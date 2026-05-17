-- Source Excel file path: ..\datas\SkinGacha.xlsx
local T = {}
T.RT_1 = {
		[1] = 7601,
		[2] = 7602,
		[3] = 7603,
		[4] = 7604,
		[5] = 7605,
	}
T.RT_2 = {
		[1] = 20,
		[2] = 40,
		[3] = 60,
		[4] = 80,
		[5] = 100,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SkinGachaCumulative", {
	[9002] = {
		GachaId = 9002,
		RewardId = T.RT_1,
		RewardTarget = T.RT_2,
	},
	[9003] = {
		GachaId = 9003,
		RewardId = T.RT_1,
		RewardTarget = T.RT_2,
	},
	[9004] = {
		GachaId = 9004,
		RewardId = T.RT_1,
		RewardTarget = T.RT_2,
	},
	[9005] = {
		GachaId = 9005,
		RewardId = T.RT_1,
		RewardTarget = T.RT_2,
	},
})