local prop = require "NetworkEngine.Common.Prop"

---@class TemplateAvatarAttr
local TemplateAvatarAttr = {
    -- 当前角色
	CurrentChar = prop.prop("ObjId", "client save"),
    -- 当前近战武器
	MeleeWeapon = prop.prop("ObjId", "client save"),
	-- 当前远程武器
	RangedWeapon = prop.prop("ObjId", "client save"),
    -- 角色
	Chars = prop.prop("Character.CharDict", "client save proto"),
	-- 角色公共数据
	CommonChars = prop.prop("CharacterCommon.CommonCharDict", "client save"),
	-- 未拥有角色的皮肤
	OtherCharSkins = prop.prop("Int2IntListDict", "client save"),
	-- 武器
	Weapons = prop.prop("Weapon.WeaponDict", "client save meta"),
	-- 显赫武器
	UWeapons = prop.prop("Weapon.UWeaponDict", "client save meta"),
	-- 拥有的武器皮肤
	OwnedWeaponSkins = prop.prop("Int2IntDict", "client save"),
    -- 饰品
	CharAccessorys = prop.prop("IntList", "client save"),
	--武器配饰
	WeaponAccessorys = prop.prop("IntList", "client save"),
	-- Mod
	Mods = prop.prop("Mod.ModDict", "client save"),
	OriginalMods = prop.prop("Int2ObjIdDict", "client save"),

	--所有宠物
	Pets = prop.prop("Pet.PetDict", "client save"),
	--宠物递增唯一ID
	PetUniqueID = prop.prop("Int", "save", 1),

}
return TemplateAvatarAttr
