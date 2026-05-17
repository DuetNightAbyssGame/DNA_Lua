--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
---@type BP_HitSwitchBase_C

local M = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})
function M:OnBreakCountDown(SourceEid)
    M.Super.OnBreakCountDown(self, SourceEid)
    self:ChangeState("Hit", SourceEid)
end

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self, Info)
    Battle(self):AddBuffToTarget(self, self, 5000017, -1, nil, nil)
    self.JumpWordComponent:K2_DestroyComponent(self)
end

function M:ClientInitInfo(Info)
    M.Super.ClientInitInfo(self, Info)
    self.BillboardComponent.IsInit = true
end

function M:OnStateChangeCountDownLua(RemainTimePercent, RemainTime)
    -- 多点破坏玩法通常只会同时存在一个机关在倒计时，先这样做吧
    EventManager:FireEvent(EventID.OnRepHitSwitchTimer, RemainTimePercent)
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
