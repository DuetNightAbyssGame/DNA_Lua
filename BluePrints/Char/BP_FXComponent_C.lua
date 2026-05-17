--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"
require "Utils"
local BP_FXComponent_C = Class()

-- function BP_FXComponent_C:Initialize(Initializer)
-- 	--print("FXComponent Initialize")
-- end

-- function BP_FXComponent_C:ReceiveBeginPlay()
-- 	rawset(self, "FxAnimation", {})
-- 	rawset(self, "TargetEffects", {})
-- 	-- self.FxAnimation = {}
-- 	-- self.TargetEffects = {}
-- 	-- self.Effects = {}
-- end

--function BP_FXComponent_C:ReceiveEndPlay()
--end

  

-- function BP_FXComponent_C:PlayHitFX(SocketName, Weapon, ByCrital)
-- 	-- body
-- 	print("PlayHitFX", SocketName, Weapon, ByCrital)
-- 	if Weapon then
-- 		Weapon.FXComponent:PlayGroupFX("HitEffect", false, self:GetMeshComponent(), nil, SocketName, "", UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0))
-- 	else
-- 		-- local FXPath = "/Game/Asset/FX/Heitao/Particles/NS_Heitao_Hit.NS_Heitao_Hit"
-- 		-- local FXAsset = LoadObject(FXPath)
-- 		-- self:PlayFX(FXAsset, nil, SocketName, UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0))
-- 	end
-- end

-- function BP_FXComponent_C:GetMeshComponent()
-- 	if rawget(self, "CacheMeshComponent") then
-- 		return self.CacheMeshComponent
-- 	end
-- 	-- body
-- 	local Pawn = self:GetOwner()
-- 	rawset(self, "CacheMeshComponent", Pawn.Mesh)
-- 	if rawget(self, "CacheMeshComponent") == nil then
-- 		rawset(self, "CacheMeshComponent", Pawn.WeaponMesh)
-- 	end
-- 	if rawget(self, "CacheMeshComponent") == nil then
-- 		rawset(self, "CacheMeshComponent", Pawn:K2_GetRootComponent())
-- 	end

-- 	return self.CacheMeshComponent
-- end
--[[
function BP_FXComponent_C:GetRealMesh(MeshComp)
	local Owner = self:GetOwner()
	local Mesh
	if Owner.GetFXMesh then
		Mesh = Owner:GetFXMesh()
	else
		Mesh = MeshComp
	end
	if Mesh == nil then
		Mesh = self:GetMeshComponent()
	end
	return Mesh
end
]]

--[[
function BP_FXComponent_C:PlayFX(FXAsset, MeshComp, SocketName, LocalOffset, LocalRotation, UseAbsoluteLocation, FollowRootMotion, bTickEvenWhenPaused)
	-- body
	local Mesh = self:GetRealMesh(MeshComp)
	if Mesh == nil then
		return nil
	end
	-- print("PlayFX", FXAsset)
	local FxObject = nil
	if UE4.UKismetMathLibrary.EqualEqual_ClassClass(FXAsset:GetClass(), UNiagaraSystem:StaticClass()) then
		if UseAbsoluteLocation then
			if MiscUtils.IsTakeRecorderCapturing(self) then
				local attachTarget = self:GetOwner().RootComponent
				if MeshComp then
					attachTarget = MeshComp
				end
				local DirectSource = self:GetOwner():GetDirectSource()
				if DirectSource then
					attachTarget = DirectSource.RootComponent
				end
				FxObject = UE4.UNiagaraFunctionLibrary.SpawnSystemAttached(FXAsset, attachTarget, "", LocalOffset , LocalRotation, 1)
				FxObject:SetAbsolute(true, true, true) 
				FxObject:K2_SetWorldLocationAndRotation(LocalOffset,LocalRotation,false,nil,false)
			else
				FxObject = UE4.UNiagaraFunctionLibrary.SpawnSystemAtLocation(self:GetOwner(), FXAsset, LocalOffset, LocalRotation, Const.OneVector, true, true, 0, true, bTickEvenWhenPaused or false)
			end
		elseif FollowRootMotion then
			local Transform = Mesh:GetSocketTransform(SocketName, UE4.ERelativeTransformSpace.RTS_Component)
			LocalOffset = Transform.Translation
			LocalRotation = Transform.Rotation:ToRotator()
			-- print("Play", LocalOffset, LocalRotation, Transform.Scale3D)
			FxObject = UE4.UNiagaraFunctionLibrary.SpawnSystemAttached(FXAsset, Mesh, "", LocalOffset, LocalRotation, 0)
		else
			FxObject = UE4.UNiagaraFunctionLibrary.SpawnSystemAttached(FXAsset, Mesh, SocketName, LocalOffset, LocalRotation, 0)
		end
		-- print("PlayFX NiagaraEffects")
	elseif UE4.UKismetMathLibrary.EqualEqual_ClassClass(FXAsset:GetClass(), UParticleSystem:StaticClass()) then
		if UseAbsoluteLocation then 
			FxObject = UE4.UGameplayStatics.SpawnEmitterAtLocation(self:GetOwner(), FXAsset, LocalOffset, LocalRotation) 
		elseif FollowRootMotion then
			FxObject = UE4.UGameplayStatics.SpawnEmitterAttached(FXAsset, Mesh, "", LocalOffset, LocalRotation) 
		else
			FxObject = UE4.UGameplayStatics.SpawnEmitterAttached(FXAsset, Mesh, SocketName, LocalOffset, LocalRotation) 
		end
	end
	return FxObject
end
]]
-- function BP_FXComponent_C:GetEffectById(EffectID)
-- 	local EffectPath = DataMgr.VisualEffect[EffectID].EffectPath
-- 	if EffectPath ~= nil then
-- 		local FXPath = EffectPath
-- 		local FXAsset = LoadObject(FXPath)
-- 		return FXAsset
-- 	end
-- 	return nil
-- end

-- function BP_FXComponent_C:PlayTrailFX(FXAsset, MeshComp, FirstSocketName, SecondSocketName, WidthScaleMode, IsUseParentScale)
-- 	-- body
-- 	local Mesh = MeshComp
-- 	if Mesh == nil then
-- 		Mesh = self:GetMeshComponent()
-- 	end
-- 	local FxObject = self:SpawnTrailEffect(FXAsset, Mesh, FirstSocketName, SecondSocketName, WidthScaleMode)
-- 	if FxObject and IsUseParentScale then
-- 		FxObject:SetRelativeScale3D(Mesh:GetOwner():GetTransform().Scale3D)
-- 	end
-- 	return FxObject
-- end

-- function BP_FXComponent_C:HandleScaleRate(MeshComponent, Scale, IsUseParentScale)
-- 	local FinalScale = Scale
-- 	if IsUseParentScale then
-- 		local Mesh = self:GetRealMesh(MeshComponent)
-- 		if not Mesh then return FinalScale end
-- 		local Owner = Mesh:GetOwner()
-- 		local OwnerScale = Owner:GetTransform().Scale3D
-- 		if not Scale then return OwnerScale end
-- 		FinalScale = FinalScale * OwnerScale
-- 	end
-- 	return FinalScale
-- end

-- function BP_FXComponent_C:PlayGroupFX(GroupName, ManualStop, MeshComponent, PlayerMeshComponent, SocketName, SecondSocketName, LocalOffset, LocalRotation, AnimationName, UseAbsoluteLocation, FXSource, IsUseParentScale, AttachNotFollow, Priority)
-- 	-- body
-- 	self:PlayGroupFXInternal(GroupName, ManualStop, MeshComponent, PlayerMeshComponent, SocketName, SecondSocketName, LocalOffset, LocalRotation, AnimationName, UseAbsoluteLocation, FXSource, IsUseParentScale, AttachNotFollow, Priority)
-- end
--[[
function BP_FXComponent_C:PlayGroupFXInternal(GroupName, ManualStop, MeshComponent, PlayerMeshComponent, SocketName, SecondSocketName, LocalOffset, LocalRotation, AnimationName, InColor, UseAbsoluteLocation, FXSource, IsUseParentScale)
	local UseSettedSocket = true
	if not FXSource then
		FXSource = self 
		UseSettedSocket = false
	end
	local Color = nil
	local Weapon = FXSource:GetOwner()
	if Weapon and Weapon.WeaponFashion then
		Color = Weapon.WeaponFashion:GetEffectColor()
	end
	local Effects = FXSource.NiagaraEffects:Find(GroupName)
	if Effects and Effects.Effects:Length() > 0 then
		Effects = Effects.Effects
		local Keys = Effects:Keys()
		for i = 1, Keys:Length() do
			local Key = Keys:GetRef(i)
			local Effect = Effects:Find(Key)
			--print("GetRef", Key, Effect.FXAsset, Effect.SocketName)
			local FxObject = nil
			-- print('222222222222222222222222222222222222222222222222222222',LocalOffset, LocalRotation)
			if UseSettedSocket then 
				Effect.SocketName = SocketName
				LocalOffset = Effect.LocalOffset
				LocalRotation = LocalRotation
			else
				if LocalOffset then
					LocalOffset = Effect.LocalOffset + LocalOffset
				else
					LocalOffset = Effect.LocalOffset
				end
				if LocalRotation then
					LocalRotation = Effect.LocalRotation + LocalRotation
				else
					LocalRotation = Effect.LocalRotation
				end
			end
			local bFollowRootMotion = Effect.bFollowRootMotion
			if Effect.bPlayByChar then
				MeshComponent = PlayerMeshComponent
				PlayerMeshComponent = nil
				bFollowRootMotion = false  
			end
			if UseAbsoluteLocation then
				FxObject = self:PlayFX(Effect.FXAsset, MeshComponent, SocketName, LocalOffset, LocalRotation, true, Effect.bFollowRootMotion, Effect.bTickEvenWhenPaused)
			elseif Effect.bAttach==false then
				local LocalTransform = UE4.UKismetMathLibrary.MakeTransform(LocalOffset, LocalRotation, UE4.FVector(1, 1, 1))
				local Transform = MeshComponent:GetSocketTransform(Effect.SocketName, UE4.ERelativeTransformSpace.RTS_World)
				if PlayerMeshComponent then
					local AttachSocketName = MeshComponent:GetAttachSocketName()
					local PlayerTransform = PlayerMeshComponent:GetSocketTransform(AttachSocketName, UE4.ERelativeTransformSpace.RTS_World)
					local Transform1 = MeshComponent:GetSocketTransform(Effect.SocketName, UE4.ERelativeTransformSpace.RTS_Component)
					-- local Transform2 = PlayerMeshComponent:GetSocketTransform(AttachSocketName, UE4.ERelativeTransformSpace.RTS_Component)
					-- local Position = PlayerMeshComponent:GetOwner().PlayerAnimInstance:Montage_GetPosition()
					-- print(Transform2, Position)
					Transform = Transform1 * PlayerTransform
				end
				local FinalTransform = LocalTransform*Transform
				LocalOffset = FinalTransform.Translation
				LocalRotation = FinalTransform.Rotation:ToRotator()
				-- print("Play", LocalOffset, LocalRotation, Transform.Scale3D)
				FxObject = self:PlayFX(Effect.FXAsset, MeshComponent, Effect.SocketName, LocalOffset, LocalRotation, true, nil, Effect.bTickEvenWhenPaused)

			elseif bFollowRootMotion then
				local LocalTransform = UE4.UKismetMathLibrary.MakeTransform(LocalOffset, LocalRotation, UE4.FVector(1, 1, 1))
				local Transform = MeshComponent:GetSocketTransform(Effect.SocketName, UE4.ERelativeTransformSpace.RTS_World)
				local RootTransform = PlayerMeshComponent:GetSocketTransform("", UE4.ERelativeTransformSpace.RTS_World)
				local RelativeTransform = UE4.UKismetMathLibrary.MakeRelativeTransform(LocalTransform * Transform, RootTransform)
				LocalOffset = RelativeTransform.Translation
				LocalRotation = RelativeTransform.Rotation:ToRotator()
				-- print("PlayerMeshComponent", PlayerMeshComponent, LocalOffset, LocalRotation)
				FxObject = self:PlayFX(Effect.FXAsset, PlayerMeshComponent, "", LocalOffset, LocalRotation, false, false, Effect.bTickEvenWhenPaused)
			else
				FxObject = self:PlayFX(Effect.FXAsset, MeshComponent, Effect.SocketName, LocalOffset, LocalRotation, false, false, Effect.bTickEvenWhenPaused)
			end

			if FxObject then
				local EffectId = tonumber(Effect.EffectId)
				local Scale = Effect.Scale
				local Owner = MeshComponent:GetOwner()
				if EffectId then
					if PlayerMeshComponent then
						Owner = PlayerMeshComponent:GetOwner()
					end
					local scales = {Scale.X, Scale.Y, Scale.Z}
					Battle(Owner):ApplyRangeModifyByEffectId(Owner, EffectId, scales)
					Scale = UE4.FVector(scales[1], scales[2], scales[3])
				end
				Scale = self:HandleScaleRate(MeshComponent, Scale, IsUseParentScale)
				FxObject:SetRelativeScale3D(Scale)
				FxObject:SetNiagaraVariableVec3("Scale", Scale)
				if Color then
					FxObject:SetVariableLinearColor("Color", Color)
					-- print(FxObject, Color)
				end
				local Character = Owner
				if PlayerMeshComponent then
					Character = PlayerMeshComponent:GetOwner()
				end
				if FxObject.SetQualityBias and Character.GetFXQualityBias then
					FxObject:SetQualityBias(Character:GetFXQualityBias())
					if Character:IsMainPlayer() then
						FxObject:SetLightingChannels(false, true, false)
					end
				end
				FxObject.CastShadow = true
				FxObject:SetExcludeFromLightAttachmentGroup(true)
			end

			if ManualStop and FxObject then
				if Effect.bDestroyAtEnd then
					FxObject.ComponentTags:Add(GroupName .. ".destroyatend")
				else
					FxObject.ComponentTags:Add(GroupName)
				end
			end
		end
	end

	Effects = self.TrailEffects:Find(GroupName)
	if Effects and Effects.Effects:Length() > 0 then
		Effects = Effects.Effects
		local Keys = Effects:Keys()
		for i = 1, Keys:Length() do
			local Key = Keys:GetRef(i)
			local Effect = Effects:Find(Key)
			-- print("GetRef Trail", Key, Effect.FXAsset)
			local FxObject = nil
			if SocketName == "" or SocketName == "None" then
				FxObject = self:PlayTrailFX(Effect.FXAsset, MeshComponent, Effect.FirstSocketName, Effect.SecondSocketName, Effect.WidthScaleMode, IsUseParentScale)
			else
				FxObject = self:PlayTrailFX(Effect.FXAsset, PlayerMeshComponent, SocketName, SecondSocketName, Effect.WidthScaleMode, IsUseParentScale)
			end
			if FxObject then
				FxObject.ComponentTags:Add(GroupName)
			end
		end
	end
	Effects = self.DecalEffects:Find(GroupName)
	if Effects and Effects.Effects:Length() > 0 then
		Effects = Effects.Effects
		local Keys = Effects:Keys()
		for i = 1, Keys:Length() do
			local Key = Keys:GetRef(i)
			local Effect = Effects:Find(Key)
			-- print("GetRef Decal", Key, Effect.DecalActorClass)
			if Effect.DecalActorClass then
				if Effect.bPlayByChar then
					MeshComponent = PlayerMeshComponent 
				end
				local DecalSize = Effect.DecalSize
				local EffectId = tonumber(Effect.EffectId)
				if EffectId then
					local Owner = MeshComponent:GetOwner()
					if PlayerMeshComponent then
						Owner = PlayerMeshComponent:GetOwner()
					end
					local scales = {Effect.DecalSize}
					Battle(Owner):ApplyRangeModifyByEffectId(Owner, EffectId, scales)
					DecalSize = scales[1]
				end
				local DecalActor = self:PlayFxDecalActor(Effect.DecalActorClass, MeshComponent, Effect.SocketName, Effect.LocalOffset, Effect.LocalRotation,
					false, DecalSize, Effect.SizeRandom, Effect.DecalRandomRotation, Effect.DecalTimeDelay, Effect.DecalLife, Effect.FadeScreenSize, Color, Effect.Material)
			end
		end
	end
	if AnimationName then
		if not self.FxAnimation[AnimationName] then
			self.FxAnimation[AnimationName] = {}
		end
		table.insert(self.FxAnimation[AnimationName], GroupName)
	end
end
]]--
-- function BP_FXComponent_C:StopGroupFX(MeshComponent, GroupName)
-- 	-- body
-- 	self:StopGroupFXInternal(MeshComponent, GroupName)
-- end
--[[
function BP_FXComponent_C:StopGroupFXInternal(MeshComponent, GroupName)
	--print("StopGroupFX", GroupName)
	local WeaponMesh = self:GetMeshComponent()
	self:StopTrailEffect(MeshComponent, GroupName)
	self:StopTrailEffect(WeaponMesh, GroupName)

	self:StopNiagaraEffect(MeshComponent, GroupName..".destroyatend", true)
	self:StopNiagaraEffect(WeaponMesh, GroupName..".destroyatend", true)

	self:StopNiagaraEffect(MeshComponent, GroupName, false)
	self:StopNiagaraEffect(WeaponMesh, GroupName, false)
	
end
]]--

-- function BP_FXComponent_C:PlayDecalGroupByHit(GroupName, GroupInfoTable)
-- 	local Effects = self.DecalEffects:Find(GroupName)
-- 	local CurrentWeapon = GroupInfoTable.CurrentWeapon
-- 	local Color = nil
-- 	local Character = CurrentWeapon:GetAttachParentActor()
-- 	if Character and Character.CharacterFashion then
-- 		local FXShow, FXQualityBias = Character:GetFXQualityBias()
-- 		if not FXShow then
-- 			return
-- 		end
-- 		Color = Character.CharacterFashion:GetEffectColor()
-- 	end
-- 	if not Effects or Effects.Effects:Length() <= 0 then 
-- 		print('No Effect!!!!!!!!!!')
-- 		return 
-- 	end
-- 	local DecalEffects = Effects.Effects
-- 	local Keys = DecalEffects:Keys()
-- 	for k, v in pairs(Keys) do
-- 		local Effect = DecalEffects:Find(v)
-- 		local EffectId = tonumber(Effect.EffectId)
-- 		if EffectId then
-- 			local Owner = self:GetMeshComponent():GetOwner()
-- 			local Scales = {Effect.DecalSize}
-- 			Battle(Owner):ApplyRangeModifyByEffectId(Owner, EffectId, Scales)
-- 		end
-- 		print(_G.LogTag, "GetRef Decal", v, Effect.DecalActorClass)
-- 		if Effect.bChangeColorByChar then
-- 			self:PlaySingleDecal(Effect, GroupInfoTable, Color)
-- 		else
-- 			self:PlaySingleDecal(Effect, GroupInfoTable, nil)
-- 		end
-- 	end
-- end

-- function BP_FXComponent_C:PlaySingleDecal(Effect, GroupInfoTable, Color)
-- 	if not UKismetSystemLibrary.IsValidSoftObjectReference(Effect.DecalActorClass) then 
-- 		return 
-- 	end
-- 	local Owner = self:GetOwner()
-- 	if IsAuthority(Owner) and not IsStandAlone(Owner) then
-- 		return
-- 	end
-- 	local HitPosition = GroupInfoTable.HitPosition
-- 	local Direction = GroupInfoTable.MoveDirection
-- 	local FinalPos = HitPosition + Direction * Effect.DecalSize.Z / 2
-- 	local Rot = GroupInfoTable.NormalVector:ToRotator()
-- 	local UpVecRot = FRotator(90 + Rot.Pitch, Rot.Yaw, 0)
-- 	local LocalMoveRot = UE4.UKismetMathLibrary.LessLess_VectorRotator(Direction, UpVecRot):ToRotator()
-- 	-- print('1111111111111111111111111111111111', LocalMoveRot)
-- 	local BornRot = FRotator(Rot.Pitch, Rot.Yaw, LocalMoveRot.Yaw)
-- 	BornRot:Normalize()
-- 	local BornTransform = UE4.UKismetMathLibrary.MakeTransform(FinalPos, BornRot, UE4.FVector(1,1,1))
-- 	local DecalActor = self:GetWorld():SpawnActor(UKismetSystemLibrary.LoadClassAsset_Blocking(Effect.DecalActorClass), BornTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, nil, nil, nil)
-- 	DecalActor:SetDecalMaterial(UKismetSystemLibrary.LoadAsset_Blocking(Effect.Material))
-- 	DecalActor.Decal.DecalSize = GroupInfoTable.DecalSize
-- 	DecalActor:K2_SetActorRotation(BornRot, false)
-- 	local MaterialInstanceDynamic = DecalActor:CreateDynamicMaterialInstance()
-- 	-- local MaterialInstanceDynamic = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self, Effect.Material)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("BP_DecalLife", Effect.DecalLife)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("BP_TimeDelay", UE4.UGameplayStatics.GetTimeSeconds(self) + Effect.DecalTimeDelay)
-- 	-- print('11111111111111111111111111111111111111111111111111',Effect.DecalTimeDelay, Effect.DecalLife)
-- 	if Color then
-- 		MaterialInstanceDynamic:SetVectorParameterValue("Color", Color)
-- 	end
-- 	-- print('33333333333333333333333333333333333333333333333333333333',FRotator(Rot.Pitch, Rot.Yaw, LocalMoveRot.Yaw))
-- 	-- local DecalObject = UE4.UGameplayStatics.SpawnDecalAtLocation(self, MaterialInstanceDynamic, GroupInfoTable.DecalSize, FinalPos, FRotator(Rot.Pitch, Rot.Yaw, LocalMoveRot.Yaw), Effect.DecalLife + Effect.DecalTimeDelay)
-- 	DecalActor.Decal:SetFadeScreenSize(Effect.FadeScreenSize)
-- 	if MiscUtils.IsTakeRecorderCapturing(self) then
-- 		DecalActor.BPMaterial=UKismetSystemLibrary.LoadAsset_Blocking(Effect.Material)
-- 		DecalActor.BPDecalLife=Effect.DecalLife
-- 		DecalActor.BPTimeDelay=Effect.DecalTimeDelay
-- 		if Color then
-- 		    DecalActor.BPColor=Color
-- 		end
-- 		DecalActor.IsTakeRecorderCaptured=true
-- 		local temp= URuntimeCommonFunctionLibrary.DuplicateActor(DecalActor)
-- 		DecalActor:K2_DestroyActor()
-- 		DecalActor=temp
-- 	end
-- 	local function f(self)  
-- 		DecalActor:K2_DestroyActor()
-- 	end
-- 	UE4.UKismetSystemLibrary.K2_SetTimerDelegate({DecalActor, f}, Effect.DecalTimeDelay + Effect.DecalLife, false, 0.0)
-- end

--[[
function BP_FXComponent_C:StopGroupFXForAnimation(AnimationName)
	-- body
	if self.FxAnimation[AnimationName] then
		for k, v in pairs(self.FxAnimation[AnimationName]) do
			self:StopGroupFX(nil, v)
		end

		self.FxAnimation[AnimationName] = {}
	end
end

function BP_FXComponent_C:StopAllGroupFX()
	if not self.FxAnimation then
		return
	end
	for AnimationName, FxData in pairs(self.FxAnimation) do
		for k, v in pairs(FxData) do
			self:StopGroupFX(nil, v)
		end
	end
	self.FxAnimation = {}
end
]]--
--function BP_FXComponent_C:PlayEffectByID(EffectID)
--	return self:PlayEffectByIDParams(EffectID, nil)
--end

function BP_FXComponent_C:PlayEffectByIDParams(EffectID, EffectParam)
	local PlayEffectParam = self:GetPlayEffectParams(EffectID)
	if EffectParam then
		if EffectParam.Location then
			if not EffectParam.UseAbsoluteLocation and not EffectParam.socket then
				PlayEffectParam.Location:Set(EffectParam.Location[1] + PlayEffectParam.Location.X, 
					EffectParam.Location[2] + PlayEffectParam.Location.Y, 
					EffectParam.Location[3] + PlayEffectParam.Location.Z)
			else
	    		PlayEffectParam.Location:Set(EffectParam.Location[1], EffectParam.Location[2], EffectParam.Location[3])
	    	end
	    end
	    if EffectParam.Rotation then
	    	if not EffectParam.UseAbsoluteLocation and not EffectParam.socket then
				PlayEffectParam.Rotation:Set(EffectParam.Rotation[2] + PlayEffectParam.Rotation.Pitch, 
					EffectParam.Rotation[3] + PlayEffectParam.Rotation.Yaw, 
					EffectParam.Rotation[1] + PlayEffectParam.Rotation.Roll)
			else
		    	PlayEffectParam.Rotation:Set(EffectParam.Rotation[2], EffectParam.Rotation[3], EffectParam.Rotation[1])
		    end
	    end
	    if EffectParam.RandomRotation then
	    	PlayEffectParam.Rotation:Set(EffectParam.RandomRotation[2] + PlayEffectParam.Rotation.Pitch, 
				EffectParam.RandomRotation[3] + PlayEffectParam.Rotation.Yaw, 
				EffectParam.RandomRotation[1] + PlayEffectParam.Rotation.Roll)
	    end
	    if EffectParam.scale then  
	    	PlayEffectParam.Scale:Set(EffectParam.scale[1], EffectParam.scale[2], EffectParam.scale[3])
	    end
	    local Attrs = {"UseAbsoluteLocation", "NotAttached", "AimSaveLoc", "AimFrom", "TargetEid", "IsUseParentScale", "FXSource", "SaveLocation"}
	    for k, v in pairs(Attrs) do
	    	if EffectParam[v] then PlayEffectParam[v] = EffectParam[v] end
		end
		if EffectParam.socket then
			PlayEffectParam.SocketName = EffectParam.socket
		end
		if EffectParam.Component then
			PlayEffectParam.Component = EffectParam.Component
		end
		if EffectParam.bTickEvenWhenPaused then
			PlayEffectParam.bTickEvenWhenPaused = EffectParam.bTickEvenWhenPaused
		end
		if EffectParam.AttachLocation then
			PlayEffectParam.AttachRule = EffectParam.AttachLocation
		end
	end
	-- 这段逻辑得放在PlayEffectByIDInternal里，不然C++调用播放特效不会走播声音的逻辑
	-- local VisualEffect = DataMgr.VisualEffect[EffectID]
	-- local AllowPlayAudio = true
	-- if VisualEffect and VisualEffect.AllowRefreshAudio and PlayEffectParam.Life > 0 then
	-- 	local Tag
	-- 	if PlayEffectParam.TargetEid > 0 then
	-- 		Tag = EffectID.."."..PlayEffectParam.TargetEid
	-- 	else
	-- 		Tag = tostring(EffectID)
	-- 	end
	-- 	if self:GetFxObjectByTag(Tag) then
	-- 		AllowPlayAudio = false
	-- 	end
	-- end
	local FxObject = self:PlayEffectByIDInternal(EffectID, PlayEffectParam)
	-- if AllowPlayAudio then
	-- 	if FxObject then
	-- 		AudioManager(self):PlayFMODSoundByID(FxObject, PlayEffectParam.SoundID, self:GetOwner(), PlayEffectParam.SocketName)
	-- 	else
	-- 		AudioManager(self):PlayFMODSoundByID(self:GetOwner(), PlayEffectParam.SoundID, self:GetOwner(), "")
	-- 	end
	-- end
	return FxObject
end
--[[
function BP_FXComponent_C:PlayEffectByIDInternal(EffectID, InEffectParam)
	-- body
	local Tag = tostring(EffectID)
	if InEffectParam.TargetEid > 0 then
		Tag = Tag .. "." .. tostring(InEffectParam.TargetEid)
	end
	local EffectData = DataMgr.VisualEffect[EffectID]
	if EffectData == nil then
		print("EffectID", EffectID, "not exist!!!")
		return
	end

	-- Skill Targets
	if EffectData.SkillEffectId ~= nil and InEffectParam.TargetEid > 0 then
		self:PlayEffectWithTargets(EffectID, InEffectParam)
		return
	end

	local EffectPath = EffectData.EffectPath
	local PlayLocation = EffectData.PlayLocation or {}
	local EffectParam = EffectData.EffectParam or {}
	local TargetLocation = EffectData.TargetLocation
	local NotFollowRotation = EffectData.NotFollowRotation
	local SoundID = EffectData.SoundID

	if InEffectParam.SoundID > 0 then
		SoundID = InEffectParam.SoundID
	end
	if InEffectParam.Life > 0 then
		if InEffectParam.LerpTime > 0 and InEffectParam.AimSaveLoc then
			local FxObject = self:UpdateEffectTimerWithLocation(Tag, InEffectParam.LerpTime, InEffectParam.SaveLocation)
			if FxObject then
				return
			end
		else
			local FxObject = self:UpdateEffectTimer(Tag)
			if FxObject then
				if InEffectParam.AimSaveLoc then
					FxObject:SetNiagaraVariableVec3("TargetLocation", InEffectParam.SaveLocation)
				end
				if InEffectParam.AimFrom then
					FxObject:K2_SetWorldLocation(InEffectParam.SaveLocation ,false,nil,false)
				end
				return
			end
		end
	end

	local MeshComponent = InEffectParam.Component
	if PlayLocation.UseWeaponBone then
		local Owner = self:GetOwner()
		if Owner:IsCharacter() then
			if Owner.GetCurrentWeapon and Owner:GetCurrentWeapon() then
				if PlayLocation.UseWeaponBone == "main" then
					MeshComponent = Owner:GetCurrentWeapon().WeaponMesh
				elseif PlayLocation.UseWeaponBone == "child" then
					local ChildWeapon = Owner:GetCurrentWeapon().ChildWeapon
					if ChildWeapon then
						MeshComponent = ChildWeapon.WeaponMesh
					end
				end
			end
		end
		if not MeshComponent then
			return
		end  
	end
	local Color = nil
	if EffectData.EffectColor then
		Color = UE4.FLinearColor(EffectData.EffectColor[1], EffectData.EffectColor[2], EffectData.EffectColor[3], EffectData.EffectColor[4])
	elseif EffectData.ChangeColorByWeapon then
		local Owner = self:GetOwner()
		Owner = Owner:GetRootSource()
		if Owner.GetCurrentWeapon and Owner:GetCurrentWeapon() then
			local CurrentWeapon = Owner:GetCurrentWeapon()
			Color = CurrentWeapon.WeaponFashion:GetEffectColor()
		end
	elseif EffectData.ChangeColorByChar then
		local Owner = self:GetOwner()
		if InEffectParam.FXSource then
			Owner = InEffectParam.FXSource
		end
		Owner = Owner:GetRootSource()
		if Owner.CharacterFashion then
			Color = Owner.CharacterFashion:GetEffectColor()
			if Color and (Color.A == 0 or (Color.R == 0 and Color.G == 0 and Color.B == 0)) then
				Color = nil
			end
			-- print("Color", Color, Owner.Object)
		end
	end
	if EffectPath ~= nil then
		local FXPath = EffectPath
		local FXAsset = LoadObject(FXPath)
		assert(FXAsset, "特效资源找不到资产:"..tostring(FXPath))
		local Location = UE4.FVector(0, 0, 0)
		local Rotation = UE4.FRotator(0, 0, 0)

		local bLocationOffset = false
		if EffectParam.BodyShapeOffset then
			local Owner = self:GetOwner()
			if Owner.BodyShapeOffset then
				for i = 1, #EffectParam.BodyShapeOffset do
					if Owner:CheckBattleCharTag(EffectParam.BodyShapeOffset[i].BattleCharTag) then
						Location = UE4.FVector(EffectParam.BodyShapeOffset[i].Location[1], EffectParam.BodyShapeOffset[i].Location[2], EffectParam.BodyShapeOffset[i].Location[3])
						bLocationOffset = true
						break
					end
				end
			end
		end
		if not bLocationOffset then
			Location = InEffectParam.Location
		end
		if not NotFollowRotation or EffectParam.ForceSetRotation then  
			Rotation = InEffectParam.Rotation
		end
		local SocketName = InEffectParam.SocketName
		local FxObject = nil
		if InEffectParam.NotAttached and not InEffectParam.UseAbsoluteLocation then
			MeshComponent = self:GetRealMesh(MeshComponent)
			if PlayLocation.Saveloc then
				Location = InEffectParam.SaveLocation
			elseif MeshComponent and SocketName then
				local LocalTransform = UE4.UKismetMathLibrary.MakeTransform(Location, Rotation, UE4.FVector(1, 1, 1))
				local Transform = MeshComponent:GetSocketTransform(SocketName, UE4.ERelativeTransformSpace.RTS_World)
				local FinalTransform = LocalTransform*Transform
				Location = FinalTransform.Translation
				Rotation = FinalTransform.Rotation:ToRotator()
			elseif not EffectParam.FixLocOnTarget then
				Location = self:GetOwner():K2_GetActorLocation() + Location
			end
		elseif not InEffectParam.NotAttached and PlayLocation.Saveloc then
			MeshComponent = self:GetRealMesh(MeshComponent)
			local WorldTransform = UE4.UKismetMathLibrary.MakeTransform(InEffectParam.SaveLocation, UE4.FRotator(0, 0, 0), UE4.FVector(1, 1, 1))
			local LocalTransform = MeshComponent:GetSocketTransform(SocketName, UE4.ERelativeTransformSpace.RTS_World)
			local RelativeTransform = UE4.UKismetMathLibrary.MakeRelativeTransform(WorldTransform, LocalTransform)
			Location = RelativeTransform.Translation  
			Rotation = RelativeTransform.Rotation:ToRotator()
		end
		-- Decal Material
		if UE4.UKismetMathLibrary.ClassIsChildOf(FXAsset:GetClass(), UMaterialInstance:StaticClass()) then
			local ShapeType = EffectParam.Type
			if not ShapeType then
				local Angle = EffectParam.Angle or 0
				local Radius = EffectParam.Radius or 100
				local Duration = EffectParam.Duration or 10
				FxObject = self:PlayFxDecal(FXAsset, Radius, Angle, Duration, Location, Rotation)
			elseif ShapeType == 0 then
				local Angle = EffectParam.Angle or 0
				local OutsideRadius = EffectParam.OutsideRadius or 100
				local InnerRadius = EffectParam.InnerRadius or 0
				local Time = EffectParam.Time or 10
				local ColorIndex = EffectParam.ColorIndex or 0
				local VisualRotation
				if EffectParam.Rotation then
					VisualRotation = UE4.FRotator(EffectParam.Rotation[2], EffectParam.Rotation[3], EffectParam.Rotation[1])
				end
				FxObject = self:PlayCircleFxDecal(FXAsset, OutsideRadius, InnerRadius, Angle, Time, Location, VisualRotation, ColorIndex, true, not InEffectParam.NotAttached)
			elseif ShapeType == 1 or ShapeType == 2 then
				local X = EffectParam.X or 100
				local Y = EffectParam.Y or 100
				local Type = EffectParam.Type or 1
				local Time = EffectParam.Time or 10
				local ColorIndex = EffectParam.ColorIndex or 0
				local VisualRotation
				if EffectParam.Rotation then
					VisualRotation = UE4.FRotator(EffectParam.Rotation[2], EffectParam.Rotation[3], EffectParam.Rotation[1])
				end
				FxObject = self:PlayRectangleFxDecal(FXAsset, X, Y, Type, Time, Location, VisualRotation, ColorIndex, true, not InEffectParam.NotAttached)
			end
		-- Decal Actor
		elseif UE4.UKismetMathLibrary.ClassIsChildOf(FXAsset:GetClass(), UBlueprint:StaticClass()) then
			local DecalActorClass = LoadClass(FXPath)
			FxObject = self:PlayFxDecalActor(DecalActorClass, nil, SocketName, Location, Rotation, EffectParam.OnGround,
				EffectParam.DecalSize, EffectParam.SizeRandom, EffectParam.DecalRandomRotation, EffectParam.DecalTimeDelay,
				EffectParam.DecalLife, EffectParam.FadeScreenSize, Color)

		-- Niagara System
		else
			FxObject = self:PlayFX(FXAsset, MeshComponent, SocketName, Location, Rotation, 
				InEffectParam.UseAbsoluteLocation or InEffectParam.NotAttached, 
				InEffectParam.FollowRootMotion, InEffectParam.bTickEvenWhenPaused)
			if FxObject ~= nil then
				if InEffectParam.Scale ~= nil then
					local Scale = InEffectParam.Scale
					Scale = self:HandleScaleRate(MeshComponent, Scale, InEffectParam.IsUseParentScale)
					FxObject:SetRelativeScale3D(Scale)
					if UE4.UKismetMathLibrary.EqualEqual_ClassClass(FXAsset:GetClass(), UNiagaraSystem:StaticClass()) then
						FxObject:SetNiagaraVariableVec3("Scale", Scale)
					end
				else
					local Scale = self:HandleScaleRate(MeshComponent, nil, InEffectParam.IsUseParentScale)
					if Scale then
						FxObject:SetRelativeScale3D(Scale)
					end
				end
				
				if TargetLocation ~= nil and TargetLocation.socket ~= nil then
					self:AddTarget(TargetLocation.socket, FxObject, InEffectParam.TargetEid)
				end
				if NotFollowRotation then
					FxObject:SetAbsolute(false, true, false)  
				end
				if Color then
					FxObject:SetVariableLinearColor("Color", Color)
				end
				if InEffectParam.skeletalmesh then
					FxObject:SetVariableObject("SkeletalMesh",self:GetOwner().Mesh)
				end
				if (not InEffectParam.UseAbsoluteLocation and not InEffectParam.NotAttached) or InEffectParam.AimFrom then
					local DelayDeactiveTime = EffectData.DelayDeactiveTime or 0
					local DeactiveParam = UE4.EDeactiveMethod[EffectData.DeactiveParam] or 0
					if DeactiveParam < 0 then DeactiveParam = 0 end
					if InEffectParam.LerpTime and InEffectParam.AimSaveLoc then
						self:AddEffectTimer(Tag, FxObject, InEffectParam.Life, InEffectParam.SaveLocation, DelayDeactiveTime, EffectData.DestroyWhenSkillEnds, DeactiveParam)
					else
						self:AddEffectTimer(Tag, FxObject, InEffectParam.Life, FVector(0, 0, 0), DelayDeactiveTime, EffectData.DestroyWhenSkillEnds, DeactiveParam)
					end
				end
				if InEffectParam.Life > 0 then
					FxObject:SetNiagaraVariableFloat("Life", InEffectParam.Life)
				end
				if InEffectParam.AimSaveLoc then
					FxObject:SetNiagaraVariableVec3("TargetLocation", InEffectParam.SaveLocation)
				end
				if not EffectData.NotCastShadow then
					FxObject.CastShadow = true
					FxObject:SetExcludeFromLightAttachmentGroup(true)
				end
				local Character = self:GetOwner()
				if Character.GetRootSource then
					Character = Character:GetRootSource()
				end
				if FxObject.SetQualityBias and Character.GetFXQualityBias then
					FxObject:SetQualityBias(Character:GetFXQualityBias())
					if Character:IsMainPlayer() then
						FxObject:SetLightingChannels(false, true, false)
					end
				end
			end
		end
		return FxObject
	end
	AudioManager(self):PlayFMODSoundByID(self:GetOwner(), SoundID, self:GetOwner(), "")
end
]]
-- function BP_FXComponent_C:StopEffectByID(EffectID, bForceDestory, StopEffectNum)
-- 	-- body
-- 	local ForceDestory = false
-- 	if bForceDestory ~= nil then
-- 		ForceDestory = bForceDestory 
-- 	else
-- 		local EffectData = DataMgr.VisualEffect[EffectID] or {}  
-- 		ForceDestory = EffectData.DelayDeactiveTime == nil or EffectData.DelayDeactiveTime <= 0
-- 	end
-- 	if StopEffectNum then
-- 		StopEffectNum = math.floor(StopEffectNum)
-- 	end
-- 	self:StopFxObjectWithTag(tostring(EffectID), ForceDestory, StopEffectNum)
-- end

-- function BP_FXComponent_C:StopAllEffects(bForceDestory)
-- 	-- body
-- 	local ForceDestory = false
-- 	if bForceDestory then
-- 		ForceDestory = true 
-- 	end
-- 	self:StopAllFxObjects(ForceDestory)
-- end

-- function BP_FXComponent_C:PlayFxDecal(MaterialInstance, Radius, Angle, Duration, Location, Rotation, OnGround)
-- 	-- body
-- 	local Owner = self:GetOwner()
-- 	local DecalActor = self:GetWorld():SpawnActor(LoadClass('/Game/Asset/Effect/Blueprint/BP_DecalActor.BP_DecalActor'), Owner:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, Owner, Owner, nil)
-- 	if IsAuthority(Owner) and not IsStandAlone(Owner) then
-- 		return DecalActor
-- 	end
-- 	DecalActor:SetDecalMaterial(MaterialInstance)
-- 	DecalActor.Decal.DecalSize = UE4.FVector(256.0, Radius * 20.1, Radius * 20.1)
-- 	-- DecalActor:K2_AttachToActor(Owner, "", UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, false)
-- 	Location = self:GetDecalActorLocation(Location, OnGround)
-- 	DecalActor:K2_SetActorLocation(Location, false, nil, true)
-- 	DecalActor:K2_SetActorRotation(Rotation, false, nil, true)
-- 	local MaterialInstanceDynamic = DecalActor:CreateDynamicMaterialInstance()
-- 	MaterialInstanceDynamic:SetScalarParameterValue("Angle", Angle)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("Radius", Radius)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("readiness time", Duration)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("starttime", UE4.UGameplayStatics.GetTimeSeconds(self))
-- 	if MiscUtils.IsTakeRecorderCapturing(self) then
-- 		DecalActor.BPMaterial = MaterialInstance
-- 		DecalActor.DecalType = 1
-- 		DecalActor.BPAngel = Angle
-- 		DecalActor.BPRadius = Radius
-- 		DecalActor.BPDuration = Duration
-- 		DecalActor.IsTakeRecorderCaptured = true
-- 		local temp = URuntimeCommonFunctionLibrary.DuplicateActor(DecalActor)
-- 		DecalActor:K2_DestroyActor()
-- 		DecalActor = temp
-- 	end  
-- 	local function f()
-- 		DecalActor:K2_DestroyActor()
-- 	end
-- 	UE4.UKismetSystemLibrary.K2_SetTimerDelegate({DecalActor, f}, Duration, false, 0.0)
-- 	DecalActor:RefreshOwner(Owner)
-- 	return DecalActor
-- end

-- function BP_FXComponent_C:InitDecal(Owner, DecalActor, Time, IsAttach, AttachedNotFollow)
-- 	local function DestroySelf()
-- 		if AttachedNotFollow then
-- 			Owner.HideDecalActors:RemoveItem(DecalActor)
-- 		end
-- 		DecalActor:K2_DestroyActor()
-- 	end
-- 	UE4.UKismetSystemLibrary.K2_SetTimerDelegate({DecalActor, DestroySelf}, Time, false, 0.0)
-- 	if IsAttach then
-- 		DecalActor:K2_AttachToActor(Owner, "", UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld, false)
-- 	end
-- 	if AttachedNotFollow then
-- 		Owner.HideDecalActors:Add(DecalActor)
-- 		if Owner.bHidden then
-- 			DecalActor:SetActorHiddenInGame(true)
-- 		end
-- 	end
-- 	DecalActor:RefreshOwner(Owner)
-- end

-- function BP_FXComponent_C:PlayRectangleFxDecal(MaterialInstance, X, Y, Type, Time, Location, Rotation, ColorIndex, OnGround, IsAttach, AttachedNotFollow)
-- 	-- body
-- 	local Owner = self:GetOwner()
-- 	local DecalActor = self:GetWorld():SpawnActor(LoadClass('/Game/Asset/Effect/Blueprint/BP_DecalActor.BP_DecalActor'), Owner:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, Owner, Owner, nil)
-- 	if IsAuthority(Owner) and not IsStandAlone(Owner) then
-- 		return DecalActor
-- 	end
-- 	DecalActor:SetDecalMaterial(MaterialInstance)
-- 	DecalActor.Decal.DecalSize = UE4.FVector(80, X * 1.1, Y * 1.1)
-- 	-- DecalActor:K2_AttachToActor(Owner, "", UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, false)
-- 	Location = self:GetDecalActorLocation(Location, OnGround)
-- 	DecalActor:K2_SetActorLocation(Location, false, nil, true)
-- 	DecalActor:K2_SetActorRotation(FRotator(-90, 0, 0), false, nil, false)
-- 	local MaterialInstanceDynamic = DecalActor:CreateDynamicMaterialInstance()
-- 	MaterialInstanceDynamic:SetScalarParameterValue("X", X)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("Y", Y)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("ColorIndex", ColorIndex)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("Time", Time - 0.15)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("Type", Type)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("StartTime", UE4.UGameplayStatics.GetTimeSeconds(self))
-- 	Rotation = Rotation or FRotator(0, 0, 0)
-- 	local OwnerTransform = Owner:GetTransform()
-- 	local NewRotation = UE4.UKismetMathLibrary.TransformRotation(OwnerTransform, Rotation)
-- 	local NewForwardVector = NewRotation:GetForwardVector()
-- 	MaterialInstanceDynamic:SetVectorParameterValue("ForwardVector", UE4.FLinearColor(-NewForwardVector.X, NewForwardVector.Y, NewForwardVector.Z, 1))
-- 	self:InitDecal(Owner, DecalActor, Time, IsAttach, AttachedNotFollow)
-- 	return DecalActor
-- end

function BP_FXComponent_C:GetPlayCircleFxDecalCNParamName(OutInnterRadiusName, OutOutsideRadiusName, OutAngelName)
	-- body
	return "内径", "外径", "角度"
	-- OutOutsideRadiusName = 
	-- OutAngelName = 
end

-- function BP_FXComponent_C:PlayCircleFxDecal(MaterialInstance, OutsideRadius, InnerRadius, Angle, Time, Location, Rotation, ColorIndex, OnGround, IsAttach, AttachedNotFollow)
-- 	-- body
-- 	local Owner = self:GetOwner()
-- 	local DecalActor = self:GetWorld():SpawnActor(LoadClass('/Game/Asset/Effect/Blueprint/BP_DecalActor.BP_DecalActor'), Owner:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, Owner, Owner, nil)
-- 	if IsAuthority(Owner) and not IsStandAlone(Owner) then
-- 		return DecalActor
-- 	end
-- 	DecalActor:SetDecalMaterial(MaterialInstance)
-- 	DecalActor.Decal.DecalSize = UE4.FVector(80, OutsideRadius * 1.1, OutsideRadius * 1.1)
-- 	Location = self:GetDecalActorLocation(Location, OnGround)
-- 	DecalActor:K2_SetActorLocation(Location, false, nil, true)
-- 	DecalActor:K2_SetActorRotation(FRotator(-90, 0, 0), false, nil, false)
-- 	local MaterialInstanceDynamic = DecalActor:CreateDynamicMaterialInstance()
-- 	MaterialInstanceDynamic:SetScalarParameterValue("内径", InnerRadius)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("外径", OutsideRadius)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("角度", Angle)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("ColorIndex", ColorIndex)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("Time", Time - 0.15)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("Type", 0)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("StartTime", UE4.UGameplayStatics.GetTimeSeconds(self))
-- 	Rotation = Rotation or FRotator(0, 0, 0)
-- 	local OwnerTransform = Owner:GetTransform()
-- 	local NewRotation = UE4.UKismetMathLibrary.TransformRotation(OwnerTransform, Rotation)
-- 	local NewForwardVector = NewRotation:GetForwardVector()
-- 	MaterialInstanceDynamic:SetVectorParameterValue("ForwardVector", UE4.FLinearColor(-NewForwardVector.X, NewForwardVector.Y, NewForwardVector.Z, 1))
-- 	self:InitDecal(Owner, DecalActor, Time, IsAttach, AttachedNotFollow)
-- 	return DecalActor
-- end

-- function BP_FXComponent_C:PlayCrossFxDecal(MaterialInstance, CrossLength, CrossWidth, Time, Location, Rotation, ColorIndex, OnGround, IsAttach, AttachedNotFollow)
-- 	local Owner = self:GetOwner()
-- 	local DecalActor = self:GetWorld():SpawnActor(LoadClass('/Game/Asset/Effect/Blueprint/BP_DecalActor.BP_DecalActor'), Owner:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, Owner, Owner, nil)
-- 	if IsAuthority(Owner) and not IsStandAlone(Owner) then
-- 		return DecalActor
-- 	end
-- 	DecalActor:SetDecalMaterial(MaterialInstance)
-- 	local MaxSize = math.max(CrossLength, CrossWidth)
-- 	DecalActor.Decal.DecalSize = UE4.FVector(80, MaxSize * 1.1, MaxSize * 1.1)
-- 	Location = self:GetDecalActorLocation(Location, OnGround)
-- 	DecalActor:K2_SetActorLocation(Location, false, nil, true)
-- 	DecalActor:K2_SetActorRotation(FRotator(-90, 0, 0), false, nil, false)
-- 	local MaterialInstanceDynamic = DecalActor:CreateDynamicMaterialInstance()
-- 	MaterialInstanceDynamic:SetScalarParameterValue("CrossLength", CrossLength)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("CrossWidth", CrossWidth)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("ColorIndex", ColorIndex)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("Time", Time - 0.15)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("Type", 3)
-- 	MaterialInstanceDynamic:SetScalarParameterValue("StartTime", UE4.UGameplayStatics.GetTimeSeconds(self))
-- 	Rotation = Rotation or FRotator(0, 0, 0)
-- 	local OwnerTransform = Owner:GetTransform()
-- 	local NewRotation = UE4.UKismetMathLibrary.TransformRotation(OwnerTransform, Rotation)
-- 	local NewForwardVector = NewRotation:GetForwardVector()
-- 	MaterialInstanceDynamic:SetVectorParameterValue("ForwardVector", UE4.FLinearColor(-NewForwardVector.X, NewForwardVector.Y, NewForwardVector.Z, 1))
-- 	self:InitDecal(Owner, DecalActor, Time, IsAttach, AttachedNotFollow)
-- 	return DecalActor
-- end

-- function BP_FXComponent_C:PlayFxDecalByID(EffectID, Location, OnGround, AttachedNotFollow)
-- 	-- body
-- 	local EffectData = DataMgr.VisualEffect[EffectID]
-- 	if EffectData == nil then
-- 		print("EffectID", EffectID, "not exist!!!")
-- 		return
-- 	end

-- 	local EffectPath = EffectData.EffectPath
-- 	local EffectParam = EffectData.EffectParam or {}
-- 	local Owner = self:GetOwner()
-- 	if EffectPath ~= nil then
-- 		local Rotation = EffectParam.Rotation or {0, 0, 0}
-- 		Rotation = FRotator(Rotation[2], Rotation[3], Rotation[1])
-- 		local Angle = EffectParam.Angle or 0
-- 		local LocOffset = EffectParam.Location and FVector(EffectParam.Location[1], EffectParam.Location[2], EffectParam.Location[3]) or FVector(0, 0, 0)
-- 		local MaterialInstance = LoadObject(EffectPath)
-- 		if UE4.UKismetMathLibrary.Vector_IsZero(Location) then
-- 			Location = UE4.UKismetMathLibrary.TransformLocation(Owner:GetTransform(), LocOffset)
-- 		end
-- 		local OutsideRadius = EffectParam.OutsideRadius or 100
-- 		local InnerRadius = EffectParam.InnerRadius or 0
-- 		local Time = EffectParam.Time or 10
-- 		local ColorIndex = EffectParam.ColorIndex or 0
-- 		local IsAttach = EffectParam.IsAttach
-- 		return self:PlayCircleFxDecal(MaterialInstance, OutsideRadius, InnerRadius, Angle, Time, Location, Rotation, ColorIndex, OnGround, IsAttach, AttachedNotFollow)
-- 	end
-- end

-- function BP_FXComponent_C:ApplySkillScaleByEffectId(FxObject, EffectId, Scale)
-- 	if FxObject then
-- 		local Owner = self:GetOwner()
-- 		local scales = {Scale.X, Scale.Y, Scale.Z}
-- 		scales = Battle(Owner):ApplyRangeModifyByEffectId(Owner, EffectId, scales)
-- 		Scale = UE4.FVector(scales[1], scales[2], scales[3])
-- 		FxObject:SetRelativeScale3D(Scale)
-- 		FxObject:SetNiagaraVariableVec3("Scale", Scale)
-- 	end
-- end

-- function BP_FXComponent_C:PlayFxDecalActor(DecalActorClass, MeshComp, SocketName, LocalOffset, LocalRotation, OnGround,
-- 											DecalSize, SizeRandom, DecalRandomRotation, DecalTimeDelay, DecalLife, FadeScreenSize, Color, Material)
-- 	-- body
-- 	local Mesh = MeshComp
-- 	if Mesh == nil then
-- 		Mesh = self:GetMeshComponent()
-- 	end
-- 	if Mesh == nil then
-- 		return nil
-- 	end
-- 	local Owner = self:GetOwner()
-- 	local DecalActor = self:GetWorld():SpawnActor(UKismetSystemLibrary.LoadClassAsset_Blocking(DecalActorClass), Owner:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, Owner, Owner, nil)
-- 	local LocalTransform = UE4.UKismetMathLibrary.MakeTransform(LocalOffset, LocalRotation, UE4.FVector(1,1,1))
-- 	local Transform = Mesh:GetSocketTransform(SocketName, UE4.ERelativeTransformSpace.RTS_World)
-- 	local RelativeTransform = LocalTransform * Transform
-- 	local Location = RelativeTransform.Translation
-- 	local Rotation = RelativeTransform.Rotation:ToRotator()
-- 	Location = self:GetDecalActorLocation(Location, OnGround)
-- 	DecalActor:K2_SetActorLocation(Location, false, nil, true)
-- 	DecalActor:K2_SetActorRotation(Rotation, false, nil, true)
-- 	if DecalSize then DecalActor.DecalSize = DecalSize end
-- 	if SizeRandom then DecalActor.SizeRandom = SizeRandom end
-- 	if DecalRandomRotation then DecalActor.DecalRandomRotation = DecalRandomRotation end
-- 	if DecalTimeDelay then DecalActor.DecalTimeDelay = DecalTimeDelay end
-- 	if DecalLife then DecalActor.DecalLife = DecalLife end
-- 	if FadeScreenSize then DecalActor.FadeScreenSize = FadeScreenSize end
-- 	if Color then DecalActor.Color = Color end
-- 	if DecalActor then
-- 		if Material then
-- 			DecalActor["Decal Material"] = Material
-- 		end
					
-- 		DecalActor:PlayDecal()
-- 		if MiscUtils.IsTakeRecorderCapturing(self) then
-- 			DecalActor.IsTakeRecorderCaptured=true
-- 			URuntimeCommonFunctionLibrary.DuplicateActor(DecalActor)
-- 		end
-- 	end
-- 	return DecalActor
-- end
--[[
function BP_FXComponent_C:PlayEffectWithTargets(EffectID, InEffectParam)
	-- body
	local Owner = self:GetOwner()
	local EffectData = DataMgr.VisualEffect[EffectID]
	local EffectInfo = DataMgr.SkillEffects[EffectData.SkillEffectId]
	local Battle = Battle(Owner)
	local TargetEids = Battle:DoTargetFilter(Owner, nil, EffectInfo.TargetFilter, EffectInfo.AllowSkillRangeModify, EffectInfo.AttackRangeType)
	local Index = 0
	local Length = TargetEids:Length()  
	while (Index < Length) do
		Index = Index + 1
		local Eid = TargetEids:GetRef(Index)
		if Eid then
			InEffectParam.TargetEid = Eid
			self:PlayEffectByIDInternal(EffectID, InEffectParam)
		end
	end
end
]]
-- function BP_FXComponent_C:GetDecalActorLocation(Location, OnGround)
-- 	-- body
-- 	if OnGround then
-- 		local HitResult = FHitResult()
-- 		local Hit = UE4.UKismetSystemLibrary.LineTraceSingle(self, Location, FVector(Location.X, Location.Y, Location.Z - Const.DecalHeight), ETraceTypeQuery.TraceScene, false, nil, 0, HitResult, true)
--         if Hit then
--             local Offset = math.abs(HitResult.ImpactPoint.Z - HitResult.TraceStart.Z) - 2.0
--              --print(Offset)
--              Location = FVector(Location.X, Location.Y, Location.Z - Offset)
--         end
-- 	end
-- 	return Location
-- end

-- function BP_FXComponent_C:GetDecalHeight()
-- 	return Const.DecalHeight
-- end

return BP_FXComponent_C
