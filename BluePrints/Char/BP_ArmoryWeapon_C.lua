--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type ArmoryWeapon_C
local M = Class()

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    self.HideTags = {}
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

function M:SetActorHideTag(Tag,bHidden)
    if(bHidden)then
        self.HideTags[Tag] = true
    else
        self.HideTags[Tag] = nil
    end
    if(next(self.HideTags))then
        self:SetActorHiddenInGame(true)
    else
        self:SetActorHiddenInGame(false)
    end
end

function M:ForceClearActorHideTag()
    self.HideTags = {}
    self:SetActorHiddenInGame(false)
end

return M
