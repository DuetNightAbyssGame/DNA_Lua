--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TrapArea_Temple_C
local M = Class({
    "BluePrints/Item/AirWall/BP_FieldCreature_C",
})

function M:OnBreakCountDown(SourceEid)
    M.Super.OnBreakCountDown(self, SourceEid)
    self:ChangeState("Hit", SourceEid)
end

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self, Info)
    self.HasMonsterInRange = false
    self.InRangeMonsters = {}
    self.Center = self.DetectMonBox:K2_GetComponentLocation()
end

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self, Info)
    EventManager:AddEvent(EventID.OnTempleSmeltChangeBlue, self, self.OnTempleSmeltChangeBlue)
    EventManager:AddEvent(EventID.OnNoticeCageUp, self, self.OnNoticeCageUp)
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    -- self:AddTimer(0.1, self.CheckMonInRange, true, 0, "CheckMonInRange")
end

function M:ResetInfo()
    self.Overridden.ResetInfo(self)
    self:K2_SetActorLocation(self.LocDown, false, nil, false)
    self:ChangeState("Manual", 0, self.InitStateId)
end

function M:OnMonsterIn(OtherActor)
    if OtherActor and OtherActor.IsPureMonster and OtherActor:IsPureMonster() and self:CheckMonsterValid(OtherActor.UnitId) then
        self.InRangeMonsters[OtherActor.Eid] = OtherActor
        if not self.HasMonsterInRange and self.StateId ~= self.UpToDownStateId then
            self.HasMonsterInRange = true
            self:OnMonsterInRangeChange()
        end
    end
end

function M:OnMonsterOut(OtherActor)
    if OtherActor and OtherActor.IsPureMonster and OtherActor:IsPureMonster() and self:CheckMonsterValid(OtherActor.UnitId) and self.InRangeMonsters[OtherActor.Eid] then
        local PreHasMonster = self.HasMonsterInRange
        self:CheckMonInRange()
        if PreHasMonster and not self.HasMonsterInRange then
            self:OnMonsterInRangeChange()
        end
    end
end

function M:CheckMonsterValid(UnitId)
    for i, v in pairs(self.MonsterUnitIds) do
        if v == UnitId then
            return true
        end
    end
    return false
end

function M:CheckMonInRange()
    self.InRangeMonsters = {}
    self.HasMonsterInRange = false
    local Actors = self.preBox:GetOverlappingActors()
    if Actors:Length() > 0 then
        for i = 1, Actors:Length() do
            if Actors[i].IsPureMonster and Actors[i]:IsPureMonster() and self:CheckMonsterValid(Actors[i].UnitId) and not Actors[i]:IsDead() then
                -- 有怪在范围里
                self.InRangeMonsters[Actors[i].Eid] = Actors[i]
                self.HasMonsterInRange = true
            end
        end
    end
end

function M:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)
    if NowStateId == self.DownStateId then
        self:ChangeSmelt(true)
    end
end

function M:OnLeaveState(NowStateId, NextStateId)
    self.Overridden.OnLeaveState(self, NowStateId, NextStateId)
    if NowStateId == self.DownStateId then
        self:ChangeSmelt(false)
    end
end

function M:AddMonsterBuff()
    if not self.InRangeMonsters then return end
    for i, v in pairs(self.InRangeMonsters) do
        if v and not v:IsDead() then
            v:SetVector("CageCenterLoc", self.Center)
            Battle(self):AddBuffToTarget(self, v, self.BuffId, -1, nil, nil)
        end
    end
end

function M:ChangeSmelt(IsEnterDown)
    EventManager:FireEvent(EventID.OnTempleCageEnterDown, self.ManualItemId, IsEnterDown)
end

function M:OnTempleSmeltChangeBlue(ManualId)
    if ManualId ~= self.TransMechanId then
        return
    end
    -- 延时后杀怪
    self:AddTimer(self.MonsterDeadDelay, function()
        for i, v in pairs(self.InRangeMonsters) do
            if v and not v:IsDead() then
                local GameMode = UE4.UGameplayStatics.GetGameMode(self)
                GameMode:GetDungeonComponent():OnCageMonsterDead(v, self.ManualItemId)
                Battle(self):BattleOnDead(v.Eid, v.Eid, 0, EDeathReason.NoReason)
            end
        end
    end, false, 0)
end

function M:OnNoticeCageUp(ManualId)
    if ManualId ~= self.TransMechanId then
        return
    end
    self:ChangeState("Manual", 0, self.AutoUpStateId)
end

return M
