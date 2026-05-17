--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
--！！！！！完全是从BP_MonsterCharacter_C.lua复制过来的（2024/5/9 131587版本），需要逐步去掉Monster的逻辑，只保留Npc的逻辑，最终把这里的逻辑都挪到BP_NPC_C.lua
--！！！！！Monster和Npc共有的逻辑需要逐步移到BP_AICharacterBase_C.lua

require "UnLua"
local ItemUtils = require "Utils.ItemUtils"
local CommonConst = require "CommonConst"
local UIUtils = require "Utils.UIUtils"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"

---@class BP_NpcCharacterBase_C : BP_CharacterBase_C
local BP_NpcCharacterBase_C = Class({
    "BluePrints.Char.BP_AICharacterBase_C",
    "BluePrints.Combat.Components.MonsterInitLogic",
    -- "BluePrints.Combat.BattleLogic.CampLogic",

    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonModelComponent",
})

BP_NpcCharacterBase_C._components = {
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonUpdateBBComponent",
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonAlertComponent",
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonEliteComponent",
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonExtraVitaminComponent",
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonCaptureComponent",
    -- "BluePrints.Char.CharacterComponent.MonsterComponent.MonPenalizeComponent",
    
    --"BluePrints.Char.CharacterComponent.AddGuideComponent",挪到BP_AICharacterBase_C.lua
}

function BP_NpcCharacterBase_C:Initialize(Initializer)
    -- BP_NpcCharacterBase_C.Super.Initialize(self)
    self.bIsBossInPart = false     --用于区分Boss的血条是否是分段血条，不是判断是否是Boss
end

function BP_NpcCharacterBase_C:ReceiveBeginPlay()
	BP_NpcCharacterBase_C.Super.ReceiveBeginPlay(self)
	-- self.StopBTFlags = {}
    -- 怪物默认预设由蓝图设置
    -- self.Mesh:SetCollisionProfileName(Const.InitialCollisionProfileName)
    self.MonBattleComponentTickTime = 0.1
    self.MonBattleComponentRemainTime = self.MonBattleComponentTickTime
end

-- function BP_NpcCharacterBase_C:GetOwnBlackBoardComponent()
--     if self.OwnBlackBoardComponent == nil then
--         self.OwnBlackBoardComponent = UE4.UAIBlueprintHelperLibrary.GetBlackboard(self)
--     end
--     return self.OwnBlackBoardComponent
-- end

function BP_NpcCharacterBase_C:TryResumeRootMotionFromPush()
    if not self.bBePushed and self:GetRootMotionTagState(ESourceTags.ApplyPush) then
        self:EnableRootMotion(ESourceTags.ApplyPush)
    end
end

-- function BP_NpcCharacterBase_C:TickMonsterBattleComponent(DeltaSeconds)
--     self.MonBattleComponentRemainTime = self.MonBattleComponentRemainTime - DeltaSeconds
--     if self.MonBattleComponentRemainTime <= 0 then
--         local TmpTime = self.MonBattleComponentRemainTime
--         self.MonBattleComponentRemainTime = self.MonBattleComponentTickTime
--         self:TickComponent(self.MonBattleComponentTickTime - TmpTime)
--     end
-- end

-- function BP_NpcCharacterBase_C:CheckMonsterCanReachTest()
--     local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--     local Location = self:CheckMonsterCanReach(Player)
--     if not Location then
--         return
--     end
--     self:K2_SetActorLocation(Location, false, nil, false)
--     print('selfCheckMonsterCanReachTest', Location)
-- end

function BP_NpcCharacterBase_C:GetBlueprintPath()
    return self.Data.UnitBPPath
end

-- function BP_NpcCharacterBase_C:PlayOutBattleMontage(MontageIndex)
-- 	local Model = DataMgr.Model[self.ModelId]
-- 	local GroupId = Model.BehaviorMontageGroupId
-- 	if not GroupId or not DataMgr.BehaviorRuleId[GroupId] then
-- 		return 0
-- 	end
-- 	local PossibleOutBattleMontageList = DataMgr.BehaviorRuleId[GroupId].OutBattleList
-- 	if not PossibleOutBattleMontageList then
-- 		return 0
-- 	end
-- 	self.LastOutBattleMontageIndex = PossibleOutBattleMontageList[MontageIndex]
-- 	if not self.LastOutBattleMontageIndex then
-- 		return 0
-- 	end
-- 	if not DataMgr.BehaviorMontage[self.LastOutBattleMontageIndex] then
-- 		return 0
-- 	end
-- 	local Path = DataMgr.BehaviorMontage[self.LastOutBattleMontageIndex].MontagePath
-- 	self:Montage_RepPlay(Path)
-- 	return self.PlayerAnimInstance.NowMontageDuration
-- end

-- function BP_NpcCharacterBase_C:PlayInBattleMontageCheck()
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

-- function BP_NpcCharacterBase_C:PlayInBattleMontage()
-- 	local MontageIndex = self:PlayInBattleMontageCheck()
-- 	local Path = DataMgr.BehaviorMontage[MontageIndex].MontagePath
-- 	self:Montage_RepPlay(Path)
-- 	return Path, self.PlayerAnimInstance.NowMontageDuration
-- end

-- function BP_NpcCharacterBase_C:GetObjType()
--     return EObjType.NpcCharacter
-- end

-- function BP_NpcCharacterBase_C:ActiveGuide(OpType) 挪到BP_AICharacterBase_C.lua
--     -- 激活指引
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local SceneMgrComponent = GameInstance:GetSceneManager()
--     if (IsValid(SceneMgrComponent) and self.Data and self.Data.GuideIconAni) then
--         SceneMgrComponent:UpdateSceneGuideIcon(self.Eid, self, nil, OpType, true, self.Data)
--     end
-- end

-- function BP_NpcCharacterBase_C:DeactiveGuide()
--     -- 关闭指引
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local SceneMgrComponent = GameInstance:GetSceneManager()
--     if (IsValid(SceneMgrComponent) and self.Data and self.Data.GuideIconAni) then
--         SceneMgrComponent:UpdateSceneGuideIcon(self.Eid, self, nil, "Delete", true, self.Data)
--     end
-- end

-- function BP_NpcCharacterBase_C:TriggerGenerateReward(Reason, ExtraInfo)
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

function BP_NpcCharacterBase_C:OnEMActorDestroy_Lua(DestroyReason)
    local GameMode = UGameplayStatics.GetGameMode(self)
    -- NewRegionEnable
    if GameMode then
        GameMode:GetRegionDataMgrSubSystem():DeadRegionActorData(self, DestroyReason, GameMode:GetActorLevelName(self))
    end
    
    self:CommonOnEMActorDestroy(DestroyReason)
    if IsAuthority(self) then
        self:ServerOnEMActorDestroy(DestroyReason)
    end

    if (IsClient(self) or IsStandAlone(self)) and self.TeammateUI then
        local BattleMain = UIManager(self):GetUIObj("BattleMain")
        if BattleMain then
            BattleMain:RemoveTeammateUI(self.TeammateUI)
        end
        self.TeammateUI = nil
    end
end

function BP_NpcCharacterBase_C:Recovery(...)
    BP_NpcCharacterBase_C.Super.Recovery(self, ...)
    self:SetCharacterTagIdle()
end



function BP_NpcCharacterBase_C:SetIsFallTrigger()
    self.IsFallTrigger = true
end

function BP_NpcCharacterBase_C:LeaveHitFlyTag()
end

-- function BP_NpcCharacterBase_C:ClientMonsterEnableAim(Enabled)
--     if self.PlayerAnimInstance and Enabled then
--         self.PlayerAnimInstance.EnableAim = 1
--     elseif self.PlayerAnimInstance and not Enabled then
--         self.PlayerAnimInstance.EnableAim = 0
--     end
-- end

-- function BP_NpcCharacterBase_C:GetMonsterToTargetPitch()
--     local Target = self.BBTarget
--     if not Target then
--         return 0
--     end
--     local TargetLocation = Target:K2_GetActorLocation()
--     local SelfLocation = self:K2_GetActorLocation()
--     local SelfToTarget = TargetLocation - SelfLocation
--     local DesiredRotPitch = SelfToTarget:ToRotator().Pitch
--     return DesiredRotPitch
-- end

-- function BP_NpcCharacterBase_C:GetMonsterToTarget()
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

-- function BP_NpcCharacterBase_C:ReceiveSound(SoundSourceLoc, Strength)
--     BP_NpcCharacterBase_C.Super.ReceiveSound(self, SoundSourceLoc, Strength)
--     self.MonAlertComponent:AlertSetHearingInfo(SoundSourceLoc)
-- end

-- function BP_NpcCharacterBase_C:ShowHeal(HealEvent)
--     BP_NpcCharacterBase_C.Super.ShowHeal(self, HealEvent)
--     if not GMVariable.EnableShowBillboard then
--         return
--     end
--     if (HealEvent.HitPosition ~= nil and HealEvent.HitDirection ~= nil) then
--         self.JumpWordComponent:TryToShowJumpWord(HealEvent.HitPosition, HealEvent.HitDirection, "Cure", HealEvent.TrueValue, 0, HealEvent.SourceEid, HealEvent.TargetEid, HealEvent.DamageType,TArray(FName), TMap(FName, FRateStructFowShow))
--     else
--         self.JumpWordComponent:TryToShowJumpWord(UE4.FVector(0, 0, 0), nil, "Cure", HealEvent.TrueValue, 0, HealEvent.SourceEid, HealEvent.TargetEid, HealEvent.DamageType, TArray(FName), TMap(FName, FRateStructFowShow))
--     end
--     if (self.BillboardComponent ~= nil) then
--         if(self.IsBossInPart == true) then
--             EventManager:FireEvent(EventID.ShowBossBlood,"Heal", HealEvent)
--         -- else
--         --     self.BillboardComponent:RefreshMonsterInfoByAction("Heal", HealEvent.EnergyShieldReduce)
--         end

--     end
-- end

-- function BP_NpcCharacterBase_C:ShowDeath(DissolveDuration)
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

-- function BP_NpcCharacterBase_C:GetJoinHatredListSource()
--     if not self:IsSummonMonster() then return end
--     local SummonSource
--     local JoinHatredList = self.Data.JoinHatredList
--     if JoinHatredList and JoinHatredList == Const.CanJoinHatredList then
--         SummonSource = self
--     end
--     return SummonSource
-- end

-- function BP_NpcCharacterBase_C:GetJoinHatredListMaster()
--     if not self:IsSummonMonster() then return end
--     local SummonMaster
--     local ParentJoinHatredList = self.Data.ParentJoinHatredList
--     if ParentJoinHatredList and ParentJoinHatredList == Const.ParentCanJoinHatredList then
--         SummonMaster = self:GetDirectSource()
--     end
--     return SummonMaster
-- end

-- function BP_NpcCharacterBase_C:GetPresetHatredValue(Target, Reason)
--     local HatredIncrement = 0
-- 	if Target:IsPlayer() then
--         HatredIncrement = DataMgr.PresetHatred["Player"][Reason]
-- 	elseif Target:IsAIControlled() then
-- 		HatredIncrement = DataMgr.PresetHatred["AIActor"][Reason]
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

-- function BP_NpcCharacterBase_C:AddHatredTargetByWaitRecover(TargetEid)
--     local Target = Battle(self):GetEntity(TargetEid)
--     if not Target:IsPlayer() and not Target:IsAIControlled() then
--         return
--     end
--     if not Target:IsNearDying() then
--         return
--     end
--     local PresetHatredValue = self:GetPresetHatredValue(Target, "ReasonWaitRecover")
--     if self.TargetHatred:Find(TargetEid) then
--         self:RemoveHatredTarget(TargetEid)
--         self:AddHatredTarget(TargetEid, PresetHatredValue, PresetHatredValue)
--     end
-- end

-- function BP_NpcCharacterBase_C:ListenRecoverHatredEvent()
--     EventManager:AddEvent(EventID.CharDie, self, self.AddHatredTargetByWaitRecover)
-- end

-- function BP_NpcCharacterBase_C:RemoveRecoverHatredEvent()
--     EventManager:RemoveEvent(EventID.CharDie, self)
-- end

-- function BP_NpcCharacterBase_C:GetSplingAnim()
--     if not self.IsCoverMontage then
--         return
--     end
--     local CoverType = self.CoverPointInfo.IsCrouch
-- end

-- --用于读取Model表， 取不同情况下的动画资源
-- function BP_NpcCharacterBase_C:GetCoverMontageAnimAsset(AnimName)
--     local MontageInfo = DataMgr.Model[self.ModelId]
--     local MontageFolder, MontagePrefix = self:GetHitMontageFolderAndPrefix()
--     if not MontageFolder then
--         return nil,nil
--     end
--     local MontageName = MontagePrefix..AnimName
--     local MontageFloderPath = MontageFolder.."Locomotion/"
--     local MontageAnimBpPath = MontageFloderPath..MontageName..Const.MontageSuffix.."."..MontageName..Const.MontageSuffix
--     return nil, MontageAnimBpPath
-- end

-- function BP_NpcCharacterBase_C:IsLimitMontage()
--     local SourceTag = DataMgr.MonsterStateLimit[self.AutoSyncProp.CharacterTag]["SourceTag"]
--     return SourceTag == Const.StunTag
-- end

-- function BP_NpcCharacterBase_C:PlayLimitMontage(StunName)
--     if(self:IsLimitMontage() == false) then return end
--     local Path = self:GetLimitMontagePath(StunName)
--     if Path == nil then
--         return
--     end
--     -- 全身动作
--     self:PlayMontageByPath(Path, nil, false)
-- end

-- function BP_NpcCharacterBase_C:StopLimitMontage(StunName)
--     if(self:IsLimitMontage() == false) then return end
--     local Path = self:GetLimitMontagePath(StunName)
--     if Path == nil then
--         return
--     end
--     local AnimationAsset = LoadObject(Path)
--     if not AnimationAsset then
--         return
--     end
--     self.PlayerAnimInstance:Montage_Stop(Const.MontageBlendOutTime, AnimationAsset)
-- end

-- function BP_NpcCharacterBase_C:GetLimitMontagePath(StunName)
--     local MontageFloder, MontagePrefix = self:GetHitMontageFolderAndPrefix()
--     if MontageFloder ~= nil then
--         local MontagePostfix = StunName .. "_Montage"
--         local Path = MontageFloder.."Combat/Hit/"..MontagePrefix..MontagePostfix
--         return Path
--     else
--         return nil
--     end
-- end

-- function BP_NpcCharacterBase_C:GetSkillIdBySkillType(SkillId)
--     return SkillId
-- end

-- function BP_NpcCharacterBase_C:LuaMonsterReset()
--     self:CMonsterReset()
-- end

-- function BP_NpcCharacterBase_C:TriggerRelationSpawnInfo(DestroyReason)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     if not GameMode or not GameMode.TacMapManager then
--         return
--     end

--     -- 非正常死亡则补充一只
--     if CommonUtils.CheckDestroyReason(DestroyReason, "IsTriggrRelationSpawn") and self.CreatorType == "MonsterSpawn" and self.RelationSpawn then
--         local PresetTarget = Battle(self):GetEntity(self.OriginalTargetHatred)
--         if not IsValid(PresetTarget) then
--             PresetTarget = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--         end

--         local TacmapSpawnInfo = {} 
--         TacmapSpawnInfo[PresetTarget] = 1
--         local Location = GameMode.TacMapManager:GetSpawnPoints({PresetTargets = TacmapSpawnInfo, Mode = "Player"})
--         if #Location == 0 then 
--             return 
--         end

--         local MonsterSpawn = self.MonsterSpawn or GameMode.FixedMonsterSpawn
--         GameMode.EMGameState.EventMgr:CreateUnit({
--             UnitType = "Monster",
--             UnitId = self.UnitId,
--             Loc = Location[1],
--             MonsterSpawn = MonsterSpawn,
--             RelationSpawn = true,
--             Level = self.Level,
--             PresetTarget = PresetTarget,
--         })
--     end
-- end

-- function BP_NpcCharacterBase_C:GetCurrentAnimationBlueprint(Id)
--     if self.Data and self.Data.AnimCoverPath then
--         return self.Data.AnimCoverPath
--     end
--     return BP_NpcCharacterBase_C.Super.GetCurrentAnimationBlueprint(self, Id)
-- end

-- function BP_NpcCharacterBase_C:ClassifyMonster(Target)
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

-- function BP_NpcCharacterBase_C:ClassifyAttribute(Target)
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

-- function BP_NpcCharacterBase_C:ClassifyChangeColor(Target)
--     if not Target then
--         Target = self
--     end
--     if self:HasAnyTags_Table(Target, {"Mon.ChangeColor.BlastRobot01"}, false) then
--         return EMonsterChangeColor.BlastRobot01
--     end
--     return EMonsterChangeColor.None
-- end

-- function BP_NpcCharacterBase_C:IsContainCollapsedGraphTag(CollapsedGraph)
--     if CollapsedGraph == "None" then return false end
--     if self:HasAnyTags_Table(self, {CollapsedGraph}, false) then
--         return true
--     end
--     return false
-- end

-- function BP_NpcCharacterBase_C:BlockTickLod(bEnable, Tag, TickObjectFlag)
--     if self.Data and self.Data.DisableTicklod then
--         return
--     end
-- 	---@type UEMSignificanceMgrSubsystem
-- 	local SignificanceMgrSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UEMSignificanceMgrSubsystem)
-- 	if not SignificanceMgrSubsystem then
-- 		return
-- 	end
--     SignificanceMgrSubsystem:BlockTickLod(ESignificanceTag.Monster, bEnable, self, Tag, TickObjectFlag)
--     SignificanceMgrSubsystem:BlockTickLod(ESignificanceTag.Monster, bEnable, self:GetController(), Tag, ETickObjectFlag.FLAG_ACTOR & ETickObjectFlag.FLAG_BTCOMPONENT)
-- end

-- function BP_NpcCharacterBase_C:CheckOverlapPushForChangeCollision(Channel, NewResponse)
--     local function SetCollision()
--         if self.CapsuleComponent then
--             self.CapsuleComponent:SetCollisionResponseToChannel(Channel, NewResponse)
--         end
--     end

--     return self:EnableCheckOverlapPush(SetCollision)
-- end


-- function BP_NpcCharacterBase_C:IsNeedHideInTalk()
--     if IsStandAlone(self) then
--         return GWorld.GameInstance:GetTalkContext():HasDisableMonsterSpawn()
--     else
--         return false
--     end
-- end

function BP_NpcCharacterBase_C:OnTalkEnableMonsterSpawn()
    self:SetWaitInitTag(false, Const.CharWaitInitTag.HideInTalk)
    EventManager:RemoveEvent(EventID.TalkEnableMonsterSpawn, self)
end

function BP_NpcCharacterBase_C:ReceiveEndPlay(EndPlayReason)
    EventManager:RemoveEvent(EventID.TalkEnableMonsterSpawn, self)
    GWorld.GameInstance.GlobalLockOnTargets:Remove(self.Eid)
end

-- function BP_NpcCharacterBase_C:UpdateCdAndUseSkill(SkillId)
--     local Skill = self:GetSkill(SkillId)
--     Skill:ResetSkillCd()
--     return self:UseSkill(SkillId)
-- end

-- function BP_NpcCharacterBase_C:ReuseSkill(SkillIndex)
--     local SkillId = self:GetSeqSkill(SkillIndex)
--     if (SkillId == 0) then
--         return false
--     end
--     local Skill = self:GetSkill(SkillId)
--     if not Skill then
--         return false
--     end
--     if Skill.SkillType == "Passive" then
--         return false
--     end
--     self:AddTimer(0.05, self.UpdateCdAndUseSkill, true, 0, "ReuseSkillTimer", nil, SkillId)
-- end

function BP_NpcCharacterBase_C:CallSuperFunction(FuncName,...)
    BP_NpcCharacterBase_C.Super[FuncName](self, ...)
end

-- function BP_NpcCharacterBase_C:IsCanTriggetBeAttacked(DamageEvent)
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

-- function BP_NpcCharacterBase_C:SetTreasureMonsterTarget(TargetLocation)
--     self:GetOwnBlackBoardComponent():SetValueAsVector("ExtractionLoc", TargetLocation)
-- end

--function BP_NpcCharacterBase_C:OnActorHideAll(bHide)
    -- if self.IsBoss and (IsClient(self) or IsStandAlone(self)) then
    --     local UIManager = GWorld.GameInstance:GetGameUIManager()
    --     local BossBloodUI = UIManager:GetUIObj("BossBlood")
    --     local Tag = bHide and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible
    --     if BossBloodUI then
    --         BossBloodUI:SetVisibility(Tag)
    --         if not bHide and not BossBloodUI.IsResetBossToughness and BossBloodUI.OutHideTag then
    --             BossBloodUI:OutHideTag()
    --         end
    --     end
    -- end
--end

-- function BP_NpcCharacterBase_C:TryToStartUIHitFeedBack(DamageEvent)
--     UIUtils.TryToStartUIHitFeedback(DamageEvent, self)
-- end
----------------------------------------------------------------

function BP_NpcCharacterBase_C:GetManualItemId()
    return -1
end

-- function BP_NpcCharacterBase_C:AfterActorTeleport()
--     self.Overridden.AfterActorTeleport(self)
--     self:UpdateCurrentLevelId()
-- end

----------------------------------------------------------------- 初始化 --------------------------------------------------------------------------
function BP_NpcCharacterBase_C:CommonOnEMActorDestroy(DestroyReason)
    EventManager:RemoveEvent(EventID.TalkEnableMonsterSpawn, self)
    if DestroyReason == EDestroyReason.EngineDestroy then
       return
    end
    self:ClearFXComponent()
    self.GameplayTagsTable = nil
end
----------------------------------------------------------------- 初始化 --------------------------------------------------------------------------

-- 一些原本写在lua的component放到C++之后，初始化的执行顺序要保持跟之前一样，就只能通过lua里的InitComponent(有些逻辑不知道能不能在begin play跑)
-- function BP_NpcCharacterBase_C:InitComponent()
--     local Components = {
--         -- self.MonEliteComponent,
--         self.MonUpdateBBComponent,
--         -- self.MonAlertComponent
--     }

--     for _,Component in pairs(Components) do
--         if Component and Component.InitComponent then
--             Component:InitComponent()
--         end
--     end

-- end

-- -- 软引用对InitExpressionPlane赋值
-- function BP_NpcCharacterBase_C:InitExpressionPlane()
--     if self.ExpressionPlane then
--         local StaticMesh = UKismetSystemLibrary.LoadAsset_Blocking(self.ExpressionPlaneStaticMeshSoftPtr)
--         self.ExpressionPlane:SetStaticMesh(StaticMesh)
--     end
-- end

AssembleComponents(BP_NpcCharacterBase_C)
return BP_NpcCharacterBase_C
