-- Source Excel file path: ..\datas\UIGuide.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("UIGuide", {
	[3] = {
		ChildGuideId = {
			301,
			302,
		},
		GuideId = 3,
		MainGuideTitle = "MAINUIGUIDE_TITLE_EXECUTION",
	},
	[4] = {
		ChildGuideId = {
			401,
		},
		GuideId = 4,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SKILL2",
	},
	[5] = {
		ChildGuideId = {
			501,
		},
		GuideId = 5,
		MainGuideTitle = "MAINUIGUIDE_TITLE_HPSHIELD",
	},
	[6] = {
		ChildGuideId = {
			601,
			602,
			603,
			604,
		},
		GuideId = 6,
		MainGuideTitle = "MAINUIGUIDE_TITLE_PARTIALDAMAGE",
	},
	[7] = {
		ChildGuideId = {
			701,
			702,
		},
		GuideId = 7,
		MainGuideTitle = "MAINUIGUIDE_TITLE_GUNANDAMMO",
	},
	[8] = {
		ChildGuideId = {
			605,
			606,
			607,
			608,
		},
		GuideId = 8,
		MainGuideTitle = "MAINUIGUIDE_TITLE_PARTIALDAMAGE_CRYSTALOPHILE",
	},
	[9] = {
		ChildGuideId = {
			901,
			902,
		},
		GuideId = 9,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DELIVERY",
	},
	[10] = {
		ChildGuideId = {
			1001,
			1002,
		},
		GuideId = 10,
		MainGuideTitle = "MAINUIGUIDE_TITLE_COMBO",
	},
	[11] = {
		ChildGuideId = {
			1101,
			1102,
		},
		GuideId = 11,
		MainGuideTitle = "MAINUIGUIDE_TITLE_HARDBOSS",
	},
	[12] = {
		ChildGuideId = {
			1201,
			1204,
		},
		GuideId = 12,
		MainGuideTitle = "MAINUIGUIDE_TITLE_MOD",
	},
	[13] = {
		ChildGuideId = {
			1301,
			1302,
		},
		GuideId = 13,
		MainGuideTitle = "MAINUIGUIDE_TITLE_BULLETJUMP",
	},
	[14] = {
		ChildGuideId = {
			1401,
		},
		GuideId = 14,
		MainGuideTitle = "MAINUIGUIDE_TITLE_WALLJUMP",
	},
	[15] = {
		ChildGuideId = {
			1501,
			1502,
		},
		GuideId = 15,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DODGEANDRUN",
	},
	[16] = {
		ChildGuideId = {
			1601,
		},
		GuideId = 16,
		MainGuideTitle = "MAINUIGUIDE_TITLE_LOCKMONSTER",
	},
	[17] = {
		ChildGuideId = {
			1701,
			1702,
		},
		GuideId = 17,
		MainGuideTitle = "MAINUIGUIDE_TITLE_BATTLEWHEEL",
	},
	[18] = {
		ChildGuideId = {
			1801,
			1802,
		},
		GuideId = 18,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SHADOW",
	},
	[19] = {
		ChildGuideId = {
			1901,
		},
		GuideId = 19,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ELEVATOR",
	},
	[20] = {
		ChildGuideId = {
			2001,
		},
		GuideId = 20,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TURNTABLE",
	},
	[21] = {
		ChildGuideId = {
			2101,
		},
		GuideId = 21,
		MainGuideTitle = "MAINUIGUIDE_TITLE_CONNECTMECHANISM",
	},
	[22] = {
		ChildGuideId = {
			2201,
			2202,
		},
		GuideId = 22,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DAMAGEMECHANISM",
	},
	[23] = {
		ChildGuideId = {
			2301,
		},
		GuideId = 23,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DESTRUCTIBLE",
	},
	[25] = {
		ChildGuideId = {
			2501,
			2502,
			2503,
		},
		GuideId = 25,
		MainGuideTitle = "MAINUIGUIDE_TITLE_EXPLORATIONMECHANISM",
	},
	[26] = {
		ChildGuideId = {
			2601,
		},
		GuideId = 26,
		MainGuideTitle = "MAINUIGUIDE_TITLE_CURSORACTIVATION",
	},
	[27] = {
		ChildGuideId = {
			2701,
		},
		GuideId = 27,
		MainGuideTitle = "MAINUIGUIDE_TITLE_READING",
	},
	[29] = {
		ChildGuideId = {
			2901,
			2902,
		},
		GuideId = 29,
		MainGuideTitle = "MAINUIGUIDE_TITLE_IMPRESSIONSYSTEM",
	},
	[30] = {
		ChildGuideId = {
			3001,
			3002,
		},
		GuideId = 30,
		MainGuideTitle = "MAINUIGUIDE_TITLE_IMPRESSIONCHECK",
	},
	[31] = {
		ChildGuideId = {
			3101,
		},
		GuideId = 31,
		MainGuideTitle = "MAINUIGUIDE_TITLE_BIOGRAPHY",
	},
	[32] = {
		ChildGuideId = {
			3201,
			3202,
			3203,
			3204,
		},
		GuideId = 32,
		MainGuideTitle = "MAINUIGUIDE_TITLE_PHANTOM",
	},
	[33] = {
		ChildGuideId = {
			3301,
			3302,
			3303,
		},
		GuideId = 33,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TRAININGGROUND",
	},
	[34] = {
		ChildGuideId = {
			3401,
		},
		GuideId = 34,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TRAININGGROUND_2",
	},
	[35] = {
		ChildGuideId = {
			3501,
		},
		GuideId = 35,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ASSISTANCESKILL",
	},
	[36] = {
		ChildGuideId = {
			3601,
		},
		GuideId = 36,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SP",
	},
	[37] = {
		ChildGuideId = {
			3703,
			3701,
			3702,
		},
		GuideId = 37,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TRIGGEREFFECT",
	},
	[38] = {
		ChildGuideId = {
			3801,
		},
		GuideId = 38,
		MainGuideTitle = "MAINUIGUIDE_TITLE_BONUSDAMAGE",
	},
	[39] = {
		ChildGuideId = {
			3901,
		},
		GuideId = 39,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DOT",
	},
	[40] = {
		ChildGuideId = {
			4001,
		},
		GuideId = 40,
		MainGuideTitle = "MAINUIGUIDE_TITLE_FIREMECHANISM",
	},
	[41] = {
		ChildGuideId = {
			4101,
		},
		GuideId = 41,
		MainGuideTitle = "MAINUIGUIDE_TITLE_VALVEMECHANISM",
	},
	[42] = {
		ChildGuideId = {
			4201,
			4202,
		},
		GuideId = 42,
		MainGuideTitle = "MAINUIGUIDE_TITLE_EX01MECHANISM",
	},
	[43] = {
		ChildGuideId = {
			4301,
			4302,
			4303,
		},
		GuideId = 43,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TEMPLE",
	},
	[45] = {
		ChildGuideId = {
			4501,
			4502,
		},
		GuideId = 45,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TEAM",
	},
	[46] = {
		ChildGuideId = {
			4601,
			4602,
			4603,
		},
		GuideId = 46,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ONLINE_COMMISSION",
	},
	[47] = {
		ChildGuideId = {
			4701,
			4702,
		},
		GuideId = 47,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DYNSTORY",
	},
	[48] = {
		ChildGuideId = {
			4801,
			4802,
		},
		GuideId = 48,
		MainGuideTitle = "MAINUIGUIDE_TITLE_LAYEREDMAP",
	},
	[49] = {
		ChildGuideId = {
			4901,
			4902,
		},
		GuideId = 49,
		MainGuideTitle = "MAINUIGUIDE_TITLE_PET",
	},
	[50] = {
		ChildGuideId = {
			5001,
		},
		GuideId = 50,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SWITCHMASTER",
	},
	[51] = {
		ChildGuideId = {
			5101,
		},
		GuideId = 51,
		MainGuideTitle = "MAINUIGUIDE_TITLE_RELAYMECHANISM",
	},
	[52] = {
		ChildGuideId = {
			5201,
			5202,
		},
		GuideId = 52,
		MainGuideTitle = "MAINUIGUIDE_TITLE_FORT",
	},
	[53] = {
		ChildGuideId = {
			5301,
			5302,
		},
		GuideId = 53,
		MainGuideTitle = "MAINUIGUIDE_TITLE_MONSTEREXITMECHANISM",
	},
	[54] = {
		ChildGuideId = {
			2903,
			2904,
		},
		GuideId = 54,
		MainGuideTitle = "MAINUIGUIDE_TITLE_IMPRESSIONSHOP",
	},
	[55] = {
		ChildGuideId = {
			5501,
		},
		GuideId = 55,
		MainGuideTitle = "MAINUIGUIDE_TITLE_LONGPRESSEDSKILLS",
	},
	[56] = {
		ChildGuideId = {
			5601,
		},
		GuideId = 56,
		MainGuideTitle = "MAINUIGUIDE_TITLE_PERFECTDODGE",
	},
	[59] = {
		ChildGuideId = {
			4604,
			4605,
		},
		GuideId = 59,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ONLINE_SPECIALRULES",
	},
	[61] = {
		ChildGuideId = {
			4606,
		},
		GuideId = 61,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ONLINE_TEMPORARYTEAM",
	},
	[62] = {
		ChildGuideId = {
			5701,
		},
		GuideId = 62,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TASKACCEPTANCE",
	},
	[63] = {
		ChildGuideId = {
			5102,
		},
		GuideId = 63,
		MainGuideTitle = "MAINUIGUIDE_TITLE_LTRELAYMECHANISM",
	},
	[64] = {
		ChildGuideId = {
			5801,
		},
		GuideId = 64,
		MainGuideTitle = "MAINUIGUIDE_TITLE_EX01MAP",
	},
	[68] = {
		ChildGuideId = {
			502,
		},
		GuideId = 68,
		MainGuideTitle = "UIGuide_Title_OverloadShield",
	},
	[69] = {
		ChildGuideId = {
			6901,
			6902,
		},
		GuideId = 69,
		MainGuideTitle = "MAINUIGUIDE_TITLE_WIKI",
	},
	[70] = {
		ChildGuideId = {
			7001,
		},
		GuideId = 70,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SIDEWAYSJUMP",
	},
	[71] = {
		ChildGuideId = {
			7101,
			7102,
		},
		GuideId = 71,
		MainGuideTitle = "UIGuide_PetPan_Title",
	},
	[72] = {
		ChildGuideId = {
			7201,
			7202,
			7203,
			7204,
			7205,
		},
		GuideId = 72,
		MainGuideTitle = "UIGuide_Fish_Title",
	},
	[73] = {
		ChildGuideId = {
			7301,
			7302,
		},
		GuideId = 73,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SpecialSideStoryUI",
	},
	[74] = {
		ChildGuideId = {
			7401,
		},
		GuideId = 74,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DailyGoalUI",
	},
	[75] = {
		ChildGuideId = {
			7501,
		},
		GuideId = 75,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ModArchiveUI",
	},
	[76] = {
		ChildGuideId = {
			7601,
			7602,
			7603,
			7604,
			7605,
		},
		GuideId = 76,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ABYSS",
	},
	[77] = {
		ChildGuideId = {
			7701,
			7702,
		},
		GuideId = 77,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ROUGE",
	},
	[78] = {
		ChildGuideId = {
			7801,
			7802,
			7803,
			7804,
		},
		GuideId = 78,
		MainGuideTitle = "MAINUIGUIDE_TITLE_PETTRAIN",
	},
	[79] = {
		ChildGuideId = {
			7901,
			7902,
			7903,
		},
		GuideId = 79,
		MainGuideTitle = "UI_Dungeon_Tab_WalnutDungeon",
	},
	[80] = {
		ChildGuideId = {
			8001,
			8002,
			8003,
		},
		GuideId = 80,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ONLINEAREA",
	},
	[81] = {
		ChildGuideId = {
			8101,
		},
		GuideId = 81,
		MainGuideTitle = "MAINUIGUIDE_TITLE_HOOK",
	},
	[82] = {
		ChildGuideId = {
			8201,
			8202,
		},
		GuideId = 82,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Badge",
	},
	[83] = {
		ChildGuideId = {
			8301,
			8302,
		},
		GuideId = 83,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Treasure",
	},
	[84] = {
		ChildGuideId = {
			8401,
		},
		GuideId = 84,
		MainGuideTitle = "MAINUIGUIDE_TITLE_MirrorPuzzle",
	},
	[85] = {
		ChildGuideId = {
			8501,
			8502,
		},
		GuideId = 85,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TRIALRANK",
	},
	[86] = {
		ChildGuideId = {
			8601,
			8602,
		},
		GuideId = 86,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DEDUCE",
	},
	[87] = {
		ChildGuideId = {
			8701,
			8702,
		},
		GuideId = 87,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Saiqi_1",
	},
	[88] = {
		ChildGuideId = {
			8801,
			8802,
			8803,
		},
		GuideId = 88,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ONLINEAREA",
	},
	[89] = {
		ChildGuideId = {
			8901,
		},
		GuideId = 89,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TongLv_1",
	},
	[90] = {
		ChildGuideId = {
			9001,
			9002,
			9003,
			9004,
		},
		GuideId = 90,
		MainGuideTitle = "MAINUIGUIDE_TITLE_FangShu_1",
	},
	[91] = {
		ChildGuideId = {
			9101,
			9102,
		},
		GuideId = 91,
		MainGuideTitle = "MAINUIGUIDE_TITLE_FuWen_1",
	},
	[92] = {
		ChildGuideId = {
			9201,
			9202,
		},
		GuideId = 92,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ChenMo_1",
	},
	[93] = {
		ChildGuideId = {
			9301,
		},
		GuideId = 93,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ShanYe_1",
	},
	[94] = {
		ChildGuideId = {
			9401,
		},
		GuideId = 94,
		MainGuideTitle = "MAINUIGUIDE_TITLE_XiQiu_1",
	},
	[95] = {
		ChildGuideId = {
			9501,
			9502,
		},
		GuideId = 95,
		MainGuideTitle = "MAINUIGUIDE_TITLE_FanZhuan_1",
	},
	[96] = {
		ChildGuideId = {
			9601,
		},
		GuideId = 96,
		MainGuideTitle = "MAINUIGUIDE_TITLE_HuaBan_1",
	},
	[97] = {
		ChildGuideId = {
			9701,
			9702,
			9703,
		},
		GuideId = 97,
		MainGuideTitle = "MAINUIGUIDE_TITLE_WangXi_1",
	},
	[98] = {
		ChildGuideId = {
			9801,
		},
		GuideId = 98,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DengHua_1",
	},
	[99] = {
		ChildGuideId = {
			9901,
		},
		GuideId = 99,
		MainGuideTitle = "MAINUIGUIDE_TITLE_QiTianDeng_1",
	},
	[100] = {
		ChildGuideId = {
			10001,
		},
		GuideId = 100,
		MainGuideTitle = "MAINUIGUIDE_TITLE_XiaoChuan_1",
	},
	[101] = {
		ChildGuideId = {
			10101,
		},
		GuideId = 101,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ZhanFeng_1",
	},
	[102] = {
		ChildGuideId = {
			10201,
		},
		GuideId = 102,
		MainGuideTitle = "MAINUIGUIDE_TITLE_XingShi_1",
	},
	[103] = {
		ChildGuideId = {
			10301,
			10302,
			10303,
		},
		GuideId = 103,
		MainGuideTitle = "MAINUIGUIDE_TITLE_JiGuanZhen_1",
	},
	[104] = {
		ChildGuideId = {
			10401,
			10402,
		},
		GuideId = 104,
		MainGuideTitle = "MAINUIGUIDE_TITLE_YanShi_1",
	},
	[105] = {
		ChildGuideId = {
			10501,
			10502,
		},
		GuideId = 105,
		MainGuideTitle = "MAINUIGUIDE_TITLE_HuaBao_1",
	},
	[106] = {
		ChildGuideId = {
			10601,
			10602,
			10603,
			10604,
		},
		GuideId = 106,
		MainGuideTitle = "MAINUIGUIDE_TITLE_LongLin_1",
	},
	[107] = {
		ChildGuideId = {
			10701,
		},
		GuideId = 107,
		MainGuideTitle = "MAINUIGUIDE_TITLE_JiaSu_1",
	},
	[108] = {
		ChildGuideId = {
			10801,
			10802,
		},
		GuideId = 108,
		MainGuideTitle = "MAINUIGUIDE_TITLE_HuiYu_1",
	},
	[109] = {
		ChildGuideId = {
			10901,
			10902,
			10903,
		},
		GuideId = 109,
		MainGuideTitle = "MAINUIGUIDE_TITLE_HuaRui_1",
	},
	[110] = {
		ChildGuideId = {
			11001,
			11002,
			11003,
		},
		GuideId = 110,
		MainGuideTitle = "MAINUIGUIDE_TITLE_FenZuSai_1",
	},
	[111] = {
		ChildGuideId = {
			11101,
			11102,
			11103,
			11104,
		},
		GuideId = 111,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DianFeng_1",
	},
	[112] = {
		ChildGuideId = {
			11201,
		},
		GuideId = 112,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ZhouYe_1",
	},
	[113] = {
		ChildGuideId = {
			11301,
		},
		GuideId = 113,
		MainGuideTitle = "MAINUIGUIDE_TITLE_FangShu_4",
	},
	[114] = {
		ChildGuideId = {
			11401,
			11402,
			11403,
		},
		GuideId = 114,
		MainGuideTitle = "MAINUIGUIDE_TITLE_JuYuan_1",
	},
	[115] = {
		ChildGuideId = {
			11501,
			11502,
		},
		GuideId = 115,
		MainGuideTitle = "Mon_Guide_Title_115",
	},
	[116] = {
		ChildGuideId = {
			11601,
			11602,
			11603,
			11604,
			11605,
			11606,
			11607,
			11608,
		},
		GuideId = 116,
		MainGuideTitle = "MAINUIGUIDE_TITLE_JuYuan_1",
	},
	[117] = {
		ChildGuideId = {
			11701,
			11702,
			11703,
		},
		GuideId = 117,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ShengMing_1",
	},
	[118] = {
		ChildGuideId = {
			11801,
			11802,
			11803,
		},
		GuideId = 118,
		MainGuideTitle = "MAINUIGUIDE_TITLE_WuYou_1",
	},
	[119] = {
		ChildGuideId = {
			11901,
			11902,
			11903,
		},
		GuideId = 119,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ZuoQi_1",
	},
	[120] = {
		ChildGuideId = {
			12001,
		},
		GuideId = 120,
		MainGuideTitle = "UI_Title_Popup_RecordVedio",
	},
	[121] = {
		ChildGuideId = {
			12101,
			12102,
			12103,
			12104,
		},
		GuideId = 121,
		MainGuideTitle = "MAINUIGUIDE_TITLE_QiaoBan_1",
	},
	[122] = {
		ChildGuideId = {
			12201,
		},
		GuideId = 122,
		MainGuideTitle = "MAINUIGUIDE_TITLE_PinTu_1",
	},
	[123] = {
		ChildGuideId = {
			12301,
			12302,
		},
		GuideId = 123,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ShenJi_1",
	},
	[124] = {
		ChildGuideId = {
			12403,
			12401,
			12402,
			12404,
		},
		GuideId = 124,
		MainGuideTitle = "MAINUIGUIDE_TITLE_XiaoYao_1",
	},
	[125] = {
		ChildGuideId = {
			12501,
		},
		GuideId = 125,
		MainGuideTitle = "MAINUIGUIDE_TITLE_XuanYong_1",
	},
	[126] = {
		ChildGuideId = {
			12601,
			12602,
		},
		GuideId = 126,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ZhenLv_1",
	},
	[127] = {
		ChildGuideId = {
			12701,
			12702,
		},
		GuideId = 127,
		MainGuideTitle = "MAINUIGUIDE_TITLE_AnHao_1",
	},
	[128] = {
		ChildGuideId = {
			12801,
			12802,
		},
		GuideId = 128,
		MainGuideTitle = "MAINUIGUIDE_TITLE_YanQue_1",
	},
	[129] = {
		ChildGuideId = {
			12901,
			12902,
		},
		GuideId = 129,
		MainGuideTitle = "MAINUIGUIDE_TITLE_QueXie_1",
	},
	[130] = {
		ChildGuideId = {
			13001,
			13002,
		},
		GuideId = 130,
		MainGuideTitle = "MAINUIGUIDE_TITLE_QianKun_1",
	},
	[131] = {
		ChildGuideId = {
			13101,
			13102,
			13103,
			10104,
		},
		GuideId = 131,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ZhengLi_Main",
	},
	[132] = {
		ChildGuideId = {
			13201,
		},
		GuideId = 132,
		MainGuideTitle = "MAINUIGUIDE_TITLE_RongQi_1",
	},
	[133] = {
		ChildGuideId = {
			13301,
		},
		GuideId = 133,
		MainGuideTitle = "MAINUIGUIDE_TITLE_NiuDan_1",
	},
	[134] = {
		ChildGuideId = {
			13401,
		},
		GuideId = 134,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TianQi_1",
	},
	[135] = {
		ChildGuideId = {
			13501,
		},
		GuideId = 135,
		MainGuideTitle = "MAINUIGUIDE_TITLE_GongFeng_1",
	},
	[136] = {
		ChildGuideId = {
			13601,
			13602,
			13603,
		},
		GuideId = 136,
		MainGuideTitle = "MAINUIGUIDE_TITLE_MiShi_1",
	},
	[137] = {
		ChildGuideId = {
			13701,
		},
		GuideId = 137,
		MainGuideTitle = "MAINUIGUIDE_TITLE_XianJing_1",
	},
	[138] = {
		ChildGuideId = {
			13801,
			13802,
			13803,
		},
		GuideId = 138,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ShouHu_1",
	},
	[139] = {
		ChildGuideId = {
			13901,
		},
		GuideId = 139,
		MainGuideTitle = "MAINUIGUIDE_TITLE_JingYing_1",
	},
	[140] = {
		ChildGuideId = {
			14001,
		},
		GuideId = 140,
		MainGuideTitle = "MAINUIGUIDE_TITLE_JieSuan_1",
	},
	[141] = {
		ChildGuideId = {
			12403,
			12404,
		},
		GuideId = 141,
		MainGuideTitle = "MAINUIGUIDE_TITLE_XiaoYao_1",
	},
	[142] = {
		ChildGuideId = {
			12401,
			12402,
		},
		GuideId = 142,
		MainGuideTitle = "MAINUIGUIDE_TITLE_XiaoYao_1",
	},
	[143] = {
		ChildGuideId = {
			14301,
			14302,
		},
		GuideId = 143,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SuYi_1",
	},
	[144] = {
		ChildGuideId = {
			14401,
		},
		GuideId = 144,
		MainGuideTitle = "MAINUIGUIDE_TITLE_TeYao_1",
	},
	[145] = {
		ChildGuideId = {
			14501,
			14502,
			14503,
			14504,
			14505,
			14506,
		},
		GuideId = 145,
		MainGuideTitle = "MAINUIGUIDE_TITLE_YanQueFeiXing_1",
	},
	[146] = {
		ChildGuideId = {
			14601,
		},
		GuideId = 146,
		MainGuideTitle = "MAINUIGUIDE_TITLE_YinZong_1",
	},
	[147] = {
		ChildGuideId = {
			14701,
			14702,
			14703,
			14704,
			14705,
		},
		GuideId = 147,
		MainGuideTitle = "MAINUIGUIDE_TITLE_YuBo_1",
	},
	[1001] = {
		ChildGuideId = {
			100101,
			100102,
			100103,
			100104,
		},
		GuideId = 1001,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SurvivalMini",
	},
	[1002] = {
		ChildGuideId = {
			100201,
			100202,
			100203,
		},
		GuideId = 1002,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SurvivalMiniPro",
	},
	[1003] = {
		ChildGuideId = {
			100301,
			100302,
		},
		GuideId = 1003,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Defence",
	},
	[1004] = {
		ChildGuideId = {
			100401,
		},
		GuideId = 1004,
		MainGuideTitle = "MAINUIGUIDE_TITLE_DefenceMove",
	},
	[1005] = {
		ChildGuideId = {
			100501,
			100502,
			100503,
			100504,
		},
		GuideId = 1005,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Capture",
	},
	[1006] = {
		ChildGuideId = {
			100601,
			100602,
			100603,
			100604,
			100605,
			100606,
		},
		GuideId = 1006,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Excavation",
	},
	[1007] = {
		ChildGuideId = {
			100701,
			100702,
			100703,
			100704,
			100705,
		},
		GuideId = 1007,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Sabotage",
	},
	[1008] = {
		ChildGuideId = {
			100801,
			100802,
			100803,
			100804,
			100805,
		},
		GuideId = 1008,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Rescue",
	},
	[1009] = {
		ChildGuideId = {
			100901,
			100902,
			100903,
		},
		GuideId = 1009,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Hijack",
	},
	[1010] = {
		ChildGuideId = {
			101001,
			101002,
		},
		GuideId = 1010,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Exterminate",
	},
	[1011] = {
		ChildGuideId = {
			101101,
		},
		GuideId = 1011,
		MainGuideTitle = "MAINUIGUIDE_TITLE_ExtermPro",
	},
	[1012] = {
		ChildGuideId = {
			101201,
			101202,
		},
		GuideId = 1012,
		MainGuideTitle = "MAINUIGUIDE_TITLE_SabotagePro",
	},
	[1013] = {
		ChildGuideId = {
			101301,
			101302,
			101303,
			101304,
			101305,
			101306,
		},
		GuideId = 1013,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Synthesis",
	},
	[1014] = {
		ChildGuideId = {
			101401,
			101402,
			101403,
			101404,
			101405,
			101406,
		},
		GuideId = 1014,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Synthesis2",
	},
	[2001] = {
		ChildGuideId = {
			200101,
		},
		GuideId = 2001,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_1",
	},
	[2002] = {
		ChildGuideId = {
			200201,
		},
		GuideId = 2002,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_2",
	},
	[2003] = {
		ChildGuideId = {
			200301,
		},
		GuideId = 2003,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_3",
	},
	[2004] = {
		ChildGuideId = {
			200401,
		},
		GuideId = 2004,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_4",
	},
	[2005] = {
		ChildGuideId = {
			200501,
		},
		GuideId = 2005,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_5",
	},
	[2006] = {
		ChildGuideId = {
			200601,
		},
		GuideId = 2006,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_6",
	},
	[2007] = {
		ChildGuideId = {
			200701,
		},
		GuideId = 2007,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_7",
	},
	[2008] = {
		ChildGuideId = {
			200801,
		},
		GuideId = 2008,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_8",
	},
	[2009] = {
		ChildGuideId = {
			200901,
		},
		GuideId = 2009,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_9",
	},
	[2010] = {
		ChildGuideId = {
			201001,
		},
		GuideId = 2010,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_10",
	},
	[2011] = {
		ChildGuideId = {
			201101,
		},
		GuideId = 2011,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_11",
	},
	[2012] = {
		ChildGuideId = {
			201201,
		},
		GuideId = 2012,
		MainGuideTitle = "MAINUIGUIDE_TITLE_Feina_12",
	},
	[10011] = {
		ChildGuideId = {
			1001101,
		},
		GuideId = 10011,
		MainGuideTitle = "Mon_Guide_Title_Strong_Frozen",
	},
	[10012] = {
		ChildGuideId = {
			1001201,
		},
		GuideId = 10012,
		MainGuideTitle = "Mon_Guide_Title_Strong_Burst",
	},
	[10013] = {
		ChildGuideId = {
			1001301,
		},
		GuideId = 10013,
		MainGuideTitle = "Mon_Guide_Title_Strong_Poison",
	},
	[10014] = {
		ChildGuideId = {
			1001401,
		},
		GuideId = 10014,
		MainGuideTitle = "Mon_Guide_Title_Strong_Thunder",
	},
	[10015] = {
		ChildGuideId = {
			1001501,
			1001502,
		},
		GuideId = 10015,
		MainGuideTitle = "Mon_Guide_Title_Strong_Blood",
	},
	[10016] = {
		ChildGuideId = {
			1001601,
		},
		GuideId = 10016,
		MainGuideTitle = "Mon_Guide_Title_Strong_Fade",
	},
	[10017] = {
		ChildGuideId = {
			1001701,
		},
		GuideId = 10017,
		MainGuideTitle = "Mon_Guide_Title_Strong_Shield",
	},
	[10018] = {
		ChildGuideId = {
			1001801,
		},
		GuideId = 10018,
		MainGuideTitle = "Mon_Guide_Title_Strong_Revenge",
	},
	[10019] = {
		ChildGuideId = {
			1001901,
		},
		GuideId = 10019,
		MainGuideTitle = "Mon_Guide_Title_Strong_IceOrb",
	},
	[10020] = {
		ChildGuideId = {
			1002001,
		},
		GuideId = 10020,
		MainGuideTitle = "Mon_Guide_Title_Strong_Reflect",
	},
	[10021] = {
		ChildGuideId = {
			1002101,
		},
		GuideId = 10021,
		MainGuideTitle = "Mon_Guide_Title_Strong_Kamikaze",
	},
	[10022] = {
		ChildGuideId = {
			1002201,
		},
		GuideId = 10022,
		MainGuideTitle = "Mon_Guide_Title_Strong_ThunderLaser",
	},
	[10023] = {
		ChildGuideId = {
			1002301,
		},
		GuideId = 10023,
		MainGuideTitle = "Mon_Guide_Title_Strong_Vampire",
	},
	[10024] = {
		ChildGuideId = {
			1002401,
		},
		GuideId = 10024,
		MainGuideTitle = "Mon_Guide_Title_Strong_Threefold",
	},
	[10100] = {
		ChildGuideId = {
			1010001,
		},
		GuideId = 10100,
		MainGuideTitle = "Mon_Guide_Title_Strong_Multiple",
	},
	[20301] = {
		ChildGuideId = {
			203001,
		},
		GuideId = 20301,
		MainGuideTitle = "UIGuide_Title_203001",
	},
	[20351] = {
		ChildGuideId = {
			203501,
		},
		GuideId = 20351,
		MainGuideTitle = "UIGuide_Title_203501",
	},
	[20361] = {
		ChildGuideId = {
			203601,
		},
		GuideId = 20361,
		MainGuideTitle = "UIGuide_Title_203601",
	},
	[6006001] = {
		ChildGuideId = {
			600600101,
		},
		GuideId = 6006001,
		MainGuideTitle = "Mon_Guide_Title_6006001",
	},
	[6007001] = {
		ChildGuideId = {
			600700101,
		},
		GuideId = 6007001,
		MainGuideTitle = "Mon_Guide_Title_6007001",
	},
	[6015001] = {
		ChildGuideId = {
			601500101,
		},
		GuideId = 6015001,
		MainGuideTitle = "Mon_Guide_Title_6015001",
	},
	[7001005] = {
		ChildGuideId = {
			700100501,
			700100502,
		},
		GuideId = 7001005,
		MainGuideTitle = "Mon_Guide_Title_7001005",
	},
	[7002005] = {
		ChildGuideId = {
			700200501,
			700200502,
			700200503,
		},
		GuideId = 7002005,
		MainGuideTitle = "Mon_Guide_Title_7002005",
	},
	[7003005] = {
		ChildGuideId = {
			700300501,
			700300502,
		},
		GuideId = 7003005,
		MainGuideTitle = "Mon_Guide_Title_7003005",
	},
	[7007002] = {
		ChildGuideId = {
			700700201,
		},
		GuideId = 7007002,
		MainGuideTitle = "Mon_Guide_Title_7007002",
	},
	[7008001] = {
		ChildGuideId = {
			700800101,
			700800102,
			700800103,
		},
		GuideId = 7008001,
		MainGuideTitle = "Mon_Guide_Title_7008001",
	},
	[7015001] = {
		ChildGuideId = {
			701500101,
		},
		GuideId = 7015001,
		MainGuideTitle = "Mon_Guide_Title_7015001",
	},
	[8501002] = {
		ChildGuideId = {
			850100201,
		},
		GuideId = 8501002,
		MainGuideTitle = "Mon_Guide_Title_8501002",
	},
	[8515001] = {
		ChildGuideId = {
			851500101,
		},
		GuideId = 8515001,
		MainGuideTitle = "Mon_Guide_Title_8515001",
	},
	[9003004] = {
		ChildGuideId = {
			900300401,
		},
		GuideId = 9003004,
		MainGuideTitle = "Mon_Guide_Title_9003004",
	},
	[9005004] = {
		ChildGuideId = {
			900500401,
		},
		GuideId = 9005004,
		MainGuideTitle = "Mon_Guide_Title_9005004",
	},
	[9006004] = {
		ChildGuideId = {
			900600401,
		},
		GuideId = 9006004,
		MainGuideTitle = "Mon_Guide_Title_9006004",
	},
	[9500001] = {
		ChildGuideId = {
			950000101,
		},
		GuideId = 9500001,
		MainGuideTitle = "Mon_Guide_Title_9500001",
	},
})