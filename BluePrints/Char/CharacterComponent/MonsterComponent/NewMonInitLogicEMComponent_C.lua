require "UnLua"
local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"

local M = Class({
    "BluePrints.Common.TimerMgr",
})

-- The job that move these function to c++ is very hard 
-- Start
-- BattleCharInfo 战斗组导表参数，没法通过uproperty放到c++里，36.8us 
function M:NewMonInitComponent_GetDataInfo(Owner)
    Owner.BattleCharInfo = nil
    local RoleId = Owner.CurrentRoleId
    if not RoleId or RoleId == 0 then
        return
    end
    Owner.BattleCharInfo = DataMgr.BattleMonster[RoleId]
end

--function M:AddEvent_TalkEnableMonsterSpawn()
--    EventManager:AddEvent(EventID.TalkEnableMonsterSpawn, self, self.OnTalkEnableMonsterSpawn)
--end

--function M:OnTalkEnableMonsterSpawn()
--    self:NewInitComponentBase_SetWaitInitTag(false, Const.CharWaitInitTag.HideInTalk)
--    EventManager:RemoveEvent(EventID.TalkEnableMonsterSpawn, self)
--end

function M:NewMonInitComponent_TriggerSTLPostStaticCreatorEvent(Mode, Actor)
    Mode:TriggerSTLEvent("STLPostStaticCreatorEvent", Actor)
end

function M:NewMonInitComponent_GetData(Owner, UnitType, UnitId)
    Owner.Data = DataMgr[UnitType][UnitId]
end

function M:NewMonInitComponent_HardBossBTRunning(GameMode)
    return GameMode.BossBattleInfo["HardBossBTRunning"]
end

function M:NewMonInitComponent_SyncServerBornInfo(Owner)
   Owner.ServerBornInfo = Owner.BornInfo:ToEffectStruct()
end

function M:NewMonInitComponent_CallBPReceiveBeginPlay(Owner)
    Owner.Overridden.ReceiveBeginPlay(Owner)
    if not IsAuthority(Owner) and Owner.bIsFromCache then
        for Key, Value in pairs(Owner.Weapons) do 
            if Value ~= Owner.UsingWeapon and not Value.bChildWeapon then
                Value:ShouldHideWeapon(true) 
            end
        end
    end

    if Owner.TryStartOutAirWallCheck then
        Owner:TryStartOutAirWallCheck()
    end

    -- if Owner.SetHitCapsuleBeginplayState then
    --     DebugPrint("@gulinan init begin play SetHitCapsuleBeginplayState false")
    --     Owner:SetHitCapsuleBeginplayState(false)
    -- end
end

function M:NewMonInitComponent_TriggerDungeonComponentFun(GameMode, Name)
    return GameMode:TriggerDungeonComponentFun(Name)
end

-- GM Buffer
function M:NewMonInitComponent_AddGMBuff(Owner, GameMode, Value)
    for _, BuffId in pairs(GameMode.GMMonsterBuff) do
        Battle(Owner):AddBuffToTarget(Owner, Owner, BuffId, -1, Value, nil)
    end
end
-- End

--- Wait To Move To C++ Start
function M:NewMonInitComponent_CacheBornInfo(Owner)
    if not Owner.BornInfo then
        Owner.BornInfo = EffectResults.Result()
    end
end

function M:NewMonInitComponent_GetAirWallStaticId(Owner)
    local GameMode = UE4.UGameplayStatics.GetGameMode(Owner)
    return GameMode.BossBattleInfo["AirWallStaticId"]
end

function M:NewMonInitComponent_AddRoleSkillByContext(Owner, Context)
    local SkillInfos = Context:GetLuaTable("SkillInfos")
    local SkillInitInfo = TArray(FSkillInitInfo)

    if SkillInfos and next(SkillInfos) then
        for _, SkillInfo in ipairs(SkillInfos) do
            local SkillInitItem = FSkillInitInfo()
            SkillInitItem.SkillId = SkillInfo.SkillId
            SkillInitItem.SkillLevel = SkillInfo.SkillInfo.Level or 1
            SkillInitItem.SkillGrade = SkillInfo.SkillInfo.Grade or 0
            
            SkillInitInfo:Add(SkillInitItem)
        end
    end
    Owner:AddRoleSkill(Owner.CurrentRoleId, SkillInitInfo)
end

---------------------------------------------------------------- OnCharacterReady ------------------------------------------------------------
function M:NewMonInitComponent_TryPlayBirthMontage_Lua(Owner, BirthMontagePath)
    local MontageTime = Owner:PlayMontageByPath(BirthMontagePath)
    Owner:AddDelayFrameFunc(function()
        Owner:SetMeshVisibilityBasedAnimTickOption(EVisibilityBasedAnimTickOption.AlwaysTickPose)
        Owner:SetActorHideTag("Birth", false)
    end, 5)
    return MontageTime
end

function M:NewMonInitComponent_InitBossBillBoard(Owner, IsBossInPart,BossUIType)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(Owner)
    local UIManager = GameInstance:GetGameUIManager()
    if BossUIType == EBossUIType.None then
        if UIManager:GetUIObj("BossBlood") then
            UIManager:UnLoadUI("BossBlood")
        end
        Owner.BossBloodUI = UIManager:LoadUINew("BossBlood", Owner, IsBossInPart,BossUIType)
    else
        local DoubleBossUI = UIManager:GetUIObj("DoubleBossBlood") or UIManager:LoadUINew("DoubleBossBlood")
        if DoubleBossUI then
            if BossUIType == EBossUIType.Left then
               Owner.BossBloodUI = DoubleBossUI.Boss_1
            else
                Owner.BossBloodUI = DoubleBossUI.Boss_2
            end
            DoubleBossUI:ActiveBossUI()
            Owner.BossBloodUI:InitBossUI(Owner,IsBossInPart,BossUIType)
        end
    end
    Owner.BillboardComponent.IsInit = true
    Owner.BillboardComponent.Owner = Owner
end

-- only Editor
function M:NewMonInitComponent_OnCharacterReady_SpecialTakeRecord(Owner)
    Owner:AddInteractiveTrigger()
    Owner:SetInteractiveTriggerDistance(Owner:GetAttr("DropDistance"))
    local Controller = Owner:GetController()
    Controller:ForbidWeapon()
end

-------------------------------------------------------- Reset -----------------------------------------------------------

-------------------------------------------------------- DungeonPoolInit -----------------------------------------------------------------
function M:NewMonInitComponent_EnterPoolSetDataInfo(Owner)
    Owner.Data = DataMgr.Monster[Owner.UnitId]
    Owner.BattleCharInfo = nil
    local RoleId = Owner.CurrentRoleId
    if not RoleId or RoleId == 0 then
        return
    end
    Owner.BattleCharInfo = DataMgr.BattleMonster[RoleId]
end
-------------------------------------------------------- DungeonPoolInit -----------------------------------------------------------------

return M