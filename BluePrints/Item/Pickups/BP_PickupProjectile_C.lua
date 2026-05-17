require "UnLua"
---@type BP_PickupProjectile_C
local BP_PickupProjectile_C = Class( {"BluePrints.Item.Pickups.BP_PickupBase_C"} )

-- function BP_PickupProjectile_C:ClientInitInfo(Info)
-- 	-- 这里有严格的顺序，需要在父类的ClientInitInfo前初始化
-- 	-- self.DropEffectNew = nil
-- 	-- if self.IsShowJumping then
-- 	-- 	self:InitDropEffect()
-- 	-- end

--     BP_PickupProjectile_C.Super.ClientInitInfo(self,Info)
-- end

-- function BP_PickupProjectile_C:InitDropEffect()
-- 	self.State2Effect = {}
-- 	if self:GetRarity() == 4 then
-- 		self.State2Effect[EPickupProjectileState.Idle] = '/Game/Asset/Effect/Niagara/Item/NS_Item_Base_Pro.NS_Item_Base_Pro'
-- 		self.State2Effect[EPickupProjectileState.Flying] = '/Game/Asset/Effect/Niagara/Item/NS_Item_Pick_Base_Pro.NS_Item_Pick_Base_Pro'
-- 	elseif self:GetRarity() == 5 then
-- 		self.State2Effect[EPickupProjectileState.Idle] = '/Game/Asset/Effect/Niagara/Item/NS_Item_Base_Ultra.NS_Item_Base_Ultra'
-- 		self.State2Effect[EPickupProjectileState.Flying] = '/Game/Asset/Effect/Niagara/Item/NS_Item_Pick_Base_Ultra.NS_Item_Pick_Base_Ultra'
-- 	else
-- 		self.State2Effect[EPickupProjectileState.Idle] = '/Game/Asset/Effect/Niagara/Item/NS_Item_Base.NS_Item_Base'
-- 		self.State2Effect[EPickupProjectileState.Flying] = '/Game/Asset/Effect/Niagara/Item/NS_Item_Pick_Base.NS_Item_Pick_Base'
-- 	end
-- 	self.State2Effect[EPickupProjectileState.Projectile] = '/Game/Asset/Effect/Niagara/Item/NS_Item_Base_Fly.NS_Item_Base_Fly'
-- end

-- function BP_PickupProjectile_C:PlayEffect(TargetState)
-- 	if IsDedicatedServer(self) then
-- 		return
-- 	end
-- 	local FXMgr = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UFXPriorityManager)
-- 	local ShowColor = self:GetEffectColor()
-- 	if self.IsShowJumping then
-- 		if not self.State2Effect or not self.State2Effect[TargetState] then
-- 			return
-- 		end
-- 		local BulletEffectAsset = LoadObject(self.State2Effect[TargetState])
-- 		if TargetState == EPickupProjectileState.Flying then
-- 			local RelativeLocation = self:K2_GetActorLocation()
-- 			local RelativeRotation = self:K2_GetActorRotation()
-- 			local FxObject
-- 			FxObject = FXMgr:SpawnSystemAtLocation(self:GetOwner(), EFXPriorityType.DropEffect, self, BulletEffectAsset, RelativeLocation, RelativeRotation, FVector(1,1,1), true, true)
-- 			if FxObject then
-- 				FxObject:SetNiagaraVariableLinearColor("User.Color", ShowColor)
-- 			end
-- 			BulletEffectAsset = LoadObject(self.State2Effect[EPickupProjectileState.Projectile])
-- 		end
-- 		-- todo wuzhijun, ce13临时, cbt2前正式修改, 去掉蓝图里的niagaracomp
-- 		if BulletEffectAsset then
-- 			if self.DropEffectNew then
-- 				UCharacterFunctionLibrary.DeactivateNiagaraImmediately(self.DropEffectNew)
-- 			end
-- 			self.DropEffectNew = FXMgr:SpawnSystemAttached(self:GetOwner(), EFXPriorityType.DropEffect, BulletEffectAsset, self:K2_GetRootComponent(), "", UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0), 0)
-- 			if ShowColor then
-- 				self.DropEffectNew:SetNiagaraVariableLinearColor("User.Color", ShowColor)
-- 			end
-- 			self.DropEffectNew:Activate(true)
-- 		end
-- 	end
-- 	--有特效有mesh和无特效有mesh规则不同
-- 	if (TargetState ~= EPickupProjectileState.Idle and self.IsShowJumping) then--or (not self.IsShowJumping and TargetState ==EPickupProjectileState.Flying) then
-- 		self:CloseMesh()
-- 	else
-- 		self:ShowMesh()
-- 		self:SetMeshEffectColor(ShowColor)
-- 	end
-- end

function BP_PickupProjectile_C:AddPickupBaseToCache_Lua()
	BP_PickupProjectile_C.Super.AddPickupBaseToCache_Lua(self)
	if self.DropEffectNew then
		UCharacterFunctionLibrary.DeactivateNiagaraImmediately(self.DropEffectNew)
	end
end

return BP_PickupProjectile_C
