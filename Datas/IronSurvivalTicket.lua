-- Source Excel file path: ..\datas\DungeonIronSurvival.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("IronSurvivalTicket", {
	[1001] = {
		Level = 70,
		TicketId = 1001,
	},
})