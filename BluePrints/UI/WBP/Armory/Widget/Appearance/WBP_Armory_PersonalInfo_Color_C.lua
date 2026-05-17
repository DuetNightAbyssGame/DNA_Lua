--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_PersonalInfo_Color_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
end

function M:OnListItemObjectSet(Content)
    self.ColorId = Content.ColorId

    self:SetColor()
end

function M:SetColor()
    local SwatchData = DataMgr.Swatch
    local ColorData = SwatchData[self.ColorId]
    ColorData = ColorData and ColorData.ColorNumber
    local Color = FLinearColor(1, 1, 1)
    if(ColorData)then
        UKismetMathLibrary.LinearColor_SetFromSRGB(Color,
            FColor(ColorData[1] or 0,ColorData[2] or 0,ColorData[3] or 0))
    end
    if Color then
        self.Image_Color:SetColorAndOpacity(Color)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
