-- Source Excel file path: ..\datas\Combat\ServerEffect.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ServerEffect", {
	[1] = {
		Id = 1,
		Name = "ForbidGetExp",
	},
})