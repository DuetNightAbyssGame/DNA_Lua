-- Source Excel file path: ..\datas\Dungeons\Trial.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("TrialTask", {
	[1] = {
		IsKillMonsterTask = false,
		TaskId = 1,
		TextMap = "DUNGEONSINGLE",
		TextTitle = "UI_CharTrial_Title",
		TexturePath = "MainMission",
		WidgetPath = "Guide_Point",
	},
	[2] = {
		IsKillMonsterTask = true,
		MonsterSpawnId = {
			9000101,
		},
		TargetNum = 40,
		TaskId = 2,
		TextMap = "TARGET_DUNGEON_TRAINING_102",
		TextTitle = "UI_CharTrial_Title",
		TexturePath = "DefeatMission",
		WidgetPath = "Guide_Point",
	},
	[3] = {
		IsKillMonsterTask = false,
		TaskId = 3,
		TextMap = "TARGET_DUNGEON_103",
		TextTitle = "UI_CharTrial_Title",
		TexturePath = "Evacuation",
		WidgetPath = "Guide_Point",
	},
})