--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_EvacuationPoint_C
local M = Class("BluePrints.Item.BP_CombatItemBase_C")

function M:OnPlayerEnter(Player)
    if self.HasEntered == true then
        return
    end
    self.HasEntered = true
    DebugPrint(Player:GetName(),"Player Enter EvacuationPoint =============================")
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    DebugPrint("==============TriggerGameModeEvent: OnTempleSuccess====================")
    GameMode:TriggerGameModeEvent("OnTempleSuccess", self)
end

return M
