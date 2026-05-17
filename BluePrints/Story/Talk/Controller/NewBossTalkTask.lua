local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local EDialogueNodeType = TalkUtils.EDialogueNodeType

local ShowUIDialoguePanel = function(UI)
	UI.Dialogue_Boss:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

local CollapseUIDialoguePanel = function(UI)
	if IsValid(UI) then
		UI.Dialogue_Boss:SetVisibility(ESlateVisibility.Collapsed)
	end
end

local M = Class("BluePrints.Story.Talk.Controller.TalkTaskBase")

function M:Start(TalkTaskData, TaskFinished_Callback)
	M.Super.Start(self, TalkTaskData, TaskFinished_Callback)
	self.NodeFinished_Callback = TaskFinished_Callback
    self:InitUI()
    AudioManager(GWorld.GameInstance):AddAuANotifyForbidTag(self.UnitKey)
	EventManager:AddEvent(EventID.OnTeamRecoveryStateChange, self, self.HandleOnTeamRecoveryStateChange)

    self:StartPlayDialogue()
end

function M:Clear()
	DebugPrint("NewBossTalkTask:Clear")
    self:ClearUI()
    self:ClearAudio()
    self:ClearAllTimers()
    AudioManager():RemoveAuANotifyForbidTag(self.UnitKey)
	EventManager:RemoveEvent(EventID.OnTeamRecoveryStateChange, self)
end

function M:PlayDialogue(bPauseResume)
	local NodeType = self.DialogueIterationComponent:GetCurrentNodeType()
	if (NodeType ~= EDialogueNodeType.Dialogue) then
		DebugPrint("lhr@Dialogue Iteration Error: NodeType", NodeType, "不合法")
		return
	end
	local CurrentDialogue = self.DialogueIterationComponent:GetDialogue()
	if (not CurrentDialogue) then
		DebugPrint("lhr@Dialogue Iteration Error: Dialogue为空")
		return
	end

    if bPauseResume and self.bAudioFinished then
        return
    end

	local Content = TalkUtils:DialogueIdToContent(CurrentDialogue.DialogueId)
	if not Content then
		self:IterateDialogue()
		return
	end
	self:OnPlayingDialogue(CurrentDialogue)

	self.UI.Text_Boss:SetText(Content)

	local Duration = CurrentDialogue.Duration or 1
	local bTimerFinish = false
    if CurrentDialogue.VoiceName then
	    self.bAudioFinished = false		
	    self:PlayAudio(CurrentDialogue, function(bUnFinished)
			if not bUnFinished then
                self.bAudioFinished = true
                if bTimerFinish then
                	self:IterateDialogue()
                end
            end
		end, nil, bPauseResume)	
	else
		self.bAudioFinished = true
	end
	self.TalkContext.TalkTimerManager:AddTimer(self, Duration, nil, nil, nil, function()
		bTimerFinish = true
        if self.bAudioFinished then
            self:IterateDialogue()
        end
	end)
end

function M:InitUI()
	self.UI = self:CreateBattleMainUI()
	local PlayerCharacter = GWorld:GetMainPlayer()
	if (PlayerCharacter:IsDead()) then
		CollapseUIDialoguePanel(self.UI)
	else
		ShowUIDialoguePanel(self.UI)
	end
end

function M:CreateComponents()
    M.Super.CreateComponents(self)

    if not self.TaskData then
        return
    end

    self.TalkTaskData = self.TaskData
    self.TalkContext = self.TaskData.TalkContext
    self.TalkTimerManager = self.TalkContext.TalkTimerManager

    self:CreateDialogueIteratorComponent()
    self:CreateTalkAudioComponent()
end

function M:CreateBattleMainUI()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local BattleMain = UIManager:GetUIObj("BattleMain")
	return BattleMain
end

function M:HandleOnTeammateRecovery(Eid)
	local Entity = GWorld.Battle:GetEntity(Eid)
	if (Entity and Entity.IsMainPlayer and Entity:IsMainPlayer()) then
		ShowUIDialoguePanel(self.UI)
	end
end

function M:HandleOnCharWaitingResurgence(Eid)
	local Entity = GWorld.Battle:GetEntity(Eid)
	if (Entity and Entity.IsMainPlayer and Entity:IsMainPlayer()) then
		CollapseUIDialoguePanel(self.UI)
	end
end

function M:HandleOnTeamRecoveryStateChange(Eid, State, PrevState)
	if State == UE4.ETeamRecoveryState.IsWaitingRecover and PrevState == UE4.ETeamRecoveryState.Dying then
		self:HandleOnCharWaitingResurgence(Eid)
	elseif State == UE4.ETeamRecoveryState.Alive and PrevState == UE4.ETeamRecoveryState.IsWaitingRecover then
		self:HandleOnTeammateRecovery(Eid)
	end
end

function M:EndDialogue()
    self:Finish()
end

function M:Finish()
	self:Clear()
    self:TryEndFlowGraph()
	if self.NodeFinished_Callback and self.NodeFinished_Callback[2] then
        local NodeFinished_Obj = self.NodeFinished_Callback[1]
        local NodeFinished_Func = self.NodeFinished_Callback[2]
        NodeFinished_Func(NodeFinished_Obj, self)
    end
end

function M:ClearUI()
	CollapseUIDialoguePanel(self.UI)
end

function M:OnExceptionInterruptedBySTL()
    DebugPrint("NewBossTalkTask:OnExceptionInterruptedBySTL")
    TalkUtils:RemovePlayerInvincible()
    self.NodeFinished_Callback = nil
end

function M:OnInterrupted()
    DebugPrint("NewBossTalkTask:OnInterrupted")
    self.bHasInterrupted = true
    self:Clear()
end

function M:OnPaused()
    DebugPrint("NewBossTalkTask:对话被暂停", self)
    self:PauseAllTimers(true)
    if not self.bAudioFinished then
        self:PauseAudio()
    end
end

function M:OnPauseResumed()
    if self.bHasInterrupted then
        return
    end
    DebugPrint("NewBossTalkTask:对话暂停恢复", self)
    self:PauseAllTimers(false)
    self.DialogueIterationComponent:Resume()
    if not self.bAudioFinished then
        self:ResumePauseAudio()
    end
end

return M
