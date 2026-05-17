--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"
-- Const = require("Const")
local FootIKValues = require("BluePrints.Char.CharacterComponent.AnimStruct")

local HighLevelKawaiiState = {
    Shooting = 1,
    ShootHold = 1,
    Reload = 1
}

local IdleTagToZero = {
	EmoIdle = 1,
	Gesture01_Idle = 1
}
local BP_NpcAnimInstance_C = Class()

function BP_NpcAnimInstance_C:LuaAnimBeginPlay()
	-- self.Begining = true
	-- self.Overridden.BlueprintBeginPlay(self)
	-- self.Velocity = UE4.FVector()
	-- self.ControlRot = UE4.FRotator()
	-- self.Pawn = self:TryGetPawnOwner()
	-- self.RotationYaw = 0
	-- self.SpeedArray = {0}
	-- self.InBoneHit = false
	-- if  (IsStandAlone(self.Pawn) or MiscUtils.IsAutonomousProxy(self.Pawn)) and not UIManager(self.Pawn):GetArmoryUIObj() then 
	-- 	self.bEnableKawaiiSetting = true
	-- else
	-- 	self.bEnableKawaiiSetting = false
	-- end
	-- self.LastUpdateSpeedTime = UE4.UGameplayStatics.GetTimeSeconds(self)
	-- self.OnMontageEnded:Add(self, self.OnAnimationEnded)
	-- self.LastYaw = self.Pawn:K2_GetActorRotation().Yaw
	-- self.EnableAim = 0
	-- self.HitedState:Add("HeavyHit")
	-- self.HitedState:Add("HitFly")
	-- self.HitedState:Add("HitFlyDown")
	-- self.HitedState:Add("HitRepel")
	-- self.FootIKValues = New(FootIKValues)
	-- self.MaxAccleration = self.Pawn:GetMovementComponent().MaxAcceleration
	-- self.FootOffsetRTarget = FVector()
	-- self.FootOffsetLTarget = FVector()
	-- self.CharacterTag = "Idle"
	-- self.IdleTag = "0"
	-- self.EnableIK = false
	-- if self.Pawn and self.Pawn.CurrentRoleId ~= 2101 and self.Pawn.CurrentRoleId ~= 4201 then
	-- 	self.BlendSkirtLock = 0.8
	-- else
	-- 	self.BlendSkirtLock = 0
	-- end
	-- -- self.bRotateL = false
	-- -- self.bRotateR = false
	-- -- self.ShouldInAir = true
	-- if self.Pawn:IsPlayer() and MiscUtils.GetGameCofingSettings("bUseBlueprintMeshAndABP") then 
	-- 	self:UseBlueprintSettingAttr()
	-- end
	-- -- self.FullBody = true
	-- -- self.IsEmoIdleEnable = true
	-- -- --self.Pawn:EnableRootMotion(ESourceTags.Skill)
	-- self.IdleTagNotArmory:Add("0")
	-- self.IdleTagNotArmory:Add("SkillIdle")
	-- self.IdleTagNotArmory:Add("EmoIdle")
	-- self.IdleTagNotArmory:Add("Gesture01_Idle")
end

function BP_NpcAnimInstance_C:GetPawnOwner()
	if not self.Pawn then
		self.Pawn = self:TryGetPawnOwner()
	end

	return self.Pawn
end

function BP_NpcAnimInstance_C:OnLeaveGesture01_Idle(NewIdleTag)
	if self:IsAnymontagePlaying() then
		self:Montage_StopSlotByName(0, "Gesture")
	end
end

--OnEnterEmoIdle
function BP_NpcAnimInstance_C:OnEnterEmoIdle()
	-- if self.Pawn and self.Pawn.StopLookAt then 
	-- 	self.Pawn:StopLookAt()
	-- end
	if self.IdleTag=="EmoIdle" and self:CanPlayEmoIdleVoice() and not self:GetPawnOwner().bHidden then
		AudioManager(self):PlaySeById(self:GetPawnOwner(), 214, self:GetPawnOwner(), false, true, "", "EmoIdle")
		self.EmoIdleVoiceHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.RemoveEmoIdleVoiceHandle}, Const.EmoIdleVoiceCoolDown, false, 0)
	end
end

function BP_NpcAnimInstance_C:OnLeaveEmoIdle()
	if self.EmoIdleVoiceHandle then
		self:RemoveEmoIdleVoiceHandle()
		AudioManager(self):StopSound(self:GetPawnOwner(), "EmoIdle")
	end
end

function BP_NpcAnimInstance_C:CanPlayEmoIdleVoice()
	-- 非玩家不播放
	if not self:GetPawnOwner():IsPlayer() then
		return false
	end
	-- CD内不播放
	if self.EmoIdleVoiceHandle then
		return false
	end
	-- 在副本中直接播放
	local Avatar = GWorld:GetAvatar()
	if Avatar and Avatar:IsInDungeon() then
		return true
	end
	-- 在Battle Region播放
	if self:GetPawnOwner():IsRegionInBattle() then
		return true
	end
	return false
end

function BP_NpcAnimInstance_C:SetEmoIdleEnabled(IsEnable, IsChangeRefreshNow)
	if self.IsEmoIdleEnable == IsEnable then
		return
	end
	self.IsEmoIdleEnable = IsEnable

	if IsEnable then
		if IsChangeRefreshNow then
			self:ResetIdleTag()
			self:EnterEmojiIdle()
		else
			self:ResetIdleTag()
		end
	else
		self:RemoveIdleHandle()
		if IsChangeRefreshNow then
			self:ResetIdleTag()
		end
	end
end

function BP_NpcAnimInstance_C:EnterEmojiIdle()
	self:SetIdleTag("EmoIdle")
end

function BP_NpcAnimInstance_C:RemoveEmoIdleVoiceHandle()
	UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.EmoIdleVoiceHandle)
	self.EmoIdleVoiceHandle = nil
end

function BP_NpcAnimInstance_C:EnterArmoryIdle()
	self:RemoveIdleHandle()
	if self.IsEnterArmory == "None" then 
		self:ResetIdleTag()
		-- self:AnimNotify_IdleStart()
		return 
	end
	-- local ArmIdleTag = self:GetArmoryIdleTag()
end

function BP_NpcAnimInstance_C:SetArmoryIdleTag()
	if self.IsEnterArmory ~= "None" then 
		self:SetIdleTag(self:GetArmoryIdleTag())

		if self:GetPawnOwner() and (self:GetPawnOwner():IsPlayer() or self:GetPawnOwner():IsPhantom())then 
			-- self:GetPawnOwner():ShouldEnableHandIk()
			self.EnableHandIk = false
			self:GetPawnOwner():PlayShowIdleMontage(self.IdleTag)
		end
	end
end

function BP_NpcAnimInstance_C:GetArmoryIdleTag()
	local Pawn = self:TryGetPawnOwner(self:GetPawnOwner())
	if not Pawn then
		return "0"
	end
	if self.IsEnterArmory and Const.ArmoryIdleTags[self.IsEnterArmory] then
		return Const.ArmoryIdleTags[self.IsEnterArmory]
	end
	return Pawn:GetUsingWeaponType(self.IsEnterArmory)
end
function BP_NpcAnimInstance_C:OnAnimationEnded(Montage, Interrupted)
	--print("OnAnimationEnded", Montage, Interrupted)
end

function BP_NpcAnimInstance_C:RealMontage_RepPlay(MontagePath, InPlayRate, StartSectionName, ReturnValueType, InTimeToStartMontageAt, bStopAllMontages)
	local Pawn = self:TryGetPawnOwner(self:GetPawnOwner())
	if Pawn.PlayerAnimInstance then
		Pawn:SetCanExtractZVelocity()
		Pawn:ResetAllCancelTag()
		local AnimationAsset = LoadObject(MontagePath)
		if AnimationAsset and self:IsMontageAsset(AnimationAsset) then
			local Duration = self:Montage_Play(AnimationAsset, InPlayRate)
			if Duration > 0 then
				if StartSectionName ~= "None" then
					Pawn.PlayerAnimInstance:Montage_JumpToSection(StartSectionName, AnimationAsset)
				end
				return Duration
			else 
				return 0
			end
		else
			return 0
		end
	elseif Pawn.NpcAnimInstance then
		Pawn:SetCanExtractZVelocity()
		Pawn:ResetAllCancelTag()
		local AnimationAsset = LoadObject(MontagePath)
		if AnimationAsset and self:IsMontageAsset(AnimationAsset) then
			local Duration = self:Montage_Play(AnimationAsset, InPlayRate)
			if Duration > 0 then
				if StartSectionName ~= "None" then
					Pawn.NpcAnimInstance:Montage_JumpToSection(StartSectionName, AnimationAsset)
				end
				return Duration
			else 
				return 0
			end
		else
			return 0
		end
	end
	
end

function  BP_NpcAnimInstance_C:EndAnimationTrigger()
	-- body
	if self.CurrentAnimation then
		--print("Montage_Stop", self.CurrentAnimation)
		self:Montage_Stop(0.01, self.CurrentAnimation)
		self.CurrentAnimation = nil
	end
end

function BP_NpcAnimInstance_C:PlayEyeAnimation(Animation)
	if(not Animation) then return end
	DebugPrint("Eye animation:",Animation)
	self.EyeSequence=Animation
end

function BP_NpcAnimInstance_C:PlayMouthAnimation(Animation)
	if(not Animation) then return end
	DebugPrint("Mouth animation:",Animation)
	self.MouthSequence=Animation
end

function BP_NpcAnimInstance_C:SetNpcDefaultAnim(Animation)
	if(not Animation) then
		DebugPrint("ERROR: DefaultAnim Is Null", self:GetPawnOwner():GetName())
		return
	end
	DebugPrint("NpcDefaultAnim: ",Animation)
	self.NpcDefaultAnim=Animation
end

function BP_NpcAnimInstance_C:SetNpcDefaultAnimEnable(bEnable)
	self.EnableNpcDefaultAnim = bEnable
end

function BP_NpcAnimInstance_C:SwitchEnableTalkAction(bEnable)
	self.bEnableTalkAction = bEnable and true or false
end

function BP_NpcAnimInstance_C:SwitchEnableAnimInstanceIK(bEnable)
	DebugPrint("BP_NpcAnimInstance_C:SwitchEnableAnimInstanceIK", bEnable)
	self.bUseIK = bEnable and true or false
end

function BP_NpcAnimInstance_C:CheckParamentVaild(KawaiiInfo, CurrentState)
	if not KawaiiInfo then 
		return false
	end
	if not KawaiiInfo.KawaiiParament then 
		return false
	end
	if not KawaiiInfo.KawaiiParament[CurrentState] then
		return false
	end
	return true
end

function BP_NpcAnimInstance_C:TryCallLuaOverriden(NotifyName, MeshComponent, Sequence)
	local LuaFuncName = "Lua_" .. NotifyName
	local LuaFunc = self[LuaFuncName]
	if not LuaFunc then
		return false
	end
	if (type(LuaFunc) ~= "function" and not (type(LuaFunc) == "table" and getmetatable(LuaFunc) and getmetatable(LuaFunc).__call)) then 
		return false
	end
	self[LuaFuncName](self, MeshComponent, Sequence)
	return true
end

function BP_NpcAnimInstance_C:Lua_AnimNotify_BindNewWeaponType(Mesh, Anim)
	print(_G.LogTag, "Lua_AnimNotify_BindNewWeaponType", Mesh, Anim)
end
--------------------------This Begins AnimNotify Please Define Function Above this line -------------------------


function BP_NpcAnimInstance_C:AnimNotify_SecondJumpEnd()
	if self.CurrentJumpState == Const.SecondJump then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end


function BP_NpcAnimInstance_C:AnimNotify_LeaveJump()
	if self.CurrentJumpState == Const.FirstJump then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end

function BP_NpcAnimInstance_C:AnimNotify_LeaveJumpSec()
	if self.CurrentJumpState == Const.SecondJump then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end
function BP_NpcAnimInstance_C:AnimNotify_EnterLand()
end

function BP_NpcAnimInstance_C:AnimNotify_EnterGround()
	self.ShouldInAir = true
end

function BP_NpcAnimInstance_C:AnimNotify_LeaveGround()
	if not self:GetPawnOwner() then 
		return 
	end
	if self.CurrentJumpState ~= Const.JumpFall or self.CurrentJumpState ~= Const.NormalState then 
		return
	end
	local TraceStart = self:GetPawnOwner():K2_GetActorLocation() + self:GetPawnOwner():GetActorForwardVector()*self:GetPawnOwner().CapsuleComponent:GetUnscaledCapsuleRadius() - FVector(0, 0, 1) * self:GetPawnOwner().CapsuleComponent:GetUnscaledCapsuleHalfHeight()
	local TraceEnd = TraceStart - FVector(0, 0, 1) * 50
	local HitResult = FHitResult() 
	UE4.UKismetSystemLibrary.LineTraceSingle(self, TraceStart, TraceEnd, ETraceTypeQuery.TraceExceptChar, false, nil, 0, HitResult, true)
	if not HitResult.bBlockingHit then 
		return 
	end
	self.ShouldInAir = false
end

function BP_NpcAnimInstance_C:AnimNotify_ShrinkEnd()
	if not self:GetPawnOwner() then 
		return
	end
	if self:GetPawnOwner():CharacterInTag("Slide") then
		return 
	end 
	self:GetPawnOwner():ResetCapSize()
end

function BP_NpcAnimInstance_C:AnimNotify_Enter_SlideLoop()
	self.IsSlideLoop = true
end

function BP_NpcAnimInstance_C:AnimNotify_Out_SlideLoop()
	self.IsSlideLoop = false
end

function BP_NpcAnimInstance_C:AnimNotify_FirstJumpEnd()
	if self.CurrentJumpState == Const.FirstJump then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end

function BP_NpcAnimInstance_C:AnimNotify_ClimbEnd()
	if self.CurrentJumpState == Const.Climb then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end

function BP_NpcAnimInstance_C:AnimNotify_EnterWallJumpLoop()
	self.CanPlayWallJumpLoop = true
end

function BP_NpcAnimInstance_C:AnimNotify_LeaveWallJumpLoop()
	self.CanPlayWallJumpLoop = false
end

function BP_NpcAnimInstance_C:AnimNotify_EnterBindNewWeaponType()
	self:GetPawnOwner():PlayWeaponNewTypeIn()
end

function BP_NpcAnimInstance_C:AnimNotify_PauseAnimation()
	if self.CurrentAnimation then
		--print("Montage_Pause", self.CurrentAnimation)
		self:Montage_Pause(self.CurrentAnimation)
	end
end

function BP_NpcAnimInstance_C:AnimNotify_DeadAnimationEnd()
	local Pawn = self:TryGetPawnOwner(self:GetPawnOwner())
	if Pawn:IsMonster() then
		Pawn:MonsterDeadAnimationEnd(Pawn:GetVector("DamageCauserLocation"), 0.0, 0.0, 3.0, 3.0)
	end
end

function BP_NpcAnimInstance_C:AnimNotify_EnterIdle()
	self:SetKawaiiPhysics_Cpp("Idle")
	self.ForceIdle = false
end

function BP_NpcAnimInstance_C:AnimNotify_EnterArmoryIdle()
	self:SetKawaiiPhysics_Cpp("ArmoryIdle")
end

function BP_NpcAnimInstance_C:AnimNotify_EnterJump()
	self:SetKawaiiPhysics_Cpp("Jump")
end

function BP_NpcAnimInstance_C:AnimNotify_EnterSecJump()
	self:SetKawaiiPhysics_Cpp("SecJump")
end

function BP_NpcAnimInstance_C:AnimNotify_EnterRunstart()
	self:SetKawaiiPhysics_Cpp("RunStart")
end


function BP_NpcAnimInstance_C:AnimNotify_EnterRunLoop()
	self:SetKawaiiPhysics_Cpp("RunLoop")
end

function BP_NpcAnimInstance_C:AnimNotify_EnterShootHoldEx()
	self:StartShootHoldToIdle()
	-- self:SetKawaiiPhysics_Cpp("ShootHold")
	-- if self.StopShootHoldHandle.Handle ~= 0 then 
	-- 	return
	-- end
	-- self.StopShootHoldHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.StopShootHoldEx}, Const.WholeShootHoldTime, false, 0)
end

function BP_NpcAnimInstance_C:AnimNotify_EnterShootHold()
	self:SetKawaiiPhysics_Cpp("ShootHold")
	if self.StopShootHoldHandle.Handle ~= 0 then 
		return
	end
	self.StopShootHoldHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.StopShootHold}, Const.WholeShootHoldTime, false, 0)
end

function BP_NpcAnimInstance_C:AnimNotify_StartShootHold()
	self:SetKawaiiPhysics_Cpp("ShootHold")
	if self.StartHoldHandle then 
		UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.StartHoldHandle)
	end
	-- self:RemoveHoldHandler()
	self.StartHoldHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.StartShootHoldToIdle}, Const.StopShootHoldDelay, false, 0)
	if self.StopShootHoldHandle.Handle ~= 0 then 
		return
	end
	self.StopShootHoldHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.StopShootHoldEx}, Const.WholeShootHoldTime, false, 0)
end

function BP_NpcAnimInstance_C:StartShootHoldToIdle()
	if true then
		self:StopShootHold()
		return
	end
	if self.CurVelocity:Size() > 0 then 
		return
	end
	self:RemoveHoldHandler()
	self.HoldeToIdle = true
	if self.StartHoldHandle then 
		UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.StartHoldHandle)
	end
	self.StartHoldHandle = nil
end

function BP_NpcAnimInstance_C:AnimNotify_EnterHoldToIdle()
	self.StopShootHoldHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.StopShootHold}, Const.StopShootHoldDelay, false, 0)
	self:GetPawnOwner():ShouldEnableHandIk()
end


function BP_NpcAnimInstance_C:AnimNotify_LeaveShootHold()
	if(self.IsOnServer) then 
		return 
	end
	
	self.HoldeToIdle = false
	-- self:StopShootHold()
	self:RemoveHoldHandler()
	if self.StartHoldHandle then 
		UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.StartHoldHandle)
		self.StartHoldHandle = nil
	end

	-- self:SetKawaiiPhysics("Shooting")
end

function BP_NpcAnimInstance_C:StopShootHoldEx()
	if self.CurVelocity:Size() > 0 then 
		self:StopShootHold()
	else
		self:StartShootHoldToIdle()
	end
end

function BP_NpcAnimInstance_C:AnimNotify_EnterRunStop()
	if(self.IsOnServer) then 
		return 
	end
	print(_G.LogTag, "AnimNotify_EnterRunStop")
	-- self.Overridden.AnimNotify_EnterRunStop(self)
	
	local CurveValue = self:GetCurveValue("FeetPos")
	local CurveValue2 = self:GetCurveValue("StartFeetPos")
	self.StartFeetPos = CurveValue2
	self.IsRightFootStop = CurveValue > 0.5 or (CurveValue < 0 and CurveValue > -0.5)
	self.FootPosCurveValue = CurveValue
	self.Pivot = false
	self:SetKawaiiPhysics_Cpp("RunStop")
end


function BP_NpcAnimInstance_C:AnimNotify_SlideStart()
	if(self.IsOnServer) then 
		return 
	end
	self:SetKawaiiPhysics_Cpp("SlideStart")
end

function BP_NpcAnimInstance_C:AnimNotify_EnterSlideToIdle()
	if(self.IsOnServer) then 
		return 
	end
	self:SetKawaiiPhysics_Cpp("SlideToIdle")

end

function BP_NpcAnimInstance_C:AnimNotify_EnterSlideToRun()
	if(self.IsOnServer) then 
		return 
	end
	self:SetKawaiiPhysics_Cpp("SlideToRun")
end

function BP_NpcAnimInstance_C:AnimNotify_EnterLand()
	if(self.IsOnServer) then 
		return 
	end
	self:SetKawaiiPhysics_Cpp("Land")
end

function BP_NpcAnimInstance_C:AnimNotify_ShowPet()
	EventManager:FireEvent(EventID.OnArmoryShowPet)
end

function BP_NpcAnimInstance_C:AnimNotify_EndShoot_Bow01()
	if(self.IsOnServer) then
		return
	end
	AudioManager(self:GetPawnOwner()):PlayNormalSound(self:GetPawnOwner(), nil, "event:/sfx/weapon/Bow/Lieyan/end", "EndShoot_Bow")
end

function BP_NpcAnimInstance_C:AnimNotify_EndShoot_Bow02()
	if(self.IsOnServer) then
		return
	end
	AudioManager(self:GetPawnOwner()):StopSound(self:GetPawnOwner(), "EndShoot_Bow")
end


return BP_NpcAnimInstance_C