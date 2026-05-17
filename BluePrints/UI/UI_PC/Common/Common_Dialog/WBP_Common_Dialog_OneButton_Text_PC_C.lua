require "UnLua"

---@class Common_Dialog_One_Button_Text_PC_C
local WBP_Common_Dialog_OneButton_Text_PC_C = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

---@param Params Common_Dialog_Params
function WBP_Common_Dialog_OneButton_Text_PC_C:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)

    local Text = nil 
    if PopupData then Text = Text or PopupData.PopoverText end
    if Params and Params.ShortText then Text = Params.ShortText end
    if Text==nil then return end

    if (Params and Params.ShortTextParams) then
        self.Text_Details:SetText(string.format(GText(Text), table.unpack(Params.ShortTextParams)))
        return
    end
    self.Text_Details:SetText(GText(Text))
end



return WBP_Common_Dialog_OneButton_Text_PC_C