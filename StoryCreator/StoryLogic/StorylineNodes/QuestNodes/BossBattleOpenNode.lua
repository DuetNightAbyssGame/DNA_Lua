local M = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')
local PauseTag = "BossFightOpen"

function M:Init()
	self.SequencePath = ""
	self.EnableFadeIn = true
	self.EnableFadeOut = true
	self.EnableSkip = true
	self.PauseGameGlobal = false
	self.DisableMonsterAI = false
	self.DisableNPCAI = false
	self.TalkContext = GWorld.GameInstance:GetTalkContext()
	self.Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	EventManager:AddEvent(EventID.OnHardBossOpeningAllPlayerReady, self, self.OnAllPlayerReadyCallback)
end

function M:Execute(Callback)
	self.Callback = Callback
	self:ShowUI()
	self:PlaySequence()
	self.Player:AddDisableInputTag(PauseTag)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode and GameMode.SetPlayerCharacterForceIdle then
		GameMode:SetPlayerCharacterForceIdle(self.Player)
	end
end

function M:Clear()
	self.Player:RemoveClearInputCache()
	self.Player:RemoveDisableInputTag(PauseTag)
	
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	if GameState then
		GameState:ClientHideHardBossDgActor(false, "Boss")
	end
end

function M:PlaySequence()
	local SequenceAsset = LoadObject(self.SequencePath)

	if not IsValid(SequenceAsset) then
		DebugPrint("Warning: BossBattleOpenNode Sequence路径有误，请检查！！！", self.SequencePath)
		self:OnSequencePlayFinished()
		return
	end

	local transform = UE4.UKismetMathLibrary.MakeTransform(UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0), UE4.FVector(1, 1, 1))
	self.LevelSequenceActor = GWorld.GameInstance:GetWorld():SpawnActor(UE4.LoadClass(Const.Talk_LevelSequenceActorPath), transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    --self.LevelSequenceActor.CameraSettings.bOverrideAspectRatioAxisConstraint = false
	self.SequencePlayer = self.LevelSequenceActor.SequencePlayer
	self.LevelSequenceActor:SetSequence(SequenceAsset)

	if self.PauseGameGlobal and Utils.IsStandAlone(GWorld.GameInstance) then
		self.TalkContext:OnPausedBegin()
		local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		GameMode:SetGamePaused(PauseTag, true)

		local TS = TalkSubsystem()
		TS:AddIgnorePauseObject(self.LevelSequenceActor)
	end

	-- Sequence结束后委托
	self.SequencePlayer.OnFinished:Add(SequenceAsset, function()
		self:OnSequencePlayFinished()
	end)

	-- self.SequencePlayer.OnPause:Add(SequenceAsset, function()
	-- 	self:OnSequencePause()
	-- end)

	-- 1.2新流程，客户端无需暂停sequence来等待其他玩家ready了，相关逻辑先干掉
	-- 如果是区域就暂停，否则就直接播
    -- if GameState and GameState:IsInRegion() then
	-- 	self.SequencePlayer:Play()
	-- else
    --     -- 判断有没有标记帧
	-- 	local MarkedFrameIndex = UE4.UMovieSceneSequenceExtensions.FindMarkedFrameByLabel(SequenceAsset, "EnterPause")
	-- 	if MarkedFrameIndex == -1 then
	-- 		-- 计算前一帧的时间
	-- 		local TotalFrames = UE4.UMovieSceneSequenceExtensions.GetPlaybackEnd(SequenceAsset) - 5
	-- 		local FrameRate = self.SequencePlayer:GetFrameRate()
	-- 		local Time = (TotalFrames * FrameRate.Denominator) / FrameRate.Numerator
	-- 		-- 播放到前一帧
	-- 		local PlaybackParams = FMovieSceneSequencePlaybackParams()
	-- 		PlaybackParams.Time = Time
	-- 		PlaybackParams.PositionType = EMovieScenePositionType.Time
	-- 		self.SequencePlayer:PlayTo(PlaybackParams)
	-- 	else
	-- 		-- 播放到标记帧
	-- 		local PlaybackParams = FMovieSceneSequencePlaybackParams()
	-- 		PlaybackParams.MarkedFrame = "EnterPause"
	-- 		PlaybackParams.PositionType = EMovieScenePositionType.MarkedFrame
	-- 		self.SequencePlayer:PlayTo(PlaybackParams)
	-- 	end
	-- 	self.LoadingUI.Group_Coop:SetVisibility(UIConst.VisibilityOp.Visible)
	-- 	self.LoadingUI.Com_Loading:SetVisibility(UIConst.VisibilityOp.Collapsed)
	-- 	self.LoadingUI.Text_CoopTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
	-- end

	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)

	if GameState and GameState:IsInDungeon() then
		self.LoadingUI.Group_Coop:SetVisibility(UIConst.VisibilityOp.Visible)
		self.LoadingUI.Com_Loading:SetVisibility(UIConst.VisibilityOp.Collapsed)
		self.LoadingUI.Text_CoopTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
	end
	UIManager(GWorld.GameInstance):ClearCachedViewTarget()
	self.SequencePlayer:Play()
	-- Seq set view target 与 camera set position 在 queue 中执行，时序无法保证，因此手动更新一次相机位置，防止 wc 根据相机位置加载错误
	local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
	UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(PlayerController)

	if GameState then
		GameState:ClientHideHardBossDgActor(true, "Boss")
	end
end

function M:ShowUI()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	UIManager:HideAllUI(true, Const.BossBattleOpenHideTag)
	self.LoadingUI = UIManager:LoadUINew("HardBossBattleOpen", self.EnableFadeIn, self.EnableSkip, self, self.SkipToEnd)
	self.LoadingUI.Text_CoopTitle:SetText(GText("UI_HardBoss_WaitOthers"))
	TeamController:OpenHeadUI(self.LoadingUI.Group_Team)
	TeamController:GetModel():SetIsInOpenCoop(true)
end

function M:SkipToEnd()
	self.SequencePlayer:GoToEndAndStop()
	self:OnSequencePlayFinished()
end

function M:UnShowUI()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local BossBattleOpenUI = UIManager:GetUIObj("HardBossBattleOpen")

	-- 卸载开战UI
	if self.EnableFadeOut then
		-- 显示淡出动效
		BossBattleOpenUI:BindToAnimationFinished(BossBattleOpenUI.Out, function()
			BossBattleOpenUI:Close()
		end)
		BossBattleOpenUI:PlayAnimation(BossBattleOpenUI.Out)
		BossBattleOpenUI:ShowHardBossTitle(false)
	else
		BossBattleOpenUI:Close()
	end

	-- 显示其他UI
	UIManager:HideAllUI(false, Const.BossBattleOpenHideTag)
	TeamController:GetModel():SetIsInOpenCoop(false)
end

function M:OnSequencePlayFinished()
	EventManager:RemoveEvent(EventID.OnHardBossOpeningAllPlayerReady, self)
	if self.PauseGameGlobal and Utils.IsStandAlone(GWorld.GameInstance) then
		self.TalkContext:OnPausedEnd()

		local TS = TalkSubsystem()
		TS:ClearIgnorePauseObjects()

		local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		GameMode:SetGamePaused(PauseTag, false)
	end
	self:UnShowUI()
	local Eid = self.Player.MechanismEid
	local Mechanism = Battle(self):GetEntity(Eid)
	if Mechanism then
		Mechanism.ChestInteractiveComponent:EndInteractive(self.Player)
	end
	self.LevelSequenceActor:K2_DestroyActor()
	self.Callback()
	self.SequencePlayer = nil
end

-- function M:OnSequencePause()
-- 	self.LoadingUI:PlayAnimation(self.LoadingUI.Remind_In)
-- 	self.LoadingUI.Com_Loading:PlayAnimation(self.LoadingUI.Com_Loading.Loop, 0.0, 0)
--     EventManager:FireEvent(EventID.OnHardBossOpeningSequencePause)
-- 	self.LoadingUI.Com_Loading:SetVisibility(UIConst.VisibilityOp.Visible)
-- 	self.LoadingUI.Text_CoopTitle:SetVisibility(UIConst.VisibilityOp.Visible)
-- end

function M:OnAllPlayerReadyCallback()
	if self.SequencePlayer then
		self.SequencePlayer:Play()
	end
end

return M
