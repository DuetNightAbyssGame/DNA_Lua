-- Source Excel file path: ..\datas\CDNWeight.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("InternalCDNWeight", {
	["http://10.18.200.86:9000/pan01/Patches/FinalPatch/"] = {
		CDNPath = "http://10.18.200.86:9000/pan01/Patches/FinalPatch/",
		IsGlobal = false,
		Weight = 75,
	},
})