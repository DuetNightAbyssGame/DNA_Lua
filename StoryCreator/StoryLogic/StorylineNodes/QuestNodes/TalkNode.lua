local TalkNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

local ETalkType = require "BluePrints.Story.Talk.Base.ETalkType"
local ETalkNodeFinishType = require 'StoryCreator.StoryLogic.StorylineUtils'.ETalkNodeFinishType
local GameFlowUtils = require "Utils.GameFlowUtils"

function TalkNode:Init()
	self.Options = nil
	self.TalkTask = nil
	self.TalkTaskData = nil
	self.NpcId = 0
	self.TalkContext = nil
	self.GuideType = nil
	self.GuidePointName = nil
	self.QuestHintId = 0
	self.GuideUIEnable = false
	self.bSpecifyExecution = false
	self.DelayShowGuideTime = 0
end

function TalkNode:Execute(Callback)
	self.Callback = Callback
	self.TalkContext = GWorld.GameInstance:GetTalkContext()
	self.TalkBasicType = DataMgr.TalkType[self.TalkType].BasicType
	self:CreateTalkNodeData()
	self:ShowGuide()
	self:SwitchStart()
end

function TalkNode:Clear()
	self:HideGuide()
	GWorld.StoryMgr:UnbindNPCInteractiveTalk(self.NpcIdWithGender, self.BindId)

	if (self.bIsImmersiveStory) then
		GameFlowUtils:RemoveFlow(self.Flow)
		self.Flow = nil
	end

	if not self:IsNormalFinished() then
		local TS = TalkSubsystem()
		assert(TS, "对话系统必须存在")
		TS:ExceptionInterruptTaskBySTL(self.TalkTaskKey)
	end
end

function TalkNode:CreateTalkNodeData()
	self.TalkNodeData = {
		FilePath = self.Context.FilePath,
		QuestChainId = self.Context.QuestChainId,
		TalkNodeId = self.Key,
		Options = self.Options,
		FirstDialogueId = self.FirstDialogueId,
		TalkName = self.Name,
		TalkType = self.TalkType,
		BubblePlayType = self.BubblePlayType,
		BubbleDelayLoopSeconds = self.BubbleDelayLoopSeconds,
		bBubblePlayCDEnable = self.bBubblePlayCDEnable,
		BubblePlayCD = self.BubblePlayCD,
		TalkStageName = self.TalkStageName,
		ShowFilePath = self.ShowFilePath,
		BlendInTime = self.BlendInTime,
		BlendOutTime = self.BlendOutTime,
		BlendInType = self.InType,
		BlendOutType = self.OutType,
		ForceAutoPlay = self.ForceAutoPlay,
		ShowSkipButton = self.ShowSkipButton,
		ShowAutoPlayButton = self.ShowAutoPlayButton,
		ShowReviewButton = self.ShowReviewButton,
		ShowWikiButton = self.ShowWikiButton,
		PauseGameGlobal = self.PauseGameGlobal,
		DisableMonsterAI = self.DisableMonsterAI,
		DisableNPCAI = self.DisableNPCAI,
		HideAllBattleEntity = self.HideAllBattleEntity,
		HideElseCharacter = self.HideElseCharacter,
		RestoreStand = self.RestoreStand,
		TalkActors = self.TalkActors or {},
		IsPlayerTurnToNPC = self.IsPlayerTurnToNPC,
		IsNPCTurnToPlayer = self.IsNPCTurnToPlayer,
		GuideMeshIndexList = self.GuideMeshIndexList,
		BeginNewTargetPointName = self.BeginNewTargetPointName,
		EndNewTargetPointName = self.EndNewTargetPointName,
		CameraLookAtTartgetPoint = self.CameraLookAtTartgetPoint,
		SkipToOption = self.SkipToOption,
		RandomOptionNum = self.RandomOptionNum,
		SaveToServer = self.SaveToServer,
		OptionType = self.OptionType,
		NormalOptions = self.NormalOptions,
		RandomOptions = self.RandomOptions,
		PlusOptions = self.PlusOptions,
		CheckOptions = self.CheckOptions,
		RougeLikeOptions = self.RougeLikeOptions,
		UseProceduralCamera = self.UseProceduralCamera,
		ProceduralCameraId = self.ProceduralCameraId,
		IsPlayStartSound = self.IsPlayStartSound,
		GuideTalkStyle = self.GuideTalkStyle,
		Name = self.Name,
		HideEffectCreature = self.HideEffectCreature,
		HideNpcs = self.HideNpcs,
		HideMonsters = self.HideMonsters,
        bHideMechanismsFX = self.HideMechanismsFX,
		DisableNpcOptimization = self.DisableNpcOptimization,
		DoNotReceiveCharacterShadow = self.DoNotReceiveCharacterShadow,
		bPauseTimeElapse = self.PauseTimeElapse,
		FreezeWorldComposition = self.FreezeWorldComposition,
		bTravelFullLoadWorldComposition = self.bTravelFullLoadWorldComposition,
		SwitchToMasterType = self.SwitchToMaster,
		bOverrideFailBlend = self.OverrideFailBlend,
		FailOutType = self.FailOutType,
		FailOutTime = self.FailOutTime,
		Key = self.Key,
		UsingGM = self.UsingGM,
		TalkTriggerId = self:GetPayload("TalkTriggerId"),
		InteractiveActorId = self:GetPayload("InteractiveActorId"),
		PlayDialogueCallBack = self:GetPayload("PlayDialogueCallBack"),
		FlowAssetPath = self.FlowAssetPath,
    	PauseNpcBT = self.PauseNpcBT,
		ShowFadeDetail = self.ShowFadeDetail,
		StartFadeOutTime = self.StartFadeOutTime,
		StartScreenEffectDuration = self.StartScreenEffectDuration,
		FinishFadeInTime = self.FinishFadeInTime,
		PlayerSwitchEmoIdle = self.PlayerSwitchEmoIdle,
        bNpcActionKeepIn = self.bNpcActionKeepIn,
        bNpcActionKeepOut = self.bNpcActionKeepOut,
		bUseFlowAssetActors = self.bUseFlowAssetActors,
		bForceWaitNavLoaded = self.bForceWaitNavLoaded,
	}

	local NativeTalkActors = {}
	for _, ActorData in pairs(self.TalkNodeData.TalkActors) do
		NativeTalkActors[ActorData.TalkActorId] = true
	end

	if (self.IsNpcNode) then
		if (not NativeTalkActors[0]) then
			table.insert(self.TalkNodeData.TalkActors, {
				TalkActorType = "Player",
				TalkActorId = 0,
				TalkActorVisible = true
			})
			NativeTalkActors[0] = true
		end

		if (not NativeTalkActors[self.NpcId]) then
			table.insert(self.TalkNodeData.TalkActors, {
				TalkActorType = "Npc",
				TalkActorId = self.NpcId,
				TalkActorVisible = true
			})
			NativeTalkActors[self.NpcId] = true
		end
	end

	for _, ActorData in pairs(self:GetPayload("TalkActors") or {}) do
		if (not NativeTalkActors[ActorData.TalkActorId]) then
			table.insert(self.TalkNodeData.TalkActors, ActorData)
			NativeTalkActors[ActorData.TalkActorId] = true
		end
	end
end

function TalkNode:SwitchStart()
	if self.IsNpcNode then
		local BindId
        local NpcIdWithGender = self.NpcId
        if (NpcIdWithGender) then
            NpcIdWithGender = URuntimeCommonFunctionLibrary.GetNPCIdByGender(GWorld.GameInstance, NpcIdWithGender)
        end

		self.NpcIdWithGender = NpcIdWithGender
		local NpcNodeInteractiveName = (string.isempty(self.NpcNodeInteractiveName) and nil) or self.NpcNodeInteractiveName
		local Detail = {
			QuestChainId = self.TalkNodeData.QuestChainId,
			SpecialQuestId = self:GetPayload("SpecialQuestId"),
			DynQuestId = self:GetPayload("DynQuestId"),
			NpcNodeInteractiveName = NpcNodeInteractiveName,
			GuideUIEnable = self.GuideUIEnable,
			Func = function(NPC, OnTalkEndCallback)
				GWorld.StoryMgr:UnbindNPCInteractiveTalk(NpcIdWithGender, BindId)
				self:TalkNodeStartInternal(function(TalkNodeFinishType, OptionIndex)
					if (OnTalkEndCallback) then
						OnTalkEndCallback.Func(OnTalkEndCallback.Obj)
					end
					self:TalkNodeFinishInternal(TalkNodeFinishType, OptionIndex)
				end)
			end
		}
		self.BindId = GWorld.StoryMgr:BindNPCInteractiveTalk(NpcIdWithGender, Detail)
	else
		if (self.bIsStandalone) then
			self:TalkNodeStartInternal()
			self:TalkNodeFinishInternal()
		else
			self:TalkNodeStartInternal(function(TalkNodeFinishType, OptionIndex)
				self:TalkNodeFinishInternal(TalkNodeFinishType, OptionIndex)
			end)
		end
	end
end

function TalkNode:TalkNodeStartInternal(TalkTaskEndLambdaCallback)
	local BasicTalkType = DataMgr.TalkType[self.TalkType].BasicType
	self.bIsImmersiveStory = BasicTalkType == ETalkType.Cinematic or
			BasicTalkType == ETalkType.FreeSimple or
			BasicTalkType == ETalkType.FixSimple or
			BasicTalkType == ETalkType.Impression or
			BasicTalkType == ETalkType.Black

	if (self.bIsImmersiveStory) then
		self.Flow = GameFlowUtils:AddFlow("ImmersiveStory", {
			GWorld.GameInstance, function(_, Flow)
				local TS = TalkSubsystem()
				self.TalkTaskKey = TS:RegisterTalkData(self.TalkNodeData)
				TS:RegisterTalkTask(self.TalkTaskKey, TalkTaskEndLambdaCallback, function()
					self:TalkNodeFinishInternal()
				end)
			end
		})
	else
		local TS = TalkSubsystem()
		self.TalkTaskKey = TS:RegisterTalkData(self.TalkNodeData)
		TS:RegisterTalkTask(self.TalkTaskKey, TalkTaskEndLambdaCallback, function()
			self:TalkNodeFinishInternal()
		end)
	end
end

function TalkNode:TalkNodeFinishInternal(TalkNodeFinishType, OptionIndex)
	TalkNodeFinishType = TalkNodeFinishType or ETalkNodeFinishType.Out

	TalkSubsystem():UnregisterTalkData(self.TalkTaskKey)

	if self.TalkContext.TalkCameraManager then
		self.TalkContext.TalkCameraManager:ClearTalkCamera()
	end
	self.TalkTaskKey = nil

	if TalkNodeFinishType == ETalkNodeFinishType.Stop then
		self:StopStory()
	else
		local OutPortName = self:CalOutPortName(TalkNodeFinishType, OptionIndex)
		self.Callback(OutPortName)
	end
	UIManager():FallbackAfterLoadingMgr()
end

function TalkNode:ShowGuide()
	if self.GuideUIEnable then
		if self.DelayShowGuideTime > 0 then
			self.ShowGuideTimer = GWorld.GameInstance:AddTimer(self.DelayShowGuideTime, function()
				MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
			end, false)
		else
			MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
		end
	end
end

function TalkNode:HideGuide()
	if self.GuideUIEnable then
		if self.ShowGuideTimer ~= nil then
			GWorld.GameInstance:RemoveTimer(self.ShowGuideTimer)
			self.ShowGuideTimer = nil
		end
		MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
	end
end

function TalkNode:IsNormalFinished()
	return self.TalkTaskKey == nil
end

--仅限印象检定中按退出按钮时调用
function TalkNode:StopStory()
	if self.TalkNodeData.QuestChainId ~= 0 then
    	self.Context:FailQuest()
    else
		self.Context:StopStory()
	end
end

function TalkNode:CalOutPortName(TalkNodeFinishType, OptionIndex)
	assert(TalkNodeFinishType, "对话节点完成类型不能为空")

	local OutPortName = TalkNodeFinishType
	if (TalkNodeFinishType == ETalkNodeFinishType.Out) then
		OutPortName = "Out"
	elseif (TalkNodeFinishType == ETalkNodeFinishType.Option) then
		assert(OptionIndex, "对话节点完成类型为Option时，选项索引不能为空")
		OutPortName = "Option_" .. OptionIndex
	elseif (TalkNodeFinishType == ETalkNodeFinishType.Fail) then
		OutPortName = "Fail"
	end
	return OutPortName
end

return TalkNode
