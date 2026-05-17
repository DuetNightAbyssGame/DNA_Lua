-- Source Excel file path: ..\datas\Extraction\ExtractionTreasure.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ExtractionTreasureRarity", {
	[1] = {
		IdentifyTime = 1,
		ShowRarity = 2,
		TreasureRarity = 1,
	},
	[2] = {
		IdentifyTime = 1.5,
		ShowRarity = 4,
		TreasureRarity = 2,
	},
	[3] = {
		IdentifyTime = 2,
		ShowRarity = 5,
		TreasureRarity = 3,
	},
	[4] = {
		IdentifyTime = 2.5,
		ShowRarity = 6,
		TreasureRarity = 4,
	},
	[5] = {
		IdentifyTime = 3,
		ShowRarity = 6,
		TreasureRarity = 5,
	},
	[6] = {
		IdentifyTime = 2,
		ShowRarity = 5,
		TreasureRarity = 6,
	},
})