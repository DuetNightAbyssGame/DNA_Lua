-- Source Excel file path: ..\datas\Dungeons\Party.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PartyDebuff", {
	[5000202] = {
		BuffID = 5000202,
	},
	[5000205] = {
		BuffID = 5000205,
	},
})