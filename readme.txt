【【【重要说明】】】
    【整个工程目录使用 VsCode 打开，按 F5 可直接运行调试。】
    【外网需要自动寻路、战斗、做任务时，需要将 ..\ConsoleCmds 拷贝到 ..\a01\server_scripts\gs\cmds\ 中进行打包版本。内网测试一样要拷贝】
    【由于机器人代码越来月复杂，所以建议一个 console 跑 200 个机器人】
    【Linux 环境下需要安装 node 环境 (版本：v8.4.0，模块：(npm install --save xxx)：async、xml2js)】
    【开机器人需要配置1亿金币上线邮件维持机器人日常储备，可配置金币自动购买会员也可以配置邮件月卡，配置宠物，装备和飞行器，经验，邮件，分为三个邮件】
配置文件 cfg.js 中相关配置项说明:
    host 配置 aaa 服务器 ip
    port 配置 aaa 服务器的端口
    dist 配置区组名
    users 配置登录的帐号信息
    walkPath 配置行走路径信息，目前配置了四个地图的行走路径，分别是揽仙镇1000、东海渔村11000、无名小镇23000和官道北24000。官道北是练功区地图，在该地图上行走可触发战斗，其他的三个地图为非练功区地图
    combatInterval  : 战斗回合间隔（毫秒）
    randomWalk      : simulateWalking中相信两步移动随机增加值（毫秒）
    userGroup       : 玩家组，每个console每次只上200人，防止登录失败
    enableAutoTask  : 自动跑任务，默认开启

运行前需要先生成一批帐号，然后在 cfg.js 中进行配置
运行 run.bat 前必须先运行 init.bat 拷贝障碍点信息及获取 MapInfo 配表
运行 run.bat 参数说明:
    执行文件路径 主入口 账号前缀 账号数字位数 起始编号 截止编号 登录密码

运行起来后，是一个交互式的环境，支持如下指令:
    setAutoFightAll(true)           : 设置所有玩家进入自动战斗状态
    autoWalkAll(mapId)              : 开始自动行走，mapId 为 cfg.js 中 walkPath 配置的地图，当前可设置为 1000
    stopAutoWalkAll()               : 停止自动行走
    beginAutoWalkAll(mapId, x, y)   : 开始自动行走，可自动寻路到 mapId 地图下的 x, y 坐标。
    setShowMoreUsersAll(true/false) : 设置是否显示较多的玩家
    loginAllClient()                : 登录
    logoutAll()                     : 所有帐号退出游戏
    exit()                          : 工具终止运行
    receiveAllMail("新手礼包")        : 所有人 领取名字叫新手礼包的邮件
    allClientBuyVip(1)              : 所有账号购买会员，：1：月卡。2：季卡，3：年卡
    ()
    autoCombatTest(type)            : type为0表示进行自动战斗准备，type为1表示开始进行自动战斗测试。需要在DEBUG版本下导入测试文件测试，屏蔽每回合战斗时间限制。
    switchServerAll(num)            : 测试玩家换线，num 为换线次数。
    teleportTest(num)               : 测试天墉城 <-> 揽仙镇外来回切换地图，num 为执行次数。
    printAllClientStatus()          : 输出所有的连接状态
    checkClientStatus(account)      : 检查连接状态,
    checkConnections()              : 检查所有连接状态
    setDebugOn(flag)                : 打开或关闭消息打印(只对取到的第一个账号玩家进行打印) setDebugOn(false)
    sendTestCmd(testCmd)            : 发送聊天栏命令
    autoChannelTest(num)            : 聊天测试
    traceConnections(type)          : 连接情况
    teamMatchTeam(type)             : 作为队伍开始匹配  1:除暴，13:巡逻
    teamMatchMember(type)           : 作为队员开始匹配  1:除暴，13:巡逻
    startSendRecvTest(num)          : 测试收发包（需要屏蔽服务器的发送频率限制）

移动测试说明
    1、关闭随机过图点
        set_obj_var(find_object("/gs/cmds/normal/cmd_teleport.c"), "random_teleport_pos_flag", FALSE);
    2、行走类型
        beginAutoWalkAll(mapId, x, y):自动寻路到 mapId 地图下的 x, y 坐标。
        randomWalkInMap(mapId): 地图随机行走，目前支持天墉城（5000）。 (cfg.randomWalkRoutes)
        simulateWalking(interval): 循环过图行走, 参数interval表示相邻玩家开始行走的时间差（秒）(cfg.walkAndFlyRoutes)。
        walkToLiZongbing(): 走到李总兵附近。(cfg.birthRoutes)
        randomBirthPos()  : 走到出生点附近。(cfg.lizongbingRoutes)
    如何生成行走路径：
        GS 上执行 set_obj_var(find_object("/gs/cmds/normal/cmd_teleport.c"), "random_teleport_pos_flag", FALSE) 关闭随机过图点
        GS 上执行 GS_DEBUG_D->set_temp("record_move/"+me->get_gid(),1)，路径会生成到指定文件
        替换生成的路径信息到 cfg 配置表中

摆摊测试说明:
    1、将 file://10.2.51.97/atmpack/svn/test/patch_test 中的测试文件下载到服务器所在主机的 server_scripts/test 文件夹下。

    2、导入测试代码:
        所有GS: to = reload_object("/test" + STALL_D);
        MSS: to = reload_object("/test" + MSS_STALL_D);

    3、稍等一会儿，登录所有机器人:
        在 AAA 上创建所需的账号，for (i = 1; i < 2; ++i) { account = "" + (10000 + i); account = "g" + account[1..<1]; THREAD_D->dispatch_service(find_function(get_obj_function(ACCOUNT_D, "add_account"), account, "1234", "", "console_mac")); }
        运行机器人程序登录。

    4、准备工作:
        清空所有摆摊数据: 在 MSS 后台执行 to->clear_stall_data();
        清空摆摊系统: 在 MSS 执行 'sizeof(MSS_ONLINE_D->query_online_chars()) 观察是否都登录成功了。
        准备玩家数据: 在所有 GS 执行 set_stdout();然后在 MSS 后台执行 to->prepare_user_data(); 观察 GS 打印信息，确定是否完成装备工作。

    5、 摆摊指令:
       上架指令: stallPutAwayGoods()，上架商品，每个玩家上架 12 件商品；统计信息见 - stallStat.putAwayGoods 格式如下:
            beginTime   : now,      // 开始时间
            endTime     : now,      // 结束时间
            putCount    : 0,        // 上架次数
            okCount     : 0,        // 上架成功次数
            maxTime     : 0,        // 单次上架最长时间
        下架指令: stallRemoveGoods()，下架所有摆摊商品；统计信息见 - stallStat.removeGoods 格式同上。
        搜索指令: stallSearchGoods()，每个玩家执行一遍搜索；统计信息见 - stallStat.searchGoods 格式同上。
        取钱指令: stallTakeCash()，每个玩家都执行一次取钱操作；统计信息见 - stallStat.takeCash 格式同上。
        购买指令: stallBuyGoods()， 每个玩家执行一次购买操作(先查询摆摊列表，然后执行购买)；统计信息见 - stallStat.buyGoods 格式如下:
            beginTime   : now,      // 开始时间
            endTime     : now,      // 结束时间
            reqCount    : 0,        // 请求数据次数
            reqOkCount  : 0,        // 请求数据成功次数
            buyCount    : 0,        // 请求购买次数
            buyOkCount  : 0,        // 请求购买成功次数
            reqMaxTime  : 0,        // 请求数据单次最长时间
            buyMaxTime  : 0,        // 请求购买单次最长时间

    6、一部分玩家购买、另一部分玩家执行下架操作，观察是否有异常:
        console1 上架商品；
        console2 购买商品；
        console1 下架商品；
        等操作完成后，在 ldb 中执行以下命令来确认是否有重复的情况:
            创建临时表:
                CREATE TABLE `temp_stall_log` (
                	`id` INT(11) NOT NULL AUTO_INCREMENT,
                	`update_time` CHAR(14) NOT NULL,
                	`type` VARCHAR(32) NOT NULL,
                	`seller_gid` VARCHAR(32) NOT NULL,
                	`goods_name` VARCHAR(32) NOT NULL,
                	`goods_type` INT(11) NOT NULL,
                	`goods_level` INT(11) NOT NULL,
                	`goods_iid` VARCHAR(32) NOT NULL,
                	`goods_amount` INT(11) NOT NULL,
                	`price` INT(11) NOT NULL,
                	`tax` INT(11) NOT NULL,
                	`buyer_gid` VARCHAR(32) NOT NULL,
                	`para1` VARCHAR(32) NOT NULL,
                	`para2` VARCHAR(32) NOT NULL,
                	`para3` VARCHAR(32) NOT NULL,
                	`memo` TEXT NOT NULL,
                	PRIMARY KEY (`id`),
                	INDEX `index_seller_gid` (`seller_gid`),
                	INDEX `index_goods_iid` (`goods_iid`),
                	INDEX `index_buyer_gid` (`buyer_gid`),
                	INDEX `index_time` (`update_time`)
                )
                COLLATE='latin1_swedish_ci'
                ENGINE=InnoDB
            清空临时表:
                TRUNCATE `temp_stall_log`;
            插入需要分析的数据到临时表(注意修改时间 update_time):
                insert into temp_stall_log (select * from stall_log where `update_time` > 20160108210810 and type='cancel_sell_goods' or type='buy_goods');
            查询 goods_iid 是否有重复:
                select count(*) from temp_stall_log group by goods_iid;
        尝试将所有玩家登录到同一台 GS 上，观察宠物或者道具的 gid 是否重复:
            观察日志表 ldb.important_log action='have_same_iid' 确认一下摆摊系统是否有刷商品的情况。

    7、测试过程中在 GS、MSS、DBA 上执行以下命令，观察服务器是否正常:
        size_queues()       : 查看队列积压情况。
        ps()                : 查看进程情况。
        get_thread_info(id) : 查看线程堆栈情况。

    8、数据保存、读取情况: 上架商品成功后，在 MSS 后台执行 update(MSS_STALL_D)，读取数据完成后，通过日志 ldb.debug_exception_log 查看保存、读取花费的时间:
        备注            log_id      time                p1                        p2          p3                memo
       加载数据         20002   2016-01-08 21:47:31     init_ok                 时间毫秒      无             加载的商品数量
       保存商品数据     20002   2016-01-08 21:47:31     save_all_type_goods     时间毫秒    保存的数量       保存失败的数量
       保存玩家数据     20002   2016-01-08 21:47:31     save_all_player_goods   时间毫秒    保存的数量       保存失败的数量

金元宝交易测试说明:
    1、将 file://10.2.51.97/atmpack/svn/test/patch_test 中的测试文件下载到服务器所在主机的 server_scripts/test 文件夹下。

    2、导入测试代码:
        所有GS: to = reload_object("/test" + GOLD_STALL_D);
        MSS: to = reload_object("/test" + MSS_GOLD_STALL_D);

    3、稍等一会儿，登录所有机器人:
        在 AAA 上创建所需的账号，for (i = 1; i < 2; ++i) { account = "" + (10000 + i); account = "g" + account[1..<1]; THREAD_D->dispatch_service(find_function(get_obj_function(ACCOUNT_D, "add_account"), account, "1234")); }
        运行机器人程序登录。

    4、准备工作:
        清空所有金元宝交易数据: 在 MSS 后台执行 to->clear_stall_data();
        清空金元宝交易系统: 在 MSS 执行 'sizeof(MSS_ONLINE_D->query_online_chars()) 观察是否都登录成功了。
        准备玩家数据: 在所有 GS 执行 set_stdout();然后在 MSS 后台执行 to->prepare_user_data(); 观察 GS 打印信息，确定是否完成装备工作。

    5、 金元宝交易指令:
       上架指令: goldStallPutAwayGoods(put_one)，上架商品，每个玩家上架 3 件商品；统计信息见 - goldStallStat.putAwayGoods 格式如下:
            beginTime   : now,      // 开始时间
            endTime     : now,      // 结束时间
            putCount    : 0,        // 上架次数
            okCount     : 0,        // 上架成功次数
            maxTime     : 0,        // 单次上架最长时间
        下架指令: goldStallRemoveGoods(remove_one)，下架所有摆摊商品；统计信息见 - goldStallStat.removeGoods 格式同上。
        搜索指令: goldStallSearchGoods()，每个玩家执行一遍搜索；统计信息见 - goldStallStat.searchGoods 格式同上。
        取钱指令: goldStallTakeCash()，每个玩家都执行一次取钱操作；统计信息见 - goldStallStat.takeCash 格式同上。
        购买指令: goldStallBuyGoods()， 需要先在 MSS 后台执行命令 to->sell_all_goods() 将所有商品变成出售状态。
            每个玩家执行一次购买操作(先查询摆摊列表，然后执行购买)；统计信息见 - goldStallStat.buyGoods 格式如下:
            beginTime   : now,      // 开始时间
            endTime     : now,      // 结束时间
            reqCount    : 0,        // 请求数据次数
            reqOkCount  : 0,        // 请求数据成功次数
            buyCount    : 0,        // 请求购买次数
            buyOkCount  : 0,        // 请求购买成功次数
            reqMaxTime  : 0,        // 请求数据单次最长时间
            buyMaxTime  : 0,        // 请求购买单次最长时间

    6、一部分玩家购买、另一部分玩家执行下架操作，观察是否有异常:
        console1 上架商品；
        console2 购买商品；
        console1 下架商品；
        等操作完成后，在 ldb 中执行以下命令来确认是否有重复的情况:
            创建临时表:
                CREATE TABLE `temp_gold_stall_log` (
                	`id` INT(11) NOT NULL AUTO_INCREMENT,
                	`update_time` CHAR(14) NOT NULL,
                	`type` VARCHAR(32) NOT NULL,
                	`seller_gid` VARCHAR(32) NOT NULL,
                	`goods_name` VARCHAR(32) NOT NULL,
                	`goods_type` INT(11) NOT NULL,
                	`goods_level` INT(11) NOT NULL,
                	`goods_iid` VARCHAR(32) NOT NULL,
                	`goods_amount` INT(11) NOT NULL,
                	`price` INT(11) NOT NULL,
                	`tax` INT(11) NOT NULL,
                	`buyer_gid` VARCHAR(32) NOT NULL,
                	`para1` VARCHAR(32) NOT NULL,
                	`para2` VARCHAR(32) NOT NULL,
                	`para3` VARCHAR(32) NOT NULL,
                	`memo` TEXT NOT NULL,
                	PRIMARY KEY (`id`),
                	INDEX `index_seller_gid` (`seller_gid`),
                	INDEX `index_goods_iid` (`goods_iid`),
                	INDEX `index_buyer_gid` (`buyer_gid`),
                	INDEX `index_time` (`update_time`)
                )
                COLLATE='latin1_swedish_ci'
                ENGINE=InnoDB
            清空临时表:
                TRUNCATE `temp_gold_stall_log`;
            插入需要分析的数据到临时表(注意修改时间 update_time):
                insert into temp_gold_stall_log (select * from gold_stall_log where `update_time` > 20160108210810 and type='cancel_sell_goods' or type='buy_goods');
            查询 goods_iid 是否有重复:
                select count(*) from temp_gold_stall_log group by goods_iid;
        尝试将所有玩家登录到同一台 GS 上，观察宠物或者道具的 gid 是否重复:
            观察日志表 ldb.important_log action='have_same_iid' 确认一下摆摊系统是否有刷商品的情况。

    7、测试过程中在 GS、MSS、DBA、AAA 上执行以下命令，观察服务器是否正常:
        size_queues()       : 查看队列积压情况。
        ps()                : 查看进程情况。
        get_thread_info(id) : 查看线程堆栈情况。

    8、数据保存、读取情况: 上架商品成功后，在 MSS 后台执行 update(MSS_GOLD_STALL_D)，读取数据完成后，通过日志 ldb.debug_exception_log 查看保存、读取花费的时间:
        备注            log_id      time                p1                        p2          p3                memo
       加载数据         20008   2016-01-08 21:47:31     init_ok                 时间毫秒      无             加载的商品数量
       保存商品数据     20008   2016-01-08 21:47:31     save_all_type_goods     时间毫秒    保存的数量       保存失败的数量
       保存玩家数据     20008   2016-01-08 21:47:31     save_all_player_goods   时间毫秒    保存的数量       保存失败的数量

拍卖测试说明:
    1、将 file://10.2.51.97/atmpack/svn/test/patch_test 中的测试文件下载到服务器所在主机的 server_scripts/test 文件夹下。

    2、导入测试代码:
        所有GS: to = reload_object("/test" + SYS_AUCTION_D);
        MSS: to = reload_object("/test" + MSS_SYS_AUCTION_D);

    3、稍等一会儿，登录所有机器人:
        在 AAA 上创建所需的账号，for (i = 1; i < 2; ++i) { account = "" + (10000 + i); account = "g" + account[1..<1]; THREAD_D->dispatch_service(find_function(get_obj_function(ACCOUNT_D, "add_account"), account, "1234")); }
        运行机器人程序登录。

    4、准备工作:
        观察玩家是否登录完毕: 在 MSS 执行 'sizeof(MSS_ONLINE_D->query_online_chars()) 观察是否都登录成功了。
        准备玩家数据: 在所有 GS 执行 set_stdout();然后在 MSS 后台执行 to->prepare_user_data(); 观察 GS 打印信息，确定是否完成准备工作。
            将拍卖商品的起拍价设置为 100，方便不会很快到达上限。
            将拍卖商品的截止时间设置在 30 分钟后。
            将玩家的金钱设置为 20 亿。
        测试开始前，将日志表 acution_log 清空。

    5、拍卖竞价指令:
        auctionBidGoods("2018-03-16 16:35:00", 100, 100)
            para1: 开始竞价的时间点，方便所有机器人在同一时间发起竞价。
            para2: 每个机器人自身多次竞价的间隔，毫秒。
            para3: 每个机器人发起几次竞价。
        auctionStat.bidStat console 记录的统计信息:
            beginTime: 1458018957552,   // 开始时间，毫秒
            endTime: 1458018975973,     // 结束时间，毫秒
            reqCount: 10000,            // 发起请求拍卖列表的次数
            reqRetCount: 10000,         // 拍卖列表返回次数
            bidCount: 10000,            // 发起竞价的次数
            bidRetCount: 7891,          // 竞价结果返回次数；少了的有可能是金钱不足或者正在操作中
            reqMaxTime: 3094,           // 请求拍卖列表的最大时间，毫秒
            bidMaxTime: 7885,           // 请求竞价的最大时间，毫秒

    6、观察玩家扣除的金钱是否正确:
        查询某个玩家竞价的消耗: select sum(price) from auction_log where `type`='bid_goods' and buyer_gid='56E778DC0073D2000100';
        跟玩家自身金钱进行对比，如果加起来正好等于 20亿就没有问题。

    7、测试过程中在 GS、MSS、DBA 上执行以下命令，观察服务器是否正常:
        size_queues()       : 查看队列积压情况。
        ps()                : 查看进程情况。
        get_thread_info(id) : 查看线程堆栈情况。

【废弃，有需要再想其他办法】充值测试说明（测试地址配置在cfg.js文件字段rechargeHttpInfo，需要连接平台的测试服务器进行测试）
    rechargeGoldCoin()              // 充值元宝测试，充值6元元宝类型

【废弃，有需要再想其他办法】登录排队中充值成功推送说明（测试地址配置在cfg.js文件字段 chargeHttpInfo，需要配置为服务器的 CCS 的 http 端口，并且需要在 adb.ccs 的 http_ip 中加上本地 ip 地址）
    waitLineCharge(100)              // 登录排队充值元宝测试，随机 100 个玩家充值。

聚宝斋压力测试（需要连接平台的测试服务器进行购买测试）
    上架
        tradingSellRole("2018-03-16 16:41:00", 100, 100)
    购买tradingBuyRole
        tradingBuyRole("2018-03-16 10:18:00")
    下架tradingCancelRole
        tradingCancelRole("2018-03-16 14:33:00")
    trading_cfg.js配置要进行购买测试的订单号数据

试道大会测试说明: // 早期版本单服试道大会测试命令，已废弃。
    1、将 file://10.2.51.97/atmpack/svn/test/patch_test 中的测试文件下载到服务器所在主机的 server_scripts/test 文件夹下。

    2、导入测试代码:
        指定GS:
        t = "/test/gs/tasks/shidao-dahui/shidao_dahui.c";
        update(t);

    3、稍等一会儿，登录所有机器人:
        在 AAA 上创建所需的账号，for (i = 1; i < 2; ++i) { account = "" + (10000 + i); account = "g" + account[1..<1]; THREAD_D->dispatch_service(find_function(get_obj_function(ACCOUNT_D, "add_account"), account, "1234")); }
        运行机器人程序登录。

    4、准备工作:
        在 GS 后台执行
        t->start_shidao_dahui();    // 开始试道大会
        t->teleport_all_players();  // 安排所有玩家入场

    5、 测试在试道场的移动:
        在 js控制台输入
        walkInShiDaoChang()         // 在试道场内随意移动

    6、测试在试道场内与元魔战斗
        在 GS 后台执行
        t->enter_first_stage();     // 进入试道大会第一阶段
        t->combat_with_monster();   // 依次安排玩家与场内的元魔战斗

    7、测试在试道场内与玩家战斗
        在 GS 后台执行
        t->enter_second_stage();    // 进入试道大会第二阶段

        在 js控制台输入
        walkInShiDaoChang()         // 在试道场内随意移动
