-- Source Excel file path: ..\datas\GameEvent\BackpackPuzzleEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("BackpackPuzzleConstant", {
	BackPackGrid_High = {
		ConstantName = "BackPackGrid_High",
		ConstantValue = 8,
	},
	BackPackGrid_Length = {
		ConstantName = "BackPackGrid_Length",
		ConstantValue = 10,
	},
	BackPack_AmmoId = {
		ConstantName = "BackPack_AmmoId",
		ConstantValue = 201,
	},
	BagGameEventId = {
		ConstantName = "BagGameEventId",
		ConstantValue = 103015,
	},
})