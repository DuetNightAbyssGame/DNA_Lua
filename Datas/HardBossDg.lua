-- Source Excel file path: ..\datas\Dungeons\HardBossDg.xlsx
local T = {}
T.RT_1 = {
		1310010602,
	}
T.RT_2 = {
		8500501,
	}
T.RT_3 = {
		8500502,
	}
T.RT_4 = {
		8500503,
	}
T.RT_5 = {
		[1] = T.RT_2,
		[2] = T.RT_3,
		[3] = T.RT_3,
		[4] = T.RT_4,
	}
T.RT_6 = {
		1440052,
	}
T.RT_7 = {
		8503501,
	}
T.RT_8 = {
		8503502,
	}
T.RT_9 = {
		8503503,
	}
T.RT_10 = {
		[1] = T.RT_7,
		[2] = T.RT_8,
		[3] = T.RT_8,
		[4] = T.RT_9,
	}
T.RT_11 = {
		1240027,
	}
T.RT_12 = {
		8502501,
	}
T.RT_13 = {
		8502502,
	}
T.RT_14 = {
		8502503,
	}
T.RT_15 = {
		[1] = T.RT_12,
		[2] = T.RT_13,
		[3] = T.RT_13,
		[4] = T.RT_14,
	}
T.RT_16 = {
		1660121,
	}
T.RT_17 = {
		8505501,
	}
T.RT_18 = {
		8505502,
	}
T.RT_19 = {
		8505503,
	}
T.RT_20 = {
		[1] = T.RT_17,
		[2] = T.RT_18,
		[3] = T.RT_18,
		[4] = T.RT_19,
	}
T.RT_21 = {
		1969946,
	}
T.RT_22 = {
		8512501,
	}
T.RT_23 = {
		8512502,
	}
T.RT_24 = {
		8512503,
	}
T.RT_25 = {
		[1] = T.RT_22,
		[2] = T.RT_23,
		[3] = T.RT_23,
		[4] = T.RT_24,
	}
T.RT_26 = {
		302720001,
		302720004,
	}
T.RT_27 = {
		8510004,
		8511002,
	}
T.RT_28 = {
		[1] = T.RT_27,
		[2] = T.RT_27,
		[3] = T.RT_27,
		[4] = T.RT_27,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("HardBossDg", {
	[50101] = {
		AirWallStaticId = 1610010620,
		BossStaticId = T.RT_1,
		BossUnitId = T.RT_5,
		DifficultyId = 1001,
		DungeonId = 50101,
		HardBossId = 1,
		PreparingAirWallStaticId = 1610010621,
	},
	[50102] = {
		AirWallStaticId = 1610010620,
		BossStaticId = T.RT_1,
		BossUnitId = T.RT_5,
		DifficultyId = 1002,
		DungeonId = 50102,
		HardBossId = 1,
		PreparingAirWallStaticId = 1610010621,
	},
	[50103] = {
		AirWallStaticId = 1610010620,
		BossStaticId = T.RT_1,
		BossUnitId = T.RT_5,
		DifficultyId = 1003,
		DungeonId = 50103,
		HardBossId = 1,
		PreparingAirWallStaticId = 1610010621,
	},
	[50104] = {
		AirWallStaticId = 1610010620,
		BossStaticId = T.RT_1,
		BossUnitId = T.RT_5,
		DifficultyId = 1004,
		DungeonId = 50104,
		HardBossId = 1,
		PreparingAirWallStaticId = 1610010621,
	},
	[50105] = {
		AirWallStaticId = 1610010620,
		BossStaticId = T.RT_1,
		BossUnitId = T.RT_5,
		DifficultyId = 1005,
		DungeonId = 50105,
		HardBossId = 1,
		PreparingAirWallStaticId = 1610010621,
	},
	[50106] = {
		AirWallStaticId = 1610010620,
		BossStaticId = T.RT_1,
		BossUnitId = T.RT_5,
		DifficultyId = 1006,
		DungeonId = 50106,
		HardBossId = 1,
		PreparingAirWallStaticId = 1610010621,
	},
	[50201] = {
		AirWallStaticId = 1440064,
		BossStaticId = T.RT_6,
		BossUnitId = T.RT_10,
		DifficultyId = 1011,
		DungeonId = 50201,
		HardBossId = 2,
		PreparingAirWallStaticId = 1440066,
	},
	[50202] = {
		AirWallStaticId = 1440064,
		BossStaticId = T.RT_6,
		BossUnitId = T.RT_10,
		DifficultyId = 1012,
		DungeonId = 50202,
		HardBossId = 2,
		PreparingAirWallStaticId = 1440066,
	},
	[50203] = {
		AirWallStaticId = 1440064,
		BossStaticId = T.RT_6,
		BossUnitId = T.RT_10,
		DifficultyId = 1013,
		DungeonId = 50203,
		HardBossId = 2,
		PreparingAirWallStaticId = 1440066,
	},
	[50204] = {
		AirWallStaticId = 1440064,
		BossStaticId = T.RT_6,
		BossUnitId = T.RT_10,
		DifficultyId = 1014,
		DungeonId = 50204,
		HardBossId = 2,
		PreparingAirWallStaticId = 1440066,
	},
	[50205] = {
		AirWallStaticId = 1440064,
		BossStaticId = T.RT_6,
		BossUnitId = T.RT_10,
		DifficultyId = 1015,
		DungeonId = 50205,
		HardBossId = 2,
		PreparingAirWallStaticId = 1440066,
	},
	[50206] = {
		AirWallStaticId = 1440064,
		BossStaticId = T.RT_6,
		BossUnitId = T.RT_10,
		DifficultyId = 1016,
		DungeonId = 50206,
		HardBossId = 2,
		PreparingAirWallStaticId = 1440066,
	},
	[50301] = {
		AirWallStaticId = 1240025,
		BossStaticId = T.RT_11,
		BossUnitId = T.RT_15,
		DifficultyId = 1021,
		DungeonId = 50301,
		HardBossId = 3,
		PreparingAirWallStaticId = 1240026,
	},
	[50302] = {
		AirWallStaticId = 1240025,
		BossStaticId = T.RT_11,
		BossUnitId = T.RT_15,
		DifficultyId = 1022,
		DungeonId = 50302,
		HardBossId = 3,
		PreparingAirWallStaticId = 1240026,
	},
	[50303] = {
		AirWallStaticId = 1240025,
		BossStaticId = T.RT_11,
		BossUnitId = T.RT_15,
		DifficultyId = 1023,
		DungeonId = 50303,
		HardBossId = 3,
		PreparingAirWallStaticId = 1240026,
	},
	[50304] = {
		AirWallStaticId = 1240025,
		BossStaticId = T.RT_11,
		BossUnitId = T.RT_15,
		DifficultyId = 1024,
		DungeonId = 50304,
		HardBossId = 3,
		PreparingAirWallStaticId = 1240026,
	},
	[50305] = {
		AirWallStaticId = 1240025,
		BossStaticId = T.RT_11,
		BossUnitId = T.RT_15,
		DifficultyId = 1025,
		DungeonId = 50305,
		HardBossId = 3,
		PreparingAirWallStaticId = 1240026,
	},
	[50306] = {
		AirWallStaticId = 1240025,
		BossStaticId = T.RT_11,
		BossUnitId = T.RT_15,
		DifficultyId = 1026,
		DungeonId = 50306,
		HardBossId = 3,
		PreparingAirWallStaticId = 1240026,
	},
	[50401] = {
		AirWallStaticId = 1660120,
		BossStaticId = T.RT_16,
		BossUnitId = T.RT_20,
		DifficultyId = 1031,
		DungeonId = 50401,
		HardBossId = 4,
		PreparingAirWallStaticId = 1660123,
	},
	[50402] = {
		AirWallStaticId = 1660120,
		BossStaticId = T.RT_16,
		BossUnitId = T.RT_20,
		DifficultyId = 1032,
		DungeonId = 50402,
		HardBossId = 4,
		PreparingAirWallStaticId = 1660123,
	},
	[50403] = {
		AirWallStaticId = 1660120,
		BossStaticId = T.RT_16,
		BossUnitId = T.RT_20,
		DifficultyId = 1033,
		DungeonId = 50403,
		HardBossId = 4,
		PreparingAirWallStaticId = 1660123,
	},
	[50404] = {
		AirWallStaticId = 1660120,
		BossStaticId = T.RT_16,
		BossUnitId = T.RT_20,
		DifficultyId = 1034,
		DungeonId = 50404,
		HardBossId = 4,
		PreparingAirWallStaticId = 1660123,
	},
	[50405] = {
		AirWallStaticId = 1660120,
		BossStaticId = T.RT_16,
		BossUnitId = T.RT_20,
		DifficultyId = 1035,
		DungeonId = 50405,
		HardBossId = 4,
		PreparingAirWallStaticId = 1660123,
	},
	[50406] = {
		AirWallStaticId = 1660120,
		BossStaticId = T.RT_16,
		BossUnitId = T.RT_20,
		DifficultyId = 1036,
		DungeonId = 50406,
		HardBossId = 4,
		PreparingAirWallStaticId = 1660123,
	},
	[50501] = {
		AirWallStaticId = 1969947,
		BossStaticId = T.RT_21,
		BossUnitId = T.RT_25,
		DifficultyId = 1041,
		DungeonId = 50501,
		HardBossId = 5,
		PreparingAirWallStaticId = 1969948,
	},
	[50502] = {
		AirWallStaticId = 1969947,
		BossStaticId = T.RT_21,
		BossUnitId = T.RT_25,
		DifficultyId = 1042,
		DungeonId = 50502,
		HardBossId = 5,
		PreparingAirWallStaticId = 1969948,
	},
	[50503] = {
		AirWallStaticId = 1969947,
		BossStaticId = T.RT_21,
		BossUnitId = T.RT_25,
		DifficultyId = 1043,
		DungeonId = 50503,
		HardBossId = 5,
		PreparingAirWallStaticId = 1969948,
	},
	[50504] = {
		AirWallStaticId = 1969947,
		BossStaticId = T.RT_21,
		BossUnitId = T.RT_25,
		DifficultyId = 1044,
		DungeonId = 50504,
		HardBossId = 5,
		PreparingAirWallStaticId = 1969948,
	},
	[50505] = {
		AirWallStaticId = 1969947,
		BossStaticId = T.RT_21,
		BossUnitId = T.RT_25,
		DifficultyId = 1045,
		DungeonId = 50505,
		HardBossId = 5,
		PreparingAirWallStaticId = 1969948,
	},
	[50506] = {
		AirWallStaticId = 1969947,
		BossStaticId = T.RT_21,
		BossUnitId = T.RT_25,
		DifficultyId = 1046,
		DungeonId = 50506,
		HardBossId = 5,
		PreparingAirWallStaticId = 1969948,
	},
	[50601] = {
		AirWallStaticId = 302720002,
		BossStaticId = T.RT_26,
		BossUnitId = T.RT_28,
		DifficultyId = 1051,
		DungeonId = 50601,
		HardBossId = 6,
		PreparingAirWallStaticId = 302720003,
	},
	[50602] = {
		AirWallStaticId = 302720002,
		BossStaticId = T.RT_26,
		BossUnitId = T.RT_28,
		DifficultyId = 1052,
		DungeonId = 50602,
		HardBossId = 6,
		PreparingAirWallStaticId = 302720003,
	},
	[50603] = {
		AirWallStaticId = 302720002,
		BossStaticId = T.RT_26,
		BossUnitId = T.RT_28,
		DifficultyId = 1053,
		DungeonId = 50603,
		HardBossId = 6,
		PreparingAirWallStaticId = 302720003,
	},
	[50604] = {
		AirWallStaticId = 302720002,
		BossStaticId = T.RT_26,
		BossUnitId = T.RT_28,
		DifficultyId = 1054,
		DungeonId = 50604,
		HardBossId = 6,
		PreparingAirWallStaticId = 302720003,
	},
	[50605] = {
		AirWallStaticId = 302720002,
		BossStaticId = T.RT_26,
		BossUnitId = T.RT_28,
		DifficultyId = 1055,
		DungeonId = 50605,
		HardBossId = 6,
		PreparingAirWallStaticId = 302720003,
	},
	[50606] = {
		AirWallStaticId = 302720002,
		BossStaticId = T.RT_26,
		BossUnitId = T.RT_28,
		DifficultyId = 1056,
		DungeonId = 50606,
		HardBossId = 6,
		PreparingAirWallStaticId = 302720003,
	},
})