鐢ㄤ簬瑕嗙洊 Web 鏈嶅姟绔彛銆?
绀轰緥锛?
```bash
set HTTP_PORT=3003
node main.js
```

#### `DISABLE_REPL`

璁剧疆涓?`1` 鏃朵笉鎵撳紑 REPL锛岄€傚悎鍙窇 Web 鍚庡彴鎴栧悗鍙板疄渚嬨€?
绀轰緥锛?
```bash
set DISABLE_REPL=1
node main.js
```

### 6.4 澶氬疄渚嬭皟璇?
鏈」鐩敮鎸佸悓鏈哄紑澶氫釜瀹炰緥锛屽彧瑕佸垎寮€绔彛鍗冲彲銆?
渚嬪锛?
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

瀹為檯璋冭瘯鏃朵竴瀹氳璁颁綇锛?
- 浣犳敼鐨勬槸鍝釜瀹炰緥
- 浣犵湅鐨勬槸鍝釜绔彛鐨勯〉闈?- 浣犳煡鐨勬槸鍝釜瀹炰緥鏃ュ織

### 6.5 鍘嗗彶鑴氭湰璇存槑

#### `run.bat`

褰撳墠浠撳簱閲岀殑 `run.bat` 鏇村儚鍘嗗彶閬楃暀锛屼笉浠ｈ〃鐜板湪鐨勬爣鍑嗗惎鍔ㄦ祦绋嬶紝涓嶅缓璁洿鎺ヤ緷璧栥€?
#### `start_console.sh`

鍘嗗彶 Linux 鍚姩鑴氭湰锛岀ず渚嬪懡浠ゆ槸锛?
```bash
node main.js g 7 ${START_ID} ${END_ID} 1234
```

闇€瑕佷綘鑷繁纭鍙傛暟鍚箟鍜屽綋鍓嶇幆澧冩槸鍚﹁繕閫傜敤銆?
#### `start_multi_console.sh`

鍘嗗彶 Linux 澶氬疄渚嬫媶鍒嗚剼鏈紝鎸夋瘡 200 涓处鍙峰垏涓€缁勫惎鍔ㄣ€? 
閫傚悎浣滀负鍙傝€冿紝涓嶅缓璁笉鐪嬪唴瀹圭洿鎺ユ墽琛屻€?
---

### 6.6 Debian / Docker 鍚姩鏂瑰紡

褰撳墠浠撳簱宸茬粡琛ヤ簡涓€鐗?Debian 瀹瑰櫒鍖栬繍琛岄鏋讹紝鐩爣鏄厛鎶婃湇鍔＄ǔ瀹氳窇璧锋潵锛?
- `Dockerfile`
- `docker-compose.yml`
- `docker/entrypoint.sh`
- `.dockerignore`

杩欎竴鐗堢殑瀹氫綅鏄細

1. 鍏堝湪 Debian 涓婃妸 Node 鏈嶅姟鍜?Web 鍚庡彴璺戣捣鏉?2. 淇濈暀 `config`銆乣data`銆乣log` 鎸佷箙鍖?3. 鏆傛椂涓嶅湪瀹瑰櫒閲屾墽琛?`init.bat`
4. 鐩存帴澶嶇敤浠撳簱閲岀幇鎴愮殑 `MapInfo.js` 鍜?`tmx/`

#### 鐩存帴鐢?Docker 鍚姩

```bash
docker build -t aiman:debian .
docker run -d \
  --name aiman \
  -p 3000:3000 \
  -e HTTP_PORT=3000 \
  -e DISABLE_REPL=1 \
  -e TZ=Asia/Shanghai \
  -v $(pwd)/config:/app/config \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/log:/app/log \
  aiman:debian
```

#### 鐢?Docker Compose 鍚姩

濡傛灉浣犵殑 Debian 瑁呯殑鏄柊鐗堟彃浠讹細

```bash
docker compose up -d --build
```

濡傛灉浣犵殑鐜鏄€佸懡浠わ細

```bash
docker-compose up -d --build
```

#### 瀹瑰櫒杩愯绾︽潫

1. 鎺ㄨ崘閫氳繃鐜鍙橀噺鍥哄畾 `DISABLE_REPL=1`
2. Web 绔彛閫氳繃 `HTTP_PORT` 鎺у埗
3. `config/config.json`銆乣data/list.json`銆乣log/` 寤鸿閮芥寕鍗?4. 濡傛灉鎸傜殑鏄┖鐩綍锛屽叆鍙ｈ剼鏈細鑷姩鍐欏叆榛樿 `config.json` 鍜?`list.json`
5. 褰撳墠瀹瑰櫒鏂规涓嶈礋璐ｇ敓鎴?`MapInfo.js`锛岄粯璁や娇鐢ㄤ粨搴撳凡鏈夋枃浠?
#### Debian 绗竴鐗堟帹鑽愮洰鏍?
鍏堝畬鎴愯繖鍥涗欢浜嬪氨澶熶簡锛?
1. 瀹瑰櫒鍙惎鍔?2. `/home` 椤甸潰鍙闂?3. 閰嶇疆椤靛彲淇敼骞舵寔涔呭寲
4. 鍩虹鐧诲綍涓庤嚜鍔ㄩ€昏緫浠嶆寜鍘熼」鐩柟寮忚繍琛?
## 7. 閰嶇疆浣撶郴

### 7.1 閰嶇疆鏉ユ簮浼樺厛绾?
杩欏椤圭洰鏈€瀹规槗韪╁潙鐨勫湴鏂癸紝灏辨槸鈥滄敼浜?`cfg.js` 浣嗚繍琛屼笉鐢熸晥鈥濄€?
瀹為檯浼樺厛绾у涓嬶細

1. `config/config.json`
   杩愯鏃剁湡瀹炵敓鏁堥厤缃?2. `cfg.js`
   榛樿鍊硷紝浠呭湪 `config/config.json` 缂哄け鏌愰」鏃跺垵濮嬪寲鍐欏叆
3. 鍚姩鍙傛暟
   浠呰鐩栭儴鍒嗚处鍙风敓鎴愬弬鏁?
涔熷氨鏄锛?
- `cfg.js` 鏇村儚鈥滈粯璁ゆā鏉库€?- `config/config.json` 鎵嶆槸鈥滃綋鍓嶈繍琛屽€尖€?
### 7.2 闈欐€侀厤缃枃浠?
- 鏂囦欢锛歚cfg.js`
- 浣滅敤锛?  - 鎻愪緵椤圭洰榛樿閰嶇疆
  - 鎻愪緵闈欐€佽矾鐢便€佸湴鍥俱€佹憜鎽婃祴璇曢厤缃瓑

### 7.3 杩愯鏃堕厤缃枃浠?
- 鏂囦欢锛歚config/config.json`
- 鏉ユ簮锛?  - 椤圭洰棣栨鍚姩鏃剁敱 `main.js` 浠?`cfg.js` 鍐欓粯璁ゅ€?  - 鍚庣画鐢?Web 閰嶇疆椤垫垨鎺ュ彛 `/api/updateConfig` 鎸佷箙鍖栦慨鏀?
### 7.4 鏍稿績閰嶇疆椤?
| 閰嶇疆椤?| 浣嶇疆 | 璇存槑 |
|---|---|---|
| `host` | `cfg.js` | AAA 鍦板潃 |
| `port` | `cfg.js` | AAA 绔彛 |
| `http_port` | `cfg.js` | 榛樿 Web 绔彛 |
| `dist` | `cfg.js` | 鍖虹粍鍚嶏紝蹇呴』鍜屾湇鍔＄涓€鑷?|
| `gs` | `cfg.js` | 鎸囧畾鐧诲綍鐩爣 GS锛屽瓨鍦ㄦ椂浼樺厛璧拌鏈嶅姟鍣?|
| `users_prefix` | `config/config.json` | 璐﹀彿鍓嶇紑 |
| `users_index_num` | `config/config.json` | 璐﹀彿鏁板瓧浣嶆暟 |
| `users_start` | `cfg.js` 鎴栧懡浠よ | 璧峰缂栧彿 |
| `users_end` | `cfg.js` 鎴栧懡浠よ | 缁撴潫缂栧彿 |
| `users_pass` | `config/config.json` | 瀵嗙爜 |
| `enableAutoTask` | `cfg.js` | 鑷姩浠诲姟鎬诲紑鍏?|
| `debugOn` | `cfg.js` | 璋冭瘯鏃ュ織寮€鍏?|
| `world_Team` | `config/config.json` | 涓栫晫棰戦亾缁勯槦鍏抽敭璇?|
| `world_chat` | `config/config.json` | 鑷姩鍠婅瘽璇枡 |
| `mail_name` | `config/config.json` | 缁忛獙閭欢鍚?|
| `mail_equip` | `config/config.json` | 瑁呭閭欢鍚?|
| `mail_pet` | `config/config.json` | 瀹犵墿閭欢鍚?|
| `vip_type` | `config/config.json` | 鑷姩璐拱浼氬憳绫诲瀷 |
| `tempMap` | `cfg.js` | 涓浆鍦板浘 |
| `combatInterval` | `cfg.js` | 鎴樻枟鍥炲悎闂撮殧 |
| `randomWalk` | `cfg.js` | 绉诲姩闅忔満鍊?|

### 7.5 鎺ㄨ崘淇敼鏂瑰紡

鎺ㄨ崘浼樺厛鍦?Web 閰嶇疆椤?`/config` 淇敼锛?
- 浼氱洿鎺ュ啓鍏?`config/config.json`
- 涓嬫閲嶅惎浠嶇劧淇濈暀

濡傛灉浣犵洿鎺ユ敼 `cfg.js`锛?
- 鍙細褰卞搷鈥滈粯璁ゅ€尖€?- 宸插瓨鍦ㄧ殑 `config/config.json` 涓嶄細鑷姩琚鐩?
---

## 8. 璐﹀彿瑙勫垯涓庣櫥褰曢壌鏉?
### 8.1 璐﹀彿鐢熸垚瑙勫垯

璐﹀彿鍚嶇敓鎴愰€昏緫鍦?`main.js`锛?
```text
110001 + users_prefix + 宸︿晶琛ラ浂鍚庣殑缂栧彿
```

渚嬪锛?
- `users_prefix = A`
- `users_index_num = 4`
- 缂栧彿 `1`

---

## 附录 A：项目内置脚本

### Windows 本地脚本

位置：

- `scripts/local/start.ps1`
- `scripts/local/stop.ps1`
- `scripts/local/status.ps1`

常用方式：

```powershell
npm run local:start
npm run local:status
npm run local:stop
```

直接指定端口：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\local\start.ps1 -Ports 3000,3001,3002,3003
powershell -ExecutionPolicy Bypass -File .\scripts\local\status.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\local\stop.ps1
```

说明：

1. 脚本会把实例状态写到 `.codex_tmp/local/instances/`
2. 默认关闭 REPL，适合本地多实例调试
3. 第一个实例如需保留 REPL，可加 `-PrimaryWithRepl`
4. 端口被旧实例占用时，可加 `-Force`

### Linux 运维脚本

位置：

- `scripts/linux/deploy.sh`
- `scripts/linux/logs.sh`
- `scripts/linux/status.sh`
- `scripts/linux/restart.sh`
- `scripts/linux/stop.sh`
- `scripts/linux/update.sh`

常用方式：

```bash
sh ./scripts/linux/deploy.sh
sh ./scripts/linux/status.sh
sh ./scripts/linux/logs.sh
sh ./scripts/linux/restart.sh
sh ./scripts/linux/stop.sh
sh ./scripts/linux/update.sh
```

## 附录 B：Debian 最佳实践快速开始

一键部署，不需要 `git clone`：

```bash
curl -fsSL https://raw.githubusercontent.com/liut-coder/aiman/debian-docker/scripts/linux/install.sh | bash
```

自定义安装目录：

```bash
curl -fsSL https://raw.githubusercontent.com/liut-coder/aiman/debian-docker/scripts/linux/install.sh | TARGET_DIR=/srv/aiman bash
```

说明：

1. 脚本会直接下载 `debian-docker` 分支压缩包
2. 默认安装到 `/opt/aiman`
3. 会尽量保留已有的 `config/`、`data/`、`log/`
4. 如果系统缺少 `curl`、`tar`、`docker`，会尝试自动安装
5. 结束后会自动执行 `sh ./scripts/linux/deploy.sh`

首次部署：

```bash
apt update && apt install -y git docker.io docker-compose
git clone -b debian-docker https://github.com/liut-coder/aiman.git
cd aiman
sh ./scripts/linux/deploy.sh
```

日常查看：

```bash
cd aiman
sh ./scripts/linux/status.sh
sh ./scripts/linux/logs.sh
```

更新并重建：

```bash
cd aiman
sh ./scripts/linux/update.sh
```

重启：

```bash
cd aiman
sh ./scripts/linux/restart.sh
```

停止：

```bash
cd aiman
sh ./scripts/linux/stop.sh
```

推荐习惯：

1. 固定运行 `debian-docker` 分支
2. 优先使用 `scripts/linux/*.sh`
3. 保留 `config/`、`data/`、`log/`
4. 每次更新后先看容器状态，再看日志

