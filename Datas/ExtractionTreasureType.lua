-- Source Excel file path: ..\datas\Extraction\ExtractionTreasure.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ExtractionTreasureType", {
	[1] = {
		Name = "UI_ExtreactionTreasure_Type_1",
		TreasureRarity = 1,
	},
	[2] = {
		Name = "UI_ExtreactionTreasure_Type_2",
		TreasureRarity = 2,
	},
	[3] = {
		Name = "UI_ExtreactionTreasure_Type_3",
		TreasureRarity = 3,
	},
	[4] = {
		Name = "UI_ExtreactionTreasure_Type_4",
		TreasureRarity = 4,
	},
	[5] = {
		Name = "UI_ExtreactionTreasure_Type_5",
		TreasureRarity = 5,
	},
})