-- Source Excel file path: ..\datas\Combat\GlobalPassive.xlsx
local T = {}
T.RT_1 = {
		Count = "#1",
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GlobalPassiveData", {
	[1] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/BP_AbyssPassive_Test.BP_AbyssPassive_Test",
		Camp = "Monster",
		ID = 1,
		Vars = {
			GrowVar = "#1",
			TestVar = 30,
		},
	},
	[11112] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_PersonalRemoveBuff.BP_AbyssGP_PersonalRemoveBuff",
		Camp = "Player",
		ID = 11112,
		Vars = {
			Buff = 2011111,
		},
	},
	[11113] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HealAddBuff.BP_AbyssGP_HealAddBuff",
		Camp = "Player",
		ID = 11113,
		Vars = {
			Buff = 2011113,
			LastTime = 10,
		},
	},
	[11121] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HpCostAddBuff.BP_AbyssGP_HpCostAddBuff",
		Camp = "Player",
		ID = 11121,
		Vars = {
			Buff = 2011121,
			HpCost = 0.04,
			LastTime = 12,
		},
	},
	[11122] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Player",
		ID = 11122,
		Vars = {
			Buff = 2011122,
		},
	},
	[11211] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HpAboveBuff.BP_AbyssGP_HpAboveBuff",
		Camp = "Player",
		ID = 11211,
		Vars = {
			Buff = 2011211,
			HpRate = 0.8,
		},
	},
	[11212] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Player",
		ID = 11212,
		Vars = {
			Buff = 2011212,
		},
	},
	[11221] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_MeleeAddBuff.BP_AbyssGP_MeleeAddBuff",
		Camp = "Player",
		ID = 11221,
		Vars = {
			Buff = 2011221,
			LastTime = 10,
		},
	},
	[11222] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Player",
		ID = 11222,
		Vars = {
			Buff = 2011222,
		},
	},
	[12111] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillAddBuff.BP_AbyssGP_SkillAddBuff",
		Camp = "Player",
		ID = 12111,
		Vars = {
			Buff = 2012111,
			LastTime = 18,
		},
	},
	[12112] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Player",
		ID = 12112,
		Vars = {
			Buff = 2012112,
		},
	},
	[12121] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillAddBuff.BP_AbyssGP_SkillAddBuff",
		Camp = "Player",
		ID = 12121,
		Vars = {
			Buff = 2012121,
			LastTime = 15,
		},
	},
	[12211] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillExtraEffect.BP_AbyssGP_SkillExtraEffect",
		Camp = "Player",
		ID = 12211,
		Vars = {
			SkillEffect = 12211,
		},
	},
	[12221] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
		Camp = "Player",
		ID = 12221,
		Vars = {
			Buff = 2012221,
			HitCount = 5,
			LastTime = 15,
		},
	},
	[13111] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillAddBuff.BP_AbyssGP_SkillAddBuff",
		Camp = "Player",
		ID = 13111,
		Vars = {
			Buff = 2013111,
			LastTime = 12,
		},
	},
	[13112] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Player",
		ID = 13112,
		Vars = {
			Buff = 2013112,
		},
	},
	[13121] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_BuffInAir.BP_AbyssGP_BuffInAir",
		Camp = "Player",
		ID = 13121,
		Vars = {
			Buff = 2013121,
			LastTime = 1,
		},
	},
	[13122] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Player",
		ID = 13122,
		Vars = {
			Buff = 2013122,
		},
	},
	[13211] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SpAddBuff.BP_AbyssGP_SpAddBuff",
		Camp = "Player",
		ID = 13211,
		Vars = {
			Buff = 2013211,
			LastTime = 24,
			SpCost = 300,
		},
	},
	[13212] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Player",
		ID = 13212,
		Vars = {
			Buff = 2013212,
		},
	},
	[13221] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
		Camp = "Player",
		ID = 13221,
		Vars = {
			Buff = 2013221,
			HitCount = 3,
			LastTime = 20,
		},
	},
	[13222] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Player",
		ID = 13222,
		Vars = {
			Buff = 2013222,
		},
	},
	[20030] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
		Camp = "Player",
		ID = 20030,
		Vars = {
			Buff = 2010011,
			HitCount = 5,
			LastTime = 10,
		},
	},
	[20100] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_BossLockHp.BP_AbyssGP_BossLockHp",
		Camp = "Monster",
		GameplayTag = "Mon.Boss",
		ID = 20100,
		Vars = {
			LastTime = 30,
			LockHpBuff = 2010001,
			LockHpRate = 0.5,
		},
	},
	[20101] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_Weakness.BP_AbyssGP_Weakness",
		Camp = "Monster",
		ID = 20101,
	},
	[20102] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_EsAddDamage.BP_AbyssGP_EsAddDamage",
		Camp = "Monster",
		ID = 20102,
		Vars = {
			DamageRate = 0.2,
		},
	},
	[20201] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
		Camp = "Monster",
		ID = 20201,
		Vars = {
			Buff = 2010201,
		},
	},
	[20202] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
		Camp = "Monster",
		ID = 20202,
		Vars = {
			Buff = 2010202,
			Condition = "Crit",
		},
	},
	[20203] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
		Camp = "Monster",
		ID = 20203,
		Vars = {
			Buff = 2010203,
			Condition = "Tag",
			DamageTag = "Ranged",
		},
	},
	[20204] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
		Camp = "Monster",
		ID = 20204,
		Vars = {
			Buff = 2010204,
			Condition = "Tag",
			DamageTag = "Weapon",
		},
	},
	[20205] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
		Camp = "Monster",
		ID = 20205,
		Vars = {
			Buff = 2010205,
			Condition = "Tag",
			DamageTag = "Melee",
		},
	},
	[20206] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
		Camp = "Monster",
		ID = 20206,
		Vars = {
			Buff = 2010206,
			Condition = "Tag",
			DamageTag = "Dot",
		},
	},
	[20207] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
		Camp = "Monster",
		ID = 20207,
		Vars = {
			Buff = 2010207,
			Condition = "Tag",
			DamageTag = "Skill",
		},
	},
	[20301] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
		Camp = "Player",
		ID = 20301,
		Vars = {
			Buff = 2010301,
			HitCount = 5,
			LastTime = 15,
		},
	},
	[20302] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Player",
		ID = 20302,
		Vars = {
			Buff = 2010302,
		},
	},
	[20303] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_CritUpByBuff.BP_AbyssGP_CritUpByBuff",
		Camp = "Player",
		ID = 20303,
		Vars = {
			CritRate = 0.2,
		},
	},
	[20304] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SpAddBuff.BP_AbyssGP_SpAddBuff",
		ID = 20304,
		Vars = {
			Buff = 2010304,
			LastTime = 15,
			SpCost = 15,
		},
	},
	[20401] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
		Camp = "Monster",
		GameplayTag = "Mon.Elite",
		ID = 20401,
		Vars = {
			Buff = 2010101,
		},
	},
	[20511] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_DmgExchange.BP_AbyssGP_DmgExchange",
		Camp = "Player",
		ID = 20511,
		Vars = {
			DownRate = -0.5,
			DownTag = "Dot",
			UpRate = 0.5,
			UpTag = "Weapon",
		},
	},
	[20512] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillTrigger.BP_AbyssGP_SkillTrigger",
		Camp = "Player",
		ID = 20512,
		Vars = {
			Buff = 2010512,
			TriggerProb = 1,
		},
	},
	[22001] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_Wys_1.BP_EventGP_Wys_1",
		Camp = "Player",
		ID = 22001,
		Vars = {
			LastTime = 5,
		},
	},
	[22002] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_Wys_2.BP_EventGP_Wys_2",
		Camp = "Player",
		ID = 22002,
		Vars = {
			DamagePerLayer = 0.06,
		},
	},
	[22003] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_Wys_3.BP_EventGP_Wys_3",
		Camp = "Player",
		ID = 22003,
		Vars = {
			LastTime = 15,
		},
	},
	[22004] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_Wys_4.BP_EventGP_Wys_4",
		Camp = "Player",
		ID = 22004,
		Vars = {
			DamagePerLayer = 0.15,
			MaxLayer = 12,
		},
	},
	[30100] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_Common.BP_RaidGP_Common",
		Camp = "Monster",
		ID = 30100,
		Vars = {
			EliteRate = 0.27,
			NormalRate = 0.033,
		},
	},
	[30101] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_010.BP_RaidGP_010",
		Camp = "Player",
		ID = 30101,
		Vars = {
			Divider = 0.3,
			MaxSkillInten = 4,
			Penetration = 0.05,
		},
	},
	[30102] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_012.BP_RaidGP_012",
		Camp = "Player",
		ID = 30102,
		Vars = {
			Divider = 0.3,
			MaxSkillInten = 4.6,
			Penetration = 0.035,
		},
	},
	[30103] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_013.BP_RaidGP_013",
		Camp = "Player",
		ID = 30103,
		Vars = {
			Divider1 = 0.1,
			Divider2 = 0.2,
			MaxRange = 0.6,
			MaxSustain = 1,
			Penetration1 = 0.07,
			Penetration2 = 0.1,
		},
	},
	[30101001] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30101001.BP_Rou_Contract_30101001",
		Camp = "Player",
		ID = 30101001,
		Vars = {
			HealRate = "#1",
		},
	},
	[30101002] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30101002.BP_Rou_Contract_30101002",
		Camp = "Player",
		ID = 30101002,
	},
	[30102001] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30102001.BP_Rou_Contract_30102001",
		Camp = "Monster",
		ID = 30102001,
	},
	[30102002] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30102002.BP_Rou_Contract_30102002",
		Camp = "Monster",
		ID = 30102002,
	},
	[30102003] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30102003.BP_Rou_Contract_30102003",
		Camp = "Monster",
		ID = 30102003,
		Vars = {
			DamagedRate = "#1",
		},
	},
	[30102004] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30102004.BP_Rou_Contract_30102004",
		Camp = "Monster",
		ID = 30102004,
	},
	[30103001] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30103001.BP_Rou_Contract_30103001",
		Camp = "Player",
		ID = 30103001,
		Vars = T.RT_1,
	},
	[30103002] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30103002.BP_Rou_Contract_30103002",
		Camp = "Player",
		ID = 30103002,
		Vars = T.RT_1,
	},
	[30103003] = {
		BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30103003.BP_Rou_Contract_30103003",
		Camp = "Player",
		ID = 30103003,
		Vars = T.RT_1,
	},
})