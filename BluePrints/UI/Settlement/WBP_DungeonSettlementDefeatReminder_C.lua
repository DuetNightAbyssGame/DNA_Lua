---@type WBP_Dungeon_Settlement_DefeatReminder_New_C
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

    local HeadLineText_Fail = GText("UI_MISSION_FAIL")
    self.Text_Headline:SetText(HeadLineText_Fail)
end

return M
