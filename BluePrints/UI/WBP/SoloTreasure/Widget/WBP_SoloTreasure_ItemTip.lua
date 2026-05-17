
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")

---@type WBP_SoloTreasure_BagItem00_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    -- "BluePrints.Common.TimerMgr",
    -- "BluePrints.Common.DelayFrameComponent"
})

function M:RefreshItemInfo(Content)
    if not Content then return end
    local TreasureId = Content.ItemId
    if not TreasureId then return end
    local TreasureInfo = DataMgr.ExtractionTreasure[TreasureId]
    if not TreasureInfo then return end
    self.Text_Name:SetText(GText(TreasureInfo.Name))
    local FormattedTreasureValue = Utils.FormatNumber(TreasureInfo.TreasureValue, false)
    self.Text_Value:SetText(GText(FormattedTreasureValue))
    self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    self:PlayAnimation(self.In)
end
return M
