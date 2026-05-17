--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Reasoning_Bubble_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:ShowInfo()
    self.Text_Bubble:SetText(GText("Minigame_Textmap_100303"))
    self:UnbindFromAnimationFinished(self.In, {self, self.OnInAnimFinished})
    self:BindToAnimationFinished(self.In, {self, self.OnInAnimFinished})
    self:PlayAnimation(self.In)
end

function M:OnInAnimFinished()
    self:PlayAnimation(self.Loop, 0, 0)
end


return M
