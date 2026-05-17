require "UnLua"

local DungeonFactory = require "BluePrints.DungeonObject.DungeonFactory"
local SDRC = require "Datas.ServerDomLevel_data.ServerDomRandomCreator"
local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
local DungeonObjectComponent = {}

function DungeonObjectComponent:yxdtest(EventName)
	self:NotifyServerDungeonEvent(EventName, {})
end

function DungeonObjectComponent:InitDungeonObject(DungeonId)
	local DungeonInfo = DataMgr.Dungeon[DungeonId]
	if not DungeonInfo then
		return
	end

	local DungeonType = DungeonInfo.DungeonType
	local ServerEntity = GWorld:GetServerEntity()
	if not ServerEntity then
		return
	end

	local DungeonObject = ServerEntity:GetDungeonObject()
	if not DungeonObject then
		return
	end

	DungeonObject:Init({
		GameMode = self,
		Battle = Battle,
	})
	self:SetServerDungeonEnable()
	DungeonObject:BeginPlay()

	-- 临时在这里调用ClientDungeon的初始化
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.ClientDungeonObject then
        Avatar.ClientDungeonObject:BeginPlay()
    end
	-- self.AddRandomCreatorId = 0
end

function DungeonObjectComponent:SetServerDungeonEnable()
	self.ServerDungeonEnable = true
end

function DungeonObjectComponent:CheckServerDungeonEnable()
	if self:IsInRegion() then
		return false
	end
	return self.ServerDungeonEnable
end

function DungeonObjectComponent:NotifyServerDungeonEvent(EventName, ...)
	if not self:CheckServerDungeonEnable() then 
		return
	end
	DebugPrint("DungeonObjectComponent:NotifyServerDungeonEvent, EventName: ", EventName)
	local ServerEntity = GWorld:GetServerEntity()
	if not ServerEntity then
		DebugPrint("NotifyServerDungeonEvent 服务器实体不存在")
		return
	end
	local DungeonObject = ServerEntity:GetDungeonObject()
	if not DungeonObject then
		DebugPrint("NotifyServerDungeonEvent DungeonObject不存在")
		return
	end
	DungeonObject:NotifyServerDungeonEvent(EventName, ...)
end

function DungeonObjectComponent:NotifyServerDungeonEventWithCallback(Callback, EventName, ...)
	if not self:CheckServerDungeonEnable() then 
		return
	end
	DebugPrint("DungeonObjectComponent:NotifyServerDungeonEventWithCallback, EventName: ", EventName)
	local ServerEntity = GWorld:GetServerEntity()
	if not ServerEntity then
		DebugPrint("DungeonObjectComponent:NotifyServerDungeonEventWithCallback 服务器实体不存在")
		return
	end
	local DungeonObject = ServerEntity:GetDungeonObject()
	if not DungeonObject then
		DebugPrint("DungeonObjectComponent:NotifyServerDungeonEventWithCallback DungeonObject不存在")
		return
	end
	DungeonObject:NotifyServerDungeonEventWithCallback(Callback, EventName, ...)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent(EventName, ...)
	if not self:CheckServerDungeonEnable() then 
		return
	end

	DebugPrint("GameMode:OnNotifyGameModeDungeonEvent, EventName: ", EventName)
	local FunName = "OnNotifyGameModeDungeonEvent_"..EventName
	if self[FunName] then
		self[FunName](self, ...)
	end
end


----------------------提供具体的业务逻辑接口----------------------

-- 服务器通知GameMode静态点激活
function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerActiveStaticCreator(Infos)
	DebugPrint("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerActiveStaticCreator")
	PrintTable(Infos, 10)
	for i, Info in pairs(Infos) do
		local RegionBaseData = {}
		RegionBaseData.CreatorId = Info.StaticCreatorId
		RegionBaseData.ServerUniqueId = Info.UniqueId
		RegionBaseData.UnitId = Info.UnitId
		RegionBaseData.ExtraRegionInfo = {}
		self:GetRegionDataMgrSubSystem():InitSSDataFromDungeonServer(RegionBaseData)
	end
end

-- 服务器通知GameMode随机点激活
function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerActiveRandomCreator(Infos)
	DebugPrint("gmy@DungeonObjectComponent DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerActiveRandomCreator", CommonUtils.TableToString3(Infos))
	 --Infos = {
	 --    [1] = {
	 --        UnitId = number,
	 --        RandomRuleId = number,     
	 --        RandomPointIndex = number, 
	 --        RandomTableId = number,
	 --        UniqueId = number,
	 --        UnitType = string,
	 --    },
	 --    [2] = { ... },
	 --    ...
	 --}

	 for _, Info in pairs(Infos) do
		local RegionBaseData = {}
		RegionBaseData.ServerUniqueId = tostring(Info.UniqueId)
		RegionBaseData.UnitId = Info.UnitId
		RegionBaseData.UnitType = Info.UnitType
		RegionBaseData.RandomRuleId = Info.RandomRuleId
		RegionBaseData.RandomTableId = Info.RandomTableId
		RegionBaseData.RandomIdxInRule = Info.RandomPointIndex - 1
		RegionBaseData.ExtraRegionInfo = {}
		if SDRC[self.DungeonId] and SDRC[self.DungeonId][Info.RandomRuleId] and SDRC[self.DungeonId][Info.RandomRuleId][Info.RandomPointIndex] then
			local Data = SDRC[self.DungeonId][Info.RandomRuleId][Info.RandomPointIndex]
			local ActorLoc = Data.ActorLoc
			RegionBaseData.BornLocation = {X = ActorLoc.x, Y = ActorLoc.y, Z = ActorLoc.z}
			RegionBaseData.LevelName = Data.WCLevelName
			-- self.AddRandomCreatorId = self.AddRandomCreatorId + 1
			-- RegionBaseData.RandomCreatorId = 2000000000 + self.AddRandomCreatorId--客户端原版见BP_RandomCreateActor_C:AddRandomCreatorInfo
			self:GetRegionDataMgrSubSystem():InitSSDataFromDungeonServer(RegionBaseData)
		else
			GWorld.logger.error("随机点副本区域数据初始化没有找到RandomCreator！ 已跳过：".. 'DungeonId:' ..self.DungeonId .. ' RandomRuleId:'.. Info.RandomRuleId.. ' RandomIdxInRule:'.. Info.RandomPointIndex)
		end
	 end
end

-- 服务器通知GameMode创建动态刷怪规则
function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerMSCreateMonsters(MonsterInfos)
	DebugPrint("OnNotifyGameModeDungeonEvent_ServerMSCreateMonsters UnitSpawnId:", MonsterInfos.UnitSpawnId, "IsRelation:", MonsterInfos.IsRelation, "OnlyRelation", MonsterInfos.OnlyRelation)
	-- PrintTable(MonsterInfos, 10)
	local MonsterSpawn = self.MonsterSpawnMap:FindRef(MonsterInfos.UnitSpawnId)
	if not MonsterSpawn then
		local UnitIdArray = TArray(0)
		UnitIdArray:Add(MonsterInfos.UnitSpawnId)
		self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Create, UnitIdArray, MonsterInfos.OnlyRelation, false, true)
		MonsterSpawn = self.MonsterSpawnMap:FindRef(MonsterInfos.UnitSpawnId)
    end
	if not MonsterSpawn then
		DebugPrint("Error OnNotifyGameModeDungeonEvent_ServerMSCreateMonsters MonsterSpawn创建失败 UnitSpawnId： ", MonsterInfos.UnitSpawnId)
		return
	end
	local InfoMap = self:ConvertMSInfosToMap(MonsterInfos)
	if MonsterInfos.IsRelation then
		MonsterSpawn:RelationCreateMonstersByServer(InfoMap)
	else
		MonsterSpawn:TriggerCreateMonstersByServer(InfoMap)
	end
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerCreateMonsterSpawn(UnitSpawnIdTable, OnlyRelation)
	local UnitIdArray = TArray(0)
	for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
		UnitIdArray:Add(UnitSpawnId)
	end
	self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Create, UnitIdArray, OnlyRelation, false, true)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerDestroyMonsterSpawn(UnitSpawnIdTable)
	local UnitIdArray = TArray(0)
	for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
		UnitIdArray:Add(UnitSpawnId)
	end
	self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Destroy, UnitIdArray, false, false, true)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerDestroyAllMonsterSpawn(UnitSpawnIdTable, NormalDeath)
	local UnitIdArray = TArray(0)
	for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
		UnitIdArray:Add(UnitSpawnId)
	end
	self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.DestroyAll, UnitIdArray, false, NormalDeath, true)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerPauseMonsterSpawn(UnitSpawnIdTable)
	local UnitIdArray = TArray(0)
	for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
		UnitIdArray:Add(UnitSpawnId)
	end
	self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Pause, UnitIdArray)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerResumeAllMonsterSpawn(UnitSpawnIdTable)
	local UnitIdArray = TArray(0)
	for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
		UnitIdArray:Add(UnitSpawnId)
	end
	self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Resume, UnitIdArray)
end

-- info: {
-- UnitSpawnId = xxx
-- IsRelation = xxx
-- UnitInfos = {UnitId, UniqueIds = {111,222,333}, {UnitId, UniqueIds = {444,555}}
-- }
function DungeonObjectComponent:ConvertMSInfosToMap(MonsterInfos)
	local ServerMonsterInfoMap = TMap(0, FServerMonsterInfo)
	-- local TotalNeedSpawnMonsterInfo = TMap(0, 0)
	for UnitId, UniqueIds in pairs(MonsterInfos.UnitInfos) do
		local ServerMonsterInfo = FServerMonsterInfo()
		-- local Num = 0
		for _, Id in pairs(UniqueIds) do
			ServerMonsterInfo.UniqueIds:Add(Id)
			-- Num = Num + 1
		end
		ServerMonsterInfoMap:Add(UnitId, ServerMonsterInfo)
		-- TotalNeedSpawnMonsterInfo:Add(UnitId, Num)
	end
	return ServerMonsterInfoMap
end

-- 服务器向客户端获取刷怪倍率
function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_GetMultiInfoResFromClient(UnitSpawnId, OnlyRelation)
	DebugPrint("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_GetMultiInfoResFromClient UnitSpawnId:", UnitSpawnId)
	local MonsterSpawn = self.MonsterSpawnMap:FindRef(UnitSpawnId)
	if not MonsterSpawn then
		local UnitIdArray = TArray(0)
		UnitIdArray:Add(UnitSpawnId)
		self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Create, UnitIdArray, OnlyRelation, false, true)
		MonsterSpawn = self.MonsterSpawnMap:FindRef(UnitSpawnId)
    end
	if not MonsterSpawn then
		DebugPrint("Error OnNotifyGameModeDungeonEvent_ServerMSCreateMonsters MonsterSpawn创建失败 UnitSpawnId： ", UnitSpawnId)
		return
	end
	MonsterSpawn:UpdateMultiInfoResToServer(true)
end

-- 客户端通知服务器刷怪倍率更新
function DungeonObjectComponent:NotifyServerMultiInfoResChange(UnitSpawnId, MultiInfoRes)
	DebugPrint("DungeonObjectComponent:NotifyServerMultiInfoResChange UnitSpawnId:", UnitSpawnId, "MultiInfoRes:", MultiInfoRes)
	self:NotifyServerDungeonEvent("MultiInfoResChange", UnitSpawnId, MultiInfoRes)
end


-- 服务器通知GameMode怪物死亡合理 {UnitId = UnitId, UniqueId = UniqueId, Res = true}
function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_MonsterDead(MonsterInfo)
	DebugPrint("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_MonsterDead")
	PrintTable(MonsterInfo, 10)
end

-- 服务器通知GameMode创建掉落物
function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_CreatDrop(DropRes, OtherParams)
	-- 请参考RewardGenComponent 的CreateDrop函数
	DebugPrint("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_CreatDrop")
	PrintTable(DropRes, 10)
	-- Transform (string): 28099.029296875,61513.63671875,5018.283203125|0.0,-0.0,0.90647459030151,0.42226028442383|1.0,1.0,1.0 (string)
	-- DropInfos (string): table: 0x7f44fe5ded40 (table)
	-- 	1 (number): table: 0x7f44fe5ded80 (table)
	-- 		UniqueIds (string): table: 0x7f44fe5dee00 (table)
	-- 			1 (number): 14 (number)
	-- 		DropCountTable (string): table: 0x7f45069eb500 (table)
	-- 			1 (string): 1 (number)
	-- 			2 (string): 0 (number)
	-- 		DropId (string): 40101 (number)
	-- 	2 (number): table: 0x7f44fe5e5100 (table)
	-- 		UniqueIds (string): table: 0x7f44fe5f0880 (table)
	-- 			1 (number): 15 (number)
	-- 		DropCountTable (string): table: 0x7f45069eb580 (table)
	-- 			1 (string): 1 (number)
	-- 			2 (string): 0 (number)
	-- 		DropId (string): 40102 (number)
	-- Reason (string): MonsterDead (string)
	-- ExtraInfo (string): table: 0x7f45067f5e40 (table)
	-- 	bAuthority (string): true (boolean)
	-- 	Level (string): 1 (number)
	-- 	UnitId (string): 7003001 (number)
	-- 	bKilledByPlayer (string): true (boolean)
	-- 	IsSummonMonster (string): false (boolean)
	-- 	SourceEid (string): 1 (number)
	-- 	UniqueSign (string): 197 (number)
	-- 	WeaponType (string): Melee (string)

	local Transform = CommonUtils:UnSerializeFTransform(DropRes.Transform)
    local GameState = self.EMGameState
    local LevelId = self:GetItemLevelId(Transform.Translation)
	OtherParams = OtherParams or {}
    local function CreateDrop(DropId, Count, bExtra, UniqueIds)
        if self.LevelGameMode.DropRule[DropId] then return end
        if IsStandAlone(self) then
            DebugPrint("HandleRewardDrop in DungeonObject", DropId, Count)
            GameState.EventMgr:RealSpawnRewards_Normal_DungeonOServer(DropId, Count, Transform, DropRes.Reason, DropRes.ExtraInfo, bExtra, UniqueIds)
		else
			DebugPrint("CreateDrop For Player", DropId)
			local Avatar = OtherParams.Avatar or ""
			self:PickupToSpecPlayer(DropId, Count, Avatar, DropRes.Reason, Transform, LevelId, bExtra)
			self.bNeedNotifyClientCreateDrop = true
		end
    end

    --周本宝箱分波次生成掉落物
    -- if ExtraInfo and ExtraInfo.MultiWave and self:IsInDungeon() then--没看到调用，先不管
        -- local Mechanism = Battle(self):GetEntity(ExtraInfo.ParentEid)
        -- print(_G.LogTag,"HandleCreateDrop For Player", OtherParams.Avatar)
        -- Mechanism:MultiWaveCreateDrop(Drops, CreateDrop, OtherParams.Avatar)
    -- else
        -- 处理掉落物
        for _, Info in pairs(DropRes.DropInfos) do
            local DropId = tonumber(Info.DropId)
			local DropCountTable = Info.DropCountTable
            -- todo: @SnowMoon 如果真的配出来了复合Tag，那么掉落物需要把bExtra参数改成直接透传Drop的Tag
            local ExtraCount = RewardBox:FindCountByTag(DropCountTable, "Extra")
            if ExtraCount > 0 then
                CreateDrop(DropId, ExtraCount, true, Info.UniqueIds)
            end

            local OtherCount = RewardBox:FindCountByTag(DropCountTable, "Normal")
            if OtherCount > 0 then
                CreateDrop(DropId, OtherCount, false, Info.UniqueIds)
            end
        end
    -- end
end


-----------------------------------------------------------------

-- 通知服务器怪物死亡 {UnitId = UnitId, UniqueId = UniqueId}
function DungeonObjectComponent:NotifyServerMonsterDead(cb, MonsterInfo)
	-- MonsterInfo = {UnitId = UnitId, UniqueId = UniqueId}
	self:NotifyServerDungeonEventWithCallback(cb, "MonsterDead", MonsterInfo)
end

function DungeonObjectComponent:NotifyServerOnInit()
	self:NotifyServerDungeonEvent("OnInit", {})
end

-- 内部测试服务器激活静态点
function DungeonObjectComponent:ServerTriggerActiveStaticCreator(StaticCreatorIds)
	if not UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
		return
	end
	if not self:CheckServerDungeonEnable() then
		return
	end
	local Ids = StaticCreatorIds:ToTable()
	self:NotifyServerDungeonEvent("ServerTriggerActiveStaticCreator", Ids)
end
-----------------------------------------------------------------
-------------------------------机关逻辑----------------------------------
function DungeonObjectComponent:NotifyServerMechanismStateChange(EventInfo)
	-- MonsterInfo = {UnitId = UnitId, UniqueId = UniqueId, StateId = StateId,PlayerId = PlayerId,Type = Type}
	print(_G.LogTag,"LXZ DungeonLogic NotifyServerMechanismStateChange")
	PrintTable(EventInfo, 10)
	self:NotifyServerDungeonEvent("MechanismStateChange", EventInfo)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_MechanismStateChange(EventInfo)
	print(_G.LogTag,"LXZ DungeonLogic OnNotifyGameModeDungeonEvent_MechanismStateChange")
	PrintTable(EventInfo, 10)
	local GameState = UGameplayStatics.GetGameState(self)
	local MechanismObj = GameState.CombatItemUniqueMap:Find(EventInfo.UniqueId)
	if MechanismObj then
		MechanismObj:DungeonServerChangeState(EventInfo)
	end
end

-- 服务端通知掉落机关（怪物死亡掉落容器）- 创建机关Actor
function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerCreateDropMechanism(DropMechanismInfo)
	print("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerCreateDropMechanism")
	PrintTable(DropMechanismInfo, 10)
	
	if not DropMechanismInfo or not DropMechanismInfo.UnitId or not DropMechanismInfo.UniqueId then
		print("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerCreateDropMechanism Invalid DropMechanismInfo")
		return
	end
	
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState or not GameState.EventMgr then
		print("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerCreateDropMechanism GameState or EventMgr is nil")
		return
	end
	
	local TransformStr = DropMechanismInfo.Transform
	
	local Transform = CommonUtils:UnSerializeFTransform(TransformStr)
	if not Transform then
		print("DungeonObjectComponent: Transform反序列化失败")
		return
	end
	
	-- 贴地修正
	local SpawnLoc = CommonUtils.GetFixLocation(self, Transform.Translation, 0, 200, -1500, "TraceScene")
	--print(string.format("DungeonObjectComponent: 贴地修正 Z: %.2f -> %.2f", Transform.Translation.Z, SpawnLoc.Z))
	
	local Context = AEventMgr.CreateUnitContext()
	Context.UnitType = "Mechanism"
	Context.UnitId = DropMechanismInfo.UnitId
	Context.Loc = SpawnLoc
	Context.Rotation = Transform.Rotation:ToRotator()
	Context.NameParams:Add("UniqueId", tostring(DropMechanismInfo.UniqueId))
	
	Context.StrParams:Add("ServerUniqueId", tostring(DropMechanismInfo.UniqueId))
	
	if DropMechanismInfo.MonsterUnitId then
		Context.IntParams:Add("MonsterUnitId", DropMechanismInfo.MonsterUnitId)
	end
	
	-- 创建机关Actor
	print(string.format("DungeonObjectComponent: 创建机关Actor - UnitId(%d), UniqueId(%s), Location(%s, %s, %s)",
		DropMechanismInfo.UnitId,
		tostring(DropMechanismInfo.UniqueId), 
		tostring(SpawnLoc.X), tostring(SpawnLoc.Y), tostring(SpawnLoc.Z)))
	
	GameState.EventMgr:CreateUnitNew(Context, false)
	
	print(string.format("DungeonObjectComponent: 机关创建完成 - UniqueId(%s)", tostring(DropMechanismInfo.UniqueId)))
end
-----------------------------------------------------------------


----------------------------副本事件-----------------------------
-- 服务器下发事件转发到组件
function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_DungeonComponentFun(EventName, ...)
	if not self:CheckServerDungeonEnable() then
		return
	end
	self:TriggerDungeonComponentFun(EventName, ...)
end

-- 通知服务器副本结束（胜利/失败）
function DungeonObjectComponent:NotifyServerGameEnd(IsWin, GameEndReason)
	if not self:CheckServerDungeonEnable() then
		return
	end
	DebugPrint("BP_EMGameMode_C:NotifyServerGameEnd IsWin:", IsWin, " GameEndReason:", GameEndReason)
	self:NotifyServerDungeonEvent("TriggerGameEnd", IsWin, GameEndReason)
end

-- 服务器下发GameMode副本结束 	todo:改成回调函数的形式
function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_OnServerGameEnd(IsWin, GameEndReason)
	if not self:CheckServerDungeonEnable() then
		return
	end
	DebugPrint("BP_EMGameMode_C:OnServerGameEnd IsWin:", IsWin, " GameEndReason:", GameEndReason)
	if IsWin then
		self:TriggerDungeonWin()
	else
		self:TriggerDungeonFailed()
	end
end

-- 由配表触发的服务器事件
function DungeonObjectComponent:TriggerTableDrivenServerEvent(EventID)
	local TableName = self.EMGameState.GameModeType.."ServerEvent"
	if not DataMgr[TableName] then return end
	if not DataMgr[TableName][EventID] then return end

	DebugPrint("BP_EMGameMode_C:TriggerTableDrivenServerEvent   EventID:", EventID)
	self:NotifyServerDungeonEvent("TableDrivenServerEvent", EventID)					-- todo 回调
end

-----------------------------------------------------------------


return DungeonObjectComponent

