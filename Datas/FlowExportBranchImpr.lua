local T = {}
T.RT_1 = {
}
T.RT_2 = {
}
T.RT_3 = {
}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FlowExportBranchImpr", {
	[12022315] = {
	},
	[12040210] = T.RT_1,
	[12040211] = T.RT_1,
	[12045514] = {
	},
	[120104291] = T.RT_3,
	[120104292] = T.RT_3,
	[120131061] = T.RT_2,
	[120131062] = T.RT_2,
})