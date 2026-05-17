-- Source Excel file path: ..\datas\Walnut.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WalnutFirstGet", {
	[1020] = {
		RewardLv = {
			1,
			5,
			6,
		},
		WalnutId = 1020,
	},
})