-- Source Excel file path: ..\datas\CostumeTemplate.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WeaponCostumeTemplate", {
	[530110] = {
		SkinId = 3010201,
		WeaponAccessory = 10001,
		WeaponCostumeId = 530110,
		WeaponSpecialColor = 10001,
	},
	[1020101] = {
		SkinId = 3010402,
		WeaponCostumeId = 1020101,
	},
	[1020401] = {
		SkinId = 3010401,
		WeaponCostumeId = 1020401,
	},
	[2060201] = {
		SkinId = 3010301,
		WeaponCostumeId = 2060201,
	},
	[3010107] = {
		SkinId = 3010107,
		WeaponCostumeId = 3010107,
	},
	[3010501] = {
		SkinId = 3010501,
		WeaponCostumeId = 3010501,
	},
	[3011002] = {
		SkinId = 3011002,
		WeaponCostumeId = 3011002,
	},
})