// main.js
// Created by chenyq Jul/14/2015

iconv = require("./node_modules/iconv-lite");
var repl = require("repl");
var cfg = require("./cfg.js");
var Client = require("./client.js");
var log = require("./lib/log.js").create(cfg.logPath, "main");
var os = require("os");
var tradingCfg = require("./trading_cfg.js");
var Const = require("./Const.js");
var mgr = require("./mgr.js");
var TestClient = require("./testclient.js");

const crypto = require('crypto');
const path = require('path');
const chatCorpus = require('./lib/chatCorpus');
const {
  claimUserAccounts,
  getOwnedUserDatas,
  getUserDatas,
  isLeaseActive,
  releaseUserAccounts,
  removeOwnedUserAccounts,
  renewOwnedUserAccounts,
  upsertOwnedUserDatas,
  upsertUserDatas,
} = require('./data/data');

const HTTP_PORT = Number(process.env.HTTP_PORT || cfg.http_port);
const INSTANCE_LEASE_MS = Math.max(30000, Number(process.env.INSTANCE_LEASE_MS || 120000));
const INSTANCE_HEARTBEAT_MS = Math.max(5000, Number(process.env.INSTANCE_HEARTBEAT_MS || 15000));
const INSTANCE_HOST = os.hostname();
const INSTANCE_ROOT = path.resolve(__dirname);
const INSTANCE_HASH = crypto
  .createHash('md5')
  .update(`${INSTANCE_HOST}|${HTTP_PORT}|${INSTANCE_ROOT}`)
  .digest('hex')
  .slice(0, 8);
const INSTANCE_INFO = {
  id: `${INSTANCE_HOST}:${HTTP_PORT}:${INSTANCE_HASH}`,
  label: `${INSTANCE_HOST}:${HTTP_PORT}`,
  host: INSTANCE_HOST,
  port: HTTP_PORT,
  pid: process.pid,
  projectRoot: INSTANCE_ROOT,
  startedAt: new Date().toISOString()
};

let allConnectData = 0
let connectAAAData = 0
let connectGsData = 0
let lostConnectData = 0

// 捕捉异常
// cyq process.on('uncaughtException', log.exception.bind(log));

//批量写入config
setConfigObj = (updates) => {
  // 应用更新
  for (const key in updates) {
    cfg.db.set(key, updates[key]).write();
  }
}

// 只初始化缺失配置，避免每次启动覆盖后台修改的配置
setDefaultConfigObj = (defaults) => {
  for (const key in defaults) {
    if (cfg.db.get(key).value() === undefined) {
      cfg.db.set(key, defaults[key]).write();
    }
  }
}

//写入config
setConfig = (key,value) => {
  cfg.db.set(key, value).write();
}

//根据key读取config
getConfig = (key) => {
  let val = cfg.db.get(key).value()
  // console.log(val);
  return val
}

//获取全部配置config
getConfigAll = () => {
  let val = cfg.db.read()
  // console.log(val);
  return val
}

//将默认配置信息写入config.json
setDefaultConfigObj({
  "users_prefix": cfg.users_prefix,
  "users_index_num": cfg.users_index_num,
  "users_pass": cfg.users_pass,
  "instance_lock_enabled": 0,
  "mail_name": cfg.mail_name,
  "mail_equip": cfg.mail_equip,
  "mail_pet": cfg.mail_pet,
  "War_pet": cfg.War_pet,
  "Ride_pet": cfg.Ride_pet,
  "equip_fly": cfg.equip_fly,
  "vip_type": cfg.vip_type,
  "world_Team": cfg.world_Team,
  "world_chat": cfg.world_chat,
  "prompt": [
    "帐号前缀",
    "帐号位数",
    "帐号的密码",
    "经验邮件名称",
    "装备邮件名称",
    "宠物邮件名称",
    "设置参战宠物名称",
    "设置乘骑坐骑名称",
    "设置使用飞行法宝名称",
    "购买会员类型，：1：月卡。2：季卡，3：年卡",
    "组队喊话关键词",
    "自动喊话词"
  ],
})

// account --> Client
clients = {};
cfg.loadNames();

// users_prefix = cfg.users_prefix;
users_prefix = getConfig("users_prefix");
users_index_num = getConfig('users_index_num');
users_start = cfg.users_start;
users_end = cfg.users_end;
users_pass = getConfig('users_pass');

stallStat = {}; // 测试摆摊统计信息
goldStallStat = {}; // 金元宝交易统计信息
auctionStat = {}; // 拍卖系统统计信息
tradingStat = {}; // 聚宝斋系统统计信息

if (null != process.argv[2]) {
  users_prefix = process.argv[2];
} else {
  // users_prefix = cfg.users_prefix;
  users_prefix = getConfig("users_prefix");
}

if (null != process.argv[3]) {
  users_index_num = parseInt(process.argv[3]);
} else {
  // users_index_num = cfg.users_index_num;
  users_index_num = getConfig('users_index_num');
}

if (null != process.argv[4]) {
  users_start = parseInt(process.argv[4]);
} else {
  users_start = cfg.users_start;
}

if (null != process.argv[5]) {
  users_end = parseInt(process.argv[5]);
} else {
  users_end = cfg.users_end;
}

if (null != process.argv[6]) {
  users_pass = process.argv[6];
} else {
  // users_pass = cfg.users_pass;
  users_pass = getConfig('users_pass');
}

// 给数字前补0
prefixInteger = function(num, n) {
  return (Array(Number(n)).join(0) + num).slice(-n);
};

// 所有人领取邮件
receiveAllMail = function(type) {
  for (var key in clients) {
    var client = clients[key];
    for (let i = 0; i < client.me.allMailInfo.length; i++) {
      var allMailInfoElement = client.me.allMailInfo[i];
      if(allMailInfoElement.title === type){
        client.me.receiveMailAtta(client.me.allMailInfo[i].id);
      }

    }

  }
};


// 所有账号购买会员
allClientBuyVip = function(type) {

  for (var key in clients) {
    var client = clients[key];
    client.me.buyVip(type)
  }
};
// 获取帐号名
getAccount = function(index) {
  if (users_start > index || users_end < index) {
    return "";
  }

  // return "110001" + users_prefix + prefixInteger(index, users_index_num);
  return "110001" + getConfig("users_prefix") + prefixInteger(index, getConfig('users_index_num'));
};

getAccountNum = function(index,num) {
  if (users_start > index || num < index) {
    return "";
  }
  // return "110001" + users_prefix + prefixInteger(index, users_index_num);
  return "110001" + getConfig("users_prefix") + prefixInteger(index, getConfig('users_index_num'));
};

generateAccountName = function(index, prefix, indexNum) {
  return "110001" + prefix + prefixInteger(index, indexNum);
};

normalizeAccount = function(account) {
  if (account === undefined || account === null) return "";
  let value = String(account).trim();
  if (!value) return "";
  value = value.replace(/\s+/g, "");
  if (!value.startsWith("110001")) {
    value = "110001" + value;
  }
  return value;
};

const DEFAULT_CHAR_NAME_MODE = 'cn_random';
const DEFAULT_CHAR_GENDER_MODE = 'account_parity';

normalizeCharNameMode = function(mode) {
  return mode === 'gender_pool' ? 'gender_pool' : DEFAULT_CHAR_NAME_MODE;
};

normalizeCharGenderMode = function(mode) {
  return ['account_parity', 'random', 'male', 'female'].includes(mode)
    ? mode
    : DEFAULT_CHAR_GENDER_MODE;
};

buildCharacterProfile = function(source) {
  const data = source || {};
  return {
    charNameMode: normalizeCharNameMode(data.charNameMode || data.nameMode),
    charGenderMode: normalizeCharGenderMode(data.charGenderMode || data.genderMode)
  };
};

findUserRecordByAccount = function(account) {
  const normalized = normalizeAccount(account);
  if (!normalized) return null;

  return getUserDatas().find(item => normalizeAccount(item.account) === normalized) || null;
};

syncClientCharacterProfile = function(client, account) {
  if (!client || typeof client.setCharacterProfile !== 'function') {
    return client;
  }

  const record = findUserRecordByAccount(account);
  const profile = buildCharacterProfile(record || {});
  client.setCharacterProfile({
    nameMode: profile.charNameMode,
    genderMode: profile.charGenderMode
  });
  return client;
};

ensureClient = function(account) {
  account = normalizeAccount(account);
  if (!account) return null;

  if (!clients[account]) {
    var pass = getConfig('users_pass');
    var client = Client.create(Const.CONNECT_TYPE.NORMAL);
    client.setAAA(cfg.host, cfg.port);
    client.setAccount(account, pass);
    clients[account] = client;
  }

  syncClientCharacterProfile(clients[account], account);
  return clients[account];
};

getClientStatusLabel = function(account) {
  const status = checkClientStatusObject(account);
  if (!status) {
    return {
      aaa: '未连接',
      gs: '未连接'
    };
  }
  return status;
};

getClientRuntimeSnapshot = function(account) {
  const client = clients[normalizeAccount(account)];
  if (!client || !client.me) {
    return {};
  }

  const me = client.me;
  const data = me.data || {};
  const level = Number.isFinite(Number(data.level)) ? Number(data.level) : '';
  const mapName = typeof me.getCurrentMapName === 'function' ? (me.getCurrentMapName() || '') : '';

  return {
    roleName: data.name || '',
    level: level,
    mapName: mapName,
    serverName: data.serverName || '',
    chatScene: me.instruction && me.instruction.type ? me.instruction.type : ''
  };
};

buildUserRecord = function(account, index, extra) {
  const status = getClientStatusLabel(account);
  const record = Object.assign({
    account: account,
    index: index,
    aaa: status.aaa,
    gs: status.gs,
    roleName: '',
    level: '',
    mapName: '',
    serverName: '',
    chatScene: '',
    charNameMode: DEFAULT_CHAR_NAME_MODE,
    charGenderMode: DEFAULT_CHAR_GENDER_MODE
  }, extra || {});
  const profile = buildCharacterProfile(record);
  record.charNameMode = profile.charNameMode;
  record.charGenderMode = profile.charGenderMode;
  return record;
};

isInstanceLockEnabled = function() {
  const value = getConfig('instance_lock_enabled');
  if (typeof value === 'string') {
    const normalized = value.trim().toLowerCase();
    return !['0', 'false', 'off', 'disabled', 'no'].includes(normalized);
  }
  return value !== 0 && value !== false;
};

formatLeaseTime = function(timestamp) {
  const value = Number(timestamp);
  if (!Number.isFinite(value) || value <= 0) return '';
  return new Date(value).toLocaleString('zh-CN', { hour12: false });
};

buildOwnershipView = function(record) {
  const lockEnabled = isInstanceLockEnabled();
  const ownerInstanceId = record && record.ownerInstanceId ? record.ownerInstanceId : '';
  const ownerLabel = record && record.ownerLabel ? record.ownerLabel : '';
  const ownerLeaseUntil = Number(record && record.ownerLeaseUntil) || 0;
  const ownerActive = lockEnabled ? isLeaseActive(record) : false;
  const ownedByCurrentInstance = Boolean(ownerInstanceId) && ownerInstanceId === INSTANCE_INFO.id;

  let ownerStatusLabel = lockEnabled ? '未归属' : '锁已关闭';
  if (lockEnabled) {
    if (ownedByCurrentInstance) {
      ownerStatusLabel = '当前实例';
    } else if (ownerInstanceId) {
      ownerStatusLabel = ownerActive ? `已锁定 ${ownerLabel || '其他实例'}` : `锁已过期 ${ownerLabel || '其他实例'}`;
    }
  }

  return {
    instanceLockEnabled: lockEnabled,
    ownerInstanceId,
    ownerLabel,
    ownerLeaseUntil,
    ownerLeaseUntilLabel: formatLeaseTime(ownerLeaseUntil),
    ownerActive,
    ownedByCurrentInstance,
    ownerStatusLabel
  };
};

enrichUserRecordOwnership = function(record) {
  return Object.assign({}, record, buildOwnershipView(record));
};

normalizeAccountList = function(accounts) {
  const unique = new Set();
  (Array.isArray(accounts) ? accounts : []).forEach(account => {
    const normalized = normalizeAccount(account);
    if (normalized) unique.add(normalized);
  });
  return Array.from(unique);
};

buildActionMessage = function(actionLabel, successCount, conflicts, skippedCount) {
  const done = Number(successCount) || 0;
  const blocked = Array.isArray(conflicts) ? conflicts.length : 0;
  const skipped = Number(skippedCount) || 0;
  const parts = [`${actionLabel} ${done} 个账号`];

  if (blocked) {
    parts.push(`被其他实例占用 ${blocked} 个`);
  }
  if (skipped) {
    parts.push(`其余跳过 ${skipped} 个`);
  }

  return parts.join('，');
};

getOwnedAccountsForCurrentInstance = function() {
  return getOwnedUserDatas(INSTANCE_INFO.id).map(item => normalizeAccount(item && item.account)).filter(Boolean);
};

claimAccountsForCurrentInstance = function(accounts) {
  const normalized = normalizeAccountList(accounts);
  if (!isInstanceLockEnabled()) {
    return {
      claimed: normalized,
      conflicts: [],
      userDatas: getUserDatas()
    };
  }
  return claimUserAccounts(normalized, INSTANCE_INFO, INSTANCE_LEASE_MS);
};

upsertAccountsForCurrentInstance = function(records) {
  if (!isInstanceLockEnabled()) {
    return {
      saved: normalizeAccountList((Array.isArray(records) ? records : []).map(item => item && item.account)),
      conflicts: [],
      userDatas: upsertUserDatas(records)
    };
  }
  return upsertOwnedUserDatas(records, INSTANCE_INFO, INSTANCE_LEASE_MS);
};

renewCurrentInstanceOwnership = function(accounts) {
  if (!isInstanceLockEnabled()) {
    return { renewed: [], userDatas: getUserDatas() };
  }
  return renewOwnedUserAccounts(INSTANCE_INFO, INSTANCE_LEASE_MS, normalizeAccountList(accounts));
};

releaseCurrentInstanceOwnership = function(accounts) {
  return releaseUserAccounts(normalizeAccountList(accounts), INSTANCE_INFO.id);
};

generateBatchAccounts = function(startIndex, count, prefix, indexNum) {
  const result = [];
  for (let i = 0; i < count; i++) {
    const index = startIndex + i;
    result.push({
      account: generateAccountName(index, prefix, indexNum),
      index: index
    });
  }
  return result;
};

parseAccountText = function(rawText) {
  if (!rawText) return [];

  const unique = new Set();
  String(rawText)
    .split(/[\r\n,，;\s]+/)
    .map(item => normalizeAccount(item))
    .filter(Boolean)
    .forEach(item => unique.add(item));

  return Array.from(unique);
};

loginAccounts = function(accounts) {
  const normalized = normalizeAccountList(accounts);
  const claimResult = claimAccountsForCurrentInstance(normalized);
  const logged = [];
  const skipped = [];

  claimResult.claimed.forEach(account => {
    const client = ensureClient(account);
    if (!client) {
      skipped.push({ account, reason: 'client_create_failed' });
      return;
    }
    client.login();
    logged.push(client.account);
  });

  return {
    accounts: logged,
    conflicts: claimResult.conflicts,
    skipped,
    message: buildActionMessage('已触发登录', logged.length, claimResult.conflicts, skipped.length)
  };
};

logoutAccounts = function(accounts) {
  const normalized = normalizeAccountList(accounts);
  const claimResult = claimAccountsForCurrentInstance(normalized);
  const loggedOut = [];
  const skipped = [];

  claimResult.claimed.forEach(account => {
    const ok = logoutSingleAccount(account);
    if (ok) {
      loggedOut.push(account);
      return;
    }
    skipped.push({ account, reason: 'client_not_found' });
  });

  return {
    accounts: loggedOut,
    conflicts: claimResult.conflicts,
    skipped,
    message: buildActionMessage('已触发退出', loggedOut.length, claimResult.conflicts, skipped.length)
  };
};

prepareFinishedClient = function(account) {
  const client = clients[normalizeAccount(account)];
  if (!client || !client.getGs()) {
    return { account: normalizeAccount(account), ok: false, reason: 'not_connected' };
  }

  client.me.receiveCurrentMail(getConfig('mail_pet'));
  client.me.receiveCurrentMail(getConfig('mail_name'));
  client.me.receiveCurrentMail(getConfig('mail_equip'));
  client.me.buyVip(getConfig('vip_type'));

  for (var petId in client.me.pets) {
    var pet = client.me.pets[petId];
    if (getConfig('War_pet') == pet.name) {
      client.me.con.sendCmd("CMD_SELECT_CURRENT_PET", { id: pet.id, pet_status: 1 });
      client.me.con.sendCmd("CMD_SET_RECOMMEND_ATTRIB", { petId: pet.id, con: 0, wiz: 0, str: 4, dex: 0 });
    }
    if (getConfig('Ride_pet') == pet.name) {
      client.me.con.sendCmd("CMD_SELECT_CURRENT_MOUNT", { petId: pet.id });
    }
  }

  for (var pos in client.me.items) {
    var item = client.me.items[pos];
    if (!item || item.pos < 41) continue;
    if (getConfig('equip_fly') == item.name) {
      client.me.con.sendCmd('CMD_EQUIP', { pos: item.pos, equip_part: 40 });
    }
  }

  return { account: normalizeAccount(account), ok: true };
};

prepareFinishedAccounts = function(accounts) {
  const normalized = normalizeAccountList(accounts);
  const claimResult = claimAccountsForCurrentInstance(normalized);
  const result = claimResult.claimed.map(account => prepareFinishedClient(account));
  const skipped = result.filter(item => !item.ok);

  return {
    result,
    conflicts: claimResult.conflicts,
    skipped,
    message: buildActionMessage(
      '已触发成品准备',
      result.filter(item => item.ok).length,
      claimResult.conflicts,
      skipped.length
    )
  };
};

runXiangyaoAccounts = function(accounts) {
  const normalized = normalizeAccountList(accounts);
  const claimResult = claimAccountsForCurrentInstance(normalized);
  const list = [];
  const skipped = [];

  claimResult.claimed.forEach(account => {
    const client = clients[account];
    if (!client || !client.getGs()) {
      skipped.push({ account, reason: 'not_connected' });
      return;
    }
    client.me.GoXiangYao();
    list.push(account);
  });

  return {
    accounts: list,
    conflicts: claimResult.conflicts,
    skipped,
    message: buildActionMessage('已触发降妖', list.length, claimResult.conflicts, skipped.length)
  };
};

// 创建所有的客户端
createClinet = function() {
  var count = 0;
  for (var i = users_start; i <= users_end; ++i) {
    var account = getAccount(i);
    console.log("create Client : " + account);
    if ("" == account) continue;

    // var pass = users_pass;
    var pass = getConfig('users_pass');
    var client = Client.create(Const.CONNECT_TYPE.NORMAL);
    client.setAAA(cfg.host, cfg.port);
    client.setAccount(account, pass);
    clients[account] = client;
    count++;
  }

  console.log("create Client complete totle : \n" + count);
};

// 创建所有的客户端
let stratNum = 1
createClinetNum = function(num) {
  var count = 0;
  const records = [];
  for (var i = stratNum; i < stratNum+Number(num); ++i) {
    console.log('i',i,'  num',num)
    // var account = getAccountNum(i,num);
    var account = getAccountNum(i,stratNum+Number(num));
    console.log("create Client : " + account);
    if ("" == account) continue;

    // var pass = users_pass;
    var pass = getConfig('users_pass');
    var client = Client.create(Const.CONNECT_TYPE.NORMAL);
    client.setAAA(cfg.host, cfg.port);
    client.setAccount(account, pass);
    clients[account] = client;
    count++;
    //获取状态
    const status = checkClientStatusObject(account)
    records.push({
      account: account,
      index: i,
      aaa: status.aaa,
      gs: status.gs
    })
  }
  if (records.length) {
    upsertAccountsForCurrentInstance(records);
  }
  stratNum = stratNum + Number(num)

  console.log("create Client complete totle : \n" + count);
};

//创建并登录单个账号
createLoginClinet = function (username) {
  return loginAccounts([username]);
}

// 登陆所有的帐号，直接登陆，登陆失败的在Client内部自行处理
loginAllClient = function() {
  this.loginAllTime = os.uptime();
  const knownAccounts = new Set();

  for (var key in clients) {
    knownAccounts.add(normalizeAccount(key));
  }

  getUserDatas().forEach(item => {
    const account = normalizeAccount(item && item.account);
    if (account) knownAccounts.add(account);
  });

  const ownedAccounts = getOwnedAccountsForCurrentInstance();
  ownedAccounts.forEach(account => knownAccounts.add(account));

  return loginAccounts(Array.from(knownAccounts));
};

//登录列表中的所有账号
loginListClient = function (list) {
  const accounts = (Array.isArray(list) ? list : []).map(item => item && item.account);
  return loginAccounts(accounts);
}

// 创建并登录所有账号
// let stratNum = 1
createLoginAllClinetNum = function(num) {
  var count = 0;
  const records = [];
  for (var i = stratNum; i < stratNum+Number(num); ++i) {
    console.log('i',i,'  num',num)
    // var account = getAccountNum(i,num);
    var account = getAccountNum(i,stratNum+Number(num));
    console.log("create Client : " + account);
    if ("" == account) continue;

    // var pass = users_pass;
    var pass = getConfig('users_pass');
    var client = Client.create(Const.CONNECT_TYPE.NORMAL);
    client.setAAA(cfg.host, cfg.port);
    client.setAccount(account, pass);
    clients[account] = client;
    count++;
    //获取状态
    const status = checkClientStatusObject(account)
    records.push({
      account: account,
      index: i,
      aaa: status.aaa,
      gs: status.gs
    })
  }
  if (records.length) {
    upsertAccountsForCurrentInstance(records);
    loginAccounts(records.map(item => item.account));
  }
  stratNum = stratNum + Number(num)

  console.log("create Client complete totle : \n" + count);
};

createBatchUserRecords = function(options) {
  const startIndex = Number(options.startIndex || 1);
  const count = Number(options.count || 0);
  const prefix = String(options.prefix || getConfig('users_prefix') || '').trim();
  const indexNum = Number(options.indexNum || getConfig('users_index_num') || 4);
  const autoLogin = options.autoLogin === true;
  const charNameMode = normalizeCharNameMode(options.charNameMode);
  const charGenderMode = normalizeCharGenderMode(options.charGenderMode);

  if (!prefix) {
    return { created: [], message: 'prefix_required' };
  }
  if (!Number.isFinite(count) || count <= 0) {
    return { created: [], message: 'count_invalid' };
  }
  if (!Number.isFinite(startIndex) || startIndex <= 0) {
    return { created: [], message: 'start_index_invalid' };
  }

  const accounts = generateBatchAccounts(startIndex, count, prefix, indexNum);
  const records = accounts.map(item => buildUserRecord(item.account, item.index, {
    source: 'batch_generate',
    charNameMode: charNameMode,
    charGenderMode: charGenderMode
  }));

  const savedResult = upsertAccountsForCurrentInstance(records);
  const created = records.filter(item => savedResult.saved.includes(item.account));
  let loginResult = null;

  if (autoLogin && created.length) {
    loginResult = loginAccounts(created.map(item => item.account));
  }

  return {
    created,
    conflicts: savedResult.conflicts,
    loginResult,
    message: savedResult.conflicts.length ? 'partial_conflict' : 'ok'
  };
};

importUserAccounts = function(options) {
  const accounts = parseAccountText(options.accountsText);
  const autoLogin = options.autoLogin === true;
  const baseIndex = Number(options.startIndex || 1);

  if (!accounts.length) {
    return { created: [], message: 'accounts_empty' };
  }
  if (!Number.isFinite(baseIndex) || baseIndex <= 0) {
    return { created: [], message: 'start_index_invalid' };
  }

  const records = accounts.map((account, idx) =>
    buildUserRecord(account, baseIndex + idx, { source: 'manual_import' })
  );

  const savedResult = upsertAccountsForCurrentInstance(records);
  const created = records.filter(item => savedResult.saved.includes(item.account));
  let loginResult = null;

  if (autoLogin && created.length) {
    loginResult = loginAccounts(created.map(item => item.account));
  }

  return {
    created,
    conflicts: savedResult.conflicts,
    loginResult,
    message: savedResult.conflicts.length ? 'partial_conflict' : 'ok'
  };
};

beginAutoWalkByIdx = function(mapId, x, y, idx) {
  var account = getAccount(idx);
  if ("" == account) return;

  clients[account].me.beginAutoWalk(mapId, x, y);

  //setTimeout(function(){
  beginAutoWalkByIdx(mapId, x, y, idx + 1);
  //}, 500);
};

// 地图中自动寻路到某一坐标
beginAutoWalkAll = function(mapId, x, y) {
  beginAutoWalkByIdx(mapId, x, y, users_start);
};

function autoWalkByIdx(mapId, idx) {
  var account = getAccount(idx);
  if ("" == account) return;

  clients[account].me.autoWalk(mapId);

  setTimeout(function() {
    autoWalkByIdx(mapId, idx + 1);
  }, 500);
}

// 开始自动走路
autoWalkAll = function(mapId) {
  autoWalkByIdx(mapId, users_start);
};

startSendRecvTest = function(num) {
  for (var key in clients) {
    var client = clients[key];
    client.me.startSendRecvTest(num);
    break;
  }
};

// 停止自动走路
stopAutoWalkAll = function() {
  for (var key in clients) {
    var client = clients[key];
    client.me.stopAutoWalk();
  }
};

// 所有玩家退出游戏
logoutAll = function() {
  var i = 0;
  for (var key in clients) {
    var client = clients[key];
    client.logout();
  }
};

//退出指定账号
logoutSingleAccount = function(account) {
  var client = clients[account];
  if (!client){
    return false
  }
  client.logout();
  return true
}

// 去降妖
allXiangYao = function() {
  for (var key in clients) {
    var client = clients[key];
    client.me.GoXiangYao();
  }
};
// 随机换线
switchServerAll = function(num) {
  for (var key in clients) {
    var client = clients[key];
    client.me.randomSwitchServer(num);
  }
};

// 进入天墉城同一个点
teleportTest = function(num) {
  if (--num <= 0) return;

  if (num % 2) {
    for (var key in clients) {
      var client = clients[key];
      client.me.enterMapEx(5000, 95, 64);
    }
  } else {
    for (var key in clients) {
      var client = clients[key];
      client.me.enterMapEx(2000, 34, 28);
    }
  }

  setTimeout(function() {
    teleportTest(num);
  }, 1000);
};

// 设置自动战斗
setAutoFightAll = function(autoFight) {
  for (var key in clients) {
    var client = clients[key];
    client.me.sendAutoFight(autoFight);
  }
};

// 设置自动战斗（type为0表示准备数据和环境，type为1表示自动战斗）
autoCombatTest = function(type) {
  for (var key in clients) {
    var client = clients[key];
    client.me.autoCombatTest(type);
  }
};

// 取map大小
getMapLength = function(map) {
  var length = 0;
  for (var key in map) length++;
  return length;
};

// 随机分布在出生点
randomBirthPos = function() {
  for (var key in clients) {
    var client = clients[key];
    client.me.randomBirthPos();
  }
};

// 地图中随机行走
randomWalkInMap = function(mapId) {
  for (var key in clients) {
    var client = clients[key];
    client.me.randomWalkInMap(mapId);
  }
};

// 设置是否显示较多玩家
setShowMoreUsersAll = function(showMore) {
  for (var key in clients) {
    var client = clients[key];
    client.me.setShowMoreUsers(showMore);
  }
};

// 开关消息打印
setDebugOn = function(flag) {
  for (var key in clients) {
    var client = clients[key];
    client.setDebugOn(flag);
  }
};

// 发送聊天栏测试命令
sendTestCmd = function(testCmd) {
  for (var key in clients) {
    var client = clients[key];
    client.me.sendChatEx(testCmd);
  }
};

// 自动聊天
autoChannelTest = function(num) {
  if (--num < 0) return;

  for (var key in clients) {
    var client = clients[key];

    setTimeout(client.me.sendChatEx.bind(client.me, "11111" + num + "_" + key), Math.random() * 6000);
  }

  setTimeout(function() {
    autoChannelTest(num);
  }, 6000);
};

// 模拟玩家行走等行为
simulateWalking = function(interval) {
  var account = getAccount(users_start);
  if ("" == account) return;

  clients[account].me.simulateWalking();

  // 一段时间后启动下一个玩家
  setTimeout(function() {
    nextSimulateWalking(users_start + 1, interval);
  }, interval * 1000);
};

nextSimulateWalking = function(index, interval) {
  var account = getAccount(index);
  if ("" == account) return;

  clients[account].me.simulateWalking();

  // 一段时间后启动下一个玩家
  setTimeout(function() {
    nextSimulateWalking(index + 1, interval);
  }, interval * 1000);
};

// 行走到李总兵身边
walkToLiZongbing = function() {
  for (var key in clients) {
    var client = clients[key];
    client.me.walkToLiZongbing();
  }
};

// 作为队员开始匹配
teamMatchMember = function(type) {
  for (var key in clients) {
    var client = clients[key];
    client.me.teamMatchMember(type);
  }
};

// 作为队伍开始匹配
teamMatchTeam = function(type) {
  for (var key in clients) {
    var client = clients[key];
    client.me.teamMatchTeam(type);
  }
};

// 结束进程
exit = function() {
  try {
    releaseCurrentInstanceOwnership();
  } catch (error) {
    console.log('release ownership on exit error', error);
  }
  process.exit();
};

// 检查连接
checkConnections = function() {
  var connectAAA = 0;
  var connectGs = 0;
  var lostConnect = 0;
  var allConnect = 0;

  for (var key in clients) {
    var client = clients[key];
    if (client.getAAA() && client.getGs()) {
      allConnect++;
    } else if (client.getAAA()) {
      connectAAA++;
    } else if (client.getGs()) {
      connectGs++;
    } else {
      lostConnect++;
    }
  }

  // console.log("[allConnect] " + allConnect);
  // console.log("[connectAAA] " + connectAAA);
  // console.log("[connectGs] " + connectGs);
  // console.log("[lostConnect] " + lostConnect);

  allConnectData = allConnect
  connectAAAData = connectAAA
  connectGsData = connectGs
  lostConnectData = lostConnect
};

traceConnections = function(type) {
  for (var key in clients) {
    var client = clients[key];
    if ("lost" == type) {
      if (!client.getAAA() && !client.getGs()) {
        console.log("[account] " + key);
      }
    } else if ("aaa" == type) {
      if (client.getAAA()) {
        console.log("[account] " + key);
      }
    } else if ("gs" == type) {
      if (client.getGs()) {
        console.log("[account] " + key);
      }
    }
  }
};

// 检查连接状态
checkClientStatus = function(account) {
  var client = clients[account];
  if (null == client) {
    console.log("[" + account + "] client not exit !");
    return;
  }

  if (client.getAAA()) console.log("[" + account + "] aaa connected !");
  else console.log("[" + account + "] aaa not connected !");

  if (client.getGs()) console.log("[" + account + "] gs connected !");
  else console.log("[" + account + "] gs not connected !");
};

// 获取账号连接状态
checkClientStatusObject = function(account) {
  var client = clients[account];
  if (null == client) {
    return;
  }

  let obj = {aaa: '',gs: ''}

  if (client.getAAA()) {
    // console.log("[" + account + "] aaa connected !")
    obj.aaa = '已连接';
  }
  else {
    // console.log("[" + account + "] aaa not connected !");
    obj.aaa = '未连接';
  }

  if (client.getGs()) {
    // console.log("[" + account + "] gs connected !");
    obj.gs = '连接';
  }
  else {
    // console.log("[" + account + "] gs not connected !");
    obj.gs = '未连接';
  }
  return obj
};

// 输出所有的连接
printAllClientStatus = function() {
  for (var key in clients) {
    checkClientStatus(key);
  }
};

// 摆摊上架
stallPutAwayGoods = function(put_one) {
  var now = os.uptime();

  // 初始化统计信息
  stallStat.putAwayGoods = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    count: 0, // 请求次数
    okCount: 0, // 成功次数
    maxTime: 0 // 单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.stallPutAwayGoods(0, stallStat.putAwayGoods, put_one);
  }
};

// 摆摊下架
stallRemoveGoods = function(remove_one) {
  var now = os.uptime();

  // 初始化统计信息
  stallStat.removeGoods = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    count: 0, // 请求次数
    okCount: 0, // 成功次数
    maxTime: 0 // 单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.stallRemoveGoods(0, stallStat.removeGoods, remove_one);
  }
};

// 摆摊搜索
stallSearchGoods = function() {
  var now = os.uptime();

  // 初始化统计信息
  stallStat.searchGoods = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    count: 0, // 请求次数
    okCount: 0, // 成功次数
    maxTime: 0 // 单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.stallSearchGoods(stallStat.searchGoods);
  }
};

// 摆摊购买
stallBuyGoods = function() {
  var now = os.uptime();

  // 初始化统计信息
  stallStat.buyGoods = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    reqCount: 0, // 请求数据次数
    reqOkCount: 0, // 请求数据成功次数
    buyCount: 0, // 请求购买次数
    buyOkCount: 0, // 请求购买成功次数
    reqMaxTime: 0, // 请求数据单次最长时间
    buyMaxTime: 0 // 请求购买单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.stallBuyGoods(stallStat.buyGoods, true);
  }
};

// 摆摊提款
stallTakeCash = function() {
  var now = os.uptime();

  // 初始化统计信息
  stallStat.takeCash = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    count: 0, // 请求次数
    okCount: 0, // 成功次数
    maxTime: 0 // 单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.stallTakeCash(stallStat.takeCash);
  }
};

// 金元宝交易上架
goldStallPutAwayGoods = function(put_one) {
  var now = os.uptime();

  // 初始化统计信息
  goldStallStat.putAwayGoods = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    count: 0, // 请求次数
    okCount: 0, // 成功次数
    maxTime: 0 // 单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.goldStallPutAwayGoods(0, goldStallStat.putAwayGoods, put_one);
  }
};

// 金元宝交易下架
goldStallRemoveGoods = function(remove_one) {
  var now = os.uptime();

  // 初始化统计信息
  goldStallStat.removeGoods = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    count: 0, // 请求次数
    okCount: 0, // 成功次数
    maxTime: 0 // 单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.goldStallRemoveGoods(0, goldStallStat.removeGoods, remove_one);
  }
};

// 金元宝交易搜索
goldStallSearchGoods = function() {
  var now = os.uptime();

  // 初始化统计信息
  goldStallStat.searchGoods = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    count: 0, // 请求次数
    okCount: 0, // 成功次数
    maxTime: 0 // 单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.goldStallSearchGoods(goldStallStat.searchGoods);
  }
};

// 金元宝交易购买
goldStallBuyGoods = function() {
  var now = os.uptime();

  // 初始化统计信息
  goldStallStat.buyGoods = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    reqCount: 0, // 请求数据次数
    reqOkCount: 0, // 请求数据成功次数
    buyCount: 0, // 请求购买次数
    buyOkCount: 0, // 请求购买成功次数
    reqMaxTime: 0, // 请求数据单次最长时间
    buyMaxTime: 0 // 请求购买单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.goldStallBuyGoods(goldStallStat.buyGoods, true);
  }
};

// 金元宝交易提款
goldStallTakeCash = function() {
  var now = os.uptime();

  // 初始化统计信息
  goldStallStat.takeCash = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    count: 0, // 请求次数
    okCount: 0, // 成功次数
    maxTime: 0 // 单次最长时间
  };

  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.goldStallTakeCash(goldStallStat.takeCash);
  }
};

// 充值元宝
rechargeGoldCoin = function() {
  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.rechargeGoldCoin();
  }
};

// 发送消息指令
sendCommand = function(command) {
  for (var key in clients) {
    var client = clients[key];
    client.me.sendTellEx(1, command);
  }
};

// 行走在试道场内
walkInShiDaoChang = function() {
  for (var key in clients) {
    var client = clients[key];
    client.me.walkInShiDaoChang();
  }
};

function onAuctionBidGoods(interval, count, maxCount) {
  // 所有客户端发送竞拍信息
  for (var key in clients) {
    var client = clients[key];
    if (client instanceof Object) client.me.auctionBidGoods(auctionStat.bidStat, maxCount - count);
  }

  if (--count <= 0) return;

  setTimeout(function() {
    onAuctionBidGoods(interval, count, maxCount);
  }, interval);
}

// 拍卖系统竞价
auctionBidGoods = function(timeDesc, interval, count) {
  var startDate;
  var now, startTime;

  now = Date.now();

  startTime = now;
  if (timeDesc.length > 0) {
    startDate = new Date(timeDesc);
    if (startDate.getTime() > startTime) startTime = startDate.getTime();
  }

  if (interval <= 0) interval = 1;

  // 初始化统计信息
  auctionStat.bidStat = {
    beginTime: now, // 开始时间
    endTime: now, // 结束时间
    reqCount: 0, // 请求数据次数
    reqRetCount: 0, // 请求数据返回次数
    bidCount: 0, // 竞价次数
    bidRetCount: 0, // 请求竞价返回次数
    reqMaxTime: 0, // 请求数据单次最长时间
    bidMaxTime: 0 // 请求竞价单次最长时间
  };

  setTimeout(function() {
    onAuctionBidGoods(interval, count, count);
  }, startTime - now);
};

function onTradingSellRole(start, cocurrentNum, interval) {
  var end = start + cocurrentNum - 1;
  if (end >= users_end) end = users_end;

  console.log("onTradingSellRole[" + start + "," + end + "] time:" + Date.now());

  for (var i = start; i <= end; ++i) {
    var account = getAccount(i);
    if ("" == account) continue;

    var client = clients[account];
    if (client instanceof Object) client.me.tradingSellRole(tradingStat.sellStat);
  }

  if (end < users_end) {
    setTimeout(function() {
      onTradingSellRole(end + 1, cocurrentNum, interval);
    }, interval);
  }
}

// 聚宝斋出售角色
tradingSellRole = function(timeDesc, cocurrentNum, interval) {
  var startDate;
  var now, startTime;

  now = Date.now();

  startTime = now;
  if (timeDesc.length > 0) {
    startDate = new Date(timeDesc);
    if (startDate.getTime() > startTime) startTime = startDate.getTime();
  }

  // 初始化统计信息
  tradingStat.sellStat = {
    startTime: now,
    endTime: now,
    opCount: 0, // 操作次数
    okCount: 0, // 成功次数
    secondOpStat: {},
    maxCostTime: 0, // 最大消耗时间
    totalCostTime: 0,
    useRealTime: 0 // 最后一个请求完成时用了多少时间
  };

  setTimeout(function() {
    onTradingSellRole(users_start, cocurrentNum, interval);
  }, startTime - now);
};

// 聚宝斋取消出售角色
tradingCancelRole = function(timeDesc) {
  var startDate;
  var now, startTime;

  now = Date.now();

  startTime = now;
  if (timeDesc.length > 0) {
    startDate = new Date(timeDesc);
    if (startDate.getTime() > startTime) startTime = startDate.getTime();
  }

  // 初始化统计信息
  tradingStat.cancelStat = {
    startTime: now,
    endTime: now,
    opCount: 0, // 操作次数
    okCount: 0, // 成功次数
    secondOpStat: {},
    maxCostTime: 0, // 最大消耗时间
    totalCostTime: 0,
    useRealTime: 0 // 最后一个请求完成时用了多少时间
  };

  setTimeout(function() {
    // 所有客户端发送出售角色
    for (var key in clients) {
      var client = clients[key];
      if (client instanceof Object) client.me.tradingCancelRole(tradingStat.cancelStat);
    }
  }, startTime - now);
};

// 聚宝斋购买角色
tradingBuyRole = function(timeDesc) {
  var startDate;
  var now, startTime;

  now = Date.now();

  startTime = now;
  if (timeDesc.length > 0) {
    startDate = new Date(timeDesc);
    if (startDate.getTime() > startTime) startTime = startDate.getTime();
  }

  // 初始化统计信息
  tradingStat.buyStat = {
    startTime: now,
    endTime: now,
    opCount: 0, // 操作次数
    okCount: 0, // 成功次数
    secondOpStat: {},
    maxCostTime: 0, // 最大消耗时间
    totalCostTime: 0,
    useRealTime: 0 // 最后一个请求完成时用了多少时间
  };

  setTimeout(function() {
    for (var i = users_start; i <= users_end; ++i) {
      var index = i - users_start;
      if (index >= tradingCfg.orders.length) continue;

      var account = getAccount(i);
      if ("" == account) continue;

      var client = clients[account];
      if (client instanceof Object) client.me.tradingBuyRole(tradingStat.buyStat, tradingCfg.orders[index]);
    }
  }, startTime - now);
};

waitLineAction = function(account, loginType) {
  var orgClient = clients[account];
  var client = Client.create(Const.CONNECT_TYPE.LINE_UP);
  client.setAAA(cfg.host, cfg.port);
  client.setAccount(orgClient.account, orgClient.pwd);
  client.login(loginType);
};

// 登陆过程中进行充值
waitLineCharge = function(num) {
  var allAccounts = Object.keys(clients);
  var clientLength = allAccounts.length;
  for (var i = 0; i < Math.min(num, clientLength); ++i) {
    var index = i; // Math.ceil(Math.random() * clientLength) - 1;
    waitLineAction(allAccounts[index], Const.ACCOUNT_TYPE.CHARGE);
  }
};

// 登陆过程中购买会员
waitLineBuyInsider = function(num) {
  var allAccounts = Object.keys(clients);
  var clientLength = allAccounts.length;
  for (var i = 0; i < Math.min(num, clientLength); ++i) {
    var index = i; // Math.ceil(Math.random() * clientLength) - 1;
    waitLineAction(allAccounts[index], Const.ACCOUNT_TYPE.INSIDER);
  }
};

// 初始化
mgr.init();

if (cfg.debugWsConnect) {
  var tc = TestClient.create();
  tc.run();
} else {
  // 运行
  // createClinet();
  // loginAllClient();
}

startOwnershipHeartbeat = function() {
  const heartbeat = () => {
    try {
      renewCurrentInstanceOwnership();
    } catch (error) {
      console.log('renew ownership error', error);
    }
  };

  heartbeat();
  const timer = setInterval(heartbeat, INSTANCE_HEARTBEAT_MS);
  if (timer && typeof timer.unref === 'function') {
    timer.unref();
  }
  return timer;
};

const express = require('express');
const app = express();
const port = HTTP_PORT;

// 设置模板引擎为 EJS
app.set('view engine', 'ejs');
app.set('views', './views')
app.use(express.json());
// 设置静态文件目录
// app.use(express.static('public'));
app.use(express.static(path.join(__dirname, 'public')));

// 定义路由
app.get('/home', (req, res) => {
  // 渲染 views 目录下的 index.ejs 文件
  res.render('index', { title: 'Home Page', message: JSON.stringify(getUserDatas()) });
});
app.get('/config', (req, res) => {
  // 渲染 views 目录下的 index.ejs 文件
  res.render('configView', { title: 'Home Page', message: JSON.stringify(getUserDatas()) });
});

//登录接口
app.get('/api/loginAllClient', (req, res) => {
  // 调用服务器端的函数
  const result = loginAllClient();
  res.json({
    success: true,
    accounts: result.accounts,
    conflicts: result.conflicts,
    skipped: result.skipped,
    message: result.message,
    userDatas: getUserDatas()
  });
});
//退出接口
app.get('/api/logoutAll', (req, res) => {
  // 调用服务器端的函数
  logoutAll();
  // removeUserDatas()
  res.json({});
});
//关闭进程
app.get('/api/exit', (req, res) => {
  // 调用服务器端的函数
  const result = exit();
  res.json({ result });
});
//全部降妖
app.get('/api/allXiangYao', (req, res) => {
  // 调用服务器端的函数
  const result = allXiangYao();
  res.json({ result });
});
//获取机器人信息接口
app.get('/api/checkConnections', (req, res) => {
  // 调用服务器端的函数
  const result = checkConnections();
  let data = {
    'allConnect':allConnectData,
    'connectAAA':connectAAAData,
    'connectGs':connectGsData,
    'lostConnect':lostConnectData
  }
  res.json(data);
});
app.get('/api/getUserDataList', (req, res) => {
  const data = getUserDatas()
  const persistUpdates = [];
  const next = data.map(item => {
    const status = checkClientStatusObject(item.account);
    const runtime = getClientRuntimeSnapshot(item.account);
    const ownership = buildOwnershipView(item);
    const roleName = runtime.roleName || item.roleName || '';
    const level = runtime.level !== '' ? runtime.level : (item.level || '');
    const mapName = runtime.mapName || item.mapName || '';
    const serverName = runtime.serverName || item.serverName || '';
    const chatScene = runtime.chatScene || item.chatScene || '';

    const canPersistRuntime = ownership.ownedByCurrentInstance || !ownership.ownerInstanceId || !ownership.ownerActive;
    if (canPersistRuntime && (runtime.roleName || runtime.level !== '' || runtime.mapName || runtime.serverName || runtime.chatScene)) {
      const snapshotUpdate = {};
      if (roleName && roleName !== item.roleName) snapshotUpdate.roleName = roleName;
      if (level !== '' && level !== item.level) snapshotUpdate.level = level;
      if (mapName && mapName !== item.mapName) snapshotUpdate.mapName = mapName;
      if (serverName && serverName !== item.serverName) snapshotUpdate.serverName = serverName;
      if (chatScene && chatScene !== item.chatScene) snapshotUpdate.chatScene = chatScene;
      if (Object.keys(snapshotUpdate).length) {
        persistUpdates.push(Object.assign({ account: item.account }, snapshotUpdate));
      }
    }

    if (status === undefined) {
      return Object.assign({}, item, ownership, {
        aaa: '不存在该连接',
        gs: '不存在该连接',
        roleName: roleName,
        level: level,
        mapName: mapName,
        serverName: serverName,
        chatScene: chatScene
      });
    }
    return Object.assign({}, item, ownership, {
      aaa: status.aaa,
      gs: status.gs,
      roleName: roleName,
      level: level,
      mapName: mapName,
      serverName: serverName,
      chatScene: chatScene
    });
  });
  if (persistUpdates.length) {
    upsertUserDatas(persistUpdates);
  }
  res.json({
    userDatas: next,
    instance: {
      id: INSTANCE_INFO.id,
      label: INSTANCE_INFO.label,
      leaseMs: INSTANCE_LEASE_MS,
      heartbeatMs: INSTANCE_HEARTBEAT_MS
    }
  });
});
//创建并登录所有账号
app.post('/api/createLoginAllClinetNum', (req, res) => {
  const requestData = req.body;
  console.log(requestData)
  // const result = createClinetNum(Number(requestData.value));//登录  logoutAll()退出
  createLoginAllClinetNum(Number(requestData.value));//创建并登录
  res.json({});
});
app.get('/api/createLoginAllClinetNum', (req, res) => {
  const value = Number(req.query.value || 0);
  createLoginAllClinetNum(value);
  res.json({ success: true, value });
});
//创建并登录单个账号
app.post('/api/createLoginClinet',(req, res)=>{
  const requestData = req.body;
  const result = createLoginClinet(requestData.account)
  res.json({
    success: result.accounts.length > 0,
    accounts: result.accounts,
    conflicts: result.conflicts,
    skipped: result.skipped,
    message: result.message
  });
})
app.get('/api/createLoginClinet',(req, res)=>{
  const account = req.query.account;
  const result = createLoginClinet(account);
  res.json({
    success: result.accounts.length > 0,
    account,
    accounts: result.accounts,
    conflicts: result.conflicts,
    skipped: result.skipped,
    message: result.message
  });
})
//登录列表中的所有账号
app.post('/api/loginListClient', async (req, res) => {
  const requestData = req.body;
  const result = await loginListClient(requestData.list);
  res.json({
    success: true,
    accounts: result.accounts,
    conflicts: result.conflicts,
    skipped: result.skipped,
    message: result.message
  })
})
//退出指定账号
app.post('/api/logoutSingleAccount',async (req, res)=>{
  const requestData = req.body;
  const result = await logoutAccounts([requestData.account])
  res.json({
    success: result.accounts.length > 0,
    accounts: result.accounts,
    conflicts: result.conflicts,
    skipped: result.skipped,
    message: result.message
  });
})
app.post('/api/accounts/generate', (req, res) => {
  const result = createBatchUserRecords(req.body || {});
  res.json({
    success: result.message === 'ok' || result.message === 'partial_conflict',
    created: result.created,
    conflicts: result.conflicts,
    loginResult: result.loginResult,
    message: result.message === 'partial_conflict'
      ? `已写入 ${result.created.length} 个账号，${result.conflicts.length} 个账号被其他实例占用。`
      : `已写入 ${result.created.length} 个账号。`
  });
});
app.post('/api/accounts/import', (req, res) => {
  const result = importUserAccounts(req.body || {});
  res.json({
    success: result.message === 'ok' || result.message === 'partial_conflict',
    created: result.created,
    conflicts: result.conflicts,
    loginResult: result.loginResult,
    message: result.message === 'partial_conflict'
      ? `已导入 ${result.created.length} 个账号，${result.conflicts.length} 个账号被其他实例占用。`
      : `已导入 ${result.created.length} 个账号。`
  });
});
app.post('/api/accounts/delete', (req, res) => {
  const accounts = (req.body && req.body.accounts) || [];
  const claimResult = claimAccountsForCurrentInstance(accounts);
  claimResult.claimed.forEach(account => {
    logoutSingleAccount(account);
    delete clients[account];
  });
  const removedResult = removeOwnedUserAccounts(claimResult.claimed, INSTANCE_INFO.id);
  res.json({
    success: true,
    accounts: removedResult.removed,
    conflicts: claimResult.conflicts.concat(removedResult.conflicts),
    skipped: [],
    message: buildActionMessage('已删除', removedResult.removed.length, claimResult.conflicts.concat(removedResult.conflicts), 0),
    userDatas: removedResult.userDatas
  });
});
app.post('/api/accounts/login', (req, res) => {
  const accounts = (req.body && req.body.accounts) || [];
  const result = loginAccounts(accounts);
  res.json({
    success: true,
    accounts: result.accounts,
    conflicts: result.conflicts,
    skipped: result.skipped,
    message: result.message
  });
});
app.post('/api/accounts/logout', (req, res) => {
  const accounts = (req.body && req.body.accounts) || [];
  const result = logoutAccounts(accounts);
  res.json({
    success: true,
    accounts: result.accounts,
    conflicts: result.conflicts,
    skipped: result.skipped,
    message: result.message
  });
});
app.post('/api/accounts/prepare-finished', (req, res) => {
  const accounts = (req.body && req.body.accounts) || [];
  const result = prepareFinishedAccounts(accounts);
  res.json({
    success: true,
    result: result.result,
    conflicts: result.conflicts,
    skipped: result.skipped,
    message: result.message
  });
});
app.post('/api/accounts/xiangyao', (req, res) => {
  const accounts = (req.body && req.body.accounts) || [];
  const result = runXiangyaoAccounts(accounts);
  res.json({
    success: true,
    accounts: result.accounts,
    conflicts: result.conflicts,
    skipped: result.skipped,
    message: result.message
  });
});
app.get('/api/chat-corpus', (req, res) => {
  res.json({
    success: true,
    corpus: chatCorpus.getCorpus(),
    summary: chatCorpus.getSummary()
  });
});
app.get('/api/chat-corpus/runtime', (req, res) => {
  res.json({
    success: true,
    corpus: chatCorpus.getActiveCorpus(),
    summary: chatCorpus.getSummary()
  });
});
app.post('/api/chat-corpus/runtime/refresh', (req, res) => {
  const next = chatCorpus.refreshActiveCorpus();
  res.json({
    success: true,
    corpus: next.corpus,
    summary: next.summary
  });
});
app.post('/api/chat-corpus', (req, res) => {
  try {
    const next = chatCorpus.saveCorpus((req.body && req.body.corpus) || {});
    res.json({
      success: true,
      corpus: next,
      summary: chatCorpus.getSummary()
    });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message || 'save_failed' });
  }
});
app.post('/api/chat-corpus/category', (req, res) => {
  try {
    const body = req.body || {};
    const next = chatCorpus.upsertCategory(body.key, body.content);
    res.json({
      success: true,
      corpus: next,
      summary: chatCorpus.getSummary()
    });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message || 'save_failed' });
  }
});
app.post('/api/chat-corpus/category/delete', (req, res) => {
  try {
    const body = req.body || {};
    const next = chatCorpus.removeCategory(body.key);
    res.json({
      success: true,
      corpus: next,
      summary: chatCorpus.getSummary()
    });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message || 'delete_failed' });
  }
});
app.get('/api/chat-corpus/summary', (req, res) => {
  res.json(chatCorpus.getSummary());
});
//获取配置信息
app.get('/api/getConfig',(req, res)=>{
  const data = getConfigAll()
  res.json(data);
})
//更新配置信息
app.post('/api/updateConfig',(req, res)=>{
  const requestData = req.body;
  let value = requestData.value;

  if (requestData.field === 'instance_lock_enabled') {
    value = value === true || value === 1 || value === '1' || value === 'true' ? 1 : 0;
  }

  setConfig(requestData.field, value)

  if (requestData.field === 'instance_lock_enabled') {
    try {
      if (Number(value) === 1) {
        renewCurrentInstanceOwnership();
      } else {
        releaseCurrentInstanceOwnership();
      }
    } catch (error) {
      console.log('toggle instance lock error', error);
    }
  }

  res.json({ success: true, field: requestData.field, value });
})
// 启动服务器
app.listen(port, () => {
  startOwnershipHeartbeat();
  console.log(`实例归属锁：${INSTANCE_INFO.label}，租约 ${INSTANCE_LEASE_MS}ms，心跳 ${INSTANCE_HEARTBEAT_MS}ms`);
  console.log(`访问路径： http://localhost:${port}/home`);
});

process.on("uncaughtException", function(error) {
  console.log("error %s: %s\n%s", error.name, error.message, error.stack);
});

['SIGINT', 'SIGTERM'].forEach(signal => {
  process.on(signal, () => {
    try {
      releaseCurrentInstanceOwnership();
    } catch (error) {
      console.log(`release ownership on ${signal} error`, error);
    }
    process.exit(0);
  });
});

if (process.env.DISABLE_REPL !== "1") {
  repl.start({
    prompt: "> ",
    input: process.stdin,
    output: process.stdout
  });
}
