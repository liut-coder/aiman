const fs = require('fs');
const path = require('path');

const corpusFile = path.join(__dirname, '..', 'data', 'chat_corpus.json');
const defaultCorpus = {
  global: [],
  team: [],
  xiangyao: [],
  zhuxian: [],
  shimen: [],
  bangpai: [],
  chubao: []
};

let cacheMtimeMs = 0;
let cacheData = defaultCorpus;

const sceneLabelMap = {
  zhuxian: '主线',
  shimen: '师门',
  bangpai: '帮派',
  chubao: '除暴',
  xiangyao: '降妖',
  global: '世界'
};
const DAILY_VARIATION_MIN_COUNT = 3;
const DAILY_VARIATION_BASE_RATIO = 0.6;
const DAILY_VARIATION_RATIO_SPAN = 0.25;
const TONE_PROFILES = [
  {
    key: 'steady',
    label: '稳刷任务党',
    description: '偏稳定、正常交流，像持续清日常的老玩家。',
    endings: [],
    appendProbability: 0
  },
  {
    key: 'social',
    label: '社交混队党',
    description: '更愿意搭话、求组队，像边做任务边聊天的玩家。',
    endings: ['，有人一起不？', '，在线的回一声。', '，来个队友。'],
    appendProbability: 42
  },
  {
    key: 'grind',
    label: '效率冲级党',
    description: '更看重进度和效率，像赶日常和拉经验的玩家。',
    endings: ['，效率点。', '，先把进度清了。', '，抓紧走一轮。'],
    appendProbability: 38
  },
  {
    key: 'leader',
    label: '带队招人党',
    description: '更像在收人开队，语气更主动、更像队长。',
    endings: ['，缺位直接来。', '，能跟队的进。', '，来就开。'],
    appendProbability: 48
  },
  {
    key: 'casual',
    label: '佛系挂机党',
    description: '更松弛一点，像边挂边做、随缘聊天的玩家。',
    endings: ['，慢慢来就行。', '，不急，随缘组。', '，在线的唠两句。'],
    appendProbability: 34
  }
];
let runtimeVariationState = {
  dateKey: '',
  toneIndex: 0,
  refreshCount: 0
};

function normalizeList(list) {
  if (!Array.isArray(list)) return [];

  const unique = new Set();
  list.forEach(item => {
    const text = String(item || '').trim();
    if (text) unique.add(text);
  });
  return Array.from(unique);
}

function normalizeCorpus(raw) {
  const next = {};
  const source = raw && typeof raw === 'object' ? raw : {};

  Object.keys(source).forEach(key => {
    next[key] = normalizeList(source[key]);
  });

  return next;
}

function ensureCorpusDir() {
  fs.mkdirSync(path.dirname(corpusFile), { recursive: true });
}

function ensureCorpusFile() {
  ensureCorpusDir();
  if (fs.existsSync(corpusFile)) {
    return;
  }

  fs.writeFileSync(corpusFile, JSON.stringify(defaultCorpus, null, 2));
}

function writeCorpus(corpus) {
  ensureCorpusDir();
  const normalized = normalizeCorpus(corpus);
  const jsonText = JSON.stringify(normalized, null, 2);
  fs.writeFileSync(corpusFile, jsonText);

  try {
    const stat = fs.statSync(corpusFile);
    cacheMtimeMs = stat.mtimeMs;
  } catch (error) {
    cacheMtimeMs = 0;
  }
  cacheData = normalized;
  return cacheData;
}

function loadCorpus() {
  try {
    ensureCorpusFile();
    const stat = fs.statSync(corpusFile);
    if (cacheData && cacheMtimeMs === stat.mtimeMs) {
      return cacheData;
    }

    const rawText = fs.readFileSync(corpusFile, 'utf8');
    const parsed = JSON.parse(rawText);
    cacheData = normalizeCorpus(parsed);
    cacheMtimeMs = stat.mtimeMs;
    return cacheData;
  } catch (error) {
    console.error('load chat corpus error', error);
    try {
      if (fs.existsSync(corpusFile)) {
        fs.renameSync(corpusFile, corpusFile + '.broken-' + Date.now());
      }
    } catch (renameError) {
      console.error('backup broken chat corpus error', renameError);
    }

    cacheMtimeMs = 0;
    cacheData = normalizeCorpus(cacheData && Object.keys(cacheData).length ? cacheData : defaultCorpus);
    return writeCorpus(cacheData);
  }
}

function splitCustomPhrases(text) {
  return normalizeList(String(text || '').split(/[\r\n,，；;]+/));
}

function splitCategoryContent(value) {
  if (Array.isArray(value)) {
    return normalizeList(value);
  }

  return normalizeList(
    String(value || '')
      .replace(/\\n/g, '\n')
      .split(/\r?\n/)
  );
}

function padNumber(value) {
  return String(value).padStart(2, '0');
}

function getDateKey(date) {
  const source = date instanceof Date ? date : new Date();
  return [
    source.getFullYear(),
    padNumber(source.getMonth() + 1),
    padNumber(source.getDate())
  ].join('-');
}

function hashString(input) {
  const text = String(input || '');
  let hash = 2166136261;

  for (let i = 0; i < text.length; i++) {
    hash ^= text.charCodeAt(i);
    hash = Math.imul(hash, 16777619);
  }

  return hash >>> 0;
}

function buildSeededOrder(list, seedKey) {
  return list
    .map((item, index) => ({
      item: item,
      order: hashString(`${seedKey}|${index}|${item}`)
    }))
    .sort((a, b) => a.order - b.order)
    .map(entry => entry.item);
}

function getRuntimeState(date) {
  const dateKey = getDateKey(date);
  if (runtimeVariationState.dateKey !== dateKey) {
    runtimeVariationState = {
      dateKey: dateKey,
      toneIndex: hashString(`${dateKey}|tone`) % TONE_PROFILES.length,
      refreshCount: 0
    };
  }

  return Object.assign({}, runtimeVariationState);
}

function getToneProfile(runtimeState) {
  const index = runtimeState && Number.isInteger(runtimeState.toneIndex)
    ? runtimeState.toneIndex
    : 0;
  return TONE_PROFILES[index] || TONE_PROFILES[0];
}

function stripTerminalPunctuation(text) {
  return String(text || '').replace(/[，。！？,.!?\s]+$/g, '');
}

function applyToneToMessage(message, categoryKey, runtimeState) {
  const toneProfile = getToneProfile(runtimeState);
  const text = String(message || '').trim();
  if (!text || !toneProfile.endings.length || toneProfile.appendProbability <= 0) {
    return text;
  }

  const messageSeed = hashString(
    `${runtimeState.dateKey}|${runtimeState.refreshCount}|${toneProfile.key}|${categoryKey}|${text}`
  );
  if ((messageSeed % 100) >= toneProfile.appendProbability) {
    return text;
  }

  const ending = toneProfile.endings[messageSeed % toneProfile.endings.length];
  if (!ending) {
    return text;
  }

  const endingCore = ending.replace(/[，。！？,.!?]/g, '');
  if (endingCore && text.includes(endingCore)) {
    return text;
  }

  return stripTerminalPunctuation(text) + ending;
}

function pickDailySubset(list, categoryKey, runtimeState) {
  const normalized = normalizeList(list);
  if (normalized.length <= DAILY_VARIATION_MIN_COUNT) {
    return normalized;
  }

  const toneProfile = getToneProfile(runtimeState);
  const ordered = buildSeededOrder(
    normalized,
    `${runtimeState.dateKey}|${categoryKey}|${toneProfile.key}|${runtimeState.refreshCount}`
  );
  const ratioSeed = hashString(
    `${runtimeState.dateKey}|${categoryKey}|${toneProfile.key}|ratio|${runtimeState.refreshCount}`
  );
  const ratio = DAILY_VARIATION_BASE_RATIO + ((ratioSeed % 1000) / 1000) * DAILY_VARIATION_RATIO_SPAN;
  const targetCount = Math.max(
    DAILY_VARIATION_MIN_COUNT,
    Math.min(normalized.length, Math.round(normalized.length * ratio))
  );

  return ordered.slice(0, targetCount);
}

function buildDailyCorpus(baseCorpus, runtimeState) {
  const source = normalizeCorpus(baseCorpus);
  const active = {};

  Object.keys(source).forEach(key => {
    active[key] = pickDailySubset(source[key], key, runtimeState).map(item =>
      applyToneToMessage(item, key, runtimeState)
    );
  });

  return active;
}

function renderTemplate(message, context) {
  const data = Object.assign({
    roleName: '',
    mapName: '',
    scene: '',
    sceneLabel: '',
    account: ''
  }, context || {});

  return String(message || '').replace(/\{\{\s*(\w+)\s*\}\}/g, function(match, key) {
    return data[key] !== undefined && data[key] !== null ? String(data[key]) : '';
  }).trim();
}

function buildPool(options) {
  const runtimeState = getRuntimeState(options && options.now);
  const corpus = buildDailyCorpus(loadCorpus(), runtimeState);
  const scene = String((options && options.scene) || '').trim();
  const customPhrases = splitCustomPhrases(options && options.customPhrases);
  const pool = [];

  if (Array.isArray(corpus.global)) {
    pool.push.apply(pool, corpus.global);
  }

  if (options && options.inTeam && Array.isArray(corpus.team)) {
    pool.push.apply(pool, corpus.team);
  }

  if (scene && Array.isArray(corpus[scene])) {
    pool.push.apply(pool, corpus[scene]);
  }

  if (customPhrases.length) {
    pool.push.apply(pool, customPhrases);
  }

  return normalizeList(pool).map(item => renderTemplate(item, {
    roleName: options && options.roleName,
    mapName: options && options.mapName,
    scene: scene,
    sceneLabel: sceneLabelMap[scene] || sceneLabelMap.global,
    account: options && options.account
  })).filter(Boolean);
}

function pickChatMessage(options) {
  const pool = buildPool(options);
  if (!pool.length) return '';

  const recentMessages = normalizeList(options && options.recentMessages);
  let candidates = pool.filter(item => !recentMessages.includes(item));
  if (!candidates.length) {
    candidates = pool.slice();
  }

  const randomIndex = Math.floor(Math.random() * candidates.length);
  return candidates[randomIndex] || '';
}

function getSummary() {
  const corpus = loadCorpus();
  const runtimeState = getRuntimeState();
  const toneProfile = getToneProfile(runtimeState);
  const activeCorpus = buildDailyCorpus(corpus, runtimeState);
  const categories = Object.keys(corpus).map(key => ({
    key: key,
    count: Array.isArray(corpus[key]) ? corpus[key].length : 0
  })).sort((a, b) => b.count - a.count);
  const activeCategories = Object.keys(activeCorpus).map(key => ({
    key: key,
    count: Array.isArray(activeCorpus[key]) ? activeCorpus[key].length : 0
  })).sort((a, b) => b.count - a.count);

  return {
    file: corpusFile,
    totalCategories: categories.length,
    totalMessages: categories.reduce((sum, item) => sum + item.count, 0),
    categories: categories,
    dailyVariation: {
      enabled: true,
      dateKey: runtimeState.dateKey,
      toneKey: toneProfile.key,
      toneLabel: toneProfile.label,
      toneDescription: toneProfile.description,
      refreshCount: runtimeState.refreshCount,
      totalMessages: activeCategories.reduce((sum, item) => sum + item.count, 0),
      categories: activeCategories
    }
  };
}

function getCorpus() {
  return JSON.parse(JSON.stringify(loadCorpus()));
}

function getActiveCorpus(options) {
  const runtimeState = getRuntimeState(options && options.now);
  return JSON.parse(JSON.stringify(buildDailyCorpus(loadCorpus(), runtimeState)));
}

function refreshActiveCorpus(options) {
  getRuntimeState(options && options.now);
  runtimeVariationState.toneIndex = (runtimeVariationState.toneIndex + 1) % TONE_PROFILES.length;
  runtimeVariationState.refreshCount += 1;

  return {
    corpus: getActiveCorpus(options),
    summary: getSummary()
  };
}

function saveCorpus(corpus) {
  return writeCorpus(corpus || {});
}

function upsertCategory(key, value) {
  const categoryKey = String(key || '').trim();
  if (!categoryKey) {
    throw new Error('category_key_required');
  }

  const next = getCorpus();
  next[categoryKey] = splitCategoryContent(value);
  return writeCorpus(next);
}

function removeCategory(key) {
  const categoryKey = String(key || '').trim();
  if (!categoryKey) {
    throw new Error('category_key_required');
  }

  const next = getCorpus();
  delete next[categoryKey];
  return writeCorpus(next);
}

module.exports = {
  getActiveCorpus,
  getCorpus,
  refreshActiveCorpus,
  saveCorpus,
  splitCustomPhrases,
  pickChatMessage,
  getSummary,
  upsertCategory,
  removeCategory
};
