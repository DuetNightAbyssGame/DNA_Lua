
require "UnLua"
local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
local CharacterDataStruct = require "BluePrints.Combat.Components.CharacterDataStruct"
local EMCache = require "EMCache.EMCache"

local BP_Battle_C = Class("BluePrints.Common.TimerMgr")

BP_Battle_C._components = {
    "BluePrints.Combat.BattleLogic.AttrLogic",          -- 属性
    "BluePrints.Combat.BattleLogic.BattleEventLogic",          -- 战斗内事件
    "BluePrints.Combat.BattleLogic.BattleGMLogic",          -- 战斗内GM指令
    "BluePrints.Combat.BattleLogic.BuffLogic",          -- 状态
    "BluePrints.Combat.BattleLogic.CampLogic",          -- 阵营
    "BluePrints.Combat.BattleLogic.CharacterLogic",          -- 角色相关
    "BluePrints.Combat.BattleLogic.CreatureLogic",      -- 创生物
    "BluePrints.Combat.BattleLogic.DamageLogic",          -- 伤害逻辑
    "BluePrints.Combat.BattleLogic.PositionLogic",      -- 位置相关的逻辑
    "BluePrints.Combat.BattleLogic.SeekEnemyLogic",     -- 索敌
    "BluePrints.Combat.BattleLogic.SkillRawEffects",    -- 技能效果用于结算效果
    "BluePrints.Combat.BattleLogic.TargetFilterLogic",      -- 技能任务用于选择目标
    "BluePrints.Combat.BattleLogic.DeadLogic",      -- 死亡复活
    "BluePrints.Combat.BattleLogic.ConditionLogic",      -- 触发条件判定
    "BluePrints.Combat.BattleLogic.ToughnessLogic",        -- 韧性逻辑
    "BluePrints.Combat.BattleLogic.BattlePlayMgr",      -- 客户端表现
    "BluePrints.Combat.BattleLogic.LaserLogic",
    "BluePrints.Combat.Components.SkillCreaturePool",
    --"BluePrints.Combat.BattleLogic.DanmakuLogic",        -- 弹幕
}

function BP_Battle_C:CanExecute()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState:CheckGameModeStateNotEnd() then
        return false
    end
    if IsStandAlone(self) then
        return true
    end
    if IsDedicatedServer(self) then
        return true
    end
    if self.ClientExec then
        return true
    end
    return false
end

function BP_Battle_C:ReceiveBeginPlay()
    print(_G.LogTag, "BP_Battle_C ReceiveBeginPlay")
    GWorld.Battle = self
    self.Overridden.ReceiveBeginPlay(self)
    rawset(self, "BattleEvent", self.BattleEvent)
    self.Results = EffectResults.Results()
    self.Result = EffectResults.Result()
    self.CreatureSrouceMap = {}
    self.CreatureDelayHandles = {}    
    self.HpLinkBuffDic = {}
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.Battle = self
    self:OnCreated() -- 这句话一定要最后调用
   -- self:Init_SkillCreaturePool()
    EventManager:AddEvent(EventID.TalkPauseGame, self, self.ClearAllDanmaku)
end

function BP_Battle_C:GetSummonInheritAttrs()
    return {
        "MaxHP",
        "Hp",
        "MaxES",
        "ES",
        "DEF",
        "SkillRange",
        "SkillSustain",
        "SkillEfficiency",
        "SkillIntensity",
    }
end

function BP_Battle_C:GetSummonSpecialInheritAttrs()
    return {
        'StrongValue',
        'EnmityValue',
    }
end

-- @SnowMooN 只有这个时机才能通过Battle(self)拿到它，ReceiveBeginPlay太早了，虽然创建出来了，但是还没有挂到GameState上去
function BP_Battle_C:OnCreated()
    assert(Battle(self))
    if IsAuthority(self) then
        self:TriggerGameModeBattleInit()
    end
    print(_G.LogTag, "FireEvent OnBattleReady")
    EventManager:FireEvent(EventID.OnBattleReady, self)
end

-- ClientOnly表示只在客户端生效的技能效果，在联机服务器不执行
function BP_Battle_C:GetClientOnlyFunction_Lua()
    return {
        "ExecuteClientPassiveFunction",
        "PlayUIAnim",
        "AimDiffusion",
        "BeginAccumulate",
        "CameraShake",
        "AdditionalHitFX",
    }
end

-- 客户端预测，如果是从蓝图服务器执行，则广播
function BP_Battle_C:GetClientPredictFunction_Lua()
    return {
        "PlayFX",
        "PlaySE",
    }
end

-- 双端都执行，单机下需要保持只执行一次，不能在蓝图里执行
function BP_Battle_C:GetServerClientBothFunction_Lua()
    return {
        "AddCameraSpeed",
        "AddCharFallSpeed",
        "HitStop",
        "ExecuteClientSkillLogicFunction",
        "ChangeModel",
        "SetToCondemnLoc",
        "GrabHit"
    }
end

-- 双端都执行，单机下需要保持只执行一次，可以在蓝图里执行
function BP_Battle_C:GetServerClientBothNetMulticastFunction_Lua()
    return {
        "CreateSkillCreature",
        "CreateRayCreature",
        "RemoveRayCreature",
        "RemoveSkillCreature",
        "StartLoopShoot",
        "EndLoopShoot",
        "UpdateLoopShoot",
        "StartHeavyCharge",
        "ExecuteHeavyEffect",
        "SaveLoc",
        "OverrideCharVelocity",
        "CallBackSkillCreature",
        -- "ChangeModel",
        "ClearHitTargets",
        "ReplaceBulletFXID",
        "RemoveDanmaku",
    }
end

--用来给c++的技能效果函数出错覆盖用的
function BP_Battle_C:GetLuaOverrideFunction_Lua()
    return 
    {
        -- TargetFilter
        --"CheckRangeHit",
        
        -- SkillEffect
    }
end

function BP_Battle_C:TriggerGameModeBattleInit()
    if not IsAuthority(self) then return end
    UE4.UGameplayStatics.GetGameMode(self):TryTriggerOnPrepare("BattleInit")
end

-- function BP_Battle_C:ReceiveTick(DeltaSeconds)
--     -- self.Overridden.ReceiveTick(self, DeltaSeconds)
--     -- self:TickSkillEffectResult()
--     -- self:DelayCreateSkillCreature()
-- --    self:TickSkillCreaturePool(DeltaSeconds)
--     self:TickBattleEvents(DeltaSeconds)
-- end

function BP_Battle_C:FlushEffectResult_Lua()
    if self.Result and not self.Result.IsEmpty then
        self.Results:Add(self.Result)
        self.Result = EffectResults.Result()
    end
    
    if self.Results and not self.Results.IsEmpty and self.Results.ToEffectStruct then
        -- PrintTable({Results=self.Results},10, "ServerResults")
        local EffectStruct = self.Results:ToEffectStruct()
        self:AddEffectStruct(EffectStruct)
        self.Results = EffectResults.Results()
    end
end

-- function BP_Battle_C:TickSkillEffectResult()
--     -- 如果是单机或者客户端，不走这些逻辑
--     if IsStandAlone(self) or IsClient(self) then
--         self.TickSkillEffectResult = MiscUtils.EmptyFunction
--         self.Result.Add = MiscUtils.EmptyFunction
--         self.Result.ToEffectStruct = MiscUtils.EmptyFunction
--         self.Results.Add = MiscUtils.EmptyFunction
--         self.Results.ToEffectStruct = MiscUtils.EmptyFunction
--         return
--     end

--     -- -- 只有联机服务器才会进来
--     -- if self.Result and not self.Result.IsEmpty then
--     --     self.Results:Add(self.Result)
--     --     self.Result = EffectResults.Result()
--     -- end
--     -- if self.Results and not self.Results.IsEmpty and self.Results.ToEffectStruct then
--     --     -- PrintTable({Results=self.Results},10, "ServerResults")
--     --     -- local EffectStruct = self.Results:ToEffectStruct()
--     --     -- -- PrintTable({
--     --     -- --     Results=self.Results,
--     --     -- --     Length=#EffectStruct:GetResult(),
--     --     -- --     Str=EffectStruct:GetResult(),
--     --     -- -- },10)
--     --     -- local EffectStructs = TArray(FEffectStruct)
--     --     -- EffectStructs:Add(EffectStruct)
--     --     self:NetMulticastExecuEffect(EffectStructs)
--     --     self.Results = EffectResults.Results()
--     -- end
-- end

function BP_Battle_C:DelayCreateSkillCreature()
    local Battle = Battle(self)
    for i, v in pairs(self.CreatureSrouceMap) do
        local function CreateSkillCreatureDelay(self)
            if not  UE4.UKismetSystemLibrary.IsValid(v.Source) then
                return
            end
            local BornLocationData = v.BornLocationData
            if self.BornLocation and BornLocationData and BornLocationData.Index ~= 1 then
                v.BornLocation = FVector(self.BornLocation.X, self.BornLocation.Y + BornLocationData.YOffset, self.BornLocation.Z + BornLocationData.ZOffset)
            end
            local Creature = Battle:CreateSkillCreature(v, true)
            if BornLocationData and BornLocationData.Index == 1 then
                self.BornLocation = Creature.BornLocation
            elseif not BornLocationData then
                self.BornLocation = nil
            end
        end
        local Interval = 0.01 * (i - 1)
        if Interval > 0 then
            local Handle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, CreateSkillCreatureDelay}, Interval, false)
            table.insert(self.CreatureDelayHandles, Handle)
        else
            CreateSkillCreatureDelay(self)
        end
    end
    self.CreatureSrouceMap = {}
end

function BP_Battle_C:ReceiveEndPlay()
    if self.Components then
        for _, Module in pairs(self.Components) do
            Module:Destroy(self)
        end
    end
    for i,v in pairs(self.CreatureDelayHandles)do
        UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, v)
    end

    EventManager:RemoveEvent(EventID.TalkPauseGame, self)
    GWorld.Battle = nil
end

function BP_Battle_C:ToTable(SourceCharacter)
    local CharStruct = New(CharacterDataStruct)
    CharStruct.Eid = SourceCharacter.Eid
    CharStruct.Location = {SourceCharacter:K2_GetActorLocation().X, SourceCharacter:K2_GetActorLocation().Y, SourceCharacter:K2_GetActorLocation().Z}
    CharStruct.CurrentSkillId = SourceCharacter.CurrentSkillId
    if SourceCharacter and SourceCharacter.GetFireSkill then
        CharStruct.FireSkillId = SourceCharacter:GetSkillByType(UE.ESkillType.Shooting)
    end
    if SourceCharacter and SourceCharacter.GetCurrentWeapon and SourceCharacter:GetCurrentWeapon() then
        CharStruct.CurrentWeapon = SourceCharacter:GetCurrentWeapon().WeaponId
    end
    return CharStruct
end
function BP_Battle_C:ToStruct(CharStruct)
    CharStruct.K2_GetActorLocation = function()
        return FVector(CharStruct.Location[1],CharStruct.Location[2],CharStruct.Location[3])
    end
    CharStruct.GetFireSkill = function()
        return CharStruct.FireSkillId
    end
    CharStruct.GetCurrentWeapon = function()
        if not Battle(self):GetEntity(CharStruct.Eid)then
            return nil
        end
        local Character = Battle(self):GetEntity(CharStruct.Eid)
        if not Character.Weapons then 
            return 
        end
        return Character.Weapons[CharStruct.CurrentWeapon]
    end
    return CharStruct
end

function BP_Battle_C:ShowBattleErrorLua(Text)
    self:ShowBattleError(Text, true)
end

function BP_Battle_C:StandardShowBattleErrorLua(Type, Title, Content, bCallFromCpp)
    -- 参数验证
    if not Content then
        Content = ""
    end
    if Type == nil then
        DebugPrint(ErrorTag, "StandardShowBattleErrorLua:参数Type为nil")
        return
    end
    local TypeString = nil
    local Success, Result = pcall(function()
        return UE.EShowBattleErrorType:GetNameStringByValue(Type)
    end)
    if not Success or not Result or Result == "" then
        DebugPrint(ErrorTag, "StandardShowBattleErrorLua:参数Type不是有效的EShowBattleErrorType枚举值")
        return
    end
    TypeString = Result
    if Title == nil then
        DebugPrint(ErrorTag, "StandardShowBattleErrorLua:参数Title为nil")
        Title = "nil"
    elseif type(Title) ~= "string" and type(Title) ~= "number" then
        Title = tostring(Title)
    end
    if Content == nil then
        DebugPrint(ErrorTag, "StandardShowBattleErrorLua:参数Content为nil")
        Content = "nil"
    elseif type(Content) ~= "string" and type(Content) ~= "number" then
        Content = tostring(Content)
    end
    
    local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
    if bDistribution then
        return
    end

    local Space = "=========================================================\n"
    local Ct = Content ~= "" and {
        Space,
        "【错误大类】: ", TypeString, "\n",
        "【Title】: ", Title, "\n",
        "【Content】: ",Content, "\n",
    } or {
        Space,
        "【错误大类】: ", TypeString, "\n",
        "【Title】: ", Title, "\n",
    }
    local Ret
    self:FillBattleLog(Ct)
    if not bCallFromCpp then
        table.insert(Ct, Space)
        table.insert(Ct, "Traceback:\n\t")
        table.insert(Ct, debug.traceback())
        table.insert(Ct, "\n")
    end
    Ret = table.concat(Ct)

    if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
        ScreenPrint("战斗报错(StandardShowBattleError):\n"..Ret)	
    else
        DebugPrint("战斗报错(StandardShowBattleError):\n"..Ret)	
    end
    if not GWorld.ErrorDict then
        GWorld.ErrorDict = {}
    end
    local ErrorDictContent = TypeString..Title
    if ErrorDictContent ~= "" and GWorld.ErrorDict[ErrorDictContent] then
        return
    end
    GWorld.ErrorDict[ErrorDictContent] = true
    local TraceType = {
        first = GText("战斗报错"),
        second = TypeString,
        third = Title,
    }
    local DescribeInfo = {
        title = GText("详细信息"),
        trace_content = Ret,
    }
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:SendToFeishuForBattle(Ret, "战斗报错"..TypeString)
        Avatar:SendTraceToQaWeb(TraceType, DescribeInfo)
        return
    end
    local DSEntity = GWorld:GetDSEntity()
    if DSEntity then
        DSEntity:SendToFeishuForBattle(Ret, "战斗报错"..TypeString)
        DSEntity:SendTraceToQaWeb(TraceType, DescribeInfo)
        return
    end
end

function BP_Battle_C:FillBattleCharacterLog(Ct, Player)
    if not Player then
        return
    end
    local CurrentRoleId = Player.CurrentRoleId
    table.insert(Ct, "使用角色ID:")
    table.insert(Ct, tostring(CurrentRoleId))
    if DataMgr.BattleChar[CurrentRoleId] then
        local RoleName = GText(DataMgr.BattleChar[CurrentRoleId].CharName)
        table.insert(Ct, "(")
        table.insert(Ct, tostring(RoleName))
        table.insert(Ct, ")")
    end
    if Player.MeleeWeapon then
        local WeaponId = Player.MeleeWeapon.WeaponId
        table.insert(Ct, ",近战武器ID:")
        table.insert(Ct, tostring(Player.MeleeWeapon.WeaponId))
        local WeaponInfo = DataMgr.Weapon[WeaponId]
        if WeaponInfo then
            local WeaponName = WeaponInfo.WeaponName
            if DataMgr.TextMap[WeaponName] then
                WeaponName = GText(WeaponName)
            end
            if WeaponName then
                table.insert(Ct, "(")
                table.insert(Ct, WeaponName)
                table.insert(Ct, ")")
            end
        end
    end
    if Player.RangedWeapon then
        local WeaponId = Player.RangedWeapon.WeaponId
        table.insert(Ct, ",远程武器ID:")
        table.insert(Ct, tostring(Player.RangedWeapon.WeaponId))
        local WeaponInfo = DataMgr.Weapon[WeaponId]
        if WeaponInfo then
            local WeaponName = WeaponInfo.WeaponName
            if DataMgr.TextMap[WeaponName] then
                WeaponName = GText(WeaponName)
            end
            if WeaponName then
                table.insert(Ct, "(")
                table.insert(Ct, WeaponName)
                table.insert(Ct, ")")
            end
        end
    end
    
    if not Player:IsPhantom() then
        -- 基础标识信息
        table.insert(Ct, "\n基础信息:")
        table.insert(Ct, "  Eid: ")
        table.insert(Ct, tostring(Player.Eid or "Unknown"))
        table.insert(Ct, "  模型Id: ")
        table.insert(Ct, tostring(Player.ModelId or "Unknown"))
        
        -- 初始化状态信息
        table.insert(Ct, "\n初始化状态:")
        table.insert(Ct, "  InitSuccess: ")
        table.insert(Ct, Player.InitSuccess and "成功" or "失败")
        table.insert(Ct, "  ServerInitSuccess: ")
        table.insert(Ct, Player.ServerInitSuccess and "成功" or "失败")
        if Player.IsCharacterReady then
            table.insert(Ct, "  IsCharacterReady: ")
            table.insert(Ct, Player:IsCharacterReady() and "就绪" or "未就绪")
        end
        if Player.WaitInitTags then
            local waitCount = 0
            for _ in pairs(Player.WaitInitTags) do
                waitCount = waitCount + 1
            end
            if waitCount > 0 then
                table.insert(Ct, "  WaitInitTags: ")
                table.insert(Ct, tostring(waitCount))
            end
        end
        
        -- 特殊状态信息
        local hasSpecialState = false
        local specialStates = {}
        if Player.bInJetRush then
            table.insert(specialStates, "喷射冲刺")
            hasSpecialState = true
        end
        if Player.bInJetState then
            table.insert(specialStates, "喷射状态")
            hasSpecialState = true
        end
        if Player.EnableAnimFly then
            table.insert(specialStates, "飞行动画")
            hasSpecialState = true
        end
        if Player.JumpHolden then
            table.insert(specialStates, "跳跃保持")
            hasSpecialState = true
        end
        if Player.SprintHolden then
            table.insert(specialStates, "冲刺保持")
            hasSpecialState = true
        end
        if hasSpecialState then
            table.insert(Ct, "\n特殊状态:")
            for i, state in ipairs(specialStates) do
                if i > 1 then
                    table.insert(Ct, ", ")
                end
                table.insert(Ct, "  " .. state)
            end
        end
    end

    if Player:IsPlayer() then
        local Flag = false
        local PhantomTeammate = Player:GetPhantomTeammates()
        for _, Target in pairs(PhantomTeammate) do
            if Target ~= Player then
                if not Flag then
                    table.insert(Ct, "\n正在使用的魅影信息:")
                    Flag = true
                end
                table.insert(Ct, "\n\t")
                self:FillBattleCharacterLog(Ct, Target)
            end
        end
    end
end

function BP_Battle_C:FillBattleLog(Ct)
    local Avatar = GWorld:GetAvatar()
    table.insert(Ct, "环境:")
    if IsClient(self) then
        table.insert(Ct, "联机客户端")
    elseif IsDedicatedServer(self) then
        table.insert(Ct, "联机服务端")
    elseif Avatar and Avatar:IsInHardBoss() then
        table.insert(Ct, "梦魇残声")
        if Avatar.HardBossInfo then
            table.insert(Ct, ":编号[")
            local HardBossId = Avatar.HardBossInfo.HardBossId
            table.insert(Ct, HardBossId)
            table.insert(Ct, "]")
            local Context = nil
            if DataMgr.HardBossMain[HardBossId] then
                local HardBossName = DataMgr.HardBossMain[HardBossId].HardBossName
                if DataMgr.TextMap[HardBossName] then
                    Context = GText(HardBossName)
                end
            end
            if Context then
                table.insert(Ct, "[")
                table.insert(Ct, Context)
                table.insert(Ct, "]")
            end
            local DifficultyId = Avatar.HardBossInfo.DifficultyId
            local DifficultyLevel = nil
            if DifficultyId and DataMgr.HardBossDifficulty[DifficultyId] then
                DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
            end
            table.insert(Ct, ":难度等级[")
            table.insert(Ct, DifficultyLevel)
            table.insert(Ct, "]")
        end
    elseif Avatar and Avatar.CurrentOnlineType and Avatar.CurrentOnlineType ~= -1 then
        table.insert(Ct, "区域联机")
    else
        table.insert(Ct, "单机")
    end
    --新增平台信息
    local PlatformName
    if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then --编辑器环境
        PlatformName = "编辑器"
    else --非编辑器环境
        PlatformName = UGameplayStatics.GetPlatformName()
    end
    table.insert(Ct, "  平台:"..tostring(PlatformName))
    table.insert(Ct, "\n")

    local Space = "================".."角色信息".."================\n"
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    table.insert(Ct, Space)
    if IsDedicatedServer(self) then
        local AllPlayer = GameMode:GetAllPlayer()
        for i, Player in pairs(AllPlayer) do
            table.insert(Ct, "[")
            table.insert(Ct, i)
            table.insert(Ct, "]")
            self:FillBattleCharacterLog(Ct, Player)
            table.insert(Ct, "\n")
        end
    else
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        local CurrentRoleId = nil
        if Player then
            CurrentRoleId = Player.CurrentRoleId
        end
        self:FillBattleCharacterLog(Ct, Player)
        table.insert(Ct, "\n")
    end

    

    --副本信息
    Space = "================".."副本信息".."================\n"
    local GameState = UE.UGameplayStatics.GetGameState(self.Player)
    if IsValid(GameState) and GameState:IsInDungeon() then
        table.insert(Ct, Space)
        self:FillDungeonLog(Ct, GameState)
    end

    --区域信息
    Space = "================".."区域信息".."================\n"
    if IsValid(GameState) and GameState:IsInRegion() and Avatar then
        table.insert(Ct, Space)
        self:FillRegionLog(Ct, GameMode, Avatar)
    end

    --时间信息
    Space = "================".."时间信息".."================\n"
    table.insert(Ct, Space)
    self:FillTimeLog(Ct)
    
    --UI信息
    Space = "================".."UI信息".."================\n"
    table.insert(Ct, Space)
    self:FillUIInfoLog(Ct)
end

function BP_Battle_C:FillDungeonLog(Ct, GameState)
    local DungeonId = GameState.DungeonId
    if not DungeonId or DungeonId <= 0 then
        return
    end
    
    -- 基础副本信息
    table.insert(Ct, "副本ID:")
    table.insert(Ct, tostring(DungeonId))
    local DungeonInfo = DataMgr.Dungeon[DungeonId]
    local DungeonType = nil
    if DungeonInfo then
        local DungeonName = DungeonInfo.DungeonName
        if DungeonName and DataMgr.TextMap[DungeonName] then
            DungeonName = GText(DungeonName)
        end
        table.insert(Ct, "(")
        table.insert(Ct, tostring(DungeonName))
        table.insert(Ct, ")")
        DungeonType = DungeonInfo.DungeonType

        -- 副本类型
        if DungeonInfo.DungeonType then
            table.insert(Ct, "  [")
            table.insert(Ct, "副本类型: ")
            table.insert(Ct, tostring(DungeonInfo.DungeonType))
            table.insert(Ct, "]")
        end
    end
    table.insert(Ct, "\n")
    
    if DungeonInfo then
        -- 副本等级
        if DungeonInfo.DungeonLevel then
            table.insert(Ct, "副本等级: ")
            table.insert(Ct, tostring(DungeonInfo.DungeonLevel))
            table.insert(Ct, "")
        end

        --是否为周本
        if DungeonId and DataMgr.Dungeon[DungeonId] and DataMgr.Dungeon[DungeonId].IsWeeklyDungeon then
            table.insert(Ct, "      是否为周本: 是")
        else
            table.insert(Ct, "      是否为周本: 否")
        end
    end
    
    -- 当前场景名称
    local SceneManager = GWorld.GameInstance:GetSceneManager()
    if SceneManager then
        local SceneName = SceneManager:GetCurSceneName()
        if SceneName then
            table.insert(Ct, "      当前场景名称: ")
            table.insert(Ct, tostring(SceneName))
        end
    end
    table.insert(Ct, "\n")

    --是否结算
    if self:IsInSettlement() then
        table.insert(Ct, "是否结算: 是")
    else
        table.insert(Ct, "是否结算: 否")
        -- 副本进度信息
        if GameState.DungeonProgress then
            table.insert(Ct, "      副本当前进度(轮次): ")
            table.insert(Ct, tostring(GameState.DungeonProgress))
        end

        -- 敌人信息
        if GameState.MonsterNum then
            table.insert(Ct, "      当前敌人数量: ")
            table.insert(Ct, tostring(GameState.MonsterNum))
        end
    end
    table.insert(Ct, "\n")
end

function BP_Battle_C:FillTimeLog(Ct)
    -- World时间（会在切换UWorld时重置）
    local WorldTime = GWorld:GetCurrentTime()
    table.insert(Ct, "当前World运行时间（进入副本/父区域时间）:")
    local minutes = math.floor(WorldTime / 60)
    local seconds = WorldTime % 60
    if minutes > 0 then
        table.insert(Ct, string.format("  时间: %d分%.0f秒", minutes, seconds))
    else
        table.insert(Ct, string.format("  时间: %.0f秒", seconds))
    end
    table.insert(Ct, "\n")
    
    -- 上次报错的时间记录，会随着BP_Battle_C的生命周期而重置
    local SystemTime = os.time()
    if self.LastErrorLogTime then
        local LastTimeStr = os.date("%Y-%m-%d %H:%M:%S", self.LastErrorLogTime)
        local TimeSinceLast = math.floor(SystemTime - self.LastErrorLogTime)
        table.insert(Ct, "上次战斗报错距今("..LastTimeStr.."):")
        local hours = math.floor(TimeSinceLast / 3600)
        local minutes = math.floor((TimeSinceLast % 3600) / 60)
        local seconds = TimeSinceLast % 60
        local timeStr = ""
        if hours > 0 then timeStr = timeStr .. hours .. "小时" end
        if minutes > 0 then timeStr = timeStr .. minutes .. "分钟" end
        if seconds > 0 or (hours == 0 and minutes == 0) then timeStr = timeStr .. seconds .. "秒" end
        table.insert(Ct, timeStr)
        table.insert(Ct, "\n")
    end
    self.LastErrorLogTime = SystemTime
end

function BP_Battle_C:FillUIInfoLog(Ct)
    -- 添加当前UI层级信息
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if IsValid(UIManager) then
        local ExcludeUIPrefixes = {
            -- 在这里添加不想显示的UI名称前缀，通常是数量多的或者不会影响其他UI显隐的
            "TaskIndicator",
            "PoolClass_Monster",
            "BattleHitDirection",
            "TalkGuideUI",
        }
        
        local function IsUIExcluded(UiName)
            for _, prefix in ipairs(ExcludeUIPrefixes) do
                if string.sub(UiName, 1, string.len(prefix)) == prefix then
                    return true
                end
            end
            return false
        end
        
        table.insert(Ct, "当前UI:")
        table.insert(Ct, "\n")
        
        local AllUI = UIManager.UIInstances:ToTable()
        local RootWidgets = {}
        
        for _, Widget in pairs(AllUI) do
            if IsValid(Widget) then
                local UIName = Widget.ConfigName or Widget.WidgetName or "Unknown"
                if not IsUIExcluded(UIName) then
                    local Parent = Widget:GetParent()
                    table.insert(RootWidgets, Widget)
                end
            end
        end
        
        local function BuildUIHierarchy(Widget, Depth)
            local Indent = string.rep("  ", Depth)
            local UIName = Widget.ConfigName or Widget.WidgetName or "Unknown"
            local VisibilityState = Widget:IsVisible() and "显示" or "隐藏"
            
            local HideTagsInfo = ""
            if not Widget:IsVisible() and Widget.HideTags then
                local HideTags = Widget.HideTags
                if HideTags and type(HideTags) == "table" and next(HideTags) then
                    local TagsList = {}
                    for tag, _ in pairs(HideTags) do
                        table.insert(TagsList, tostring(tag))
                    end
                    if #TagsList > 0 then
                        local TagsStr = table.concat(TagsList, ",")
                        HideTagsInfo = string.format(" [HideTags:%s]", TagsStr)
                    end
                elseif HideTags and type(HideTags) == "string" and HideTags ~= "" then
                    HideTagsInfo = string.format(" [HideTags:%s]", HideTags)
                end
            end
            
            local UIInfo = string.format("%s├─ %s (%s)%s", Indent, UIName, VisibilityState, HideTagsInfo)
            table.insert(Ct, UIInfo)
            table.insert(Ct, "\n")
        end
        
        -- 显示UI层级树
        if #RootWidgets > 0 then
            for _, RootWidget in pairs(RootWidgets) do
                BuildUIHierarchy(RootWidget, 0)
            end
        else
            table.insert(Ct, "  无活跃UI")
            table.insert(Ct, "\n")
        end
        
        -- 添加UI统计信息
        local TotalUICount = 0
        local VisibleUICount = 0
        local HiddenUICount = 0
        local ExcludeUICount = 0
        for _, Widget in pairs(AllUI) do
            if IsValid(Widget) then
                TotalUICount = TotalUICount + 1                
                local UIName = Widget.ConfigName or Widget.WidgetName or "Unknown"
                if IsUIExcluded(UIName) then
                    ExcludeUICount = ExcludeUICount + 1
                elseif Widget:IsVisible() then
                    VisibleUICount = VisibleUICount + 1
                else
                    HiddenUICount = HiddenUICount + 1
                end
            end
        end
        
        table.insert(Ct, string.format("UI统计: 总计%d个, 可见%d个, 隐藏%d个, 排除%d个(排除前缀:%s)", TotalUICount, VisibleUICount, HiddenUICount, ExcludeUICount, table.concat(ExcludeUIPrefixes, ",")))
        table.insert(Ct, "\n")
    end
end

function BP_Battle_C:FillRegionLog(Ct, GameMode, Avatar)

    local RegionId = Avatar:GetCurrentRegionId()
    table.insert(Ct, "子区域ID:")
    table.insert(Ct, tostring(RegionId))
    local RegionInfo = DataMgr.SubRegion[RegionId]
    if not RegionInfo then
        return
    end
    
    -- 区域配置信息
    local RegionName = RegionInfo.SubRegionName
    if DataMgr.TextMap[RegionName] then
        RegionName = GText(RegionName)
    end
    table.insert(Ct, "(")
    table.insert(Ct, tostring(RegionName))
    table.insert(Ct, ")")
    table.insert(Ct, "\n")
    
    -- 大区域信息
    if GameMode and GameMode.RegionId then
        table.insert(Ct, "父区域ID:")
        table.insert(Ct, tostring(GameMode.RegionId))
        local MainRegionInfo = DataMgr.Region[GameMode.RegionId]
        if MainRegionInfo then
            local MainRegionName = MainRegionInfo.RegionName
            if DataMgr.TextMap[MainRegionName] then
                MainRegionName = GText(MainRegionName)
            end
            table.insert(Ct, "(")
            table.insert(Ct, tostring(MainRegionName))
            table.insert(Ct, ")")
        end
        table.insert(Ct, "\n")
    end

    -- 当前场景名称
    local SceneManager = GWorld.GameInstance:GetSceneManager()
    if SceneManager then
        local SceneName = SceneManager:GetCurSceneName()
        if SceneName then
            table.insert(Ct, "当前场景名称: ")
            table.insert(Ct, tostring(SceneName))
            table.insert(Ct, "\n")
        end
    end
end

function BP_Battle_C:ShowBattleError(Text, HideTraceback)
    local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
    local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
    if bDistribution and not bEnableShippingLog then
        return
    end
    
    local Space = "=========================================================\n"
    local Ct = {
        Space,
        "报错文本:\n\t",
        tostring(Text), "\n",
    }
    local Ret
    if not HideTraceback then
        table.insert(Ct, Space)
        table.insert(Ct, "Traceback:\n\t")
        table.insert(Ct, debug.traceback())
        table.insert(Ct, "\n")
    end

    table.insert(Ct, Space)

    self:FillBattleLog(Ct)

    Ret = table.concat(Ct)

    if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then	
        ScreenPrint("战斗报错:\n"..Ret)	
    else
        DebugPrint("战斗报错(ShowBattleError):\n"..Ret)	
    end

    if not GWorld.ErrorDict then
        GWorld.ErrorDict = {}
    end
    if GWorld.ErrorDict[Text] then
        return
    end
    GWorld.ErrorDict[Text] = true

    local TraceType = {
        first = "战斗报错",
        second = "旧版ShowBattleError",
        third = "其他分类",
    }
    local DescribeInfo = {
        title = "战斗报错",
        trace_content = Ret,
    }
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:SendToFeishuForBattle(Ret, "战斗报错")
        Avatar:SendTraceToQaWeb(TraceType, DescribeInfo)
        return
    end

    local DSEntity = GWorld:GetDSEntity()
    if DSEntity then
        DSEntity:SendToFeishuForBattle(Ret, "战斗报错")
        DSEntity:SendTraceToQaWeb(TraceType, DescribeInfo)
        return
    end
end

function BP_Battle_C:GetLimitSeNumEachAttack()
    return Const.EveryAttackLimitSeNum
end

function BP_Battle_C:InitBannedRecordTags()
    local Arr = TArray(FName)
    local BannedRecordTags = EMCache:Get("BannedRecordTags")
    if BannedRecordTags and next(BannedRecordTags) then 
        for Tag, _ in pairs(BannedRecordTags) do 
            Arr:Add(Tag) 
        end

    end
    self:SetBannedRecordTags(Arr)
end

function BP_Battle_C:ShowError_Monster_Inner_Lua(Text, Title)
    if Title == nil then
        Title = "怪物组报错"
    end
    local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
    local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
    if bDistribution and not bEnableShippingLog then
        return
    end
    
    local Space = "=========================================================\n"
    local ct = {
        Space,
        "报错文本:\n\t",
        tostring(Text), "\n",
    }
    local ret
    -- traceback
    table.insert(ct, Space)
    table.insert(ct, "Traceback:\n\t")
    table.insert(ct, debug.traceback())
    table.insert(ct, "\n")

    table.insert(ct, Space)

    self:FillLog_Monster(ct)

    ret = table.concat(ct)

    -- if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    --     ScreenPrint("怪物组报错:\n"..ret)
    -- end

    if not GWorld.ErrorDict then
        GWorld.ErrorDict = {}
    end
    if GWorld.ErrorDict[Text] then
        return
    end
    GWorld.ErrorDict[Text] = true

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local LocalUser = UE.UKismetSystemLibrary:GetPlatformUserName()
	    local ret = "设备名："..LocalUser.."\n"..ret
        Avatar:CallServerMethod("SendToFeiShuForMonster", ret, Title)
        -- Avatar:SendToFeishuForMonster(ret, "怪物组报错")
        return
    end

    local DSEntity = GWorld:GetDSEntity()
    if DSEntity then
        DSEntity:SendToFeishuForMonster(ret, Title)
        return
    end

    -- 接入QA平台
    local TraceType = {
        first = GText("怪物报错"),
        second = Title,
        third = "",
    }
    local DescribeInfo = {
        title = GText("详细信息"),
        trace_content = ret,
    }
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:SendTraceToQaWeb(TraceType, DescribeInfo)
        return
    end
    local DSEntity = GWorld:GetDSEntity()
    if DSEntity then
        DSEntity:SendTraceToQaWeb(TraceType, DescribeInfo)
        return
    end
end

function BP_Battle_C:FillLog_Monster(ct)
    local Avatar = GWorld:GetAvatar()
    table.insert(ct, "环境:")
    if IsClient(self) then
        table.insert(ct, "联机客户端\n")
    elseif IsDedicatedServer(self) then
        table.insert(ct, "联机服务端\n")
    elseif Avatar and Avatar:IsInHardBoss() then
        table.insert(ct, "梦魇残声")
        if Avatar.HardBossInfo then
            table.insert(ct, ":编号[")
            local HardBossId = Avatar.HardBossInfo.HardBossId
            table.insert(ct, HardBossId)
            table.insert(ct, "]")
            local Context = nil
            if DataMgr.HardBossMain[HardBossId] then
                local HardBossName = DataMgr.HardBossMain[HardBossId].HardBossName
                if DataMgr.TextMap[HardBossName] then
                    Context = GText(HardBossName)
                end
            end
            if Context then
                table.insert(ct, "[")
                table.insert(ct, Context)
                table.insert(ct, "]")
            end
            local DifficultyId = Avatar.HardBossInfo.DifficultyId
            local DifficultyLevel = nil
            if DifficultyId and DataMgr.HardBossDifficulty[DifficultyId] then
                DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
            end
            table.insert(ct, ":难度等级[")
            table.insert(ct, DifficultyLevel)
            table.insert(ct, "]")
        end
        table.insert(ct, "\n")
    else
        table.insert(ct, "单机\n")
    end

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if IsDedicatedServer(self) then
        local AllPlayer = GameMode:GetAllPlayer()
        for i, Player in pairs(AllPlayer) do
            table.insert(ct, "[")
            table.insert(ct, i)
            table.insert(ct, "]")
            self:FillCharacterLog_Monster(ct, Player)
            table.insert(ct, "\n")
        end
    else
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        local CurrentRoleId = nil
        if Player then
            CurrentRoleId = Player.CurrentRoleId
        end
        self:FillCharacterLog_Monster(ct, Player)
        table.insert(ct, "\n")
    end

    local GameState = UE.UGameplayStatics.GetGameState(self.Player)
    if IsValid(GameState) then
        local DungeonId = GameState.DungeonId
        if DungeonId and DungeonId > 0 then
            table.insert(ct, "副本ID:")
            table.insert(ct, tostring(DungeonId))
            local DungeonInfo = DataMgr.Dungeon[DungeonId]
            if DungeonInfo then
                local DungeonName = DungeonInfo.DungeonName
                if DungeonName and DataMgr.TextMap[DungeonName] then
                    DungeonName = GText(DungeonName)
                end
                table.insert(ct, "(")
                table.insert(ct, tostring(DungeonName))
                table.insert(ct, ")")
            end
            table.insert(ct, "\n")
        end
    end

    if IsValid(GameMode) and GameMode:IsInRegion() and Avatar then
        local RegionId = Avatar:GetCurrentRegionId()
        table.insert(ct, "子区域ID:")
        table.insert(ct, tostring(RegionId))
        local RegionInfo = DataMgr.SubRegion[RegionId]
        if RegionInfo then
            local RegionName = RegionInfo.SubRegionName
            if DataMgr.TextMap[RegionName] then
                RegionName = GText(RegionName)
            end
            table.insert(ct, "(")
            table.insert(ct, tostring(RegionName))
            table.insert(ct, ")")
        end
        table.insert(ct, "\n")
    end
end

function BP_Battle_C:FillCharacterLog_Monster(ct, Player)
    if not Player then
        return
    end
    local CurrentRoleId = Player.CurrentRoleId
    table.insert(ct, "使用角色ID:")
    table.insert(ct, tostring(CurrentRoleId))
    if DataMgr.BattleChar[CurrentRoleId] then
        local RoleName = GText(DataMgr.BattleChar[CurrentRoleId].CharName)
        table.insert(ct, "(")
        table.insert(ct, tostring(RoleName))
        table.insert(ct, ")")
    end
    -- if Player.MeleeWeapon then
    --     local WeaponId = Player.MeleeWeapon.WeaponId
    --     table.insert(ct, ",近战武器ID:")
    --     table.insert(ct, tostring(Player.MeleeWeapon.WeaponId))
    --     local WeaponInfo = DataMgr.Weapon[WeaponId]
    --     if WeaponInfo then
    --         local WeaponName = WeaponInfo.WeaponName
    --         if DataMgr.TextMap[WeaponName] then
    --             WeaponName = GText(WeaponName)
    --         end
    --         if WeaponName then
    --             table.insert(ct, "(")
    --             table.insert(ct, WeaponName)
    --             table.insert(ct, ")")
    --         end
    --     end
    -- end
    -- if Player.RangedWeapon then
    --     local WeaponId = Player.RangedWeapon.WeaponId
    --     table.insert(ct, ",远程武器ID:")
    --     table.insert(ct, tostring(Player.RangedWeapon.WeaponId))
    --     local WeaponInfo = DataMgr.Weapon[WeaponId]
    --     if WeaponInfo then
    --         local WeaponName = WeaponInfo.WeaponName
    --         if DataMgr.TextMap[WeaponName] then
    --             WeaponName = GText(WeaponName)
    --         end
    --         if WeaponName then
    --             table.insert(ct, "(")
    --             table.insert(ct, WeaponName)
    --             table.insert(ct, ")")
    --         end
    --     end
    -- end

    if Player:IsPlayer() then
        local Flag = false
        local PhantomTeammate = Player:GetPhantomTeammates()
        for _, Target in pairs(PhantomTeammate) do
            if Target ~= Player then
                if not Flag then
                    table.insert(ct, "\n正在使用的魅影信息:")
                    Flag = true
                end
                table.insert(ct, "\n\t")
                self:FillCharacterLog_Monster(ct, Target)
            end
        end
    end
end

function BP_Battle_C:IsInSettlement()
    return UIManager(self):GetUI("DungeonSettlement") ~= nil
end

AssembleComponents(BP_Battle_C)
return BP_Battle_C