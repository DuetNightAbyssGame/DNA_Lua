--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_Pet_EntryTag_L_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(Content)
    if(Content.IsLocked)then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(2)
    elseif(Content.IsEmpty)then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        self.Panel_EntryTag:Init(Content)
    end
end


return M
