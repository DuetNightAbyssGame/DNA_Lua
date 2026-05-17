-- Source Excel file path: ..\datas\Achievement.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AchievementTest", {
	[1] = {
		Count = 1,
		Index = 1,
		Param1Int = 200101,
		TargetId = 70102,
		TargetType = 10701,
	},
	[2] = {
		Count = 1,
		Index = 2,
		TargetId = 1080201,
		TargetType = 10802,
	},
})