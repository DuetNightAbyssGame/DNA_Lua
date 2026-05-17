
require "UnLua"

local Component = Class({
	"BluePrints.Combat.Components.CharacterInitLogic",
	"BluePrints.Combat.Components.EffectSourceInterface",
	"BluePrints.Combat.Components.SkillLevelInterface",

	"BluePrints.Char.CharacterComponent.CharModelComponent",
})

--function Component:PickUpBullet(ChangeBullet, GetBulletReason)
--	if ChangeBullet > 0 and self:GetAttr("CanNotGetBullet") == 1 then
--		return
--	end
--	if self.RangedWeapon then
--		local BulletNum = self:GetBulletNum()
--		self.RangedWeapon:PickUpBullet(ChangeBullet)
--		if ChangeBullet > 0 and GetBulletReason then
--			Battle(self):TriggerBattleEvent(BattleEventName.OnGetBullet, self, BulletNum, self:GetBulletNum(), GetBulletReason)
--		end
--	end
--end
--
--function Component:AddBullet(Amount, GetBulletReason)
--	if Amount > 0 and self:GetAttr("CanNotGetBullet") == 1 then
--		return
--	end
--	if self.RangedWeapon then
--		local BulletNum = self:GetBulletNum()
--		self.RangedWeapon:AddBullet(Amount)
--		if Amount > 0 and GetBulletReason then
--			Battle(self):TriggerBattleEvent(BattleEventName.OnGetBullet, self, BulletNum, self:GetBulletNum(), GetBulletReason)
--		end
--	end
--end
--
--function Component:AddBulletByBl(Amount)
--	self:AddBullet(Amount, EGetBulletReason.BlueprintAddBullet)
--end
--
--function Component:GetBulletNum()
--	if self.RangedWeapon then
--		return self.RangedWeapon:GetAttr("BulletNum")
--	end
--end
--
--function Component:ChargeBullet(ChargeAmount)
--	local Rate = self:GetAttr("ReloadBulletNoLoss")
--	local IsConsumeBullet = true
--	if Rate == 1 then
--		IsConsumeBullet = false
--	elseif Rate > 0 and Rate >= CommonUtils:RandomFloat() then
--		IsConsumeBullet = false
--	end
--	if self.RangedWeapon then
--		self.RangedWeapon:ChargeBullet(ChargeAmount, IsConsumeBullet)
--	end
--end
--
--function Component:AddMagazineBullet(ChargeAmount)
--	if ChargeAmount > 0 and self:GetAttr("CanNotGetBullet") == 1 then
--		return
--	end
--	if self.RangedWeapon then
--		self.RangedWeapon:AddMagazineBullet(ChargeAmount)
--	end
--end

function Component:ServerSetRoleMod(RoleId, ModPassives, OnlySummonInherit)
	self.ModPassives = ModPassives
	if not ModPassives then 
		return 
	end
	for i = 1, #ModPassives do
		local PassiveInfo = ModPassives[i]
		local PassiveId = PassiveInfo[1]
		local Level = PassiveInfo[2]
		local SummonInherit = PassiveInfo[3]
		if not OnlySummonInherit or SummonInherit then
			local PassiveEffect = self:AddPassiveEffectByRole(RoleId, PassiveId, Level)
			if PassiveEffect then
				PassiveEffect.SummonInherit = SummonInherit
			end
		end
	end
end

function Component:ServerInheritModAttr(ModData)
	for k, Data in pairs(ModData) do
		local ModId = Data.ModId
		local ModLevel = Data.Level
		self:SetAttrByMod(ModId, ModLevel)
	end
end

function Component:CreateUnitServerSetRoleMod(RoleId, Source, OnlySummonInherit)
	local MonsterData = DataMgr.Monster[self.UnitId]
	if MonsterData and MonsterData.InheritMod then
		self:ServerInheritModAttr(Source.InfoForInit and Source.InfoForInit.ModData or {})
		self:ServerSetRoleMod(RoleId, Source.ModPassives, false)
	else
		self:ServerSetRoleMod(RoleId, Source.ModPassives, OnlySummonInherit)
	end
	if MonsterData and MonsterData.InheritWeapon then
		if MonsterData.InheritWeapon == "Melee" then
			if Source.InfoForInit and Source.InfoForInit.MeleeWeapon then
				self:SummonServerSetUpMeleeWeapon(Source.InfoForInit.MeleeWeapon)
			elseif Source.CurrentRoleId and DataMgr.BattleChar[Source.CurrentRoleId].WeaponId then
				self:SummonServerSetUpMeleeWeapon({WeaponId = DataMgr.BattleChar[Source.CurrentRoleId].WeaponId})
			end
		elseif MonsterData.InheritWeapon == "Ranged" then
			if Source.InfoForInit and Source.InfoForInit.RangedWeapon then
				self:SummonServerSetUpRangedWeapon(Source.InfoForInit.RangedWeapon)
			elseif Source.CurrentRoleId and DataMgr.BattleChar[Source.CurrentRoleId].RangedWeapon then
				self:SummonServerSetUpMeleeWeapon({WeaponId = DataMgr.BattleChar[Source.CurrentRoleId].RangedWeapon})
			end
		end
	end
	local MaxHp = self:GetAttr("MaxHp")
	if MaxHp <= 0 then
		self:SetAttr("MaxHp", 1)
		self:SetAttr("Hp", 1)
	end
end

return Component
