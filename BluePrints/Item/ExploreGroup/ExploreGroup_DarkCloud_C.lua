--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type Explore_DarkCloud_C
local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

function M:GetChildCloudLoc()
    if not self.ChildCloudNum then
        self.ChildCloudNum = 0
    end

    local Locs = {}
    for i = 1, self.ChildCloudNum do 
        table.insert(Locs, self["ChildCloud"..i]:K2_GetComponentLocation())
    end
    return Locs
end

function M:GetChildCloudNum()
    return self.ChildCloudNum or 0
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
