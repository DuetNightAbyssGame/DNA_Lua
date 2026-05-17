local ETalkVisibility = {
	Show = "Show",
	Hide = "Hide"
}

local M = {}
local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	local ActorId = Params.ActorId
	local TargetPointName = Params.TargetPoint
	local Visibility = Params.Visibility or ETalkVisibility.Show

	local TalkContext = GWorld.GameInstance:GetTalkContext()
	if (not IsValid(TalkContext)) then
		local Message = string.format("SetLocation create failed: TalkContext not found, DialogueId: %d", Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetLocation脚本执行出错: TalkContext无效", Message)
		return
	end

	local TalkActorData = TalkContext:GetTalkActorData(TalkTask, ActorId)
	if (not TalkActorData) then
		local Message = string.format("SetLocation create failed: TalkActorData not found, DialogueId: %d, ActorId: %d", Flow.DialogueId, ActorId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetLocation脚本执行出错: TalkActorData无效", Message)
		return
	end

	local TalkActor = TalkActorData.TalkActor
	if (not IsValid(TalkActor)) then
		local Message = string.format("SetLocation create failed: TalkActor not found, DialogueId: %d, ActorId: %d", Flow.DialogueId, ActorId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetLocation脚本执行出错: TalkActor无效", Message)
		return
	end

	local GameState = UGameplayStatics.GetGameState(Flow)
	if (not IsValid(GameState)) then
		local Message = string.format("SetLocation create failed: GameState not found, DialogueId: %d", Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetLocation脚本执行出错: GameState无效", Message)
		return
	end

	local TargetPoint = GameState:GetTargetPoint(TargetPointName)
	if (not IsValid(TargetPoint)) then
		local Message = string.format("SetLocation create failed: TargetPoint not found, DialogueId: %d, PointName: %s", Flow.DialogueId, TargetPointName)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetLocation脚本执行出错: TargetPoint无效", Message)
		return
	end

	local SetLocationNode = Flow:CreateNode(UEFNode_Delegate)
	SetLocationNode.DebugLog = string.format("SetLocation ActorId: %s, TargetPointName: %s, Visibility: %s", ActorId, TargetPointName, Visibility)

	SetLocationNode.OnStart:Add(SetLocationNode, function(Node)
		if (Visibility == ETalkVisibility.Show) then
			TalkContext:ShowActor(TalkActorData, true, true)
		else
			TalkContext:HideActor(TalkActorData, true, true)
		end

		local ResLoc = TargetPoint:K2_GetActorLocation()
		local TargetPointLoc = TargetPoint:K2_GetActorLocation() + FVector(0, 0, 10) -- 抬高一点，避免意外穿地？本地无法复现，试着修复下
		local HalfHeight = TalkActor.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
		local EndLoc = TargetPointLoc - FVector(0, 0, 1000)
		local HitResult = FHitResult()
		local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(GWorld.GameInstance, TargetPointLoc, EndLoc, ETraceTypeQuery.TraceScene, false, nil, 0, HitResult, true)
		if bHit then
			ResLoc = FVector(TargetPointLoc.X, TargetPointLoc.Y, HitResult.ImpactPoint.Z + HalfHeight)
		end
		TalkActor:K2_SetActorLocation(ResLoc, false, nil, false)
		Node:Finish({ Node.FinishPin })
	end)

	return SetLocationNode
end

return M
