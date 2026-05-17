local M = Class()

local LogType = UE.EStoryLogType.Sequence

function M:StartMoveTo(MoveToData)
    local Section = MoveToData.Section
    local Character = MoveToData.Character

    if not (IsValid(Section) and IsValid(Character)) then
        return 
    end
    local SourceLocation = MoveToData.SourceLocation
    local TargetLocation = MoveToData.TargetLocation
    local NowLocation = Character:K2_GetActorLocation()
    local SquaredDis = UE4.UKismetMathLibrary.Vector_DistanceSquared(NowLocation, SourceLocation)

    if SquaredDis > 10000 then
        Character:K2_SetActorLocation(SourceLocation, false, nil, false)
    end

    if Section.MoveTurnToTarget then
        local OriginToDest = TargetLocation - SourceLocation
        local LookAtRot = UE4.UKismetMathLibrary.Conv_VectorToRotator(OriginToDest)
        LookAtRot.Roll = 0
        LookAtRot.Pitch = 0
        Character:K2_SetActorRotation(LookAtRot, false, nil, false)
    end

    local TalkSequenceObject = UTrackInstanceFunctionLibrary.GetTalkSequenceObject(self, MoveToData.Input)
    if not TalkSequenceObject or not TalkSequenceObject:IsInSkip() then
        if Character.NpcAnimInstance and  MoveToData.Character.NpcAnimInstance.IsRotating then
            Character:AbortRotation()
            local Message = string.format("%s %d 转身尚未结束就开始Moveto，请把转身加快一点", Character:GetName(), Character.NpcId)
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, LogType, "Sequence移动轨道异常", Message)
        end
    end

    Character:SetMaxWalkSpeed(MoveToData.MoveToSpeed)
    Character:SetNpcMovementTickEnable(true)

    if Character:GetMovementComponent() then
        Character:GetMovementComponent():LockMovementMode(false, EMovementMode.MOVE_Walking)
    end

    Character:ForbidFootStep(not Section.EnableFootStepFX)

    UAIBlueprintHelperLibrary.CreateMoveToProxyObject(Character, Character, TargetLocation, nil, Section.MoveAcceptRadius)

    local CustomSequencePropertySystem = USubsystemBlueprintLibrary.GetWorldSubsystem(MoveToData.Character, UCustomSequencePropertySystem)
    if (IsValid(CustomSequencePropertySystem)) then
        CustomSequencePropertySystem:ForbiddenNpcTransform(MoveToData.Character, self)
    end
end

function M:EndMoveTo(MoveToData)
    local Character = MoveToData.Character
    if not IsValid(Character) then
        return
    end

    self:FinishMoveTo(MoveToData)

    -- if Character:GetMovementComponent() then
    --     Character:GetMovementComponent():LockMovementMode(true, EMovementMode.MOVE_NavWalking)
    -- end
    if Character.NpcAnimInstance and not Character.NpcAnimInstance.IsRotating then
        Character:SetNpcMovementTickEnable(false)
    end

    Character:ForbidFootStep(MoveToData.NpcForbidFootStep)
    Character:SetWalkSpeed()
    Character:CacheLastMovementLoc()

    local CustomSequencePropertySystem = USubsystemBlueprintLibrary.GetWorldSubsystem(Character, UCustomSequencePropertySystem)
    if IsValid(CustomSequencePropertySystem) then
        CustomSequencePropertySystem:UnForbiddenNpcTransform(Character, self)
    end
end

return M