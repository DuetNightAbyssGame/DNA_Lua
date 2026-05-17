--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "Unlua"
---@type BP_PrologueYinbimen_C
local M = Class("BluePrints.Item.Mechanism.BP_PrologueDoor")

function M:ReceiveBeginPlay()
    M.Super.ReceiveBeginPlay(self)
    if not self.InitSuccess then
        self:InitActorInfo()
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
