--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_UnlockDialogItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(Content)
    Content = Content or {}
    rawset(self,"Content",Content)
    rawset(Content,"Widget",self)
    rawset(self,"Owner",Content.Owner)
    rawset(self,"_OnClicked",Content.OnClicked)
    rawset(self,"_OnAddedToFocusPath",Content.OnAddedToFocusPath)
    self.Text_Item:SetText(Content.Text)
    if(Content.IconPath)then
        local Icon = LoadObject(Content.IconPath)
        if(Icon)then
            self.Icon_Item:SetBrushResourceObject(Icon)
        end
    end
    self.Btn_Area:SetChecked(false)
end

function M:OnClicked()
    if(rawget(self,"_OnClicked"))then
        self._OnClicked(self.Owner,self.Content)
    end
end

function M:OnSelect(bSelect)
    self:StopAllAnimations()
    self.bSelect = bSelect
    if(bSelect)then
        self.Btn_Area:SetCheckedNoNotify(true)
        self.Btn_Area:SetIsEnabled(false)
        self:PlayAnimation(self.Click)
    else
        self.Btn_Area:SetCheckedNoNotify(false)
        self.Btn_Area:SetIsEnabled(true)
        self:PlayAnimation(self.Normal)
    end
end

function M:OnAddedToFocusPath()
    if(rawget(self,"_OnAddedToFocusPath"))then
        self._OnAddedToFocusPath(self.Owner,self.Content)
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return  UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Btn_Area)
end

return M
