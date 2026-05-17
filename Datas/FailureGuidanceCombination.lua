-- Source Excel file path: ..\datas\FailureGuidance.xlsx
local T = {}
T.RT_1 = {
		1001,
		1002,
		1003,
		1005,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FailureGuidanceCombination", {
	[100001] = {
		CombinationId = 100001,
		GuidanceModuleId = T.RT_1,
		GuidanceTitle1 = "UI_DungeonFail_Tips1",
		GuidanceTitle2 = "UI_DungeonFail_Tips2",
		GuidanceType = 1,
	},
	[100002] = {
		CombinationId = 100002,
		GuidanceModuleId = {
			1001,
			1002,
			1004,
			1005,
		},
		GuidanceTitle1 = "UI_DungeonFail_Tips1",
		GuidanceTitle2 = "UI_DungeonFail_Tips2",
		GuidanceType = 1,
	},
	[100003] = {
		CombinationId = 100003,
		GuidanceModuleId = T.RT_1,
		GuidanceTitle1 = "UI_DungeonFail_Tips1",
		GuidanceTitle2 = "UI_DungeonFail_Tips2",
		GuidanceType = 1,
	},
	[200001] = {
		CombinationId = 200001,
		GuidanceModuleId = T.RT_1,
		GuidanceTitle1 = "UI_DungeonFail_Tips1",
		GuidanceTitle2 = "UI_DungeonFail_Tips2",
		GuidanceType = 2,
	},
})