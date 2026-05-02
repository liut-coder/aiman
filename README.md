# 智能假人系统文档入口

项目详细文档已经拆分到 `docs/` 目录，根 README 只保留导航和常用入口。

## 文档入口

- [docs/README.md](./docs/README.md)
- [docs/01-overview-and-init.md](./docs/01-overview-and-init.md)
- [docs/02-startup-and-deploy.md](./docs/02-startup-and-deploy.md)
- [docs/03-config-and-auth.md](./docs/03-config-and-auth.md)
- [docs/04-features-and-logic.md](./docs/04-features-and-logic.md)
- [docs/05-web-console-api.md](./docs/05-web-console-api.md)
- [docs/06-data-troubleshooting-and-maintenance.md](./docs/06-data-troubleshooting-and-maintenance.md)
- [docs/07-batch-account-console.md](./docs/07-batch-account-console.md)

## 常用脚本

- Windows 本地脚本：`scripts/local/`
- Linux 运维脚本：`scripts/linux/`

## 一键部署

Debian 服务器可直接执行：

```bash
curl -fsSL https://raw.githubusercontent.com/liut-coder/aiman/debian-docker/scripts/linux/install.sh | bash
```

自定义安装目录：

```bash
curl -fsSL https://raw.githubusercontent.com/liut-coder/aiman/debian-docker/scripts/linux/install.sh | TARGET_DIR=/srv/aiman bash
```

详细说明见 [docs/02-startup-and-deploy.md](./docs/02-startup-and-deploy.md)。

## 推荐阅读顺序

1. 先看 `01-overview-and-init`
2. 再看 `02-startup-and-deploy`
3. 改配置前看 `03-config-and-auth`
4. 查功能逻辑看 `04-features-and-logic`
5. 看后台操作和接口时看 `05-web-console-api`
6. 排错和日常维护看 `06-data-troubleshooting-and-maintenance`
7. 批量导号和 Web 控制台操作看 `07-batch-account-console`
