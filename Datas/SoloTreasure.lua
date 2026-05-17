-- Source Excel file path: ..\datas\Dungeons\SoloTreasure.xlsx
local T = {}
T.RT_1 = {
		88101,
		88201,
	}
T.RT_2 = {
		7180001,
		7180002,
		7230101,
	}
T.RT_3 = {
		88111,
		88212,
	}
T.RT_4 = {
		7180015,
		7180016,
		7230103,
	}
T.RT_5 = {
		88102,
		88202,
	}
T.RT_6 = {
		7180013,
		7180014,
		7230102,
	}
T.RT_7 = {
		88112,
		88212,
	}
T.RT_8 = {
		7180017,
		7180018,
		7230104,
	}
T.RT_9 = {
		88113,
		88213,
	}
T.RT_10 = {
		7180302,
		7180309,
		7180310,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SoloTreasure", {
	[41801] = {
		DifficultyDesc = "UI_SoloTreasure_NormalMode",
		DungeonId = 41801,
		EvacuationTime = 10,
		GamePlayId = T.RT_1,
		GameTotalTime = 600,
		RainyRandomId = T.RT_2,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41802] = {
		DifficultyDesc = "UI_SoloTreasure_NormalMode",
		DungeonId = 41802,
		EvacuationTime = 10,
		GamePlayId = T.RT_1,
		GameTotalTime = 600,
		RainyRandomId = T.RT_2,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41803] = {
		DifficultyDesc = "UI_SoloTreasure_HardMode",
		DungeonId = 41803,
		EvacuationTime = 10,
		GamePlayId = T.RT_3,
		GameTotalTime = 600,
		RainyRandomId = T.RT_4,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41804] = {
		DifficultyDesc = "UI_SoloTreasure_HardMode",
		DungeonId = 41804,
		EvacuationTime = 10,
		GamePlayId = T.RT_3,
		GameTotalTime = 600,
		RainyRandomId = T.RT_4,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41805] = {
		DifficultyDesc = "UI_SoloTreasure_NormalMode",
		DungeonId = 41805,
		EvacuationTime = 10,
		GamePlayId = T.RT_5,
		GameTotalTime = 600,
		RainyRandomId = T.RT_6,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41806] = {
		DifficultyDesc = "UI_SoloTreasure_NormalMode",
		DungeonId = 41806,
		EvacuationTime = 10,
		GamePlayId = T.RT_5,
		GameTotalTime = 600,
		RainyRandomId = T.RT_6,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41807] = {
		DifficultyDesc = "UI_SoloTreasure_HardMode",
		DungeonId = 41807,
		EvacuationTime = 10,
		GamePlayId = T.RT_7,
		GameTotalTime = 600,
		RainyRandomId = T.RT_8,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41808] = {
		DifficultyDesc = "UI_SoloTreasure_HardMode",
		DungeonId = 41808,
		EvacuationTime = 10,
		GamePlayId = T.RT_7,
		GameTotalTime = 600,
		RainyRandomId = T.RT_8,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41809] = {
		DifficultyDesc = "UI_SoloTreasure_HardMode",
		DungeonId = 41809,
		EvacuationTime = 10,
		GamePlayId = T.RT_9,
		GameTotalTime = 600,
		RainyRandomId = T.RT_10,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41810] = {
		DifficultyDesc = "UI_SoloTreasure_HardMode",
		DungeonId = 41810,
		EvacuationTime = 10,
		GamePlayId = T.RT_9,
		GameTotalTime = 600,
		RainyRandomId = T.RT_10,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41811] = {
		DifficultyDesc = "UI_SoloTreasure_NormalMode",
		DungeonId = 41811,
		EvacuationTime = 10,
		GamePlayId = {
			88104,
			88204,
		},
		GameTotalTime = 600,
		RainyRandomId = {
			7180312,
			7180319,
			7180320,
		},
		TurnRainyTime = 420,
		WarningTime = 60,
	},
	[41812] = {
		DifficultyDesc = "UI_SoloTreasure_HardMode",
		DungeonId = 41812,
		EvacuationTime = 10,
		GamePlayId = {
			88114,
			88214,
		},
		GameTotalTime = 600,
		RainyRandomId = T.RT_10,
		TurnRainyTime = 420,
		WarningTime = 60,
	},
})