
## 10. Web 鍚庡彴鎿嶄綔鎵嬪唽

### 10.1 椤甸潰鍏ュ彛

- 棣栭〉锛歚/home`
- 閰嶇疆椤碉細`/config`

榛樿绔彛锛?
```text
http://localhost:3000/home
```

濡傛灉浣犺缃簡 `HTTP_PORT=3003`锛屽垯鍏ュ彛鍙樹负锛?
```text
http://localhost:3003/home
```

### 10.2 棣栭〉鍔熻兘

棣栭〉鎸夐挳锛?
- `鍏ㄤ綋鐧诲綍`
  璋冪敤 `/api/loginAllClient`
- `鍏ㄤ綋涓嬬嚎`
  璋冪敤 `/api/logoutAll`
- `鍋滄杩涚▼`
  璋冪敤 `/api/exit`
- `鍏ㄤ綋闄嶅`
  璋冪敤 `/api/allXiangYao`
- `鍒涘缓瀹㈡埛绔痐
  璋冪敤 `/api/createLoginAllClinetNum`
- `鍒楄〃鐧诲綍`
  鎶?`data/list.json` 涓綋鍓嶅垪琛ㄨ处鍙烽€愪釜鐧诲綍

### 10.3 棣栭〉缁熻鍗＄墖

椤甸潰姣忕杞涓€娆?`/api/checkConnections`锛屾樉绀猴細

- `allConnect`
- `connectAAA`
- `connectGs`
- `lostConnect`

缁存姢鏃惰娉ㄦ剰瀹冧滑鐨勫畾涔夛紝涓嶈鎶?`allConnect=0` 璇涓衡€滃叏鎸備簡鈥濄€?
### 10.4 棣栭〉璐﹀彿琛ㄦ牸

瀛楁锛?
- `璐﹀彿`
- `AAA杩炴帴鐘舵€乣
- `GS杩炴帴鐘舵€乣
- `鎿嶄綔`

姣忚鎸夐挳锛?
- `鐧诲綍璐﹀彿`
  璋冪敤 `/api/createLoginClinet`
- `閫€鍑虹櫥褰昤
  璋冪敤 `/api/logoutSingleAccount`

### 10.5 鈥滃垱寤哄鎴风鈥濆脊绐?
鐢ㄩ€旓細

- 鎸夊綋鍓嶉厤缃嚜鍔ㄧ敓鎴愬苟鐧诲綍涓€鎵硅处鍙?
瀹為檯璋冪敤锛?
- `POST /api/createLoginAllClinetNum`

閫昏緫锛?
- 浠?`stratNum` 涓哄綋鍓嶈捣鐐?- 鏍规嵁 `users_prefix + users_index_num` 鐢熸垚璐﹀彿
- 姣忓垱寤轰竴鎵瑰氨鎺ㄨ繘璧峰缂栧彿
- 鍚屾椂鍐欏叆 `data/list.json`

### 10.6 閰嶇疆椤?
閰嶇疆椤靛睍绀哄瓧娈碉細

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

鐐瑰嚮鈥滅紪杈戔€濆悗浼氬脊鍑烘ā鎬佹锛屾彁浜ゅ悗璋冪敤锛?
- `POST /api/updateConfig`

鍐欏叆鐩爣锛?
- `config/config.json`

### 10.7 椤甸潰琛屼负璇存槑

- 棣栭〉浼氳疆璇㈣繛鎺ョ姸鎬?- 璐﹀彿鍒楄〃鏉ヨ嚜 `data/list.json`
- 濡傛灉浣犳槸閫氳繃鏌愪簺璋冭瘯鎵嬫鐩存帴鍒涘缓骞剁櫥褰曡处鍙凤紝鑰屾病鏈夊啓鍏?`data/list.json`锛岄〉闈㈡湭蹇呰兘鐪嬪埌瀹?
---

## 11. 鎺у埗鍙?/ REPL 鎿嶄綔鎵嬪唽

濡傛灉鏈缃?`DISABLE_REPL=1`锛岃繘绋嬪惎鍔ㄥ悗浼氭湁 REPL锛屽彲鐩存帴鎵ц鍏ㄥ眬鍑芥暟銆?
### 11.1 璐﹀彿涓庣櫥褰曠被

| 鍛戒护 | 璇存槑 |
|---|---|
| `createClinet()` | 鎸?`users_start ~ users_end` 鍒涘缓瀹㈡埛绔璞★紝涓嶈嚜鍔ㄧ櫥褰?|
| `createClinetNum(num)` | 鍒涘缓涓€鎵瑰鎴风瀵硅薄骞跺啓鍏ュ垪琛紝涓嶈嚜鍔ㄧ櫥褰?|
| `createLoginClinet(account)` | 鍒涘缓骞剁櫥褰曞崟涓处鍙?|
| `loginAllClient()` | 鐧诲綍褰撳墠 `clients` 涓墍鏈夎处鍙?|
| `loginListClient(list)` | 鐧诲綍鎸囧畾鍒楄〃璐﹀彿 |
| `createLoginAllClinetNum(num)` | 鍒涘缓骞剁櫥褰曚竴鎵硅处鍙?|
| `logoutAll()` | 鎵€鏈夎处鍙蜂笅绾?|
| `logoutSingleAccount(account)` | 鎸囧畾璐﹀彿涓嬬嚎 |
| `exit()` | 缁撴潫褰撳墠杩涚▼ |

### 11.2 浠诲姟涓庣Щ鍔ㄧ被

| 鍛戒护 | 璇存槑 |
|---|---|
| `allXiangYao()` | 鍏ㄤ綋鍘婚檷濡?|
| `beginAutoWalkAll(mapId, x, y)` | 鑷姩瀵昏矾鍒扮洰鏍囧潗鏍?|
| `autoWalkAll(mapId)` | 鎸夊湴鍥炬棦瀹氶€昏緫鑷姩琛岃蛋 |
| `stopAutoWalkAll()` | 鍋滄鑷姩琛岃蛋 |
| `randomBirthPos()` | 鍓嶅線鍑虹敓鐐归檮杩?|
| `randomWalkInMap(mapId)` | 鍦板浘闅忔満璧板姩 |
| `simulateWalking(interval)` | 妯℃嫙寰幆杩囧浘琛岃蛋 |
| `walkToLiZongbing()` | 璧板埌鏉庢€诲叺闄勮繎 |
| `switchServerAll(num)` | 鎵归噺鎹㈢嚎 |
| `teleportTest(num)` | 澶╁鍩?/ 鎻戒粰闀囧鏉ュ洖鍒囧浘娴嬭瘯 |
| `teamMatchMember(type)` | 浠ラ槦鍛樿韩浠藉紑濮嬪尮閰?|
| `teamMatchTeam(type)` | 浠ラ槦闀胯韩浠藉紑濮嬪尮閰?|
| `walkInShiDaoChang()` | 璇曢亾鍦哄唴闅忔満绉诲姩 |

### 11.3 鎴樻枟涓庤皟璇曠被

| 鍛戒护 | 璇存槑 |
|---|---|
| `setAutoFightAll(true/false)` | 鎵归噺寮€鍏宠嚜鍔ㄦ垬鏂?|
| `autoCombatTest(type)` | 鑷姩鎴樻枟涓撻」娴嬭瘯 |
| `startSendRecvTest(num)` | 鏀跺彂鍖呮祴璇?|
| `setShowMoreUsersAll(flag)` | 璁剧疆鏄惁鏄剧ず鏇村鐜╁ |
| `setDebugOn(flag)` | 鎵撳紑鎴栧叧闂秷鎭皟璇?|
| `sendTestCmd(cmd)` | 鍙戣亰澶╂爮鍛戒护 |
| `autoChannelTest(num)` | 鑱婂ぉ棰戦亾娴嬭瘯 |

### 11.4 鐘舵€佺被

| 鍛戒护 | 璇存槑 |
|---|---|
| `checkConnections()` | 缁熻杩炴帴鎯呭喌 |
| `traceConnections(type)` | 鎵撳嵃鎸囧畾鐘舵€佽处鍙凤紝`lost/aaa/gs` |
| `checkClientStatus(account)` | 鎵撳嵃鎸囧畾璐﹀彿杩炴帴鐘舵€?|
| `checkClientStatusObject(account)` | 杩斿洖瀵硅薄鐘舵€?|
| `printAllClientStatus()` | 鎵撳嵃鍏ㄩ儴璐﹀彿杩炴帴鐘舵€?|
