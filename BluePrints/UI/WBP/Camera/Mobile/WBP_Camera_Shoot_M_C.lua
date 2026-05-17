--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Camera_Shoot_M_C
local M = Class("BluePrints.UI.WBP.Camera.Mobile.WBP_Camera_ComBtn_M_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:PlayLoopRemind()
    if(not self:IsAnimationPlaying(self.Remind))then
        self:BindToAnimationFinished(self.Remind, {self, self.OnRemindAnimationFinished})
        self:PlayAnimation(self.Remind)
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_bite", "Camera_Find_Target_Remind", nil)
    end
end

function M:StopLoopRemind()
    if(self:IsAnimationPlaying(self.Remind))then
        self:StopAnimation(self.Remind)
    end
    AudioManager(self):StopSound(self, "Camera_Find_Target_Remind")
    self:UnbindFromAnimationFinished(self.Remind, {self, self.OnRemindAnimationFinished})
end

function M:OnRemindAnimationFinished()
    self:PlayAnimation(self.Remind)
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_bite", "Camera_Find_Target_Remind", nil)
end

function M:OnBtnClicked()
    M.Super.OnBtnClicked(self)
end

return M
