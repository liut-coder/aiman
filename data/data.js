const fs = require('fs');
const path = require('path');

const fileName = 'data/list.json';
const lockFileName = 'data/list.lock';
const LOCK_WAIT_MS = 8000;
const LOCK_RETRY_MS = 50;
const LOCK_STALE_MS = 5000;
const SLEEP_BUFFER = new Int32Array(new SharedArrayBuffer(4));

function normalizeAccount(account) {
  if (account === undefined || account === null) return '';
  return String(account).trim();
}

function sleepSync(ms) {
  const timeout = Math.max(1, Number(ms) || 1);
  Atomics.wait(SLEEP_BUFFER, 0, 0, timeout);
}

function ensureParentDir(filePath) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
}

function readListUnsafe() {
  try {
    const data = fs.readFileSync(fileName, 'utf8');
    const list = JSON.parse(data);
    return Array.isArray(list) ? list : [];
  } catch (err) {
    if (err && err.code !== 'ENOENT') {
      console.log('read user data error', err);
    }
    return [];
  }
}

function writeListUnsafe(list) {
  try {
    ensureParentDir(fileName);
    const jsonString = JSON.stringify(Array.isArray(list) ? list : [], null, 2);
    fs.writeFileSync(fileName, jsonString);
  } catch (err) {
    console.log('write user data error', err);
  }
}

function clearOwnerFields(record) {
  const next = Object.assign({}, record);
  delete next.ownerInstanceId;
  delete next.ownerLabel;
  delete next.ownerHost;
  delete next.ownerPort;
  delete next.ownerPid;
  delete next.ownerProjectRoot;
  delete next.ownerLeaseMs;
  delete next.ownerLeaseUntil;
  delete next.ownerLastHeartbeatAt;
  return next;
}

function getOwnerMeta(ownerInfo, leaseMs, now) {
  const ts = Number(now) || Date.now();
  const ttl = Math.max(1000, Number(leaseMs) || 0);
  return {
    ownerInstanceId: ownerInfo.id,
    ownerLabel: ownerInfo.label,
    ownerHost: ownerInfo.host || '',
    ownerPort: ownerInfo.port || '',
    ownerPid: ownerInfo.pid || '',
    ownerProjectRoot: ownerInfo.projectRoot || '',
    ownerLeaseMs: ttl,
    ownerLeaseUntil: ts + ttl,
    ownerLastHeartbeatAt: ts
  };
}

function isLeaseActive(record, now) {
  const leaseUntil = Number(record && record.ownerLeaseUntil);
  return Boolean(record && record.ownerInstanceId && Number.isFinite(leaseUntil) && leaseUntil > (Number(now) || Date.now()));
}

function describeConflict(record, now, reason) {
  return {
    account: normalizeAccount(record && record.account),
    reason: reason || 'owned_by_other_instance',
    ownerInstanceId: record && record.ownerInstanceId ? record.ownerInstanceId : '',
    ownerLabel: record && record.ownerLabel ? record.ownerLabel : '',
    ownerLeaseUntil: record && record.ownerLeaseUntil ? record.ownerLeaseUntil : 0,
    ownerActive: isLeaseActive(record, now)
  };
}

function canMutateRecord(record, ownerId, now) {
  if (!record) return true;
  if (!record.ownerInstanceId) return true;
  if (record.ownerInstanceId === ownerId) return true;
  return !isLeaseActive(record, now);
}

function withListLock(fn) {
  ensureParentDir(lockFileName);
  const start = Date.now();
  let fd = null;

  while (!fd) {
    try {
      fd = fs.openSync(lockFileName, 'wx');
      fs.writeFileSync(fd, JSON.stringify({ pid: process.pid, lockedAt: new Date().toISOString() }));
    } catch (err) {
      if (!err || err.code !== 'EEXIST') {
        throw err;
      }

      try {
        const stat = fs.statSync(lockFileName);
        if (Date.now() - stat.mtimeMs > LOCK_STALE_MS) {
          fs.unlinkSync(lockFileName);
          continue;
        }
      } catch (statErr) {
        if (statErr && statErr.code === 'ENOENT') {
          continue;
        }
      }

      if (Date.now() - start > LOCK_WAIT_MS) {
        throw new Error('list_lock_timeout');
      }
      sleepSync(LOCK_RETRY_MS);
    }
  }

  try {
    const current = readListUnsafe();
    const result = fn(current);
    if (result && Object.prototype.hasOwnProperty.call(result, 'list')) {
      writeListUnsafe(result.list);
    }
    return result && Object.prototype.hasOwnProperty.call(result, 'value') ? result.value : result;
  } finally {
    try {
      fs.closeSync(fd);
    } catch (err) {}
    try {
      fs.unlinkSync(lockFileName);
    } catch (err) {}
  }
}

function readList() {
  return readListUnsafe();
}

function writeList(list) {
  return withListLock(() => ({
    list: Array.isArray(list) ? list : [],
    value: Array.isArray(list) ? list : []
  }));
}

function pushUserData(v) {
  return withListLock(current => {
    const account = normalizeAccount(v && v.account);
    const next = current.slice();
    const exists = next.some(item => normalizeAccount(item && item.account) === account);
    if (!exists && account) {
      next.push(v);
    }
    return { list: next, value: next };
  });
}

function upsertUserData(v) {
  return withListLock(current => {
    const account = normalizeAccount(v && v.account);
    const next = current.slice();
    const idx = next.findIndex(item => normalizeAccount(item && item.account) === account);
    if (idx >= 0) {
      next[idx] = Object.assign({}, next[idx], v);
    } else if (account) {
      next.push(v);
    }
    return { list: next, value: next };
  });
}

function upsertUserDatas(list) {
  return withListLock(current => {
    const map = {};

    current.forEach(item => {
      const account = normalizeAccount(item && item.account);
      if (!account) return;
      map[account] = Object.assign({}, item);
    });

    (Array.isArray(list) ? list : []).forEach(item => {
      const account = normalizeAccount(item && item.account);
      if (!account) return;
      map[account] = Object.assign({}, map[account] || {}, item);
    });

    const next = Object.keys(map).map(account => map[account]);
    return { list: next, value: next };
  });
}

function getUserDatas() {
  return readList();
}

function getOwnedUserDatas(ownerId) {
  return readList().filter(item => item && item.ownerInstanceId === ownerId);
}

function removeUserDatas() {
  return writeList([]);
}

function removeUserAccounts(accounts) {
  return withListLock(current => {
    const removeSet = new Set((Array.isArray(accounts) ? accounts : []).map(normalizeAccount).filter(Boolean));
    const next = current.filter(item => !removeSet.has(normalizeAccount(item && item.account)));
    return { list: next, value: next };
  });
}

function removeOwnedUserAccounts(accounts, ownerId) {
  return withListLock(current => {
    const now = Date.now();
    const targetSet = new Set((Array.isArray(accounts) ? accounts : []).map(normalizeAccount).filter(Boolean));
    const removed = [];
    const conflicts = [];
    const next = [];

    current.forEach(item => {
      const account = normalizeAccount(item && item.account);
      if (!targetSet.has(account)) {
        next.push(item);
        return;
      }

      if (!canMutateRecord(item, ownerId, now)) {
        conflicts.push(describeConflict(item, now, 'owned_by_other_instance'));
        next.push(item);
        return;
      }

      removed.push(account);
    });

    return { list: next, value: { removed, conflicts, userDatas: next } };
  });
}

function writeUserData(list) {
  return writeList(list);
}

function claimUserAccounts(accounts, ownerInfo, leaseMs) {
  return withListLock(current => {
    const now = Date.now();
    const ownerMeta = getOwnerMeta(ownerInfo, leaseMs, now);
    const targetSet = new Set((Array.isArray(accounts) ? accounts : []).map(normalizeAccount).filter(Boolean));
    const claimed = [];
    const conflicts = [];
    const next = current.map(item => {
      const account = normalizeAccount(item && item.account);
      if (!targetSet.has(account)) {
        return item;
      }

      if (!canMutateRecord(item, ownerInfo.id, now)) {
        conflicts.push(describeConflict(item, now, 'owned_by_other_instance'));
        return item;
      }

      claimed.push(account);
      return Object.assign({}, item, ownerMeta);
    });

    targetSet.forEach(account => {
      const exists = next.some(item => normalizeAccount(item && item.account) === account);
      if (!exists) {
        conflicts.push({
          account,
          reason: 'account_not_found',
          ownerInstanceId: '',
          ownerLabel: '',
          ownerLeaseUntil: 0,
          ownerActive: false
        });
      }
    });

    return { list: next, value: { claimed, conflicts, userDatas: next } };
  });
}

function upsertOwnedUserDatas(list, ownerInfo, leaseMs) {
  return withListLock(current => {
    const now = Date.now();
    const ownerMeta = getOwnerMeta(ownerInfo, leaseMs, now);
    const map = {};
    const conflicts = [];
    const saved = [];

    current.forEach(item => {
      const account = normalizeAccount(item && item.account);
      if (!account) return;
      map[account] = Object.assign({}, item);
    });

    (Array.isArray(list) ? list : []).forEach(item => {
      const account = normalizeAccount(item && item.account);
      if (!account) return;

      const existing = map[account];
      if (!canMutateRecord(existing, ownerInfo.id, now)) {
        conflicts.push(describeConflict(existing, now, 'owned_by_other_instance'));
        return;
      }

      map[account] = Object.assign({}, existing || {}, clearOwnerFields(item), ownerMeta);
      saved.push(account);
    });

    const next = Object.keys(map).map(account => map[account]);
    return { list: next, value: { saved, conflicts, userDatas: next } };
  });
}

function renewOwnedUserAccounts(ownerInfo, leaseMs, accounts) {
  return withListLock(current => {
    const now = Date.now();
    const ownerMeta = getOwnerMeta(ownerInfo, leaseMs, now);
    const targetSet = Array.isArray(accounts) && accounts.length
      ? new Set(accounts.map(normalizeAccount).filter(Boolean))
      : null;
    const renewed = [];

    const next = current.map(item => {
      if (!item || item.ownerInstanceId !== ownerInfo.id) {
        return item;
      }

      const account = normalizeAccount(item.account);
      if (targetSet && !targetSet.has(account)) {
        return item;
      }

      renewed.push(account);
      return Object.assign({}, item, ownerMeta);
    });

    return { list: next, value: { renewed, userDatas: next } };
  });
}

function releaseUserAccounts(accounts, ownerId) {
  return withListLock(current => {
    const targetSet = Array.isArray(accounts) && accounts.length
      ? new Set(accounts.map(normalizeAccount).filter(Boolean))
      : null;
    const released = [];

    const next = current.map(item => {
      if (!item || item.ownerInstanceId !== ownerId) {
        return item;
      }

      const account = normalizeAccount(item.account);
      if (targetSet && !targetSet.has(account)) {
        return item;
      }

      released.push(account);
      return clearOwnerFields(item);
    });

    return { list: next, value: { released, userDatas: next } };
  });
}

module.exports = {
  get userDatas() {
    return readList();
  },
  claimUserAccounts,
  getOwnedUserDatas,
  getUserDatas,
  isLeaseActive,
  pushUserData,
  releaseUserAccounts,
  removeOwnedUserAccounts,
  removeUserAccounts,
  removeUserDatas,
  renewOwnedUserAccounts,
  upsertOwnedUserDatas,
  upsertUserData,
  upsertUserDatas,
  writeUserData
};
