---@type WBP_DungeonSettlement_VictoryReminder_New_C
local M = Class("BluePrints.UI.Settlement.WBP_DungeonSettlementReminder_C")

-- function M:Initialize(Initializer)
-- end

-- function M:PreConstruct(IsDesignTime)
-- end

-- function M:Construct()
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)

    local HeadLineText_Win = GText("UI_MISSION_COMPLETE")
    self.Text_Headline:SetText(HeadLineText_Win)
end

return M
