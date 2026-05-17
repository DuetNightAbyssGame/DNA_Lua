--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_ExploreGroup_WuYouSheng_C
local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

function M:SetTeleportGateTarget(StaticCreatorComp, InTransform)
    if StaticCreatorComp.ChildEids:Length() == 0 then
        return
    end
    local Mechanism = Battle(self):GetEntity(StaticCreatorComp.ChildEids[1])
    if not Mechanism or not Mechanism.SetTeleportDestLocation then
        return
    end
    Mechanism:SetTeleportDestLocation(InTransform.Translation)
    Mechanism:SetTeleportDestRotation(InTransform.Rotation:ToRotator())
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
