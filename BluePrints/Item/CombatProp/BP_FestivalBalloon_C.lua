--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

local BP_FestivalBalloon_C = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function BP_FestivalBalloon_C:AuthorityInitInfo(Info)
    BP_FestivalBalloon_C.Super.AuthorityInitInfo(self, Info)

    self.IsActive = true
    self.Direction = 1
    self.Progress = 0

    self.TimeLength = tonumber(self.TimeLength) or 5

    if self.Spline then
        local StartLoc = self.Spline:GetLocationAtDistanceAlongSpline(0, ESplineCoordinateSpace.World)
        local StartRot = self.Spline:GetRotationAtDistanceAlongSpline(0, ESplineCoordinateSpace.World)  
        self:K2_SetActorLocation(StartLoc, false, nil, false) 
        self:K2_SetActorRotation(StartRot, false)
    else
        DebugPrint("BP_FestivalBalloon_C:CommonInitInfo Spline is nil")
    end
end

function BP_FestivalBalloon_C:ReceiveTick(DeltaSeconds)
    if not self.IsActive then
        return
    end

    if not self.Spline then
        return
    end

    self:MoveWithSpline(DeltaSeconds)
end

function BP_FestivalBalloon_C:MoveWithSpline(DeltaSeconds)
    if not self.Spline then
        return 
    end

    DeltaSeconds = DeltaSeconds or 0
    self.TimeLength = tonumber(self.TimeLength) or 1
    if self.TimeLength <= 0 then
        return
    end

    self.Direction = self.Direction or 1
    self.Progress = self.Progress or 0

    -- 进度按时间推进（秒）
    self.Progress = self.Progress + self.Direction * DeltaSeconds

    if self.MotionType == 0 then
        -- 往返
        if self.Progress >= self.TimeLength then
            self.Progress = self.TimeLength
            self.Direction = -1
        elseif self.Progress <= 0 then
            self.Progress = 0
            self.Direction = 1
        end
    elseif self.MotionType == 1 then
        if self.Progress >= self.TimeLength then
            self.Progress = 0
        elseif self.Progress < 0 then
            self.Progress = 0
            self.Direction = 1
        end
    end

    local Alpha = math.max(0, math.min(1, self.Progress / self.TimeLength))
    local SplineLen = self.Spline:GetSplineLength()
    local Distance = Alpha * SplineLen

    local Location = self.Spline:GetLocationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
    local Rotation = self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)

    -- self:K2_SetActorLocation(Location, false, nil, false)
    -- self:K2_SetActorRotation(Rotation, false)
    self.Target:K2_SetWorldLocation(Location, false, nil, false)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
end

return BP_FestivalBalloon_C
