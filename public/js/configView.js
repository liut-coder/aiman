(function() {
  const fieldMeta = {
    users_prefix: {
      label: '账号前缀',
      description: '批量生成账号时，会拼接在 110001 后面，例如 A、WD。'
    },
    users_index_num: {
      label: '编号位数',
      description: '账号编号左侧补零的位数，例如 4 表示 0001。'
    },
    users_pass: {
      label: '默认密码',
      description: '新建或登录机器人账号时统一使用的密码。'
    },
    instance_lock_enabled: {
      label: '实例归属锁',
      description: '控制是否启用多实例账号归属锁。关闭后会忽略 owner / lease 拦截。',
      toggle: true,
      toggleOnLabel: '已开启',
      toggleOffLabel: '已关闭',
      footnote: '建议多开共享账号池时保持开启。关闭后，当前实例会立刻释放自己持有的归属锁。'
    },
    mail_name: {
      label: '经验邮件名称',
      description: '成品准备时自动领取的经验类邮件标题。'
    },
    mail_equip: {
      label: '装备邮件名称',
      description: '成品准备时自动领取的装备邮件标题。'
    },
    mail_pet: {
      label: '宠物邮件名称',
      description: '成品准备时自动领取的宠物邮件标题。'
    },
    War_pet: {
      label: '参战宠物名称',
      description: '成品准备阶段会自动把匹配到的宠物设置为参战。'
    },
    Ride_pet: {
      label: '乘骑坐骑名称',
      description: '成品准备阶段会自动把匹配到的宠物设置为坐骑。'
    },
    equip_fly: {
      label: '飞行法宝名称',
      description: '成品准备阶段会尝试自动装备该飞行法宝。'
    },
    vip_type: {
      label: '会员类型',
      description: '所有账号购买会员时使用的类型：1 月卡，2 季卡，3 年卡。'
    },
    world_Team: {
      label: '组队喊话关键词',
      description: '世界频道监听到这些关键词后，机器人会按规则尝试申请入队。',
      multiline: true,
      footnote: '这里是实际生效中的世界组队关键词匹配配置。'
    },
    world_chat: {
      label: '自动喊话词',
      description: '这里的内容会作为自定义补充词库，和本地语料文件一起参与自动喊话。',
      multiline: true,
      footnote: '基础语料在 data/chat_corpus.json，这里更适合放你临时追加的特色喊话。'
    }
  };

  const groups = [
    {
      title: '账号基础',
      subtitle: '这一组决定批量生成账号的命名规则、默认登录密码，以及多实例共享时的归属锁开关。',
      chip: '基础',
      fields: ['users_prefix', 'users_index_num', 'users_pass', 'instance_lock_enabled']
    },
    {
      title: '成品准备',
      subtitle: '领取邮件、购买会员、设置参战宠物、坐骑和飞行法宝都集中在这里。',
      chip: '成品准备',
      fields: ['mail_name', 'mail_equip', 'mail_pet', 'War_pet', 'Ride_pet', 'equip_fly', 'vip_type']
    },
    {
      title: '世界互动',
      subtitle: '包括组队关键词监听和自动喊话配置，后续扩展时也建议优先从这里接入。',
      chip: '世界频道',
      fields: ['world_Team', 'world_chat']
    }
  ];

  const corpusLabelMap = {
    global: '世界通用',
    team: '组队相关',
    xiangyao: '降妖场景',
    zhuxian: '主线场景',
    shimen: '师门场景',
    bangpai: '帮派场景',
    chubao: '除暴场景'
  };

  const preferredCorpusOrder = ['global', 'team', 'xiangyao', 'zhuxian', 'shimen', 'bangpai', 'chubao'];
  const corpusState = {
    corpus: {},
    summary: null
  };

  let editingFieldKey = '';

  function escapeHtml(value) {
    return String(value ?? '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function notify(message, icon) {
    if (window.layui && layui.layer && typeof layui.layer.msg === 'function') {
      layui.layer.msg(message, icon === undefined ? {} : { icon });
      return;
    }
    console.log(message);
  }

  function normalizeToggleValue(value) {
    if (typeof value === 'string') {
      return ['1', 'true', 'on', 'yes'].includes(value.trim().toLowerCase());
    }
    return value === true || value === 1;
  }

  async function requestJson(url, options) {
    const response = await fetch(url, options || {});
    let payload = null;

    try {
      payload = await response.json();
    } catch (error) {
      payload = null;
    }

    if (!response.ok) {
      throw new Error((payload && payload.message) || `HTTP ${response.status}`);
    }

    return payload || {};
  }

  function buildFieldControl(field) {
    const meta = fieldMeta[field] || {};
    if (meta.toggle) {
      return `
        <label style="display:flex; align-items:center; gap:12px; min-height:46px;">
          <input type="checkbox" id="${field}" style="width:18px; height:18px;">
          <span id="${field}_label">${escapeHtml(meta.toggleOffLabel || '已关闭')}</span>
        </label>
      `;
    }

    if (meta.multiline) {
      return `<textarea class="form-control" id="${field}" rows="5" readonly></textarea>`;
    }

    const inputType = field === 'users_index_num' || field === 'vip_type' ? 'number' : 'text';
    return `<input type="${inputType}" class="form-control" id="${field}" readonly>`;
  }

  function buildActionButton(field) {
    const meta = fieldMeta[field] || {};
    if (meta.toggle) {
      return `<button class="field-btn btn-toggle-save" data-field="${escapeHtml(field)}" type="button">保存开关</button>`;
    }
    return `<button class="field-btn btn-edit" data-field="${escapeHtml(field)}" type="button">编辑</button>`;
  }

  function buildConfigGroups() {
    const groupsContainer = document.getElementById('configGroups');
    if (!groupsContainer) return;

    groupsContainer.innerHTML = groups.map(group => {
      const hasWideOnly = group.fields.length <= 2 && group.fields.every(field => fieldMeta[field] && fieldMeta[field].multiline);
      const fieldsHtml = group.fields.map(field => {
        const meta = fieldMeta[field] || {};
        const wideClass = meta.multiline ? 'wide' : '';

        return `
          <div class="field-card ${wideClass}">
            <div class="field-card-top">
              <div>
                <h3 class="field-name">${escapeHtml(meta.label || field)}</h3>
                <div class="field-key">${escapeHtml(field)}</div>
              </div>
              ${buildActionButton(field)}
            </div>
            <div class="field-desc">${escapeHtml(meta.description || '暂无说明')}</div>
            <div class="field-value">
              ${buildFieldControl(field)}
            </div>
            ${meta.footnote ? `<div class="field-footnote">${escapeHtml(meta.footnote)}</div>` : ''}
          </div>
        `;
      }).join('');

      return `
        <section class="group-card">
          <div class="group-head">
            <div>
              <h2 class="group-title">${escapeHtml(group.title)}</h2>
              <div class="group-subtitle">${escapeHtml(group.subtitle)}</div>
            </div>
            <div class="group-chip">${escapeHtml(group.chip)}</div>
          </div>
          <div class="group-fields ${hasWideOnly ? 'single' : ''}">
            ${fieldsHtml}
          </div>
        </section>
      `;
    }).join('');

    groupsContainer.addEventListener('click', event => {
      const toggleButton = event.target.closest('.btn-toggle-save');
      if (toggleButton) {
        const field = toggleButton.getAttribute('data-field');
        const input = document.getElementById(field);
        saveFieldValue(field, input && input.checked ? 1 : 0);
        return;
      }

      const editButton = event.target.closest('.btn-edit');
      if (!editButton) return;

      const field = editButton.getAttribute('data-field');
      const input = document.getElementById(field);
      openModal(field, input ? input.value : '', fieldMeta[field] || {});
    });
  }

  function normalizeCorpusOrder(keys) {
    const rest = keys.filter(key => !preferredCorpusOrder.includes(key)).sort();
    return preferredCorpusOrder.filter(key => keys.includes(key)).concat(rest);
  }

  function renderCorpusSummary() {
    const summary = corpusState.summary;
    const chip = document.getElementById('chatCorpusSummaryChip');
    const subtitle = document.getElementById('chatCorpusSubtitle');

    if (!chip || !subtitle) return;

    if (!summary) {
      chip.textContent = '加载中';
      subtitle.textContent = '这里可以直接维护 data/chat_corpus.json。每行一句，保存后会立刻参与自动喊话。';
      return;
    }

    const dailyVariation = summary.dailyVariation || {};
    const toneLabel = dailyVariation.toneLabel || '今日语气';
    const runtimeCount = dailyVariation.totalMessages || 0;
    const refreshCount = dailyVariation.refreshCount || 0;

    chip.textContent = `${summary.totalCategories || 0} 类 / ${summary.totalMessages || 0} 句 / ${toneLabel}`;
    subtitle.textContent = `这里可以直接维护 data/chat_corpus.json。当前共 ${summary.totalCategories || 0} 个分类、${summary.totalMessages || 0} 句本地语料。今日实际生效 ${runtimeCount} 句，当前是“${toneLabel}”，已手动切换 ${refreshCount} 次。`;
  }

  function renderCorpusManager() {
    const container = document.getElementById('chatCorpusManager');
    if (!container) return;

    const corpus = corpusState.corpus || {};
    const keys = normalizeCorpusOrder(Object.keys(corpus));

    renderCorpusSummary();

    if (!keys.length) {
      container.innerHTML = '<div class="corpus-empty">当前还没有语料分类，先新建一个分类开始维护。</div>';
      return;
    }

    container.innerHTML = keys.map(key => {
      const list = Array.isArray(corpus[key]) ? corpus[key] : [];
      const content = list.join('\n');
      const label = corpusLabelMap[key] || key;

      return `
        <div class="corpus-card" data-corpus-key="${escapeHtml(key)}">
          <div class="corpus-card-head">
            <div>
              <h3 class="corpus-card-title">${escapeHtml(label)}</h3>
              <div class="corpus-card-key">${escapeHtml(key)}</div>
            </div>
            <div class="corpus-count">${list.length} 句</div>
          </div>
          <div class="corpus-card-desc">每行一句。保存后会直接写入本地语料文件，自动喊话下一周期就会读取到。</div>
          <textarea class="form-control corpus-textarea" data-corpus-editor="${escapeHtml(key)}">${escapeHtml(content)}</textarea>
          <div class="corpus-actions">
            <div class="corpus-hint">支持模板变量：{{roleName}}、{{mapName}}、{{sceneLabel}}、{{account}}</div>
            <div style="display:flex; gap:10px; flex-wrap:wrap;">
              <button class="flat-btn flat-btn-primary" type="button" data-corpus-save="${escapeHtml(key)}">保存分类</button>
              <button class="flat-btn flat-btn-danger" type="button" data-corpus-delete="${escapeHtml(key)}">删除分类</button>
            </div>
          </div>
        </div>
      `;
    }).join('');
  }

  async function loadChatCorpus() {
    try {
      const result = await requestJson('/api/chat-corpus');
      corpusState.corpus = result.corpus || {};
      corpusState.summary = result.summary || null;
      renderCorpusManager();
    } catch (error) {
      console.error('加载本地语料失败:', error);
      const container = document.getElementById('chatCorpusManager');
      if (container) {
        container.innerHTML = '<div class="corpus-empty">加载本地语料失败，请稍后重试。</div>';
      }
      notify('加载本地语料失败', 2);
    }
  }

  async function refreshCorpusRuntime() {
    try {
      const result = await requestJson('/api/chat-corpus/runtime/refresh', {
        method: 'POST'
      });
      corpusState.summary = result.summary || corpusState.summary;
      renderCorpusSummary();

      const dailyVariation = result.summary && result.summary.dailyVariation
        ? result.summary.dailyVariation
        : null;
      if (dailyVariation) {
        notify(`已切换到“${dailyVariation.toneLabel || '今日语气'}”`, 1);
      } else {
        notify('已刷新今日语料', 1);
      }
    } catch (error) {
      console.error('手动切换语气失败:', error);
      notify(`切换语气失败：${error.message}`, 2);
    }
  }

  async function saveCorpusCategory(key) {
    const editor = document.querySelector(`[data-corpus-editor="${key}"]`);
    if (!editor) return;

    try {
      const result = await requestJson('/api/chat-corpus/category', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ key, content: editor.value })
      });
      corpusState.corpus = result.corpus || {};
      corpusState.summary = result.summary || null;
      renderCorpusManager();
      notify(`已保存 ${key}`, 1);
    } catch (error) {
      console.error('保存语料分类失败:', error);
      notify(`保存失败：${error.message}`, 2);
    }
  }

  async function deleteCorpusCategory(key) {
    try {
      const result = await requestJson('/api/chat-corpus/category/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ key })
      });
      corpusState.corpus = result.corpus || {};
      corpusState.summary = result.summary || null;
      renderCorpusManager();
      notify(`已删除 ${key}`, 1);
    } catch (error) {
      console.error('删除语料分类失败:', error);
      notify(`删除失败：${error.message}`, 2);
    }
  }

  async function createCorpusCategory() {
    const input = document.getElementById('newCorpusCategoryInput');
    if (!input) return;

    const key = String(input.value || '').trim();
    if (!key) {
      notify('请先输入分类 key', 0);
      return;
    }

    if (!/^[a-zA-Z0-9_-]+$/.test(key)) {
      notify('分类 key 仅支持字母、数字、下划线和中横线', 2);
      return;
    }

    if (Object.prototype.hasOwnProperty.call(corpusState.corpus || {}, key)) {
      notify('这个分类已经存在了', 0);
      return;
    }

    try {
      const result = await requestJson('/api/chat-corpus/category', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ key, content: '' })
      });
      corpusState.corpus = result.corpus || {};
      corpusState.summary = result.summary || null;
      input.value = '';
      renderCorpusManager();
      notify(`已新建分类 ${key}`, 1);
    } catch (error) {
      console.error('新建语料分类失败:', error);
      notify(`新建失败：${error.message}`, 2);
    }
  }

  function openModal(field, value, meta) {
    const modal = document.getElementById('editModal');
    const modalTitle = document.getElementById('modalTitle');
    const modalSubtitle = document.getElementById('modalSubtitle');
    const modalTextarea = document.getElementById('modalTextarea');

    if (!modal || !modalTitle || !modalSubtitle || !modalTextarea) return;

    editingFieldKey = field;
    modalTitle.textContent = `编辑 ${meta.label || field}`;
    modalSubtitle.textContent = meta.description || '保存后会立即写入配置文件。';
    modalTextarea.value = value || '';
    modal.classList.add('is-open');
    document.body.style.overflow = 'hidden';
  }

  function closeModal() {
    const modal = document.getElementById('editModal');
    if (modal) modal.classList.remove('is-open');
    document.body.style.overflow = '';
    editingFieldKey = '';
  }

  function applyFieldValue(field, value) {
    const meta = fieldMeta[field] || {};
    const input = document.getElementById(field);
    if (!input) return;

    if (meta.toggle) {
      const checked = value === undefined ? false : normalizeToggleValue(value);
      input.checked = checked;
      const label = document.getElementById(`${field}_label`);
      if (label) {
        label.textContent = checked
          ? (meta.toggleOnLabel || '已开启')
          : (meta.toggleOffLabel || '已关闭');
      }
      return;
    }

    input.value = value ?? '';
  }

  async function loadConfigData() {
    try {
      const cfg = await requestJson('/api/getConfig');
      Object.keys(fieldMeta).forEach(field => {
        applyFieldValue(field, cfg[field]);
      });
    } catch (error) {
      console.error('加载配置失败:', error);
      notify('加载配置失败', 2);
    }
  }

  async function saveFieldValue(field, value) {
    try {
      const result = await requestJson('/api/updateConfig', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ field, value })
      });
      applyFieldValue(field, result.value !== undefined ? result.value : value);
      closeModal();
      notify('修改成功', 1);
    } catch (error) {
      console.error('更新配置失败:', error);
      notify('更新失败', 2);
    }
  }

  function bindEvents() {
    const modalCloseBtn = document.getElementById('modalCloseBtn');
    const modalCancelBtn = document.getElementById('modalCancelBtn');
    const modalSubmitBtn = document.getElementById('modalSubmitBtn');
    const editModal = document.getElementById('editModal');
    const createCorpusCategoryBtn = document.getElementById('createCorpusCategoryBtn');
    const reloadCorpusBtn = document.getElementById('reloadCorpusBtn');
    const newCorpusCategoryInput = document.getElementById('newCorpusCategoryInput');
    const chatCorpusManager = document.getElementById('chatCorpusManager');

    if (modalCloseBtn) modalCloseBtn.addEventListener('click', closeModal);
    if (modalCancelBtn) modalCancelBtn.addEventListener('click', closeModal);
    if (modalSubmitBtn) {
      modalSubmitBtn.addEventListener('click', function() {
        if (!editingFieldKey) return;
        const textarea = document.getElementById('modalTextarea');
        saveFieldValue(editingFieldKey, textarea ? textarea.value : '');
      });
    }
    if (editModal) {
      editModal.addEventListener('click', function(event) {
        if (event.target.id === 'editModal') closeModal();
      });
    }
    if (createCorpusCategoryBtn) {
      createCorpusCategoryBtn.addEventListener('click', createCorpusCategory);
    }
    if (reloadCorpusBtn) {
      reloadCorpusBtn.textContent = '切换今日语气';
      reloadCorpusBtn.title = '手动切到下一套运行时语气';
      reloadCorpusBtn.addEventListener('click', refreshCorpusRuntime);
    }
    if (newCorpusCategoryInput) {
      newCorpusCategoryInput.addEventListener('keydown', function(event) {
        if (event.key === 'Enter') {
          event.preventDefault();
          createCorpusCategory();
        }
      });
    }
    if (chatCorpusManager) {
      chatCorpusManager.addEventListener('click', function(event) {
        const saveButton = event.target.closest('[data-corpus-save]');
        if (saveButton) {
          saveCorpusCategory(saveButton.getAttribute('data-corpus-save'));
          return;
        }

        const deleteButton = event.target.closest('[data-corpus-delete]');
        if (!deleteButton) return;

        const key = deleteButton.getAttribute('data-corpus-delete');
        if (!window.confirm(`确认删除语料分类 ${key} 吗？`)) return;
        deleteCorpusCategory(key);
      });
    }
  }

  async function init() {
    buildConfigGroups();
    bindEvents();
    await loadConfigData();
    await loadChatCorpus();
  }

  init();
})();
