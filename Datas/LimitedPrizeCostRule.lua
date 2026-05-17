-- Source Excel file path: ..\datas\GameEvent\LimitedPrizePool.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("LimitedPrizeCostRule", {
	[1001] = {
		CostResCount = {
			[1] = 1,
			[2] = 3,
			[3] = 5,
			[4] = 7,
			[5] = 9,
			[6] = 11,
			[7] = 13,
			[8] = 15,
		},
		CostResourceId = 1001,
		CostRuleId = 1001,
		GetBestPrizeNum = 2,
	},
	[1002] = {
		CostResCount = {
			[1] = 1,
			[2] = 2,
			[3] = 4,
			[4] = 6,
			[5] = 8,
			[6] = 10,
			[7] = 12,
			[8] = 14,
		},
		CostResourceId = 1001,
		CostRuleId = 1002,
		GetBestPrizeNum = 1,
	},
})