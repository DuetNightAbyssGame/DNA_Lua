--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_WindCreateNew_C
local BP_WindCreateNew_C = Class("BluePrints.Item.BP_CombatItemBase_C")

function BP_WindCreateNew_C:CommonInitInfo(Info)
    BP_WindCreateNew_C.Super.CommonInitInfo(self,Info)
    self.WindSpeedCpp = self.WindSpeed
    self.WindRateCpp = self.WindRate
    self.ArrowComp = self.Arrow
    self.ActorsToIgnore = TArray(AActor)
    self.HitResult = FHitResult()
    self.ActorsToIgnore:Add(self)
    self.Color1 = UE4.FLinearColor(1, 0, 0, 1)
    self.Color2 = UE4.FLinearColor(0, 1, 0, 1)
end

function BP_WindCreateNew_C:OnCharacterEnter(Character)
    -- DebugPrint("============================================OnCharacterEnter============", Character:GetName())
    self.InWindCharacters:Add(Character)
end

function BP_WindCreateNew_C:OnCharacterLeave(Character)
    -- DebugPrint("============================================OnCharacterLeave============", Character:GetName())
    self.InWindCharacters:RemoveItem(Character)
end

-- function BP_WindCreateNew_C:ReceiveTick(DeltaSeconds)
--     self.Overridden.ReceiveTick(self, DeltaSeconds)
--     if self.IsActive ~= true then
--         return
--     end
--     for i = 1, self.InWindCharacters:Num() do
--         -- self:PushTargetByWind(self.InWindCharacters[i])
--         UE4.URuntimeCommonFunctionLibrary.WindCreateNewPushTargetByWind(self.InWindCharacters[i], self.Arrow, self.WindSpeed, self.WindRate)
--     end
-- end

-- function BP_WindCreateNew_C:PushTargetByWind(TargetActor)
--     local ArrowPos = self.Arrow:K2_GetComponentLocation()
--     local ActorPos = TargetActor:k2_GetActorLocation()
--     local Dir = ActorPos - ArrowPos
--     local ArrowForward = self.Arrow:GetForwardVector()
--     -- ArrowForward. Z = 0
--     -- Dir.Z = 0
--     Dir:Normalize()
--     ArrowForward:Normalize()
--     local CosAngle = Dir:Dot(ArrowForward)
--     local Distance = UE4.UKismetMathLibrary.Vector_Distance(ActorPos, ArrowPos)
--     local ForwardDis = Distance * CosAngle
--     local PlayerHalfHeight = TargetActor.CapsuleComponent:GetScaledCapsuleHalfHeight()
--     local PlayerLoc1 = FVector(ActorPos.X, ActorPos.Y, ActorPos.Z - PlayerHalfHeight)
--     local PlayerLoc2 = FVector(ActorPos.X, ActorPos.Y, ActorPos.Z + PlayerHalfHeight)
--     local bHit1 = UE4.UKismetSystemLibrary.LineTraceSingle(self, PlayerLoc1 - ArrowForward * ForwardDis, PlayerLoc1, ETraceTypeQuery.TraceScene, false, self.ActorsToIgnore, 0, self.HitResult, true, self.Color1, self.Color2)
--     local bHit2 = UE4.UKismetSystemLibrary.LineTraceSingle(self, PlayerLoc2 - ArrowForward * ForwardDis, PlayerLoc2, ETraceTypeQuery.TraceScene, false, self.ActorsToIgnore, 0, self.HitResult, true, self.Color1, self.Color2)
--     if bHit1 == false or bHit2 == false then
--         if TargetActor:IsPlayer() then
--             local ActorVelocity = FVector(TargetActor.CharacterMovement.Velocity.X, TargetActor.CharacterMovement.Velocity.Y, TargetActor.CharacterMovement.Velocity.Z)
--             ActorVelocity:Normalize()
--             local VelCosAngle = ActorVelocity:Dot(ArrowForward)
--             local ArrowForwardValLen = 0
--             if (TargetActor:IsPlayer() and (TargetActor.MoveInput.X ~= 0 or TargetActor.MoveInput.Y ~= 0)) then
--                 local TargetForward = TargetActor:GetActorForwardVector()
--                 TargetForward:Normalize()
--                 local TargetCosAngle = TargetForward:Dot(ArrowForward)
--                 ArrowForwardValLen = TargetCosAngle * TargetActor.CharacterMovement.MaxWalkSpeed
--             end
--             local ActorForwardValLen = VelCosAngle * TargetActor.CharacterMovement.Velocity:Size()
--             -- DebugPrint("===================wwwyyy========================================", VelCosAngle,ArrowForwardValLen,ActorForwardValLen,TargetActor.CharacterMovement.MaxWalkSpeed)
--             if TargetActor.IsCharacterInAir and TargetActor:IsCharacterInAir() then
--                 -- TargetActor:LaunchCharacter(ArrowForward * self.WindSpeed * self.WindRate, true, false)
--                 TargetActor.CharacterMovement.Velocity = TargetActor.CharacterMovement.Velocity - ArrowForward * (ActorForwardValLen) + ArrowForward * (self.WindSpeed * self.WindRate + ArrowForwardValLen)
--             else
--                 TargetActor.CharacterMovement.Velocity = TargetActor.CharacterMovement.Velocity - ArrowForward * (ActorForwardValLen) + ArrowForward * (self.WindSpeed + ArrowForwardValLen)
--             end
--         elseif TargetActor:IsRealMonster() or TargetActor:IsPhantom() then
--             local Rate = 1
--             if TargetActor.IsFlying and TargetActor:IsFlying() then
--                 Rate = self.WindRate
--             end
--             TargetActor:LaunchCharacter(ArrowForward * self.WindSpeed * Rate, true, true)
--         end
--     end
-- end

function BP_WindCreateNew_C:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)
    -- self.IsActive = self.Data.FirstStateId ~= NowStateId
    local Speed = self.StateSpeedMap:FindRef(NowStateId)
    if Speed then
        self.WindSpeed = Speed
        -- DebugPrint("=================self.WindSpeed:",self.WindSpeed)
    end
end

return BP_WindCreateNew_C
