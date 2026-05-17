local M = Class()

function M:OnInitializeEvent()
end

function M:UpdateCameraTransitionUI(Camera, Section, Input)
    DebugPrint("CameraTransitionTrackInstance:UpdateCamTransWidget", Camera, self.bInitialized)
    if not IsValid(Section) then
        return
    end

    if not IsValid(self.CamTransWidget) then
        self.CamTransWidget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/Sequence/WBP_Camera_Transition.WBP_Camera_Transition'")
        if not IsValid(self.CamTransWidget) then
            return
        end
        self.CamTransWidget:AddToViewport(-100)
    end
    self.CamTransWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    local SceneCaptureComp, CameraTexture = self:CaptureCameraScene(Camera, Section.IsDynamic)
    self.CaptureComp = SceneCaptureComp
    self.CamTransWidget:SetCameraTexture(CameraTexture)
    local TalkSequenceObject = UTrackInstanceFunctionLibrary.GetTalkSequenceObject(self, Input)
    if not TalkSequenceObject or not TalkSequenceObject:IsInSkip() then
       ---@NOTHING 
    end
end

function M:HideCameraTransitionUI()
    DebugPrint("CameraTransitionTrackInstance:HideCamTransWidget")
    if not IsValid(self.CamTransWidget) then return end
    self.CamTransWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:CaptureCameraScene(Camera, IsDynamic)
    if not IsValid(Camera) then
        return nil, nil
    end
    local GameUserSettings = UGameUserSettings.GetGameUserSettings()
    local ScreenResolution = GameUserSettings:GetScreenResolution()
    local Size = UWidgetLayoutLibrary.GetViewportSize(GWorld.GameInstance)
    local RenderTexture = UKismetRenderingLibrary.CreateRenderTarget2D(Camera,ScreenResolution.X,ScreenResolution.Y,
                                                                    UE4.ETextureRenderTargetFormat.RTF_RGBA8_SRGB)
    URuntimeCommonFunctionLibrary.RenderTarget2DResize(RenderTexture, Size.X, Size.Y)
    local SceneCaptureComponent = NewObject(USceneCaptureComponent2D, Camera)
    SceneCaptureComponent:K2_AttachToComponent(Camera.CameraComponent)
    SceneCaptureComponent:K2_SetRelativeTransform(FTransform(), false, nil, false)
    URuntimeCommonFunctionLibrary.RegisterComponent(SceneCaptureComponent)
    SceneCaptureComponent.TextureTarget = RenderTexture

    self:SetCaptureParams(SceneCaptureComponent, Camera.CameraComponent, IsDynamic)
    SceneCaptureComponent:CaptureScene()

    return SceneCaptureComponent, RenderTexture
end

function M:SetCaptureParams(SceneCaptureComp, CameraComp, IsDynamic)
    if not IsValid(SceneCaptureComp) or not IsValid(CameraComp) then
        return
    end

    --同步视觉参数
    SceneCaptureComp.FOVAngle = CameraComp.FieldOfView
    SceneCaptureComp.OrthoWidth     = CameraComp.OrthoWidth
    SceneCaptureComp.ProjectionType = CameraComp.ProjectionMode
    SceneCaptureComp.CaptureSource = ESceneCaptureSource.SCS_FinalToneCurveHDR

    --同步后处理
    SceneCaptureComp.PostProcessSettings = CameraComp.PostProcessSettings
    -- local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(self,UE4.AEnvironmentManager:StaticClass())
    -- if IsValid(EnvironmentManager) then
    --     SceneCaptureComp.PostProcessSettings.bOverride_ColorGradingIntensity = 1
    --     SceneCaptureComp.PostProcessSettings.bOverride_ColorGradingLUT = 1
    --     SceneCaptureComp.PostProcessSettings.ColorGradingIntensity = EnvironmentManager.PostProcess.Settings.ColorGradingIntensity
    --     SceneCaptureComp.PostProcessSettings.ColorGradingLUT = EnvironmentManager.PostProcess.Settings.ColorGradingLUT
    -- end

    SceneCaptureComp.bEnablePostProcessSettings = true
    SceneCaptureComp.PostProcessBlendWeight = 1.0

    --每帧渲染
    SceneCaptureComp.bCaptureEveryFrame = IsDynamic
    SceneCaptureComp.bCaptureOnMovement = false

    self:InitCaptureShowFlags(SceneCaptureComp)
end

function M:OnDestroyedEvent()
    if IsValid(self.CamTransWidget) then
        self.CamTransWidget:RemoveFromParent()
        self.CamTransWidget = nil
    end
    if IsValid(self.CaptureComp) then
        self.CaptureComp:K2_DestroyComponent(self.CaptureComp)
        self.CaptureComp = nil
    end
end

return M