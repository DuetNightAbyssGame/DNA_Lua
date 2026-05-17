--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_EliteBar_C
local WBP_EliteBar_C = Class("BluePrints.UI.BP_UIState_C")

-- function WBP_EliteBar_C:Initialize(Initializer)
--     self.Super.Initialize(self)
-- end

-- function WBP_EliteBar_C:Init()
--     self:SetVisibility(UE4.ESlateVisibility.Collapsed)
-- end

-- function WBP_EliteBar_C:SetInvincible(bIsInvincible)
--     if bIsInvincible then
--         self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         local AnimTime = self.invincibility:GetEndTime()
--         local PlayLoopAnimation = function()
--             self:PlayAnimation(self.invincibility)
--         end
--         self:AddTimer(AnimTime, PlayLoopAnimation, true, 0, "PlayLoopAnimation")
--     else
--         self:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         if (self:IsExistTimer("PlayLoopAnimation")) then
--             self:RemoveTimer("PlayLoopAnimation")
--         end
--         self:StopAnimation(self.invincibility)
--     end
-- end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return WBP_EliteBar_C
