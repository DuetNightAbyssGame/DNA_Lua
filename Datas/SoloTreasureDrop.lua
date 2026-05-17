-- Source Excel file path: ..\datas\Dungeons\SoloTreasure.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SoloTreasureDrop", {
	["Mon.SoloTreasure.AContainer"] = {
		BoxDropRate = 0.5,
		DropMechanismId = 131076,
		MonsterTag = "Mon.SoloTreasure.AContainer",
	},
	["Mon.SoloTreasure.APoint"] = {
		KillScore = 20,
		MonsterTag = "Mon.SoloTreasure.APoint",
	},
	["Mon.SoloTreasure.BContainer"] = {
		BoxDropRate = 0.5,
		DropMechanismId = 131061,
		MonsterTag = "Mon.SoloTreasure.BContainer",
	},
	["Mon.SoloTreasure.BPoint"] = {
		KillScore = 10,
		MonsterTag = "Mon.SoloTreasure.BPoint",
	},
})