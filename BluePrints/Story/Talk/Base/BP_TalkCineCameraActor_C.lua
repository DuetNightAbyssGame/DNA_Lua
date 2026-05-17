--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_TalkCineCameraActor_C = Class()


function BP_TalkCineCameraActor_C:Initialize(Initializer)
    self.end_view_target_callback={}
end

function BP_TalkCineCameraActor_C:K2_OnEndViewTarget(player_controller)
    for func,obj in pairs(self.end_view_target_callback) do
        func(obj)
    end
    print(_G.Log,"End view Target")
end

function BP_TalkCineCameraActor_C:BindEndViewTargetCallback(object,func)
    self.end_view_target_callback[func]=object
end

function BP_TalkCineCameraActor_C:UnBindEndViewTargetCallback(func)
    self.end_view_target_callback[func]=nil
end

--function BP_TalkCineCameraActor_C:UserConstructionScript()
--end

--function BP_TalkCineCameraActor_C:ReceiveBeginPlay()
--end

--function BP_TalkCineCameraActor_C:ReceiveEndPlay()
--end

-- function BP_TalkCineCameraActor_C:ReceiveTick(DeltaSeconds)
-- end

--function BP_TalkCineCameraActor_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_TalkCineCameraActor_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_TalkCineCameraActor_C:ReceiveActorEndOverlap(OtherActor)
--end

return BP_TalkCineCameraActor_C
