-- Source Excel file path: ..\datas\Skin.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SkinUpgrade", {
	[150401] = {
		[2] = {
			Condition = 4220,
			SkinID = 150401,
			Step = 2,
			UnlockAmount = 1000,
			UnlockCurrency = 100,
		},
		[3] = {
			Condition = 4220,
			SkinID = 150401,
			Step = 3,
			UnlockAmount = 1000,
			UnlockCurrency = 99,
		},
	},
})