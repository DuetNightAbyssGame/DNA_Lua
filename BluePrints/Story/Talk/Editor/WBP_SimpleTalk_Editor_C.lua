--- 给sequence预览对话使用，实际运行不会跑
local TalkUtils  = require "BluePrints.Story.Talk.View.TalkUtils"
local TalkAudioComp_C = require "BluePrints.Story.Talk.Controller.TalkAudioComp"
local M = Class("BluePrints.Common.TimerMgr")

function M:Construct()
    self.AudioComp = TalkAudioComp_C.New()
	local TS = TalkSubsystem()
	TS.bInImmersiveTalk = true
end

function M:PlayDialogue(DialogueId)
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local DialogueData = DataMgr.Dialogue[DialogueId]
    local NpcId = DialogueData.SpeakNpcId
    local Name = TalkUtils:GetTalkActorName("Npc", NpcId)
    if not string.isempty(DialogueData.SpeakNpcName) then
        Name = DialogueData.SpeakNpcName
    end
    self.TypingText:SetTypingSpeed(0.5)
    self.NpcNameText:SetText(Name)
    self.TypingText:Typing(TalkUtils:DialogueIdToContent(DialogueId))
    self:PlayAudio(DialogueId)
	local TS = TalkSubsystem()
	TS.bInImmersiveTalk = true
end

function M:StopDialogue(DialogueId)
    self:SetVisibility(ESlateVisibility.Collapsed)
    self:StopAudio(DialogueId)
end

function M:PlayAudio(DialogueId)
    self.AudioComp:Clear()
    local DialogueData = DataMgr.Dialogue[DialogueId]
    local NpcId = DialogueData.SpeakNpcId
    -- local Npc = ANpcCharacter.GetNpc(self, NpcId)
	-- DebugPrint("self.SoundOralComponent:PlayAudio", DialogueData.VoiceName, Npc, DialogueData.SpeakNpcId)
	-- local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    -- if (not GameState) then
    --     DebugPrint("Async get or create NPC failed, game state is nil.", GameState)
    --     return
    -- end
    -- if (not GameState.GetNpcInfoAsync) then
    --     DebugPrint("Async get or create NPC failed, game state get npc info async is nil.")
    --     return
    -- end
	local Subsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UTalkEditorContextSubSystem)
	if not Subsystem then return end
	local Npc = Subsystem:GetNpcWithGender(NpcId)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self.AudioComp:PlayAudio(DialogueData.VoiceName, Npc or Player, nil, DialogueData, true, "Editor")
	if not Npc then return end
	local TargetLocation = Npc:K2_GetActorLocation()
	DebugPrint("TargetLocation", TargetLocation)
	if UE4.UKismetMathLibrary.VSize(Player:K2_GetActorLocation() - TargetLocation) >= 10000 then
		TargetLocation = (TargetLocation - Player:K2_GetActorLocation())
		DebugPrint("TargetLocation", TargetLocation, Player:K2_GetActorLocation())
		TargetLocation:Normalize()
		TargetLocation = TargetLocation * 10000 + Player:K2_GetActorLocation()
	end
	DebugPrint("TargetLocation", TargetLocation)
	Player:K2_SetActorLocation(TargetLocation, false, nil, true)
	Player:SetActorHideTag("TalkEditorUI", true)
	local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
	GMFunctionLibrary.SetPlayerGhost(GWorld.GameInstance, true)
end

function M:StopAudio(DialogueId)
    self.AudioComp:Clear()
end

function M:Tick(DeltaTime)
end

return M