-- Source Excel file path: ..\datas\PreloadCommonAsset.xlsx
local T = {}
T.RT_1 = {
		Path = "WidgetBlueprint'/Game/UI/WBP/Dungeon/Defense/WBP_Dungeon_DefenseWaveStart.WBP_Dungeon_DefenseWaveStart'",
	}
T.RT_2 = {
		[1] = T.RT_1,
	}
T.RT_3 = {
		Path = "WidgetBlueprint'/Game/UI/WBP/Dungeon/Excavation/WBP_Dungeon_ExcavationToast_New.WBP_Dungeon_ExcavationToast_New'",
	}
T.RT_4 = {
		[1] = T.RT_3,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CommonAssetByDungeon", {
	[1] = {
		AssetPath = {
			[1] = {
				Path = "/Game/AssetDesign/AI/Z_Misc_Test/BT/TestNew.TestNew",
			},
		},
		DungeonId = 1,
	},
	[60101] = {
		AssetPath = T.RT_2,
		DungeonId = 60101,
	},
	[60102] = {
		AssetPath = T.RT_2,
		DungeonId = 60102,
	},
	[62101] = {
		AssetPath = T.RT_2,
		DungeonId = 62101,
	},
	[62102] = {
		AssetPath = T.RT_2,
		DungeonId = 62102,
	},
	[64101] = {
		AssetPath = T.RT_2,
		DungeonId = 64101,
	},
	[64102] = {
		AssetPath = T.RT_2,
		DungeonId = 64102,
	},
	[90102] = {
		AssetPath = T.RT_2,
		DungeonId = 90102,
	},
	[90104] = {
		AssetPath = T.RT_2,
		DungeonId = 90104,
	},
	[90106] = {
		AssetPath = T.RT_2,
		DungeonId = 90106,
	},
	[90108] = {
		AssetPath = T.RT_2,
		DungeonId = 90108,
	},
	[90110] = {
		AssetPath = T.RT_2,
		DungeonId = 90110,
	},
	[90112] = {
		AssetPath = T.RT_2,
		DungeonId = 90112,
	},
	[90114] = {
		AssetPath = T.RT_2,
		DungeonId = 90114,
	},
	[90201] = {
		AssetPath = T.RT_4,
		DungeonId = 90201,
	},
	[90202] = {
		AssetPath = T.RT_4,
		DungeonId = 90202,
	},
	[90203] = {
		AssetPath = T.RT_4,
		DungeonId = 90203,
	},
	[90204] = {
		AssetPath = T.RT_4,
		DungeonId = 90204,
	},
	[90205] = {
		AssetPath = T.RT_4,
		DungeonId = 90205,
	},
	[90206] = {
		AssetPath = T.RT_4,
		DungeonId = 90206,
	},
	[90207] = {
		AssetPath = T.RT_4,
		DungeonId = 90207,
	},
})