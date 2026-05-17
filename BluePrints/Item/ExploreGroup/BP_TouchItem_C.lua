--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TouchItemBase_C
local M = Class("BluePrints/Item/BP_CombatItemBase_C")

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    if not self.ToughRange then
        return
    end
    self.bTouched = false
    --ToughRange蓝图内的默认碰撞请设为NoCollision
    self.ToughRange.OnComponentBeginOverlap:Add(self, self.OnStartTough)
    self.ToughRange.OnComponentEndOverlap:Add(self, self.OnEndTough)
    self.ToughRange:SetCollisionProfileName("OnlyPlayer", true)
end

function M:OnStartTough(Component, OtherActor, OtherComp)
    print(_G.LogTag, "LXZ OnStartTough",OtherComp:GetName(), OtherActor:GetName())
    if self.bTouched or not self.bCanTouch then
        self.bTouched = true
        return
    end
    self.bTouched = true
    --默认都是摸到就切状态
    self:ChangeState("TriggerBox")
end

function M:OnEndTough(Component, OtherActor, OtherComp)
    if not self.bTouched or not self.bCanTouch then
        self.bTouched = false
        return
    end
    self.bTouched = false
    -- --默认都是离开就切状态
    -- self:ChangeState("LeaveTriggerBox")
end

--踩石块探索组石块专用
function M:OnExploreStoneShowEnd()
    if not self.ShowEndCallback then
        return
    end
    self:ShowEndCallback()
end

function M:ReceiveBeginPlay()
    if not self.ToughRange then
        return
    end
    self.ToughRange:SetCollisionEnabled(0)
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
--     print(_G.LogTag,"LXZ ReceiveActorBeginOverlap", OtherActor:GetName())
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
