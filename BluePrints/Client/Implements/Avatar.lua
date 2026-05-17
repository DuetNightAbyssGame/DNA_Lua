local prop = require "NetworkEngine.Common.Prop"

---@class AvatarAttr
local AvatarAttr = {
	_id = prop.prop("ObjId", "client save"),
	-- Eid
	Eid = prop.prop("ObjId", "client save"),
	-- Uid
	Uid = prop.prop("Int", "client save cross"),
	-- Hostnum
	Hostnum = prop.prop("Int", "client save"),
	-- 注册时间戳
	RegTime = prop.prop("Int", "client save",0),
	-- 账号
	Account = prop.prop("Str", "client save"),
	-- 账号ID
	AccountId = prop.prop("Str", "client save"),
	-- 登陆sdk user id
	SdkUserId = prop.prop("Str", "client save"),
	-- 登陆设备id
	SdkDeviceId = prop.prop("Str2StrDict", "client save"),
	-- channel
	Channel = prop.prop("Str", "client save"),
	-- 注册时的channel id
	ChannelId = prop.prop("Int", "client save",237),
	-- 注册时的img channel id
	ImgChannelId = prop.prop("Int", "client save", 0),
	-- sdk uid
	ChannelUid = prop.prop("Str", "client save"),
	--当前HeadIconId头像图标id
	HeadIconId = prop.prop("Int","client save cross",10001),
	--拥有的头像列表
	HeadIconList = prop.prop("IntList","client save",{10001}),
	--当前HeadFrameId头像框id
	HeadFrameId = prop.prop("Int","client save cross",-1),
	--拥有的头像框列表
	HeadFrameList = prop.prop("IntList","client save"),
	--Signature签名
	Signature = prop.prop("Str","client save cross",""),
	--Birthday生日
	Birthday = prop.prop("IntList", "client save",{0,0,1}),--{月，日，剩余修改次数}
	BirthdayMailRecord = prop.prop("Int2IntDict", "client save", {}), -- 记录每年是否发过生日邮件
	-- nickname
	Nickname = prop.prop("Str", "client save cross"),
	-- nickname
	NicknameChangeTime = prop.prop("Int", "client save",0),

	-- 前主角名字
	WeitaName = prop.prop("Str", "client save",""),
	-- 前主角性别
	WeitaSex = prop.prop("Int", "client save",0),
	-- sex
	Sex = prop.prop("Int", "client save cross",1),
	--体力
	ActionPoint = prop.prop("Int", "client save",0),
	ActionPointLastRecoverTime = prop.prop("Int", "client save",0),
	PurchaseActionPointCount = prop.prop("Int", "client save",0),
	TotalActionPointCost = prop.prop("Int", "client save",0),
	ActionPointRewardGot = prop.prop("Int2IntDict", "client save", {}),

	-- 账号创建时间
	CreateTime = prop.prop("Float", "client save"),
	-- 上次登录时间
	LastLoginTime = prop.prop("Float", "client save"),
	-- 上一次登出时间
	LastLogoutTime = prop.prop("Float", "client save"),
	-- 累计登录天数
	TotalLoginDays = prop.prop("Int", "client save"),
	-- 累计在线时长
	TotalOnlineTime = prop.prop("Int", "client save", 0),
	-- 区域联机累计在线时长
	TotalRegionOnlineTime = prop.prop("Int", "client save", 0),
	-- 连续登录天数
	ConsecutiveLoginDays = prop.prop("Int", "client save"),
	-- 每小时刷新时间
	NextHourlyRefreshTime = prop.prop("Int", "save"),
	-- 每日刷新时间
	NextDailyRefreshTime = prop.prop("Int", "save"),
	-- 每周刷新时间
	NextWeeklyRefreshTime = prop.prop("Int", "save"),
	-- 每月刷新时间
	NextMonthlyRefreshTime = prop.prop("Int", "save"),
	-- 上一次埋点记录的时间
	LastSaLogTime = prop.prop("Int", "save",0),
	-- 当前赛季
	CurrentRaidSeasonId = prop.prop("Int", "client save", 0),
	-- 赛季数据
	RaidSeasons = prop.prop("RaidSeason.RaidSeasonDict", "client save"),
	--  区域数据
	--  上次离线区域数据
	LastRegionData = prop.prop("Region.LastRegionData", "client save"),
	CurrentRegionId = prop.prop("Int", "client save", 0),
	StartIndex = prop.prop("Int", "client save", 0),
	--  上次离线区域数据
	CommonRegionDatas = prop.prop("Region.SubRegionBaseDataAttrDict", "save"),
	QuestRegionDatas = prop.prop("Region.SubRegionBaseDataAttrDict", "save"),
	RarelyRegionDatas = prop.prop("Region.SubRegionBaseDataAttrDict", "save"),
	CommonDailyRegionDatas = prop.prop("Region.SubRegionBaseDataAttrDict", "save"),
	CommonTriduumRegionDatas = prop.prop("Region.SubRegionBaseDataAttrDict", "save"),
	CommonWeeklyRegionDatas = prop.prop("Region.SubRegionBaseDataAttrDict", "save"),
	CommonQuestRegionDatas = prop.prop("Region.SubRegionBaseDataAttrDict","save"),
	Region2TryPetCount = prop.prop("Int2IntDict", "client save"),
	TryMaxPetRegionId = prop.prop("Int", "client save", 0),
	--- 昼夜系统时间戳
	TimeOfDay = prop.prop("Float", "client save", 12),
	-- 坐骑数据
	Mounts =  prop.prop("Mount.MountDict", "client save"),
	-- 坐骑共享等级数据
	ShareMountDatas = prop.prop("Mount.MountShareDataDict", "client save"),
	-- 坐骑执照
	MountFlyLicenses = prop.prop("Int2IntDict", "client save"),
	-- 区域测试用的开关
	TestRegionDataCheck = prop.prop("Bool", "save", false),
	--  区域数据
	RegionDataRefreshTime = prop.prop("Int2IntDict", "save"),
	-- 等级
	Level = prop.prop("Int", "client save cross", 1),
	-- 等级奖励领取态
	LevelRewardsGot = prop.prop("IntSet", "client save"),
	-- 收集奖励
	CollectRewardExpRecord = prop.prop("Str2IntDict", "client save", {}),
	StoredCollectReward = prop.prop("Str2IntDict", "client save", {}), -- 待领取的收集奖励
	ActivityRewardGotRecord = prop.prop("Str2IntDict", "client save", {}), -- 已领取的奖励
	-- 日常任务初始登记
	DailyInitLevel =  prop.prop("Int", "client save cross", 1),
	-- 经验
	Exp = prop.prop("Int", "client save cross"),
	PlayerExpRecord = prop.prop("Int2IntDict", "client save", {}), -- 玩家经验记录
	-- 累计经验
	TotalExp = prop.prop("Int", "client save"),
	-- 当前角色
	CurrentChar = prop.prop("ObjId", "client save"),
	-- 当前近战武器
	MeleeWeapon = prop.prop("ObjId", "client save"),
	-- 当前远程武器
	RangedWeapon = prop.prop("ObjId", "client save"),
	--Buff
	Buffs = prop.prop("Buff.BuffDict", "client save cross"),
	--ServerBuff
	ServerBuffs = prop.prop("Buff.BuffDict", "client cross"),
	--ServerEffects
	ServerEffects = prop.prop("Buff.EffectDict", "client"),
	-- 角色
	Chars = prop.prop("Character.CharDict", "client save proto"),
	-- 角色公共数据
	CommonChars = prop.prop("CharacterCommon.CommonCharDict", "client save"),
	-- 未拥有角色的皮肤
	OtherCharSkins = prop.prop("Int2IntListDict", "client save"),
	-- 未拥有角色的发型
	OtherCharHairs = prop.prop("Int2IntListDict", "client save"),
	-- 通用角色发型
	CommonCharHairs = prop.prop("Int2IntDict", "client save"),
	-- 武器
	Weapons = prop.prop("Weapon.WeaponDict", "client save meta"),
	-- 显赫武器
	UWeapons = prop.prop("Weapon.UWeaponDict", "client save meta"),
	-- 拥有的武器皮肤
	OwnedWeaponSkins = prop.prop("Int2IntDict", "client save"),
	-- 拥有的坐骑皮肤
	OwnedMountSkins = prop.prop("Int2IntDict", "client save"),
	-- 任务
	QuestChains = prop.prop("Quest.QuestChains", "client save"),
	-- 任务对应的UI弹窗
	QuestPopUI = prop.prop("Int2IntDict", "client save"),
	-- 日常任务
	DailyTasks = prop.prop("DailyTask.DailyTaskDict", "client save"),
	-- 日常进度
	DailyTaskProgress = prop.prop("Int2IntDict", "client save"),
	-- 日常对话奖励
	DailyTalks = prop.prop("Int2BoolDict", "client save"),
	-- 当前日常进度
	CurrentTaskProgress = prop.prop("Int", "client save", 0),
	-- 每日任务达200活跃度次数
	DailyProgressReachTimes = prop.prop("Int", "client save", 0),
	-- 日常成就
	DailyTaskAchvs = prop.prop("TargetCounter.TargetCounterDict", "client save"),
	-- 邮件唯一ID递增
	MailUniqueID = prop.prop("Int", "client save", 1),
	-- 邮件收件箱
	MailInbox = prop.prop("Mail.MailDict", "client save"),
	-- 邮件收藏夹
	StarMails = prop.prop("Mail.MailDict", "client save"),
	-- 运营邮件领取记录
	OperationMailNotes = prop.prop("Str2StrDict", "client save"),
	--条件邮件领取记录
	ConditionMailHasGot = prop.prop("Int2IntDict", "client save"),
	-- H5奖励邮件领取记录
	H5RewardMailRecord = prop.prop("Int2IntDict", "client save"),
	-- 调查问卷领取记录
	QuestionnaireRecord = prop.prop("Int2IntDict", "client save"),
	-- 教学手册状态 key:教学id value:已经领取
	GuideBook = prop.prop("GuideBook.GuideBookDict", "client save"),

	-- 选中的Char
	CurrentPartyChar = prop.prop("Int", "client save", 1),
	-- 邀约Char
	PartyNpcs = prop.prop("Party.PartyDict", "client save"),
	-- 资源
	Resources = prop.prop("Resource.ResourceDict", "client save"),

	-- 每天所获得的深红凝珠数量
	ResourceCoinNumDaily = prop.prop("Int", "client save"),

	-- 限时资源
	LimitedResources = prop.prop("LimitedResource.LimitedResourceDict", "client save"),

	-- 钢铁之证
	IronSurvivalTicket = prop.prop("IronSurvival.IronSurvivalTicketDict","client save"),
	-- 钢铁之证唯一Id
	IronSurvivalTicketUniqueId = prop.prop("Int", "save", 0),

	-- Mod
	Mods = prop.prop("Mod.ModDict", "client save"),
	OriginalMods = prop.prop("Int2ObjIdDict", "client save"),
	HoldMods = prop.prop("Int2IntDict", "client save"),
	HoldModRewards = prop.prop("Int2BoolDict", "client save"),
	-- 副本
	Dungeons = prop.prop("Dungeon.DungeonDict", "client save"),
	-- 副本随机事件
	DungeonRandomEvent = prop.prop("DungeonRandomEvent.DungeonRandomEvent", "client save"),
	-- 副本是否双倍消耗体力
	bDungeonDoubleCost = prop.prop("Bool", "client save", false),
	--FeiNa活动数据
	FeiNaDungeonData = prop.prop("FeiNaActivity.FeiNaDict", "client save"),
	-- 今日获得的派对复通奖励
	TodayPartyReward = prop.prop("Int", "client save", 0),
	-- 阵容预设
	Squad = prop.prop("Squad.SquadList", "client save"),
	-- 副本阵容预设
	DungeonSquad = prop.prop("Str2IntDict", "client save"),
	-- 整备阵容自动召唤魅影
	bAutoPhantomForDefaultSquad = prop.prop("Bool", "client save", true),
	--据点看板娘
	SignBoardNpc = prop.prop("IntList", "client save"),
	--看板娘每日放置对话总计数
	TotalSignBoardNpcDailyTalkCount = prop.prop("Int", "client save", 0),
	-- 奖励影响参数
	RewardParams = prop.prop("RewardParams.RewardParams", "client save cross"),
	-- 成就
	Achvs = prop.prop("Achv.AchvDict", "client save"),
	-- 目标需求表
	AchvTargets = prop.prop("Achv.AchvTargetDict", "client save cross"),
	-- 铸造蓝图
	Drafts = prop.prop("Blueprint.DraftDict","client save"),
	-- 铸造图鉴
	HoldDrafts = prop.prop("Int2IntDict", "client save"),
	--自定义操作映射，按键设置
	ActionMapping = prop.prop("Str2StrDict", "client save"),

	-- 抽卡相关
	-- 卡池表，用于记录每个卡池的配表信息以及个人信息
	GachaPool = prop.prop("Gacha.GachaDict", "client save"),
	-- 皮肤卡池表
	SkinGachaPool = prop.prop("Gacha.SkinGachaDict", "client save"),
	-- 保底记录表
	GuaranteedDict = prop.prop("Gacha.GuaranteedDict", "client save"),
	-- 抽卡记录
	GachaRecordQueue = prop.prop("Gacha.GachaRecordQueue", "save"),
	-- 抽卡记录数据结构参数
	GachaRecordParams = prop.prop("Str2IntDict", "save"),
	-- 今日已抽卡次数
	GachaDrawCounts = prop.prop("Int", "client save", 0),

	-- 有限奖池
	LimitPrize = prop.prop("LimitPrize.LimitPrizeDict", "client save"),

	--商城-商品表
	ShopItems = prop.prop("Shop.ShopItemDict", "client save"),
	-- 探索数据
	Explores = prop.prop("Explore.ExploreDict","client save"),
	-- 首遇怪物数据
	FirstMonsters = prop.prop("IntList", "client save"),
	-- 首遇强引导怪物数据
	FirstStrongMonsters = prop.prop("IntList", "client save"),
	-- 首遇机关数据
	FirstMechanismTags = prop.prop("Str2IntDict", "client save"),
	-- 离线后rpc时间
	OfflineOperatorTime = prop.prop("Float", "save"),
	-- 配置文件
	Suits = prop.prop("Suit.Suits", "client save"),

	-- 印象系统
	Impressions = prop.prop("Impression.ImpressionDict","client save"),
	ImpressionDialogues = prop.prop("Int2IntDict", "client save"),
	ImpressionTalkTriggers = prop.prop("Int2IntDict", "client save"),

	-- 轮盘
	Wheels = prop.prop("Wheel.Wheels", "client save"),
	-- 轮盘套装名
	WheelsName  = prop.prop("StrList", "client save"),
	-- 当前选择的轮盘
	WheelIndex = prop.prop("Int", "client save", 1),

	-- 梦魇残声（HardBoss）
	HardBoss = prop.prop("HardBoss.HardBoss", "client save"),

	-- 系统解锁状态
	SystemStates = prop.prop("Str2IntDict", "client save"),
	-- 系统引导
	SystemGuides = prop.prop("SystemGuide.SystemGuideDict","client save"),

	--动态事件
	DynamicQuests = prop.prop("DynamicQuest.DynamicQuestDict", "client save"),

	--今日已完成的限次动态事件次数
	TodayLimitDynamicQuestTimes = prop.prop("Int", "client save", 0),

	--最近一次GCD开始的时间
	DynamicQuestGlobalCD = prop.prop("Int", "client save", 0),

	--当前大秘境赛季Id
	CurrentAbyssSeasonId = prop.prop("Int", "client save"),
	--大秘境
	Abysses = prop.prop("Abyss.AbyssDict", "client save"),

	-- UI标记点
	MarkPoints = prop.prop("MarkPoint.MarkPointDict", "client save"),

	-- 追踪的任务
	QuestTrack = prop.prop("Quest.QuestTracking", "client save"),

	-- 当前追踪的任务链ID
	TrackingQuestChainId = prop.prop("Int", "client save", 0),

	-- 任务全局变量
	StoryVariable = prop.prop("Str2IntDict", "client save"),

	-- 饰品
	CharAccessorys = prop.prop("IntList", "client save"),
	--武器配饰
	WeaponAccessorys = prop.prop("IntList", "client save"),
	--坐骑配饰
	MountAccessorys = prop.prop("IntList", "client save"),

	-- 肉鸽玩法数据
	RougeLike = prop.prop("RougeLikeInfo.RougeLikeInfo", "client save"),

	-- 特殊任务数据
	SpecialQuestData = prop.prop("Quest.SpecialQuestDataDict","client save"),

	-- 盗宝怪是否能刷新
	IsRefreshRobberMonster = prop.prop("Bool", "client save"),
	--好友列表
	Friends = prop.prop("Friend.FriendDict", "client save"),
	--好友申请列表
	FriendRequestReceiveBox = prop.prop("Friend.FriendRequestDict", "client save"),
	--好友申请发送列表
	FriendRequestSendBox = prop.prop("Friend.FriendRequestDict", "client save"),
	--黑名单
	Blacklist = prop.prop("AvatarInfo.AvatarInfoDict", "client save"),
	--最近匹配的玩家
	RecentMatchList = prop.prop("Friend.RecentMatchedFriendDict", "client save"),
	--推荐好友列表
	RecommendFriendList = prop.prop("AvatarInfo.AvatarInfoDict", "client save"),

	--所有宠物
	Pets = prop.prop("Pet.PetDict", "client save"),
	--宠物递增唯一ID
	PetUniqueID = prop.prop("Int", "save", 1),
	--动态事件宠物抓捕唯一ID
	DynamicQuestPetToBeCapturedUniqueId = prop.prop("Int", "client save", 0),
	--当前佩戴的宠物 
	--由于策划又后加了一套阵容预设的鬼东西，CurrentPet的表达能力不够用了
	--目前只有区域和没设置阵容预设的时候有用
	CurrentPet = prop.prop("Int", "client save", 0),

	-- 当前生效中的宠物  
	-- 当前生效中的宠物属性变化了需要重新计算增益
	-- 按照阵容预设进入副本的时候 CurrentPet会失效，所以需要单独记录一个属性来表示当前生效中的宠物。
	EffectingPet = prop.prop("Int", "client save", 0),

	--宠物解锁过的词条
	PetUnlockedEntrys = prop.prop("Int2IntDict", "client save"),
	--抓宠保底概率
	PetGuaranteeRate = prop.prop("Float", "save", 1),
	-- 抓宠显示升级炫彩道具
	PetShowPremiumTransform = prop.prop("Bool", "client save", false),
	-- 宠物设置 开启自动锁定 有该词条的宠物会自动锁定
	PetEntryLockSetting = prop.prop("Int2IntDict", "client save"),

	-- 1.0大量玩家把巧手喂了， 1.1 策划要求第一次获得金词条自动上锁
	PetEntryTryAutoLockRecord = prop.prop("Int2IntDict", "client save"),

	-- 聊天
	Chats = prop.prop("Chat.ChatDict", "client save"),
	-- 聊天频道开关
	ChatChannelClose = prop.prop("Int2BoolDict", "client"),
	---世界频道-历史频道
	ChatHelpChannelHistoryList = prop.prop("IntList", "client save"),
	-- 禁言时间点
	ForbidChatTime = prop.prop("Int", "client save",0),
	-- 禁言原因
	ForbidChatReason = prop.prop("Str", "client save", ""),
	-- 聊天频道免打扰
	ChatChannelMute = prop.prop("Int2IntDict", "client save"),
	-- 快捷消息
	QuickMessages = prop.prop("StrList", "client save"),
	-- 表情包
	Emoticons = prop.prop("IntList", "client save"),

	DailyLogin = prop.prop("DailyLogin.DailyLoginDict", "client save"),

	StarterQuests = prop.prop("TargetCounter.TargetCounterDict", "client save"),

	ModGuideQuests = prop.prop("TargetCounter.TargetCounterDict", "client save"),

	--战令每日任务
	BattlePassTaskDaily = prop.prop("TargetCounter.TargetCounterDict", "client save"),
	--战令每周任务
	BattlePassTaskWeekly = prop.prop("TargetCounter.TargetCounterDict", "client save"),
	--战令版本任务	
	BattlePassTaskVersion = prop.prop("TargetCounter.TargetCounterDict", "client save"),
	--战令版本号
	BattlePassVersion = prop.prop("Int", "client save", 0),
	--战令等级
	BattlePassLevel = prop.prop("Int", "client save", 1),
	--战令经验
	BattlePassExp = prop.prop("Int", "client save", 0),
	--免费战令等级奖励领取记录
	BattlePassRank1LevelRewardsGot = prop.prop("Int2BoolDict", "client save"),
	--RMB战令等级奖励领取记录
	BattlePassRank2LevelRewardsGot = prop.prop("Int2BoolDict", "client save"),
	--RMB战令解锁状态
	BattlePassUnlockRank2 = prop.prop("Bool", "client save", false),
	--RMB战令解锁状态
	BattlePassUnlockRank3 = prop.prop("Bool", "client save", false),
	-- 战令宠物是否已获取
	BattlePassPetClaimed = prop.prop("Bool", "client save", false),
	-- 战令宠物是否可以领取
	BattlePassPetCanClaim = prop.prop("Bool", "client save", false),
	-- 战令宠物领取记录
	BattlePassPetClaimedRecord = prop.prop("Int2IntDict", "client save"),
	-- 是否有上版本战令未领取宠物
	BattlePassLastVersionHasUnclaimedPet = prop.prop("Bool", "client save", false),
	-- 上版本战令版本号
	BattlePassLastVersion = prop.prop("Int", "client save", 0),
	--本周每日任务和每周任务 已获取的战令经验
	BattlePassWeeklyExp = prop.prop("Int", "client save", 0),
	--本周每日任务和每周任务 触发了自动领取
	BattlePassAutoGetTaskReward = prop.prop("Bool", "client save", false),
	--战令已经自动领取的奖励记录
	BattlePassAutoGotRewards_ = prop.prop("Str", "save", "return {}"),
	-- 战令过期提醒邮件记录
	BattlePassRemindMailRecord = prop.prop("Int2IntDict", "client save", {}),

	TeamOrientation = prop.prop("Int", "client save", 1),

	---- 对话台本标签
	TalkTags = prop.prop("Str2IntDict", "client save"),

	-- 是否被封禁
	IsBanned = prop.prop("Bool", "client save"),
	-- 封禁原因
	BanReason = prop.prop("Str", "client save"),
	-- 封禁时间
	BanTime = prop.prop("Int", "client save"),
	-- 黑名单匹配
	BlackMatch = prop.prop("Int", "save", -1),
	-- 副本奖励没收次数
	ForbidDungeonRewardCount =  prop.prop("Int", "client save", 0),
	-- 上次执行惩罚的时间 有一小时CD 防止重复惩罚
	ForbidDungeonRewardTime = prop.prop("Int", "client save", 0),

	-- 累计充值金额
	TotalRechargeMoney = prop.prop("Float", "client save", 0),
	-- 累计充值次数
	TotalRechargeCount = prop.prop("Int", "save", 0),
	-- 充值返利
	FeeRefund = prop.prop("FeeRefund.FeeRefundDict", "client save"),
	-- 是否已经获取过充值返利
	bGotFeeRefund = prop.prop("Bool", "save", false),

	-- 临时移除的武器 --- 用于铸造消耗
	RemoveWeapons = prop.prop("Weapon.WeaponDict", "client save meta"),
	-- 临时移除的Mod --- 用于铸造消耗
	RemoveMods = prop.prop("Mod.ModDict", "client save"),
	-- 扣除的资源对应的数量
	Draft2Matas = prop.prop("Blueprint.Draft2MataDict", "client save"),
	-- 区域宠物状态数据
	PetRegionAttrs = prop.prop("Region.PetRegionAttrDict", "client save"),
	-- 区域特殊怪刷新计数器
	RegionSpecialMonsterCounter = prop.prop("Int2IntDict", "client save"),
	-- 区域特殊怪刷新计时器
	RegionSpecialMonsterTimer = prop.prop("Int2IntDict", "client save"),
	
	
	--CDK使用记录
	CDKUsageRecord = prop.prop("Int2IntDict", "client save"),

	-- 印象商店
	ImpressionShops = prop.prop("ImpressionShop.ImpressionShopItemDict", "client save"),

	WikiEntries = prop.prop("WikiEntry.WikiEntryDict", "client save"),

	WikiGotRewards = prop.prop("Int2IntDict", "client save"),

	-- 委托密函
	Walnuts = prop.prop("Walnut.Walnut", "client save cross"),

	-- 派遣系统
	Dispatches = prop.prop("DispatchGame.DispatchDict", "client save"),
	CurrentDispatchList = prop.prop("DispatchGame.DispatchGameListDict", "client save"),

	-- 角色试用
	CharTrial = prop.prop("CharTrial.CharTrialDict", "client save"),

	-- LevelSequence状态记录器
	LevelSequenceStateRecorder = prop.prop("LevelSequenceState.LevelSequenceStateDict", "client save"),

	--图鉴陈列室
	Archives = prop.prop("Archive.ArchiveDict", "client save"),

	--钓鱼点
	FishingSpots = prop.prop("Fish.FishingSpotDict", "client save"),
	--已钓到的鱼图鉴,{Id：数量，最大尺寸}
	Fishes = prop.prop("Int2IntListDict", "client save"),
	--背包里鱼的尺寸
	FishSizes = prop.prop("Fish.FishSizeDict", "client save"),
	--钓鱼成就
	FishAchvs = prop.prop("TargetCounter.TargetCounterDict", "client save"),
	-- 钓鱼额外奖励剩余次数
	FishRemainExtraReward = prop.prop("Int", "client save", 0),

	--推理小游戏 解锁的线索
	DetectiveGameUnlockedAnswers = prop.prop("Int2IntDict", "client save"),
	DetectiveGameUnlockedAnswersRecord = prop.prop("Int2IntDict", "client save"),
	DetectiveGameUnlockedQuestions = prop.prop("Int2IntDict", "client save"),
	DetectiveGameUnlockedResults = prop.prop("Int2IntDict", "client save"),

	-- 记录读过的台本
	CompletedDialogues = prop.prop("Int2IntDict", "client save"),

	-- 解锁的音乐
	BGMs = prop.prop("Int2IntDict", "client save",{[1004003] = 1}),
	HomeBaseBGM = prop.prop("Int", "client save", 1004003),

	-- 个人主页
	PersonalInfo = prop.prop("PersonalInfo.PersonalInfo", "client save"),

	-- 月卡
	MonthlyCards = prop.prop("MonthlyCard.MonthlyCardDict", "client save"),
	-- 剩余可领月卡每日奖励次数
	MonthlyCardDailyRewardCount = prop.prop("Int", "client save"),
	-- 月卡每日奖励信息
	MonthlyCardDailyRewards = prop.prop("MonthlyCard.MonthlyCardDailyRewardList", "save"),
	-- 月卡有效期
	MonthlyCardExpireTime = prop.prop("Int", "client save"),
	-- 上一次领取月卡每日奖励的时间
	LastMonthlyCardDailyRewardTime = prop.prop("Int", "client save"),
	-- 月卡到期提醒时间
	MonthlyCardExpireRemindTime = prop.prop("Int", "client save"),

	-- mod手册任务
	ModBookQuests = prop.prop("ModBookQuest.ModBookQuestDict", "client save"),
	-- mod手册任务阶段奖励领取
	ModBookQuestPhaseRewardsGot = prop.prop("Int2BoolDict", "client save"),

	ZhiLiuEntrustDict = prop.prop("ZhiLiuEntrust.ZhiLiuEntrustDict", "client save"),

	ZhiLiuEntrustGrandRewardGot = prop.prop("Bool", "client save",false),


	ActivityPlayerLvRewardsGot = prop.prop("Int2IntSetDict", "client save"),
	--下架的活动
	OfflineActivity = prop.prop("Int2IntDict", "client save"),

	
	ActivityEndRemindMailRecord = prop.prop("Int2IntDict", "client save", {}),
	ActivityPermanenRemindMailRecord = prop.prop("Int2IntDict", "client save", {}),
	WeChatSentRewards = prop.prop("Str2IntDict", "client save", {}),
	OfficalSentRewards = prop.prop("Str2IntDict", "client save", {}),
	-- 中期活动奖池积分
	MidTermScores = prop.prop("Int", "client save"),
	-- 中期活动成就积分
	MidTermAchvScores = prop.prop("Int", "client save"),
	-- 中期活动任务
	MidTermTasks = prop.prop("TargetCounter.TargetCounterDict", "client save"),
	-- 中期活动任务记录(循环任务计数)
	MidTermTasksRecord = prop.prop("MidTermTask.MidTermTaskDict", "client save"),
	-- 积分奖励
	MidTermScoresRewards = prop.prop("Int2IntDict", "client save"),
	-- 成就积点进度奖励领取{[pt] = 1}
	MidTermAchvProgressRewarded = prop.prop("Int2IntDict", "client save"),

	-- 炮台小游戏
	PaotaiGame = prop.prop("PaotaiGame.PaotaiEventDict", "client save"),
	-- 炮台增益列表
	PaotaiBuffs = prop.prop("Int2IntDict", "client save"),

	-- 皎皎角相关
	Community = prop.prop("Community.Community", "client save"),

	-- 条件领奖活动领取记录
	ClaimActivityConditionRewardRecord = prop.prop("Int2IntDict", "client save"),

	--魔之楔双倍掉落
	DoubleModDrop = prop.prop("DoubleModDrop.DoubleModDropDict", "client save"),
	-- 双倍掉落活动首次标识
	DoubleModDropFirst = prop.prop("Bool", "client save", true),

	--通用 活动任务系统
	CommonQuestActivity = prop.prop("CommonQuest.CommonQuestDict", "client save"),
	CommonQuestBases = prop.prop("CommonQuest.CommonQuestBaseDict", "client save"),

	-- 周本奖励剩余次数
	WeeklyDungeonRewardLeft = prop.prop("Int", "client save", 0),

	-- sdk 登录时的 code
	SdkLoginRegionCode = prop.prop("Str", "client"),
	-- sdk 注册时的 code
	SdkRegisterRegionCode = prop.prop("Str", "client save"),

	-- 神庙活动
	Temple = prop.prop("Temple.TempleDict", "client save"),

	-- Twitch掉落奖励领取
	TwitchRewardsGot = prop.prop("Str2IntDict", "client save"),
	-- Chzzk奖励领取
	ChzzkRewardsGot = prop.prop("Str2IntDict", "client save"),

	-- 完成的活动
	CompletedActivity = prop.prop("Int2IntDict", "client save"),

	CatName = prop.prop("Str", "client save"),

	-- 无由生活动
	WuyoushengActivity = prop.prop("Wuyousheng.WuyoushengDict", "client save"),

	-- 称号
	Titles = prop.prop("Int2IntDict", "client save"),
	-- 称号样式
	TitleFrames = prop.prop("Int2IntDict", "client save"),
	-- 称号前
	TitleBefore = prop.prop("Int", "client save", -1),
	-- 称号后
	TitleAfter = prop.prop("Int", "client save", -1),
	-- TitleFrame
	TitleFrame = prop.prop("Int", "client save", -1),

	--剧场联机活动
	TheaterActivity = prop.prop("Theater.TheaterDict", "client save"),

	--数据统计,角色、武器...{Weapon10101 = 1}
	DataStatistics = prop.prop("Str2IntDict", "client save", {}),

	-- 分日礼包
	DailyPacks = prop.prop("DailyPack.DailyPackDict", "client save"),

	-- 跳转页列表(0未完成1已完成2已领取)
	WebJumpList = prop.prop("Int2IntDict", "client save"),

	--当前生效的移动端HUD布局方案
	CurrentMobileHudPlan = prop.prop("Int", "client save", 1),
	--移动端HUD布局
	MobileHudPlans = prop.prop("StrList", "client save"),

	-- AppStore评分推荐弹窗上次弹出时间
	LastAppStoreRatingJumpTime = prop.prop("Str2IntDict", "client save", {}),

	-- 自走棋
	AutoChess = prop.prop("AutoChess.AutoChess", "client save"),


	-- 礼物订单字典
	GiftOrders = prop.prop("Gift.GiftOrderDict", "client save"),
	-- 礼物额度总量
	TotalGiftQuota = prop.prop("Int", "client save", 0),
	-- 已经花费的礼物额度
	ConsumeGiftQuota = prop.prop("Int", "client save", 0),
	-- 每月已发送礼物数量
	-- MonthSendGiftCount = prop.prop("Int", "client save"),
	-- 当月已发送礼物数量
	CurrentMonthSendGiftCount = prop.prop("Int", "client save", 0),
	-- 禁止发送礼物
	BanGiftSend = prop.prop("Bool", "client save", false),
	-- 禁止接收礼物
	BanGiftRecv = prop.prop("Bool", "client save", false),
	
	-- 礼物白名单
	GiftWhitelist = prop.prop("Bool", "client save",false),
	-- 发送礼物记录列表
	SentGiftRecords = prop.prop("Gift.GiftRecordList", "client save"),
	-- 接收礼物记录列表
	RecvGiftRecords = prop.prop("Gift.GiftRecordList", "client save"),
	--区域声望
	RegionReputations = prop.prop("RegionReputation.RegionReputationDict", "client save"),
	--文明博弈(中期活动2.0)
	MidTermGoals = prop.prop("MidTermGoal.MidTermGoalDict", "client save"),
	-- FoolsDayPhotoUniqueId Int 1 图片唯一ID自增
	FoolsDayPhotoUniqueId = prop.prop("Int", "client save", 1),
	-- FoolsDayPhotos IntList 自己的上传图片列表
	FoolsDayPhotos = prop.prop("IntList", "client save"),
	-- FoolsDayLikeRecord 点赞列表
	FoolsDayLikeRecord = prop.prop("FoolsDay.FoolsDayLikeRecordDict", "client save"),

	-- 愚人节上次使用时间
	FoolsDayUseTransformLastTime = prop.prop("Int", "client save", 0),

	-- 愚人节上次点赞时间
	FoolsDayLikeLastTime = prop.prop("Int", "client save", 0),

	UnlockedFoolsDayTransforms = prop.prop("Int2IntDict", "client save",{}),

	-- 累充活动
	AccumulateRecharge = prop.prop("AccumulateRecharge.AccumulateRechargeDict", "client save"),

	-- 回归活动
	ComeBacks = prop.prop("ComeBack.ComeBackDict", "client save"),
	-- 回归活动过期时间
	ComeBackExpireTime = prop.prop("Int", "client save"),

	-- 二级密码每次登录只验证一次状态
	SecondaryPasswordPreLoginValidateOnce = prop.prop("Bool", "client save", false),
	-- 二级密码
	szSecondaryPassword = prop.prop("Str", "client save", ""),
	-- 二级密码连续错误次数
	nSecondaryPasswordErrorTimes = prop.prop("Int", "client save", 0),
	-- 二级密码冻结时间戳
	nSecondaryPasswordFreezeTimeStamp = prop.prop("Int", "client save", 0),
	nSecondaryPasswordIsValidateThisLogin = prop.prop("Bool", "client", false),

	-- 拍照活动奖励领取
	PhotoActRewardGot = prop.prop("Int2IntDict", "client save"),

	-- 被举报记录
	ReportMatchRecord = prop.prop("Int2IntDict", "client save", {}),

	--寻宝局外记录
	TreasureHunts = prop.prop("TreasureHunt.TreasureHuntDict", "client save"),

	-- 背包整理活动
	BackpackPuzzles = prop.prop("BackpackPuzzle.BackpackPuzzleDict", "client save"),
	--STL奖励发放记录
	InteractTriggerRewardRecords = prop.prop("Int2IntDict", "client save", {}),
	-- 外观掉落活动
	AccessoryDrops = prop.prop("AccessoryDrop.AccessoryDropDict", "client save"),

	-- 区域联机频道缓存
	RegionOnlineChannelCache = prop.prop("Int2IntListDict", "client save"),

	-- -- 灵化武器熔炉等级
	-- WeaponForgeLevel = prop.prop("Int", "client save", 0),
	-- -- 灵化武器熔炉等级任务
	-- WeaponForgeQuests = prop.prop("TargetCounter.TargetCounterDict", "client save"),
	-- -- 灵化武器熔炉等级奖励领取
	-- WeaponForgeLevelRewardGot = prop.prop("Int2IntDict", "client save"),
}


return AvatarAttr
