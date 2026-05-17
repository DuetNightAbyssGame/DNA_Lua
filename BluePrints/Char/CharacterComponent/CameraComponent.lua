local EMCache = require "EMCache.EMCache"
local SettingUtils = require "Utils.SettingUtils"
local CameraComponent = {}

function CameraComponent:OnCharacterReady()
    if(self.FromOtherWorld)then
        return
    end
    rawset(self, "CharSpringArmComponent",self.CharSpringArmComponent)
    rawset(self, "CameraRotationComponent",self.CameraRotationComponent)
    rawset(self, "CharCameraComponent",self.CharCameraComponent)
    self.CharSpringArmComponent:InitComponent()
    self.CameraRotationComponent:InitComponent()

    self:EnableAutoResetCameraPitch(EMCache:Get("CameraBack") or "Enable")
    
    
    local DefaultSpringArmRate = EMCache:Get("SpringArmRate")
    if not DefaultSpringArmRate then
        if self.UIModePlatform == "PC" then
            DefaultSpringArmRate = DataMgr.Option["SpringArmRate"].DefaultValue / DataMgr.Option["SpringArmRate"].ScrollMappingScale
        else
            DefaultSpringArmRate = DataMgr.Option["SpringArmRate"].DefaultValueM / DataMgr.Option["SpringArmRate"].ScrollMappingScale     
        end
    end
    self:SetDefaultSpringArmRate(DefaultSpringArmRate)
    self:SetCameraYawFollow()
    --self:InitAspectAndFOV()

    rawset(self, "MaxDistance_LockOn",4000)     --锁定的最大距离
    rawset(self, "MaxTime_LockOnObscured",2)    --被遮挡超过此时间解除锁定
    -- self.AngleWeigh = 10                     --预锁定角度权重
    -- self.DistanceWeigh = 10                  --预锁定距离权重

    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        rawset(self,"IsPlayerCameraUnlock",false)
    else
        rawset(self,"IsPlayerCameraUnlock",true)
    end

end

function CameraComponent:EnableAutoResetCameraPitch(Method)
    self.CameraRotationComponent:EnableAutoResetCameraPitch(UE4.EResetPitchMethod[Method] or 0)
end

function CameraComponent:SetDefaultSpringArmRate(Value)
    self.DefaultSpringArmRate = Value
    self.SpringArmRate = Value
    local BaseTargetArmLength,  BaseSocketOffset = self:SetCameraSpringRate(self.DefaultSpringArmRate)
    self:SetBaseTargetArmLengthForReset(BaseTargetArmLength)
    self:SetBaseSocketOffsetForReset(BaseSocketOffset)
    self:ResetSpringArm();
    self:ResetSocketOffset();
end

function CameraComponent:SetBaseTargetArmLengthForReset(ArmLength)
    self.CharSpringArmComponent.BaseSpringArmForReset = ArmLength
    self.CharSpringArmComponent.MouseWheelTargetArmLength = ArmLength
end

function CameraComponent:SetBaseSocketOffsetForReset(SocketOffset)
    self.CharSpringArmComponent.BaseSocketOffsetForReset = SocketOffset
    self.CharSpringArmComponent.MouseWheelSocketOffset = SocketOffset
end

function CameraComponent:ApplyCameraShake(CameraShake, ShakeScale)
    local PlayerCameraManager = self.Controller and self.Controller.PlayerCameraManager
    if PlayerCameraManager == nil or UGameplayStatics.GetPlayerControllerID(self.Controller) ~= 0 then
        return
    end

    if self.CharSpringArmComponent:IsCameraOverlapped() then
        return
    end

    DebugPrint("TTT:Debug:ApplyCameraShake:定位Seq内相机抖动问题日志", CameraShake, ShakeScale)
    local CameraShakeCoef = math.max(0.0, tonumber(SettingUtils.GetEMCache("CameraShakeRange", nil, 1.0)) or 1.0)
    PlayerCameraManager:StartCameraShake(CameraShake, ShakeScale * CameraShakeCoef)
end

--function CameraComponent:AddCameraSpringArmInput(AxisValue)
--    -- 弹簧臂复位过程中不允许新的输入
--    if self.CharSpringArmComponent.bIsSpringArmResetting or self.CharSpringArmComponent.bIsSocketOffsetResetting then
--        return
--    end
--    self.CharSpringArmComponent:AddCameraSpringArmInput(AxisValue)
--end

--重置相机Pitch
function CameraComponent:ResetCameraPitch()
    if(IsValid(self.CameraRotationComponent)) then
        return self.CameraRotationComponent:ResetCameraPitch()
    end
end

--重置弹簧臂长度
function CameraComponent:ResetSpringArm()
    if(IsValid(self.CharSpringArmComponent)) then
        return self.CharSpringArmComponent:ResetSpringArm()
    end
end

function CameraComponent:ResetSocketOffset()
    if(IsValid(self.CharSpringArmComponent)) then
        return self.CharSpringArmComponent:ResetSocketOffset()
    end
end

-- 初始化时设置默认值
function CameraComponent:SetCameraYawFollow()
    self.CameraRotationComponent.bSwitchOnCameraFollow = EMCache:Get("CameraYawFollow")
    if self.CameraRotationComponent.bSwitchOnCameraFollow == nil then
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
            self.CameraRotationComponent.bSwitchOnCameraFollow = true
        elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            self.CameraRotationComponent.bSwitchOnCameraFollow = false
        end
    end
end

-- 设置里开启/关闭相机Yaw轴跟随的接口
function CameraComponent:SwitchCameraYawFollow(bSwitchOn)
    self.CameraRotationComponent.bSwitchOnCameraFollow = bSwitchOn
end

function CameraComponent:CalcTargetCtrlRotation(TargetPoint,bImmediately)
    local ControlRotation = self.Controller:GetControlRotation()
    local TargetCtrlRotation
    local CameraRotation = self.CharCameraComponent:K2_GetComponentRotation()
    local PitchOffset = CameraRotation.Pitch - ControlRotation.Pitch
    local TargetPointLookFrom = self:CalcTargetPointLookFrom(TargetPoint)
    TargetCtrlRotation = UE4.UKismetMathLibrary.FindLookAtRotation(TargetPointLookFrom,TargetPoint)
    if(not bImmediately)then
        local OnlyUsePitch = UE4.UKismetMathLibrary.FindLookAtRotation(self.CharCameraComponent:K2_GetComponentLocation(),TargetPoint)
        TargetCtrlRotation.Pitch = OnlyUsePitch.Pitch
    end
    TargetCtrlRotation.Pitch = TargetCtrlRotation.Pitch - PitchOffset
    if(not self:CheckCanRotateToTarget(TargetPoint))then
        TargetCtrlRotation.Pitch = UE4.UKismetMathLibrary.FClamp(TargetCtrlRotation.Pitch, self.CameraPitchLimitMin, self.CameraPitchLimitMax)
    end
    TargetCtrlRotation.Roll = 0
    return TargetCtrlRotation
end

function CameraComponent:CheckCanRotateToTarget(TargetPoint)
    local V = self.CharSpringArmComponent:K2_GetComponentLocation() - TargetPoint
    --如果目标、角色与Z轴形成的夹角小于0.5，那么认为不能旋转到
    local OutsideLen = math.abs(V.Z) * UE4.UKismetMathLibrary.DegTan(0.5)
    V.Z = 0
    local R = UE4.UKismetMathLibrary.VSize(V) 
    return R > (self.CharSpringArmComponent.SocketOffset.Y * OutsideLen)
end

function CameraComponent:CalcTargetPointLookFrom(TargetPoint)
    local PA = TargetPoint
    local PO = self.CharSpringArmComponent:K2_GetComponentLocation()
    local Radius = self.CharSpringArmComponent.SocketOffset.Y
    local AO = PO - PA
    AO.Z = 0 --不考虑Z轴
    local SizeAO = UE4.UKismetMathLibrary.VSize(AO)
    local CosAOB = Radius / SizeAO
    local AngleAOB = UE4.UKismetMathLibrary.DegAcos(CosAOB) --AngleAOB == 0 时，说明目标点在圆内，无切点
    local OBN = UE4.UKismetMathLibrary.RotateAngleAxis(UE4.UKismetMathLibrary.Normal(AO),AngleAOB * -1,FVector(0,0,1))
    local OB = OBN * Radius
    --切点
    local PB = OB + PO
    local CameraRotation = self.CharCameraComponent:K2_GetComponentRotation()
    local dir = UE4.UKismetMathLibrary.GetForwardVector(CameraRotation)
    local CurrentPointLookFrom = dir * self.CharSpringArmComponent.BaseTargetArmLength + self.CharCameraComponent:K2_GetComponentLocation()
    PB.Z = CurrentPointLookFrom.Z
    return PB
end

function CameraComponent:CalcDiffAngleInYaw(Forward, Target)
    return self:CalcVectorAngle(FVector(Forward.X, Forward.Y, 0), FVector(Target.X, Target.Y, 0))
end

function CameraComponent:CalcCurrentPitchAngle(Forward, Right)
    local HorizonVector = FVector(Forward.X, Forward.Y, 0)
    local AngleValue = self:CalcVectorAngle(Forward, HorizonVector)
    local CrossResult = Forward:Cross(HorizonVector)
    local DotResult = CrossResult:Dot(Right)
    if (DotResult >= 0) then
        return AngleValue
    else
        return -AngleValue
    end
end

function CameraComponent:StopCameraLookOrLockOnTarget()
    local rest = false
    if(self.CameraRotationComponent.IsCameraLookingToTarget)then
        self.CameraRotationComponent:StopCameraLookToTarget()
        rest =  true
    end
    return rest
end

function CameraComponent:StopAllAutoControlRotation()
    local rest = false
    if(self.CameraRotationComponent:GetIsControllerAutoRotating())then
        self.CameraRotationComponent:StopControlRotationLerp()
        rest = true
    elseif(self.CameraRotationComponent.IsCameraLookingToTarget)then
        self.CameraRotationComponent:StopCameraLookToTarget()
        rest = true
    end
    return rest
end

function CameraComponent:CalcCameraRotation()
    --现在不能获取正确的相机旋转，迭代前暂时使用此方法获取相机旋转
    local ControlRotation = self.Controller:GetControlRotation()
    local CameraRotation = self.CharCameraComponent:K2_GetComponentRotation()
    local PitchOffset = CameraRotation.Pitch - ControlRotation.Pitch
    local result = FRotator(0,0,0)
    result.Yaw = ControlRotation.Yaw
    result.Pitch = ControlRotation.Pitch + PitchOffset 
    return result
end

function CameraComponent:FlipCameraLockOnMonster()
    if(self:CharacterInTag("Shooting"))then
        return
    end
    if(self:StopCameraLookOrLockOnTarget())then
        return
    end
    local PreLockOnInfo = self.CameraRotationComponent.PreLockOnInfo
    if IsValid(PreLockOnInfo) then
        self.CameraRotationComponent.CurLockOnInfo = PreLockOnInfo
        local OnEnd = function()
            self.CameraRotationComponent.PreLockOnInfo = nil
            self.CameraRotationComponent.CurLockOnInfo = nil
        end
        self.CameraRotationComponent:CameraLookToTarget(PreLockOnInfo.Actor,PreLockOnInfo.Bone,self.CameraRotationComponent.Duration_LockOn,nil,false,self.CameraRotationComponent.MaxAngle_ReLockOn,self.MaxDistance_LockOn,self.MaxTime_LockOnObscured,true,true,OnEnd,OnEnd,OnEnd)
    else
        -- 如果没有可以锁的目标，镜头和摇臂回正
        self:ResetCameraAndSpringArm()
    end
end

-- 玩家无法锁定特定目标一段时间
function CameraComponent:CameraUnlockOnBySkill_Implementation(SourceEid, CantLockTime)
    if not IsClient(self) and not IsStandAlone(self) then
        return
    end
    if(SourceEid == 0 or not IsValid(self.CameraRotationComponent))then
        return
    end
    if self.IsPlayerCameraUnlock then
        self:BanCameraLockOnBySkill_Implementation(CantLockTime)
    else
        local CurLockOnInfo = self.CameraRotationComponent.CurLockOnInfo
        if( self.CameraRotationComponent.IsCameraLookingToTarget and CurLockOnInfo and CurLockOnInfo.Actor.Eid == SourceEid)then
            self.CameraRotationComponent:StopCameraLookToTarget()
        end
        
        self:SetTargetCantBeLockOn(SourceEid,true)
        if CantLockTime > 0 then
            local SetCanBeLockOn = function()
                self:SetTargetCantBeLockOn(SourceEid,false)
            end
            self:AddTimer(CantLockTime,SetCanBeLockOn,false,0,SourceEid.."SetCanBeLockOn", false)
        end
        
    end
end

-- 解除CameraUnlockOnBySkill此函数的禁用效果
function CameraComponent:CameraRelockOnBySkill_Implementation(SourceEid)
    if not IsClient(self) and not IsStandAlone(self) then
        return
    end
    if(SourceEid == 0)then
        return
    end
    if self.IsPlayerCameraUnlock then
        self.CameraRotationComponent.SetCanLockOn = true
        if self:IsExistTimer("BanCameraLockOn") then
            self:RemoveTimer("BanCameraLockOn")
        end
    else
        self:SetTargetCantBeLockOn(SourceEid,false)
        if self:IsExistTimer(SourceEid.."SetCanBeLockOn") then
            self:RemoveTimer(SourceEid.."SetCanBeLockOn")
        end
    end
end


-- 禁用玩家的锁定能力一段时间
function CameraComponent:BanCameraLockOnBySkill_Implementation(CantLockTime)
    if not IsClient(self) and not IsStandAlone(self) then
        return
    end
    local SetCanLockOn = function()
        self.CameraRotationComponent.SetCanLockOn = true
    end
    self.CameraRotationComponent.SetCanLockOn = false
    if self:IsExistTimer("BanCameraLockOn") then
        self:RemoveTimer("BanCameraLockOn")
    end
    if CantLockTime > 0 then
        self:AddTimer(CantLockTime,SetCanLockOn, false, 0, "BanCameraLockOn", false)
    end
end

function CameraComponent:SetTargetCantBeLockOn(Eid,CantBeLockOn)
    self.CameraRotationComponent:SetTargetCantBeLockOn(Eid,CantBeLockOn)
end

function CameraComponent:StartCameraKeepSightOnActor(Actor,KeepSightTime,CameraAxisLockType,Speed,OnFinish)
    self.CameraRotationComponent:StartCameraKeepSightOnActor(Actor,KeepSightTime,CameraAxisLockType,Speed,OnFinish)
end

function CameraComponent:FinishKeepSight()
    self.CameraRotationComponent:FinishKeepSight()
end

function CameraComponent:SetControlPitchLimit(MinPitch, MaxPitch, TimeToInterpSpeed, InterpSpeed)
    if not self.Controller then
        return
    end
    if self.IsSpawnedByMovieCaptureSequence then
        return
    end
    if not IsValid(self.CameraRotationComponent) or not IsValid(self.CameraControlComponent) then
        return
    end
    local CurrentRotation = self.Controller:GetControlRotation()
    local CurrentPitch = CurrentRotation.Pitch
    local CurrentYaw = CurrentRotation.Yaw
    if(CurrentPitch > 90 and CurrentPitch - 360 < MinPitch) then
        self.CameraRotationComponent:SetControlRotationAbsolute_Lerp(FRotator(MinPitch, CurrentYaw, 0), TimeToInterpSpeed, InterpSpeed, false, function()
            self.CameraControlComponent:ModifyViewPitch(MinPitch, MaxPitch)
        end)
    elseif(CurrentPitch < 90 and CurrentPitch > MaxPitch) then
        self.CameraRotationComponent:SetControlRotationAbsolute_Lerp(FRotator(MaxPitch, CurrentYaw, 0), TimeToInterpSpeed, InterpSpeed, false, function()
            self.CameraControlComponent:ModifyViewPitch(MinPitch, MaxPitch)
        end)
    else
        self.CameraControlComponent:ModifyViewPitch(MinPitch, MaxPitch)
    end
end

function CameraComponent:ResetPitchWhenBulletJump()
    if self.UIModePlatform ~= "Mobile" then
        return
    end
    local BulletJumpCamReset = EMCache:Get("BulletJumpCamReset")
    if not BulletJumpCamReset then
        return
    end
    self.CameraRotationComponent:ResetCameraPitch()
end

return CameraComponent
