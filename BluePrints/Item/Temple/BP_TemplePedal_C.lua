--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Pedal_Temple_01_C
local M = Class("BluePrints.Item.BP_CombatItemBase_C")

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    self.CurProgress = 1
    self.IsInDown = true
end

function M:ResetInfo()
    self.Overridden.ResetInfo(self)

end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)

    if self.IsInDown then
        self.CurProgress = math.max(self.CurProgress - DeltaSeconds * self.Speed, 0)
        self:SetMeshLocByProgress(self.CurProgress)
        if self.CurProgress <= 0 then
            self:ChangeState("Manual", 0, self.StayDownStateId)
        end
    else
        self.CurProgress = math.min(self.CurProgress + DeltaSeconds * self.Speed, 1)
        self:SetMeshLocByProgress(self.CurProgress)
        if self.CurProgress >= 1 then
            self:ChangeState("Manual", 0, self.StayUpStateId)
        end
    end
end

function M:OnPawnIn(OtherActor)
    if self.StateId ~= self.StayDownStateId then
        self:ChangeState("Manual", 0, self.InDownStateId)
    end
end

function M:OnPawnOut(OtherActor)
    local Actors = self.Box:GetOverlappingActors()
    if Actors:Length() == 0 and self.StateId ~= self.StayUpStateId then
        self:ChangeState("Manual", 0, self.InUpStateId)
    end
end

function M:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)

    if NowStateId == self.InUpStateId then
        self.IsInDown = false
        self:SetActorTickEnabled(true)
    elseif NowStateId == self.InDownStateId then
        self.IsInDown = true
        self:SetActorTickEnabled(true)
    elseif NowStateId == self.StayUpStateId then
        self:SetActorTickEnabled(false)
    elseif NowStateId == self.StayDownStateId then
        self:SetActorTickEnabled(false)
    end
end

function M:SetMeshLocByProgress(Progress)
    self.Cube1:K2_SetWorldLocation(FVector(self.InitLocation.X, self.InitLocation.Y, self.InitLocation.Z - self.Distance * (1 - Progress)), false, nil, false)
end

return M
