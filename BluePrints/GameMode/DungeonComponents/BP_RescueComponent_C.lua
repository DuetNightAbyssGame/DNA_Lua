require "UnLua"

local BattleUtils = require "Utils.BattleUtils"
local EMLuaConst = require "EMLuaConst"
local BP_RescueComponent_C = Class({
"BluePrints.Common.TimerMgr",
})


function BP_RescueComponent_C:InitRescueComponent()
	self.GameMode = self:GetOwner()
	--self.RescueAlertingEid = 0 已移到C++的GameMode中
	self.HostageStaticId = 0
	self:SetHostageEid(0)
	self.RescueIsInCommonAlert = false
	self.RescueAlarmTarget = nil

	self.IsHostageRescued = false				-- 人质是否被解救，人质解救后不再触发倒计时
	self.IsRescueCountDownTriggered = false		-- 倒计时是否触发过，如果触发过倒计时典狱长则不会报警，倒计时仅可触发一次

	self.IsHostageSpawned = false				-- 人质是否已生成，防止重复生成
end

function BP_RescueComponent_C:GetHostageEid()
	return self.HostageEid
end

function BP_RescueComponent_C:SetHostageEid(Eid)
	self.HostageEid = Eid
end

function BP_RescueComponent_C:InitRescueBaseInfo()
	-- Id为临时版本，之后导表
	local StaticIds = {}
	for i = 1010000001, 1010000008 do
		if self.GameMode.EMGameState:GetStaticCreatorInfo(i) then
			table.insert(StaticIds, i)
		end
	end
	if #StaticIds < 1 then 
		GameState(self):ShowDungeonError("RescueComponent:救援玩法内未找到人质刷新点,请检查蓝图配置，当前副本Id: "..self.GameMode.DungeonId..", 当前Json: "..UE4.URuntimeCommonFunctionLibrary.GetLevelLoadJsonName(self.GameMode), Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end
	local Index = math.random(1, #StaticIds)
	self.HostageStaticId = StaticIds[Index]
	DebugPrint("RescueComponent: 救援玩法 当前人质静态点为： ", self.HostageStaticId)
end

function BP_RescueComponent_C:TriggerSpawnHostage(Player)
	if self.IsHostageSpawned then
		return
	end
	self.IsHostageSpawned = true

	self:StopRescueCountDown()
	self:RemoveHostageDoorIndicator()

	local Creator = self.GameMode.EMGameState:GetStaticCreatorInfo(self.HostageStaticId)
	local HostageExtraInfo = BattleUtils.GetExtraCreateInfo(Creator.UnitType, Creator.UnitId, Creator.UnitId)
	if Player then
		HostageExtraInfo.PhantomOwnerEid = Player.Eid
	end
	HostageExtraInfo.EventName = "RescueHostage"
	if EMLuaConst.IsOpenEscortNPCPhantomOpt == false then
 		Creator:RealActiveStaticCreator(HostageExtraInfo)
	else
		local HostageChar = GameState(self):GetHostagePhantomAIFromPreLoadCache(Creator.UnitId, self.HostageStaticId)
		if HostageChar then
			DebugPrint("LHQ@@@RescueComponent: 救援玩法 UseSpawnedHostage")
		end
	end
	
	DebugPrint("RescueComponent: 救援玩法 TriggerSpawnHostage")
end

function BP_RescueComponent_C:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
	if EventName == "RescueHostage" then
		self:SetHostageEid(Eid)
		DebugPrint("RescueComponent: 救援玩法 生成人质，当前人质Eid为： ", self:GetHostageEid())
		local Hostage = Battle(self):GetEntity(self:GetHostageEid())
		if IsValid(Hostage) then
			Hostage:StopBT("RescueDoor")
			Hostage:ActiveHostageGuide("Add", Eid)		-- 服务端不该走更新指引逻辑，@lhq修改

			self.GameMode:TriggerGameModeEvent("OnSpawnHostage")
			self.GameMode:TriggerDungeonAchieve("OnHostageRescued", -1)
			if self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
				self.GameMode:TriggerSpawnPet()
			end

			GameState(self):SyncHostageState(Hostage)

			self.IsHostageRescued = true
		end
	end
end

function BP_RescueComponent_C:TriggerStartHostageBT()
	local Hostage = Battle(self):GetEntity(self:GetHostageEid())
	if IsValid(Hostage) then
		Hostage:RestartBT()
		DebugPrint("RescueComponent: 开启人质行为树，Eid:", self:GetHostageEid())
	end
end

function BP_RescueComponent_C:TriggerRescueExitMechanismOverlap(Player)
	DebugPrint("RescueComponent: 救援玩法有玩家到达撤离点, Player Eid =", Player.Eid)

	local Hostage = Battle(self):GetEntity(self:GetHostageEid())
	if Hostage == nil then
		DebugPrint("RescueComponent Error: 人质未刷出，无法移动到撤离机关")
		return
	end
	
	local ExitMachanism = self.GameMode:GetEscapeMechanismActor()
	if ExitMachanism == nil then
		DebugPrint("RescueComponent Error: 撤离机关不存在，人质移动无目标")
		return
	end
	
	UE4.UNavigationFunctionLibrary.ActorToActorTeleport(Hostage, ExitMachanism)
	Hostage:StopBT("RescueHostageSucceed")
end

function BP_RescueComponent_C:TriggerRescuePlayerDungeonEnd(Player)
	if self.GameMode.EMGameState:CheckGameModeStateNotEnd() then
		Player:ChangeHostageOwner()
	end
end

function BP_RescueComponent_C:TriggerRescueOnEnd()
	local Hostage = Battle(self):GetEntity(self:GetHostageEid())
	if Hostage then
		Hostage:EMActorDestroy(EDestroyReason.HostageRescueEnd)
	end
end

function BP_RescueComponent_C:AddHostageDoorIndicator()
	if not self.RescueGuideShowEnable then
		self.RescueGuideShowEnable = true
		local IgnoreList = TArray(0)
		IgnoreList:Add(self.HostageDoor.Eid)
		self.HostageDoor:DeactiveAllGuide(IgnoreList)
		-- self.GameMode.EMGameState:AddGuideEid(self.HostageDoor.Eid)
	end
end

function BP_RescueComponent_C:RemoveHostageDoorIndicator()
	if self.RescueGuideShowEnable then
		self.RescueGuideShowEnable = false
		-- self.GameMode.EMGameState:RemoveGuideEid(self.HostageDoor.Eid)
	end
end

function BP_RescueComponent_C:TriggerRescueTimerLowEvent()
	if not self.RescueLowTimeTriggered then
		self.RescueLowTimeTriggered = true
		self.GameMode:TriggerGameModeEvent("OnRescueCountDownLow")
	end
end

function BP_RescueComponent_C:OnHostageDie(Hostage)
	if Hostage.Eid == self:GetHostageEid() then
		DebugPrint("RescueComponent: 人质死亡！")
		self.GameMode:TriggerGameModeEvent("OnHostageDieBP")
		self.GameMode:TriggerDungeonFailed()
	end
end

function BP_RescueComponent_C:OnHostageDying(Hostage)
	if Hostage.Eid == self:GetHostageEid() then
		DebugPrint("RescueComponent: 人质倒地！")
		self.GameMode:TriggerGameModeEvent("OnHostageDyingBP")

		local NowTime = URuntimeCommonFunctionLibrary.GetNowTimeStamp()
		self.GameMode:AddDungeonEvent("HostageDyingCountDown")
	end
end

function BP_RescueComponent_C:SetRescueHostageDoor(Door)
	self.HostageDoor = Door
end

--------------- 处决倒计时相关 ---------------
function BP_RescueComponent_C:StartRescueCountDown()
	if self.IsRescueCountDownTriggered then
		DebugPrint("RescueComponent: 倒计时已触发，不重复添加")
		return
	end
	if self.IsHostageRescued then
		DebugPrint("RescueComponent: 人质已解救，不触发倒计时")
		return
	end

	local DungenData = DataMgr.Rescue[self.GameMode.DungeonId]
	if DungenData == nil then
		DebugPrint("RescueComponent Error: 副本表数据不存在, DungeonId =", self.GameMode.DungeonId)
	end
	self.GameMode.EMGameState:SetRescueCountDownTime(DungenData.HostageRescueTime or 0)
	self.RescueLowTimeThreshold = DungenData.RescueLowTimeThreshold or 0
	self.RescueLowTimeTriggered = false

	self.IsRescueCountDownTriggered = true
	self:AddTimer(1, self.RescueCountDown, true, 0, "RescueCountDownTimer")
	self.GameMode:AddDungeonEvent("RescueCountDownUI")
	self.GameMode:TriggerGameModeEvent("OnRescueCountDownStart")

	DebugPrint("RescueComponent: 处决倒计时开始！时间", DungenData.HostageRescueTime)
end

function BP_RescueComponent_C:RescueCountDown()
	self:AddToRescueCountDownTime(-1)
	DebugPrint("RescueComponent: RescueCountDownTime =", self:GetRescueCountDownTime())
	if self:GetRescueCountDownTime() <= self.RescueLowTimeThreshold then
		self:TriggerRescueTimerLowEvent()
		self:AddHostageDoorIndicator()
	end

	if self:GetRescueCountDownTime() <= 0 then
		self:RemoveHostageDoorIndicator()

		self:StopRescueCountDown()
		self.GameMode:TriggerGameModeEvent("OnHostageDieBP")
		self.GameMode:TriggerDungeonFailed()
	end
end

function BP_RescueComponent_C:StopRescueCountDown()
	if not self.IsRescueCountDownTriggered then 
		return 
	end
	self:RemoveTimer("RescueCountDownTimer")
	self.GameMode:RemoveDungeonEvent("RescueCountDownUI")
	DebugPrint("RescueComponent: 处决倒计时关闭！")
end

function BP_RescueComponent_C:AddToRescueCountDownTime(Value)
	self.GameMode.EMGameState:SetRescueCountDownTime(math.max(0, self.GameMode.EMGameState.RescueCountDownTime + Value))
	if IsStandAlone(self) then
		self.GameMode.EMGameState:OnRep_RescueCountDownTime()
	end
end

function BP_RescueComponent_C:GetRescueCountDownTime()
	return self.GameMode.EMGameState.RescueCountDownTime
end
---------------------------------------------------

--------------- 典狱长专用报警位相关 ---------------
function BP_RescueComponent_C:TriggerRescueAlert(Monster)
	-- 触发人质救援倒计时，并且把监狱长警戒值拉满
	self:StartRescueCountDown()
	if Monster.MonAlertComponent then
		Monster.MonAlertComponent:AlertStateChange(Const.FightState, true)
		Monster.MonAlertComponent:RequestRescueAlertSuccess()
	end
	DebugPrint("RescueComponent: 救援玩法触发监狱长警戒, RescueCountDownTime =", self:GetRescueCountDownTime())
end

function BP_RescueComponent_C:TrySetRescueAlertingInfo(LastTargetAlertedNum, Monster)
	if not IsValid(Monster) then
		return false
	end
	if self.GameMode:GetRescueAlertingEid() ~= 0 then
		return false
	end
	if not Monster:IsJailerMonster() then
		return false
	end
	if self.RescueIsInCommonAlert then
		return false
	end
	if self.IsRescueCountDownTriggered then
		--DebugPrint("RescueComponent: 倒计时已触发过，典狱长不再报警")
		return false
	end
	-- if LastTargetAlertedNum == 0 and Monster.TargetAlerted:Num() > 0 then
	if Monster.TargetAlerted:Num() > 0 then
		-- 目前只有典狱长在救援玩法内可以额外抢占报警位
		--抢占成功，进行报警
		self.GameMode:SetRescueAlertingEid(Monster.Eid)
		self.RescueAlarmTarget = Battle(self):GetEntity(Monster.TargetAlerted[1])

		local MonAlertComponent = Monster.MonAlertComponent
		if MonAlertComponent then
			MonAlertComponent:SetAlertValue(math.floor(MonAlertComponent.MaxAlertValue-1),false)
		end
		Monster:BBSetAlarmTarget(self.RescueAlarmTarget)
		Monster:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", true)
		DebugPrint("RescueComponent: 救援玩法典狱长抢占报警位成功，开始报警动画---Eid:"..Monster.Eid.." UnitId:"..Monster.UnitId.." Loc:"..tostring(Monster:K2_GetActorLocation()).." AlarmTargetLoc:"..tostring(self.RescueAlarmTarget:K2_GetActorLocation()))
		return true
	end
	return false
end

function BP_RescueComponent_C:IsRescueAlertingMonster(Monster)
	if not Monster:IsJailerMonster() then
		return false
	end
	return Monster.Eid == self.GameMode:GetRescueAlertingEid()
end

function BP_RescueComponent_C:TryResetRescueAlertingInfo(Monster)
	if Monster.Eid == self.GameMode:GetRescueAlertingEid() then
		DebugPrint("RescueComponent: 救援玩法典狱长重置报警位成功", Monster.Eid)
		self.GameMode:SetRescueAlertingEid(0)
		Monster:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", false)
	end
end

function BP_RescueComponent_C:RequestRescueAlarmTargetInfo(Monster)
	if self.RescueAlarmTarget ~= nil then
		return self.RescueAlarmTarget
	end
	local MinDistance, ResPlayer = nil, nil
	for _, Player in pairs(self:GetAllPlayer()) do
		local PlayerDistance = UE4.UKismetMathLibrary.Vector_Distance(Player:K2_GetActorLocation(), Monster:K2_GetActorLocation())
		if MinDistance == nil or PlayerDistance < MinDistance then
			MinDistance, ResPlayer = PlayerDistance, Player
		end
	end
	return ResPlayer
end
------------------------------------------------------------

return BP_RescueComponent_C

