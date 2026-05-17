--[[
Info : 
{
	number : UnitId,
	string : UnitType,
	IStaticCreatorInterface : Creator,
	number : Eid,
	string : WorldRegionEid
}
--]]

require "UnLua"
require "DataMgr"
require "Const"
local MiscUtils = require "Utils.MiscUtils"
local Utils = require "Utils"
local EventTrigger = require "BluePrints.Combat.EventTrigger"
-- GFuncLib = require "BluePrints.Common.BP_GlobalFunctionLibrary_C"

local BP_EventMgr_C = Class()

function BP_EventMgr_C:Initialize(Initializer)
    self.EventTriggers = {}
    self.FramingCreateUintQueue = {}
    self.AysncQueueChangedDelegates = {}
	self.AsyncCreateActorNum = 0 -- 追踪Actor的创建

    self.LoadingClassMonsterQueue = {} -- 从CreateAIUnit到LoadClassFinish的队列
    self.InitializeMonsterQueue = {}   -- 从LoadClassFinish到初始化完成的队列
    -- self:InitializeSummonCacheParams()
    self.AsyncQueueIndex = 1
    self.AsyncQueueTypeArray = {}
    for Key, Value in pairs(Const.OpenFramingCreateUnit) do
        if (Value) then
            table.insert(self.AsyncQueueTypeArray,Key)
            self.FramingCreateUintQueue[Key] = {}
        end
    end
end

function BP_EventMgr_C:InitializeSummonCacheParams()
    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName()
    -- self.bSummonCanDeadCache = Const.SummonDeadCache_Windows
    -- self.bPlayerCanPreloadSummon = Const.PlayerPreloadSummon_Windows
    -- if PlatformName == "Android" then
    --     self.bSummonCanDeadCache = Const.SummonDeadCache_Android
    --     self.bPlayerCanPreloadSummon = Const.PlayerPreloadSummon_Android
    -- elseif PlatformName == "IOS" then
    --     self.bSummonCanDeadCache = Const.SummonDeadCache_IOS
    --     self.bPlayerCanPreloadSummon = Const.PlayerPreloadSummon_IOS
    -- end
    self.bCustomNpcOpenCreateOpt = Const.CustomNpcCreateOpt
end

function BP_EventMgr_C:InitAIUnitCacheParams()
    self.bStandAloneMonsterCanCache = Const.StandAloneMonsterCanCache
    self.bOnlineMonsterCanCache = Const.OnlineMonsterCanCache
    self.bMonsterCanSpawnFromCache = Const.MonsterCanSpawnFromCache
end

function BP_EventMgr_C:AddTrigger(TriggerId)
    local NewTrigger = EventTrigger:New({}, TriggerId)
    table.insert(self.EventTriggers, NewTrigger)
end

function BP_EventMgr_C:ReceiveBeginPlay()
    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName()
    if PlatformName == "Android" then
        self.bEnableCreateUnitCtrlOpt = true
    else
        self.bEnableCreateUnitCtrlOpt = false
    end
    
    -- rawset(self, "MonsterInfoQueue", {})      --  CreateAIUnit限制怪物数量
    --self:AddTrigger(1)
    -- self.TriggerTimerHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, BP_EventMgr_C.CheckTriggers}, 2.0, true)
end

-- function BP_EventMgr_C:ReceiveTick(DeltaSeconds)
--     self.Overridden.ReceiveTick(self, DeltaSeconds)

--     for i = #self.MonsterInfoQueue, 1, -1 do
--         if self:CheckCreateMonster(self.MonsterInfoQueue[i].UnitId) then
--             self:CreateAIUnit(self.MonsterInfoQueue[i], false, true)
--             table.remove(self.MonsterInfoQueue, i)
--             break
--         end
--     end

--     if not self.bEnableCreateUnitCtrlOpt or self.CreateUnitCtrlType == ECreateUnitCtrlType.NoCtrl or self.CreateUnitCtrlType == ECreateUnitCtrlType.RealInitCtrl then
--         self.AsyncQueueIndex = self.AsyncQueueIndex % (#self.AsyncQueueTypeArray)
--         local bHasAnythingCreated = false
--         for Index = self.AsyncQueueIndex,#self.AsyncQueueTypeArray do
--             local UnitType = self.AsyncQueueTypeArray[Index]
--             local CreateUnitCount = Const.FrameCreateUnitCount[UnitType]
--             local FramingQueue = self.FramingCreateUintQueue[UnitType]
--             self.AsyncQueueIndex = Index
--             if not CreateUnitCount then
--                 CreateUnitCount = 1
--             end
--             if FramingQueue then
--                 for i = 1, CreateUnitCount do
--                     if #FramingQueue == 0 then
--                         break
--                     end
--                     local UnitInfo = FramingQueue[1]
--                     table.remove(FramingQueue, 1)
--                     if UnitType == "Monster" then
--                         self.CreateUnitCtrlType = ECreateUnitCtrlType.RealCreateCtrl
--                     else
--                         self.CreateUnitCtrlType = ECreateUnitCtrlType.NoCtrl
--                     end
--                     self:RealCreateUnit(UnitInfo)
--                     bHasAnythingCreated = true
--                 end
    
--                 if (bHasAnythingCreated) then
--                     break
--                 end
--             end
--         end
--         if bHasAnythingCreated == false then
--             self.CreateUnitCtrlType = ECreateUnitCtrlType.NoCtrl
--         end
--         self.AsyncQueueIndex = self.AsyncQueueIndex + 1
--     else
--         self.CreateUnitCtrlType = ECreateUnitCtrlType.NoCtrl
--     end

--     -- for UnitType, FramingQueue in pairs(self.FramingCreateUintQueue) do
--     --     local CreateUnitCount = Const.FrameCreateUnitCount[UnitType]
--     --     if not CreateUnitCount then
--     --         CreateUnitCount = 1
--     --     end

--     --     for i = 1, CreateUnitCount do
--     --         if #FramingQueue == 0 then
--     --             break
--     --         end
--     --         local UnitInfo = FramingQueue[1]
--     --         table.remove(FramingQueue, 1)
--     --         self:RealCreateUnit(UnitInfo)
--     --     end
--     -- end
-- end

function BP_EventMgr_C:TryEndLoading()
	for UnitType, FramingQueue in pairs(self.FramingCreateUintQueue) do
		if #FramingQueue > 0 then
			return false
		end
	end
	if self.AsyncCreateActorNum > 0 then
		return false
	end
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState then
		return false
	end
	if not GameState.bRegionPreCreateUnitReady then
		GameState.bRegionPreCreateUnitReady = true
		GameState:TryEndLoading("RegionPreCreateUnitReady")
	end
	return true
end

function BP_EventMgr_C:CheckTriggers()
    local i = 1
    while i <= #self.EventTriggers do
        if self.EventTriggers[i].IsTriggered() then
            self:TriggerATrigger(self.EventTriggers[i])
            table.remove(self.EventTriggers, i)
        else
            i = i + 1
        end
    end
    --self:AddTrigger(1)
end

function BP_EventMgr_C:TriggerATrigger(Trigger)
    for Index, EventId in Trigger.Events do
        self:TriggerEvent(EventId)
    end
end

function BP_EventMgr_C:TriggerEvent(EventId)
    --EventData,
end

-- function BP_EventMgr_C:TriggerCreateMonsterSpawn(UnitSpawnId, OnlyRelation)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     -- if not OnlyRelation and GameMode.MonsterSpawnMap:FindRef(UnitSpawnId) then 
--     if GameMode.MonsterSpawnMap:FindRef(UnitSpawnId) then
--         return
--     end
--     local MonsterSpawn = self:GetWorld():SpawnActor(GameMode.MonsterSpawnPath, self:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
--     MonsterSpawn:InitMonsterSpawn(UnitSpawnId, OnlyRelation)
--     if not IsValid(MonsterSpawn) then
--         print(_G.LogTag, "ERROR: MonsterSpawn destroyed when init", UnitSpawnId)
--         return
--     end
--     if MonsterSpawn.InitSuccess then
--         GameMode.MonsterSpawnMap:Add(UnitSpawnId, MonsterSpawn)
--     end
-- end

function BP_EventMgr_C:GMCreateNpc(UnitId, Num, Level, CreatorType)
    DebugPrint(UE4.UKismetSystemLibrary.GetFrameCount(),"==========GMCreateNpc============================")
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Location = FVector(0,0,0)
    if IsValid(Player) then
        Location = Player:K2_GetActorLocation() + Player:GetActorForwardVector() * 100
    end

    local Creator = nil
    local MonsterSpawn = nil
    if CreatorType == "StaticCreator" then
        Creator = UE4.UGameplayStatics.GetGameMode(self).FixedCreator
    elseif CreatorType == "MonsterSpawn" then
        MonsterSpawn = UE4.UGameplayStatics.GetGameMode(self).FixedMonsterSpawn
    end
    for i=1, Num do
        local Context = AEventMgr.CreateUnitContext()
        Context.UnitId = tonumber(UnitId)
        Context.UnitType = "Npc"
        Context.Loc = Location
        Context.IntParams:Add("Level", tonumber(Level) or 1)
        Context.Creator = Creator
        Context.MonsterSpawn = MonsterSpawn
        Context.BoolParams:Add("FixLocation", true)
        self:CreateUnitNew(Context, false)
    end
end

function BP_EventMgr_C:GMCreatePet(UnitId, Num)
    DebugPrint(UE4.UKismetSystemLibrary.GetFrameCount(),"==========GMCreatePet============================")
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Location = FVector(0,0,0)
    if IsValid(Player) then
        Location = Player:K2_GetActorLocation() + Player:GetActorForwardVector() * 100
    end

    for i=1, Num do
        local Context = AEventMgr.CreateUnitContext()
        Context.UnitId = tonumber(UnitId)
        Context.UnitType = "Pet"
        Context.Loc = Location
        Context.IntParams:Add("Level", 1)
        Context.IntParams:Add("RegionDataType", 1)
        Context.BoolParams:Add("FixLocation", false)
        self:CreateUnitNew(Context, false)
    end
end

function BP_EventMgr_C:GMCreateMonster(Eid, UnitId, Num, Level, CreatorType, ForceLOD)
    local Player = Battle(self):GetEntity(Eid)
    local Location = FVector(0,0,0)
    if IsValid(Player) then
        Location = Player:K2_GetActorLocation() + Player:GetActorForwardVector() * 100
    end

    local Creator = nil
    local MonsterSpawn = nil
    if CreatorType == "StaticCreator" then
        Creator = UE4.UGameplayStatics.GetGameMode(self).FixedCreator
    elseif CreatorType == "MonsterSpawn" then
        MonsterSpawn = UE4.UGameplayStatics.GetGameMode(self).FixedMonsterSpawn
    end
    for i=1, Num do
        local function LoadFinishCallbackNew(_, Unit)
            if ForceLOD ~= nil then
                Unit.Mesh:SetForcedLOD(tonumber(ForceLOD)) 
            end
        end        
        local Context = AEventMgr.CreateUnitContext()
        Context.UnitId = tonumber(UnitId)
        Context.UnitType = "Monster"
        Context.Loc = Location
        Context.IntParams:Add("Level", tonumber(Level) or 1)
        Context.Creator = Creator
        Context.MonsterSpawn = MonsterSpawn
        Context.BoolParams:Add("FixLocation", true)
        Context.BoolParams:Add("FromGM", true)
        if ForceLOD ~= nil then
            Context.OnUnitInitCreateReadyDynamic:Add(self, LoadFinishCallbackNew)
        end
        self:CreateUnitNew(Context, false)
    end
end

function BP_EventMgr_C:GMCreateTestMonster(Eid, Id, Num, Loc, Callback, Args)
    -- 要求生成高血量无AI版本的怪物，不方便合并到已有的创建函数，因此单独写一个
    local ActorType = "Monster"
    local UnitId = tonumber(Id)
    local ActorData = DataMgr[ActorType][UnitId]
    local ActorPath = ActorData.UnitBPPath
    local Player = Battle(self):GetEntity(Eid)
    local Location = Loc or FVector(0,0,0)
    if IsValid(Player) and not Loc then
        Location = Player:K2_GetActorLocation() + Player:GetActorForwardVector() * 100
    end
    local Unit = nil
    for i=1, Num do
        local function LoadClassFinished(self, UnitBlueprint)
            local BTObject = LoadObject("/Game/AssetDesign/AI/Z_Misc_Test/BT/TestNew.TestNew") or nil
            -- MiscUtils.SaveCacheClass(ActorPath, UnitBlueprint)
            Unit = URuntimeCommonFunctionLibrary.SpawnAIFromClass(self, UnitBlueprint, BTObject, Location, FRotator(0,0,0), UE4.ESpawnActorCollisionHandlingMethod.AdjustIfPossibleButAlwaysSpawn, nil)
            local function LoadFinishCallback(Unit)
                Unit:SetAttr("MaxHp", 999999999)
                Unit:SetAttr("MaxES", 5000)
                Unit:SetAttr("ES", 5000)
                if Callback then
                    Callback(Unit)
                end
            end
            local function LoadFinishCallbackNew(_, Unit)
                Unit:SetAttr("MaxHp", 999999999)
                Unit:SetAttr("MaxES", 5000)
                Unit:SetAttr("ES", 5000)
                if Callback then
                    Callback(Unit)
                end
            end

            local Eid = UE4.UGameplayStatics.GetGameMode(self):GetBattleEid()
            local Context = AEventMgr.CreateUnitContext()
            Context.UnitId = UnitId
            Context.UnitType = "Monster"
            Context.Loc = Location
            Context.IntParams:Add("Eid", Eid)
            Context:AddObjectParams("BTObject", BTObject)
            Context:AddLuaTable("Args", Args)
            Context.OnUnitInitCreateReadyDynamic:Add(self, LoadFinishCallbackNew)
            Context.Unit = Unit
            Unit.UnitId = UnitId
            Unit:SetEid(Eid)
            self:RegisterCreateData(Eid, Context)
            Unit:RegisterInfoNew(Context)
        end
        local UnitClass = MiscUtils.GetCacheClass(ActorPath)
        if UnitClass then
            LoadClassFinished(self, UnitClass)
        else
            UE4.UResourceLibrary.LoadClassAsync(self, ActorPath, {self, LoadClassFinished})
        end
    end
end

function BP_EventMgr_C:GMCreateMechanismSummon(Eid, UnitId, Num, Level)
    local Player = Battle(self):GetEntity(Eid)
    local Location = FVector(0,0,0)
    if IsValid(Player) then
        Location = Player:K2_GetActorLocation() + Player:GetActorForwardVector() * 100
    end
    for i=1, Num do
        local Context = AEventMgr.CreateUnitContext()
        Context.UnitId = tonumber(UnitId)
        Context.UnitType = "MechanismSummon"
        Context.Loc = Location
        Context.IntParams:Add("Level", tonumber(Level) or 1)
        Context.DirectSource = Player
        Context.BoolParams:Add("FixLocation", true)
        self:CreateUnitNew(Context, false)
    end
end

function BP_EventMgr_C:CreateAIUnitFromCache(Info)
    if not Const.StandAloneMonsterCanCache and IsStandAlone(self) then
        return false
    end
    if not Const.OnlineMonsterCanCache and not IsStandAlone(self) then
        return false
    end
    if not Const.MonsterCanSpawnFromCache then
        return false
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    -- 从死亡缓存池拿动态怪
    if Info.MonsterSpawn~=nil and GameState:HasMonsterCache(Info.UnitId) then
        local BTObject = Info.BT and LoadObject(Info.BT) or nil
        local Unit = GameState:CreateAIUnitFromCache(Info.UnitId, BTObject, Info.Loc, Info.Rotation)
        Info.BTObject = BTObject
        Info.InitType = "FromCache"
        self:AddInitializeMonsterQueue(Info)
        Unit:RegisterInfo(Info)

        self:FixPawnLocation(Unit, Info, Unit:IsAIControlled() == true and Unit:IsSummonMonster() == false)
        return true
    end

    -- 从LoadingPool拿动态怪
    if Info.MonsterSpawn~=nil and GameState:HasMonsterInPool(Info.UnitId) then
        local BTObject = Info.BT and LoadObject(Info.BT) or nil
        local Unit = GameState:GetMonsterFromPool(Info.UnitId, BTObject, Info.Loc, Info.Rotation)
        if Unit == nil then
            return false
        end
        Info.BTObject = BTObject
        if Info.SkillLevelSource then
            Unit:SetSkillLevelInfo(Info.SkillLevelSource:GetSkillLevelInfo())
        end
        if Info.SourceSkillId and Unit.SetSourceSkillId then
            Unit:SetSourceSkillId(Info.SourceSkillId)
        end

        -- OK的改成这个问题不大,InitFromPool InitFromCache 本来就差不多
        Info.InitType = "FromCache"
        self:AddInitializeMonsterQueue(Info)
        Unit:RegisterInfo(Info)

        self:FixPawnLocation(Unit, Info, Unit:IsAIControlled() == true and Unit:IsSummonMonster() == false)
        return true
    end

    -- 从LoadingPool拿静态怪
    if GameState:HasMonsterInStaticPool(Info.UnitId) then
        local BTObject = Info.BT and LoadObject(Info.BT) or nil
        local Unit = GameState:GetMonsterFromStaticPool(Info.UnitId, BTObject, Info.Loc, Info.Rotation)
        if Unit == nil then
            return false
        end
        Info.BTObject = BTObject
        if Info.SkillLevelSource then
            Unit:SetSkillLevelInfo(Info.SkillLevelSource:GetSkillLevelInfo())
        end
        if Info.SourceSkillId and Unit.SetSourceSkillId then
            Unit:SetSourceSkillId(Info.SourceSkillId)
        end

        Info.InitType = "FromCache"
        self:AddInitializeMonsterQueue(Info)
        Unit:RegisterInfo(Info)

        self:FixPawnLocation(Unit, Info, Unit:IsAIControlled() == true and Unit:IsSummonMonster() == false)
        return true
    end

    -- 从LoadingPool拿Summon
    if self.bPlayerCanPreloadSummon and Info.DirectSource~=nil and GameState:HasSummonMonsterInPool(Info.UnitId) then
        local BTObject = Info.BT and LoadObject(Info.BT) or nil
        local Unit = GameState:GetSummonMonFromPool(Info.UnitId, BTObject, Info.Loc, Info.Rotation)
        if Unit == nil then
            return false
        end
        Info.BTObject = BTObject
        if Info.SkillLevelSource then
            Unit:SetSkillLevelInfo(Info.SkillLevelSource:GetSkillLevelInfo())
        end
        if Info.SourceSkillId and Unit.SetSourceSkillId then
            Unit:SetSourceSkillId(Info.SourceSkillId)
        end

        Info.InitType = "FromCache"
        self:AddInitializeMonsterQueue(Info)
        Unit:RegisterInfo(Info)
        return true
    end

    -- 从死亡缓存池拿Summon
    if self.bSummonCanDeadCache and Info.DirectSource~=nil and GameState:HasSummonsterInDeadCache(Info.UnitId) then
        local BTObject = Info.BT and LoadObject(Info.BT) or nil
        local Unit = GameState:GetSummonFromDeadCache(Info.UnitId, BTObject, Info.Loc, Info.Rotation)
        Info.BTObject = BTObject
        Info.InitType = "FromCache"
        self:AddInitializeMonsterQueue(Info)
        Unit:RegisterInfo(Info)
        return true
    end
    return false
end

function BP_EventMgr_C:SnapShotCreateUnit(SpawnData, Creator)
    -- if IsValid(Battle(self):GetEntity(SpawnData.SnapShotId)) then
    --     DebugPrint("SnapShot Error! 禁止恢复一个Eid重复的Actor LevelName:", SpawnData.LevelName, "UnitId:", SpawnData.UnitId, "UnitType:", SpawnData.UnitType, 
    --             "Eid:", SpawnData.SnapShotId, "Location:", Location, "CreatorId:", SpawnData.CreatorId, "BornPos:", SpawnData.BornPos, "PrivateEnable:", SpawnData.PrivateEnable)
    --     return
    -- end
    -- --随机点需要将用到的参数注册到管理器中，所以与静态点分开处理
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- local Creator = GameMode:GetCreatorOnSnapShotCreateUnit(SpawnData.RuleId, SpawnData.RandomCreatorId, SpawnData.LevelName, SpawnData.CreatorId, SpawnData.PrivateEnable)
    -- if SpawnData.RuleId ~= 0 then
    --     local RandomActorManager = UE4.UGameplayStatics.GetGameMode(self).RandomActorManager
    --     local IdxInRule = RandomActorManager:GetCreatorRegionDataIdxInRule(SpawnData.RuleId, SpawnData.RandomCreatorId)
    --     Creator = RandomActorManager:GetCreator(SpawnData.RuleId, SpawnData.LevelName, IdxInRule)
    -- else
    --     Creator = UE4.UGameplayStatics.GetGameState(self):GetStaticCreatorInfo(SpawnData.CreatorId, SpawnData.PrivateEnable, SpawnData.LevelName)
    -- end
    local Location = FVector(SpawnData.Trans.Translation.X, SpawnData.Trans.Translation.Y, SpawnData.Trans.Translation.Z)
    local BornPos = FVector(SpawnData.BornPos.X,SpawnData.BornPos.Y,SpawnData.BornPos.Z)
    local Context = AEventMgr.CreateUnitContext()
    Context.StrParams:Add("LevelName", SpawnData.LevelName)
    Context.UnitId = SpawnData.UnitId
    Context.UnitType = SpawnData.UnitType
    Context.IntParams:Add("Eid", SpawnData.SnapShotId)
    Context.Loc = Location
    Context.IntParams:Add("Level", SpawnData.Level)
    Context.Rotation = SpawnData.Trans.Rotation:ToRotator()
    Context.Creator = Creator
    Context:AddObjectParams("BTObject", Creator and Creator.BornChangeBT)
    Context.IntParams:Add("RandomCreatorId", SpawnData.RandomCreatorId)
    Context.IntParams:Add("RandomRuleId", SpawnData.RuleId)
    Context.IntParams:Add("RandomTableId", SpawnData.RandomTableId)
    Context.VectorParams:Add("BornPos", BornPos)
    self:CreateUnitNew(Context, false)
    DebugPrint("SnapShot: 副本序列化恢复, LevelName:", SpawnData.LevelName, "UnitId:", SpawnData.UnitId,
            "UnitType:", SpawnData.UnitType, "Eid:", SpawnData.SnapShotId, "Location:", Location,
            "CreatorId:", SpawnData.CreatorId, "BornPos:", SpawnData.BornPos,
            "PrivateEnable:", SpawnData.PrivateEnable, "RandomCreatorId:", SpawnData.RandomCreatorId,
            "RandomRuleId:", SpawnData.RuleId, "RandomTableId", SpawnData.RandomTableId)
end
function BP_EventMgr_C:PostProcessInfo(Info)
	local function CheckRarity(Info)
		return DataMgr.Drop[Info.UnitId].Rarity >= 3
	end
	if Info.UnitType == "Drop" and Info.UnitId then
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar:IsInHardBoss() then
            Info.RegionDataType = ERegionDataType.RDT_HardBossData
            return
        end
		if Info.RegionDataType and Info.RegionDataType ~= ERegionDataType.RDT_RarelyData and Info.RegionDataType ~= ERegionDataType.RDT_QuestData then
			if not CheckRarity(Info) then
				Info.RegionDataType = ERegionDataType.RDT_None
			end
		end
	end
end

function BP_EventMgr_C:OnRegionDataClaimed_Lua(WorldRegionEid)
    -- self:TryRemoveNpcLoadingInfo(WorldRegionEid)
	for UnitType, AsyncTable in pairs(self.FramingCreateUintQueue) do
		for i, AsyncInfo in ipairs(AsyncTable) do
			if AsyncInfo.WorldRegionEid == WorldRegionEid then
				table.remove(AsyncTable, i)
				return
			end
		end
	end
	if self.LoadingClassMonsterQueue[WorldRegionEid] then
		self.LoadingClassMonsterQueue[WorldRegionEid] = nil
	end
end

-- function BP_EventMgr_C:TryRemoveNpcLoadingInfo(WorldRegionEid)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if (not GameMode) or (not GameState) then
--         return
--     end
--     local RegionDataMgrSubsystem = GameMode:GetRegionDataMgrSubSystem()
--     if not RegionDataMgrSubsystem then
--         return
--     end

--     local LuaTableIndex = RegionDataMgrSubsystem:GetLuaDataIndex(WorldRegionEid)
--     local Info = RegionDataMgrSubsystem.DataPool:GetRegionEntityData(LuaTableIndex)
-- 	if not Info then
-- 		return
-- 	end
--     if Info.UnitId and GameState.NpcLoadingArray:Contains(Info.UnitId) then
--         GameState.NpcLoadingArray:RemoveItem(Info.UnitId)
--     end
-- end

function BP_EventMgr_C:OnSpecialQuestBegin()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode or not GameMode:GetRegionDataMgrSubSystem() then return end
    local RegionDataMgrSubsystem = GameMode:GetRegionDataMgrSubSystem()
    local RegionDataLibrary = RegionDataMgrSubsystem.DataLibrary
    if not RegionDataLibrary then return end
	for UnitType, AsyncTable in pairs(self.FramingCreateUintQueue) do
        local WaitingRemove = {}
        for _,AsyncInfo in pairs(AsyncTable) do
            if not RegionDataLibrary:CheckCanCreateWhileSpecialQuest(AsyncInfo.Creator or AsyncInfo) then
                DebugPrint("BP_EventMgr_C:OnSpecialQuestBegin ",UnitType,AsyncInfo.WorldRegionEid)
                RegionDataMgrSubsystem:ClaimRegionData(AsyncInfo.WorldRegionEid)
                table.insert(WaitingRemove,AsyncInfo.WorldRegionEid)
            end
        end
        
        for _,WorldRegionEid in pairs(WaitingRemove) do
            self:OnRegionDataClaimed_Lua(WorldRegionEid)
        end
	end

    for Eid,Info in pairs(self.LoadingClassMonsterQueue) do
        if Info.WorldRegionEid and not RegionDataLibrary:CheckCanCreateWhileSpecialQuest(Info.Creator) then
            RegionDataMgrSubsystem:ClaimRegionData(Info.WorldRegionEid)
            self:OnRegionDataClaimed_Lua(Info.WorldRegionEid)
            self.LoadingClassMonsterQueue[Info.WorldRegionEid] = nil
            DebugPrint("BP_EventMgr_C:OnSpecialQuestBegin LoadingClassMonsterQueue",Info.WorldRegionEid)
        end 
    end

    for Eid,Info in pairs(self.InitializeMonsterQueue) do
        if not RegionDataLibrary:CheckCanCreateWhileSpecialQuest(Info.Creator) then
            Info.DestroySelf = true
            Info.DestroySelfReason = EDestroyReason.SepcialQuestStart
        end
    end
end

function BP_EventMgr_C:PreCreateRegionInfo(Info, bForceSync)
	if type(Info) ~= "table" then
		DebugPrint("NOINFO")
		return
	end
    if Info.ExtraCreateInfo then
        for k,v in pairs(Info.ExtraCreateInfo) do
            Info[k] = v
        end
    end
    if Info.UnitType == "Gizmo" then
        Info.UnitType = "Mechanism"
    end
    if Info.UnitId == 0 then
        return
    end
	if Info.UnitType == "Monster" and Info.UnitId ~= 7007002 then
		return
	end

    self:PostProcessInfo(Info)
end

function BP_EventMgr_C:CanRegionSerialize(Info)
    if Const.RegionSerializeUnitType[Info.UnitType] == nil then
        return false
    end

    if Info.UnitType == "Phantom" and not Info.IsNPCPhantom then
        return false
    end

    return true
end

function BP_EventMgr_C:PostCreateRegionInfo(Info, bForceSync)
	-- local CreatorId = -1
	-- if Info.Creator then
	-- 	CreatorId = Info.CreatorId or Info.Creator.StaticCreatorId
	-- end
	-- if Info.UnitType == "Monster" and CreatorId ~= 1180392 then
	-- 	return
	-- end
    if not bForceSync then
        if not self.FramingCreateUintQueue[Info.UnitType] then
            self.FramingCreateUintQueue[Info.UnitType] = {}
            table.insert(self.AsyncQueueTypeArray,Info.UnitType)
        end
        if not table.findValue(self.AsyncQueueTypeArray,Info.UnitType) then
            table.insert(self.AsyncQueueTypeArray,Info.UnitType)
        end
        table.insert(self.FramingCreateUintQueue[Info.UnitType], Info)
    else
        self:RealCreateUnit(Info, bForceSync)
	end
end

--NPC映射
function BP_EventMgr_C:ChangeNpcInfoByGender(Info)
    if DataMgr.NPC[Info.UnitId] == nil or DataMgr.NPC[Info.UnitId].PlayerInfo ~= 1 then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then
        Utils.ScreenPrint("Error ChangeNpcInfoByGender Avatar == nil, NPCId:" .. Info.UnitId)
        return
    end
    local FakeNpcInfo = nil
    for _, value in pairs(DataMgr.GenderToNpcId) do
        if value.NpcId and value.NpcId == Info.UnitId then
            FakeNpcInfo = value
            break
        end
    end

    if FakeNpcInfo == nil then
        Utils.ScreenPrint("Error ChangeNpcInfoByGender FakeNpcInfo == nil, NPCId:" .. Info.UnitId)
        return
    end
    local FakeNpcInfo2 = nil
    for _, value in pairs(DataMgr.GenderToNpcId) do
        if value.GroupId and value.GroupId == FakeNpcInfo.GroupId and value.Gender ~= FakeNpcInfo.Gender then
            FakeNpcInfo2 = value
            break
        end
    end
    if FakeNpcInfo2 == nil then
        Utils.ScreenPrint("Error ChangeNpcInfoByGender FakeNpcInfo2 == nil, NPCId:" .. Info.UnitId)
        return
    end
    local AvatarGender = nil
    if FakeNpcInfo2.SwitchPlayer == "Player" then
        AvatarGender = Avatar.Sex
    elseif FakeNpcInfo2.SwitchPlayer == "EXPlayer" then
        AvatarGender = Avatar.WeitaSex
    end
    if AvatarGender == nil then
        Utils.ScreenPrint("Error ChangeNpcInfoByGender AvatarGender == nil, NPCId:" .. Info.UnitId)
        return
    end
    local RealNpcInfo = nil
    if AvatarGender == FakeNpcInfo2.Gender then
        RealNpcInfo = FakeNpcInfo2
    elseif AvatarGender == FakeNpcInfo.Gender then
        RealNpcInfo = FakeNpcInfo
    end
    if RealNpcInfo == nil then
        Utils.ScreenPrint("Error ChangeNpcInfoByGender RealNpcInfo == nil, NPCId:" .. Info.UnitId)
        return
    end
    DebugPrint("FakeNpcId:",Info.UnitId,"RealNpcId:",RealNpcInfo.NpcId,"Gender:",RealNpcInfo.SwitchPlayer,AvatarGender)
    Info.UnitId = RealNpcInfo.NpcId
end

-- function BP_EventMgr_C:ServerCreateDrop(Info)
	-- self:PreCreateRegionInfo(Info)
	-- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	-- if GameMode and GameMode:GetWCSubSystem() then
	-- 	self:PreServerCreateDrop(Info.WorldRegionEid, GameMode:GetWCSubSystem():GetLocationLevelName(Info.Loc))
	-- end
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if GameMode then
    --     if URuntimeCommonFunctionLibrary.UseCppRegionData(self) and ( GameMode:IsInRegion() or not GWorld:GetAvatar())then
    --         if Info.WorldRegionEid then
    --             self:PreActorCreated(Info.WorldRegionEid)
    --         else
    --              Info.WorldRegionEid = self:PreActorCreated_Raw(Info.Loc)
    --         end
    --         GameMode:GetRegionDataMgrSubSystem():FillRegionData(Info)
    --     end
    -- end
	-- self:PostCreateRegionInfo(Info)
-- end

function BP_EventMgr_C:RealCreateUnit(Info, bForceSync)
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not Info.UnitType or not Info.UnitId then
		GameMode:GetRegionDataMgrSubSystem():PrintEntityData(Info.WorldRegionEid)
	end
    local ActorData = DataMgr[Info.UnitType][Info.UnitId]
    if ActorData == nil then
        if not Info.Creator then
            GWorld.logger.error("刷怪数据获取失败    UnitId:   ".. Info.UnitId.."   UnitType:  "..Info.UnitType)
            return
        end
        local ExploreActor = GameMode.EMGameState.ExploreGroupMap:FindRef(Info.Creator.RarelyId)
        local LevelName = GameMode:GetActorLevelName(Info.Creator)
        if ExploreActor then
            GWorld.logger.error("刷怪数据获取失败    UnitId:   ".. Info.UnitId.."   UnitType:  "..Info.UnitType.."  CreatorId: "..Info.Creator.StaticCreatorId..
            "  LevelName: "..tostring(Info.LevelName).."  ExploreActorName: "..ExploreActor:GetName().." StaticCreatorActor: "..Info.Creator:GetName())
        else
            GWorld.logger.error("刷怪数据获取失败    UnitId:   ".. Info.UnitId.."   UnitType:  "..Info.UnitType.."  CreatorId: "..Info.Creator.StaticCreatorId..
            "  LevelName: "..tostring(LevelName).." StaticCreatorActor: "..Info.Creator:GetName())
        end
        return
    end

    Info.ActorPath = ActorData.UnitBPPath
    if Info.UnitType ~= "Monster" then
        Info.BT = ActorData.BT
        if Info.BTIndex then
            Info.BT = Info.BT[Info.BTIndex]
        end
    end
    if Const.CreateType[Info.UnitType] == 1 then
        self:CreateAIUnit(Info, bForceSync)
    else
        self:CreateActorUnit(Info, bForceSync)
    end
end

function BP_EventMgr_C:NeedApplySubsidenceAdjust(Unit)
    -- 不是AI控制,返回false
    if Unit:IsAIControlled() == false then
        return false
    end
    local UnitId = Unit.UnitId
    -- Monster表中的 DontApplySubsidenceAdjust 为 true,返回false
    if DataMgr.Monster[UnitId] and DataMgr.Monster[UnitId].DontApplySubsidenceAdjust then
        return false
    end
    return true
end

-- 生成AI
function BP_EventMgr_C:CreateAIUnit(Info, bForceSync, bFromMonsterLimitQueue)
    if Const.EnableCreateUnitLog then
        print(_G.LogTag, "CreateAIUnit", Info.UnitId)
        PrintTable(Info)
    end

    if not bFromMonsterLimitQueue and not self:CheckCreateAIUnit(Info) then
        table.insert(self.MonsterInfoQueue, Info)
        return
    end

    if Info.UnitType=="Monster" and Info.DirectSource and Info.CreateUnitId then
        if not self:PreCheckDirectSourceHadUnit(Info.DirectSource,Info.CreateUnitId) then
            DebugPrint("BP_EventMgr_C CreateAIUnit DirectSource", Info.DirectSource:GetName(),
                "don't have CreateUnitId", Info.CreateUnitId, "return")
            return
        end
    end

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    Info.Eid = Info.Eid or GameMode:GetBattleEid()

    if Info.UnitType=="Monster" and self:CreateAIUnitFromCache(Info) then
        return
    end

    -- 入队
    if Info.WorldRegionEid then
        self.LoadingClassMonsterQueue[Info.WorldRegionEid] = Info
    end

    local function LoadClassFinished(self, UnitBlueprint)
        if Info.UnitType=="Monster" and Info.DirectSource and Info.CreateUnitId then
            if not self:PreCheckDirectSourceHadUnit(Info.DirectSource,Info.CreateUnitId) then
                DebugPrint("BP_EventMgr_C CreateAIUnit LoadClassFinished DirectSource", Info.DirectSource:GetName(),
                    "don't have CreateUnitId", Info.CreateUnitId, "return")
                return
            end
        end

		if Info.WorldRegionEid and not self.LoadingClassMonsterQueue[Info.WorldRegionEid] then
			DebugPrint("BP_EventMgr_C LoadClassFinished but", Info.WorldRegionEid, "已经被销毁了")
			return
		end

        if Info.WorldRegionEid then
            self.LoadingClassMonsterQueue[Info.WorldRegionEid] = nil -- 出队
        end

		GameMode.RegionDataIniting = true
        local Unit = URuntimeCommonFunctionLibrary.SpawnAIFromClass(self, UnitBlueprint, nil, Info.Loc, Info.Rotation, UE4.ESpawnActorCollisionHandlingMethod.AdjustIfPossibleButAlwaysSpawn, nil)
        if IsValid(Unit) == false then
            DebugPrint("BP_EventMgr_C CreateAIUnit Failed Please Check BPPath", Info.UnitId, Info.ActorPath)
            GWorld.logger.error("刷怪失败!请检查蓝图路径    UnitId:   ".. Info.UnitId.."   UnitType:  "..Info.UnitType)
            return
        end

        if Info.UnitType == "Npc" then
            local NeedReset = DataMgr.Npc[Info.UnitId].IgnoreFixLocation~=true
            self:FixPawnLocation(Unit, Info, NeedReset)
        end

        if Info.SkillLevelSource then
            Unit:SetSkillLevelInfo(Info.SkillLevelSource:GetSkillLevelInfo())
        end
        if Info.SourceSkillId and Unit.SetSourceSkillId then
            Unit:SetSourceSkillId(Info.SourceSkillId)
        end

        Info.InitType = "First"
        self:AddInitializeMonsterQueue(Info)
        Unit:RegisterInfo(Info)

        if Info.UnitType ~= "Npc" then
            self:FixPawnLocation(Unit, Info, self:NeedApplySubsidenceAdjust(Unit))
        end

    end
    local UnitClass = MiscUtils.GetCacheClass(Info.ActorPath)
    if UnitClass then
        LoadClassFinished(self, UnitClass)
    else
        if (not self:UseAsyncCreate(Info.UnitType, Info.UnitId)) or bForceSync then
            -- DebugPrint("BP_EventMgr_C 关闭分帧", Info.UnitType, Info.UnitId, bForceSync)
            local BPClass = LoadClass(Info.ActorPath)
            LoadClassFinished(self, BPClass)
        else
            -- DebugPrint("BP_EventMgr_C 使用分帧", Info.UnitType, Info.UnitId, bForceSync)
            UE4.UResourceLibrary.LoadClassAsync(self, Info.ActorPath,{self, LoadClassFinished})
        end
    end
end

function BP_EventMgr_C:RemoveUnitInQueue(WorldRegionEid, DestroyReason)
    -- if self.LoadingClassMonsterQueue[WorldRegionEid] then
    -- end
    self.LoadingClassMonsterQueue[WorldRegionEid] = nil
    if self.InitializeMonsterQueue[WorldRegionEid] then
        DebugPrint('Remove From InitializeMonsterQueue:', WorldRegionEid, DestroyReason)
        self.InitializeMonsterQueue[WorldRegionEid].DestroySelf = true
        self.InitializeMonsterQueue[WorldRegionEid].DestroySelfReason = DestroyReason
    end
end

function BP_EventMgr_C:CheckCreateAIUnit(Info)
    if Info.UnitType == "Monster" and not Info.SourceSkillId then
        return self:CheckCreateMonster(Info.UnitId)
    end
    return true
end

function BP_EventMgr_C:GetMaxDungeonMonNum()
    local DeviceType = CommonUtils.GetDeviceTypeByPlatformName(self)
    if DeviceType == "PC" then
        return Const.MaxDungeonMonNum_PC
    else
        return Const.MaxDungeonMonNum_Mobile
    end
end


-- return true 表示使用异步加载
function BP_EventMgr_C:UseAsyncCreate(UnitType, UnitId)
    -- 只有 Monster 表有这个关闭分帧的数据,其他Actor默认返回true,用 bForceSync 判断
    if UnitType ~= "Monster" then
        return true
    end
    -- 如果表格里有数据 且 关闭分帧为true, return false 判断 bForceSync
    if DataMgr.Monster[UnitId] and DataMgr.Monster[UnitId].DontApplyAsyncCreate == true then
        return false
    end
    -- 默认都使用异步加载
    return true
end

-- 生成Actor
function BP_EventMgr_C:CreateActorUnit(Info, bForceSync)
    local TraceType = Info.FixTraceChannel or "TraceCreatureHit"
    Info.Loc = self:FixLocation(Info.Loc, Info.FixLocation, Info.FixLocationZ or 50, Info.FixLocationStartZ or 200, Info.FixLocationEndZ or -1500, Const.FixTraceChannel[TraceType])
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    -- DebugPrint("ZJT_ 11111111111 CreateActorUnit ", Info.Loc, Info.UnitType, GameState:HasPickupCache(Info.UnitId))
    if Info.UnitType == "Drop" then
        local GameMode = UE.UGameplayStatics.GetGameMode(self)  
        local ItemLevelId = GameMode:GetItemLevelId(Info.Loc)
        Info.ItemLevelId = ItemLevelId
        if GameState:HasPickupCache(Info.ActorPath) then
            local Rotation = Info.Rotation or FRotator(0, 0, 0)
            local Transform = UKismetMathLibrary.MakeTransform(Info.Loc, Rotation, UE4.FVector(1, 1, 1))
            local Unit = GameState:CreatePickUpUnitFromCache(Info.ActorPath, Transform)
            -- Unit:K2_SetActorLocation(Info.Loc, false, nil, false)
            Unit:RegisterInfo(Info)
            -- DebugPrint("ZJT_ 11111111111 ", Unit:K2_GetActorLocation(), Unit:GetName())
            return
        else
            DebugPrint("Crack","New Drop Unit: ",Info.UnitId)
        end
    end
    local UnitType = Info.UnitType
    local DirectSource = Info.DirectSource
    local CreateUnitId = Info.CreateUnitId
    if UnitType == "MechanismSummon" and DirectSource and CreateUnitId then
        if not self:PreCheckDirectSourceHadUnit(Info.DirectSource, Info.CreateUnitId) then
            DebugPrint("BP_EventMgr_C CreateActorUnit DirectSource", Info.DirectSource:GetName(),
                    "don't have CreateUnitId", Info.CreateUnitId, "return")
            return
        end
    end
    local function LoadClassFinished(self, UnitBlueprint)
        if UnitType == "MechanismSummon" and DirectSource and CreateUnitId then
            if not self:PreCheckDirectSourceHadUnit(DirectSource, CreateUnitId) then
                DebugPrint("BP_EventMgr_C CreateActorUnit DirectSource", DirectSource:GetName(),
                        "don't have CreateUnitId", CreateUnitId, "return")
                return
            end
        end
        -- self.AsyncCreateActorNum = self.AsyncCreateActorNum - 1
        print(_G.LogTag,"LXZ LoadClassFinished00000")
        if IsValid(UnitBlueprint) == false then
            GWorld.logger.error("刷机关失败!UnitBlueprint错误 请检查蓝图路径    UnitId:   ".. Info.UnitId.."   UnitType:  "..Info.UnitType.."   ActorPath   "..Info.ActorPath)
            return
        end

        -- todo，这里会存在一种情况，区域内在异步加载过程中，外部（如任务系统）主动销毁这个数据，但是因为处于异步加载过程中，SSData还没清，任务删的是SSData.
        -- 但是Actor还是会被创建出来。因为现在创建Entity后删除SSData是在RegisterInfo里面，临时处理，区域判断SSData里是否还有该数据，没有的话直接退出。
        -- 待正式处理，维护一个加载中列表。
        local GameMode = UE.UGameplayStatics.GetGameMode(self)
		if not URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
			if GameMode and GameMode:IsInRegion() and Info.WorldRegionEid and Info.LevelName and 
					GameMode:GetRegionDataMgrSubSystem().DataLibrary:GetRegionSSDataByKey(Info.LevelName, Info.WorldRegionEid) == nil then
				return
			end
		end

        local Rotation = Info.Rotation or FRotator(0, 0, 0)
        local Transform = UE4.FTransform(Rotation:ToQuat(), Info.Loc)
		GameMode.RegionDataIniting = true
        local Unit = self:GetWorld():SpawnActor(UnitBlueprint, Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
        if IsValid(Unit) == false then
            GWorld.logger.error("刷机关失败!请检查蓝图路径    UnitId:   ".. Info.UnitId.."   UnitType:  "..Info.UnitType)
            return
        end
        if Info.SkillLevelSource and Unit.SetSkillLevelInfo then
            Unit:SetSkillLevelInfo(Info.SkillLevelSource:GetSkillLevelInfo())
        end
        if Info.SourceSkillId and Unit.SetSourceSkillId then
            Unit:SetSourceSkillId(Info.SourceSkillId)
        end
        print(_G.LogTag,"LXZ LoadClassFinished", Unit:GetName())
        if Unit.RegisterInfo then
            Unit:RegisterInfo(Info)
        else
            DebugPrint("CreateUnit: 创建了一个没有RegisterInfo方法的Actor Name:", Unit:GetName())
        end
    end
    if not bForceSync then
		-- self.AsyncCreateActorNum = self.AsyncCreateActorNum + 1
        UE4.UResourceLibrary.LoadClassAsync(self, Info.ActorPath,{self, LoadClassFinished})
    else
        local BPClass = LoadClass(Info.ActorPath)
        LoadClassFinished(self, BPClass)
    end
end

-- 将陷入碰撞体中或浮空的Pawn置于碰撞体表面
function BP_EventMgr_C:FixPawnLocation(Pawn, Info, IsNeedReset) --移到c++
    DebugPrint("BP_EventMgr_C:FixPawnLocation   ", Pawn:GetName(), Info.UnitId, Pawn.Eid, Info.Loc, Info.FixLocation, Info.FormationId, Info.FixNavLocation, IsNeedReset)
    local TraceType = Info.FixTraceChannel or "TraceCreatureHit"
    Info.Loc = self:FixLocation(Info.Loc, Info.FixLocation, Info.FixLocationZ or 50, Info.FixLocationStartZ or 200, Info.FixLocationEndZ or -1500, Const.FixTraceChannel[TraceType])
    Info.Loc = self:FixEliteLocation(Info.Loc, Info.FormationId or -1, Info.DirectSource)
	Info.Loc = self:FixNavLocation(Info.Loc, Info.FixNavLocation ~= nil)
    Pawn:K2_SetActorLocation(Info.Loc, false, nil, false)
    if IsNeedReset == false then
        return
    end
    URuntimeCommonFunctionLibrary.ResetCharacterBaseLocation(Pawn, Info.Loc)
    -- local SpawnPos = Pawn:K2_GetActorLocation()
    -- local HalfHeight = Pawn.CapsuleComponent:GetScaledCapsuleHalfHeight()
    -- local Radius = Pawn.CapsuleComponent:GetScaledCapsuleRadius()
    -- -- local MeshOffsetZ = -Pawn.Mesh.RelativeLocation.Z
    -- -- if MeshOffsetZ > HalfHeight and MeshOffsetZ < HalfHeight + 5 then
    -- --     HalfHeight = MeshOffsetZ
    -- -- end
	-- local Start = SpawnPos+ FVector(0,0,math.max(HalfHeight - Radius, Radius))
    -- local StartLine = SpawnPos+ FVector(0,0,HalfHeight)
	-- local End = SpawnPos + FVector(0,0,-HalfHeight*2)
	-- local HitResult = FHitResult()
    -- local OffsetZ = HalfHeight - Radius
	-- local Ret = UE4.UKismetSystemLibrary.CapsuleTraceSingle(self, Start, End, Radius, Radius, ETraceTypeQuery.TraceScene, false, nil, 2, HitResult, true)
    -- if Ret and HitResult.ImpactPoint.Z - InfoLoc.Z > Radius then
    --     DebugPrint("CapsuleTraceSingle 打中位置：",HitResult.ImpactPoint,"打中目标：",HitResult.Actor:GetName(),"Pawn名字：",Pawn:GetName())
    --     Ret = UE4.UKismetSystemLibrary.LineTraceSingle(self, StartLine, End, ETraceTypeQuery.TraceScene, false, nil, 2, HitResult, true)
    --     OffsetZ = HalfHeight
    -- end
	-- if(Ret) then
    --     local SurfacePos = FVector(HitResult.Location.X,HitResult.Location.Y,HitResult.Location.Z + OffsetZ)
    --     DebugPrint("半高：",HalfHeight,"打中位置：",HitResult.ImpactPoint,"打中目标：",HitResult.Actor:GetName(),"Pawn名字：",Pawn:GetName(),"SurfacePos：",SurfacePos,"============sssss================")
    --     Pawn:K2_SetActorLocation(SurfacePos, false, nil, false)
    -- elseif Pawn:IsRealMonster() then
    --     if SpawnPos.Z - HalfHeight < InfoLoc.Z then
    --         DebugPrint("半高：",HalfHeight,"InfoLoc：",InfoLoc,"SpawnPos：",SpawnPos,"Pawn名字：",Pawn:GetName(),"============sssss================")
    --         local SurfacePos = FVector(SpawnPos.X, SpawnPos.Y, InfoLoc.Z + HalfHeight)
    --         Pawn:K2_SetActorLocation(SurfacePos, false, nil, false)
    --     end
	-- end
end

function BP_EventMgr_C:GetDropRegionDataType(UnitId, TargetRegionDataType)
    local function CheckRarity()
		return DataMgr.Drop[UnitId].Rarity >= 3
	end
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar:IsInHardBoss() then
        return ERegionDataType.RDT_HardBossData
    end
    if TargetRegionDataType then
        if TargetRegionDataType == ERegionDataType.RDT_RarelyData then
            return ERegionDataType.RDT_RarelyData
        end
        if TargetRegionDataType == ERegionDataType.RDT_QuestData then
            return ERegionDataType.RDT_QuestData
        end
        if not CheckRarity() then
            return ERegionDataType.RDT_None
        end
        return TargetRegionDataType
    end
    return ERegionDataType.RDT_None
end

function BP_EventMgr_C:BuildDropInfo_Region(ItemId, Transform, Reason, ExtraInfo, bExtra, CreateIndex, DropRegionDatas)
    local Info = self:BuildDropInfo_Normal(ItemId, Transform, Reason, ExtraInfo, bExtra)
    if not DropRegionDatas or next(DropRegionDatas) == nil then
        local RegionDataType = self:GetDropRegionDataType(ItemId, ExtraInfo and ExtraInfo.RegionDataType or nil)
        Info.IntParams:Add("RegionDataType", RegionDataType)
        return Info 
    end
    local RegionDatas = DropRegionDatas[ItemId]
    -- PrintTable({DropRegionDatas = DropRegionDatas}, 10)
    -- PrintTable({RegionDatas = RegionDatas}, 10)
    -- DebugPrint("ZJT_ 11111111111111111 ",RegionDatas, type(ItemId), ItemId, Transform, Reason, ExtraInfo, bExtra, CreateIndex, DropRegionDatas)
    if not RegionDatas then
        local RegionDataType = self:GetDropRegionDataType(ItemId, ExtraInfo.RegionDataType)
        Info.IntParams:Add("RegionDataType", RegionDataType)
    else
        local RegionBaseData = RegionDatas[CreateIndex]
        if not RegionBaseData then
            local RegionDataType = self:GetDropRegionDataType(ItemId, ExtraInfo.RegionDataType)
            Info.IntParams:Add("RegionDataType", RegionDataType)
        else
            Info.NameParams:Add("WorldRegionEid", RegionBaseData.WorldRegionEid)
            -- Info.StrParams:Add("LevelName", RegionBaseData.LevelName)--注意：正常Create不应该有LevelName，用于判断是否需要弹射，AllocateRegionData时用Loc再计算一次
            Info.IntParams:Add("SubRegionId", RegionBaseData.SubRegionId)
            Info.IntParams:Add("RarelyId", RegionBaseData.RarelyId)
            Info.IntParams:Add("QuestChainId", RegionBaseData.QuestChainId)
            Info.IntParams:Add("RegionDataType", RegionBaseData.RegionDataType)
        end
        
    end     
    return Info
end
function BP_EventMgr_C:BuildDropInfo_Normal(ItemId, Transform, Reason, ExtraInfo, bExtra, ActorPath)
    local Context = AEventMgr.CreateUnitContext()
    Context.UnitType = "Drop"
    Context.UnitId = ItemId
    Context.Loc = Transform.Translation
    Context.Rotation = Transform.Rotation:ToRotator()
    Context.StrParams:Add("ReasonType", Reason)
    Context.IntParams:Add("ParentEid", ExtraInfo ~= nil and ExtraInfo.ParentEid or nil)
    Context.BoolParams:Add("bExtra", bExtra)
    Context.BoolParams:Add("ActorPath", ActorPath)
    return Context
end

function BP_EventMgr_C:CheckSpawnDrop(ItemId, Count)
    local ActorPath = nil
    local ItemInfo = DataMgr.Drop[ItemId]
    if not ItemInfo then return false, ActorPath, Count end
    local ActorPath = ItemInfo.UnitBPPath
    Count = math.min(ItemInfo.DropMaxNum or 0, Count)
    if not ActorPath then return false, ActorPath, Count end 
    return true, ActorPath, Count
end

--生成对话空物体
function BP_EventMgr_C:CreateTalkObject(Info)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then
        return
    end
    GameState:AddLoadingNpcId(Info.UnitId)
    local function LoadClassFinished(self, UnitBlueprint)       
        local Rotation = Info.Rotation or FRotator(0, 0, 0)
        local Transform = UE4.FTransform(Rotation:ToQuat(), Info.Loc)
        local Unit = self:GetWorld():SpawnActor(UnitBlueprint, Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
        if IsValid(Unit) == false then
            GWorld.logger.error("创建TalkObject失败!请检查蓝图路径    UnitId:   ".. Info.UnitId.."   UnitType:  "..Info.UnitType)
            return
        end
        Unit:Init(Info)
        GameState:AddNpcInfo_Lua(Unit)    
        GameState.NpcLoadingArray:Remove(Info.UnitId)
    end
    local Path = DataMgr.NPC[Info.UnitId].UnitBPPath
    UE4.UResourceLibrary.LoadClassAsync(self, Path, {self, LoadClassFinished})
end



function BP_EventMgr_C:RealSpawnDrop_Normal(ActorPath, Count, ItemId, Transform, Reason, ExtraInfo, bExtra)
    for j = 1, Count do
        local Info = self:BuildDropInfo_Normal(ItemId, Transform, Reason, ExtraInfo, bExtra, ActorPath)
        self:CreateUnitNew(Info, false)
    end
end

function BP_EventMgr_C:RealSpawnDrop_Region(ActorPath, Count, CreateIndex, ItemId, Transform, Reason, ExtraInfo, bExtra, DropRegionDatas)
    local function LoadClassFinished(self, UnitBlueprint)
        for j = 1, Count do
            CreateIndex = CreateIndex + 1
            local Info = self:BuildDropInfo_Region(ItemId, Transform, Reason, ExtraInfo, bExtra, CreateIndex, DropRegionDatas)
            self:ServerCreateDropNew(Info)
        end
    end
    UE4.UResourceLibrary.LoadClassAsync(self, ActorPath, {self, LoadClassFinished})
end

function BP_EventMgr_C:RealSpawnRewards_Normal(ItemId, Count, Transform, Reason, ExtraInfo, bExtra)
    local Res, ActorPath, UpdateCount = self:CheckSpawnDrop(ItemId, Count)
    if not Res then return end
    self:RealSpawnDrop_Normal(ActorPath, UpdateCount, ItemId, Transform, Reason, ExtraInfo, bExtra)
end

function BP_EventMgr_C:RealSpawnRewards_Region(ItemId, Count, Transform, Reason, ExtraInfo, bExtra, CreateIndex, DropRegionDatas)
    local Res, ActorPath, UpdateCount = self:CheckSpawnDrop(ItemId, Count)
    DebugPrint("ZJT_ CreateRes ", Res, ActorPath, UpdateCount)
    if not Res then return end
    self:RealSpawnDrop_Region(ActorPath, UpdateCount, CreateIndex, ItemId, Transform, Reason, ExtraInfo, bExtra, DropRegionDatas)
end

function BP_EventMgr_C:RealSpawnRewards_Normal_DungeonOServer(ItemId, Count, Transform, Reason, ExtraInfo, bExtra, UniqueIds)
    local Res, ActorPath, UpdateCount = self:CheckSpawnDrop(ItemId, Count)
    if not Res then return end
    for j = 1, UpdateCount do
        if UniqueIds[j] then
            local Info = self:BuildDropInfo_Normal(ItemId, Transform, Reason, ExtraInfo, bExtra, ActorPath)
            Info.StrParams:Add("ServerUniqueId", UniqueIds[j])
            self:CreateUnitNew(Info, false)
        else
            GWorld.logger.error("ServerUniqueId数量不足！",ItemId, Transform, Reason)
        end
    end
end

-- 挪到cpp了
-- function BP_EventMgr_C:FixLocation(Info)
--     if not Info.FixLocation then
--         return Info.Loc
--     end
--     return CommonUtils.GetFixLocation(self, Info.Loc, Info.FixLocationZ, Info.FixLocationStartZ, Info.FixLocationEndZ, Info.FixTraceChannel)
-- end

-- 挪到cpp了
-- function BP_EventMgr_C:FixEliteLocation(Info)
--     if not Info.FormationId then
--         return Info.Loc
--     end
--     return CommonUtils.GetEliteLocation(Info.FormationId, Info.DirectSource, Info.Loc)
-- end

-- 挪到cpp了
-- function BP_EventMgr_C:FixNavLocation(Info)
-- 	if not Info.FixNavLocation then
-- 		return Info.Loc
-- 	end
--     return URuntimeCommonFunctionLibrary.ProjectPointToNavigation(self, Info.Loc)
-- end

function BP_EventMgr_C:RandomPointInCircle(Source,MinRadius,MaxRadius,MinAngle,MaxAngle)
    local RandAngle = math.rad(math.random()*MaxAngle+MinAngle);
    local RandRadius = math.sqrt(math.rad(math.random()*(MaxRadius*MaxRadius-MinRadius*MinRadius)+MinRadius*MinRadius))
    local x = math.cos(RandAngle)*RandRadius
    local y = math.sin(RandAngle)*RandRadius
    local RandomLocationInRadius = Source+FVector(x,y,0)
    return RandomLocationInRadius
end

function BP_EventMgr_C:AddInitializeMonsterQueue(Info)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode or not GameMode:IsInRegion() then
        return
    end

    if not Info or not Info.WorldRegionEid  then
        if  Info.UnitType == "Monster" then
            GWorld.logger.error("在区域内的怪物没有初始化数据或WorldRegionEid!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        end
        return
    end
    -- TODO 这个回调可以改成所有AI初始化完成之后自己call回eventmgr清除数据，DestroySelf和DestroySelfReason也可以存放在另外的数据结构，不一定堆在Info里
    Info.AfterInitializeCallback_EventMgr = function (Monster,WorldRegionEid)
        local MonInfo = self.InitializeMonsterQueue[WorldRegionEid]
        if MonInfo and MonInfo.DestroySelf and MonInfo.DestroySelfReason and Monster then
            DebugPrint("AfterInitializeCallback_EventMgr",Monster.Eid,WorldRegionEid,Monster.RegionDataType)
            Monster:EMActorDestroy(MonInfo.DestroySelfReason)
        end
        MonInfo.IsDestroied = true
        self.InitializeMonsterQueue[WorldRegionEid] = nil
    end
    self.InitializeMonsterQueue[Info.WorldRegionEid] = Info
end

function BP_EventMgr_C:GetConstParamCheckDungeonMonId()
    return Const.CheckDungeonMonId
end

function BP_EventMgr_C:GetConstPreFrameRealInitNum()
    return Const.PreFrameRealInitNum
end

function BP_EventMgr_C:GetAvatarGender(SwitchPlayer)
    local AvatarGender = -1
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return AvatarGender
    end
    if SwitchPlayer == "Player" then
        AvatarGender = Avatar.Sex
    elseif SwitchPlayer == "EXPlayer" then
        AvatarGender = Avatar.WeitaSex
    end
    return AvatarGender
end

function BP_EventMgr_C:GetRegionSerializeUnitType()
    return Const.RegionSerializeUnitType
end

function BP_EventMgr_C:GetCreateType()
    return Const.CreateType
end

function BP_EventMgr_C:GetFixTraceChannel()
    return Const.FixTraceChannel
end

---- 查询或者删除异步加载中的魅影
function BP_EventMgr_C:FindPhantomAysncLoadingAndConsiderDestroy(RoleId,bWantToDestroy,DestroyReason)
    if not RoleId then
        return false
    end
    local FramingQueue = self.FramingCreateUintQueue["Phantom"]
    if FramingQueue then
        for Index,Info in ipairs(FramingQueue) do
            if Info.RoleId == RoleId then
                if bWantToDestroy then table.remove(FramingQueue, Index) end -- 第一种可能，他还在异步加载队列
                return true
            end
        end
    end

    for Key,Info in pairs(self.LoadingClassMonsterQueue) do
        if Info.RoleId == RoleId and Info.UnitType == "Phantom" then
            if bWantToDestroy then self.LoadingClassMonsterQueue[Key] = nil end -- 第二种可能，正在异步加载Class
            return true
        end
    end

    for Key,Info in pairs(self.InitializeMonsterQueue) do
        if Info.RoleId == RoleId and Info.UnitType == "Phantom" then
            if bWantToDestroy then
                Info.DestroySelf = true
                Info.DestroySelfReason = DestroyReason -- 第三种可能，ActorSpawn出来了但是还没初始化完成
            end 
            return true
        end
    end
    return false
end

function BP_EventMgr_C:CleanAllAsyncLoadingPhantom(DestroyReason)
    self.FramingCreateUintQueue["Phantom"] = {} 
    
    for Key,Info in pairs(self.LoadingClassMonsterQueue) do 
        if Info.UnitType == "Phantom" then
            self.LoadingClassMonsterQueue[Key] = nil
        end
    end

    for Key,Info in pairs(self.InitializeMonsterQueue) do
        if Info.UnitType == "Phantom" then
            Info.DestroySelf = true
            Info.DestroySelfReason = DestroyReason -- 第三种可能，ActorSpawn出来了但是还没初始化完成
        end
    end
end

function BP_EventMgr_C:GetConstMonDeathTaskNumPreFrame()
    return Const.MonDeathTaskNumPreFrame or 0
end

AssembleComponents(BP_EventMgr_C)
return BP_EventMgr_C
