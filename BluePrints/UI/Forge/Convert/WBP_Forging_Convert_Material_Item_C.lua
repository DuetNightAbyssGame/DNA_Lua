require "UnLua"

---@type WBP_Forging_Convert_Material_Item_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(Content)
    self:InitData(Content)
    self:InitItem()
end

function M:InitData(Content)
    self.Content = Content
end

function M:InitItem()
    self.WBP_Com_Item_Universal_L:Init(self.Content)
end

function M:ShowAddImg(bShow)
    DebugPrint("Yihan@ ShowAddImg", bShow)
    if bShow then
        self.Image_155:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.Image_155:SetVisibility(UE4.ESlateVisibility.Hidden)
    end
end

function M:ShowLeftTopIcon(bShow)
    if bShow then
        self.WBP_Com_BtnImg01:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.WBP_Com_BtnImg01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    DebugPrint("Yihan@ WBP_Forging_Convert_Material_Item_C:OnMouseEnter")
    if self.NotInteractive then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    DebugPrint("Yihan@ WBP_Forging_Convert_Material_Item_C:OnMouseLeave")
    if self.NotInteractive then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end
return M