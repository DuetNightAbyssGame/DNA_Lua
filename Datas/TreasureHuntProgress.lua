-- Source Excel file path: ..\datas\Extraction\TreasureHuntEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TreasureHuntProgress", {
	[1001] = {
		EventDugeonId = 10301411,
		EventProgressId = 1001,
		EventProgressText = "EventProgress_01",
		NextProgressScore = 20000,
		PetConBP = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/SoloTreasure/T_SoloTreasure_Bird01.T_SoloTreasure_Bird01'",
		PetConText = "Pet_Con01",
		ProgressCondition = 10301422,
	},
	[1002] = {
		EventDugeonId = 10301412,
		EventProgressId = 1002,
		EventProgressText = "EventProgress_02",
		NextProgressScore = 50000,
		PetConBP = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/SoloTreasure/T_SoloTreasure_Bird02.T_SoloTreasure_Bird02'",
		PetConText = "Pet_Con02",
		ProgressCondition = 10301423,
	},
	[1003] = {
		EventDugeonId = 10301413,
		EventProgressId = 1003,
		EventProgressText = "EventProgress_03",
		NextProgressScore = 80000,
		PetConBP = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/SoloTreasure/T_SoloTreasure_Bird03.T_SoloTreasure_Bird03'",
		PetConText = "Pet_Con03",
		ProgressCondition = 10301424,
	},
	[1004] = {
		EventDugeonId = 10301414,
		EventProgressId = 1004,
		EventProgressText = "EventProgress_04",
		NextProgressScore = 120000,
		PetConBP = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/SoloTreasure/T_SoloTreasure_Bird04.T_SoloTreasure_Bird04'",
		PetConText = "Pet_Con04",
		ProgressCondition = 10301425,
	},
	[1005] = {
		EventDugeonId = 10301415,
		EventProgressId = 1005,
		EventProgressText = "EventProgress_05",
		NextProgressScore = 120000,
		PetConBP = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/SoloTreasure/T_SoloTreasure_Bird05.T_SoloTreasure_Bird05'",
		PetConText = "Pet_Con05",
		ProgressCondition = 10301426,
	},
})