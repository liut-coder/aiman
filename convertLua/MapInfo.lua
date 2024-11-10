return {

        -- isActiveNPC:节日活动的NPC标注，不能显示在小地图的NPC精灵列表中
        -- notInSmallMap:不显示在小地图
        -- inTestDist：显示内测区组
        -- offsetPos: 偏移，用于小地图名字显示。由于部分配置NPC会超出边框、重叠，设置该偏移量，则显示名字会基于原坐标，偏移x、y像素。
        -- croplands：居所后院中的农田坐标
        -- mapType: 1, 普通地图    2, 拖动的地图，默认为1普通地图
        -- map_obstacle_id 使用的地图资源编号与障碍点的编号不同时可配置该字段
        -- range = {x1, x2, y1, x2}
        ---- x1 左边距 x2 右边距  y1 上边距 y2 下边距
        -- notShowExitInSmallMap: 不显示传送点
        -- notDrawTeam : 不显示队伍
        -- bottom_image:NPC脚下站着的图片
        -- bottom_image_Zorder :脚底图片 的Zorder
        -- isFloat: Npc需要浮动，当前浮动方式只有1中，所以bool型
        -- armatureType 同 LightEffect.lua 文件 armatureType
        -- magicIcon, actionName NPC脚下光效、动作名称
[1000] = {
    map_name = CHS[3000794], -- 揽仙镇
    map_id = 1000,
    teleport_x = 86,
    teleport_y = 85,

    npc = {
        {name = CHS[3000795],   x = 038, y = 108, icon = 06010},
        {name = CHS[3000796],     x = 092, y = 116, icon = 06018},
        {name = CHS[3000797],   x = 123, y = 114, icon = 06019},  -- 莲花姑娘
        {name = CHS[3000798],     x = 100, y = 097, icon = 06016},
        {name = CHS[3000799],     x = 054, y = 069, icon = 06012},
        {name = CHS[3000800],     x = 071, y = 117, icon = 06011},
        {name = CHS[3000801],     x = 097, y = 051, icon = 06015},
        {name = CHS[3000802],     x = 123, y = 068, icon = 06014},
        {name = CHS[3000803],     x = 014, y = 057, icon = 06013},
        {name = CHS[3000804],     x = 116, y = 021, icon = 06059}, -- 乐善施
        {name = CHS[3000805],   x = 037, y = 026, icon = 06058},
        {name = CHS[3000806],   x = 140, y = 009, icon = 06047},
        {name = CHS[5420029],   x = 086, y = 084, icon = 51501, notInSmallMap = true, isActiveNPC = true, },
        {name = "小岚",   x = 14, y = 100, icon = 51526, notInSmallMap = true, isActiveNPC = true },
        {name = "小水",   x = 10, y = 102, icon = 51525, notInSmallMap = true, isActiveNPC = true },
    },

    exit_level = { [CHS[3000807]] = "15~20", [CHS[3000808]] = "30~50"},
    monster_level = 0,
},

[1001] = {
    map_name = CHS[7190282], -- 迷仙镇
    map_id = 1000,
    teleport_x = 86,
    teleport_y = 85,
        npc = {
        {name = CHS[7100365], x = 092, y = 116, icon = 06018, offsetPos = {x = 25, y = 7}}, -- 小童
        {name = CHS[7100364], x = 089, y = 119, icon = 06043, offsetPos = {x = 15, y = 0}}, -- 贾捕快
        {name = CHS[7100366], x = 075, y = 120, icon = 06013}, -- 小童母亲
        {name = CHS[7100367], x = 054, y = 069, icon = 06012}, -- 小童父亲
        {name = CHS[7100368], x = 096, y = 099, icon = 51513}, -- 小童叔叔
        {name = CHS[7100369], x = 008, y = 060, icon = 06087}, -- 常舌馥
        {name = CHS[7100370], x = 091, y = 051, icon = 06035}, -- 小童爷爷
        {name = CHS[7100371] .. "2", x = 121, y = 069, icon = 06011, alias = CHS[7100371]}, -- 药店老板
        {name = CHS[7100372], x = 037, y = 026, icon = 20062}, -- 镇内灵石
        {name = CHS[7100373], x = 038, y = 108, icon = 06042}, -- 招魂道士
    },
    monster_level = 0,
    unmatch_team = true,
    unswitch_line = true,
    notShowExitInSmallMap = true,
    notDrawTeam = true,
},

[2000] = {
    map_name = CHS[3000808], -- 揽仙镇外镇外
    map_id = 2000,
    teleport_x = 34,
    teleport_y = 28,
    npc = {
    },
    monster_level = 2,
},

[3000] = {
    map_name = CHS[3000809], -- 卧龙坡
    map_id = 3000,
    teleport_x = 19,
    teleport_y = 31,
    npc = {
        {name = CHS[3000810],       x = 014, y = 020, icon = 06191},
            {name = CHS[3000811],   x = 051, y = 008, icon = 06042},
            {name = CHS[3000812],   x = 051, y = 022, icon = 06041},
    },
    monster_level = 7,
},

[3001] = {
        map_name = CHS[4100427], -- 落魄崖
        map_id = 3000,
        teleport_x = 19,
        teleport_y = 31,
        npc = {
            {name = CHS[4100428],   x = 42, y = 11, icon = 06065}, -- 灵宝真君
        },
        monster_level = 0,
    },

[4000] = {
    map_name = CHS[3000807], -- 官道南
    map_id = 4000,
    teleport_x = 42,
    teleport_y = 37,
    npc = {
    },
    monster_level = 10,
},

[24000] = {
    map_name = CHS[3000813], -- 官道北
    map_id = 24000,
    teleport_x = 35,
    teleport_y = 24,
    npc = {
    },
    monster_level = 13,
},

[24001] = {
        map_name = CHS[4200140], -- 百花小径
        map_id = 24000,
        teleport_x = 35,
        teleport_y = 24,
        npc = {
            {name = "吕洞宾2",   x = 23, y = 13, icon = 20006, alias = "吕洞宾"}, -- 吕洞宾
            {name = CHS[4200141],   x = 14, y = 37, icon = 06260}, -- 穿山魔甲
        },
        monster_level = 13,
    },

[24002] = {
        map_name = CHS[4100430], -- 乡间小道
        map_id = 24000,
        teleport_x = 35,
        teleport_y = 24,
        npc = {
            {name = CHS[4100431],   x = 49, y = 18, icon = 06230}, -- 李猎户
        },
        monster_level = 13,
    },

[05000] = {
    map_name = CHS[3000814], -- 天墉城
    map_id = 05000,
    teleport_x = 95,
    teleport_y = 64,

    npc = {
            {name = CHS[3000815],   x = 194, y = 52, icon = 06058},     --天机老人
            {name = CHS[3000816],     x = 165, y = 60, icon = 06031, offsetPos = {x = 0, y = 33}},   -- 李总兵
                {name = CHS[3000817],   x = 22, y = 136, icon = 06042},     -- 通灵道人
                {name = CHS[3000818],     x = 127, y = 119, icon = 06010},      -- 白邦芒
                {name = CHS[3000819],   x = 138, y = 13, icon = 06223},         -- 赤灵尊神
            {name = CHS[3000820],   x = 114, y = 16, icon = 06047},         -- 北斗星使
            {name = CHS[3000821],     x = 20, y = 46, icon = 06033},        -- 杨镖头
            {name = CHS[3000822], x = 132, y = 48, icon = 06043},           -- 试道申请人
            {name = CHS[3000823],   x = 109, y = 75, icon = 06236},
            {name = CHS[3000824],     x = 89, y = 94, icon = 06014},
            {name = CHS[3000825],     x = 139, y = 39, icon = 06011},
            {name = CHS[3000826],     x = 146, y = 74, icon = 06012, notInSmallMap = true},
            {name = CHS[3000827],     x = 119, y = 50, icon = 06013, notInSmallMap = true},
            {name = CHS[3000828],     x = 107, y = 113, icon = 06016},          -- 冯喜来
            {name = "杂货店老板1", x = 76, y = 26, icon = 06015, offsetPos = {x = 0, y = -2}, alias = "杂货店老板"},
            {name = CHS[3000830],     x = 41, y = 72, icon = 06039},
            {name = CHS[3000831],     x = 43, y = 81, icon = 06040, offsetPos = {x = -15, y = 0}},-- 历巧手
            {name = CHS[3000832],     x = 9, y = 66, icon = 06240},
            {name = CHS[3000833],     x = 57, y = 79, icon = 06058},
            {name = CHS[3000834],     x = 91, y = 50, icon = 06016, offsetPos = {x = 0, y = -3}}, -- 集市管理员
            {name = CHS[3000835],     x = 55, y = 27, icon = 06175, offsetPos = {x = -10, y = 0}, headTitle = {classIcon = "ui/Icon2180.png", wordIcon = "ui/Icon2185.png"}}, -- 屠娇娇
            {name = CHS[3000836],     x = 83, y = 46, icon = 06035, offsetPos = {x = 0, y = 3}, headTitle = {classIcon = "ui/Icon2180.png", wordIcon = "ui/Icon2184.png"}}, -- 董老头
            {name = CHS[3000838],     x = 70, y = 97, icon = 06057, notInSmallMap = true},

            {name = CHS[3000840],   x = 135, y = 81, icon = 06043},

            {name = CHS[3000842],     x = 44, y = 136, icon = 06032},                       -- 逍遥仙
            {name = CHS[3000843],     x = 55, y = 10, icon = 06213, notInSmallMap = true},  -- 夜行人

            {name = CHS[3000845],     x = 90, y = 22, icon = 06059, offsetPos = {x = 5, y = 2}, headTitle = {classIcon = "ui/Icon2182.png", wordIcon = "ui/Icon2186.png"}}, -- 辛仁皑
            {name = "妙手道人",   x = 23, y = 116, icon = 06058, headTitle = {classIcon = "ui/Icon2182.png", wordIcon = "ui/Icon2192.png"}}, -- 妙手道人
            {name = "灵兽异人2",   x = 113, y = 120, icon = 06041, offsetPos = {x = -15, y = -3}, alias = "灵兽异人"},
            {name = CHS[3000848],   x = 46, y = 28, icon = 06042, notInSmallMap = true},
            {name = CHS[3000849],   x = 15, y = 54, icon = 06231, notInSmallMap = true},
            {name = CHS[3000850],     x = 152, y = 20, icon = 06012},
            {name = "船夫8",       x = 88, y = 134, icon = 06044, notInSmallMap = true, alias = "船夫"},
            {name = "神算子",     x = 138, y = 111, icon = 06091, headTitle = {classIcon = "ui/Icon2182.png", wordIcon = "ui/Icon2193.png"}},
                {name = CHS[3000853],     x = 6, y = 80, icon = 06049,  offsetPos = {x = 8, y = 0}},             -- 千面怪
            {name = CHS[3000854],       x = 93, y = 10, icon = 06057},  -- 蒙面


            {name = CHS[8000002],       x = 188, y = 37, icon = 06048, notInSmallMap = true},
            {name = CHS[8000003],       x = 67, y = 35, icon = 06048, notInSmallMap = true},
            {name = CHS[8000004],       x = 148, y = 38, icon = 06048, notInSmallMap = true},
            {name = "守城士兵2",   x = 199, y = 119, icon = 06050, notInSmallMap = true, alias = "守城士兵"},
            {name = "守城士兵1",   x = 31, y = 22, icon = 06050, notInSmallMap = true, alias = "守城士兵"},
            {name = "竞技使者",   x = 176, y = 105, icon = 06036},
            {name = CHS[5100015],   x = 159, y = 96, icon = 06059},
            {name = "红娘", x = 161, y = 121, icon = 06087, headTitle = {classIcon = "ui/Icon2182.png", wordIcon = "ui/Icon2189.png"}},
            {name = CHS[6000291], x = 107, y = 58, icon = 06108, notInSmallMap = true, isActiveNPC = true}, -- 老猴
            {name = CHS[6000295], x = 107, y = 58, icon = 06103, notInSmallMap = true, isActiveNPC = true}, -- 猴哥
            {name = CHS[6000303], x = 107, y = 58, icon = 06187, notInSmallMap = true, isActiveNPC = true}, -- 猴宝
            {name = CHS[6000393], x = 79, y = 58, icon = 06227, notInSmallMap = true, isActiveNPC = true}, -- 饿死鬼
            {name = CHS[4200172], x = 107, y = 58, icon = 06135, notInSmallMap = true, isActiveNPC = true}, -- 嫦娥仙子
            {name = CHS[4200173], x = 112, y = 58, icon = 06182, notInSmallMap = true, isActiveNPC = true}, -- 玉兔
            {name = CHS[4100400], x = 168, y = 86, icon = 06036},        -- 节日活动的NPC标注为isActiveNPC，不能显示在小地图，NPC精灵列表中
            {name = CHS[7000172], x = 111, y = 63, icon = 20122, shadow = "christmas_tree_shadow", shadow_x = -42, shadow_y = -21, notInSmallMap = true, isActiveNPC = true}, -- 华丽的圣诞树
            {name = CHS[7000173], x = 80, y = 64, icon = 20122, shadow = "christmas_tree_shadow", shadow_x = -42, shadow_y = -21, notInSmallMap = true, isActiveNPC = true}, -- 精美的圣诞树
            {name = CHS[5450068], x = 84, y = 55, icon = 20122, shadow = "christmas_tree_shadow", shadow_x = -42, shadow_y = -21, notInSmallMap = true, isActiveNPC = true}, -- 圣诞树
            {name = CHS[7000174], x = 91, y = 57, icon = 30001, notInSmallMap = true, isActiveNPC = true}, -- 圣诞麋鹿
            {name = CHS[4200206], x = 78, y = 101, icon = 06038, inTestDist = true,}, -- 王中王
            {name = "物资管理员", x = 182, y = 93, icon = 06014, npcShowFunc = "showInNSZB"},   -- 物资管理员
            {name = "粽仙", x = 106, y = 58, icon = 20010, notInSmallMap = true, isActiveNPC = true},
            {name = "郝艾佳", x = 185, y = 133, icon = 06013, headTitle = {classIcon = "ui/Icon2182.png", wordIcon = "ui/Icon2188.png"}},
            {name = "问卷调查专员", x = 100, y = 88, icon = 06020, notInSmallMap = true},
            {name = "跨服赛事接引人", x = 176, y = 60, icon = 06236},

            {name = "周年蛋糕", x = 84, y = 58, icon = 20122, notInSmallMap = true, isActiveNPC = true}, -- 周年蛋糕

            {name = "楼兰特使", x = 100, y = 55, icon = 6031, notInSmallMap = true, isActiveNPC = true},

            {name = "四海升平钟", x = 84, y = 58, icon = 20123, notInSmallMap = true, isActiveNPC = true},
            {name = "甜粽党代表",   x = 188, y = 105, icon = 861202, notInSmallMap = true, isActiveNPC = true },
            {name = "咸粽党代表",   x = 194, y = 102, icon = 861202, notInSmallMap = true, isActiveNPC = true },
            {name = "周华健",   x = 100, y = 55, icon = 51532, notInSmallMap = true, isActiveNPC = true},
    },
    monster_level = 0,
},

[05006] = {
    map_name = "决斗场",
    map_id = 05000,
    map_obstacle_id = 05006,
    teleport_x = 169,
    teleport_y = 95,

    range = { x1 = 3768, x2 = 80, y1 = 1752, y2 = 1064 },
    npc = {
            {name = "夏总兵2", x = 195, y = 80, icon = 06031,  alias = "夏总兵"},
    },

    monster_level = 0,
},

[05015] = {
    map_name = CHS[7000063], -- 监狱
    map_id = 05015,
    teleport_x = 19,
    teleport_y = 30,
    npc = {
            {name = CHS[7000064],   x = 39, y = 27, icon = 06050},
    },
    monster_level = 0,
},
[6000] = {
    map_name = CHS[3000860],    -- 桃柳林
    map_id = 6000,
    teleport_x = 41,
    teleport_y = 31,
    npc = {
    },
    monster_level = 17,
},

[7000] = {
    map_name = CHS[3000861],        -- 风月谷
    map_id = 7000,
    teleport_x = 28,
    teleport_y = 25,
    npc = {
            {name = CHS[3000862],       x = 038, y = 016, icon = 06205},
            {name = CHS[3000863],       x = 006, y = 045, icon = 06019},
            {name = CHS[3000864],       x = 051, y = 032, icon = 06192},
            {name = "月老",       x = 050, y = 015, icon = 06060, headTitle = {classIcon = "ui/Icon2182.png", wordIcon = "ui/Icon2190.png"}},
            {name = "云游大仙1",   x = 017, y = 008, icon = 06043, alias = "云游大仙"},
            {name = "云游大仙2",   x = 006, y = 008, icon = 06043, alias = "云游大仙"},
            {name = "云游大仙3",   x = 010, y = 015, icon = 06043, alias = "云游大仙"},
            {name = "童童",   x = 25, y = 16, icon = 51502, notInSmallMap = true, isActiveNPC = true},
            {name = "薛之谦1",   x = 26, y = 16, icon = 51502, notInSmallMap = true, isActiveNPC = true, alias = "薛之谦"},
    },
    monster_level = 0,
},

[17001] = {
    map_name = "无名仙境",  -- 无名仙境
    map_id = 17000,
    teleport_x = 31,
    teleport_y = 52,
    npc = {

    {name = "活动大使1",   x = 78, y = 52, icon = 06236, alias = "活动大使"},

    },
    monster_level = 51,
},

[8000] = {
    map_name = CHS[3000867],        -- 轩辕庙
    map_id = 8000,
    teleport_x = 24,
    teleport_y = 30,
    npc = {
            {name = CHS[3000868],   x = 062, y = 044, icon = 06086},
            {name = "无想僧",     x = 051, y = 045, icon = 06089, headTitle = {classIcon = "ui/Icon2182.png", wordIcon = "ui/Icon2187.png"}},
            {name = "无意僧",     x = 65, y = 38, icon = 06089, headTitle = {classIcon = "ui/Icon2182.png", wordIcon = "ui/Icon2289.png"}},
            {name = CHS[3000870],     x = 068, y = 016, icon = 06089},
            {name = "车夫2",       x = 034, y = 046, icon = 06045, alias = "车夫"},
            {name = CHS[7003025], x = 023, y = 021, icon = 06042, notInSmallMap = true, isActiveNPC = true},
    },
    monster_level = 22,
},

[8100] = {
        map_name = CHS[3000872],        -- 轩辕坟一层
    map_id = 8100,
    teleport_x = 41,
    teleport_y = 41,
    npc = {},
    monster_level = 27,
},

[8200] = {
        map_name = CHS[3000873],  -- 轩辕坟二层
    map_id = 8200,
    teleport_x = 59,
    teleport_y = 38,
    npc = {},
    monster_level = 32,
},

[08300] = {
        map_name = CHS[3000874],  -- 轩辕坟三层
    map_id = 08300,
    teleport_x = 25,
    teleport_y = 37,
    npc = {},
    monster_level = 37,
},

[9000] = {
        map_name = CHS[3000875],   -- 北海沙滩
    map_id = 9000,
    teleport_x = 25,
    teleport_y = 29,
    npc = {
    },
    monster_level = 25,
},

[9001] = {
        map_name = CHS[4000381],  -- 海滨
    map_id = 9000,
    teleport_x = 25,
    teleport_y = 29,
    npc = {
            {name = "韩湘子1",          x = 24, y = 11, icon = 20008, alias = "韩湘子"},
            {name = CHS[4000393],       x = 59, y = 31, icon = 06066},
            {name = CHS[4000394],       x = 47, y = 6, icon = 20062},

    },
    monster_level = 25,
},

[9003] = {
    map_name = CHS[7002022], -- 东海之滨
    map_id = 9000,
    teleport_x = 25,
    teleport_y = 29,
    npc = {
        {name = CHS[7002025],   x = 58, y = 27, icon = 06047}, -- 神秘老者
                {name = "何仙姑2",   x = 32, y = 29, icon = 20010, alias = "何仙姑"}, -- 何仙姑
                {name = "曹国舅2",   x = 30, y = 32, icon = 20011, alias = "曹国舅"}, -- 曹国舅
    },
    monster_level = 0,
},

[10000] = {
    map_name = "五龙山",
    map_id = 10000,
    teleport_x = 43,
    teleport_y = 22,
    npc = {
            {name = CHS[3000877],       x = 051, y = 18, icon = 06232},
            {name = CHS[3000878],       x = 30, y = 28, icon = 06190},
            {name = CHS[3000879],   x = 51, y = 37, icon = 06001},
            {name = "接引道童1",   x = 43, y = 15,  icon = 06069, defalut_talk = CHS[6000379], alias = "接引道童"}, -- 接引道童
    },
    monster_level = 35,
},

[10001] = {
    map_name = CHS[3000880],
    map_id = 10001,
    teleport_x = 24,
    teleport_y = 25,
    npc = {
                {name = CHS[3000881],   x = 15, y = 12, icon = 06052},        -- 文殊天尊
                {name = CHS[3000882],   x = 16, y = 027, icon = 06020},            -- 云霄童子
            {name = CHS[3000883],   x = 36, y = 014, icon = 20033},
    },
    monster_level = 0,
},

[10100] = {
    map_name = CHS[3000884],
    map_id = 10100,
    teleport_x = 64,
    teleport_y = 34,
    npc = {},
    monster_level = 42,
},

[10101] = {
    map_name = CHS[7003008], -- 地底通道
    map_id = 10100,
    teleport_x = 64,
    teleport_y = 34,
    npc = {
        {name = CHS[7003012],   x = 59, y = 7, icon = 06128},
    },
    monster_level = 0,
},

[10200] = {
    map_name = CHS[3000885],
    map_id = 10200,
    teleport_x = 21,
    teleport_y = 34,
    npc = {},
    monster_level = 45,
},

[10300] = {
    map_name = CHS[3000886],
    map_id = 10300,
    teleport_x = 36,
    teleport_y = 39,
    npc = {},
    monster_level = 48,
},

[10400] = {
    map_name = CHS[3000887],
    map_id = 10400,
    teleport_x = 8,
    teleport_y = 23,
    npc = {},
    monster_level = 51,
    npc = {{name = CHS[3000888], x = 065, y = 055, icon = 06003},}
},

[10500] = {
    map_name = CHS[3000889],
    map_id = 10500,
    teleport_x = 25,
    teleport_y = 26,
    npc = {},
    monster_level = 54,
    npc = {{name = CHS[3000890], x = 022, y = 020, icon = 06003},}
},

[11000] = {
        map_name = CHS[3000891], -- 东海渔村
    map_id = 11000,
    teleport_x = 64,
    teleport_y = 77,
    npc = {
            {name = "船夫1",       x = 088, y = 097, icon = 06044, alias = "船夫"},
            {name = CHS[3000892],     x = 013, y = 040, icon = 06042},
            {name = CHS[3000893],   x = 088, y = 015, icon = 06014},
            {name = CHS[3000894],   x = 017, y = 028, icon = 06011},
            {name = CHS[3000895],   x = 062, y = 051, icon = 06016},
            {name = "杂货店老板2", x = 046, y = 015, icon = 06015, alias = "杂货店老板"},
            {name = CHS[3000896],     x = 089, y = 051, icon = 06032},
            {name = "玉真子",     x = 034, y = 077, icon = 06053, headTitle = {classIcon = "ui/Icon2180.png", wordIcon = "ui/Icon2191.png"}},
            {name = "灵兽异人1",   x = 016, y = 094, icon = 06041, alias = "灵兽异人"},
            {name = "车夫1",       x = 070, y = 067, icon = 06045, alias = "车夫"},
    },
    monster_level = 0,
},

[11001] = {
        map_name = CHS[4100432], -- 李家庄
        map_id = 11000,
        teleport_x = 64,
        teleport_y = 77,
        npc = {
            {name = CHS[4100433],       x = 33, y = 77, icon = 06004},
        },
        monster_level = 0,
    },


[12000] = {
    map_name = CHS[3000898],
    map_id = 12000,
    teleport_x = 52,
    teleport_y = 35,
    npc = {
        {name = CHS[3000899],       x = 043, y = 057, icon = 06189},
    },
    monster_level = 31,
},

[13000] = {
    map_name = "乾元山",
    map_id = 13000,
    teleport_x = 32,
    teleport_y = 41,
    npc = {
        {name = CHS[3000901],       x = 013, y = 016, icon = 06235},
        {name = CHS[3000902],    x = 22, y = 35, icon = 06004},
        {name = "接引道童2",   x = 36, y = 33,  icon = 06069, defalut_talk = CHS[6000379], alias = "接引道童"}, -- 接引道童
    },
    exit_level = { },
    monster_level = 35,
},

[13001] = {
            map_name = CHS[3000903],    -- 金光洞
    map_id = 13001,
    teleport_x = 11,
    teleport_y = 23,
    npc = {
                {name = CHS[3000904],   x = 46, y = 015, icon = 06055},    -- 太乙真人
                {name = CHS[3000905],   x = 28, y = 013, icon = 06023},    -- 赤霞童子
                {name = CHS[3000906],   x = 15, y = 013, icon = 20036},    -- 金光长老
    },
    monster_level = 0,
},

[14000] = {
    map_name = "终南山",
    map_id = 14000,
    teleport_x = 36,
    teleport_y = 20,
    npc = {
        {name = CHS[3000908],       x = 006, y = 026, icon = 06233},
        {name = CHS[3000909],   x = 46, y = 12, icon = 06002},
        {name = "接引道童3",   x = 28, y = 12,  icon = 06069, defalut_talk = CHS[6000379], alias = "接引道童"}, -- 接引道童
    },
    exit_level = { },
    monster_level = 35,
},

[14001] = {
            map_name = CHS[3000910],    -- 玉柱洞
    map_id = 14001,
    teleport_x = 36,
    teleport_y = 22,
    npc = {
                {name = CHS[3000911],     x = 14, y = 010, icon = 06053},  -- 云中子
                {name = CHS[3000912],   x = 40, y = 015, icon = 06021},    -- 碧玉童子
                {name = CHS[3000913],   x = 13, y = 025, icon = 20034},    -- 玉柱长老
    },
    monster_level = 0,
},

[15000] = {
    map_name = CHS[3000914],  -- 凤凰山
    map_id = 15000,
    teleport_x = 46,
    teleport_y = 26,
    npc = {
            {name = CHS[3000915],       x = 020, y = 017, icon = 06234},
            {name = CHS[3000916],   x = 64, y = 21, icon = 06003},
            {name = "接引道童4",   x = 57, y = 16,  icon = 06069, defalut_talk = CHS[6000379], alias = "接引道童"}, -- 接引道童
    },
    exit_level = { },
    monster_level = 35,
},

[15001] = {
            map_name = CHS[3000917],    -- 斗阙宫
    map_id = 15001,
    teleport_x = 43,
    teleport_y = 25,
    npc = {
                {name = CHS[3000918],   x = 10, y = 009, icon = 06054},    -- 龙吉公主
            {name = CHS[3000919],   x = 43, y = 007, icon = 06022},
            {name = CHS[3000920],   x = 26, y = 007, icon = 20035},
    },
    monster_level = 0,
},

[15005] = {
    map_name = "王母寝宫",
    map_id = 15001,
    teleport_x = 43,
    teleport_y = 25,
    npc = {
        {name = "瑶池天兵1", x = 12, y = 014, icon = 06223, alias = "瑶池天兵"},
        {name = "瑶池天兵2", x = 012, y = 022, icon = 06223, alias = "瑶池天兵"},
        {name = "瑶池天兵3", x = 023, y = 027, icon = 06223, alias = "瑶池天兵"},
        {name = "瑶池天兵4", x = 038, y = 027, icon = 06223, alias = "瑶池天兵"},
        {name = "瑶池天兵5", x = 024, y = 020, icon = 06223, alias = "瑶池天兵"},
        {name = "侍女青梅", x = 023, y = 009, icon = 06134},
        {name = "侍女红羽", x = 038, y = 009, icon = 06136},
        {name = "侍女黄秀", x = 049, y = 014, icon = 06133},
        {name = "侍女蓝欣", x = 049, y = 022, icon = 06138},
        {name = "侍女白依", x = 034, y = 015, icon = 06135},
    },
    monster_level = 0,
    unswitch_line = true,
    unmatch_team = true,
},

[16000] = {
    map_name = "骷髅山",
    map_id = 16000,
    teleport_x = 39,
    teleport_y = 44,
    npc = {
            {name = CHS[3000922],       x = 037, y = 009, icon = 06236},
            {name = CHS[3000923],     x = 051, y = 018, icon = 06226},
            {name = CHS[3000924],   x = 9, y = 36, icon = 06005},
            {name = "接引道童5",   x = 19, y = 36,  icon = 06069, defalut_talk = CHS[6000379], alias = "接引道童"}, -- 接引道童
    },
    exit_level = { },
    monster_level = 35,
},

[16005] = {
    map_name = CHS[7190148],  -- 山贼营外
    map_id = 16000,
    monster_level = 0,
    unmatch_team = true,
    unswitch_line = true,
},

[08101] = {
    map_name = CHS[7190149],  -- 山贼老巢
    map_id = 08100,
    monster_level = 0,
    unmatch_team = true,
    unswitch_line = true,
},

[16001] = {
        map_name = CHS[3000925],            -- 白骨洞
    map_id = 16001,
    teleport_x = 23,
    teleport_y = 22,
    npc = {
                {name = CHS[3000926],   x = 44, y = 009, icon = 06056},    -- 石矶娘娘
                {name = CHS[3000927],   x = 24, y = 016, icon = 06024},    -- 彩云童子
                {name = CHS[3000928],   x = 45, y = 022, icon = 20037},    -- 白骨长老
    },
    monster_level = 0,
},

[16100] = {
    map_name = CHS[3000929],  -- 幽冥涧
    map_id = 16100,
    teleport_x = 37,
    teleport_y = 33,
    npc = {
            {name = CHS[3000930],   x = 049, y = 019, icon = 06147},
            {name = CHS[3000931],     x = 014, y = 033, icon = 06228},
            {name = CHS[3000932],   x = 013, y = 021, icon = 06227},
            {name = CHS[3000933],   x = 032, y = 019, icon = 06003},
    },
    monster_level = 57,
},

[16101] = {
    map_name = CHS[3000934],
    map_id = 16100,
    teleport_x = 49,
    teleport_y = 38,
    monster_level = 1,
},


[17000] = {
    map_name = CHS[3000935],  -- 蓬莱岛
    map_id = 17000,
    teleport_x = 31,
    teleport_y = 52,
    npc = {
        {name = CHS[3000936],   x = 50, y = 49, icon = 6047},
        {name = CHS[3000937],   x = 61, y = 9, icon = 6068},
        {name = CHS[3000938],   x = 37, y = 51, icon = 6003},
        {name = "龙宫使者2",   x = 7, y = 76, icon = 6163, defalut_talk = CHS[6000375], alias = "龙宫使者"}, -- 龙宫使者
        {name = "米兰仙子",    x = 7, y = 19, icon = 6002, offsetPos = {x = 10, y = 0}}
    },
    monster_level = 51,
},


[17100] = {
    map_name = CHS[3000939],
    map_id = 17100,
    teleport_x = 22,
    teleport_y = 35,
    npc = {},
    monster_level = 62,
    npc = {{name = CHS[3000940],   x = 034, y = 035, icon = 06003},
    },
},

[17200] = {
    map_name = CHS[3000941],
    map_id = 17200,
    teleport_x = 36,
    teleport_y = 43,
    npc = {},
    monster_level = 65,
    npc = {{name = CHS[3000942],   x = 051, y = 034, icon = 06003},
    },
},

[17201] = {
    map_name = "百花丛中",
    map_id = 17200,
    teleport_x = 36,
    teleport_y = 43,
    npc = {{name = "百花使者",   x = 19, y = 50, icon = 06128}},
    monster_level = 0,
    unmatch_team = true,
},

[17300] = {
    map_name = CHS[3000943],
    map_id = 17300,
    teleport_x = 50,
    teleport_y = 47,
    npc = {},
    monster_level = 68,
    npc = {{name = CHS[3000944],   x = 051, y = 034, icon = 06003},
    },
},

[17400] = {
    map_name = CHS[3000945],
    map_id = 17400,
    teleport_x = 52,
    teleport_y = 25,
    npc = {},
    monster_level = 71,
    npc = {{name = CHS[3000946],   x = 034, y = 035, icon = 06003},
    },
},

[17500] = {
    map_name = CHS[3000947],
    map_id = 17500,
    teleport_x = 33,
    teleport_y = 23,
    npc = {
        {name = CHS[3000948],     x = 069, y = 022, icon = 06173},
        {name = CHS[3000949],   x = 051, y = 034, icon = 06003},
    },
    monster_level = 74,
},

[17600] = {
    map_name = CHS[3000950],
    map_id = 17600,
    teleport_x = 67,
    teleport_y = 33,
    npc = {},
    monster_level = 77,
    npc = {{name = CHS[3000951],   x = 051, y = 034, icon = 06003},
    },
},

[17700] = {
    map_name = CHS[3000952],
    map_id = 17700,
    teleport_x = 46,
    teleport_y = 45,
    npc = {
        {name = CHS[3000953],     x = 014, y = 024, icon = 06022},
        {name = CHS[3000954],   x = 034, y = 035, icon = 06003},
    },
    monster_level = 80,
},

[23000] = {
    map_name = CHS[3000955],  -- 无名小镇
    map_id = 23000,
    teleport_x = 64,
    teleport_y = 58,
    npc = {
            {name = CHS[3000956],       x = 080, y = 035, icon = 06032},
            {name = CHS[3000957],       x = 088, y = 074, icon = 06032},
            {name = CHS[3000958],   x = 047, y = 047, icon = 06011},
            {name = CHS[3000959], x = 086, y = 063, icon = 06012},
            {name = CHS[3000960],   x = 078, y = 018, icon = 06013},
            {name = CHS[3000961],   x = 042, y = 019, icon = 06016},
            {name = CHS[3000962], x = 016, y = 044, icon = 06015},
            {name = "善财童子", x = 051, y = 078, icon = 06240, headTitle = {classIcon = "ui/Icon2181.png", wordIcon = "ui/Icon2194.png"}},
            {name = "灵兽异人3",   x = 021, y = 029, icon = 06041, alias = "灵兽异人"},
            {name = "船夫5",       x = 015, y = 085, icon = 06044, alias = "船夫"},
            {name = "车夫3",       x = 016, y = 015, icon = 06045, alias = "车夫"},
            {name = CHS[3000964],  x = 076, y = 054, icon = 20006},
            {name = "南华真人",  x = 9, y = 21, icon = 6063},
    },
    monster_level = 0,
},



[26000] = {
    map_name = CHS[3000965],
    map_id = 26000,
    teleport_x = 17,
    teleport_y = 44,
    npc = {
            {name = CHS[3000966],        x = 31, y = 8, icon = 06240},
            {name = CHS[3000967],      x = 31, y = 40, icon = 06033},
            {name = CHS[3000968],        x = 038, y = 012, icon = 06036},
            {name = CHS[3000969],        x = 064, y = 15, icon = 06043},
            {name = CHS[3000970],        x = 070, y = 048, icon = 06014},
            {name = CHS[3000971],        x = 011, y = 014, icon = 06135},
    },
    monster_level = 0,
},

[26001] = {
    map_name = CHS[3000972],
    map_id = 26000,
    teleport_x = 17,
    teleport_y = 44,
    npc = {
    },
    monster_level = 0,
},

[31100] = {
    map_name = CHS[3000973],
    map_id = 08100,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
        {name = CHS[3000974], x = 60, y = 41},
    },
    monster_level = 0,
},
[31200] = {
    map_name = CHS[3000975],
    map_id = 08200,
    teleport_x = 20,
    teleport_y = 20,
    npc = {},
    monster_level = 0,
},
[31300] = {
    map_name = CHS[3000976],
    map_id = 08300,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
        {name = CHS[3000977], x = 13, y = 23},
    },
    monster_level = 0,
},

[31101] = {
    map_name = "幻·黑风一层",
    map_id = 08100,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
        {name = "二当家", icon = 06202, x = 69, y = 18, notInSmallMap = true, isActiveNPC = true},
        {name = "僵尸王", icon = 06149, x = 17, y = 19, notInSmallMap = true, isActiveNPC = true},
    },
    monster_level = 0,
},
[31201] = {
    map_name = "幻·黑风二层",
    map_id = 08200,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
    },
    monster_level = 0,
},

[31301] = {
    map_name = "幻·黑风三层",
    map_id = 08300,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
        {name = "受伤的妖狼王", icon = 06257, x = 73, y = 24, notInSmallMap = true, isActiveNPC = true},
        {name = "影狼", icon = 06257, x = 67, y = 24, notInSmallMap = true, isActiveNPC = true},
        {name = "幻境-蒙面人", icon = 06057, x = 49, y = 43, alias = "蒙面人", notInSmallMap = true, isActiveNPC = true},
    },
    monster_level = 0,
},


[32000] = {
    map_name = CHS[3000978],
    map_id = 08000,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
        {name = CHS[5300008], x = 68, y = 16}
    },
    monster_level = 0,
},
[32100] = {
    map_name = CHS[3000979],
    map_id = 06000,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
    },
    monster_level = 0,
},
[32200] = {
    map_name = CHS[3000980],
    map_id = 16100,
    teleport_x = 20,
    teleport_y = 20,
    npc = {},
    monster_level = 0,
},
[32001] = {
    map_name = "幻·兰若寺",
    map_id = 08000,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
        {name = "黑山小妖", icon = 06229, x = 67, y = 55, notInSmallMap = true, isActiveNPC = true},
        {name = "黑山小队长", icon = 06226, x = 73, y = 51, notInSmallMap = true, isActiveNPC = true},
    },
    monster_level = 0,
},
[32101] = {
    map_name = "幻·后山",
    map_id = 06000,
    teleport_x = 7,
    teleport_y = 8,
    npc = {
        {name = "小倩", icon = 06002, x = 31, y = 23, notInSmallMap = true, isActiveNPC = true},
        {name = "幻·赤霞真人", icon = 06086, x = 53, y = 14, alias = "赤霞真人", notInSmallMap = true, isActiveNPC = true},
        {name = "姥姥", icon = 06241, x = 30, y = 26, notInSmallMap = true, isActiveNPC = true},
        {name = "黑山老妖2", icon = 06258, x = 35, y = 27, alias = "黑山老妖", notInSmallMap = true, isActiveNPC = true},
    },
    monster_level = 0,
},
[32201] = {
    map_name = "幻·洞穴",
    map_id = 16100,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
        {name = "采臣", icon = 06004, x = 19, y = 19, notInSmallMap = true, isActiveNPC = true},
        {name = "黑山老妖1", icon = 06258, x = 38, y = 31, alias = "黑山老妖", notInSmallMap = true, isActiveNPC = true},
    },
    monster_level = 0,
},

[33000] = {
    map_name = CHS[3000981],
    map_id = 16000,
    teleport_x = 20,
    teleport_y = 20,
    npc = {
                {name = CHS[3000982], x = 24, y = 40},  -- 土地公公
    },
    monster_level = 0,
},
[33100] = {
            map_name = CHS[3000983],    -- 烈火涧西面
    map_id = 16001,
    teleport_x = 20,
    teleport_y = 20,
    npc = {},
    monster_level = 0,
},
[33300] = {
    map_name = CHS[3000984],
    map_id = 16001,
    teleport_x = 20,
    teleport_y = 20,
    npc = {},
    monster_level = 0,
},
[33200] = {
    map_name = CHS[3000985],
    map_id = 16001,
    teleport_x = 20,
    teleport_y = 20,
    npc = {},
    monster_level = 0,
},
[37000] = {
    map_name = CHS[3000986],    -- 通天塔
    map_id = 37000,
    teleport_x = 20,
    teleport_y = 20,
        npc = {
            {name = CHS[3000987], x = 31, y = 19},
            {name = CHS[3000988], x = 43, y = 11},
            {name = CHS[3000989], x = 31, y = 9},
            {name = CHS[3000990], x = 19, y = 11},
            {name = CHS[3000991], x = 8, y = 16},
            {name = CHS[3000992], x = 4, y = 23},
            {name = CHS[3000993], x = 58, y = 23},
            {name = CHS[3000994], x = 54, y = 16},
        },
        monster_level = 0,
	},
    [38000] = {
        map_name = CHS[5400030],  -- 楼兰城
        map_id = 38000,
        teleport_x = 20,
        teleport_y = 20,
        monster_level = 0,
        npc = {
            {name = CHS[5400038], x = 62, y = 36, icon = 06236},   -- 试道接引人
            {name = "战场物资员1", x = 101, y = 33, icon = 6014, alias = "战场物资员"}, -- 战场物资员
        },
    },
[38004] = {
    map_name = CHS[3000995],
    map_id = 38001,
    teleport_x = 20,
    teleport_y = 20,
    monster_level = 0,
        npc = {
            {name = CHS[3000996], x = 38, y = 48, icon = 06012},
        },
    },
[38005] = {
    map_name = CHS[3000997],
    map_id = 38001,
    teleport_x = 17,
    teleport_y = 44,
    npc = {
    },
    monster_level = 0,
    },
[38003] = {
        map_name = CHS[3000998],    -- 帮战地图
        map_id = 38001,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            {name = CHS[3000999],   x = 52, y = 49, icon = 6043},
        },
        monster_level = 0,

        exit_level = { [CHS[3000814]] = ""},
    },
    [38006] = {
        map_name = CHS[5400028], -- 跨服试道战场
        map_id = 38001,
        teleport_x = 17,
        teleport_y = 44,
        monster_level = 0,
        npc = {
            {name = CHS[5400029],   x = 38, y = 48, icon = 6223},  -- 天下道尊
            {name = "战场物资员2",   x = 77, y = 63, icon = 6014, alias = "战场物资员"},  -- 战场物资员
        },
    },
    [16003] = {
        map_name = CHS[3001000],
        map_id = 16000,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {

            {name = "吕洞宾1",      x = 38, y = 9,  icon = 20006, alias = "吕洞宾"},
            {name = CHS[3001002],   x = 7,  y = 18, icon = 06055},
            {name = CHS[3001003],   x = 23,  y = 39, icon = 06260},

        },
    },
    [12001] = {
        map_name = CHS[4100105], -- 不周山
        map_id = 12000,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            -- [4100106] = "张果老",
            {name = "张果老1",   x = 48, y = 57,  icon = 20009, alias = "张果老"},

        },
    },
    [16102] = {
        map_name = CHS[4100107], -- 邪冥谷
        map_id = 16100,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {

            {name = CHS[4100108],   x = 14, y = 20,  icon = 6127},
            {name = CHS[4100109],   x = 43, y = 18,  icon = 6124},
            {name = CHS[4100110],   x = 54, y = 30,  icon = 6119},
            {name = CHS[4100111],   x = 44, y = 42,  icon = 6118},
            {name = CHS[4100112],   x = 17, y = 34,  icon = 6117},
            {name = CHS[4100113], x = 35, y = 32,  icon = 6227},

        },
    },
    [17301] = {
        map_name = CHS[4200143],
        map_id = 17300,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            {name = "何仙姑1",      x = 21, y = 42, icon = 20010, alias = "何仙姑"}, -- 何仙姑
            {name = CHS[4200145],   x = 54, y = 41, icon = 06249}, -- 上古穿山甲
            {name = CHS[4200146],   x = 50, y = 39, icon = 06202}, -- 家仆
        },
    },
    [28007] ={
        map_name = CHS[4100277],
        map_id = 28007,
        monster_level = 0,
        teleport_x = 36,
        teleport_y = 29,
        npc = {},
    },

    [19000] = {
        map_name = CHS[6000334], -- 碧游宫
        map_id = 19000,
        monster_level = 0,
        teleport_x = 30,
        teleport_y = 35,
        npc = {
            {name = CHS[6000356],   x = 13, y = 22,  icon = 06064}, -- 通天教主
            {name = CHS[6000357],   x = 43, y = 25,  icon = 06243}, -- 天阙阵主
            {name = CHS[6000358],   x = 10, y = 42,  icon = 06252}, -- 红砂阵主
            {name = "传送童子1",   x = 30, y = 30,  icon = 06069, defalut_talk = CHS[6000379], alias = "传送童子"}, -- 传送童子
        },
    },

    [20000] = {
        map_name = CHS[6000335], -- 大罗宫
        map_id = 20000,
        monster_level = 0,
        teleport_x = 39,
        teleport_y = 35,
        npc = {
            {name = CHS[6000353],   x = 12, y = 18,  icon = 06065}, -- 太上老君
            {name = CHS[6000354],   x = 15, y = 38,  icon = 06244}, -- 地烈阵主
            {name = CHS[6000355],   x = 46, y = 22,  icon = 06249}, -- 烈焰阵主
            {name = "传送童子2",   x = 23, y = 22,  icon = 06069, defalut_talk = CHS[6000379], alias = "传送童子"}, -- 传送童子
        },
    },

    [21001] = {
        map_name = CHS[6000336], -- 七宝林
        map_id = 21001,
        monster_level = 0,
        teleport_x = 27,
        teleport_y = 16,
        npc = {
            {name = CHS[6000345],   x = 50, y = 7,  icon = 06066}, -- 准提道人
            {name = CHS[6000346],   x = 30, y = 7,  icon = 06250}, -- 落魄阵主
            {name = CHS[6000347],   x = 54, y = 23,  icon = 06248}, -- 化血阵主
            {name = CHS[6000348],   x = 4, y = 21,  icon = 06235}, -- 萧升
            {name = "传送童子3",   x = 45, y = 18,  icon = 06069, defalut_talk = CHS[6000379], alias = "传送童子"}, -- 传送童子
        },
    },

    [22001] = {
        map_name = CHS[6000337], -- 八德池
        map_id = 22001,
        monster_level = 0,
        teleport_x = 34,
        teleport_y = 17,
        npc = {
            {name = CHS[6000349],   x = 19, y = 6,  icon = 06063}, -- 西方教主
            {name = CHS[6000350],   x = 14, y = 43,  icon = 06251}, -- 红水阵主
            {name = CHS[6000351],   x = 50, y = 25,  icon = 06246}, -- 寒冰阵主
            {name = CHS[6000352],   x = 18, y = 20,  icon = 06232}, -- 曹宝
            {name = "传送童子4",   x = 33, y = 8,  icon = 06069, defalut_talk = CHS[6000379], alias = "传送童子"}, -- 传送童子
        },
    },

    [15002] = {
        map_name = CHS[3001004],
        map_id = 22001,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            {name = CHS[3001005],   x = 50,  y = 25, icon = 06139},   -- 牡丹仙子
            {name = CHS[3001006],   x = 21,  y = 8, icon = 06071},
            {name = CHS[3001007],   x = 13,  y = 44, icon = 06223},
        },
    },

    [25000] = {
        map_name = CHS[6000338], -- 西昆仑
        map_id = 25000,
        monster_level = 0,
        teleport_x = 31,
        teleport_y = 27,
        npc = {
            {name = CHS[6000342],   x = 14, y = 16,  icon = 06061},
            {name = CHS[6000343],   x = 8, y = 26,  icon = 06247}, -- 金光阵主
            {name = CHS[6000344],   x = 30, y = 8,  icon = 06245}, -- 风吼阵主
            {name = "传送童子5",   x = 27, y = 19,  icon = 06069, defalut_talk = CHS[6000379], alias = "传送童子"}, -- 传送童子
        },
    },

    [25010] = {
        map_name = CHS[4100361], -- 云中道
        map_id = 25002,
        monster_level = 0,
        npc = {
            {name = "蓝采和1",       x = 46, y = 4,  icon = 20007, alias = "蓝采和"}, -- 蓝采和
            {name = CHS[4100363],   x = 46, y = 6,  icon = 07009}, -- 书童
            {name = CHS[4100364],   x = 8, y = 28,  icon = 06228}, -- 阎罗殿传送人
        },
    },


    [14003] = {
        map_name = CHS[6000309], -- 绝人阵
        map_id = 14003,
        monster_level = 0,
        teleport_x = 33,
        teleport_y = 39,
        npc = {
            {name = CHS[6000366],   x = 7, y = 35,  icon = 06258}, -- 灵妖王
            {name = CHS[4200147],   x = 36, y = 16,  icon = 06003}
        },
    },

    [14004] = {
        map_name = CHS[6000320], -- 绝仙阵
        map_id = 14004,
        monster_level = 0,
        teleport_x = 35,
        teleport_y = 33,
        npc = {
            {name = CHS[6000368],   x = 50, y = 16,  icon = 06244}, -- 九世道人
            {name = CHS[6000369],   x = 38, y = 5,  icon = 06143}, -- 翻天鼠
            {name = CHS[4100253],   x = 53, y = 40,  icon = 06003} -- 绝仙阵守护神
        },
    },

    [14005] = {
        map_name = CHS[6000323], -- 地绝阵
        map_id = 14005,
        monster_level = 0,
        teleport_x = 31,
        teleport_y = 25,
        npc = {
            {name = CHS[6000370],   x = 55, y = 16,  icon = 06214}, -- 金大升
            {name = CHS[4200149],   x = 56, y = 44,  icon = 06003} -- 地绝阵守护神
        },
    },

    [14006] = {
        map_name = CHS[6000326], -- 天绝阵
        map_id = 14006,
        monster_level = 0,
        teleport_x = 50,
        teleport_y = 44,
        npc = {
            {name = CHS[6000371],   x = 31, y = 7,  icon = 06223}, -- 袁洪
            {name = CHS[4200150],   x = 40, y = 27,  icon = 06003} -- 天绝阵守护神
        },
    },

    [14008] = {
        map_name = CHS[7100160], -- 外冢一层
        map_id = 14003,
        monster_level = 0,
        unswitch_line = true,
        npc = {
        },
    },

    [14009] = {
        map_name = CHS[7100157], -- 外冢二层
        map_id = 14004,
        monster_level = 0,
        unswitch_line = true,
        npc = {
        },
    },

    [14010] = {
        map_name = CHS[7100158], -- 内冢
        map_id = 14005,
        monster_level = 0,
        unswitch_line = true,
        npc = {
        },
    },

    [16004] = {
        map_name = CHS[4100365], -- 阎罗殿
        map_id = 16001,
        monster_level = 0,
        npc = {
            {name = CHS[4100366],   x = 32, y = 17,  icon = 20056}, -- 牛头
            {name = CHS[4100367],   x = 38, y = 20,  icon = 20057}, -- 马面
            {name = CHS[4100368],   x = 44, y = 9,  icon = 20051}, -- 阎罗王
        },
    },

    [27000] = {
        map_name = CHS[6000329], -- 海底迷宫
        map_id = 27000,
        monster_level = 0,
        teleport_x = 28,
        teleport_y = 20,
        npc = {
            {name = CHS[4200151],   x = 43, y = 15,  icon = 06003} -- "海底迷宫守护神"
        },
    },

    [27005] = {
        map_name = CHS[7002023], -- 海底幽径
        map_id = 27000,
        monster_level = 0,
        teleport_x = 28,
        teleport_y = 20,
        npc = {

                {name = "铁拐李2",   x = 36, y = 11,  icon = 20004, alias = "铁拐李"}, -- 铁拐李
                {name = "张果老2",   x = 40, y = 8 ,  icon = 20009, alias = "张果老"}, -- 张果老
                {name = "汉钟离2",   x = 18, y = 14,  icon = 20005, alias = "汉钟离"}, -- 汉钟离
                {name = "蓝采和2",   x = 16, y = 16,  icon = 20007, alias = "蓝采和"}, -- 蓝采和
        },
    },

    [27006] = {
        map_name = CHS[7002024], -- 龙宫宫殿
        map_id = 27002,
        monster_level = 0,
        teleport_x = 43,
        teleport_y = 25,
        npc = {
                {name = "韩湘子2",   x = 37, y = 12,  icon = 20008, alias = "韩湘子"}, -- 韩湘子
                {name = "吕洞宾3",   x = 39, y = 10,  icon = 20006, alias = "吕洞宾"}, -- 吕洞宾
            {name = CHS[7002028],   x = 13,  y = 7 ,  icon = 06079}, -- 敖广
        },
    },

    [18000] = {
        map_name = CHS[6000317], -- 东昆仑
        map_id = 18000,
        monster_level = 0,
        teleport_x = 42,
        teleport_y = 64,
        npc = {
            {name = CHS[6000363],   x = 28, y = 70,  icon = 06244}, -- 吴了尘
            {name = "船夫2",   x = 18, y = 87,  icon = 06044, alias = "船夫"}, -- 船夫
            {name = CHS[6000365],   x = 51, y = 49,  icon = 06108}, -- 小猿猴
            {name = CHS[6000385],   x = 46, y = 23,  icon = 06249}, -- 申伏虎
            {name = CHS[4200152],   x = 16, y = 37,  icon = 06003} -- 东昆仑守护神
        },
    },

    [25002] = {
        map_name = CHS[6000332], -- 昆仑云海
        map_id = 25002,
        monster_level = 0,
        teleport_x = 26,
        teleport_y = 20,
        npc = {
            {name = CHS[4200153],   x = 45, y = 11,  icon = 06003} -- 昆仑云海守护神
        },
    },

    [14002] = {
        map_name = CHS[6000339], -- 盘虬洞
        map_id = 14002,
        monster_level = 0,
        teleport_x = 23,
        teleport_y = 20,
        npc = {
            {name = CHS[6000362],   x = 21, y = 9,  icon = 06032, defalut_talk = CHS[6000377]} -- 张真人
        },
    },

    [27002] = {
        map_name = CHS[6000340], -- 龙宫大殿
        map_id = 27002,
        monster_level = 0,
        teleport_x = 31,
        teleport_y = 24,
        npc = {
            {name = CHS[6000360],   x = 13, y = 7,  icon = 06079}, -- 龙王
            {name = CHS[6000361],   x = 43, y = 9,  icon = 06054}, -- 龙女
                {name = "侍女1",   x = 17, y = 16,  icon = 6173, alias = "侍女"}, -- 侍女
                {name = "侍女2",   x = 26, y = 12,  icon = 6173, alias = "侍女"}, -- 侍女
        },
    },

    [27003] = {
        map_name = CHS[4000382], -- 东海深宫
        map_id = 27002,
        monster_level = 0,
        teleport_x = 43,
        teleport_y = 25,
        npc = {
            {name = CHS[4200142],       x = 13, y = 7, icon = 06079}, -- 东海龙王
        },
    },

    [27001] = {
        map_name = CHS[6000341], -- 龙宫
        map_id = 27001,
        monster_level = 0,
        teleport_x = 27,
        teleport_y = 22,
        npc = {
            {name = "龙宫使者1",   x = 46, y = 19,  icon = 06163, defalut_talk = CHS[6000376], alias = "龙宫使者"}, -- 龙宫使者
        },
    },

    [9002] = {
        map_name = CHS[4100278],  --"东胜岛"
        map_id = 9000,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {

            {name = "曹国舅1",     x = 35, y = 41,  icon = 20011, alias = "曹国舅"}, -- 曹国舅
            {name = CHS[4100281],       x = 22, y = 13,  icon = 6124 }, -- 蛟龙
            {name = CHS[4100282],   x = 16, y = 45,  icon = 6223 }, -- 东胜尊神

        },
    },

    [25005] = {
            map_name = "飘渺仙府",
            map_id = 25000,
            monster_level = 0,
            teleport_x = 31,
            teleport_y = 27,
            npc = {
                {name = "引路童子",   x = 27, y = 19,  icon = 06069 },
                {name = "恶仆",   x = 37, y = 30,  icon = 06245 },
                {name = "武痴",   x = 7, y = 26,  icon = 20037 },
            },
    },

    [25006] = {
            map_name = "仙府秘境",
            map_id = 25002,
            monster_level = 0,
            teleport_x = 26,
            teleport_y = 20,
            npc = {
                {name = "双面鬼",   x = 14, y = 31,  icon = 20058 },
            },
        },

    [27004] = {
        map_name = CHS[4100283],        -- 蛟龙宫殿
        map_id = 27002,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {

            {name = CHS[4100284],   x = 18, y = 10,  icon = 6190 }, -- 蛟龙族长

        },
    },

    [27007] = {
            map_name = "仙府大殿",
            map_id = 27002,
            monster_level = 0,
            teleport_x = 31,
            teleport_y = 24,
            npc = {
                {name = '侍剑者',   x = 26, y = 12,  icon = 06272 },
                {name = '侍书者',   x = 17, y = 16,  icon = 06307 },
                {name = '飘渺府主',   x = 13, y = 7,  icon = 20008 },
            },
        },

    [3002] = {
        map_name = CHS[4100318],     -- 吐蕃境内
        map_id = 3000,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            {name = '白发老翁',   x = 14, y = 22,  icon = 20009 }, -- 白发老翁
        },
    },

    [14007] = {
        map_name = CHS[4100319],    -- '紫金四皓峰',
        map_id = 14000,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            {name = '东华上仙',   x = 22, y = 12,  icon = 6066 }, -- 东华上仙
            {name = '太上老君1',   x = 18, y = 45,  icon = 6065 , alias = "太上老君"}, -- 太上老君
        },
    },

    [16103] = {
        map_name = CHS[4100320],        -- '龙崆洞',
        map_id = 16100,
        monster_level = 0,
        teleport_x = 17,
        teleport_y = 44,
        npc = {

            {name = '玉匣',   x = 21, y = 21,  icon = 20038 }, -- 玉匣
            {name = '李副将',   x = 43, y = 34,  icon = 860801 }, -- 李副将

        },
    },
    [16104] = {
        map_name = CHS[7003009], -- 海底世界
        map_id = 16100,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            {name = CHS[7003014],   x = 37, y = 38, icon = 06241},
        },
        monster_level = 0,
    },

    [38010] = {
        map_name = CHS[7002105], -- 舞会场地
        map_id = 38000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        monster_level = 0,
    },

    [38011] = {
        map_name = CHS[7002128], -- 百兽战场
        map_id = 38000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        monster_level = 0,
    },

    [38007] = {
        map_name = "全民热身赛场",
        map_id = 38001,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            {name = "全民PK赛接引人",   x = 38, y = 48, icon = 06236},
            {name = "全民战场物资员1",   x = 77, y = 63, icon = 06014, alias = "战场物资员"},
        },
        monster_level = 0,
    },

    [38008] = {
        map_name = "全民楼兰城",
        map_id = 38000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "全民楼兰城接引人",   x = 62, y = 36, icon = 06236},
            {name = "全民战场物资员2",   x = 101, y = 33, icon = 06014, alias = "战场物资员"},
        },
        monster_level = 0,
    },

    [38009] = {
        map_name = "全民赛场",
        map_id = 38001,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            {name = "全民战场物资员3",   x = 77, y = 63, icon = 06014, alias = "战场物资员"},
        },
        monster_level = 0,
    },

    [38020] = {
        map_name = "争霸楼兰城",
        map_id = 38000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
                {name = "名人争霸赛场接引人",   x = 62, y = 36, icon = 6236, alias = "赛场接引人"},
                {name = "战场物资员5",   x = 101, y = 33, icon = 6014, alias = "战场物资员"},
        },
        monster_level = 0,
    },

    [38021] = {
        map_name = "争霸战场",
        map_id = 38001,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
                {name = "战场物资员6",   x = 77, y = 63, icon = 6014, alias = "战场物资员"},
                {name = "名人争霸战场接引人",   x = 38, y = 48, icon = 6223, alias = "战场接引人"},
        },
        monster_level = 0,
    },

    [38022] = {
        map_name = "城市赛场",
        map_id = 38001,
        teleport_x = 17,
        teleport_y = 44,
        npc = {
            {name = "全民战场物资员7",   x = 77, y = 63, icon = 6014, alias = "战场物资员"},
        },
        monster_level = 0,
    },

    [15004] = {
        map_name = "须弥秘境",
        map_id = 15001,
        teleport_x = 43,
        teleport_y = 25,
        npc = {

        },
        monster_level = 0,
    },

    [38014] = {
        map_name = "蓝毛巨兽巢穴",
        map_id = 08100,
        teleport_x = 41,
        teleport_y = 41,
        npc = {
        },
        monster_level = 0,
    },

    [38015] = {
        map_name = "聚宝矿洞",
        map_id = 08200,
        teleport_x = 59,
        teleport_y = 38,
        npc = {
        },
        monster_level = 0,
    },

    [38016] = {
        map_name = "赤焰炼魔巢穴",
        map_id = 08300,
        teleport_x = 25,
        teleport_y = 37,
        npc = {
        },
        monster_level = 0,
    },

    [10102] = {
        map_name = "万妖窟一层",
        map_id = 10100,
        teleport_x = 64,
        teleport_y = 34,
        npc = {
            {name = "玄武神将1",   x = 73, y = 13, icon = 06223, alias = "玄武神将"},
        },
        monster_level = 0,
        unfly = true,
        unfly_tip = "本地图插翅难飞！",
        unswitch_line = true,
        unmatch_team = true,
    },

    [10202] = {
        map_name = "万妖窟二层",
        map_id = 10200,
        teleport_x = 64,
        teleport_y = 34,
        npc = {
            {name = "玄武神将2",   x = 74, y = 53, icon = 06223, alias = "玄武神将"},
        },
        monster_level = 0,
        unfly = true,
        unfly_tip = "本地图插翅难飞！",
        unswitch_line = true,
        unmatch_team = true,
    },

    [10302] = {
        map_name = "万妖窟三层",
        map_id = 10300,
        teleport_x = 64,
        teleport_y = 34,
        npc = {
            {name = "玄武神将3",   x = 10, y = 54, icon = 06223, alias = "玄武神将"},
        },
        monster_level = 0,
        unfly = true,
        unfly_tip = "本地图插翅难飞！",
        unswitch_line = true,
        unmatch_team = true,
    },

    [10402] = {
        map_name = "万妖窟四层",
        map_id = 10400,
        teleport_x = 64,
        teleport_y = 34,
        npc = {
            {name = "玄武神将4",   x = 11, y = 13, icon = 06223, alias = "玄武神将"},
        },
        monster_level = 0,
        unfly = true,
        unfly_tip = "本地图插翅难飞！",
        unswitch_line = true,
        unmatch_team = true,
    },

    [10502] = {
        map_name = "万妖窟五层",
        map_id = 10500,
        teleport_x = 64,
        teleport_y = 34,
        npc = {
            {name = "玄武神将5",   x = 5, y = 16, icon = 06223, alias = "玄武神将"},
        },
        monster_level = 0,
        unfly = true,
        unfly_tip = "本地图插翅难飞！",
        unswitch_line = true,
        unmatch_team = true,
    },
    [38012] = {
        map_name = "先锋营地",
        map_id = 38001,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
             {name = "先锋官",   x = 92, y = 25, icon = 06031},    -- 先锋官
             {name = "义士头领",   x = 85, y = 21, icon = 06033},  -- 义士头领
             {name = "试炼木桩",   x = 81, y = 24, icon = 06219},  -- 试炼木桩
             {name = "蛮熊将军", x = 22, y = 77, icon = 06203, notInSmallMap = true, isActiveNPC = true}, -- 蛮熊将军
        },
        monster_level = 0,
        unfly = true,
        unfly_tip = "当前地图无法直接离开。",
        unswitch_line = true,
        unmatch_team = true,
    },
    [38013] = {
        map_name = "中洲古城",
        map_id = 38000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "蛮熊主帅", x = 82, y = 46, icon = 06600, notInSmallMap = true, isActiveNPC = true}, -- 蛮熊主帅
        },
        monster_level = 0,
        unfly = true,
        unfly_tip = "当前地图无法直接离开。",
        unswitch_line = true,
        unmatch_team = true,
    },

    [19002] = {
        map_name = "雪域冰原",
        map_id = 19002,
        teleport_x = 41,
        teleport_y = 25,
        npc = {
            {name = CHS[7002272],   x = 17, y = 45,  icon = 06003}, -- "雪域冰原守护神"
            {name = "无底洞",   x = 57, y = 14, icon = 06274, isActiveNPC = true}, -- "无底洞"
            {name = "球球",   x = 28, y = 5, icon = 20018},
        },
        monster_level = 0,
    },

    [21000] = {
        map_name = "迷境花树",
        map_id = 21000,
        teleport_x = 35,
        teleport_y = 30,
        npc = {
            {name = CHS[7002273],   x = 44, y = 38,  icon = 06003} -- "迷境花树守护神"
        },
        monster_level = 0,
    },

    [22000] = {
        map_name = "水云间",
        map_id = 22000,
        teleport_x = 33,
        teleport_y = 25,
        npc = {
            {name = CHS[7002274],   x = 15, y = 36,  icon = 06003} -- "水云间守护神"
        },
        monster_level = 0,
    },

    [20002] = {
        map_name = CHS[7190107],        -- 热砂荒漠
        map_id = 20002,
        teleport_x = 11,
        teleport_y = 22,
        npc = {
            {name = "热砂荒漠守护神",   x = 24, y = 13,  icon = 06003} -- "热砂荒漠守护神"
        },
        monster_level = 0,
        exit_level = {},
    },

    [20003] = {
        map_name = "埋骨之地",
        map_id = 20002,
        teleport_x = 11,
        teleport_y = 22,
        npc = {
            {name = "埋骨逍遥仙",  x = 35, y = 36, icon = 6032,  alias = "逍遥仙"},
            {name = "大日金乌",    x = 55, y = 18, icon = 6310 },
            {name = "金乌之灵",    x = 51, y = 24, icon = 6311 },
            {name = "火狮兽",      x = 57, y = 26, icon = 6312 },
            {name = "火焰之灵",    x = 47, y = 22, icon = 6313 },
        },
        monster_level = 0,
        unmatch_team = true,
    },

    [20004] = {
        map_name = "极热之地",
        map_id = 20002,
        teleport_x = 39,
        teleport_y = 42,
        monster_level = 0,
        npc = {
                {name = "炼魔", x = 31, y = 12, icon = 06153},
        },
    },

    [37001] = {
        map_name = "粽仙楼一层",
        map_id = 37000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "仙楼神将1", x = 31, y = 10, icon = 06223, alias = "仙楼神将"},
            {name = "青龙1", x = 8, y = 16, icon = 06190, alias = "青龙"},
            {name = "白虎1", x = 19, y = 11, icon = 06189, alias = "白虎"},
            {name = "朱雀1", x = 43, y = 11, icon = 06192, alias = "朱雀"},
            {name = "玄武1", x = 53, y = 16, icon = 06191, alias = "玄武"},
        },
        monster_level = 0,
    },


    [37002] = {
        map_name = "粽仙楼二层",
        map_id = 37000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "仙楼神将2", x = 31, y = 10, icon = 06223, alias = "仙楼神将"},
            {name = "粽仙楼左护法", x = 19, y = 11, icon = 06249},
            {name = "粽仙楼右护法", x = 43, y = 11, icon = 06248},
        },
        monster_level = 0,
    },

    [37003] = {
        map_name = "粽仙楼三层",
        map_id = 37000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "粽仙幻影", x = 31, y = 10, icon = 20010},
        },
        monster_level = 0,
    },
    [28100] = {
        map_name = "小舍-前庭",
        map_id = 28100,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        range = { x1 = 96, x2 = 48, y1 = 0, y2 = 72 },
        monster_level = 0,
    },
    [28101] = {
        map_name = "小舍-房屋",
        map_id = 28101,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "管家1", x = 23, y = 34, icon = 06011, alias = "管家"},
        },
        range = { x1 = 96, x2 = 168, y1 = 0, y2 = 96 },
        exit_range = {
            ["24_39"] = 1.2,
            ["60_20"] = 1.2,
        },
        monster_level = 0,
    },
    [28102] = {
        map_name = "小舍-后院",
        map_id = 28102,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "园丁1", x = 26, y = 34, icon = 51517, alias = "园丁"},
        },

		croplands = {
		    [2] = {name = "农田", x = 690, y = 562},
			[4] = {name = "农田", x = 570, y = 502},
			[6] = {name = "农田", x = 450, y = 442},
			[8] = {name = "农田", x = 330, y = 382},
			[1] = {name = "农田", x = 810, y = 502},
		    [3] = {name = "农田", x = 690, y = 442},
			[5] = {name = "农田", x = 570, y = 382},
			[7] = {name = "农田", x = 450, y = 322},
		},

        range = { x1 = 0, x2 = 0, y1 = 96, y2 = 0 },
        monster_level = 0,
    },
    [28103] = {
        map_name = "小童父母家",
        map_id = 28101,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        range = { x1 = 96, x2 = 168, y1 = 0, y2 = 96 },
        exit_range = {
            ["24_39"] = 1.2,
            ["60_20"] = 1.2,
        },
        monster_level = 0,
        notDrawTeam = true,
    },
    [28104] = {
        map_name = "小童叔叔家",
        map_id = 28101,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        range = { x1 = 96, x2 = 168, y1 = 0, y2 = 96 },
        exit_range = {
            ["24_39"] = 1.2,
            ["60_20"] = 1.2,
        },
        monster_level = 0,
        notDrawTeam = true,
    },
    [28105] = {
        map_name = "常舌馥家",
        map_id = 28101,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        range = { x1 = 96, x2 = 168, y1 = 0, y2 = 96 },
        exit_range = {
            ["24_39"] = 1.2,
            ["60_20"] = 1.2,
        },
        monster_level = 0,
        notDrawTeam = true,
    },
    [28106] = {
        map_name = "小童爷爷家",
        map_id = 28101,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        range = { x1 = 96, x2 = 168, y1 = 0, y2 = 96 },
        exit_range = {
            ["24_39"] = 1.2,
            ["60_20"] = 1.2,
        },
        monster_level = 0,
        notDrawTeam = true,
    },
    [28200] = {
        map_name = "雅筑-前庭",
        map_id = 28200,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        range = { x1 = 96, x2 = 48, y1 = 0, y2 = 72 },
        monster_level = 0,
    },
    [28201] = {
        map_name = "雅筑-房屋",
        map_id = 28201,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "管家2", x = 27, y = 40, icon = 06011, alias = "管家"},
        },
        range = { x1 = 96, x2 = 168, y1 = 0, y2 = 96 },
        exit_range = {
            ["28_45"] = 1.2,
            ["72_22"] = 1.2,
        },
        monster_level = 0,
    },
    [28202] = {
        map_name = "雅筑-后院",
        map_id = 28202,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "园丁2", x = 30, y = 32, icon = 51517, alias = "园丁"},
        },

	    croplands = {
		    [3] = {name = "农田", x = 678, y = 760},
			[6] = {name = "农田", x = 558, y = 700},
			[9] = {name = "农田", x = 438, y = 640},
			[12] = {name = "农田", x = 318, y = 580},
			[2] = {name = "农田", x = 798, y = 700},
		    [5] = {name = "农田", x = 678, y = 640},
			[8] = {name = "农田", x = 558, y = 580},
			[11] = {name = "农田", x = 438, y = 520},
			[1] = {name = "农田", x = 918, y = 640},
		    [4] = {name = "农田", x = 798, y = 580},
			[7] = {name = "农田", x = 678, y = 520},
			[10] = {name = "农田", x = 558, y = 460},
		},

        range = { x1 = 0, x2 = 0, y1 = 96, y2 = 0 },
        monster_level = 0,
    },
    [28300] = {
        map_name = "豪宅-前庭",
        map_id = 28300,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        range = { x1 = 96, x2 = 48, y1 = 0, y2 = 72 },
        monster_level = 0,
    },
    [28301] = {
        map_name = "豪宅-房屋",
        map_id = 28301,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "管家3", x = 32, y = 46, icon = 06011, alias = "管家"},
        },
        range = { x1 = 96, x2 = 168, y1 = 0, y2 = 96 },
        exit_range = {
            ["32_51"] = 1.2,
            ["84_24"] = 1.2,
        },
        monster_level = 0,
    },
    [28401] = {
        map_name = "小岚之家",
        map_id = 28101,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
        },
        range = { x1 = 96, x2 = 168, y1 = 0, y2 = 96 },
        exit_range = {
            ["24_39"] = 1.2,
            ["60_20"] = 1.2,
        },
        monster_level = 0,
        unmatch_team = true,
    },
    [28302] = {
        map_name = "豪宅-后院",
        map_id = 28302,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "园丁3", x = 34, y = 38, icon = 51517, alias = "园丁"},
        },

		croplands = {
		    [4] = {name = "农田", x = 681, y = 877},
			[8] = {name = "农田", x = 561, y = 817},
			[12] = {name = "农田", x = 441, y = 757},
			[16] = {name = "农田", x = 321, y = 697},
			[3] = {name = "农田", x = 801, y = 817},
		    [7] = {name = "农田", x = 681, y = 757},
			[11] = {name = "农田", x = 561, y = 697},
			[15] = {name = "农田", x = 441, y = 637},
	        [2] = {name = "农田", x = 921, y = 757},
			[6] = {name = "农田", x = 801, y = 697},
			[10] = {name = "农田", x = 681, y = 637},
			[14] = {name = "农田", x = 561, y = 577},
			[1] = {name = "农田", x = 1041, y = 697},
		    [5] = {name = "农田", x = 921, y = 637},
			[9] = {name = "农田", x = 801, y = 577},
			[13] = {name = "农田", x = 681, y = 517},
		},

        range = { x1 = 0, x2 = 0, y1 = 192, y2 = 0 },
        monster_level = 0,
    },
    [37004] = {
        map_name = "众仙塔一层",
        map_id = 37000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "仙塔传送人1", x = 31, y = 10, icon = 06223, alias = "仙塔传送人"},
            {name = "修士1", x = 4, y = 23, icon = 861101, alias = "修士"},
            {name = "修士2", x = 8, y = 16, icon = 861102, alias = "修士"},
            {name = "修士3", x = 19, y = 11, icon = 861103, alias = "修士"},
            {name = "修士4", x = 43, y = 11, icon = 861104, alias = "修士"},
            {name = "修士5", x = 53, y = 16, icon = 861101, alias = "修士"},
            {name = "修士6", x = 58, y = 23, icon = 871101, alias = "修士"},
        },
        monster_level = 0,
    },
    [37005] = {
        map_name = "众仙塔二层",
        map_id = 37000,
        teleport_x = 20,
        teleport_y = 20,
        npc = {
            {name = "仙塔传送人2", x = 31, y = 10, icon = 06223, alias = "仙塔传送人"},
            {name = "修士7", x = 8, y = 16, icon = 871102, alias = "修士"},
            {name = "修士8", x = 19, y = 11, icon = 871103, alias = "修士"},
            {name = "修士9", x = 43, y = 11, icon = 871104, alias = "修士"},
            {name = "修士10", x = 53, y = 16, icon = 871105, alias = "修士"},
        },
        monster_level = 0,
    },
    [38017] = {
        map_name = "跨服楼兰城",  -- 跨服楼兰城
        map_id = 38000,
        teleport_x = 20,
        teleport_y = 20,
        monster_level = 0,
        npc = {
                {name = "联赛战场接引人", x = 62, y = 36, icon = 06236, alias = "战场接引人"},   -- 联赛战场接引人
                {name = "联赛战场物资员", x = 101, y = 33, icon = 6014, alias = "战场物资员"}, -- 联赛战场物资员
        },
    },
    [38001] = {
        map_name = "跨服战场",  -- 跨服战场
        map_id = 38001,
        teleport_x = 20,
        teleport_y = 20,
        monster_level = 0,
        npc = {
            {name = "雷霆战神", x = 38, y = 48, icon = 06223},   -- 雷霆战神联赛
            {name = "联赛战场物资员", x = 77, y = 63, icon = 6014, alias = "战场物资员"}, -- 联赛战场物资员
        },
    },
    [39002] = {
        map_name = "左方帮派营地",
        map_id = 38001,
        teleport_x = 20,
        teleport_y = 20,
        monster_level = 0,
        flipX = true,
        npc = {
                {name = "帮战使者1", x = 25, y = 18, icon = 06043, alias = "帮战使者"},
                {name = "寨门守卫1", x = 56, y = 34, icon = 06236, alias = "寨门守卫"},
                --{name = "木材", x = 70, y = 24, icon = 06043},
                --{name = "铁块", x = 26, y = 45, icon = 06043},
        },
        unmatch_team = true,
    },
    [39003] = {
        map_name = "右方帮派营地",
        map_id = 38001,
        teleport_x = 20,
        teleport_y = 20,
        monster_level = 0,
        npc = {
                {name = "帮战使者2", x = 108, y = 18, icon = 06043, alias = "帮战使者"},
                {name = "寨门守卫2", x = 77, y = 34, icon = 06236, alias = "寨门守卫"},
                --{name = "木材", x = 63, y = 24, icon = 06043},
                --{name = "铁块", x = 107, y = 45, icon = 06043},
        },
        unmatch_team = true,
    },
    [39001] = {
        map_name = "矿区",
        map_id = 39001,
        teleport_x = 20,
        teleport_y = 20,
        monster_level = 0,
        unmatch_team = true,
    },


    [18001] = {
        map_name = "雪精圣地",
        map_id = 19002,
        monster_level = 0,
        teleport_x = 42,
        teleport_y = 64,
        npc = {
            {name = "雪精碎片1",  x = 20, y = 50,  icon = 20015, alias = "雪精碎片"},
            {name = "雪精碎片2",  x = 39, y = 45,  icon = 20015, alias = "雪精碎片"},
            {name = "雪精碎片3",  x = 25, y = 31,  icon = 20015, alias = "雪精碎片"},
            {name = "雪精碎片4",  x = 55, y = 36,  icon = 20015, alias = "雪精碎片"},
            {name = "雪精碎片5",  x = 57, y = 21,  icon = 20015, alias = "雪精碎片"},
            {name = "雪精碎片6",  x = 32, y = 19,  icon = 20015, alias = "雪精碎片"},
            {name = "雪精碎片7",  x = 39, y = 6,  icon = 20015, alias = "雪精碎片"},
            {name = "雪精碎片8",  x = 11, y = 10,  icon = 20015, alias = "雪精碎片"},
            {name = "调皮的雪精", x = 12, y = 23,   icon = 20018},
            {name = "稳重的雪精", x = 8, y = 43,  icon = 20018},
        },
        unmatch_team = true,
        unswitch_line = true,
    },


    [38018] = {
        map_name = "竞技楼兰城",
        map_id = 38000,
        teleport_x = 20,
        teleport_y = 20,
        monster_level = 0,
        npc = {
            {name = "竞技接引人", x = 62, y = 36, icon = 06236},   -- 竞技接引人
            {name = "战场物资员3", x = 101, y = 33, icon = 6014, alias = "战场物资员"},
        },
    },
    [38019] = {
        map_name = "跨服竞技战场",
        map_id = 38001,
        teleport_x = 20,
        teleport_y = 20,
        monster_level = 0,
        npc = {
            {name = "跨服竞技使者", x = 38, y = 48, icon = 06223, alias = "竞技使者"},
            {name = "战场物资员4", x = 77, y = 63, icon = 6014, alias = "战场物资员"},
        },
        unmatch_team = true,
        unswitch_line = true,
    },

[29002] = {
    map_name = "证道殿",
    map_id = 29002,
    teleport_x = 120,
    teleport_y = 175,
    npc = {
        {name = "道虚真人", x = 14, y = 11, icon = 6058},
    },
    monster_level = 0,
},

[05005] = {
    map_name = "喜来客栈",
    map_id = 05005,
    teleport_x = 5,
    teleport_y = 5,
    monster_level = 0,
    npc = {
        {name = "客栈掌柜", x = 15, y = 42, icon = 06011},
    },
    mapType = 2,
    unmatch_team    = true,
},

[05007] = {
    map_name = "中秋大胃王",
    map_id = 05005,
    teleport_x = 5,
    teleport_y = 5,
    monster_level = 0,
    npc = {
    },
    mapType = 2,
    unmatch_team    = true,
},

[05008] = {
    map_name = "相约元宵客栈",
    map_id = 05005,
    teleport_x = 5,
    teleport_y = 5,
    monster_level = 0,
    npc = {
    },
    mapType = 2,
    unmatch_team    = true,
},
[05009] = {
    map_name = "千面酒会",
    map_id = 05005,
    teleport_x = 5,
    teleport_y = 5,
    monster_level = 0,
    npc = {
    },
    -- mapType = 2,
    unmatch_team    = true,
},

[05004] = {
    map_name = "官府",
    map_id = 05004,
    teleport_x = 21,
    teleport_y = 29,
    npc = {
        {name = "70", x = 36, y = 30, icon = 06223, notInSmallMap = true, alias = "英雄会评判员", isActiveNPC = true},
        {name = "80", x = 41, y = 27, icon = 06223, notInSmallMap = true, alias = "英雄会评判员", isActiveNPC = true},
        {name = "90", x = 46, y = 24, icon = 06223, notInSmallMap = true, alias = "英雄会评判员", isActiveNPC = true},
        {name = "100", x = 18, y = 22, icon = 06223, notInSmallMap = true, alias = "英雄会评判员", isActiveNPC = true},
        {name = "110", x = 24, y = 19, icon = 06223, notInSmallMap = true, alias = "英雄会评判员", isActiveNPC = true},
        {name = "120", x = 30, y = 16, icon = 06223, notInSmallMap = true, alias = "英雄会评判员", isActiveNPC = true},
        {name = CHS[3000844],     x = 47, y = 9, icon = 06031}, -- 夏总兵夏总兵
        {name = CHS[3000839],     x = 54, y = 12, icon = 06011}, -- 贾师爷
        {name = CHS[7190217],     x = 11, y = 18, icon = 06043}, -- 李捕头
    },
    monster_level = 0,
},


[50000] = {
    map_name = "云霄宫",
    map_id = 50000,
    teleport_x = 42,
    teleport_y = 57,
    monster_level = 0,
    npc = {
        {name = "复元仙", x = 76, y = 25, icon = 20071},
        {name = "百宝仙", x = 101, y = 38, icon = 20072},
        {name = "通灵药王", x = 100, y = 70, icon = 20075},
        {name = "钧天君", x = 56, y = 50, icon = 06418},
    },
},

[50001] = {
    map_name = "南天门",
    map_id = 50001,
    teleport_x = 22,
    teleport_y = 51,
    monster_level = 0,
    npc = {
        {name = "太清真君", x = 8, y = 20, icon = 20065},
        {name = "太玄真君", x = 71, y = 54, icon = 20065},
    },
},


[17101] = {
    map_name = "花谷幻境一",
    map_id = 17100,
    teleport_x = 20,
    teleport_y = 20,
    monster_level = 0,
    npc = {
         {name = "幻境傀儡1", x = 36, y = 21, icon = 51524, notInSmallMap = true, alias = CHS[7190255]},
    },
},


[17102] = {
    map_name = "万花谷",
    map_id = 17100,
    teleport_x = 20,
    teleport_y = 20,
    monster_level = 0,
    npc = {

    },

        unmatch_team = true,
    unswitch_line = true,
    notShowExitInSmallMap = true,
    notDrawTeam = true,
},

[17202] = {
    map_name = "花谷幻境二",
    map_id = 17200,
    teleport_x = 20,
    teleport_y = 20,
    monster_level = 0,
    npc = {
        {name = "幻境傀儡2", x = 39, y = 22, icon = 51524, notInSmallMap = true, alias = CHS[7190255]},
    },
},

[17302] = {
    map_name = "花谷幻境三",
    map_id = 17300,
    teleport_x = 20,
    teleport_y = 20,
    monster_level = 0,
    npc = {
        {name = "幻境傀儡3", x = 38, y = 22, icon = 51524, notInSmallMap = true, alias = CHS[7190255]},
    },
},

[17401] = {
    map_name = "卧龙花谷",
    map_id = 17400,
    teleport_x = 20,
    teleport_y = 20,
    monster_level = 0,
    npc = {
    },
},

-- 困难副本之飘渺仙府(client)
    [27008] = {
        map_name = "幻·大殿", -- 幻·大殿
        map_id = 27002,
        monster_level = 0,
        npc = {
			{name = "仙童", x = 35, y = 18, icon = 06302},
        },
    },

    [25008] = {
        map_name = "幻·秘境", -- 幻·大殿
        map_id = 25002,
        monster_level = 0,
        teleport_x = 31,
        teleport_y = 24,
        npc = {

        },
    },

    [25009] = {
        map_name = "幻·仙府", -- 幻·大殿
        map_id = 25000,
        monster_level = 0,
        teleport_x = 31,
        teleport_y = 24,
        npc = {
        {name = "幻境—恶仆", x = 37, y = 30, icon = 06245, alias = "恶仆"},
        {name = "幻境—引路童子", x = 27, y = 19, icon = 06069, alias = "引路童子"},
        },
    },

    [33001] = {
        map_name = "幻·烈火涧",
        map_id = 16000,
        teleport_x = 39,
        teleport_y = 44,
        npc = {

        },
        exit_level = { },
        monster_level = 35,
    },

    [33101] = {
        map_name = "幻·烈火涧西",            -- 幻·烈火涧西
        map_id = 16001,
        teleport_x = 23,
        teleport_y = 22,
        npc = {

        },
        monster_level = 0,
    },

    [33201] = {
        map_name = "幻·烈火涧北",            -- 幻·烈火涧北
        map_id = 16001,
        teleport_x = 23,
        teleport_y = 22,
        npc = {

        },
        monster_level = 0,
    },

    [33301] = {
        map_name = "幻·烈火涧东",            -- 幻·烈火涧东
        map_id = 16001,
        teleport_x = 23,
        teleport_y = 22,
        npc = {

        },
        monster_level = 0,
    },


    [38023] = {
        map_name = "宝物守卫战",
        map_id = 38000,
        teleport_x = 20,
        teleport_y = 20,
        monster_level = 0,
        npc = {
        },
    },

    [38024] = {
        map_name = "月试道楼兰城",
        map_id = 38000,
        teleport_x = 83,
        teleport_y = 46,
        monster_level = 0,
        npc = {
                {name = "月试道接引人", x = 62, y = 36, icon = 06236, alias = "试道接引人"},
                {name = "月试道战场物资员", x = 101, y = 33, icon = 6014, alias = "战场物资员"},
        },
        unmatch_team = true,
    },
    [38025] = {
        map_name = "月跨服试道战场",
        map_id = 38001,
        teleport_x = 66,
        teleport_y = 39,
        monster_level = 0,
        npc = {
            {name = "月跨服天下道尊", x = 38, y = 48, icon = 06223, alias = "天下道尊"},
            {name = "月跨服战场物资员", x = 77, y = 63, icon = 6014, alias = "战场物资员"},
        },

        unmatch_team = true,
    },



    [28203] = {
        map_name = "赵老板居所-前庭",
        map_id = 28200,
        teleport_x = 66,
        teleport_y = 39,
        monster_level = 0,
        npc = {

        },
    },

    [28204] = {
        map_name = "赵老板居所-房屋",
        map_id = 28201,
        teleport_x = 66,
        teleport_y = 39,
        monster_level = 0,
        npc = {
            {name = "管家5", x = 27, y = 40, icon = 51513, alias = "管家"},
        },
    },

    [28107] = {
        map_name = "乐善施居所-前庭",
        map_id = 28100,
        teleport_x = 66,
        teleport_y = 39,
        monster_level = 0,
        npc = {

        },
    },

    [28108] = {
        map_name = "乐善施居所-房屋",
        map_id = 28101,
        teleport_x = 66,
        teleport_y = 39,
        monster_level = 0,
        npc = {
            {name = "管家4", x = 23, y = 34, icon = 06011, alias = "管家"},
        },
    },


    [28303] = {
        map_name = "钱老板居所-前庭",
        map_id = 28300,
        teleport_x = 66,
        teleport_y = 39,
        monster_level = 0,
        npc = {

        },
    },

    [28304] = {
        map_name = "钱老板居所-房屋",
        map_id = 28301,
        teleport_x = 66,
        teleport_y = 39,
        monster_level = 0,
        npc = {
            {name = "管家6", x = 32, y = 46, icon = 51514, alias = "管家"},
        },
    },


    [37100] = {
        map_name = "通天塔顶",
        map_id = 37100,
        teleport_x = 66,
        teleport_y = 39,
        monster_level = 0,
        npc = {
            {name = "北斗神将2", x = 29, y = 10, alias = "北斗神将", armatureType = 4, magicIcon = 02039, actionName = "Bottom", isFloat = true, bottom_image_Zorder = -1},
            {name = "开阳星君2", x = 16, y = 19, alias = "开阳星君", armatureType = 4, magicIcon = 02039, actionName = "Bottom", isFloat = true, bottom_image_Zorder = -1},
            {name = "摇光星君2", x = 47, y = 10, alias = "摇光星君", armatureType = 4, magicIcon = 02039, actionName = "Bottom", isFloat = true, bottom_image_Zorder = -1},
            {name = "天枢星君2", x = 62, y = 17, alias = "天枢星君", armatureType = 4, magicIcon = 02039, actionName = "Bottom", isFloat = true, bottom_image_Zorder = -1},
            {name = "天璇星君2", x = 64, y = 29, alias = "天璇星君", armatureType = 4, magicIcon = 02039, actionName = "Bottom", isFloat = true, bottom_image_Zorder = -1},
            {name = "天玑星君2", x = 51, y = 39, alias = "天玑星君", armatureType = 4, magicIcon = 02039, actionName = "Bottom", isFloat = true, bottom_image_Zorder = -1},

            {name = "天权星君2", x = 31, y = 39, alias = "天权星君", armatureType = 4, magicIcon = 02039, actionName = "Bottom", isFloat = true, bottom_image_Zorder = -1},
            {name = "玉衡星君2", x = 16, y = 33, alias = "玉衡星君", armatureType = 4, magicIcon = 02039, actionName = "Bottom",bottom_image_Zorder = -1, isFloat = true,},

        },
    },

    [37101] = {
        map_name = "神秘房间",
        map_id = 37101,
        teleport_x = 31,
        teleport_y = 27,
        monster_level = 0,
        npc = {
            {name = "北斗星使1", x = 35, y = 24, alias = "北斗星使"},

        },
    },

}
