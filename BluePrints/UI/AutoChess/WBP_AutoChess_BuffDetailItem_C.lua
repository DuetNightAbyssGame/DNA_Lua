require "UnLua"
local WBP_AutoChess_BuffDetailItem = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

function WBP_AutoChess_BuffDetailItem:OnListItemObjectSet(ListItemObject)
    DebugPrint("------------------------item-------------------------")
    self.Text_Name:SetText(ListItemObject.BuffName)
    self.Text_Desc:SetText(ListItemObject.BuffDes)
    local IconObj = LoadObject(ListItemObject.BuffIcon)
    self.Icon_Buff:SetBrushFromTexture(IconObj)
    -- self:playAnimation(self.In)
end

return WBP_AutoChess_BuffDetailItem
