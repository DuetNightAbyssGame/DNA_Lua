--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Build_PhantomSlot_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:SetCharIcon(IconPath, ...)
    self.CharIconPath = IconPath
    self:PlayAnimation(self.Normal)
    self.WidgetSwitcher_Head:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.WidgetSwitcher_Head:SetActiveWidgetIndex(0)
    self.Img_Avatar:SetBrushResourceObject(LoadObject(IconPath))
    -- local IconDynaMaterial = self.Img_Avatar:GetDynamicMaterial()
    -- if IconDynaMaterial then
    --     IconDynaMaterial:SetTextureParameterValue("IconMap", LoadObject(IconPath))
    -- end
end

function M:SetWeaponIcon(IconPath, ...)
    self:PlayAnimation(self.Normal)
    self.WidgetSwitcher_Head:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.WidgetSwitcher_Head:SetActiveWidgetIndex(1)
    local IconDynaMaterial = self.Img_Weapon:GetDynamicMaterial()
    if IconDynaMaterial then
        IconDynaMaterial:SetTextureParameterValue("IconMap", LoadObject(IconPath))
    end
end

function M:SetEmptyIcon(IconPath, ...)
    self:StopAllAnimations()
    local Type = ...
    if Type == "Phantom" then
        self.WidgetSwitcher_Head:SetActiveWidgetIndex(2)
    elseif Type == "Weapon" then
        self.WidgetSwitcher_Head:SetActiveWidgetIndex(3)
    end
    self:PlayAnimation(self.Normal)
end

function M:SetDeficiencyIcon()
    self:StopAllAnimations()
    self:PlayAnimation(self.FlashRed)
end

--头像置灰
function M:CharIconGray()
    self.WidgetSwitcher_Head:SetActiveWidgetIndex(4)
    -- self.Head_Phantom_Lack:SetBrushResourceObject(LoadObject(self.CharIconPath))
    local IconDynaMaterial = self.Head_Phantom_Lack:GetDynamicMaterial()
    if IconDynaMaterial then
        IconDynaMaterial:SetTextureParameterValue("MainTex", LoadObject(self.CharIconPath))
    end
end

return M
