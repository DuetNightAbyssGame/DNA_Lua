-- Source Excel file path: ..\datas\GameEvent\DoubleModDrop.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ModDropConstant", {
	DailyFreeTicketAmount = {
		ConstantName = "DailyFreeTicketAmount",
		ConstantValue = 1,
	},
	DailyModDungeonAmount = {
		ConstantName = "DailyModDungeonAmount",
		ConstantValue = 6,
	},
	EventBonus = {
		ConstantName = "EventBonus",
		ConstantValue = 30000,
	},
})