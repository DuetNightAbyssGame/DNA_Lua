--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_FakeCharacter_C
local M = Class("BluePrints.Char.BP_CharacterBase_C")

function M:Initialize(Initializer)
end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.InitSuccess = true
    self:ForceSetCanExtractZVelocity()
    self:GetMovementComponent():SetMovementMode(EMovementMode.MOVE_Flying)
end

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

function M:InitFakeCharacter(Info)
    self.InitInfo = Info
    self.ShadowModelId = Info.ShadowModelId
    self.CurrentRoleId = Info.CurrentRoleId
    self.ModelId = Info.ModelId
    self:GetCharModelComponent():LoadCurrentModel()
end

function M:GetObjType()
    return EObjType.FakeCharacter
end


function M:CheckCanPart()
    return self.InitInfo.CanPart
end

return M
