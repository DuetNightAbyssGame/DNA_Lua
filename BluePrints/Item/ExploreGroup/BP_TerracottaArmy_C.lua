--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type BP_TerracottaArmy_C
local M = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self, Info)
    -- self.EnemyStateId = self.UnitParams["EnemyStateId"] or 9999902
    -- self.BreakStateId = self.UnitParams["BreakStateId"] or 9999903
    self.bAutoBomb = self.UnitParams["bAutoBomb"]
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    -- self:CheckAutoBomb()
end

function M:CheckInCamera()
    local bShouldShow = URuntimeCommonFunctionLibrary.WasComponentRecentlyRenderedOnScreen(self.StaticMesh, 0.5)
    return bShouldShow
end

-- function M:AfterBeCutToughness(CurrentTN)
--     if self.EnemyStateId == self.StateId then
--         return
--     end
--     local MaxTN = self:GetAttr("MaxTN")
--     local Rate = CurrentTN / MaxTN
--     if Rate > 0.5 then
--         return
--     end
--     self:ChangeState("Manual", 0, self.EnemyStateId)
-- end

-- function M:OnToughnessToZero()
--     self:ChangeState("Manual", 0, self.BreakStateId)
-- end

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
