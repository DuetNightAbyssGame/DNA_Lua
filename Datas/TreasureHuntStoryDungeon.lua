-- Source Excel file path: ..\datas\Extraction\TreasureHuntEvent.xlsx
local T = {}
T.RT_1 = {
		1,
		2,
		3,
		4,
		5,
		6,
	}
T.RT_2 = {
		1101,
	}
T.RT_3 = {
		10101,
		20101,
	}
T.RT_4 = {
		701101,
	}
T.RT_5 = {
		605,
	}
T.RT_6 = {
		4010101,
		4020101,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TreasureHuntStoryDungeon", {
	[10301411] = {
		DungeonDes = "StoryDungeon01_Des",
		DungeonId = 41801,
		DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/Encyclopedia/T_Encyclopedia_56.T_Encyclopedia_56'",
		DungeonName = "StoryDungeon01_Title",
		EventDugeonId = 10301411,
		Fee = 0,
		FeeResource = 6000004,
		IsBanPhantom = false,
		LevelBackPack = T.RT_1,
		LimitCharacter = T.RT_2,
		LimitWeapon = T.RT_3,
		TrialCharacter = T.RT_4,
		TrialPet = T.RT_5,
		TrialWeapon = T.RT_6,
		UnlockCondition = 10301422,
	},
	[10301412] = {
		DungeonDes = "StoryDungeon02_Des",
		DungeonId = 41803,
		DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/Encyclopedia/T_Encyclopedia_56.T_Encyclopedia_56'",
		DungeonName = "StoryDungeon02_Title",
		EventDugeonId = 10301412,
		Fee = 1000,
		FeeResource = 6000004,
		IsBanPhantom = false,
		LevelBackPack = T.RT_1,
		LimitCharacter = T.RT_2,
		LimitWeapon = T.RT_3,
		TrialCharacter = T.RT_4,
		TrialPet = T.RT_5,
		TrialWeapon = T.RT_6,
		UnlockCondition = 10301423,
	},
	[10301413] = {
		DungeonDes = "StoryDungeon03_Des",
		DungeonId = 41805,
		DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/Encyclopedia/T_Encyclopedia_56.T_Encyclopedia_56'",
		DungeonName = "StoryDungeon03_Title",
		EventDugeonId = 10301413,
		Fee = 2000,
		FeeResource = 6000004,
		IsBanPhantom = false,
		LevelBackPack = T.RT_1,
		LimitCharacter = T.RT_2,
		LimitWeapon = T.RT_3,
		TrialCharacter = T.RT_4,
		TrialPet = T.RT_5,
		TrialWeapon = T.RT_6,
		UnlockCondition = 10301424,
	},
	[10301414] = {
		DungeonDes = "StoryDungeon04_Des",
		DungeonId = 41807,
		DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/Encyclopedia/T_Encyclopedia_56.T_Encyclopedia_56'",
		DungeonName = "StoryDungeon04_Title",
		EventDugeonId = 10301414,
		Fee = 3000,
		FeeResource = 6000004,
		IsBanPhantom = false,
		LevelBackPack = T.RT_1,
		LimitCharacter = T.RT_2,
		LimitWeapon = T.RT_3,
		TrialCharacter = T.RT_4,
		TrialPet = T.RT_5,
		TrialWeapon = T.RT_6,
		UnlockCondition = 10301425,
	},
	[10301415] = {
		DungeonDes = "StoryDungeon05_Des",
		DungeonId = 41809,
		DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/Encyclopedia/T_Encyclopedia_56.T_Encyclopedia_56'",
		DungeonName = "StoryDungeon05_Title",
		EventDugeonId = 10301415,
		Fee = 5000,
		FeeResource = 6000004,
		IsBanPhantom = false,
		LevelBackPack = T.RT_1,
		LimitCharacter = T.RT_2,
		LimitWeapon = T.RT_3,
		TrialCharacter = T.RT_4,
		TrialPet = {
			-1,
		},
		TrialWeapon = T.RT_6,
		UnlockCondition = 10301426,
	},
})