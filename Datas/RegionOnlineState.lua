-- Source Excel file path: ..\datas\RegionOnline.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("RegionOnlineState", {
	[1] = {
		NumRange = 30,
		StateId = 1,
	},
	[2] = {
		NumRange = 70,
		StateId = 2,
	},
	[3] = {
		NumRange = 100,
		StateId = 3,
	},
})