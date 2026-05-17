-- Source Excel file path: ..\datas\Combat\Mark.xlsx
local T = {}
T.RT_1 = {
		2060301,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("Mark", {
	[150401] = {
		MarkId = 150401,
		VisualEffects = T.RT_1,
	},
	[2060301] = {
		MarkId = 2060301,
		VisualEffects = T.RT_1,
	},
})