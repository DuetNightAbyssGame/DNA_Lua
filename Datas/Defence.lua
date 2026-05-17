-- Source Excel file path: ..\datas\Dungeons\Defence.xlsx
local T = {}
T.RT_1 = {
		301,
	}
T.RT_2 = {
		302,
		307,
	}
T.RT_3 = {
		303,
	}
T.RT_4 = {
		304,
		307,
	}
T.RT_5 = {
		305,
	}
T.RT_6 = {
		306,
		308,
	}
T.RT_7 = {
		[1] = T.RT_1,
		[2] = T.RT_2,
		[3] = T.RT_3,
		[4] = T.RT_4,
		[5] = T.RT_5,
		[6] = T.RT_6,
	}
T.RT_8 = {
		0.9,
		0.1,
	}
T.RT_9 = {
		100302,
	}
T.RT_10 = {
		100304,
	}
T.RT_11 = {
		100306,
		91134,
	}
T.RT_12 = {
		[1] = T.RT_9,
		[2] = T.RT_10,
		[3] = T.RT_11,
	}
T.RT_13 = {
		0.6,
		0.2,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("Defence", {
	[20002] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = {
			0.5,
			0.1,
		},
		DungeonId = 20002,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[30101] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 30101,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[30102] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 30102,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[30103] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 30103,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[30104] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 30104,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[30105] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 30105,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[30106] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 30106,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[30107] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 30107,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_12,
		MonsterTotalBaseNum = 15,
	},
	[30108] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 30108,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_12,
		MonsterTotalBaseNum = 15,
	},
	[60101] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 4,
		ButcherMonsterSpawnProbability = T.RT_13,
		DungeonId = 60101,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[60102] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 60102,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[62101] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 4,
		ButcherMonsterSpawnProbability = T.RT_13,
		DungeonId = 62101,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[62102] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 62102,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[64101] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 4,
		ButcherMonsterSpawnProbability = T.RT_13,
		DungeonId = 64101,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[64102] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 64102,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[90102] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = {
			0,
			0,
		},
		DungeonId = 90102,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[90104] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 4,
		ButcherMonsterSpawnProbability = T.RT_13,
		DungeonId = 90104,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[90106] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 90106,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[90108] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 90108,
		EnsureGuideTime = -1,
		MonsterSpawnId = {
			[1] = {
				100301,
			},
			[2] = {
				100302,
				100307,
			},
			[3] = {
				100303,
			},
			[4] = {
				100304,
				100307,
			},
			[5] = {
				100305,
			},
			[6] = {
				100306,
				100308,
			},
		},
		MonsterTotalBaseNum = 15,
	},
	[90110] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 90110,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[90112] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 90112,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[90114] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 90114,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_7,
		MonsterTotalBaseNum = 15,
	},
	[91134] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91134,
		EnsureGuideTime = -1,
		MonsterSpawnId = T.RT_12,
		MonsterTotalBaseNum = 15,
	},
	[91135] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91135,
		EnsureGuideTime = -1,
		MonsterSpawnId = {
			[1] = T.RT_9,
			[2] = T.RT_10,
			[3] = {
				100306,
				91135,
			},
		},
		MonsterTotalBaseNum = 15,
	},
	[91146] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91146,
		EnsureGuideTime = -1,
		MonsterSpawnId = {
			[1] = T.RT_9,
			[2] = T.RT_10,
			[3] = {
				100306,
				91146,
			},
		},
		MonsterTotalBaseNum = 15,
	},
	[91147] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91147,
		EnsureGuideTime = -1,
		MonsterSpawnId = {
			[1] = T.RT_9,
			[2] = T.RT_10,
			[3] = {
				100306,
				91147,
			},
		},
		MonsterTotalBaseNum = 15,
	},
	[91150] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91150,
		EnsureGuideTime = -1,
		MonsterSpawnId = {
			[1] = T.RT_9,
			[2] = T.RT_10,
			[3] = {
				100306,
				91150,
			},
		},
		MonsterTotalBaseNum = 15,
	},
	[91183] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91183,
		EnsureGuideTime = 60,
		MonsterSpawnId = {
			[1] = {
				100309,
				91183,
				911831,
			},
			[2] = {
				100310,
				91183,
				911831,
			},
			[3] = {
				100311,
				911830,
			},
		},
		MonsterTotalBaseNum = 80,
	},
	[91184] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91184,
		EnsureGuideTime = 60,
		MonsterSpawnId = {
			[1] = {
				100309,
				91184,
				911841,
			},
			[2] = {
				100310,
				91184,
				911841,
			},
			[3] = {
				100311,
				911840,
			},
		},
		MonsterTotalBaseNum = 80,
	},
	[91187] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91187,
		EnsureGuideTime = -1,
		MonsterSpawnId = {
			[1] = T.RT_9,
			[2] = T.RT_10,
			[3] = {
				100306,
				91187,
			},
		},
		MonsterTotalBaseNum = 15,
	},
	[91208] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91208,
		EnsureGuideTime = 60,
		MonsterSpawnId = {
			[1] = {
				100309,
				91208,
				912081,
			},
			[2] = {
				100310,
				91208,
				912081,
			},
			[3] = {
				100311,
				912080,
			},
		},
		MonsterTotalBaseNum = 80,
	},
	[91209] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91209,
		EnsureGuideTime = 60,
		MonsterSpawnId = {
			[1] = {
				100309,
				91209,
				912091,
			},
			[2] = {
				100310,
				91209,
				912091,
			},
			[3] = {
				100311,
				912090,
			},
		},
		MonsterTotalBaseNum = 80,
	},
	[91212] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91212,
		EnsureGuideTime = 60,
		MonsterSpawnId = {
			[1] = {
				100309,
				91212,
				912121,
			},
			[2] = {
				100310,
				91212,
				912121,
			},
			[3] = {
				100311,
				912120,
			},
		},
		MonsterTotalBaseNum = 80,
	},
	[91213] = {
		ButcherMonsterId = 8501002,
		ButcherMonsterSpawnMinWave = 2,
		ButcherMonsterSpawnProbability = T.RT_8,
		DungeonId = 91213,
		EnsureGuideTime = 60,
		MonsterSpawnId = {
			[1] = {
				100309,
				91213,
				912131,
			},
			[2] = {
				100310,
				91213,
				912131,
			},
			[3] = {
				100311,
				912130,
			},
		},
		MonsterTotalBaseNum = 80,
	},
})