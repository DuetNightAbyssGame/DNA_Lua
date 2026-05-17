-- Source Excel file path: ..\datas\Combat\CombatVersionControl.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CombatVersionControl", {
	[1] = {
		CombatVersionOpen = {
			10,
			11,
			12,
			13,
		},
		Id = 1,
	},
})