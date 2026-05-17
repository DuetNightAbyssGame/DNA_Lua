--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type Achievement_Hyperlink_C
local M = Class()

function M:OnClick(url)
    EventManager:FireEvent(EventID.OnAchvHyperlinkClick,url)
end

return M