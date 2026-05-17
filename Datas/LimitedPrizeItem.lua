-- Source Excel file path: ..\datas\GameEvent\LimitedPrizePool.xlsx
local T = {}
T.RT_1 = {
		[1] = 1,
		[2] = 1,
		[3] = 1,
		[4] = 1,
		[5] = 1,
		[6] = 50000,
		[7] = 5,
		[8] = 10,
	}
T.RT_2 = {
		180101,
		410101,
	}
T.RT_3 = {
		10001,
		10002,
	}
T.RT_4 = {
		10050,
	}
T.RT_5 = {
		20008,
	}
T.RT_6 = {
		30016,
	}
T.RT_7 = {
		101,
	}
T.RT_8 = {
		201,
		202,
	}
T.RT_9 = {
		110,
	}
T.RT_10 = {
		[1] = T.RT_2,
		[2] = T.RT_3,
		[3] = T.RT_4,
		[4] = T.RT_5,
		[5] = T.RT_6,
		[6] = T.RT_7,
		[7] = T.RT_8,
		[8] = T.RT_9,
	}
T.RT_11 = {
		[1] = 450,
		[2] = 450,
		[3] = 850,
		[4] = 1050,
		[5] = 1450,
		[6] = 1650,
		[7] = 2050,
		[8] = 2050,
	}
T.RT_12 = {
		[1] = 2,
		[2] = 4,
		[3] = 4,
		[4] = 4,
		[5] = 4,
		[6] = 6,
		[7] = 6,
		[8] = 6,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("LimitedPrizeItem", {
	[1001] = {
		CostRuleId = 1001,
		Count = T.RT_1,
		Id = T.RT_10,
		LimitedPrizePoolId = 1001,
		Probability = T.RT_11,
		Type = T.RT_12,
	},
	[1002] = {
		CostRuleId = 1002,
		Count = T.RT_1,
		Id = T.RT_10,
		LimitedPrizePoolId = 1002,
		Probability = T.RT_11,
		Type = T.RT_12,
	},
})