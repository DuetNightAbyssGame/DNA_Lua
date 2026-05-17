-- Source Excel file path: ..\datas\UIGuide.xlsx
local T = {}
T.RT_1 = {
		PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_1.T_Guide_Img_Explore_Step_1'",
		Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_1.T_Guide_Img_Explore_Step_1'",
	}
T.RT_2 = {
		PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Exterminate_Step_1.T_Guide_Img_Exterminate_Step_1'",
		Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Exterminate_Step_1.T_Guide_Img_Exterminate_Step_1'",
	}
T.RT_3 = {
		GamePad = "UIGuide_FangShu_4",
		PC = "UIGuide_FangShu_4",
		Phone = "UIGuide_FangShu_4",
	}
T.RT_4 = {
		GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_4.T_Guide_Img_FangShu_4'",
		PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_4.T_Guide_Img_FangShu_4'",
		Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_4.T_Guide_Img_FangShu_4'",
	}
T.RT_5 = {
		GuideContent = T.RT_3,
		GuidePicture = T.RT_4,
	}
T.RT_6 = {
		PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Elevator_01.T_Guide_Img_Elevator_01'",
		Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Shadow_01.T_Guide_Img_Shadow_01'",
	}
T.RT_7 = {
		PC = "UIGuide_SIDEWAYSJUMP",
		Phone = "UIGuide_SIDEWAYSJUMP",
	}
T.RT_8 = {
		PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SidewayJump_01.T_Guide_Img_SidewayJump_01'",
		Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SidewayJump_01.T_Guide_Img_SidewayJump_01'",
	}
T.RT_9 = {
		GuideContent = T.RT_7,
		GuidePicture = T.RT_8,
	}
T.RT_10 = {
		GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_02.T_Guide_Img_OnlineArea_02'",
		PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_02.T_Guide_Img_OnlineArea_02'",
		Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_02.T_Guide_Img_OnlineArea_02'",
	}
T.RT_11 = {
		GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_03.T_Guide_Img_OnlineArea_03'",
		PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_03.T_Guide_Img_OnlineArea_03'",
		Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_03.T_Guide_Img_OnlineArea_03'",
	}
T.RT_12 = {
		PC = "Message_Guide_Badge_1",
		Phone = "Message_Guide_Badge_1",
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("UIChildGuide", {
	[301] = {
		ChildGuideId = 301,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGUIDE_EXECUTION_01",
				PC = "UIGUIDE_EXECUTION_01",
				Phone = "UIGUIDE_EXECUTION_01",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Toughness.T_Guide_Img_Toughness'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Toughness.T_Guide_Img_Toughness'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Toughness.T_Guide_Img_Toughness'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_EXECUTION_01",
		GuideType = "ImageText",
	},
	[302] = {
		ChildGuideId = 302,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_EXECUTION_02",
				Phone = "UIGUIDE_EXECUTION_02",
			},
			GuidePicture = {
				GamePad = "FileMediaSource'/Game/Asset/UIVideo/Video_Guide_Hero_Execute_GamePad.Video_Guide_Hero_Execute_GamePad'",
				PC = "FileMediaSource'/Game/Asset/UIVideo/Video_Guide_Hero_Execute_PC.Video_Guide_Hero_Execute_PC'",
				Phone = "FileMediaSource'/Game/Asset/UIVideo/Video_Guide_Hero_Execute_Phone.Video_Guide_Hero_Execute_Phone'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_EXECUTION_02",
		GuideType = "ImageText",
	},
	[401] = {
		ChildGuideId = 401,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_SKILL2_01",
				Phone = "UIGUIDE_SKILL2_01_phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Secondskill.T_Guide_Img_Secondskill'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Secondskill.T_Guide_Img_Secondskill'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_SKILL2_01",
		GuideType = "ImageText",
	},
	[501] = {
		ChildGuideId = 501,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_HPSHIELD",
				Phone = "UIGUIDE_HPSHIELD",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Hp_Shield_PC.T_Guide_Img_Hp_Shield_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Hp_Shield_Phone.T_Guide_Img_Hp_Shield_Phone'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_HPSHIELD",
		GuideType = "ImageText",
	},
	[502] = {
		ChildGuideId = 502,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_OverloadShield",
				Phone = "UIGuide_OverloadShield",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OverloadShield_PC.T_Guide_Img_OverloadShield_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OverloadShield_Phone.T_Guide_Img_OverloadShield_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_OverloadShield",
		GuideType = "ImageText",
	},
	[601] = {
		ChildGuideId = 601,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_PARTIALDAMAGE_01",
				Phone = "UIGUIDE_PARTIALDAMAGE_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_01.T_Guide_Img_DestructablePart_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_01.T_Guide_Img_DestructablePart_01'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_PARTIALDAMAGE",
		GuideType = "ImageText",
	},
	[602] = {
		ChildGuideId = 602,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_PARTIALDAMAGE_02",
				Phone = "UIGUIDE_PARTIALDAMAGE_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_02.T_Guide_Img_DestructablePart_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_02.T_Guide_Img_DestructablePart_02'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_PARTIALDAMAGE",
		GuideType = "ImageText",
	},
	[603] = {
		ChildGuideId = 603,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_PARTIALDAMAGE_03",
				Phone = "UIGUIDE_PARTIALDAMAGE_03",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_03.T_Guide_Img_DestructablePart_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_03.T_Guide_Img_DestructablePart_03'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_PARTIALDAMAGE",
		GuideType = "ImageText",
	},
	[604] = {
		ChildGuideId = 604,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_PARTIALDAMAGE_04",
				Phone = "UIGUIDE_PARTIALDAMAGE_04",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DestructablePart_04_Phone.T_Guide_Img_DestructablePart_04_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DestructablePart_04_Phone.T_Guide_Img_DestructablePart_04_Phone'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_PARTIALDAMAGE",
		GuideType = "ImageText",
	},
	[605] = {
		ChildGuideId = 605,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_PARTIALDAMAGE_05",
				Phone = "UIGUIDE_PARTIALDAMAGE_05",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_05.T_Guide_Img_DestructablePart_05'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_05.T_Guide_Img_DestructablePart_05'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_PARTIALDAMAGE",
		GuideType = "ImageText",
	},
	[606] = {
		ChildGuideId = 606,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_PARTIALDAMAGE_06",
				Phone = "UIGUIDE_PARTIALDAMAGE_06",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_06.T_Guide_Img_DestructablePart_06'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_06.T_Guide_Img_DestructablePart_06'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_PARTIALDAMAGE",
		GuideType = "ImageText",
	},
	[607] = {
		ChildGuideId = 607,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_PARTIALDAMAGE_07",
				Phone = "UIGUIDE_PARTIALDAMAGE_07",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_07.T_Guide_Img_DestructablePart_07'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_DestructablePart_07.T_Guide_Img_DestructablePart_07'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_PARTIALDAMAGE",
		GuideType = "ImageText",
	},
	[608] = {
		ChildGuideId = 608,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_PARTIALDAMAGE_08",
				Phone = "UIGUIDE_PARTIALDAMAGE_08",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DestructablePart_08_Phone.T_Guide_Img_DestructablePart_08_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DestructablePart_08_Phone.T_Guide_Img_DestructablePart_08_Phone'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_PARTIALDAMAGE",
		GuideType = "ImageText",
	},
	[701] = {
		ChildGuideId = 701,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_GUN",
				Phone = "UIGUIDE_GUN",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Gun_PC.T_Guide_Img_Gun_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Gun_Phone.T_Guide_Img_Gun_Phone'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_GUN",
		GuideType = "ImageText",
	},
	[702] = {
		ChildGuideId = 702,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGUIDE_AMMO",
				Phone = "UIGUIDE_AMMO",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Ammo_PC.T_Guide_Img_Ammo_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Ammo_Phone.T_Guide_Img_Ammo_Phone'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_AMMO",
		GuideType = "ImageText",
	},
	[901] = {
		ChildGuideId = 901,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Delivery_01",
				Phone = "UIGuide_Delivery_01_phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Delivery_01.T_Guide_Img_Delivery_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Delivery_01.T_Guide_Img_Delivery_01'",
			},
		},
		GuideTitle = "UIGuide_Title_Delivery_01",
		GuideType = "ImageText",
	},
	[902] = {
		ChildGuideId = 902,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Delivery_02",
				Phone = "UIGuide_Delivery_02_phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Delivery_02.T_Guide_Img_Delivery_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Delivery_02.T_Guide_Img_Delivery_02'",
			},
		},
		GuideTitle = "UIGuide_Title_Delivery_02",
		GuideType = "ImageText",
	},
	[1001] = {
		ChildGuideId = 1001,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Combo_01",
				Phone = "UIGuide_Combo_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Combo_01.T_Guide_Img_Combo_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Combo_01.T_Guide_Img_Combo_01'",
			},
		},
		GuideTitle = "UIGuide_Title_Combo_01",
		GuideType = "ImageText",
	},
	[1002] = {
		ChildGuideId = 1002,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Combo_02_PC",
				Phone = "UIGuide_Combo_02_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Combo_02.T_Guide_Img_Combo_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Combo_02.T_Guide_Img_Combo_02'",
			},
		},
		GuideTitle = "UIGuide_Title_Combo_02",
		GuideType = "ImageText",
	},
	[1101] = {
		ChildGuideId = 1101,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_HardBoss_01",
				Phone = "UIGuide_HardBoss_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HardBoss_01.T_Guide_Img_HardBoss_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HardBoss_01.T_Guide_Img_HardBoss_01'",
			},
		},
		GuideTitle = "UIGuide_Title_HardBoss",
		GuideType = "ImageText",
	},
	[1102] = {
		ChildGuideId = 1102,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_HardBoss_02",
				Phone = "UIGuide_HardBoss_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HardBoss_02.T_Guide_Img_HardBoss_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HardBoss_02.T_Guide_Img_HardBoss_02'",
			},
		},
		GuideTitle = "UIGuide_Title_HardBoss",
		GuideType = "ImageText",
	},
	[1201] = {
		ChildGuideId = 1201,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ModTendency_1",
				Phone = "UIGuide_ModTendency_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Mod_01.T_Guide_Img_Mod_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Mod_01.T_Guide_Img_Mod_01'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_ModTendency_2",
				Phone = "UIGuide_ModTendency_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Mod_02.T_Guide_Img_Mod_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Mod_02.T_Guide_Img_Mod_02'",
			},
		},
		GuideTitle = "UIGuide_Title_ModTendency_1",
		GuideType = "ImageText",
	},
	[1204] = {
		ChildGuideId = 1204,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ModTendency_4",
				Phone = "UIGuide_ModTendency_4",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Mod_03.T_Guide_Img_Mod_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Mod_03.T_Guide_Img_Mod_03'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_ModTendency_5",
				Phone = "UIGuide_ModTendency_5",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Mod_04.T_Guide_Img_Mod_04'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Mod_04.T_Guide_Img_Mod_04'",
			},
		},
		GuideTitle = "UIGuide_Title_ModTendency_4",
		GuideType = "ImageText",
	},
	[1301] = {
		ChildGuideId = 1301,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_BulletJump_1_PC",
				Phone = "UIGuide_BulletJump_1_Phone",
			},
			GuidePicture = {
				PC = "FileMediaSource'/Game/Asset/UIVideo/Video_Guide_BulletJump_01.Video_Guide_BulletJump_01'",
				Phone = "FileMediaSource'/Game/Asset/UIVideo/Video_Guide_BulletJump_01.Video_Guide_BulletJump_01'",
			},
		},
		GuideTitle = "UIGuide_Title_BulletJump",
		GuideType = "ImageText",
	},
	[1302] = {
		ChildGuideId = 1302,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_BulletJump_2",
				Phone = "UIGuide_BulletJump_2",
			},
			GuidePicture = {
				PC = "FileMediaSource'/Game/Asset/UIVideo/Video_Guide_BulletJump_02.Video_Guide_BulletJump_02'",
				Phone = "FileMediaSource'/Game/Asset/UIVideo/Video_Guide_BulletJump_02.Video_Guide_BulletJump_02'",
			},
		},
		GuideTitle = "UIGuide_Title_BulletJump",
		GuideType = "ImageText",
	},
	[1401] = {
		ChildGuideId = 1401,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_WallJump_PC",
				Phone = "UIGuide_WallJump_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WallJump_01.T_Guide_Img_WallJump_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WallJump_01.T_Guide_Img_WallJump_01'",
			},
		},
		GuideTitle = "UIGuide_Title_WallJump",
		GuideType = "ImageText",
	},
	[1501] = {
		ChildGuideId = 1501,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Dodge_PC",
				Phone = "UIGuide_Dodge_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Dodge_01_PC.T_Guide_Img_Dodge_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Dodge_01_Phone.T_Guide_Img_Dodge_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Dodge",
		GuideType = "ImageText",
	},
	[1502] = {
		ChildGuideId = 1502,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Run_PC",
				Phone = "UIGuide_Run_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Run_01_PC.T_Guide_Img_Run_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Run_01_Phone.T_Guide_Img_Run_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Run",
		GuideType = "ImageText",
	},
	[1601] = {
		ChildGuideId = 1601,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_LockMonster_PC",
				Phone = "UIGuide_LockMonster_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LockMonster_01_PC.T_Guide_Img_LockMonster_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LockMonster_01_Phone.T_Guide_Img_LockMonster_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_LockMonster",
		GuideType = "ImageText",
	},
	[1701] = {
		ChildGuideId = 1701,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_BattleWheel_1",
				Phone = "UIGuide_BattleWheel_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_BattleWheel_01.T_Guide_Img_BattleWheel_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_BattleWheel_01.T_Guide_Img_BattleWheel_01'",
			},
		},
		GuideTitle = "UIGuide_Title_BattleWheel_1",
		GuideType = "ImageText",
	},
	[1702] = {
		ChildGuideId = 1702,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_BattleWheel_2_PC",
				Phone = "UIGuide_BattleWheel_2_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_BattleWheel_02.T_Guide_Img_BattleWheel_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_BattleWheel_02.T_Guide_Img_BattleWheel_02'",
			},
		},
		GuideTitle = "UIGuide_Title_BattleWheel_2",
		GuideType = "ImageText",
	},
	[1801] = {
		ChildGuideId = 1801,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Shadow_1",
				Phone = "UIGuide_Shadow_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Shadow_01.T_Guide_Img_Shadow_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Shadow_01.T_Guide_Img_Shadow_01'",
			},
		},
		GuideTitle = "UIGuide_Title_Shadow_1",
		GuideType = "ImageText",
	},
	[1802] = {
		ChildGuideId = 1802,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Shadow_2",
				Phone = "UIGuide_Shadow_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Shadow_02.T_Guide_Img_Shadow_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Shadow_02.T_Guide_Img_Shadow_02'",
			},
		},
		GuideTitle = "UIGuide_Title_Shadow_2",
		GuideType = "ImageText",
	},
	[1901] = {
		ChildGuideId = 1901,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Elevator",
				Phone = "UIGuide_Elevator",
			},
			GuidePicture = T.RT_6,
		},
		GuideTitle = "UIGuide_Title_Elevator",
		GuideType = "ImageText",
	},
	[2001] = {
		ChildGuideId = 2001,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TurnTable",
				Phone = "UIGuide_TurnTable",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TurnTable_01_Phone.T_Guide_Img_TurnTable_01_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TurnTable_01_Phone.T_Guide_Img_TurnTable_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_TurnTable",
		GuideType = "ImageText",
	},
	[2101] = {
		ChildGuideId = 2101,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ConnectMechanism",
				Phone = "UIGuide_ConnectMechanism",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ConnectMechanism_01_PC.T_Guide_Img_ConnectMechanism_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ConnectMechanism_01_Phone.T_Guide_Img_ConnectMechanism_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_ConnectMechanism",
		GuideType = "ImageText",
	},
	[2201] = {
		ChildGuideId = 2201,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_DamageMechanism_1",
				Phone = "UIGuide_DamageMechanism_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DamageMechanism_01.T_Guide_Img_DamageMechanism_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DamageMechanism_01.T_Guide_Img_DamageMechanism_01'",
			},
		},
		GuideTitle = "UIGuide_Title_DamageMechanism",
		GuideType = "ImageText",
	},
	[2202] = {
		ChildGuideId = 2202,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_DamageMechanism_2",
				Phone = "UIGuide_DamageMechanism_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DamageMechanism_02.T_Guide_Img_DamageMechanism_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DamageMechanism_02.T_Guide_Img_DamageMechanism_02'",
			},
		},
		GuideTitle = "UIGuide_Title_DamageMechanism",
		GuideType = "ImageText",
	},
	[2301] = {
		ChildGuideId = 2301,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Destructible",
				Phone = "UIGuide_Destructible",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Destructible_01.T_Guide_Img_Destructible_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Destructible_01.T_Guide_Img_Destructible_01'",
			},
		},
		GuideTitle = "UIGuide_Title_Destructible",
		GuideType = "ImageText",
	},
	[2501] = {
		ChildGuideId = 2501,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ExplorationMechanism_1_PC",
				Phone = "UIGuide_ExplorationMechanism_1_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExplorationMechanism_01_Phone.T_Guide_Img_ExplorationMechanism_01_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExplorationMechanism_01_Phone.T_Guide_Img_ExplorationMechanism_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_ExplorationMechanism_1",
		GuideType = "ImageText",
	},
	[2502] = {
		ChildGuideId = 2502,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ExplorationMechanism_2",
				Phone = "UIGuide_ExplorationMechanism_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExplorationMechanism_02.T_Guide_Img_ExplorationMechanism_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExplorationMechanism_02.T_Guide_Img_ExplorationMechanism_02'",
			},
		},
		GuideTitle = "UIGuide_Title_ExplorationMechanism_2",
		GuideType = "ImageText",
	},
	[2503] = {
		ChildGuideId = 2503,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ExplorationMechanism_3",
				Phone = "UIGuide_ExplorationMechanism_3",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExplorationMechanism_03.T_Guide_Img_ExplorationMechanism_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExplorationMechanism_03.T_Guide_Img_ExplorationMechanism_03'",
			},
		},
		GuideTitle = "UIGuide_Title_ExplorationMechanism_3",
		GuideType = "ImageText",
	},
	[2601] = {
		ChildGuideId = 2601,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_CursorActivation",
				Phone = "UIGuide_CursorActivation",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_CursorActivation_01.T_Guide_Img_CursorActivation_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_CursorActivation_01.T_Guide_Img_CursorActivation_01'",
			},
		},
		GuideTitle = "UIGuide_Title_CursorActivation",
		GuideType = "ImageText",
	},
	[2701] = {
		ChildGuideId = 2701,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Reading",
				Phone = "UIGuide_Reading",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Reading_01_Phone.T_Guide_Img_Reading_01_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Reading_01_Phone.T_Guide_Img_Reading_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Reading",
		GuideType = "ImageText",
	},
	[2901] = {
		ChildGuideId = 2901,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ImpressionSystem_1",
				Phone = "UIGuide_ImpressionSystem_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionSystem_01_Phone.T_Guide_Img_ImpressionSystem_01_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionSystem_01_Phone.T_Guide_Img_ImpressionSystem_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_ImpressionSystem_1",
		GuideType = "ImageText",
	},
	[2902] = {
		ChildGuideId = 2902,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ImpressionSystem_2",
				Phone = "UIGuide_ImpressionSystem_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionSystem_02_Phone.T_Guide_Img_ImpressionSystem_02_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionSystem_02_Phone.T_Guide_Img_ImpressionSystem_02_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_ImpressionSystem_2",
		GuideType = "ImageText",
	},
	[2903] = {
		ChildGuideId = 2903,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ImpressionShop_1",
				Phone = "UIGuide_ImpressionShop_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionShop_01.T_Guide_Img_ImpressionShop_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionShop_01.T_Guide_Img_ImpressionShop_01'",
			},
		},
		GuideTitle = "UIGuide_Title_ImpressionShop",
		GuideType = "ImageText",
	},
	[2904] = {
		ChildGuideId = 2904,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ImpressionShop_2",
				Phone = "UIGuide_ImpressionShop_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionShop_02.T_Guide_Img_ImpressionShop_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionShop_02.T_Guide_Img_ImpressionShop_02'",
			},
		},
		GuideTitle = "UIGuide_Title_ImpressionShop",
		GuideType = "ImageText",
	},
	[3001] = {
		ChildGuideId = 3001,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ImpressionCheck_1",
				Phone = "UIGuide_ImpressionCheck_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionCheck_01.T_Guide_Img_ImpressionCheck_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionCheck_01.T_Guide_Img_ImpressionCheck_01'",
			},
		},
		GuideTitle = "UIGuide_Title_ImpressionCheck_1",
		GuideType = "ImageText",
	},
	[3002] = {
		ChildGuideId = 3002,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ImpressionCheck_2",
				Phone = "UIGuide_ImpressionCheck_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionCheck_02.T_Guide_Img_ImpressionCheck_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ImpressionCheck_02.T_Guide_Img_ImpressionCheck_02'",
			},
		},
		GuideTitle = "UIGuide_Title_ImpressionCheck_2",
		GuideType = "ImageText",
	},
	[3101] = {
		ChildGuideId = 3101,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Biography",
				Phone = "UIGuide_Biography",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Biography_01_Phone.T_Guide_Img_Biography_01_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Biography_01_Phone.T_Guide_Img_Biography_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Biography",
		GuideType = "ImageText",
	},
	[3201] = {
		ChildGuideId = 3201,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Phantom_1_1",
				Phone = "UIGuide_Phantom_1_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_01_01_PC.T_Guide_Img_Phantom_01_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_01_01_Phone.T_Guide_Img_Phantom_01_01_Phone'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_Phantom_1_2",
				Phone = "UIGuide_Phantom_1_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_01_02_PC.T_Guide_Img_Phantom_01_02_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_01_02_Phone.T_Guide_Img_Phantom_01_02_Phone'",
			},
		},
		GuideInfo3 = {
			GuideContent = {
				PC = "UIGuide_Phantom_1_3",
				Phone = "UIGuide_Phantom_1_3",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_01_03_PC.T_Guide_Img_Phantom_01_03_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_01_03_Phone.T_Guide_Img_Phantom_01_03_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Phantom_1",
		GuideType = "ImageText",
	},
	[3202] = {
		ChildGuideId = 3202,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Phantom_2_1",
				Phone = "UIGuide_Phantom_2_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_02_01_PC.T_Guide_Img_Phantom_02_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_02_01_Phone.T_Guide_Img_Phantom_02_01_Phone'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_Phantom_2_2",
				Phone = "UIGuide_Phantom_2_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_02_02_PC.T_Guide_Img_Phantom_02_02_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_02_02_Phone.T_Guide_Img_Phantom_02_02_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Phantom_2",
		GuideType = "ImageText",
	},
	[3203] = {
		ChildGuideId = 3203,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Phantom_3_1",
				Phone = "UIGuide_Phantom_3_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_03_01_PC.T_Guide_Img_Phantom_03_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_03_01_Phone.T_Guide_Img_Phantom_03_01_Phone'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_Phantom_3_2",
				Phone = "UIGuide_Phantom_3_2_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_03_02.T_Guide_Img_Phantom_03_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_03_02.T_Guide_Img_Phantom_03_02'",
			},
		},
		GuideInfo3 = {
			GuideContent = {
				PC = "UIGuide_Phantom_3_3",
				Phone = "UIGuide_Phantom_3_3",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_03_03.T_Guide_Img_Phantom_03_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Phantom_03_03.T_Guide_Img_Phantom_03_03'",
			},
		},
		GuideTitle = "UIGuide_Title_Phantom_3",
		GuideType = "ImageText",
	},
	[3204] = {
		ChildGuideId = 3204,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Phantom_4_1",
				Phone = "UIGuide_Phantom_4_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Phantom_04_01_PC.T_Guide_Img_Phantom_04_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Phantom_04_01_PC.T_Guide_Img_Phantom_04_01_PC'",
			},
		},
		GuideTitle = "UIGuide_Title_Phantom_4",
		GuideType = "ImageText",
	},
	[3301] = {
		ChildGuideId = 3301,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TrainingGround_1",
				Phone = "UIGuide_TrainingGround_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TraingGround_01.T_Guide_Img_TraingGround_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TraingGround_01.T_Guide_Img_TraingGround_01'",
			},
		},
		GuideTitle = "UIGuide_Title_TrainingGround_1",
		GuideType = "ImageText",
	},
	[3302] = {
		ChildGuideId = 3302,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TrainingGround_2",
				Phone = "UIGuide_TrainingGround_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TraingGround_02.T_Guide_Img_TraingGround_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TraingGround_02.T_Guide_Img_TraingGround_02'",
			},
		},
		GuideTitle = "UIGuide_Title_TrainingGround_2",
		GuideType = "ImageText",
	},
	[3303] = {
		ChildGuideId = 3303,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TrainingGround_3_PC",
				Phone = "UIGuide_TrainingGround_3_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TraingGround_03.T_Guide_Img_TraingGround_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TraingGround_03.T_Guide_Img_TraingGround_03'",
			},
		},
		GuideTitle = "UIGuide_Title_TrainingGround_3",
		GuideType = "ImageText",
	},
	[3401] = {
		ChildGuideId = 3401,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TrainingGround_4_PC",
				Phone = "UIGuide_TrainingGround_4_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LeaveTrainingGround_01.T_Guide_Img_LeaveTrainingGround_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LeaveTrainingGround_01.T_Guide_Img_LeaveTrainingGround_01'",
			},
		},
		GuideTitle = "UIGuide_Title_TrainingGround_4",
		GuideType = "ImageText",
	},
	[3501] = {
		ChildGuideId = 3501,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_AssistanceSkill",
				Phone = "UIGuide_AssistanceSkill",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AssistanceSkill_01_PC.T_Guide_Img_AssistanceSkill_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AssistanceSkill_01_Phone.T_Guide_Img_AssistanceSkill_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_AssistanceSkill",
		GuideType = "ImageText",
	},
	[3601] = {
		ChildGuideId = 3601,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Sp",
				Phone = "UIGuide_Sp",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Sp_01_PC.T_Guide_Img_Sp_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Sp_01_Phone.T_Guide_Img_Sp_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Sp",
		GuideType = "ImageText",
	},
	[3701] = {
		ChildGuideId = 3701,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TriggerEffect_1",
				Phone = "UIGuide_TriggerEffect_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TriggerEffect_01.T_Guide_Img_TriggerEffect_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TriggerEffect_01.T_Guide_Img_TriggerEffect_01'",
			},
		},
		GuideTitle = "UIGuide_Title_TriggerEffect",
		GuideType = "ImageText",
	},
	[3702] = {
		ChildGuideId = 3702,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TriggerEffect_2",
				Phone = "UIGuide_TriggerEffect_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TriggerEffect_02.T_Guide_Img_TriggerEffect_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TriggerEffect_02.T_Guide_Img_TriggerEffect_02'",
			},
		},
		GuideTitle = "UIGuide_Title_TriggerEffect",
		GuideType = "ImageText",
	},
	[3703] = {
		ChildGuideId = 3703,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TriggerEffect_3",
				Phone = "UIGuide_TriggerEffect_3",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TriggerEffect_03.T_Guide_Img_TriggerEffect_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TriggerEffect_03.T_Guide_Img_TriggerEffect_03'",
			},
		},
		GuideTitle = "UIGuide_Title_TriggerEffect",
		GuideType = "ImageText",
	},
	[3801] = {
		ChildGuideId = 3801,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_BonusDamage",
				Phone = "UIGuide_BonusDamage",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_BonusDamage_01.T_Guide_Img_BonusDamage_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_BonusDamage_01.T_Guide_Img_BonusDamage_01'",
			},
		},
		GuideTitle = "UIGuide_Title_BonusDamage",
		GuideType = "ImageText",
	},
	[3901] = {
		ChildGuideId = 3901,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Dot",
				Phone = "UIGuide_Dot",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Dot_01.T_Guide_Img_Dot_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Dot_01.T_Guide_Img_Dot_01'",
			},
		},
		GuideTitle = "UIGuide_Title_Dot",
		GuideType = "ImageText",
	},
	[4001] = {
		ChildGuideId = 4001,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_FireMechanism",
				Phone = "UIGuide_FireMechanism",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FireMechanism_01.T_Guide_Img_FireMechanism_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FireMechanism_01.T_Guide_Img_FireMechanism_01'",
			},
		},
		GuideTitle = "UIGuide_Title_FireMechanism",
		GuideType = "ImageText",
	},
	[4101] = {
		ChildGuideId = 4101,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_ValveMechanism",
				Phone = "UIGuide_ValveMechanism",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ValveMechanism_01_Phone.T_Guide_Img_ValveMechanism_01_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ValveMechanism_01_Phone.T_Guide_Img_ValveMechanism_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_ValveMechanism",
		GuideType = "ImageText",
	},
	[4201] = {
		ChildGuideId = 4201,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_EX01Mechanism_1",
				Phone = "UIGuide_EX01Mechanism_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_EX01_Mechanism_01.T_Guide_Img_EX01_Mechanism_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_EX01_Mechanism_01.T_Guide_Img_EX01_Mechanism_01'",
			},
		},
		GuideTitle = "UIGuide_Title_EX01Mechanism_1",
		GuideType = "ImageText",
	},
	[4202] = {
		ChildGuideId = 4202,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_EX01Mechanism_2",
				Phone = "UIGuide_EX01Mechanism_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_EX01_Mechanism_02.T_Guide_Img_EX01_Mechanism_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_EX01_Mechanism_02.T_Guide_Img_EX01_Mechanism_02'",
			},
		},
		GuideTitle = "UIGuide_Title_EX01Mechanism_2",
		GuideType = "ImageText",
	},
	[4301] = {
		ChildGuideId = 4301,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Temple_1",
				Phone = "UIGuide_Temple_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Temple_01_Phone.T_Guide_Img_Temple_01_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Temple_01_Phone.T_Guide_Img_Temple_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Temple_1",
		GuideType = "ImageText",
	},
	[4302] = {
		ChildGuideId = 4302,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Temple_2",
				Phone = "UIGuide_Temple_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Temple_02.T_Guide_Img_Temple_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Temple_02.T_Guide_Img_Temple_02'",
			},
		},
		GuideTitle = "UIGuide_Title_Temple_2",
		GuideType = "ImageText",
	},
	[4303] = {
		ChildGuideId = 4303,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Temple_3",
				Phone = "UIGuide_Temple_3",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Temple_03.T_Guide_Img_Temple_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Temple_03.T_Guide_Img_Temple_03'",
			},
		},
		GuideTitle = "UIGuide_Title_Temple_1",
		GuideType = "ImageText",
	},
	[4501] = {
		ChildGuideId = 4501,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Team_1",
				Phone = "UIGuide_Team_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Team_01.T_Guide_Img_Team_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Team_01.T_Guide_Img_Team_01'",
			},
		},
		GuideTitle = "UIGuide_Title_Team",
		GuideType = "ImageText",
	},
	[4502] = {
		ChildGuideId = 4502,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Team_2_PC",
				Phone = "UIGuide_Team_2_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Team_02_PC.T_Guide_Img_Team_02_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Team_02_Phone.T_Guide_Img_Team_02_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Team",
		GuideType = "ImageText",
	},
	[4601] = {
		ChildGuideId = 4601,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Online_01_01",
				Phone = "UIGuide_Online_01_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_01_01_PC.T_Guide_Img_Online_01_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_01_01_Phone.T_Guide_Img_Online_01_01_Phone'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_Online_01_02",
				Phone = "UIGuide_Online_01_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_01_02.T_Guide_Img_Online_01_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_01_02.T_Guide_Img_Online_01_02'",
			},
		},
		GuideTitle = "UIGuide_Title_Online_1",
		GuideType = "ImageText",
	},
	[4602] = {
		ChildGuideId = 4602,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Online_02_01",
				Phone = "UIGuide_Online_02_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_02_01.T_Guide_Img_Online_02_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_02_01.T_Guide_Img_Online_02_01'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_Online_02_02",
				Phone = "UIGuide_Online_02_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_02_02.T_Guide_Img_Online_02_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_02_02.T_Guide_Img_Online_02_02'",
			},
		},
		GuideTitle = "UIGuide_Title_Online_2",
		GuideType = "ImageText",
	},
	[4603] = {
		ChildGuideId = 4603,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Online_03_01",
				Phone = "UIGuide_Online_03_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_03_01.T_Guide_Img_Online_03_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_03_01.T_Guide_Img_Online_03_01'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_Online_03_02",
				Phone = "UIGuide_Online_03_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_03_02.T_Guide_Img_Online_03_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_03_02.T_Guide_Img_Online_03_02'",
			},
		},
		GuideTitle = "UIGuide_Title_Online_3",
		GuideType = "ImageText",
	},
	[4604] = {
		ChildGuideId = 4604,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Online_04_01",
				Phone = "UIGuide_Online_04_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_04_01.T_Guide_Img_Online_04_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_04_01.T_Guide_Img_Online_04_01'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_Online_04_02",
				Phone = "UIGuide_Online_04_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_04_02.T_Guide_Img_Online_04_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_04_02.T_Guide_Img_Online_04_02'",
			},
		},
		GuideInfo3 = {
			GuideContent = {
				PC = "UIGuide_Online_04_03",
				Phone = "UIGuide_Online_04_03",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_04_03.T_Guide_Img_Online_04_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_04_03.T_Guide_Img_Online_04_03'",
			},
		},
		GuideTitle = "UIGuide_Title_Online_4",
		GuideType = "ImageText",
	},
	[4605] = {
		ChildGuideId = 4605,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Online_05_01",
				Phone = "UIGuide_Online_05_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_05_01_PC.T_Guide_Img_Online_05_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_05_01_Phone.T_Guide_Img_Online_05_01_Phone'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_Online_05_02",
				Phone = "UIGuide_Online_05_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_05_02.T_Guide_Img_Online_05_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_05_02.T_Guide_Img_Online_05_02'",
			},
		},
		GuideTitle = "UIGuide_Title_Online_5",
		GuideType = "ImageText",
	},
	[4606] = {
		ChildGuideId = 4606,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Online_06_01",
				Phone = "UIGuide_Online_06_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_06_01.T_Guide_Img_Online_06_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Online_06_01.T_Guide_Img_Online_06_01'",
			},
		},
		GuideTitle = "UIGuide_Title_Online_6",
		GuideType = "ImageText",
	},
	[4701] = {
		ChildGuideId = 4701,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_DynStory_1",
				Phone = "UIGuide_DynStory_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DynStory_01.T_Guide_Img_DynStory_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DynStory_01.T_Guide_Img_DynStory_01'",
			},
		},
		GuideTitle = "UIGuide_Title_DynStory",
		GuideType = "ImageText",
	},
	[4702] = {
		ChildGuideId = 4702,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_DynStory_2",
				Phone = "UIGuide_DynStory_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DynStory_02.T_Guide_Img_DynStory_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DynStory_02.T_Guide_Img_DynStory_02'",
			},
		},
		GuideTitle = "UIGuide_Title_DynStory",
		GuideType = "ImageText",
	},
	[4801] = {
		ChildGuideId = 4801,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_LayeredMap_1",
				Phone = "UIGuide_LayeredMap_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LayeredMap_01.T_Guide_Img_LayeredMap_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LayeredMap_01.T_Guide_Img_LayeredMap_01'",
			},
		},
		GuideTitle = "UIGuide_Title_LayeredMap_1",
		GuideType = "ImageText",
	},
	[4802] = {
		ChildGuideId = 4802,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_LayeredMap_2",
				Phone = "UIGuide_LayeredMap_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LayeredMap_02.T_Guide_Img_LayeredMap_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LayeredMap_02.T_Guide_Img_LayeredMap_02'",
			},
		},
		GuideTitle = "UIGuide_Title_LayeredMap_2",
		GuideType = "ImageText",
	},
	[4901] = {
		ChildGuideId = 4901,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Pet_1",
				Phone = "UIGuide_Pet_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Pet_02.T_Guide_Img_Pet_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Pet_02.T_Guide_Img_Pet_02'",
			},
		},
		GuideTitle = "UIGuide_Title_Pet",
		GuideType = "ImageText",
	},
	[4902] = {
		ChildGuideId = 4902,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Pet_2",
				Phone = "UIGuide_Pet_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Pet_01.T_Guide_Img_Pet_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Pet_01.T_Guide_Img_Pet_01'",
			},
		},
		GuideTitle = "UIGuide_Title_Pet",
		GuideType = "ImageText",
	},
	[5001] = {
		ChildGuideId = 5001,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_SwitchMaster_PC",
				Phone = "UIGuide_SwitchMaster_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_SwitchMaster_01_PC.T_Guide_Img_SwitchMaster_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_SwitchMaster_01_Phone.T_Guide_Img_SwitchMaster_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_SwitchMaster",
		GuideType = "ImageText",
	},
	[5101] = {
		ChildGuideId = 5101,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_RelayMechanism_1",
				Phone = "UIGuide_RelayMechanism_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_RelayMechanism_01.T_Guide_Img_RelayMechanism_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_RelayMechanism_01.T_Guide_Img_RelayMechanism_01'",
			},
		},
		GuideTitle = "UIGuide_Title_RelayMechanism_1",
		GuideType = "ImageText",
	},
	[5102] = {
		ChildGuideId = 5102,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_RelayMechanism_2",
				Phone = "UIGuide_RelayMechanism_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_RelayMechanism_02.T_Guide_Img_RelayMechanism_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_RelayMechanism_02.T_Guide_Img_RelayMechanism_02'",
			},
		},
		GuideTitle = "UIGuide_Title_RelayMechanism_2",
		GuideType = "ImageText",
	},
	[5201] = {
		ChildGuideId = 5201,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Fort_1_PC",
				Phone = "UIGuide_Fort_1_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fort_01_Phone.T_Guide_Img_Fort_01_Phone'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fort_01_Phone.T_Guide_Img_Fort_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Fort",
		GuideType = "ImageText",
	},
	[5202] = {
		ChildGuideId = 5202,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Fort_2",
				Phone = "UIGuide_Fort_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fort_02_PC.T_Guide_Img_Fort_02_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fort_02_Phone.T_Guide_Img_Fort_02_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_Fort",
		GuideType = "ImageText",
	},
	[5301] = {
		ChildGuideId = 5301,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_MonsterExitMechanism_1",
				Phone = "UIGuide_MonsterExitMechanism_1",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_MonsterExitMechanism_01.T_Guide_Img_MonsterExitMechanism_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_MonsterExitMechanism_01.T_Guide_Img_MonsterExitMechanism_01'",
			},
		},
		GuideTitle = "UIGuide_Title_MonsterExitMechanism",
		GuideType = "ImageText",
	},
	[5302] = {
		ChildGuideId = 5302,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_MonsterExitMechanism_2",
				Phone = "UIGuide_MonsterExitMechanism_2",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_MonsterExitMechanism_02.T_Guide_Img_MonsterExitMechanism_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_MonsterExitMechanism_02.T_Guide_Img_MonsterExitMechanism_02'",
			},
		},
		GuideTitle = "UIGuide_Title_MonsterExitMechanism",
		GuideType = "ImageText",
	},
	[5501] = {
		ChildGuideId = 5501,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_LongPressedSkills",
				Phone = "UIGuide_LongPressedSkills",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongPressedSkills_01_PC.T_Guide_Img_LongPressedSkills_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongPressedSkills_01_Phone.T_Guide_Img_LongPressedSkills_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_LongPressedSkills",
		GuideType = "ImageText",
	},
	[5601] = {
		ChildGuideId = 5601,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_PerfectDodge",
				Phone = "UIGuide_PerfectDodge",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PerfectDodge_01_PC.T_Guide_Img_PerfectDodge_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PerfectDodge_01_Phone.T_Guide_Img_PerfectDodge_01_Phone'",
			},
		},
		GuideTitle = "UIGuide_Title_PerfectDodge",
		GuideType = "ImageText",
	},
	[5701] = {
		ChildGuideId = 5701,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TaskAcceptance",
				Phone = "UIGuide_TaskAcceptance",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TaskAcceptance_01.T_Guide_Img_TaskAcceptance_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TaskAcceptance_01.T_Guide_Img_TaskAcceptance_01'",
			},
		},
		GuideTitle = "UIGuide_Title_TaskAcceptance",
		GuideType = "ImageText",
	},
	[5801] = {
		ChildGuideId = 5801,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_EX01Map",
				Phone = "UIGuide_EX01Map",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_EX01Map.T_Guide_Img_EX01Map'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_EX01Map.T_Guide_Img_EX01Map'",
			},
		},
		GuideTitle = "UIGuide_Title_EX01Map",
		GuideType = "ImageText",
	},
	[6901] = {
		ChildGuideId = 6901,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_WIKI_01",
				Phone = "UIGuide_WIKI_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WIKI_01.T_Guide_Img_WIKI_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WIKI_01.T_Guide_Img_WIKI_01'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_WIKI",
		GuideType = "ImageText",
	},
	[6902] = {
		ChildGuideId = 6902,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_WIKI_02",
				Phone = "UIGuide_WIKI_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WIKI_02.T_Guide_Img_WIKI_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WIKI_02.T_Guide_Img_WIKI_02'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_WIKI",
		GuideType = "ImageText",
	},
	[7001] = {
		ChildGuideId = 7001,
		GuideInfo1 = T.RT_9,
		GuideTitle = "UIGUIDE_TITLE_SIDEWAYSJUMP",
		GuideType = "ImageText",
	},
	[7101] = {
		ChildGuideId = 7101,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_PetPan_01",
				Phone = "UIGuide_PetPan_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetPan_01.T_Guide_Img_PetPan_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetPan_01.T_Guide_Img_PetPan_01'",
			},
		},
		GuideTitle = "UIGuide_PetPan_Title",
		GuideType = "ImageText",
	},
	[7102] = {
		ChildGuideId = 7102,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_PetPan_02",
				Phone = "UIGuide_PetPan_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetPan_02.T_Guide_Img_PetPan_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetPan_02.T_Guide_Img_PetPan_02'",
			},
		},
		GuideTitle = "UIGuide_PetPan_Title",
		GuideType = "ImageText",
	},
	[7201] = {
		ChildGuideId = 7201,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Fish_01",
				Phone = "UIGuide_Fish_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_01.T_Guide_Img_Fishing_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_01.T_Guide_Img_Fishing_01'",
			},
		},
		GuideTitle = "UIGuide_Fish_SubTitle_1",
		GuideType = "ImageText",
	},
	[7202] = {
		ChildGuideId = 7202,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Fish_02",
				Phone = "UIGuide_Fish_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_02.T_Guide_Img_Fishing_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_02.T_Guide_Img_Fishing_02'",
			},
		},
		GuideTitle = "UIGuide_Fish_SubTitle_2",
		GuideType = "ImageText",
	},
	[7203] = {
		ChildGuideId = 7203,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Fish_03",
				Phone = "UIGuide_Fish_03",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_03.T_Guide_Img_Fishing_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_03.T_Guide_Img_Fishing_03'",
			},
		},
		GuideTitle = "UIGuide_Fish_SubTitle_3",
		GuideType = "ImageText",
	},
	[7204] = {
		ChildGuideId = 7204,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Fish_04",
				Phone = "UIGuide_Fish_04",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_04.T_Guide_Img_Fishing_04'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_04.T_Guide_Img_Fishing_04'",
			},
		},
		GuideTitle = "UIGuide_Fish_SubTitle_4",
		GuideType = "ImageText",
	},
	[7205] = {
		ChildGuideId = 7205,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Fish_05",
				Phone = "UIGuide_Fish_05",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_05.T_Guide_Img_Fishing_05'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_05.T_Guide_Img_Fishing_05'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Fishing_05.T_Guide_Img_Fishing_05'",
			},
		},
		GuideTitle = "UIGuide_Fish_SubTitle_5",
		GuideType = "ImageText",
	},
	[7301] = {
		ChildGuideId = 7301,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_SpecialSideStoryUI1",
				Phone = "UIGuide_SpecialSideStoryUI1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_SpecialSideStory_01.T_Guide_Img_SpecialSideStory_01'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_SpecialSideStory_01.T_Guide_Img_SpecialSideStory_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_SpecialSideStory_01.T_Guide_Img_SpecialSideStory_01'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_SpecialSideStoryUI",
		GuideType = "ImageText",
	},
	[7302] = {
		ChildGuideId = 7302,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_SpecialSideStoryUI2",
				Phone = "UIGuide_SpecialSideStoryUI2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_SpecialSideStory_02.T_Guide_Img_SpecialSideStory_02'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_SpecialSideStory_02.T_Guide_Img_SpecialSideStory_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_SpecialSideStory_02.T_Guide_Img_SpecialSideStory_02'",
			},
		},
		GuideTitle = "UIGUIDE_TITLE_SpecialSideStoryUI",
		GuideType = "ImageText",
	},
	[7401] = {
		ChildGuideId = 7401,
		GuideInfo1 = T.RT_9,
		GuideTitle = "UIGUIDE_TITLE_DailyGoalUI",
		GuideType = "ImageText",
	},
	[7501] = {
		ChildGuideId = 7501,
		GuideInfo1 = T.RT_9,
		GuideTitle = "UIGUIDE_TITLE_ModArchiveUI",
		GuideType = "ImageText",
	},
	[7601] = {
		ChildGuideId = 7601,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_Abyss_1",
				PC = "UIGuide_Abyss_1",
				Phone = "UIGuide_Abyss_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_1.T_Guide_Img_Abyss_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_1.T_Guide_Img_Abyss_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_1.T_Guide_Img_Abyss_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ABYSS",
		GuideType = "ImageText",
	},
	[7602] = {
		ChildGuideId = 7602,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_Abyss_2",
				PC = "UIGuide_Abyss_2",
				Phone = "UIGuide_Abyss_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_2.T_Guide_Img_Abyss_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_2.T_Guide_Img_Abyss_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_2.T_Guide_Img_Abyss_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ABYSS_2",
		GuideType = "ImageText",
	},
	[7603] = {
		ChildGuideId = 7603,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_Abyss_3_1",
				PC = "UIGuide_Abyss_3_1",
				Phone = "UIGuide_Abyss_3_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_3_1.T_Guide_Img_Abyss_3_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_3_1.T_Guide_Img_Abyss_3_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_3_1.T_Guide_Img_Abyss_3_1'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				GamePad = "UIGuide_Abyss_3_2",
				PC = "UIGuide_Abyss_3_2",
				Phone = "UIGuide_Abyss_3_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_3_2.T_Guide_Img_Abyss_3_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_3_2.T_Guide_Img_Abyss_3_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_3_2.T_Guide_Img_Abyss_3_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ABYSS_3",
		GuideType = "ImageText",
	},
	[7604] = {
		ChildGuideId = 7604,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_Abyss_4",
				PC = "UIGuide_Abyss_4",
				Phone = "UIGuide_Abyss_4",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_4.T_Guide_Img_Abyss_4'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_4.T_Guide_Img_Abyss_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_4.T_Guide_Img_Abyss_4'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ABYSS_4",
		GuideType = "ImageText",
	},
	[7605] = {
		ChildGuideId = 7605,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_Abyss_5",
				PC = "UIGuide_Abyss_5",
				Phone = "UIGuide_Abyss_5",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_5.T_Guide_Img_Abyss_5'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_5.T_Guide_Img_Abyss_5'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Abyss_5.T_Guide_Img_Abyss_5'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ABYSS_5",
		GuideType = "ImageText",
	},
	[7701] = {
		ChildGuideId = 7701,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Rouge_1",
				Phone = "UIGuide_Rouge_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_1.T_Guide_Img_Rouge_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_1.T_Guide_Img_Rouge_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_1.T_Guide_Img_Rouge_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ROUGE",
		GuideType = "ImageText",
	},
	[7702] = {
		ChildGuideId = 7702,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_Rouge_2_1",
				PC = "UIGuide_Rouge_2_1",
				Phone = "UIGuide_Rouge_2_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_2_1.T_Guide_Img_Rouge_2_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_2_1.T_Guide_Img_Rouge_2_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_2_1.T_Guide_Img_Rouge_2_1'",
			},
		},
		GuideInfo2 = {
			GuideContent = {
				GamePad = "UIGuide_Rouge_2_3",
				PC = "UIGuide_Rouge_2_3",
				Phone = "UIGuide_Rouge_2_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_2_2.T_Guide_Img_Rouge_2_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_2_2.T_Guide_Img_Rouge_2_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_2_2.T_Guide_Img_Rouge_2_2'",
			},
		},
		GuideInfo3 = {
			GuideContent = {
				GamePad = "UIGuide_Rouge_2_2",
				PC = "UIGuide_Rouge_2_2",
				Phone = "UIGuide_Rouge_2_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_2_3.T_Guide_Img_Rouge_2_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_2_3.T_Guide_Img_Rouge_2_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Rouge_2_3.T_Guide_Img_Rouge_2_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ROUGE",
		GuideType = "ImageText",
	},
	[7801] = {
		ChildGuideId = 7801,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_PetTrain_4",
				PC = "Message_Guide_PetTrain_4",
				Phone = "Message_Guide_PetTrain_4",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_1.T_Guide_Img_PetTrain_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_1.T_Guide_Img_PetTrain_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_1.T_Guide_Img_PetTrain_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_PETTRAIN",
		GuideType = "ImageText",
	},
	[7802] = {
		ChildGuideId = 7802,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_PetTrain_5",
				PC = "Message_Guide_PetTrain_5",
				Phone = "Message_Guide_PetTrain_5",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_2.T_Guide_Img_PetTrain_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_2.T_Guide_Img_PetTrain_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_2.T_Guide_Img_PetTrain_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_PETTRAIN",
		GuideType = "ImageText",
	},
	[7803] = {
		ChildGuideId = 7803,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_PetTrain_6",
				PC = "Message_Guide_PetTrain_6",
				Phone = "Message_Guide_PetTrain_6",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_3.T_Guide_Img_PetTrain_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_3.T_Guide_Img_PetTrain_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_3.T_Guide_Img_PetTrain_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_PETTRAIN",
		GuideType = "ImageText",
	},
	[7804] = {
		ChildGuideId = 7804,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_PetTrain_7",
				PC = "Message_Guide_PetTrain_7",
				Phone = "Message_Guide_PetTrain_7",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_4.T_Guide_Img_PetTrain_4'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_4.T_Guide_Img_PetTrain_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_PetTrain_4.T_Guide_Img_PetTrain_4'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_PETTRAIN",
		GuideType = "ImageText",
	},
	[7901] = {
		ChildGuideId = 7901,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_DungeonSec_3",
				PC = "Message_Guide_DungeonSec_3",
				Phone = "Message_Guide_DungeonSec_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DungeonSec_1.T_Guide_Img_DungeonSec_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DungeonSec_1.T_Guide_Img_DungeonSec_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DungeonSec_1.T_Guide_Img_DungeonSec_1'",
			},
		},
		GuideTitle = "UI_Dungeon_Tab_WalnutDungeon",
		GuideType = "ImageText",
	},
	[7902] = {
		ChildGuideId = 7902,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_DungeonSec_1",
				PC = "Message_Guide_DungeonSec_1",
				Phone = "Message_Guide_DungeonSec_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DungeonSec_2.T_Guide_Img_DungeonSec_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DungeonSec_2.T_Guide_Img_DungeonSec_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DungeonSec_2.T_Guide_Img_DungeonSec_2'",
			},
		},
		GuideTitle = "UI_Dungeon_Tab_WalnutDungeon",
		GuideType = "ImageText",
	},
	[7903] = {
		ChildGuideId = 7903,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_DungeonSec_2",
				PC = "Message_Guide_DungeonSec_2",
				Phone = "Message_Guide_DungeonSec_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DungeonSec_3.T_Guide_Img_DungeonSec_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DungeonSec_3.T_Guide_Img_DungeonSec_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DungeonSec_3.T_Guide_Img_DungeonSec_3'",
			},
		},
		GuideTitle = "UI_Dungeon_Tab_WalnutDungeon",
		GuideType = "ImageText",
	},
	[8001] = {
		ChildGuideId = 8001,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_OnlineArea_1",
				PC = "Message_Guide_OnlineArea_1",
				Phone = "Message_Guide_OnlineArea_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_01.T_Guide_Img_OnlineArea_01'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_01.T_Guide_Img_OnlineArea_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_01.T_Guide_Img_OnlineArea_01'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ONLINEAREA",
		GuideType = "ImageText",
	},
	[8002] = {
		ChildGuideId = 8002,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_OnlineArea_2",
				PC = "Message_Guide_OnlineArea_2",
				Phone = "Message_Guide_OnlineArea_2",
			},
			GuidePicture = T.RT_10,
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ONLINEAREA",
		GuideType = "ImageText",
	},
	[8003] = {
		ChildGuideId = 8003,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_OnlineArea_3",
				PC = "Message_Guide_OnlineArea_3",
				Phone = "Message_Guide_OnlineArea_3",
			},
			GuidePicture = T.RT_11,
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ONLINEAREA",
		GuideType = "ImageText",
	},
	[8101] = {
		ChildGuideId = 8101,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Hook_PC",
				Phone = "UIGuide_Hook_Phone",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Hook_01.T_Guide_Img_Hook_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Hook_01.T_Guide_Img_Hook_01'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_HOOK",
		GuideType = "ImageText",
	},
	[8201] = {
		ChildGuideId = 8201,
		GuideInfo1 = {
			GuideContent = T.RT_12,
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExploreBadge_01.T_Guide_Img_ExploreBadge_01'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExploreBadge_01.T_Guide_Img_ExploreBadge_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExploreBadge_01.T_Guide_Img_ExploreBadge_01'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Badge",
		GuideType = "ImageText",
	},
	[8202] = {
		ChildGuideId = 8202,
		GuideInfo1 = {
			GuideContent = T.RT_12,
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExploreBadge_02.T_Guide_Img_ExploreBadge_02'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExploreBadge_02.T_Guide_Img_ExploreBadge_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ExploreBadge_02.T_Guide_Img_ExploreBadge_02'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Badge",
		GuideType = "ImageText",
	},
	[8301] = {
		ChildGuideId = 8301,
		GuideInfo1 = {
			GuideContent = {
				PC = "Message_Guide_Treasure_1",
				Phone = "Message_Guide_Treasure_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Treasure_01.T_Guide_Img_Treasure_01'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Treasure_01.T_Guide_Img_Treasure_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Treasure_01.T_Guide_Img_Treasure_01'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Treasure",
		GuideType = "ImageText",
	},
	[8302] = {
		ChildGuideId = 8302,
		GuideInfo1 = {
			GuideContent = {
				PC = "Message_Guide_Treasure_2",
				Phone = "Message_Guide_Treasure_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Treasure_02.T_Guide_Img_Treasure_02'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Treasure_02.T_Guide_Img_Treasure_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Treasure_02.T_Guide_Img_Treasure_02'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Treasure",
		GuideType = "ImageText",
	},
	[8401] = {
		ChildGuideId = 8401,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_MirrorPuzzle_1",
				Phone = "UIGuide_MirrorPuzzle_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_MirrorPuzzle_01.T_Guide_Img_MirrorPuzzle_01'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_MirrorPuzzle_01.T_Guide_Img_MirrorPuzzle_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_MirrorPuzzle_01.T_Guide_Img_MirrorPuzzle_01'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_MirrorPuzzle",
		GuideType = "ImageText",
	},
	[8501] = {
		ChildGuideId = 8501,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TrialRank_1",
				Phone = "UIGuide_TrialRank_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Trailrank_01.T_Guide_Img_Trailrank_01'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Trailrank_01.T_Guide_Img_Trailrank_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Trailrank_01.T_Guide_Img_Trailrank_01'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_TRIALRANK",
		GuideType = "ImageText",
	},
	[8502] = {
		ChildGuideId = 8502,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_TrialRank_2",
				Phone = "UIGuide_TrialRank_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Trailrank_02.T_Guide_Img_Trailrank_02'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Trailrank_02.T_Guide_Img_Trailrank_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Trailrank_02.T_Guide_Img_Trailrank_02'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_TRIALRANK",
		GuideType = "ImageText",
	},
	[8601] = {
		ChildGuideId = 8601,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Deduce_1",
				Phone = "UIGuide_Deduce_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Deduce_01.T_Guide_Img_Deduce_01'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Deduce_01.T_Guide_Img_Deduce_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Deduce_01.T_Guide_Img_Deduce_01'",
			},
		},
		GuideTitle = "UIGuide_Deduce_SubTitle_1",
		GuideType = "ImageText",
	},
	[8602] = {
		ChildGuideId = 8602,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Deduce_2",
				Phone = "UIGuide_Deduce_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Deduce_02.T_Guide_Img_Deduce_02'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Deduce_02.T_Guide_Img_Deduce_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_Deduce_02.T_Guide_Img_Deduce_02'",
			},
		},
		GuideTitle = "UIGuide_Deduce_SubTitle_2",
		GuideType = "ImageText",
	},
	[8701] = {
		ChildGuideId = 8701,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_Saiqi_1_Gamepad",
				PC = "UIGuide_Saiqi_1",
				Phone = "UIGuide_Saiqi_1_Phone",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SaiqiSkill_01_PC.T_Guide_Img_SaiqiSkill_01_PC'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SaiqiSkill_01_PC.T_Guide_Img_SaiqiSkill_01_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SaiqiSkill_01_Phone.T_Guide_Img_SaiqiSkill_01_Phone'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Saiqi_1",
		GuideType = "ImageText",
	},
	[8702] = {
		ChildGuideId = 8702,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_Saiqi_2_Gamepad",
				PC = "UIGuide_Saiqi_2",
				Phone = "UIGuide_Saiqi_2_Phone",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SaiqiSkill_02_PC.T_Guide_Img_SaiqiSkill_02_PC'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SaiqiSkill_02_PC.T_Guide_Img_SaiqiSkill_02_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SaiqiSkill_02_PC.T_Guide_Img_SaiqiSkill_02_PC'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Saiqi_2",
		GuideType = "ImageText",
	},
	[8801] = {
		ChildGuideId = 8801,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_OnlineAreaPre_1",
				PC = "Message_Guide_OnlineAreaPre_1",
				Phone = "Message_Guide_OnlineAreaPre_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_04.T_Guide_Img_OnlineArea_04'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_04.T_Guide_Img_OnlineArea_04'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_OnlineArea_04.T_Guide_Img_OnlineArea_04'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ONLINEAREAPRE_1",
		GuideType = "ImageText",
	},
	[8802] = {
		ChildGuideId = 8802,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_OnlineAreaPre_2",
				PC = "Message_Guide_OnlineAreaPre_2",
				Phone = "Message_Guide_OnlineAreaPre_2",
			},
			GuidePicture = T.RT_10,
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ONLINEAREAPRE_2",
		GuideType = "ImageText",
	},
	[8803] = {
		ChildGuideId = 8803,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "Message_Guide_OnlineAreaPre_3",
				PC = "Message_Guide_OnlineAreaPre_3",
				Phone = "Message_Guide_OnlineAreaPre_3",
			},
			GuidePicture = T.RT_11,
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ONLINEAREAPRE_3",
		GuideType = "ImageText",
	},
	[8901] = {
		ChildGuideId = 8901,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_TongLv_1",
				PC = "UIGuide_TongLv_1",
				Phone = "UIGuide_TongLv_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TongLv_1.T_Guide_Img_TongLv_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TongLv_1.T_Guide_Img_TongLv_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_TongLv_1.T_Guide_Img_TongLv_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_TongLv_1",
		GuideType = "ImageText",
	},
	[9001] = {
		ChildGuideId = 9001,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FangShu_1",
				PC = "UIGuide_FangShu_1",
				Phone = "UIGuide_FangShu_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_1.T_Guide_Img_FangShu_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_1.T_Guide_Img_FangShu_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_1.T_Guide_Img_FangShu_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FangShu_1",
		GuideType = "ImageText",
	},
	[9002] = {
		ChildGuideId = 9002,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FangShu_2",
				PC = "UIGuide_FangShu_2",
				Phone = "UIGuide_FangShu_2_Phone",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_2.T_Guide_Img_FangShu_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_2.T_Guide_Img_FangShu_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_2_Phone.T_Guide_Img_FangShu_2_Phone'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FangShu_2",
		GuideType = "ImageText",
	},
	[9003] = {
		ChildGuideId = 9003,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FangShu_3",
				PC = "UIGuide_FangShu_3",
				Phone = "UIGuide_FangShu_3_Phone",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_3.T_Guide_Img_FangShu_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_3.T_Guide_Img_FangShu_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FangShu_3_Phone.T_Guide_Img_FangShu_3_Phone'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FangShu_3",
		GuideType = "ImageText",
	},
	[9004] = {
		ChildGuideId = 9004,
		GuideInfo1 = T.RT_5,
		GuideTitle = "MAINUIGUIDE_TITLE_FangShu_4",
		GuideType = "ImageText",
	},
	[9101] = {
		ChildGuideId = 9101,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FuWen_1",
				PC = "UIGuide_FuWen_1",
				Phone = "UIGuide_FuWen_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FuWen_1.T_Guide_Img_FuWen_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FuWen_1.T_Guide_Img_FuWen_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FuWen_1.T_Guide_Img_FuWen_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FuWen_1",
		GuideType = "ImageText",
	},
	[9102] = {
		ChildGuideId = 9102,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FuWen_2",
				PC = "UIGuide_FuWen_2",
				Phone = "UIGuide_FuWen_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FuWen_2.T_Guide_Img_FuWen_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FuWen_2.T_Guide_Img_FuWen_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FuWen_2.T_Guide_Img_FuWen_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FuWen_1",
		GuideType = "ImageText",
	},
	[9201] = {
		ChildGuideId = 9201,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ChenMo_1",
				PC = "UIGuide_ChenMo_1",
				Phone = "UIGuide_ChenMo_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ChenMo_1.T_Guide_Img_ChenMo_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ChenMo_1.T_Guide_Img_ChenMo_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ChenMo_1.T_Guide_Img_ChenMo_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ChenMo_1",
		GuideType = "ImageText",
	},
	[9202] = {
		ChildGuideId = 9202,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ChenMo_2",
				PC = "UIGuide_ChenMo_2",
				Phone = "UIGuide_ChenMo_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ChenMo_2.T_Guide_Img_ChenMo_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ChenMo_2.T_Guide_Img_ChenMo_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ChenMo_2.T_Guide_Img_ChenMo_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ChenMo_1",
		GuideType = "ImageText",
	},
	[9301] = {
		ChildGuideId = 9301,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ShanYe_1",
				PC = "UIGuide_ShanYe_1",
				Phone = "UIGuide_ShanYe_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShanYe_1.T_Guide_Img_ShanYe_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShanYe_1.T_Guide_Img_ShanYe_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShanYe_1.T_Guide_Img_ShanYe_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ShanYe_1",
		GuideType = "ImageText",
	},
	[9401] = {
		ChildGuideId = 9401,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_XiQiu_1",
				PC = "UIGuide_XiQiu_1",
				Phone = "UIGuide_XiQiu_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiQiu_1.T_Guide_Img_XiQiu_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiQiu_1.T_Guide_Img_XiQiu_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiQiu_1.T_Guide_Img_XiQiu_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_XiQiu_1",
		GuideType = "ImageText",
	},
	[9501] = {
		ChildGuideId = 9501,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FanZhuan_1",
				PC = "UIGuide_FanZhuan_1",
				Phone = "UIGuide_FanZhuan_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FanZhuan_1.T_Guide_Img_FanZhuan_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FanZhuan_1.T_Guide_Img_FanZhuan_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FanZhuan_1.T_Guide_Img_FanZhuan_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FanZhuan_1",
		GuideType = "ImageText",
	},
	[9502] = {
		ChildGuideId = 9502,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FanZhuan_2",
				PC = "UIGuide_FanZhuan_2",
				Phone = "UIGuide_FanZhuan_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FanZhuan_2.T_Guide_Img_FanZhuan_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FanZhuan_2.T_Guide_Img_FanZhuan_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FanZhuan_2.T_Guide_Img_FanZhuan_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FanZhuan_1",
		GuideType = "ImageText",
	},
	[9601] = {
		ChildGuideId = 9601,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_HuaBan_1",
				PC = "UIGuide_HuaBan_1",
				Phone = "UIGuide_HuaBan_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaBan_1.T_Guide_Img_HuaBan_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaBan_1.T_Guide_Img_HuaBan_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaBan_1.T_Guide_Img_HuaBan_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_HuaBan_1",
		GuideType = "ImageText",
	},
	[9701] = {
		ChildGuideId = 9701,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_WangXi_1",
				PC = "UIGuide_WangXi_1",
				Phone = "UIGuide_WangXi_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WangXi_1.T_Guide_Img_WangXi_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WangXi_1.T_Guide_Img_WangXi_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WangXi_1.T_Guide_Img_WangXi_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_WangXi_1",
		GuideType = "ImageText",
	},
	[9702] = {
		ChildGuideId = 9702,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_WangXi_2",
				PC = "UIGuide_WangXi_2",
				Phone = "UIGuide_WangXi_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WangXi_2.T_Guide_Img_WangXi_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WangXi_2.T_Guide_Img_WangXi_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WangXi_2.T_Guide_Img_WangXi_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_WangXi_1",
		GuideType = "ImageText",
	},
	[9703] = {
		ChildGuideId = 9703,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_WangXi_3",
				PC = "UIGuide_WangXi_3",
				Phone = "UIGuide_WangXi_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WangXi_3.T_Guide_Img_WangXi_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WangXi_3.T_Guide_Img_WangXi_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WangXi_3.T_Guide_Img_WangXi_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_WangXi_1",
		GuideType = "ImageText",
	},
	[9801] = {
		ChildGuideId = 9801,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_DengHua_1",
				PC = "UIGuide_DengHua_1",
				Phone = "UIGuide_DengHua_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DengHua_1.T_Guide_Img_DengHua_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DengHua_1.T_Guide_Img_DengHua_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DengHua_1.T_Guide_Img_DengHua_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_DengHua_1",
		GuideType = "ImageText",
	},
	[9901] = {
		ChildGuideId = 9901,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_QiTianDeng_1",
				PC = "UIGuide_QiTianDeng_1",
				Phone = "UIGuide_QiTianDeng_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QiTianDeng_1.T_Guide_Img_QiTianDeng_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QiTianDeng_1.T_Guide_Img_QiTianDeng_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QiTianDeng_1.T_Guide_Img_QiTianDeng_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_QiTianDeng_1",
		GuideType = "ImageText",
	},
	[10001] = {
		ChildGuideId = 10001,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_XiaoChuan_1",
				PC = "UIGuide_XiaoChuan_1",
				Phone = "UIGuide_XiaoChuan_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoChuan_1.T_Guide_Img_XiaoChuan_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoChuan_1.T_Guide_Img_XiaoChuan_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoChuan_1.T_Guide_Img_XiaoChuan_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_XiaoChuan_1",
		GuideType = "ImageText",
	},
	[10101] = {
		ChildGuideId = 10101,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhanFeng_1",
				PC = "UIGuide_ZhanFeng_1",
				Phone = "UIGuide_ZhanFeng_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhanFeng_1.T_Guide_Img_ZhanFeng_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhanFeng_1.T_Guide_Img_ZhanFeng_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhanFeng_1.T_Guide_Img_ZhanFeng_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhanFeng_1",
		GuideType = "ImageText",
	},
	[10201] = {
		ChildGuideId = 10201,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_XingShi_1",
				PC = "UIGuide_XingShi_1",
				Phone = "UIGuide_XingShi_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XingShi_1.T_Guide_Img_XingShi_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XingShi_1.T_Guide_Img_XingShi_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XingShi_1.T_Guide_Img_XingShi_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_XingShi_1",
		GuideType = "ImageText",
	},
	[10301] = {
		ChildGuideId = 10301,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_JiGuanZhen_1",
				PC = "UIGuide_JiGuanZhen_1",
				Phone = "UIGuide_JiGuanZhen_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiGuanZhen_1.T_Guide_Img_JiGuanZhen_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiGuanZhen_1.T_Guide_Img_JiGuanZhen_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiGuanZhen_1.T_Guide_Img_JiGuanZhen_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_JiGuanZhen_1",
		GuideType = "ImageText",
	},
	[10302] = {
		ChildGuideId = 10302,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_JiGuanZhen_2",
				PC = "UIGuide_JiGuanZhen_2",
				Phone = "UIGuide_JiGuanZhen_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiGuanZhen_2.T_Guide_Img_JiGuanZhen_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiGuanZhen_2.T_Guide_Img_JiGuanZhen_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiGuanZhen_2.T_Guide_Img_JiGuanZhen_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_JiGuanZhen_1",
		GuideType = "ImageText",
	},
	[10303] = {
		ChildGuideId = 10303,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_JiGuanZhen_3",
				PC = "UIGuide_JiGuanZhen_3",
				Phone = "UIGuide_JiGuanZhen_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiGuanZhen_3.T_Guide_Img_JiGuanZhen_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiGuanZhen_3.T_Guide_Img_JiGuanZhen_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiGuanZhen_3.T_Guide_Img_JiGuanZhen_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_JiGuanZhen_1",
		GuideType = "ImageText",
	},
	[10401] = {
		ChildGuideId = 10401,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanShi_1",
				PC = "UIGuide_YanShi_1",
				Phone = "UIGuide_YanShi_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanShi_1.T_Guide_Img_YanShi_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanShi_1.T_Guide_Img_YanShi_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanShi_1.T_Guide_Img_YanShi_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanShi_1",
		GuideType = "ImageText",
	},
	[10402] = {
		ChildGuideId = 10402,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanShi_2",
				PC = "UIGuide_YanShi_2",
				Phone = "UIGuide_YanShi_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanShi_2.T_Guide_Img_YanShi_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanShi_2.T_Guide_Img_YanShi_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanShi_2.T_Guide_Img_YanShi_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanShi_1",
		GuideType = "ImageText",
	},
	[10501] = {
		ChildGuideId = 10501,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_HuaBao_1",
				PC = "UIGuide_HuaBao_1",
				Phone = "UIGuide_HuaBao_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaBao_1.T_Guide_Img_HuaBao_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaBao_1.T_Guide_Img_HuaBao_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaBao_1.T_Guide_Img_HuaBao_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_HuaBao_1",
		GuideType = "ImageText",
	},
	[10502] = {
		ChildGuideId = 10502,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_HuaBao_2",
				PC = "UIGuide_HuaBao_2",
				Phone = "UIGuide_HuaBao_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaBao_2_PC.T_Guide_Img_HuaBao_2_PC'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaBao_2_PC.T_Guide_Img_HuaBao_2_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaBao_2_Phone.T_Guide_Img_HuaBao_2_Phone'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_HuaBao_1",
		GuideType = "ImageText",
	},
	[10601] = {
		ChildGuideId = 10601,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_LongLin_1",
				PC = "UIGuide_LongLin_1",
				Phone = "UIGuide_LongLin_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_1.T_Guide_Img_LongLin_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_1.T_Guide_Img_LongLin_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_1.T_Guide_Img_LongLin_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_LongLin_1",
		GuideType = "ImageText",
	},
	[10602] = {
		ChildGuideId = 10602,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_LongLin_2",
				PC = "UIGuide_LongLin_2",
				Phone = "UIGuide_LongLin_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_2.T_Guide_Img_LongLin_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_2.T_Guide_Img_LongLin_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_2.T_Guide_Img_LongLin_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_LongLin_1",
		GuideType = "ImageText",
	},
	[10603] = {
		ChildGuideId = 10603,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_LongLin_3",
				PC = "UIGuide_LongLin_3",
				Phone = "UIGuide_LongLin_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_3.T_Guide_Img_LongLin_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_3.T_Guide_Img_LongLin_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_3.T_Guide_Img_LongLin_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_LongLin_1",
		GuideType = "ImageText",
	},
	[10604] = {
		ChildGuideId = 10604,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_LongLin_4",
				PC = "UIGuide_LongLin_4",
				Phone = "UIGuide_LongLin_4",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_4.T_Guide_Img_LongLin_4'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_4.T_Guide_Img_LongLin_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_LongLin_4.T_Guide_Img_LongLin_4'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_LongLin_1",
		GuideType = "ImageText",
	},
	[10701] = {
		ChildGuideId = 10701,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_JiaSu_1",
				PC = "UIGuide_JiaSu_1",
				Phone = "UIGuide_JiaSu_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiaSu_1.T_Guide_Img_JiaSu_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiaSu_1.T_Guide_Img_JiaSu_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JiaSu_1.T_Guide_Img_JiaSu_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_JiaSu_1",
		GuideType = "ImageText",
	},
	[10801] = {
		ChildGuideId = 10801,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_HuiYu_1",
				PC = "UIGuide_HuiYu_1",
				Phone = "UIGuide_HuiYu_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuiYu_1_PC.T_Guide_Img_HuiYu_1_PC'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuiYu_1_PC.T_Guide_Img_HuiYu_1_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuiYu_1_Phone.T_Guide_Img_HuiYu_1_Phone'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_HuiYu_1",
		GuideType = "ImageText",
	},
	[10802] = {
		ChildGuideId = 10802,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_HuiYu_2",
				PC = "UIGuide_HuiYu_2",
				Phone = "UIGuide_HuiYu_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuiYu_2.T_Guide_Img_HuiYu_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuiYu_2.T_Guide_Img_HuiYu_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuiYu_2.T_Guide_Img_HuiYu_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_HuiYu_1",
		GuideType = "ImageText",
	},
	[10901] = {
		ChildGuideId = 10901,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_HuaRui_1",
				PC = "UIGuide_HuaRui_1",
				Phone = "UIGuide_HuaRui_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaRui_1.T_Guide_Img_HuaRui_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaRui_1.T_Guide_Img_HuaRui_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaRui_1.T_Guide_Img_HuaRui_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_HuaRui_1",
		GuideType = "ImageText",
	},
	[10902] = {
		ChildGuideId = 10902,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_HuaRui_2",
				PC = "UIGuide_HuaRui_2",
				Phone = "UIGuide_HuaRui_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaRui_2_PC.T_Guide_Img_HuaRui_2_PC'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaRui_2_PC.T_Guide_Img_HuaRui_2_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaRui_2_Phone.T_Guide_Img_HuaRui_2_Phone'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_HuaRui_1",
		GuideType = "ImageText",
	},
	[10903] = {
		ChildGuideId = 10903,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_HuaRui_3",
				PC = "UIGuide_HuaRui_3",
				Phone = "UIGuide_HuaRui_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaRui_3_PC.T_Guide_Img_HuaRui_3_PC'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaRui_3_PC.T_Guide_Img_HuaRui_3_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_HuaRui_3_Phone.T_Guide_Img_HuaRui_3_Phone'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_HuaRui_1",
		GuideType = "ImageText",
	},
	[11001] = {
		ChildGuideId = 11001,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FenZuSai_1",
				PC = "UIGuide_FenZuSai_1",
				Phone = "UIGuide_FenZuSai_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FenZuSai_1.T_Guide_Img_FenZuSai_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FenZuSai_1.T_Guide_Img_FenZuSai_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FenZuSai_1.T_Guide_Img_FenZuSai_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FenZuSai_1",
		GuideType = "ImageText",
	},
	[11002] = {
		ChildGuideId = 11002,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FenZuSai_2",
				PC = "UIGuide_FenZuSai_2",
				Phone = "UIGuide_FenZuSai_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FenZuSai_2.T_Guide_Img_FenZuSai_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FenZuSai_2.T_Guide_Img_FenZuSai_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FenZuSai_2.T_Guide_Img_FenZuSai_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FenZuSai_1",
		GuideType = "ImageText",
	},
	[11003] = {
		ChildGuideId = 11003,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_FenZuSai_3",
				PC = "UIGuide_FenZuSai_3",
				Phone = "UIGuide_FenZuSai_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FenZuSai_3.T_Guide_Img_FenZuSai_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FenZuSai_3.T_Guide_Img_FenZuSai_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_FenZuSai_3.T_Guide_Img_FenZuSai_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_FenZuSai_1",
		GuideType = "ImageText",
	},
	[11101] = {
		ChildGuideId = 11101,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_DianFeng_1",
				PC = "UIGuide_DianFeng_1",
				Phone = "UIGuide_DianFeng_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_1.T_Guide_Img_DianFeng_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_1.T_Guide_Img_DianFeng_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_1.T_Guide_Img_DianFeng_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_DianFeng_1",
		GuideType = "ImageText",
	},
	[11102] = {
		ChildGuideId = 11102,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_DianFeng_2",
				PC = "UIGuide_DianFeng_2",
				Phone = "UIGuide_DianFeng_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_2.T_Guide_Img_DianFeng_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_2.T_Guide_Img_DianFeng_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_2.T_Guide_Img_DianFeng_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_DianFeng_1",
		GuideType = "ImageText",
	},
	[11103] = {
		ChildGuideId = 11103,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_DianFeng_3",
				PC = "UIGuide_DianFeng_3",
				Phone = "UIGuide_DianFeng_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_3.T_Guide_Img_DianFeng_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_3.T_Guide_Img_DianFeng_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_3.T_Guide_Img_DianFeng_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_DianFeng_1",
		GuideType = "ImageText",
	},
	[11104] = {
		ChildGuideId = 11104,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_DianFeng_4",
				PC = "UIGuide_DianFeng_4",
				Phone = "UIGuide_DianFeng_4",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_4.T_Guide_Img_DianFeng_4'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_4.T_Guide_Img_DianFeng_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_DianFeng_4.T_Guide_Img_DianFeng_4'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_DianFeng_1",
		GuideType = "ImageText",
	},
	[11201] = {
		ChildGuideId = 11201,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhouYe_1",
				PC = "UIGuide_ZhouYe_1",
				Phone = "UIGuide_ZhouYe_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhouYe_1.T_Guide_Img_ZhouYe_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhouYe_1.T_Guide_Img_ZhouYe_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhouYe_1.T_Guide_Img_ZhouYe_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhouYe_1",
		GuideType = "ImageText",
	},
	[11301] = {
		ChildGuideId = 11301,
		GuideInfo1 = T.RT_5,
		GuideTitle = "MAINUIGUIDE_TITLE_FangShu_4",
		GuideType = "ImageText",
	},
	[11401] = {
		ChildGuideId = 11401,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_JuYuan_1",
				PC = "UIGuide_JuYuan_1",
				Phone = "UIGuide_JuYuan_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JuYuan_1.T_Guide_Img_JuYuan_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JuYuan_1.T_Guide_Img_JuYuan_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JuYuan_1.T_Guide_Img_JuYuan_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_JuYuan_1",
		GuideType = "ImageText",
	},
	[11402] = {
		ChildGuideId = 11402,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_JuYuan_2",
				PC = "UIGuide_JuYuan_2",
				Phone = "UIGuide_JuYuan_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JuYuan_2.T_Guide_Img_JuYuan_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JuYuan_2.T_Guide_Img_JuYuan_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JuYuan_2.T_Guide_Img_JuYuan_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_JuYuan_1",
		GuideType = "ImageText",
	},
	[11403] = {
		ChildGuideId = 11403,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_JuYuan_3",
				PC = "UIGuide_JuYuan_3",
				Phone = "UIGuide_JuYuan_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JuYuan_3.T_Guide_Img_JuYuan_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JuYuan_3.T_Guide_Img_JuYuan_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_JuYuan_3.T_Guide_Img_JuYuan_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_JuYuan_1",
		GuideType = "ImageText",
	},
	[11501] = {
		ChildGuideId = 11501,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_115_01",
				Phone = "Mon_Guide_115_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_11501.T_Guide_Img_Mon_11501'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_11501.T_Guide_Img_Mon_11501'",
			},
		},
		GuideTitle = "Mon_Guide_Title_115",
		GuideType = "ImageText",
	},
	[11502] = {
		ChildGuideId = 11502,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_115_02",
				Phone = "Mon_Guide_115_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_11502.T_Guide_Img_Mon_11502'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_11502.T_Guide_Img_Mon_11502'",
			},
		},
		GuideTitle = "Mon_Guide_Title_115",
		GuideType = "ImageText",
	},
	[11601] = {
		ChildGuideId = 11601,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AutoChess_1",
				PC = "UIGuide_AutoChess_1",
				Phone = "UIGuide_AutoChess_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_1.T_Guide_Img_AutoChess_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_1.T_Guide_Img_AutoChess_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_1.T_Guide_Img_AutoChess_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AutoChess_1",
		GuideType = "ImageText",
	},
	[11602] = {
		ChildGuideId = 11602,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AutoChess_2_1",
				PC = "UIGuide_AutoChess_2_1",
				Phone = "UIGuide_AutoChess_2_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_2.T_Guide_Img_AutoChess_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_2.T_Guide_Img_AutoChess_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_2.T_Guide_Img_AutoChess_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AutoChess_2",
		GuideType = "ImageText",
	},
	[11603] = {
		ChildGuideId = 11603,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AutoChess_2_2",
				PC = "UIGuide_AutoChess_2_2",
				Phone = "UIGuide_AutoChess_2_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_3.T_Guide_Img_AutoChess_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_3.T_Guide_Img_AutoChess_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_3.T_Guide_Img_AutoChess_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AutoChess_2",
		GuideType = "ImageText",
	},
	[11604] = {
		ChildGuideId = 11604,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AutoChess_2_3",
				PC = "UIGuide_AutoChess_2_3",
				Phone = "UIGuide_AutoChess_2_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_4.T_Guide_Img_AutoChess_4'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_4.T_Guide_Img_AutoChess_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_4.T_Guide_Img_AutoChess_4'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AutoChess_2",
		GuideType = "ImageText",
	},
	[11605] = {
		ChildGuideId = 11605,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AutoChess_3",
				PC = "UIGuide_AutoChess_3",
				Phone = "UIGuide_AutoChess_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_5.T_Guide_Img_AutoChess_5'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_5.T_Guide_Img_AutoChess_5'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_5.T_Guide_Img_AutoChess_5'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AutoChess_3",
		GuideType = "ImageText",
	},
	[11606] = {
		ChildGuideId = 11606,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AutoChess_4_1",
				PC = "UIGuide_AutoChess_4_1",
				Phone = "UIGuide_AutoChess_4_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_6.T_Guide_Img_AutoChess_6'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_6.T_Guide_Img_AutoChess_6'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_6.T_Guide_Img_AutoChess_6'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AutoChess_4",
		GuideType = "ImageText",
	},
	[11607] = {
		ChildGuideId = 11607,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AutoChess_4_2",
				PC = "UIGuide_AutoChess_4_2",
				Phone = "UIGuide_AutoChess_4_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_7.T_Guide_Img_AutoChess_7'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_7.T_Guide_Img_AutoChess_7'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_7.T_Guide_Img_AutoChess_7'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AutoChess_4",
		GuideType = "ImageText",
	},
	[11608] = {
		ChildGuideId = 11608,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AutoChess_5",
				PC = "UIGuide_AutoChess_5",
				Phone = "UIGuide_AutoChess_5",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_8.T_Guide_Img_AutoChess_8'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_8.T_Guide_Img_AutoChess_8'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AutoChess_8.T_Guide_Img_AutoChess_8'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AutoChess_5",
		GuideType = "ImageText",
	},
	[11701] = {
		ChildGuideId = 11701,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ShengMing_1",
				PC = "UIGuide_ShengMing_1",
				Phone = "UIGuide_ShengMing_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShengMing_1.T_Guide_Img_ShengMing_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShengMing_1.T_Guide_Img_ShengMing_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShengMing_1.T_Guide_Img_ShengMing_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ShengMing_1",
		GuideType = "ImageText",
	},
	[11702] = {
		ChildGuideId = 11702,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ShengMing_2",
				PC = "UIGuide_ShengMing_2",
				Phone = "UIGuide_ShengMing_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShengMing_2.T_Guide_Img_ShengMing_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShengMing_2.T_Guide_Img_ShengMing_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShengMing_2.T_Guide_Img_ShengMing_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ShengMing_1",
		GuideType = "ImageText",
	},
	[11703] = {
		ChildGuideId = 11703,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ShengMing_3",
				PC = "UIGuide_ShengMing_3",
				Phone = "UIGuide_ShengMing_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShengMing_3.T_Guide_Img_ShengMing_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShengMing_3.T_Guide_Img_ShengMing_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShengMing_3.T_Guide_Img_ShengMing_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ShengMing_1",
		GuideType = "ImageText",
	},
	[11801] = {
		ChildGuideId = 11801,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_WuYou_1",
				PC = "UIGuide_WuYou_1",
				Phone = "UIGuide_WuYou_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WuYou_1.T_Guide_Img_WuYou_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WuYou_1.T_Guide_Img_WuYou_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WuYou_1.T_Guide_Img_WuYou_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_WuYou_1",
		GuideType = "ImageText",
	},
	[11802] = {
		ChildGuideId = 11802,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_WuYou_2",
				PC = "UIGuide_WuYou_2",
				Phone = "UIGuide_WuYou_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WuYou_2.T_Guide_Img_WuYou_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WuYou_2.T_Guide_Img_WuYou_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WuYou_2.T_Guide_Img_WuYou_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_WuYou_1",
		GuideType = "ImageText",
	},
	[11803] = {
		ChildGuideId = 11803,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_WuYou_3",
				PC = "UIGuide_WuYou_3",
				Phone = "UIGuide_WuYou_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WuYou_3.T_Guide_Img_WuYou_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WuYou_3.T_Guide_Img_WuYou_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_WuYou_3.T_Guide_Img_WuYou_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_WuYou_1",
		GuideType = "ImageText",
	},
	[11901] = {
		ChildGuideId = 11901,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZuoQi_1",
				PC = "UIGuide_ZuoQi_1",
				Phone = "UIGuide_ZuoQi_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZuoQi_1.T_Guide_Img_ZuoQi_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZuoQi_1.T_Guide_Img_ZuoQi_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZuoQi_1.T_Guide_Img_ZuoQi_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZuoQi_1",
		GuideType = "ImageText",
	},
	[11902] = {
		ChildGuideId = 11902,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZuoQi_2",
				PC = "UIGuide_ZuoQi_2",
				Phone = "UIGuide_ZuoQi_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZuoQi_2.T_Guide_Img_ZuoQi_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZuoQi_2.T_Guide_Img_ZuoQi_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZuoQi_2.T_Guide_Img_ZuoQi_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZuoQi_2",
		GuideType = "ImageText",
	},
	[11903] = {
		ChildGuideId = 11903,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZuoQi_3",
				PC = "UIGuide_ZuoQi_3",
				Phone = "UIGuide_ZuoQi_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZuoQi_3.T_Guide_Img_ZuoQi_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZuoQi_3.T_Guide_Img_ZuoQi_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZuoQi_3.T_Guide_Img_ZuoQi_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZuoQi_3",
		GuideType = "ImageText",
	},
	[12001] = {
		ChildGuideId = 12001,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UI_Title_Popup_RecordVedio_Cont",
				PC = "UI_Title_Popup_RecordVedio_Cont",
				Phone = "UI_Title_Popup_RecordVedio_Cont",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_RecordVideo.T_Guide_Img_RecordVideo'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_RecordVideo.T_Guide_Img_RecordVideo'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_RecordVideo.T_Guide_Img_RecordVideo'",
			},
		},
		GuideTitle = "UI_Title_Popup_RecordVedio",
		GuideType = "ImageText",
	},
	[12101] = {
		ChildGuideId = 12101,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_QiaoBan_1",
				PC = "UIGuide_QiaoBan_1",
				Phone = "UIGuide_QiaoBan_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QiaoBan_1.T_Guide_Img_QiaoBan_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QiaoBan_1.T_Guide_Img_QiaoBan_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QiaoBan_1.T_Guide_Img_QiaoBan_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_QiaoBan_1",
		GuideType = "ImageText",
	},
	[12102] = {
		ChildGuideId = 12102,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_QiaoBan_2",
				PC = "UIGuide_QiaoBan_2",
				Phone = "UIGuide_QiaoBan_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QiaoBan_2.T_Guide_Img_QiaoBan_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QiaoBan_2.T_Guide_Img_QiaoBan_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QiaoBan_2.T_Guide_Img_QiaoBan_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_QiaoBan_1",
		GuideType = "ImageText",
	},
	[12103] = {
		ChildGuideId = 12103,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhuanZhou_1",
				PC = "UIGuide_ZhuanZhou_1",
				Phone = "UIGuide_ZhuanZhou_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhuanZhou_1.T_Guide_Img_ZhuanZhou_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhuanZhou_1.T_Guide_Img_ZhuanZhou_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhuanZhou_1.T_Guide_Img_ZhuanZhou_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhuanZhou_1",
		GuideType = "ImageText",
	},
	[12104] = {
		ChildGuideId = 12104,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhuanZhou_2",
				PC = "UIGuide_ZhuanZhou_2",
				Phone = "UIGuide_ZhuanZhou_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhuanZhou_2.T_Guide_Img_ZhuanZhou_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhuanZhou_2.T_Guide_Img_ZhuanZhou_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ZhuanZhou_2.T_Guide_Img_ZhuanZhou_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhuanZhou_1",
		GuideType = "ImageText",
	},
	[12201] = {
		ChildGuideId = 12201,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_PinTu_1",
				PC = "UIGuide_PinTu_1",
				Phone = "UIGuide_PinTu_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_PinTu_1",
		GuideType = "ImageText",
	},
	[12301] = {
		ChildGuideId = 12301,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ShenJi_1",
				PC = "UIGuide_ShenJi_1",
				Phone = "UIGuide_ShenJi_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShenJi_1.T_Guide_Img_ShenJi_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShenJi_1.T_Guide_Img_ShenJi_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShenJi_1.T_Guide_Img_ShenJi_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ShenJi_1",
		GuideType = "ImageText",
	},
	[12302] = {
		ChildGuideId = 12302,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ShenJi_2",
				PC = "UIGuide_ShenJi_2",
				Phone = "UIGuide_ShenJi_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShenJi_2.T_Guide_Img_ShenJi_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShenJi_2.T_Guide_Img_ShenJi_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_ShenJi_2.T_Guide_Img_ShenJi_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ShenJi_1",
		GuideType = "ImageText",
	},
	[12401] = {
		ChildGuideId = 12401,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_XiaoYao_1",
				PC = "UIGuide_XiaoYao_1",
				Phone = "UIGuide_XiaoYao_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_1.T_Guide_Img_XiaoYao_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_1.T_Guide_Img_XiaoYao_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_1.T_Guide_Img_XiaoYao_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_XiaoYao_1",
		GuideType = "ImageText",
	},
	[12402] = {
		ChildGuideId = 12402,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_XiaoYao_2",
				PC = "UIGuide_XiaoYao_2",
				Phone = "UIGuide_XiaoYao_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_2.T_Guide_Img_XiaoYao_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_2.T_Guide_Img_XiaoYao_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_2.T_Guide_Img_XiaoYao_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_XiaoYao_1",
		GuideType = "ImageText",
	},
	[12403] = {
		ChildGuideId = 12403,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_XiaoYao_3",
				PC = "UIGuide_XiaoYao_3",
				Phone = "UIGuide_XiaoYao_3",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_3.T_Guide_Img_XiaoYao_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_3.T_Guide_Img_XiaoYao_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_3.T_Guide_Img_XiaoYao_3'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_XiaoYao_1",
		GuideType = "ImageText",
	},
	[12404] = {
		ChildGuideId = 12404,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_XiaoYao_4",
				PC = "UIGuide_XiaoYao_4",
				Phone = "UIGuide_XiaoYao_4",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_4.T_Guide_Img_XiaoYao_4'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_4.T_Guide_Img_XiaoYao_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XiaoYao_4.T_Guide_Img_XiaoYao_4'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_XiaoYao_1",
		GuideType = "ImageText",
	},
	[12501] = {
		ChildGuideId = 12501,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_XuanYong_1",
				PC = "UIGuide_XuanYong_1",
				Phone = "UIGuide_XuanYong_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XuanYong_1.T_Guide_Img_XuanYong_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XuanYong_1.T_Guide_Img_XuanYong_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_XuanYong_1.T_Guide_Img_XuanYong_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_XuanYong_1",
		GuideType = "ImageText",
	},
	[12601] = {
		ChildGuideId = 12601,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhenLv_1",
				PC = "UIGuide_ZhenLv_1",
				Phone = "UIGuide_ZhenLv_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QianKun_1.T_Guide_Img_QianKun_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QianKun_1.T_Guide_Img_QianKun_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QianKun_1.T_Guide_Img_QianKun_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhenLv_1",
		GuideType = "ImageText",
	},
	[12602] = {
		ChildGuideId = 12602,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhenLv_2",
				PC = "UIGuide_ZhenLv_2",
				Phone = "UIGuide_ZhenLv_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QianKun_2.T_Guide_Img_QianKun_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QianKun_2.T_Guide_Img_QianKun_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QianKun_2.T_Guide_Img_QianKun_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhenLv_1",
		GuideType = "ImageText",
	},
	[12701] = {
		ChildGuideId = 12701,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AnHao_1",
				PC = "UIGuide_AnHao_1",
				Phone = "UIGuide_AnHao_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AnHao_1.T_Guide_Img_AnHao_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AnHao_1.T_Guide_Img_AnHao_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_AnHao_1.T_Guide_Img_AnHao_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AnHao_1",
		GuideType = "ImageText",
	},
	[12702] = {
		ChildGuideId = 12702,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_AnHao_2",
				PC = "UIGuide_AnHao_2",
				Phone = "UIGuide_AnHao_2",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_AnHao_1",
		GuideType = "ImageText",
	},
	[12801] = {
		ChildGuideId = 12801,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanQue_1",
				PC = "UIGuide_YanQue_1",
				Phone = "UIGuide_YanQue_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanQue_1.T_Guide_Img_YanQue_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanQue_1.T_Guide_Img_YanQue_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanQue_1.T_Guide_Img_YanQue_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanQue_1",
		GuideType = "ImageText",
	},
	[12802] = {
		ChildGuideId = 12802,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanQue_2",
				PC = "UIGuide_YanQue_2",
				Phone = "UIGuide_YanQue_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanQue_2.T_Guide_Img_YanQue_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanQue_2.T_Guide_Img_YanQue_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_YanQue_2.T_Guide_Img_YanQue_2'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanQue_1",
		GuideType = "ImageText",
	},
	[12901] = {
		ChildGuideId = 12901,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_QueXie_1",
				PC = "UIGuide_QueXie_1",
				Phone = "UIGuide_QueXie_1",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QueXie_1.T_Guide_Img_QueXie_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QueXie_1.T_Guide_Img_QueXie_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QueXie_1.T_Guide_Img_QueXie_1'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_QueXie_1",
		GuideType = "ImageText",
	},
	[12902] = {
		ChildGuideId = 12902,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_QueXie_2_PC",
				PC = "UIGuide_QueXie_2_PC",
				Phone = "UIGuide_QueXie_2_Phone",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QueXie_2_PC.T_Guide_Img_QueXie_2_PC'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QueXie_2_PC.T_Guide_Img_QueXie_2_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/System/T_Guide_Img_QueXie_2_Phone.T_Guide_Img_QueXie_2_Phone'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_QueXie_1",
		GuideType = "ImageText",
	},
	[13001] = {
		ChildGuideId = 13001,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_QianKun_1",
				PC = "UIGuide_QianKun_1",
				Phone = "UIGuide_QianKun_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_QianKun_1",
		GuideType = "ImageText",
	},
	[13002] = {
		ChildGuideId = 13002,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_QianKun_2",
				PC = "UIGuide_QianKun_2",
				Phone = "UIGuide_QianKun_2",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_QianKun_1",
		GuideType = "ImageText",
	},
	[13101] = {
		ChildGuideId = 13101,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhengLi_1",
				PC = "UIGuide_ZhengLi_1",
				Phone = "UIGuide_ZhengLi_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhengLi_1",
		GuideType = "ImageText",
	},
	[13102] = {
		ChildGuideId = 13102,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhengLi_2",
				PC = "UIGuide_ZhengLi_2",
				Phone = "UIGuide_ZhengLi_2",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhengLi_2",
		GuideType = "ImageText",
	},
	[13103] = {
		ChildGuideId = 13103,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhengLi_3",
				PC = "UIGuide_ZhengLi_3",
				Phone = "UIGuide_ZhengLi_3",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhengLi_3",
		GuideType = "ImageText",
	},
	[13104] = {
		ChildGuideId = 13104,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ZhengLi_4",
				PC = "UIGuide_ZhengLi_4",
				Phone = "UIGuide_ZhengLi_4",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ZhengLi_4",
		GuideType = "ImageText",
	},
	[13201] = {
		ChildGuideId = 13201,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_RongQi_1",
				PC = "UIGuide_RongQi_1",
				Phone = "UIGuide_RongQi_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_RongQi_1",
		GuideType = "ImageText",
	},
	[13301] = {
		ChildGuideId = 13301,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_NiuDan_1",
				PC = "UIGuide_NiuDan_1",
				Phone = "UIGuide_NiuDan_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_NiuDan_1",
		GuideType = "ImageText",
	},
	[13401] = {
		ChildGuideId = 13401,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_TianQi_1",
				PC = "UIGuide_TianQi_1",
				Phone = "UIGuide_TianQi_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_TianQi_1",
		GuideType = "ImageText",
	},
	[13501] = {
		ChildGuideId = 13501,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_GongFeng_1",
				PC = "UIGuide_GongFeng_1",
				Phone = "UIGuide_GongFeng_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_GongFeng_1",
		GuideType = "ImageText",
	},
	[13601] = {
		ChildGuideId = 13601,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_MiShi_1",
				PC = "UIGuide_MiShi_1",
				Phone = "UIGuide_MiShi_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_MiShi_1",
		GuideType = "ImageText",
	},
	[13602] = {
		ChildGuideId = 13602,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_MiShi_2",
				PC = "UIGuide_MiShi_2",
				Phone = "UIGuide_MiShi_2",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_MiShi_1",
		GuideType = "ImageText",
	},
	[13603] = {
		ChildGuideId = 13603,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_MiShi_3",
				PC = "UIGuide_MiShi_3",
				Phone = "UIGuide_MiShi_3",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_MiShi_1",
		GuideType = "ImageText",
	},
	[13701] = {
		ChildGuideId = 13701,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_XianJing_1",
				PC = "UIGuide_XianJing_1",
				Phone = "UIGuide_XianJing_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_XianJing_1",
		GuideType = "ImageText",
	},
	[13801] = {
		ChildGuideId = 13801,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ShouHu_1",
				PC = "UIGuide_ShouHu_1",
				Phone = "UIGuide_ShouHu_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ShouHu_1",
		GuideType = "ImageText",
	},
	[13802] = {
		ChildGuideId = 13802,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ShouHu_2",
				PC = "UIGuide_ShouHu_2",
				Phone = "UIGuide_ShouHu_2",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ShouHu_1",
		GuideType = "ImageText",
	},
	[13803] = {
		ChildGuideId = 13803,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_ShouHu_3",
				PC = "UIGuide_ShouHu_3",
				Phone = "UIGuide_ShouHu_3",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_ShouHu_1",
		GuideType = "ImageText",
	},
	[13901] = {
		ChildGuideId = 13901,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_JingYing_1",
				PC = "UIGuide_JingYing_1",
				Phone = "UIGuide_JingYing_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_JingYing_1",
		GuideType = "ImageText",
	},
	[14001] = {
		ChildGuideId = 14001,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_JieSuan_1",
				PC = "UIGuide_JieSuan_1",
				Phone = "UIGuide_JieSuan_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_JieSuan_1",
		GuideType = "ImageText",
	},
	[14301] = {
		ChildGuideId = 14301,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_SuYi_PC_1",
				PC = "UIGuide_SuYi_PC_1",
				Phone = "UIGuide_SuYi_Phone_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_SuYi_1",
		GuideType = "ImageText",
	},
	[14302] = {
		ChildGuideId = 14302,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_SuYi_PC_2",
				PC = "UIGuide_SuYi_PC_2",
				Phone = "UIGuide_SuYi_Phone_2",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_SuYi_2",
		GuideType = "ImageText",
	},
	[14401] = {
		ChildGuideId = 14401,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_TeYao_1",
				PC = "UIGuide_TeYao_1",
				Phone = "UIGuide_TeYao_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_TeYao_1",
		GuideType = "ImageText",
	},
	[14501] = {
		ChildGuideId = 14501,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanQueFeiXing_1",
				PC = "UIGuide_YanQueFeiXing_1",
				Phone = "UIGuide_YanQueFeiXing_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanQueFeiXing_1",
		GuideType = "ImageText",
	},
	[14502] = {
		ChildGuideId = 14502,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanQueFeiXing_2",
				PC = "UIGuide_YanQueFeiXing_2",
				Phone = "UIGuide_YanQueFeiXing_2",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanQueFeiXing_1",
		GuideType = "ImageText",
	},
	[14503] = {
		ChildGuideId = 14503,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanQueFeiXing_3",
				PC = "UIGuide_YanQueFeiXing_3",
				Phone = "UIGuide_YanQueFeiXing_3",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanQueFeiXing_1",
		GuideType = "ImageText",
	},
	[14504] = {
		ChildGuideId = 14504,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanQueFeiXing_4",
				PC = "UIGuide_YanQueFeiXing_4",
				Phone = "UIGuide_YanQueFeiXing_4",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanQueFeiXing_1",
		GuideType = "ImageText",
	},
	[14505] = {
		ChildGuideId = 14505,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanQueFeiXing_5",
				PC = "UIGuide_YanQueFeiXing_5",
				Phone = "UIGuide_YanQueFeiXing_5",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanQueFeiXing_1",
		GuideType = "ImageText",
	},
	[14506] = {
		ChildGuideId = 14506,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YanQueFeiXing_6",
				PC = "UIGuide_YanQueFeiXing_6",
				Phone = "UIGuide_YanQueFeiXing_6",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YanQueFeiXing_1",
		GuideType = "ImageText",
	},
	[14601] = {
		ChildGuideId = 14601,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YinZong_1",
				PC = "UIGuide_YinZong_1",
				Phone = "UIGuide_YinZong_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YinZong_1",
		GuideType = "ImageText",
	},
	[14701] = {
		ChildGuideId = 14701,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YuBo_1",
				PC = "UIGuide_YuBo_1",
				Phone = "UIGuide_YuBo_1",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YuBo_1",
		GuideType = "ImageText",
	},
	[14702] = {
		ChildGuideId = 14702,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YuBo_2",
				PC = "UIGuide_YuBo_2",
				Phone = "UIGuide_YuBo_2",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YuBo_1",
		GuideType = "ImageText",
	},
	[14703] = {
		ChildGuideId = 14703,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YuBo_3",
				PC = "UIGuide_YuBo_3",
				Phone = "UIGuide_YuBo_3",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YuBo_1",
		GuideType = "ImageText",
	},
	[14704] = {
		ChildGuideId = 14704,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YuBo_4",
				PC = "UIGuide_YuBo_4",
				Phone = "UIGuide_YuBo_4",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YuBo_1",
		GuideType = "ImageText",
	},
	[14705] = {
		ChildGuideId = 14705,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_YuBo_5",
				PC = "UIGuide_YuBo_5",
				Phone = "UIGuide_YuBo_5",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_YuBo_1",
		GuideType = "ImageText",
	},
	[100101] = {
		ChildGuideId = 100101,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SURVIVALPRO_114",
				Phone = "DUNGEON_SURVIVALPRO_114",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survival01_Step_1.T_Guide_Img_Survival01_Step_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survival01_Step_1.T_Guide_Img_Survival01_Step_1'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_100",
		GuideType = "ImageText",
	},
	[100102] = {
		ChildGuideId = 100102,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SURVIVALPRO_115",
				Phone = "DUNGEON_SURVIVALPRO_115",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survival01_Step_2.T_Guide_Img_Survival01_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survival01_Step_2.T_Guide_Img_Survival01_Step_2'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_100",
		GuideType = "ImageText",
	},
	[100103] = {
		ChildGuideId = 100103,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SURVIVALPRO_116",
				Phone = "DUNGEON_SURVIVALPRO_116",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survival01_Step_3.T_Guide_Img_Survival01_Step_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survival01_Step_3.T_Guide_Img_Survival01_Step_3'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_100",
		GuideType = "ImageText",
	},
	[100104] = {
		ChildGuideId = 100104,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SURVIVALPRO_117",
				Phone = "DUNGEON_SURVIVALPRO_117",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survival01_Step_4.T_Guide_Img_Survival01_Step_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survival01_Step_4.T_Guide_Img_Survival01_Step_4'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_100",
		GuideType = "ImageText",
	},
	[100201] = {
		ChildGuideId = 100201,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SURVIVALMINIPRO_102",
				Phone = "DUNGEON_SURVIVALMINIPRO_102",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survivalminipro_Step_1.T_Guide_Img_Survivalminipro_Step_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survivalminipro_Step_1.T_Guide_Img_Survivalminipro_Step_1'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_105",
		GuideType = "ImageText",
	},
	[100202] = {
		ChildGuideId = 100202,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SURVIVALMINIPRO_103",
				Phone = "DUNGEON_SURVIVALMINIPRO_103",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survivalminipro_Step_2.T_Guide_Img_Survivalminipro_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survivalminipro_Step_2.T_Guide_Img_Survivalminipro_Step_2'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_105",
		GuideType = "ImageText",
	},
	[100203] = {
		ChildGuideId = 100203,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SURVIVALMINIPRO_104",
				Phone = "DUNGEON_SURVIVALMINIPRO_104",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survivalminipro_Step_3.T_Guide_Img_Survivalminipro_Step_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Survivalminipro_Step_3.T_Guide_Img_Survivalminipro_Step_3'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_105",
		GuideType = "ImageText",
	},
	[100301] = {
		ChildGuideId = 100301,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_DEFENCE_108",
				Phone = "TARGET_DUNGEON_DEFENCE_108",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Defense_Step_1.T_Guide_Img_Defense_Step_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Defense_Step_1.T_Guide_Img_Defense_Step_1'",
			},
		},
		GuideTitle = "DUNGEON_DEFENCE_103",
		GuideType = "ImageText",
	},
	[100302] = {
		ChildGuideId = 100302,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_DEFENCE_109",
				Phone = "TARGET_DUNGEON_DEFENCE_109",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Denfense_Step_2.T_Guide_Img_Denfense_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Denfense_Step_2.T_Guide_Img_Denfense_Step_2'",
			},
		},
		GuideTitle = "DUNGEON_DEFENCE_103",
		GuideType = "ImageText",
	},
	[100401] = {
		ChildGuideId = 100401,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_DEFENCE_112",
				Phone = "TARGET_DUNGEON_DEFENCE_112",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Defense02_Step_1.T_Guide_Img_Defense02_Step_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Defense02_Step_1.T_Guide_Img_Defense02_Step_1'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_DEFENCE_101",
		GuideType = "ImageText",
	},
	[100501] = {
		ChildGuideId = 100501,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_CAPTURE_103",
				Phone = "TARGET_DUNGEON_CAPTURE_103",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Capture_Step_1.T_Guide_Img_Capture_Step_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Capture_Step_1.T_Guide_Img_Capture_Step_1'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_CAPTURE_100",
		GuideType = "ImageText",
	},
	[100502] = {
		ChildGuideId = 100502,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_CAPTURE_104",
				Phone = "TARGET_DUNGEON_CAPTURE_104",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Capture_Step_2_PC.T_Guide_Img_Capture_Step_2_PC'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Capture_Step_2_Mobile.T_Guide_Img_Capture_Step_2_Mobile'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_CAPTURE_100",
		GuideType = "ImageText",
	},
	[100503] = {
		ChildGuideId = 100503,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_CAPTURE_105",
				Phone = "TARGET_DUNGEON_CAPTURE_105",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Capture_Step_3.T_Guide_Img_Capture_Step_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Capture_Step_3.T_Guide_Img_Capture_Step_3'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_CAPTURE_100",
		GuideType = "ImageText",
	},
	[100504] = {
		ChildGuideId = 100504,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_CAPTURE_107",
				Phone = "TARGET_DUNGEON_CAPTURE_107",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Capture_Step_4.T_Guide_Img_Capture_Step_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Capture_Step_4.T_Guide_Img_Capture_Step_4'",
			},
		},
		GuideTitle = "TARGET_DUNGEON_CAPTURE_100",
		GuideType = "ImageText",
	},
	[100601] = {
		ChildGuideId = 100601,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_EXCAVATION_104",
				Phone = "TARGET_DUNGEON_EXCAVATION_104",
			},
			GuidePicture = T.RT_1,
		},
		GuideTitle = "DUNGEON_EXCAVATION_100",
		GuideType = "ImageText",
	},
	[100602] = {
		ChildGuideId = 100602,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_EXCAVATION_105",
				Phone = "TARGET_DUNGEON_EXCAVATION_105",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_2.T_Guide_Img_Explore_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_2.T_Guide_Img_Explore_Step_2'",
			},
		},
		GuideTitle = "DUNGEON_EXCAVATION_100",
		GuideType = "ImageText",
	},
	[100603] = {
		ChildGuideId = 100603,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_EXCAVATION_106",
				Phone = "TARGET_DUNGEON_EXCAVATION_106",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_3.T_Guide_Img_Explore_Step_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_3.T_Guide_Img_Explore_Step_3'",
			},
		},
		GuideTitle = "DUNGEON_EXCAVATION_100",
		GuideType = "ImageText",
	},
	[100604] = {
		ChildGuideId = 100604,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_EXCAVATION_107",
				Phone = "TARGET_DUNGEON_EXCAVATION_107",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_4.T_Guide_Img_Explore_Step_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_4.T_Guide_Img_Explore_Step_4'",
			},
		},
		GuideTitle = "DUNGEON_EXCAVATION_100",
		GuideType = "ImageText",
	},
	[100605] = {
		ChildGuideId = 100605,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_EXCAVATION_108",
				Phone = "TARGET_DUNGEON_EXCAVATION_108",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_5.T_Guide_Img_Explore_Step_5'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_5.T_Guide_Img_Explore_Step_5'",
			},
		},
		GuideTitle = "DUNGEON_EXCAVATION_100",
		GuideType = "ImageText",
	},
	[100606] = {
		ChildGuideId = 100606,
		GuideInfo1 = {
			GuideContent = {
				PC = "TARGET_DUNGEON_EXCAVATION_109",
				Phone = "TARGET_DUNGEON_EXCAVATION_109",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_6.T_Guide_Img_Explore_Step_6'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Explore_Step_6.T_Guide_Img_Explore_Step_6'",
			},
		},
		GuideTitle = "DUNGEON_EXCAVATION_100",
		GuideType = "ImageText",
	},
	[100701] = {
		ChildGuideId = 100701,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SABOTAGE_110",
				Phone = "DUNGEON_SABOTAGE_110",
			},
			GuidePicture = T.RT_1,
		},
		GuideTitle = "UI_DUNGEON_TYPE_SABOTAGE",
		GuideType = "ImageText",
	},
	[100702] = {
		ChildGuideId = 100702,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SABOTAGE_112",
				Phone = "DUNGEON_SABOTAGE_112",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Sabotage_Step_2.T_Guide_Img_Sabotage_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Sabotage_Step_2.T_Guide_Img_Sabotage_Step_2'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SABOTAGE",
		GuideType = "ImageText",
	},
	[100703] = {
		ChildGuideId = 100703,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SABOTAGE_113",
				Phone = "DUNGEON_SABOTAGE_113",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Sabotage_Step_3.T_Guide_Img_Sabotage_Step_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Sabotage_Step_3.T_Guide_Img_Sabotage_Step_3'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SABOTAGE",
		GuideType = "ImageText",
	},
	[100704] = {
		ChildGuideId = 100704,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SABOTAGE_114",
				Phone = "DUNGEON_SABOTAGE_114",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Sabotage_Step_4.T_Guide_Img_Sabotage_Step_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Sabotage_Step_4.T_Guide_Img_Sabotage_Step_4'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SABOTAGE",
		GuideType = "ImageText",
	},
	[100705] = {
		ChildGuideId = 100705,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SABOTAGE_111",
				Phone = "DUNGEON_SABOTAGE_111",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Sabotage_Step_5.T_Guide_Img_Sabotage_Step_5'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Sabotage_Step_5.T_Guide_Img_Sabotage_Step_5'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SABOTAGE",
		GuideType = "ImageText",
	},
	[100801] = {
		ChildGuideId = 100801,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_RESCUE_101",
				Phone = "DUNGEON_RESCUE_101",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_1.T_Guide_Img_Rescue_Step_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_1.T_Guide_Img_Rescue_Step_1'",
			},
		},
		GuideTitle = "DUNGEON_NAME_30007",
		GuideType = "ImageText",
	},
	[100802] = {
		ChildGuideId = 100802,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_RESCUE_102",
				Phone = "DUNGEON_RESCUE_102",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_2.T_Guide_Img_Rescue_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_2.T_Guide_Img_Rescue_Step_2'",
			},
		},
		GuideTitle = "DUNGEON_NAME_30007",
		GuideType = "ImageText",
	},
	[100803] = {
		ChildGuideId = 100803,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_RESCUE_103",
				Phone = "DUNGEON_RESCUE_103",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_3.T_Guide_Img_Rescue_Step_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_3.T_Guide_Img_Rescue_Step_3'",
			},
		},
		GuideTitle = "DUNGEON_NAME_30007",
		GuideType = "ImageText",
	},
	[100804] = {
		ChildGuideId = 100804,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_RESCUE_104",
				Phone = "DUNGEON_RESCUE_104",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_4.T_Guide_Img_Rescue_Step_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_4.T_Guide_Img_Rescue_Step_4'",
			},
		},
		GuideTitle = "DUNGEON_NAME_30007",
		GuideType = "ImageText",
	},
	[100805] = {
		ChildGuideId = 100805,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_RESCUE_105",
				Phone = "DUNGEON_RESCUE_105",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_5.T_Guide_Img_Rescue_Step_5'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Rescue_Step_5.T_Guide_Img_Rescue_Step_5'",
			},
		},
		GuideTitle = "DUNGEON_NAME_30007",
		GuideType = "ImageText",
	},
	[100901] = {
		ChildGuideId = 100901,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_HIJACK_112",
				Phone = "DUNGEON_HIJACK_112",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Hijack_Step_1.T_Guide_Img_Hijack_Step_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Hijack_Step_1.T_Guide_Img_Hijack_Step_1'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_HIJACK",
		GuideType = "ImageText",
	},
	[100902] = {
		ChildGuideId = 100902,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_HIJACK_113",
				Phone = "DUNGEON_HIJACK_113",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Hijack_Step_2.T_Guide_Img_Hijack_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Hijack_Step_2.T_Guide_Img_Hijack_Step_2'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_HIJACK",
		GuideType = "ImageText",
	},
	[100903] = {
		ChildGuideId = 100903,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_HIJACK_114",
				Phone = "DUNGEON_HIJACK_114",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Hijack_Step_3.T_Guide_Img_Hijack_Step_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Hijack_Step_3.T_Guide_Img_Hijack_Step_3'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_HIJACK",
		GuideType = "ImageText",
	},
	[101001] = {
		ChildGuideId = 101001,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_EXTERMINATE_101",
				Phone = "DUNGEON_EXTERMINATE_101",
			},
			GuidePicture = T.RT_2,
		},
		GuideTitle = "UI_DUNGEON_TYPE_EXTERMINATE",
		GuideType = "ImageText",
	},
	[101002] = {
		ChildGuideId = 101002,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_EXTERMINATE_102",
				Phone = "DUNGEON_EXTERMINATE_102",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Exterminate_Step_2.T_Guide_Img_Exterminate_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Exterminate_Step_2.T_Guide_Img_Exterminate_Step_2'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_EXTERMINATE",
		GuideType = "ImageText",
	},
	[101101] = {
		ChildGuideId = 101101,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_EXTERMPRO_100",
				Phone = "DUNGEON_EXTERMPRO_100",
			},
			GuidePicture = T.RT_2,
		},
		GuideTitle = "UI_DUNGEON_TYPE_TESTING",
		GuideType = "ImageText",
	},
	[101201] = {
		ChildGuideId = 101201,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SABOTAGEPRO_102",
				Phone = "DUNGEON_SABOTAGEPRO_102",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SabotagePro_Step_1.T_Guide_Img_SabotagePro_Step_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SabotagePro_Step_1.T_Guide_Img_SabotagePro_Step_1'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SABOTAGEPRO",
		GuideType = "ImageText",
	},
	[101202] = {
		ChildGuideId = 101202,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SABOTAGEPRO_103",
				Phone = "DUNGEON_SABOTAGEPRO_103",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SabotagePro_Step_2.T_Guide_Img_SabotagePro_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_SabotagePro_Step_2.T_Guide_Img_SabotagePro_Step_2'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SABOTAGEPRO",
		GuideType = "ImageText",
	},
	[101301] = {
		ChildGuideId = 101301,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SYNTHESIS_119",
				Phone = "DUNGEON_SYNTHESIS_119",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_1.T_Guide_Img_Synthesis_Step_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_1.T_Guide_Img_Synthesis_Step_1'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESIS",
		GuideType = "ImageText",
	},
	[101302] = {
		ChildGuideId = 101302,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SYNTHESIS_120",
				Phone = "DUNGEON_SYNTHESIS_120",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_2.T_Guide_Img_Synthesis_Step_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_2.T_Guide_Img_Synthesis_Step_2'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESIS",
		GuideType = "ImageText",
	},
	[101303] = {
		ChildGuideId = 101303,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SYNTHESIS_121",
				Phone = "DUNGEON_SYNTHESIS_121",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_3.T_Guide_Img_Synthesis_Step_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_3.T_Guide_Img_Synthesis_Step_3'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESIS",
		GuideType = "ImageText",
	},
	[101304] = {
		ChildGuideId = 101304,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SYNTHESIS_122",
				Phone = "DUNGEON_SYNTHESIS_122",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_4.T_Guide_Img_Synthesis_Step_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_4.T_Guide_Img_Synthesis_Step_4'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESIS",
		GuideType = "ImageText",
	},
	[101305] = {
		ChildGuideId = 101305,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SYNTHESIS_123",
				Phone = "DUNGEON_SYNTHESIS_123",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_5.T_Guide_Img_Synthesis_Step_5'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_5.T_Guide_Img_Synthesis_Step_5'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESIS",
		GuideType = "ImageText",
	},
	[101306] = {
		ChildGuideId = 101306,
		GuideInfo1 = {
			GuideContent = {
				PC = "DUNGEON_SYNTHESIS_134",
				Phone = "DUNGEON_SYNTHESIS_134",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_6.T_Guide_Img_Synthesis_Step_6'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Synthesis_Step_6.T_Guide_Img_Synthesis_Step_6'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESIS",
		GuideType = "ImageText",
	},
	[101401] = {
		ChildGuideId = 101401,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "DUNGEON_SYNTHESIS2_119",
				PC = "DUNGEON_SYNTHESIS2_119",
				Phone = "DUNGEON_SYNTHESIS2_119",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_1.T_Guide_Img_WT2_1'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_1.T_Guide_Img_WT2_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_1.T_Guide_Img_WT2_1'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESISII",
		GuideType = "ImageText",
	},
	[101402] = {
		ChildGuideId = 101402,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "DUNGEON_SYNTHESIS2_120",
				PC = "DUNGEON_SYNTHESIS2_120",
				Phone = "DUNGEON_SYNTHESIS2_120",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_2.T_Guide_Img_WT2_2'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_2.T_Guide_Img_WT2_2'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_2.T_Guide_Img_WT2_2'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESISII",
		GuideType = "ImageText",
	},
	[101403] = {
		ChildGuideId = 101403,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "DUNGEON_SYNTHESIS2_121",
				PC = "DUNGEON_SYNTHESIS2_121",
				Phone = "DUNGEON_SYNTHESIS2_121",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_3.T_Guide_Img_WT2_3'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_3.T_Guide_Img_WT2_3'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_3.T_Guide_Img_WT2_3'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESISII",
		GuideType = "ImageText",
	},
	[101404] = {
		ChildGuideId = 101404,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "DUNGEON_SYNTHESIS2_122",
				PC = "DUNGEON_SYNTHESIS2_122",
				Phone = "DUNGEON_SYNTHESIS2_122",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_4.T_Guide_Img_WT2_4'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_4.T_Guide_Img_WT2_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_4.T_Guide_Img_WT2_4'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESISII",
		GuideType = "ImageText",
	},
	[101405] = {
		ChildGuideId = 101405,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "DUNGEON_SYNTHESIS2_123",
				PC = "DUNGEON_SYNTHESIS2_123",
				Phone = "DUNGEON_SYNTHESIS2_123",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_5.T_Guide_Img_WT2_5'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_5.T_Guide_Img_WT2_5'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_5.T_Guide_Img_WT2_5'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESISII",
		GuideType = "ImageText",
	},
	[101406] = {
		ChildGuideId = 101406,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "DUNGEON_SYNTHESIS2_124",
				PC = "DUNGEON_SYNTHESIS2_124",
				Phone = "DUNGEON_SYNTHESIS2_124",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_6.T_Guide_Img_WT2_6'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_6.T_Guide_Img_WT2_6'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_WT2_6.T_Guide_Img_WT2_6'",
			},
		},
		GuideTitle = "UI_DUNGEON_TYPE_SYNTHESISII",
		GuideType = "ImageText",
	},
	[200101] = {
		ChildGuideId = 200101,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_1",
				Phone = "UIGuide_Feina_1_Phone",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_15.T_Guide_Img_Feina_15'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_15.T_Guide_Img_Feina_15'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_15.T_Guide_Img_Feina_15'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_1",
		GuideType = "ImageText",
	},
	[200201] = {
		ChildGuideId = 200201,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_2",
				Phone = "UIGuide_Feina_2",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_13.T_Guide_Img_Feina_13'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_13.T_Guide_Img_Feina_13'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_13.T_Guide_Img_Feina_13'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_2",
		GuideType = "ImageText",
	},
	[200301] = {
		ChildGuideId = 200301,
		GuideInfo1 = {
			GuideContent = {
				GamePad = "UIGuide_Feina_3_Gamepad",
				PC = "UIGuide_Feina_3",
				Phone = "UIGuide_Feina_3_Phone",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_12.T_Guide_Img_Feina_12'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_12.T_Guide_Img_Feina_12'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_12.T_Guide_Img_Feina_12'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_3",
		GuideType = "ImageText",
	},
	[200401] = {
		ChildGuideId = 200401,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_4",
				Phone = "UIGuide_Feina_4",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_4.T_Guide_Img_Feina_4'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_4.T_Guide_Img_Feina_4'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_4.T_Guide_Img_Feina_4'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_4",
		GuideType = "ImageText",
	},
	[200501] = {
		ChildGuideId = 200501,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_5",
				Phone = "UIGuide_Feina_5",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_5.T_Guide_Img_Feina_5'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_5.T_Guide_Img_Feina_5'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_5.T_Guide_Img_Feina_5'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_5",
		GuideType = "ImageText",
	},
	[200601] = {
		ChildGuideId = 200601,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_6",
				Phone = "UIGuide_Feina_6",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_6.T_Guide_Img_Feina_6'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_6.T_Guide_Img_Feina_6'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_6.T_Guide_Img_Feina_6'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_6",
		GuideType = "ImageText",
	},
	[200701] = {
		ChildGuideId = 200701,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_7",
				Phone = "UIGuide_Feina_7",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_7.T_Guide_Img_Feina_7'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_7.T_Guide_Img_Feina_7'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_7.T_Guide_Img_Feina_7'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_7",
		GuideType = "ImageText",
	},
	[200801] = {
		ChildGuideId = 200801,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_8",
				Phone = "UIGuide_Feina_8",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_8.T_Guide_Img_Feina_8'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_8.T_Guide_Img_Feina_8'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_8.T_Guide_Img_Feina_8'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_8",
		GuideType = "ImageText",
	},
	[200901] = {
		ChildGuideId = 200901,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_9",
				Phone = "UIGuide_Feina_9",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_9.T_Guide_Img_Feina_9'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_9.T_Guide_Img_Feina_9'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_9.T_Guide_Img_Feina_9'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_9",
		GuideType = "ImageText",
	},
	[201001] = {
		ChildGuideId = 201001,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_10",
				Phone = "UIGuide_Feina_10",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_10.T_Guide_Img_Feina_10'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_10.T_Guide_Img_Feina_10'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_10.T_Guide_Img_Feina_10'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_10",
		GuideType = "ImageText",
	},
	[201101] = {
		ChildGuideId = 201101,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_11",
				Phone = "UIGuide_Feina_11",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_11.T_Guide_Img_Feina_11'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_11.T_Guide_Img_Feina_11'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_11.T_Guide_Img_Feina_11'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_11",
		GuideType = "ImageText",
	},
	[201201] = {
		ChildGuideId = 201201,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_Feina_12",
				Phone = "UIGuide_Feina_12",
			},
			GuidePicture = {
				GamePad = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_14.T_Guide_Img_Feina_14'",
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_14.T_Guide_Img_Feina_14'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Level/T_Guide_Img_Feina_14.T_Guide_Img_Feina_14'",
			},
		},
		GuideTitle = "MAINUIGUIDE_TITLE_Feina_12",
		GuideType = "ImageText",
	},
	[203001] = {
		ChildGuideId = 203001,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_content_203001",
				Phone = "UIGuide_content_203001",
			},
			GuidePicture = T.RT_6,
		},
		GuideTitle = "UIGuide_Title_203001",
		GuideType = "ImageText",
	},
	[203501] = {
		ChildGuideId = 203501,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_content_203501",
				Phone = "UIGuide_content_203501",
			},
			GuidePicture = T.RT_6,
		},
		GuideTitle = "UIGuide_Title_203501",
		GuideType = "ImageText",
	},
	[203601] = {
		ChildGuideId = 203601,
		GuideInfo1 = {
			GuideContent = {
				PC = "UIGuide_content_203601",
				Phone = "UIGuide_content_203601",
			},
			GuidePicture = T.RT_6,
			GuideSubTitle = "UIGuide_Title_203601",
		},
		GuideInfo2 = {
			GuideContent = {
				PC = "UIGuide_content_203602",
				Phone = "UIGuide_content_203602",
			},
			GuidePicture = T.RT_6,
			GuideSubTitle = "UIGuide_Title_203602",
		},
		GuideTitle = "UIGuide_Title_203601",
		GuideType = "ImageText",
	},
	[1001101] = {
		ChildGuideId = 1001101,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Frozen_01",
				Phone = "Mon_Guide_Strong_Frozen_01",
			},
			GuideDescValues = {
				"$#SkillEffects[600000102].TaskEffects[2].LastTime$",
				"$#Buff[6000102].MaxLayer$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Frozen_01.T_Guide_Img_Mon_Strong_Frozen_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Frozen_01.T_Guide_Img_Mon_Strong_Frozen_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Frozen",
		GuideType = "ImageText",
	},
	[1001201] = {
		ChildGuideId = 1001201,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Burst_01",
				Phone = "Mon_Guide_Strong_Burst_01",
			},
			GuideDescValues = {
				"$#Buff[6000103].DotDatas[1].Interval$",
				"$#SkillEffects[600000201].TaskEffects[3].LastTime$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Burst_01.T_Guide_Img_Mon_Strong_Burst_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Burst_01.T_Guide_Img_Mon_Strong_Burst_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Burst",
		GuideType = "ImageText",
	},
	[1001301] = {
		ChildGuideId = 1001301,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Poison_01",
				Phone = "Mon_Guide_Strong_Poison_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Poison_01.T_Guide_Img_Mon_Strong_Poison_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Poison_01.T_Guide_Img_Mon_Strong_Poison_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Poison",
		GuideType = "ImageText",
	},
	[1001401] = {
		ChildGuideId = 1001401,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Thunder_01",
				Phone = "Mon_Guide_Strong_Thunder_01",
			},
			GuideDescValues = {
				"$#DanmakuCreature[600000401].Vars.DamageInterval$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Thunder_01.T_Guide_Img_Mon_Strong_Thunder_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Thunder_01.T_Guide_Img_Mon_Strong_Thunder_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Thunder",
		GuideType = "ImageText",
	},
	[1001501] = {
		ChildGuideId = 1001501,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Blood_01",
				Phone = "Mon_Guide_Strong_Blood_01",
			},
			GuideDescValues = {
				"$#SkillEffects[600000501].TaskEffects[1].SingleSummonCount$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Blood_01.T_Guide_Img_Mon_Strong_Blood_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Blood_01.T_Guide_Img_Mon_Strong_Blood_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Blood",
		GuideType = "ImageText",
	},
	[1001502] = {
		ChildGuideId = 1001502,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Blood_02",
				Phone = "Mon_Guide_Strong_Blood_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Blood_02.T_Guide_Img_Mon_Strong_Blood_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Blood_02.T_Guide_Img_Mon_Strong_Blood_02'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Blood",
		GuideType = "ImageText",
	},
	[1001601] = {
		ChildGuideId = 1001601,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Fade_01",
				Phone = "Mon_Guide_Strong_Fade_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Fade_01.T_Guide_Img_Mon_Strong_Fade_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Fade_01.T_Guide_Img_Mon_Strong_Fade_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Fade",
		GuideType = "ImageText",
	},
	[1001701] = {
		ChildGuideId = 1001701,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Shield_01",
				Phone = "Mon_Guide_Strong_Shield_01",
			},
			GuideDescValues = {
				"$#SkillEffects[600000701].TaskEffects[1].LifeTime$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Shield_01.T_Guide_Img_Mon_Strong_Shield_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Shield_01.T_Guide_Img_Mon_Strong_Shield_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Shield",
		GuideType = "ImageText",
	},
	[1001801] = {
		ChildGuideId = 1001801,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Revenge_01",
				Phone = "Mon_Guide_Strong_Revenge_01",
			},
			GuideDescValues = {
				"$#SkillEffects[600000801].TaskEffects[1].LastTime$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Revenge_01.T_Guide_Img_Mon_Strong_Revenge_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Revenge_01.T_Guide_Img_Mon_Strong_Revenge_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Revenge",
		GuideType = "ImageText",
	},
	[1001901] = {
		ChildGuideId = 1001901,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_IceOrb_01",
				Phone = "Mon_Guide_Strong_IceOrb_01",
			},
			GuideDescValues = {
				"$#MechanismSummon[900901].BluePrintParams.SpeedDownTime$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_IceOrb_01.T_Guide_Img_Mon_Strong_IceOrb_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_IceOrb_01.T_Guide_Img_Mon_Strong_IceOrb_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_IceOrb",
		GuideType = "ImageText",
	},
	[1002001] = {
		ChildGuideId = 1002001,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Reflect_01",
				Phone = "Mon_Guide_Strong_Reflect_01",
			},
			GuideDescValues = {
				"$#SkillEffects[600001001].TaskEffects[1].LastTime$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Reflect_01.T_Guide_Img_Mon_Strong_Reflect_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Reflect_01.T_Guide_Img_Mon_Strong_Reflect_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Reflect",
		GuideType = "ImageText",
	},
	[1002101] = {
		ChildGuideId = 1002101,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Kamikaze_01",
				Phone = "Mon_Guide_Strong_Kamikaze_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Kamikaze_01.T_Guide_Img_Mon_Strong_Kamikaze_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Kamikaze_01.T_Guide_Img_Mon_Strong_Kamikaze_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Kamikaze",
		GuideType = "ImageText",
	},
	[1002201] = {
		ChildGuideId = 1002201,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_ThunderLaser_01",
				Phone = "Mon_Guide_Strong_ThunderLaser_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_ThunderLaser_01.T_Guide_Img_Mon_Strong_ThunderLaser_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_ThunderLaser_01.T_Guide_Img_Mon_Strong_ThunderLaser_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_ThunderLaser",
		GuideType = "ImageText",
	},
	[1002301] = {
		ChildGuideId = 1002301,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Vampire_01",
				Phone = "Mon_Guide_Strong_Vampire_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Vampire_01.T_Guide_Img_Mon_Strong_Vampire_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Vampire_01.T_Guide_Img_Mon_Strong_Vampire_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Vampire",
		GuideType = "ImageText",
	},
	[1002401] = {
		ChildGuideId = 1002401,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Threefold_01",
				Phone = "Mon_Guide_Strong_Threefold_01",
			},
			GuideDescValues = {
				"$#SkillEffects[600001401].TaskEffects[1].SingleSummonCount$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Threefold_01.T_Guide_Img_Mon_Strong_Threefold_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Threefold_01.T_Guide_Img_Mon_Strong_Threefold_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Threefold",
		GuideType = "ImageText",
	},
	[1010001] = {
		ChildGuideId = 1010001,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_Strong_Multiple_01",
				Phone = "Mon_Guide_Strong_Multiple_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Multiple_01.T_Guide_Img_Mon_Strong_Multiple_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_Strong_Multiple_01.T_Guide_Img_Mon_Strong_Multiple_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_Strong_Multiple",
		GuideType = "ImageText",
	},
	[600600101] = {
		ChildGuideId = 600600101,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_6006001_01",
				Phone = "Mon_Guide_6006001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_6006001_01.T_Guide_Img_Mon_6006001_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_6006001_01.T_Guide_Img_Mon_6006001_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_6006001",
		GuideType = "ImageText",
	},
	[600700101] = {
		ChildGuideId = 600700101,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_6007001_01",
				Phone = "Mon_Guide_6007001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_6007001_01.T_Guide_Img_Mon_6007001_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_6007001_01.T_Guide_Img_Mon_6007001_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_6007001",
		GuideType = "ImageText",
	},
	[601500101] = {
		ChildGuideId = 601500101,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_6015001_01",
				Phone = "Mon_Guide_6015001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_6015001_01.T_Guide_Img_Mon_6015001_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_6015001_01.T_Guide_Img_Mon_6015001_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_6015001",
		GuideType = "ImageText",
	},
	[700100501] = {
		ChildGuideId = 700100501,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7001005_01",
				Phone = "Mon_Guide_7001005_01",
			},
			GuideDescValues = {
				"$#PassiveEffect[700121].Vars.LastTime$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7001005_01.T_Guide_Img_Mon_7001005_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7001005_01.T_Guide_Img_Mon_7001005_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7001005",
		GuideType = "ImageText",
	},
	[700100502] = {
		ChildGuideId = 700100502,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7001005_02",
				Phone = "Mon_Guide_7001005_02",
			},
			GuideDescValues = {
				"$#PassiveEffect[700121].Vars.SpareCD$",
				"$#PassiveEffect[700121].Vars.LastTime$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7001005_02.T_Guide_Img_Mon_7001005_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7001005_02.T_Guide_Img_Mon_7001005_02'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7001005",
		GuideType = "ImageText",
	},
	[700200501] = {
		ChildGuideId = 700200501,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7002005_01",
				Phone = "Mon_Guide_7002005_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7002005_01.T_Guide_Img_Mon_7002005_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7002005_01.T_Guide_Img_Mon_7002005_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7002005",
		GuideType = "ImageText",
	},
	[700200502] = {
		ChildGuideId = 700200502,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7002005_02",
				Phone = "Mon_Guide_7002005_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7002005_02.T_Guide_Img_Mon_7002005_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7002005_02.T_Guide_Img_Mon_7002005_02'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7002005",
		GuideType = "ImageText",
	},
	[700200503] = {
		ChildGuideId = 700200503,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7002005_03",
				Phone = "Mon_Guide_7002005_03",
			},
			GuideDescValues = {
				"$#SkillEffects[700722].TaskEffects[3].LastTime$",
				"$#SkillEffects[700721].TaskEffects[1].LastTime$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7002005_03.T_Guide_Img_Mon_7002005_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7002005_03.T_Guide_Img_Mon_7002005_03'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7002005",
		GuideType = "ImageText",
	},
	[700300501] = {
		ChildGuideId = 700300501,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7003005_01",
				Phone = "Mon_Guide_7003005_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7003005_01.T_Guide_Img_Mon_7003005_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7003005_01.T_Guide_Img_Mon_7003005_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7003005",
		GuideType = "ImageText",
	},
	[700300502] = {
		ChildGuideId = 700300502,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7003005_02",
				Phone = "Mon_Guide_7003005_02",
			},
			GuideDescValues = {
				"$#SkillEffects[700323].TaskEffects[5].LastTime$",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7003005_02.T_Guide_Img_Mon_7003005_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7003005_02.T_Guide_Img_Mon_7003005_02'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7003005",
		GuideType = "ImageText",
	},
	[700700201] = {
		ChildGuideId = 700700201,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7007002_01",
				Phone = "Mon_Guide_7007002_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7007002_01.T_Guide_Img_Mon_7007002_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7007002_01.T_Guide_Img_Mon_7007002_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7007002",
		GuideType = "ImageText",
	},
	[700800101] = {
		ChildGuideId = 700800101,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7008001_01",
				Phone = "Mon_Guide_7008001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7008001_01.T_Guide_Img_Mon_7008001_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7008001_01.T_Guide_Img_Mon_7008001_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7008001",
		GuideType = "ImageText",
	},
	[700800102] = {
		ChildGuideId = 700800102,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7008001_02",
				Phone = "Mon_Guide_7008001_02",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7008001_02.T_Guide_Img_Mon_7008001_02'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7008001_02.T_Guide_Img_Mon_7008001_02'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7008001",
		GuideType = "ImageText",
	},
	[700800103] = {
		ChildGuideId = 700800103,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7008001_03",
				Phone = "Mon_Guide_7008001_03",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7008001_03.T_Guide_Img_Mon_7008001_03'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7008001_03.T_Guide_Img_Mon_7008001_03'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7008001",
		GuideType = "ImageText",
	},
	[701500101] = {
		ChildGuideId = 701500101,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_7015001_01",
				Phone = "Mon_Guide_7015001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7015001.T_Guide_Img_Mon_7015001'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_7015001.T_Guide_Img_Mon_7015001'",
			},
		},
		GuideTitle = "Mon_Guide_Title_7015001",
		GuideType = "ImageText",
	},
	[850100201] = {
		ChildGuideId = 850100201,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_8501002_01",
				Phone = "Mon_Guide_8501002_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_8501002_01.T_Guide_Img_Mon_8501002_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_8501002_01.T_Guide_Img_Mon_8501002_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_8501002",
		GuideType = "ImageText",
	},
	[851500101] = {
		ChildGuideId = 851500101,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_8515001_01",
				Phone = "Mon_Guide_8515001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_8515001_01.T_Guide_Img_Mon_8515001_01'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_8515001_01.T_Guide_Img_Mon_8515001_01'",
			},
		},
		GuideTitle = "Mon_Guide_Title_8515001",
		GuideType = "ImageText",
	},
	[900300401] = {
		ChildGuideId = 900300401,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_9003001_01",
				Phone = "Mon_Guide_9003001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_9003001_1.T_Guide_Img_Mon_9003001_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_9003001_1.T_Guide_Img_Mon_9003001_1'",
			},
		},
		GuideTitle = "Mon_Guide_Title_9003004",
		GuideType = "ImageText",
	},
	[900500401] = {
		ChildGuideId = 900500401,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_9005001_01",
				Phone = "Mon_Guide_9005001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_9005001_1.T_Guide_Img_Mon_9005001_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_9005001_1.T_Guide_Img_Mon_9005001_1'",
			},
		},
		GuideTitle = "Mon_Guide_Title_9005004",
		GuideType = "ImageText",
	},
	[900600401] = {
		ChildGuideId = 900600401,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_9006001_01",
				Phone = "Mon_Guide_9006001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_9006001_1.T_Guide_Img_Mon_9006001_1'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_9006001_1.T_Guide_Img_Mon_9006001_1'",
			},
		},
		GuideTitle = "Mon_Guide_Title_9006004",
		GuideType = "ImageText",
	},
	[950000101] = {
		ChildGuideId = 950000101,
		GuideInfo1 = {
			GuideContent = {
				PC = "Mon_Guide_9500001_01",
				Phone = "Mon_Guide_9500001_01",
			},
			GuidePicture = {
				PC = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_9500001.T_Guide_Img_Mon_9500001'",
				Phone = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guide/Battle/T_Guide_Img_Mon_9500001.T_Guide_Img_Mon_9500001'",
			},
		},
		GuideTitle = "Mon_Guide_Title_9500001",
		GuideType = "ImageText",
	},
})