require "unlua"

---@type Common_Dialog_Item_PC_C
local WBP_Common_Dialog_Item_PC_C = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

local TypeIdx2Type = {
    [0] = "Funds",
    [1] = "Tip", 
    [2] = "Tip",
    [3] = "Tip",
    [4] = "SelectHint"
}

---@param Type string
---@param Params Common_Dialog_Params
---@param PopupData table
function WBP_Common_Dialog_Item_PC_C:Init(PosIndex, TypeIdx, Params, PopupData, Owner)
    self.Owner = Owner
    self.PosIndex = PosIndex
    local ItemType = TypeIdx2Type[TypeIdx]
    if not ItemType then 
        DebugPrint("Tianyi@ ItemType填写错误!")
        return 
    end

    self.ItemType = ItemType
    self.Switcher:SetActiveWidgetIndex(TypeIdx) 
    self["Show_" .. ItemType](self, Params, PopupData)
    self:BindDialogEvent("UpdateFunds", self.Show_Funds)
    self:BindDialogEvent(DialogEvent.HideDialogItem, self.HideDialogItem)
    self:BindDialogEvent("UpdateDialogTipText", self.UpdateDialogTipText)
end

function WBP_Common_Dialog_Item_PC_C:Show_Tip(Params, PopupData)
    local Text = nil
    if PopupData and PopupData.Tip then Text = PopupData.Tip[self.PosIndex] end
    if Params and Params.Tips then Text = Params.Tips[self.PosIndex] end
    if Text then 
        self.Text_Tips01:SetText(GText(Text)) 
        self.Text_Tips02:SetText(GText(Text)) 
        self.Text_Tips03:SetText(GText(Text)) 
    end
end


function WBP_Common_Dialog_Item_PC_C:Show_Funds(Params, PopupData)
    if Params and Params.Funds then 
        local Widgets = self.HB_Item:GetAllChildren()
        local WidgetCount = self.HB_Item:GetChildrenCount()
        local Avatar = GWorld:GetAvatar()
        for index, value in ipairs(Params.Funds) do
            local Widget = WidgetCount >= index and Widgets:GetRef(index)
            if(not Widget)then
                -- Widget = Utils.UIManager(self):CreateWidget('/Game/UI/UI_PC/Common/Common_Dialog/Common_Dialog_Currency_PC.Common_Dialog_Currency_PC', false)
                Widget = self:CreateWidgetNew("CommonDialogCurrency")
                self.HB_Item:AddChildToHorizontalBox(Widget)
            end
            if(Widget)then
                local Resource = Avatar.Resources[value.FundId] or {Count = 0}
                local Params = {
                    ResourceId = value.FundId,
                    Denominator = value.FundNeed,
                    Numerator = Resource.Count,
                }
                Widget:InitContent(Params)
            end
        end
        if(#Params.Funds < WidgetCount)then
            for index = #Params.Funds + 1,WidgetCount do
                Widgets:GetRef(index):SetVisibility(UE.ESlateVisibility.Collapsed)
            end
        end
        self.Panel_Currency:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Currency:SetVisibility(UE.ESlateVisibility.Collapsed)
    end
end

function WBP_Common_Dialog_Item_PC_C:Show_SelectHint(Params, PopupData)
    local Text = nil 
    if PopupData and PopupData.HintText then Text = PopupData.HintText end 
    if Params and Params.HintText then Text = Params.HintText end 
    if Text then self.Text_Hint:SetText(GText(Text)) end

    self.Button_Hint.OnClicked:Add(self, function() 
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
        self.Bg_Select:SetVisibility(self.Bg_Select:IsVisible() and UE.ESlateVisibility.Hidden or UE.ESlateVisibility.Visible)
    end)
end

function WBP_Common_Dialog_Item_PC_C:HideDialogItem(Params, PopupData)
    if(Params.DialogItemIndex == self.PosIndex)then
        if(Params.bHideDialogItem)then
            self.Switcher:SetVisibility(UE.ESlateVisibility.Collapsed)
        else
            self.Switcher:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
        end
    end

    self.Owner:AutofitDialog()
end

function WBP_Common_Dialog_Item_PC_C:UpdateDialogTipText(Params, PopupData)
    if(Params.DialogItemIndex == self.PosIndex)then
        self:Show_Tip( Params, PopupData)
    end
end

-- 根据控件类型，返回一些弹窗内信息
function WBP_Common_Dialog_Item_PC_C:PackageData()
    local PackageResult = {}

    if self.ItemType == "SelectHint" then 
        PackageResult.IsSelected = self.Bg_Select:IsVisible()
    end

    return PackageResult
end

return WBP_Common_Dialog_Item_PC_C