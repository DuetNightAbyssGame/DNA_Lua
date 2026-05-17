--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PlayerBloodReturn_C
local WBP_PlayerBloodReturn_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_PlayerBloodReturn_C:Initialize(Initializer)
    self.Super.Initialize(self)
end

function WBP_PlayerBloodReturn_C:Init()
    -- self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return WBP_PlayerBloodReturn_C
