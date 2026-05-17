--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_AgentMiniHead_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Initialize(Initializer)
    self.IsForid = false
    self.IsChoose = false
    self.Id = nil
end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
