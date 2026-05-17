-- Source Excel file path: ..\datas\Extraction\ExtractionTreasureMechanism.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ExtractionTreasureTicket", {
	[92001] = {
		MechanismID = 92001,
		MechanismName = "扭蛋机1",
		RenewalPoint = {
			50,
			100,
			150,
			200,
			250,
		},
		UnlockPoint = 30,
	},
})