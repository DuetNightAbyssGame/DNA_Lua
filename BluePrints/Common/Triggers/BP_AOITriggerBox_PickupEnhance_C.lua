--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_AOITriggerBox_PickupEnhance_C
local M = Class("BluePrints.Common.Triggers.BP_AOITriggerBox_C")

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    M.Super.ReceiveBeginPlay(self)
    self.Eid2TickInterval = {}
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

function M:OnActorOverlap(OtherActor, TriggerType)
    if OtherActor.InitSuccess then
        local InteractiveComponent = OtherActor:GetComponentByClass(UInteractiveTriggerComponent)
		if InteractiveComponent then
            if TriggerType == "BeginOverlap" then
                self.Eid2TickInterval[OtherActor.Eid] = InteractiveComponent:GetComponentTickInterval()
                InteractiveComponent:SetComponentTickInterval(self.TargetInterval)
                DebugPrint("BP_AOITriggerBox_PickupEnhance_C SetComponentTickInterval Begin", self.TargetInterval)
            elseif TriggerType == "EndOverlap" then
                InteractiveComponent:SetComponentTickInterval(self.Eid2TickInterval[OtherActor.Eid])
                DebugPrint("BP_AOITriggerBox_PickupEnhance_C SetComponentTickInterval End", self.Eid2TickInterval[OtherActor.Eid])
                self.Eid2TickInterval[OtherActor.Eid] = nil
            end
		end
    end
end

function M:CheckCanTrigger(TriggerActor)
    return true
end

return M
