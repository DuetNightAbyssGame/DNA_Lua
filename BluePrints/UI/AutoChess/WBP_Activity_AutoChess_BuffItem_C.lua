require "UnLua"
local WBP_Activity_AutoChess_BuffItem = Class("BluePrints.UI.BP_EMUserWidget_C")


function WBP_Activity_AutoChess_BuffItem:OnListItemObjectSet(ListItemObject)
    self.Text_Buff:SetText(ListItemObject.BuffName)
    local IconObj = LoadObject(ListItemObject.BuffIcon)
    self.Icon_Buff:SetBrushFromTexture(IconObj)
    self:PlayAnimation(self.In) 
end

return WBP_Activity_AutoChess_BuffItem