--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_HostageAimPoint_C
local M = Class("BluePrints/Item/BP_CombatItemBase_C")

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    if IsAuthority(self) then
        self.Box.OnComponentBeginOverlap:Add(self, self.OnHostageEnter)
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:AddHostageAimPoint(self)
    end
end

function M:ReceiveEndPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:RemoveHostageAimPoint(self)
    end
end

function M:OnHostageEnter(OverlappedComponent, OtherActor,  OtherComp,  OtherBodyIndex,  bFromSweep, SweepResult)
    if not OtherActor or not OtherActor.UnitId or OtherActor.UnitId ~= 7017051 or self.HasEnter then
        return
    end

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then
        return
    end

    self.HasEnter = true
    local BlackBoardComponent = OtherActor:GetOwnBlackBoardComponent()
    if BlackBoardComponent then
        BlackBoardComponent:SetValueAsBool("ReachSynthesisLoc", true)
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        local LevelName = GameMode:GetActorLevelName(self)
        GameMode:TriggerDungeonComponentFun("OnHostageEnterPoint", LevelName)
    end
end

return M
