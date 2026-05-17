-- Source Excel file path: ..\datas\Weapon.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("HyperWeaponCardLevel", {
	[10101] = {
		[1] = {
			CollectRewardExp = 200,
			ResourceId = {
				[1] = 100,
			},
			ResourceNum = {
				[1] = 5,
			},
			WeaponCardLevel = 1,
			WeaponId = 10101,
		},
	},
})