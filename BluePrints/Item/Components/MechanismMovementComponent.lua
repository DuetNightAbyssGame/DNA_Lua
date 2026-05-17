--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
local MiscUtils = require "Utils.MiscUtils"
local Component = {}

function Component:InitComponent()
    -- self.CurrentVelocity = FVector(0,0,0)
    -- self.CurrentAcceleration = FVector(0,0,-100)
end

-- function Component:SetMovementParam(Velocity, Acceleration, RotatorVelocity)
--     self.CurrentVelocity = Velocity or FVector(0,0,0)
--     self.CurrentAcceleration = Acceleration or FVector(0,0,-100)
--     self.CurrentRotatorVelocity = RotatorVelocity or FRotator(0,0,0)
-- end

-- function Component:MoveLocation(DeltaSeconds)
--     local CurrentLocation = self:K2_GetActorLocation()
--     local X = self:MoveAxis(DeltaSeconds, "X", CurrentLocation)
--     local Y = self:MoveAxis(DeltaSeconds, "Y", CurrentLocation)
--     local Z = self:MoveAxis(DeltaSeconds, "Z", CurrentLocation)
--     local NextLocation = FVector(X,Y,Z)
--     -- print(_G.LogTag, NextLocation)
--     self:K2_SetActorLocation(NextLocation, false, nil, false)
-- end

-- function Component:MoveRotation(DeltaSeconds)
--     local CurrentRotation = self:K2_GetActorRotation()
--     local NewPitch = self.CurrentRotatorVelocity.Pitch*DeltaSeconds
--     local NewYaw = self.CurrentRotatorVelocity.Yaw*DeltaSeconds
--     local NewRoll = self.CurrentRotatorVelocity.Roll*DeltaSeconds
--     -- print(_G.LogTag,"LXZ ",NewPitch, NewYaw, NewRoll)
--     local NewRotation = FRotator(CurrentRotation.Pitch + NewPitch, CurrentRotation.Yaw + NewYaw, CurrentRotation.Roll + NewRoll)
--     self:K2_SetActorRotation(NewRotation, false)
-- end

-- function Component:MoveAxis(DeltaSeconds, AxisName, CurrentLocation)
--     local Speed = self.CurrentVelocity[AxisName]
--     local Acceleration = self.CurrentAcceleration[AxisName]
--     local AxisLocation = CurrentLocation[AxisName]
--     local NextAxisLocation = Speed * DeltaSeconds + Acceleration * DeltaSeconds * DeltaSeconds / 2
--     self.CurrentVelocity[AxisName] = Speed + DeltaSeconds * Acceleration
--     return NextAxisLocation + AxisLocation
-- end

function Component:PlayMontage(Mesh, MontagePath, SectionName, Callback, ExcuteFnishOnlyWhenCompelete)
    self.MontToPlay = LoadObject(MontagePath)
    if not self.MontToPlay then
        return
    end
    local AnimInstance = Mesh:GetAnimInstance()
    local Montage = AnimInstance:GetCurrentActiveMontage()
    if not Callback then
        Callback = {}
    end
    local MontParam = 
    {
        OnCompleted = Callback["OnCompleted"],
        OnBlendOut = Callback["OnBlendOut"],
        OnInterrupted = Callback["OnInterrupted"],
        OnNotifyBegin = Callback["OnNotifyBegin"],
        OnNotifyEnd = Callback["OnNotifyEnd"],
        ExcuteFnishOnlyWhenCompelete = ExcuteFnishOnlyWhenCompelete,
        StartSec = SectionName
    }
    if self.MontageProxyInst then
        AnimInstance:Montage_JumpToSection(SectionName, Montage)
        self:UpdateMontageProxy(MontParam)
    else
        MiscUtils.PlayMontageBySkeletaMesh(self, Mesh,  self.MontToPlay, MontParam)
    end
    -- MiscUtils.PlayMontageBySkeletaMesh(self, Mesh,  self.MontToPlay, MontParam)
end

function Component:UpdateMontageProxy(PlayParam)
    self:CleanMontPorxy()
    local MontCallbackProxy = self.MontageProxyInst
    local OnCompleted = PlayParam.OnCompleted
	MontCallbackProxy.OnCompleted:Add(self, PlayParam.OnCompleted)

    if PlayParam.ExcuteFnishOnlyWhenCompelete then
    	OnCompleted = nil
    end
    local BlendOutFunc = PlayParam.OnBlendOut
	if not PlayParam.OnBlendOut then
		BlendOutFunc = OnCompleted
	end
    MontCallbackProxy.OnBlendOut:Add(self, BlendOutFunc)

	local InterruptedFunc = PlayParam.OnInterrupted
    if not PlayParam.OnInterrupted then
		InterruptedFunc = OnCompleted
	end
    MontCallbackProxy.OnInterrupted:Add(self, InterruptedFunc)
    if PlayParam.OnNotifyBegin then 
    	MontCallbackProxy.OnNotifyBegin:Add(self, PlayParam.OnNotifyBegin)
	end
	local EndFunc = PlayParam.OnNotifyEnd
    if not PlayParam.OnNotifyEnd then
		EndFunc = OnCompleted
	end
    MontCallbackProxy.OnNotifyEnd:Add(self, EndFunc)
end

return Component