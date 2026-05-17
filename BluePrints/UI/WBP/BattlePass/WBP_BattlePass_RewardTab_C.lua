--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_BattlePass_RewardTab_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(Parent)
    self.Parent = Parent
    self.Tab_Normal:SetText(GText("UI_BattlePass_FreeRank"))
end

function M:SetReddotVisibility(Visibility)
    self.Reddot:SetVisibility(Visibility)
end

return M
