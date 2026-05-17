-- Source Excel file path: ..\datas\SoundEffect.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AuPOParam", {
	DistanceLimit = {
		ParamName = "DistanceLimit",
		ParamValue = 30,
	},
	HighPriorityNum = {
		ParamName = "HighPriorityNum",
		ParamValue = 8,
	},
	LowPriorityNum = {
		ParamName = "LowPriorityNum",
		ParamValue = 2,
	},
	MidPriorityNum = {
		ParamName = "MidPriorityNum",
		ParamValue = 4,
	},
	TimeLimit = {
		ParamName = "TimeLimit",
		ParamValue = 1,
	},
})