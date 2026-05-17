--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Bird_Feina_C
require "UnLua"
local M = Class("BluePrints.Item.BP_CombatItemBase_C")


function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)

    self.NowPathId = 1
    self.NextPathId = 1
    self.Distance = 0
    self.Speed = self.UnitParams["Speed"] or 100
    self.Range = self.UnitParams["Range"] or 100
    self.bFirstActive = false

    self:CreateSpline()

    --OpenState，交互机关参数，负责车的停下和启动。ForceStop, 可交互，但是不可移动的状态
    -- self.bMove = false
    -- self.ForceStop = false
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode:GetDungeonComponent() then
        GameMode:GetDungeonComponent().FeinaBird = self
    end
end

function M:CreateSpline()
    local SplinePath = UE4.UClass.Load('/Game/BluePrints/Item/DefenceCore/BP_TrollySpline.BP_TrollySpline')
    local Transform = FTransform()
    Transform.Translation = self:GetTransform().Translation
    self.Spline = self:GetWorld():SpawnActor(SplinePath, Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    self.Spline.Spline:ClearSplinePoints(false)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.NowPathId = self.NowPathId
    GameState.NextPathId = self.NextPathId
    -- self:AddNewPath()
end

function M:AddNewPath()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode:GetDungeonComponent() then
        return
    end
    local PointList = GameMode:TriggerDungeonComponentFun("GetNextPathInfos", self.NowPathId)
    print(_G.LogTag,"LXZ AddNewPath", PointList, self.NowPathId)
    if not PointList then
        GWorld.logger.error("菲娜活动夜莺 不存在下一段路径，当前路径id："..self.NowPathId)
        return
    end
    table.sort(PointList, function(a, b)
        return a.PathPointIndex < b.PathPointIndex
    end)
    for i, v in pairs(PointList) do
		self.Spline:AddPoint(v:K2_GetActorLocation(), i-1, v)
    end
    self.NowPathId = self.NextPathId
    self.NextPathId = PointList[#PointList].NextPathId
    self.PathDistance:Add(self.NowPathId, self.SplineLength)
    self.SplineLength = self.Spline.Spline:GetSplineLength()
    self.Percent = self.Distance/self.SplineLength
    -- if self.NowPathId == 1 then
    --     self:OnPathStart(self.NowPathId)
    --     local Transform = self.Spline:GetMoveTransform(self.Percent)
    --     Transform = FTransform(Transform.Rotation, Transform.Translation + FVector(0,0,154), self:GetActorScale3D())
    --     self:K2_SetActorTransform(Transform, false, nil, false)
    -- end
end

function M:OnPathEnd(PathId)
    print(_G.LogTag,"LXZ OnPathEnd", PathId)
    self.Overridden.OnPathEnd(self, PathId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:TriggerGameModeEvent("OnPathEnd", self.CreatorId, PathId)
    end
end
function M:OnPathStart(PathId)
    self.Overridden.OnPathStart(self, PathId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:TriggerGameModeEvent("OnPathStart", self.CreatorId, PathId)
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
--     self:Move_Main(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
