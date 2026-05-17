--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_WeeklyChest_C
require "UnLua"

local M = Class({
    "BluePrints/Item/DefenceCore/BP_DefenceBase_C",
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.KeyBuffId = self.UnitParams["KeyBuffId"]

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    self.NeedKeyNum = DataMgr.Synthesis[GameState.DungeonId].KeyNeedNum or 1
    -- self.NeedKeyNum = 5
    --self.RotateAxis = 0
end

function M:ActiveOnServer()
    M.Super.ActiveOnServer(self)
    if IsAuthority(self) then
        self:StartFindPlayer()
    end
end

function M:DeActive()
    M.Super.DeActive(self)
    self:StopFindPlayer()
end

function M:StartFindPlayer()
    self:AddTimer(0.1, self.FindPlayer, true, 0, "WeeklyChestTarget")
end

function M:TryFindPlayer()
    self:FindPlayer()
end

function M:StopFindPlayer()
    self:RemoveTimer("WeeklyChestTarget")
end

function M:OnKeyDelivered_Server(KeyNum)
    self.Overridden.OnKeyDelivered_Server(self, KeyNum)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:TriggerDungeonComponentFun("OnKeyDelivered", self)
    end
end

function M:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    M.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if IsAuthority(self) then
    --     GameMode:TriggerGameModeEvent("OnExcavationDestroyed")
    --     GameMode:TriggerDungeonComponentFun("JudgeNextTurn")
    -- end
    -- self:EMActorDestroy(EDestroyReason.MechanismDead)
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
