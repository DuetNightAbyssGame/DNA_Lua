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
local BP_TestPlayerAnimInstance_C = Class()

-- function BP_TestPlayerAnimInstance_C:Initialize(Initializer)

-- 	-- self.CurrentAnimationState = "Idle"
-- 	-- --self.AttackAnimation = LoadObject('/Game/ParagonYin/Characters/Heroes/Yin/Animations/Primary_Attack_D_Medium_Montage.Primary_Attack_D_Medium_Montage')
-- 	-- --self.FwdStopAnimation = LoadObject('/Game/ParagonYin/Characters/Heroes/Yin/Animations/Jog_Fwd_Stop.Jog_Fwd_Stop')
-- 	-- self.SpeedArray = {0}
-- 	-- self.CurrentAnimation = nil
-- 	-- self.LastYaw = 0
-- 	-- self.EnableAim = 0
-- 	-- self.HitedState:Add("HeavyHit")
-- 	-- self.HitedState:Add("HitFly")
-- 	-- self.HitedState:Add("HitFlyDown")
-- 	-- self.HitedState:Add("HitRepel")
-- 	-- self.HitedState:Add("LightHit")
-- 	-- self.HitedState:Add("LightHitRanged")
-- 	-- self.FootIKValues = New(FootIKValues)
-- 	-- self.FacialEyeList = UE4.TMap("", FFacialBlender())
-- 	-- self.FacialMouthList = UE4.TMap("", FFacialBlender())
-- 	-- self.FacialTimerHandles = {}
-- 	-- self.ShouldInAir = true
-- 	-- self.bEnableKawaiiSetting = true
-- end

--function BP_CharacterBase_C:UserConstructionScript()
--end

function BP_TestPlayerAnimInstance_C:LuaAnimBeginPlay()
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

function BP_TestPlayerAnimInstance_C:GetPawnOwner()
	if not self.Pawn then
		self.Pawn = self:TryGetPawnOwner()
	end

	return self.Pawn
end

--function BP_CharacterBase_C:ReceiveEndPlay()
--end

-- function BP_TestPlayerAnimInstance_C:BlueprintUpdateAnimation(DeltaTimeX)
-- 	if self.Overridden then
-- 		self.Overridden.BlueprintUpdateAnimation(self, DeltaTimeX)
-- 	end
-- 	-- UE4.UKismetSystemLibrary.DrawDebugSphere(self, self.Hand_L_Pos, 5, 12, UE4.UKismetMathLibrary.LinearColor_Red(), 0.1)
-- 	local Pawn = self:TryGetPawnOwner(self.Pawn)
-- 	if not Pawn then
-- 		return
-- 	end
-- 	if Pawn:IsPlayer() then
-- 		self:PlayerBlueprintUpdate(DeltaTimeX)
-- 	else
-- 		self:MonsterBlueprintUpdate(DeltaTimeX)
-- 	end
-- end

-- function BP_TestPlayerAnimInstance_C:PlayerBlueprintUpdate(DeltaTimeX)
-- 	-- self:UpdateIdleTag()
-- 	if self.CurrentKawaiiState ~= "InAir" and self.CurrentJumpState == Const.JumpFall then 
-- 		self:SetKawaiiPhysics_Cpp("InAir")
-- 	end
-- 	if self.IsInAir and self.CharacterTag == "Slide" and self.CurrentKawaiiState ~= "SlideStart" then 
-- 		self:SetKawaiiPhysics_Cpp("SlideStart")
-- 	end
-- 	-- print(_G.LogTag, "11111111111111111111111111111111111", self.CurrentKawaiiState)
-- end



-- function BP_TestPlayerAnimInstance_C:UseBlueprintSettingAttr()
-- 	self:InitAttributeFromTable(true)
-- end

-- function BP_TestPlayerAnimInstance_C:UpdateIdleTag()
-- 	if self.IsEnterArmory ~= "None" then 
-- 		return
-- 	end
-- 	local NotIdle = self.CharacterTag ~= "Idle" or self.MoveSpeed ~= 0.0 or self.StartShoot
-- 	if NotIdle and self.IdleHandle then
-- 		self:RemoveIdleHandle()
-- 	end
-- 	if NotIdle and IdleTagToZero[self.IdleTag] then
-- 		self:ResetIdleTag(true)
-- 		return 
-- 	end
-- end

--SetIdleTag
-- function BP_TestPlayerAnimInstance_C:SetIdleTag(IdleTag, NoAfterFunc)
-- 	-- if self.IdleTag == IdleTag then
-- 	-- 	return
-- 	-- end
-- 	if self.IdleHandle then
-- 		self:RemoveIdleHandle()
-- 	end
-- 	if self:CheckCanEnterIdleTag(IdleTag) then 
-- 		return 
-- 	end
-- 	self.IdleTag = IdleTag
-- 	if NoAfterFunc then
-- 		return
-- 	end
-- 	local AfterFunc = self["OnEnter".. IdleTag]
-- 	if AfterFunc then
-- 		AfterFunc(self)
-- 	end
-- end

-- function BP_TestPlayerAnimInstance_C:SetIdleTag_Lua(IdleTag, NoAfterFunc)
-- 	if not self:CheckCanEnterIdleTag(IdleTag) then 
-- 		return 
-- 	end
-- 	local PreLeaveFunc = self["OnLeave".. self.IdleTag]
-- 	if PreLeaveFunc then
-- 		PreLeaveFunc(self, IdleTag)
-- 	end
-- 	self.IdleTag = IdleTag
-- 	self.IdleTagName = IdleTag
-- 	if NoAfterFunc then
-- 		return
-- 	end
-- 	local AfterFunc = self["OnEnter".. IdleTag]
-- 	if AfterFunc then
-- 		AfterFunc(self)
-- 	end
-- end

function BP_TestPlayerAnimInstance_C:OnLeaveGesture01_Idle(NewIdleTag)
	if self:IsAnymontagePlaying() then
		self:Montage_StopSlotByName(0, "Gesture")
	end
end

-- function BP_TestPlayerAnimInstance_C:CheckCanEnterIdleTag(IdleTag)
-- 	if not IdleTag then
-- 		return false
-- 	end
-- 	local CheckFunc = self["CheckCanEnter".. IdleTag]
-- 	if CheckFunc and not CheckFunc(self) then
-- 		return false
-- 	end
-- 	return true
-- end

--CheckCanEnterEmoIdle
-- function BP_TestPlayerAnimInstance_C:CheckCanEnterEmoIdle()
-- 	if not self.IsEmoIdleEnable_FootIk then 
-- 		return false
-- 	end
-- 	if not self.IsEmoIdleEnable then
-- 		return false
-- 	end
-- 	if self.IsEnterArmory ~= "" and self.IsEnterArmory ~= "None" then 
-- 		return false
-- 	end
-- 	if self.CharacterTag ~= "Idle" then
-- 		return false
-- 	end
-- 	if self.IdleTag ~= "0" then
-- 		return false
-- 	end
-- 	-- print(_G.LogTag, "1111111",  self:GetCurrentFloorZ())
-- 	if self:GetCurrentFloorZ() < 0.95 then 
-- 		return false
-- 	end
-- 	return true
-- end

--checkcanenter0
-- function BP_TestPlayerAnimInstance_C:CheckCanEnter0()
-- 	-- if self.CharacterTag ~= "Idle" then
-- 	-- 	return false
-- 	-- end
-- 	local Pawn = self:TryGetPawnOwner()
-- 	if not Pawn then
-- 		return false
-- 	end
-- 	if not Pawn.CheckShouldEnterNormalIdle then 
-- 		return true
-- 	end
-- 	return Pawn:CheckShouldEnterNormalIdle()
-- end
--OnEnter0 --- idletag 0 
-- function BP_TestPlayerAnimInstance_C:OnEnter0()
-- 	-- if self.Pawn and self.Pawn:IsPlayer() then 
-- 	-- 	local _ = self.Pawn.CheckCanLookAt and self.Pawn:CheckCanLookAt()
-- 	-- end
-- 	self.DeltaYaw = 0
-- 	if (self.CurVelocity:Size()  <= 0) then 
-- 		self.VelocityBlend = FVelocityBlend()
-- 	end
-- 	if self.IsEnterArmory ~= "None" and self.IsEnterArmory ~= "" then
-- 		self.Pawn:SetArmoryTag("None")
-- 	end 
-- 	self.IdleHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.EnterEmojiIdle}, Const.EmojiIdleDelay, false, 0)
-- end

--OnEnterEmoIdle
function BP_TestPlayerAnimInstance_C:OnEnterEmoIdle()
	-- if self.Pawn and self.Pawn.StopLookAt then 
	-- 	self.Pawn:StopLookAt()
	-- end
	if self.IdleTag=="EmoIdle" and self:CanPlayEmoIdleVoice() and not self:GetPawnOwner().bHidden then
		AudioManager(self):PlaySeById(self:GetPawnOwner(), 214, self:GetPawnOwner(), false, true, "", "EmoIdle")
		self.EmoIdleVoiceHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.RemoveEmoIdleVoiceHandle}, Const.EmoIdleVoiceCoolDown, false, 0)
	end
end

function BP_TestPlayerAnimInstance_C:OnLeaveEmoIdle()
	if self.EmoIdleVoiceHandle then
		self:RemoveEmoIdleVoiceHandle()
		AudioManager(self):StopSound(self:GetPawnOwner(), "EmoIdle")
	end
end

function BP_TestPlayerAnimInstance_C:CanPlayEmoIdleVoice()
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

-- function BP_TestPlayerAnimInstance_C:ResetIdleTag(NoAfterFunc)
-- 	self:SetIdleTag("0", NoAfterFunc)
-- end

--function BP_TestPlayerAnimInstance_C:ForceToRunloop()
--	self.bIsDirectRunLoop = true
--	self.ForceRunLoopTag = true
--end

-- function BP_TestPlayerAnimInstance_C:EnableKawaiiSettings(Enabled)
-- 	self.bEnableKawaiiSetting = Enabled
-- 	if Enabled then 
-- 		-- print('11111111111111111111111111111111111111111111111111111111111111', self.CurrentKawaiiState)
-- 		self:SetKawaiiPhysics_Cpp(self.CurrentKawaiiState)
-- 	end
-- end
-- function BP_TestPlayerAnimInstance_C:EnterIk()
-- 	self.EnableIK = true
-- 	self.TargetRotOffset = FRotator()
-- end


function BP_TestPlayerAnimInstance_C:SetEmoIdleEnabled(IsEnable, IsChangeRefreshNow)
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

function BP_TestPlayerAnimInstance_C:EnterEmojiIdle()
	self:SetIdleTag("EmoIdle")
end

-- function  BP_TestPlayerAnimInstance_C:RemoveIdleHandle()
-- 	UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.IdleHandle)
-- 	self.IdleHandle = nil
-- 	-- body
-- end

function BP_TestPlayerAnimInstance_C:RemoveEmoIdleVoiceHandle()
	UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.EmoIdleVoiceHandle)
	self.EmoIdleVoiceHandle = nil
end

function BP_TestPlayerAnimInstance_C:EnterArmoryIdle()
	self:RemoveIdleHandle()
	if self.IsEnterArmory == "None" then 
		self:ResetIdleTag()
		-- self:AnimNotify_IdleStart()
		return 
	end
	-- local ArmIdleTag = self:GetArmoryIdleTag()
end

function BP_TestPlayerAnimInstance_C:SetArmoryIdleTag(bHideUntilLoop)
	if self.IsEnterArmory ~= "None" then 
		self:SetIdleTag(self:GetArmoryIdleTag())

		if self:GetPawnOwner() and (self:GetPawnOwner():IsPlayer() or self:GetPawnOwner():IsPhantom())then 
			-- self:GetPawnOwner():ShouldEnableHandIk()
			self.EnableHandIk = false
			self:GetPawnOwner():PlayShowIdleMontage(self.IdleTag, bHideUntilLoop)
		end
	end
end

-- function BP_TestPlayerAnimInstance_C:ShouldEnableHandIk()
-- 	-- body
-- 	return self.StartShoot or (self.IdleTag ~= "0" and self.IdleTag ~= Const.NoWeaponIdleType and self.IdleTag ~= "EmoIdle")
-- end

function BP_TestPlayerAnimInstance_C:GetArmoryIdleTag()
	local Pawn = self:TryGetPawnOwner(self:GetPawnOwner())
	if not Pawn then
		return "0"
	end
	if self.IsEnterArmory then
		if Const.ArmoryIdleTags[self.IsEnterArmory] then
			return Const.ArmoryIdleTags[self.IsEnterArmory]
		elseif Const.ArmoryWeaponIdleTags[self.IsEnterArmory] then
			return self.IsEnterArmory .. "_" .. Pawn:GetUsingWeaponType(Const.ArmoryWeaponIdleTag2WeaponType[self.IsEnterArmory])
		end
	end
	return Pawn:GetUsingWeaponType(self.IsEnterArmory)
end

function BP_TestPlayerAnimInstance_C:IsArmoryIdleTag(Tag)
	if not Tag then
		return false
	end
	local CurrentTag = self:GetArmoryIdleTag()
	return CurrentTag == Tag
end

function BP_TestPlayerAnimInstance_C:OnAnimationEnded(Montage, Interrupted)
	--print("OnAnimationEnded", Montage, Interrupted)
end

-- function BP_TestPlayerAnimInstance_C:GetAimTargetLoc(Pawn, ActorRot)
-- 	local CharToTarget = Pawn:GetActorForwardVector()

-- 	if Pawn:IsAIControlled() then 
-- 		CharToTarget = Pawn:GetMonsterToTarget()
-- 	else
-- 		CharToTarget = self:PlayerTargetLoc(Pawn, ActorRot)
-- 	end
-- 	CharToTarget = CharToTarget or Pawn:GetActorForwardVector()
-- 	return CharToTarget
-- end

-- function BP_TestPlayerAnimInstance_C:PlayerTargetLoc(Pawn, ActorRot)
-- 	-- if Weapon doesn't have maxdistance
-- 	local Distance = 1000
-- 	if Pawn:GetCurrentWeapon() then
-- 		local CurrentWeaponId = Pawn:GetCurrentWeapon().WeaponId
-- 		local WeaponInfo = DataMgr.BattleWeapon[CurrentWeaponId]
-- 		if WeaponInfo then
-- 			Distance = WeaponInfo.MaxDistance or Distance
-- 		end
-- 	end
-- 	-- if math.abs(DiffControl.Yaw) > Const.NearZero then
-- 	-- 	self.AimRot = Const.DefaultAimRot
-- 	-- 	return
-- 	-- end
-- 	local ShootingTargets = Pawn:GetShootingTargets()
-- 	local Target = nil
-- 	if ShootingTargets and ShootingTargets:Length() > 0 then
-- 		Target = ShootingTargets:GetRef(1)
-- 	end
-- 	local SourceLocation = self:GetOwningComponent():GetSocketLocation("Socket_AimBase")
-- 	local LocationData = {
-- 		Source = Pawn,
-- 		Target = Target,
-- 		Direction = "Camera",
-- 		Distance = Distance,
-- 		BornRotation = SourceLocation,
-- 	}
-- 	local TargetLocation = Battle(Pawn):CalcTargetLocation(LocationData)
-- 	return TargetLocation - SourceLocation
-- end

-- function BP_TestPlayerAnimInstance_C:ShowDamage(DamageEvent)
--     if not self:GetPawnOwner() then 
--     	return 
--     end
--     if not self:GetPawnOwner():IsPlayer() then 
--     	return 
--     end
-- 	if self.HitAdditiveState ~= 0 and self.IdleTag == "Gesture01_Idle" then 
-- 		return
-- 	end
--     self:ResetIdleTag()
-- end

-- function BP_TestPlayerAnimInstance_C:PlaySkillAnimation(AnimationPath, DisableBlendBone, SlotName, AnimPlayRate, StartTime, EndTime, IsRep)
-- 	local AnimationAsset = UE4.UResourceLibrary.FindObject(self, AnimationPath)
-- 	if AnimationAsset == nil then
-- 		AnimationAsset = LoadObject(AnimationPath)
-- 	end

--     assert(AnimationAsset, "找不到资产:"..tostring(AnimationPath))
--     local Pawn = self:TryGetPawnOwner(self:GetPawnOwner())
-- 	if AnimationAsset and self:IsMontageAsset(AnimationAsset) then
-- 		if not IsRep then
-- 		    Pawn:SetCanExtractZVelocity()
-- 			Pawn:ResetAllCancelTag()
-- 			self:Montage_Play(AnimationAsset,AnimPlayRate)
-- 		else
-- 			Pawn:Montage_RepPlay(AnimationPath, AnimPlayRate)
-- 		end
-- 	else
-- 		self.CurrentAnimation = self:PlaySlotAnimationAsDynamicMontage(AnimationAsset,SlotName,0.0, 0.0, AnimPlayRate, 1, EndTime, StartTime)
-- 	end
-- 	return AnimationAsset
-- end

-- function BP_TestPlayerAnimInstance_C:StopSkillAnimation()
-- 	if self.CurrentAnimation then
-- 		--print("Montage_Stop", self.CurrentAnimation)

-- 		self:Montage_Stop(0.25, self.CurrentAnimation)
-- 		self.CurrentAnimation = nil
-- 	end
-- end

function BP_TestPlayerAnimInstance_C:RealMontage_RepPlay(MontagePath, InPlayRate, StartSectionName, ReturnValueType, InTimeToStartMontageAt, bStopAllMontages)
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

function  BP_TestPlayerAnimInstance_C:EndAnimationTrigger()
	-- body
	if self.CurrentAnimation then
		--print("Montage_Stop", self.CurrentAnimation)
		self:Montage_Stop(0.01, self.CurrentAnimation)
		self.CurrentAnimation = nil
	end
end

function BP_TestPlayerAnimInstance_C:PlayEyeAnimation(Animation)
	if(not Animation) then return end
	DebugPrint("Eye animation:",Animation)
	self.EyeSequence=Animation
end

function BP_TestPlayerAnimInstance_C:PlayMouthAnimation(Animation)
	if(not Animation) then return end
	DebugPrint("Mouth animation:",Animation)
	self.MouthSequence=Animation
end

function BP_TestPlayerAnimInstance_C:SetNpcDefaultAnim(Animation)
	if(not Animation) then
		DebugPrint("ERROR: DefaultAnim Is Null", self:GetPawnOwner():GetName())
		return
	end
	DebugPrint("NpcDefaultAnim: ",Animation)
	self.NpcDefaultAnim=Animation
end

function BP_TestPlayerAnimInstance_C:SetNpcDefaultAnimEnable(bEnable)
	self.EnableNpcDefaultAnim = bEnable
end

function BP_TestPlayerAnimInstance_C:SwitchEnableTalkAction(bEnable)
	self.bEnableTalkAction = bEnable and true or false
end

function BP_TestPlayerAnimInstance_C:SwitchEnableAnimInstanceIK(bEnable)
	DebugPrint("BP_TestPlayerAnimInstance_C:SwitchEnableAnimInstanceIK", bEnable)
	self.bUseIK = bEnable and true or false
end

-- function BP_TestPlayerAnimInstance_C:SetKawaiiPhysics(CurrentState)
-- 	if not self:GetPawnOwner() then 
-- 		return 
-- 	end
-- 	if self.CurrentKawaiiState == CurrentState then 
-- 		return 
-- 	end
-- 	if HighLevelKawaiiState[CurrentState] then 
-- 		self.HighLevelKawaii = CurrentState
-- 	else
-- 		self.NormalKawaii = CurrentState
-- 	end
	
-- 	if self.HighLevelKawaii ~= "" and CurrentState == self.NormalKawaii then 
-- 		return 
-- 	end
-- 	self.CurrentKawaiiState = CurrentState
-- 	self:ForceKawaiiSettings(CurrentState)
-- end


function BP_TestPlayerAnimInstance_C:CheckParamentVaild(KawaiiInfo, CurrentState)
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

function BP_TestPlayerAnimInstance_C:TryCallLuaOverriden(NotifyName, MeshComponent, Sequence)
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

function BP_TestPlayerAnimInstance_C:Lua_AnimNotify_BindNewWeaponType(Mesh, Anim)
	print(_G.LogTag, "Lua_AnimNotify_BindNewWeaponType", Mesh, Anim)
end
--------------------------This Begins AnimNotify Please Define Function Above this line -------------------------


function BP_TestPlayerAnimInstance_C:AnimNotify_SecondJumpEnd()
	if self.CurrentJumpState == Const.SecondJump then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end


function BP_TestPlayerAnimInstance_C:AnimNotify_LeaveJump()
	if self.CurrentJumpState == Const.FirstJump then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end

function BP_TestPlayerAnimInstance_C:AnimNotify_LeaveJumpSec()
	if self.CurrentJumpState == Const.SecondJump then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end
function BP_TestPlayerAnimInstance_C:AnimNotify_EnterLand()
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterGround()
	self.ShouldInAir = true
	self.ForceIdle = false
end

function BP_TestPlayerAnimInstance_C:AnimNotify_LeaveGround()
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

function BP_TestPlayerAnimInstance_C:AnimNotify_ShrinkEnd()
	if not self:GetPawnOwner() then 
		return
	end
	if self:GetPawnOwner():CharacterInTag("Slide") then
		return 
	end 
	self:GetPawnOwner():ResetCapSize()
end

function BP_TestPlayerAnimInstance_C:AnimNotify_Enter_SlideLoop()
	self.IsSlideLoop = true
end

function BP_TestPlayerAnimInstance_C:AnimNotify_Out_SlideLoop()
	self.IsSlideLoop = false
end

function BP_TestPlayerAnimInstance_C:AnimNotify_FirstJumpEnd()
	if self.CurrentJumpState == Const.FirstJump then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end

function BP_TestPlayerAnimInstance_C:AnimNotify_ClimbEnd()
	if self.CurrentJumpState == Const.Climb then
		if (self:GetPawnOwner()) then 
			self:GetPawnOwner():SetCurrentJumpState(Const.JumpFall)
		end
	end
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterWallJumpLoop()
	self.CanPlayWallJumpLoop = true
end

function BP_TestPlayerAnimInstance_C:AnimNotify_LeaveWallJumpLoop()
	self.CanPlayWallJumpLoop = false
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterBindNewWeaponType()
	self:GetPawnOwner():PlayWeaponNewTypeIn()
end

-- function BP_TestPlayerAnimInstance_C:AnimNotify_IdleStartNew()
-- 	if self.IdleHandle or not self.IsEmoIdleEnable then
-- 		return
-- 	end
-- 	self:ResetIdleTag()
-- 	self:SetKawaiiPhysics("Idle")
-- end

function BP_TestPlayerAnimInstance_C:AnimNotify_PauseAnimation()
	if self.CurrentAnimation then
		--print("Montage_Pause", self.CurrentAnimation)
		self:Montage_Pause(self.CurrentAnimation)
	end
end

function BP_TestPlayerAnimInstance_C:AnimNotify_DeadAnimationEnd()
	local Pawn = self:TryGetPawnOwner(self:GetPawnOwner())
	if Pawn:IsMonster() then
		Pawn:MonsterDeadAnimationEnd(Pawn:GetVector("DamageCauserLocation"), 0.0, 0.0, 3.0, 3.0)
	end
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterIdle()
	self:SetKawaiiPhysics_Cpp("Idle")
	self.ForceIdle = false
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterArmoryIdle()
	self:SetKawaiiPhysics_Cpp("ArmoryIdle")
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterJump()
	self:SetKawaiiPhysics_Cpp("Jump")
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterSecJump()
	self:SetKawaiiPhysics_Cpp("SecJump")
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterRunstart()
	self:SetKawaiiPhysics_Cpp("RunStart")
end


function BP_TestPlayerAnimInstance_C:AnimNotify_EnterRunLoop()
	self:SetKawaiiPhysics_Cpp("RunLoop")
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterShootHoldEx()
	self:StartShootHoldToIdle()
	-- self:SetKawaiiPhysics_Cpp("ShootHold")
	-- if self.StopShootHoldHandle.Handle ~= 0 then 
	-- 	return
	-- end
	-- self.StopShootHoldHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.StopShootHoldEx}, Const.WholeShootHoldTime, false, 0)
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterShootHold()
	self:SetKawaiiPhysics_Cpp("ShootHold")
	if self.StopShootHoldHandle.Handle ~= 0 then 
		return
	end
	self.StopShootHoldHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.StopShootHold}, Const.WholeShootHoldTime, false, 0)
end

function BP_TestPlayerAnimInstance_C:AnimNotify_StartShootHold()
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

function BP_TestPlayerAnimInstance_C:StartShootHoldToIdle()
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

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterHoldToIdle()
	self.StopShootHoldHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.StopShootHold}, Const.StopShootHoldDelay, false, 0)
	self:GetPawnOwner():ShouldEnableHandIk()
end


function BP_TestPlayerAnimInstance_C:AnimNotify_LeaveShootHold()
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

function BP_TestPlayerAnimInstance_C:StopShootHoldEx()
	if self.CurVelocity:Size() > 0 then 
		self:StopShootHold()
	else
		self:StartShootHoldToIdle()
	end
end

-- function BP_TestPlayerAnimInstance_C:StopShootHold()
-- 	self:RemoveHoldHandler()
-- 	self.StartShoot = false
-- 	self.HoldeToIdle = false
-- 	self.EnableAim = UE4.UKismetMathLibrary.Clamp(self.EnableAim - 1, 0, 1)
-- 	self:GetPawnOwner():DisableReloadWithoutShoot()
-- 	-- self:ShouldEnableHandIk()
-- 	self.FullBody = true
-- 	self:GetPawnOwner():ShouldEnableHandIk()-- or self.StartShoot

-- 	self.HighLevelKawaii = ""
-- 	self:SetKawaiiPhysics_Cpp(self.NormalKawaii)
-- end

-- TODO: has been moved to C++, needs to be deleted when it is stable.
--function BP_TestPlayerAnimInstance_C:RemoveHoldHandler()
--	if self.StopShootHoldHandle then 
--		UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.StopShootHoldHandle)
--	end
--	self.StopShootHoldHandle = nil
--end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterRunStop()
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


function BP_TestPlayerAnimInstance_C:AnimNotify_SlideStart()
	if(self.IsOnServer) then 
		return 
	end
	self:SetKawaiiPhysics_Cpp("SlideStart")
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterSlideToIdle()
	if(self.IsOnServer) then 
		return 
	end
	self:SetKawaiiPhysics_Cpp("SlideToIdle")

end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterSlideToRun()
	if(self.IsOnServer) then 
		return 
	end
	self:SetKawaiiPhysics_Cpp("SlideToRun")
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EnterLand()
	if(self.IsOnServer) then 
		return 
	end
	self:SetKawaiiPhysics_Cpp("Land")
end

function BP_TestPlayerAnimInstance_C:AnimNotify_ShowPet()
	EventManager:FireEvent(EventID.OnArmoryShowPet)
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EndShoot_Bow01()
	if(self.IsOnServer) then
		return
	end
	AudioManager(self:GetPawnOwner()):PlayNormalSound(self:GetPawnOwner(), nil, "event:/sfx/weapon/Bow/Lieyan/end", "EndShoot_Bow")
end

function BP_TestPlayerAnimInstance_C:AnimNotify_EndShoot_Bow02()
	if(self.IsOnServer) then
		return
	end
	AudioManager(self:GetPawnOwner()):StopSound(self:GetPawnOwner(), "EndShoot_Bow")
end


return BP_TestPlayerAnimInstance_C