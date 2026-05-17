require "UnLua"

local BP_MiniGame_Training_C = Class( "BluePrints/Item/MiniGame/BP_OpenUIMechanism_C")

function BP_MiniGame_Training_C:OpenMechanism(Id)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:LoadUINew("TrainingGroundSetup")
end

function BP_MiniGame_Training_C:CloseMechanism(PlayerId)
    -- 机关配表有大问题，1.2重做
    -- if IsAuthority(self) then
    --     self.CombatStateChangeComponent:TriggerOnEventEnd(self.UINextStateId)
    --     print(_G.LogTag,"LXZ CloseMechanism", self.bIsSuccess, PlayerId)
    --     if self.bIsSuccess then
    --         self:ChangeState("InteractDone", PlayerId)
    --     else
    --         self:ChangeState("InteractBreak", PlayerId)
    --     end
    -- end
    -- self:BroadcastCloseMechanism(PlayerId)
end

return BP_MiniGame_Training_C