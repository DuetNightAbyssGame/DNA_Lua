
require "UnLua"
local Const = require "Const"

local BP_NewTargetPoint = Class({
    "BluePrints.Common.TimerMgr",
}
)

function BP_NewTargetPoint:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
    self.TargetPointTriggerBoxHandle = nil
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if self.TargetPointType == Const.Common then
        GameState:AddTargetPointInfo(self)
    elseif self.TargetPointType == Const.Hijack then
        GameState:AddHijackPointInfo(self)
    elseif self.TargetPointType == Const.RougeLike then
        GWorld.RougeLikeManager:AddDeliveryPointInfo(self)
    end

    if IsAuthority(self) and self.SpawnTriggerBoxId ~= -1 and self.SpawnBoxType == ENTPSpawnBoxType.ReceiveBegin then
        if GameState.GameModeState < Const.StateRunning then
            self.TargetPointTriggerBoxHandle = self:AddTimer(0.5, self.SpawnTriggerBox, true, 1, "TargetPointTriggerBoxHandle")
        else
            self:SpawnTriggerBox()
        end
    end
end

function BP_NewTargetPoint:ReceiveEndPlay()
end

function BP_NewTargetPoint:SpawnTriggerBox()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState.GameModeState < Const.StateRunning then
        return
    end
    self:RemoveTimer(self.TargetPointTriggerBoxHandle)
    self.TargetPointTriggerBoxHandle = nil
    local function SaveBox(_, Unit)
        self.SaveTrggerBox = Unit
    end
    local TriggerEventId = tonumber(self.PathId.."0000"..self.PathPointIndex)
    local Context = AEventMgr.CreateUnitContext()
    Context.UnitType = "Mechanism"
    Context.UnitId = self.SpawnTriggerBoxId
    Context.Loc = self:K2_GetActorLocation()
    Context.IntParams:Add("TriggerEventId", TriggerEventId)
    Context:AddObjectParams("TriggerCreator", self)
    Context.OnUnitInitCreateReadyDynamic:Add(self, SaveBox)
    DebugPrint("BP_NewTargetPoint:SpawnTriggerBox", Context.UnitId, TriggerEventId)
    GameState.EventMgr:CreateUnitNew(Context, false)
    
end

function BP_NewTargetPoint:DestroyTriggerBox(Reason)
    if self.SaveTrggerBox and IsValid(self.SaveTrggerBox) then
        self.SaveTrggerBox:EMActorDestroy(Reason)
    else
        GWorld.logger.errorlog("DisactiveNewTargetPointAOITrigger_Region 接口销毁触发盒失败，NewTargetPoint没存下触发盒")
    end

end

return BP_NewTargetPoint