-- Source Excel file path: ..\datas\Dungeons\SabotagePro.xlsx
local T = {}
T.RT_1 = {
		10705,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SabotagePro", {
	[60201] = {
		DungeonId = 60201,
		MonsterSpawnIds = T.RT_1,
		TimeLimit = 90,
	},
	[60202] = {
		DungeonId = 60202,
		MonsterSpawnIds = T.RT_1,
		TimeLimit = 90,
	},
	[62201] = {
		DungeonId = 62201,
		MonsterSpawnIds = T.RT_1,
		TimeLimit = 90,
	},
	[62202] = {
		DungeonId = 62202,
		MonsterSpawnIds = T.RT_1,
		TimeLimit = 90,
	},
	[64201] = {
		DungeonId = 64201,
		MonsterSpawnIds = T.RT_1,
		TimeLimit = 90,
	},
	[64202] = {
		DungeonId = 64202,
		MonsterSpawnIds = T.RT_1,
		TimeLimit = 90,
	},
})