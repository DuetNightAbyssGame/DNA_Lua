--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_RotateTrap_C
require "UnLua"
local M = Class({
    "BluePrints.Item.CombatProp.BP_CombatPropBase_C",
    "BluePrints.Common.TimerMgr"
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self, Info)
    -- self.SkillEffect = self.UnitParams["SkillEffect"]
    -- self.MonEffect = self.UnitParams["MonEffect"]
    self.AttackCD = self.UnitParams["AttackCD"]
    self.Rotator = FRotator(0, 0, self.RotateSpeed)
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    -- local Components = self:K2_GetComponentsByClass(UE.UStaticMeshComponent)
    -- for _, v in pairs(Components) do
    --     v.OnComponentBeginOverlap:Add(self, self.OnOverlap)
    -- end

    self.InstancedStaticMesh.OnComponentBeginOverlap:Add(self, self.OnOverlap)
    -- self.InstancedStaticMesh.OnComponentEndOverlap:Add(self, self.OnEndOverlap)
    self.InstancedMesh = self.InstancedStaticMesh
    self.RotSpeed = self.RotateSpeed
end

function M:OnOverlap(OverlappedComponent, OtherActor, OtherComp,OtherBodyIndex, bFromSweep, SweepResult)
    -- DebugPrint("zwkkk OnOverlap",OtherActor:GetName(),OtherActor.RotateTrapAttacking,OtherActor.IsPlayer,OtherComp:GetName(),GWorld:GetCurrentTime())
    if not self.IsActive then return end
    if not OtherActor.RotateTrapAttacking and OtherActor:IsDead() ~= true and (OtherActor.IsPlayer or OtherActor.IsRealMonster) then
        OtherActor.RotateTrapAttacking = true
        local function ResetTargetAcorTrapAttack()
            OtherActor.RotateTrapAttacking = false
        end
        self:AddTimer(self.AttackCD, ResetTargetAcorTrapAttack, false, 0)
        self.Super.PropAttack(self, OtherActor)
    end
end

function M:OnEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)

end

function M:ActiveCombat()
    M.Super.ActiveCombat(self)
    self:OnTrapActive()
    self:SetActorTickEnabled(true)
end

function M:DeActiveCombat()
    M.Super.DeActiveCombat(self)
    self:OnTrapDeActive()
    self:SetActorTickEnabled(false)
end

-- function M:ReceiveTick(DeltaSeconds)
--     self.Overridden.ReceiveTick(self, DeltaSeconds)
--     if not self.IsActive then return end
--     self.InstancedStaticMesh:K2_AddRelativeRotation(FRotator(0, self.RotateSpeed * DeltaSeconds, 0), false, nil, false)
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
