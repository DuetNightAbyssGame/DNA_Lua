local TalkTaskState = require "BluePrints.Story.Talk.Base.TalkTaskState"
local ETalkType = require "BluePrints.Story.Talk.Base.ETalkType"
local FHideGameUIComponent = require "BluePrints.Story.Components.HideGameUIComponent"
local FPauseGameComponent = require "BluePrints.Story.Components.PauseGameComponent"
local FDisableNpcPerformanceOptimizationComponent = require "BluePrints.Story.Components.DisableNpcPerformanceOptimizationComponent"
local FHideAllEffectComponent = require "BluePrints.Story.Components.HideAllEffectComponent"
local FHideMechanismsFXComponent = require "BluePrints.Story.Components.HideMechanismsFXComponent"
local FSoundEffectComponent = require "BluePrints.Story.Components.SoundEffectComponent"
local ETalkNodeFinishType = require 'StoryCreator.StoryLogic.StorylineUtils'.ETalkNodeFinishType
local FDisablePlayerInputComponent = require "BluePrints.Story.Components.DisablePlayerInputComponent"
local FDisableNpcMovementComponent = require "BluePrints.Story.Components.DisableNpcMovementComponent"
local FSetForceLodComponent = require "BluePrints.Story.Components.SetForceLodComponent"
local FDisableCameraArmComponent = require "BluePrints.Story.Components.DisableCameraArmComponent"
local FSwitchEmoIdleComponent = require "BluePrints.Story.Components.SwitchEmoIdleComponent"
local FDisableInteractiveComponent = require "BluePrints.Story.Components.DisableInteractiveComponent"
local FDialogueWikiComponent = require "BluePrints.Story.Components.DialogueWikiComponent"
local FHideAllBattleEntityComponent = require "BluePrints.Story.Components.HideAllBattleEntityComponent"
local FStopPlayerActionComponent = require "BluePrints.Story.Components.StopPlayerActionComponent"
local FEnableCharacterDitherComponent = require "BluePrints.Story.Components.EnableCharacterDitherComponent"
local FDisableCharacterDitherComponent = require "BluePrints.Story.Components.DisableCharacterDitherComponent"
local FFreezeWorldCompositionComponent = require "BluePrints.Story.Components.FreezeWorldCompositionComponent"
local FSwitchToMasterComponent = require "BluePrints.Story.Components.SwitchToMasterComponent"
local FSetPlayerInvincibleComponent = require "BluePrints.Story.Components.SetPlayerInvincibleComponent"
local FPauseTimeElapseComponent = require "BluePrints.Story.Components.PauseTimeElapseComponent"
local SimpleDialogueData_C = require "BluePrints.Story.Talk.Model.DialogueData".SimpleDialogueData_C
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local TalkOptionData_C = require "BluePrints.Story.Talk.Model.TalkOptionData".TalkOptionData_C
local ETalkOptionType = require "BluePrints.Story.Talk.Model.TalkOptionData".ETalkOptionType
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local EMLuaConst = require "EMLuaConst"

local WaitQueueTag = {
	CameraBlend = "CameraBlend",
	KeepBlack = "KeepBlack",
	CreateActors = "CreateActors",
	NpcRotateToPlayer = "NpcRotateToPlayer",
	PlayerRotateToNpc = "PlayerRotateToNpc",
	PlayerMove = "PlayerMove",
}

local WaitItemUniqueTag = {
	UIPlayDialogue = "UIPlayDialogue",
	PlayAction = "PlayAction",
	RotateTo = "RotateTo",
	Lookat = "Lookat",
	CameraBlend = "DialogueCameraBlend",
	PlayAudio = "PlayAudio",
	PlayScript = "PlayScript",
	WaitFlowEnd = "WaitFlowEnd",
    AutoPlayDelay = "AutoPlayDelay",
}

local CommonTalkTask = Class({ "BluePrints.Story.Talk.Controller.TalkTaskBase" })

function CommonTalkTask:Start(TalkTaskData, TaskFinishedCallback)
	CommonTalkTask.Super.Start(self, TalkTaskData, TaskFinishedCallback)
	self:InitData(TalkTaskData, TaskFinishedCallback)

	if (not self.TalkContext:RequestRegisterTalkTask(self, TalkTaskData.TalkType, TalkTaskData.BasicTalkType)) then
		self:End(ETalkNodeFinishType.Out)
		return
	end

	if (not self:CheckResource()) then
		self:TryFireEndingCallback(0, 0)
		return
	end

	AudioManager(GWorld.GameInstance):AddAuANotifyForbidTag(self.UnitKey)

	-- 设置剧情内阴影更新频率
	local TalkSubsystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.TalkContext, UE4.UTalkSubsystem)
	if (IsValid(TalkSubsystem)) then
		TalkSubsystem:SetShadowParamsEnabled(true)
	end

	-- 处理镜头切换光照闪烁问题
	UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.Shadow.CacheViewLocation 1")

	-- 关闭硬件遮挡查询，用于处理修复剧情镜头瞬切，场景闪烁问题
	if EMLuaConst.bDisableOcclusionInTalk then
		UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.AllowOcclusionQueries 0")
	end
	--UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.HZBOcclusion 0")
	URuntimeCommonFunctionLibrary.SetSceneOcclusionThreshold(10.0, 50.0)

	-- 开启动态分辨率
	GWorld.GameInstance:SetDynamicResolution("Talk", true)

	EventManager:FireEvent(EventID.StartTalk, {
		TalkType = TalkTaskData.TalkType,
		bExitOnline = TalkTaskData.bExitOnline,
		bDisableGameInput = TalkTaskData.bDisableGameInput,
	})

	self:InitUI()
	self:OnTalkStart(TalkTaskData)
	self:SwitchEnableComponent(self.DialogueWikiComponent, true)
	self:SwitchEnableComponent(self.SetPlayerInvincibleComponent, true)
	self:SwitchEnableComponent(self.FreezeWorldCompositionComponent, true)
	self:SwitchEnableComponent(self.DisablePlayerInputComponent, true)
	self:SwitchEnableComponent(self.DisableInteractiveComponent, true)
	self:SwitchEnableComponent(self.SoundEffectComponent, true)
	self:SwitchEnableComponent(self.HideGameUIComponent, true)
	self:SwitchEnableComponent(self.SwitchToMasterComponent, true)
	self:SwitchEnableComponent(self.DisableCharacterDitherComponent, true)
	self:SwitchEnableComponent(self.EnableCharacterDitherComponent, true)
	self:SwitchEnableComponent(self.DisableNpcPerformanceOptimizationComponent, true)
	self:SwitchEnableComponent(self.DisableCameraArmComponent, true)
	self:SwitchEnableComponent(self.SwitchEmoIdleComponent, true)
	self:SwitchEnableComponent(self.PauseTimeElapseComponent, true)
	self:OnCinematicBegin()
	self.UI:PreEnterTalkTask(self, self.TalkTaskData)

	self:FadeInBlack(self.TalkTaskData.BlendInType == "FadeIn", self.TalkTaskData.BlendInTime, function()
		self:TravelPlayer(self.TalkTaskData.BeginTargetPoint, function()
			self:SetViewTargetToStage(function()
				self:WaitNavLoadFinish(function()
					self:BlendIn(self.TalkTaskData.CameraType, function()
						self:PreStartPerformance()
					end)
				end)
			end)
		end)
	end)
end

function CommonTalkTask:Finish(TalkNodeFinishType, OptionIndex)
	self.FinishType = self.OverriddenFinishType or TalkNodeFinishType
	self.FinishOptionIndex = self.OverriddenFinishIndex or OptionIndex
	local TalkTaskData = self.TalkTaskData
	if self.FinishType == ETalkNodeFinishType.Fail then
		if TalkTaskData.bOverrideFailBlend then
			TalkTaskData.BlendOutType = TalkTaskData.FailOutType
			TalkTaskData.BlendOutTime = TalkTaskData.FailOutTime
		end
	end
	self.TalkTaskState = TalkTaskState.OnFinish

	self:UnbindDelegate()
	self:SwitchEnableComponent(self.SoundEffectComponent, false)
	self:SwitchEnableComponent(self.PauseGameComponent, false)

    self.UI:PreExitTalkTask(self, self.TalkTaskData)
	self:FadeInBlack(self.TalkTaskData.BlendOutType == "FadeOut" and TalkTaskData.CameraType ~= "SequenceCamera", self.FinishFadeInTime, function()
		if self.ExpressionComp then
			self.ExpressionComp:Clear()
		end

		if (not self.TalkTaskData.bNpcActionKeepOut) then
			self.TalkActionManager:Clear(self)
			self:PlayNpcDefaultAction(self.TalkTaskData.BasicTalkType == "FixSimple", self.TalkTaskData.TalkActors)
		end

		self:StopDSL()
		self:TryEndFlowGraph()
		self:NPCEnableSkeletalMeshActorRules(self.TalkTaskData.TalkType == "Cinematic", false)
		self:ResetStageSetting(self.TalkTaskData.TalkStage)
		self.TalkContext:DestoryTalkActors(self, self.TalkTaskData.TalkActors)
		self:TryHideDialogueBlackUI()
		self.TalkContext:ConditionalRecoverCharacterShadowSetting(self.TalkTaskData)
		self:ProcessShowHide(false)
		UIManager(GWorld.GameInstance):UnLoadUINew(self:GetUIName())

		self:BlendOut(self.TalkTaskData.CameraType, function()
			self.UI:PostExitTalkTask(self, self.TalkTaskData)
			self:SetViewTargetToPlayer(function()
				self:TravelPlayer(self.TalkTaskData.EndTargetPoint, function()
					if (self.TalkTaskData.CameraLookAtTartgetPoint) then
						UE4.UAsyncCameraLookToTargetAction.CameraLookToNewTargetPoint(self.TalkContext, self.TalkTaskData.CameraLookAtTartgetPoint, 0, nil, false)
					end
					self:FadeOutBlack(self.TalkTaskData.BlendOutType == "FadeOut", self.TalkTaskData.BlendOutTime, function()
						self:End(self.FinishType, self.FinishOptionIndex)
					end)
				end)
			end)
		end)
	end)
end

function CommonTalkTask:End(TalkNodeFinishType, OptionIndex)
	-- 还原剧情内阴影更新频率
	local TalkSubsystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.TalkContext, UE4.UTalkSubsystem)
	if (IsValid(TalkSubsystem)) then
		TalkSubsystem:SetShadowParamsEnabled(false)
	end

	-- 处理镜头切换光照闪烁问题
	UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.Shadow.CacheViewLocation 0")

	-- 开启硬件遮挡查询
	if EMLuaConst.bDisableOcclusionInTalk then
		UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.AllowOcclusionQueries 1")
	end
	--UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.HZBOcclusion 1")
	URuntimeCommonFunctionLibrary.SetSceneOcclusionThreshold(45.0, 10000)

	-- 关闭动态分辨率
	GWorld.GameInstance:SetDynamicResolution("Talk", false)

	self:Clear()
	self:OnTalkEnd()
	self:SwitchEnableComponent(self.DisableNpcPerformanceOptimizationComponent, false)
	self:SwitchEnableComponent(self.DisableCharacterDitherComponent, false)
	self:SwitchEnableComponent(self.EnableCharacterDitherComponent, false)
	self:SwitchEnableComponent(self.FreezeWorldCompositionComponent, false)
	self:SwitchEnableComponent(self.SetPlayerInvincibleComponent, false)
	self:SwitchEnableComponent(self.SwitchToMasterComponent, false)
	self:SwitchEnableComponent(self.DialogueWikiComponent, false)
	self:SwitchEnableComponent(self.HideGameUIComponent, false)
	self:SwitchEnableComponent(self.DisableCameraArmComponent, false)
	self:SwitchEnableComponent(self.SwitchEmoIdleComponent, false)
	self:SwitchEnableComponent(self.DisablePlayerInputComponent, false)
	self:SwitchEnableComponent(self.DisableInteractiveComponent, false)
	self:SwitchEnableComponent(self.DisableNpcMovementComponent, false)
	self:SwitchEnableComponent(self.SetForceLodComponent, false)
	self:SwitchEnableComponent(self.PauseTimeElapseComponent, false)
	self:TryReleaseStoryPanelUI()
	self.TalkContext:UnRegisterTalkTask(self)

	EventManager:FireEvent(EventID.EndTalk, {
		TalkType = self.TalkTaskData.TalkType,
		bExitOnline = self.TalkTaskData.bExitOnline,
		bDisableGameInput = self.TalkTaskData.bDisableGameInput,
	})

	self:TryFireEndingCallback(TalkNodeFinishType, OptionIndex)
end

function CommonTalkTask:Clear()
	-- 将父类代码转移到此处，以确保在子类中调用时能正确执行
	TalkUtils:RemovePlayerInvincible()
	local BasicType = self:GetBasicTalkType()
	if BasicType == ETalkType.FixSimple or
			BasicType == ETalkType.FreeSimple or
			BasicType == ETalkType.Black or
			BasicType == ETalkType.Cinematic or
			BasicType == ETalkType.Impression then
		if self.TalkContext then
			self.TalkContext.TalkTimerManager:ClearTimer(self)
			self.TalkContext.WaitQueueManager:ClearGroup(self)
			self.TalkContext.TalkDelegateManager:ClearGroup(self)
			self.TalkContext.TalkActionManager:StopAllLookAt(self)
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
			if (IsValid(TS)) then
				TS:UnRegisterFlowTalkTask(self.TalkTaskData.FlowAssetPath)
			end
		end
		if self:GetUIName() then
			UIManager(GWorld.GameInstance):UnLoadUINew(self:GetUIName())
		end
	end

	AudioManager(GWorld.GameInstance):RemoveAuANotifyForbidTag(self.UnitKey)

	self:ClearAudio()

	if (IsValid(self.StageViewTarget)) then
		self.StageViewTarget:K2_DestroyActor()
		self.StageViewTarget = nil
	end
end

function CommonTalkTask:PreStartPerformance()
	self:ProcessShowHide(true)
	self.TalkContext:ConditionalSetupCharacterShadowSetting(self.TalkTaskData)

	-- 隐藏玩家属于外部环境，防止其他演员生成、设置位置与其产生碰撞
	local TS = TalkSubsystem()
	if IsValid(TS) then
		TS:TalkHidePlayerCharacter(self.Player, true, Const.TalkHideTag)
	end

	local WaitQueue = self.WaitQueueManager:CreateWaitQueue(self, {
		{ Tag = WaitQueueTag.KeepBlack },
		{ Tag = WaitQueueTag.CreateActors }
	}, nil, function()
		self:ActorsAroundPlayer(self.TalkTaskData.TalkActors)
		self:ApplyStageSetting(self.TalkTaskData.TalkStage)
		-- 其他演员生成、设置位置完成，显示玩家
		TS:TalkHidePlayerCharacter(self.Player, false, Const.TalkHideTag)
		self.TalkContext:ShowHideInTalkActors()
		self:StartPerformance()
	end)

	-- 保证 FadeIn 之后的黑屏至少有 1s
	self:KeepBlack(self.TalkTaskData.BlendInType == "FadeIn", self.ScreenEffectDurationSeconds, function()
		WaitQueue:CompleteWaitItem(WaitQueueTag.KeepBlack)
	end)

	local DefaultCreateLocation = FVector(0, 0, 0)
	if (IsValid(self.TalkTaskData.TalkStage)) then
		DefaultCreateLocation = self.TalkTaskData.TalkStage:K2_GetActorLocation()
	elseif (IsValid(self.Player)) then
		DefaultCreateLocation = self.Player:K2_GetActorLocation()
	end

	self:CreateActors(self.TalkTaskData.TalkActors, DefaultCreateLocation, function()
		WaitQueue:CompleteWaitItem(WaitQueueTag.CreateActors)
	end)
end

function CommonTalkTask:StartPerformance()
	self:NPCEnableSkeletalMeshActorRules(self.TalkTaskData.TalkType == "Cinematic", true)
	self:FadeOutBlack(self.TalkTaskData.BlendInType == "FadeIn", self.TalkTaskData.BeginFadeOutTime)
	self:StopNpcDefaultAction(not self.TalkTaskData.bNpcActionKeepIn and self.TalkTaskData.BasicTalkType == "FixSimple", self.TalkTaskData.TalkActors)

	self:StartDialogueFlow()
end

function CommonTalkTask:StartDialogueFlow()
	self.UI:PostEnterTalkTask(self, self.TalkTaskData)
	self:BindDelegate()
	self:SetCanResponseUIClick(true)
	self:SwitchEnableComponent(self.PauseGameComponent, true)
	self:SwitchEnableComponent(self.DisableNpcMovementComponent, true)
	self:SwitchEnableComponent(self.SetForceLodComponent, true)
	self:TryPlaySequence()
	self:StartDialogueIteration()
end

function CommonTalkTask:ActorsAroundPlayer(ActorInfos)
	local AroundActors = {}
	local ActorInfos = ActorInfos or {}
	for _, ActorInfo in ipairs(ActorInfos) do
		if (ActorInfo.AroundPlayer) then
			local ActorData = self.TalkContext:GetTalkActorData(self, ActorInfo.TalkActorId)
			if (ActorData and IsValid(ActorData.TalkActor)) then
				table.insert(AroundActors, ActorData.TalkActor)
			end
		end
	end

	local Locations = self.TalkContext:GetNPCStandPositions(UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0), #AroundActors, true)
	for i, Actor in ipairs(AroundActors) do
		if (IsValid(Actor)) then
			Actor:K2_SetActorLocation(Locations[i], false, nil, true)
			Actor:ResetLocation()
		end
	end
end

function CommonTalkTask:ApplyStageSetting(Stage)
	if (not IsValid(Stage)) then
		return
	end

	for i = 1, Stage.StaticCreateActors:Length() do
		local StaticCreateActor = Stage.StaticCreateActors:GetRef(i)
		if (IsValid(StaticCreateActor)) then
			if (string.lower(StaticCreateActor.UnitType) == "npc") then
				local NpcData = self.TalkContext:GetTalkActorData(self, StaticCreateActor.UnitId)
				if (NpcData) then
					local Npc = NpcData.TalkActor
					if (IsValid(Npc) and Npc:IsA(UE4.ANpcCharacter)) then
						self:CacheNpcTransform(Npc)
						Npc:SetStagePoint(StaticCreateActor)
						local Location = StaticCreateActor:k2_GetActorLocation() + UE4.UKismetMathLibrary.Multiply_VectorFloat(Npc:GetActorUpVector(), Npc.CapsuleComponent.CapsuleHalfHeight)
						Npc:K2_SetActorLocationAndRotation(Location, StaticCreateActor:K2_GetActorRotation(), false, nil, true)

						local ResetLocationIgnoreActors = {}
						if DataMgr.Npc[Npc.UnitId] and DataMgr.Npc[Npc.UnitId].IsSit == 2 then
							ResetLocationIgnoreActors = Npc:GetStandNearlyStaticMeshAndMechanism()
						end

						Npc:ResetLocation(ResetLocationIgnoreActors)
					end
				end
			end
		end
	end
end

function CommonTalkTask:ResetStageSetting(Stage)
	if (not IsValid(Stage)) then
		return
	end

	for i = 1, Stage.StaticCreateActors:Length() do
		local StaticCreateActor = Stage.StaticCreateActors:GetRef(i)
		if (IsValid(StaticCreateActor)) then
			if (string.lower(StaticCreateActor.UnitType) == "npc") then
				local NpcData = self.TalkContext:GetTalkActorData(self, StaticCreateActor.UnitId)
				if (NpcData) then
					local Npc = NpcData.TalkActor
					if (IsValid(Npc) and Npc:IsA(UE4.ANpcCharacter)) then
						self:ResetNpcTransform(Npc)
					end
				end
			end
		end
	end
end

function CommonTalkTask:NPCEnableSkeletalMeshActorRules(bEnableFunction, bEnable)
	if (not bEnableFunction) then
		return
	end

	for _, ActorInfo in ipairs(self.TalkTaskData.TalkActors) do
		if (ActorInfo.TalkActorType == "Npc") then
			local ActorData = self.TalkContext:GetTalkActorData(self, ActorInfo.TalkActorId)
			if (ActorData and IsValid(ActorData.TalkActor) and ActorData.TalkActor:IsA(UE4.ANpcCharacter)) then
				ActorData.TalkActor:EnableSkeletalMeshActorRules(bEnable)
			end
		end
	end
end

function CommonTalkTask:FadeInBlack(bEnable, FadeInSeconds, Callback)
	bEnable = bEnable or false
	FadeInSeconds = FadeInSeconds or 0
	Callback = Callback or function()
	end

	if (not bEnable or FadeInSeconds == 0) then
		Callback()
		return
	end

	local BlackHandle = UIManager(GWorld.GameInstance):ShowCommonBlackScreen({
		InAnimationPlayTime = FadeInSeconds
	})
	GWorld.GameInstance:AddTimer(FadeInSeconds, function()
		UIManager(GWorld.GameInstance):CloseCommonBlackScreenWithoutCB(BlackHandle)
		Callback()
	end, false, 0, nil, true)
end

function CommonTalkTask:FadeOutBlack(bEnable, FadeOutSeconds, Callback)
	bEnable = bEnable or false
	FadeOutSeconds = FadeOutSeconds or 0
	Callback = Callback or function()
	end

	if (not bEnable or FadeOutSeconds == 0) then
		Callback()
		return
	end

	local BlackHandle = UIManager(GWorld.GameInstance):ShowCommonBlackScreen({
		OutAnimationPlayTime = FadeOutSeconds,
		IsPlayOutWhenLoaded = true
	})
	GWorld.GameInstance:AddTimer(FadeOutSeconds, function()
		UIManager(GWorld.GameInstance):CloseCommonBlackScreenWithoutCB(BlackHandle)
		Callback()
	end, false, 0, nil, true)
end

function CommonTalkTask:KeepBlack(bEnable, KeepSeconds, Callback)
	bEnable = bEnable or false
	KeepSeconds = KeepSeconds or 0
	Callback = Callback or function()
	end

	if (not bEnable) then
		Callback()
		return
	end

	local BlackHandle = UIManager(GWorld.GameInstance):ShowCommonBlackScreen({})
	GWorld.GameInstance:AddTimer(KeepSeconds, function()
		UIManager(GWorld.GameInstance):HideCommonBlackScreen(BlackHandle)
		Callback()
	end, false, 0, nil, true)
end

function CommonTalkTask:CreateActors(ActorInfos, DefaultCreateLocation, Callback)
	ActorInfos = ActorInfos or {}
	Callback = Callback or function()
	end

	local BlackHandle = UIManager(GWorld.GameInstance):ShowCommonBlackScreen({})

	local bDoOnce = false
	local OnCreateActorsFinished = function()
		if (bDoOnce) then
			return
		end
		bDoOnce = true

		for _, ActorInfo in ipairs(ActorInfos) do
			if (ActorInfo.TalkActorType == "Player" or ActorInfo.TalkActorType == "Npc") then
				local ActorData = self.TalkContext:GetTalkActorData(self, ActorInfo.TalkActorId)
				if (not ActorData or not IsValid(ActorData.TalkActor)) then
					local Title = "对话创建检查Actor失败"
					local Message = string.format("ActorId: %s, ActorType: %s", ActorInfo.TalkActorId, ActorInfo.TalkActorType)
					UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE4.EStoryLogType.Talk, Title, Message)
				end
			end
		end

		UIManager(GWorld.GameInstance):HideCommonBlackScreen(BlackHandle)
		Callback()
	end

	-- 正常创建完成回调
	self.TalkContext:CreateTalkActors(self, ActorInfos, DefaultCreateLocation, OnCreateActorsFinished)

	-- 防止卡死，5秒后强制完成
	local ForceCompleteSeconds = 8
	GWorld.GameInstance:AddTimer(ForceCompleteSeconds, OnCreateActorsFinished)
end

function CommonTalkTask:StopNpcDefaultAction(bEnable, ActorInfos)
	bEnable = bEnable or false

	if (not bEnable) then
		return
	end

	self.TalkContext:NPCStopDefaultAction(self, ActorInfos)
end

function CommonTalkTask:PlayNpcDefaultAction(bEnable, ActorInfos)
	bEnable = bEnable or false

	if (not bEnable) then
		return
	end

	self.TalkContext:NPCPlayDefaultAction(self, ActorInfos)
end

function CommonTalkTask:CacheNpcTransform(Npc)
	if (not IsValid(Npc)) then
		return
	end

	self.CachedNpcTransforms = self.CachedNpcTransforms or {}
	self.CachedNpcTransforms[Npc] = Npc:GetTransform()
end

function CommonTalkTask:ResetNpcTransform(Npc)
	if (not IsValid(Npc)) then
		return
	end

	self.CachedNpcTransforms = self.CachedNpcTransforms or {}
	local Transform = self.CachedNpcTransforms[Npc]
	if (not Transform) then
		return
	end

	Npc:K2_SetActorTransform(self.CachedNpcTransforms[Npc], false, nil, true)
end

function CommonTalkTask:BlendIn(CameraType, Callback)
	Callback = Callback or function()
	end

	local PlayerController = UE4.UGameplayStatics.GetPlayerController(self.TalkContext, 0)
	if IsValid(PlayerController) then
		PlayerController:SetViewTargetWithBlend(self.Player)
	end

	if self.DialogueFlowGraphComponent:IsUseEmptyCamera() then
		Callback()
		return
	end

	local BlendInFunc = self.DefaultCameraBlendIn
	if (CameraType == "FreeCamera") then
		BlendInFunc = self.FreeCameraBlendIn
	elseif (CameraType == "FixedCamera") then
		BlendInFunc = self.FixedCameraBlendIn
	elseif (CameraType == "SequenceCamera") then
		BlendInFunc = self.SequenceCameraBlendIn
	end

	local BlendSeconds = 0
	if (self.TalkTaskData.BlendInType == "BlendIn") then
		BlendSeconds = self.TalkTaskData.BlendInTime
	end

	BlendInFunc(self, BlendSeconds, {
		Func = Callback
	})
end

function CommonTalkTask:DefaultCameraBlendIn(BlendSeconds, Callback)
	self.TalkContext:TryFireCallback(Callback)
end

function CommonTalkTask:FreeCameraBlendIn(BlendSeconds, Callback)
	local TargetCamera = self.TalkCameraManager:GetTalkPawnNew(self.TalkTaskData.bUseProceduralCamera, self.TalkTaskData.ProceduralCameraId)
	self.TalkCameraManager:SetTalkPawnEnableChangeView(true)
	local WaitQueue = self.WaitQueueManager:CreateWaitQueue(self, {
		{ Tag = WaitQueueTag.CameraBlend },
		{ Tag = WaitQueueTag.NpcRotateToPlayer },
		{ Tag = WaitQueueTag.PlayerRotateToNpc },
	}, Callback.Obj, Callback.Func)

	--Fadein转身的时候，在完全黑屏时直接瞬切转身，不走完整转身流程，节约黑屏等待时间
	self.TalkActionManager:FreeTalkNpcRotateToPlayer(self, self.TalkContext.InteractiveActor, {
		Func = function()
			WaitQueue:CompleteWaitItem(WaitQueueTag.NpcRotateToPlayer)
		end
	}, self.TalkTaskData.BlendInType == "FadeIn")

	self.TalkActionManager:FreeTalkPlayerRotateToNpc(self, self.TalkContext.InteractiveActor, {
		Func = function()
			WaitQueue:CompleteWaitItem(WaitQueueTag.PlayerRotateToNpc)
		end
	}, self.TalkTaskData.BlendInType == "FadeIn")

	self.TalkCameraManager:CameraBlendToNew(self.TalkTaskData.Key or self, TargetCamera, BlendSeconds, "TalkPawn", {
		Func = function()
			WaitQueue:CompleteWaitItem(WaitQueueTag.CameraBlend)
		end
	}, nil, self.TalkTaskData.CameraBlendEaseExp)
end

function CommonTalkTask:FixedCameraBlendIn(BlendSeconds, Callback)
	local FirstDialogueData = SimpleDialogueData_C.New(self, self.TalkTaskData.FirstDialogueId, self.TalkContext)
	local TargetCamera = self.TalkCameraManager:GetFixedCamera(FirstDialogueData.CameraInfo, self.TalkTaskData.TalkStage, true)
	self.TalkCameraManager:CameraBlendToNew(self.TalkTaskData.Key or self, TargetCamera, BlendSeconds, nil, Callback, nil, self.TalkTaskData.CameraBlendEaseExp)
end

function CommonTalkTask:SequenceCameraBlendIn(BlendSeconds, Callback)
	if UTalkSequenceFunctionLibrary.HasSequenceTrack(self.TalkTaskData.Sequence, UMoveSequencerTrack) then
		-- 只有无缝移动需要，并且无缝镜头不需要
		-- Sequence过程中，主角镜头可能发生各种改变，如果换了Pawn，Sequence过程中不会同步到Player身上
		-- 然后Sequence一结束，直接瞬切gg
		self.TalkCameraManager:GetTalkPawn()
		local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
		self.TalkCameraManager:SwitchCameraRole("TalkPawn")
		self.TalkCameraManager:SetTalkPawnEnableChangeView(false)
		self.TalkCameraManager:MakeSequenceCamera()
		USequenceFunctionLibrary.SetViewTarget(PlayerController, self.TalkCameraManager.SequenceCamera)
	end

	if Callback and Callback.Func then
		Callback.Func(Callback.Obj)
	end
end

function CommonTalkTask:BlendOut(CameraType, Callback)
	Callback = Callback or function()
	end

	local BlendOutFunc = self.DefaultCameraBlendOut
	if (CameraType == "FreeCamera") then
		BlendOutFunc = self.FreeCameraBlendOut
	elseif (CameraType == "FixedCamera") then
	elseif (CameraType == "SequenceCamera") then
		BlendOutFunc = self.SequenceCameraBlendOut
	end

	local BlendSeconds = 0
	if (self.TalkTaskData.BlendOutType == "BlendOut") then
		BlendSeconds = self.TalkTaskData.BlendOutTime
	end

	BlendOutFunc(self, BlendSeconds, {
		Func = Callback
	})
end

function CommonTalkTask:DefaultCameraBlendOut(BlendSeconds, Callback)
	self.TalkCameraManager:CameraBlendToNew(self.TalkTaskData.Key or self, self.Player, BlendSeconds, "Player", Callback, nil, self.TalkTaskData.CameraBlendEaseExp)
end

function CommonTalkTask:FreeCameraBlendOut(BlendSeconds, Callback)
	self.TalkActionManager:FreeTalkNpcRotateRecover(self.TalkContext.InteractiveActor, self, self.TalkTaskData)
	self.TalkCameraManager:FreeSimpleCameraBlendOutTo(Callback, self.TalkTaskData, self.Player, BlendSeconds)
end

function CommonTalkTask:SequenceCameraBlendOut(BlendSeconds, Callback)
	self.TalkCameraManager:SwitchCameraRole("Player")
	self.TalkCameraManager:ClearSequenceCamera()
	if Callback and Callback.Func then
		Callback.Func(Callback.Obj)
	end
end

function CommonTalkTask:TravelPlayer(TargetPoint, OnFinished)
	if (not IsValid(TargetPoint)) then
		if (OnFinished) then
			OnFinished()
		end
		return
	end

	local WorldCompositionSubSystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self.TalkContext, UWorldCompositionSubSystem)
	if (not IsValid(WorldCompositionSubSystem)) then
		if (OnFinished) then
			OnFinished()
		end
		return
	end

	local BlackHandle = UIManager(self.TalkContext):ShowCommonBlackScreen({})
	WorldCompositionSubSystem:RequestAsyncTravel_Fast(self.Player, TargetPoint:GetTransform(), { self.TalkContext, function()
		UIManager(self.TalkContext):HideCommonBlackScreen(BlackHandle)

		if (OnFinished) then
			OnFinished()
		end
	end }, true, false)

	EventManager:FireEvent(EventID.SetPlayerLocWithLoadLevel)
end

function CommonTalkTask:SetViewTargetToStage(OnFinished)
	local Stage = self.TalkTaskData.TalkStage
	if (not IsValid(Stage)) then
		if (OnFinished) then
			OnFinished()
		end
		return
	end

	self.StageViewTarget = GWorld.GameInstance:GetWorld():SpawnActor(ACameraActor, Stage:GetTransform())
	self:TravelViewTarget(self.StageViewTarget, self.TalkTaskData.bTravelFullLoadWorldComposition, OnFinished)
end

function CommonTalkTask:WaitNavLoadFinish(OnFinish)
	DebugPrint("CommonTalkTask:WaitNavLoadFinish")
	if (not self.TalkTaskData.bForceWaitNavLoaded) then
		if (OnFinish) then
			DebugPrint("CommonTalkTask:WaitNavLoadFinish OnFinish")
			OnFinish()
		end
		return
	end

	if self.TalkTaskData.bFreezeWorldComposition then
		local Title = "强制等待加载导航失败"
		local Message = string.format("当前对话勾选了冻结WC加载，可能会导致导航也被冻结，请选一个勾掉")
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE4.EStoryLogType.Talk, Title, Message)
		if (OnFinish) then
			OnFinish()
		end
		return
	end

    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
	if (not IsValid(GameMode)) then
		if (OnFinish) then
			DebugPrint("CommonTalkTask:WaitNavLoadFinish OnFinish")
			OnFinish()
		end
		return
	end

    local LevelLoader = GameMode:GetLevelLoader()

	if (not IsValid(LevelLoader)) then
		if (OnFinish) then
			DebugPrint("CommonTalkTask:WaitNavLoadFinish OnFinish")
			OnFinish()
		end
		return
	end

	local BlackHandle = UIManager(self.TalkContext):ShowCommonBlackScreen({})
	LevelLoader:CollectUnAttachNavigationLevel({self.TalkContext, function()
		DebugPrint("CommonTalkTask:WaitNavLoadFinish Real OnFinish")
		UIManager(self.TalkContext):HideCommonBlackScreen(BlackHandle)
		if (OnFinish) then
			OnFinish()
		end
	end})	
end

function CommonTalkTask:SetViewTargetToPlayer(OnFinished)
	local Stage = self.TalkTaskData.TalkStage
	if (not IsValid(Stage)) then
		if (OnFinished) then
			OnFinished()
		end
		return
	end

	self:TravelViewTarget(self.Player, self.TalkTaskData.bTravelFullLoadWorldComposition, OnFinished)
end

function CommonTalkTask:TravelViewTarget(ViewTarget, bIsFullLoad, OnFinished)
	if (not IsValid(ViewTarget)) then
		if (OnFinished) then
			OnFinished()
		end
		return
	end

	local WorldCompositionSubSystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self.TalkContext, UWorldCompositionSubSystem)
	if (not IsValid(WorldCompositionSubSystem)) then
		if (OnFinished) then
			OnFinished()
		end
		return
	end

	local BlackHandle = UIManager(self.TalkContext):ShowCommonBlackScreen({})
	WorldCompositionSubSystem:SetViewTargetWithWC(ViewTarget, { self.TalkContext, function()
		UIManager(self.TalkContext):HideCommonBlackScreen(BlackHandle)

		if (OnFinished) then
			OnFinished()
		end
	end }, bIsFullLoad, false)
end

function CommonTalkTask:StartDialogueIteration()
	self.IgnoreActionMontageBlendInTime = true
	self.DialogueIterationComponent:Start()
	self.IgnoreActionMontageBlendInTime = false
end

function CommonTalkTask:SkipOption(DialogueId)
	local DialogueData = DataMgr.Dialogue[DialogueId]

	if (not DialogueData) then
		DebugPrint("lhr@Dialogue Iteration Error: 选项的DialogueData为空", DialogueId)
		return
	end

	DebugPrint("CommonTalkTask@Skipping Option", DialogueId)

	self:RunDSL(DialogueData)
	self:SkipDSL()
end

function CommonTalkTask:SkipDialogue()
	local NodeType = self.DialogueIterationComponent:GetCurrentNodeType()
	if (NodeType ~= EDialogueNodeType.Dialogue) then
		DebugPrint("lhr@Dialogue Iteration Error: NodeType 2", NodeType, "不合法")
		return
	end

	local Dialogue = self.DialogueIterationComponent:GetDialogue()
	if (not Dialogue) then
		DebugPrint("lhr@Dialogue Iteration Error: Dialogue为空")
		return
	end

	if self.WaitQueue then
		self.WaitQueue:CloseWaitQueue()
	end
	self.DialogueIterationComponent:ForceToDialogueEnd(true)
	DebugPrint("CommonTalkTask@Skipping Dialogue", self.DialogueIterationComponent:GetDialogue())
	self:SkipDSL()
end

function CommonTalkTask:PlayDialogue(bPauseResume, bSkipping)
	if bPauseResume then
		--- Flow中可能会走到这里，原本的逻辑不会走到这，所以先Return了
		return
	end
	local NodeType = self.DialogueIterationComponent:GetCurrentNodeType()
	if (NodeType ~= EDialogueNodeType.Dialogue) then
		DebugPrint("lhr@Dialogue Iteration Error: NodeType", NodeType, "不合法")
		return
	end
	local Dialogue = self.DialogueIterationComponent:GetDialogue()
	if (not Dialogue) then
		DebugPrint("lhr@Dialogue Iteration Error: Dialogue为空")
		return
	end
	UIManager(GWorld.GameInstance):UnLoadUINew("ReasoningCollect")
	if Dialogue.DetectiveQuestionId then
		UIManager(GWorld.GameInstance):LoadUINew("ReasoningCollect", Dialogue.DetectiveQuestionId)
	end
	local CurrentDialogueId = Dialogue.DialogueId
	DebugPrint("CommonTalkTask:PlayDialogue:", CurrentDialogueId)
	local DialogueData = SimpleDialogueData_C.New(self, CurrentDialogueId, self.TalkContext)

	-- 无论是否跳过，都要记录对话完成状态
	self:RecordDialogueCompleted(DialogueData.DialogueId)
	self.DialogueWikiComponent:CompletePlayDialogue(Dialogue.RelatedWikiId)

	if bSkipping then
		self:RunDSL(DialogueData)
		self.UI:PlayDialogue(self, DialogueData, self.TalkTaskData, true)
		return
	end
	self:SetDialogueTypingFinished(false)
	self:SetPlayDialogueTaskFinished(false)

	if (not DialogueData.Content) then
		self:IterateDialogue()
		return
	end
	if DialogueData.ShowStoryContent then
		self:TryShowStoryPanelUI(DialogueData, function()
			self:IterateDialogue()
		end)
		return
	end
	self:OnPlayingDialogue(Dialogue)
	if (DialogueData.bIsBlack) then
		self:TryShowDialogueBlackUI()
	else
		self:TryHideDialogueBlackUI()
	end
	self.bAutoToNext = DialogueData.bAutoToNext --- Flow里面的配置，当前完成后马上进入下一句，不需要点击

    local PanelType = DialogueData.DialoguePanelType
    self.bForceAutoPlay = PanelType == "None" or PanelType == "AllHide"

	self.TalkTaskState = TalkTaskState.PlayingDialogue
	if self.WaitQueue then
		self.WaitQueue:CloseWaitQueue()
	end
	---@type TalkWaitQueue_C
	self.WaitQueue = self.WaitQueueManager:CreateWaitQueue(self, {
		{ Tag = WaitItemUniqueTag.UIPlayDialogue },
		{ Tag = WaitItemUniqueTag.PlayAudio },
		{ Tag = WaitItemUniqueTag.PlayScript, Condition = function()
    			return DialogueData.Scripts
    		end 
        },
		{
			Tag = WaitItemUniqueTag.WaitFlowEnd, Condition = function()
    			return DialogueData.bWaitFlowEnd
    		end
		},
        {
            Tag = WaitItemUniqueTag.AutoPlayDelay, Condition = function()
                return self:IsAutoPlay() and not DialogueData.DisableDuration
            end
        }
	}, self, self.OnTaskPlayDialogueFinished)

	local WaitQueuePointer = self.WaitQueue

	--对话开始点击保护时间(默认2秒)
	self:SetCanResponseUIClick(false)
	self.ForbiddenClickSkip = nil
	if not DialogueData.ForbiddenClick then
		self.EnableClickTimer = self.TalkTimerManager:AddTimer(self, DialogueData.AllowClickTime, nil, nil, nil, function()
			DebugPrint("EnableClickDelayTime")
			self:SetCanResponseUIClick(true)
            self.EnableClickTimer = nil
		end)
	else
		self.ForbiddenClickSkip = true
	end

	self:PlayAudio(DialogueData, function()
		WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayAudio)
	end)


    if self:IsAutoPlay() then
        self.TalkContext.TalkTimerManager:AddTimer(self, DialogueData.Duration, nil, nil, self, function()
            WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.AutoPlayDelay)
        end)
    end

	self.UI:PlayDialogue(self, DialogueData, self.TalkTaskData)
	self:RunDSL(DialogueData,
    	function()
    		WaitQueuePointer:CompleteWaitItem(WaitItemUniqueTag.PlayScript)
    	end)
end

function CommonTalkTask:ForceCompleteDialogue()
	-- if self.WaitQueue:IsTagOnlyUncompleted(WaitItemUniqueTag.WaitSectionEnd) then
	--     self.WaitQueue:CompleteWaitItem(WaitItemUniqueTag)
	-- end
	--- 先这样写，看看会不会有额外问题
	self.UI:SetTextBorderHidden(true)
	self:SetCanResponseUIClick(false)
	self.TalkAudioComp:Clear()
	self:TryHideDialogueBlackUI()
end

function CommonTalkTask:InitData(TalkTaskData, TaskFinishedCallback)
	self.ExecutedComps = {}
	self.NodeFinished_Callback = TaskFinishedCallback
	self.TalkTaskData = TalkTaskData
	self.TalkContext = TalkTaskData.TalkContext
	self.TalkTimerManager = self.TalkContext.TalkTimerManager
	self.TalkCameraManager = self.TalkContext.TalkCameraManager
	self.WaitQueueManager = self.TalkContext.WaitQueueManager
	self.TalkActionManager = self.TalkContext.TalkActionManager
	self.bForceAutoPlay = false
	self.bResponseUIClick = false
	self.bTaskPlayDialogueFinished = false
	self.ScreenEffectDurationSeconds = self.TalkTaskData.ScreenEffectDurationSeconds
	self.FinishFadeInTime = self.TalkTaskData.FinishFadeInTime
	self.BeginFadeOutTime = self.TalkTaskData.BeginFadeOutTime
	self.Player = TalkTaskData.Player
	self.TalkDelegateManager = self.TalkContext.TalkDelegateManager
	self.IgnoreActionMontageBlendInTime = false -- Task 开始播放台本时、点击强制播放下一句时、跳过台本时，忽略动作的 BlendInTime
end

function CommonTalkTask:InitUI()
	self:SetUIName(self.TalkTaskData.UIName)
	self.UI = UIManager(GWorld.GameInstance):LoadUINew(self.TalkTaskData.UIName)
	self.UI:SetUpTalkTask(self)

	self.TalkTaskData.UI = self.UI
	self:TryCreateTalkCommonBlackUI()
end

function CommonTalkTask:HideUI(bHidden, HideTag)
	if IsValid(self.UI) then
		if bHidden then
			self.UI:Hide(HideTag)
		else
			self.UI:Show(HideTag)
		end
	end
end

function CommonTalkTask:TryCreateDialogueBlackUI()
	self.DialogueBlackUI = self.DialogueBlackUI or self.TalkContext:GetDialogueBlackUI() --Todo
end

function CommonTalkTask:TryCreateTalkCommonBlackUI()
	self.BlackUI = self.BlackUI or self.TalkContext:GetSimpleBlackUI()
end

function CommonTalkTask:TryHideDialogueBlackUI()
	-- 原本分散的调用，合到同一个函数里面
	if self.DialogueBlackUI then
		self.DialogueBlackUI:SetToTransparent()
	end
end

function CommonTalkTask:TryShowDialogueBlackUI()
	self:TryCreateDialogueBlackUI()
	if self.DialogueBlackUI then
		self.DialogueBlackUI:SetToBlack()
	end
end

function CommonTalkTask:CreateDialogueWikiComponent()
	self.DialogueWikiComponent = FDialogueWikiComponent:New(self)
end

function CommonTalkTask:CreateCharacterDitherComponent()
	if self.TalkTaskData.CameraType == "FreeCamera" then
		self.EnableCharacterDitherComponent = FEnableCharacterDitherComponent:New(self.TalkContext)
	elseif self.TalkTaskData.CameraType == "FixedCamera" or self.TalkTaskData.CameraType == "SequenceCamera" then
		self.DisableCharacterDitherComponent = FDisableCharacterDitherComponent:New(self.TalkContext)
	end
end

function CommonTalkTask:CreateDisablePlayerInputComponent()
	if self.TalkTaskData.bDisableGameInput then
		self.DisablePlayerInputComponent = FDisablePlayerInputComponent:New(self.TalkTaskData.Player, self.TalkTaskData)
	end
end

function CommonTalkTask:CreateDisableNpcMovementComponent()
	if self.TalkTaskData.FlowAsset and self.TalkTaskData.FlowAsset:IsFirstDialogueNodeSequence() then
		self.DisableNpcMovementComponent = FDisableNpcMovementComponent:New(self, self.TalkContext)
	end
end

function CommonTalkTask:CreateSetForceLodComponent()
	self.SetForceLodComponent = FSetForceLodComponent:New(self, self.TalkContext)
end

function CommonTalkTask:CreateDisableCameraArmComponent()
	if self.TalkTaskData.CameraType == "SequenceCamera" then
		self.DisableCameraArmComponent = FDisableCameraArmComponent:New(self.TalkTaskData.Player)
	end
end

function CommonTalkTask:CreateSwitchEmoIdleComponent()
	if self.TalkTaskData.PlayerSwitchEmoIdle then
		self.SwitchEmoIdleComponent = FSwitchEmoIdleComponent:New(self.TalkTaskData.Player)
	end
end

function CommonTalkTask:CreateStopPlayerActionComponent()
	DebugPrint("TTT:CreateStopPlayerActionComponent", self.TalkTaskData.bDisableGameInput, self.TalkTaskData.bPlayerMove)
	if (self.TalkTaskData.bDisableGameInput) and (self.TalkTaskData.bPlayerMove) then
		self.StopPlayerActionComponent = FStopPlayerActionComponent:New(self.TalkTaskData.Player)
	end
end

function CommonTalkTask:CreateHideAllBattleEntityComponent()
	if self.TalkTaskData.bHideAllBattleEntity then
		self.HideAllBattleEntityComponent = FHideAllBattleEntityComponent:New(self.TalkContext)
	end
end

function CommonTalkTask:CreateDisableNpcPerformanceOptimizationComponent()
	if self.TalkTaskData.bDisableNpcOptimization then
		self.DisableNpcPerformanceOptimizationComponent = FDisableNpcPerformanceOptimizationComponent:New()
	end
end

function CommonTalkTask:CreateHideGameUIComponent()
	if self.TalkTaskData.bDisableGameInput then
		self.HideGameUIComponent = FHideGameUIComponent:New()
	end
end

function CommonTalkTask:CreateSoundEffectComponent()
	if self.TalkTaskData.bDisableGameInput then
		self.SoundEffectComponent = FSoundEffectComponent:New()
	end
end

function CommonTalkTask:CreateFreezeWCComponent()
	if self.TalkTaskData.bFreezeWorldComposition then
		self.FreezeWorldCompositionComponent = FFreezeWorldCompositionComponent:New()
	end
end

function CommonTalkTask:CreateSwitchToMasterComponent()
	if self.TalkTaskData.SwitchToMasterType then
		self.SwitchToMasterComponent = FSwitchToMasterComponent:New(self.TalkTaskData.SwitchToMasterType, self.TalkTaskData)
	end
end

function CommonTalkTask:CreateSetPlayerInvincibleComponent()
	if self.TalkTaskData.SetPlayerInvincible then
		self.SetPlayerInvincibleComponent = FSetPlayerInvincibleComponent:New()
	end
end

function CommonTalkTask:CreateDisableInteractiveComponent()
	if self.TalkTaskData.bDisableGameInput then
		self.DisableInteractiveComponent = FDisableInteractiveComponent:New(self.TalkTaskData.Player)
	end
end

function CommonTalkTask:CreatePauseGameComponent()
	if self.TalkTaskData.bPauseGameGlobal and Utils.IsStandAlone(GWorld.GameInstance) then
		self.PauseGameComponent = FPauseGameComponent:New(self.TalkContext, self, self.TalkTaskData)
	end
end

function CommonTalkTask:CreateHideEffectComponent()
	if self.TalkTaskData.bHideEffectCreature then
		self.HideAllEffectComponent = FHideAllEffectComponent:New()
	end
end

function CommonTalkTask:CreateHideMechanismsFXComponent()
	if (self.TalkTaskData.bHideMechanismsFX) then
		self.HideMechanismsFXComponent = FHideMechanismsFXComponent:New()
	end
end

function CommonTalkTask:CreatePauseTimeElapseComponent()
	if self.TalkTaskData.bPauseTimeElapse then
		self.PauseTimeElapseComponent = FPauseTimeElapseComponent:New()
	end
end

function CommonTalkTask:FinishDialogue()
	self:SetCanResponseUIClick(false)
	UIManager(GWorld.GameInstance):UnLoadUINew("ReasoningCollect")
	local OptionData = self.TalkTaskData.OptionData
	if (OptionData:IsShow() and #OptionData.Options > 0) then
		self:ShowTalkOptions(OptionData)
	else
		self:Finish(ETalkNodeFinishType.Out)
	end
end

function CommonTalkTask:BindDelegate()
	if self.UI then
		self.UI:AddDelegate_DialoguePanelClicked(self, self.OnUIDialoguePanelClicked)
		self.UI:AddDelegate_WholeDialogueTypingFinished(self, self.OnUIWholeDialogueTypingFinished)
		self.UI:AddDelegate_AutoPlayChanged(self, self.OnAutoPlayChanged)
		self.UI:AddDelegate_SkipButtonClicked(self, self.OnSkipButtonClicked)
		self.UI:AddDelegate_StopStoryline(self, self.StopStoryline)
	end
end

function CommonTalkTask:UnbindDelegate()
	if self.UI then
		self.UI:RemoveDelegate_DialoguePanelClicked(self, self.OnUIDialoguePanelClicked)
		self.UI:RemoveDelegate_WholeDialogueTypingFinished(self, self.OnUIWholeDialogueTypingFinished)
		self.UI:RemoveDelegate_AutoPlayChanged(self, self.OnAutoPlayChanged)
		self.UI:RemoveDelegate_SkipButtonClicked(self, self.OnSkipButtonClicked)
		self.UI:RemoveDelegate_StopStoryline(self, self.StopStoryline)
	end
end

---@param OptionData TalkOptionData_C
function CommonTalkTask:ShowTalkOptions(OptionData)
	self:SetCanResponseUIClick(false)
	self:TryHideDialogueBlackUI()
	self.TalkTaskState = TalkTaskState.ShowingOption

	local CopiedOptionTexts = {}
	for i, Option in ipairs(OptionData.Options) do
		table.insert(CopiedOptionTexts, { Index = Option.Index, Text = Option.OptionText, bIsSelected = Option.bIsSelected, 
			bCanReselect = Option.bCanReselect, OptionStyle = Option.OptionStyle})
	end

	local FinalOptionTexts = {}
	if (OptionData.OptionType == "random" and OptionData.RandomOptionNum > 0) then
		local FinialOptionNum = math.min(#CopiedOptionTexts, self.TalkTaskData.RandomOptionNum)
		for i = 1, FinialOptionNum do
			local RandomIndex = math.random(1, #CopiedOptionTexts)
			local RandOption = CopiedOptionTexts[RandomIndex]
			table.insert(FinalOptionTexts, {
				Index = RandOption.Index,
				Text = RandOption.Text,
			})
			table.remove(CopiedOptionTexts, RandomIndex)
		end
	else
		FinalOptionTexts = CopiedOptionTexts
	end
	OptionData.bTalkOptions = true

	self.UI:ShowOptions(self, FinalOptionTexts, OptionData,
	---@param Item USimpleDialogueButtonItem
		function(ItemIdx, SpecifyFinishType)
			self.UI:ClearOptions()

			local Option = OptionData.Options[ItemIdx]
			if (Option.OverrideBlend) then
				self.TalkTaskData.BlendOutType = Option.OverrideOutype
				self.TalkTaskData.BlendOutTime = Option.OverrideOutTime
			end
			if (Option.bSaveToServer) then
				local Avatar = GWorld:GetAvatar()
				if Avatar then
					Avatar:SelectStoryOption(Option.OptionId)
				end
			end

			local OptionDialogueData = DataMgr.Dialogue[Option.OptionId]
			self:RunDSL(OptionDialogueData, function()
				self:SetCanResponseUIClick(true)
				if SpecifyFinishType then
					self:Finish(SpecifyFinishType)
				else
					local Options = {}
					for i, Option in ipairs(OptionData.Options) do
						table.insert(Options, Option.OptionId)
					end
					local OptionType = OptionData.OptionType
					local bImpression = false
					if OptionType == ETalkOptionType.Check then
						OptionType = "Check"
						bImpression = true
					elseif OptionType == ETalkOptionType.Plus then
						OptionType = "Plus"
						bImpression = true
					end
					self.DialogueRecordComponent:OnOptionRecord(Options[ItemIdx], {
						bImpression = bImpression,
						OptionType = OptionType,
						Options = Options,
						VisitedOptions = {},
						SelectedOption = Options[ItemIdx],
					})
					self:Finish(ETalkNodeFinishType.Option, ItemIdx)
				end
			end)
		end)
end

---@param OptionIds table<integer, integer>
function CommonTalkTask:ShowDialogueOptions(OptionIds)
	DebugPrint("CommonTalkTask:ShowDialogueOptions", self, OptionIds)
	self:SetDialogueTypingFinished(false)
	self:SetPlayDialogueTaskFinished(false)
	self:SetCanResponseUIClick(false)
	self:TryHideDialogueBlackUI()
	self.TalkTaskState = TalkTaskState.ShowingOption
	--判断是否为印象选项
	local DialougeType = "null"
	for i, OptionId in ipairs(OptionIds) do
		local DialogueData = DataMgr.Dialogue[OptionId]
		local Type = "dialogue"
		if DialogueData.ImprCheckId then
			Type = "check"
		end
		if DialogueData.ImprPlusId then
			Type = "plus"
		end
		if DialougeType ~= "null" then
			if Type ~= DialougeType then
				local Message = "Dialogue各选项之间类型不同\nDialogueId: " .. OptionId
				local Title = "印象系统错误：选项类型不同"
				UStoryLogUtils.PrintToFeiShu(self, UE4.EStoryLogType.Impression, Title, Message)
				DebugPrint("lhr@Dialogue各选项之间类型不同\nDialogueId:", OptionId)
				return
			end
		end
		DialougeType = Type
	end
	local NewOptionData = TalkOptionData_C.New(DialougeType, nil, OptionIds, self.DialogueIterationComponent)
	local OptionTexts = {}
	for i, OptionData in ipairs(NewOptionData.Options) do
		table.insert(OptionTexts, { Index = i, Text = OptionData.OptionText, bIsSelected = OptionData.bIsSelected, 
		bCanReselect = OptionData.bCanReselect, OptionStyle = OptionData.OptionStyle})
	end
	self.UI:ShowOptions(self, OptionTexts, NewOptionData,
	---@param Item USimpleDialogueButtonItem
			function(ItemIdx, SpecifyFinishType)
				self.UI:ClearOptions()

				local OptionId = OptionIds[ItemIdx]
				local OptionData = NewOptionData.Options[ItemIdx]
				if (OptionData.bSaveToServer) then
					local Avatar = GWorld:GetAvatar()
					if Avatar then
						Avatar:SelectStoryOption(OptionId)
					end
				end
				local OptionDialogueData = DataMgr.Dialogue[OptionId]
				if SpecifyFinishType == ETalkNodeFinishType.Fail then
					self:SetOutport(SpecifyFinishType)
				end
				self:RunDSL(OptionDialogueData,
					function()
						self:SetCanResponseUIClick(true)
						self:StopDSL()
						self:IterateDialogue(OptionId, SpecifyFinishType)
						-- self:PlayDialogue(true)
					end)
			end)
end

function CommonTalkTask:SetOutport(OutportName, OptionIndex)
	self.OverriddenFinishType = OutportName
	self.OverriddenFinishIndex = OptionIndex
end

------------------------------手动/自动播放逻辑------------------------
function CommonTalkTask:OnTaskPlayDialogueFinished()
	DebugPrint("CommonTalkTask:OnTaskPlayDialogueFinished", self.bForceAutoPlay, self.TalkTaskState)
	self:SetPlayDialogueTaskFinished(true)
	self.UI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	if self.ForbiddenClickSkip then
		self:SetCanResponseUIClick(true)
	end
    if self.bAutoToNext or self:IsAutoPlay() then
        self.bAutoToNext = nil
        self.bForceAutoPlay = false
        if not self.IsPanelBeingClicked then
            self:IterateDialogue()
        end
    end
end

function CommonTalkTask:IterateDialogue(...)
    if self.EnableClickTimer then
        self.TalkTimerManager:DestroyTimer(self, self.EnableClickTimer)
        self.EnableClickTimer = nil
    end
    CommonTalkTask.Super.IterateDialogue(self, ...)
end

---@param FinishOrPageEnd boolean 打字机是全部完成还是单页完成
function CommonTalkTask:OnUIWholeDialogueTypingFinished(FinishOrPageEnd)
	DebugPrint("OnUIWholeDialogueTypingFinished", FinishOrPageEnd)
	if (FinishOrPageEnd) then
		self:SetDialogueTypingFinished(true)
		if self.WaitQueue then
			self.WaitQueue:CompleteWaitItem(WaitItemUniqueTag.UIPlayDialogue)
		end
	end
end

function CommonTalkTask:OnUIDialoguePanelClicked()
	if not self:IsDialogueTypingFinished() then
		if not self.UI:SkipDialogueTyping() then
		    return
        end
	end
	if not self:CanResponseUIClick() then
		return
	end
	DebugPrint("CommonTalkTask:OnUIDialoguePanelClicked", self:IsPlayDialogueTaskFinished())
    self.IsPanelBeingClicked = true
	self:TrySkipDSL()
	self.DialogueIterationComponent:ForceToDialogueEnd()
    if self.WaitQueue then
        self.WaitQueue:CompleteWaitItem(WaitItemUniqueTag.AutoPlayDelay)
    end
    self.IsPanelBeingClicked = false
	if self.WaitQueue and self.WaitQueue:IsTagOnlyUncompleted(WaitItemUniqueTag.PlayAudio) then
		self.TalkAudioComp:Clear()
		AudioManager(self.TalkContext):PlayUISound(self.TalkContext, "event:/ui/common/click_dialog_next", "", nil)
		self:ForcePlayNextDialogue()
	elseif self:IsPlayDialogueTaskFinished() then
		AudioManager(self.TalkContext):PlayUISound(self.TalkContext, "event:/ui/common/click_dialog_next", "", nil)
		self:ForcePlayNextDialogue()
	end
end

function CommonTalkTask:OnAutoPlayChanged()
	if (self.TalkTaskState == TalkTaskState.OnFinish or self.TalkTaskState == TalkTaskState.ShowingOption) then
		return
	end
	if self:IsAutoPlay() then
		if self:IsPlayDialogueTaskFinished() then
			self:ForcePlayNextDialogue()
		end
	else
		if self.WaitQueue then
            self.WaitQueue:CompleteWaitItem(WaitItemUniqueTag.AutoPlayDelay)
        end
	end
end
------------------------------手动/自动播放逻辑------------------------

function CommonTalkTask:OnSkipButtonClicked()
	DebugPrint("OnSkipButtonClicked")
	if (self.TalkTaskState == TalkTaskState.OnFinish or self.TalkTaskState == TalkTaskState.ShowingOption) then
		return
	end

	self.IgnoreActionMontageBlendInTime = true
	if (self.TalkTaskData.bSkipToOption) then
		self.DialogueIterationComponent:SkipToEndOrOption()
	else
		self.DialogueIterationComponent:SkipToEnd()
	end
	self.IgnoreActionMontageBlendInTime = false

	self.TalkCameraManager:SkipCameraBreathe()

	local Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if IsValid(Player) and Player.TrackSkipTalkInfo then
		Player:TrackSkipTalkInfo(self.TalkTaskData)
	end
end

function CommonTalkTask:StopStoryline()
	self.TalkTaskData.BlendOutTime = 0.5
	self:Finish(ETalkNodeFinishType.Stop)
end

function CommonTalkTask:CreateComponents()
	CommonTalkTask.Super.CreateComponents(self)

	if not self.TaskData then
		return
	end

	self.TalkTaskData = self.TaskData
	self.TalkContext = self.TaskData.TalkContext

	self:CreateFreezeWCComponent()
	self:CreateTalkAudioComponent()
	self:CreatePauseGameComponent()
	self:CreateHideEffectComponent()
	self:CreateHideMechanismsFXComponent()
	self:CreateExpressionComponent()
	self:CreateHideGameUIComponent()
	self:CreateSoundEffectComponent()
	self:CreateDialogueWikiComponent()
	self:CreateSwitchToMasterComponent()
	self:CreateCharacterDitherComponent()
	self:CreateDialogueIteratorComponent()
	self:CreateStopPlayerActionComponent()
	self:CreateDisableNpcMovementComponent()
	self:CreateSetForceLodComponent()
	self:CreateDisablePlayerInputComponent()
	self:CreateDisableInteractiveComponent()
	self:CreateHideAllBattleEntityComponent()
	self:CreateSetPlayerInvincibleComponent()
	self:CreateDisableNpcPerformanceOptimizationComponent()
	self:CreateDisableCameraArmComponent()
	self:CreateSwitchEmoIdleComponent()
	self:CreatePauseTimeElapseComponent()
end

function CommonTalkTask:OnCinematicBegin()
	if self.TalkTaskData.SequenceActor then
		self.TalkTaskData.SequenceActor:InitializeLua(self, self.TalkTaskData)
	end
end

function CommonTalkTask:TryPlaySequence()
	if self.TalkTaskData.SequencePlayer then
		self.TalkContext:BindActors(self)
		self.TalkTaskData.SequencePlayer:Play()
		-- Seq set view target 与 camera set position 在 queue 中执行，时序无法保证，因此手动更新一次相机位置，防止 wc 根据相机位置加载错误
		local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
		UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(PlayerController)
	end
end

function CommonTalkTask:SequenceDrivePlayDialogue(DialogueId)
end

function CommonTalkTask:SequenceEndPlayDialogue(DialogueId)
end

function CommonTalkTask:IsAutoPlay()
	if self.UI then
		return self.UI:IsAutoPlay() or self.bForceAutoPlay
	else
		return self.bForceAutoPlay
	end
end

function CommonTalkTask:CanResponseUIClick()
	return self.bResponseUIClick
end

function CommonTalkTask:SetCanResponseUIClick(bResponseUIClick)
	DebugPrint("CommonTalkTask:SetCanResponseUIClick", bResponseUIClick)
	self.bResponseUIClick = bResponseUIClick
	self.UI:SwitchWaitState(self.bResponseUIClick)
end

function CommonTalkTask:SetDialogueTypingFinished(bSet)
	self.bDialogueTypingFinished = bSet
end

function CommonTalkTask:IsDialogueTypingFinished()
	return self.bDialogueTypingFinished
end

function CommonTalkTask:SetPlayDialogueTaskFinished(bFinished)
	self.bTaskPlayDialogueFinished = bFinished
end

function CommonTalkTask:IsPlayDialogueTaskFinished()
	return self.bTaskPlayDialogueFinished
end

function CommonTalkTask:ForcePlayNextDialogue()
	DebugPrint("CommonTalkTask:ForcePlayNextDialogue")
	self:StopDSL()
	self.WaitQueue:CloseWaitQueue()
	self.IgnoreActionMontageBlendInTime = true
	self:IterateDialogue()
	self.IgnoreActionMontageBlendInTime = false
	return true
end

function CommonTalkTask:OnInterrupted(TalkNodeFinishType)
	DebugPrint("CommonTalkTask:OnInterrupted")
	if self.TalkContext and self.TalkContext.TalkCameraManager then
		self.TalkContext.TalkCameraManager:OnExceptionInterrupted()
	end
	self:ResumeAllExecutedComps()
	self.TalkContext:RemoveSimpleBlackUI()
	self:End(TalkNodeFinishType)
end

function CommonTalkTask:OnExceptionInterruptedBySTL()
	DebugPrint("CommonTalkTask:OnExceptionInterruptedBySTL")
	TalkUtils:RemovePlayerInvincible()
	self.NodeFinished_Callback = nil
	if self.TalkContext and self.TalkContext.TalkCameraManager then
		self.TalkContext.TalkCameraManager:OnExceptionInterrupted()
	end
	if self.TalkTaskData.SequencePlayer then
		self.TalkTaskData.SequencePlayer:Stop()
	end
	self:ResumeAllExecutedComps()
	self:Clear()
end

function CommonTalkTask:ResumeAllExecutedComps()
	for Comp, _ in pairs(self.ExecutedComps or {}) do
		Comp:Resume()
	end
end

function CommonTalkTask:TryFireEndingCallback(TalkNodeFinishType, OptionIndex)
	if self.NodeFinished_Callback and self.NodeFinished_Callback[2] then
		local NodeFinished_Obj = self.NodeFinished_Callback[1]
		local NodeFinished_Func = self.NodeFinished_Callback[2]
		NodeFinished_Func(NodeFinished_Obj, self, TalkNodeFinishType, OptionIndex)
	end
end

function CommonTalkTask:CheckResource()
	return true
end

function CommonTalkTask:RecordDialogueCompleted(DialogueId)
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		return
	end

	if (DataMgr.DialogueId2WikiTextIds[DialogueId] == nil) then
		return
	end

	Avatar:CompletedDialogue(DialogueId)
end

function CommonTalkTask:OnPaused()
	DebugPrint("CommonTalkTask:OnPaused")
	self:PauseAudio()
	self:PauseCamera(true)
	self:PauseBlackUI(true)
	self:PauseAllTimers(true)
	AudioManager(self.TalkContext):PauseCineSound(true)
	self.DialogueIterationComponent:Pause()
end

function CommonTalkTask:OnPauseResumed()
	DebugPrint("CommonTalkTask:OnPauseResumed")
	self:ResumePauseAudio()
	self:PauseCamera(false)
	self:PauseBlackUI(false)
	self:PauseAllTimers(false)
	AudioManager(self.TalkContext):PauseCineSound(false)
	self.DialogueIterationComponent:Resume()
end

function CommonTalkTask:PauseBlackUI(bPaused)
	if IsValid(self.BlackUI) then
		self.BlackUI:Pause(bPaused)
	end
end

return CommonTalkTask
