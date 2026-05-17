--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_TabText_C
local M = Class({"BluePrints.UI.WBP.Common.Tab.Widget.WBP_Com_TabSubItem01_P_C"})

function M:Update(Idx, Info, PlatformDeviceName)
    M.Super.Update(self, Idx, Info, PlatformDeviceName)
    if Info.IsLast then
        self.Arrow:SetVisibility(ESlateVisibility.Collapsed)
    end
end
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
