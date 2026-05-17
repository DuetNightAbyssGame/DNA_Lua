--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Archive_ShowItem_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Item.WBP_ShowItem_Base_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitData(Content)
    self.Super.InitData(self, Content)
end

function M:InitCompView()
    self.Super.InitCompView(self)
    --..........
end

return M
