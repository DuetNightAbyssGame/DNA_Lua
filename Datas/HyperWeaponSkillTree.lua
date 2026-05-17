-- Source Excel file path: ..\datas\Weapon.xlsx
local T = {}
T.RT_1 = {
		[1] = 100,
	}
T.RT_2 = {
		[1] = 5,
	}
T.RT_3 = {
		Skill = 110101,
	}
T.RT_4 = {
		10101001,
	}
T.RT_5 = {
		20599001,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("HyperWeaponSkillTree", {
	[10101001] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		WeaponCardLevel = 0,
		WeaponId = 10101,
		WeaponSkill = T.RT_3,
		WeaponSkillId = 10101001,
	},
	[10101101] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = T.RT_4,
		WeaponCardLevel = 1,
		WeaponId = 10101,
		WeaponSkill = T.RT_3,
		WeaponSkillId = 10101101,
	},
	[10101102] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = T.RT_4,
		WeaponCardLevel = 1,
		WeaponId = 10101,
		WeaponSkill = {
			Attr = 150202,
		},
		WeaponSkillId = 10101102,
	},
	[20599001] = {
		WeaponCardLevel = 0,
		WeaponId = 20599,
		WeaponSkillId = 20599001,
	},
	[20599002] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = T.RT_5,
		WeaponCardLevel = 1,
		WeaponId = 20599,
		WeaponSkillId = 20599002,
	},
	[20599003] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = T.RT_5,
		WeaponCardLevel = 1,
		WeaponId = 20599,
		WeaponSkillId = 20599003,
	},
	[20599004] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = {
			20599002,
		},
		WeaponCardLevel = 2,
		WeaponId = 20599,
		WeaponSkillId = 20599004,
	},
	[20599005] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = {
			20599003,
		},
		WeaponCardLevel = 2,
		WeaponId = 20599,
		WeaponSkillId = 20599005,
	},
	[20599006] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = {
			20599004,
		},
		WeaponCardLevel = 3,
		WeaponId = 20599,
		WeaponSkillId = 20599006,
	},
	[20599007] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = {
			20599005,
		},
		WeaponCardLevel = 3,
		WeaponId = 20599,
		WeaponSkillId = 20599007,
	},
	[20599008] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = {
			20599006,
		},
		WeaponCardLevel = 4,
		WeaponId = 20599,
		WeaponSkillId = 20599008,
	},
	[20599009] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = {
			20599007,
		},
		WeaponCardLevel = 4,
		WeaponId = 20599,
		WeaponSkillId = 20599009,
	},
	[20599010] = {
		ResourceId = T.RT_1,
		ResourceNum = T.RT_2,
		UnlockCondition = {
			20599008,
			20599009,
		},
		WeaponCardLevel = 5,
		WeaponId = 20599,
		WeaponSkillId = 20599010,
	},
})