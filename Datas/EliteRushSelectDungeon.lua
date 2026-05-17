-- Source Excel file path: ..\datas\GameEvent\DoubleModDrop.xlsx
local T = {}
T.RT_1 = {
		160,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("EliteRushSelectDungeon", {
	UI_DungeonMod_Tab_20 = {
		MonRewardIdList = {
			11001,
			11002,
			11003,
			11004,
			12001,
			12002,
		},
		Name = "UI_DungeonMod_Tab_20",
		Sequence = 20,
	},
	UI_DungeonMod_Tab_30 = {
		Condition = {
			112,
		},
		MonRewardIdList = {
			13001,
			13002,
			13003,
			13004,
		},
		Name = "UI_DungeonMod_Tab_30",
		Sequence = 30,
	},
	UI_DungeonMod_Tab_40 = {
		Condition = {
			125,
		},
		MonRewardIdList = {
			14001,
			14002,
			14003,
			14004,
			14005,
		},
		Name = "UI_DungeonMod_Tab_40",
		Sequence = 40,
	},
	UI_DungeonMod_Tab_50 = {
		Condition = {
			130,
		},
		MonRewardIdList = {
			15001,
			15002,
			15003,
			15004,
			15005,
			15006,
		},
		Name = "UI_DungeonMod_Tab_50",
		Sequence = 50,
	},
	UI_DungeonMod_Tab_55 = {
		Condition = {
			135,
		},
		MonRewardIdList = {
			15501,
			15502,
			15503,
			15504,
			15505,
			15506,
		},
		Name = "UI_DungeonMod_Tab_55",
		Sequence = 60,
	},
	UI_DungeonMod_Tab_60 = {
		Condition = {
			140,
		},
		MonRewardIdList = {
			16001,
			16002,
			16003,
			16004,
			16005,
			16006,
			16007,
			16008,
			16009,
			16010,
			16011,
			16012,
		},
		Name = "UI_DungeonMod_Tab_60",
		Sequence = 70,
	},
	UI_DungeonMod_Tab_65 = {
		Condition = {
			145,
		},
		MonRewardIdList = {
			16501,
			16502,
			16503,
			16504,
			16505,
			16506,
			16507,
			16508,
			16509,
		},
		Name = "UI_DungeonMod_Tab_65",
		Sequence = 80,
	},
	UI_DungeonMod_Tab_70 = {
		Condition = {
			155,
		},
		MonRewardIdList = {
			17001,
			17002,
			17003,
			17004,
			17005,
			17006,
			17007,
		},
		Name = "UI_DungeonMod_Tab_70",
		Sequence = 90,
	},
	UI_DungeonMod_Tab_75 = {
		Condition = T.RT_1,
		MonRewardIdList = {
			18001,
			18002,
			18003,
			18004,
			18005,
			18006,
			18007,
			18008,
			18009,
		},
		Name = "UI_DungeonMod_Tab_75",
		Sequence = 100,
	},
	UI_DungeonMod_Tab_80 = {
		Condition = T.RT_1,
		MonRewardIdList = {
			18010,
			18011,
			18012,
			18013,
		},
		Name = "UI_DungeonMod_Tab_80",
		Sequence = 110,
	},
})