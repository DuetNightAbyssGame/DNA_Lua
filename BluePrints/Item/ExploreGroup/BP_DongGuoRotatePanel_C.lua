--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type BP_DongGuoRotatePanel_C
local M = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
})
function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    local CorrectDirection = self.UnitParams["CorrectDirection"]
    if CorrectDirection == "X" then
        self:SetPanelCorrectDirction(0)
    elseif CorrectDirection == "-X" then
        self:SetPanelCorrectDirction(1)
    elseif CorrectDirection == "Y" then
        self:SetPanelCorrectDirction(2)
    elseif CorrectDirection == "-Y" then
        self:SetPanelCorrectDirction(3)
    elseif CorrectDirection == "Z" then
        self:SetPanelCorrectDirction(4)
    elseif CorrectDirection == "-Z" then
        self:SetPanelCorrectDirction(5)
    end
    self.SkipDetection = self.UnitParams["SkipDetection"] or false
end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
