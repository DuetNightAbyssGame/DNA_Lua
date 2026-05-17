--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_SaiqiShield_C = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
})

function BP_SaiqiShield_C:AuthorityInitInfo(Info)
    BP_SaiqiShield_C.Super.AuthorityInitInfo(self,Info)
    local BreakCountDef = self.UnitParams.BreakCountDef or 0
    self.BuffId = self.UnitParams.BuffId or 850201
    self.PlayerBuffId = self.UnitParams.PlayerBuffId or 850203
    self.BreakCount = 3
    -- Battle(self):AddBuffToTarget(self, self, self.BuffId, -1)
end

function BP_SaiqiShield_C:PlayerTouchSphere(Player, Sphere)
    -- Battle(self):AddBuffToTarget(self, Player, self.PlayerBuffId, -1)
    self:K2_DestroyComponent(Sphere)
    self:OnPlayerTouchSphere(Player, Sphere)
    self.BreakCount = self.BreakCount - 1
    if self.BreakCount == 0 then
        self:ShowDeath()
    end
end

function BP_SaiqiShield_C:OnPlayerTouchSphere(Player, Sphere)
    -- Battle(self):AddBuffToTarget(self, Player, self.PlayerBuffId, -1)
    
end

function BP_SaiqiShield_C:OnDead(KillMineRoleEid, KillMineSkillId)
    BP_SaiqiShield_C.Super.OnDead(self, KillMineRoleEid, KillMineSkillId)  
    self:EMActorDestroy(EDestroyReason.MechanismDead)
end

-- function BP_SaiqiShield_C:OnBreakCountDown(SourceEid, SkillId)
--     local Source = Battle(self):GetEntity(SourceEid)
--     UE4.UBattleFunctionLibrary.ReduceBuffLayerFromTarget(self, Source, self.PlayerBuffId,1)
--     UE4.UBattleFunctionLibrary.ReduceBuffLayerFromTarget(self, Source:GetDirectSource(true), self.PlayerBuffId, 1)
-- end

-- function BP_SaiqiShield_C:IsInvincible(Source)
--     self.bIsInvincible = true
--     if not UE4.UBattleFunctionLibrary.FindBuffSpecialEffect(self, "Invulnerability") then
--         self.bIsInvincible = false
--     end
--     if UE4.UBattleFunctionLibrary.FindBuffSpecialEffect(Source, "IgnoreInvulnerability") then
--         self.bIsInvincible = false
--     end
--     if UE4.UBattleFunctionLibrary.FindBuffSpecialEffect(Source:GetDirectSource(true), "IgnoreInvulnerability") then
--         self.bIsInvincible = false
--     end
--     return self.bIsInvincible or false
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

return BP_SaiqiShield_C
