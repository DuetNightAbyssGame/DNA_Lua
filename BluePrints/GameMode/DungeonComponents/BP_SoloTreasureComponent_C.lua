--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
local TimeUtils = require "Utils.TimeUtils"
---@type BP_SoloTreasureComponent_C
local M = Class({
    "BluePrints.Common.TimerMgr",
})

function M:InitSoloTreasureComponent()
	self.GameMode = self:GetOwner()
	local SoloTreasureInfo = DataMgr.SoloTreasure[self.GameMode.DungeonId]
	if not SoloTreasureInfo then
		return
	end

	self.GamePlayIds = SoloTreasureInfo.GamePlayId or {}
	self.GameTotalTime = SoloTreasureInfo.GameTotalTime or 0
	for _, GamePlayId in pairs(self.GamePlayIds) do
		local GamePlayInfo = DataMgr.SoloTreasureGamePlay[GamePlayId]
		if GamePlayInfo and GamePlayInfo.type == 1 then
			self:InitDefenceGameInfo(GamePlayInfo)
		end
	end

	self.GuideOrder = {}	-- index: Eid	-- 管理守护机关指引顺序，即ABC出现顺序
end

function M:InitSoloTreasureBaseInfo()

end

function M:TriggerSoloTreasureOnEnd()
	self:RemoveTimer("ClientSolotreasureRemainTime")
end

function M:OnSetGameStartTime(StartGameTimestamp)
	local CurrentTimestamp = StartGameTimestamp
	local Offset = TimeUtils.NowTime() - StartGameTimestamp
	local EndGameTimestamp = StartGameTimestamp + self.GameTotalTime - Offset
	self:OnSetRemainGameTime(self.GameTotalTime)
	DebugPrint("OnSetGameStartTime")
	self:AddTimer(0.1, function()
		CurrentTimestamp = math.min(TimeUtils.NowTime(), EndGameTimestamp)
		self:OnSetRemainGameTime(EndGameTimestamp - CurrentTimestamp)
		if CurrentTimestamp == EndGameTimestamp then
			self:RemoveTimer("ClientSolotreasureRemainTime")
		end
	end, true, 0, "ClientSolotreasureRemainTime", true)
end

function M:OnSetRemainGameTime(RemainTime)
	self.GameRemainTime = RemainTime
	self:OnUpdateCountDown()
end

function M:OnGetRemainGameTime()
	return self.GameRemainTime or 0
end

function M:OnTimeOver()
	self:FinishSolotreasure(false, "TimeOver")
	UIManager(self):UnLoadUINew("DungeonLevelMapMain")
end

function M:FinishSolotreasure(IsWin, Reason)
	UIManager(self):LoadUINew("SoloTreasureFinishTip", IsWin)
	--定时器结束，直接结算
	self:AddTimer(0.1, function()
		if IsWin then
			self:OnDungeonWin(Reason)
		else
			self:OnDungeonFailed(Reason)
		end
	end, false, 1.7)
end

function M:OnDungeonWin(Reason)
	self.GameMode:NotifyServerGameEnd(true, Reason)
	--self.GameMode:TriggerDungeonWin()
end

function M:OnDungeonFailed(Reason)
	self.GameMode:NotifyServerGameEnd(false, Reason)
	--self.GameMode:TriggerDungeonFailed()
end

function M:OnUpdateCountDown()
	local CountDownUI = UIManager(self):GetUI("SoloTreasureCountDownTip")
	if CountDownUI then
		CountDownUI:UpdateCountDownUI(self:OnGetRemainGameTime())
	end
	local TipUI = UIManager(self):GetUI("SoloTreasureTimeTip")
	if TipUI then
		TipUI:InitText(self:OnGetRemainGameTime())
	end
end

function M:OnTurnRainy()
	DebugPrint("ljl@ SoloTreasureComponent OnTurnRainy")
	self.GameMode:TriggerGameModeEvent("Event_OnTurnRainy")
end

function M:OnMechanismStateChange(Mechanism, StateId, LeaveStateId)
	DebugPrint("BP_SoloTreasureComponent_C : OnMechanismStateChange")
	if not IsValid(Mechanism) then
		return
	end
	if not self.HasDefenceGame then
		return
	end

	if (Mechanism.CreatorId == self.DefenceGameInteractiveStaticId) and (StateId == self.DefenceGameInteractiveStateId) and (LeaveStateId == self.DefenceGameInteractiveInitStateId) then
		DebugPrint("yly BP_SoloTreasureComponent DefenceGame Begin.")
		self.GameMode:NotifyServerDungeonEvent("DefenceGameBegin", Mechanism.CreatorId, Mechanism.ServerUniqueId, self.DefenceGamePlayId)
		local MechanismIdArray = TArray(0)
		for Id, _ in pairs(self.DefenceContainerInfos) do
			MechanismIdArray:Add(Id)
		end
		--self.GameMode:OpenGuideIconDungeon("Mechanism", 0, MechanismIdArray)
		self.GameMode:OpenGuideIconRegion(nil, MechanismIdArray)
		-- self.GameMode:OpenGuideIconRegion("Mechanism", 0, MechanismIdArray)

		-- 激活容器，切换至可被攻击状态
		for ContainerStaticId, ContainerInfo in pairs(self.DefenceContainerInfos) do
			self.GameMode:TriggerMechanism(ContainerStaticId, 1310672)
		end

		-- Open局内守护提示开始的UI
		UIManager(GWorld.GameInstance):LoadUINew("SoloTreasureHudTips01", {[1]=self.DefenceGamePlayId})

		-- 开始守护任务计时
		local CurrentTimestamp = os.time()
		local EndGameTimestamp = CurrentTimestamp + self.DefenceGameTotalTime
		self:OnSetDefenceGameRemainTime(self.DefenceGameTotalTime)
		self:AddTimer(0.1, function()
			CurrentTimestamp = math.min(os.time(), EndGameTimestamp)
			self:OnSetDefenceGameRemainTime(EndGameTimestamp - CurrentTimestamp)
			if CurrentTimestamp == EndGameTimestamp then
				self:RemoveTimer("ClientGuardTaskTimer")
			end
		end, true, 0, "ClientGuardTaskTimer", true)
	end

	local bAllContainersClaimed = true
	for ContainerStaticId, ContainerInfo in pairs(self.DefenceContainerInfos or {}) do
		if ContainerInfo.IsAlive then
			if (Mechanism.CreatorId == ContainerStaticId) and (StateId == self.ContainerRewardsClaimedStateId) then
				DebugPrint("yly		OnMechanismStateChange Mechanism.CreatorId =", ContainerStaticId, " Rewards were Claimed!")
				ContainerInfo.IsRewardsClaimed = true
			end
			if not ContainerInfo.IsRewardsClaimed then
				bAllContainersClaimed = false
			end
		end
	end
	if bAllContainersClaimed then
		-- 所有存活容器的奖励都已领取
		DebugPrint("yly		OnMechanismStateChange All Containers Rewards were Claimed!")
		EventManager:FireEvent(EventID.OnAllContainersRewardsClaimed)
	end
end

function M:OnSetDefenceGameRemainTime(RemainTime)
	self.DefenceGameRemainTime = RemainTime
end

function M:OnGetDefenceGameRemainTime()
	return self.DefenceGameRemainTime or 0
end

function M:OnShowToast(ToastType)
	if self.bForbidShowToastAgain then
		return
	end
	if ToastType == Const.DefenceGameToastType.Damaged then
		if not self:IsExistTimer("TimerToastCoolDown") then
			GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_35", 2, EToastType.Warning)
			self:AddTimer(self.ToastCD + 2, function()
				DebugPrint("yly BP_SoloTreasureComponent ToastCoolDown Finished")
				-- self:RemoveTimer("TimerToastCoolDown")
			end, false, 0, "TimerToastCoolDown")
		end
	elseif ToastType == Const.DefenceGameToastType.Destroyed then
		GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_39", 2, EToastType.Warning)
	elseif ToastType == Const.DefenceGameToastType.Fail then
		self.bForbidShowToastAgain = true
		GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_40", 2, EToastType.Failed)
	elseif ToastType == Const.DefenceGameToastType.Success then
		self.bForbidShowToastAgain = true
		GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_41", 2, EToastType.Success)
	end
end

function M:OnUnitDestoryEvent(MonsterC, CombatItemBase, DestroyReason)
	DebugPrint("yly		OnUnitDestoryEvent")
	if not self.HasDefenceGame then
		return
	end
	if not IsValid(CombatItemBase) then
		return
	end

	local StaticId = CombatItemBase.CreatorId
	if not StaticId then
		return
	end
	if not self.DefenceContainerInfos[StaticId] then
		return
	end
	if not self.DefenceContainerInfos[StaticId].IsAlive then
		return
	end
	self.DefenceContainerInfos[StaticId].IsAlive = false
	DebugPrint("yly	OnUnitDestoryEvent Mechanism CreatorId =", StaticId, " DefenceContainer was Destroyed!")

	self.GameMode:NotifyServerDungeonEvent("SpecialContainerDead", StaticId)
	if not self:IsAllDefenceContainersDead() then
		DebugPrint("yly OnUnitDestoryEvent Show Container Destroyed Toast")
		self:OnShowToast(Const.DefenceGameToastType.Destroyed)
	end
end

function M:InitDefenceGameInfo(GamePlayInfo)
	if not GamePlayInfo then
		return
	end

	self.ContainerRewardsClaimedStateId = 1310675
	self.DefenceGameInteractiveInitStateId = 1310711
	self.HasDefenceGame = true
	self.DefenceGamePlayId = GamePlayInfo.GamePlayId
	self.DefenceGameInteractiveStaticId = GamePlayInfo.Interactive
	self.DefenceGameInteractiveStateId = GamePlayInfo.InteractiveStateId
	self.DefenceGameTotalTime = GamePlayInfo.CountDown
	self.ToastCD = DataMgr.GlobalConstant.SoloTreasureGuardToastCD.ConstantValue
	self.bForbidShowToastAgain = false
	self.DefenceContainerInfos = {}		-- key: ContainerStaticId, value: table
	for Index, ContainerId in pairs(GamePlayInfo.Container or {}) do
		self.DefenceContainerInfos[ContainerId] = {
			IsAlive = true,
			GuideOrderId = Index,
			IsRewardsClaimed = false
		}
	end
end

function M:IsAllDefenceContainersDead()
	if not self.HasDefenceGame then
		return true
	end
	for ContainerStaticId, ContainerInfo in pairs(self.DefenceContainerInfos or {}) do
		if ContainerInfo.IsAlive == true then
			return false
		end
	end
	return true
end

-- 守护机关生成时会调用此方法，用于记录顺序，以便判断其ABC顺序	-- 参考挖掘流程 BP_ExcavationComponent_C
-- return GuideOrderIndex
function M:RegisterGuideOrder(StaticId)
	for ContainerStaticId, value in pairs(self.DefenceContainerInfos) do
		if StaticId == ContainerStaticId then
			return value.GuideOrderId
		end
	end
	DebugPrint("BP_SoloTreasureComponent_C: RegisterGuideOrder StaticId Failed, StaticId = ", StaticId)
	return #self.DefenceContainerInfos
end

function M:DefenceGameEnd(IsWin)
	DebugPrint("ljl@ DefenceGameEnd IsWin:", IsWin)
	if IsWin then
		-- 任务完成，可开启容器
		-- GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_41", 2, EToastType.Success)
		self:OnShowToast(Const.DefenceGameToastType.Success)
		for ContainerStaticId, ContainerInfo in pairs(self.DefenceContainerInfos) do
			if ContainerInfo.IsAlive then
				self.GameMode:TriggerMechanism(ContainerStaticId, 1310677)
			else
				self.GameMode:TriggerMechanism(ContainerStaticId, 1310676)
			end
		end
	else
		-- 容器全部被破坏，任务失败
		-- GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_40", 2, EToastType.Failed)
		self:OnShowToast(Const.DefenceGameToastType.Fail)
	end

	-- 通知任务结束
	EventManager:FireEvent(EventID.OnTaskEnded, IsWin)
end

function M:ShowRainToast()
	UIManager(GWorld.GameInstance):LoadUINew("LeaveSoloTreasureRainTips")
end

return M
