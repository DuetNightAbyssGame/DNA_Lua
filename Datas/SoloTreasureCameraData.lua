-- Source Excel file path: ..\datas\Combat\CameraControlData.xlsx
local T = {}
T.RT_1 = {
		0,
		0,
		10,
	}
T.RT_2 = {
		[0] = T.RT_1,
	}
T.RT_3 = {
		0,
		-4,
		-90,
	}
T.RT_4 = {
		27,
		190,
		136,
	}
T.RT_5 = {
		-11,
		0,
		0,
	}
T.RT_6 = {
		[0] = T.RT_5,
	}
T.RT_7 = {
		0,
		200,
		137,
	}
T.RT_8 = {
		-3,
		0,
		0,
	}
T.RT_9 = {
		[0] = T.RT_8,
	}
T.RT_10 = {
		-31,
		190,
		115,
	}
T.RT_11 = {
		8.5,
		3,
		-1,
	}
T.RT_12 = {
		[0] = T.RT_11,
	}
T.RT_13 = {
		0,
		0,
		-90,
	}
T.RT_14 = {
		0,
		130,
		132,
	}
T.RT_15 = {
		0,
		170,
		90,
	}
T.RT_16 = {
		0,
		1,
		-90,
	}
T.RT_17 = {
		[2101] = T.RT_1,
	}
T.RT_18 = {
		0,
		150,
		90,
	}
T.RT_19 = {
		-150,
		265,
		100,
	}
T.RT_20 = {
		0,
		0,
		-60,
	}
T.RT_21 = {
		-120,
		225,
		77,
	}
T.RT_22 = {
		-140,
		260,
		115,
	}
T.RT_23 = {
		-140,
		255,
		110,
	}
T.RT_24 = {
		-5,
		440,
		95,
	}
T.RT_25 = {
		2,
		230,
		130,
	}
T.RT_26 = {
		2,
		140,
		145,
	}
T.RT_27 = {
		2,
		190,
		135,
	}
T.RT_28 = {
		0,
		250,
		115,
	}
T.RT_29 = {
		0,
		135,
		135,
	}
T.RT_30 = {
		0,
		205,
		120,
	}
T.RT_31 = {
		-5,
		220,
		85,
	}
T.RT_32 = {
		-5,
		140,
		100,
	}
T.RT_33 = {
		-5,
		190,
		91,
	}
T.RT_34 = {
		0,
		300,
		135,
	}
T.RT_35 = {
		0,
		160,
		167,
	}
T.RT_36 = {
		0,
		240,
		150,
	}
T.RT_37 = {
		0,
		270,
		125,
	}
T.RT_38 = {
		0,
		130,
		148,
	}
T.RT_39 = {
		0,
		200,
		135,
	}
T.RT_40 = {
		5,
		260,
		105,
	}
T.RT_41 = {
		5,
		130,
		100,
	}
T.RT_42 = {
		5,
		350,
		80,
	}
T.RT_43 = {
		5,
		130,
		95,
	}
T.RT_44 = {
		5,
		260,
		100,
	}
T.RT_45 = {
		5,
		300,
		70,
	}
T.RT_46 = {
		5,
		180,
		75,
	}
T.RT_47 = {
		15,
		260,
		80,
	}
T.RT_48 = {
		10,
		290,
		128,
	}
T.RT_49 = {
		10,
		160,
		115,
	}
T.RT_50 = {
		10,
		260,
		128,
	}
T.RT_51 = {
		5,
		370,
		100,
	}
T.RT_52 = {
		5,
		170,
		117,
	}
T.RT_53 = {
		5,
		260,
		120,
	}
T.RT_54 = {
		0,
		360,
		90,
	}
T.RT_55 = {
		0,
		300,
		70,
	}
T.RT_56 = {
		0,
		220,
		45,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SoloTreasureCameraData", {
	Char_Boy = {
		BackwardLocation = {
			15,
			560,
			137,
		},
		CameraFocal = 38.6,
		CameraName = "Char_Boy",
		Ease = 14,
		ForwardLocation = {
			3,
			160,
			150,
		},
		Location = {
			15,
			385,
			123,
		},
		MobileLocationOffset = T.RT_2,
		Rotation = {
			0,
			-5,
			-90,
		},
		Time = 1.2,
	},
	Char_Girl = {
		BackwardLocation = {
			5,
			480,
			120,
		},
		CameraFocal = 38.6,
		CameraName = "Char_Girl",
		Ease = 14,
		ForwardLocation = {
			5,
			160,
			142,
		},
		Location = {
			5,
			370,
			110,
		},
		LocationOffset = {
			[1801] = {
				5,
				0,
				0,
			},
		},
		MobileLocationOffset = T.RT_2,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Char_Loli = {
		BackwardLocation = {
			5,
			470,
			145,
		},
		CameraFocal = 38.6,
		CameraName = "Char_Loli",
		Ease = 14,
		ForwardLocation = {
			5,
			210,
			124,
		},
		Location = {
			5,
			310,
			120,
		},
		MobileLocationOffset = T.RT_2,
		Rotation = {
			0,
			-9,
			-90,
		},
		Time = 1.2,
	},
	Char_Man = {
		BackwardLocation = {
			5,
			530,
			128,
		},
		CameraFocal = 38.6,
		CameraName = "Char_Man",
		Ease = 14,
		ForwardLocation = {
			5,
			180,
			170,
		},
		Location = {
			5,
			440,
			120,
		},
		MobileLocationOffset = T.RT_2,
		Rotation = {
			0,
			-3,
			-90,
		},
		Time = 1.2,
	},
	Char_Woman = {
		BackwardLocation = {
			5,
			530,
			155,
		},
		CameraFocal = 38.6,
		CameraName = "Char_Woman",
		Ease = 14,
		ForwardLocation = {
			5,
			150,
			165,
		},
		Location = {
			5,
			425,
			150,
		},
		LocationOffset = {
			[1502] = {
				0,
				35,
				0,
			},
			[2401] = {
				-7,
				0,
				-5,
			},
		},
		MobileLocationOffset = T.RT_2,
		Rotation = {
			0,
			-7,
			-90,
		},
		Time = 1.2,
	},
	Default = {
		CameraFocal = 70,
		CameraName = "Default",
		Ease = 14,
		Location = {
			1000,
			-20,
			-1,
		},
		Rotation = {
			0,
			0,
			180,
		},
		Time = 1.2,
	},
	Nanzhu_Entry_LevelUp_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nanzhu_Entry_LevelUp_Pet",
		Ease = 14,
		Location = T.RT_4,
		MobileLocationOffset = T.RT_6,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nanzhu_Entry_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nanzhu_Entry_Pet",
		Ease = 14,
		Location = T.RT_7,
		MobileLocationOffset = T.RT_9,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nanzhu_Entry_Switch_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nanzhu_Entry_Switch_Pet",
		Ease = 14,
		Location = T.RT_7,
		MobileLocationOffset = T.RT_9,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nanzhu_LevelUp_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nanzhu_LevelUp_Pet",
		Ease = 14,
		Location = T.RT_4,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nanzhu_Mix_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nanzhu_Mix_Pet",
		Ease = 14,
		Location = T.RT_10,
		MobileLocationOffset = T.RT_12,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Nanzhu_Pet = {
		BackwardLocation = T.RT_7,
		CameraFocal = 38.6,
		CameraName = "Nanzhu_Pet",
		Ease = 14,
		ForwardLocation = T.RT_14,
		Location = T.RT_7,
		MobileLocationOffset = T.RT_9,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nanzhu_Switch_Pet = {
		BackwardLocation = T.RT_7,
		CameraFocal = 38.6,
		CameraName = "Nanzhu_Switch_Pet",
		Ease = 14,
		ForwardLocation = T.RT_14,
		Location = T.RT_7,
		MobileLocationOffset = T.RT_9,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nvzhu_Entry_LevelUp_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nvzhu_Entry_LevelUp_Pet",
		Ease = 14,
		Location = T.RT_4,
		MobileLocationOffset = T.RT_6,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nvzhu_Entry_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nvzhu_Entry_Pet",
		Ease = 14,
		Location = T.RT_7,
		MobileLocationOffset = T.RT_9,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nvzhu_Entry_Switch_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nvzhu_Entry_Switch_Pet",
		Ease = 14,
		Location = T.RT_7,
		MobileLocationOffset = T.RT_9,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nvzhu_LevelUp_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nvzhu_LevelUp_Pet",
		Ease = 14,
		Location = T.RT_4,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nvzhu_Mix_Pet = {
		CameraFocal = 38.6,
		CameraName = "Nvzhu_Mix_Pet",
		Ease = 14,
		Location = T.RT_10,
		MobileLocationOffset = T.RT_12,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Nvzhu_Pet = {
		BackwardLocation = T.RT_7,
		CameraFocal = 38.6,
		CameraName = "Nvzhu_Pet",
		Ease = 14,
		ForwardLocation = T.RT_14,
		Location = T.RT_7,
		MobileLocationOffset = T.RT_9,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Nvzhu_Switch_Pet = {
		BackwardLocation = T.RT_7,
		CameraFocal = 38.6,
		CameraName = "Nvzhu_Switch_Pet",
		Ease = 14,
		ForwardLocation = T.RT_14,
		Location = T.RT_7,
		MobileLocationOffset = T.RT_9,
		Rotation = T.RT_3,
		Time = 1.2,
	},
	Weapon_Bow_Boy = {
		BackwardLocation = {
			8,
			340,
			100,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Bow_Boy",
		Ease = 14,
		ForwardLocation = T.RT_15,
		Location = {
			8,
			300,
			100,
		},
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Bow_Girl = {
		BackwardLocation = {
			0,
			300,
			100,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Bow_Girl",
		Ease = 14,
		ForwardLocation = {
			0,
			180,
			80,
		},
		Location = {
			0,
			260,
			100,
		},
		LocationOffset = T.RT_17,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Bow_Loli = {
		BackwardLocation = {
			8,
			300,
			80,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Bow_Loli",
		Ease = 14,
		ForwardLocation = {
			0,
			180,
			70,
		},
		Location = {
			8,
			260,
			80,
		},
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Bow_Man = {
		BackwardLocation = {
			0,
			350,
			125,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Bow_Man",
		Ease = 14,
		ForwardLocation = {
			0,
			180,
			95,
		},
		Location = {
			0,
			310,
			125,
		},
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Bow_Woman = {
		BackwardLocation = {
			0,
			320,
			113,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Bow_Woman",
		Ease = 14,
		ForwardLocation = T.RT_18,
		Location = {
			0,
			280,
			113,
		},
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Cannon_Boy = {
		BackwardLocation = T.RT_19,
		CameraFocal = 38.6,
		CameraName = "Weapon_Cannon_Boy",
		Ease = 14,
		ForwardLocation = {
			-85,
			140,
			70,
		},
		Location = T.RT_19,
		Rotation = T.RT_20,
		Time = 1.2,
	},
	Weapon_Cannon_Girl = {
		BackwardLocation = {
			-150,
			260,
			95,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Cannon_Girl",
		Ease = 14,
		ForwardLocation = {
			-85,
			135,
			80,
		},
		Location = {
			-138,
			240,
			100,
		},
		LocationOffset = T.RT_17,
		Rotation = T.RT_20,
		Time = 1.2,
	},
	Weapon_Cannon_Loli = {
		BackwardLocation = T.RT_21,
		CameraFocal = 38.6,
		CameraName = "Weapon_Cannon_Loli",
		Ease = 14,
		ForwardLocation = {
			-55,
			100,
			55,
		},
		Location = T.RT_21,
		Rotation = T.RT_20,
		Time = 1.2,
	},
	Weapon_Cannon_Man = {
		BackwardLocation = T.RT_22,
		CameraFocal = 38.6,
		CameraName = "Weapon_Cannon_Man",
		Ease = 14,
		ForwardLocation = {
			-70,
			130,
			75,
		},
		Location = T.RT_22,
		Rotation = T.RT_20,
		Time = 1.2,
	},
	Weapon_Cannon_Woman = {
		BackwardLocation = T.RT_23,
		CameraFocal = 38.6,
		CameraName = "Weapon_Cannon_Woman",
		Ease = 14,
		ForwardLocation = {
			-70,
			130,
			90,
		},
		Location = T.RT_23,
		Rotation = T.RT_20,
		Time = 1.2,
	},
	Weapon_Claymore_Boy = {
		BackwardLocation = {
			-5,
			415,
			88,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Claymore_Boy",
		Ease = 14,
		ForwardLocation = {
			-5,
			250,
			120,
		},
		Location = {
			5,
			370,
			95,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Claymore_Girl = {
		BackwardLocation = T.RT_24,
		CameraFocal = 38.6,
		CameraName = "Weapon_Claymore_Girl",
		Ease = 14,
		ForwardLocation = {
			-5,
			215,
			115,
		},
		Location = {
			-5,
			330,
			90,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Claymore_Loli = {
		BackwardLocation = {
			5,
			340,
			66,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Claymore_Loli",
		Ease = 14,
		ForwardLocation = {
			5,
			200,
			66,
		},
		Location = {
			15,
			270,
			66,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Claymore_Man = {
		BackwardLocation = {
			-5,
			460,
			100,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Claymore_Man",
		Ease = 14,
		ForwardLocation = {
			-5,
			270,
			125,
		},
		Location = {
			-5,
			390,
			110,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Claymore_Woman = {
		BackwardLocation = T.RT_24,
		CameraFocal = 38.6,
		CameraName = "Weapon_Claymore_Woman",
		Ease = 14,
		ForwardLocation = {
			-10,
			270,
			110,
		},
		Location = {
			-5,
			350,
			100,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Crossbow_Boy = {
		BackwardLocation = T.RT_25,
		CameraFocal = 38.6,
		CameraName = "Weapon_Crossbow_Boy",
		Ease = 14,
		ForwardLocation = T.RT_26,
		Location = T.RT_27,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Crossbow_Girl = {
		BackwardLocation = T.RT_28,
		CameraFocal = 38.6,
		CameraName = "Weapon_Crossbow_Girl",
		Ease = 14,
		ForwardLocation = T.RT_29,
		Location = T.RT_30,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Crossbow_Loli = {
		BackwardLocation = T.RT_31,
		CameraFocal = 38.6,
		CameraName = "Weapon_Crossbow_Loli",
		Ease = 14,
		ForwardLocation = T.RT_32,
		Location = T.RT_33,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Crossbow_Man = {
		BackwardLocation = T.RT_34,
		CameraFocal = 38.6,
		CameraName = "Weapon_Crossbow_Man",
		Ease = 14,
		ForwardLocation = T.RT_35,
		Location = T.RT_36,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Crossbow_Woman = {
		BackwardLocation = T.RT_37,
		CameraFocal = 38.6,
		CameraName = "Weapon_Crossbow_Woman",
		Ease = 14,
		ForwardLocation = T.RT_38,
		Location = T.RT_39,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Dualblade_Boy = {
		BackwardLocation = {
			10,
			300,
			100,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Dualblade_Boy",
		Ease = 14,
		ForwardLocation = {
			10,
			180,
			80,
		},
		Location = {
			10,
			250,
			120,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Dualblade_Girl = {
		BackwardLocation = {
			0,
			300,
			90,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Dualblade_Girl",
		Ease = 14,
		ForwardLocation = {
			0,
			160,
			85,
		},
		Location = {
			0,
			215,
			115,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Dualblade_Loli = {
		BackwardLocation = {
			0,
			320,
			70,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Dualblade_Loli",
		Ease = 14,
		ForwardLocation = {
			0,
			200,
			81,
		},
		Location = {
			10,
			280,
			81,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Dualblade_Man = {
		BackwardLocation = {
			0,
			400,
			100,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Dualblade_Man",
		Ease = 14,
		ForwardLocation = T.RT_15,
		Location = {
			0,
			290,
			125,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Dualblade_Woman = {
		BackwardLocation = {
			0,
			395,
			90,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Dualblade_Woman",
		Ease = 14,
		ForwardLocation = T.RT_18,
		Location = {
			0,
			255,
			120,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Katana_Boy = {
		BackwardLocation = {
			10,
			455,
			90,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Katana_Boy",
		Ease = 14,
		ForwardLocation = {
			10,
			255,
			90,
		},
		Location = {
			15,
			325,
			95,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Katana_Girl = {
		BackwardLocation = {
			10,
			430,
			90,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Katana_Girl",
		Ease = 14,
		ForwardLocation = {
			10,
			230,
			90,
		},
		Location = {
			10,
			300,
			95,
		},
		LocationOffset = {
			[2101] = {
				0,
				0,
				15,
			},
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Katana_Loli = {
		BackwardLocation = {
			10,
			400,
			75,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Katana_Loli",
		Ease = 14,
		ForwardLocation = {
			10,
			225,
			75,
		},
		Location = {
			10,
			270,
			80,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Katana_Man = {
		BackwardLocation = {
			10,
			450,
			120,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Katana_Man",
		Ease = 14,
		ForwardLocation = {
			10,
			230,
			120,
		},
		Location = {
			10,
			320,
			125,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Katana_Woman = {
		BackwardLocation = {
			10,
			450,
			105,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Katana_Woman",
		Ease = 14,
		ForwardLocation = {
			10,
			230,
			105,
		},
		Location = {
			10,
			320,
			110,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Machinegun_Boy = {
		BackwardLocation = T.RT_40,
		CameraFocal = 38.6,
		CameraName = "Weapon_Machinegun_Boy",
		Ease = 14,
		ForwardLocation = T.RT_41,
		Location = T.RT_40,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Machinegun_Girl = {
		BackwardLocation = T.RT_42,
		CameraFocal = 38.6,
		CameraName = "Weapon_Machinegun_Girl",
		Ease = 14,
		ForwardLocation = T.RT_43,
		Location = T.RT_44,
		LocationOffset = T.RT_17,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Machinegun_Loli = {
		BackwardLocation = T.RT_45,
		CameraFocal = 38.6,
		CameraName = "Weapon_Machinegun_Loli",
		Ease = 14,
		ForwardLocation = T.RT_46,
		Location = T.RT_47,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Machinegun_Man = {
		BackwardLocation = T.RT_48,
		CameraFocal = 38.6,
		CameraName = "Weapon_Machinegun_Man",
		Ease = 14,
		ForwardLocation = T.RT_49,
		Location = T.RT_50,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Machinegun_Woman = {
		BackwardLocation = T.RT_51,
		CameraFocal = 38.6,
		CameraName = "Weapon_Machinegun_Woman",
		Ease = 14,
		ForwardLocation = T.RT_52,
		Location = T.RT_53,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Pistol_Boy = {
		BackwardLocation = T.RT_25,
		CameraFocal = 38.6,
		CameraName = "Weapon_Pistol_Boy",
		Ease = 14,
		ForwardLocation = T.RT_26,
		Location = T.RT_27,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Pistol_Girl = {
		BackwardLocation = T.RT_28,
		CameraFocal = 38.6,
		CameraName = "Weapon_Pistol_Girl",
		Ease = 14,
		ForwardLocation = T.RT_29,
		Location = T.RT_30,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Pistol_Loli = {
		BackwardLocation = T.RT_31,
		CameraFocal = 38.6,
		CameraName = "Weapon_Pistol_Loli",
		Ease = 14,
		ForwardLocation = T.RT_32,
		Location = T.RT_33,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Pistol_Man = {
		BackwardLocation = T.RT_34,
		CameraFocal = 38.6,
		CameraName = "Weapon_Pistol_Man",
		Ease = 14,
		ForwardLocation = T.RT_35,
		Location = T.RT_36,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Pistol_Woman = {
		BackwardLocation = T.RT_37,
		CameraFocal = 38.6,
		CameraName = "Weapon_Pistol_Woman",
		Ease = 14,
		ForwardLocation = T.RT_38,
		Location = T.RT_39,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Polearm_Boy = {
		BackwardLocation = {
			-10,
			400,
			90,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Polearm_Boy",
		Ease = 14,
		ForwardLocation = {
			-22,
			230,
			120,
		},
		Location = T.RT_54,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Polearm_Girl = {
		BackwardLocation = {
			0,
			380,
			95,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Polearm_Girl",
		Ease = 14,
		ForwardLocation = {
			-16,
			206,
			137,
		},
		Location = {
			0,
			300,
			95,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Polearm_Loli = {
		BackwardLocation = {
			-10,
			340,
			80,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Polearm_Loli",
		Ease = 14,
		ForwardLocation = {
			-30,
			207,
			95,
		},
		Location = {
			-5,
			300,
			80,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Polearm_Man = {
		BackwardLocation = {
			0,
			430,
			100,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Polearm_Man",
		Ease = 14,
		ForwardLocation = {
			-26,
			256,
			134,
		},
		Location = {
			0,
			380,
			100,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Polearm_Woman = {
		BackwardLocation = {
			0,
			450,
			105,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Polearm_Woman",
		Ease = 14,
		ForwardLocation = {
			-16,
			230,
			150,
		},
		Location = {
			0,
			320,
			110,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Shotgun_Boy = {
		BackwardLocation = {
			5,
			290,
			105,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Shotgun_Boy",
		Ease = 14,
		ForwardLocation = T.RT_41,
		Location = T.RT_40,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Shotgun_Girl = {
		BackwardLocation = T.RT_42,
		CameraFocal = 38.6,
		CameraName = "Weapon_Shotgun_Girl",
		Ease = 14,
		ForwardLocation = T.RT_43,
		Location = T.RT_44,
		LocationOffset = T.RT_17,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Shotgun_Loli = {
		BackwardLocation = T.RT_45,
		CameraFocal = 38.6,
		CameraName = "Weapon_Shotgun_Loli",
		Ease = 14,
		ForwardLocation = T.RT_46,
		Location = T.RT_47,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Shotgun_Man = {
		BackwardLocation = T.RT_48,
		CameraFocal = 38.6,
		CameraName = "Weapon_Shotgun_Man",
		Ease = 14,
		ForwardLocation = T.RT_49,
		Location = T.RT_50,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Shotgun_Woman = {
		BackwardLocation = T.RT_51,
		CameraFocal = 38.6,
		CameraName = "Weapon_Shotgun_Woman",
		Ease = 14,
		ForwardLocation = T.RT_52,
		Location = T.RT_53,
		Rotation = T.RT_16,
		Time = 1.2,
	},
	Weapon_Sword_Boy = {
		BackwardLocation = {
			0,
			460,
			90,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Sword_Boy",
		Ease = 14,
		ForwardLocation = {
			0,
			220,
			95,
		},
		Location = {
			0,
			280,
			105,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Sword_Girl = {
		BackwardLocation = T.RT_54,
		CameraFocal = 38.6,
		CameraName = "Weapon_Sword_Girl",
		Ease = 14,
		ForwardLocation = {
			0,
			210,
			105,
		},
		Location = {
			0,
			280,
			95,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Sword_Loli = {
		BackwardLocation = T.RT_55,
		CameraFocal = 38.6,
		CameraName = "Weapon_Sword_Loli",
		Ease = 14,
		ForwardLocation = {
			0,
			206,
			70,
		},
		Location = {
			0,
			280,
			70,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Sword_Man = {
		BackwardLocation = {
			0,
			377,
			105,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Sword_Man",
		Ease = 14,
		ForwardLocation = {
			0,
			230,
			125,
		},
		Location = {
			0,
			280,
			118,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Sword_Woman = {
		BackwardLocation = {
			0,
			377,
			95,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Sword_Woman",
		Ease = 14,
		ForwardLocation = {
			0,
			175,
			120,
		},
		Location = {
			0,
			280,
			115,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Swordwhip_Boy = {
		BackwardLocation = {
			0,
			350,
			87,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Swordwhip_Boy",
		Ease = 14,
		ForwardLocation = T.RT_56,
		Location = {
			0,
			370,
			87,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Swordwhip_Girl = {
		BackwardLocation = {
			0,
			410,
			80,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Swordwhip_Girl",
		Ease = 14,
		ForwardLocation = {
			0,
			270,
			50,
		},
		Location = {
			0,
			368,
			80,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Swordwhip_Loli = {
		BackwardLocation = {
			0,
			350,
			65,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Swordwhip_Loli",
		Ease = 14,
		ForwardLocation = T.RT_56,
		Location = T.RT_55,
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Swordwhip_Man = {
		BackwardLocation = {
			0,
			460,
			95,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Swordwhip_Man",
		Ease = 14,
		ForwardLocation = {
			0,
			250,
			65,
		},
		Location = {
			0,
			405,
			95,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
	Weapon_Swordwhip_Woman = {
		BackwardLocation = {
			0,
			440,
			93,
		},
		CameraFocal = 38.6,
		CameraName = "Weapon_Swordwhip_Woman",
		Ease = 14,
		ForwardLocation = {
			0,
			220,
			60,
		},
		Location = {
			0,
			400,
			90,
		},
		Rotation = T.RT_13,
		Time = 1.2,
	},
})