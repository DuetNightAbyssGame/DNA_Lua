--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_EnergyCube_C
local M = Class({
    "BluePrints/Item/ExploreGroup/BP_DongGuoBreakableItem_C",
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)

    self.Energy = self.UnitParams["Energy"] or 50
    self.ReturnSpeed = self.UnitParams["ReturnSpeed"] or 10
    self.ReturnSpeed = self.ReturnSpeed * 100
    self.ChangeSpeed = self.UnitParams["ChangeSpeed"] or 4
    self.ChangeSpeed = self.ChangeSpeed * 100
    self.Duration = self.UnitParams["Duration"] or 3
    self.DecelerationSpeed = self.UnitParams["DecelerationSpeed"] or 1
    self.DecelerationSpeed = self.DecelerationSpeed * 100
    self.DecelerationDuration = self.UnitParams["DecelerationDuration"] or 1
    self.Color = self.UnitParams["Color"] or "Blue"
    self.AngleRange = self.UnitParams["AngleRange"] or 60
    self.MinDistance = 15.0

    if self.Color == "Blue" then
        self:SetColorInfo(4.0)
    elseif self.Color == "Red" then
        self:SetColorInfo(5.0)
    elseif self.Color == "Green" then
        self:SetColorInfo(3.0)
    end

    -- self:SetActorHideTag("EnergyCubeHide", true)
    self:SetActorHiddenInGame(true)
end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)
    if self.FlyToTarget and self.YanQue then
        local selfLoc = self:K2_GetActorLocation()
        local targetLoc = self.YanQue:GetEnterPos()

        local toTarget = targetLoc - selfLoc
        local dist = toTarget:Size()

        -- 距离足够近
        if dist <= self.MinDistance then
            self.FlyToTarget = false
            self:SetActorTickEnabled(false)
            self:OnEnterLoc()
            return
        end

        toTarget:Normalize()

        -- 本帧最多走的距离：固定速度 * dt
        local step = self.ReturnSpeed * DeltaSeconds

        -- 防止越过目标
        -- local need = dist - self.MinDistance
        -- if step > need then
        --     step = need
        -- end

        local newLoc = selfLoc + toTarget * step

        -- 带扫掠可以避免穿透；如果你不需要碰撞检测，也可把 sweep 设为 false
        self:K2_SetActorLocation(newLoc, false, nil, false)
    end
end

function M:OnEnterState(StateId)
    self.Overridden.OnEnterState(self, StateId)

    if StateId == self.FlyStateId then

    elseif StateId == self.AttackStateId then

    end
end

function M:CommonOnAttack()
    self:ChangeState("Hit", 0)
    self.ProjectileMovement.bSimulationEnabled = false
    self.FlyToTarget = true
    self.YanQue = Battle(self):GetEntity(self.YanQueEid)
    self.CubeMesh:SetCollisionEnabled(ECollisionEnabled.NoCollision)
end

function M:BlueAttack()
    DebugPrint("zwkkk BlueAttack")
    -- if self.YanQue then
    --     self.YanQue:OnBlueAttack(self.ChangeSpeed, self.Duration)
    -- end
end

function M:RedAttack()
    DebugPrint("zwkkk RedAttack")
    -- if self.YanQue then
    --     self.YanQue:OnRedAttack(self.DecelerationSpeed, self.DecelerationDuration)
    -- end
end

function M:GreenAttack()
    DebugPrint("zwkkk GreenAttack")
    -- if self.YanQue then
    --     self.YanQue:OnGreenAttack(self.Energy)
    -- end
end

function M:OnEnterLoc()
    -- 到达偃雀指定位置点
    if self.YanQue then
        if self.Color == "Blue" then
            self.YanQue:OnBlueAttack(self.ChangeSpeed, self.Duration)
        elseif self.Color == "Red" then
            self.YanQue:OnRedAttack(self.DecelerationSpeed, self.DecelerationDuration)
        elseif self.Color == "Green" then
            self.YanQue:OnGreenAttack(self.Energy)
        end
    end

    self:BluePrintOnEnterLoc(self.Color)
    self:ChangeState("Manual", 0, self.DestroyStateId)
end

function M:FireCube(Position, YanQueEid)
    self:ChangeState("Manual", 0, self.FlyStateId)
    self:K2_SetActorLocation(Position, false, nil, false)
    -- self:SetActorHideTag("EnergyCubeHide", false)
    self:SetActorHiddenInGame(false)
    self:LaunchCube()
    self.YanQueEid = YanQueEid
end

function M:DegToRad(d)
     return d * math.pi / 180
end
function M:RandRange(a, b)
    return a + math.random() * (b - a)
end

function M:RandomLaunchDir_ConeUniform(maxPitchDeg)
    maxPitchDeg = maxPitchDeg or 60.0

    local yawDeg = self:RandRange(0.0, 360.0)
    local yaw = self:DegToRad(yawDeg)

    -- 让 cos(pitch) 均匀：cos(pitch) ∈ [cos(maxPitch), 1]
    local cmin = math.cos(self:DegToRad(maxPitchDeg))
    local c = self:RandRange(cmin, 1.0)
    local pitch = math.acos(c)

    local cp = math.cos(pitch)
    local sp = math.sin(pitch)

    local dir = FVector(
        cp * math.cos(yaw),
        cp * math.sin(yaw),
        sp
    )
    dir:Normalize()
    return dir
end

function M:LaunchCube()
    local dir = self:RandomLaunchDir_ConeUniform(self.AngleRange)
    self.ProjectileMovement.Velocity = dir * self.ProjectileMovement.InitialSpeed
    self.ProjectileMovement.bSimulationEnabled = true
    DebugPrint("zwkkk Dir ", dir)
end

return M
