require "UnLua"

---@type WBP_Forging_Convert_ItemBig_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnMouseEnter(MyGeometry, MouseEvent)
    DebugPrint("Yihan@ WBP_Forging_Convert_ItemBig_C:OnMouseEnter")
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if self.IsSelect then return end
    self.Item_Shop:StopAllAnimations()
    self.Item_Shop:PlayAnimation(self.Item_Shop.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    DebugPrint("Yihan@ WBP_Forging_Convert_ItemBig_C:OnMouseLeave")
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if self.IsSelect then return end
    self.Item_Shop:StopAllAnimations()
    self.Item_Shop:PlayAnimation(self.Item_Shop.UnHover)
end

function M:PlayerClickAnimation()
    self.Item_Shop:PlayAnimation(self.Item_Shop.Click)
    self.IsSelect = true
end

function M:PlayerUnHoverAnimation()
    self.Item_Shop:PlayAnimation(self.Item_Shop.UnHover)
    self.IsSelect = false
end

return M