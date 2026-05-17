--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Item_Universal_M_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Item.WBP_Com_Item_Base_C"})
M._components = {
    "BluePrints.UI.UI_PC.Common.Common_Item.Comp.WBP_Com_Item_TimeTag_Comp",
    "BluePrints.UI.UI_PC.Common.Common_Item.Comp.WBP_Com_Item_CustomTag_Comp",
}

function M:InitData(Content)
    self.Super.InitData(self, Content)
end

function M:InitCommonView()
    if self.bDontRemoveSubWidget then
        for _, Widget in pairs(self.Node_Widget:GetAllChildren()) do
            Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        self.Node_Widget:ClearChildren()
        self.WidgetMap = {}
    end
    self.Super.InitCommonView(self)
end

function M:InitCompView()
    self.Super.InitCompView(self)

    self:SetCount(self.Count, self.NeedCount, self.MaxCount, self.NotCountFormat, self.bShowNotHaveStyle)
    self:SetBonus(self.BonusType, self.ExtraBonusText)
    self:SetName(self.ItemName)
    self:SetLevel(self.Level)
    self:SetIsCanGet(self.bCanGet, self.CanGetStyle)
    self:SetOutline(self.bOutline)
    self:SetSelectNum(self.SelectNeedCount, self.SelectTotalCount)
    if self.ItemType == CommonConst.DataType.Weapon then
        self:SetWeaponPhantomIcon(self.Uuid)
    end
    self:SetItemSold(self.bSold)

    -- 层级1
    self:SetLock(self.LockType)
    self:SetShadow(self.bShadow)
    self:SetIsGot(self.bHasGot)

    self:SetRareTag(self.bRare)
    self:SetTimeLimitData(self.TimeLimitData)
    -- 层级2
    self:SetTimeTag(self.Content.TimeTagList)
    self:SetCustomTag(self.Content.bAllowCustom)
    self:SetRedDot(self.RedDotType)

end
AssembleComponents(M)
return M
