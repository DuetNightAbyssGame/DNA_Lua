--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local LuaConst = require("EMLuaConst")
local BP_TrainingSetupInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

function BP_TrainingSetupInteractiveComponent_C:IsCanInteractive(PlayerActor)
    if LuaConst.OpenComputeInteractive then
        return self:GetDistanceCheckResult()
    else
        return self.DistanceCheck(self:GetOwner(), PlayerActor, self.InteractiveDistance)
    end
end

function BP_TrainingSetupInteractiveComponent_C:BtnClicked(PlayerActor, InPressTimeSeconds)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:LoadUINew("TrainingGroundSetup")
end

return BP_TrainingSetupInteractiveComponent_C

