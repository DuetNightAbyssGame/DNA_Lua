-- Source Excel file path: ..\datas\GameEvent\WuyoushengEvent.xlsx
local T = {}
T.RT_1 = {
		-1,
		240,
		180,
	}
T.RT_2 = {
		601,
		602,
		603,
		604,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WuyoushengEventLevel", {
	[22001] = {
		DungeonId = 22001,
		EventId = 110001,
		LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_0",
		LevelDes = "MonsterRushEvent_Wuyou_DungeonDes01",
		LevelGoalRequiredTime1 = T.RT_1,
		LevelIconLetter = "j",
		LevelName = "MonsterRushEvent_Wuyou_DungeonName01",
		LevelPet = {
			603,
		},
		LevelTriaRangedlWeapon = {
			91000012,
			91000013,
			91000014,
		},
		LevelTrialChar = {
			90000011,
			90000012,
			90000013,
		},
		LevelTrialMeleeWeapon = {
			91000011,
		},
		UnlockDate = LocalTimeProxy(1772157600),
	},
	[22002] = {
		DungeonId = 22002,
		EventId = 110001,
		LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_0",
		LevelDes = "MonsterRushEvent_Wuyou_DungeonDes02",
		LevelGoalRequiredTime1 = T.RT_1,
		LevelIconLetter = "y",
		LevelName = "MonsterRushEvent_Wuyou_DungeonName02",
		LevelPet = {
			603,
			604,
		},
		LevelTriaRangedlWeapon = {
			91000022,
		},
		LevelTrialChar = {
			90000021,
			90000022,
			90000023,
		},
		LevelTrialMeleeWeapon = {
			91000021,
			91000023,
			91000024,
		},
		PerviousDungeon = 22001,
		UnlockDate = LocalTimeProxy(1772244000),
	},
	[22003] = {
		DungeonId = 22003,
		EventId = 110001,
		LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_0",
		LevelDes = "MonsterRushEvent_Wuyou_DungeonDes03",
		LevelGoalRequiredTime1 = T.RT_1,
		LevelIconLetter = "b",
		LevelName = "MonsterRushEvent_Wuyou_DungeonName03",
		LevelPet = {
			601,
			603,
			604,
		},
		LevelTriaRangedlWeapon = {
			91000032,
		},
		LevelTrialChar = {
			90000041,
			90000042,
			90000043,
		},
		LevelTrialMeleeWeapon = {
			91000031,
			91000033,
			91000034,
		},
		PerviousDungeon = 22002,
		UnlockDate = LocalTimeProxy(1772330400),
	},
	[22004] = {
		DungeonId = 22004,
		EventId = 110001,
		LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_2",
		LevelDes = "MonsterRushEvent_Wuyou_DungeonDes04",
		LevelGoalRequiredTime1 = T.RT_1,
		LevelIconLetter = "d",
		LevelName = "MonsterRushEvent_Wuyou_DungeonName04",
		LevelPet = T.RT_2,
		LevelTriaRangedlWeapon = {
			91000052,
			91000053,
			91000054,
		},
		LevelTrialChar = {
			90000061,
			90000062,
			90000063,
		},
		LevelTrialMeleeWeapon = {
			91000051,
		},
		PerviousDungeon = 22003,
		UnlockDate = LocalTimeProxy(1772416800),
	},
	[22005] = {
		DungeonId = 22005,
		EventId = 110001,
		LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_1",
		LevelDes = "MonsterRushEvent_Wuyou_DungeonDes05",
		LevelGoalRequiredTime1 = T.RT_1,
		LevelIconLetter = "w",
		LevelName = "MonsterRushEvent_Wuyou_DungeonName05",
		LevelPet = T.RT_2,
		LevelTriaRangedlWeapon = {
			91000042,
		},
		LevelTrialChar = {
			90000051,
			90000052,
			90000053,
		},
		LevelTrialMeleeWeapon = {
			91000041,
			91000043,
			91000044,
		},
		PerviousDungeon = 22004,
		UnlockDate = LocalTimeProxy(1772503200),
	},
	[22006] = {
		DungeonId = 22006,
		EventId = 110001,
		LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_3",
		LevelDes = "MonsterRushEvent_Wuyou_DungeonDes06",
		LevelGoalRequiredTime1 = T.RT_1,
		LevelIconLetter = "j",
		LevelName = "MonsterRushEvent_Wuyou_DungeonName06",
		LevelPet = T.RT_2,
		LevelTriaRangedlWeapon = {
			91000062,
			91000063,
			91000064,
		},
		LevelTrialChar = {
			90000071,
			90000072,
			90000073,
		},
		LevelTrialMeleeWeapon = {
			91000061,
		},
		PerviousDungeon = 22005,
		UnlockDate = LocalTimeProxy(1772589600),
	},
	[22007] = {
		DungeonId = 22007,
		EventId = 110001,
		LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_4",
		LevelDes = "MonsterRushEvent_Wuyou_DungeonDes07",
		LevelGoalRequiredTime1 = T.RT_1,
		LevelIconLetter = "g",
		LevelName = "MonsterRushEvent_Wuyou_DungeonName07",
		LevelPet = T.RT_2,
		LevelTriaRangedlWeapon = {
			91000072,
		},
		LevelTrialChar = {
			90000081,
			90000082,
			90000083,
		},
		LevelTrialMeleeWeapon = {
			91000071,
			91000073,
			91000074,
		},
		PerviousDungeon = 22006,
		UnlockDate = LocalTimeProxy(1772676000),
	},
})