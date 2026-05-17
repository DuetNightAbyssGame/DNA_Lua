---@class TalkTaskBase_C
local ETaskState = require "BluePrints.Story.Talk.Base.ETaskState"
local ETalkType = require "BluePrints.Story.Talk.Base.ETalkType"
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local FHideAllMonstersComponent = require "BluePrints.Story.Components.HideAllMonstersComponent"
local FDialogueIterationComponent = require "BluePrints.Story.Components.DialogueIterationComponent"
local FDialogueRecordComponent = require "BluePrints.Story.Components.DialogueRecordComponent"
local FDialogueFlowGraphComponent = require "BluePrints.Story.Components.DialogueFlowGraphComponent"
local FHideAllNpcsComponent = require "BluePrints.Story.Components.HideAllNpcsComponent"
local FExecutionFlowUtils = require "BluePrints.Story.ExecutionFlow.ExecutionFlowUtils"
local ExpressionComp_C = require "BluePrints.Story.Talk.Controller.ExpressionComp"
local TalkAudioComp_C = require "BluePrints.Story.Talk.Controller.TalkAudioComp"

local TalkTaskBase_C = Class()

function TalkTaskBase_C:New(TaskData, TalkType)
	local Obj = setmetatable({}, {
		__index = self
	})

    Obj.UnitKey = string.format("%s_%s", TalkType, tostring(Obj):gsub("table: ", ""))
	Obj.TaskData = TaskData
	Obj.TalkComps = {}
	Obj.ExecutedComps = {}
	Obj.State = ETaskState.Default
	Obj.TalkType = TalkType
	Obj.BasicTalkType = DataMgr.TalkType[TalkType].BasicType
	Obj.OnTalkEndEvents = {}
	Obj:CreateComponents()

	return Obj
end

function TalkTaskBase_C:ExecuteProps()
	if (self.TalkComps) then
		for _, Comp in pairs(self.TalkComps) do
			if not Comp.bManualCall then
				Comp:Execute()
			end
		end
	end
end

function TalkTaskBase_C:ResumeProps()
	if (self.TalkComps) then
		for _, Comp in pairs(self.TalkComps) do
			Comp:Resume()
		end
	end
end

function TalkTaskBase_C:ExecuteComp(CompType)
	local Comp = self.TalkComps[CompType]
	if Comp then
		Comp:Execute()
	end
end

function TalkTaskBase_C:ResumeComp(CompType)
	local Comp = self.TalkComps[CompType]
	if Comp then
		Comp:Resume()
	end
end

function TalkTaskBase_C:StartWorking(TalkTaskData, TaskFinished_Callback)
	self:Start(TalkTaskData, TaskFinished_Callback)
end

---------------通用接口-----------------
function TalkTaskBase_C:TryEndFlowGraph()
	self.DialogueFlowGraphComponent:OnTalkEnd()
end

function TalkTaskBase_C:GetTalkComps()
	return self.TalkComps or {}
end

function TalkTaskBase_C:Start()
	self:PlaySnapShot()
end

function TalkTaskBase_C:PlaySnapShot()
	AudioManager(GWorld.GameInstance):StartTalkSnapShot(self.UnitKey)
end

function TalkTaskBase_C:Finish()

	self:RemoveDialogueEffectSound()
end

function TalkTaskBase_C:End()

	self:RemoveDialogueEffectSound()
end

function TalkTaskBase_C:RemoveDialogueEffectSound()
	AudioManager(GWorld.GameInstance):StopTalkSnapShot(self.UnitKey)
end

function TalkTaskBase_C:PauseSnapShot()
	AudioManager(GWorld.GameInstance):UpdateTalkSnapShotParam(0)
end

function TalkTaskBase_C:OnPlayingDialogue(DialogueData)
	local RawData = DataMgr.Dialogue[DialogueData.DialogueId]
	if RawData and RawData.SnapShot then
		AudioManager(GWorld.GameInstance):UpdateTalkSnapShotParam(Const.DialogueSnapShot[RawData.SnapShot])
	else
		AudioManager(GWorld.GameInstance):UpdateTalkSnapShotParam(0)
	end
end

function TalkTaskBase_C:StartPlayDialogue()
	if self.DialogueIterationComponent then
    	self.DialogueIterationComponent:Start()
	end
end

function TalkTaskBase_C:IterateDialogue(...)
	if self.DialogueIterationComponent then
		self.DialogueIterationComponent:Iterate(...)
	end
end

function TalkTaskBase_C:EndDialogue(...)
	--在子类中实现
	self:FinishDialogue(...)
end

function TalkTaskBase_C:FinishDialogue(...)
	--在子类中实现
end

function TalkTaskBase_C:SetUIName(Name)
	self.UIName = Name
end

function TalkTaskBase_C:GetUIName()
	return self.UIName
end

function TalkTaskBase_C:GetTalkType()
	return self.TalkType
end

function TalkTaskBase_C:GetTalkTaskData()
	return self.TalkTaskData
end

function TalkTaskBase_C:GetBasicTalkType()
	return self.BasicTalkType
end

function TalkTaskBase_C:GetState()
	return self.State
end

function TalkTaskBase_C:GetLastState()
	return self.LastState
end

function TalkTaskBase_C:SetState(State)
	self.LastState = self.State or ETaskState.Default
	self.State = State
end

function TalkTaskBase_C:IsWorking()
	return self.State == ETaskState.Working
end

function TalkTaskBase_C:OnInterrupted()
	DebugPrint("@@@ error OnInterrupted未实现/不支持被打断", self:GetTalkType())
end

function TalkTaskBase_C:OnPaused()
	DebugPrint("@@@ error OnPaused未实现/不支持被暂停", self:GetTalkType())
end

function TalkTaskBase_C:OnPauseResumed()
	DebugPrint("@@@ error OnPauseResumed未实现/不支持暂停恢复", self:GetTalkType())
end

function TalkTaskBase_C:Clear()
	TalkUtils:RemovePlayerInvincible()
	local BasicType = self:GetBasicTalkType()
	if BasicType == ETalkType.FixSimple or
			BasicType == ETalkType.FreeSimple or
			BasicType == ETalkType.Black or
			BasicType == ETalkType.Cinematic or
			BasicType == ETalkType.Impression then
		self:ClearDefault()
	else
		--DebugPrint("@@@ error Clear函数未实现", self:GetTalkType())
	end
end

function TalkTaskBase_C:ClearWaitTag()
	if self.WaitQueue then
		self.WaitQueue:CloseWaitQueue()
		self.WaitQueue = nil
	end
end

function TalkTaskBase_C:ClearDefault()
	DebugPrint("TalkTaskBase_C:ClearDefault", self:GetBasicTalkType())
	if self.TalkContext then
		self.TalkContext.TalkTimerManager:ClearTimer(self)
		self.TalkContext.WaitQueueManager:ClearGroup(self)
		self.TalkContext.TalkDelegateManager:ClearGroup(self)
		self.TalkContext.TalkActionManager:StopAllLookAt(self)
		self.TalkContext.TalkActionManager:StopAllNpcMontage(self)
	end
	self:TryRemoveBlackUI()
	self:StopDSL()
	if self.UnbindDelegate then
		self:UnbindDelegate()
	end
	self:ClearDialogueGuideUI()

	if self.ExpressionComp then
		self.ExpressionComp:Clear()
	end

	if self.DisableCharacterDitherComponent then
		self.DisableCharacterDitherComponent:Resume()
	end
	if self.TalkTaskData.FlowAsset then
		local TS = TalkSubsystem()
		TS:UnRegisterFlowTalkTask(self.TalkTaskData.FlowAssetPath)
	end
	if self:GetUIName() then
		UIManager(GWorld.GameInstance):UnLoadUINew(self:GetUIName())
	end
end

function TalkTaskBase_C:TryRemoveBlackUI()
	if not self.TalkContext then
		return
	end

	self.TalkContext:RemoveDialogueBlackUI()
end

function TalkTaskBase_C:OnExceptionInterruptedBySTL()
	TalkUtils:RemovePlayerInvincible()
	local BasicType = self:GetBasicTalkType()
	if BasicType == ETalkType.FixSimple or
			BasicType == ETalkType.FreeSimple or
			BasicType == ETalkType.Black or
			BasicType == ETalkType.Cinematic or
			BasicType == ETalkType.Impression or
			BasicType ==ETalkType.RougeLike then
		self:OnExceptionInterruptedBySTLDefault()
	else
		DebugPrint("@@@ error OnExceptionInterruptedBySTL函数未实现", self:GetTalkType())
	end
end

function TalkTaskBase_C:OnExceptionInterruptedBySTLDefault()
	DebugPrint("TalkTaskBase_C:OnExceptionInterruptedBySTLDefault", self:GetBasicTalkType())
	self.NodeFinished_Callback = nil
	if self.TalkContext and self.TalkContext.TalkCameraManager then
		self.TalkContext.TalkCameraManager:OnExceptionInterrupted()
	end
	self:ResumeProps()
	self:Clear()
	if self.TalkTaskData and self.TalkTaskData.SequencePlayer then
		self.TalkTaskData.SequencePlayer:Stop()
	end
end

function TalkTaskBase_C:PauseTaskExternal(bPause, Pauser)
	local TS = TalkSubsystem()
	if bPause then
		TS:ForcePauseTalk(self, Pauser)
	else
		TS:TryResumePauseTalk(Pauser)
	end
end

function TalkTaskBase_C:PauseAllTimers(bPause)
	if self.TalkTimerManager then
		if bPause then
			self.TalkTimerManager:PauseTimer(self)

			if (IsValid(self.DSLFlow)) then
				self.DSLFlow:Pause()
			end
		else
			self.TalkTimerManager:UnPauseTimer(self)

			if (IsValid(self.DSLFlow)) then
				self.DSLFlow:Resume()
			end
		end
	end
end

function TalkTaskBase_C:PauseAudio()
	self:PauseSnapShot()
	if self.TalkAudioComp then
		self.TalkAudioComp:OnPaused()
	end
end

function TalkTaskBase_C:PauseCamera(bPause)
	local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
	if not PlayerController then
		return
	end
	if bPause then
		self.CacheControllerPausedParam = PlayerController.bShouldPerformFullTickWhenPaused
		PlayerController.bShouldPerformFullTickWhenPaused = false
		UGameplayStatics.SetGamePaused(GWorld.GameInstance, true)
		if self.TalkContext and self.TalkContext.TalkCameraManager then
			self.TalkContext.TalkCameraManager:PauseCameraBreathe(true)
		end
	else
		PlayerController.bShouldPerformFullTickWhenPaused = self.CacheControllerPausedParam
		UGameplayStatics.SetGamePaused(GWorld.GameInstance, false)
		if self.TalkContext and self.TalkContext.TalkCameraManager then
			self.TalkContext.TalkCameraManager:PauseCameraBreathe(false)
		end
	end
end

function TalkTaskBase_C:HideUI()
	-- 待子类中实现
end

function TalkTaskBase_C:CreateExpressionComponent()
    self.ExpressionComp = ExpressionComp_C.New()
end

function TalkTaskBase_C:CreateTalkAudioComponent()
    self.TalkAudioComp = TalkAudioComp_C.New()
end

function TalkTaskBase_C:PlayAudio(DialogueData, Callback, bIsAttachActor, bPauseResume, bNoWait, OverrideAttachActor)
	if self.TalkAudioComp then
		local VoiceName = DialogueData.VoiceName
		local SoundHandle = self.TalkTaskData.BasicTalkType
		local DialogueId = DialogueData.DialogueId
		local ExtraDialogueInfo = DataMgr.Dialogue[DialogueId]
		if ExtraDialogueInfo and ExtraDialogueInfo.bTurnOffVoice and AudioManager(GWorld.GameInstance).bTurnOffTalkVoice then
			if Callback then
				Callback()
			end
			return
		end
		local TalkActorData = DialogueData.TalkActorData
		local SrcActor = TalkActorData and TalkActorData.TalkActor
		self.TalkAudioComp:PlayAudio(VoiceName, SrcActor, Callback, ExtraDialogueInfo, bIsAttachActor,
			SoundHandle, OverrideAttachActor, bPauseResume, bNoWait)
	end
end

function TalkTaskBase_C:ResumePauseAudio()
	if self.TalkAudioComp then
		self.TalkAudioComp:OnPauseResumed()
	end
end

function TalkTaskBase_C:ClearAudio()
	if self.TalkAudioComp then
		self.TalkAudioComp:Clear()
	end
	self:RemoveDialogueEffectSound()
end

function TalkTaskBase_C:ClearAllTimers()
    DebugPrint("TalkTaskBase_C:ClearAllTimers")
    if self.TalkTimerManager then
        self.TalkTimerManager:ClearTimer(self)
        self.TalkTimerManager:ClearTimer(self.dsl)
    end
end

function TalkTaskBase_C:SkipDialogue()
	-- 待子类中实现
end

function TalkTaskBase_C:SkipOption(DialogueId)
	-- 待子类中实现
end

function TalkTaskBase_C:StopDSL()
	if (IsValid(self.DSLFlow)) then
		self.DSLFlow:Stop()
	end
end

function TalkTaskBase_C:SkipDSL()
	if (IsValid(self.DSLFlow)) then
		self.DSLFlow:Skip()
	end
end

function TalkTaskBase_C:TrySkipDSL()
	if (IsValid(self.DSLFlow) and self.DSLFlow.bAllowClick) then
		self.DSLFlow:Skip()
		return true
	end
	return false
end

function TalkTaskBase_C:TryCompleteDSLTag()
	if (IsValid(self.DSLFlow) and self.DSLFlow.bAllowClick) then
		if self.WaitQueue then
			self.WaitQueue:CompleteWaitItem("PlayScript")
		end
	end
end

function TalkTaskBase_C:GetDialogueDataWithCheck(DialogueIterator)
	if not self.DialogueDataDecorator_C then
		self.DialogueDataDecorator_C = require("BluePrints.Story.Talk.Model.DialogueData." .. self.BasicTalkType .. "DialogueData")
	end

	local CurrentDialogueId = DialogueIterator.DialogueId
	local DialogueData = self.DialogueDataDecorator_C.New(self, CurrentDialogueId)
	if (not DialogueData.Content) then
		error("@@@ DialogueId无效", CurrentDialogueId)
		return
	end
	return DialogueData
end

function TalkTaskBase_C:RunDSL(DialogueData, OnFinished)
	if not self.DialogueFlowGraphComponent:CanUseDSLFlow() then
		DebugPrint("DialogueFlowGraphComponent Use LevelSequence, Forbidden DSLFlow", DialogueData.DialogueId)
		return OnFinished and OnFinished()
	end
	if (IsValid(self.DSLFlow)) then
		self.DSLFlow:Skip() -- 本应在节点中让脚本跟随自身的台本或选项，但无时间迭代，临时处理
	end

	local DSLFlow = FExecutionFlowUtils:CreateFlow(DialogueData.DialogueId, self, function()
		self.DSLFlow = nil
		if (OnFinished) then
			OnFinished()
		end
	end)

	if (DSLFlow) then
		self.DSLFlow = DSLFlow
		DSLFlow:Start()
	end
end

function TalkTaskBase_C:CompositeExtraParams()

end

function TalkTaskBase_C:AddGuideUIForDialogue()
	DebugPrint("TalkTaskBase_C:AddGuideUIForDialogue", self)
	if self.DialogueGuideUI then
		return
	end
	if self.UI.Pos_Drive then
		local GuideUI = UIManager(GWorld.GameInstance):LoadUINew("TalkGuideUI")
		self.DialogueGuideUI = GuideUI
		self.UI.Pos_Drive:AddChild(GuideUI)
	else
		Utils.ScreenPrint("Error 对话UI中Pos_Drive为空，请检查是否对话类型是否支持切换对话UI样式" .. self:GetTalkType())
	end
end

function TalkTaskBase_C:ClearDialogueGuideUI()
	DebugPrint("TalkTaskBase_C:ClearDialogueGuideUI", self)
	if self.DialogueGuideUI then
		self.DialogueGuideUI = nil
		UIManager(GWorld.GameInstance):UnLoadUINew("TalkGuideUI")
		if self.UI and self.UI.Pos_Drive then
			self.UI.Pos_Drive:ClearChildren()
		else
			Utils.ScreenPrint("Error 对话UI中Pos_Drive为空，请检查是否对话类型是否支持切换对话UI样式" .. self:GetTalkType())
		end
	end
end

function TalkTaskBase_C:TryShowStoryPanelUI(DialogueData, Callback)
	if not DialogueData then
		Callback()
		return
	end
	DebugPrint("TryShowStoryPanelUI", DialogueData.DialoguePanelType)
	if not DialogueData.ShowStoryContent then
		Callback()
		return
	end
	local DialoguePanelType = DialogueData.DialoguePanelType
	local ShowStoryContent = DialogueData.ShowStoryContent
	local Type = ShowStoryContent.Type
	local Topic = ShowStoryContent.Topic
	local Content = ShowStoryContent.Content
	local AnimationName = ShowStoryContent.AnimationName
	if not Topic or not Content then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Talk, "对话中弹出阅读错误", string.format("格式错误或者content、tpoic为空 DialogueId: \
            %d DialoguePanelType: %s", DialogueData.DialogueId, DialoguePanelType))
		Callback()
		return
	end
	self.StoryPanelUI = UIManager(GWorld.GameInstance):LoadUINew("NpcBiography",
			GText(Topic),
			GText(Content),
			AnimationName)
	if self.StoryPanelUI then
		-- DebugPrint("TryShowStoryPanelUI self.StoryPanelUI", Type)
		--self.UI:SetVisibility(ESlateVisibility.Collapsed)
		self.StoryPanelUI:BindOnRealClose(function()
			--self.UI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			self:TryReleaseStoryPanelUI()
			--- 顺序还是很重要的，先销毁旧资源，防止Callback重入
			Callback()
		end)
		return
	end
	Callback()
	return
end

function TalkTaskBase_C:TryReleaseStoryPanelUI()
	local StoryPanelUI = self.StoryPanelUI
	self.StoryPanelUI = nil
	if IsValid(StoryPanelUI) then
		StoryPanelUI:UnBindOnRealClose()
		UIManager(GWorld.GameInstance):UnLoadUINew("NpcBiography")
	end
end

function TalkTaskBase_C:SwitchHideDialoguePanel(bHide)
	if self.UI.SwitchHideDialoguePanel then
		self.UI:SwitchHideDialoguePanel(bHide)
	end
end

function TalkTaskBase_C:CreateDialogueIteratorComponent()
	if self.TalkTaskData then
    	self.DialogueIterationComponent = FDialogueIterationComponent:New(DataMgr.Dialogue, self.TalkTaskData.FirstDialogueId, self)
    end
end

function TalkTaskBase_C:CreateDialogueRecordComponent()
    self.DialogueRecordComponent = FDialogueRecordComponent:New(self, self.TaskData)
end

function TalkTaskBase_C:CreateDialogueFlowGraphComponent()
    self.DialogueFlowGraphComponent = FDialogueFlowGraphComponent:New(self, self.TaskData)
end

function TalkTaskBase_C:CreateComponents()
	self:CreateDialogueRecordComponent()
	self:CreateDialogueFlowGraphComponent()
end

function TalkTaskBase_C:OnTalkStart(TalkTaskData)
	self.TalkContext:OnTalkStart(self)
	if TalkTaskData.bHideMonsters then
		self.HideAllMonstersComponent = FHideAllMonstersComponent:New()
	end
	if TalkTaskData.bHideNpcs then
		self.HideAllNpcsComponent = FHideAllNpcsComponent:New()
	end
end

function TalkTaskBase_C:SwitchEnableComponent(Comp, bEnable)
	if not Comp then
		return
	end

	if bEnable then
		if not self.ExecutedComps[Comp] then
			Comp:Execute()
			self:RecordExecutedComp(Comp)
		end
	else
		Comp:Resume()
		Comp = nil -- Resume后生命周期结束
	end
end

function TalkTaskBase_C:RecordExecutedComp(Comp)
	if Comp then
		self.ExecutedComps[Comp] = true
	end
end

function TalkTaskBase_C:SetOutport()
	--待子类实现
end

--临时版本
function TalkTaskBase_C:OnTalkEnd()
	self.TalkContext:OnTalkEnd()
end

function TalkTaskBase_C:ProcessShowHide(bIsBegin)
	self:SwitchEnableComponent(self.HideAllBattleEntityComponent, bIsBegin)
	self:SwitchEnableComponent(self.HideAllEffectComponent, bIsBegin)
    self:SwitchEnableComponent(self.HideMechanismsFXComponent, bIsBegin)

	if bIsBegin then
		if self.HideAllMonstersComponent then
			self.HideAllMonstersComponent:DoHide()
		end
		if self.HideAllNpcsComponent then
			self.HideAllNpcsComponent:DoHide()
		end
		if self.TalkTaskData.bShowInteractiveActor then
			self.TalkContext:ShowInteractiveActor(true)
		end
	else
		if self.HideAllMonstersComponent then
			self.HideAllMonstersComponent:ResumeHide()
		end
		if self.HideAllNpcsComponent then
			self.HideAllNpcsComponent:ResumeHide()
		end
	end
end

------------------内部开发函数----------------------
function TalkTaskBase_C:ResolveDialoguePanelType(DialoguePanelType)
	if DialoguePanelType then
		DialoguePanelType = string.lower(DialoguePanelType)
		local Type = TalkUtils:FindTargetString(DialoguePanelType, 'type')
		local Style = TalkUtils:FindTargetString(DialoguePanelType, 'style')
		Type = TalkUtils:FirstToUpper(Type)
		Style = TalkUtils:FirstToUpper(Style)
		DebugPrint("TalkTaskBase_C:ResolveDialoguePanelType", Type, Style)
		return {
			Type = Type,
			Style = Style,
		}
	end
end

function TalkTaskBase_C:GetDebugMetaInfo()
	if self.DebugMetaInfo then
		return self.DebugMetaInfo
	end

	self.DebugMetaInfo = {}
	if not self.TalkTaskData then
		self.DebugMetaInfo["任务数据为空"] = self
		return self.DebugMetaInfo
	end

	local Data = self.TalkTaskData
	if Data.TalkNodeName then
		table.insert(self.DebugMetaInfo, { "对话节点名字", Data.TalkNodeName })
	end
	if Data.TalkTriggerId then
		table.insert(self.DebugMetaInfo, { "TalkTriggerId", Data.TalkTriggerId })
	end
	table.insert(self.DebugMetaInfo, { "对话类型", Data.TalkType })
	if Data.Key then
		table.insert(self.DebugMetaInfo, { "Key", Data.Key })
	end
	table.insert(self.DebugMetaInfo, { "首句台词ID", Data.FirstDialogueId })

	if Data.FlowAssetPath then
		table.insert(self.DebugMetaInfo, { "对话Flow Path", Data.FlowAssetPath })
	end

	return self.DebugMetaInfo
end

------------------内部开发函数----------------------

return TalkTaskBase_C
