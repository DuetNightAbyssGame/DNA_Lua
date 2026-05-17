local UIUtils = require "Utils.UIUtils"
local View = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
})

function View:OnListItemObjectSet(Content)
    self.Switch_Type:SetActiveWidgetIndex(1)
    self.Text_Effect01:SetText(Content.EffectText)
end

return View