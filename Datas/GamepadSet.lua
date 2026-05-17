-- Source Excel file path: ..\datas\GamepadSet.xlsx
local T = {}
T.RT_1 = {
		[1] = "Combo1",
	}
T.RT_2 = {
		[1] = "WB_Key_L",
	}
T.RT_3 = {
		[1] = "WB_Key_R",
	}
T.RT_4 = {
		[1] = "WB_Key_Direc",
	}
T.RT_5 = {
		[1] = "Combo2",
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GamepadSet", {
	ActiveGuide = {
		ActionName = "ActiveGuide",
		IsAction = true,
		KeyRegion = T.RT_1,
		KeyText = "UI_Keyboard_Map_ActiveGuide",
		Order = 11,
	},
	Attack = {
		ActionName = "Attack",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_XYBA",
			[2] = "WB_Key_RBT",
			[3] = "WB_Key_XYBA",
			[4] = "WB_Key_XYBA",
		},
		KeyText = "UI_Keyboard_Map_Attack",
		Order = 4,
		TextHighLight = true,
	},
	Avoid = {
		ActionName = "Avoid",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_XYBA",
			[2] = "WB_Key_XYBA",
			[3] = "WB_Key_XYBA",
			[4] = "WB_Key_RBT",
		},
		KeyText = "UI_Keyboard_Map_Avoid",
		Order = 7,
		TextHighLight = true,
	},
	BulletJump = {
		ActionName = "BulletJump",
		IsAction = true,
		KeyRegion = T.RT_2,
		KeyText = "UI_CTL_BulletJump",
		Order = 22,
	},
	Camera = {
		ActionName = "Camera",
		GamepadIcon = {
			"R",
		},
		KeyRegion = T.RT_3,
		KeyText = "UI_CTL_Camera",
		Order = 23,
	},
	ChangeCameraLengthDown = {
		ActionName = "ChangeCameraLengthDown",
		IsAction = true,
		KeyRegion = T.RT_1,
		KeyText = "UI_CTL_ZoomOut",
		Order = 10,
	},
	ChangeCameraLengthUp = {
		ActionName = "ChangeCameraLengthUp",
		IsAction = true,
		KeyRegion = T.RT_1,
		KeyText = "UI_CTL_ZoomIn",
		Order = 9,
	},
	ChangeSelect = {
		ActionName = "ChangeSelect",
		GamepadIcon = {
			"Vertical",
		},
		KeyRegion = T.RT_4,
		KeyText = "UI_CTL_Switch",
		Order = 19,
	},
	ChargeBullet = {
		ActionName = "ChargeBullet",
		IsAction = true,
		KeyRegion = T.RT_1,
		KeyText = "UI_Keyboard_Map_ChargeBullet",
		Order = 16,
	},
	Fire = {
		ActionName = "Fire",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_RBT",
		},
		KeyText = "UI_Keyboard_Map_Fire",
		Order = 2,
	},
	GamepadOpenSystem = {
		ActionName = "GamepadOpenSystem",
		IsAction = true,
		KeyRegion = T.RT_4,
		KeyText = "UI_CTL_OpenSystem",
		Order = 18,
	},
	GamepadUseSkill = {
		ActionName = "GamepadUseSkill",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_LBT",
			[2] = "WB_Key_LBT",
			[3] = "WB_Key_XYBA",
			[4] = "WB_Key_XYBA",
		},
		KeyText = "UI_CTL_UseSkill",
		Order = 8,
		TextHighLight = true,
	},
	Interactive = {
		ActionName = "Interactive",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_XYBA",
			[2] = "WB_Key_XYBA",
			[3] = "WB_Key_XYBA",
			[4] = "WB_Key_XYBA",
		},
		KeyText = "UI_Keyboard_Map_Interactive",
		Order = 5,
	},
	Jump = {
		ActionName = "Jump",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_XYBA",
			[2] = "WB_Key_XYBA",
			[3] = "WB_Key_RBT",
			[4] = "WB_Key_XYBA",
		},
		KeyText = "UI_Keyboard_Map_Jump",
		Order = 6,
		TextHighLight = true,
	},
	LockMonster = {
		ActionName = "LockMonster",
		IsAction = true,
		KeyRegion = T.RT_3,
		KeyText = "UI_Keyboard_Map_LockMonster",
		Order = 24,
	},
	Move = {
		ActionName = "Move",
		GamepadIcon = {
			"L",
		},
		KeyRegion = T.RT_2,
		KeyText = "UI_CTL_Move",
		Order = 21,
	},
	OpenArmory = {
		ActionName = "OpenArmory",
		IsAction = true,
		KeyRegion = T.RT_5,
		KeyText = "MAIN_UI_ARMORY",
		Order = 29,
	},
	OpenBag = {
		ActionName = "OpenBag",
		IsAction = true,
		KeyRegion = T.RT_5,
		KeyText = "MAIN_UI_BAG",
		Order = 32,
	},
	OpenBattlePass = {
		ActionName = "OpenBattlePass",
		IsAction = true,
		KeyRegion = T.RT_5,
		KeyText = "MAIN_UI_BATTLEPASS",
		Order = 27,
	},
	OpenBattleWheel = {
		ActionName = "OpenBattleWheel",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_LBT",
		},
		KeyText = "MAIN_UI_BATTLEWHEEL",
		Order = 1,
	},
	OpenCamera = {
		ActionName = "OpenCamera",
		IsAction = true,
		KeyRegion = T.RT_5,
		KeyText = "UI_CameraSystem_Camera",
		Order = 35,
	},
	OpenEvent = {
		ActionName = "OpenEvent",
		IsAction = true,
		KeyRegion = T.RT_5,
		KeyText = "MAIN_UI_GAMEEVENT",
		Order = 30,
	},
	OpenForge = {
		ActionName = "OpenForge",
		IsAction = true,
		KeyRegion = T.RT_5,
		KeyText = "MAIN_UI_FORGE",
		Order = 34,
	},
	OpenGacha = {
		ActionName = "OpenGacha",
		IsAction = true,
		KeyRegion = T.RT_5,
		KeyText = "MAIN_UI_GACHA",
		Order = 33,
	},
	OpenGuideBook = {
		ActionName = "OpenGuideBook",
		IsAction = true,
		KeyRegion = T.RT_1,
		KeyText = "MAIN_UI_GUIDEBOOK",
		Order = 12,
	},
	OpenMap = {
		ActionName = "OpenMap",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_View",
		},
		KeyText = "MAIN_UI_MAP",
		Order = 25,
	},
	OpenMenu = {
		ActionName = "OpenMenu",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_Menu",
		},
		KeyText = "MAIN_UI_MENU",
		Order = 26,
	},
	OpenPlay = {
		ActionName = "OpenPlay",
		IsAction = true,
		KeyRegion = T.RT_5,
		KeyText = "MAIN_UI_PLAY",
		Order = 31,
	},
	OpenTask = {
		ActionName = "OpenTask",
		IsAction = true,
		KeyRegion = T.RT_5,
		KeyText = "MAIN_UI_QUEST",
		Order = 28,
	},
	ShowTeamInfo = {
		ActionName = "ShowTeamInfo",
		IsAction = true,
		KeyRegion = T.RT_4,
		KeyText = "UI_Keyboard_TeamInfo",
		Order = 20,
	},
	Skill1 = {
		ActionName = "Skill1",
		IsAction = true,
		KeyRegion = T.RT_1,
		KeyText = "UI_Keyboard_Map_Skill1",
		Order = 13,
	},
	Skill2 = {
		ActionName = "Skill2",
		IsAction = true,
		KeyRegion = T.RT_1,
		KeyText = "UI_Keyboard_Map_Skill2",
		Order = 14,
	},
	Skill3 = {
		ActionName = "Skill3",
		IsAction = true,
		KeyRegion = T.RT_1,
		KeyText = "UI_Keyboard_Map_Skill3",
		Order = 15,
	},
	Slide = {
		ActionName = "Slide",
		IsAction = true,
		KeyRegion = {
			[1] = "WB_Key_RBT",
			[2] = "WB_Key_XYBA",
			[3] = "WB_Key_LBT",
			[4] = "WB_Key_LBT",
		},
		KeyText = "UI_Keyboard_Map_Slide",
		Order = 3,
		TextHighLight = true,
	},
	SwitchWalk = {
		ActionName = "SwitchWalk",
		IsAction = true,
		KeyRegion = T.RT_1,
		KeyText = "UI_CTL_SwitchWalk",
		Order = 17,
	},
})