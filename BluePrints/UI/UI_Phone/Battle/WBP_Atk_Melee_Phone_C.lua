--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_AtkMelee_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

function M:Construct()
    self.DefaultIconPath = "/Game/UI/Texture/Static/Atlas/Battle/T_Battle_Melee.T_Battle_Melee"
    self.ImageMat = self.Image_Main:GetDynamicMaterial()
    UE.UResourceLibrary.LoadObjectAsync(self, self.DefaultIconPath, {self, M.OnWeaponHUDIconLoadFinish})
end

function M:OnPropEffectReplaceAttack(PropEffectId)
    local ReplaceIconPath = DataMgr.PropEffect[PropEffectId].ReplaceAttackIconPath
    if not ReplaceIconPath then
        return
    end
    UE.UResourceLibrary.LoadObjectAsync(self, ReplaceIconPath, {self, M.OnPropIconLoadFinish}) 
end

function M:OnPropEffectEndReplaceAttack()
    if self.DefaultIconPath then
        UE.UResourceLibrary.LoadObjectAsync(self, self.DefaultIconPath, {self, M.OnWeaponHUDIconLoadFinish})
    end
end

function M:OnWeaponHUDIconLoadFinish(Object)
    if not IsValid(self) or not Object then
        return 
    end
    self:WeaponIcon()
    self.ImageMat = self.Image_Main:GetDynamicMaterial()
    if self.ImageMat then
        self.ImageMat:SetTextureParameterValue("IconMap", Object)
    end
end

function M:OnPropIconLoadFinish(Object,ResourceID)
    if not IsValid(self) or not Object or self.LoadPropResourceID ~= ResourceID then
        return
    end
    self:OrganIcon(Object)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

AssembleComponents(M)

return M
