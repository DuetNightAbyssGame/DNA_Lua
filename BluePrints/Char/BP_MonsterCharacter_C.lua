--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local ItemUtils = require "Utils.ItemUtils"
local CommonConst = require "CommonConst"
local UIUtils = require "Utils.UIUtils"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"

---@class BP_MonsterCharacter_C : BP_CharacterBase_C
local BP_MonsterCharacter_C = Class({
    "BluePrints.Char.BP_AICharacterBase_C",
    "BluePrints.Combat.Components.MonsterInitLogic",
    "BluePrints.Combat.BattleLogic.CampLogic",

    "BluePrints.Char.CharacterComponent.MonsterComponent.MonModelComponent",
})

BP_MonsterCharacter_C._components = {
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonUpdateBBComponent",
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonAlertComponent",
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonEliteComponent",
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonExtraVitaminComponent",
    "BluePrints.Char.CharacterComponent.MonsterComponent.MonCaptureComponent",
    "BluePrints.Char.CharacterComponent.MonsterComponent.MonPenalizeComponent",
    
    -- "BluePrints.Char.CharacterComponent.AddGuideComponent",挪到BP_AICharacterBase_C.lua
}

UE4.AMonsterCharacter.SetEQSOptimizationInfo(Const.bSkipEQSTestWhilePlatformWarning,Const.NumOfEQSItemWhilePlatformWarning)
UE4.AMonsterCharacter.SetAndroidPlayDeathEffectDist(Const.AndroidPlayDeathEffectDist)

function BP_MonsterCharacter_C:Initialize(Initializer)
    -- BP_MonsterCharacter_C.Super.Initialize(self)
    self.bIsBossInPart = false     --用于区分Boss的血条是否是分段血条，不是判断是否是Boss
end

function BP_MonsterCharacter_C:ReceiveBeginPlay()
    self.IsDestroied = false
	BP_MonsterCharacter_C.Super.ReceiveBeginPlay(self)
    local GameState = UGameplayStatics.GetGameState(self)
    if GameState and GameState:IsInRegion() then
        self.CharFSMComp.OnAfterTagChanged:Add(self,self.OnTagChange)
    end
    
    -- if not self.bAddExecuteInLuaDelegateLogic and self.ExecuteInLuaDelegate then
    --     self.bAddExecuteInLuaDelegateLogic = true
    --     self.ExecuteInLuaDelegate:Add(self,self.CallFromCPPDelegete)
    -- end
	-- self.StopBTFlags = {}
    -- 怪物默认预设由蓝图设置
    -- self.Mesh:SetCollisionProfileName(Const.InitialCollisionProfileName)
    -- self.MonBattleComponentTickTime = 0.1
    -- self.MonBattleComponentRemainTime = self.MonBattleComponentTickTime
end

function BP_MonsterCharacter_C:TryStartOutAirWallCheck(Info)
    local GameState = UGameplayStatics.GetGameState(self)
    local IsInDungeon = GameState and GameState:IsInDungeon()
    if GameState and IsInDungeon and URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) and GameState.CheckOutAirDoorBoxTransform ~= nil and GameState.CheckOutAirBoxLocal ~= nil then
        -- DebugPrint(self:GetName().." @gulinan Start AirDoorBoxOutCheck Timer")
        self.CheckOutAirDoorBoxTransform = GameState.CheckOutAirDoorBoxTransform
        self.CheckOutAirBoxLocal = GameState.CheckOutAirBoxLocal
        local bCanStartTime = not self.bInPool and self.IsDead and not self:IsDead() and self.InitSuccess and self.IsRealMonster and self:IsRealMonster()
        if bCanStartTime then
            self.TimeCount = 0
            self.CheckOutAirDoorHandle = self:AddTimer(1, function()
                if self.CheckOutAirDoorHandle == nil then
                    DebugPrint(self:GetName().." @gulinan AirDoorBoxOutCheck Handle is invalid but timer still tick")
                    self.RemoveTimer("CheckOutAirDoorBoxTimer")
                    self.CheckOutAirDoorHandle = nil
                end

                local bFilterActor = not self.bInPool and self.IsDead and not self:IsDead() and self.InitSuccess and self.IsRealMonster and self:IsRealMonster()
                if self ~= nil and not bFilterActor and self.CheckOutAirDoorHandle ~= nil then
                    self:RemoveTimer(self.CheckOutAirDoorHandle)
                    self.CheckOutAirDoorHandle = nil
                end
                
                self.CheckOutAirDoorBoxTransform.Scale3D = FVector(1,1,1)
                local CurLocalLoc = UE4.UKismetMathLibrary.InverseTransformLocation(self.CheckOutAirDoorBoxTransform, self:K2_GetActorLocation())
                if CurLocalLoc.X > self.CheckOutAirBoxLocal.X or CurLocalLoc.X < -self.CheckOutAirBoxLocal.X 
                or CurLocalLoc.Y > self.CheckOutAirBoxLocal.Y or CurLocalLoc.Y < -self.CheckOutAirBoxLocal.Y 
                or CurLocalLoc.Z > self.CheckOutAirBoxLocal.Z or CurLocalLoc.Z < -self.CheckOutAirBoxLocal.Z then
                    if self.TimeCount < 10 then
                        self.TimeCount = self.TimeCount + 1
                    else
                        -- DebugPrint(self:GetName().." @gulinan AirDoorBoxOutCheck Kill")
                        self.TimeCount = 0
                        Battle(self):BattleOnDead(self.Eid, self.Eid, 0, EDeathReason.StuckInWall)
                        
                        if self.CheckOutAirDoorHandle ~= nil then
                            self:RemoveTimer(self.CheckOutAirDoorHandle)
                            self.CheckOutAirDoorHandle = nil
                        end
                    end
                else
                    self.TimeCount = 0
                end
                -- UE4.UKismetSystemLibrary.DrawDebugSphere(self, self:K2_GetActorLocation() + FVector(0,0,20000), 50, 12, FLinearColor(0,255,0), 1, 10)
            end, true, 0, "CheckOutAirDoorBoxTimer", false)
        end
    end
end

function BP_MonsterCharacter_C:CallFromCPPDelegete(Type)
    DebugPrint("BP_MonsterCharacter_C:CallFromCPPDelegete",Type)
end

function BP_MonsterCharacter_C:OnTagChange(Eid,OldTag,NewTag)
    if NewTag~="HitFly"then return end
    local Mesh = self.Mesh
    if Mesh and Mesh.SkeletalMesh:GetPhysicsAsset() then
        local PhysicsAsset = Mesh.SkeletalMesh:GetPhysicsAsset()
        for _,BodySetup in pairs(PhysicsAsset.SkeletalBodySetups) do
            if BodySetup and BodySetup.PhysicsType == EPhysicsType.PhysType_Default and BodySetup.CollisionReponse ~= EBodyCollisionResponse.BodyCollision_Enabled then
                BodySetup.CollisionReponse = EBodyCollisionResponse.BodyCollision_Enabled
            end
        end
    end
end

-- function BP_MonsterCharacter_C:InitAttributeFromTable(InitFromAnimInst)
--     if self:IsPhantom() then
--         BP_MonsterCharacter_C.Super.InitAttributeFromTable(self,InitFromAnimInst)
--     end
-- end

-- function BP_MonsterCharacter_C:GetOwnBlackBoardComponent()
--     if self.OwnBlackBoardComponent == nil then
--         self.OwnBlackBoardComponent = UE4.UAIBlueprintHelperLibrary.GetBlackboard(self)
--     end
--     return self.OwnBlackBoardComponent
-- end

function BP_MonsterCharacter_C:SetReplaceAttrsLua(Context)
    local ReplaceAttrs = Context:GetLuaTable("ReplaceAttrs")
    if ReplaceAttrs then
        self:SetReplaceAttrs(ReplaceAttrs)
    end
end

function BP_MonsterCharacter_C:TryResumeRootMotionFromPush()
    if not self.bBePushed and self:GetRootMotionTagState(ESourceTags.ApplyPush) then
        self:EnableRootMotion(ESourceTags.ApplyPush)
    end
end

function BP_MonsterCharacter_C:TickMonsterBattleComponent(DeltaSeconds)
    -- self.MonBattleComponentRemainTime = self.MonBattleComponentRemainTime - DeltaSeconds
    -- if self.MonBattleComponentRemainTime <= 0 then
    --     local TmpTime = self.MonBattleComponentRemainTime
    --     self.MonBattleComponentRemainTime = self.MonBattleComponentTickTime
    --     self:TickComponent(self.MonBattleComponentTickTime - TmpTime)
    -- end
    self:TickComponent(DeltaSeconds)
end

function BP_MonsterCharacter_C:CheckMonsterCanReachTest()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Location = self:CheckMonsterCanReach(Player)
    if not Location then
        return
    end
    self:K2_SetActorLocation(Location, false, nil, false)
    print('selfCheckMonsterCanReachTest', Location)
end

function BP_MonsterCharacter_C:GetBlueprintPath()
    return self.Data.UnitBPPath
end

function BP_MonsterCharacter_C:PlayOutBattleMontage(MontageIndex)
	local Model = DataMgr.Model[self.ModelId]
	local GroupId = Model.BehaviorMontageGroupId
	if not GroupId or not DataMgr.BehaviorRuleId[GroupId] then
		return 0
	end
	local PossibleOutBattleMontageList = DataMgr.BehaviorRuleId[GroupId].OutBattleList
	if not PossibleOutBattleMontageList then
		return 0
	end
	self.LastOutBattleMontageIndex = PossibleOutBattleMontageList[MontageIndex]
	if not self.LastOutBattleMontageIndex then
		return 0
	end
	if not DataMgr.BehaviorMontage[self.LastOutBattleMontageIndex] then
		return 0
	end
	local Path = DataMgr.BehaviorMontage[self.LastOutBattleMontageIndex].MontagePath
	self:Montage_RepPlay(Path)
	return self.EMAnimInstance.NowMontageDuration
end

-- function BP_MonsterCharacter_C:PlayInBattleMontageCheck()
-- 	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	if GameMode:IsCommonAlertingMonster(self) then
-- 		return -1 
-- 	end
-- 	local MontageIndex
-- 	if self.LastOutBattleMontageIndex then
-- 		MontageIndex = DataMgr.BehaviorMontage[self.LastOutBattleMontageIndex] and DataMgr.BehaviorMontage[self.LastOutBattleMontageIndex].NextMontage
-- 	end
-- 	if not MontageIndex then
-- 		local Model = DataMgr.Model[self.ModelId]
-- 		local GroupId = Model.BehaviorMontageGroupId
-- 		if not GroupId or not DataMgr.BehaviorRuleId[GroupId] then
-- 			return -1
-- 		end
-- 		MontageIndex = DataMgr.BehaviorRuleId[GroupId].DefaultAlert
-- 	end
-- 	if not MontageIndex then
-- 		return -1
-- 	end
-- 	return MontageIndex
-- end

-- function BP_MonsterCharacter_C:PlayInBattleMontage()
-- 	local MontageIndex = self:PlayInBattleMontageCheck()
-- 	local Path = DataMgr.BehaviorMontage[MontageIndex].MontagePath
-- 	self:Montage_RepPlay(Path)
-- 	return Path, self.PlayerAnimInstance.NowMontageDuration
-- end

-- function BP_MonsterCharacter_C:GetObjType()
--     return EObjType.MonsterCharacter
-- end

-- function BP_MonsterCharacter_C:ActiveGuide(OpType) 挪到BP_AICharacterBase_C.lua
--     -- 激活指引
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local SceneMgrComponent = GameInstance:GetSceneManager()
--     if (IsValid(SceneMgrComponent) and self.Data and self.Data.GuideIconAni) then
--         SceneMgrComponent:UpdateSceneGuideIcon(self.Eid, self, nil, OpType, true, self.Data)
--     end
-- end

-- function BP_MonsterCharacter_C:DeactiveGuide()
--     -- 关闭指引
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local SceneMgrComponent = GameInstance:GetSceneManager()
--     if (IsValid(SceneMgrComponent) and self.Data and self.Data.GuideIconAni) then
--         SceneMgrComponent:UpdateSceneGuideIcon(self.Eid, self, nil, "Delete", true, self.Data)
--     end
-- end

-- function BP_MonsterCharacter_C:TriggerGenerateReward(Reason, ExtraInfo)
--     if not IsAuthority(self) then
--         return
--     end
--     if self.IsFallTrigger then
--         return
--     end
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     local RewardIds = GameMode:GetDropRule(self.UnitId)
--     if RewardIds and GameMode then
--         GameMode:TriggerGenerateReward(RewardIds, Reason, self:GetTransform(), ExtraInfo)
--     end
-- end

function BP_MonsterCharacter_C:OnEMActorDestroy_Lua(DestroyReason)
    -- local GameMode = UGameplayStatics.GetGameMode(self)
    -- -- NewRegionEnable
    -- if GameMode then
    --     GameMode:GetRegionDataMgrSubSystem():DeadRegionActorData(self, DestroyReason, GameMode:GetActorLevelName(self))
    -- end

    self:CommonOnEMActorDestroy(DestroyReason)
    -- if IsAuthority(self) then
    --     self:ServerOnEMActorDestroy(DestroyReason)
    -- end

    -- if (IsClient(self) or IsStandAlone(self)) and self.TeammateUI then
    --     local BattleMain = UIManager(self):GetUIObj("BattleMain")
    --     if BattleMain then
    --         BattleMain:RemoveTeammateUI(self.TeammateUI)
    --     end
    --     self.TeammateUI = nil
    -- end
end

--- @return bool 是否被player击杀(魅影也算)
-- function BP_MonsterCharacter_C:OnDeadTriggerSpawnReward(KillMineRoleEid, KillMineSkillId)
--     if self:IsSummonByPlayer() then
--         return
--     end
--     local KillMineRole = Battle(self):GetEntity(KillMineRoleEid)
--     if not KillMineRole then
--         return false
--     end
--     --local KillSourceType
--     --KillMineRole and KillMineRole.IsPlayer and KillMineRole:IsPlayer()

--     local bIsKillByPlayer = false;
--     local RootSource = KillMineRole:GetRootSource()
--     if not RootSource then
--         return false
--     end

--     if RootSource:IsPhantom() then
--         RootSource = RootSource.PhantomOwner
--     end
--     if RootSource:IsPlayer() then
--         bIsKillByPlayer = true
--     end

--     if IsAuthority(self) and self.MonsterDeathReason == EDeathReason.Damage then
--         local ExpRate, WeaponType
--         if bIsKillByPlayer then
--             local WeaponId
--             -- KillSourceType = self:GetKillSourceType(KillMineRoleEid)
--             -- if not RootSource:IsPlayer() and not RootSource:IsPhantom() then
--             --     return false
--             -- end
--             if RootSource.GetSkill then
--                 local Skill = RootSource:GetSkill(KillMineSkillId)
--                 if Skill and Skill.Weapon then
--                     WeaponId = Skill.Weapon.WeaponId
--                 end
--             end
--             ExpRate = RootSource:GetExpRate()

--             if RootSource.MeleeWeapon and RootSource.MeleeWeapon.WeaponId == WeaponId then
--                 WeaponType = CommonConst.WeaponType.MeleeWeapon
--             elseif RootSource.RangedWeapon and RootSource.RangedWeapon.WeaponId == WeaponId then
--                 WeaponType = CommonConst.WeaponType.RangedWeapon
--             end
--         end

--         local ExtraInfo = {
--             -- KillSourceType = KillSourceType,
--             UniqueSign = self.Eid,
--             KillerEid = RootSource.Eid,
--             bKilledByPlayer = bIsKillByPlayer,
--             WeaponType = WeaponType,
--             ExpRate = ExpRate,
--             UnitId = self.UnitId,
--             Level = self:GetAttr("Level"),
--             IsEliteMonster = UE4.UBlueprintGameplayTagLibrary.HasTag(self.GameplayTags,URuntimeCommonFunctionLibrary.BPRequestGameplayTag("Mon.Strong",false),false),
--             IsSummonMonster = self:IsSummonMonster(),
--         }
--         --DebugPrint("OnDead", IsUseWeapon, ExtraInfo)
--         self:TriggerGenerateReward(CommonConst.RewardReason.MonsterDead, ExtraInfo)
--     end
--     return bIsKillByPlayer
-- end

-- --- ---- 获取击杀源类型
function BP_MonsterCharacter_C:GetKillSourceType(KillMineRoleEid)
    local KillMineRole = Battle(self):GetEntity(KillMineRoleEid)
    local KillSourceType 
    if KillMineRole then
        local RootSource = KillMineRole:GetRootSource()
        if RootSource and RootSource.IsPlayer and RootSource:IsPlayer() then
            KillSourceType = CommonConst.ActorType.Player
        elseif RootSource and RootSource.IsCombatItemBase and RootSource:IsCombatItemBase() then
            KillSourceType = CommonConst.ActorType.CombatItemBase            
        end
    end
    return KillSourceType
end

-- function BP_MonsterCharacter_C:OnDeadShowJumpWord(DeathReason, DamageCauserLocation, IsPlayerKill, KillMineRoleEid)
--     -- 死亡之后的经验跳字
--     if (DeathReason ~= EDeathReason.TriggerFalling and DeathReason ~= EDeathReason.Capture and DeathReason~=EDeathReason.SpawnerClear 
--     and DeathReason~=EDeathReason.Falling ) and RewardUtils and self.KillRewardId and IsPlayerKill then
--         local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--         if not GameMode then return end
--         local Info = {
--             UnitId = self.UnitId,
--             Level = self:GetAttr("Level"),
--             IsEliteMonster = UE4.UBlueprintGameplayTagLibrary.HasTag(self.GameplayTags,URuntimeCommonFunctionLibrary.BPRequestGameplayTag("Mon.Strong",false),false)
--         }
--         local Exp = CommonUtils:GetMonsterExp(Info)
--         local KillMineRole = Battle(self):GetEntity(KillMineRoleEid)
--         if not KillMineRole then
--             return
--         end
--         local RootSource = KillMineRole:GetRootSource()
--         -- KillSourceType = self:GetKillSourceType(KillMineRoleEid)
--         local ExpRate = 0
--         if RootSource.IsPlayer and RootSource:IsPlayer() then
--             ExpRate = RootSource.BuffManager.ExpRate or 0
--         end
--         local ExpNum = math.floor(Exp * (ExpRate + 1) + 0.5)
--         if (ExpNum > 0) and GMVariable.EnableShowBillboard then
--             self.JumpWordComponent:TryToShowJumpWord(DamageCauserLocation, nil, "Exp", ExpNum, 0, 0, KillMineRoleEid, "", TArray(FName), TMap(FName, FRateStructFowShow))
--         end
--     end
-- end

-- function BP_MonsterCharacter_C:HandleDeathResult()
--     self.CapsuleComponent:SetCollisionProfileName("MonsterDeath")
--     if self.MonsterHitedCapsule then
--         self.MonsterHitedCapsule:SetCollisionProfileName("MonsterDeadCapsule")
--     end
--     if self.MonsterBlockPlayer then
--         self.MonsterBlockPlayer:SetCollisionEnabled(ECollisionEnabled.NoCollision)
--     end
--     self.Mesh:SetCollisionProfileName(Const.HittedCollisionProfileName)
--     if self:HasAnyTags_Table(self, Const.SurvivalPoisonMonster, false) then
--         local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--         if GameMode then
--             GameMode:PostCustomEvent("PoisonMonsterDead")
--         end
-- 		local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
-- 		local UIManager = GameInstance:GetGameUIManager()
-- 		if not UIManager then
-- 			return
-- 		end
-- 		local SurvivalPanel = UIManager:GetUIObj("DungenonSurviveFloat")
--         if not SurvivalPanel then
--             return
--         end
--         SurvivalPanel:OnSpecialMonsterDead()
--     end
-- end

-- function BP_MonsterCharacter_C:RealOnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
--     DebugPrint("Monster::RealOnDead", self:GetName(), DeathReason)
--     self.MonsterDeathReason = DeathReason
--     if self:IsSummonMonster() then
--         local SummonMaster = self:GetDirectSource()
--         if SummonMaster then
--             Battle(self):TriggerBattleEvent(BattleEventName.OnMySummonDying, SummonMaster, self)
--         end
--     end
--     if self:IsJailerMonster() then
--         local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--         if GameMode then
--             GameMode:TriggerDungeonAchieve("OnJailerMonsterDead", -1)
--         end
--     end
--     BP_MonsterCharacter_C.Super.RealOnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
--     local IsPlayerKill = self:OnDeadTriggerSpawnReward(KillMineRoleEid, KillMineSkillId)
--     self:HandleDeathResult()
--     self:ClearMonsterInfo()
--     self:RemoveRecoverHatredEvent()
--     local KillMineRole = Battle(self):GetEntity(KillMineRoleEid)
--     -- 如果怪物身上有指引，则删除其指引
--     -- self:DeactiveGuide()

--     if self:GetMonMoveComp() then
--         self:GetMonMoveComp():RealReleaseHoldTarget()
--     end

--     if not IsDedicatedServer(self) then
--         local BossBloodUI = self.bIsBossInPart and self.BossBloodUI
--         if BossBloodUI then
--             BossBloodUI:CloseBossBlood()
--         end

--         if (self.BillboardComponent ~= nil) then
--             self.BillboardComponent:CharOnDead()
--         end
--         local DamageCauserLocation = KillMineRole and KillMineRole:K2_GetActorLocation()
--         if DamageCauserLocation then
--             self:SetVector("DamageCauserLocation", DamageCauserLocation)
--         end
--         if self:IsAllowedExp() then
--             self:OnDeadShowJumpWord(DeathReason, DamageCauserLocation, IsPlayerKill, KillMineRoleEid)
--         end
--     end

--     -- 可能会直接走到EMActorDestroy
--     self:PlayDeadAnimation(DeathReason,self.PlayDieEffect)
-- end

--function BP_MonsterCharacter_C:OnDead_Lua(KillMineRoleEid, KillMineSkillId, DeathReason)
--    if (Const.bEnableMonDeathOptimization) and not self:IsSummonMonster() then
--        local EventMgr = UE4.URuntimeCommonFunctionLibrary.GetCurrentEventMgr(self)
--        if EventMgr then
--            EventMgr:AddMonsterDeadTask(self,KillMineRoleEid, KillMineSkillId, DeathReason)
--            return
--        end
--    end
--    BP_MonsterCharacter_C.Super.OnDead_Lua(self,KillMineRoleEid, KillMineSkillId, DeathReason)
--end

function BP_MonsterCharacter_C:IsAllowedExp()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
	if not Avatar:IsInDungeon() then
		return true
	end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local DungeonInfo = DataMgr.Dungeon[GameState.DungeonId]
    if not DungeonInfo then
        if DataMgr.HardBossDifficulty[GameState.DungeonId] then
            return true
        end
        return false
    end
    return not DungeonInfo.OnlyCombatReward
end

function BP_MonsterCharacter_C:Recovery(...)
    BP_MonsterCharacter_C.Super.Recovery(self, ...)
    self:SetCharacterTagIdle()
end

function BP_MonsterCharacter_C:OnDeadAnimationEnd()
    -- body
	-- TakeRecorder会录到这个Notify... 然后和已知逻辑打架， 在这里处理一下. 发布的时候可以干掉
    self.Mesh:SetCollisionProfileName("Ragdoll")
	if not self.IsSpawnedByMovieCaptureSequence then
		self.Mesh:SetAllBodiesBelowSimulatePhysics("root", true, false)
	end
    self.Mesh:SetAllBodiesPhysicsBlendWeight(1.0)
    -- self:BeginRagdollUpdate(true, "pelvis", 0, Const.HitFlyHeightMinValue)
    self:BeginRagdollState("Ragdoll","pelvis",-1,true,1.0,0.0,ERagdollStateType.RagdollStateDead)
    if self.DuringDyingHitFly then
        self.DuringDyingHitFly = nil
    end
end

function BP_MonsterCharacter_C:SetActionModeForBlackBoard(ActionMode)    
    if self:GetOwnBlackBoardComponent() then
        self:GetOwnBlackBoardComponent():SetValueAsEnum("ActionMode", ActionMode)
    end
end

function BP_MonsterCharacter_C:MonsterCommonLeaveTag()
    if not DataMgr.MonsterStateLimit[self.AutoSyncProp.CharacterTag] then
        return
    end
    if DataMgr.MonsterStateLimit[self.AutoSyncProp.CharacterTag].ForbidAI == 1 then
        self:ClearStopBTFlag(self.AutoSyncProp.CharacterTag)
    end
end

function BP_MonsterCharacter_C:TriggerFallingCallable(GameMode)
    DebugPrint("OtherActor is Falling Dead. ActorName: ", self:GetName(), ", UnitId: ", self.UnitId, ", Eid: ", self.Eid, ", CreatorId: ", self.CreatorId, " CreatorType: ", self.CreatorType, ", BornPos: ", self.BornPos)
    if self.IsSummonMonster and self:IsSummonMonster() then 
        local DirectSource = self:GetDirectSource()
	    if not DirectSource then
		    return
	    end
	    local AttachParent = self:GetAttachParentActor()
	    if AttachParent then
		    return
	    end
	    UNavigationFunctionLibrary.ActorToActorTeleport(self, DirectSource)
	    self:EnableCheckOverlapPush({})
	    if self.OnTriggerFallingCallable then
		    self:OnTriggerFallingCallable()
	    end
	    self:Landed()
    elseif self.IsCaptureMonster and self:IsCaptureMonster() then
        local NearestPlayer = nil
        local MinDis = 9999999
        for _, Player in pairs(GameMode:GetAllPlayer()) do
            if IsValid(Player) then
                local Dis = Player:GetDistanceTo(self)
                if Dis < MinDis then
                    MinDis = Dis
                    NearestPlayer = Player
                end
            end
        end
        if IsValid(NearestPlayer) then
            UNavigationFunctionLibrary.ActorToActorTeleport(self, NearestPlayer)
        end
    elseif self.IsAIControlled and self:IsAIControlled() then
        if not self:IsNPC() then
            self:SetIsFallTrigger()
            Battle(GameMode):BattleOnDead(self.Eid, self.Eid, 0, EDeathReason.TriggerFalling)
        end
    end
end

function BP_MonsterCharacter_C:TriggerWaterFallingCallable(GameMode)
    if self.IsCaptureMonster and self:IsCaptureMonster() then
        local NearestPlayer = nil
        local MinDis = 9999999
        for _, Player in pairs(GameMode:GetAllPlayer()) do
            if IsValid(Player) then
                local Dis = Player:GetDistanceTo(self)
                if Dis < MinDis then
                    MinDis = Dis
                    NearestPlayer = Player
                end
            end
        end
        if IsValid(NearestPlayer) then
            UNavigationFunctionLibrary.ActorToActorTeleport(self, NearestPlayer)
        end
    elseif self.IsMonster and self:IsMonster() then
        self:SetIsFallTrigger()
		Battle(self):BattleOnDead(self.Eid, self.Eid, 0, EDeathReason.TriggerFalling)
    end
end

-- function BP_MonsterCharacter_C:IsAtIsland()
--     if not IsAuthority(self) then
--         return false
--     end

--     local Target = self.BBTarget
--     local CharacterOnNav = false
--     if Target and UE4.UKismetSystemLibrary.IsValid(Target) then
--         local TwoPosPathType = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(self:K2_GetActorLocation(), Target:K2_GetActorLocation(),self)
--         CharacterOnNav = TwoPosPathType == Const.PathTypeHasPath
--     end

--     if CharacterOnNav then
--         return false
--     end

--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	for i, PlayerCharacter in pairs(GameMode:GetAllPlayer()) do
-- 		local TwoPosPathType = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(self:K2_GetActorLocation(), PlayerCharacter:K2_GetActorLocation(),self)
-- 		CharacterOnNav = CharacterOnNav or (TwoPosPathType == Const.PathTypeHasPath)
-- 		if CharacterOnNav then
-- 			return false
-- 		end
-- 	end

--     if self.BornPos then
--         return not (UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(self:K2_GetActorLocation(), self.BornPos,self) == Const.PathTypeHasPath)
--     end

--     return true
-- end

function BP_MonsterCharacter_C:CheckMonsterCanReach(Creator, IgnoreActorPos)
    local TwoPosPathType = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(self:K2_GetActorLocation(), Creator:K2_GetActorLocation(),self)

    if TwoPosPathType == Const.PathTypeHasPath then
        return nil
    end
    local MonsPos = self:K2_GetActorLocation()
    local CreatorPos = Creator:K2_GetActorLocation()
    local DeltaAngel = 36
    local CheckRadius = self.CapsuleComponent:GetUnscaledCapsuleRadius() * 10
    local Forward = self:GetActorForwardVector()
    for index = 0, 9 do
        local CosAngle = UE4.UKismetMathLibrary.DegCos(DeltaAngel * index)
        local SinAngle = UE4.UKismetMathLibrary.DegSin(DeltaAngel * index)
        local TargetVec = FVector(Forward.X * CosAngle + Forward.Y * SinAngle, Forward.Y * CosAngle - Forward.X * SinAngle, 0) * CheckRadius + MonsPos
        -- local FinalVec = FVector()
        -- local bProj = UE4.UNavigationSystemV1.K2_ProjectPointToNavigation(self, TargetVec, FinalVec)
        -- UE4.UKismetSystemLibrary.DrawDebugLine(self, TargetVec, TargetVec+FVector(0, 0,1000), FLinearColor(0,111,0), 60, 3)
        local TargetVecPathType = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(TargetVec, CreatorPos,self)
        if TargetVecPathType == Const.PathTypeHasPath then
            return TargetVec
        end
    end
    if IgnoreActorPos then
        return nil
    end
    return Creator:K2_GetActorLocation()
end

function BP_MonsterCharacter_C:SetIsFallTrigger()
    self.IsFallTrigger = true
end

function BP_MonsterCharacter_C:LeaveHitFlyTag()
end

-- Moved to C++
--function BP_MonsterCharacter_C:ClientMonsterEnableAim(Enabled)
--    if self.PlayerAnimInstance and Enabled then
--        self.PlayerAnimInstance.EnableAim = 1
--    elseif self.PlayerAnimInstance and not Enabled then
--        self.PlayerAnimInstance.EnableAim = 0
--    end
--end

function BP_MonsterCharacter_C:GetMonsterToTargetPitch()
    local Target = self.BBTarget
    if not Target then
        return 0
    end
    local TargetLocation = Target:K2_GetActorLocation()
    local SelfLocation = self:K2_GetActorLocation()
    local SelfToTarget = TargetLocation - SelfLocation
    local DesiredRotPitch = SelfToTarget:ToRotator().Pitch
    return DesiredRotPitch
end

-- function BP_MonsterCharacter_C:GetMonsterToTarget()
--     local Target = self.BBTarget
--     if not Target then
--         return self.LastToTargetResult or self:K2_GetActorLocation() 
--     end
--     local TargetLocation = Target:K2_GetActorLocation()
--     local SelfLocation = self.Mesh:GetSocketLocation("spine_03")
--     -- UE4.UKismetSystemLibrary.DrawDebugLine(self, SelfLocation, TargetLocation, FLinearColor(0,1,0), 60, 3)

--     local SelfToTarget = TargetLocation - SelfLocation
--     self.LastToTargetResult = SelfToTarget
--     return SelfToTarget
-- end

-- function BP_MonsterCharacter_C:ReceiveSound(SoundSourceLoc, Strength)
--     BP_MonsterCharacter_C.Super.ReceiveSound(self, SoundSourceLoc, Strength)
--     self.MonAlertComponent:AlertSetHearingInfo(SoundSourceLoc)
-- end

-- function BP_MonsterCharacter_C:ShowHeal(HealEvent)
--     BP_MonsterCharacter_C.Super.ShowHeal(self, HealEvent)
--     if not GMVariable.EnableShowBillboard then
--         return
--     end
--     if (HealEvent.HitPosition ~= nil and HealEvent.HitDirection ~= nil) then
--         self.JumpWordComponent:TryToShowJumpWord(HealEvent.HitPosition, HealEvent.HitDirection, "Cure", HealEvent.TrueValue, 0, HealEvent.TargetEid, HealEvent.DamageType,TArray(FName), TMap(FName, FRateStructFowShow))
--     else
--         self.JumpWordComponent:TryToShowJumpWord(UE4.FVector(0, 0, 0), nil, "Cure", HealEvent.TrueValue, 0, HealEvent.TargetEid, HealEvent.DamageType, TArray(FName), TMap(FName, FRateStructFowShow))
--     end
--     if (self.BillboardComponent ~= nil) then
--         if(self.IsBossInPart == true) then
--             EventManager:FireEvent(EventID.ShowBossBlood,"Heal", HealEvent)
--         -- else
--         --     self.BillboardComponent:RefreshMonsterInfoByAction("Heal", HealEvent.EnergyShieldReduce)
--         end

--     end
-- end

-- function BP_MonsterCharacter_C:ShowDeath(DissolveDuration)
--     if UGameplayStatics.GetGameInstance(self).IsTakeRecorderCapturing then
-- 		local appearActor=self:GetWorld():SpawnActor(LoadClass('/Game/BluePrints/Scene/TakeRecorder/BP_TakeRecorder_ShowDissolve.BP_TakeRecorder_ShowDissolve_C'),nil, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, self, nil, nil)
-- 		appearActor:K2_AttachToActor(self,'',0,0,0,true)
-- 	end
--     self:MonsterDead(DissolveDuration)
--     DissolveDuration = DissolveDuration + 0.1
--     local Weapon = self:GetCurrentWeapon()
--     if Weapon then
--         Weapon:ShowDissolve(DissolveDuration)
--     end
-- end

function BP_MonsterCharacter_C:TreasureMonsterInRougLikeOnDead()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:SpeciaMonsterOnDead(self.UnitId)
    end
end

-- function BP_MonsterCharacter_C:SetMonsterCoverPointInfo(Info)
--     2025.2.7 掩体功能废弃
--     self.CoverPointInfo = Info
--     if not self.CoverPointInfo.CoverPointValid then
--         return
--     end
--     local CoverType = -1
--     if self.CoverPointInfo.IsCrouch then
--         CoverType = self.CoverPointInfo.LocType
--     else
--         CoverType = self.CoverPointInfo.LocType + 3;
--     end

--     self:GetOwnBlackBoardComponent():SetValueAsInt("CoverType", CoverType)
--     if self.PlayerAnimInstance then
--         self.PlayerAnimInstance.CoverType = CoverType 
--     end
-- end

-- function BP_MonsterCharacter_C:ResetMonsterCoverPointInfo()
--     2025.2.7 掩体功能废弃
--     -- 先重置GameMode的掩体信息，再清除玩家身上以及黑板值的信息
--     if not IsAuthority(self) then 
--         return
--     end
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     GameMode:ResetCoverInfo(self.CoverPointInfo, self.Eid)

--     self.CoverPointInfo = FCoverPointStruct()
--     local BlackBoardComponent = self:GetOwnBlackBoardComponent()
--     if not BlackBoardComponent then
--         return
--     end
--     BlackBoardComponent:ClearValue("CoverLoc")
--     BlackBoardComponent:SetValueAsInt("CoverType", -1)
--     BlackBoardComponent:SetValueAsBool("CoverPointInfoValid", false)
--     BlackBoardComponent:SetValueAsBool("UsingIsSelf", false)
--     BlackBoardComponent:ClearValue("CoverEnterLoc")
--     self.PlayerAnimInstance.CoverType = -1
-- end

-- function BP_MonsterCharacter_C:GetJoinHatredListSource()
--     if not self:IsSummonMonster() then return end
--     local SummonSource
--     local JoinHatredList = self.Data.JoinHatredList
--     if JoinHatredList and JoinHatredList == Const.CanJoinHatredList then
--         SummonSource = self
--     end
--     return SummonSource
-- end

-- function BP_MonsterCharacter_C:GetJoinHatredListMaster()
--     if not self:IsSummonMonster() then return end
--     local SummonMaster
--     local ParentJoinHatredList = self.Data.ParentJoinHatredList
--     if ParentJoinHatredList and ParentJoinHatredList == Const.ParentCanJoinHatredList then
--         SummonMaster = self:GetDirectSource()
--     end
--     return SummonMaster
-- end

-- function BP_MonsterCharacter_C:GetPresetHatredValue(Target, Reason)
--     local HatredIncrement = 0
-- 	if Target:IsPlayer() then
--         HatredIncrement = DataMgr.PresetHatred["Player"][Reason]
-- 	elseif Target:IsAIControlled() then
-- 		HatredIncrement = DataMgr.PresetHatred["AIActor"][Reason]
--         if Target:IsPhantom() then
--             local HatredRatio = DataMgr.Phantom[Target.UnitId].HatredRatio or 1
--             HatredIncrement = HatredIncrement * HatredRatio
--         end
--     elseif Target:IsCombatItemBase("DefenceCore") then
--         HatredIncrement = DataMgr.PresetHatred["DefenceCore"][Reason]
--     elseif Target:IsCombatItemBase("Excavation") then
--         HatredIncrement = DataMgr.PresetHatred["Excavation"][Reason]
--     elseif Target:IsCombatItemBase("Trolly") then
--         HatredIncrement = DataMgr.PresetHatred["Hijack"][Reason]
--     end
-- 	HatredIncrement = HatredIncrement or 0
--     return HatredIncrement
-- end

function BP_MonsterCharacter_C:AddHatredTargetByWaitRecover(TargetEid)
    local Target = Battle(self):GetEntity(TargetEid)
    if not Target:IsPlayer() and not Target:IsAIControlled() then
        return
    end
    if not Target:IsDead() then
        return
    end
    local PresetHatredValue = self:GetPresetHatredValue(Target, "ReasonWaitRecover")
    if self.TargetHatred:Find(TargetEid) then
        self:RemoveHatredTarget(TargetEid)
        self:AddHatredTarget(TargetEid, PresetHatredValue, PresetHatredValue)
    end
end

function BP_MonsterCharacter_C:ListenRecoverHatredEvent()
    EventManager:AddEvent(EventID.CharDie, self, self.AddHatredTargetByWaitRecover)
end

function BP_MonsterCharacter_C:RemoveRecoverHatredEvent()
    EventManager:RemoveEvent(EventID.CharDie, self)
end

function BP_MonsterCharacter_C:GetSplingAnim()
    if not self.IsCoverMontage then
        return
    end
    local CoverType = self.CoverPointInfo.IsCrouch
end

--用于读取Model表， 取不同情况下的动画资源
function BP_MonsterCharacter_C:GetCoverMontageAnimAsset(AnimName)
    local MontageInfo = DataMgr.Model[self.ModelId]
    local MontageFolder, MontagePrefix = self:GetHitMontageFolderAndPrefix()
    if not MontageFolder then
        return nil,nil
    end
    local MontageName = MontagePrefix..AnimName
    local MontageFloderPath = MontageFolder.."Locomotion/"
    local MontageAnimBpPath = MontageFloderPath..MontageName..Const.MontageSuffix.."."..MontageName..Const.MontageSuffix
    return nil, MontageAnimBpPath
end

function BP_MonsterCharacter_C:IsLimitMontage()
    local SourceTag = DataMgr.MonsterStateLimit[self.AutoSyncProp.CharacterTag]["SourceTag"]
    return SourceTag == Const.StunTag
end

function BP_MonsterCharacter_C:PlayLimitMontage(StunName)
    if(self:IsLimitMontage() == false) then return end
    local Path = self:GetLimitMontagePath(StunName)
    if Path == nil then
        return
    end
    -- 全身动作
    self:PlayMontageByPath(Path, nil, false)
end

function BP_MonsterCharacter_C:StopLimitMontage(StunName)
    if(self:IsLimitMontage() == false) then return end
    local Path = self:GetLimitMontagePath(StunName)
    if Path == nil then
        return
    end
    local AnimationAsset = LoadObject(Path)
    if not AnimationAsset then
        return
    end
    self.EMAnimInstance:Montage_Stop(Const.MontageBlendOutTime, AnimationAsset)
end

function BP_MonsterCharacter_C:GetLimitMontagePath(StunName)
    local MontageFloder, MontagePrefix = self:GetHitMontageFolderAndPrefix()
    if MontageFloder ~= nil then
        local MontagePostfix = StunName .. "_Montage"
        local Path = MontageFloder.."Combat/Hit/"..MontagePrefix..MontagePostfix
        return Path
    else
        return nil
    end
end

function BP_MonsterCharacter_C:GetSkillIdBySkillType(SkillId)
    return SkillId
end

function BP_MonsterCharacter_C:GetCurrentAnimationBlueprint(Id)
    if self.Data and self.Data.AnimCoverPath then
        return self.Data.AnimCoverPath
    end
    return BP_MonsterCharacter_C.Super.GetCurrentAnimationBlueprint(self, Id)
end

-- function BP_MonsterCharacter_C:ClassifyMonster(Target)
--     if not Target then Target = self end
--     if self:HasAnyTags_Table(Target, Const.StrongMonster, false) then
--         return EMonsterTag.IsStrong
--     elseif self:HasAnyTags_Table(Target, Const.SummonLightMonster, false) then
--         return EMonsterTag.IsSummonLight
--     elseif self:HasAnyTags_Table(Target, Const.CaptureMonster, false) then
--         return EMonsterTag.IsCapture
--     elseif self:HasAnyTags_Table(Target, Const.InvisibleMonster, false) then
--         return EMonsterTag.IsInvisible
--     end
--     return EMonsterTag.Other
-- end

-- function BP_MonsterCharacter_C:ClassifyAttribute(Target)
--     if not Target then Target = self end
--     if self:HasAnyTags_Table(Target, {"Mon.Attribute.Water"}, false) then
--         return EMonsterAttr.Water
--     elseif self:HasAnyTags_Table(Target, {"Mon.Attribute.Fire"}, false) then
--         return EMonsterAttr.Fire
--     elseif self:HasAnyTags_Table(Target, {"Mon.Attribute.Wind"}, false) then
--         return EMonsterAttr.Wind
--     elseif self:HasAnyTags_Table(Target, {"Mon.Attribute.Thunder"}, false) then
--         return EMonsterAttr.Thunder
--     end
--     return EMonsterAttr.None
-- end

-- function BP_MonsterCharacter_C:ClassifyChangeColor(Target)
--     if not Target then
--         Target = self
--     end
--     if self:HasAnyTags_Table(Target, {"Mon.ChangeColor.BlastRobot01"}, false) then
--         return EMonsterChangeColor.BlastRobot01
--     end
--     return EMonsterChangeColor.None
-- end

function BP_MonsterCharacter_C:IsContainCollapsedGraphTag(CollapsedGraph)
    if CollapsedGraph == "None" then return false end
    if self:HasAnyTags_Table(self, {CollapsedGraph}, false) then
        return true
    end
    return false
end

function BP_MonsterCharacter_C:BlockTickLod(bEnable, Tag, TickObjectFlag)
    if self.Data and self.Data.DisableTicklod then
        return
    end

    if TickObjectFlag | ETickObjectFlag.FLAG_CHARMOVEMENTCOMPONENT  then
        GWorld.logger.errorlog("@wuzhijun：BlockTickLod.处理移动组件用 BlockTickLod_MoveComp")
        return
    end

	---@type UEMSignificanceMgrSubsystem
	local SignificanceMgrSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UEMSignificanceMgrSubsystem)
	if not SignificanceMgrSubsystem then
		return
	end
    SignificanceMgrSubsystem:BlockTickLod(ESignificanceTag.Monster, bEnable, self, Tag, TickObjectFlag)
end

function BP_MonsterCharacter_C:BlockTickLod_BT(bEnable, Tag)
    if self.Data and self.Data.DisableTicklod then
        return
    end
	local SignificanceMgrSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UEMSignificanceMgrSubsystem)
	if not SignificanceMgrSubsystem then
		return
	end

    SignificanceMgrSubsystem:BlockTickLod(ESignificanceTag.MonsterBT, bEnable, self:GetController(), Tag, ETickObjectFlag.FLAG_ACTOR | ETickObjectFlag.FLAG_BTCOMPONENT)
end

function BP_MonsterCharacter_C:CheckOverlapPushForChangeCollision(Channel, NewResponse)
    local function SetCollision()
        if self.CapsuleComponent then
            self.CapsuleComponent:SetCollisionResponseToChannel(Channel, NewResponse)
        end
    end

    return self:EnableCheckOverlapPush({self,SetCollision})
end

function BP_MonsterCharacter_C:IsNeedHideInTalk()
    if IsStandAlone(self) then
        return GWorld.GameInstance:GetTalkContext():HasDisableMonsterSpawn()
    else
        return false
    end
end

function BP_MonsterCharacter_C:OnTalkEnableMonsterSpawn()
    self:SetWaitInitTag(false, Const.CharWaitInitTag.HideInTalk)
    EventManager:RemoveEvent(EventID.TalkEnableMonsterSpawn, self)
end

function BP_MonsterCharacter_C:ReceiveEndPlay(EndPlayReason)
    EventManager:RemoveEvent(EventID.TalkEnableMonsterSpawn, self)
    EventManager:RemoveEvent(EventID.CharDie, self)
    GWorld.GameInstance.GlobalLockOnTargets:Remove(self.Eid)
    if self.BossBloodUI then
        self.BossBloodUI:UnLoadSelf()
        self.BossBloodUI = nil
    end
    self.IsDestroied = true
    -- if self.bAddExecuteInLuaDelegateLogic and self.ExecuteInLuaDelegate then
    --     self.bAddExecuteInLuaDelegateLogic = false
    --     self.ExecuteInLuaDelegate:Remove(self,self.CallFromCPPDelegete)
    -- end

    if self.CheckOutAirDoorHandle ~= nil then
        DebugPrint(self:GetName().." @gulinan Clear AirDoorBoxOutCheck Timer On Destroy")
        self.RemoveTimer(self.CheckOutAirDoorHandle)
        self.CheckOutAirDoorHandle = nil
    end
end

function BP_MonsterCharacter_C:UpdateCdAndUseSkill(SkillId)
    local Skill = self:GetSkill(SkillId)
    Skill:ResetSkillCd()
    return self:UseSkill(SkillId, 0)
end

function BP_MonsterCharacter_C:ReuseSkill(SkillIndex)
    local SkillId = self:GetSeqSkill(SkillIndex)
    if (SkillId == 0) then
        return false
    end
    local Skill = self:GetSkill(SkillId)
    if not Skill then
        return false
    end
    if Skill.SkillType == "Passive" then
        return false
    end
    self:AddTimer(0.05, self.UpdateCdAndUseSkill, true, 0, "ReuseSkillTimer", nil, SkillId)
end

function BP_MonsterCharacter_C:CallSuperFunction(FuncName,...)
    BP_MonsterCharacter_C.Super[FuncName](self, ...)
end

-- function BP_MonsterCharacter_C:IsCanTriggetBeAttacked(DamageEvent)
--     if DamageEvent.DamageTag then
--         for _, tag in pairs(DamageEvent.DamageTag) do
--             if tag == "Dot" then
--                 return false
--             end
--         end
--     end
--     if DamageEvent.DamageType and DataMgr.DamageType[DamageEvent.DamageType].DisableAddColor == 1 then
--         return false
--     end
--     return true
-- end

function BP_MonsterCharacter_C:OnTimeDilationChanged(TimeDilation,CurrentTimeDilation)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player then
        Player:TimeDilationPostProcess(TimeDilation,CurrentTimeDilation)
    end
end

function BP_MonsterCharacter_C:SetTreasureMonsterTarget(TargetLocation)
    self:GetOwnBlackBoardComponent():SetValueAsVector("ExtractionLoc", TargetLocation)
end

--function BP_MonsterCharacter_C:OnActorHideAll(bHide)
--    if self.IsBoss and (IsClient(self) or IsStandAlone(self)) then
--        local BossBloodUI = self.BossBloodUI
--        local Tag = bHide and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible
--        if BossBloodUI then
--            BossBloodUI:SetVisibility(Tag)
--            if not bHide and not BossBloodUI.IsResetBossToughness and BossBloodUI.OutHideTag then
--                BossBloodUI:OutHideTag()
--            end
--        end
--    end
--end

-- function BP_MonsterCharacter_C:TryToStartUIHitFeedBack(DamageEvent)
--     UIUtils.TryToStartUIHitFeedback(DamageEvent, self)
-- end
----------------------------------------------------------------

function BP_MonsterCharacter_C:GetManualItemId()
    return -1
end

-- function BP_MonsterCharacter_C:AfterActorTeleport()
--     self.Overridden.AfterActorTeleport(self)
--     self:UpdateCurrentLevelId()
-- end

function BP_MonsterCharacter_C:CommonOnEMActorDestroy(DestroyReason)
	-- if self:IsSummonMonster() then
	-- 	if IsStandAlone(self) or IsClient(self) then
	-- 		EventManager:FireEvent(EventID.OnCharRemoveSummoner, self)
	-- 	end
	-- end
	
    -- EventManager:RemoveEvent(EventID.TalkEnableMonsterSpawn, self) -- 怪物现在不会监听这个事件了，初始化组件自己监听
    -- if DestroyReason == EDestroyReason.EngineDestroy then
    --    return
    -- end
    -- self:ClearFXComponent()
    -- self.GameplayTagsTable = nil  -- 从hcc出来的怪UnitId不会变，这个不需要清除
end

function BP_MonsterCharacter_C:SetHitCapsuleBeginplayState(bEnableEnd)
    DebugPrint("@gulinan SetHitCapsuleBeginplayState ".. tostring(bEnableEnd))
    self.bHitCapsuleBeginplay = bEnableEnd
end

function BP_MonsterCharacter_C:PhysStateErrorReset_Lua()
    Battle(self):ShowError_Monster_Inner_Lua("PhysStateErrorReset_Lua" .. self:GetName())
    self.Mesh:TermBodiesBelow("Root")
end

----------------------------------------------------------------- 初始化 --------------------------------------------------------------------------
-- 一些原本写在lua的component放到C++之后，初始化的执行顺序要保持跟之前一样，就只能通过lua里的InitComponent(有些逻辑不知道能不能在begin play跑)
-- function BP_MonsterCharacter_C:InitComponent()
--     local Components = {
--         self.MonEliteComponent,
--         self.MonUpdateBBComponent,
--         self.MonAlertComponent
--     }

--     for _,Component in pairs(Components) do
--         if Component and Component.InitComponent then
--             Component:InitComponent()
--         end
--     end

-- end

-- 软引用对InitExpressionPlane赋值
--function BP_MonsterCharacter_C:InitExpressionPlane()
--    if self.ExpressionPlane then
--        local StaticMesh = UKismetSystemLibrary.LoadAsset_Blocking(self.ExpressionPlaneStaticMeshSoftPtr)
--        self.ExpressionPlane:SetStaticMesh(StaticMesh)
--    end
--end

-- function BP_MonsterCharacter_C:RealInitInfoLua_Stamp(Context)
--     DebugPrint("@gulinan Monster::RealInitInfoLua_Stamp", self:GetName())
--     -- self.bInInitialMeshTick = true;
-- 	self.InitialMeshTickTime = 0;
-- end
------------------------------------------------------------------- 初始化 --------------------------------------------------------------------------
----------------------------------------------------------------- 缓存池 ----------------------------------------------------------------

AssembleComponents(BP_MonsterCharacter_C)

if BP_MonsterCharacter_C.TickComponent then
    AMonsterCharacter.SetHasLuaComponentTick(true)
end

return BP_MonsterCharacter_C
