-- Source Excel file path: ..\datas\Combat\Phantom.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PhantomGetDrop", {
	[1001] = {
		IsCanDrop = true,
		UnitId = 1001,
	},
	[1002] = {
		IsCanDrop = true,
		UnitId = 1002,
	},
	[1003] = {
		IsCanDrop = true,
		UnitId = 1003,
	},
})