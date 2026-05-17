-- Source Excel file path: ..\datas\Combat\BattleCharUI.xlsx
local T = {}
T.RT_1 = {
		MaxSummonerCount = 3,
		SummonerId = 210101,
	}
T.RT_2 = {
		0,
		1,
	}
T.RT_3 = {
		ID = 1,
		Params = T.RT_1,
		ScaleNode = "Main",
		SkillGrade = T.RT_2,
		UIName = "UISkillShuimu",
	}
T.RT_4 = {
		MaxSummonerCount = 5,
		SummonerId = 210101,
	}
T.RT_5 = {
		2,
		3,
		4,
		5,
		6,
	}
T.RT_6 = {
		ID = 1,
		Params = T.RT_4,
		ScaleNode = "Main",
		SkillGrade = T.RT_5,
		UIName = "UISkillShuimu",
	}
T.RT_7 = {
		SpecialUI = 0,
	}
T.RT_8 = {
		ID = 10,
		Params = T.RT_7,
		ScaleNode = "Main",
		SkillGrade = T.RT_2,
		UIName = "UISkillXibi",
	}
T.RT_9 = {
		SpecialUI = 1,
	}
T.RT_10 = {
		ID = 10,
		Params = T.RT_9,
		ScaleNode = "Main",
		SkillGrade = T.RT_5,
		UIName = "UISkillXibi",
	}
T.RT_11 = {
		0,
		1,
		2,
		3,
		4,
		5,
		6,
	}
T.RT_12 = {
		ID = 11,
		SkillGrade = T.RT_11,
		TriggerBuffId = 3,
		UIName = "UISkillNvzhu",
	}
T.RT_13 = {
		[180131] = 1,
		[180132] = 2,
		[180133] = 3,
		[180134] = 4,
		[180135] = 1,
		[180136] = 2,
		[180137] = 3,
		[180138] = 4,
	}
T.RT_14 = {
		ID = 12,
		Params = T.RT_13,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillFeina",
	}
T.RT_15 = {
		SummonerId = 420201,
	}
T.RT_16 = {
		ID = 13,
		Params = T.RT_15,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		TriggerBuffId = 420211,
		UIName = "UISkillLandi",
	}
T.RT_17 = {
		MaxSummonerCount = 2,
		UnitId = 240101,
	}
T.RT_18 = {
		ID = 14,
		Params = T.RT_17,
		ScaleNode = "Main",
		SkillGrade = T.RT_2,
		UIName = "UISKillFushu",
	}
T.RT_19 = {
		MaxSummonerCount = 3,
		UnitId = 240101,
	}
T.RT_20 = {
		ID = 14,
		Params = T.RT_19,
		ScaleNode = "Main",
		SkillGrade = T.RT_5,
		UIName = "UISKillFushu",
	}
T.RT_21 = {
		ID = 16,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillLise",
	}
T.RT_22 = {
		ID = 17,
		SkillGrade = T.RT_11,
		TriggerBuffDelay = 1.5,
		TriggerBuffId = 110302,
		UIName = "UISkill2Tuosi",
	}
T.RT_23 = {
		FireBuffId = 110331,
	}
T.RT_24 = {
		ID = 18,
		Params = T.RT_23,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillTuosi",
	}
T.RT_25 = {
		PassiveEffectId = 410201,
		ThunderBuffId = 410201,
		WindBuffId = 410202,
	}
T.RT_26 = {
		ID = 19,
		Params = T.RT_25,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillZhiliu",
	}
T.RT_27 = {
		ID = 2,
		SkillGrade = T.RT_11,
		TriggerBuffDelay = 0.8,
		TriggerBuffId = 110101,
		UIName = "UISkillSpade",
	}
T.RT_28 = {
		SummonId = 310202,
	}
T.RT_29 = {
		ID = 20,
		Params = T.RT_28,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillXier",
	}
T.RT_30 = {
		MeleeBuffId = 150307,
		MeleeWeakBuffId = 150325,
		RangedBuffId = 150308,
	}
T.RT_31 = {
		1,
		2,
		3,
		4,
		5,
		6,
	}
T.RT_32 = {
		ID = 21,
		Params = T.RT_30,
		ScaleNode = "Main",
		SkillGrade = T.RT_31,
		UIName = "UISkillKezhou",
	}
T.RT_33 = {
		ID = 23,
		SkillGrade = T.RT_11,
		UIName = "UISkillSaqiUltiSkin1",
	}
T.RT_34 = {
		FlashLevel = 1,
	}
T.RT_35 = {
		ID = 24,
		Params = T.RT_34,
		SkillGrade = T.RT_11,
		TriggerBuffId = 240151,
		UIName = "UIFushuNearDeath",
	}
T.RT_36 = {
		FlashLevel = 2,
	}
T.RT_37 = {
		ID = 25,
		Params = T.RT_36,
		SkillGrade = T.RT_11,
		TriggerBuffId = 240152,
		UIName = "UIFushuNearDeath",
	}
T.RT_38 = {
		FlashLevel = 3,
	}
T.RT_39 = {
		ID = 26,
		Params = T.RT_38,
		SkillGrade = T.RT_11,
		TriggerBuffId = 240153,
		UIName = "UIFushuNearDeath",
	}
T.RT_40 = {
		ID = 27,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillLise",
	}
T.RT_41 = {
		BuffId = 150101,
	}
T.RT_42 = {
		ID = 28,
		Params = T.RT_41,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillBaonu",
	}
T.RT_43 = {
		CreatureId = 320202,
	}
T.RT_44 = {
		ID = 29,
		Params = T.RT_43,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillKami",
	}
T.RT_45 = {
		ID = 3,
		SkillGrade = T.RT_11,
		TriggerBuffId = 530101,
		UIName = "UISkillSaqiUlti",
	}
T.RT_46 = {
		ID = 30,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillSuyi",
	}
T.RT_47 = {
		ID = 31,
		SkillGrade = T.RT_11,
		TriggerBuffId = 150401,
		UIName = "UISkillSuyiUlti",
	}
T.RT_48 = {
		ID = 32,
		Params = T.RT_38,
		SkillGrade = T.RT_11,
		TriggerBuffId = 9000201,
		UIName = "UIFushuNearDeath",
	}
T.RT_49 = {
		ID = 33,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillSuyi01",
	}
T.RT_50 = {
		ID = 34,
		SkillGrade = T.RT_11,
		UIName = "UISkillSuyiUlti01",
	}
T.RT_51 = {
		ID = 35,
		SkillGrade = T.RT_11,
		TriggerBuffId = 320232,
		UIName = "UISkillKamiUlti",
	}
T.RT_52 = {
		EnhancedReloadBuffId = 310131,
		FirepowerSuppressionBuffId = 310132,
	}
T.RT_53 = {
		ID = 4,
		Params = T.RT_52,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillLinen",
	}
T.RT_54 = {
		RideBuff = 510121,
		SummonerId = 510101,
	}
T.RT_55 = {
		ID = 5,
		Params = T.RT_54,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillSonglu",
	}
T.RT_56 = {
		SummonerId = 420101,
	}
T.RT_57 = {
		ID = 6,
		Params = T.RT_56,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		UIName = "UISkillHeilong",
	}
T.RT_58 = {
		ID = 7,
		ScaleNode = "Main",
		SkillGrade = T.RT_11,
		TriggerBuffId = 310122,
		UIName = "UISkill2Linen",
	}
T.RT_59 = {
		ID = 8,
		SkillGrade = T.RT_11,
		TriggerBuffId = 850405,
		UIName = "UISkillSaqiUlti",
	}
T.RT_60 = {
		ID = 9,
		SkillGrade = T.RT_11,
		TriggerBuffId = 310301,
		UIName = "UISkilYeerUlti",
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("BattleCharUI", {
	[1] = {
		[0] = T.RT_3,
		[1] = T.RT_3,
		[2] = T.RT_6,
		[3] = T.RT_6,
		[4] = T.RT_6,
		[5] = T.RT_6,
		[6] = T.RT_6,
	},
	[2] = {
		[0] = T.RT_27,
		[1] = T.RT_27,
		[2] = T.RT_27,
		[3] = T.RT_27,
		[4] = T.RT_27,
		[5] = T.RT_27,
		[6] = T.RT_27,
	},
	[3] = {
		[0] = T.RT_45,
		[1] = T.RT_45,
		[2] = T.RT_45,
		[3] = T.RT_45,
		[4] = T.RT_45,
		[5] = T.RT_45,
		[6] = T.RT_45,
	},
	[4] = {
		[0] = T.RT_53,
		[1] = T.RT_53,
		[2] = T.RT_53,
		[3] = T.RT_53,
		[4] = T.RT_53,
		[5] = T.RT_53,
		[6] = T.RT_53,
	},
	[5] = {
		[0] = T.RT_55,
		[1] = T.RT_55,
		[2] = T.RT_55,
		[3] = T.RT_55,
		[4] = T.RT_55,
		[5] = T.RT_55,
		[6] = T.RT_55,
	},
	[6] = {
		[0] = T.RT_57,
		[1] = T.RT_57,
		[2] = T.RT_57,
		[3] = T.RT_57,
		[4] = T.RT_57,
		[5] = T.RT_57,
		[6] = T.RT_57,
	},
	[7] = {
		[0] = T.RT_58,
		[1] = T.RT_58,
		[2] = T.RT_58,
		[3] = T.RT_58,
		[4] = T.RT_58,
		[5] = T.RT_58,
		[6] = T.RT_58,
	},
	[8] = {
		[0] = T.RT_59,
		[1] = T.RT_59,
		[2] = T.RT_59,
		[3] = T.RT_59,
		[4] = T.RT_59,
		[5] = T.RT_59,
		[6] = T.RT_59,
	},
	[9] = {
		[0] = T.RT_60,
		[1] = T.RT_60,
		[2] = T.RT_60,
		[3] = T.RT_60,
		[4] = T.RT_60,
		[5] = T.RT_60,
		[6] = T.RT_60,
	},
	[10] = {
		[0] = T.RT_8,
		[1] = T.RT_8,
		[2] = T.RT_10,
		[3] = T.RT_10,
		[4] = T.RT_10,
		[5] = T.RT_10,
		[6] = T.RT_10,
	},
	[11] = {
		[0] = T.RT_12,
		[1] = T.RT_12,
		[2] = T.RT_12,
		[3] = T.RT_12,
		[4] = T.RT_12,
		[5] = T.RT_12,
		[6] = T.RT_12,
	},
	[12] = {
		[0] = T.RT_14,
		[1] = T.RT_14,
		[2] = T.RT_14,
		[3] = T.RT_14,
		[4] = T.RT_14,
		[5] = T.RT_14,
		[6] = T.RT_14,
	},
	[13] = {
		[0] = T.RT_16,
		[1] = T.RT_16,
		[2] = T.RT_16,
		[3] = T.RT_16,
		[4] = T.RT_16,
		[5] = T.RT_16,
		[6] = T.RT_16,
	},
	[14] = {
		[0] = T.RT_18,
		[1] = T.RT_18,
		[2] = T.RT_20,
		[3] = T.RT_20,
		[4] = T.RT_20,
		[5] = T.RT_20,
		[6] = T.RT_20,
	},
	[16] = {
		[0] = T.RT_21,
		[1] = T.RT_21,
		[2] = T.RT_21,
		[3] = T.RT_21,
		[4] = T.RT_21,
		[5] = T.RT_21,
		[6] = T.RT_21,
	},
	[17] = {
		[0] = T.RT_22,
		[1] = T.RT_22,
		[2] = T.RT_22,
		[3] = T.RT_22,
		[4] = T.RT_22,
		[5] = T.RT_22,
		[6] = T.RT_22,
	},
	[18] = {
		[0] = T.RT_24,
		[1] = T.RT_24,
		[2] = T.RT_24,
		[3] = T.RT_24,
		[4] = T.RT_24,
		[5] = T.RT_24,
		[6] = T.RT_24,
	},
	[19] = {
		[0] = T.RT_26,
		[1] = T.RT_26,
		[2] = T.RT_26,
		[3] = T.RT_26,
		[4] = T.RT_26,
		[5] = T.RT_26,
		[6] = T.RT_26,
	},
	[20] = {
		[0] = T.RT_29,
		[1] = T.RT_29,
		[2] = T.RT_29,
		[3] = T.RT_29,
		[4] = T.RT_29,
		[5] = T.RT_29,
		[6] = T.RT_29,
	},
	[21] = {
		[0] = {
			ID = 21,
			Params = {
				MeleeBuffId = 150301,
				MeleeWeakBuffId = 150325,
				RangedBuffId = 150302,
			},
			ScaleNode = "Main",
			SkillGrade = {
				0,
			},
			UIName = "UISkillKezhou",
		},
		[1] = T.RT_32,
		[2] = T.RT_32,
		[3] = T.RT_32,
		[4] = T.RT_32,
		[5] = T.RT_32,
		[6] = T.RT_32,
	},
	[23] = {
		[0] = T.RT_33,
		[1] = T.RT_33,
		[2] = T.RT_33,
		[3] = T.RT_33,
		[4] = T.RT_33,
		[5] = T.RT_33,
		[6] = T.RT_33,
	},
	[24] = {
		[0] = T.RT_35,
		[1] = T.RT_35,
		[2] = T.RT_35,
		[3] = T.RT_35,
		[4] = T.RT_35,
		[5] = T.RT_35,
		[6] = T.RT_35,
	},
	[25] = {
		[0] = T.RT_37,
		[1] = T.RT_37,
		[2] = T.RT_37,
		[3] = T.RT_37,
		[4] = T.RT_37,
		[5] = T.RT_37,
		[6] = T.RT_37,
	},
	[26] = {
		[0] = T.RT_39,
		[1] = T.RT_39,
		[2] = T.RT_39,
		[3] = T.RT_39,
		[4] = T.RT_39,
		[5] = T.RT_39,
		[6] = T.RT_39,
	},
	[27] = {
		[0] = T.RT_40,
		[1] = T.RT_40,
		[2] = T.RT_40,
		[3] = T.RT_40,
		[4] = T.RT_40,
		[5] = T.RT_40,
		[6] = T.RT_40,
	},
	[28] = {
		[0] = T.RT_42,
		[1] = T.RT_42,
		[2] = T.RT_42,
		[3] = T.RT_42,
		[4] = T.RT_42,
		[5] = T.RT_42,
		[6] = T.RT_42,
	},
	[29] = {
		[0] = T.RT_44,
		[1] = T.RT_44,
		[2] = T.RT_44,
		[3] = T.RT_44,
		[4] = T.RT_44,
		[5] = T.RT_44,
		[6] = T.RT_44,
	},
	[30] = {
		[0] = T.RT_46,
		[1] = T.RT_46,
		[2] = T.RT_46,
		[3] = T.RT_46,
		[4] = T.RT_46,
		[5] = T.RT_46,
		[6] = T.RT_46,
	},
	[31] = {
		[0] = T.RT_47,
		[1] = T.RT_47,
		[2] = T.RT_47,
		[3] = T.RT_47,
		[4] = T.RT_47,
		[5] = T.RT_47,
		[6] = T.RT_47,
	},
	[32] = {
		[0] = T.RT_48,
		[1] = T.RT_48,
		[2] = T.RT_48,
		[3] = T.RT_48,
		[4] = T.RT_48,
		[5] = T.RT_48,
		[6] = T.RT_48,
	},
	[33] = {
		[0] = T.RT_49,
		[1] = T.RT_49,
		[2] = T.RT_49,
		[3] = T.RT_49,
		[4] = T.RT_49,
		[5] = T.RT_49,
		[6] = T.RT_49,
	},
	[34] = {
		[0] = T.RT_50,
		[1] = T.RT_50,
		[2] = T.RT_50,
		[3] = T.RT_50,
		[4] = T.RT_50,
		[5] = T.RT_50,
		[6] = T.RT_50,
	},
	[35] = {
		[0] = T.RT_51,
		[1] = T.RT_51,
		[2] = T.RT_51,
		[3] = T.RT_51,
		[4] = T.RT_51,
		[5] = T.RT_51,
		[6] = T.RT_51,
	},
})