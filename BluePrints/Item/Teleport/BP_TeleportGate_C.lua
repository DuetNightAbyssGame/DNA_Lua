--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TeleportGate_C
local BP_TeleportGate_C = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
})

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

function BP_TeleportGate_C:CommonInitInfo(Info)
    BP_TeleportGate_C.Super.CommonInitInfo(self, Info)
    self.OppositeSceneName = self.UnitParams["OppositeSceneName"]
    self.Opacity = self.UnitParams["Opacity"]

    self:InitUI()--蓝图事件
    --self:InitSceneCaptureComponent()
end

function BP_TeleportGate_C:InitSceneCaptureComponent()
    self.RenderTexture=UKismetRenderingLibrary.CreateRenderTarget2D(self)
    local size=UWidgetLayoutLibrary.GetViewportSize(self)
    URuntimeCommonFunctionLibrary.RenderTarget2DResize(self.RenderTexture,size.X,size.Y)

    local player=UGameplayStatics.GetPlayerCharacter(self,0)
    self.SceneCaptureComponent=NewObject(USceneCaptureComponent2D,player)
    self.SceneCaptureComponent:K2_AttachToComponent(player.CharCameraComponent)
    self.SceneCaptureComponent:K2_SetRelativeTransform(FTransform(),false,nil,false)
    URuntimeCommonFunctionLibrary.RegisterComponent(self.SceneCaptureComponent)
    self.SceneCaptureComponent.FOVAngle=player.CharCameraComponent.FieldOfView
    self.SceneCaptureComponent.TextureTarget=self.RenderTexture
    self.SceneCaptureComponent.CaptureSource=ESceneCaptureSource.SCS_FinalToneCurveHDR
    self.SceneCaptureComponent:SetComponentTickEnabled(false)
    self.SceneCaptureComponent.bCaptureEveryFrame=false
    self.SceneCaptureComponent.bCaptureOnMovement=false
end

function BP_TeleportGate_C:GetGateImage(ImageName)
    if not ImageName then
        DebugPrint("BP_TeleportGate_C: OppositeSceneName is nil")
        return
    end
    local RealImageName = "/Game/Asset/Scene/common/InterProps/Texture/"..ImageName.."."..ImageName
    local RealImage = LoadObject(RealImageName)
    --local RealImage = LoadObject('/Game/Asset/Scene/common/InterProps/Texture/T_East02_Cube_01.T_East02_Cube_01')

    if not RealImage then
        DebugPrint("BP_TeleportGate_C: Load Material: "..ImageName.." failed")
        return
    end
    return RealImage
end

function BP_TeleportGate_C:ClearSceneCaptureComponent()
    if self.SceneCaptureComponent then
        self.SceneCaptureComponent:K2_DestroyComponent(self.SceneCaptureComponent)
        self.SceneCaptureComponent=nil
    end
    UKismetRenderingLibrary.ReleaseRenderTarget2D(self.RenderTexture)
    self.RenderTexture=nil
end

function BP_TeleportGate_C:OnStartTeTeleport()
    if IsStandAlone(self) or IsClient(self) then
        UIManager(self):LoadUINew('RougeTransition', self.SceneCaptureComponent, self.RenderTexture, false)
    end
end

function BP_TeleportGate_C:StartTeleport()
    -- self:ClearSceneCaptureComponent()
    -- self:InitSceneCaptureComponent()
	--self:OnStartTeTeleport()
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	PlayerCharacter:K2_TeleportTo(self.DestLoaction, self.DestRotation, false, nil, false)
    PlayerCharacter:ResetIdle()
    PlayerCharacter:GetController():SetControlRotation(self.DestRotation)
end

function BP_TeleportGate_C:GetTeleportGate()
    if self.TeleportGate then
        return self.TeleportGate
    end
end

function BP_TeleportGate_C:GetTeleportDestLocation()
    return self.DestLoaction
end

function BP_TeleportGate_C:SetTeleportDestLocation(DestLoaction)
    self.DestLoaction = DestLoaction
end

function BP_TeleportGate_C:GetTeleportDestRotation()
    return self.DestRotation
end

function BP_TeleportGate_C:SetTeleportDestRotation(DestRotation)
    self.DestRotation = DestRotation
end

function BP_TeleportGate_C:OnEMActorDestroy(DestroyReason)
    BP_TeleportGate_C.Super.OnEMActorDestroy(self, DestroyReason)
    --self:ClearSceneCaptureComponent()
end

return BP_TeleportGate_C
