require "UnLua"

---@type Battle_HitDirection_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")

-- function M:Initialize(Initializer)
-- end

-- function M:PreConstruct(IsDesignTime)
-- end

-- function M:Construct()
-- end

function M:OnLoaded(Attacker, OwnerPlayer)
    M.Super.OnLoaded(self, Attacker, OwnerPlayer)
    self:OnLoaded_CPP(Attacker, OwnerPlayer)
    -- self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- local OnAnimationFinished = function()
    --     self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    --     --self:SetUIVisibilityTag("Self", true)
    --     self.Finished = true
    -- end
    -- self:BindToAnimationFinished(self.HitDirection_IN,{self,OnAnimationFinished})
    -- local Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    -- if Platform == "Mobile" then
    --     self.Radius = self.MobileRadius
    -- else
    --     self.Radius = self.PCRadius
    -- end
    -- self.RadiusSquared = self.Radius*self.Radius
    -- local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.HitDirection)
    -- CanvasSlot:SetPosition(FVector2D(0,self.Radius))
    -- -- self:Refresh(Attacker, OwnerPlayer)
    -- self:AfterLoaded(Attacker, OwnerPlayer)
end

-- function M:Refresh(Attacker, OwnerPlayer, IsShiledDamage)
--     if self:GetDistanceSquared(Attacker) < self.Radius*self.Radius then
--         self:SetVisibility(UIConst.VisibilityOp.Collapsed)
--         --self:SetUIVisibilityTag("Self", true)
--         self.Finished = true
--         return
--     end
--     self.Attacker = Attacker
--     self.OwnerPlayer = OwnerPlayer
--     self.IsShiledDamage = IsShiledDamage``
--     self.Finished = false
--     --self:SetUIVisibilityTag("Self", false)
--     self:SetVisibility(UIConst.VisibilityOp.Visible)
--     local ShowAngle = self:GetDamageAngleByAttacker()
--     self.RootWidget:SetRenderTransformAngle(ShowAngle)
--     -- self:PlayAnimation(self.HitDirection_IN)
-- 	-- local SubSystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self.OwnerPlayer, UEMUIAnimationSubsystem)
--     EMUIAnimationSubsystem:EMPlayAnimation(self, self.HitDirection_IN)
-- end

-- function M:GetDamageAngleByAttacker()
--     if (not IsValid(self.OwnerPlayer) or not IsValid(self.Attacker)) then
--         return 0
--     end
--     local Radian = self.OwnerPlayer:GetDamageInstigatorCurrentAngle(self.Attacker)
--     local Angle = math.deg(Radian)
--     return Angle
-- end

-- function M:GetDistanceSquared(Attacker)
--     local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)
--     local AttackerWorldLocation = Attacker:K2_GetActorLocation()
--     local AttackerScreenLocation = FVector2D(0, 0)
--     local PlayerScreenLocation = FVector2D(0, 0)
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local UIManager = GameInstance:GetGameUIManager()
--     local DesignedSize = UIManager:GetDesignedScreenSize()
--     PlayerScreenLocation = DesignedSize/2
--     UE4.UUIFunctionLibrary.WorldPostionToScreenPosition(Controller, AttackerWorldLocation, AttackerScreenLocation)
--     local DeltaCenterPos = FVector2D(AttackerScreenLocation.X - PlayerScreenLocation.X,  PlayerScreenLocation.Y - AttackerScreenLocation.Y)
--     return DeltaCenterPos:SizeSquared()
-- end

-- function M:Close()
--     M.Super.Close(self)
-- end

return M
