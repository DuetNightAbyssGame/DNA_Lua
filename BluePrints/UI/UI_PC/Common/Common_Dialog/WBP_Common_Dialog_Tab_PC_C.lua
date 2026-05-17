

require "UnLua"

---@type WBP_Common_Dialog_Tab_PC_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

---@field FirstTabText string @Tab1标题
---@field SecondTabText string @Tab2标题
function M:PreInitContent(Params, PopupData, Owner) 
    self.Super.PreInitContent(self, Params, PopupData, Owner)
    self.Owner = Owner
    --目前设计只支持两个
    self.FirstTab = 1
    self.SecondTab = 2
    self.CurrentTab = self.FirstTab
    self.Tab01:InitBtn(Params.FirstTabText,true,self,self.OnTabFirstClicked)  --默认选中第一个
    self.Tab02:InitBtn(Params.SecondTabText,false,self,self.OnTabSecondClicked)
    
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Q" and self.CurrentTab ~= self.FirstTab then
        self:OnTabFirstClicked()
    elseif InKeyName == "E" and self.CurrentTab ~= self.SecondTab then
        self:OnTabSecondClicked()
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTabFirstClicked()
    if self.CurrentTab == self.FirstTab then
    else
        self.CurrentTab = self.FirstTab
        self.Tab01:SetIsSelected(true)
        self.Tab02:SetIsSelected(false) 
        self:BroadcastDialogEvent("OnCommonDialogTabChange",self.CurrentTab)
    end
end

function M:OnTabSecondClicked()
    if self.CurrentTab == self.FirstTab then
        self.CurrentTab = self.SecondTab
        self.Tab01:SetIsSelected(false)
        self.Tab02:SetIsSelected(true)
        self:BroadcastDialogEvent("OnCommonDialogTabChange",self.CurrentTab)
    else
    end
end

return M