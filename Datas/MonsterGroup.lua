-- Source Excel file path: ..\datas\MonsterSpawn\MonsterGroup.xlsx
local T = {}
T.RT_1 = {
		UnitId = 7002001,
		UnitProb = 1,
	}
T.RT_2 = {
		UnitId = 7004001,
		UnitProb = 0.3,
	}
T.RT_3 = {
		UnitId = 7001001,
		UnitProb = 1,
	}
T.RT_4 = {
		UnitId = 7003001,
		UnitProb = 1,
	}
T.RT_5 = {
		UnitId = 6001001,
		UnitProb = 1,
	}
T.RT_6 = {
		UnitId = 6004001,
		UnitProb = 0.3,
	}
T.RT_7 = {
		UnitId = 6002001,
		UnitProb = 1,
	}
T.RT_8 = {
		UnitId = 6003001,
		UnitProb = 1,
	}
T.RT_9 = {
		UnitId = 6011001,
		UnitProb = 1,
	}
T.RT_10 = {
		UnitId = 6011001,
		UnitProb = 0.5,
	}
T.RT_11 = {
		UnitId = 6017001,
		UnitProb = 1,
	}
T.RT_12 = {
		UnitId = 6012001,
		UnitProb = 1,
	}
T.RT_13 = {
		UnitId = 6003001,
		UnitProb = 0.5,
	}
T.RT_14 = {
		UnitId = 6013001,
		UnitProb = 0.5,
	}
T.RT_15 = {
		UnitId = 6016001,
		UnitProb = 1,
	}
T.RT_16 = {
		UnitId = 6015001,
		UnitProb = 0.2,
	}
T.RT_17 = {
		UnitId = 6014001,
		UnitProb = 1,
	}
T.RT_18 = {
		UnitId = 6002601,
		UnitProb = 1,
	}
T.RT_19 = {
		UnitId = 6012601,
		UnitProb = 1,
	}
T.RT_20 = {
		UnitId = 6003601,
		UnitProb = 0.5,
	}
T.RT_21 = {
		UnitId = 6014601,
		UnitProb = 1,
	}
T.RT_22 = {
		UnitId = 6011601,
		UnitProb = 1,
	}
T.RT_23 = {
		UnitId = 6013601,
		UnitProb = 1,
	}
T.RT_24 = {
		UnitId = 7012001,
		UnitProb = 1,
	}
T.RT_25 = {
		UnitId = 7009001,
		UnitProb = 1,
	}
T.RT_26 = {
		UnitId = 7015001,
		UnitProb = 1,
	}
T.RT_27 = {
		UnitId = 7004001,
		UnitProb = 0.5,
	}
T.RT_28 = {
		UnitId = 7014001,
		UnitProb = 0.3,
	}
T.RT_29 = {
		UnitId = 7011001,
		UnitProb = 1,
	}
T.RT_30 = {
		UnitId = 7013001,
		UnitProb = 1,
	}
T.RT_31 = {
		UnitId = 7015001,
		UnitProb = 0.2,
	}
T.RT_32 = {
		UnitId = 7010001,
		UnitProb = 1,
	}
T.RT_33 = {
		UnitId = 7012601,
		UnitProb = 1,
	}
T.RT_34 = {
		UnitId = 7002601,
		UnitProb = 1,
	}
T.RT_35 = {
		UnitId = 7012601,
		UnitProb = 0.5,
	}
T.RT_36 = {
		UnitId = 7004601,
		UnitProb = 0.5,
	}
T.RT_37 = {
		[1] = T.RT_33,
		[2] = T.RT_34,
		[3] = T.RT_34,
		[4] = T.RT_35,
		[5] = T.RT_36,
	}
T.RT_38 = {
		UnitId = 7001601,
		UnitProb = 1,
	}
T.RT_39 = {
		UnitId = 7011601,
		UnitProb = 0.5,
	}
T.RT_40 = {
		UnitId = 8002001,
		UnitProb = 1,
	}
T.RT_41 = {
		UnitId = 8001001,
		UnitProb = 1,
	}
T.RT_42 = {
		UnitId = 8003001,
		UnitProb = 1,
	}
T.RT_43 = {
		UnitId = 8002601,
		UnitProb = 1,
	}
T.RT_44 = {
		UnitId = 8001601,
		UnitProb = 1,
	}
T.RT_45 = {
		UnitId = 8003601,
		UnitProb = 1,
	}
T.RT_46 = {
		UnitId = 9001001,
		UnitProb = 1,
	}
T.RT_47 = {
		UnitId = 9002001,
		UnitProb = 1,
	}
T.RT_48 = {
		UnitId = 9007001,
		UnitProb = 1,
	}
T.RT_49 = {
		UnitId = 9001601,
		UnitProb = 1,
	}
T.RT_50 = {
		UnitId = 9002601,
		UnitProb = 1,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MonsterGroup", {
	[11] = {
		GroupId = 11,
		MemberSpawnProb = {
			[1] = T.RT_1,
			[2] = T.RT_1,
			[3] = T.RT_2,
		},
	},
	[12] = {
		GroupId = 12,
		MemberSpawnProb = {
			[1] = T.RT_3,
			[2] = T.RT_4,
		},
	},
	[13] = {
		GroupId = 13,
		MemberSpawnProb = {
			[1] = T.RT_5,
			[2] = T.RT_5,
			[3] = T.RT_6,
		},
	},
	[14] = {
		GroupId = 14,
		MemberSpawnProb = {
			[1] = T.RT_7,
			[2] = T.RT_8,
		},
	},
	[6010] = {
		GroupId = 6010,
		MemberSpawnProb = {
			[1] = T.RT_5,
			[2] = T.RT_5,
			[3] = T.RT_9,
			[4] = {
				UnitId = 6001001,
				UnitProb = 0.5,
			},
			[5] = T.RT_10,
		},
	},
	[6011] = {
		GroupId = 6011,
		MemberSpawnProb = {
			[1] = T.RT_5,
			[2] = T.RT_9,
			[3] = T.RT_6,
			[4] = {
				UnitId = 6014001,
				UnitProb = 0.2,
			},
		},
	},
	[6012] = {
		GroupId = 6012,
		MemberSpawnProb = {
			[1] = T.RT_5,
			[2] = T.RT_9,
			[3] = T.RT_11,
			[4] = {
				UnitId = 6004001,
				UnitProb = 0.2,
			},
			[5] = {
				UnitId = 6014001,
				UnitProb = 0.3,
			},
		},
	},
	[6020] = {
		GroupId = 6020,
		MemberSpawnProb = {
			[1] = T.RT_7,
			[2] = T.RT_7,
			[3] = T.RT_12,
			[4] = {
				UnitId = 6002001,
				UnitProb = 0.5,
			},
			[5] = {
				UnitId = 6012001,
				UnitProb = 0.5,
			},
		},
	},
	[6021] = {
		GroupId = 6021,
		MemberSpawnProb = {
			[1] = T.RT_7,
			[2] = T.RT_12,
			[3] = T.RT_13,
			[4] = T.RT_14,
		},
	},
	[6022] = {
		GroupId = 6022,
		MemberSpawnProb = {
			[1] = T.RT_7,
			[2] = T.RT_12,
			[3] = T.RT_15,
			[4] = {
				UnitId = 6007001,
				UnitProb = 0.2,
			},
			[5] = T.RT_16,
		},
	},
	[6023] = {
		GroupId = 6023,
		MemberSpawnProb = {
			[1] = T.RT_8,
			[2] = {
				UnitId = 6013001,
				UnitProb = 1,
			},
		},
	},
	[6030] = {
		GroupId = 6030,
		MemberSpawnProb = {
			[1] = T.RT_5,
			[2] = T.RT_7,
			[3] = T.RT_10,
			[4] = {
				UnitId = 6007001,
				UnitProb = 0.5,
			},
		},
	},
	[6040] = {
		GroupId = 6040,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6004001,
				UnitProb = 1,
			},
			[2] = T.RT_5,
			[3] = T.RT_7,
			[4] = T.RT_7,
			[5] = T.RT_13,
		},
	},
	[6041] = {
		GroupId = 6041,
		MemberSpawnProb = {
			[1] = T.RT_17,
			[2] = T.RT_9,
			[3] = T.RT_7,
			[4] = T.RT_12,
			[5] = T.RT_14,
		},
	},
	[6042] = {
		GroupId = 6042,
		MemberSpawnProb = {
			[1] = T.RT_17,
			[2] = T.RT_9,
			[3] = T.RT_12,
			[4] = T.RT_8,
			[5] = T.RT_14,
		},
	},
	[6043] = {
		GroupId = 6043,
		MemberSpawnProb = {
			[1] = T.RT_17,
			[2] = T.RT_15,
			[3] = T.RT_15,
			[4] = T.RT_11,
			[5] = T.RT_11,
			[6] = T.RT_16,
		},
	},
	[6050] = {
		GroupId = 6050,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6004601,
				UnitProb = 1,
			},
			[2] = {
				UnitId = 6001601,
				UnitProb = 1,
			},
			[3] = T.RT_18,
			[4] = T.RT_18,
			[5] = T.RT_19,
			[6] = T.RT_20,
		},
	},
	[6051] = {
		GroupId = 6051,
		MemberSpawnProb = {
			[1] = T.RT_21,
			[2] = T.RT_22,
			[3] = T.RT_18,
			[4] = T.RT_19,
			[5] = T.RT_23,
			[6] = T.RT_20,
		},
	},
	[6052] = {
		GroupId = 6052,
		MemberSpawnProb = {
			[1] = T.RT_21,
			[2] = T.RT_22,
			[3] = T.RT_19,
			[4] = T.RT_23,
			[5] = T.RT_23,
			[6] = T.RT_20,
		},
	},
	[7010] = {
		GroupId = 7010,
		MemberSpawnProb = {
			[1] = T.RT_1,
			[2] = T.RT_1,
			[3] = T.RT_24,
			[4] = T.RT_1,
			[5] = T.RT_2,
		},
	},
	[7011] = {
		GroupId = 7011,
		MemberSpawnProb = {
			[1] = T.RT_25,
			[2] = T.RT_26,
			[3] = T.RT_1,
			[4] = {
				UnitId = 7012001,
				UnitProb = 0.5,
			},
			[5] = T.RT_27,
		},
	},
	[7012] = {
		GroupId = 7012,
		MemberSpawnProb = {
			[1] = T.RT_1,
			[2] = T.RT_24,
			[3] = T.RT_2,
			[4] = T.RT_28,
			[5] = {
				UnitId = 7009001,
				UnitProb = 0.3,
			},
		},
	},
	[7020] = {
		GroupId = 7020,
		MemberSpawnProb = {
			[1] = T.RT_3,
			[2] = T.RT_4,
			[3] = T.RT_29,
			[4] = T.RT_30,
			[5] = T.RT_28,
		},
	},
	[7021] = {
		GroupId = 7021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7008001,
				UnitProb = 1,
			},
			[2] = T.RT_26,
			[3] = {
				UnitId = 7001001,
				UnitProb = 0.5,
			},
			[4] = {
				UnitId = 7011001,
				UnitProb = 0.5,
			},
			[5] = {
				UnitId = 7003001,
				UnitProb = 0.5,
			},
		},
	},
	[7022] = {
		GroupId = 7022,
		MemberSpawnProb = {
			[1] = T.RT_1,
			[2] = T.RT_3,
			[3] = T.RT_1,
			[4] = T.RT_4,
			[5] = {
				UnitId = 7010001,
				UnitProb = 0.5,
			},
			[6] = T.RT_31,
		},
	},
	[7023] = {
		GroupId = 7023,
		MemberSpawnProb = {
			[1] = T.RT_3,
			[2] = T.RT_29,
			[3] = T.RT_4,
			[4] = T.RT_30,
			[5] = T.RT_31,
		},
	},
	[7024] = {
		GroupId = 7024,
		MemberSpawnProb = {
			[1] = T.RT_32,
		},
	},
	[7040] = {
		GroupId = 7040,
		MemberSpawnProb = {
			[1] = T.RT_1,
			[2] = T.RT_24,
			[3] = T.RT_3,
			[4] = T.RT_4,
			[5] = T.RT_27,
		},
	},
	[7041] = {
		GroupId = 7041,
		MemberSpawnProb = {
			[1] = T.RT_24,
			[2] = T.RT_24,
			[3] = T.RT_29,
			[4] = T.RT_30,
			[5] = {
				UnitId = 7014001,
				UnitProb = 0.5,
			},
		},
	},
	[7042] = {
		GroupId = 7042,
		MemberSpawnProb = {
			[1] = T.RT_25,
			[2] = T.RT_24,
			[3] = T.RT_29,
			[4] = T.RT_30,
		},
	},
	[7044] = {
		GroupId = 7044,
		MemberSpawnProb = {
			[1] = T.RT_32,
			[2] = T.RT_24,
			[3] = {
				UnitId = 7014001,
				UnitProb = 1,
			},
			[4] = T.RT_29,
			[5] = T.RT_26,
		},
	},
	[7050] = {
		GroupId = 7050,
		MemberSpawnProb = T.RT_37,
	},
	[7051] = {
		GroupId = 7051,
		MemberSpawnProb = T.RT_37,
	},
	[7052] = {
		GroupId = 7052,
		MemberSpawnProb = {
			[1] = T.RT_38,
			[2] = {
				UnitId = 7003601,
				UnitProb = 1,
			},
			[3] = T.RT_38,
			[4] = T.RT_39,
			[5] = {
				UnitId = 7013601,
				UnitProb = 0.5,
			},
		},
	},
	[7053] = {
		GroupId = 7053,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7008601,
				UnitProb = 1,
			},
			[2] = {
				UnitId = 7015601,
				UnitProb = 1,
			},
			[3] = {
				UnitId = 7001601,
				UnitProb = 0.5,
			},
			[4] = T.RT_39,
			[5] = {
				UnitId = 7003601,
				UnitProb = 0.5,
			},
		},
	},
	[7054] = {
		GroupId = 7054,
		MemberSpawnProb = {
			[1] = T.RT_34,
			[2] = T.RT_38,
			[3] = {
				UnitId = 7010601,
				UnitProb = 0.5,
			},
			[4] = {
				UnitId = 7015601,
				UnitProb = 0.2,
			},
		},
	},
	[8010] = {
		GroupId = 8010,
		MemberSpawnProb = {
			[1] = T.RT_40,
			[2] = T.RT_40,
			[3] = T.RT_40,
			[4] = T.RT_41,
		},
	},
	[8011] = {
		GroupId = 8011,
		MemberSpawnProb = {
			[1] = T.RT_40,
			[2] = T.RT_40,
			[3] = T.RT_40,
		},
	},
	[8020] = {
		GroupId = 8020,
		MemberSpawnProb = {
			[1] = T.RT_41,
			[2] = T.RT_41,
			[3] = T.RT_40,
			[4] = T.RT_42,
		},
	},
	[8021] = {
		GroupId = 8021,
		MemberSpawnProb = {
			[1] = T.RT_41,
			[2] = T.RT_41,
			[3] = T.RT_41,
			[4] = T.RT_41,
		},
	},
	[8022] = {
		GroupId = 8022,
		MemberSpawnProb = {
			[1] = T.RT_42,
		},
	},
	[8040] = {
		GroupId = 8040,
		MemberSpawnProb = {
			[1] = T.RT_40,
			[2] = T.RT_40,
			[3] = T.RT_41,
			[4] = T.RT_41,
			[5] = T.RT_42,
			[6] = {
				UnitId = 8003001,
				UnitProb = 0.5,
			},
		},
	},
	[8050] = {
		GroupId = 8050,
		MemberSpawnProb = {
			[1] = T.RT_43,
			[2] = T.RT_43,
			[3] = T.RT_44,
			[4] = T.RT_44,
			[5] = T.RT_45,
			[6] = T.RT_45,
		},
	},
	[9010] = {
		GroupId = 9010,
		MemberSpawnProb = {
			[1] = T.RT_46,
			[2] = T.RT_46,
			[3] = T.RT_47,
			[4] = T.RT_48,
		},
	},
	[9011] = {
		GroupId = 9011,
		MemberSpawnProb = {
			[1] = T.RT_46,
			[2] = T.RT_46,
			[3] = T.RT_46,
		},
	},
	[9020] = {
		GroupId = 9020,
		MemberSpawnProb = {
			[1] = T.RT_47,
			[2] = T.RT_47,
			[3] = T.RT_46,
			[4] = T.RT_48,
		},
	},
	[9021] = {
		GroupId = 9021,
		MemberSpawnProb = {
			[1] = T.RT_47,
			[2] = T.RT_47,
			[3] = T.RT_47,
			[4] = T.RT_48,
		},
	},
	[9040] = {
		GroupId = 9040,
		MemberSpawnProb = {
			[1] = T.RT_46,
			[2] = T.RT_46,
			[3] = T.RT_47,
			[4] = T.RT_47,
			[5] = T.RT_48,
			[6] = {
				UnitId = 9007001,
				UnitProb = 0.5,
			},
		},
	},
	[9050] = {
		GroupId = 9050,
		MemberSpawnProb = {
			[1] = T.RT_49,
			[2] = T.RT_49,
			[3] = T.RT_50,
			[4] = T.RT_50,
			[5] = {
				UnitId = 9007601,
				UnitProb = 1,
			},
			[6] = {
				UnitId = 9007601,
				UnitProb = 0.5,
			},
		},
	},
	[6001012] = {
		GroupId = 6001012,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6001012,
				UnitProb = 1,
			},
		},
	},
	[6001014] = {
		GroupId = 6001014,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6001014,
				UnitProb = 1,
			},
		},
	},
	[6001016] = {
		GroupId = 6001016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6001016,
				UnitProb = 1,
			},
		},
	},
	[6001018] = {
		GroupId = 6001018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6001018,
				UnitProb = 1,
			},
		},
	},
	[6001701] = {
		GroupId = 6001701,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6001701,
				UnitProb = 1,
			},
		},
	},
	[6002011] = {
		GroupId = 6002011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6002011,
				UnitProb = 1,
			},
		},
	},
	[6002015] = {
		GroupId = 6002015,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6002015,
				UnitProb = 1,
			},
		},
	},
	[6002016] = {
		GroupId = 6002016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6002016,
				UnitProb = 1,
			},
		},
	},
	[6002017] = {
		GroupId = 6002017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6002017,
				UnitProb = 1,
			},
		},
	},
	[6002018] = {
		GroupId = 6002018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6002018,
				UnitProb = 1,
			},
		},
	},
	[6002701] = {
		GroupId = 6002701,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6002701,
				UnitProb = 1,
			},
		},
	},
	[6004013] = {
		GroupId = 6004013,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6007001,
				UnitProb = 1,
			},
		},
	},
	[6011019] = {
		GroupId = 6011019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6011019,
				UnitProb = 1,
			},
		},
	},
	[6011020] = {
		GroupId = 6011020,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6011020,
				UnitProb = 1,
			},
		},
	},
	[6011021] = {
		GroupId = 6011021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6011021,
				UnitProb = 1,
			},
		},
	},
	[6011023] = {
		GroupId = 6011023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6011023,
				UnitProb = 1,
			},
		},
	},
	[6011024] = {
		GroupId = 6011024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6011024,
				UnitProb = 1,
			},
		},
	},
	[6012019] = {
		GroupId = 6012019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6012019,
				UnitProb = 1,
			},
		},
	},
	[6012021] = {
		GroupId = 6012021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6012021,
				UnitProb = 1,
			},
		},
	},
	[6012022] = {
		GroupId = 6012022,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6012022,
				UnitProb = 1,
			},
		},
	},
	[6012023] = {
		GroupId = 6012023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6012023,
				UnitProb = 1,
			},
		},
	},
	[6012024] = {
		GroupId = 6012024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6012024,
				UnitProb = 1,
			},
		},
	},
	[6016011] = {
		GroupId = 6016011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016011,
				UnitProb = 1,
			},
		},
	},
	[6016013] = {
		GroupId = 6016013,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016013,
				UnitProb = 1,
			},
		},
	},
	[6016015] = {
		GroupId = 6016015,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016015,
				UnitProb = 1,
			},
		},
	},
	[6016016] = {
		GroupId = 6016016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016016,
				UnitProb = 1,
			},
		},
	},
	[6016017] = {
		GroupId = 6016017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016017,
				UnitProb = 1,
			},
		},
	},
	[6016018] = {
		GroupId = 6016018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016018,
				UnitProb = 1,
			},
		},
	},
	[6016019] = {
		GroupId = 6016019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016019,
				UnitProb = 1,
			},
		},
	},
	[6016021] = {
		GroupId = 6016021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016021,
				UnitProb = 1,
			},
		},
	},
	[6016022] = {
		GroupId = 6016022,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016022,
				UnitProb = 1,
			},
		},
	},
	[6016023] = {
		GroupId = 6016023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016023,
				UnitProb = 1,
			},
		},
	},
	[6016024] = {
		GroupId = 6016024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6016024,
				UnitProb = 1,
			},
		},
	},
	[6017011] = {
		GroupId = 6017011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017011,
				UnitProb = 1,
			},
		},
	},
	[6017012] = {
		GroupId = 6017012,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017012,
				UnitProb = 1,
			},
		},
	},
	[6017013] = {
		GroupId = 6017013,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017013,
				UnitProb = 1,
			},
		},
	},
	[6017014] = {
		GroupId = 6017014,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017014,
				UnitProb = 1,
			},
		},
	},
	[6017016] = {
		GroupId = 6017016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017016,
				UnitProb = 1,
			},
		},
	},
	[6017017] = {
		GroupId = 6017017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017017,
				UnitProb = 1,
			},
		},
	},
	[6017018] = {
		GroupId = 6017018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017018,
				UnitProb = 1,
			},
		},
	},
	[6017019] = {
		GroupId = 6017019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017019,
				UnitProb = 1,
			},
		},
	},
	[6017020] = {
		GroupId = 6017020,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017020,
				UnitProb = 1,
			},
		},
	},
	[6017021] = {
		GroupId = 6017021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017021,
				UnitProb = 1,
			},
		},
	},
	[6017023] = {
		GroupId = 6017023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017023,
				UnitProb = 1,
			},
		},
	},
	[6017024] = {
		GroupId = 6017024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 6017024,
				UnitProb = 1,
			},
		},
	},
	[7001011] = {
		GroupId = 7001011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001011,
				UnitProb = 1,
			},
		},
	},
	[7001015] = {
		GroupId = 7001015,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001015,
				UnitProb = 1,
			},
		},
	},
	[7001016] = {
		GroupId = 7001016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001016,
				UnitProb = 1,
			},
		},
	},
	[7001017] = {
		GroupId = 7001017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001017,
				UnitProb = 1,
			},
		},
	},
	[7001018] = {
		GroupId = 7001018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001018,
				UnitProb = 1,
			},
		},
	},
	[7001019] = {
		GroupId = 7001019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001019,
				UnitProb = 1,
			},
		},
	},
	[7001021] = {
		GroupId = 7001021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001021,
				UnitProb = 1,
			},
		},
	},
	[7001022] = {
		GroupId = 7001022,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001022,
				UnitProb = 1,
			},
		},
	},
	[7001023] = {
		GroupId = 7001023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001023,
				UnitProb = 1,
			},
		},
	},
	[7001024] = {
		GroupId = 7001024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7001024,
				UnitProb = 1,
			},
		},
	},
	[7002011] = {
		GroupId = 7002011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002011,
				UnitProb = 1,
			},
		},
	},
	[7002012] = {
		GroupId = 7002012,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002012,
				UnitProb = 1,
			},
		},
	},
	[7002014] = {
		GroupId = 7002014,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002014,
				UnitProb = 1,
			},
		},
	},
	[7002016] = {
		GroupId = 7002016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002016,
				UnitProb = 1,
			},
		},
	},
	[7002017] = {
		GroupId = 7002017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002017,
				UnitProb = 1,
			},
		},
	},
	[7002018] = {
		GroupId = 7002018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002018,
				UnitProb = 1,
			},
		},
	},
	[7002019] = {
		GroupId = 7002019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002019,
				UnitProb = 1,
			},
		},
	},
	[7002020] = {
		GroupId = 7002020,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002020,
				UnitProb = 1,
			},
		},
	},
	[7002021] = {
		GroupId = 7002021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002021,
				UnitProb = 1,
			},
		},
	},
	[7002023] = {
		GroupId = 7002023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002023,
				UnitProb = 1,
			},
		},
	},
	[7002024] = {
		GroupId = 7002024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7002024,
				UnitProb = 1,
			},
		},
	},
	[7003011] = {
		GroupId = 7003011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003011,
				UnitProb = 1,
			},
		},
	},
	[7003015] = {
		GroupId = 7003015,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003015,
				UnitProb = 1,
			},
		},
	},
	[7003016] = {
		GroupId = 7003016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003016,
				UnitProb = 1,
			},
		},
	},
	[7003017] = {
		GroupId = 7003017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003017,
				UnitProb = 1,
			},
		},
	},
	[7003018] = {
		GroupId = 7003018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003018,
				UnitProb = 1,
			},
		},
	},
	[7003019] = {
		GroupId = 7003019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003019,
				UnitProb = 1,
			},
		},
	},
	[7003021] = {
		GroupId = 7003021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003021,
				UnitProb = 1,
			},
		},
	},
	[7003022] = {
		GroupId = 7003022,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003022,
				UnitProb = 1,
			},
		},
	},
	[7003023] = {
		GroupId = 7003023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003023,
				UnitProb = 1,
			},
		},
	},
	[7003024] = {
		GroupId = 7003024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 7003024,
				UnitProb = 1,
			},
		},
	},
	[8001011] = {
		GroupId = 8001011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001011,
				UnitProb = 1,
			},
		},
	},
	[8001015] = {
		GroupId = 8001015,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001015,
				UnitProb = 1,
			},
		},
	},
	[8001016] = {
		GroupId = 8001016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001016,
				UnitProb = 1,
			},
		},
	},
	[8001017] = {
		GroupId = 8001017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001017,
				UnitProb = 1,
			},
		},
	},
	[8001018] = {
		GroupId = 8001018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001018,
				UnitProb = 1,
			},
		},
	},
	[8001019] = {
		GroupId = 8001019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001019,
				UnitProb = 1,
			},
		},
	},
	[8001021] = {
		GroupId = 8001021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001021,
				UnitProb = 1,
			},
		},
	},
	[8001022] = {
		GroupId = 8001022,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001022,
				UnitProb = 1,
			},
		},
	},
	[8001023] = {
		GroupId = 8001023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001023,
				UnitProb = 1,
			},
		},
	},
	[8001024] = {
		GroupId = 8001024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8001024,
				UnitProb = 1,
			},
		},
	},
	[8002011] = {
		GroupId = 8002011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002011,
				UnitProb = 1,
			},
		},
	},
	[8002012] = {
		GroupId = 8002012,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002012,
				UnitProb = 1,
			},
		},
	},
	[8002014] = {
		GroupId = 8002014,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002014,
				UnitProb = 1,
			},
		},
	},
	[8002016] = {
		GroupId = 8002016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002016,
				UnitProb = 1,
			},
		},
	},
	[8002017] = {
		GroupId = 8002017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002017,
				UnitProb = 1,
			},
		},
	},
	[8002018] = {
		GroupId = 8002018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002018,
				UnitProb = 1,
			},
		},
	},
	[8002019] = {
		GroupId = 8002019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002019,
				UnitProb = 1,
			},
		},
	},
	[8002020] = {
		GroupId = 8002020,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002020,
				UnitProb = 1,
			},
		},
	},
	[8002021] = {
		GroupId = 8002021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002021,
				UnitProb = 1,
			},
		},
	},
	[8002023] = {
		GroupId = 8002023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002023,
				UnitProb = 1,
			},
		},
	},
	[8002024] = {
		GroupId = 8002024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002024,
				UnitProb = 1,
			},
		},
	},
	[8002701] = {
		GroupId = 8002701,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002701,
				UnitProb = 1,
			},
		},
	},
	[8002702] = {
		GroupId = 8002702,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002702,
				UnitProb = 1,
			},
		},
	},
	[8002703] = {
		GroupId = 8002703,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002703,
				UnitProb = 1,
			},
		},
	},
	[8002704] = {
		GroupId = 8002704,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8002704,
				UnitProb = 1,
			},
		},
	},
	[8003011] = {
		GroupId = 8003011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003011,
				UnitProb = 1,
			},
		},
	},
	[8003015] = {
		GroupId = 8003015,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003015,
				UnitProb = 1,
			},
		},
	},
	[8003016] = {
		GroupId = 8003016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003016,
				UnitProb = 1,
			},
		},
	},
	[8003017] = {
		GroupId = 8003017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003017,
				UnitProb = 1,
			},
		},
	},
	[8003018] = {
		GroupId = 8003018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003018,
				UnitProb = 1,
			},
		},
	},
	[8003019] = {
		GroupId = 8003019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003019,
				UnitProb = 1,
			},
		},
	},
	[8003021] = {
		GroupId = 8003021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003021,
				UnitProb = 1,
			},
		},
	},
	[8003022] = {
		GroupId = 8003022,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003022,
				UnitProb = 1,
			},
		},
	},
	[8003023] = {
		GroupId = 8003023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003023,
				UnitProb = 1,
			},
		},
	},
	[8003024] = {
		GroupId = 8003024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003024,
				UnitProb = 1,
			},
		},
	},
	[8003701] = {
		GroupId = 8003701,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003701,
				UnitProb = 1,
			},
		},
	},
	[8003702] = {
		GroupId = 8003702,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003702,
				UnitProb = 1,
			},
		},
	},
	[8003703] = {
		GroupId = 8003703,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003703,
				UnitProb = 1,
			},
		},
	},
	[8003704] = {
		GroupId = 8003704,
		MemberSpawnProb = {
			[1] = {
				UnitId = 8003704,
				UnitProb = 1,
			},
		},
	},
	[9001011] = {
		GroupId = 9001011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001011,
				UnitProb = 1,
			},
		},
	},
	[9001012] = {
		GroupId = 9001012,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001012,
				UnitProb = 1,
			},
		},
	},
	[9001014] = {
		GroupId = 9001014,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001014,
				UnitProb = 1,
			},
		},
	},
	[9001016] = {
		GroupId = 9001016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001016,
				UnitProb = 1,
			},
		},
	},
	[9001017] = {
		GroupId = 9001017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001017,
				UnitProb = 1,
			},
		},
	},
	[9001018] = {
		GroupId = 9001018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001018,
				UnitProb = 1,
			},
		},
	},
	[9001019] = {
		GroupId = 9001019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001019,
				UnitProb = 1,
			},
		},
	},
	[9001020] = {
		GroupId = 9001020,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001020,
				UnitProb = 1,
			},
		},
	},
	[9001021] = {
		GroupId = 9001021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001021,
				UnitProb = 1,
			},
		},
	},
	[9001023] = {
		GroupId = 9001023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001023,
				UnitProb = 1,
			},
		},
	},
	[9001024] = {
		GroupId = 9001024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9001024,
				UnitProb = 1,
			},
		},
	},
	[9002011] = {
		GroupId = 9002011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002011,
				UnitProb = 1,
			},
		},
	},
	[9002015] = {
		GroupId = 9002015,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002015,
				UnitProb = 1,
			},
		},
	},
	[9002016] = {
		GroupId = 9002016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002016,
				UnitProb = 1,
			},
		},
	},
	[9002017] = {
		GroupId = 9002017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002017,
				UnitProb = 1,
			},
		},
	},
	[9002018] = {
		GroupId = 9002018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002018,
				UnitProb = 1,
			},
		},
	},
	[9002019] = {
		GroupId = 9002019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002019,
				UnitProb = 1,
			},
		},
	},
	[9002021] = {
		GroupId = 9002021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002021,
				UnitProb = 1,
			},
		},
	},
	[9002022] = {
		GroupId = 9002022,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002022,
				UnitProb = 1,
			},
		},
	},
	[9002023] = {
		GroupId = 9002023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002023,
				UnitProb = 1,
			},
		},
	},
	[9002024] = {
		GroupId = 9002024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9002024,
				UnitProb = 1,
			},
		},
	},
	[9003601] = {
		GroupId = 9003601,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9003601,
				UnitProb = 1,
			},
		},
	},
	[9005601] = {
		GroupId = 9005601,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9005601,
				UnitProb = 1,
			},
		},
	},
	[9006601] = {
		GroupId = 9006601,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9006601,
				UnitProb = 1,
			},
		},
	},
	[9007011] = {
		GroupId = 9007011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007011,
				UnitProb = 1,
			},
		},
	},
	[9007015] = {
		GroupId = 9007015,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007015,
				UnitProb = 1,
			},
		},
	},
	[9007016] = {
		GroupId = 9007016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007016,
				UnitProb = 1,
			},
		},
	},
	[9007017] = {
		GroupId = 9007017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007017,
				UnitProb = 1,
			},
		},
	},
	[9007018] = {
		GroupId = 9007018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007018,
				UnitProb = 1,
			},
		},
	},
	[9007019] = {
		GroupId = 9007019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007019,
				UnitProb = 1,
			},
		},
	},
	[9007021] = {
		GroupId = 9007021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007021,
				UnitProb = 1,
			},
		},
	},
	[9007022] = {
		GroupId = 9007022,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007022,
				UnitProb = 1,
			},
		},
	},
	[9007023] = {
		GroupId = 9007023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007023,
				UnitProb = 1,
			},
		},
	},
	[9007024] = {
		GroupId = 9007024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 9007024,
				UnitProb = 1,
			},
		},
	},
	[10005011] = {
		GroupId = 10005011,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005011,
				UnitProb = 1,
			},
		},
	},
	[10005012] = {
		GroupId = 10005012,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005012,
				UnitProb = 1,
			},
		},
	},
	[10005013] = {
		GroupId = 10005013,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005013,
				UnitProb = 1,
			},
		},
	},
	[10005014] = {
		GroupId = 10005014,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005014,
				UnitProb = 1,
			},
		},
	},
	[10005016] = {
		GroupId = 10005016,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005016,
				UnitProb = 1,
			},
		},
	},
	[10005017] = {
		GroupId = 10005017,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005017,
				UnitProb = 1,
			},
		},
	},
	[10005018] = {
		GroupId = 10005018,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005018,
				UnitProb = 1,
			},
		},
	},
	[10005019] = {
		GroupId = 10005019,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005019,
				UnitProb = 1,
			},
		},
	},
	[10005020] = {
		GroupId = 10005020,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005020,
				UnitProb = 1,
			},
		},
	},
	[10005021] = {
		GroupId = 10005021,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005021,
				UnitProb = 1,
			},
		},
	},
	[10005023] = {
		GroupId = 10005023,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005023,
				UnitProb = 1,
			},
		},
	},
	[10005024] = {
		GroupId = 10005024,
		MemberSpawnProb = {
			[1] = {
				UnitId = 10005024,
				UnitProb = 1,
			},
		},
	},
})