require "UnLua"
require "Const"

local M = Class()

-- 区域几个时间节点初始化顺序
-- 1. 切换区域从服务器收到区域数据RPC ReceiveSynchronizedDataFromServer、ReceiveSyncAllRegionDataFromServer
-- 2. 切换区域成功的RPC PrepareToBattleRegion
-- 3. 服务器区域状态更新完成RPC SetInRegionState、SetEnterLevelStateReady
-- 4. 客户端GameMode OnInit

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
----------------------------------------- 1. 拉取服务器数据后的初始化 ----------------------------------------------------


-- 同步全区域存储数据
-- 登录时从服务器拉一次全区域存储的数据，如传送点数据。
-- [WorldRegionEid] = RegionBaseData
-- todo，如果有除传送点外的Unit数据，考虑存到SSData和ClientCache
function M:SyncFullRegionStoreDataFromServer(FullRegionStoreData)
    self.DataLibrary.FullRegionStoreDatas = FullRegionStoreData
end

-- todo
-- 同步所在区域存储数据
-- 除全区域数据外的定义为所在区域数据，只在切区域时从服务器拉一次数据。
-- 如任务有额外需求，需要客户端有其他区域的数据，则定义为全区域存储数据。
function M:SyncPartRegionDataFromServer(PartRegionStoreData)
	self.NewDataReceived = true
	self.PartRegionStoreData = PartRegionStoreData
	-- 这里清理一次 一会再清理一次
	-- self.DataLibrary:ClearSSData()
    -- self.DataLibrary:ClearRegionCacheDatas()
	-- self.DataLibrary:ClearManualItemDatas()
	-- self:ClearCppRegionData()

	-- self:MakeManualItemIdMap()
	-- if self.DataPool then
	-- 	self.DataPool:Initialize(self)
	-- end
    -- self:SyncServerRegionData(PartRegionStoreData)
end

function M:ClearServerRegionData()
	-- self:TryActiveDefaultDeliver()
	self.DataLibrary:ClearSSData()
    self.DataLibrary:ClearRegionCacheDatas()
	self.DataLibrary:ClearManualItemDatas()
	self:ClearCppRegionData()

	self:MakeManualItemIdMap()
	if self.DataPool then
		self.DataPool:Initialize(self)
	end
	self.DataLibrary.LogHelper.bIsRegionLogEnabled = self.IsRegionLogEnabled
	self.RegionDataAddCallback = {}--暂时只用于新版WCDungeon Server
	self.RegionDataUpdateCallback = {}
end

function M:MakeManualItemIdMap()
	if not self.PartRegionStoreData then
		return
	end
	for RegionDataType, SubRegionDatas in pairs(self.PartRegionStoreData) do
        for SubRegionId, LevelRegionDatas in pairs(SubRegionDatas) do   
           for LevelName, RegionDatas in pairs(LevelRegionDatas) do
                for WorldRegionEid, RegionBaseData in pairs(RegionDatas) do
					if RegionBaseData.ManualItemId~= nil and RegionBaseData.ManualItemId > 0 then
						self.DataLibrary.ManualItemIdMap[RegionBaseData.ManualItemId] = RegionBaseData
						self.DataLibrary.ManualItemWorldRegionEidExist:Add(RegionBaseData.ManualItemId, RegionBaseData.WorldRegionEid)
					end
				end
			end
		end
	end
end

function M:SyncServerRegionData()
    GWorld.UploadQuestChainData = true
    -- 切区域后这两个都清 第二次清理
    self.DataLibrary:ClearSSData()
    self.DataLibrary:ClearRegionCacheDatas()
	if not self.PartRegionStoreData or not self.NewDataReceived then
		self.CurRegionDeliverDatas = {}
    	self.CurRegionDeliver = {}
		self.CurRegionDeliverNew:Clear()
		self.CurRegionDeliverDatasNew:Clear()
		return
	end
	self.NewDataReceived = false
    for RegionDataType, SubRegionDatas in pairs(self.PartRegionStoreData) do
        for SubRegionId, LevelRegionDatas in pairs(SubRegionDatas) do   
           for LevelName, RegionDatas in pairs(LevelRegionDatas) do
                for WorldRegionEid, RegionBaseData in pairs(RegionDatas) do
                    if self.DataLibrary.RegionSSDatas[LevelName] == nil then
                        self.DataLibrary.RegionSSDatas[LevelName] = {}
                    end
                    RegionBaseData.ExtraRegionInfo = RegionBaseData.ExtraRegionInfo or {}
					if URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
                    	self.DataLibrary:AddUnitRegionCacheData(RegionBaseData)
						self:InitSSDataFromServer(RegionBaseData)
					else
						self.DataLibrary:SetUnitRegionCacheData(RegionDataType, SubRegionId, LevelName, WorldRegionEid, RegionBaseData)
                    	self.DataLibrary:AddRegionSSDatas(RegionBaseData)
					end
                end
           end 
        end
    end
	-- if SubSystem.bTryActiveDefaultDeliver then
		-- 	SubSystem:TryActiveDefaultDeliver()
		-- end
		
	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
	if SubSystem then
		-- SubSystem:SetRegionInitState(ERegionInitState.RegionDataReceived)
	end
    GWorld.UploadQuestChainData = false
end

function M:InitSSDataFromServer(RegionBaseData)
	self:InitSubRegionInfoByData(RegionBaseData)
	if RegionBaseData.ManualItemId~=nil and RegionBaseData.ManualItemId > 0 then
		return
	end
	if RegionBaseData.IsDead and self:CheckRegionDataNeedDead(RegionBaseData) then
		self.DataLibrary:SetUnitRegionCacheData(RegionBaseData.RegionDataType, RegionBaseData.SubRegionId, RegionBaseData.LevelName, RegionBaseData.WorldRegionEid, RegionBaseData)
		return
	end
	self.LastState = RegionBaseData.State
	self.LastBornLocation = RegionBaseData.BornLocation
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	if RegionBaseData.CreatorId~=nil and RegionBaseData.CreatorId > 0 then
		if not RegionBaseData.RandomRuleId or RegionBaseData.RandomRuleId == 0 then
			if GameState.StaticCreatorMap:Find(RegionBaseData.CreatorId) then
				self:InitStaticCreatorParams(RegionBaseData.CreatorId, RegionBaseData.QuestChainId, RegionBaseData.ExtraRegionInfo.SpecialQuestId, RegionBaseData.ExtraRegionInfo.DynQuestId)
				self:InitSSDataFromServer_StaticCreator(RegionBaseData.WorldRegionEid, RegionBaseData.LevelName, RegionBaseData.CreatorId)
			else
				GWorld.logger.error("区域数据初始化没有找到StaticCreator!! 已跳过：".. RegionBaseData.CreatorId)
			end
		end
	elseif RegionBaseData.RandomRuleId and RegionBaseData.RandomRuleId > 0 then
		RegionBaseData.BornLocation = RegionBaseData.BornLocation or {X = 0, Y = 0, Z = 0}
		self:InitSSDataFromServer_RandomCreator(RegionBaseData.WorldRegionEid, RegionBaseData.LevelName, RegionBaseData.RandomCreatorId, RegionBaseData.RandomRuleId, 
		RegionBaseData.RandomTableId, RegionBaseData.RandomIdxInRule, RegionBaseData.BornLocation.X, RegionBaseData.BornLocation.Y, RegionBaseData.BornLocation.Z)
	else
		RegionBaseData.BornLocation = RegionBaseData.BornLocation or {X = 0, Y = 0, Z = 0}
		local Location = FVector(RegionBaseData.BornLocation.X, RegionBaseData.BornLocation.Y, RegionBaseData.BornLocation.Z)
		RegionBaseData.Rotation = RegionBaseData.Rotation or {Pitch = 0, Yaw = 0, Roll = 0}
		local Rotation = FRotator(RegionBaseData.Rotation.Pitch, RegionBaseData.Rotation.Yaw, RegionBaseData.Rotation.Roll)
		self:InitSSDataFromServer_Raw(RegionBaseData.WorldRegionEid, RegionBaseData.LevelName, RegionBaseData.UnitType, RegionBaseData.UnitId, Location, Rotation, RegionBaseData.RegionDataType)
	end
end

function M:InitSSDataFromDungeonServer(RegionBaseData)
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	local RealData = nil
	if RegionBaseData.CreatorId and RegionBaseData.CreatorId > 0 then
		local Creator = GameState.StaticCreatorMap:Find(RegionBaseData.CreatorId)
		if Creator then
			local LevelName, WorldRegionEid, LuaIndex = self:AllocateDungeonServerData(Creator)
			RegionBaseData.LevelName = LevelName
			RegionBaseData.WorldRegionEid = WorldRegionEid
			DebugPrint('InitSSDataFromDungeonServer StaticCreator:',RegionBaseData.ServerUniqueId,RegionBaseData.CreatorId, LevelName, WorldRegionEid)
			self:InitSSDataFromServer(RegionBaseData)
			RealData = self.DataPool:GetRegionEntityDataNoCopy(LuaIndex)
			if RealData then
				RealData.ServerUniqueId = RegionBaseData.ServerUniqueId
			end
		else
			GWorld.logger.error("副本区域数据初始化没有找到StaticCreator!! 已跳过：".. RegionBaseData.CreatorId)
		end
	elseif RegionBaseData.RandomRuleId and RegionBaseData.RandomRuleId > 0 then
		local LevelName, WorldRegionEid, LuaIndex = self:AllocateDungeonServerData(nil, RegionBaseData.LevelName)
		RegionBaseData.WorldRegionEid = WorldRegionEid
		local Check = false
		local RandomParams = GameState.RandomCreatorRuleMap:FindRef(RegionBaseData.RandomRuleId)
		if RandomParams then
			local Param = RandomParams.Params:GetRef(RegionBaseData.RandomIdxInRule + 1)
			if Param then
				RegionBaseData.RandomCreatorId = Param.Actorid
				Check = true
			end
		end
		if not Check then
			GWorld.logger.error("副本区域数据初始化没有找到RandomCreator!! 已跳过：".. RegionBaseData.RandomRuleId .. ", " .. RegionBaseData.RandomIdxInRule)
			return
		end
		DebugPrint('InitSSDataFromDungeonServer RandomCreator:',RegionBaseData.ServerUniqueId,LevelName, WorldRegionEid, RegionBaseData.RandomCreatorId, RegionBaseData.RandomRuleId, 
		RegionBaseData.RandomTableId, RegionBaseData.RandomIdxInRule)
		-- local MyRandomCreatorId = RegionBaseData.RandomCreatorId
		self:InitSSDataFromServer(RegionBaseData)
		RealData = self.DataPool:GetRegionEntityDataNoCopy(LuaIndex)
		if RealData then
			RealData.ServerUniqueId = RegionBaseData.ServerUniqueId
			--副本RandomDataManager位置归零
			-- local RandomActorManager = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance).RandomActorManager
			-- local Check = false
			-- if RandomActorManager then
			-- 	local Template = RandomActorManager.Templates:FindRef(RegionBaseData.RandomRuleId)
			-- 	if Template then
			-- 		local Param = Template:GetParam(RegionBaseData.RandomRuleId, RealData.RandomCreatorId)
			-- 		if Param then
			-- 			RealData.Loc = Param:GetLoc()
			-- 			-- RealData.Rotation = Param:GetRot()
			-- 			Check = true
			-- 		end
			-- 	end
			-- end
			-- if not Check then
			-- 	self:ShowRegionError(string.format("InitSSDataFromDungeonServer RandomCreator Not Find Param: %s, %s, %s, %d, %d, %d, %d \r\n DungeonId:",LevelName, WorldRegionEid, RegionBaseData.RandomCreatorId, RegionBaseData.RandomRuleId, 
			-- 	RegionBaseData.RandomTableId, RegionBaseData.RandomIdxInRule, GameState.DungeonId))
			-- end
			-- RealData.RandomCreatorId = MyRandomCreatorId--用原版是从1开始， 有和静态点id撞id风险
		end
	end
	if RealData then
		self:ExeRegionDataAddCallback(RealData)
	end
end

function M:CheckRegionDataNeedDead(RegionBaseData)
	if RegionBaseData.RegionDataType == 1 and RegionBaseData.UnitType == "Mechanism" and RegionBaseData.UnitId then
		if not self.MechanismNoDeadType then
			self.MechanismNoDeadType = {"HardBossOpenMechanism", "TeleportMechanism", "Delivery"}
		end
		local Data = DataMgr.Mechanism[RegionBaseData.UnitId] 
		if Data then
			return not CommonUtils.HasValue(self.MechanismNoDeadType, Data.UnitRealType)
		end
	end
	return true
end

function M:InitStaticCreatorParams(CreatorId, QuestChainId, SpecialQuestId, DynQuestId)
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	if not GameState then
		return
	end
	local Creator = GameState.StaticCreatorMap:FindRef(CreatorId)
	if not Creator then
		return
	end
	Creator:SetQuestChainId(QuestChainId)
	Creator.ExtraRegionInfo.SpecialQuestId = SpecialQuestId
	Creator.ExtraRegionInfo.DynQuestId = DynQuestId 
end

function M:InitSSDataFromServer_StaticCreator_Lua(LuaTableIndex, CreatorId)
	local Context = AEventMgr.CreateUnitContext()
	Context.IntParams:Add("CreatorId", CreatorId)
	Context.IntParams:Add("Type", 4)
	Context:AddLuaTable("State", self.LastState)
	self:InitRegionDataTable(LuaTableIndex, Context)
	self.LastState = nil
	self.LastBornLocation = nil
	self.DataPool:GetRegionEntityDataNoCopy(LuaTableIndex)--提前完善数据，减少运行时恢复数据时的消耗
end

function M:InitSSDataFromServer_RandomCreator_Lua(LuaTableIndex, RandomCreatorId, RandomRuleId, RandomTableId, RandomIdxInRule, LevelName)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	GameMode.RandomActorManager:GetCreator(RandomRuleId, LevelName, RandomIdxInRule)
	local Context = AEventMgr.CreateUnitContext()
	Context.IntParams:Add("RandomCreatorId", RandomCreatorId)
	Context.IntParams:Add("RandomRuleId", RandomRuleId)
	Context.IntParams:Add("RandomTableId", RandomTableId)
	Context.IntParams:Add("RandomIdxInRule", RandomIdxInRule)
	Context.VectorParams:Add("BornLocation", FVector(self.LastBornLocation.X, self.LastBornLocation.Y, self.LastBornLocation.Z))
	Context.IntParams:Add("Type", 4)
	Context:AddLuaTable("State", self.LastState)
	self:InitRegionDataTable(LuaTableIndex, Context)
	self.LastState = nil
	self.LastBornLocation = nil
	self.DataPool:GetRegionEntityDataNoCopy(LuaTableIndex)
end

function M:InitSSDataFromServer_Raw_Lua(LuaTableIndex, UnitType, UnitId, Location, Rotation, RegionDataType)
	local Context = AEventMgr.CreateUnitContext()
	Context.UnitId = UnitId
	Context.UnitType = UnitType
	Context.Loc = Location
	Context.Rotation = Rotation
	Context.IntParams:Add("RegionDataType", RegionDataType)
	Context.IntParams:Add("Type", 4)
	Context:AddLuaTable("State", self.LastState)
	self:InitRegionDataTable(LuaTableIndex, Context)
	self.LastState = nil
	self.LastBornLocation = nil
	self.DataPool:GetRegionEntityDataNoCopy(LuaTableIndex)
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------2. PrepareToBattleRegion时的初始化---------------------------------------------

function M:InitCacheByPrepareRegion()
	self:InitRegionDeliverMechanismCache()
	self:InitSpawnActorDataCache()
	self:InitCretorDataCache() 
end

function M:InitCretorDataCache()
    self.StaticIdControlCache = {}
	self.RandomIdControlCache = {}
	self:ClearControlCache()
end

-- 缓存一下表里的传送点数据
function M:InitRegionDeliverMechanismCache()
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode then
		self:TryActiveDefaultDeliver()
	end
	self.CurRegionDeliverNew:Clear()
	self.CurRegionDeliverDatasNew:Clear()
	local Avatar = GWorld:GetAvatar()
	self:InitRegionDeliverMechanismCacheCpp(Avatar:GetSubRegionId2RegionId())
end

---- ManualDatas
function M:InitSpawnActorDataCache()
    self.ManualDatas = {}
end
function M:AddManualDataToCache(ManualItemId, WorldRegionEid)
	if not ManualItemId or not WorldRegionEid or ManualItemId <= 0 then return end
	if not self:IsExistManualItemId(ManualItemId) and ManualItemId > 0 then
		self.ManualDatas[ManualItemId] = WorldRegionEid
	end
end

function M:IsExistManualItemId(ManualItemId)
	if not ManualItemId then return false end
	if self.ManualDatas[ManualItemId] then return true end
	return false
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------ 3. SetInRegionState、SetEnterLevelStateReady 服务器状态设置成功后的初始化 ------------------------

function M:InitRegionInfo()
    GWorld.UploadQuestChainData = true

    -- 进入区域时调用,初始化一些配置和基础结构数据
    self.ReadyRegionRecover = true

    -- 目的，不让gamemode反复触发事件的阻断
    self.LoadSubRegionCache = {}

    local Avatar = GWorld:GetAvatar()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not GameMode:IsInRegion() then
		return
	end
    local WorldLoader = GameMode:GetLevelLoader()
    if WorldLoader and GWorld:GetWorldRegionState() and Avatar:CheckCurrentSubRegion() then
        -- 恢复BpBorn的Actor
        self:RecoverRegionBpData(Avatar, Avatar.CurrenRegionId)
    end

    GWorld.UploadQuestChainData = false

	if not self.Inited then
		self:OnInitRecoverRegionData(false)
	end
end


function M:RecoverRegionBpData(Avatar, SubRegionId)
    -- 恢复区域bp数据和静态点数据，随机点数据和探索组数据
    local RegionId = Avatar:GetSubRegionId2RegionId(SubRegionId)
    local RegionData = DataMgr.Region[RegionId]
    if not RegionData then 
        DebugPrint("Error! RecoverRegionBpData 找不到区域数据", RegionId)
        return 
    end
    local StorageRegionDataType = {1,2,3,5,6,7}
    for RegionDataType, j in ipairs(StorageRegionDataType) do
        for _, SubRegionId in ipairs(RegionData.IsRandom) do
        -- 遍历这个区域下的所有子区域，按照数据类型恢复一下bp数据和静态点数据
            local Datas = self.DataLibrary:GetRegionCacheDatasByIdType(RegionDataType)
            self:RecoverSubRegionDataCache(Avatar, SubRegionId, RegionDataType, Datas)
        end
    end
    for _, SubRegionId in ipairs(RegionData.IsRandom) do
        -- 恢复探索组内部数据恢复
        self:RecoverRegionRarelyGroupDataCache(Avatar, SubRegionId)
    end
end

----- 探索组处理
-- Avatar.Explore是属性同步，todo
function M:RecoverRegionRarelyGroupDataCache(Avatar, SubRegionId)
    if not Avatar then return end
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    for  _, RarelyId in pairs(Avatar.Explores:Keys()) do
        local ExploreActor = GameMode.EMGameState.ExploreGroupMap:FindRef(RarelyId)
        local Explore = Avatar.Explores[RarelyId]
        -- 探索组存在并且不是未激活状态
        if IsValid(ExploreActor) and Explore and not Explore:IsInActive() and Explore.RegionId == SubRegionId then
            -- 状态同步 + 属性赋值
            ExploreActor:RealSetExploreGroupStatus(Explore:GetState())
            for ExploreDataKey, ExploreDataValue in pairs(Explore.ExploreData.Props) do
                ExploreActor[ExploreDataKey] = ExploreDataValue
            end
        end
    end
end

function M:InitSubRegionInfoByData(UnitData)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if UnitData.ManualItemId and UnitData.ManualItemId > 0 then
		DebugPrint("RecoverSubRegionDataCache 恢复这些manualitem", UnitData.ManualItemId, UnitData.SubRegionId, UnitData.UnitType,UnitData.UnitId)
		local ManualItemActor = GameMode.BPBornRegionActor:FindRef(UnitData.ManualItemId)
		if ManualItemActor then 
			if UnitData.IsDead and ManualItemActor:GetUnitRealType() == "RockTrap" then
				if ManualItemActor.EMActorDestroy then
					ManualItemActor:EMActorDestroy(EDestroyReason.RecoverSubRegionDataCacheButBpBornHasAlreadyDead)
				else
					DebugPrint("Error! RecoverSubRegionDataCache 此ACTOR 蓝图生成，但是没有销毁方法", ManualItemActor)
				end
			else
				local Context = AEventMgr.CreateUnitContext()
				Context.UnitId = UnitData.UnitId
				Context.UnitType = UnitData.UnitType
				Context:AddLuaTable("State", UnitData.State)
				Context.IntParams:Add("RegionDataType", UnitData.RegionDataType)
				Context.NameParams:Add("WorldRegionEid", UnitData.WorldRegionEid)
				Context.IntParams:Add("SubRegionId", UnitData.SubRegionId)
				Context.VectorParams:Add("BornLoc", ManualItemActor:K2_GetActorLocation())
				ManualItemActor:RegisterInfoNew(Context)
			end
			self:AddManualDataToCache(UnitData.ManualItemId, UnitData.WorldRegionEid)
		else
			DebugPrint("Error! 区域，存在一个蓝图生成的actor，但是当前场景内未找到")
		end
	elseif UnitData.CreatorId then
		-- 添加静态点的控制cache
		local Context = AEventMgr.CreateUnitContext()
		Context.IntParams:Add("CreatorId", UnitData.CreatorId)
		Context.NameParams:Add("WorldRegionEid", UnitData.WorldRegionEid)
		Context.IntParams:Add("SubRegionId", UnitData.SubRegionId)
		self:AddCretorActiveCacheNew(Context)
		self:InitStaticCreatorData(UnitData)
	-- 处理 随机点生成的
	-- 但是这个地方函数层次不是并列的  AddCretorActiveCache 会包含AddStaticCreatorId，有点怪
	-- 之后处理
	elseif UnitData.RandomRuleId then
		local WorldLoader = GameMode:GetLevelLoader()
		local LevelName = WorldLoader:GetLevelIdByLocation(FVector(UnitData.BornLocation.X, UnitData.BornLocation.Y, UnitData.BornLocation.Z))
		if LevelName == "None" or LevelName == "" then
			DebugPrint("RandomCreator中不存在如下数据： Location = ", UnitData.BornLocation.X, UnitData.BornLocation.Y, UnitData.BornLocation.Z)
		end
		local RandomCreatorId = GameMode.RandomActorManager:GetParamActorId(UnitData.RandomRuleId, LevelName, UnitData.RandomIdxInRule)
		UnitData.RandomCreatorId = RandomCreatorId
		local Context = AEventMgr.CreateUnitContext()
		Context.IntParams:Add("RandomCreatorId", UnitData.RandomCreatorId)
		Context.IntParams:Add("RandomRuleId", UnitData.RandomRuleId)
		Context.NameParams:Add("WorldRegionEid", UnitData.WorldRegionEid)
		Context.IntParams:Add("SubRegionId", UnitData.SubRegionId)
		self:AddCretorActiveCacheNew(Context)
	end
	-- 添加本地，增加可读性，无逻辑需求
	-- Avatar:AddRegionBaseDataByCache(WorldRegionEid, RegionDataType, UnitData)
end

function M:RecoverSubRegionDataCache(Avatar, SubRegionId, RegionDataType, Datas)
    if not Datas then 
        return 
    end
	if URuntimeCommonFunctionLibrary.UseCppRegionData(GWorld.GameInstance) then
		return
	end
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local SubRegionDatas = Datas[SubRegionId]
    if not SubRegionDatas then 
        return 
    end
    -- PrintTable(SubRegionDatas, 6)
    for LevelName, SubRegionData in pairs(SubRegionDatas) do
        for WorldRegionEid, UnitData in pairs(SubRegionData) do
            -- 处理  拖进去的BpBorn
			self:InitSubRegionInfoByData(UnitData)
        end
    end
end 

-- 从服务器上拉下来的RegionData, 在第一次反序列化成为Actor之前缺失StaticCreator->Actor/SSData的映射关系, 使用WorldRegionEid映射一下
function M:InitStaticCreatorData(UnitData)
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState then
		return
	end
	local StaticCreator = GameState.StaticCreatorMap:FindRef(UnitData.CreatorId)
	if not IsValid(StaticCreator) then
		return
	end
	if not UnitData.WorldRegionEid or UnitData.WorldRegionEid == "" then
		return
	end
	StaticCreator.ChildSerializedWorldRegionEids:Add(UnitData.WorldRegionEid)
end



------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ GameMode OnInit中调用 ------------------------------------------------

function M:OnInitRecoverRegionData(IsReRecover)
    -- 恢复生成的Actor
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)

    -- SystemGuideManager:AddListenerSystemGuide() 先注释掉

    if not self.ReadyRegionRecover then 
        DebugPrint("ZJT_ Recover Region Data Failer !!!") 
        return 
    end
    local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local WorldLoader = GameMode:GetLevelLoader()
    if WorldLoader and GWorld:GetWorldRegionState() and Avatar:CheckCurrentSubRegion() then
        if not URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
            WorldLoader:ArtLevelBindEvent(IsReRecover)
        else
            if not IsReRecover then
                -- C++，注册WC回调。todo，后续需转移到Loading
                GameMode:InitWCEvent()
            else
                -- hardboss的恢复，只恢复事件即可
                GameMode:TriggerLoadedEvent()
            end
        end
    end
    WorldLoader:OpenInitSuit()
	self.Inited = true
end

-- function M:PostInit()
-- 	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
-- end

return M