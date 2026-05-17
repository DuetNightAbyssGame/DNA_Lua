--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Slide_C
require "UnLua"
local M = Class("BluePrints.Item.BP_CombatItemBase_C")

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    DebugPrint("zwkk OnActorReady lua")
    -- EventManager:AddEvent(EventID.OnBulletJumpStarted, self, self.OnBulletJumpStarted)
    EventManager:AddEvent(EventID.OnJumpPressed, self, self.OnJumpPressed)
end

-- function M:OnBulletJumpStarted()
--     DebugPrint("zwkk OnBulletJumpStarted lua")
-- end

function M:OnJumpPressed()
    --DebugPrint("zwkk OnJumpPressed lua")
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    self:TestFun(Player)
end

function M:OnPlayerIn(Player)
    Player.NeedJumpEvent = true
end

function M:OnPlayerLeave(Player)
    Player.NeedJumpEvent = false
end

return M
