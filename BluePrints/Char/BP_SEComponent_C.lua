--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_SEComponent_C = Class()

--function BP_SEComponent_C:Initialize(Initializer)
--end

--function BP_SEComponent_C:ReceiveBeginPlay()
--end

--function BP_SEComponent_C:ReceiveEndPlay()
--end

-- function BP_SEComponent_C:ReceiveTick(DeltaSeconds)
-- end

-- Weapon's SEComponent Play this
function BP_SEComponent_C:PlayGroupFMODSe(GroupName, Mesh, HitedLocation, SocketName)
    local PlayFMODSoundTransform = Mesh:GetSocketTransform(SocketName, UE4.ERelativeTransformSpace.RTS_Component)
    -- UEPrint(PlayFMODSoundTransform)
    local Effects = self.FMODEventEffects:Find(GroupName)
    for i,v in pairs(Effects.Effects) do
        local FMODEvent = v.AudioEvent
        UEPrint(UE4.UKismetSystemLibrary.GetDisplayName(FMODEvent))
        UE4.UFMODBlueprintStatics.PlayEventAtLocation(self, FMODEvent, PlayFMODSoundTransform, true)
    end
end

return BP_SEComponent_C
