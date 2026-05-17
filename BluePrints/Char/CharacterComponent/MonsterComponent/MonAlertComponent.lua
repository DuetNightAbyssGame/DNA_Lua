
require "UnLua"
require "Const"

local Component = Class()

function Component:InitComponent_Lua()
	rawset(self,"AlertData", DataMgr.AlertData[self.AlertId])
end

-- function Component:InitComponent()
-- 	self.AlertData = DataMgr.AlertData[self.AlertId]
-- 	self.AlertResetChange = -100
-- 	self.AlertValue_Lua = self.AlertValue
-- 	if self.AlertData == nil then
-- 		return
-- 	end
-- 	self.MonAlertComponent:InitComponentAttrs(self.AlertId)
-- 	self.AlertTickTime = 0.3
-- 	self.AlertTickRemainTime = self.AlertTickTime
-- 	--self.MaxAlertValue = self.AlertData.MaxAlertValue or self:GetMaxAlertValue()
-- 	self.AlertResetChange = self.AlertData.AlertResetChange or self.AlertResetChange
-- 	--self.BroadCastDis = self.AlertData.BroadCastDis or 2000
-- 	self.BroadCastAlertValue = self.AlertData.BroadCastAlertValue or 30
-- 	--self.FightStateBroarCastTime = self.AlertData.FightStateBroarCastTime or 1
-- 	--self.FightStateBroarCastRemainTime = self.FightStateBroarCastTime
-- 	--self.CanBroadCastAlert = self.AlertData.CanBroadCastAlert  -- 导表数据，优先级最高
-- 	-- InitSightInfo
-- 	self.InSight = false
-- 	self.SightRadius = 0
-- 	self.SightAngle = 0
-- 	self.MinSightDis = 0
-- 	-- InitHearInfo
-- 	self.InHear = false
-- 	self.InHearCD = false
-- 	self.HearCD = 3
-- 	self.HearSetAlertValue = 0
-- 	self.HearReduceAlertValue = 30
-- 	-- InitAlertInfo
-- 	--self.BroadCastEnable = false  -- 本轮自己数据的修改能否进行广播的控制
-- 	--self.LastAlertValue = 0
-- 	self.IsInCommonAlert = false
-- 	self.AlarmTarget = nil
-- 	self.OnlyBaseAlertEnable = self.Data.CommonAlertEnable ~= 1
-- 	self.AlertGameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	self.AOEnable = self:IsRangedMonster()
-- 	self.LastAlertTimestamp = nil	-- 上次触发报警的时间
-- 	self.CommonAlertRequestTime = self.AlertData.CommonAlertRequestTime or 1
-- 	if self:GetOwnBlackBoardComponent() then
-- 		local AlarmMode = self.AlertData.AlarmMode or ""
-- 		self:GetOwnBlackBoardComponent():SetValueAsString("AlarmMode", AlarmMode)
-- 	end
-- end

-- function Component:UpdateIsInCommonAlert(Monster)
-- 	if self.AlertGameMode and self.AlertGameMode:CheckIsInCommonAlert(Monster.ClanId) then
-- 		self.IsInCommonAlert = true
-- 		return
-- 	end
-- 	self.IsInCommonAlert = false
-- end

-- function Component:ResetIsInCommonAlert()
-- 	self.IsInCommonAlert = false
-- end

-- function Component:UpdateSightHearBaseData()
-- 	-- 副本内需要替换报警下的听觉视觉
-- 	if self.AlertGameMode:IsInDungeon() and self.IsInCommonAlert then
-- 		self.SightData = DataMgr.SightData[self.AlertData.CommonAlertSightId]
-- 		self.HearData = DataMgr.HearData[self.AlertData.CommonAlertHearId]
-- 	else
-- 		local AlertValue = self:GetAlertValue_Lua()
-- 		for i,v in pairs(self.AlertData.AlertRanges) do
-- 			if AlertValue < v.AlertRange[2] and AlertValue >= v.AlertRange[1] then
-- 				self.SightData = DataMgr.SightData[v.AlertRangeSightId]
-- 				self.HearData = DataMgr.HearData[v.AlertRangeHearId]
-- 			end
-- 		end
-- 	end
-- 	self:SetSightData()
-- 	self:SetHearData()
-- end

-- function Component:SetSightData()
-- 	if not self.SightData then 
-- 		return
-- 	end
-- 	self.SightRadius = self.SightData.SightRadius * (self.SightRadiusRate or 1)
-- 	self.SightAngle = self.SightData.SightAngle
-- end

-- function Component:SetHearData()
-- 	if not self.HearData then
-- 		return
-- 	end
-- 	self.HearCD = self.HearData.HearCD
-- 	self.HearSetAlertValue = self.HearData.HearSetAlertValue
-- 	self.HearReduceAlertValue = self.HearData.HearReduceAlertValue
-- 	self.HearBaseRadius = self.HearData.HearBaseRadius or 0
-- end

-- function Component:TickComponent(DeltaSeconds)
-- 	if self.AlertData == nil then
-- 		return
-- 	end
-- 	if not self:GetOwnBlackBoardComponent() then 
-- 		return 
-- 	end
--     self.AlertTickRemainTime = self.AlertTickRemainTime - DeltaSeconds
--     if self.AlertTickRemainTime <= 0 then
--         local TmpTime = self.AlertTickRemainTime
--         self.AlertTickRemainTime = self.AlertTickTime
--         self:TickAlertComponent(self.AlertTickTime - TmpTime)
--     end
-- end

-- function Component:TickAlertComponent(DeltaSeconds)
-- 	-- 更新AO标志
-- 	self:UpdateAOInfo()
	
-- 	-- 战斗状态和脱战状态停掉警戒值
-- 	if self:GetAlertState_Lua() == Const.FightState or self:GetAlertState_Lua() == Const.EndBattleState then
-- 		return
-- 	end
-- 	self.LastAlertValue = self:GetAlertValue_Lua()
-- 	self.BroadCastEnable = false
-- 	self:UpdateIsInCommonAlert(self)
-- 	local LastTargetAlertedNum = self.TargetAlerted:Num()

-- 	--目前出于性能方面原因考虑，暂时不需要，一直广播的功能，保留变更时广播的功能
-- 	-- 战斗怪物边跑边喊XDM一起上
-- 	--[[if self.CanBroadCastAlert and self:GetAlertState_Lua() == Const.FightState then
-- 		self:BroadCastFightInfo(DeltaSeconds)
-- 		return
-- 	end--]]

-- 	-- 非战斗怪物边看边加入战斗
-- 	self.MonAlertComponent:RequestFightInfo(DeltaSeconds)
-- 	if self:GetAlertState_Lua() == Const.FightState then
-- 		return
-- 	end
-- 	-- 仇恨列表的变化直接更新状态，并且做广播
-- 	self:UpdateAlertState()
-- 	if self:GetAlertState_Lua() == Const.FightState then
-- 		return
-- 	end
-- 	-- 更新[报警目标]的信息
-- 	self:UpdateAlarmTargetInfo()
-- 	-- 判断是否区域/副本报警，并更新警戒值和警戒列表(一次)
-- 	self:UpdateCommonAlertInfo()
-- 	-- 更新听觉视觉的导表数据
-- 	self:UpdateSightHearBaseData()
-- 	-- 更新听觉引起的警戒值变化
-- 	self:UpdateHearingInfo()
-- 	-- 更新视觉引起的警戒值变化
-- 	self:UpdateSightInfo()
-- 	if self:IsJailerMonster() then
-- 		-- 救援报警位相关，仅救援玩法生效
-- 		if self:TrySetRescueAlertingInfo(LastTargetAlertedNum) then
-- 			return
-- 		end
-- 	else
-- 		-- 怪物尝试抢占报警位，进行报警
-- 		if self:TrySetCommonAlertingInfo(LastTargetAlertedNum) then 
-- 			return
-- 		end
-- 	end
-- 	-- 更新警戒值变化自动增减(副本内CommonAlert下只升不降)
-- 	self:UpdateAlertValue(DeltaSeconds)
-- 	-- 警戒值变化，引起的状态，列表更新
-- 	self:UpdateAlertInfo()
-- 	-- 进行状态变化引起的广播
-- 	self.MonAlertComponent:BroadCastInfo()
-- 	self:ResetIsInCommonAlert()
	-- local yxdAlarmTarget = "No AlarmTarget"
	-- if self.AlarmTarget then
	-- 	yxdAlarmTarget = self.AlarmTarget.Eid
	-- end
	-- DebugPrint("yxd MonAlertComponent DeltaSeconds:"..DeltaSeconds
	-- 	.."  UnitId:" .. self.UnitId
	-- 	.."  AlertValue:" .. self.AlertValue_Lua
	-- 	.."  AlertState:" .. self:GetAlertState()
	-- 	.."  Mindis:" .. self.MinSightDis
	-- 	.."  Eid:" .. self.Eid
	-- 	.."  AlarmTarget:"..yxdAlarmTarget
	-- 	.."  IsAlertingMonter:",UE4.UGameplayStatics.GetGameMode(self):IsCommonAlertingMonster(self)
	-- )
-- end

-- function Component:RequestCommonAlertSuccess()
-- 	if self.AlertGameMode:IsInDungeon() then 
-- 		self:DungeonRequestCommonAlertSuccess()
-- 	end
-- 	if self.AlertGameMode:IsInRegion() then
-- 		self:RegionRequestCommonAlertSuccess()
-- 	end
-- end

-- function Component:DungeonRequestCommonAlertSuccess() 
-- 	if self.IsInCommonAlert then 
-- 		return
-- 	end
-- 	if not self.AlertGameMode:IsCommonAlertingMonster(self) then 
-- 		return
-- 	end

-- 	-- 2023.10.18 xyz要求副本报警成功时 进行alarmtarget 和 alertvalue的广播
-- 	DebugPrint("Monster Alert 副本报警成功  报警怪 Eid:"..self.Eid.."  UnitId:"..self.UnitId)
-- 	self:BroadCastCommonAlertInfo()
-- 	self:AlertStateChange(Const.FightState, true)
-- 	self:UpdateAlertInfo()
-- 	-- 报警成功，区域副本都进行0/1-2的广播
-- 	self.MonAlertComponent:BroadCastInfo()
-- 	self.AlertGameMode:TryResetCommonAlertingInfo(self)
-- 	self:GetOwnBlackBoardComponent():SetValueAsObject("AlarmTarget", nil)
-- 	self:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", false)
-- 	self.AlertGameMode:TriggerActiveGameModeState(Const.StateAlert)
-- end

function Component:RegionRequestCommonAlertSuccess()
	local Owner = self.Owner
	if not IsValid(Owner) then return end
	if self.IsInCommonAlert then 
		return
	end
	if not self.AlertGameMode:IsCommonAlertingMonster(Owner) then
		return
	end
	local ClanMgr = self.AlertGameMode:GetClan(Owner.ClanId)
	ClanMgr.InCommonAlert = true
	self.AlertGameMode:TryResetCommonAlertingInfo(Owner)
	self:AlertStateChange(Const.FightState, true)
	self:UpdateAlertInfo()
	-- 报警成功，区域副本都进行0/1-2的广播
	self:BroadCastInfo()
	Owner:GetOwnBlackBoardComponent():SetValueAsObject("AlarmTarget", nil)
	Owner:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", false)
	-- 激活群落的动态刷怪
	ClanMgr:CreateMonsterSpawn()
	-- 区域没有副本状态的变化，直接发事件通知UI
	self.AlertGameMode:OnEnterCommonAlert()
end

function Component:RequestRescueAlertSuccess()
	local Owner = self.Owner
	if not IsValid(Owner) then return end
	if not self.AlertGameMode:IsRescueAlertingMonster(Owner) then
		return
	end

	DebugPrint("救援副本报警成功  报警怪 Eid:"..Owner.Eid.."  UnitId:"..Owner.UnitId)
	self:BroadCastRescueAlertInfo()
	self:AlertStateChange(Const.FightState, true)
	self:UpdateAlertInfo()
	-- 报警成功，区域副本都进行0/1-2的广播
	self:BroadCastInfo()
	self.AlertGameMode:TriggerDungeonComponentFun("TryResetRescueAlertingInfo", self.Owner)
	Owner:GetOwnBlackBoardComponent():SetValueAsObject("AlarmTarget", nil)
	Owner:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", false)
	self.AlertGameMode:GetDungeonComponent().RescueIsInCommonAlert = true
end

function Component:ClanRequestAlertSuccess()
	local Owner = self.Owner
	if not IsValid(Owner) then return end
	if self.IsInCommonAlert then 
		return
	end
	if not self.AlertGameMode:IsCommonAlertingMonster(Owner) then
		return
	end
	local ClanMgr = self.AlertGameMode:GetClan(Owner.ClanId)
	ClanMgr.InCommonAlert = true
	self:BroadCastClanInfo(ClanMgr.MonsterMap)
end

-- function Component:UpdateAlarmTargetInfo()
-- 	-- 更新[报警目标]的信息，如果不存在，重置报警信息
-- 	if self.OnlyBaseAlertEnable then 
-- 		return
-- 	end
-- 	if self.IsInCommonAlert then
-- 		return
-- 	end
-- 	if self.AlertGameMode:LevelCommonAlertDisable(self) then
-- 		return
-- 	end
-- 	if self.AlertGameMode:IsCommonAlertingMonster(self) then
-- 		if self.AlarmTarget == nil or self.AlarmTarget:IsDead() then
-- 			self.AlertGameMode:TryResetCommonAlertingInfo(self)
-- 		end
-- 	end
-- end

function Component:TrySetRescueAlertingInfo(LastTargetAlertedNum)
	if self.AlertGameMode:IsInRegion() then
		return false
	end
	if self:GetAlertValue_Lua() < 200 then
		return false
	end
	if self.AlertGameMode.EMGameState.GameModeType == "Rescue" then
		return self.AlertGameMode:TriggerDungeonComponentFun("TrySetRescueAlertingInfo", LastTargetAlertedNum, self.Owner)
	end
	return false
end

function Component:TryResetRescueAlertingInfo()
	self.AlertGameMode:TriggerDungeonComponentFun("TryResetRescueAlertingInfo", self.Owner)
end

-- function Component:TrySetCommonAlertingInfo(LastTargetAlertedNum)
-- 	-- 怪物尝试抢占报警位，进行报警
-- 	if not self.AlertData then 
-- 		return false
-- 	end
-- 	if self.OnlyBaseAlertEnable then 
-- 		return false
-- 	end
-- 	if self.IsInCommonAlert then 
-- 		return false
-- 	end
-- 	if self.AlertGameMode:LevelCommonAlertDisable(self) then
-- 		return false
-- 	end
-- 	if LastTargetAlertedNum == 0 and self.TargetAlerted:Num() > 0 then
-- 		-- 目前只有副本 + 区域群落可以抢占报警位
-- 		if self:RequestCommonAlertingEid() then
-- 			--抢占成功，进行报警
-- 			self:SetAlertValue(self:GetMaxAlertValue() - 1, false)
-- 			return self:TrySetBBAlertingInfo()
-- 		end
-- 	end
-- 	return false
-- end

function Component:RequestCommonAlertingEid()
	return self.AlertGameMode:RequestCommonAlertingEid(self.Owner)
end

function Component:TrySetBBAlertingInfo()
	local Owner = self.Owner
	if not IsValid(Owner) then return end
	if self.AlertData.AlarmMode == "UseAlarmMechanism" then 
		local AlertMechanism = self.AlertGameMode:GetAlertMechanismInfo(Owner)
		if not AlertMechanism then 
			self.AlertGameMode:TryResetCommonAlertingInfo(Owner)
			self.OnlyBaseAlertEnable = true
			DebugPrint("Monster Alert 怪物抢占了报警位但是没有机关报警失败---Eid"..Owner.Eid.." UnitId:"..Owner.UnitId.." Loc:"..tostring(Owner:K2_GetActorLocation()))
			return false
		end
		DebugPrint("Monster Alert 抢占报警位，获取报警机关成功---Eid:"..Owner.Eid.." UnitId:"..Owner.UnitId.." Loc:"..tostring(AlertMechanism:GetMonsterAnimTrans().Translation))
		Owner:GetOwnBlackBoardComponent():SetValueAsVector("AlarmMechanismInteractiveLoc", AlertMechanism:GetMonsterAnimTrans().Translation)
		Owner:GetOwnBlackBoardComponent():SetValueAsObject("AlarmMechanism", AlertMechanism)
	end
	Owner:BBSetAlarmTarget(self.AlertGameMode:RequestCommonAlarmTargetInfo(Owner))
	Owner:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", true)
	DebugPrint("Monster Alert 抢占报警位成功，开始报警动画---Eid:"..Owner.Eid.." UnitId:"..Owner.UnitId.." Loc:"..tostring(Owner:K2_GetActorLocation()).." AlarmTargetLoc:"..tostring(self.AlarmTarget:K2_GetActorLocation()))
	return true
end

function Component:TrySetClanAlertingInfo()
	local Owner = self.Owner
	if not IsValid(Owner) then return end
	if self.AlertData.AlarmMode == "UseAlarmMechanism" then 
		local AlertMechanism = self.AlertGameMode:GetAlertMechanismInfo(Owner)
		if not AlertMechanism then 
			self.AlertGameMode:TryResetCommonAlertingInfo(Owner)
			self.OnlyBaseAlertEnable = true
			DebugPrint("Clan Monster Alert 怪物抢占了报警位但是没有机关报警失败---Eid"..Owner.Eid.." UnitId:"..Owner.UnitId.." Loc:"..tostring(Owner:K2_GetActorLocation()))
			return false
		end
		DebugPrint("Clan Monster Alert 抢占报警位，获取报警机关成功---Eid:"..Owner.Eid.." UnitId:"..Owner.UnitId.." Loc:"..tostring(AlertMechanism:GetMonsterAnimTrans().Translation))
		Owner:GetOwnBlackBoardComponent():SetValueAsVector("AlarmMechanismInteractiveLoc", AlertMechanism:GetMonsterAnimTrans().Translation)
		Owner:GetOwnBlackBoardComponent():SetValueAsObject("AlarmMechanism", AlertMechanism)
	end
	Owner:BBSetAlarmTarget(self.AlertGameMode:RequestCommonAlarmTargetInfo(Owner))
	Owner:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", true)
	DebugPrint("Clan Monster Alert 抢占报警位成功，开始报警动画---Eid:"..Owner.Eid.." UnitId:"..Owner.UnitId.." Loc:"..tostring(Owner:K2_GetActorLocation()).." AlarmTargetLoc:"..tostring(self.AlarmTarget:K2_GetActorLocation()))

	local ClanMgr = self.AlertGameMode:GetClan(Owner.ClanId)
	if not ClanMgr then
		DebugPrint("Clan Monster Alert ClanMgr is nil, can't set clan alerting info---Eid"..Owner.Eid.." UnitId:"..Owner.UnitId)
		return
	end
	-- 激活群落报警
	ClanMgr:ActiveClanAlert()
	self:ClanRequestAlertSuccess()
	return true
end

-- function Component:UpdateCommonAlertInfo()
-- 	-- 判断是否区域/副本报警，并更新警戒值和AlarmTarget
-- 	-- 2023.10.18 xyz要求副本内只有广播的那波才有Alarmtarget，此功能只有区域保留
-- 	if self.AlertGameMode:IsInDungeon() then
-- 		return
-- 	end
-- 	if self.OnlyBaseAlertEnable then 
-- 		return
-- 	end
-- 	if self.AlarmTarget then 
-- 		return
-- 	end
-- 	if self.AlertGameMode:LevelCommonAlertDisable(self) then
-- 		return
-- 	end
-- 	if self.IsInCommonAlert and not self.AlertGameMode:IsCommonAlertingMonster(self) then
-- 		local CommonAlertSetValue = self.AlertData.CommonAlertSetValue or 40
-- 		local Value = math.max(CommonAlertSetValue, self:GetAlertValue_Lua())
-- 		self:SetAlertValue(Value, false)
-- 		local CommonAlarmTarget = self.AlertGameMode:RequestCommonAlarmTargetInfo(self)
-- 		DebugPrint("Monster Alert 区域范围报警，区域怪物收到了CommonAlarmTarget的广播---selfEid"..self.Eid.." UnitId:"..self.UnitId.." AlarmTargetEid:"..CommonAlarmTarget.Eid)
-- 		self:BroadCastChangeMonsterInfo(nil, self, {CommonAlarmTarget = CommonAlarmTarget})
-- 	end
-- end

function Component:GetAlertValue_Lua()
	return self.Owner.MonAlertComponent.AlertValue
end

-- function Component:GetAlertState_Lua(Value)
-- 	local ResValue = Value or self:GetAlertValue_Lua()
-- 	if ResValue == 0 then
-- 		return Const.NormalStateInAlert
-- 	elseif ResValue == -1 then
-- 		return Const.EndBattleState
-- 	elseif ResValue >= self:GetMaxAlertValue() then
-- 		return Const.FightState;
-- 	end
-- 	return Const.AlertState
-- end

-- function Component:SetAlertValue(SetValue, BroadCastEnable)
-- 	self.AlertValue = SetValue
-- 	self.AlertValue_Lua = SetValue
-- 	self:UpdateDecisionState()
-- 	self.BroadCastEnable = BroadCastEnable or self.BroadCastEnable
-- end

-- function Component:UpdateDecisionState()
-- 	if not self.MonDecisionStateComponent then
-- 		DebugPrint("AI 缺少 DecisionStateComponent")
-- 		return
-- 	end
-- 	local NowAlertState = self:GetAlertState_Lua()
-- 	local LastAlertState = self:GetAlertState_Lua(self.LastAlertValue)
-- 	if NowAlertState == LastAlertState then
-- 		return
-- 	end
-- 	if LastAlertState == Const.NormalStateInAlert then
-- 		self.MonDecisionStateComponent:PushState(EDecisionState.OutBattleToEnterBattle)
-- 		return
-- 	end

-- 	self.MonDecisionStateComponent:PushState(NowAlertState)
-- end

-- function Component:UpdateAlertValue(DeltaSeconds)
-- 	local AlertSpeed = self:GetAlertSpeed()
-- 	-- 副本报警状态中，警戒值只升不降
-- 	if self.AlertGameMode:IsRescueAlertingMonster(self) then
-- 		AlertSpeed = 0
-- 	elseif self.AlertGameMode:IsInDungeon() and self.IsInCommonAlert then
-- 		AlertSpeed = math.max(AlertSpeed, 0)
-- 	elseif self.AlertGameMode:IsCommonAlertingMonster(self) then
-- 		AlertSpeed = 0
-- 	end
-- 	local Value = math.ceil(self:GetAlertValue_Lua() + AlertSpeed * DeltaSeconds)
-- 	Value = math.max(math.min(Value, self:GetMaxAlertValue()), 0)
-- 	self:SetAlertValue(Value, true)
-- end

-- function Component:UpdateAlertInfo()
-- 	-- 怪物警戒值进入战斗状态，更新信息
-- 	local AlertState = self:GetAlertState_Lua()
-- 	if AlertState == Const.AlertState then 
-- 		return
-- 	elseif AlertState == Const.FightState then 
-- 		self:AddAllTargetHatred()
-- 	end
-- 	self:ClearSightHearInfo()
-- 	self:ClearTargetAlerted()
-- end

-- function Component:AlertStateChange(TargetState, BroadCastEnable)
-- 	self.LastAlertValue = self:GetAlertValue_Lua()
-- 	local AlertState = self:GetAlertState_Lua()
-- 	if AlertState == TargetState then 
-- 		return
-- 	end
-- 	if TargetState == Const.NormalStateInAlert then
-- 		self:SetAlertValue(0, false)
-- 	elseif TargetState == Const.FightState then
-- 		local Value = self:GetMaxAlertValue()
-- 		self:SetAlertValue(Value, BroadCastEnable)
-- 	elseif TargetState == Const.EndBattleState then
-- 		self:SetAlertValue(-1, false)
-- 		self.TargetHatred:Clear()
-- 		self.TargetAlerted:Clear()
-- 		-- self:AddTimer(5, function () self:SetAlertValue(0, false) end)
-- 	elseif AlertState == Const.FightState and TargetState == Const.AlertState then
-- 		local Value = math.max(math.min(self:GetAlertValue_Lua() + self.AlertResetChange, self:GetMaxAlertValue()), 0)
-- 		self:SetAlertValue(Value)
-- 		self.TargetHatred:Clear()
-- 		self:ClearSightHearInfo()
-- 		self:ClearBBAlertSoundLoc()

-- 		if self:IsRangedMonster() then 
-- 			self.AOEnable = true
-- 			self.PlayerAnimInstance.EnableAim = 0
-- 		end
-- 	end
-- end

-- function Component:UpdateAlertState()
-- 	if self.TargetHatred:Length() > 0 or self:GetOriginalTargetHatred() ~= 0 then 
-- 		self:AlertStateChange(Const.FightState, true)
-- 		self.MonAlertComponent:BroadCastInfo()
-- 	end
-- end

-- function Component:GetAlertSpeed()
-- 	local AlertValue = self:GetAlertValue_Lua()
-- 	local UpSpeed = 0
-- 	local DownSpeed = 0
-- 	for i,v in pairs(self.AlertData.AlertRanges) do
-- 		if AlertValue < v.AlertRange[2] and AlertValue >= v.AlertRange[1] then
-- 			UpSpeed = v.AlertRangeUpSpeed
-- 			DownSpeed = v.AlertRangeDownSpeed
-- 		end
-- 	end
-- 	if self.InSight then
-- 		UpSpeed = UpSpeed * (1 + 76542.4 * self.MinSightDis^-1.96483) 
-- 		return UpSpeed
-- 	elseif self.InHear then
-- 		DownSpeed = self.HearReduceAlertValue
-- 	end
-- 	return DownSpeed
-- end

-- function Component:UpdateSightInfo()
-- 	if not self.SightData then
-- 		return
-- 	end
-- 	self.InSight = false
-- 	self.MinSightDis = self.SightRadius
-- 	local InSightTargets = {}

-- 	local CampTargets = self.AlertGameMode:GetAICampResult("Enemy", self)
-- 	local SelfFor = self:GetActorForwardVector()
-- 	SelfFor:Normalize()
-- 	for _, Target in pairs(CampTargets) do
-- 		if self:CheckDistanceAndAngle(Target, SelfFor) then
-- 			table.insert(InSightTargets, Target)
-- 		end
-- 	end

-- 	self.TargetAlerted:Clear()
-- 	for i,TmpActor in pairs(InSightTargets) do 
-- 		local HitResult = FHitResult()
-- 		local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, self:K2_GetActorLocation(), TmpActor:K2_GetActorLocation(), ETraceTypeQuery.TraceEnemyVision, false, nil, 0, HitResult, true)
--     	if bHit and IsValid(HitResult.Actor) and HitResult.Actor.Eid == TmpActor.Eid then 
-- 			self.InSight = true
-- 			self:AddTargetAlerted(TmpActor.Eid)
--     	end
-- 	end
-- end

-- function Component:CheckDistanceAndAngle(Target, SelfFor)
-- 	if not IsValid(Target) then
-- 		return false
-- 	end
-- 	local Dis = (self:K2_GetActorLocation() - Target:K2_GetActorLocation()):Size()
-- 	if Dis <= self.SightRadius then
-- 		local TargetToSource = Target:K2_GetActorLocation() - self:K2_GetActorLocation()
-- 		TargetToSource:Normalize()
-- 	    local Angle = UE4.UKismetMathLibrary.DegAcos(SelfFor:Dot(TargetToSource))
-- 	    if Angle < self.SightAngle then 
-- 	    	if Dis < self.MinSightDis then 
-- 				self.MinSightDis = Dis
-- 			end
-- 	    	return true
-- 	    end
-- 	end
-- 	return false
-- end

-- function Component:AlertSetHearingInfo(SourceLoc)
-- 	if not self.InitSuccess or not self.HearData or self.InHearCD or self:GetAlertState_Lua() == Const.FightState then 
-- 		return
-- 	end
-- 	if not IsValid(self:GetOwnBlackBoardComponent()) then
-- 		return
-- 	end
-- 	self:GetOwnBlackBoardComponent():SetValueAsVector("AlertSoundLoc", SourceLoc)
-- 	self.InHearCD = true
-- 	self.UpdateHearingInfoFlag = true
-- 	self:AddTimer(self.HearCD, self.ResetHearInfoCD, false, self.HearCD, "AlertHearInfoCD")
-- end

-- function Component:UpdateHearingInfo()
-- 	if not self.HearData or not self.InHearCD or not self.UpdateHearingInfoFlag then
-- 		return
-- 	end
-- 	self.UpdateHearingInfoFlag = false
-- 	self.InHear = true
-- 	self:SetAlertValue(math.max(self.HearSetAlertValue, self:GetAlertValue_Lua()), true)
-- end

function Component:ResetHearInfoCD()
	self.InHearCD = false
end

-- function Component:ClearBBAlertSoundLoc()
-- 	if IsValid(self:GetOwnBlackBoardComponent()) then
-- 		self:GetOwnBlackBoardComponent():a("AlertSoundLoc")
-- 	end
-- end

-- function Component:ClearSightHearInfo()
-- 	self.InSight = false
-- 	self.InHear = false
-- end

-- function Component:ClearTargetAlerted()
-- 	self.TargetAlerted:Clear()
-- end

-- function Component:AddAllTargetHatred()
-- 	local Battle = Battle(self)
-- 	for i = 1, self.TargetAlerted:Length() do 
-- 		local TargetEid = self.TargetAlerted:GetRef(i)
-- 		local Target = Battle:GetEntity(TargetEid)
-- 		if IsValid(Target) then
-- 			local HatredIncrement = self:GetPresetHatredValue(Target, "ReasonAlert")
-- 			self:AddHatredTarget(Target.Eid, HatredIncrement, 0)
-- 		end
-- 	end
-- 	if IsValid(self.AlarmTarget) then
-- 		local HatredIncrement = self:GetPresetHatredValue(self.AlarmTarget, "ReasonAlert")
-- 		self:AddHatredTarget(self.AlarmTarget.Eid, HatredIncrement, 0)
-- 	end
-- end

-- function Component:BroadCastInfo()
-- 	if true then
-- 		DebugPrint("BroadCastInfo已迁移到c++，正常情况不应看到这条log")
-- 		return
-- 	end

-- 	if not self.CanBroadCastAlert or not self.BroadCastEnable then 
-- 		return 
-- 	end
-- 	if self:GetOriginalTargetHatred() ~= 0 then 
-- 		return
-- 	end
-- 	local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 	if self.LastAlertValue < self:GetMaxAlertValue() and self:GetAlertValue_Lua() >= self:GetMaxAlertValue() then
-- 		-- --触发 0/1-2
-- 		for _, Monster in pairs(GameState.MonsterMap) do
-- 			if self:CheckMonsterCanBeBroadCast(Monster) then 
-- 				-- 改仇恨列表
-- 				DebugPrint("警戒状态进行了广播 SourceEid:"..self.Eid.." TargetEid:"..Monster.Eid.." TargetUnitId:"..Monster.UnitId.."  进行了仇恨列表的同步")
-- 				self:BroadCastChangeMonsterInfo(self, Monster, {HatredTarget = 1})
-- 			end
-- 		end
-- 	-- elseif self.AlertGameMode:IsInRegion() and self.LastAlertValue <= 0 and self:GetAlertValue_Lua() > 0 then
-- 	-- 	--只有区域会触发 0-1
-- 	-- 	print("yxd @@@@@@@@@@@@@@@@ BroadCastInfo 0-1", self.Eid, self.AlertGameMode:IsCommonAlertingMonster(self))
-- 	-- 	for _, Monster in pairs(GameState.MonsterMap) do
-- 	-- 		if self:CheckMonsterCanBeBroadCast(Monster) then 
-- 	-- 			-- 改警戒值  AlertSoundLoc 警戒列表
-- 	-- 			self:BroadCastChangeMonsterInfo(self, Monster, {AlertValue = 1, AlertSoundLoc = 1, AlertInfo = 1})
-- 	-- 		end
-- 	-- 	end
-- 	end
-- end

-- function Component:BroadCastCommonAlertInfo()
-- 	-- 副本广播报警成功后的 AlarmTarget和AlertValue
-- 	if not self.CanBroadCastAlert then 
-- 		return 
-- 	end
-- 	local CommonAlertSetValue = self.AlertData.CommonAlertSetValue or 40
-- 	local CommonAlarmTarget = self.AlertGameMode:RequestCommonAlarmTargetInfo(self)
-- 	for _, Monster in pairs(UE4.UGameplayStatics.GetGameState(self).MonsterMap) do
-- 		if self:CheckMonsterCanBeBroadCast(Monster) then 
-- 			DebugPrint("Monster Alert CommonAlertInfo进行了广播 SourceEid:"..self.Eid.." TargetEid:"..Monster.Eid.." TargetUnitId:"..Monster.UnitId.."  同步了通用报警的警戒值和AlarmTarget")
-- 			self:BroadCastChangeMonsterInfo(self, Monster, {CommonAlertSetValue = CommonAlertSetValue, CommonAlarmTarget = CommonAlarmTarget})
-- 		end
-- 	end
-- end

function Component:BroadCastRescueAlertInfo()
	local Owner = self.Owner
	if not self.CanBroadCastAlert or not IsValid(Owner) then 
		return 
	end
	local CommonAlertSetValue = self.AlertData.CommonAlertSetValue or 40
	local RescueAlarmTarget = self.AlertGameMode:TriggerDungeonComponentFun("RequestRescueAlarmTargetInfo", Owner)
	DebugPrint("救援典狱长报警位即将进行广播", Owner.Eid, Owner:GetName())
	local BroadCastInfo = FBroadCastInfo()
	BroadCastInfo.CommonAlertSetValue = CommonAlertSetValue
	BroadCastInfo.CommonAlarmTarget = RescueAlarmTarget
	for _, Monster in pairs(UE4.UGameplayStatics.GetGameState(Owner).MonsterMap) do
		if self:CheckMonsterCanBeBroadCast(Monster) then 
			DebugPrint("救援RescueAlertInfo进行了广播 SourceEid:"..Owner.Eid.." TargetEid:"..Monster.Eid.." TargetUnitId:"..Monster.UnitId.."  同步了通用报警的警戒值和AlarmTarget")
			self:BroadCastChangeMonsterInfo(Owner, Monster, BroadCastInfo)
		end
	end
end

-- function Component:CheckMonsterCanBeBroadCast(Monster)
-- 	return self:RealCheckMonsterEnable(Monster, Const.NormalStateInAlert) and self.MonAlertComponent:IsAlertChannelConnected(self, Monster)
-- end


-- function Component:CheckMonsterCanBeRequest(Monster)
-- 	return self:RealCheckMonsterEnable(Monster, Const.FightState) and self.MonAlertComponent:IsAlertChannelConnected(Monster, self)
-- end

-- function Component:RealCheckMonsterEnable(Monster, TargetState)
-- 	if not IsValid(Monster) then 
-- 		return false
-- 	end
-- 	if not Monster.CanBroadCastAlert then
-- 		return false
-- 	end
-- 	if Monster == self then 
-- 		return false
-- 	end
-- 	if self.AlertGameMode:IsCommonAlertingMonster(Monster) then
-- 		return false
-- 	end
-- 	if not Monster:IsPureMonster() then 
-- 		return false
-- 	end
-- 	if Monster:GetAlertState_Lua() ~= TargetState then
-- 		return false
-- 	end
-- 	if not self:IsFriend(Monster) then 
-- 		return false
-- 	end
-- 	if (Monster:K2_GetActorLocation() - self:K2_GetActorLocation()):Size() > self.BroadCastDis then
-- 		return false
-- 	end
-- 	return true
-- end

-- function Component:BroadCastChangeMonsterInfo(Source, Target, Info)
-- 	if Info.AlertValue then
-- 		Target:SetAlertValue(Source.BroadCastAlertValue, false)
-- 	end
-- 	if Info.AlertSoundLoc then 
-- 		if IsValid(Source:GetOwnBlackBoardComponent()) and IsValid(Target:GetOwnBlackBoardComponent()) then
-- 			Target:GetOwnBlackBoardComponent():SetValueAsVector("AlertSoundLoc", Target:GetOwnBlackBoardComponent():GetValueAsVector("AlertSoundLoc"))
-- 		end
-- 	end
-- 	if Info.AlertInfo then 
-- 		Target.TargetAlerted:Clear()
-- 		for k, v in pairs(Source.TargetAlerted) do 
-- 			Target:AddTargetAlerted(v)
-- 		end
-- 	end
-- 	if Info.HatredTarget then
-- 		Target.TargetHatred:Clear()
-- 		for k, v in pairs(Source.TargetHatred) do 
-- 			Target:AddHatredTarget(k, v, 0)
-- 			Target:SetAlertValue(Target:GetMaxAlertValue(), false)
-- 		end
-- 	end
-- 	if Info.CommonAlarmTarget then
-- 		Target:BBSetAlarmTarget(Info.CommonAlarmTarget)
-- 	end
-- 	if Info.CommonAlertSetValue then
-- 		Target:SetAlertValue(Info.CommonAlertSetValue, false)
-- 	end
-- end

-- function Component:BroadCastFightInfo(DeltaSeconds)
-- 	-- 老版函数，功能：进入战斗状态的怪物 定时 向周围怪物进行仇恨列表的同步
-- 	--由于性能问题，暂时不再使用
-- 	if not self.CanBroadCastAlert then return end
-- 	if self:GetAlertState_Lua() ~= Const.FightState then return end

-- 	self.FightStateBroarCastRemainTime = self.FightStateBroarCastRemainTime - DeltaSeconds
-- 	if self.FightStateBroarCastRemainTime > 0 then 
-- 		return 
-- 	end
-- 	self.FightStateBroarCastRemainTime = self.FightStateBroarCastTime

-- 	local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 	for _, Monster in pairs(GameState.MonsterMap) do
-- 		if self:CheckMonsterCanBeBroadCast(Monster) then 
-- 			self:BroadCastChangeMonsterInfo(self, Monster, {HatredTarget = 1})
-- 		end
-- 	end
-- end

-- function Component:RequestFightInfo(DeltaSeconds)
-- 	-- 功能：未进入战斗状态的怪物 定时 向周围怪物请求战斗信息
-- 	-- 条件：依托于相关副本状态 
-- 	-- 2023.9.18 xyz要求不依托副本状态，每个怪检查自己的

-- 	-- if not self.IsInCommonAlert then
-- 	-- 	return
-- 	-- end

-- 	if not self.CanBroadCastAlert then 
-- 		return 
-- 	end
-- 	if self.AlertGameMode:IsCommonAlertingMonster(self) then
-- 		return
-- 	end
-- 	if self:GetAlertState_Lua() == Const.FightState then return end
-- 	self.FightStateBroarCastRemainTime = self.FightStateBroarCastRemainTime - DeltaSeconds
-- 	if self.FightStateBroarCastRemainTime > 0 then 
-- 		return 
-- 	end
-- 	self.FightStateBroarCastRemainTime = self.FightStateBroarCastTime
-- 	local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 	for _, Monster in pairs(GameState.MonsterMap) do
-- 		if self:CheckMonsterCanBeRequest(Monster) then 
-- 			DebugPrint("RequestFightInfo进行了广播 SourceEid:"..self.Eid.." TargetEid:"..Monster.Eid.." TargetUnitId:"..Monster.UnitId.."  进行了仇恨列表的同步")
-- 			self:BroadCastChangeMonsterInfo(Monster, self, {HatredTarget = 1})
-- 			return
-- 		end
-- 	end
-- end

-- 更新PlayerAnimInstance.EnableAim
-- function Component:UpdateAOInfo()
-- 	if not self.AOEnable then return end
-- 	local NowAlertState = self:GetAlertState_Lua()
-- 	local Target = nil
-- 	if NowAlertState == Const.FightState then 
-- 		Target = self:GetOwnBlackBoardComponent():GetValueAsObject("Target")
-- 	elseif NowAlertState == Const.AlertState then 
-- 		Target = self:GetOwnBlackBoardComponent():GetValueAsObject("AlertTarget")
-- 	end
-- 	if self:CheckAOInfoAngle(Target) then 
-- 		self.PlayerAnimInstance.EnableAim = 1
-- 		self.AOEnable = false
-- 	end

-- end

-- function Component:CheckAOInfoAngle(Target)
-- 	if not IsValid(Target) then return false end
-- 	local selfForward = self:GetActorForwardVector()
-- 	local DisForward = Target:K2_GetActorLocation() - self:K2_GetActorLocation()
-- 	selfForward:Normalize()
-- 	DisForward:Normalize()
-- 	local DotResult = selfForward:Dot(DisForward)
--     local Angle = UE4.UKismetMathLibrary.DegAcos(DotResult)
--     if Angle < 90 then 
--     	return true
--     end
-- 	return false
-- end

-- function Component:ApplyEffectStartAlarm()
-- 	self.LastAlertTimestamp = UE4.UGameplayStatics.GetRealTimeSeconds(self)
-- end

-- function Component:ApplyEffectTryAlarm()
-- 	local CurTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
-- 	if self.LastAlertTimestamp and (CurTime - self.LastAlertTimestamp >= self.CommonAlertRequestTime) then 
-- 		self:RequestCommonAlertSuccess()
-- 	end
-- end

-- function Component:IsClanMonster()
-- 	local Owner = self.Owner
-- 	if not IsValid(Owner) then 
-- 		return false 
-- 	end
-- 	-- if not Owner.ClanId or not self.AlertGameMode then
-- 	-- 	return false
-- 	-- end
-- 	local ClanMgr = self.AlertGameMode:GetClan(Owner.ClanId)
-- 	if not ClanMgr then
-- 		return false
-- 	else
-- 		return true
-- 	end
-- end

function Component:HasEnemyInClan()
	if not self:IsClanMonster() then
		return false
	end
	local Owner = self.Owner
	local ClanMgr = self.AlertGameMode:GetClan(Owner.ClanId)
	local ClanRange = 2000 -- 默认群落范围
	local ClanRangeRadius = nil
	local ClanRangeVector = nil
	local LeaveCollision = ClanMgr.leavecollision
	if LeaveCollision then
		if LeaveCollision.GetScaledBoxExtent then
			ClanRangeVector = LeaveCollision:GetScaledBoxExtent()
		end
		if LeaveCollision.GetScaledSphereRadius then
			ClanRangeRadius = LeaveCollision:GetScaledSphereRadius()
		end
	end
	-- 找到所有魅影
	local GameMode = UE4.UGameplayStatics.GetGameMode(Owner)
    if not GameMode then
		return false
    end
	local EnemyActors = GameMode:GetAICampResult(UE4.ECamp.Enemy, Owner)
    if not EnemyActors or EnemyActors:Length() == 0 then
		return false
    end
	-- local OwnerLocation = ClanMgr:K2_GetActorLocation()
	local OwnerLocation = LeaveCollision:K2_GetComponentLocation()
	for _, EnemyActor in pairs(EnemyActors) do
		local EnemyLocation = EnemyActor:K2_GetActorLocation()

        if ClanRangeVector then
            -- 使用盒体范围判断
            local RelativeLocation = EnemyLocation - OwnerLocation
            local IsInRange = math.abs(RelativeLocation.X) <= ClanRangeVector.X and
                              math.abs(RelativeLocation.Y) <= ClanRangeVector.Y and
                              math.abs(RelativeLocation.Z) <= ClanRangeVector.Z
            if IsInRange then
				return true
            end
        elseif ClanRangeRadius then
            -- 使用球体半径判断
            local Distance = UE4.UKismetMathLibrary.Vector_Distance(OwnerLocation, EnemyLocation)
            if Distance <= ClanRangeRadius then
				return true
            end
        end
	end
	ClanMgr.InCommonAlert = false
	return false
end


-------------------------------------------
return Component