--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TrialComponent_C
require "UnLua"

local BP_TrialComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

--------------------GameMode 流程&事件相关------------------------

function BP_TrialComponent_C:InitTrialEventInfo()
    --角色试玩id  
    self.CharTrialId = self.GameMode.PreInitInfo.CharTrialId
end

--试玩关卡信息
function BP_TrialComponent_C:InitTrialDungeonInfo()
    -- 角色试玩关卡副本信息
	self.TrialDungeonInfo = DataMgr.Trial[self.CharTrialId]
    if not self.TrialDungeonInfo then
		DebugPrint("无法找到当前角色试玩信息。读入角色Id：", self.CharTrialId)
		return
	end
	--获取角色试玩任务列表
	self.TaskList = self.TrialDungeonInfo.Tasks
end



function BP_TrialComponent_C:UpdateTaskInfo(TaskIndex)
	self.CurrentTaskInfo = DataMgr.TrialTask[self.TaskList[TaskIndex]]
	if not self.CurrentTaskInfo then
		DebugPrint("thy   试玩任务信息不存在，请检查以下地方是否有问题！ 1.传入参数TaskIndex(任务编号) 2.Trial表中对应角色的试玩任务列表 3.TrialTask表中是否包含2中的TaskId")
	end
	self.TaskIndex = TaskIndex
	self.WidgetPath = self.CurrentTaskInfo.WidgetPath
	self.TexturePath = self.CurrentTaskInfo.TexturePath
	self.TextTitle = self.CurrentTaskInfo.TextTitle
	self.TextMap = self.CurrentTaskInfo.TextMap
	self.IsKillMonsterTask = self.CurrentTaskInfo.IsKillMonsterTask
	--有杀怪任务才获取下面两个值
	if self.IsKillMonsterTask then
		self.MonsterSpawnId = self.CurrentTaskInfo.MonsterSpawnId
		self.TargetNum = self.CurrentTaskInfo.TargetNum
		DebugPrint("thy     self.TargetNum", self.TargetNum)
		self.GameMode.EMGameState:SetTrialKilledNum(0)
		self.GameMode.EMGameState:SetTrialTotalNum(self.TargetNum)
		self.GameMode.EMGameState:OnRep_TrialKilledNum()
		--显示进度UI
		self:HideOrShowProgress(true)
	end
end

function BP_TrialComponent_C:InitTrialComponent()
	self.GameMode = self:GetOwner()
	self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	self.NowGuideEid = nil  -- NowMonsterGuideEid
	self.HasGuideUpdateRequest = false
	self.IsCompleteTrial = false
	self:InitTrialEventInfo()
	self:InitTrialDungeonInfo()
	--self.GameMode.EMGameState:SetTrialTotalNum(self.TargetNum)
end

function BP_TrialComponent_C:ShowArmory()
	local QuestRoleId = DataMgr.CharTrial[self.CharTrialId].QuestRoleId
	local Avatar = GWorld:GetAvatar()
	local SquadInfo, TempAvatar = AvatarUtils:GetSquadInfoByQuestRoleId(QuestRoleId, Avatar)
	local Params = {IsPreviewMode = true,
		EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
		IsCharacterTrialMode = true,
		Avatar = TempAvatar,
	}
	UIUtils.GenerateArmoryPreviewParamsBySquadInfo(Params,SquadInfo)
	UIManager(self):LoadUINew("ArmoryDetail",Params)
end

function BP_TrialComponent_C:ShowTrialTask(TaskIndex)
	DebugPrint("THy    TaskIndex", TaskIndex)
	--更新任务信息
	self:UpdateTaskInfo(TaskIndex)
	self.GameMode:NotifyClientShowDungeonTaskNew(self.TexturePath, self.TextTitle, self.TextMap)
	if self.IsKillMonsterTask then 
		local MonsterSpawnArr = TArray(0)
		for index, value in pairs(self.MonsterSpawnId) do
			MonsterSpawnArr:Add(self.MonsterSpawnId[index])
		end
		DebugPrint("THy    TriggerCreateMonsterSpawn")
		self.GameMode:TriggerCreateMonsterSpawn(MonsterSpawnArr)
		self:InitGuideUpdateTimerLogic()--初始化指引
		local BattleProgress = UIManager(self):GetUIObj("Trial_BattleProgress")
		if BattleProgress then
			DebugPrint("BattleProgress is show")
			BattleProgress:SetTrialBattleVisibility(true)
		end
	end
end

function BP_TrialComponent_C:InitTrialBaseInfo()
	DebugPrint("thy   InitTrialBaseInfo------InitGuideUpdateTimerLogic")
	--self:InitGuideUpdateTimerLogic()
end

function BP_TrialComponent_C:InitGuideUpdateTimerLogic()
	self.GuideTimerHandle_DetectFault = "Handle_DetectFault"	-- 自动检测指引点是否存在
    --试玩玩法指引点自动刷新间隔
	self.GuideTimerInterval_AutoUpdate = DataMgr.GlobalConstant.TrialGuideInterval.ConstantValue or 5
	self:AddGuideTimer_DetectFault()							-- 初始进关卡显示指引/自动检测指引是否存在
    self.HasGuideUpdateRequest = false
    self:AddGuideTimer_AutoUpdate()
end

function BP_TrialComponent_C:AddGuideTimer_AutoUpdate()
	if self.Player then
		self:AddTimer(self.GuideTimerInterval_AutoUpdate, self.OnTimerEnd_AutoUpdate, true, 0, "Handle_AutoUpdate", nil, self.Player.Eid)
	end
end

function BP_TrialComponent_C:OnTimerEnd_AutoUpdate()
	if self.Player then
		DebugPrint("TrialComponent: 自动更新RemoveGuideEid 被Remove的指引点Eid: "..tostring(self.NowGuideEid).."  Player Eid: "..tostring(self.Player.Eid))
		self.GameMode.EMGameState:RemoveGuideEid(self.NowGuideEid, self.Player.Eid)
		self:TryUpdateGuidePoint()
	end
end

function BP_TrialComponent_C:AddGuideTimer_LimitCalls()
	if self.Player then
		self:AddTimer(1, self.OnTimerEnd_LimitCalls, false, 0, "Handle_LimitCalls", nil, self.Player.Eid)
	end
end

function BP_TrialComponent_C:OnTimerEnd_LimitCalls()
	if self.HasGuideUpdateRequest then
		self:UpdateNearestMonsterGuide()
		self.HasGuideUpdateRequest = false
	end
end

function BP_TrialComponent_C:AddGuideTimer_DetectFault()
	self:AddTimer(2, self.OnTimerEnd_DetectFault, true, 0, self.GuideTimerHandle_DetectFault)
end


function BP_TrialComponent_C:OnTimerEnd_DetectFault()
    if self:CheckGuideLogicHasFault() then
		self:TryUpdateGuidePoint()
	end
end

function BP_TrialComponent_C:CheckGuideLogicHasFault()
	if not self.Player then
		return true
	end
	if not self.NowGuideEid then
		return true
	end
	if not self.GameMode.EMGameState:ContainsGuideEid(self.NowGuideEid, self.Player.Eid) then
		return true
	end
	return false
end

function BP_TrialComponent_C:TryUpdateGuidePoint()
	if self:IsExistTimer("Handle_LimitCalls") then
		self.HasGuideUpdateRequest = true
	else
		self:UpdateNearestMonsterGuide()
		self:AddGuideTimer_LimitCalls()
	end
end

function BP_TrialComponent_C:OnUnitDeadEvent(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
	if not IsValid(MonsterC) then
		return
	end
	if not MonsterC:IsRealMonster() then
		return
	end
	if not self.Player then
		return
	end
	self:AddTrialKilledNum(1)
	self:CheckTargetNum()
	self.GameMode.EMGameState:RemoveGuideEid(self.NowGuideEid, self.Player.Eid)
	self:TryUpdateGuidePoint()
	self:AddGuideTimer_AutoUpdate()  -- 直接刷新该角色自动间隔计时器
	DebugPrint("TrialComponent: OnUnitDeadEvent", MonsterC:GetName(), MonsterC.Eid, self.Player.Eid)
end

function BP_TrialComponent_C:AddTrialKilledNum(Num)
	self.GameMode.EMGameState:SetTrialKilledNum(self.GameMode.EMGameState.TrialKilledNum + Num)
	if IsStandAlone(self) then
		self.GameMode.EMGameState:OnRep_TrialKilledNum()
	end
end

function BP_TrialComponent_C:UpdateNearestMonsterGuide()
	if not self.Player then 
		DebugPrint("thy ERROR:  self.Player is nil")
		return 
	end
	local MonsterEid = self.GameMode:GetNearestMonsterEid(self.Player)
	if MonsterEid ~= nil and MonsterEid > 0 then
		self.NowGuideEid = MonsterEid
		self.GameMode.EMGameState:AddGuideEid(MonsterEid, self.Player.Eid)
		DebugPrint("TrialComponent: 已成功添加指引点 指引点Eid: " .. MonsterEid .. "  Player Eid: " .. self.Player.Eid)
	else
		DebugPrint("TrialComponent: Error  当前场上找不到怪物!")
	end
end

function BP_TrialComponent_C:ClearGuideUpdateTimerLogic()
	if self.Player then
		self.GameMode.EMGameState:RemoveGuideEid(self.NowGuideEid, self.Player.Eid)
		self.NowGuideEid = nil
		self:RemoveTimer(self.GuideTimerHandle_DetectFault)
		self.GameMode.EMGameState:ClearGuideEid(self.Player.Eid)
		self:RemoveTimer("Handle_AutoUpdate")
		self:RemoveTimer("Handle_LimitCalls")
	end
end

function BP_TrialComponent_C:CheckTargetNum()
	self.TargetNum = self.TargetNum - 1
	if self.TargetNum <= 0 and not self.IsCompleteTrial then
		local TryOutTips = UIManager(self):LoadUINew("TryOut_Victory", GText("UI_CharTrial_FinishTitle"), GText("UI_CharTrial_FinishText"), GText("UI_TRAIN_CLOSE"))
		TryOutTips.Btn_FullScreen.OnClicked:Add(self, function()
			AudioManager(self):SetEventSoundParam(nil, "TryOut_Victory", {ToEnd = 1})
		end)
		AudioManager(self):PlayUISound(nil, "event:/ui/common/complete_trial_level_panel_show", "TryOut_Victory", nil)
		self.IsCompleteTrial = true
		self.GameMode:TriggerGameModeEvent("OnAchieveTarget")
	end
end

--销毁刷怪规则和清除场景中的怪
function BP_TrialComponent_C:DestroyAllMonsterAndRuleByUnitId()
	local MonsterSpawnArr = TArray(0)
	for index, value in pairs(self.MonsterSpawnId) do
		DebugPrint("thy     OnPlayerDead and DestroyMonsterByUnitSpawnId", self.MonsterSpawnId[index])
		MonsterSpawnArr:Add(self.MonsterSpawnId[index])
	end
	DebugPrint("thy     OnPlayerDead and DestroyMonsterByUnitSpawnId")
	self.GameMode:TriggerMonsterSpawn(ETriggerMonsterSpawnType.DestroyAll, MonsterSpawnArr)
end

--重置关卡
function BP_TrialComponent_C:ResetMechanism()
	--找到机关
	local MechanismTable = self.GameMode.EMGameState.MechanismMap:FindRef('MiniGame').Array:ToTable()
	local Mechanism = MechanismTable[1]
	if not Mechanism then 
		return 
	end
	DebugPrint("thy MechanismName: ", Mechanism:GetName())
	local StaticCreatorArray = TArray(0)
	--机关的静态点id为490121
	StaticCreatorArray:Add(490121)
	--反激活
	self.GameMode:TriggerInactiveStaticCreator(StaticCreatorArray)
	-- MechanismMap中被反激活的机关清掉
	self.GameMode.EMGameState.MechanismMap:FindRef('MiniGame'):RemoveAt(0)
	--激活
	self.GameMode:TriggerActiveStaticCreator(StaticCreatorArray)
	--隐藏进度UI
	self:HideOrShowProgress(false)
end

function BP_TrialComponent_C:HideOrShowProgress(bShow)
	local ProgressUI = UIManager(self):GetUIObj("Trial_BattleProgress")
	if ProgressUI then
		if bShow then
			ProgressUI:SetVisibility(ESlateVisibility.Visibie)
		else
			ProgressUI:SetVisibility(ESlateVisibility.Collapsed)
		end

	end
end

--移除指引
function BP_TrialComponent_C:RemoveAllGuideEids()
	if self.Player then
		self.GameMode.EMGameState:RemoveGuideEid(self.NowGuideEid, self.Player.Eid)
	end
end

--角色死亡逻辑
function BP_TrialComponent_C:OnPlayerDead()
	if self.TaskIndex == 3 then return end --如果玩家在杀完怪,生成撤离点后死亡,不需要重置试玩关卡
	--重置关卡
	self:ResetMechanism()
	--移除怪物指引
	self:RemoveAllGuideEids()
	--销毁刷怪规则和清除场景中的怪
	self:DestroyAllMonsterAndRuleByUnitId()
	--进入任务1
	self:ShowTrialTask(1)
end


return BP_TrialComponent_C
