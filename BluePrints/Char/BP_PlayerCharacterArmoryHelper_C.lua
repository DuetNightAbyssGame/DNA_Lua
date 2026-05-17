--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class("BluePrints.Common.TimerMgr")

--function M:Initialize(Initializer)
--end

--function M:UserConstructionScript()
--end

function M:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
    self.ArmoryLocation = GlobalArmoryLocations or {}
end

function M:UpdatePPSetting(PPSettingType)
    if(PPSettingType == 0)then
        self.Camera.PostProcessSettings = self.PPSetting_Default
    elseif(PPSettingType == 1)then
        self.Camera.PostProcessSettings = self.PPSetting_PreviewCommon
    elseif(PPSettingType == 2)then
        self.Camera.PostProcessSettings = self.PPSetting_PreviewCommon
    end
end

function M:ClearPPSetting()
    self.Camera.PostProcessSettings.WeightedBlendables.Array:Clear()
end

--function M:ReceiveTick(DeltaSeconds)
--end

--function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function M:ReceiveActorBeginOverlap(OtherActor)
--end

--function M:ReceiveActorEndOverlap(OtherActor)
--end

function M:SetCameraStartTrans(StartTransform,FOV,Player)
    local CameraMgr = UGameplayStatics.GetPlayerCameraManager(self,0)
    self.RecoverEndTransform = FTransform()
    self.RecoverEndTransform.Translation = CameraMgr:GetCameraLocation()
    self.RecoverEndTransform.Rotation = CameraMgr:GetCameraRotation():ToQuat()
    StartTransform = StartTransform or self.RecoverEndTransform
    self.OriginalFOV = FOV
    if(not self.OriginalFOV)then
        self.OriginalFOV = CameraMgr:GetFOVAngle()
    end
    self:SetFOV(self.OriginalFOV)
    if Player and self.Player ~= Player and Player.Mesh then
        --self.OriginalRootTrans = Player.Mesh:GetSocketTransform('Root',ERelativeTransformSpace.RTS_World)
        self.OriginalRootTrans = Player.Mesh:K2_GetComponentToWorld()
    end
    self.Player=Player
    self.ViewActor = Player
    self.EndPos,self.EndRot=UE4.UKismetMathLibrary.BreakTransform(StartTransform)
    self.StartPos = StartTransform.Translation
    self.EnableCameraScrolling = false
    self:CalcCircle()
    self.Camera:K2_SetWorldTransform(StartTransform,false,nil,false)
    self:OnCameraRotated()
    self:OnCameraZoom()
    local CurRot = self.Player and self.Player:K2_GetActorRotation() or self.EndRot
    self:SetOriginalRotation(CurRot)
    self:SetTickableWhenPaused(true)
    -- local Controller = UGameplayStatics.GetPlayerController(self,0)
    -- self.bShouldControllerPerformFullTickWhenPaused = Controller.bShouldPerformFullTickWhenPaused
    -- Controller.bShouldPerformFullTickWhenPaused = true
end

function M:SetCameraStartInfo(Location,Rotation,FOV)
    if(not self.ViewActor)then
        return
    end
    local CameraMgr = UGameplayStatics.GetPlayerCameraManager(self,0)
    self.RecoverEndTransform = FTransform()
    self.RecoverEndTransform.Translation = CameraMgr:GetCameraLocation()
    self.RecoverEndTransform.Rotation = CameraMgr:GetCameraRotation():ToQuat()
    self.OriginalFOV = FOV
    if(not self.OriginalFOV)then
        self.OriginalFOV = CameraMgr:GetFOVAngle()
    end
    self.EndPos,self.EndRot=Location,Rotation
    self.StartPos = Location
    self.EnableCameraScrolling = false
    self:CalcCircle()
    self:SetTickableWhenPaused(true)
end

function M:SetOriginalRotation(Rotator)
    self.OriginalRotation = FRotator(Rotator.Pitch,Rotator.Yaw,Rotator.Roll)
end

function M:OnRoleChanged()
    self:SetViewActorRotation(self.OriginalRotation)
    if(self.Player)then
        --self.OriginalRootTrans = self.Player.Mesh:GetSocketTransform('Root',ERelativeTransformSpace.RTS_World)
        self.OriginalRootTrans = self.Player.Mesh:K2_GetComponentToWorld()
    end
end

---开始相机动画,参数都是相对位置
function M:TransformCamera(EndLocation,EndRotation,Duration,Ease,StartLocation,StartRotation)
    if(not self.ViewActor)then
        return
    end
    self:ResetStart(StartLocation,StartRotation)
    local trans = self.OriginalRootTrans or self.ViewActor.RootComponent:K2_GetComponentToWorld()
    self.EndPos=UE4.UKismetMathLibrary.TransformLocation(trans, EndLocation)
    self.EndRot=UE4.UKismetMathLibrary.TransformRotation(trans, EndRotation)
    self:CalcCircle()
    self.Duration = Duration or 0
    self:Move(function()
        self.BaseScrollLocation = self.Camera:K2_GetComponentLocation()
        self:UpdateScrolDirection()
    end,Ease or 14)
    return self.StartPos,self.EndPos
end

---根据起始点和终点计算绕点旋转需要的参数
function M:CalcCircle()
    local StartDiff = self:GetViewActorLocation() - self.StartPos
    local EndDiff = self:GetViewActorLocation() - self.EndPos
    self.CenterOfCircle = self:GetViewActorLocation()
    if(StartDiff:Size() > EndDiff:Size())then
        self.CenterOfCircle.Z = self.EndPos.Z
    else
        self.CenterOfCircle.Z = self.StartPos.Z
    end
    self.StartArmLength=UE4.UKismetMathLibrary.Vector_Distance(self.StartPos,self.CenterOfCircle)
    self.StartForward=UE4.UKismetMathLibrary.FindLookAtRotation(self.CenterOfCircle,self.StartPos)
    self.EndArmLength=UE4.UKismetMathLibrary.Vector_Distance(self.EndPos,self.CenterOfCircle)
    self.EndForward=UE4.UKismetMathLibrary.FindLookAtRotation(self.CenterOfCircle,self.EndPos)
end

---恢复到角色相机
function M:RecorverCamera(Obj_OnRecoverEnd,OnRecoverEnd,DurationTime,StartTransform,RelativeLocation,RelativeRotation)
    self:SetViewActorRotation(self.OriginalRotation)
    self:ResetStart(RelativeLocation,RelativeRotation,StartTransform or self.OriginalRootTrans)
    self.Duration=DurationTime or 0
    self.EndPos,self.EndRot=UE4.UKismetMathLibrary.BreakTransform(self.RecoverEndTransform)
    self:CalcCircle()
    local OnCompleteFunc = function()
        if(OnRecoverEnd)then
            OnRecoverEnd(Obj_OnRecoverEnd)
        end
    end
    if(self.Duration <= 0)then
        OnCompleteFunc()
    else
        self:Move(OnCompleteFunc,6)
        self:StartFOVAnim(self.OriginalFOV,0,6)
    end
end

---实际开始移动相机
function M:Move(CompleteFunc,Ease)
    local Duration = self.Duration
    if(Duration <= 0)then
        Duration = 0.01
    end
    local yawRotateRate=0
    local needLerpYaw=false
    self:YawNormalize(self.StartRot)
        self:YawNormalize(self.EndRot)
        self:YawNormalize(self.StartForward)
        self:YawNormalize(self.EndForward)
        local isRight=true
        local sub=math.abs((self.EndForward-self.StartForward).Yaw)
        if sub<180 then
            if sub>90 then
                needLerpYaw=true
                if self.StartForward.Yaw<self.EndForward.Yaw then
                    isRight=true
                else
                    isRight=false
                end
            end
        else
            sub=360-sub
            if sub>90 then
                needLerpYaw=true
                if self.StartForward.Yaw<self.EndForward.Yaw then
                    isRight=false
                else
                    isRight=true
                end
            end
        end
        if not isRight  then--逆时针
            if (self.EndRot.Yaw>self.StartRot.Yaw) then
                yawRotateRate=-(360-(self.EndRot.Yaw-self.StartRot.Yaw))/Duration
            else
                yawRotateRate=(self.EndRot.Yaw-self.StartRot.Yaw)/Duration
            end
        else--顺时针
            if (self.EndRot.Yaw>self.StartRot.Yaw) then
                yawRotateRate=(self.EndRot.Yaw-self.StartRot.Yaw)/Duration
            else
                yawRotateRate=(360+(self.EndRot.Yaw-self.StartRot.Yaw))/Duration
            end
        end
    if(self.LTweenHandle_Scroll and IsValid(self.LTweenHandle_Scroll))then
        ULTweenBPLibrary.KillIfIsTweening(self,self.LTweenHandle_Scroll,true)
    end
    if(self.LTweenHandle and IsValid(self.LTweenHandle))then
        ULTweenBPLibrary.KillIfIsTweening(self,self.LTweenHandle,true)
    end
    local CameraTransByLerpValue = function(value)
        local armLength=UE4.UKismetMathLibrary.Lerp(self.StartArmLength,self.EndArmLength,value)
        local armForward=UE4.UKismetMathLibrary.RLerp(self.StartForward,self.EndForward,value,true)
        local temp=self.CenterOfCircle+UE4.UKismetMathLibrary.Multiply_VectorFloat(UE4.UKismetMathLibrary.GetForwardVector(armForward),armLength)
        local lerpRot=UE4.UKismetMathLibrary.RLerp(self.StartRot,self.EndRot,value,true)
        if needLerpYaw then
        lerpRot.Yaw=self.StartRot.Yaw+yawRotateRate*value*Duration
        end
        self.Camera:K2_SetWorldLocationAndRotation(temp,lerpRot,false,nil,false)
        self:OnCameraRotated()
        self:OnCameraZoom()
    end
    if(self.Duration <= 0)then
        CameraTransByLerpValue(1)
        if(CompleteFunc)then
            CompleteFunc()
        end
        return
    end
    self.LTweenHandle= UE4.ULTweenBPLibrary.FloatTo(self,{self,function(_,value)
        CameraTransByLerpValue(value)
    end},0,1,Duration,0,Ease)
    local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.LTweenHandle)
    if(LTweenActor)then
        LTweenActor:SetTickableWhenPaused(true)
    end
    self.LTweenHandle:OnComplete({self,function()
        if(CompleteFunc)then
            CompleteFunc()
        end
    end})
    if(self.LTweenHandle_Scroll and IsValid(self.LTweenHandle_Scroll))then
        ULTweenBPLibrary.KillIfIsTweening(self,self.LTweenHandle_Scroll,true)
    end
end



---重置开始移动的位置和旋转
---@param RelativeLocation FVector 相对于Transform的位置
---@param RelativeRotation FRotator 相对于Transform的旋转
---@param Transform FTransform 用于计算相对位置与旋转
function M:ResetStart(RelativeLocation,RelativeRotation,Transform)
    local trans = Transform or self.ViewActor.RootComponent:K2_GetComponentToWorld()
    if (RelativeLocation) then
        self.StartPos = UE4.UKismetMathLibrary.TransformLocation(trans, RelativeLocation)
    else
        self.StartPos = (self.EnableCameraScrolling and self.Camera:K2_GetComponentLocation()) or self.EndPos
    end
    if (RelativeRotation) then
        self.StartRot = UE4.UKismetMathLibrary.TransformRotation(trans, RelativeRotation)
    else
        self.StartRot = (self.EnableCameraScrolling and self.Camera:K2_GetComponentRotation()) or self.EndRot
    end
end

function M:YawNormalize(Rotator)
    local yaw=math.fmod(Rotator.Yaw,360)
    if yaw <0 then
        yaw=yaw+360
    end
    Rotator.Yaw=yaw
end

---指针拖动时
function M:OnDragViewActor(DeltaMove)
    if(self.LTweenHandle and IsValid(self.LTweenHandle) or not self.ViewActor)then
        return
    end
    DeltaMove = DeltaMove or {X = 0}
    local CurRot = self:GetViewActorRotation()
    local Rotation = FRotator()
    Rotation.Yaw = CurRot.Yaw
    Rotation.Pitch = CurRot.Pitch
    Rotation.Roll = CurRot.Roll
    local LimitMaxYaw = UIUtils.IsMobileInput() and 20 or 100
    local DeltaMoveYaw = math.clamp(DeltaMove.X,-LimitMaxYaw,LimitMaxYaw)
    Rotation.Yaw = Rotation.Yaw - DeltaMoveYaw
    self:SetViewActorRotation(Rotation)
end

---设置鼠标滚轮滚动时相机位置的范围
function M:SetCameraScrollRange(ForwardLocation, BackwardLocation, Duration, Ease)
    self.DataForwardScrollLocation = ForwardLocation
    self.DataBackwardScrollLocation = BackwardLocation
    self.ScrollAnimDuration = Duration
    self.ScrollEase = Ease or 14
    self:UpdateScrolDirection()
end

function M:UpdateScrolDirection()
    if(not self.DataForwardScrollLocation or not self.BaseScrollLocation or not IsValid(self.ViewActor))then
        return
    end
    local trans= self.ViewActor.RootComponent:K2_GetComponentToWorld()
    if self.OriginalRootTrans then
        trans = self.OriginalRootTrans
    end
    self.ForwardScrollLocation = UE4.UKismetMathLibrary.TransformLocation(trans, self.DataForwardScrollLocation)
    self.BackwardScrollLocation = UE4.UKismetMathLibrary.TransformLocation(trans, self.DataBackwardScrollLocation)
    self.ForwardScrollDirection = self.ForwardScrollLocation - self.BaseScrollLocation
    self.ForwardScrollLength = self.ForwardScrollDirection:Size()
    self.ForwardScrollDirection:Normalize()
    self.BackwardScrollDirection = self.BackwardScrollLocation - self.BaseScrollLocation
    self.BackwardScrollLength = self.BackwardScrollDirection:Size()
    self.BackwardScrollDirection:Normalize()
    self.ScrollDirection = 0
    self.TargetScrollLength = 0
end

---鼠标滚轮滚动时
function M:OnScrolling(DeltaScroll)
    if(DeltaScroll == 0
    or not self.EnableCameraScrolling
    or (IsValid(self.LTweenHandle) and ULTweenBPLibrary.IsTweening(self,self.LTweenHandle))
    or not self.ForwardScrollLocation or not self.BaseScrollLocation)then
        return
    end
    if(self.LTweenHandle_Scroll and IsValid(self.LTweenHandle_Scroll))then
        ULTweenBPLibrary.KillIfIsTweening(self,self.LTweenHandle_Scroll,true)
    end
    local Speed = 20.0
    local EndValue
    self.TargetScrollLength = self.TargetScrollLength + DeltaScroll * Speed
    if(self.ScrollDirection == 0)then
        if(DeltaScroll > 0)then
            self.TargetScrollLength = math.clamp(self.TargetScrollLength,0,self.ForwardScrollLength)
            EndValue = self.BaseScrollLocation + self.ForwardScrollDirection * self.TargetScrollLength
            self.ScrollDirection = 1
        else
            self.TargetScrollLength = math.clamp(self.TargetScrollLength,-self.BackwardScrollLength,0)
            EndValue = self.BaseScrollLocation + self.BackwardScrollDirection * -self.TargetScrollLength
            self.ScrollDirection = -1
        end
    elseif(self.ScrollDirection > 0 )then
        self.TargetScrollLength = math.clamp(self.TargetScrollLength,0,self.ForwardScrollLength)
        EndValue = self.BaseScrollLocation + self.ForwardScrollDirection * self.TargetScrollLength
    else
        self.TargetScrollLength = math.clamp(self.TargetScrollLength,-self.BackwardScrollLength,0)
        EndValue = self.BaseScrollLocation + self.BackwardScrollDirection * -self.TargetScrollLength
    end
    if(self.TargetScrollLength == 0)then
        self.ScrollDirection = 0
    end
    self.LTweenHandle_Scroll = ULTweenBPLibrary.WorldPositionTo(self.Camera,EndValue,self.ScrollAnimDuration,0, self.ScrollEase)
    if(self.LTweenHandle_Scroll)then
        self.LTweenHandle_Scroll:OnUpdate({self,self.OnCameraScrolled})
    end
    local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.LTweenHandle_Scroll)
    if(LTweenActor)then
        LTweenActor:SetTickableWhenPaused(true)
    end
end

function M:OnCameraScrolled(InProgress)
    if(self.OnCameraZoom)then
        self:OnCameraZoom()
    end
end

---重置角色旋转
function M:ResetRotation()
    self:SetViewActorRotation(self.OriginalRotation)
end

function M:SetViewActorRotation(Rotation)
    if(self.ViewActor and Rotation)then
        self.ViewActor:K2_SetActorRotation(Rotation,false,nil,false)
    end
end

function M:GetViewActorRotation()
    return self.ViewActor and self.ViewActor:K2_GetActorRotation() or FRotator(0,0,0)
end

function M:GetViewActorLocation()
    return self.ViewActor and self.ViewActor:K2_GetActorLocation() or FVector(0,0,0)
end

function M:OpenArmoryTransformCheck()
    local player=UGameplayStatics.GetPlayerCharacter(self,0)
    self.ViewActor:K2_SetActorLocationAndRotation(player:K2_GetActorLocation(),player:K2_GetActorRotation(),false,nil,false)
    if not player:CharacterInTag('Falling') then
        local transform=player.RootComponent:K2_GetComponentToWorld()
        local capsuleRadius=player.CapsuleComponent.CapsuleRadius
        local capsuleHalfHeight=player.CapsuleComponent.CapsuleHalfHeight/2
        local exceptActors=TArray(AActor)
        exceptActors:Add(player)
        exceptActors:Add(self.ViewActor)
        local standardVector=FVector(800,0,0)
        local boxExtent=FVector(5,100,50)
        local axis=FVector(0,0,1)
        local traceHalfCount=10
        local rot=transform.Rotation:ToRotator().Yaw
        for i=1,traceHalfCount+1 do 
            local deg=(i-1)*180/traceHalfCount
            local targetVector=UKismetMathLibrary.RotateAngleAxis(standardVector,deg,axis)
            targetVector=UKismetMathLibrary.TransformLocation(transform,targetVector)
            local hitResult=FHitResult()
            local result= UKismetSystemLibrary.BoxTraceSingle(self,(transform.Translation+targetVector)/2,targetVector,boxExtent,
            FRotator(0,rot+deg,0),1,false,exceptActors,0,hitResult,true)
            -- FRotator(0,rot+deg,0),1,false,exceptActors,2,hitResult,true,UKismetMathLibrary.LinearColor_Red(),UKismetMathLibrary.LinearColor_Green(),5)
            local resultCap= UKismetSystemLibrary.CapsuleTraceSingle(self,transform.Translation,(transform.Translation+targetVector)/2,capsuleRadius,
            capsuleHalfHeight,1,false,exceptActors,0,hitResult,true)
            -- capsuleHalfHeight,1,false,exceptActors,2,hitResult,true,UKismetMathLibrary.LinearColor_Red(),UKismetMathLibrary.LinearColor_Green(),5)
            if (result or resultCap) and deg~=0 and deg~=180 then
                targetVector=UKismetMathLibrary.RotateAngleAxis(standardVector,-deg,axis)
                targetVector=UKismetMathLibrary.TransformLocation(transform,targetVector)
                local result1=UKismetSystemLibrary.BoxTraceSingle(self,(transform.Translation+targetVector)/2,targetVector,boxExtent,
                FRotator(0,rot-deg,0),1,false,exceptActors,0,hitResult,true)
                -- FRotator(0,rot-deg,0),1,false,exceptActors,2,hitResult,true,UKismetMathLibrary.LinearColor_Red(),UKismetMathLibrary.LinearColor_Green(),5)
                local resultCap1= UKismetSystemLibrary.CapsuleTraceSingle(self,transform.Translation,(transform.Translation+targetVector)/2,capsuleRadius,
                capsuleHalfHeight,1,false,exceptActors,0,hitResult,true)
                -- capsuleHalfHeight,1,false,exceptActors,2,hitResult,true,UKismetMathLibrary.LinearColor_Red(),UKismetMathLibrary.LinearColor_Green(),5)
                if not result1 and not resultCap1 then
                    self.ViewActor:K2_AddActorLocalRotation(FRotator(0,-deg,0),false,nil,false)
                    return self.ViewActor:GetTransform()
                end
            elseif not result and not resultCap then
                self.ViewActor:K2_AddActorLocalRotation(FRotator(0,deg,0),false,nil,false)
                return self.ViewActor:GetTransform()
            end
        end
    end
    local distance=nil
    local target=nil
    for _,armoryLocaction in pairs(self.ArmoryLocation) do
        if(IsValid(armoryLocaction))then
            local temp=UKismetMathLibrary.Vector_Distance(player:K2_GetActorLocation(),armoryLocaction:K2_GetActorLocation())
            if distance==nil or distance>temp then
                distance=temp
                target=armoryLocaction
            end
        end
    end
    player = self.ViewActor
    if target and distance<12800 then 
        local finalLoc=FVector(0,0,player.CapsuleComponent.CapsuleHalfHeight + 2.4)
        FVector.Add(finalLoc,target:K2_GetActorLocation())
        self.ViewActor:K2_SetActorLocationAndRotation(finalLoc,target:K2_GetActorRotation(),false,nil,false)
        return self.ViewActor:GetTransform()
    end
end

function M:StartFOVAnim(EndFOV,Duration,Ease,CompleteFunc)
    local CameraMgr = UGameplayStatics.GetPlayerCameraManager(self,0)
    if(not CameraMgr)then
        return
    end
    self.StartFOV = CameraMgr:GetFOVAngle()
    self.EndFOV = EndFOV
    if(IsValid(self.LTweenHandle_FOV))then
        ULTweenBPLibrary.KillIfIsTweening(self,self.LTweenHandle_FOV,false)
    end
    self.LTweenHandle_FOV = UE4.ULTweenBPLibrary.FloatTo(self,{self,function(_,value)
        local fov =UE4.UKismetMathLibrary.Lerp(self.StartFOV,self.EndFOV,value)
        self:SetFOV(fov)
        self.Camera:SetFieldOfView(fov)
    end},0,1,Duration or 0,0,Ease or 14)
    local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.LTweenHandle_FOV)
    if(LTweenActor)then
        LTweenActor:SetTickableWhenPaused(true)
    end
    if CompleteFunc then
        self.LTweenHandle_FOV:OnComplete({self,CompleteFunc})
    end
end

function M:SetFOV(FOV)
    self.Camera:SetFieldOfView(FOV)
end

function M:SetPreviewLevelActor(PreviewLevelActor)
    rawset(self,"PreviewLevelActor",PreviewLevelActor)
end

function M:GetPreviewLevelActor()
    return rawget(self,"PreviewLevelActor")
end

function M:StartPreviewBGAnimation(TargetLoc,Duration)
    local PreviewLevelActor = self:GetPreviewLevelActor()
    if(PreviewLevelActor and PreviewLevelActor.GetBGActor)then
        local BGActor = PreviewLevelActor:GetBGActor()
        if(BGActor)then
            local StartLoc = FVector(0,0,0)
            self.LTweenHandle_BGAnim = UE4.ULTweenBPLibrary.FloatTo(self,{self,function(_,value)
                local Loc = UKismetMathLibrary.VLerp(StartLoc,TargetLoc,value)
                BGActor:K2_SetActorRelativeLocation(Loc,false,nil,false)
            end},0,1,Duration,0,14)
            local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.LTweenHandle_BGAnim)
            if(LTweenActor)then
                LTweenActor:SetTickableWhenPaused(true)
            end
        end
    end
end

function M:SetPlayer(Player,DestroyOldPlayer)
    if(DestroyOldPlayer and self.Player ~= Player)then
        if(IsValid(self.Player))then
            if(self.Player.IsPlayer and self.Player:IsPlayer())then
                self.Player:ServerRemoveBattlePet()
            end
            self.Player:EMActorDestroy(EDestroyReason.Armory)
            self.Player:K2_DestroyActor()
        end
    end
    self.Player = Player
end

function M:SetViewActor(Actor)
    if(Actor)then
        if(Actor == self.Weapon)then
            self.ViewActor = self.WeaponArmoryHelper
        else
            self.ViewActor = Actor
        end
    else
        self.ViewActor = nil
    end
end

function M:GetViewActor()
    return self.ViewActor
end

function M:SetWeapon(Weapon,WeaponReflection)
    self.Weapon = Weapon
    self.WeaponReflection = WeaponReflection
    if(self.Weapon == nil)then
        self.WeaponTag = nil
        if(IsValid(self.WeaponArmoryHelper))then
            self.WeaponArmoryHelper:K2_DestroyActor()
            self.WeaponArmoryHelper = nil
        end
        if(IsValid(self.WeaponReflectionHelper))then
            self.WeaponReflectionHelper:K2_DestroyActor()
            self.WeaponReflectionHelper = nil
        end
        return
    end
    self:AttachWeaponToHelper(Weapon,self.WeaponArmoryHelper)
    if(WeaponReflection and self.WeaponReflectionHelper)then
        self:AttachWeaponToHelper(WeaponReflection,self.WeaponReflectionHelper)
    end
end

function M:AttachWeaponToHelper(Weapon,WeaponArmoryHelper)
    local Tags = Weapon:GetWeaponTags():ToTable()
    for key, value in pairs(Tags) do
        if(WeaponArmoryHelper[value])then
            local SceneComponents = TArray(USceneComponent)
            WeaponArmoryHelper[value]:GetChildrenComponents(true, SceneComponents)
            Weapon:K2_AttachToComponent(SceneComponents:GetRef(1))
            if(SceneComponents:Length() > 1 )then
                if(Weapon.ChildWeapon)then
                    Weapon.ChildWeapon:K2_AttachToComponent(SceneComponents:GetRef(2))
                    Weapon.ChildWeapon:K2_SetActorRelativeTransform(FTransform(),false,nil,false)
                end
                local AccessoriesLen = Weapon.Accessories:Length()
                if(AccessoriesLen > 0)then
                    Weapon.Accessories[1]:K2_AttachToComponent(SceneComponents:GetRef(2))
                    Weapon.Accessories[1]:K2_SetActorRelativeTransform(FTransform(),false,nil,false)
                end
            end
            break
        end
    end
end

function M:CreateOrGetWeaponHelper()
    if(not self.WeaponArmoryHelper or not IsValid(self.WeaponArmoryHelper))then
        self.WeaponArmoryHelper = self:CreateWeaponHelper()
    end
    return self.WeaponArmoryHelper
end

function M:CreateOrGetWeaponReflectionHelper()
    if(not self.WeaponReflectionHelper or not IsValid(self.WeaponReflectionHelper))then
        self.WeaponReflectionHelper = self:CreateWeaponHelper()
    end
    return self.WeaponReflectionHelper
end

function M:CreateWeaponHelper()
    local _Class = UE4.UClass.Load('/Game/UI/Blueprint/ArmoryWeapon.ArmoryWeapon')
    local WeaponArmoryHelper = self:GetWorld():SpawnActor(_Class, self:GetTransform(),UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    WeaponArmoryHelper:K2_SetActorRotation(FRotator(0,0,0),false,nil,false)
    return WeaponArmoryHelper
end

function M:TransformWeaponCamera()
    if(not self.WeaponTag)then
        return
    end
    local WeaponTag = self.WeaponTag
    local Distance = self.WeaponArmoryHelper.CamDistance:ToTable()[WeaponTag] or 0
    local ViewActorLocation = self:K2_GetActorLocation()
    local Rotation = UKismetMathLibrary.FindLookAtRotation(ViewActorLocation+self.WeaponArmoryHelper:GetActorRightVector(),ViewActorLocation)
    local Offset = UKismetMathLibrary.GetForwardVector(Rotation) * -Distance
    local Location = ViewActorLocation + Offset
    local TargetTrans = FTransform()
    TargetTrans.Translation = Location
    TargetTrans.Rotation = Rotation
    if(not self.OriginalRootTrans)then
        self.OriginalRootTrans = self:GetTransform()
        self:SetCameraStartInfo(Location,Rotation)
    end
    self:TransformCamera(Offset,Rotation,0.5)
    local MinDistance = self.WeaponArmoryHelper.CamDistance_Min:ToTable()[WeaponTag] or 0
    local MinLocation = UKismetMathLibrary.GetForwardVector(Rotation) * -MinDistance
    local MaxDistance = self.WeaponArmoryHelper.CamDistance_Max:ToTable()[WeaponTag] or 0
    local MaxLocation = UKismetMathLibrary.GetForwardVector(Rotation) * -MaxDistance
    self:SetCameraScrollRange(MinLocation, MaxLocation, 0.5)
    if(MinDistance ~= 0 or MaxDistance ~= 0)then
        self.EnableCameraScrolling = true
    end
end

function M:ReceiveEndPlay(...)
    self.Overridden.ReceiveEndPlay(self,...)
    self.ArmoryLocation = nil
    self:DestroyViewActorIfNeed()
end

function M:DestroyViewActorIfNeed()
    self:SetPlayer(nil,self.bNeedDestroyPlayerActor)
    self:SetWeapon(nil)
    self:SetViewActor(nil)
end

function M:BindViewTargetEvents(Events,Obj)
    Events = Events or {}
    self._OnEndViewTarget = Events.OnEndViewTarget
    self._OnBecomeViewTarget = Events.OnBecomeViewTarget
    self._OnAfterEndViewTarget = Events.OnAfterEndViewTarget
    self.ViewTargetEventObj = Obj
end

function M:ViewTarget()
    local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)
    if(not Controller)then
        return
    end
    if(Controller.PlayerCameraManager and not rawget(self,"bOnSetNewViewTargetBound"))then
        rawset(self,"bOnSetNewViewTargetBound",true)
        Controller.PlayerCameraManager.OnSetNewViewTarget:Add(self,self.OnCameraManagerSetNewViewTarget)
    end
    Controller:SetViewTargetWithBlend(self, 0, UE4.EViewTargetBlendFunction.VTBlend_Linear, 0, false)
end

function M:OnCameraManagerSetNewViewTarget(NewTarget)
    if(NewTarget ~= self)then
        if(self._OnAfterEndViewTarget)then
            self._OnAfterEndViewTarget(self.ViewTargetEventObj,NewTarget)
        end
    end
end

function M:DestroySelf()
    local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)
    if(Controller)then
        Controller.PlayerCameraManager.OnSetNewViewTarget:Remove(self,self.OnCameraManagerSetNewViewTarget)
    end
    self:K2_DestroyActor()
    DebugPrint("CY@ Armory Helper Destroyed")
end

function M:K2_OnEndViewTarget(PC)
    if(self._OnEndViewTarget)then
        self._OnEndViewTarget(self.ViewTargetEventObj,PC)
    end
end

function M:K2_OnBecomeViewTarget(PC)
    if(self._OnBecomeViewTarget)then
        self._OnBecomeViewTarget(self.ViewTargetEventObj,PC)
    end
end

function M:GetActorToRotate()
    if(self:GetPreviewLevelActor())then
        return self:GetPreviewLevelActor():GetGroundActor()
    end
end

return M
