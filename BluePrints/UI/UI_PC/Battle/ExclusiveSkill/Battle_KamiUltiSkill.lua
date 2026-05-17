--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Battle_KamiUltiSkill_PC_C
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

function M:OnLoaded(OwnerPlayer, Params)
	self.Super.OnLoaded(self)
    self.OwnerPlayer = OwnerPlayer
    self:PlayAnimation(self.In)
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
