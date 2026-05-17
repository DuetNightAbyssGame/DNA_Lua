--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TrollyWall_C
local BP_TrollyWall_C = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

--普通推车障碍物，只用于阻挡，只能放在无分叉路径上

function BP_TrollyWall_C:CommonInitInfo(Info)
    BP_TrollyWall_C.Super.CommonInitInfo(self,Info)
    self.InitHandle = self:AddTimer(0.5,self.GetTrolly,true)
    self.bCrashed = false
end

function BP_TrollyWall_C:OnActorReady(Info)
    -- print(_G.LogTag,"LXZ   ",self:GetName())
    if IsAuthority(self) then
        self._RegisterOnCharacterDead = true
        self.BattleEvent.AfterBeCutToughness:Add(self, self.AfterBeCutToughness)
        self.BattleEvent.OnToughnessToZero:Add(self, self.OnToughnessToZeroCallback)
    end
end

function BP_TrollyWall_C:OnToughnessToZeroCallback()
    self:OnToughnessToZero_CPP()
end

function BP_TrollyWall_C:OnToughnessToZero()
    if IsAuthority(self) then
        self.BattleEvent.AfterBeCutToughness:Remove(self, self.AfterBeCutToughness)
        self.BattleEvent.OnToughnessToZero:Remove(self, self.OnToughnessToZero_CPP)
    end
    if IsClient(self) or IsStandAlone(self) then
        self:ShowDeath()
        self.Overridden.OnToughnessToZero(self)
    end
    self:EMActorDestroy(EDestroyReason.MechanismDead)
end

function BP_TrollyWall_C:AfterBeCutToughness(Target, Source, Skill, BeforeTN, AfterTN, SubTN)
    if AfterTN ~= 0 then
        self:OnNormalDamage()
    else
        self:OnNormalDead()
    end
end

function BP_TrollyWall_C:OnCrashed()
    self.bCrashed = true
    AudioManager(self):PlayFMODSound(self, nil, self.OnCrashedSoundPath, "OnTrollyWallCrashed")
end

--障碍物死亡，更新当前路径点
function BP_TrollyWall_C:OnNormalDead()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.RaplacePathMap:Add(self.CurrentPathIndex, self.ReplacePathIndex)
    if self.Trolly then
        self.Trolly.CurrentWall = nil
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode then
            GameMode:TriggerGameModeEvent("OnWallDead", self)
        end
    end
end

--障碍物未死亡，停车，并更新车中当前阻挡墙的记录
function BP_TrollyWall_C:OnNormalDamage()
    if self.bCrashed then
        self.Trolly:Stop(self)
    end
end

function BP_TrollyWall_C:GetTrolly()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState.DefBaseMap:Length() > 1 then
        print(_G.LogTag,"Error: Level has more than two Trolly")
    end
    if GameState.DefBaseMap:Length() < 1 then
        print(_G.LogTag,"Error: Level has no Trolly")
    end
    for i, Trolly in pairs(GameState.DefBaseMap) do
        self.Trolly = Trolly
        self:RemoveTimer(self.InitHandle)
        break
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
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return BP_TrollyWall_C
