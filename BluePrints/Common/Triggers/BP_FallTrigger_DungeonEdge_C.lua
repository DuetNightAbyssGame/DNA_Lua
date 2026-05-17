--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_FallTrigger_DungeonEdge_C
local BP_FallTrigger_DungeonEdge_C = Class("BluePrints.Common.TimerMgr")

function BP_FallTrigger_DungeonEdge_C:Initialize(Initializer)
    self.InRange = false
end

-- function BP_FallTrigger_DungeonEdge_C:UserConstructionScript()
-- end

function BP_FallTrigger_DungeonEdge_C:ReceiveBeginPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:AddFallTriggerInfo(self)
    end
end

function BP_FallTrigger_DungeonEdge_C:ReceiveEndPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:RemoveFallTriggerInfo(self)
    end
end

function BP_FallTrigger_DungeonEdge_C:OnOverlapActorAround(OtherActor, OtherComponent)
    if not self.Active or UE4.UKismetMathLibrary.ClassIsChildOf(OtherComponent:GetClass(), UInteractiveBaseComponent:StaticClass()) then
        return
    end
    if IsClient(self) then
        return
    end
    DebugPrint("zwkkk BP_FallTrigger_DungeonEdge_C:OnOverlapActorAround ",OtherActor:GetName(),OtherActor.IsPlayer,OtherActor:IsPlayer())
    if OtherActor.IsPlayer and OtherActor:IsPlayer() then
        OtherActor.RPCComponent:OnPlayerEnterDungeonEdge(true)
    end
end

function BP_FallTrigger_DungeonEdge_C:OnOverlapActorInner(OtherActor, OtherComponent)
    if not self.Active or UE4.UKismetMathLibrary.ClassIsChildOf(OtherComponent:GetClass(), UInteractiveBaseComponent:StaticClass()) then
        return
    end
    if IsClient(self) then
        return
    end
    if OtherActor.IsPlayer and OtherActor:IsPlayer() then
        local ResComponent = self:GetNearestComponentTransform(OtherActor:K2_GetActorLocation())
        DebugPrint("zwkkk BP_FallTrigger_DungeonEdge_C:OnOverlapActorInner ", OtherActor:GetName())
        OtherActor.RPCComponent:OnTriggerFallTriggerEdge(
            OtherActor,
            ResComponent:K2_GetComponentToWorld(),
            self.MaxDis,
            self.DefaultEnable,
            self
        )
    end
end

function BP_FallTrigger_DungeonEdge_C:OnEndOverlapActorAround(OtherActor, OtherComponent)
    if not self.Active or UE4.UKismetMathLibrary.ClassIsChildOf(OtherComponent:GetClass(), UInteractiveBaseComponent:StaticClass()) then
        return
    end
    if IsClient(self) then
        return
    end
    if OtherActor.IsPlayer and OtherActor:IsPlayer() then
        OtherActor.RPCComponent:OnPlayerEnterDungeonEdge(false)
    end
end

function BP_FallTrigger_DungeonEdge_C:GetTransformParam(OtherActor)
    local Transform = nil
    if self.Reborn:Length() > 0 then
        Transform = self:GetNearestTransformByReborn(OtherActor:K2_GetActorLocation())
    else
        local ResComponent = self:GetNearestComponentTransform(OtherActor:K2_GetActorLocation())
        Transform = ResComponent:K2_GetComponentToWorld()
    end
    return Transform
end

return BP_FallTrigger_DungeonEdge_C
