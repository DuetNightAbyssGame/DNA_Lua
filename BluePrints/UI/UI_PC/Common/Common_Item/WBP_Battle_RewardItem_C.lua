--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_RewardItem_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Item.WBP_Com_Item_Base_C"})

function M:InitData(Content)
    self.Super.InitData(self, Content)
end

function M:InitCommonView()
    self.Node_Widget:ClearChildren()
    self.Super.InitCommonView(self)
end

function M:InitCompView()
    self.Super.InitCompView(self)
    self:SetCount(self.Count, self.NeedCount, self.MaxCount, self.NotCountFormat)
end

function M:PlayInAnimation()
    if self.Rarity == 5 then
        self:PlayAnimation(self.Reward_In_Orange)
    elseif self.Rarity == 4 then
        self:PlayAnimation(self.Reward_In_Purple)
    elseif self.Rarity == 3 then
        self:PlayAnimation(self.Reward_In_Blue)
    elseif self.Rarity == 2 then
        self:PlayAnimation(self.Reward_In_Green)
    elseif self.Rarity == 1 then
        self:PlayAnimation(self.Reward_In_White)
    end
end


return M
