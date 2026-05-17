--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class({
    "BluePrints/Item/DefenceCore/BP_DefenceMechanism_C",
})

function M:GetCanOpen()
    self.CanOpen = true
end

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)
    self.IsPetDefenceMechanism = true
end

function M:GetGuidePos()
    return self:K2_GetActorLocation()+self.GuidePos.RelativeLocation
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
