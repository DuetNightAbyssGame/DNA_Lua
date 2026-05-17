-- Source Excel file path: ..\datas\Weapon.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ForgeLevel", {
	[1] = {
		ForgeLevel = 1,
		HyperWeaponMaxCardLevel = 1,
	},
	[2] = {
		ForgeLevel = 2,
		HyperWeaponMaxCardLevel = 2,
	},
	[3] = {
		ForgeLevel = 3,
		HyperWeaponMaxCardLevel = 3,
	},
	[4] = {
		ForgeLevel = 4,
		HyperWeaponMaxCardLevel = 4,
	},
	[5] = {
		ForgeLevel = 5,
		HyperWeaponMaxCardLevel = 5,
	},
})