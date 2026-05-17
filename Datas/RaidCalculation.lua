-- Source Excel file path: ..\datas\RaidDungeon.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("RaidCalculation", {
	[1] = {
		FomulaId = 1,
		RaidTimeRate = {
			0.025,
			0.05,
			0.075,
		},
		RaidTimeZone = {
			10,
			20,
			60,
		},
	},
	[2] = {
		FomulaId = 2,
		RaidTimeRate = {
			0.01,
			0.018,
			0.025,
		},
		RaidTimeZone = {
			25,
			80,
			180,
		},
	},
})