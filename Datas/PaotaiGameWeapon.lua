-- Source Excel file path: ..\datas\GameEvent\PaotaiMiniGame.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PaotaiGameWeapon", {
	[1] = {
		BuffId = 40101012,
		DungeonId = 40102,
		DungeonLockDes = "PaotaiGame_PropLock_2",
		Id = 1,
		WeaponDes = "PaotaiGame_WeaponDes_1",
		WeaponIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Fort/T_Fort_Weapon_01.T_Fort_Weapon_01",
		WeaponName = "PaotaiGame_WeaponName_1",
	},
	[2] = {
		BuffId = 40101013,
		DungeonId = 40103,
		DungeonLockDes = "PaotaiGame_PropLock_3",
		Id = 2,
		WeaponDes = "PaotaiGame_WeaponDes_2",
		WeaponIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Fort/T_Fort_Weapon_02.T_Fort_Weapon_02",
		WeaponName = "PaotaiGame_WeaponName_2",
	},
	[3] = {
		BuffId = 40101014,
		DungeonId = 40104,
		DungeonLockDes = "PaotaiGame_PropLock_4",
		Id = 3,
		WeaponDes = "PaotaiGame_WeaponDes_3",
		WeaponIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Fort/T_Fort_Weapon_03.T_Fort_Weapon_03",
		WeaponName = "PaotaiGame_WeaponName_3",
	},
	[4] = {
		BuffId = 40101015,
		DungeonId = 40105,
		DungeonLockDes = "PaotaiGame_PropLock_5",
		Id = 4,
		WeaponDes = "PaotaiGame_WeaponDes_4",
		WeaponIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Fort/T_Fort_Weapon_04.T_Fort_Weapon_04",
		WeaponName = "PaotaiGame_WeaponName_4",
	},
})