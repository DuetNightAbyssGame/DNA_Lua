local Class = _G.TypeClass
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties


local SimpleChar = Class("SimpleChar", CustomTypes.CustomAttr)
	SimpleChar.__Props__ = {
		-- 角色id
		CharId = prop.prop("Int", "client save"),
		-- 等级
		Level = prop.prop("Int", "client save", 1),
		-- 突破等级
		EnhanceLevel = prop.prop("Int", "client save", 0),
		-- 阶级
		GradeLevel = prop.prop("Int", "client save", 0),
		-- 皮肤
		SkinId = prop.prop("Int", "client save", 0),
		-- 技能
		Skills = prop.prop("Skill.SkillList", "client save"),
		-- ModSlots
		ModSlots = prop.prop("Mod.SimpleModSlots", "client save")
	}

	FormatProperties(SimpleChar)


local SimpleWeapon = Class("SimpleWeapon", CustomTypes.CustomAttr)
	SimpleWeapon.__Props__ = {
		-- 武器id
		WeaponId = prop.prop("Int", "client save"),
		-- 等级
		Level = prop.prop("Int", "client save", 1),
		-- 突破等级
		EnhanceLevel = prop.prop("Int", "client save", 0),
		-- 阶级
		GradeLevel = prop.prop("Int", "client save", 0),
		-- 技能
		Skills = prop.prop("Skill.SkillList", "client save"),
		-- ModSlots
		ModSlots = prop.prop("Mod.SimpleModSlots", "client save")
	}

	FormatProperties(SimpleWeapon)

return {
	SimpleChar = SimpleChar,
	SimpleWeapon = SimpleWeapon
}