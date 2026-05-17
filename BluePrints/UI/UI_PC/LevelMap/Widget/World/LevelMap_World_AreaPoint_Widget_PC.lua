--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type LevelMap_World_AreaPoint_Widget_PC_C
local M = Class()

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    local LevelMap = UIManager(self):GetUI("LevelMap")
    LevelMap.LevelMap_World:AddAreaPoint(self.RegionId, self)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:OnClickButton()

end

return M
