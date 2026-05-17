require "Utils"
local msgpack = require "msgpack_core"
local MiscUtils = require "Utils.MiscUtils"
local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
local ActionLogicComponent = {}

 -- n = 0
function ActionLogicComponent:InitActionLogicParamas()
    self.AvoidTime = -1
    self.SlideCount = 0
    self.AvoidCount = 0
    self.SlidePrepareInfo = {}
    self.AvoidPrepareInfo = {}
    -- self.EnablePushEnemy = TArray("")
    -- self.PushFactor = 0
    self.AvoidRemainTimes = 1
end

function ActionLogicComponent:SetupActionLogicPramas()
    self.bUseControllerRotationYaw = false
    self.JumpMaxCount = 3
    local r = DataMgr.PlayerRotationRates["BulletJump"]
    if r then
        self.BulletRotationSpeed = r.ParamentValue[2]
    else
        self.BulletRotationSpeed = self.PlayerRotationRates:Find("BulletJump").Yaw
    end
    self:InitCapsuleSize()
    if self:IsPlayer() then 
        self:SetActionFeatureAttr(self.SlideMaintainTime, self.SlideLaunchDelay)
    end
    self.SlidePrepareInfo = {}
    self.AvoidPrepareInfo = {}
    self.OriginBrakFrictionWalk = self:GetMovementComponent().BrakingDecelerationWalking
    self:SetRotationRate("OnGround")
    --self.EnablePushEnemy = TArray("")
    -- self.PushFactor = 0
    self:SetHoldCrouch(false)
    self.ShrinkType = { Tag = 'Defaulted', Reverse = false }

    local Movement = self:GetMovementComponent()
    local _AirControl = DataMgr.PlayerRotationRates["FlyAirControl"]
    if _AirControl  then
        Movement.FlyAirControl = _AirControl.ParamentValue[1]
    end
    local _AirControlMulti = DataMgr.PlayerRotationRates["AirControlMultiplier"]
    if _AirControlMulti then 
        Movement.FlyAirControlBoostMultiplier = _AirControlMulti.ParamentValue[1]
    end
    local MaxAvoidExecuteTimes = self:GetAttr("MaxAvoidExecuteTimes")
    if MaxAvoidExecuteTimes then
        self.AvoidRemainTimes = math.max(1, MaxAvoidExecuteTimes)
    end
end


function ActionLogicComponent:GetConstHalfHeight(InShrinkType)
    if (InShrinkType == "Defaulted") then 
        return self.OriginHalfHeight
    end
    return Const[InShrinkType .. 'HalfHeight']
end

function ActionLogicComponent:GetInteractiveWaitToEnd()
    return Const.InteractiveWaitToEnd 
end

function ActionLogicComponent:ResetGravity(Now)
    if self:ClearBulletGravityInfo(Now) then
        self.BulletJumpDirectionInfo = nil
        self.bBulletJumpControlGravity = false
    end
end

function ActionLogicComponent:CounterJump(JumpStage)
    if JumpStage == Const.BulletJump then 
        self:CountPlayerSkillUsedTimes("BulletJump")
    elseif JumpStage == Const.FirstJump or JumpStage == Const.SecondJump then 
        self:CountPlayerSkillUsedTimes("Jump")
    end
end

function ActionLogicComponent:NotifyBulletToUI()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    ---@type BP_UIManagerComponent_C
    local UIManager = GameInstance:GetGameUIManager()
    local DungeonCapture = UIManager:GetUIObj("DungeonCaptureFloat")
    if DungeonCapture then
        DungeonCapture:NotifyBulletJump()
    end
    if (self.NeedBulletJumpEvent) then
        EventManager:FireEvent(EventID.OnBulletJumpStarted)
    end
end


function ActionLogicComponent:BulletJumpRecoverCheck_Lua()
    self.AutoSyncProp.IsBulletJumping = false
    self.ForbidOrient = false
    self:ChangeOrientControll()
    -- self:StartRecoverPitch()
end

function ActionLogicComponent:SetEnterInteractive(InInteractive, MontageName, CharacterTag, SubFile)
    self.IsInteractive = InInteractive
    if self.PlayerAnimInstance then 
        self.PlayerAnimInstance.IsInteractive = InInteractive
        self.PlayerAnimInstance:ResetIdleTag()
    end
    if InInteractive and MontageName then
        -- self:SetCharacterTag(CharacterTag)
        local Callback = { OnCompleted = self.OnExitInteractive,
                           OnInterrupted = self.OnExitInteractive,
                           OnBlendOut = self.OnExitInteractive }

        if not SubFile then
            SubFile = "MechInteractive"
        end
        self:PlayActionMontage("Interactive/"..SubFile, MontageName, Callback, false, true)
        self.InteractiveMont = self.MontToPlay
    end
    if (self.NeedInteractiveEvent) then
        EventManager:FireEvent(EventID.OnInteractivePressed)
    end
end

function ActionLogicComponent:OnExitInteractive()
    if self:IsPlayer() then
        self:MinusForbidTag("Battle")
    end
    self.InteractiveMont = nil
    self.IsInteractive = false
    self.WaitCallBack = false
    if self.PlayerAnimInstance then 
        self.PlayerAnimInstance.IsInteractive = false
    end
    if self.OnInteractiveDelegate:IsBound() then
        self.OnInteractiveDelegate:Broadcast(self)
    end
    self:GetMovementComponent().RootMotionZScale = 1
    if self:CharacterInTag("Interactive") or self:CharacterInTag("Seating") then
        self:ServerSetCharacterTag("Idle")
        self:SetCharacterTagIdle()
    end
end

function ActionLogicComponent:PlayArmoryAction(ActionId, bHideUntilLoop)
	DebugPrint("gmy@ActionLogicComponent:PlayArmoryAction ActionId", ActionId)
	if ActionId == 0 then return end
	
	local ActionName = Const.ArmoryActionIdToArmoryTag[ActionId]
	if ActionName then
		if self.CurrentSkillId ~= 0 then
			self:StopSkill(UE.ESkillStopReason.ArmoryCancel)
		end
		self:SetArmoryTag(ActionName, nil, bHideUntilLoop)
	end
end

function ActionLogicComponent:IsArmoryIdleTag(IdleTag)
    --DebugPrint("gmy@ActionLogicComponent ActionLogicComponent:IsArmoryIdleTag", IdleTag, self.PlayerAnimInstance:IsArmoryIdleTag(IdleTag))
    if self.PlayerAnimInstance then
        return self.PlayerAnimInstance:IsArmoryIdleTag(IdleTag)
    end
    
    return false
end

function ActionLogicComponent:CanUseArmoryAction(ActionId)
    DebugPrint("gmy@ActionLogicComponent ActionLogicComponent:CanUseArmoryAction", ActionId)
    if ActionId == 0 then return end
    
    local ActionName = Const.ArmoryActionIdToArmoryTag[ActionId]
    if ActionName == Const.Melee then
        DebugPrint("gmy@ActionLogicComponent ActionLogicComponent:CanUseArmoryAction", self.MeleeWeapon)
        local MeleeWeapon = self.MeleeWeapon
        if not IsValid(MeleeWeapon) then
            return false
        end
    elseif ActionName == Const.Ranged then
        DebugPrint("gmy@ActionLogicComponent ActionLogicComponent:CanUseArmoryAction", self.RangedWeapon)
        local RangedWeapon = self.RangedWeapon
        if not IsValid(RangedWeapon) then
            return false
        end
    end
    
    return true
end
function ActionLogicComponent:EmptyCurResourceId()
    self.CurResourceId = 0
    if (self.FromOtherWorld) then 
        self.PlayerAnimInstance:SetEmoIdleEnabled(true, true)
    end
end
function ActionLogicComponent:PlayResourceAction(ActionName, bHideUntilLoop)
    -- local Callback = { OnCompleted = self.EmptyCurResourceId}
    -- -- if (self.FromOtherWorld) then 
    -- --     if(self:GetCharacterTag() == "None")then 
    -- --         self:SetCharacterTagIdle()
    -- --     end
    -- --     self.PlayerAnimInstance:SetEmoIdleEnabled(false)
    -- -- end
    -- print(_G.LogTag, "PlayResourceAction", ActionName)
    local Callback = {}
    self:PlayActionMontage("Interactive/Gesture", ActionName.."_Montage", Callback,false, nil, nil, bHideUntilLoop)
end

function ActionLogicComponent:PlayActionMontage(SubFile, MontageSuffix, 
                                                Callback, ShouldForbidAction, 
                                                ExcuteFnishOnlyWhenCompelete,bLoadAsync,
                                                bHideUntilLoop)
    if ShouldForbidAction then 
        self:AddForbidTag("Battle")
    end
    if self.CurrentSkillId ~= 0 then 
        self:StopSkill(UE.ESkillStopReason.ActionCancel)
    end
    local MontPath = self:GetMontagePath(SubFile, MontageSuffix)
    print(_G.LogTag, "PlayActionMontage", MontPath)
    if bLoadAsync then
        UResourceLibrary.LoadObjectAsync(self,MontPath,{self,function (_,Montage)
            self.MontToPlay = Montage
            if Montage then DebugPrint("ActionLogicComponent:PlayActionMontage",self:GetName(),Montage:GetName()) end
            local MontParam = 
            {
                OnCompleted = Callback["OnCompleted"],
                OnBlendOut = Callback["OnBlendOut"],
                OnInterrupted = Callback["OnInterrupted"],
                OnNotifyBegin = Callback["OnNotifyBegin"],
                OnNotifyEnd = Callback["OnNotifyEnd"],
                ExcuteFnishOnlyWhenCompelete = ExcuteFnishOnlyWhenCompelete,
            }
            self:SetCanExtractZVelocity()
            MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh,  self.MontToPlay, MontParam)

            if bHideUntilLoop and self.MontToPlay then
                self:HideActorBeforeLoop(self.MontToPlay)
            end
        end})
        return nil
    end
    self.MontToPlay = LoadObject(MontPath)
    local MontParam = 
    {
        OnCompleted = Callback["OnCompleted"],
        OnBlendOut = Callback["OnBlendOut"],
        OnInterrupted = Callback["OnInterrupted"],
        OnNotifyBegin = Callback["OnNotifyBegin"],
        OnNotifyEnd = Callback["OnNotifyEnd"],
        ExcuteFnishOnlyWhenCompelete = ExcuteFnishOnlyWhenCompelete,
    }
    self:SetCanExtractZVelocity()
    MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh,  self.MontToPlay, MontParam)
    if bHideUntilLoop and self.MontToPlay then
        self:HideActorBeforeLoop(self.MontToPlay)
    end
end

function ActionLogicComponent:HideActorBeforeLoop(Montage)
    if Montage then
        local StartTime = self:GetMontageSectionStartTime(Montage, "Loop")

        if StartTime > 0 then
            -- TODO@lxz: 在这里设置对应召唤机关的交互状态
            self:SetActorHideTag("GestureMontage", true, false, true)
            self:AddTimer(StartTime, function()
                self:SetActorHideTag("GestureMontage", false, false, true)
            end)
        end
    end
end


-- function ActionLogicComponent:GetMontagePath(SubFile, MontageSuffix)
--     local ModelId = self:GetCharModelComponent():GetCurrentModelId()
--     local ModelData = DataMgr.Model[ModelId]
--     local PlayerAnimPath = ModelData.MontageFolder or ""
--     local Prefix = ModelData.MontagePrefix or ""
--     if not Prefix then return end
--     local _SubFile = SubFile.."/"
--     if not SubFile or SubFile == "" then
--         _SubFile = ""
--     end

--     local MontPath = "AnimMontage\'"..PlayerAnimPath.._SubFile..Prefix..MontageSuffix.."."..Prefix..MontageSuffix.."\'"
--     return MontPath
-- end

function ActionLogicComponent:GetCapsuleRootLocation()
    return self.Mesh:GetSocketLocation("Root")
end

function ActionLogicComponent:IsAnimCrouch()
    if not self.PlayerAnimInstance then
        return false
    end
    return self.PlayerAnimInstance.IsCrouching
end


--改这里的时候记得改下UPushMonsterCapsuleComponent，松露的猪也算玩家推怪
-- function ActionLogicComponent:ComputeSlipVector(Delta, Time, Hit, IsForce)
--     if Delta == Const.ZeroVector then
--         return Const.ZeroVector
--     end
--     if IsForce == false and self:IsPushEnemyEmpty() then
--         return Const.ZeroVector
--     end
--     if not Hit.Actor then
--         return Const.ZeroVector
--     end
--     if not UE4.UKismetMathLibrary.ClassIsChildOf(Hit.Actor:GetClass(), AMonsterCharacter:StaticClass()) then
--         return Const.ZeroVector
--     end
--     if Hit.Actor:IsMonster() and DataMgr.BattleMonster[Hit.Actor.Data.BattleRoleId].CannotBePushed == 1 then
--         return Const.ZeroVector
--     end
--     if Hit.Actor:IsRealMonster() and Hit.Actor:CharacterInTag("WaitForCaught") then
--         return Const.ZeroVector
--     end
--     if(Hit.Actor:IsNPC()) then
--         return Const.ZeroVector
--     end
--     if not self:IsEnemy(Hit.Actor) then
--         return Const.ZeroVector
--     end
--     -- UE4.UKismetSystemLibrary.DrawDebugLine(self, self:K2_GetActorLocation(), self:K2_GetActorLocation()+self:GetVelocity(), FLinearColor(0,0,255), 10, 3)
--     --     
--     local Target = Hit.Actor
--     -- local a = Hit.ImpactPoint
--     local HitNormal = Hit.ImpactNormal
--     HitNormal:Normalize()
--     local HitNormalVelocity = HitNormal * HitNormal:Dot(Delta)

--     local PushFactor = self.PushFactor
--     if(IsForce) then PushFactor = 1 end

--     local LoseHitNormalV = (Delta - HitNormalVelocity) * Time
--     if self:GetAttr("CollisionLevel") < Target:GetAttr("CollisionLevel") then
--         print('@@@@@@@@@@@@@@@@@@@@@@@@@')
--         local BounceSourceVelocity = Target:GetVelocity() * UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
--         HitNormalVelocity = HitNormal * HitNormal:Dot(BounceSourceVelocity)
--     end
--     LoseHitNormalV = (LoseHitNormalV + HitNormalVelocity * PushFactor * Time)
--     HitNormalVelocity.Z = 0
--     local SelfVelocity = FVector(Delta.X, Delta.Y, Delta.Z)
--     SelfVelocity:Normalize()
--     local VelocityRight = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(SelfVelocity, FRotator(0, 90, 0)) 

--     local MultiFactor = 1
--     if VelocityRight:Dot(-HitNormal) < 0 then 
--         MultiFactor = -1
--     end 
--     -- print('2222222222222222222222222222222222222222zjy', Time, HitNormalVelocity:Size(),SelfVelocity:Dot(-HitNormal))
--     if SelfVelocity:Dot(-HitNormal) > 0.86 then
--         HitNormalVelocity = HitNormalVelocity + VelocityRight * UE4.UGameplayStatics.GetWorldDeltaSeconds(self)  * Const.TransplantSize * MultiFactor
--     end
--     -- print('333333333333333333333333333333333333333zjy', Time, HitNormalVelocity:Size())

--     local SelfToTargetForward = Target:K2_GetActorLocation() - self:K2_GetActorLocation()
--     if(SelfToTargetForward:Dot(HitNormalVelocity) < 0) then return LoseHitNormalV end

--     if _G.DrawDebugTest then
--         UE4.UKismetSystemLibrary.DrawDebugLine(self, self:K2_GetActorLocation(), self:K2_GetActorLocation() + LoseHitNormalV * 1000, FLinearColor(10, 111, 0), 3, 3)
--         UE4.UKismetSystemLibrary.DrawDebugLine(self, self:K2_GetActorLocation(), self:K2_GetActorLocation() + Delta * 1000, FLinearColor(0, 0, 111), 3, 3)
--         UE4.UKismetSystemLibrary.DrawDebugLine(self, self:K2_GetActorLocation(), self:K2_GetActorLocation() + HitNormalVelocity*1000, FLinearColor(1, 0, 0), 3, 3)
--     end
--     -- print('222222222222222222222222222222222222222222222222222222222222',LoseHitNormalV, LoseHitNormalV:Size())
--     -- print('333333333333333333333333333333333333333333333333333333333333',self:GetVelocity():Size())
--     Target:ApplyPush(HitNormalVelocity, PushFactor, UE4.UGameplayStatics.GetWorldDeltaSeconds(self))
--     return LoseHitNormalV --FVector(0,0,0)

-- end

-- PlayerCharacter Action Command
function ActionLogicComponent:PlayerLanded()
    -- if self.AutoSyncProp.IsBulletJumping then
    --     self:OnPlayerCapHit()
    --     return false
    -- end
    print(_G.LogTag, "PlayerLanded", self:GetCharacterTag())
    if not self:CharacterInTag("Slide") then
        -- self:ResetJumpState_Cpp(true)
        self:ResetCapSize()
        self:SetRotationRate("OnGround")
    end
    
    self.PlayerAnimInstance.WallJumpIndex = 0
    return true
end

function ActionLogicComponent:PlayerImpending()
    if self.AutoSyncProp.IsBulletJumping then
        return false
    end
    if self:IsFlying() then
        return false
    end

    if self.ImpendingSetted then
        return
    end
    -- print(_G.LogTag, "PlayerImpending", self:GetCharacterTag())
    if not self:CharacterInTag("Slide") then 
        -- self:ResetCapSize()
        self:SetRotationRate("InAir")
    end
    self.PlayerAnimInstance.WallJumpIndex = 0
    -- self:SetCrouch(false)
    return true
end

function ActionLogicComponent:PlayTeleportAction(...)
    local MontageSuffix
    if(self.InfoForInit and self.InfoForInit.AppearanceSuit)then
        local AccessorySuit = self.InfoForInit.AppearanceSuit.AccessorySuit or {}
        if(AccessorySuit[CommonConst.NewCharAccessoryTypes.FX_Teleport])then
            local Data = DataMgr.CharAccessory[AccessorySuit[CommonConst.NewCharAccessoryTypes.FX_Teleport]]
            if(Data)then
                MontageSuffix = Data.Montage
            end
        end
    end
    MontageSuffix = MontageSuffix or "Teleport_01_Montage"
    local MontagePath = self:GetMontagePath("Interactive/MechInteractive", MontageSuffix)
    local Montage = LoadObject(MontagePath)
    if not Montage then
        MontageSuffix = "Teleport_01_Montage"
    end
    self:PlayActionMontage("Interactive/MechInteractive", MontageSuffix,...)
end

return ActionLogicComponent
--deprecated code ---
-- function ActionLogicComponent:ProcessClimbActionInTick(DeltaSeconds)
--     if not self.ClimbMont then 
--         return  
--     end
--     if not self.PlayerAnimInstance then 
--         return 
--     end
--     if not self.PlayerAnimInstance:Montage_IsPlaying(self.ClimbMont) then 
--         return  
--     end
--     if (self.CurrentLocation - self.StartClimbPos):Size2D() <= self.CapsuleComponent:GetUnscaledCapsuleRadius() then 
--         return 
--     end
--     if self:ShouldStopClimbMontage() then 
--         self.PlayerAnimInstance:Montage_Stop(Const.MontageBlendOutTime, self.ClimbMont)
--     end

-- end