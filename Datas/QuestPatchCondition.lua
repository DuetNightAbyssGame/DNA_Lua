-- Source Excel file path: ..\datas\PatchCondition.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("QuestPatchCondition", {
	[100103] = {
		AutoPatch = "Patch_East",
		NecessaryPatch = {
			"Patch_Icelake",
		},
		QuestChainID = 100103,
	},
	[120003] = {
		NecessaryPatch = {
			"Patch_Icelake",
			"Patch_East",
		},
		QuestChainID = 120003,
	},
})