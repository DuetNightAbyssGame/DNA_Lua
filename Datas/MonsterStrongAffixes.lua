-- Source Excel file path: ..\datas\Combat\Monster.xlsx
local T = {}
T.RT_1 = {
		7.2,
		11.9,
		7.2,
		1,
	}
T.RT_2 = {
		6.5,
		10.5,
		22.5,
		1,
	}
T.RT_3 = {
		13.8,
		4.3,
		22.6,
		1,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MonsterStrongAffixes", {
	["Mon.Strong.Blood"] = {
		AffixesBuffIds = {
			6000405,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Blood",
		Note = "猩红",
		Priority = 31,
	},
	["Mon.Strong.Blood.Double"] = {
		AffixesBuffIds = {
			6000505,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Blood.Double",
		Note = "猩红",
		Priority = 31,
	},
	["Mon.Strong.Blood.Triple"] = {
		AffixesBuffIds = {
			6000605,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Blood.Triple",
		Note = "猩红",
		Priority = 31,
	},
	["Mon.Strong.Burst"] = {
		AffixesBuffIds = {
			6000402,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Burst",
		Note = "爆破",
		Priority = 21,
	},
	["Mon.Strong.Burst.Double"] = {
		AffixesBuffIds = {
			6000502,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Burst.Double",
		Note = "爆破",
		Priority = 21,
	},
	["Mon.Strong.Burst.Triple"] = {
		AffixesBuffIds = {
			6000602,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Burst.Triple",
		Note = "爆破",
		Priority = 21,
	},
	["Mon.Strong.Fade"] = {
		AffixesBuffIds = {
			6000406,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Fade",
		Note = "枯萎",
		Priority = 32,
	},
	["Mon.Strong.Fade.Double"] = {
		AffixesBuffIds = {
			6000506,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Fade.Double",
		Note = "枯萎",
		Priority = 32,
	},
	["Mon.Strong.Fade.Triple"] = {
		AffixesBuffIds = {
			6000606,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Fade.Triple",
		Note = "枯萎",
		Priority = 32,
	},
	["Mon.Strong.Frozen"] = {
		AffixesBuffIds = {
			6000401,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Frozen",
		Note = "凛霜",
		Priority = 15,
	},
	["Mon.Strong.Frozen.Double"] = {
		AffixesBuffIds = {
			6000501,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Frozen.Double",
		Note = "凛霜",
		Priority = 15,
	},
	["Mon.Strong.Frozen.Triple"] = {
		AffixesBuffIds = {
			6000601,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Frozen.Triple",
		Note = "凛霜",
		Priority = 15,
	},
	["Mon.Strong.IceOrb"] = {
		AffixesBuffIds = {
			6000409,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.IceOrb",
		Note = "霜狱",
		Priority = 11,
	},
	["Mon.Strong.IceOrb.Double"] = {
		AffixesBuffIds = {
			6000509,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.IceOrb.Double",
		Note = "霜狱",
		Priority = 11,
	},
	["Mon.Strong.IceOrb.Triple"] = {
		AffixesBuffIds = {
			6000609,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.IceOrb.Triple",
		Note = "霜狱",
		Priority = 11,
	},
	["Mon.Strong.Kamikaze"] = {
		AffixesBuffIds = {
			6000411,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Kamikaze",
		Note = "舍身",
		Priority = 45,
	},
	["Mon.Strong.Kamikaze.Double"] = {
		AffixesBuffIds = {
			6000511,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Kamikaze.Double",
		Note = "舍身",
		Priority = 45,
	},
	["Mon.Strong.Kamikaze.Triple"] = {
		AffixesBuffIds = {
			6000611,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Kamikaze.Triple",
		Note = "舍身",
		Priority = 45,
	},
	["Mon.Strong.Poison"] = {
		AffixesBuffIds = {
			6000403,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Poison",
		Note = "侵蚀",
		Priority = 41,
	},
	["Mon.Strong.Poison.Double"] = {
		AffixesBuffIds = {
			6000503,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Poison.Double",
		Note = "侵蚀",
		Priority = 41,
	},
	["Mon.Strong.Poison.Triple"] = {
		AffixesBuffIds = {
			6000603,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Poison.Triple",
		Note = "侵蚀",
		Priority = 41,
	},
	["Mon.Strong.Reflect"] = {
		AffixesBuffIds = {
			6000410,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Reflect",
		Note = "残火",
		Priority = 25,
	},
	["Mon.Strong.Reflect.Double"] = {
		AffixesBuffIds = {
			6000510,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Reflect.Double",
		Note = "残火",
		Priority = 25,
	},
	["Mon.Strong.Reflect.Triple"] = {
		AffixesBuffIds = {
			6000610,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Reflect.Triple",
		Note = "残火",
		Priority = 25,
	},
	["Mon.Strong.Revenge"] = {
		AffixesBuffIds = {
			6000408,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Revenge",
		Note = "复仇",
		Priority = 35,
	},
	["Mon.Strong.Revenge.Double"] = {
		AffixesBuffIds = {
			6000508,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Revenge.Double",
		Note = "复仇",
		Priority = 35,
	},
	["Mon.Strong.Revenge.Triple"] = {
		AffixesBuffIds = {
			6000608,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Revenge.Triple",
		Note = "复仇",
		Priority = 35,
	},
	["Mon.Strong.Shield"] = {
		AffixesBuffIds = {
			6000407,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Shield",
		Note = "守护",
		Priority = 16,
	},
	["Mon.Strong.Shield.Double"] = {
		AffixesBuffIds = {
			6000507,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Shield.Double",
		Note = "守护",
		Priority = 16,
	},
	["Mon.Strong.Shield.Triple"] = {
		AffixesBuffIds = {
			6000607,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Shield.Triple",
		Note = "守护",
		Priority = 16,
	},
	["Mon.Strong.Threefold"] = {
		AffixesBuffIds = {
			6000414,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Threefold",
		Note = "掠影",
		Priority = 62,
	},
	["Mon.Strong.Threefold.Double"] = {
		AffixesBuffIds = {
			6000514,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Threefold.Double",
		Note = "掠影",
		Priority = 62,
	},
	["Mon.Strong.Threefold.Triple"] = {
		AffixesBuffIds = {
			6000614,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Threefold.Triple",
		Note = "掠影",
		Priority = 62,
	},
	["Mon.Strong.Thunder"] = {
		AffixesBuffIds = {
			6000404,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Thunder",
		Note = "霹雳",
		Priority = 52,
	},
	["Mon.Strong.Thunder.Double"] = {
		AffixesBuffIds = {
			6000504,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Thunder.Double",
		Note = "霹雳",
		Priority = 52,
	},
	["Mon.Strong.Thunder.Triple"] = {
		AffixesBuffIds = {
			6000604,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Thunder.Triple",
		Note = "霹雳",
		Priority = 52,
	},
	["Mon.Strong.ThunderLaser"] = {
		AffixesBuffIds = {
			6000412,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.ThunderLaser",
		Note = "转雷",
		Priority = 51,
	},
	["Mon.Strong.ThunderLaser.Double"] = {
		AffixesBuffIds = {
			6000512,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.ThunderLaser.Double",
		Note = "转雷",
		Priority = 51,
	},
	["Mon.Strong.ThunderLaser.Triple"] = {
		AffixesBuffIds = {
			6000612,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.ThunderLaser.Triple",
		Note = "转雷",
		Priority = 51,
	},
	["Mon.Strong.Vampire"] = {
		AffixesBuffIds = {
			6000413,
		},
		EffectColor = T.RT_1,
		GamePlayTag = "Mon.Strong.Vampire",
		Note = "浴血",
		Priority = 61,
	},
	["Mon.Strong.Vampire.Double"] = {
		AffixesBuffIds = {
			6000513,
		},
		EffectColor = T.RT_2,
		GamePlayTag = "Mon.Strong.Vampire.Double",
		Note = "浴血",
		Priority = 61,
	},
	["Mon.Strong.Vampire.Triple"] = {
		AffixesBuffIds = {
			6000613,
		},
		EffectColor = T.RT_3,
		GamePlayTag = "Mon.Strong.Vampire.Triple",
		Note = "浴血",
		Priority = 61,
	},
})