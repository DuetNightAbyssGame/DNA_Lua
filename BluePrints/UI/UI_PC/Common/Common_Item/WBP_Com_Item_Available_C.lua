--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_ItemL_GetVX_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

local StyleMap = {
    Gold = 5,
    White = 1,
    Green = 2,
    Purple = 4,
    Blue = 3,
}

---限self为WBP_Com_Item_Available_C类型的时候使用，否则会报错
---@param StyleStr string 可选项有：Gold,White,Purple,Blue
function M:SetStyle(StyleStr)
    if not StyleStr then StyleStr = "Gold" end
    local StyleCode = StyleMap[StyleStr]
    local DynMat = self.VX_Glow:GetDynamicMaterial()
    DynMat:SetVectorParameterValue("MainColor", self["VX_Glow_"..StyleCode].SpecifiedColor)
    DynMat = self.VX_Rolllight:GetDynamicMaterial()
    DynMat:SetVectorParameterValue("MainColor", self["VX_Rolllight_"..StyleCode].SpecifiedColor)
    DynMat = self.VX_Scanlight:GetDynamicMaterial()
    DynMat:SetVectorParameterValue("MainColor", self["VX_Scanlight_"..StyleCode].SpecifiedColor)
end

local RarityMap={
    "White","Green","Blue","Purple","Gold"
}

---限self为WBP_Com_ItemL_GetVX_C类型的时候使用，否则会报错
function M:SetRarity(RarityVal)
    if RarityVal<1 and RarityVal>#RarityMap then return end
    local Color = self[RarityMap[RarityVal]]
    self.VX_GetBGGlow:SetColorAndOpacity(Color)
    self.VX_GetSweepLine:SetColorAndOpacity(Color)
    self.VX_GetSacnlight:SetColorAndOpacity(Color)
    self.VX_GetFullColor:SetColorAndOpacity(Color)
    self:PlayAnimation(self.In)
end

return M
