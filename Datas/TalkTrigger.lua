-- Source Excel file path: ..\datas\Talk\TalkConfig.xlsx
local T = {}
T.RT_1 = {
		QuestId = 11010107,
	}
T.RT_2 = {
		QuestStart = T.RT_1,
	}
T.RT_3 = {
		QuestId = 11010108,
	}
T.RT_4 = {
		QuestUnstart = T.RT_3,
	}
T.RT_5 = {
		T.RT_2,
		T.RT_4,
	}
T.RT_6 = {
		And = T.RT_5,
	}
T.RT_7 = {
		QuestId = 11010305,
	}
T.RT_8 = {
		QuestStart = T.RT_7,
	}
T.RT_9 = {
		QuestId = 11010306,
	}
T.RT_10 = {
		QuestUnstart = T.RT_9,
	}
T.RT_11 = {
		T.RT_8,
		T.RT_10,
	}
T.RT_12 = {
		And = T.RT_11,
	}
T.RT_13 = {
		QuestId = 11010109,
	}
T.RT_14 = {
		QuestStart = T.RT_13,
	}
T.RT_15 = {
		QuestId = 11010301,
	}
T.RT_16 = {
		QuestUnstart = T.RT_15,
	}
T.RT_17 = {
		T.RT_14,
		T.RT_16,
	}
T.RT_18 = {
		And = T.RT_17,
	}
T.RT_19 = {
		QuestId = 10030104,
	}
T.RT_20 = {
		QuestStart = T.RT_19,
	}
T.RT_21 = {
		QuestId = 10030105,
	}
T.RT_22 = {
		QuestUnstart = T.RT_21,
	}
T.RT_23 = {
		T.RT_20,
		T.RT_22,
	}
T.RT_24 = {
		And = T.RT_23,
	}
T.RT_25 = {
		TalkTriggerId = 510033,
	}
T.RT_26 = {
		ImprUncomp = T.RT_25,
	}
T.RT_27 = {
		TalkTriggerId = 510016,
	}
T.RT_28 = {
		QuestChainId = 100208,
	}
T.RT_29 = {
		QuestChainFinish = T.RT_28,
	}
T.RT_30 = {
		TalkTriggerId = 510022,
	}
T.RT_31 = {
		QuestId = 20021004,
	}
T.RT_32 = {
		QuestFinish = T.RT_31,
	}
T.RT_33 = {
		TalkTriggerId = 510023,
	}
T.RT_34 = {
		ImprComp = T.RT_33,
	}
T.RT_35 = {
		QuestId = 20020309,
	}
T.RT_36 = {
		QuestFinish = T.RT_35,
	}
T.RT_37 = {
		QuestChainId = 200205,
	}
T.RT_38 = {
		QuestId = 20020608,
	}
T.RT_39 = {
		QuestFinish = T.RT_38,
	}
T.RT_40 = {
		QuestId = 20020706,
	}
T.RT_41 = {
		QuestFinish = T.RT_40,
	}
T.RT_42 = {
		QuestId = 20021301,
	}
T.RT_43 = {
		QuestFinish = T.RT_42,
	}
T.RT_44 = {
		TalkTriggerId = 510102,
	}
T.RT_45 = {
		ImprComp = T.RT_44,
	}
T.RT_46 = {
		TalkTriggerId = 510103,
	}
T.RT_47 = {
		ImprComp = T.RT_46,
	}
T.RT_48 = {
		QuestChainId = 100307,
	}
T.RT_49 = {
		QuestChainFinish = T.RT_48,
	}
T.RT_50 = {
		TalkTriggerId = 510104,
	}
T.RT_51 = {
		ImprComp = T.RT_50,
	}
T.RT_52 = {
		QuestChainId = 100204,
	}
T.RT_53 = {
		QuestChainFinish = T.RT_52,
	}
T.RT_54 = {
		ExploreGroupId = 7013098,
	}
T.RT_55 = {
		ExploreGroupInActive = T.RT_54,
	}
T.RT_56 = {
		ExploreGroupComp = T.RT_54,
	}
T.RT_57 = {
		ExploreGroupId = 7013101,
	}
T.RT_58 = {
		ExploreGroupComp = T.RT_57,
	}
T.RT_59 = {
		QuestChainId = 990103,
	}
T.RT_60 = {
		QuestChainFinish = T.RT_59,
	}
T.RT_61 = {
		QuestChainId = 110109,
	}
T.RT_62 = {
		QuestChainId = 100306,
	}
T.RT_63 = {
		QuestChainUnFinish = T.RT_62,
	}
T.RT_64 = {
		QuestChainFinish = T.RT_62,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TalkTrigger", {
	[-1] = {
		DialogueId = 10010111,
		TalkTriggerId = -1,
		TalkType = "ForgingGuide",
	},
	[105] = {
		StoryLinePath = "105.story",
		TalkId = 105,
		TalkTriggerId = 105,
	},
	[107] = {
		StoryLinePath = "107.story",
		TalkId = 107,
		TalkTriggerId = 107,
		Type = "Impression",
	},
	[1001] = {
		StoryLinePath = "Common/LeaveHintTrigger.story",
		TalkId = 1001,
		TalkTriggerId = 1001,
	},
	[1002] = {
		DialogueId = 10012502,
		TalkTriggerId = 1002,
		TalkType = "SpecialQuestFail",
	},
	[3001] = {
		DialogueId = 90000001,
		TalkTriggerId = 3001,
		TalkType = "ForgingGuide",
	},
	[10101] = {
		DialogueId = 60140001,
		TalkTriggerId = 10101,
		TalkType = "AudioOnly",
	},
	[10102] = {
		DialogueId = 60140002,
		TalkTriggerId = 10102,
		TalkType = "AudioOnly",
	},
	[10103] = {
		DialogueId = 60140003,
		TalkTriggerId = 10103,
		TalkType = "AudioOnly",
	},
	[10104] = {
		DialogueId = 60140004,
		TalkTriggerId = 10104,
		TalkType = "AudioOnly",
	},
	[10105] = {
		DialogueId = 60140005,
		TalkTriggerId = 10105,
		TalkType = "AudioOnly",
	},
	[10106] = {
		DialogueId = 60140006,
		TalkTriggerId = 10106,
		TalkType = "AudioOnly",
	},
	[10201] = {
		DialogueId = 60140201,
		TalkTriggerId = 10201,
		TalkType = "AudioOnly",
	},
	[10202] = {
		DialogueId = 60140202,
		TalkTriggerId = 10202,
		TalkType = "AudioOnly",
	},
	[10203] = {
		DialogueId = 60140203,
		TalkTriggerId = 10203,
		TalkType = "AudioOnly",
	},
	[10204] = {
		DialogueId = 60140204,
		TalkTriggerId = 10204,
		TalkType = "AudioOnly",
	},
	[10205] = {
		DialogueId = 60140205,
		TalkTriggerId = 10205,
		TalkType = "AudioOnly",
	},
	[10206] = {
		DialogueId = 60140206,
		TalkTriggerId = 10206,
		TalkType = "AudioOnly",
	},
	[10207] = {
		DialogueId = 60140207,
		TalkTriggerId = 10207,
		TalkType = "AudioOnly",
	},
	[20101] = {
		DialogueId = 60140001,
		TalkTriggerId = 20101,
		TalkType = "Boss",
	},
	[20102] = {
		DialogueId = 60140002,
		TalkTriggerId = 20102,
		TalkType = "Boss",
	},
	[20103] = {
		DialogueId = 60140003,
		TalkTriggerId = 20103,
		TalkType = "Boss",
	},
	[20104] = {
		DialogueId = 60140004,
		TalkTriggerId = 20104,
		TalkType = "Boss",
	},
	[20105] = {
		DialogueId = 60140005,
		TalkTriggerId = 20105,
		TalkType = "Boss",
	},
	[20106] = {
		DialogueId = 60140006,
		TalkTriggerId = 20106,
		TalkType = "Boss",
	},
	[20201] = {
		DialogueId = 60140201,
		TalkTriggerId = 20201,
		TalkType = "Boss",
	},
	[20202] = {
		DialogueId = 60140202,
		TalkTriggerId = 20202,
		TalkType = "Boss",
	},
	[20203] = {
		DialogueId = 60140203,
		TalkTriggerId = 20203,
		TalkType = "Boss",
	},
	[20204] = {
		DialogueId = 60140204,
		TalkTriggerId = 20204,
		TalkType = "Boss",
	},
	[20205] = {
		DialogueId = 60140205,
		TalkTriggerId = 20205,
		TalkType = "Boss",
	},
	[20206] = {
		DialogueId = 60140206,
		TalkTriggerId = 20206,
		TalkType = "Boss",
	},
	[20207] = {
		DialogueId = 60140207,
		TalkTriggerId = 20207,
		TalkType = "Boss",
	},
	[20301] = {
		DialogueId = 60149001,
		TalkTriggerId = 20301,
		TalkType = "UnimportGuide",
	},
	[20302] = {
		DialogueId = 60149002,
		TalkTriggerId = 20302,
		TalkType = "UnimportGuide",
	},
	[20303] = {
		DialogueId = 60149003,
		TalkTriggerId = 20303,
		TalkType = "UnimportGuide",
	},
	[20304] = {
		DialogueId = 60149004,
		TalkTriggerId = 20304,
		TalkType = "UnimportGuide",
	},
	[20305] = {
		DialogueId = 60149005,
		TalkTriggerId = 20305,
		TalkType = "UnimportGuide",
	},
	[20306] = {
		DialogueId = 60149006,
		TalkTriggerId = 20306,
		TalkType = "UnimportGuide",
	},
	[20307] = {
		DialogueId = 60149007,
		TalkTriggerId = 20307,
		TalkType = "UnimportGuide",
	},
	[20308] = {
		DialogueId = 60149008,
		TalkTriggerId = 20308,
		TalkType = "UnimportGuide",
	},
	[20309] = {
		DialogueId = 60149009,
		TalkTriggerId = 20309,
		TalkType = "UnimportGuide",
	},
	[20310] = {
		DialogueId = 60149010,
		TalkTriggerId = 20310,
		TalkType = "UnimportGuide",
	},
	[20311] = {
		DialogueId = 60149011,
		TalkTriggerId = 20311,
		TalkType = "UnimportGuide",
	},
	[20312] = {
		DialogueId = 60149012,
		TalkTriggerId = 20312,
		TalkType = "UnimportGuide",
	},
	[20313] = {
		DialogueId = 60149013,
		TalkTriggerId = 20313,
		TalkType = "UnimportGuide",
	},
	[20314] = {
		DialogueId = 60149014,
		TalkTriggerId = 20314,
		TalkType = "UnimportGuide",
	},
	[20315] = {
		DialogueId = 60149015,
		TalkTriggerId = 20315,
		TalkType = "UnimportGuide",
	},
	[20401] = {
		DialogueId = 60140401,
		TalkTriggerId = 20401,
		TalkType = "Boss",
	},
	[20402] = {
		DialogueId = 60140402,
		TalkTriggerId = 20402,
		TalkType = "Boss",
	},
	[20403] = {
		DialogueId = 60140403,
		TalkTriggerId = 20403,
		TalkType = "Boss",
	},
	[20404] = {
		DialogueId = 60140404,
		TalkTriggerId = 20404,
		TalkType = "Boss",
	},
	[20405] = {
		DialogueId = 60140405,
		TalkTriggerId = 20405,
		TalkType = "Boss",
	},
	[20406] = {
		DialogueId = 60140406,
		TalkTriggerId = 20406,
		TalkType = "Boss",
	},
	[20407] = {
		DialogueId = 60140407,
		TalkTriggerId = 20407,
		TalkType = "Boss",
	},
	[20408] = {
		DialogueId = 60140408,
		TalkTriggerId = 20408,
		TalkType = "Boss",
	},
	[20409] = {
		DialogueId = 60140409,
		TalkTriggerId = 20409,
		TalkType = "Boss",
	},
	[20501] = {
		DialogueId = 60140501,
		TalkTriggerId = 20501,
		TalkType = "Boss",
	},
	[20502] = {
		DialogueId = 60140502,
		TalkTriggerId = 20502,
		TalkType = "Boss",
	},
	[20503] = {
		DialogueId = 60140503,
		TalkTriggerId = 20503,
		TalkType = "Boss",
	},
	[20504] = {
		DialogueId = 60140504,
		TalkTriggerId = 20504,
		TalkType = "Boss",
	},
	[20505] = {
		DialogueId = 60140505,
		TalkTriggerId = 20505,
		TalkType = "Boss",
	},
	[20506] = {
		DialogueId = 60140506,
		TalkTriggerId = 20506,
		TalkType = "Boss",
	},
	[20507] = {
		DialogueId = 60140507,
		TalkTriggerId = 20507,
		TalkType = "Boss",
	},
	[20508] = {
		DialogueId = 60140508,
		TalkTriggerId = 20508,
		TalkType = "Boss",
	},
	[20601] = {
		DialogueId = 60150001,
		TalkTriggerId = 20601,
		TalkType = "AudioOnly",
	},
	[20602] = {
		DialogueId = 60150002,
		TalkTriggerId = 20602,
		TalkType = "AudioOnly",
	},
	[20603] = {
		DialogueId = 60150003,
		TalkTriggerId = 20603,
		TalkType = "AudioOnly",
	},
	[20604] = {
		DialogueId = 60150004,
		TalkTriggerId = 20604,
		TalkType = "AudioOnly",
	},
	[20605] = {
		DialogueId = 60150005,
		TalkTriggerId = 20605,
		TalkType = "AudioOnly",
	},
	[20606] = {
		DialogueId = 60150006,
		TalkTriggerId = 20606,
		TalkType = "AudioOnly",
	},
	[20701] = {
		DialogueId = 60160001,
		TalkTriggerId = 20701,
		TalkType = "UnimportGuide",
	},
	[20702] = {
		DialogueId = 60160002,
		TalkTriggerId = 20702,
		TalkType = "UnimportGuide",
	},
	[20703] = {
		DialogueId = 60160003,
		TalkTriggerId = 20703,
		TalkType = "UnimportGuide",
	},
	[20704] = {
		DialogueId = 60160004,
		TalkTriggerId = 20704,
		TalkType = "UnimportGuide",
	},
	[20705] = {
		DialogueId = 60160005,
		TalkTriggerId = 20705,
		TalkType = "UnimportGuide",
	},
	[20801] = {
		DialogueId = 60170001,
		TalkTriggerId = 20801,
		TalkType = "Boss",
	},
	[20802] = {
		DialogueId = 60170002,
		TalkTriggerId = 20802,
		TalkType = "Boss",
	},
	[20803] = {
		DialogueId = 60170003,
		TalkTriggerId = 20803,
		TalkType = "Boss",
	},
	[20901] = {
		DialogueId = 60180001,
		TalkTriggerId = 20901,
		TalkType = "Boss",
	},
	[20902] = {
		DialogueId = 60180002,
		TalkTriggerId = 20902,
		TalkType = "Boss",
	},
	[20903] = {
		DialogueId = 60180003,
		TalkTriggerId = 20903,
		TalkType = "Boss",
	},
	[20904] = {
		DialogueId = 60180004,
		TalkTriggerId = 20904,
		TalkType = "Boss",
	},
	[20905] = {
		DialogueId = 60180005,
		TalkTriggerId = 20905,
		TalkType = "Boss",
	},
	[20906] = {
		DialogueId = 60180006,
		TalkTriggerId = 20906,
		TalkType = "Boss",
	},
	[100125] = {
		StoryLinePath = "Common/100125.story",
		TalkId = 100125,
		TalkTriggerId = 100125,
	},
	[100142] = {
		StoryLinePath = "Other/100142.story",
		TalkTriggerId = 100142,
	},
	[100143] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/AogeTraceEnlik.story",
		TalkId = 100143,
		TalkTriggerId = 100143,
		TriggerCondition = {
			And = {
				{
					QuestStart = {
						QuestId = 10020652,
					},
				},
				{
					QuestUnstart = {
						QuestId = 10020604,
					},
				},
			},
		},
	},
	[100144] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/EnlikeIcelake.story",
		TalkId = 100144,
		TalkTriggerId = 100144,
		TriggerCondition = {
			And = {
				{
					QuestStart = {
						QuestId = 10020608,
					},
				},
				{
					QuestUnstart = {
						QuestId = 10020611,
					},
				},
			},
		},
	},
	[100295] = {
		TalkId = 100295,
		TalkTriggerId = 100295,
	},
	[101043] = {
		StoryLinePath = "Other/101043.story",
		TalkTriggerId = 101043,
	},
	[101050] = {
		DialogueId = 10105001,
		TalkTriggerId = 101050,
		TalkType = "Guide",
	},
	[101051] = {
		DialogueId = 10105101,
		TalkTriggerId = 101051,
		TalkType = "Guide",
	},
	[101052] = {
		DialogueId = 10105201,
		TalkId = 101052,
		TalkTriggerId = 101052,
		TalkType = "Guide",
	},
	[101120] = {
		DialogueId = 10112001,
		TalkTriggerId = 101120,
		TalkType = "Guide",
	},
	[101180] = {
		StoryLinePath = "Other/101180.story",
		TalkId = 101180,
		TalkTriggerId = 101180,
	},
	[110118] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/Kajia1.story",
		TalkId = 110118,
		TalkTriggerId = 110118,
		TriggerCondition = {
			And = {
				{
					QuestStart = {
						QuestId = 11010510,
					},
				},
				{
					QuestUnstart = {
						QuestId = 11010521,
					},
				},
			},
		},
	},
	[110119] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/LaiAng.story",
		TalkId = 110119,
		TalkTriggerId = 110119,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 11010508,
			},
		},
	},
	[110120] = {
		StoryLinePath = "Impression/EX01Fort/Task/impression09.story",
		TalkId = 110120,
		TalkTriggerId = 110120,
		TriggerCondition = T.RT_6,
		Type = "Impression",
	},
	[110121] = {
		StoryLinePath = "Impression/EX01Fort/Task/impression10.story",
		TalkId = 110121,
		TalkTriggerId = 110121,
		TriggerCondition = T.RT_6,
		Type = "Impression",
	},
	[110122] = {
		StoryLinePath = "Impression/EX01Fort/Task/impression03.story",
		TalkTriggerId = 110122,
		TriggerCondition = {
			And = {
				{
					QuestStart = {
						QuestId = 11010516,
					},
				},
				{
					QuestUnstart = {
						QuestId = 11010517,
					},
				},
			},
		},
		Type = "Impression",
	},
	[110123] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/AwaTalk1.story",
		TalkId = 110123,
		TalkTriggerId = 110123,
		TriggerCondition = T.RT_12,
	},
	[110124] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/AwaTalk2.story",
		TalkId = 110124,
		TalkTriggerId = 110124,
		TriggerCondition = {
			QuestStart = {
				QuestId = 11010511,
			},
		},
	},
	[110125] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/Monica1.story",
		TalkId = 110125,
		TalkTriggerId = 110125,
		TriggerCondition = T.RT_12,
	},
	[110126] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/HurtBubble01.story",
		TalkId = 110126,
		TalkTriggerId = 110126,
		TriggerCondition = T.RT_18,
	},
	[110127] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/HurtBubble02.story",
		TalkId = 110127,
		TalkTriggerId = 110127,
		TriggerCondition = T.RT_18,
	},
	[110128] = {
		StoryLinePath = "TalkGossip/110128_Dafu.story",
		TalkId = 110128,
		TalkTriggerId = 110128,
		TriggerCondition = T.RT_6,
	},
	[110129] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/SoldierBubble01.story",
		TalkId = 110129,
		TalkTriggerId = 110129,
		TriggerCondition = T.RT_6,
	},
	[110130] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/SoldierBubble02.story",
		TalkId = 110130,
		TalkTriggerId = 110130,
		TriggerCondition = T.RT_6,
	},
	[110131] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/SoldierBubble03.story",
		TalkId = 110131,
		TalkTriggerId = 110131,
		TriggerCondition = T.RT_6,
	},
	[110132] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/MonikaWeike.story",
		TalkId = 110132,
		TalkTriggerId = 110132,
		TriggerCondition = {
			VarEqual = {
				Name = "Weike110103",
				Value = 1,
			},
		},
	},
	[110133] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/SoldierBubble04.story",
		TalkId = 110133,
		TalkTriggerId = 110133,
		TriggerCondition = T.RT_6,
	},
	[110134] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/SoldierBubble05.story",
		TalkId = 110134,
		TalkTriggerId = 110134,
		TriggerCondition = T.RT_6,
	},
	[110135] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/SoldierBubble06.story",
		TalkId = 110135,
		TalkTriggerId = 110135,
		TriggerCondition = T.RT_6,
	},
	[110136] = {
		StoryLinePath = "Impression/EX01Fort/Gossip/DafuLinshi.story",
		TalkId = 110136,
		TalkTriggerId = 110136,
		TriggerCondition = {
			And = {
				{
					QuestStart = T.RT_15,
				},
				{
					QuestUnstart = {
						QuestId = 11010308,
					},
				},
			},
		},
	},
	[110201] = {
		StoryLinePath = "Impression/East02/12020206L.story",
		TalkId = 110201,
		TalkTriggerId = 110201,
	},
	[110202] = {
		StoryLinePath = "Impression/East02/12020206R.story",
		TalkId = 110202,
		TalkTriggerId = 110202,
	},
	[120106] = {
		StoryLinePath = "Impression/East01/Gossip/120106.story",
		TalkId = 120106,
		TalkTriggerId = 120106,
	},
	[120250] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120250.story",
		TalkId = 120250,
		TalkTriggerId = 120250,
	},
	[120251] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120251.story",
		TalkId = 120251,
		TalkTriggerId = 120251,
	},
	[120252] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120252.story",
		TalkId = 120252,
		TalkTriggerId = 120252,
	},
	[120253] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120253.story",
		TalkId = 120253,
		TalkTriggerId = 120253,
	},
	[120254] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120254.story",
		TalkId = 120254,
		TalkTriggerId = 120254,
	},
	[120255] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120255.story",
		TalkId = 120255,
		TalkTriggerId = 120255,
	},
	[120256] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120256.story",
		TalkId = 120256,
		TalkTriggerId = 120256,
	},
	[120257] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120257.story",
		TalkId = 120257,
		TalkTriggerId = 120257,
	},
	[120258] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120258.story",
		TalkId = 120258,
		TalkTriggerId = 120258,
	},
	[120259] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120259.story",
		TalkId = 120259,
		TalkTriggerId = 120259,
	},
	[120260] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120260.story",
		TalkId = 120260,
		TalkTriggerId = 120260,
	},
	[120261] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120261.story",
		TalkId = 120261,
		TalkTriggerId = 120261,
	},
	[120262] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120262.story",
		TalkId = 120262,
		TalkTriggerId = 120262,
	},
	[120263] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120263.story",
		TalkId = 120263,
		TalkTriggerId = 120263,
	},
	[120264] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120264.story",
		TalkId = 120264,
		TalkTriggerId = 120264,
	},
	[120265] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120265.story",
		TalkId = 120265,
		TalkTriggerId = 120265,
	},
	[120266] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120266.story",
		TalkId = 120266,
		TalkTriggerId = 120266,
	},
	[120267] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120267.story",
		TalkId = 120267,
		TalkTriggerId = 120267,
	},
	[120268] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120268.story",
		TalkId = 120268,
		TalkTriggerId = 120268,
	},
	[120269] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120269.story",
		TalkId = 120269,
		TalkTriggerId = 120269,
	},
	[120270] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120270.story",
		TalkId = 120270,
		TalkTriggerId = 120270,
	},
	[120271] = {
		StoryLinePath = "Impression/East01/Talk_Gossip/120271.story",
		TalkId = 120271,
		TalkTriggerId = 120271,
	},
	[120301] = {
		StoryLinePath = "Impression/East03/12030105.story",
		TalkId = 120301,
		TalkTriggerId = 120301,
		TriggerCondition = {
			And = {
				{
					QuestStart = {
						QuestId = 12030105,
					},
				},
				{
					QuestUnstart = {
						QuestId = 12030201,
					},
				},
			},
		},
	},
	[120302] = {
		StoryLinePath = "Impression/East03/12030205.story",
		TalkId = 120302,
		TalkTriggerId = 120302,
		TriggerCondition = {
			And = {
				{
					QuestFinish = {
						QuestId = 12030205,
					},
				},
				{
					QuestUnstart = {
						QuestId = 12030302,
					},
				},
			},
		},
	},
	[120303] = {
		StoryLinePath = "Impression/East03/12030504.story",
		TalkId = 120303,
		TalkTriggerId = 120303,
		TriggerCondition = {
			And = {
				{
					QuestFinish = {
						QuestId = 12030504,
					},
				},
				{
					QuestUnstart = {
						QuestId = 12030602,
					},
				},
			},
		},
	},
	[200008] = {
		StoryLinePath = "TalkGossip/AfterQuest/200102_1_End.story",
		TalkId = 200008,
		TalkTriggerId = 200008,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20010201,
			},
		},
	},
	[200009] = {
		StoryLinePath = "TalkGossip/AfterQuest/200102_2_End.story",
		TalkId = 200009,
		TalkTriggerId = 200009,
		TriggerCondition = {
			And = {
				{
					QuestChainFinish = {
						QuestChainId = 200102,
					},
				},
				{
					QuestUnstart = {
						QuestId = 10020607,
					},
				},
			},
		},
	},
	[200010] = {
		StoryLinePath = "Impression/IceLakeCity/200104_1_End.story",
		TalkId = 200010,
		TalkTriggerId = 200010,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 200104,
			},
		},
	},
	[200011] = {
		StoryLinePath = "Impression/IceLakeCity/200103_End.story",
		TalkId = 200011,
		TalkTriggerId = 200011,
		TriggerCondition = {
			And = {
				{
					QuestChainFinish = {
						QuestChainId = 200103,
					},
				},
				{
					QuestUnstart = {
						QuestId = 10020302,
					},
				},
			},
		},
	},
	[200012] = {
		StoryLinePath = "BubbleTalk/51105129.story",
		TalkId = 200012,
		TalkTriggerId = 200012,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 200305,
			},
		},
	},
	[200013] = {
		StoryLinePath = "TalkGossip/AfterQuest/120114_End.story",
		TalkId = 200013,
		TalkTriggerId = 200013,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 120114,
			},
		},
	},
	[300100] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300100,
		TalkTriggerId = 300100,
		TriggerCondition = T.RT_24,
	},
	[300101] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300101,
		TalkTriggerId = 300101,
		TriggerCondition = T.RT_24,
	},
	[300102] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300102,
		TalkTriggerId = 300102,
		TriggerCondition = T.RT_24,
	},
	[300103] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300103,
		TalkTriggerId = 300103,
		TriggerCondition = T.RT_24,
	},
	[300104] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300104,
		TalkTriggerId = 300104,
		TriggerCondition = T.RT_24,
	},
	[300105] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300105,
		TalkTriggerId = 300105,
		TriggerCondition = T.RT_24,
	},
	[300106] = {
		StoryLinePath = "BubbleTalk/10030510.story",
		TalkId = 300106,
		TalkTriggerId = 300106,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 10030398,
			},
		},
	},
	[300107] = {
		StoryLinePath = "BubbleTalk/10030511.story",
		TalkId = 300107,
		TalkTriggerId = 300107,
	},
	[300108] = {
		StoryLinePath = "BubbleTalk/10030512.story",
		TalkId = 300108,
		TalkTriggerId = 300108,
	},
	[300109] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300109,
		TalkTriggerId = 300109,
	},
	[300110] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300110,
		TalkTriggerId = 300110,
	},
	[300111] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300111,
		TalkTriggerId = 300111,
	},
	[300112] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300112,
		TalkTriggerId = 300112,
	},
	[300113] = {
		StoryLinePath = "BubbleTalk/10030001.story",
		TalkId = 300113,
		TalkTriggerId = 300113,
	},
	[500001] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500001.story",
		TalkId = 500001,
		TalkTriggerId = 500001,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20021200,
			},
		},
	},
	[500002] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500002.story",
		TalkId = 500002,
		TalkTriggerId = 500002,
	},
	[500003] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500003.story",
		TalkId = 500003,
		TalkTriggerId = 500003,
	},
	[500004] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500004.story",
		TalkId = 500004,
		TalkTriggerId = 500004,
		TriggerCondition = {
			ImprUncomp = {
				TalkTriggerId = 510008,
			},
		},
	},
	[500005] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500005.story",
		TalkId = 500005,
		TalkTriggerId = 500005,
	},
	[500006] = {
		TalkId = 500006,
		TalkTriggerId = 500006,
	},
	[500007] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500007.story",
		TalkId = 500007,
		TalkTriggerId = 500007,
	},
	[500008] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500008.story",
		TalkId = 500008,
		TalkTriggerId = 500008,
	},
	[500009] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500009.story",
		TalkId = 500009,
		TalkTriggerId = 500009,
	},
	[500010] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500010.story",
		TalkId = 500010,
		TalkTriggerId = 500010,
	},
	[500011] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500011.story",
		TalkId = 500011,
		TalkTriggerId = 500011,
	},
	[500012] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500012.story",
		TalkId = 500012,
		TalkTriggerId = 500012,
	},
	[500013] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500013.story",
		TalkId = 500013,
		TalkTriggerId = 500013,
		TriggerCondition = {
			VarEqual = {
				Name = "XiAoStage",
				Value = 0,
			},
		},
	},
	[500014] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500014.story",
		TalkId = 500014,
		TalkTriggerId = 500014,
		TriggerCondition = {
			VarEqual = {
				Name = "XiAoStage",
				Value = 1,
			},
		},
	},
	[500015] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500015.story",
		TalkId = 500015,
		TalkTriggerId = 500015,
	},
	[500016] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500016.story",
		TalkId = 500016,
		TalkTriggerId = 500016,
	},
	[500017] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500017.story",
		TalkId = 500017,
		TalkTriggerId = 500017,
	},
	[500018] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500018.story",
		TalkId = 500018,
		TalkTriggerId = 500018,
		TriggerCondition = T.RT_26,
	},
	[500019] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500019.story",
		TalkId = 500019,
		TalkTriggerId = 500019,
	},
	[500020] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500020.story",
		TalkId = 500020,
		TalkTriggerId = 500020,
	},
	[500021] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500021.story",
		TalkId = 500021,
		TalkTriggerId = 500021,
	},
	[500022] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500022.story",
		TalkId = 500022,
		TalkTriggerId = 500022,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020104,
			},
		},
	},
	[500023] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500023.story",
		TalkId = 500023,
		TalkTriggerId = 500023,
	},
	[500024] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500024.story",
		TalkId = 500024,
		TalkTriggerId = 500024,
	},
	[500025] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500025.story",
		TalkId = 500025,
		TalkTriggerId = 500025,
	},
	[500026] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500026.story",
		TalkId = 500026,
		TalkTriggerId = 500026,
	},
	[500027] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500027.story",
		TalkId = 500027,
		TalkTriggerId = 500027,
		TriggerCondition = {
			VarEqual = {
				Name = "DaDunStage",
				Value = 0,
			},
		},
	},
	[500028] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500028.story",
		TalkId = 500028,
		TalkTriggerId = 500028,
		TriggerCondition = {
			ImprUncomp = T.RT_27,
		},
	},
	[500029] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500029.story",
		TalkId = 500029,
		TalkTriggerId = 500029,
	},
	[500030] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500030.story",
		TalkId = 500030,
		TalkTriggerId = 500030,
	},
	[500031] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500031.story",
		TalkId = 500031,
		TalkTriggerId = 500031,
	},
	[500032] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500032.story",
		TalkId = 500032,
		TalkTriggerId = 500032,
	},
	[500033] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500033.story",
		TalkId = 500033,
		TalkTriggerId = 500033,
	},
	[500034] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500034.story",
		TalkId = 500034,
		TalkTriggerId = 500034,
	},
	[500035] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500035.story",
		TalkId = 500035,
		TalkTriggerId = 500035,
	},
	[500036] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500036.story",
		TalkId = 500036,
		TalkTriggerId = 500036,
	},
	[500037] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500037.story",
		TalkId = 500037,
		TalkTriggerId = 500037,
		TriggerCondition = T.RT_26,
	},
	[500038] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500038.story",
		TalkId = 500038,
		TalkTriggerId = 500038,
	},
	[500039] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500039.story",
		TalkId = 500039,
		TalkTriggerId = 500039,
	},
	[500040] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500040.story",
		TalkId = 500040,
		TalkTriggerId = 500040,
	},
	[500041] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500041.story",
		TalkId = 500041,
		TalkTriggerId = 500041,
		TriggerCondition = {
			ImprUncomp = {
				TalkTriggerId = 510018,
			},
		},
	},
	[500042] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500042.story",
		TalkId = 500042,
		TalkTriggerId = 500042,
	},
	[500043] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500043.story",
		TalkId = 500043,
		TalkTriggerId = 500043,
		TriggerCondition = T.RT_29,
	},
	[500044] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500044.story",
		TalkId = 500044,
		TalkTriggerId = 500044,
	},
	[500045] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500045.story",
		TalkId = 500045,
		TalkTriggerId = 500045,
	},
	[500046] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500046.story",
		TalkId = 500046,
		TalkTriggerId = 500046,
	},
	[500047] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500047.story",
		TalkId = 500047,
		TalkTriggerId = 500047,
		TriggerCondition = {
			ImprUncomp = {
				TalkTriggerId = 510020,
			},
		},
	},
	[500048] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500048.story",
		TalkId = 500048,
		TalkTriggerId = 500048,
		TriggerCondition = {
			ImprComp = T.RT_30,
		},
	},
	[500049] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500049.story",
		TalkId = 500049,
		TalkTriggerId = 500049,
		TriggerCondition = {
			ImprUncomp = {
				TalkTriggerId = 510053,
			},
		},
	},
	[500050] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500050.story",
		TalkId = 500050,
		TalkTriggerId = 500050,
		TriggerCondition = {
			ImprUncomp = {
				TalkTriggerId = 510042,
			},
		},
	},
	[500051] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500051.story",
		TalkId = 500051,
		TalkTriggerId = 500051,
		TriggerCondition = T.RT_32,
	},
	[500052] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500052.story",
		TalkId = 500052,
		TalkTriggerId = 500052,
	},
	[500053] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500053.story",
		TalkId = 500053,
		TalkTriggerId = 500053,
		TriggerCondition = {
			ImprUncomp = {
				TalkTriggerId = 510070,
			},
		},
	},
	[500054] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500054.story",
		TalkId = 500054,
		TalkTriggerId = 500054,
	},
	[500055] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500055.story",
		TalkId = 500055,
		TalkTriggerId = 500055,
	},
	[500056] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500056.story",
		TalkId = 500056,
		TalkTriggerId = 500056,
	},
	[500057] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500057.story",
		TalkId = 500057,
		TalkTriggerId = 500057,
		TriggerCondition = {
			VarEqual = {
				Name = "XiAoStage",
				Value = 2,
			},
		},
	},
	[500058] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500058.story",
		TalkId = 500058,
		TalkTriggerId = 500058,
		TriggerCondition = {
			VarEqual = {
				Name = "DaDunStage",
				Value = 1,
			},
		},
	},
	[500059] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/500059.story",
		TalkId = 500059,
		TalkTriggerId = 500059,
	},
	[500080] = {
		StoryLinePath = "Impression/IceLakeCity/500080_Hesite.story",
		TalkId = 500080,
		TalkTriggerId = 500080,
		Type = "Impression",
	},
	[501036] = {
		StoryLinePath = "Impression/East01/Gossip/501036.story",
		TalkId = 501036,
		TalkTriggerId = 501036,
	},
	[501037] = {
		StoryLinePath = "Impression/East01/Gossip/501037.story",
		TalkId = 501037,
		TalkTriggerId = 501037,
	},
	[501038] = {
		StoryLinePath = "Impression/East01/Gossip/501038.story",
		TalkId = 501038,
		TalkTriggerId = 501038,
	},
	[501039] = {
		StoryLinePath = "Impression/East01/Gossip/501039.story",
		TalkId = 501039,
		TalkTriggerId = 501039,
	},
	[501040] = {
		StoryLinePath = "Impression/East01/Gossip/501040.story",
		TalkId = 501040,
		TalkTriggerId = 501040,
	},
	[501041] = {
		StoryLinePath = "Impression/East01/Gossip/501041.story",
		TalkId = 501041,
		TalkTriggerId = 501041,
	},
	[501042] = {
		StoryLinePath = "Impression/East01/Gossip/501042.story",
		TalkId = 501042,
		TalkTriggerId = 501042,
	},
	[501043] = {
		StoryLinePath = "Impression/East01/Gossip/501043.story",
		TalkId = 501043,
		TalkTriggerId = 501043,
	},
	[501044] = {
		StoryLinePath = "Impression/East01/Gossip/501044.story",
		TalkId = 501044,
		TalkTriggerId = 501044,
	},
	[501045] = {
		StoryLinePath = "Impression/East01/Gossip/501045.story",
		TalkId = 501045,
		TalkTriggerId = 501045,
	},
	[501046] = {
		StoryLinePath = "Impression/East01/Gossip/501046.story",
		TalkId = 501046,
		TalkTriggerId = 501046,
	},
	[501047] = {
		StoryLinePath = "Impression/East01/Gossip/501047.story",
		TalkId = 501047,
		TalkTriggerId = 501047,
	},
	[501048] = {
		StoryLinePath = "Impression/East01/Gossip/501048.story",
		TalkId = 501048,
		TalkTriggerId = 501048,
	},
	[501049] = {
		StoryLinePath = "Impression/East01/Gossip/501049.story",
		TalkId = 501049,
		TalkTriggerId = 501049,
	},
	[501050] = {
		StoryLinePath = "Impression/East01/Gossip/501050.story",
		TalkId = 501050,
		TalkTriggerId = 501050,
	},
	[501051] = {
		StoryLinePath = "Impression/East01/Gossip/501051.story",
		TalkId = 501051,
		TalkTriggerId = 501051,
	},
	[501052] = {
		StoryLinePath = "Impression/East01/Gossip/501052.story",
		TalkId = 501052,
		TalkTriggerId = 501052,
	},
	[501053] = {
		StoryLinePath = "Impression/East01/Gossip/501053.story",
		TalkId = 501053,
		TalkTriggerId = 501053,
	},
	[501054] = {
		StoryLinePath = "Impression/East01/Gossip/501054.story",
		TalkId = 501054,
		TalkTriggerId = 501054,
	},
	[501055] = {
		StoryLinePath = "Impression/East01/Gossip/501055.story",
		TalkId = 501055,
		TalkTriggerId = 501055,
	},
	[501056] = {
		StoryLinePath = "Impression/East01/Gossip/501056.story",
		TalkId = 501056,
		TalkTriggerId = 501056,
	},
	[501057] = {
		StoryLinePath = "Impression/East01/Gossip/501057.story",
		TalkId = 501057,
		TalkTriggerId = 501057,
	},
	[501058] = {
		StoryLinePath = "Impression/East01/Gossip/501058.story",
		TalkId = 501058,
		TalkTriggerId = 501058,
	},
	[501059] = {
		StoryLinePath = "Impression/East01/Gossip/501059.story",
		TalkId = 501059,
		TalkTriggerId = 501059,
	},
	[501060] = {
		StoryLinePath = "Impression/East01/Gossip/501060.story",
		TalkId = 501060,
		TalkTriggerId = 501060,
	},
	[501061] = {
		StoryLinePath = "Impression/East01/Gossip/501061.story",
		TalkId = 501061,
		TalkTriggerId = 501061,
	},
	[501062] = {
		StoryLinePath = "Impression/East01/Gossip/501062.story",
		TalkId = 501062,
		TalkTriggerId = 501062,
	},
	[501063] = {
		StoryLinePath = "Impression/East01/Gossip/501063.story",
		TalkId = 501063,
		TalkTriggerId = 501063,
	},
	[501071] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\501071.story",
		TalkId = 501071,
		TalkTriggerId = 501071,
	},
	[510002] = {
		StoryLinePath = "Impression/IceLakeCity/510002_XilinFuren.story",
		TalkId = 510002,
		TalkTriggerId = 510002,
		TriggerCondition = {
			QuestChainStart = {
				QuestChainId = 200201,
			},
		},
		Type = "Impression",
	},
	[510005] = {
		StoryLinePath = "Impression/IceLakeCity/510005_Aiersha_2.story",
		TalkId = 510005,
		TalkTriggerId = 510005,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020306,
			},
		},
		Type = "Impression",
	},
	[510007] = {
		RewardId = 4000003,
		StoryLinePath = "Impression/IceLakeCity/510007_Alice_1.story",
		TalkId = 510007,
		TalkTriggerId = 510007,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020313,
			},
		},
		Type = "Impression",
	},
	[510009] = {
		TalkId = 510009,
		TalkTriggerId = 510009,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 100201,
			},
		},
		Type = "Impression",
	},
	[510010] = {
		StoryLinePath = "Impression/IceLakeCity/510010_Jiexika.story",
		TalkId = 510010,
		TalkTriggerId = 510010,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020202,
			},
		},
		Type = "Impression",
	},
	[510011] = {
		RewardId = 4000002,
		StoryLinePath = "Impression/IceLakeCity/510011_Alice_Mading_1.story",
		TalkId = 510011,
		TalkTriggerId = 510011,
		TriggerCondition = {
			QuestStart = {
				QuestId = 20020305,
			},
		},
		Type = "Impression",
	},
	[510012] = {
		StoryLinePath = "Impression/IceLakeCity/510012_Kenong.story",
		TalkId = 510012,
		TalkTriggerId = 510012,
		Type = "Impression",
	},
	[510014] = {
		StoryLinePath = "Impression/IceLakeCity/510014_Sangni.story",
		TalkId = 510014,
		TalkTriggerId = 510014,
		Type = "Impression",
	},
	[510015] = {
		TalkId = 510015,
		TalkTriggerId = 510015,
		Type = "Impression",
	},
	[510016] = {
		StoryLinePath = "Impression/IceLakeCity/510016_Yagebu.story",
		TalkId = 510016,
		TalkTriggerId = 510016,
		Type = "Impression",
	},
	[510017] = {
		StoryLinePath = "Impression/IceLakeCity/510017_Dadun.story",
		TalkId = 510017,
		TalkTriggerId = 510017,
		Type = "Impression",
	},
	[510019] = {
		StoryLinePath = "Impression/IceLakeCity/510019_Wells_Quarrel.story",
		TalkId = 5100182,
		TalkTriggerId = 510019,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020403,
			},
		},
		Type = "Impression",
	},
	[510022] = {
		StoryLinePath = "Impression/IceLakeCity/510022_Blue_2.story",
		TalkId = 5100192,
		TalkTriggerId = 510022,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020510,
			},
		},
		Type = "Impression",
	},
	[510026] = {
		StoryLinePath = "Impression/IceLakeCity/510026_Kaiwen_1.story",
		TalkId = 510026,
		TalkTriggerId = 510026,
		TriggerCondition = {
			QuestStart = {
				QuestId = 20021202,
			},
		},
		Type = "Impression",
	},
	[510029] = {
		StoryLinePath = "Impression/IceLakeCity/510029_Kami_1.story",
		TalkId = 510029,
		TalkTriggerId = 510029,
		TriggerCondition = {
			QuestStart = {
				QuestId = 20020600,
			},
		},
		Type = "Impression",
	},
	[510030] = {
		StoryLinePath = "Impression/IceLakeCity/510030_Bake_1.story",
		TalkId = 510030,
		TalkTriggerId = 510030,
		TriggerCondition = {
			QuestChainStart = {
				QuestChainId = 200206,
			},
		},
		Type = "Impression",
	},
	[510033] = {
		StoryLinePath = "Impression/IceLakeCity/510033_Anuo_1.story",
		TalkId = 510033,
		TalkTriggerId = 510033,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020606,
			},
		},
		Type = "Impression",
	},
	[510035] = {
		StoryLinePath = "Impression/IceLakeCity/510035_Aima_1.story",
		TalkId = 510035,
		TalkTriggerId = 510035,
		TriggerCondition = {
			QuestChainStart = {
				QuestChainId = 200207,
			},
		},
		Type = "Impression",
	},
	[510036] = {
		StoryLinePath = "Impression/IceLakeCity/510036_Beilinda_1.story",
		TalkId = 510036,
		TalkTriggerId = 510036,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020703,
			},
		},
		Type = "Impression",
	},
	[510037] = {
		RewardId = 4000004,
		StoryLinePath = "Impression/IceLakeCity/510037_Beilinda_2.story",
		TalkId = 510037,
		TalkTriggerId = 510037,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020705,
			},
		},
		Type = "Impression",
	},
	[510039] = {
		StoryLinePath = "Impression/IceLakeCity/510039_Faye_2.story",
		TalkId = 510039,
		TalkTriggerId = 510039,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20021101,
			},
		},
		Type = "Impression",
	},
	[510041] = {
		RewardId = 4000006,
		StoryLinePath = "Impression/IceLakeCity/510041_Faye_3.story",
		TalkId = 510041,
		TalkTriggerId = 510041,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20021104,
			},
		},
		Type = "Impression",
	},
	[510042] = {
		StoryLinePath = "Impression/IceLakeCity/510042_Heerluo.story",
		TalkId = 510042,
		TalkTriggerId = 510042,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20021007,
			},
		},
		Type = "Impression",
	},
	[510050] = {
		StoryLinePath = "Impression/IceLakeCity/510050_Laina.story",
		TalkId = 510050,
		TalkTriggerId = 510050,
		TriggerCondition = {
			And = {
				T.RT_29,
				T.RT_43,
			},
		},
		Type = "Impression",
	},
	[510058] = {
		StoryLinePath = "Impression/IceLakeCity/510058_dean.story",
		TalkId = 510058,
		TalkTriggerId = 510058,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 100202,
			},
		},
		Type = "Impression",
	},
	[510070] = {
		StoryLinePath = "Impression/IceLakeCity/510070_Liande.story",
		TalkId = 510070,
		TalkTriggerId = 510070,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20021901,
			},
		},
		Type = "Impression",
	},
	[510075] = {
		StoryLinePath = "Impression/IceLakeCity/510075_Xueli1.story",
		TalkId = 510075,
		TalkTriggerId = 510075,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20022105,
			},
		},
		Type = "Impression",
	},
	[510076] = {
		StoryLinePath = "Impression/IceLakeCity/510076_Xueli2.story",
		TalkId = 510076,
		TalkTriggerId = 510076,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20022102,
			},
		},
		Type = "Impression",
	},
	[510080] = {
		StoryLinePath = "Impression/IceLakeCity/510079_Dadun_EndTalk.story",
		TalkId = 510080,
		TalkTriggerId = 510080,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 200222,
			},
		},
	},
	[510096] = {
		StoryLinePath = "Impression/IceLakeCity/510096_Lars.story",
		TalkId = 510096,
		TalkTriggerId = 510096,
		TriggerCondition = {
			QuestStart = {
				QuestId = 20023100,
			},
		},
	},
	[510102] = {
		StoryLinePath = "Impression/IceLakeCity/510102_Liliko_1.story",
		TalkId = 510102,
		TalkTriggerId = 510102,
		Type = "Impression",
	},
	[510103] = {
		StoryLinePath = "Impression/IceLakeCity/510103_Liliko_2.story",
		TalkId = 510103,
		TalkTriggerId = 510103,
		TriggerCondition = {
			And = {
				T.RT_45,
				T.RT_29,
			},
		},
		Type = "Impression",
	},
	[510104] = {
		StoryLinePath = "Impression/IceLakeCity/510104_Liliko_3.story",
		TalkId = 510104,
		TalkTriggerId = 510104,
		TriggerCondition = {
			And = {
				T.RT_47,
				T.RT_49,
			},
		},
		Type = "Impression",
	},
	[510105] = {
		StoryLinePath = "Impression/IceLakeCity/510105_Kaiwen.story",
		TalkId = 510105,
		TalkTriggerId = 510105,
		Type = "Impression",
	},
	[510106] = {
		StoryLinePath = "Impression/IceLakeCity/510106_Jimu.story",
		TalkId = 510106,
		TalkTriggerId = 510106,
		Type = "Impression",
	},
	[510107] = {
		StoryLinePath = "Impression/IceLakeCity/510107_Beiguanjiaojiao.story",
		TalkId = 510107,
		TalkTriggerId = 510107,
		Type = "Impression",
	},
	[510108] = {
		StoryLinePath = "Impression/IceLakeCity/510108_Daixi.story",
		TalkId = 510108,
		TalkTriggerId = 510108,
		Type = "Impression",
	},
	[510109] = {
		StoryLinePath = "Impression/IceLakeCity/510109_Walun.story",
		TalkId = 510109,
		TalkTriggerId = 510109,
		Type = "Impression",
	},
	[510110] = {
		StoryLinePath = "Impression/IceLakeCity/510110_Halan.story",
		TalkId = 510110,
		TalkTriggerId = 510110,
		Type = "Impression",
	},
	[510111] = {
		StoryLinePath = "Impression/IceLakeCity/510111_Kongkongjiaojiao.story",
		TalkId = 510111,
		TalkTriggerId = 510111,
		Type = "Impression",
	},
	[510112] = {
		StoryLinePath = "Impression/IceLakeCity/510112_Ailisha.story",
		TalkId = 510112,
		TalkTriggerId = 510112,
		TriggerCondition = T.RT_53,
		Type = "Impression",
	},
	[510113] = {
		StoryLinePath = "Impression/IceLakeCity/510113_Miya.story",
		TalkId = 510113,
		TalkTriggerId = 510113,
		TriggerCondition = T.RT_53,
		Type = "Impression",
	},
	[510114] = {
		StoryLinePath = "Impression/IceLakeCity/510114_Yinyudeshaonian.story",
		TalkId = 510114,
		TalkTriggerId = 510114,
		TriggerCondition = T.RT_53,
		Type = "Impression",
	},
	[510115] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/510115.story",
		TalkId = 510115,
		TalkTriggerId = 510115,
	},
	[510116] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/510116.story",
		TalkId = 510116,
		TalkTriggerId = 510116,
	},
	[510117] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/510117.story",
		TalkId = 510117,
		TalkTriggerId = 510117,
	},
	[510118] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/510118.story",
		TalkId = 510118,
		TalkTriggerId = 510118,
	},
	[510119] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/510119.story",
		TalkId = 510119,
		TalkTriggerId = 510119,
	},
	[510120] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/510120.story",
		TalkId = 510120,
		TalkTriggerId = 510120,
	},
	[510122] = {
		StoryLinePath = "Impression/IceLakeCity/510122_Cat.story",
		TalkId = 510122,
		TalkTriggerId = 510122,
		Type = "Impression",
	},
	[510123] = {
		StoryLinePath = "Impression/East01/701005_LinghuNing",
		TalkId = 510123,
		TalkTriggerId = 510123,
		Type = "Impression",
	},
	[510124] = {
		StoryLinePath = "Impression/East01/701006_DuPing",
		TalkId = 510124,
		TalkTriggerId = 510124,
		Type = "Impression",
	},
	[510125] = {
		StoryLinePath = "Impression/East01/701007_YiSheng",
		TalkId = 510125,
		TalkTriggerId = 510125,
		Type = "Impression",
	},
	[510126] = {
		StoryLinePath = "Impression/East01/701008_LaMeng",
		TalkId = 510126,
		TalkTriggerId = 510126,
		Type = "Impression",
	},
	[510127] = {
		StoryLinePath = "Impression/East01/701009_MrCheng",
		TalkId = 510127,
		TalkTriggerId = 510127,
		Type = "Impression",
	},
	[510128] = {
		StoryLinePath = "Impression/East01/701011_JiangZhengyi",
		TalkId = 510128,
		TalkTriggerId = 510128,
		Type = "Impression",
	},
	[510129] = {
		StoryLinePath = "Impression/East01/701012_SaMi",
		TalkId = 510129,
		TalkTriggerId = 510129,
		Type = "Impression",
	},
	[510130] = {
		StoryLinePath = "Impression/East01/701013_LiShi",
		TalkId = 510130,
		TalkTriggerId = 510130,
		Type = "Impression",
	},
	[510131] = {
		StoryLinePath = "Impression/East01/701014_WuYe",
		TalkId = 510131,
		TalkTriggerId = 510131,
		Type = "Impression",
	},
	[510132] = {
		StoryLinePath = "Impression/East01/701015_Yang",
		TalkId = 510132,
		TalkTriggerId = 510132,
		Type = "Impression",
	},
	[510133] = {
		StoryLinePath = "Impression/East01/701019_XiaoYun",
		TalkId = 510133,
		TalkTriggerId = 510133,
		Type = "Impression",
	},
	[510134] = {
		StoryLinePath = "Impression/East01/701020_JuMu",
		TalkId = 510134,
		TalkTriggerId = 510134,
		Type = "Impression",
	},
	[510135] = {
		StoryLinePath = "Impression/East01/701021_LanYe",
		TalkId = 510135,
		TalkTriggerId = 510135,
		Type = "Impression",
	},
	[510136] = {
		StoryLinePath = "Impression/East01/701024_QingQing",
		TalkId = 510136,
		TalkTriggerId = 510136,
		Type = "Impression",
	},
	[510137] = {
		StoryLinePath = "Impression/East01/701026_QuanDoutong",
		TalkId = 510137,
		TalkTriggerId = 510137,
		Type = "Impression",
	},
	[510138] = {
		StoryLinePath = "Impression/East01/701027_DrHuang",
		TalkId = 510138,
		TalkTriggerId = 510138,
		Type = "Impression",
	},
	[510139] = {
		StoryLinePath = "Impression/East01/701029_YuXia",
		TalkId = 510139,
		TalkTriggerId = 510139,
		Type = "Impression",
	},
	[510140] = {
		StoryLinePath = "Impression/East01/701031_JiuPiaoZi",
		TalkId = 510140,
		TalkTriggerId = 510140,
		Type = "Impression",
	},
	[510141] = {
		StoryLinePath = "Impression/East01/701032_FengDeng",
		TalkId = 510141,
		TalkTriggerId = 510141,
		Type = "Impression",
	},
	[510142] = {
		StoryLinePath = "Impression/East01/701033_MysteryWhite",
		TalkId = 510142,
		TalkTriggerId = 510142,
		Type = "Impression",
	},
	[510143] = {
		StoryLinePath = "Impression/East01/701006_DuPing_2",
		TalkId = 510143,
		TalkTriggerId = 510143,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510124,
			},
		},
	},
	[510144] = {
		StoryLinePath = "Impression/East01/701008_LaMeng_2",
		TalkId = 510144,
		TalkTriggerId = 510144,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510126,
			},
		},
	},
	[510145] = {
		StoryLinePath = "Impression/East01/701009_MrCheng_2",
		TalkId = 510145,
		TalkTriggerId = 510145,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510127,
			},
		},
	},
	[510146] = {
		StoryLinePath = "Impression/East01/701011_JiangZhengyi_2",
		TalkId = 510146,
		TalkTriggerId = 510146,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510128,
			},
		},
	},
	[510147] = {
		StoryLinePath = "Impression/East01/701012_SaMi_2",
		TalkId = 510147,
		TalkTriggerId = 510147,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510129,
			},
		},
	},
	[510148] = {
		StoryLinePath = "Impression/East01/701013_LiShi_2",
		TalkId = 510148,
		TalkTriggerId = 510148,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510130,
			},
		},
	},
	[510149] = {
		StoryLinePath = "Impression/East01/701015_Yang_2",
		TalkId = 510149,
		TalkTriggerId = 510149,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 51013201,
			},
		},
	},
	[510150] = {
		StoryLinePath = "Impression/East01/701019_XiaoYun_2",
		TalkId = 510150,
		TalkTriggerId = 510150,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510133,
			},
		},
	},
	[510151] = {
		StoryLinePath = "Impression/East01/701020_JuMu_2",
		TalkId = 510151,
		TalkTriggerId = 510151,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510134,
			},
		},
	},
	[511010] = {
		StoryLinePath = "BubbleTalk/51101001.story",
		TalkId = 511010,
		TalkTriggerId = 511010,
	},
	[511252] = {
		StoryLinePath = "Impression/East01/Gossip/511252.story",
		TalkId = 511252,
		TalkTriggerId = 511252,
	},
	[511253] = {
		StoryLinePath = "Impression/East01/Gossip/511253.story",
		TalkId = 511253,
		TalkTriggerId = 511253,
	},
	[511254] = {
		StoryLinePath = "Impression/East01/Gossip/511254.story",
		TalkId = 511254,
		TalkTriggerId = 511254,
	},
	[511255] = {
		StoryLinePath = "Impression/East01/Gossip/511255.story",
		TalkId = 511255,
		TalkTriggerId = 511255,
		Type = "Impression",
	},
	[511256] = {
		StoryLinePath = "Impression/East01/Gossip/511256.story",
		TalkId = 511256,
		TalkTriggerId = 511256,
		Type = "Impression",
	},
	[511257] = {
		StoryLinePath = "Impression/East01/Gossip/511257.story",
		TalkId = 511257,
		TalkTriggerId = 511257,
	},
	[511258] = {
		StoryLinePath = "Impression/East01/Gossip/511258.story",
		TalkId = 511258,
		TalkTriggerId = 511258,
		Type = "Impression",
	},
	[511259] = {
		StoryLinePath = "Impression/East01/Gossip/511259.story",
		TalkId = 511259,
		TalkTriggerId = 511259,
	},
	[511260] = {
		StoryLinePath = "Impression/East01/Gossip/511260.story",
		TalkId = 511260,
		TalkTriggerId = 511260,
		Type = "Impression",
	},
	[511261] = {
		StoryLinePath = "Impression/East01/Gossip/511261.story",
		TalkId = 511261,
		TalkTriggerId = 511261,
	},
	[511262] = {
		StoryLinePath = "Impression/East01/Gossip/511262.story",
		TalkId = 511262,
		TalkTriggerId = 511262,
	},
	[511263] = {
		StoryLinePath = "Impression/East01/Gossip/511263.story",
		TalkId = 511263,
		TalkTriggerId = 511263,
	},
	[511264] = {
		StoryLinePath = "Impression/East01/Gossip/511264.story",
		TalkId = 511264,
		TalkTriggerId = 511264,
	},
	[511265] = {
		StoryLinePath = "Impression/East01/Gossip/511265.story",
		TalkId = 511265,
		TalkTriggerId = 511265,
	},
	[511266] = {
		StoryLinePath = "Impression/East01/Gossip/511266.story",
		TalkId = 511266,
		TalkTriggerId = 511266,
	},
	[511267] = {
		StoryLinePath = "Impression/East01/Gossip/511267.story",
		TalkId = 511267,
		TalkTriggerId = 511267,
	},
	[511268] = {
		StoryLinePath = "Impression/East01/Gossip/511268.story",
		TalkId = 511268,
		TalkTriggerId = 511268,
	},
	[511269] = {
		StoryLinePath = "Impression/East01/Gossip/511269.story",
		TalkId = 511269,
		TalkTriggerId = 511269,
	},
	[511270] = {
		StoryLinePath = "Impression/East01/Gossip/511270.story",
		TalkId = 511270,
		TalkTriggerId = 511270,
	},
	[511271] = {
		StoryLinePath = "Impression/East01/Gossip/511271.story",
		TalkId = 511271,
		TalkTriggerId = 511271,
		Type = "Impression",
	},
	[511272] = {
		StoryLinePath = "Impression/East01/Gossip/511272.story",
		TalkId = 511272,
		TalkTriggerId = 511272,
	},
	[511273] = {
		StoryLinePath = "Impression/East01/Gossip/511273.story",
		TalkId = 511273,
		TalkTriggerId = 511273,
		Type = "Impression",
	},
	[511274] = {
		StoryLinePath = "Impression/East01/Gossip/511274.story",
		TalkId = 511274,
		TalkTriggerId = 511274,
	},
	[511275] = {
		StoryLinePath = "Impression/East01/Gossip/511275.story",
		TalkId = 511275,
		TalkTriggerId = 511275,
		Type = "Impression",
	},
	[511276] = {
		StoryLinePath = "Impression/East01/Gossip/511276.story",
		TalkId = 511276,
		TalkTriggerId = 511276,
	},
	[511277] = {
		StoryLinePath = "Impression/East01/Gossip/511277.story",
		TalkId = 511277,
		TalkTriggerId = 511277,
	},
	[511278] = {
		StoryLinePath = "Impression/East01/Gossip/511278.story",
		TalkId = 511278,
		TalkTriggerId = 511278,
	},
	[511279] = {
		StoryLinePath = "Impression/East01/Gossip/511279.story",
		TalkId = 511279,
		TalkTriggerId = 511279,
		Type = "Impression",
	},
	[511280] = {
		StoryLinePath = "Impression/East01/Gossip/511280.story",
		TalkId = 511280,
		TalkTriggerId = 511280,
		Type = "Impression",
	},
	[511282] = {
		StoryLinePath = "Impression/East01/Gossip/511282.story",
		TalkId = 511282,
		TalkTriggerId = 511282,
		Type = "Impression",
	},
	[511511] = {
		StoryLinePath = "Impression/East01/Gossip/511511_WangChun.story",
		TalkId = 511511,
		TalkTriggerId = 511511,
	},
	[511512] = {
		StoryLinePath = "Impression/East01/Gossip/511512_BaiJL.story",
		TalkId = 511512,
		TalkTriggerId = 511512,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 12010203,
			},
		},
	},
	[511514] = {
		StoryLinePath = "Impression/East01/Gossip/511514_BaiDD.story",
		TalkId = 511514,
		TalkTriggerId = 511514,
	},
	[511530] = {
		StoryLinePath = "BubbleTalk/511530.story",
		TalkId = 511530,
		TalkTriggerId = 511530,
	},
	[511531] = {
		StoryLinePath = "BubbleTalk/511531.story",
		TalkId = 511531,
		TalkTriggerId = 511531,
	},
	[511550] = {
		StoryLinePath = "BubbleTalk/511550.story",
		TalkId = 511550,
		TalkTriggerId = 511550,
	},
	[511560] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511560.story",
		TalkId = 511560,
		TalkTriggerId = 511560,
		Type = "Impression",
	},
	[511561] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511561.story",
		TalkId = 511561,
		TalkTriggerId = 511561,
	},
	[511562] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511562.story",
		TalkId = 511562,
		TalkTriggerId = 511562,
		Type = "Impression",
	},
	[511563] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511563.story",
		TalkId = 511563,
		TalkTriggerId = 511563,
	},
	[511564] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511564.story",
		TalkId = 511564,
		TalkTriggerId = 511564,
	},
	[511565] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511565.story",
		TalkId = 511565,
		TalkTriggerId = 511565,
	},
	[511566] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511566.story",
		TalkId = 511566,
		TalkTriggerId = 511566,
	},
	[511567] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511567.story",
		TalkId = 511567,
		TalkTriggerId = 511567,
	},
	[511568] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511568.story",
		TalkId = 511568,
		TalkTriggerId = 511568,
	},
	[511569] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511569.story",
		TalkId = 511569,
		TalkTriggerId = 511569,
		Type = "Impression",
	},
	[511570] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511570.story",
		TalkId = 511570,
		TalkTriggerId = 511570,
	},
	[511576] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511576.story",
		TalkId = 511576,
		TalkTriggerId = 511576,
	},
	[511579] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511579.story",
		TalkId = 511579,
		TalkTriggerId = 511579,
	},
	[511580] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511580.story",
		TalkId = 511580,
		TalkTriggerId = 511580,
		Type = "Impression",
	},
	[511581] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511581.story",
		TalkId = 511581,
		TalkTriggerId = 511581,
	},
	[511582] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511582.story",
		TalkId = 511582,
		TalkTriggerId = 511582,
		Type = "Impression",
	},
	[511583] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511583.story",
		TalkId = 511583,
		TalkTriggerId = 511583,
	},
	[511584] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511584.story",
		TalkId = 511584,
		TalkTriggerId = 511584,
	},
	[511585] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511585.story",
		TalkId = 511585,
		TalkTriggerId = 511585,
	},
	[511586] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511586.story",
		TalkId = 511586,
		TalkTriggerId = 511586,
	},
	[511587] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511587.story",
		TalkId = 511587,
		TalkTriggerId = 511587,
	},
	[511588] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511588.story",
		TalkId = 511588,
		TalkTriggerId = 511588,
	},
	[511589] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511589.story",
		TalkId = 511589,
		TalkTriggerId = 511589,
	},
	[511590] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511590.story",
		TalkId = 511590,
		TalkTriggerId = 511590,
	},
	[511591] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511591.story",
		TalkId = 511591,
		TalkTriggerId = 511591,
	},
	[511592] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511592.story",
		TalkId = 511592,
		TalkTriggerId = 511592,
	},
	[511593] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511593.story",
		TalkId = 511593,
		TalkTriggerId = 511593,
	},
	[511594] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511594.story",
		TalkId = 511594,
		TalkTriggerId = 511594,
		Type = "Impression",
	},
	[511595] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511595.story",
		TalkId = 511595,
		TalkTriggerId = 511595,
	},
	[511596] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511596.story",
		TalkId = 511596,
		TalkTriggerId = 511596,
		Type = "Impression",
	},
	[511597] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511597.story",
		TalkId = 511597,
		TalkTriggerId = 511597,
	},
	[511598] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511598.story",
		TalkId = 511598,
		TalkTriggerId = 511598,
	},
	[511599] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511599.story",
		TalkId = 511599,
		TalkTriggerId = 511599,
	},
	[511601] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511601.story",
		TalkId = 511601,
		TalkTriggerId = 511601,
	},
	[511602] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511602.story",
		TalkId = 511602,
		TalkTriggerId = 511602,
	},
	[511603] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511603.story",
		TalkId = 511603,
		TalkTriggerId = 511603,
	},
	[511604] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511604.story",
		TalkId = 511604,
		TalkTriggerId = 511604,
	},
	[511605] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511605.story",
		TalkId = 511605,
		TalkTriggerId = 511605,
	},
	[511606] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511606.story",
		TalkId = 511606,
		TalkTriggerId = 511606,
		Type = "Impression",
	},
	[511608] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511608.story",
		TalkId = 511608,
		TalkTriggerId = 511608,
	},
	[511609] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511609.story",
		TalkId = 511609,
		TalkTriggerId = 511609,
	},
	[511610] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511610.story",
		TalkId = 511610,
		TalkTriggerId = 511610,
		Type = "Impression",
	},
	[511611] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511611.story",
		TalkId = 511611,
		TalkTriggerId = 511611,
	},
	[511613] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511613.story",
		TalkId = 511613,
		TalkTriggerId = 511613,
	},
	[511614] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511614.story",
		TalkId = 511614,
		TalkTriggerId = 511614,
	},
	[511615] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511615.story",
		TalkId = 511615,
		TalkTriggerId = 511615,
	},
	[511616] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511616.story",
		TalkId = 511616,
		TalkTriggerId = 511616,
	},
	[511617] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511617.story",
		TalkId = 511617,
		TalkTriggerId = 511617,
	},
	[511618] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511618.story",
		TalkId = 511618,
		TalkTriggerId = 511618,
	},
	[511620] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511620.story",
		TalkId = 511620,
		TalkTriggerId = 511620,
	},
	[511621] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511621.story",
		TalkId = 511621,
		TalkTriggerId = 511621,
	},
	[511622] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511622.story",
		TalkId = 511622,
		TalkTriggerId = 511622,
	},
	[511623] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511623.story",
		TalkId = 511623,
		TalkTriggerId = 511623,
	},
	[511624] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511624.story",
		TalkId = 511624,
		TalkTriggerId = 511624,
	},
	[511625] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511625.story",
		TalkId = 511625,
		TalkTriggerId = 511625,
	},
	[511626] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511626.story",
		TalkId = 511626,
		TalkTriggerId = 511626,
	},
	[511627] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511627.story",
		TalkId = 511627,
		TalkTriggerId = 511627,
	},
	[511628] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511628.story",
		TalkId = 511628,
		TalkTriggerId = 511628,
	},
	[511629] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511629.story",
		TalkId = 511629,
		TalkTriggerId = 511629,
		Type = "Impression",
	},
	[511670] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511670.story",
		TalkId = 511670,
		TalkTriggerId = 511670,
	},
	[511671] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511671.story",
		TalkId = 511671,
		TalkTriggerId = 511671,
	},
	[511672] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511672.story",
		TalkId = 511672,
		TalkTriggerId = 511672,
	},
	[511673] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511673.story",
		TalkId = 511673,
		TalkTriggerId = 511673,
	},
	[511674] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511674.story",
		TalkId = 511674,
		TalkTriggerId = 511674,
	},
	[511675] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511675.story",
		TalkId = 511675,
		TalkTriggerId = 511675,
	},
	[511676] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511676.story",
		TalkId = 511676,
		TalkTriggerId = 511676,
	},
	[511677] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511677.story",
		TalkId = 511677,
		TalkTriggerId = 511677,
	},
	[511678] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511678.story",
		TalkId = 511678,
		TalkTriggerId = 511678,
	},
	[511679] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511679.story",
		TalkId = 511679,
		TalkTriggerId = 511679,
	},
	[511680] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511680.story",
		TalkId = 511680,
		TalkTriggerId = 511680,
	},
	[511681] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511681.story",
		TalkId = 511681,
		TalkTriggerId = 511681,
	},
	[511682] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511682.story",
		TalkId = 511682,
		TalkTriggerId = 511682,
	},
	[511683] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511683.story",
		TalkId = 511683,
		TalkTriggerId = 511683,
	},
	[511684] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511684.story",
		TalkId = 511684,
		TalkTriggerId = 511684,
	},
	[511685] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511685.story",
		TalkId = 511685,
		TalkTriggerId = 511685,
	},
	[511686] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511686.story",
		TalkId = 511686,
		TalkTriggerId = 511686,
	},
	[511687] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511687.story",
		TalkId = 511687,
		TalkTriggerId = 511687,
	},
	[511688] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511688.story",
		TalkId = 511688,
		TalkTriggerId = 511688,
	},
	[511689] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511689.story",
		TalkId = 511689,
		TalkTriggerId = 511689,
	},
	[511690] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511690.story",
		TalkId = 511690,
		TalkTriggerId = 511690,
	},
	[511691] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511691.story",
		TalkId = 511691,
		TalkTriggerId = 511691,
	},
	[511692] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511692.story",
		TalkId = 511692,
		TalkTriggerId = 511692,
	},
	[511693] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511693.story",
		TalkId = 511693,
		TalkTriggerId = 511693,
	},
	[511694] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511694.story",
		TalkId = 511694,
		TalkTriggerId = 511694,
	},
	[511695] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511695.story",
		TalkId = 511695,
		TalkTriggerId = 511695,
	},
	[511696] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511696.story",
		TalkId = 511696,
		TalkTriggerId = 511696,
	},
	[511697] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511697.story",
		TalkId = 511697,
		TalkTriggerId = 511697,
	},
	[511699] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511699.story",
		TalkId = 511699,
		TalkTriggerId = 511699,
	},
	[511700] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511700.story",
		TalkId = 511700,
		TalkTriggerId = 511700,
	},
	[511701] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511701.story",
		TalkId = 511701,
		TalkTriggerId = 511701,
	},
	[511702] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511702.story",
		TalkId = 511702,
		TalkTriggerId = 511702,
	},
	[511703] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511703.story",
		TalkId = 511703,
		TalkTriggerId = 511703,
	},
	[511704] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511704.story",
		TalkId = 511704,
		TalkTriggerId = 511704,
	},
	[511705] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511705.story",
		TalkId = 511705,
		TalkTriggerId = 511705,
	},
	[511706] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511706.story",
		TalkId = 511706,
		TalkTriggerId = 511706,
	},
	[511707] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511707.story",
		TalkId = 511707,
		TalkTriggerId = 511707,
	},
	[511708] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511708.story",
		TalkId = 511708,
		TalkTriggerId = 511708,
	},
	[511709] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511709.story",
		TalkId = 511709,
		TalkTriggerId = 511709,
	},
	[511710] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511710.story",
		TalkId = 511710,
		TalkTriggerId = 511710,
	},
	[511711] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511711.story",
		TalkId = 511711,
		TalkTriggerId = 511711,
	},
	[511712] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511712.story",
		TalkId = 511712,
		TalkTriggerId = 511712,
	},
	[511713] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511713.story",
		TalkId = 511713,
		TalkTriggerId = 511713,
	},
	[511714] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511714.story",
		TalkId = 511714,
		TalkTriggerId = 511714,
	},
	[511715] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511715.story",
		TalkId = 511715,
		TalkTriggerId = 511715,
	},
	[511716] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511716.story",
		TalkId = 511716,
		TalkTriggerId = 511716,
	},
	[511717] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511717.story",
		TalkId = 511717,
		TalkTriggerId = 511717,
	},
	[511718] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511718.story",
		TalkId = 511718,
		TalkTriggerId = 511718,
	},
	[511719] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511719.story",
		TalkId = 511719,
		TalkTriggerId = 511719,
	},
	[511720] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511720.story",
		TalkId = 511720,
		TalkTriggerId = 511720,
	},
	[511721] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511721.story",
		TalkId = 511721,
		TalkTriggerId = 511721,
	},
	[511722] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511722.story",
		TalkId = 511722,
		TalkTriggerId = 511722,
	},
	[511723] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511723.story",
		TalkId = 511723,
		TalkTriggerId = 511723,
	},
	[511724] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511724.story",
		TalkId = 511724,
		TalkTriggerId = 511724,
	},
	[511725] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511725.story",
		TalkId = 511725,
		TalkTriggerId = 511725,
	},
	[511726] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511726.story",
		TalkId = 511726,
		TalkTriggerId = 511726,
	},
	[511727] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511727.story",
		TalkId = 511727,
		TalkTriggerId = 511727,
	},
	[511728] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511728.story",
		TalkId = 511728,
		TalkTriggerId = 511728,
	},
	[511729] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511729.story",
		TalkId = 511729,
		TalkTriggerId = 511729,
	},
	[511731] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511731.story",
		TalkId = 511731,
		TalkTriggerId = 511731,
	},
	[511732] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511732.story",
		TalkId = 511732,
		TalkTriggerId = 511732,
	},
	[511733] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511733.story",
		TalkId = 511733,
		TalkTriggerId = 511733,
	},
	[511734] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511734.story",
		TalkId = 511734,
		TalkTriggerId = 511734,
	},
	[511735] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511735.story",
		TalkId = 511735,
		TalkTriggerId = 511735,
	},
	[511736] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511736.story",
		TalkId = 511736,
		TalkTriggerId = 511736,
	},
	[511737] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511681.story",
		TalkId = 511737,
		TalkTriggerId = 511737,
	},
	[511738] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511682.story",
		TalkId = 511738,
		TalkTriggerId = 511738,
	},
	[511739] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511683.story",
		TalkId = 511739,
		TalkTriggerId = 511739,
	},
	[511740] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511684.story",
		TalkId = 511740,
		TalkTriggerId = 511740,
	},
	[511741] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511685.story",
		TalkId = 511741,
		TalkTriggerId = 511741,
	},
	[511742] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511686.story",
		TalkId = 511742,
		TalkTriggerId = 511742,
	},
	[511743] = {
		StoryLinePath = "Impression/East02/Gossip/511743.story",
		TalkId = 511743,
		TalkTriggerId = 511743,
	},
	[511744] = {
		StoryLinePath = "Impression/East02/Gossip/511744.story",
		TalkId = 511744,
		TalkTriggerId = 511744,
	},
	[511745] = {
		StoryLinePath = "Impression/East02/Gossip/511745.story",
		TalkId = 511745,
		TalkTriggerId = 511745,
	},
	[511746] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511746.story",
		TalkId = 511746,
		TalkTriggerId = 511746,
	},
	[511747] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511747.story",
		TalkId = 511747,
		TalkTriggerId = 511747,
	},
	[511748] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511748.story",
		TalkId = 511748,
		TalkTriggerId = 511748,
	},
	[511749] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511749.story",
		TalkId = 511749,
		TalkTriggerId = 511749,
	},
	[511750] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511750.story",
		TalkId = 511750,
		TalkTriggerId = 511750,
	},
	[511751] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511751.story",
		TalkId = 511751,
		TalkTriggerId = 511751,
	},
	[600101] = {
		DialogueId = 60010101,
		TalkTriggerId = 600101,
		TalkType = "Guide",
	},
	[600102] = {
		DialogueId = 60010201,
		TalkTriggerId = 600102,
		TalkType = "Guide",
	},
	[600103] = {
		DialogueId = 60010301,
		TalkTriggerId = 600103,
		TalkType = "Guide",
	},
	[600104] = {
		DialogueId = 60010401,
		TalkTriggerId = 600104,
		TalkType = "Guide",
	},
	[600105] = {
		DialogueId = 60010501,
		TalkTriggerId = 600105,
		TalkType = "Guide",
	},
	[600106] = {
		DialogueId = 60010601,
		TalkTriggerId = 600106,
		TalkType = "Guide",
	},
	[600107] = {
		DialogueId = 60010701,
		TalkTriggerId = 600107,
		TalkType = "Guide",
	},
	[600201] = {
		DialogueId = 60020101,
		TalkTriggerId = 600201,
		TalkType = "Guide",
	},
	[600202] = {
		DialogueId = 60020201,
		TalkTriggerId = 600202,
		TalkType = "Guide",
	},
	[600203] = {
		DialogueId = 60020301,
		TalkTriggerId = 600203,
		TalkType = "Guide",
	},
	[600204] = {
		DialogueId = 60020401,
		TalkTriggerId = 600204,
		TalkType = "Guide",
	},
	[600205] = {
		DialogueId = 60020501,
		TalkTriggerId = 600205,
		TalkType = "Guide",
	},
	[600206] = {
		DialogueId = 60020601,
		TalkTriggerId = 600206,
		TalkType = "Guide",
	},
	[600207] = {
		DialogueId = 60020701,
		TalkTriggerId = 600207,
		TalkType = "Guide",
	},
	[600208] = {
		DialogueId = 60020801,
		TalkTriggerId = 600208,
		TalkType = "Guide",
	},
	[600209] = {
		DialogueId = 60020901,
		TalkTriggerId = 600209,
		TalkType = "Guide",
	},
	[600301] = {
		DialogueId = 60030101,
		TalkTriggerId = 600301,
		TalkType = "Guide",
	},
	[600302] = {
		DialogueId = 60030201,
		TalkTriggerId = 600302,
		TalkType = "Guide",
	},
	[600303] = {
		DialogueId = 60030301,
		TalkTriggerId = 600303,
		TalkType = "Guide",
	},
	[600304] = {
		DialogueId = 60030401,
		TalkTriggerId = 600304,
		TalkType = "Guide",
	},
	[600305] = {
		DialogueId = 60030501,
		TalkTriggerId = 600305,
		TalkType = "Guide",
	},
	[600306] = {
		DialogueId = 60030601,
		TalkTriggerId = 600306,
		TalkType = "Guide",
	},
	[600307] = {
		DialogueId = 60030701,
		TalkTriggerId = 600307,
		TalkType = "Guide",
	},
	[600308] = {
		DialogueId = 60030801,
		TalkTriggerId = 600308,
		TalkType = "Guide",
	},
	[600309] = {
		DialogueId = 60030901,
		TalkTriggerId = 600309,
		TalkType = "Guide",
	},
	[600310] = {
		DialogueId = 60031001,
		TalkTriggerId = 600310,
		TalkType = "Guide",
	},
	[600311] = {
		DialogueId = 60031101,
		TalkTriggerId = 600311,
		TalkType = "Guide",
	},
	[600312] = {
		DialogueId = 60031201,
		TalkTriggerId = 600312,
		TalkType = "Guide",
	},
	[600401] = {
		DialogueId = 60040101,
		TalkTriggerId = 600401,
		TalkType = "Guide",
	},
	[600402] = {
		DialogueId = 60040201,
		TalkTriggerId = 600402,
		TalkType = "Guide",
	},
	[600403] = {
		DialogueId = 60040301,
		TalkTriggerId = 600403,
		TalkType = "Guide",
	},
	[600404] = {
		DialogueId = 60040401,
		TalkTriggerId = 600404,
		TalkType = "Guide",
	},
	[600405] = {
		DialogueId = 60040501,
		TalkTriggerId = 600405,
		TalkType = "Guide",
	},
	[600406] = {
		DialogueId = 60040601,
		TalkTriggerId = 600406,
		TalkType = "Guide",
	},
	[600407] = {
		DialogueId = 60040701,
		TalkTriggerId = 600407,
		TalkType = "Guide",
	},
	[600408] = {
		DialogueId = 60040801,
		TalkTriggerId = 600408,
		TalkType = "Guide",
	},
	[600501] = {
		DialogueId = 60050101,
		TalkTriggerId = 600501,
		TalkType = "Guide",
	},
	[600502] = {
		DialogueId = 60050201,
		TalkTriggerId = 600502,
		TalkType = "Guide",
	},
	[600601] = {
		StoryLinePath = "Dungeon/Common/600601.story",
		TalkTriggerId = 600601,
	},
	[600602] = {
		DialogueId = 60060201,
		TalkTriggerId = 600602,
		TalkType = "Guide",
	},
	[600603] = {
		DialogueId = 60060301,
		TalkTriggerId = 600603,
		TalkType = "Guide",
	},
	[600604] = {
		DialogueId = 60060401,
		TalkTriggerId = 600604,
		TalkType = "Guide",
	},
	[600605] = {
		DialogueId = 60060501,
		TalkTriggerId = 600605,
		TalkType = "Guide",
	},
	[600606] = {
		DialogueId = 60060601,
		TalkTriggerId = 600606,
		TalkType = "Guide",
	},
	[600607] = {
		DialogueId = 60060701,
		TalkTriggerId = 600607,
		TalkType = "Guide",
	},
	[600608] = {
		DialogueId = 60060801,
		TalkTriggerId = 600608,
		TalkType = "Guide",
	},
	[600609] = {
		DialogueId = 60060901,
		TalkTriggerId = 600609,
		TalkType = "Guide",
	},
	[601101] = {
		DialogueId = 60110101,
		TalkTriggerId = 601101,
		TalkType = "Guide",
	},
	[601102] = {
		DialogueId = 60110201,
		TalkTriggerId = 601102,
		TalkType = "Guide",
	},
	[601103] = {
		DialogueId = 60110301,
		TalkTriggerId = 601103,
		TalkType = "Guide",
	},
	[601105] = {
		DialogueId = 60110501,
		TalkTriggerId = 601105,
		TalkType = "Guide",
	},
	[601106] = {
		DialogueId = 60110601,
		TalkTriggerId = 601106,
		TalkType = "Guide",
	},
	[601107] = {
		DialogueId = 60110701,
		TalkTriggerId = 601107,
		TalkType = "Guide",
	},
	[601201] = {
		DialogueId = 60120101,
		TalkTriggerId = 601201,
		TalkType = "Guide",
	},
	[601202] = {
		DialogueId = 60120201,
		TalkTriggerId = 601202,
		TalkType = "Guide",
	},
	[601203] = {
		DialogueId = 60120301,
		TalkTriggerId = 601203,
		TalkType = "Guide",
	},
	[601204] = {
		DialogueId = 60120401,
		TalkTriggerId = 601204,
		TalkType = "Guide",
	},
	[601205] = {
		DialogueId = 60120501,
		TalkTriggerId = 601205,
		TalkType = "Guide",
	},
	[601206] = {
		DialogueId = 60120601,
		TalkTriggerId = 601206,
		TalkType = "Guide",
	},
	[601301] = {
		DialogueId = 60130101,
		TalkTriggerId = 601301,
		TalkType = "Guide",
	},
	[601302] = {
		DialogueId = 60130201,
		TalkTriggerId = 601302,
		TalkType = "Guide",
	},
	[601303] = {
		DialogueId = 60130301,
		TalkTriggerId = 601303,
		TalkType = "Guide",
	},
	[601304] = {
		DialogueId = 60130401,
		TalkTriggerId = 601304,
		TalkType = "Guide",
	},
	[601305] = {
		DialogueId = 60130501,
		TalkTriggerId = 601305,
		TalkType = "Guide",
	},
	[601306] = {
		DialogueId = 60130601,
		TalkTriggerId = 601306,
		TalkType = "Guide",
	},
	[601307] = {
		DialogueId = 60130701,
		TalkTriggerId = 601307,
		TalkType = "Guide",
	},
	[601308] = {
		DialogueId = 60130801,
		TalkTriggerId = 601308,
		TalkType = "Guide",
	},
	[602001] = {
		DialogueId = 60200101,
		TalkTriggerId = 602001,
		TalkType = "Guide",
	},
	[602002] = {
		DialogueId = 60200201,
		TalkTriggerId = 602002,
		TalkType = "Guide",
	},
	[602003] = {
		DialogueId = 60200301,
		TalkTriggerId = 602003,
		TalkType = "Guide",
	},
	[602004] = {
		DialogueId = 60200401,
		TalkTriggerId = 602004,
		TalkType = "Guide",
	},
	[602005] = {
		DialogueId = 60200501,
		TalkTriggerId = 602005,
		TalkType = "Guide",
	},
	[602101] = {
		DialogueId = 60210101,
		TalkTriggerId = 602101,
		TalkType = "Guide",
	},
	[602102] = {
		DialogueId = 60210201,
		TalkTriggerId = 602102,
		TalkType = "Guide",
	},
	[602103] = {
		DialogueId = 60210301,
		TalkTriggerId = 602103,
		TalkType = "Guide",
	},
	[602201] = {
		DialogueId = 60220101,
		TalkTriggerId = 602201,
		TalkType = "Guide",
	},
	[602202] = {
		DialogueId = 60220201,
		TalkTriggerId = 602202,
		TalkType = "Guide",
	},
	[602203] = {
		DialogueId = 60220301,
		TalkTriggerId = 602203,
		TalkType = "Guide",
	},
	[602204] = {
		DialogueId = 60220401,
		TalkTriggerId = 602204,
		TalkType = "Guide",
	},
	[602205] = {
		DialogueId = 60220501,
		TalkTriggerId = 602205,
		TalkType = "Guide",
	},
	[602206] = {
		DialogueId = 60220601,
		TalkTriggerId = 602206,
		TalkType = "Guide",
	},
	[602207] = {
		DialogueId = 60220701,
		TalkTriggerId = 602207,
		TalkType = "Guide",
	},
	[602208] = {
		DialogueId = 60220801,
		TalkTriggerId = 602208,
		TalkType = "Guide",
	},
	[602209] = {
		DialogueId = 60220901,
		TalkTriggerId = 602209,
		TalkType = "Guide",
	},
	[602210] = {
		DialogueId = 60221001,
		TalkTriggerId = 602210,
		TalkType = "Guide",
	},
	[602211] = {
		DialogueId = 60221101,
		TalkTriggerId = 602211,
		TalkType = "Guide",
	},
	[602212] = {
		DialogueId = 60221201,
		TalkTriggerId = 602212,
		TalkType = "Guide",
	},
	[602213] = {
		DialogueId = 60221301,
		TalkTriggerId = 602213,
		TalkType = "Guide",
	},
	[602214] = {
		DialogueId = 60221401,
		TalkTriggerId = 602214,
		TalkType = "Guide",
	},
	[602215] = {
		DialogueId = 60221501,
		TalkTriggerId = 602215,
		TalkType = "Guide",
	},
	[602216] = {
		DialogueId = 60221601,
		TalkTriggerId = 602216,
		TalkType = "Guide",
	},
	[602301] = {
		DialogueId = 60230101,
		TalkTriggerId = 602301,
		TalkType = "Guide",
	},
	[602302] = {
		DialogueId = 60230201,
		TalkTriggerId = 602302,
		TalkType = "Guide",
	},
	[602303] = {
		DialogueId = 60230301,
		TalkTriggerId = 602303,
		TalkType = "Guide",
	},
	[602304] = {
		DialogueId = 60230401,
		TalkTriggerId = 602304,
		TalkType = "Guide",
	},
	[602401] = {
		DialogueId = 60240101,
		TalkTriggerId = 602401,
		TalkType = "Guide",
	},
	[602402] = {
		DialogueId = 60240201,
		TalkTriggerId = 602402,
		TalkType = "Guide",
	},
	[602403] = {
		DialogueId = 60240301,
		TalkTriggerId = 602403,
		TalkType = "Guide",
	},
	[602404] = {
		DialogueId = 60240401,
		TalkTriggerId = 602404,
		TalkType = "Guide",
	},
	[602405] = {
		DialogueId = 60240501,
		TalkTriggerId = 602405,
		TalkType = "Guide",
	},
	[602406] = {
		DialogueId = 60240601,
		TalkTriggerId = 602406,
		TalkType = "Guide",
	},
	[602407] = {
		DialogueId = 60240701,
		TalkTriggerId = 602407,
		TalkType = "Guide",
	},
	[602408] = {
		DialogueId = 60240801,
		TalkTriggerId = 602408,
		TalkType = "Guide",
	},
	[602409] = {
		DialogueId = 60240901,
		TalkTriggerId = 602409,
		TalkType = "Guide",
	},
	[602410] = {
		DialogueId = 60241001,
		TalkTriggerId = 602410,
		TalkType = "Guide",
	},
	[602411] = {
		DialogueId = 60241101,
		TalkTriggerId = 602411,
		TalkType = "Guide",
	},
	[602412] = {
		DialogueId = 60241201,
		TalkTriggerId = 602412,
		TalkType = "Guide",
	},
	[602413] = {
		DialogueId = 60241301,
		TalkTriggerId = 602413,
		TalkType = "Guide",
	},
	[602414] = {
		DialogueId = 60241401,
		TalkTriggerId = 602414,
		TalkType = "Guide",
	},
	[602415] = {
		DialogueId = 60241501,
		TalkTriggerId = 602415,
		TalkType = "Guide",
	},
	[603001] = {
		DialogueId = 60300101,
		TalkTriggerId = 603001,
		TalkType = "Guide",
	},
	[608001] = {
		DialogueId = 60800101,
		TalkTriggerId = 608001,
		TalkType = "Guide",
	},
	[699901] = {
		StoryLinePath = "Rogue/Test_1.story",
		TalkId = 699901,
		TalkTriggerId = 699901,
	},
	[699902] = {
		StoryLinePath = "Rogue/Test_2.story",
		TalkId = 699902,
		TalkTriggerId = 699902,
	},
	[699903] = {
		StoryLinePath = "Rogue/Test_3.story",
		TalkId = 699903,
		TalkTriggerId = 699903,
	},
	[699991] = {
		StoryLinePath = "Rogue/699991_Shop_1_Bubble.story",
		TalkId = 699991,
		TalkTriggerId = 699991,
	},
	[699992] = {
		StoryLinePath = "Rogue/699992_Shop_1.story",
		TalkId = 699992,
		TalkTriggerId = 699992,
	},
	[700001] = {
		DialogueId = 10038101,
		TalkTriggerId = 700001,
		TalkType = "Black",
	},
	[700101] = {
		StoryLinePath = "Observe/Village.story",
		TalkId = 700101,
		TalkTriggerId = 700101,
	},
	[700102] = {
		StoryLinePath = "Observe/Village.story",
		TalkId = 700102,
		TalkTriggerId = 700102,
	},
	[700103] = {
		StoryLinePath = "Observe/Village.story",
		TalkId = 700103,
		TalkTriggerId = 700103,
	},
	[700104] = {
		StoryLinePath = "Observe/Village.story",
		TalkId = 700104,
		TalkTriggerId = 700104,
	},
	[700105] = {
		StoryLinePath = "Observe/Village.story",
		TalkId = 700105,
		TalkTriggerId = 700105,
	},
	[700106] = {
		StoryLinePath = "Observe/Village.story",
		TalkId = 700106,
		TalkTriggerId = 700106,
	},
	[700107] = {
		StoryLinePath = "Observe/Village.story",
		TalkId = 700107,
		TalkTriggerId = 700107,
	},
	[700108] = {
		StoryLinePath = "Observe/Village.story",
		TalkId = 700108,
		TalkTriggerId = 700108,
	},
	[700109] = {
		StoryLinePath = "Observe/Village.story",
		TalkId = 700109,
		TalkTriggerId = 700109,
	},
	[700110] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700110,
		TalkTriggerId = 700110,
	},
	[700111] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700111,
		TalkTriggerId = 700111,
	},
	[700112] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700112,
		TalkTriggerId = 700112,
	},
	[700113] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700113,
		TalkTriggerId = 700113,
	},
	[700114] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700114,
		TalkTriggerId = 700114,
	},
	[700115] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700115,
		TalkTriggerId = 700115,
	},
	[700116] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700116,
		TalkTriggerId = 700116,
	},
	[700117] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700117,
		TalkTriggerId = 700117,
	},
	[700118] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700118,
		TalkTriggerId = 700118,
	},
	[700119] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700119,
		TalkTriggerId = 700119,
	},
	[700120] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700120,
		TalkTriggerId = 700120,
	},
	[700121] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700121,
		TalkTriggerId = 700121,
	},
	[700122] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700122,
		TalkTriggerId = 700122,
	},
	[700123] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700123,
		TalkTriggerId = 700123,
	},
	[700124] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700124,
		TalkTriggerId = 700124,
	},
	[700125] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700125,
		TalkTriggerId = 700125,
	},
	[700126] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700126,
		TalkTriggerId = 700126,
	},
	[700127] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700127,
		TalkTriggerId = 700127,
	},
	[700128] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700128,
		TalkTriggerId = 700128,
	},
	[700129] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700129,
		TalkTriggerId = 700129,
	},
	[700130] = {
		StoryLinePath = "Observe/IceLakeCity_1.story",
		TalkId = 700130,
		TalkTriggerId = 700130,
	},
	[700131] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700131,
		TalkTriggerId = 700131,
	},
	[700132] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700132,
		TalkTriggerId = 700132,
	},
	[700133] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700133,
		TalkTriggerId = 700133,
	},
	[700134] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700134,
		TalkTriggerId = 700134,
	},
	[700135] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700135,
		TalkTriggerId = 700135,
	},
	[700136] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700136,
		TalkTriggerId = 700136,
	},
	[700137] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700137,
		TalkTriggerId = 700137,
	},
	[700138] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700138,
		TalkTriggerId = 700138,
	},
	[700139] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700139,
		TalkTriggerId = 700139,
	},
	[700140] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700140,
		TalkTriggerId = 700140,
	},
	[700141] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700141,
		TalkTriggerId = 700141,
	},
	[700142] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700142,
		TalkTriggerId = 700142,
	},
	[700143] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700143,
		TalkTriggerId = 700143,
	},
	[700144] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700144,
		TalkTriggerId = 700144,
	},
	[700145] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700145,
		TalkTriggerId = 700145,
	},
	[700146] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700146,
		TalkTriggerId = 700146,
	},
	[700147] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700147,
		TalkTriggerId = 700147,
	},
	[700148] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700148,
		TalkTriggerId = 700148,
	},
	[700149] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700149,
		TalkTriggerId = 700149,
	},
	[700150] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700150,
		TalkTriggerId = 700150,
	},
	[700151] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700151,
		TalkTriggerId = 700151,
	},
	[700152] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700152,
		TalkTriggerId = 700152,
	},
	[700153] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700153,
		TalkTriggerId = 700153,
	},
	[700154] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700154,
		TalkTriggerId = 700154,
	},
	[700155] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700155,
		TalkTriggerId = 700155,
	},
	[700156] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700156,
		TalkTriggerId = 700156,
	},
	[700157] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700157,
		TalkTriggerId = 700157,
	},
	[700158] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700158,
		TalkTriggerId = 700158,
	},
	[700159] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700159,
		TalkTriggerId = 700159,
	},
	[700160] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700160,
		TalkTriggerId = 700160,
	},
	[700161] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700161,
		TalkTriggerId = 700161,
	},
	[700162] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700162,
		TalkTriggerId = 700162,
	},
	[700163] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700163,
		TalkTriggerId = 700163,
	},
	[700164] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700164,
		TalkTriggerId = 700164,
	},
	[700165] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700165,
		TalkTriggerId = 700165,
	},
	[700166] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700166,
		TalkTriggerId = 700166,
	},
	[700167] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700167,
		TalkTriggerId = 700167,
	},
	[700168] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700168,
		TalkTriggerId = 700168,
	},
	[700169] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700169,
		TalkTriggerId = 700169,
	},
	[700170] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700170,
		TalkTriggerId = 700170,
	},
	[700171] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700171,
		TalkTriggerId = 700171,
	},
	[700172] = {
		StoryLinePath = "Observe/EX01.story",
		TalkId = 700172,
		TalkTriggerId = 700172,
	},
	[700173] = {
		StoryLinePath = "Observe/EX01.story",
		TalkId = 700173,
		TalkTriggerId = 700173,
	},
	[700174] = {
		StoryLinePath = "Observe/EX01.story",
		TalkId = 700174,
		TalkTriggerId = 700174,
	},
	[700175] = {
		StoryLinePath = "Observe/EX01.story",
		TalkId = 700175,
		TalkTriggerId = 700175,
	},
	[700176] = {
		StoryLinePath = "Observe/EX01.story",
		TalkId = 700176,
		TalkTriggerId = 700176,
	},
	[700177] = {
		StoryLinePath = "Observe/EX01.story",
		TalkId = 700177,
		TalkTriggerId = 700177,
	},
	[700178] = {
		StoryLinePath = "Observe/EX01.story",
		TalkId = 700178,
		TalkTriggerId = 700178,
	},
	[700179] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700179,
		TalkTriggerId = 700179,
	},
	[700180] = {
		StoryLinePath = "Observe/EX01.story",
		TalkId = 700180,
		TalkTriggerId = 700180,
	},
	[700181] = {
		StoryLinePath = "Observe/IceLake.story",
		TalkId = 700181,
		TalkTriggerId = 700181,
	},
	[700182] = {
		StoryLinePath = "Observe/IceLake.story",
		TalkId = 700182,
		TalkTriggerId = 700182,
	},
	[700183] = {
		StoryLinePath = "Observe/IceLake.story",
		TalkId = 700183,
		TalkTriggerId = 700183,
	},
	[700184] = {
		StoryLinePath = "Observe/East01_Sce.story",
		TalkId = 700184,
		TalkTriggerId = 700184,
	},
	[700185] = {
		StoryLinePath = "Observe/East01_Sce.story",
		TalkId = 700185,
		TalkTriggerId = 700185,
	},
	[700200] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700200,
		TalkTriggerId = 700200,
	},
	[700300] = {
		StoryLinePath = "Observe/IceLakeCity_2.story",
		TalkId = 700300,
		TalkTriggerId = 700300,
	},
	[710005] = {
		StoryLinePath = "DynStory/Talk.story",
		TalkId = 710005,
		TalkTriggerId = 710005,
	},
	[720000] = {
		StoryLinePath = "Explore/A_PanTalk_Prologue.story",
		TalkId = 710000,
		TalkTriggerId = 720000,
	},
	[720002] = {
		StoryLinePath = "Explore/A_PanTalk_Prologue.story",
		TalkId = 720002,
		TalkTriggerId = 720002,
	},
	[720003] = {
		StoryLinePath = "Explore/A_PanTalk_Prologue.story",
		TalkId = 720003,
		TalkTriggerId = 720003,
	},
	[720004] = {
		StoryLinePath = "Explore/A_PanTalk_Prologue.story",
		TalkId = 720004,
		TalkTriggerId = 720004,
	},
	[720005] = {
		StoryLinePath = "Explore/A_PanTalk_Prologue.story",
		TalkId = 720005,
		TalkTriggerId = 720005,
	},
	[720006] = {
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720006,
		TalkTriggerId = 720006,
	},
	[720007] = {
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720007,
		TalkTriggerId = 720007,
	},
	[720008] = {
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720008,
		TalkTriggerId = 720008,
	},
	[720009] = {
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720009,
		TalkTriggerId = 720009,
	},
	[720010] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720010,
		TalkTriggerId = 720010,
	},
	[720011] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720011,
		TalkTriggerId = 720011,
	},
	[720012] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720012,
		TalkTriggerId = 720012,
	},
	[720013] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720013,
		TalkTriggerId = 720013,
	},
	[720014] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720014,
		TalkTriggerId = 720014,
	},
	[720015] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720015,
		TalkTriggerId = 720015,
	},
	[720016] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720016,
		TalkTriggerId = 720016,
	},
	[720017] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720017,
		TalkTriggerId = 720017,
	},
	[720018] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720018,
		TalkTriggerId = 720018,
	},
	[720019] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720019,
		TalkTriggerId = 720019,
	},
	[720020] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720020,
		TalkTriggerId = 720020,
	},
	[720021] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720021,
		TalkTriggerId = 720021,
	},
	[720022] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720022,
		TalkTriggerId = 720022,
	},
	[720023] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720023,
		TalkTriggerId = 720023,
	},
	[720024] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720024,
		TalkTriggerId = 720024,
	},
	[720025] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720025,
		TalkTriggerId = 720025,
	},
	[720026] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720026,
		TalkTriggerId = 720026,
	},
	[720027] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720027,
		TalkTriggerId = 720027,
	},
	[720028] = {
		StoryLinePath = "Explore/A_PanTalk_Icelake.story",
		TalkId = 720028,
		TalkTriggerId = 720028,
	},
	[720029] = {
		StoryLinePath = "Explore/A_PanTalk_Sew.story",
		TalkId = 720029,
		TalkTriggerId = 720029,
	},
	[720030] = {
		StoryLinePath = "Explore/A_PanTalk_Sew.story",
		TalkId = 720030,
		TalkTriggerId = 720030,
	},
	[720031] = {
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720031,
		TalkTriggerId = 720031,
	},
	[720032] = {
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720032,
		TalkTriggerId = 720032,
	},
	[720033] = {
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720033,
		TalkTriggerId = 720033,
	},
	[720034] = {
		RewardId = 3011,
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720034,
		TalkTriggerId = 720034,
		Type = "Impression",
	},
	[720035] = {
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720035,
		TalkTriggerId = 720035,
	},
	[720036] = {
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720036,
		TalkTriggerId = 720036,
	},
	[720037] = {
		RewardId = 3011,
		StoryLinePath = "Explore/A_PanTalk_EX01.story",
		TalkId = 720037,
		TalkTriggerId = 720037,
		Type = "Impression",
	},
	[720038] = {
		StoryLinePath = "Explore/A_PanTalk_Prologue.story",
		TalkId = 720038,
		TalkTriggerId = 720038,
	},
	[720039] = {
		StoryLinePath = "Explore/A_PanTalk_Prologue.story",
		TalkId = 720039,
		TalkTriggerId = 720039,
	},
	[720040] = {
		StoryLinePath = "Explore/A_PanTalk_KuangKeng.story",
		TalkId = 720040,
		TalkTriggerId = 720040,
	},
	[720041] = {
		StoryLinePath = "Explore/A_PanTalk_KuangKeng.story",
		TalkId = 720041,
		TalkTriggerId = 720041,
	},
	[720042] = {
		StoryLinePath = "Explore/A_PanTalk_KuangKeng.story",
		TalkId = 720042,
		TalkTriggerId = 720042,
	},
	[720043] = {
		StoryLinePath = "Explore/A_PanTalk_Sew.story",
		TalkId = 720043,
		TalkTriggerId = 720043,
	},
	[720044] = {
		StoryLinePath = "Explore/A_PanTalk_Sew.story",
		TalkId = 720044,
		TalkTriggerId = 720044,
	},
	[720045] = {
		StoryLinePath = "Explore/A_PanTalk_Sew.story",
		TalkId = 720045,
		TalkTriggerId = 720045,
	},
	[720046] = {
		StoryLinePath = "Explore/A_PanTalk_Sew.story",
		TalkId = 720046,
		TalkTriggerId = 720046,
	},
	[721001] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721001,
		TalkTriggerId = 721001,
	},
	[721002] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721002,
		TalkTriggerId = 721002,
	},
	[721003] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721003,
		TalkTriggerId = 721003,
	},
	[721004] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721004,
		TalkTriggerId = 721004,
	},
	[721005] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721005,
		TalkTriggerId = 721005,
	},
	[721006] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721006,
		TalkTriggerId = 721006,
	},
	[721007] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721007,
		TalkTriggerId = 721007,
	},
	[721008] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721008,
		TalkTriggerId = 721008,
	},
	[721009] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721009,
		TalkTriggerId = 721009,
	},
	[721010] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721010,
		TalkTriggerId = 721010,
	},
	[721011] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721011,
		TalkTriggerId = 721011,
	},
	[721012] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 721012,
		TalkTriggerId = 721012,
	},
	[721013] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721013,
		TalkTriggerId = 721013,
	},
	[721014] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721014,
		TalkTriggerId = 721014,
	},
	[721015] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721015,
		TalkTriggerId = 721015,
	},
	[721016] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721016,
		TalkTriggerId = 721016,
	},
	[721017] = {
		StoryLinePath = "Explore/A_WuyouTalk_Yanjindu.story",
		TalkId = 721017,
		TalkTriggerId = 721017,
	},
	[722001] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722001,
		TalkTriggerId = 722001,
	},
	[722002] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722002,
		TalkTriggerId = 722002,
	},
	[722003] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722003,
		TalkTriggerId = 722003,
	},
	[722004] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722004,
		TalkTriggerId = 722004,
	},
	[722005] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722005,
		TalkTriggerId = 722005,
	},
	[722006] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722006,
		TalkTriggerId = 722006,
	},
	[722007] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722007,
		TalkTriggerId = 722007,
	},
	[722008] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722008,
		TalkTriggerId = 722008,
	},
	[722009] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722009,
		TalkTriggerId = 722009,
	},
	[722010] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722010,
		TalkTriggerId = 722010,
	},
	[722011] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722011,
		TalkTriggerId = 722011,
	},
	[722012] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722012,
		TalkTriggerId = 722012,
	},
	[722013] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722013,
		TalkTriggerId = 722013,
	},
	[722014] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722014,
		TalkTriggerId = 722014,
	},
	[722015] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722015,
		TalkTriggerId = 722015,
	},
	[722016] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722016,
		TalkTriggerId = 722016,
	},
	[722017] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722017,
		TalkTriggerId = 722017,
	},
	[722018] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722018,
		TalkTriggerId = 722018,
	},
	[722019] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722019,
		TalkTriggerId = 722019,
	},
	[722020] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722020,
		TalkTriggerId = 722020,
	},
	[722021] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722021,
		TalkTriggerId = 722021,
	},
	[722022] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722022,
		TalkTriggerId = 722022,
	},
	[722023] = {
		StoryLinePath = "Explore/A_WuyouTalk_Haojing.story",
		TalkId = 722023,
		TalkTriggerId = 722023,
	},
	[730006] = {
		DialogueId = 73000601,
		TalkTriggerId = 730006,
		TalkType = "Guide",
	},
	[730007] = {
		DialogueId = 73000701,
		TalkTriggerId = 730007,
		TalkType = "Guide",
	},
	[730008] = {
		DialogueId = 73000801,
		TalkTriggerId = 730008,
		TalkType = "Guide",
	},
	[730009] = {
		DialogueId = 73000901,
		TalkTriggerId = 730009,
		TalkType = "Guide",
	},
	[730010] = {
		DialogueId = 73001001,
		TalkTriggerId = 730010,
		TalkType = "Guide",
	},
	[830001] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830001,
		TalkTriggerId = 830001,
	},
	[830002] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830002,
		TalkTriggerId = 830002,
	},
	[830003] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830003,
		TalkTriggerId = 830003,
	},
	[830004] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830004,
		TalkTriggerId = 830004,
	},
	[830005] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830005,
		TalkTriggerId = 830005,
	},
	[830006] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830006,
		TalkTriggerId = 830006,
	},
	[830007] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830007,
		TalkTriggerId = 830007,
	},
	[830008] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830008,
		TalkTriggerId = 830008,
	},
	[830009] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830009,
		TalkTriggerId = 830009,
	},
	[830010] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830010,
		TalkTriggerId = 830010,
	},
	[830011] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830011,
		TalkTriggerId = 830011,
	},
	[830012] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830012,
		TalkTriggerId = 830012,
	},
	[830013] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830013,
		TalkTriggerId = 830013,
	},
	[830014] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830014,
		TalkTriggerId = 830014,
	},
	[830015] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830015,
		TalkTriggerId = 830015,
	},
	[830016] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830016,
		TalkTriggerId = 830016,
	},
	[830017] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830017,
		TalkTriggerId = 830017,
	},
	[830018] = {
		StoryLinePath = "Explore/ExploreGroup.story",
		TalkId = 830018,
		TalkTriggerId = 830018,
	},
	[900101] = {
		StoryLinePath = "TalkGossip/900101_Duanzao_Bubble.story",
		TalkId = 900101,
		TalkTriggerId = 900101,
	},
	[900102] = {
		StoryLinePath = "TalkGossip/900102_Duanzao.story",
		TalkId = 900102,
		TalkTriggerId = 900102,
	},
	[900201] = {
		StoryLinePath = "TalkGossip/900201_Shangdian_Bubble.story",
		TalkId = 900201,
		TalkTriggerId = 900201,
	},
	[900202] = {
		StoryLinePath = "TalkGossip/900202_Shangdian.story",
		TalkId = 900202,
		TalkTriggerId = 900202,
	},
	[900301] = {
		StoryLinePath = "TalkGossip/900301_Heitao.story",
		TalkId = 900301,
		TalkTriggerId = 900301,
	},
	[900401] = {
		StoryLinePath = "TalkGossip/900401_Shuimu.story",
		TalkId = 900401,
		TalkTriggerId = 900401,
	},
	[900501] = {
		StoryLinePath = "TalkGossip/900501_Zhangyu.story",
		TalkId = 900501,
		TalkTriggerId = 900501,
	},
	[900601] = {
		StoryLinePath = "TalkGossip/900601_Haier.story",
		TalkId = 900601,
		TalkTriggerId = 900601,
	},
	[900701] = {
		StoryLinePath = "TalkGossip/900701_Yuming.story",
		TalkId = 900701,
		TalkTriggerId = 900701,
	},
	[900801] = {
		StoryLinePath = "TalkGossip/900801_Landi.story",
		TalkId = 900801,
		TalkTriggerId = 900801,
	},
	[900901] = {
		StoryLinePath = "TalkGossip/900901_Xibi.story",
		TalkId = 900901,
		TalkTriggerId = 900901,
	},
	[901001] = {
		StoryLinePath = "TalkGossip/901001_Saiqi.story",
		TalkId = 901001,
		TalkTriggerId = 901001,
	},
	[901101] = {
		StoryLinePath = "TalkGossip/901101_Baiheng.story",
		TalkId = 901101,
		TalkTriggerId = 901101,
	},
	[901201] = {
		StoryLinePath = "TalkGossip/901201_Songlu.story",
		TalkId = 901201,
		TalkTriggerId = 901201,
	},
	[901301] = {
		StoryLinePath = "TalkGossip/901301_Linen.story",
		TalkId = 901301,
		TalkTriggerId = 901301,
	},
	[901401] = {
		TalkTriggerId = 901401,
		TriggerCondition = T.RT_60,
	},
	[901501] = {
		StoryLinePath = "TalkGossip/901501_Feina.story",
		TalkId = 901501,
		TalkTriggerId = 901501,
	},
	[901601] = {
		StoryLinePath = "TalkGossip/901601_Aote.story",
		TalkId = 901601,
		TalkTriggerId = 901601,
	},
	[901701] = {
		StoryLinePath = "TalkGossip/901701_Maer.story",
		TalkId = 901701,
		TalkTriggerId = 901701,
	},
	[901801] = {
		StoryLinePath = "TalkGossip/901801_Yeer.story",
		TalkId = 901801,
		TalkTriggerId = 901801,
	},
	[901901] = {
		StoryLinePath = "TalkGossip/901901_James.story",
		TalkId = 901901,
		TalkTriggerId = 901901,
	},
	[902001] = {
		StoryLinePath = "TalkGossip/902001_Jack.story",
		TalkId = 902001,
		TalkTriggerId = 902001,
	},
	[902101] = {
		StoryLinePath = "TalkGossip/902101_Emily.story",
		TalkId = 902101,
		TalkTriggerId = 902101,
	},
	[902501] = {
		StoryLinePath = "TalkGossip/902501_Nifu.story",
		TalkId = 902501,
		TalkTriggerId = 902501,
	},
	[902601] = {
		StoryLinePath = "TalkGossip/902601_Zhiliu.story",
		TalkId = 902601,
		TalkTriggerId = 902601,
	},
	[902701] = {
		StoryLinePath = "TalkGossip/902701_Kezhou.story",
		TalkId = 902701,
		TalkTriggerId = 902701,
	},
	[902901] = {
		StoryLinePath = "TalkGossip/902901_Baonu.story",
		TalkId = 902901,
		TalkTriggerId = 902901,
	},
	[903001] = {
		StoryLinePath = "TalkGossip/903001_Suyi.story",
		TalkId = 903001,
		TalkTriggerId = 903001,
	},
	[903101] = {
		StoryLinePath = "TalkGossip/903101_Kami.story",
		TalkId = 903101,
		TalkTriggerId = 903101,
	},
	[910101] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/HeitaoIdleBubble.story",
		TalkId = 910101,
		TalkTriggerId = 910101,
	},
	[910102] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/ShuimuIdleBubble.story",
		TalkId = 910102,
		TalkTriggerId = 910102,
	},
	[910103] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/ZhangyuIdleBubble.story",
		TalkId = 910103,
		TalkTriggerId = 910103,
	},
	[910104] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/HaierIdleBubble.story",
		TalkId = 910104,
		TalkTriggerId = 910104,
	},
	[910105] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/YumingIdleBubble.story",
		TalkId = 910105,
		TalkTriggerId = 910105,
	},
	[910106] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/LandiIdleBubble.story",
		TalkId = 910106,
		TalkTriggerId = 910106,
	},
	[910107] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/XibiIdleBubble.story",
		TalkId = 910107,
		TalkTriggerId = 910107,
	},
	[910108] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/SaiqiIdleBubble.story",
		TalkId = 910108,
		TalkTriggerId = 910108,
	},
	[910109] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/FushuIdleBubble.story",
		TalkId = 910109,
		TalkTriggerId = 910109,
	},
	[910110] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/SongluIdleBubble.story",
		TalkId = 910110,
		TalkTriggerId = 910110,
	},
	[910111] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/LinenIdleBubble.story",
		TalkId = 910111,
		TalkTriggerId = 910111,
	},
	[910112] = {
		TalkTriggerId = 910112,
		TriggerCondition = T.RT_60,
	},
	[910113] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/FeinaIdleBubble.story",
		TalkId = 910113,
		TalkTriggerId = 910113,
	},
	[910114] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/AoteIdleBubble.story",
		TalkId = 910114,
		TalkTriggerId = 910114,
	},
	[910115] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/MaerIdleBubble.story",
		TalkId = 910115,
		TalkTriggerId = 910115,
	},
	[910116] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/YeerIdleBubble.story",
		TalkId = 910116,
		TalkTriggerId = 910116,
	},
	[910117] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/DafuIdleBubble.story",
		TalkId = 910117,
		TalkTriggerId = 910117,
	},
	[910118] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/TuosiIdleBubble.story",
		TalkId = 910118,
		TalkTriggerId = 910118,
	},
	[910119] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/LiseIdleBubble.story",
		TalkId = 910119,
		TalkTriggerId = 910119,
	},
	[910120] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/NifuIdleBubble.story",
		TalkId = 910120,
		TalkTriggerId = 910120,
	},
	[910121] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/ZhiliuIdleBubble.story",
		TalkId = 910121,
		TalkTriggerId = 910121,
	},
	[910122] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/KezhouIdleBubble.story",
		TalkId = 910122,
		TalkTriggerId = 910122,
	},
	[910123] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/BaonuIdleBubble.story",
		TalkId = 910123,
		TalkTriggerId = 910123,
	},
	[910124] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/SuyiIdleBubble.story",
		TalkId = 910124,
		TalkTriggerId = 910124,
	},
	[910125] = {
		StoryLinePath = "TalkGossip/LongIdleBubble/KamiIdleBubble.story",
		TalkId = 910125,
		TalkTriggerId = 910125,
	},
	[920101] = {
		TalkTriggerId = 920101,
		TriggerCondition = T.RT_60,
	},
	[920102] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/HeitaoSonglu.story",
		TalkId = 920102,
		TalkTriggerId = 920102,
	},
	[920103] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/HeitaoXibi.story",
		TalkId = 920103,
		TalkTriggerId = 920103,
	},
	[920104] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/HeitaoAote.story",
		TalkId = 920104,
		TalkTriggerId = 920104,
	},
	[920105] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/ShuimuHaier.story",
		TalkId = 920105,
		TalkTriggerId = 920105,
	},
	[920106] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/ShuimuZhangyu.story",
		TalkId = 920106,
		TalkTriggerId = 920106,
	},
	[920107] = {
		TalkTriggerId = 920107,
		TriggerCondition = T.RT_60,
	},
	[920108] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/ZhangyuHaier.story",
		TalkId = 920108,
		TalkTriggerId = 920108,
	},
	[920109] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/ZhangyuShuimu.story",
		TalkId = 920109,
		TalkTriggerId = 920109,
	},
	[920110] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/ZhangyuBaonu.story",
		TalkId = 920110,
		TalkTriggerId = 920110,
	},
	[920111] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/HaierXibi.story",
		TalkId = 920111,
		TalkTriggerId = 920111,
	},
	[920112] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/HaierShuimu.story",
		TalkId = 920112,
		TalkTriggerId = 920112,
	},
	[920113] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/HaierLandi.story",
		TalkId = 920113,
		TalkTriggerId = 920113,
	},
	[920114] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/YumingAote.story",
		TalkId = 920114,
		TalkTriggerId = 920114,
	},
	[920115] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/YumingKezhou.story",
		TalkId = 920115,
		TalkTriggerId = 920115,
	},
	[920116] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/YumingHaier.story",
		TalkId = 920116,
		TalkTriggerId = 920116,
	},
	[920117] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/LandiXibi.story",
		TalkId = 920117,
		TalkTriggerId = 920117,
	},
	[920118] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/LandiLinen.story",
		TalkId = 920118,
		TalkTriggerId = 920118,
	},
	[920119] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/LandiHeitao.story",
		TalkId = 920119,
		TalkTriggerId = 920119,
	},
	[920120] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/XibiDafu.story",
		TalkId = 920120,
		TalkTriggerId = 920120,
	},
	[920121] = {
		TalkTriggerId = 920121,
		TriggerCondition = T.RT_60,
	},
	[920122] = {
		TalkTriggerId = 920122,
		TriggerCondition = T.RT_60,
	},
	[920123] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/XibiAote.story",
		TalkId = 920123,
		TalkTriggerId = 920123,
	},
	[920124] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/XibiLandi.story",
		TalkId = 920124,
		TalkTriggerId = 920124,
	},
	[920125] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/SaiqiAote.story",
		TalkId = 920125,
		TalkTriggerId = 920125,
	},
	[920126] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/SaiqiKami.story",
		TalkId = 920126,
		TalkTriggerId = 920126,
	},
	[920127] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/SaiqiSonglu.story",
		TalkId = 920127,
		TalkTriggerId = 920127,
	},
	[920128] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/FushuLandi.story",
		TalkId = 920128,
		TalkTriggerId = 920128,
	},
	[920129] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/FushuZhiliu.story",
		TalkId = 920129,
		TalkTriggerId = 920129,
	},
	[920130] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/FushuYeer.story",
		TalkId = 920130,
		TalkTriggerId = 920130,
	},
	[920131] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/SongluMaer.story",
		TalkId = 920131,
		TalkTriggerId = 920131,
	},
	[920132] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/SongluLinen.story",
		TalkId = 920132,
		TalkTriggerId = 920132,
	},
	[920133] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/SongluBaonu.story",
		TalkId = 920133,
		TalkTriggerId = 920133,
	},
	[920134] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/LinenLandi.story",
		TalkId = 920134,
		TalkTriggerId = 920134,
	},
	[920135] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/LinenXibi.story",
		TalkId = 920135,
		TalkTriggerId = 920135,
	},
	[920136] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/LinenLise.story",
		TalkId = 920136,
		TalkTriggerId = 920136,
	},
	[920137] = {
		TalkTriggerId = 920137,
		TriggerCondition = T.RT_60,
	},
	[920138] = {
		TalkTriggerId = 920138,
		TriggerCondition = T.RT_60,
	},
	[920139] = {
		TalkTriggerId = 920139,
		TriggerCondition = T.RT_60,
	},
	[920140] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/FeinaAote.story",
		TalkId = 920140,
		TalkTriggerId = 920140,
	},
	[920141] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/FeinaSonglu.story",
		TalkId = 920141,
		TalkTriggerId = 920141,
	},
	[920142] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/FeinaBaonu.story",
		TalkId = 920142,
		TalkTriggerId = 920142,
	},
	[920143] = {
		TalkTriggerId = 920143,
		TriggerCondition = T.RT_60,
	},
	[920144] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/AoteFeina.story",
		TalkId = 920144,
		TalkTriggerId = 920144,
	},
	[920145] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/AoteSaiqi.story",
		TalkId = 920145,
		TalkTriggerId = 920145,
	},
	[920146] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/AoteKami.story",
		TalkId = 920146,
		TalkTriggerId = 920146,
	},
	[920147] = {
		TalkTriggerId = 920147,
		TriggerCondition = T.RT_60,
	},
	[920148] = {
		TalkTriggerId = 920148,
		TriggerCondition = T.RT_60,
	},
	[920149] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/MaerFeina.story",
		TalkId = 920149,
		TalkTriggerId = 920149,
	},
	[920150] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/MaerHaier.story",
		TalkId = 920150,
		TalkTriggerId = 920150,
	},
	[920151] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/MaerLinen.story",
		TalkId = 920151,
		TalkTriggerId = 920151,
	},
	[920152] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/MaerKami.story",
		TalkId = 920152,
		TalkTriggerId = 920152,
	},
	[920153] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/YeerTuosi.story",
		TalkId = 920153,
		TalkTriggerId = 920153,
	},
	[920154] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/YeerSonglu.story",
		TalkId = 920154,
		TalkTriggerId = 920154,
	},
	[920155] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/YeerHaier.story",
		TalkId = 920155,
		TalkTriggerId = 920155,
	},
	[920156] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/DafuFushu.story",
		TalkId = 920156,
		TalkTriggerId = 920156,
	},
	[920157] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/DafuHaier.story",
		TalkId = 920157,
		TalkTriggerId = 920157,
	},
	[920158] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/DafuXibi.story",
		TalkId = 920158,
		TalkTriggerId = 920158,
	},
	[920159] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/DafuTuosi.story",
		TalkId = 920159,
		TalkTriggerId = 920159,
	},
	[920160] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/TuosiLise.story",
		TalkId = 920160,
		TalkTriggerId = 920160,
	},
	[920161] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/TuosiFeina.story",
		TalkId = 920161,
		TalkTriggerId = 920161,
	},
	[920162] = {
		TalkTriggerId = 920162,
		TriggerCondition = T.RT_60,
	},
	[920163] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/TuosiZhangyu.story",
		TalkId = 920163,
		TalkTriggerId = 920163,
	},
	[920164] = {
		TalkTriggerId = 920164,
		TriggerCondition = T.RT_60,
	},
	[920165] = {
		TalkTriggerId = 920165,
		TriggerCondition = T.RT_60,
	},
	[920166] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/LiseLandi.story",
		TalkId = 920166,
		TalkTriggerId = 920166,
	},
	[920167] = {
		TalkTriggerId = 920167,
		TriggerCondition = T.RT_60,
	},
	[920168] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/NifuAote.story",
		TalkId = 920168,
		TalkTriggerId = 920168,
	},
	[920169] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/NifuFushu.story",
		TalkId = 920169,
		TalkTriggerId = 920169,
	},
	[920170] = {
		TalkTriggerId = 920170,
		TriggerCondition = T.RT_60,
	},
	[920171] = {
		TalkTriggerId = 920171,
		TriggerCondition = T.RT_60,
	},
	[920172] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/ZhiliuShuimu.story",
		TalkId = 920172,
		TalkTriggerId = 920172,
	},
	[920173] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/ZhiliuKezhou.story",
		TalkId = 920173,
		TalkTriggerId = 920173,
	},
	[920174] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/ZhiliuKami.story",
		TalkId = 920174,
		TalkTriggerId = 920174,
	},
	[920175] = {
		TalkTriggerId = 920175,
		TriggerCondition = T.RT_60,
	},
	[920176] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/KezhouYuming.story",
		TalkId = 920176,
		TalkTriggerId = 920176,
	},
	[920177] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/KezhouBaonu.story",
		TalkId = 920177,
		TalkTriggerId = 920177,
	},
	[920178] = {
		TalkTriggerId = 920178,
		TriggerCondition = T.RT_60,
	},
	[920179] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/BaonuZhangyu.story",
		TalkId = 920179,
		TalkTriggerId = 920179,
	},
	[920180] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/BaonuLinen.story",
		TalkId = 920180,
		TalkTriggerId = 920180,
	},
	[920181] = {
		TalkTriggerId = 920181,
		TriggerCondition = T.RT_60,
	},
	[920182] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/SuyiShuimu.story",
		TalkId = 920182,
		TalkTriggerId = 920182,
	},
	[920183] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/SuyiKezhou.story",
		TalkId = 920183,
		TalkTriggerId = 920183,
	},
	[920184] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/SuyiSaiqi.story",
		TalkId = 920184,
		TalkTriggerId = 920184,
	},
	[920185] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/KamiSaiqi.story",
		TalkId = 920185,
		TalkTriggerId = 920185,
	},
	[920186] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/KamiZhiliu.story",
		TalkId = 920186,
		TalkTriggerId = 920186,
	},
	[920187] = {
		StoryLinePath = "TalkGossip/EasterEggBubble/KamiAote.story",
		TalkId = 920187,
		TalkTriggerId = 920187,
	},
	[5010713] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\501071_Bubble.story",
		TalkId = 5010713,
		TalkTriggerId = 5010713,
	},
	[5100032] = {
		StoryLinePath = "Impression/IceLakeCity/510003_XilinFuren_1_EndTalk.story",
		TalkId = 5100032,
		TalkTriggerId = 5100032,
		TriggerCondition = T.RT_34,
	},
	[5100042] = {
		StoryLinePath = "Impression/IceLakeCity/510004_Aiersha_EndTalk.story",
		TalkId = 5100042,
		TalkTriggerId = 5100042,
		TriggerCondition = {
			And = {
				{
					QuestFinish = {
						QuestId = 20020300,
					},
				},
				{
					QuestChainUnFinish = {
						QuestChainId = 200203,
					},
				},
			},
		},
	},
	[5100043] = {
		StoryLinePath = "Impression/IceLakeCity/510004_Aiersha_EndTalk2.story",
		TalkId = 5100043,
		TalkTriggerId = 5100043,
		TriggerCondition = T.RT_36,
	},
	[5100072] = {
		StoryLinePath = "Impression/IceLakeCity/510007_Alice_EndTalk.story",
		TalkId = 5100072,
		TalkTriggerId = 5100072,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510007,
			},
		},
	},
	[5100082] = {
		StoryLinePath = "Impression/IceLakeCity/510008_Alice_EndTalk_1.story",
		TalkId = 5100082,
		TalkTriggerId = 5100082,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020310,
			},
		},
	},
	[5100083] = {
		StoryLinePath = "Impression/IceLakeCity/510008_Alice_EndTalk_2.story",
		TalkId = 5100083,
		TalkTriggerId = 5100083,
		TriggerCondition = T.RT_36,
	},
	[5100092] = {
		TalkId = 5100092,
		TalkTriggerId = 5100092,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510009,
			},
		},
	},
	[5100102] = {
		StoryLinePath = "Impression/IceLakeCity/510010_Jiexika_EndTalk.story",
		TalkId = 5100102,
		TalkTriggerId = 5100102,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510010,
			},
		},
	},
	[5100122] = {
		StoryLinePath = "Impression/IceLakeCity/510012_Kenong_EndTalk.story",
		TalkId = 5100122,
		TalkTriggerId = 5100122,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510012,
			},
		},
	},
	[5100142] = {
		StoryLinePath = "Impression/IceLakeCity/510014_Sangni_EndTalk.story",
		TalkId = 5100142,
		TalkTriggerId = 5100142,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510014,
			},
		},
	},
	[5100152] = {
		TalkId = 5100152,
		TalkTriggerId = 5100152,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510015,
			},
		},
	},
	[5100162] = {
		StoryLinePath = "Impression/IceLakeCity/510016_Yagebu_EndTalk.story",
		TalkId = 5100162,
		TalkTriggerId = 5100162,
		TriggerCondition = {
			ImprComp = T.RT_27,
		},
	},
	[5100172] = {
		StoryLinePath = "Impression/IceLakeCity/510017_Dadun_EndTalk.story",
		TalkId = 5100172,
		TalkTriggerId = 5100172,
	},
	[5100192] = {
		StoryLinePath = "Impression/IceLakeCity/510019_Wells_End.story",
		TalkId = 5100183,
		TalkTriggerId = 5100192,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020405,
			},
		},
	},
	[5100202] = {
		StoryLinePath = "Impression/IceLakeCity/510020_Blue_1_End.story",
		TalkId = 5100193,
		TalkTriggerId = 5100202,
		TriggerCondition = {
			And = {
				{
					ImprUncomp = T.RT_30,
				},
				{
					QuestChainStart = T.RT_37,
				},
			},
		},
	},
	[5100222] = {
		StoryLinePath = "Impression/IceLakeCity/510022_Blue_2_End.story",
		TalkId = 5100194,
		TalkTriggerId = 5100222,
		TriggerCondition = {
			QuestChainFinish = T.RT_37,
		},
	},
	[5100232] = {
		StoryLinePath = "Impression/IceLakeCity/510023_Shali_EndTalk.story",
		TalkId = 5100232,
		TalkTriggerId = 5100232,
		TriggerCondition = T.RT_34,
	},
	[5100341] = {
		StoryLinePath = "Impression/IceLakeCity/510034_Anuo_EndTalk.story",
		TalkId = 5100341,
		TalkTriggerId = 5100341,
		TriggerCondition = T.RT_39,
	},
	[5100342] = {
		StoryLinePath = "Impression/IceLakeCity/510034_Bake_EndTalk.story",
		TalkId = 5100342,
		TalkTriggerId = 5100342,
		TriggerCondition = T.RT_39,
	},
	[5100371] = {
		StoryLinePath = "Impression/IceLakeCity/510037_Aima_EndTalk.story",
		TalkId = 5100371,
		TalkTriggerId = 5100371,
		TriggerCondition = T.RT_41,
	},
	[5100372] = {
		StoryLinePath = "Impression/IceLakeCity/510037_Beilinda_EndTalk.story",
		TalkId = 5100372,
		TalkTriggerId = 5100372,
		TriggerCondition = T.RT_41,
	},
	[5100411] = {
		StoryLinePath = "Impression/IceLakeCity/510041_Faye_EndTalk.story",
		TalkId = 5100411,
		TalkTriggerId = 5100411,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20021105,
			},
		},
	},
	[5100421] = {
		StoryLinePath = "Impression/IceLakeCity/510042_Heerluo_EndTalk.story",
		TalkId = 5100421,
		TalkTriggerId = 5100421,
		TriggerCondition = T.RT_32,
	},
	[5100491] = {
		StoryLinePath = "Impression/IceLakeCity/510049_Luna_EndTalk.story",
		TalkId = 5100491,
		TalkTriggerId = 5100491,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020901,
			},
		},
	},
	[5100501] = {
		StoryLinePath = "Impression/IceLakeCity/510050_Laina_EndTalk.story",
		TalkId = 5100501,
		TalkTriggerId = 5100501,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20020803,
			},
		},
	},
	[5100511] = {
		StoryLinePath = "Impression/IceLakeCity/510051_Maer_EndTalk.story",
		TalkId = 5100511,
		TalkTriggerId = 5100511,
		TriggerCondition = T.RT_43,
	},
	[5100521] = {
		StoryLinePath = "Impression/IceLakeCity/510052_Maer_EndTalk.story",
		TalkId = 5100521,
		TalkTriggerId = 5100521,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 200213,
			},
		},
	},
	[5100531] = {
		StoryLinePath = "Impression/IceLakeCity/510053_Makusi_EndTalk.story",
		TalkId = 5100531,
		TalkTriggerId = 5100531,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20021500,
			},
		},
	},
	[5100551] = {
		StoryLinePath = "Impression/IceLakeCity/510055_Makusi_EndTalk.story",
		TalkId = 5100551,
		TalkTriggerId = 5100551,
		TriggerCondition = {
			QuestFinish = {
				QuestId = 20021504,
			},
		},
	},
	[5100591] = {
		StoryLinePath = "Impression/IceLakeCity/510059_Sanxiongdi_EndTalk.story",
		TalkId = 510059,
		TalkTriggerId = 5100591,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 200216,
			},
		},
	},
	[5100671] = {
		StoryLinePath = "Impression/IceLakeCity/510067_Waiter_EndTalk.story",
		TalkId = 5100671,
		TalkTriggerId = 5100671,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 200220,
			},
		},
	},
	[5100681] = {
		StoryLinePath = "Impression/IceLakeCity/510068_Nifu_EndTalk.story",
		TalkId = 5100681,
		TalkTriggerId = 5100681,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 200218,
			},
		},
	},
	[5100711] = {
		StoryLinePath = "Impression/IceLakeCity/510071_Jiexi_EndTalk.story",
		TalkId = 5100711,
		TalkTriggerId = 5100711,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 200219,
			},
		},
	},
	[5101022] = {
		StoryLinePath = "Impression/IceLakeCity/510102_Liliko_1_EndTalk.story",
		TalkId = 5101022,
		TalkTriggerId = 5101022,
		TriggerCondition = {
			And = {
				T.RT_45,
				{
					QuestChainUnFinish = T.RT_28,
				},
			},
		},
	},
	[5101023] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/510102.story",
		TalkId = 5101023,
		TalkTriggerId = 5101023,
		TriggerCondition = {
			ImprUncomp = T.RT_44,
		},
	},
	[5101032] = {
		StoryLinePath = "Impression/IceLakeCity/510103_Liliko_2_EndTalk.story",
		TalkId = 5101032,
		TalkTriggerId = 5101032,
		TriggerCondition = {
			And = {
				T.RT_47,
				{
					QuestChainUnFinish = T.RT_48,
				},
			},
		},
	},
	[5101033] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/510103.story",
		TalkId = 5101033,
		TalkTriggerId = 5101033,
		TriggerCondition = {
			And = {
				T.RT_45,
				T.RT_29,
				{
					ImprUncomp = T.RT_46,
				},
			},
		},
	},
	[5101042] = {
		StoryLinePath = "Impression/IceLakeCity/510104_Liliko_3_EndTalk.story",
		TalkId = 5101042,
		TalkTriggerId = 5101042,
		TriggerCondition = T.RT_51,
	},
	[5101043] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/510104.story",
		TalkId = 5101043,
		TalkTriggerId = 5101043,
		TriggerCondition = {
			And = {
				T.RT_47,
				T.RT_49,
				{
					ImprUncomp = T.RT_50,
				},
			},
		},
	},
	[5101044] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/5101044.story",
		TalkId = 5101044,
		TalkTriggerId = 5101044,
		TriggerCondition = T.RT_51,
	},
	[5101052] = {
		StoryLinePath = "Impression/IceLakeCity/510105_Kaiwen_EndTalk.story",
		TalkId = 5101052,
		TalkTriggerId = 5101052,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510105,
			},
		},
	},
	[5101062] = {
		StoryLinePath = "Impression/IceLakeCity/510106_Jimu_EndTalk.story",
		TalkId = 5101062,
		TalkTriggerId = 5101062,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510106,
			},
		},
	},
	[5101072] = {
		StoryLinePath = "Impression/IceLakeCity/510107_Beiguanjiaojiao_EndTalk.story",
		TalkId = 5101072,
		TalkTriggerId = 5101072,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510107,
			},
		},
	},
	[5101082] = {
		StoryLinePath = "Impression/IceLakeCity/510108_Daixi_EndTalk.story",
		TalkId = 5101082,
		TalkTriggerId = 5101082,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510108,
			},
		},
	},
	[5101092] = {
		StoryLinePath = "Impression/IceLakeCity/510109_Walun_EndTalk.story",
		TalkId = 5101092,
		TalkTriggerId = 5101092,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510109,
			},
		},
	},
	[5101102] = {
		StoryLinePath = "Impression/IceLakeCity/510110_Halan_EndTalk.story",
		TalkId = 5101102,
		TalkTriggerId = 5101102,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510110,
			},
		},
	},
	[5112552] = {
		StoryLinePath = "Impression/East01/Gossip/511255_EndTalk.story",
		TalkId = 5112552,
		TalkTriggerId = 5112552,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511255,
			},
		},
	},
	[5112562] = {
		StoryLinePath = "Impression/East01/Gossip/511256_EndTalk.story",
		TalkId = 5112562,
		TalkTriggerId = 5112562,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511256,
			},
		},
	},
	[5112572] = {
		StoryLinePath = "Impression/East01/Gossip/511257_EndTalk.story",
		TalkId = 5112572,
		TalkTriggerId = 5112572,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511257,
			},
		},
	},
	[5112582] = {
		StoryLinePath = "Impression/East01/Gossip/511258_EndTalk.story",
		TalkId = 5112582,
		TalkTriggerId = 5112582,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511258,
			},
		},
	},
	[5112602] = {
		StoryLinePath = "Impression/East01/Gossip/511260_EndTalk.story",
		TalkId = 5112602,
		TalkTriggerId = 5112602,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511260,
			},
		},
	},
	[5112612] = {
		StoryLinePath = "Impression/East01/Gossip/511261_EndTalk.story",
		TalkId = 5112612,
		TalkTriggerId = 5112612,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511261,
			},
		},
	},
	[5112642] = {
		StoryLinePath = "Impression/East01/Gossip/511264_EndTalk.story",
		TalkId = 5112642,
		TalkTriggerId = 5112642,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511264,
			},
		},
	},
	[5112692] = {
		StoryLinePath = "Impression/East01/Gossip/511269_EndTalk.story",
		TalkId = 5112692,
		TalkTriggerId = 5112692,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511269,
			},
		},
	},
	[5112702] = {
		StoryLinePath = "Impression/East01/Gossip/511270_EndTalk.story",
		TalkId = 5112702,
		TalkTriggerId = 5112702,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511270,
			},
		},
	},
	[5112712] = {
		StoryLinePath = "Impression/East01/Gossip/511271_EndTalk.story",
		TalkId = 5112712,
		TalkTriggerId = 5112712,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511271,
			},
		},
	},
	[5112732] = {
		StoryLinePath = "Impression/East01/Gossip/511273_EndTalk.story",
		TalkId = 5112732,
		TalkTriggerId = 5112732,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511273,
			},
		},
	},
	[5112752] = {
		StoryLinePath = "Impression/East01/Gossip/511275_EndTalk.story",
		TalkId = 5112752,
		TalkTriggerId = 5112752,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511275,
			},
		},
	},
	[5112762] = {
		StoryLinePath = "Impression/East01/Gossip/511276_EndTalk.story",
		TalkId = 5112762,
		TalkTriggerId = 5112762,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511276,
			},
		},
	},
	[5112802] = {
		StoryLinePath = "Impression/East01/Gossip/511280_EndTalk.story",
		TalkId = 5112802,
		TalkTriggerId = 5112802,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511280,
			},
		},
	},
	[5112822] = {
		StoryLinePath = "Impression/East01/Gossip/511282_EndTalk.story",
		TalkId = 5112822,
		TalkTriggerId = 5112822,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511282,
			},
		},
	},
	[5115602] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511560_EndTalk.story",
		TalkId = 5115602,
		TalkTriggerId = 5115602,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511560,
			},
		},
	},
	[5115603] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511560_Bubble.story",
		TalkId = 5115603,
		TalkTriggerId = 5115603,
	},
	[5115613] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511561_Bubble.story",
		TalkId = 5115613,
		TalkTriggerId = 5115613,
	},
	[5115622] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511562_EndTalk.story",
		TalkId = 5115622,
		TalkTriggerId = 5115622,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511562,
			},
		},
	},
	[5115623] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511562_Bubble.story",
		TalkId = 5115623,
		TalkTriggerId = 5115623,
	},
	[5115633] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511563_Bubble.story",
		TalkId = 5115633,
		TalkTriggerId = 5115633,
	},
	[5115653] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511565_Bubble.story",
		TalkId = 5115653,
		TalkTriggerId = 5115653,
	},
	[5115663] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511566_Bubble.story",
		TalkId = 5115663,
		TalkTriggerId = 5115663,
	},
	[5115673] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511567_Bubble.story",
		TalkId = 5115673,
		TalkTriggerId = 5115673,
	},
	[5115683] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511568_Bubble.story",
		TalkId = 5115683,
		TalkTriggerId = 5115683,
	},
	[5115692] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511569_EndTalk.story",
		TalkId = 5115692,
		TalkTriggerId = 5115692,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511569,
			},
		},
	},
	[5115693] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511569_Bubble.story",
		TalkId = 5115693,
		TalkTriggerId = 5115693,
	},
	[5115703] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511570_Bubble.story",
		TalkId = 5115703,
		TalkTriggerId = 5115703,
	},
	[5115763] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511576_Bubble.story",
		TalkId = 5115763,
		TalkTriggerId = 5115763,
	},
	[5115802] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511580_EndTalk.story",
		TalkId = 5115802,
		TalkTriggerId = 5115802,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511580,
			},
		},
	},
	[5115803] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511580_Bubble.story",
		TalkId = 5115803,
		TalkTriggerId = 5115803,
	},
	[5115813] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511581_Bubble.story",
		TalkId = 5115813,
		TalkTriggerId = 5115813,
	},
	[5115822] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511582_EndTalk.story",
		TalkId = 5115822,
		TalkTriggerId = 5115822,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511582,
			},
		},
	},
	[5115823] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511582_Bubble.story",
		TalkId = 5115823,
		TalkTriggerId = 5115823,
	},
	[5115833] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511583_Bubble.story",
		TalkId = 5115833,
		TalkTriggerId = 5115833,
	},
	[5115843] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511584_Bubble.story",
		TalkId = 5115843,
		TalkTriggerId = 5115843,
	},
	[5115853] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511585_Bubble.story",
		TalkId = 5115853,
		TalkTriggerId = 5115853,
	},
	[5115863] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511586_Bubble.story",
		TalkId = 5115863,
		TalkTriggerId = 5115863,
	},
	[5115873] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511587_Bubble.story",
		TalkId = 5115873,
		TalkTriggerId = 5115873,
	},
	[5115883] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511588_Bubble.story",
		TalkId = 5115883,
		TalkTriggerId = 5115883,
	},
	[5115893] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511589_Bubble.story",
		TalkId = 5115893,
		TalkTriggerId = 5115893,
	},
	[5115903] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511590_Bubble.story",
		TalkId = 5115903,
		TalkTriggerId = 5115903,
	},
	[5115913] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511591_Bubble.story",
		TalkId = 5115913,
		TalkTriggerId = 5115913,
	},
	[5115923] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511592_Bubble.story",
		TalkId = 5115923,
		TalkTriggerId = 5115923,
	},
	[5115933] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511593_Bubble.story",
		TalkId = 5115933,
		TalkTriggerId = 5115933,
	},
	[5115942] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511594_EndTalk.story",
		TalkId = 5115942,
		TalkTriggerId = 5115942,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511594,
			},
		},
	},
	[5115943] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511594_Bubble.story",
		TalkId = 5115943,
		TalkTriggerId = 5115943,
	},
	[5115953] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511595_Bubble.story",
		TalkId = 5115953,
		TalkTriggerId = 5115953,
	},
	[5115962] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511596_EndTalk.story",
		TalkId = 5115962,
		TalkTriggerId = 5115962,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511596,
			},
		},
	},
	[5115963] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511596_Bubble.story",
		TalkId = 5115963,
		TalkTriggerId = 5115963,
	},
	[5115973] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511597_Bubble.story",
		TalkId = 5115973,
		TalkTriggerId = 5115973,
	},
	[5115983] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511598_Bubble.story",
		TalkId = 5115983,
		TalkTriggerId = 5115983,
	},
	[5115993] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511599_Bubble.story",
		TalkId = 5115993,
		TalkTriggerId = 5115993,
	},
	[5116011] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511601_1.story",
		TalkId = 51156011,
		TalkTriggerId = 5116011,
	},
	[5116012] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511601_3_Bubble.story",
		TalkId = 5116012,
		TalkTriggerId = 5116012,
	},
	[5116013] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511601_Bubble.story",
		TalkId = 5116013,
		TalkTriggerId = 5116013,
	},
	[5116023] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511602_Bubble.story",
		TalkId = 5116023,
		TalkTriggerId = 5116023,
	},
	[5116033] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511603_Bubble.story",
		TalkId = 5116033,
		TalkTriggerId = 5116033,
	},
	[5116043] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511604_Bubble.story",
		TalkId = 5116043,
		TalkTriggerId = 5116043,
	},
	[5116053] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511605_Bubble.story",
		TalkId = 5116053,
		TalkTriggerId = 5116053,
	},
	[5116062] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511606_EndTalk.story",
		TalkId = 5116062,
		TalkTriggerId = 5116062,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511606,
			},
		},
	},
	[5116063] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511606_Bubble.story",
		TalkId = 5116063,
		TalkTriggerId = 5116063,
	},
	[5116093] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511609_Bubble.story",
		TalkId = 5116093,
		TalkTriggerId = 5116093,
	},
	[5116102] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511610_EndTalk.story",
		TalkId = 5116102,
		TalkTriggerId = 5116102,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 511610,
			},
		},
	},
	[5116103] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511610_Bubble.story",
		TalkId = 5116103,
		TalkTriggerId = 5116103,
	},
	[5116113] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511611_Bubble.story",
		TalkId = 5116113,
		TalkTriggerId = 5116113,
	},
	[5116133] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511613_Bubble.story",
		TalkId = 5116133,
		TalkTriggerId = 5116133,
	},
	[5116143] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511614_Bubble.story",
		TalkId = 511614,
		TalkTriggerId = 5116143,
	},
	[5116153] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511615_Bubble.story",
		TalkId = 5116153,
		TalkTriggerId = 5116153,
	},
	[5116163] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511616_Bubble.story",
		TalkId = 5116163,
		TalkTriggerId = 5116163,
	},
	[5116173] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511617_Bubble.story",
		TalkId = 5116173,
		TalkTriggerId = 5116173,
	},
	[5116183] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511618_Bubble.story",
		TalkId = 5116183,
		TalkTriggerId = 5116183,
	},
	[5116203] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511620_Bubble.story",
		TalkId = 5116203,
		TalkTriggerId = 5116203,
	},
	[5116213] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511621_Bubble.story",
		TalkId = 5116213,
		TalkTriggerId = 5116213,
	},
	[5116221] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511622_1.story",
		TalkId = 5116221,
		TalkTriggerId = 5116221,
	},
	[5116222] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511622_1_Bubble.story",
		TalkId = 5116222,
		TalkTriggerId = 5116222,
	},
	[5116223] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511622_Bubble.story",
		TalkId = 5116223,
		TalkTriggerId = 5116223,
	},
	[5116233] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511623_Bubble.story",
		TalkId = 5116233,
		TalkTriggerId = 5116233,
	},
	[5116243] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511624_Bubble.story",
		TalkId = 5116243,
		TalkTriggerId = 5116243,
	},
	[5116253] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511625_Bubble.story",
		TalkId = 5116253,
		TalkTriggerId = 5116253,
	},
	[5116263] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511626_Bubble.story",
		TalkId = 5116263,
		TalkTriggerId = 5116263,
	},
	[5116273] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511627_Bubble.story",
		TalkId = 5116273,
		TalkTriggerId = 5116273,
	},
	[5116283] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511628_Bubble.story",
		TalkId = 5116283,
		TalkTriggerId = 5116283,
	},
	[5116293] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511629_Bubble.story",
		TalkId = 5116293,
		TalkTriggerId = 5116293,
	},
	[5116703] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511670_Bubble.story",
		TalkId = 5116703,
		TalkTriggerId = 5116703,
	},
	[5116713] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511671_Bubble.story",
		TalkId = 5116713,
		TalkTriggerId = 5116713,
	},
	[5116723] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511672_Bubble.story",
		TalkId = 5116723,
		TalkTriggerId = 5116723,
	},
	[5116733] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511673_Bubble.story",
		TalkId = 5116733,
		TalkTriggerId = 5116733,
	},
	[5116743] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511674_Bubble.story",
		TalkId = 5116743,
		TalkTriggerId = 5116743,
	},
	[5116753] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511675_Bubble.story",
		TalkId = 5116753,
		TalkTriggerId = 5116753,
	},
	[5116763] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511676_Bubble.story",
		TalkId = 5116763,
		TalkTriggerId = 5116763,
	},
	[5116773] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511677_Bubble.story",
		TalkId = 5116773,
		TalkTriggerId = 5116773,
	},
	[5116783] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511678_Bubble.story",
		TalkId = 5116783,
		TalkTriggerId = 5116783,
	},
	[5116793] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511679_Bubble.story",
		TalkId = 5116793,
		TalkTriggerId = 5116793,
	},
	[5116803] = {
		StoryLinePath = "Impression\\East02\\Wes_Gossip\\511680_Bubble.story",
		TalkId = 5116803,
		TalkTriggerId = 5116803,
	},
	[5116813] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511681_Bubble.story",
		TalkId = 5116813,
		TalkTriggerId = 5116813,
	},
	[5116823] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511682_Bubble.story",
		TalkId = 5116823,
		TalkTriggerId = 5116823,
	},
	[5116833] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511683_Bubble.story",
		TalkId = 5116833,
		TalkTriggerId = 5116833,
	},
	[5116841] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511684_1.story",
		TalkId = 5116841,
		TalkTriggerId = 5116841,
	},
	[5116843] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511684_Bubble.story",
		TalkId = 5116843,
		TalkTriggerId = 5116843,
	},
	[5116853] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511685_Bubble.story",
		TalkId = 5116853,
		TalkTriggerId = 5116853,
	},
	[5116863] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511686_Bubble.story",
		TalkId = 5116863,
		TalkTriggerId = 5116863,
	},
	[5116923] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511692_Bubble.story",
		TalkId = 5116923,
		TalkTriggerId = 5116923,
	},
	[5116933] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511693_Bubble.story",
		TalkId = 5116933,
		TalkTriggerId = 5116933,
	},
	[5116943] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511694_Bubble.story",
		TalkId = 5116943,
		TalkTriggerId = 5116943,
	},
	[5116953] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511695_Bubble.story",
		TalkId = 5116953,
		TalkTriggerId = 5116953,
	},
	[5116963] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511696_Bubble.story",
		TalkId = 5116963,
		TalkTriggerId = 5116963,
	},
	[5116973] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511697_Bubble.story",
		TalkId = 5116973,
		TalkTriggerId = 5116973,
	},
	[5116993] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511699_Bubble.story",
		TalkId = 5116993,
		TalkTriggerId = 5116993,
	},
	[5117003] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511700_Bubble.story",
		TalkId = 5117003,
		TalkTriggerId = 5117003,
	},
	[5117013] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511701_Bubble.story",
		TalkId = 5117013,
		TalkTriggerId = 5117013,
	},
	[5117023] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511702_Bubble.story",
		TalkId = 5117023,
		TalkTriggerId = 5117023,
	},
	[5117033] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511703_Bubble.story",
		TalkId = 5117033,
		TalkTriggerId = 5117033,
	},
	[5117043] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511704_Bubble.story",
		TalkId = 5117043,
		TalkTriggerId = 5117043,
	},
	[5117053] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511705_Bubble.story",
		TalkId = 5117053,
		TalkTriggerId = 5117053,
	},
	[5117063] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511706_Bubble.story",
		TalkId = 5117063,
		TalkTriggerId = 5117063,
	},
	[5117073] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511707_Bubble.story",
		TalkId = 5117073,
		TalkTriggerId = 5117073,
	},
	[5117083] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511708_Bubble.story",
		TalkId = 5117083,
		TalkTriggerId = 5117083,
	},
	[5117093] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511709_Bubble.story",
		TalkId = 5117093,
		TalkTriggerId = 5117093,
	},
	[5117103] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511710_Bubble.story",
		TalkId = 5117103,
		TalkTriggerId = 5117103,
	},
	[5117113] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511711_Bubble.story",
		TalkId = 5117113,
		TalkTriggerId = 5117113,
	},
	[5117123] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511712_Bubble.story",
		TalkId = 5117123,
		TalkTriggerId = 5117123,
	},
	[5117133] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511713_Bubble.story",
		TalkId = 5117133,
		TalkTriggerId = 5117133,
	},
	[5117143] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511714_Bubble.story",
		TalkId = 5117143,
		TalkTriggerId = 5117143,
	},
	[5117163] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511716_Bubble.story",
		TalkId = 5117163,
		TalkTriggerId = 5117163,
	},
	[5117173] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511717_Bubble.story",
		TalkId = 5117173,
		TalkTriggerId = 5117173,
	},
	[5117183] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511718_Bubble.story",
		TalkId = 5117183,
		TalkTriggerId = 5117183,
	},
	[5117193] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511719_Bubble.story",
		TalkId = 5117193,
		TalkTriggerId = 5117193,
	},
	[5117203] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511720_Bubble.story",
		TalkId = 5117203,
		TalkTriggerId = 5117203,
	},
	[5117213] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511721_Bubble.story",
		TalkId = 5117213,
		TalkTriggerId = 5117213,
	},
	[5117223] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511722_Bubble.story",
		TalkId = 5117223,
		TalkTriggerId = 5117223,
	},
	[5117233] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511723_Bubble.story",
		TalkId = 5117233,
		TalkTriggerId = 5117233,
	},
	[5117243] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511724_Bubble.story",
		TalkId = 5117243,
		TalkTriggerId = 5117243,
	},
	[5117253] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511725_Bubble.story",
		TalkId = 5117253,
		TalkTriggerId = 5117253,
	},
	[5117263] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511726_Bubble.story",
		TalkId = 5117263,
		TalkTriggerId = 5117263,
	},
	[5117273] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511727_Bubble.story",
		TalkId = 5117273,
		TalkTriggerId = 5117273,
	},
	[5117283] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511728_Bubble.story",
		TalkId = 5117283,
		TalkTriggerId = 5117283,
	},
	[5117293] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511729_Bubble.story",
		TalkId = 5117293,
		TalkTriggerId = 5117293,
	},
	[5117313] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511731_Bubble.story",
		TalkId = 5117313,
		TalkTriggerId = 5117313,
	},
	[5117323] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511732_Bubble.story",
		TalkId = 5117323,
		TalkTriggerId = 5117323,
	},
	[5117333] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511733_Bubble.story",
		TalkId = 5117333,
		TalkTriggerId = 5117333,
	},
	[5117343] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511734_Bubble.story",
		TalkId = 5117343,
		TalkTriggerId = 5117343,
	},
	[5117353] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511735_Bubble.story",
		TalkId = 5117353,
		TalkTriggerId = 5117353,
	},
	[5117363] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511736_Bubble.story",
		TalkId = 5117363,
		TalkTriggerId = 5117363,
	},
	[5117373] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511681_Bubble.story",
		TalkId = 5117373,
		TalkTriggerId = 5117373,
	},
	[5117383] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511682_Bubble.story",
		TalkId = 5117383,
		TalkTriggerId = 5117383,
	},
	[5117393] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511683_Bubble.story",
		TalkId = 5117393,
		TalkTriggerId = 5117393,
	},
	[5117403] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511684_Bubble.story",
		TalkId = 5117403,
		TalkTriggerId = 5117403,
	},
	[5117433] = {
		StoryLinePath = "Impression/East02/Gossip/511743_Bubble.story",
		TalkId = 5117433,
		TalkTriggerId = 5117433,
	},
	[5117443] = {
		StoryLinePath = "Impression/East02/Gossip/511744_Bubble.story",
		TalkId = 5117443,
		TalkTriggerId = 5117443,
	},
	[5117453] = {
		StoryLinePath = "Impression/East02/Gossip/511745_Bubble.story",
		TalkId = 5117453,
		TalkTriggerId = 5117453,
	},
	[5117463] = {
		StoryLinePath = "Impression\\East02\\Gossip\\511746_Bubble.story",
		TalkId = 5117463,
		TalkTriggerId = 5117463,
	},
	[5117473] = {
		StoryLinePath = "Impression\\East02\\Jlc_Gossip\\511747_Bubble.story",
		TalkId = 5117473,
		TalkTriggerId = 5117473,
	},
	[5117483] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511748_Bubble.story",
		TalkId = 5117483,
		TalkTriggerId = 5117483,
	},
	[5117493] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511749_Bubble.story",
		TalkId = 5117493,
		TalkTriggerId = 5117493,
	},
	[5117503] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511750_Bubble.story",
		TalkId = 5117503,
		TalkTriggerId = 5117503,
	},
	[5117513] = {
		StoryLinePath = "Impression\\East02\\Inn_Gossip\\511751_Bubble.story",
		TalkId = 5117513,
		TalkTriggerId = 5117513,
	},
	[7001581] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001581,
		TalkTriggerId = 7001581,
	},
	[7001591] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001591,
		TalkTriggerId = 7001591,
	},
	[7001621] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001621,
		TalkTriggerId = 7001621,
	},
	[7001631] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001631,
		TalkTriggerId = 7001631,
	},
	[7001641] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001641,
		TalkTriggerId = 7001641,
	},
	[7001651] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001651,
		TalkTriggerId = 7001651,
	},
	[7001661] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001661,
		TalkTriggerId = 7001661,
	},
	[7001671] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001671,
		TalkTriggerId = 7001671,
	},
	[7001681] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001681,
		TalkTriggerId = 7001681,
	},
	[7001691] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001691,
		TalkTriggerId = 7001691,
	},
	[7001701] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001701,
		TalkTriggerId = 7001701,
	},
	[7001711] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001711,
		TalkTriggerId = 7001711,
	},
	[7001721] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001721,
		TalkTriggerId = 7001721,
	},
	[7001731] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001731,
		TalkTriggerId = 7001731,
	},
	[7001741] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001741,
		TalkTriggerId = 7001741,
	},
	[7001751] = {
		StoryLinePath = "Observe/East01.story",
		TalkId = 7001751,
		TalkTriggerId = 7001751,
	},
	[8200011] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200011,
		TalkTriggerId = 8200011,
		Type = "Impression",
	},
	[8200012] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200012,
		TalkTriggerId = 8200012,
		TriggerCondition = {
			And = {
				{
					ImprComp = {
						TalkTriggerId = 8200011,
					},
				},
				T.RT_55,
			},
		},
	},
	[8200013] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200013,
		TalkTriggerId = 8200013,
	},
	[8200014] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200014,
		TalkTriggerId = 8200014,
	},
	[8200021] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200021,
		TalkTriggerId = 8200021,
		TriggerCondition = T.RT_56,
		Type = "Impression",
	},
	[8200022] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200022,
		TalkTriggerId = 8200022,
		TriggerCondition = {
			And = {
				{
					ImprComp = {
						TalkTriggerId = 8200021,
					},
				},
				T.RT_56,
				{
					ExploreGroupInActive = T.RT_57,
				},
			},
		},
	},
	[8200023] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200023,
		TalkTriggerId = 8200023,
	},
	[8200024] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200024,
		TalkTriggerId = 8200024,
	},
	[8200031] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200031,
		TalkTriggerId = 8200031,
		TriggerCondition = T.RT_58,
		Type = "Impression",
	},
	[8200032] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200032,
		TalkTriggerId = 8200032,
		TriggerCondition = {
			And = {
				{
					ImprComp = {
						TalkTriggerId = 8200031,
					},
				},
				T.RT_58,
				{
					ExploreGroupInActive = {
						ExploreGroupId = 7013100,
					},
				},
			},
		},
	},
	[8200033] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200033,
		TalkTriggerId = 8200033,
		Type = "Impression",
	},
	[8200034] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200034,
		TalkTriggerId = 8200034,
	},
	[8200042] = {
		StoryLinePath = "Explore/Laser.story",
		TalkId = 8200042,
		TalkTriggerId = 8200042,
		TriggerCondition = {
			And = {
				{
					ImprComp = {
						TalkTriggerId = 8200033,
					},
				},
				T.RT_55,
			},
		},
	},
	[9022011] = {
		StoryLinePath = "TalkGossip/902201_Dafu_B4Ex01.story",
		TalkId = 9022011,
		TalkTriggerId = 9022011,
		TriggerCondition = {
			QuestChainUnFinish = T.RT_61,
		},
	},
	[9022012] = {
		StoryLinePath = "TalkGossip/902201_Dafu_AFTEx01.story",
		TalkId = 9022012,
		TalkTriggerId = 9022012,
		TriggerCondition = {
			QuestChainFinish = T.RT_61,
		},
	},
	[9023011] = {
		StoryLinePath = "TalkGossip/902301_Tuosi_B4Ch02.story",
		TalkId = 9023011,
		TalkTriggerId = 9023011,
		TriggerCondition = T.RT_63,
	},
	[9023012] = {
		StoryLinePath = "TalkGossip/902301_Tuosi_AFTCh02.story",
		TalkId = 9023012,
		TalkTriggerId = 9023012,
		TriggerCondition = T.RT_64,
	},
	[9024011] = {
		StoryLinePath = "TalkGossip/902401_Lise_B4Ch02.story",
		TalkId = 9024011,
		TalkTriggerId = 9024011,
		TriggerCondition = T.RT_63,
	},
	[9024012] = {
		StoryLinePath = "TalkGossip/902401_Lise_AFTCh02.story",
		TalkId = 9024012,
		TalkTriggerId = 9024012,
		TriggerCondition = T.RT_64,
	},
	[10010104] = {
		StoryLinePath = "Common/10010104.story",
		TalkId = 10010104,
		TalkTriggerId = 10010104,
	},
	[10032501] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/10032501.story",
		TalkId = 10032501,
		TalkTriggerId = 10032501,
	},
	[10032601] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/10032601.story",
		TalkId = 10032601,
		TalkTriggerId = 10032601,
	},
	[10032701] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/10032701.story",
		TalkId = 10032701,
		TalkTriggerId = 10032701,
	},
	[10032801] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/10032801.story",
		TalkId = 10032801,
		TalkTriggerId = 10032801,
	},
	[10032901] = {
		StoryLinePath = "Impression/IceLakeCity/Gossip/10032901.story",
		TalkId = 10032901,
		TalkTriggerId = 10032901,
	},
	[10122401] = {
		DialogueId = 10122401,
		TalkTriggerId = 10122401,
		TalkType = "Guide",
	},
	[10122402] = {
		DialogueId = 10122402,
		TalkTriggerId = 10122402,
		TalkType = "Guide",
	},
	[10122701] = {
		DialogueId = 10122701,
		TalkTriggerId = 10122701,
		TalkType = "Guide",
	},
	[51013201] = {
		StoryLinePath = "Impression/East01/701015_Yang_3",
		TalkId = 51013201,
		TalkTriggerId = 51013201,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510132,
			},
		},
		Type = "Impression",
	},
	[51013601] = {
		StoryLinePath = "Impression/East01/701024_QingQing_2",
		TalkId = 51013601,
		TalkTriggerId = 51013601,
		Type = "Impression",
	},
	[51013602] = {
		StoryLinePath = "Impression/East01/701024_QingQing_3",
		TalkId = 51013602,
		TalkTriggerId = 51013602,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 51013601,
			},
		},
		Type = "Impression",
	},
	[51013701] = {
		StoryLinePath = "Impression/East01/701026_QuanDoutong_2",
		TalkId = 51013701,
		TalkTriggerId = 51013701,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510137,
			},
		},
	},
	[51013801] = {
		StoryLinePath = "Impression/East01/701027_DrHuang_2",
		TalkId = 51013801,
		TalkTriggerId = 51013801,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510138,
			},
		},
	},
	[51014001] = {
		StoryLinePath = "Impression/East01/701031_JiuPiaoZi_2",
		TalkId = 51014001,
		TalkTriggerId = 51014001,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510140,
			},
		},
	},
	[51014101] = {
		StoryLinePath = "Impression/East01/701032_FengDeng_2",
		TalkId = 51014101,
		TalkTriggerId = 51014101,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510141,
			},
		},
	},
	[51014201] = {
		StoryLinePath = "Impression/East01/701033_MysteryWhite_2",
		TalkId = 51014201,
		TalkTriggerId = 51014201,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510142,
			},
		},
	},
	[51014901] = {
		StoryLinePath = "Impression/East01/701015_Yang_2",
		TalkId = 51014901,
		TalkTriggerId = 51014901,
		TriggerCondition = {
			QuestChainFinish = {
				QuestChainId = 200311,
			},
		},
	},
	[51105801] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105801.story",
		TalkId = 51105801,
		TalkTriggerId = 51105801,
	},
	[51105802] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105802.story",
		TalkId = 51105802,
		TalkTriggerId = 51105802,
	},
	[51105803] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105803.story",
		TalkId = 51105803,
		TalkTriggerId = 51105803,
	},
	[51105804] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105804.story",
		TalkId = 51105804,
		TalkTriggerId = 51105804,
	},
	[51105805] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105805.story",
		TalkId = 51105805,
		TalkTriggerId = 51105805,
	},
	[51105806] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105806.story",
		TalkId = 51105806,
		TalkTriggerId = 51105806,
	},
	[51105807] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105807.story",
		TalkId = 51105807,
		TalkTriggerId = 51105807,
	},
	[51105808] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105808.story",
		TalkId = 51105808,
		TalkTriggerId = 51105808,
	},
	[51105809] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105809.story",
		TalkId = 51105809,
		TalkTriggerId = 51105809,
	},
	[51105810] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105810.story",
		TalkId = 51105810,
		TalkTriggerId = 51105810,
	},
	[51105811] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105811.story",
		TalkId = 51105811,
		TalkTriggerId = 51105811,
	},
	[51105812] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105812.story",
		TalkId = 51105812,
		TalkTriggerId = 51105812,
	},
	[51105813] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105813.story",
		TalkId = 51105813,
		TalkTriggerId = 51105813,
	},
	[51105814] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105814.story",
		TalkId = 51105814,
		TalkTriggerId = 51105814,
	},
	[51105815] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105815.story",
		TalkId = 51105815,
		TalkTriggerId = 51105815,
	},
	[51105816] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105816.story",
		TalkId = 51105816,
		TalkTriggerId = 51105816,
	},
	[51105817] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105817.story",
		TalkId = 51105817,
		TalkTriggerId = 51105817,
	},
	[51105818] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105818.story",
		TalkId = 51105818,
		TalkTriggerId = 51105818,
	},
	[51105819] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105819.story",
		TalkId = 51105819,
		TalkTriggerId = 51105819,
	},
	[51105820] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105820.story",
		TalkId = 51105820,
		TalkTriggerId = 51105820,
	},
	[51105821] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105821.story",
		TalkId = 51105821,
		TalkTriggerId = 51105821,
	},
	[51105822] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105822.story",
		TalkId = 51105822,
		TalkTriggerId = 51105822,
	},
	[51105823] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105823.story",
		TalkId = 51105823,
		TalkTriggerId = 51105823,
	},
	[51105824] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105824.story",
		TalkId = 51105824,
		TalkTriggerId = 51105824,
	},
	[51105825] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105825.story",
		TalkId = 51105825,
		TalkTriggerId = 51105825,
	},
	[51105826] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105826.story",
		TalkId = 51105826,
		TalkTriggerId = 51105826,
	},
	[51105827] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105827.story",
		TalkId = 51105827,
		TalkTriggerId = 51105827,
	},
	[51105828] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105828.story",
		TalkId = 51105828,
		TalkTriggerId = 51105828,
	},
	[51105829] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105829.story",
		TalkId = 51105829,
		TalkTriggerId = 51105829,
	},
	[51105830] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105830.story",
		TalkId = 51105830,
		TalkTriggerId = 51105830,
	},
	[51105831] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105831.story",
		TalkId = 51105831,
		TalkTriggerId = 51105831,
	},
	[51105832] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105832.story",
		TalkId = 51105832,
		TalkTriggerId = 51105832,
	},
	[51105833] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105833.story",
		TalkId = 51105833,
		TalkTriggerId = 51105833,
	},
	[51105834] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105834.story",
		TalkId = 51105834,
		TalkTriggerId = 51105834,
	},
	[51105835] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105835.story",
		TalkId = 51105835,
		TalkTriggerId = 51105835,
	},
	[51105836] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105836.story",
		TalkId = 51105836,
		TalkTriggerId = 51105836,
	},
	[51105837] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105837.story",
		TalkId = 51105837,
		TalkTriggerId = 51105837,
	},
	[51105838] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105838.story",
		TalkId = 51105838,
		TalkTriggerId = 51105838,
	},
	[51105839] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105839.story",
		TalkId = 51105839,
		TalkTriggerId = 51105839,
	},
	[51105840] = {
		StoryLinePath = "ActiveQuest/ActiveThea/Gossip/51105840.story",
		TalkId = 51105840,
		TalkTriggerId = 51105840,
	},
	[74114700] = {
		StoryLinePath = "QuestTest/FacialTest.story",
		TalkTriggerId = 74114700,
	},
	[74114701] = {
		StoryLinePath = "QuestTest/74114701.story",
		TalkTriggerId = 74114701,
	},
	[74114702] = {
		StoryLinePath = "QuestTest/74114702.story",
		TalkTriggerId = 74114702,
	},
	[74114703] = {
		StoryLinePath = "QuestTest/74114703.story",
		TalkTriggerId = 74114703,
	},
	[74114704] = {
		StoryLinePath = "QuestTest/74114704.story",
		TalkTriggerId = 74114704,
	},
	[74114705] = {
		StoryLinePath = "QuestTest/74114705.story",
		TalkTriggerId = 74114705,
	},
	[74114706] = {
		StoryLinePath = "QuestTest/74114706.story",
		TalkTriggerId = 74114706,
	},
	[74114707] = {
		StoryLinePath = "QuestTest/74114707.story",
		TalkTriggerId = 74114707,
	},
	[74114708] = {
		StoryLinePath = "QuestTest/74114708.story",
		TalkTriggerId = 74114708,
	},
	[74114709] = {
		StoryLinePath = "QuestTest/74114709.story",
		TalkTriggerId = 74114709,
	},
	[74114710] = {
		StoryLinePath = "QuestTest/74114710.story",
		TalkTriggerId = 74114710,
	},
	[74114711] = {
		StoryLinePath = "QuestTest/74114711.story",
		TalkTriggerId = 74114711,
	},
	[74114712] = {
		StoryLinePath = "QuestTest/74114712.story",
		TalkTriggerId = 74114712,
	},
	[74114713] = {
		StoryLinePath = "QuestTest/74114713.story",
		TalkTriggerId = 74114713,
	},
	[74114714] = {
		StoryLinePath = "QuestTest/74114714.story",
		TalkTriggerId = 74114714,
	},
	[74114715] = {
		StoryLinePath = "QuestTest/74114715.story",
		TalkTriggerId = 74114715,
	},
	[74114716] = {
		StoryLinePath = "QuestTest/74114716.story",
		TalkTriggerId = 74114716,
	},
	[74114717] = {
		StoryLinePath = "QuestTest/74114717.story",
		TalkTriggerId = 74114717,
	},
	[74114718] = {
		StoryLinePath = "QuestTest/74114718.story",
		TalkTriggerId = 74114718,
	},
	[74114719] = {
		StoryLinePath = "QuestTest/74114719.story",
		TalkTriggerId = 74114719,
	},
	[74114720] = {
		StoryLinePath = "QuestTest/74114720.story",
		TalkTriggerId = 74114720,
	},
	[74114721] = {
		StoryLinePath = "QuestTest/74114721.story",
		TalkTriggerId = 74114721,
	},
	[74114722] = {
		StoryLinePath = "QuestTest/74114722.story",
		TalkTriggerId = 74114722,
	},
	[74114723] = {
		StoryLinePath = "QuestTest/74114723.story",
		TalkTriggerId = 74114723,
	},
	[74114724] = {
		StoryLinePath = "QuestTest/74114724.story",
		TalkTriggerId = 74114724,
	},
	[74114725] = {
		StoryLinePath = "QuestTest/74114725.story",
		TalkTriggerId = 74114725,
	},
	[74114726] = {
		StoryLinePath = "QuestTest/74114726.story",
		TalkTriggerId = 74114726,
	},
	[74114727] = {
		StoryLinePath = "QuestTest/74114727.story",
		TalkTriggerId = 74114727,
	},
	[74114728] = {
		StoryLinePath = "QuestTest/74114728.story",
		TalkTriggerId = 74114728,
	},
	[74114729] = {
		StoryLinePath = "QuestTest/74114729.story",
		TalkTriggerId = 74114729,
		Type = "Impression",
	},
	[74114730] = {
		StoryLinePath = "QuestTest/74114730.story",
		TalkTriggerId = 74114730,
		Type = "Impression",
	},
	[74114731] = {
		StoryLinePath = "QuestTest/74114731.story",
		TalkTriggerId = 74114731,
	},
	[74114732] = {
		StoryLinePath = "QuestTest/74114732.story",
		TalkTriggerId = 74114732,
	},
	[74114733] = {
		StoryLinePath = "QuestTest/74114733.story",
		TalkTriggerId = 74114733,
	},
	[74114734] = {
		StoryLinePath = "QuestTest/74114734.story",
		TalkTriggerId = 74114734,
	},
	[74114735] = {
		StoryLinePath = "QuestTest/74114735.story",
		TalkTriggerId = 74114735,
	},
	[74114736] = {
		StoryLinePath = "QuestTest/74114736.story",
		TalkTriggerId = 74114736,
	},
	[74114737] = {
		StoryLinePath = "QuestTest/74114737.story",
		TalkTriggerId = 74114737,
	},
	[74114738] = {
		StoryLinePath = "QuestTest/74114738.story",
		TalkTriggerId = 74114738,
	},
	[74114739] = {
		StoryLinePath = "QuestTest/74114739.story",
		TalkTriggerId = 74114739,
	},
	[74114740] = {
		StoryLinePath = "QuestTest/74114740.story",
		TalkTriggerId = 74114740,
	},
	[74114741] = {
		StoryLinePath = "QuestTest/74114741.story",
		TalkTriggerId = 74114741,
	},
	[74114742] = {
		StoryLinePath = "QuestTest/74114742.story",
		TalkTriggerId = 74114742,
	},
	[74114743] = {
		StoryLinePath = "QuestTest/74114743.story",
		TalkTriggerId = 74114743,
	},
	[74114744] = {
		StoryLinePath = "QuestTest/74114744.story",
		TalkTriggerId = 74114744,
	},
	[75000002] = {
		StoryLinePath = "QuestTest/75000002.story",
		TalkTriggerId = 75000002,
	},
	[76000014] = {
		StoryLinePath = "QuestTest/FacialTest_LNM.story",
		TalkTriggerId = 76000014,
	},
	[76000015] = {
		StoryLinePath = "QuestTest/FacialTest_LNF.story",
		TalkTriggerId = 76000015,
	},
	[76000016] = {
		StoryLinePath = "QuestTest/FacialTest_ZNM.story",
		TalkTriggerId = 76000016,
	},
	[76000017] = {
		StoryLinePath = "QuestTest/FacialTest_ZNF.story",
		TalkTriggerId = 76000017,
	},
	[76000018] = {
		StoryLinePath = "QuestTest/FacialTest_QNM.story",
		TalkTriggerId = 76000018,
	},
	[76000019] = {
		StoryLinePath = "QuestTest/FacialTest_QNF.story",
		TalkTriggerId = 76000019,
	},
	[76000020] = {
		StoryLinePath = "QuestTest/FacialTest_YN.story",
		TalkTriggerId = 76000020,
	},
	[80001001] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_01_Intro.story",
		TalkId = 80001001,
		TalkTriggerId = 80001001,
	},
	[80001004] = {
		DialogueId = 80001004,
		TalkTriggerId = 80001004,
		TalkType = "Guide",
	},
	[80001005] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_01.story",
		TalkId = 80001005,
		TalkTriggerId = 80001005,
	},
	[80001007] = {
		DialogueId = 80001007,
		TalkTriggerId = 80001007,
		TalkType = "Guide",
	},
	[80001008] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_02.story",
		TalkId = 80001008,
		TalkTriggerId = 80001008,
	},
	[80001010] = {
		DialogueId = 80001010,
		TalkTriggerId = 80001010,
		TalkType = "Guide",
	},
	[80001011] = {
		DialogueId = 80001011,
		TalkTriggerId = 80001011,
		TalkType = "Guide",
	},
	[80001012] = {
		DialogueId = 80001012,
		TalkTriggerId = 80001012,
		TalkType = "Guide",
	},
	[80001013] = {
		DialogueId = 80001013,
		TalkTriggerId = 80001013,
		TalkType = "Guide",
	},
	[80001014] = {
		DialogueId = 80001014,
		TalkTriggerId = 80001014,
		TalkType = "Guide",
	},
	[80001015] = {
		DialogueId = 80001015,
		TalkTriggerId = 80001015,
		TalkType = "Guide",
	},
	[80001017] = {
		DialogueId = 80001017,
		TalkTriggerId = 80001017,
		TalkType = "Guide",
	},
	[80001018] = {
		DialogueId = 80001018,
		TalkTriggerId = 80001018,
		TalkType = "Guide",
	},
	[80001019] = {
		DialogueId = 80001019,
		TalkTriggerId = 80001019,
		TalkType = "Guide",
	},
	[80001021] = {
		DialogueId = 80001021,
		TalkTriggerId = 80001021,
		TalkType = "Guide",
	},
	[80001022] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_01_Aote.story",
		TalkTriggerId = 80001022,
	},
	[80001024] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_01_Feather.story",
		TalkId = 80001024,
		TalkTriggerId = 80001024,
	},
	[80002001] = {
		DialogueId = 80002001,
		TalkTriggerId = 80002001,
		TalkType = "Guide",
	},
	[80002003] = {
		DialogueId = 80002003,
		TalkTriggerId = 80002003,
		TalkType = "Guide",
	},
	[80002004] = {
		DialogueId = 80002004,
		TalkTriggerId = 80002004,
		TalkType = "Guide",
	},
	[80002005] = {
		DialogueId = 80002005,
		TalkTriggerId = 80002005,
		TalkType = "Guide",
	},
	[80002006] = {
		DialogueId = 80002006,
		TalkTriggerId = 80002006,
		TalkType = "Guide",
	},
	[80002007] = {
		DialogueId = 80002007,
		TalkTriggerId = 80002007,
		TalkType = "Guide",
	},
	[80002008] = {
		DialogueId = 80002008,
		TalkTriggerId = 80002008,
		TalkType = "Guide",
	},
	[80002009] = {
		DialogueId = 80002009,
		TalkTriggerId = 80002009,
		TalkType = "Guide",
	},
	[80002010] = {
		DialogueId = 80002010,
		TalkTriggerId = 80002010,
		TalkType = "Guide",
	},
	[80002012] = {
		DialogueId = 80002012,
		TalkTriggerId = 80002012,
		TalkType = "Guide",
	},
	[80002013] = {
		DialogueId = 80002013,
		TalkTriggerId = 80002013,
		TalkType = "Guide",
	},
	[80002014] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_02_Unicorn.story",
		TalkTriggerId = 80002014,
	},
	[80002016] = {
		DialogueId = 80002016,
		TalkTriggerId = 80002016,
		TalkType = "Guide",
	},
	[80002017] = {
		DialogueId = 80002017,
		TalkTriggerId = 80002017,
		TalkType = "Guide",
	},
	[80002018] = {
		DialogueId = 80002018,
		TalkTriggerId = 80002018,
		TalkType = "Guide",
	},
	[80002019] = {
		DialogueId = 80002019,
		TalkTriggerId = 80002019,
		TalkType = "Guide",
	},
	[80002020] = {
		DialogueId = 80002020,
		TalkTriggerId = 80002020,
		TalkType = "Guide",
	},
	[80002021] = {
		DialogueId = 80002021,
		TalkTriggerId = 80002021,
		TalkType = "Guide",
	},
	[80002022] = {
		DialogueId = 80002022,
		TalkTriggerId = 80002022,
		TalkType = "Guide",
	},
	[80002023] = {
		DialogueId = 80002023,
		TalkTriggerId = 80002023,
		TalkType = "Guide",
	},
	[80002024] = {
		DialogueId = 80002024,
		TalkTriggerId = 80002024,
		TalkType = "Guide",
	},
	[80002025] = {
		DialogueId = 80002025,
		TalkTriggerId = 80002025,
		TalkType = "Guide",
	},
	[80002027] = {
		DialogueId = 80002027,
		TalkTriggerId = 80002027,
		TalkType = "Guide",
	},
	[80002029] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_02_Feather.story",
		TalkTriggerId = 80002029,
	},
	[80003100] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_031_Init.story",
		TalkTriggerId = 80003100,
	},
	[80003101] = {
		DialogueId = 80003101,
		TalkTriggerId = 80003101,
		TalkType = "Guide",
	},
	[80003102] = {
		DialogueId = 80003102,
		TalkTriggerId = 80003102,
		TalkType = "Guide",
	},
	[80003103] = {
		DialogueId = 80003103,
		TalkTriggerId = 80003103,
		TalkType = "Guide",
	},
	[80003104] = {
		DialogueId = 80003104,
		TalkTriggerId = 80003104,
		TalkType = "Guide",
	},
	[80003105] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_04.story",
		TalkTriggerId = 80003105,
	},
	[80003106] = {
		DialogueId = 80003106,
		TalkTriggerId = 80003106,
		TalkType = "Guide",
	},
	[80003107] = {
		DialogueId = 80003107,
		TalkTriggerId = 80003107,
		TalkType = "Guide",
	},
	[80003108] = {
		DialogueId = 80003108,
		TalkTriggerId = 80003108,
		TalkType = "Guide",
	},
	[80003109] = {
		DialogueId = 80003109,
		TalkTriggerId = 80003109,
		TalkType = "Guide",
	},
	[80003110] = {
		DialogueId = 80003110,
		TalkTriggerId = 80003110,
		TalkType = "Guide",
	},
	[80003111] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_06.story",
		TalkTriggerId = 80003111,
	},
	[80003112] = {
		DialogueId = 80003112,
		TalkTriggerId = 80003112,
		TalkType = "Guide",
	},
	[80003113] = {
		DialogueId = 80003113,
		TalkTriggerId = 80003113,
		TalkType = "Guide",
	},
	[80003114] = {
		DialogueId = 80003114,
		TalkTriggerId = 80003114,
		TalkType = "Guide",
	},
	[80003115] = {
		DialogueId = 80003115,
		TalkTriggerId = 80003115,
		TalkType = "Guide",
	},
	[80003116] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_031_Boat.story",
		TalkTriggerId = 80003116,
	},
	[80003117] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_031_Feather.story",
		TalkTriggerId = 80003117,
	},
	[80003200] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_032_InitBoat.story",
		TalkTriggerId = 80003200,
	},
	[80003201] = {
		DialogueId = 80003201,
		TalkTriggerId = 80003201,
		TalkType = "Guide",
	},
	[80003202] = {
		DialogueId = 80003202,
		TalkTriggerId = 80003202,
		TalkType = "Guide",
	},
	[80003203] = {
		DialogueId = 80003203,
		TalkTriggerId = 80003203,
		TalkType = "Guide",
	},
	[80003204] = {
		DialogueId = 80003204,
		TalkTriggerId = 80003204,
		TalkType = "Guide",
	},
	[80003205] = {
		DialogueId = 80003205,
		TalkTriggerId = 80003205,
		TalkType = "Guide",
	},
	[80003206] = {
		DialogueId = 80003206,
		TalkTriggerId = 80003206,
		TalkType = "Guide",
	},
	[80003207] = {
		DialogueId = 80003207,
		TalkTriggerId = 80003207,
		TalkType = "Guide",
	},
	[80003208] = {
		DialogueId = 80003208,
		TalkTriggerId = 80003208,
		TalkType = "Guide",
	},
	[80003209] = {
		DialogueId = 80003209,
		TalkTriggerId = 80003209,
		TalkType = "Guide",
	},
	[80003210] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_032_Hehua.story",
		TalkTriggerId = 80003210,
	},
	[80003211] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_032_Tengman.story",
		TalkTriggerId = 80003211,
	},
	[80003212] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_032_Boat.story",
		TalkTriggerId = 80003212,
	},
	[80003213] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_032_Shizhu.story",
		TalkTriggerId = 80003213,
	},
	[80003214] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_032_Feather.story",
		TalkTriggerId = 80003214,
	},
	[80004101] = {
		DialogueId = 80004101,
		TalkTriggerId = 80004101,
		TalkType = "Guide",
	},
	[80004102] = {
		DialogueId = 80004102,
		TalkTriggerId = 80004102,
		TalkType = "Guide",
	},
	[80004103] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_07.story",
		TalkId = 80004103,
		TalkTriggerId = 80004103,
	},
	[80004104] = {
		DialogueId = 80004104,
		TalkTriggerId = 80004104,
		TalkType = "Guide",
	},
	[80004105] = {
		DialogueId = 80004105,
		TalkTriggerId = 80004105,
		TalkType = "Guide",
	},
	[80004106] = {
		DialogueId = 80004106,
		TalkTriggerId = 80004106,
		TalkType = "Guide",
	},
	[80004107] = {
		DialogueId = 80004107,
		TalkTriggerId = 80004107,
		TalkType = "Guide",
	},
	[80004108] = {
		DialogueId = 80004108,
		TalkTriggerId = 80004108,
		TalkType = "Guide",
	},
	[80004109] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_08.story",
		TalkId = 80004109,
		TalkTriggerId = 80004109,
	},
	[80004110] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_041_Feather.story",
		TalkTriggerId = 80004110,
	},
	[80004201] = {
		DialogueId = 80004201,
		TalkTriggerId = 80004201,
		TalkType = "Guide",
	},
	[80004202] = {
		DialogueId = 80004202,
		TalkTriggerId = 80004202,
		TalkType = "Guide",
	},
	[80004203] = {
		DialogueId = 80004203,
		TalkTriggerId = 80004203,
		TalkType = "Guide",
	},
	[80004204] = {
		DialogueId = 80004204,
		TalkTriggerId = 80004204,
		TalkType = "Guide",
	},
	[80004205] = {
		DialogueId = 80004205,
		TalkTriggerId = 80004205,
		TalkType = "Guide",
	},
	[80004206] = {
		DialogueId = 80004206,
		TalkTriggerId = 80004206,
		TalkType = "Guide",
	},
	[80004207] = {
		DialogueId = 80004207,
		TalkTriggerId = 80004207,
		TalkType = "Guide",
	},
	[80004208] = {
		DialogueId = 80004208,
		TalkTriggerId = 80004208,
		TalkType = "Guide",
	},
	[80004209] = {
		DialogueId = 80004209,
		TalkTriggerId = 80004209,
		TalkType = "Guide",
	},
	[80004210] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_042_Zhanzhuang.story",
		TalkId = 80004210,
		TalkTriggerId = 80004210,
	},
	[80004211] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_042_Zhanzhuang.story",
		TalkId = 80004211,
		TalkTriggerId = 80004211,
	},
	[80004212] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_042_Zhanzhuang.story",
		TalkId = 80004212,
		TalkTriggerId = 80004212,
	},
	[80004213] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_042_End.story",
		TalkTriggerId = 80004213,
	},
	[80004214] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_042_Feather.story",
		TalkTriggerId = 80004214,
	},
	[80004250] = {
		DialogueId = 80004250,
		TalkTriggerId = 80004250,
		TalkType = "Guide",
	},
	[80004251] = {
		DialogueId = 80004251,
		TalkTriggerId = 80004251,
		TalkType = "Guide",
	},
	[80004252] = {
		DialogueId = 80004252,
		TalkTriggerId = 80004252,
		TalkType = "Guide",
	},
	[80004253] = {
		DialogueId = 80004253,
		TalkTriggerId = 80004253,
		TalkType = "Guide",
	},
	[80004254] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_05.story",
		TalkTriggerId = 80004254,
	},
	[80004255] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_09.story",
		TalkTriggerId = 80004255,
	},
	[80004256] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_10.story",
		TalkTriggerId = 80004256,
	},
	[80004257] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_11.story",
		TalkTriggerId = 80004257,
	},
	[80004258] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_12.story",
		TalkTriggerId = 80004258,
	},
	[80004259] = {
		StoryLinePath = "Dungeon\\EventFeina\\EventFeina_Guide_03.story",
		TalkTriggerId = 80004259,
	},
	[88888801] = {
		StoryLinePath = "Explore/Home_Cat.story",
		TalkId = 88888801,
		TalkTriggerId = 88888801,
		TriggerCondition = {
			ImprComp = {
				TalkTriggerId = 510122,
			},
		},
	},
})