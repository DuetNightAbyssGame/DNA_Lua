require "UnLua"
require "Const"

local Library = Class()

function Library:RegionDataLibraryInit()
    -- self.FullRegionStoreDatas，全区域存储的数据
    -- 格式：[WorldRegionEid] = RegionBaseData
    self.FullRegionStoreDatas = {} 

    -- self.RegionSSDatas，客户端实时序列化数据
    -- 格式：[LevelName][WorldRegionEid] = RegionBaseData
    self.RegionSSDatas = {} 

	-- {FString : WorldRegionEid -> Table : RegionBaseData}
	self.WorldRegionEid2SSData = {}

    -- self.RegionCacheDatas
    -- 格式：[SubRegionId][LevelName][WorldRegionEid] = RegionBaseData 
    -- todo，当前是按照服务器分了几个ERegionDataType的Table，存在几个库中WorldRegionEid无法保证唯一性的问题
    -- 待修改服务器数据库的存储格式。
    self:ClearRegionCacheDatas()
	self.LogHelper = require "BluePrints.Common.RegionLogHelper"
    -- 特殊任务期间需要保留的区域数据类型
    self.SpecialQuestHoldRegionDataType = {}

    -- 特殊任务的任务链
    self.CurSpecialQuestChainId = nil

    -- 当前正在执行的特殊任务id
    self.CurSpecialQuestid = 0
	-- todo @fanyuxiao 整理出来这部分数据, 不止给NPC用
	self.SerializedNpcs = {}
	self.ManualItemIdMap = {}
end

function Library:ClearRegionCacheDatas()
    self.RegionCacheDatas = {
        [ERegionDataType.RDT_CommonData]        = {},  -- 永久数据
        [ERegionDataType.RDT_QuestData]         = {},  -- 任务数据
        [ERegionDataType.RDT_RarelyData]        = {},  -- 探索组数据
        [ERegionDataType.RDT_CommonDailyData]   = {},  -- 每日数据
        [ERegionDataType.RDT_CommonTriduumData] = {},  -- 三日数据
        [ERegionDataType.RDT_CommonWeeklyData]  = {},  -- 周数据
        [ERegionDataType.RDT_QuestCommonData]   = {},  -- 跨任务数据
    }

    -- [WorldRegionEid]=[RegionCacheData]，额外维护的索引只读
    self.WorldEid2RegionCacheData = {}
end

function Library:ClearSSData()
	self.RegionSSDatas = {}
    self.WorldRegionEid2SSData = {}
	self.LogHelper:Clear()
    self:OnSpecialQuestEnd()
end

function Library:GetFullRegionStoreDatas()
    return self.FullRegionStoreDatas
end

function Library:GetRegionSSDatas()
    return self.RegionSSDatas
end

function Library:GetLevelRegionSSDatas(LevelName)
    return self.RegionSSDatas[LevelName]
end

function Library:GetRegionCacheDatasByIdType(Type)
    return self.RegionCacheDatas[Type]
end


---------------------------------------------RegionCacheDatas 客户端缓存数据，和服务器保持一致--------------------------------------------

-- 添加ClientCache数据
function Library:AddUnitRegionCacheData(UnitRegionData)
    local RegionDataType = UnitRegionData.RegionDataType
    local SubRegionId = UnitRegionData.SubRegionId
    local LevelName = UnitRegionData.LevelName
    local WorldRegionEid = UnitRegionData.WorldRegionEid

    self:SetUnitRegionCacheData(RegionDataType, SubRegionId, LevelName, WorldRegionEid, UnitRegionData)

    -- 全区域存储的数据，手动添加到FullRegionStoreDatas
    if UnitRegionData.IsUnlimited then
        self.FullRegionStoreDatas[WorldRegionEid] = UnitRegionData
    end

    -- todo. 传送点功能，临时放这里，需要迭代，@wuzhijun--统一放到FillRegionData了@smh
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	-- GameMode:GetRegionDataMgrSubSystem():RegisterRegionDeliverMechanism(UnitRegionData.WorldRegionEid, UnitRegionData.CreatorId)

    self.LogHelper:OnClientCacheCreated(UnitRegionData.WorldRegionEid, UnitRegionData.Eid, UnitRegionData.LevelName)
    if self.LogHelper:IsRegionLogEnabled() then
        self:_CheckCacheDataDuplication(RegionDataType, SubRegionId, LevelName, WorldRegionEid)
    end
end

function Library:_CheckCacheDataDuplication(RegionDataType, SubRegionId, LevelName, WorldRegionEid)
    -- 检查是否同一份数据存在两个不同的table里
    for _RegionDataType, _SubRegionDatas in pairs(self.RegionCacheDatas) do
        for _SubRegionId, _LevelRegionDatas in pairs(_SubRegionDatas) do   
           for _LevelName, _RegionDatas in pairs(_LevelRegionDatas) do
                for _WorldRegionEid, _ in pairs(_RegionDatas) do
                    if _WorldRegionEid == WorldRegionEid and
                    (
                        RegionDataType ~= _RegionDataType
                        or SubRegionId ~= _SubRegionId
                        or LevelName ~= _LevelName
                    )
                    then
                        GWorld.logger.error("同一份区域数据错误存在两个数据集里：WorldRegionEid："..WorldRegionEid 
                        .. "  Type：" .. RegionDataType .. "  RegionId：".. SubRegionId .. "  ".. LevelName)
                        PrintTable(_RegionDatas)
                    end
                end
            end 
        end
    end
end

-- 移除ClientCache数据
function Library:RemoveUnitRegionCacheData(WorldRegionEid)
    local UnitRegionData = self:GetUnitRegionCacheDataByWorldRegionEid(WorldRegionEid)
    if not UnitRegionData then
        return false
    end

    -- 全区域存储的数据，手动移除
    if UnitRegionData.IsUnlimited then
        self.FullRegionStoreDatas[WorldRegionEid] = nil
    end

    local RegionDataType = UnitRegionData.RegionDataType
    local SubRegionId = UnitRegionData.SubRegionId
    local LevelName = UnitRegionData.LevelName
    local WorldRegionEid = UnitRegionData.WorldRegionEid
    self:SetUnitRegionCacheData(RegionDataType, SubRegionId, LevelName, WorldRegionEid, nil)

    self.LogHelper:OnClientCacheDeleted(UnitRegionData.WorldRegionEid, UnitRegionData.Eid, UnitRegionData.LevelName)
    return true
end

-- 更新ClientCache数据--只更新State，以及后续的LevelName和SubRegionId，减少深拷贝
function Library:UpdateUnitRegionCacheData(TargetActor)
    local WorldRegionEid = TargetActor.WorldRegionEid
    local OldUnitRegionData = self.WorldEid2RegionCacheData[WorldRegionEid]
    if not OldUnitRegionData then
        return nil
    end
    -- local RegionDataType = UnitRegionData.RegionDataType
    -- local SubRegionId = UnitRegionData.SubRegionId
    -- local LevelName = UnitRegionData.LevelName

    -- 全区域存储的数据，手动更新
    if OldUnitRegionData.IsUnlimited then--只更新State
        self:SetStateValue(self.FullRegionStoreDatas[WorldRegionEid], TargetActor.RegionData)
    end

    if TargetActor.LevelName ~= OldUnitRegionData.LevelName or TargetActor.SubRegionId ~= OldUnitRegionData.SubRegionId then
        DebugPrint('LevelName and SubRegionId Update:',TargetActor.UnitId, TargetActor.UnitType, WorldRegionEid, TargetActor.SubRegionId, TargetActor.LevelName, OldUnitRegionData.LevelName, OldUnitRegionData.SubRegionId)
        self:SetUnitRegionCacheData(OldUnitRegionData.RegionDataType, OldUnitRegionData.SubRegionId, OldUnitRegionData.LevelName, OldUnitRegionData.WorldRegionEid, nil)
        OldUnitRegionData.LevelName = TargetActor.LevelName
        OldUnitRegionData.SubRegionId = TargetActor.SubRegionId
        self:SetUnitRegionCacheData(TargetActor.RegionDataType, TargetActor.SubRegionId, TargetActor.LevelName, WorldRegionEid, OldUnitRegionData)
        OldUnitRegionData = self:GetUnitRegionCacheDataByWorldRegionEid(WorldRegionEid)
    end
    self:SetStateValue(OldUnitRegionData, TargetActor.RegionData)
    self.LogHelper:OnClientCacheUpdated(OldUnitRegionData.WorldRegionEid, OldUnitRegionData.Eid, OldUnitRegionData.LevelName)
    return OldUnitRegionData
end

function Library:RegionActorCacheDataDeadByCreatorId(CreatorId)
    local RegionDatas = self:GetClientCacheDataByCreatorId(CreatorId)
    for _,RegionData in pairs(RegionDatas) do
        RegionData.IsDead = true
        local SSData = self:GetRegionSSDataByKey(RegionData.LevelName, RegionData.WorldRegionEid)
        if SSData then
            SSData.IsDead = true
        end
        if self.FullRegionStoreDatas[RegionData.WorldRegionEid] then
            self.FullRegionStoreDatas[RegionData.WorldRegionEid].IsDead = true
        end
    end
    return RegionDatas
end

function Library:RegionActorCacheDataDeadByUnitLabel(UnitId, UnitType)
    local RegionDatas = self:GetClientCacheDataByUnitLabel(UnitId, UnitType)
    for _,RegionData in pairs(RegionDatas) do
        RegionData.IsDead = true
        local SSData = self:GetRegionSSDataByKey(RegionData.LevelName, RegionData.WorldRegionEid)
        if SSData then
            SSData.IsDead = true
        end
        if self.FullRegionStoreDatas[RegionData.WorldRegionEid] then
            self.FullRegionStoreDatas[RegionData.WorldRegionEid].IsDead = true
        end
    end
    return RegionDatas
end

function Library:CheckUnitIsDeadByWorldRegionEid(WorldRegionEid)
    local Data = self:GetUnitRegionCacheDataByWorldRegionEid(WorldRegionEid)
    if not Data then
        return false
    end
    return Data.IsDead
end

function Library:SetUnitIsDeadByWorldRegionEid(WorldRegionEid)
    local Data = self:GetUnitRegionCacheDataByWorldRegionEid(WorldRegionEid)
    if not Data or (Data and Data.IsDead) then
        return false
    end
    Data.IsDead = true
    return true
end

function Library:UpdateRegionDataStateCacheByCreatorId(CreatorId, StateData)
    local RegionDatas = self:GetClientCacheDataByCreatorId(CreatorId)
    for _,RegionData in pairs(RegionDatas) do
        self:SetStateValue(RegionData,StateData)
        self:UpdateRegionSSDatasState(RegionData.LevelName, RegionData.WorldRegionEid, StateData)
        if self.FullRegionStoreDatas[RegionData.WorldRegionEid] then
            self:SetStateValue(self.FullRegionStoreDatas[RegionData.WorldRegionEid],StateData)
        end
    end
    return RegionDatas
end

function Library:GetClientCacheDataByCreatorId(CreatorId)
    local RegionDatas={}
    for _,TypeData in pairs(self.RegionCacheDatas) do
        for _,SubRegionData in pairs(TypeData) do
            for _,LevelNameData in pairs(SubRegionData) do
                for _,RegionData in pairs(LevelNameData) do
                    if RegionData.CreatorId == CreatorId then
                        table.insert(RegionDatas,RegionData)
                    end
                end
            end
        end
    end
    return RegionDatas
end

function Library:GetClientCacheDataByUnitLabel(UnitId, UnitType)
    local RegionDatas={}
    for _,TypeData in pairs(self.RegionCacheDatas) do
        for _,SubRegionData in pairs(TypeData) do
            for _,LevelNameData in pairs(SubRegionData) do
                for _,RegionData in pairs(LevelNameData) do
                    if RegionData.UnitId == UnitId and RegionData.UnitType == UnitType then
                        table.insert(RegionDatas,RegionData)
                    end
                end
            end
        end
    end
    return RegionDatas
end

function Library:SetUnitRegionCacheData(RegionDataType, SubRegionId, LevelName, WorldRegionEid, UnitRegionData)
    if self.WorldEid2RegionCacheData == nil then
        self.WorldEid2RegionCacheData = {}
    end

    if self.RegionCacheDatas == nil then
        self.RegionCacheDatas = {}
    end

    if SubRegionId == nil or LevelName == nil or WorldRegionEid == nil then
        -- GWorld.logger.error("SetUnitRegionCacheData: 设置区域数据时数据是空的. " .. "SubRegionId:"
        --             .. (SubRegionId and SubRegionId or 'nil') .. "LevelName:".. (LevelName and LevelName or 'nil')
        --              .. "WorldRegionEid:"..(WorldRegionEid and WorldRegionEid or 'nil'))
        -- PrintTable(UnitRegionData)
        local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
        local WCSubSystem = GameMode:GetWCSubSystem()
        if WCSubSystem and GameMode:IsInRegion() then
            WCSubSystem:ShowRegionError_Lua("SetUnitRegionCacheData: 设置区域数据时数据是空的. " .. "SubRegionId:"
                    .. (SubRegionId and SubRegionId or 'nil') .. "LevelName:".. (LevelName and LevelName or 'nil')
                     .. "WorldRegionEid:"..(WorldRegionEid and WorldRegionEid or 'nil'))
        end
        return
    end

    -- assert(SubRegionId, "SubRegionId为空") 
    -- assert(LevelName, "LevelName为空") 
    -- assert(WorldRegionEid, "WorldRegionEid为空")

    SubRegionId = tonumber(SubRegionId)

    -- 注意：服务器拉下来的数据先用于初始化SSData, RegionCacheData用deepcopy拷贝一份出来。
    self.RegionCacheDatas[RegionDataType] = self.RegionCacheDatas[RegionDataType] or {}
    self.RegionCacheDatas[RegionDataType][SubRegionId] = self.RegionCacheDatas[RegionDataType][SubRegionId] or {}
    self.RegionCacheDatas[RegionDataType][SubRegionId][LevelName] = self.RegionCacheDatas[RegionDataType][SubRegionId][LevelName] or {}
    local CopyData = CommonUtils.DeepCopy(UnitRegionData)
    self.RegionCacheDatas[RegionDataType][SubRegionId][LevelName][WorldRegionEid] = CopyData
	-- self.LogHelper:OnClientCacheUpdated(UnitRegionData.WorldRegionEid, UnitRegionData.Eid, UnitRegionData.LevelName)
    self.WorldEid2RegionCacheData[WorldRegionEid] = CopyData
    self.WorldRegionEidExist:Add(WorldRegionEid)
end

function Library:GetUnitRegionCacheDataByWorldRegionEid(WorldRegionEid)
    local UnitRegionData = self.WorldEid2RegionCacheData[WorldRegionEid]
    if not UnitRegionData then
        ScreenPrint("WorldEid2RegionCacheData中找不到WorldRegionEid:【" .. tostring(WorldRegionEid) .. "】的数据")
    end
    return UnitRegionData
end

-- 从RegionCacheDatas中获取数据
function Library:GetUnitRegionCacheData(TypeRegionDatas, SubRegionId, LevelName, WorldRegionEid)
    SubRegionId = tonumber(SubRegionId)
    if not TypeRegionDatas then
        return nil
    end
    local RegionData = TypeRegionDatas[SubRegionId]
    if not RegionData then
        return nil
    end
    local LevelData = RegionData[LevelName]
    if not LevelData then
        return nil
    end

    return LevelData[WorldRegionEid]
end


---------------------------------------------RegionSSDatas 客户端实时序列化数据 --------------------------------------------
function Library:GetManualItemData(ManualItemId)
	return self.ManualItemIdMap[ManualItemId]
end

function Library:ClearManualItemDatas()
	self.ManualItemIdMap = {}
    self.ManualItemWorldRegionEidExist:Clear()
end

function Library:AddRegionSSDatas(UnitRegionData)
    -- 添加SSData.
	if URuntimeCommonFunctionLibrary.UseCppRegionData(GWorld.GameInstance) then
		local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		GameMode:GetRegionDataMgrSubSystem():AddSSData(UnitRegionData.WorldRegionEid)
		return
	end
	
    local LevelName = UnitRegionData.LevelName
    self.RegionSSDatas[LevelName] = self.RegionSSDatas[LevelName] or {}
    if self.RegionSSDatas[LevelName][UnitRegionData.WorldRegionEid] then
        DebugPrint("RegionDataMgr: Error AddRegionSSDatas添加之前就已经存在对应的数据，严查。RegionSSDatas["..LevelName.."]["..UnitRegionData.WorldRegionEid.."]")
    end
    DebugPrint("RegionDataMgr: AddRegionSSDatas 添加RegionSSDatas["..LevelName.."]["..UnitRegionData.WorldRegionEid.."]")
    self.RegionSSDatas[LevelName][UnitRegionData.WorldRegionEid] = UnitRegionData
	if UnitRegionData.WorldRegionEid then
		self.WorldRegionEid2SSData[UnitRegionData.WorldRegionEid] = UnitRegionData
	end
	if UnitRegionData.UnitType == "Npc" then
		self.SerializedNpcs[UnitRegionData.UnitId] = 1
	end
end

function Library:GetRegionSSDataByKey(LevelName, WorldRegionEid)
    if self.RegionSSDatas[LevelName] then
        return self.RegionSSDatas[LevelName][WorldRegionEid]
    end
    return nil
end

function Library:RemoveRegionSSDatas(LevelName, WorldRegionEid)
    if self.RegionSSDatas[LevelName] and self.RegionSSDatas[LevelName][WorldRegionEid] then
		local DeletedData = self.RegionSSDatas[LevelName][WorldRegionEid]
		if DeletedData.UnitType == "Npc" then
			self.SerializedNpcs[DeletedData.UnitId] = nil
		end
		DebugPrint("RegionDataMgr: RemoveRegionSSDatas["..LevelName.."]["..WorldRegionEid.."]")
        self.RegionSSDatas[LevelName][WorldRegionEid] = nil
        self.WorldRegionEid2SSData[WorldRegionEid] = nil
		return true
    end
	return false
end

function Library:RemoveRegionSSDataByWorldRegionEid(WorldRegionEid)
	local RegionBaseData = self.WorldRegionEid2SSData[WorldRegionEid]
	if not RegionBaseData then
		GWorld.logger.errorlog("删除RegionSSData时RegionSSDatas找不到WorldRegionEid:" .. WorldRegionEid .. "的数据")
		return
	end
	local LevelName = RegionBaseData.LevelName
	if not self.RegionSSDatas[LevelName] or not self.RegionSSDatas[LevelName][WorldRegionEid] then
		GWorld.logger.errorlog("删除RegionSSData时RegionSSDatas找不到删除RegionSSData时RegionSSDatas找不到WorldRegionEid:" .. WorldRegionEid .. "的数据")
        return
	end

	self.RegionSSDatas[LevelName][WorldRegionEid] = nil
	self.WorldRegionEid2SSData[WorldRegionEid] = nil
end

function Library:RemoveLevelRegionSSData(LevelName)
    local TmpSSData = self.RegionSSDatas[LevelName]
    if TmpSSData == nil then
        return 
    end

    for WorldEid, Data in pairs(TmpSSData) do
        self:RemoveRegionSSDatas(LevelName, WorldEid)
    end
    self.RegionSSDatas[LevelName] = nil
end

function Library:UpdateRegionSSDatas(UnitRegionData)
    local LevelName = UnitRegionData.LevelName
    local WorldRegionEid = UnitRegionData.WorldRegionEid
    if (LevelName == nil or WorldRegionEid == nil) then
        GWorld.logger.errorlog("UpdateRegionSSDatas 更新SSData数据传入的数据错误")
        PrintTable(UnitRegionData)
        return
    end

    if self.RegionSSDatas[LevelName] == nil or self.RegionSSDatas[LevelName][WorldRegionEid] == nil then
        GWorld.logger.errorlog("UpdateRegionSSDatas 更新SSData数据时传入SSData不存在的数据")
        PrintTable(UnitRegionData)
        return
    end

    self.RegionSSDatas[LevelName][WorldRegionEid] = CommonUtils.DeepCopy(UnitRegionData)
    self.WorldRegionEid2SSData[WorldRegionEid] = self.RegionSSDatas[LevelName][WorldRegionEid]
	self.LogHelper:OnSSDataUpdated(WorldRegionEid, self.RegionSSDatas[LevelName][WorldRegionEid].Eid, LevelName)
end

function Library:UpdateRegionSSDatasState(LevelName, WorldRegionEid, UpdateStateData)
    if self.RegionSSDatas[LevelName] == nil or self.RegionSSDatas[LevelName][WorldRegionEid] == nil then
        return
    end
    local BaseSSData = self.RegionSSDatas[LevelName][WorldRegionEid]
    self:SetStateValue(BaseSSData,UpdateStateData)
end

---------------------------------------------构造区域数据 Begin--------------------------------------------
-- 根据静态点构造数据
function Library:ConstructUnitRegionDataByCreatorData(Eid, LevelName, Creator, WorldRegionEid)
    local Avatar = GWorld:GetAvatar()
    local WorldRegionEid = WorldRegionEid or Avatar:GetWorldRegionEid(Creator, Eid)
    local UnitRegionData = {}
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if not Eid then
        DebugPrint("RegionDataMgr: Error ConstructUnitRegionDataByCreatorData 第一次生成缺少eid", WorldRegionEid)
    end

    local UnitRegionData = self:ConstructCommonUnitRegionData({
        UnitId = Creator.UnitId,
        UnitType = Creator.UnitType,
        Eid = Eid,
        RegionDataType = Creator.RegionDataType,
        WorldRegionEid = WorldRegionEid,
        SubRegionId = GameMode:GetRegionIdByLocation(Creator:K2_GetActorLocation()),
        QuestChainId = Creator:GetQuestChainId(),
        LevelName = LevelName,
        Location = Creator:K2_GetActorLocation(),
        Rotation = Creator:K2_GetActorRotation(),
        CreatorId = Creator.StaticCreatorId,
        RarelyId = Creator.RarelyId,
        IsUnlimited = Creator.IsFullRegionStore,
        ExtraRegionInfo = {SpecialQuestId = Creator.ExtraRegionInfo.SpecialQuestId,
                            DynQuestId = Creator.ExtraRegionInfo.DynQuestId},
    })

    DebugPrint("RegionDataMgr:  ConstructUnitRegionDataByCreatorData",UnitRegionData.WorldRegionEid, UnitRegionData.LevelName, UnitRegionData.RegionDataType)
    -- PrintTable(UnitRegionData, 10)
    return UnitRegionData
end

-- 根据随机刷新点构造数据
function Library:ConstructUnitRegionDataByRandomData(LevelName, RuleId, Param, TmpEid, SpawnRandomTableId, SpawnIdxInRule, WorldRegionEid)
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local SubRegionId = GameMode:GetRegionIdByLocation(Param:GetLoc())
    local RegionDataType = GameMode.RandomActorManager:GetCreatorRegionDataType(RuleId, 0)
	local Avatar = GWorld:GetAvatar()
    local WorldRegionEid = WorldRegionEid or self:GetUnitTypeWorldRegionEid(Param.ActorUnitType, TmpEid)

    local ManagerRot = Param.DataManager:K2_GetActorRotation()
    local Rot = FRotator(Param.ActorRot.Pitch + ManagerRot.Pitch, Param.ActorRot.Yaw + ManagerRot.Yaw,Param.ActorRot.Roll + ManagerRot.Roll)
    local UnitRegionData = self:ConstructCommonUnitRegionData({
        UnitId = Param.UnitId,
        UnitType = Param.UnitType,
        Eid = TmpEid,
        RegionDataType = RegionDataType,
        WorldRegionEid = WorldRegionEid,
        SubRegionId = SubRegionId,
        QuestChainId = -1,  -- 随机点不会有任务id？

        LevelName = LevelName,
        RarelyId = Param.RarelyId,
        Location = Param:GetLoc(),
        Rotation = Rot,

        RandomCreatorId = Param.Actorid,
        RandomRuleId = RuleId,
        RandomTableId = SpawnRandomTableId,
        RandomIdxInRule = SpawnIdxInRule,
        IsUnlimited = false,
        ExtraRegionInfo = {}
    })
    
    DebugPrint("RegionDataMgr:  ConstructUnitRegionDataByRandomData",UnitRegionData.WorldRegionEid, UnitRegionData.LevelName, UnitRegionData.RegionDataType)
    -- PrintTable(UnitRegionData, 10)
    
    return UnitRegionData
end

-- 根据实体构建数据
function Library:ConstructUnitRegionDataByUnit(TargetActor)
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local OriginLevelName = GameMode:GetActorLevelName(TargetActor)
	local WCSubsystem = GameMode:GetWCSubSystem()
	if WCSubsystem and TargetActor.BornPos:Size() ~= 0 then
		OriginLevelName = WCSubsystem:GetLocationLevelName(TargetActor.BornPos)
	end
    local UnitRegionData = self:ConstructCommonUnitRegionData({
        UnitId = TargetActor.UnitId,
        UnitType = TargetActor.UnitType,
        CreatorId = TargetActor.CreatorId,
        -- Eid = TargetActor.Eid,
        RegionDataType = TargetActor.RegionDataType,
        WorldRegionEid = TargetActor.WorldRegionEid,
        SubRegionId = TargetActor.SubRegionId,
        QuestChainId = TargetActor:GetQuestChainId(),

        LevelName = OriginLevelName,
        Location = TargetActor.BornPos,
        -- TargetActor.BornRot
        Rotation = TargetActor.BornRot,
        RarelyId = TargetActor.RarelyId,
        ManualItemId = TargetActor.ManualItemId,
		State = TargetActor.RegionData,

        RandomCreatorId = TargetActor.RandomCreatorId,
        RandomRuleId = TargetActor.RandomRuleId,
        RandomTableId = TargetActor.RandomTableId,
        RandomIdxInRule = TargetActor.RandomIdxInRule,

        IsUnlimited = TargetActor.IsFullRegionStore,
        ExtraRegionInfo = {SpecialQuestId = TargetActor.ExtraRegionInfo.SpecialQuestId,
                            DynQuestId = TargetActor.ExtraRegionInfo.DynQuestId},
    })


    DebugPrint("RegionDataMgr:  ConstructUnitRegionDataByUnit",UnitRegionData.WorldRegionEid, UnitRegionData.LevelName, UnitRegionData.RegionDataType)
    -- PrintTable(UnitRegionData, 10)
    
    return UnitRegionData
end

function Library:ConstructCommonUnitRegionData(Info)
    local UnitRegionData = {}
    UnitRegionData.UnitId = Info.UnitId
    UnitRegionData.UnitType = Info.UnitType
    UnitRegionData.Eid = Info.Eid
    UnitRegionData.RegionDataType = Info.RegionDataType
    UnitRegionData.WorldRegionEid = Info.WorldRegionEid
    UnitRegionData.SubRegionId = Info.SubRegionId
    UnitRegionData.QuestChainId = Info.QuestChainId
    UnitRegionData.LevelName = Info.LevelName
    UnitRegionData.ManualItemId = Info.ManualItemId
    UnitRegionData.CreatorId = Info.CreatorId
    UnitRegionData.RarelyId = Info.RarelyId
    UnitRegionData.ExtraRegionInfo = {
        SpecialQuestId = Info.ExtraRegionInfo.SpecialQuestId,
        DynQuestId = Info.ExtraRegionInfo.DynQuestId
    } 
    

    self:SetBornLocation(UnitRegionData, Info.Location)
    self:SetRotation(UnitRegionData, Info.Rotation)

    UnitRegionData.IsUnlimited = Info.IsUnlimited

    UnitRegionData.RandomCreatorId = Info.RandomCreatorId
    UnitRegionData.RandomRuleId = Info.RandomRuleId
    UnitRegionData.RandomTableId = Info.RandomTableId
    UnitRegionData.RandomIdxInRule = Info.RandomIdxInRule
	UnitRegionData.State = Info.State

    -- UnitRegionData.IsUnlimited = Info.IsUnlimited

    return UnitRegionData
end


function Library:SetRotation(UnitRegionData, Rotation)
    if not Rotation then 
        return 
    end
    if not UnitRegionData.Rotation then 
        UnitRegionData.Rotation = {} 
    end
    UnitRegionData.Rotation.pitch = Rotation.pitch
    UnitRegionData.Rotation.yaw = Rotation.yaw
    UnitRegionData.Rotation.roll = Rotation.roll
end

function Library:SetBornLocation(UnitRegionData, Location)
    if not Location then 
        return 
    end
    if not UnitRegionData.BornLocation then 
        UnitRegionData.BornLocation = {} 
    end
    UnitRegionData.BornLocation.X = Location.X
    UnitRegionData.BornLocation.Y = Location.Y
    UnitRegionData.BornLocation.Z = Location.Z
end


function Library:SetLocation(RegionBaseData, Location)
	if not Location then return end
	if not RegionBaseData.Location then RegionBaseData.Location = {} end
	RegionBaseData.Location.X = Location.X
	RegionBaseData.Location.Y = Location.Y
	RegionBaseData.Location.Z = Location.Z
end

function Library:SetStateValue(RegionBaseData, StateTable)
	if not StateTable or type(StateTable) ~= "table" then
		return
	end
    local TempStateTable = CommonUtils.DeepCopy(StateTable)
	if not RegionBaseData.State then
		RegionBaseData.State = {}
	end
	for _, State in pairs(TempStateTable) do
		RegionBaseData.State[_] = State
	end
end

function Library:GetStateValue(WorldRegionEid)
    local ClientCacheData = self:GetUnitRegionCacheDataByWorldRegionEid(WorldRegionEid)
    if WorldRegionEid and ClientCacheData.State then
        return CommonUtils.DeepCopy(ClientCacheData.State)
    end
    return nil
end

function Library:GetUnitTypeWorldRegionEid(UnitType, Eid)
	Eid = Eid or tostring(math.random())
	if not UnitType or UnitType == "" then
		DebugPrint("ZJT_ GetUnitTypeWorldRegionEid UnitType 没配表 ", Eid)
	end
	local WorldRegionEid = UnitType.."_"..Eid.."_"..os.time()
	-- DebugPrint("ZJT_ GetUnitTypeWorldRegionEid ", WorldRegionEid, WorldRegionEid, Eid)
	return WorldRegionEid
end

---------------------------------------------构造区域数据 End--------------------------------------------

---------------------------------------------特殊任务数据相关---------------------------------------------

--- @param RegionDataTypeStr string 对应UniversalConfig表中的RegionDataType字段
--- @param QuestChainId int 任务链id
--- @param SpecialQuestId int 特殊任务id
function Library:OnSpecialQuestBegin(QuestChainId,SpecialQuestId,RegionDataTypeStrList)
    assert(SpecialQuestId, "OnSpecialQuestBegin ParamError")
    assert(type(RegionDataTypeStrList) == "table", "需保留的数据类型不为List,检查UniversalConfig表,SpecialQuestId = ",SpecialQuestId)
    self.CurSpecialQuestChainId = QuestChainId
    self.CurSpecialQuestid = SpecialQuestId
    for _,RDT in pairs(RegionDataTypeStrList) do
        assert(UE4.ERegionDataType[RDT] >= 0, "枚举中找不到该值, RDT = ".. RDT or "")
        self.SpecialQuestHoldRegionDataType[UE4.ERegionDataType[RDT]] = true
    end
    -- assert(self.SpecialQuestHoldRegionDataType, "SpecialQuestHoldRegionDataType Error " .. RegionDataTypeStr .. "Can't Convert to ERegionDataType")
end

function Library:OnSpecialQuestEnd()
    self.CurSpecialQuestChainId = nil
    self.CurSpecialQuestid = nil
    self.SpecialQuestHoldRegionDataType = {}
end

function Library:IsInSpecialQuest()
    return self.CurSpecialQuestid ~= nil
end

-- 特殊任务期间一些指定的Actor会被销毁，此时也不应该被反序列化
function Library:CheckCanCreateWhileSpecialQuest(RegionBaseData)
    if self.CurSpecialQuestChainId == nil  or self.CurSpecialQuestid == nil or self.CurSpecialQuestid == 0 then
        return true
    end

    if not RegionBaseData or not RegionBaseData.ExtraRegionInfo then
        return true
    end

    if RegionBaseData.ExtraRegionInfo.SpecialQuestId == self.CurSpecialQuestid then
        return true
    end

    return not self:CheckRegionDataTypeNeedDestroy(RegionBaseData.RegionDataType, RegionBaseData.QuestChainId)
end

function Library:CheckRegionDataTypeNeedDestroy(RegionDataType,QuestChainId)
    -- DebugPrint("CheckRegionDataTypeNeedDestroy ",RegionDataType,QuestChainId)
    if not RegionDataType then return end
    if not self.SpecialQuestHoldRegionDataType[RegionDataType] then return true end
    --  保留类型为QuestData的同时任务链相同  或  RDT与需要保留的类型相同且需要保留的RDT类型不为QuestData
    local bTryHoldQuestData = RegionDataType == UE4.ERegionDataType.RDT_QuestData
    if bTryHoldQuestData then
        return QuestChainId ~= self.CurSpecialQuestChainId
    end
    return false
end


function Library:GetSpecialQuestUniversalConfig()
    if not self.CurSpecialQuestid then return end
    local SpecialQuestConfig = DataMgr.SpecialQuestConfig[self.CurSpecialQuestid]
    if SpecialQuestConfig and SpecialQuestConfig.UniversalConfigId then
        return DataMgr.UniversalConfig[SpecialQuestConfig.UniversalConfigId]
    end
end
---------------------------------------------特殊任务数据相关 END-----------------------------------------
return Library