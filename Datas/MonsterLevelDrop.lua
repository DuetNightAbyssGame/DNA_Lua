-- Source Excel file path: ..\datas\DungeonIronSurvival.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MonsterLevelDrop", {
	[1] = {
		BaseProbability = {
			[1] = 10000,
			[2] = 30000,
		},
		MonsterLevel = {
			[1] = 10,
			[2] = 20,
		},
		MonsterLevelDropId = 1,
		ProbabilityUp = {
			[1] = 1000,
			[2] = 10000,
		},
		RewardId = {
			[1] = 303001,
			[2] = 303001,
		},
	},
})