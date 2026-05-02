# 智能假人系统文档入口

项目文档已经从单个大 `README.md` 拆分到 `docs/` 目录，后续维护建议按分类阅读，不再把所有内容堆在一个文件里。

## 快速入口

- [docs/01-overview-and-init.md](./docs/01-overview-and-init.md)
  项目定位、总体架构、目录说明、环境要求、初始化流程
- [docs/02-startup-and-deploy.md](./docs/02-startup-and-deploy.md)
  启动方式、环境变量、多实例调试、历史脚本、Debian / Docker 启动
- [docs/03-config-and-auth.md](./docs/03-config-and-auth.md)
  配置体系、配置优先级、账号规则、登录鉴权、AAA / GS 状态说明
- [docs/04-features-and-logic.md](./docs/04-features-and-logic.md)
  自动任务、自动喊话、世界组队、邮件会员、核心实现逻辑
- [docs/05-web-console-api.md](./docs/05-web-console-api.md)
  Web 后台操作手册、控制台 / REPL 命令、HTTP API
- [docs/06-data-troubleshooting-and-maintenance.md](./docs/06-data-troubleshooting-and-maintenance.md)
  数据文件、日志、关键逻辑说明、常见问题、维护建议、日常流程

## 推荐阅读顺序

1. 先看 `01-overview-and-init`
2. 再看 `02-startup-and-deploy`
3. 改配置前看 `03-config-and-auth`
4. 查功能逻辑看 `04-features-and-logic`
5. 操作后台或接口时看 `05-web-console-api`
6. 排错和日常维护看 `06-data-troubleshooting-and-maintenance`

## 维护约定

1. 根目录 `README.md` 只保留导航和总入口
2. 详细内容按主题维护在 `docs/`
3. 后续新增文档优先追加到对应分类，不再回到单文件大杂烩
4. 每次文档结构调整，记得同步更新 [WORKLOG.md](/c:/Users/Lucas/aiman/WORKLOG.md)
