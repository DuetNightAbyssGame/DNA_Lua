--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Achievement_Root_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:Construct()
--end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:PressKeyA()
    self.List_Item:NavigateToIndex(0)
end

function M:PressKeyA_Item()
    self.List_Achievement:SetFocus()
end

function M:AchievementNavigateRight()
    self.List_Item:NavigateToIndex(0)
    return true
end

function M:ClickAchievement()
    self.List_Item:NavigateToIndex(0)
end

function M:OnClickItem()
end

return M
