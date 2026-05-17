local ECameraBlendFunc = {
    linear = 0,
    easeInQuad = 1,
    easeOutQuad = 2,
    easeInOutQuad = 3,
}

local ECameraComponentClass = {
    CameraComponent = 0,
    CineCameraComponent = 1,
}

local ECameraFocusMethod = {
    [0] = "DoNotOverride",
    [1] = "Manual",
    [2] = "Tracking",
    [3] = "Disable",
    [4] = "MAX",
}

local FeishuErrorTitle = "对话相机错误"

---@class TalkCameraManager_C
local TalkCameraManager_C = {}
---@param TalkContext TalkContext_C
---@param Player ACharacter
---@param PlayerController APlayerController
TalkCameraManager_C.New = function(TalkContext,Player,PlayerController)
    ---@type TalkCameraManager_C
    local Obj = setmetatable({}, {
        __index = TalkCameraManager_C
    })
    ---@type TalkContext_C
    Obj.TalkContext=TalkContext
    ---@type ACharacter
    Obj.Player = Player
    ---@type APlayerController
    Obj.PlayerController = PlayerController
    ---@type AAIController
    Obj.AIControllerForPlayer = nil
    ---@type BP_TalkPlayerPawn_C
    Obj.TalkPawn = nil
    ---@type AActor
    Obj.CineCamera = nil
    ---@type AActor
    Obj.CurrentCamera = nil
    ---@type AActor
    Obj.InteractiveActor = nil
    ---@type number
    Obj.BlendRunTime = 0
    ---@type string
    Obj.BlendType = nil
    ---@type number
    Obj.BlendTime = 0
    ---@type function
    Obj.Callback = nil
    ---@type table
    Obj.BlendParam = {}

    ---@type FVector
    Obj.CurrentCameraLocation = nil
    ---@type FVector
    Obj.TargetCameraLocation = nil
    ---@type FVector
    Obj.DeltaLocation = nil
    ---@type number
    Obj.TranslationTime = 0
    ---@type number
    Obj.TotalTranslationTime = 0
    ---@type FRotator
    Obj.CurrentCameraRotation = nil
    ---@type FRotator
    Obj.TargetCameraRotation = nil
    ---@type FVector
    Obj.TargetCameraForward = nil
    ---@type FRotator
    Obj.DeltaRotation = nil
    ---@type number
    Obj.RotationTime = 0
    ---@type number
    Obj.TotalRotationTime = 0
    ---@type boolean
    Obj.IsCameraTransforming = false
    ---@type boolean
    Obj.bUseFinalCameraBlend = false 
    ---@type FCameraBlendViewInfo
    Obj.StartCameraInfo = nil
    ---@type FCameraBlendViewInfo
    Obj.EndCameraInfo = nil

	Obj.PlayerAspectRatio = 16 / 9
    Obj.ConfiguredCameras = {}
    Obj.CameraConfigs = {}
    Obj.FinalCameraTranslationTimeInterval = 0.01666
    return Obj
end

local function InterpEaseIn(Alpha,Exp)
    local ModifiedAlpha = Alpha ^ Exp
    return ModifiedAlpha
end

local function InterpEaseOut(Alpha,Exp)
    local ModifiedAlpha = 1 - ((1 - Alpha) ^ Exp)
    return ModifiedAlpha
end

local function InterpEaseInOut(Alpha,Exp)
    if Alpha < 0.5 then
        Alpha = InterpEaseIn(Alpha*2,Exp)*0.5
    else
        Alpha = InterpEaseOut(Alpha*2-1,Exp)*0.5+0.5
    end
    return Alpha
end


---@param CameraBlendFuncType ECameraBlendFunc
function TalkCameraManager_C:CalculateBlendPct(CameraBlendFuncType)
    local Alpha = 0
    if self.TotalTranslationTime == 0 then
        Alpha = 1
    else
        Alpha = self.TranslationTime / self.TotalTranslationTime
    end
    local BlendExp = 2

    if CameraBlendFuncType == ECameraBlendFunc.linear then
        --nothing
    elseif CameraBlendFuncType == ECameraBlendFunc.easeInQuad then
        Alpha = InterpEaseIn(Alpha , BlendExp)
    elseif CameraBlendFuncType == ECameraBlendFunc.easeOutQuad then
        Alpha = InterpEaseIn(Alpha , 1 / BlendExp)
    elseif CameraBlendFuncType == ECameraBlendFunc.easeInOutQuad then
        Alpha = InterpEaseInOut(Alpha , BlendExp)
    end

    return Alpha
end

function TalkCameraManager_C:SwitchForceEnablePlayerFashionComponentDither(bEnable)
    --DebugPrint("TalkCameraManager_C:SwitchForceEnablePlayerFashionComponentDither", bEnable)
    if not IsValid(self.Player) then
        return
    end

    self.bEnablePlayerDither = bEnable
    local FC = self.Player:GetComponentByClass(UFashionComponent)
    if IsValid(FC) then
    	FC:ForceEnableDitherAlphaByTalk(bEnable)
    end
end

function TalkCameraManager_C:SwitchEnablePlayerDither(bEnable)
    DebugPrint("TalkCameraManager_C:SwitchEnablePlayerDither", bEnable)
    if not IsValid(self.Player) then
        return
    end

    local PCC = self.Player:GetComponentByClass(UPlayerCameraComponent)
    self:SwitchEnablePlayerCameraComponentDither(PCC, bEnable)
end

function TalkCameraManager_C:SwitchEnableTalkPawnDither(bEnable)
    DebugPrint("TalkCameraManager_C:SwitchEnableTalkPawnDither", bEnable)
    if not IsValid(self.TalkPawn) then
        return
    end
    local PCC = self.TalkPawn:GetComponentByClass(UPlayerCameraComponent)
    self:SwitchEnablePlayerCameraComponentDither(PCC, bEnable)
end

function TalkCameraManager_C:SwitchEnablePlayerCameraComponentDither(PCC, bEnable)
    if not IsValid(PCC) then
        return
    end
    if bEnable then
        PCC:EnableCameraDither()
    else
        PCC:DisableCameraDither()
    end
end

function TalkCameraManager_C:ReceiveTick(DeltaTime)
    if self.AIControllerForPlayer and self.PlayerController and self.bUseTalkPawn and self.bEnablePlayerDither then 
        local Rot = self.PlayerController:GetControlRotation()
        self.AIControllerForPlayer:SetControlRotation(Rot)
        self.AIControllerForPlayer.bSetControlRotationFromPawnOrientation = false
    end

    if self.SequenceCamera then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        local PCC = Player:GetComponentByClass(UPlayerCameraComponent)
        local Config = self:MakeConfigFromCamera(PCC)
        local FinalTrans = UE4.UKismetMathLibrary.TInterpTo(self.SequenceCamera:GetTransform(),PCC:K2_GetComponentToWorld(),DeltaTime,1)
        self.SequenceCamera:K2_SetActorTransform(FinalTrans, false, nil, false)
    end

    self:_CameraBreathe(DeltaTime)
end

---@param DeltaTime number
function TalkCameraManager_C:_CameraBreathe(DeltaTime)
    if (self.IsCameraTransforming and self:GetCurrentCamera() and not self.bBreathePaused) then
        if(self.bUseFinalCameraBlend) then
            self:_CameraBreathe_ByFinalCameraBlendConfig(DeltaTime)
        else
            self:_CameraBreathe_ByCameraTransformConfig(DeltaTime)
        end
    end
end

---@param DeltaTime number
function TalkCameraManager_C:_CameraBreathe_ByFinalCameraBlendConfig(DeltaTime)
    if not self.Stage then
        return
    end

    local BlendPct = self:CalculateBlendPct(self.ToFinalCameraBlendFuntion)
    UTalkFunctionLibrary.UpdateCameraByBlendViewInfo(self:GetCurrentCamera(),self.StartCameraInfo,self.EndCameraInfo,BlendPct,self.PlayerAspectRatio)
    self.TranslationTime = self.TranslationTime + DeltaTime

    if(self.TranslationTime >= self.TotalTranslationTime) then
        UTalkFunctionLibrary.UpdateCameraByBlendViewInfo(self:GetCurrentCamera(), self.StartCameraInfo, self.EndCameraInfo, 1, self.PlayerAspectRatio)
        self.IsCameraTransforming = false
        self.StartCameraInfo = nil
        self.EndCameraInfo = nil
        if self.FinalCameraBlendCallback then
            local FinalCameraBlendCallback = self.FinalCameraBlendCallback
            self.FinalCameraBlendCallback = nil
            FinalCameraBlendCallback()
        end
        return
    end
end

---@param DeltaTime number
function TalkCameraManager_C:_CameraBreathe_ByCameraTransformConfig(DeltaTime)
    self.IsCameraTransforming = false
    if (self.RotationTime < self.TotalRotationTime) then
        self.CurrentCameraRotation = self.CurrentCameraRotation + self.DeltaRotation * DeltaTime
        self.RotationTime           = self.RotationTime + DeltaTime
        self.IsCameraTransforming  = true
    end
    if (self.TranslationTime < self.TotalTranslationTime) then
        self.CurrentCameraLocation = self.CurrentCameraLocation + self.DeltaLocation * DeltaTime
        self.TranslationTime        = self.TranslationTime + DeltaTime
        self.IsCameraTransforming  = true
    end
    local LocalTrans = UE4.UKismetMathLibrary.MakeTransform(self.CurrentCameraLocation, self.CurrentCameraRotation, FVector(1, 1, 1))
    local FinalTrans = UE4.UKismetMathLibrary.ComposeTransforms(LocalTrans, self.Stage:GetTransform())
    self:GetCurrentCamera():K2_SetActorTransform(FinalTrans, false, nil, false)
    --print(_G.LogTag,self.CurrentCameraLocation,self.CurrentCameraRotation)
end


--TODO 
---@param Target AActor
function TalkCameraManager_C:GetActiveCameraComponent(Target, CameraClass)
    local RtnCameraComponent = nil
    local CameraComponents = Target:K2_GetComponentsByClass(CameraClass)
    for i = 1, CameraComponents:Length() do
        ---@type UCameraComponent
        local CameraComponent = CameraComponents:Get(i)
        if CameraComponent:IsActive() then
            RtnCameraComponent = CameraComponent
        end
    end
    return RtnCameraComponent
end

function TalkCameraManager_C:_StartCameraBreathe_FinalCameraConfig(CameraInfo, FinalCameraInfo, BlendDuration, Stage, CameraBlendCurve, FinalCameraBlendCallback)
    self.TotalTranslationTime = BlendDuration
    self.TranslationTime = 0
    self.IsCameraTransforming = true
    self.bUseFinalCameraBlend = true
    self.ToFinalCameraBlendFuntion = ECameraBlendFunc[CameraBlendCurve]
    self.Stage = Stage
    self.FinalCameraBlendCallback = FinalCameraBlendCallback


    local Trans,FocalLength,FocusDis,ConstraintAspectRadio,FocusMethod,CurrentAperture
    if CameraInfo then
        Trans,FocalLength,FocusDis,ConstraintAspectRadio,FocusMethod,CurrentAperture = 
            self:RetrieveCameraViewInfo(CameraInfo,self.Stage:GetTransform())
    else
        Trans,FocalLength,FocusDis,ConstraintAspectRadio,FocusMethod,CurrentAperture = 
            self:GetCurrentCameraInfo()
    end
    self.StartCameraInfo = UE4.UTalkFunctionLibrary.MakeCameraBlendViewInfo(Trans,FocalLength,
        FocusDis,ConstraintAspectRadio,FocusMethod,CurrentAperture)

    Trans,FocalLength,FocusDis,ConstraintAspectRadio,FocusMethod,CurrentAperture=
        self:RetrieveCameraViewInfo(FinalCameraInfo,self.Stage:GetTransform())
    self.EndCameraInfo = UE4.UTalkFunctionLibrary.MakeCameraBlendViewInfo(Trans,FocalLength,
        FocusDis,ConstraintAspectRadio,FocusMethod,CurrentAperture)

    if (self.TotalTranslationTime == 0) then
        self:ReceiveTick(0)
    end
end

function TalkCameraManager_C:_StartCameraBreathe_CameraTransformConfig(CameraTransform,TargetCameraActor, Stage)
    if(not CameraTransform or CameraTransform == "") then
        return
    end
    self.Stage = Stage
    self.IsCameraTransforming = true
    self.bUseFinalCameraBlend = false
    self.ToFinalCameraBlendFuntion = nil
    local List = Split(CameraTransform, ',')
    local AddRotation = UE4.FRotator(tonumber(List[1] or 0), tonumber(List[2] or 0), 0)
    local AngleSpeed = tonumber(List[3] or 4)
    local AddLocation = UE4.FVector(tonumber(List[4] or 0), tonumber(List[5] or 0), tonumber(List[6] or 0))
    local TranslationSpeed = tonumber(List[7] or 0)
    local CurrentTransfrom = TargetCameraActor:GetTransform()
    self.CurrentCameraLocation = CurrentTransfrom.Translation - self.Stage:GetTransform().Translation
    self.TargetCameraLocation = self.CurrentCameraLocation + AddLocation
    self.DeltaLocation = UE4.UKismetMathLibrary.Normal(self.TargetCameraLocation - self.CurrentCameraLocation) *
                            TranslationSpeed
    local Dis = UE4.UKismetMathLibrary.VSize(self.TargetCameraLocation - self.CurrentCameraLocation)
    self.TranslationTime = 0
    if (TranslationSpeed > 0) then
        self.TotalTranslationTime = Dis / TranslationSpeed
    else
        self.TotalTranslationTime = 0
    end

    self.CurrentCameraRotation = UE4.UKismetMathLibrary.Quat_Rotator(CurrentTransfrom.Rotation)
    self.TargetCameraRotation = self.CurrentCameraRotation + AddRotation
    local CurrentCameraForward = TargetCameraActor:GetActorForwardVector()
    TargetCameraActor:K2_SetActorRotation(self.TargetCameraRotation, false)
    self.TargetCameraForward = TargetCameraActor:GetActorForwardVector()
    TargetCameraActor:K2_SetActorRotation(self.CurrentCameraRotation, false)
    local DeltaUp = UE4.UKismetMathLibrary.Normal(UE4.UKismetMathLibrary.Cross_VectorVector(CurrentCameraForward,
        self.TargetCameraForward))
    local DeltaForward = UE4.UKismetMathLibrary.RotateAngleAxis(CurrentCameraForward, AngleSpeed, DeltaUp)
    self.DeltaRotation = UE4.UKismetMathLibrary.FindLookAtRotation(self.CurrentCameraLocation,
        self.CurrentCameraLocation + DeltaForward) - self.CurrentCameraRotation
    self.DeltaRotation.Roll = 0
    self.RotationTime = 0
    local TotalAngle = UE4.UKismetMathLibrary.DegAcos(CurrentCameraForward:Dot(self.TargetCameraForward))
    self.TotalRotationTime = TotalAngle / AngleSpeed
    DebugPrint("InitCameraTransformAnim", self.CurrentCameraLocation, self.TargetCameraLocation, self.DeltaLocation,
    self.CurrentCameraRotation, self.TargetCameraRotation, self.DeltaRotation, self.TotalRotationTime,
    self.TotalTranslationTime)
end

---@param TargetCameraActor AActor
---@param CameraTransform string
---@param CameraInfo string
---@param FinalCameraInfo string
---@param CameraBlendCurve string
---@param BlendDuration number
---@param Stage ATalkStage
function TalkCameraManager_C:StartCameraBreathe(TargetCameraActor, CameraTransform, CameraInfo,
    FinalCameraInfo, CameraBlendCurve, BlendDuration, Stage)
    if (TargetCameraActor == nil) then
        return
    end
    
    self.bBreathePaused = false
    if(CameraInfo and FinalCameraInfo) then
        self:_StartCameraBreathe_FinalCameraConfig(CameraInfo, FinalCameraInfo, BlendDuration, Stage, CameraBlendCurve)
    else
        self:_StartCameraBreathe_CameraTransformConfig(CameraTransform, TargetCameraActor, Stage)
    end
end

function TalkCameraManager_C:PauseCameraBreathe(bPause)
    self.bBreathePaused = bPause
end

function TalkCameraManager_C:StopCameraBreathe()
    self.RotationTime = self.TotalRotationTime + 1
    self.TranslationTime = self.TotalTranslationTime + 1
    self.IsCameraTransforming = false
    self.bBreathePaused = false
    self.StartCameraInfo = nil
    self.EndCameraInfo = nil
    if self.FinalCameraBlendCallback then
        self.FinalCameraBlendCallback()
        self.FinalCameraBlendCallback = nil
    end
end

function TalkCameraManager_C:SkipCameraBreathe()
    self:ReceiveTick(self.TotalTranslationTime)
end

function TalkCameraManager_C:ClearCameraBreatheCallback()
    self.FinalCameraBlendCallback = nil
end

function TalkCameraManager_C:SwitchCameraRole(Target)
    if Target == "TalkPawn" then
        self:SwitchToTalkPawn()
    elseif Target == "Player" then
        self:SwitchToPlayer()
    end
end

function TalkCameraManager_C:CameraBlendToNew(Instigator, TargetCamera, BlendTime, TalkPawnSwitch, Callback,CurveInfo,EaseExp)
    self:StopCameraBreathe()
    local PlayerCameraManager = UE4.UGameplayStatics.GetPlayerCameraManager(GWorld.GameInstance, 0)
    local CurrentCameraLoc = PlayerCameraManager:GetCameraLocation()
    DebugPrint("TalkCameraManager_C:CameraBlendToNew", Instigator, TargetCamera, TargetCamera:GetName(),TargetCamera:K2_GetActorLocation(), CurrentCameraLoc, BlendTime, TalkPawnSwitch, Callback,CurveInfo,EaseExp)
    
    local OnBlendEndCallback = function()
        USequenceFunctionLibrary.SetViewTarget(self.PlayerController, TargetCamera)
        self:SetCurrentCamera(TargetCamera)
        self:SwitchCameraRole(TalkPawnSwitch)
        self.TalkContext:TryFireCallback(Callback)

		-- SetViewTarget 后，当帧镜头位置仍是之前镜头位置，可能残留多帧，会影响后续依赖镜头位置的操作，因此手动更新摄像机管理器
		local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
		UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(PlayerController)
		DebugPrint("TalkCameraManager_C:OnBlendEndCallback", UKismetSystemLibrary.GetFrameCount(), PlayerController:GetViewTarget():GetName(), PlayerController.PlayerCameraManager:GetCameraLocation())
    end

    if (BlendTime == -1 ) then
        OnBlendEndCallback()
    elseif (BlendTime == 0 ) then
        OnBlendEndCallback()
    else
        --优先使用Curve
        if(CurveInfo)then
            USequenceFunctionLibrary.SetViewTargetWithBlendByCurve(self.PlayerController, TargetCamera, BlendTime,CurveInfo.FOVCurveName,CurveInfo.CameraPositionCurveName,CurveInfo.CameraRotationCurveName)
        else
            if(EaseExp) then
                USequenceFunctionLibrary.SetViewTargetWithBlend(self.PlayerController, TargetCamera, BlendTime, UE4.EViewTargetBlendFunction.VTBlend_EaseInOut, EaseExp)
            else
                USequenceFunctionLibrary.SetViewTargetWithBlend(self.PlayerController, TargetCamera, BlendTime)
            end
        end

        -- self.TalkContext.TalkTimerManager:AddTimer(Instigator, BlendTime, false, nil, nil, OnBlendEndCallback)

        -- TalkContext.TalkTimerManager的Tick时间有问题，改用TimerMgr.lua里的AddTimer
        self.TalkContext:AddTimer(BlendTime, function()
            self.TalkContext:RemoveTimer(Instigator)
            OnBlendEndCallback()
        end,false,0,Instigator)
    end
end

--FreeSimple的BlendOut是特殊的
function TalkCameraManager_C:FreeSimpleCameraBlendOutTo(Callback, TalkTaskData, TargetCamera, BlendTime, EaseExp)
    DebugPrint("TalkCameraManager_C:FreeSimpleCameraBlendOutTo",BlendTime,EaseExp)
    -- 重置Camera动画
    self:StopCameraBreathe()

    local OverrideCallback = function()
        local Rot = self.AIControllerForPlayer:GetControlRotation()
        self:SwitchToPlayer()
        self.PlayerController:SetControlRotation(Rot)
        self.AIControllerForPlayer.bSetControlRotationFromPawnOrientation = false
        self.TalkContext:TryFireCallback(Callback)
    end

    if BlendTime == 0 then
        USequenceFunctionLibrary.SetViewTarget(self.PlayerController, TargetCamera)
        OverrideCallback()
    -- 其余情况，相机正常Blend
    else 
        local Rot = self.PlayerController:GetControlRotation()
        self.AIControllerForPlayer.bSetControlRotationFromPawnOrientation = false
        self.AIControllerForPlayer:SetControlRotation(Rot)

        if EaseExp and EaseExp > 0 then
            USequenceFunctionLibrary.SetViewTargetWithBlend(self.PlayerController, TargetCamera, BlendTime, UE4.EViewTargetBlendFunction.VTBlend_EaseInOut, EaseExp)
        else
            USequenceFunctionLibrary.SetViewTargetWithBlend(self.PlayerController, TargetCamera, BlendTime, nil, nil, true)
        end

        -- CameraMgr.OnCameraBlendComplete事件有时会因为丢失ViewTarget而失效，所以改用定时器
        self.TalkContext.TalkTimerManager:AddTimer("FreeSimpleCameraBlendOut", BlendTime, false, nil, nil, function()
            self.TalkContext.TalkTimerManager:ClearTimer("FreeSimpleCameraBlendOut")
            self:SetCurrentCamera(TargetCamera)
            OverrideCallback()
        end)
    end
end


function TalkCameraManager_C:KeepCurrentCamera()
    USequenceFunctionLibrary.SetViewTarget(self.PlayerController, self:GetCurrentCamera())
end

function TalkCameraManager_C:SetCurrentCamera(Camera)
    self.CurrentCamera = Camera
    --若当前有缓存的后处理信息，将其应用到新相机上
    if self.CachedPPInfo then
        self:SetPostProcess_Internal(self.CachedPPInfo)
    end
end

function TalkCameraManager_C:SwitchToTalkPawn()
    if (self.AIControllerForPlayer == nil) then
        self.AIControllerForPlayer = self.TalkContext:GetWorld():SpawnActor(ATalkAIController:StaticClass(),
            UE4.UKismetMathLibrary.MakeTransform(UE4.FVector(), UE4.FRotator(),
                UE4.FVector(1, 1, 1)))
    end
    DebugPrint("TalkCameraManager_C:SwitchToTalkPawn",self.PlayerController,self.Player,self.TalkPawn,self.AIControllerForPlayer,UE4.UKismetSystemLibrary.GetFrameCount())
    self.bUseTalkPawn = true
    self.PlayerController:SetLastPawn(self.Player)
    self.PlayerController:Possess(self.TalkPawn)
    self.AIControllerForPlayer:Possess(self.Player)
    local FC = self.Player:GetComponentByClass(UFashionComponent)
    if FC then
    	FC:ForceEnableDitherAlphaByTalk(true)
    end
end

function TalkCameraManager_C:SwitchToPlayer()
    if not self.bUseTalkPawn then
        return
    end
    DebugPrint("TalkCameraManager_C:SwitchToPlayer",UE4.UKismetSystemLibrary.GetFrameCount())
    
    if self.AIControllerForPlayer then
        self.AIControllerForPlayer:UnPossess(self.Player)
    end
    self.bUseTalkPawn = false
    -- self.PlayerController:K2_SetActorLocationAndRotation(self.Player:K2_GetActorLocation(),
    --     self.Player:K2_GetActorRotation(), true, nil, true)
    self.PlayerController:Possess(self.Player)
end

function TalkCameraManager_C:SetTalkPawnEnableChangeView(bEnable)
    DebugPrint("TalkCameraManager_C:SetTalkPawnEnableChangeView", bEnable)
    if (self.TalkPawn) then
        self.TalkPawn:SetEnableChangeView(bEnable)
    end
end

function TalkCameraManager_C:GetTalkPawn()
    local Loc = FVector(1)
    local Rot =  FRotator(0, 0, 0)
    if(IsValid(self.TalkPawn)) then
        self.TalkPawn:K2_DestroyActor()
    end
    local TalkPawnClass = LoadClass('/Game/BluePrints/Story/Talk/Base/BP_TalkPlayerPawn.BP_TalkPlayerPawn_C')
    self.TalkPawn = self.TalkContext:GetWorld():SpawnActor(TalkPawnClass,
        UE4.UKismetMathLibrary.MakeTransform(Loc,Rot, FVector(1)))
    return self.TalkPawn
end

function TalkCameraManager_C:GetTalkPawnNew(bUseProceduralCamera,ProceduralCameraId)
    local ProceduralParams
    if bUseProceduralCamera and ProceduralCameraId then
        local ProceduralCameraData = DataMgr.FreeCamera[ProceduralCameraId]
        ProceduralParams = {
            CameraControl = ProceduralCameraData.CameraControl,
            PushX = ProceduralCameraData.PushDistance,
            PullX = ProceduralCameraData.PullDistance,
            AngleThreshold = ProceduralCameraData.BlockRange,
            AngleAfterBlock = ProceduralCameraData.IfBlockThenRot,
            CameraHeight = ProceduralCameraData.CameraHeight,
            PivotOffset = ProceduralCameraData.PivotOffset,
            MinCameraDis = ProceduralCameraData.MinCameraDistance,
        }
    end
 
    local Loc, Rot = self:CalculateTalkPawnTrans((ProceduralParams or {}).PivotOffset)
    if not IsValid(self.TalkPawn) then
        local TalkPawnClass = LoadClass('/Game/BluePrints/Story/Talk/Base/BP_TalkPlayerPawn.BP_TalkPlayerPawn_C')
        self.TalkPawn = self.TalkContext:GetWorld():SpawnActor(TalkPawnClass, UE4.UKismetMathLibrary.MakeTransform(Loc,Rot, FVector(1)))
    end
    self.TalkPawn:K2_SetActorTransform(UE4.UKismetMathLibrary.MakeTransform(Loc,Rot, FVector(1)), false, nil, false)

    if(ProceduralParams) then
        local CameraActor = self:GetCurrentCamera()
        self.TalkContext:FreeSimpleProceduralCamera(CameraActor,self.TalkPawn,self.Player,self.InteractiveActor,
            ProceduralParams.PushX,ProceduralParams.PullX,ProceduralParams.AngleThreshold,ProceduralParams.AngleAfterBlock,
            ProceduralParams.CameraHeight)
        if(ProceduralParams.CameraControl == nil or ProceduralParams.CameraControl == false) then
            self.TalkPawn:SetDisableRotation(true)
        end
        local PlayerToOrigin = UE4.UKismetMathLibrary.VSize(self.Player:K2_GetActorLocation() - Loc)
        local MinSpringArmLength = PlayerToOrigin + ProceduralParams.MinCameraDis
        if self.TalkPawn.TalkSpringArm.BaseTargetArmLength < MinSpringArmLength then
            self.TalkPawn.TalkSpringArm.BaseTargetArmLength = MinSpringArmLength
        end
    end

    return self.TalkPawn
end

function TalkCameraManager_C:CalculateTalkPawnTrans(PivotOffset)
    local InteractiveActor = self.InteractiveActor or self.Player
    local StoryPlayable = InteractiveActor:Cast(UStoryPlayableInterface)
    local CameraLocationOffset = FVector(0, 0, PivotOffset or 0)
    if StoryPlayable then
        CameraLocationOffset = StoryPlayable:GetFreeCameraOffset() + FVector(0, 0, PivotOffset or 0)
    end
    
    local CameraLocation = (self.Player:K2_GetActorLocation() + InteractiveActor:K2_GetActorLocation()) / 2 + CameraLocationOffset

    local CameraRotation = FRotator(0, 0, 0)
    local CameraComp = self.Player:GetComponentByClass(UPlayerCameraComponent)
    if CameraComp then
        CameraRotation = UKismetMathLibrary.Conv_VectorToRotator(CameraLocation - CameraComp:K2_GetComponentLocation())
    end

    return CameraLocation, CameraRotation
end

function TalkCameraManager_C:GetCurrentCamera()
    return self.CurrentCamera or self.Player
end

function TalkCameraManager_C:GetCurrentCameraInfo()
    local CurrentCamera = self:GetCurrentCamera()
    if not CurrentCamera then
        return
    end
    DebugPrint("TalkCameraManager_C:GetCurrentCameraInfo", CurrentCamera:GetName())
    local CineCamera = CurrentCamera:GetCineCameraComponent()
    if not CineCamera then
        return
    end
    local Trans = CurrentCamera:GetTransform()
    local FocalLength = CineCamera.CurrentFocalLength
    local FocusDis = CineCamera.FocusSettings and CineCamera.FocusSettings.ManualFocusDistance or 0
    local ConstraintAspectRadio = CineCamera.bConstrainAspectRatio
    local FocusMethod = CineCamera.FocusSettings and CineCamera.FocusSettings.FocusMethod
    FocusMethod = FocusMethod and ECameraFocusMethod[FocusMethod] or "Disable"
    local CurrentAperture = CineCamera.CurrentAperture

    return Trans,FocalLength,FocusDis,ConstraintAspectRadio,FocusMethod,CurrentAperture
end

---@return ACineCameraActor
function TalkCameraManager_C:GetCineCamera()
    if not self.CineCamera then
        local CineCamera = self.TalkContext:GetWorld():SpawnActor(ACineCameraActor:StaticClass(), UE4.UKismetMathLibrary
            .MakeTransform(FVector(1), FRotator(0, 0, 0), FVector(1)), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
        local CameraComp = self:GetCameraComponent(CineCamera)
        self:MarkCameraIsConfigured(CameraComp, false)
        self:RecordCameraConfig(CameraComp, nil)
        CameraComp:SetConstraintAspectRatio(false)
        self.CineCamera = CineCamera
    end
    return self.CineCamera
end

function TalkCameraManager_C:ClearCineCamera()
    if IsValid(self.CineCamera) then
        local CameraComp = self:GetCameraComponent(self.CineCamera)
        self:MarkCameraIsConfigured(CameraComp, false)
        self:RecordCameraConfig(CameraComp, nil)
        self.CineCamera:K2_DestroyActor()
    end
    self.CineCamera = nil
end

local Split = function(str, p)
    local rt = {}
    string.gsub(str, '[^' .. p .. ']+', function(w)
        table.insert(rt, w)
    end)
    return rt
end

function TalkCameraManager_C:RetrieveCameraViewInfo(CameraInfo,AnchorTrans)
    local List = Split(CameraInfo, ',')
    local Loc = FVector(tonumber(List[1]), tonumber(List[2]), tonumber(List[3]))
    local Rot = FRotator(tonumber(List[5]), tonumber(List[6]), tonumber(List[4]))
    local LocTrans = UE4.UKismetMathLibrary.MakeTransform(Loc, Rot, FVector(1, 1, 1))
    local Trans = UE4.UKismetMathLibrary.ComposeTransforms(LocTrans,AnchorTrans )
    local FocalLength = tonumber(List[7])
    local FocusDis = tonumber(List[8])
    local ConstraintAspectRadio = List[9] == "true" and true or false
    local FocusMethod = List[10]
    local CurrentAperture = tonumber(List[11])
    return Trans,FocalLength,FocusDis,ConstraintAspectRadio,FocusMethod,CurrentAperture
end

function TalkCameraManager_C:GetDefaultCameraViewInfo()
    local Trans = self.Player:GetCameraComponent():K2_GetComponentToWorld()
    local FocalLength = 0
    local FocusDis = 0
    local ConstraintAspectRadio = false
    local FocusMethod = "Disable"
    local CurrentAperture = 0
    return Trans, FocalLength, FocusDis, ConstraintAspectRadio, FocusMethod, CurrentAperture
end

function TalkCameraManager_C:MakeSequenceCamera()
    self.SequenceCamera = self:GetCineCamera()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    local PCC = Player:GetComponentByClass(UPlayerCameraComponent)
    local Config = self:MakeConfigFromCamera(PCC)
    self.SequenceCamera:K2_SetActorTransform(PCC:K2_GetComponentToWorld(), false, nil, false)
    self:PasteConfigToCamera(self.SequenceCamera, Config)
end

function TalkCameraManager_C:ClearSequenceCamera()
    self.SequenceCamera = nil
end

---@param Stage ATalkStage
function TalkCameraManager_C:GetFixedCamera(CameraInfo, Stage, bUseDefaultIfCameraInfoIsNil, bUseDebugStage)
    bUseDefaultIfCameraInfoIsNil = bUseDefaultIfCameraInfoIsNil or false
    local CineCamera = self:GetCineCamera()

    local Trans, FocalLength, FocusDis, ConstraintAspectRadio, FocusMethod, CurrentAperture
    if (CameraInfo == nil and bUseDefaultIfCameraInfoIsNil) then
        if (UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self.TalkContext)) then
            ScreenPrint("镜头未配置，使用默认镜头配置！")
        end
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        local PCC = Player:GetComponentByClass(UPlayerCameraComponent)
        local Config = self:MakeConfigFromCamera(PCC)
        CineCamera:K2_SetActorTransform(PCC:K2_GetComponentToWorld(), false, nil, false)
        self:PasteConfigToCamera(CineCamera, Config)
        self:MarkCameraIsConfigured(self:GetCameraComponent(CineCamera), true)
        self:RecordCameraConfig(self:GetCameraComponent(CineCamera), Config)
    else
        if (CameraInfo == nil or CameraInfo == "") then
            local Message = "镜头信息未配置(Debug信息目前不太好加，之后补充)"
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Talk, FeishuErrorTitle, Message)
        else
            if Stage then
                Trans, FocalLength, FocusDis, ConstraintAspectRadio, FocusMethod, CurrentAperture = self:RetrieveCameraViewInfo(CameraInfo, Stage:GetTransform())
            elseif bUseDebugStage then
                local PlayerCameraManager = UE4.UGameplayStatics.GetPlayerCameraManager(GWorld.GameInstance, 0)
                local Loc = PlayerCameraManager:GetCameraLocation()
                local Rot = PlayerCameraManager:GetCameraRotation()
                Trans = FTransform(Loc,Rot)
                FocalLength, FocusDis, ConstraintAspectRadio, FocusMethod, CurrentAperture = 27,100000,false,0,2.8
            end
            CineCamera:K2_SetActorTransform(Trans, false, nil, false)
            UTalkFunctionLibrary.UpdateCameraSettingFromConfig(CineCamera, FocalLength, FocusDis, ConstraintAspectRadio,
                FocusMethod,CurrentAperture,self.PlayerAspectRatio)
            self:MarkCameraIsConfigured(self:GetCameraComponent(CineCamera), true)
            local Config = {
                ConstraintAspectRadio = ConstraintAspectRadio,
                FocalLength = FocalLength,
                AspectRatio = 1.7777778,
                SensorWidth = 23.76
            }
            self:RecordCameraConfig(self:GetCameraComponent(CineCamera), Config)
        end
    end
    DebugPrint("TalkCameraManager_C::GetFixedCamera", CineCamera and CineCamera:GetName())
    return CineCamera
end

function TalkCameraManager_C:MarkCameraIsConfigured(TargetCamera, bIsConfigured)
    if not TargetCamera then
        return
    end

    local Camera = self:GetCameraComponent(TargetCamera)
    if bIsConfigured then
        self.ConfiguredCameras[Camera] = true
    else
        if self.ConfiguredCameras[Camera] then
            self.ConfiguredCameras[Camera] = nil
        end
    end
end

function TalkCameraManager_C:IsConfiguredCamera(TargetCamera)
    local Camera = self:GetCameraComponent(TargetCamera)
    return self.ConfiguredCameras[Camera]
end

function TalkCameraManager_C:RecordCameraConfig(TargetCamera, Config)
    if not TargetCamera then
        return
    end
    local Camera = self:GetCameraComponent(TargetCamera)
    self.CameraConfigs[Camera] = Config
end

function TalkCameraManager_C:GetCameraConfig(TargetCamera)
    local Camera = self:GetCameraComponent(TargetCamera)
    return self.CameraConfigs[Camera]
end

function TalkCameraManager_C:GetFirstBoundObject(SequenceActor, Tag)
    local Binds = SequenceActor:FindNamedBindings(Tag)
    for i = 1, Binds:Num() do
        local Objects = SequenceActor.SequencePlayer:GetBoundObjects(Binds[i])
        for j = 1, Objects:Num() do
            return Objects[j]
        end
    end
end

function TalkCameraManager_C:MakeConfigFromCamera(Camera)
    local CameraComp = self:GetCameraComponent(Camera)
    local Config = {}

    if URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraComp, UCineCameraComponent) then
        Config = {
            FocalLength = CameraComp.CurrentFocalLength,
            AspectRatio = CameraComp.Filmback.SensorAspectRatio,
            SensorWidth = CameraComp.Filmback.SensorWidth,
            SensorHeight = CameraComp.Filmback.SensorHeight,
            FOV = CameraComp:GetHorizontalFieldOfView(),
            Class = ECameraComponentClass.CineCameraComponent
        }
    elseif URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraComp, UCameraComponent) then

        Config = {
            FOV = CameraComp.FieldOfView,
            AspectRatio = CameraComp.AspectRatio,
            Class = ECameraComponentClass.CameraComponent
        }
    end
    return Config
end

function TalkCameraManager_C:PasteConfigToCamera(Camera, Config)
    local CameraComp = self:GetCameraComponent(Camera)
    if URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraComp, UCineCameraComponent) then
        if Config.Class == ECameraComponentClass.CameraComponent then
            CameraComp:SetAspectRatio(Config.AspectRatio)
            CameraComp:SetFieldOfView(Config.FOV)
        elseif Config.Class == ECameraComponentClass.CineCameraComponent then
            CameraComp.SensorWidth = Config.SensorWidth
            CameraComp.SensorHeight = Config.SensorHeight
            CameraComp:SetCurrentFocalLength(Config.FocalLength)
        end
    elseif URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraComp, UCineCameraComponent) then
        CameraComp:SetAspectRatio(Config.AspectRatio)
        CameraComp:SetFieldOfView(Config.FOV)
    end
end

function TalkCameraManager_C:FixAndReturnFOV(CameraComponent, Config, NewAspectRatio)
    local InitFOV = Config.FOV 
    if not InitFOV then
        local SensorWidth = Config.SensorWidth or 23.76
        if Config.FocalLength then
            InitFOV = math.deg(2.0 * math.atan(SensorWidth / (2.0 * Config.FocalLength)))
        else
            InitFOV = 37.497356
        end
    end
    local InitFOVHalfTan = math.tan(math.rad(InitFOV / 2))
    local InitAspectRatio = 1.7777778
    local NewFOV = 2 * (math.atan(InitFOVHalfTan * NewAspectRatio / InitAspectRatio) * 180 / math.pi)

    return NewFOV
end

function TalkCameraManager_C:OnSequenceCameraSpawned(TargetActor)
    if not IsValid(TargetActor) then
        return 
    end
    local CameraComp = self:GetCameraComponent(TargetActor)
    if not IsValid(CameraComp) then
        return
    end

    if IsValid(TargetActor) then 
        self:MarkCameraIsConfigured(CameraComp, true)
        local Config = {
            FocalLength = CameraComp.CurrentFocalLength,
            AspectRatio = CameraComp.Filmback and CameraComp.Filmback.SensorAspectRatio,
            SensorWidth = CameraComp.Filmback and CameraComp.Filmback.SensorWidth,
            FOV = CameraComp.GetHorizontaFieldOfView and CameraComp.GetHorizontaFieldOfView() or CameraComp.FieldOfView,
        }
        self:RecordCameraConfig(CameraComp, Config)
    end
end

-- function TalkCameraManager_C:AdaptCineCameraConstraint(CameraActor)
--     local CameraComponent = self:GetCameraComponent(CameraActor)
--     if not IsValid(CameraComponent) then return end
--     CameraComponent:SetConstraintAspectRatio(false)
-- end

function TalkCameraManager_C:GetCameraComponent(CameraActor)
    local CameraComponent = nil
    if IsValid(CameraActor) then 
        if URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraActor, UCameraComponent) then
            CameraComponent = CameraActor
        elseif URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraActor, ACineCameraActor) then
            CameraComponent = CameraActor:GetCineCameraComponent()
        elseif URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraActor, ACameraActor) then
            CameraComponent = CameraActor.CameraComponent
        end
    end
    return CameraComponent
end

function TalkCameraManager_C:OnExceptionInterrupted()
    if self.bUseTalkPawn then
        self:SwitchToPlayer()
    end
	local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    if IsValid(PlayerController) and IsValid(self.Player) then
        USequenceFunctionLibrary.SetViewTarget(PlayerController, self.Player)
    end
end

function TalkCameraManager_C:SetPostProcess(MaterialPath)
    if MaterialPath == "None" then
        self:ClearPostProcess()
        return
    end
    local Material = LoadObject(MaterialPath)
    if not Material then
        local Message = "后处理材质不存在，路径："..MaterialPath
        local Title = "对话脚本Error：后处理材质不存在"
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Script, Title, Message)
        return
    end
    local MaterialType = Material:GetBaseMaterial()
    local DynamicInstance = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self, Material)
    --缓存当前后处理信息
    local PostProcessInfo = {
        MaterialPath = MaterialPath,
        MaterialType = MaterialType,
        DynamicInstance = DynamicInstance,
    }
    self:SetPostProcess_Internal(PostProcessInfo)
end

function TalkCameraManager_C:SetPostProcess_Internal(PostProcessInfo)
    if not PostProcessInfo then
        return
    end
    if self.CachedPPInfo and self.CachedPPInfo.MaterialPath ~= PostProcessInfo.MaterialPath then
        --当后处理效果改变时，清除当前所有Camera上的后处理效果
        self:ClearPostProcess()
    end
    self.CachedPPInfo = PostProcessInfo
    local MaterialType = PostProcessInfo.MaterialType
    local DynamicInstance = PostProcessInfo.DynamicInstance
    local CameraComponent = self:GetCameraComponent(self:GetCurrentCamera()) or self:GetCurrentCamera():GetComponentByClass(UPlayerCameraComponent)
    if not CameraComponent then
        DebugPrint("lhr@SetPostProcess: CameraComponent is nil", self:GetCurrentCamera() and self:GetCurrentCamera():GetName())
        return
    end
    self.ProcessedCameras = self.ProcessedCameras or {}
    if self.ProcessedCameras[CameraComponent] then
        --Camera已被后处理，return
        return
    end
    if CameraComponent.MaterialInstDynamicMaps then
        if CameraComponent.MaterialInstDynamicMaps:Find(MaterialType) then 
            CameraComponent.MaterialInstDynamicMaps:Remove(MaterialType)
        end
        CameraComponent.MaterialInstDynamicMaps:Add(MaterialType, DynamicInstance)
    end
    CameraComponent:AddOrUpdateBlendable(DynamicInstance, 1)
    self.ProcessedCameras[CameraComponent] = true
end

function TalkCameraManager_C:ClearPostProcess()
    self.ProcessedCameras = self.ProcessedCameras or {}
    for CameraComp, _ in pairs(self.ProcessedCameras) do
        self:ClearSingleCameraPP(CameraComp)
    end
    self.ProcessedCameras = {}
    self.CachedPPInfo = nil
end

function TalkCameraManager_C:ClearSingleCameraPP(CameraComponent)
    if not CameraComponent then
        return
    end
    if CameraComponent.ClearBlendables then
        CameraComponent:ClearBlendables()
    else
        if CameraComponent.PostProcessSettings then
            CameraComponent.PostProcessSettings.WeightedBlendables.Array:Clear()
        end
    end
    if CameraComponent.MaterialInstDynamicMaps then
        CameraComponent.MaterialInstDynamicMaps:Clear()
    end
end

function TalkCameraManager_C:ClearTalkCamera()
    DebugPrint("TalkCameraManager_C:ClearTalkCamera", self.CurrentCamera and self.CurrentCamera:GetName())
    self.CurrentCamera = nil

    self:ClearCineCamera()
    self:ClearPostProcess()
end

return TalkCameraManager_C
