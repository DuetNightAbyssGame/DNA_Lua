-- Source Excel file path: ..\datas\GameEvent\TheaterEvent.xlsx
local T = {}
T.RT_1 = {
		4011,
		4012,
		4013,
	}
T.RT_2 = {
		4021,
		4022,
		4023,
	}
T.RT_3 = {
		4031,
		4032,
		4033,
		4039,
	}
T.RT_4 = {
		4041,
		4042,
		4043,
		4049,
	}
T.RT_5 = {
		4051,
		4052,
		4053,
	}
T.RT_6 = {
		4061,
		4062,
		4063,
	}
T.RT_7 = {
		4071,
		4072,
		4073,
		4079,
	}
T.RT_8 = {
		4081,
		4082,
		4083,
	}
T.RT_9 = {
		4091,
		4092,
		4093,
	}
T.RT_10 = {
		41002,
		41005,
		41006,
	}
T.RT_11 = {
		4111,
		4112,
		4113,
	}
T.RT_12 = {
		4121,
		4122,
		4123,
	}
T.RT_13 = {
		4131,
		4132,
		4133,
	}
T.RT_14 = {
		4141,
		4142,
		4143,
	}
T.RT_15 = {
		4151,
		4152,
		4153,
	}
T.RT_16 = {
		4161,
		4162,
		4163,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TheaterRandom", {
	[4011] = {
		PetNPCID = 900020,
		RandomID = 4011,
		Refer = "Pet",
		TalkConfigId = 51105801,
		TypeMatch = T.RT_1,
		Weight = 100,
	},
	[4012] = {
		PetNPCID = 900021,
		RandomID = 4012,
		Refer = "Pet",
		TalkConfigId = 51105802,
		TypeMatch = T.RT_1,
		Weight = 100,
	},
	[4021] = {
		PetNPCID = 900022,
		RandomID = 4021,
		Refer = "Pet",
		TalkConfigId = 51105803,
		TypeMatch = T.RT_2,
		Weight = 100,
	},
	[4022] = {
		PetNPCID = 900023,
		RandomID = 4022,
		Refer = "Pet",
		TalkConfigId = 51105804,
		TypeMatch = T.RT_2,
		Weight = 100,
	},
	[4031] = {
		PetNPCID = 900024,
		RandomID = 4031,
		Refer = "Pet",
		TalkConfigId = 51105805,
		TypeMatch = T.RT_3,
		Weight = 100,
	},
	[4032] = {
		PetNPCID = 900025,
		RandomID = 4032,
		Refer = "Pet",
		TalkConfigId = 51105806,
		TypeMatch = T.RT_3,
		Weight = 100,
	},
	[4041] = {
		PetNPCID = 900026,
		RandomID = 4041,
		Refer = "Pet",
		TalkConfigId = 51105807,
		TypeMatch = T.RT_4,
		Weight = 100,
	},
	[4042] = {
		PetNPCID = 900027,
		RandomID = 4042,
		Refer = "Pet",
		TalkConfigId = 51105808,
		TypeMatch = T.RT_4,
		Weight = 100,
	},
	[4051] = {
		PetNPCID = 900028,
		RandomID = 4051,
		Refer = "Pet",
		TalkConfigId = 51105809,
		TypeMatch = T.RT_5,
		Weight = 100,
	},
	[4052] = {
		PetNPCID = 900029,
		RandomID = 4052,
		Refer = "Pet",
		TalkConfigId = 51105810,
		TypeMatch = T.RT_5,
		Weight = 100,
	},
	[4061] = {
		PetNPCID = 900030,
		RandomID = 4061,
		Refer = "Pet",
		TalkConfigId = 51105811,
		TypeMatch = T.RT_6,
		Weight = 100,
	},
	[4062] = {
		PetNPCID = 900031,
		RandomID = 4062,
		Refer = "Pet",
		TalkConfigId = 51105812,
		TypeMatch = T.RT_6,
		Weight = 100,
	},
	[4071] = {
		PetNPCID = 900032,
		RandomID = 4071,
		Refer = "Pet",
		TalkConfigId = 51105813,
		TypeMatch = T.RT_7,
		Weight = 100,
	},
	[4072] = {
		PetNPCID = 900033,
		RandomID = 4072,
		Refer = "Pet",
		TalkConfigId = 51105814,
		TypeMatch = T.RT_7,
		Weight = 100,
	},
	[4081] = {
		PetNPCID = 900034,
		RandomID = 4081,
		Refer = "Pet",
		TalkConfigId = 51105815,
		TypeMatch = T.RT_8,
		Weight = 100,
	},
	[4082] = {
		PetNPCID = 900035,
		RandomID = 4082,
		Refer = "Pet",
		TalkConfigId = 51105816,
		TypeMatch = T.RT_8,
		Weight = 100,
	},
	[4091] = {
		PetNPCID = 900036,
		RandomID = 4091,
		Refer = "Pet",
		TalkConfigId = 51105817,
		TypeMatch = T.RT_9,
		Weight = 100,
	},
	[4092] = {
		PetNPCID = 900037,
		RandomID = 4092,
		Refer = "Pet",
		TalkConfigId = 51105818,
		TypeMatch = T.RT_9,
		Weight = 100,
	},
	[4111] = {
		PetNPCID = 900038,
		RandomID = 4111,
		Refer = "Pet",
		TalkConfigId = 51105819,
		TypeMatch = T.RT_11,
		Weight = 100,
	},
	[4112] = {
		PetNPCID = 900039,
		RandomID = 4112,
		Refer = "Pet",
		TalkConfigId = 51105820,
		TypeMatch = T.RT_11,
		Weight = 100,
	},
	[4121] = {
		PetNPCID = 900040,
		RandomID = 4121,
		Refer = "Pet",
		TalkConfigId = 51105821,
		TypeMatch = T.RT_12,
		Weight = 100,
	},
	[4122] = {
		PetNPCID = 900041,
		RandomID = 4122,
		Refer = "Pet",
		TalkConfigId = 51105822,
		TypeMatch = T.RT_12,
		Weight = 100,
	},
	[4131] = {
		PetNPCID = 900042,
		RandomID = 4131,
		Refer = "Pet",
		TalkConfigId = 51105823,
		TypeMatch = T.RT_13,
		Weight = 100,
	},
	[4132] = {
		PetNPCID = 900043,
		RandomID = 4132,
		Refer = "Pet",
		TalkConfigId = 51105824,
		TypeMatch = T.RT_13,
		Weight = 100,
	},
	[4141] = {
		PetNPCID = 900044,
		RandomID = 4141,
		Refer = "Pet",
		TalkConfigId = 51105825,
		TypeMatch = T.RT_14,
		Weight = 100,
	},
	[4142] = {
		PetNPCID = 900045,
		RandomID = 4142,
		Refer = "Pet",
		TalkConfigId = 51105826,
		TypeMatch = T.RT_14,
		Weight = 100,
	},
	[4151] = {
		PetNPCID = 900046,
		RandomID = 4151,
		Refer = "Pet",
		TalkConfigId = 51105827,
		TypeMatch = T.RT_15,
		Weight = 100,
	},
	[4152] = {
		PetNPCID = 900047,
		RandomID = 4152,
		Refer = "Pet",
		TalkConfigId = 51105828,
		TypeMatch = T.RT_15,
		Weight = 100,
	},
	[4161] = {
		PetNPCID = 900048,
		RandomID = 4161,
		Refer = "Pet",
		TalkConfigId = 51105829,
		TypeMatch = T.RT_16,
		Weight = 100,
	},
	[4162] = {
		PetNPCID = 900049,
		RandomID = 4162,
		Refer = "Pet",
		TalkConfigId = 51105830,
		TypeMatch = T.RT_16,
		Weight = 100,
	},
	[41001] = {
		RandomID = 41001,
		Refer = "Resource",
		TalkConfigId = 51105831,
		TypeMatch = {
			41001,
		},
		Weight = 100,
	},
	[41002] = {
		RandomID = 41002,
		Refer = "Resource",
		TalkConfigId = 51105832,
		TypeMatch = T.RT_10,
		Weight = 100,
	},
	[41003] = {
		RandomID = 41003,
		Refer = "Resource",
		TalkConfigId = 51105833,
		TypeMatch = {
			41003,
		},
		Weight = 100,
	},
	[41004] = {
		RandomID = 41004,
		Refer = "Resource",
		TalkConfigId = 51105834,
		TypeMatch = {
			41004,
		},
		Weight = 100,
	},
	[41005] = {
		RandomID = 41005,
		Refer = "Resource",
		TalkConfigId = 51105835,
		TypeMatch = T.RT_10,
		Weight = 100,
	},
	[41006] = {
		RandomID = 41006,
		Refer = "Resource",
		TalkConfigId = 51105836,
		TypeMatch = T.RT_10,
		Weight = 100,
	},
	[41011] = {
		MontageName = "Close",
		RandomID = 41011,
		Refer = "Resource",
		TalkConfigId = 51105837,
		TypeMatch = {
			41011,
		},
		Weight = 100,
	},
	[41013] = {
		RandomID = 41013,
		Refer = "Resource",
		TalkConfigId = 51105838,
		TypeMatch = {
			41013,
		},
		Weight = 100,
	},
})