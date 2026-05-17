-- Source Excel file path: ..\datas\QuestSetVariable.xlsx
local T = {}
T.RT_1 = {
		Name = "IQ1002",
		Value = 1,
	}
T.RT_2 = {
		[1] = T.RT_1,
	}
T.RT_3 = {
		Name = "AltStart",
		Value = 1,
	}
T.RT_4 = {
		[1] = T.RT_3,
	}
T.RT_5 = {
		Name = "FengxiangBoss",
		Value = 1,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("QuestSetVariable", {
	[10020101] = {
		Start = {
			Info = T.RT_2,
			QuestId = 10020101,
			QuestStartorSuccess = "Start",
		},
		Success = {
			Info = T.RT_2,
			QuestId = 10020101,
			QuestStartorSuccess = "Success",
		},
	},
	[10030101] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ1003",
					Value = 1,
				},
			},
			QuestId = 10030101,
			QuestStartorSuccess = "Start",
		},
	},
	[10030301] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ100303",
					Value = 1,
				},
			},
			QuestId = 10030301,
			QuestStartorSuccess = "Start",
		},
	},
	[10030395] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ1002",
					Value = 0,
				},
			},
			QuestId = 10030395,
			QuestStartorSuccess = "Success",
		},
	},
	[10030401] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ100304",
					Value = 0,
				},
			},
			QuestId = 10030401,
			QuestStartorSuccess = "Start",
		},
	},
	[10030498] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ10030498",
					Value = 1,
				},
			},
			QuestId = 10030498,
			QuestStartorSuccess = "Start",
		},
	},
	[10030499] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ100304",
					Value = 1,
				},
				[2] = {
					Name = "IQ10030498",
					Value = 0,
				},
			},
			QuestId = 10030499,
			QuestStartorSuccess = "Start",
		},
	},
	[10030510] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ100306",
					Value = 1,
				},
			},
			QuestId = 10030510,
			QuestStartorSuccess = "Start",
		},
	},
	[10030512] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ10030601",
					Value = 1,
				},
				[2] = {
					Name = "IQ100306",
					Value = 0,
				},
			},
			QuestId = 10030512,
			QuestStartorSuccess = "Success",
		},
	},
	[10030601] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ10030601",
					Value = 0,
				},
			},
			QuestId = 10030601,
			QuestStartorSuccess = "Success",
		},
	},
	[11010104] = {
		Success = {
			Info = {
				[1] = {
					Name = "LinshiNPC110101",
					Value = 1,
				},
			},
			QuestId = 11010104,
			QuestStartorSuccess = "Success",
		},
	},
	[11010306] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ110103",
					Value = 1,
				},
			},
			QuestId = 11010306,
			QuestStartorSuccess = "Success",
		},
	},
	[11010308] = {
		Success = {
			Info = {
				[1] = {
					Name = "LinshiNPC110101",
					Value = 0,
				},
			},
			QuestId = 11010308,
			QuestStartorSuccess = "Success",
		},
	},
	[11010501] = {
		Start = {
			Info = {
				[1] = {
					Name = "XimengNPC110105",
					Value = 1,
				},
			},
			QuestId = 11010501,
			QuestStartorSuccess = "Start",
		},
	},
	[11010512] = {
		Start = {
			Info = {
				[1] = {
					Name = "NengYuanNPC110105",
					Value = 0,
				},
			},
			QuestId = 11010512,
			QuestStartorSuccess = "Start",
		},
	},
	[11010515] = {
		Start = {
			Info = {
				[1] = {
					Name = "ShenWenNPC110105",
					Value = 1,
				},
			},
			QuestId = 11010515,
			QuestStartorSuccess = "Start",
		},
	},
	[11010516] = {
		Success = {
			Info = {
				[1] = {
					Name = "ShenWenNPC110105",
					Value = 0,
				},
			},
			QuestId = 11010516,
			QuestStartorSuccess = "Success",
		},
	},
	[11010526] = {
		Success = {
			Info = {
				[1] = {
					Name = "NengYuanNPC110105",
					Value = 1,
				},
			},
			QuestId = 11010526,
			QuestStartorSuccess = "Success",
		},
	},
	[11010704] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ110107",
					Value = 1,
				},
			},
			QuestId = 11010704,
			QuestStartorSuccess = "Success",
		},
	},
	[11010706] = {
		Success = {
			Info = {
				[1] = {
					Name = "NPC110108",
					Value = 1,
				},
			},
			QuestId = 11010706,
			QuestStartorSuccess = "Success",
		},
	},
	[11010804] = {
		Success = {
			Info = {
				[1] = {
					Name = "NPC110108",
					Value = 0,
				},
			},
			QuestId = 11010804,
			QuestStartorSuccess = "Success",
		},
	},
	[11010816] = {
		Success = {
			Info = {
				[1] = {
					Name = "XimengNPC110105",
					Value = 0,
				},
			},
			QuestId = 11010816,
			QuestStartorSuccess = "Success",
		},
	},
	[12010307] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12010307",
					Value = 1,
				},
			},
			QuestId = 12010307,
			QuestStartorSuccess = "Start",
		},
	},
	[12010313] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12010313",
					Value = 1,
				},
			},
			QuestId = 12010313,
			QuestStartorSuccess = "Start",
		},
	},
	[12010315] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12010313",
					Value = 0,
				},
			},
			QuestId = 12010315,
			QuestStartorSuccess = "Start",
		},
	},
	[12010322] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12010307",
					Value = 0,
				},
			},
			QuestId = 12010322,
			QuestStartorSuccess = "Start",
		},
	},
	[12010502] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12010502",
					Value = 1,
				},
			},
			QuestId = 12010502,
			QuestStartorSuccess = "Start",
		},
	},
	[12010513] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12010513_fu",
					Value = 1,
				},
			},
			QuestId = 12010513,
			QuestStartorSuccess = "Start",
		},
	},
	[12010516] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12010513_fu",
					Value = 0,
				},
			},
			QuestId = 12010516,
			QuestStartorSuccess = "Start",
		},
	},
	[12010519] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ12010502",
					Value = 0,
				},
			},
			QuestId = 12010519,
			QuestStartorSuccess = "Success",
		},
	},
	[12010602] = {
		Success = {
			Info = T.RT_4,
			QuestId = 12010602,
			QuestStartorSuccess = "Success",
		},
	},
	[12010603] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12010513",
					Value = 1,
				},
			},
			QuestId = 12010603,
			QuestStartorSuccess = "Start",
		},
	},
	[12010604] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12010513",
					Value = 0,
				},
			},
			QuestId = 12010604,
			QuestStartorSuccess = "Start",
		},
	},
	[12010606] = {
		Start = {
			Info = {
				[1] = {
					Name = "AltStart",
					Value = 0,
				},
			},
			QuestId = 12010606,
			QuestStartorSuccess = "Start",
		},
		Success = {
			Info = T.RT_4,
			QuestId = 12010606,
			QuestStartorSuccess = "Success",
		},
	},
	[12020101] = {
		Start = {
			Info = {
				[1] = {
					Name = "Wuyousheng_First_12020122",
					Value = 1,
				},
				[2] = {
					Name = "IQ120315",
					Value = 0,
				},
				[3] = T.RT_5,
			},
			QuestId = 12020101,
			QuestStartorSuccess = "Start",
		},
	},
	[12020112] = {
		Success = {
			Info = {
				[1] = {
					Name = "Wuyousheng_First_12020122",
					Value = 0,
				},
			},
			QuestId = 12020112,
			QuestStartorSuccess = "Success",
		},
	},
	[12020205] = {
		Start = {
			Info = {
				[1] = {
					Name = "Qianxing12020208",
					Value = 1,
				},
			},
			QuestId = 12020205,
			QuestStartorSuccess = "Start",
		},
	},
	[12020210] = {
		Start = {
			Info = {
				[1] = {
					Name = "Qianxing12020208",
					Value = 0,
				},
				[2] = {
					Name = "Int12020208",
					Value = 1,
				},
			},
			QuestId = 12020210,
			QuestStartorSuccess = "Start",
		},
	},
	[12020211] = {
		Start = {
			Info = {
				[1] = {
					Name = "Wuyousheng_Escape_12020212",
					Value = 1,
				},
			},
			QuestId = 12020211,
			QuestStartorSuccess = "Start",
		},
	},
	[12020212] = {
		Success = {
			Info = {
				[1] = {
					Name = "Wuyousheng_Escape_12020212",
					Value = 0,
				},
			},
			QuestId = 12020212,
			QuestStartorSuccess = "Success",
		},
	},
	[12020401] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12020401",
					Value = 1,
				},
			},
			QuestId = 12020401,
			QuestStartorSuccess = "Start",
		},
	},
	[12020411] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ12020401",
					Value = 0,
				},
			},
			QuestId = 12020411,
			QuestStartorSuccess = "Success",
		},
	},
	[12020513] = {
		Start = {
			Info = {
				[1] = {
					Name = "Special_Zhiliu_12020515",
					Value = 1,
				},
			},
			QuestId = 12020513,
			QuestStartorSuccess = "Start",
		},
	},
	[12020516] = {
		Start = {
			Info = {
				[1] = {
					Name = "Special_Zhiliu_12020515",
					Value = 0,
				},
			},
			QuestId = 12020516,
			QuestStartorSuccess = "Start",
		},
	},
	[12020517] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ12020517",
					Value = 1,
				},
			},
			QuestId = 12020517,
			QuestStartorSuccess = "Success",
		},
	},
	[12020623] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ12020517",
					Value = 0,
				},
			},
			QuestId = 12020623,
			QuestStartorSuccess = "Success",
		},
	},
	[12030101] = {
		Start = {
			Info = {
				[1] = {
					Name = "FengxiangBaoming",
					Value = 1,
				},
				[2] = T.RT_5,
			},
			QuestId = 12030101,
			QuestStartorSuccess = "Start",
		},
	},
	[12030202] = {
		Success = {
			Info = {
				[1] = {
					Name = "FengxiangXiaochi",
					Value = 1,
				},
			},
			QuestId = 12030202,
			QuestStartorSuccess = "Success",
		},
	},
	[12030706] = {
		Start = {
			Info = {
				[1] = {
					Name = "IQ12030706_jlc",
					Value = 1,
				},
			},
			QuestId = 12030706,
			QuestStartorSuccess = "Start",
		},
		Success = {
			Info = {
				[1] = {
					Name = "IQ12030706",
					Value = 1,
				},
			},
			QuestId = 12030706,
			QuestStartorSuccess = "Success",
		},
	},
	[12030707] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ12030706_jlc",
					Value = 0,
				},
			},
			QuestId = 12030707,
			QuestStartorSuccess = "Success",
		},
	},
	[12030801] = {
		Success = {
			Info = {
				[1] = {
					Name = "FengxiangXiaochi",
					Value = 0,
				},
				[2] = {
					Name = "FengxiangBaoming",
					Value = 0,
				},
				[3] = {
					Name = "IQ12030706",
					Value = 0,
				},
			},
			QuestId = 12030801,
			QuestStartorSuccess = "Success",
		},
	},
	[20030303] = {
		Success = {
			Info = {
				[1] = {
					Name = "DaFengBaoXiang200303",
					Value = 1,
				},
			},
			QuestId = 20030303,
			QuestStartorSuccess = "Success",
		},
	},
	[20030304] = {
		Success = {
			Info = {
				[1] = {
					Name = "DaFengBaoXiang200303",
					Value = 0,
				},
			},
			QuestId = 20030304,
			QuestStartorSuccess = "Success",
		},
	},
	[20031505] = {
		Success = {
			Info = {
				[1] = {
					Name = "IQ120315",
					Value = 1,
				},
			},
			QuestId = 20031505,
			QuestStartorSuccess = "Success",
		},
	},
})