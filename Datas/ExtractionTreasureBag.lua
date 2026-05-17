-- Source Excel file path: ..\datas\Extraction\ExtractionTreasureBag.xlsx
local T = {}
T.RT_1 = {
		2,
		2,
	}
T.RT_2 = {
		1,
		3,
	}
T.RT_3 = {
		3,
		3,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ExtractionTreasureBag", {
	[1] = {
		BagID = 1,
		Desc = "24.0",
		Name = "SoloTreasure_Backpack01",
		Price = 0,
		Shape = {
			T.RT_1,
			T.RT_1,
			{
				4,
				4,
			},
		},
		ShapeType = 1,
	},
	[2] = {
		BagID = 2,
		Desc = "35.0",
		EventUnlockCondition = 10301417,
		Name = "SoloTreasure_Backpack02",
		Price = 200,
		Shape = {
			T.RT_2,
			T.RT_3,
			T.RT_2,
			{
				5,
				4,
			},
		},
		ShapeType = 0,
		ShopItemId = 10007121,
	},
	[3] = {
		BagID = 3,
		Desc = "45.0",
		EventUnlockCondition = 10301418,
		Name = "SoloTreasure_Backpack03",
		Price = 300,
		Shape = {
			T.RT_2,
			T.RT_3,
			T.RT_2,
			{
				5,
				6,
			},
		},
		ShapeType = 0,
		ShopItemId = 10007122,
	},
	[4] = {
		BagID = 4,
		Desc = "55.0",
		EventUnlockCondition = 10301419,
		Name = "SoloTreasure_Backpack04",
		Price = 400,
		Shape = {
			T.RT_2,
			T.RT_3,
			T.RT_2,
			{
				5,
				3,
			},
			{
				5,
				5,
			},
		},
		ShapeType = 2,
		ShopItemId = 10007123,
	},
	[5] = {
		BagID = 5,
		Desc = "60.0",
		EventUnlockCondition = 10301420,
		Name = "SoloTreasure_Backpack05",
		Price = 500,
		Shape = {
			{
				5,
				12,
			},
		},
		ShapeType = 3,
		ShopItemId = 10007124,
	},
	[6] = {
		BagID = 6,
		Desc = "70.0",
		EventUnlockCondition = 10301421,
		Name = "SoloTreasure_Backpack06",
		Price = 600,
		Shape = {
			{
				5,
				14,
			},
		},
		ShapeType = 3,
	},
})