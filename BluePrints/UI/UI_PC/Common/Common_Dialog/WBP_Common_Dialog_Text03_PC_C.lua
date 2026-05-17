require "UnLua"

---@type Common_Dialog_Text03_PC_C
local WBP_Common_Dialog_Text03_PC_C = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

---@param Params Common_Dialog_Params
function WBP_Common_Dialog_Text03_PC_C:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    if not Params then return end
    
    
    self.List:ClearListItems()
    ---@type Common_Dialog_Text03_ItemContent_PC_C
    for _, Item in ipairs(Params.Text03_ListView) do 
        local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
        for key, value in pairs(Item) do
            ItemContent[key] = value
        end
        self.List:AddItem(ItemContent)
    end
    self.List:RequestRefresh()
    self.List.bIsFocusable = false
    self.bIsDealWithVirtualAccept = true

    self:AddTimer(0.01, function()
        if UIUtils.GetMaxScrollOffsetOfListView(self.List) > 5 then
            self:ShowGamepadScrollBtn(true)
        else
            self:ShowGamepadScrollBtn(false)
        end
    end)
end

function WBP_Common_Dialog_Text03_PC_C:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.RightAnalogY) then
        local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        self.List:SetScrollOffset(self.List:GetScrollOffset() + DeltaOffset)
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

return WBP_Common_Dialog_Text03_PC_C