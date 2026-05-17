local ETalkNodeFinishType = require 'StoryCreator.StoryLogic.StorylineUtils'.ETalkNodeFinishType
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local EDialogueNodeType = TalkUtils.EDialogueNodeType

--- @class LightTalkTask : TalkTaskBase_C
local LightTalkTask = Class({ "BluePrints.Story.Talk.Controller.TalkTaskBase" })

function LightTalkTask:InitData(TalkTaskData, NodeFinished_Callback)
    self.ExecutedComps = {}
    self.NodeFinished_Callback = NodeFinished_Callback
    self.TalkTaskData = TalkTaskData
    self.TalkContext = TalkTaskData.TalkContext
    self.TalkActionManager = self.TalkContext.TalkActionManager
    self.TalkTimerManager = self.TalkContext.TalkTimerManager
    self.WaitQueueManager = self.TalkContext.WaitQueueManager
    self.bTaskPlayDialogueFinished = false
    self.Player = TalkTaskData.Player
end

function LightTalkTask:InitUI()
	if (not self.TalkTaskData) or (not self.TalkTaskData.UIName) then
		return
	end

    self.UI = UIManager(GWorld.GameInstance):LoadUINew(self.TalkTaskData.UIName)
    if (self.TalkType == "ForgingGuide") then
        self.UI:SetForgeVisibility(true)
    end
end

function LightTalkTask:Start(TalkTaskData, NodeFinished_Callback)
    LightTalkTask.Super.Start(self, TalkTaskData, NodeFinished_Callback)
    DebugPrint("LightTalkTask:Start:", TalkTaskData.TalkNodeId)
    AudioManager(GWorld.GameInstance):AddAuANotifyForbidTag(self.UnitKey)
    self:InitData(TalkTaskData, NodeFinished_Callback)
    self:InitUI()
    EventManager:AddEvent(EventID.InLoading, self, self.InLoading)
    self:StartPlayDialogue()
end

function LightTalkTask:Finish(TalkNodeFinishType)
    DebugPrint("LightTalkTask:Finish:", self.TalkTaskData.TalkNodeId)
    if IsValid(self.UI) and self.UI.OnFinished then
        self.UI:OnFinished(function()
            self:RealFinish(TalkNodeFinishType)
        end)
    else
        self:RealFinish(TalkNodeFinishType)
    end
end

function LightTalkTask:Clear()
    DebugPrint("LightTalkTask:Clear")
    AudioManager(GWorld.GameInstance):RemoveAuANotifyForbidTag(self.UnitKey)
    self:RemoveDialogueEffectSound()
    self:ClearWaitTag()
    self:ClearAudio()
    self:ClearAllTimers()
    if self.TalkContext then
        self.TalkContext.TalkActionManager:StopAllLookAt(self)
    end
    self:StopDSL()
    self:ClearUI()
    self:ClearEvents()
end

function LightTalkTask:PlayDialogue(bPauseResume)
    local NodeType = self.DialogueIterationComponent:GetCurrentNodeType()
    if (NodeType ~= EDialogueNodeType.Dialogue) then
        DebugPrint("lhr@Dialogue Iteration Error: NodeType", NodeType, "不合法")
        return
    end
    local Dialogue = self.DialogueIterationComponent:GetDialogue()
    DebugPrint("LightTalkTask PlayDialogue:", Dialogue and Dialogue.DialogueId)
    if (not Dialogue) then
        DebugPrint("lhr@Dialogue Iteration Error: Dialogue为空")
        return
    end

    self:OnPlayingDialogue(Dialogue)
    local DialogueData = self:GetDialogueDataWithCheck(Dialogue)
    self.CurrentDialogueData = DialogueData
    self:ConstructWaitTag(self, self.OnTaskPlayDialogueFinished)
    self:ProcessDialogueData(DialogueData, bPauseResume)
    self:ProcessWaitTag_UIPlayDialogue(DialogueData, self.WaitQueue)
    self:ProcessWaitTag_PlayAudio(DialogueData, bPauseResume, nil, self.WaitQueue)
    self:ProcessWaitTag_PlayScript(DialogueData, self.WaitQueue)
end

function LightTalkTask:EndDialogue()
    self.CurrentDialogueData = nil
    self:Finish(ETalkNodeFinishType.Out)
end

function LightTalkTask:TryFireEndingCallback(TalkNodeFinishType, OptionIndex)
    if self.NodeFinished_Callback and self.NodeFinished_Callback[2] then
        local NodeFinished_Obj = self.NodeFinished_Callback[1]
        local NodeFinished_Func = self.NodeFinished_Callback[2]
        NodeFinished_Func(NodeFinished_Obj, self, TalkNodeFinishType, OptionIndex)
    end
end

function LightTalkTask:RealFinish(TalkNodeFinishType)
    DebugPrint("LightTalkTask:RealFinish:", self.TalkTaskData.TalkNodeId, self.TalkTaskData.TalkNodeName, self.NodeFinished_Callback)
    self:TryEndFlowGraph()
    self:Clear()
    self:TryFireEndingCallback(TalkNodeFinishType)
    TalkSubsystem():ClearRefs(self)
end

local WaitItemUniqueTag = TalkUtils:GetPlayDialogueWaitItemTags()

function LightTalkTask:ConstructWaitTag(Obj, Func)
    self.WaitQueue = self.TalkContext.WaitQueueManager:CreateWaitQueue(self, {
        { Tag = WaitItemUniqueTag.UIPlayDialogue },
        { Tag = WaitItemUniqueTag.PlayAudio },
        { Tag = WaitItemUniqueTag.PlayScript },
    }, Obj, Func)
end

function LightTalkTask:ProcessWaitTag_UIPlayDialogue(DialogueData, WaitQueuePointer)
    if IsValid(self.UI) then
        self.UI:PlayDialogue(self, DialogueData, self.TalkTaskData, function()
            WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.UIPlayDialogue)
        end)
    else
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.UIPlayDialogue)
    end
end

function LightTalkTask:ProcessWaitTag_PlayAudio(DialogueData, bPauseResume, bIsAttachActor, WaitQueuePointer, bNoWait)
    if not self.TalkAudioComp then
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
        return
    end
    if bPauseResume and self.bAudioFinished then
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
        return
    end
    DebugPrint("LightTalkTask:ProcessWaitTag_PlayAudio", DialogueData, bPauseResume, self.bAudioFinishe, bNoWait)
    self.bAudioFinished = false
    self:PlayAudio(DialogueData, function(bUnFinished)
        if not bUnFinished then
            self.bAudioFinished = true
        end
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
    end, bIsAttachActor, bPauseResume, bNoWait)
end

function LightTalkTask:ProcessWaitTag_PlayScript(DialogueData, WaitQueuePointer)
    self:RunDSL(DialogueData, function()
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayScript)
    end)
end

function LightTalkTask:OnTaskPlayDialogueFinished()
    DebugPrint("LightTalkTask OnTaskPlayDialogueFinished", self)
    self:IterateDialogue()
end

function LightTalkTask:OnExceptionInterruptedBySTL()
    DebugPrint("LightTalkTask:OnExceptionInterruptedBySTL")
    TalkUtils:RemovePlayerInvincible()
    --注意：Guide的此函数实现是特殊的
    self.NodeFinished_Callback = nil
end

function LightTalkTask:OnInterrupted()
    DebugPrint("LightTalkTask:OnInterrupted")
    self.bHasInterrupted = true
    self:Clear()
end

function LightTalkTask:OnPaused()
    DebugPrint("LightTalkTask:对话被暂停", self, self:GetTalkType())
    self.PauseTime = UE4.UGameplayStatics.GetTimeSeconds(GWorld.GameInstance)
    self:ClearWaitTag()
    self:PauseAllTimers(true)
    if not self.bAudioFinished then
        self:PauseAudio()
    end
    self:StopDSL()
    if (IsValid(self.UI)) and (self.UI.OnPaused) then
        self.UI:OnPaused()
    end
end

function LightTalkTask:OnPauseResumed()
    if self.bHasInterrupted then
        return
    end
    DebugPrint("LightTalkTask:对话暂停恢复", self, self:GetTalkType())

    if (IsValid(self.UI)) and (self.UI.OnPauseResumed) then
        self.UI:OnPauseResumed()
    end
    self:PauseAllTimers(false)
    self.DialogueIterationComponent:Resume()
    if not self.bAudioFinished then
        self:ResumePauseAudio()
    end
end

function LightTalkTask:ProcessDialogueData(DialogueData, bPauseResume)
    if bPauseResume then
        local PlayedDuration = self.PauseTime - self.StartTime
        DialogueData.Duration = DialogueData.Duration - PlayedDuration
        DialogueData.Duration = math.max(DialogueData.Duration, 0)
    else
        self.StartTime = UE4.UGameplayStatics.GetTimeSeconds(GWorld.GameInstance)
    end
end

function LightTalkTask:InLoading()
    DebugPrint("LightTalkTask:InLoading", self)
    --特殊处理
    TalkSubsystem():ForceInterruptTalkTaskData(function(Data)
        return Data.FirstDialogueId == self.TalkTaskData.FirstDialogueId
    end)
end

function LightTalkTask:ClearEvents()
    EventManager:RemoveEvent(EventID.InLoading, self)
end

function LightTalkTask:ClearUI()
    if (not IsValid(self.UI)) then
        return
    end

    UIManager(GWorld.GameInstance):UnLoadUINew("TalkGuideUI")
    self.UI = nil
end

function LightTalkTask:ClearAudio()
    if self.TalkAudioComp then
        self.TalkAudioComp:Clear()
    end
end

------------------清理函数-------------------

function LightTalkTask:CreateComponents()
    LightTalkTask.Super.CreateComponents(self)

    if not self.TaskData then
        return
    end

    self.TalkTaskData = self.TaskData
    self.TalkContext = self.TaskData.TalkContext

    self:CreateDialogueIteratorComponent()
    self:CreateTalkAudioComponent()
    self:CreateExpressionComponent()
end

return LightTalkTask

