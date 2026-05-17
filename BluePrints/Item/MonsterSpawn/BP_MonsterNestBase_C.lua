--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_MonsterNestBase_C
require "UnLua"

local M = Class({
    "BluePrints.Item.CombatProp.BP_CombatPropBase_C",
})

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)
    self.SpawnedMonsters = {}
    self.ExistMonsters = {}
end

function M:GetMonsterSpawnPointTrans()
    return self.MonsterSpawnPoint:K2_GetComponentToWorld()
end

--激活逻辑
function M:ActiveOnServer()
    M.Super.ActiveOnServer(self)
end

--反激活逻辑
function M:DeActive()
    M.Super.DeActive(self)
    self:RemoveTimer("SpawnMonstersTimer")
end

--激活状态改变时的表现
function M:OnActiveStateChange()
    self.Super.OnActiveStateChange(self)
    if self.IsActive then
        self:AddTimer(self.MonsterSpawnInterval, self.SpawnMonsters, true, 0, "SpawnMonstersTimer")
    end
end

--死亡表现
function M:ShowDeath()
    M.Super.ShowDeath(self)
end

--死亡逻辑
function M:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    M.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    self:RemoveTimer("SpawnMonstersTimer")
end

function M:SetActiveType()
    self.ActiveType = "Manual"
end

function M:SpawnMonsters()
    if self.MonsterNum <= 0 then
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode == nil then
        self:DeActive()
        return
    end

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState == nil then
        self:DeActive()
        return
    end

    -- 预设目标为空
    local MonPresetTarget = nil

    -- 预设目标为玩家
    if self.MonsterPresetTarget == EPresetTargetType.EPlayer then
        MonPresetTarget = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)

    -- 预设目标为防御核心
    elseif self.MonsterPresetTarget == EPresetTargetType.EMechanism then
        for _, DefCore in pairs(GameState.DefBaseMap) do
            if DefCore.UnitId == self.MonsterPresetTargetId then
                MonPresetTarget = DefCore
                break
            end
        end
    end

    local RandomIndex = math.random(self.MonsterUnitId:Num())
    local RandomUnitId = self.MonsterUnitId:Get(RandomIndex)
    DebugPrint("BP_MonsterNestBase_C SpawnMonster ", self:GetName()," RandomUnitId:", RandomUnitId)

    local function LoadFinishCallback(_,Unit)
        print(_G.LogTag,"LXZ LoadFinishCallback", Unit.Eid)
        if (IsValid(Unit.NestHelperComponent)) then
            Unit.NestHelperComponent:K2_DestroyComponent(Unit)
            Unit.NestHelperComponent = nil
        end
        table.insert(self.SpawnedMonsters, Unit.Eid)
        table.insert(self.ExistMonsters, Unit.Eid)
		if Unit.OnSpawnInMonsterNest then
			Unit:OnSpawnInMonsterNest(self, self, self.LaunchSpeed or 1500, self.MaxTime or 5)
			Unit.CharacterMovement.MaxWalkSpeed = 600
		end
        if #self.SpawnedMonsters >= self.MonsterNum then
            self:RemoveTimer("SpawnMonstersTimer")
            -- 刷怪完成
        end
    end
    local Context = AEventMgr.CreateUnitContext()
    Context.UnitType = self.MonsterUnitType
    Context.UnitId = RandomUnitId
    Context.Loc = self:GetMonsterSpawnPointTrans().Translation
    Context.Rotation = self:GetMonsterSpawnPointTrans().Rotation:ToRotator()
    Context.MonsterSpawn = GameMode.LevelGameMode.FixedMonsterSpawn
    Context.IntParams:Add("Level", self:GetAttr("Level"))
    Context.BoolParams:Add("FixNavLocation",false)
    Context:AddObjectParams("PresetTarget", MonPresetTarget)
    Context.OnUnitInitCreateReadyDynamic:Add(self, LoadFinishCallback)
    GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
end

function M:DestroyAllMonster()
    for i, v in pairs(self.SpawnedMonsters) do
        local Monster = Battle(self):GetEntity(v)
        if IsValid(Monster) then
            Monster:EMActorDestroy(EDestroyReason.MonsterNestItemClear)
        end
    end
    self.SpawnedMonsters = {}
    self.ExistMonsters = {}
    self.IsCountRest = false
end

function M:ShowSpawnedMonsterGuide()
    DebugPrint("BP_MonsterNestBase_C ShowSpawnedMonsterGuide", self:GetName())
    for _, Eid in pairs(self.ExistMonsters) do
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:AddGuideEid(Eid)
    end
end

function M:HideSpawnedMonsterGuide()
    DebugPrint("BP_MonsterNestBase_C HideSpawnedMonsterGuide", self:GetName())
    for _, Eid in pairs(self.ExistMonsters) do
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:RemoveGuideEid(Eid)
    end
end

function M:TriggerCountRestMonsters()
    DebugPrint("BP_MonsterNestBase_C TriggerCountRestMonsters", self.ManualItemId)
    self.IsCountRest = true
    self:AddTimer(1, self.CheckRestMonsters, true, 0, "CheckRestMonsters")
end

-- Tick检测self.ExistMonsters是否全存在，如果不存在则认为已经全清
function M:CheckRestMonsters()
    if not self.IsCountRest then
        return
    end

    local NewExistMonsters = {}
    for _, LastExistEid in pairs(self.ExistMonsters) do
        local MonsterEntity = Battle(self):GetEntity(LastExistEid)
        if IsValid(MonsterEntity) then
            table.insert(NewExistMonsters, LastExistEid)
        end
    end

    self.ExistMonsters = NewExistMonsters
    DebugPrint("BP_MonsterNestBase_C ManaualItemId", self.ManualItemId," 还剩", #self.ExistMonsters, "个怪物没清除")
    if #self.ExistMonsters == 0 then
        self.IsCountRest = false
        DebugPrint("BP_MonsterNestBase_C ManaualItemId", self.ManualItemId," 全部怪物死亡，发出事件")
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        GameMode:OnMonsterNestRestMonClear(self.ManualItemId)
    end
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
--     self.Super.ReceiveBeginPlay(self)
--     self.SpawnedMonsters = {}
--     self:ActiveOnServer()
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
