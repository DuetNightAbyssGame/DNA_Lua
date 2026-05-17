--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Aim_Locked_Phone_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

 function M:Construct()
     self.IsShowButton = false
     self.LastShowButton = false
     self.CurButtonState = "UnLock"
     self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
     self.Button_Area.OnPressed:Add(self, self.OnPressed)
     self:SetVisibility(UE4.ESlateVisibility.Collapsed)
 end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:OnPressed()
    -- 逻辑层
    self.OwnerPlayer:FlipCameraLockOnMonster()
    self.OwnerPanel:CancelBulletJump()
    -- 表现层
    if self.OwnerPlayer.CameraRotationComponent.IsCameraLookingToTarget then
        self.CurButtonState = "Lock"
        self:PlayAnimation(self.Lock)
    else
        self.CurButtonState = "Unlock"
        self:PlayAnimation(self.Unlock)
    end
end

function M:OnLockOnButtonShowChanged(IsLooking, IsShow)
    if IsLooking then
        self:PlayAnimation(self.Lock)
        self.CurButtonState = "Lock"
    else
        self:PlayAnimation(self.Unlock)
        self.CurButtonState = "UnLock"
    end
    if IsShow then
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnCameraLockOnChanged(IsLooking)
    if self.CurButtonState == "Lock" and not IsLooking then
        self.CurButtonState = "Unlock"
        self:PlayAnimation(self.Unlock)
    end
end

--function M:UpdateButtonInTimer()
--    -- 决定按钮出现/消失
--    if IsValid(self.OwnerPlayer.CameraRotationComponent.PreLockOnInfo) or self.OwnerPlayer.IsLockOn then
--        self.IsShowButton = true
--    else
--        self.IsShowButton = false
--    end
--    if self.IsShowButton ~= self.LastShowButton then
--        if self.OwnerPlayer.CameraRotationComponent.IsCameraLookingToTarget then
--            self:PlayAnimation(self.Lock)
--            self.CurButtonState = "Lock"
--        else
--            self:PlayAnimation(self.Unlock)
--            self.CurButtonState = "UnLock"
--        end
--        if self.IsShowButton then
--            self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--        else
--            self:SetVisibility(UE4.ESlateVisibility.Collapsed)
--        end
--    end
--    self.LastShowButton = self.IsShowButton
--    -- 超出距离（或其他情况解除锁定时）播解除动效
--    if (self.CurButtonState == "Lock" and not self.OwnerPlayer.CameraRotationComponent.IsCameraLookingToTarget) then
--        self.CurButtonState = "Unlock"
--        self:PlayAnimation(self.Unlock)
--    end
--end

AssembleComponents(M)

return M
