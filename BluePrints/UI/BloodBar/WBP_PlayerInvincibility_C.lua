--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_PlayerPlayerInvincibility_C
local WBP_PlayerPlayerInvincibility_C = Class("BluePrints.UI.BP_UIState_C")

-- function WBP_PlayerPlayerInvincibility_C:Initialize(Initializer)

-- end

-- function WBP_PlayerPlayerInvincibility_C:Init()
--     self:SetVisibility(UE4.ESlateVisibility.Collapsed)
-- end

-- function WBP_PlayerPlayerInvincibility_C:SetInvincible(bIsInvincible)
--     if bIsInvincible then
--         self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Group_VXInvincibility:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         local AnimTime = self.Player_Invincibility:GetEndTime()
--         local PlayLoopAnimation = function()
--             self:PlayAnimation(self.Player_Invincibility)
--         end
--         self:AddTimer(AnimTime, PlayLoopAnimation, true, 0, "PlayLoopAnimation")
--     else
--         self:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         if (self:IsExistTimer("PlayLoopAnimation")) then
--             self:RemoveTimer("PlayLoopAnimation")
--         end
--         self:StopAnimation(self.Player_Invincibility)
--     end
-- end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return WBP_PlayerPlayerInvincibility_C
