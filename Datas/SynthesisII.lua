-- Source Excel file path: ..\datas\Dungeons\SynthesisII.xlsx
local T = {}
T.RT_1 = {
		1000000021,
		1000000022,
		1000000023,
	}
T.RT_2 = {
		1000000001,
		1000000003,
	}
T.RT_3 = {
		12001,
		12003,
	}
T.RT_4 = {
		1000000041,
	}
T.RT_5 = {
		50,
		100,
	}
T.RT_6 = {
		1000000011,
		1000000012,
		1000000013,
	}
T.RT_7 = {
		1000000001,
		1000000002,
		1000000003,
	}
T.RT_8 = {
		12001,
		12002,
		12003,
	}
T.RT_9 = {
		1000000041,
		1000000042,
	}
T.RT_10 = {
		80,
		120,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SynthesisII", {
	[91501] = {
		CannonCreatorId = T.RT_1,
		ChargeCreatorId = T.RT_2,
		ChargeMonsterSpawnId = T.RT_3,
		ChargeTime = 140,
		DungeonId = 91501,
		EliteCreatorId = T.RT_4,
		FortDefenceTargetNum = T.RT_5,
		HostageCreatorId = 1000000031,
		MiniGameCreatorId = T.RT_6,
	},
	[91502] = {
		CannonCreatorId = T.RT_1,
		ChargeCreatorId = T.RT_2,
		ChargeMonsterSpawnId = T.RT_3,
		ChargeTime = 140,
		DungeonId = 91502,
		EliteCreatorId = T.RT_4,
		FortDefenceTargetNum = T.RT_5,
		HostageCreatorId = 1000000031,
		MiniGameCreatorId = T.RT_6,
	},
	[91503] = {
		CannonCreatorId = T.RT_1,
		ChargeCreatorId = T.RT_2,
		ChargeMonsterSpawnId = T.RT_3,
		ChargeTime = 140,
		DungeonId = 91503,
		EliteCreatorId = T.RT_4,
		FortDefenceTargetNum = T.RT_5,
		HostageCreatorId = 1000000031,
		MiniGameCreatorId = T.RT_6,
	},
	[91504] = {
		CannonCreatorId = T.RT_1,
		ChargeCreatorId = T.RT_2,
		ChargeMonsterSpawnId = T.RT_3,
		ChargeTime = 140,
		DungeonId = 91504,
		EliteCreatorId = T.RT_4,
		FortDefenceTargetNum = T.RT_5,
		HostageCreatorId = 1000000031,
		MiniGameCreatorId = T.RT_6,
	},
	[91505] = {
		CannonCreatorId = T.RT_1,
		ChargeCreatorId = T.RT_7,
		ChargeMonsterSpawnId = T.RT_8,
		ChargeTime = 140,
		DungeonId = 91505,
		EliteCreatorId = T.RT_9,
		FortDefenceTargetNum = T.RT_10,
		HostageCreatorId = 1000000031,
		MiniGameCreatorId = T.RT_6,
	},
	[91506] = {
		CannonCreatorId = T.RT_1,
		ChargeCreatorId = T.RT_7,
		ChargeMonsterSpawnId = T.RT_8,
		ChargeTime = 140,
		DungeonId = 91506,
		EliteCreatorId = T.RT_9,
		FortDefenceTargetNum = T.RT_10,
		HostageCreatorId = 1000000031,
		MiniGameCreatorId = T.RT_6,
	},
	[91507] = {
		CannonCreatorId = T.RT_1,
		ChargeCreatorId = T.RT_7,
		ChargeMonsterSpawnId = T.RT_8,
		ChargeTime = 140,
		DungeonId = 91507,
		EliteCreatorId = T.RT_9,
		FortDefenceTargetNum = T.RT_10,
		HostageCreatorId = 1000000031,
		MiniGameCreatorId = T.RT_6,
	},
	[91508] = {
		CannonCreatorId = T.RT_1,
		ChargeCreatorId = T.RT_7,
		ChargeMonsterSpawnId = T.RT_8,
		ChargeTime = 140,
		DungeonId = 91508,
		EliteCreatorId = T.RT_9,
		FortDefenceTargetNum = T.RT_10,
		HostageCreatorId = 1000000031,
		MiniGameCreatorId = T.RT_6,
	},
})