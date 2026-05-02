# 项目维护台账

最后更新：2026-05-02
维护人：Codex

## 2026-05-02 多实例账号归属锁

### 已完成
1. 给 `data/list.json` 增加文件级互斥锁，避免多实例同时读写时互相覆盖。
2. 给账号台账增加实例归属字段：`ownerInstanceId`、`ownerLabel`、`ownerLeaseUntil`、`ownerLastHeartbeatAt` 等。
3. 新增租约接口能力：账号 claim、续租 heartbeat、释放归属、按 owner 删除。
4. 当前实例启动后会自动续租自己持有的账号；退出进程时会主动释放自己的归属锁。
5. `批量生成 / 批量导入 / 全部登录 / 单账号登录 / 批量登录 / 退出 / 成品准备 / 降妖 / 删除` 已接入实例归属校验。
6. `/api/getUserDataList` 现在会返回实例归属视图，首页账号列会展示“当前实例 / 已锁定其他实例 / 锁已过期”。
7. 当账号正被其他实例持有时，首页单账号操作按钮会直接禁用，避免误点无反馈。
8. 新增运行时配置 `instance_lock_enabled`，支持在 `/config` 页面手动开关实例归属锁。

### 风险收敛
1. 防止多个项目或多个端口实例同时接管同一批假人。
2. 防止两个进程并发改写 `data/list.json` 导致账号台账丢失或互相覆盖。
3. 实例异常退出后不需要手动清锁，等租约过期后其他实例可自动接管。

### 后续可选
1. 如需更强可视化，可在首页额外显示“当前实例标签 / 租约剩余时间”。
2. 如需人工交接账号池，可再补一个“释放所选账号归属”按钮。

## 2026-05-02 Web 控制台 / 本地语料库 / 角色回显

### 已完成
1. 重做 `/home` 首页布局，统一为天蓝色卡片风。
2. 批量生成账号新增角色名策略、角色性别策略，并贯通到首次建角流程。
3. 修复建角时把 `account` 误传给 `buildCharName` 的问题。
4. 首页账号表格新增角色名回显，并回显等级、地图、当前任务场景等运行态信息。
5. 首页“当前关键配置”改为横向多列卡片展示。
6. 新增本地语料模块 `lib/chatCorpus.js`。
7. 新增本地语料文件 `data/chat_corpus.json`。
8. 将 `Instruction.onInterval3` 的世界自动喊话切换为“本地语料 + world_chat 补充词库”模式。
9. `/config` 页面新增“本地语料库”可视化管理区域，支持查看分类、保存单分类、新建分类、删除分类、刷新语料。
10. 新增语料相关 HTTP API：
   - `GET /api/chat-corpus`
   - `POST /api/chat-corpus`
   - `POST /api/chat-corpus/category`
   - `POST /api/chat-corpus/category/delete`
   - `GET /api/chat-corpus/summary`
11. 已完成 `main.js`、`Instruction.js`、`lib/chatCorpus.js` 语法检查。
12. 已完成 `views/index.ejs`、`views/configView.ejs` 模板编译检查。
13. 已完成备用端口启动检查与语料接口读写检查。

### 进行中
1. 梳理多实例运行风险与账号归属管理方案。
2. 评估是否需要给账号池增加实例 owner / lease 锁。

### 待完成
1. 如需支持稳定多开，补实例归属锁与租约机制。
2. 如需增强语料管理，再补分类重命名、导入导出、恢复默认语料。
3. 如需增强登录诊断，再补登录失败原因统计面板与实例归属展示。

---

## 2026-05-02 Debian / Docker 适配

### 已完成
1. 新建 `debian-docker` 分支，用于隔离 Debian 容器化改造。
2. 完成首轮可行性评估，确认核心运行层可迁移到 Debian。
3. 新增 `Dockerfile`。
4. 新增 `docker-compose.yml`。
5. 新增 `docker/entrypoint.sh`。
6. 新增 `.dockerignore`。
7. 在 `package.json` 补充基础启动脚本。
8. 在 `README.md` 补充 Debian / Docker 启动与部署说明。

### 进行中
1. 验证 Docker 构建与容器启动是否能在当前环境直接通过。
2. 观察 Debian 第一版是否还需要补额外兼容项。

### 待完成
1. 如有需要，补 Linux 版初始化脚本替代 `init.bat`。
2. 视运行结果决定是否补 `.gitignore`。
3. 视运行结果决定是否继续清理与 Docker 无关的历史接口。

---

## 2026-05-02 文档拆分

### 已完成
1. 将根目录大体量 `README.md` 拆分到 `docs/`。
2. 新建根目录精简导航版 `README.md`。
3. 新建 `docs/README.md` 文档目录。
4. 拆分出以下文档：
   - `01-overview-and-init.md`
   - `02-startup-and-deploy.md`
   - `03-config-and-auth.md`
   - `04-features-and-logic.md`
   - `05-web-console-api.md`
   - `06-data-troubleshooting-and-maintenance.md`

### 进行中
1. 继续把后续新功能统一收口到 `docs/`。

### 待完成
1. 如后续 Web 操作手册继续膨胀，可继续拆独立专题文档。

---

## 维护建议

后续每次改动建议至少补 3 件事：
1. 改了什么。
2. 为什么改。
3. 影响了哪些文件、接口、页面或配置。
