-- Source Excel file path: ..\datas\Combat\Mod.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ModUniteType", {
	test = {
		Id = "test",
	},
})