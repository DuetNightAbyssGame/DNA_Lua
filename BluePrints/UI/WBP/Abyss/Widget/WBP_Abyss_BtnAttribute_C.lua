
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self.Text_Attribute:SetText(GText("UI_SuggestAttribute"))
end

function M:Destruct()
end

function M:FillAttrList(Attributes)
    self.List_Attribute:ClearListItems()
    local Attributes = Attributes or {}
    for _, Attribute in pairs(Attributes) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IconPath = DataMgr.Attribute[Attribute].Icon
        self.List_Attribute:AddItem(Obj)
    end
end

function M:PlayRemindAnim()
    self:PlayAnimation(self.Remind)
end

return M