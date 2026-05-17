
require "UnLua"

local BP_MechanismDoorBase_C = Class()

--function BP_MechanismBase_C:Initialize(Initializer)
--end

--function BP_MechanismBase_C:UserConstructionScript()
--end

function BP_MechanismDoorBase_C:ReceiveBeginPlay()
    self.State = 0
end

--function BP_MechanismBase_C:ReceiveEndPlay()
--end

-- function BP_MechanismBase_C:ReceiveTick(DeltaSeconds)
-- end

function BP_MechanismDoorBase_C:ReceiveActorBeginOverlap(OtherActor)
end

function BP_MechanismDoorBase_C:ReceiveActorEndOverlap(OtherActor)
end

return BP_MechanismDoorBase_C
