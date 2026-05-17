--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"
local UIUtils = require "Utils.UIUtils"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"

local BP_CombatPropBase_C = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
})

BP_CombatPropBase_C._components = {
    "BluePrints.Combat.Components.SkillLevelInterface",
    "BluePrints.Common.DelayFrameComponent",
    "BluePrints.Combat.Components.CharacterBattleEventComponent",
}

function BP_CombatPropBase_C:AuthorityInitInfo(Info)
    if self.Bpborn then
        if self.LevelAdaptDisable and UE4.UGameplayStatics.GetGameMode(self):IsInRegion() then
            self:SetAttr("Level", math.max(1, self.PresetLevel))
        else
            local Level = self.PresetLevel + UE4.UGameplayStatics.GetGameMode(self):GetFixedGamemodeLevel()
            self:SetAttr("Level", Level)
        end
    else
        self:SetAttr("Level", Info.IntParams:Find("Level") or 1)
    end
    local _Data = self:GetBattleDataInfo(Info)
    if _Data then
        self:SetTableAttr()
    end
    BP_CombatPropBase_C.Super.AuthorityInitInfo(self, Info)
    self:SetDirectSource(Info.DirectSource and Info.DirectSource.Eid)
    self:InitCombatPropInfo()
    self:SetCamp(Info.Camp or self.Data["Camp"])
    if self.NeedRecoverShield then
        self:AddShieldRecoverComp()
    end
    if(self.ActiveType=="") then
        self.IsActive = true
    end
end

function BP_CombatPropBase_C:CommonInitInfo(Info)
    self:SetActiveType()
    --部分UI需要读BuffManager,所以两端都要添加
    self:AddBuffManager()
    if(self.ActiveType ~= "" and self.ActiveType ~= "PlayerAttack") then
        self.IsActive = false
        self.InitHandle = self:AddTimer(0.2,self.InitInvincible,false)
    end
    --有些机关死亡后还留在场上，因为初始化里需要触发一次死亡表现，防止反序列化之后表现不对
    self:OnDeadStateChange(self.bIsDead)
    BP_CombatPropBase_C.Super.CommonInitInfo(self, Info)
end

function BP_CombatPropBase_C:ClientInitInfo(Info)
    BP_CombatPropBase_C.Super.ClientInitInfo(self, Info)
    self:InitUIWidgetComponent()
    if self.Data.BloodUIParmas and self.Data.BloodUIParmas.ActiveCommonUI == 1 then
        self.BillboardComponent:InitItemsBillBoard(self, "BreakableItems")
    else
        self.BillBoardComponent.IsInit = true
    end
end

-- function BP_CombatPropBase_C:RegisterToGameState()
--     if not IsAuthority(self) then
--         return
--     end
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     GameState:RegisterMechanism(self,self:GetUnitRealType())
-- end

function BP_CombatPropBase_C:InitInvincible()
    self:RemoveTimer(self.InitHandle)
    if self.IsActive then
        return
    end
    Battle(self):AddBuffToTarget(self, self, 6000207, -1, nil, nil)
    Battle(self):AddBuffToTarget(self, self, 301, -1, nil, nil)
end

function BP_CombatPropBase_C:GetBattleDataInfo(Info)
    self.RoleId = self.Data["BattleRoleId"]
    self.RewardId = self.Data["RewardId"]
    return DataMgr.BattleMonster[self.RoleId]
end

function BP_CombatPropBase_C:CheckIgnoreByRangeHit(TargetActor)
    if not TargetActor then
        return false
    end
    if TargetActor:Cast(AMonsterCharacter) then
        local MonsterData = DataMgr.Monster[TargetActor.UnitId]
        if not MonsterData then
            return false
        end
        local IgnoreByEnemyCheckRangeHit = MonsterData.IgnoreByEnemyCheckRangeHit
        if IgnoreByEnemyCheckRangeHit and self:IsEnemyOrNeutral(TargetActor) then
            return true
        end
        local IgnoreByFriendCheckRangeHit = MonsterData.IgnoreByFriendCheckRangeHit
        if IgnoreByFriendCheckRangeHit and (self:IsFriend(TargetActor) or self:IsOtherFriend()) then
            return true
        end
    end
    return false
end

function BP_CombatPropBase_C:PropUseSkill(SkillId,TargetActor)
    if self:CheckIgnoreByRangeHit(TargetActor) then
        return
    end
    if(type(SkillId)=="table") then
        for i,v in SkillId do
            self:ExecuteTask(v,TargetActor)
        end
    else
        self:ExecuteTask(SkillId,TargetActor)
    end
end

function BP_CombatPropBase_C:ExecuteTask(EffectId, Target)
    Battle(self):ExecuteSkillEffectWithType(self, EffectId, Target, nil, self)
end

function BP_CombatPropBase_C:PropAttack(TargetActor)
    if self:CheckIgnoreByRangeHit(TargetActor) then
        return
    end
    if not self.PlayerEffect then
        self.PlayerEffect = self.UnitParams["PlayerEffect"]
    end
    if self.PlayerEffect then
        if(type(self.PlayerEffect) == "table") then
            for i, v in self.PlayerEffect do
                self:ExecuteTask(v, TargetActor)
            end
        else
            self:ExecuteTask(self.PlayerEffect, TargetActor)
        end
    end
    if not self.MonEffect then
        self.MonEffect = self.UnitParams["MonEffect"]
    end
    if self.MonEffect then
        if(type(self.MonEffect) == "table") then
            for i, v in self.MonEffect do
                self:ExecuteTask(v, TargetActor)
            end
        else
            self:ExecuteTask(self.MonEffect, TargetActor)
        end
    end
end

function BP_CombatPropBase_C:InitCombatPropInfo()
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if GameMode and self.RewardID then
    --     GameMode:InitDropRule(self.UnitId, self.RewardID)
    -- end
end

function BP_CombatPropBase_C:SetActiveType()
    --激活方式默认不设置
    --目前激活方式："Distance"  "DistanceAlways"  "Manual"  "OtherCombat"  "PlayerAttack"
    self.ActiveType = ""
end

function BP_CombatPropBase_C:OnServerReady()
    self.Overridden.OnServerReady(self)
end

-- 用SceneItemBase中的逻辑
-- function BP_CombatPropBase_C:ActiveGuide(OpType)
--     -- 激活指引
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local ResourceMgr = GameInstance:GetSceneManager()
--     local CombatProp = DataMgr.Mechanism[self.UnitId]
--     if (ResourceMgr ~= nil and (CombatProp.GuideIconBPPath or CombatProp.GuideIconAni)) then
--         local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 		GameState:AddGuideEid(self.Eid)
--         ResourceMgr:UpdateSceneGuideIcon(self.Eid, self, nil, OpType, true, CombatProp)
--     end
-- end

-- function BP_CombatPropBase_C:DeactiveGuide()
--     -- 关闭指引
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local ResourceMgr = GameInstance:GetSceneManager()
--     local CombatProp = DataMgr.Mechanism[self.UnitId]
--     if (ResourceMgr ~= nil and (CombatProp.GuideIconBPPath or CombatProp.GuideIconAni)) then
--         local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 		GameState:RemoveGuideEid(self.Eid)
--         ResourceMgr:UpdateSceneGuideIcon(self.Eid, self, nil, "Delete", true, CombatProp)
--     end
-- end
---------------------------------------死亡、受击表现-----------------------------------------------------
--------基本区分：Show做表现，On做逻辑，只想实际受击而不是受伤时，用CheckHited判断
function BP_CombatPropBase_C:ShowDeath(DissolveDuration)
    self:DeactiveGuide()
    self.CombatClientEffectComponent:OnDeadEffect()
end

-- function BP_CombatPropBase_C:ShowDamage(DamageEvent)
--     if GMVariable.EnableShowBillboard then
--         self:TryToStartHarmJumpWord(DamageEvent)
--     end
--     UIUtils.TryToStartUIHitFeedback(DamageEvent, self)
--     if self.BillBoardComponent then
--         self.BillboardComponent:OnDamaged("Attack",DamageEvent)
--     end
--     self.CombatClientEffectComponent:OnHitedEffect()
-- end

-- function BP_CombatPropBase_C:CheckHited(DamageEvent)
--     if DamageEvent.DamageTag:Length() == 0 then
--         return true
--     end
--     local Res = false
--     for i = 1, DamageEvent.DamageTag:Length() do
--         if(DamageEvent.DamageTag[i] ~= "Dot")then
--             --Dot伤害不需要命中反馈
--             Res = true
--         end
--     end
--     return Res
-- end

function BP_CombatPropBase_C:OnBreakCountDown(SourceEid)
    if IsStandAlone(self) or IsClient(self) then
        self.CombatClientEffectComponent:OnHitedEffect()
    end
end

function BP_CombatPropBase_C:OnDamaged(DamageEvent)
    self.Overridden.OnDamaged(self, DamageEvent)
end

function BP_CombatPropBase_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    self.bIsDead = true
    self:OnDeadStateChange(self.bIsDead)
    self:DestroyAllCreatures(ECreatureDeathWithCreator.Normal, EDeathReason.CreatureNotDelay)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameMode then
        self:CreateReward(KillMineRoleEid)
        GameMode:CombatPropOnDead(self)
    end
    self.Overridden.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    self:TriggerSource(0)
    self:ShowDeath()
    
    --统计场景机关被破坏情况，所有死亡都算(NewBreakableItem也实现了)
    local Player = Battle(self):GetEntity(KillMineRoleEid)
    if IsValid(Player) and Player.IsPlayer and Player:IsPlayer() then
        Player:AddBreakableItemCount()
    end
end

function BP_CombatPropBase_C:CreateReward(KillMineRoleEid)
    if not self:CheckAutoCreateReward() then
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        local RewardPosition = self:GetTransform()
        if self.RewardPosition then
            RewardPosition = self.RewardPosition:K2_GetComponentToWorld()
        end
        local ExtraInfo = {
            UniqueSign = self.Eid,
            SourceEid = KillMineRoleEid,
        }
        if GameMode:IsInRegion() then
            ExtraInfo.WorldRegionEid = self.WorldRegionEid
            ExtraInfo.RegionDataType = self.RegionDataType
        end
        GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.BreakableItem, RewardPosition, ExtraInfo)
    end
end

function BP_CombatPropBase_C:StateCreateReward(PlayerId, NextStateId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        local RewardPosition = self:GetTransform()
        if self.RewardPosition then
            RewardPosition = self.RewardPosition:K2_GetComponentToWorld()
        end
        local ExtraInfo = {
            UniqueSign = self.Eid,
            SourceEid = KillMineRoleEid,
        }
        if GameMode:IsInRegion() then
            ExtraInfo.WorldRegionEid = self.WorldRegionEid
            ExtraInfo.RegionDataType = self.RegionDataType
        end
        local function CallBack()
            self.CombatStateChangeComponent:TriggerOnEventEnd(NextStateId)
        end
        return GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.BreakableItem, RewardPosition, ExtraInfo, CallBack)
    end
    return false
end
---------------------------------------死亡、受击表现end-----------------------------------------------------

function BP_CombatPropBase_C:ActiveOnServer()
    if self:IsDead() then
        return
    end
    BP_CombatPropBase_C.Super.ActiveOnServer(self)
    Battle(self):RemoveBuffFromTarget(self, self, 6000207, false, -1)
    Battle(self):RemoveBuffFromTarget(self, self, 301, false, -1)
end

function BP_CombatPropBase_C:DeActive()
    BP_CombatPropBase_C.Super.DeActive(self)
    self.IsStart = false
    self.IsActive = false
    if(self.ActiveType ~= "" and self.ActiveType ~= "PlayerAttack") then
        Battle(self):AddBuffToTarget(self, self, 6000207, -1, nil, nil)
        Battle(self):AddBuffToTarget(self, self, 301, -1, nil, nil)
    end
end

function BP_CombatPropBase_C:ActiveFX(Niagara)
    Niagara:SetActive(true)
end
function BP_CombatPropBase_C:DeActiveFX(Niagara)
    Niagara:Deactivate()
end
function BP_CombatPropBase_C:GetCurrentWeapon()
    return nil
end

function BP_CombatPropBase_C:CreateRegionData()
    self.RegionData = {
        MaxHp = self:GetAttr("MaxHp"),
        Hp = self:GetAttr("Hp"),
        MaxES = self:GetAttr("MaxES"),
        ES = self:GetAttr("ES"),
        IsActive = self.IsActive,
        StateId = self.StateId
    }
end

function BP_CombatPropBase_C:GetShootingTargets()
    return TArray(ACharacterBase)
end

---------------------------------------指引点---------------------------------------
function BP_CombatPropBase_C:GetGuidePos()
    if self.GuidePos then
        return self:K2_GetActorLocation()+self.GuidePos.RelativeLocation
    else
        return self:K2_GetActorLocation()
    end
end

AssembleComponents(BP_CombatPropBase_C)
return BP_CombatPropBase_C
