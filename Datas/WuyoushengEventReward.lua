-- Source Excel file path: ..\datas\GameEvent\WuyoushengEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WuyoushengEventReward", {
	[11000101] = {
		EventId = 110001,
		RequiredStar = 3,
		Reward = 110701,
		RewardKeyId = 11000101,
	},
	[11000102] = {
		EventId = 110001,
		RequiredStar = 6,
		Reward = 110702,
		RewardKeyId = 11000102,
	},
	[11000103] = {
		EventId = 110001,
		RequiredStar = 9,
		Reward = 110703,
		RewardKeyId = 11000103,
	},
	[11000104] = {
		EventId = 110001,
		RequiredStar = 12,
		Reward = 110704,
		RewardKeyId = 11000104,
	},
	[11000105] = {
		EventId = 110001,
		RequiredStar = 15,
		Reward = 110705,
		RewardKeyId = 11000105,
	},
	[11000106] = {
		EventId = 110001,
		RequiredStar = 18,
		Reward = 110706,
		RewardKeyId = 11000106,
	},
	[11000107] = {
		EventId = 110001,
		RequiredStar = 21,
		Reward = 110707,
		RewardKeyId = 11000107,
	},
})