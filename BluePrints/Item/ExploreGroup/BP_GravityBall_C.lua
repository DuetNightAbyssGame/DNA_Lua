--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
---@type BP_GravityBall_C
local M = Class({
    "BluePrints/Item/ExploreGroup/BP_DongGuoBreakableItem_C",
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.InitLoc = self.Ball:K2_GetComponentLocation()
    self.InitRot = self.Ball:K2_GetComponentRotation()
    self.CanUse = true
end

function M:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.ResetRange.OnComponentEndOverlap:Add(self, self.OnEndOverlap)
end

-- function M:ReceiveTick(DeltaSeconds)
--     self.Overridden.ReceiveTick(self, DeltaSeconds)
--     local Location = self.Ball:K2_GetComponentLocation()
--     if UE4.UKismetMathLibrary.Vector_Distance(Location, self.InitLoc) >= self.MaxDistance then
--         self.CanUse = false
--         self:OnLeaveMaxDistance()
--         self:SetActorTickEnabled(false)
--     end
--     local Velocity = self.Ball:GetComponentVelocity()
--     if UE4.UKismetMathLibrary.VSize(Velocity) <= 0.1 then
--         self:SetActorTickEnabled(false)
--     end
-- end

function M:OnEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    if OtherActor and OtherActor == self and self.CanUse then
        self.CanUse = false
        self:OnLeaveMaxDistance()
    end
end

function M:OnSpecialBulletHitted(SourceId)
    if not self.IsActive then return end
    if not self.CanUse then return end
    local Player = Battle(self):GetEntity(SourceId)
    if not Player then return end

    -- -- 角冲量
    -- local ImpulseDir = (Player:K2_GetActorLocation() - self.Ball:K2_GetComponentLocation())
    -- ImpulseDir:Normalize()
    -- local AngularImpulse = UKismetMathLibrary.Cross_VectorVector(FVector(0, 0, 1), ImpulseDir * self.Sphere.SphereRadius) * self.Intensity
    -- DebugPrint("zwk", self.Sphere.SphereRadius, ImpulseDir, AngularImpulse)
    -- DebugPrint("zwk1", URuntimeCommonFunctionLibrary.GetSceneComponentBoundsRadius(self.Ball), URuntimeCommonFunctionLibrary.GetSceneComponentBoundsRadius(self.Sphere))
    -- self.Ball:AddAngularImpulseInDegrees(AngularImpulse, "", true)

    if self.MoveMode == 1 then
        -- 添加冲量
        local Impulse = (Player:K2_GetActorLocation() - self.Ball:K2_GetComponentLocation()) * self.Intensity
        self.Ball:AddImpulse(Impulse)
    elseif self.MoveMode == 2 then
        -- 添加扭矩
        local ImpulseDir = (Player:K2_GetActorLocation() - self.Ball:K2_GetComponentLocation())
        ImpulseDir:Normalize()
        local UpVector = FVector(0, 0, 1)
        local TorqueDir = UKismetMathLibrary.Cross_VectorVector(UpVector, ImpulseDir)
        local Torque = TorqueDir * self.Intensity
        self.Ball:AddTorqueInRadians(Torque, "", true)
    end

    -- self:SetActorTickEnabled(true)
end

function M:OnComplete()
    self:ChangeState("Manual", 0, self.CompleteStateId)
    self.Ball:SetSimulatePhysics(false)
    -- self:SetActorTickEnabled(false)
end

function M:GetGuidePos()
    return self.Ball:K2_GetComponentLocation()
end

function M:ResetState()
    self.CanUse = true
    self.Ball:K2_SetWorldLocationAndRotation(self.InitLoc, self.InitRot, false, nil, false)
    self.Ball:SetPhysicsAngularVelocity(FVector(0,0,0))
    self.Ball:SetPhysicsLinearVelocity(FVector(0,0,0))
end

return M
