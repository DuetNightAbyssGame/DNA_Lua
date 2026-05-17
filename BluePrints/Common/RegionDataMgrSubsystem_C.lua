require "Unlua"
require "Const"
local BattleUtils = require "Utils.BattleUtils"

local RegionDataMgrSubsystem_C = Class({
    "BluePrints.Common.RegionDataInitLogic",
    "BluePrints.Common.RegionDataGmLogic",
})

function RegionDataMgrSubsystem_C:Initialize_Lua()
    -- 客户端GM获取数据库数据的标记
    self.TestGMRegionDataType = Const.TestGMRegionType.NoneTest
    
    -- self.DataLibrary = require "BluePrints.Common.RegionDataLibrary"
    self.DataLibrary:RegionDataLibraryInit()
	-- self.DataPool = require "BluePrints.Common.RegionDataPool"
	self.DataPool:Initialize(self)
    self:InitDestroyReason()
end

function RegionDataMgrSubsystem_C:GetCurSubRegionId()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 0
    end
    return Avatar.CurrentRegionId
end

function RegionDataMgrSubsystem_C:NotifyAvatarRegionAllReady()
    -- local Avatar = GWorld:GetAvatar()
    -- if not Avatar then
    --     return
    -- end
    -- if Avatar.NotifyAvatarRegionAllReady then
    --     Avatar:NotifyAvatarRegionAllReady()
    -- end
end

function RegionDataMgrSubsystem_C:FillRegionData(Info)
	local Index = self:GetLuaDataIndex(Info.WorldRegionEid)
	self.DataPool:FillRegionData(Index, Info,self)
end

function RegionDataMgrSubsystem_C:InitRegionDataTable(LuaIndex, Info)
    self.DataPool:FillRegionDataNew(LuaIndex, Info)
end

function RegionDataMgrSubsystem_C:OnRegionDataAllocated_Lua(LuaTableIndex, WorldRegionEid)
	self.DataPool:InitRegionDataTable(LuaTableIndex, WorldRegionEid)
end

function RegionDataMgrSubsystem_C:MarkRegionDataDead(LuaTableIndex)
	return self.DataPool:MarkRegionDataDead(LuaTableIndex)
end
function RegionDataMgrSubsystem_C:RemoveQuestChainData(QuestChainId, DestroyReason)
    self.DataPool:RemoveQuestChainData(QuestChainId)
end

function RegionDataMgrSubsystem_C:RemoveDynamicQuestData(DynamicQuestId, DestroyReason)
    self.DataPool:RemoveDynamicQuestData(DynamicQuestId)
end

function RegionDataMgrSubsystem_C:RemoveSpecialQuestData(SpecialQuestId, DestroyReason)
    self.DataPool:RemoveSpecialQuestData(SpecialQuestId)
end

function RegionDataMgrSubsystem_C:GetStateIdByWorldRegionEid(LuaTableIndex)
	return self.DataPool:GetStateIdByWorldRegionEid(LuaTableIndex)
end

-----------------------------------------------------------------------------------------
----- 初始化Info中区域独有数据初始化
function RegionDataMgrSubsystem_C:SetActorRegionInfo(TargetActor, Info)
	local GameMode = UE4.UGameplayStatics.GetGameMode(TargetActor)
	if not GameMode then
		return
	end
	if not GameMode:IsInRegion() then
		return
	end
    if not TargetActor or not Info then 
		return
	end
    -- if not Info.ExtraRegionInfo then 
    --     Info.ExtraRegionInfo = {SpecialQuestId = Info.SpecialQuestId,DynQuestId = Info.DynQuestId} 
    -- end
    TargetActor.QuestChainId = Info.QuestChainId
	TargetActor.ExtraRegionInfo.SpecialQuestId = Info.ExtraRegionInfo and Info.ExtraRegionInfo.SpecialQuestId or Info.SpecialQuestId
	TargetActor.ExtraRegionInfo.DynQuestId = Info.ExtraRegionInfo and Info.ExtraRegionInfo.DynQuestId or Info.DynQuestId
    if Info.Creator then
        TargetActor.RarelyId = Info.RarelyId or Info.Creator.RarelyId
        TargetActor:SetAttr("Level", Info.Creator:GetUnitLevel())     -- 区域恢复静态点的时候，CreateUnit之前不会传入level，故初始化时补充
    else
        TargetActor.RarelyId = Info.RarelyId or 0
    end
end

function RegionDataMgrSubsystem_C:SetActorRegionInfo_SceneItemBase(TargetActor, Info)
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then return end
    if not TargetActor or not Info then return end
    local CppInfo = FActorRegionInfo()
    -- if not Info.ExtraRegionInfo then 
    --     Info.ExtraRegionInfo = {SpecialQuestId = Info.SpecialQuestId,DynQuestId = Info.DynQuestId} 
    -- end
    if not URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
        CppInfo.LevelName = Info.StrParams:Find("LevelName") or GameMode:GetActorLevelName(TargetActor)
        CppInfo.SubRegionId = Info.IntParams:Find("SubRegionId") or GameMode:GetRegionIdByLocation(TargetActor:k2_GetActorLocation())
        CppInfo.WorldRegionEid = Info.StrParams:Find("WorldRegionEid") or URuntimeCommonFunctionLibrary.GenerateGUID()
        CppInfo.RegionDataType = Info.IntParams:Find("RegionDataType")
    end
    CppInfo.QuestChainId = Info.IntParams:Find("QuestChainId")
    CppInfo.ExtraRegionInfo.SpecialQuestId = Info.ExtraRegionInfo and Info.ExtraRegionInfo.SpecialQuestId or Info.IntParams:Find("SpecialQuestId")
    CppInfo.ExtraRegionInfo.DynQuestId = Info.ExtraRegionInfo and Info.ExtraRegionInfo.DynQuestId or Info.IntParams:Find("DynQuestId")
    if IsValid(Info.Creator) then
        CppInfo.RarelyId = Info.IntParams:Find("RarelyId") or Info.Creator.RarelyId
    else
        CppInfo.RarelyId = Info.IntParams:Find("RarelyId") or 0
    end
    URegionDataMgrSubsystem.SetActorRegionInfo_SceneItemBase(TargetActor,CppInfo)
end

-- 初始化Info中区域数据有但不是独有数据初始化,不包括UnitId，UnitType，Eid(这几个要放preinit？)
function RegionDataMgrSubsystem_C:SetActorRegionCommonInfo(TargetActor, Info)
    TargetActor.BornPos = Info.VectorParams:Find("BornPos") or Info.Loc
    TargetActor.BornRot = Info.RotatorParams:Find("BornRot") or Info.Rotation
    if Info.Creator then
        local GameMode = UE4.UGameplayStatics.GetGameMode(TargetActor)
        local Creator = Info.Creator
        TargetActor.CreatorId = Info.IntParams:Find("CreatorId") or Creator.StaticCreatorId
        TargetActor.RandomCreatorId = Info.IntParams:Find("RandomCreatorId") or 0
        TargetActor.RandomRuleId = Info.IntParams:Find("RandomRuleId") or 0
        TargetActor.RandomTableId = Info.IntParams:Find("RandomTableId") or 0
        TargetActor.RandomIdxInRule = Info.IntParams:Find("RandomIdxInRule") or GameMode.RandomActorManager:GetCreatorRegionDataIdxInRule(Info.RandomRuleId, Info.RandomCreatorId)
    else
        TargetActor.CreatorId = Info.IntParams:Find("CreatorId") or 0
        TargetActor.RandomCreatorId = Info.IntParams:Find("RandomCreatorId") or 0
        TargetActor.RandomRuleId = Info.IntParams:Find("RandomRuleId") or 0
        TargetActor.RandomTableId = Info.IntParams:Find("RandomTableId") or 0
        TargetActor.RandomIdxInRule = Info.IntParams:Find("RandomIdxInRule") or 0
    end
end

function RegionDataMgrSubsystem_C:SetActorRegionCommonInfo_SceneItemBase(TargetActor, Info)
    local CppInfo=FActorRegionCommonInfo()
    CppInfo.BornPos = Info.VectorParams:Find("BornPos") or Info.Loc
    CppInfo.BornRot = Info.RotatorParams:Find("BornRot") or Info.Rotation
    if IsValid(Info.Creator) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(TargetActor)
        local Creator = Info.Creator
        CppInfo.CreatorId = Info.IntParams:Find("CreatorId") or Creator.StaticCreatorId
        CppInfo.RandomCreatorId = Info.IntParams:Find("RandomCreatorId") or 0
        CppInfo.RandomRuleId = Info.IntParams:Find("RandomRuleId") or 0
        CppInfo.RandomTableId = Info.IntParams:Find("RandomTableId") or 0
        CppInfo.RandomIdxInRule = Info.IntParams:Find("RandomIdxInRule") or GameMode.RandomActorManager:GetCreatorRegionDataIdxInRule(Info.RandomRuleId, Info.RandomCreatorId)
    else
        CppInfo.CreatorId = Info.CreatorId or 0
        CppInfo.RandomCreatorId = Info.RandomCreatorId or 0
        CppInfo.RandomRuleId = Info.RandomRuleId or 0
        CppInfo.RandomTableId = Info.RandomTableId or 0
        CppInfo.RandomIdxInRule = Info.RandomIdxInRule or 0
    end
    URegionDataMgrSubsystem.SetActorRegionCommonInfo_SceneItemBase(TargetActor,CppInfo)
end

-------------------------------------------操作RegionCacheData的接口-------------------------------------------

-- 从区域中获取Actor的UnitRegionData
function RegionDataMgrSubsystem_C:GetUnitRegionCacheDataByActor(TargetActor)
    local RegionDataType = TargetActor.RegionDataType
    local Avatar = GWorld:GetAvatar()
    local TypeRegionDatas = self.DataLibrary:GetRegionCacheDatasByIdType(RegionDataType)
    local UnitRegionData = self.DataLibrary:GetUnitRegionCacheData(TypeRegionDatas, TargetActor.SubRegionId, TargetActor.LevelName, TargetActor.WorldRegionEid)
    if not UnitRegionData then
        GWorld.logger.error("在RegionDatas[Type:".. tostring(RegionDataType) .. "]中找不到" .. tostring(UE4.UKismetSystemLibrary.GetDisplayName(TargetActor)) .. "的数据")
    end
    return UnitRegionData
end
--为了性能不能全部构建数据了，只更新State，以及后续的LevelName和SubRegionId，减少深拷贝
function RegionDataMgrSubsystem_C:UpdateUnitRegionCacheDataByActor(TargetActor)
    -- local GameMode = UGameplayStatics.GetGameMode(TargetActor)
    -- local NewUnitRegionData = self.DataLibrary:ConstructUnitRegionDataByUnit(TargetActor)
    return self.DataLibrary:UpdateUnitRegionCacheData(TargetActor)
end

-- 创建Actor之前调用
-- 1.构造一份简单的UnitRegionData
function RegionDataMgrSubsystem_C:PreActorCreated(Info)
	-- 1.构造一份简单的UnitRegionData, 提交SS和服务器
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		DebugPrint("Pre Actor Created Avatar is nil !!")
		PrintTable(Info)
		return
	end
	Avatar:GetWorldRegionEid(Info)
	local GameMode = UGameplayStatics.GetGameMode(self)
	Info.Eid = Info.Eid or GameMode:GetBattleEid()
	DebugPrint("PreActorCreated:", Info.WorldRegionEid, Info.Eid)

	local Creator = Info.Creator
	if not Info.RandomCreatorId or Info.RandomCreatorId == 0 then
		if not Creator and Info.CreatorId then
			local GameState = UGameplayStatics.GetGameState(self)
			Creator = GameState.StaticCreatorMap:FindRef(Info.CreatorId)
		end
	end
	if Creator and (not Info.RandomCreatorId or Info.RandomCreatorId == 0) then
		if not self:SSDataAlreadyExist(Info.LevelName or GameMode:GetActorLevelName(Info.Creator), Info.WorldRegionEid) then
			self:RegionAddDataByStaticCreator(Info.LevelName or GameMode:GetActorLevelName(Creator), Creator, Info.Eid, Info.WorldRegionEid)
		end
		self:MarkSSDataCreating(Info.LevelName or GameMode:GetActorLevelName(Creator), Info.WorldRegionEid)
	end
	
	if Info.RandomCreatorId and Info.RandomCreatorId ~= 0 then
		local GameMode = UGameplayStatics.GetGameMode(self)
		local Param, CreatorInfo, WCLevelName= GameMode:CreateSnapShotDataByRandomCreator(Info.RandomRuleId, Info.RandomCreatorId)
		if not self:SSDataAlreadyExist(Info.LevelName or WCLevelName, Info.WorldRegionEid) then
			self:RegionAddDataByRandomCreator(Info.LevelName or WCLevelName, Info.RandomRuleId, Param, Info.Eid, CreatorInfo.SpawnRandomTableId, CreatorInfo.SpawnIdxInRule, Info.WorldRegionEid)
		end
		self:MarkSSDataCreating(Info.LevelName or WCLevelName, Info.WorldRegionEid)
	end
end

-- Actor创建完成之后调用, 删除SSData中的数据, ClientCache和服务器数据如果有就更新一下
function RegionDataMgrSubsystem_C:PostActorCreated(Actor)
	-- local GameMode = UGameplayStatics.GetGameMode(self)
	-- local WCSubsystem = GameMode:GetWCSubSystem()
	-- local SSDatasExist = self.DataLibrary:RemoveRegionSSDatas(GameMode:GetActorLevelName(Actor), Actor.WorldRegionEid)
	-- if not SSDatasExist and not Actor.BpBorn and ( not Actor.UnitType or not Actor.UnitType == "Drop") then
	-- 	GWorld.logger.error("ERROR @fanyuxiao 生成了一个SSData里面没有的Actor" .. Actor:GetName().."_"..Actor.UnitId.."_"..Actor.WorldRegionEid)
	-- 	self.DataLibrary:RemoveRegionSSDatas(GameMode:GetActorLevelName(Actor), Actor.WorldRegionEid)
	-- end
	-- if not Actor:CheckUnitNeedStorage() then
    --     return
    -- end
	-- local UnitRegionData = self.DataLibrary:ConstructUnitRegionDataByUnit(Actor)
	-- self:UpdateUnitRegionCacheDataByActor(Actor)
	-- local ActorData = self:GetUnitRegionCacheDataByActor(Actor)
	-- self:UpdateRegionActorData(Actor, ActorData)
end

-- 异步过程中的Actor创建时调用, 删除SSData中的数据,  ClientCache和RegionCacheData如果有也一起删了
-- @fanyuxiao 没见到从异步队列里面删掉自己的操作, TODO
function RegionDataMgrSubsystem_C:OnActorCreationInterrupted(Info)

end

function RegionDataMgrSubsystem_C:AddRegionDataByActor(TargetActor, Info, AddRegionDataType, ActorPath)
    local Creator = Info.Creator
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then return end
    local WorldLoader = GameMode:GetLevelLoader()
    if not WorldLoader or not WorldLoader.IsWorldLoader then return end
    if Creator then
        -- TargetActor.RegionDataType = Info.RegionDataType or Creator.RegionDataType
        -- TargetActor.QuestChainId = Info.QuestChainId or Creator.QuestChainId
        -- TargetActor.RarelyId = Info.RarelyId or Creator.RarelyId
    else
        -- TargetActor.RegionDataType = Info.RegionDataType or TargetActor.RegionDataType
        -- TargetActor.QuestChainId = Info.QuestChainId or TargetActor.QuestChainId
        -- TargetActor.RarelyId = Info.RarelyId or TargetActor.RarelyId
    end

    if AddRegionDataType == CommonConst.AddRegionDataType.Random then
        -- local LevelName, LevelGameMode = GameMode:GetLevelGamemModeAndLevelName(TargetActor.SubRegionId )
        -- TargetActor.RegionDataType = GameMode.RandomActorManager:GetCreatorRegionDataType(TargetActor.RandomRuleId, TargetActor.RandomCreatorId)
        -- TargetActor.RandomIdxInRule = GameMode.RandomActorManager:GetCreatorRegionDataIdxInRule(TargetActor.RandomRuleId, TargetActor.RandomCreatorId)
    end
    self:RegionAddDataByUnit(TargetActor)
end


-------------------------------------------操作SSData的接口-------------------------------------------
-- 
-- Actor2SSData
function RegionDataMgrSubsystem_C:DeadRegionActorData(TargetActor, DestroyReason)
	-- 动态怪不进SSData--怪物自己去过滤
	-- if TargetActor.CreatorType == "MonsterSpawn" then
	-- 	return
	-- end
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then 
        if GameMode:IsInDungeon() then
            self:DeadDungeonActorData(TargetActor, DestroyReason, GameMode)
        end
        return 
    end
    -- local WorldLoader = GameMode:GetLevelLoader()
    -- if not WorldLoader or not WorldLoader.IsWorldLoader then 
    --     return 
    -- end
    -- local NewLevelName = GameMode:GetActorLevelName(TargetActor)--暂时没用，为了性能注了
    -- local NewSubRegionId = WorldLoader:GetRegionIdByLocation(TargetActor:K2_GetActorLocation())
    Avatar:RegionActorDead(TargetActor, DestroyReason, TargetActor.SubRegionId, TargetActor.LevelName)
	-- if TargetActor.IsPickupBase then
	-- 	TargetActor.WorldRegionEid = nil--掉落物启用了对象池，直接清掉
	-- end
end
--仿照AvatarRegionRpcMgr:RegionActorDead的流程过滤之后标记SSData的IsDead
-- function RegionDataMgrSubsystem_C:DestroyRegionSSData(WorldRegionEid, DestroyReason)
--     local Data = DataLibrary:GetUnitRegionCacheDataByWorldRegionEid(WorldRegionEid)
--     if not Data then
--         return
--     end
--     local DestoryReasonNotToSave = {EDestroyReason.LevelUnloadedSaveGame, EDestroyReason.LevelNotExsit,
--     EDestroyReason.HardBossClear, EDestroyReason.SepcialQuestStart, EDestroyReason.RegionExploreGroup}
--     local NoStorageRegionDataType = {ERegionDataType.RDT_QuestData, ERegionDataType.RDT_None, ERegionDataType.RDT_HardBossData, ERegionDataType.RDT_QuestCommonData}
--     if CommonUtils.HasValue(NoStorageRegionDataType, Data.RegionDataType) or 
--     CommonUtils.HasValue(DestoryReasonNotToSave, DestroyReason) then
--         return
--     end
--     self.DataLibrary:SetUnitIsDeadByWorldRegionEid(WorldRegionEid)
-- end

function RegionDataMgrSubsystem_C:DeadDungeonActorData(TargetActor, DestroyReason, GameMode)
    if DestroyReason == EDestroyReason.LevelUnloadedSaveGame or DestroyReason == EDestroyReason.LevelNotExsit then 
		DebugPrint("RegionLog:  WC导致Actor销毁,当前类型为："..TargetActor.RegionDataType.."  WorldRegionEid:"..TargetActor.WorldRegionEid)
		GameMode:GetRegionDataMgrSubSystem():AddSSData(TargetActor.WorldRegionEid)
		return
	end
    GameMode:GetRegionDataMgrSubSystem():OnActorDead(TargetActor)
end

function RegionDataMgrSubsystem_C:OnActorDead_Lua(LuaTableIndex)
	self.DataPool:RemoveData(LuaTableIndex)
end

function RegionDataMgrSubsystem_C:RegionActorCacheDataDeadByCreatorId(CreatorId)
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then 
        return nil
    end
    local BaseRegionDatas = self.DataLibrary:RegionActorCacheDataDeadByCreatorId(CreatorId)
    return BaseRegionDatas
end

function RegionDataMgrSubsystem_C:RegionActorCacheDataDeadByUnitLabel(UnitId, UnitType)
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then 
        return nil
    end
    local BaseRegionDatas = self.DataLibrary:RegionActorCacheDataDeadByUnitLabel(UnitId, UnitType)
    return BaseRegionDatas
end

function RegionDataMgrSubsystem_C:UpdateRegionActorData(TargetActor, RegionData, IsFromServer)
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then
        if GameMode:IsInDungeon() then
            local LuaTableIndex = TargetActor.RegionDataTableIndex or self:GetLuaDataIndex(TargetActor.WorldRegionEid)
            self:UpdateStateInfoByTable(LuaTableIndex, RegionData)
        end
        return
    end
	-- 随机点需要延迟到统一发送
	if (TargetActor.RandomRuleId and self.DataPool.RandomCreatorDatas[TargetActor.RandomRuleId]) or IsFromServer then
		return
	end
    -- local WorldLoader = GameMode:GetLevelLoader()
    -- if not WorldLoader or not WorldLoader.IsWorldLoader then
    --     return
    -- end
    -- local NewLevelName = GameMode:GetActorLevelName(TargetActor)
    -- local NewSubRegionId = WorldLoader:GetRegionIdByLocation(TargetActor:K2_GetActorLocation())

    -- 更新RegionDataPool里对应数据的State，并检查是否完全一致，如果是就不往服务端发RPC了
    local bNeedUpdateServer = true
    -- if Const.OptimizationRegionRPC and URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
        local LuaTableIndex = TargetActor.RegionDataTableIndex or self:GetLuaDataIndex(TargetActor.WorldRegionEid)
        bNeedUpdateServer = self:UpdateStateInfoByTable(LuaTableIndex, RegionData)
    -- end
    if bNeedUpdateServer then
        if not IsFromServer or TargetActor.RegionDataType == 8 then
            Avatar:RegionActorUpdate(TargetActor, TargetActor.SubRegionId, TargetActor.LevelName, RegionData)
        else
            local Ret, _ = self:AvatarUpdateUnitRegionData(TargetActor, TargetActor.SubRegionId, TargetActor.LevelName)
            if not self:CheckRegionErrorCode(Ret) then 
                DebugPrint("RegionLog:  Actor更新属性,当前类型为："..TargetActor.RegionDataType.."  WorldRegionEid:"..tostring(TargetActor.WorldRegionEid).."    更新数据失败，Ret："..Ret)
                return
            end
        end
    end
end

function RegionDataMgrSubsystem_C:RecoverRegionActorDataStateValue(WorldRegionEid)
    local ClientCacheState = self.DataLibrary:GetStateValue(WorldRegionEid)
    local LuaTableIndex = self:GetLuaDataIndex(WorldRegionEid)
    if ClientCacheState then
        self:UpdateStateInfoByTable(LuaTableIndex, ClientCacheState)
    else
        self.DataPool:ClearState(LuaTableIndex)
    end
end

function RegionDataMgrSubsystem_C:UpdatePetRegionActorData(TargetActor, PetState)
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then
        return
    end
    local WorldLoader = GameMode:GetLevelLoader()
    if not WorldLoader or not WorldLoader.IsWorldLoader then
        return
    end
    local NewLevelName = GameMode:GetActorLevelName(TargetActor)
    local NewSubRegionId = WorldLoader:GetRegionIdByLocation(TargetActor:K2_GetActorLocation())
   
end

function RegionDataMgrSubsystem_C:UpdateRegionDataStateCacheByCreatorId(CreatorId, RegionData)
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then
        return nil
    end
    local BaseRegionDatas = self.DataLibrary:UpdateRegionDataStateCacheByCreatorId(CreatorId, RegionData)
    return BaseRegionDatas
end

function RegionDataMgrSubsystem_C:IsCanTriggerRegionDataHandle()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local Avatar = GWorld:GetAvatar()
    return Avatar and GameMode:IsInRegion(), Avatar, GameMode
	-- if not Avatar then
    --     return
    -- end
    -- if not GameMode or not GameMode:IsInRegion() then return false, Avatar, GameMode end
    -- if not Avatar or not Avatar:CheckCurrentSubRegion() then return false, Avatar, GameMode end
    -- return true, Avatar, GameMode
end

function RegionDataMgrSubsystem_C:ResetRarelyStaticCreator(StaticCreatorId, PrivateEnable, EventName)
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then
        return
    end
    local WorldRegionEids = {}
    if not self:IsCretorIdControlByCacheNew(StaticCreatorId) then
        GWorld.logger.error("重刷静态点错误，静态点未激活! StaticCreatorId:".. StaticCreatorId)
        return
    end
    WorldRegionEids = self:GetControlWorldRegionEidByCreatorId(StaticCreatorId):ToTable()

    for WorldRegionEid, _ in pairs(WorldRegionEids) do
        local CacheData = self.DataLibrary:GetUnitRegionCacheDataByWorldRegionEid(WorldRegionEid)
        if CacheData and CacheData.RarelyId and CacheData.RarelyId > 0 and CacheData.RegionDataType == ERegionDataType.RDT_RarelyData then
            self.DataLibrary:RemoveRegionSSDatas(CacheData.LevelName, WorldRegionEid)
            self.DataLibrary:RemoveUnitRegionCacheData(WorldRegionEid)
        else
            if not CacheData then
                GWorld.logger.error("重刷静态点错误，静态点数据不存在 StaticCreatorId:".. StaticCreatorId.. " WorldRegionEid:".. WorldRegionEid)
            elseif not CacheData.RarelyId or CacheData.RarelyId <= 0 then
                GWorld.logger.error("重刷静态点错误，静态点数据RarelyId错误 StaticCreatorId:".. StaticCreatorId, " WorldRegionEid:".. WorldRegionEid)
            elseif CacheData.RegionDataType ~= ERegionDataType.RDT_RarelyData then
                GWorld.logger.error("重刷静态点错误，静态点数据RegionDataType错误 StaticCreatorId:".. StaticCreatorId, " WorldRegionEid:".. WorldRegionEid, " RegionDataType:".. CacheData.RegionDataType)
            end
        end
    end

    self:RemoveCretorIdContollerByCacheNew(StaticCreatorId)
    --print(_G.LogTag,"LXZ ResetRarelyStaticCreator")
    Avatar:ResetRarelyStaticCreator(StaticCreatorId, self.ActiveStaticCreatorAfterReset, StaticCreatorId, PrivateEnable, EventName)
end

function RegionDataMgrSubsystem_C:ResetRarelyStaticCreatorClient(WorldRegionEid)
    if WorldRegionEid == "None" then
        return
    end
    --与self.DataLibrary:GetUnitRegionCacheDataByWorldRegionEid()相同，但不需要空检查
    local CacheData = self.DataLibrary.WorldEid2RegionCacheData[WorldRegionEid]
    if CacheData and CacheData.RarelyId and CacheData.RarelyId > 0 and CacheData.RegionDataType == ERegionDataType.RDT_RarelyData then
        self.DataLibrary:RemoveRegionSSDatas(CacheData.LevelName, WorldRegionEid)
        self.DataLibrary:RemoveUnitRegionCacheData(WorldRegionEid)
    end
end

--ResetRarelyStaticCreator专用回调  @LXZ
function RegionDataMgrSubsystem_C:ActiveStaticCreatorAfterReset(StaticCreatorId, PrivateEnable, EventName)
    --print(_G.LogTag,"LXZ ActiveStaticCreatorAfterReset", StaticCreatorId, PrivateEnable, EventName)
    local Ids = TArray(0)
    Ids:Add(StaticCreatorId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    GameMode:TriggerActiveStaticCreator(Ids, EventName, PrivateEnable)
end

---------------------------------------------静态刷新点缓存，这个数据先放这里--------------------------------------------
function RegionDataMgrSubsystem_C:GetQuestChainData(QuestChainId)--DataPool恢复时不深拷贝，所以任务数据需要上传服务器时做深拷贝同时清理userdata
	local Table = self.DataPool.QuestChainId2Data[QuestChainId]
	if not Table then
		return {}
	end
    local CopyTable = CommonUtils.DeepCopy(Table)
	for _, RegionData in ipairs(CopyTable) do
        RegionData.Creator = nil
		for Key, Value in pairs(RegionData) do
            if type(Value) == "userdata" then
                RegionData[Key] = nil
            end
        end
	end
	return CopyTable
end

function RegionDataMgrSubsystem_C:DeleteQuestChainDataNotInClientCache(QuestChainId)
	local Table = self.DataPool.QuestChainId2Data[QuestChainId]
	if not Table then
		return
	end
    local WorldRegionEids = {}
	for _, RegionData in ipairs(Table) do
        WorldRegionEids[RegionData.WorldRegionEid] = true
		if not self:ClientCacheExist(RegionData.WorldRegionEid) then
			self:DestroyRegionEntity(RegionData.WorldRegionEid, EDestroyReason.QuestChainClear)
            DebugPrint("任务链:【"..tostring(QuestChainId).."】回退，删除了:"..tostring(RegionData.WorldRegionEid))
		end
	end

    local QuestRegionDatas = self.DataLibrary:GetRegionCacheDatasByIdType(ERegionDataType.RDT_QuestData)
	for _, RegionData in pairs(QuestRegionDatas) do
		for _, LevelData in pairs(RegionData) do
			for _, WorldRegionEid in pairs(CommonUtils.Keys(LevelData)) do
				local UnitRegionData = LevelData[WorldRegionEid]
				if UnitRegionData.QuestChainId == QuestChainId and not WorldRegionEids[WorldRegionEid] then
                    UnitRegionData.ExtraRegionInfo = UnitRegionData.ExtraRegionInfo or {}
					self:InitSSDataFromServer(UnitRegionData)
					DebugPrint("任务链:【"..tostring(QuestChainId).."】回退，恢复了:"..tostring(UnitRegionData.WorldRegionEid))
				end
			end
		end
	end
end

function RegionDataMgrSubsystem_C:DeleteExceptQuestChainDataNotInClientCache(QuestChainId)
    for ChainId,Table in pairs(self.DataPool.QuestChainId2Data) do
        if Table and ChainId ~= QuestChainId then
            for _, RegionData in ipairs(Table) do
                if not self:ClientCacheExist(RegionData.WorldRegionEid) then
                    self:DestroyRegionEntity(RegionData.WorldRegionEid, EDestroyReason.QuestChainClear)
                end
            end
        end
    end
end

--已有转C++版本
function RegionDataMgrSubsystem_C:AddCretorActiveCache(UnitData)
    if UnitData.CreatorId and (not UnitData.RandomCreatorId or UnitData.RandomCreatorId == 0) then
    	DebugPrint("RegionDataMgr: AddCretorActiveCache 新的接口恢复静态点controlcache ", UnitData.CreatorId, UnitData.RandomCreatorId)
		self:AddStaticCreatorId(UnitData.CreatorId, UnitData.WorldRegionEid, UnitData.SubRegionId)
	elseif UnitData.RandomCreatorId and UnitData.RandomCreatorId ~= 0 then
		DebugPrint("RegionDataMgr: AddCretorActiveCache 新的接口恢复随机点controlcache ", UnitData.CreatorId, UnitData.RandomCreatorId)
		self:AddRandomStaticCreatorId(UnitData.RandomRuleId, UnitData.RandomCreatorId, UnitData.WorldRegionEid, UnitData.SubRegionId)
	end
end
--标记：已有转C++版本
function RegionDataMgrSubsystem_C:AddStaticCreatorId(CreatorId, WorldRegionEid, SubRegionId)
	if not CreatorId or not WorldRegionEid then 
		return 
	end
	-- 判断是否有静态点数据，并且这个静态点刷了这个WorldRegionEid 的Actor
	if self:IsControlCreatorIdByWorldRegionEid(CreatorId, WorldRegionEid) then 
		return 
	end
	if not self.StaticIdControlCache[CreatorId] then
		self.StaticIdControlCache[CreatorId] = {}
	end
	self.StaticIdControlCache[CreatorId][WorldRegionEid] = SubRegionId
end
--标记：已有转C++版本
function RegionDataMgrSubsystem_C:RemoveCretorIdContollerByCache(CreatorId)
    if not self.StaticIdControlCache[CreatorId] then return false end
	self.StaticIdControlCache[CreatorId] = nil
	return true
end
--标记：已有转C++版本
function RegionDataMgrSubsystem_C:IsCretorIdControlByCache(CreatorId)
    return self.StaticIdControlCache[CreatorId] ~= nil
end
--标记：已有转C++版本
function RegionDataMgrSubsystem_C:IsControlCreatorIdByWorldRegionEid(CreatorId, WorldRegionEid)
    return self.StaticIdControlCache[CreatorId] and self.StaticIdControlCache[CreatorId][WorldRegionEid]
end

--标记：已有转C++版本
function RegionDataMgrSubsystem_C:AddRandomStaticCreatorId(RandomRuleId, RandomCreatorId, WorldRegionEid, SubRegionId)
	if not RandomRuleId or not RandomCreatorId or not WorldRegionEid then return end
	if self:IsRandomIdControlByCache(RandomRuleId, RandomCreatorId) and self:IsControlRandomIdByWorldRegionEid(RandomRuleId, RandomCreatorId, WorldRegionEid) then return end
	if not self.RandomIdControlCache[RandomRuleId] then
		self.RandomIdControlCache[RandomRuleId] = {}
	end
	if not self.RandomIdControlCache[RandomRuleId][RandomCreatorId] then
		self.RandomIdControlCache[RandomRuleId][RandomCreatorId] = {}
	end
	self.RandomIdControlCache[RandomRuleId][RandomCreatorId][WorldRegionEid] = SubRegionId
end

function RegionDataMgrSubsystem_C:UploadRandomCreatorData(RandomRuleId)
	self.DataPool:UploadRandomCreatorData(RandomRuleId)
end
--标记：已有转C++版本
function RegionDataMgrSubsystem_C:IsRandomIdControlByCache(RandomRuleId, RandomCreatorId)
    if not RandomRuleId or not RandomCreatorId then
		return false
	end
    if not self.RandomIdControlCache[RandomRuleId] then
		return false
	end

    -- RandomCreatorId是一个每次都会打乱的数组，会导致二次上线时拿到的Id跟存在服务端的不一样
	-- if not self.RandomIdControlCache[RandomRuleId][RandomCreatorId] then
	-- 	return false
	-- end
	return true
end
--标记：已有转C++版本
function RegionDataMgrSubsystem_C:IsControlRandomIdByWorldRegionEid(RandomRuleId, RandomCreatorId, WorldRegionEid)
	-- PrintTable({RandomIdControlCache = self.RandomIdControlCache }, 10)
	if self.RandomIdControlCache[RandomRuleId] and self.RandomIdControlCache[RandomRuleId][RandomCreatorId]
	 	and self.RandomIdControlCache[RandomRuleId][RandomCreatorId][WorldRegionEid] then
		return true
	end
	return false
end

---------------------------------------------传送点相关--------------------------------------------
-- 传送点都没激活时开启默认传送点
function RegionDataMgrSubsystem_C:ClearDeliverData()
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode then
		self:TryActiveDefaultDeliver()
	end
	self.CurRegionDeliverDatas = {}
	self.CurRegionDeliver = {}
    self.CurRegionDeliverNew:Clear()
	self.CurRegionDeliverDatasNew:Clear()
end

function RegionDataMgrSubsystem_C:IsCurrentRegionDeliver(CreatorId)
    if not self.CurRegionDeliverDatas then
        return false
    end
	return self.CurRegionDeliverDatas[CreatorId] ~= nil
end

function RegionDataMgrSubsystem_C:RegisterRegionDeliverMechanism(WorldRegionEid, CreatorId)
	if not self:IsCurrentRegionDeliver(CreatorId) then 
        return 
    end
	self.CurRegionDeliver[WorldRegionEid] = CreatorId
end

function RegionDataMgrSubsystem_C:ClientCacheExist(WorldRegionEid)
	return self.DataLibrary.WorldEid2RegionCacheData[WorldRegionEid] ~= nil
end
--1.3更新，移到服务器处理
function RegionDataMgrSubsystem_C:TryActiveDefaultDeliver()
    -- local Deliver = {}
    -- if  self.CurRegionDeliverNew:Num() == 0 then
    --     return
    -- end
    -- Deliver = self.CurRegionDeliverNew:ToTable()
    -- local Avatar = GWorld:GetAvatar()
    -- if not Avatar then
    --     return
    -- end

	-- local Res, Data
	-- for WorldRegionEid, CreatorId in pairs(Deliver) do
	-- 	local RegionBaseData = self.DataLibrary:GetUnitRegionCacheDataByWorldRegionEid(WorldRegionEid)
	-- 	if RegionBaseData then
    --         if RegionBaseData.State and RegionBaseData.State["OpenState"]then
    --             Res = true
    --             break
    --         end
    --         if self:CheckDeliverMechanismIsDefault(CreatorId) then
    --             Data = RegionBaseData
    --             break
    --         end
	-- 	end
	-- end
	-- if not Res and Data then
	-- 	local function callback(Ret)
	-- 		-- self.logger.debug("解锁默认传送点", Ret, Data.WorldRegionEid)
    --         Avatar:CombatItemTargetFinish(CommonConst.TargetTypeCreatorIdAndStateId, Data.CreatorId, 1, Data.CreatorId, 901001)
	-- 	end
    --     Avatar:UpdateRegionDataStateByCreatorId(Data.CreatorId, {OpenState = true, StateId = 901002}, callback)

	-- 	-- Avatar:CallServer("UpdateRegionActorData", callback, Data.WorldRegionEid,
	-- 	-- Data.RegionId, ERegionDataType.RDT_CommonData, Data.State, Data.LevelName)
	-- end
end
---------------------------------------------传送点相关--------------------------------------------


---------------------------------------------处理区域生成的数据 对外接口--------------------------------------------
function RegionDataMgrSubsystem_C:GetManualItemData(ManualItemId)
	return self.DataLibrary.ManualItemIdMap[ManualItemId]
end

function RegionDataMgrSubsystem_C:UpdateStateInfo(LuaTableIndex, DataName, DataValue)
	return self.DataPool:UpdateState(LuaTableIndex, DataName, DataValue)
end

function RegionDataMgrSubsystem_C:UpdateState(LuaTableIndex, StateId)
	local SthDiff, Info = self:UpdateStateInfo(LuaTableIndex, "StateId", StateId)
    if SthDiff and Info then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:RegionActorUpdate(Info, Info.SubRegionId, Info.LevelName, Info.State)
        end
    end
end

function RegionDataMgrSubsystem_C:UpdateStateInfoByTable(LuaTableIndex,NewState)
    return self.DataPool:UpdateStateByTable(LuaTableIndex,NewState)
end

-- 静态点生成的数据处理（未真正生成，只有数据）
function RegionDataMgrSubsystem_C:RegionAddDataByStaticCreator(LevelName, Creator, TempEid, WorldRegionEid)
	if URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
		return 
	end
    DebugPrint ("RegionDataMgr: RegionAddDataByStaticCreator", LevelName, Creator, TempEid, Creator.StaticCreatorId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local UnitRegionData = self.DataLibrary:ConstructUnitRegionDataByCreatorData(TempEid, LevelName, Creator, WorldRegionEid)
    -- 不管需不需要存储，都要进SS数据
    self.DataLibrary:AddRegionSSDatas(UnitRegionData)
    -- 如果需要存储，要添加到Client数据并且通知服务器
    if self:CheckUnitDataNeedStorage(UnitRegionData) then
        self:AddCretorActiveCache(UnitRegionData)
        self.DataLibrary:AddUnitRegionCacheData(UnitRegionData)
        -- 注意：同时操作RegionCacheData和上传服务器的接口。按顺序，先改客户端数据，再传服务器。
        Avatar:AvatarC2SAddRegionActorData(UnitRegionData)
    end
    -- Avatar:AddRegionBaseDataByCache(WorldRegionEid, UnitRegionData.RegionDataType, UnitRegionData)
end

-- 随机点生成的数据处理（未真正生成，只有数据）
function RegionDataMgrSubsystem_C:RegionAddDataByRandomCreator(LevelName, RuleId, Param, TmpEid, SpawnRandomTableId, SpawnIdxInRule, WorldRegionEid)
    -- @lxz
	if URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
		return
	end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
	if type(WorldRegionEid) == "number" then
		WorldRegionEid = nil
	end
    local UnitRegionData = self.DataLibrary:ConstructUnitRegionDataByRandomData(LevelName, RuleId, Param, TmpEid, SpawnRandomTableId, SpawnIdxInRule, WorldRegionEid)
    self.DataLibrary:AddRegionSSDatas(UnitRegionData)
    if self:CheckUnitDataNeedStorage(UnitRegionData) then
        self:AddCretorActiveCache(UnitRegionData)
        self.DataLibrary:AddUnitRegionCacheData(UnitRegionData)
        -- 注意：同时操作RegionCacheData和上传服务器的接口。按顺序，先改客户端数据，再传服务器。
        Avatar:AvatarC2SAddRegionActorData(UnitRegionData)
    end
    -- Avatar:AddRegionBaseDataByCache(WorldRegionEid, UnitRegionData.RegionDataType, UnitRegionData)
end


-- 静态点生成的数据处理（真正生成，有实体Actor）
function RegionDataMgrSubsystem_C:RegionAddDataByUnit(TargetActor)
	if URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
		return
	end
    DebugPrint("RegionDataMgr: RegionAddDataByUnit RegionDataType: "..tostring(TargetActor.RegionDataType).."  WorldRegionEid: "..TargetActor.WorldRegionEid)
	self:PostActorCreated(TargetActor)
    if TargetActor.RegionDataType == ERegionDataType.RDT_QuestData then
        return
    end
    if not TargetActor:CheckUnitNeedStorage() then
        return
    end
    local Avatar = GWorld:GetAvatar()
	
    if not Avatar then 
        return
    end

    -- 添加进区域数据
    local UnitRegionData = self.DataLibrary:ConstructUnitRegionDataByUnit(TargetActor)
    self.DataLibrary:AddUnitRegionCacheData(UnitRegionData)

    -- 添加静态点和随机点的控制
    self:AddCretorActiveCache(UnitRegionData)
    -- PrintTable(UnitRegionData)

    -- 注意：同时操作RegionCacheData和上传服务器的接口。按顺序，先改客户端数据，再传服务器。
    Avatar:AvatarC2SAddRegionActorData(UnitRegionData)
end

-- Actor请求生成到真正生成完成的时间段需要标记SSData正在创建, 在WC关卡加载回调时不要再用这个SSData生成Actor -- See OnWorldCompositionLevelLoaded_Lua
function RegionDataMgrSubsystem_C:MarkSSDataCreating(LevelName, WorldRegionEid)
	local SSData = self.DataLibrary:GetLevelRegionSSDatas(LevelName)
	if not SSData then
		return
	end
	local RegionBaseData = SSData[WorldRegionEid]
	if RegionBaseData then
		RegionBaseData.bIsCreating = true
	end
end

function RegionDataMgrSubsystem_C:SSDataAlreadyExist(LevelName, WorldRegionEid)
	local SSData = self.DataLibrary:GetLevelRegionSSDatas(LevelName)
	if not SSData then
		return false
	end
	local RegionBaseData = SSData[WorldRegionEid]
	if not RegionBaseData then
		return false
	end
	return true
end
---------------------------------------------处理区域生成的数据 End--------------------------------------------

---------------------------------------------WC恢复数据接口 Begin--------------------------------------------

-- 
-- 卸载由Actor.OnLevelUnloaded调用，不用OnWorldCompositionLevelUnloaded_Lua。省去mgr遍历哪些怪物需要卸载的步骤。
-- 
--因为用CreateUnitContext初始化了，所以不需要深拷贝了
function RegionDataMgrSubsystem_C:RecoverRegionDataByIndex(LuaTableIndex)
	local Info = self.DataPool:GetRegionEntityDataNoCopy(LuaTableIndex)
	-- if not Info.UnitId or not Info.UnitType then
	-- 	return
	-- end
    -- if not self.DataLibrary:CheckCanCreateWhileSpecialQuest(Info) then
        -- QA需求 不打印
        -- DebugPrint(" Reject Create Because SpecialQuest",Info.WorldRegionEid,Info.RegionDataType)
        -- return
    -- end
	-- local DeepCopiedInfo = CommonUtils.DeepCopy(Info)
	-- DeepCopiedInfo.Loc = FVector(DeepCopiedInfo.Loc.X, DeepCopiedInfo.Loc.Y, DeepCopiedInfo.Loc.Z)
	-- DeepCopiedInfo.BornLocation = DeepCopiedInfo.Loc
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local Context = AEventMgr.CreateUnitContext()
    self:FillCreateUnitContext(Context, Info)
    if Info.Type then
        if Info.Type == 1 then
            self:FillStaticCreatorCreateUnitContext(Context, Info)
        elseif Info.Type == 2 then
            self:FillRandomCreatorCreateUnitContext(Context, Info)
        elseif Info.Type == 3 then
            self:FillCommonCreateUnitContext(Context, Info)
        end
    else
        -- GWorld.logger.error("RecoverRegionDataByIndex Type Nil ! UnitId:", Info.UnitId ,"UnitType:", Info.UnitTYpe,
        -- "WorldRegionEid:", Info.WorldRegionEid)
        self:ShowRegionError("RecoverRegionDataByIndex Type Nil !\nUnitId:"..Info.UnitId .." \nUnitType:".. Info.UnitTYpe..
        "WorldRegionEid:".. Info.WorldRegionEid, Info)
    end
    GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
end

function RegionDataMgrSubsystem_C:CheckCanCreateWhileSpecialQuest(LuaTableIndex)
    local Info = self.DataPool:GetRegionEntityDataNoCopy(LuaTableIndex)
	if not Info.UnitId or not Info.UnitType then
		return false
	end
    return self.DataLibrary:CheckCanCreateWhileSpecialQuest(Info)
end

--Info里不知道会有啥，总之先按服务器数据加一遍然后按类型再加一遍，再查漏补缺
function RegionDataMgrSubsystem_C:FillCreateUnitContext(Context, Info)
    Context.UnitId = Info.UnitId
    Context.UnitType = Info.UnitType
    Context.Loc = FVector(Info.Loc.X, Info.Loc.Y, Info.Loc.Z) 
    Context.BornPos = Context.Loc 
    Context.Rotation = Info.Rotation 
    Context.Creator = Info.Creator
    if Info.WorldRegionEid then
        Context.NameParams:Add("WorldRegionEid", Info.WorldRegionEid)
    end
    if Info.SubRegionId then
        Context.IntParams:Add("SubRegionId", Info.SubRegionId)
    end
    if Info.LevelName then
        Context.StrParams:Add("LevelName", Info.LevelName)
    end
    if Info.RegionDataType then
        Context.IntParams:Add("RegionDataType", Info.RegionDataType)
    end
    if Info.BornLocation then
        Context.VectorParams:Add("BornLocation", Info.BornLocation)
    end
    if Info.State then
        Context:AddLuaTable("State", Info.State)
    end
    if Info.RarelyId then
        Context.IntParams:Add("RarelyId", Info.RarelyId)
    end
    if Info.IsUnlimited then
        Context.BoolParams:Add("IsFullRegionStore", Info.IsUnlimited)
    end
    if Info.QuestChainId then
        Context.IntParams:Add("QuestChainId", Info.QuestChainId)
    end
    if Info.QuestId then
        Context.IntParams:Add("QuestId", Info.QuestId)
    end
    if Info.IsBonus then
        Context.BoolParams:Add("IsBonus", Info.IsBonus)
    end
    if Info.IsDead then
        Context.BoolParams:Add("IsDead", Info.IsDead)
    end
    if Info.ServerUniqueId then
        Context.StrParams:Add("ServerUniqueId", Info.ServerUniqueId)
    end
end

function RegionDataMgrSubsystem_C:FillStaticCreatorCreateUnitContext(Context, Info)
    if Info.CreatorId then
        Context.IntParams:Add("CreatorId", Info.CreatorId)
    end
    if Info.Creator then
        Info.Creator:FillCreateUnitContext(Context, nil)
    else
        -- GWorld.logger.error("RecoverRegionDataByIndex For Creator But Creator Is Nil!!!")
        -- PrintTable(Info,5)
        self:ShowRegionError("RecoverRegionDataByIndex For Creator But Creator Is Nil!!!\nCreatorId: " .. Info.CreatorId, Info)
    end
end

function RegionDataMgrSubsystem_C:FillRandomCreatorCreateUnitContext(Context, Info)
    if Info.RandomTableId then
        Context.IntParams:Add("RandomTableId", Info.RandomTableId)
    end
    if Info.RandomIdxInRule then
        Context.IntParams:Add("RandomIdxInRule", Info.RandomIdxInRule)
    end
    if Info.RandomCreatorId then
        Context.IntParams:Add("RandomCreatorId", Info.RandomCreatorId)
    end
    if Info.RandomRuleId then
        Context.IntParams:Add("RandomRuleId", Info.RandomRuleId)
    end
    if Info.RandomRuleId and Info.RandomTableId then
        local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
        local RandomCreator = GameMode.RandomActorManager:GetCreator(Info.RandomRuleId, Info.LevelName, Info.RandomIdxInRule)
        if RandomCreator then
            RandomCreator:FillRandomCreateUnitContext(Context, nil)
        else
            -- GWorld.logger.error("RecoverRegionDataByIndex For RandomCreator But RandomCreator Is Nil!!!")
            -- PrintTable(Info,5)
            self:ShowRegionError(string.format("RecoverRegionDataByIndex For RandomCreator But RandomCreator Is Nil!!! \nRandomRuleId:%d \nRandomTableId:%d \nLevelName:%s \nRandomIdxInRule:%d",
            Info.RandomRuleId, Info.RandomTableId, Info.LevelName, Info.RandomIdxInRule), Info)
        end
    end
end

function RegionDataMgrSubsystem_C:FillCommonCreateUnitContext(Context, Info)
    if Info.ManualItemId then
        Context.IntParams:Add("ManualItemId", Info.ManualItemId)
    end
end

function RegionDataMgrSubsystem_C:OnWorldCompositionLevelLoaded_Lua(ProxyInfo)
    local Avatar = GWorld:GetAvatar()
	if not Avatar then 
		return
	end
    if Avatar:IsInHardBoss() then
        return
    end
	DebugPrint("RegionDataMgr: OnWorldCompositionLevelLoaded_Lua", ProxyInfo.LevelId)
    -- 真正恢复生成的接口
    ---上线存储恢复先给WC复制过去，再走wc恢复-----------------------------
	if URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
		local LevelName = ProxyInfo.LevelId
        local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
        local WorldLoader = GameMode:GetLevelLoader()
        local ParentLevelIds = ProxyInfo:GetAllParentLevelIds()
        for i, ParentLevelId in pairs(ParentLevelIds) do
    		local SubRegionId = WorldLoader:GetRegionIdByLevelId(ParentLevelId)
    		self:TryGameModeFailEvent(SubRegionId, LevelName)
        end
	else
		local LevelName = ProxyInfo.LevelId
		local ParentLevelId = ProxyInfo.ParentLevelId
		local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		local WorldLoader = GameMode:GetLevelLoader()
        local ParentLevelIds = ProxyInfo.GetAllParentLevelIds()
        for i, ParentLevelId in pairs(ParentLevelIds) do
            local SubRegionId = WorldLoader:GetRegionIdByLevelId(ParentLevelId)
            DebugPrint("RegionDataMgr: OnWorldCompositionLevelLoaded_Lua", LevelName, ParentLevelId, SubRegionId)
            if Avatar:CheckCurrentSubRegion(SubRegionId) then
                local TmpSSData = self.DataLibrary:GetLevelRegionSSDatas(LevelName)
                if TmpSSData ~= nil then
                    for WorldRegionEid, UnitRegionData in pairs(TmpSSData) do
                        DebugPrint("RegionDataMgr: OnWorldCompositionLevelLoaded_Lua 遍历RegionSSDatas", WorldRegionEid, LevelName)
                        if not UnitRegionData.bIsCreating and self.DataLibrary:CheckCanCreateWhileSpecialQuest(UnitRegionData) then
                            self:WCRecoverActor(UnitRegionData)
                        end
                    end
                end
        
                -- @fanyuxiao 反序列化之后, SSData的删除交由异步生成的Actor去做
                -- self.DataLibrary:RemoveLevelRegionSSData(LevelName)
                -- if ProxyInfo:GetType() == EWorldCompositionLevelType.MainArt then
                    self:TryGameModeFailEvent(SubRegionId, LevelName)
                -- end
            end
        end
	end
end

-- function RegionDataMgrSubsystem_C:WCRecoverActor(RegionBaseData) 
--     local Avatar = GWorld:GetAvatar()
-- 	if not Avatar then
--         return
--     end
--     local WorldRegionEid = RegionBaseData.WorldRegionEid
--     local RegionDataType = RegionBaseData.RegionDataType
--     DebugPrint("RegionDataMgr:  WCRecoverActor",  WorldRegionEid, RegionBaseData.RegionDataType, RegionBaseData.LevelName)
--     if RegionBaseData.IsDead then
--         DebugPrint("RegionDataMgr: Warning  存储数据标记死亡 不许重新创建 该信息包括为： ", RegionBaseData.ManualItemId, WorldRegionEid, RegionBaseData.SubRegionId, RegionDataType, 
--         RegionBaseData.QuestId, RegionBaseData.CreatorId, RegionBaseData.UnitType, RegionBaseData.UnitId)
--         return
--     end

--     local SpawnActorInfo = {}
--     local DebugString = ""
--     if RegionBaseData.RandomCreatorId and RegionBaseData.RandomCreatorId ~= 0 then
--         -- 随机刷新点创建
--         SpawnActorInfo = self:RandomCreatorRecoverSpawnInfo(RegionBaseData)
--         DebugString = "RandomCreator" .. RegionBaseData.RandomCreatorId
--     elseif RegionBaseData.CreatorId and RegionBaseData.CreatorId > 0 then
--         -- 静态刷新点创建
--         SpawnActorInfo = self:StaticCreatorRecoverSpawnInfo(RegionBaseData)
--         DebugString = "StaticCreator" .. RegionBaseData.CreatorId
--     else
--         -- 其他
--         SpawnActorInfo = self:CommonSpwanRecoverSpawnInfo(RegionBaseData)
--         DebugString = "Common"
--     end
--     if IsEmptyTable(SpawnActorInfo) then
--         GWorld.logger.errorlog("WC恢复对象数据构建失败, 来源 " .. DebugString)
-- 		SpawnActorInfo = self:RandomCreatorRecoverSpawnInfo(RegionBaseData)
--         return 
--     end

--     DebugPrint("RegionDataMgr: WCRecoverActor  " .. DebugString)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
--     GameMode.EMGameState.EventMgr:CreateUnit(SpawnActorInfo)
--     DebugPrint("RegionDataMgr: WCRecoverActor 大世界存储恢复 成功更新信息 ", RegionDataType, SpawnActorInfo.QuestChainId ,SpawnActorInfo.LevelName,  SpawnActorInfo.Loc, RegionBaseData.CreatorId, WorldRegionEid, RegionBaseData.RarelyId)
-- end

function RegionDataMgrSubsystem_C:CommonSpwanRecoverSpawnInfo(RegionBaseData)
    DebugPrint("RegionDataMgr: WCRecoverActor 既非静态点又非随机点", RegionBaseData.WorldRegionEid)
    local Info = {}

    Info.UnitId = RegionBaseData.UnitId
    Info.UnitType = RegionBaseData.UnitType
    Info.RegionDataType = RegionBaseData.RegionDataType

    -- SpawnActorInfo.ActorPath = RegionBaseData.ActorPath
    Info.LevelName = RegionBaseData.LevelName
    Info.QuestId = RegionBaseData.QuestId
    Info.QuestChainId = RegionBaseData.QuestChainId
    Info.SubRegionId = RegionBaseData.SubRegionId
    Info.WorldRegionEid = RegionBaseData.WorldRegionEid
    Info.State = RegionBaseData.State
    -- 
    Info.RarelyId = RegionBaseData.RarelyId
    -- eid 有些有，有些没有，只有单局内恢复有
    Info.Eid = RegionBaseData.Eid

    local LastLocation = RegionBaseData.Location or RegionBaseData.BornLocation
    Info.Loc = FVector(LastLocation.X, LastLocation.Y, LastLocation.Z)
    Info.BornPos = FVector(RegionBaseData.BornLocation.X, RegionBaseData.BornLocation.Y, RegionBaseData.BornLocation.Z)
    -- 这里优化一下，存yaw就可以
    Info.Rotation = FRotator(RegionBaseData.Rotation.pitch, RegionBaseData.Rotation.yaw, RegionBaseData.Rotation.roll)
    Info.ExtraRegionInfo = {
        SpecialQuestId = RegionBaseData.ExtraRegionInfo.SpecialQuestId,
        DynQuestId = RegionBaseData.ExtraRegionInfo.DynQuestId
    }
    
    return Info
end

function RegionDataMgrSubsystem_C:RandomCreatorRecoverSpawnInfo(RegionBaseData)
    local Avatar = GWorld:GetAvatar()
	if not Avatar then
        return
    end
    DebugPrint("RegionDataMgr: WCRecoverActor 随机点恢复 ", RegionBaseData.WorldRegionEid, RegionBaseData.RandomRuleId, RegionBaseData.RandomCreatorId)

    if not RegionBaseData.RandomRuleId then
		DebugPrint("RandomCreatorRecoverSpawnInfo, No RandomRuleId")
        return {}
    end

    local RandomInfo = DataMgr.RandomCreator[RegionBaseData.RandomRuleId].RandomInfos[RegionBaseData.RandomTableId]
    if not RandomInfo then 
		DebugPrint("RandomCreatorRecoverSpawnInfo, No RandomInfo")
        return {}
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local LevelName, LevelGameMode = GameMode:GetLevelGamemModeAndLevelName(RegionBaseData.SubRegionId)
    local Info = {}
    RegionBaseData.RandomCreatorId = LevelGameMode.LevelGameMode.RandomActorManager:GetParamActorId(RegionBaseData.RandomRuleId, LevelName, RegionBaseData.RandomIdxInRule)
    Info.RandomCreatorId = RegionBaseData.RandomCreatorId
    Info.RandomRuleId = RegionBaseData.RandomRuleId
    Info.RandomTableId = RegionBaseData.RandomTableId
    Info.RandomIdxInRule = RegionBaseData.RandomIdxInRule
    Info.RegionDataType = RegionBaseData.RegionDataType
    ---------------------
    Info.UnitType = DataMgr.RandomCreator[RegionBaseData.RandomRuleId].UnitType
    Info.UnitId = RandomInfo.UnitId
    Info.Level = (RandomInfo.UnitLevel or 0 ) + GameMode:GetFixedGamemodeLevel()
    Info.Loc = GameMode.RandomActorManager:GetCreatorRegionDataLoc(Info.RandomRuleId, RegionBaseData.RandomCreatorId)
    Info.Rotation = GameMode.RandomActorManager:GetCreatorRegionDataRot(Info.RandomRuleId, RegionBaseData.RandomCreatorId)
    Info.BornPos = FVector(RegionBaseData.BornLocation.X, RegionBaseData.BornLocation.Y, RegionBaseData.BornLocation.Z)
    ---------------------
    Info.Creator = GameMode.RandomActorManager:GetCreator(Info.RandomRuleId, LevelName, Info.RandomIdxInRule)

    Info.LevelName = RegionBaseData.LevelName
    Info.QuestId = RegionBaseData.QuestId
    Info.QuestChainId = RegionBaseData.QuestChainId
    Info.SubRegionId = RegionBaseData.SubRegionId
    Info.WorldRegionEid = RegionBaseData.WorldRegionEid
    Info.State = RegionBaseData.State
    Info.RarelyId = RegionBaseData.RarelyId
    Info.Eid = RegionBaseData.Eid
    return Info
end

function RegionDataMgrSubsystem_C:StaticCreatorRecoverSpawnInfo(RegionBaseData)
    DebugPrint("RegionDataMgr: WCRecoverActor 静态点恢复", RegionBaseData.WorldRegionEid)
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local Creator = GameMode.EMGameState.StaticCreatorMap:Find(RegionBaseData.CreatorId)
    if not IsValid(Creator) then 
        DebugPrint("RegionDataMgr: Error WCRecoverActor 找不到静态点！", RegionBaseData.CreatorId, RegionBaseData.RandomCreatorId)
        return {}
    end

    local Info = {}

    Info.Creator = Creator
    Info.UnitId = Creator.UnitId
    Info.UnitType = Creator.UnitType
    Info.Level = Creator:GetUnitLevel()
    Info.LevelName = RegionBaseData.LevelName
    Info.RegionDataType = RegionBaseData.RegionDataType

    Info.SubRegionId = RegionBaseData.SubRegionId
    Info.WorldRegionEid = RegionBaseData.WorldRegionEid
    Info.State = RegionBaseData.State
    Info.RarelyId = RegionBaseData.RarelyId
    -- todo, Eid这里需要整理
    Info.Eid = RegionBaseData.Eid
    -- Quest
    Info.QuestId = RegionBaseData.QuestId
    Info.QuestChainId = RegionBaseData.QuestChainId
    -- Transform
    local LastLocation = RegionBaseData.BornLocation or RegionBaseData.Location

    ----- @zjt 用于GM解锁传送点做的特殊处理 后续会迭代 原因在主城解锁传送点无法获取和构建传送点位置
    if Info.UnitId == CommonConst.DeliveryAnchorMechanismUnitId and Info.Creator and not LastLocation then
        Info.Loc = Creator:k2_GetActorLocation()
        Info.BornPos = Creator:k2_GetActorLocation()
        Info.Rotation = Creator:K2_GetActorRotation()
    else
        Info.Loc = FVector(LastLocation.X, LastLocation.Y, LastLocation.Z)
        Info.BornPos = FVector(RegionBaseData.BornLocation.X, RegionBaseData.BornLocation.Y, RegionBaseData.BornLocation.Z)
        Info.Rotation = FRotator(RegionBaseData.Rotation.pitch, RegionBaseData.Rotation.yaw, RegionBaseData.Rotation.roll)
    end
    -- 这里优化一下，存yaw就可以
    Info.ExtraRegionInfo = {
        SpecialQuestId = RegionBaseData.ExtraRegionInfo.SpecialQuestId,
        DynQuestId = RegionBaseData.ExtraRegionInfo.DynQuestId
    }

    return Info
end

---------------------------------------------WC恢复数据接口 End--------------------------------------------

---------------------------------------------特殊任务结束时恢复数据 Begin-----------------------------------
function RegionDataMgrSubsystem_C:OnSpecialQuestFinish()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)

    if GameMode then
        -- GameMode:TriggerLoadedEvent()
		GameMode:AllowAllFutureCreate()
        return
    end

    -- local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    -- local LevelName = GameMode:GetActorLevelName(Player)
    -- -- local WCSubSystem =  GameMode:GetWCSubSystem()
    -- -- if  WCSubSystem then
    -- --     LevelName = GameMode:GetWCSubSystem():GetObjectLevelId(Player)
    -- -- end

    -- if not LevelName then
    --     GWorld.logger.errorlog("RegionDataMgrSubsystem_C:OnSpecialQuestFinish 特殊任务结束恢复数据异常 ")
    --     return
    -- end

    -- local TmpSSData = self.DataLibrary:GetLevelRegionSSDatas(LevelName)
    -- if TmpSSData~= nil then
    --     for WorldRegionEid, UnitRegionData in pairs(TmpSSData) do
    --         GWorld.logger.debug("RegionDataMgr: OnSpecialQuestFinish 遍历RegionSSDatas", WorldRegionEid, LevelName)
    --         if not UnitRegionData.bIsCreating and self.DataLibrary:CheckCanCreateWhileSpecialQuest(UnitRegionData) then
    --             self:WCRecoverActor(UnitRegionData)
    --         end
    --     end
    -- end
end
---------------------------------------------特殊任务结束时恢复数据 End-------------------------------------


--------------------------------------分割线，一下均为内部逻辑，如果只是看区域的整体，都在上面-----------------------
--------------------------------------分割线，一下均为内部逻辑，如果只是看区域的整体，都在上面-----------------------
--------------------------------------分割线，一下均为内部逻辑，如果只是看区域的整体，都在上面-----------------------
--------------------------------------分割线，一下均为内部逻辑，如果只是看区域的整体，都在上面-----------------------
--------------------------------------分割线，一下均为内部逻辑，如果只是看区域的整体，都在上面-----------------------

--------------------------------------------工具函数 Begin--------------------------------------------
function RegionDataMgrSubsystem_C:CheckUnitDataNeedStorage(UnitRegionData)
    local RegionDataType = UnitRegionData.RegionDataType
    if RegionDataType and RegionDataType > 0 and RegionDataType ~= ERegionDataType.RDT_HardBossData and RegionDataType ~= ERegionDataType.RDT_QuestData then
        return true
    end
    return false
end

function RegionDataMgrSubsystem_C:GetActorDataInfo(UnitId, UnitType)
    local Result = {}
    Result.UnitId = UnitId
    Result.UnitType = UnitType
    return Result
end

function RegionDataMgrSubsystem_C:GetNpcData(NpcId)
	if self.DataLibrary.SerializedNpcs[NpcId] then
		return true
	end
	return false
end

function RegionDataMgrSubsystem_C:CheckIsDataInitFromServer(WorldRegionEid)
    if not Const.OptimizationRegionRPC then return false end -- return false，调用的地方会往服务端发Add的RPC
    local Res = self.DataLibrary and self.DataLibrary.WorldEid2RegionCacheData and self.DataLibrary.WorldEid2RegionCacheData[WorldRegionEid] ~= nil
    DebugPrint("RegionDataMgrSubsystem_C:CheckIsDataInitFromServer ",WorldRegionEid,Res)
    return Res
end

function RegionDataMgrSubsystem_C:HasRegionSSDDataByKey(LevelName, WorldRegionEid)
    return self.DataLibrary:GetRegionSSDataByKey(LevelName, WorldRegionEid) ~= nil
end

--------------------------------------------工具函数 End--------------------------------------------



--------------------------------------------GameMode事件函数 Begin-----------------------------------
function RegionDataMgrSubsystem_C:TryGameModeFailEvent(SubRegionId, LevelName)
    local Avatar = GWorld:GetAvatar()
	if not Avatar then
        return
    end
    for Type, Datas in pairs(self.DataLibrary.RegionCacheDatas) do
        if IsEmptyTable(Datas) or IsEmptyTable(Datas[SubRegionId]) then
            self:ExeSubGameModeFailEvent(Avatar, SubRegionId, Type, LevelName)
        end
    end
    -- local Avatar = GWorld:GetAvatar()
    -- local RegionId = Avatar:GetSubRegionId2RegionId(SubRegionId)
    -- RegionId = tostring(RegionId)
    -- if not Avatar.CommonRegionDatas[tostring(SubRegionId)] then
    --     self:ExeSubGameModeFailEvent(Avatar, SubRegionId, ERegionDataType.RDT_CommonData, LevelName)
    -- end

    -- if not Avatar.QuestRegionDatas[tostring(SubRegionId)] then
    --     self:ExeSubGameModeFailEvent(Avatar, SubRegionId, ERegionDataType.RDT_QuestData, LevelName)
    -- end

    -- if not Avatar.RarelyRegionDatas[tostring(SubRegionId)] then
    --     self:ExeSubGameModeFailEvent(Avatar, SubRegionId, ERegionDataType.RDT_RarelyData, LevelName)
    -- end
    -- if not Avatar.CommonDailyDatas[tostring(SubRegionId)] then
    --     self:ExeSubGameModeFailEvent(Avatar, SubRegionId, ERegionDataType.RDT_CommonDailyData, LevelName)
    -- end
    -- if not Avatar.CommonTriduumDatas[tostring(SubRegionId)] then
    --     self:ExeSubGameModeFailEvent(Avatar, SubRegionId, ERegionDataType.RDT_CommonTriduumData, LevelName)
    -- end
    -- if not Avatar.CommonWeeklyDatas[tostring(SubRegionId)] then
    --     self:ExeSubGameModeFailEvent(Avatar, SubRegionId, ERegionDataType.RDT_CommonWeeklyData, LevelName)
    -- end
end

function RegionDataMgrSubsystem_C:ExeSubGameModeFailEvent(Avatar, SubRegionId, RegionDataType, SubLevelName)
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if not DataMgr.SubRegion[SubRegionId] then 
        SubRegionId = Avatar.CurrentRegionId
    end
    local WorldLoader = GameMode:GetLevelLoader()
    local LevelName = WorldLoader:GetLevelIdByRegionId(SubRegionId)
    if not LevelName then
        return
    end

    if self.LoadSubRegionCache[RegionDataType] ~= nil and self.LoadSubRegionCache[RegionDataType][LevelName] ~= nil then
        return
    end
    self.LoadSubRegionCache[RegionDataType] = self.LoadSubRegionCache[RegionDataType] or {}
    local SubGameMode = GameMode.SubGameModeInfo:FindRef(LevelName)
    if CommonConst.RegionDataType[RegionDataType] ~= nil then
        local CacheName = "OnReload"..CommonConst.RegionDataType[RegionDataType].."Fail"
        if SubGameMode and SubGameMode[CacheName] then
            SubGameMode[CacheName](SubGameMode)
        end
        self.LoadSubRegionCache[RegionDataType][LevelName] = SubRegionId
    end
end

--------------------------------------------GameMode事件函数 End-----------------------------------

function RegionDataMgrSubsystem_C:CheckUnitIsDeadByWorldRegionEid(WorldRegionEid)
    return self.DataLibrary:CheckUnitIsDeadByWorldRegionEid(WorldRegionEid)
end

function RegionDataMgrSubsystem_C:InitDestroyReason()
    self.DestoryReasonNotToSave:Clear()
    local DestoryReasons = {EDestroyReason.LevelUnloadedSaveGame, EDestroyReason.LevelNotExsit,
    EDestroyReason.HardBossClear, EDestroyReason.SepcialQuestStart, EDestroyReason.RegionExploreGroup}
    for _,DestoryReason in pairs (DestoryReasons) do
        self.DestoryReasonNotToSave:Add(DestoryReason)
    end
end

function RegionDataMgrSubsystem_C:UpdatePhantomRegionData(Actor)
    local Result, Avatar, GameMode = self:IsCanTriggerRegionDataHandle()
    if not Result then
        return
    end
    local WorldLoader = GameMode:GetLevelLoader()
    local SubRegionId = -1
    if WorldLoader then
        SubRegionId = WorldLoader:GetRegionIdByLocation(Actor:k2_GetActorLocation())
    end
    if SubRegionId == -1 then
        return
    end
    Actor.SubRegionId = SubRegionId
    self.DataPool:UpdateLevelNameAndSubRegionId(self:GetLuaDataIndex(Actor.WorldRegionEid), Actor)
    local Data = self:UpdateUnitRegionCacheDataByActor(Actor)
    self.DataLibrary.LogHelper:OnClientCacheUpdated(Actor.WorldRegionEid, Actor.Eid, Actor.LevelName)
    if Data then
        Avatar:UpdatePhantomRegionActorData(Data, Data.State or {})
    end
end

function RegionDataMgrSubsystem_C:GetAllRegionDataByUnitType(UnitType)
    return self.DataPool:GetAllRegionDataByUnitType(UnitType)
end

function RegionDataMgrSubsystem_C:AddRegionDataAddCallback(UnitType, Obj, Func)
	if not self.RegionDataAddCallback[UnitType] then
		self.RegionDataAddCallback[UnitType] = {}
	end
	self.RegionDataAddCallback[UnitType][Obj] = Func
    DebugPrint('AddRegionDataAddCallback')
    PrintTable(self.RegionDataAddCallback[UnitType])
end

function RegionDataMgrSubsystem_C:RemoveRegionDataAddCallback(UnitType, Obj)
	if self.RegionDataAddCallback[UnitType] and self.RegionDataAddCallback[UnitType][Obj] then
		self.RegionDataAddCallback[UnitType][Obj] = nil
	end
end

function RegionDataMgrSubsystem_C:ExeRegionDataAddCallback(RegionData)
    if RegionData.UnitType then
        local Pair = self.RegionDataAddCallback[RegionData.UnitType]
        if Pair then
            PrintTable(Pair,2)
            for Obj, Func in pairs(Pair) do
                if Obj and Func then
                    Func(Obj, RegionData)
                end
            end
        end
    end
end

function RegionDataMgrSubsystem_C:AddRegionDataUpdateCallback(UnitType, Obj, Func)
	if not self.RegionDataUpdateCallback[UnitType] then
		self.RegionDataUpdateCallback[UnitType] = {}
	end
	self.RegionDataUpdateCallback[UnitType][Obj] = Func
end

function RegionDataMgrSubsystem_C:RemoveRegionDataUpdateCallback(UnitType, Obj)
	if self.RegionDataUpdateCallback[UnitType] and self.RegionDataUpdateCallback[UnitType][Obj] then
		self.RegionDataUpdateCallback[UnitType][Obj] = nil
	end
end

function RegionDataMgrSubsystem_C:ExeRegionDataUpdateCallback(RegionData)
    if RegionData.UnitType then
        local Pair = self.RegionDataUpdateCallback[RegionData.UnitType]
        if Pair then
            for Obj, Func in pairs(Pair) do
                if Obj and Func then
                    Func(Obj, RegionData)
                end
            end
        end
    end
end

function RegionDataMgrSubsystem_C:SetRegionSnapshotInfo(SnapShotInfo, Eid)
    local Index, Result = self:TryGetLuaDataIndexByEid(Eid)
    if Result then
        local Info = self.DataPool:GetRegionEntityDataNoCopy(Index)
        if Info then
            SnapShotInfo.SnapShotId = Eid
            SnapShotInfo.UnitId = Info.UnitId
            SnapShotInfo.UnitType = Info.UnitType
            SnapShotInfo.Loc = Info.Loc
        end
    end
end

function RegionDataMgrSubsystem_C:CheckRecoverRegionDataByIndex(Index)
    local Info = self.DataPool:GetRegionEntityDataNoCopy(Index)
	if not Info.UnitId or not Info.UnitType then
		return
	end
    if not self.CheckRecoverRegionDataByIndexCount then
        self.CheckRecoverRegionDataByIndexCount = {}
    end
    if not self.CheckRecoverRegionDataByIndexCount[Index] then
        self.CheckRecoverRegionDataByIndexCount[Index] = 0
    elseif self.CheckRecoverRegionDataByIndexCount[Index] >= 10 then
        return
    end
    if Info.UnitType == 'None' then
        DebugPrint('CheckRecoverRegionDataByIndex UnitType None!!!')
        PrintTable(Info,3)
    end
    if not self.DataLibrary:CheckCanCreateWhileSpecialQuest(Info) then
        return
    end
    if Info.RegionDataType == ERegionDataType.RDT_RarelyData then
        if Info.UnitType == "Drop" and not Info.CreatorId then
            return
        end
        if not Info.RarelyId then
            self:ShowRegionError("CheckRecoverRegionDataByIndex Error: RarelyData But No RarelyId !\nCreatorId:"..
            (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType, Info)
            self.CheckRecoverRegionDataByIndexCount[Index] = self.CheckRecoverRegionDataByIndexCount[Index] + 1
        else
            local GameState = UGameplayStatics.GetGameState(self)
            local ExploreGroup = GameState.ExploreGroupMap:Find(Info.RarelyId)
            if ExploreGroup then
                if ExploreGroup.Status == EExploreGroupStatus.EGS_Complete then--登录恢复的时候探索组状态还没恢复，所以只能黑名单检查下是否已完成
                    -- self:ShowRegionError("CheckRecoverRegionDataByIndex Error: ExploreGroup Status Error!\nStatus:".. ExploreGroup.Status.. 
                    -- "\nRarelyId:".. Info.RarelyId.. "\nCreatorId:".. (Info.CreatorId and Info.CreatorId or "nil"), Info)
                    -- self.CheckRecoverRegionDataByIndexCount[Index] = self.CheckRecoverRegionDataByIndexCount[Index] + 1--存在探索组完成后保留的机关，先屏蔽
                end
            end
        end
    elseif Info.RegionDataType == ERegionDataType.RDT_QuestData then
        if Info.ExtraRegionInfo then
            local Avatar = GWorld:GetAvatar()
            if Info.ExtraRegionInfo.SpecialQuestId and Info.ExtraRegionInfo.SpecialQuestId > 0 then
                if Avatar and (not Avatar.InSpecialQuest or Info.ExtraRegionInfo.SpecialQuestId ~= Avatar.SpecialQuestId) then
                    local SpecialQuestConfig = DataMgr.SpecialQuestConfig[Info.ExtraRegionInfo.SpecialQuestId]
                    if SpecialQuestConfig and SpecialQuestConfig.TriggerBoxStaticCreatorId == Info.CreatorId then
                        return
                    end
                    self:ShowRegionError("CheckRecoverRegionDataByIndex Error: QuestData Is In SpecialQuest But Avatar Is Not In SpecialQuest!\nCreatorId:"..
                    (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType.. "\nSpecialQuestId:".. Info.ExtraRegionInfo.SpecialQuestId, Info)
                    self.CheckRecoverRegionDataByIndexCount[Index] = self.CheckRecoverRegionDataByIndexCount[Index] + 1
                end
                return
            elseif Info.ExtraRegionInfo.DynQuestId and Info.ExtraRegionInfo.DynQuestId > 0 then
                local DynamicQuest = Avatar.DynamicQuests[Info.ExtraRegionInfo.DynQuestId]
                if not DynamicQuest then
                    self:ShowRegionError("CheckRecoverRegionDataByIndex Error: QuestData Is In DynamicQuest But Avatar Has No DynamicQuest!\nCreatorId:"..
                    (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType.. "\nDynQuestId:".. Info.ExtraRegionInfo.DynQuestId, Info)
                    self.CheckRecoverRegionDataByIndexCount[Index] = self.CheckRecoverRegionDataByIndexCount[Index] + 1
                elseif not DynamicQuest:IsDoing() then
                    self:ShowRegionError("CheckRecoverRegionDataByIndex Error: QuestData Is In DynamicQuest But DynamicQuest Is Not Doing!\nCreatorId:"..
                    (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType.. "\nDynQuestId:".. Info.ExtraRegionInfo.DynQuestId, Info)
                    self.CheckRecoverRegionDataByIndexCount[Index] = self.CheckRecoverRegionDataByIndexCount[Index] + 1
                end
                return
            end
        end
        if not Info.QuestChainId then
            self:ShowRegionError("CheckRecoverRegionDataByIndex Error: QuestData But No QuestChainId !\nCreatorId:"..
            (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType, Info)
            self.CheckRecoverRegionDataByIndexCount[Index] = self.CheckRecoverRegionDataByIndexCount[Index] + 1
        else
            local Avatar = GWorld:GetAvatar()
            if Avatar and not Avatar:IsQuestChainDoing(Info.QuestChainId) and not Avatar:IsQuestChainUnlock(Info.QuestChainId)then
                self:ShowRegionError("CheckRecoverRegionDataByIndex Error: QuestData But QuestChain Is Not Doing !\nCreatorId:"..
                (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType.. "\nQuestChainId:".. Info.QuestChainId, Info)
                self.CheckRecoverRegionDataByIndexCount[Index] = self.CheckRecoverRegionDataByIndexCount[Index] + 1
            end
        end
    end
end

function RegionDataMgrSubsystem_C:CheckOnRegionEntityCreated(Index)
    local Info = self.DataPool:GetRegionEntityDataNoCopy(Index)
    if Info.RegionDataType == ERegionDataType.RDT_RarelyData then
        if Info.UnitType == "Drop" and not Info.CreatorId then
            return
        end
        if not Info.RarelyId then
            self:ShowRegionError("CheckOnRegionEntityCreated Error: RarelyData But No RarelyId !\nCreatorId:"..
            (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType, Info)
        else
            local GameState = UGameplayStatics.GetGameState(self)
            local ExploreGroup = GameState.ExploreGroupMap:Find(Info.RarelyId)
            if ExploreGroup then
                if ExploreGroup.Status == EExploreGroupStatus.EGS_Complete or ExploreGroup.Status == EExploreGroupStatus.EGS_Deactive then
                    -- self:ShowRegionError("CheckOnRegionEntityCreated Error: ExploreGroup Status Error!\nStatus:".. ExploreGroup.Status.. 
                    -- "\nRarelyId:".. Info.RarelyId.. "\nCreatorId:".. (Info.CreatorId and Info.CreatorId or "nil"), Info)--存在探索组完成后保留的机关，先屏蔽
                end
            end
        end
    elseif Info.RegionDataType == ERegionDataType.RDT_QuestData then
        if Info.ExtraRegionInfo then
            local Avatar = GWorld:GetAvatar()
            if Info.ExtraRegionInfo.SpecialQuestId and Info.ExtraRegionInfo.SpecialQuestId > 0 then
                if Avatar and (not Avatar.InSpecialQuest or Info.ExtraRegionInfo.SpecialQuestId ~= Avatar.SpecialQuestId) then
                    local SpecialQuestConfig = DataMgr.SpecialQuestConfig[Info.ExtraRegionInfo.SpecialQuestId]
                    if SpecialQuestConfig and SpecialQuestConfig.TriggerBoxStaticCreatorId == Info.CreatorId then
                        return
                    end
                    self:ShowRegionError("CheckOnRegionEntityCreated Error: QuestData Is In SpecialQuest But Avatar Is Not In SpecialQuest!\nCreatorId:"..
                    (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType.. "\nSpecialQuestId:".. Info.ExtraRegionInfo.SpecialQuestId, Info)
                end
                return
            elseif Info.ExtraRegionInfo.DynQuestId and Info.ExtraRegionInfo.DynQuestId > 0 then
                local DynamicQuest = Avatar.DynamicQuests[Info.ExtraRegionInfo.DynQuestId]
                if not DynamicQuest then
                    self:ShowRegionError("CheckOnRegionEntityCreated Error: QuestData Is In DynamicQuest But Avatar Has No DynamicQuest!\nCreatorId:"..
                    (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType.. "\nDynQuestId:".. Info.ExtraRegionInfo.DynQuestId, Info)
                elseif not DynamicQuest:IsDoing() then
                    self:ShowRegionError("CheckOnRegionEntityCreated Error: QuestData Is In DynamicQuest But DynamicQuest Is Not Doing!\nCreatorId:"..
                    (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType.. "\nDynQuestId:".. Info.ExtraRegionInfo.DynQuestId, Info)
                end
                return
            end
        end
        if not Info.QuestChainId then
            self:ShowRegionError("CheckOnRegionEntityCreated Error: QuestData But No QuestChainId !\nCreatorId:"..
            (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType, Info)
        else
            local Avatar = GWorld:GetAvatar()
            if Avatar and not Avatar:IsQuestChainDoing(Info.QuestChainId) and not Avatar:IsQuestChainUnlock(Info.QuestChainId)then
                self:ShowRegionError("CheckOnRegionEntityCreated Error: QuestData But QuestChain Is Not Doing !\nCreatorId:"..
                (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType.. "\nQuestChainId:".. Info.QuestChainId, Info)
            end
            if self.DataPool:CheckQuestDataExist(Info.QuestChainId, Info) then
                self:ShowRegionError("CheckOnRegionEntityCreated Error: QuestData Create Repeated !\nCreatorId:"..
                (Info.CreatorId and Info.CreatorId or "nil").. "\nUnitId:".. Info.UnitId.. "\nUnitType:".. Info.UnitType.. "\nQuestChainId:".. Info.QuestChainId, Info)
            end
        end
    end
end

function RegionDataMgrSubsystem_C:ShowRegionError(String, Info)
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local WCSubSystem = GameMode:GetWCSubSystem()
    if WCSubSystem then
        WCSubSystem:ShowRegionError_Lua(String)
    end
    if Info then
        PrintTable(Info, 2)
    end
end

function RegionDataMgrSubsystem_C:ReportRemoveLocalDataOnce(LuaTableIndex)
    local Data = self.DataPool:GetRegionEntityData(LuaTableIndex)
    local Avatar = GWorld:GetAvatar()
    if Avatar and Data then
        Avatar:ReportRemoveLocalDataOnce(Data)
    end
end

return RegionDataMgrSubsystem_C