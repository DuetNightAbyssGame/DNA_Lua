local CinematicDialogueData_C = require"BluePrints.Story.Talk.Model.DialogueData".CinematicDialogueData_C
local ReviewUtils = require"BluePrints.UI.WBP.StoryReview.StoryReviewUtils"
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local LibraryPath = '/Game/Asset/Effect/Blueprint/PostProcess/PostProcessFunctionLibrary.PostProcessFunctionLibrary'

local WaitItemUniqueTag = {
    UIPlayDialogue = 1,
    DelayTime = 2,
    PlayAudio = 3,
    DialogueSequenceDrive = 4,
    DialogueSequenceWaitClick = 5,
    DialogueSequencePause = 6,
}

local M = Class("BluePrints.Story.Talk.Controller.CommonTalkTask")

function M:End()
    local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    AudioManager(self):StopSound(PlayerController, Const.TalkSoundKey)
    if self.TalkTaskData.SequenceActor then
        self.TalkTaskData.SequenceActor:K2_DestroyActor()
    end
    local TalkSequenceMgrSubSystem =  USubsystemBlueprintLibrary.GetWorldSubsystem(self.TalkContext, UTalkSequenceMgrSubSystem)
    if IsValid(TalkSequenceMgrSubSystem) then
        TalkSequenceMgrSubSystem:UnRegisterTalkSequencerProxy(self.TalkTaskData.SequencePlayer)
    end
    ReviewUtils.OpenCutShowReview(false)

    self.TalkContext:OnSequencePlayEnd(self.TalkTaskData)

    M.Super.End(self)
end

function M:BindDelegate()
    -- 监听UI跳过事件
    self.UI:AddDelegate_SkipButtonClicked(self, self.OnSkipButtonClicked)
    self.UI:AddDelegate_DialoguePanelClicked(self, self.OnUIDialoguePanelClicked)

    -- 监听Sequence暂停事件
    self.TalkTaskData.SequencePlayer.OnPause:Add(self.TalkContext, function()
        self:OnSequencePlayPaused()
    end)

    -- 监听Sequence结束事件
    self.TalkTaskData.SequencePlayer.OnFinished:Add(self.TalkContext, function()
        self:OnSequencePlayFinished()
    end)

    if self.TalkTaskData.BlendOutType == "FadeOut" then
        self.TalkContext:BindOnSequenceFadeInStart(self.TalkTaskData.SequencePlayer, self.FinishFadeInTime,{
            Obj = self,
            Func = self.OnCinematicTalkEndFadeIn,
        })
    end
end

function M:OnSequenceShowVideoUI(bState)
    if self.UI then
        self.UI:ShowVideo(bState)
    end
end

function M:UnbindDelegate()
    if not self.UI then
        return
    end
    self.UI:RemoveDelegate_SkipButtonClicked(self, self.OnSkipButtonClicked)
    self.UI:RemoveDelegate_DialoguePanelClicked(self, self.OnUIDialoguePanelClicked)
    -- 解绑Sequence开始事件 暂用Clear
    self.TalkTaskData.SequencePlayer.OnPlay:Clear()

    -- 解绑Sequence暂停事件
    self.TalkTaskData.SequencePlayer.OnPause:Clear()

    -- 解绑Sequence结束事件
    self.TalkTaskData.SequencePlayer.OnFinished:Clear()
    if IsValid(self.SequenceProxy) then
        self.SequenceProxy.OnPlayDialogue:Clear()
        self.SequenceProxy.OnEndPlayDialogue:Clear()
    end
end

function M:OnCinematicBegin()
    M.Super.OnCinematicBegin(self)
    self.TalkContext:OnSequencePlayBegin(self.TalkTaskData)
    ReviewUtils.OpenCutShowReview(true)
    local TalkSequenceMgrSubSystem =  USubsystemBlueprintLibrary.GetWorldSubsystem(self.TalkContext, UTalkSequenceMgrSubSystem)
    if IsValid(TalkSequenceMgrSubSystem) then
        self.SequenceProxy = TalkSequenceMgrSubSystem:RegisterTalkSequencerProxy(self.TalkTaskData.SequenceActor, 
            self.TalkTaskData.SequencePlayer, UTalkSequencerRuntimeProxy)
    end
    if IsValid(self.SequenceProxy) then
        self.SequenceProxy.OnPlayDialogue:Add(self.TalkTaskData.SequencePlayer, function(_, Section)
            self:SequenceDrivePlayDialogue(Section.DialogueId)
        end)
        self.SequenceProxy.OnEndPlayDialogue:Add(self.TalkTaskData.SequencePlayer, function(_, Section)
            if not Section then return end
            self:SequenceEndPlayDialogue(Section.DialogueId)
        end)
        self.SequenceProxy:SetUpLua(self)
    end
    DebugPrint("CinematicTalkTask:OnCinematicBegin", self.SequenceProxy, TalkSequenceMgrSubSystem)
    local UPostProcessFunctionLibrary = LoadClass(LibraryPath)
    if UPostProcessFunctionLibrary and UPostProcessFunctionLibrary.MobileCloseLights then
        UPostProcessFunctionLibrary.MobileCloseLights(self.TalkTaskData.SequenceActor)
    end
end

function M:OnCinematicTalkEndFadeIn()
    self.BlackUI:FadeIn(self.FinishFadeInTime)
end

function M:PlayDialogue(bPauseResume, bSkipping)
    local NodeType = self.DialogueIterationComponent:GetCurrentNodeType()
    if (NodeType ~= EDialogueNodeType.Dialogue) then
        DebugPrint("lhr@Dialogue Iteration Error: NodeType", NodeType, "不合法")
        return
    end

    if bSkipping  or self.TalkTaskData.bSkippedSequence then
        return
    end

    local Dialogue = self.DialogueIterationComponent:GetDialogue()
    DebugPrint("CinematicTalkTask:PlayDialogue",Dialogue and Dialogue.DialogueId)
    if (not Dialogue) then
        DebugPrint("lhr@Dialogue Iteration Error: Dialogue为空")
        return
    end
    local CurrentDialogueId = Dialogue.DialogueId
    local DialogueData = CinematicDialogueData_C.New(self, CurrentDialogueId, self.TalkContext)
    if(not DialogueData.Content) then
        self:IterateDialogue()
        self:RecordDialogueCompleted(DialogueData.DialogueId)
        return
    end
    if self.WaitQueue then
        self.WaitQueue:CloseWaitQueue()
    end
    self.WaitQueue = self.TalkContext.WaitQueueManager:CreateWaitQueue(self, {
        { Tag = WaitItemUniqueTag.DelayTime },
        { Tag = WaitItemUniqueTag.PlayAudio },
    }, self, self.OnTaskPlayDialogueFinished)

    -- 防止与上一个WaitQueue冲突
    local WaitQueuePointer = self.WaitQueue

    self.UI:SetTextBorderHidden(false)
    self.UI:PlayDialogue(self, DialogueData, self.TalkTaskData)

    self:PlayAudio(DialogueData, function()
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
    end)

    self.TalkContext.TalkTimerManager:AddTimer(self, DialogueData.Duration, nil, nil, self, function()
        WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.DelayTime)
    end)

    self:RecordDialogueCompleted(DialogueData.DialogueId)
end

function M:EndDialogue()
    -- DebugPrint("lhr@CinematicTalk end")
    self.UI:SetTextBorderHidden(true)
end

function M:OnSkipButtonClicked()
    DebugPrint("CinematicTalkTask:OnSkipButtonClicked")
    self.TalkTaskData.bSkippedSequence = true
    self.TalkTaskData.SkippedSequencePoint = self.TalkTaskData.SequencePlayer:GetCurrentTimeAsSeconds()
    local Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if IsValid(Player) and Player.TrackSkipTalkInfo then
        Player:TrackSkipTalkInfo(self.TalkTaskData)
    end

    if(self.WaitQueue) then
        self.WaitQueue:CloseWaitQueue()
    end

    self.TalkTaskData.SequencePlayer:GoToEnd()
    if self.TalkTaskData.SequencePlayer:IsPaused() then
        self.TalkTaskData.SequencePlayer:Play()
    end
end

function M:OnUIDialoguePanelClicked()
    if not self:CanResponseUIClick() then
        return
    end
    -- if not self:IsDialogueTypingFinished() then
    --     return
    -- end
    self:SequenceTryResumeDialogue()
    self.UI:SwitchEnableTalkClick(false)
end

function M:OnSequencePlayDialogue(DialogueId,bStart)
    DebugPrint("CinematicTalkTask:OnSequencePlayDialogue", DialogueId, bStart)
    -- 不需要了，直接屏蔽
    -- if(bStart) then
    --     self:CinematicStartIteration(DialogueId)
    -- else
    --     self.DialogueIterationComponent:SkipToFinalOrOption()
    --     local FinalDialogue = self.DialogueIterationComponent:GetDialogue()
    --     if (FinalDialogue) then
    --         self:CinematicStartIteration(FinalDialogue.DialogueId + 1)
    --     end
    -- end
    -- PlayDialogue改为在DialogueIterationComponent的Node中执行
    -- self:CinematicPlayDialogue()
end

function M:SequenceDrivePlayDialogue(DialogueId)
    DebugPrint("CinematicTalkTask:SequenceDrivePlayDialogue", DialogueId)
    -- self:CinematicPlayDialogue(true)
    self:CinematicStartIteration(DialogueId)
    if self.WaitQueue then
        self.WaitQueue:RegiserWaitItem(WaitItemUniqueTag.DialogueSequenceDrive)
    end
end

function M:SequenceEndPlayDialogue(DialogueId)
    DebugPrint("CinematicTalkTask:SequenceEndPlayDialogue", DialogueId)
    self:TryHideDialogueBlackUI()
    -- 直接调用IterateDialogue强制迭代到下一句，无需CompleteWaitItem，防止重复迭代(OnTaskPlayDialogueFinished中也会调用IterateDialogue)
    -- self.WaitQueue:CompleteWaitItem(WaitItemUniqueTag.DialogueSequenceDrive)
    local WaitQuque = self.WaitQueue 
    self:IterateDialogue()
    if WaitQuque then
        WaitQuque:CloseWaitQueue()
    end
end

function M:SequenceTryPauseDialogue()
    DebugPrint("CinematicTalkTask:SequenceTryPauseDialogue")
    self.TalkTaskData.SequencePlayer:Pause()
end

function M:SequenceTryResumeDialogue()
    DebugPrint("CinematicTalkTask:SequenceTryResumeDialogue")
    self.TalkTaskData.SequencePlayer:Play()
end

function M:TalkTryPauseDialogue()
    DebugPrint("CinematicTalkTask:TalkTryPauseDialogue")
    self.TalkTaskData.SequencePlayer:Pause()
    if not self.WaitQueue then return end
    self.WaitQueue:RegiserWaitItem(WaitItemUniqueTag.DialogueSequencePause)
end

function M:TalkTryResumeDialogue()
    DebugPrint("CinematicTalkTask:TalkTryResumeDialogue")
    self.TalkTaskData.SequencePlayer:Play()
    if not self.WaitQueue then return end
    self.WaitQueue:CompleteWaitItem(WaitItemUniqueTag.DialogueSequencePause)
end

function M:OnTaskPlayDialogueFinished()
    DebugPrint("CinematicTalkTask:OnTaskPlayDialogueFinished")
    -- self:CinematicPlayDialogue()
    self.UI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:IterateDialogue()
end

function M:OnSequencePlayPaused()
    DebugPrint("OnSequencePlayPaused")
end

function M:OnSequencePlayFinished()
    DebugPrint("CinematicTalkTask:OnSequencePlayFinished")

    -- 瞬切黑屏并取消FadeIn的监听事件
    self.BlackUI:FadeIn(0)
    self.BlackUI:FadeOut(0)
    self.TalkContext:UnBindOnSequenceFadeInStart()

    -- Sequence 结束后，当帧镜头位置仍是 Sequence 的镜头位置，会影响后续依赖镜头位置的操作，因此手动更新摄像机管理器
    local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(PlayerController)

    self:FinishDialogue()
end

function M:StartDialogueIteration()
    --NOTHING
end

function M:CinematicStartIteration(DialogueId)
    self.DialogueIterationComponent:Initialize(DataMgr.Dialogue, DialogueId)
    self.DialogueIterationComponent:Start()
end

function M:OnPaused()
    M.Super.OnPaused(self)
    --暂停过场
    self:TalkTryPauseDialogue()
    --暂停qte
    EventManager:FireEvent(EventID.PauseQTE)
end

function M:OnPauseResumed()
    M.Super.OnPauseResumed(self)
    --恢复过场
    self:TalkTryResumeDialogue()
    --恢复qte
    EventManager:FireEvent(EventID.ResumeQTE)
end

function M:CheckResource()
    if not M.Super.CheckResource() then
        return false
    else
        if not self.TalkTaskData then 
            DebugPrint("CheckCinematicResource Error No TalkTaskData")
            return false
        elseif not self.TalkTaskData.SequenceActor then 
            DebugPrint("CheckCinematicResource Error No SequenceActor")
            return false
        elseif not self.TalkTaskData.SequencePlayer then 
            DebugPrint("CheckCinematicResource Error No SequencePlayer")
            return false
        elseif not self.TalkTaskData.Sequence then 
            DebugPrint("CheckCinematicResource Error No Sequence")
            return false
        end
        return true
    end
    return true
end

return M