--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_WeaponFashion_C = Class("BluePrints.Common.FashionComponent_C")

-- function BP_WeaponFashion_C:Initialize(Initializer)
-- 	print("weapon fashion initialize")
-- 	-- self.BodyIndex = {}
-- 	self.OPHideTags = {}
-- end

-- function BP_WeaponFashion_C:ReceiveBeginPlay()
-- 	self.DisappearTime = -1000    
-- 	-- self:CreateAllDynamicMaterial()
-- end

-- function BP_WeaponFashion_C:CreateAllDynamicMaterial()
-- 	self.AllMaterials:Clear()
-- 	local Owner = self:GetOwner()
-- 	local Mesh = Owner.WeaponMesh	
-- 	if Mesh == nil then
-- 		return
-- 	end
-- 	local MaterialSlotNames = Mesh:GetMaterialSlotNames()
-- 	for i=1,MaterialSlotNames:Length() do
-- 		self.AllMaterials:Add(Mesh:CreateDynamicMaterialInstance(i - 1))
-- 	end
-- 	-- if self.BodyIndex then
-- 	-- 	local Owner = self:GetOwner()
-- 	-- 	local Mesh = Owner.WeaponMesh
-- 	-- 	self.BodyMaterial = {}
-- 	-- 	for k, v in pairs(self.BodyIndex) do
-- 	-- 		if self.BodyMaterial[v] == nil then
-- 	-- 			self.BodyMaterial[v] = self.AllMaterials:GetRef(v+1)
-- 	-- 		end
-- 	-- 	end
-- 	-- end
-- 	if self.AllMaterials:Length() > 0 then
-- 		-- self.WeaponMaterial = self.AllMaterials:GetRef(1)	
-- 	end

-- 	for _, Accessory in pairs(Owner.Accessories) do
-- 		if Accessory then
-- 			local AccessoryMesh = Accessory.ItemMesh
-- 			if AccessoryMesh then
-- 				local AccessoryMaterialSlotNames = AccessoryMesh:GetMaterialSlotNames()
-- 				for i=1,AccessoryMaterialSlotNames:Length() do
-- 					self.AllMaterials:Add(AccessoryMesh:CreateDynamicMaterialInstance(i - 1))
-- 				end
-- 			end
-- 		end
-- 	end
-- end

-- appear传0表示消失，传1表示出现
-- duration表示动画持续时间
-- function BP_WeaponFashion_C:WeaponAppear()
-- 	local Owner = self:GetOwner()
-- 	if IsDedicatedServer(Owner) and IsAuthority(Owner) then 
-- 		return 
-- 	end
-- 	if self.BodyMaterial then
-- 		for k, v in pairs(self.BodyMaterial) do
-- 			v:SetScalarParameterValue("Appear_Dissolve", 1.0)
-- 			v:SetScalarParameterValue("Duration_Dissolve", self.AppearDissolveDuration)
-- 			v:SetScalarParameterValue("StartTime_Dissolve", UE4.UGameplayStatics.GetTimeSeconds(self))
-- 		end
-- 	end
-- end

-- function BP_WeaponFashion_C:WeaponDisappear()
-- 	local Now = UE4.UGameplayStatics.GetTimeSeconds(self)
-- 	if Now - self.DisappearTime < self.DisappearDissolveInterval then
-- 		return self.DissolveWeapon
-- 	end
-- 	if IsValid(self.DissolveWeapon) then
-- 		self.DissolveWeapon:K2_DestroyActor()
-- 	end
-- 	self.DisappearTime = Now
-- 	self.DissolveWeapon = self:CreateDissolveActor(self.DisappearDissolveDuration)
-- 	if self.DissolveWeapon then
-- 		local Owner = self:GetOwner()
-- 		Owner:WeaponRemain(self.DissolveWeapon)
-- 	end
-- 	return self.DissolveWeapon
-- end

-- function BP_WeaponFashion_C:WeaponAppearImmediately()
-- 	local Owner = self:GetOwner()
-- 	if IsDedicatedServer(Owner) and IsAuthority(Owner) then 
-- 		return 
-- 	end
-- 	if self.BodyMaterial then
-- 		for k, v in pairs(self.BodyMaterial) do
-- 			v:SetScalarParameterValue("Appear_Dissolve", 1)
-- 			v:SetScalarParameterValue("StartTime_Dissolve", -1000)
-- 		end
-- 	end
-- end

-- function BP_WeaponFashion_C:ShowDissolve(DissolveDuration)
-- 	print("ShowDissolve")
-- 	local Owner = self:GetOwner()
-- 	if IsDedicatedServer(Owner) and IsAuthority(Owner) then 
-- 		return 
-- 	end
-- 	if self.AllMaterials then
-- 		print('ShowDissolve', DissolveDuration)  
-- 		for k, v in pairs(self.AllMaterials) do
-- 			v:SetScalarParameterValue("StartTime_Dissolve", UE4.UGameplayStatics.GetTimeSeconds(self))
-- 			v:SetScalarParameterValue("Duration_Dissolve", DissolveDuration)
-- 			v.NextPass = nil
-- 			print("ShowDissolve", k, v)
-- 		end
-- 	end
-- end

-- function BP_WeaponFashion_C:SetDitherAlpha(DitherAlpha, OP)
-- 	-- body	
-- 	local Owner = self:GetOwner()
-- 	if IsDedicatedServer(Owner) and IsAuthority(Owner) then 
-- 		return 
-- 	end
-- 	for k, v in pairs(self.AllMaterials) do
-- 		v:SetScalarParameterValue("DitherAlpha", DitherAlpha)
-- 		-- print("SetDitherAlpha", DitherAlpha, OP)
-- 	end
-- 	self:HideOP(OP == 0.0, "Camera")
-- end

-- function BP_WeaponFashion_C:HideOP(bHide, HideTag)
-- 	if bHide then
-- 		self.OPHideTags[HideTag] = true
-- 	else
-- 		self.OPHideTags[HideTag] = nil
-- 	end

-- 	local Hide = false
-- 	for Tag, bHide in pairs(self.OPHideTags) do
-- 		if bHide then
-- 			Hide = true
-- 			break
-- 		end
-- 	end
-- 	if self.WeaponMaterial and self.WeaponMaterial.NextPass then
-- 		if Hide then
-- 			self.WeaponMaterial.NextPass:SetScalarParameterValue("OP", 0.0)
-- 		else
-- 			self.WeaponMaterial.NextPass:SetScalarParameterValue("OP", 1.0)
-- 		end
-- 	end
-- end

-- function BP_WeaponFashion_C:GetEffectColor()
-- 	-- body
-- 	local Owner = self:GetOwner()
-- 	if IsDedicatedServer(Owner) and IsAuthority(Owner) then 
-- 		return 
-- 	end
-- 	if self.WeaponMaterial then
-- 		return self.WeaponMaterial:K2_GetVectorParameterValue("EffectColor")
-- 	end
-- 	return FLinearColor(0, 0, 0, 0)
-- end

return BP_WeaponFashion_C
