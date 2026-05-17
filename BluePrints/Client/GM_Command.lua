-- local CommonUtils = require "Utils.CommonUtils"
-- local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
-- local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
-- local TimeUtils         = require "Utils.TimeUtils"
-- local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
-- local MAUtils = require "Utils.MonsterAnimationUtils"
-- local EMCache = require "EMCache.EMCache"
---@class BP_Avatar_C
local GM_Command = {}

function GM_Command:Initialize(Initializer)
	self:Init_Command()
    self.NewCommands = {}
    for k,v in pairs(self.Commands) do
        self.NewCommands[string.upper(k)] = v
    end

    for k,v in pairs(self.NewCommands) do
        self.Commands[k] = v
    end
end

---需要进入游戏后自动执行的GM指令写在这里
function GM_Command:AutoExecuteGM()
    local EMCache = require "EMCache.EMCache"
    if(EMCache:Get("GM_MockAllSystemCondition",true)) then
        self:MockAllSystemCondition()
    end
end

function GM_Command:Init_Command()
    self.Commands = {
        R = "ReloadAll",
        Hotfix = "Hotfix",
        GA = "GetAvatar",
        GSA = "GetServerAvatar",
        CM = "CreateMonster",                -- 创建怪物，默认静态怪
        CMSM = "CreateMonsterSpawnMonster",  -- 创建怪物，默认动态怪
        CTM = "CreateTestMonster",
        CP = "CreatePhantom",
        CMS = "CreateMechanismSummon",
        CN = "CreateNpc",
        CPet = "CreatePet",
		TriggerLoadedEvent = "TriggerLoadedEvent",

        MonsterForceLOD = "MonsterForceLOD", -- 强制设置怪物LOD等级
        
        LowQuality = "LowQuality",
        ShowFlag = "ShowFlag",

        QualityLevel = "QualityLevel",

        OpenUI = "OpenUI",
        HideUI = "HideUI",
        CloseUI = "CloseUI",
        ShowGuideUI = "ShowGuideUI",
        FallAttackPoint = "FallAttackPoint",
        FallAttackPointPos = "FallAttackPointPos",
        SwitchKawaiiDebug = "SwitchKawaiiDebug",
        -- 设置头部缩放
        HeadScale = "HeadScale",
        UpperArmScale = "UpperArmScale",
        LowerArmScale = "LowerArmScale",
        HandScale = "HandScale",
        Debug = "Debug",
        UpdateVLM = "UpdateVLM",

        GlobalTimeDilation = "GlobalTimeDilation",

        TakePhotoAddWaterMark = "TakePhotoAddWaterMark",

        ------------------ 关卡怪物战斗相关 Begin-----------------
        -- 关卡
        EnterDungeon = "EnterDungeon",              -- 进入XX副本
        ExitBattle = "ExitBattle",
        PlayerEnd = "PlayerEnd",                    -- 玩家结算，不影响副本流程
        DungeonObjectFinish = "DungeonObjectFinish",-- 副本服务器关卡结算
        InitGM = "InitGameMode",                    -- 按照某个副本ID初始化GameMode
        RequireAndEnterDS = "RequireAndEnterDS",    -- 申请一个DS场景并且进入
        ExitDS = "ExitDS",                          -- 退出当前所在DS场景
        EnterLocalDS = "EnterLocalDS",              -- 进入本地DS
        EnterLocalDungeon = "EnterLocalDungeon",    -- 进入本地服的副本
        EnterNewDS = "EnterNewDS",                  -- 进入新DS，中途不可加入其他人
        TestEnterDS = "TestEnterDS",                -- 测试进入DS，本地127.0.0.1:17777
        DSLog = "DSLog",                            -- 获取DS的日志地址
        KickPlayer = "KickPlayer",                  -- 踢出玩家
        KickSelf = "KickSelf",                      -- 踢出自己
        BlockEntrance = "BlockEntrance",            -- 副本锁定加入权限
        UseMinimumLoad = "UseMinimumLoad",          -- 使用新版关卡加载规则（最大5）
        GameModeEnable = "GameModeEnable",          -- 开启/关闭GameMode逻辑
        DSC = "DedicatedServerCommand",             -- DS GM指令
        DungeonDoubleCost = "DungeonDoubleCost",    -- 副本双倍消耗
		Tel = "Tel",
		FreezeWorldComposition = "FreezeWorldComposition",
        BreakableItemNavEnableInLower = "BreakableItemNavEnableInLower", -- 禁用破碎物体的导航修改
        PrintActorSCLoc = "PrintActorSCLoc",        -- 打印Actor DS和客户端的位置旋转
        TestServerRandomCreator = "TestServerRandomCreator",  -- 测试服务端随机创建器
        EnterIronSurvivalDungeon = "EnterIronSurvivalDungeon", -- 进入钢铁之证副本

        Recovery = "RecoverySelf",                  -- 复活
        RecoverPlayer = "RecoverPlayer",
        KM = "KillMonster",                         -- 杀怪
        RTL = "ResetTrollyLoc",                     -- 劫持玩法重置小车位置
        DMS = "DebugMonsterSpawn",                  -- 动态刷怪无视点位规则
        DPMS = "DebugPrintMonsterSpawn",            -- 显示动态刷怪的所有日志
        GAM = "GuideAllMonster",                    -- 显示当前所有怪物指引
        RSS = "RequestSnapShotInfo",                -- 打印所有的序列化数据
        RMC = "RequestMonsterCacheInfo",            -- 打印所有的怪物缓存数据
        RSC = "RequestStaticCreatorInfo",           -- 打印所有的静态刷新点数据
        NPCRotate = "NPCRotate",                    -- NPC旋转
        NPCRotate90 = "NPCRotate90",                -- NPC 90旋转
        NPCTalkAgree = "NPCTalkAgree",              -- NPC 抱胸和点头/摇头
        NPCAgree = "NPCAgree",                      -- NPC 单独点头
        NPCTalk03 = "NPCTalk03",                    -- NPC 单独抱胸
        YXD = "YXDTEST",                            -- yxd自用测试GM
        THY = "THYTEST",                            -- thy自用测试GM
        JTY = "JTYTEST",                            -- jty自用测试GM
        LJL = "LJLTEST",                            -- ljl自用测试GM
        HTY = "HTYTEST",                            -- hty自用测试GM
        LHQ = "LHQTEST",                            -- lhq自用测试GM
        LJH = "LJHTEST",                            -- ljh自用测试GM
        AYF = "AYFTEST",                            -- ayf自用测试GM
        LGC = "LGCTEST",                            -- lgc自用测试GM
        YLY = "YLYTEST",                            -- yly自用测试GM
        DungeonEventTest = "DungeonEventTest",      -- DungeonEvent 测试用GM
        SwitchSurvivalValueChange = "SwitchSurvivalValueChange",      --生存血清
        PrintLevelDebugInfo = "PrintLevelDebugInfo",                  -- 打印常用的关卡debug信息
        PrintPlayerInfoOnScreen = "PrintPlayerInfoOnScreen",
        PrintGameModeInfoOnScreen="PrintGameModeInfoOnScreen",
        
        TeleportPlayer = "TeleportPlayer",              -- 传送玩家到指定坐标

        PrintGetCover = "PrintGetCover",            -- 是否打印掩体的获取
        PrintUpdateCover = "PrintUpdateCover",      -- 是否打印掩体的更新

        TrainingCreateMonster = "TrainingCreateMonster", -- 训练场刷怪
        TrainingSetMonsterAI = "TrainingSetMonsterAI", -- 设置训练场怪物 AI 是否开启
        TrainingRemoveMonster = "TrainingRemoveMonster", -- 销毁训练场中生成的所有怪物
        TrainingClearCreateInfo = "TrainingClearCreateInfo", -- 删除训练场刷怪信息缓存

        CNPCCache = "PrintCustomNPCCacheInfo",

        StartVote = "StartVote",                    --直接开始投票
        SpawnPet = "SpawnPet",                      --副本确定生成宠物事件时,直接触发宠物事件
        PostCustomEvent = "PostCustomEvent",        -- 触发PostCustomEvent

        -- 菲娜活动
        SetFeinaStar = "SetFeinaStar",              -- 设置菲娜活动星数

        -- 大秘境相关
        EnterAbyss = "EnterAbyss",                  -- 进入大秘境
        EnterAbyssNew = "EnterAbyssNew",            -- 进入大秘境(新版)
        AbyssPassRoom = "AbyssPassRoom",            -- 深渊通关当前房间
        padt = "PrintAllDailyTask",                 -- 打印当前客户端每日任务信息
        --AI
        MonsterMaxHp = "MonsterMaxHp",              -- 怪物
        HMC = "HideMonsterCapsule",                 -- 隐藏全部怪物的胶囊体组件
        HM = "HideMonster",                 -- 隐藏怪物
        ShowCapsule = "ShowCapsule",                -- 展示胶囊体
        -- ShowCoverPoint = "ShowCoverPoint",          -- 显隐掩体点
        GetMonster = "GetMonster",                  -- 获取某只怪物
        StopAI = "StopAI",                          -- 停止行为树
        StartAI = "StartAI",                        -- 开始行为树
        MoveTo = "MoveTo",
        Target = "Target",
        TargetAll = "TargetAll",
        MoveDebug = "MoveDebug",
        PerMonsterDebug = "PerMonsterDebug",
        StopMonsterSkill = "StopMonsterSkill",
        BTTest = "BTTest",
        ChangeCL = "ChangeCrossLevel",
        DrawCL = "DrawCrossLevel",
        ReuseSkill = "ReuseSkill",
        SetMonsterCrouch = "SetMonsterCrouch",
        GetBlackboardValue = "GetBlackboardValue",
        MonsterTimeDilation = "MonsterTimeDilation",
        ControlAllMonsterBTTickEnable = "ControlAllMonsterBTTickEnable",
        TestTriggerAbyssOnEnd="TestTriggerAbyssOnEnd",
        TestGraphTask="TestGraphTask",

        -- 属性
        ForbidDamage = "ForbidDamage",
        ForbidPlay = "ForbidPlay",
        TestBattle = "TestBattle",
        -- NoDamage = "NoDamage",
        Attr = "GetOrSetPlayerAttr",
        WeaponAttr = "GetOrSetPlayerWeaponAttr",
        PinAttr = "PinAttr",
        MaxBullet = "MaxBullet",
        MaxMagazineBullet = "MaxMagazineBullet",
        MaxAttack = "MaxAttack",
        MaxDefence = "MaxDefence",
        MaxSp = "MaxSp",
        AddSp = "AddSp",
        MaxHp = "MaxHp",
        MaxTriggerProbability = "MaxTriggerProbability",
        SetNickname = "SetNickname",
        SetSex = "SetSex",
        AddHp = "AddHp",
        MaxES = "MaxES",
        
        -- 测试公会战排行榜数据
        TestGuildWarRanking = "TestGuildWarRanking",
        AddES = "AddES",
        God = "God",
        DefCoreGod = "DefCoreGod",
        UnlimitFire = "UnlimitFire",
        GAW = "GetAllWeapons",
        GAC = "GetAllChars",
        IsCrit = "IsCrit",
        IsFloat = "IsFloat",
        CharacterTag = "CharacterTag",
        CalcAttrOpt = "CalcAttrOpt",
        SetLockHpRate ="SetLockHpRate",
        SetLockHpValue ="SetLockHpValue",

        AddMod = "AddMod",
        DebugMod = "DebugMod",

        TestEvent = "TestEvent",
        ShowDamageDetails = "ShowDamageDetails",
        DSShowDetails = "DSShowDetails",
        ShowRealAttr = "ShowRealAttr",
        StatDamage = "StatDamage",
        -- Buff
        Buff = "Printbuff",
        BuffDebug = "BuffDebug",
        AddBuff = "AddBuff",
        RemoveBuff = 'RemoveBuff',
        AddMonsterBuff = "AddMonsterBuff",
        AddMonsterBuffDuration = "AddMonsterBuffDuration",
        RemoveMonsterBuff = 'RemoveMonsterBuff',

        -- 全局被动
        AddGP = "AddGP",
        RemoveAllGP = "RemoveAllGP",
        PrintGP = "PrintGP",

        -- 标记 
        PrintMarks = "PrintMarks",

        -- 动态刷怪点分配逻辑测试
        MSPDT = "MonsterSpawnPointDistributeLogicTest",

        --- 关卡怪物战斗相关 End--- 

        StartXibiBoss = "StartXibiBoss",
        UnlockHardBoss = "UnlockHardBoss",
        UnlockRegionTeleport = "UnlockRegionTeleport",
        UnlockRegionDelivery = "UnlockRegionDelivery",

        -- 肉鸽相关
        AddRougeLikeCurrency = "AddRougeLikeCurrency",
        GetRougeLikeCurrency = "GetRougeLikeCurrency",
        RGPassRoom ="RougeLikePassRoom",

        -- 任务
        StartQuestChain = "StartQuestChain",
        SuccQuestChain = "SuccQuestChain",
        CleanQuestChain = "CleanQuestChain",
        CleanAllQuest = "CleanAllQuest",
        StartQuest = "StartQuest",
        SuccQuest = "SuccQuest",
        FailQuest = "FailQuest",
        IsQuestChainLock = "IsQuestChainLock",
        IsQuestChainUnlock = "IsQuestChainUnlock",
        ShowUseCountSkill = "ShowUseCountSkill",
        ShowCacheUseCountSkill = "ShowCacheUseCountSkill",
        SCRQ = "SkipCurrentRunningQuest",
        PrintCurrentTaskGuideInfo = "PrintCurrentTaskGuideInfo",
        SetTaskGuidePointDebugMode = "SetTaskGuidePointDebugMode",
        ChangeToNewModel = "ChangeToNewModel",
        bn = "GetOrSetRangedWeaponBulletNum",
        ChangeWeapon = "ChangeWeapon",

        rct = "RandomCreateTest",

        -- Avatar RPC
        ChangeMod = "ChangeMod",
        TakeOffMod = "TakeOffMod",
        ChangeModSuit = "ChangeModSuit",
        ModLevelUp = "ModLevelUp",
        WLU = "WeaponLevelUp",
        WB = "WeaponBreak",
        CLU = "CharLevelUp",
        CGLU = "CharGradeLevelUp",
        CB = "CharBreak",
        clearmonsterdes = "ClearFirstMonsterRecords",
        UnlockMonsterGallery = "UnlockMonsterGallery",
        clearmonguide = "ClearMonGuide",
        RL = "ResetLoc",
        CCCV = "ChangeCharCornerVisibility",
        UWGL = "UpWeaponGradeLevel",
        ChangeWeaponColor = "ChangeWeaponColor",
        CleanWeaponColor = "CleanWeaponColor",
        ForgeRPCTest = "ForgeRPCTest",


        --技能
        NOCD = "NoCDForSkill",
        UpdateMonCd = "UpdateMonCd",
        FireDanmaku = "FireDanmaku",
        PrintSkill = "PrintCurrentSkillID",
        PrintMonsterSkill = "PrintMonsterSkill",

        -- 受击 
        CTN = "CutToughnessValue",
        PlayLightHit = "PlayLightHit",
        PlayLightHitRanged = "PlayLightHitRanged",
        PlayHeavyHit = "PlayHeavyHit",
        PlayHitFly = "PlayHitFly",
        PlayHitFly_Force = "PlayHitFly_Force",


        --TakeRecorder
        TakeRecorderCapture ="TakeRecorderCapture",
        UseDungeonLevelBounds = "UseDungeonLevelBounds",
		EnemyVisionDebug = "EnemyVisionDebug",
		TargetLocDebug = "TargetLocDebug",

        -- 剧情
        TestStory = "TestStory",
        TestStory1 = "TestStory1",
        RunStory = "RunStoryline",
        StopStory = "StopStoryline",
        RunQuest = "RunQuest",
        SkipQuest = "SkipQuest",
        SuccessAllQuest = "SuccessAllQuest",
        PrintStorylineInfo = "PrintStorylineInfo",
		PrintStorylinesNeedRestartInfo = "PrintStorylinesNeedRestartInfo",
        RemoveAllImpression = "RemoveAllImpression",
        CIS = "CompleteImpressionSystem",
        PlayTalk = "PlayTalk",
        PT = "PlayTalk",
        ScanForDuplicatedTalk = "ScanForDuplicatedTalk",
        ST = "ScanForDuplicatedTalk",
        ForceSetStorySkipable = "ForceSetStorySkipable", --强制设置过场剧情可跳过
        NPCLookAtDebug = "ShowLookAtDebug",
        StartNPCLookAt = "StartLookAt",
        LookAtBySlerp = "LookAtBySlerp",
        NPCMoveTo = "NPCMoveTo",
        TestSTLNode = 'TestSTLNode',
        TIP = "TestImpression",
        FinishImpressionTalk = "FinishImpressionTalk",

        ImpressionCheckByEnumId = "ImpressionCheckByEnumId",
        ImpressionAddByEnumId = "ImpressionAddByEnumId",
        CompleteDialogueByText = "CompleteDialogueByText",

        --怪物动画工具
        MAULookAt = "MAULookAt",
        QuitMAU = "QuitMAU",
        UseSkill = "UseSkill",
        Focus = "Focus",
        SetSpeed = "SetSpeed",

        CCSpeed = "ChangeCreatureSpeed",
        ShowSkillCreature = "ShowSkillCreature",
        ShowRayCreature = "ShowRayCreature",

        AnimCacheEnableState = "AnimCacheEnableState",
        EnableOnlineAnimCache = "EnableOnlineAnimCache",
        GDTAI = "GDTAI",
        GDTEMBT = "GDTEMBT",
        GDTAnimCache = "GDTAnimCache",

        --获取指定数量的掉落物
        GetDrop = "GetDrop",

        -- 网络
        DS = "DisconnectServer",
        CS = "ConnectServer",
        LS = "ListenServer",
        NetMode = "NetMode",
        Re0 = "Reconnect",
        TestNetworkFailure = "TestNetworkFailure",
        TestCrash = "TestCrash",
        ForbidEntityMessage = "ForbidEntityMessage",

        -- QA Debug
        smgi = "ShowOrHideMonsterGuideIcon",
        CMBS="CreateMonstersBatches",
        ScanLevel = "ScanLevel",
        ShowPreloadFX = "ShowPreloadFX",
        DebugAchvUI = "DebugAchvUI",
        SpeedUp = "SpeedUp",
        EnableJetJump = "EnableJetJump",
        EnableJetRush = "EnableJetRush",
        EnableSplineMove = "EnableSplineMove",
        EnableSplatoonMove = "EnableSplatoonMove",
        PlayAllNiagaraArround = "PlayAllNiagaraArround",
        DestroyAllMonster = "DestroyAllMonster",
        DSVersion = "DSVersion",
        MGC = "ManualGC",
        sctime = "SetClientTime",
        EnableBuffMesh = "EnableBuffMesh",
        SwitchRWS = "SwitchRWS",

        pcmv ="PrintCharModVolume",
        ChangeSpeed = "ChangeSpeed",
        SetWalk = "SetWalk",
        -- Audio
        GetSceneSoundPause = "GetSceneSoundPause",
        SetBGMVolume = "SetBGMVolume",
        SetAudioListenerOpenDebug = "SetAudioListenerOpenDebug",
        SetEMPreviewMute = "SetEMPreviewMute",
        SetBGMOpenDebug = "SetBGMOpenDebug",
        PrintBGMInfo = "PrintBGMInfo",
        GetAllBusVolume = "GetAllBusVolume",
        GetAllBusPauseState = "GetAllBusPauseState",
        ReloadAllBank = "ReloadAllBank",
        SetDrawDebugEnabled = "SetDrawDebugEnabled",
        SetSoundPointCompDebugEnabled = "SetSoundPointCompDebugEnabled",
        SetSoundSplineDrawDebug = "SetSoundSplineDrawDebug",
        SetReverbDebug = "SetReverLogicOpenbDebug",
        PrintHeadPhonePlugIn = "PrintHeadPhonePlugIn",
        SetAudioManagerTestRegionId = "SetAudioManagerTestRegionId",
        SimulateBGMEnterNewRegion = "SimulateBGMEnterNewRegion",
        SetLineSoundDebug = "SetLineSoundDebug",
        SectorSoundDebug = "SectorSoundDebug",
        CircularSoundDebug = "CircularSoundDebug",
        PrintEventsMap = "PrintEventsMap",
        PrintAUAForbidTag = "PrintAUAForbidTag",
        PrintCurAuActionCount = "PrintCurAuActionCount",

        -- 机关
        MechanismStateDebug = "MechanismStateDebug",

        -- 区域-特殊任务
        StartSpecialQuest = "StartSpecialQuest",
        SuccessSpecialQuest = "SuccessSpecialQuest",
        FailerSpecialQuest = "FailerSpecialQuest",

        --区域-动态事件
        PrintDynamicEventInfo="PrintDynamicEventInfo",
        ForceStartDynQuest="ForceStartDynQuest",
        CADC = "CompleteAllDispatchCondion",

        ChangeToMaster = "ChangeToMaster",
        ChangeBackToHero = "ChangeBackToHero",
        ChangeSkinModel = "ChangeSkinModel",
        ChangeCharAcc = "ChangeCharAcc",
        ChangeWeaponAcc = "ChangeWeaponAcc",
        ActiveExplores = "ActiveExploreStaticCreator",

        -- 舆情系统
        TestRealtimeContentValidate = "TestRealtimeContentValidate",
        TestUploadChat = "TestUploadChat",
        TestUploadReport = "TestUploadReport",
        TestUploadBanLog = "TestUploadBanLog",

        -- 抽卡系统
        TestDrawGacha = "TestDrawGacha",
        ShowGachaParams = "ShowGachaParams",
        GachaSelfSelect = "GachaSelfSelect",
        TestDrawSkinGacha = "TestDrawSkinGacha",

        --系统引导
        FSG = "FinishSystemGuide",
        
        --商城系统
        PSI = "PurchaseShopItem",
        SPSUI = "ShowPurchaseShopUI",

        ---- 卸载Loading界面 -----
        UnLoadChangeUI = "UnLoadChangeUI",
       
       
        SBP = "StartBlueProduct", ---- 开始铸造
        CBP = "CompleteBlueProduct", ---- 完成制造

        -- 时间
        CTime = "ShowClientTime",
        STime = "ShowServerTime",

        -- 辅助功能
        StartBattle = "StartBattle",

		--副本关卡拆分测试
		LoadSmallObj = "LoadSmallObjects",

        SetPlayerDilation = "SetPlayerDilation",

        Mem = "Mem",
        CleanLuaTable = "CleanLuaTable",

        -- Avatar 相关
        ShowAvatarStatus = "ShowAvatarStatus",
        CheckCondition = "CheckCondition",
        ServerCheckCondition = "ServerCheckCondition",

        -- 性能测试
        StatMonster = "StatMonster",
        StatMonsterMem = "StatMonsterMem",
        StatFX = "StatFX",
        StatLevel = "StatLevel",
        StatRecordLevel = "StatRecordLevel",
        GenerateStripMesh = "GenerateStripMesh", --创建网格面数测试
        UWAUpLoad = "UWAUpLoad", --UWA上传

        -- 通用弹窗
        PreviewPopup = "PreviewPopup",
        ShowPopup = "ShowPopup",

        ShowRecoverUI="ShowRecoverUI",

        -- 通用角色/武器获得
        TestGetCharWeapon = "TestGetCharWeapon",

        -- 通用复选框
        DisableCheckBox = "DisableCheckBox",
        EnableCheckBox = "EnableCheckBox",
        --触控
        TouchSpeedPitch = "TouchSpeedPitch",
        TouchSpeedYaw = "TouchSpeedYaw",
        TouchLimitPitch = "TouchLimitPitch",
        TouchLimitYaw = "TouchLimitYaw",

        SetInvincible = "SetInvincible",

        ClearPhantoms = "ClearPhantoms",
        KillAllPhantoms = "KillAllPhantoms",

        -- 条件模块
        CompleteCondition = "CompleteCondition",
        CompleteSystemCondition = "CompleteSystemCondition",
        CompleteSystemConditionWithoutGuide = "CompleteSystemConditionWithoutGuide",

        -- 系统解锁
        ShowSystemUnlock = 'ShowSystemUnlock',
        FakeUIUnlockConditionComplete = 'FakeUIUnlockConditionComplete',
        MockAllSystemCondition = 'MockAllSystemCondition',
        MockSystemCondition  = 'MockSystemCondition',
        UnLockAllDungeonSelectLevels = 'UnLockAllDungeonSelectLevels',
        UnLockAllDungeonLevels = 'UnLockAllDungeonLevels',
        

        -- QTE
        PlaySequence = 'PlaySequence',

        FSMDebug = 'FSMDebug',

        --系统引导
        SystemGuideSwitch = 'SystemGuideSwitch',

        --完成所有系统引导
        SuccessAllSystemGuide = 'SuccessAllSystemGuide',

        --导航
        SwitchCullModifier = "SwitchCullModifier",

        I18Time = "I18Time",
        
        --教学手册相关
        GBFS = "GuideBookFinishSomething",
        EchoAvatar = "EchoAvatar",
        PrintGuideBook = "PrintGuideBook",
        GuideBookGetReward = "GuideBookGetReward",

        --清空本地缓存
        ResetEMCache= "ResetEMCache",

        TestWarningToast = "TestWarningToast",
        TestCombineWarningToast = "TestCombineWarningToast",
        StartAutoTest = "StartAutoTest",
        ABTS = "AutoBattleTestServer",
        ABTC = "AutoBattleTestClient",
        StopABT = "StopAutoBattleTest",

        ChangeBuffLastTime = "ChangeBuffLastTime",
        ReduceBuffLayer = "ReduceBuffLayer",

        TestTrackingQuest = "TestTrackingQuest",

        --肉鸽
        EnterRougeLike = "EnterRougeLike",
        UpgradeAward="UpgradeAward",
        RogueShopTest="RogueShopTest",
        RougeDetailsTest = "RougeDetailsTest",
        ShowRougeManual = "ShowRougeManual",
        ShowGetItemsTip="ShowGetItemsTip",
        ShowUpgradeTip="ShowUpgradeTip",
		
		-- 战斗背包
		DisableBattleWheel = "DisableBattleWheel",
		EnableBattleWheel = "EnableBattleWheel",
        FillBattleWheel = "FillBattleWheel",
        PrintBattleWheel = "PrintBattleWheel",
        
        --战斗宠物
        AddPet = "AddPet",
        RemovePet = "RemovePet",
        AddPetAffix = "AddPetAffix",
        RemovePetAffix = "RemovePetAffix",
		
		-- 打印所有联机玩家
		PrintPlayers = "PrintPlayers",
		-- 打印所有队友(包含魅影)
		PrintTeammates = "PrintTeammates",
		
        ShowCountdownToast = "ShowCountdownToast",
        AddCountdownTime = "AddCountdownTime",

        --聊天
        EnableChatCheck = "EnableChatCheck", ---聊天敏感词检测开关
        ChatToOtherPlayer = "ChatToOtherPlayer",
		
		-- 强制玩家立刻执行技能
		ForceUseSkill = "ForceUseSkill",
        
        -- CommonHudReward奖励测试
        ShowHudReward = "ShowHudReward",

        ---组队Test
        CInitTeamTest = "CInitTeamTest",
        CAddTeammateTest = "CAddTeammateTest",
        CDelTeammateTest = "CDelTeammateTest",
        CTeamInviteTest = "CTeamInviteTest",
        CTestTeamBloodBar = "CTestTeamBloodBar",
        CTestDelBloodBar = "CTestDelBloodBar",

        -- 特效性能测试
        FXTest = "FXPriorityTest",
        FXTestChar = "FXPriorityTest_Char",
        FXTestOne = "FXPriorityTest_One",
        PrintAllFXPath = "PrintAllFXPath",
        ClearFXTest = "ClearFXTest",
        LevelFXTest = "LevelFXTest",

        -- 预加载资源路径测试
        PrintAllAssetPath = "PrintAllAssetPath",
        PrintAllPreloadCacheInfo = "PrintAllPreloadCacheInfo",

        -- 调试器开关
        UseDebug = "UseDebug",
        obj = "obj",
        EnableShowLevelLoadingInfo = "EnableShowLevelLoadingInfo",

        -- 动效性能测试
        PUA = "PlayUMGAnimation",
        UAT = "UMGAnimationsTime",
		cdk = "GMUseCDK",
        EMPWA = "EMPlayWidgetAnimation",
        HideAllUI = "HideAllUI",

        -- UnitBudget
        UseMobileUnitBudget = "UseMobileUnitBudget",
        DebugTickUnitBudget = "DebugTickUnitBudget",

        --怪物AIDebug
        OpenMonsterDebug = "OpenMonsterDebug",

		-- 技能先行
		EnableSkillPrediction = "EnableSkillPrediction",
        ForceSimPredictionFailed = "ForceSimPredictionFailed",
		PrintPredictionDebugInfo = "PrintPredictionDebugInfo",

        CrashTest = "CrashTest",
        -- 手柄按键预设

        SetGamepad = "SetGamepad",

        -- 战斗历史
        History = "PrintBattleHistory",

        -- 牵引
        TractedMonsterToPlayer = "TractedMonsterToPlayer",
        TestTractedPlayer = "TestTractedPlayer",

        -- 钓鱼
        SkipAngling = "SkipAngling",

        -- SequenceStateRecorder
        SSRPlaySequence = "SSRPlaySequence",

        NewDeputeTest = "NewDeputeTest",

        -- 推理小游戏
        DetectiveMinigame = "DetectiveMinigame",
        --Flow
        StartFlow="StartFlow",
        StopFlow="StopFlow",

        -- 核桃
        OpenWalnutRewardDialog = "OpenWalnutRewardDialog",

        -- 阵容预设
        CreateSquad = "CreateSquad",

        QuitGame = "QuitGame",

        SyncTest = "SyncTest",

        --月卡
        GM_SkipMonthCardPay = "GM_SkipMonthCardPay",

        GetWorldRegionEidByCreatorId = "GetWorldRegionEidByCreatorId",
        GetWorldRegionEidByManualItemId = "GetWorldRegionEidByManualItemId",
        GetWorldRegionEidByRandomRuleId = "GetWorldRegionEidByRandomRuleId",
        ShowUI = "ShowUI",
        
        -- 道具效果
        EnablePropEffect = "EnablePropEffect",

        -- 录制显示Sequence时间用
        ShowSequenceTime = "ShowSequenceTime",

        -- 通用活动结算
        CommonActivitySettlement = "CommonActivitySettlement",

        -- 活动副本
        EnterPaotai = "EnterPaotai", -- 进入炮台副本
        EnterEventDungeon = "EnterEventDungeon", -- 进入活动副本

        -- 打印CloudArtevelbound坐标
        PrintLevelbound = "PrintLevelbound",

        --场景
        ShowScenarioPerformanceData = "ShowScenarioPerformanceData",
        ShowScenarioDataOnTick = "ShowScenarioDataOnTick",

		--ShowBattleError
		ShowBattleError = "ShowBattleError",
        ShowUIError = "ShowUIError",

        --个人主页
        ShowPersonalInfoPage = "ShowPersonalInfoPage",

        --内存修改测试
        VerifyArrayTest = "VerifyArrayTest",
        FloatVerifyArrayTest = "FloatVerifyArrayTest",
        EnableRegionPlayerRandomRoleId = "EnableRegionPlayerRandomRoleId",
        EnableRegionPlayerOnlyShowHeadUI = "EnableRegionPlayerOnlyShowHeadUI",
        URB = "UseResourceBattle",
        AFD = "ApplyAFDTransform",
        CAFD = "CancelAFDTransform",
        NPCSubSystemOnline = "NPCSubSystemOnline",
        NPCSubSystemChangeId = "NPCSubSystemChangeOnlineRegionId",
        ReadyForRegonOnline = "ReadyForRegonOnline",
        RandomChar = "RandomChar",

        --全局版本号
        ShowGlobalVersion = "ShowGlobalVersion",
        HideGlobalVersion = "HideGlobalVersion",

        --区域联机动作UI
        OpenOnlineActionView = "OpenOnlineActionView",
        
        --模拟切换手机HUD布局
        SwitchMobileHUDLayout = "SwitchMobileHUDLayout",

        --打开多人挑战界面
        OpenMultiChallenge = "OpenMultiChallenge",

        ChangeDSMonsterFramingNodeConfig = "ChangeDSMonsterFramingNodeConfig",

        --隐藏特定UI
        HideStoryUI = "HideStoryUI",
        HideEntertainmentUI = "HideEntertainmentUI",

        -- 自选礼包
        GetAllOptPackages = "GetAllOptPackages",

        Eids = "ShowEids",

        -- 按距离显隐Actor
        ActorSnapShot = "ActorSnapShot",

        -- 自走棋相关
        CreateAutoChessMonster = "CreateAutoChessMonster",
        RemoveAutoChessMonster = "RemoveAutoChessMonster",
        AutoChessUI = "OpenAutoChessUI",
        AutoChessBuffDetail = "OpenAutoChessBuffDetailUI",
        AutoChessDeputeMonsterInfo = "OpenAutoChessDeputeMonsterInfoUI",

        --声望相关测试
        OpenFameMainUI = "OpenFameMainUI",
        ReputationExpAdd = "ReputationExpAdd",

        -- 搜打撤相关
        CreateNewTreasureItemToPocket = "CreateNewTreasureItemToPocket",
        SoloTreasureBag = "SoloTreasureBag",
        OpenUIAndAddSoloTreaureScore = "OpenUIAndAddSoloTreaureScore",
        OpenUIMainSoloTreasure = "OpenUIMainSoloTreasure",
        -- 回归活动相关
        OpenReturnWelcomeBanner = "OpenReturnWelcomeBanner",

        -- 二级密码相关
        OpenSecPassWordUI = "OpenSecPassWordUI",
        VerifySecPassword = "VerifySecPassword",

        ShowWaterMark = "ShowWaterMark",

        -- 导出预加载数据
        ExportAllAssetPathFromModelData = "ExportAllAssetPathFromModelData",
        
        -- 切换对象LOD
        SetLOD = "SetLOD",

        -- 导出指定的头发动画
        ExportHairAnimSequence = "ExportHairAnimSequence",

        -- 播放指定路径的动画
        TestPlay = "TestPlay",
        
		-- 额外打印一些引擎gameplay相关Insights
        GP = "GP",
		-- 生成NPC位置(测试)
        GenerateNpcLocation = "GenerateNpcLocation",    }
end

function GM_Command:OpenUIMainSoloTreasure(Mode)
    local EventId = 103014
    UIManager(self):LoadUINew("ActivitySoloTreasureMain", EventId, Mode)
end


function GM_Command:OpenAutoChessDeputeMonsterInfoUI(MissionID)
    local MissionID = tonumber(MissionID)
    UIManager(self):LoadUINew("AutoChessDeputeMonsterInfoUI", MissionID)
end

function GM_Command:OpenAutoChessBuffDetailUI(MissionID)
    local MissionID = tonumber(MissionID)
    UIManager(self):LoadUINew("AutoChessBuffDetail", MissionID)
end

function GM_Command:OpenUIAndAddSoloTreaureScore(AddScore)
    local UI = UIManager(GWorld.GameInstance):LoadUINew("SoloTreasureCountDownTip")
    local RealScore = tonumber(AddScore)
    if type(RealScore) == "number" then
        EventManager:FireEvent(EventID.OnUpdateGameScore, RealScore)
    end
end

function GM_Command:LGCTEST(UUid)
    --local UI = UIManager(GWorld.GameInstance):LoadUINew("CharSkinPreview", {Type = "ShopRecommend", SkinSeriesId = "BP_03"})
    
    local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
    local TreasureDatas = InventoryController:GetTreasureDatasById(10111)
    local MainWidget = InventoryController.MainWidget
    MainWidget:BlockAllUIInput(false)
    
    -- local Avatar = GWorld:GetAvatar()
    -- UUid = tonumber(UUid)
    -- Avatar:TestCreateAndOpenMechanismId(UUid)
end

function GM_Command:GMUseCDK(CDK)
    local Avatar = self:GetClientAvatar()
	Avatar:UseCDK(CDK)
end

function GM_Command:ShowScenarioDataOnTick()
    local GameInstance = GWorld.GameInstance
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    UE4.UKismetSystemLibrary.ExecuteConsoleCommand(Player,"stat unit",nil)
    --UE4.UKismetSystemLibrary.ExecuteConsoleCommand(Player,"stat memory",nil)
    UE4.UKismetSystemLibrary.ExecuteConsoleCommand(Player,"DumpMeshLODData",nil)
    if Player:IsExistTimer("DataOnTick") then
        Player:RemoveTimer("DataOnTick")
        URuntimeCommonFunctionLibrary.RemoveOnScreenDebugMessage(28)
    else
        Player:AddTimer(0.5, self.ShowScenarioPerformanceData, true, 0.1, "DataOnTick", true)
        self:ShowScenarioPerformanceData()
    end
end

function GM_Command:ShowScenarioPerformanceData()
    -- UE4.UKismetSystemLibrary.ExecuteConsoleCommand(Player,"stat unit",nil)
    -- UE4.UKismetSystemLibrary.ExecuteConsoleCommand(Player,"stat memory",nil)

    local GameInstance = GWorld.GameInstance
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local LODDataArr = URuntimeCommonFunctionLibrary.GetStaticMeshTrianglesTopTen(Player:GetWorld()):ToTable()

    local BigSpace = string.rep(" ", 100)
    local SmallSpace = string.rep(" ", 10)
    local Message = ""..BigSpace
    for Index, StaticMeshLODData in ipairs(LODDataArr) do
        Message = Message.."StaticMeshName: "..StaticMeshLODData.ActorName..SmallSpace.."StaticMeshNum: "..StaticMeshLODData.ActorNum
        Message = Message.."\n"..BigSpace
        --Message = Message.." LOD"..StaticMeshLODData.LODNum.."(Triangles: "..StaticMeshLODData.NumTriangles[1]..", Vertices: "..StaticMeshLODData.NumVertices[1]..")"..SmallSpace
        for i = 1, StaticMeshLODData.LODNum do
            if StaticMeshLODData.CurLODIndex and StaticMeshLODData.CurLODIndex >= 0 and StaticMeshLODData.CurLODIndex + 1 == i then
                Message = Message.."->->-> LOD"..(i-1).."(Triangles: "..(StaticMeshLODData.NumTriangles[i]/StaticMeshLODData.ActorNum)..", Vertices: "..(StaticMeshLODData.NumVertices[i]/StaticMeshLODData.ActorNum)..")".."<-<-<-"..SmallSpace
            else
                Message = Message.." LOD"..(i-1).."(Triangles: "..(StaticMeshLODData.NumTriangles[i]/StaticMeshLODData.ActorNum)..", Vertices: "..(StaticMeshLODData.NumVertices[i]/StaticMeshLODData.ActorNum)..")"..SmallSpace
            end
        end
        Message = Message.."\n\n"..BigSpace
    end
    URuntimeCommonFunctionLibrary.AddOnScreenDebugMessage(28,3600,FColor(255,255,255),Message,false,FVector2D(1,1))

end

function GM_Command:UseDebug(bOn)
    if bOn == nil then bOn = "1" end
    local LuaPanda = require("LuaPanda")
    if bOn == "1" then
        LuaPanda.reGetSock()
        LuaPanda.start()
    else
        LuaPanda.stopAttach()
    end
end

function GM_Command:CTestDelBloodBar(Eid)
    ---@type BP_UIManagerComponent_C
    local UIMgr = UIManager(self:GetGameInstance())
    --local Eid =  UGameplayStatics.GetPlayerCharacter(self:GetGameInstance(),0).Eid
    Eid = tonumber(Eid)
    ---@type WBP_Battle_P_C
    local BattleView = UIMgr:GetUIObj("BattleMain")
    BattleView.VB_PlayerBar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    BattleView:RemoveBattleTeamBloodBar(Eid)
end

function GM_Command:CTestTeamBloodBar(Eid)
    Eid = tonumber(Eid)
    ---@type BP_UIManagerComponent_C
    local UIMgr = UIManager(self:GetGameInstance())
    --local Eid =  UGameplayStatics.GetPlayerCharacter(self:GetGameInstance(),0).Eid
    ---@type WBP_Battle_P_C
    local BattleView = UIMgr:GetUIObj("BattleMain")
    BattleView.VB_PlayerBar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    BattleView:AddBattleTeamBloodBar(Eid,true, true)
end



function GM_Command:CTeamInviteTest()
    local InviteInfo = {
        Uid = 23333,
        HeadIconId = TeamController:GetAvatar().HeadIconId,
        IsOnline = true,
        Nickname = "test2",
        Level = 3,
    }
    TeamController:RecvTeamBeInvited(InviteInfo)
end

function GM_Command:CInitTeamTest()
    local FakeTeam = {
        TeamId = 2, 
        LeaderId = TeamController:GetAvatar().Uid,
        Hostnum = 101,
        Members = {
            {
                Uid = 23333,
                HeadIconId = TeamController:GetAvatar().HeadIconId,
                IsOnline = true,
                Nickname = "test2",
            },
            TeamController:GetAvatar(),
            {
                Uid = 23335,
                HeadIconId = TeamController:GetAvatar().HeadIconId,
                IsOnline = true,
                Nickname = "test2",
            },
            {
                Uid = 23336,
                HeadIconId = TeamController:GetAvatar().HeadIconId,
                IsOnline = true,
                Nickname = "test2",
            },
        }
    }
    TeamController:RecvTeamOnInit(FakeTeam)
end

function GM_Command:CAddTeammateTest(Uid)
    local FakeMember = {
        Uid = tonumber(Uid),
        HeadIconId = TeamController:GetAvatar().HeadIconId,
        IsOnline = true,
        Nickname = "test2",
    }
    TeamController:RecvTeamOnAddPlayer(FakeMember)
end

function GM_Command:CDelTeammateTest(Uid)
    if Uid~='0' then
    TeamController:RecvTeamOnDelPlayer(tonumber(Uid), CommonConst.LeaveTeamReason.Willing)
    else
    TeamController:RecvTeamOnDelPlayer(23333, CommonConst.LeaveTeamReason.Willing)
    local FakeMember = {
        Uid = 23336,
        HeadIconId = TeamController:GetAvatar().HeadIconId,
        IsOnline = true,
        Nickname = "test2",
    }
    TeamController:RecvTeamOnAddPlayer(FakeMember)
    TeamController:RecvTeamOnDelPlayer(23335, CommonConst.LeaveTeamReason.Willing)
    FakeMember = {
        Uid = 23337,
        HeadIconId = TeamController:GetAvatar().HeadIconId,
        IsOnline = true,
        Nickname = "test2",
    }
    TeamController:RecvTeamOnAddPlayer(FakeMember)
    FakeMember = {
        Uid = 23338,
        HeadIconId = TeamController:GetAvatar().HeadIconId,
        IsOnline = true,
        Nickname = "test2",
        TeamController:RecvTeamOnAddPlayer(FakeMember)
    }
    end
end

function GM_Command:EnableChatCheck(bOn)
    bOn = tonumber(bOn)
    ChatCommon.IgnoreSensitiveCheck = (bOn ==0)
end

function GM_Command:ChatToOtherPlayer(Uid, Count, Content)
    if not Count then Count = 60 end
    for i=1, tonumber(Count) do
        if not Content then Content = "2333" end
        GWorld:GetAvatar():ChatToPlayer(tonumber(Uid), Content..i)
    end
end

function GM_Command:ResetEMCache()
    local EMCache = require "EMCache.EMCache"
    EMCache:Reset()
end


function GM_Command:ExecuteGM(WorldContextObject, FunctionName, Args, IsClient, IsDedicatedServer)
    if IsDedicatedServer then
        self:DedicatedServerGM(WorldContextObject, FunctionName, Args)
    elseif IsClient then
        self:ClientGM(WorldContextObject, FunctionName, Args)
    else
        self:ServerGM(FunctionName, Args)
    end
end


function GM_Command:DedicatedServerGM(WorldContextObject, FunctionName, Args)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(WorldContextObject)
    assert(GameInstance, "找不到GameInstance")
    self.Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local _Battle = Battle(self.Player)

    assert(_Battle, "没找到Battle")
    assert(not IsStandAlone(self.Player), "不能在单机情况下使用DSGM")

    local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
    local Result = EffectResults.Result()
    Result:Add(FunctionName, Args)
    Result = Result:ToEffectStruct()
    self.Player:GMServerBattleCommand(Result)
end


function GM_Command:ClientGM(WorldContextObject, FunctionName, Args)
    -- 兼容DS
    local function SplitArgs(_Args)
        if type(_Args) == "string" then
            local ReturnArgs = {}
            for Arg in string.gmatch(_Args, "%S+") do
                table.insert(ReturnArgs, Arg)
            end
            return ReturnArgs
        end
        return _Args
    end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(WorldContextObject) or GWorld.GameInstance
    assert(GameInstance, "找不到GameInstance")
    self.Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)

    local Result = nil
    -- 如果是GM整合指令
    local GMIntegrationData = DataMgr.GMIntegration[FunctionName]
    if GMIntegrationData then
        for _, Command in pairs(GMIntegrationData.GMCommands) do
            UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GameInstance, Command)
        end
    else
        local RealFunctionName = self.Commands[string.upper(FunctionName)]
        if RealFunctionName then
            local Func = self[RealFunctionName]
            assert(Func, '错误的函数名:' .. RealFunctionName)

            FunctionName = RealFunctionName
            if Args then
                FunctionName = FunctionName .. ' ' .. tostring(Args)
            end
            Result = Func(self, table.unpack(SplitArgs(Args)))
        else
            if Args then
                FunctionName = FunctionName .. ' ' .. Args
            end
            local LocalFunctionStr =
            [[
                local A = self.Avatar
                local P = self.Player
                local W = self.Player:GetCurrentWeapon()
                local B = Battle(self.Player)
                local GameMode = UE4.UGameplayStatics.GetGameMode(P)
                local GameState = UE4.UGameplayStatics.GetGameState(P)
                local GameInstance = UE4.UGameplayStatics.GetGameInstance(P)
                local UIManager = GameInstance:GetGameUIManager()
                local E = function(eid)
                    return B:GetEntity(eid)
                end
                local ObjectId = function (obj_str)
                    return CommonUtils.Str2ObjId("ObjectId(\""..obj_str.."\")")
                end
            ]]

            local ExecStr = "return function(self) " .. LocalFunctionStr .. "return " .. FunctionName .. " end"
            local Func = load(ExecStr)
            if not Func then
                ExecStr = "return function(self) " .. LocalFunctionStr .. FunctionName .. " end"
                Func = load(ExecStr)
            end
            assert(Func, '错误的代码:' .. ExecStr)
            local RealFunc = Func()
            Result = RealFunc(self)
        end
    end
    if Result == nil then
        Result = 'nil'
    end
    PrintTable({FunctionName = FunctionName, Result = Result}, 1, 'GM指令执行结果')
end


function GM_Command:ServerGM(FunctionName, Args)
    DebugPrint(string.format("ServerGM, %s, %s", FunctionName, Args))
    local args = {}
    for arg in string.gmatch(Args, "%S+") do
        table.insert(args, arg)
    end
    self:Server_Command(FunctionName, args)
end


function GM_Command:ServerBattleCommand(FunctionName, ...)
    local battle = Battle(self.Player)

    assert(battle, "没找到battle")
    local func = battle['GM_'..FunctionName]
    --print(_G.LogTag,func)
    assert(func, "没找到函数:GM_"..FunctionName)

    local Args = ...
    if type(Args) ~= 'table' then
        Args = {...}
    end

    if IsStandAlone(self.Player) then
        func(battle, table.unpack(Args))
        return
    end

    local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
    local Result = EffectResults.Result()
    -- PrintTable({Pack=Args,type=type(...)},3)
    Result:Add(FunctionName, Args)
    Result = Result:ToEffectStruct()
    self.Player:GMServerBattleCommand(Result)
end

-- 支持传参

function GM_Command:DedicatedServerCommand(Func, ...)
    local MyPlayerController = UE4.UGameplayStatics.GetPlayerController(self:GetGameInstance(), 0)
    assert(MyPlayerController, "非法PlayerController")

    local func = MyPlayerController['GM_'..Func]
    assert(func, "没找到函数:GM_"..Func)

    local Args = { ... }
    local msgpack = require "msgpack_core"
    local ArgsStr = msgpack.pack(Args)
    local ArgsMessage = FMessage()
    ArgsMessage:SetBytes(ArgsStr, #ArgsStr)

    if IsStandAlone(self.Player) then
        func(MyPlayerController, ArgsMessage)
        return
    end

    MyPlayerController:GMDedicatedServerCommand(Func, ArgsMessage)
end


function GM_Command:Server_Command(FunctionName, Args)
    -- 服务端GM指令
    local Avatar = self:GetClientAvatar()
    if Avatar == nil then
        ScreenPrint("can not find avatar")
        return
    end
    local function callback(Ret, ...)
        DebugPrint("ServerGM Callback", FunctionName, Ret)
        local t = {...}
        DebugPrintTable(t, 5)
        if Ret == ErrorCode.RET_FAIL then
            return
        end
        if FunctionName == "scl" then
            self:ClientGM("attr", "Level " .. table.unpack(Args))
        end
        EventManager:FireEvent(EventID.ServerGMSucceed, FunctionName)
    end
    Avatar:CallServer("DoGmCommand", callback, FunctionName, table.unpack(Args))
end


function GM_Command:ReloadAll(...)
    -- 客户端脚本热更
    -- example: gm r
    UUnLuaFunctionLibrary.HotReload()
end


function GM_Command:Hotfix(...)
    -- 客户端测试hotfix
    -- example: gm hotfix
    local HotfixData = require "Datas.HotfixData"
    assert(HotfixData.index, "需要填写HotfixData.index")
    assert(HotfixData.script, "需要填写HotfixData.script")
    local UnLuaHotReload = require "UnLuaHotReload"
    require("HotFix").ExecHotFix(HotfixData.index, HotfixData.script, true)
    GWorld.HotfixDataIndex = HotfixData.index
    if not IsStandAlone(self.Player) then
        self:ServerBattleCommand("Hotfix")
    end
end

function GM_Command:GetAvatar(...)
    -- 获取avatar信息
	-- example: gm ga
    -- example: gm ga Chars
    local Args = {...}
    local length = #Args
    local avatar = self:GetClientAvatar()
    if not avatar then
        return
    end
    local client_attr = avatar:GetClientAttrs()
    local result = client_attr
    if length > 0 then
        for i = 1, length do
            result = result[Args[i]]
        end
    end

    PrintTable({result = result}, 10)
end

function GM_Command:GetServerAvatar(...)
    -- 获取avatar信息
	-- example: gm gsa
    -- example: gm gsa Chars
    local avatar = self:GetClientAvatar()
    if not avatar then
        return
    end
    avatar:GetServerAvatar(...)
end

function GM_Command:LowQuality()
    local GameInstance = self:GetGameInstance()
    assert(GameInstance, "找不到GameInstance")
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local Controller = Player:GetController()
    Controller:ShowFlags("DynamicShadows", false)
    Controller:ShowFlags("VolumetricFog", false)
    Controller:ShowFlags("PointLights", false)
    Controller:ShowFlags("InstancedFoliage", false)
    Controller:ShowFlags("InstancedGrass", false)
    --Player:LowQuality()
    --Controller:ShowFlags("DeferredLighting", false)
    Player.CharacterFashion:HideHairCapture()
end

--[[
    ShowFlag Name
        DynamicShadows
        GlobalIllumination
        InstancedFoliage
        InstancedGrass
        PointLights
        ReflectionEnvironment
        SkyLighting
        VolumetricFog  
]]--
function GM_Command:ShowFlag(Name, bShow)
    -- body
    local GameInstance = self:GetGameInstance()
    assert(GameInstance, "找不到GameInstance")
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local Controller = Player:GetController()
    if bShow == "1" then
        Controller:ShowFlags(Name, true)
    elseif bShow == "0" then
        Controller:ShowFlags(Name, false)
    end
end

function GM_Command:QualityLevel(Level)
    ---@type BP_EMGameInstance_C
    local GameInstance = self:GetGameInstance()
    UEMGameInstance.SetOverallScalabilityLevel(Level and tonumber(Level) or -1)
    Const.ScalabilityUpdateTime = Const.ScalabilityUpdateTime + 1
end

function GM_Command:OpenUI(UIName, ...)
    -- 打开界面（界面名字后面可以跟需要传入的参数）
    -- example: gm OpenUI BagMain
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    local SystemUIConfig = DataMgr.SystemUI[UIName]
    if (SystemUIConfig ~= nil) then
        return UIManager:LoadUINew(UIName, ...)
    end
    local UIConfig = UIConst.AllUIConfig[UIName]
    if (UIConfig == nil) then
        ScreenPrint(string.format("Not find UIConfig Which Name is %s", UIName))
        return
    end
    return UIManager:LoadUI(UIConfig.resource, UIName, UIConfig.zorder)
end

function GM_Command:HideUI(UIName, IsShow, HideTag)
    -- 隐藏/显示界面（界面名字、需要显示IsShow为1、显示/隐藏Tag）
    -- example: gm HideUI BagMain
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    local UIWidget = UIManager:GetUIObj(UIName, true)
    if (UIWidget == nil) then
        ScreenPrint(string.format("Not find UIWidget Which Name is %s", UIName))
        return
    end
    if (IsShow == "1") then
        if (type(UIWidget.Show) == "function") then
            UIWidget:Show(HideTag)
        else
            UIWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    else
        if (type(UIWidget.Hide) == "function") then
            UIWidget:Hide(HideTag)
        else
            UIWidget:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function GM_Command:CloseUI(UIName)
    -- 关闭
    -- example: gm CloseUI BagMain
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    local UIWidget = UIManager:GetUIObj(UIName)
    if (UIWidget == nil) then
        ScreenPrint(string.format("Not find UIWidget Which Name is %s", UIName))
        return
    end
    if (type(UIWidget.Close) == "function") then
        UIWidget:Close()
    end
end

function GM_Command:ShowGuideUI(GuideId)
    -- 打开图文引导界面
    -- example: gm ShowGuideUI GuideId
    local GameInstance = self:GetGameInstance()
    UE4.UUIStateAsyncActionBase.ShowGuideUI(GameInstance, tonumber(GuideId))
end

function GM_Command:CreateNpc(UnitId, Num, Level)
    -- 放Npc
    -- example: gm CN 81101 1 0
    self:ServerBattleCommand('CreateNpc', UnitId, Num, Level, "StaticCreator")
end

function GM_Command:CreatePet(UnitId, Num, Level)
    -- 放Pet
    -- example: gm CPet 409 1 0
    self:ServerBattleCommand('CreatePet', UnitId, Num, Level, "StaticCreator")
end

function GM_Command:CreateMonster(UnitId, Num, Level, ForcedLOD)
    -- 放怪
    -- example: gm CM 8001001 2 50
    self:ServerBattleCommand('CreateMonster', self.Player.Eid, UnitId, Num, Level, "StaticCreator", ForcedLOD)
end

function GM_Command:CreateMonsterSpawnMonster(UnitId, Num, Level)
    -- 放怪
    -- example: gm CMSM 8001001 2 50
    self:ServerBattleCommand('CreateMonster', self.Player.Eid, UnitId, Num, Level, "MonsterSpawn")
end

function GM_Command:CreateTestMonster(UnitId, Num)
    -- 放固定测试怪
    -- example: gm CM 8001001 2

    self:ServerBattleCommand('CreateTestMonster', self.Player.Eid, UnitId, Num)
end

function GM_Command:GuideBookFinishSomething(Type,Id)
    local Avatar = GWorld:GetAvatar()
	print(_G.LogTag, "GMGuideBookFinishSomething", Type,Id)
    if tonumber(Id) ~= nil then
        Id = tonumber(Id)
    end
	Avatar:GuideBookFinishSomething(Type,Id)
end
function GM_Command:EchoAvatar(Index)
    local Avatar = GWorld:GetAvatar()
    Avatar:EchoAvatar(Index)
end

function GM_Command:CreatePhantom(RoleId, Num, BTIndex, Level, WeaponId, SkillPhantomLevel, SkillPhantomGrade, SkipInitWaitCheck)
    -- 创建一个己方阵营的魅影，传入RoleId、数量、行为树编号、等级、指定武器ID
    -- example: gm CP
    -- example: gm CP 1101
    -- example: gm CP 1101 2
    -- example: gm CP 1101 2 2
    -- example: gm CP 1101 2 2 10
    -- example: gm CP 1101 2 2 10 20603

    if not RoleId or RoleId == 0 then
        RoleId = self.Player.CurrentRoleId
    end
    if SkipInitWaitCheck and SkipInitWaitCheck == "0" then
        SkipInitWaitCheck = false
    else
        SkipInitWaitCheck = true
    end
    if WeaponId and (not DataMgr.Weapon[tonumber(WeaponId)]) then
        DebugPrint(string.format("武器表中不存在该武器ID:%s", tostring(WeaponId)))
        return
    end
    if not SkillPhantomLevel or not SkillPhantomGrade then 
        self:ServerBattleCommand('CreatePhantom', self.Player.Eid, RoleId, Num, BTIndex,Level, false, false, WeaponId)
        return
    else
        Const.DefaultPhantomSkillLevel = tonumber(SkillPhantomLevel)
        Const.DefaultPhantomSkillGrade = tonumber(SkillPhantomGrade)
        self:ServerBattleCommand('CreatePhantom', self.Player.Eid, RoleId, Num, BTIndex,Level, SkipInitWaitCheck, SkipInitWaitCheck, WeaponId)
    end
    Const.DefaultPhantomSkillLevel = 1
    Const.DefaultPhantomSkillGrade = 0
end

function GM_Command:ClearPhantoms()
    local Avatar = GWorld:GetAvatar()
    self:ServerBattleCommand('ClearPhantoms', self.Player.Eid)
end

function GM_Command:KillAllPhantoms()
    self:ServerBattleCommand('KillAllPhantoms')
end

function GM_Command:CreateMechanismSummon(UnitId, Num)
    -- 创建一个召唤物，传入UnitId、数量
    -- example: gm CMS 1
    -- example: gm CMS 1 2

    if not UnitId or UnitId == 0 then
        ScreenPrint(string.format("CreateMechanismSummon Error,UnitId:%s", tostring(UnitId)))
        return
    end
    self:ServerBattleCommand('CreateMechanismSummon', self.Player.Eid, UnitId, Num)
end


function GM_Command:KillMonster(Eid)
    -- 杀怪
    -- example: gm km eid

    self:ServerBattleCommand('KillMonster', self.Player.Eid, Eid)
end

function GM_Command:RecoverySelf()
    -- 复活自己
    -- example: gm Recovery

    self:ServerBattleCommand('RecoverySelf', self.Player.Eid)
end

function GM_Command:RecoverPlayer(TargetEid, IsBegin, OverrideSpeed)
    -- 复活别人
    -- example: gm RecoverPlayer
    self:ServerBattleCommand('RecoverPlayer', self.Player.Eid, TargetEid, IsBegin, OverrideSpeed)
end

function GM_Command:HideMonsterCapsule(IsEnable)
    -- 隐藏全部怪物的胶囊体组件
    -- example: gm HMC true
    local NewHidden = false
    if IsEnable ~=nil and string.lower(IsEnable) =="true" then
        NewHidden = true
    end
    local Entities = Battle(self.Player):GetAllEntities()
    for eid, ent in pairs(Entities) do
        if ent and ent.IsMonster and ent:IsMonster() then
            ent.CapsuleComponent:SetHiddenInGame(NewHidden,false)
        end
    end
    ScreenPrint(string.format("HideMonsterCapsule %s", NewHidden))
end

function GM_Command:HideMonster(IsEnable)
    -- 隐藏全部怪物的胶囊体组件
    -- example: gm HMC true
    local NewHidden = false
    if IsEnable ~= nil and string.lower(IsEnable) == "true" then
        NewHidden = true
    end
    local Entities = Battle(self.Player):GetAllEntities()
    for eid, ent in pairs(Entities) do
        if ent and ent.IsMonster and ent:IsMonster() then
            ent:SetActorHideTag("GMHideMonster", NewHidden)
        end
    end
end

function GM_Command:StartQuestChain(QuestChainId)
    -- 开始任务链，执行该任务链的Storyline
    -- example: gm StartQuestChain 100101
    if not QuestChainId then
        ScreenPrint(string.format("QuestChainId %s is invalid", QuestChainId))
        return
    end
    QuestChainId = tonumber(QuestChainId)
    local avatar = GWorld:GetAvatar()
    if avatar then
        avatar:GMStartQuestChain(QuestChainId)
    end
end

function GM_Command:FallAttackPoint(ActorName)
    -- 下落攻击指定位置， 无参数则关闭
    -- example: gm FallAttackPoint BP_FallAttackPoint
    local GameInstance = self:GetGameInstance()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local FallAttackObject = PlayerCharacter:GetOrAddFallAttackObject()
    if ActorName == nil then 
        FallAttackObject.bFallAttackPoint = false
        FallAttackObject.FallAttackPoint = FVector(0, 0, 0)
        ScreenPrint(string.format("FallAttackPoint is closed"))
        return 
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    local TargetPoint = GameState:GetTargetPoint(ActorName)
    if not TargetPoint then 
        ScreenPrint(string.format("FallAttackPoint Setting Failed", ActorName))
        return 
    end
    if TargetPoint.IsActive then 
        FallAttackObject.bFallAttackPoint = true
        FallAttackObject.FallAttackPoint = TargetPoint:K2_GetActorLocation()
        print('FallAttackPoint is open at', FallAttackObject.FallAttackPoint)
    end
    
end

function GM_Command:SwitchKawaiiDebug(Enabled)
    -- example: gm SwitchKawaiiDebug 0/1
    if not self.Player then 
        return 
    end

    if not self.Player.PlayerAnimInstance then 
        return
    end
    Enabled = tonumber(Enabled)
    Enabled = Enabled == 1
    self.Player.PlayerAnimInstance.ArtDebugSwitch = Enabled
end

function GM_Command:FallAttackPointPos(X, Y, Z)
    -- 下落攻击指定位置， 无参数则关闭
    -- example: gm FallAttackPoint 0 0 0
    local GameInstance = self:GetGameInstance()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local FallAttackObject = PlayerCharacter:GetOrAddFallAttackObject()
    if X == nil and Y == nil and Z == nil then 
        FallAttackObject.bFallAttackPoint = false
        FallAttackObject.FallAttackPoint = FVector(0, 0, 0)
        ScreenPrint(string.format("FallAttackPoint is closed"))
        return 
    end
    if Y == nil then 
        Y = "0"
    end
    if Z == nil then 
        Z = "0"
    end
    print('FallAttackPoint is open at', X, Y, Z)
    X = tonumber(X)
    Y = tonumber(Y)
    Z = tonumber(Z)
    FallAttackObject.bFallAttackPoint = true
    FallAttackObject.FallAttackPoint = FVector(X, Y, Z)
    print('FallAttackPoint is open at', FallAttackObject.FallAttackPoint)
end

function GM_Command:SuccQuestChain(QuestChainId)
    -- 完成任务链
    -- example: gm SuccQuestChain 100101
    if not QuestChainId then
        ScreenPrint(string.format("QuestChainId %s is invalid", QuestChainId))
        return
    end
    QuestChainId = tonumber(QuestChainId)
    local avatar = GWorld:GetAvatar()
    if avatar then
        avatar:GMSuccQuestChain(QuestChainId)
    end
    self:StopStoryline(QuestChainId)
end

function GM_Command:CleanQuestChain(QuestChainId)
    if not QuestChainId then
        return
    end

    QuestChainId = tonumber(QuestChainId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GMCleanQuestChain(QuestChainId)
    end
    self:StopStoryline(QuestChainId)
end

function GM_Command:CleanAllQuest()
    -- 清除所有任务存盘信息
    -- example: gm CleanAllQuest
    local avatar = GWorld:GetAvatar()
    avatar:GMCleanAllQuest()
end

function GM_Command:ChangeToNewModel(RoleId)
    -- 切换角色模型
    -- example: gm ChangeToNewModel 1101
    if not RoleId then
        return
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        ScreenPrint("连接服务器情况下，请在军械库更换角色")
        return
    end

    RoleId = tonumber(RoleId)
    if self.Player.ChangeRole then
        self.Player:ChangeRole(RoleId)
    end
end

function GM_Command:ChangeWeapon(WeaponId)
    -- 切换角色武器
    -- example: gm ChangeWeapon 10101
    if not WeaponId then
        ScreenPrint("需要传入武器编号才可以进行武器更换哦~")
        return
    end
    if self.Player then
        self.Player:ChangeToNewWeapon(tonumber(WeaponId))
        EventManager:FireEvent(EventID.OnSwitchWeapon)
    end
end

function GM_Command:GetOrSetRangedWeaponBulletNum( BulletNum )
     -- 查询/修改角色远程武器的当前的子弹数量
     -- 查询example: gm bn
     -- 修改example: gm bn 1
    if ( BulletNum == nil ) then
        ScreenPrint(string.format("当前远程武器剩余子弹数量: %s", self.Player.RangedWeapon:GetAttr("BulletNum")))
    else
        BulletNum = tonumber(BulletNum)
        self.Player.RangedWeapon:SetAttr("BulletNum", BulletNum)
    end
 end

function GM_Command:ForbidDamage()
    -- 禁战斗伤害
    -- example: gm ForbidDamage
    local Current = false
    if self.Player then
        Current = require("EMLuaConst").bForbidDamage
    end
    self:ServerBattleCommand('ForbidDamage', not Current)
end

function GM_Command:ForbidPlay()
    -- 禁战斗表现
    -- example: gm ForbidPlay
    local Current = false
    if self.Player then
        Current = require("EMLuaConst").bForbidPlay
    end
    self:ServerBattleCommand('ForbidPlay', not Current)
end

function GM_Command:TestBattle(Eid)
    -- 测试代码
    -- example: gm TestBattle
    self:ServerBattleCommand('TestBattle', Eid)
end

-- function GM_Command:NoDamage()
--     -- (切换)没有伤害/恢复有伤害
--     -- example: gm NoDamage
--     local _Battle = Battle(self.Player)
--     if _Battle.SavedApplyDamage then
--         _Battle.ApplyDamage = _Battle.SavedApplyDamage
--         _Battle.ApplyHeal = _Battle.SavedApplyHeal
--     else
--         _Battle.SavedApplyDamage = _Battle.ApplyDamage
--         _Battle.SavedApplyHeal = _Battle.ApplyHeal
--         _Battle.ApplyDamage = EmptyFunction
--         _Battle.ApplyHeal = EmptyFunction
--     end
-- end

function GM_Command:GetOrSetPlayerAttr(AttrName, Value)
    -- 查询/修改玩家的属性
    -- 查询 example: gm attr Hp
    -- 修改 example: gm attr Hp 100
    if not AttrName then
        ScreenPrint(string.format("至少需要传入属性名才可进行查询操作"))
    else
        self:ServerBattleCommand('GetOrSetPlayerAttr', self.Player.Eid, AttrName, Value)
    end
end

function GM_Command:GetOrSetPlayerWeaponAttr(WeaponId, AttrName, Value)
    -- 查询/修改玩家武器的属性
    -- 查询 example: gm WeaponAttr 10101 ATK
    -- 修改 example: gm WeaponAttr 10101 ATK 100
    if not WeaponId or not AttrName then
        ScreenPrint(string.format("至少需要传入武器编号和属性名才可进行查询操作"))
    else
        self:ServerBattleCommand('GetOrSetPlayerWeaponAttr', self.Player.Eid, WeaponId, AttrName, Value)
    end
end

function GM_Command:RandomCreateTest( RandomId, test_count )
    -- 随机刷新点概率测试
    -- example: gm rct 1 100000

    local RandomId = RandomId or 1
    local test_count = test_count or 1000000
    local Result = {}
    local UnitInfo = {}
    local WeightSum = 0
    local UnitInfoWeight = {}
    for _, Info in pairs(DataMgr.RandomCreator[RandomId]["RandomInfos"]) do
        UnitInfo[Info.UnitId] = 0
        UnitInfoWeight[Info.UnitId] = Info.Weight
        WeightSum = WeightSum + Info.Weight
    end

    local function randUnit( totalWeight )
        for UnitId, Weight in pairs(UnitInfoWeight) do
            local RandomNumber = math.random(1,totalWeight)
            if(RandomNumber<=Weight) then
                return UnitId
            else
                totalWeight = totalWeight - Weight
            end
        end
    end

    for i=1, test_count do
        local UnitId = randUnit(WeightSum)
        if ( Result[UnitId] == nil ) then
            rawset(Result, UnitId, 1)
        else
            local cur_count = rawget(Result, UnitId)
            cur_count = cur_count + 1
            rawset(Result, UnitId, cur_count)
        end
    end

    for UnitId, count in pairs(Result) do
        rawset(Result, UnitId, count / test_count)
    end
    PrintTable(Result)

end

function GM_Command:MaxBullet()
    -- 无限子弹
    -- example: gm MaxBullet

    self:ServerBattleCommand('MaxBullet', self.Player.Eid)
    Battle(self.Player):GM_MaxBullet(self.Player.Eid)
end

function GM_Command:MaxMagazineBullet()
    -- 无限装填子弹
    -- example: gm MaxMagazineBullet

    self:ServerBattleCommand('MaxMagazineBullet', self.Player.Eid)
end

function GM_Command:MaxAttack()
    -- 无限攻击
    -- example: gm MaxAttack

    self:ServerBattleCommand('MaxAttack', self.Player.Eid)
end

function GM_Command:MaxDefence()
    -- 无限防御
    -- example: gm MaxDefence

    self:ServerBattleCommand('MaxDefence', self.Player.Eid)
end

function GM_Command:MaxSp()
    -- 无限能量
    -- example: gm MaxSp

    self:ServerBattleCommand('MaxSp', self.Player.Eid)
end

function GM_Command:AddSp(Value)
    -- 增加能量
    -- example: gm AddSp 10

    self:ServerBattleCommand('AddSp', self.Player.Eid, tonumber(Value))
end

function GM_Command:MaxHp()
    -- 无限生命
    -- example: gm MaxHp

    self:ServerBattleCommand('MaxHp', self.Player.Eid)
end

function GM_Command:AddHp(Value)
    -- 增加生命
    -- example: gm AddHp 10

    self:ServerBattleCommand('AddHp', self.Player.Eid, tonumber(Value))
end

function GM_Command:MaxES()
    -- 无限护盾
    -- example: gm MaxES

    self:ServerBattleCommand('MaxES', self.Player.Eid)
end

function GM_Command:AddES(Value)
    -- 增加护盾
    -- example: gm AddES 10

    self:ServerBattleCommand('AddES', self.Player.Eid, tonumber(Value))
end

function GM_Command:God()
    -- 神(无限弹药，无限能量，无限防御，不会过热，必杀)
    -- example: gm God

    self:MaxBullet()
    self:MaxAttack()
    self:MaxDefence()
    self:MaxSp()
    self:MaxHp()
    self:MaxES()
    self:NoCDForSkill()
    self:MaxTriggerProbability()
end

function GM_Command:MaxTriggerProbability()
    if Battle(self.Player).IsFullTriggerProbability then
        Battle(self.Player).IsFullTriggerProbability = false
    else
        Battle(self.Player).IsFullTriggerProbability = true
    end
end

function GM_Command:AddMod(ModId, ModLevel, ApplicationType)
    -- 给战斗内的角色/武器装一个指定等级的Mod,只增加属性和被动，1=角色，2=近战武器，3=远程武器, 4=显赫武器
    -- example: gm AddMod 11001 0 1
    if (not ModLevel) then
        ModLevel = 0 --没有提供ModLevel默认0级
    end
    if (not ApplicationType) then
        ApplicationType = 1 --不填默认给角色
    end
    ModId = tonumber(ModId)
    assert(DataMgr.Mod[ModId], "找不到编号为【"..tostring(ModId).."】的Mod")
    ApplicationType = tonumber(ApplicationType)
    assert(ApplicationType >= 1 and ApplicationType <= 4, "请填写1~4之间的Type,1=角色，2=近战武器，3=远程武器, 4=显赫武器")
    
    self:ServerBattleCommand('AddMod',  tonumber(ModId), self.Player.Eid, ModLevel, ApplicationType)
end



function GM_Command:DebugMod(bOn)
    bOn = tonumber(bOn)
    ModCommon.DebugMode = (bOn ==1)
end

function GM_Command:DefCoreGod()
    -- 已激活的 防御核心/挖掘机/推车 神(最高血量，最高护盾，最高防御)
    -- example: gm God
    local GameState = UE.UGameplayStatics.GetGameState(self.Player)
    if not GameState then return end
    local DefCoreEid = GameState.DefBaseMap:Keys():ToTable()[1]
    self:ServerBattleCommand('MaxHp', DefCoreEid)
    self:ServerBattleCommand('MaxDefence', DefCoreEid)
    self:ServerBattleCommand('MaxES', DefCoreEid)

    -- local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    -- for Eid, DefenceCore in pairs(GameMode.EMGameState.DefBaseMap) do
    --     self:ServerBattleCommand('MaxDefence', Eid)
    --     self:ServerBattleCommand('MaxHp', Eid)
    --     self:ServerBattleCommand('MaxES', Eid)
    -- end
end

function GM_Command:UnlimitFire()
    -- 无限制射击
    -- gm UnlimitFire

    self:MaxBullet()
    self:MaxMagazineBullet()
end

function GM_Command:NoCDForSkill()
    -- 角色技能CD无冷却
    -- example: gm NOCD
    for SkillId, Skill in pairs(self.Player.Skills) do
        Skill:ResetSkillCd()
    end
    Battle(self.Player):GM_NoCDForSkill(self.Player.Eid)
    self:ServerBattleCommand('NoCDForSkill', self.Player.Eid)
end

function GM_Command:UpdateMonCd()
    -- 修改怪物技能CD
    -- example: gm UpdateMonCd
    Battle(self.Player):GM_UpdateMonSkillCd()
    self:ServerBattleCommand('UpdateMonSkillCd')
end

function GM_Command:FireDanmaku(DanmakuTemplateId, Duration)
    -- 发射弹幕，传入弹幕模板编号，持续时间
    -- example: gm FireDanmaku 1 10
    DanmakuTemplateId = tonumber(DanmakuTemplateId)
    Duration = tonumber(Duration)
    assert(DataMgr.DanmakuTemplate[DanmakuTemplateId], "弹幕模板编号不存在")
    self:ServerBattleCommand('FireDanmaku', self.Player.Eid, DanmakuTemplateId, Duration, "")
end

function GM_Command:MonsterMaxHp()
    -- 存在的怪物无限生命
    -- example: gm MonsterMaxHp

    self:ServerBattleCommand('MonsterMaxHp')
end

function GM_Command:DebugMonsterSpawn()
    -- 关闭/开启动态刷怪的各种条件过滤
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    GameMode.DebugMonsterSpawn = not GameMode.DebugMonsterSpawn
end

function GM_Command:DebugPrintMonsterSpawn()
    -- 关闭/开启动态刷怪的各种条件过滤
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    GameMode.DebugPrintMonsterSpawn = not GameMode.DebugPrintMonsterSpawn
end


function GM_Command:GuideAllMonster()
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    for i,j in pairs(GameMode.EMGameState.MonsterMap) do
        if IsValid(j) and not j:IsDead() then
            GameMode.EMGameState:AddGuideEid(i)
        end
    end
end

----- 打印关卡debug相关的关键信息 begin --------------------
function GM_Command:PrintLevelDebugInfo()
    -- 打印关卡debug相关的关键信息
    -- example: gm PrintLevelDebugInfo
    local FinalMsgTable = {}
    local LongSpace = "================="
    local ShortSpace = "====="
    if IsStandAlone(GWorld.GameInstance) then
        table.insert(FinalMsgTable, LongSpace.." PrintLevelDebugInfo "..LongSpace.."\n")
        table.insert(FinalMsgTable, ShortSpace.." PrintGameStateInfo "..ShortSpace.."\n")
        self:FillGameStateInfo(FinalMsgTable)

        table.insert(FinalMsgTable, ShortSpace.." PrintGameModeInfo "..ShortSpace.."\n")
        self:FillGameModeInfo(FinalMsgTable)
        
        table.insert(FinalMsgTable, ShortSpace.." PrintPlayerInfo "..ShortSpace.."\n")
        self:FillPlayerInfo(FinalMsgTable)

        table.insert(FinalMsgTable, LongSpace..LongSpace..LongSpace.."\n")
    else
        self:DedicatedServerCommand("PrintLevelDebugInfo")

        table.insert(FinalMsgTable, LongSpace.." PrintLevelDebugInfo  Client "..LongSpace.."\n")
        table.insert(FinalMsgTable, ShortSpace.." PrintGameStateInfo Client "..ShortSpace.."\n")
        self:FillGameStateInfo(FinalMsgTable)

        table.insert(FinalMsgTable, ShortSpace.." PrintPlayerInfo Client "..ShortSpace.."\n")
        self:FillPlayerInfo(FinalMsgTable)

        table.insert(FinalMsgTable, LongSpace..LongSpace..LongSpace.."\n")
    end
    local FinalMsg = table.concat(FinalMsgTable)
    DebugPrint(FinalMsg)
    UUIFunctionLibrary.ClipboardCopy(FinalMsg)
end

function GM_Command:FillGameStateInfo(FinalMsgTable)
    local GameState = UE.UGameplayStatics.GetGameState(self.Player)

    table.insert(FinalMsgTable, "DungeonId\t"..tostring(GameState.DungeonId).."\n")
    table.insert(FinalMsgTable, "GameModeType\t"..GameState.GameModeType.."\n")
    table.insert(FinalMsgTable, "GameModeState\t"..EGameModeState:GetNameByValue(GameState.GameModeState).."\n")
    table.insert(FinalMsgTable, "DungeonUIState\t"..EDungeonUIState:GetNameByValue(GameState.DungeonUIState).."\n")
    table.insert(FinalMsgTable, "GameModeLevel\t"..tostring(GameState.GameModeLevel).."\n")
    table.insert(FinalMsgTable, "DungeonProgress\t"..tostring(GameState.DungeonProgress).."\n")
    table.insert(FinalMsgTable, "InDungeon\t"..tostring(GameState:IsInDungeon()).."\n")
    table.insert(FinalMsgTable, "InCommonAlert\t"..tostring(GameState.InCommonAlert).."\n")

    local EventString = ""
    for i = 1, GameState.DungeonEvent:Num() do
        local Event = GameState.DungeonEvent:GetValueByIdx(i-1)
        EventString = EventString..Event..", "
    end
    table.insert(FinalMsgTable, "DungeonEvent\t"..EventString.."\n")

    local GuideEidString = ""
    for i = 1, GameState.GuideEids.Items:Num() do
        local Eid = GameState.GuideEids.Items:GetRef(i).IntProperty
        GuideEidString = GuideEidString..Eid..", "
    end
    table.insert(FinalMsgTable, "GuideEids\t"..GuideEidString.."\n")

    local PlayerState = self.Player.PlayerState
    local PlayerEidString = ""
    for Index = 1, PlayerState.PlayerGuideEids.Items:Num() do
        local Eid = PlayerState.PlayerGuideEids.Items:GetRef(Index).IntProperty
        PlayerEidString = PlayerEidString..Eid..", "
    end
    table.insert(FinalMsgTable, "PlayerGuideEids\t"..PlayerEidString.."\n")
end

function GM_Command:FillGameModeInfo(FinalMsgTable)
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)

    local MonsterSpawnString = ""
    for Id, _ in pairs(GameMode.MonsterSpawnMap) do
        MonsterSpawnString = MonsterSpawnString..Id..", "
    end
    table.insert(FinalMsgTable, "MonsterSpawnMap\t"..MonsterSpawnString.."\n")
    table.insert(FinalMsgTable, "SubGameModeInfo\t LevelName\t IsActive\n")
    for LevelName, SubGameMode in pairs(GameMode.SubGameModeInfo) do
        table.insert(FinalMsgTable, "...............\t "..LevelName.."\t "..tostring(SubGameMode.IsActive).."\n")
    end
    GameMode:TriggerDungeonComponentFun("Print"..GameMode.EMGameState.GameModeType.."DebugInfo", FinalMsgTable)   -- 打印各个玩法组件的信息，以后有需要再补

    local LevelName = GameMode:GetActorLevelName(self.Player)
    table.insert(FinalMsgTable, "Player_LevelName\t"..LevelName.."\n")
end

function GM_Command:FillPlayerInfo(FinalMsgTable)
    local GameState = UE.UGameplayStatics.GetGameState(self.Player)
    if GameState:IsInDungeon() then
        try{
            exec= function()
                self:FillScanLevelInfo(FinalMsgTable)
            end,
        }
    end
    local PlayerLocation = self.Player:K2_GetActorLocation()
    table.insert(FinalMsgTable, "Player Location XYZ \t"..PlayerLocation.X.." "..PlayerLocation.Y.." "..PlayerLocation.Z.."\n")
    local FrameRate = 1 / UE4.UGameplayStatics.GetWorldDeltaSeconds(self.Player)
    table.insert(FinalMsgTable, "FrameRate \t"..tostring(FrameRate).."\n")
    local PlayerState = self.Player.PlayerState
    local PlayerPing = PlayerState:GetPlayerPing()
    table.insert(FinalMsgTable, "PlayerPing \t"..tostring(PlayerPing).."\n")
    local VersionText = UE.AHotUpdateGameMode.GetTotalVersionNumber()
    if VersionText == "" then VersionText = "编辑器状态，未获取到版本号" end
    table.insert(FinalMsgTable, "Game Version \t"..VersionText.."\n")
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Hostnum = Avatar.Hostnum
        table.insert(FinalMsgTable, "Avatar Hostnum \t"..tostring(Hostnum).."\n")
    end
end

function GM_Command:FillScanLevelInfo(FinalMsgTable)
    local Level_shortname = UE4.URuntimeCommonFunctionLibrary.GetLevelLoadJsonName(self.Player)
    local JsonLoads = function(shortname)
        local pro_path = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
        local path=pro_path..'Script/Datas/Houdini_data/'..shortname .. '.json'
        local info = UE4.URuntimeCommonFunctionLibrary.LoadFile(path)
        local json= require("rapidjson")
        local res = json.decode(info)
        return res
    end
    local level_ids = self.Player.CurrentLevelId
    --local LevelInfo = string.format("当前玩家进的拼接关卡: %s", Level_shortname)
    table.insert(FinalMsgTable, "当前玩家进的拼接关卡 \t"..Level_shortname.."\n")
    local LevelData = JsonLoads(Level_shortname)
    for _, point in pairs(LevelData.points) do
        for i=1,level_ids:Length() do
            local cur_id = level_ids:Get(i)
            if tostring(point.id) == cur_id then
                local cur_artLevel = point.art_path
                if cur_artLevel == '' then
                    cur_artLevel = string.gsub(point.struct, "Data_Design", "Data_Art", 1)
                end
                --LevelInfo = LevelInfo .. string.format("，所在的美术关卡是: %s， 关卡id是： %s", cur_artLevel, cur_id)
                table.insert(FinalMsgTable, "所在的美术关卡 \t"..cur_artLevel.."\t关卡id\t"..cur_id.."\n")
            end
        end
    end
    return
end

function GM_Command:PrintPlayerInfoOnScreen()
    local ct={}
    Battle(GWorld.GameInstance):FillBattleLog(ct)
    local Message="---------------玩家信息-------------\n"
    for _, value in ipairs(ct) do
        Message=Message..value
    end

    local AllPlayer={}
    if IsDedicatedServer(GWorld.GameInstance) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
        AllPlayer = GameMode:GetAllPlayer()
    else
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        table.insert(AllPlayer,Player)
    end
    local GameState = UE.UGameplayStatics.GetGameState(GWorld.GameInstance)
    for _, Player in pairs(AllPlayer) do
        if GameState:IsInDungeon() then
           --Message=Message..GMFunctionLibrary.ExecConsoleCommand(GWorld.GameInstance,"gm ScanLevel")..'\n'
        end
        local PlayerLocation = Player:K2_GetActorLocation()
        Message=Message.."玩家位置"..tostring(PlayerLocation)..'\n'
        local FrameRate = 1 / UE4.UGameplayStatics.GetWorldDeltaSeconds(Player)
        Message=Message.."帧率"..FrameRate..'\n'
        local PlayerState = Player.PlayerState
        local PlayerPing = PlayerState:GetPlayerPing()
        Message=Message.."延迟".. PlayerPing..'\n'
    end
    URuntimeCommonFunctionLibrary.AddOnScreenDebugMessage(-1,5,FColor(255,255,255),Message,false,FVector2D(1,1))
    DebugPrint(Message)
end

function GM_Command:PrintGameModeInfoOnScreen()
    local Message="-------GameModeInfo----------\n"
     Message=Message.."环境：联机"
    if IsStandAlone(GWorld.GameInstance) then
        Message= Message.."环境：单机\n"
    end
    local GameState = UE.UGameplayStatics.GetGameState(GWorld.GameInstance)

    Message=Message.."DungeonId: "..GameState.DungeonId..'\n'
    Message=Message.."GameModeType: "..GameState.GameModeType..'\n'
    Message=Message.."GameModeState: ".. EGameModeState:GetNameByValue(GameState.GameModeState)..'\n'
    Message=Message.."DungeonUIState: ".. EDungeonUIState:GetNameByValue(GameState.DungeonUIState)..'\n'
    Message=Message.."GameModeLevel: "..GameState.GameModeLevel..'\n'
    Message=Message.."DungeonProgress: "..GameState.DungeonProgress..'\n'
    Message=Message.."InDungeon: "..tostring(GameState:IsInDungeon())..'\n'
    Message=Message.."InCommonAlert: "..tostring(GameState.InCommonAlert)..'\n'

    local EventString = ""
    for i = 1, GameState.DungeonEvent:Num() do
        local Event = GameState.DungeonEvent:GetValueByIdx(i-1)
        EventString = EventString..Event..", "
    end
    Message=Message.."DungeonEvent: ".. EventString..'\n'

    -- local GuideEidString = ""
    -- for i = 1, GameState.GuideEids.Items:Num() do
    --     local Eid = GameState.GuideEids.Items:GetRef(i).IntProperty
    --     GuideEidString = GuideEidString..Eid..", "
    -- end
    -- Message=Message.."GuideEids".. GuideEidString..'\n'

    -- local PlayerState = self.Player.PlayerState
    -- local PlayerEidString = ""
    -- for Index = 1, PlayerState.PlayerGuideEids.Items:Num() do
    --     local Eid = PlayerState.PlayerGuideEids.Items:GetRef(Index).IntProperty
    --     PlayerEidString = PlayerEidString..Eid..", "
    -- end
    -- Message=Message.."PlayerGuideEids".. PlayerEidString..'\n'
    URuntimeCommonFunctionLibrary.AddOnScreenDebugMessage(-1,5,FColor(255,255,255),Message,false,FVector2D(1,1))
    DebugPrint(Message)
end
----- 打印关卡debug相关的关键信息 end --------------------

function GM_Command:RequestSnapShotInfo()
    self.Player.RPCComponent:RequestSnapShotInfo()
end

function GM_Command:RequestMonsterCacheInfo()
    self.Player.RPCComponent:RequestMonsterCacheInfo()
end

function GM_Command:RequestStaticCreatorInfo()
    self.Player.RPCComponent:RequestStaticCreatorInfo()
end

function GM_Command:PrintActorSCLoc(Eid)
    -- -- 打印Actor DS和客户端的位置旋转
    -- example: gm PrintActorSCLoc 1
    local Eid = tonumber(Eid)
    local Actor = Battle(self.Player):GetEntity(Eid)
    if not Actor then  
        return 
    end

    local ActorName = Actor:GetName()
    self.Player:AddTimer(0.1, function()
        local Loc = Actor:K2_GetActorLocation()
        local Rot = Actor:K2_GetActorRotation()
        DebugPrint("PrintActorSCLoc Actor Eid:", Eid, "Name:", ActorName," Loc:", Loc, "Rot:", Rot)
    end, true)

    self:DedicatedServerCommand("PrintActorSCLoc", Eid)
end

function GM_Command:LJLTEST(arg)
    self.Player.RPCComponent:NotifyServerStartExitDelivery()

    --self:DedicatedServerCommand("ljltest", arg)
    -- local GameState = UE4.UGameplayStatics.GetGameState(self)
    -- if arg == "1" then
    --     GameState.VoteValues:Add(1, EVoteState.Wait)
    -- elseif arg == "2" then
    --     GameState.VoteValues:Add(1, EVoteState.Exit)
    -- elseif arg == "3" then
    --     GameState.VoteValues:Add(1, EVoteState.Continue)
    -- end
    -- UE.UMapSyncHelper.SyncMap(GameState, "VoteValues")
    -- local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    -- -- GameMode:ClearGamePausedTags()
    -- -- GameMode:SetGamePaused("GameModeState", false)
    -- local array = TArray(0)
    -- array:Add(6160)
    -- array:Add(6161)
    -- GameMode:TriggerActiveStaticCreator(array)
    -- GameMode:TriggerInactiveStaticCreator(array)

    -- local Eid = tonumber(arg)
    -- local Boss = Battle(self.Player):GetEntity(Eid)
    -- self.Player:AddTimer(0.1, function()
    --     local Loc = Boss:K2_GetActorLocation()
    --     DebugPrint("ljl11111111111", Loc.X, Loc.Y, Loc.Z)
    -- end, true)

    -- if arg == "1" then
    --     local MyWidget = UIManager(self.GameInstance):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Activity/Widget/ZhiliuEvent/WBP_Activity_Jump_ZhiliuEvent_Reward.WBP_Activity_Jump_ZhiliuEvent_Reward'", true)
    --     MyWidget:InitPage(103005)
    -- elseif arg == "2" then
    --     local MyWidget = UIManager(self.GameInstance):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Activity/Widget/PreTask/WBP_Activity_PreTask_Item.WBP_Activity_PreTask_Item'", true)
    --     MyWidget:InitPage(103005)
    -- elseif arg == "3" then
    --     PageJumpUtils:JumpToTargetPageByJumpId(24)
    -- elseif arg == "4" then
    --     PageJumpUtils:JumpToTargetPageByJumpId(25)
    -- end
end

function GM_Command:YXDTEST(type)
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    GameMode:yxdtest("yxdtest")

end

function GM_Command:YLYTEST(type)
    local GameInstance = self:GetGameInstance()
    -- local UIManager = GameInstance:GetGameUIManager()
    if type == "1" then
        UIManager(GWorld.GameInstance):LoadUINew("SoloTreasureEvacuation")
        -- UIManager(GWorld.GameInstance):LoadUINew("ActivitySoloTreasureMain")
    elseif type == "2" then
        DebugPrint("yly     gm")
    end
end

function GM_Command:THYTEST(type, TaskId, Arg)
    DebugPrint("THY  THYTEST ")
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    local Avatar = GWorld:GetAvatar()
    -- if not Avatar then 
    --     DebugPrint("thy   no avatar")
    --     return 
    -- end
    if not GameMode then return end
    if type == "1" then
        GameMode:ShowTrialTask(TaskId)
    elseif type == "2" then
        Avatar:EnterCharTrial(nil, 900002, 105101011)
    elseif type == "3" then
        DebugPrint("thy    GameMode.GameState.GameModeType", GameMode.GameState.GameModeType) 
    elseif type == "4" then
        DebugPrint("thy   RoomIndex", GWorld.RougeLikeManager.RoomIndex)
        DebugPrint("thy   IsCurRougeLikeRoomClear",  GWorld.RougeLikeManager:IsCurRougeLikeRoomClear())
        DebugPrint("thy   GetCurRougeLikeRoomType",  GWorld.RougeLikeManager:GetCurRougeLikeRoomType())
    elseif type == "5" then
        DebugPrint("thy     gm",TaskId, Arg)
        local EventName = TaskId.."#"..Arg
        DebugPrint("thy     EventName", EventName)
        GameMode:PostCustomEvent(EventName)
    elseif type == "6" then
        GameMode:ResetRegionSpecialQuest()
    elseif type == "7" then
        GameMode:UpdateProgressToTarget(TaskId)
    elseif type == "8" then
        UIManager(GWorld.GameInstance):LoadUINew("RegionCoDefenceProgress")
    elseif type == "9" then
        UIManager(GWorld.GameInstance):LoadUINew("TiaoPin")
    elseif type == "10" then
        local Obj = UIManager(GWorld.GameInstance):GetUIObj("TiaoPin")
        Obj:PrintBindMessage()
    elseif type == "11" then
        --GameMode:CreateProbabilityMonster("Treasure", 9500053)
        DebugPrint("thy   IsInRegion", GameMode:IsInRegion())
    end
end

function GM_Command:ForgeRPCTest()
    local function Callback(Ret)
        DebugPrint("ForgeRPCTest, Ret is :", Ret)
        ErrorCode:Check(Ret)
    end

    local TestFunctions = {}
    local Avatar = GWorld:GetAvatar()

    table.insert(TestFunctions, function()
        DebugPrint("Tianyi@ 批量铸造测试， ProduceNum = 99999999999")
        local DraftId = 1001    -- 利刃药剂
        local SelectParam = {}
        local ProduceNum = 99999999999

        Avatar:CallServer("StartProduct", Callback, DraftId, ProduceNum, SelectParam)
    end)

    table.insert(TestFunctions, function()
        DebugPrint("Tianyi@ 批量铸造测试， ProduceNum = -1")
        local DraftId = 1001    -- 利刃药剂
        local SelectParam = {}
        local ProduceNum = -1

        Avatar:CallServer("StartProduct", Callback, DraftId, ProduceNum, SelectParam)
    end)

    table.insert(TestFunctions, function()
        DebugPrint("Tianyi@ 饰品批量铸造测试， DraftId = 340003")
        local DraftId = 340003    -- 车轮滚滚
        local SelectParam = {}
        local ProduceNum = 3

        Avatar:CallServer("StartProduct", Callback, DraftId, ProduceNum, SelectParam)
    end)

    table.insert(TestFunctions, function()
        DebugPrint("Tianyi@ 武器批量铸造测试， DraftId = 920604")
        local DraftId = 920604    -- 裂魂
        local SelectParam = {}
        local ProduceNum = 333333

        Avatar:CallServer("StartProduct", Callback, DraftId, ProduceNum, SelectParam)
    end)

    table.insert(TestFunctions, function()
        DebugPrint("Tianyi@ 武器加速铸造测试 DraftId = 920604")
        local DraftId = 920604    -- 裂魂
        Avatar:CallServer("AccelerateProduct", Callback, DraftId)
    end)

    table.insert(TestFunctions, function()
        DebugPrint("Tianyi@ 武器取消铸造测试 DraftId = 920604")
        local DraftId = 920604    -- 裂魂
        Avatar:CallServer("CancelProduct", Callback, DraftId)
    end)

    for i = 1, #TestFunctions do
       self.Player:AddTimer((i - 1) * 1.0, function()
            local TestFunction = TestFunctions[i]
            TestFunction()
        end)
    end
end

function GM_Command:JTYTEST(Value)
    PageJumpUtils:JumpToForgeCompendiumPathByDraftId(1001)
end

function GM_Command:HTYTEST(type, Id)
    if type == "1" then
        local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
        GameMode:OpenGuideIconDungeon("Mechanism", 11201)
        GameMode:OpenGuideIconDungeon("Mechanism", 10613)
    elseif type == "2" then
        local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
        GameMode:CloseGuideIconDungeon("Mechanism", 11201)
        GameMode:CloseGuideIconDungeon("Mechanism", 10613)
    elseif type == "3" then
        UIManager(self):LoadUINew("GuideBook_Tips", 1001)
    elseif type == "4" then
        local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
        local UnitIdArray = TArray(0)
        UnitIdArray:Add(-1)
        GameMode:TriggerCreateMonsterSpawn(UnitIdArray, false)
    elseif type == "PrintPlayArray" then
        local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
        local PlayerArray = GameState.PlayerArray
        for Index, PlayerState in pairs(PlayerArray) do
            DebugPrint("PLAYER ARRAY INFO: ", Index, PlayerState.Eid)
        end
    elseif type == "5" then
        local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.Player, UE4.UWorldCompositionSubSystem)
        if WorldCompositionSubSystem then
            WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", true)
            self.Player:AddTimer(0.2, function()
                WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", false)
            end, false, 0)
            self.Player:AddTimer(0.4, function()
                WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", true)
            end, false, 0)
            self.Player:AddTimer(0.6, function()
                WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", false)
            end, false, 0)
            self.Player:AddTimer(0.8, function()
                WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", true)
            end, false, 0)
            self.Player:AddTimer(1, function()
                WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", false)
            end, false, 0)
            self.Player:AddTimer(1.2, function()
                WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", true)
            end, false, 0)
            self.Player:AddTimer(1.4, function()
                WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", false)
            end, false, 0)
            -- WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("", false)
        end
    elseif type == "6" then
        local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.Player, UE4.UWorldCompositionSubSystem)
        if WorldCompositionSubSystem then
            WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", true)
        end
    elseif type == "7" then
        local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.Player, UE4.UWorldCompositionSubSystem)
        if WorldCompositionSubSystem then
            WorldCompositionSubSystem:LoadOrUnloadLevelDynamically("Prologue_Main_01_Art_Breakable", false)
        end
    end
end

function GM_Command:DungeonEventTest(oper, str)
    -- DungeonEvent 测试用GM
    -- example: gm DungeonEventTest Add A
    if not IsStandAlone(GWorld.GameInstance) then
        self:DedicatedServerCommand("DungeonEventTest", oper, str)
    else
        local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
        if (oper == "add") or (oper == "Add") then
            GameMode:AddDungeonEvent(str)
            return
        end
        if (oper == "remove") or (oper == "Remove") then
            GameMode:RemoveDungeonEvent(str)
            return
        end
    end
end

function GM_Command:Printbuff(Eid)
    -- 打印玩家当前的buff
    -- example: gm buff
    local Entity = nil 
    if not Eid then 
        Entity = self.Player        
    else 
        Eid = tonumber(Eid)
        Entity = Battle(self.Player):GetEntity(Eid)
    end

    Entity.BuffManager:DebugPrint()
end

function GM_Command:BuffDebug(Eid)
    local Entity = nil 
    if not Eid then 
        Entity = self.Player        
    else 
        Eid = tonumber(Eid)
        Entity = Battle(self.Player):GetEntity(Eid)
    end

    local Panel = UIManager(self.Player):LoadUI(UIConst.BUFFDEBUGPANEL, "BuffDebugPanel", UIConst.ZORDER_ABOVE_ALL, Entity)
    Panel:SetEntity(Entity)
end

function GM_Command:AddBuff(BuffId, LastTime, Value)
    -- 给某个对象添加buff
    -- example: gm AddBuff 101 10

    BuffId = tonumber(BuffId)
    assert(BuffId, 'BuffId要填数字')
    assert(DataMgr.Buff[BuffId], '找不到[' .. tostring(BuffId) .. ']对应的Buff')
    LastTime = tonumber(LastTime)
    assert(LastTime and (LastTime ~= 0), 'LastTime要填数字且不能为0')
    if Value then
        Value = tonumber(Value)
    end
    self:ServerBattleCommand('AddBuff', self.Player.Eid, BuffId, tonumber(LastTime), Value)
end

function GM_Command:AddGP(GlobalPassiveId, Level)
    -- 添加全局被动
    -- example: gm AddGP 101 
    GlobalPassiveId = tonumber(GlobalPassiveId)
    Level = tonumber(Level)
    Battle(self.Player):AddGlobalPassive(GlobalPassiveId, self.Player, Level)
end

function GM_Command:RemoveAllGP()
    Battle(self.Player):RemoveAllGlobalPassives()
end

function GM_Command:PrintGP()
    Battle(self.Player):PrintCurrentGlobalPassives()
end

function GM_Command:PrintMarks(Eid)
    local Entity = self.Player
    if Eid then 
        Entity = Battle(self.Player):GetEntity(tonumber(Eid))
    end

    Battle(self):PrintMarksFromTarget(Entity)
end

function GM_Command:RemoveBuff(BuffId)
    -- 移除玩家身上的某个buff
    -- example: gm RemoveBuff 101
    BuffId = tonumber(BuffId)
    assert(BuffId, 'BuffId要填数字')
    assert(DataMgr.Buff[BuffId], '找不到[' .. tostring(BuffId) .. ']对应的Buff')

    self:ServerBattleCommand('RemoveBuff', self.Player.Eid, BuffId)
end

function GM_Command:AddMonsterBuff(BuffId, Value)
    -- 给当前所有Monster对象和未来生成的Monster添加buff
    -- example: gm AddMonsterBuff 101 10
    self:AddMonsterBuffDuration(BuffId, -1, Value)
end

function GM_Command:AddMonsterBuffDuration(BuffId, LastTime, Value)
    -- 给当前所有Monster对象和未来生成的Monster添加buff
    -- example: gm AddMonsterBuff 101 10
    BuffId = tonumber(BuffId)
    assert(BuffId, 'BuffId要填数字')
    assert(DataMgr.Buff[BuffId], '找不到[' .. tostring(BuffId) .. ']对应的Buff')
    if Value then
        Value = tonumber(Value)
    end
    LastTime = tonumber(LastTime)
    self:ServerBattleCommand('AddMonsterBuff', BuffId, LastTime, Value)
end

function GM_Command:RemoveMonsterBuff(BuffId)
    -- 移除当前所有Monster对象和未来生成的Monster身上的buff
    -- example: gm RemoveMonsterBuff 101
    BuffId = tonumber(BuffId)
    assert(BuffId, 'BuffId要填数字')
    assert(DataMgr.Buff[BuffId], '找不到[' .. tostring(BuffId) .. ']对应的Buff')

    self:ServerBattleCommand('RemoveMonsterBuff', BuffId)
end

function GM_Command:StartXibiBoss()
    -- 新号序章开始西比尔boss战
    -- example: gm StartXibiBoss
    local NodeCallback = function( ... )
        self:SuccQuestChain(100102)
        self:StartQuest(10010306)
    end
    self:SuccessAllSystemGuide()
    local RegionId = 100103
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:AddRegionSkipCallback(RegionId, self, NodeCallback)
    self:SkipRegion(1, RegionId, 1)
end

function GM_Command:UnlockHardBoss(bAll)
    print(_G.LogTag, "UnlockHardBoss", bAll)
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    local function FillCondition(Info)
        local ConditionList = {}
        for _, InnerInfo in pairs(Info) do
            local Condition = InnerInfo.UnlockCondition
            if Condition then
                if type(Condition) == "table" then
                    for i=1, #Condition do
                        GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(Condition[i]))
                    end
                else
                    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(Condition))
                end
            end
        end

        return ConditionList
    end

    FillCondition(DataMgr.HardBossMain)

    if bAll then
        FillCondition(DataMgr.HardBossDifficulty)
    end

    if not Const.UnlockRegionTeleport then
        Const.UnlockRegionTeleport = true
    end

    self:CompleteSystemCondition()
    SystemGuideManager:GMEnforceFinishAllSysGuide()
end

function GM_Command:UnlockRegionTeleport(bEnabled)
    Const.UnlockRegionTeleport = bEnabled == "1"
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    local Struct = GameState.MechanismMap:FindRef("TeleportMechanism")
    if not Struct then
        return
    end
    for i, v in pairs(Struct.Array:ToTable()) do
        v:GMUnlock()
    end
end

function GM_Command:UnlockRegionDelivery(bEnabled)
    _G.UnlockRegionDelivery = bEnabled == "1"
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    local Struct = GameState.MechanismMap:FindRef("Delivery")
    if not Struct then
        return
    end
    for i, v in pairs(Struct.Array:ToTable()) do
        v:GMUnlock()
    end
end

function GM_Command:AddRougeLikeToken(Count, SeasonId)
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    local Cmd = "sgm AddRougeLikeToken "..Count
    if SeasonId then
        Cmd = Cmd.." "..SeasonId
    end
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(),Cmd)
end

function GM_Command:GetRougeLikeToken()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        print(_G.LogTag, "GetRougeLikeCurrency", Avatar:GetCurrentRougeLikeToken())
    end
end

function GM_Command:RougeLikePassRoom(Value)
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    for i, MonsterSpawn in pairs(GameMode.MonsterSpawnMap) do
        MonsterSpawn:ClearMonsterSpawnInfo()
        if IsValid(GameMode.MonsterSpawnMap:Find(MonsterSpawn.UnitSpawnId)) then
            GameMode.MonsterSpawnMap:Remove(MonsterSpawn.UnitSpawnId)
        end
        MonsterSpawn:K2_DestroyActor()
    end
    self:ServerBattleCommand('KillMonster', self.Player.Eid)
    GameMode:TriggerRougeLikeEnd(true)
end

function GM_Command:Debug()
    -- 显示或者隐藏调试线
    -- example: gm debug
    _G.DrawDebugTest = not (_G.DrawDebugTest)
    Battle(self.Player).DrawDebugTest = _G.DrawDebugTest
end

function GM_Command:ResetLoc()
    -- 玩家脱离卡死
    -- example: gm RL
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    GameMode:SetPlayerSafeLoction(self.Player.Eid)
end

function GM_Command:ChangeCharCornerVisibility(IsVisible)
    --修改当前角色角部的显隐
    -- gm CCCV false
    if IsVisible == "true" or IsVisible == "1" then
        IsVisible = true
    elseif IsVisible == "false" or IsVisible == "0" then
        IsVisible = false
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Char = Avatar.Chars[Avatar.CurrentChar]
        local CharUuid = Char.Uuid
        Avatar:ChangeCharCornerVisibility(CharUuid,IsVisible)
    end
end

function GM_Command:Tel()
	self.Player:TeleportToCloestTeleportPoint()
end

function GM_Command:UpWeaponGradeLevel(WeaponUuid,CurrentGradeLevel,Uuid1,Uuid2,Uuid3,Uuid4,Uuid5)
    --gm UWGL
    local GL = tonumber(CurrentGradeLevel)
    local Avatar = GWorld:GetAvatar()
    local Uuids = {}
    if Uuid1 then
        table.insert(Uuids,CommonUtils.Str2ObjId(Uuid1))
    end
    if Uuid2 then
        table.insert(Uuids,CommonUtils.Str2ObjId(Uuid2))
    end
    if Uuid3 then
        table.insert(Uuids,CommonUtils.Str2ObjId(Uuid3))
    end
    if Uuid4 then
        table.insert(Uuids,CommonUtils.Str2ObjId(Uuid4))
    end
    if Uuid5 then
        table.insert(Uuids,CommonUtils.Str2ObjId(Uuid5))
    end
    if Avatar then
        local Uuid = CommonUtils.Str2ObjId(WeaponUuid)
        Avatar:UpWeaponGradeLevel(Uuid,GL,Uuids)
    end
end

function GM_Command:ChangeWeaponColor(WeaponUuid,Part1,Color1,Part2,Color2,Part3,Color3,Part4,Color4)
    local Avatar = GWorld:GetAvatar()
    local NewColorWithPart = {}
    if Part1 and Color1 then
        NewColorWithPart[tonumber(Part1)] = tonumber(Color1)
    end
    if Part2 and Color2 then
        NewColorWithPart[tonumber(Part2)] = tonumber(Color2)
    end
    if Part3 and Color3 then
        NewColorWithPart[tonumber(Part3)] = tonumber(Color3)
    end
    if Part4 and Color4 then
        NewColorWithPart[tonumber(Part4)] = tonumber(Color4)
    end
    if Avatar then
        local Uuid = CommonUtils.Str2ObjId(WeaponUuid)
        Avatar:ChangeWeaponColors(Uuid,NewColorWithPart)
    end
end

function GM_Command:CleanWeaponColor(WeaponUuid)
    local Avatar = GWorld:GetAvatar()
    local NewColorWithPart = {
        [1] = -1,
        [2] = -1,
        [3] = -1,
        [4] = -1,
    }
    if Avatar then
        local Uuid = CommonUtils.Str2ObjId(WeaponUuid)
        Avatar:ChangeWeaponColors(Uuid,NewColorWithPart)
    end
end

function GM_Command:ChangeMod(Tag, Uuid, ModSuitIndex, ModSlotId, ModUuid)
    -- 替换mod
    -- example: gm ChangeMod Char uuid 1 1 uuid
    if not Tag or not Uuid or not ModSuitIndex or not ModSlotId or not ModUuid then
       return
    end

    Uuid = CommonUtils.Str2ObjId(Uuid)
    ModSuitIndex = tonumber(ModSuitIndex)
    ModSlotId = tonumber(ModSlotId)
    ModUuid = CommonUtils.Str2ObjId(ModUuid)

    local avatar = self:GetClientAvatar()
    if string.lower(Tag) == "char" then
        avatar:ChangeCharMod(nil,Uuid, ModSuitIndex, ModSlotId, ModUuid)
    elseif string.lower(Tag) == "weapon" then
        avatar:ChangeWeaponMod(nil,Uuid, ModSuitIndex, ModSlotId, ModUuid)
    end
end

function GM_Command:TakeOffMod(Tag, Uuid, ModSuitIndex, ModSlotId)
    -- 卸载mod
    -- example: gm TakeOffMod Char uuid 1 1
    if not Tag or not Uuid or not ModSuitIndex or not ModSlotId then
        return
    end

    Uuid = CommonUtils.Str2ObjId(Uuid)
    ModSuitIndex = tonumber(ModSuitIndex)
    ModSlotId = tonumber(ModSlotId)

    local avatar = self:GetClientAvatar()
    if string.lower(Tag) == "char" then
        avatar:TakeOffCharMod(nil,Uuid, ModSuitIndex, ModSlotId)
    elseif string.lower(Tag) == "weapon" then
        avatar:TakeOffWeaponMod(nil,Uuid, ModSuitIndex, ModSlotId)
    end
end

function GM_Command:ChangeModSuit(Tag, Uuid, TargetModSuitIndex)
    -- 更改Mod配置套装
    -- example: gm ChangeModSuit Char uuid 1
    if not Tag or not Uuid or not TargetModSuitIndex then
        return
    end

    Uuid = CommonUtils.Str2ObjId(Uuid)
    TargetModSuitIndex = tonumber(TargetModSuitIndex)

    local avatar = self:GetClientAvatar()
    if string.lower(Tag) == "char" then
        avatar:ChangeCharModSuit(nil,Uuid, TargetModSuitIndex)
    elseif string.lower(Tag) == "weapon" then
        avatar:ChangeWeaponModSuit(nil, Uuid, TargetModSuitIndex)
    end
end

function GM_Command:ModLevelUp(ModUuid, CurrentLevel, TargetLevel, InActive)
    -- mod升级
    -- example: gm ModLevelUp moduuid 0 1 true
    if not ModUuid or not CurrentLevel or not TargetLevel or not InActive then
        return
    end
    ModUuid = CommonUtils.Str2ObjId(ModUuid)
    CurrentLevel = tonumber(CurrentLevel)
    TargetLevel = tonumber(TargetLevel)
    InActive = InActive == "true"

    local avatar = self:GetClientAvatar()
    avatar:ModLevelUp(nil, ModUuid, CurrentLevel, TargetLevel, InActive)
end

function GM_Command:GetAllWeapons()
    --获取武器属性
    --example: gm GAW
    local avatar = self:GetClientAvatar()
    if not avatar then
        return
    end
    local Weapon = avatar.Weapons
    local result={}
    for key,value in pairs(Weapon) do
        result[CommonUtils.ObjId2Str(key)]= {value.WeaponId,value.Level,value.MaxLevel,value.EnhanceLevel}
    end
    PrintTable({result = result}, 10)
end

function GM_Command:WeaponLevelUp(WeaponUuid,CurrentLevel, TargetLevel)
    --主动升级武器
    --example: gm WLU WeaponUuid CurrentLevel TargetLevel
    if not WeaponUuid or not CurrentLevel or not TargetLevel then
        return
    end
    WeaponUuid = CommonUtils.Str2ObjId(WeaponUuid)
    CurrentLevel = tonumber(CurrentLevel)
    TargetLevel = tonumber(TargetLevel)
    local avatar = self:GetClientAvatar()
    if not avatar then
        return
    end
    avatar:WeaponLevelUp(WeaponUuid,CurrentLevel,TargetLevel)
end

function GM_Command:WeaponBreak(WeaponUuid,TargetBreakLevel)
    --主动武器突破
    --example: gm WB WeaponUuid TargetBreakLevel
    if not WeaponUuid or not TargetBreakLevel then
        return
    end
    WeaponUuid = CommonUtils.Str2ObjId(WeaponUuid)
    TargetBreakLevel = tonumber(TargetBreakLevel)
    local avatar = self:GetClientAvatar()
    if not avatar then
        return
    end
    avatar:WeaponBreakLevelUp(WeaponUuid,TargetBreakLevel)
end

function GM_Command:GetAllChars()
    --获取角色属性
    --example: gm GAC
    local avatar = self:GetClientAvatar()
    if not avatar then
        return
    end
    local Char = avatar.Chars
    local result={}
    for key,value in pairs(Char) do
        result[CommonUtils.ObjId2Str(key)]= {value.CharId,value.Level,value.MaxLevel,value.EnhanceLevel}
    end
    PrintTable({result = result}, 10)
end

function GM_Command:CharLevelUp(CharUuid,CurrentLevel, TargetLevel)
    --主动升级角色
    --example: gm CLU CharUuid CurrentLevel TargetLevel
    if not CharUuid or not CurrentLevel or not TargetLevel then
        return
    end
    CharUuid = CommonUtils.Str2ObjId(CharUuid)
    CurrentLevel = tonumber(CurrentLevel)
    TargetLevel = tonumber(TargetLevel)
    local avatar = self:GetClientAvatar()
    if not avatar then
        return
    end
    avatar:CharLevelUp(CharUuid,CurrentLevel,TargetLevel)
end

function GM_Command:CharGradeLevelUp()
    --主动升阶当前角色
    --example: gm CGLU
    local Avatar = self:GetClientAvatar()
    local Char = Avatar.Chars[Avatar.CurrentChar]
    if not Avatar then
        return
    end
    --local CharUuid = CommonUtils.Str2ObjId(Char.Uuid)
    local CharUuid = Char.Uuid
    local CurrentGradeLevel = tonumber(Char.GradeLevel)
    Avatar:UpCharGradeLevel(CharUuid,CurrentGradeLevel)
end


function GM_Command:CharBreak(CharUuid,TargetBreakLevel)
    --主动武器突破
    --example: gm CB CharUuid TargetBreakLevel
    if not CharUuid or not TargetBreakLevel then
        return
    end
    CharUuid = CommonUtils.Str2ObjId(CharUuid)
    TargetBreakLevel = tonumber(TargetBreakLevel)
    local avatar = self:GetClientAvatar()
    if not avatar then
        return
    end
    avatar:CharBreakLevelUp(CharUuid,TargetBreakLevel)
end

function GM_Command:GetMonster(...)
    -- 获取距离最近的MonsterEntity
    -- example: gm GetMonster
    local Entities = Battle(self.Player):GetAllEntities()
    local NearestMonster = nil
    local NearestDis = 9999999
    local PlayerLocation = self.Player:K2_GetActorLocation()
    for eid, ent in pairs(Entities) do
        if ent and ent.IsMonster and ent:IsMonster() then
            local EntLocation = ent:K2_GetActorLocation()
            local Dis = UE4.UKismetMathLibrary.Vector_Distance(PlayerLocation, EntLocation)
            if Dis < NearestDis then
                NearestDis = Dis
                NearestMonster = ent
            end
        end
    end
    if NearestMonster then
        self.Monster = NearestMonster
        local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
        if GameState then
            GameState.DebugMonster = NearestMonster
        end
        -- UE4.UKismetSystemLibrary.DrawDebugSphere(self.Monster, self.Monster.BornPos, 30, 16, FLinearColor(255,0,0), 1000)
        print (_G.LogTag, "Get NearestMonster, Eid:",  self.Monster.Eid)
    end
end

function GM_Command:GlobalTimeDilation(val)
    UE4.UGameplayStatics.SetGlobalTimeDilation(self.Player, tonumber(val))
end

function GM_Command:TakePhotoAddWaterMark(bEnable)
    Const.bTakePhotoAddWatermark = (tonumber(bEnable) > 0)
end

function GM_Command:MonsterTimeDilation(val)
    if self:HasTargetMonster()==false or not val then return end
    if val == 0 then
        self.Player:RemoveTimer("MonsterTimeDilationTimer", true)
        self.Monster.CustomTimeDilation = 1
    else
        self.Player:AddTimer(0.01, function()
            self.Monster.CustomTimeDilation = tonumber(val)
        end, true, 0, "MonsterTimeDilationTimer", true)
    end
end

function GM_Command:SetMonsterCrouch(val)
    if self:HasTargetMonster()==false or not val then return end
    local IsCrouch = tonumber(val) > 0 and true or false
    self:ServerBattleCommand('SetMonsterCrouch', self.Monster.Eid, IsCrouch)
end

function GM_Command:GetBlackboardValue(type, name)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    for Index, Character in pairs(GameState.MonsterMap) do
        
        local BBComponent = Character:GetOwnBlackBoardComponent()
        local BBFunction = BBComponent["GetValueAs"..type]

        if BBFunction ~= nil then
            local Result = BBFunction(BBComponent, name)
            DebugPrint("Monster Eid =", Character.Eid, ", BBValue =", Result)
            
        else DebugPrint("TypeError type =", type) end
    end
end

function GM_Command:StopAI(...)
    -- 暂停AI
    if self:HasTargetMonster()==false then return end
    self.Monster:StopBT("GM")
end

function GM_Command:StartAI(...)
    -- 开启AI
    if self:HasTargetMonster()==false then return end
    self.Monster:StartBT()
end

function GM_Command:Target(...)
    -- 设置TargetMonster的目标为玩家
    if self:HasTargetMonster()==false then return end
    self.Monster:BBSetTarget(Battle(self.Player):GetCharacter(self.Player.Eid))
end


function GM_Command:TargetAll(...)
    local ents = Battle(self.Player):GetAllEntities()
    for eid, ent in pairs(ents) do
        if ent and ent.IsMonster and ent:IsMonster() then
            ent:BBSetTarget(Battle(self.Player):GetCharacter(self.Player.Eid))
        end
    end
end

function GM_Command:MoveTo(...)
    -- TargetMonster移动到玩家位置
    if self:HasTargetMonster()==false then return end
    local AICtrl = self.Monster:GetController()
    local Movement = self.Monster:GetMovementComponent()
    Movement:SetAvoidanceEnabled(true)
    AICtrl:MoveToLocation(self.Player:K2_GetActorLocation(), 1, true, true, false, true, nil, true)
end

function GM_Command:ReuseSkill(UnitId, SkillIndex)
    self:ServerBattleCommand('ReuseSkill', UnitId, SkillIndex, self.Player.Eid)
end

function GM_Command:MonsterForceLOD(UnitId, ForceLodIndex)
    local Entities = Battle(self.Player):GetAllEntities()
    for eid, ent in pairs(Entities) do
        if ent and pairs(Entities) then
            if ent and ent.IsMonster and ent.UnitId == tonumber(UnitId) then
                ent.Mesh:SetForcedLOD(tonumber(ForceLodIndex))
            end
        end
    end
end

function GM_Command:HasTargetMonster()
    local bHas = true
    if self.Monster == nil then
        bHas = false
    end
    if Battle(self.Player):GetEntity(self.Monster.Eid) == nil then
        self.Monster = nil
        bHas = false
    end
    if bHas == false then print (_G.LogTag, "No Target Monster") end
    return bHas
end

function GM_Command:TakeRecorderCapture(Capturing)
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    local isSet= Capturing=='1'
    GMFunctionLibrary.SetTakeRecorderCapture(self.Player,isSet)
end

function GM_Command:UseDungeonLevelBounds(IsEnable)
    _G.UseDungeonLevelBounds = IsEnable=='1'
end

function GM_Command:UseMinimumLoad(IsEnable)
    _G.UseMinimumLoad = IsEnable~='0'
end

function GM_Command:GameModeEnable(IsEnable)
    -- GameMode逻辑设置是否启用
    -- example: gm GameModeEnable false
    self:GetGameInstance().IsGameModeEnable = (IsEnable ~= "false")
    DebugPrint("GM_GameMode逻辑设置是否启用", self:GetGameInstance().IsGameModeEnable)
end

function GM_Command:MoveDebug(val)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    if GameState then
        val = tonumber(val)
        if val > 0 then
            GameState.MonsterMoveDebug = true
        else
            GameState.MonsterMoveDebug = false
        end
    end
end

function GM_Command:StopMonsterSkill(val)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    if GameState then
        val = tonumber(val)
        if val > 0 then
            GameState.MonsterStopSkillDebug = true
        else
            GameState.MonsterStopSkillDebug = false
        end
    end
end

function GM_Command:BTTest(val)
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    if not GameMode then
        return
    end
    val = tonumber(val)
    if val > 0 then
        GameMode.DebugTestBT = true
    else
        GameMode.DebugTestBT = false
    end
end

function GM_Command:ChangeCrossLevel(val)
    val = tonumber(val)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    for i,v in pairs(GameState.MonsterMap) do
        local Controller  = v:GetController()
        if Controller then 
            Controller.CrossLevelEnable = (val > 0)
        end
    end
end

function GM_Command:DrawCrossLevel(val)
    val = tonumber(val)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    for i,v in pairs(GameState.MonsterMap) do
        local Controller  = v:GetController()
        if Controller then 
            Controller.DrawCrossLevel = (val > 0)
        end
    end
end

-- function GM_Command:TestStory(path, QuestId, NodeId)
--     self:RunStoryline("1-3.story")
-- end

function GM_Command:TestStory(path, QuestId, NodeId)
    self:RunStoryline("test_czc.story")
end

function GM_Command:TestStory1(path, QuestId, NodeId)
    self:RunStoryline("test_czc1.story")
end

function GM_Command:RunStoryline(path, QuestId, NodeId)
    GWorld.StoryMgr:RunStory(path, QuestId, NodeId)
end

function GM_Command:StopStoryline(QuestChainId)
    local QuestChainInfo = DataMgr.QuestChain[QuestChainId]
    if (QuestChainInfo == nil) then
        UIManager(GWorld.GameInstance):ShowError(6001)
        return
    end
    if GWorld.StoryMgr:IsRunningStoryline(QuestChainInfo.StoryPath) then
        GWorld.StoryMgr:StopStoryline(QuestChainInfo.StoryPath)
    end
end

function GM_Command:RunQuest(QuestId)
    GWorld.StoryMgr:RunQuest(tonumber(QuestId))
end

function GM_Command:SkipQuest(QuestId)
    GWorld.StoryMgr:CompleteQuest(tonumber(QuestId))
end

function GM_Command:RemoveAllImpression()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function Callback(Ret)
            self.logger.debug("ZJT_ GMRemoveAllmpressionRegionData ", Ret)
        end
        Avatar:CallServer("GMRemoveAllmpressionRegionData", Callback)
    end
end

---@Deprecated
function GM_Command:TestImpression()
    -- local Avatar = GWorld:GetAvatar()
    -- if Avatar then
    --     local RegionId = Avatar:GetSubRegionId2RegionId()
    --     local Option = "3"
    --     local StoryLineId = 100101
    --     local function CheckByEnumIdCallback(Ret)
    --         DebugPrint("ZJT_ CheckByEnumIdCallback ", Ret)
    --     end
    --     Avatar:xCallServer("ImpressionCheckByEnumId", CheckByEnumIdCallback, "169675519237213304", "169675519237213304", "OptionCheckId1", RegionId, Option, 10, true)
    --     Avatar:xCallServer("ImpressionCheckByEnumId", CheckByEnumIdCallback, "169675519237213304", "169675519237213304", "OptionCheckId1", RegionId, Option, 10, true)
    --     local function AddByEnumIdCallback(Ret)
    --         DebugPrint("ZJT_ AddByEnumIdCallback ", Ret)
    --     end
    --     Avatar:xCallServer("ImpressionAddByEnumId", AddByEnumIdCallback, "169770206824485454", "169770206824485454", "OptionPlusId1", RegionId, Option)
    --     Avatar:xCallServer("ImpressionAddByEnumId", AddByEnumIdCallback, "1704175978764175755", "1704175978764175755", "OptionPlusId1", RegionId, Option)
    --     Avatar:xCallServer("ImpressionAddByEnumId", AddByEnumIdCallback, "1704175978764175755", "1704175978764175755", "OptionPlusId1", RegionId, Option)
    --     local function CompleteCallback(Ret)
    --         DebugPrint("ZJT_ CompleteCallback ", Ret)
    --     end
    --     Avatar:CallServer("SetTalkTriggerComplete", CompleteCallback, 100112, RegionId)
    --     Avatar:CallServer("SetTalkTriggerComplete", CompleteCallback, 100112, RegionId)

    --     local function UpdateCurrentCallback(Ret)
    --         DebugPrint("ZJT_ UpdateCurrentCallback ", Ret)
    --     end
    --     Avatar:xCallServer("UpdateCurrentStoryNode", UpdateCurrentCallback, "1704961116490114362", "1704961116490114362", Option, RegionId)
    --     Avatar:xCallServer("UpdateCurrentStoryNode", UpdateCurrentCallback, "1704961116490114362", "1704961116490114362", Option, RegionId)
    --     local StoryId = "eUBEgIDM5XHpbEm9PFL9"
    --     local ImprCheckOptionEnum = "OptionCheckId1"
    --     local ImprPlusOptionEnum = "OptionPlusId1"
    -- end
end

function GM_Command:FinishImpressionTalk(TalkTriggerId)
    TalkTriggerId = tonumber(TalkTriggerId)
    local ErrorCode = ""
    local printError = function()
        DebugPrint("GM_Command:FinishImpressionTalk@", ErrorCode)
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:ShowUITip(UIConst.Tip_CommonToast, ErrorCode, 3)
    end
    if not TalkTriggerId then
        ErrorCode = "TalkTriggerId为空"
        printError()
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        ErrorCode = "Avatar不存在"
        printError()
        return
    end
    if Avatar.ImpressionTalkTriggers[TalkTriggerId] then
        ErrorCode = "对应的对话已完成，无法重复完成"
        printError()
        return
    end
    Avatar:SetTalkTriggerComplete_New(TalkTriggerId, {self, function()
        DebugPrint("Log: Impression Talk Finished", TalkTriggerId)
    end})
end

---@param DialogueChain     table   当前对话先前的所有存储节点的DialogueId
---@param CurrentDialogueId number  当前印象选项的DialogueId
---@param TalkTriggerId     number  当前印象对话的TalkTriggerId
---@param RegionId          number  当前印象对话的所在区域Id
function GM_Command:ImpressionCheckByEnumId(DialogueChain, CurrentDialogueId, TalkTriggerId, RegionId)
    local Avatar = GWorld:GetAvatar()
    local ErrorCode = ""
    local printError = function()
        DebugPrint("GM_Command:ImpressionCheckByEnumId@", ErrorCode)
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:ShowUITip(UIConst.Tip_CommonToast, ErrorCode, 3)
    end
    if not Avatar then
        ErrorCode = "Avatar不存在"
        printError()
    end
    DialogueChain = DialogueChain or {741148230}
    CurrentDialogueId = CurrentDialogueId or 7411482301
    TalkTriggerId = TalkTriggerId or 74114730
    RegionId = RegionId or 1011
    if Avatar:IsImpressionCheckSuccess(CurrentDialogueId) then
        ErrorCode = "对应的选项已被记录，无法重复选择"
        printError()
    end
    Avatar:ImpressionCheckByEnumId_New(DialogueChain, CurrentDialogueId, TalkTriggerId, RegionId)
end

---@param DialogueChain     table   当前对话先前的所有存储节点的DialogueId
---@param CurrentDialogueId number  当前印象选项的DialogueId
function GM_Command:ImpressionAddByEnumId(DialogueChain, CurrentDialogueId)
    local Avatar = GWorld:GetAvatar()
    local ErrorCode = ""
    local printError = function()
        DebugPrint("GM_Command:ImpressionAddByEnumId@", ErrorCode)
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:ShowUITip(UIConst.Tip_CommonToast, ErrorCode, 3)
    end
    if not Avatar then
        ErrorCode = "Avatar不存在"
        printError()
        return
    end
    DialogueChain = DialogueChain or {741148229}
    CurrentDialogueId = CurrentDialogueId or 7411482291
    if Avatar:IsImpressionCheckSuccess(CurrentDialogueId) then
        ErrorCode = "对应的选项已被记录，无法重复选择"
        printError()
        return
    end
    Avatar:ImpressionAddByEnumId_New(DialogueChain, CurrentDialogueId)
end

function GM_Command:CompleteDialogueByText(Text)
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        DebugPrint(_G.ErrorTag, "Complete dialogue by text failed, Avatar is nil.")
        return
    end

    string.gsub(Text, "DialogueHasRead:%[(%d+)%]", function(DialogueId)
        DialogueId = tonumber(DialogueId)
        if (DataMgr.DialogueId2WikiTextIds[DialogueId] == nil) then
            DebugPrint(_G.ErrorTag, string.format("Complete dialogue by text failed, dialogue id %d not exist in dialogue id to wiki text ids data.", DialogueId))
            return
        end
        Avatar:CompletedDialogue(DialogueId)
    end)
end

function GM_Command:ForceSetStorySkipable(bSet)
    local TS = TalkSubsystem()
    if TS then
        TS:ForceSetStorySkipable(bSet)
        return true
    end
end

-- 播放对话，按照FindKey,以优先级依次查找以下对话：
-- 1.  查找TalkNodeId
-- 2.  查找Sequence名字（不带路径的名字）
-- 3.  查找首句台词Id
-- 4.  查找TalkTriggerId
function GM_Command:PlayTalk(FindKey, bIncludeFilterFiles)
    bIncludeFilterFiles = not (not bIncludeFilterFiles)
    local pro_path = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
    local Path = pro_path .. "../Tools/storycreator/talk_nodes.json"
    local a, Info = nil, nil
    if not UBlueprintPathsLibrary.FileExists(Path) then
        local JsonText = self:SerializeTalkNodeData()
        a,Info = URuntimeCommonFunctionLibrary.ParseTalkNodesJson(GWorld.GameInstance, JsonText, FindKey, bIncludeFilterFiles)
    else
        a,Info = URuntimeCommonFunctionLibrary.ParseTalkNodesByPath(GWorld.GameInstance, Path, FindKey, bIncludeFilterFiles)
    end
    if Info and Info ~= "" then
        local JsonLib = require("rapidjson")
        local TalkNodeInfo = JsonLib.decode(Info)
        TalkNodeInfo.props = TalkNodeInfo.props or {}

        -- 如果是npc节点，自动创建npc
        if TalkNodeInfo.props.IsNpcNode then
            local NpcId = TalkNodeInfo.props.NpcId
            if NpcId then
                self:CreateNpc(NpcId)
            end
        end

        local StorylineUtils = require 'StoryCreator.StoryLogic.StorylineUtils'
        local TalkNode = StorylineUtils.CreateQuestNode("TalkNode", {
            FinishNode = function(self, OutPortNames, Result)
            end
        })

        TalkNode:BuildNode(TalkNodeInfo.nodeId, {
            key = TalkNodeInfo.nodeId,
            type = "TalkNode",
            name = "TalkNode_Temp",
            propsData = TalkNodeInfo.props
        }, {})

        TalkNode.GuideUIEnable = false -- 临时对话节点，无法获取任务相关内容，指引缺失数据会报错。

        TalkNode:Execute(function()
            TalkNode:Finish()
            DebugPrint("PlayTalk执行结束")
        end)
    else
        UE4.UPlayTalkAsyncAction.PlayTalk(GWorld.GameInstance, tonumber(FindKey), nil)
    end
end

function GM_Command:SerializeTalkNodeData()
    local Info = {}
    local ToSubFilePath = function(Str)
        Str       = string.gsub(Str, "[/\\]", ".")
        if string.sub(Str, -6) == ".story" then
            Str = string.sub(Str, 1, string.len(Str)-6) 
        end
        return Str
    end
    local safe_require = function(module_path)
        local status, result = pcall(require, module_path)
        if status then
            return result
        else
            return nil
        end
    end
    local FolderPath = "../../Content/Script/StoryCreator/StoryFiles/"
    local GetTalkNodeDada = function(DataTable, PropertyName)
        for _, v in pairs(DataTable) do
            if v[PropertyName] then
                local FileName = v[PropertyName]
                local res = safe_require("StoryCreator.StoryFiles."..ToSubFilePath(FileName))
                local storyNodes = res and res.storyNodeData or {}
                for _, storyNode in pairs(storyNodes) do
                    local questNodes = storyNode.questNodeData.nodeData
                    for k, v in pairs(questNodes) do
                        if v.type == "TalkNode" then
                            local NodeInfo = {}
                            NodeInfo["filePath"] = FolderPath..string.gsub(FileName, ".story", ".lua")
                            NodeInfo["nodeId"] = k
                            NodeInfo["props"] = v.propsData
                            Info[k] = NodeInfo
                        end
                    end
                end
            end
        end
    end
    GetTalkNodeDada(DataMgr.DynQuest, "StoryPath")
    GetTalkNodeDada(DataMgr.QuestChain, "StoryPath")
    GetTalkNodeDada(DataMgr.TalkTrigger, "StoryLinePath")
    GetTalkNodeDada(DataMgr.PartyTopic, "PartyTopicTalkId")
    GetTalkNodeDada(DataMgr.SpecialQuestConfig, "StoryPath")

    local json = require "rapidjson"
    return json.encode(Info)
end

-- 扫描重复的对话数据
function GM_Command:ScanForDuplicatedTalk(bIncludeFilterFiles)
    DebugPrint("lhr@ScanForDuplicatedTalk")
    bIncludeFilterFiles = not (not bIncludeFilterFiles)
    local pro_path = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
    local Path = pro_path .. "../Tools/storycreator/talk_nodes.json"
    local Message = URuntimeCommonFunctionLibrary.ScanForDuplicatedTalk(GWorld.GameInstance, Path, bIncludeFilterFiles)
    local TimeUtils = require "Utils.TimeUtils"
    local TimeStr = TimeUtils.TimeToYMDHMSStr(TimeUtils.RealTime(), false, "_", "_")
    local FilePath = UEMPathFunctionLibrary.GetProjectSavedDirectory().."Talk/".. "DuplicatedTalkData_"..tostring(TimeStr) ..".txt"
    UE.URuntimeCommonFunctionLibrary.SaveFile(FilePath, Message)
end

function GM_Command:CreateSTLNode(NodeType, Args)
    local QuestNodeCoreInfo = DataMgr.QuestNodeCore[NodeType]
    local RealArgs = {}
    if QuestNodeCoreInfo and QuestNodeCoreInfo.TestArgs then
        for k,v in pairs(QuestNodeCoreInfo.TestArgs) do
            RealArgs[k] = v
        end
    end
    if Args then
        local LuaStr = "return " .. tostring(Args)
        local load_fun = _G.loadstring or load
        Args = load_fun(LuaStr)()
        for k,v in pairs(Args) do
            RealArgs[k] = v
        end
    end
    RealArgs.Type = NodeType
    PrintTable({NodeType=NodeType,RealArgs=RealArgs},10)
    local StorylineUtils = require 'StoryCreator.StoryLogic.StorylineUtils'
    local NodeCore = StorylineUtils.GMCreateQuestNode(NodeType, RealArgs)
    return NodeCore
end

function GM_Command:TestSTLNode(NodeType, Args, Res)
    -- 测试StoryLine节点功能
    -- example: gm TestSTLNode TestPrintNode {Text="Hahaha"} Success
    local NodeCore = self:CreateSTLNode(NodeType, Args)
    local Callback = nil
    local OldFinish = NodeCore.Finish
    if Res then
        local RealRes = string.lower(Res)
        if RealRes == "success" then
            Callback = function( ... )
                OldFinish(NodeCore)
                NodeCore:ClearWhenQuestSuccess()
            end
        elseif RealRes == "fail" then
            Callback = function( ... )
                OldFinish(NodeCore)
                NodeCore:ClearWhenQuestFail()
            end
        end
    end
    if Callback then
        NodeCore.Finish = Callback
    end
    NodeCore:Start()
end

function GM_Command:ShowCapsule(bShow)
    -- 显示/隐藏胶囊体
    -- example: gm ShowCapsule 0/1
    bShow = bShow or 0
    local NewHidden = true
    if bShow ~= "0" then
        NewHidden = false
    end
    self:HideMonsterCapsule(bShow)
    self.Player.CapsuleComponent:SetHiddenInGame(NewHidden, false)
    self.Player.CapsuleComponent:SetVisibility(not NewHidden, false)
    local Entities = Battle(self.Player):GetAllEntities()
    for eid, ent in pairs(Entities) do
        if ent and ent.IsMonster and ent:IsMonster() then
            ent.CapsuleComponent:SetHiddenInGame(NewHidden,false)
            ent.CapsuleComponent:SetVisibility(not NewHidden, false)
        end
    end
    UCharacterFunctionLibrary.SetNewCharacterCapsuleVisibility(NewHidden)
end

-- function GM_Command:ShowCoverPoint(Show)
--     -- 显隐掩体点
--     -- example: gm ShowCoverPoint 0/1
--     local bShow = tonumber(Show) or 1
--     local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
--     GameMode.RandomActorManager:ShowCoverPoint(bShow)
--     -- for i,v in pairs(GameState.CoverMap) do
--     --     v.DebugDraw = (bShow~=0)
--     --     local CoverPoints = TArray(UCoverPointComponent)
--     --     CoverPoints = v:K2_GetComponentsByClass(UCoverPointComponent:StaticClass())
--     --     for i = 1, CoverPoints:Length() do
--     --         CoverPoints[i]:SetHiddenInGame(not v.DebugDraw)
--     --     end
--     -- end
-- end

function GM_Command:MAULookAt(Eid)
    local MAUtils = require "Utils.MonsterAnimationUtils"
    MAUtils:LookAtMonster(Eid)
end

function GM_Command:QuitMAU()
    local MAUtils = require "Utils.MonsterAnimationUtils"
    MAUtils:QuitMAUtil()
end

function GM_Command:UseSkill(Eid, SkillId)
    local MAUtils = require "Utils.MonsterAnimationUtils"
    MAUtils:UseSkill(Eid, SkillId)
end

function GM_Command:Focus(IsFocus)
    local MAUtils = require "Utils.MonsterAnimationUtils"
    MAUtils:Focus(tonumber(IsFocus))
end

function GM_Command:SetSpeed(Value)
    local MAUtils = require "Utils.MonsterAnimationUtils"
    MAUtils:SetSpeed(tonumber(Value))
end

function GM_Command:HeadScale(Eid, Scale)
    -- 设置头部缩放
    local B = Battle(self.Player)
    local Entity = B:GetEntity(tonumber(Eid))
    if Entity.EMAnimInstance then
        Entity.EMAnimInstance.HeadScale = Scale
    end
end

function GM_Command:UpperArmScale(Scale)
    -- 设置头部缩放
    self.Player.PlayerAnimInstance.UpperArmScale = Scale
end

function GM_Command:LowerArmScale(Scale)
    -- 设置头部缩放
    self.Player.PlayerAnimInstance.LowerArmScale = Scale
end

function GM_Command:HandScale(Scale)
    -- 设置头部缩放
    self.Player.PlayerAnimInstance.TargetHandScale = Scale
end

function GM_Command:UpdateVLM()
    -- 设置头部缩放
    URuntimeCommonFunctionLibrary.UpdateFoliageVLM(self.Player)
end

function GM_Command:ChangeCreatureSpeed(Speed)
    Const.SkillCreatureSpeed = Speed
    require("EMLuaConst").SkillCreatureSpeed = Const.SkillCreatureSpeed
    self:ServerBattleCommand('ChangeCreatureSpeed', Speed)
end

function GM_Command:ShowSkillCreature()
    UE4.URuntimeCommonFunctionLibrary.ShowSkillCreature()
end

function GM_Command:ShowRayCreature()
    Const.IsShowRayCreature = not Const.IsShowRayCreature
    require("EMLuaConst").IsShowRayCreature = Const.IsShowRayCreature
end

function GM_Command:AnimCacheEnableState(IsEnable)
    -- 开启/关闭动画缓存
    -- example: gm AnimCacheEnableState 0/1
    UE4.URuntimeCommonFunctionLibrary.EnableGlobalAnimCache(self.Player, (tonumber(IsEnable) > 0));
end

function GM_Command:EnableOnlineAnimCache(IsEnable)
    -- 开启/关闭联机动画缓存
    -- example: gm EnableOnlineAnimCache 0/1
    require("EMLuaConst").bEnableDSAnimCache = (tonumber(IsEnable) > 0)
end
-- GDTAI = "GDTAI",
-- GDTEMBT = "GDTEMBT",
-- GDTAnimCache = "GDTAnimCache",

local GDTAIFlag = 1
function GM_Command:GDTAI()
    GDTAIFlag = 1 - GDTAIFlag
    UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self.Player, "gdt.EnableCategoryName AI "..tostring(GDTAIFlag), nil)
end

local GDTEMBT = 1
function GM_Command:GDTEMBT()
    GDTEMBT = 1 - GDTEMBT
    UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self.Player, "gdt.EnableCategoryName EMBT "..tostring(GDTEMBT), nil)
end

local GDTAnimCache = 0
function GM_Command:GDTAnimCache()
    GDTAnimCache = 1 - GDTAnimCache
    UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self.Player, "gdt.EnableCategoryName AnimCache "..tostring(GDTAnimCache), nil)
end

function GM_Command:DisconnectServer()
    local Avatar = self:GetClientAvatar()
    if Avatar then
        Avatar:DisconnectServer()
    end
    -- GWorld.NetworkMgr:Disconnect()
end

function GM_Command:ExitBattle(IsWin)
    -- 副本胜利或失败
    -- example: gm ExitBattle 1/0
    IsWin = tonumber(IsWin)
    IsWin = IsWin == 1 and true or false

    if IsStandAlone(self:GetGameInstance()) then
        local avatar = self:GetClientAvatar()
        if avatar then
            avatar:ExitBattle(IsWin)
        end
    else
        if IsWin then
            self:DedicatedServerCommand("DungeonWin")
        else
            self:DedicatedServerCommand("DungeonFailed")
        end
    end
end

function GM_Command:PlayerEnd(IsWin)
    IsWin = tonumber(IsWin)
    IsWin = IsWin == 1 and true or false

    if IsStandAlone(self:GetGameInstance()) then
        local avatar = self:GetClientAvatar()
        if avatar then
            avatar:ExitBattle(IsWin)
        end
    else
        if IsWin then
            self:DedicatedServerCommand("PlayerWin")
        else
            self:DedicatedServerCommand("PlayerFailed")
        end
    end
end

function GM_Command:DungeonObjectFinish(IsWin)
    -- 副本服务器关卡结算
    -- example: gm DungeonObjectFinish 1/0
    IsWin = tonumber(IsWin)
    IsWin = IsWin == 1 and true or false

    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    GameMode:NotifyServerGameEnd(IsWin, "GMFinish")
end

function GM_Command:SetInvincible(Eid)
    local GameInstance = self:GetGameInstance()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance,0)
    local Monster = Battle(PlayerCharacter):GetEntity(tonumber(Eid))
    Monster:SetInvincible(true, "GM")
end

function GM_Command:GetDrop(DropId,Count)
    DropId = tonumber(DropId)
    Count = tonumber(Count)
    local GameInstance = self:GetGameInstance()
    local ScenceManager = GameInstance:GetSceneManager()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GameInstance)
    local DropInfo = DataMgr.Drop[DropId]
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance,0)
    local Rotation = PlayerCharacter:K2_GetActorRotation()
    local SpawnLocation = PlayerCharacter:K2_GetActorLocation() + FVector(400,0,0)
    if not DropInfo or Count <= 0 then
        print(_G.LogTag,"ZJT_ DropInfo Battle DropCount ",not DropInfo, not ScenceManager:IsDungeonScene(),Count)
        return
    end
    local Avatar = self:GetClientAvatar()
    if Avatar and not Avatar:IsInDungeon() and not Avatar:CheckCurrentSubRegion() then
        print(_G.LogTag,"ZJT_ Avatar not Avatar:IsInDungeon() ", Avatar, Avatar:IsInDungeon())
        return
    end
    --注册生成的掉落物
    local Transform = UE4.UKismetMathLibrary.MakeTransform(SpawnLocation, Rotation , UE4.FVector(1, 1, 1))
    local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
    local Drops = {}
    local DropCountTable = {}
    local NormalTag = RewardBox:GetTag("Normal")
    DropCountTable[tostring(NormalTag)] = Count
    Drops[DropId] = DropCountTable
    self.Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    if IsStandAlone(self.Player) then
        GameMode:HandleRewardDrop(Drops, CommonConst.RewardReason.REASON_GM_SPAWN, Transform, {}, nil)
    elseif IsClient(self.Player) then
        self.Player.RPCComponent:GMServerGetDrop(DropId, Count)
    end
end

function GM_Command:PerMonsterDebug(bShow)
    local bHide = false
    if bShow == "0" then
        bHide = true
    end
    local Entities = Battle(self.Player):GetAllEntities()
    local CompArray
    for eid, ent in pairs(Entities) do
        if ent and ent.IsMonster and ent:IsMonster() then
            CompArray = ent:K2_GetComponentsByClass(UCharDebugWidgetComponent:StaticClass())
            for i = 1,CompArray:Length() do
                CompArray[i]:SetHiddenInGame(bHide)
            end
        end
    end
    CompArray = self.Player:K2_GetComponentsByClass(UCharDebugWidgetComponent:StaticClass())
    for i = 1,CompArray:Length() do
        CompArray[i]:SetHiddenInGame(bHide)
    end
end




function GM_Command:ShowOrHideMonsterGuideIcon( isShow )
    -- 显隐怪物身上的UI指引点
    -- example: gm smgi 0/1
    local isShow = tonumber(isShow) or 0
    isShow = isShow~=0
    local UnitLabels = TArray(FUnitLabel)
    local label = FUnitLabel()
    label.UnitId = 0
    label.UnitType = "Monster"
    UnitLabels:Add(label)
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    if not GameMode then
        return
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self.Player)
    if not GameInstance then
        return
    end
    local UIManager = GameInstance:GetGameUIManager()
    local ResourceMgr = GameInstance:GetSceneManager()
    if (UIManager == nil) then
        return
    end

    local ShowOrHide = function(isShow)
        ResourceMgr.IsSceneGuideShow = isShow
        local num = isShow and 1.0 or 0.0
        for k, v in pairs(ResourceMgr.CurSceneGuideEids) do
            local GuideIcon = UIManager:GetUIObj(k)
            if (GuideIcon ~= nil) then
                GuideIcon:SetRenderOpacity(num)
            end
        end
    end

    if isShow then
        GameMode:ShowGuideIcon(UnitLabels)
    end
    ShowOrHide(isShow)
end

function GM_Command:ScanLevel()
    -- 查看当前关卡信息
    -- example: gm ScanLevel
    local Level_shortname = UE4.URuntimeCommonFunctionLibrary.GetLevelLoadJsonName(self.Player)

    local JsonLoads = function(shortname)
        local pro_path = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
        local path=pro_path..'Script/Datas/Houdini_data/'..shortname .. '.json'
        local info = UE4.URuntimeCommonFunctionLibrary.LoadFile(path)
        local json= require("rapidjson")
        local res = json.decode(info)
        return res
    end

    local level_ids = self.Player.CurrentLevelId

    local LevelInfo = string.format("当前玩家进的拼接关卡: %s", Level_shortname)

    local LevelData = JsonLoads(Level_shortname)
    for _, point in pairs(LevelData.points) do
        for i=1,level_ids:Length() do
            local cur_id = level_ids:Get(i)
            if tostring(point.id) == cur_id then
                local cur_artLevel = point.art_path
                if cur_artLevel == '' then
                    cur_artLevel = string.gsub(point.struct, "Data_Design", "Data_Art", 1)
                end
                LevelInfo = LevelInfo .. string.format("，所在的美术关卡是: %s， 关卡id是： %s", cur_artLevel, cur_id)
            end
        end
    end
    return LevelInfo
end

function GM_Command:DebugAchvUI( AchvId )
    local UIManager = self:GetGameInstance():GetGameUIManager()
    AchvId = tonumber(AchvId)
    if not AchvId then
        print(LogTag, "必要参数缺失~")
        return
    end
    local Achv = DataMgr.Achievement[AchvId]
    if not Achv or not Achv.TargetProgress then return end
    local CurrentCount=Achv.TargetProgress
    local index=1
    if Achv.TargetProgressRenew then
        index=#Achv.TargetProgressRenew+1
    end
    local UI = UIManager:GetUIObjAsync("AchievementPanel",function(UIObj)
        if UIObj then
            UIObj:AddQuene(AchvId, CurrentCount, Achv.TargetProgress, index)
        end
    end)
    if not UI and not UIManager:GetUIObjIsAsyncLoading("AchievementPanel") then
        if Achv.CompletionValue then
            CurrentCount=Achv.CompletionValue
        end
        UI = UIManager:LoadUIAsync("AchievementPanel",function()end, AchvId, CurrentCount,Achv.TargetProgress, index)
        -- UI:UpdateAchievementPage(CurrentCount,Achv.TargetProgress, index)
        -- UI:SetVisibility(ESlateVisibility.HitTestInvisible)
    end
end

function GM_Command:EnableJetRush( IsJet, LimitYaw, LimiPitch )
    -- 开启/关闭喷气冲刺
    -- example: gm EnableJetRush 0/1
    local IsJet = tonumber(IsJet)
    if not IsJet then
        return
    end
    LimitYaw = tonumber(LimitYaw) or 100
    LimiPitch = tonumber(LimiPitch) or 100
    local Player = self.Player
    if IsJet == 1 then
        Player:StartJetRush(LimitYaw, LimiPitch)
    else
        Player:EndJetRush()
    end
end

function GM_Command:EnableBuffMesh(bOn)
    -- 开启/关闭buff模型
    -- example: gm EnableBuffMesh 0/1
    local bOn = tonumber(bOn)
    if not bOn then
        return
    end
    local Player = self.Player
    if bOn == 1 then
        Player:EnableRimLightModel(true)
    else
        Player:EnableRimLightModel(false)
    end
end
function GM_Command:EnableJetJump( IsJet )
    -- 开启/关闭喷气跳跃
    -- example: gm EnableJetJump 0/1
    local IsJet = tonumber(IsJet)
    if not IsJet then
        return
    end
    local Player = self.Player
    if IsJet == 1 then
        Player.bJetJump = true
    else    
        Player.bJetJump = false
    end
end

function GM_Command:EnableSplineMove( IsMove, CanReverse,  ShouldReachTargetPoint)
    -- 开启/关闭超级马里奥移动
    -- example: gm EnableSplineMove 1
    local IsMove = tonumber(IsMove)
    if not IsMove then
        return
    end
    local bCanReverse = tonumber(CanReverse) or 0
    local bShouldReachTargetPoint = tonumber(ShouldReachTargetPoint) or 0
    local CanMoveReverse = bCanReverse == 1
    local CanReachTargetPoint = bShouldReachTargetPoint == 1
    local Player = self.Player
    local Splines = UE4.UGameplayStatics.GetAllActorsOfClass(Player, ACinemaMoveSpline:StaticClass());
    if( Splines:Length() == 0 ) then
        print(_G.LogTag,"没有找到CinemaMoveSpline")
        return
    end
    local Spline = Splines[1]
    Player:SetWalkType(2)
    Player:SetPlayerMaxMovingSpeed(0.16)
    if IsMove == 1 then
        Player:StartMoveAlongSpline(Spline.SplineComponent,Spline.SplineComponent:K2_GetComponentLocation(), CanMoveReverse, CanReachTargetPoint)
    else
        Player:EndMoveAlongSpline()
    end
end

function GM_Command:EnableSplatoonMove( IsMove )
    -- 开启/关闭超级马里奥移动
    -- example: gm EnableSplatoonMove 0/1
    local IsMove = tonumber(IsMove)
    if not IsMove then
        return
    end
    local Player = self.Player
    if IsMove == 1 then
        Player:StartSplatoonMove()
    else    
        Player:EndSplatoonMove()
    end
end


function GM_Command:SpeedUp( Rate )
    -- 按照一定倍率修改玩家的移动速度
    -- example: gm SpeedUp 3
    Rate = tonumber(Rate)
    if not Rate then
        return
    end
    if not self.Player.CurrentSpeedRate then 
        self.Player.CurrentSpeedRate = 1
    end
    local MaxSpeed = DataMgr.PlayerRotationRates["NormalWalkSpeed"].ParamentValue[1]
    local MaxCrouch = DataMgr.PlayerRotationRates["CrouchWalkSpeed"].ParamentValue[1]
    self.Player.PlayerSlideAtttirbute.NormalWalkSpeed = MaxSpeed * Rate
    self.Player.PlayerSlideAtttirbute.CrouchWalkSpeed = MaxCrouch * Rate
    -- if self.Player:IsFlying() then 
    local Movementcomp = self.Player:GetMovementComponent()
    local CurrentMaxFlySpeed = Movementcomp.MaxFlySpeed / self.Player.CurrentSpeedRate
    Movementcomp.MaxFlySpeed = CurrentMaxFlySpeed * Rate
    -- end
    self.Player.CurrentSpeedRate = Rate
end
function GM_Command:SetWalk(IsWalk, WalkType)
    local _IsWalk = tonumber(IsWalk)
    local _WalkType = tonumber(WalkType)
    if not _IsWalk then
        return
    end
    local Player = self.Player
    if(not Player.PlayerAnimInstance) then 
        return 
    end
    if(_IsWalk == 1) then
        Player.PlayerAnimInstance.IsWalking = true
    else
        Player.PlayerAnimInstance.IsWalking = false
    end
    Player.PlayerAnimInstance.WalkType = _WalkType or 0
end
function GM_Command:ChangeSpeed(Rate)
    Rate = tonumber(Rate)
    if not Rate then
        return
    end
    self.Player:SetPlayerMaxMovingSpeed(Rate)
end
function GM_Command:ShowPreloadFX()
    ---@type UFXPreloadGameInstanceSubsystem
    local FXPreloadGameInstanceSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self.Player, UFXPreloadGameInstanceSubsystem)
    if not FXPreloadGameInstanceSubsystem then
        return
    end

    local Msg = "\nCommonNiagara:\n"
    local CommonNiagaras = FXPreloadGameInstanceSubsystem.CommonNiagaraSystems:ToArray()
    for i = 1, CommonNiagaras:Length() do
        Msg = Msg .. UKismetSystemLibrary.GetObjectName(CommonNiagaras:GetRef(i)) .. ","
    end
    Msg = Msg .. "\nPlayerNiagara\n"
    local CharacterNiagaras = FXPreloadGameInstanceSubsystem.CharacterNiagaraSystems:ToArray()
    for i = 1, CharacterNiagaras:Length() do
        Msg = Msg .. UKismetSystemLibrary.GetObjectName(CharacterNiagaras:GetRef(i)) .. ","
    end

    DebugPrint(Msg)
end

function GM_Command:GetSceneSoundPause(SoundType)
    print(_G.LogTag, "GetSceneSoundPause 的输出值是", SoundType, AudioManager(self.Player):GetSceneSoundPause(tonumber(SoundType)))
end

function GM_Command:EnterDungeon(DungeonId, SquadId)
    -- 进入副本
    -- example: gm EnterDungeon 1001
    DungeonId = tonumber(DungeonId)
    SquadId = tonumber(SquadId)
    if not DungeonId then
        return
    end
    local avatar = self:GetClientAvatar()
    if avatar then
        avatar:EnterDungeon(DungeonId,nil,function(retCode)
            if retCode == 0 then
                return
            end
            UIManager(self):ShowUITip("CommonToastMain", DataMgr.ErrorCode[retCode].ErrorCodeContent)
        end,nil,SquadId)
    end
end

function GM_Command:EnterIronSurvivalDungeon(DungeonId, IronTicket)
    DungeonId = tonumber(DungeonId)
    IronTicket = tonumber(IronTicket)
    if not DungeonId or not IronTicket then
        return
    end
    local avatar = self:GetClientAvatar()
    if avatar then
        avatar:EnterDungeon(DungeonId,nil,function(retCode)
            if retCode == 0 then
                return
            end
            UIManager(self):ShowUITip("CommonToastMain", DataMgr.ErrorCode[retCode].ErrorCodeContent)
        end,nil,nil, {
            IronTicketId = IronTicket
        })
    end
end

function GM_Command:EnterEventDungeon(DungeonId, EventId, ...)
    DungeonId = tonumber(DungeonId)
    EventId = tonumber(EventId)
    if not DungeonId or not EventId then
        return
    end
    local DungeonInfo = DataMgr.Dungeon[DungeonId]
    if not DungeonInfo then
        return
    end
    local avatar = self:GetClientAvatar()
    if not avatar then
        return
    end

    local t = {...}
    local k, v
    local CustomParams = {}
    for i=1, #t do
        if i%2==1 then
            k=t[i]
        else
            v=t[i]
            v = tonumber(v) or v
            CustomParams[k] = v
        end
    end
    avatar:EnterEventDungeon(nil, DungeonId, nil, EventId, CustomParams)
end

function GM_Command:EnterPaotai(DungeonId, PaotaiId)
    -- 进入炮台副本
    -- example: gm EnterPaotai 40101 1
    DungeonId = tonumber(DungeonId)
    PaotaiId = tonumber(PaotaiId)
    if not DungeonId or not PaotaiId then
        return
    end
    local avatar = self:GetClientAvatar()
    if avatar then
        avatar:EnterDungeon(DungeonId,nil,nil,nil,nil,{PaotaiId = PaotaiId})
    end
end

function GM_Command:EnterLocalDungeon(DungeonId)
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm EnterLocalDungeon "..DungeonId)
end

function GM_Command:EnterNewDS(DungeonId, DSVersion)
    DSVersion = DSVersion or ""
    if not DungeonId then
        return
    end

    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm EnterMultiDungeon "..DungeonId .." ".. DSVersion)
end

function GM_Command:TestEnterDS(Ip, Port)
    Ip = Ip or "127.0.0.1"
    Port = Port or 17777
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self.GameInstance, 0)
    PlayerController:ClientTravel(Ip..":"..tostring(Port).."?TestRegion", false, false)
end

function GM_Command:DSLog()
    local avatar = self:GetClientAvatar()
    if avatar then
        avatar:GetDSLogPath()
    end
end

function GM_Command:SetNickname(nickname)
    local nickname_arg = tostring(nickname)
    local avatar = self:GetClientAvatar()
    if avatar then
        avatar:SetAvatarNickname(nickname_arg)
    end
end

function GM_Command:SetSex(name,newSex,exsex)
    local newSex_str = tostring(newSex)
    local avatar = self:GetClientAvatar()
    if avatar then
        avatar:AvatarCreateRole(name,tonumber(newSex),function()
            DebugPrint("AvatarCreateRole Callback")
            AudioManager(self):SetVoiceGender()
        end)
        avatar:SetWeitaInfo(name,tonumber(exsex),function()
            DebugPrint("SetWeitaInfo Callback")
            AudioManager(self):SetVoiceGender()
        end)
    end
end

function GM_Command:SetBGMVolume(Volume)
    local bus_name = "bus:/bgm"
    local bus = UE4.UFMODBlueprintStatics.FindAssetByName(bus_name)
    UE4.UFMODBlueprintStatics.BusSetVolume(bus:Cast(UE4.UFMODBus), tonumber(Volume))
end

function GM_Command:SetAudioListenerOpenDebug(bOpen)
    if self.Player and self.Player.AudioListener then
        if bOpen == "true" then
            self.Player.AudioListener.OpenDebug = true
        elseif bOpen == "false" then
            self.Player.AudioListener.OpenDebug = false
        end
    end
end

function GM_Command:SetEMPreviewMute(bMute)
    if bMute == "true" then
        AudioManager(self.Player):SetCinePreviewSoundMute(true)
    elseif bMute == "false" then
        AudioManager(self.Player):SetCinePreviewSoundMute(false)
    end
end

function GM_Command:StartSpecialQuest(SpecialQuestId)
    -- 开始指定的特殊任务
    -- example: gm StartSpecialQuest 10000
    assert(SpecialQuestId, "一定要传入参数:SpecialQuestId")
    SpecialQuestId = tonumber(SpecialQuestId)
    local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
    ClientEventUtils:StartSpecialQuestEvent(SpecialQuestId)
end



function GM_Command:SuccessSpecialQuest()
    -- 完成指定的特殊任务
    -- example: gm SuccessSpecialQuest 10000
    local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
    local CurrentEvent = ClientEventUtils:GetCurrentEvent()
    assert(CurrentEvent, "客户端不存在特殊任务")
    assert(CurrentEvent.Type == "SpecialQuest", "客户端不存在特殊任务")
    CurrentEvent:TryFinishEvent(true)
end

function GM_Command:FailerSpecialQuest()
    -- 失败指定的特殊任务
    -- example: gm FailerSpecialQuest 10000
    local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
    local CurrentEvent = ClientEventUtils:GetCurrentEvent()
    assert(CurrentEvent, "客户端不存在特殊任务")
    assert(CurrentEvent.Type == "SpecialQuest", "客户端不存在特殊任务")
    CurrentEvent:TryFinishEvent(false)
end

function GM_Command:ChangeToMaster()
    -- 区域切换成女主
    -- example: gm ChangeToMaster
    if self.Player then
        self.Player:ChangeToMaster(true)
    end
end

function GM_Command:ChangeBackToHero()
    -- 区域切换成军械库角色
    -- example: gm ChangeBackToHero
    if self.Player then
        self.Player:ChangeBackToHero()
    end
end
function GM_Command:ChangeSkinModel(SkinId)
    if not SkinId then
        SkinId = 0
    end
    SkinId = tonumber(SkinId)
    if self.Player then

        self.Player:ChangeSkinModel(SkinId)
        self.Player:SetCharDefaultPart()
        local CharacterFashion = self.Player.CharacterFashion
        CharacterFashion.AppearanceSuitInfo.SkinId = SkinId
        if CharacterFashion then
            self.Player:InitAppearanceSuit(CharacterFashion.AppearanceSuitInfo)
        end
    end
end

function GM_Command:ChangeCharAcc(AccessoryId,AccessoryType)
    AccessoryId = tonumber(AccessoryId)
    if(self.Player.CharacterFashion)then
        if(not AccessoryType)then
            local Data= DataMgr.CharAccessory[AccessoryId]
            AccessoryType = Data and Data.AccessoryType
        end
        self.Player.CharacterFashion:ChangeAccessory(AccessoryId,AccessoryType)
    end
end

function GM_Command:ChangeWeaponAcc(AccessoryId)
    AccessoryId = tonumber(AccessoryId)
    if(self.Player.UsingWeapon)then
        self.Player.UsingWeapon:ChangeAccessory(AccessoryId)
    elseif(self.Player.MeleeWeapon)then
        self.Player.MeleeWeapon:ChangeAccessory(AccessoryId)
    elseif(self.Player.RangedWeapon)then
        self.Player.RangedWeapon:ChangeAccessory(AccessoryId)
    end
end

function GM_Command:ActiveExploreStaticCreator()
    -- 区域激活全部探索组，已完成的重置后激活
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    for Id, ExploreGroup in pairs(GameState.ExploreGroupMap) do
        print(_G.LogTag,"LXZ ActiveExploreStaticCreator", Id)
        ExploreGroup:ActiveExploreGroupGM()
    end
end

function GM_Command:PrintRegionTypeData(QuestRegionDatas, Type)
    PrintTable({Type = QuestRegionDatas}, 10)
end

function GM_Command:InitGameMode(DungeonId)
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    if not GameMode then
        return
    end
    GameMode:GMInitGameModeInfo(tonumber(DungeonId))
end


function GM_Command:TestRealtimeContentValidate(ChatContent)
    HeroUSDKSubsystem():RequestRealTimeContentValidate(ChatContent, 
    { 
        self, function(self, ResponseData) 
            DebugPrint("TestRealtimeContentValidateResponse", ResponseData.Code, ResponseData.Msg, ResponseData.Data) 
        end 
    },
    { 
        self, function(self) 
            DebugPrint("TestRealtimeContentValidateResponseFail") 
        end 
    })
end

function GM_Command:TestUploadChat( ... )
    local ChatContents = { ... }
    HeroUSDKSubsystem():RequestUploadChatData_Lua(ChatContents,  
        self, function(self, ResponseData) 
            DebugPrint("TestUploadChatResponse", ResponseData.Code, ResponseData.Msg, ResponseData.Data) 
        end)
end

function GM_Command:TestUploadReport()
    local ReportData = { 
        {
            FromServerId = 1,  
            FromRoleId = 2,  
            FromRoleName = "TestName",
            Text = "TestText",
            Remark = "TestRemark",
            Reason = "TestReason"
        }
    }
    HeroUSDKSubsystem():RequestUploadReportData_Lua(ReportData,  
        self, function(self, ResponseData) 
            DebugPrint("TestUploadReportResponse", ResponseData.Code, ResponseData.Msg, ResponseData.Data) 
        end)
end

function GM_Command:TestUploadBanLog()
    local LogData = {
        { BanType = 1, BanReason = "Reason1", BanBeginTime = 1, BanEndTime = 2 },
        { BanType = 2, BanReason = "Reason2", BanBeginTime = 1, BanEndTime = 2 }
    }
    HeroUSDKSubsystem():RequestUploadBanLog_Lua(LogData, 
        self, function(self, ResponseData) 
            DebugPrint("TestUploadBanLogResponse", ResponseData.Code, ResponseData.Msg, ResponseData.Data) 
        end)
end

function GM_Command:UnLoadChangeUI()
    local GameInstance = self:GetGameInstance()
    GameInstance:CloseLoadingUI()
    -- local UIManager = GameInstance:GetGameUIManager()
    -- UIManager:UnLoadUI("CommonChangeScene")
end






function GM_Command:PrintQuestData()
    local Avatar = GWorld:GetAvatar()
    for QuestId, QuestData in pairs(Avatar.QuestUpdateDatas) do
        print(_G.LogTag,"ZJT_ 打印之前待提交任务数据缓存 PrintQuestData QuestId ", QuestId)
        for WorldRegionEid, RegionBaseData in pairs(QuestData) do
            print(_G.LogTag,"ZJT_ PrintQuestData QuestData eid ", WorldRegionEid, RegionBaseData.Eid, RegionBaseData.QuestId, RegionBaseData.Id, 
            RegionBaseData.SubRegionId, RegionBaseData.LevelName, RegionBaseData.CreatorId)
        end
    end
end


function GM_Command:RequireAndEnterDS(DungeonId, Reason)
    local Avatar = GWorld:GetAvatar()

    local function callback(ret)
        if ErrorCode:Check(ret) then
            Avatar:ConnectAndEnterDS()
        end
    end
    Avatar:RequireDS(tonumber(DungeonId), Reason, callback)
end

function GM_Command:LoadSmallObjects()
	URuntimeCommonFunctionLibrary.LoadStreamingLevel(self.Player)
end

function GM_Command:ExitDS()
    local Avatar = GWorld:GetAvatar()
    Avatar:ExitDS()
end

function GM_Command:EnterLocalDS()
    local Avatar = GWorld:GetAvatar()
    self:GetGameInstance():ConnectDedicatedServer_Lua("127.0.0.1", 17777, Avatar.Account, Avatar.Eid)
end

function GM_Command:StartBlueProduct(DraftId)
    local Avatar = GWorld:GetAvatar()
    Avatar:StartProduct(DraftId) 
end

function GM_Command:CompleteBlueProduct(DraftId)
    local Avatar = GWorld:GetAvatar()
    Avatar:CompleteProduct(DraftId)
end

function GM_Command:AccelerateBlueProduct(DraftId)
    local Avatar = GWorld:GetAvatar()
    Avatar:AccelerateProduct(DraftId)
end

function GM_Command:KickPlayer(AvatarEid)
    local Avatar = GWorld:GetAvatar()
    Avatar:KickPlayer(AvatarEid)
end

function GM_Command:KickSelf(Reason)
    GM_Command:DedicatedServerCommand("KickSelf", Reason)
end

function GM_Command:ShowClientTime()
    local TimeUtils = require "Utils.TimeUtils"
    DebugPrint("Current Time is", TimeUtils.TimeToStr())
end

function GM_Command:ShowServerTime()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GetServerTime()
    end
end

function GM_Command:StartBattle()
    -- 移动到防守触发点
    -- example: gm StartBattle
    local MyPlayerController = UE4.UGameplayStatics.GetPlayerController(self:GetGameInstance(), 0)
    MyPlayerController:StartBattle()
end

function GM_Command:TestDrawGacha(GachaId, Counts)
    local Avatar = GWorld:GetAvatar()
    Avatar:DrawGacha(tonumber(GachaId), tonumber(Counts))
end

function GM_Command:TestDrawSkinGacha(GachaId, Counts)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    Avatar:DrawSkinGacha(tonumber(GachaId), tonumber(Counts))
end

function GM_Command:ShowGachaParams()
    local Avatar = GWorld:GetAvatar()
    local cb = function (params)
        PrintTable(params, 3)
    end
    Avatar:CallServer("GMGachaParams", cb)
end

function GM_Command:GachaSelfSelect(GachaId, ItemId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    Avatar:SetGachaSelfSelect(nil, tonumber(GachaId), tonumber(ItemId))
end

function GM_Command:FinishSystemGuide(SystemGuideId)
    local Avatar = GWorld:GetAvatar()
    Avatar:FinishSystemGuide(tonumber(SystemGuideId))
end

function GM_Command:PurchaseShopItem(ShopItemId,Count)
    local Avatar = GWorld:GetAvatar()
    Avatar:PurchaseShopItem(tonumber(ShopItemId), tonumber(Count))
end

function GM_Command:ShowPurchaseShopUI()
    local UIManger = GWorld:GetGameInstance():GetGameUIManager()
    UIManger:LoadUI(UIConst.SHOPMAIN,"ShopMain",UIConst.ZORDER_FOR_DESKTOP_TEMP)
end

function GM_Command:PlayAllNiagaraArround()
    URuntimeCommonFunctionLibrary.PlayAllNiagaraArround(self:GetGameInstance())
end

function GM_Command:EnemyVisionDebug()
	local SelectedActors = UGameplayStatics.GetAllActorsOfClass(self.Player, AMonsterCharacter:StaticClass()):ToTable()
	for _, Actor in ipairs(SelectedActors) do
		local Comp = Actor:GetComponentByClass(UCharDebugWidgetComponent:StaticClass())
		if Comp then
			Comp.bEnemyVisionDebug = not Comp.bEnemyVisionDebug
		end
	end
end

function GM_Command:TargetLocDebug()
	local SelectedActors = UGameplayStatics.GetAllActorsOfClass(self.Player, AMonsterCharacter:StaticClass()):ToTable()
	for _, Actor in ipairs(SelectedActors) do
		local Comp = Actor:GetComponentByClass(UCharDebugWidgetComponent:StaticClass())
		if Comp then
			Comp.bTargetLocDebug = not Comp.bTargetLocDebug
		end
	end
end

function GM_Command:ConnectServer()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:TestConnectLS()
    end
end

function GM_Command:ListenServer(DungeonId)
    print(_G.LogTag, "ListenServer", DungeonId)
	WorldTravelSubsystem():ChangeDungeonByDungeonId(DungeonId, CommonConst.DungeonNetMode.ListenServer)
end

function GM_Command:NetMode()
    local Mode = self:GetGameInstance():GetNetMode()
    if Mode == 0 then
        print(_G.LogTag, "Current NetMode StandAlone")
    elseif Mode == 1 then
        print(_G.LogTag, "Current NetMode DedicatedServer")
    elseif Mode == 2 then
        print(_G.LogTag, "Current NetMode ListenServer")
    elseif Mode == 3 then
        print(_G.LogTag, "Current NetMode Client")
    else
        print(_G.LogTag, "Unknown Current NetMode", Mode)
    end
end

function GM_Command:Reconnect()
    local NetworkManager = self:GetGameInstance():GetNetworkManager()
    NetworkManager:TestAck()
end

function GM_Command:TestNetworkFailure(FailureType)
    self:GetGameInstance():HandleNetworkError(tonumber(FailureType), false)
end

function GM_Command:TestCrash()
    local Controller = UE.UGameplayStatics.GetPlayerController(self:GetGameInstance(), 0)
    Controller:TestCrash()
end

function GM_Command:ForbidEntityMessage(flag)
    GWorld:ForbidEntityMessage(flag)
end

function GM_Command:DestroyAllMonster()
    local AllActors= TArray(AActor)
    UE4.UGameplayStatics.GetAllActorsOfClass(self.Player, AMonsterCharacter, AllActors)
    for i = 1, AllActors:Length() do
        ---@type AMonsterCharacter
        local Monster = AllActors:Get(i)
        if Monster then
            Monster:EMActorDestroy(EDestroyReason.GM)
        end
    end
end

function GM_Command:DSVersion()
    -- 查询本地客户端对应的DS版本号
    -- example: gm DSVersion
    local MiscUtils = require "Utils.MiscUtils"
    local DSVersion = MiscUtils.GetGameCofingSettings("DSVersion")
    return DSVersion
end

function GM_Command:ManualGC()
    -- 手动触发垃圾回收
    -- example: gm MGC
    collectgarbage("collect")
    UE4.UKismetSystemLibrary.CollectGarbage()
end

function GM_Command:SetClientTime(year, month, day, hour, minute, second)
    -- QA测试用：设置客户端时间
    -- example gm sctime 2024 6 15 19 10 11
    local TimeUtils = require "Utils.TimeUtils"
    local t = TimeUtils.DataToTimestamp(tonumber(year), tonumber(month), tonumber(day), tonumber(hour), tonumber(minute), tonumber(second))
    TimeUtils.TimeOffset = math.floor(t - os.time())
end

function GM_Command:SwitchRWS(Type, TypeId, SkinId)
    -- QA自动化测试专用：切换角色/武器/皮肤
    -- example gm SwitchRWS Char 1101
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    DebugPrint(string.format("SwitchRWS Type:%s, TypeId:%s, SkinId:%s", tostring(Type), tostring(TypeId), tostring(SkinId)))
    TypeId = tonumber(TypeId)
    if SkinId then
        SkinId = tonumber(SkinId)
        Type = Type .. "Skin"
    end

    local RefreshPlayer = function()
         local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
         local PlayerController = self.Player:GetController()
         PlayerController:SetAvatarInfo(CommonUtils.ObjId2Str(Avatar.Eid), AvatarInfo)
         self.Player:ChangeRole(nil, AvatarInfo)
    end

    -- 切换角色
    local ChangeRole = function(Id)
        Avatar.OnSwitchCurrentChar = function(Ret, CharUuid)
            Avatar.logger.debug("OnSwitchCurrentChar", Ret, CharUuid)
            RefreshPlayer()
            EventManager:FireEvent(EventID.OnSwitchRole, Avatar.CurrentChar)
        end

        for CharUUid, CharData in pairs(Avatar.Chars) do
            if CharData.CharId == Id then
                if CharUUid == Avatar.CurrentChar then
                    DebugPrint(string.format("当前角色已经是: %d，无需切换", Id))
                    return
                end
                Avatar:SwitchCurrentChar(CharUUid)
                return
            end
        end
        DebugPrint(string.format("当前账号没有角色: %d，无法切换", Id))
    end

    -- 切武器
    local ChangeWeapon = function(Id)
        Avatar.OnSwitchWeapon = function (Ret, WeaponTag, WeaponUuid)
            Avatar.logger.debug("yc_test OnSwitchWeapon", Ret, WeaponTag, WeaponUuid)
            RefreshPlayer()
            EventManager:FireEvent(EventID.OnSwitchWeapon,WeaponTag,WeaponUuid)
        end
        for WeaponUuid, WeaponData in pairs(Avatar.Weapons) do
            if WeaponData.WeaponId == Id then
                local BattleWeaponData = DataMgr.BattleWeapon[Id]
                if CommonUtils.HasValue(BattleWeaponData.WeaponTag, CommonConst.WeaponType.MeleeWeapon) then
                    if Avatar.MeleeWeapon ~= WeaponUuid then
                        Avatar:SwitchWeapon(CommonConst.WeaponType.MeleeWeapon, WeaponUuid)
                    else
                        DebugPrint(string.format("当前近战武器已经是: %d，无需切换", Id))
                    end
                elseif CommonUtils.HasValue(BattleWeaponData.WeaponTag, CommonConst.WeaponType.RangedWeapon) then
                    if Avatar.RangedWeapon ~= WeaponUuid then
                        Avatar:SwitchWeapon(CommonConst.WeaponType.RangedWeapon, WeaponUuid)
                    else
                        DebugPrint(string.format("当前远程武器已经是: %d，无需切换", Id))
                    end
                end
                return
            end
        end
    end
    -- 切角色皮肤
    local ChangeCharAppearanceSkin = function (Id, SkinId)
        Avatar.logger.debug("ChangeCharAppearanceSkin Start", SkinId)
        local AppearanceIndex = 1
        local RefreshSkinCallback = function (Ret, CharUuid, AppearanceIndex, SkinId)
            Avatar.logger.debug("OnChangeCharAppearanceSkin", Ret)
            RefreshPlayer()
            EventManager:FireEvent(EventID.OnCharSkinChanged, Ret, CharUuid, AppearanceIndex, SkinId)
        end

        Avatar.ChangeCharAppearanceSkin = function (self, CharUuid, AppearanceIndex, SkinId)
            DebugPrint("ZJT_ ChangeCharAppearanceSkin", CharUuid, AppearanceIndex, SkinId)
            self:CallServer("ChangeCharAppearanceSkin", RefreshSkinCallback, CharUuid, AppearanceIndex, SkinId)
        end

        for CharUuid, CharData in pairs(Avatar.Chars) do
            if CharData.CharId == Id then
                if CharUuid == Avatar.CurrentChar then
                    DebugPrint(string.format("当前角色已经是: %d，无需切换", Id))
                    return
                end
                Avatar:ChangeCharAppearanceSkin(CharUuid, AppearanceIndex, SkinId)
                return
            end
        end
        Avatar.logger.debug("ChangeCharAppearanceSkin End", SkinId)
    end
    -- 切武器皮肤
    local ChangeWeaponAppearanceSkin = function (Id, SkinId)
        Avatar.logger.debug("ChangeWeaponAppearanceSkin Start", Id, SkinId)
        local RefreshSkinCallback = function (Ret, WeaponTag, WeaponUuid, SkinId)
            Avatar.logger.debug("OnChangeWeaponAppearanceSkin", Ret)
            RefreshPlayer()
            EventManager:FireEvent(EventID.OnWeaponSkinChanged, Ret, WeaponTag, WeaponUuid, SkinId)
        end

        Avatar.ChangeWeaponAppearanceSkin = function(self, WeaponUuid,SkinId)
            self.logger.debug("ZJT_ ChangeWeaponAppearanceSkin Start", CommonUtils.ObjId2Str(WeaponUuid),SkinId)
            self:CallServer("ChangeWeaponAppearanceSkin", RefreshSkinCallback, WeaponUuid,SkinId)
        end
        
        local BattleWeaponData = DataMgr.BattleWeapon[Id]
        if not BattleWeaponData then
            DebugPrint(string.format("未找到 %s 对应的武器数据,无法切换皮肤", Id))
            return
        end
        local WeaponUuid
        local WeaponData
        if CommonUtils.HasValue(BattleWeaponData.WeaponTag, CommonConst.WeaponType.MeleeWeapon) then
            WeaponUuid = Avatar.MeleeWeapon
            WeaponData = Avatar.Weapons[WeaponUuid]
        elseif CommonUtils.HasValue(BattleWeaponData.WeaponTag, CommonConst.WeaponType.RangedWeapon) then
            WeaponUuid = Avatar.RangedWeapon
            WeaponData = Avatar.Weapons[WeaponUuid]
        end
        if not WeaponUuid then
            DebugPrint("当前没有装备武器,无法切换皮肤")
            return
        end
        local SkinApplicationType = DataMgr.Weapon[Id].SkinApplicationType
        local WeaponSkinItem = DataMgr.WeaponSkin[SkinId]
        local CanApply = CommonUtils.HasValue(SkinApplicationType, WeaponSkinItem.ApplicationType) and WeaponSkinItem.SkinId ~= WeaponData:GetAppearance().SkinId or false
        if not CanApply then
            DebugPrint(string.format("武器皮肤 %d 无法应用到当前武器 %d 上", SkinId, Id))
            return
        else
            Avatar:ChangeWeaponAppearanceSkin(WeaponUuid, SkinId)
        end
        Avatar.logger.debug("ChangeWeaponAppearanceSkin End", Id, SkinId)
    end
        

    if Type == "char" or Type == "role" then
        ChangeRole(TypeId)
    elseif Type == "weapon" then
        ChangeWeapon(TypeId)
    elseif Type == "charSkin" or Type == "roleSkin" then
        ChangeRole(TypeId)
        self.Player:AddTimer(0, function ()
            ChangeCharAppearanceSkin(TypeId, SkinId)
        end, false, 0.5, "QAAutoTest")
    elseif Type == "weaponSkin" then
        ChangeWeapon(TypeId)
        self.Player:AddTimer(0, function ()
            ChangeWeaponAppearanceSkin(TypeId, SkinId)
        end, false, 0.5, "QAAutoTest")
    else
        DebugPrint("AutoTestChange 不支持的类型: ", Type)
        return
    end 
end

function GM_Command:ResetTrollyLoc(NowId, NextId)
    local NowPathId = tonumber(NowId)
    local NextPathId = tonumber(NextId)
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    if not GameMode:GetDungeonComponent() then
        DebugPrint("当前未找到副本组件")
        return
    end
    GameMode.EMGameState.NowPathId = NowPathId
    GameMode.EMGameState.NextPathId = NextPathId
    for Eid, DefenceCore in pairs(GameMode.EMGameState.DefBaseMap) do
        if IsValid(DefenceCore) then
            DefenceCore.NowPathId = NowPathId
            DefenceCore.NextPathId = NextPathId
            DefenceCore.Percent = 0
            DefenceCore.Spline.Spline:ClearSplinePoints(false)
            DefenceCore:AddNewPath()
            local Transform = DefenceCore.Spline:GetMoveTransform(DefenceCore.Percent)
            Transform = FTransform(Transform.Rotation, Transform.Translation + FVector(0,0,200), DefenceCore:GetActorScale3D())
            DefenceCore:K2_SetActorTransform(Transform, false, nil, false)
            local TmpPlayerTransform = FTransform(Transform.Rotation, Transform.Translation + FVector(0,0,400), DefenceCore:GetActorScale3D())
            self.Player:K2_SetActorLocation(TmpPlayerTransform.Translation, false, nil, false)
        end
    end
end

function GM_Command:ClearFirstMonsterRecords()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    Avatar:CallServerMethod("GMClearFirstMonsterRecords")
    local GameState = self:GetGameInstance():GetCurrentGameMode().EMGameState
    GameState.FirstSeen = {}
    GameState.MonstersNeedCheck = {}
end

function GM_Command:ClearMonGuide()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    Avatar:CallServerMethod("GMClearFirstStrongMonsterRecords")
end

function GM_Command:StartQuest(QuestId)
    local Avatar = GWorld:GetAvatar()

    if not Avatar then return end
    local QuestChainId = tonumber(string.sub(QuestId, 1, 6))
    print(_G.LogTag, "QuestChainId", QuestChainId)

    local QuestChain = Avatar.QuestChains[QuestChainId]
    if QuestChain and QuestChain:IsFinish() then
        DebugPrint("ZJT_ 任务链已经完成 ", QuestChainId)
        return 
    end
    if QuestChain and QuestChain:CheckQuestIdComplete(QuestId) then
        DebugPrint("ZJT_ 任务已经完成 ", QuestId)
        return
    end
    if QuestChain and QuestChain.DoingQuestId == QuestId then
        DebugPrint("任务正在进行 ", QuestId)
        return
    end

    Avatar:GMStartQuest(tonumber(QuestChainId), tonumber(QuestId), true)
end

function GM_Command:SuccQuest(QuestId)
    local Avatar = GWorld:GetAvatar() 
    if not Avatar then return end
    local QuestChainId = tonumber(string.sub(QuestId, 1, 6))
    QuestId = tonumber(QuestId)
    local QuestChain = Avatar.QuestChains[QuestChainId]
    if QuestChain and QuestChain:IsFinish() then
        DebugPrint("ZJT_ 任务链已经完成 ", QuestChainId)
        return 
    end
    if QuestChain and QuestChain:CheckQuestIdComplete(QuestId) then
        DebugPrint("ZJT_ 任务已经完成 ", QuestId)
        return
    end
    Avatar:CallServerMethod("GMSuccestQuest", QuestChainId, QuestId)
end

function GM_Command:SkipCurrentRunningQuest()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local TrackingQuestChainId = Avatar.TrackingQuestChainId
    if TrackingQuestChainId == 0 then
        DebugPrint("ZJT_ 当前未追踪任何任务链 ", TrackingQuestChainId)
        return
    end
    local QuestChain = Avatar.QuestChains[TrackingQuestChainId]
    if QuestChain and QuestChain:IsFinish() then
        DebugPrint("ZJT_ 任务链已经完成 ", TrackingQuestChainId)
        return 
    end
    local DoingQuestId = QuestChain.DoingQuestId
    if QuestChain and QuestChain:CheckQuestIdComplete(DoingQuestId) then
        DebugPrint("ZJT_ 任务已经完成 ", DoingQuestId)
        return
    end
    self:SuccQuest(DoingQuestId)
end

function GM_Command:FailQuest(QuestId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local QuestChainId = string.sub(QuestId, 1, 6)
    QuestChainId = tonumber(QuestChainId)
    print(_G.LogTag, "QuestChainId", QuestChainId)
    if not Avatar.QuestChains[QuestChainId] then
        self:StartQuestChain(QuestChainId)
    end
    Avatar:RecoverDataByQuestChainId(QuestChainId)
end

function GM_Command:ShowUseCountSkill()
    local EMCache = require "EMCache.EMCache"
    local NeedCountPlayerSkillUsedTimesList = EMCache:Get('bNeedCountPlayerSkillUsedTimesList', true) or {}
    local NeedCountSkillTypeList = {}
    for SkillType, v in pairs(NeedCountPlayerSkillUsedTimesList) do
        table.insert(NeedCountSkillTypeList, SkillType)
    end
    local Str = table.concat(NeedCountSkillTypeList, ",")
    DebugPrint("CountSkillUsedTime->当前角色的本地存储允许哪些技能类似可以计算:", Str)
    local CountPlayerSkillUsedTimesList = EMCache:Get('CountPlayerSkillUsedTimesList', true) or {}
    DebugPrint("CountSkillUsedTime->当前技能的使用次数:")
    DebugPrint("CountSkillUsedTime->----------------------------")
    for SkillType, Count in pairs(CountPlayerSkillUsedTimesList) do
        DebugPrint("CountSkillUsedTime->技能类型", SkillType, "使用次数", Count)
    end
    DebugPrint("CountSkillUsedTime->----------------------------")
end

function GM_Command:ShowCacheUseCountSkill()
    local NeedCountPlayerSkillUsedTimesList = self.Player and self.Player.NeedCountPlayerSkillUsedTimesList or {}
    local NeedCountSkillTypeList = {}
    for SkillType, v in pairs(NeedCountPlayerSkillUsedTimesList) do
        table.insert(NeedCountSkillTypeList, SkillType)
    end
    local Str = table.concat(NeedCountSkillTypeList, ",")
    DebugPrint("CountSkillUsedTime->当前角色的缓存允许哪些技能类似可以计算:", Str)
    local CountPlayerSkillUsedTimesList = self.Player and self.Player.CountPlayerSkillUsedTimesList or {}
    DebugPrint("CountSkillUsedTime->当前技能的使用次数:")
    DebugPrint("CountSkillUsedTime->----------------------------")
    for SkillType, Count in pairs(CountPlayerSkillUsedTimesList) do
        DebugPrint("CountSkillUsedTime->技能类型", SkillType, "使用次数", Count)
    end
    DebugPrint("CountSkillUsedTime->----------------------------")
end

function GM_Command:SuccessAllQuest()
    GWorld.StoryMgr:SuccessAllQuest()
end

function GM_Command:PrintStorylineInfo()
    GWorld.StoryMgr:PrintStorylineInfo()
end

function GM_Command:PrintStorylinesNeedRestartInfo()
    GWorld.StoryMgr:PrintStorylinesNeedRestartInfo()
end

function GM_Command:SetPlayerDilation(Dilation)
    if self.Player then
        self.Player:SetTimeDilation(tonumber(Dilation))
    end
end

function GM_Command:Mem()
    local m = require("MemDump")
    m = nil
    collectgarbage("collect")
end

function GM_Command:CleanLuaTable()
    DataMgr.CleanAllTable()
end

function GM_Command:PrintCurrentSkillID()
    local Type_2_Skills = {}
    for i, v in pairs(self.Player.Type_2_Skills) do
        Type_2_Skills[i] = v
    end
    local ForceSkills = self.Player.ForceSkills
    for Index, Skill in pairs(Type_2_Skills) do
        if ForceSkills:Find(Skill) then
            Type_2_Skills[Index] = ForceSkills:Find(Skill)
        end
    end
    PrintTable(Type_2_Skills, 10, "当前按键技能为")
end

function GM_Command:PrintMonsterSkill(Eid)
    local GameInstance = self:GetGameInstance()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance,0)
    local Entity = Battle(PlayerCharacter):GetEntity(tonumber(Eid))

    if not Entity then 
        DebugPrint("Tianyi@ 找不到对应怪物")
        return 
    end

    Entity.DebugPrintSkillId = true
end

function GM_Command:ShowAvatarStatus()
    local Avatar = GWorld:GetAvatar()
    local PrintStr = "CurrentAvatarStatus: "
    if Avatar then
        Avatar:PrintAvatarStatus()
    end
end

function GM_Command:StatMonster()
    local tmp = require("StatMonster")
    tmp:Stat(self)
    tmp = nil
end

function GM_Command:StatMonsterMem()
    local tmp = require("StatMonster")
    tmp:StatMem(self)
    tmp = nil
end

function GM_Command:StatFX(NiagaraCount)
    require("StatFX"):Stat(self, NiagaraCount)
end

function GM_Command:StatLevel()
    local tmp = require("StatLevel")
    tmp:Stat(self)
    tmp = nil
end

function GM_Command:StatRecordLevel()
    local tmp = require("StatRecordLevel")
    tmp:Stat(self)
    tmp = nil
end

function GM_Command:PreviewPopup(StyleId)
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:PreviewCommonPopupStyle(StyleId)
end

function GM_Command:ShowPopup(PopupId)
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:ShowCommonPopupUI(tonumber(PopupId), {})
end
 
function GM_Command:ShowRecoverUI()
    UIUtils.ShowActionRecover(self)
end

function GM_Command:TestGetCharWeapon(Type,...)
    local Ids = {...}
    local TargetTable = {}
    TargetTable[Type..'s'] = {}
    for k,v in ipairs(Ids) do
        if not TargetTable[Type..'s'][tonumber(v)] then
            TargetTable[Type..'s'][tonumber(v)] = 0
        end
        TargetTable[Type..'s'][tonumber(v)] = TargetTable[Type..'s'][tonumber(v)] + 1
    end
    UIUtils.ShowGetCharWeaponPage(TargetTable, nil, nil,false)
end

function GM_Command:DisableCheckBox()
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    local Widget = UIManager:GetUIObj("TrainingGroundSetup")
    Widget.WBP_Training_Root.WBP_Com_CheckBox_LeftText:ForbidBtn(true)
end

function GM_Command:EnableCheckBox()
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    local Widget = UIManager:GetUIObj("TrainingGroundSetup")
    Widget.WBP_Training_Root.WBP_Com_CheckBox_LeftText:ForbidBtn(false)
end
 
function GM_Command:IsCrit()
    -- 设置玩家能否触发暴击
    -- example: gm IsCrit
    if require("EMLuaConst").IsCanCrit == false then
        require("EMLuaConst").IsCanCrit = true
    else
        require("EMLuaConst").IsCanCrit = false
    end
end

function GM_Command:IsFloat()
    -- 设置玩家能否触发浮动伤害
    -- example: gm IsFloat
    if require("EMLuaConst").IsCanFloat == false then
        require("EMLuaConst").IsCanFloat = true
    else
        require("EMLuaConst").IsCanFloat = false
    end
end

function GM_Command:TestEvent()
    self.Player:TestTriggerBattleEvent(30)
end

function GM_Command:ShowDamageDetails()
    Const.bShowDamageDetails = not Const.bShowDamageDetails
    require("EMLuaConst").bShowDamageDetails = Const.bShowDamageDetails
end

function GM_Command:DSShowDetails()
    self:ServerBattleCommand('DSShowDetails')
end

function GM_Command:ShowRealAttr()
    local GameInstance = GWorld.GameInstance
    self.Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local ATK = self.Player:GetAttr("ATK")
    local ATK_Char = self.Player:GetAttr("ATK_Char")
    local ATK_Wepon = ATK - ATK_Char
    local SkillIntensity = self.Player:GetAttr("SkillIntensity")
    local SkillSustain = self.Player:GetAttr("SkillSustain")
    local SkillRange = self.Player:GetAttr("SkillRange")
    local SkillEfficiency = self.Player:GetAttr("SkillEfficiency")
    local StrongValue = string.format("%.2f", (1 + (self.Player:GetAttr("StrongValue") or 0)) * 100)
    local EnmityValue = string.format("%.2f", (1 + (self.Player:GetAttr("EnmityValue") or 0)) * 100)
    ScreenPrint("背水："..EnmityValue.."%")
    ScreenPrint("昂扬："..StrongValue.."%")
    local Weapon = self.Player:GetCurrentWeapon()
    if Weapon then
        local CRI = string.format("%.2f", Weapon:GetAttr("CRI")*100)
        local CRD = string.format("%.2f", Weapon:GetAttr("CRD")*100)
        local TRI = string.format("%.2f", Weapon:GetAttr("TriggerProbability")*100)
        local MultiShoot = string.format("%.2f", Weapon:GetAttr("MultiShoot")*100)
        local AttackSpeed_Normal = string.format("%.2f", Weapon:GetAttr("AttackSpeed_Normal"))
        ScreenPrint("多重射击："..MultiShoot.."%")
        ScreenPrint("触发概率："..TRI.."%")
        ScreenPrint("爆伤："..CRD.."%")
        ScreenPrint("暴击："..CRI.."%")
        ScreenPrint("攻速："..AttackSpeed_Normal)
    end
    ScreenPrint("技能效益："..string.format("%.2f",SkillEfficiency*100).."%")
    ScreenPrint("技能耐久："..string.format("%.2f",SkillSustain*100).."%")
    ScreenPrint("技能范围："..string.format("%.2f",SkillRange*100).."%")
    ScreenPrint("技能强度："..string.format("%.2f",SkillIntensity*100).."%")
    ScreenPrint("武器攻击："..ATK_Wepon)
    ScreenPrint("角色攻击："..ATK_Char)
    ScreenPrint("总攻击："..ATK)
end

function GM_Command:StatDamage()
    if not Const.bShowDamageDetails then
        ScreenPrint("未开启伤害详细信息")
        return
    end
    if Const.bStatDamage then
        Const.bStatDamage = false
        ScreenPrint('该次统计总计伤害：'..string.format("%.5f",Const.TotalDamage))
        if Const.EndTime and Const.StartTime then
            ScreenPrint('该次统计总计伤害时长：'..string.format("%.5f",Const.EndTime - Const.StartTime))
        end
        Const.TotalDamage = 0
    else
        ScreenPrint('统计总计伤害开始！！！')
        Const.TotalDamage = 0
        Const.bStatDamage = true
        Const.StartTime = nil
        Const.EndTime = nil
    end
end

function GM_Command:CheckCondition(ConditionId, bShowFailed)
    bShowFailed = bShowFailed or false
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        print(_G.LogTag, "CheckCondition Result: ", ConditionUtils.CheckCondition(Avatar, tonumber(ConditionId), bShowFailed))
    end
end

function GM_Command:ServerCheckCondition(ConditionId, bShowFailed)
    bShowFailed = bShowFailed or false
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local cb = function (ret)
             print(_G.LogTag, "ServerCheckCondition Result: ", ret)
        end
        ConditionUtils.ServerCheckCondition(Avatar, tonumber(ConditionId), cb, bShowFailed)
    end
end

function GM_Command:PrintGetCover(DoPrint)
    -- if DoPrint == nil then
    --     DoPrint = true
    -- end
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    -- if GameMode ~= nil then
    --     GameMode.CoverComponent.NeedPrintGetCoverInfos = DoPrint
    -- end
end

function GM_Command:PrintUpdateCover(DoPrint)
    -- if DoPrint == nil then
    --     DoPrint = true
    -- end
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    -- if GameMode ~= nil then
    --     GameMode.CoverComponent.NeedPrintUpdateCoverInfos = DoPrint
    -- end
end

function GM_Command:TrainingCreateMonster(...)
    local Params, CreateInfo = {...}, {}
    for i = 1, #Params, 3 do
        table.insert(CreateInfo, {tonumber(Params[i]), tonumber(Params[i+1]), tonumber(Params[i+2])})
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    if GameMode ~= nil then
        GameMode:TriggerDungeonComponentFun("CreateMonster", CreateInfo)
    end
end

function GM_Command:TrainingSetMonsterAI(Flag)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    if GameMode ~= nil then
        local Param = false
        if Flag == "true" then
            Param = true
        end
        GameMode:TriggerDungeonComponentFun("SetMonsterAI", Param)
    end
end

function GM_Command:TrainingRemoveMonster()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    if GameMode ~= nil then
        GameMode:TriggerDungeonComponentFun("RemoveMonster")
    end
end

function GM_Command:TrainingClearCreateInfo()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    if GameMode ~= nil then
        GameMode:TriggerDungeonComponentFun("ClearCreateInfo")
    end
end

function GM_Command:TouchSpeedPitch(speed)
    local Player=UE4.UGameplayStatics.GetPlayerCharacter(self:GetGameInstance(), 0)
    speed = tonumber(speed)
    Player.TurnSpeedPitch = speed
end

function GM_Command:TouchSpeedYaw(speed)
    local Player=UE4.UGameplayStatics.GetPlayerCharacter(self:GetGameInstance(), 0)
    speed = tonumber(speed)
    Player.TurnSpeedYaw = speed
end

function GM_Command:TouchLimitPitch(TurnLimit)
    local Player=UE4.UGameplayStatics.GetPlayerCharacter(self:GetGameInstance(), 0)
    TurnLimit = tonumber(TurnLimit)
    Player.TurnLimitPitch = math.pi/180 *TurnLimit
end

function GM_Command:TouchLimitYaw(TurnLimit)
    local Player=UE4.UGameplayStatics.GetPlayerCharacter(self:GetGameInstance(), 0)
    TurnLimit = tonumber(TurnLimit)
    Player.TurnLimitYaw = math.pi/180 *TurnLimit
end

local CC = {}
function CC.PlayerLevelMin(Avatar, Params)
    if not Avatar then
        return
    end

    Avatar:GMSetPlayerLevel(Params)
end

function CC.DynamicEventCompleteTimes(Avatar, Params)
    PrintTable({Params = Params}, 10)
    Avatar:CallServerMethod("GMSetDynamicQuestCompleteTimes", table.unpack(Params))
end

function CC.PlayerLevelMax(Avatar, Params)
    if not Avatar then
        return
    end

    Avatar:GMSetPlayerLevel(Params)
end

function CC.QuestChain(Avatar, Params)
    GM_Command:SuccQuestChain(Params)
end

function CC.Impression(Avatar, Params)
    if type(Params) == 'table' then
        GM_Command:CompleteImpressionSystem(tonumber(Params[1]))
    end
end

function CC.HaveResource(Avatar, Params)
    if not Avatar then
        return
    end

    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(GWorld.GameInstance, "sgm ar "..Params[1] .." ".. Params[2])
end

function CC.Quest(Avatar, Params)
    GM_Command:SuccQuest(Params)
end

function CC.MechanismState(Avatar, Params)
    GM_Command:DedicatedServerCommand("TriggerMechanism", table.unpack(Params))
end

function CC.DungeonComplete(Avatar, Params)
    Avatar:CallServerMethod("GMDungeonComplete", table.unpack(Params))
end

function CC.HardBossComplete(Avatar, Params)
    Avatar:CallServerMethod("GMHardBossComplete", table.unpack(Params))
end

function CC.RougeLikeComplete(Avatar, Params)
    Avatar:CallServerMethod("GMRougeLikeComplete", Params)
end

-- 解锁多个条件
function GM_Command:CompleteCondition(ConditionIdList)
    if not ConditionIdList then return end
    if type(ConditionIdList) ~= "table" then
        ConditionIdList = {tonumber(ConditionIdList)}
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Index = 1
    local UnlockMgrOnConditionComplete = function(_, ConditionId)
        if ConditionId ==  ConditionIdList[Index] then
            if Index < #ConditionIdList then
                Index = Index + 1
                while (Index < #ConditionIdList and ConditionUtils.CheckCondition(Avatar, ConditionIdList[Index])) do
                    Index = Index + 1
                end
                self:CompleteSingleCondition(ConditionIdList[Index])
            end
        end
    end
    EventManager:AddEvent(EventID.ConditionComplete, self, UnlockMgrOnConditionComplete)
    local FirstCondition = ConditionIdList[1]
    if ConditionUtils.CheckCondition(Avatar, FirstCondition) then
        UnlockMgrOnConditionComplete(nil, FirstCondition)
    else
        self:CompleteSingleCondition(FirstCondition)
    end
end

function GM_Command:FreezeWorldComposition(bFreeze)
	if not bFreeze then
		bFreeze = 1
	end
	bFreeze = tonumber(bFreeze)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self:GetGameInstance())
	local WCSubsystem = GameMode:GetWCSubSystem()
	if not WCSubsystem then
		return
	end
	if bFreeze > 0 then
		WCSubsystem:FreezeWorldComposition()
	else
		WCSubsystem:UnFreezeWorldComposition()
	end
end


function GM_Command:BreakableItemNavEnableInLower(IsEnable)
	UE4.URuntimeCommonFunctionLibrary.EnableBreakableItemNavModifyInLower((tonumber(IsEnable) > 0))
end

-- 解锁单个条件（服务器
function GM_Command:CompleteSingleCondition(ConditionId)
    if not ConditionId then return end
    ConditionId = tonumber(ConditionId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if ConditionUtils.CheckCondition(Avatar, ConditionId) then return end
    local ConditionInfo = DataMgr.Condition[ConditionId]
    local ConditionMap = ConditionInfo.ConditionMap
    local ConditionLogic = string.lower(ConditionInfo.ConditionLogic)
    for k, v in pairs(ConditionMap) do
        for i=1, #v do
            if not ConditionUtils["Judge"..k](Avatar, v[i]) then
                if CC[k] then
                    CC[k](Avatar, v[i])
                    if ConditionLogic == "or" then
                        return
                    end
                else
                    print(_G.LogTag, string.format("条件完成函数【%s】不存在", k))
                end
            end
        end
    end
end

-- 解锁所有系统条件（服务器
function GM_Command:CompleteSystemCondition()
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm sysu")
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(8002))
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(4220))
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(4170))
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(2001))
    self:SuccessAllSystemGuide()
    local GameInstance = self:GetGameInstance()
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100102")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100103")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100201")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100202")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100203")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100204")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100205")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100206")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100207")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100208")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200101")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200102")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200103")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200104")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200215")
end

-- 解锁所有系统（客户端Fake
function GM_Command:MockAllSystemCondition(bSave)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar.bCrackUnlockAllSystems = true
    end
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI then
        BattleMainUI:InitBtnList()
        BattleMainUI.Btn_Esc:LoadImage(11)
        BattleMainUI.Battle_Map:OnChangeKeyBoardSet()
        BattleMainUI:EndChat()
        BattleMainUI:InitChat()
        BattleMainUI:_RefreshEscReddot()
    end
    if bSave=="1" then
        local EMCache = require "EMCache.EMCache"
        EMCache:Set("GM_MockAllSystemCondition",true, true)
    end
end

-- 解锁系统条件（客户端Fake
function GM_Command:MockSystemCondition(UIUnlockRuleId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar.CrackedUnlockSystems[UIUnlockRuleId] = true
    end
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI then
        BattleMainUI:InitBtnList()
    end
end

function GM_Command:ShowSystemUnlock(ID)
    local Avatar = GWorld:GetAvatar()
    Avatar:OnSystemFirstTimeUnlock_Internal(ID, function() 
        UIManager(GWorld.GameInstance):UnLoadUINew("SystemUnlockGuide") 
        local BattleMainUI = UIManager(GWorld.GameInstance):GetUIObj("BattleMain")
        if BattleMainUI ~= nil and BattleMainUI.Pos_SubSystemUnlock ~= nil then
            BattleMainUI.Pos_SubSystemUnlock:ClearChildren()
            BattleMainUI.Pos_SubSystemUnlock:SetVisibility(ESlateVisibility.Collapsed)
        end
    end)
end

-- 仅可用于模拟测试系统初次解锁，对CheckUIUnlocked无效
function GM_Command:FakeUIUnlockConditionComplete(...)
    local ConditionIds= {...}
    local Length = #ConditionIds
    local Avatar = GWorld:GetAvatar()
    if Avatar  and Length > 0 then
        for i = 1, Length do
            Avatar:UIUnlockMgrOnConditionComplete(tonumber(ConditionIds[i]))
        end
    end
end

-- 解锁全部委托关卡
function GM_Command:UnLockAllDungeonSelectLevels()
    local SelectDungeonData = DataMgr.SelectDungeon
    local AllDungeonConditions = {}
    local Avatar = GWorld:GetAvatar()

    for _, Data in pairs(SelectDungeonData) do
        local ConditionList = Data.Condition
        if ConditionList then
            for _, ConditionId in pairs(ConditionList) do
                if not ConditionUtils.CheckCondition(Avatar, ConditionId) then
                    table.insert(AllDungeonConditions, ConditionId)
                end
            end
        end
    end
    self:CompleteCondition(AllDungeonConditions)
end


function GM_Command:UnLockAllDungeonLevels()
    local DungeonData = DataMgr.Dungeon
    local AllDungeonConditions = {}
    local Avatar = GWorld:GetAvatar()
   
    for _, Data in pairs(DungeonData) do
        local ConditionList = Data.Condition
        if ConditionList then   
            for _, ConditionId in pairs(ConditionList) do
                if not ConditionUtils.CheckCondition(Avatar, ConditionId) then
                    table.insert(AllDungeonConditions, ConditionId)
                end
            end
        end
    end
    self:CompleteCondition(AllDungeonConditions)
end

function GM_Command:PlaySequence(Path)
    local SequenceAsset = LoadObject(Path)
    if not SequenceAsset then
        DebugPrint("error GM播放sequence传入路径错误", Path)
        return
    end

    local SA,SP = UE4.ULevelSequencePlayer.CreateLevelSequencePlayer(self:GetGameInstance(), SequenceAsset,UE4.FMovieSceneSequencePlaybackSettings())
    SP:Play()
end

function GM_Command:FSMDebug(EidOrTag)
    if (EidOrTag ~= nil and tonumber(EidOrTag) == nil) then
        UE4.UCharacterFSM.EnableTagDebug(EidOrTag)
        return 
    end

    local GameInstance = self:GetGameInstance()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance,0)
    if not EidOrTag then 
        PlayerCharacter.CharFSMComp.bDebugMode = not PlayerCharacter.CharFSMComp.bDebugMode
    else
        local Entity = Battle(PlayerCharacter):GetEntity(tonumber(EidOrTag))
        if Entity then 
            Entity.CharFSMComp.bDebugMode = not Entity.CharFSMComp.bDebugMode
        end
    end
end

function GM_Command:CompleteImpressionSystem(TalkTriggerId, State)
    TalkTriggerId = tonumber(TalkTriggerId)
    local ErrorCode = ""
    local printError = function()
        DebugPrint("GM_Command:CompleteImpressionSystem@", ErrorCode)
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:ShowUITip(UIConst.Tip_CommonToast, ErrorCode, 3)
    end
    if not TalkTriggerId then
        ErrorCode = "TalkTriggerId为空"
        printError()
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        ErrorCode = "Avatar不存在"
        printError()
        return
    end
    if Avatar.ImpressionTalkTriggers[TalkTriggerId] then
        ErrorCode = "对应的对话已完成，无法重复完成"
        printError()
        return
    end
    Avatar:SetTalkTriggerComplete_New(TalkTriggerId)
end


function GM_Command:SystemGuideSwitch(val)
    -- 系统引导开关
    -- example: gm SystemGuideSwitch Open/Close
    if(val == "Open") then 
        SystemGuideManager.Invalid = false 
        DebugPrint("系统引导打开")
        return 
    end
    if(val == "Close") then 
        SystemGuideManager.Invalid = true 
        DebugPrint("系统引导关闭")
        return 
    end
end

function GM_Command:SuccessAllSystemGuide()
    -- 完成所有系统引导
    -- example: gm SuccessAllSystemGuide
    DebugPrint("GM_Command:SuccessAllSystemGuide:Success all SystemGuide")
    SystemGuideManager:GMEnforceFinishAllSysGuide()
end

function GM_Command:SwitchCullModifier(TurnOn)
    if(TurnOn == "true") then
        DebugPrint("UE4.AEMRecastNavMesh.SwitchCullModifier(true)")
        UE4.AEMRecastNavMesh.SwitchCullModifier(true)
    else
        DebugPrint("UE4.AEMRecastNavMesh.SwitchCullModifier(false)")
        UE4.AEMRecastNavMesh.SwitchCullModifier(false)
    end
end

function GM_Command:I18Time(FormatID, Language)
    Language = string.lower(Language)
    if Language == "cn" then 
        DebugPrint("Current I18Time: " .. GDate(FormatID, nil, CommonConst.SystemLanguages.CN))
    elseif Language == "en" then 
        DebugPrint("Current I18Time: " .. GDate(FormatID, nil, CommonConst.SystemLanguages.EN))
    elseif Language == "jp" then 
        DebugPrint("Current I18Time: " .. GDate(FormatID, nil, CommonConst.SystemLanguages.JP))
    elseif Language == "kr" then 
        DebugPrint("Current I18Time: " .. GDate(FormatID, nil, CommonConst.SystemLanguages.KR))
    else 
        DebugPrint("Current I18Time: " .. GDate(FormatID, nil, CommonConst.SystemLanguages.CN))
    end
end

function GM_Command:PrintGuideBook()
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.GuideBook then
        for i,v in pairs(Avatar.GuideBook) do
            local info = (v.Reward == 1) and "未领取" or "已领取"
            DebugPrint("教学条目Id:", i,"状态:", info)
        end
    end
end

function GM_Command:GuideBookGetReward(GuideId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GuideBookGetReward(tonumber(GuideId))
    end
end

function GM_Command:TestWarningToast(Context,LastTime)
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonWarning,Context,tonumber(LastTime))
end

function GM_Command:TestCombineWarningToast(Context,LastTime)
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CombineWarning,Context,tonumber(LastTime))
end

function GM_Command:PlayLightHit(IsSelf, HitRule) 
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    for _, Target in pairs(GameState.MonsterMap) do
        if Target:GetCamp() == ECampName.Monster then
            local HitParams = UE4.FHitParams()
            HitParams.CauseHitName = HitRule or "LightHit_120"   
            HitParams.CauseHitType = Const.CauseHitTypeNormal
            Target:SetCharacterTag("LightHit")
            Target:ProcessHit("LightHit", self.Player, HitParams)
        end
    end

    if tonumber(IsSelf) == 1 then 
        local HitParams = UE4.FHitParams()
        HitParams.CauseHitName = HitRule or "LightHit_120"   
        HitParams.CauseHitType = Const.CauseHitTypeNormal
        self.Player:SetCharacterTag("LightHit")
        self.Player:ProcessHit("LightHit", self.Player, HitParams)
    end
end

function GM_Command:PlayLightHitRanged(IsSelf, HitRule)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    for _, Target in pairs(GameState.MonsterMap) do
        if Target:GetCamp() == ECampName.Monster then
            local HitParams = UE4.FHitParams()
            HitParams.CauseHitName = HitRule or "RangedWeapon_Common"   
            HitParams.CauseHitType = Const.CauseHitTypeNormal
            Target:SetCharacterTag("LightHitRanged")
            Target:ProcessHit("LightHitRanged", self.Player, HitParams)
        end
    end

    if tonumber(IsSelf) == 1 then 
        local HitParams = UE4.FHitParams()
        HitParams.CauseHitName = HitRule or "RangedWeapon_Common"   
        HitParams.CauseHitType = Const.CauseHitTypeNormal
        self.Player:SetCharacterTag("LightHitRanged")
        self.Player:ProcessHit("LightHitRanged", self.Player, HitParams)
    end
end

function GM_Command:PlayHeavyHit(IsSelf, HitRule)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    for _, Target in pairs(GameState.MonsterMap) do
        if Target:GetCamp() == ECampName.Monster then
            local HitParams = UE4.FHitParams()
            HitParams.CauseHitName = HitRule or "HeavyHit_30"   
            HitParams.CauseHitType = Const.CauseHitTypeNormal
            Target:SetCharacterTag("HeavyHit")
            Target:ProcessHit("HeavyHit", self.Player, HitParams)
        end
    end

    if tonumber(IsSelf) == 1 then 
        local HitParams = UE4.FHitParams()
        HitParams.CauseHitName = HitRule or "HeavyHit_30"   
        HitParams.CauseHitType = Const.CauseHitTypeNormal   
        self.Player:SetCharacterTag("HeavyHit")
        self.Player:ProcessHit("HeavyHit", self.Player, HitParams)
    end
end

function GM_Command:PlayHitFly(IsSelf, HitRule) 
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    for _, Target in pairs(GameState.MonsterMap) do
            local HitParams = UE4.FHitParams()
            HitParams.CauseHitName = HitRule or "HitFly_XY500Z1000"   
            HitParams.CauseHitType = Const.CauseHitTypeNormal
            Target:SetCharacterTag("HitFly")
            Target:ProcessHitFly(self.Player, HitParams)
    end

    if tonumber(IsSelf) == 1 then 
        local HitParams = UE4.FHitParams()
        HitParams.CauseHitName = HitRule or "HitFly_XY400Z300"   
        HitParams.CauseHitType = Const.CauseHitTypeNormal
        self.Player:SetCharacterTag("HitFly")
        self.Player:ProcessHitFly(self.Player, HitParams)
    end
end

function GM_Command:PlayHitFly_Force(HitRule)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    for _, Target in pairs(GameState.MonsterMap) do
        if Target:GetCamp() == ECampName.Monster then
            local HitParams = UE4.FHitParams()
            HitParams.CauseHitName = HitRule or "HitFly_Force_Common"   
            HitParams.CauseHitType = Const.CauseHitTypeNormal
            Target:SetCharacterTag("HitFly")
            Target:ProcessHitFly(self.Player, HitParams)
        end
    end
end

function GM_Command:EnterRougeLike(SeasonId, Difficulty, SquadId)
    print(_G.LogTag, "EnterRougeLike", SeasonId, Difficulty, SquadId)
    SeasonId = SeasonId or ""
    Difficulty = Difficulty or ""
    SquadId = SquadId or ""
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm EnterRougeLike "..SeasonId .." ".. Difficulty .. " " .. SquadId)
end

function GM_Command:UpgradeAward(AwardType, AwardId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:UpgradeAward(AwardType, AwardId)
    end
end

function GM_Command:StartAutoTest()
    local RoleId = self.Player.CurrentRoleId
    -- local Phantoms = self:GetPhantomTeammates()

	local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
	local Location = self.Player:K2_GetActorLocation()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self.Player, 0)
    local AvatarInfo = PlayerController:GetAvatarInfo()
    local Context = AEventMgr.CreateUnitContext()
    Context.UnitId = 1
    Context.IntParams:Add("RoleId", RoleId)
    Context.UnitType = "Phantom"
    Context.Loc = Location
    Context.NameParams:Add("Camp", "Player")
    Context.BoolParams:Add("FixLocation", true)
    Context:AddLuaTable("AvatarInfo", AvatarInfo)
    GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
end

function GM_Command:AutoBattleTestServer(Id)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:CallServerMethod("GMTestAutoBattle", Id)
    end
end

function GM_Command:AutoBattleTestClient(Id)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:CallServerMethod("GMTestAutoBattle", Id, true)
    end
end

function GM_Command:StopAutoBattleTest(bClientMode)
    local ret = false
    if bClientMode then
        ret = true
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:CallServerMethod("GMStopAutoBattleTest", ret)
    end
end

function GM_Command:StartVote()
    if IsStandAlone(self:GetGameInstance()) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
        GameMode:TriggerActiveGameModeState(5)
    else
        self:DedicatedServerCommand("StartVote")
    end
    -- UIManager(self.Player):LoadUINew("Vote")
    -- self.Player.CrackKeyNum = self.Player.CrackKeyNum + 1
    -- Battle(self):AddBuffToTarget(self.Player, self.Player, 50, -1, nil, nil, 1)
end

function GM_Command:SpawnPet()
    if IsStandAlone(self:GetGameInstance()) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
        GameMode:TriggerSpawnPet()
    else
        self:DedicatedServerCommand("SpawnPet")
    end
end

function GM_Command:PostCustomEvent(EventName)
    -- gm触发PostCustomEvent
    -- example: gm PostCustomEvent xxxx
    DebugPrint("GM PostCustomEvent", EventName)
    if IsStandAlone(self:GetGameInstance()) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
        GameMode:PostCustomEvent(EventName)
    else
        self:DedicatedServerCommand("PostCustomEvent", EventName)
    end
end

function GM_Command:SetFeinaStar(NewStar)
    -- 设置菲娜活动星级
    -- example: gm SetFeinaStar 5
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    GameMode:TriggerDungeonComponentFun("SetStar", tonumber(NewStar))
end

function GM_Command:EnterAbyss(_AbyssDungeonId, _AbyssDifficulty)
    -- 进入指定等级的大秘境关卡（注意！此为临时给gm专用的实现方式）
    -- example: gm EnterAbyss 2011011 30
    local AbyssDungeonId = tonumber(_AbyssDungeonId)
    local DungeonId = DataMgr.AbyssDungeon[AbyssDungeonId].DungeonId
    local AbyssDifficulty = tonumber(_AbyssDifficulty)
    local CustomPreInitInfo = {
        AbyssDungeonId = AbyssDungeonId,
        AbyssDifficulty = AbyssDifficulty,
    }
    GWorld.GameInstance.TempAbyssInfo = CustomPreInitInfo
    DebugPrint("GM_EnterAbyss AbyssDungeonId", AbyssDungeonId, "DungeonId", DungeonId, "AbyssDifficulty", AbyssDifficulty)
    self:EnterDungeon(DungeonId)
end

function GM_Command:EnterAbyssNew(AbyssId, AbyssLevelId, AbyssDungeonIndex)
    -- 进入大秘境关卡 大秘境id 层级id 关卡索引
    -- example: gm EnterAbyssNew 9991 1 1
    --处理进入副本服务器返回值
    local Callback = function(RetCode)
        if not ErrorCode:Check(RetCode) then
			return
		end

        DebugPrint("GM_EnterAbyssNew Success AbyssId", AbyssId, "AbyssLevelId", AbyssLevelId, "AbyssDungeonIndex", AbyssDungeonIndex)
    end
    local Avatar = self:GetClientAvatar()
    if Avatar then
        Avatar:TriggerEnterAbyss(Callback, tonumber(AbyssId), tonumber(AbyssLevelId), tonumber(AbyssDungeonIndex))
    end
end

function GM_Command :PrintAllDailyTask()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    Avatar:UpdateStoryVariable("PhotoTalk110105", 1)
    -- PrintTable({DailyTasks = Avatar.DailyTasks:all_dump(Avatar.DailyTasks)}, 10)
    -- PrintTable({DailyTaskProgress = Avatar.DailyTaskProgress:all_dump(Avatar.DailyTaskProgress)}, 10)
    -- PrintTable({DailyTaskAchvs = Avatar.DailyTaskAchvs:all_dump(Avatar.DailyTaskAchvs)}, 10)
    -- PrintTable({CurrentTaskProgress = Avatar.CurrentTaskProgress}, 10)
end

function GM_Command:AbyssPassRoom()
    -- 深渊通关当前房间
    -- example: gm AbyssPassRoom
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    for i, MonsterSpawn in pairs(GameMode.MonsterSpawnMap) do
        MonsterSpawn:ClearMonsterSpawnInfo()
        if IsValid(GameMode.MonsterSpawnMap:Find(MonsterSpawn.UnitSpawnId)) then
            GameMode.MonsterSpawnMap:Remove(MonsterSpawn.UnitSpawnId)
        end
        MonsterSpawn:K2_DestroyActor()
    end
    self:ServerBattleCommand('KillMonster', self.Player.Eid)
    
    for _, SubGameMode in pairs(GameMode.SubGameModeInfo) do    --  暂时写个for循环第一次遍历就return吧
        SubGameMode:BpDelTimer("AbyssBattle", false, Const.GameModeEventServerClient)
        SubGameMode:AbyssRoomEnd(EAbyssRoomEndReason.MissionClear)
        SubGameMode:TeleportToNextRoom()
        return
    end
end

function GM_Command:ReduceBuffLayer(BuffId, Layer)
    local GameInstance = self:GetGameInstance()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    Player:ReduceBuffLayer(Player, tonumber(BuffId), tonumber(Layer))
end

function GM_Command:ChangeBuffLastTime(BuffId, LastTimeValue, bIsExpand)
    local GameInstance = self:GetGameInstance()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    Player:ChangeBuffLastTime(tonumber(BuffId), 0, tonumber(LastTimeValue), bIsExpand)
end

function GM_Command:TestTrackingQuest(QuestIdStr)
    local QuestId = tonumber(QuestIdStr)
    local Avatar = GWorld:GetAvatar()
    if Avatar and QuestId then
        Avatar:SetQuestTracking(QuestId)
    end
end

function GM_Command:SetBGMOpenDebug(bOpenDebug)
    if bOpenDebug == "true" then
        AudioManager(self.Player):SetBGMDebugValue(true)
    elseif bOpenDebug == "false" then
        AudioManager(self.Player):SetBGMDebugValue(false)
    end
end

function GM_Command:PrintBGMInfo()
    AudioManager(self.Player):PrintBGMInfo()
end

function GM_Command:GetAllBusVolume()
    AudioManager(self.Player):GetAllBusVolume()
end

function GM_Command:GetAllBusPauseState()
    AudioManager(self.Player):GetAllBusPauseState()
end

function GM_Command:ReloadAllBank()
    UE4.UFMODBlueprintStatics.ReloadAllBank()
end

function GM_Command:TriggerLoadedEvent()
	DebugPrint("TriggerLoadedEvent")

	local GameMode = UE4.UGameplayStatics.GetGameMode(self:GetGameInstance())

    if GameMode then
        GameMode:TriggerLoadedEvent()
        return
    end
end

function GM_Command:SetDrawDebugEnabled(bEnabled)
    if bEnabled == "true" then
        AudioManager(self.Player).DrawDebug = true
    elseif bEnabled == "false" then
        AudioManager(self.Player).DrawDebug = false
    end
    -- EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, "hyytest", 0)
end

function GM_Command:SetSoundPointCompDebugEnabled(bEnabled)
    if not self.Player.SoundPointManagerComp then
        return
    end
    if bEnabled == "true" then
        self.Player.SoundPointManagerComp.EnableDebug = true
    elseif bEnabled == "false" then
        self.Player.SoundPointManagerComp.EnableDebug = false
    end
end

function GM_Command:SetSoundSplineDrawDebug(bEnabled)
    local Enable = nil
    if bEnabled == "true" then
        Enable = true
    elseif bEnabled == "false" then
        Enable = false
    end
    local SoundSplines = UGameplayStatics.GetAllActorsOfClass(self.Player, ASoundSpline:StaticClass()):ToTable()
    for _, SoundSpline in pairs(SoundSplines) do
        SoundSpline.SplineDrawDebug = Enable
    end
end

function GM_Command:SetReverLogicOpenbDebug(bOpenDebug)
    if bOpenDebug == "true" then
        AudioManager(self.Player).ReverbLogicDebug = true
    elseif bOpenDebug == "false" then
        AudioManager(self.Player).ReverbLogicDebug = false
    end
    -- local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    -- GameState:HideCustomNpcsByAtmosphereTag(AudioManager(self.Player).ReverbLogicDebug, "hyytest")
end

function GM_Command:PrintHeadPhonePlugIn()
    AudioManager(self.Player):DebugPrintHeadPhonePlugInParam()
end

function GM_Command:SetAudioManagerTestRegionId(InRegionId)
    AudioManager(self.Player).TestRegionId = tonumber(InRegionId)
end

function GM_Command:SimulateBGMEnterNewRegion(NewRegionId)
    AudioManager(self.Player).TestRegionId = tonumber(NewRegionId)
    AudioManager(self.Player):CheckLevelSoundAndRegionId(tonumber(NewRegionId))
end

function GM_Command:SetLineSoundDebug(bOpenDebug)
    if bOpenDebug == "true" then
        AudioManager(self.Player).LineSound_DrawDebug = true
    elseif bOpenDebug == "false" then
        AudioManager(self.Player).LineSound_DrawDebug = false
    end
end

function GM_Command:SectorSoundDebug(bOpenDebug)
    if bOpenDebug == "true" then
        AudioManager(self.Player).SectorSound_DrawDebug = true
    elseif bOpenDebug == "false" then
        AudioManager(self.Player).SectorSound_DrawDebug = false
    end
end

function GM_Command:CircularSoundDebug(bOpenDebug)
if bOpenDebug == "true" then
    AudioManager(self.Player).Circular_DrawDebug = true
elseif bOpenDebug == "false" then
    AudioManager(self.Player).Circular_DrawDebug = false
end
end

function GM_Command:PrintEventsMap()
    AudioManager(self.Player):PrintEventsMap()
end

function GM_Command:PrintAUAForbidTag()
    AudioManager(self.Player):PrintAuANotifyForbidTag()
end

function GM_Command:PrintCurAuActionCount()
    AudioManager(self.Player):PrintCurAuActionCount()
end

---@todo ZDX_临时测试商城，后续删除
function GM_Command:RogueShopTest()
    local UIManager = self:GetGameInstance():GetGameUIManager()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local RougeLikeManager = GWorld.RougeLikeManager
    if not RougeLikeManager then
        return
    end
    local Shop = RougeLikeManager.Shop:Keys()
    local ShopId = nil
    if Shop:Length() > 0 then
        ShopId = Shop[1]
    end
    UIManager:LoadUINew("RougeShop", ShopId)
end

function GM_Command:RougeDetailsTest()
    local UIManager = self:GetGameInstance():GetGameUIManager()
    UIManager:LoadUINew('RougeBag')
end

function GM_Command:ShowRougeManual()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        PrintTable(Avatar.RougeLike.Manual, 5)
    end
end

function GM_Command:DisableBattleWheel()
	local MyPlayerController = UE4.UGameplayStatics.GetPlayerController(self:GetGameInstance(), 0)
	DebugPrint("gmy@GM_Command:DisableBattleWheel", MyPlayerController.bEnableBattleWheel)
	MyPlayerController.bEnableBattleWheel = false
	if self.Player then
		self.Player:RefreshBattleWheelEnableState()
	end
end

function GM_Command:EnableBattleWheel()
	local MyPlayerController = UE4.UGameplayStatics.GetPlayerController(self:GetGameInstance(), 0)
	DebugPrint("gmy@GM_Command:EnableBattleWheel", MyPlayerController.bEnableBattleWheel)
	MyPlayerController.bEnableBattleWheel = true
	if self.Player then
		self.Player:RefreshBattleWheelEnableState()
	end
end

function GM_Command:FillBattleWheel()
    local Avatar = GWorld:GetAvatar()
    local ResourceList = { 40001, 40002, 40003, 40011, 40012, 40013, 41001, 41002, 41003, 41004, 41005, 41006, 41007, 41008, 41009, 41010, 41011, 41012, 41013, 41014, }
    for Index, ResourceId in ipairs(ResourceList) do
        Avatar:ChangeBattleWheel(1, Index, ResourceId)
    end
end

function GM_Command:PrintBattleWheel()
    local Avatar = GWorld:GetAvatar()
    local Wheels = Avatar.Wheels

    for i = 1, 24 do
        DebugPrint("gmy@GM_Command GM_Command:PrintBattleWheel", i, Wheels[1][i].ResourceId)
    end
end

function GM_Command:AddPet(PetId)
    self:ServerBattleCommand('AddPet', PetId)
end

function GM_Command:AddPetAffix(AffixId)
    self:ServerBattleCommand('AddPetAffix', AffixId)
end

function GM_Command:RemovePet()
    self:ServerBattleCommand('RemovePet')
end

function GM_Command:RemovePetAffix(AffixId)
    self:ServerBattleCommand('RemovePetAffix', AffixId)
end

function GM_Command:PrintTeammates()
	local Players = self.Player:GetAllTeammates()
	for Index, Player in pairs(Players) do
		DebugPrint("gmy@GM_Command:PrintTeammates", Index, Player:GetName())
	end
end

function GM_Command:PrintPlayers()
	local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
	local Players = GameState:GetAllPlayer()

	for Index, Player in pairs(Players) do
		DebugPrint("gmy@GM_Command:PrintPlayers", Index, Player:GetName())
	end
end

function GM_Command:ShowCountdownToast(TotalTime,WarningTime)
    TotalTime = tonumber(TotalTime)
    WarningTime = tonumber(WarningTime)
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager then
        local UI = UIManager:LoadUINew("DungeonCaptureFloat",TotalTime,WarningTime)
        UI:UIStateChange_OnTarget()
    end
end

function GM_Command:AddCountdownTime(Time)
    Time = tonumber(Time)
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager then
        local UI = UIManager:GetUIObj("DungeonCaptureFloat")
        UI:AddRemainingTime(Time)
    end
end

function GM_Command:ForceUseSkill(Eid, SkillId)
	if DrawDebugTest then
		local _SkillId = tonumber(SkillId)
		local _OtherPlayerId = tonumber(Eid)

		self.Player:ServerUseSkillTest(_OtherPlayerId, _SkillId)
	end
end

function GM_Command:UnlockMonsterGallery()
    local Avatar = GWorld:GetAvatar()
    for RuleId, GalleryData in pairs(DataMgr.GalleryRule) do 
        if not GalleryData.DisableTrainingGround then 
            local UnitId = GalleryData.PreferredMonsterId
            Avatar:CheckFirstMonster(UnitId, true)
        end
    end
end

function GM_Command:ShowHudReward(Type, Id, Count)
    local Rewards = {}
    Id = tonumber(Id)
    if Type == "Quest" then
        if DataMgr.QuestChain[Id] == nil or DataMgr.QuestChain[Id].QuestChainReward == nil then
            DebugPrint("QuestChainId is error or QuestChainReward is nil")
            return
        end
        local RewardList = DataMgr.QuestChain[Id].QuestChainReward
        for _, RewardId in pairs(RewardList) do
            local RewardInfo = DataMgr.Reward[RewardId]
            if RewardInfo then
                local Ids = RewardInfo.Id or {}
                local RewardCount = RewardInfo.Count or {}
                local TableName = RewardInfo.Type or {}
                for i = 1, #Ids do
                    local ItemId = Ids[i]
                    local Count = RewardUtils:GetCount(RewardCount[i])
                    local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                    local ItemType = TableName[i]
                    local RewardContent = {
                        ItemType = ItemType,
                        ItemId = ItemId,
                        Count = Count,
                        Rarity = Rarity,
                    }
                    table.insert(Rewards, RewardContent)
                end
            end
        end
    elseif Type == "Reward" then
        local RewardInfo = DataMgr.Reward[Id]
        local RewardList = {}
        if RewardInfo then
            local RewardIds = RewardInfo.Id or {}
            local RewardCounts = RewardInfo.Count or {}
            local RewardTypes = RewardInfo.Type or {}
            for i = 1, #RewardIds do
                local ItemId = RewardIds[i]
                local Count = RewardUtils:GetCount(RewardCounts[i])
                local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
                local ItemType = RewardTypes[i]
                local RewardContent = {
                    ItemType = ItemType,
                    ItemId = ItemId,
                    Count = Count,
                    Rarity = Rarity,
                }
                table.insert(Rewards, RewardContent)
            end
        end
    else
        local RewardContent = {
            ItemType = Type,
            ItemId = Id,
            Count = Count,
            Rarity = ItemUtils.GetItemRarity(Id,Type),
        }
        table.insert(Rewards, RewardContent)
    end
    local function SortByRarity(a, b)
        return a.Rarity > b.Rarity
    end
    table.sort(Rewards, SortByRarity)
    UIUtils.ShowHudReward("测试", Rewards)
end

function GM_Command:FXPriorityTest()
    local path1 = "/Game/Asset/Effect/Niagara/Weapon/Sword/NS_Huipo_RunAttack01_dg_Pro.NS_Huipo_RunAttack01_dg_Pro"
    local path2 = "/Game/Asset/Effect/Niagara/Weapon/Sword/NS_Huipo_RunAttack01_dg_Pro.NS_Huipo_RunAttack01_dg_Pro"
    local path3 = "/Game/Asset/Effect/Niagara/Weapon/Sword/NS_Huipo_RunAttack01_dg_Pro.NS_Huipo_RunAttack01_dg_Pro"
    -- local path1 = "/Game/Asset/Effect/Niagara/Player/Haier/NS_Haier_Passive.NS_Haier_Passive"
    -- local path2 = "/Game/Asset/Effect/Niagara/Player/Landi/NS_Landi_Skill02_Ground01.NS_Landi_Skill02_Ground01"
    -- local path3 = "/Game/Asset/Effect/Niagara/Player/Saiqi/NS_Saiqi_Skill01_Explode.NS_Saiqi_Skill01_Explode"

    self.Player.FXComponent:PlayFX(LoadObject(path1), self.Player.Mesh, nil, self.Player:K2_GetActorLocation(), FRotator(0,0,0), 
        true, false, false, false, EAttachLocation.KeepWorldPosition, EFXPriorityType.Lowest)
    self.Player:AddTimer(0.1, function()
        self.Player.FXComponent:PlayFX(LoadObject(path2), self.Player.Mesh, nil, self.Player:K2_GetActorLocation() + FVector(0, 300, 0), FRotator(0,0,0), 
        true, false, false, false, EAttachLocation.KeepWorldPosition, EFXPriorityType.Dead)
    end, false, 0, "FXTest1", false)

    self.Player:AddTimer(0.2, function()
        self.Player.FXComponent:PlayFX(LoadObject(path3), self.Player.Mesh, nil, self.Player:K2_GetActorLocation() + FVector(0, 500, 0), FRotator(0,0,0), 
        true, false, false, false, EAttachLocation.KeepWorldPosition, EFXPriorityType.Born)
    end, false, 0, "FXTest2", false)

    -- self.Player:AddTimer(0.3, function()
    --     self.Player.FXComponent:PlayFX(LoadObject(path1), self.Player.Mesh, nil, self.Player:K2_GetActorLocation() + FVector(0, 450, 0), FRotator(0,0,0), 
    --     true, false, false, false, EAttachLocation.KeepWorldPosition, EFXPriorityType.Dead)
    -- end, false, 0, "FXTest3", false)

end

local FXPriorityTest_CharName = {
    "Baiheng",
    "Feina",
    "Haier",
    "Heitao",
    "Landi",
    "Linen",
    "Maer",
    "Nvzhu",
    "Saiqi",
    "Shuimu",
    "Songlu",
    "Xibi",
    "Xier",
    "Yeer",
    "Yuming",
    "Zhangyu"
}

local AllFXTestObj = {}

function GM_Command:FXPriorityTest_Char(Index)
    local FXPreloadGameInstanceSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self.Player, UFXPreloadGameInstanceSubsystem)

    local PlayerLoc = self.Player:K2_GetActorLocation()
    local XBiasDis = FVector(100, 0, 0)
    local XBiasCount = 0
    local YBiasDis = FVector(0, 100, 0)
    local YBiasCount = 0
    local function PlayCharFX(Name)
        if not Name then
            return
        end

        FXPreloadGameInstanceSubsystem:PreloadCharacterFX(Name)
        local CharacterNiagaras = FXPreloadGameInstanceSubsystem.CharacterNiagaraSystems:ToArray()

        for key, Obj in pairs(CharacterNiagaras) do
            -- self.Player.FXComponent:PlayFX(Obj, self.Player.Mesh, nil, PlayerLoc + XBiasDis * XBiasCount + YBiasDis * YBiasCount, 
            -- FRotator(0,0,0), true, false, false, false, EAttachLocation.KeepWorldPosition, EFXPriorityType.Lowest)

            local FXObj = self.Player.FXComponent:PlayFX(Obj, self.Player.Mesh, nil, PlayerLoc, 
            FRotator(0,0,0), true, false, false, false, EAttachLocation.KeepWorldPosition, EFXPriorityType.Lowest)
            
            table.insert(AllFXTestObj, FXObj)

            XBiasCount = XBiasCount + 1
        end
        
        YBiasCount = YBiasCount + 1
    end

    if Index and tonumber(Index) > 0 then
        local Name = FXPriorityTest_CharName[tonumber(Index)]
        PlayCharFX(Name)
    else
        for idx, Name in pairs(FXPriorityTest_CharName) do
            PlayCharFX(Name)
        end
    end
end

function GM_Command:ClearFXTest()
    for _, FXObj in pairs(AllFXTestObj) do
        if IsValid(FXObj) then
            UE4.UCharacterFunctionLibrary.DeactivateNiagaraImmediately(FXObj)
        end
    end
    AllFXTestObj = {}
    self:ManualGC()
end

function GM_Command:PrintAllFXPath()
    local Folder = "Asset/Effect/Niagara/"
    local PreloadSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self.Player, UE4.URolePreloadGameInstanceSubsystem)
	local _, NiagaraPaths = PreloadSystem.GetFolderAssetPaths(Folder)
    for _, path in ipairs(NiagaraPaths:ToTable()) do
        print(_G.LogTag, path)
    end
end

function GM_Command:LevelFXTest(Path)
    self.Player.FXComponent:SpawnFXAtLocation_Level(Path, "Test", true, self.Player:K2_GetActorLocation())
    self.Player.FXComponent:SpawnFXAtLocation_Level(Path, "Test", true, self.Player:K2_GetActorLocation())
    local function cb(obj)
        print(_G.LogTag, "------------", obj)
    end
    -- self.Player.FXComponent:GetFXByName_LevelInner("Test", {self, cb})
    -- self.Player.FXComponent:StopFX_Level("Test")
end

function GM_Command:FXPriorityTest_One(Path, Count)
    if not Path then
        return
    end
    for _, FXObj in pairs(AllFXTestObj) do
        if IsValid(FXObj) then
            UE4.UCharacterFunctionLibrary.DeactivateNiagaraImmediately(FXObj)
        end
    end
    AllFXTestObj = {}

    local Asset = LoadObject(Path)
    Count = Count or 30
    for i = 1, Count, 1 do
        local FXObj = self.Player.FXComponent:PlayFX(Asset, self.Player.Mesh, nil, self.Player:K2_GetActorLocation(), 
        FRotator(0,0,0), true, false, false, false, EAttachLocation.KeepWorldPosition, EFXPriorityType.Lowest)
        
        table.insert(AllFXTestObj, FXObj)
    end
end

function GM_Command:CharacterTag()
    DebugPrint("Tianyi@ CurrentTag: " .. self.Player:GetCharacterTag())
end

function GM_Command:CalcAttrOpt(Value)
    local NumValue = tonumber(Value)
    if not NumValue then return end
    local AttributesSetSubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UAttributesSetSubsystem:StaticClass())
    if NumValue == 0 then
        AttributesSetSubSystem:SwitchCalcAttrOptimization(false)
    elseif NumValue == 1 then
        AttributesSetSubSystem:SwitchCalcAttrOptimization(true)
    end
end

function GM_Command:IsQuestChainLock(QuestChainId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if Avatar:IsQuestChainLock(tonumber(QuestChainId)) then
        DebugPrint("Lock", QuestChainId)
    else
        DebugPrint("Not Lock", QuestChainId)
    end
end

function GM_Command:IsQuestChainUnlock(QuestChainId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if Avatar:IsQuestChainUnlock(tonumber(QuestChainId)) then
        DebugPrint("UnLock", QuestChainId)
    else
        DebugPrint("Not UnLock", QuestChainId)
    end
end

function GM_Command:MonsterSpawnPointDistributeLogicTest()
    AMonsterSpawn.GMTestDistributedMonsterLogic(self.Player)
end

function GM_Command:UMGAnimationsTime(WidgetPath)
    -- 打印对应界面的所有动画时长 WidgetPath-UMG路径
    -- example: gm UAT /Game/UI/WBP/Common/Key/WBP_Com_KeyText.WBP_Com_KeyText
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    UWidgetLayoutLibrary.RemoveAllWidgets(GameInstance)

    local NewWidget = UIManager:CreateWidget(WidgetPath, true)
    if NewWidget == nil then
        ScreenPrint("can not find Widget")
        return
    end

    local AllAnimations = UE4.UUIFunctionLibrary.GetAllAnimationOfUserWidget(NewWidget)
    for _UIName, TargetAnimation in pairs(AllAnimations) do
        local AnimationTime = TargetAnimation:GetEndTime()
        DebugPrint("UMGAnimationsTime Widget:", WidgetPath, "AnimationName: ", _UIName, "Time: ", AnimationTime)
    end
end

function GM_Command:EMPlayWidgetAnimation(WidgetPath, AnimName)
    -- gm EMPWA /Game/UI/UI_PC/Battle/Battle_HitDirection_PC.Battle_HitDirection_PC HitDirection_IN
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    UWidgetLayoutLibrary.RemoveAllWidgets(GameInstance)

    local NewWidget = UIManager:CreateWidget(WidgetPath, true)
    if NewWidget == nil then
        ScreenPrint("can not find Widget")
        return
    end

    local AllAnimations = UE4.UUIFunctionLibrary.GetAllAnimationOfUserWidget(NewWidget)
    local TargetAnimation = AllAnimations:Find(AnimName)
    if TargetAnimation == nil then
        ScreenPrint("can not find Animation")
        return
    end

	-- local SubSystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self.Player, UEMUIEffectManager)
    -- SubSystem:EMPlayAnimation(NewWidget, TargetAnimation)
    EMUIAnimationSubsystem:EMPlayAnimation(NewWidget, TargetAnimation);
end

function GM_Command:HideAllUI(IsHide)
    -- gm HideAllUI
    local HideUI=true
    if IsHide=="0" then
        HideUI=false
    end
    local GameInstance = self:GetGameInstance()
    GameInstance.ImmersionModel=HideUI
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:HideAllUI(HideUI, "DefaultTag", true)
end

function GM_Command:PlayUMGAnimation(WidgetPath, Times, AnimName, CreatCount)
    -- 播放对应界面的动画 WidgetPath-UMG路径  AnimName-对应动画名称(空则全播) Times-次数
    -- example: gm PUA /Game/UI/WBP/Common/Key/WBP_Com_KeyText.WBP_Com_KeyText 10 PromptSpace 5
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    UWidgetLayoutLibrary.RemoveAllWidgets(GameInstance)

    if CreatCount == nil then
        CreatCount = 1
    end
    for i = 1, CreatCount do
        local NewWidget = UIManager:CreateWidget(WidgetPath, true)
        if NewWidget == nil then
            ScreenPrint("can not find Widget")
            return
        end

        if Times == nil then
            Times = 1
        end
        local AllAnimations = UE4.UUIFunctionLibrary.GetAllAnimationOfUserWidget(NewWidget)
        if AnimName == nil then
            local co
            co = coroutine.create(function()
                for i = 1, Times do
                    for _UIName, TargetAnimation in pairs(AllAnimations) do
                        DebugPrint("Play Current Animation ", _UIName)
                        local _, Proxy = UWidgetAnimationPlayCallbackProxy.CreatePlayAnimationProxyObject(nil, NewWidget, TargetAnimation, 0, 1, 0)
                        Proxy.Finished:Add(self, function ()
                            coroutine.resume(co)
                        end)
                        coroutine.yield()
                    end
                end
            end)
            coroutine.resume(co)
        else
            local TargetAnimation = AllAnimations:Find(AnimName)
            if TargetAnimation == nil then
                ScreenPrint("can not find Animation")
                return
            end
            local co
            co = coroutine.create(function()
                for i = 1, Times do
                    DebugPrint("Play Animation ", AnimName, " Times: ", i)
                    local _, Proxy = UWidgetAnimationPlayCallbackProxy.CreatePlayAnimationProxyObject(nil, NewWidget, TargetAnimation, 0, 1, 0)
                    Proxy.Finished:Add(self, function ()
                        coroutine.resume(co)
                    end)
                    coroutine.yield()
                end
            end)
            coroutine.resume(co)
        end
    end

end

function GM_Command:obj()
    URuntimeCommonFunctionLibrary.LogMaximumUObject()
end

function GM_Command:SwitchSurvivalValueChange()
    if IsStandAlone(self:GetGameInstance()) then
        local GameInstance = self:GetGameInstance()
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
        local GameState = UE4.UGameplayStatics.GetGameState(Player)
        if not Player then
            return
        end
        if Player.AddSurvivalValueTimer then
            Player:RemoveTimer(Player.AddSurvivalValueTimer)
            Player.AddSurvivalValueTimer = nil
        end
        Player.AddSurvivalValueTimer = Player:AddTimer(1, function()
            GameState:SetSurvivalValue(GameState.SurvivalValue + 100)
        end, true)
    else
        self:DedicatedServerCommand("SwitchSurvivalValueChange")
    end
end

function GM_Command:CreateMonstersBatches(list,number,level)
    local result = {}
    for word in string.gmatch(list, '([^,]+)') do
        table.insert(result, word)
    end
    for _,i in pairs(result) do
        self:ServerBattleCommand('CreateMonster', self.Player.Eid, i, number, level, "StaticCreator")
    end
end

function GM_Command:CutToughnessValue(Value)
    -- 控制削韧数值为给定值，参数不填时，默认一刀打空韧性
    -- example: gm ctn 100
    Value = Value and tonumber(Value) or 1000000
    self:ServerBattleCommand("CutToughnessValue", self.Player.Eid, Value)
    local _Battle = Battle(self.Player)  
    if _Battle then 
        _Battle:SetGMCuttoughnessValue(Value)
    end
end

function GM_Command:PrintCurrentTaskGuideInfo()
    DebugPrint("PrintCurrentTaskGuideInfo start===")
    local UIMgr = UIManager(self:GetGameInstance())
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self:GetGameInstance(), 0)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
    local PlayerRegionId = nil
    PlayerRegionId = Avatar.CurrentRegionId
    DebugPrint("PlayerRegionId:", PlayerRegionId)
    DebugPrint("PlayerLoc:", Player:k2_GetActorLocation())

    local Objs = MissionIndicatorManager:GetAllIndicatorUIObjs()
    if not IsEmptyTable(Objs) then
        local Index = 1
        for Name, Obj in pairs(Objs) do
            DebugPrint("========================")
            local ShowText = "折叠"
            if Obj.Visibility ~= UE4.ESlateVisibility.Collapsed and Obj.Guide_Node.Visibility == UE4.ESlateVisibility.SelfHitTestInvisible then
                ShowText = "显示"
            end

            local STLNodeId = 0
            if Obj.GuideInfoCache and Obj.GuideInfoCache.QuestNode and Obj.GuideInfoCache.QuestNode.QuestId then
                STLNodeId = Obj.GuideInfoCache.QuestNode.QuestId
            end

            DebugPrint("Indicator["..Index.."]："..ShowText)
            DebugPrint("WidgetName:", Name)
            DebugPrint("STLIndicatorType:", Obj.STLIndicatorType)
            if Obj.GuideInfoCache then
                DebugPrint("QuestChainId:", Obj.CurGuideChainId," STLNode:", STLNodeId)
                DebugPrint("PointType", Obj.GuideInfoCache.PointType, "TargetPointName:", Obj.GuideInfoCache.PointName, "MapPointName:", Obj.GuideInfoCache.PointOrStaticCreatorName)
                DebugPrint("Location:", Obj.TargetPointPos)
                DebugPrint("TaskRegionId:", Obj.TaskRegionId)
                if GuidePointLocData[Obj.GuideInfoCache.PointOrStaticCreatorName] then
                    local Data = GuidePointLocData[Obj.GuideInfoCache.PointOrStaticCreatorName]
                    DebugPrint("GuidePointLocData: X:",Data.X,",Y:", Data.Y,",Z:",Data.Z,",R:",Data.R,",SubRegionId:",Data.SubRegionId)
                else
                    DebugPrint("GuidePointLocData is nil")
                end
            end
           
            DebugPrint("========================")
            Index = Index + 1
        end
    end
    DebugPrint("PrintCurrentTaskGuideInfo end===")
end

function GM_Command:SetTaskGuidePointDebugMode(InNumger)
    local UIMgr = UIManager(GWorld.GameInstance)
    local Objs = MissionIndicatorManager:GetAllIndicatorUIObjs()
    if not IsEmptyTable(Objs) then
        for Name, Obj in pairs(Objs) do
            if tonumber(InNumger) == 1 then
                Obj.IsDebugMode = true
            else
                Obj.IsDebugMode = false
            end
        end
    end
end

function GM_Command:PrintAllAssetPath(EObjectType,UnitId)
    local _ObjType = tonumber(EObjectType)
    local _Id = tonumber(UnitId)
    local MeshNum = 0
    local MontageNum = 0
    local WeaponNum = 0
    local PreloadSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self.Player, UE4.URolePreloadGameInstanceSubsystem)
    DebugPrint("Montage:")
    local Temp = PreloadSystem:CommonPrepareAllBattleMontage(_ObjType,_Id)
    for _,Path in pairs(Temp) do
        MeshNum = MeshNum + 1
        DebugPrint(Path:GetOriginPath())
    end

    DebugPrint("Mesh:")
    Temp = PreloadSystem:CommonPrepareAllMesh(_ObjType,_Id)
    for _,Path in pairs(Temp) do
        MontageNum = MontageNum + 1
        DebugPrint(Path:GetOriginPath())
    end
    DebugPrint("Weapon:")
    local WeaponTags = {}
    for k,_ in pairs (DataMgr.WeaponTag) do
        table.insert(WeaponTags, k)
    end
    Temp = PreloadSystem:CommonPrepareAllWeaponMontage(WeaponTags,_ObjType,_Id)
    for _,Path in pairs(Temp) do
        WeaponNum = WeaponNum + 1
        DebugPrint(Path:GetOriginPath())
    end
    DebugPrint("End!!! Find MeshNum = ",MeshNum," MontageNum = ",MontageNum," Weapon = ",WeaponNum)
end


function GM_Command:PrintAllPreloadCacheInfo()
    UCharPreloadEMComponent.PrintAllCacheDebugInfo()
    URolePreloadGameInstanceSubsystem.PrintAllDebugInfo()
end
function GM_Command:PrintDynamicEventInfo(Id)
    local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
    local Message =ClientEventUtils.GetDynEventInfo(Id)
    URuntimeCommonFunctionLibrary.AddOnScreenDebugMessage(-1,5,FColor(255,255,255),Message,false,FVector2D(1,1))
    DebugPrint(Message)
end

function GM_Command:UseMobileUnitBudget(bEnable)
    local UnitBudgetMgr = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self.Player, UUnitBudgetAllocatorSubsystem)
	if UnitBudgetMgr then
        if tonumber(bEnable) == 0 then
            UnitBudgetMgr.bUseMobile = false
        else
            UnitBudgetMgr.bUseMobile = true
        end
	end
end

function GM_Command:DebugTickUnitBudget()
    local UnitBudgetMgr = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self.Player, UUnitBudgetAllocatorSubsystem)
	if UnitBudgetMgr then
        UnitBudgetMgr:Debug_TickUnitBudget()
    end
end

function GM_Command:OpenMonsterDebug()
    local Battle = UIManager(GWorld.GameInstance):GetUIObj("BattleMain")
    Battle.TakeAimIndicator.bOpenMonsterDebug = not Battle.TakeAimIndicator.bOpenMonsterDebug
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "EnableGDT")   
end


-- 触发崩溃的函数
function GM_Command:CrashTest(CrashName)
    CrashName = CrashName or "IllegalAccess"
    ScreenPrint("CrashTest CrashTest CrashTest", CrashName)
    URuntimeCommonFunctionLibrary.CrashTest(CrashName)
end

function GM_Command:EnableSkillPrediction()
    GM_Command.bEnableSkillPrediction = not Battle(self.Player).bEnableSkillPrediction
	Battle(self.Player).bEnableSkillPrediction = GM_Command.bEnableSkillPrediction
    
    self:ServerBattleCommand('EnableSkillPrediction', GM_Command.bEnableSkillPrediction)
end

function GM_Command:ForceSimPredictionFailed()

    GM_Command.bSimPredictionFailed = not Battle(self.Player).bSimPredictionFailed
    Battle(self.Player).bSimPredictionFailed = GM_Command.bSimPredictionFailed

    DebugPrint("gmy@GM_Command GM_Command:ForceSimPredictionFailed", GM_Command.bSimPredictionFailed)
    self:ServerBattleCommand('ForceSimPredictionFailed', GM_Command.bSimPredictionFailed)
end

function GM_Command:PrintPredictionDebugInfo(EidStr)
    if self.Player then
        if EidStr then
            local Eid = tonumber(EidStr)
            local Entity = Battle(self.Player):GetEntity(Eid)
            if Entity and Entity.PrintPredictionDebugInfo then
                Entity:PrintPredictionDebugInfo()
            end
        else
            self.Player:PrintPredictionDebugInfo()
        end
    end
end

function GM_Command:SetGamepad(KeySet)
    local GameInstance = self:GetGameInstance()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    if Player then
        Player:SwitchGamepadSet(tonumber(KeySet))
    end
end

function GM_Command:PrintBattleHistory(Verbosity, ...)
    -- 打印战斗历史, 参数为详细度 Verbosity, 过滤标签 Tag1, Tag2...
	-- example: gm history
    -- example: gm history 1
    -- example: gm history 1 Buff 
    -- example: gm history 1 Buff Skill
    Verbosity = Verbosity and tonumber(Verbosity) or 0
    local Tags = {...}
    local Filter = UE4.FBattleHistoryFilter()
    if Verbosity and Verbosity == 1 then 
        Filter.Verbosity = UE4.EBattleRecordVerbosity.Verbose
    else 
        Filter.Verbosity = UE4.EBattleRecordVerbosity.Normal
    end

    for _, Tag in ipairs(Tags) do
        Filter.TargetTags:Add(Tag)
    end

    Battle(self.Player):BP_PrintBattleHistory(Filter)
end

function GM_Command:ShowGetItemsTip(Type,Islose)
    --UIUtils.GetTreasureGroupNum(13101)
    local Params={}
    Params.InfoDataList={}
    if Type=="Blessing" then
        table.insert(Params.InfoDataList,DataMgr.RougeLikeBlessing[505])
        -- table.insert(Params.InfoDataList,DataMgr.RougeLikeBlessing[102])
        -- table.insert(Params.InfoDataList,DataMgr.RougeLikeBlessing[105])
    else
        table.insert(Params.InfoDataList,DataMgr.RougeLikeTreasure[14201])
        table.insert(Params.InfoDataList,DataMgr.RougeLikeTreasure[10102])
        table.insert(Params.InfoDataList,DataMgr.RougeLikeTreasure[10103])
    end
    if Islose then
        Params.Islose=true
    else
        Params.Islose=false
    end
    Params.ItemId =101
    Params.OldLevel = 1
    Params.NewLevel= 2
    UIManager(self):LoadUINew(UIConst.GetItemsTip, Params)
end

function GM_Command:TestTriggerAbyssOnEnd()
    self.AbyssLogicServerInfo={}
    self.AbyssLogicServerInfo.AbyssLevelId=3
    self.AbyssLogicServerInfo.AbyssId=1012
 --更新词条红点
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
     --赛季信息
    local AbyssInfo = Avatar.Abysses[self.AbyssLogicServerInfo.AbyssId]
    if not AbyssInfo then
        return
    end
    local AbyssLevelInfo = AbyssInfo.AbyssLevelList[self.AbyssLogicServerInfo.AbyssLevelId]
    if not  AbyssLevelInfo  then 
        return 
    end
    local IsPassed= AbyssLevelInfo:IsAbyssLevelPass()
    if IsPassed then
        return
    end
    local AbyssLevel = DataMgr.AbyssLevel
    local PreLevel=self.AbyssLogicServerInfo.AbyssLevelId
    local NowLevel=PreLevel+1
    local DungeonId1=AbyssLevel[PreLevel].AbyssDungeon1
    local NewDungeon1BuffIds={}
    local NewDungeon2BuffIds={}
    if DungeonId1 then
        local PreDungeon1BuffIds={}
        local NowDungeon1BuffIds={}
        if AbyssLevel[NowLevel] then
            local NowDungeonId1=AbyssLevel[NowLevel].AbyssDungeon1
            NowDungeon1BuffIds=DataMgr.AbyssDungeon[NowDungeonId1].AbyssBuffID
        end
        if AbyssLevel[PreLevel] then
            local PreDungeonId1=AbyssLevel[PreLevel].AbyssDungeon1
            PreDungeon1BuffIds=DataMgr.AbyssDungeon[PreDungeonId1].AbyssBuffID
        end
        for _, Buff2Id in pairs(NowDungeon1BuffIds) do
            local Isfind=false
            for _, Buff1Id in pairs(PreDungeon1BuffIds) do
                if Buff2Id==Buff1Id then
                    Isfind=true
                    goto continue
                end
            end
            ::continue::
            if not Isfind then
                table.insert(NewDungeon1BuffIds,Buff2Id)
            end
        end
    end
    local DungeonId2=AbyssLevel[PreLevel].AbyssDungeon2
    if DungeonId2 then
        local PreDungeon2BuffIds={}
        local NowDungeon2BuffIds={}
        if AbyssLevel[NowLevel] then
            local NowDungeonId2=AbyssLevel[NowLevel].AbyssDungeon2
            NowDungeon2BuffIds=DataMgr.AbyssDungeon[NowDungeonId2].AbyssBuffID
        end
        if AbyssLevel[PreLevel] then
            local PreDungeonId2=AbyssLevel[PreLevel].AbyssDungeon2
            PreDungeon2BuffIds=DataMgr.AbyssDungeon[PreDungeonId2].AbyssBuffID
        end
        for _, Buff2Id in pairs(NowDungeon2BuffIds) do
            local Isfind=false
            for _, Buff1Id in pairs(PreDungeon2BuffIds) do
                if Buff2Id==Buff1Id then
                    Isfind=true
                    goto continue
                end
            end
            ::continue::
            if not Isfind then
                table.insert(NewDungeon2BuffIds,Buff2Id)
            end
        end
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry1")
    local HasNew=false
    for _, Value in ipairs(NewDungeon1BuffIds) do
        local CacheKey = tostring(Value)
        if not CacheDetail[self.AbyssLogicServerInfo.AbyssId] then
            CacheDetail[self.AbyssLogicServerInfo.AbyssId]={}
        end
        if not CacheDetail[self.AbyssLogicServerInfo.AbyssId][CacheKey] then
            CacheDetail[self.AbyssLogicServerInfo.AbyssId][CacheKey]=true
            HasNew=true
        end
    end
    if HasNew then
        ReddotManager.IncreaseLeafNodeCount("AbyssEntry1")
    end
    HasNew=false
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry2")
    for _, Value in ipairs(NewDungeon2BuffIds) do
        local CacheKey = tostring(Value)
        if not CacheDetail[self.AbyssLogicServerInfo.AbyssId] then
            CacheDetail[self.AbyssLogicServerInfo.AbyssId]={}
        end
        if not CacheDetail[self.AbyssLogicServerInfo.AbyssId][CacheKey] then
            CacheDetail[self.AbyssLogicServerInfo.AbyssId][CacheKey]=true
            HasNew=true
        end
    end
    if HasNew then
        ReddotManager.IncreaseLeafNodeCount("AbyssEntry2")
    end
end

function GM_Command:ShowUpgradeTip(Id,BeforeLevel)
	local Params={}
		Params.ItemId = 105
		Params.OldLevel = 1
		Params.NewLevel= 2
		UIManager(self):LoadUINew(UIConst.UpgradeTip, Params)
end

function GM_Command:ForceStartDynQuest(DynQuestId)
    if DynQuestId then
        local DynQuest=DataMgr.DynQuest[tonumber(DynQuestId)]
        local RegionId=DynQuest.RegionId
        local TriggerBoxID=DynQuest.TriggerBoxID
        local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
        local SubRegionId
        if DataMgr.Region and DataMgr.Region[RegionId] then
            local SubRegions=DataMgr.Region[RegionId].IsRandom
            if SubRegions then
                SubRegionId=SubRegions[1]
            end
        end
        if GameMode then
            if SubRegionId then
                if DataMgr.DispatchUI[tonumber(DynQuestId)] then
                    local TeleportPoint = DataMgr.DispatchUI[tonumber(DynQuestId)].TeleportPointPos
                    if TeleportPoint then
                        SubRegionId = DataMgr.DynQuest[tonumber(DynQuestId)].SubRegionId
                        GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion,SubRegionId,TeleportPoint,nil,nil, true)
                        return
                    end
                end
                local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameMode, 0)
                local Avatar = GWorld:GetAvatar()
                if not Avatar then
                    return
                end
                local TelCallBack=function (...)           
                    local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
                        ClientEventUtils:StartDynamicEvent(tonumber(DynQuestId))
                        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
                        if not GameState then
                            return
                        end
                        local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
                        local StaticCreator = GameState.StaticCreatorMap:FindRef(TriggerBoxID)
                        if StaticCreator then
                        --GameMode:TriggerFallingCallable(Player, StaticCreator:GetTransform(), 0, true)
                            local Player=UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
                        local WCSubsystem = GameMode:GetWCSubSystem()
                            if not WCSubsystem then
                                return
                            end
                            local TargetTransform=StaticCreator:GetTransform()
                            TargetTransform.Translation=UE4.UNavigationFunctionLibrary.ProjectPointToNavigation3D(TargetTransform.Translation, WCSubsystem)
                            WCSubsystem:RequestAsyncTravel(Player, TargetTransform, 
                        {Player, 
                        function()
                            --OnTeleportSucceedDel()
                            -- GameMode:AddTimer(DataMgr.GlobalConstant.DeliveryBlackCurtainTime.ConstantValue, GameMode.HandleLevelDeliverBlackCurtainEnd, false, 0, "HandleLevelDeliver", true)
                        end
                        })
                    end
                end
                if Avatar:GetCurrentRegionId()~=SubRegionId then
                    --Avatar:AddRegionSkipCallback(SubRegionId, self, TelCallBack)
                    Avatar:StartJumpRegion(SubRegionId,TelCallBack)
                    --GameMode:HandleLevelDeliver(1, SubRegionId, 1, nil, true)
                    self:SkipRegion(1, SubRegionId, 1)
                else
                    TelCallBack()
                end
            end
        end
    else

    end
end

function GM_Command:CompleteAllDispatchCondion()
    for DispatchId, Dispatch in pairs(DataMgr.Dispatch) do
        self:CompleteSingleCondition(Dispatch.DispatchCondition)
    end
end

function GM_Command:TractedMonsterToPlayer(Speed,Time)
    local _Speed = tonumber(Speed) or 2000
    local _Time = tonumber(Time) or 500000
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    local Eids = TArray(0)
    for _,Mon in pairs(GameMode.EMGameState.MonsterMap) do
        Eids:Add(Mon.Eid)
    end
    URuntimeCommonFunctionLibrary.TractionActorsToCenter(ESourceTags.Skill,self.Player:K2_GetActorLocation(),_Speed,_Time,Eids,self.Player)
end

function GM_Command:TestTractedPlayer(Speed,Time)
    local _Speed = tonumber(Speed) or 200
    local _Time = tonumber(Time) or 500000
    local Eids = TArray(0)
    Eids:Add(self.Player.Eid)
    local Center = self.Player:K2_GetActorLocation()
    URuntimeCommonFunctionLibrary.TractionActorsToCenter(ESourceTags.Skill,Center,_Speed,_Time,Eids,self.Player)
end

function GM_Command:SkipAngling(bSkip)
    if not _G.bSkipAngling and bSkip then
        _G.bSkipAngling = true
    elseif _G.bSkipAngling and not bSkip then
        _G.bSkipAngling = false
    end
end

function GM_Command:ShowRegionmapPane(bEnabled)
    _G.ShowRegionmapPane = bEnabled == "1"
end

function GM_Command:SSRPlaySequence(RecorderId, StateId)
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    if GameMode.LevelSequenceStateRecorder then
        GameMode.LevelSequenceStateRecorder:PlaySequence(tonumber(RecorderId), tonumber(StateId))
    end
end


function GM_Command:StartFlow(Owner,FlowAsset)
    Owner=Owner or self.Player
    if not FlowAsset then
        FlowAsset=LoadObject('/Game/Dialogue/SpecialSideStory/2002/200234/510122.510122')
    end
    if UE.UEMFlowFunctionLibrary then
        local FlowSubsystem=UE.UEMFlowFunctionLibrary.GetFlowSubsystem(self.Player)
        if FlowSubsystem then
            FlowSubsystem:StartRootFlow(Owner,FlowAsset)
        end
    end
end

function GM_Command:StopFlow(Owner,FlowAsset)
    Owner=Owner or self.Player
    if not FlowAsset then
        FlowAsset=LoadObject('/Game/TestFlowAsset.TestFlowAsset')
    end
    if UE.UEMFlowFunctionLibrary then
        local FlowSubsystem=UE.UEMFlowFunctionLibrary.GetFlowSubsystem(self.Player)
        if FlowSubsystem then
            FlowSubsystem:StopRootFlow(Owner,FlowAsset)
        end
    end
end

--委托测试
function GM_Command:NewDeputeTest()
    Const.IsOpenNewDepute = true
end

function GM_Command:PrintCharModVolume()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 
    end
    for CharUuid, Char in pairs(Avatar.Chars) do
        DebugPrint("ZJT_ 11111111 PrintCharModVolume ",Char.CharId,Char:GetModVolume(),  Char.ModVolume, Char.ExtralModVolume or 0)
    end
end

-- 推理小游戏
function GM_Command:DetectiveMinigame(type, Id)
    if type == "UnlockQuestion" then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:DetectiveQuestionUnlockQuestion(tonumber(Id))
        end
    elseif type == "UnlockAnswer" then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:DetectiveQuestionUnlockAnswer(tonumber(Id))
        end
    elseif type == "OpenUI" then
        local UIManager = self:GetGameInstance():GetGameUIManager()
        UIManager:LoadUINew("DetectiveMinigame")
    elseif type == "OpenDetailUI" then
        UIManager(self):LoadUINew("DetectiveReasoningAni",function()
            UIManager(self):LoadUINew("DetectiveReasoningDetail", Id)
        end)
    end
end

-- 通用活动结算
function GM_Command:CommonActivitySettlement()
    
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local Params =
    {
        LevelScore = 500,
        IsWin = true,
        LevelTitle = "关卡标题",
        Text_Title = "标题文本",
        Text_GetReward = "获得奖励111",
        TitleColor = UE4.UUIFunctionLibrary.StringToSlateColor("FFFF00"),
        ScoreLineColor = UE4.UUIFunctionLibrary.StringToSlateColor("FFFF00"),
        ActivityId = 1030103,
    }
    -- Params.ScoreInfo_Left = {
    --     ["通关时达到100"] = true,
    --     ["通关时达到200"] = false,
    --     ["通关时达到300"] = true,
    -- }
    Params.ScoreInfo = {
        {text = "通关时达到12300", isFinish = true},
        {text = "通关时达到21330", isFinish = false},
        {text = "通关时达到31330", isFinish = true},
        {text = "通关时达到12", isFinish = true},
        {text = "通关时达到210", isFinish = false},
        {text = "通关时达到3130", isFinish = true},
    }

    Params.RewardIds = {
        1016,
        1017,
        1018,
    }

    Params.ExitCallback = function()
        local UIManager = GWorld.GameInstance:GetGameUIManager()
		UIManager:ShowUITip("CommonToastMain", GText("Minigame_Textmap_100305"))
    end

    -- Params.ContinueCallback = function()
    --     local UIManager = GWorld.GameInstance:GetGameUIManager()
	-- 	UIManager:ShowUITip("CommonToastMain", GText("Minigame_Textmap_100305"))
    -- end

    -- ActivityController:SetSettlementActivityId(Params.ActivityId)
    UIManager:LoadUINew("ActivitySettlement", Params)
end

function GM_Command:EnterTiaoPinGame()
    UIManager(GWorld.GameInstance):LoadUINew("TiaoPin")
end

function GM_Command:PinAttr(AttrName, Eid)
    -- 将目标角色的属性打印在屏幕上
    -- example: gm PinAttr Hp  显示玩家的血量
    -- example: gm PinAttr Hp 6 显示Eid为6的对象的血量
    -- example: gm PinAttr 清空屏幕上当前属性
    local Panel = UIManager(self.Player):LoadUI(UIConst.ATTRDEBUGPANEL, "AttrDebugPanel", UIConst.ZORDER_ABOVE_ALL)
    Panel:AddAttrWatcher(AttrName, Eid)
end

function GM_Command:ShowEids()
    local _ShowEids = function(IsShow)
        local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
        local PlayerLoc = self.Player:K2_GetActorLocation()
        for _, Target in pairs(Battle(self.Player).Entities) do
            if Target.IsCharacter and Target:IsCharacter() then
                local Comp = Target:GetComponentByClass(UCharDebugWidgetComponent:StaticClass())
                if not Comp then
                    local BPClass = LoadClass("/Game/BluePrints/ScreenDebug/BP_ScreenDebugComponent.BP_ScreenDebugComponent")
                    Comp = Target:AddComponentByClass(BPClass, false, UE4.FTransform(), false)
                    Comp:SetHiddenInGame(true)
                end
                if Comp then
                    if IsShow and Comp.bHiddenInGame then
                        local TargetLoc = Target:K2_GetActorLocation()
                        local Dis = FVector.Dist(PlayerLoc, TargetLoc)
                        if Dis < 1000 then
                            Comp:SetHiddenInGame(false)
                            Comp:K2_AttachTo(Target:K2_GetRootComponent(), "None", EAttachLocation.SnapToTargetIncludingScale, false)
                            Comp:K2_SetRelativeLocation(FVector(0, 0, 150), false, nil, false)
                            Comp:SetWidgetSpace(UE4.EWidgetSpace.Screen)
                            Comp:AddDebugTEXT("Eid", "Eid:"..tostring(Target.Eid))
                        end
                    elseif not IsShow and not Comp.bHiddenInGame then
                        Comp:SetHiddenInGame(true)
                    end
                end
            end
        end
    
        if self.IsShowingEids then
            self.IsShowingEids = nil
        else
            self.IsShowingEids = true
        end
    end

    if self.IsShowingEids then
        self.Player:RemoveTimer("ShowEidsTimer")
        _ShowEids(false)
    else
        _ShowEids(true)
        self.Player:AddTimer(1, function()
            _ShowEids(true)
        end, true, 0, "ShowEidsTimer")
    end


end

function GM_Command:OpenWalnutRewardDialog(Id)
    if not UIManager(self):GetUIObj("WalnutRewardDialog") then
        self.DetailWidget = UIManager(self):LoadUINew("WalnutRewardDialog", tonumber(Id))
    end
end

function GM_Command:VerifyArrayTest()
    local GameInstance = GWorld.GameInstance
    GameInstance:GmChangeVerifyArray()
end

function GM_Command:FloatVerifyArrayTest()
    local GameInstance = GWorld.GameInstance
    GameInstance:GmChangeFloatVerifyArray()
end

function GM_Command:CreateSquad(SquadName)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    Avatar:CallServerMethod("GMCreateSquad", SquadName)
end

function GM_Command:QuitGame(bForce)
    if bForce then
        GWorld.GameInstance.ForceQuitGame()
    else
        UKismetSystemLibrary.QuitGame(self.Player, nil, EQuitPreference.Quit, false)
    end
end

function GM_Command:SyncTest()
    local Paths = {
        "/Game/AssetDesign/Char/Monster/Jt_Pizhuo/BP_Mon_Jt_Pizhuo.BP_Mon_Jt_Pizhuo",
        "AnimBlueprint'/Game/AssetDesign/Char/Monster/Jt_Pizhuo/ABP_Mon_Jt_Pizhuo.ABP_Mon_Jt_Pizhuo_C'",
        "/Game/AssetDesign/AI/Monster/Jt_Pizhuo/BT_7Pizhuo.BT_7Pizhuo",
        "/Game/AssetDesign/Weapon/Monster/Melee/BP_Jt_Pizhuo.BP_Jt_Pizhuo",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Mesh/JT_Pizhuo_Physics",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Mesh/Jt_Pizhuo_SM",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Mesh/JT_Pizhuo_WP02_Physics",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Mesh/JT_Pizhuo_WP02_SM",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Mesh/JT_Pizhuo_WP_SK",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Mesh/JT_Pizhuo_WP_SM",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Mesh/JT_Pizhuo_WP_SM_Physics",
        "/Game/Asset/Char/Monster/Common/Part/Mesh/JT_Part02F_SM.JT_Part02F_SM",
        "/Game/Asset/Char/Monster/Common/Part/Mesh/JT_Part01L_SM.JT_Part01L_SM",
        "/Game/Asset/Char/Monster/Common/Part/Mesh/JT_Part01R_SM.JT_Part01R_SM",
        "/Game/Asset/Char/Monster/Common/Part/Mesh/JT_Part02B_SM.JT_Part02B_SM",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_CaughtDie_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_Die_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_GetUpBack_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_GetUpFront_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_HeavyHit_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_HitFly_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_HitFlyDie_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_LightHit1_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_LightHit2_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_LightHitRanged_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_StunBlind_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_StunBound_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_StunFire_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Hit/JT_Pizhuo_StunParalysis_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_Alarm01_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_Attack01_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_Attack02_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_C01_Attack01_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_C01_Attack02_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_C01_Skill01_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_DYZAlarmTest_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_ShakeIdle_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_Skill01_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_Skill02_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Combat/Skill/JT_Pizhuo_Skill03_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/Locomotion/JT_Pizhuo_Rotation_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/SpecialIdle/JT_Pizhuo_SpecialAlert_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/SpecialIdle/JT_Pizhuo_SpecialIdle01_End_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/SpecialIdle/JT_Pizhuo_SpecialIdle01_Montage",
        "/Game/Asset/Char/Monster/JT_Pizhuo/Animation/Montage/SpecialIdle/JT_Pizhuo_SpecialIdle02_Montage",
    }

    for _, Path in pairs(Paths) do
        UE4.UResourceLibrary.LoadObjectAsync(self.Player, Path, {})
    end
   
    LoadObject("NiagaraSystem'/Game/Asset/Effect/Niagara/Monster/A_Common/NS_Common_Part_Smash.NS_Common_Part_Smash'")
    -- LoadObject("NiagaraSystem'/Game/Asset/Effect/Niagara/Common/Monster/NS_knifehit_mon_dir.NS_knifehit_mon_dir'")
    -- LoadObject("NiagaraSystem'/Game/Asset/Effect/Niagara/Item/NS_Item_Base.NS_Item_Base'")
    -- LoadObject("WidgetBlueprint'/Game/UI/WBP/Battle/Widget/Aim/WBP_Battle_Aim_ShotGun.WBP_Battle_Aim_ShotGun'")
end

function GM_Command:ShowLookAtDebug(InNpcId, IsEnable)
    local enable = tonumber(IsEnable)
    local npcId = tonumber(InNpcId)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)

    if enable > 0 then
        if GameState then
            local TargetNpc = GameState.NpcCharacterMap:FindRef(npcId)
            if TargetNpc and TargetNpc.NpcAnimInstance then
                TargetNpc.NpcAnimInstance.IsLookAtDebug = true
            end
        end
    else
        if GameState then
            local TargetNpc = GameState.NpcCharacterMap:FindRef(npcId)
            if TargetNpc and TargetNpc.NpcAnimInstance then
                TargetNpc.NpcAnimInstance.IsLookAtDebug = false
            end
        end
    end
end

function GM_Command:StartLookAt(InNpcId, InLookatedNpcId, IsEnable)
    local enable = tonumber(IsEnable)
    local sourcenpcId = tonumber(InNpcId)
    local targetnpcId = tonumber(InLookatedNpcId)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)

    if enable > 0 then
        if GameState then
            local sourceNpc = GameState.NpcCharacterMap:FindRef(sourcenpcId)
            local targetnpc = GameState.NpcCharacterMap:FindRef(InLookatedNpcId)
            if targetnpcId == 1 then
                local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
                targetnpc = UE4.UGameplayStatics.GetPlayerCharacter(GameMode, 0)
            end
            if sourceNpc and sourceNpc.NpcAnimInstance and targetnpc then
                sourceNpc.NpcAnimInstance:SetLookAtActor(targetnpc, "head")
            end
        end
    else
        if GameState then
            local sourceNpc = GameState.NpcCharacterMap:FindRef(sourcenpcId)
            if sourceNpc and sourceNpc.NpcAnimInstance then
                sourceNpc.NpcAnimInstance:ResetNormalLookAt()
            end
        end
    end
end

function GM_Command:NPCMoveTo(InNpcId, InSpeed, InDistance)
    local NpcId = tonumber(InNpcId)
    local Speed = tonumber(InSpeed)
    local Distance = tonumber(InDistance)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if GameState then
        local TalkActor = GameState.NpcCharacterMap:FindRef(NpcId)
        TalkActor:SetMaxWalkSpeedBase(Speed)
       -- Speed = Speed * -1
        TalkActor:SetNpcMovementTickEnable(true)
        UAIBlueprintHelperLibrary.CreateMoveToProxyObject(TalkActor, TalkActor, 
                TalkActor:K2_GetActorLocation() + TalkActor:GetActorForwardVector() * Distance)
        --UE4.UAITask_MoveTo.AIMoveTo(, nil)
    end
end

function GM_Command:LookAtBySlerp(InNpcId, InLookatedNpcId, IsEnable, InTime)
    local enable = tonumber(IsEnable)
    local sourcenpcId = tonumber(InNpcId)
    local targetnpcId = tonumber(InLookatedNpcId)
    local Time = tonumber(InTime)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)

    if enable > 0 then
        if GameState then
            local sourceNpc = GameState.NpcCharacterMap:FindRef(sourcenpcId)
            local targetnpc = GameState.NpcCharacterMap:FindRef(InLookatedNpcId)
            if targetnpcId == 1 then
                local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
                targetnpc = UE4.UGameplayStatics.GetPlayerCharacter(GameMode, 0)
            end
            if sourceNpc and sourceNpc.NpcAnimInstance and targetnpc then
                sourceNpc.NpcAnimInstance.PitchSlerpAlpha.TotalTime = 10.0
                sourceNpc.NpcAnimInstance.YawSlerpAlpha.TotalTime = 1.0
                sourceNpc.NpcAnimInstance:SetLookAtActor(targetnpc, "head", true)
                sourceNpc.NpcAnimInstance.IsLookAtDebug = true
                sourceNpc.NpcAnimInstance:StartSlerpLookAt()
            end
        end
    else
        if GameState then
            local sourceNpc = GameState.NpcCharacterMap:FindRef(sourcenpcId)
            if sourceNpc and sourceNpc.NpcAnimInstance then
                sourceNpc.NpcAnimInstance:ResetNormalLookAt()
                sourceNpc.NpcAnimInstance.IsLookAtDebug = false
            end
        end
    end
end

function GM_Command:ControlAllMonsterBTTickEnable(bEnable)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    if bEnable == false then bEnable = false end
    for _, Target in pairs(GameState.MonsterMap) do
        Target:SetTickEnabled(ETickCtrlType.UnitBudget,ETickObjectFlag.FLAG_BTCOMPONENT,bEnable)
    end
end

function GM_Command:LJHTEST()
    --UIManager(self.Player):LoadUINew("FeinaEventReward")
    --UIUtils.OpenRaidReward()
    EventManager:FireEvent(EventID.OnDailyRefresh)
end

function GM_Command:TestGraphTask()
    UE4.UBattleFunctionLibrary.TestTaskGraphTask(self.Player)
end

function GM_Command:LHQTEST(InNpcId, InFlag)
    local npcId = tonumber(InNpcId)
    local flag = tonumber(InFlag)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if GameState then
        local TargetNpc = GameState.NpcCharacterMap:FindRef(npcId)
        local AssetPath1 = "AnimMontage'/Game/Asset/Char/Player/Char009_Xibi/Animation/Montage/Interactive/MechInteractive/Xibi_Interactive_Sit_F_Montage.Xibi_Interactive_Sit_F_Montage'"
        local AnimationAsset1 = LoadObject(AssetPath1)
        local AssetPath2 = "AnimMontage'/Game/Asset/Char/Player/Char010_Saiqi/Animation/Montage/Interactive/MechInteractive/Saiqi_Interactive_Sit_F_Montage.Saiqi_Interactive_Sit_F_Montage'"

        local AnimationAsset2 = LoadObject(AssetPath1)
        if TargetNpc and TargetNpc.NpcAnimInstance and flag == 1 then
            -- TargetNpc.NpcAnimInstance:Montage_Play(AnimationAsset1, 1.0, UE4.EMontagePlayReturnType.Duration)
            -- TargetNpc.NpcAnimInstance:Montage_Play(AnimationAsset1, 1.0, UE4.EMontagePlayReturnType.Duration)
            -- TargetNpc.NpcAnimInstance:Montage_Play(AnimationAsset2, 1.0, UE4.EMontagePlayReturnType.Duration)
            TargetNpc:RotateOffset(60)
        else
            -- TargetNpc.NpcAnimInstance:Montage_Play(AnimationAsset2, 1.0, UE4.EMontagePlayReturnType.Duration)
            TargetNpc:RotateOffset(-120)
        end
    end
end

function GM_Command:NPCRotate90(InNpcId, InAngle)
    local Angle = tonumber(InAngle)
    local NpcId = tonumber(InNpcId)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if GameState then
        local TargetNpc = GameState.NpcCharacterMap:FindRef(NpcId)
        TargetNpc.NpcAnimInstance:SetTurnInPlace90(TargetNpc.ModelId)
        TargetNpc:RotateOffset(Angle)
    end
end

function GM_Command:NPCRotate(InNpcId, InAngle)
    local Angle = tonumber(InAngle)
    local NpcId = tonumber(InNpcId)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if GameState then
       local TargetNpc = GameState.NpcCharacterMap:FindRef(NpcId)
       TargetNpc.NpcAnimInstance:SetTurnInPlace45()
       TargetNpc:RotateOffset(Angle)
    end
end

function GM_Command:NPCTalkAgree(InNpcId, InAgree)
    local NpcId = tonumber(InNpcId)
    local Agree = tonumber(InAgree)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if GameState then
        local TargetNpc = GameState.NpcCharacterMap:FindRef(NpcId)
        local AgreeAssetPath = "AnimMontage'/Game/Asset/Char/Player/Char028_Kajia/Animation/Montage/Locomotion/Kajia_Agree_Montage_Only_For_Test.Kajia_Agree_Montage_Only_For_Test'"
        local AgreeAsset = LoadObject(AgreeAssetPath)
        TargetNpc.NpcAnimInstance:Montage_Play(AgreeAsset)
        if Agree == 0 then
            TargetNpc.NpcAnimInstance:Montage_JumpToSection("Disagree", AgreeAsset) 
        end
    end
end

function GM_Command:NPCTalk03(InNpcId)
    local NpcId = tonumber(InNpcId)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if GameState then
        local TargetNpc = GameState.NpcCharacterMap:FindRef(NpcId)
        local Talk03AssetPath = "AnimMontage'/Game/Asset/Char/Player/Char028_Kajia/Animation/Montage/Interactive/Kajia_Emo_Talk03_Montage.Kajia_Emo_Talk03_Montage'"
        local TalkAsset = LoadObject(Talk03AssetPath)
        TargetNpc.NpcAnimInstance:Montage_Play(TalkAsset)
    end    
end

function GM_Command:NPCAgree(InNpcId, InAgree)
    local NpcId = tonumber(InNpcId)
    local Agree = tonumber(InAgree)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if GameState then
        local TargetNpc = GameState.NpcCharacterMap:FindRef(NpcId)
        local AgreeAssetPath = "AnimMontage'/Game/Asset/Char/Player/Char028_Kajia/Animation/Montage/Locomotion/Kajia_Agree_Montage_Only_For_Test.Kajia_Agree_Montage_Only_For_Test'"
        local AgreeAsset = LoadObject(AgreeAssetPath)
        TargetNpc.NpcAnimInstance.bEnableAgreeTest = true
        TargetNpc.NpcAnimInstance:Montage_Play(AgreeAsset)
        if Agree == 0 then
            TargetNpc.NpcAnimInstance:Montage_JumpToSection("Disagree", AgreeAsset)
        end       
    end  
end


function GM_Command:GM_SkipMonthCardPay()
    DebugPrint("GM_SkipMonthCardPay")
    local MonthCardController = require "BluePrints.UI.WBP.Perk.MonthCard.MonthCardController"
    MonthCardController.TryPurchaseMonthCard = function()
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:BuyMonthlyCard()
        end
    end
end

function GM_Command:DungeonDoubleCost(bDouble)
    local boolValue = bDouble and true or false
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:SetDungeonDoubleCost(boolValue)
    end
end

function GM_Command:GetWorldRegionEidByCreatorId(CreatorId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    local RegionData = GameMode:GetRegionDataMgrSubSystem().DataPool.RegionData
    if not RegionData then return end
    local Eid
    for _, value in pairs(RegionData) do
        if(value.CreatorId == tonumber(CreatorId)) then
            Eid = value.WorldRegionEid
            break
        end
    end
    if not Eid then
        ScreenPrint("can not find Eid")
        return
    end
    DebugPrint(CreatorId.."的Eid为 "..Eid)
end

function GM_Command:GetWorldRegionEidByManualItemId(ManualItemId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    local RegionData = GameMode:GetRegionDataMgrSubSystem().DataPool.RegionData
    if not RegionData then return end
    local Eid
    for _, value in pairs(RegionData) do
        if(value.ManualItemId == tonumber(ManualItemId)) then
            Eid = value.WorldRegionEid
            break
        end
    end
    if not Eid then
        ScreenPrint("can not find Eid")
        return
    end
    DebugPrint(ManualItemId.."的Eid为 "..Eid)
end

function GM_Command:GetWorldRegionEidByRandomRuleId(RandomRuleId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    local RegionData = GameMode:GetRegionDataMgrSubSystem().DataPool.RegionData
    if not RegionData then return end
    local EidTable = {}
    for _, value in pairs(RegionData) do
        if(value.RandomRuleId == tonumber(RandomRuleId)) then
            table.insert(EidTable,value.WorldRegionEid)
        end
    end
    if not EidTable then
        ScreenPrint("can not find Eid")
        return
    end
    for _, value in pairs(EidTable) do
        DebugPrint(RandomRuleId.."的Eid为 "..value)
    end

end


function GM_Command:EnablePropEffect(PropEffectId, IsOn)
    -- 启用/移除道具效果
    -- example: gm EnablePropEffect PropEffectId 0/1
    local PropEffectId = tonumber(PropEffectId)
    local IsOn = tonumber(IsOn)
    if not IsOn or not PropEffectId then
        return
    end
    if not DataMgr.PropEffect[PropEffectId] then
        return
    end
    local BPPath = DataMgr.PropEffect[PropEffectId].BPPath
    if IsOn == 1 then
        self.Player.PropEffectComponent:LoadPropEffect(BPPath)
    else
        self.Player.PropEffectComponent:UnloadPropEffect()
    end
end

function GM_Command:ShowSequenceTime(bOpen)
    if bOpen=="true" then
        ULevelSequenceCommonFunctionLibrary.CreateRunTimeSequenceTimeWidget(self.Player, self.Player)
    else
        ULevelSequenceCommonFunctionLibrary.DestroyRunTimeSequenceTimeWidget(self.Player, self.Player)
    end
end

function GM_Command:UWAUpLoad()
    local UserName = "17357126837"
    local Password = "yingxiongwudi123"
    local ProjectId = 11211
    UE4.UUWABlueprintFunctionLibrary.UpLLoad(UserName,Password,ProjectId)
end

function GM_Command:GenerateStripMesh(Number, XCount,YCount,UnitSize)
    local GameInstance = self:GetGameInstance()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local BaseLocation = PlayerCharacter:K2_GetActorLocation()

    -- 载入生成用的蓝图类
    local ActorClass = UE4.UClass.Load("/Game/BluePrints/Test/TestProceduralMesh.TestProceduralMesh")
    if not ActorClass then
        DebugPrint("Failed to load ProceduralMesh actor class.")
        return
    end

    for i = 1, Number do
        -- 每个生成位置都往 X 轴偏移一定距离，防止重叠
        local Offset = 300 * (i - 1)
        local Location = FVector(BaseLocation.X + Offset, BaseLocation.Y, BaseLocation.Z)

        local SpawnTransform = UE4.FTransform(FRotator(0, 0, 0), Location)

        local Actor = GWorld.GameInstance:GetWorld():SpawnActor(
            ActorClass,
            SpawnTransform,
            UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn,
            nil,
            self,
            nil
        )

        if Actor and Actor.GenerateStripMesh then
            Actor:GenerateStripMesh(XCount,YCount,UnitSize)
        else
            DebugPrint("Failed to spawn actor or GenerateStripMesh is nil.")
        end
    end
end

function GM_Command:PrintLevelbound(levelName)
    if levelName == nil then
        levelName = "Prologue_Clouds_Art"
    end
    local Player = self.Player
    local AllActors = UE4.UGameplayStatics.GetAllActorsOfClass(Player, ALevelBounds.StaticClass())
    local StreamingLevel = UE4.UGameplayStatics.GetStreamingLevel(Player, "Prologue_Clouds_Art")
    -- local PackageName = StreamingLevel.PackageNameToLoad
    -- DebugPrint("PackageName", PackageName)
    for _, Actor in pairs(AllActors) do
        local ActorLevel = UE4.URuntimeCommonFunctionLibrary.GetLevel(Actor)
        -- local LevelName = UE4.URuntimeCommonFunctionLibrary.GetLevelName(Actor)
        local LoadedLevel = StreamingLevel:GetLoadedLevel()
        if ActorLevel == LoadedLevel then
            local Transform = Actor:GetTransform()
            local Location = Transform.Translation
            local Rotation = Transform.Rotation
            local Scale = Transform.Scale3D
            DebugPrint(levelName.." Levelbound Location:", Location.X, Location.Y, Location.Z)
            DebugPrint(levelName.." Levelbound Rotation:", Rotation.X, Rotation.Y, Rotation.Z)
            DebugPrint(levelName.." Levelbound Scale:", Scale.X, Scale.Y, Scale.Z)
        end
        -- if StreamingLevelInfo == nil then
        --     local lastPart = ""
        --     if LevelName ~= "" then
        --         lastPart = string.match(LevelName, "/([^/]+)$") or ""
        --         if lastPart == "" then
        --             lastPart = LevelName
        --         end
        --     end
        --     if lastPart == levelName or lastPart == "UEDPIE_0_" .. levelName then
        --         local Transform = Actor:GetTransform()
        --         local Location = Transform.Translation
        --         local Rotation = Transform.Rotation
        --         local Scale = Transform.Scale3D
        --         DebugPrint(levelName.." Levelbound Location:", Location.X, Location.Y, Location.Z)
        --         DebugPrint(levelName.." Levelbound Rotation:", Rotation.X, Rotation.Y, Rotation.Z)
        --         DebugPrint(levelName.." Levelbound Scale:", Scale.X, Scale.Y, Scale.Z)
        --     end
        -- end
    end
end

-- 发布版将function都替换为空函数
if UE and UE.URuntimeCommonFunctionLibrary.IsDistribution() then
    for k, v in pairs(GM_Command) do
        if type(v) == "function" then
            GM_Command[k] = function() end
        end
    end
end

function GM_Command:PrintCustomNPCCacheInfo()
    local NPCCreateSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.Player, UE4.UNPCCreateSubSystem)
    if NPCCreateSubSystem then
        NPCCreateSubSystem:CustomNPCCacheDebug()
    end
end

function GM_Command:MechanismStateDebug(val)
    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    if GameState then
        val = tonumber(val)
        if val > 0 then
            GameState.MechanismStateChangeDebug = true
        else
            GameState.MechanismStateChangeDebug = false
        end
    end
end

function GM_Command:ShowBattleError(num)
    -- 测试战斗错误显示，num为1-2，1为ShowBattleError，2为StandardShowBattleErrorLua，3为走C++的StandardShowBattleErrorLua
    -- gm showbattleerror 1
    -- gm showbattleerror 2
    -- gm showbattleerror 3
    local battle = GWorld.Battle
    if not battle then
        ScreenPrint("Error:找不到GWorld.Battle")
        return
    end
    
    num = tonumber(num) or 1
    if num < 1 or num > 3 then
        ScreenPrint("参数错误，num应为1-3之间的整数")
        return
    end
    
    if num == 1 then
        battle:ShowBattleError("GM测试自定义信息", false)
    elseif num == 2 then
        -- local UIManager = GWorld.GameInstance:GetGameUIManager()
	    -- local BattleMain = UIManager:GetUIObj("BattleMain")
        -- BattleMain:AddTimer(5, function()
        --     battle:StandardShowBattleErrorLua(UE.EShowBattleErrorType.Weapon, "GM测试小类")
        -- end)
        battle:StandardShowBattleErrorLua(UE.EShowBattleErrorType.Weapon, "GM测试小类")
        
        -- 其他枚举值示例：
        -- battle:StandardShowBattleErrorLua(UE.EShowBattleErrorType.Creature, "创生物错误", "创生物ID: 67890")
        -- battle:StandardShowBattleErrorLua(UE.EShowBattleErrorType.Attribute, "属性错误", "属性计算异常")
        -- battle:StandardShowBattleErrorLua(UE.EShowBattleErrorType.Other, "其他错误", "未知错误类型")
    elseif num == 3 then
        -- 走C++的StandardShowBattleErrorLua函数
        if not self.Player then return end
        self.Player:ResetSkillCD(100000)
    end
end

function GM_Command:ShowUIError(ErrorCategory, Text)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then
        ScreenPrint("Error:找不到UIManager")
    end
    UIManager:ShowUIError(ErrorCategory, Text)
end

--打开自己的个人主页
---IsOtherPageKind 是否用服务端数据
function GM_Command:ShowPersonalInfoPage(IsOtherPageKind)
    if IsOtherPageKind then
        GWorld:GetAvatar():CheckOtherPlayerPersonallInfo(GWorld:GetAvatar().Uid,true)
    else
        local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
        PersonInfoController:OpenView()
    end
end

function GM_Command:UseResourceBattle(ResourceId)
    ResourceId = tonumber(ResourceId)
    
    if nil == self.ResourceUseHelper then
        self.ResourceUseHelper = require "Utils.ResourceUseHelper"
    end
    
    if self.ResourceUseHelper then
        self.ResourceUseHelper:ForceUseItemInBattle(ResourceId)
    end
end

function GM_Command:ApplyAFDTransform(TransformId)
    TransformId = tonumber(TransformId)

    if self.Player then
        self.Avatar:RegionOnlineTransformAFDay(TransformId)
        self.Player:ApplyAFDTransform(TransformId)
    end
end

function GM_Command:CancelAFDTransform()
    if self.Player then
        self.Avatar:RegionOnlineTransformAFDay(-1)
        self.Player:CancelAFDTransform()
    end
end

function GM_Command:EnableRegionPlayerOnlyShowHeadUI(Enable,Num)
    -- local GameInstance = GWorld.GameInstance
    -- local bEnable = Enable == "1"
    -- local AllowCreateNum = tonumber(Num)
    -- GameInstance.bRegionClientOnlyShowUI = bEnable
    -- UE4.URegionPlayerManagerSubsystem.SetIsOnlyShowPlayerHeadUI(bEnable)
    -- if AllowCreateNum then
    --     UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self.Player,"p.EM_RegionAllowCreatePlayerNum " .. Num,nil)
    -- end
end

function GM_Command:NPCSubSystemOnline(bOnline)
    local NPCCreateSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.Player, UE4.UNPCCreateSubSystem)
    if bOnline then
        NPCCreateSubSystem:SetIsOnlineState(true)
    else
        NPCCreateSubSystem:SetIsOnlineState(false)
    end
end

function GM_Command:NPCSubSystemChangeOnlineRegionId(NewID)
    local NPCCreateSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.Player, UE4.UNPCCreateSubSystem)
    NPCCreateSubSystem:TestChangeRegionOnlineId(tonumber(NewID))
end

function GM_Command:ReadyForRegonOnline()
    self:CompleteSystemCondition()
    self:CompleteCondition({100103, 100208})
    local GameInstance = self:GetGameInstance()
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm saq")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aac")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm macml")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aas")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aad")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aaw")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm mawml")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aar")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aaws")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aawa")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aamd")

    local A = GWorld:GetAvatar()
    A:GmGetAllTitle()
    A:GmGetAllTitleFrame()

    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aah")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm aahf")

    for PetId, value in pairs(DataMgr.Pet) do
        GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm PetAdd " .. PetId)
    end

    self:UnlockRegionTeleport(1)
    self:RandomChar()
    self:SkipRegion(1,999701,1)
end

function GM_Command:RandomChar()
    local A = GWorld:GetAvatar()
    A:ChangeBattleWheel(1,1,41022)
    A:ChangeBattleWheel(1,2,41017)
    A:ChangeBattleWheel(1,3,49996)
    A:ChangeBattleWheel(1,4,49998)
    A:ChangeBattleWheel(1,5,41011)
    A:ChangeBattleWheel(1,6,41010)
    A:ChangeBattleWheel(1,7,41019)
    A:ChangeBattleWheel(1,8,41013)

    local RandomKey = function(tbl, filter)
        local Keys = {}
        -- 收集所有 key
        for k in pairs(tbl) do
            if filter then
                if filter(k) then
                    table.insert(Keys, k)
                end
            else
                table.insert(Keys, k)
            end
        end
        
        if #Keys == 0 then
            return nil  -- 空表返回 nil
        end
        
        -- 随机选择一个 key
        local RandomIndex = math.random(1, #Keys)
        return Keys[RandomIndex]
    end

    local RandomValue = function(tbl, filter)
        local Keys = {}
        -- 收集所有 value
        for _, k in pairs(tbl) do
            if filter then
                if filter(k) then
                    table.insert(Keys, k)
                end
            else
                table.insert(Keys, k)
            end
        end
        
        if #Keys == 0 then
            return nil  -- 空表返回 nil
        end
        
        -- 随机选择一个 key
        local RandomIndex = math.random(1, #Keys)
        return Keys[RandomIndex]
    end
    local Uuid = RandomKey(A.Chars)
    A:SwitchCurrentChar(Uuid)

    local Weapons = {}
    for k,v in pairs(A.Weapons) do
        Weapons[v.WeaponId] = k
    end
    local MeleeWeaponUuid = RandomValue(Weapons, function(k)
        -- DebugPrint("ZJT_ 111", A.Weapons[k], A.Weapons[k]:IsMelee())
        return A.Weapons[k]:IsMelee()
    end)
    -- DebugPrint("ZJT_ 222",A.Weapons[MeleeWeaponUuid].WeaponId)
    A:SwitchWeapon(CommonConst.WeaponType.MeleeWeapon, MeleeWeaponUuid)
    
    local RangedWeaponUuid = RandomValue(Weapons, function(k)
        return A.Weapons[k]:IsRanged()
    end)
    A:SwitchWeapon(CommonConst.WeaponType.RangedWeapon, RangedWeaponUuid)

    local PetUniqueID = RandomKey(A.Pets)
    A:EquipPet(PetUniqueID)

    local CharId = A.Chars[Uuid].CharId

    local ChangeSkin = function( ... )
        local CommonChar = A.CommonChars[CharId]
        local SkinId = RandomKey(CommonChar.OwnedSkins)
        if SkinId then
            A:ChangeCharAppearanceSkin(Uuid, 1, SkinId)
        end

        for k,v in pairs(CommonConst.CharAccessoryTypes) do
            local AccessoryId = RandomValue(A.CharAccessorys, function(AccessoryId)
                return DataMgr.CharAccessory[AccessoryId].AccessoryType == k
            end)
            if AccessoryId then
                A:SetCharAppearanceAccessory(Uuid, 1, AccessoryId)
            end
        end

        if SkinId then
            local NewColorWithPart = {}
            for i=1,DataMgr.GlobalConstant.CharColorPart.ConstantValue do
                NewColorWithPart[i] = RandomKey(DataMgr.Swatch)
            end
            A:ChangeCharSkinColors(SkinId,NewColorWithPart,1)
        end

        local MeleeWeapon = A.Weapons[MeleeWeaponUuid]
        local SkinId = RandomKey(A.OwnedWeaponSkins, function(SkinId)
            local Skin = DataMgr.WeaponSkin[SkinId]
            return Skin.ApplicationType == MeleeWeapon.SkinApplicationType
        end)
        if not SkinId then
            SkinId = MeleeWeapon.WeaponId
        end
        A:ChangeWeaponAppearanceSkin(MeleeWeaponUuid, SkinId)

        local AccessoryId = RandomValue(A.WeaponAccessorys)
        if AccessoryId then
            A:ChangeWeaponAppearanceAccessory(MeleeWeaponUuid,  AccessoryId)
        end

        local NewColorWithPart = {}
        for i=1,DataMgr.GlobalConstant.WeaponColorPart.ConstantValue do
            NewColorWithPart[i] = RandomKey(DataMgr.Swatch)
        end
        -- PrintTable({NewColorWithPart=NewColorWithPart},10,"NewColorWithPart")
        A:ChangeWeaponSkinColors(MeleeWeaponUuid,SkinId,1,NewColorWithPart)


        local RangedWeapon = A.Weapons[RangedWeaponUuid]
        local SkinId = RandomKey(A.OwnedWeaponSkins, function(SkinId)
            local Skin = DataMgr.WeaponSkin[SkinId]
            return Skin.ApplicationType == RangedWeapon.SkinApplicationType
        end)
        if not SkinId then
            SkinId = RangedWeapon.WeaponId
        end
        A:ChangeWeaponAppearanceSkin(RangedWeaponUuid, SkinId)

        AccessoryId = RandomValue(A.WeaponAccessorys)
        if AccessoryId then
            A:ChangeWeaponAppearanceAccessory(RangedWeaponUuid,  AccessoryId)
        end

        NewColorWithPart = {}
        for i=1,DataMgr.GlobalConstant.WeaponColorPart.ConstantValue do
            NewColorWithPart[i] = RandomKey(DataMgr.Swatch)
        end
        -- PrintTable({NewColorWithPart=NewColorWithPart},10,"NewColorWithPart")
        A:ChangeWeaponSkinColors(RangedWeaponUuid,SkinId,1,NewColorWithPart)
    end
    ChangeSkin()

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    Player:AddTimer(1, function()
        local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(A)
        
        -- PrintTable({AvatarInfo=AvatarInfo},10,"AvatarInfo")
        Player:ChangeRole(CharId, AvatarInfo)
    end)
end

function GM_Command:ShowGlobalVersion()
    UIManager(self):ShowGlobalVersion()
end

function GM_Command:HideGlobalVersion()
    UIManager(self):HideGlobalVersion()
end

-- 解锁所有系统条件（服务器） 同时屏蔽引导和系统解锁提示
function GM_Command:CompleteSystemConditionWithoutGuide()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar.bGMHideUnlockPopup = true
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm sysu")
    self:SuccessAllSystemGuide()
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(8002))
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(4220))
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(4170))
    GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm CompleteCondition " .. tostring(2001))
    -- -- local function OnUIOpen(self,UIName)
    -- --     if UIName=="SystemUnlockGuide" then
    -- --         local GuideUI=UIManager(self):GetUIObj("SystemUnlockGuide")
    -- --         if GuideUI then
    -- --             GuideUI:Hide("CompleteSystemConditionWithoutGuide")
    -- --             GuideUI:Close()
    -- --         end
    -- --         EventManager:RemoveEvent(EventID.LoadUI, self)
    -- --     end
    -- -- end
    -- -- EventManager:RemoveEvent(EventID.LoadUI, self)
    -- EventManager:AddEvent(EventID.LoadUI, self, OnUIOpen)
    local GameInstance = self:GetGameInstance()
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100102")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100103")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100201")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100202")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100203")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100204")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100205")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100206")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100207")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 100208")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200101")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200102")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200103")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200104")
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm qcf 200215")
end
--- func desc
---@param OpenModel 1代表动作主人打开，2代表被邀请者打开
function GM_Command:OpenOnlineActionView(OpenModel)
    if not OpenModel then
        OpenModel=1
    else
        OpenModel=tonumber(OpenModel)
    end
    local OnlineActionController=require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
    if OpenModel==-1 then
        OnlineActionController:HideBtn()
    else
        OnlineActionController:ShowBtn(OpenModel)
    end
    OnlineActionController:GetModel():CreatFakeInvitationInfo()
end

function GM_Command:OpenMultiChallenge(ChallengeId)
     UIUtils.OpenMultiplayerChallengeLevelChoose(ChallengeId)
end

function GM_Command:SwitchMobileHUDLayout(Layout)
    local LayoutNumber = tonumber(Layout)
    EventManager:FireEvent(EventID.OnSwitchMobileHUDLayout, LayoutNumber)
end

function GM_Command:ChangeDSMonsterFramingNodeConfig(PlatformType,PlatformQualityLevel,MonQualityLevel,Key,Value)
    if not PlatformType or not PlatformQualityLevel or not MonQualityLevel or not Key or not Value then
        return
    end
    PlatformType = tonumber(PlatformType)
    PlatformQualityLevel = tonumber(PlatformQualityLevel)
    MonQualityLevel = tonumber(MonQualityLevel)
    Value = tonumber(Value)
    self:ServerBattleCommand('ChangeDSMonsterFramingNodeConfig',PlatformType,PlatformQualityLevel,MonQualityLevel,Key,Value)
end

function GM_Command:HideEntertainmentUI(Hide)
    local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
    if Hide == 0 or Hide == "0" then
        Hide = false
    else
        Hide = true
    end
    if Hide then
        GMVariable.HideEntertainmentUI = true
    else
        GMVariable.HideEntertainmentUI = false
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local Entertainment = UIManager:GetUIObj("Entertainment")
    if Entertainment then
        if Hide then
            Entertainment:SetRenderOpacity(0)
        else
            Entertainment:SetRenderOpacity(1)
        end
    end
    if Hide then
        EventManager:AddEvent(EventID.LoadUI, GMVariable.HideEntertainmentUIObj, function(obj, UIName)
            Entertainment = UIManager:GetUIObj("Entertainment")
            if Entertainment then
                if GMVariable.HideEntertainmentUI then
                    Entertainment:SetRenderOpacity(0)
                end
            end
        end)
    else
        EventManager:RemoveEvent(EventID.LoadUI, GMVariable.HideEntertainmentUIObj)
    end
end

function GM_Command:HideStoryUI(Hide)
    if Hide == 0 or Hide == "0" then
        Hide = false
    else
        Hide = true
    end
    local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
    if Hide then
        GMVariable.HideStoryUI = true
    else
        GMVariable.HideStoryUI = false
    end
    local TS = TalkSubsystem()
    local Tasks = TS:GetAllTasks()
    if Hide then
        for key, Task in pairs(Tasks) do
            if IsValid(Task.UI) then
                Task.UI:SetRenderOpacity(0)
            end
        end
    else
        for key, Task in pairs(Tasks) do
            if IsValid(Task.UI) then
                Task.UI:SetRenderOpacity(1)
            end
        end
    end

    if Hide then
        EventManager:AddEvent(EventID.LoadUI, GMVariable.HideStoryUIObj, function(obj, UIName)
            TS = TalkSubsystem()
            local Tasks = TS:GetAllTasks()
            if GMVariable.HideStoryUI then
                for key, Task in pairs(Tasks) do
                    if IsValid(Task.UI) then
                        Task.UI:SetRenderOpacity(0)
                    end
                end
            else
                for key, Task in pairs(Tasks) do
                    if IsValid(Task.UI) then
                        Task.UI:SetRenderOpacity(1)
                    end
                end
            end
        end)
    else
        EventManager:RemoveEvent(EventID.LoadUI, GMVariable.HideStoryUIObj)
    end
end

function GM_Command:GetAllOptPackages(Count)
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    local ResourceData = DataMgr.Resource
    if not Count then
        Count = 10
    end
    for ResourceId, ResourceInfo in pairs(ResourceData) do
        if ResourceInfo.MaterialClassify == 7 then
            GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm ar " .. ResourceId .. " " .. Count)
            DebugPrint("ayff test resourceid:"..ResourceId)
        end
    end
end

function GM_Command:ActorSnapShot(Begin, End)
    Begin = tonumber(Begin) or 0
    End = tonumber(End) or 10000

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not IsValid(Player) then
        Utils.ScreenPrint("Error: Player not found!")
        return
    end

    local AllActors = TArray(AActor)
    UE4.UGameplayStatics.GetAllActorsOfClass(Player, AActor:StaticClass(), AllActors)
    local ActorTable = AllActors:ToTable()
    -- Utils.ScreenPrint("Total Actors Count: "..tostring(#ActorTable))

    local ClassStaticMeshActor = UE4.AStaticMeshActor
    local ClassISMC = UE4.UInstancedStaticMeshComponent
    local TargetActors = {}

    for i, v in pairs(ActorTable) do
        if IsValid(v) then
            local bIsTargetType = false
            
            if v:IsA(ClassStaticMeshActor) then
                bIsTargetType = true
            elseif v:GetComponentByClass(ClassISMC) then
                bIsTargetType = true
            end

            if bIsTargetType then
                table.insert(TargetActors, v)
            end
        end
    end

    Utils.ScreenPrint("Static/Instanced Actors Count: " .. tostring(#TargetActors))

    local CenterLocation = Player:K2_GetActorLocation()
    local BeginSq = (Begin * 100) * (Begin * 100)
    local EndSq = (End * 100) * (End * 100)

    for i, v in pairs(TargetActors)  do
        local ActorLocation = v:K2_GetActorLocation()
        local DistanceSq = UE4.UKismetMathLibrary.VSizeSquared(ActorLocation - CenterLocation)

        local bInRange = DistanceSq >= BeginSq and DistanceSq <= EndSq

        if bInRange then
            if v:ActorHasTag("HiddenByActorSnapShot") then
                v:SetActorHiddenInGame(false)
                v.Tags:Remove("HiddenByActorSnapShot")
            end
        else
            if not v.bHidden then
                v:SetActorHiddenInGame(true)
                v.Tags:AddUnique("HiddenByActorSnapShot")
            end
        end
    end
end

function GM_Command:SetLockHpValue(LockHpValue)
    require("EMLuaConst").OpenCheckHPLock = true
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not IsValid(Player) then
        DebugPrint("SetLockHpValue Error: Player not found!")
        return
    end
    if not Player.BuffManager then
        DebugPrint("SetLockHpValue Error: Player BuffManager not found!")
        return
    end
    Player.BuffManager:SetLockHpValue(tonumber(LockHpValue) or 0)
end

function GM_Command:SetLockHpRate(LockHpRate)
    require("EMLuaConst").OpenCheckHPLock = true
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not IsValid(Player) then
        DebugPrint("SetLockHpRate Error: Player not found!")
        return
    end
    if not Player.BuffManager then
        DebugPrint("SetLockHpRate Error: Player BuffManager not found!")
        return
    end
    Player.BuffManager:SetLockHpRate(tonumber(LockHpRate) or 0)
end

function GM_Command:TeleportPlayer(PosX, PosY, PosZ)
    PosX = tonumber(PosX)
    PosY = tonumber(PosY)
    PosZ = tonumber(PosZ)
    local FinalPos = UE4.FVector(PosX, PosY, PosZ)
    local GameInstance = self:GetGameInstance()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance,0)
    Player:K2_SetActorLocation(FinalPos, false, nil, false)
end

function GM_Command:CreateAutoChessMonster(CombatChessId, Index, IsEnemy)
    EventManager:FireEvent(EventID.OnAutoChessCreateMonster, CombatChessId, Index, IsEnemy)
end

function GM_Command:RemoveAutoChessMonster(Index, IsEnemy)
    EventManager:FireEvent(EventID.OnAutoChessRemoveMonster, Index, IsEnemy)
end


function GM_Command:OpenFameMainUI(...)
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    local SystemUIConfig = DataMgr.SystemUI["FameMain"]
    if (SystemUIConfig ~= nil) then
        return UIManager:LoadUINew("FameMain", ...)
    end
end

-- 区域ID, OldLevel, OldExp, CurLevel, CurExp, OnlyShowLevel
function GM_Command:ReputationExpAdd(...)
    local RegionId, OldLevel, OldExp, CurLevel, CurExp, OnlyShowLevel = ...
    local ReputationExpAddInfo = {
        RegionId = tonumber(RegionId),
        OldLevel = tonumber(OldLevel),
        OldExp = tonumber(OldExp),
        CurLevel = tonumber(CurLevel),
        CurExp = tonumber(CurExp),
        OnlyShowLevel = OnlyShowLevel,
    }

    -- 声望值增加
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    local SystemUIConfig = DataMgr.SystemUI["ReputationLevelUp"]
    if (SystemUIConfig ~= nil) then
        return UIManager:LoadUINew("ReputationLevelUp", ReputationExpAddInfo)
    end
end

function GM_Command:OpenAutoChessUI()
    UIManager(self):LoadUINew("AutoChessMain")
end

-- 打开背包界面，临时使用，后续会接入正常流程
function GM_Command:SoloTreasureBag(MechanismUid)
    -- gm SoloTreasureBag 1
    local MechanismUid = tonumber(MechanismUid)
    local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
    UIManager(self):LoadUINew("SoloTreasureBag", MechanismUid, function(LoadedWidget)
        self.SoloTreasureBagUI = LoadedWidget
        DebugPrint("lgc@ SoloTreasureBag AsyncLoaded MechanismUid =", MechanismUid)
    end, "Async") 
end

-- 给指定的口袋添加Treasure，口袋名称为蓝图中的子控件名
-- PocketName: WBP_Type01_Bag04, Bag_Search, WBP_Type01_Bag01, WBP_Type01_Bag02, WBP_Type01_Bag03
function GM_Command:CreateNewTreasureItemToPocket(TreasureId, UniqueId)
    -- gm CreateNewTreasureItemToPocket Bag_Search 100102
    if not self.SoloTreasureBagUI then
        self.SoloTreasureBagUI = UIManager(self):GetUI("SoloTreasureBag")
    end
    if not self.SoloTreasureBagUI or not self.SoloTreasureBagUI.InventoryController then
        UIManager(self):ShowUITip("CommonToastMain", GText("添加Item失败,先打开背包界面再添加Item"), 2)
        return
    end
    self.SoloTreasureBagUI.InventoryController:UpdateTreasureItemDataServerNew(
        {
			SubBagIndex = 0,
			Id = TreasureId,
			BagIndex = 17,
			Pos = 0,
			Rotate = false,
			UniqueId = UniqueId,
		}
    )
end

function GM_Command:OpenReturnWelcomeBanner()
    UIManager(self):LoadUINew("ComBackWelcomeBanner")
end

function GM_Command:OpenSecPassWordUI(Mode, Min, Max, TextLimit, InitVal)
    Mode = Mode or 4
    Min = Min or 1
    Max = Max or 999999
    TextLimit = TextLimit or 10
    InitVal = InitVal or nil
    UIManager(self):LoadUINew("CommonNumInput", tonumber(Mode), {
        Min = tonumber(Min), Max = tonumber(Max), TextLimit = tonumber(TextLimit), InitVal = tonumber(InitVal)
    })
end

function GM_Command:VerifySecPassword()
    -- 接入方式一：
    local Callbacks_Style1 = {
        OnSuccess = function(Password)
            DebugPrint("[方式一] 回调成功！密码: " .. tostring(Password))
        end,
        
        OnCancel = function()
            DebugPrint("[方式一] 回调取消！")
        end
    }
    SecondaryPasswordController:RequestSecPasswordValidation(Callbacks_Style1)

    -- 接入方式二：
    -- local Callbacks_Style2 = {
    --     OnSuccess = {
    --         Obj = self,
    --         Func = self.Func
    --     },
        
    --     OnCancel = {
    --         Obj = self,
    --         Func = self.Func
    --     }
    -- }
    -- SecondaryPasswordController:RequestSecPasswordValidation(Callbacks_Style2)
end

function GM_Command:TestServerRandomCreator(DungeonId)
    DebugPrint("gmy@GM_Command GM_Command:TestServerRandomCreator", DungeonId)
    
    local SoloTreasureUtils = require "Utils.SoloTreasureUtils"
    DungeonId = tonumber(DungeonId)

    local RandomPointsMap = SoloTreasureUtils:GenerateRandomPointsList(DungeonId)
    
    if not next(RandomPointsMap) then
        DebugPrint(string.format("错误: 找不到DungeonId=%d的随机点数据或生成失败", DungeonId))
        return
    end
    
    DebugPrint(string.format("=== 副本随机点生成结果 (DungeonId=%d) ===", DungeonId))
    
    local TotalCount = 0
    for RandomRuleId, PointResults in pairs(RandomPointsMap) do
        local Points = {}
        for SDRCIndex, RandomTableId in pairs(PointResults) do
            table.insert(Points, {Index = SDRCIndex, TableId = RandomTableId})
        end
        
        table.sort(Points, function(a, b) return a.Index < b.Index end)
        
        local Count = #Points
        TotalCount = TotalCount + Count
        
        DebugPrint(string.format("  RandomRuleId=%d: 生成了%d个点", RandomRuleId, Count))
        for _, Point in ipairs(Points) do
            DebugPrint(string.format("    - SDRC索引=%d, 随机表ID=%d", Point.Index, Point.TableId))
        end
    end
    
    DebugPrint(string.format("总计: %d个随机点", TotalCount))
    DebugPrint("==========================================")
    
    return RandomPointsMap
end

function GM_Command:TestServerStaticCreator(DungeonId)
    DebugPrint("gmy@GM_Command GM_Command:TestServerStaticCreator", DungeonId)
    
    local SoloTreasureUtils = require "Utils.SoloTreasureUtils"
    DungeonId = tonumber(DungeonId)
    
    local StaticPointsList = SoloTreasureUtils:GenerateStaticPointsList(DungeonId)
    
    if #StaticPointsList == 0 then
        DebugPrint(string.format("错误: 找不到DungeonId=%d的静态点数据", DungeonId))
        return
    end
    
    DebugPrint(string.format("=== 副本静态点生成结果 (DungeonId=%d) ===", DungeonId))
    DebugPrint(string.format("总静态点数量: %d", #StaticPointsList))
    DebugPrint(string.format("静态点ID列表: %s", table.concat(StaticPointsList, ", ")))
    
    DebugPrint("==========================================")
    
    return StaticPointsList
end

function GM_Command:ShowWaterMark(Text)
    GWorld.GameInstance:GetGameUIManager():LoadUINew("WaterMark", Text)
end

function GM_Command:EnableShowLevelLoadingInfo(bEnabled)
    bEnabled = tonumber(bEnabled)
    if bEnabled == nil or bEnabled == 0 then
        bEnabled = false
    else
        bEnabled = true
    end
    local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
    GMVariable.EnableShowLevelLoadingInfo = bEnabled
    _G.EnableShowLevelLoadingInfo = bEnabled
end

function GM_Command:ExportAllAssetPathFromModelData()
    UE4.URolePreloadGameInstanceSubsystem.ExportAllAssetPathFromModelData()
end



function GM_Command:SetLOD(ActorName, ForceLODIndex)
    local GameInstance = self:GetGameInstance()
    if not GameInstance then
        return
    end
    
    local PlayerCharacters = TArray(APlayerCharacter)
    UGameplayStatics.GetAllActorsOfClass(GameInstance, APlayerCharacter:StaticClass(), PlayerCharacters)
    local MonsterCharacters = TArray(AMonsterCharacter)
    UGameplayStatics.GetAllActorsOfClass(GameInstance, AMonsterCharacter:StaticClass(), MonsterCharacters)

    local AttachedActors = TArray(AActor)
    

    for _, PlayerCharacter in pairs(PlayerCharacters) do
        local Name = PlayerCharacter:GetName()
        if Name == ActorName then
            local SkeletalMeshComponents = PlayerCharacter:K2_GetComponentsByClass(USkeletalMeshComponent)
            for _, SkeletalMeshComponent in pairs(SkeletalMeshComponents) do
                SkeletalMeshComponent:SetForcedLOD(tonumber(ForceLODIndex))
                DebugPrint(string.format("%s SetLOD to: %s", UKismetSystemLibrary.GetObjectName(SkeletalMeshComponent), ForceLODIndex))
            end
            
            PlayerCharacter:GetAttachedActors(AttachedActors)
            for _, AttachedActor in pairs(AttachedActors) do
                local AttachedActorSkeletalMeshComponents = AttachedActor:K2_GetComponentsByClass(USkeletalMeshComponent)
                for _, AttachedActorSkeletalMeshComponent in pairs(AttachedActorSkeletalMeshComponents) do
                    AttachedActorSkeletalMeshComponent:SetForcedLOD(tonumber(ForceLODIndex))
                    DebugPrint(string.format("%s SetLOD to: %s", UKismetSystemLibrary.GetObjectName(AttachedActorSkeletalMeshComponent), ForceLODIndex))
                end
            end
        end
    end

    for _, MonsterCharacter in pairs(MonsterCharacters) do
        local Name = MonsterCharacter:GetName()
        if Name == ActorName then
            local SkeletalMeshComponents = MonsterCharacter:K2_GetComponentsByClass(USkeletalMeshComponent)
            for _, SkeletalMeshComponent in pairs(SkeletalMeshComponents) do
                SkeletalMeshComponent:SetForcedLOD(tonumber(ForceLODIndex))
                DebugPrint(string.format("%s SetLOD to: %s", UKismetSystemLibrary.GetObjectName(SkeletalMeshComponent), ForceLODIndex))
            end

            MonsterCharacter:GetAttachedActors(AttachedActors)
            for _, AttachedActor in pairs(AttachedActors) do
                local AttachedActorSkeletalMeshComponents = AttachedActor:K2_GetComponentsByClass(USkeletalMeshComponent)
                for _, AttachedActorSkeletalMeshComponent in pairs(AttachedActorSkeletalMeshComponents) do
                    AttachedActorSkeletalMeshComponent:SetForcedLOD(tonumber(ForceLODIndex))
                    DebugPrint(string.format("%s SetLOD to: %s", UKismetSystemLibrary.GetObjectName(AttachedActorSkeletalMeshComponent), ForceLODIndex))
                end
            end
        end
    end
end

---对场景里的所有NPC 对给定的Animation Sequence，导出到动画序列的同文件夹下，加上头发的网格体名字后缀
function GM_Command:ExportHairAnimSequence(OldAnimSequencePath)
    -- GM ExportHairAnimSequence /Game/Asset/Char/Npc/Npc_Custom/CM_Zhongnian/Animation/Sequence/Locomotion/Npc_Zhongnian_F_Run_Loop.Npc_Zhongnian_F_Run_Loop
    -- GM ExportHairAnimSequence /Game/Asset/Char/Npc/Npc_Custom/CM_Zhongnian/Animation/Sequence/Interactive/Npc_Zhongnian_F_Emo_Idle.Npc_Zhongnian_F_Emo_Idle
    -- GM ExportHairAnimSequence /Game/Asset/Char/Npc/Npc_Custom/CM_Zhongnian/Animation/Sequence/Interactive/Npc_Zhongnian_F_Emo_Give.Npc_Zhongnian_F_Emo_Give
    if OldAnimSequencePath == '' then
        DebugPrint("输入的AnimSequencePath不能为空")
        return
    end

    local AnimSequence = LoadObject(OldAnimSequencePath)
    if not AnimSequence then
        DebugPrint(OldAnimSequencePath .. "加载失败")
        return
    end

    local Manager = UHairAnimSequenceExportManager.Get()
    if not Manager then
        return
    end
    local GameInstance = self:GetGameInstance()
    if not GameInstance then
        return
    end

    local OutNpcs = UE4.UGameplayStatics.GetAllActorsOfClass(GameInstance, UE4.ANpcCharacter)
    for _, Npc in pairs(OutNpcs) do
        local HairID = Npc.HairID
        if HairID then
            Manager:K2_ExportAnimSequence(Npc, AnimSequence)
        end

        break
    end
end



---对两个Character测试播放单个导出的AnimSequence效果，第一个播放导出，第二个播放原始动画
---@param HairAnimationSequencePath string 导出的头发动画的路径
function GM_Command:TestPlay(HairAnimationSequencePath)
    -- idle和give
    -- GM TestPlay /Game/Asset/Char/Npc/Npc_Custom/CM_Zhongnian/Animation/Sequence/Interactive/Npc_Zhongnian_F_Emo_IdleNpc_Zhongnian_F_Emo_Give_CM_ZNF_Hair06_SM.Npc_Zhongnian_F_Emo_IdleNpc_Zhongnian_F_Emo_Give_CM_ZNF_Hair06_SM
    -- GM TestPlay /Game/Asset/Char/Npc/Npc_Custom/CM_Zhongnian/Animation/Sequence/Locomotion/Npc_Zhongnian_F_Run_Loop_CM_ZNF_Hair06_SM.Npc_Zhongnian_F_Run_Loop_CM_ZNF_Hair06_SM
    if HairAnimationSequencePath == "" then
        return
    end

    local HairAnimationSequence = LoadObject(HairAnimationSequencePath)
    if not HairAnimationSequence then
        return
    end

    local Manager = UHairAnimSequenceExportManager.Get()
    if not Manager then
        return
    end

    local GameInstance = self:GetGameInstance()
    if not GameInstance then
        return
    end

    local Count = 1
    local OutNpcs = UE4.UGameplayStatics.GetAllActorsOfClass(GameInstance, UE4.ANpcCharacter)
    local BodyAnimationSequence = nil
    for _, Npc in pairs(OutNpcs) do

        if Count == 1 then
            local SkeletalMeshComponents = Npc:K2_GetComponentsByClass(USkeletalMeshComponent)
            for _, SkeletalMeshComponent in pairs(SkeletalMeshComponents) do
                local Name = UKismetSystemLibrary.GetObjectName(SkeletalMeshComponent)
                if Name == "Hair_SM" then
                    local SMName = UKismetSystemLibrary.GetObjectName(SkeletalMeshComponent.SkeletalMesh)
                    local Suffix = "_" .. SMName
                    local BodyAnimationSequencePath = HairAnimationSequencePath:gsub(Suffix, "")
                    BodyAnimationSequence = LoadObject(BodyAnimationSequencePath)
                    if not BodyAnimationSequence then
                        return
                    end

                    Manager:K2_PlayBodyAnimation(Npc, BodyAnimationSequence, true)
                    Manager:K2_PlayHairAnimation(Npc, HairAnimationSequence, true)

                end
            end
        else
            local SkeletalMeshComponents = Npc:K2_GetComponentsByClass(UMonSkeletalMeshComponent)
            for _, SkeletalMeshComponent in pairs(SkeletalMeshComponents) do

                Manager:K2_PlayBodyAnimation(Npc, BodyAnimationSequence, true)

            end
        end

        Count = Count + 1
    end
end



function GM_Command:GP()
    URuntimeCommonFunctionLibrary.EnableInsightsForGameplayEngine()
end
function GM_Command:GenerateNpcLocation(count)
    local GameInstance = GWorld.GameInstance
    if GameInstance then
        local TalkContext = GameInstance:GetTalkContext()
        if IsValid(TalkContext) then
            local res = TalkContext:GetNPCStandPositions(UE4.UGameplayStatics.GetPlayerCharacter(GameInstance,0), count, true)
            DebugPrint("GM_Command:GenerateNpcLocation", #res)
        end
    end
end

function GM_Command:TestGuildWarRanking()
    local PersonInfoModel = require "BluePrints.UI.WBP.PersonInfo.PersonInfoModel"
    local SerializeUtils = require "Utils.SerializeUtils"
    
    -- Mock MaxSquad (based on provided log structure)
    local MockSquadTable = {
        AvatarInfo = {
            CharacterInfo = {
                RoleInfo = { 
                    RoleId = 5301, 
                    Level = 80,
                    GradeLevel = 6,
                    BreakLevel = 0,
                    ModSuitIndex = 1
                },
                MeleeWeapon = {
                    WeaponId = 10204,
                    Level = 80,
                    EnhanceLevel = 6,
                    SkinId = 3010402
                },
                AppearanceSuit = {
                    SkinId = 5301,
                    IsShowPartMesh = true,
                    CharId = 5301
                }
            },
            PhantomInfo1 = {
                RoleInfo = { RoleId = 1801, Level = 80 }
            },
            PhantomInfo2 = {
                RoleInfo = { RoleId = 2401, Level = 80 }
            }
        },
        CommonCombatInfo = {
            pet_id = 4153,
            pet_level = 60
        }
    }
    
    local MockSquadStr = SerializeUtils:Serialize(MockSquadTable)
    
    local MockRankData = {}
    -- Create 3 mock records
    for i = 1, 3 do
        local Record = {
            SeasonId = 100 + i,
            Rank = i,
            PreRaidGroupId = 1, -- Default SSS (GroupId=1)
            Score = 10000 - (i * 1000), -- 分数差异拉大
            UpdateTime = os.time(),
            Squad = MockSquadStr, -- Changed from MaxSquad to Squad to match PersonInfoModel
            Nickname = "MockPlayer_" .. i,
            Uid = 10000 + i,
        }
        
        -- Use different IDs for subsequent records to show variety (optional)
        if i == 2 then
            -- Clone and modify for player 2 (Score: 9000 -> SSS/SS)
            local MockSquadTable2 = {
                AvatarInfo = {
                    CharacterInfo = {
                        RoleInfo = { RoleId = 1801, Level = 80 }, -- Use phantom as main
                        MeleeWeapon = { WeaponId = 10204, Level = 80 },
                        AppearanceSuit = { SkinId = 1801, CharId = 1801 }
                    },
                    PhantomInfo1 = {
                        RoleInfo = { RoleId = 5301, Level = 80 }
                    },
                    PhantomInfo2 = {
                        RoleInfo = { RoleId = 2401, Level = 80 }
                    }
                },
                CommonCombatInfo = { pet_id = 4153, pet_level = 60 }
            }
            Record.Squad = SerializeUtils:Serialize(MockSquadTable2) -- Changed from MaxSquad to Squad
            Record.Score = 5000 -- Lower score to trigger different grade (e.g. S or A)
            Record.PreRaidGroupId = 3 -- Set to S (GroupId=3)
        elseif i == 3 then
             -- Player 3 (Score: 8000 -> S/A)
             Record.Score = 2000 -- Much lower score
             Record.PreRaidGroupId = 4 -- Set to A (GroupId=4)
        end
        
        -- Insert into list (assuming UI iterates list)
        table.insert(MockRankData, Record)
    end
    
    -- Mock OtherPersonInfo for BaseInfo (required for PersonInfoModel:BuildGuildWarHistoryTopN)
    PersonInfoModel.OtherPersonInfo = {
        Uuid = 10001,
        Nickname = "MockTargetPlayer",
        Level = 80,
        HeadIconId = 1,
        HeadFrameId = 1,
        TitleBefore = 0,
        TitleAfter = 0,
        TitleFrame = 0
    }
    
    -- Inject data
    PersonInfoModel.DebugCachedRankData = MockRankData
    if ScreenPrint then ScreenPrint("TestGuildWarRanking: Cached Mock Data. Open Personal Info -> History Rank to see it.") end
    print("TestGuildWarRanking: Cached Mock Data into PersonInfoModel.DebugCachedRankData")
    
    -- No longer automatically opening the UI
    -- local Controller = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
    -- ... (removed logic)
end


return GM_Command
