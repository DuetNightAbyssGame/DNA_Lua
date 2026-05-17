--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type BP_JumpWordComponent_C
local M = Class()

-- 加载屏幕跳字
function M:LoadMonsterExpTips(ShowNumber, OvalEdgeScreenPos)
    UIManager(self):LoadUI(UIConst.MONSTEREXPTIPS, "MonsterExpWord", UIConst.ZORDER_FOR_COMMON_TIP, ShowNumber, OvalEdgeScreenPos)
end

return M
