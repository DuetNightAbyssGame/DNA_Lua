-- Source Excel file path: ..\datas\Dungeons\MonsterRush.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MonsterRushDungeon", {
	[22001] = {
		LevelId = 22001,
		MonsterList = {
			2200101,
			2200102,
		},
		StaticCreatorList = {
			2560001,
			2010194,
			2560008,
			1120008,
			1120009,
		},
		TargetNum = 300,
	},
	[22002] = {
		LevelId = 22002,
		MonsterList = {
			2200201,
			2200202,
		},
		StaticCreatorList = {
			2570002,
			2010194,
			2570008,
			1710055,
			1710061,
		},
		TargetNum = 300,
	},
	[22003] = {
		LevelId = 22003,
		MonsterList = {
			2200301,
			2200302,
		},
		StaticCreatorList = {
			2560003,
			2010194,
			2560008,
			1120008,
			1120009,
		},
		TargetNum = 300,
	},
	[22004] = {
		GlobalPassiveList = {
			22002,
		},
		LevelId = 22004,
		MonsterList = {
			2200401,
			2200402,
		},
		StaticCreatorList = {
			2570009,
			2010194,
			2570008,
			1710055,
			1710061,
		},
		TargetNum = 300,
	},
	[22005] = {
		GlobalPassiveList = {
			22001,
		},
		LevelId = 22005,
		MonsterList = {
			2200501,
			2200502,
		},
		StaticCreatorList = {
			2560004,
			2010194,
			2560008,
			1120008,
			1120009,
		},
		TargetNum = 300,
	},
	[22006] = {
		GlobalPassiveList = {
			22003,
		},
		LevelId = 22006,
		MonsterList = {
			2200601,
			2200602,
		},
		StaticCreatorList = {
			2570005,
			2010194,
			2570008,
			1710055,
			1710061,
		},
		TargetNum = 300,
	},
	[22007] = {
		GlobalPassiveList = {
			22004,
		},
		LevelId = 22007,
		MonsterList = {
			2200701,
			2200702,
		},
		StaticCreatorList = {
			2560007,
			2010191,
			2560008,
			1120008,
			1120009,
		},
		TargetNum = 300,
	},
})