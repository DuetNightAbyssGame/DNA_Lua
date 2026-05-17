-- Source Excel file path: ..\datas\GameEvent\AccessoryDrop.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("BoxDrop", {
	[103020] = {
		BoxCoinId = 221,
		BoxMaximum = 21,
		BoxPerDay = 2,
		CoinPerBox = 3,
		EventId = 103020,
		RewardCount = {
			[1] = 25,
		},
		RewardId = {
			[1] = 114100,
			[2] = 114101,
		},
	},
})