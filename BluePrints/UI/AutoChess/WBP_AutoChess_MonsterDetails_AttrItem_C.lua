local UIUtils = require "Utils.UIUtils"
local View = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
})

function View:InitView(TitleName, Value)
    self.Text_Name:SetText(TitleName)
    if type(Value) == "number" then
        self.Text_Num:SetText(string.format("%.0f", Value))
    else
        self.Text_Num:SetText(Value)
    end
end

return View