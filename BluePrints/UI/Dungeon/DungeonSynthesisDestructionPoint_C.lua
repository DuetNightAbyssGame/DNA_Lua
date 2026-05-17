--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeWeekly_Hud_ClueProgress_PointItem_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",

})


function M:InitItem(Index, RageValue)
    self.Index = Index
    self.RageValue = RageValue
    self:SetNormal()

    -- 简单点 做成动效只播一次 且不可逆转
    self.IsRed = false
    self.IsComplete = false
    --self:BindToAnimationFinished(self.HighlightPrompt, {self, self.OnHighlightAnimFinished})      新版用不上了
end

function M:SetRed()
    -- if self.IsFinalHide then
    --     return
    -- end
    -- self:SetItemVisibility(true)
    if self.IsRed then
        return
    end
    self.IsRed = true
    self:PlayAnimation(self.Red_In)
    self.Red:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Panel_Complete:SetVisibility(UE4.ESlateVisibility.Collapsed)

    AudioManager(self):PlayUISound(self, "event:/ui/common/week_level_target_found", nil, nil)
end

function M:SetNormal()
    -- if self.IsFinalHide then
    --     return
    -- end
    -- self:SetItemVisibility(true)
    self.Red:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Complete:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

-- function M:SetHide()
--     if self.IsFinalHide then
--         return
--     end
--     self:SetItemVisibility(false)
-- end

function M:SetComplete()
    if self.IsComplete then
        return
    end
    self.IsComplete = true
    self:PlayAnimation(self.Complete_In)
    self.Red:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Complete:SetVisibility(UE4.ESlateVisibility.Visible)

    AudioManager(self):PlayUISound(self, "event:/ui/common/week_level_target_finish", nil, nil)
end

-- 这次大迭代把所有用不上的方法都注释掉了

-- function M:PlayHideAnimation()
--     -- RageValue已经上涨超过当前点所在的阶段，通过这种方式隐藏，不会再显示
--     self.IsFinalHide = true
--     self:PlayAnimation(self.HighlightPrompt)
-- end

-- function M:OnHighlightAnimFinished()
--     if self.IsFinalHide then
--         self:SetItemVisibility(false)
--     else
--         -- self:SetNormal()
--         if self.HighlightAnimCb then
--             self.HighlightAnimCb(self)
--         end
--     end
-- end

-- function M:PlayHighlightAnim(cb)
--     if self.IsFinalHide then
--         return
--     end
--     self.HighlightAnimCb = cb
--     self:SetRed()
--     self:PlayAnimation(self.HighlightPrompt)
-- end

-- function M:SetItemVisibility(IsShow)
--     if IsShow then
--         self:SetVisibility(UE4.ESlateVisibility.Visible)
--     else
--         self:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
-- end

return M
