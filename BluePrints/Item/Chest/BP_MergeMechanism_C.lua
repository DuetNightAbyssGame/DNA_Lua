--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_MergeMechanism_C = Class()

--function BP_MergeMechanism_C:Initialize(Initializer)
--end

--function BP_MergeMechanism_C:UserConstructionScript()
--end

function BP_MergeMechanism_C:ReceiveBeginPlay()
    self.MergeList = {}
    self.MergeName = ""
    self.Num = 0
end

function BP_MergeMechanism_C:SetInteractiveName(Name)
    self.BP_MergeInteractiveComponent.InteractiveName = Name
end

function BP_MergeMechanism_C:AddMergeList(ActorName,Interactive)
    self.Num = self.Num + 1
    self.MergeList[ActorName] = Interactive
end

function BP_MergeMechanism_C:DeleteMergeList(ActorName)
    self.Num = self.Num - 1
    self.MergeList[ActorName] = nil
    if self.Num == 0 then
        return true
    end
    return false
end

--function BP_MergeMechanism_C:ReceiveEndPlay()
--end

-- function BP_MergeMechanism_C:ReceiveTick(DeltaSeconds)
-- end

--function BP_MergeMechanism_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_MergeMechanism_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_MergeMechanism_C:ReceiveActorEndOverlap(OtherActor)
--end

return BP_MergeMechanism_C
