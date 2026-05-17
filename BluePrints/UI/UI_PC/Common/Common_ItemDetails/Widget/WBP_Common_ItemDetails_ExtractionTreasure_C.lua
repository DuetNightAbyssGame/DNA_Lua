--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type WBP_Com_Tips_SoloTreasure_C
local M = Class()

function M:InitItemInfo(ItemType, ItemId, UnitId)
    local ExtractionTreasureData = DataMgr.ExtractionTreasure[ItemId]
    if not ExtractionTreasureData then
        return
    end
    local ExtractionTreasureType = ExtractionTreasureData.TreasureType
    if ExtractionTreasureType then
        local ExtractionTreasureTypeInfo = DataMgr.ExtractionTreasureType[ExtractionTreasureType]
        if ExtractionTreasureTypeInfo then
            self.Text_Type:SetText(GText(ExtractionTreasureTypeInfo.Name))
        end
    end

    local TreasureValue = ExtractionTreasureData.TreasureValue
    if TreasureValue then
        local FormattedTreasureValue = Utils.FormatNumber(TreasureValue, false)
        self.Text_Num:SetText(FormattedTreasureValue)
    end

    self.Text_Value:SetText(GText("UI_Extraction_SingleSpaceValue"))

    local Shape = ExtractionTreasureData.Shape
    if Shape then
        local TreasureSize = ExtractionTreasureData.Shape[1] * ExtractionTreasureData.Shape[2]
        if TreasureValue and TreasureSize then
            local TreasureValuePreGrid = math.ceil(TreasureValue / TreasureSize)
            local FormattedTreasureValuePreGrid = Utils.FormatNumber(TreasureValuePreGrid, true)
            self.Num_Value:SetText(FormattedTreasureValuePreGrid)
        end
        self.Bag_Position:SetShowSize(FVector2D(ExtractionTreasureData.Shape[1], ExtractionTreasureData.Shape[2]))
        if TreasureSize <= 1 then
            self.SingleValue:SetVisibility(ESlateVisibility.Collapsed)
        end
    end

end

return M
