local ETalkVisibility = {
	Show = "Show",
	Hide = "Hide"
}

local M = {}
local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	local ActorId = Params.ActorId
	local TargetPointName = Params.TargetPoint
	local MoveSpeed = Params.MoveSpeed
	local Visibility = Params.Visibility or ETalkVisibility.Show
	local EnableFootStepFx = Params.EnableFootStepFx or false

	local TalkContext = GWorld.GameInstance:GetTalkContext()
	if (not IsValid(TalkContext)) then
		local Message = string.format("MoveTo create failed: TalkContext not found, DialogueId: %d", Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "MoveTo脚本执行出错：TalkContext无效", Message)
		return
	end

	local TalkActorData = TalkContext:GetTalkActorData(TalkTask, ActorId)
	if (not TalkActorData) then
		local Message = string.format("MoveTo create failed: TalkActorData not found, ActorId: %d, DialogueId: %d", ActorId, Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType,  "MoveTo脚本执行出错：TalkActorData无效", Message)
		return
	end

	local TalkActor = TalkActorData.TalkActor
	if (not IsValid(TalkActor)) then
		local Message = string.format("MoveTo create failed: TalkActor not found, ActorId: %d, DialogueId: %d", ActorId, Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType,  "MoveTo脚本执行出错：TalkActor无效", Message)
		return
	end

	local GameState = UGameplayStatics.GetGameState(Flow)
	if (not IsValid(GameState)) then
		local Message = string.format("MoveTo create failed: GameState not found, DialogueId: %d", Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType,  "MoveTo脚本执行出错：GameState无效", Message)
		return
	end

	local TargetPoint = GameState:GetTargetPoint(TargetPointName)
	if (not IsValid(TargetPoint)) then
		local Message = string.format("MoveTo create failed: TargetPoint not found, PointName: %s, DialogueId: %d", TargetPointName, Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType,  "MoveTo脚本执行出错：TargetPoint无效", Message)
		return
	end

	local ActorForbidFootFX = TalkActor.bForbidFootStepFX
	local MaxMovingSpeedInfoCache = TalkActor:GetMaxMovingSpeedInfo()
	local bMovementTickEnable = TalkActor.bNpcMovementTickEnable
	local ActorStartLocation = TalkActor:K2_GetActorLocation()

	local MoveToNode = Flow:CreateNode(UEFNode_MoveTo)
	MoveToNode.DebugLog = string.format("MoveTo ActorId: %s, TargetPointName: %s, MoveSpeed: %s, Visibility: %s", ActorId, TargetPointName, MoveSpeed, Visibility)

	MoveToNode.OnStart:Add(MoveToNode, function(Node)
		if (MoveSpeed) then
			TalkActor:SetMaxMovingSpeedByInfo({
				NormalWalk = MoveSpeed,
				CrouchWalk = MoveSpeed
			})
		end

		if (Visibility == ETalkVisibility.Show) then
			TalkContext:ShowActor(TalkActorData, true, true)
		end

		local AnimInstance = TalkActor.Mesh:GetAnimInstance()
		if (IsValid(AnimInstance) and AnimInstance.SwitchEnableTalkAction) then
			AnimInstance:SwitchEnableTalkAction(false)
		end

		TalkActor:SetNpcMovementTickEnable(true)
		TalkActor:ForbidFootStep(not EnableFootStepFx)
		if TalkActor:GetMovementComponent() then
			TalkActor:GetMovementComponent():LockMovementMode(false, EMovementMode.MOVE_Walking)
			TalkActor:GetMovementComponent().bDoingMoveToNode = true
		end
		if TalkActor.CapsuleComponent and TalkActor.CapsuleComponent:GetCollisionEnabled() == ECollisionEnabled.NoCollision then
			TalkActor.CapsuleComponent:SetCollisionEnabled(ECollisionEnabled.QueryAndPhysics)
		end

		Node.MoveToProxy = UAIBlueprintHelperLibrary.CreateMoveToProxyObject(Node, TalkActor, TargetPoint:K2_GetActorLocation())
		if (not IsValid(Node.MoveToProxy)) then
			local Message = string.format("MoveTo start failed: MoveToProxy not created, ActorId: %d, DialogueId: %d", ActorId, Flow.DialogueId)
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, "对话运行时出错", Message)
			Node:Finish({ Node.FinishPin })
			return
		end

		Node.MoveToProxy.OnSuccess:Add(Node, function()
			Node:Finish({ Node.FinishPin })
		end)
	end)

	MoveToNode.OnFinish:Add(MoveToNode, function(Node)
		if (MoveSpeed) then
			TalkActor:SetMaxMovingSpeedByInfo(MaxMovingSpeedInfoCache)
		end

		if (Visibility == ETalkVisibility.Hide) then
			TalkContext:HideActor(TalkActorData, true, true)
		end

		local AnimInstance = TalkActor.Mesh:GetAnimInstance()
		if (IsValid(AnimInstance) and AnimInstance.SwitchEnableTalkAction) then
			AnimInstance:SwitchEnableTalkAction(true)
		end

		TalkActor:SetNpcMovementTickEnable(bMovementTickEnable)
		TalkActor:ForbidFootStep(ActorForbidFootFX)
		if TalkActor:GetMovementComponent() then
			TalkActor:GetMovementComponent().bDoingMoveToNode = false
		end
		
		if bMovementTickEnable == false then
			TalkActor:ResetLocation()
		end

		Node.MoveToProxy = nil
	end)

	MoveToNode.OnPause:Add(MoveToNode, function(Node)
		--暂停寻路
		TalkActor:GetController().PathFollowingComponent:SetComponentTickEnabled(false)
		--暂停位移
		TalkActor.CharacterMovement:SetComponentTickEnabled(false)
		--暂停动画
		TalkActor.Mesh:SetComponentTickEnabled(false)
	end)

	MoveToNode.OnResume:Add(MoveToNode, function(Node)
		TalkActor:GetController().PathFollowingComponent:SetComponentTickEnabled(true)
		TalkActor.CharacterMovement:SetComponentTickEnabled(true)
		TalkActor.Mesh:SetComponentTickEnabled(true)
	end)

	MoveToNode.OnSkip:Add(MoveToNode, function(Node)
		TalkActor:GetController():StopMovement()

		local TargetLocation = TargetPoint:K2_GetActorLocation()
		local TargetRotation = UKismetMathLibrary.Conv_VectorToRotator(UKismetMathLibrary.Subtract_VectorVector(TargetLocation, ActorStartLocation))
		TargetRotation.Pitch = 0
		TargetRotation.Roll = 0

		TalkActor:K2_SetActorLocationAndRotation(TargetLocation, TargetRotation, false, nil, true)
		TalkActor:ResetLocation()

		Node:Finish({ Node.FinishPin })
	end)

	return MoveToNode
end

return M
