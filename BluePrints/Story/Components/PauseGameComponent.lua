local M = {}

function M:New(TalkContext, TalkTask, TalkTaskData)
	local Obj = setmetatable({}, {
		__index = M
	})
	Obj.TalkContext = TalkContext
	Obj.TalkTask = TalkTask
	Obj.TalkTaskData = TalkTaskData
	return Obj
end

function M:Execute()
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if (not IsValid(GameMode) or not GameMode:IsA(UE4.AEMGameMode)) then
		return
	end

	GameMode:SetGamePaused(Const.Tag_GamePausedByTalk, true)
	self.TalkContext:OnPausedBegin(self.TalkTaskData)

	local TalkSubsystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UE4.UTalkSubsystem)
	if (not IsValid(TalkSubsystem)) then
		return
	end

	local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
	TalkSubsystem:AddIgnorePauseObject(PlayerController)

	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	TalkSubsystem:AddIgnorePauseObject(PlayerCharacter)

	TalkSubsystem:AddIgnorePauseObject(self.TalkTaskData.SequenceActor)

	for _, TalkActorData in pairs(self.TalkTaskData.TalkActors or {}) do
		local ActorData = self.TalkContext:GetTalkActorData(self.TalkTask, TalkActorData.TalkActorId)
		local Actor = ActorData and ActorData.TalkActor
		TalkSubsystem:AddIgnorePauseObject(Actor)
	end
end

function M:Resume()
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if (not IsValid(GameMode) or not GameMode:IsA(UE4.AEMGameMode)) then
		return
	end

	GameMode:SetGamePaused(Const.Tag_GamePausedByTalk, false)
	self.TalkContext:OnPausedEnd(self.TalkTaskData)

	local TalkSubsystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UE4.UTalkSubsystem)
	if (not IsValid(TalkSubsystem)) then
		return
	end

	TalkSubsystem:ClearIgnorePauseObjects()
end

return M
