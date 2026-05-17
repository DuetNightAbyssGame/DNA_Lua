--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_AOITriggerBox_StopTrolly_C
local M = Class("BluePrints.Common.Triggers.BP_AOITriggerBox_C")

function M:AuthorityInitInfo(Info)
    print(_G.LogTag,"LXZ SpawnTriggerBox AuthorityInitInfo", self:GetName())
    M.Super.AuthorityInitInfo(self,Info)
    self.PathPoint = Info:FindObjectParams("TriggerCreator")
    local GameState = UGameplayStatics.GetGameState(self)
    if GameState then
        local Location = self:K2_GetActorLocation()
        local LastNum = GameState.StopTrollyBoxLocation:Num()
        GameState.StopTrollyBoxLocation:AddUnique(Location)
        local NewNum = GameState.StopTrollyBoxLocation:Num()
        DebugPrint("StopTrollyBoxLocation add location:", Location.X, " ", Location.Y, " ", Location.Z)
        DebugPrint("StopTrollyBoxLocation LastNum:", LastNum, " NewNum:", NewNum)
        -- 避免时序问题导致DungeonHijackFloat_C的InitAllTargetPoint只在StopTrollyBoxLocation统计完成前调用
        if NewNum > LastNum then
            EventManager:FireEvent(EventID.OnDungeonUIStateUpdated)
            GameState:MarkDirty_StopTrollyBoxLocation()
        end
    end
end

function M:GetUnitRealType()
	return "AOITriggerBox"
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

function M:CollisionBeginOverlap(Component, OtherActor)
    if not OtherActor.IsCombatItemBase or not OtherActor:IsCombatItemBase("Trolly") then
        if OtherActor.IsCombatItemBase then
            print(_G.LogTag,"LXZ CollisionBeginOverlap", OtherActor:IsCombatItemBase("Trolly"))
        end
        return
    end
    -- OtherActor.ForceStop = true
	OtherActor:TriggerBoxStop()

    local Index
    for i,Point in pairs(OtherActor.Spline.PointMap) do
        if Point == self.PathPoint then
            Index = i
            break
        end
    end
    if Index ~=nil then 
        local TempDis = OtherActor.Spline.Spline:GetDistanceAlongSplineAtSplinePoint(Index-1)
        local Dis = TempDis - OtherActor.Distance
        OtherActor.CurrentAccelerationValue = -1 * OtherActor.Speed * OtherActor.Speed / 2 / Dis 
    end

    M.Super.CollisionBeginOverlap(self, Component, OtherActor)
end

function M:OnEMActorDestroy(DestroyReason)
    self.Overridden.OnEMActorDestroy(self,DestroyReason)
    print(_G.LogTag,"LXZ OnEMActorDestroy", DestroyReason)
end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
