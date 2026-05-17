--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_DoubleVentilator_C
local M = Class("BluePrints.Item.BP_CombatItemBase_C")

-- function M:CommonInitInfo(Info)
--     M.Super.CommonInitInfo(self,Info)
--     DebugPrint("BP_DoubleVentilator_C===========CommonInitInfo=============================")
--     if self.IsOpen then
--         self:ActiveCombat()
--     end
-- end

function M:ActiveCombat(bFromGameMode)
    DebugPrint("ActiveCombat BP_DoubleVentilator_C ==========================")
    self.IsOpen = true

end

function M:InactiveCombat(bFromGameMode)
    DebugPrint("InactiveCombat BP_DoubleVentilator_C =============================")
    self.IsOpen = false
end

function M:ResetInfo()
    self:InactiveCombat()
end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self,DeltaSeconds)
end

-- function M:Initialize(Initializer)
-- end

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
