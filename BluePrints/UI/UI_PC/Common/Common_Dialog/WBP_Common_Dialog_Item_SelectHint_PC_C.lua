require "unlua"

---@type Common_Dialog_Item_SelectHint_PC_C
local WBP_Common_Dialog_Item_SelectHint_PC_C = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")


function WBP_Common_Dialog_Item_SelectHint_PC_C:PreInitContent(Params, PopupData, Owner)
    self.Super.PreInitContent(self, Params, PopupData, Owner)
    self:BindDialogEvent(DialogEvent.HideDialogItem, self.HideDialogItem)
    self.PackageKey = "SelectHint"
end

---@param Type string
---@param Params Common_Dialog_Params
---@param PopupData table
function WBP_Common_Dialog_Item_SelectHint_PC_C:InitContent(Params, PopupData, Owner)
    self.Owner = Owner
    self.PosIndex = self.Owner:GetItemIndex()

    local Text = nil 
    if PopupData and PopupData.HintText then Text = PopupData.HintText end 
    if Params and Params.HintText then Text = Params.HintText end 
    if Text then self.Text_Hint:SetText(GText(Text)) end

    self.Button_Hint.OnClicked:Add(self, self.OnBtnClicked)
    self.Button_Hint.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Hint.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Button_Hint.OnPressed:Add(self, self.OnBtnPressed)    
    self.IsSelected = false
    self.Bg_Select:SetVisibility(UE.ESlateVisibility.Collapsed)
end

function WBP_Common_Dialog_Item_SelectHint_PC_C:InitGamepadView()
    self.Key_GamePad:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
    self.Key_GamePad:SetVisibility(UE.ESlateVisibility.HitTestInvisible)
end

function WBP_Common_Dialog_Item_SelectHint_PC_C:InitKeyboardView()
    self.Key_GamePad:SetVisibility(UE.ESlateVisibility.Collapsed)
end

function WBP_Common_Dialog_Item_SelectHint_PC_C:OnBtnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    if not self.IsSelected then
        self:PlayAnimation(self.Click)
    else
        self:PlayAnimation(self.Click)
    end
    self.IsSelected = not self.IsSelected
    self.Bg_Select:SetVisibility(self.IsSelected and UE.ESlateVisibility.Visible or UE.ESlateVisibility.Collapsed)
end

-- handlers for button five-state animations
function WBP_Common_Dialog_Item_SelectHint_PC_C:OnBtnHovered()
    self:PlayAnimation(self.Hover)
end

function WBP_Common_Dialog_Item_SelectHint_PC_C:OnBtnUnhovered()
    self:PlayAnimation(self.UnHover)
end

function WBP_Common_Dialog_Item_SelectHint_PC_C:OnBtnPressed()
    self:PlayAnimation(self.Press)
end


function WBP_Common_Dialog_Item_SelectHint_PC_C:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == Const.GamepadLeftThumbstick then
        self:OnBtnClicked()
        return true
    end
    return false
end

function WBP_Common_Dialog_Item_SelectHint_PC_C:HideDialogItem(Params, PopupData)
    if(Params.DialogItemIndex == self.PosIndex)then
        if(Params.bHideDialogItem)then
            self:SetVisibility(UE.ESlateVisibility.Collapsed)
        else
            self:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
        end
    end

    self.Owner:AutofitDialog()
end

-- 根据控件类型，返回一些弹窗内信息
function WBP_Common_Dialog_Item_SelectHint_PC_C:PackageData()
    local PackageResult = {}
    PackageResult.IsSelected = self.Bg_Select:IsVisible()
    return PackageResult
end

return WBP_Common_Dialog_Item_SelectHint_PC_C