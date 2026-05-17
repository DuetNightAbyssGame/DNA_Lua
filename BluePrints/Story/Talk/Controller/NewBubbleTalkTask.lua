local ETalkNodeFinishType = require 'StoryCreator.StoryLogic.StorylineUtils'.ETalkNodeFinishType
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local Timeutils = require("Utils.TimeUtils")

local EBubblePlayType = {
    Once = "Once",
    StayOnLast = "StayOnLast",
    DelayLoop = "DelayLoop"
}
local WaitItemUniqueTag = TalkUtils:GetPlayDialogueWaitItemTags()
local TalkLogType = UE.EStoryLogType.Talk

--- @class BubbleTalkTask : LightTalkTask
local M = Class("BluePrints.Story.Talk.Controller.TalkTaskBase")
function M:Start(TalkTaskData, NodeFinished_Callback)
    if(TalkTaskData.TalkActors) then
        TalkTaskData.TalkContext:CreateTalkActors(self, TalkTaskData.TalkActors, nil, nil, true)
    end

    self:PlaySnapShot()
    self:InitData(TalkTaskData, NodeFinished_Callback)
    EventManager:AddEvent(EventID.InLoading, self, self.InLoading)
    self:StartPlayDialogue()
end

function M:Clear()
    if(self.TalkTaskData.TalkActors) then
        self.TalkContext:DestoryTalkActors(self, self.TalkTaskData.TalkActors)
    end

    self:ClearUI()
    self:ClearWaitTag()
    self:ClearAudio()
    self:ClearAllTimers()
    self.TalkActionManager:StopAllLookAt(self)
    self:StopDSL()
    EventManager:RemoveEvent(EventID.InLoading, self)
end

function M:InLoading()
    DebugPrint("BubbleTalkTask:InLoading", self)
    --特殊处理
    TalkSubsystem():ForceInterruptTalkTaskData(function(Data)
        return Data.FirstDialogueId == self.TalkTaskData.FirstDialogueId
    end)
end

function M:InitData(TalkTaskData, NodeFinished_Callback)
    self.NodeFinished_Callback = NodeFinished_Callback
    self.TalkActionManager = self.TalkContext.TalkActionManager
    self.TalkTimerManager = self.TalkContext.TalkTimerManager
    self.WaitQueueManager = self.TalkContext.WaitQueueManager
end

--- @return boolean, number
function M:CheckBubbleInCd()
    local TalkTaskData = self.TalkTaskData
    if not TalkTaskData.bBubblePlayCDEnable then return false end
    local LastPlayTime = self.TalkContext:GetBubbleLastPlayTime(TalkTaskData)
    local BubblePlayCD = TalkTaskData.BubblePlayCD
    local NowTime = Timeutils.NowTime()
    if NowTime - LastPlayTime >= BubblePlayCD then return false end
    return true, BubblePlayCD - (NowTime - LastPlayTime)
end

function M:StartPlayDialogue()
    local bBubbleInCd, CdLastTime = self:CheckBubbleInCd()
    if bBubbleInCd then
        self.TalkTimerManager:AddTimer(self, CdLastTime, false, nil, self, self.StartPlayDialogue)
        return 
    end
    self.DialogueIterationComponent:Start()
    self.TalkContext:RecordBubbleStart(self.TalkTaskData)
end

function M:PlayDialogue(bPauseResume)
    local NodeType = self.DialogueIterationComponent:GetCurrentNodeType()
    if (NodeType == EDialogueNodeType.Dialogue) then
        local Dialogue = self.DialogueIterationComponent:GetDialogue()
        if (not Dialogue) then
            DebugPrint("BubbleTalkTask@Dialogue Iteration Error: Dialogue为空")
            return
        end
        DebugPrint("BubbleTalkTask:PlayDialogue:",self.TalkTaskData.TalkNodeId, Dialogue.DialogueId) -- Todo 优化打印信息
        self:DisableBubbleUI()

        local DialogueData = self:GetDialogueDataWithCheck(Dialogue)
        if not self:CheckDialogueData(DialogueData, Dialogue.DialogueId) then
            self:IterateDialogue()
            return
        end
        self:OnPlayingDialogue(Dialogue)
        self:ConstructWaitTag(DialogueData,self, self.IterateDialogue)
        self:ProcessWaitTag_PlayScript(DialogueData, self.WaitQueue)
        self:ProcessWaitTag_UIPlayDialogue(DialogueData, self.WaitQueue)
        self:ProcessWaitTag_PlayAudio(DialogueData, bPauseResume, true, self.WaitQueue)
    else
        DebugPrint("BubbleTalkTask@Dialogue Iteration Error: NodeType", NodeType, "不合法")
        return
    end
end

function M:EndDialogue()
    DebugPrint("BubbleTalkTask: End")
    if (self.TalkTaskData.BubblePlayType == EBubblePlayType.Once) then
        self:Finish(ETalkNodeFinishType.Out)
    elseif (self.TalkTaskData.BubblePlayType == EBubblePlayType.StayOnLast) then
    elseif (self.TalkTaskData.BubblePlayType == EBubblePlayType.DelayLoop) then
        self:DisableBubbleUI()
        self.DialogueIterationComponent:Initialize(DataMgr.Dialogue, self.TalkTaskData.FirstDialogueId)
        self.TalkTimerManager:AddTimer(self, self.TalkTaskData.BubbleDelayLoopSeconds, false, nil, self, function()
            self.DialogueIterationComponent:Start()    
        end)
    end
end

function M:Finish(TalkNodeFinishType)
    DebugPrint("BubbleTalkTask:Finish:", self.TalkTaskData.TalkNodeId, self.TalkTaskData.TalkNodeName, self.NodeFinished_Callback)
    self:TryEndFlowGraph()
    self:Clear()
    if self.NodeFinished_Callback and self.NodeFinished_Callback[2] then
        local NodeFinished_Obj = self.NodeFinished_Callback[1]
        local NodeFinished_Func = self.NodeFinished_Callback[2]
        NodeFinished_Func(NodeFinished_Obj, self, TalkNodeFinishType)
    end
end

function M:ConstructWaitTag(DialogueData, Obj, Func)
    self.WaitQueue = self.TalkContext.WaitQueueManager:CreateWaitQueue(self, {
        { Tag = WaitItemUniqueTag.UIPlayDialogue }, 
        { Tag = WaitItemUniqueTag.PlayAudio}, 
        { Tag = WaitItemUniqueTag.PlayScript, Condition = function() return DialogueData.Scripts end},
    }, Obj, Func)
end

function M:ProcessWaitTag_PlayScript(DialogueData, WaitQueuePointer)
    self:RunDSL(DialogueData, function()
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayScript)
    end)
end

function M:ProcessWaitTag_UIPlayDialogue(DialogueData, WaitQueuePointer)
    DebugPrint("NewBubbleTalkTask ProcessWaitTag_UIPlayDialogue",DialogueData)
    self:RecordDialogueData(DialogueData)
    self:EnableBubbleUI(DialogueData)
    self.TalkTimerManager:AddTimer(self, DialogueData.Duration, false, nil, nil, function()
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.UIPlayDialogue)
    end)
end

function M:ProcessWaitTag_PlayAudio(DialogueData, bPauseResume, bIsAttachActor, WaitQueuePointer, bNoWait)
    if not self.TalkAudioComp then
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
        return
    end
    if bPauseResume and self.bAudioFinished then
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
        return
    end
    DebugPrint("NewBubbleTalkTask:ProcessWaitTag_PlayAudio", DialogueData, bPauseResume, self.bAudioFinishe, bNoWait)
    self.bAudioFinished = false
    self:PlayAudio(DialogueData, function(bUnFinished)
        if not bUnFinished then
            self.bAudioFinished = true
        end
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
    end, bIsAttachActor, bPauseResume, bNoWait)
end

function M:EnableBubbleUI(DialogueData)
    local TalkActor = DialogueData.TalkActorData and DialogueData.TalkActorData.TalkActor
    if not IsValid(TalkActor) then
        local InteractiveActorId = self.TalkTaskData.InteractiveActorId
        if InteractiveActorId then
            local TalkActorData = self.TalkContext:GetTalkActorData(self, InteractiveActorId)
            TalkActor = TalkActorData and TalkActorData.TalkActor
        end
    end
    if IsValid(TalkActor) then
        local Content = DialogueData.Content
        local Style = nil
        if DialogueData.DialoguePanelType then
            local DialoguePanelType = string.lower(DialogueData.DialoguePanelType)
            Style = TalkUtils:FindTargetString(DialoguePanelType, 'style')
        end
        --DebugPrint("EnableBubbleUI", Style)
        TalkActor:EnableBubbleWidget(true, Content, Style)
        self.TalkActor = TalkActor
    end
end

function M:DisableBubbleUI()
    if IsValid(self.TalkActor) then
        self.TalkActor:EnableBubbleWidget(false)
    end
    self.TalkActor = nil
end

function M:RecordDialogueData(DialogueData)
    self.LastDialogueData = self.WorkingDialogueData
    self.WorkingDialogueData = DialogueData
end

function M:ClearUI()
    if IsValid(self.TalkActor) then
        self.TalkActor:EnableBubbleWidget(false)
    end
end

function M:ClearAudio()
    if self.TalkAudioComp then
        self.TalkAudioComp:Clear()
    end
end

function M:OnExceptionInterruptedBySTL()
    DebugPrint("NewBubbleTalkTask:OnExceptionInterruptedBySTL")
    TalkUtils:RemovePlayerInvincible()
    self.NodeFinished_Callback = nil
end

function M:OnInterrupted()
    DebugPrint("NewBubbleTalkTask:OnInterrupted")
    self.bHasInterrupted = true
    self:Clear()
end

function M:OnPaused()
    DebugPrint("NewBubbleTalkTask:对话被暂停", self)
    self:ClearWaitTag()
    self:PauseAllTimers(true)
    if not self.bAudioFinished then
        self:PauseAudio()
    end
    self:StopDSL()
    self:DisableBubbleUI()
end

function M:OnPauseResumed()
    if self.bHasInterrupted then
        return
    end
    DebugPrint("NewBubbleTalkTask:对话暂停恢复", self)

    self:PauseAllTimers(false)
    self.DialogueIterationComponent:Resume()
    if not self.bAudioFinished then
        self:ResumePauseAudio()
    end
end

function M:CreateComponents()
    M.Super.CreateComponents(self)

    if not self.TaskData then
        return
    end

    self.TalkTaskData = self.TaskData
    self.TalkContext = self.TaskData.TalkContext

    self:CreateDialogueIteratorComponent()
    self:CreateTalkAudioComponent()
    self:CreateExpressionComponent()
end

function M:CheckDialogueData(DialogueData, DialogueId)
    local ErrorMessge = "\nDialogueId:"..tostring(DialogueId)..
                        "\nTalkNodeName: "..tostring(self.TalkTaskData.TalkNodeName)
    if (not DialogueData) then
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, TalkLogType, "冒泡对话数据错误: DialogueData无效", "台本内容为空"..ErrorMessge)
        return false
    else
        if (not DialogueData.TalkActorData) then
            local InteractiveActorId = self.TalkTaskData.InteractiveActorId
            if not InteractiveActorId or not DataMgr.TheaterNpc[InteractiveActorId] then
                local Dialogue = DataMgr.Dialogue[DialogueId]
                local SpeakNpcId = Dialogue and Dialogue.SpeakNpcId or 0
                UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, TalkLogType, "冒泡对话数据错误: TalkActorData无效", 
                    "台本SpeakNpcId字段为空\n 或者TalkNode没有配置当前台本SpeakNpcId的演员 SpeakNpcId: " .. tostring(SpeakNpcId)
                    ..ErrorMessge)
                return false
            end
        elseif (not DialogueData.TalkActorData.TalkActor) then
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, TalkLogType, "冒泡对话数据错误: TalkActor无效", "Npc不存在\nNpcId:"..tostring(DialogueData.TalkActorData.TalkActorId)..ErrorMessge)
            return false
        end
    end

    return true
end

return M