local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
require "UnLua"

-- 魅影
local BP_PhantomCharacter = Class({
	"BluePrints.Char.BP_MonsterCharacter_C",
	"BluePrints.Char.CharacterComponent.PlayerCommonInterface",
})

BP_PhantomCharacter._components = {
    "BluePrints.Char.CharacterComponent.PickupComponent",
    "BluePrints.Char.CharacterComponent.CharacterPickupUseComponent",
    "BluePrints.Char.CharacterComponent.TeamRecoveryComponent",
}

-- function BP_PhantomCharacter:ReceiveBeginPlay()
--     self.Super.ReceiveBeginPlay(self)
-- end

function BP_PhantomCharacter:Initialize(Initializer)
    BP_PhantomCharacter.Super.Initialize(self)
    self:InitActionLogicParamas()
end

function BP_PhantomCharacter:ClientInitInfoNew(Context)
    self:InitUIWidgetComponent()
    if self.PhantomOwner and self.PhantomOwner:IsMainPlayer() then
        self:AddInteractiveTrigger()
        self.InteractiveTriggerComponent.SpecInteractiveComps:Add(UPickUpInteractiveComponent:StaticClass())
    end

    if self.BP_RecoverInteractiveComponent then
        self.BP_RecoverInteractiveComponent:InitCharInfo()
    end
end

function BP_PhantomCharacter:ClientInitInfo(Info)
    BP_PhantomCharacter.Super.ClientInitInfo(self, Info)
    self:InitUIWidgetComponent()
    if self.PhantomOwner and self.PhantomOwner:IsMainPlayer() then
        self:AddInteractiveTrigger()
        self.InteractiveTriggerComponent.SpecInteractiveComps:Add(UPickUpInteractiveComponent:StaticClass())
    end

    if self.BP_RecoverInteractiveComponent then 
        self.BP_RecoverInteractiveComponent:InitCharInfo()
    end
end

-- function BP_PhantomCharacter:ReceiveTick(DeltaSeconds)
--     if not self.InitSuccess then
--         return
--     end
--     -- BP_PhantomCharacter.Super.ReceiveTick(self, DeltaSeconds)
--     -- CallOverridden(self, DeltaSeconds)
--     -- self:StopDodgeWhenTimeOver()
--     -- self:ProcessJumpActionInTick(DeltaSeconds)
--     self:TriggerGuideChangeVisibility()
-- end

-- function BP_PhantomCharacter:GetObjType()
--     return EObjType.PhantomCharacter
-- end

function BP_PhantomCharacter:ReceiveEndPlay(EndPlayReason)
    local Avatar = GWorld:GetAvatar()
    if Avatar and EndPlayReason ~= EEndPlayReason.LevelTransition then
        Avatar:ClearCreatePhantomInfo(self.UnitId)
    end
    self.Overridden.ReceiveEndPlay(self, EndPlayReason)
end

function BP_PhantomCharacter:CheckCanPart()
    return true
end

-- function BP_PhantomCharacter:ServerDoJump(_JumpStage)
--     if (not IsAuthority(self)) then 
--         return  false
--     end
--     if not self:CheckJumpKeyValide()then
--         return false
--     end
--     if self.ClimbMont then 
--         return  false
--     end
--     local TempJumpInfo = EffectResults.Result()
    
--     local JumpStage = _JumpStage

--     if not JumpStage or JumpStage == 0 then 
--         JumpStage = self:CheckJumpStage(TempJumpInfo)
--     end

--     -- if JumpStage == Const.BulletJump then 
--     --     JumpStage = nil 
--     -- end
--     JumpStage = self:CheckBuffForbidenJump(JumpStage)
--     if JumpStage == nil then
--         return false
--     end
--     if JumpStage == Const.BulletJump then
--         if self:CheckSkillInActive(ESkillName.BulletJump) then
--             return false
--         end
--         local CurrentJumpState = self.PlayerAnimInstance.CurrentJumpState
--         local IsMoveOnGround = not self.IsInAir
--         local EnterBulletJumpStage = self:CheckBulletJumpCondition(CurrentJumpState, IsMoveOnGround)
--         if not EnterBulletJumpStage then
--             return false
--         end
--     end
--     local JumpResult = TempJumpInfo:ToEffectStruct()
--     self:ClientJump(JumpStage, JumpResult)
--     return true
-- end

function BP_PhantomCharacter:CheckJumpStage()
    local CurrentJumpState = self.PlayerAnimInstance.CurrentJumpState
    local IsMoveOnGround = not self.IsInAir
    local EnterFirstJumpStage = self:CheckFirstJumpCondition(CurrentJumpState, IsMoveOnGround)
    if EnterFirstJumpStage then
        return Const.FirstJump
    end
    local EnterSecondJumpStage = self:CheckSecondJumpCondition(CurrentJumpState, IsMoveOnGround)
    if EnterSecondJumpStage then
        return Const.SecondJump
    end
    return nil
end

function BP_PhantomCharacter:OnJumpStageChaned(JumpStage)
    if JumpStage == Const.BulletJump then 
        self.BulletJumpCount = self.BulletJumpCount + 1
        self:RealStopSlide(false)
    end
    if self:CharacterInTag("Avoid") then 
        self:StopDodge()
    end

    if self.SlideTime ~= -1 then 
        self.SlideTime = -1 
    end
    self:SetCrouch(false)
    self:SetHoldCrouch(false)
end

-- function BP_PhantomCharacter:AfterTagChanged(OldTag, NewTag)
--     if self.BuffEnableFlight then 
--         -- 如果有飞行状态，则需要再设置一下，防止其他逻辑把飞行状态关闭了
--         -- 比如受击相关，以及LaunchCharacter
--         self:SetFlyMode(true)
--     end
-- end

-- function BP_PhantomCharacter:PhantomDodge()
--     if self:CheckSkillInActive(UE4.ESkillName.Avoid) then
--         return false
--     end
--     if not self:CheckCanAvoid()then
--         return false
--     end
--     if self:ReachMaxAvoidTimes() then
--         return false
--     end
--     self:DoDodge()
--     return true
-- end

function BP_PhantomCharacter:CommonRecoveryImpl()
    self.Super.CommonRecoveryImpl(self)
    if self.PhantomOwner then 
        Battle(self):TriggerBattleEvent(BattleEventName.OnPhantomRecover, self.PhantomOwner, self)
    end
end

function BP_PhantomCharacter:Recovery(...)
    BP_PhantomCharacter.Super.Recovery(self, ...)
    self:AddGravityModifier(UE4.EGravityModifierTag.PhantomDead, 1)
    if IsAuthority(self) then
        self:UseSkill(Const.PlayerRecoverySkill, 0)
    end

    -- 人质濒死ui相关处理
    if self.IsHostage then
        -- todo 该先通知到GameMode，GameMode再RemoveDungeonEvent，逻辑更舒服些
        if IsAuthority(self) then
            local GameMode = UGameplayStatics.GetGameMode(self)
            if GameMode then
                GameMode:RemoveDungeonEvent("HostageDyingCountDown")
            end
        end
    end
end

-- function BP_PhantomCharacter:RealOnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
--     DebugPrint("Tianyi@ BP_PhantomCharacter:OnDead")
--     local CreatorName = self.PhantomOwner and self.PhantomOwner:GetName() or ""
--     local CreatorEid = self.PhantomOwner and self.PhantomOwner.Eid or 0
--     Battle(self):RecordBattleEvent_Lua("召唤者Eid为:"..CreatorEid.."，召唤者名字为:"..CreatorName.."，Eid为:"..self.Eid.."，名字为"..self:GetName().."的魅影死亡了，它的UnitId为:"..self.UnitId, "Phantom", 0)
--     -- 魅影并不希望走怪的Ondead，所以直接调CharacterBase的OnDead
--     BP_PhantomCharacter.Super.Super.RealOnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
--     DebugPrint("Tianyi@ Player Die!!!!!!!!!!")
--     self:PlayHitMontage("Die")
--     self:ResetCapSize()
--     self:TryEnterDying()
--     self:StopFire(false, false)
--     self:ShouldEnableHandIk()

--     if not IsDedicatedServer(self) then
--         if (self.BillboardComponent ~= nil) then
--             self.BillboardComponent:CharOnDead()
--         end
--     end
-- end

function BP_PhantomCharacter:OnRealEnterDying()
    self.Super.OnRealEnterDying(self)
    DebugPrint("LHQPhantomState OnRealEnterDying")

    if IsAuthority(self) and not self.IsHostage then 
        local GameMode = UGameplayStatics.GetGameMode(self)  
        if self:CheckCanRecovery() then
            -- 魅影触发自救
            local RespawnRule = GameMode:GetRespawnRule(self)
            if RespawnRule and RespawnRule.PhantomRecoverSpeed then 
                Battle(self):RecoverOther(self.Eid, self.Eid, true, {Speed = RespawnRule.PhantomRecoverSpeed}, UE4.ERecoverReason.RecoverReason_SelfRecover)
            end
        end
    end

    if self.IsHostage then
        local TeamRecoveryComp = self:GetOrAddTeamRecoveryComp()
        if TeamRecoveryComp then
            TeamRecoveryComp.HaveDyingCountDown = true
        end
    end
end

-- 离开濒死状态，进入真正死亡阶段
function BP_PhantomCharacter:OnRealDie()
    DebugPrint("Tianyi@ Phantom real die, Eid = " .. self.Eid)
        local RespawnRuleName = self:GetCurRespawnRuleName()
        if RespawnRuleName and DataMgr.RespawnRule[RespawnRuleName] then 
            local RespawnRule = DataMgr.RespawnRule[RespawnRuleName]
            if RespawnRule.DissolveAfterDead == true then 
                local DiscardPlayRate = 1
                self:PhantomDiscard(DiscardPlayRate, 0, false)
                if IsAuthority(self) then 
                    self:AddTimer_Combat(0.4/DiscardPlayRate, function() self:EMActorDestroy(EDestroyReason.PhantomDieInRegion) end, false, 0, "DestroyPhantomTimer", false)
                end
            end
        end

        if IsAuthority(self) then 
            if self.IsHostage then -- 如果是人质死亡，通知一下GameMode
                local GameMode = UGameplayStatics.GetGameMode(self)      
                if GameMode then    
                    GameMode:TriggerDungeonComponentFun("OnHostageDie", self)
                end
            end
        end

        -- -- 服务端初始化复活次数
	    -- local Avatar = GWorld:GetAvatar()
        -- -- 魅影在区域中死亡后直接销毁
	    -- if Avatar and Avatar:IsRealInBigWorld() and not Avatar:IsInHardBoss() then 
        --     local DiscardPlayRate = 1
        --     self:PhantomDiscard(DiscardPlayRate, 0, false)
        --     if IsAuthority(self) then 
        --         self:AddTimer_Combat(0.4/DiscardPlayRate, function() self:EMActorDestroy(EDestroyReason.PhantomDieInRegion) end, false, 0, "DestroyPhantomTimer", false)
        --     end
        -- else 
        --     if IsAuthority(self) then 
        --         if self.IsHostage then -- 如果是人质死亡，通知一下GameMode
        --             local GameMode = UGameplayStatics.GetGameMode(self)      
        --             if GameMode then    
        --                 GameMode:TriggerDungeonComponentFun("OnHostageDie", self)
        --             end
        --         end
        --     end
        -- end
end

--魅影掉落
function BP_PhantomCharacter:TriggerFallingCallable()
    DebugPrint("OtherActor is Falling Dead. ActorName: ", self:GetName(), ", UnitId: ", self.UnitId, ", Eid: ", self.Eid, ", CreatorId: ", self.CreatorId, " CreatorType: ", self.CreatorType, ", BornPos: ", self.BornPos)
    local Player = self.PhantomOwner
	UNavigationFunctionLibrary.ActorToActorTeleport(self, Player)
	self:EnableCheckOverlapPush({})
	if self.OnTriggerFallingCallable then
		self:OnTriggerFallingCallable()
	end
	self:Landed()
end

--魅影落水
function BP_PhantomCharacter:TriggerWaterFallingCallable()
    self:TriggerFallingCallable()
end

-- function BP_PhantomCharacter:TriggerGuideChangeVisibility()
--     if self.IsFireDistanceEvent == nil then
--         return
--     end
--     local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--     local PlayerLocation = Player:K2_GetActorLocation()
--     local Distance = UE4.UKismetMathLibrary.Vector_Distance(self:K2_GetActorLocation(), PlayerLocation)
--     local ChangeDistance = 100
--     if Distance < ChangeDistance and not self.IsFireDistanceEvent then
--         self.IsFireDistanceEvent = true
--         EventManager:FireEvent(EventID.TriggerHostageVisibility, false)
--     elseif Distance >= ChangeDistance and self.IsFireDistanceEvent then
--         self.IsFireDistanceEvent = false
--         EventManager:FireEvent(EventID.TriggerHostageVisibility, true)

--     end

-- end

function BP_PhantomCharacter:ActiveHostageGuide(OpType, HostageEid)
    -- 激活指引
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local SceneMgrComponent = GameInstance:GetSceneManager()
    self.StartFireDistanceEvent = true
    self.IsHostageChar = true
    if (IsValid(SceneMgrComponent) and self.Data and self.Data.GuideIconAni) then
        SceneMgrComponent:UpdateSceneGuideIcon(HostageEid, self, nil, OpType, true, self.Data)
    end
end

function BP_PhantomCharacter:DeactiveHostageGuide()
    -- 关闭指引
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local SceneMgrComponent = GameInstance:GetSceneManager()
    if (IsValid(SceneMgrComponent) and self.Data and self.Data.GuideIconAni) then
        SceneMgrComponent:UpdateSceneGuideIcon(self.Eid, self, nil, "Delete", true, self.Data)
    end
end

-- function BP_PhantomCharacter:CheckCanRecovery()
--     local Avatar = GWorld:GetAvatar()

--     -- 魅影在区域中死亡后直接销毁
--     if Avatar and Avatar:IsRealInBigWorld() then 
--         return false  
--     end

--     return true
-- end

function BP_PhantomCharacter:PhantomBulletJump(Forward)
    self.BulletForward = FVector(Forward.X, Forward.Y, Forward.Z)
    return self:ServerDoJump(Const.BulletJump)
end

function BP_PhantomCharacter:GetBulletJumpForwardVector()
    if not self.BulletForward then 
        return self:GetActorForwardVector(), self:GetActorRightVector(), self:K2_GetActorRotation()
    end

    local Rotation = self.BulletForward:ToRotator()
    local RightVector = UE4.UKismetMathLibrary.GetRightVector(Rotation)
    return self.BulletForward, RightVector, Rotation
end

function BP_PhantomCharacter:OnEMActorDestroy_Lua(DestroyReason)
    if (IsClient(self) and not GameState(self):GetPhantomState(self.Eid)) or IsStandAlone(self) then
        EventManager:FireEvent(EventID.CloseTeammateBloodUI, self.Eid, self.TeammateUI)
        self.TeammateUI = nil
    end
    self.Super.OnEMActorDestroy_Lua(self,DestroyReason)
end

function BP_PhantomCharacter:OnCharacterReady_Lua()
    if self.RangedWeapon == nil then
        return
    end

    local RangedWeaponId = self.RangedWeapon.WeaponId
    local WeaponData = DataMgr.BattleWeapon[RangedWeaponId]
    if WeaponData and WeaponData.IsForceEnablePhysics then
        if UE4.UCharacterFunctionLibrary.SetMonsterPhysicsForceEnable(self:GetWorld(), true) then
            DebugPrint("@gulinan BP_PhantomCharacter::OnCharacterReady_Lua try Enable physics, WeaponId: ", RangedWeaponId)
        end
    else
        if UE4.UCharacterFunctionLibrary.SetMonsterPhysicsForceEnable(self:GetWorld(), false) then
            DebugPrint("@gulinan BP_PhantomCharacter::OnCharacterReady_Lua try Disable physics, WeaponId: ", RangedWeaponId)
        end
    end
end

function BP_PhantomCharacter:UpdatePhantomRegionData()
    local GameMode = UGameplayStatics.GetGameMode(self)
    if GameMode then
        local RegionDataMgr = GameMode:GetRegionDataMgrSubSystem()
        RegionDataMgr:UpdatePhantomRegionData(self)
    end
end

AssembleComponents(BP_PhantomCharacter, {"CheckJumpStage","OnJumpStageChaned","GetBulletJumpForwardVector"})
return BP_PhantomCharacter
