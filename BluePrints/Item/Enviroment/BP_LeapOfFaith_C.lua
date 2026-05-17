--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_LeapOfFaith_C
local M = Class("BluePrints.Item.BP_CombatItemBase_C")

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self, Info)
    self.EffectId = self.UnitParams["EffectId"] or 900012
    self:BindEvent()
    self.OnLeaping = false
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    if IsAuthority(self) then
        -- Battle(self):RegisterBattleEvent(BattleEventName.EnterLanding, self, "OnCharacterEnterLanding")
        self:RegisterEnterLandingBattleEvent(self, "OnCharacterEnterLanding")
    end
end

function M:BindEvent()
    self.End.OnComponentBeginOverlap:Add(self, self.OnPlayerEnterEndBox)
    self.Start.OnComponentEndOverlap:Add(self, self.OnPlayerLeaveStartBox)
end

function M:OnPlayerLeaveStartBox(Component, OtherActor)
    if not OtherActor:IsPlayer() then
        return
    end
    self.OnLeaping = true
end

function M:OnPlayerEnterEndBox(Component, OtherActor)
    if not OtherActor:IsPlayer() or not self.OnLeaping then
        return
    end
    self:ChangeState("TriggerBox")
    local EffectLoc = self.GrassEffectLoc:K2_GetComponentLocation()
    local EffectRot = self.GrassEffectLoc:K2_GetComponentRotation()
    self.FXComponent:PlayEffectByIDParams(self.EffectId, {
        UseAbsoluteLocation = true,
        Location = {EffectLoc.X, EffectLoc.Y, EffectLoc.Z},
        Rotation = {EffectRot.Pitch, EffectRot.Yaw, EffectRot.Roll}
    })
end

function M:OnCharacterEnterLanding(Character, Speed)
    if not Character:IsPlayer()then
        return
    end
    self.OnLeaping = false
end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
