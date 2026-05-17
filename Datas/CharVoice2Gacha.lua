local T = {}
T.RT_1 = {
	[1] = "vo_gain",
}
T.RT_2 = {
	[1] = "vo_gain_1",
}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CharVoice2Gacha", {
	[1101] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10001,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Heitao_vo_gain",
				},
			},
		},
	},
	[1103] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10659,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Tuosi_vo_gain",
				},
			},
		},
	},
	[1501] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10884,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Baonu_vo_gain",
				},
			},
		},
	},
	[1502] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10565,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Nifu_vo_gain",
				},
			},
		},
	},
	[1503] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10763,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Kezhou_vo_gain",
				},
			},
		},
	},
	[1504] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10961,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Suyi_vo_gain",
				},
			},
		},
	},
	[1801] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10452,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Feina_vo_gain",
				},
			},
		},
	},
	[2101] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10041,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Shuimu_vo_gain",
				},
			},
		},
	},
	[2301] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10078,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Zhangyu_vo_gain",
				},
			},
		},
	},
	[2401] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10263,
				["VoiceRes"] = T.RT_2,
				["VoiceText"] = {
					[1] = "voice_ch_char_Baiheng_vo_gain_1",
				},
			},
		},
	},
	[3101] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10113,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Linen_vo_gain",
				},
			},
		},
	},
	[3102] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10145,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Xier_vo_gain",
				},
			},
		},
	},
	[3103] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10490,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Yeer_vo_gain",
				},
			},
		},
	},
	[3201] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10527,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Haier_vo_gain",
				},
			},
		},
	},
	[3202] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10919,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Kami_vo_gain",
				},
			},
		},
	},
	[3301] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10409,
				["VoiceRes"] = T.RT_2,
				["VoiceText"] = {
					[1] = "voice_ch_char_Maer_vo_gain_1",
				},
			},
		},
		[2] = {
			[1] = {
				["GachaVoiceCondition"] = {
					[1] = 6007,
				},
				["VoiceId"] = 10410,
				["VoiceRes"] = {
					[1] = "vo_gain_2",
				},
				["VoiceText"] = {
					[1] = "voice_ch_char_Maer_vo_gain_2",
				},
			},
		},
	},
	[4101] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10614,
				["VoiceRes"] = {
					[1] = "vo_gain_01",
				},
				["VoiceText"] = {
					[1] = "voice_ch_char_Lise_vo_gain_01",
				},
			},
		},
		[2] = {
			[1] = {
				["GachaVoiceCondition"] = {
					[1] = 100307,
				},
				["VoiceId"] = 10615,
				["VoiceRes"] = {
					[1] = "vo_gain_02",
				},
				["VoiceText"] = {
					[1] = "voice_ch_char_Lise_vo_gain_02",
				},
			},
		},
	},
	[4102] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10844,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Zhiliu_vo_gain",
				},
			},
		},
	},
	[4201] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10186,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Yuming_vo_gain",
				},
			},
		},
	},
	[4202] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10341,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Landi_vo_gain",
				},
			},
		},
	},
	[4301] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10373,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Xibi_vo_gain",
				},
			},
		},
	},
	[5101] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10302,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Songlu_vo_gain",
				},
			},
		},
	},
	[5102] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10803,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Aote_vo_gain",
				},
			},
		},
	},
	[5301] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10220,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Saiqi_vo_gain",
				},
			},
		},
	},
	[5401] = {
		[1] = {
			[1] = {
				["VoiceId"] = 10714,
				["VoiceRes"] = T.RT_1,
				["VoiceText"] = {
					[1] = "voice_ch_char_Dafu_vo_gain",
				},
			},
		},
	},
})