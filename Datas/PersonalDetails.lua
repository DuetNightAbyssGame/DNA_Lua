-- Source Excel file path: ..\datas\PersonalDetails.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PersonalDetails", {
	Abyss_Difficulty = {
		DataType = "String",
		Des = "UI_Deteal_Abyss_3",
		Event = "Abyss_Difficulty",
		Sort = 1,
		TabID = 101,
	},
	Abyss_Star = {
		DataType = "Int",
		Des = "UI_Deteal_Abyss_4",
		Event = "Abyss_Star",
		Sort = 3,
		TabID = 101,
	},
	Rouge_Difficulty = {
		DataType = "Int",
		Des = "UI_Deteal_Rouge_2",
		Event = "Rouge_Difficulty",
		Sort = 4,
		TabID = 102,
	},
})