
---@type BP_MechanismSummon_C
local BP_MechanismSummon_C = Class({
	"BluePrints.Combat.Components.EffectSourceInterface",
	"BluePrints.Common.TimerMgr",
})

BP_MechanismSummon_C._components = {
	"BluePrints.Combat.Components.ActorTypeComponent",
    "BluePrints.Combat.Components.SkillLevelInterface",
    "BluePrints.Combat.Skill.MechanismSummonInitLogic",
    "BluePrints.Common.DelayFrameComponent",
}

function BP_MechanismSummon_C:ReceiveBeginPlay()
    -- @SnowMoon 监听battle并尝试初始化，如果已经有battle则会成功初始化，否则会等待battle触发场景Actor集体初始化
    EventManager:AddEvent(EventID.OnBattleReady, self, self.OnBattleReady_TryInitCharacterInfo)
end

function BP_MechanismSummon_C:OnBattleReady_TryInitCharacterInfo(_Battle)
    if Battle(self) == _Battle then
        self:TryInitActorInfo("Battle")
    end
end

function BP_MechanismSummon_C:RealReceiveBeginPlay()
    self.Data = DataMgr.MechanismSummon[self.UnitId]
    if self.Data.BluePrintParams then
        for Key, Value in pairs(self.Data.BluePrintParams) do
            self[Key] = Value
        end
    end

    self.InitSuccess = true
    self.Overridden.ReceiveBeginPlay(self)
    self:AllBeginPlay()
    self.Overridden.OnActorReady(self)

	if IsDedicatedServer(self) or IsStandAlone(self) then
		self:ServerBeginPlay(self);
	end
	
	if IsClient(self) or IsStandAlone(self) then
		self:ClientBeginPlay(self);
	end

    local Creator = self:GetDirectSource()
    if Creator and Creator:IsMainPlayer() then
        if IsStandAlone(self) or IsClient(self) then
            EventManager:FireEvent(EventID.OnCharCallSummoner, self)
        end
    end
end

function BP_MechanismSummon_C:ReceiveEndPlay(EndPlayReason)
    local Creator = self:GetDirectSource()
    if Creator and Creator:IsMainPlayer() then
        if IsStandAlone(self) or IsClient(self) then
            EventManager:FireEvent(EventID.OnCharRemoveSummoner, self)
        end
    end
    self.Overridden.ReceiveEndPlay(self, EndPlayReason)
    EventManager:RemoveEvent(EventID.OnBattleReady, self)
end

function BP_MechanismSummon_C:LoadCurrentModel()
    local ModelId = self.Data.ModelId
    if not ModelId then
        return
    end
    local ModelData = DataMgr.Model[ModelId]
    local ModelPath = ModelData.SkeletonMeshPath
    ModelPath = '/Game/'..ModelPath

    local ModelMesh = UE4.UResourceLibrary.FindObject(self, ModelPath)
    if ModelMesh == nil then
        ModelMesh = LoadObject(ModelPath)
    end
    if ModelMesh then
        self.Mesh:SetSkeletalMesh(ModelMesh, true)
    end
end

function BP_MechanismSummon_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    local Creator = self:GetDirectSource()
    local CreatorName = Creator and Creator:GetName() or ""
    local CreatorEid = Creator and Creator.Eid or 0
    local BattleTemp = Battle and Battle(self)
    if BattleTemp then
        BattleTemp:RecordBattleEvent_Lua("召唤者Eid为:"..CreatorEid.."，召唤者名字为:"..CreatorName.."，Eid为:"..self.Eid.."，名字为"..self:GetName().."的机关召唤物死亡了，它的UnitId为:"..self.UnitId, "MechanismSummon", 0)
    end
    self:OnMechanismSummonDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    self:DestroyAllCreatures(ECreatureDeathWithCreator.Normal, EDeathReason.CreatureNotDelay)
    if self.Data and self.Data.DelayDestroyTime then
        self.FXComponent:StopAllEffects(false)
        self:AddTimer_Combat(self.Data.DelayDestroyTime, function() self:EMActorDestroy(EDestroyReason.MechanismSummon) end)
    else
        self:EMActorDestroy(EDestroyReason.MechanismSummon)
    end
    if self.BillboardComponent then
        self.BillBoardComponent:CharOnDead()
    end
end

-- function BP_MechanismSummon_C:GetObjType()
--     return EObjType.MechanismSummon
-- end

-- function BP_MechanismSummon_C:AddChains()
--     for i, _Name in pairs(self.ChainEndName)do 
--         self:AddChain(_Name)
--     end
-- end

-- function BP_MechanismSummon_C:AddChain(ChainName)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     local EventMgr = GameMode.EMGameState.EventMgr
--     local function LoadFinishCallback(Unit)
--         Unit:AddConstraint(self.ControlMeshComp, self.StartAttachBoneName, ChainName)
--     end
--     EventMgr:CreateUnit({
--         UnitType = "MechanismSummon",
--         UnitId = 310204,
--         Loc = self:K2_GetActorLocation(),
--         Rotation = self:K2_GetActorRotation(),
--         LoadFinishCallback = LoadFinishCallback,
--         Creator =  self
--     })
-- end

AssembleComponents(BP_MechanismSummon_C)
return BP_MechanismSummon_C
