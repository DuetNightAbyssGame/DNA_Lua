--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_GuideMan_C

local BP_GuideMan_C = Class("BluePrints.Char.BP_NPC_C")

function BP_GuideMan_C:InitCharacterInfo(Info)
    BP_GuideMan_C.Super.InitCharacterInfo(self, Info)
    if Info.LoadFinishCallback then
        Info.LoadFinishCallback(self)
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

return BP_GuideMan_C
