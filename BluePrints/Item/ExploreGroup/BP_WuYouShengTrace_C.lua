--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_WuYouShengTrace_C
local M = Class("BluePrints/Item/BP_CombatItemBase_C")

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)
    self.BuffId = self.UnitParams["BuffId"] or 5000206
    self.BuffTime = self.UnitParams["BuffTime"] or 3
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self,Info)
    if Info.Creator then
        self.Box:SetBoxExtent(Info.Creator.TriggerBoxContent, Info.Creator.TriggerTipsBoxContent)
    end
    self.Box.OnComponentBeginOverlap:Add(self, self.CollisionBeginOverlap)
    self.Box:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
end

function M:CollisionBeginOverlap(Component, OtherActor)
    if OtherActor.IsPlayer and OtherActor:IsPlayer() then
        Battle(self):AddBuffToTarget(OtherActor, OtherActor, self.BuffId, self.BuffTime, 0, nil, 1)
    end
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
