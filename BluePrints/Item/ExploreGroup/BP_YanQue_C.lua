--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_YanQue_C
local M = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)

    self.BaseEnergy = self.UnitParams["BaseEnergy"]
    self.MaxEnergy = self.UnitParams["MaxEnergy"]
    self.WarningEnergy = self.UnitParams["WarningEnergy"]
    self.FlySpeed = self.UnitParams["FlySpeed"] * 100  -- cm/s 转成 m/s
    self.ReduceSpeed = self.UnitParams["ReduceSpeed"]
    self.FirstFlyTime = self.UnitParams["FirstFlyTime"] or 2.0
    self.EndFlyTime = self.UnitParams["EndFlyTime"] or 2.0

    self.CurTime = 0.0
    self.TotalTime = 1.0

    -- 移动模式  "SEGMENT"固定时间移动 / "SPEED"固定速度移动
    self.MoveMode = nil

    self.InLowEnergy = false
end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)

    -- 完成后停止后续逻辑，防止UI已释放时报错
    if self.IsCompleted then
        return
    end

    if self.MoveMode == "SEGMENT" then
        self:TickMove_Segment(DeltaSeconds)
    elseif self.MoveMode == "SPEED" then
        self:TickMove_Speed(DeltaSeconds)
    end

    -- 平滑俯仰角归零
    if self.SmoothPitchToZero then
        self.SmoothPitchElapsed = self.SmoothPitchElapsed + DeltaSeconds
        local t = self.SmoothPitchElapsed / self.EndFlyTime
        if t > 1 then t = 1 end
        local newPitch = self.SmoothPitchStart * (1 - t)
        local curRot = self:K2_GetActorRotation()
        local targetRot = UE4.FRotator(newPitch, curRot.Yaw, curRot.Roll)
        self:K2_SetActorRotation(targetRot, false)
        if t >= 1 then
            self.SmoothPitchToZero = false
        end
    end

    if self.UI then
        self.UI:SetPercent(self.CurTime / self.TotalTime)
    end
    if self.BaseEnergy <= self.WarningEnergy and not self.InLowEnergy then
        -- 低电量警告
        self.InLowEnergy = true
        if self.UI then
            self.UI:OnLowEnergy(self.WarningEnergy / self.MaxEnergy)
        end
    elseif self.BaseEnergy > self.WarningEnergy and self.InLowEnergy then
        self.InLowEnergy = false
        if self.UI then
            self.UI:OnRecoverToNormalEnergy()
        end
    end
end

function M:OnEnterState(StateId)
    self.Overridden.OnEnterState(self, StateId)

    if StateId == self.BeginFlyStateId then
        -- 状态2：匀速移动，不使用飞行速度和电量消耗
        local a0 = self:GetAlphaAtPoint(0)
        local a1 = self:GetAlphaAtPoint(1)
        self:AddTimer(1.0, function()
            self:BeginSegmentMove(a0, a1, self.FirstFlyTime, self.FlyingStateId)
        end, false, 0, "BeginFlyDelay")
    elseif StateId == self.FlyingStateId then
        -- 状态3：开始根据飞行速度进行控制
        local a1 = self:GetAlphaAtPoint(1)
        local PointNum = self.ExploreSplineComponent:GetNumberOfSplinePoints()
        self.DistEnterState4 = self.ExploreSplineComponent:GetDistanceAlongSplineAtSplinePoint(PointNum - 2)
        self:BeginSpeedMove(a1, self.FlySpeed, nil)
    elseif StateId == self.DownStateId then
        -- 状态4：匀速降落到终点
        local PointNum = self.ExploreSplineComponent:GetNumberOfSplinePoints()
        local aN2 = self:GetAlphaAtPoint(PointNum - 2)
        local aN1 = self:GetAlphaAtPoint(PointNum - 1)

        if self.ExploreSplineComponent then
            self.ExploreSplineComponent.bEnableRotation = false
        end
        self.SmoothPitchToZero = true
        self.SmoothPitchElapsed = 0.0
        -- 记录当前俯仰角作为起始值
        local CurRot = self:K2_GetActorRotation()
        self.SmoothPitchStart = CurRot.Pitch

        -- 在EndFlyTime内匀速从倒数第二个点到终点
        self:BeginSegmentMove(aN2, aN1, self.EndFlyTime, self.CompleteStateId)
    elseif StateId == self.CompleteStateId then
        -- 状态5：玩法完成，恢复至idle状态
        self.MoveMode = nil
        self.SmoothPitchToZero = false
        self.IsCompleted = true
    end
end

-- 按时间移动，在Duration时间内从StartAlpha移动到EndAlpha
function M:BeginSegmentMove(StartAlpha, EndAlpha, Duration, FinishStateId)
    self.MoveMode = "SEGMENT"
    self.SegStartAlpha = StartAlpha or 0
    self.SegEndAlpha   = EndAlpha or 0
    self.SegDuration   = Duration or 1.0
    self.SegElapsed    = 0.0
    self.SegFinishStateId = FinishStateId

    -- 固定 TotalTime = 1，CurTime=Alpha
    self:ApplyTimeToSpline(self.SegStartAlpha, 1.0)
end

function M:TickMove_Segment(dt)
    self.SegElapsed = self.SegElapsed + dt
    local t = self.SegElapsed / self.SegDuration
    if t > 1 then t = 1 end

    local alpha = self.SegStartAlpha + (self.SegEndAlpha - self.SegStartAlpha) * t
    self:ApplyTimeToSpline(alpha, 1.0)

    if t >= 1 then
        self.MoveMode = nil
        if self.SegFinishStateId then
            self:ChangeState("Manual", 0, self.SegFinishStateId)
        end
    end
end

-- 速度移动，以Speed m/s 的速度推进
function M:BeginSpeedMove(StartAlpha, Speed, FinishStateId)
    if not self.ExploreSplineComponent then return end

    local len = self.ExploreSplineComponent:GetSplineLength()
    if not len or len <= 0 then return end

    self.MoveMode = "SPEED"
    self.Speed = Speed or 0.0
    self.SpeedFinishStateId = FinishStateId

    self.CurDist = (StartAlpha or 0) * len
    if self.CurDist < 0 then self.CurDist = 0 end
    if self.CurDist > len then self.CurDist = len end

    self:ApplyTimeToSpline(self.CurDist / len, 1.0)
end

function M:TickMove_Speed(dt)
    local sp = self.ExploreSplineComponent
    if not sp then return end

    local len = sp:GetSplineLength()
    if not len or len <= 0 then return end

    self.BaseEnergy = self.BaseEnergy - (self.ReduceSpeed * dt)
    self.BaseEnergy = math.clamp(self.BaseEnergy, 0, self.MaxEnergy)
    if self.BaseEnergy <= 0 then
        local alpha = self.CurDist / len
        self:ApplyTimeToSpline(alpha, 1.0)
        self:ChangeState("Manual", 0, self.FallingStateId)
        return
    end

    self.CurDist = self.CurDist + (self.Speed * dt)
    -- DebugPrint("zwkkk Speed ", self.Speed)
    if self.CurDist > len then self.CurDist = len end
    if self.CurDist < 0 then self.CurDist = 0 end

    -- 判断到倒数第二个点，切状态
    if self.DistEnterState4 and self.CurDist >= self.DistEnterState4 then
        self.DistEnterState4 = nil
        self.MoveMode = nil
        self:ChangeState("Manual", 0, self.DownStateId)
        return
    end

    local alpha = self.CurDist / len
    self:ApplyTimeToSpline(alpha, 1.0)

    if self.CurDist >= len then
        self.MoveMode = nil
        if self.SpeedFinishStateId then
            self:ChangeState("Manual", 0, self.SpeedFinishStateId)
        end
    end
end




function M:ApplyTimeToSpline(CurTime, TotalTime)
    self.CurTime = CurTime
    self.TotalTime = TotalTime

    if not self.ExploreSplineComponent then return end

    self.ExploreSplineComponent.CurTime = self.CurTime
    self.ExploreSplineComponent.TotalTime = self.TotalTime
end

function M:GetAlphaAtPoint(PointIndex)
    if not self.ExploreSplineComponent then return 0 end
    local len = self.ExploreSplineComponent:GetSplineLength()
    if len <= 0 then return 0 end
    local dist = self.ExploreSplineComponent:GetDistanceAlongSplineAtSplinePoint(PointIndex)
    if not dist then dist = 0 end
    return dist / len
end

function M:GetCanOpen()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState and GameState.ActiveLimitTimeExploreGroup > 0 then
        self.CanOpen = false
    else
        self.CanOpen = true
    end
end

function M:SetExploreSpline(SplineComponent)
    self.ExploreSplineComponent = SplineComponent
    DebugPrint("zwk SetExploreSpline", self.ExploreSplineComponent:GetName())
end

function M:CheckCanFireCube()
    return self.StateId == self.FlyingStateId
end

function M:GetFirePos()
    return self.FirePos:K2_GetComponentLocation()
end

function M:GetEnterPos()
    return self.EnterPos:K2_GetComponentLocation()
end

function M:OnBlueAttack(Speed, Duration)
    self.Speed = Speed
    self:RemoveTimer("ReduceSpeed")
    self:AddTimer(Duration, function()
        self.Speed = self.FlySpeed
        if self.UI then
            self.UI:OnSpeedNormal()
        end
    end, false, 0, "AddSpeed")
    if self.UI then
        self.UI:OnAddSpeed((self.Speed - self.FlySpeed) / self.FlySpeed)
    end
    if self.OnGetBlueCube then
        self:OnGetBlueCube()
    end
end

function M:OnRedAttack(Speed, Duration)
    self.Speed = Speed
    self:RemoveTimer("AddSpeed")
    self:AddTimer(Duration, function()
        self.Speed = self.FlySpeed
        if self.UI then
            self.UI:OnSpeedNormal()
        end
    end, false, 0, "ReduceSpeed")
    if self.UI then
        self.UI:OnReduceSpeed((self.FlySpeed - self.Speed) / self.FlySpeed)
    end
    if self.OnGetRedCube then
        self:OnGetRedCube()
    end
end

function M:OnGreenAttack(DeltaEnergy)
    self.BaseEnergy = self.BaseEnergy + DeltaEnergy
    self.BaseEnergy = math.clamp(self.BaseEnergy, 0, self.MaxEnergy)
    if self.UI then
        self.UI:OnAddEnergy(DeltaEnergy)
    end
    if self.OnGetGreenCube then
        self:OnGetGreenCube()
    end
end

return M
