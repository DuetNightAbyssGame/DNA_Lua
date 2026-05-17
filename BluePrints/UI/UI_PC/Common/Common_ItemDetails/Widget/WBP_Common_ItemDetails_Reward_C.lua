--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR Zhangdongxu
-- @DATE 2023年11月22日
--
require "UnLua"

---@type Common_ItemDetails_Reward_C
local M = Class()

function M:InitItemInfo(ItemType, ItemId, UnitId)
    local RewardInfo = DataMgr.Reward[ItemId]
    self.Panel_Describe:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_LongDescribe:SetVisibility(RewardInfo.DetailDes == nil and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
    self.Text_LongDescribe:SetText(GText(RewardInfo.DetailDes))
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
end
return M
