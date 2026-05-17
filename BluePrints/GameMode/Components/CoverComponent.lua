
-- require "UnLua"
-- require "Const"

-- local Component = {}

-- function Component:ComponentReceiveBeginPlay()
-- 	self.AreaSize = 1300 -- 区域的长宽
-- 	self.Offset = {-1, 0, 1}
-- 	self.TickInterval = 3.0
-- 	self.IntervalRemain = self.TickInterval
-- 	self.CoverInfos = {}-- {AreaId: {CoverPointId : CoverStruct}}
-- end

-- function Component:InitCoverInfoAreas(CoverPonintInfos)
-- 	if CoverPonintInfos == nil then
-- 		return
-- 	end
-- 	for i = 1, CoverPonintInfos:Length() do
-- 		local CoverPonintInfo = CoverPonintInfos:GetRef(i)
-- 		CoverPonintInfo.CoverPointId = self:GetBattleEid()
-- 		self:SetAreaCoverPointInfo(CoverPonintInfo)
-- 	end
-- 	DebugPrint("CoverComponent InitCoverInfoAreas Num:"..CoverPonintInfos:Length())
-- end

-- function Component:ClearCoverPointInfo()
-- 	self.CoverInfos = {}
-- 	self.CoverPointCandidate = {}
-- 	DebugPrint("CoverComponent: Clear!")
-- end

-- function Component:ResetCoverInfo(CoverPointInfo, SourceEid)
-- 	if CoverPointInfo == nil then
-- 		return
-- 	end
-- 	if CoverPointInfo.UsingEid == 0 or CoverPointInfo.UsingEid ~= SourceEid then
-- 		return
-- 	end
-- 	local Key = self:GetAreaKey(CoverPointInfo:GetCoverPointLoc(self))
-- 	local RealCoverPointInfo = self.CoverInfos[Key][CoverPointInfo.CoverPointId]
-- 	RealCoverPointInfo.CoverPointValid = false
-- 	RealCoverPointInfo.UsingEid = 0
-- 	RealCoverPointInfo.MonNearNum = math.max(CoverPointInfo.MonNearNum - 1, 0)
-- end

-- function Component:SetAreaCoverPointInfo(CoverPointInfo)
-- 	local Key = self:GetAreaKey(CoverPointInfo:GetCoverPointLoc(self))
-- 	local AreaCoverInfos = self.CoverInfos[Key] or {}
-- 	AreaCoverInfos[CoverPointInfo.CoverPointId] = CoverPointInfo
-- 	self.CoverInfos[Key] = AreaCoverInfos
-- end

-- function Component:GetAreaKey(Loc)
-- 	local AreaX = math.floor(Loc.X / self.AreaSize)
-- 	local AreaY = math.floor(Loc.Y / self.AreaSize)
-- 	return AreaX.."-"..AreaY
-- end

-- function Component:GetAroundAreaKeys(Loc)
-- 	local Res = {}
-- 	local AreaX = math.floor(Loc.X / self.AreaSize)
-- 	local AreaY = math.floor(Loc.Y / self.AreaSize)
-- 	for i,j in pairs(self.Offset) do
-- 		local TmpX = AreaX + j
-- 		for ii,k in pairs(self.Offset) do
-- 			local TmpY = AreaY + k
-- 			table.insert(Res, TmpX.."-"..TmpY)
-- 		end
-- 	end  
-- 	return Res
-- end
-- --=============================================================================================================

-- function Component:InitComponent()
-- 	local FilterCoverData = DataMgr.FilterCoverData[1]
-- 	self.CoverPointCandidate = {} -- {Eid:{coverpointInfos}}

-- 	self.FilterCoverMaxDis = FilterCoverData.MaxDis or 20
-- 	self.FilterCoverMinDis = FilterCoverData.MinDis or 0
-- 	self.FilterCoverMaxAngle = FilterCoverData.MaxAngleList or {180, 180, 180}
-- 	self.FilterCoverMinAngle = FilterCoverData.MinAngleList or {-180, -180, -180}
-- 	self.FilterMaxNearNum = FilterCoverData.MaxNearNum or 100
-- 	self.FilterMaxZ = FilterCoverData.MaxZ or 100
-- 	self.LineZOffSet = (FilterCoverData.CoverLineCheck and FilterCoverData.CoverLineCheck.LineHeight) or 100
-- 	self.CenterLineEnable = (FilterCoverData.CoverLineCheck and FilterCoverData.CoverLineCheck.CenterLineEnable) or false
-- 	self.OffsetLineEnable = (FilterCoverData.CoverLineCheck and FilterCoverData.CoverLineCheck.OffsetLineEnable) or false
-- end

-- function Component:TickComponent(DeltaSeconds)
-- 	if self.UseCPPAIBattleComponent then
-- 		return
-- 	end
-- 	self.IntervalRemain = self.IntervalRemain - DeltaSeconds
-- 	if self.IntervalRemain > 0 then
-- 		return
-- 	end
-- 	self.IntervalRemain = self.TickInterval

-- 	self.CoverPointCandidate = {}
-- 	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	for _, Player in pairs(GameMode:GetAllPlayer()) do
-- 		local AroundAreaKeys = self:GetAroundAreaKeys(Player:k2_GetActorLocation())
-- 		for i, TmpAreaKey in pairs(AroundAreaKeys) do
-- 			local TmpCoverPointInfos = self.CoverInfos[TmpAreaKey]
-- 			self:UpdateCoverPointInfos(Player, TmpCoverPointInfos)
-- 		end
-- 	end
-- end

-- function Component:UpdateCoverPointInfos(Player, TmpCoverPointInfos)
-- 	if TmpCoverPointInfos == nil then return end
-- 	local TargetCoverPointInfos = self.CoverPointCandidate[Player.Eid] or {}
-- 	for i, CoverPointInfo in pairs(TmpCoverPointInfos) do
-- 		if self:FilterCoverPointInfo(Player, CoverPointInfo) then
-- 			table.insert(TargetCoverPointInfos, CoverPointInfo)
-- 		elseif self:CoverPointInfoIsUsing(CoverPointInfo) then
-- 			self:UpdateCoverPointValidValue(CoverPointInfo.UsingEid, false)
-- 		end
-- 	end
-- 	self.CoverPointCandidate[Player.Eid] = TargetCoverPointInfos

-- 	if self.NeedPrintUpdateCoverInfos == true then
-- 		DebugPrint("\n===================== CoverComponent [Lua] 更新掩体信息 =====================")
-- 		DebugPrint("玩家 Eid =", Player.Eid, ", 掩体数量 =", #self.CoverPointCandidate[Player.Eid])
-- 		for key, value in pairs(self.CoverPointCandidate[Player.Eid]) do
-- 			DebugPrint("第", key, "个掩体的位置 =", value.CoverPointLoc)
-- 		end
-- 		DebugPrint("===================== CoverComponent [Lua] 结束掩体更新 =====================\n")
-- 	end
-- end

-- function Component:FilterCoverPointInfo(Player, CoverPointInfo)
-- 	if CoverPointInfo == nil then
-- 		return false
-- 	end
-- 	-- 1. Filter by range
-- 	if not IsValid(Player) then return false end
-- 	if not MiscUtils.IsInRange(CoverPointInfo:GetCoverPointLoc(self), Player:K2_GetActorLocation(), self.FilterCoverMinDis, self.FilterCoverMaxDis) then 
-- 		return false
-- 	end

-- 	-- 2. Filter by Z
-- 	if self.FilterMaxZ < math.abs(Player:K2_GetActorLocation().Z - CoverPointInfo:GetCoverPointLoc(self).Z) then
-- 		return false
-- 	end

-- 	-- 3. Filter by angle
-- 	local CoverPointInfoForward = CoverPointInfo:GetCoverPointFor(self)
-- 	local DisForward = Player:K2_GetActorLocation() - CoverPointInfo:GetCoverPointLoc(self)
-- 	local LocationType = CoverPointInfo.LocType + 1
-- 	local MinAngle = self.FilterCoverMinAngle[LocationType] or 180
-- 	local MaxAngle = self.FilterCoverMaxAngle[LocationType] or -180
-- 	CoverPointInfoForward:Normalize()
-- 	DisForward:Normalize()
-- 	local DotResult = CoverPointInfoForward:Dot(DisForward)
--     local Angle = UE4.UKismetMathLibrary.DegAcos(DotResult)
-- 	local CrossProduct = CoverPointInfoForward:Cross(DisForward)

-- 	local RealAngle = Angle
-- 	if CrossProduct.Z < 0 then
-- 		RealAngle = -RealAngle
-- 	end
	
-- 	-- 合法的角度定义: 所有在maxangle以顺时针方向转到minangle之间的角度， see https://www.tapd.cn/31626021/prong/stories/view/1131626021001098605
-- 	if MinAngle < MaxAngle then
-- 		if RealAngle < MinAngle or RealAngle > MaxAngle then
-- 			return false
-- 		end 
-- 	end

-- 	if MinAngle > MaxAngle then
-- 		if RealAngle < MaxAngle and RealAngle > MinAngle then
-- 			return false
-- 		end
-- 	end

-- 	-- 4. Filter by line trace
-- 	if not self.CenterLineEnable and not self.OffsetLineEnable then 
-- 		return true 
-- 	end
-- 	local CenterPos = CoverPointInfo:GetCoverPointLoc(self)
-- 	local CenterPosOffset = CoverPointInfo:GetCoverEnterPointLoc(self)
-- 	if CoverPointInfo.LocType == 1 then 
-- 		CenterPosOffset = CenterPos + FVector(0,0,1) * self.LineZOffSet
-- 	end
-- 	local EndPos = Player:K2_GetActorLocation()
-- 	local HitResult = FHitResult()
	
-- 	if self.CenterLineEnable then 
-- 		local bHitCenterPos = UE4.UKismetSystemLibrary.LineTraceSingle(self, CenterPos, EndPos, ETraceTypeQuery.TraceEnemyVision, false, nil, 0, HitResult, true)
-- 	    if bHitCenterPos and HitResult.Actor and HitResult.Actor.Eid == Player.Eid then
-- 	       	return false
-- 	    end
-- 	end

-- 	if self.OffsetLineEnable then 
-- 		local bHitCenterPosOffset = UE4.UKismetSystemLibrary.LineTraceSingle(self, CenterPosOffset, EndPos, ETraceTypeQuery.TraceEnemyVision, false, nil, 0, HitResult, true)
-- 	    if (not bHitCenterPosOffset) or (not HitResult.Actor) or (not (HitResult.Actor.Eid == Player.Eid)) then
-- 	       	return false
-- 	    end
-- 	end

-- 	return true
-- end

-- function Component:CoverPointInfoIsUsing(CoverPointInfo)
-- 	if CoverPointInfo.UsingEid ~= 0 then
-- 		return true
-- 	end
-- 	return false
-- end

-- function Component:FilterCoverPointUseEnable(Infos)
-- 	local Res = {}
-- 	for _, Info in pairs(Infos) do
-- 		if not self:CoverPointInfoIsUsing(Info) then
-- 			table.insert(Res, Info)
-- 		end
-- 	end
-- 	return Res
-- end

-- function Component:FilterCoverPointNearNum(Infos, NearNum)
-- 	local Res = {}
-- 	for i, Info in pairs(Infos) do 
-- 		if Info.MonNearNum and Info.MonNearNum <= NearNum then 
-- 			table.insert(Res, Info) 
-- 		end
-- 	end
-- 	return Res
-- end

-- function Component:FilterCoverPointNum(Player, Infos, Rule)
-- 	local Res = {}
-- 	local DistanceTable = {} -- {1: Dis}
-- 	local TmpCoverPointInfo = {}  -- {Dis: CoverPointInfo}
-- 	for i, Info in pairs(Infos) do
-- 		local Dis = (Player:K2_GetActorLocation() - Info:GetCoverPointLoc(self)):Size()
-- 		table.insert(DistanceTable, Dis)
-- 		TmpCoverPointInfo[Dis] = Info
-- 	end
-- 	if Rule.NearEnable then
-- 		table.sort(DistanceTable, function(a, b) return a < b end)
-- 	else
-- 		table.sort(DistanceTable, function(a, b) return a > b end)
-- 	end
-- 	for i,j in pairs(DistanceTable) do 
-- 		if i <= Rule.Num then
-- 			table.insert(Res, TmpCoverPointInfo[j])
-- 		end
-- 	end
-- 	return Res
-- end

-- function Component:FilterCoverPointAngle(Monster, Player, Infos, Rule)
-- 	local Res = {}
-- 	for i, Info in pairs(Infos) do
-- 		local MonPlayerForward = Monster:K2_GetActorLocation() - Player:K2_GetActorLocation()
-- 		local CovPlayerForward = Info:GetCoverPointLoc(self) - Player:K2_GetActorLocation()
-- 		MonPlayerForward:Normalize()
-- 		CovPlayerForward:Normalize()
-- 		local DotResult = MonPlayerForward:Dot(CovPlayerForward)
-- 	    local Angle = UE4.UKismetMathLibrary.DegAcos(DotResult)
-- 	    if Rule.AngleMax == -1 or Angle <= Rule.AngleMax then 
-- 	    	if Rule.AngleMin == -1 or Angle >= Rule.AngleMin then 
-- 	    		table.insert(Res, Info)
-- 	    	end
-- 	    end
-- 	end
-- 	return Res
-- end

-- function Component:FilterCoverPointPathFinding(Monster, Infos)
-- 	local Res = {}
-- 	for i, Info in pairs(Infos) do
-- 		if UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(Monster:K2_GetActorLocation(), Info:GetCoverPointLoc(self),Monster) == UE4.EPathConnectType.HasPath then
-- 			table.insert(Res, Info)
-- 		end
-- 	end
-- 	return Res
-- end

-- function Component:RandomCoverPointInfo(SourceEid, Infos, Rule)
-- 	if #Infos == 0 then 
-- 		return FCoverPointStruct()
-- 	end
-- 	local Index = math.random(1,#Infos)
-- 	local Info = Infos[Index]

-- 	Info.CoverPointValid = true
-- 	Info.MonNearNum = Info.MonNearNum + 1
-- 	if Rule.UseEnable then 
-- 		Info.UsingEid = SourceEid
-- 		self:UpdateCoverPointValidValue(SourceEid, true)
-- 	else
-- 		if Info.UsingEid == SourceEid then
-- 			Info.UsingEid = 0
-- 		end
-- 		self:UpdateCoverPointValidValue(SourceEid, false)
-- 	end
-- 	self:UpdateCoverPointUsingValue(SourceEid, Info, Rule)
-- 	return Info
-- end

-- function Component:GetCoverPointInfo(SourceEid, UseEnable, NearEnable, Num, AngleMax, AngleMin)
-- 	local Rule = {UseEnable = UseEnable, NearEnable = NearEnable, Num = Num, AngleMax = AngleMax, AngleMin = AngleMin}
-- 	local Monster = Battle(self):GetEntity(SourceEid)
-- 	if Monster == nil then
-- 		return FCoverPointStruct() 
-- 	end
-- 	local Player = Monster.BBTarget
-- 	if Player == nil then
-- 		return FCoverPointStruct() 
-- 	end
-- 	local ResCoverPointCandidate = self.CoverPointCandidate[Player.Eid]
-- 	if ResCoverPointCandidate == nil then 
-- 		return FCoverPointStruct() 
-- 	end
-- 	if Rule.UseEnable then
-- 		ResCoverPointCandidate = self:FilterCoverPointUseEnable(ResCoverPointCandidate)
-- 	end
-- 	if Rule.AngleMax ~= -1 or Rule.AngleMin ~= -1 then
-- 		ResCoverPointCandidate = self:FilterCoverPointAngle(Monster, Player, ResCoverPointCandidate, Rule)
-- 	end
-- 	if self.FilterMaxNearNum then 
-- 		ResCoverPointCandidate = self:FilterCoverPointNearNum(ResCoverPointCandidate, self.FilterMaxNearNum)
-- 	end
-- 	if Rule.Num > 0 then
-- 		ResCoverPointCandidate = self:FilterCoverPointNum(Player, ResCoverPointCandidate, Rule)
-- 	end
-- 	ResCoverPointCandidate = self:FilterCoverPointPathFinding(Monster, ResCoverPointCandidate)

-- 	if self.NeedPrintGetCoverInfos == true then
-- 		DebugPrint("\n===================== CoverComponent [Lua] 获取掩体信息 =====================")
-- 		DebugPrint("怪物 Eid =", SourceEid, ", 玩家 Eid =", Player.Eid, ", 掩体数量 =", #ResCoverPointCandidate)
-- 		for key, value in pairs(ResCoverPointCandidate) do
-- 			DebugPrint("第", key, "个掩体的位置 =", value.CoverPointLoc)
-- 		end
-- 		DebugPrint("===================== CoverComponent [Lua] 结束掩体获取 =====================\n")
-- 	end
	
-- 	ResCoverPointCandidate = self:RandomCoverPointInfo(SourceEid, ResCoverPointCandidate, Rule)
-- 	return ResCoverPointCandidate
-- end

-- function Component:UpdateCoverPointValidValue(UsingEid, Value)
-- 	-- 本意是为了 当玩家跑开的时候打断怪物的行为
-- 	if UsingEid == 0 then
-- 		return
-- 	end
-- 	local Monster = Battle(self):GetEntity(UsingEid)
-- 	if Monster == nil then return end
-- 	Monster:GetOwnBlackBoardComponent():SetValueAsBool("CoverPointInfoValid", Value)
-- end

-- function Component:UpdateCoverPointUsingValue(SourceEid, Info, Rule)
-- 	-- 目的是为了在拿到掩体以后判断，这个掩体占用是不是自己
-- 	local Monster = Battle(self):GetEntity(SourceEid)
-- 	if Rule.UseEnable and Info.UsingEid == SourceEid then
-- 		Monster:GetOwnBlackBoardComponent():SetValueAsBool("UsingIsSelf", true)
-- 		return
-- 	end
-- 	Monster:GetOwnBlackBoardComponent():SetValueAsBool("UsingIsSelf", false)
-- end


-- return Component