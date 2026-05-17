--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeWeekly_Hud_KeySubItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.ParentWidget = Content.ParentWidget
    Content.SelfWidget = self
    self.Index = Content.Index
    self:UpdateState(Content.State)
end

function M:UpdateState(NewState)
    self.State = NewState
    self:StopAllAnimations()
    if self.State == "Normal" then
        self:PlayAnimation(self.Empty)
    elseif self.State == "Highlight" then
        self:PlayAnimation(self.Highlight)
    elseif self.State == "Activated" then
        self:PlayAnimation(self.Activated)
        AudioManager(self):PlayUISound(self, "event:/ui/common/week_level_get_key", nil, nil)
    end
end


return M
