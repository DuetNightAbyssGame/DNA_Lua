
local Component = {}

function Component:GetTableAttrNames_Lua()
	return {
		"Attribute",
		"BaseOverShield",
		"OverShieldLevelGrow",
		"CRI",
		"CRD",
		"AttackSpeed_Normal",
		"AttackSpeed_Reload",
		"AttackRange_Normal",
		"AttackRange_RayLength",
		"SkillSpeed",

		-- 能量相关
		"Sp",
		"MaxSp",
		"SpRecoverTime",
		"SpRecoverRate",
		"SpRecoverValue",
		"SpRate",
		"CollisionLevel",
		"SecondSp",
		"MaxSecondSp",
		-- "UltraWeapon",
		"SkillRange",
		"SkillSustain",
		"SkillEfficiency",
		"SkillIntensity",
		"BreakCount",
		"PlayerDamagedRate",
		"MonsterDamageRate",

		-- 韧性值相关
		"TN",
		"MaxTN",
		"TNResistance",
		"TNRecoverS",
		"TNRecoverTimeB",
		"TNRecoverTimeZ",
		"BossTNToZeroRecoverSpeed",

		---------------------------武器独有---------------------------
		"TriggerProbability",
		"MultiShoot",
		-- 子弹
		"BulletSpeed",
		"RayLength",
		"BulletType",
		"BulletMax",
		"BulletInit",
		"BulletConver",
		"MagazineCapacity",
		-- 连击
		"MaxComboCount",
		"ComboHoldTime",
		-- 护盾恢复
		"ESRecoverRate",
		"ESRecoverValue",
		"ESRecoverTime",
		-- 移动速度
		"MoveSpeedAddRate",
		"MaxAvoidExecuteTimes",
		"AvoidChargeCd",
		"DropDistance",
	}
end

function Component:SetReplaceAttrs(ReplaceAttrs)
	local FromSkynet = true
	for AttrName, Value in pairs(ReplaceAttrs.TotalValues or {}) do
		local CardValue = (ReplaceAttrs.CardValues or {})[AttrName]
		local CardLevelValue = (ReplaceAttrs.CardLevelValues or {})[AttrName]
		local ModRateValue = (ReplaceAttrs.ModRateValues or {})[AttrName]
		local ModAddValue = (ReplaceAttrs.ModAddValues or {})[AttrName]
		self:FillReplaceAttr(AttrName, CardValue, CardLevelValue, ModRateValue, ModAddValue, FromSkynet)
	end	
end

function Component:SetTableAttr(ReplaceAttrs)
	self:SetTableAttrCpp()

	-- 这里是skynet传过来的玩家/武器的数据替换
	if ReplaceAttrs then
		self:SetReplaceAttrs(ReplaceAttrs)
		--local FromSkynet = true
		--for AttrName, Value in pairs(ReplaceAttrs.TotalValues or {}) do
		--	local CardValue = (ReplaceAttrs.CardValues or {})[AttrName]
		--	local CardLevelValue = (ReplaceAttrs.CardLevelValues or {})[AttrName]
		--	local ModRateValue = (ReplaceAttrs.ModRateValues or {})[AttrName]
		--	local ModAddValue = (ReplaceAttrs.ModAddValues or {})[AttrName]
		--	self:FillReplaceAttr(AttrName, CardValue, CardLevelValue, ModRateValue, ModAddValue, FromSkynet)
		--end
	else--if not self:IsSummonMonster() and not self:IsNPC() then
		self:FillLevelAttrs()
	end

	self:AfterSetTableAttr()
end

function Component:InitAllWeaponModifier(ReplaceAttrs)
	if not ReplaceAttrs then
		return
	end
	
	for AttrName, Value in pairs(ReplaceAttrs.TotalValues or {}) do
		self:SetAllWeaponModifier(AttrName)
	end
end

return Component
