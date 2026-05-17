require "UnLua"
local WBP_Training_TextItem_C = Class("BluePrints.UI.BP_EMUserWidget_C")

function WBP_Training_TextItem_C:OnListItemObjectSet(Content)
    self.Content = Content 
    self:UpdateView(Content)    
end

function WBP_Training_TextItem_C:UpdateView(Content)
    self.Text_TitleData:SetText(Content.Title)
    self.Text_DataNum:SetText(Content.Num)
    self.WidgetSwitcher_Bg:SetActiveWidgetIndex(Content.ColorIndex)
end

return WBP_Training_TextItem_C