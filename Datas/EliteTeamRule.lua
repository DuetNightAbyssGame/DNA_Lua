-- Source Excel file path: ..\datas\Combat\FormationData.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("EliteTeamRule", {
	[1] = {
		FilterTags = {
			"Mon.Ranged",
			"Mon.Jt",
		},
		Id = 1,
	},
})