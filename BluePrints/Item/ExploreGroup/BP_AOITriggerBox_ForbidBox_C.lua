--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_AOITriggerBox_ForbidBox_C
local M = Class("BluePrints.Common.Triggers.BP_AOITriggerBox_C")

function M:CollisionBeginOverlap(Component, OtherActor)
    if not OtherActor.IsPlayer or not OtherActor:IsPlayer() then
        return
    end
    self:ExecuteForbid(OtherActor, true)
    self.OverlappingPlayer = OtherActor
    M.Super.CollisionBeginOverlap(self, Component, OtherActor)
end

function M:CollisionEndOverlap(Component, OtherActor)
    if not OtherActor.IsPlayer or not OtherActor:IsPlayer() then
        return
    end
    self:ExecuteForbid(OtherActor, false)
    self.OverlappingPlayer = nil
    M.Super.CollisionEndOverlap(self, Component, OtherActor)
end

function M:OnPreTransformPlayer()
    if not self.OverlappingPlayer then
        return false, FTransform()
    end
    if self.InTransformCD then
        return false, FTransform()
    end
    self.InTransformCD = true
    self:AddTimer(0.01, function()
        self.InTransformCD = false
    end, false, 0)
    -- local PlayerLoc = self.OverlappingPlayer:K2_GetActorLocation()
    -- local LocalPos = UE.UKismetMathLibrary.InverseTransformLocation(self.CollisionComponent:K2_GetComponentToWorld(), PlayerLoc)
    -- DebugPrint("zwkkk LocalPos ", LocalPos)
    -- return true, FTransform(LocalPos, self.OverlappingPlayer:K2_GetActorRotation(), FVector(1,1,1))
    local PlayerTrans = self.OverlappingPlayer:GetTransform()
    local BoxTrans = self.CollisionComponent:K2_GetComponentToWorld()
    DebugPrint("zwjkjk PlayerTrans ", PlayerTrans)
    DebugPrint("zwjkjk BoxTrans ", BoxTrans)
    return true, UE.UKismetMathLibrary.MakeRelativeTransform(PlayerTrans, BoxTrans)
end

function M:SetNewTransform(Transform)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not Player then
        return
    end

    -- local BoxTrans = self.CollisionComponent:K2_GetComponentToWorld()
    -- local NewPlayerTrans = UE.UKismetMathLibrary.ComposeTransforms(Transform, BoxTrans)
    -- Player:K2_SetActorTransform(NewPlayerTrans, false, nil, false)
    -- -- Player:GetController():SetControlRotation(Player:K2_GetActorRotation())
    -- local Controller = Player:GetController()
    -- if Controller then
    --     local CR = Controller:GetControlRotation()

    --     local NewRot = UE.UKismetMathLibrary.Conv_TransformToRotator(NewPlayerTrans)
    --     -- 只对齐Yaw，保留玩家抬头低头
    --     local Fixed = UE.FRotator(CR.Pitch, NewRot.Yaw, 0.0)

    --     Controller:SetControlRotation(Fixed)
    -- end
	-- Player:Landed()

    local Controller = Player:GetController()

    -- 记录瞬移前
    local OldActorRot = Player:K2_GetActorRotation()
    local OldCtrlRot
    if Controller then
        OldCtrlRot = Controller:GetControlRotation()
    end

    -- 计算目标世界Transform
    local BoxTrans = self.CollisionComponent:K2_GetComponentToWorld()
    local NewPlayerTrans = UE.UKismetMathLibrary.ComposeTransforms(Transform, BoxTrans)

    Player:K2_SetActorTransform(NewPlayerTrans, false, nil, true)
    DebugPrint("zwjkjk SetNewTransform ", NewPlayerTrans)

    -- 瞬移后修正镜头
    if Controller and OldCtrlRot then
        local NewActorRot = NewPlayerTrans.Rotator and NewPlayerTrans:Rotator() or Player:K2_GetActorRotation()

        local DeltaYaw = NewActorRot.Yaw - OldActorRot.Yaw

        local NewCtrlRot = UE.FRotator(OldCtrlRot.Pitch, OldCtrlRot.Yaw + DeltaYaw, OldCtrlRot.Roll)
        Controller:SetControlRotation(NewCtrlRot)

        -- 修正速度方向，将速度向量绕Z轴旋转 DeltaYaw
        local MovementComp = Player.CharacterMovement or Player:GetMovementComponent()
        if MovementComp then
            local OldVelocity = MovementComp.Velocity
            if OldVelocity and (OldVelocity.X ~= 0 or OldVelocity.Y ~= 0 or OldVelocity.Z ~= 0) then
                local DeltaRotator = UE.FRotator(0, DeltaYaw, 0)
                local NewVelocity = UE.UKismetMathLibrary.GreaterGreater_VectorRotator(OldVelocity, DeltaRotator)
                MovementComp.Velocity = NewVelocity
            end
        end
    end
end

return M
