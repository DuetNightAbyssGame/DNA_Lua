-- Source Excel file path: ..\datas\Combat\Mod.xlsx
local T = {}
T.RT_1 = {
		"UI_Armory_Char",
	}
T.RT_2 = {
		"UI_Armory_Meleeweapon",
	}
T.RT_3 = {
		"UI_Armory_Longrange",
	}
T.RT_4 = {
		"UI_Armory_MeleeweaponUltra",
	}
T.RT_5 = {
		"UI_Armory_LongrangeUltra",
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ModTag", {
	[1] = {
		ApplicationType = 1,
		ModTagText = T.RT_1,
	},
	[2] = {
		ApplicationType = 2,
		ModTagText = T.RT_2,
	},
	[3] = {
		ApplicationType = 3,
		ModTagText = T.RT_3,
	},
	[4] = {
		ApplicationType = 4,
		ModTagText = T.RT_4,
	},
	[5] = {
		ApplicationType = 5,
		ModTagText = T.RT_5,
	},
	[11] = {
		ApplicationType = 11,
		ModTagText = {
			"UI_Armory_Char",
			"UI_Attr_Dark_Name",
		},
	},
	[12] = {
		ApplicationType = 12,
		ModTagText = {
			"UI_Armory_Char",
			"UI_Attr_Water_Name",
		},
	},
	[13] = {
		ApplicationType = 13,
		ModTagText = {
			"UI_Armory_Char",
			"UI_Attr_Fire_Name",
		},
	},
	[14] = {
		ApplicationType = 14,
		ModTagText = {
			"UI_Armory_Char",
			"UI_Attr_Thunder_Name",
		},
	},
	[15] = {
		ApplicationType = 15,
		ModTagText = {
			"UI_Armory_Char",
			"UI_Attr_Wind_Name",
		},
	},
	[16] = {
		ApplicationType = 16,
		ModTagText = {
			"UI_Armory_Char",
			"UI_Attr_Light_Name",
		},
	},
	[21] = {
		ApplicationType = 21,
		ModTagText = T.RT_2,
	},
	[22] = {
		ApplicationType = 22,
		ModTagText = T.RT_2,
	},
	[23] = {
		ApplicationType = 23,
		ModTagText = T.RT_2,
	},
	[31] = {
		ApplicationType = 31,
		ModTagText = T.RT_3,
	},
	[32] = {
		ApplicationType = 32,
		ModTagText = T.RT_3,
	},
	[33] = {
		ApplicationType = 33,
		ModTagText = T.RT_3,
	},
	[34] = {
		ApplicationType = 34,
		ModTagText = T.RT_3,
	},
	[35] = {
		ApplicationType = 35,
		ModTagText = T.RT_3,
	},
	[41] = {
		ApplicationType = 41,
		ModTagText = T.RT_4,
	},
	[42] = {
		ApplicationType = 42,
		ModTagText = T.RT_4,
	},
	[43] = {
		ApplicationType = 43,
		ModTagText = T.RT_4,
	},
	[51] = {
		ApplicationType = 51,
		ModTagText = T.RT_5,
	},
	[52] = {
		ApplicationType = 52,
		ModTagText = T.RT_5,
	},
	[53] = {
		ApplicationType = 53,
		ModTagText = T.RT_5,
	},
	[101] = {
		ApplicationType = 101,
		ModTagText = T.RT_2,
	},
	[102] = {
		ApplicationType = 102,
		ModTagText = T.RT_2,
	},
	[103] = {
		ApplicationType = 103,
		ModTagText = T.RT_2,
	},
	[104] = {
		ApplicationType = 104,
		ModTagText = T.RT_2,
	},
	[106] = {
		ApplicationType = 106,
		ModTagText = T.RT_2,
	},
	[1504] = {
		ApplicationType = 1504,
		ModTagText = T.RT_1,
	},
})