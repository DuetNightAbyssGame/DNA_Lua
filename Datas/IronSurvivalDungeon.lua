-- Source Excel file path: ..\datas\DungeonIronSurvival.xlsx
local T = {}
T.RT_1 = {
		[70] = 303002,
		[80] = 1017,
		[90] = 1018,
	}
T.RT_2 = {
		[70] = 1016,
		[80] = 1017,
		[90] = 1018,
	}
T.RT_3 = {
		1001,
	}
T.RT_4 = {
		1,
	}
T.RT_5 = {
		15001,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("IronSurvivalDungeon", {
	[91601] = {
		DungeonId = 91601,
		IronRoundsReward = T.RT_1,
		IronRoundsRewardView = T.RT_2,
		IronTicketId = T.RT_3,
		MonsterLevelDrop = T.RT_4,
		MonsterLevelDropView = T.RT_5,
		RewardId = 51601,
	},
	[91602] = {
		DungeonId = 91602,
		IronRoundsReward = T.RT_1,
		IronRoundsRewardView = T.RT_2,
		IronTicketId = T.RT_3,
		MonsterLevelDrop = T.RT_4,
		MonsterLevelDropView = T.RT_5,
		RewardId = 51601,
	},
	[91603] = {
		DungeonId = 91603,
		IronRoundsReward = T.RT_1,
		IronRoundsRewardView = T.RT_2,
		IronTicketId = T.RT_3,
		MonsterLevelDrop = T.RT_4,
		MonsterLevelDropView = T.RT_5,
		RewardId = 51601,
	},
	[91604] = {
		DungeonId = 91604,
		IronRoundsReward = T.RT_1,
		IronRoundsRewardView = T.RT_2,
		IronTicketId = T.RT_3,
		MonsterLevelDrop = T.RT_4,
		MonsterLevelDropView = T.RT_5,
		RewardId = 51601,
	},
	[91605] = {
		DungeonId = 91605,
		IronRoundsReward = T.RT_1,
		IronRoundsRewardView = T.RT_2,
		IronTicketId = T.RT_3,
		MonsterLevelDrop = T.RT_4,
		MonsterLevelDropView = T.RT_5,
		RewardId = 51601,
	},
	[91606] = {
		DungeonId = 91606,
		IronRoundsReward = T.RT_1,
		IronRoundsRewardView = T.RT_2,
		IronTicketId = T.RT_3,
		MonsterLevelDrop = T.RT_4,
		MonsterLevelDropView = T.RT_5,
		RewardId = 51601,
	},
})