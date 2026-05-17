
require "UnLua"

local BP_WeaponAttributesSet_C = Class("BluePrints.Combat.BaseAttributesSet")

BP_WeaponAttributesSet_C.CppAttrs = {}

--function BP_WeaponAttributesSet_C:OnRep_BulletNum()
--	local Owner = self.OwnerActor
--	if not Owner then
--		return
--	end
--	local Character = Owner.Owner
--	if not Character then
--		return
--	end
--	
--	if(Character:IsMainPlayer() and Character.UpdateBulletNumUI)then
--		Character:UpdateBulletNumUI()
--	end
--	if self:GetAttr("MagazineBulletNum") ~= 0 then 
--		Owner:SetWeaponState("NoBullet", false)
--		return
--	end
--
--	if self:GetAttr("BulletMax") ~= 0 then
--		Owner:SetWeaponState("NoBullet", true)
--	end
--end
--
--function BP_WeaponAttributesSet_C:OnRep_MagazineBulletNum()
--	local Owner = self.OwnerActor
--	if not Owner then
--		return
--	end
--	local Character = Owner.Owner
--	if not Character then
--		return
--	end
--	if(Character:IsMainPlayer() and Character.UpdateBulletNumUI)then
--		Character:UpdateBulletNumUI()
--	end
--	if self:GetAttr("MagazineBulletNum") ~= 0 then 
--		Owner:SetWeaponState("NoBullet", false)
--		return
--	end
--	if self:GetAttr("MagazineCapacity") > 0 then
--		Owner:SetWeaponState("NoBullet", true)
--	end
--end

function BP_WeaponAttributesSet_C:LevelUp(NewLevel, WeaponId)
	local Owner = self.OwnerActor.Owner
	if Owner:IsMainPlayer() then
		local UIManager = GWorld.GameInstance:GetGameUIManager()		
		if self.OwnerActor == Owner.MeleeWeapon then
			UIManager:ShowLevelUpToast(NewLevel, "MeleeWeapon", WeaponId)
		elseif self.OwnerActor == Owner.RangedWeapon then
			UIManager:ShowLevelUpToast(NewLevel, "RangedWeapon", WeaponId)
		end
	end
end

return BP_WeaponAttributesSet_C