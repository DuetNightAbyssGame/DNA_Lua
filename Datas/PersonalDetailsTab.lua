-- Source Excel file path: ..\datas\PersonalDetails.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PersonalDetailsTab", {
	[101] = {
		Name = "Abyss_entry",
		TabID = 101,
	},
	[102] = {
		Name = "MAIN_UI_ROUGE",
		TabID = 102,
	},
})