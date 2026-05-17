-- Source Excel file path: ..\datas\Dungeon.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("WeeklySelectDungeon", {
	[1] = {
		ChapterId = 1,
		ChapterName = "UI_DUNGEON_TYPE_SYNTHESIS",
		ChapterSubName = "UI_DUNGEON_DROP_MOD",
		DungeonList = {
			91302,
			91304,
			91306,
			91307,
			91308,
		},
		GuidanceTitle = 200001,
		Path = "/Game/UI/Texture/Dynamic/Atlas/Permanent/T_Play_Weekly01.T_Play_Weekly01",
		RewardViewId = 90012,
		Sequence = 10,
	},
	[2] = {
		ChapterId = 2,
		ChapterName = "UI_DUNGEON_TYPE_SYNTHESISII",
		ChapterSubName = "UI_DUNGEON_DROP_MOD",
		DungeonList = {
			91502,
			91504,
			91506,
			91507,
			91508,
		},
		GuidanceTitle = 200001,
		Path = "/Game/UI/Texture/Dynamic/Atlas/Permanent/T_Play_Weekly02.T_Play_Weekly02",
		RewardViewId = 90012,
		Sequence = 10,
	},
})