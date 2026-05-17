
local Component = Class({
    "BluePrints.Combat.Components.CharacterInitLogic",
})

-----------------------初始化流程开始-----------------------
function Component:GetInfoForInit()
    return {
        RoleId = self.CurrentRoleId,
        UnitId = self.UnitId,
        UnitType = self.UnitType,
        ShadowModelId = self.ShadowModelId,
    }
end

function Component:InitCharacterInfo(Info)
    Info = Info or self.InfoForInit
    local InitType = Info.InitType
    if InitType == "FromCache" then
        self:GetInitLogicComp():InitFromCache(Info)
    else
        -- First和不传参都默认走FirstInit，所以联机客户端在初始化怪物的时候也是走的这个地方
        self:GetInitLogicComp():FirstInit(Info)
    end
end

function Component:IsBpbornRegionStorage()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then return false end
    local BPBornActor = GameMode.BPBornRegionActor:FindRef(self.ManualItemId)
    return self.BpBorn and IsValid(BPBornActor)
end

------------------------------------------------- 指引 -------------------------------------------------

-- 怪物和npc公用 因此移到AICharacterBase
function Component:CheckInitGuideType()
    local InitGuideInfo = DataMgr[self.UnitType][self.UnitId].InitGuide
    if not InitGuideInfo or not self:GetShowGuideDis(InitGuideInfo) then
        return false
    end
    return true
end

function Component:GetShowGuideDis(InitGuideInfo)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    for type,dis in pairs(InitGuideInfo) do
        if GameState.GameModeType == type then
            self.ShowGuideDistance = dis
            return true
        end
    end
   return false
end

function Component:CreateGuideHandle()
    self.FixTryToAddGuideHandle = self:AddTimer(1, self.TryToAddGuide, true)
end

function Component:StopTryToAddGuideTimer()
	if not IsValid(self) then 
		self:StopAddGuideTimer()
		return true
	end
	if self:IsDead() then 
		self:StopAddGuideTimer()
		return true
	end
    return false
end
------------------------------------------------- 指引 -------------------------------------------------

-- function Component:SetOutBattleInfo_Lua()
--     local BehaviorId = 0
--     local RandomData = DataMgr.RandomCreator[self.RandomRuleId]
--     for i, v in pairs(RandomData.RandomInfos) do
--         if v.UnitId == self.UnitId then
--             BehaviorId = v.OutBattleBehaviorId
--             break
--         end
--     end
-- 	local Behavior = DataMgr.OutBattleBehavior[BehaviorId]
-- 	if not Behavior then
-- 		return
-- 	end
-- 	self.OutBattleBehaviorType = Const.BehaviorId[Behavior.OutBattleBehaviorType]
-- 	if Behavior.PatrolBehavior then
-- 		self.PatrolId = Behavior.PatrolBehavior.PatrolId
-- 		self.PatrolPointType = Behavior.PatrolBehavior.PatrolPointType
-- 	end
-- 	self.StrollRange = Behavior.StrollRange
-- 	self.LoopMontageId = Behavior.LoopMontageId
-- 	self.MontageList = Behavior.MontageList
-- end

-- function Component:IsUseNewInitLogic()
--     return Const.UseNewCreateUnit
-- end

function Component:CheckUnitNeedStorage()
    if self.RegionDataType and CommonUtils.HasValue(Const.RegionDataStorageType, self.RegionDataType) then 
        return true
    end
    return false
end

-- function Component:SetOutBattleCMD_Lua()
--     local BehaviorId = 0
--     local RandomData = DataMgr.RandomCreator[self.RandomRuleId]
--     for i, v in pairs(RandomData.RandomInfos) do
--         if v.UnitId == self.UnitId then
--             BehaviorId = v.OutBattleBehaviorId
--             break
--         end
--     end
-- 	local Behavior = DataMgr.OutBattleBehavior[BehaviorId]
--     if not Behavior then
-- 		return
-- 	end
-- 	self:GetOwnBlackBoardComponent():SetValueAsEnum("OutBattleCMD", Behavior.OutBattleCMD);
-- end

--=================Clear Monster Info=========================
-- function Component:ClearMonsterInfo()
--     -- 正常死亡第一步数据清理
--     self:ClearMonsterInfo_CPP()
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     if GameMode then
--         GameMode:GetRegionDataMgrSubSystem():DeadRegionActorData(self, EDestroyReason.MonsterDead, GameMode:GetActorLevelName(self))
--     end
-- end

function Component:ClearFXComponent()
    self.FXComponent:StopAllEffects(true)
    if not self.Weapons then
        return
    end
    for _, Weapon in pairs(self.Weapons) do
        Weapon.FXComponent:StopAllEffects(true)
    end
end

-- function Component:ServerOnEMActorDestroy(DestroyReason)
--     -- 触发副本事件
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     if DestroyReason ~= EDestroyReason.MonsterDead then
--         GameMode:GetRegionDataMgrSubSystem():DeadRegionActorData(self, DestroyReason, GameMode:GetActorLevelName(self))
--     end
--     if CommonUtils.CheckDestroyReason(DestroyReason, "IsTriggerDestroyEvent") then
--         GameMode:TriggerEMActorDestoryEvent(self, nil, DestroyReason)
--     end
--     self:ServerClearMonsterExtraInfo(DestroyReason)
-- end

function Component:ServerClearMonsterExtraInfo(DestroyReason)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)

    --     2025.2.7 掩体功能废弃
    -- GameMode.CoverComponent:ResetCoverInfo(self.CoverPointInfo, self.Eid)

    -- if self:IsJailerMonster() then
    --     GameMode:TriggerDungeonComponentFun("TryResetRescueAlertingInfo", self)
    -- else
    --     GameMode:TryResetCommonAlertingInfo(self)
    -- end
    if self.MonAlertComponent then
        self.MonAlertComponent:TryResetCommonAlertingInfo()
    end

    self:WCOnEMActorDestroy(GameMode)
    --self:ClearEliteTeamInfo(NormalDeath, GameMode)
    if self.MonEliteComponent then
        self.MonEliteComponent:ClearEliteTeamInfo()
    end

    self:ServerClearAIExtraInfo(DestroyReason)
end

function Component:ServerClearNpcExtraInfo(DestroyReason)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)

    self:WCOnEMActorDestroy(GameMode)

    self:ServerClearAIExtraInfo(DestroyReason)
end

function Component:ServerClearAIExtraInfo(DestroyReason)
    local GameState = UE4.UGameplayStatics.GetGameState(self)

    if CommonUtils.CheckDestroyReason(DestroyReason, "IsClearStaticCreatorRef") then
        -- 正常死亡只需要维护静态点的数据，指引在ClearMonsterInfo里面已删除
        if self.CreatorType == "StaticCreator" then
            local Creator = GameState:GetStaticCreatorInfo(self.CreatorId, self.PrivateEnable, "", self)
            if Creator and URuntimeCommonFunctionLibrary.IsStaticCreatorValid(Creator) then 
                Creator:RemoveActorToChildEids(self.Eid)
            end
        end
    end

    if CommonUtils.CheckDestroyReason(DestroyReason, "IsMonClearBattleInfo") then
        -- 直接调用EMActorDestroy而非走BattleOnDead销毁的怪物，都应该补充Battle相关数据清理
        self:SetCharacterTag("Dead")
        self:ClearCharacterBattleInfo(false, DestroyReason)
        --if not self.SaveGame then GameState:RemoveGuideEid(self.Eid) end
    end

    if CommonUtils.CheckDestroyReason(DestroyReason, "IsClearGuide") then
        GameState:RemoveGuideEid(self.Eid)
    end
end

function Component:WCOnEMActorDestroy(GameMode)
    if not IsValid(GameMode:GetWCSubSystem()) then
        return
    end
    GameMode:GetWCSubSystem():UnregisterEntryToWorldComposition(self)
end

function Component:RemoveBuffOfInDirect()
    for i = 1, self.BuffManager.Buffs:Length() do
        local Buff = self.BuffManager.Buffs:GetRef(i)
        if Buff.SourceEid ~= self.Eid then
            self:RawRemoveBuff(Buff)
        end
    end
end

return Component
