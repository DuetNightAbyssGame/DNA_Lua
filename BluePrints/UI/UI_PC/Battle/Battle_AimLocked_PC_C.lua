--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Battle_AimLocked_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

-- function M:Destruct()
--     self:StopAllAnimations()
--     self:FlushAnimations()
-- end

-- function M:SetIsLocked(IsLocked)
--     if(self.IsLocked == IsLocked)then
--         return
--     end
--     if(IsLocked)then
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.LockOut)
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.UnLockOut)
--         EMUIAnimationSubsystem:EMPlayAnimation(self, self.LockIn)
--         AudioManager(self):PlayUISound(self, "event:/ui/common/enemy_focus", nil, nil)
--     else
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.LockIn)
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.LockLoop)
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.UnLockOut)
--         EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnLockIn)
--         AudioManager(self):PlayUISound(self, "event:/ui/common/enemy_unfocus", nil, nil)
--     end
--     self.IsLocked = IsLocked
-- end

-- function M:SetIsShow(IsShow)
--     if(self.IsShow == IsShow)then
--         return
--     end
--     if(IsShow)then
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.LockOut)
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.UnLockOut)
--         if(self.IsLocked)then
--             EMUIAnimationSubsystem:EMPlayAnimation(self, self.LockIn)
--         else
--             EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnLockIn)
--         end
--     else
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.LockIn)
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.LockLoop)
--         EMUIAnimationSubsystem:EMStopAnimation(self, self.UnLockIn)
--         if(self.IsLocked)then
--             EMUIAnimationSubsystem:EMPlayAnimation(self, self.LockOut)
--         else
--             EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnLockOut)
--         end
--     end
--     self.IsShow = IsShow
-- end

-- function M:BindAnim()
--     self:BindToAnimationFinished(self.LockIn, {self, self.PlayLoopAnim})
-- end

-- function M:PlayLoopAnim()
--     EMUIAnimationSubsystem:EMPlayAnimation(self, self.LockLoop, 0, true)
-- end

return M
