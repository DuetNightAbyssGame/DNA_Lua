--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_AOITriggerBox_Excavation_C
local M = Class("BluePrints.Common.Triggers.BP_AOITriggerBox_C")

function M:SetBoxExtent_Lua(Size)
    local Info = DataMgr[self.UnitType][self.UnitId]
    local X = Info.UnitParams["X"] or 100
    local Y = Info.UnitParams["Y"] or 100
    local Z = Info.UnitParams["Z"] or 100
    M.Super.SetBoxExtent_Lua(self,FVector(X,Y,Z))
end

function M:InitTriggerEventId(Info)
    -- 处理 挖掘玩法 触发盒
    self.TriggerEventId = self.UnitId
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
