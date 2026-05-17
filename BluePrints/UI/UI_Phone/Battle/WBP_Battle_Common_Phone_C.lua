--
-- DESCRIPTION
--
-- @COMPANY HERO GAMES @PAN.Studio
-- @AUTHOR ZhuYuhao
-- @DATE ${date} ${time}
--

---@type Jump_Phone_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

function M:Initialize(Initializer)
end


AssembleComponents(M)

return M
