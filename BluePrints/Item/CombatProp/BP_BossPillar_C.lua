--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_Pillar_ShiJingZhe_C = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

function BP_Pillar_ShiJingZhe_C:AuthorityInitInfo(Info)
    BP_Pillar_ShiJingZhe_C.Super.AuthorityInitInfo(self, Info)
    self:AdjustTransform()
end

function BP_Pillar_ShiJingZhe_C:ShowDeath()
    self.Overridden.ShowDeath(self)
end

function BP_Pillar_ShiJingZhe_C:AdjustTransform()
    local Scale = self.UnitParams["Scale"]
    if not Scale then
        return
    end
    local CurrentScale = self:GetActorScale3D()
    local BodySize = self.BodyCollision.BoxExtent
    local CurrentLocation = self:K2_GetActorLocation()
    self:SetActorScale3D(FVector(Scale[1], Scale[2], Scale[3]))

    local ResX = (Scale[1] - CurrentScale.X) * BodySize.X
    local ResY = (Scale[2] - CurrentScale.Y) * BodySize.Y
    local ResZ = (Scale[3] - CurrentScale.Z) * BodySize.Z
    local Res = FVector(ResX, ResY, ResZ)
    -- Res = UKismetMathLibrary.GreaterGreater_VectorRotator(Res, self:K2_GetActorRotation())
    self:K2_SetActorLocation(Res + CurrentLocation, false, nil, false)
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function BP_Pillar_ShiJingZhe_C:ReceiveTick(DeltaSeconds)
--     print(_G.LogTag,self.Data)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return BP_Pillar_ShiJingZhe_C
