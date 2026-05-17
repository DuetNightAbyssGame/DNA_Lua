--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class({
    "BluePrints.Common.TimerMgr"
})

function M:ReceiveTick(DeltaSeconds)
    -- if IsClient(self) then return end
    if self.IsMoveOneTgt then
        self:InMoveOneTgt(DeltaSeconds)
    elseif self.IsRotateOneTgt then
        self:InRotateOneTgt(DeltaSeconds)
    elseif self.IsRotateKeep then

    end
end

function M:OnForcePause()
    -- 进入暂停状态
    self.ForcePause = true
end

--------------------------------------------------------定点移动-----------------------------------------------------------------------------
function M:MoveOneTgt()
    self.Motion = self:GetOwner()
    if not self.Motion then return end
    self.IsMoveOneTgt = true

    if self.ForcePause and self.CurrentTime and self.CurrentTime >= 0 then
        
    else
        self.StartLocation = self.Motion:K2_GetActorLocation()
        self.TargetLocationAbs = UKismetMathLibrary.TransformLocation(self.Motion:GetTransform(), self.Motion.TargetLocation)
        self.CurrentTime = 0.0
        self.MoveTime = self.Motion.MoveTime
        self.MoveUniformly = self.Motion.MoveUniformly
        self.bMovingToTarget = true
        self.bIsPaused = false
    end
    self.ForcePause = false
end

function M:InMoveOneTgt(DeltaTime)
    if IsClient(self.Motion) and not self.Motion.UseClient then
        if self.bMovingToTarget then
            self.Motion:MoveLocationLerp(DeltaTime, self.StartLocation, self.TargetLocationAbs, 0, self.MoveTime, self.MoveUniformly and 0 or 1)
        else
            self.Motion:MoveLocationLerp(DeltaTime, self.TargetLocationAbs, self.StartLocation, 0, self.MoveTime, self.MoveUniformly and 0 or 1)
        end
        return
    end

    if self.bIsPaused or not self.Motion or self.ForcePause then
        return
    end

    self.CurrentTime = self.CurrentTime + DeltaTime
    local Progress = self.CurrentTime / self.MoveTime

    if Progress > 1.0 then
        -- 运动完成，暂停后切换方向
        self:PauseBeforeReverse()
        return
    end

    if self.Motion.UseClient then
        -- 计算当前运动位置
        local NewPosition
        if self.MoveUniformly then
            NewPosition = self:InterpolateLinear(Progress)
        else
            NewPosition = self:InterpolateAccelerated(Progress)
        end

        -- 设置 Owner 位置
        self.Motion:K2_SetActorLocation(NewPosition, false, nil, false)
    else
        if self.bMovingToTarget then
            self.Motion:MoveLocationLerp(DeltaTime, self.StartLocation, self.TargetLocationAbs, 0, self.MoveTime, self.MoveUniformly and 0 or 1)
        else
            self.Motion:MoveLocationLerp(DeltaTime, self.TargetLocationAbs, self.StartLocation, 0, self.MoveTime, self.MoveUniformly and 0 or 1)
        end
    end
end

-- 线性插值（匀速运动）
function M:InterpolateLinear(Progress)
    if self.bMovingToTarget then
        return self.StartLocation + (self.TargetLocationAbs - self.StartLocation) * Progress
    else
        return self.TargetLocationAbs + (self.StartLocation - self.TargetLocationAbs) * Progress
    end
end

-- 加速插值（非匀速运动）
function M:InterpolateAccelerated(Progress)
    -- 读取 Owner 的 Acceleration
    -- local Acceleration = self.Motion.Acceleration

    -- SmootherStep 插值模拟加速
    local t = Progress * Progress * (3 - 2 * Progress)
    if self.bMovingToTarget then
        return self.StartLocation + (self.TargetLocationAbs - self.StartLocation) * t
    else
        return self.TargetLocationAbs + (self.StartLocation - self.TargetLocationAbs) * t
    end
end

-- 运动暂停并切换方向
function M:PauseBeforeReverse()
    self.bIsPaused = true
    self.CurrentTime = 0
    self.Motion:ResetMovementInfo()

    -- 读取 Owner 变量确定暂停时间
    local TeleportBack = self.Motion.TeleportBackToOrigin
    local PauseTime = self.bMovingToTarget and self.Motion.PauseTime1 or self.Motion.PauseTime2

    -- 设定定时器，暂停后继续运动
    self:AddTimer(PauseTime, function()
        self.bIsPaused = false
        if TeleportBack and self.bMovingToTarget then
            -- 到达目标点后立即瞬移回起点，再继续往目标点移动
            self.Motion:K2_SetActorLocation(self.StartLocation)

            -- 重新计算绝对目标位置（相对起点）
            self.TargetLocationAbs = UKismetMathLibrary.TransformLocation(self.Motion:GetTransform(), self.Motion.TargetLocation)

            -- 重设为朝向目标方向
            self.bMovingToTarget = true
        else
            -- 原始往返模式：反转方向
            self.bMovingToTarget = not self.bMovingToTarget
        end
    end, false, 0)


end
--------------------------------------------------------定点移动-----------------------------------------------------------------------------


--------------------------------------------------------定点旋转-----------------------------------------------------------------------------
function M:RotateOneTgt()
    self.Motion = self:GetOwner()
    if not self.Motion then return end
    self.IsRotateOneTgt = true

    if self.ForcePause and self.CurrentTime and self.CurrentTime >= 0 then
        
    else
        self.CurrentTime = 0
        self.RotateTime = self.Motion.RotateTime
        self.RotateUniformly = self.Motion.RotateUniformly
        self.bRotatingToTarget = true
        self.bIsPaused = false
        self.KeepingRotate = self.Motion.KeepingRotate
        self.TargetRotation = self.Motion.TargetRotation or FRotator(0, 90, 0)

        self.TotalRotated = FRotator(0, 0, 0) -- 局部旋转累积值
    end
    self.ForcePause = false
end

function M:InRotateOneTgt(DeltaTime)
    if IsClient(self.Motion) and not self.Motion.UseClient then
        self.CurrentTime = self.CurrentTime + DeltaTime
        local progress = math.min(self.CurrentTime / self.RotateTime, 1.0)
        local currentRelativeRot
        if self.RotateUniformly then
            currentRelativeRot = self:InterpolateLinearRot(progress)
        else
            currentRelativeRot = self:InterpolateAcceleratedRot(progress)
        end
        local deltaRot = currentRelativeRot - self.TotalRotated
        self.TotalRotated = currentRelativeRot
        self.Motion:MoveRotationLerp(DeltaTime, deltaRot)
        return
    end

    if self.bIsPaused or not self.Motion then
        return
    end

    self.CurrentTime = self.CurrentTime + DeltaTime
    local progress = math.min(self.CurrentTime / self.RotateTime, 1.0)

    -- 插值出当前期望总旋转值
    local currentRelativeRot
    if self.RotateUniformly then
        currentRelativeRot = self:InterpolateLinearRot(progress)
    else
        currentRelativeRot = self:InterpolateAcceleratedRot(progress)
    end

    -- 与上一次比较，得到“增量旋转”
    local deltaRot = currentRelativeRot - self.TotalRotated
    self.TotalRotated = currentRelativeRot

    if self.Motion.UseClient then
        -- 局部坐标系旋转
        self.Motion:K2_AddActorLocalRotation(deltaRot, false, nil, false)
    else
        self.Motion:MoveRotationLerp(DeltaTime, deltaRot)
    end
    if progress >= 1.0 then
        self:PauseBeforeReverseRot()
    end
end

-- 线性插值（匀速旋转）
function M:InterpolateLinearRot(progress)
    local target = self.TargetRotation
    local factor = self.bRotatingToTarget and progress or (1.0 - progress)
    return FRotator(
        target.Pitch * factor,
        target.Yaw * factor,
        target.Roll * factor
    )
end

-- 加速插值（非匀速旋转）
function M:InterpolateAcceleratedRot(progress)
    local t = progress * progress * (3 - 2 * progress)
    local target = self.TargetRotation
    local factor = self.bRotatingToTarget and t or (1.0 - t)
    return FRotator(
        target.Pitch * factor,
        target.Yaw * factor,
        target.Roll * factor
    )
end

-- 旋转暂停并切换方向
function M:PauseBeforeReverseRot()
    self.bIsPaused = true
    self.CurrentTime = 0
    self.Motion:ResetMovementInfo()

    -- 读取 Owner 变量确定暂停时间
    local PauseTime = self.bRotatingToTarget and self.Motion.RotatePauseTime1 or self.Motion.RotatePauseTime2

    -- 设定定时器，暂停后继续运动
    self:AddTimer(PauseTime, function()
        self.bIsPaused = false
        self.TotalRotated = FRotator(0, 0, 0)

        if self.KeepingRotate and self.bRotatingToTarget then
            -- 继续旋转（不反向），增加目标旋转角度
            self.bRotatingToTarget = true
        else
            -- 反转方向
            self.bRotatingToTarget = not self.bRotatingToTarget
        end
    end, false, 0)
end



--------------------------------------------------------定点旋转-----------------------------------------------------------------------------

return M
