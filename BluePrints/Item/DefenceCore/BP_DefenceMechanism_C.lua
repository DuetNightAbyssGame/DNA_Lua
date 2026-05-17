--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_DefenceMechanism_C = Class({
    "BluePrints/Item/DefenceCore/BP_DefenceBase_C",
})

function BP_DefenceMechanism_C:AuthorityInitInfo(Info)
    BP_DefenceMechanism_C.Super.AuthorityInitInfo(self,Info)
    self.bDamaged = false
end

function BP_DefenceMechanism_C:ClientInitInfo(Info)
    BP_DefenceMechanism_C.Super.ClientInitInfo(self,Info)
    EventManager:AddEvent(EventID.OnArtLevelLoaded, self, self.OnArtLevelLoaded)
end

function BP_DefenceMechanism_C:ShowDamage_Lua(DamageEvent)
    -- PrintTable(DamageEvent)
    if self:CheckHited(DamageEvent) then
        --近战武器打击点在施法者脚下，目前方案：施法者水平打射线，检测防御核心，检测点为特效点
        if DamageEvent.DamageTag:Find("Melee") then
            local Start = Battle(self):GetEntity(DamageEvent.SourceEid):K2_GetActorLocation()
            local End = FVector(self:K2_GetActorLocation().X, self:K2_GetActorLocation().Y,Start.Z)
            local HitResult = FHitResult()
            local ActorsToIgnore = TArray(AActor)
            ActorsToIgnore:Add(Battle(self):GetEntity(DamageEvent.SourceEid))
            local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, Start, End, ETraceTypeQuery.TraceSkillCreatureBlock, false, ActorsToIgnore, 0, HitResult, false)
            if bHit and HitResult.Actor == self then
                self.FXComponent:PlayFX(self.HitedFX,self.Mesh,nil,HitResult.Location,FRotator(0,0,0),true,nil)
            end
        else
            local HitPosition = FVector(DamageEvent.HitPosition.X, DamageEvent.HitPosition.Y, DamageEvent.HitPosition.Z)
            self.FXComponent:PlayFX(self.HitedFX,self.Mesh,nil,HitPosition,FRotator(0,0,0),true,nil)
        end
    end
end

function BP_DefenceMechanism_C:OnDamaged(DamageEvent)
    BP_DefenceMechanism_C.Super.OnDamaged(self, DamageEvent)
    if DamageEvent.HpBefore > DamageEvent.HpAfter and self.bDamaged == false then
        local GameMode = UGameplayStatics.GetGameMode(self)
        if GameMode then
            GameMode:TriggerDungeonAchieve("DefenceCoreDamaged", -1, self.Eid, self.UnitId)
        end
        self.bDamaged = true
    end
end

-- 移到父类DefenceBase里了
-- function BP_DefenceMechanism_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
--     BP_DefenceMechanism_C.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
--     if IsStandAlone(self) or IsClient(self) then
--         DebugPrint(" BP_DefenceMechanism_C:OnDead StandAlone or Client")
--         if self.IsPetDefenceCore then
--             return
--         end
--         local GameState = UE4.UGameplayStatics.GetGameState(self)
--         local DefenceUIName = CommonConst.DungeonUINameMap[GameState.GameModeType]
--         local DefenceUI = UIManager(self):GetUIObj(DefenceUIName)
--         -- 防御核心也不一定只用在防御玩法中（其实该改拿UIName的方法，先这样吧）
--         if DefenceUI then
--             DefenceUI:OnDefenceCoreDead()
--         end
--     end
-- end

function BP_DefenceMechanism_C:OnArtLevelLoaded(LevelId)
    --print(_G.LogTag,"lxz OnArtLevelLoaded", self:GetName())
    if not self.CurrentLevelId:Contains(LevelId) then
        return
    end
    local MeshComps = self:K2_GetComponentsByClass(UMeshComponent):ToTable()
    for _, MeshComp in pairs(MeshComps) do
        --print(_G.LogTag,"lxz OnArtLevelLoaded111", self:GetName(), MeshComp:GetName())
        MeshComp:SetVisibility(false, false)
        MeshComp:SetVisibility(true, false)
    end
    EventManager:RemoveEvent(EventID.OnArtLevelLoaded, self)
    if not self:IsExistTimer("TimerSetVisibility") then
        self:AddTimer(3, self.TimerSetVisibility, true, 0, "TimerSetVisibility")
    end
end

function BP_DefenceMechanism_C:TimerSetVisibility()
    local MeshComps = self:K2_GetComponentsByClass(UMeshComponent):ToTable()
    for _, MeshComp in pairs(MeshComps) do
        --print(_G.LogTag,"lxz OnArtLevelLoaded111", self:GetName(), MeshComp:GetName())
        MeshComp:SetVisibility(false, false)
        MeshComp:SetVisibility(true, false)
    end
end

function BP_DefenceMechanism_C:OnFirstActive()
    self.Overridden.OnFirstActive(self)
end

--function BP_DefenceMechanism_C:ReceiveTick(DeltaSeconds)
--    print(_G.LogTag,self.RecoverHandle)
--    self.Overridden.ReceiveTick(self,DeltaSeconds)
--end
--function BP_DefenceMechanism_C:UserConstructionScript()
--end

--function BP_DefenceMechanism_C:ReceiveBeginPlay()
--end

function BP_DefenceMechanism_C:ReceiveEndPlay(EndReason)
    self:RemoveTimer("TimerSetVisibility")
    BP_DefenceMechanism_C.Super.ReceiveEndPlay(self, Reason)
end

-- function BP_DefenceMechanism_C:ReceiveTick(DeltaSeconds)
-- end

--function BP_DefenceMechanism_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_DefenceMechanism_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_DefenceMechanism_C:ReceiveActorEndOverlap(OtherActor)
--end

return BP_DefenceMechanism_C
