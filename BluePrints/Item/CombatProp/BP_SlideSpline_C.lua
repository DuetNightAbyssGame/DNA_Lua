--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_SlideSpline_C
local BP_SlideSpline_C = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

function BP_SlideSpline_C:CommonInitInfo(Info)
    BP_SlideSpline_C.Super.CommonInitInfo(self, Info)
    self.Progress = 0.0
    self.Length = self.Spline:GetSplineLength()
    self.Speed = DataMgr.MovementParams["Speed"].ParamValue or 400.0
    self.ChangeCD = DataMgr.MovementParams["SideJumpAttachTime"].ParamValue or 1.0

    -- 转向相关
    self.bIsTurning = false
    self.MoveDirection = 1  -- 1=正向, -1=反向
    self.TurnDuration = 0.0
    self.TurnElapsed = 0.0

    self.AccTime = DataMgr.MovementParams["AccTime"].ParamValue or 0.1

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState then
        GameState:AddSlideMech(self)
    end
end

-- function BP_SlideSpline_C:ReceiveBeginPlay()
--     self.Overridden.ReceiveBeginPlay(self)

--     local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
--     self:EnableInput(PlayerController)
-- end

function BP_SlideSpline_C:OnActorReady(Info)
    BP_SlideSpline_C.Super.OnActorReady(self, Info)
end

function BP_SlideSpline_C:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)
    if IsValid(self.CurPlayer) and self.PlayerInSlide and not self.PlayerInSwitch then
        if self.bIsTurning then
            self:TickTurn(DeltaSeconds)
        else
            self:UpdatePostTurnAccel(DeltaSeconds)
            self:MoveWithSpline(DeltaSeconds, self.CurPlayer)
        end
    end
end

function BP_SlideSpline_C:ChangeSlideMechanism_Lua(IsChangeLeft)
    if IsChangeLeft then
        self:OnChangeLeft()
    else
        self:OnChangeRight()
    end
end

function BP_SlideSpline_C:LeaveSlideMechanism_Lua(IsPassive)
    if self.CurPlayer and not self:IsExistTimer("SlideLaunchPlayer") then
        if self.bIsTurning then
            return
        end
        local Distance = self.Progress * self.Length
        local Tangent = self.Spline:GetDirectionAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
        Tangent:Normalize()
        local PassiveDeattachSpeedPer = DataMgr.MovementParams["PassiveDeattachSpeedPer"].ParamValue or 1.0
        local ActiveDeattachSpeedPer = DataMgr.MovementParams["ActiveDeattachSpeedPer"].ParamValue or 1.0
        local SpeedPer
        local PitchAngle
        if IsPassive then
            SpeedPer = PassiveDeattachSpeedPer
            PitchAngle = self.PassiveDeattachSpeedAngel
            self:EndSlideSplineMove(true)
        else
            SpeedPer = ActiveDeattachSpeedPer
            PitchAngle = self.ActiveDeattachSpeedAngel
            self:EndSlideSplineMove(false)
        end

        local BaseVelocity = Tangent * self.Speed * SpeedPer * self.MoveDirection

        local Right = self.CurPlayer:GetActorRightVector()
        local FinalVelocity = UKismetMathLibrary.RotateAngleAxis(BaseVelocity, -PitchAngle, Right)

        self.CurPlayer:ChangeBackToHeroSlideMech()
        self:AddTimer(0.01, function()
            -- 确保玩家已经切换回原角色后再弹射
            self.CurPlayer:LaunchCharacter(FinalVelocity, true, true)

            self.CurPlayer = nil
            self.PlayerInSlide = false
            self.CanChange = false
            self.MoveDirection = 1
            self:OnEndLeave()
        end, false, 0, "SlideLaunchPlayer")

        self:AddTimer(self.ChangeCD, function()
            self.CanChange = true
        end, false, 0)

    end
end

function BP_SlideSpline_C:MoveWithSpline(DeltaSeconds, Player)
    -- 计算每一帧玩家应该沿着 Spline 前进的距离
    local MoveDistance = self.Speed * DeltaSeconds * Player.SlideMovingRate * self.MoveDirection

    -- 计算新的进度：加上这帧的移动距离
    self.Progress = self.Progress + MoveDistance / self.Length

    if self.Progress >= 1.0 and self.MoveDirection == 1 then
        self:LeaveSlideMechanism(true)
        self.Progress = 1.0
        return
    elseif self.Progress <= 0.0 and self.MoveDirection == -1 then
        -- 反向到达起点也弹出
        self:LeaveSlideMechanism(true)
        self.Progress = 0.0
        return
    elseif self.Progress < 0.0 then
        self.Progress = 0.0
    end

    local Distance = self.Progress * self.Length

    -- 根据新的进度获取玩家在 Spline 上的位置
    local NewLocation = self.Spline:GetLocationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
    NewLocation = self:GetAdjustLocation(NewLocation, Player)
    local NewRotation = self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)

    if self.MoveDirection < 0 then
        NewRotation = UE4.FRotator(NewRotation.Pitch, NewRotation.Yaw + 180.0, NewRotation.Roll)
    end

    -- 更新玩家的位置
    Player:K2_SetActorLocation(NewLocation, false, nil, false)
    Player:K2_SetActorRotation(NewRotation, false, nil, false)
end

function BP_SlideSpline_C:GetAimLocation(DeltaSeconds, Player)
    -- DeltaSeconds指ChangeCD
    -- 计算切换期间考虑加速的总移动距离
    local MoveDistance = self:CalcAccelAwareDistance(DeltaSeconds, Player)

    self.TargetProgress = self.Progress + MoveDistance / self.Length

    if self.TargetProgress >= 1.0 then
        self.TargetProgress = 1.0
    elseif self.TargetProgress < 0.0 then
        self.TargetProgress = 0.0
    end

    local Distance = self.TargetProgress * self.Length

    -- 根据新的进度获取玩家在 Spline 上的位置
    local NewLocation = self.Spline:GetLocationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
    NewLocation = self:GetAdjustLocation(NewLocation, Player)
    local NewRotation = self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
    
    if self.MoveDirection < 0 then
        NewRotation = UE4.FRotator(NewRotation.Pitch, NewRotation.Yaw + 180.0, NewRotation.Roll)
    end
    
    return NewLocation, NewRotation
end

--- 计算在 duration 时间内，考虑加速阶段的实际移动距离（带方向）
--- 之后保持 1.0 匀速
function BP_SlideSpline_C:CalcAccelAwareDistance(duration, Player)
    local baseSpeed = self.Speed * self.MoveDirection
    
    if not self.bPostTurnAccel then
        -- 没有在加速，匀速运动
        return baseSpeed * duration * Player.SlideMovingRate
    end

    -- 当前加速已经过的时间
    local accelElapsed = self.PostTurnAccelElapsed or 0.0
    -- 加速总时长
    local accelTotal = self.AccTime
    -- 剩余加速时间
    local remainAccTime = math.max(accelTotal - accelElapsed, 0.0)
    -- 当前速率
    local currentRate = math.min(accelElapsed / accelTotal, 1.0)

    if remainAccTime <= 0 then
        -- 加速已完成，匀速
        return baseSpeed * duration * 1.0
    end

    local distance = 0.0

    if duration <= remainAccTime then
        -- 整个切换期间都在加速阶段
        -- rate 从 currentRate 线性增长到 currentRate + duration/accelTotal
        -- 积分 ∫ rate dt = currentRate*t + t^2/(2*accelTotal)  从 0 到 duration
        local endRate = math.min(currentRate + duration / accelTotal, 1.0)
        -- 梯形面积 = (currentRate + endRate) * duration / 2
        distance = baseSpeed * (currentRate + endRate) * duration / 2.0
    else
        -- 前半段加速，后半段匀速
        -- 加速阶段：从 currentRate 到 1.0，耗时 remainAccTime
        -- 梯形面积
        local accelDist = baseSpeed * (currentRate + 1.0) * remainAccTime / 2.0
        -- 匀速阶段
        local constDist = baseSpeed * 1.0 * (duration - remainAccTime)
        distance = accelDist + constDist
    end

    return distance
end

function BP_SlideSpline_C:MovePlayerSmooth()
    if not self.CurPlayer then
        return
    end

    if self.CurPlayer.PlayerAnimInstance then
        self.CurPlayer.PlayerAnimInstance.IsSwitchingSlideMech = true
    end

    self.SwitchBeginLocation = self.CurPlayer:K2_GetActorLocation()
    self.SwitchBeginRotation = self.CurPlayer:K2_GetActorRotation()

    self.SwitchBeginProgress = self.Progress

    -- 保存切换开始时的加速状态快照，用于切换期间继续加速
    self.SwitchAccelState = nil
    if self.CurPlayer.SlideMovingRate < 1.0 and self.bPostTurnAccel then
        self.SwitchAccelState = {
            bActive = true,
            accelElapsed = self.PostTurnAccelElapsed or 0.0,
            accelTotal = self.AccTime,
            startRate = self.CurPlayer.SlideMovingRate,
        }
    end

    self.SwitchTargetLocation, self.SwitchTargetRotation = self:GetAimLocation(self.ChangeCD, self.CurPlayer)
    self.CurSwitchDeltaNum = 0
    self.SwitchDeltaTotalNum = self.ChangeCD / 0.01
    self:AddTimer(0.01, self.MovePlayer, true, -0.01, "MovePlayer")
end

function BP_SlideSpline_C:CalcCurLocation()
    local BeginDist = self.Progress * self.Length
    local BeginLoc = self.Spline:GetLocationAtDistanceAlongSpline(BeginDist, ESplineCoordinateSpace.World)
    BeginLoc = self:GetAdjustLocation(BeginLoc, self.CurPlayer)
    return BeginLoc
end

function BP_SlideSpline_C:MovePlayer()
    self.CurSwitchDeltaNum = self.CurSwitchDeltaNum + 1
    if not self.CurPlayer then
        return
    end
    local Alpha = self.CurSwitchDeltaNum / self.SwitchDeltaTotalNum
    if Alpha > 1.0 then
        Alpha = 1.0
    end

    -- 切换期间继续推进加速状态
    if self.SwitchAccelState and self.SwitchAccelState.bActive then
        local elapsed = self.SwitchAccelState.accelElapsed + self.CurSwitchDeltaNum * 0.01
        local accelTotal = self.SwitchAccelState.accelTotal
        local rate = math.min(elapsed / accelTotal, 1.0)
        self.CurPlayer.SlideMovingRate = rate

        -- 同步更新实际的加速计时器，使得切换结束后 TickTurn/UpdatePostTurnAccel 能无缝衔接
        self.PostTurnAccelElapsed = elapsed

        if rate >= 1.0 then
            self.SwitchAccelState.bActive = false
            self.bPostTurnAccel = false
            self.CurPlayer.SlideMovingRate = 1.0
        end
    end

    -- 使用加速感知的非线性进度插值，而非简单线性插值
    -- 因为加速阶段前慢后快，位置插值需要反映真实运动曲线
    local ProgressAlpha = self:CalcSwitchProgressAlpha(Alpha)

    local SmoothAlpha = UKismetMathLibrary.Ease(0.0, 1.0, Alpha, EEasingFunc.EaseInOut)

    local NewLocation = UKismetMathLibrary.VLerp(self.SwitchBeginLocation, self.SwitchTargetLocation, SmoothAlpha)

    local NewRotation = UKismetMathLibrary.RLerp(self.SwitchBeginRotation, self.SwitchTargetRotation, SmoothAlpha, true)

    -- 同步推进 Progress，使用加速感知的进度
    self.Progress = self.SwitchBeginProgress + (self.TargetProgress - self.SwitchBeginProgress) * ProgressAlpha

    self.CurPlayer:K2_SetActorLocation(NewLocation, false, nil, false)
    self.CurPlayer:K2_SetActorRotation(NewRotation, false, nil, false)
    if self.CurSwitchDeltaNum >= self.SwitchDeltaTotalNum then
        self:RemoveTimer("MovePlayer")
        self.Progress = self.TargetProgress
        self.PlayerInSwitch = false
        self:BeginSlideSplineMove(false)
        if self.CurPlayer.PlayerAnimInstance then
            self.CurPlayer.PlayerAnimInstance.IsSwitchingSlideMech = false
        end
    end
end

--- 计算切换过程中，考虑加速的进度 Alpha
--- timeAlpha: 时间维度的 alpha (0~1)
--- 返回: 距离维度的 alpha (0~1)，反映加速导致的非匀速运动
function BP_SlideSpline_C:CalcSwitchProgressAlpha(timeAlpha)
    if not self.SwitchAccelState then
        -- 没有加速状态，线性
        return timeAlpha
    end

    local switchDuration = self.ChangeCD
    local currentTime = timeAlpha * switchDuration
    local totalDist = self:CalcAccelAwareDistanceRaw(switchDuration)
    
    if math.abs(totalDist) < 0.001 then
        return timeAlpha
    end

    local currentDist = self:CalcAccelAwareDistanceRaw(currentTime)
    return currentDist / totalDist
end

--- 内部辅助：基于切换开始时快照计算 t 时间内的无方向距离比例
function BP_SlideSpline_C:CalcAccelAwareDistanceRaw(t)
    if not self.SwitchAccelState or not self.SwitchAccelState.bActive then
        return t  -- 匀速，距离正比于时间
    end

    local accelElapsed = self.SwitchAccelState.accelElapsed
    local accelTotal = self.SwitchAccelState.accelTotal
    local remainAccTime = math.max(accelTotal - accelElapsed, 0.0)
    local currentRate = self.SwitchAccelState.startRate

    if remainAccTime <= 0 then
        return t
    end

    if t <= remainAccTime then
        local endRate = math.min(currentRate + t / accelTotal, 1.0)
        return (currentRate + endRate) * t / 2.0
    else
        local accelPart = (currentRate + 1.0) * remainAccTime / 2.0
        local constPart = 1.0 * (t - remainAccTime)
        return accelPart + constPart
    end
end

function BP_SlideSpline_C:RequestTurn()
    if not self.AllowTurn then
        return
    end
    if self.bIsTurning then
        return
    end
    if not self.CurPlayer or not self.PlayerInSlide then
        return
    end
    if self.PlayerInSwitch then
        return
    end

    self:AddTimer(0.01, self.StartTurn, false, 0)
end

function BP_SlideSpline_C:StartTurn()
    self.bIsTurning = true
    self.TurnElapsed = 0.0

    -- 从动画资产读取转向动画时长
    self.TurnDuration = self:GetTurnAnimDuration("Locomotion")
    DebugPrint("zwk StartTurn TurnDuration ", self.TurnDuration)
    if self.TurnDuration <= 0 then
        self.TurnDuration = 0.5
    end

    -- 记录转向起始旋转
    self.TurnStartRotation = self.CurPlayer:K2_GetActorRotation()
    self.TurnTargetRotation = UE4.FRotator(
        self.TurnStartRotation.Pitch,
        self.TurnStartRotation.Yaw + 180.0,
        self.TurnStartRotation.Roll
    )
end

function BP_SlideSpline_C:TickTurn(DeltaSeconds)
    self.TurnElapsed = self.TurnElapsed + DeltaSeconds

    local Alpha = math.min(self.TurnElapsed / self.TurnDuration, 1.0)

    local NewRotation = UKismetMathLibrary.RLerp(
        self.TurnStartRotation,
        self.TurnTargetRotation,
        Alpha,
        true
    )
    self.CurPlayer:K2_SetActorRotation(NewRotation, false, nil, false)
    -- if self.CurPlayer:GetController() then
    --     self.CurPlayer:GetController():SetControlRotation(NewRotation)
    -- end

    if Alpha >= 0.95 then
        self:EndTurn()
    end
end

function BP_SlideSpline_C:EndTurn()
    self.bIsTurning = false

    -- 反转移动方向
    self.MoveDirection = -self.MoveDirection

    -- 通知动画蓝图退出 Turn，回到 MoveLoop
    if self.CurPlayer.PlayerAnimInstance then
        self.CurPlayer.InSlideMechTurning = false
        self.CurPlayer.PlayerAnimInstance.InSlideMechTurn = false
    end

    -- 将速率归零，开始加速阶段
    self.CurPlayer.SlideMovingRate = 0.0
    self.bPostTurnAccel = true
    self.PostTurnAccelElapsed = 0.0
end

function BP_SlideSpline_C:UpdatePostTurnAccel(DeltaSeconds)
    if not self.bPostTurnAccel then
        return
    end

    self.PostTurnAccelElapsed = self.PostTurnAccelElapsed + DeltaSeconds
    local Alpha = math.min(self.PostTurnAccelElapsed / self.AccTime, 1.0)

    self.CurPlayer.SlideMovingRate = Alpha

    if Alpha >= 1.0 then
        self.bPostTurnAccel = false
        self.CurPlayer.SlideMovingRate = 1.0
    end
end

function BP_SlideSpline_C:GetTurnAnimDuration(MachineName)
    if not self.CurPlayer then return end
    return self.CurPlayer:GetSlideMechTurnAimDuration(MachineName, "T")
end


return BP_SlideSpline_C
