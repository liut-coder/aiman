# 智能假人系统维护文档

## 1. 项目定位

本项目是一个基于 Node.js 的《问道》机器人控制台，核心能力包括：

- 批量创建和登录机器人账号
- AAA 登录、GS 进服、角色选择与基础连线维护
- 自动主线、师门、帮派、除暴、降妖等任务流转
- 自动世界喊话
- 根据世界频道关键词自动申请加入队伍
- Web 管理后台
- 一批老的压力测试能力：摆摊、金元宝交易、拍卖、聚宝斋、试道等

这套代码是“历史项目持续演进”的状态，功能很多，但配置来源、脚本入口和页面行为并不完全统一。维护时最重要的是先分清：

- 哪些配置只是默认值
- 哪些配置才是运行时实际生效值
- 哪些启动脚本是历史遗留
- 当前到底在看哪个实例、哪个端口

---

## 2. 总体架构

### 2.1 运行模型

- `main.js`
  进程主入口。负责：
  - 读取配置
  - 创建 `Client`
  - 暴露全局控制函数给 REPL
  - 启动 Web 后台
- `client.js`
  负责 AAA / GS 网络协议、登录、鉴权、切服、消息注册和基础连接管理
- `me.js`
  负责角色层逻辑：
  - 地图移动
  - 背包/邮件/任务数据
  - 组队、聊天、摆摊、拍卖等角色指令
- `Instruction.js`
  负责“自动玩法调度器”：
  - 定时执行任务
  - 自动归队 / 自动确认 / 自动同意
  - 自动喊话
  - 自动切换任务类型
- `views/` + `public/`
  Web 后台页面和静态资源
- `config/config.json`
  运行时配置持久化文件
- `data/list.json`
  Web 页面上的账号列表数据源

### 2.2 连接链路

机器人登录流程是：

1. 连 AAA
2. AAA 返回登录 cookie
3. 客户端对登录串加密后发 `CMD_L_ACCOUNT`
4. AAA 返回 `MSG_L_AGENT_RESULT`
5. 客户端再去连 GS
6. 进入角色、地图、任务循环

注意：

- 页面上看到“AAA 未连接 + GS 连接”通常是正常的
- 因为账号在 AAA 阶段完成分发后，后续主要看 GS 是否在线

---

## 3. 目录说明

```text
aiman/
├─ main.js                    主入口；REPL + Web + 批量控制
├─ client.js                  AAA/GS 协议和登录流程
├─ me.js                      角色逻辑
├─ Instruction.js             自动任务调度
├─ cfg.js                     静态默认配置
├─ version.js                 版本号与 ver_code
├─ Const.js                   常量定义
├─ mgr.js                     名字/资源管理
├─ AutoWalk.js                自动寻路
├─ Obstacle.js                障碍点逻辑
├─ MapInfo.js                 地图数据（由 init.bat 生成）
├─ trading_cfg.js             聚宝斋测试配置
├─ data/
│  ├─ data.js                 账号列表读写
│  └─ list.json               Web 页面账号列表
├─ config/
│  └─ config.json             运行时配置持久化文件
├─ views/
│  ├─ index.ejs               首页
│  └─ configView.ejs          配置页
├─ public/                    静态资源
├─ comm/                      协议号、解析器、通用通知定义
├─ convertLua/                Lua 转 JS 工具
├─ tmx/                       地图障碍点/地图资源
├─ init.bat                   资源初始化脚本
├─ run.bat                    历史脚本，当前不建议直接依赖
├─ start_console.sh           Linux 单实例历史脚本
└─ start_multi_console.sh     Linux 多实例历史脚本
```

---

## 4. 环境要求

### 4.1 Node 依赖

`package.json` 当前依赖：

- `async`
- `eis`
- `ejs`
- `express`
- `iconv-lite`
- `lowdb`
- `ws`
- `xml2js`

安装方式：

```bash
npm install
```

### 4.2 Node 版本建议

历史文档中写的是 Linux `node v8.4.0`，但当前仓库已经使用较新的依赖版本。  
建议做法：

- 如果你要跟老环境严格对齐，先确认线上原始 Node 版本
- 如果你在本地新环境跑，优先以“当前项目实际可运行”为准，再逐项验证

### 4.3 资源依赖

`init.bat` 依赖外部工程资源：

- `AsktaoMobile/res/maps/tmx`
- `AsktaoMobile/res/cfg/MapInfo.lua`
- `AsktaoMobile/src/global/CHS.lua`
- `AsktaoMobile/src/global/CHS3.lua`
- 本地 Lua 解释器路径：`D:/Lua/5.1/lua.exe`
- 本地 Node 路径：`D:/nodejs/node`

这说明：

- 本项目不是一个完全自包含仓库
- 地图、中文表、MapInfo 转换依赖外部资源目录

---

## 5. 初始化流程

### 5.1 什么时候需要执行初始化

以下场景建议执行：

- 新机器第一次拉起项目
- 地图资源更新
- `MapInfo.lua` 更新
- `CHS.lua / CHS3.lua` 更新
- `tmx/` 目录缺失
- `MapInfo.js` 缺失或明显过旧

### 5.2 初始化脚本做了什么

`init.bat` 会：

1. 复制地图 `tmx`
2. 复制 `MapInfo.lua`
3. 复制中文表 `CHS.lua / CHS3.lua`
4. 在 `convertLua/` 目录中把 `MapInfo.lua` 转成 `MapInfo.js`

### 5.3 初始化前检查

执行 `init.bat` 前请先确认：

- 上面提到的外部目录真实存在
- `D:/Lua/5.1/lua.exe` 路径有效
- `D:/nodejs/node` 路径有效

如果路径和你机器不一致，需要先改 `init.bat`。

---

## 6. 启动方式

### 6.1 推荐启动方式

当前最稳定、最可控的方式是直接启动：

```bash
node main.js
```

启动后会：

- 起 Web 服务，默认 `http://localhost:3000/home`
- 打开 REPL 控制台（除非设置了 `DISABLE_REPL=1`）

### 6.2 命令行参数

`main.js` 支持以下参数：

```text
node main.js [users_prefix] [users_index_num] [users_start] [users_end] [users_pass]
```

对应关系：

- 参数 1：账号前缀，例如 `A`
- 参数 2：账号数字位数，例如 `4`
- 参数 3：开始编号
- 参数 4：结束编号
- 参数 5：密码

示例：

```bash
node main.js A 4 1 200 A123456
```

注意：

- 这里只覆盖账号生成相关参数
- 服务器地址、端口、区组名等仍然来自配置文件

### 6.3 环境变量

#### `HTTP_PORT`

用于覆盖 Web 服务端口。

示例：

```bash
set HTTP_PORT=3003
node main.js
```

#### `DISABLE_REPL`

设置为 `1` 时不打开 REPL，适合只跑 Web 后台或后台实例。

示例：

```bash
set DISABLE_REPL=1
node main.js
```

### 6.4 多实例调试

本项目支持同机开多个实例，只要分开端口即可。

例如：

```bash
set HTTP_PORT=3001
set DISABLE_REPL=1
node main.js
```

```bash
set HTTP_PORT=3002
set DISABLE_REPL=1
node main.js
```

```bash
set HTTP_PORT=3003
set DISABLE_REPL=1
node main.js
```

实际调试时一定要记住：

- 你改的是哪个实例
- 你看的是哪个端口的页面
- 你查的是哪个实例日志

### 6.5 历史脚本说明

#### `run.bat`

当前仓库里的 `run.bat` 更像历史遗留，不代表现在的标准启动流程，不建议直接依赖。

#### `start_console.sh`

历史 Linux 启动脚本，示例命令是：

```bash
node main.js g 7 ${START_ID} ${END_ID} 1234
```

需要你自己确认参数含义和当前环境是否还适用。

#### `start_multi_console.sh`

历史 Linux 多实例拆分脚本，按每 200 个账号切一组启动。  
适合作为参考，不建议不看内容直接执行。

---

## 7. 配置体系

### 7.1 配置来源优先级

这套项目最容易踩坑的地方，就是“改了 `cfg.js` 但运行不生效”。

实际优先级如下：

1. `config/config.json`
   运行时真实生效配置
2. `cfg.js`
   默认值，仅在 `config/config.json` 缺失某项时初始化写入
3. 启动参数
   仅覆盖部分账号生成参数

也就是说：

- `cfg.js` 更像“默认模板”
- `config/config.json` 才是“当前运行值”

### 7.2 静态配置文件

- 文件：`cfg.js`
- 作用：
  - 提供项目默认配置
  - 提供静态路由、地图、摆摊测试配置等

### 7.3 运行时配置文件

- 文件：`config/config.json`
- 来源：
  - 项目首次启动时由 `main.js` 从 `cfg.js` 写默认值
  - 后续由 Web 配置页或接口 `/api/updateConfig` 持久化修改

### 7.4 核心配置项

| 配置项 | 位置 | 说明 |
|---|---|---|
| `host` | `cfg.js` | AAA 地址 |
| `port` | `cfg.js` | AAA 端口 |
| `http_port` | `cfg.js` | 默认 Web 端口 |
| `dist` | `cfg.js` | 区组名，必须和服务端一致 |
| `gs` | `cfg.js` | 指定登录目标 GS，存在时优先走该服务器 |
| `users_prefix` | `config/config.json` | 账号前缀 |
| `users_index_num` | `config/config.json` | 账号数字位数 |
| `users_start` | `cfg.js` 或命令行 | 起始编号 |
| `users_end` | `cfg.js` 或命令行 | 结束编号 |
| `users_pass` | `config/config.json` | 密码 |
| `enableAutoTask` | `cfg.js` | 自动任务总开关 |
| `debugOn` | `cfg.js` | 调试日志开关 |
| `world_Team` | `config/config.json` | 世界频道组队关键词 |
| `world_chat` | `config/config.json` | 自动喊话语料 |
| `mail_name` | `config/config.json` | 经验邮件名 |
| `mail_equip` | `config/config.json` | 装备邮件名 |
| `mail_pet` | `config/config.json` | 宠物邮件名 |
| `vip_type` | `config/config.json` | 自动购买会员类型 |
| `tempMap` | `cfg.js` | 中转地图 |
| `combatInterval` | `cfg.js` | 战斗回合间隔 |
| `randomWalk` | `cfg.js` | 移动随机值 |

### 7.5 推荐修改方式

推荐优先在 Web 配置页 `/config` 修改：

- 会直接写入 `config/config.json`
- 下次重启仍然保留

如果你直接改 `cfg.js`：

- 只会影响“默认值”
- 已存在的 `config/config.json` 不会自动被覆盖

---

## 8. 账号规则与登录鉴权

### 8.1 账号生成规则

账号名生成逻辑在 `main.js`：

```text
110001 + users_prefix + 左侧补零后的编号
```

例如：

- `users_prefix = A`
- `users_index_num = 4`
- 编号 `1`

生成账号：

```text
110001A0001
```

### 8.2 `110001` 前缀的意义

`110001` 不是普通账号名的一部分，而是区服/渠道前缀。  
登录鉴权时会在 `client.js` 中剥掉：

- `110001wd0001` 会先转成 `wd0001`
- 然后计算 `md5(userId)`
- 再拼成：

```text
userId=wd0001&game=wd&channelNo=110001&token=<md5>
```

所以维护结论是：

- 外部传入时通常要带 `110001`
- 纯 `wd0001` 往往无法按这套逻辑正常通过 AAA

### 8.3 登录状态含义

#### AAA 连接

表示登录/分发阶段是否在线。

#### GS 连接

表示角色是否已经进游戏服。

#### 为什么会出现 “AAA 未连接 + GS 连接”

这是正常现象。  
账号完成 AAA 登录并进入 GS 后，AAA 不一定保持连接。

### 8.4 页面统计的一个已知误区

`main.js` 中 `checkConnections()` 的统计规则是：

- `allConnect` 只统计 AAA 和 GS 同时在线的账号
- `connectAAA` 只统计 AAA 在线
- `connectGs` 只统计 GS 在线
- `lostConnect` 两边都不在线

因此：

- `allConnect` 很容易偏低
- 页面上真正能代表“角色在线”的通常是 `GS连接`

---

## 9. 核心功能说明

### 9.1 自动任务调度

入口文件：`Instruction.js`

调度周期：

- `onInterval0()`：每 10 秒
- `onInterval()`：每 30 秒
- `onInterval3()`：每 30 秒

#### `onInterval0()` 做什么

- 请求归队 `CMD_RETURN_TEAM`
- 自动确认弹窗 `CMD_CONFIRM_RESULT`
- 自动同意队伍请求 `NOTIFY_TEAM_ASK_AGREE`

这意味着：

- 队伍相关弹框很多时候会被自动确认
- 调试“为什么自动同意/自动归队”时先看这里

#### `onInterval()` 做什么

- 自动查询帮派并尝试加入
- 自动任务总调度
- 如果没开 `enableAutoTask`，直接不跑
- 如果没连上 GS，不跑
- 如果在战斗中，不跑
- 根据任务状态切换当前任务类型

当前任务类型有：

- `zhuxian` 主线
- `shimen` 师门
- `bangpai` 帮派
- `chubao` 除暴
- `xiangyao` 降妖

#### 降妖逻辑

`onXiangyaoPrompt()` 会根据：

- 等级
- 当前是否有队
- 当前匹配状态
- 队伍人数

在“队长匹配”和“队员匹配”之间切换。

### 9.2 自动世界喊话

入口：`Instruction.prototype.onInterval3`

逻辑：

1. 仅角色等级 `>= 70` 才可能喊
2. 每 30 秒检查一次
3. 在 `1 ~ cfg.users_end` 中取随机数
4. 只有 `randomInt <= 1` 才真正发
5. 从 `world_chat` 配置里按中英文逗号拆语料
6. 随机取一句发到世界频道

维护注意：

- `users_end` 越大，单个号喊话概率越低
- 这不是固定每 30 秒必喊

### 9.3 世界喊话组队

入口：`me.js` 中 `onMessageEx`

逻辑链路：

1. 只处理 `channel == 2` 的世界消息
2. 读取 `world_Team`
3. 按中英文逗号拆成关键词
4. 用 `msgData.msg.includes(keyword)` 判断是否命中
5. 命中后遍历所有客户端
6. 过滤掉：
   - 发言者自己
   - 等级小于 70
   - 50% 随机跳过
7. 通过后直接发送：

```text
CMD_REQUEST_JOIN
ask_type = request_join
peer_name = 发言人名字
id = 发言人 id
```

#### 这条逻辑的几个重要事实

- 它是“申请加入对方队伍”
- 不是“把对方拉进自己队伍”
- 不会自动记录“上一次被拒绝的人”
- 不会因为被拒绝就永久停止
- 没有固定冷却时间
- 只要下一条世界消息再次命中，就可能再次申请

#### 为什么会“匹配中了但没进队”

常见原因：

- 自己已经在队伍里
- 对方没处理申请
- 对方拒绝了申请
- 这次刚好被 50% 随机跳过
- 账号等级小于 70

#### 相关日志

我已经在代码里补过调试日志，常见格式：

- `matched(关键词)`：说明关键词命中了
- `request_join A -> B`：说明机器人 A 正在申请进 B 的队
- `summary ...`：说明这一轮统计结果

### 9.4 邮件与会员

支持：

- 批量领邮件
- 批量购买会员
- 自动领取新手邮件
- 自动装备、自动宠物相关操作

关键配置：

- `mail_name`
- `mail_equip`
- `mail_pet`
- `vip_type`
- `War_pet`
- `Ride_pet`
- `equip_fly`

### 9.5 压测与专项测试

`main.js` 里保留了较多旧测试函数，主要用于压测或专项系统测试：

- 摆摊
- 金元宝交易
- 拍卖
- 聚宝斋
- 试道大会
- 充值/排队中充值

这些能力很多带有明显“测试服 / 内部环境 / 依赖服务端脚本”的前提，维护时不要直接拿去线上盲跑。

---

## 10. Web 后台操作手册

### 10.1 页面入口

- 首页：`/home`
- 配置页：`/config`

默认端口：

```text
http://localhost:3000/home
```

如果你设置了 `HTTP_PORT=3003`，则入口变为：

```text
http://localhost:3003/home
```

### 10.2 首页功能

首页按钮：

- `全体登录`
  调用 `/api/loginAllClient`
- `全体下线`
  调用 `/api/logoutAll`
- `停止进程`
  调用 `/api/exit`
- `全体降妖`
  调用 `/api/allXiangYao`
- `创建客户端`
  调用 `/api/createLoginAllClinetNum`
- `列表登录`
  把 `data/list.json` 中当前列表账号逐个登录

### 10.3 首页统计卡片

页面每秒轮询一次 `/api/checkConnections`，显示：

- `allConnect`
- `connectAAA`
- `connectGs`
- `lostConnect`

维护时请注意它们的定义，不要把 `allConnect=0` 误认为“全挂了”。

### 10.4 首页账号表格

字段：

- `账号`
- `AAA连接状态`
- `GS连接状态`
- `操作`

每行按钮：

- `登录账号`
  调用 `/api/createLoginClinet`
- `退出登录`
  调用 `/api/logoutSingleAccount`

### 10.5 “创建客户端”弹窗

用途：

- 按当前配置自动生成并登录一批账号

实际调用：

- `POST /api/createLoginAllClinetNum`

逻辑：

- 以 `stratNum` 为当前起点
- 根据 `users_prefix + users_index_num` 生成账号
- 每创建一批就推进起始编号
- 同时写入 `data/list.json`

### 10.6 配置页

配置页展示字段：

- `users_prefix`
- `users_index_num`
- `users_pass`
- `mail_name`
- `mail_equip`
- `mail_pet`
- `War_pet`
- `Ride_pet`
- `equip_fly`
- `vip_type`
- `world_Team`
- `world_chat`

点击“编辑”后会弹出模态框，提交后调用：

- `POST /api/updateConfig`

写入目标：

- `config/config.json`

### 10.7 页面行为说明

- 首页会轮询连接状态
- 账号列表来自 `data/list.json`
- 如果你是通过某些调试手段直接创建并登录账号，而没有写入 `data/list.json`，页面未必能看到它

---

## 11. 控制台 / REPL 操作手册

如果未设置 `DISABLE_REPL=1`，进程启动后会有 REPL，可直接执行全局函数。

### 11.1 账号与登录类

| 命令 | 说明 |
|---|---|
| `createClinet()` | 按 `users_start ~ users_end` 创建客户端对象，不自动登录 |
| `createClinetNum(num)` | 创建一批客户端对象并写入列表，不自动登录 |
| `createLoginClinet(account)` | 创建并登录单个账号 |
| `loginAllClient()` | 登录当前 `clients` 中所有账号 |
| `loginListClient(list)` | 登录指定列表账号 |
| `createLoginAllClinetNum(num)` | 创建并登录一批账号 |
| `logoutAll()` | 所有账号下线 |
| `logoutSingleAccount(account)` | 指定账号下线 |
| `exit()` | 结束当前进程 |

### 11.2 任务与移动类

| 命令 | 说明 |
|---|---|
| `allXiangYao()` | 全体去降妖 |
| `beginAutoWalkAll(mapId, x, y)` | 自动寻路到目标坐标 |
| `autoWalkAll(mapId)` | 按地图既定逻辑自动行走 |
| `stopAutoWalkAll()` | 停止自动行走 |
| `randomBirthPos()` | 前往出生点附近 |
| `randomWalkInMap(mapId)` | 地图随机走动 |
| `simulateWalking(interval)` | 模拟循环过图行走 |
| `walkToLiZongbing()` | 走到李总兵附近 |
| `switchServerAll(num)` | 批量换线 |
| `teleportTest(num)` | 天墉城 / 揽仙镇外来回切图测试 |
| `teamMatchMember(type)` | 以队员身份开始匹配 |
| `teamMatchTeam(type)` | 以队长身份开始匹配 |
| `walkInShiDaoChang()` | 试道场内随机移动 |

### 11.3 战斗与调试类

| 命令 | 说明 |
|---|---|
| `setAutoFightAll(true/false)` | 批量开关自动战斗 |
| `autoCombatTest(type)` | 自动战斗专项测试 |
| `startSendRecvTest(num)` | 收发包测试 |
| `setShowMoreUsersAll(flag)` | 设置是否显示更多玩家 |
| `setDebugOn(flag)` | 打开或关闭消息调试 |
| `sendTestCmd(cmd)` | 发聊天栏命令 |
| `autoChannelTest(num)` | 聊天频道测试 |

### 11.4 状态类

| 命令 | 说明 |
|---|---|
| `checkConnections()` | 统计连接情况 |
| `traceConnections(type)` | 打印指定状态账号，`lost/aaa/gs` |
| `checkClientStatus(account)` | 打印指定账号连接状态 |
| `checkClientStatusObject(account)` | 返回对象状态 |
| `printAllClientStatus()` | 打印全部账号连接状态 |

### 11.5 邮件与会员类

| 命令 | 说明 |
|---|---|
| `receiveAllMail(title)` | 全部账号领取指定标题邮件 |
| `allClientBuyVip(type)` | 全部账号购买会员，1 月卡 / 2 季卡 / 3 年卡 |

### 11.6 压测类

保留命令很多，这里只列主入口：

- `stallPutAwayGoods()`
- `stallRemoveGoods()`
- `stallSearchGoods()`
- `stallBuyGoods()`
- `stallTakeCash()`

- `goldStallPutAwayGoods()`
- `goldStallRemoveGoods()`
- `goldStallSearchGoods()`
- `goldStallBuyGoods()`
- `goldStallTakeCash()`

- `auctionBidGoods(timeDesc, interval, count)`
- `tradingSellRole(timeDesc, cocurrentNum, interval)`
- `tradingCancelRole(timeDesc)`
- `tradingBuyRole(timeDesc)`

- `rechargeGoldCoin()`
- `waitLineCharge(num)`
- `waitLineBuyInsider(num)`

这些命令的环境前置条件较多，建议结合源码和服务端配套脚本使用。

---

## 12. HTTP API 一览

| 方法 | 路径 | 说明 |
|---|---|---|
| `GET` | `/home` | 首页 |
| `GET` | `/config` | 配置页 |
| `GET` | `/api/loginAllClient` | 登录所有当前客户端 |
| `GET` | `/api/logoutAll` | 所有当前客户端下线 |
| `GET` | `/api/exit` | 结束当前进程 |
| `GET` | `/api/allXiangYao` | 全体降妖 |
| `GET` | `/api/checkConnections` | 获取连接统计 |
| `GET` | `/api/getUserDataList` | 获取页面账号列表并刷新状态 |
| `POST` | `/api/createLoginAllClinetNum` | 创建并登录一批账号 |
| `GET` | `/api/createLoginAllClinetNum?value=n` | 同上，便于调试 |
| `POST` | `/api/createLoginClinet` | 创建并登录单个账号 |
| `GET` | `/api/createLoginClinet?account=...` | 同上，便于调试 |
| `POST` | `/api/loginListClient` | 登录列表中的账号 |
| `POST` | `/api/logoutSingleAccount` | 退出单个账号 |
| `GET` | `/api/getConfig` | 读取运行时配置 |
| `POST` | `/api/updateConfig` | 更新运行时配置 |

注意：

- 接口名里有历史拼写 `Clinet`
- 属于现状，不建议在没同步前后端的情况下随意改名

---

## 13. 数据文件与日志

### 13.1 `config/config.json`

运行时真实配置源。  
Web 配置页修改的就是它。

### 13.2 `data/list.json`

Web 页面账号列表来源。  
只要账号是通过“创建客户端”流程创建的，通常会写入这里。

### 13.3 `version.js`

包含：

- `ver`
- `ver_code`

如果服务端版本或客户端签名校验变了，这里要同步。

### 13.4 `cfg.logPath`

默认是：

```text
./log
```

用于项目自身日志输出。

### 13.5 `.codex_tmp/*.log`

这是本地调试时常用的实例日志目录，不是项目原生强绑定目录。  
如果你采用多实例方式跑，可以像这样分别看：

- `.codex_tmp/main3001.out.log`
- `.codex_tmp/main3002.out.log`
- `.codex_tmp/main3003.out.log`

---

## 14. 关键实现逻辑详解

### 14.1 为什么改了 `cfg.js` 没生效

因为运行时优先读 `config/config.json`。  
`cfg.js` 只在缺字段时充当默认值。

### 14.2 为什么网页点“登录账号”时会先连 AAA

因为 AAA 是登录分发入口，GS 是游戏服入口。  
这是正常登录链路，不是异常行为。

### 14.3 为什么“AAA 未连接 + GS 连接”是正常的

角色已经完成 AAA 分发并进入 GS 后，AAA 不一定保持连接。

### 14.4 世界喊话组队的完整链路

1. 对方在世界频道发消息
2. 我方收到 `MSG_MESSAGE_EX`
3. 用 `world_Team` 关键词 `includes` 匹配
4. 满足等级与随机条件后发 `CMD_REQUEST_JOIN`
5. 服务器可能返回：
   - 已发出申请，请等待
   - 已经在队伍中了
   - 对方拒绝了你的申请
   - 成功更新队伍列表

### 14.5 为什么“来人”和“万年”命中了，但结果不一样

关键词配置本身没有区别。  
不同结果通常来自运行时状态不同：

- 自己当时是否已经在队伍中
- 是否被 50% 随机跳过
- 对方是否同意
- 对方是否重复喊话

### 14.6 为什么拒绝之后还会继续申请

因为当前代码：

- 没有被拒绝冷却
- 没有同一对象去重
- 没有“同一条消息只申请一次”的强约束

只要下一条世界消息再次命中，就可能再次申请。

---

## 15. 常见问题排查

### 15.1 改了关键词但页面和日志都不变

检查顺序：

1. 你改的是不是 `config/config.json`
2. 当前看的实例是不是正确端口
3. 日志里有没有 `matched(...)`
4. `debugOn` 是否打开

### 15.2 `来人` 不生效但 `万年` 生效

排查点：

1. 配置文件里是否真的包含 `来人`
2. 当前实例是否已加载新配置
3. 日志里是否有 `matched(来人)`
4. 如果命中了但没进队，再看：
   - 是否“你已经在队伍中了！”
   - 是否“你已发出申请，请耐心等待。”
   - 是否“对方拒绝了你的申请。”

### 15.3 `wd0001` 登录失败，`110001wd0001` 才能进

这是正常现象。  
因为登录鉴权默认按 `110001` 渠道前缀处理。

### 15.4 网页里看不到某个账号，但日志里它明明在跑

通常是：

- 这个账号不是通过“创建客户端”流程写入 `data/list.json`
- 所以页面列表里没有它

### 15.5 首页 `allConnect=0`，是不是全挂了

不一定。  
先看：

- `connectGs`
- 单账号 `gs` 状态

### 15.6 页面显示乱码 / 文件里中文异常

仓库中存在历史编码问题。  
维护建议：

- 统一以 UTF-8 保存新增文档
- 对历史中文字符串修改前先备份
- 不要在不确认编码的情况下批量替换

---

## 16. 已知问题与维护建议

### 16.1 已知问题

1. `allConnect` 统计口径容易误导
2. `world team` 逻辑没有拒绝冷却
3. 世界组队逻辑不会先自动退队再申请
4. `data/list.json` 与实际在线客户端可能不一致
5. 历史脚本 `run.bat`、`start_console.sh`、`start_multi_console.sh` 与当前推荐流程不完全一致
6. 代码和页面中存在一些中文编码问题
7. `/api/loginListClient` 当前实现里使用了 `res.join({})`，这是一个明显不标准写法，后续建议修正为 `res.json({})`

### 16.2 推荐维护顺序

如果你以后要继续维护，建议优先做这几件事：

1. 统一文档、配置源、启动方式
2. 修复页面统计口径
3. 给世界组队加拒绝冷却和重复申请控制
4. 让“当前 clients”与 `data/list.json` 状态更一致
5. 逐步清理历史脚本和编码问题

### 16.3 功能扩展时建议优先看哪里

| 需求 | 首先看 |
|---|---|
| 登录 / 鉴权 / 断线重连 | `client.js` |
| 角色动作 / 地图 / 队伍 / 聊天 | `me.js` |
| 自动任务行为 | `Instruction.js` |
| 页面按钮和接口 | `main.js`、`views/` |
| 配置持久化 | `main.js`、`cfg.js`、`config/config.json` |
| 页面账号列表 | `data/data.js`、`data/list.json` |

---

## 17. 推荐日常维护流程

### 修改配置

1. 先确认当前使用的实例端口
2. 优先在 `/config` 页面改
3. 改完立即查日志确认是否生效

### 启动调试实例

1. 指定 `HTTP_PORT`
2. 视情况关闭 REPL
3. 保留独立日志文件
4. 不直接和生产实例混用页面

### 排查“功能没生效”

1. 先确认有没有命中日志
2. 再确认有没有发请求日志
3. 最后确认服务器回包是等待、拒绝还是成功

这个顺序最省时间。

---

## 18. 结论

这套项目能做的事情很多，但维护难点主要集中在三类：

- 配置来源不统一
- 页面状态与实际运行状态不完全同步
- 自动逻辑多、定时器多、历史代码多

只要先抓住下面这三点，后续维护会顺很多：

1. `config/config.json` 才是运行时真实配置
2. `client.js / me.js / Instruction.js` 是核心三层
3. Web 页只是一个管理入口，真实行为一定以日志和代码为准

