--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
---@type WBP_Battle_SuyiUltiSkill_C
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

function M:OnLoaded(OwnerPlayer)
	self.Super.OnLoaded(self)
    self.OwnerPlayer = OwnerPlayer
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:AddTimer(1.6, function()
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:StopAllAnimations()
        self:PlayAnimation(self.In)
    end, false, 0, "PlayInAnim")
end

function M:RemoveSelf()
    self:StopAllAnimations()
    self:PlayAnimation(self.Out)
    local EndTime = self.Out:GetEndTime()
    self:AddTimer(EndTime, function()
        self:Close()
    end, false, 0, "OutAnimFinished")
end

return M