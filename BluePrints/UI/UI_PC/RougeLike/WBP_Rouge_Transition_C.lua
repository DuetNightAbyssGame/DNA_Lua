--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_Transition_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
--     -- local material=self.Bg:GetDynamicMaterial()
--     local rt=UKismetRenderingLibrary.CreateRenderTarget2D(self)
--     local size=UWidgetLayoutLibrary.GetViewportSize(self)
--     URuntimeCommonFunctionLibrary.RenderTarget2DResize(rt,size.X,size.Y)
--     -- self.Image_40:SetBrushResourceObject(rt)
--     -- material:SetTextureParameterValue('Pic01',rt)
--     -- material:SetTextureParameterValue('Pic02',rt)
--     -- local rt=LoadObject('/Game/UI/UI_PNG/Story/Recall_Pictures/10011802.10011802')
--     -- if not rt then
--     --     PrintCrack('not rt')
--     --     return
--     -- end
--     local material=self.BG01:GetDynamicMaterial()
--     material:SetTextureParameterValue('MainTex',rt)
--     local material=self.Bg02_Add:GetDynamicMaterial()
--     material:SetTextureParameterValue('MainTex',rt)
--     local material=self.Bg03:GetDynamicMaterial()
--     material:SetTextureParameterValue('MainTex',rt)
--     local material=self.Bg04_Add:GetDynamicMaterial()
--     material:SetTextureParameterValue('MainTex',rt)

--     local player=UGameplayStatics.GetPlayerCharacter(self,0)
--     self.SceneCaptureComponent=NewObject(USceneCaptureComponent2D,player)
--     -- self.SceneCaptureComponent:SetComponentTickEnabled(true)
--     URuntimeCommonFunctionLibrary.RegisterComponent(self.SceneCaptureComponent)
--     self.SceneCaptureComponent:K2_AttachToComponent(player.CharCameraComponent)
--     self.SceneCaptureComponent:K2_SetRelativeTransform(FTransform(),false,nil,false)
--     self.SceneCaptureComponent.FOVAngle=player.CharCameraComponent.FieldOfView
--     self.SceneCaptureComponent.TextureTarget=rt
--     self.SceneCaptureComponent.CaptureSource=ESceneCaptureSource.SCS_FinalColorHDR
--     self.SceneCaptureComponent.bCaptureEveryFrame=false
--     self.SceneCaptureComponent.bCaptureOnMovement=false
--     self.SceneCaptureComponent:SetComponentTickEnabled(false)
--     self.SceneCaptureComponent:CaptureScene()

--     self:UnbindAllFromAnimationFinished(self.Change)
--     self:BindToAnimationFinished(self.Change,{self,self.Close})
--     self:PlayAnimation(self.Change)
-- end

function M:Construct()
    self:UnbindAllFromAnimationFinished(self.Change)
    self:BindToAnimationFinished(self.Change,{self,self.Close})
    self:PlayAnimation(self.Change)
    local player=UGameplayStatics.GetPlayerCharacter(self,0)
    player:AddDisableInputTag('RougeTransition')
end

function M:OnLoaded(SceneCaptureComponent,RenderTexture,IsBossRoom)
    -- self.ScreenPercentage = URuntimeCommonFunctionLibrary.GetConsoleScreenPercentage()
    -- UKismetSystemLibrary.ExecuteConsoleCommand(self, 'r.ScreenPercentage 100')
    -- local Scale = 1
    -- local IsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC"
    -- if IsMobile then
        -- local ViewPortSize = UWidgetLayoutLibrary.GetViewportSize(self)
        -- local UISize = UIManager(self):GetDesignedScreenSize(self)
        -- local ScreenPercentage, MaxViewSize = URuntimeCommonFunctionLibrary.GetConsoleScreenPercentageAndMaxViewSize()
        -- if MaxViewSize == 0 then
        --     Scale = ScreenPercentage / 100
        -- else
        --     Scale = math.min(MaxViewSize / ViewPortSize.Y, ScreenPercentage / 100)
        -- end
        -- DebugPrint('WBP_Rouge_Transition', ViewPortSize, UISize, ScreenPercentage, MaxViewSize, Scale)
    -- end
    if IsBossRoom then
        local material=self.BG01:GetDynamicMaterial()
        material:SetTextureParameterValue('MainTex',RenderTexture)
        -- if IsMobile and Scale ~= 1 then
        --     material:SetScalarParameterValue('Main_U_Tiling', Scale)
        --     material:SetScalarParameterValue('Main_V_Tiling', Scale)
        -- end
        local material=self.Bg02_Add:GetDynamicMaterial()
        material:SetTextureParameterValue('MainTex',RenderTexture)
        -- if IsMobile and Scale ~= 1 then
        --     material:SetScalarParameterValue('Main_U_Tiling', Scale)
        --     material:SetScalarParameterValue('Main_V_Tiling', Scale)
        -- end
        local material=self.Bg03:GetDynamicMaterial()
        material:SetTextureParameterValue('MainTex',RenderTexture)
        -- if IsMobile and Scale ~= 1 then
        --     material:SetScalarParameterValue('Main_U_Tiling', Scale)
        --     material:SetScalarParameterValue('Main_V_Tiling', Scale)
        -- end
        local material=self.Bg04_Add:GetDynamicMaterial()
        material:SetTextureParameterValue('MainTex',RenderTexture)
        -- if IsMobile and Scale ~= 1 then
        --     material:SetScalarParameterValue('Main_U_Tiling', Scale)
        --     material:SetScalarParameterValue('Main_V_Tiling', Scale)
        -- end
        AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_trans_boss", nil, nil)
    else
        local material=self.Bg:GetDynamicMaterial()
        material:SetTextureParameterValue('Pic01',RenderTexture)
        material:SetTextureParameterValue('Pic02',RenderTexture)
        AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_trans_normal", nil, nil)
        -- if IsMobile and Scale ~= 1 then
        --     material:SetVectorParameterValue('PicUV', FLinearColor(Scale, Scale, Scale, Scale))
        -- end
    end
    self.SceneCaptureComponent=SceneCaptureComponent
    self.SceneCaptureComponent.bCaptureEveryFrame=false
    self.SceneCaptureComponent:CaptureScene()
end

function M:OnChange()
    self.SceneCaptureComponent:SetComponentTickEnabled(true)
    self.SceneCaptureComponent.bCaptureEveryFrame=true
end

function M:Destruct()
    self.SceneCaptureComponent:SetComponentTickEnabled(false)
    self.SceneCaptureComponent.bCaptureEveryFrame=false
    local player=UGameplayStatics.GetPlayerCharacter(self,0)
    player:RemoveDisableInputTag('RougeTransition')
    -- UKismetSystemLibrary.ExecuteConsoleCommand(self, 'r.ScreenPercentage ' .. self.ScreenPercentage)
end

function M:Close()
    local RougeLikeManager = GWorld.RougeLikeManager
    if RougeLikeManager then
        RougeLikeManager:ShowEnterRoomToast()
    end
    M.Super.Close(self)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M
