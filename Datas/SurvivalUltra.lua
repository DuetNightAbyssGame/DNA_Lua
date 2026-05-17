-- Source Excel file path: ..\datas\Dungeons\SurvivalUltra.xlsx
local T = {}
T.RT_1 = {
		[1] = 120,
		[2] = 150,
	}
T.RT_2 = {
		916021,
	}
T.RT_3 = {
		916022,
	}
T.RT_4 = {
		916023,
	}
T.RT_5 = {
		916024,
	}
T.RT_6 = {
		916025,
	}
T.RT_7 = {
		916026,
	}
T.RT_8 = {
		[1] = T.RT_2,
		[2] = T.RT_3,
		[3] = T.RT_4,
		[4] = T.RT_5,
		[5] = T.RT_6,
		[6] = T.RT_7,
	}
T.RT_9 = {
		916031,
		916032,
	}
T.RT_10 = {
		916033,
		916034,
	}
T.RT_11 = {
		916035,
		916036,
	}
T.RT_12 = {
		[1] = T.RT_9,
		[2] = T.RT_10,
		[3] = T.RT_11,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SurvivalUltra", {
	[91601] = {
		DungeonId = 91601,
		LevelThreshold = T.RT_1,
		MonsterSpawnId = T.RT_8,
		StrongLoopSpawnId = T.RT_12,
	},
	[91602] = {
		DungeonId = 91602,
		LevelThreshold = T.RT_1,
		MonsterSpawnId = T.RT_8,
		StrongLoopSpawnId = T.RT_12,
	},
	[91603] = {
		DungeonId = 91603,
		LevelThreshold = T.RT_1,
		MonsterSpawnId = T.RT_8,
		StrongLoopSpawnId = T.RT_12,
	},
	[91604] = {
		DungeonId = 91604,
		LevelThreshold = T.RT_1,
		MonsterSpawnId = T.RT_8,
		StrongLoopSpawnId = T.RT_12,
	},
	[91605] = {
		DungeonId = 91605,
		LevelThreshold = T.RT_1,
		MonsterSpawnId = T.RT_8,
		StrongLoopSpawnId = T.RT_12,
	},
	[91606] = {
		DungeonId = 91606,
		LevelThreshold = T.RT_1,
		MonsterSpawnId = T.RT_8,
		StrongLoopSpawnId = T.RT_12,
	},
})