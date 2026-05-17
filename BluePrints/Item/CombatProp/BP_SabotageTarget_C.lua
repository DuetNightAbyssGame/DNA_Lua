--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
---@type BP_SabotageTarget_C
local BP_SabotageTarget_C = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function BP_SabotageTarget_C:AuthorityInitInfo(Info)
    BP_SabotageTarget_C.Super.AuthorityInitInfo(self, Info)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local Level = self.DefaultLevel + GameMode:GetFixedGamemodeLevel()
    self:SetAttr("Level", Level)
    local GameState = UE4.UGameplayStatics.GetGameState(self)

    local MiniGameId = self.MiniGameId
    if self.MiniGameId ~= 0 then
        GameState.StaticCreatorMap:Find(self.MiniGameId).SourceEid = self.Eid
        local MiniGameList = TArray(0)
        MiniGameList:Add(self.MiniGameId)
        GameMode:TriggerActiveStaticCreator(MiniGameList)
    end

    if GameMode:GetDungeonComponent() then
        GameMode:GetDungeonComponent().SabotageTarget = self
    end
end

function BP_SabotageTarget_C:CustomAddGuideCondition()
    return false
end

function BP_SabotageTarget_C:TriggerByChild(ChildEid)
    self:ChangeToState(1)
end

function BP_SabotageTarget_C:ChangeToState(StateId)
    if StateId == 1 then
        -- self.IsActive = true
        -- self:ActiveOnServer()
        -- self:ActiveGuide("Add")
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        self:ChangeState("Manual", Player.Eid, 239)
    elseif StateId == 0 then
        self.IsActive = false
        Battle(self):AddBuffToTarget(self, self, 301, -1, nil, nil)
    end
end

function BP_SabotageTarget_C:ActiveOnServer()
    if self.bIsDead then
        return
    end
    BP_SabotageTarget_C.Super.ActiveOnServer(self)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and not self.bTriggerActiveGameMode then
        self.bTriggerActiveGameMode = true
        GameMode:TriggerDungeonComponentFun("SabotageTargetActive")
        GameMode:SetClientDungeonUIState(Const.EDungeonUIState.OnTarget)
    end
    local UIManager = UIManager(self)
    if UIManager ~= nil then
        self.BossBloodUI = UIManager:LoadUINew("BossBlood", self, true, true)
        if self.BillboardComponent then
            self.BillboardComponent.Owner = self
        end
        DebugPrint("Load Sabotage BloodUI",self.BillboardComponent)
    end
    self:OnSabotageActive()
end

-- function BP_SabotageTarget_C:ShowDamage(DamageEvent)
--     BP_SabotageTarget_C.Super.ShowDamage(self, DamageEvent)
--     EventManager:FireEvent(EventID.ShowBossBlood, "Attack",DamageEvent)

--     --检查是否为纯dot伤害
--     if self:CheckHited(DamageEvent) then
--         self:OnHited()
--     end
-- end

function BP_SabotageTarget_C:SetActiveType()
    self.ActiveType = "OtherCombat"
end

function BP_SabotageTarget_C:ShowDeath()
    BP_SabotageTarget_C.Super.ShowDeath(self)
    if IsAuthority(self) and IsStandAlone(self) then
        self:UnLoadBloodUI()
        self:PlayDeadMontage()
    end
end

function BP_SabotageTarget_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    BP_SabotageTarget_C.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and not self.bSabotageIsDead then
        self.bSabotageIsDead = true
        GameMode:TriggerGameModeEvent("OnSabotageTargetDead")
        
    end
end

function BP_SabotageTarget_C:OnRep_bSabotageIsDead()
    if self.bSabotageIsDead then
        self:UnLoadBloodUI()
        self:PlayDeadMontage()
        self:DeactiveGuide()
    end
end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

function BP_SabotageTarget_C:ReceiveEndPlay()
    self:UnLoadBloodUI()
end

function BP_SabotageTarget_C:UnLoadBloodUI()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager ~= nil then
        local BloodUI = UIManager:GetUI("BossBlood")
        if BloodUI and BloodUI.Owner == self then
            UIManager:UnLoadUI("BossBlood")
        end
    end
end

function BP_SabotageTarget_C:SelectCollisionComp(CollisionArray)
    local MaxRate = -1
    local Res = nil
    for i, v in pairs(CollisionArray.Collisions) do
        local Name = UKismetSystemLibrary.GetDisplayName(v)
        local Rate = self.DamageRate:Find(v:GetName())
        if Rate > MaxRate then
            MaxRate = Rate
            Res = v
        end
    end
    return Res
end

function BP_SabotageTarget_C:UpdateDamageRate(Character, Damage, Source, Target)
    local Rate = self.DamageRate:Find(Damage.CollisionName)
    self.HitedComponent = Damage.CollisionName
    Damage:AddGlobalDamageRate(Rate, "", true)
end


-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return BP_SabotageTarget_C
