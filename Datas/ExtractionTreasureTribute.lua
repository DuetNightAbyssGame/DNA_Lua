-- Source Excel file path: ..\datas\Extraction\ExtractionTreasureMechanism.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ExtractionTreasureTribute", {
	[131069] = {
		MechanismID = 131069,
		MechanismName = "献祭机关1",
		Shape = {
			5,
			4,
		},
		UnlockPoint = 10,
	},
})