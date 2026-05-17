-- Source Excel file path: ..\datas\Dungeons\ServerEvents\SoloTreasureServerEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SoloTreasureServerEvent", {
	[1] = {
		EventID = 1,
		EventName = {
			[1] = "ActiveStaticCreator",
			[2] = "ActiveMonsterSpawn",
			[3] = "MyCustomFunc",
		},
		EventParams = {
			[1] = {
				CreatorId = 1001,
			},
			[2] = {
				MonsterSpawnId = 2001,
				OnlyRelation = "false",
			},
			[3] = {
				MyParam1 = 101001,
				MyParam2 = "true",
			},
		},
		TriggerType = "Single",
	},
})