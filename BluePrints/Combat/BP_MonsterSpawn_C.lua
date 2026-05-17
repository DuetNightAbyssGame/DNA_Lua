--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

--require "LocalPrint"
local BP_MonsterSpawn_C = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.Combat.Components.MonsterSpawnComponent",
	"BluePrints.Common.DelayFrameComponent"
})

-- function BP_MonsterSpawn_C:ReceiveBeginPlay()
-- 	-- self.UnitSpawnId = -99
-- 	-- self.GameState = UE4.UGameplayStatics.GetGameState(self)
-- 	-- self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- end

-- function BP_MonsterSpawn_C:InitMonsterSpawn(UnitSpawnId, OnlyRelation)
-- 	self.UnitSpawnId = UnitSpawnId
-- 	self.OnlyRelation = OnlyRelation
-- 	self.Data = DataMgr.MonsterSpawn[UnitSpawnId]
-- 	-- self.InitSuccess = false
-- 	if not self.Data then 
-- 		return
-- 	end

-- 	self.Locations = {}
-- 	self.LocationIndex = 0
-- 	self.MonsterSpawnInfo = {}   -- 实时的怪物信息 {Unid:  Num}  改为 {Unitid: {Eid,EId}}

-- 	if self.OnlyRelation then 
-- 		self:InitRelationSpawn()
-- 		self:AddTimerToDestory()
-- 		self.InitSuccess = true
-- 		return
-- 	end

-- 	self:InitRelationSpawn()
-- 	if self.Data.DetectTime then
-- 		self.RealDetectTime = self.Data.DetectTime or 3
-- 		-- TotalNum 是需要刷怪的总数，AliveNum是剩余存活的怪物总数，AliveNum目的是为了恢复关卡加载引起的数量误差
		
-- 		self.UnitSpawnTotalNum = self.Data.UnitSpawnTotalNum
-- 		self.UnitSpawnAliveNum = self.UnitSpawnTotalNum
-- 		self.UnitSpawningNum = 0  -- 生成过程中的怪，用于处理 异步刷怪时N帧卡住重复刷的问题

-- 		self.MonsterSpawnInitInfo = {}  	-- 初始的怪物数量信息
-- 		self.MonsterSpawnInitInfoFix = {}   -- 经过修正的怪物数量信息
-- 		self.MonsterSpawnInitInfoLevel = {}
		
-- 		self.DetectTimeFlag = 0
-- 		self:InitMonsterSpawnInfo()
		
-- 		self:SetLifeTime()
-- 		self:AddTimer(self.RealDetectTime, self.DetectMonsterSpawnInfo, true, 0, "MonsterSpawnTimeHandle")
-- 	else
-- 		self:AddTimerToDestory()
-- 		return
-- 	end
-- 	self.InitSuccess = true
-- end	

-- function BP_MonsterSpawn_C:InitMonsterSpawnInfo()
-- 	for _, Info in pairs(self.Data["MonsterSpawnInfos"]) do
-- 		self.MonsterSpawnInfo[Info.UnitId] = {}
-- 		self.MonsterSpawnInitInfo[Info.UnitId] = Info.UnitNum
-- 		self.MonsterSpawnInitInfoFix[Info.UnitId] = Info.UnitNumFix
-- 		self.MonsterSpawnInitInfoLevel[Info.UnitId] = Info.UnitLevel
-- 	end
-- 	self:TriggerCreateMonsters()
-- end

-- 需要在lua中初始化一份Data
-- function BP_MonsterSpawn_C:InitMonsterSpawn(UnitSpawnId, OnlyRelation)
-- 	self.Data = DataMgr.MonsterSpawn[UnitSpawnId]
-- 	if not self.Data then 
-- 		return
-- 	end
-- 	self:InitMonsterSpawn_CPP(UnitSpawnId, OnlyRelation)
-- end

-- function BP_MonsterSpawn_C:TriggerCreateMonsters()
-- 	-- GetLocations无法迁移C++，所以本函数也无法迁移
-- 	if not self:DetectMonsterSpawnTotalNum() then
-- 		DebugPrint("BP_MonsterSpawn_C 刷怪数量已达上限，但当前规则还存留怪物在场，MonsterSpawnId:", self.UnitSpawnId)
-- 		return
-- 	end
-- 	-- 获取刷怪的基本信息
-- 	local DistributedInfo = self:GetCreateMonstersBaseInfo()
-- 	-- 获取刷怪的全部位置
-- 	local TotalSpawnLocs = self:GetLocations(DistributedInfo)
-- 	-- 对每个预设目标开始刷怪
-- 	for PresetTarget, TargetNeedSpawnInfo in pairs(DistributedInfo) do
-- 		-- 获取刷怪的位置
-- 		self.Locations = TotalSpawnLocs[PresetTarget]
-- 		self.LocationIndex = 0
-- 		self:TryCreateMonsters(PresetTarget, TargetNeedSpawnInfo, "Main", PresetTarget.Eid)
-- 	end
-- end

-- function BP_MonsterSpawn_C:GetCreateMonstersBaseInfo()
-- 	-- local TotalNeedSpawnMonsterInfo = {}
-- 	-- local RealMonsterSpawnInitInfo = self:GetRealMonsterSpawnInfo()
-- 	-- local TotalNeedNum, FirstTotalNum = self:GetCreateMonsterTotalNeedNum(RealMonsterSpawnInitInfo)

-- 	-- local NextTriggeredCreate = self.TriggeredCreate
-- 	-- for UnitId, Infos in pairs(self.MonsterSpawnInfo) do
-- 	-- 	local NowNum, ExpectedNum = Infos:Num(), RealMonsterSpawnInitInfo:FindRef(UnitId)

-- 	-- 	if NowNum < ExpectedNum then
-- 	-- 		if self.Data.FirstPercentFix == nil or self.TriggeredCreate == true then
-- 	-- 			TotalNeedSpawnMonsterInfo[UnitId] = ExpectedNum - NowNum
-- 	-- 		else
-- 	-- 			TotalNeedSpawnMonsterInfo[UnitId] = math.ceil((ExpectedNum - NowNum) / TotalNeedNum * FirstTotalNum)
-- 	-- 			NextTriggeredCreate = true
-- 	-- 		end
-- 	-- 	end
-- 	-- end
-- 	-- self.TriggeredCreate = NextTriggeredCreate
-- 	local TotalNeedSpawnMonsterInfo = self:GetCreateMonstersBaseInfo_CPP()
-- 	local PresetTargets = self:GetPresetTarget() 
-- 	DebugPrint("BP_MonsterSpawn_C    MonsterSpawnId:"..self.UnitSpawnId.."  找到预设目标数量:   " .. PresetTargets:Num())	
-- 	local DistributedInfo = self:DistributedMonster(PresetTargets:ToTable(), TotalNeedSpawnMonsterInfo:ToTable(), self:GetSpawnTypeIsBalance())
-- 	if IsEmptyTable(DistributedInfo) then
-- 		DebugPrint("BP_MonsterSpawn_C  没有找到预设目标，所有没有合适点位  MonsterSpawnId:", self.UnitSpawnId)
-- 	end
-- 	return DistributedInfo -- {actor : {UnitId:Num}}
-- end

-- function BP_MonsterSpawn_C:TryCreateMonsters(PresetTarget, TargetNeedSpawnInfo, SourceType)
-- 	if #self.Locations == 0 then
-- 		DebugPrint("BP_MonsterSpawn_C No Locations MonsterSpawnId:"..self.UnitSpawnId.."  PresetTargetEid:" .. PresetTarget.Eid.."   self.Locations:0    " .. "FromTacMap:"..tostring(self.Data.Tacmap))
-- 		return
-- 	end
-- 	for UnitId, Num in pairs(TargetNeedSpawnInfo) do
-- 		DebugPrint("BP_MonsterSpawn_C TryCreateMonsters         MonsterSpawnId:"..self.UnitSpawnId.."  PresetTargetEid:" .. PresetTarget.Eid.."   UnitId:" ..UnitId.."   Num:"..Num.."    SourceType:"..SourceType)
-- 		self:RealCreateUnits(UnitId, Num, PresetTarget, SourceType)
-- 	end
-- end

-- 2025.7.4 性能优化迭代，不在同一帧触发生成，把UnitSpawningNum和RelationSpawningNum总数放到最前面加
-- function BP_MonsterSpawn_C:RealCreateUnits(UnitId, UnitNum, PresetTarget, SourceType, Level)
-- 	if self.GameMode.EMGameState.GameModeType == "Abyss" then
-- 		local MonsterMaxLevel = DataMgr.GlobalConstant.MonsterLevelUpperLimit.ConstantValue
-- 		Level = math.min(Level, MonsterMaxLevel)
-- 	end

-- 	-- local MonsterLevel = self:GetMonsterLevel(UnitId, SourceType)
-- 	DebugPrint("RealCreateUnits CreateUnitNew UnitId:", UnitId, "UnitNum:", UnitNum)
-- 	local FrameCount = UE4.UKismetSystemLibrary.GetFrameCount()
-- 	-- 同一帧进来的进行分帧计算
-- 	if self.PreFrameCount ~= FrameCount then
-- 		self.DelayFrameStartCount = 1
-- 		self.PreFrameCount = FrameCount
-- 	end
-- 	for i = 1, UnitNum do
-- 		self:AddDelayFrameFunc(
-- 			function()
-- 				if SourceType == "Main" then 
-- 					self.RemainUnitNum = self.RemainUnitNum - 1
-- 				else
-- 					self.RemainRelationUnitNum = self.RemainRelationUnitNum - 1
-- 				end
-- 				if SourceType == "Main" and not self:DetectMonsterSpawnTotalNum() then
-- 					DebugPrint("BP_MonsterSpawn_C 刷怪过程中数量已达上限, 直接返回  MonsterSpawnId:", self.UnitSpawnId)
-- 					return
-- 				end
-- 				local Location = nil
-- 				if SourceType == "Main" then 
-- 					if self.Locations:Num() == 0 then
-- 						DebugPrint("Error: BP_MonsterSpawn_C No Locations MonsterSpawnId:", self.UnitSpawnId)
-- 						return
-- 					end
-- 					Location = self.Locations[self.LocationIndex % self.Locations:Num() + 1]
-- 					self.LocationIndex = self.LocationIndex + 1
-- 				else
-- 					if self.RelationLocations:Num() == 0 then
-- 						DebugPrint("Error: BP_MonsterSpawn_C No RelationLocations MonsterSpawnId:", self.UnitSpawnId)
-- 						return
-- 					end
-- 					Location = self.RelationLocations[self.RelationLocationIndex % self.RelationLocations:Num() + 1]
-- 					self.RelationLocationIndex = self.RelationLocationIndex + 1
-- 				end
-- 				-- Location = UE.UNavigationFunctionLibrary.GetGroundPos(self, Location) -- 贴地
-- 				local Context = AEventMgr.CreateUnitContext()
-- 				Context.UnitType = "Monster"
-- 				Context.UnitId = UnitId
-- 				Context.Loc = Location
-- 				Context.MonsterSpawn = self
-- 				Context.BoolParams:Add("RelationSpawn", (SourceType == "Relation"))
-- 				Context.IntParams:Add("Level", Level)
-- 				Context:AddObjectParams("PresetTarget", PresetTarget)
-- 				self:DebugPrintMonsterSpawn("RealCreateUnits CreateUnitNew UnitId: "..UnitId.." Level: "..Level)
-- 				self.GameState.EventMgr:CreateUnitNew(Context, false)
-- 				if SourceType == "Main" then 
-- 					self:UpdateMonsterSpawnTotalNum(-1)-- 总数减1
-- 					self.UnitSpawningNum = self.UnitSpawningNum + 1 --SpawningNum + 1
-- 				else
-- 					self.RelationSpawningNum = self.RelationSpawningNum + 1
-- 				end
-- 			end, self.DelayFrameStartCount)
-- 		self.DelayFrameStartCount = self.DelayFrameStartCount + 1
-- 	end
-- end

-- 已废弃
-- function BP_MonsterSpawn_C:RealCreateUnits(UnitId, UnitNum, PresetTarget, SourceType, Level)
-- 	-- local MonsterLevel = self:GetMonsterLevel(UnitId, SourceType)
-- 	DebugPrint("RealCreateUnits CreateUnitNew UnitId:", UnitId, "UnitNum:", UnitNum)
-- 	for i = 1, UnitNum do
-- 		if SourceType == "Main" and not self:DetectMonsterSpawnTotalNum() then
-- 			DebugPrint("BP_MonsterSpawn_C 刷怪过程中数量已达上限, 直接返回  MonsterSpawnId:", self.UnitSpawnId)
-- 			return
-- 		end
-- 		local Location = self.Locations[self.LocationIndex % self.Locations:Num() + 1]
-- 		-- Location = UE.UNavigationFunctionLibrary.GetGroundPos(self, Location) -- 贴地
-- 		self.LocationIndex = self.LocationIndex + 1
-- 		local Context = AEventMgr.CreateUnitContext()
-- 		Context.UnitType = "Monster"
-- 		Context.UnitId = UnitId
-- 		Context.Loc = Location
-- 		Context.MonsterSpawn = self
-- 		Context.BoolParams:Add("RelationSpawn", (SourceType == "Relation"))
-- 		Context.IntParams:Add("Level", Level)
-- 		Context:AddObjectParams("PresetTarget", PresetTarget)
-- 		self.GameState.EventMgr:CreateUnitNew(Context, false)
-- 		if SourceType == "Main" then 
-- 			self:UpdateMonsterSpawnTotalNum(-1)-- 总数减1
-- 			self.UnitSpawningNum = self.UnitSpawningNum + 1 --SpawningNum +1 
-- 		else
-- 			self.RelationSpawningNum = self.RelationSpawningNum + 1
-- 		end
-- 	end
-- end

function BP_MonsterSpawn_C:CheckDungeonReachable(LevelLoader, PresetTarget, SpawnPointInfo)
	-- 本函数仅在拼接关生效，肉鸽无门，LevelId2Doors为空
	if not LevelLoader.LevelId2Doors then
		local IsHasPath = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(SpawnPointInfo.Loc, PresetTarget:K2_GetActorLocation(),self.GameMode)
		return IsHasPath
	end
	local LevelId = LevelLoader:GetLevelIdByLocation(PresetTarget:K2_GetActorLocation())
	local LevelReachable = false
	for DoorIndex, BPArrow in pairs(LevelLoader.LevelId2Doors[LevelId]) do
		local IsHasPath = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(SpawnPointInfo.Loc, BPArrow:K2_GetActorLocation(),self.GameMode)
		if IsHasPath == UE4.EPathConnectType.HasPath then
			LevelReachable = true
			break
		end
	end
	return LevelReachable
end

function BP_MonsterSpawn_C:GetAroundDivisionInfos(Loc)
	return self.GameMode:GetAroundDivisionInfos(Loc)
end


function BP_MonsterSpawn_C:AddHostageInfo(Res)
	local HostageEid = self.GameMode:TriggerDungeonComponentFun("GetHostageEid")
	if HostageEid == nil then
		DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质，但不应该在非捕获玩法使用  MonsterSpawnId:", self.UnitSpawnId)
		self:AddPlayerInfo(Res)
		return
	end
	local Hostage = Battle(self):Getentity(HostageEid)
	if not IsValid(Hostage) then
		DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质，人质不存在  MonsterSpawnId:", self.UnitSpawnId)
		self:AddPlayerInfo(Res)
		return
	end
	DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质  MonsterSpawnId:", self.UnitSpawnId, "人质Eid:", HostageEid)
	Res:Add(Hostage)
end


function BP_MonsterSpawn_C:DebugPrintMonsterSpawn(Info)
	if self.GameMode.DebugPrintMonsterSpawn then
		DebugPrint("WARNING:  "..Info)
	end
end


-- function BP_MonsterSpawn_C:GetLocations(DistributedInfo)
-- 	-- GetTacmapLocations无法迁移C++，所以本函数也无法迁移
-- 	if self.Data.Tacmap then 
-- 		local TacmapSpawnInfo = self:GetTacmapSpawnInfo(DistributedInfo)
-- 		self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  使用TacMap查找预设目标周围的点位   MonsterSpawnId:"..self.UnitSpawnId)
-- 		return self:GetTacmapLocations(TacmapSpawnInfo)
-- 	else
-- 		local Res = {}
-- 		for PresetTarget, TargetNeedSpawnInfo in pairs(DistributedInfo) do
-- 			Res[PresetTarget] = self:GetSpawnPointLocations(PresetTarget, self:GetCheckInfo())
-- 		end
-- 		return Res
-- 	end
-- end

-- function BP_MonsterSpawn_C:GetTacmapLocations(TacmapSpawnInfo)
-- 	-- GetSpawnPoints在lua中，无法迁移C++
-- 	return self.GameMode.TacMapManager:GetSpawnPoints({
-- 		PresetTargets = TacmapSpawnInfo,
-- 		Mode = self.Data.Mode,
-- 		UnitSpawnRadiusMin = self.Data.UnitSpawnRadiusMin,
-- 		UnitSpawnRadiusMax = self.Data.UnitSpawnRadiusMax,
-- 		RandomSpawn = self.Data.RandomSpawn,
-- 		FilterReachable = self.Data.FilterReachable,
-- 	})
-- end


-- CheckInfo: UnitSpawnRadiusMin, RandomSpawn, UnitSpawnRadiusMax, FilterReachable
-- function BP_MonsterSpawn_C:GetSpawnPointLocations(PresetTarget, CheckInfo)
-- 	-- if not IsValid(PresetTarget) then 
-- 	-- 	DebugPrint("BP_MonsterSpawn_C  没有找到预设目标，所有没有合适点位")
-- 	-- 	return {}
-- 	-- end

-- 	-- -- Array of table {Distance, Location}
-- 	-- local SpawnPoints, PersetLoc = {}, PresetTarget:K2_GetActorLocation()
-- 	-- self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  开始过滤预设目标周围的点位 ====================================================  MonsterSpawnId:", self.UnitSpawnId)
-- 	-- for SpawnIndex, SpawnPointInfo in pairs(self.GameMode:GetAroundDivisionInfos(PersetLoc)) do
-- 	-- 	self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  开始过滤预设目标周围的点位，当前点位Index :"..SpawnIndex)
-- 	-- 	local LevelLoader = self.GameMode:GetLevelLoader()
-- 	-- 	if self:CheckPointEnable(SpawnPointInfo, LevelLoader) then
-- 	-- 		local SpawnDis = UE4.UKismetMathLibrary.Vector_Distance(SpawnPointInfo.Loc, PersetLoc)
-- 	-- 		if self:CheckSpawnPointIsValidOrNot(SpawnDis, SpawnPointInfo, PresetTarget, LevelLoader, CheckInfo) then
-- 	-- 			self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  当前点位检测通过，点位Index :"..SpawnIndex)
-- 	-- 			table.insert(SpawnPoints, {[1] = SpawnDis, [2] =  SpawnPointInfo.Loc})
-- 	-- 		end
-- 	-- 	end
-- 	-- end
-- 	-- self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  结束过滤预设目标周围的点位 ====================================================  MonsterSpawnId:", self.UnitSpawnId)
-- 	-- self:DebugPrintMonsterSpawn("																									 ")
-- 	-- self:DebugPrintMonsterSpawn("																									 ")
-- 	local SpawnPoints = {}
	-- for SpawnDis, Loc in pairs(self:GetSpawnPointLocations_CPP(PresetTarget, CheckInfo)) do
	-- 	table.insert(SpawnPoints, {[1] = SpawnDis, [2] =  FVector(Loc.X, Loc.Y, Loc.Z)})
	-- end
	-- -- 打乱数据，进行随机
	-- if CheckInfo.RandomSpawn then
	-- 	for i = #SpawnPoints, 2, -1 do
	-- 		local j = math.random(i)
	-- 		SpawnPoints[i], SpawnPoints[j] = SpawnPoints[j], SpawnPoints[i]
	-- 	end
	-- else
	-- table.sort(SpawnPoints, function (t1, t2)
		-- if not t1[1] then
		-- 	return false
		-- end

		-- if not t2[1] then
		-- 	return false
		-- end

		-- return t1[1] < t2[1]
		-- end)
	-- end
-- 	local Locations = {}
-- 	for _, SpawnPoints in ipairs(SpawnPoints) do 
-- 		table.insert(Locations, SpawnPoints[2])
-- 	end
-- 	return Locations
-- end

-- function BP_MonsterSpawn_C:GetTacmapSpawnInfo(DistributedInfo)
-- 	local Res = {}
-- 	for PresetTarget, NeedSpawnMonster in pairs(DistributedInfo) do
-- 		Res[PresetTarget] = 0
-- 		for UnitId, UnitNum in pairs(NeedSpawnMonster) do 
-- 			Res[PresetTarget] = Res[PresetTarget] + UnitNum
-- 		end
-- 	end
-- 	return Res
-- end


-- CheckInfo: UnitSpawnRadiusMin, RandomSpawn, UnitSpawnRadiusMax, FilterReachable
-- function BP_MonsterSpawn_C:GetCheckInfo()
-- 	local CheckInfo = {}
-- 	CheckInfo.UnitSpawnRadiusMin = self.Data.UnitSpawnRadiusMin
-- 	CheckInfo.RandomSpawn = self.Data.RandomSpawn
-- 	CheckInfo.UnitSpawnRadiusMax = self.Data.UnitSpawnRadiusMax
-- 	CheckInfo.FilterReachable =self.Data.FilterReachable
-- 	return CheckInfo
-- end

-- function BP_MonsterSpawn_C:GetCreateMonsterTotalNeedNum(RealMonsterSpawnInitInfo)
-- 	if self.Data.FirstPercentFix == nil or self.TriggeredCreate == true then
-- 		return nil, nil
-- 	end
-- 	local TotalNeedNum = 0
-- 	for UnitId, Infos in pairs(self.MonsterSpawnInfo) do
-- 		local NowNum, ExpectedNum = Infos:Num(), RealMonsterSpawnInitInfo:FindRef(UnitId)
-- 		if NowNum < ExpectedNum then
-- 			TotalNeedNum = TotalNeedNum + ExpectedNum - NowNum
-- 		end
-- 	end
-- 	return TotalNeedNum, math.ceil(TotalNeedNum * self.Data.FirstPercentFix / 100)
-- end

-- function BP_MonsterSpawn_C:CheckPointEnable(SpawnPointInfo, LevelLoader)
-- 	if self.GameMode.DebugMonsterSpawn then
-- 		return true
-- 	end

-- 	if not IsValid(LevelLoader) then 
-- 		return true 
-- 	end

-- 	local LevelName = nil
-- 	if self.GameMode:IsInDungeon() then
-- 		LevelName = LevelLoader:GetLevelIdByLocation(SpawnPointInfo.Loc)
-- 		if self.GameMode.SubGameModeInfo:Keys():Find(LevelName) == 0 then
-- 			self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：所处levelname找不到    LevelName:"..tostring(LevelName).."  MonsterSpawnId:" ..self.UnitSpawnId)
-- 			return false
-- 		end
-- 		if not self.GameMode.SubGameModeInfo:Find(LevelName).IsActive then
-- 			self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：所处level未激活    LevelName:"..tostring(LevelName).."  MonsterSpawnId:" ..self.UnitSpawnId)
-- 			return false
-- 		end
-- 	else
-- 		LevelName = SpawnPointInfo.WCLevelName
-- 		if not self.GameMode:GetWCSubSystem() then 
-- 			self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  区域内找不到wc system  MonsterSpawnId:", self.UnitSpawnId)
-- 			return false
-- 		end
-- 		if not self.GameMode:GetWCSubSystem():IsLevelLoadedByName(LevelName) then
-- 			self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  区域内此 LevelName 未加载  LevelName:"..tostring(LevelName).."  MonsterSpawnId:" ..self.UnitSpawnId)
-- 			return false
-- 		end
-- 	end
-- 	return true
-- end

-- function BP_MonsterSpawn_C:CheckVisionEnable(SpawnDis, SpawnPointInfo)
-- 	if self.GameMode.DebugMonsterSpawn then
-- 		return true
-- 	end
-- 	if SpawnDis >= 3000 then return true end

-- 	for i, Player in pairs(self.GameMode:GetAllPlayer()) do
-- 		local HitResult = FHitResult()

-- 		local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, SpawnPointInfo.Loc, Player:K2_GetActorLocation(),
-- 			ETraceTypeQuery.TraceEnemyVision, false, nil, 0, HitResult, true)

-- 		if bHit and IsValid(HitResult.Actor) and HitResult.Actor.Eid == Player.Eid then 
-- 			return false 
-- 		end
-- 	end
-- 	return true
-- end

-- function BP_MonsterSpawn_C:CheckSpawnPointIsValidOrNot(SpawnDis, SpawnPointInfo, PresetTarget, LevelLoader, CheckInfo)
-- 	if self.GameMode.DebugMonsterSpawn then
-- 		return true
-- 	end
-- 	if SpawnDis < CheckInfo.UnitSpawnRadiusMin then 
-- 		self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：距离小于导表数据最小刷怪范围   Dis:"..SpawnDis.."  UnitSpawnRadiusMin:"..CheckInfo.UnitSpawnRadiusMin.."  MonsterSpawnId:" ..self.UnitSpawnId)
-- 		return false 
-- 	end
-- 	if CheckInfo.RandomSpawn == true and SpawnDis > CheckInfo.UnitSpawnRadiusMax then 
-- 		self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：距离大于导表数据最大刷怪范围（此规则只有RandomSpawn为true生效）   Dis:"..SpawnDis.."  UnitSpawnRadiusMax:"..CheckInfo.UnitSpawnRadiusMax.."  MonsterSpawnId:" ..self.UnitSpawnId)
-- 		return false 
-- 	end
-- 	if self:CheckVisionEnable(SpawnDis, SpawnPointInfo) == false then 
-- 		self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：打射线检测视野失败  MonsterSpawnId:", self.UnitSpawnId)
-- 		return false 
-- 	end
-- 	if CheckInfo.FilterReachable == true then
-- 		if self.GameMode:IsInDungeon() then
-- 			if not IsValid(LevelLoader) then 
-- 				self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：导航可达性只在拼接本生效，当前环境下找不到LevelLoader  MonsterSpawnId:", self.UnitSpawnId)
-- 				return false 
-- 			end
-- 			local LevelId = LevelLoader:GetLevelIdByLocation(PresetTarget:K2_GetActorLocation())
-- 			local LevelReachable = false
-- 			for DoorIndex, BPArrow in pairs(LevelLoader.LevelId2Doors[LevelId]) do
-- 				local IsHasPath = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(SpawnPointInfo.Loc, BPArrow:K2_GetActorLocation(),self.GameMode)
-- 				if IsHasPath == UE4.EPathConnectType.HasPath then
-- 					LevelReachable = true
-- 					break
-- 				end
-- 			end
-- 			if LevelReachable == false then
-- 				self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：导航可达性 检测失败  MonsterSpawnId:", self.UnitSpawnId)
-- 				return false
-- 			end
-- 		end
-- 		if self.GameMode:IsInRegion() then
-- 			-- 后续添加判断七天神像是否可达
-- 			return true
-- 		end
-- 	end
-- 	return true
-- end


-- function BP_MonsterSpawn_C:TriggerMonsterDead(Monster)
-- 	if not IsValid(Monster) then 
-- 		return 
-- 	end
-- 	if self.MonsterSpawnInfo[Monster.UnitId] == nil then
-- 		return
-- 	end
-- 	self:ReduceMonsterSpawnInfo(Monster)
-- 	self:UpdateMonsterSpawnAliveNum(-1)
-- end


-- function BP_MonsterSpawn_C:AddMonsterSpawnInfo(Monster)
-- 	if not IsValid(Monster) then return end
-- 	if Monster.RelationSpawn then 
-- 		return
-- 	end
-- 	table.insert(self.MonsterSpawnInfo[Monster.UnitId], Monster.Eid)
-- 	self.UnitSpawningNum = self.UnitSpawningNum - 1
-- end

-- function BP_MonsterSpawn_C:ReduceMonsterSpawnInfo(Monster)
-- 	local i = 1
--     while i <= #self.MonsterSpawnInfo[Monster.UnitId] do
--        	if self.MonsterSpawnInfo[Monster.UnitId][i] == Monster.Eid then
--            table.remove(self.MonsterSpawnInfo[Monster.UnitId], i)
--            return
--        	else
--            i = i + 1
--        	end
--     end
-- end

-- function BP_MonsterSpawn_C:UpdateMonsterSpawnInfo()
-- 	for UnitId, Infos in pairs(self.MonsterSpawnInfo) do
-- 		self:UpdateMonsterSpawnInfoByUnitId(UnitId)
-- 	end
-- end

-- function BP_MonsterSpawn_C:UpdateMonsterSpawnInfoByUnitId(UnitId)
-- 	local i = 1
-- 	while i <= #self.MonsterSpawnInfo[UnitId] do
-- 		if not IsValid(Battle(self):GetEntity(self.MonsterSpawnInfo[UnitId][i])) then
-- 			table.remove(self.MonsterSpawnInfo[UnitId], i)
-- 			self:UpdateMonsterSpawnTotalNum(1)
-- 		else
-- 			i = i + 1
-- 		end
-- 	end
-- end

-- function BP_MonsterSpawn_C:DetectMonsterSpawnTotalNum()
-- 	if self.UnitSpawnTotalNum == nil or self.UnitSpawnTotalNum > 0 then 
-- 		return true
-- 	end
-- 	return false
-- end

-- function BP_MonsterSpawn_C:UpdateMonsterSpawnTotalNum(Count)
-- 	if self.UnitSpawnTotalNum == nil then 
-- 		return
-- 	end
-- 	self.UnitSpawnTotalNum = self.UnitSpawnTotalNum + Count
-- 	--DebugPrint("BP_MonsterSpawn_C 刷怪总数更新: ", self.UnitSpawnTotalNum, "MonsterSpawnId:", self.UnitSpawnId)
-- end

-- function BP_MonsterSpawn_C:UpdateMonsterSpawnAliveNum(Count)
-- 	if self.UnitSpawnAliveNum == nil then 
-- 		return
-- 	end
-- 	self.UnitSpawnAliveNum = self.UnitSpawnAliveNum + Count
-- 	if self.UnitSpawnAliveNum <= 0 then 
-- 		self:TriggerDestory()
-- 	end
-- end

-- function BP_MonsterSpawn_C:GetMonsterSpawnInfoTotalNum()
-- 	local Res = 0
-- 	for UnitId, Infos in pairs(self.MonsterSpawnInfo) do
-- 		Res = Res + #Infos
-- 	end
-- 	return Res
-- end

-- function BP_MonsterSpawn_C:GetMonsterSpawnInfoAllEid()
-- 	-- 获取当前规则刷出的所有动态怪
-- 	local Res = {}
-- 	for UnitId, Infos in pairs(self.MonsterSpawnInfo) do
--         for i, Eid in pairs(Infos) do
--         	table.insert(Res, Eid)
--         end
-- 	end
-- 	return Res
-- end

-- function BP_MonsterSpawn_C:ClearMonsterSpawnInfo(NormalDeath)
-- 	-- 销毁当前规则刷出的所有动态怪
-- 	for i, Eid in pairs(self:GetMonsterSpawnInfoAllEid()) do
-- 		local Monster = Battle(self):GetEntity(Eid)
-- 		if not Monster:IsDead() then

-- 			-- 正常死亡
-- 			if NormalDeath == true then
-- 				Battle(self):BattleOnDead(Monster.Eid, Monster.Eid, 0, EDeathReason.SpawnerClear)

-- 			-- 非正常死亡
-- 			else
-- 				Monster:EMActorDestroy(EDestroyReason.SpawnerClear)
-- 			end
-- 		end
-- 	end
-- end

-- function BP_MonsterSpawn_C:GetMonsterThreshold()
-- 	local TmpThreshold = self.Data.Threshold * self:GetMultiInfoRes()
-- 	if self.Data.FirstPercentFix == nil or self.TriggeredThreshold == true then
-- 		return TmpThreshold
-- 	end
-- 	return math.ceil(TmpThreshold * self.Data.FirstPercentFix / 100)
-- end

-- function BP_MonsterSpawn_C:DetectMonsterThreshold()
-- 	local UnitNum = self:GetMonsterSpawnInfoTotalNum()
-- 	local TmpThreshold = self:GetMonsterThreshold()

-- 	DebugPrint("BP_MonsterSpawn_C DetectMonsterThreshold  MonsterSpawnId:"..self.UnitSpawnId.."  NowNum:" .. UnitNum.."         NowThreshold:" ..TmpThreshold)
-- 	for i,j in pairs(self.MonsterSpawnInfo) do
-- 		self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  当前MonsterSpawnId :  "..self.UnitSpawnId.."==============")
-- 		for k,v in pairs(j) do
-- 			self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn   当前怪物UnitId:"..i.."  当前存活怪物Eid:  "..v)
-- 		end
-- 	end
-- 	if UnitNum < TmpThreshold then 
-- 		self:TriggerCreateMonsters()
-- 		self.TriggeredThreshold = true
-- 	end
-- 	if UnitNum <= (TmpThreshold / 2) then 
-- 		return 1
-- 	end
-- 	return -1
-- end

-- function BP_MonsterSpawn_C:DetectMonsterSpawnInfo()
-- 	if self.UnitSpawningNum > 0 then 
-- 		return
-- 	end
-- 	local Res = self:DetectMonsterThreshold()
-- 	self:UpdateDetectFix(Res)
-- end

-- function BP_MonsterSpawn_C:UpdateDetectFix(Res)
-- 	local ClearFlag = false
-- 	self.DetectTimeFlag = math.min(math.max(0, self.DetectTimeFlag + Res), 2)
-- 	if self.DetectTimeFlag == 2 and self.RealDetectTime ~= self.Data.DetectTime + self.Data.DetectTimeFix then 
-- 		self.RealDetectTime = self.Data.DetectTimeFix or 3
-- 		ClearFlag = true
-- 	elseif self.DetectTimeFlag == 0 and self.RealDetectTime ~= self.Data.DetectTime then
-- 		self.RealDetectTime = self.Data.DetectTime or 3
-- 		ClearFlag = true
-- 	end
-- 	if ClearFlag then
-- 		self:AddTimer(self.RealDetectTime, self.DetectMonsterSpawnInfo, true, 0, "MonsterSpawnTimeHandle")
-- 	end
-- end

-- function BP_MonsterSpawn_C:SetLifeTime()
-- 	if self.Data.UnitSpawnLife == nil or self.Data.UnitSpawnLife <= 0 then 
-- 		return
-- 	end
-- 	self:AddTimer(self.Data.UnitSpawnLife, self.TriggerDestory, false, 0)
-- end

-- function BP_MonsterSpawn_C:AddTimerToDestory()
-- 	self:AddTimer(30, self.TriggerDestory, false, 0)
-- end

-- function BP_MonsterSpawn_C:TriggerDestory_lua()
-- 	if IsValid(self.GameMode.MonsterSpawnMap:Find(self.UnitSpawnId)) then
-- 		self.GameMode.MonsterSpawnMap:Remove(self.UnitSpawnId)
-- 	end
-- 	self:K2_DestroyActor()
-- end

-- function BP_MonsterSpawn_C:IsOnlyRelationMonsterSpawn()
-- 	return self.OnlyRelation
-- end

-- function BP_MonsterSpawn_C:IsMainMonsterSpawn()
-- 	return not self.OnlyRelation
-- end

-- function BP_MonsterSpawn_C:GetMonsterSpawnFixLevel(UnitId, SourceType)
-- 	if SourceType == "Main" then
-- 		return self.MonsterSpawnInitInfoLevel[UnitId]
-- 	else
-- 		return self.RelationSpawnLevel or 0
-- 	end
-- end

-- function BP_MonsterSpawn_C:GetRealMonsterSpawnInfo()
-- 	local MultiPara = self:GetMultiInfoRes()
-- 	local RefInfo = {}
-- 	if self.DetectTimeFlag == 2 then
-- 		RefInfo = self.MonsterSpawnInitInfoFix
-- 	else
-- 		RefInfo = self.MonsterSpawnInitInfo
-- 	end

-- 	if MultiPara == 1 then 
-- 		return RefInfo 
-- 	end
-- 	local Res = {}
-- 	for i,j in pairs(RefInfo) do 
-- 		Res[i] = math.ceil(j * MultiPara)
-- 	end
-- 	return Res
-- end

-- function BP_MonsterSpawn_C:GetSpawnTypeIsBalance()
-- 	return self.Data.SpawnType == "Balance"
-- end

-- function BP_MonsterSpawn_C:GetMultiInfoRes()
-- 	-- 获取多目标适配最后的变化结果
-- 	if not self.Data.MultiPara then
-- 		return 1
-- 	end
-- 	local MultiTargets  = self:GetMultiInfo()
-- 	local Res = self.Data.MultiPara[#MultiTargets] or 1
-- 	return Res
-- end

-- function BP_MonsterSpawn_C:GetMultiInfo()
-- 	-- 获取多目标适配的目标table  return {actor, actor}
-- 	return self:GetMultiInfoOrPresetTarget(self.Data.MultiInfo)
-- end

-- function BP_MonsterSpawn_C:GetPresetTarget()
-- 	-- 获取多人预设目标 return return {actor, actor}
-- 	return self:GetMultiInfoOrPresetTarget(self.Data.PresetTargetInfo)
-- end

-- function BP_MonsterSpawn_C:GetMultiInfoOrPresetTarget(SourceData)
-- 	local Res = {}
-- 	if not SourceData then
-- 		DebugPrint("BP_MonsterSpawn_C  导表没填预设目标列，找不到预设目标  MonsterSpawnId:", self.UnitSpawnId)
-- 		return Res 
-- 	end
-- 	for i,j in pairs(SourceData) do
-- 		if i == "Player" then 
-- 			self:AddPlayerInfo(Res)
-- 		elseif i == "Mechanism" then 
-- 			self:AddMechanismInfo(Res, j)
-- 		elseif i == "Hostage" then
-- 			self:AddHostageInfo(Res)
-- 		end
-- 	end
-- 	return Res
-- end

-- function BP_MonsterSpawn_C:AddPlayerInfo(Res)
-- 	if self.GameMode:GetPlayerNum() == 0 then
-- 		DebugPrint("BP_MonsterSpawn_C  当前预设目标为玩家，但玩家数量为0  MonsterSpawnId:", self.UnitSpawnId)
-- 	end
-- 	for i, Player in pairs(self.GameMode:GetAllPlayer()) do
-- 		table.insert(Res, Player)
-- 	end
-- end

-- function BP_MonsterSpawn_C:AddMechanismInfo(Res, UnitId)
-- 	for Eid, DefenceCore in pairs(self.GameState.DefBaseMap) do
-- 		if IsValid(DefenceCore) and DefenceCore.UnitId == UnitId then
-- 			table.insert(Res, DefenceCore)
-- 		end
-- 	end
-- end

-- function BP_MonsterSpawn_C:DistributedMonster(PresetTargets, NeedCreateMonster, IsBalance)
--     local actor_num = #PresetTargets
--     if actor_num == 0 then return {} end
--     local Res = {}
-- 	local random_index = nil
-- 	local random_actor = nil
--     math.randomseed(tostring(os.time()):reverse():sub(1, 7))
--     if IsBalance then
--         -- 平均分配的逻辑
-- 		local sigma_monster_num = 0
-- 		local monster_type_num = 0
-- 		local monster_unitids = {}
-- 		-- 计算 怪物总数 怪物种类数 怪物 unitid表
-- 		for unitid,num in pairs(NeedCreateMonster) do
-- 			table.insert(monster_unitids, unitid)
-- 			sigma_monster_num = sigma_monster_num + num
-- 			monster_type_num = monster_type_num + 1
-- 		end
-- 		-- 每个玩家都能分到的怪物数量
-- 		local divisor = sigma_monster_num//actor_num
-- 		-- 剩下的怪物数量
-- 		local remainder = sigma_monster_num%actor_num
-- 		local temp_actors = {}
-- 		-- 给每个玩家分配固定数量的怪物
-- 		for _,actor in pairs(PresetTargets) do
-- 			-- 记录一个临时的玩家表
-- 			table.insert(temp_actors,actor)
-- 			for i=1,divisor do
-- 				-- 随机一个怪物种类, actor 对应+1
-- 				random_index = math.random(1,monster_type_num)
-- 				local temp_unitid = monster_unitids[random_index]
-- 				Res[actor] = Res[actor] or {}
-- 				Res[actor][temp_unitid] = Res[actor][temp_unitid] and Res[actor][temp_unitid]+1 or 1
-- 				-- 该种类怪物数量-1
-- 				NeedCreateMonster[temp_unitid] = NeedCreateMonster[temp_unitid] - 1
-- 				-- 该种类怪物数量为0 从怪物 unitid表中移除此unitid
-- 				if NeedCreateMonster[temp_unitid] == 0 then
-- 					monster_type_num = monster_type_num - 1
-- 					table.remove(monster_unitids, random_index)
-- 				end
-- 			end
-- 		end
-- 		for i=1,remainder do
-- 			-- 随机选中一个actor
-- 			random_index = math.random(1,actor_num)
-- 			random_actor = temp_actors[random_index]
-- 			table.remove(temp_actors,random_index)
-- 			actor_num = actor_num - 1
-- 			-- 随机选中一个怪物种类
-- 			random_index = math.random(1,monster_type_num)
-- 			local temp_unitid = monster_unitids[random_index]
-- 			Res[random_actor] = Res[random_actor] or {}
-- 			Res[random_actor][temp_unitid] = Res[random_actor][temp_unitid] and Res[random_actor][temp_unitid]+1 or 1
-- 			-- 该种类怪物数量-1
-- 			NeedCreateMonster[temp_unitid] = NeedCreateMonster[temp_unitid] - 1
-- 			-- 该种类怪物数量为0 从怪物 unitid表中移除此unitid
-- 			if NeedCreateMonster[temp_unitid] == 0 then
-- 				monster_type_num = monster_type_num - 1
-- 				table.remove(monster_unitids, random_index)
-- 			end
-- 		end
--     else
--         -- 随机分配的逻辑
--     	-- 设置随机Seed
--         for unitid, num in pairs(NeedCreateMonster) do
--             for i=1,num do
--                 random_index = math.random(1,actor_num)
--                 random_actor = PresetTargets[random_index]
--                 Res[random_actor] = Res[random_actor] or {}
--                 Res[random_actor][unitid] = Res[random_actor][unitid] or 0
--                 Res[random_actor][unitid] = Res[random_actor][unitid] + 1
--             end
--         end
--     end
--     return Res
-- end

return BP_MonsterSpawn_C