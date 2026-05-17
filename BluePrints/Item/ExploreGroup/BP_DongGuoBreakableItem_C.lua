--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

--东国破碎物专用基类

---@type BP_DongGuoBreakableBase_C
require "UnLua"

local M = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

--具有Energy的破碎物，Energy归零
function M:OnEnergyZero()
    print(_G.LogTag,"LXZ OnEnergyZero")
    self.Overridden.OnEnergyZero(self)
    if self.EnergyZeroStateId == 0 then
        return
    end
    self:ChangeState("Manual", 0, self.EnergyZeroStateId)
end

function M:OnEnergyMax()
    print(_G.LogTag,"LXZ OnEnergyMax")
    self.Overridden.OnEnergyMax(self)
    if self.EnergyMaxStateId == 0 then
        return
    end
    self:ChangeState("Manual", 0, self.EnergyMaxStateId)
end

function M:OnEnergyChange()
    print(_G.LogTag,"LXZ OnEnergyChange",self.Energy)
    if self.NeedStopEvent and self.LastEnergy ~= nil and self.LastEnergy > self.Energy then
        self:CheckEnergyStop()
    end
    self.LastEnergy = self.Energy
    self.Overridden.OnEnergyChange(self)
    if self.Energy <= 0 then
        self:OnEnergyZero()
    elseif self.Energy >= self.MaxEnergy then
        self:OnEnergyMax()
    end
end

function M:CheckEnergyStop()
    if not self.bEnergyChanging then
        self.bEnergyChanging = true
        self:AddTimer(self.StopEventTime, self.SetEnergyChanging, false, -0.1, "CheckEnergyStop")
    else
        self:RemoveTimer("CheckEnergyStop")
        self:AddTimer(self.StopEventTime, self.SetEnergyChanging, false, -0.1, "CheckEnergyStop")
    end
end

function M:SetEnergyChanging()
    self.bEnergyChanging = false
    self:OnEnergyChangeStop()
end

function M:OnEnergyChangeStop()
    print(_G.LogTag,"LXZ OnEnergyChangeStop",self.Energy)
    self.Overridden.OnEnergyChangeStop(self)
end

function M:OnBreakCountDownTag(Tag, SkillId, InSourceEid)
    if self.WeaponEffectType ~= 0 then
        local Source = Battle(self):GetEntity(InSourceEid)
        if Source:IsPlayer() then
            self:SetWeaponEffect(Source)
        end
    end
    self.Overridden.OnBreakCountDownTag(self, Tag, SkillId, InSourceEid)
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
