--region 这里只能定义常量
--不能定义其他东西，尤其是全局变量，全局变量到GWorld里定义
---@class Const
local CommonConst = {

	CONN_TYPE_NORMAL = 1,
	CONN_TYPE_REQUEST_AVATAR = 2,

	ConnectServerRequestType = {
		NEW_CONNECTION = 0,	    -- 新登录
		RE_CONNECTION = 1,	    -- 断线快速重连
		BIND_AVATAR = 2,	    -- 重新绑定entity到avatar
		DS_NEW_CONNECTION = 3,  -- DS新连接
	},

	ConnectServerReplyType = {
		BUSY = 0,	                 -- 服务端忙，请重试
		CONNECTED = 1,		         -- 初次连接成功
		RECONNECT_SUCCEEDED = 2,     -- 断线重连成功
		RECONNECT_FAILED = 3,		 -- 断线快速重练失败，需重新登录
		FORBIDDEN = 4,				 -- 服务器禁止连接
		MAX_CONNECTION = 5,			 -- Gate连接数达上限
	},

	KickAvatarType = {
		KICK_AVATAR_RELAY = 1,              -- 顶号踢角色下线
		KICK_AVATAR_FORCE_GM = 2,              -- GM强制踢角色下线
		KICK_AVATAR_NONSTOP = 3,            -- 不停服登录踢老服角色下线
		KICK_AVATAR_BAN = 4,                         -- 封号被踢下线
		KICK_AVATAR_ANTI_DULGENCE = 5,               -- 防沉迷
		KICK_AVATAR_REGISTER_REAL_NAME = 6,          -- 实名认证
		KICK_AVATAR_FORCE_PATCH = 7,        -- 强制patch踢下线
		KICK_AVATAR_LOADMETAFROMDB_FAIL = 8,        -- load meta 属性失败
		KICK_AVATAR_CHECK_SCRIPT = 9,   -- 检测到脚本
	},

	CLIENT_LOSE_DESTROY_DELAY_TIME = 300,  -- 客户端断开连接后销毁间隔时间
	DEFAULT_SAVE_TIME = 900,  -- 默认存盘时间
	ConnectTimeout = 5,
	ONLINE_MATCH_TIME = 10,  -- 联机匹配时间
	ONLINE_TEAM_VOTE_TIME = 10, -- 队伍成员接受挑战邀请的时间
	AddCollectorTime = 0.5,
	UpdateCollectorTime = 0.5,
	DeadCollectorTime = 0.5,
	FoolsDayPhotoType = {
        Large = "Large",
        Small = "Small",
        Pixel = "Pixel",
	},
	-- 增减Reason通知@xuyonghao@lijinyi@zhangjiangtao
	RewardReason = {
		MonsterDead = "MonsterDead",  -- 怪物死亡
		Chest = "Chest",  -- 宝箱
		BreakableItem = "BreakableItem",  -- 破碎物
		MonsterAnim = "MonsterAnim",  -- 怪物动画中播动画
		PickUp = "PickUp", -- 掉落物
		Repeated = "Repeated", -- 同个actor反复生成奖励
	},

	DSType = {
		Root = 0,
		Child = 1,
		Leaf = 2
	},

	DSRunningStatus = {
		Init = 0,
		Patching = 1,
		Preloading = 2,
		Running = 3,
		Destroyed = 4,
	},

	WeaponType = {
		MeleeWeapon = "Melee",
		RangedWeapon = "Ranged",
		UltraWeapon = "Ultra",
	},
	OnlineShowWeapon = {
		Melee = "Melee",
		Ranged = "Ranged",
	},
	ItemType = {
		Resource = "Resource",
		Material = "Material",
		GetThenUse = "GetThenUse",
	},

	SkillType = {
		WeaponPassive = "WeaponPassive",
	},

	DungeonNetMode = {
		Standalone = 1,
		DedicatedServer = 2,
		ListenServer = 3
	},

	H5RwardOpenDay = {2025,10,30,12,0,0},
	H5RwardCloseDay = {2025,11,28,5,0,0},

	-- 副本类型映射副本UIName
	DungeonUINameMap = {
		Survival = "DungenonSurviveFloat",
        SurvivalPro = "DungenonSurviveFloat",
		SurvivalMini = "DungenonSurviveFloat",
		SurvivalMiniPro = "DungenonSurviveFloat",
		SurvivalUltra = "DungenonSurviveFloat",
        Defence = "DungenonDefenseFloat",
		DefenceMove = "DungenonDefenseFloat",
        DefencePro = "DungenonDefenseProFloat",
        Capture = "DungeonCaptureFloat",
        Training = "Disable",
        Hijack = "DungeonHijackFloat",
        Sabotage = "DungeonSabotageFloat",
		SabotagePro = "Disable",
        Exterminate = "DungeonExterminateFloat",
		ExtermPro = "DungeonExterminateFloat",
        Excavation = "DungenonExcavation",
        Rescue = "DungeonRescueFloat",
		Temple = "DungeonTempleFloat",
		Party = "DungeonTempleFloat",
		Synthesis = "DungenonDefenseFloat", 
		Rouge = "Rouge_BattleProgress",
		Abyss = "Abyss_BattleProgress",
		Trial = "Trial_BattleProgress",
		MultiDestroy = "RegionMultiDestroyProgress",
		CoDefence = "RegionCoDefenceProgress",
		HardBossDg = "Disable",
		SoloRaid = "WidgetUI",
		MonsterRush = "WidgetUI",
		AutoChess = "Disable", -- 自走棋的UI自行加载
		SoloTreasure = "SoloTreasureCountDownTip",
		SynthesisII = "DungenonDefenseFloat",
	},

	DungeonEMWidgetUINameMap = {
		SoloRaid = "SoloRaidScore",
		MonsterRush = {
			"WuyoushengProgressHud",
			"WuyoushengTopContent",
		},
	},

	DungeonType = {
		Survival = "Survival",
		Defence = "Defence",
		Excavation = "Excavation",
		Capture = "Capture",
		Temple = "Temple",
		Training = "Training",
		Rouge = "Rouge",
		Trial = "Trial",
		Abyss = "Abyss",
		Party = "Party",
		Paotai = "Paotai",
		FeiNa = "FeinaEvent",
		MonsterRush = "MonsterRush",
		HardBossDg = "HardBossDg",
		SoloRaid = "SoloRaid",
		AutoChess = "AutoChess",
		SoloTreasure = "SoloTreasure",
	},
	SubRegionType = {
		Field = "field",
		Home = "home",
	},

	AvatarStatus = {
		Normal = 1,
		InBigWorld = 2,
		Matching = 3,
		EnterSingleDungeon = 4,
		InSingleDungeon = 5,
		EnterBigWorld = 6,
		InMultiDungeon = 7,
		InHardBoss = 8,
		EnterRougeLike = 9,
		InRougeLike = 10,
		EnterMultiDungeon = 11,
		DynamicEvent = 12,
		InExploreChanllenge = 13,
		InTeam = 14,
		InSpecialQuest = 15,
		InRegionOnline = 16,
		InTheaterPerform = 17, -- 剧院联机小游戏中
	},

	CommonStatus = {
		UnLock = 0,
		Lock = 1
	},

	AllType = {
		Char = 1,
		Weapon = 2,
		Resource = 3,
		Mod = 4,
	},


	ActorType ={
		Player = 1,
		Monster = 2,
		CombatItemBase = 3,
	},
	DataType = {
		Weapon = "Weapon",
		Char = "Char",
		Mod = "Mod",
		Resource = "Resource",
		Skin = "Skin",
		WeaponSkin = "WeaponSkin",
		Hair = "Hair",
		CharAccessory = "CharAccessory",
		WeaponAccessory = "WeaponAccessory",
		Pet = "Pet",
	},

	----- 区域数据类型
	RegionDataType = {
		[0] = "Mistake",
		[1] = "Common",
		[2] = "Quest",
		[3] = "Rarely",
		[5] = "CommonDaily",
		[6] = "CommonTriduum",
		[7] = "CommonWeekly",
		[8] = "CommonQuest"
	},

	AvatarOnlineStatus = {
		NotInOnline = 0,
		EnteringOnline = 1,
		InOnline = 2,
		LeavingOnline = 3,
	},

	FeiNaState = {
		Doing = 0,
		Complete = 1,
		GetReward = 2,
	},

	ExploreState = {
    	InActive = 0,
    	Doing = 1,
    	ChallageComplete = 2,
		SpecialActive = 3,
    	Complete = 4,
	},

	SystemGuideState = {
		UnFinished = 0,
		Finished = 1,
	},
	--商城
	ShopRefreshBeginTime = {2023,1,1,5,0,0}, -- 商城商品刷新的起点，2023-01-01 05：00
	ShopBannerPCPath = "/Game/UI/WBP/Shop/PC/Banner/",
	ShopBannerMobilePath = "/Game/UI/WBP/Shop/Mobile/Banner/",
	ShopOncePurchaseLimit = 10000000, --单次购买上限一千万

	-- 经验
	PlatinumItemId = 100, -- 白金
	ExpItemId = 101,      -- 现金
	CharExpItemId = 102,
	MeleeWeaponExpItemId = 103,
	RangedWeaponExpItemId = 104,
	PlayerExpId = 105,
	-- 货币
	Coins = {
		Coin1 = 100, -- 月石
		Coin2 = 101, -- 银币
		Coin3 = 102, -- 深红凝珠
		Coin4 = 99,  -- 付费月石
	},
	-- 体力
	PhysicalStrengthId = 103, 	-- 仅 WBP_Com_TabResourceBar_C 使用，后续删除体力功能时，此条可删

	CoinsList = {100, 101, 102, 99},
	MonthlyCard = 121, -- 月卡

	ResourceSType = {
		Fish = "Fish",
		Event = "Event",
		Coin = "Coin",
		Read = "Read",
		PhantomItem = "PhantomItem",
		BattleItem = "BattleItem",
	},

	CorrectReason = {
		3001,
		4001,
	},
	--道具使用类型
	ResUseEffectType = {
		SelectCharacter = "SelectCharacter",
		SelectWeapon = "SelectWeapon",
		SelectPet = "SelectPet",
		SelectResource = "SelectResource",
		ResourcePack = "ResourcePack", -- 普通道具使用
		SelectSkin = "SelectSkin",
		SelectGeneralSkin = "SelectGeneralSkin",
		SelectWeaponSkin = "SelectWeaponSkin",
		SelectCharAccessory = "SelectCharAccessory",
		SelectWeaponAccessory = "SelectWeaponAccessory",
		SelectGestureItem = "SelectGestureItem",
	},
	--自选道具奖励类型
	OptRewardType = {
		Char = "Char", --角色
		Weapon = "Weapon", --武器
		Pet = "Pet", --魔灵
		Resource = "Resource", --材料资源
		Skin = "Skin", --角色皮肤
		GeneralSkin = "GeneralSkin", --通用角色皮肤
		WeaponSkin = "WeaponSkin", --武器皮肤
		CharAccessory = "CharAccessory", --角色装饰
		WeaponAccessory = "WeaponAccessory", --武器装饰
	},
--region RougeLike Related
	-- 肉鸽房间类型
	RougeLikeRoomType = {
		Combat = 1,
		EliteCombat = 2,
		Event = 3,
		Rest = 4,
		Boss = 5,
	},
	-- 肉鸽刻印/宝物随机类型
	RougeLikeAwardType = {
		AutoRandomOne = 1,
		ManualRandomThree = 2,
		SpecifyOne = 3,
	},
	RougeLikeEventType = {
		DialogueAward = "DialogueAward",
		Battle = "Battle",
		Game = "Game",
	},
	RougeLikeManualType = {
		Blessing = 100002,
		Treasure = 100001,
		Event = 100003,
		StoryEvent = 100004,
	},
	RougeLikeStoryEventMoment = {
		PassRoom = 0,
		Win = 1,
		Lose = 2,
		NewStart = 3,
	},
--endregion

	--体力
	ActionPoint = 103,

	RagdollStateHitFly = 1,
	RagdollStateGrab = 2,
	RagdollStateDead = 3,
	

	ROLE_Authority = 3,
	ROLE_AutonomousProxy = 2,
	ROLE_SimulatedProxy = 1,

	--Boss血条分段上限
	BOSS_BLOOD_PART_MAX = 5,

	--抽卡相关
	GACHA_PROBABILITY_BASE = 10000, -- 抽卡概率底数
	GachaRegionId = 101101,--抽卡打开后需要卸载的区域Id
	GachaOneResult = 1, --单次结果数量
	GachaTenResults = 10, --十次结果数量
	GachaCharType = 0,--抽卡结果为角色类型
	GachaWeaponType = 1,--抽卡结果为武器类型
	GachaRarityMax = 5,--抽卡结果最大稀有度
	GachaSelectCount = 6,--自选卡池小于等于6个是，列表禁用滑动
	GachaVideoRarity5 = "/Game/Asset/UIVideo/Video_ChouKa_jin.Video_ChouKa_jin",
	GachaVideoRarity4 = "/Game/Asset/UIVideo/Video_ChouKa_zi.Video_ChouKa_zi",
	GachaVideoRarity3 = "/Game/Asset/UIVideo/Video_ChouKa_lan.Video_ChouKa_lan",
	GachaVideoRarity5_Mobile = "/Game/Asset/UIVideo/Video_ChouKa_jin_Mobile.Video_ChouKa_jin_Mobile",
	GachaVideoRarity4_Mobile = "/Game/Asset/UIVideo/Video_ChouKa_zi_Mobile.Video_ChouKa_zi_Mobile",
	GachaVideoRarity3_Mobile = "/Game/Asset/UIVideo/Video_ChouKa_lan_Mobile.Video_ChouKa_lan_Mobile",

	GachaVideoMaleRarity6_PC = "/Game/Asset/UIVideo/Gacha/Gacha_S_Movie_PC.Gacha_S_Movie_PC",
	GachaVideoMaleRarity5_PC = "/Game/Asset/UIVideo/Gacha/Gacha_S_Movie_PC.Gacha_S_Movie_PC",
	GachaVideoMaleRarity4_PC = "/Game/Asset/UIVideo/Gacha/Gacha_R_Movie_PC.Gacha_R_Movie_PC",
	GachaVideoMaleRarity3_PC = "/Game/Asset/UIVideo/Gacha/Gacha_N_Movie_PC.Gacha_N_Movie_PC",
	GachaVideoFemaleRarity6_PC = "/Game/Asset/UIVideo/Gacha/Gacha_S_Movie_PC.Gacha_S_Movie_PC",
	GachaVideoFemaleRarity5_PC = "/Game/Asset/UIVideo/Gacha/Gacha_S_Movie_PC.Gacha_S_Movie_PC",
	GachaVideoFemaleRarity4_PC = "/Game/Asset/UIVideo/Gacha/Gacha_R_Movie_PC.Gacha_R_Movie_PC",
	GachaVideoFemaleRarity3_PC = "/Game/Asset/UIVideo/Gacha/Gacha_N_Movie_PC.Gacha_N_Movie_PC",

	GachaVideoMaleRarity6_Mobile = "/Game/Asset/UIVideo/Gacha/Gacha_S_Movie_Mobile.Gacha_S_Movie_Mobile",
	GachaVideoMaleRarity5_Mobile = "/Game/Asset/UIVideo/Gacha/Gacha_S_Movie_Mobile.Gacha_S_Movie_Mobile",
	GachaVideoMaleRarity4_Mobile = "/Game/Asset/UIVideo/Gacha/Gacha_R_Movie_Mobile.Gacha_R_Movie_Mobile",
	GachaVideoMaleRarity3_Mobile = "/Game/Asset/UIVideo/Gacha/Gacha_N_Movie_Mobile.Gacha_N_Movie_Mobile",
	GachaVideoFemaleRarity6_Mobile = "/Game/Asset/UIVideo/Gacha/Gacha_S_Movie_Mobile.Gacha_S_Movie_Mobile",
	GachaVideoFemaleRarity5_Mobile = "/Game/Asset/UIVideo/Gacha/Gacha_S_Movie_Mobile.Gacha_S_Movie_Mobile",
	GachaVideoFemaleRarity4_Mobile = "/Game/Asset/UIVideo/Gacha/Gacha_R_Movie_Mobile.Gacha_R_Movie_Mobile",
	GachaVideoFemaleRarity3_Mobile = "/Game/Asset/UIVideo/Gacha/Gacha_N_Movie_Mobile.Gacha_N_Movie_Mobile",

	GuideGachaVoice = "voice/$Locale$/story/1002/100127/1910D59A", --序章抽卡语音
	GachaBackgroundAddrPC = "/Game/UI/WBP/Get/Widget/Avatar/",	--抽卡背景PC端前缀
	GachaBackgroundAddrMobile = "/Game/UI/WBP/Get/Widget/Avatar/",	--抽卡背景移动端前缀
	GachaJumpToShopMainTabId = 110,--抽卡直接跳转至商城直充界面

	--性别
	Sex = {
		Male = 0,
		Female = 1,
	},

	RaidDungeonType = {
		Pre = 1,
		Formal = 2,
	},

	DynamicQuest_Probability_Head = 1,--动态事件概率判定区间起点
	DynamicQuest_Probability_Tail = 100,--动态事件概率判定区间终点

	ChangeCharQuestChainId = 100201, --黑桃离队对应任务链id

	SignBoardUnset = -1,--看板娘未放置
	SignBoardThird = 3,--第三个看板，需站姿，一二为坐姿

	PartySaiQi = 5301,--新号默认解锁赛琪点滴

	Community = {
		JJJCN = 1,	--皎皎角国内
		JJJAboard = 4,	--皎皎角海外
	},

	BuffType = {
		Buff = 1,
		Debuff = 2,
		Weakness = 100,
	},
	AvatarBuffPermanent = -1,--服务器buff持续时间无限

	NET_PING_TIME = 5, -- Ping间隔
	NET_DELAY_TIPS_INTERVAL = 2, -- 网络延迟tips显示间隔时间
	NET_DELAY_TIMEOUT_TIME = 100, -- 网络延迟响应等待最大时间
	NET_DELAY_CHECK_INTERVAL = 4, -- 网络延迟检查间隔时间（单位：秒）
	NET_Player_UPDATE_INFO = 5, -- 在大世界里以每五秒的时间同步玩家信息


	-- 检测目标
	TargetTypeRougeLikeFinish = 9001, -- 完成肉鸽
	TargetTypeRougeLikeTalentBranch = 9002, -- 点亮指定天赋分支
	TargetTypeRougeLikeGetBlessing = 9003, -- 获得祝福
	TargetTypeRougeLikeGetTreasure = 9004, -- 获得宝物
	TargetTypeRougeLikeEnterRoom = 9005, -- 进入房间
	TargetTypeRougeLikeGetToken = 9006, -- 获得肉鸽货币
	TargetTypeRougeLikeCurrentToken = 9007, --当前肉鸽货币
	TargetTypeRougeLikeToken = 9008, --通关时肉鸽货币
	TargetTypeRougeLikeContract = 9009, -- 通关时契约热度

	TargetTypeAvatarLevel = 10001,  -- 玩家等级（和鸣等级）达到要求等级
	TargetTypeTotalLoginDays = 10002,  -- 账号累计登录天数
	TargetTypeConsecutiveLoginDays = 10003,  -- 账号连续登录天数
	TargetTypeConsumeActionPoint = 10004,  -- 消耗的体力值
	TargetTypeLoginDay = 10005,  -- 登录天数计数
	TargetTypeAccumulatedNumberOfFriendsAdded = 10801,  -- 累计添加好友人数	
	
	TargetTypeGetReource = 10101,  -- 获取特定Resource
	TargetTypeCostResource = 10102,  -- 消耗特定Resource
	TargetTypeGetResourceSTypeRarity = 10103,	--获取指定子类型和指定稀有度的Resource
	TargetTypeGetResourceForAutoUseWhenAdd = 10104,	--获取自动使用的 Resource
	TargetTypeCostResourceForBattleItem = 10105,	--累计（在战斗轮盘）使用BattleItem的次数

	TargetTypeMosterAll = 10201,  -- 击杀任意怪物
	TargetTypeMosterId = 10202,  -- 击杀特定怪物
	TargetTypeModAll = 10301,  -- 获取任意MOD
	TargetTypeModId = 10302,  -- 获取特定MOD
	TargetTypeModType = 10303,  -- 获得特定品质MOD
	TargetTypeCharModNum = 10304,  -- 任意一名角色装备的MOD数量
	TargetTypeWeaponTagModNum = 10305,  -- 某一类型武器装备MOD数量
	TargetTypeModRarityLevel = 10306,  -- 强化指定稀有度MOD至指定等级（相同ID只记1次）
	TargetTypeModCountRarityLevel= 10307,  -- 角色同时装备#1个以上#2稀有度且强化至#3级以上的MOD

	TargetTypeWeaponAll = 10401,  -- 获取任意武器
	TargetTypeWeaponLevel = 10402,  -- 达到要求等级的武器
	TargetTypeWeaponEnchance = 10403,  -- 达到要求突破等级的武器
	TargetTypeWeaponRarityModSlotPolarity = 10404,  -- 累计极化指定稀有度武器次数（填多个时表示其中任意一个都行）
	TargetTypeWeaponModSlotPolarity = 10405,  -- 累计极化指定武器次数
	TargetTypeWeaponRarityGrade = 10406,  -- 累计提升指定稀有度武器至指定同卡等级次数
	TargetTypeWeaponGrade = 10407,  -- 提升指定武器至某一同卡等级
	TargetTypeRarityWeaponHyperCardLevel = 10408, -- 提升指定稀有度灵化武器至某一灵化熔炼等级（相同UID只计1次）
	TargetTypeWeaponHyperCardLevel = 10409, -- 提升指定灵化武器至某一灵化熔炼等级（相同UID只计1次）


	TargetTypeMechanismId = 10501,  -- 打开特定机关
	TargetTypeDungeonId = 10502,  -- 通关特定关卡
	TargetTypeDungeonIdAndTime = 10503,  -- 快速通关特定关卡
	TargetTypeDungeonIdAndProgress = 10504,  -- 在特定无尽关卡中坚持完成了非常多的轮次
	TargetTypeExploreId = 10505,  -- 完成指定探索组
	TargetTypeExploreIdInTime = 10507,  -- 在特定时间内完成指定的探索组（跑酷类，从探索组激活到完成，计时功能英卓做的）
	TargetTypeDungeonIdFirst = 10509,  -- 第一次完成任意一个指定类型的关卡
	TargetTypeDungeonsCharId = 10511,  -- 限定角色通关任意关卡（包括所有副本和梦魇残声）
	TargetTypeDungeonCharId = 10512,  -- 限定角色通关限定副本（dungeon）
	TargetTypeDungeonTime = 10513, -- 累计通过任意副本次数
	TargetTypeDungeonTypeTime = 10514, -- 累计通过特定副本类型次数
	TargetTypeMultiDungeonTime = 10515, -- 累计通过联机次数
	TargetTypeDynamicEventTime = 10516, -- 累计完成动态事件次数
	TargetTypeTempleTime = 10517, -- 累计完成神庙
	TargetTypeSpecialTemple = 10518, -- 完成指定神庙
	TargetTypeCreatorIdAndStateId = 10520, -- 累计将指定Creator ID机关切换至指定状态的数量，填多个时都计数
	TargetTypeModDungeon = 10523, -- 累计通过特定MOD副本次数

	TargetTypeCharLevel = 10601,  -- 达到要求等级的角色
	TargetTypeCharEnchance = 10602, -- 达到要求突破等级的角色
	TargetTypeCharId = 10603, -- 获取特定角色
	TargetTypeCharAllModSlotPolarity = 10604, -- 累计极化所有角色次数
	TargetTypeCharIdModSlotPolarity = 10605, -- 累计极化指定角色次数
	TargetTypeCharRarityGrade = 10606, -- 达成某一命座等级的指定稀有度角色数量
	TargetTypeCharIdGrade = 10607, -- 提升指定角色的命座等级次数
	TargetTypeCharIdRarity = 10608, -- 拥有指定稀有度的角色数量
	TargetTypeCharSkillLevel = 10609, -- 累计提升某个技能达到指定等级

	TargetTypeQuestChainId = 10701,  -- 完成指定的任务链
	TargetTypeCompleteQuestId = 10702, --- 完成指定任务
	TargetTypeQuestChainType = 10703, --- 完成指定任务链类型
	TargetTypeQuestOnlyCondition = 10704, -- 任务完成指定条件ID


	TargetTypeDrawGacha = 11001, -- 累计抽卡次数

	TargetTypeTheaterPerformReward = 10803, -- 完成一次匹配小游戏（获得任意品质的奖励）
	TargetTypeTheaterPerformHighReward = 10804, -- 完成小游戏并获得最高级奖励
	TargetTypeTheaterDonateResource = 10805, -- 捐献指定资源

	TargetTypeBlueTypeCount = 10901,

	TargetTypeImpressionCheckCount = 12001,
	TargetTypeImpressionValue = 12002,
	TargetTypeCharAccessoryCount = 13001,
	TargetTypeGetCharSkin = 13002, --获得指定的角色皮肤
	TargetTypeGetWeaponSkin = 13003, --获得指定的武器皮肤
	TargetTypeAllImpressionValue = 12003,
	TargetTypeImpressionShop = 12004, 
	TargetTypeTalkTriggerComplete = 12005,

	TargetDispatchCompleteCount = 10519, 
	TargetDispatchCompleteGrade = 10521, 
	TargetPetCaptureSuccessDungeon = 10522, --Dungeon种累计捕获的数量

	TargetPetCaptureSuccessCount = 14001,  -- 累计捕获成功魔灵次数	
	TargetPetBreakCount = 14002,  -- 累计突破魔灵次数	
	TargetPetBreaknumCount = 14003,  -- 累计拥有突破至x阶的魔灵数	
	TargetGetWeapon = 14008,  -- 获得指定的武器	

	TargetTakePhotoCount = 21001, -- 拍照次数

	TargetTypePassAbyssTypeTimes = 15001, --连续x期，通关轮换/无尽大秘境至x层

	TargetTypeWikiEntryUnlockCount = 16001, --百科词条解锁数量

	TargetTypeStarterQuestPhaseFinish = 18001, -- 完成新手任务阶段
	TargetTypePartyTopicUnlockCount = 17001, --点滴话题解锁数量
	TargetTypeCompletePartyTopic = 17002, --完成指定点滴话题
	TargetTypeCompleteNpcTalkRepeat = 17003, --累计和看板娘完成主动对话次数,可重复
	TargetTypeCompleteNpcTalkNoRepeat = 17004, --累计和看板娘完成主动对话次数，不可重复
	
	TargetTypeTryPetCaptureCreatorId = 14004, -- 捕获对应的宠物ID
	TargetTypeZhiliuCompleteCount = 22003, -- 止流活动完成的委托次数

	TargetTypeWalnutType = 19001, -- 开特定类型的核桃
	TargetTypeWalnutId = 19002, -- 获得特定Id核桃

	TargetTypeChangeColor = 20001, --染色，武器/角色

	TargetTypeTempleStarsGet = 22001, -- 神庙活动获得多少颗星
	TargetTypeWYSStarsGet = 22002, -- 无由生活动获得多少颗星

	TargetTypeCommonQuestFinish = 22004, -- 完成东国探索活动中对应的任务
	TargetTypeCollectFeiNaCount = 22005, -- 菲娜活动收集的羽毛数量
	TargetTypeMidTermScoreGet = 22006, -- 中期目标活动获得多少积分

	TargetTypeAutoChessRankLevel = 22013, -- 自走棋段位
	TargetTypeAutoChessPassRandomMission = 22014, -- 自走棋通关随机关卡次数
	TargetTypeAutoChessCostSum = 22015, -- 自走棋累计消耗部署费用
	TargetTypeAutoChessPerCostLess = 22016, -- 自走棋单局费用不大于
	TargetTypeAutoChessPerCostMore = 22017, -- 自走棋单局费用不小于
	TargetTypeAutoChessUnlockEquip = 22018, -- 自走棋解锁装备
	TargetTypeAutoChessUnlockCard = 22019, -- 自走棋解锁卡片

	TargetTypeOnlineDruation = 10802, -- 区域联机累计在线时长

	TargetTypePassHardBoss = 23001, -- 通关指定难度boss

	TargetTypeFoolsDayTransformUnlockCount = 22007,	--愚人节活动--解锁变身数量	
	TargetTypeFoolsDayUseTransformCount = 22008,	--愚人节活动--连续XX天使用变身道具	
	TargetTypeFoolsDayUploadPhotoCount = 22009,	--愚人节活动--上传照片次数	
	TargetTypeFoolsDayLikeCount = 22010,	--愚人节活动--连续XX天点赞他人照片	
	TargetTypeFoolsDayMiniGameCount = 22011,	--愚人节活动--进行小游戏次数	
	TargetTypeFoolsDayCompleteMiniGameCount = 22012,	--愚人节活动--成功完成小游戏次数

	MaxGradeLevel = 6,  ----- 角色最大阶级
	MailMaxDueTime = 9999, --邮件无期限时 剩余天数
	GMMailTimeLimit = 30, --GM平台邮件默认30天有效期
	MailTabMaxRedNums = 99, --邮件最大红点数量

	DoubleModDropEventID = 103009001, --双倍mod活动id

	AbyssEventId=103002, --大秘境活动id
	FeinaEventId=103010, --菲娜活动id
	TheaterEventId=103011, --剧场活动id
	ZhiliuEventId=103005, --止流活动id
	RaidEventId=111001,--单人工会战活动Id
	AutoChessEventId=103016, --自走棋活动id
	SoloTreasureEventId=103014, --搜打撤活动id

	TargetCheckAll = {
		9001,
		9002,
		9003,
		9004,
		9005,
		10103,
		10105,
		10305,
		10307,
		10501,
		10512,
		10606,
		11001,
		10513,
		10514,
		10515,
		10516,
		10517,
		10518,
		10901,
		13001,
		12003,
		10519,
		10520,
		14003,
		18001,
		19001,
		19002,
		23001,
		22005,
		10704,
		10802,
		22013,
	},
	TargetCheckFirst = {
		10001,
		10002,
		10003,
		10101,
		10102,
		10104,
		10202,
		10302,
		10303,
		10304,
		10402,
		10403,
		10404,
		10405,
		10502,
		10505,
		10509,
		10511,
		10601,
		10602,
		10603,
		10605,
		10607,
		10608,
		10609,
		10701,
		10702,
		10703,
		12001,
		12005,
		10521,
		14004,
		20001,
		22004,
		12004,
		10805,
		17002,
		17003,
		17004,
		13002,
		13003,
		14008
	},

	TargetCheckFisrtAndLess = {
		10503,
		10507,
	},

	TargetCheckFisrtAndMore = {
		9009,
		10306,
		10406,
		10407,
		10504,
		22002,
		10408,
		10409,
	},

	TargetCheckLastAndMore = {
		12002,
		15001,
		22001,
	},

	TargetCheckLess = {
		22016,
	},

	TargetCheckMore = {
		22017,
	},

	SystemLanguages = {
		Default = "TextMapContent", -- 默认
		CN = "TextMapContent", -- 中文
		EN = "ContentEN", -- 英语
		JP = "ContentJP", -- 日语
		KR = "ContentKR", -- 韩语
		TC = "ContentTC", -- 繁体中文
		DE = "ContentDE", -- 德语
		FR = "ContentFR", -- 法语
		ES = "ContentES", -- 西语
	},
	SystemLanguage = "TextMapContent",
	SystemVoices = {
		Default = 'CN',
		CN = 'CN',
		EN = 'EN',
		JP = 'JP',
		KR = 'KR',
	},
	SystemVoice = 'CN',
	ASC = 1,  --升序
	DESC = 2, --降序
	ArmoryVoice = nil,	--军械库语音


	--  时间相关常量
	SECOND_IN_MINUTE = 60,
	SECOND_IN_HOUR = 3600,
	SECOND_IN_DAY = 86400,
	SECOND_IN_WEEKDAY = 604800,
	MINUTE_IN_HOUR = 60,
	GAME_REFRESH_HMS = {5,0,0}, --天数计算以早上5：00开始
	SALOG_TIME = 8, --埋点间隔时间为8小时

	DungeonExitRule = {
		OVERLAP_EXIT = 1,
		ALL_EXIT = 2,
	},

	-- 属性计算乘区
	RateIndex = {
		Default = 1,  -- 默认乘区
		GlobalATK = 2,   -- 总攻击力乘区
		ExcelWeapon = 3,   -- 得意武器单独乘区
	},
	SuitType = {
		--- GameMode 配置
		GameModeSuit = "GameModeSuit",
		PlayerCharacterSuit = "PlayerCharacterSuit",
		---- 角色玩家配置
	},
	GameModeSuit = {
		DropRule = "DropRule",
	},
	
	PlayerCharacterSuit = {
		DisableSkill = "DisableSkill",
		SwitchRole = "SwitchRole",
		SwitchStoryMode = "SwitchStoryMode",
		HideUIInScreen = "HideUIInScreen",
		MonsterFirstSeenGuide = "MonsterFirstSeenGuide",
		BGM = "BGM",
		ContinuedGuide = "ContinuedGuide",
		NpcHideShowTag = "NpcHideShowTag",
		BGMParams =  "BGMParams",
		NpcExpression = "NpcExpression",
	},
	ImpressionType = { ------ 印象系统
		Benefit = "Benefit",
		Morality = "Morality",
		Wisdom = "Wisdom",
		Empathy = "Empathy",
		Chaos = "Chaos",
	},
	ImpressionState = {
		Failer = 0,
		Success = 1,
		Complete = 2,
	},
	ResourceUseEffectDrop = {
		AddHPValue = 1001,
		AddSPValue = 1002,
		AddAmmo = 1003,
	},
	EnterRegionType = {
		GM = "GM",
		Recover = "Recover",
		SelectMap = "SelectMap",
		Deliver = "Deliver",
		FirstRegion = "FirstRegion",
		Sojourns = "Sojourns",
	},

	-- 掉落物飞出的声音
	DropProjectileSe = {
		[0] = "event:/ui/common/dropItem_normal_open",
		[1] = "event:/ui/common/dropItem_purple_open",
		[2] = "event:/ui/common/dropItem_gold_open",
	},

	-- 掉落物落地的声音
	DropIdleSe = {
		[0] = "event:/ui/common/dropItem_normal_drop",
		[1] = "event:/ui/common/dropItem_purple_drop",
		[2] = "event:/ui/common/dropItem_gold_drop",
	},

	-- 掉落物飞向角色的声音
	DropFlyingSe = {
		[0] = "event:/ui/common/dropItem_whoosh",
		[1] = "event:/ui/common/dropItem_whoosh",
		[2] = "event:/ui/common/dropItem_whoosh",
	},

	-- 掉落物被拾取的声音
	DropPickupSe = {
		[0] = "event:/ui/common/dropItem_normal_pick",
		[1] = "event:/ui/common/dropItem_purple_pick",
		[2] = "event:/ui/common/dropItem_gold_pick",
	},

	-- 必须同步加载的声音路径
	CannotAsyncEventPath = {
		[0] = "event:/cine",
		[1] = "event:/sfx/common/story",
	},

	NoNeedCacheEventPath = {
		[0] = "event:/bgm",
		[1] = "event:/cine",
		[2] = "event:/voice/ch/inv",
		[3] = "event:/voice/ch/story",
		[4] = "event:/voice/en/inv",
		[5] = "event:/voice/en/story",
		[6] = "event:/voice/jp/inv",
		[7] = "event:/voice/jp/story",
		[8] = "event:/voice/kr/inv",
		[9] = "event:/voice/kr/story",
		[10] = "event:/sfx/common/story",
	},

	AddRegionDataType = {
		Normal = "Normal",
		Static = "Static",
		Random = "Random",
	},

	ArmoryType = {
		Char = "Char" ,
		Skill = "Skill",
		Weapon = "Weapon",
		Trace = "Trace",
		Grade = "Grade",
		Mod = "Mod",
		Pet = "Pet",
		Mount = "Mount",
	},
	ArmoryTag = {
		Char = "Char",
		Skill = "Skill",
		Melee = "Melee",
		Ranged = "Ranged",
		Trace = "Trace",
		Grade = "Grade",
		Condemn = "Condemn",
		Prominent = "Prominent",
		UWeapon = "UWeapon",
		Appearance = "Appearance",
		Files = "Files",
		Pet = "Pet",
		Color = "Color"
	},

	EPreviewSceneType = {
		PreviewArmory = 1,
		PersonInfo = 2,
		BattlePass = 3,
		PreviewCommon = 4,
		PreviewMVP = 5,
		PreviewSoloTreasure = 6,
	},

	PreviewScenePaths = {
		"/Game/UI/LevelMap/Armory_BGSkySphere.Armory_BGSkySphere",
		"/Game/UI/LevelMap/Map_Preview.Map_Preview'",
		"/Game/UI/LevelMap/Map_BattleOrder.Map_BattleOrder",
		'/Game/UI/LevelMap/UI_Background_Art.UI_Background_Art',
		"/Game/UI/LevelMap/MVPShow_BGSkySphere.MVPShow_BGSkySphere",
		"/Game/UI/LevelMap/Map_Huaxu_Haojing_Poi.Map_Huaxu_Haojing_Poi",
	},

	--@note 无极性的默认值
	NonePolarity = -1,
	ModSlotUnequipped = "", --mod槽未装配

	--配饰类型
	CharAccessoryTypes = {
        Back = "Back",
		Head = "Head",
		Waist = "Waist",
		Face = "Face",
		Fx = "Fx",
		FX_Body = "FX_Body",
		FX_Footprint = "FX_Footprint",
		FX_Teleport = "FX_Teleport",
		FX_Dead = "FX_Dead",
		FX_PlungingATK = "FX_PlungingATK",
		FX_HelixLeap = "FX_HelixLeap",
		Hat = "Hat",
		MVP = "MVP",
		Tail = "Tail",
    },

	NewCharAccessoryTypes = {
		Back = 1,
		Head = 2,
		Waist = 3,
		Face = 4,
		Fx = 5,
		FX_Footprint = 6,
		FX_Body = 7,
		FX_Teleport = 8,
		FX_Dead = 9,
		FX_PlungingATK = 10,
		FX_HelixLeap = 11,
		Hat = 12,
		Tail = 13,
		MVP = 14,
	},
	WeaponAccessoryTypes = {
		Accessory = "Accessory",
		RunAttack = "RunAttack",
		HeavyAttack =  "HeavyAttack",
		FallAttack = "FallAttack",
		SlideAttack = "SlideAttack",
	},
	WeaponAccessoryTypeIndex = {
		Accessory = 1,
		RunAttack = 2,
		HeavyAttack = 3,
		FallAttack = 4,
		SlideAttack = 5,
	},
	MountAccessoryType = {
		Head = "Head",
		Waist = "Waist",
	},
	MountAccessoryTypeIndex = {
		Head = 1,
		Waist = 2,
	},

	ActionAccessoryTypes = {
		FX_Dead = "FX_Dead",
		FX_Teleport = "FX_Teleport",
		FX_PlungingATK = "FX_PlungingATK",
		FX_HelixLeap = "FX_HelixLeap",
		MVP = "MVP",
	},

	RobberMonsterDungeonType = {
		Sabotage = "Sabotage",
		Excavation = "Excavation",
		Survival = "Survival",
		Capture = "Capture",
	},
	RobberMonsterId = 9500001,

	--设置系统相关
	OverallPerformanceCustom = -1,--整体性能用户自定义时
	OverallPerformanceHigh = 3,--  >=3时为高配
	AntiAliasingClose = 0,--抗锯齿为关闭时的值
	FullscreenMode = 0,
	WindowMode = 2,
	ScreenScale = 9,
	DefaultScreenScale = 16,
	DefaultWindowResolution = {
		X = 1600,
		Y = 900,
	},
	ResolutionTable={
		[1] = {
		{2048, 1536},
		{1920, 1440},
		{1600, 1200},
		{1440, 1080},
		{1280, 960},
		{1152, 864},
		{1024, 768},
		{800, 600}
		},
		[2] = {
		{3840, 2160},
		{2560, 1440},
		{1920, 1080},
		{1600, 900},
		{1366, 768},
		{1280, 720}
		},
		[3] = {
		{3440, 1440},
		{2560, 1080},
		{1792, 768}
		},
		[4] = {
		{3680, 1440},
		{1840, 720}
		}
		},
	
	SpecialHideNoWhere = 0,--国内海外都显示/登陆界面游戏内都显示
	SpecialHideAboard = 1,--海外不显示/游戏内不显示
	SpecialHideCN = 2,--国内不显示/登陆界面不显示
	SpecialHideAnyWhere = 99,--国内海外都不显示
	MaxFPS = 9999,--帧率无上限时

	DefaultMobileHudPlan = 2,--默认的移动端布局方案

	--看板娘相关
	SensorHeight = 20.25, --镜头胶片背板感应器高度
	FocusMethod = 0, --镜头聚焦方法， 0 = 不重载
	UnsetState = -1 , --看板娘未摆放状态

	PartySaiQi = 5301,--邀约赛琪Id

	--图鉴类型
	ArchiveType = {
		Char = "Char",
		Weapon = "Weapon",
		Resource = "Resource",
		Monster = "Monster",
	},
	ArchiveType2ArchiveId = {
		Char = 1001,
		MeleeWeapon = 1002,
		RangedWeapon = 1003,
		NormalResource = 1004,
		ReadResource = 1005,
		Monster = 1006,
	},
	ItemArchiveTypeList = {1,2},--普通资源图鉴包含的分类id

	-- 图鉴信息：武器类参数
	ArchiveInfo_Weapon = {
		MaxEnhanceLevel = 1, --历史最高突破等级
		MaxGradeLevel = 2, --历史最高熔炼等级
	},

	FishSizeScale = 10,--钓鱼尺寸放大系数
	FishSystemNoParam = -1,--钓鱼系统无鱼饵，无小鱼，无尺寸信息时，用-1
	RareFishLevel = 4,--稀有鱼定义：稀有度在4及以上的鱼。
	FishingLureEffect = {
		Hook = "AccelerateHook", 		--增加上钩速度
		Variant = "AddVariationProb",	--增加变异概率
		Weight = "AddRareFishProb",	 	--增加稀有鱼权重
	},

	--系统入口
	ArmoryEnterId = 1, --军械库下标
	CommonSetId = 26,--通用设置下标

	GachaEnterId = 5,--抽卡下标

	AbyssTeamNoChar = "",	--大秘境出战角色/Uuid为空
	AbyssTeamNoPet = -1,	--大秘境出战宠物/UnitId为空
	AbyssTeamDataType = {
		"Char","MeleeWeapon","RangedWeapon","Phantom1","PhantomWeapon1","Phantom2","PhantomWeapon2","Pet"
	},

	DefaultNoHeadFrame = -1,--默认无头像框
	CharSkillTreeCount = 3,--角色技能树的数量已经节点数

	FilterRewardRarity = 3, -- 过滤奖励

	-- 副本通关模式
	DungeonWinMode = {
		Endless = 1,
		Single = 2,
		Disable = 3,
	},

	-- 副本未扣除道具枚举
	DungeonUnCostItems = {
		ActionPoint = 1,
		Ticket = 2,
		Walnut = 3,
		DoubleDrop = 4, -- 双倍掉落次数
		EliteRush = 5, -- 连战次数
	},

--region 副本核桃相关
	WalnutUser = {
		Depute = "Depute",
        Dungeon = "Dungeon",
		Settlement = "Settlement",
	},

	ClientStatus = {
		None = 0,
		InRegion = 1,
		InDungeon = 2,
	},

	SyncReason = {
		Normal = "Normal",
		InElevator = "InElevator",
		DSOnline = "DSOnline",
	},

	DailyTaskState = {
		Doing = 1,
		Complete = 2,
		GetReward = 3,
	},

	DynamicQuestState = {
		inactive = 0,
		active = 1,
		doing = 2,
		success = 3,
		fail = 4,
		dispatch = 5,
	},
	DispatchState = {
		Unlock = 0,
		CanDispatch = 1,
 		Doing = 2,
		Perfect = 3,
		Success = 4,
		Qualified  = 5,
		Disqualified = 6,
		Failer = 7,
		Cooling = 8,
	},

	ExeModeType = {
		GM = "GM",
		Normal = "Normal",
	},

	DispatchRewardIndex = {
		Perfect = 0,
		Success = 1,
		Qualified = 2,
		Disqualified = 3
	},

	DispatchEffect = {
		Workaholic = "Workaholic",
		Rigorous  = "Rigorous",
		Skilled = "Skilled",
		Lucky = "Lucky",
	},

	DraftState = {
		ToBeProduced = 0,
		Doing = 1,
		Complete = 2,
	},

	SkinType = {
		Char = 0,
		Weapon = 1,
		Mount = 2,
		Hair = 3,
	},

	QuestState = {
		Start = 1,
		Success = 2,
		Failer = 3,
	},

	QuestCompleteType = {
		Normal = "Normal",
		GM = "GM",
		TargetTrigger = "TargetTrigger",
	},

	SpecialQuestState = {
		NoneStart = 0,
		Doing = 1,
		Success = 2,
		Failer = 3,
	},

	QuestChainState = {
		lock = 0,
		unlock = 1,
		doing = 2,
		finish = 3,
		preQuest = 4,
	},

	RecurringTaskState = {
		NotAccept = 0,          -- 未接受
		Doing = 1,              -- 进行中
		AlreadyClaimed = 2,     -- 已领取
		CanClaim = 3,           -- 可领取
	},

	EntrustFameTaskState = {
		ReadyClaim = 0,         -- 未领取(是否满足条件由CanSubmit判断)
		AlreadyClaimed = 2,     -- 已领取
	},

	FameRewardState = {
		NotClaimable = 0,			-- 不可领取（条件未满足）
		ReadyClaim = 1,				-- 可领取（满足条件，等待领取）
		AlreadyClaimed = 2			-- 已领取（已完成领取）
	},

	-- 区域声望状态
	RegionFameState = {
		Normal = 0,						-- 可正常接取/领取/提交任务
		MaxLevel = 1,					-- 已满级 显示遮罩 并显示已满级提示
		WeeklyFameLimit = 2,			-- 周声望经验已满 显示遮罩 并显示已满提示
		DoingOtherRegionFameTask = 3,	-- 正在进行其他区域的声望任务 显示遮罩 并显示正在进行其他区域任务提示
	},

	-- 社交聊天的消息类型
	MESSAGE_TYPE_SELF = 0, --客户端使用，本机发出的消息
	MESSAGE_TYPE_WORLD = 1,
	MESSAGE_TYPE_SYSTEM = 2,
	MESSAGE_TYPE_PRIVATE = 3,
	MESSAGE_TYPE_LEAGUE = 4,
	MESSAGE_TYPE_TEAM = 5,

	-- 好友私聊 聊天记录
	MAX_MESSAGE_COUNT = 50,
	-- 聊天频道类型
	ChatChannel = {
		Name = 0,--姓名检测上报频道
		TeamUp = 1,
		Help = 2,
		--League = 3,
		InTeam = 3,
		Friend = 4,
		RegionOnline = 5,
		SettlementOnline = 6,
		Signature = 7,--签名检测上报频道
	},
	-- 聊天频道初始化总数
	INIT_WORLD_CHANNEL_COUNT = 1,
	-- 聊天频道类型总数
	-- MAX_WORLD_CHANNEL_TYPE = 4,
	-- 聊天频道容纳人数
	MAX_WORLD_CHANNEL_MEMBER = 200,

	INIT_WORLD_CHANNEL_NUM = 50, ---初始化频道
	MAX_WORLD_CHANNEL_NUM = 99,	 ---频道最大上限

	MAX_WORLD_HISTORY_CHANNEL = 5, ---历史频道记录
	-- 世界聊天间隔
	CHAT_INTERVAL = 0.5,
	-- 快捷消息数量限制
	MAX_QUICK_MESSAGE_COUNT = 8,
	-- 表情包数量限制
	MAX_EMOTION_COUNT = 10,
	-- 举报类型
	ReportType = {
		"UI_COMMONPOP_TEXT_100090_3",
		"UI_COMMONPOP_TEXT_100090_4",
		"UI_COMMONPOP_TEXT_100090_5",
		"UI_COMMONPOP_TEXT_100090_6",
		"UI_COMMONPOP_TEXT_100090_7",
		"UI_COMMONPOP_TEXT_100090_8",
		"UI_COMMONPOP_TEXT_100090_9",
		"UI_COMMONPOP_TEXT_100090_10",
		"UI_COMMONPOP_TEXT_100090_12",
		"UI_COMMONPOP_TEXT_100090_13",
	},
	-- avatar info
	AvatarInfoProps = {
		"Account",
		"Eid",
		"Uid",
		"Nickname", -- 当前昵称
		"Hostnum",
		"Level",
		"HeadIconId", -- 当前HeadIconId头像图标id
		"LastLogoutTime",
		"LastLoginTime",
		"Signature", -- 当前签名
		"CurrentRegionId", --- 当前区域ID
		"ChannelId",
		"IsOnline",  -- avatar 存档属性里没有
		"HeadFrameId", -- 当前HeadFrameId头像框id
		"TitleBefore", -- 当前称号前缀
		"TitleAfter", -- 当前称号后缀
		"TitleFrame", -- 当前称号框
		-- 15
	},
	RMN2GiftQuota = 10, -- 人民币增长礼物配额
	GIFT_MAIL_CONTENT_MAX_LEN = 500, -- 礼物邮件内容最大长度
	GiftMinFriendDuration = 14 * 86400, -- 赠送礼物最小好友天数 14天
	FriendShortInfoProps = {
		"Account",
		"Eid",
		"Uid",
		"Nickname",
		"Hostnum",
		"Level",
		"HeadIconId",
		"LastLogoutTime",
		"LastLoginTime",
		"Signature",
		"CurrentRegionId",
		"Friends",
		"Blacklist",
		"ChannelId",  -- 12
	},

	FriendDetailInfoProps = {
		"Account",
		"Eid",
		"Uid",
		"Nickname",
		"Hostnum",
		"Level",
		"HeadIconId",
		"LastLogoutTime",
		"LastLoginTime",
		"Signature",
		"CurrentRegionId",
		"ChannelId",
		"Friends",
		"Blacklist",  -- 14
	},

	ImpressionCheckType = {
		Normal = 0,
		Success = 1,
		Failed = 2,
	},

	GMRegionTargetType = {
		AllData = 1,	-- 请求指定区域的所有数据
		AllQuestData = 2,	-- 请求当前所有任务数据
	},

	QuestChainType = {
		Main = 1,
		Daily = 2,
		Branch = 3,
		ActiveBranch = 5,
		MainActive = 6,
	},
	QuestTypeName = {
		[1] = "UI_QUEST_SUBTAB_NAME_MAIN",
		[3] = "UI_QUEST_SUBTAB_NAME_SIDE",
		[4] = "UI_QUEST_SUBTAB_NAME_SpecialSlide",
		[5] = "UI_QUEST_SUBTAB_NAME_LimitedtimeActivity",
		[6] = "UI_QUEST_SUBTAB_NAME_Activity",
	},

	--体力变化原因
	ActionPointReason = {
		Auto  = "auto",  -- 自动回复
		Purchase  = "purchase",  -- 购买
		Item  = "item",  -- 使用道具
		Dungeon = "dungeon",  -- 副本
	},

	TeamOrientation = {
		Public = 1,
		OnlyFriend = 2,
		RefuseAll = 3
	},

	LeaveTeamReason = {
		OffLine = 1,
		Willing = 2,
		Kick = 3,
	},

	NpcPetState = {
		None = 0,					-- "未激活"
		Active = 1,					-- "已激活（默认状态，场景中显现，可以进行交互）"
		InteractiveSuccess = 2,		-- "已交互-成功"
		InteractiveFail = 3			-- "已交互-失败"
	},

	--埋点数据类型
	SagLogType = {
		Track = "track",
		Monitor = "monitor",
		Set = "user_set",
		SetOnce = "user_setOnce",
		Add = "user_add",
		Unset = "user_unset",
		Append = "user_append",
		UniqAppend = "user_uniqAppend",
		Del = "user_del",
	},
	--埋点 用户数据类型
	SagLogUserType = {
		Account = 1, --账号
		Char = 2, --角色
		AccountAndChar = 3, --账号 + 角色
		Device = 4, --设备
		AccountAndDevice = 5,  --账号 + 设备
		CharAndDevice = 6, -- 角色 + 设备
		AccountCharAndDevice = 7, --账号 + 角色 + 设备
	},
	WarningLogLength = 12000,--log长度告警

	SaLogClickTrack = {
		"user_login",
		"create_role",
		"role_login",
		"role_logout",
		"charge_info"
	}, --需要上报click_id的track事件,以及

	SaLogCloudAppMsgTrack = {
		"user_login",
		"create_role",
		"role_login",
		"role_logout",
		"charge_info",
		"role_online_time",
	}, --需要上报cloud_app_msg的track事件

	SaLogTrackProperties = {
		"#channel_id",
		"#app_channel_id",
		"#img_channel_id" ,
		"#oaid",
		"#gaid",
		"#ads_json",
		"#sdk_version",
		"#os",
		"#user_agent",
		"#device_key",
		"#android_id",
		"#idfa",
		"#idfv",
		"#app_version",
		"#system_version",
		"#manufacturer",
		"#bundle_id",
		"#session_id",
		"#device_model",
		"#app_version_code",
		"#brand",
	},--需要放内层的字段，仅track事件

	SaLogUserProperties = {
		"#user_ip",
		"#click_id",
		"#img_channel_id",
		"#channel_id",
		"#app_channel_id",
		"#oaid",
		"#gaid",
		"#ads_json",
		"#sdk_version",
		"#os",
		"#user_agent",
		"#device_key",
		"#wegame_distribute_id",
		"#android_id",
		"#idfa",
		"#idfv",
		"#app_version",
		"#system_version",
		"#manufacturer",
		"#bundle_id",
		"#session_id",
		"#device_model",
		"#app_version_code",
		"#brand",
		"#cloud_app_msg",
	},--用户属性事件需要过滤的字段

	SaLogTrackNeedWeGame = {
		"user_login",
		"role_login",
		"role_logout",
		"create_role",
		"charge_info",
		"charge_deliver",
	},--需要埋wegame标识的Track事件
	SaLogReportOnlineTime = 2 , --每隔2h上报一次
	
	PetAutoLockBreakNum = 3, --魔灵自动锁定突破次数
	PetAutoLockRarity = 5, --魔灵自动锁定稀有度
	PetEntryAutoLockRarity = 5, --魔灵词条自动锁定稀有度

	ResourceType = {
		Mod = "Mod",
		Weapon = "Weapon",
		Resource = "Resource",
		Char = "Char",
	},

	BagResourceType = {
		Weapon = 1,
		Mod = 2,
		Resource = 3,
		QuestResource = 4,
		ReadResource = 5,
	},

	BattlePassTaskType = {
		Daily = "Daily",
		Weekly = "Weekly",
		Version = "Version",
	},
	PetNameLenghtLimit = 14,
	PetType = {
		Normal = 1,
		Consumable = 2,
	},
	DynamicQuestPetToBeCapturedMaxCount = 100,
	LauncherSwitchConf = {
		[1] = "拦截公告开关",
	},
	BattlePassPayType = {
		RANK2 = 1,
		RANK3 = 2,
		RANK2_UPGRADE_RANK3 = 3,
	},
	QueryPayRetType = {
		Normal = 0,
		First = 1,
		Limit = 2,
	},--0 正常 1首充 2 限制购买(不展示)
	WhitelistType = {
		Internal = "内部白名单",
		Player = "玩家白名单",
	},
	--操作系统
	CHANNEL_OS = {
		IOS = "ios",
		ANDROID = "android",
		WINDOWS = "windows",
	},

	--设备类型
	DEVICE_TYPE = {
		MOBILE = "mobile",
		PC = "pc",
	},

	--设备类型(客户端使用)
	CLIENT_DEVICE_TYPE = {
		MOBILE = "Mobile",
		PC = "PC",
		OTHER = "Other"
	},

	--渠道商
	CHANNEL_PROVIDER = {
		OFFICAL = "hero",
		BILI = "bilibili",
	},

	IMG_CHANNEL_PROVIDER = {
		TapTap = "TapTap",
		HaoYouKuaiBao = "HaoYouKuaiBao",
		Lenovo = "Lenovo",
	},

	CHANNEL_REGION = {
		CHINA = "china",
		GLOBAL = "global",
	},
	CDKType = {
		Reusable = "Reusable",
		NonReusable = "NonReusable",
	},

	-- --SDK渠道枚举ID
	-- SDKChannelId = {
	-- 	China = 0,
	-- 	Global = 1,
	-- 	Steam = 2,
	-- 	Bilibili = 3,
	-- 	None = -1
	-- },
	CrashSightNum = {
		[101] = {
			PC = 1,
			MB = 1
		},
		[102] = {
			PC = 1,
			MB = 1
		},
	},

	-- 月卡
	MonthlyCardValidDay = 30, -- 月卡有效期
	DayTime = 86400, -- 一天的秒数

	OnlineClientMessageType = {
		Move = true,
		Action = true,
		StopAction = true,
		Hide = true,
		SwitchShowWeapon = true,
		SwitchOnlineState = true,
		UseGouSuo = true,
	},

	OnlineClientItemMessageType = {
		OnDeadRegionOnlineItem = "OnDeadRegionOnlineItem",
		OnChangeRegionOnlineItemState = "OnChangeRegionOnlineItemState",
		OnLeaveRegionOnlineItem = "OnLeaveRegionOnlineItem",
		OnUseRegionOnlineItem = "OnUseRegionOnlineItem",
		OnDeadRegionOnlineMount = "OnDeadRegionOnlineMount",
		OnUseCreateMount = "OnUseCreateMount",
		OnChangeRegionOnlineMount = "OnChangeRegionOnlineMount",
	},

	OnlineState = {
		Normal = 1,
		UseWheel = 2,
		UseDelivery = 3,
		UseFish = 4,
	},
	HandleOnlineStateFunc = {
		[1] = "HandleOnlineStateNormal",
		[2] = "HandleOnlineStateUseWheel",
		[3] = "HandleOnlineStateDelivery",
		[4] = "HandleOnlineStateFish",
	},

	OnlineItemType = {
		["GouSuo"] = "GouSuo",
	},

	-- 中期目标建立活动任务类型
	MidTermTaskType = {
		DailyHigh = 1, -- 高分值每日任务
		DailyLow = 2, -- 低分值每日任务
		Cycle = 3, -- 循环任务
		Achv = 4, -- 成就任务
	},

	RewardRateType = {
		Bonus = "Bonus",
		Exp = "Exp",
	},

	PersonalInfoVisibleType = {
		All = 1, -- 全部可见
		FriendOnly = 2, -- 仅好友可见
		Self = 3, -- 仅自己可见
	},

	DeliveryAnchorMechanismUnitId = 90100,

	AutoChess = {
		-- 自走棋棋盘格的不同状态，用于调用对应状态函数
		CubeState = {
			CanPutin = "CanPutin",
			CanChange = "CanChange",
			Hover = "Hover",
			UnHover = "UnHover",
			Forbid = "Forbid",
			InitEffect = "InitEffect",
			Xuanzhong = "Xuanzhong",
			BanEnemy = "BanEnemy",
		},
		-- 自走棋布阵的不同状态
		DeployState = {
			Place = 1,
			Move = 2,
		},
		InputMode = "WBP_AutoChessBattlePage_Deploying",
		GamepadFocusState = {
			Focus1 = 1,
			Focus2 = 2,
			Focus3 = 3,
		},
		BoardWidth = 6,
		BoardHeight = 4,
		MaxChessNum = 24,
		-- 自走棋手柄移动最小间隔时间
		GamepadMoveMinDeltaTime = 0.3,
		-- 自走棋手柄移动摇杆阈值
		JoystickThreshold = 0.5,
	}
}

CommonConst.IndependentModMultiplier = {
	"Normal"
}


CommonConst.CONFIG = {
	expire_time = 3 * 3600,       -- 3小时过期时间（秒）
    check_interval = 600,         -- 清理检查间隔（秒）
    hash_algorithm = "sha1",      -- 支持 md5/sha1/sha256
    max_log_size = 1024,          -- 最大日志长度（超出会截断）
    collision_check = false,      -- 是否开启哈希碰撞检测
	max_data_length = 10000,      -- 最大日志长度
}

CommonConst.SVONKeepDataWorld = {
	[0] = "Chapter01_Won",
	[1] = "Ailixian_Paotai01",
	[2] = "Huaxu_Haojing_Reb",
}

CommonConst.CheckTimeAccelerationInterval = 30 -- 30s检测一次
CommonConst.TimeAccelerationWarningInterval = 300 -- 300s警告一次


CommonConst.WeaponTypes = {
    Ultra = 1,
    Polearm = 1,
    Claymore = 1,
    Broadsword = 1,
    Katana = 1,
    Crossbow = 1,
    Funnel = 1,
    Cannon = 1,
    Sword = 1,
    Dualblade = 1,
    Swordwhip = 1,
    Scythe = 1,
    Machinegun = 1,
	Bow = 1, 
	Pistol = 1, 
    Shotgun = 1
}

CommonConst.RougeLikeEventType2ManualType = {
	[1] = CommonConst.RougeLikeManualType.Event,
	[2] = CommonConst.RougeLikeManualType.StoryEvent,
}

CommonConst.SERVER_AREA_TO_TIMEZONE = {
	China = 8,
	HMT = 8,
	Asian = 8,
	America = -5,
	Europe = 1,
	SEA = 8,
}


-- 非限定支付金额转月石比率
CommonConst.UnrestrictedPayMoney2CoinNum = {
	["TWD"] = 1.818,
	["USD"] = 59.46181704
}

-- 武器熔炼道具
CommonConst.WeaponCardLevelResourceId = 1006

-- 神庙关卡通关所需星数
CommonConst.TemplePassNeedStar = 1
-- 无由生关卡通关所需星数
CommonConst.WysPassNeedStar = 1

CommonConst.RegionMapTrackingType = {
	TeleportPoint = 1,
	RegionPoint = 2,
	MarkPoint = 3,
	MiniDispatchPoint = 4,
	SpecialSideQuest = 5,
	SoloTreasure = 6,
}

-- 网页跳转状态
CommonConst.WebJumpState = {
	Zero = 0,
	Jumped = 1,
	Rewarded = 2,
}

CommonConst.MonitorCheatType = {
	Damage = 1, -- 伤害
	Time = 2, -- 通关时间
	AdvResGet = 3, -- 超前获取
	OverResGet = 4, -- 超量获取
	Attr = 5, -- 属性检测
	CRCError = 6,
	GatheringMonster = 7,
	Mouse = 8,
	Keyboard = 9,
	Raid = 11, -- 单人公会战
	DungeonReward = 12, -- 副本奖励
}

-- 监控反外挂上报周期（min）
CommonConst.MonitorReportPeriod = 1

-- 监控反外挂的统计周期（min）
CommonConst.MonitorCheatPeriod = {
	[CommonConst.MonitorCheatType.Time] = 24 * 60,
}

-- 关卡通关时间外挂判定时间
CommonConst.MonitorTimeCheatSecond = 5
-- 关卡通关时间外挂检查次数阈值
CommonConst.MonitorTimeCheckTimes = 15

-- 客户端收集报警信息
CommonConst.WarningCollectionPeriod = 60

-- 客户端收集日志信息
CommonConst.ClientLogCollectionPeriod = 1

-- 作弊上报字段
CommonConst.CheatKey = {
	MaxDamage = "MaxDamage",
	DamageLog = "DamageLog",
	TotalRecharge = "TotalRecharge",
	TimeCheat = "TimeCheat",
	TimeCheck = "TimeCheck",
	TimeCheckStart = "TimeCheckStart",
	ExpRate = "ExpRate",
	AdvGet = "AdvGet",
	OverGet = "OverGet",
	OverGetTag = "OverGetTag",
	Attr = "Attr",
}

CommonConst.RaidState = {
	Zero = 0,
    PreRaid = 1, -- 预选
    Raid = 2, -- 正式
    Rest = 3, -- 休整
}

CommonConst.PreRaidRankRefreshPercent = 1

CommonConst.PreRaidRankRefreshCheckMin = 100000

CommonConst.TheaterPerformGameState = {
    End = 0, -- 表演未开启（可接取任务）
    Start  = 1, -- 表演刚开启（可接取任务）
    Performing = 2, -- 表演进行中
    Settle = 3, -- 表演结束结算中
}

CommonConst.RankType = {
	PreRaidRank = 1,
	RaidRank = 2,
}

CommonConst.CommonQuestType = {
	Normal = 1,
	Daily = 2, -- 每日任务
}

-- 交付界面请求刷新CD
CommonConst.TheaterDonationRefreshCD = 3

CommonConst.PlayerTag = {
	New = 1, -- 新玩家
	Active = 2, -- 活跃玩家
	ComeBack = 3, -- 回归玩家
}

-- 每日活跃度
CommonConst.DailyProgressNeed = 200
CommonConst.ForbidDungeonRewardCD = 3600
CommonConst.ForbidDungeonRewardCount = 30

CommonConst.RegionOnlineState = {
	NotExist = -1, -- 不存在
	Normal = 1, -- 正常
	Busy = 2, -- 繁忙
	Full = 3, -- 已满
}



CommonConst.WeaponSubType = {
	Normal = "Normal",
	Hyper = "Hyper",
}

CommonConst.SynthesisIIHostageUnitId = 7017051

return CommonConst

--endregion 这里只能定义常量
--不能定义其他东西，尤其是全局变量，全局变量到GWorld里定义