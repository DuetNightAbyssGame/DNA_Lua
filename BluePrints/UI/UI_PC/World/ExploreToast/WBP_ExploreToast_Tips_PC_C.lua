--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_ExploreToast_Tips_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
    local Content,LastTime,Title = ...
    if not LastTime then
        LastTime = 3
    end
    self.Text_Toast_Tips:SetText(GText(Content))
    if Title then
        self.Text_Title:SetText(GText(Title))
    end
    self:PlayAnimation(self.In)
    self:AddTimer(LastTime, self.PlayOutAnim)
end

function M:PlayOutAnim()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self.Super.Close(self)
    end
end

return M
