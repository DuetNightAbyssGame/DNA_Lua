--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Wuyousheng_LevelTabGroup_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.UI = self
    self:Init(Content)
end

function M:Init(Content)
    if Content.DungeonId1 then
        self.LevelTab_1.ParentWidget = Content.ParentWidget
        self.LevelTab_1:Init(Content.DungeonId1, Content.EventId, Content.Index1)
    end
    if Content.DungeonId2 == nil then
        self.LevelTab_2:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.LevelTab_2.ParentWidget = Content.ParentWidget
        self.LevelTab_2:SetVisibility(UIConst.VisibilityOp.Visible)
        self.LevelTab_2:Init(Content.DungeonId2, Content.EventId, Content.Index2)
    end

end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return self.LevelTab_1
end

return M
