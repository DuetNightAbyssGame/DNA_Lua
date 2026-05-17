--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_WuYouShengItem_C
require "UnLua"
local M = Class({
    "BluePrints/Item/ExploreGroup/BP_DongGuoBreakableItem_C",
})

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)
    self.TotalTime = self.UnitParams["TotalTime"] or 5
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self,Info)
    if Info.Creator and Info.Creator.TriggerBoxContent:Size() > 0 then
        self.ActiveTrigger:SetBoxExtent(Info.Creator.TriggerBoxContent, Info.Creator.TriggerTipsBoxContent)
    end
    print(_G.LogTag,"LXZ OnActorReady", self:GetName())
    self.ActiveTrigger.OnComponentBeginOverlap:Add(self, self.CollisionBeginOverlap)
    self.ActiveTrigger.OnComponentEndOverlap:Add(self, self.CollisionEndOverlap)
    self.ActiveTrigger:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
end

function M:CollisionBeginOverlap(Component, OtherActor)
    print(_G.LogTag,"LXZ CollisionBeginOverlap")
    if OtherActor.IsPlayer and OtherActor:IsPlayer() then
        self:ChangeState("TriggerBox")
    end
end

function M:CollisionEndOverlap(Component, OtherActor)
    if OtherActor.IsPlayer and OtherActor:IsPlayer() then
        self:ChangeState("TriggerBox")
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
