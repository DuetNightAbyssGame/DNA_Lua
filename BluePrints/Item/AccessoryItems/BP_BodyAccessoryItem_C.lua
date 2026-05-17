--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_BodyAccessoryItem_C
local BP_BodyAccessoryItem_C = Class({
	"BluePrints.Common.TimerMgr",
})

-- function BP_BodyAccessoryItem_C:Initialize(Initializer)
-- 	-- self.HideTags = {}
-- end

--function BP_BodyAccessoryItem_C:UserConstructionScript()
--end

-- function BP_BodyAccessoryItem_C:InitAccessoryInfo_Lua(AccessoryId)
-- 	self.AccessoryId = AccessoryId
-- 	self.Data = DataMgr.BodyAccessory[AccessoryId]
-- 	local MeshRes = self.Data.ModelPath
-- 	local Mesh = LoadObject(MeshRes)
-- 	--self:SetMesh(Mesh)
-- 	self:SetMesh_CPP(Mesh)
-- 	if self.Data.AnimPath and self.Data.AnimNames and self.AccessoryAnims:Num() == 0 then
-- 		if self.Mesh:Cast(USkeletalMeshComponent) then
-- 			for i = 1, #self.Data.AnimNames do
-- 				local Anim = LoadObject(self.Data.AnimPath .. self.Data.AnimNames[i])
-- 				self.AccessoryAnims:Add(Anim)
-- 			end
-- 		end
-- 	end

-- 	-- -- 初始化时跟随Owner的HideTag
-- 	-- if self.Owner.HideTags and not IsEmptyTable(self.Owner.HideTags) then
-- 	-- 	for key, val in pairs(self.Owner.HideTags) do
-- 	-- 		if val == 1 then
-- 	-- 			self:SetActorHideTag(key, true)
-- 	-- 		end
-- 	-- 	end
-- 	-- end
-- end

-- function BP_BodyAccessoryItem_C:ReceiveBeginPlay()
-- 	self.Overridden.ReceiveBeginPlay(self)

-- 	self:K2_GetRootComponent():SetIsReplicated(true)
-- end

--function BP_BodyAccessoryItem_C:ReceiveEndPlay()
--end

-- function BP_BodyAccessoryItem_C:_InverseAccessoryPosition(SocketName)
-- 	-- PrintTable({_InverseWeaponPosition=SocketName})
-- 	local Scale = self:GetActorScale3D()
-- 	---@type FTransform
-- 	local Transform = self.Mesh:GetSocketTransform(SocketName, UE4.ERelativeTransformSpace.RTS_Component)
-- 	local InverseTransform = Transform:Inverse()
-- 	self.Mesh:K2_SetRelativeTransform(InverseTransform, false, nil, true)
-- 	self:SetActorScale3D(Scale)
-- end

-- function BP_BodyAccessoryItem_C:Bind_Lua()
-- 	if not rawget(self, "Data") then
-- 		return
-- 	end
-- 	self:Bind_CPP(self.AccessoryId)
-- 	self:ClearDissolve()
-- 	-- 初始化时跟随Owner的HideTag
-- 	if self.Owner.HideTags and not IsEmptyTable(self.Owner.HideTags) then
-- 		for key, val in pairs(self.Owner.HideTags) do
-- 			if val == 1 then
-- 				self:SetActorHideTag(key, true)
-- 			end
-- 		end
-- 	end
-- 	-- local AttachRule = self.Data.AttachRule
-- 	-- self.AttachSocket = AttachRule["SocketB"]
-- 	-- self.InverseSocket = AttachRule["SocketA"]
-- 	-- self:K2_AttachToComponent(self:GetOwner().Mesh, self.AttachSocket, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.KeepWorld)
-- 	-- self:_InverseAccessoryPosition(self.InverseSocket)
-- end

-- function BP_BodyAccessoryItem_C:ReceiveTick(DeltaSeconds)
-- 	if not rawget(self, "MarkDroped") then
-- 		return
-- 	end
-- 	local Radius = URuntimeCommonFunctionLibrary.GetSceneComponentBoundsRadius(self.Mesh) + 10
-- 	local Start = self.Mesh:K2_GetComponentLocation()
-- 	local HitResult = TArray(AActor)
-- 	local ObjectTypes = TArray(EObjectTypeQuery)
	-- ObjectTypes:Add(EObjectTypeQuery.WorldStatic)
-- 	if UKismetSystemLibrary.SphereOverlapActors(self, Start, Radius, ObjectTypes, nil, nil, HitResult) then
-- 		self:OnLand()
-- 	end

-- end

--function BP_BodyAccessoryItem_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_BodyAccessoryItem_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_BodyAccessoryItem_C:ReceiveActorEndOverlap(OtherActor)
--end

-- function BP_BodyAccessoryItem_C:OnLand()
-- 	if IsStandAlone(self) or IsClient(self) then
-- 		self.FXComponent:PlayEffectByID(self.Data.LandEffectId)
-- 	end
-- 	self:SetActorTickEnabled(false)
-- end

-- function BP_BodyAccessoryItem_C:Destroy(DirectIndex, HitType)
-- 	if not self.Data.Speed then
-- 		self:EMActorDestroy()
-- 		return
-- 	end

-- 	if self.PlayBodyAccessoryEffect then
-- 		self:DestroyMulticast(DirectIndex, HitType)
-- 	else
-- 		self:AddTimer(self.Data.DelayDestroyTime, self.SimpleDestroyMulticast)
-- 	end
-- end

-- function BP_BodyAccessoryItem_C:DestroyMulticast_Lua(DirectIndex, HitType)
-- 	if self.Data.LandEffectId then
-- 		self:SetActorTickEnabled(true)
-- 	end
-- 	local Owner = self:GetOwner()
-- 	rawset(self, "MarkDroped", true)
-- 	local MoveDirect = self.Data.MoveDirect and (self.Data.MoveDirect[DirectIndex] or 0) or 0
-- 	local Rotation = Owner:K2_GetActorRotation()
-- 	local Rotator = FRotator(0, Rotation.Yaw + MoveDirect + math.random() * 30 - 15, 0)
-- 	local Speed = self.Data.Speed["Normal"] or 0
-- 	if HitType == "Hit" then
-- 		if self.Data.Speed["Hit"] then
-- 			Speed = self.Data.Speed["Hit"]
-- 		end
-- 	elseif HitType == "Death" then
-- 		if self.Data.Speed["Death"] then
-- 			Speed = self.Data.Speed["Death"]
-- 		end
-- 	end

-- 	local ForwardVector = UE4.UKismetMathLibrary.GetForwardVector(Rotator) * Speed
-- 	self.Mesh:SetPhysicsLinearVelocity(FVector(ForwardVector.X,ForwardVector.Y,150))
-- 	self:AddTimer(self.Data.DelayDestroyTime, self.Dissolve)
-- end

-- function BP_BodyAccessoryItem_C:SimpleDestroyMulticast_Lua()
-- 	self:AddTimer(self.Data.DelayDestroyTime, self.Dissolve)
-- end

-- function BP_BodyAccessoryItem_C:Dissolve()
-- 	local bStandAlone = IsStandAlone(self)
-- 	if bStandAlone or IsClient(self) then
-- 		self:BeginDissolve()
-- 	end
	
-- 	if bStandAlone or IsDedicatedServer(self) then
-- 		self:AddTimer(2, self.EMActorDestroy)
-- 	end
-- end

-- function BP_BodyAccessoryItem_C:EMActorDestroy()
-- 	if not IsValid(self) then 
-- 		return 
-- 	end

-- 	if self.AccessoryId then
-- 		local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 		if GameState and GameState:CheckBodyAccessotyNeedCache(self.AccessoryId) then
-- 			self:EMActorDestroyMulticast()
-- 			GameState:DoCacheBodyAccessory(self.AccessoryId, self)
-- 			rawset(self, "MarkDroped", false)
-- 			--self:SetActorHideTag("CacheFreeze", true)
-- 			return
-- 		end
-- 	end
-- 	self:K2_DestroyActor()
-- end

function BP_BodyAccessoryItem_C:EMActorDestroyMulticast_Lua()
	-- self.HideTags = {}
	self.FXComponent:StopAllEffects(true)
end

-- function BP_BodyAccessoryItem_C:SetActorHideTag(HideTag, bHide)
-- 	if bHide then
-- 		if self.HideTags[HideTag] then
-- 			return
-- 		end
-- 		self.HideTags[HideTag] = true
-- 	else
-- 		self.HideTags[HideTag] = nil
-- 	end
-- 	local bHide = not IsEmptyTable(self.HideTags)
-- 	self:SetActorHiddenInGame(bHide)
-- end

return BP_BodyAccessoryItem_C
