-- Source Excel file path: ..\datas\Extraction\ExtractionTreasureMechanism.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ExtractionTreasureGuard", {
	[131067] = {
		MechanismID = 131067,
		MechanismItemBox = 131065,
		MechanismName = "守护机关1",
		RepairSpeed = 0.1,
	},
})