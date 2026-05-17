---@class Const
local Const = {HOT_RELOAD = true}

Const.BattleHistoryTags = {
    "Skill",
    "Buff",
    "SkillEffect",
    "SkillCreature",
    "Summon",
    "Phantom",
    "MechanismSummon",
    "Mechanism",
    "Monster"
}

Const.VectorSizeZero = 0.00001
Const.NearZero = 0.0001
Const.LittleOffset = 0.1
Const.TestInt = 4
Const.SlideSpeed = 5000
Const.BulletJumpSpeed = 800
Const.MaxJumpCount = 2
Const.MaxBulletJumpCount = 1
Const.SpeedLowGravity = 150
Const.LowGravityScale = 1.5
Const.HighGravityScale = 2.8
Const.SlideBlendTime = 0.2
Const.AvoidDeccelerTime = 0.03
Const.DoSlideDelayTime = 0.1
Const.DefaultCD = 0
Const.BoneHitTime = 0.4

Const.Shoulder = 1
Const.Hand = 2
Const.Blend = 3

Const.NormalState = 0
Const.FirstJump = 1
Const.SecondJump = 2
Const.BulletJump = 3
Const.WallJump = 4
Const.JumpFall = 5
Const.Climb = 6
Const.FlipEaves = 7
Const.Flying = 8

Const.JumpFunctionIndex = {"FirstJump", "SecondJump", "BulletJump", "WallJump"}
Const.BulletJumpDebug = false
Const.DebugDruration = 3

Const.ClimbHeight = 176.682999
Const.RunStopStartTime = 0.13
Const.TransplantSize = 500
Const.NormalWallJump = "NormalWallJump"
Const.LeftSideWallJump = "LeftSideWallJump"
Const.RightSideWallJump = "RightSideWallJump"
Const.NormalWallJumpHeight = 300
Const.SideWallJumpHeight = 400
Const.SideWallJumpMultiply = 3
Const.GapDistance = 30
Const.GuidePointName = 'GuideManBornLoc'
Const.FallAttackPointName = 'BP_FallAttackPoint'


Const.Walking = 1
Const.Falling = 3
Const.Custom = 6
Const.Slide = 2

Const.InvincibleBuffId = 301
Const.SynthesisSpeedUpBuffId = 5000301
Const.MuteBuffId = 859900
Const.BossInvincibleBuffId = 6000212


------------- ALS EightToward Blend---------------
-- MoveDirection
Const.Forward = 0
Const.Right = 1
Const.Left = 2
Const.Backward = 3

--LerpSpeed
Const.VelocityBlendInterpSpeed = 12.0
Const.AimRotLerpSpeed = 30.0

Const.FwdThresholdR = 22.5
Const.FwdThresholdL = -22.5
Const.FRThresholdR = 67.5
Const.FLThresholdL = -67.5
Const.RThresholdRB = 112.5
Const.LThresholdLB = -112.5
Const.BckThresholdR = 157.5
Const.BckThresholdL = -157.5

-----------------------------
Const.FRThreshold = 60
Const.FLThreshold = -60
Const.BRThreshold = 120
Const.BLThreshold = -120

Const.Buffer = 5

Const.AllQuestChainType = -1
Const.MainQuestChainType = 1
Const.DailyQuestChainType = 2
Const.SideQuestChainType = 3
Const.MainActivityQuestChainType = 6
Const.LimTimeQuestChainType = 5
Const.SpecialSideQuestChainType = 4

Const.MontageBlendOutTime = 0.1


Const.CrouchWalkSpeed = 160
Const.NormalWalkSpeed = 500

Const.MaxClimbHeight = 100
Const.MinClimbHeight = 20
------------- ALS EightToward Blend---------------
--------------ALS FootIk And Hip Control----------
Const.RST_World = 0
Const.RST_Component = 2
Const.UpVector = FVector(0,0,1)
Const.ZeroVector = FVector(0,0,0)
Const.OneVector = FVector(1,1,1)
Const.UpFootHeight = FVector(0.0, 0.0, 50)
Const.DownFootHeight = FVector(0.0, 0.0, 45)
Const.XAxisVector = FVector(1,0,0)
Const.ZeroRotator = FRotator(0,0,0)
Const.FootCheckRadius = 15
Const.FootHeight = 10
Const.FootHeight2 = 9.5
Const.IkFootBoneHeight = 13
Const.ClampFootRot = 10
Const.StandSlopeThreshold = 0.75

Const.InterSpeedLevel0 = 5
Const.InterSpeedLevel1 = 10
Const.InterSpeedLevel2 = 15
Const.InterSpeedLevel3 = 30
Const.InterSpeedLevel4 = 40

Const.EnterIKDelay = 1

Const.DefaultAimRot = FRotator(0.5,0.5,0)
Const.RightAngle = 90
Const.HalfRightAngle = 45
Const.FlatAngle = 180
Const.Angle270 = 270
Const.FullAngle = 360

 Const.LowerPlayRate = 1.15
 Const.HigherPlayRate = 3
--------------ALS FootIk And Hip Control----------


Const.PushFactorSlide = 1
Const.PushFactorBulletJump = 1

Const.BulletClimbAngle = 45


Const.Enemy = 0
Const.Friend = 1
Const.Neutral = 2

Const.NormalAttack = 'Attack'
Const.FallAttack = 'FallAttack'
Const.HeavyAttack = "HeavyAttack"
Const.NormalSkill = 'Skill1'
Const.UltraSkill = 'Skill2'
Const.SummonRoleSupportSkill = 'Skill3'
Const.SupportSkill = 'Support'
Const.SlideSkill = 'SlideAttack'
Const.FireSkill = 'Shooting'
Const.HeavyShooting = 'HeavyShooting'
Const.OverHeatSkill = 'ShootingOverheat'
Const.ReloadSkill = 'Reload'
Const.CondemnSkill = 'Condemn'
Const.PassiveSkill = "Passive"
Const.ExtraPassiveSkill = "ExtraPassive"
Const.HomeBaseSubRegionId = 210101 --据点子区域Id
Const.IceCitySubRegionId = 101101 --据点子区域Id
-- 技能结束的原因
Const.StopUnknown = 0
Const.StopNormal = 1
Const.StopBySkillCancel = 2
Const.StopByWalkCancel = 3
Const.StopBySlideCancel = 4

Const.StateNormal = 0
Const.StateHitFly = 2
Const.StateHitFlyDown = 3
Const.StateHeavyHit_1 = 4
Const.StateHeavyHit_2 = 5
Const.StateLightHit = 6
Const.StateLightHitRanged = 7


Const.Player = 'Player'
Const.Monster = 'Monster'


Const.First = 1
Const.Second = 2

Const.SimulatedProxy = 1
Const.AutonomousProxy = 2
Const.Authority = 3

Const.AutoPickupDistance = 500
Const.ManualPickupDistance = 100

Const.LandHeavySpeed = -2000

Const.SummonInheritAttrs = {
    MaxHp = 1,
    Hp = 1,
    MaxES = 1,
    ES = 1,
    DEF = 1,
    SkillRange = 1,
    SkillSustain = 1,
    SkillEfficiency = 1,
    SkillIntensity = 1,
}

Const.HpAttrNames = {
    MaxHp = 1,
}

Const.ATKAttrNames = {
    ATK = 1,
    WeaponATKModifierRate = 1,
    -- WeaponATKModifierValue = 1,
}

Const.WeaponAttrTable = {
    --ATK = 1, 应用武器攻击力，由属性攻击力传递给角色，不需要特意设置
}

local AttrATKList = {}

for _AttrName, _ in pairs(DataMgr.Attribute) do
    local AttrName = "ATK_" .. _AttrName
    Const.ATKAttrNames[AttrName] = 1
    Const.WeaponAttrTable[AttrName] = 1
    table.insert(AttrATKList, AttrName)
    -- Const.SummonInheritAttrs[AttrName] = 1
end

Const.WeaponModifierAttrs = {
    WeaponATKModifierRate = {
        AttrNames = AttrATKList,
        RateAttr = "WeaponATKModifierRate",
        ValueAttr = "WeaponATKModifierValue",
        CalcATK = 1,
        RateIndex = CommonConst.RateIndex.GlobalATK, -- 总攻击力位于第二乘区
    },
    -- WeaponATKModifierValue = {
    --     AttrNames = AttrATKList,
    --     RateAttr = "WeaponATKModifierRate",
    --     ValueAttr = "WeaponATKModifierValue",
    --     CalcATK = 1,
    -- },
    AttackSpeedModifierRate_Normal = {
        AttrNames = {"AttackSpeed_Normal"},
        RateAttr = "AttackSpeedModifierRate_Normal",
        ValueAttr = "AttackSpeedModifierValue_Normal",
    },
    AttackSpeedModifierValue_Normal = {
        AttrNames = {"AttackSpeed_Normal"},
        RateAttr = "AttackSpeedModifierRate_Normal",
        ValueAttr = "AttackSpeedModifierValue_Normal",
    },
    AttackRangeModifierRate_Normal = {
        AttrNames = {"AttackRange_Normal"},
        RateAttr = "AttackRangeModifierRate_Normal",
        ValueAttr = "AttackRangeModifierValue_Normal",
    },
    AttackRangeModifierValue_Normal = {
        AttrNames = {"AttackRange_Normal"},
        RateAttr = "AttackRangeModifierRate_Normal",
        ValueAttr = "AttackRangeModifierValue_Normal",
    },
    AttackRangeModifierRate_Bullet = {
        AttrNames = {"AttackRange_Bullet"},
        RateAttr = "AttackRangeModifierRate_Bullet",
        ValueAttr = "AttackRangeModifierValue_Bullet",
    },
    AttackRangeModifierValue_Bullet = {
        AttrNames = {"AttackRange_Bullet"},
        RateAttr = "AttackRangeModifierRate_Bullet",
        ValueAttr = "AttackRangeModifierValue_Bullet",
    },
    WeaponCRIModifierRate = {
        AttrNames = {"CRI"},
        RateAttr = "WeaponCRIModifierRate",
        ValueAttr = "WeaponCRIModifierValue",
    },
    WeaponCRIModifierValue = {
        AttrNames = {"CRI"},
        RateAttr = "WeaponCRIModifierRate",
        ValueAttr = "WeaponCRIModifierValue",
    },
    WeaponCRDModifierRate = {
        AttrNames = {"CRD"},
        RateAttr = "WeaponCRDModifierRate",
        ValueAttr = "WeaponCRDModifierValue",
    },
    WeaponCRDModifierValue = {
        AttrNames = {"CRD"},
        RateAttr = "WeaponCRDModifierRate",
        ValueAttr = "WeaponCRDModifierValue",
    },
    TriggerProbModifierRate = {
        AttrNames = {"TriggerProbability"},
        RateAttr = "TriggerProbModifierRate",
        ValueAttr = "TriggerProbModifierValue",
    },
    TriggerProbModifierValue = {
        AttrNames = {"TriggerProbability"},
        RateAttr = "TriggerProbModifierRate",
        ValueAttr = "TriggerProbModifierValue",
    },
    MultiShootModifierRate = {
        AttrNames = {"MultiShoot"},
        RateAttr = "MultiShootModifierRate",
        ValueAttr = "MultiShootModifierValue",
    },
    MultiShootModifierValue = {
        AttrNames = {"MultiShoot"},
        RateAttr = "MultiShootModifierRate",
        ValueAttr = "MultiShootModifierValue",
    },
}

Const.WeaponModifierAttrChangers = {
    AttackSpeed_Normal = {
        BattleEvent = "AttackSpeedNormalChanged"
    }
}

Const.ROLE_None = 0
Const.ROLE_SimulatedProxy = 1
Const.ROLE_AutonomousProxy = 2
Const.ROLE_Authority = 3
Const.ROLE_MAX = 4

Const.NM_Standalone = 0
Const.NM_DedicatedServer = 1
Const.NM_ListenServer = 2
Const.NM_Client = 3
Const.NM_MAX = 4

Const.StatePrepare = 0
Const.StateGameModeReady = 1
Const.StateRunning = 2
Const.StateAlert = 3
Const.StateBattle = 4
Const.StatePause = 5
Const.StateEnd = 6
Const.ExitStateAlert = 7
Const.StateBattleProgress = 99

Const.ProgressRecoverDungeonType = {
    Survival = true,
    SurvivalPro = true,
    SurvivalMini = true,
    Defence = true,
    Excavation = true,
    Rouge = true
}

-- 副本报错大类，为功能模块
Const.DungeonErrorType = {
    DungeonGame = "拼接关玩法",
    StaticCreator = "静态刷新点",
    MonsterSpawn = "动态刷怪规则",
    Pet = "宠物系统",
    Common = "通用错误",
    Settlement = "结算系统",
    DungeonIndicator = "关卡指引",
    Mechanism = "机关",
    GameMode = "GameMode报错",
    DungeonDelivery = "副本传送点",
    DungeonVote = "副本投票",
}

-- 副本报错小类，为具体错误类别
Const.DungeonErrorTitle = {
    Config = "配置错误",
    CallTiming = "调用时机错误",
    FindObject = "找不到对象",
    Process = "流程错误",
    Implement = "方法未实现/参数不合法",
    ServerData = "服务器数据不存在",
    DataNil = "数据为空",
    Other = "其他错误",
}

Const.RegionErrorType = {
    RegionData = "区域数据",
    LevelProxy = "LevelProxy",
    RandomCreator = "随机点"
}

Const.RegionErrorTitle = {
    DataSthNil = "部分数据为空",
    DataType = "区域数据处理类型错误",
    CreatorNotFound = "静态点不存在",
    RandomCreatorNotFound = "随机点不存在",
    RalyIdNil = "RalyId为空",
    QuestNotDoing = "任务不在进行中",
    QuesDatatRepeated = "任务数据重复创建",
    DataNotFound = "数据不存在",
    LevelProxyNotFound = "LevelProxy不存在",
    CanNotCreate = "数据无法恢复",
    CanNotDestroy = "数据Actor无法销毁",
    GetRandomCreatorNil = "随机点GetCreator失败",
    GetRnadomParamActorNil = "随机点GetParamActorId失败"
}

Const.ServerDungeonType = {"SoloTreasure",}

Const.DungeonEnd_NoReason = 0 
Const.DungeonEnd_PlayerDead = 1
Const.DungeonEnd_DefenceCoreDead = 2

Const.ClientEventManagerClassPath = "/Game/AssetDesign/GameMode/ClientEventManager/BP_%sClientEventMananger.BP_%sClientEventMananger"

Const.BattleProgressTimerHandle = "BattleProgress"

Const.DunegonDeliveryPointUpdateInterval = 5
Const.DunegonDeliveryPointUpdateTimerHandle = "DunegonDeliveryPointUpdateTimerHandle"

Const.GameModeEventServer = 0
Const.GameModeEventServerClient = 1

Const.AimProtectYaw = 175
Const.MaXRotPercent = 0.12
Const.ShootAimLengthLR = 1
Const.ShootAimLengthDU = 1



Const.CrouchHalfHeight = 67.5
Const.CrouchShrinkSpeed = 160
Const.SlideHalfHeight = 45
Const.SlideShrinkSpeed =200
Const.BulletJumpHalfHeight = 44
Const.BulletJumpShrinkSpeed = 160
Const.SecondJumpHalfHeight = 44
Const.SecondJumpShrinkSpeed = 160
Const.WallJumpHalfHeight = 44
Const.WallJumpShrinkSpeed = 160

Const.CreateType = {Monster = 1, Npc = 1, CombatProp = 1, BattleChar = 1, Mechanism = 2, Phantom = 1}

Const.ScreenFadeMat = "Material'/Game/Asset/Char/Player/Common/Material/PP/MI_PP_ScreenFade.MI_PP_ScreenFade'"


Const.HitToLevel = {
    BoneHit = 1,
    LightHit = 2,
    LightHitRanged = 2,
    HeavyHit = 3,
    HitRepel = 4,
    HitFly = 5,
    GrabHit = 6,
}
Const.LevelToHit = {
    "BoneHit",
    "LightHit",
    "HeavyHit",
    "HitRepel",
    "HitFly",
    "GrabHit",
}

Const.CauseHitTypeNormal = 0
Const.CauseHitTypeFirst = 1
Const.CauseHitTypeDie = 2

Const.NormalStateInAlert = 0
Const.AlertState = 1
Const.FightState = 2
Const.EndBattleState = 3
Const.YXDNewState = 99

Const.PresetNone = 0
Const.PresetPlayer = 1
Const.PresetMechanism = 2

Const.SurvivalResourceItemId = 1006

Const.DefaultRoleId = 1101 -- 蓓蕾尼卡
-- Const.DefaultRoleId = 1102 -- 芙罗拉
-- Const.DefaultRoleId = 1103 -- 托斯卡
-- Const.DefaultRoleId = 1202 -- 法露茜
-- Const.DefaultRoleId = 1501 -- 暴怒
-- Const.DefaultRoleId = 1502 -- 妮弗尔夫人
-- Const.DefaultRoleId = 1503 -- 刻舟
-- Const.DefaultRoleId = 1504 -- 苏乙
-- Const.DefaultRoleId = 1801 -- 菲娜
-- Const.DefaultRoleId = 2101 -- 丽蓓卡
-- Const.DefaultRoleId = 2102 -- 伊微
-- Const.DefaultRoleId = 2301 -- 塔比瑟
-- Const.DefaultRoleId = 2401 -- 扶疏
-- Const.DefaultRoleId = 3101 -- 琳恩
-- Const.DefaultRoleId = 3102 -- 希尔妲
-- Const.DefaultRoleId = 3103 -- 耶尔
-- Const.DefaultRoleId = 3201 -- 海尔法
-- Const.DefaultRoleId = 3202 -- 卡米拉
-- Const.DefaultRoleId = 3301 -- 玛尔洁
-- Const.DefaultRoleId = 4101 -- 黎瑟
-- Const.DefaultRoleId = 4102 -- 止流
-- Const.DefaultRoleId = 4201 -- 煜明
-- Const.DefaultRoleId = 4202 -- 兰迪
-- Const.DefaultRoleId = 4301 -- 西比尔
-- Const.DefaultRoleId = 5101 -- 松露和榛子
-- Const.DefaultRoleId = 5102 -- 奥特赛德
-- Const.DefaultRoleId = 5301 -- 赛琪
-- Const.DefaultRoleId = 5401 -- 达芙涅
-- Const.DefaultRoleId = 5402 -- 莉莉蔻
-- Const.DefaultRoleId = 201 -- 阿瓦尔

-- 默认近战武器，覆盖填表，连服务器无效
Const.DeafaultMeleeWeapon = nil
 --Const.DeafaultMeleeWeapon = 10101 -- 辉珀刃
 --Const.DeafaultMeleeWeapon = 10102 -- 孤子的缚锁
 --Const.DeafaultMeleeWeapon = 10104 -- 慧谋的攻守
 --Const.DeafaultMeleeWeapon = 10201 -- 塞壬的拥吻
 --Const.DeafaultMeleeWeapon = 10203 -- 罪愆的逆鳞
 --Const.DeafaultMeleeWeapon = 10204 -- 希冀的丰稔
 --Const.DeafaultMeleeWeapon = 10301 -- 惩戒的炼火
 --Const.DeafaultMeleeWeapon = 10302 -- 铸铁者
 --Const.DeafaultMeleeWeapon = 10401 -- 失乡的獠牙
-- Const.DeafaultMeleeWeapon = 10402 -- 鎏金岁月
-- Const.DeafaultMeleeWeapon = 10501 -- 不渝的梦海
-- Const.DeafaultMeleeWeapon = 10502 -- 泽世的慈雨
-- Const.DeafaultMeleeWeapon = 10601 -- 红叶一滴
-- Const.DeafaultMeleeWeapon = 10602 -- 凋零


-- 默认远程武器，覆盖填表，连服务器无效
Const.DeafaultRangedWeapon = nil
 --Const.DeafaultRangedWeapon = 20101 -- 无序奇点
-- Const.DeafaultRangedWeapon = 20201 -- 赤猩猎弩
-- Const.DeafaultRangedWeapon = 20203 -- 蓝色脉动
-- Const.DeafaultRangedWeapon = 20301 -- 群星无意赦免
-- Const.DeafaultRangedWeapon = 20302 -- 炽枪的花宴
-- Const.DeafaultRangedWeapon = 20303 -- 赤猩加农炮
-- Const.DeafaultRangedWeapon = 20304 -- 归墟棘轮（贴地裂变）
-- Const.DeafaultRangedWeapon = 20305 -- 银白勒令（加特林）
-- Const.DeafaultRangedWeapon = 20401 -- 赤猩霰弹枪
-- Const.DeafaultRangedWeapon = 20402 -- 斑紫步枪（粘滞）
-- Const.DeafaultRangedWeapon = 20403 -- 圣裁步枪（追踪）
-- Const.DeafaultRangedWeapon = 20405 -- 爆破艺术（引爆）
-- Const.DeafaultRangedWeapon = 20501 -- 赤猩突击枪
-- Const.DeafaultRangedWeapon = 20502 -- 放逐怒雷（射线）
-- Const.DeafaultRangedWeapon = 20503 -- 祈请净火（喷火）
-- Const.DeafaultRangedWeapon = 20504 -- 破晓（激光）
-- Const.DeafaultRangedWeapon = 20507 -- 引浪小调（回旋）
-- Const.DeafaultRangedWeapon = 20601 -- 砂蚀长弓
-- Const.DeafaultRangedWeapon = 20602 -- 弧光百劫
-- Const.DeafaultRangedWeapon = 20603 -- 茵布拉花序
Const.DeafaultCharAccessoryTypes = {
    -- Back = 40001, --背部
    -- Head = 10001 , -- 头部
    -- Waist = nil, -- 腰部
    -- Face = 29998, --面部
    -- Fx = nil, --不知道是啥特效表里没有
    -- FX_Footprint = nil, -- 脚印特效
    -- FX_Body = nil, --幻纹
    -- FX_Teleport = nil, -- 传送特效
    -- FX_Dead = nil, --死亡特效
    -- FX_PlungingATK = 11002, -- 攻击特效
    -- FX_HelixLeap = 21003, --子弹跳特效 
    -- Special = nil, -- 不知道
    -- Ear = nil, --耳饰
}


Const.DefaultBattlePet = 101
Const.DefaultPetLocation = FVector(0, 50, 0)
Const.RandomLimitedPetRarity = 4

Const.NvZhuRoleId = 101
Const.NanZhuRoleId = 104

Const.DefaultKawaiiLinkLayer = "AnimBlueprint'/Game/AssetDesign/Char/Player/Heitao/ABP_Heitao_Kawaii.ABP_Heitao_Kawaii'"

Const.MouthSlotName = "FacialMouth"
Const.EyeSlotName = "FacialMouth"

Const.RougeLikeBuff = 10101101  -- 肉鸽类型Buff, 支持暂离恢复

Const.BuffDotDuration = 10
Const.BuffDotDamage = "Dot"
Const.BuffDotHot = "Hot"
Const.BuffDotAddShield = "AddShield"
Const.BuffDotSkillEffect = "SkillEffect"
Const.BuffDotSpChange = "SpChange"

Const.BuffDefaultFresnelParams = 
{
    FresnelColor = { 0.953125, 0.677123, 0.541725, 0 },
    FresnelColorRange = { Default = 0 },
    FresnelColorStrength = {Default = 0 }
}

Const.BuffDefaultNextPassParams = 
{
    NextPassShowyColor = { 0, 0, 0, 0 },
    NextPassShowy = { Default = 0 },
    NextPassShowyWidth = {Default = 0.3 }
}

Const.PathTypeNoNav = 0
Const.PathTypeNoPath = 1
Const.PathTypeHasPath = 2

Const.EmojiIdleDelay = 5
Const.EmoIdleVoiceCoolDown = 60

Const.WholeShootHoldTime = 10
Const.StopShootHoldDelay = 2

Const.ExtraFixVitamin = {"Mon.Strong.Poison",}

Const.BossMonster = {"Mon.Boss",}
Const.StrongMonster = {"Mon.Strong",}
Const.EliteMonster = {"Mon.Elite",}
Const.SummonLightMonster = {"Mon.Summon.Light",}
Const.CaptureMonster = {"Mon.Capture",}
Const.InvisibleMonster = {"Mon.Invisible",}
Const.SurvivalPoisonMonster = {"Mon.SurvivalPoison",}

Const.StrongBloodMonster = {"Mon.Strong.Blood",}
Const.StrongBurstMonster = {"Mon.Strong.Burst",}
Const.StrongFadeMonster = {"Mon.Strong.Fade",}
Const.StrongFrozenMonster = {"Mon.Strong.Frozen",}
Const.StrongPoisonMonster = {"Mon.Strong.Poison",}
Const.StrongShieldMonster = {"Mon.Strong.Shield",}
Const.StrongThunderMonster = {"Mon.Strong.Thunder",}

Const.MinusFindPathDist = 2000 --40m

Const.InitialCollisionProfileName = "meshcollision"
Const.HittedCollisionProfileName = "Ragdoll"
Const.DefaultBuffCollisionProfileName = "Ragdoll"

-- ESnapShotTime 调用CheckNeedSnapShot的时机 
Const.ECreatorInit = 0
Const.ECreateSuccess = 1
Const.ELevelUnloaded = 2

Const.AllSKillNames = {
    ESkillName.Skill1,
    ESkillName.Skill2,
    ESkillName.Skill3,
    ESkillName.Passive,
    ESkillName.Attack,
    ESkillName.FallAttack,
    ESkillName.HeavyAttack,
    ESkillName.SlideAttack,
    ESkillName.Fire,
    ESkillName.ChargeBullet,
    ESkillName.HeavyShooting,
}

Const.ArmoryIdleTags = {
    None = 'None',
    Armory = 'Armory',
    Armory_Mod = 'Armory_Mod',
    Armory_Grade = 'Armory_Grade',
    Armory_Pet = 'Armory_Pet',
    Armory_BullutJump = 'Armory_BullutJump',
    Armory_FallAttack_Sword = 'Armory_FallAttack_Sword',
}

Const.ArmoryWeaponIdleTags = {
    Armory_FallAttack = 'Armory_FallAttack',
}

Const.ArmoryWeaponIdleTag2WeaponType = {
    Armory_FallAttack = 'Melee',
}

Const.ArmoryActionIdToArmoryTag = {
	[1] = "Melee",
	[2] = "Ranged",
	[3] = "Armory",
	[4] = "Ultra",
	[5] = "Armory_Grade",
}

Const.MaxBatteryOneChar = 4
Const.MaxCrackKeyOneChar = 1
Const.MainCityID = 2101
Const.DefaultMainCityFile = "/Game/Maps/Chapter01_HomeBase"
Const.DefaultLoginSceneFile = "/Game/Maps/Login"
Const.DefaultOptionalPatchSceneFile = "/Game/Maps/OptionPatch"
Const.DefaultMainCityRegionId = 210101
Const.DefaultPrologueRegionId = 100103

Const.BaseSummonOffset = 100
local L = Const.BaseSummonOffset
Const.SummonOffset = {}

Const.HitFlyHeightMinValue = 50

for i=0,2 do
    for j=0,i do
        local k = i - j
        if k == 0 and j == 0 then
            table.insert(Const.SummonOffset, {k * L, j * L})
        elseif k == 0 then
            table.insert(Const.SummonOffset, {k * L, j * L})
            table.insert(Const.SummonOffset, {k * L, -j * L})
        elseif j == 0 then
            table.insert(Const.SummonOffset, {k * L, j * L})
            table.insert(Const.SummonOffset, {-k * L, j * L})
        else
            table.insert(Const.SummonOffset, {k * L, j * L})
            table.insert(Const.SummonOffset, {-k * L, j * L})
            table.insert(Const.SummonOffset, {k * L, -j * L})
            table.insert(Const.SummonOffset, {-k * L, -j * L})
        end
    end
end


-- Attr上限常量改为读表
Const.AttrLimit = {}
for AttrName, Data in pairs(DataMgr.AttrLimit) do
    --Const[AttrName] = Data.LimitValue
    if Data.AttachAttrName then
        Const.AttrLimit[Data.AttachAttrName] = Data.LimitValue
    end
end

Const.PlayerRecoverySkill = 20
Const.PlayerCondemnSkill = 30
Const.EmptyTNHpPercent = 0.3

Const.DefaultWeaponArmSocket = 'root_point'

Const.UseLocation = {
    Weapon = "Weapon",
    ChildWeapon = "ChildWeapon",
    Target = "Target",
    Char = "Char",
}

Const.DefaultSkillLevel = 1
Const.DefaultSkillGrade = 0
Const.DefaultCharGrade = 0
Const.DefaultWeaponGrade = 0

Const.DefaultPhantomSkillLevel = 1
Const.DefaultPhantomSkillGrade = 0

Const.MontageSuffix = "_Montage"

Const.GravityAcceleration = -980

Const.BodyAccessoryDropFrameCount = 3

-- Talk
Const.ShortPressThreshold =0.3
Const.LongPressThreshold =1.5
Const.TalkUIDeactiveTimeThreshold = 3
Const.TalkState_IsInTalk = "IsInTalk"
Const.TalkState_DisableMonsterSpawn = "DisableMonsterSpawn"
Const.TalkState_HiddenGameUI = "HiddenGameUI"
Const.Tag_GamePausedByTalk = "PausedByTalk"
Const.Talk_LevelSequenceActorPath = "/Game/BluePrints/Story/Talk/Base/BP_TalkSequenceActor.BP_TalkSequenceActor_C"
Const.MaxFloorDetection = 2000
-- Const.DecalHeight = 2000
Const.BuffEffectInterval = 2
Const.SkillCreatureSpeed = 1
Const.TalkSoundKey = "Talk_VO"
Const.ReviewSoundKey = "Review_VO"
Const.DialogueEffectSoundKey = "DialogueEffectSoundKey"
Const.TalkActionMontageGroupName = "TalkGroup"
Const.CharacterFacialMouthMontageGroupName = "TalkFacialMouth"
Const.CharacterFacialEyeMontageGroupName = "TalkFacialEye"


-- Mechanism
Const.ForceEndInteractive = 1
Const.NormalEndInteractive = 0

Const.NoInteractive = 0
Const.InteractiveStart = 1
Const.InteractiveWaitToEnd = 2

Const.ClickInteractive = 1
Const.PressInteractive = 2
Const.EndByTargetInteractive = 3

Const.EnableTaskPrintError = true

--- Optimization
Const.OpenFramingCreateUnit = {Npc = true, Monster = true, Drop = true,Mechanism = true}  -- 分帧创建Unit开关
Const.RegionSerializeUnitType = {Npc = 1, Monster = 1, Drop = 1, Mechanism = 1, Pet = 1, Phantom = 1}
Const.FrameCreateUnitCount = {Npc = 1, Monster = 1, Drop = 1, Mechanism = 1}
Const.MonsterCullDistance = 7000
Const.EnableTickLod = true
Const.EnableDungeonAssetsPreload = true
Const.DataMgrGCUseCount = 20
Const.DataMgrGCTablePercent = 0.5
Const.SkillCreaturePoolRefreshTime = 20
Const.SkillCreaturePoolCleanTime = 60
Const.SkillCreaturePoolDefaultPreloadNum = 100
Const.EnableMonsterPreloadPackage = true
Const.EnableNpcPreloadPackage = true
Const.OptimizationRegionRPC = true
Const.bSkipEQSTestWhilePlatformWarning = false
Const.NumOfEQSItemWhilePlatformWarning = 5
Const.EnablePlayerPreload = true
Const.EnableDungeonPhantomPreload = true
Const.EnableMonLevelChecker = true
Const.AndroidPlayDeathEffectDist = 1500
Const.EnableClientRpcDelay = true
Const.PushMonsterOptimizationLevel = 2
Const.BeginRagdollExecutePreFrame_PC = 3
Const.BeginRagdollExecutePreFrame_IOS = 3
Const.BeginRagdollExecutePreFrame_Android = 1
Const.bEnablePlayerRootMotionOptimizations = true

Const.CharResourcePaths = {
    DistructableBodyBp = "/Game/BluePrints/Item/AccessoryItems/BP_DestructablePart.BP_DestructablePart_C",
    AccessoryBP = "/Game/BluePrints/Item/AccessoryItems/BP_BodyAccessoryItem.BP_BodyAccessoryItem_C",
    StaticAccessoryBP = "/Game/BluePrints/Item/AccessoryItems/BP_BodyAccessoryStaticItem.BP_BodyAccessoryStaticItem_C",
}

Const.FixTraceChannel = {
    TraceCreatureHit = ETraceTypeQuery.TraceCreatureHit,
    TraceScene = ETraceTypeQuery.TraceScene,
}

Const.BlockTickLodTag = {
    SceneGuide = "SceneGuide",
    CharBillboard = "CharBillboard",
}
Const.EDungeonUIState = 
{
	None = 0,
	BeforeTarget = 1,
	OnTarget = 2,
	AfterTarget = 3
};

--存在刷光的静态网格体名称
Const.BrushStaticMesh = {
    --"SM_Dianchangji_01", --仓库目前取消交互
    "SM_Zhanshijia_01", --地图
    "地图B",  --地图
    "地图贴纸", --地图
}

Const.CharWaitInitTag = {
    AssetsLoading = "AssetsLoading",
    OverlapCheck = "OverlapCheck",
    HideInTalk = "HideInTalk",
}

-- AI
Const.EnableDynamicAIController = true
Const.FlyAIControllerPath = "/Game/BluePrints/AI/BP_EMMonFlyAIController.BP_EMMonFlyAIController_C"
Const.DefaultAIControllerPath = "/Game/BluePrints/AI/BP_EMAIController.BP_EMAIController_C"


-- 是否出生检查碰撞重叠
Const.EnableBornOverlapCheck = true

Const.MonsterPushFactor = 1.5
Const.MonsterMinPushVelocity = 200
Const.MonsterOverlapPushVelocity = 1000

Const.Patrol = 3
Const.Command = 4


------- 进度刻度 -------
Const.MaxLoadingPercentage = 100
Const.LoadingTipsInterval = 15

Const.MaxRecoverValue = 100 --复活进度到100时复活

Const.BossTNToZeroRecoverTickInterival = 0.1 -- Boss 韧性为0恢复的Tick间隔。
Const.MonsterTNRecoverTickInterival = 1 -- 怪物韧性恢复的Tick间隔（Boss 也会使用）。
Const.BossTNRecoverTickFrequency = 30  --韧性恢复的Tick频率

Const.DefaultHUDScale = 100     --默认HUD尺寸
Const.MinHUDScale = 50          --HUD最小尺寸
Const.MaxHUDScale = 150         --HUD最大尺寸

----------------ENetRole
Const.ROLE_None = 0
Const.ROLE_SimulatedProxy = 1
Const.ROLE_AutonomousProxy = 2
Const.ROLE_Authority = 3
Const.ROLE_MAX = 4

Const.SkillFeatureHideTag = "SkillFeature"
Const.ImmersionModelHideTag = "ImmersionModel"
Const.MiniGameHideTag = "MiniGame"
Const.TalkHideTag = "Talk"
Const.ShowUIOnlyTag = "DoShowUIOnly"
Const.BattleResurgenceHidTag = "BattleResurgence"
Const.BlackScreenHideTag = "BlackScreen"
Const.DungeonSettlementHideTag = "DungeonSettlement"
Const.GuideMainHideTag = "GuideMain"
Const.BossBattleOpenHideTag = "BossBattleOpen"
Const.LevelSequenceStateRecorderTag = "LevelSequenceStateRecorder"

Const.BossOpeningEnsureTime = 30
Const.HardBossDgPrepareAirwallId = 11012

Const.Common = 0
Const.Hijack = 1
Const.RougeLike = 2

Const.GatherMaxTime = 5

Const.MinTimeDilation = 0.001

Const.Skill = "Skill"
Const.Melee = "Melee"
Const.Ranged = "Ranged"

Const.SequenceNpcMeshBoundScale = 5 -- NPC绑定到Sequence上修改的边界缩放，防止渲染剔除。

Const.BreakableJsonPath = "Script/Datas/Houdini_data/Prologue/PrologueBreakableFile/"

Const.ScalabilityUpdateTime = 0


Const.ScalabilityLevelVeryLow = 0
Const.ScalabilityLevelLow = 1
Const.ScalabilityLevelMiddle = 2
Const.ScalabilityLevelHigh = 3
Const.ScalabilityLevelVeryHigh = 4

Const.BanSmallLevelScalabilityLevel = {}


-- 削韧等级压制
Const.CutTNLevelThreshold = 10
Const.CutTNLevelModifer = 1.0

Const.AccessEnterDefeated = 0
Const.CantEnterDefeated = 1
Const.DefeatedStopNotify = 2
Const.DefeatedEndToIdle = 3

-- 连击Combo清空原因
Const.ClearCombo_Timelimit = 0
Const.ClearCombo_Dead = 1 
Const.ClearCombo_SkillEffect = 2
Const.ClearCombo_DisableUltraWeapon = 3
Const.ClearCombo_ChangeWeapon = 4

Const.MaxPhantomNum = 2 -- 战斗中每个角色可以召唤出的最大魅影个数
Const.MaxPhantomNum2Player = 1 -- 两名玩家时战斗中每个角色可以召唤出的最大魅影个数
Const.MaxPhantomNumOver2Player = 0 -- 超过两名玩家时战斗中每个角色可以召唤出的最大魅影个数

-- 持久化掉落物类型
Const.SavePickupType = {
    GetWeapon = 1,
    GetMod = 1,
    GetResource = 1,
}

-- 铸造弹窗ID
Const.Popup_GetProduceItem = 100017
Const.Popup_StartProduce = 100014
Const.Popup_CancelProduce = 100154
Const.Popup_BatchStartProduce = 100153
Const.Popup_AccerateProduce = 100018
Const.Popup_ConfirmLockedMod = 100098
Const.Popup_ConfirmUpgradedMod = 100099

Const.StunTag = "Stun"

--- DedicatedServer Const
Const.DS_Default_GroupId = 101 -- DS所在跨服组ID，这个值应该由外部传入替换
Const.DSVersion = 0 -- DS版本号
---

--- 网络相关
Const.NetWorkFailure_Tag = "NetWorkFailure"
Const.NET_CLIENT_SEND_HEARTBEAT_TIME = 60 -- 客户端发送心跳包间隔
Const.NET_CLIENT_HEARTBEAT_WARNING = 5 -- 客户端心跳包丢失警告判定间隔
Const.NET_CLIENT_HEARTBEAT_TIMEOUT = 13 -- 客户端心跳包检测判定断线间隔

-- 技能重置特殊ID
Const.DefaultResetPressSkillId = 0
Const.UseOriginSkillId = -1

-- 二次确认弹窗
Const.Popup_SecondConfirm = 100027

-- 结算界面
Const.Popup_CombatData = 100052  -- 战斗数据弹窗
Const.RoleBarLength = 202.5

-- 结算MVP
-- Const.MVPMontagePath = '/Game/Asset/Char/Player/Char001_Heitao_J/Animation/Montage/Interactive/MVPShow/Heitao_MVPShow_01_Montage.Heitao_MVPShow_01_Montage'

Const.BattleCharTagVXScaleTable = { -- 不同体型角色特效缩放比例
    ["Loli"] = {0.8, 0.8, 0.8},
    ["Girl"] = {1, 1, 1},
    ["Man"] = {1.2, 1.2, 1.2},
    ["Woman"] = {1.1, 1.1, 1.1},
    ["Boy"] = {1, 1, 1},
}

-- Mod升级确认弹窗
Const.Popup_ModUpgrade = 100045
Const.Popup_ModPolarity = 100050
Const.Popup_ModAutoPutOn = 100066

Const.BarriyBuffId = 50
Const.CrackKeyBuffId = 51

Const.SkillFeatureCD = 30
Const.bEnableSkillFeatureCD = true

-- 隐藏技能CD提示
Const.bHideSkillCD = 1

-- 拼接关默认背景蓝图
Const.DungeonBgBluePrint = '/Game/UI/UI_PC/LevelSelect/LevelSelect_Bg/LevelSelect_Bg_Training.LevelSelect_Bg_Training'
-- 登录背景蓝图
Const.LoadingBgBluePrint = '/Game/UI/UI_PC/LevelSelect/LevelSelect_Bg/LevelSelect_Bg_Login.LevelSelect_Bg_Login'

-- 直充商品列表
Const.ReChargeLst = {
    [1] = 110101,
    [2] = 110102,
    [3] = 110103,
    [4] = 110104,
    [5] = 110105,
    [6] = 110106,
}

-- 血条UI预扣血相关
Const.BloodBarAnimTime = 0.3
Const.BloodBarDelayTime = 0.1

-- data_phone信号强度ui
Const.SignalStrength = {
    30,90,150
}

Const.PlayerSignatureIllegal = 26005
Const.PlayerNicknameIllegal = 26006

--战斗中出现的提示的CD
Const.BattleTip_CommonTop_CD = 0.5

Const.BehaviorId = 
{
	Stroll = 0,
	LoopMontage = 1,
	MontageList	= 2,
	Patrol = 3,
	Command = 4,
}

Const.TestGMRegionType = {
    NoneTest = 0,
    OnlyServer = 1,
    CompareServer = 2,
}

Const.RegionDataTypeDebugText = {
    "非存储数据",
    "关卡数据, 永不卸载",
    "任务数据",
    "探索组数据",
    "Boss数据",
    "关卡数据, 每一天清除",
    "关卡数据, 每三天清除",
    "关卡数据, 每一周清除",
    "跨任务数据",
}

Const.RegionDataStorageType = {
    -- 1,3,5,6,7
    ERegionDataType.RDT_CommonData,
    ERegionDataType.RDT_RarelyData,
    ERegionDataType.RDT_CommonDailyData,
    ERegionDataType.RDT_CommonTriduumData, 
    ERegionDataType.RDT_CommonWeeklyData, 
    ERegionDataType.RDT_CommonQuestData,
}

Const.RougeSliceInfoType = {
    None = 0,
    RecoverCount = 1,
    TreasureMonCount = 2,
    BlueprintValue = 3,         -- 蓝图自定义值
}

Const.DUNGEON_MATCH_BAR_STATE =
{
	SPONSOR_WAITING_CONFIRM = 1,		-- 发起者等待确认
	TEAMMATE_CONFIRMING = 2,			-- 队友确认中
	TEAMMATE_WAITING_CONFIRMING = 3,	-- 队友等待其他队友确认
	WAITING_MATCHING = 4,				-- 等待匹配游戏
	WAITING_MATCHING_WITH_CANCEL = 5,	-- 等待匹配游戏(可取消)

	WAITING_ENTER_DUNGEON = 6,			-- 进入游戏中
}

Const.CampType =
{
    Monster     = ECampName.Monster,
    Player      = ECampName.Player,
    DefenceCore = ECampName.DefenceCore,
    NPC         = ECampName.NPC,
    Neutral     = ECampName.Neutral,
    Hostile     = ECampName.Hostile,
}

Const.EnableCreateUnitLog = false
Const.IsOpenNpcInitOpt = true
Const.IsOpenNpcGetBattleCharTag = true
Const.IsNpcUseNavFixPawnLoc = false
Const.IsOpenCustomNPCCategory = false
Const.IsOpenEscortNPCPhantomOpt = true
Const.EnableFXOptimization = true  -- 特效LOD优化开关

Const.ToughnessTimeDilation = 0.33
Const.ToughnessShowBloodTip = 0.4
Const.ToughnessClose = 0.76

-- Const.PlayerBreakOpenAim = true @zyh：移到C++

Const.PlayerHandAimSpeedRate = 0.9

Const.InVaildModUnlockLevel = 99 -- MOD槽位未开放

-- 音频参数
Const.PlaySoundAsync = true
Const.EveryAttackLimitSeNum = 3

-- 罗马大写数字
Const.RomanNum = 
{
	"Ⅰ","Ⅱ","Ⅲ","Ⅳ","Ⅴ",
	"Ⅵ","Ⅶ","Ⅷ","Ⅸ","Ⅹ",
	"Ⅺ","Ⅻ"
}

-- 带圈序号数字
Const.IndexNum =
{
    "①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩",
}

-- 伤害信息打印开关
Const.bShowDamageDetails = false

Const.bEditorOpenFXBudget = true

Const.DialogueSnapShot =
{
    HEART = 1,
    MEMORY = 2,
    MYSTERIOUS = 3,
    MONSTER = 4,
    TELEPHONE = 5,
    OUTDOOR = 6,
    ELECTRIC = 7 ,
    BROADCAST = 8,
    ECHO = 9,
    WUYOU = 10,
    ROBOT = 11,
}

Const.DungeonFrameLoadBreakableItemMaxNum = 2

Const.MaxDungeonMonNum_PC = 150
Const.MaxDungeonMonNum_Mobile = 100

Const.DefenceGameToastType = {
    Damaged = 1,
    Destroyed = 2,
    Fail = 3,
    Success = 4
}


---------------------------- 场景相关 ------------------------------
-- 是否开启HLOD配置
Const.bOverrideHLODDistance = false

-- HLOD配置 0 最低 4 最高
Const.HLODDistanceDefault = {
    [0] = 12000,
    [1] = 13000,
    [2] = 15000,
    [3] = 16000,
    [4] = 18000,
}

Const.HLODDistanceAndroid = {
    [0] = 3000,
    [1] = 3000,
    [2] = 3000,
    [3] = 4000,
    [4] = 4000,
}

-- PC层级加载距离配置 0 最低 4 最高
Const.PCRealStreamingDistanceRatio = {
    [0] = 1,
    [1] = 1.1,
    [2] = 1.2,
    [3] = 1.3,
    [4] = 1.5,
}

-- 安卓层级加载距离配置 0 最低 4 最高
Const.AndroidRealStreamingDistanceRatio = {
    [0] = 0.9,
    [1] = 0.95,
    [2] = 1,
    [3] = 1.2,
    [4] = 1.3,
}

-- IOS层级加载距离配置 0 最低 4 最高
Const.IOSRealStreamingDistanceRatio = {
    [0] = 0.9,
    [1] = 0.95,
    [2] = 1,
    [3] = 1.2,
    [4] = 1.3,
}

-- IOS序列化距离配置 0 最低 4 最高
Const.IOSSerializeDistanceRatio = {
    [0] = 0.8,
    [1] = 0.9,
    [2] = 1.0,
    [3] = 1.0,
    [4] = 1.0,
}

-- WC副本 低配或低内存手机 是否卸载small
Const.WCDungeonUnloadSmall = true

-- WC副本 低配或低内存手机 加载距离比例
Const.WCDungeonDistanceRatio = 0.7

-- WC副本 低配或低内存手机 Levelproxy加载比例
Const.WCDungeonLevelProxyDistanceRatio = 0.7

-- 是否允许卸载导航关卡
Const.CanUnloadNavMeshLevel = true

-- 东国场景Foliage高中低配关卡规则
Const.HuaxuFoliagePC = {
    ["High"] = {"_TypH", "_TypM", "_TypL_DenH"},
    ["Mid"] = {"_TypM", "_TypL_DenH"},
    ["Low"] = {"_TypM", "_TypL_DenM"}
}

Const.HuaxuFoliagePhone = {
    ["High"] = {"_TypM", "_TypL_DenM"},
    ["Mid"] = {"_TypM", "_TypL_DenL"},
    ["Low"] = {"_TypL_DenL"}
}

---------------------------- 场景相关 ------------------------------

--模拟移动强制使用的平台， "Windows" "Android" "IOS" "Mac" "" 不使用
Const.SimulateMovementDebugPlatform = ""

-- 是否打印Dungeon创建怪物的数据
Const.CheckDungeonMonId = false
-- 每帧怪物执行RealInit的数量上限
Const.PreFrameRealInitNum = 1
-- 每帧怪物执行OnDead的数量上限
Const.MonDeathTaskNumPreFrame = 1
Const.bEnableMonDeathOptimization = true

Const.bCloseWeaponMovementSync = true;
Const.bCloseBodyAccessoryItemMovementSync = true
Const.bSpawnAIUnitAddToEventQueue = true
Const.bWeaponAndAccessoryItemHcc = true
Const.bMonsterInitByPropertySync = true
Const.OpenLookAtProtect = true
-- Const.bUseBodyMeshAsVirtualBoneSource = true
-- 实在不知道叫啥了，为true时Android的极低和低性能NPC创建逻辑和低内存一致
Const.bALSameLM = true

---------------------------- 缓存池开关 ------------------------------
-- 单机的缓存池开关
Const.StandAloneMonsterCanCache = true
-- 联机的缓存池开关
Const.OnlineMonsterCanCache = true
-- 进副本提前创建怪物
Const.DungeonPreloadMonster = true
-- 怪物死亡可以进入缓存池
Const.MonsterNeedCache = true
-- 怪物可以从缓存池出生
Const.MonsterCanSpawnFromCache = true
-- 创生物死亡是否回缓存池
Const.SummonDeadCache_Windows = false
Const.SummonDeadCache_Android = false
Const.SummonDeadCache_IOS = false
-- 玩家是否预创建创生物
Const.PlayerPreloadSummon_Windows = false
Const.PlayerPreloadSummon_Android = false
Const.PlayerPreloadSummon_IOS = false

Const.NPCDeadCache_Win = true
Const.NPCDeadCache_IOS = false
Const.NPCDeadCache_Andriod = true

-- 低性能下CustomNPC不创建+部分静态点不刷NPCCharacter 开关
Const.LowMemoryDeviceNPCOptimize = true
-- 联机下勾选了创建优化的NPC隐藏+此时触发的创建忽略
Const.OnlineNPCCreateOptimize = true
Const.CNPCDelHide = true

Const.EnableCacheSummonID = {
    --[0] = 150401,       -- 苏乙
    --[1] = 180101,       -- 菲娜
    [2] = 210101,       -- 水母
    [3] = 230101,       -- 章鱼
    --[4] = 310301,       -- 耶尔-耶尔
    --[5] = 310302,       -- 耶尔-奥利弗
    -- [6] = 410201,       -- 止流
    -- [7] = 410202,       -- 止流
    --[8] = 420101,       -- 黑龙
    --[9] = 430101,      -- 西比
    --[10] = 510101,      -- 松露
    [11] = 530101,      -- 蝶妹
    -- [12] = 540201,      -- 莉莉蔻
}

Const.RegionPreloadSupportSceneId =
{
    [0] = 1041
}

Const.RegionStoryPreloadSupportSceneId =
{
    [0] = 1001
}

---------------------------- 缓存池开关 ------------------------------

Const.bServerMonsterDead = true

-- Audio
Const.NeedStoreSTLBGM = true
Const.FootstepFXSlowSpeed = 230
Const.FootstepFXFastSpeed = 800
Const.WaterDepth = 0.2
-- Const.OpenGetEventByIDCompute = true

-- 手柄按键相关接口(UIConst.GamePadKey里面也有一份数据，和这里数据保持一致)
Const.GamepadSpecialLeft = "Gamepad_Special_Left"         -- 左菜单键
Const.GamepadSpecialRight = "Gamepad_Special_Right"       -- 右菜单键
Const.GamepadDPadLeft = "Gamepad_DPad_Left"               -- 左方向键
Const.GamepadDPadRight = "Gamepad_DPad_Right"             -- 右方向键
Const.GamepadDPadUp = "Gamepad_DPad_Up"                   -- 上方向键
Const.GamepadDPadDown = "Gamepad_DPad_Down"               -- 下方向键
Const.GamepadFaceButtonLeft = "Gamepad_FaceButton_Left"   -- Xbox X键
Const.GamepadFaceButtonRight = "Gamepad_FaceButton_Right" -- Xbox B键
Const.GamepadFaceButtonUp = "Gamepad_FaceButton_Top"      -- Xbox Y键
Const.GamepadFaceButtonDown = "Gamepad_FaceButton_Bottom"   -- Xbox A键
Const.GamepadLeftShoulder = "Gamepad_LeftShoulder"        -- 左肩键
Const.GamepadLeftTrigger = "Gamepad_LeftTrigger"          -- 左扳机
Const.GamepadRightShoulder = "Gamepad_RightShoulder"      -- 右肩键
Const.GamepadRightTrigger = "Gamepad_RightTrigger"        -- 右扳机
Const.GamepadRightThumbstick = "Gamepad_RightThumbstick"  -- 右摇杆按钮
Const.GamepadLeftThumbstick = "Gamepad_LeftThumbstick"  -- 左摇杆按钮
Const.LeftStickUp = "Gamepad_LeftStick_Up"
Const.LeftStickDown = "Gamepad_LeftStick_Down"
Const.LeftStickRight = "Gamepad_LeftStick_Right"
Const.LeftStickLeft = "Gamepad_LeftStick_Left"
Const.RightStickUp = "Gamepad_RightStick_Up"
Const.RightStickDown = "Gamepad_RightStick_Down"
Const.RightStickRight = "Gamepad_RightStick_Right"
Const.RightStickLeft = "Gamepad_RightStick_Left"

Const.ShortKeyToGamePadKey = {
    ["Menu"] = Const.GamepadSpecialRight,
    ["View"] = Const.GamepadSpecialLeft,

    ["A"] = Const.GamepadFaceButtonDown,
    ["B"] = Const.GamepadFaceButtonRight,
    ["X"] = Const.GamepadFaceButtonLeft,
    ["Y"] = Const.GamepadFaceButtonUp,

    ["LB"] = Const.GamepadLeftShoulder,
    ["RB"] = Const.GamepadRightShoulder,
    ["LT"] = Const.GamepadLeftTrigger,
    ["RT"] = Const.GamepadRightTrigger,

    ["LS"] = Const.GamepadLeftThumbstick,
    ["RS"] = Const.GamepadRightThumbstick,

    ["Up"] = Const.GamepadDPadUp,
    ["Down"] = Const.GamepadDPadDown,
    ["Left"] = Const.GamepadDPadLeft,
    ["Right"] = Const.GamepadDPadRight,
}

-- 手柄震动强度
Const.ForceFeedbackScale = {
    1.0,
    0.6, 
    0.2,
}

-- 核桃奖励界面
Const.StandAloneNoWalnutTipsTime = 2

-- 核桃数字对应Icon路径 index 1-11 对应图片 0-10
Const.WalnutNumberIconPath =
{
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num0.T_Walnut_Num0',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num1.T_Walnut_Num1',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num2.T_Walnut_Num2',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num3.T_Walnut_Num3',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num4.T_Walnut_Num4',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num5.T_Walnut_Num5',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num6.T_Walnut_Num6',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num7.T_Walnut_Num7',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num8.T_Walnut_Num8',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num9.T_Walnut_Num9',
    '/Game/UI/Texture/Dynamic/Atlas/Walnut/T_Walnut_Num10.T_Walnut_Num10'
}

Const.DeputeType = {
    RegularDepute = 1,  --常规委托
    NightFlightManualDepute =2,--夜航
    WalnutDepute = 3,   --密函
    DeputeWeekly = 4 --周本
}


Const.UnBorn = -1
Const.Borning = 0
Const.Bonred = 1
Const.ShouldDetory = 2

---测试新委托界面用的
Const.IsOpenNewDepute = false

Const.BubbleTimePerLine = 2

--- Hero Usdk share platform
Const.HeroUsdkSharePlatform = {
    All = 20000,                    --- 有界面分享
    QQ = 20001,                     --- QQ
    QQZone = 20002,                 --- QQ 空间
    Wechat = 20003,                 --- 微信
    WechatMoments = 20004,          --- 微信朋友圈
    Weibo = 20005,                  --- 微博
    DouyinContact = 20007,          --- 抖音编辑
    XHS = 20008,                    --- 小红书
    KS = 20009,                     --- 快手
    BiliBili = 20010,               --- 哔哩
    TapTap = 20012,                 --- TapTap
    Twitter = 30001,                --- Twitter 无界面分享
    Facebook = 30002,               --- Facebook 无界面分享

    ---以下只适用于安卓
    TwitterFriends = 30003,         --- Twitter 好友 无界面分享
    Tweets = 30004,                 --- Twitter 动态 无界面分享
    Discord = 30011,                --- Discord
}

--- Hero Usdk share type
Const.HeroUsdkShareType = {
    None = 0,                       --- 无
    Link = 1,                       --- 链接
    Image = 2,                      --- 图片
    Text = 3,                       --- 文本
}

---------------- CustomNpc ---------------------
Const.CustomNpcCreateOpt = true        --开启分帧
Const.CustomNpcCanCache = true         --开启缓存池
---------------- CustomNpc ---------------------

Const.PickupNiagaraPaths = {"/Game/Asset/Effect/Niagara/Item/NS_Item_Base.NS_Item_Base",
                            "/Game/Asset/Effect/Niagara/Item/NS_Item_Pick_Base.NS_Item_Pick_Base",
                            "/Game/Asset/Effect/Niagara/Item/NS_Item_Base_Pro.NS_Item_Base_Pro",
                            "/Game/Asset/Effect/Niagara/Item/NS_Item_Pick_Base_Pro.NS_Item_Pick_Base_Pro",
                            "/Game/Asset/Effect/Niagara/Item/NS_Item_Base_Ultra.NS_Item_Base_Ultra",
                            "/Game/Asset/Effect/Niagara/Item/NS_Item_Pick_Base_Ultra.NS_Item_Pick_Base_Ultra",
                            "/Game/Asset/Effect/Niagara/Item/NS_Item_Base_Fly.NS_Item_Base_Fly"}

Const.bForceOpenPay = false


Const.IsOpenNetMultiClientOnly = true

Const.ReddotCacheType = {
    UserCache = 1,  --存储在用户缓存
    CommonCache = 0,--存储在公共缓存
    NoneCache = -1, --不需要本地缓存
}

Const.ShopCacheReason = {
    Temporary = 1,
    Persistent = 2,
    Read = 0,
}

---------------- ScriptDetection脚本检测相关Const变量 ---------------------
Const.bOpenScriptDetectionCheck = true      -- 是否开启脚本检测功能
Const.bIsUseCppVersion = true               -- 是否使用C++版本的脚本检测功能(如果设置为false，则回退成Lua版本的检测)
---------------- ScriptDetection脚本检测相关Const变量 ---------------------

Const.IsShowRayCreature = false

Const.IsOpenBulletCreature = true
Const.IsOpenSkillCreature = true
Const.IsOpenCreatureECS = true

Const.UnlockRegionTeleport = false

Const.DefaultAttributeMaster = {
    [0] = 160101,
    [1] = 1601,
}

Const.SkipShadowBudgetConfig = { 3102 }

Const.OpenVerifyArray = true

Const.bUseDynamicResolution = true

Const.WCDungeonAirBoxUnitId = 11002

Const.TempleInteractiveCount = 100

Const.ScriptDetectionCheckType = {
    OnMouse = "OnMouse",
    OnKeyboard = "OnKeyboard",
}

Const.bOutAirWallBoxCheckRangeVisualDebug = false

Const.PCScalabilityLevelNum = {--暂时不用改，为5时约等于之前的加载
        [0] = 6,
        [1] = 7,
        [2] = 8,
        [3] = 8,
        [4] = 8,
}
Const.MobileScalabilityLevelNum = {
    ["IOS"] = {
        [0] = 10,
        [1] = 10,
        [2] = 10,
        [3] = 10,
        [4] = 10,
    },
    ["Android"] = {
        [0] = 8,
        [1] = 8,
        [2] = 8,
        [3] = 8,
        [4] = 8,
    },
}

Const.bTakePhotoAddWatermark = false

Const.SynthesisCheckResetPointTime = 10

return Const

