-- Source Excel file path: ['..\\datas\\Combat\\SKill\\Skill_Char.xlsx', '..\\datas\\Combat\\SKill\\Skill_Monster.xlsx', '..\\datas\\Combat\\SKill\\Skill_Rouge.xlsx']
local T = {}
T.RT_1 = {
		4,
	}
T.RT_2 = {
		0,
		1,
		2,
		3,
		4,
		5,
		6,
	}
T.RT_3 = {
		1,
	}
T.RT_4 = {
		PassiveEffects = T.RT_1,
		SkillGrade = T.RT_2,
		SkillId = 10,
		SkillLevel = T.RT_3,
		SkillType = "Movement",
	}
T.RT_5 = {
		100001,
	}
T.RT_6 = {
		[1] = "Skill_DESC_AtkUp",
	}
T.RT_7 = {
		[1] = "$#Buff[100002].AddAttrs[1].Rate*100$%",
	}
T.RT_8 = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
		17,
		18,
		19,
		20,
	}
T.RT_9 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_5,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_100001_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_7,
		SkillGrade = T.RT_2,
		SkillId = 100001,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_100001_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_10 = {
		[0] = T.RT_9,
		[1] = T.RT_9,
		[2] = T.RT_9,
		[3] = T.RT_9,
		[4] = T.RT_9,
		[5] = T.RT_9,
		[6] = T.RT_9,
	}
T.RT_11 = {
		100003,
	}
T.RT_12 = {
		[1] = "SKILL_DESC_DmgUpSkill",
	}
T.RT_13 = {
		[1] = "$#Buff[100004].AddAttrs[1].Value*100$%",
	}
T.RT_14 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_11,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_100003_DESC",
		SkillDescKeys = T.RT_12,
		SkillDescValues = T.RT_13,
		SkillGrade = T.RT_2,
		SkillId = 100003,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_100003_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_15 = {
		[0] = T.RT_14,
		[1] = T.RT_14,
		[2] = T.RT_14,
		[3] = T.RT_14,
		[4] = T.RT_14,
		[5] = T.RT_14,
		[6] = T.RT_14,
	}
T.RT_16 = {
		100005,
	}
T.RT_17 = {
		[1] = "SKILL_DESC_DmgUpWeapon",
	}
T.RT_18 = {
		[1] = "$#Buff[100006].AddAttrs[1].Value*100$%",
	}
T.RT_19 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_16,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_100005_DESC",
		SkillDescKeys = T.RT_17,
		SkillDescValues = T.RT_18,
		SkillGrade = T.RT_2,
		SkillId = 100005,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_100005_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_20 = {
		[0] = T.RT_19,
		[1] = T.RT_19,
		[2] = T.RT_19,
		[3] = T.RT_19,
		[4] = T.RT_19,
		[5] = T.RT_19,
		[6] = T.RT_19,
	}
T.RT_21 = {
		100007,
	}
T.RT_22 = {
		[1] = "SKILL_DESC_DefUp",
	}
T.RT_23 = {
		[1] = "$#Buff[100008].AddAttrs[1].Rate*100$%",
	}
T.RT_24 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_21,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_100007_DESC",
		SkillDescKeys = T.RT_22,
		SkillDescValues = T.RT_23,
		SkillGrade = T.RT_2,
		SkillId = 100007,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_100007_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_25 = {
		[0] = T.RT_24,
		[1] = T.RT_24,
		[2] = T.RT_24,
		[3] = T.RT_24,
		[4] = T.RT_24,
		[5] = T.RT_24,
		[6] = T.RT_24,
	}
T.RT_26 = {
		100009,
	}
T.RT_27 = {
		[1] = "SKILL_DESC_CriUp",
	}
T.RT_28 = {
		[1] = "$#Buff[100010].AddAttrs[1].Value*100$%",
	}
T.RT_29 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_26,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_100009_DESC",
		SkillDescKeys = T.RT_27,
		SkillDescValues = T.RT_28,
		SkillGrade = T.RT_2,
		SkillId = 100009,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_100009_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_30 = {
		[0] = T.RT_29,
		[1] = T.RT_29,
		[2] = T.RT_29,
		[3] = T.RT_29,
		[4] = T.RT_29,
		[5] = T.RT_29,
		[6] = T.RT_29,
	}
T.RT_31 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 10011,
		CD = 3,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhujue01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 10001,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_32 = {
		[0] = T.RT_31,
		[1] = T.RT_31,
		[2] = T.RT_31,
		[3] = T.RT_31,
		[4] = T.RT_31,
		[5] = T.RT_31,
		[6] = T.RT_31,
	}
T.RT_33 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 10021,
		CD = 3,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Zhujue02",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 10002,
		SkillLevel = T.RT_8,
		SkillType = "Skill2",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_34 = {
		[0] = T.RT_33,
		[1] = T.RT_33,
		[2] = T.RT_33,
		[3] = T.RT_33,
		[4] = T.RT_33,
		[5] = T.RT_33,
		[6] = T.RT_33,
	}
T.RT_35 = {
		10001,
		10002,
	}
T.RT_36 = {
		PassiveEffects = T.RT_35,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillGrade = T.RT_2,
		SkillId = 10003,
		SkillLevel = T.RT_8,
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_37 = {
		[0] = T.RT_36,
		[1] = T.RT_36,
		[2] = T.RT_36,
		[3] = T.RT_36,
		[4] = T.RT_36,
		[5] = T.RT_36,
		[6] = T.RT_36,
	}
T.RT_38 = {
		BeginNodeId = 10041,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhujue01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 10004,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_39 = {
		[0] = T.RT_38,
		[1] = T.RT_38,
		[2] = T.RT_38,
		[3] = T.RT_38,
		[4] = T.RT_38,
		[5] = T.RT_38,
		[6] = T.RT_38,
	}
T.RT_40 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 10051,
		CD = 3,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Zhujue02",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 10005,
		SkillLevel = T.RT_8,
		SkillType = "Skill2",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_41 = {
		[0] = T.RT_40,
		[1] = T.RT_40,
		[2] = T.RT_40,
		[3] = T.RT_40,
		[4] = T.RT_40,
		[5] = T.RT_40,
		[6] = T.RT_40,
	}
T.RT_42 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 10061,
		CD = 3,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhujue01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 10006,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_43 = {
		[0] = T.RT_42,
		[1] = T.RT_42,
		[2] = T.RT_42,
		[3] = T.RT_42,
		[4] = T.RT_42,
		[5] = T.RT_42,
		[6] = T.RT_42,
	}
T.RT_44 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 10071,
		CD = 3,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Zhujue02",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 10007,
		SkillLevel = T.RT_8,
		SkillType = "Skill2",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_45 = {
		[0] = T.RT_44,
		[1] = T.RT_44,
		[2] = T.RT_44,
		[3] = T.RT_44,
		[4] = T.RT_44,
		[5] = T.RT_44,
		[6] = T.RT_44,
	}
T.RT_46 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 10081,
		CD = 3,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhujue01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 10008,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_47 = {
		[0] = T.RT_46,
		[1] = T.RT_46,
		[2] = T.RT_46,
		[3] = T.RT_46,
		[4] = T.RT_46,
		[5] = T.RT_46,
		[6] = T.RT_46,
	}
T.RT_48 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 10091,
		CD = 3,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Zhujue02",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 10009,
		SkillLevel = T.RT_8,
		SkillType = "Skill2",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_49 = {
		[0] = T.RT_48,
		[1] = T.RT_48,
		[2] = T.RT_48,
		[3] = T.RT_48,
		[4] = T.RT_48,
		[5] = T.RT_48,
		[6] = T.RT_48,
	}
T.RT_50 = {
		"Normal",
	}
T.RT_51 = {
		103,
	}
T.RT_52 = {
		[1] = "SKILL_DESC_ComboDamage1",
		[2] = "SKILL_DESC_ComboDamage2",
		[3] = "SKILL_DESC_ComboDamage3",
		[4] = "SKILL_DESC_ComboDamage4",
	}
T.RT_53 = {
		[1] = "$#SkillEffects[1010111].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1010112].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[1010113].TaskEffects[1].Rate*100$%×2",
		[4] = "$#SkillEffects[1010114].TaskEffects[1].Rate*100$%",
	}
T.RT_54 = {
		1019801,
	}
T.RT_55 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1010111,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_52,
		SkillDescValues = T.RT_53,
		SkillGrade = T.RT_2,
		SkillId = 1010101,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		SubSkills = T.RT_54,
		bEnablePrediction = true,
	}
T.RT_56 = {
		"Normal",
		"HeavyAttack",
	}
T.RT_57 = {
		102,
	}
T.RT_58 = {
		[1] = "SKILL_DESC_HeavyAttackDemage",
	}
T.RT_59 = {
		[1] = "$#SkillEffects[1010121].TaskEffects[1].Rate*100$%",
	}
T.RT_60 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1010121,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_58,
		SkillDescValues = T.RT_59,
		SkillGrade = T.RT_2,
		SkillId = 1010102,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_61 = {
		"Normal",
		"FallAttack",
	}
T.RT_62 = {
		[1] = "SKILL_DESC_FallAttackDemage",
	}
T.RT_63 = {
		[1] = "$#SkillEffects[1010132].TaskEffects[1].Rate*100$%",
	}
T.RT_64 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1010131,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillDescKeys = T.RT_62,
		SkillDescValues = T.RT_63,
		SkillGrade = T.RT_2,
		SkillId = 1010103,
		SkillLevel = T.RT_3,
		SkillType = "FallAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_65 = {
		"Normal",
		"SlideAttack",
	}
T.RT_66 = {
		[1] = "SKILL_DESC_SlideAttackDemage",
	}
T.RT_67 = {
		[1] = "$#SkillEffects[1010141].TaskEffects[1].Rate*100$%",
	}
T.RT_68 = {
		AttackSpeedType = T.RT_65,
		BeginNodeId = 1010141,
		SkillDescKeys = T.RT_66,
		SkillDescValues = T.RT_67,
		SkillGrade = T.RT_2,
		SkillId = 1010104,
		SkillLevel = T.RT_3,
		SkillType = "SlideAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_69 = {
		[1] = "$#SkillEffects[1010211].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1010212].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[1010213].TaskEffects[1].Rate*100$%×4",
		[4] = "$#SkillEffects[1010214].TaskEffects[1].Rate*100$%",
	}
T.RT_70 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1010211,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_52,
		SkillDescValues = T.RT_69,
		SkillGrade = T.RT_2,
		SkillId = 1010201,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_71 = {
		[1] = "$#SkillEffects[1010221].TaskEffects[1].Rate*100$%",
	}
T.RT_72 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1010221,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_58,
		SkillDescValues = T.RT_71,
		SkillGrade = T.RT_2,
		SkillId = 1010202,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_73 = {
		[1] = "$#SkillEffects[1010322].TaskEffects[1].Rate*100$%×2",
	}
T.RT_74 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1010321,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_58,
		SkillDescValues = T.RT_73,
		SkillGrade = T.RT_2,
		SkillId = 1010302,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_75 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1010211,
		SkillGrade = T.RT_2,
		SkillId = 1019801,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_76 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1010111,
		SkillGrade = T.RT_2,
		SkillId = 1019901,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_77 = {
		[1] = "SKILL_DESC_ComboDamage1",
		[2] = "SKILL_DESC_ComboDamage2",
		[3] = "SKILL_DESC_ComboDamage3",
		[4] = "SKILL_DESC_ComboDamage4",
		[5] = "SKILL_DESC_ComboDamage5",
	}
T.RT_78 = {
		[1] = "$#SkillEffects[1020111].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1020112].TaskEffects[1].Rate*100$%×3",
		[3] = "$#SkillEffects[1020113].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[1020114].TaskEffects[1].Rate*100$%",
		[5] = "$#SkillEffects[1020115].TaskEffects[1].Rate*100$%",
	}
T.RT_79 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1020111,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_77,
		SkillDescValues = T.RT_78,
		SkillGrade = T.RT_2,
		SkillId = 1020101,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_80 = {
		[1] = "$#SkillEffects[1020122].TaskEffects[1].Rate*100$%",
	}
T.RT_81 = {
		1020105,
		1020106,
	}
T.RT_82 = {
		AllowEightOrient = "OptionalLockOrient",
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1020121,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_58,
		SkillDescValues = T.RT_80,
		SkillGrade = T.RT_2,
		SkillId = 1020102,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		SubSkills = T.RT_81,
		bEnablePrediction = true,
	}
T.RT_83 = {
		[1] = "$#SkillEffects[1020132].TaskEffects[1].Rate*100$%",
	}
T.RT_84 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1020131,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillDescKeys = T.RT_62,
		SkillDescValues = T.RT_83,
		SkillGrade = T.RT_2,
		SkillId = 1020103,
		SkillLevel = T.RT_3,
		SkillType = "FallAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_85 = {
		[1] = "$#SkillEffects[1020141].TaskEffects[1].Rate*100$%",
	}
T.RT_86 = {
		AttackSpeedType = T.RT_65,
		BeginNodeId = 1020141,
		SkillDescKeys = T.RT_66,
		SkillDescValues = T.RT_85,
		SkillGrade = T.RT_2,
		SkillId = 1020104,
		SkillLevel = T.RT_3,
		SkillType = "SlideAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_87 = {
		FuncName = "ExecuteHeavyAttack",
		Id = 10200,
	}
T.RT_88 = {
		10200,
	}
T.RT_89 = {
		AllowUseSkillInAir = true,
		ExecutePassiveFunc = T.RT_87,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_88,
		SkillGrade = T.RT_2,
		SkillId = 1020105,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_90 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1020161,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 1020106,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_91 = {
		[1] = "$#SkillEffects[1020211].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1020212].TaskEffects[1].Rate*100$%×2",
		[3] = "$#SkillEffects[1020213].TaskEffects[1].Rate*100$%×2+$#SkillEffects[1020214].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[1020215].TaskEffects[1].Rate*100$%+$#SkillEffects[1020216].TaskEffects[1].Rate*100$%",
	}
T.RT_92 = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
	}
T.RT_93 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1020211,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_52,
		SkillDescValues = T.RT_91,
		SkillGrade = T.RT_2,
		SkillId = 1020201,
		SkillLevel = T.RT_92,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_94 = {
		[0] = T.RT_93,
		[1] = T.RT_93,
		[2] = T.RT_93,
		[3] = T.RT_93,
		[4] = T.RT_93,
		[5] = T.RT_93,
		[6] = T.RT_93,
	}
T.RT_95 = {
		[1] = "$#SkillEffects[1020222].TaskEffects[1].Rate*100$%",
	}
T.RT_96 = {
		AllowEightOrient = "OptionalLockOrient",
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1020221,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_58,
		SkillDescValues = T.RT_95,
		SkillGrade = T.RT_2,
		SkillId = 1020202,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_97 = {
		[1] = "SKILL_DESC_FallAttackDemage",
		[2] = "SKILL_DESC_FallAttackDemage2",
	}
T.RT_98 = {
		[1] = "$#SkillEffects[1020232].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1020233].TaskEffects[1].Rate*100$%",
	}
T.RT_99 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1020231,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillDescKeys = T.RT_97,
		SkillDescValues = T.RT_98,
		SkillGrade = T.RT_2,
		SkillId = 1020203,
		SkillLevel = T.RT_3,
		SkillType = "FallAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_100 = {
		102,
		1020302,
	}
T.RT_101 = {
		[1] = "$#SkillEffects[1020323].TaskEffects[1].Rate*100$%",
	}
T.RT_102 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1020321,
		PassiveEffects = T.RT_100,
		SkillDescKeys = T.RT_58,
		SkillDescValues = T.RT_101,
		SkillGrade = T.RT_2,
		SkillId = 1020302,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_103 = {
		[1] = "$#SkillEffects[1030111].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1030112].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[1030113].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[1030114].TaskEffects[1].Rate*100$%",
	}
T.RT_104 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1030111,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_52,
		SkillDescValues = T.RT_103,
		SkillGrade = T.RT_2,
		SkillId = 1030101,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_105 = {
		[1] = "SKILL_DESC_HeavyAttackDemage",
		[2] = "SKILL_DESC_HeavyAttackDemage2",
	}
T.RT_106 = {
		[1] = "$#SkillEffects[1030121].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1030122].TaskEffects[1].Rate*100$%",
	}
T.RT_107 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1030121,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_105,
		SkillDescValues = T.RT_106,
		SkillGrade = T.RT_2,
		SkillId = 1030102,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_108 = {
		[1] = "$#SkillEffects[1030132].TaskEffects[1].Rate*100$%",
	}
T.RT_109 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1030131,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillDescKeys = T.RT_62,
		SkillDescValues = T.RT_108,
		SkillGrade = T.RT_2,
		SkillId = 1030103,
		SkillLevel = T.RT_3,
		SkillType = "FallAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_110 = {
		[1] = "$#SkillEffects[1030141].TaskEffects[1].Rate*100$%",
	}
T.RT_111 = {
		AttackSpeedType = T.RT_65,
		BeginNodeId = 1030141,
		SkillDescKeys = T.RT_66,
		SkillDescValues = T.RT_110,
		SkillGrade = T.RT_2,
		SkillId = 1030104,
		SkillLevel = T.RT_3,
		SkillType = "SlideAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_112 = {
		[1] = "SKILL_DESC_ComboDamage1",
		[2] = "SKILL_DESC_ComboDamage2",
		[3] = "SKILL_DESC_ComboDamage3",
		[4] = "SKILL_DESC_PathDamage",
	}
T.RT_113 = {
		[1] = "$#SkillEffects[1030211].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1030212].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[1030214].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[1030218].TaskEffects[1].Rate*100$%",
	}
T.RT_114 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1030211,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_112,
		SkillDescValues = T.RT_113,
		SkillGrade = T.RT_2,
		SkillId = 1030201,
		SkillLevel = T.RT_92,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_115 = {
		[0] = T.RT_114,
		[1] = T.RT_114,
		[2] = T.RT_114,
		[3] = T.RT_114,
		[4] = T.RT_114,
		[5] = T.RT_114,
		[6] = T.RT_114,
	}
T.RT_116 = {
		102,
		1030202,
	}
T.RT_117 = {
		[1] = "SKILL_DESC_PathDamage",
		[2] = "SKILL_DESC_HeavyAttackDemage2",
		[3] = "SKILL_DESC_GoalDamage",
	}
T.RT_118 = {
		[1] = "$#SkillEffects[1030225].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1030224].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[1030226].TaskEffects[1].Rate*100$%",
	}
T.RT_119 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1030221,
		ClientSkillLogicId = 1030202,
		PassiveEffects = T.RT_116,
		SkillDescKeys = T.RT_117,
		SkillDescValues = T.RT_118,
		SkillGrade = T.RT_2,
		SkillId = 1030202,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_120 = {
		[1] = "$#SkillEffects[1030311].TaskEffects[1].Rate*100$%×3",
		[2] = "$#SkillEffects[1030312].TaskEffects[1].Rate*100$%×3",
		[3] = "$#SkillEffects[1030313].TaskEffects[1].Rate*100$%×5",
		[4] = "$#SkillEffects[1030314].TaskEffects[1].Rate*100$%",
	}
T.RT_121 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1030311,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_52,
		SkillDescValues = T.RT_120,
		SkillGrade = T.RT_2,
		SkillId = 1030301,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_122 = {
		[1] = "$#SkillEffects[1040111].TaskEffects[1].Rate*100$%×2",
		[2] = "$#SkillEffects[1040112].TaskEffects[1].Rate*100$%×2",
		[3] = "$#SkillEffects[1040113].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[1040114].TaskEffects[1].Rate*100$%×3",
	}
T.RT_123 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1040111,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_52,
		SkillDescValues = T.RT_122,
		SkillGrade = T.RT_2,
		SkillId = 1040101,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_124 = {
		[1] = "$#SkillEffects[1040121].TaskEffects[1].Rate*100$%×6",
		[2] = "$#SkillEffects[1040122].TaskEffects[1].Rate*100$%",
	}
T.RT_125 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1040121,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_105,
		SkillDescValues = T.RT_124,
		SkillGrade = T.RT_2,
		SkillId = 1040102,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_126 = {
		[1] = "$#SkillEffects[1040132].TaskEffects[1].Rate*100$%",
	}
T.RT_127 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1040131,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillDescKeys = T.RT_62,
		SkillDescValues = T.RT_126,
		SkillGrade = T.RT_2,
		SkillId = 1040103,
		SkillLevel = T.RT_3,
		SkillType = "FallAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_128 = {
		[1] = "$#SkillEffects[1040141].TaskEffects[1].Rate*100$%×2",
	}
T.RT_129 = {
		AttackSpeedType = T.RT_65,
		BeginNodeId = 1040141,
		SkillDescKeys = T.RT_66,
		SkillDescValues = T.RT_128,
		SkillGrade = T.RT_2,
		SkillId = 1040104,
		SkillLevel = T.RT_3,
		SkillType = "SlideAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_130 = {
		[1] = "$#SkillEffects[1040211].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1040212].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[1040213].TaskEffects[1].Rate*100$%×4",
		[4] = "$#SkillEffects[1040214].TaskEffects[1].Rate*100$%×5",
	}
T.RT_131 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1040211,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_52,
		SkillDescValues = T.RT_130,
		SkillGrade = T.RT_2,
		SkillId = 1040201,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_132 = {
		[1] = "$#SkillEffects[1040222].TaskEffects[1].Rate*100$%",
	}
T.RT_133 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1040221,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_58,
		SkillDescValues = T.RT_132,
		SkillGrade = T.RT_2,
		SkillId = 1040202,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_134 = {
		[1] = "$#SkillEffects[1040242].TaskEffects[1].Rate*100$%",
	}
T.RT_135 = {
		AttackSpeedType = T.RT_65,
		BeginNodeId = 1040241,
		SkillDescKeys = T.RT_66,
		SkillDescValues = T.RT_134,
		SkillGrade = T.RT_2,
		SkillId = 1040204,
		SkillLevel = T.RT_92,
		SkillType = "SlideAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_136 = {
		[0] = T.RT_135,
		[1] = T.RT_135,
		[2] = T.RT_135,
		[3] = T.RT_135,
		[4] = T.RT_135,
		[5] = T.RT_135,
		[6] = T.RT_135,
	}
T.RT_137 = {
		[1] = "$#SkillEffects[1050111].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[1050112].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[1050113].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[1050114].TaskEffects[1].Rate*100$%×2",
	}
T.RT_138 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1050111,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_52,
		SkillDescValues = T.RT_137,
		SkillGrade = T.RT_2,
		SkillId = 1050101,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_139 = {
		102,
		1050102,
	}
T.RT_140 = {
		[1] = "$#SkillEffects[1050122].TaskEffects[1].Rate*100$%",
	}
T.RT_141 = {
		1019901,
		1010102,
	}
T.RT_142 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1050121,
		PassiveEffects = T.RT_139,
		SkillDescKeys = T.RT_58,
		SkillDescValues = T.RT_140,
		SkillGrade = T.RT_2,
		SkillId = 1050102,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		SubSkills = T.RT_141,
		bEnablePrediction = true,
	}
T.RT_143 = {
		[1] = "$#SkillEffects[1050132].TaskEffects[1].Rate*100$%",
	}
T.RT_144 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1050131,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillDescKeys = T.RT_62,
		SkillDescValues = T.RT_143,
		SkillGrade = T.RT_2,
		SkillId = 1050103,
		SkillLevel = T.RT_3,
		SkillType = "FallAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_145 = {
		[1] = "$#SkillEffects[1050141].TaskEffects[1].Rate*100$%",
	}
T.RT_146 = {
		AttackSpeedType = T.RT_65,
		BeginNodeId = 1050141,
		SkillDescKeys = T.RT_66,
		SkillDescValues = T.RT_145,
		SkillGrade = T.RT_2,
		SkillId = 1050104,
		SkillLevel = T.RT_3,
		SkillType = "SlideAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_147 = {
		[1] = "$#SkillEffects[1060111].TaskEffects[1].Rate*100$%×3",
		[2] = "$#SkillEffects[1060112].TaskEffects[1].Rate*100$%×4",
		[3] = "$#SkillEffects[1060113].TaskEffects[1].Rate*100$%×2+$#SkillEffects[1060115].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[1060114].TaskEffects[1].Rate*100$%",
	}
T.RT_148 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1060111,
		PassiveEffects = T.RT_51,
		SkillDescKeys = T.RT_52,
		SkillDescValues = T.RT_147,
		SkillGrade = T.RT_2,
		SkillId = 1060101,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_149 = {
		[1] = "$#SkillEffects[1060121].TaskEffects[1].Rate*100$%×9",
	}
T.RT_150 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1060121,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_58,
		SkillDescValues = T.RT_149,
		SkillGrade = T.RT_2,
		SkillId = 1060102,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_151 = {
		[1] = "$#SkillEffects[1060132].TaskEffects[1].Rate*100$%",
	}
T.RT_152 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1060131,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillDescKeys = T.RT_62,
		SkillDescValues = T.RT_151,
		SkillGrade = T.RT_2,
		SkillId = 1060103,
		SkillLevel = T.RT_3,
		SkillType = "FallAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_153 = {
		[1] = "$#SkillEffects[1060141].TaskEffects[1].Rate*100$%",
	}
T.RT_154 = {
		AttackSpeedType = T.RT_65,
		BeginNodeId = 1060141,
		SkillDescKeys = T.RT_66,
		SkillDescValues = T.RT_153,
		SkillGrade = T.RT_2,
		SkillId = 1060104,
		SkillLevel = T.RT_3,
		SkillType = "SlideAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_155 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1060211,
		PassiveEffects = T.RT_51,
		SkillGrade = T.RT_2,
		SkillId = 1060201,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_156 = {
		[1] = "SKILL_DESC_HeavyAttackDemage3",
		[2] = "SKILL_DESC_HeavyAttackDemage",
		[3] = "SKILL_DESC_HeavyAttackDemage2",
	}
T.RT_157 = {
		[1] = "$#SkillEffects[1060251].TaskEffects[1].Rate*100$%×3",
		[2] = "$#SkillEffects[1060221].TaskEffects[1].Rate*100$%×8",
		[3] = "$#SkillEffects[1060229].TaskEffects[1].Rate*100$%",
	}
T.RT_158 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1060221,
		PassiveEffects = T.RT_57,
		SkillDescKeys = T.RT_156,
		SkillDescValues = T.RT_157,
		SkillGrade = T.RT_2,
		SkillId = 1060202,
		SkillLevel = T.RT_3,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_159 = {
		110001,
	}
T.RT_160 = {
		[1] = "$#Buff[110002].AddAttrs[1].Rate*100$%",
	}
T.RT_161 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_159,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_110001_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_160,
		SkillGrade = T.RT_2,
		SkillId = 110001,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110001_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_162 = {
		[0] = T.RT_161,
		[1] = T.RT_161,
		[2] = T.RT_161,
		[3] = T.RT_161,
		[4] = T.RT_161,
		[5] = T.RT_161,
		[6] = T.RT_161,
	}
T.RT_163 = {
		110003,
	}
T.RT_164 = {
		[1] = "$#Buff[110004].AddAttrs[1].Rate*100$%",
	}
T.RT_165 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_163,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_110003_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_164,
		SkillGrade = T.RT_2,
		SkillId = 110003,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110003_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_166 = {
		[0] = T.RT_165,
		[1] = T.RT_165,
		[2] = T.RT_165,
		[3] = T.RT_165,
		[4] = T.RT_165,
		[5] = T.RT_165,
		[6] = T.RT_165,
	}
T.RT_167 = {
		"SkillEfficiency",
	}
T.RT_168 = {
		"SkillIntensity",
	}
T.RT_169 = {
		"SkillRange",
	}
T.RT_170 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
	}
T.RT_171 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_DamageRadius",
	}
T.RT_172 = {
		[1] = "$#SkillNode[110111].CostSp$",
		[2] = "$#SkillEffects[110114].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[110111].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_173 = {
		110111,
	}
T.RT_174 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110111,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Heitao01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Heitao_Skill01",
		SkillDesc = "SKILL_110101_DESC",
		SkillDescHints = T.RT_170,
		SkillDescKeys = T.RT_171,
		SkillDescValues = T.RT_172,
		SkillGrade = T.RT_2,
		SkillId = 110101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_173,
		bEnablePrediction = true,
	}
T.RT_175 = {
		[0] = T.RT_174,
		[1] = T.RT_174,
		[2] = T.RT_174,
		[3] = T.RT_174,
		[4] = T.RT_174,
		[5] = T.RT_174,
		[6] = T.RT_174,
	}
T.RT_176 = {
		"SkillEfficiency",
		"SkillSustain",
	}
T.RT_177 = {
		[1] = T.RT_167,
		[2] = T.RT_176,
		[3] = T.RT_168,
		[4] = T.RT_168,
		[5] = T.RT_168,
		[6] = T.RT_168,
		[7] = T.RT_168,
		[8] = T.RT_169,
		[11] = T.RT_168,
		[12] = T.RT_168,
		[13] = T.RT_168,
		[14] = T.RT_168,
		[15] = T.RT_168,
		[16] = T.RT_168,
		[17] = T.RT_169,
	}
T.RT_178 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SpChangeScd",
		[3] = "SKILL_DESC_ComboDamage1",
		[4] = "SKILL_DESC_ComboDamage2",
		[5] = "SKILL_DESC_ComboDamage3",
		[6] = "SKILL_DESC_ComboDamage4",
		[7] = "SKILL_DESC_ComboDamage5",
		[8] = "SKILL_DESC_ComboDamageRadius",
		[9] = "SKILL_DESC_HeavyAttackDemage",
		[10] = "SKILL_DESC_SlideAttackDemage",
		[11] = "SKILL_DESC_1101WaveDamage1",
		[12] = "SKILL_DESC_1101WaveDamage2",
		[13] = "SKILL_DESC_1101WaveDamage3",
		[14] = "SKILL_DESC_1101WaveDamage4",
		[15] = "SKILL_DESC_1101WaveDamage5",
		[16] = "SKILL_DESC_1101WaveDamageOn",
		[17] = "SKILL_DESC_1101WaveWidth",
	}
T.RT_179 = {
		[1] = "$#SkillNode[110121].CostSp$",
		[2] = "$math.abs(#Buff[110101].DotDatas[1].Value)$",
		[3] = "$#SkillEffects[110141].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[110142].TaskEffects[1].Rate*100$%",
		[5] = "$#SkillEffects[110143].TaskEffects[1].Rate*100$%",
		[6] = "$#SkillEffects[110144].TaskEffects[1].Rate*100$%",
		[7] = "$#SkillEffects[110145].TaskEffects[1].Rate*100$%",
		[8] = "$#TargetFilter[#SkillEffects[110141].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[9] = "$#SkillEffects[1010121].TaskEffects[1].Rate*100$%",
		[10] = "$#SkillEffects[1010141].TaskEffects[1].Rate*100$%",
		[11] = "$#SkillEffects[110151].TaskEffects[1].Rate*100$%",
		[12] = "$#SkillEffects[110152].TaskEffects[1].Rate*100$%",
		[13] = "$#SkillEffects[110153].TaskEffects[1].Rate*100$%",
		[14] = "$#SkillEffects[110154].TaskEffects[1].Rate*100$%",
		[15] = "$#SkillEffects[110155].TaskEffects[1].Rate*100$%",
		[16] = "$#SkillEffects[110151].TaskEffects[1].Rate*100$%",
		[17] = "$#SkillCreature[110141].ShapeInfo.BoxLength*2/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_180 = {
		110121,
	}
T.RT_181 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110121,
		CD = 2.7,
		CDType = 110102,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Heitao02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Heitao_Skill02",
		SkillDesc = "SKILL_110102_DESC",
		SkillDescHints = T.RT_177,
		SkillDescKeys = T.RT_178,
		SkillDescValues = T.RT_179,
		SkillGrade = T.RT_2,
		SkillId = 110102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_180,
		bEnablePrediction = true,
	}
T.RT_182 = {
		[0] = T.RT_181,
		[1] = T.RT_181,
		[2] = T.RT_181,
		[3] = T.RT_181,
		[4] = T.RT_181,
		[5] = T.RT_181,
		[6] = T.RT_181,
	}
T.RT_183 = {
		110101,
	}
T.RT_184 = {
		[1] = "SKILL_DESC_SpIncrease",
		[2] = "SKILL_DESC_TriggerProb",
	}
T.RT_185 = {
		[1] = "$#PassiveEffect[110101].Vars.SpIncrease$",
		[2] = "$#PassiveEffect[110101].Vars.SpIncreaseProb*100$%",
	}
T.RT_186 = {
		PassiveEffects = T.RT_183,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Heitao03",
		SkillDesc = "SKILL_110103_DESC",
		SkillDescKeys = T.RT_184,
		SkillDescValues = T.RT_185,
		SkillGrade = T.RT_2,
		SkillId = 110103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_187 = {
		[0] = T.RT_186,
		[1] = T.RT_186,
		[2] = T.RT_186,
		[3] = T.RT_186,
		[4] = T.RT_186,
		[5] = T.RT_186,
		[6] = T.RT_186,
	}
T.RT_188 = {
		110102,
	}
T.RT_189 = {
		PassiveEffects = T.RT_188,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_110104_DESC",
		SkillGrade = T.RT_2,
		SkillId = 110104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_190 = {
		[0] = T.RT_189,
		[1] = T.RT_189,
		[2] = T.RT_189,
		[3] = T.RT_189,
		[4] = T.RT_189,
		[5] = T.RT_189,
		[6] = T.RT_189,
	}
T.RT_191 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110119,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Heitao01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Heitao_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 110111,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_192 = {
		[0] = T.RT_191,
		[1] = T.RT_191,
		[2] = T.RT_191,
		[3] = T.RT_191,
		[4] = T.RT_191,
		[5] = T.RT_191,
		[6] = T.RT_191,
	}
T.RT_193 = {
		"NotRealSkill2",
	}
T.RT_194 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 110131,
		CD = 2.7,
		CDType = 110102,
		CombatConditionID = 110101,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Heitao02_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Heitao_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 110121,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_195 = {
		[0] = T.RT_194,
		[1] = T.RT_194,
		[2] = T.RT_194,
		[3] = T.RT_194,
		[4] = T.RT_194,
		[5] = T.RT_194,
		[6] = T.RT_194,
	}
T.RT_196 = {
		0,
		1,
		2,
		3,
		4,
		5,
	}
T.RT_197 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 110141,
		CancelBlockMove = 1,
		PassiveEffects = T.RT_51,
		SkillGrade = T.RT_196,
		SkillId = 110122,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_198 = {
		6,
	}
T.RT_199 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 110151,
		CancelBlockMove = 1,
		PassiveEffects = T.RT_51,
		SkillGrade = T.RT_198,
		SkillId = 110122,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_200 = {
		[0] = T.RT_197,
		[1] = T.RT_197,
		[2] = T.RT_197,
		[3] = T.RT_197,
		[4] = T.RT_197,
		[5] = T.RT_197,
		[6] = T.RT_199,
	}
T.RT_201 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1010121,
		PassiveEffects = T.RT_57,
		SkillGrade = T.RT_2,
		SkillId = 110123,
		SkillLevel = T.RT_8,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_202 = {
		[0] = T.RT_201,
		[1] = T.RT_201,
		[2] = T.RT_201,
		[3] = T.RT_201,
		[4] = T.RT_201,
		[5] = T.RT_201,
		[6] = T.RT_201,
	}
T.RT_203 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1010141,
		SkillGrade = T.RT_2,
		SkillId = 110124,
		SkillLevel = T.RT_8,
		SkillType = "SlideAttack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_204 = {
		[0] = T.RT_203,
		[1] = T.RT_203,
		[2] = T.RT_203,
		[3] = T.RT_203,
		[4] = T.RT_203,
		[5] = T.RT_203,
		[6] = T.RT_203,
	}
T.RT_205 = {
		110211,
	}
T.RT_206 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110211,
		LongPressSkill = 110211,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Heitao01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 110201,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Melee",
		SubSkills = T.RT_205,
		bEnablePrediction = true,
	}
T.RT_207 = {
		[0] = T.RT_206,
		[1] = T.RT_206,
		[2] = T.RT_206,
		[3] = T.RT_206,
		[4] = T.RT_206,
		[5] = T.RT_206,
		[6] = T.RT_206,
	}
T.RT_208 = {
		110221,
	}
T.RT_209 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110221,
		CD = 3,
		CDType = 110202,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Heitao02_On",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 110202,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_208,
		bEnablePrediction = true,
	}
T.RT_210 = {
		[0] = T.RT_209,
		[1] = T.RT_209,
		[2] = T.RT_209,
		[3] = T.RT_209,
		[4] = T.RT_209,
		[5] = T.RT_209,
		[6] = T.RT_209,
	}
T.RT_211 = {
		110201,
	}
T.RT_212 = {
		PassiveEffects = T.RT_211,
		SkillGrade = T.RT_2,
		SkillId = 110203,
		SkillLevel = T.RT_8,
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_213 = {
		[0] = T.RT_212,
		[1] = T.RT_212,
		[2] = T.RT_212,
		[3] = T.RT_212,
		[4] = T.RT_212,
		[5] = T.RT_212,
		[6] = T.RT_212,
	}
T.RT_214 = {
		110202,
	}
T.RT_215 = {
		PassiveEffects = T.RT_214,
		SkillGrade = T.RT_2,
		SkillId = 110204,
		SkillLevel = T.RT_8,
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_216 = {
		[0] = T.RT_215,
		[1] = T.RT_215,
		[2] = T.RT_215,
		[3] = T.RT_215,
		[4] = T.RT_215,
		[5] = T.RT_215,
		[6] = T.RT_215,
	}
T.RT_217 = {
		AllowSkillIntensity = true,
		AttackSpeedType = T.RT_56,
		BeginNodeId = 110251,
		PassiveEffects = T.RT_57,
		SkillGrade = T.RT_2,
		SkillId = 110205,
		SkillLevel = T.RT_8,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_218 = {
		[0] = T.RT_217,
		[1] = T.RT_217,
		[2] = T.RT_217,
		[3] = T.RT_217,
		[4] = T.RT_217,
		[5] = T.RT_217,
		[6] = T.RT_217,
	}
T.RT_219 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110212,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Heitao01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 110211,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Melee",
		bEnablePrediction = true,
	}
T.RT_220 = {
		[0] = T.RT_219,
		[1] = T.RT_219,
		[2] = T.RT_219,
		[3] = T.RT_219,
		[4] = T.RT_219,
		[5] = T.RT_219,
		[6] = T.RT_219,
	}
T.RT_221 = {
		110222,
	}
T.RT_222 = {
		AllowUseSkillInAir = true,
		CD = 3,
		CDType = 110202,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Heitao02_Off",
		SkillBtnStyle = "Switch",
		SkillEffectsList = T.RT_221,
		SkillGrade = T.RT_2,
		SkillId = 110221,
		SkillLevel = T.RT_8,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_223 = {
		[0] = T.RT_222,
		[1] = T.RT_222,
		[2] = T.RT_222,
		[3] = T.RT_222,
		[4] = T.RT_222,
		[5] = T.RT_222,
		[6] = T.RT_222,
	}
T.RT_224 = {
		"Term_1103_Skill01",
	}
T.RT_225 = {
		1,
		2,
		3,
		4,
	}
T.RT_226 = {
		SKILL_SECTIONDESC_1103_Skill01_01 = T.RT_225,
	}
T.RT_227 = {
		5,
		6,
		7,
		8,
	}
T.RT_228 = {
		SKILL_SECTIONDESC_1103_Skill01_02 = T.RT_227,
	}
T.RT_229 = {
		[1] = T.RT_226,
		[2] = T.RT_228,
	}
T.RT_230 = {
		"SkillSustain",
	}
T.RT_231 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_230,
		[5] = T.RT_167,
		[6] = T.RT_168,
		[8] = T.RT_230,
	}
T.RT_232 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_DamageRadius",
		[4] = "SKILL_DESC_1103MarkSustain",
		[5] = "SKILL_DESC_1103Skill01SpCost",
		[6] = "SKILL_DESC_1103Skill01Damage",
		[7] = "SKILL_DESC_1103Skill01SkillRange",
		[8] = "SKILL_DESC_1103Skill01Sustain",
	}
T.RT_233 = {
		[1] = "$#SkillNode[110311].CostSp$",
		[2] = "$#SkillEffects[110311].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[110311].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[110311].TaskEffects[4].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[5] = "$#SkillNode[110312].CostSp$",
		[6] = "$#SkillEffects[110314].TaskEffects[1].Rate*100$%",
		[7] = "$#Buff[110311].AddAttrs[1].Rate*100$%",
		[8] = "$#SkillEffects[110312].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_234 = {
		110311,
	}
T.RT_235 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110311,
		ExplanationId = T.RT_224,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Tuosi01_1",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Tuosi_Skill01",
		SkillDesc = "SKILL_110301_DESC",
		SkillDescGroups = T.RT_229,
		SkillDescHints = T.RT_231,
		SkillDescKeys = T.RT_232,
		SkillDescValues = T.RT_233,
		SkillGrade = T.RT_2,
		SkillId = 110301,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110301_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_234,
		bEnablePrediction = true,
	}
T.RT_236 = {
		[0] = T.RT_235,
		[1] = T.RT_235,
		[2] = T.RT_235,
		[3] = T.RT_235,
		[4] = T.RT_235,
		[5] = T.RT_235,
		[6] = T.RT_235,
	}
T.RT_237 = {
		"Term_1103_Combo",
		"Term_1103_Finish",
	}
T.RT_238 = {
		[1] = T.RT_167,
		[2] = T.RT_176,
		[3] = T.RT_168,
		[4] = T.RT_168,
		[5] = T.RT_168,
		[6] = T.RT_168,
		[7] = T.RT_168,
		[8] = T.RT_169,
		[9] = T.RT_168,
		[10] = T.RT_169,
		[12] = T.RT_168,
	}
T.RT_239 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SpChangeScd",
		[3] = "SKILL_DESC_1103ComboDamage1",
		[4] = "SKILL_DESC_1103ComboDamage2",
		[5] = "SKILL_DESC_1103ComboDamage3",
		[6] = "SKILL_DESC_1103ComboDamage4",
		[7] = "SKILL_DESC_1103FallAttackDamage",
		[8] = "SKILL_DESC_1103DamageRadius",
		[9] = "SKILL_DESC_1103RayDamage",
		[10] = "SKILL_DESC_1103RayLength",
		[11] = "SKILL_DESC_1103Restore",
		[12] = "SKILL_DESC_1103MarkRate",
		[13] = "SKILL_DESC_1103MarkRestore1",
		[14] = "SKILL_DESC_1103MarkRestore2",
	}
T.RT_240 = {
		[1] = "$#SkillNode[110321].CostSp$",
		[2] = "$math.abs(#Buff[110302].DotDatas[1].Value)$",
		[3] = "$#SkillEffects[110331].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[110332].TaskEffects[1].Rate*100$%",
		[5] = "$#SkillEffects[110333].TaskEffects[1].Rate*100$%",
		[6] = "$#SkillEffects[110334].TaskEffects[1].Rate*100$%",
		[7] = "$#SkillEffects[110342].TaskEffects[1].Rate*100$%",
		[8] = "$#TargetFilter[#SkillEffects[110342].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[9] = "$#SkillEffects[110355].TaskEffects[1].Rate*100$%",
		[10] = "$#RayCreature[110301].RayLength/100$$GText(\"SKILL_DESC_Meter\")$",
		[11] = "$#PassiveEffect[110301].Vars.MspOnHit*100$%$GText(\"SKILL_DESC_MaxSp\")$",
		[12] = "$#PassiveEffect[110301].Vars.MarkDamageRate*100$%",
		[13] = "$#PassiveEffect[110301].Vars.MarkAddSp$",
		[14] = "$#PassiveEffect[110301].Vars.MarkAddMsp*100$%$GText(\"SKILL_DESC_MaxSp\")$",
	}
T.RT_241 = {
		110321,
	}
T.RT_242 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110321,
		CD = 3,
		CDType = 110302,
		ExplanationId = T.RT_237,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Tuosi02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Tuosi_Skill02",
		SkillDesc = "SKILL_110302_DESC",
		SkillDescHints = T.RT_238,
		SkillDescKeys = T.RT_239,
		SkillDescValues = T.RT_240,
		SkillGrade = T.RT_2,
		SkillId = 110302,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110302_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_241,
	}
T.RT_243 = {
		[0] = T.RT_242,
		[1] = T.RT_242,
		[2] = T.RT_242,
		[3] = T.RT_242,
		[4] = T.RT_242,
		[5] = T.RT_242,
		[6] = T.RT_242,
	}
T.RT_244 = {
		"Term_1103_HyperForm",
	}
T.RT_245 = {
		110301,
	}
T.RT_246 = {
		1,
		2,
		3,
		4,
		5,
	}
T.RT_247 = {
		SKILL_SECTIONDESC_1103_Skill03_01 = T.RT_246,
	}
T.RT_248 = {
		6,
		7,
		8,
		9,
	}
T.RT_249 = {
		SKILL_SECTIONDESC_1103_Skill03_02 = T.RT_248,
	}
T.RT_250 = {
		[1] = T.RT_247,
		[2] = T.RT_249,
	}
T.RT_251 = {
		[1] = "SKILL_DESC_1103SpToAtk",
		[2] = "SKILL_DESC_1103MaxAtk",
		[3] = "SKILL_DESC_1103Skill01Msp1",
		[4] = "SKILL_DESC_1103Skill01Msp2",
		[5] = "SKILL_DESC_1103Skill02Msp",
		[6] = "SKILL_DESC_1103ExSpToAtk",
		[7] = "SKILL_DESC_1103LimitOff",
		[8] = "SKILL_DESC_1103SspCost",
		[9] = "SKILL_DESC_SkillSpeedUp",
	}
T.RT_252 = {
		[1] = "$#Buff[110303].AddAttrs[1].Rate*100$%$GText(\"SKILL_DESC_MaxSp\")$",
		[2] = "$#Buff[110303].AddAttrs[1].SupLimitValue$",
		[3] = "$#PassiveEffect[110301].Vars.Skill1Msp1$",
		[4] = "$#PassiveEffect[110301].Vars.Skill1Msp2$",
		[5] = "$#PassiveEffect[110301].Vars.Skill2Msp$",
		[6] = "$#Buff[110331].AddAttrs[1].Rate*100$%$GText(\"SKILL_DESC_MaxSp\")$",
		[7] = "$#Buff[110331].AddAttrs[1].SupLimitValue$",
		[8] = "$#PassiveEffect[110301].Vars.Skill2SpCost$",
		[9] = "$#Buff[110331].AddAttrs[2].Rate*100$%",
	}
T.RT_253 = {
		ExplanationId = T.RT_244,
		PassiveEffects = T.RT_245,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Tuosi03",
		SkillDesc = "SKILL_110303_DESC",
		SkillDescGroups = T.RT_250,
		SkillDescKeys = T.RT_251,
		SkillDescValues = T.RT_252,
		SkillGrade = T.RT_2,
		SkillId = 110303,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110303_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_254 = {
		[0] = T.RT_253,
		[1] = T.RT_253,
		[2] = T.RT_253,
		[3] = T.RT_253,
		[4] = T.RT_253,
		[5] = T.RT_253,
		[6] = T.RT_253,
	}
T.RT_255 = {
		110302,
	}
T.RT_256 = {
		[1] = "SKILL_DESC_TriggerProb",
	}
T.RT_257 = {
		[1] = "$#PassiveEffect[110302].Vars.TriggerProb*100$%",
	}
T.RT_258 = {
		PassiveEffects = T.RT_255,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_110304_DESC",
		SkillDescKeys = T.RT_256,
		SkillDescValues = T.RT_257,
		SkillGrade = T.RT_2,
		SkillId = 110304,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_110304_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_259 = {
		[0] = T.RT_258,
		[1] = T.RT_258,
		[2] = T.RT_258,
		[3] = T.RT_258,
		[4] = T.RT_258,
		[5] = T.RT_258,
		[6] = T.RT_258,
	}
T.RT_260 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110312,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Tuosi01_2",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Tuosi_Skill01",
		SkillGrade = T.RT_196,
		SkillId = 110311,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_261 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110313,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Tuosi01_2",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Tuosi_Skill01",
		SkillGrade = T.RT_198,
		SkillId = 110311,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_262 = {
		[0] = T.RT_260,
		[1] = T.RT_260,
		[2] = T.RT_260,
		[3] = T.RT_260,
		[4] = T.RT_260,
		[5] = T.RT_260,
		[6] = T.RT_261,
	}
T.RT_263 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110322,
		CD = 3,
		CDType = 110302,
		CombatConditionID = 110301,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Tuosi02_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Tuosi_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 110321,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
	}
T.RT_264 = {
		[0] = T.RT_263,
		[1] = T.RT_263,
		[2] = T.RT_263,
		[3] = T.RT_263,
		[4] = T.RT_263,
		[5] = T.RT_263,
		[6] = T.RT_263,
	}
T.RT_265 = {
		AllowSkillIntensity = true,
		BeginNodeId = 110331,
		SkillGrade = T.RT_2,
		SkillId = 110323,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_266 = {
		[0] = T.RT_265,
		[1] = T.RT_265,
		[2] = T.RT_265,
		[3] = T.RT_265,
		[4] = T.RT_265,
		[5] = T.RT_265,
		[6] = T.RT_265,
	}
T.RT_267 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110341,
		SkillGrade = T.RT_2,
		SkillId = 110324,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "FallAttack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_268 = {
		[0] = T.RT_267,
		[1] = T.RT_267,
		[2] = T.RT_267,
		[3] = T.RT_267,
		[4] = T.RT_267,
		[5] = T.RT_267,
		[6] = T.RT_267,
	}
T.RT_269 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110351,
		SkillGrade = T.RT_2,
		SkillId = 110325,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Shooting",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_270 = {
		[0] = T.RT_269,
		[1] = T.RT_269,
		[2] = T.RT_269,
		[3] = T.RT_269,
		[4] = T.RT_269,
		[5] = T.RT_269,
		[6] = T.RT_269,
	}
T.RT_271 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110391,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Tuosi01_2",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Tuosi_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 110391,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_272 = {
		[0] = T.RT_271,
		[1] = T.RT_271,
		[2] = T.RT_271,
		[3] = T.RT_271,
		[4] = T.RT_271,
		[5] = T.RT_271,
		[6] = T.RT_271,
	}
T.RT_273 = {
		110323,
	}
T.RT_274 = {
		AllowSkillIntensity = true,
		BeginNodeId = 110392,
		SkillGrade = T.RT_2,
		SkillId = 110392,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_273,
		bEnablePrediction = true,
	}
T.RT_275 = {
		[0] = T.RT_274,
		[1] = T.RT_274,
		[2] = T.RT_274,
		[3] = T.RT_274,
		[4] = T.RT_274,
		[5] = T.RT_274,
		[6] = T.RT_274,
	}
T.RT_276 = {
		110324,
	}
T.RT_277 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110397,
		SkillGrade = T.RT_2,
		SkillId = 110393,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "FallAttack",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_276,
		bEnablePrediction = true,
	}
T.RT_278 = {
		[0] = T.RT_277,
		[1] = T.RT_277,
		[2] = T.RT_277,
		[3] = T.RT_277,
		[4] = T.RT_277,
		[5] = T.RT_277,
		[6] = T.RT_277,
	}
T.RT_279 = {
		FuncName = "ExecuteSkillBlade",
		Id = 110401,
	}
T.RT_280 = {
		110411,
		110421,
		110431,
		110441,
		110451,
	}
T.RT_281 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		ExecutePassiveFunc = T.RT_279,
		IgnoreTag = true,
		LongPressSkill = 110411,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Heitao01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 110401,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		SubSkills = T.RT_280,
		bEnablePrediction = true,
	}
T.RT_282 = {
		[0] = T.RT_281,
		[1] = T.RT_281,
		[2] = T.RT_281,
		[3] = T.RT_281,
		[4] = T.RT_281,
		[5] = T.RT_281,
		[6] = T.RT_281,
	}
T.RT_283 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 110421,
		CD = 2.5,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Heitao02_On",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 110402,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_284 = {
		[0] = T.RT_283,
		[1] = T.RT_283,
		[2] = T.RT_283,
		[3] = T.RT_283,
		[4] = T.RT_283,
		[5] = T.RT_283,
		[6] = T.RT_283,
	}
T.RT_285 = {
		110401,
	}
T.RT_286 = {
		PassiveEffects = T.RT_285,
		SkillGrade = T.RT_2,
		SkillId = 110403,
		SkillLevel = T.RT_8,
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_287 = {
		[0] = T.RT_286,
		[1] = T.RT_286,
		[2] = T.RT_286,
		[3] = T.RT_286,
		[4] = T.RT_286,
		[5] = T.RT_286,
		[6] = T.RT_286,
	}
T.RT_288 = {
		110402,
	}
T.RT_289 = {
		PassiveEffects = T.RT_288,
		SkillGrade = T.RT_2,
		SkillId = 110404,
		SkillLevel = T.RT_8,
		SkillType = "ExtraPassive",
		bEnablePrediction = true,
	}
T.RT_290 = {
		[0] = T.RT_289,
		[1] = T.RT_289,
		[2] = T.RT_289,
		[3] = T.RT_289,
		[4] = T.RT_289,
		[5] = T.RT_289,
		[6] = T.RT_289,
	}
T.RT_291 = {
		110414,
	}
T.RT_292 = {
		AllowEightOrient = "OnlyLockOrient",
		IgnoreTag = true,
		NotExecute = true,
		SkillEffectsList = T.RT_291,
		SkillGrade = T.RT_2,
		SkillId = 110411,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_293 = {
		[0] = T.RT_292,
		[1] = T.RT_292,
		[2] = T.RT_292,
		[3] = T.RT_292,
		[4] = T.RT_292,
		[5] = T.RT_292,
		[6] = T.RT_292,
	}
T.RT_294 = {
		FuncName = "ExecuteSkillHammer",
		Id = 110401,
	}
T.RT_295 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		ExecutePassiveFunc = T.RT_294,
		IgnoreTag = true,
		LongPressSkill = 110431,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Tuosi01_1",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 110421,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_296 = {
		[0] = T.RT_295,
		[1] = T.RT_295,
		[2] = T.RT_295,
		[3] = T.RT_295,
		[4] = T.RT_295,
		[5] = T.RT_295,
		[6] = T.RT_295,
	}
T.RT_297 = {
		110433,
	}
T.RT_298 = {
		AllowEightOrient = "OnlyLockOrient",
		IgnoreTag = true,
		NotExecute = true,
		SkillEffectsList = T.RT_297,
		SkillGrade = T.RT_2,
		SkillId = 110431,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_299 = {
		[0] = T.RT_298,
		[1] = T.RT_298,
		[2] = T.RT_298,
		[3] = T.RT_298,
		[4] = T.RT_298,
		[5] = T.RT_298,
		[6] = T.RT_298,
	}
T.RT_300 = {
		FuncName = "ExecuteSkillGravity",
		Id = 110401,
	}
T.RT_301 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		ExecutePassiveFunc = T.RT_300,
		IgnoreTag = true,
		LongPressSkill = 110451,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Baonu01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 110441,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_302 = {
		[0] = T.RT_301,
		[1] = T.RT_301,
		[2] = T.RT_301,
		[3] = T.RT_301,
		[4] = T.RT_301,
		[5] = T.RT_301,
		[6] = T.RT_301,
	}
T.RT_303 = {
		110443,
	}
T.RT_304 = {
		AllowEightOrient = "OnlyLockOrient",
		IgnoreTag = true,
		NotExecute = true,
		SkillEffectsList = T.RT_303,
		SkillGrade = T.RT_2,
		SkillId = 110451,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_305 = {
		[0] = T.RT_304,
		[1] = T.RT_304,
		[2] = T.RT_304,
		[3] = T.RT_304,
		[4] = T.RT_304,
		[5] = T.RT_304,
		[6] = T.RT_304,
	}
T.RT_306 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 120111,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhujue01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 120101,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_307 = {
		[0] = T.RT_306,
		[1] = T.RT_306,
		[2] = T.RT_306,
		[3] = T.RT_306,
		[4] = T.RT_306,
		[5] = T.RT_306,
		[6] = T.RT_306,
	}
T.RT_308 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 120121,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhujue01",
		SkillBtnStyle = "Common_Btn",
		SkillFailToast = "SKILL_TOAST_CommonFail",
		SkillGrade = T.RT_2,
		SkillId = 120102,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		UseSkillCondition = 120111,
		bEnablePrediction = true,
	}
T.RT_309 = {
		[0] = T.RT_308,
		[1] = T.RT_308,
		[2] = T.RT_308,
		[3] = T.RT_308,
		[4] = T.RT_308,
		[5] = T.RT_308,
		[6] = T.RT_308,
	}
T.RT_310 = {
		120101,
	}
T.RT_311 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_310,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillGrade = T.RT_2,
		SkillId = 120103,
		SkillLevel = T.RT_8,
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_312 = {
		[0] = T.RT_311,
		[1] = T.RT_311,
		[2] = T.RT_311,
		[3] = T.RT_311,
		[4] = T.RT_311,
		[5] = T.RT_311,
		[6] = T.RT_311,
	}
T.RT_313 = {
		120102,
	}
T.RT_314 = {
		PassiveEffects = T.RT_313,
		SkillGrade = T.RT_2,
		SkillId = 120104,
		SkillLevel = T.RT_8,
		SkillType = "ExtraPassive",
		bEnablePrediction = true,
	}
T.RT_315 = {
		[0] = T.RT_314,
		[1] = T.RT_314,
		[2] = T.RT_314,
		[3] = T.RT_314,
		[4] = T.RT_314,
		[5] = T.RT_314,
		[6] = T.RT_314,
	}
T.RT_316 = {
		120211,
	}
T.RT_317 = {
		AllowSkillIntensity = true,
		BeginNodeId = 120211,
		CD = 2,
		CDType = 120201,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Heitao02_On",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 120201,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_316,
		bEnablePrediction = true,
	}
T.RT_318 = {
		[0] = T.RT_317,
		[1] = T.RT_317,
		[2] = T.RT_317,
		[3] = T.RT_317,
		[4] = T.RT_317,
		[5] = T.RT_317,
		[6] = T.RT_317,
	}
T.RT_319 = {
		120221,
	}
T.RT_320 = {
		BeginNodeId = 120221,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Heitao02_On",
		SkillGrade = T.RT_2,
		SkillId = 120202,
		SkillLevel = T.RT_8,
		SkillType = "Skill2",
		SubSkills = T.RT_319,
		bEnablePrediction = true,
	}
T.RT_321 = {
		[0] = T.RT_320,
		[1] = T.RT_320,
		[2] = T.RT_320,
		[3] = T.RT_320,
		[4] = T.RT_320,
		[5] = T.RT_320,
		[6] = T.RT_320,
	}
T.RT_322 = {
		120201,
	}
T.RT_323 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_322,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillGrade = T.RT_2,
		SkillId = 120203,
		SkillLevel = T.RT_8,
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_324 = {
		[0] = T.RT_323,
		[1] = T.RT_323,
		[2] = T.RT_323,
		[3] = T.RT_323,
		[4] = T.RT_323,
		[5] = T.RT_323,
		[6] = T.RT_323,
	}
T.RT_325 = {
		120203,
	}
T.RT_326 = {
		PassiveEffects = T.RT_325,
		SkillGrade = T.RT_2,
		SkillId = 120204,
		SkillLevel = T.RT_8,
		SkillType = "ExtraPassive",
		bEnablePrediction = true,
	}
T.RT_327 = {
		[0] = T.RT_326,
		[1] = T.RT_326,
		[2] = T.RT_326,
		[3] = T.RT_326,
		[4] = T.RT_326,
		[5] = T.RT_326,
		[6] = T.RT_326,
	}
T.RT_328 = {
		"NotRealSkill1",
	}
T.RT_329 = {
		BeginNodeId = 120212,
		CD = 2,
		CDType = 120201,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Heitao02_Off",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 120211,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_328,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_330 = {
		[0] = T.RT_329,
		[1] = T.RT_329,
		[2] = T.RT_329,
		[3] = T.RT_329,
		[4] = T.RT_329,
		[5] = T.RT_329,
		[6] = T.RT_329,
	}
T.RT_331 = {
		BeginNodeId = 120222,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Heitao02_On",
		SkillGrade = T.RT_2,
		SkillId = 120221,
		SkillLevel = T.RT_8,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_332 = {
		[0] = T.RT_331,
		[1] = T.RT_331,
		[2] = T.RT_331,
		[3] = T.RT_331,
		[4] = T.RT_331,
		[5] = T.RT_331,
		[6] = T.RT_331,
	}
T.RT_333 = {
		150001,
	}
T.RT_334 = {
		[1] = "$#Buff[150002].AddAttrs[1].Rate*100$%",
	}
T.RT_335 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_333,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_150001_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_334,
		SkillGrade = T.RT_2,
		SkillId = 150001,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150001_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_336 = {
		[0] = T.RT_335,
		[1] = T.RT_335,
		[2] = T.RT_335,
		[3] = T.RT_335,
		[4] = T.RT_335,
		[5] = T.RT_335,
		[6] = T.RT_335,
	}
T.RT_337 = {
		150003,
	}
T.RT_338 = {
		[1] = "$#Buff[150004].AddAttrs[1].Rate*100$%",
	}
T.RT_339 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_337,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_150003_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_338,
		SkillGrade = T.RT_2,
		SkillId = 150003,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150003_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_340 = {
		[0] = T.RT_339,
		[1] = T.RT_339,
		[2] = T.RT_339,
		[3] = T.RT_339,
		[4] = T.RT_339,
		[5] = T.RT_339,
		[6] = T.RT_339,
	}
T.RT_341 = {
		[1] = "$#SkillNode[150111].CostSp$",
		[2] = "$#SkillEffects[150111].TaskEffects[1].Rate*100$%×3+$#SkillEffects[150112].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[150112].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_342 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150111,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Baonu01",
		SkillDemo = "Baonu_Skill01",
		SkillDesc = "SKILL_150101_DESC",
		SkillDescHints = T.RT_170,
		SkillDescKeys = T.RT_171,
		SkillDescValues = T.RT_341,
		SkillGrade = T.RT_2,
		SkillId = 150101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_343 = {
		[0] = T.RT_342,
		[1] = T.RT_342,
		[2] = T.RT_342,
		[3] = T.RT_342,
		[4] = T.RT_342,
		[5] = T.RT_342,
		[6] = T.RT_342,
	}
T.RT_344 = {
		"Term_1501_Buff01",
	}
T.RT_345 = {
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
	}
T.RT_346 = {
		UI_WEAPON_NAME_150101 = T.RT_345,
	}
T.RT_347 = {
		[1] = T.RT_346,
	}
T.RT_348 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_168,
		[4] = T.RT_168,
		[5] = T.RT_168,
		[9] = T.RT_168,
		[10] = T.RT_168,
		[12] = T.RT_167,
		[13] = T.RT_167,
		[16] = T.RT_168,
		[17] = T.RT_169,
	}
T.RT_349 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_ComboDamage1",
		[3] = "SKILL_DESC_ComboDamage2",
		[4] = "SKILL_DESC_ComboDamage3",
		[5] = "SKILL_DESC_ComboDamage4",
		[6] = "SKILL_DESC_ComboDamageRadius",
		[7] = "SKILL_DESC_FallAttackDemage",
		[8] = "SKILL_DESC_SlideAttackDemage",
		[9] = "SKILL_DESC_HeavyAttackDemage",
		[10] = "SKILL_DESC_1501FullHeavyAttackDmg",
		[11] = "SKILL_DESC_HeavyAttackRange",
		[12] = "SKILL_DESC_1501HeavyAttackSp",
		[13] = "SKILL_DESC_1501HeavyAttackLoopSp",
		[14] = "SKILL_DESC_1501HeavyAttackCombo",
		[15] = "SKILL_DESC_1501DmgdDown",
		[16] = "SKILL_DESC_SkillExecuteDamage",
		[17] = "SKILL_DESC_SkillExecuteDamageRadius",
	}
T.RT_350 = {
		[1] = "$#SkillNode[150121].CostSp$",
		[2] = "$#SkillEffects[150131].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[150132].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[150133].TaskEffects[1].Rate*100$%×2",
		[5] = "$#SkillEffects[150134].TaskEffects[1].Rate*100$%+$#SkillEffects[150135].TaskEffects[1].Rate*100$%",
		[6] = "$#TargetFilter[#SkillEffects[150131].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[7] = "$#SkillEffects[1030132].TaskEffects[1].Rate*100$%",
		[8] = "$#SkillEffects[1030141].TaskEffects[1].Rate*100$%",
		[9] = "$#SkillEffects[150141].TaskEffects[1].Rate*100$%",
		[10] = "$#SkillEffects[150145].TaskEffects[1].Rate*100$%+$#SkillEffects[150141].TaskEffects[1].Rate*100$%",
		[11] = "$#TargetFilter[#SkillEffects[150141].TargetFilter].LuaFilterParaments.Length/100$$GText(\"SKILL_DESC_Meter\")$×$#TargetFilter[#SkillEffects[150141].TargetFilter].LuaFilterParaments.HalfWidth/50$$GText(\"SKILL_DESC_Meter\")$",
		[12] = "$#SkillNode[150141].CostSp$",
		[13] = "$#PassiveEffect[150101].Vars.HeavyAtkSp$",
		[14] = "$#PassiveEffect[150101].Vars.HeavyAtkCombo$",
		[15] = "$#Buff[150103].BuffDamagedRate.Value*(-100)$%",
		[16] = "$#SkillEffects[150123].TaskEffects[1].Rate*100$%",
		[17] = "$#TargetFilter[#SkillEffects[150123].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_351 = {
		150121,
	}
T.RT_352 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150121,
		CD = 2.5,
		CDType = 150102,
		ExplanationId = T.RT_344,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Baonu02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Baonu_Skill02",
		SkillDesc = "SKILL_150102_DESC",
		SkillDescGroups = T.RT_347,
		SkillDescHints = T.RT_348,
		SkillDescKeys = T.RT_349,
		SkillDescValues = T.RT_350,
		SkillGrade = T.RT_2,
		SkillId = 150102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_351,
		bEnablePrediction = true,
	}
T.RT_353 = {
		[0] = T.RT_352,
		[1] = T.RT_352,
		[2] = T.RT_352,
		[3] = T.RT_352,
		[4] = T.RT_352,
		[5] = T.RT_352,
		[6] = T.RT_352,
	}
T.RT_354 = {
		150101,
	}
T.RT_355 = {
		[1] = T.RT_168,
		[2] = T.RT_169,
		[5] = T.RT_230,
	}
T.RT_356 = {
		[1] = "SKILL_DESC_Damage",
		[2] = "SKILL_DESC_DamageRadius",
		[3] = "SKILL_DESC_AtkRangeUp",
		[4] = "SKILL_DESC_TriggerProbUp",
		[5] = "SKILL_DESC_1501PassiveTime",
	}
T.RT_357 = {
		[1] = "$#SkillEffects[150151].TaskEffects[1].Rate*100$%",
		[2] = "$#TargetFilter[#SkillEffects[150151].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[3] = "$#Buff[150101].AddAttrs[1].Value/100$$GText(\"SKILL_DESC_1501PassiveLevel\")$",
		[4] = "$#Buff[150101].AddAttrs[2].Value*100$%$GText(\"SKILL_DESC_1501PassiveLevel\")$",
		[5] = "$#PassiveEffect[150101].Vars.PassiveLastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_358 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_354,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Baonu03",
		SkillDesc = "SKILL_150103_DESC",
		SkillDescHints = T.RT_355,
		SkillDescKeys = T.RT_356,
		SkillDescValues = T.RT_357,
		SkillGrade = T.RT_2,
		SkillId = 150103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_359 = {
		[0] = T.RT_358,
		[1] = T.RT_358,
		[2] = T.RT_358,
		[3] = T.RT_358,
		[4] = T.RT_358,
		[5] = T.RT_358,
		[6] = T.RT_358,
	}
T.RT_360 = {
		150102,
	}
T.RT_361 = {
		[1] = T.RT_230,
	}
T.RT_362 = {
		[1] = "SKILL_DESC_1501ExtraTime",
	}
T.RT_363 = {
		[1] = "$#PassiveEffect[150102].Vars.LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_364 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_360,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_150104_DESC",
		SkillDescHints = T.RT_361,
		SkillDescKeys = T.RT_362,
		SkillDescValues = T.RT_363,
		SkillGrade = T.RT_2,
		SkillId = 150104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150104_NAME",
		SkillType = "ExtraPassive",
		bEnablePrediction = true,
	}
T.RT_365 = {
		[0] = T.RT_364,
		[1] = T.RT_364,
		[2] = T.RT_364,
		[3] = T.RT_364,
		[4] = T.RT_364,
		[5] = T.RT_364,
		[6] = T.RT_364,
	}
T.RT_366 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150122,
		CD = 2.5,
		CDType = 150102,
		CombatConditionID = 150103,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Baonu02_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Baonu_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 150121,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_367 = {
		[0] = T.RT_366,
		[1] = T.RT_366,
		[2] = T.RT_366,
		[3] = T.RT_366,
		[4] = T.RT_366,
		[5] = T.RT_366,
		[6] = T.RT_366,
	}
T.RT_368 = {
		AllowSkillIntensity = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 150131,
		PassiveEffects = T.RT_51,
		SkillGrade = T.RT_2,
		SkillId = 150123,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_369 = {
		[0] = T.RT_368,
		[1] = T.RT_368,
		[2] = T.RT_368,
		[3] = T.RT_368,
		[4] = T.RT_368,
		[5] = T.RT_368,
		[6] = T.RT_368,
	}
T.RT_370 = {
		150103,
	}
T.RT_371 = {
		AllowSkillIntensity = true,
		AttackSpeedType = T.RT_56,
		BeginNodeId = 150141,
		PassiveEffects = T.RT_370,
		SkillGrade = T.RT_2,
		SkillId = 150124,
		SkillLevel = T.RT_8,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_372 = {
		[0] = T.RT_371,
		[1] = T.RT_371,
		[2] = T.RT_371,
		[3] = T.RT_371,
		[4] = T.RT_371,
		[5] = T.RT_371,
		[6] = T.RT_371,
	}
T.RT_373 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1030131,
		SkillGrade = T.RT_2,
		SkillId = 150125,
		SkillLevel = T.RT_8,
		SkillType = "FallAttack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_374 = {
		[0] = T.RT_373,
		[1] = T.RT_373,
		[2] = T.RT_373,
		[3] = T.RT_373,
		[4] = T.RT_373,
		[5] = T.RT_373,
		[6] = T.RT_373,
	}
T.RT_375 = {
		AttackSpeedType = T.RT_65,
		BeginNodeId = 1030141,
		SkillGrade = T.RT_2,
		SkillId = 150126,
		SkillLevel = T.RT_8,
		SkillType = "SlideAttack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_376 = {
		[0] = T.RT_375,
		[1] = T.RT_375,
		[2] = T.RT_375,
		[3] = T.RT_375,
		[4] = T.RT_375,
		[5] = T.RT_375,
		[6] = T.RT_375,
	}
T.RT_377 = {
		"Term_1502_Skill01",
	}
T.RT_378 = {
		4,
		5,
		8,
		9,
	}
T.RT_379 = {
		SKILL_SECTIONDESC_1502_Skill01_01 = T.RT_378,
	}
T.RT_380 = {
		2,
		3,
		6,
		7,
	}
T.RT_381 = {
		SKILL_SECTIONDESC_1502_Skill01_02 = T.RT_380,
	}
T.RT_382 = {
		[1] = T.RT_379,
		[2] = T.RT_381,
	}
T.RT_383 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_168,
		[5] = T.RT_169,
	}
T.RT_384 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_1502Skill01Damage1",
		[3] = "SKILL_DESC_1502Skill01Radius1",
		[4] = "SKILL_DESC_1502Skill01Damage2",
		[5] = "SKILL_DESC_1502Skill01Radius2",
		[6] = "SKILL_DESC_1502Skill01Buff1",
		[7] = "SKILL_DESC_1502Skill01BuffTime1",
		[8] = "SKILL_DESC_1502Skill01Buff2",
		[9] = "SKILL_DESC_1502Skill01BuffTime2",
	}
T.RT_385 = {
		[1] = "$#SkillNode[150211].CostSp$",
		[2] = "$#SkillEffects[150213].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[150213].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[150214].TaskEffects[1].Rate*100$%",
		[5] = "$#TargetFilter[#SkillEffects[150214].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#Buff[150215].AddAttrs[1].Rate*-100$%",
		[7] = "$#SkillEffects[150213].TaskEffects[5].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[8] = "$#Buff[150214].AddAttrs[1].Value*-100$%",
		[9] = "$#SkillEffects[150214].TaskEffects[5].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_386 = {
		150211,
		150212,
		150213,
	}
T.RT_387 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150212,
		ExplanationId = T.RT_377,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Nifu01_1",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Nifu_Skill01",
		SkillDesc = "SKILL_150211_DESC",
		SkillDescGroups = T.RT_382,
		SkillDescHints = T.RT_383,
		SkillDescKeys = T.RT_384,
		SkillDescValues = T.RT_385,
		SkillGrade = T.RT_2,
		SkillId = 150201,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150211_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_386,
		bEnablePrediction = true,
	}
T.RT_388 = {
		[0] = T.RT_387,
		[1] = T.RT_387,
		[2] = T.RT_387,
		[3] = T.RT_387,
		[4] = T.RT_387,
		[5] = T.RT_387,
		[6] = T.RT_387,
	}
T.RT_389 = {
		[1] = T.RT_167,
		[3] = T.RT_230,
		[5] = T.RT_169,
		[6] = T.RT_168,
		[7] = T.RT_169,
	}
T.RT_390 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_TriggerProbUp",
		[3] = "SKILL_DESC_1502Skill02BuffTime",
		[4] = "SKILL_DESC_1502Skill02Rate",
		[5] = "SKILL_DESC_1502Skill02Radius1",
		[6] = "SKILL_DESC_1502Skill02Damage",
		[7] = "SKILL_DESC_1502Skill02Radius2",
	}
T.RT_391 = {
		[1] = "$#SkillNode[150221].CostSp$",
		[2] = "$#Buff[150221].AddAttrs[1].Value*100$%",
		[3] = "$#PassiveEffect[150201].Vars.Skill02BuffTime$$GText(\"SKILL_DESC_Second\")$",
		[4] = "$#PassiveEffect[150201].Vars.Skill02TransRate*100$%",
		[5] = "$#TargetFilter[#SkillEffects[150224].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#PassiveEffect[150201].Vars.Skill01BaseValueRate*100$%",
		[7] = "$#TargetFilter[#SkillEffects[150225].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_392 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150221,
		CD = 3,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Nifu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Nifu_Skill02",
		SkillDesc = "SKILL_150202_DESC",
		SkillDescHints = T.RT_389,
		SkillDescKeys = T.RT_390,
		SkillDescValues = T.RT_391,
		SkillGrade = T.RT_2,
		SkillId = 150202,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150202_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_393 = {
		[0] = T.RT_392,
		[1] = T.RT_392,
		[2] = T.RT_392,
		[3] = T.RT_392,
		[4] = T.RT_392,
		[5] = T.RT_392,
		[6] = T.RT_392,
	}
T.RT_394 = {
		150201,
	}
T.RT_395 = {
		[1] = "SKILL_DESC_1502Skill03Rate",
		[2] = "SKILL_DESC_1502Skill03MaxRate",
	}
T.RT_396 = {
		[1] = "$#PassiveEffect[150201].Vars.Skill01Rate*100$%$GText(\"SKILL_DESC_RangedTriggerProb\")$",
		[2] = "$#PassiveEffect[150201].Vars.MaxRate*100$%",
	}
T.RT_397 = {
		PassiveEffects = T.RT_394,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Nifu03",
		SkillDesc = "SKILL_150203_DESC",
		SkillDescKeys = T.RT_395,
		SkillDescValues = T.RT_396,
		SkillGrade = T.RT_2,
		SkillId = 150203,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150203_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_398 = {
		[0] = T.RT_397,
		[1] = T.RT_397,
		[2] = T.RT_397,
		[3] = T.RT_397,
		[4] = T.RT_397,
		[5] = T.RT_397,
		[6] = T.RT_397,
	}
T.RT_399 = {
		150202,
	}
T.RT_400 = {
		[1] = "SKILL_DESC_1502Skill04Rate",
	}
T.RT_401 = {
		[1] = "$#PassiveEffect[150202].Vars.TriggerRate*100$%",
	}
T.RT_402 = {
		PassiveEffects = T.RT_399,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_150204_DESC",
		SkillDescKeys = T.RT_400,
		SkillDescValues = T.RT_401,
		SkillGrade = T.RT_2,
		SkillId = 150204,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150204_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_403 = {
		[0] = T.RT_402,
		[1] = T.RT_402,
		[2] = T.RT_402,
		[3] = T.RT_402,
		[4] = T.RT_402,
		[5] = T.RT_402,
		[6] = T.RT_402,
	}
T.RT_404 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150211,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Nifu01_2",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Nifu_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 150211,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_405 = {
		[0] = T.RT_404,
		[1] = T.RT_404,
		[2] = T.RT_404,
		[3] = T.RT_404,
		[4] = T.RT_404,
		[5] = T.RT_404,
		[6] = T.RT_404,
	}
T.RT_406 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150214,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Nifu01_3",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Nifu_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 150212,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_407 = {
		[0] = T.RT_406,
		[1] = T.RT_406,
		[2] = T.RT_406,
		[3] = T.RT_406,
		[4] = T.RT_406,
		[5] = T.RT_406,
		[6] = T.RT_406,
	}
T.RT_408 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150213,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Nifu01_4",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Nifu_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 150213,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_409 = {
		[0] = T.RT_408,
		[1] = T.RT_408,
		[2] = T.RT_408,
		[3] = T.RT_408,
		[4] = T.RT_408,
		[5] = T.RT_408,
		[6] = T.RT_408,
	}
T.RT_410 = {
		FuncName = "ExecuteSkill01",
		Id = 150301,
	}
T.RT_411 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[5] = T.RT_230,
	}
T.RT_412 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_DamageRadius",
		[4] = "SKILL_DESC_AtkSpeedUp",
		[5] = "SKILL_DESC_Sustain",
	}
T.RT_413 = {
		[1] = "$#Skill[150301][1][0].NotExecuteSpCost$",
		[2] = "$#SkillEffects[150312].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[150312].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#Buff[150312].AddAttrs[1].Value*100$%",
		[5] = "$#PassiveEffect[150301].Vars.Skill01BuffLastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_414 = {
		150311,
	}
T.RT_415 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		CD = 1,
		ExecuteClientPassiveFunc = "ExecuteSkill01",
		ExecutePassiveFunc = T.RT_410,
		IgnoreTag = true,
		NotExecute = true,
		NotExecuteSpCost = 20,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Kezhou01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Kezhou_Skill01",
		SkillDesc = "SKILL_150301_DESC",
		SkillDescHints = T.RT_411,
		SkillDescKeys = T.RT_412,
		SkillDescValues = T.RT_413,
		SkillEffectsList = T.RT_414,
		SkillGrade = T.RT_2,
		SkillId = 150301,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150301_NAME",
		SkillType = "Skill1",
		SubSkills = T.RT_414,
		bEnablePrediction = true,
	}
T.RT_416 = {
		[0] = T.RT_415,
		[1] = T.RT_415,
		[2] = T.RT_415,
		[3] = T.RT_415,
		[4] = T.RT_415,
		[5] = T.RT_415,
		[6] = T.RT_415,
	}
T.RT_417 = {
		"Term_1503_Skill02_01",
		"Term_1503_Skill02_02",
		"Term_1503_Skill02",
	}
T.RT_418 = {
		1,
		3,
		5,
		6,
		7,
		4,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
		17,
	}
T.RT_419 = {
		SKILL_SECTIONDESC_1503_Skill02_01 = T.RT_418,
	}
T.RT_420 = {
		2,
		8,
		9,
	}
T.RT_421 = {
		SKILL_SECTIONDESC_1503_Skill02_02 = T.RT_420,
	}
T.RT_422 = {
		[1] = T.RT_419,
		[2] = T.RT_421,
	}
T.RT_423 = {
		[1] = T.RT_167,
		[2] = T.RT_167,
		[3] = T.RT_168,
		[5] = T.RT_169,
		[6] = T.RT_168,
		[8] = T.RT_168,
		[9] = T.RT_169,
	}
T.RT_424 = {
		[1] = "SKILL_DESC_1503Skill02SpCostOpen",
		[2] = "SKILL_DESC_1503Skill02SpCostClose",
		[3] = "SKILL_DESC_1503Skill02Damage01",
		[4] = "SKILL_DESC_1503Skill02WeaponRange",
		[5] = "SKILL_DESC_1503Skill02Damage01Range",
		[6] = "SKILL_DESC_1503Skill02Damage02",
		[7] = "SKILL_DESC_1503Skill02Damage02Rate",
		[8] = "SKILL_DESC_1503Skill02Damage03",
		[9] = "SKILL_DESC_1503Skill02Damage03Range",
		[10] = "SKILL_DESC_1503Skill02_Sword_RunAttack",
		[11] = "SKILL_DESC_1503Skill02_Polearm_RunAttack",
		[12] = "SKILL_DESC_1503Skill02_Claymore_RunAttack",
		[13] = "SKILL_DESC_1503Skill02_Dualblade_RunAttack",
		[14] = "SKILL_DESC_1503Skill02_Weapon_Other",
		[15] = "SKILL_DESC_1503Skill02_Weapon_Change",
	}
T.RT_425 = {
		[1] = "$#SkillNode[150321].CostSp$",
		[2] = "$#SkillNode[150322].CostSp$",
		[3] = "$#SkillEffects[150326].TaskEffects[1].Rate*100$%",
		[4] = "$#Buff[150325].AddAttrs[1].Value/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#TargetFilter[#SkillEffects[150326].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#SkillEffects[150345].TaskEffects[1].Rate*100$%",
		[7] = "$#PassiveEffect[150301].Vars.DotCheckOutRate*100$%$GText(\"SKILL_DESC_MeleeTriggerProb\")$",
		[8] = "$#SkillEffects[150343].TaskEffects[1].Rate*100$%",
		[9] = "$#TargetFilter[#SkillEffects[150343].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[10] = "$#SkillEffects[150351].TaskEffects[1].Rate*100$%",
		[11] = "$#SkillEffects[150361].TaskEffects[1].Rate*100$%",
		[12] = "$#SkillEffects[150381].TaskEffects[1].Rate*100$%",
		[13] = "$#SkillEffects[150391].TaskEffects[1].Rate*100$%",
		[14] = "$#SkillEffects[150356].TaskEffects[1].Rate*100$%",
		[15] = "$#SkillEffects[150335].TaskEffects[1].Rate*100$%",
	}
T.RT_426 = {
		150321,
	}
T.RT_427 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150321,
		CD = 3,
		CDType = 150302,
		ExplanationId = T.RT_417,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Kezhou02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Kezhou_Skill02",
		SkillDesc = "SKILL_150302_DESC",
		SkillDescGroups = T.RT_422,
		SkillDescHints = T.RT_423,
		SkillDescKeys = T.RT_424,
		SkillDescValues = T.RT_425,
		SkillGrade = T.RT_2,
		SkillId = 150302,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150302_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_426,
		bEnablePrediction = true,
	}
T.RT_428 = {
		[0] = T.RT_427,
		[1] = T.RT_427,
		[2] = T.RT_427,
		[3] = T.RT_427,
		[4] = T.RT_427,
		[5] = T.RT_427,
		[6] = T.RT_427,
	}
T.RT_429 = {
		150301,
	}
T.RT_430 = {
		[1] = "SKILL_DESC_1503PassiveValue",
		[2] = "SKILL_DESC_1503Skill02SpCost01",
		[3] = "SKILL_DESC_1503Skill02SpCost02",
	}
T.RT_431 = {
		[1] = "$#Buff[150301].AddAttrs[1].Value*100$%",
		[2] = "$-#Buff[150301].BuffSpModify[150302].Value$$GText(\"SKILL_DESC_1503PassiveValue01\")$",
		[3] = "$-#Buff[150302].BuffSpModify[150321].Value$$GText(\"SKILL_DESC_1503PassiveValue02\")$",
	}
T.RT_432 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_429,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Kezhou03",
		SkillDesc = "SKILL_150303_DESC",
		SkillDescKeys = T.RT_430,
		SkillDescValues = T.RT_431,
		SkillGrade = T.RT_2,
		SkillId = 150303,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150303_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_433 = {
		[0] = T.RT_432,
		[1] = T.RT_432,
		[2] = T.RT_432,
		[3] = T.RT_432,
		[4] = T.RT_432,
		[5] = T.RT_432,
		[6] = T.RT_432,
	}
T.RT_434 = {
		150302,
	}
T.RT_435 = {
		[1] = "SKILL_DESC_1503Passive2LastTime",
	}
T.RT_436 = {
		[1] = "$#PassiveEffect[150302].Vars.Passive2LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_437 = {
		PassiveEffects = T.RT_434,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_150304_DESC",
		SkillDescHints = T.RT_361,
		SkillDescKeys = T.RT_435,
		SkillDescValues = T.RT_436,
		SkillGrade = T.RT_2,
		SkillId = 150304,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150304_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_438 = {
		[0] = T.RT_437,
		[1] = T.RT_437,
		[2] = T.RT_437,
		[3] = T.RT_437,
		[4] = T.RT_437,
		[5] = T.RT_437,
		[6] = T.RT_437,
	}
T.RT_439 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1503101,
		PassiveEffects = T.RT_51,
		SkillGrade = T.RT_2,
		SkillId = 1503101,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 1,
		bEnablePrediction = true,
	}
T.RT_440 = {
		[0] = T.RT_439,
		[1] = T.RT_439,
		[2] = T.RT_439,
		[3] = T.RT_439,
		[4] = T.RT_439,
		[5] = T.RT_439,
		[6] = T.RT_439,
	}
T.RT_441 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1503105,
		PassiveEffects = T.RT_57,
		SkillGrade = T.RT_2,
		SkillId = 1503102,
		SkillLevel = T.RT_8,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 1,
		bEnablePrediction = true,
	}
T.RT_442 = {
		[0] = T.RT_441,
		[1] = T.RT_441,
		[2] = T.RT_441,
		[3] = T.RT_441,
		[4] = T.RT_441,
		[5] = T.RT_441,
		[6] = T.RT_441,
	}
T.RT_443 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1503106,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillGrade = T.RT_2,
		SkillId = 1503103,
		SkillLevel = T.RT_8,
		SkillType = "FallAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 1,
		bEnablePrediction = true,
	}
T.RT_444 = {
		[0] = T.RT_443,
		[1] = T.RT_443,
		[2] = T.RT_443,
		[3] = T.RT_443,
		[4] = T.RT_443,
		[5] = T.RT_443,
		[6] = T.RT_443,
	}
T.RT_445 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1503107,
		SkillGrade = T.RT_2,
		SkillId = 1503104,
		SkillLevel = T.RT_8,
		SkillType = "SlideAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 1,
		bEnablePrediction = true,
	}
T.RT_446 = {
		[0] = T.RT_445,
		[1] = T.RT_445,
		[2] = T.RT_445,
		[3] = T.RT_445,
		[4] = T.RT_445,
		[5] = T.RT_445,
		[6] = T.RT_445,
	}
T.RT_447 = {
		BeginNodeId = 150311,
		SkillGrade = T.RT_2,
		SkillId = 150311,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_448 = {
		[0] = T.RT_447,
		[1] = T.RT_447,
		[2] = T.RT_447,
		[3] = T.RT_447,
		[4] = T.RT_447,
		[5] = T.RT_447,
		[6] = T.RT_447,
	}
T.RT_449 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1503121,
		IgnoreTimeDilation = true,
		PassiveEffects = T.RT_51,
		SkillGrade = T.RT_2,
		SkillId = 1503121,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 2,
		bEnablePrediction = true,
	}
T.RT_450 = {
		[0] = T.RT_449,
		[1] = T.RT_449,
		[2] = T.RT_449,
		[3] = T.RT_449,
		[4] = T.RT_449,
		[5] = T.RT_449,
		[6] = T.RT_449,
	}
T.RT_451 = {
		AllowEightOrient = "OptionalLockOrient",
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1503126,
		PassiveEffects = T.RT_57,
		SkillGrade = T.RT_2,
		SkillId = 1503122,
		SkillLevel = T.RT_8,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 2,
		bEnablePrediction = true,
	}
T.RT_452 = {
		[0] = T.RT_451,
		[1] = T.RT_451,
		[2] = T.RT_451,
		[3] = T.RT_451,
		[4] = T.RT_451,
		[5] = T.RT_451,
		[6] = T.RT_451,
	}
T.RT_453 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1503127,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillGrade = T.RT_2,
		SkillId = 1503123,
		SkillLevel = T.RT_8,
		SkillType = "FallAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 2,
		bEnablePrediction = true,
	}
T.RT_454 = {
		[0] = T.RT_453,
		[1] = T.RT_453,
		[2] = T.RT_453,
		[3] = T.RT_453,
		[4] = T.RT_453,
		[5] = T.RT_453,
		[6] = T.RT_453,
	}
T.RT_455 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1503128,
		SkillGrade = T.RT_2,
		SkillId = 1503124,
		SkillLevel = T.RT_8,
		SkillType = "SlideAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 2,
		bEnablePrediction = true,
	}
T.RT_456 = {
		[0] = T.RT_455,
		[1] = T.RT_455,
		[2] = T.RT_455,
		[3] = T.RT_455,
		[4] = T.RT_455,
		[5] = T.RT_455,
		[6] = T.RT_455,
	}
T.RT_457 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1503141,
		PassiveEffects = T.RT_51,
		SkillGrade = T.RT_2,
		SkillId = 1503141,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 3,
		bEnablePrediction = true,
	}
T.RT_458 = {
		[0] = T.RT_457,
		[1] = T.RT_457,
		[2] = T.RT_457,
		[3] = T.RT_457,
		[4] = T.RT_457,
		[5] = T.RT_457,
		[6] = T.RT_457,
	}
T.RT_459 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1503145,
		PassiveEffects = T.RT_57,
		SkillGrade = T.RT_2,
		SkillId = 1503142,
		SkillLevel = T.RT_8,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 3,
		bEnablePrediction = true,
	}
T.RT_460 = {
		[0] = T.RT_459,
		[1] = T.RT_459,
		[2] = T.RT_459,
		[3] = T.RT_459,
		[4] = T.RT_459,
		[5] = T.RT_459,
		[6] = T.RT_459,
	}
T.RT_461 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1503146,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillGrade = T.RT_2,
		SkillId = 1503143,
		SkillLevel = T.RT_8,
		SkillType = "FallAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 3,
		bEnablePrediction = true,
	}
T.RT_462 = {
		[0] = T.RT_461,
		[1] = T.RT_461,
		[2] = T.RT_461,
		[3] = T.RT_461,
		[4] = T.RT_461,
		[5] = T.RT_461,
		[6] = T.RT_461,
	}
T.RT_463 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1503147,
		SkillGrade = T.RT_2,
		SkillId = 1503144,
		SkillLevel = T.RT_8,
		SkillType = "SlideAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 3,
		bEnablePrediction = true,
	}
T.RT_464 = {
		[0] = T.RT_463,
		[1] = T.RT_463,
		[2] = T.RT_463,
		[3] = T.RT_463,
		[4] = T.RT_463,
		[5] = T.RT_463,
		[6] = T.RT_463,
	}
T.RT_465 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1503161,
		PassiveEffects = T.RT_51,
		SkillGrade = T.RT_2,
		SkillId = 1503161,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 4,
		bEnablePrediction = true,
	}
T.RT_466 = {
		[0] = T.RT_465,
		[1] = T.RT_465,
		[2] = T.RT_465,
		[3] = T.RT_465,
		[4] = T.RT_465,
		[5] = T.RT_465,
		[6] = T.RT_465,
	}
T.RT_467 = {
		AttackSpeedType = T.RT_56,
		BeginNodeId = 1503165,
		PassiveEffects = T.RT_57,
		SkillGrade = T.RT_2,
		SkillId = 1503162,
		SkillLevel = T.RT_8,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 4,
		bEnablePrediction = true,
	}
T.RT_468 = {
		[0] = T.RT_467,
		[1] = T.RT_467,
		[2] = T.RT_467,
		[3] = T.RT_467,
		[4] = T.RT_467,
		[5] = T.RT_467,
		[6] = T.RT_467,
	}
T.RT_469 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 1503166,
		CD = 0.3,
		CDCalcType = "End",
		HideCDToast = 1,
		SkillGrade = T.RT_2,
		SkillId = 1503163,
		SkillLevel = T.RT_8,
		SkillType = "FallAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 4,
		bEnablePrediction = true,
	}
T.RT_470 = {
		[0] = T.RT_469,
		[1] = T.RT_469,
		[2] = T.RT_469,
		[3] = T.RT_469,
		[4] = T.RT_469,
		[5] = T.RT_469,
		[6] = T.RT_469,
	}
T.RT_471 = {
		AttackSpeedType = T.RT_50,
		BeginNodeId = 1503167,
		SkillGrade = T.RT_2,
		SkillId = 1503164,
		SkillLevel = T.RT_8,
		SkillType = "SlideAttack",
		SkillWeaponType = "Ultra",
		UltraOrdinal = 4,
		bEnablePrediction = true,
	}
T.RT_472 = {
		[0] = T.RT_471,
		[1] = T.RT_471,
		[2] = T.RT_471,
		[3] = T.RT_471,
		[4] = T.RT_471,
		[5] = T.RT_471,
		[6] = T.RT_471,
	}
T.RT_473 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150322,
		CD = 3,
		CDType = 150302,
		CombatConditionID = 150303,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Kezhou02_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Kezhou_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 150321,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_474 = {
		[0] = T.RT_473,
		[1] = T.RT_473,
		[2] = T.RT_473,
		[3] = T.RT_473,
		[4] = T.RT_473,
		[5] = T.RT_473,
		[6] = T.RT_473,
	}
T.RT_475 = {
		[4] = T.RT_168,
	}
T.RT_476 = {
		[1] = "SKILL_DESC_1504_Skill01_SecondSpChangeScd01",
		[2] = "SKILL_DESC_1504_Skill01_SecondSpChangeScd02",
		[3] = "SKILL_DESC_1504_Skill01_SecondSpRecover",
		[4] = "SKILL_DESC_Damage",
	}
T.RT_477 = {
		[1] = "$math.abs(#Buff[150407].DotDatas[1].Value)$/$math.abs(#Buff[150407].DotDatas[1].Interval)$$GText(\"SKILL_DESC_Second\")$",
		[2] = "$math.abs(#Buff[150408].DotDatas[1].Value)$/$math.abs(#Buff[150408].DotDatas[1].Interval)$$GText(\"SKILL_DESC_Second\")$",
		[3] = "$math.abs(#Buff[150409].DotDatas[1].Value)$/$math.abs(#Buff[150409].DotDatas[1].Interval)$$GText(\"SKILL_DESC_Second\")$",
		[4] = "$#SkillEffects[150414].TaskEffects[1].Rate*100$%",
	}
T.RT_478 = {
		150411,
	}
T.RT_479 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150412,
		CD = 1,
		CDType = 150401,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Suyi01_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Suyi_Skill01",
		SkillDesc = "SKILL_150401_DESC",
		SkillDescHints = T.RT_475,
		SkillDescKeys = T.RT_476,
		SkillDescValues = T.RT_477,
		SkillGrade = T.RT_2,
		SkillId = 150401,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150401_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_478,
		bEnablePrediction = true,
	}
T.RT_480 = {
		[0] = T.RT_479,
		[1] = T.RT_479,
		[2] = T.RT_479,
		[3] = T.RT_479,
		[4] = T.RT_479,
		[5] = T.RT_479,
		[6] = T.RT_479,
	}
T.RT_481 = {
		"Term_1504_Skill02_01",
		"Term_1504_Skill02_02",
		"Term_1504_Skill02_03",
	}
T.RT_482 = {
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_168,
		[5] = T.RT_169,
		[6] = T.RT_168,
		[7] = T.RT_169,
		[8] = T.RT_230,
		[10] = T.RT_167,
	}
T.RT_483 = {
		[1] = "SKILL_DESC_Skill02_BulletNumPer",
		[2] = "SKILL_DESC_Skill02_Damage01",
		[3] = "SKILL_DESC_Skill02_Range01",
		[4] = "SKILL_DESC_Skill02_Damage02",
		[5] = "SKILL_DESC_Skill02_Range02",
		[6] = "SKILL_DESC_Skill02_Damage03",
		[7] = "SKILL_DESC_Skill02_Range03",
		[8] = "SKILL_DESC_Skill02_BuffLastTime",
		[9] = "SKILL_DESC_Strong",
		[10] = "SKILL_DESC_SpCost_Min",
	}
T.RT_484 = {
		[1] = "$GText(\"SKILL_DESC_RangedBulletMax\")$*$#PassiveEffect[150401].Vars.Skill02BulletNumPer$",
		[2] = "$#SkillEffects[150455].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillCreature[150405].ShapeInfo.BoxWidth*2/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[150434].TaskEffects[1].Rate*100$%",
		[5] = "$#TargetFilter[#SkillEffects[150434].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#SkillEffects[150445].TaskEffects[1].Rate*100$%",
		[7] = "$#TargetFilter[#SkillEffects[150445].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[8] = "$#PassiveEffect[150401].Vars.Skill02BuffLastTime$",
		[9] = "$#Buff[150403].AddAttrs[1].Value*100$%",
		[10] = "$#SkillNode[150421].CostSp$",
	}
T.RT_485 = {
		150421,
	}
T.RT_486 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150421,
		CD = 2,
		CDType = 150402,
		ExplanationId = T.RT_481,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Suyi02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Suyi_Skill02",
		SkillDesc = "SKILL_150402_DESC",
		SkillDescHints = T.RT_482,
		SkillDescKeys = T.RT_483,
		SkillDescValues = T.RT_484,
		SkillGrade = T.RT_2,
		SkillId = 150402,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150402_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_485,
		bEnablePrediction = true,
	}
T.RT_487 = {
		[0] = T.RT_486,
		[1] = T.RT_486,
		[2] = T.RT_486,
		[3] = T.RT_486,
		[4] = T.RT_486,
		[5] = T.RT_486,
		[6] = T.RT_486,
	}
T.RT_488 = {
		"Term_1504_Passive_01",
	}
T.RT_489 = {
		150401,
	}
T.RT_490 = {
		[2] = T.RT_168,
		[3] = T.RT_169,
	}
T.RT_491 = {
		[1] = "SKILL_DESC_Passive_AddSp",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_DamageRadius",
		[4] = "SKILL_DESC_Passive_AddRate",
	}
T.RT_492 = {
		[1] = "$#PassiveEffect[150401].Vars.AddSpPer$",
		[2] = "$#SkillEffects[150427].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[150427].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#PassiveEffect[150401].Vars.Skill02OffAddDamageBaseRatePer$",
	}
T.RT_493 = {
		150405,
	}
T.RT_494 = {
		AllowSkillIntensity = true,
		ExplanationId = T.RT_488,
		PassiveEffects = T.RT_489,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Suyi03",
		SkillDesc = "SKILL_150403_DESC",
		SkillDescHints = T.RT_490,
		SkillDescKeys = T.RT_491,
		SkillDescValues = T.RT_492,
		SkillGrade = T.RT_2,
		SkillId = 150403,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150403_NAME",
		SkillType = "Passive",
		SubSkills = T.RT_493,
		bEnablePrediction = true,
	}
T.RT_495 = {
		[0] = T.RT_494,
		[1] = T.RT_494,
		[2] = T.RT_494,
		[3] = T.RT_494,
		[4] = T.RT_494,
		[5] = T.RT_494,
		[6] = T.RT_494,
	}
T.RT_496 = {
		150402,
	}
T.RT_497 = {
		[1] = "SKILL_DESC_Passive2_ConversionRate",
	}
T.RT_498 = {
		[1] = "$#PassiveEffect[150402].Vars.ConversionRate$",
	}
T.RT_499 = {
		PassiveEffects = T.RT_496,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_150404_DESC",
		SkillDescKeys = T.RT_497,
		SkillDescValues = T.RT_498,
		SkillGrade = T.RT_2,
		SkillId = 150404,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_150404_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_500 = {
		[0] = T.RT_499,
		[1] = T.RT_499,
		[2] = T.RT_499,
		[3] = T.RT_499,
		[4] = T.RT_499,
		[5] = T.RT_499,
		[6] = T.RT_499,
	}
T.RT_501 = {
		BeginNodeId = 150451,
		SkillGrade = T.RT_2,
		SkillId = 150405,
		SkillLevel = T.RT_8,
		SkillType = "Condemn",
		SkillWeaponType = "Condemn",
		bEnablePrediction = true,
	}
T.RT_502 = {
		[0] = T.RT_501,
		[1] = T.RT_501,
		[2] = T.RT_501,
		[3] = T.RT_501,
		[4] = T.RT_501,
		[5] = T.RT_501,
		[6] = T.RT_501,
	}
T.RT_503 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 150413,
		CD = 1,
		CDType = 150401,
		CombatConditionID = 150404,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Suyi01_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Suyi_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 150411,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_328,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_504 = {
		[0] = T.RT_503,
		[1] = T.RT_503,
		[2] = T.RT_503,
		[3] = T.RT_503,
		[4] = T.RT_503,
		[5] = T.RT_503,
		[6] = T.RT_503,
	}
T.RT_505 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150422,
		CD = 2,
		CDType = 150402,
		CombatConditionID = 150403,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Suyi02_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Suyi_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 150421,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_506 = {
		[0] = T.RT_505,
		[1] = T.RT_505,
		[2] = T.RT_505,
		[3] = T.RT_505,
		[4] = T.RT_505,
		[5] = T.RT_505,
		[6] = T.RT_505,
	}
T.RT_507 = {
		150431,
	}
T.RT_508 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150431,
		CancelBlockMove = 1,
		ClientSkillLogicId = 150402,
		SkillGrade = T.RT_2,
		SkillId = 150422,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Shooting",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_507,
		bEnablePrediction = true,
	}
T.RT_509 = {
		[0] = T.RT_508,
		[1] = T.RT_508,
		[2] = T.RT_508,
		[3] = T.RT_508,
		[4] = T.RT_508,
		[5] = T.RT_508,
		[6] = T.RT_508,
	}
T.RT_510 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150432,
		CancelBlockMove = 1,
		ClientSkillLogicId = 150401,
		SkillGrade = T.RT_2,
		SkillId = 150431,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Shooting",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_511 = {
		[0] = T.RT_510,
		[1] = T.RT_510,
		[2] = T.RT_510,
		[3] = T.RT_510,
		[4] = T.RT_510,
		[5] = T.RT_510,
		[6] = T.RT_510,
	}
T.RT_512 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150441,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 150441,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_513 = {
		[0] = T.RT_512,
		[1] = T.RT_512,
		[2] = T.RT_512,
		[3] = T.RT_512,
		[4] = T.RT_512,
		[5] = T.RT_512,
		[6] = T.RT_512,
	}
T.RT_514 = {
		150513,
	}
T.RT_515 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150511,
		LongPressSkill = 150513,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Baonu02_On",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 150501,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_514,
		bEnablePrediction = true,
	}
T.RT_516 = {
		[0] = T.RT_515,
		[1] = T.RT_515,
		[2] = T.RT_515,
		[3] = T.RT_515,
		[4] = T.RT_515,
		[5] = T.RT_515,
		[6] = T.RT_515,
	}
T.RT_517 = {
		150521,
	}
T.RT_518 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150521,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Baonu02_On",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 150502,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_517,
		bEnablePrediction = true,
	}
T.RT_519 = {
		[0] = T.RT_518,
		[1] = T.RT_518,
		[2] = T.RT_518,
		[3] = T.RT_518,
		[4] = T.RT_518,
		[5] = T.RT_518,
		[6] = T.RT_518,
	}
T.RT_520 = {
		150501,
	}
T.RT_521 = {
		PassiveEffects = T.RT_520,
		SkillGrade = T.RT_2,
		SkillId = 150503,
		SkillLevel = T.RT_8,
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_522 = {
		[0] = T.RT_521,
		[1] = T.RT_521,
		[2] = T.RT_521,
		[3] = T.RT_521,
		[4] = T.RT_521,
		[5] = T.RT_521,
		[6] = T.RT_521,
	}
T.RT_523 = {
		150502,
	}
T.RT_524 = {
		PassiveEffects = T.RT_523,
		SkillGrade = T.RT_2,
		SkillId = 150504,
		SkillLevel = T.RT_8,
		SkillType = "ExtraPassive",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_525 = {
		[0] = T.RT_524,
		[1] = T.RT_524,
		[2] = T.RT_524,
		[3] = T.RT_524,
		[4] = T.RT_524,
		[5] = T.RT_524,
		[6] = T.RT_524,
	}
T.RT_526 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 150531,
		SkillGrade = T.RT_2,
		SkillId = 150511,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_527 = {
		[0] = T.RT_526,
		[1] = T.RT_526,
		[2] = T.RT_526,
		[3] = T.RT_526,
		[4] = T.RT_526,
		[5] = T.RT_526,
		[6] = T.RT_526,
	}
T.RT_528 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 150532,
		SkillGrade = T.RT_2,
		SkillId = 150512,
		SkillLevel = T.RT_8,
		SkillType = "Shooting",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_529 = {
		[0] = T.RT_528,
		[1] = T.RT_528,
		[2] = T.RT_528,
		[3] = T.RT_528,
		[4] = T.RT_528,
		[5] = T.RT_528,
		[6] = T.RT_528,
	}
T.RT_530 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 150533,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Baonu02_Off",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 150513,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_531 = {
		[0] = T.RT_530,
		[1] = T.RT_530,
		[2] = T.RT_530,
		[3] = T.RT_530,
		[4] = T.RT_530,
		[5] = T.RT_530,
		[6] = T.RT_530,
	}
T.RT_532 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 150531,
		SkillGrade = T.RT_2,
		SkillId = 150514,
		SkillLevel = T.RT_8,
		SkillType = "HeavyAttack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_533 = {
		[0] = T.RT_532,
		[1] = T.RT_532,
		[2] = T.RT_532,
		[3] = T.RT_532,
		[4] = T.RT_532,
		[5] = T.RT_532,
		[6] = T.RT_532,
	}
T.RT_534 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 150522,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Heitao02_On",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 150521,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_535 = {
		[0] = T.RT_534,
		[1] = T.RT_534,
		[2] = T.RT_534,
		[3] = T.RT_534,
		[4] = T.RT_534,
		[5] = T.RT_534,
		[6] = T.RT_534,
	}
T.RT_536 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_1601Skill01Damage",
		[3] = "SKILL_DESC_1601Skill01Width",
	}
T.RT_537 = {
		[1] = "$#SkillNode[160111].CostSp$",
		[2] = "$#SkillEffects[160113].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillCreature[160101].ShapeInfo.BoxLength*2/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_538 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 160111,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhujue01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhujue_Skill01",
		SkillDesc = "SKILL_160101_DESC",
		SkillDescHints = T.RT_170,
		SkillDescKeys = T.RT_536,
		SkillDescValues = T.RT_537,
		SkillGrade = T.RT_2,
		SkillId = 160101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_160101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_539 = {
		[0] = T.RT_538,
		[1] = T.RT_538,
		[2] = T.RT_538,
		[3] = T.RT_538,
		[4] = T.RT_538,
		[5] = T.RT_538,
		[6] = T.RT_538,
	}
T.RT_540 = {
		"Term_1601_Skill02",
	}
T.RT_541 = {
		5,
		6,
	}
T.RT_542 = {
		SKILL_SECTIONDESC_1601_Skill02_01 = T.RT_541,
	}
T.RT_543 = {
		[1] = T.RT_542,
	}
T.RT_544 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_168,
		[5] = T.RT_230,
	}
T.RT_545 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_DamageRadius",
		[4] = "SKILL_DESC_OverES",
		[5] = "SKILL_DESC_Sustain",
		[6] = "SKILL_DESC_DmgUpWeapon",
	}
T.RT_546 = {
		[1] = "$#SkillNode[160112].CostSp$",
		[2] = "$#SkillEffects[160122].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[160122].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[160121].TaskEffects[2].Rate*100$%$GText(\"SKILL_DESC_MaxEs\")$",
		[5] = "$#SkillEffects[160121].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[6] = "$#Buff[160101].AddAttrs[1].Value*100$%",
	}
T.RT_547 = {
		AllowSkillIntensity = true,
		BeginNodeId = 160112,
		CD = 3,
		ExplanationId = T.RT_540,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Zhujue02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhujue_Skill02",
		SkillDesc = "SKILL_160102_DESC",
		SkillDescGroups = T.RT_543,
		SkillDescHints = T.RT_544,
		SkillDescKeys = T.RT_545,
		SkillDescValues = T.RT_546,
		SkillGrade = T.RT_2,
		SkillId = 160102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_160102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_548 = {
		[0] = T.RT_547,
		[1] = T.RT_547,
		[2] = T.RT_547,
		[3] = T.RT_547,
		[4] = T.RT_547,
		[5] = T.RT_547,
		[6] = T.RT_547,
	}
T.RT_549 = {
		160101,
	}
T.RT_550 = {
		[1] = T.RT_168,
		[2] = T.RT_169,
	}
T.RT_551 = {
		[1] = "SKILL_DESC_Damage",
		[2] = "SKILL_DESC_DamageRadius",
	}
T.RT_552 = {
		[1] = "$#SkillEffects[160132].TaskEffects[1].Rate*100$%",
		[2] = "$#TargetFilter[#SkillEffects[160132].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_553 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_549,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Zhujue03",
		SkillDesc = "SKILL_160103_DESC",
		SkillDescHints = T.RT_550,
		SkillDescKeys = T.RT_551,
		SkillDescValues = T.RT_552,
		SkillGrade = T.RT_2,
		SkillId = 160103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_160103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_554 = {
		[0] = T.RT_553,
		[1] = T.RT_553,
		[2] = T.RT_553,
		[3] = T.RT_553,
		[4] = T.RT_553,
		[5] = T.RT_553,
		[6] = T.RT_553,
	}
T.RT_555 = {
		160102,
	}
T.RT_556 = {
		[1] = "SKILL_DESC_Sustain",
		[2] = "SKILL_DESC_TriggerProbUp",
	}
T.RT_557 = {
		[1] = "$#SkillEffects[160131].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[2] = "$#Buff[160105].AddAttrs[1].Value*100$%",
	}
T.RT_558 = {
		PassiveEffects = T.RT_555,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_160104_DESC",
		SkillDescHints = T.RT_361,
		SkillDescKeys = T.RT_556,
		SkillDescValues = T.RT_557,
		SkillGrade = T.RT_2,
		SkillId = 160104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_160104_NAME",
		SkillType = "ExtraPassive",
		bEnablePrediction = true,
	}
T.RT_559 = {
		[0] = T.RT_558,
		[1] = T.RT_558,
		[2] = T.RT_558,
		[3] = T.RT_558,
		[4] = T.RT_558,
		[5] = T.RT_558,
		[6] = T.RT_558,
	}
T.RT_560 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 160191,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhujue01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhujue_Skill01",
		SkillDesc = "SKILL_160101_DESC",
		SkillGrade = T.RT_2,
		SkillId = 160191,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_160101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_561 = {
		[0] = T.RT_560,
		[1] = T.RT_560,
		[2] = T.RT_560,
		[3] = T.RT_560,
		[4] = T.RT_560,
		[5] = T.RT_560,
		[6] = T.RT_560,
	}
T.RT_562 = {
		AllowSkillIntensity = true,
		BeginNodeId = 160192,
		CD = 3,
		ExplanationId = T.RT_540,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Zhujue02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhujue_Skill02",
		SkillDesc = "SKILL_160102_DESC",
		SkillDescGroups = T.RT_543,
		SkillGrade = T.RT_2,
		SkillId = 160192,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_160102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_563 = {
		[0] = T.RT_562,
		[1] = T.RT_562,
		[2] = T.RT_562,
		[3] = T.RT_562,
		[4] = T.RT_562,
		[5] = T.RT_562,
		[6] = T.RT_562,
	}
T.RT_564 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_DamageRadius",
		[4] = "SKILL_DESC_1801Skill01Damage",
		[5] = "SKILL_DESC_SlowSustain",
	}
T.RT_565 = {
		[1] = "$#SkillNode[180111].CostSp$",
		[2] = "$#SkillEffects[180111].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[180111].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[180113].TaskEffects[1].Rate*100$%",
		[5] = "$#SkillEffects[180111].TaskEffects[2].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_566 = {
		180111,
	}
T.RT_567 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 180111,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Feina01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Feina_Skill01",
		SkillDesc = "SKILL_180101_DESC",
		SkillDescHints = T.RT_544,
		SkillDescKeys = T.RT_564,
		SkillDescValues = T.RT_565,
		SkillGrade = T.RT_2,
		SkillId = 180101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_180101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_566,
		bEnablePrediction = true,
	}
T.RT_568 = {
		[0] = T.RT_567,
		[1] = T.RT_567,
		[2] = T.RT_567,
		[3] = T.RT_567,
		[4] = T.RT_567,
		[5] = T.RT_567,
		[6] = T.RT_567,
	}
T.RT_569 = {
		"Term_1801_Skill02",
	}
T.RT_570 = {
		[1] = T.RT_167,
		[2] = T.RT_176,
		[3] = T.RT_169,
		[4] = T.RT_168,
		[6] = T.RT_230,
	}
T.RT_571 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SpChangeScd",
		[3] = "SKILL_DESC_1801Skill02Radius",
		[4] = "SKILL_DESC_DotDamage",
		[5] = "SKILL_DESC_BonusDmg",
		[6] = "SKILL_DESC_BonusDmgTime",
	}
T.RT_572 = {
		[1] = "$#SkillNode[180121].CostSp$",
		[2] = "$math.abs(#Buff[180102].DotDatas[1].Value)$",
		[3] = "$#Buff[180121].HaloDatas[1].AuraRange/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$(#Buff[180122].DotDatas[1].Rate)*100$%",
		[5] = "$#Buff[180131].AddAttrs[1].Value*100$%",
		[6] = "$#SkillEffects[180131].TaskEffects[2].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_573 = {
		180121,
	}
T.RT_574 = {
		AllowSkillIntensity = true,
		BeginNodeId = 180121,
		CD = 2.5,
		CDType = 180102,
		ExplanationId = T.RT_569,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Feina02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Feina_Skill02",
		SkillDesc = "SKILL_180102_DESC",
		SkillDescHints = T.RT_570,
		SkillDescKeys = T.RT_571,
		SkillDescValues = T.RT_572,
		SkillGrade = T.RT_2,
		SkillId = 180102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_180102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_573,
		bEnablePrediction = true,
	}
T.RT_575 = {
		[0] = T.RT_574,
		[1] = T.RT_574,
		[2] = T.RT_574,
		[3] = T.RT_574,
		[4] = T.RT_574,
		[5] = T.RT_574,
		[6] = T.RT_574,
	}
T.RT_576 = {
		"Term_1801_Passive",
	}
T.RT_577 = {
		180101,
	}
T.RT_578 = {
		2,
		3,
	}
T.RT_579 = {
		SKILL_SECTIONDESC_1801_Skill03_01 = T.RT_578,
	}
T.RT_580 = {
		[1] = T.RT_579,
	}
T.RT_581 = {
		[1] = T.RT_168,
		[2] = T.RT_168,
		[3] = T.RT_230,
	}
T.RT_582 = {
		[1] = "SKILL_DESC_1801Passive",
		[2] = "SKILL_DESC_1801Buff",
		[3] = "SKILL_DESC_1801BuffTime",
	}
T.RT_583 = {
		[1] = "$#Buff[180101].AddAttrs[1].Value*100$%",
		[2] = "$#Buff[180111].AddAttrs[1].Value*100$%",
		[3] = "$#PassiveEffect[180101].Vars.PassiveLastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_584 = {
		ExplanationId = T.RT_576,
		PassiveEffects = T.RT_577,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Feina03",
		SkillDesc = "SKILL_180103_DESC",
		SkillDescGroups = T.RT_580,
		SkillDescHints = T.RT_581,
		SkillDescKeys = T.RT_582,
		SkillDescValues = T.RT_583,
		SkillGrade = T.RT_2,
		SkillId = 180103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_180103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_585 = {
		[0] = T.RT_584,
		[1] = T.RT_584,
		[2] = T.RT_584,
		[3] = T.RT_584,
		[4] = T.RT_584,
		[5] = T.RT_584,
		[6] = T.RT_584,
	}
T.RT_586 = {
		180103,
	}
T.RT_587 = {
		[2] = T.RT_230,
	}
T.RT_588 = {
		[1] = "SKILL_DESC_DmgUp",
		[2] = "SKILL_DESC_Sustain",
	}
T.RT_589 = {
		[1] = "$#Buff[180141].AddAttrs[1].Value*100$%×$GText(\"SKILL_DESC_1801PassiveLayer\")$",
		[2] = "$#PassiveEffect[180103].Vars.BuffLastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_590 = {
		PassiveEffects = T.RT_586,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_180104_DESC",
		SkillDescHints = T.RT_587,
		SkillDescKeys = T.RT_588,
		SkillDescValues = T.RT_589,
		SkillGrade = T.RT_2,
		SkillId = 180104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_180104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_591 = {
		[0] = T.RT_590,
		[1] = T.RT_590,
		[2] = T.RT_590,
		[3] = T.RT_590,
		[4] = T.RT_590,
		[5] = T.RT_590,
		[6] = T.RT_590,
	}
T.RT_592 = {
		18011,
	}
T.RT_593 = {
		AllowUseSkillInAir = true,
		BeginContinuousSkillEffect = T.RT_592,
		IgnoreTag = true,
		IsContinuousSkill = true,
		NotEnterCD = true,
		NotExecute = true,
		PassiveEffects = T.RT_592,
		SkillGrade = T.RT_2,
		SkillId = 18011,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		bEnablePrediction = true,
	}
T.RT_594 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 180111,
		CD = 0.8,
		CDType = 180102,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Feina01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 180111,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_595 = {
		[0] = T.RT_594,
		[1] = T.RT_594,
		[2] = T.RT_594,
		[3] = T.RT_594,
		[4] = T.RT_594,
		[5] = T.RT_594,
		[6] = T.RT_594,
	}
T.RT_596 = {
		18010,
	}
T.RT_597 = {
		AllowUseSkillInAir = true,
		IgnoreTag = true,
		NotExecute = true,
		SkillEffectsList = T.RT_596,
		SkillGrade = T.RT_2,
		SkillId = 18012,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		bEnablePrediction = true,
	}
T.RT_598 = {
		FuncName = "SwitchSkill2",
		Id = 180101,
	}
T.RT_599 = {
		180122,
	}
T.RT_600 = {
		AllowUseSkillInAir = true,
		CD = 0.8,
		CDType = 180102,
		CombatConditionID = 180111,
		ExecutePassiveFunc = T.RT_598,
		IgnoreTag = true,
		LongPressSkill = 180122,
		NotEnterCD = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Feina02_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Feina_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 180121,
		SkillLevel = T.RT_8,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
		SubSkills = T.RT_599,
		bEnablePrediction = true,
	}
T.RT_601 = {
		[0] = T.RT_600,
		[1] = T.RT_600,
		[2] = T.RT_600,
		[3] = T.RT_600,
		[4] = T.RT_600,
		[5] = T.RT_600,
		[6] = T.RT_600,
	}
T.RT_602 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 180122,
		CD = 0.8,
		CDType = 180102,
		SkillDemo = "Feina_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 180122,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_603 = {
		[0] = T.RT_602,
		[1] = T.RT_602,
		[2] = T.RT_602,
		[3] = T.RT_602,
		[4] = T.RT_602,
		[5] = T.RT_602,
		[6] = T.RT_602,
	}
T.RT_604 = {
		180191,
	}
T.RT_605 = {
		[1] = "$#Buff[180192].AddAttrs[1].Value*100$%",
	}
T.RT_606 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_604,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_180191_DESC",
		SkillDescKeys = T.RT_17,
		SkillDescValues = T.RT_605,
		SkillGrade = T.RT_2,
		SkillId = 180191,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_180191_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_607 = {
		[0] = T.RT_606,
		[1] = T.RT_606,
		[2] = T.RT_606,
		[3] = T.RT_606,
		[4] = T.RT_606,
		[5] = T.RT_606,
		[6] = T.RT_606,
	}
T.RT_608 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 20,
		SkillGrade = T.RT_2,
		SkillId = 20,
		SkillLevel = T.RT_3,
		SkillType = "Recovery",
	}
T.RT_609 = {
		BeginNodeId = 20111,
		SkillGrade = T.RT_2,
		SkillId = 20101,
		SkillLevel = T.RT_3,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_610 = {
		20101,
	}
T.RT_611 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_ExploreRadius",
	}
T.RT_612 = {
		[1] = "$#SkillEffects[2010112].TaskEffects[1].Rate*100$%",
		[2] = "$#TargetFilter[#SkillEffects[2010114].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_613 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2010111,
		CancelBlockMove = 1,
		MaxHatred = 4,
		PassiveEffects = T.RT_610,
		SkillDescKeys = T.RT_611,
		SkillDescValues = T.RT_612,
		SkillGrade = T.RT_2,
		SkillId = 2010101,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_614 = {
		"Reload",
	}
T.RT_615 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2010121,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2010102,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_616 = {
		BeginNodeId = 20121,
		SkillGrade = T.RT_2,
		SkillId = 20102,
		SkillLevel = T.RT_3,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_617 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_ExploreDamage",
		[3] = "SKILL_DESC_ExploreRadius",
	}
T.RT_618 = {
		[1] = "$#SkillEffects[2010112].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2010114].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[2010114].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_619 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2010411,
		CancelBlockMove = 1,
		MaxHatred = 4,
		PassiveEffects = T.RT_610,
		SkillDescKeys = T.RT_617,
		SkillDescValues = T.RT_618,
		SkillGrade = T.RT_2,
		SkillId = 2010401,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_620 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2010421,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2010402,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_621 = {
		[1] = "SKILL_DESC_BullutDamage",
	}
T.RT_622 = {
		[1] = "$#SkillEffects[2019912].TaskEffects[1].Rate*100$%",
	}
T.RT_623 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2019911,
		CancelBlockMove = 1,
		MaxHatred = 4,
		SkillDescKeys = T.RT_621,
		SkillDescValues = T.RT_622,
		SkillGrade = T.RT_2,
		SkillId = 2019901,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_624 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2019921,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2019902,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_625 = {
		[1] = "$#SkillEffects[2020113].TaskEffects[1].Rate*100$%",
	}
T.RT_626 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2020111,
		CancelBlockMove = 1,
		MaxHatred = 4,
		SkillDescKeys = T.RT_621,
		SkillDescValues = T.RT_625,
		SkillGrade = T.RT_2,
		SkillId = 2020101,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_627 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2020121,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2020102,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_628 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_ReboundDamage",
	}
T.RT_629 = {
		[1] = "$#SkillEffects[2020313].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2020313].TaskEffects[1].Rate*100$%",
	}
T.RT_630 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2020311,
		CancelBlockMove = 1,
		MaxHatred = 4,
		SkillDescKeys = T.RT_628,
		SkillDescValues = T.RT_629,
		SkillGrade = T.RT_2,
		SkillId = 2020301,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_631 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2020321,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2020302,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_632 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2020711,
		CancelBlockMove = 1,
		MaxHatred = 4,
		SkillGrade = T.RT_2,
		SkillId = 2020701,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_633 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2020721,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2020702,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_634 = {
		[1] = "SKILL_DESC_ExploreDamage",
		[2] = "SKILL_DESC_ExploreRadius",
	}
T.RT_635 = {
		[1] = "$#SkillEffects[2030112].TaskEffects[1].Rate*100$%",
		[2] = "$#TargetFilter[#SkillEffects[2030112].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_636 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2030111,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_634,
		SkillDescValues = T.RT_635,
		SkillGrade = T.RT_2,
		SkillId = 2030101,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_637 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2030121,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2030102,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_638 = {
		[1] = "SKILL_DESC_ExploreDamage",
		[2] = "SKILL_DESC_ExploreDamage2",
		[3] = "SKILL_DESC_ExploreRadius",
		[4] = "SKILL_DESC_ExploreRadius2",
	}
T.RT_639 = {
		[1] = "$#SkillEffects[2030212].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2030216].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[2030212].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#TargetFilter[#SkillEffects[2030216].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_640 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2030211,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_638,
		SkillDescValues = T.RT_639,
		SkillGrade = T.RT_2,
		SkillId = 2030201,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_641 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2030221,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2030202,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_642 = {
		[1] = "SKILL_DESC_ExploreDamage",
		[2] = "SKILL_DESC_ExploreDamage2",
		[3] = "SKILL_DESC_ExploreDamage3",
		[4] = "SKILL_DESC_ExploreRadius",
		[5] = "SKILL_DESC_ExploreRadius2",
		[6] = "SKILL_DESC_ExploreRadius3",
	}
T.RT_643 = {
		[1] = "$#SkillEffects[2030312].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2030314].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[2030314].TaskEffects[1].Rate*100$%",
		[4] = "$#TargetFilter[#SkillEffects[2030312].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#TargetFilter[#SkillEffects[2030314].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#TargetFilter[#SkillEffects[2030314].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_644 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2030311,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_642,
		SkillDescValues = T.RT_643,
		SkillGrade = T.RT_2,
		SkillId = 2030301,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_645 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2030321,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2030302,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_646 = {
		[1] = "SKILL_DESC_ExploreDamage",
		[2] = "SKILL_DESC_DotDamage",
		[3] = "SKILL_DESC_ExploreDamage2",
		[4] = "SKILL_DESC_ExploreRadius",
		[5] = "SKILL_DESC_ExploreRadius2",
	}
T.RT_647 = {
		[1] = "$#SkillEffects[2030413].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2030414].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[2030416].TaskEffects[1].Rate*100$%",
		[4] = "$#TargetFilter[#SkillEffects[2030413].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#TargetFilter[#SkillEffects[2030416].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_648 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2030411,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_646,
		SkillDescValues = T.RT_647,
		SkillGrade = T.RT_2,
		SkillId = 2030401,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_649 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2030421,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2030402,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_650 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_ShootingRate",
		[3] = "SKILL_DESC_ShootingRate2",
		[4] = "SKILL_DESC_ShootingRate3",
		[5] = "SKILL_DESC_ShootingRate4",
	}
T.RT_651 = {
		[1] = "$#SkillEffects[2030512].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2030514].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
		[3] = "$#SkillEffects[2030517].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
		[4] = "$#SkillEffects[2030518].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
		[5] = "$#SkillEffects[2030519].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_652 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2030511,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_650,
		SkillDescValues = T.RT_651,
		SkillGrade = T.RT_2,
		SkillId = 2030501,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_653 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2030521,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2030502,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_654 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_BullutNum",
	}
T.RT_655 = {
		[1] = "$#SkillEffects[2040112].TaskEffects[1].Rate*100$%",
		[2] = "5.0",
	}
T.RT_656 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2040111,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_654,
		SkillDescValues = T.RT_655,
		SkillGrade = T.RT_2,
		SkillId = 2040101,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_657 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2040121,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2040102,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_658 = {
		[1] = "SKILL_DESC_ExploreDamage",
		[2] = "SKILL_DESC_ExploreRadius",
		[3] = "SKILL_DESC_ExploreRadius2",
		[4] = "SKILL_DESC_ExploreRadius3",
		[5] = "SKILL_DESC_ExploreRadius4",
	}
T.RT_659 = {
		[1] = "$#SkillEffects[2040213].TaskEffects[1].Rate*100$%",
		[2] = "$#TargetFilter[#SkillEffects[2040213].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[3] = "$#TargetFilter[#SkillEffects[2040214].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#TargetFilter[#SkillEffects[2040215].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#TargetFilter[#SkillEffects[2040216].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_660 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2040211,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_658,
		SkillDescValues = T.RT_659,
		SkillGrade = T.RT_2,
		SkillId = 2040201,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_661 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2040221,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2040202,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_662 = {
		[1] = "$#SkillEffects[2040313].TaskEffects[1].Rate*100$%",
		[2] = "$#TargetFilter[#SkillEffects[2040313].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_663 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2040311,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_634,
		SkillDescValues = T.RT_662,
		SkillGrade = T.RT_2,
		SkillId = 2040301,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_664 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2040321,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2040302,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_665 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_ExploreDamage",
		[3] = "SKILL_DESC_BullutWidth",
		[6] = "SKILL_DESC_ExploreRadius",
	}
T.RT_666 = {
		[1] = "$#SkillEffects[2040512].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2040518].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillCreature[2040511].ShapeInfo.BoxLength*2/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#TargetFilter[#SkillEffects[2040518].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_667 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2040511,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_665,
		SkillDescValues = T.RT_666,
		SkillGrade = T.RT_2,
		SkillId = 2040501,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_668 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2040512,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2040502,
		SkillLevel = T.RT_3,
		SkillType = "HeavyShooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_669 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2040521,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2040503,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_670 = {
		[1] = "SKILL_DESC_ShootingDamage",
		[2] = "SKILL_DESC_BullutDamage",
	}
T.RT_671 = {
		[1] = "$#SkillEffects[2040612].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2040615].TaskEffects[1].Rate*100$%",
	}
T.RT_672 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2040611,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_670,
		SkillDescValues = T.RT_671,
		SkillGrade = T.RT_2,
		SkillId = 2040601,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_673 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2040621,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2040602,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_674 = {
		[1] = "$#SkillEffects[2040712].TaskEffects[1].Rate*100$%",
	}
T.RT_675 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2040711,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_621,
		SkillDescValues = T.RT_674,
		SkillGrade = T.RT_2,
		SkillId = 2040701,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_676 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2040721,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2040702,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_677 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_ShootingRate",
	}
T.RT_678 = {
		[1] = "$#SkillEffects[2050113].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2050115].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_679 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2050111,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_677,
		SkillDescValues = T.RT_678,
		SkillGrade = T.RT_2,
		SkillId = 2050101,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_680 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2050121,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2050102,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_681 = {
		[1] = "SKILL_DESC_RayDamage",
		[2] = "SKILL_DESC_ReboundDamage",
		[3] = "SKILL_DESC_ShootingRate",
	}
T.RT_682 = {
		[1] = "$#SkillEffects[2050213].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2050214].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[2050215].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_683 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2050211,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_681,
		SkillDescValues = T.RT_682,
		SkillGrade = T.RT_2,
		SkillId = 2050201,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_684 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2050221,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2050202,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_685 = {
		[1] = "SKILL_DESC_RayDamage",
		[2] = "SKILL_DESC_ShootingRate",
	}
T.RT_686 = {
		[1] = "$#SkillEffects[2050314].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2050315].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_687 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2050311,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_685,
		SkillDescValues = T.RT_686,
		SkillGrade = T.RT_2,
		SkillId = 2050301,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_688 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2050321,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2050302,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_689 = {
		[1] = "SKILL_DESC_RayDamage",
		[2] = "SKILL_DESC_RayDamage2",
		[3] = "SKILL_DESC_RayDamage3",
		[4] = "SKILL_DESC_ShootingRate",
		[5] = "SKILL_DESC_ShootingRate2",
		[6] = "SKILL_DESC_ShootingRate3",
	}
T.RT_690 = {
		[1] = "$#SkillEffects[2050431].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2050432].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[2050433].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[2050414].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
		[5] = "$#SkillEffects[2050417].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
		[6] = "$#SkillEffects[2050418].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_691 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2050411,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_689,
		SkillDescValues = T.RT_690,
		SkillGrade = T.RT_2,
		SkillId = 2050401,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_692 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2050421,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2050402,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_693 = {
		[1] = "SKILL_DESC_RayDamage",
		[2] = "SKILL_DESC_ExploreDamage",
	}
T.RT_694 = {
		[1] = "$#SkillEffects[2050514].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2050517].TaskEffects[1].Rate*100$%",
	}
T.RT_695 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2050511,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_693,
		SkillDescValues = T.RT_694,
		SkillGrade = T.RT_2,
		SkillId = 2050501,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_696 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2050521,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2050502,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_697 = {
		[1] = "$#SkillEffects[2051231].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2051215].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_698 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2050611,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_677,
		SkillDescValues = T.RT_697,
		SkillGrade = T.RT_2,
		SkillId = 2050601,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_699 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2050621,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2050602,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_700 = {
		20600,
	}
T.RT_701 = {
		[1] = "$#SkillEffects[2050713].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2050715].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_702 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2050711,
		CancelBlockMove = 1,
		PassiveEffects = T.RT_700,
		SkillDescKeys = T.RT_677,
		SkillDescValues = T.RT_701,
		SkillGrade = T.RT_2,
		SkillId = 2050701,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_703 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2050921,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2050902,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_704 = {
		[1] = "$#SkillEffects[2051013].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2051015].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_705 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2051011,
		CancelBlockMove = 1,
		PassiveEffects = T.RT_700,
		SkillDescKeys = T.RT_677,
		SkillDescValues = T.RT_704,
		SkillGrade = T.RT_2,
		SkillId = 2051001,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_706 = {
		[2] = "SKILL_DESC_ShootingRate",
	}
T.RT_707 = {
		[2] = "$#SkillEffects[2050115].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_708 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2051111,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_706,
		SkillDescValues = T.RT_707,
		SkillGrade = T.RT_2,
		SkillId = 2051101,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_709 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2051121,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2051102,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_710 = {
		[1] = "$#SkillEffects[2050631].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2050615].TaskEffects[1].LoopInterval$$GText(\"SKILL_DESC_ShootingPerSecond\")$",
	}
T.RT_711 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2051211,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_677,
		SkillDescValues = T.RT_710,
		SkillGrade = T.RT_2,
		SkillId = 2051201,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_712 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_614,
		BeginNodeId = 2051221,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2051202,
		SkillLevel = T.RT_3,
		SkillType = "Reload",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_713 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_BullutDamage2",
		[3] = "SKILL_DESC_BullutDamage3",
		[4] = "SKILL_DESC_BullutWidth",
		[5] = "SKILL_DESC_BullutWidth2",
		[6] = "SKILL_DESC_BullutWidth3",
	}
T.RT_714 = {
		[1] = "$#SkillEffects[2060112].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2060122].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[2060132].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillCreature[2060111].ShapeInfo.BoxHeight*2/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#SkillCreature[2060121].ShapeInfo.BoxHeight*2/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#SkillCreature[2060131].ShapeInfo.BoxHeight*2/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_715 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2060111,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_713,
		SkillDescValues = T.RT_714,
		SkillGrade = T.RT_2,
		SkillId = 2060101,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_716 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2060121,
		CancelBlockMove = 1,
		PassiveEffects = T.RT_700,
		SkillGrade = T.RT_2,
		SkillId = 2060102,
		SkillLevel = T.RT_3,
		SkillType = "HeavyShooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_717 = {
		20604,
	}
T.RT_718 = {
		[1] = "$#SkillEffects[2060213].TaskEffects[1].Rate*100$%",
		[2] = "7.0",
	}
T.RT_719 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2060211,
		CancelBlockMove = 1,
		PassiveEffects = T.RT_717,
		SkillDescKeys = T.RT_654,
		SkillDescValues = T.RT_718,
		SkillGrade = T.RT_2,
		SkillId = 2060201,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_720 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_BullutWidth",
	}
T.RT_721 = {
		[1] = "$#SkillEffects[2060316].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillCreature[2060312].ShapeInfo.BoxLength*2/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_722 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2060311,
		CancelBlockMove = 1,
		PassiveEffects = T.RT_717,
		SkillDescKeys = T.RT_720,
		SkillDescValues = T.RT_721,
		SkillGrade = T.RT_2,
		SkillId = 2060301,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_723 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2060321,
		CancelBlockMove = 1,
		ClientSkillLogicId = 2060301,
		SkillGrade = T.RT_2,
		SkillId = 2060302,
		SkillLevel = T.RT_3,
		SkillType = "HeavyShooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_724 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2060511,
		CancelBlockMove = 1,
		SkillGrade = T.RT_2,
		SkillId = 2060501,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_725 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2060521,
		CancelBlockMove = 1,
		PassiveEffects = T.RT_700,
		SkillGrade = T.RT_2,
		SkillId = 2060502,
		SkillLevel = T.RT_3,
		SkillType = "HeavyShooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_726 = {
		[1] = "SKILL_DESC_BullutDamage",
		[2] = "SKILL_DESC_BullutDamage2",
		[3] = "SKILL_DESC_BullutWidth",
		[4] = "SKILL_DESC_BullutWidth2",
	}
T.RT_727 = {
		[1] = "$#SkillEffects[2069912].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[2069922].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillCreature[2069911].ShapeInfo.BoxHeight*2/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillCreature[2069921].ShapeInfo.BoxHeight*2/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_728 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2069911,
		CancelBlockMove = 1,
		SkillDescKeys = T.RT_726,
		SkillDescValues = T.RT_727,
		SkillGrade = T.RT_2,
		SkillId = 2069901,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_729 = {
		AllowEightOrient = "Default",
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 2069921,
		CancelBlockMove = 1,
		PassiveEffects = T.RT_700,
		SkillGrade = T.RT_2,
		SkillId = 2069902,
		SkillLevel = T.RT_3,
		SkillType = "HeavyShooting",
		SkillWeaponType = "Ranged",
		bEnablePrediction = true,
	}
T.RT_730 = {
		210001,
	}
T.RT_731 = {
		[1] = "$#Buff[210002].AddAttrs[1].Rate*100$%",
	}
T.RT_732 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_730,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_210001_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_731,
		SkillGrade = T.RT_2,
		SkillId = 210001,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_210001_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_733 = {
		[0] = T.RT_732,
		[1] = T.RT_732,
		[2] = T.RT_732,
		[3] = T.RT_732,
		[4] = T.RT_732,
		[5] = T.RT_732,
		[6] = T.RT_732,
	}
T.RT_734 = {
		210003,
	}
T.RT_735 = {
		[1] = "$#Buff[210004].AddAttrs[1].Rate*100$%",
	}
T.RT_736 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_734,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_210003_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_735,
		SkillGrade = T.RT_2,
		SkillId = 210003,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_210003_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_737 = {
		[0] = T.RT_736,
		[1] = T.RT_736,
		[2] = T.RT_736,
		[3] = T.RT_736,
		[4] = T.RT_736,
		[5] = T.RT_736,
		[6] = T.RT_736,
	}
T.RT_738 = {
		"Term_2101_Summon",
	}
T.RT_739 = {
		[1] = T.RT_167,
		[2] = T.RT_230,
		[3] = T.RT_168,
		[4] = T.RT_169,
	}
T.RT_740 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SummonedSustain",
		[3] = "SKILL_DESC_SummonedDamage",
		[4] = "SKILL_DESC_SummonedDamageRadius",
	}
T.RT_741 = {
		[1] = "$#SkillNode[210111].CostSp$",
		[2] = "$#SkillEffects[210111].TaskEffects[1].LifeTime$$GText(\"SKILL_DESC_Second\")$",
		[3] = "$#SkillEffects[210112].TaskEffects[1].Rate*100$%",
		[4] = "$#TargetFilter[#SkillEffects[210112].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_742 = {
		0,
		1,
	}
T.RT_743 = {
		210112,
	}
T.RT_744 = {
		BeginNodeId = 210111,
		ExplanationId = T.RT_738,
		LongPressSkill = 210112,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Shuimu_Skill01",
		SkillDesc = "SKILL_210101_DESC",
		SkillDescHints = T.RT_739,
		SkillDescKeys = T.RT_740,
		SkillDescValues = T.RT_741,
		SkillGrade = T.RT_742,
		SkillId = 210101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_210101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_743,
		bEnablePrediction = true,
	}
T.RT_745 = {
		2,
		3,
		4,
		5,
		6,
	}
T.RT_746 = {
		BeginNodeId = 210113,
		ExplanationId = T.RT_738,
		LongPressSkill = 210112,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Shuimu_Skill01",
		SkillDesc = "SKILL_210101_DESC",
		SkillDescHints = T.RT_739,
		SkillDescKeys = T.RT_740,
		SkillDescValues = T.RT_741,
		SkillGrade = T.RT_745,
		SkillId = 210101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_210101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_743,
		bEnablePrediction = true,
	}
T.RT_747 = {
		[0] = T.RT_744,
		[1] = T.RT_744,
		[2] = T.RT_746,
		[3] = T.RT_746,
		[4] = T.RT_746,
		[5] = T.RT_746,
		[6] = T.RT_746,
	}
T.RT_748 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_168,
		[4] = T.RT_169,
	}
T.RT_749 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_2101Skill02",
		[4] = "SKILL_DESC_DamageRadius",
	}
T.RT_750 = {
		[1] = "$#SkillNode[210121].CostSp$",
		[2] = "$#SkillEffects[210121].TaskEffects[1].Rate*100$%",
		[3] = "$#PassiveEffect[210101].Vars.Skill2ExDamegeRate*100$%",
		[4] = "$#TargetFilter[#SkillEffects[210123].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_751 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 210121,
		CD = 3.5,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Shuimu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Shuimu_Skill02",
		SkillDesc = "SKILL_210102_DESC",
		SkillDescHints = T.RT_748,
		SkillDescKeys = T.RT_749,
		SkillDescValues = T.RT_750,
		SkillGrade = T.RT_2,
		SkillId = 210102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_210102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_752 = {
		[0] = T.RT_751,
		[1] = T.RT_751,
		[2] = T.RT_751,
		[3] = T.RT_751,
		[4] = T.RT_751,
		[5] = T.RT_751,
		[6] = T.RT_751,
	}
T.RT_753 = {
		"Term_2101_Dot",
	}
T.RT_754 = {
		210101,
	}
T.RT_755 = {
		[1] = T.RT_230,
		[2] = T.RT_168,
		[3] = T.RT_169,
	}
T.RT_756 = {
		[1] = "SKILL_DESC_2101DotSustain",
		[2] = "SKILL_DESC_2101DotDamage",
		[3] = "SKILL_DESC_2101DotRadius",
	}
T.RT_757 = {
		[1] = "$#PassiveEffect[210101].Vars.LastTime$$GText(\"SKILL_DESC_Second\")$",
		[2] = "$(#Buff[210101].DotDatas[1].Rate)*100$%",
		[3] = "$#TargetFilter[\"Char_Cylinder_Large\"].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_758 = {
		ExplanationId = T.RT_753,
		PassiveEffects = T.RT_754,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Shuimu03",
		SkillDesc = "SKILL_210103_DESC",
		SkillDescHints = T.RT_755,
		SkillDescKeys = T.RT_756,
		SkillDescValues = T.RT_757,
		SkillGrade = T.RT_2,
		SkillId = 210103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_210103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_759 = {
		[0] = T.RT_758,
		[1] = T.RT_758,
		[2] = T.RT_758,
		[3] = T.RT_758,
		[4] = T.RT_758,
		[5] = T.RT_758,
		[6] = T.RT_758,
	}
T.RT_760 = {
		210103,
	}
T.RT_761 = {
		[1] = "$#PassiveEffect[210103].Vars.TriggerProb*100$%",
	}
T.RT_762 = {
		PassiveEffects = T.RT_760,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_210104_DESC",
		SkillDescKeys = T.RT_256,
		SkillDescValues = T.RT_761,
		SkillGrade = T.RT_2,
		SkillId = 210104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_210104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_763 = {
		[0] = T.RT_762,
		[1] = T.RT_762,
		[2] = T.RT_762,
		[3] = T.RT_762,
		[4] = T.RT_762,
		[5] = T.RT_762,
		[6] = T.RT_762,
	}
T.RT_764 = {
		210105,
	}
T.RT_765 = {
		[1] = "$#PassiveEffect[210151].Vars.DamageRate*100$%",
		[2] = "$#PassiveEffect[210151].Vars.BuffRate*100$%",
		[3] = "$#Buff[210161].AddAttrs[1].Value*100$%",
	}
T.RT_766 = {
		PassiveEffects = T.RT_764,
		SkillDesc = "SKILL_210105_DESC",
		SkillDescValues = T.RT_765,
		SkillGrade = T.RT_2,
		SkillId = 210105,
		SkillLevel = T.RT_8,
		SkillType = "UltraPassive",
		bEnablePrediction = true,
	}
T.RT_767 = {
		[0] = T.RT_766,
		[1] = T.RT_766,
		[2] = T.RT_766,
		[3] = T.RT_766,
		[4] = T.RT_766,
		[5] = T.RT_766,
		[6] = T.RT_766,
	}
T.RT_768 = {
		AllowSkillIntensity = true,
		BeginNodeId = 210112,
		SkillGrade = T.RT_742,
		SkillId = 210111,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		bEnablePrediction = true,
	}
T.RT_769 = {
		AllowSkillIntensity = true,
		BeginNodeId = 210114,
		SkillGrade = T.RT_745,
		SkillId = 210111,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		bEnablePrediction = true,
	}
T.RT_770 = {
		[0] = T.RT_768,
		[1] = T.RT_768,
		[2] = T.RT_769,
		[3] = T.RT_769,
		[4] = T.RT_769,
		[5] = T.RT_769,
		[6] = T.RT_769,
	}
T.RT_771 = {
		AllowEightOrient = "OnlyLockOrient",
		BeginNodeId = 210115,
		SkillDemo = "Shuimu_Skill01",
		SkillGrade = T.RT_742,
		SkillId = 210112,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_772 = {
		AllowEightOrient = "OnlyLockOrient",
		BeginNodeId = 210116,
		SkillDemo = "Shuimu_Skill01",
		SkillGrade = T.RT_745,
		SkillId = 210112,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_773 = {
		[0] = T.RT_771,
		[1] = T.RT_771,
		[2] = T.RT_772,
		[3] = T.RT_772,
		[4] = T.RT_772,
		[5] = T.RT_772,
		[6] = T.RT_772,
	}
T.RT_774 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 210211,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillDemo = "Shuimu_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 210201,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_775 = {
		[0] = T.RT_774,
		[1] = T.RT_774,
		[2] = T.RT_774,
		[3] = T.RT_774,
		[4] = T.RT_774,
		[5] = T.RT_774,
		[6] = T.RT_774,
	}
T.RT_776 = {
		210221,
	}
T.RT_777 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 210221,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillBtnStyle = "Switch",
		SkillDemo = "Shuimu_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 210202,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_776,
		bEnablePrediction = true,
	}
T.RT_778 = {
		[0] = T.RT_777,
		[1] = T.RT_777,
		[2] = T.RT_777,
		[3] = T.RT_777,
		[4] = T.RT_777,
		[5] = T.RT_777,
		[6] = T.RT_777,
	}
T.RT_779 = {
		210201,
	}
T.RT_780 = {
		PassiveEffects = T.RT_779,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Shuimu03",
		SkillGrade = T.RT_2,
		SkillId = 210203,
		SkillLevel = T.RT_8,
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_781 = {
		[0] = T.RT_780,
		[1] = T.RT_780,
		[2] = T.RT_780,
		[3] = T.RT_780,
		[4] = T.RT_780,
		[5] = T.RT_780,
		[6] = T.RT_780,
	}
T.RT_782 = {
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillGrade = T.RT_2,
		SkillId = 210204,
		SkillLevel = T.RT_8,
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_783 = {
		[0] = T.RT_782,
		[1] = T.RT_782,
		[2] = T.RT_782,
		[3] = T.RT_782,
		[4] = T.RT_782,
		[5] = T.RT_782,
		[6] = T.RT_782,
	}
T.RT_784 = {
		BeginNodeId = 210213,
		SkillGrade = T.RT_2,
		SkillId = 210211,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_785 = {
		[0] = T.RT_784,
		[1] = T.RT_784,
		[2] = T.RT_784,
		[3] = T.RT_784,
		[4] = T.RT_784,
		[5] = T.RT_784,
		[6] = T.RT_784,
	}
T.RT_786 = {
		BeginNodeId = 210214,
		SkillGrade = T.RT_2,
		SkillId = 210212,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_787 = {
		[0] = T.RT_786,
		[1] = T.RT_786,
		[2] = T.RT_786,
		[3] = T.RT_786,
		[4] = T.RT_786,
		[5] = T.RT_786,
		[6] = T.RT_786,
	}
T.RT_788 = {
		BeginNodeId = 210215,
		SkillGrade = T.RT_2,
		SkillId = 210213,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_789 = {
		[0] = T.RT_788,
		[1] = T.RT_788,
		[2] = T.RT_788,
		[3] = T.RT_788,
		[4] = T.RT_788,
		[5] = T.RT_788,
		[6] = T.RT_788,
	}
T.RT_790 = {
		BeginNodeId = 210216,
		SkillGrade = T.RT_2,
		SkillId = 210214,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_791 = {
		[0] = T.RT_790,
		[1] = T.RT_790,
		[2] = T.RT_790,
		[3] = T.RT_790,
		[4] = T.RT_790,
		[5] = T.RT_790,
		[6] = T.RT_790,
	}
T.RT_792 = {
		BeginNodeId = 210217,
		SkillGrade = T.RT_2,
		SkillId = 210215,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_793 = {
		[0] = T.RT_792,
		[1] = T.RT_792,
		[2] = T.RT_792,
		[3] = T.RT_792,
		[4] = T.RT_792,
		[5] = T.RT_792,
		[6] = T.RT_792,
	}
T.RT_794 = {
		210222,
	}
T.RT_795 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 210222,
		CombatConditionID = 210203,
		LongPressSkill = 210222,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillBtnStyle = "Switch",
		SkillDemo = "Shuimu_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 210221,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_794,
		bEnablePrediction = true,
	}
T.RT_796 = {
		[0] = T.RT_795,
		[1] = T.RT_795,
		[2] = T.RT_795,
		[3] = T.RT_795,
		[4] = T.RT_795,
		[5] = T.RT_795,
		[6] = T.RT_795,
	}
T.RT_797 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 210223,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillDemo = "Shuimu_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 210222,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_798 = {
		[0] = T.RT_797,
		[1] = T.RT_797,
		[2] = T.RT_797,
		[3] = T.RT_797,
		[4] = T.RT_797,
		[5] = T.RT_797,
		[6] = T.RT_797,
	}
T.RT_799 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 210231,
		SkillGrade = T.RT_2,
		SkillId = 210231,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_800 = {
		[0] = T.RT_799,
		[1] = T.RT_799,
		[2] = T.RT_799,
		[3] = T.RT_799,
		[4] = T.RT_799,
		[5] = T.RT_799,
		[6] = T.RT_799,
	}
T.RT_801 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 210232,
		SkillGrade = T.RT_2,
		SkillId = 210232,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_802 = {
		[0] = T.RT_801,
		[1] = T.RT_801,
		[2] = T.RT_801,
		[3] = T.RT_801,
		[4] = T.RT_801,
		[5] = T.RT_801,
		[6] = T.RT_801,
	}
T.RT_803 = {
		AllowUseSkillInAir = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Shuimu02",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 210302,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_804 = {
		[0] = T.RT_803,
		[1] = T.RT_803,
		[2] = T.RT_803,
		[3] = T.RT_803,
		[4] = T.RT_803,
		[5] = T.RT_803,
		[6] = T.RT_803,
	}
T.RT_805 = {
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Shuimu03",
		SkillGrade = T.RT_2,
		SkillId = 210303,
		SkillLevel = T.RT_8,
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_806 = {
		[0] = T.RT_805,
		[1] = T.RT_805,
		[2] = T.RT_805,
		[3] = T.RT_805,
		[4] = T.RT_805,
		[5] = T.RT_805,
		[6] = T.RT_805,
	}
T.RT_807 = {
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillGrade = T.RT_2,
		SkillId = 210304,
		SkillLevel = T.RT_8,
		SkillType = "ExtraPassive",
		bEnablePrediction = true,
	}
T.RT_808 = {
		[0] = T.RT_807,
		[1] = T.RT_807,
		[2] = T.RT_807,
		[3] = T.RT_807,
		[4] = T.RT_807,
		[5] = T.RT_807,
		[6] = T.RT_807,
	}
T.RT_809 = {
		AllowUseSkillInAir = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 210311,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_810 = {
		[0] = T.RT_809,
		[1] = T.RT_809,
		[2] = T.RT_809,
		[3] = T.RT_809,
		[4] = T.RT_809,
		[5] = T.RT_809,
		[6] = T.RT_809,
	}
T.RT_811 = {
		AllowUseSkillInAir = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 210312,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_812 = {
		[0] = T.RT_811,
		[1] = T.RT_811,
		[2] = T.RT_811,
		[3] = T.RT_811,
		[4] = T.RT_811,
		[5] = T.RT_811,
		[6] = T.RT_811,
	}
T.RT_813 = {
		SkillBtnIcon = "Skill_Shuimu01",
		SkillGrade = T.RT_2,
		SkillId = 210313,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_814 = {
		[0] = T.RT_813,
		[1] = T.RT_813,
		[2] = T.RT_813,
		[3] = T.RT_813,
		[4] = T.RT_813,
		[5] = T.RT_813,
		[6] = T.RT_813,
	}
T.RT_815 = {
		AllowUseSkillInAir = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 210314,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_816 = {
		[0] = T.RT_815,
		[1] = T.RT_815,
		[2] = T.RT_815,
		[3] = T.RT_815,
		[4] = T.RT_815,
		[5] = T.RT_815,
		[6] = T.RT_815,
	}
T.RT_817 = {
		AllowUseSkillInAir = true,
		SkillBtnIcon = "Skill_Shuimu01",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 210315,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_818 = {
		[0] = T.RT_817,
		[1] = T.RT_817,
		[2] = T.RT_817,
		[3] = T.RT_817,
		[4] = T.RT_817,
		[5] = T.RT_817,
		[6] = T.RT_817,
	}
T.RT_819 = {
		AllowUseSkillInAir = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Shuimu01",
		SkillGrade = T.RT_2,
		SkillId = 210316,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_820 = {
		[0] = T.RT_819,
		[1] = T.RT_819,
		[2] = T.RT_819,
		[3] = T.RT_819,
		[4] = T.RT_819,
		[5] = T.RT_819,
		[6] = T.RT_819,
	}
T.RT_821 = {
		AllowUseSkillInAir = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Shuimu02",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 210321,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_822 = {
		[0] = T.RT_821,
		[1] = T.RT_821,
		[2] = T.RT_821,
		[3] = T.RT_821,
		[4] = T.RT_821,
		[5] = T.RT_821,
		[6] = T.RT_821,
	}
T.RT_823 = {
		AllowUseSkillInAir = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Shuimu02",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 210322,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_824 = {
		[0] = T.RT_823,
		[1] = T.RT_823,
		[2] = T.RT_823,
		[3] = T.RT_823,
		[4] = T.RT_823,
		[5] = T.RT_823,
		[6] = T.RT_823,
	}
T.RT_825 = {
		SkillGrade = T.RT_2,
		SkillId = 210323,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_826 = {
		[0] = T.RT_825,
		[1] = T.RT_825,
		[2] = T.RT_825,
		[3] = T.RT_825,
		[4] = T.RT_825,
		[5] = T.RT_825,
		[6] = T.RT_825,
	}
T.RT_827 = {
		SkillGrade = T.RT_2,
		SkillId = 210324,
		SkillLevel = T.RT_8,
		SkillType = "Shooting",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_828 = {
		[0] = T.RT_827,
		[1] = T.RT_827,
		[2] = T.RT_827,
		[3] = T.RT_827,
		[4] = T.RT_827,
		[5] = T.RT_827,
		[6] = T.RT_827,
	}
T.RT_829 = {
		AllowUseSkillInAir = true,
		SkillGrade = T.RT_2,
		SkillId = 210325,
		SkillLevel = T.RT_8,
		SkillType = "FallAttack",
		bEnablePrediction = true,
	}
T.RT_830 = {
		[0] = T.RT_829,
		[1] = T.RT_829,
		[2] = T.RT_829,
		[3] = T.RT_829,
		[4] = T.RT_829,
		[5] = T.RT_829,
		[6] = T.RT_829,
	}
T.RT_831 = {
		SkillGrade = T.RT_2,
		SkillId = 210326,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_832 = {
		[0] = T.RT_831,
		[1] = T.RT_831,
		[2] = T.RT_831,
		[3] = T.RT_831,
		[4] = T.RT_831,
		[5] = T.RT_831,
		[6] = T.RT_831,
	}
T.RT_833 = {
		SkillGrade = T.RT_2,
		SkillId = 210331,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_834 = {
		[0] = T.RT_833,
		[1] = T.RT_833,
		[2] = T.RT_833,
		[3] = T.RT_833,
		[4] = T.RT_833,
		[5] = T.RT_833,
		[6] = T.RT_833,
	}
T.RT_835 = {
		[1] = T.RT_167,
		[4] = T.RT_230,
	}
T.RT_836 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_2301Rate",
		[3] = "SKILL_DESC_SkillDmgUp",
		[4] = "SKILL_DESC_SkillDmgUpTime",
	}
T.RT_837 = {
		[1] = "$#SkillNode[230111].CostSp$",
		[2] = "$#PassiveEffect[230101].Vars.Skill1BuffRate*100$%",
		[3] = "$#Buff[230101].AddAttrs[1].Value*100$%",
		[4] = "$#SkillEffects[230112].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_838 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 230111,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Zhangyu01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhangyu_Skill01",
		SkillDesc = "SKILL_230101_DESC",
		SkillDescHints = T.RT_835,
		SkillDescKeys = T.RT_836,
		SkillDescValues = T.RT_837,
		SkillGrade = T.RT_2,
		SkillId = 230101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_230101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
	}
T.RT_839 = {
		[0] = T.RT_838,
		[1] = T.RT_838,
		[2] = T.RT_838,
		[3] = T.RT_838,
		[4] = T.RT_838,
		[5] = T.RT_838,
		[6] = T.RT_838,
	}
T.RT_840 = {
		"Term_2301_Summon",
	}
T.RT_841 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_230,
	}
T.RT_842 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SummonedDamage",
		[3] = "SKILL_DESC_SummonedSustain",
	}
T.RT_843 = {
		[1] = "$#SkillNode[230121].CostSp$",
		[2] = "$#SkillEffects[230133].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[230121].TaskEffects[1].LifeTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_844 = {
		0,
	}
T.RT_845 = {
		BeginNodeId = 230121,
		CD = 3,
		ExplanationId = T.RT_840,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Zhangyu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhangyu_Skill02",
		SkillDesc = "SKILL_230102_DESC",
		SkillDescHints = T.RT_841,
		SkillDescKeys = T.RT_842,
		SkillDescValues = T.RT_843,
		SkillGrade = T.RT_844,
		SkillId = 230102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_230102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
	}
T.RT_846 = {
		1,
		2,
		3,
		4,
		5,
		6,
	}
T.RT_847 = {
		BeginNodeId = 230122,
		CD = 3,
		ExplanationId = T.RT_840,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Zhangyu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhangyu_Skill02",
		SkillDesc = "SKILL_230102_DESC",
		SkillDescHints = T.RT_841,
		SkillDescKeys = T.RT_842,
		SkillDescValues = T.RT_843,
		SkillGrade = T.RT_846,
		SkillId = 230102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_230102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
	}
T.RT_848 = {
		[0] = T.RT_845,
		[1] = T.RT_847,
		[2] = T.RT_847,
		[3] = T.RT_847,
		[4] = T.RT_847,
		[5] = T.RT_847,
		[6] = T.RT_847,
	}
T.RT_849 = {
		230101,
	}
T.RT_850 = {
		[2] = T.RT_168,
		[3] = T.RT_230,
	}
T.RT_851 = {
		[1] = "SKILL_DESC_TriggerProb",
		[2] = "SKILL_DESC_SummonedDamage",
		[3] = "SKILL_DESC_SummonedSustain",
	}
T.RT_852 = {
		[1] = "$#PassiveEffect[230101].Vars.TriggerProb*100$%",
		[2] = "$#SkillEffects[230133].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[230131].TaskEffects[1].LifeTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_853 = {
		ExplanationId = T.RT_840,
		PassiveEffects = T.RT_849,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Zhangyu03",
		SkillDesc = "SKILL_230103_DESC",
		SkillDescHints = T.RT_850,
		SkillDescKeys = T.RT_851,
		SkillDescValues = T.RT_852,
		SkillGrade = T.RT_2,
		SkillId = 230103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_230103_NAME",
		SkillType = "Passive",
	}
T.RT_854 = {
		[0] = T.RT_853,
		[1] = T.RT_853,
		[2] = T.RT_853,
		[3] = T.RT_853,
		[4] = T.RT_853,
		[5] = T.RT_853,
		[6] = T.RT_853,
	}
T.RT_855 = {
		230103,
	}
T.RT_856 = {
		[1] = "SKILL_DESC_CriUpLayer",
		[2] = "SKILL_DESC_Sustain",
	}
T.RT_857 = {
		[1] = "$#Buff[230103].AddAttrs[1].Value*100$%",
		[2] = "$#PassiveEffect[230103].Vars.ExtraBuffLastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_858 = {
		PassiveEffects = T.RT_855,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_230104_DESC",
		SkillDescHints = T.RT_587,
		SkillDescKeys = T.RT_856,
		SkillDescValues = T.RT_857,
		SkillGrade = T.RT_2,
		SkillId = 230104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_230104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
	}
T.RT_859 = {
		[0] = T.RT_858,
		[1] = T.RT_858,
		[2] = T.RT_858,
		[3] = T.RT_858,
		[4] = T.RT_858,
		[5] = T.RT_858,
		[6] = T.RT_858,
	}
T.RT_860 = {
		AllowSkillIntensity = true,
		BeginNodeId = 230131,
		CD = 4,
		CDType = 230131,
		SkillGrade = T.RT_2,
		SkillId = 230131,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
	}
T.RT_861 = {
		[0] = T.RT_860,
		[1] = T.RT_860,
		[2] = T.RT_860,
		[3] = T.RT_860,
		[4] = T.RT_860,
		[5] = T.RT_860,
		[6] = T.RT_860,
	}
T.RT_862 = {
		230102,
	}
T.RT_863 = {
		AllowSkillIntensity = true,
		BeginNodeId = 230132,
		CD = 4,
		CDType = 230131,
		PassiveEffects = T.RT_862,
		SkillGrade = T.RT_2,
		SkillId = 230132,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
	}
T.RT_864 = {
		[0] = T.RT_863,
		[1] = T.RT_863,
		[2] = T.RT_863,
		[3] = T.RT_863,
		[4] = T.RT_863,
		[5] = T.RT_863,
		[6] = T.RT_863,
	}
T.RT_865 = {
		"Term_2401_Summon",
	}
T.RT_866 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_230,
		[5] = T.RT_168,
	}
T.RT_867 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SummonedDamage",
		[3] = "SKILL_DESC_SummonedEffectRadius",
		[4] = "SKILL_DESC_SummonedSustain",
		[5] = "SKILL_DESC_SummonedHeal",
		[6] = "SKILL_DESC_SpIncrease",
	}
T.RT_868 = {
		[1] = "$#SkillNode[240111].CostSp$",
		[2] = "$#SkillEffects[240141].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[240141].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[240111].TaskEffects[1].LifeTime$$GText(\"SKILL_DESC_Second\")$",
		[5] = "$#SkillEffects[240103].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_ATK\")$+$#SkillEffects[240103].TaskEffects[1].Value$",
		[6] = "$#SkillEffects[240103].TaskEffects[2].SpChange$",
	}
T.RT_869 = {
		240111,
	}
T.RT_870 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 240111,
		ExplanationId = T.RT_865,
		LongPressSkill = 240111,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Baiheng01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Baiheng_Skill01",
		SkillDesc = "SKILL_240101_DESC",
		SkillDescHints = T.RT_866,
		SkillDescKeys = T.RT_867,
		SkillDescValues = T.RT_868,
		SkillGrade = T.RT_742,
		SkillId = 240101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_240101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_869,
		bEnablePrediction = true,
	}
T.RT_871 = {
		[1] = "$#SkillNode[240112].CostSp$",
		[2] = "$#SkillEffects[240141].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[240141].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[240112].TaskEffects[1].LifeTime$$GText(\"SKILL_DESC_Second\")$",
		[5] = "$#SkillEffects[240103].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_ATK\")$+$#SkillEffects[240103].TaskEffects[1].Value$",
		[6] = "$#SkillEffects[240103].TaskEffects[2].SpChange$",
	}
T.RT_872 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 240112,
		ExplanationId = T.RT_865,
		LongPressSkill = 240111,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Baiheng01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Baiheng_Skill01",
		SkillDesc = "SKILL_240101_DESC",
		SkillDescHints = T.RT_866,
		SkillDescKeys = T.RT_867,
		SkillDescValues = T.RT_871,
		SkillGrade = T.RT_745,
		SkillId = 240101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_240101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_869,
		bEnablePrediction = true,
	}
T.RT_873 = {
		[0] = T.RT_870,
		[1] = T.RT_870,
		[2] = T.RT_872,
		[3] = T.RT_872,
		[4] = T.RT_872,
		[5] = T.RT_872,
		[6] = T.RT_872,
	}
T.RT_874 = {
		"Term_2401_Skill02Buff",
	}
T.RT_875 = {
		7,
		8,
		9,
	}
T.RT_876 = {
		SKILL_SECTIONDESC_2401_Skill02_01 = T.RT_875,
	}
T.RT_877 = {
		[1] = T.RT_876,
	}
T.RT_878 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_168,
		[6] = T.RT_230,
		[9] = T.RT_230,
	}
T.RT_879 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_2401Skill02Damage",
		[3] = "SKILL_DESC_2401Skill02DamageRadius",
		[4] = "SKILL_DESC_OverES",
		[5] = "SKILL_DESC_AtkSpeedUp",
		[6] = "SKILL_DESC_AtkSpeedUpTime",
		[7] = "SKILL_DESC_2401Skill02SkillIntensityRate",
		[8] = "SKILL_DESC_2401MaxSkill02SkillIntensity",
		[9] = "SKILL_DESC_2401Skill02BuffSustain",
	}
T.RT_880 = {
		[1] = "$#SkillNode[240121].CostSp$",
		[2] = "$#SkillEffects[240123].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[240123].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[240121].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_ATK\")$+$#SkillEffects[240121].TaskEffects[1].Value$",
		[5] = "$math.abs(#Buff[240123].AddAttrs[1].Value)*100$%",
		[6] = "$#SkillEffects[240122].TaskEffects[3].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[7] = "$#PassiveEffect[240101].Vars.SkillIntensityRate*100$%$GText(\"SKILL_DESC_SkillIntensity\")$",
		[8] = "$#Buff[240121].AddAttrs[1].SupLimitRate*100$%",
		[9] = "$#PassiveEffect[240101].Vars.Skill02Time$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_881 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 240121,
		CD = 2.4,
		ExplanationId = T.RT_874,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Baiheng02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Baiheng_Skill02",
		SkillDesc = "SKILL_240102_DESC",
		SkillDescGroups = T.RT_877,
		SkillDescHints = T.RT_878,
		SkillDescKeys = T.RT_879,
		SkillDescValues = T.RT_880,
		SkillGrade = T.RT_2,
		SkillId = 240102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_240102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_882 = {
		[0] = T.RT_881,
		[1] = T.RT_881,
		[2] = T.RT_881,
		[3] = T.RT_881,
		[4] = T.RT_881,
		[5] = T.RT_881,
		[6] = T.RT_881,
	}
T.RT_883 = {
		240101,
	}
T.RT_884 = {
		[1] = "SKILL_DESC_SkillSpeedUpLayer",
		[2] = "SKILL_DESC_SkillSpeedUpTime",
	}
T.RT_885 = {
		[1] = "$#Buff[240133].AddAttrs[1].Rate*100$%",
		[2] = "$#PassiveEffect[240103].Vars.Time$",
	}
T.RT_886 = {
		PassiveEffects = T.RT_883,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Baiheng03",
		SkillBtnStyle = "Common_Btn",
		SkillDesc = "SKILL_240103_DESC",
		SkillDescHints = T.RT_587,
		SkillDescKeys = T.RT_884,
		SkillDescValues = T.RT_885,
		SkillGrade = T.RT_2,
		SkillId = 240103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_240103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_887 = {
		[0] = T.RT_886,
		[1] = T.RT_886,
		[2] = T.RT_886,
		[3] = T.RT_886,
		[4] = T.RT_886,
		[5] = T.RT_886,
		[6] = T.RT_886,
	}
T.RT_888 = {
		240105,
	}
T.RT_889 = {
		[1] = "SKILL_DESC_SkillIntenUp",
	}
T.RT_890 = {
		[1] = "$#Buff[240141].AddAttrs[1].Rate*100$%$GText(\"SKILL_DESC_2401PassiveBase\")$",
	}
T.RT_891 = {
		PassiveEffects = T.RT_888,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_240104_DESC",
		SkillDescKeys = T.RT_889,
		SkillDescValues = T.RT_890,
		SkillGrade = T.RT_2,
		SkillId = 240104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_240104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_892 = {
		[0] = T.RT_891,
		[1] = T.RT_891,
		[2] = T.RT_891,
		[3] = T.RT_891,
		[4] = T.RT_891,
		[5] = T.RT_891,
		[6] = T.RT_891,
	}
T.RT_893 = {
		AllowEightOrient = "OnlyLockOrient",
		BeginNodeId = 240113,
		ExplanationId = T.RT_865,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Baiheng01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Baiheng_Skill01",
		SkillGrade = T.RT_742,
		SkillId = 240111,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_240101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_894 = {
		AllowEightOrient = "OnlyLockOrient",
		BeginNodeId = 240114,
		ExplanationId = T.RT_865,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Baiheng01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Baiheng_Skill01",
		SkillGrade = T.RT_745,
		SkillId = 240111,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_240101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_895 = {
		[0] = T.RT_893,
		[1] = T.RT_893,
		[2] = T.RT_894,
		[3] = T.RT_894,
		[4] = T.RT_894,
		[5] = T.RT_894,
		[6] = T.RT_894,
	}
T.RT_896 = {
		240102,
	}
T.RT_897 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		PassiveEffects = T.RT_896,
		SkillGrade = T.RT_2,
		SkillId = 240131,
		SkillLevel = T.RT_8,
		bEnablePrediction = true,
	}
T.RT_898 = {
		[0] = T.RT_897,
		[1] = T.RT_897,
		[2] = T.RT_897,
		[3] = T.RT_897,
		[4] = T.RT_897,
		[5] = T.RT_897,
		[6] = T.RT_897,
	}
T.RT_899 = {
		240191,
	}
T.RT_900 = {
		[1] = "$#Buff[240192].AddAttrs[1].Value*100$%",
	}
T.RT_901 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_899,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_240191_DESC",
		SkillDescKeys = T.RT_12,
		SkillDescValues = T.RT_900,
		SkillGrade = T.RT_2,
		SkillId = 240191,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_240191_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_902 = {
		[0] = T.RT_901,
		[1] = T.RT_901,
		[2] = T.RT_901,
		[3] = T.RT_901,
		[4] = T.RT_901,
		[5] = T.RT_901,
		[6] = T.RT_901,
	}
T.RT_903 = {
		BeginNodeId = 30,
		SkillGrade = T.RT_2,
		SkillId = 30,
		SkillLevel = T.RT_3,
		SkillType = "Condemn",
		SkillWeaponType = "Condemn",
	}
T.RT_904 = {
		310001,
	}
T.RT_905 = {
		[1] = "$#Buff[310002].AddAttrs[1].Rate*100$%",
	}
T.RT_906 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_904,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_310001_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_905,
		SkillGrade = T.RT_2,
		SkillId = 310001,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310001_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_907 = {
		[0] = T.RT_906,
		[1] = T.RT_906,
		[2] = T.RT_906,
		[3] = T.RT_906,
		[4] = T.RT_906,
		[5] = T.RT_906,
		[6] = T.RT_906,
	}
T.RT_908 = {
		310003,
	}
T.RT_909 = {
		[1] = "$#Buff[310004].AddAttrs[1].Rate*100$%",
	}
T.RT_910 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_908,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_310003_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_909,
		SkillGrade = T.RT_2,
		SkillId = 310003,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310003_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_911 = {
		[0] = T.RT_910,
		[1] = T.RT_910,
		[2] = T.RT_910,
		[3] = T.RT_910,
		[4] = T.RT_910,
		[5] = T.RT_910,
		[6] = T.RT_910,
	}
T.RT_912 = {
		"Term_3101_Debuff",
	}
T.RT_913 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[5] = T.RT_168,
	}
T.RT_914 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_DamageRadius",
		[4] = "SKILL_DESC_3101WildFireTime",
		[5] = "SKILL_DESC_3101WildFireDamage",
		[6] = "SKILL_DESC_3101WildFireCountMax",
	}
T.RT_915 = {
		[1] = "$#SkillNode[310111].CostSp$",
		[2] = "$#SkillEffects[310111].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[310111].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[310111].TaskEffects[2].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[5] = "$#PassiveEffect[310111].Vars.WildFireRate*100$%",
		[6] = "$#PassiveEffect[310111].Vars.WildFireCountMax$",
	}
T.RT_916 = {
		310111,
	}
T.RT_917 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 310111,
		ExplanationId = T.RT_912,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Linen01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Linen_Skill01",
		SkillDesc = "SKILL_310101_DESC",
		SkillDescHints = T.RT_913,
		SkillDescKeys = T.RT_914,
		SkillDescValues = T.RT_915,
		SkillGrade = T.RT_2,
		SkillId = 310101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_916,
		bEnablePrediction = true,
	}
T.RT_918 = {
		[0] = T.RT_917,
		[1] = T.RT_917,
		[2] = T.RT_917,
		[3] = T.RT_917,
		[4] = T.RT_917,
		[5] = T.RT_917,
		[6] = T.RT_917,
	}
T.RT_919 = {
		[1] = T.RT_167,
		[2] = T.RT_176,
		[3] = T.RT_168,
		[4] = T.RT_169,
	}
T.RT_920 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SpChangeScd",
		[3] = "SKILL_DESC_ShootingDamage",
		[4] = "SKILL_DESC_MaxShootRange",
		[5] = "SKILL_DESC_AtkSpeedUpLayer",
	}
T.RT_921 = {
		[1] = "$#SkillNode[310121].CostSp$",
		[2] = "$math.abs(#Buff[310120].DotDatas[1].Value)$",
		[3] = "$#SkillEffects[310131].TaskEffects[1].Value*100$%",
		[4] = "$#TargetFilter[#SkillEffects[310131].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#Buff[310124].AddAttrs[1].Value*100$%",
	}
T.RT_922 = {
		310121,
	}
T.RT_923 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 310121,
		CD = 2.5,
		CDType = 310102,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Linen02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Linen_Skill02",
		SkillDesc = "SKILL_310102_DESC",
		SkillDescHints = T.RT_919,
		SkillDescKeys = T.RT_920,
		SkillDescValues = T.RT_921,
		SkillGrade = T.RT_742,
		SkillId = 310102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_922,
		bEnablePrediction = true,
	}
T.RT_924 = {
		[1] = "$#SkillNode[310121].CostSp$",
		[2] = "$math.abs(#Buff[310121].DotDatas[1].Value)$",
		[3] = "$#SkillEffects[310131].TaskEffects[1].Value*100$%",
		[4] = "$#TargetFilter[#SkillEffects[310131].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#Buff[310124].AddAttrs[1].Value*100$%",
	}
T.RT_925 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 310123,
		CD = 2.5,
		CDType = 310102,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Linen02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Linen_Skill02",
		SkillDesc = "SKILL_310102_DESC",
		SkillDescHints = T.RT_919,
		SkillDescKeys = T.RT_920,
		SkillDescValues = T.RT_924,
		SkillGrade = T.RT_745,
		SkillId = 310102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SkillWeaponType = "Ultra",
		SubSkills = T.RT_922,
		bEnablePrediction = true,
	}
T.RT_926 = {
		[0] = T.RT_923,
		[1] = T.RT_923,
		[2] = T.RT_925,
		[3] = T.RT_925,
		[4] = T.RT_925,
		[5] = T.RT_925,
		[6] = T.RT_925,
	}
T.RT_927 = {
		310101,
	}
T.RT_928 = {
		[1] = "SKILL_DESC_3103LastTime",
		[2] = "SKILL_DESC_DmgUpLayer",
	}
T.RT_929 = {
		[1] = "$#PassiveEffect[310101].Vars.BuffLastTime$$GText(\"SKILL_DESC_Second\")$",
		[2] = "$#PassiveEffect[310101].Vars.BuffRate*100$%",
	}
T.RT_930 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_927,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Linen03",
		SkillDesc = "SKILL_310103_DESC",
		SkillDescHints = T.RT_361,
		SkillDescKeys = T.RT_928,
		SkillDescValues = T.RT_929,
		SkillGrade = T.RT_2,
		SkillId = 310103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_931 = {
		[0] = T.RT_930,
		[1] = T.RT_930,
		[2] = T.RT_930,
		[3] = T.RT_930,
		[4] = T.RT_930,
		[5] = T.RT_930,
		[6] = T.RT_930,
	}
T.RT_932 = {
		310102,
	}
T.RT_933 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_932,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_310104_DESC",
		SkillGrade = T.RT_2,
		SkillId = 310104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_934 = {
		[0] = T.RT_933,
		[1] = T.RT_933,
		[2] = T.RT_933,
		[3] = T.RT_933,
		[4] = T.RT_933,
		[5] = T.RT_933,
		[6] = T.RT_933,
	}
T.RT_935 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 310112,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Linen01",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 310111,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_936 = {
		[0] = T.RT_935,
		[1] = T.RT_935,
		[2] = T.RT_935,
		[3] = T.RT_935,
		[4] = T.RT_935,
		[5] = T.RT_935,
		[6] = T.RT_935,
	}
T.RT_937 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 310122,
		CD = 2,
		CDType = 310102,
		CombatConditionID = 310120,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Linen02_Off",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 310121,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_938 = {
		[0] = T.RT_937,
		[1] = T.RT_937,
		[2] = T.RT_937,
		[3] = T.RT_937,
		[4] = T.RT_937,
		[5] = T.RT_937,
		[6] = T.RT_937,
	}
T.RT_939 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 310141,
		MaxHatred = 4,
		SkillGrade = T.RT_2,
		SkillId = 310122,
		SkillLevel = T.RT_8,
		SkillType = "Shooting",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_940 = {
		[0] = T.RT_939,
		[1] = T.RT_939,
		[2] = T.RT_939,
		[3] = T.RT_939,
		[4] = T.RT_939,
		[5] = T.RT_939,
		[6] = T.RT_939,
	}
T.RT_941 = {
		FuncName = "ExecuteSkill1_Start",
		Id = 310202,
	}
T.RT_942 = {
		310202,
	}
T.RT_943 = {
		[1] = T.RT_167,
		[2] = T.RT_176,
		[3] = T.RT_168,
	}
T.RT_944 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SpChangeScd",
		[3] = "SKILL_DESC_Damage",
		[4] = "SKILL_DESC_SpIncreaseProb",
		[5] = "SKILL_DESC_SpIncrease",
		[6] = "SKILL_DESC_3102Skill01LaserLength",
	}
T.RT_945 = {
		[1] = "$#Skill[310201][1][0].NotExecuteSpCost$",
		[2] = "$math.abs(#Buff[310204].DotDatas[1].Value)$",
		[3] = "$#SkillEffects[310216].TaskEffects[1].Rate*100$%",
		[4] = "$#PassiveEffect[310202].Vars.SpIncreaseProb*100$%",
		[5] = "$#PassiveEffect[310202].Vars.SpIncrease$",
		[6] = "$#PassiveEffect[310202].Vars.InfoLaserLength/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_946 = {
		310211,
	}
T.RT_947 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		CD = 1,
		CDType = 310201,
		ExecutePassiveFunc = T.RT_941,
		IgnoreTag = true,
		NotExecute = true,
		NotExecuteSpCost = 10,
		PassiveEffects = T.RT_942,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Xier01",
		SkillBtnStyle = "Switch",
		SkillDemo = "Xier_Skill01",
		SkillDesc = "SKILL_310201_DESC",
		SkillDescHints = T.RT_943,
		SkillDescKeys = T.RT_944,
		SkillDescValues = T.RT_945,
		SkillGrade = T.RT_2,
		SkillId = 310201,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310201_NAME",
		SkillType = "Skill1",
		SubSkills = T.RT_946,
		UseSkillCondition = 310202,
		bEnablePrediction = true,
	}
T.RT_948 = {
		[0] = T.RT_947,
		[1] = T.RT_947,
		[2] = T.RT_947,
		[3] = T.RT_947,
		[4] = T.RT_947,
		[5] = T.RT_947,
		[6] = T.RT_947,
	}
T.RT_949 = {
		"Term_3102_Debuff",
	}
T.RT_950 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_168,
		[5] = T.RT_168,
		[7] = T.RT_230,
	}
T.RT_951 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_DamageRadius",
		[4] = "SKILL_DESC_3102SmallFunnelDamage",
		[5] = "SKILL_DESC_3102BigFunnelDamage",
		[6] = "SKILL_DESC_3102Skill02FunnelRadius",
		[7] = "SKILL_DESC_3102Skill02FunnelLifeTime",
	}
T.RT_952 = {
		[1] = "$#SkillNode[310211].CostSp$",
		[2] = "$#SkillEffects[310203].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[310203].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[310218].TaskEffects[1].Rate*100$%",
		[5] = "$#SkillEffects[310212].TaskEffects[1].Rate*100$%",
		[6] = "$#TargetFilter[\"Xierda_Passive_Search\"].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[7] = "$#SkillEffects[310202].TaskEffects[1].LifeTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_953 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 310211,
		CD = 3.3,
		ExplanationId = T.RT_949,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Xier02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Xier_Skill02",
		SkillDesc = "SKILL_310202_DESC",
		SkillDescHints = T.RT_950,
		SkillDescKeys = T.RT_951,
		SkillDescValues = T.RT_952,
		SkillGrade = T.RT_2,
		SkillId = 310202,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310202_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_954 = {
		[0] = T.RT_953,
		[1] = T.RT_953,
		[2] = T.RT_953,
		[3] = T.RT_953,
		[4] = T.RT_953,
		[5] = T.RT_953,
		[6] = T.RT_953,
	}
T.RT_955 = {
		"Term_3102_Buff",
	}
T.RT_956 = {
		310201,
	}
T.RT_957 = {
		[1] = "SKILL_DESC_3102DodgeBuff",
		[2] = "SKILL_DESC_3102BuffLastTime",
	}
T.RT_958 = {
		[1] = "$#PassiveEffect[310201].Vars.IncreaseAttackSpeed*100$%",
		[2] = "$#PassiveEffect[310201].Vars.PassiveBuffLastTime$",
	}
T.RT_959 = {
		AllowSkillIntensity = true,
		ExplanationId = T.RT_955,
		PassiveEffects = T.RT_956,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Xier03",
		SkillDesc = "SKILL_310203_DESC",
		SkillDescHints = T.RT_587,
		SkillDescKeys = T.RT_957,
		SkillDescValues = T.RT_958,
		SkillGrade = T.RT_2,
		SkillId = 310203,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310203_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_960 = {
		[0] = T.RT_959,
		[1] = T.RT_959,
		[2] = T.RT_959,
		[3] = T.RT_959,
		[4] = T.RT_959,
		[5] = T.RT_959,
		[6] = T.RT_959,
	}
T.RT_961 = {
		310203,
	}
T.RT_962 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_961,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_310204_DESC",
		SkillGrade = T.RT_2,
		SkillId = 310204,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310204_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_963 = {
		[0] = T.RT_962,
		[1] = T.RT_962,
		[2] = T.RT_962,
		[3] = T.RT_962,
		[4] = T.RT_962,
		[5] = T.RT_962,
		[6] = T.RT_962,
	}
T.RT_964 = {
		FuncName = "ExecuteSkill1_Quit",
		Id = 310202,
	}
T.RT_965 = {
		AllowUseSkillInAir = true,
		CD = 1,
		CDType = 310201,
		ExecutePassiveFunc = T.RT_964,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Xier01",
		SkillGrade = T.RT_2,
		SkillId = 310211,
		SkillLevel = T.RT_8,
		SkillTags = T.RT_328,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_966 = {
		[0] = T.RT_965,
		[1] = T.RT_965,
		[2] = T.RT_965,
		[3] = T.RT_965,
		[4] = T.RT_965,
		[5] = T.RT_965,
		[6] = T.RT_965,
	}
T.RT_967 = {
		"Term_3103_Summon01",
		"Term_3103_Summon02",
	}
T.RT_968 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_168,
		[4] = T.RT_169,
		[5] = T.RT_169,
	}
T.RT_969 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_3103BombDamage",
		[3] = "SKILL_DESC_3103ExBombDamage",
		[4] = "SKILL_DESC_CrossDamageLength",
		[5] = "SKILL_DESC_CrossDamageWidth",
	}
T.RT_970 = {
		[1] = "$#SkillNode[310311].CostSp$",
		[2] = "$#SkillEffects[310313].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[310315].TaskEffects[1].Rate*100$%",
		[4] = "$#TargetFilter[#SkillEffects[310313].TargetFilter].LuaFilterParaments.CrossLength/50$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#TargetFilter[#SkillEffects[310313].TargetFilter].LuaFilterParaments.CrossWidth/50$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_971 = {
		310311,
	}
T.RT_972 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 310311,
		ExplanationId = T.RT_967,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Yeer01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Yeer_Skill01",
		SkillDesc = "SKILL_310301_DESC",
		SkillDescHints = T.RT_968,
		SkillDescKeys = T.RT_969,
		SkillDescValues = T.RT_970,
		SkillGrade = T.RT_2,
		SkillId = 310301,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310301_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_971,
		bEnablePrediction = true,
	}
T.RT_973 = {
		[0] = T.RT_972,
		[1] = T.RT_972,
		[2] = T.RT_972,
		[3] = T.RT_972,
		[4] = T.RT_972,
		[5] = T.RT_972,
		[6] = T.RT_972,
	}
T.RT_974 = {
		"Term_3103_Skill02",
	}
T.RT_975 = {
		2,
		3,
		4,
		5,
		6,
		7,
	}
T.RT_976 = {
		SKILL_SECTIONDESC_3103_Skill02_01 = T.RT_975,
	}
T.RT_977 = {
		[1] = T.RT_976,
	}
T.RT_978 = {
		[1] = T.RT_167,
		[2] = T.RT_230,
		[5] = T.RT_168,
		[6] = T.RT_168,
	}
T.RT_979 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_3103DomainLifeTime",
		[3] = "SKILL_DESC_3103DomainRadius",
		[4] = "SKILL_DESC_3103DomainDebuff",
		[5] = "SKILL_DESC_3103DomainDamage",
		[6] = "SKILL_DESC_3103DomainBuffRate",
		[7] = "SKILL_DESC_3103DomainSpRecover",
	}
T.RT_980 = {
		[1] = "$#SkillNode[310321].CostSp$",
		[2] = "$#SkillEffects[310321].TaskEffects[2].LifeTime$$GText(\"SKILL_DESC_Second\")$",
		[3] = "$#TargetFilter[#SkillEffects[310322].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$-#Buff[310321].AddAttrs[1].Value*100$%",
		[5] = "$#SkillEffects[310322].TaskEffects[1].Rate*100$%",
		[6] = "$#PassiveEffect[310301].Vars.Skill2InDamage*100$%",
		[7] = "$#PassiveEffect[310301].Vars.ReturnSpLarge$",
	}
T.RT_981 = {
		310321,
	}
T.RT_982 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 310321,
		CD = 2.3,
		CDType = 310302,
		ExplanationId = T.RT_974,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Yeer02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Yeer_Skill02",
		SkillDesc = "SKILL_310302_DESC",
		SkillDescGroups = T.RT_977,
		SkillDescHints = T.RT_978,
		SkillDescKeys = T.RT_979,
		SkillDescValues = T.RT_980,
		SkillGrade = T.RT_2,
		SkillId = 310302,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310302_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_981,
		bEnablePrediction = true,
	}
T.RT_983 = {
		[0] = T.RT_982,
		[1] = T.RT_982,
		[2] = T.RT_982,
		[3] = T.RT_982,
		[4] = T.RT_982,
		[5] = T.RT_982,
		[6] = T.RT_982,
	}
T.RT_984 = {
		310301,
	}
T.RT_985 = {
		[1] = "SKILL_DESC_3103YeerFallDamage",
		[2] = "SKILL_DESC_3103YeerFallRange",
	}
T.RT_986 = {
		[1] = "$#SkillEffects[310331].TaskEffects[1].Rate*100$%",
		[2] = "$#TargetFilter[#SkillEffects[310331].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_987 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_984,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Yeer03",
		SkillDesc = "SKILL_310303_DESC",
		SkillDescHints = T.RT_550,
		SkillDescKeys = T.RT_985,
		SkillDescValues = T.RT_986,
		SkillGrade = T.RT_2,
		SkillId = 310303,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310303_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_988 = {
		[0] = T.RT_987,
		[1] = T.RT_987,
		[2] = T.RT_987,
		[3] = T.RT_987,
		[4] = T.RT_987,
		[5] = T.RT_987,
		[6] = T.RT_987,
	}
T.RT_989 = {
		310302,
	}
T.RT_990 = {
		[1] = "SKILL_DESC_3103BuffSkillEff",
		[2] = "SKILL_DESC_3103BuffLastTime",
	}
T.RT_991 = {
		[1] = "$#Buff[310304].AddAttrs[1].Rate*100$%",
		[2] = "$#PassiveEffect[310302].Vars.BuffLastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_992 = {
		PassiveEffects = T.RT_989,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_310304_DESC",
		SkillDescHints = T.RT_587,
		SkillDescKeys = T.RT_990,
		SkillDescValues = T.RT_991,
		SkillGrade = T.RT_2,
		SkillId = 310304,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310304_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_993 = {
		[0] = T.RT_992,
		[1] = T.RT_992,
		[2] = T.RT_992,
		[3] = T.RT_992,
		[4] = T.RT_992,
		[5] = T.RT_992,
		[6] = T.RT_992,
	}
T.RT_994 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 310312,
		ExplanationId = T.RT_967,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Yeer01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Yeer_Skill01",
		SkillDesc = "SKILL_310301_DESC",
		SkillDescHints = T.RT_968,
		SkillDescKeys = T.RT_969,
		SkillDescValues = T.RT_970,
		SkillGrade = T.RT_2,
		SkillId = 310311,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_310301_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_995 = {
		[0] = T.RT_994,
		[1] = T.RT_994,
		[2] = T.RT_994,
		[3] = T.RT_994,
		[4] = T.RT_994,
		[5] = T.RT_994,
		[6] = T.RT_994,
	}
T.RT_996 = {
		FuncName = "End_Skill02_Enter",
		Id = 310301,
	}
T.RT_997 = {
		AllowUseSkillInAir = true,
		CD = 2.3,
		CDType = 310302,
		CombatConditionID = 310301,
		ExecutePassiveFunc = T.RT_996,
		IgnoreTag = true,
		IgnoreTimeDilation = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Yeer02_Off",
		SkillBtnStyle = "Switch",
		SkillGrade = T.RT_2,
		SkillId = 310321,
		SkillLevel = T.RT_8,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_998 = {
		[0] = T.RT_997,
		[1] = T.RT_997,
		[2] = T.RT_997,
		[3] = T.RT_997,
		[4] = T.RT_997,
		[5] = T.RT_997,
		[6] = T.RT_997,
	}
T.RT_999 = {
		"Term_3201_Skill01",
	}
T.RT_1000 = {
		2,
		3,
		4,
		7,
	}
T.RT_1001 = {
		SKILL_SECTIONDESC_3201_Skill01_01 = T.RT_1000,
	}
T.RT_1002 = {
		SKILL_SECTIONDESC_3201_Skill01_02 = T.RT_541,
	}
T.RT_1003 = {
		[1] = T.RT_1001,
		[2] = T.RT_1002,
	}
T.RT_1004 = {
		[1] = T.RT_167,
		[2] = T.RT_230,
		[3] = T.RT_168,
		[4] = T.RT_169,
		[5] = T.RT_168,
		[6] = T.RT_169,
		[7] = T.RT_230,
	}
T.RT_1005 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_3201Skill01Time",
		[3] = "SKILL_DESC_3201Skill01Dot",
		[4] = "SKILL_DESC_3201Skill01DotRadius",
		[5] = "SKILL_DESC_3201Skill01Damage",
		[6] = "SKILL_DESC_3201Skill01DamageRadius",
		[7] = "SKILL_DESC_3201Skill01Sustain",
	}
T.RT_1006 = {
		[1] = "$#SkillNode[320111].CostSp$",
		[2] = "$#SkillEffects[320111].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[3] = "$#Buff[320112].DotDatas[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$",
		[4] = "$#Buff[320111].HaloDatas[1].AuraRange/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#SkillEffects[320112].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[320112].TaskEffects[1].Value$",
		[6] = "$#TargetFilter[#SkillEffects[320112].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[7] = "$#PassiveEffect[320102].Vars.ExpandLastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1007 = {
		0,
		1,
		2,
		3,
	}
T.RT_1008 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 320111,
		ExplanationId = T.RT_999,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Haier01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Haier_Skill01",
		SkillDesc = "SKILL_320101_DESC",
		SkillDescGroups = T.RT_1003,
		SkillDescHints = T.RT_1004,
		SkillDescKeys = T.RT_1005,
		SkillDescValues = T.RT_1006,
		SkillGrade = T.RT_1007,
		SkillId = 320101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1009 = {
		4,
		5,
		6,
	}
T.RT_1010 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 320111,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Haier01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Haier_Skill01",
		SkillDesc = "SKILL_320101_DESC",
		SkillDescHints = T.RT_1004,
		SkillDescKeys = T.RT_1005,
		SkillDescValues = T.RT_1006,
		SkillGrade = T.RT_1009,
		SkillId = 320101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1011 = {
		[0] = T.RT_1008,
		[1] = T.RT_1008,
		[2] = T.RT_1008,
		[3] = T.RT_1008,
		[4] = T.RT_1010,
		[5] = T.RT_1010,
		[6] = T.RT_1010,
	}
T.RT_1012 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_DamageRadius",
		[4] = "SKILL_DESC_TauntSustain",
	}
T.RT_1013 = {
		[1] = "$#SkillNode[320121].CostSp$",
		[2] = "$#SkillEffects[320123].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[320123].TaskEffects[1].Value$",
		[3] = "$#TargetFilter[#SkillEffects[320123].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[320123].TaskEffects[3].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1014 = {
		AllowSkillIntensity = true,
		BeginNodeId = 320121,
		CD = 2.9,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Haier02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Haier_Skill02",
		SkillDesc = "SKILL_320102_DESC",
		SkillDescHints = T.RT_170,
		SkillDescKeys = T.RT_1012,
		SkillDescValues = T.RT_1013,
		SkillGrade = T.RT_2,
		SkillId = 320102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1015 = {
		[0] = T.RT_1014,
		[1] = T.RT_1014,
		[2] = T.RT_1014,
		[3] = T.RT_1014,
		[4] = T.RT_1014,
		[5] = T.RT_1014,
		[6] = T.RT_1014,
	}
T.RT_1016 = {
		320101,
	}
T.RT_1017 = {
		[1] = "SKILL_DESC_MaxHpUp",
		[2] = "SKILL_DESC_Hot",
	}
T.RT_1018 = {
		[1] = "$#Buff[320101].AddAttrs[1].Rate*100$%",
		[2] = "$#Buff[320101].DotDatas[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$",
	}
T.RT_1019 = {
		PassiveEffects = T.RT_1016,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Haier03",
		SkillDesc = "SKILL_320103_DESC",
		SkillDescKeys = T.RT_1017,
		SkillDescValues = T.RT_1018,
		SkillGrade = T.RT_2,
		SkillId = 320103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_1020 = {
		[0] = T.RT_1019,
		[1] = T.RT_1019,
		[2] = T.RT_1019,
		[3] = T.RT_1019,
		[4] = T.RT_1019,
		[5] = T.RT_1019,
		[6] = T.RT_1019,
	}
T.RT_1021 = {
		320104,
	}
T.RT_1022 = {
		[1] = "SKILL_DESC_DmgUp",
	}
T.RT_1023 = {
		[1] = "$#PassiveEffect[320104].Vars.Rate*100$%",
	}
T.RT_1024 = {
		PassiveEffects = T.RT_1021,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_320104_DESC",
		SkillDescKeys = T.RT_1022,
		SkillDescValues = T.RT_1023,
		SkillGrade = T.RT_2,
		SkillId = 320104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_1025 = {
		[0] = T.RT_1024,
		[1] = T.RT_1024,
		[2] = T.RT_1024,
		[3] = T.RT_1024,
		[4] = T.RT_1024,
		[5] = T.RT_1024,
		[6] = T.RT_1024,
	}
T.RT_1026 = {
		320105,
	}
T.RT_1027 = {
		[1] = "$#PassiveEffect[320105].Vars.TriggerProb*100$%",
		[2] = "$#PassiveEffect[320105].Vars.CD$",
		[3] = "$#PassiveEffect[320105].Vars.MaxLimit$",
		[4] = "$#Buff[320105].AddAttrs[1].Value*100$%",
		[5] = "$#PassiveEffect[320105].Vars.ExtraRate*100$%",
		[6] = "$#Buff[320105].MaxLayer$",
	}
T.RT_1028 = {
		PassiveEffects = T.RT_1026,
		SkillDesc = "SKILL_320105_DESC",
		SkillDescValues = T.RT_1027,
		SkillGrade = T.RT_2,
		SkillId = 320105,
		SkillLevel = T.RT_8,
		SkillType = "UltraPassive",
		bEnablePrediction = true,
	}
T.RT_1029 = {
		[0] = T.RT_1028,
		[1] = T.RT_1028,
		[2] = T.RT_1028,
		[3] = T.RT_1028,
		[4] = T.RT_1028,
		[5] = T.RT_1028,
		[6] = T.RT_1028,
	}
T.RT_1030 = {
		"Term_3202_Skill01",
	}
T.RT_1031 = {
		[1] = "SKILL_DESC_3202Skill01CostSp01",
		[2] = "SKILL_DESC_3103Skill01Damage01",
		[3] = "SKILL_DESC_3103Skill01DamageRadius01",
		[4] = "SKILL_DESC_3202Skill01Buff01",
		[5] = "SKILL_DESC_3202Skill01Buff02",
	}
T.RT_1032 = {
		[1] = "$#SkillNode[320212].CostSp$",
		[2] = "$#SkillEffects[320215].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[320215].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#Buff[320203].AddAttrs[1].Rate*100$%",
		[5] = "$#PassiveEffect[320201].Vars.AddSpeedRate*100$%",
	}
T.RT_1033 = {
		320211,
	}
T.RT_1034 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 320212,
		CancelBlockMove = 1,
		ExplanationId = T.RT_1030,
		LongPressSkill = 320211,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Kami01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Kami_Skill01",
		SkillDesc = "SKILL_320201_DESC",
		SkillDescHints = T.RT_170,
		SkillDescKeys = T.RT_1031,
		SkillDescValues = T.RT_1032,
		SkillGrade = T.RT_2,
		SkillId = 320201,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320201_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_1033,
		bEnablePrediction = true,
	}
T.RT_1035 = {
		[0] = T.RT_1034,
		[1] = T.RT_1034,
		[2] = T.RT_1034,
		[3] = T.RT_1034,
		[4] = T.RT_1034,
		[5] = T.RT_1034,
		[6] = T.RT_1034,
	}
T.RT_1036 = {
		"Term_3202_Skill02",
	}
T.RT_1037 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_3202Skill02Damage01",
		[3] = "SKILL_DESC_3202Skill02LastTime",
		[4] = "SKILL_DESC_3202Skill02Speed",
	}
T.RT_1038 = {
		[1] = "$#SkillNode[320221].CostSp$",
		[2] = "$#SkillEffects[320236].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillCreature[320202].TimeLife$$GText(\"SKILL_DESC_Second\")$",
		[4] = "$#SkillCreature[320202].Vars.OffsetSpeed/100$$GText(\"SKILL_DESC_Meter\")$/$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1039 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 320221,
		ExplanationId = T.RT_1036,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Kami02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Kami_Skill01",
		SkillDesc = "SKILL_320202_DESC",
		SkillDescHints = T.RT_841,
		SkillDescKeys = T.RT_1037,
		SkillDescValues = T.RT_1038,
		SkillGrade = T.RT_2,
		SkillId = 320202,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320202_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1040 = {
		[0] = T.RT_1039,
		[1] = T.RT_1039,
		[2] = T.RT_1039,
		[3] = T.RT_1039,
		[4] = T.RT_1039,
		[5] = T.RT_1039,
		[6] = T.RT_1039,
	}
T.RT_1041 = {
		"Term_3202_Passive01",
	}
T.RT_1042 = {
		320201,
	}
T.RT_1043 = {
		[1] = T.RT_168,
	}
T.RT_1044 = {
		[1] = "SKILL_DESC_3202Passive01Damage01",
	}
T.RT_1045 = {
		[1] = "$#SkillEffects[320242].TaskEffects[1].Rate*100$%*$GText(\"SKILL_DESC_RangedMultiShoot\")$",
	}
T.RT_1046 = {
		AllowSkillIntensity = true,
		ExplanationId = T.RT_1041,
		PassiveEffects = T.RT_1042,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Kami03",
		SkillDesc = "SKILL_320203_DESC",
		SkillDescHints = T.RT_1043,
		SkillDescKeys = T.RT_1044,
		SkillDescValues = T.RT_1045,
		SkillGrade = T.RT_2,
		SkillId = 320203,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320203_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_1047 = {
		[0] = T.RT_1046,
		[1] = T.RT_1046,
		[2] = T.RT_1046,
		[3] = T.RT_1046,
		[4] = T.RT_1046,
		[5] = T.RT_1046,
		[6] = T.RT_1046,
	}
T.RT_1048 = {
		320203,
	}
T.RT_1049 = {
		[1] = "SKILL_DESC_SpIncrease",
	}
T.RT_1050 = {
		[1] = "$#SkillEffects[320241].TaskEffects[1].SpChange$",
	}
T.RT_1051 = {
		PassiveEffects = T.RT_1048,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_320204_DESC",
		SkillDescKeys = T.RT_1049,
		SkillDescValues = T.RT_1050,
		SkillGrade = T.RT_2,
		SkillId = 320204,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320204_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_1052 = {
		[0] = T.RT_1051,
		[1] = T.RT_1051,
		[2] = T.RT_1051,
		[3] = T.RT_1051,
		[4] = T.RT_1051,
		[5] = T.RT_1051,
		[6] = T.RT_1051,
	}
T.RT_1053 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 320212,
		CancelBlockMove = 1,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Kami01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Kami_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 320211,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320201_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1054 = {
		[0] = T.RT_1053,
		[1] = T.RT_1053,
		[2] = T.RT_1053,
		[3] = T.RT_1053,
		[4] = T.RT_1053,
		[5] = T.RT_1053,
		[6] = T.RT_1053,
	}
T.RT_1055 = {
		320291,
	}
T.RT_1056 = {
		[1] = "SKILL_DESC_Strong",
	}
T.RT_1057 = {
		[1] = "$#Buff[320292].AddAttrs[1].Value*100$%",
	}
T.RT_1058 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_1055,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_320291_DESC",
		SkillDescKeys = T.RT_1056,
		SkillDescValues = T.RT_1057,
		SkillGrade = T.RT_2,
		SkillId = 320291,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_320291_NAME",
		SkillType = "PhantomPassive",
	}
T.RT_1059 = {
		[0] = T.RT_1058,
		[1] = T.RT_1058,
		[2] = T.RT_1058,
		[3] = T.RT_1058,
		[4] = T.RT_1058,
		[5] = T.RT_1058,
		[6] = T.RT_1058,
	}
T.RT_1060 = {
		[1] = T.RT_167,
		[2] = T.RT_169,
		[3] = T.RT_168,
	}
T.RT_1061 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_EffectRadius",
		[3] = "SKILL_DESC_Damage",
		[4] = "SKILL_DESC_StunSustain",
		[5] = "SKILL_DESC_3301Skill01Num",
	}
T.RT_1062 = {
		[1] = "$#SkillNode[330111].CostSp$",
		[2] = "$#TargetFilter[#SkillEffects[330112].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[3] = "$#SkillEffects[330112].TaskEffects[1].Rate*100$%",
		[4] = "$#SkillEffects[330112].TaskEffects[2].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[5] = "$#PassiveEffect[330101].Vars.Skill01Num$",
	}
T.RT_1063 = {
		330112,
	}
T.RT_1064 = {
		AllowSkillIntensity = true,
		BeginNodeId = 330111,
		LongPressSkill = 330112,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Maer01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Maer_Skill01",
		SkillDesc = "SKILL_330101_DESC",
		SkillDescHints = T.RT_1060,
		SkillDescKeys = T.RT_1061,
		SkillDescValues = T.RT_1062,
		SkillGrade = T.RT_2,
		SkillId = 330101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_330101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_1063,
	}
T.RT_1065 = {
		[0] = T.RT_1064,
		[1] = T.RT_1064,
		[2] = T.RT_1064,
		[3] = T.RT_1064,
		[4] = T.RT_1064,
		[5] = T.RT_1064,
		[6] = T.RT_1064,
	}
T.RT_1066 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_168,
		[5] = T.RT_169,
		[6] = T.RT_168,
		[7] = T.RT_169,
		[9] = T.RT_168,
		[10] = T.RT_169,
	}
T.RT_1067 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_3301Skill02Damage",
		[3] = "SKILL_DESC_3301Skill02DamageRadius",
		[4] = "SKILL_DESC_3301Skill02DamageExDamage",
		[5] = "SKILL_DESC_3301Skill02DamageExRadius",
		[6] = "SKILL_DESC_3301Skill02DotDamage",
		[7] = "SKILL_DESC_3301Skill02DotDamageRadius",
		[8] = "SKILL_DESC_3301Skill02Time",
		[9] = "SKILL_DESC_3301Skill02Damage2",
		[10] = "SKILL_DESC_3301Skill02Damage2Radius",
	}
T.RT_1068 = {
		[1] = "$#SkillNode[330121].CostSp$",
		[2] = "$#SkillEffects[330123].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[330123].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[330124].TaskEffects[1].Rate*100$%",
		[5] = "$#TargetFilter[#SkillEffects[330124].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#SkillEffects[330125].TaskEffects[1].Rate*100$%",
		[7] = "$#TargetFilter[#SkillEffects[330125].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[8] = "$#SkillCreature[330112].TimeLife$$GText(\"SKILL_DESC_Second\")$",
		[9] = "$#SkillEffects[330126].TaskEffects[1].Rate*100$%",
		[10] = "$#TargetFilter[#SkillEffects[330126].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_1069 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 330121,
		CD = 2.9,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Maer02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Maer_Skill02",
		SkillDesc = "SKILL_330102_DESC",
		SkillDescHints = T.RT_1066,
		SkillDescKeys = T.RT_1067,
		SkillDescValues = T.RT_1068,
		SkillGrade = T.RT_2,
		SkillId = 330102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_330102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
	}
T.RT_1070 = {
		[0] = T.RT_1069,
		[1] = T.RT_1069,
		[2] = T.RT_1069,
		[3] = T.RT_1069,
		[4] = T.RT_1069,
		[5] = T.RT_1069,
		[6] = T.RT_1069,
	}
T.RT_1071 = {
		330101,
	}
T.RT_1072 = {
		[1] = "SKILL_DESC_SkillIntenUpLayer",
	}
T.RT_1073 = {
		[1] = "$#Buff[330101].AddAttrs[1].Rate*100$%",
	}
T.RT_1074 = {
		PassiveEffects = T.RT_1071,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Maer03",
		SkillDesc = "SKILL_330103_DESC",
		SkillDescKeys = T.RT_1072,
		SkillDescValues = T.RT_1073,
		SkillGrade = T.RT_2,
		SkillId = 330103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_330103_NAME",
		SkillType = "Passive",
	}
T.RT_1075 = {
		[0] = T.RT_1074,
		[1] = T.RT_1074,
		[2] = T.RT_1074,
		[3] = T.RT_1074,
		[4] = T.RT_1074,
		[5] = T.RT_1074,
		[6] = T.RT_1074,
	}
T.RT_1076 = {
		330105,
	}
T.RT_1077 = {
		[1] = "$#Buff[330142].AddAttrs[1].Rate*100$%",
	}
T.RT_1078 = {
		PassiveEffects = T.RT_1076,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_330104_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_1077,
		SkillGrade = T.RT_2,
		SkillId = 330104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_330104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
	}
T.RT_1079 = {
		[0] = T.RT_1078,
		[1] = T.RT_1078,
		[2] = T.RT_1078,
		[3] = T.RT_1078,
		[4] = T.RT_1078,
		[5] = T.RT_1078,
		[6] = T.RT_1078,
	}
T.RT_1080 = {
		AllowSkillIntensity = true,
		BeginNodeId = 330112,
		SkillDemo = "Maer_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 330112,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
	}
T.RT_1081 = {
		[0] = T.RT_1080,
		[1] = T.RT_1080,
		[2] = T.RT_1080,
		[3] = T.RT_1080,
		[4] = T.RT_1080,
		[5] = T.RT_1080,
		[6] = T.RT_1080,
	}
T.RT_1082 = {
		[1] = "$#SkillEffects[40101].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[40101].TaskEffects[4].LastTime$",
	}
T.RT_1083 = {
		40100,
		40101,
	}
T.RT_1084 = {
		AllowUseSkillInAir = true,
		CD = 20,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet01",
		SkillDesc = "PET_401_SKILL",
		SkillDescValues = T.RT_1082,
		SkillEffectsList = T.RT_1083,
		SkillGrade = T.RT_2,
		SkillId = 401,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1085 = {
		[0] = T.RT_1084,
		[1] = T.RT_1084,
		[2] = T.RT_1084,
		[3] = T.RT_1084,
		[4] = T.RT_1084,
		[5] = T.RT_1084,
		[6] = T.RT_1084,
	}
T.RT_1086 = {
		FuncName = "ExecuteHeavyAttack",
		Id = 40101000,
	}
T.RT_1087 = {
		40101000,
	}
T.RT_1088 = {
		CD = 3,
		ExecutePassiveFunc = T.RT_1086,
		NotExecute = true,
		PassiveEffects = T.RT_1087,
		SkillBtnDesc = "SKILL_ICON_Fire",
		SkillBtnIcon = "Skill_Paotai_Fire",
		SkillGrade = T.RT_2,
		SkillId = 4010100,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
	}
T.RT_1089 = {
		40101001,
	}
T.RT_1090 = {
		AllowEightOrient = "Default",
		BeginNodeId = 4010100,
		PassiveEffects = T.RT_1089,
		SkillBtnDesc = "SKILL_ICON_RapidFire",
		SkillBtnIcon = "Skill_Paotai_RapidFire",
		SkillGrade = T.RT_2,
		SkillId = 4010101,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
	}
T.RT_1091 = {
		FuncName = "ExecuteHeavyAttack",
		Id = 40102000,
	}
T.RT_1092 = {
		40102000,
	}
T.RT_1093 = {
		CD = 4,
		ExecutePassiveFunc = T.RT_1091,
		NotExecute = true,
		PassiveEffects = T.RT_1092,
		SkillBtnDesc = "SKILL_ICON_Fire",
		SkillBtnIcon = "Skill_Paotai_Fire",
		SkillGrade = T.RT_2,
		SkillId = 4010200,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
	}
T.RT_1094 = {
		40102001,
	}
T.RT_1095 = {
		AllowEightOrient = "Default",
		BeginNodeId = 4010200,
		PassiveEffects = T.RT_1094,
		SkillBtnDesc = "SKILL_ICON_RapidFire",
		SkillBtnIcon = "Skill_Paotai_RapidFire",
		SkillGrade = T.RT_2,
		SkillId = 4010201,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
	}
T.RT_1096 = {
		[1] = "$#Buff[402].AddAttrs[1].Rate*100$%",
		[2] = "$#SkillEffects[40201].TaskEffects[1].LastTime$",
	}
T.RT_1097 = {
		40200,
		40201,
	}
T.RT_1098 = {
		AllowUseSkillInAir = true,
		CD = 20,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet02",
		SkillDesc = "PET_402_SKILL",
		SkillDescValues = T.RT_1096,
		SkillEffectsList = T.RT_1097,
		SkillGrade = T.RT_2,
		SkillId = 402,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1099 = {
		[0] = T.RT_1098,
		[1] = T.RT_1098,
		[2] = T.RT_1098,
		[3] = T.RT_1098,
		[4] = T.RT_1098,
		[5] = T.RT_1098,
		[6] = T.RT_1098,
	}
T.RT_1100 = {
		[1] = "$#SkillEffects[40301].TaskEffects[1].SpChange$",
	}
T.RT_1101 = {
		40300,
		40301,
	}
T.RT_1102 = {
		AllowUseSkillInAir = true,
		CD = 40,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet03",
		SkillDesc = "PET_403_SKILL",
		SkillDescValues = T.RT_1100,
		SkillEffectsList = T.RT_1101,
		SkillGrade = T.RT_2,
		SkillId = 403,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1103 = {
		[0] = T.RT_1102,
		[1] = T.RT_1102,
		[2] = T.RT_1102,
		[3] = T.RT_1102,
		[4] = T.RT_1102,
		[5] = T.RT_1102,
		[6] = T.RT_1102,
	}
T.RT_1104 = {
		[1] = "$#SkillEffects[40401].TaskEffects[1].LastTime$",
		[2] = "$#SkillEffects[40401].TaskEffects[2].Value$",
		[3] = "$#Buff[11].AddAttrs[1].Rate*100$%",
		[4] = "$#Buff[12].AddAttrs[1].Rate*100$%",
		[5] = "$#Buff[13].AddAttrs[1].Rate*100$%",
		[6] = "$#Buff[14].AddAttrs[1].Rate*100$%",
	}
T.RT_1105 = {
		40400,
		40401,
	}
T.RT_1106 = {
		AllowUseSkillInAir = true,
		CD = 40,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet04",
		SkillDesc = "PET_404_SKILL",
		SkillDescValues = T.RT_1104,
		SkillEffectsList = T.RT_1105,
		SkillGrade = T.RT_2,
		SkillId = 404,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1107 = {
		[0] = T.RT_1106,
		[1] = T.RT_1106,
		[2] = T.RT_1106,
		[3] = T.RT_1106,
		[4] = T.RT_1106,
		[5] = T.RT_1106,
		[6] = T.RT_1106,
	}
T.RT_1108 = {
		[1] = "$#SkillEffects[40501].TaskEffects[1].Rate*100$%",
	}
T.RT_1109 = {
		40500,
		40501,
	}
T.RT_1110 = {
		AllowUseSkillInAir = true,
		CD = 30,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet05",
		SkillDesc = "PET_405_SKILL",
		SkillDescValues = T.RT_1108,
		SkillEffectsList = T.RT_1109,
		SkillGrade = T.RT_2,
		SkillId = 405,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1111 = {
		[0] = T.RT_1110,
		[1] = T.RT_1110,
		[2] = T.RT_1110,
		[3] = T.RT_1110,
		[4] = T.RT_1110,
		[5] = T.RT_1110,
		[6] = T.RT_1110,
	}
T.RT_1112 = {
		[1] = "$#SkillEffects[40601].TaskEffects[1].Rate*100$%",
		[2] = "$-#Buff[406].BuffDamageRate.Value*100$%",
		[3] = "$#SkillEffects[40601].TaskEffects[4].LastTime$",
	}
T.RT_1113 = {
		40600,
		40601,
	}
T.RT_1114 = {
		AllowUseSkillInAir = true,
		CD = 20,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet06",
		SkillDesc = "PET_406_SKILL",
		SkillDescValues = T.RT_1112,
		SkillEffectsList = T.RT_1113,
		SkillGrade = T.RT_2,
		SkillId = 406,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1115 = {
		[0] = T.RT_1114,
		[1] = T.RT_1114,
		[2] = T.RT_1114,
		[3] = T.RT_1114,
		[4] = T.RT_1114,
		[5] = T.RT_1114,
		[6] = T.RT_1114,
	}
T.RT_1116 = {
		[1] = "$#SkillEffects[40701].TaskEffects[1].Rate*100$%",
	}
T.RT_1117 = {
		40700,
		40701,
		40702,
	}
T.RT_1118 = {
		AllowUseSkillInAir = true,
		CD = 30,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Nihao",
		SkillDesc = "PET_407_SKILL",
		SkillDescValues = T.RT_1116,
		SkillEffectsList = T.RT_1117,
		SkillGrade = T.RT_2,
		SkillId = 407,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1119 = {
		[0] = T.RT_1118,
		[1] = T.RT_1118,
		[2] = T.RT_1118,
		[3] = T.RT_1118,
		[4] = T.RT_1118,
		[5] = T.RT_1118,
		[6] = T.RT_1118,
	}
T.RT_1120 = {
		[1] = "$-#Buff[408].BuffDamagedRate.Value*100$%",
		[2] = "$#SkillEffects[40801].TaskEffects[1].LastTime$",
	}
T.RT_1121 = {
		40801,
	}
T.RT_1122 = {
		AllowUseSkillInAir = true,
		CD = 25,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Zhenzhu",
		SkillDesc = "PET_408_SKILL",
		SkillDescValues = T.RT_1120,
		SkillEffectsList = T.RT_1121,
		SkillGrade = T.RT_2,
		SkillId = 408,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1123 = {
		[0] = T.RT_1122,
		[1] = T.RT_1122,
		[2] = T.RT_1122,
		[3] = T.RT_1122,
		[4] = T.RT_1122,
		[5] = T.RT_1122,
		[6] = T.RT_1122,
	}
T.RT_1124 = {
		[1] = "$#Buff[409].DotDatas[1].Rate*100$%",
		[2] = "$#SkillEffects[40901].TaskEffects[1].LastTime$",
	}
T.RT_1125 = {
		40901,
	}
T.RT_1126 = {
		AllowUseSkillInAir = true,
		CD = 30,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Haomeng",
		SkillDesc = "PET_409_SKILL",
		SkillDescValues = T.RT_1124,
		SkillEffectsList = T.RT_1125,
		SkillGrade = T.RT_2,
		SkillId = 409,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1127 = {
		[0] = T.RT_1126,
		[1] = T.RT_1126,
		[2] = T.RT_1126,
		[3] = T.RT_1126,
		[4] = T.RT_1126,
		[5] = T.RT_1126,
		[6] = T.RT_1126,
	}
T.RT_1128 = {
		410001,
	}
T.RT_1129 = {
		[1] = "$#Buff[410002].AddAttrs[1].Rate*100$%",
	}
T.RT_1130 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_1128,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_410001_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_1129,
		SkillGrade = T.RT_2,
		SkillId = 410001,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410001_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_1131 = {
		[0] = T.RT_1130,
		[1] = T.RT_1130,
		[2] = T.RT_1130,
		[3] = T.RT_1130,
		[4] = T.RT_1130,
		[5] = T.RT_1130,
		[6] = T.RT_1130,
	}
T.RT_1132 = {
		410003,
	}
T.RT_1133 = {
		[1] = "$#Buff[410004].AddAttrs[1].Rate*100$%",
	}
T.RT_1134 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_1132,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_410003_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_1133,
		SkillGrade = T.RT_2,
		SkillId = 410003,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410003_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_1135 = {
		[0] = T.RT_1134,
		[1] = T.RT_1134,
		[2] = T.RT_1134,
		[3] = T.RT_1134,
		[4] = T.RT_1134,
		[5] = T.RT_1134,
		[6] = T.RT_1134,
	}
T.RT_1136 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_168,
		[5] = T.RT_230,
	}
T.RT_1137 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Damage",
		[3] = "SKILL_DESC_Damage_ConsumeSecondSp",
		[4] = "SKILL_DESC_DmgUp",
		[5] = "SKILL_DESC_DmgUpTime",
	}
T.RT_1138 = {
		[1] = "$#SkillNode[410111].CostSp$",
		[2] = "$#SkillEffects[410114].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[410115].TaskEffects[1].Rate*100$%",
		[4] = "$#Buff[410102].AddAttrs[1].Value*100$%",
		[5] = "$#SkillEffects[410117].TaskEffects[2].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1139 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410111,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Lise01",
		SkillDemo = "Lise_Skill01",
		SkillDesc = "SKILL_410101_DESC",
		SkillDescHints = T.RT_1136,
		SkillDescKeys = T.RT_1137,
		SkillDescValues = T.RT_1138,
		SkillGrade = T.RT_2,
		SkillId = 410101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
	}
T.RT_1140 = {
		[0] = T.RT_1139,
		[1] = T.RT_1139,
		[2] = T.RT_1139,
		[3] = T.RT_1139,
		[4] = T.RT_1139,
		[5] = T.RT_1139,
		[6] = T.RT_1139,
	}
T.RT_1141 = {
		"Term_4101_Skill02_01",
		"Term_4101_Skill02_02",
	}
T.RT_1142 = {
		SKILL_SECTIONDESC_4101_Skill02_01 = T.RT_541,
	}
T.RT_1143 = {
		7,
		8,
		10,
	}
T.RT_1144 = {
		SKILL_SECTIONDESC_4101_Skill02_02 = T.RT_1143,
	}
T.RT_1145 = {
		[1] = T.RT_1142,
		[2] = T.RT_1144,
	}
T.RT_1146 = {
		[1] = T.RT_167,
		[2] = T.RT_176,
		[3] = T.RT_168,
		[4] = T.RT_169,
		[6] = T.RT_168,
		[8] = T.RT_168,
		[10] = T.RT_230,
	}
T.RT_1147 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SpChangeScd",
		[3] = "SKILL_DESC_Damage",
		[4] = "SKILL_DESC_DamageRadius",
		[5] = "SKILL_DESC_4101Skill02_Radius01",
		[6] = "SKILL_DESC_4101Skill02_Damage01",
		[7] = "SKILL_DESC_4101Skill02_Radius02",
		[8] = "SKILL_DESC_4101Skill02_Damage02",
		[9] = "SKILL_DESC_4101Skill02AddSpeed",
		[10] = "SKILL_DESC_4101Skill02_BuffLastTime",
	}
T.RT_1148 = {
		[1] = "$#SkillNode[410121].CostSp$",
		[2] = "$math.abs(#Buff[410111].DotDatas[1].Value)$",
		[3] = "$#SkillEffects[410126].TaskEffects[1].Rate*100$%",
		[4] = "$#TargetFilter[#SkillEffects[410126].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#PassiveEffect[410103].Vars.SelectRadius01*100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#SkillEffects[410122].TaskEffects[1].Rate*100$%",
		[7] = "$#PassiveEffect[410103].Vars.SelectRadius02*100$$GText(\"SKILL_DESC_Meter\")$",
		[8] = "$#SkillEffects[410125].TaskEffects[1].Rate*100$%",
		[9] = "$#Buff[410123].AddAttrs[1].Value*100$%",
		[10] = "$#SkillEffects[410122].TaskEffects[2].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1149 = {
		410121,
	}
T.RT_1150 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410121,
		CD = 2,
		CDType = 410102,
		ExplanationId = T.RT_1141,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Lise02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Lise_Skill02",
		SkillDesc = "SKILL_410102_DESC",
		SkillDescGroups = T.RT_1145,
		SkillDescHints = T.RT_1146,
		SkillDescKeys = T.RT_1147,
		SkillDescValues = T.RT_1148,
		SkillGrade = T.RT_2,
		SkillId = 410102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_1149,
	}
T.RT_1151 = {
		[0] = T.RT_1150,
		[1] = T.RT_1150,
		[2] = T.RT_1150,
		[3] = T.RT_1150,
		[4] = T.RT_1150,
		[5] = T.RT_1150,
		[6] = T.RT_1150,
	}
T.RT_1152 = {
		410101,
	}
T.RT_1153 = {
		[1] = "SKILL_DESC_4101Passive_Per",
	}
T.RT_1154 = {
		[1] = "$#PassiveEffect[410101].Vars.Passive1Per*100$%",
	}
T.RT_1155 = {
		PassiveEffects = T.RT_1152,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Lise03",
		SkillDesc = "SKILL_410103_DESC",
		SkillDescKeys = T.RT_1153,
		SkillDescValues = T.RT_1154,
		SkillGrade = T.RT_2,
		SkillId = 410103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410103_NAME",
		SkillType = "Passive",
	}
T.RT_1156 = {
		[0] = T.RT_1155,
		[1] = T.RT_1155,
		[2] = T.RT_1155,
		[3] = T.RT_1155,
		[4] = T.RT_1155,
		[5] = T.RT_1155,
		[6] = T.RT_1155,
	}
T.RT_1157 = {
		410102,
	}
T.RT_1158 = {
		PassiveEffects = T.RT_1157,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_410104_DESC",
		SkillGrade = T.RT_2,
		SkillId = 410104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
	}
T.RT_1159 = {
		[0] = T.RT_1158,
		[1] = T.RT_1158,
		[2] = T.RT_1158,
		[3] = T.RT_1158,
		[4] = T.RT_1158,
		[5] = T.RT_1158,
		[6] = T.RT_1158,
	}
T.RT_1160 = {
		410131,
	}
T.RT_1161 = {
		AllowUseSkillInAir = true,
		CD = 2,
		CDType = 410102,
		CombatConditionID = 410101,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Lise02_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Lise_Skill02",
		SkillEffectsList = T.RT_1160,
		SkillGrade = T.RT_2,
		SkillId = 410121,
		SkillLevel = T.RT_8,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
	}
T.RT_1162 = {
		[0] = T.RT_1161,
		[1] = T.RT_1161,
		[2] = T.RT_1161,
		[3] = T.RT_1161,
		[4] = T.RT_1161,
		[5] = T.RT_1161,
		[6] = T.RT_1161,
	}
T.RT_1163 = {
		SKILL_SECTIONDESC_4102_Skill01_01 = T.RT_578,
	}
T.RT_1164 = {
		SKILL_SECTIONDESC_4102_Skill01_02 = T.RT_1009,
	}
T.RT_1165 = {
		[1] = T.RT_1163,
		[2] = T.RT_1164,
	}
T.RT_1166 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_168,
		[5] = T.RT_169,
		[6] = T.RT_168,
	}
T.RT_1167 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_4102Skill01_Dmg01",
		[3] = "SKILL_DESC_4102Skill01_Range01",
		[4] = "SKILL_DESC_4102Skill01_Dmg02",
		[5] = "SKILL_DESC_4102Skill01_Range02",
		[6] = "SKILL_DESC_4102Skill01_Shield",
	}
T.RT_1168 = {
		[1] = "$#SkillNode[410211].CostSp$",
		[2] = "$#SkillEffects[410213].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[410213].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[410214].TaskEffects[1].Rate*100$%",
		[5] = "$#TargetFilter[#SkillEffects[410214].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#SkillEffects[410215].TaskEffects[2].Rate*100$%$GText(\"SKILL_DESC_MaxEs\")$",
	}
T.RT_1169 = {
		410211,
	}
T.RT_1170 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410211,
		LongPressSkill = 410211,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhiliu01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhiliu_Skill01",
		SkillDesc = "SKILL_410201_DESC",
		SkillDescGroups = T.RT_1165,
		SkillDescHints = T.RT_1166,
		SkillDescKeys = T.RT_1167,
		SkillDescValues = T.RT_1168,
		SkillGrade = T.RT_2,
		SkillId = 410201,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410201_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_1169,
		bEnablePrediction = true,
	}
T.RT_1171 = {
		[0] = T.RT_1170,
		[1] = T.RT_1170,
		[2] = T.RT_1170,
		[3] = T.RT_1170,
		[4] = T.RT_1170,
		[5] = T.RT_1170,
		[6] = T.RT_1170,
	}
T.RT_1172 = {
		"Term_4102_Skill02_01",
		"Term_4102_Skill02_02",
		"Term_4102_Skill02_03",
	}
T.RT_1173 = {
		1,
		5,
		6,
	}
T.RT_1174 = {
		SKILL_SECTIONDESC_4102_Skill02_00 = T.RT_1173,
	}
T.RT_1175 = {
		2,
		7,
		8,
	}
T.RT_1176 = {
		SKILL_SECTIONDESC_4102_Skill02_01 = T.RT_1175,
	}
T.RT_1177 = {
		3,
		9,
		10,
		11,
		12,
		13,
		14,
	}
T.RT_1178 = {
		SKILL_SECTIONDESC_4102_Skill02_02 = T.RT_1177,
	}
T.RT_1179 = {
		4,
		15,
		16,
		17,
		18,
	}
T.RT_1180 = {
		SKILL_SECTIONDESC_4102_Skill02_03 = T.RT_1179,
	}
T.RT_1181 = {
		[1] = T.RT_1174,
		[2] = T.RT_1176,
		[3] = T.RT_1178,
		[4] = T.RT_1180,
	}
T.RT_1182 = {
		[1] = T.RT_167,
		[2] = T.RT_167,
		[3] = T.RT_167,
		[4] = T.RT_167,
		[5] = T.RT_168,
		[6] = T.RT_169,
		[7] = T.RT_168,
		[8] = T.RT_169,
		[9] = T.RT_168,
		[10] = T.RT_169,
		[11] = T.RT_169,
		[12] = T.RT_230,
		[13] = T.RT_168,
		[14] = T.RT_169,
		[15] = T.RT_168,
		[16] = T.RT_169,
		[18] = T.RT_230,
	}
T.RT_1183 = {
		[1] = "SKILL_DESC_4102Skill02_Sp00",
		[2] = "SKILL_DESC_4102Skill02_Sp01",
		[3] = "SKILL_DESC_4102Skill02_Sp02",
		[4] = "SKILL_DESC_4102Skill02_Sp03",
		[5] = "SKILL_DESC_4102Skill02_Dmg00",
		[6] = "SKILL_DESC_4102Skill02_Range00",
		[7] = "SKILL_DESC_4102Skill02_Dmg01",
		[8] = "SKILL_DESC_4102Skill02_Range01",
		[9] = "SKILL_DESC_4102Skill02_Dmg02",
		[10] = "SKILL_DESC_4102Skill02_Range02",
		[11] = "SKILL_DESC_4102Skill02_Range03",
		[12] = "SKILL_DESC_4102Skill02_Sustain02",
		[13] = "SKILL_DESC_4102Skill02_Dmg03",
		[14] = "SKILL_DESC_4102Skill02_Range04",
		[15] = "SKILL_DESC_4102Skill02_Dmg04",
		[16] = "SKILL_DESC_4102Skill02_Range05",
		[17] = "SKILL_DESC_4102Skill02_Buff",
		[18] = "SKILL_DESC_4102Skill02_Sustain03",
	}
T.RT_1184 = {
		[1] = "$#SkillNode[410221].CostSp$",
		[2] = "$#SkillNode[410222].CostSp$",
		[3] = "$#SkillNode[410223].CostSp$",
		[4] = "$#SkillNode[410224].CostSp$",
		[5] = "$#SkillEffects[410222].TaskEffects[1].Rate*100$%",
		[6] = "$#TargetFilter[#SkillEffects[410222].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[7] = "$#SkillEffects[410232].TaskEffects[1].Rate*100$%",
		[8] = "$#TargetFilter[#SkillEffects[410232].TargetFilter].LuaFilterParaments.Length/100$$GText(\"SKILL_DESC_Meter\")$×$#TargetFilter[#SkillEffects[410232].TargetFilter].LuaFilterParaments.HalfWidth/50$$GText(\"SKILL_DESC_Meter\")$",
		[9] = "$#SkillEffects[410243].TaskEffects[1].Rate*100$%×3+$#SkillEffects[410245].TaskEffects[1].Rate*100$%",
		[10] = "$#TargetFilter[#SkillEffects[410243].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[11] = "$#SkillCreature[410225].ShapeInfo.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[12] = "$#SkillCreature[410225].TimeLife$$GText(\"SKILL_DESC_Second\")$",
		[13] = "$#SkillEffects[410248].TaskEffects[1].Rate*100$%",
		[14] = "$#TargetFilter[#SkillEffects[410248].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[15] = "$#SkillEffects[410225].TaskEffects[1].Rate*100$%",
		[16] = "$#TargetFilter[#SkillEffects[410225].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[17] = "$#Buff[410231].AddAttrs[1].Value*100$%",
		[18] = "$#SkillEffects[410226].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1185 = {
		410221,
		410222,
		410223,
	}
T.RT_1186 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410221,
		CD = 2.5,
		ExplanationId = T.RT_1172,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhiliu02_1",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhiliu_Skill02",
		SkillDesc = "SKILL_410202_DESC",
		SkillDescGroups = T.RT_1181,
		SkillDescHints = T.RT_1182,
		SkillDescKeys = T.RT_1183,
		SkillDescValues = T.RT_1184,
		SkillGrade = T.RT_742,
		SkillId = 410202,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410202_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_1185,
		bEnablePrediction = true,
	}
T.RT_1187 = {
		410221,
		410222,
		410223,
		410224,
	}
T.RT_1188 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410221,
		CD = 2.5,
		ExplanationId = T.RT_1172,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhiliu02_1",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhiliu_Skill02",
		SkillDesc = "SKILL_410202_DESC",
		SkillDescGroups = T.RT_1181,
		SkillDescHints = T.RT_1182,
		SkillDescKeys = T.RT_1183,
		SkillDescValues = T.RT_1184,
		SkillGrade = T.RT_745,
		SkillId = 410202,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410202_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_1187,
		bEnablePrediction = true,
	}
T.RT_1189 = {
		[0] = T.RT_1186,
		[1] = T.RT_1186,
		[2] = T.RT_1188,
		[3] = T.RT_1188,
		[4] = T.RT_1188,
		[5] = T.RT_1188,
		[6] = T.RT_1188,
	}
T.RT_1190 = {
		410201,
	}
T.RT_1191 = {
		[1] = "$#PassiveEffect[410201].Vars.NoRemoveProbRateEx*100$%+$#PassiveEffect[410201].Vars.NoRemoveProbRate*100$%$GText(\"SKILL_DESC_Multi\")$$GText(\"SKILL_DESC_MeleeTriggerProb\")$",
	}
T.RT_1192 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_1190,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Zhiliu03",
		SkillDesc = "SKILL_410203_DESC",
		SkillDescKeys = T.RT_256,
		SkillDescValues = T.RT_1191,
		SkillGrade = T.RT_2,
		SkillId = 410203,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410203_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_1193 = {
		[0] = T.RT_1192,
		[1] = T.RT_1192,
		[2] = T.RT_1192,
		[3] = T.RT_1192,
		[4] = T.RT_1192,
		[5] = T.RT_1192,
		[6] = T.RT_1192,
	}
T.RT_1194 = {
		[1] = "SKILL_DESC_StrongLayer",
		[2] = "SKILL_DESC_Sustain",
	}
T.RT_1195 = {
		[1] = "$#Buff[410214].AddAttrs[1].Value*100$%",
		[2] = "$#PassiveEffect[410211].Vars.LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1196 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_1169,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_410204_DESC",
		SkillDescHints = T.RT_587,
		SkillDescKeys = T.RT_1194,
		SkillDescValues = T.RT_1195,
		SkillGrade = T.RT_2,
		SkillId = 410204,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_410204_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_1197 = {
		[0] = T.RT_1196,
		[1] = T.RT_1196,
		[2] = T.RT_1196,
		[3] = T.RT_1196,
		[4] = T.RT_1196,
		[5] = T.RT_1196,
		[6] = T.RT_1196,
	}
T.RT_1198 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410212,
		SkillGrade = T.RT_2,
		SkillId = 410211,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1199 = {
		[0] = T.RT_1198,
		[1] = T.RT_1198,
		[2] = T.RT_1198,
		[3] = T.RT_1198,
		[4] = T.RT_1198,
		[5] = T.RT_1198,
		[6] = T.RT_1198,
	}
T.RT_1200 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410222,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhiliu02_2",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhiliu_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 410221,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1201 = {
		[0] = T.RT_1200,
		[1] = T.RT_1200,
		[2] = T.RT_1200,
		[3] = T.RT_1200,
		[4] = T.RT_1200,
		[5] = T.RT_1200,
		[6] = T.RT_1200,
	}
T.RT_1202 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410223,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhiliu02_3",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhiliu_Skill02",
		SkillGrade = T.RT_742,
		SkillId = 410222,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1203 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410223,
		IgnoreTimeDilation = true,
		LongPressSkill = 410224,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Zhiliu02_3",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhiliu_Skill02",
		SkillGrade = T.RT_745,
		SkillId = 410222,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1204 = {
		[0] = T.RT_1202,
		[1] = T.RT_1202,
		[2] = T.RT_1203,
		[3] = T.RT_1203,
		[4] = T.RT_1203,
		[5] = T.RT_1203,
		[6] = T.RT_1203,
	}
T.RT_1205 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410224,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Zhiliu02_4",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Zhiliu_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 410223,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1206 = {
		[0] = T.RT_1205,
		[1] = T.RT_1205,
		[2] = T.RT_1205,
		[3] = T.RT_1205,
		[4] = T.RT_1205,
		[5] = T.RT_1205,
		[6] = T.RT_1205,
	}
T.RT_1207 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 410225,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillGrade = T.RT_745,
		SkillId = 410224,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1208 = {
		[2] = T.RT_1207,
		[3] = T.RT_1207,
		[4] = T.RT_1207,
		[5] = T.RT_1207,
		[6] = T.RT_1207,
	}
T.RT_1209 = {
		[1] = "$#SkillEffects[41101].TaskEffects[1].Rate*100$%",
		[2] = "$-#Buff[411].AddAttrs[1].Rate*100$%",
		[3] = "$#SkillEffects[41101].TaskEffects[4].LastTime$",
	}
T.RT_1210 = {
		41100,
		41101,
	}
T.RT_1211 = {
		AllowUseSkillInAir = true,
		CD = 20,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Fuyou",
		SkillDesc = "PET_411_SKILL",
		SkillDescValues = T.RT_1209,
		SkillEffectsList = T.RT_1210,
		SkillGrade = T.RT_2,
		SkillId = 411,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1212 = {
		[0] = T.RT_1211,
		[1] = T.RT_1211,
		[2] = T.RT_1211,
		[3] = T.RT_1211,
		[4] = T.RT_1211,
		[5] = T.RT_1211,
		[6] = T.RT_1211,
	}
T.RT_1213 = {
		[1] = "$#Buff[412].AddAttrs[1].Rate*100$%",
		[2] = "$#SkillEffects[41201].TaskEffects[1].LastTime$",
	}
T.RT_1214 = {
		41200,
		41201,
	}
T.RT_1215 = {
		AllowUseSkillInAir = true,
		CD = 20,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Tangshuang",
		SkillDesc = "PET_412_SKILL",
		SkillDescValues = T.RT_1213,
		SkillEffectsList = T.RT_1214,
		SkillGrade = T.RT_2,
		SkillId = 412,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1216 = {
		[0] = T.RT_1215,
		[1] = T.RT_1215,
		[2] = T.RT_1215,
		[3] = T.RT_1215,
		[4] = T.RT_1215,
		[5] = T.RT_1215,
		[6] = T.RT_1215,
	}
T.RT_1217 = {
		[1] = "$#Buff[413].AddAttrs[1].Rate*100$%",
		[2] = "$#SkillEffects[41301].TaskEffects[1].LastTime$",
	}
T.RT_1218 = {
		41300,
		41301,
		41302,
	}
T.RT_1219 = {
		AllowUseSkillInAir = true,
		CD = 30,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_YYHW",
		SkillDesc = "PET_413_SKILL",
		SkillDescValues = T.RT_1217,
		SkillEffectsList = T.RT_1218,
		SkillGrade = T.RT_2,
		SkillId = 413,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1220 = {
		[0] = T.RT_1219,
		[1] = T.RT_1219,
		[2] = T.RT_1219,
		[3] = T.RT_1219,
		[4] = T.RT_1219,
		[5] = T.RT_1219,
		[6] = T.RT_1219,
	}
T.RT_1221 = {
		[1] = "$#SkillEffects[41401].TaskEffects[1].Value$",
		[2] = "$#SkillEffects[41401].TaskEffects[2].SpChange$",
	}
T.RT_1222 = {
		41400,
		41401,
	}
T.RT_1223 = {
		AllowUseSkillInAir = true,
		CD = 40,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Pipa",
		SkillDesc = "PET_414_SKILL",
		SkillDescValues = T.RT_1221,
		SkillEffectsList = T.RT_1222,
		SkillGrade = T.RT_2,
		SkillId = 414,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1224 = {
		[0] = T.RT_1223,
		[1] = T.RT_1223,
		[2] = T.RT_1223,
		[3] = T.RT_1223,
		[4] = T.RT_1223,
		[5] = T.RT_1223,
		[6] = T.RT_1223,
	}
T.RT_1225 = {
		[1] = "$#Buff[415].AddAttrs[1].Rate*100$%",
		[2] = "$#SkillEffects[41501].TaskEffects[1].LastTime$",
		[3] = "$#SkillEffects[41501].TaskEffects[2].Rate*100$%",
	}
T.RT_1226 = {
		41500,
		41501,
	}
T.RT_1227 = {
		AllowUseSkillInAir = true,
		CD = 30,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Mianmian",
		SkillDesc = "PET_415_SKILL",
		SkillDescValues = T.RT_1225,
		SkillEffectsList = T.RT_1226,
		SkillGrade = T.RT_2,
		SkillId = 415,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1228 = {
		[0] = T.RT_1227,
		[1] = T.RT_1227,
		[2] = T.RT_1227,
		[3] = T.RT_1227,
		[4] = T.RT_1227,
		[5] = T.RT_1227,
		[6] = T.RT_1227,
	}
T.RT_1229 = {
		[1] = "$#SkillEffects[41601].TaskEffects[1].Rate*100$%",
		[2] = "$#Buff[416].AddAttrs[1].Value*100$%",
		[3] = "$#SkillEffects[41601].TaskEffects[4].LastTime$",
	}
T.RT_1230 = {
		41600,
		41601,
	}
T.RT_1231 = {
		AllowUseSkillInAir = true,
		CD = 20,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Qiuqiu",
		SkillDesc = "PET_416_SKILL",
		SkillDescValues = T.RT_1229,
		SkillEffectsList = T.RT_1230,
		SkillGrade = T.RT_2,
		SkillId = 416,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1232 = {
		[0] = T.RT_1231,
		[1] = T.RT_1231,
		[2] = T.RT_1231,
		[3] = T.RT_1231,
		[4] = T.RT_1231,
		[5] = T.RT_1231,
		[6] = T.RT_1231,
	}
T.RT_1233 = {
		[1] = "$#SkillEffects[41701].TaskEffects[1].Rate*100$%",
	}
T.RT_1234 = {
		41700,
	}
T.RT_1235 = {
		AllowUseSkillInAir = true,
		CD = 25,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Qingluan",
		SkillDesc = "PET_417_SKILL",
		SkillDescValues = T.RT_1233,
		SkillEffectsList = T.RT_1234,
		SkillGrade = T.RT_2,
		SkillId = 417,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1236 = {
		[0] = T.RT_1235,
		[1] = T.RT_1235,
		[2] = T.RT_1235,
		[3] = T.RT_1235,
		[4] = T.RT_1235,
		[5] = T.RT_1235,
		[6] = T.RT_1235,
	}
T.RT_1237 = {
		"Term_4201_FallAttack",
		"Term_4201_Marks",
		"Term_4201_BonusAttack",
		"Term_4201_SuperFallAttack",
	}
T.RT_1238 = {
		[1] = T.RT_167,
		[4] = T.RT_169,
		[5] = T.RT_168,
		[6] = T.RT_169,
		[8] = T.RT_230,
	}
T.RT_1239 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_4201FallAttackDamage",
		[3] = "SKILL_DESC_4201FallAttackExtraRate",
		[4] = "SKILL_DESC_4201FallAttackRadius",
		[5] = "SKILL_DESC_4201ThunderDamage",
		[6] = "SKILL_DESC_4201ThunderDamageRadius",
		[7] = "SKILL_DESC_DmgUp",
		[8] = "SKILL_DESC_DmgUpTime",
	}
T.RT_1240 = {
		[1] = "$#SkillNode[420111].CostSp$",
		[2] = "$#SkillEffects[420144].TaskEffects[1].Rate*100$%",
		[3] = "$#SkillEffects[420144].TaskEffects[2].Rate*100$%",
		[4] = "$#TargetFilter[#SkillEffects[420144].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#SkillEffects[420131].TaskEffects[1].Rate*100$%",
		[6] = "$#TargetFilter[#SkillEffects[420131].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[7] = "$#Buff[420112].AddAttrs[1].Value*100$%",
		[8] = "$#SkillEffects[420141].TaskEffects[3].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1241 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 420111,
		CD = 0.7,
		ExplanationId = T.RT_1237,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Yuming01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Yuming_Skill01",
		SkillDesc = "SKILL_420101_DESC",
		SkillDescHints = T.RT_1238,
		SkillDescKeys = T.RT_1239,
		SkillDescValues = T.RT_1240,
		SkillGrade = T.RT_844,
		SkillId = 420101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Melee",
	}
T.RT_1242 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 420113,
		CD = 0.7,
		ExplanationId = T.RT_1237,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Yuming01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Yuming_Skill01",
		SkillDesc = "SKILL_420101_DESC",
		SkillDescHints = T.RT_1238,
		SkillDescKeys = T.RT_1239,
		SkillDescValues = T.RT_1240,
		SkillGrade = T.RT_846,
		SkillId = 420101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SkillWeaponType = "Melee",
	}
T.RT_1243 = {
		[0] = T.RT_1241,
		[1] = T.RT_1242,
		[2] = T.RT_1242,
		[3] = T.RT_1242,
		[4] = T.RT_1242,
		[5] = T.RT_1242,
		[6] = T.RT_1242,
	}
T.RT_1244 = {
		"Term_4201_Summon",
		"Term_4201_Skill2Buff",
	}
T.RT_1245 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[5] = T.RT_169,
		[6] = T.RT_168,
	}
T.RT_1246 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SkillExecuteDamage",
		[3] = "SKILL_DESC_SkillExecuteDamageRadius",
		[4] = "SKILL_DESC_4201Skill02SummonHp",
		[5] = "SKILL_DESC_4201DebuffRadius",
		[6] = "SKILL_DESC_4201ExThunderDamage",
	}
T.RT_1247 = {
		[1] = "$#SkillNode[420121].CostSp$",
		[2] = "$#SkillEffects[420122].TaskEffects[1].Rate*100$%",
		[3] = "$#TargetFilter[#SkillEffects[420122].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[420121].TaskEffects[1].AttrRates.MaxHp*100$%$GText(\"SKILL_DESC_MaxHp\")$",
		[5] = "$#Buff[420123].HaloDatas[2].AuraRange/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#SkillEffects[420123].TaskEffects[1].Rate*100$%",
	}
T.RT_1248 = {
		AllowSkillIntensity = true,
		BeginNodeId = 420121,
		CD = 3,
		ExplanationId = T.RT_1244,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Yuming02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Yuming_Skill02",
		SkillDesc = "SKILL_420102_DESC",
		SkillDescHints = T.RT_1245,
		SkillDescKeys = T.RT_1246,
		SkillDescValues = T.RT_1247,
		SkillGrade = T.RT_2,
		SkillId = 420102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
	}
T.RT_1249 = {
		[0] = T.RT_1248,
		[1] = T.RT_1248,
		[2] = T.RT_1248,
		[3] = T.RT_1248,
		[4] = T.RT_1248,
		[5] = T.RT_1248,
		[6] = T.RT_1248,
	}
T.RT_1250 = {
		420101,
	}
T.RT_1251 = {
		[1] = "$#Buff[420124].AddAttrs[1].Value*100$%",
	}
T.RT_1252 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_1250,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Yuming03",
		SkillDesc = "SKILL_420103_DESC",
		SkillDescKeys = T.RT_1022,
		SkillDescValues = T.RT_1251,
		SkillGrade = T.RT_2,
		SkillId = 420103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420103_NAME",
		SkillType = "Passive",
	}
T.RT_1253 = {
		[0] = T.RT_1252,
		[1] = T.RT_1252,
		[2] = T.RT_1252,
		[3] = T.RT_1252,
		[4] = T.RT_1252,
		[5] = T.RT_1252,
		[6] = T.RT_1252,
	}
T.RT_1254 = {
		420102,
	}
T.RT_1255 = {
		PassiveEffects = T.RT_1254,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_420104_DESC",
		SkillGrade = T.RT_2,
		SkillId = 420104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
	}
T.RT_1256 = {
		[0] = T.RT_1255,
		[1] = T.RT_1255,
		[2] = T.RT_1255,
		[3] = T.RT_1255,
		[4] = T.RT_1255,
		[5] = T.RT_1255,
		[6] = T.RT_1255,
	}
T.RT_1257 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 420112,
		SkillGrade = T.RT_844,
		SkillId = 420111,
		SkillLevel = T.RT_8,
		SkillType = "FallAttack",
		SkillWeaponType = "Melee",
	}
T.RT_1258 = {
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_61,
		BeginNodeId = 420114,
		SkillGrade = T.RT_846,
		SkillId = 420111,
		SkillLevel = T.RT_8,
		SkillType = "FallAttack",
		SkillWeaponType = "Melee",
	}
T.RT_1259 = {
		[0] = T.RT_1257,
		[1] = T.RT_1258,
		[2] = T.RT_1258,
		[3] = T.RT_1258,
		[4] = T.RT_1258,
		[5] = T.RT_1258,
		[6] = T.RT_1258,
	}
T.RT_1260 = {
		420191,
	}
T.RT_1261 = {
		[1] = "$#Buff[420192].AddAttrs[1].Value*100$%",
	}
T.RT_1262 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_1260,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_420191_DESC",
		SkillDescKeys = T.RT_1056,
		SkillDescValues = T.RT_1261,
		SkillGrade = T.RT_2,
		SkillId = 420191,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420191_NAME",
		SkillType = "PhantomPassive",
	}
T.RT_1263 = {
		[0] = T.RT_1262,
		[1] = T.RT_1262,
		[2] = T.RT_1262,
		[3] = T.RT_1262,
		[4] = T.RT_1262,
		[5] = T.RT_1262,
		[6] = T.RT_1262,
	}
T.RT_1264 = {
		"Term_4202_Skill01",
		"Term_4202_Skill01Buff",
	}
T.RT_1265 = {
		SKILL_SECTIONDESC_4202_Skill01_01 = T.RT_541,
	}
T.RT_1266 = {
		[1] = T.RT_1265,
	}
T.RT_1267 = {
		[1] = T.RT_167,
		[2] = T.RT_176,
		[3] = T.RT_168,
		[4] = T.RT_169,
		[6] = T.RT_168,
	}
T.RT_1268 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SpChangeScd",
		[3] = "SKILL_DESC_Damage",
		[4] = "SKILL_DESC_EffectRadius",
		[5] = "SKILL_DESC_4202Skill01DebuffRate",
		[6] = "SKILL_DESC_4202Skill01DebuffDmg",
	}
T.RT_1269 = {
		[1] = "$#SkillNode[420211].CostSp$",
		[2] = "$math.abs(#Buff[420211].DotDatas[1].Value)$",
		[3] = "$#SkillEffects[420214].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_DEF\")$+$#SkillEffects[420214].TaskEffects[1].Value$",
		[4] = "$#TargetFilter[#SkillEffects[420214].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#Buff[420213].AddAttrs[1].Rate* (-100)$%",
		[6] = "$#Buff[420213].DotDatas[1].Rate*100$%$GText(\"SKILL_DESC_DEF\")$",
	}
T.RT_1270 = {
		420211,
	}
T.RT_1271 = {
		AllowSkillIntensity = true,
		BeginNodeId = 420211,
		CD = 2,
		CDType = 420201,
		ExplanationId = T.RT_1264,
		SkillBtnDesc = "SKILL_ICON_Defence",
		SkillBtnIcon = "Skill_Landi01_On",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Landi_Skill01",
		SkillDesc = "SKILL_420201_DESC",
		SkillDescGroups = T.RT_1266,
		SkillDescHints = T.RT_1267,
		SkillDescKeys = T.RT_1268,
		SkillDescValues = T.RT_1269,
		SkillGrade = T.RT_2,
		SkillId = 420201,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420201_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_1270,
		bEnablePrediction = true,
	}
T.RT_1272 = {
		[0] = T.RT_1271,
		[1] = T.RT_1271,
		[2] = T.RT_1271,
		[3] = T.RT_1271,
		[4] = T.RT_1271,
		[5] = T.RT_1271,
		[6] = T.RT_1271,
	}
T.RT_1273 = {
		SKILL_SECTIONDESC_4202_Skill02_01 = T.RT_578,
	}
T.RT_1274 = {
		[1] = T.RT_1273,
	}
T.RT_1275 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_168,
		[4] = T.RT_230,
		[6] = T.RT_169,
	}
T.RT_1276 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_4202Skill02EsDamage",
		[3] = "SKILL_DESC_4202Skill02EsConvertRate",
		[4] = "SKILL_DESC_4202Skill02Sustain",
		[5] = "SKILL_DESC_ParalysisSustain",
		[6] = "SKILL_DESC_EffectRadius",
	}
T.RT_1277 = {
		[1] = "$#SkillNode[420221].CostSp$",
		[2] = "$#SkillEffects[420223].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_DEF\")$+$#SkillEffects[420223].TaskEffects[1].Value$",
		[3] = "$#SkillEffects[420222].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_DEF\")$+$#SkillEffects[420222].TaskEffects[1].Value$",
		[4] = "$#SkillCreature[420202].TimeLife$",
		[5] = "$#SkillEffects[420225].TaskEffects[1].LastTime$",
		[6] = "$#TargetFilter[#SkillEffects[420223].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_1278 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 420221,
		CD = 3.6,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Landi02",
		SkillDemo = "Landi_Skill02",
		SkillDesc = "SKILL_420202_DESC",
		SkillDescGroups = T.RT_1274,
		SkillDescHints = T.RT_1275,
		SkillDescKeys = T.RT_1276,
		SkillDescValues = T.RT_1277,
		SkillGrade = T.RT_2,
		SkillId = 420202,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420202_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1279 = {
		[0] = T.RT_1278,
		[1] = T.RT_1278,
		[2] = T.RT_1278,
		[3] = T.RT_1278,
		[4] = T.RT_1278,
		[5] = T.RT_1278,
		[6] = T.RT_1278,
	}
T.RT_1280 = {
		420201,
	}
T.RT_1281 = {
		[3] = T.RT_230,
	}
T.RT_1282 = {
		[1] = "SKILL_DESC_DefUpLayer",
		[2] = "SKILL_DESC_DefUpLayerSup",
		[3] = "SKILL_DESC_Sustain",
	}
T.RT_1283 = {
		[1] = "$#PassiveEffect[420201].Vars.DefRate*100$%$GText(\"SKILL_DESC_DEF\")$",
		[2] = "$#Buff[420201].AddAttrs[1].SupLimitValue$",
		[3] = "$#PassiveEffect[420201].Vars.DefLastTime$",
	}
T.RT_1284 = {
		PassiveEffects = T.RT_1280,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Landi03",
		SkillDesc = "SKILL_420203_DESC",
		SkillDescHints = T.RT_1281,
		SkillDescKeys = T.RT_1282,
		SkillDescValues = T.RT_1283,
		SkillGrade = T.RT_2,
		SkillId = 420203,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420203_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_1285 = {
		[0] = T.RT_1284,
		[1] = T.RT_1284,
		[2] = T.RT_1284,
		[3] = T.RT_1284,
		[4] = T.RT_1284,
		[5] = T.RT_1284,
		[6] = T.RT_1284,
	}
T.RT_1286 = {
		420202,
	}
T.RT_1287 = {
		[1] = T.RT_167,
	}
T.RT_1288 = {
		[1] = "SKILL_DESC_SpCost",
	}
T.RT_1289 = {
		[1] = "$#PassiveEffect[420202].Vars.SpCost$",
	}
T.RT_1290 = {
		PassiveEffects = T.RT_1286,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_420204_DESC",
		SkillDescHints = T.RT_1287,
		SkillDescKeys = T.RT_1288,
		SkillDescValues = T.RT_1289,
		SkillGrade = T.RT_2,
		SkillId = 420204,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_420204_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_1291 = {
		[0] = T.RT_1290,
		[1] = T.RT_1290,
		[2] = T.RT_1290,
		[3] = T.RT_1290,
		[4] = T.RT_1290,
		[5] = T.RT_1290,
		[6] = T.RT_1290,
	}
T.RT_1292 = {
		BeginNodeId = 420241,
		CD = 2,
		CDType = 420201,
		SkillBtnDesc = "SKILL_ICON_Defence",
		SkillBtnIcon = "Skill_Landi01_Off",
		SkillBtnStyle = "Common_Btn",
		SkillGrade = T.RT_2,
		SkillId = 420211,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_328,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1293 = {
		[0] = T.RT_1292,
		[1] = T.RT_1292,
		[2] = T.RT_1292,
		[3] = T.RT_1292,
		[4] = T.RT_1292,
		[5] = T.RT_1292,
		[6] = T.RT_1292,
	}
T.RT_1294 = {
		FuncName = "ExecuteSupportSkill",
		Id = 421,
	}
T.RT_1295 = {
		421,
	}
T.RT_1296 = {
		[1] = "$#SkillEffects[42101].TaskEffects[1].Rate*100$%",
		[2] = "$#Buff[421].AddAttrs[1].Value*100$%",
		[3] = "$#SkillEffects[42102].TaskEffects[1].LastTime$",
	}
T.RT_1297 = {
		AllowUseSkillInAir = true,
		CD = 20,
		ExecutePassiveFunc = T.RT_1294,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1295,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Heiyao",
		SkillDesc = "PET_421_SKILL",
		SkillDescValues = T.RT_1296,
		SkillGrade = T.RT_2,
		SkillId = 421,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1298 = {
		[0] = T.RT_1297,
		[1] = T.RT_1297,
		[2] = T.RT_1297,
		[3] = T.RT_1297,
		[4] = T.RT_1297,
		[5] = T.RT_1297,
		[6] = T.RT_1297,
	}
T.RT_1299 = {
		FuncName = "ExecuteSupportSkill",
		Id = 422,
	}
T.RT_1300 = {
		422,
	}
T.RT_1301 = {
		[1] = "$#Buff[422].AddAttrs[1].Value*100$%",
		[2] = "$#Buff[422].AddAttrs[1].Value*100*4$%",
		[3] = "$#SkillEffects[42201].TaskEffects[1].LastTime$",
	}
T.RT_1302 = {
		AllowUseSkillInAir = true,
		CD = 20,
		ExecutePassiveFunc = T.RT_1299,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1300,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Jinqing",
		SkillDesc = "PET_422_SKILL",
		SkillDescValues = T.RT_1301,
		SkillGrade = T.RT_2,
		SkillId = 422,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1303 = {
		[0] = T.RT_1302,
		[1] = T.RT_1302,
		[2] = T.RT_1302,
		[3] = T.RT_1302,
		[4] = T.RT_1302,
		[5] = T.RT_1302,
		[6] = T.RT_1302,
	}
T.RT_1304 = {
		FuncName = "ExecuteSupportSkill",
		Id = 423,
	}
T.RT_1305 = {
		423,
	}
T.RT_1306 = {
		[1] = "$#SkillEffects[42301].TaskEffects[1].Rate*100$%",
		[2] = "$#Buff[423].AddAttrs[1].Value*100$%",
		[3] = "$#SkillEffects[42302].TaskEffects[1].LastTime$",
	}
T.RT_1307 = {
		AllowUseSkillInAir = true,
		CD = 20,
		ExecutePassiveFunc = T.RT_1304,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1305,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Manao",
		SkillDesc = "PET_423_SKILL",
		SkillDescValues = T.RT_1306,
		SkillGrade = T.RT_2,
		SkillId = 423,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1308 = {
		[0] = T.RT_1307,
		[1] = T.RT_1307,
		[2] = T.RT_1307,
		[3] = T.RT_1307,
		[4] = T.RT_1307,
		[5] = T.RT_1307,
		[6] = T.RT_1307,
	}
T.RT_1309 = {
		FuncName = "ExecuteSupportSkill",
		Id = 424,
	}
T.RT_1310 = {
		424,
	}
T.RT_1311 = {
		[1] = "$#SkillEffects[42401].TaskEffects[1].SpChange$",
		[2] = "$#Buff[424].AddAttrs[1].Value*100$%",
		[3] = "$#SkillEffects[42401].TaskEffects[2].LastTime$",
	}
T.RT_1312 = {
		AllowUseSkillInAir = true,
		CD = 40,
		ExecutePassiveFunc = T.RT_1309,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1310,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Zijing",
		SkillDesc = "PET_424_SKILL",
		SkillDescValues = T.RT_1311,
		SkillGrade = T.RT_2,
		SkillId = 424,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1313 = {
		[0] = T.RT_1312,
		[1] = T.RT_1312,
		[2] = T.RT_1312,
		[3] = T.RT_1312,
		[4] = T.RT_1312,
		[5] = T.RT_1312,
		[6] = T.RT_1312,
	}
T.RT_1314 = {
		FuncName = "ExecuteSupportSkill",
		Id = 425,
	}
T.RT_1315 = {
		425,
	}
T.RT_1316 = {
		[1] = "$#Buff[425].AddAttrs[1].Value*100$%",
		[2] = "$#SkillEffects[42501].TaskEffects[1].LastTime$",
		[3] = "$#SkillEffects[42502].TaskEffects[1].Rate*100$%",
	}
T.RT_1317 = {
		AllowUseSkillInAir = true,
		CD = 30,
		ExecutePassiveFunc = T.RT_1314,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1315,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Bixi",
		SkillDesc = "PET_425_SKILL",
		SkillDescValues = T.RT_1316,
		SkillGrade = T.RT_2,
		SkillId = 425,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1318 = {
		[0] = T.RT_1317,
		[1] = T.RT_1317,
		[2] = T.RT_1317,
		[3] = T.RT_1317,
		[4] = T.RT_1317,
		[5] = T.RT_1317,
		[6] = T.RT_1317,
	}
T.RT_1319 = {
		FuncName = "ExecuteSupportSkill",
		Id = 426,
	}
T.RT_1320 = {
		426,
	}
T.RT_1321 = {
		[1] = "$#SkillEffects[42601].TaskEffects[1].Rate*100$%",
		[2] = "$#Buff[426].AddAttrs[1].Value*100$%",
		[3] = "$#SkillEffects[42602].TaskEffects[1].LastTime$",
	}
T.RT_1322 = {
		AllowUseSkillInAir = true,
		CD = 20,
		ExecutePassiveFunc = T.RT_1319,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1320,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Oubo",
		SkillDesc = "PET_426_SKILL",
		SkillDescValues = T.RT_1321,
		SkillGrade = T.RT_2,
		SkillId = 426,
		SkillLevel = T.RT_246,
		SkillType = "Support",
	}
T.RT_1323 = {
		[0] = T.RT_1322,
		[1] = T.RT_1322,
		[2] = T.RT_1322,
		[3] = T.RT_1322,
		[4] = T.RT_1322,
		[5] = T.RT_1322,
		[6] = T.RT_1322,
	}
T.RT_1324 = {
		"Term_4301_Skill01",
	}
T.RT_1325 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_169,
		[4] = T.RT_168,
	}
T.RT_1326 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_4301Skill01Damage",
		[3] = "SKILL_DESC_4301Skill01Radius",
		[4] = "SKILL_DESC_4301Skill01DamageSp",
		[5] = "SKILL_DESC_4301Skill01RadiusSp",
		[6] = "SKILL_DESC_4301Skill01SecondEnergy",
	}
T.RT_1327 = {
		[1] = "$#SkillNode[430111].CostSp$",
		[2] = "$#SkillEffects[430113].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[430113].TaskEffects[1].Value$",
		[3] = "$#TargetFilter[#SkillEffects[430113].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[430115].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[430115].TaskEffects[1].Value$",
		[5] = "$#SkillCreature[430113].ShapeInfo.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#PassiveEffect[430101].Vars.Skill01Energy$",
	}
T.RT_1328 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		BeginNodeId = 430111,
		ExplanationId = T.RT_1324,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Xibi01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Xibi_Skill01",
		SkillDesc = "SKILL_430101_DESC",
		SkillDescHints = T.RT_1325,
		SkillDescKeys = T.RT_1326,
		SkillDescValues = T.RT_1327,
		SkillGrade = T.RT_2,
		SkillId = 430101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_430101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1329 = {
		[0] = T.RT_1328,
		[1] = T.RT_1328,
		[2] = T.RT_1328,
		[3] = T.RT_1328,
		[4] = T.RT_1328,
		[5] = T.RT_1328,
		[6] = T.RT_1328,
	}
T.RT_1330 = {
		"Term_4301_Skill02",
		"Term_4301_Skill02Damage",
	}
T.RT_1331 = {
		SKILL_SECTIONDESC_4301_Skill02_01 = T.RT_745,
	}
T.RT_1332 = {
		7,
		8,
	}
T.RT_1333 = {
		SKILL_SECTIONDESC_4301_Skill02_02 = T.RT_1332,
	}
T.RT_1334 = {
		[1] = T.RT_1331,
		[2] = T.RT_1333,
	}
T.RT_1335 = {
		[1] = T.RT_167,
		[3] = T.RT_169,
		[4] = T.RT_168,
		[5] = T.RT_168,
		[7] = T.RT_168,
		[8] = T.RT_169,
	}
T.RT_1336 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_4301Skill02LastTime",
		[3] = "SKILL_DESC_4301Skill02Radius",
		[4] = "SKILL_DESC_4301Skill02LinkDamage",
		[5] = "SKILL_DESC_4301Skill02LinkDamageSp",
		[6] = "SKILL_DESC_4301Skill02DamageRate",
		[7] = "SKILL_DESC_4301Skill02ExploreDamage",
		[8] = "SKILL_DESC_4301Skill02ExploreRange",
		[9] = "SKILL_DESC_4301Skill02SecondEnergy",
	}
T.RT_1337 = {
		[1] = "$#SkillNode[430121].CostSp$",
		[2] = "$#SkillEffects[430121].TaskEffects[1].LifeTime$$GText(\"SKILL_DESC_Second\")$",
		[3] = "$#TargetFilter[#SkillEffects[430123].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[4] = "$#SkillEffects[430122].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[430122].TaskEffects[1].Value$",
		[5] = "$#SkillEffects[430125].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[430125].TaskEffects[1].Value$",
		[6] = "$#PassiveEffect[430101].Vars.Skill02LinkRate*100$%",
		[7] = "$#SkillEffects[430123].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[430123].TaskEffects[1].Value$",
		[8] = "$#TargetFilter[#SkillEffects[430123].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[9] = "$#PassiveEffect[430101].Vars.Skill02Energy$",
	}
T.RT_1338 = {
		AllowSkillIntensity = true,
		BeginNodeId = 430121,
		CD = 2.4,
		ExplanationId = T.RT_1330,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Summon",
		SkillBtnIcon = "Skill_Xibi02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Xibi_Skill02",
		SkillDesc = "SKILL_430102_DESC",
		SkillDescGroups = T.RT_1334,
		SkillDescHints = T.RT_1335,
		SkillDescKeys = T.RT_1336,
		SkillDescValues = T.RT_1337,
		SkillGrade = T.RT_2,
		SkillId = 430102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_430102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1339 = {
		[0] = T.RT_1338,
		[1] = T.RT_1338,
		[2] = T.RT_1338,
		[3] = T.RT_1338,
		[4] = T.RT_1338,
		[5] = T.RT_1338,
		[6] = T.RT_1338,
	}
T.RT_1340 = {
		430101,
	}
T.RT_1341 = {
		[1] = "SKILL_DESC_4301Skill03EnergyAdd",
	}
T.RT_1342 = {
		[1] = "$#PassiveEffect[430101].Vars.EnergyAdd$",
	}
T.RT_1343 = {
		PassiveEffects = T.RT_1340,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Xibi03",
		SkillDesc = "SKILL_430103_DESC",
		SkillDescKeys = T.RT_1341,
		SkillDescValues = T.RT_1342,
		SkillGrade = T.RT_2,
		SkillId = 430103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_430103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_1344 = {
		[0] = T.RT_1343,
		[1] = T.RT_1343,
		[2] = T.RT_1343,
		[3] = T.RT_1343,
		[4] = T.RT_1343,
		[5] = T.RT_1343,
		[6] = T.RT_1343,
	}
T.RT_1345 = {
		430102,
	}
T.RT_1346 = {
		[1] = "SKILL_DESC_4301Skill04Rate",
	}
T.RT_1347 = {
		[1] = "$#PassiveEffect[430102].Vars.Rate*100$%$GText(\"SKILL_DESC_MeleeTriggerProb\")$",
	}
T.RT_1348 = {
		PassiveEffects = T.RT_1345,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_430104_DESC",
		SkillDescKeys = T.RT_1346,
		SkillDescValues = T.RT_1347,
		SkillGrade = T.RT_2,
		SkillId = 430104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_430104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_1349 = {
		[0] = T.RT_1348,
		[1] = T.RT_1348,
		[2] = T.RT_1348,
		[3] = T.RT_1348,
		[4] = T.RT_1348,
		[5] = T.RT_1348,
		[6] = T.RT_1348,
	}
T.RT_1350 = {
		510001,
	}
T.RT_1351 = {
		[1] = "$#Buff[510002].AddAttrs[1].Rate*100$%",
	}
T.RT_1352 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_1350,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_510001_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_1351,
		SkillGrade = T.RT_2,
		SkillId = 510001,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510001_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_1353 = {
		[0] = T.RT_1352,
		[1] = T.RT_1352,
		[2] = T.RT_1352,
		[3] = T.RT_1352,
		[4] = T.RT_1352,
		[5] = T.RT_1352,
		[6] = T.RT_1352,
	}
T.RT_1354 = {
		510003,
	}
T.RT_1355 = {
		[1] = "$#Buff[510004].AddAttrs[1].Rate*100$%",
	}
T.RT_1356 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_1354,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_510003_DESC",
		SkillDescKeys = T.RT_6,
		SkillDescValues = T.RT_1355,
		SkillGrade = T.RT_2,
		SkillId = 510003,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510003_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_1357 = {
		[0] = T.RT_1356,
		[1] = T.RT_1356,
		[2] = T.RT_1356,
		[3] = T.RT_1356,
		[4] = T.RT_1356,
		[5] = T.RT_1356,
		[6] = T.RT_1356,
	}
T.RT_1358 = {
		"Term_5101_Skill01",
	}
T.RT_1359 = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
	}
T.RT_1360 = {
		SKILL_SECTIONDESC_5101_Skill01_01 = T.RT_1359,
	}
T.RT_1361 = {
		8,
		9,
		10,
	}
T.RT_1362 = {
		SKILL_SECTIONDESC_5101_Skill01_02 = T.RT_1361,
	}
T.RT_1363 = {
		[1] = T.RT_1360,
		[2] = T.RT_1362,
	}
T.RT_1364 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_168,
		[4] = T.RT_169,
		[5] = T.RT_168,
		[7] = T.RT_230,
		[8] = T.RT_167,
		[9] = T.RT_168,
		[10] = T.RT_169,
	}
T.RT_1365 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_PathDamage",
		[3] = "SKILL_DESC_GoalDamage",
		[4] = "SKILL_DESC_GoalDamageRadius",
		[5] = "SKILL_DESC_Heal",
		[6] = "SKILL_DESC_DmgUp",
		[7] = "SKILL_DESC_DmgUpTime",
		[8] = "SKILL_DESC_5101SpCostDot",
		[9] = "SKILL_DESC_5101GoalDamage",
		[10] = "SKILL_DESC_5101GoalDamageRadius",
	}
T.RT_1366 = {
		[1] = "$#SkillNode[510111].CostSp$",
		[2] = "$#SkillEffects[510101].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[510101].TaskEffects[1].Value$",
		[3] = "$#SkillEffects[510102].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[510102].TaskEffects[1].Value$",
		[4] = "$#TargetFilter[#SkillEffects[510102].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#SkillEffects[510114].TaskEffects[2].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[510114].TaskEffects[2].Value$",
		[6] = "$#Buff[510101].AddAttrs[1].Value*100$%",
		[7] = "$#SkillEffects[510114].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[8] = "$(-#Buff[510122].DotDatas[1].Value)$",
		[9] = "$#SkillEffects[510113].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[510113].TaskEffects[1].Value$",
		[10] = "$#TargetFilter[#SkillEffects[510113].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_1367 = {
		510111,
	}
T.RT_1368 = {
		AllowEightOrient = "OptionalLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 510111,
		ExplanationId = T.RT_1358,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Songlu01",
		SkillBtnStyle = "Switch",
		SkillDemo = "Songlu_Skill01",
		SkillDesc = "SKILL_510101_DESC",
		SkillDescGroups = T.RT_1363,
		SkillDescHints = T.RT_1364,
		SkillDescKeys = T.RT_1365,
		SkillDescValues = T.RT_1366,
		SkillGrade = T.RT_2,
		SkillId = 510101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		SubSkills = T.RT_1367,
		bEnablePrediction = true,
	}
T.RT_1369 = {
		[0] = T.RT_1368,
		[1] = T.RT_1368,
		[2] = T.RT_1368,
		[3] = T.RT_1368,
		[4] = T.RT_1368,
		[5] = T.RT_1368,
		[6] = T.RT_1368,
	}
T.RT_1370 = {
		"Term_5101_Skill02_Value",
	}
T.RT_1371 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_168,
		[4] = T.RT_168,
		[5] = T.RT_168,
	}
T.RT_1372 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_PathDamage",
		[3] = "SKILL_DESC_5101AtkDamage1",
		[4] = "SKILL_DESC_5101AtkDamage2",
		[5] = "SKILL_DESC_5101FallAtkDamage",
	}
T.RT_1373 = {
		[1] = "$#SkillNode[510121].CostSp$",
		[2] = "$#SkillEffects[510126].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[510126].TaskEffects[1].Value$",
		[3] = "$#SkillEffects[510141].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[510141].TaskEffects[1].Value$",
		[4] = "$#SkillEffects[510142].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[510142].TaskEffects[1].Value$",
		[5] = "$#SkillEffects[510152].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$+$#SkillEffects[510152].TaskEffects[1].Value$",
	}
T.RT_1374 = {
		510121,
	}
T.RT_1375 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 510121,
		CD = 3.4,
		CDType = 510102,
		ExplanationId = T.RT_1370,
		IgnoreTimeDilation = true,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Songlu02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Songlu_Skill02",
		SkillDesc = "SKILL_510102_DESC",
		SkillDescHints = T.RT_1371,
		SkillDescKeys = T.RT_1372,
		SkillDescValues = T.RT_1373,
		SkillGrade = T.RT_2,
		SkillId = 510102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_1374,
	}
T.RT_1376 = {
		[0] = T.RT_1375,
		[1] = T.RT_1375,
		[2] = T.RT_1375,
		[3] = T.RT_1375,
		[4] = T.RT_1375,
		[5] = T.RT_1375,
		[6] = T.RT_1375,
	}
T.RT_1377 = {
		510101,
	}
T.RT_1378 = {
		[1] = "SKILL_DESC_DmgUpLayer",
		[2] = "SKILL_DESC_DmgdDownLayer",
		[3] = "SKILL_DESC_Sustain",
	}
T.RT_1379 = {
		[1] = "$#Buff[510103].AddAttrs[1].Value*100$%",
		[2] = "$math.abs(#Buff[510103].BuffDamagedRate.Value)*100$%",
		[3] = "$#PassiveEffect[510101].Vars.LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1380 = {
		510107,
	}
T.RT_1381 = {
		PassiveEffects = T.RT_1377,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Songlu03",
		SkillDesc = "SKILL_510103_DESC",
		SkillDescHints = T.RT_1281,
		SkillDescKeys = T.RT_1378,
		SkillDescValues = T.RT_1379,
		SkillGrade = T.RT_2,
		SkillId = 510103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510103_NAME",
		SkillType = "Passive",
		SubSkills = T.RT_1380,
		bEnablePrediction = true,
	}
T.RT_1382 = {
		[0] = T.RT_1381,
		[1] = T.RT_1381,
		[2] = T.RT_1381,
		[3] = T.RT_1381,
		[4] = T.RT_1381,
		[5] = T.RT_1381,
		[6] = T.RT_1381,
	}
T.RT_1383 = {
		AllowSkillIntensity = true,
		BeginNodeId = 510141,
		SkillGrade = T.RT_2,
		SkillId = 510104,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Attack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_1384 = {
		[0] = T.RT_1383,
		[1] = T.RT_1383,
		[2] = T.RT_1383,
		[3] = T.RT_1383,
		[4] = T.RT_1383,
		[5] = T.RT_1383,
		[6] = T.RT_1383,
	}
T.RT_1385 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 510151,
		SkillGrade = T.RT_2,
		SkillId = 510105,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "FallAttack",
		SkillWeaponType = "Ultra",
		bEnablePrediction = true,
	}
T.RT_1386 = {
		[0] = T.RT_1385,
		[1] = T.RT_1385,
		[2] = T.RT_1385,
		[3] = T.RT_1385,
		[4] = T.RT_1385,
		[5] = T.RT_1385,
		[6] = T.RT_1385,
	}
T.RT_1387 = {
		510103,
	}
T.RT_1388 = {
		[1] = "$#PassiveEffect[510103].Vars.BulletDropProb*100$%",
	}
T.RT_1389 = {
		PassiveEffects = T.RT_1387,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_510104_DESC",
		SkillDescKeys = T.RT_256,
		SkillDescValues = T.RT_1388,
		SkillGrade = T.RT_2,
		SkillId = 510106,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_1390 = {
		[0] = T.RT_1389,
		[1] = T.RT_1389,
		[2] = T.RT_1389,
		[3] = T.RT_1389,
		[4] = T.RT_1389,
		[5] = T.RT_1389,
		[6] = T.RT_1389,
	}
T.RT_1391 = {
		BeginNodeId = 510171,
		SkillGrade = T.RT_2,
		SkillId = 510107,
		SkillLevel = T.RT_8,
		SkillType = "Condemn",
		SkillWeaponType = "Condemn",
		bEnablePrediction = true,
	}
T.RT_1392 = {
		[0] = T.RT_1391,
		[1] = T.RT_1391,
		[2] = T.RT_1391,
		[3] = T.RT_1391,
		[4] = T.RT_1391,
		[5] = T.RT_1391,
		[6] = T.RT_1391,
	}
T.RT_1393 = {
		510115,
	}
T.RT_1394 = {
		510116,
	}
T.RT_1395 = {
		510113,
	}
T.RT_1396 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginContinuousSkillEffect = T.RT_1393,
		CD = 1,
		EndContinuousSkillEffect = T.RT_1394,
		IgnoreTimeDilation = true,
		IsContinuousSkill = true,
		LongPressSkill = 510111,
		NotEnterCD = true,
		NotExecute = true,
		NotExecuteSpCost = 6,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Songlu01_02",
		SkillBtnStyle = "Switch",
		SkillDemo = "Songlu_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 510111,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		SubSkills = T.RT_1395,
		UseSkillCondition = 510104,
	}
T.RT_1397 = {
		[0] = T.RT_1396,
		[1] = T.RT_1396,
		[2] = T.RT_1396,
		[3] = T.RT_1396,
		[4] = T.RT_1396,
		[5] = T.RT_1396,
		[6] = T.RT_1396,
	}
T.RT_1398 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 510112,
		IgnoreTimeDilation = true,
		SkillGrade = T.RT_2,
		SkillId = 510113,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1399 = {
		[0] = T.RT_1398,
		[1] = T.RT_1398,
		[2] = T.RT_1398,
		[3] = T.RT_1398,
		[4] = T.RT_1398,
		[5] = T.RT_1398,
		[6] = T.RT_1398,
	}
T.RT_1400 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 510122,
		CD = 3.4,
		CDType = 510102,
		CombatConditionID = 510103,
		IgnoreTimeDilation = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Songlu02_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Songlu_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 510121,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
	}
T.RT_1401 = {
		[0] = T.RT_1400,
		[1] = T.RT_1400,
		[2] = T.RT_1400,
		[3] = T.RT_1400,
		[4] = T.RT_1400,
		[5] = T.RT_1400,
		[6] = T.RT_1400,
	}
T.RT_1402 = {
		510191,
	}
T.RT_1403 = {
		[1] = "SKILL_DESC_Enmity",
	}
T.RT_1404 = {
		[1] = "$#Buff[510192].AddAttrs[1].Value*100$%",
	}
T.RT_1405 = {
		OnlyPhantom = true,
		PassiveEffects = T.RT_1402,
		SkillBtnDesc = "SKILL_ICON_Phantom",
		SkillBtnIcon = "Skill_PhantomPassive",
		SkillDesc = "SKILL_510191_DESC",
		SkillDescKeys = T.RT_1403,
		SkillDescValues = T.RT_1404,
		SkillGrade = T.RT_2,
		SkillId = 510191,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510191_NAME",
		SkillType = "PhantomPassive",
		bEnablePrediction = true,
	}
T.RT_1406 = {
		[0] = T.RT_1405,
		[1] = T.RT_1405,
		[2] = T.RT_1405,
		[3] = T.RT_1405,
		[4] = T.RT_1405,
		[5] = T.RT_1405,
		[6] = T.RT_1405,
	}
T.RT_1407 = {
		"Term_5102_Skill01",
	}
T.RT_1408 = {
		[1] = T.RT_167,
		[2] = T.RT_230,
	}
T.RT_1409 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_5102Skill01Buff",
	}
T.RT_1410 = {
		[1] = "$#SkillNode[510211].CostSp$",
		[2] = "$#SkillEffects[510211].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1411 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 510211,
		ExplanationId = T.RT_1407,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Aote01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Aote_Skill01",
		SkillDesc = "SKILL_510201_DESC",
		SkillDescHints = T.RT_1408,
		SkillDescKeys = T.RT_1409,
		SkillDescValues = T.RT_1410,
		SkillGrade = T.RT_1007,
		SkillId = 510201,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510201_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
	}
T.RT_1412 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 510212,
		ExplanationId = T.RT_1407,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Aote01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Aote_Skill01",
		SkillDesc = "SKILL_510201_DESC",
		SkillDescHints = T.RT_1408,
		SkillDescKeys = T.RT_1409,
		SkillDescValues = T.RT_1410,
		SkillGrade = T.RT_1009,
		SkillId = 510201,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510201_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
	}
T.RT_1413 = {
		[0] = T.RT_1411,
		[1] = T.RT_1411,
		[2] = T.RT_1411,
		[3] = T.RT_1411,
		[4] = T.RT_1412,
		[5] = T.RT_1412,
		[6] = T.RT_1412,
	}
T.RT_1414 = {
		"Term_5102_Skill02",
	}
T.RT_1415 = {
		[1] = T.RT_167,
		[2] = T.RT_230,
		[3] = T.RT_230,
	}
T.RT_1416 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_5102Skill02Buff",
		[3] = "SKILL_DESC_5102Skill02BuffAdd",
		[4] = "SKILL_DESC_5102Skill02BuffAddMax",
		[5] = "SKILL_DESC_5102Skill02Hp",
		[6] = "SKILL_DESC_AtkSpeedUp",
		[7] = "SKILL_DESC_Enmity",
	}
T.RT_1417 = {
		[1] = "$#SkillNode[510221].CostSp$",
		[2] = "$#PassiveEffect[510201].Vars.Skill02BuffTime$$GText(\"SKILL_DESC_Second\")$",
		[3] = "$#PassiveEffect[510201].Vars.Skill02BuffTimePerNum$$GText(\"SKILL_DESC_Second\")$",
		[4] = "$#PassiveEffect[510201].Vars.Skill02BuffTimeMax$$GText(\"SKILL_DESC_Second\")$",
		[5] = "$#PassiveEffect[510201].Vars.Skill02HpValue*100$%$GText(\"SKILL_DESC_MaxHp\")$",
		[6] = "$#Buff[510221].AddAttrs[1].Value*100$%",
		[7] = "$#Buff[510221].AddAttrs[2].Value*100$%",
	}
T.RT_1418 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 510221,
		ExplanationId = T.RT_1414,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Aote02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Aote_Skill02",
		SkillDesc = "SKILL_510202_DESC",
		SkillDescHints = T.RT_1415,
		SkillDescKeys = T.RT_1416,
		SkillDescValues = T.RT_1417,
		SkillGrade = T.RT_2,
		SkillId = 510202,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510202_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
	}
T.RT_1419 = {
		[0] = T.RT_1418,
		[1] = T.RT_1418,
		[2] = T.RT_1418,
		[3] = T.RT_1418,
		[4] = T.RT_1418,
		[5] = T.RT_1418,
		[6] = T.RT_1418,
	}
T.RT_1420 = {
		"Term_5102_Skill03",
	}
T.RT_1421 = {
		510201,
	}
T.RT_1422 = {
		[2] = T.RT_230,
		[3] = T.RT_168,
	}
T.RT_1423 = {
		[1] = "SKILL_DESC_5102Skill03DmgUp",
		[2] = "SKILL_DESC_5102Skill03DmgUpTime",
		[3] = "SKILL_DESC_5102Skill03Dmg",
	}
T.RT_1424 = {
		[1] = "$#PassiveEffect[510201].Vars.DemageAddRate*100$%",
		[2] = "$#SkillEffects[510233].TaskEffects[2].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[3] = "$#SkillEffects[510233].TaskEffects[1].Rate*100$%",
	}
T.RT_1425 = {
		AllowSkillIntensity = true,
		ExplanationId = T.RT_1420,
		PassiveEffects = T.RT_1421,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Aote03",
		SkillDesc = "SKILL_510203_DESC",
		SkillDescHints = T.RT_1422,
		SkillDescKeys = T.RT_1423,
		SkillDescValues = T.RT_1424,
		SkillGrade = T.RT_2,
		SkillId = 510203,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510203_NAME",
		SkillType = "Passive",
	}
T.RT_1426 = {
		[0] = T.RT_1425,
		[1] = T.RT_1425,
		[2] = T.RT_1425,
		[3] = T.RT_1425,
		[4] = T.RT_1425,
		[5] = T.RT_1425,
		[6] = T.RT_1425,
	}
T.RT_1427 = {
		510202,
	}
T.RT_1428 = {
		[1] = "$#PassiveEffect[510202].Vars.HitCreateRate*100$%",
	}
T.RT_1429 = {
		PassiveEffects = T.RT_1427,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_510204_DESC",
		SkillDescKeys = T.RT_256,
		SkillDescValues = T.RT_1428,
		SkillGrade = T.RT_2,
		SkillId = 510204,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_510204_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
	}
T.RT_1430 = {
		[0] = T.RT_1429,
		[1] = T.RT_1429,
		[2] = T.RT_1429,
		[3] = T.RT_1429,
		[4] = T.RT_1429,
		[5] = T.RT_1429,
		[6] = T.RT_1429,
	}
T.RT_1431 = {
		"Term_5301_Summon",
		"Term_5301_Skill01",
		"Term_5301_Skill01Mark",
	}
T.RT_1432 = {
		SKILL_SECTIONDESC_5301_Skill01_01 = T.RT_225,
	}
T.RT_1433 = {
		SKILL_SECTIONDESC_5301_Skill01_02 = T.RT_227,
	}
T.RT_1434 = {
		[1] = T.RT_1432,
		[2] = T.RT_1433,
	}
T.RT_1435 = {
		[1] = T.RT_167,
		[3] = T.RT_168,
		[4] = T.RT_169,
		[5] = T.RT_167,
		[6] = T.RT_168,
		[7] = T.RT_168,
		[8] = T.RT_230,
	}
T.RT_1436 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_5301SummonedSlow",
		[3] = "SKILL_DESC_5301SummonedDamage",
		[4] = "SKILL_DESC_5301Skill01Range",
		[5] = "SKILL_DESC_5301Skill01SpCost",
		[6] = "SKILL_DESC_5301Skill01Damage",
		[7] = "SKILL_DESC_5301Skill01Damage2",
		[8] = "SKILL_DESC_5301Skill01Sustain",
	}
T.RT_1437 = {
		[1] = "$#Skill[530101][1][0].NotExecuteSpCost$",
		[2] = "$-#Buff[530141].AddAttrs[1].Value*100$%",
		[3] = "$#SkillEffects[530114].TaskEffects[1].Rate*100$%",
		[4] = "$#TargetFilter[#SkillEffects[530114].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#SkillNode[530111].CostSp$",
		[6] = "$#SkillEffects[530115].TaskEffects[1].Rate*100$%",
		[7] = "$#SkillEffects[530116].TaskEffects[1].Rate*100$%",
		[8] = "$#SkillEffects[530115].TaskEffects[4].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1438 = {
		530111,
	}
T.RT_1439 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		CD = 0.3,
		ExecuteClientPassiveFunc = "ExecuteSkill1",
		ExplanationId = T.RT_1431,
		HideCDToast = 1,
		IgnoreTag = true,
		NotExecute = true,
		NotExecuteSpCost = 30,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Saiqi01_1",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Saiqi_Skill01",
		SkillDesc = "SKILL_530101_DESC",
		SkillDescGroups = T.RT_1434,
		SkillDescHints = T.RT_1435,
		SkillDescKeys = T.RT_1436,
		SkillDescValues = T.RT_1437,
		SkillEffectsList = T.RT_1438,
		SkillGrade = T.RT_844,
		SkillId = 530101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_530101_NAME",
		SkillType = "Skill1",
		SubSkills = T.RT_1438,
		bEnablePrediction = true,
	}
T.RT_1440 = {
		530111,
		530141,
	}
T.RT_1441 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		CD = 0.3,
		ExecuteClientPassiveFunc = "ExecuteSkill1",
		ExplanationId = T.RT_1431,
		HideCDToast = 1,
		IgnoreTag = true,
		NotExecute = true,
		NotExecuteSpCost = 30,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Saiqi01_1",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Saiqi_Skill01",
		SkillDesc = "SKILL_530101_DESC",
		SkillDescGroups = T.RT_1434,
		SkillDescHints = T.RT_1435,
		SkillDescKeys = T.RT_1436,
		SkillDescValues = T.RT_1437,
		SkillEffectsList = T.RT_1440,
		SkillGrade = T.RT_846,
		SkillId = 530101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_530101_NAME",
		SkillType = "Skill1",
		SubSkills = T.RT_1438,
		bEnablePrediction = true,
	}
T.RT_1442 = {
		[0] = T.RT_1439,
		[1] = T.RT_1441,
		[2] = T.RT_1441,
		[3] = T.RT_1441,
		[4] = T.RT_1441,
		[5] = T.RT_1441,
		[6] = T.RT_1441,
	}
T.RT_1443 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_SpChangeScd",
		[3] = "SKILL_DESC_ShootingDamage",
		[4] = "SKILL_DESC_ShootingDamageRadius",
		[5] = "SKILL_DESC_5301ExtraHpConsume",
		[6] = "SKILL_DESC_5301ExtraConvertRate",
	}
T.RT_1444 = {
		[1] = "$#SkillNode[530121].CostSp$",
		[2] = "$math.abs(#Buff[530100].DotDatas[1].Value)$",
		[3] = "$#SkillEffects[530124].TaskEffects[1].Rate*100$%",
		[4] = "$#TargetFilter[#SkillEffects[530124].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[5] = "$#SkillEffects[530128].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_MaxHp\")$",
		[6] = "$(#SkillEffects[530128].TaskEffects[2].Rate)/(#SkillEffects[530128].TaskEffects[1].Rate)*100$%",
	}
T.RT_1445 = {
		530121,
	}
T.RT_1446 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 530121,
		CD = 3.5,
		CDType = 530102,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Saiqi02_On",
		SkillBtnStyle = "Switch",
		SkillDemo = "Saiqi_Skill02",
		SkillDesc = "SKILL_530102_DESC",
		SkillDescHints = T.RT_919,
		SkillDescKeys = T.RT_1443,
		SkillDescValues = T.RT_1444,
		SkillGrade = T.RT_2,
		SkillId = 530102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_530102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_1445,
	}
T.RT_1447 = {
		[0] = T.RT_1446,
		[1] = T.RT_1446,
		[2] = T.RT_1446,
		[3] = T.RT_1446,
		[4] = T.RT_1446,
		[5] = T.RT_1446,
		[6] = T.RT_1446,
	}
T.RT_1448 = {
		530102,
	}
T.RT_1449 = {
		[4] = T.RT_230,
	}
T.RT_1450 = {
		[1] = "Skill_DESC_AtkUp",
		[2] = "SKILL_DESC_SkillIntenUp",
		[3] = "SKILL_DESC_Enmity",
		[4] = "SKILL_DESC_Sustain",
		[5] = "SKILL_DESC_DmgUpPerBuff",
	}
T.RT_1451 = {
		[1] = "$#Buff[530132].AddAttrs[1].Rate*100$%",
		[2] = "$#Buff[530133].AddAttrs[1].Rate*100$%",
		[3] = "$#Buff[530131].AddAttrs[1].Value*100$%",
		[4] = "$#PassiveEffect[530102].Vars.PassiveBuffLastTime$$GText(\"SKILL_DESC_Second\")$",
		[5] = "$#PassiveEffect[530102].Vars.PassiveDmgRate*100$%",
	}
T.RT_1452 = {
		530105,
	}
T.RT_1453 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_1448,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Saiqi03",
		SkillDesc = "SKILL_530103_DESC",
		SkillDescHints = T.RT_1449,
		SkillDescKeys = T.RT_1450,
		SkillDescValues = T.RT_1451,
		SkillGrade = T.RT_2,
		SkillId = 530103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_530103_NAME",
		SkillType = "Passive",
		SubSkills = T.RT_1452,
	}
T.RT_1454 = {
		[0] = T.RT_1453,
		[1] = T.RT_1453,
		[2] = T.RT_1453,
		[3] = T.RT_1453,
		[4] = T.RT_1453,
		[5] = T.RT_1453,
		[6] = T.RT_1453,
	}
T.RT_1455 = {
		530104,
	}
T.RT_1456 = {
		[1] = "SKILL_DESC_Sustain",
	}
T.RT_1457 = {
		[1] = "$#PassiveEffect[530104].Vars.FakeHpLastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1458 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_1455,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_530104_DESC",
		SkillDescHints = T.RT_361,
		SkillDescKeys = T.RT_1456,
		SkillDescValues = T.RT_1457,
		SkillGrade = T.RT_2,
		SkillId = 530104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_530104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
	}
T.RT_1459 = {
		[0] = T.RT_1458,
		[1] = T.RT_1458,
		[2] = T.RT_1458,
		[3] = T.RT_1458,
		[4] = T.RT_1458,
		[5] = T.RT_1458,
		[6] = T.RT_1458,
	}
T.RT_1460 = {
		AllowUseSkillInAir = true,
		BeginNodeId = 530151,
		SkillGrade = T.RT_2,
		SkillId = 530105,
		SkillLevel = T.RT_8,
		SkillType = "Condemn",
		SkillWeaponType = "Condemn",
	}
T.RT_1461 = {
		[0] = T.RT_1460,
		[1] = T.RT_1460,
		[2] = T.RT_1460,
		[3] = T.RT_1460,
		[4] = T.RT_1460,
		[5] = T.RT_1460,
		[6] = T.RT_1460,
	}
T.RT_1462 = {
		FuncName = "FlyingSkill1",
		Id = 530102,
	}
T.RT_1463 = {
		530119,
	}
T.RT_1464 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		CD = 0.6,
		ExecuteClientPassiveFunc = "FlyingSkill1",
		ExecutePassiveFunc = T.RT_1462,
		NotExecute = true,
		NotExecuteSpCost = 30,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Saiqi01_2",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Saiqi_Skill01",
		SkillEffectsList = T.RT_1463,
		SkillGrade = T.RT_844,
		SkillId = 530111,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1465 = {
		530119,
		530141,
	}
T.RT_1466 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		CD = 0.6,
		ExecuteClientPassiveFunc = "FlyingSkill1",
		ExecutePassiveFunc = T.RT_1462,
		NotExecute = true,
		NotExecuteSpCost = 30,
		SkillBtnDesc = "SKILL_ICON_Damage",
		SkillBtnIcon = "Skill_Saiqi01_2",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Saiqi_Skill01",
		SkillEffectsList = T.RT_1465,
		SkillGrade = T.RT_846,
		SkillId = 530111,
		SkillLevel = T.RT_8,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1467 = {
		[0] = T.RT_1464,
		[1] = T.RT_1466,
		[2] = T.RT_1466,
		[3] = T.RT_1466,
		[4] = T.RT_1466,
		[5] = T.RT_1466,
		[6] = T.RT_1466,
	}
T.RT_1468 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 530122,
		CD = 3.5,
		CDType = 530102,
		CombatConditionID = 530102,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Saiqi02_Off",
		SkillBtnStyle = "Switch",
		SkillDemo = "Saiqi_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 530121,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillTags = T.RT_193,
		SkillType = "Skill2",
	}
T.RT_1469 = {
		[0] = T.RT_1468,
		[1] = T.RT_1468,
		[2] = T.RT_1468,
		[3] = T.RT_1468,
		[4] = T.RT_1468,
		[5] = T.RT_1468,
		[6] = T.RT_1468,
	}
T.RT_1470 = {
		AllowEightOrient = "OnlyLockOrient",
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		AttackSpeedType = T.RT_50,
		BeginNodeId = 530123,
		CancelBlockMove = 1,
		ClientSkillLogicId = 530101,
		SkillGrade = T.RT_2,
		SkillId = 530122,
		SkillLevel = T.RT_8,
		SkillType = "Shooting",
		SkillWeaponType = "Ultra",
	}
T.RT_1471 = {
		[0] = T.RT_1470,
		[1] = T.RT_1470,
		[2] = T.RT_1470,
		[3] = T.RT_1470,
		[4] = T.RT_1470,
		[5] = T.RT_1470,
		[6] = T.RT_1470,
	}
T.RT_1472 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_230,
		[4] = T.RT_169,
	}
T.RT_1473 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Hot",
		[3] = "SKILL_DESC_Sustain",
		[4] = "SKILL_DESC_EffectRadius",
	}
T.RT_1474 = {
		[1] = "$#SkillNode[540111].CostSp$",
		[2] = "$#Buff[540111].DotDatas[1].Rate*100$%$GText(\"SKILL_DESC_ATK\")$+$#Buff[540111].DotDatas[1].Value$",
		[3] = "$#SkillEffects[540111].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[4] = "$#Buff[540101].HaloDatas[2].AuraRange/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_1475 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540111,
		SkillBtnDesc = "SKILL_ICON_Heal",
		SkillBtnIcon = "Skill_Dafu01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill01",
		SkillDesc = "SKILL_540101_DESC",
		SkillDescHints = T.RT_1472,
		SkillDescKeys = T.RT_1473,
		SkillDescValues = T.RT_1474,
		SkillGrade = T.RT_844,
		SkillId = 540101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_540101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1476 = {
		[1] = "$#SkillNode[540112].CostSp$",
		[2] = "$#Buff[540114].DotDatas[1].Rate*100$%$GText(\"SKILL_DESC_ATK\")$+$#Buff[540114].DotDatas[1].Value$",
		[3] = "$#SkillEffects[540113].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[4] = "$#Buff[540113].HaloDatas[2].AuraRange/100$$GText(\"SKILL_DESC_Meter\")$",
	}
T.RT_1477 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540112,
		SkillBtnDesc = "SKILL_ICON_Heal",
		SkillBtnIcon = "Skill_Dafu01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill01",
		SkillDesc = "SKILL_540101_DESC",
		SkillDescHints = T.RT_1472,
		SkillDescKeys = T.RT_1473,
		SkillDescValues = T.RT_1476,
		SkillGrade = T.RT_846,
		SkillId = 540101,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_540101_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1478 = {
		[0] = T.RT_1475,
		[1] = T.RT_1477,
		[2] = T.RT_1477,
		[3] = T.RT_1477,
		[4] = T.RT_1477,
		[5] = T.RT_1477,
		[6] = T.RT_1477,
	}
T.RT_1479 = {
		"Term_5401_Buff",
		"Term_5401_Debuff",
	}
T.RT_1480 = {
		[1] = T.RT_167,
		[2] = T.RT_168,
		[3] = T.RT_230,
		[5] = T.RT_169,
		[6] = T.RT_230,
		[7] = T.RT_168,
		[9] = T.RT_230,
	}
T.RT_1481 = {
		[1] = "SKILL_DESC_SpCost",
		[2] = "SKILL_DESC_Heal",
		[3] = "SKILL_DESC_5401BuffSustain",
		[4] = "SKILL_DESC_BonusDamageRate",
		[5] = "SKILL_DESC_EffectRadiusEnemy",
		[6] = "SKILL_DESC_5401DebuffSustain",
		[7] = "SKILL_DESC_DotDamage",
		[8] = "Skill_DESC_AtkDown",
		[9] = "SKILL_DESC_BoundSustain",
	}
T.RT_1482 = {
		[1] = "$#SkillNode[540121].CostSp$",
		[2] = "$#SkillEffects[540121].TaskEffects[1].Rate*100$%$GText(\"SKILL_DESC_ATK\")$+$#SkillEffects[540121].TaskEffects[1].Value$",
		[3] = "$#SkillEffects[540121].TaskEffects[2].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[4] = "$#Buff[540121].AddAttrs[1].Value*100$%",
		[5] = "$#TargetFilter[#SkillEffects[540122].TargetFilter].LuaFilterParaments.Radius/100$$GText(\"SKILL_DESC_Meter\")$",
		[6] = "$#SkillEffects[540122].TaskEffects[1].LastTime$$GText(\"SKILL_DESC_Second\")$",
		[7] = "$#Buff[540102].DotDatas[1].Rate*100$%",
		[8] = "$#Buff[540102].AddAttrs[1].Rate*(-100)$%",
		[9] = "$#SkillEffects[540122].TaskEffects[2].LastTime$$GText(\"SKILL_DESC_Second\")$",
	}
T.RT_1483 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540121,
		CD = 4,
		ExplanationId = T.RT_1479,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Dafu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill02",
		SkillDesc = "SKILL_540102_DESC",
		SkillDescHints = T.RT_1480,
		SkillDescKeys = T.RT_1481,
		SkillDescValues = T.RT_1482,
		SkillGrade = T.RT_196,
		SkillId = 540102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_540102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1484 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540122,
		CD = 4,
		ExplanationId = T.RT_1479,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Dafu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill02",
		SkillDesc = "SKILL_540102_DESC",
		SkillDescHints = T.RT_1480,
		SkillDescKeys = T.RT_1481,
		SkillDescValues = T.RT_1482,
		SkillGrade = T.RT_198,
		SkillId = 540102,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_540102_NAME",
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1485 = {
		[0] = T.RT_1483,
		[1] = T.RT_1483,
		[2] = T.RT_1483,
		[3] = T.RT_1483,
		[4] = T.RT_1483,
		[5] = T.RT_1483,
		[6] = T.RT_1484,
	}
T.RT_1486 = {
		540101,
	}
T.RT_1487 = {
		[1] = "SKILL_DESC_TriggerProbUp",
	}
T.RT_1488 = {
		[1] = "$#Buff[540103].AddAttrs[1].Value*100$%",
	}
T.RT_1489 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_1486,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Dafu03",
		SkillDesc = "SKILL_540103_DESC",
		SkillDescKeys = T.RT_1487,
		SkillDescValues = T.RT_1488,
		SkillGrade = T.RT_2,
		SkillId = 540103,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_540103_NAME",
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_1490 = {
		[0] = T.RT_1489,
		[1] = T.RT_1489,
		[2] = T.RT_1489,
		[3] = T.RT_1489,
		[4] = T.RT_1489,
		[5] = T.RT_1489,
		[6] = T.RT_1489,
	}
T.RT_1491 = {
		540103,
	}
T.RT_1492 = {
		[1] = "SKILL_DESC_DotExplodeRate",
	}
T.RT_1493 = {
		[1] = "$#PassiveEffect[540103].Vars.DotExplodeRate*100$%$GText(\"SKILL_DESC_RangedTriggerProb\")$",
	}
T.RT_1494 = {
		AllowSkillIntensity = true,
		PassiveEffects = T.RT_1491,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillDesc = "SKILL_540104_DESC",
		SkillDescKeys = T.RT_1492,
		SkillDescValues = T.RT_1493,
		SkillGrade = T.RT_2,
		SkillId = 540104,
		SkillLevel = T.RT_8,
		SkillName = "SKILL_540104_NAME",
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_1495 = {
		[0] = T.RT_1494,
		[1] = T.RT_1494,
		[2] = T.RT_1494,
		[3] = T.RT_1494,
		[4] = T.RT_1494,
		[5] = T.RT_1494,
		[6] = T.RT_1494,
	}
T.RT_1496 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540211,
		SkillBtnDesc = "SKILL_ICON_Heal",
		SkillBtnIcon = "Skill_Dafu01",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill01",
		SkillGrade = T.RT_2,
		SkillId = 540201,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill1",
		bEnablePrediction = true,
	}
T.RT_1497 = {
		[0] = T.RT_1496,
		[1] = T.RT_1496,
		[2] = T.RT_1496,
		[3] = T.RT_1496,
		[4] = T.RT_1496,
		[5] = T.RT_1496,
		[6] = T.RT_1496,
	}
T.RT_1498 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540220,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Dafu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 540202,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1499 = {
		[0] = T.RT_1498,
		[1] = T.RT_1498,
		[2] = T.RT_1498,
		[3] = T.RT_1498,
		[4] = T.RT_1498,
		[5] = T.RT_1498,
		[6] = T.RT_1498,
	}
T.RT_1500 = {
		540201,
	}
T.RT_1501 = {
		PassiveEffects = T.RT_1500,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_Dafu03",
		SkillGrade = T.RT_2,
		SkillId = 540203,
		SkillLevel = T.RT_8,
		SkillType = "Passive",
		bEnablePrediction = true,
	}
T.RT_1502 = {
		[0] = T.RT_1501,
		[1] = T.RT_1501,
		[2] = T.RT_1501,
		[3] = T.RT_1501,
		[4] = T.RT_1501,
		[5] = T.RT_1501,
		[6] = T.RT_1501,
	}
T.RT_1503 = {
		540202,
	}
T.RT_1504 = {
		PassiveEffects = T.RT_1503,
		SkillBtnDesc = "SKILL_ICON_Passive",
		SkillBtnIcon = "Skill_ExtraPassive",
		SkillGrade = T.RT_2,
		SkillId = 540204,
		SkillLevel = T.RT_8,
		SkillType = "ExtraPassive",
		SkillUnLockWithCharEnhanceLevel = 3,
		bEnablePrediction = true,
	}
T.RT_1505 = {
		[0] = T.RT_1504,
		[1] = T.RT_1504,
		[2] = T.RT_1504,
		[3] = T.RT_1504,
		[4] = T.RT_1504,
		[5] = T.RT_1504,
		[6] = T.RT_1504,
	}
T.RT_1506 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540223,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Dafu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 540220,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1507 = {
		[0] = T.RT_1506,
		[1] = T.RT_1506,
		[2] = T.RT_1506,
		[3] = T.RT_1506,
		[4] = T.RT_1506,
		[5] = T.RT_1506,
		[6] = T.RT_1506,
	}
T.RT_1508 = {
		BeginNodeId = 540221,
		SkillGrade = T.RT_2,
		SkillId = 540221,
		SkillLevel = T.RT_8,
		SkillType = "Attack",
		bEnablePrediction = true,
	}
T.RT_1509 = {
		[0] = T.RT_1508,
		[1] = T.RT_1508,
		[2] = T.RT_1508,
		[3] = T.RT_1508,
		[4] = T.RT_1508,
		[5] = T.RT_1508,
		[6] = T.RT_1508,
	}
T.RT_1510 = {
		BeginNodeId = 540222,
		SkillGrade = T.RT_2,
		SkillId = 540222,
		SkillLevel = T.RT_8,
		SkillType = "Shooting",
		bEnablePrediction = true,
	}
T.RT_1511 = {
		[0] = T.RT_1510,
		[1] = T.RT_1510,
		[2] = T.RT_1510,
		[3] = T.RT_1510,
		[4] = T.RT_1510,
		[5] = T.RT_1510,
		[6] = T.RT_1510,
	}
T.RT_1512 = {
		FuncName = "Skill2ComboAdd",
		Id = 540201,
	}
T.RT_1513 = {
		ExecutePassiveFunc = T.RT_1512,
		IgnoreTag = true,
		NotExecute = true,
		SkillGrade = T.RT_2,
		SkillId = 540223,
		SkillLevel = T.RT_8,
		SkillType = "Shooting",
	}
T.RT_1514 = {
		[0] = T.RT_1513,
		[1] = T.RT_1513,
		[2] = T.RT_1513,
		[3] = T.RT_1513,
		[4] = T.RT_1513,
		[5] = T.RT_1513,
		[6] = T.RT_1513,
	}
T.RT_1515 = {
		540221,
		540222,
		540223,
		540202,
		540220,
		540232,
		540241,
		540251,
	}
T.RT_1516 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540231,
		LongPressSkill = 540202,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Dafu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 540231,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		SubSkills = T.RT_1515,
		bEnablePrediction = true,
	}
T.RT_1517 = {
		[0] = T.RT_1516,
		[1] = T.RT_1516,
		[2] = T.RT_1516,
		[3] = T.RT_1516,
		[4] = T.RT_1516,
		[5] = T.RT_1516,
		[6] = T.RT_1516,
	}
T.RT_1518 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540231,
		LongPressSkill = 540220,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Dafu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 540232,
		SkillLevel = T.RT_8,
		SkillSpeedModify = true,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1519 = {
		[0] = T.RT_1518,
		[1] = T.RT_1518,
		[2] = T.RT_1518,
		[3] = T.RT_1518,
		[4] = T.RT_1518,
		[5] = T.RT_1518,
		[6] = T.RT_1518,
	}
T.RT_1520 = {
		AllowSkillIntensity = true,
		AllowUseSkillInAir = true,
		BeginNodeId = 540241,
		ResetVelocity = true,
		SkillBtnDesc = "SKILL_ICON_Enhance",
		SkillBtnIcon = "Skill_Dafu02",
		SkillBtnStyle = "Common_Btn",
		SkillDemo = "Dafu_Skill02",
		SkillGrade = T.RT_2,
		SkillId = 540241,
		SkillLevel = T.RT_8,
		SkillType = "Skill2",
		bEnablePrediction = true,
	}
T.RT_1521 = {
		[0] = T.RT_1520,
		[1] = T.RT_1520,
		[2] = T.RT_1520,
		[3] = T.RT_1520,
		[4] = T.RT_1520,
		[5] = T.RT_1520,
		[6] = T.RT_1520,
	}
T.RT_1522 = {
		BeginNodeId = 540251,
		SkillGrade = T.RT_2,
		SkillId = 540251,
		SkillLevel = T.RT_8,
		SkillType = "Reload",
		UseSkillCondition = 540203,
		bEnablePrediction = true,
	}
T.RT_1523 = {
		[0] = T.RT_1522,
		[1] = T.RT_1522,
		[2] = T.RT_1522,
		[3] = T.RT_1522,
		[4] = T.RT_1522,
		[5] = T.RT_1522,
		[6] = T.RT_1522,
	}
T.RT_1524 = {
		FuncName = "WysExecuteSkill",
		Id = 601,
	}
T.RT_1525 = {
		601,
	}
T.RT_1526 = {
		[1] = "$#SkillEffects[60101].TaskEffects[1].Rate*100$%",
		[2] = "$#SkillEffects[60105].TaskEffects[1].SpChange$",
		[3] = "$#Buff[4010013].AddAttrs[1].Rate*100$%",
		[4] = "$#SkillEffects[60104].TaskEffects[1].LastTime$",
	}
T.RT_1527 = {
		AllowUseSkillInAir = true,
		CD = 8,
		ExecutePassiveFunc = T.RT_1524,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1525,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Wuyou04",
		SkillDesc = "PET_601_WUYOU_SKILL",
		SkillDescValues = T.RT_1526,
		SkillGrade = T.RT_2,
		SkillId = 601,
		SkillLevel = T.RT_225,
		SkillType = "Support",
	}
T.RT_1528 = {
		[0] = T.RT_1527,
		[1] = T.RT_1527,
		[2] = T.RT_1527,
		[3] = T.RT_1527,
		[4] = T.RT_1527,
		[5] = T.RT_1527,
		[6] = T.RT_1527,
	}
T.RT_1529 = {
		FuncName = "WysExecuteSkill",
		Id = 602,
	}
T.RT_1530 = {
		602,
	}
T.RT_1531 = {
		[1] = "$#SkillEffects[60201].TaskEffects[1].Rate*100$%",
		[2] = "$#Buff[4010014].AddAttrs[1].Value*100$%",
		[3] = "$#SkillEffects[60204].TaskEffects[1].LastTime$",
	}
T.RT_1532 = {
		AllowUseSkillInAir = true,
		CD = 8,
		ExecutePassiveFunc = T.RT_1529,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1530,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Wuyou02",
		SkillDesc = "PET_602_WUYOU_SKILL",
		SkillDescValues = T.RT_1531,
		SkillGrade = T.RT_2,
		SkillId = 602,
		SkillLevel = T.RT_225,
		SkillType = "Support",
	}
T.RT_1533 = {
		[0] = T.RT_1532,
		[1] = T.RT_1532,
		[2] = T.RT_1532,
		[3] = T.RT_1532,
		[4] = T.RT_1532,
		[5] = T.RT_1532,
		[6] = T.RT_1532,
	}
T.RT_1534 = {
		FuncName = "WysExecuteSkill",
		Id = 603,
	}
T.RT_1535 = {
		603,
	}
T.RT_1536 = {
		[1] = "$#SkillEffects[60302].TaskEffects[1].Rate*100$%",
		[2] = "$#Buff[4010015].DotDatas[1].Value$",
		[3] = "$#Buff[4010015].AddAttrs[1].Value*100$%",
		[4] = "$#SkillEffects[60305].TaskEffects[1].LastTime$",
	}
T.RT_1537 = {
		AllowUseSkillInAir = true,
		CD = 8,
		ExecutePassiveFunc = T.RT_1534,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1535,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Wuyou03",
		SkillDesc = "PET_603_WUYOU_SKILL",
		SkillDescValues = T.RT_1536,
		SkillGrade = T.RT_2,
		SkillId = 603,
		SkillLevel = T.RT_225,
		SkillType = "Support",
	}
T.RT_1538 = {
		[0] = T.RT_1537,
		[1] = T.RT_1537,
		[2] = T.RT_1537,
		[3] = T.RT_1537,
		[4] = T.RT_1537,
		[5] = T.RT_1537,
		[6] = T.RT_1537,
	}
T.RT_1539 = {
		FuncName = "WysExecuteSkill",
		Id = 604,
	}
T.RT_1540 = {
		604,
	}
T.RT_1541 = {
		[1] = "$#SkillEffects[60400].TaskEffects[1].Rate*100$%",
		[2] = "$#Buff[4010016].AddAttrs[1].Rate*100$%",
		[3] = "$#SkillEffects[60402].TaskEffects[1].LastTime$",
	}
T.RT_1542 = {
		AllowUseSkillInAir = true,
		CD = 8,
		ExecutePassiveFunc = T.RT_1539,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1540,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Wuyou01",
		SkillDesc = "PET_604_WUYOU_SKILL",
		SkillDescValues = T.RT_1541,
		SkillGrade = T.RT_2,
		SkillId = 604,
		SkillLevel = T.RT_225,
		SkillType = "Support",
	}
T.RT_1543 = {
		[0] = T.RT_1542,
		[1] = T.RT_1542,
		[2] = T.RT_1542,
		[3] = T.RT_1542,
		[4] = T.RT_1542,
		[5] = T.RT_1542,
		[6] = T.RT_1542,
	}
T.RT_1544 = {
		60500,
	}
T.RT_1545 = {
		AllowUseSkillInAir = true,
		CD = 25,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Qingluan",
		SkillEffectsList = T.RT_1544,
		SkillGrade = T.RT_2,
		SkillId = 605,
		SkillLevel = T.RT_225,
		SkillType = "Support",
	}
T.RT_1546 = {
		[0] = T.RT_1545,
		[1] = T.RT_1545,
		[2] = T.RT_1545,
		[3] = T.RT_1545,
		[4] = T.RT_1545,
		[5] = T.RT_1545,
		[6] = T.RT_1545,
	}
T.RT_1547 = {
		60500,
		60600,
	}
T.RT_1548 = {
		AllowUseSkillInAir = true,
		CD = 25,
		IgnoreTag = true,
		NotExecute = true,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Qingluan",
		SkillEffectsList = T.RT_1547,
		SkillGrade = T.RT_2,
		SkillId = 606,
		SkillLevel = T.RT_225,
		SkillType = "Support",
	}
T.RT_1549 = {
		[0] = T.RT_1548,
		[1] = T.RT_1548,
		[2] = T.RT_1548,
		[3] = T.RT_1548,
		[4] = T.RT_1548,
		[5] = T.RT_1548,
		[6] = T.RT_1548,
	}
T.RT_1550 = {
		850203,
	}
T.RT_1551 = {
		850204,
	}
T.RT_1552 = {
		850301,
	}
T.RT_1553 = {
		850502,
	}
T.RT_1554 = {
		850601,
	}
T.RT_1555 = {
		851201,
	}
T.RT_1556 = {
		FuncName = "ExecuteHeavyAttack",
		Id = 90001,
	}
T.RT_1557 = {
		90001,
	}
T.RT_1558 = {
		CD = 3,
		ExecutePassiveFunc = T.RT_1556,
		NotExecute = true,
		PassiveEffects = T.RT_1557,
		SkillBtnDesc = "SKILL_ICON_Fire",
		SkillBtnIcon = "Skill_Paotai_Fire",
		SkillGrade = T.RT_2,
		SkillId = 90001,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
	}
T.RT_1559 = {
		90002,
	}
T.RT_1560 = {
		AllowEightOrient = "Default",
		BeginNodeId = 90001,
		PassiveEffects = T.RT_1559,
		SkillBtnDesc = "SKILL_ICON_RapidFire",
		SkillBtnIcon = "Skill_Paotai_RapidFire",
		SkillGrade = T.RT_2,
		SkillId = 90002,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
	}
T.RT_1561 = {
		FuncName = "ExecuteHeavyAttack",
		Id = 90011,
	}
T.RT_1562 = {
		90011,
	}
T.RT_1563 = {
		CD = 3,
		ExecutePassiveFunc = T.RT_1561,
		NotExecute = true,
		PassiveEffects = T.RT_1562,
		SkillBtnDesc = "SKILL_ICON_Fire",
		SkillBtnIcon = "Skill_Paotai_Fire",
		SkillGrade = T.RT_2,
		SkillId = 90011,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
	}
T.RT_1564 = {
		90012,
	}
T.RT_1565 = {
		AllowEightOrient = "Default",
		BeginNodeId = 90011,
		PassiveEffects = T.RT_1564,
		SkillBtnDesc = "SKILL_ICON_RapidFire",
		SkillBtnIcon = "Skill_Paotai_RapidFire",
		SkillGrade = T.RT_2,
		SkillId = 90012,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
	}
T.RT_1566 = {
		FuncName = "ExecuteHeavyAttack",
		Id = 90021,
	}
T.RT_1567 = {
		90021,
	}
T.RT_1568 = {
		CD = 3,
		ExecutePassiveFunc = T.RT_1566,
		NotExecute = true,
		PassiveEffects = T.RT_1567,
		SkillBtnDesc = "SKILL_ICON_Fire",
		SkillBtnIcon = "Skill_Paotai_Fire_01",
		SkillGrade = T.RT_2,
		SkillId = 90021,
		SkillLevel = T.RT_3,
		SkillType = "Attack",
	}
T.RT_1569 = {
		90022,
	}
T.RT_1570 = {
		AllowEightOrient = "Default",
		BeginNodeId = 90021,
		PassiveEffects = T.RT_1569,
		SkillBtnDesc = "SKILL_ICON_RapidFire_01",
		SkillBtnIcon = "Skill_Paotai_RapidFire_01",
		SkillGrade = T.RT_2,
		SkillId = 90022,
		SkillLevel = T.RT_3,
		SkillType = "Shooting",
		SkillWeaponType = "Ranged",
	}
T.RT_1571 = {
		FuncName = "ExecuteSupportSkill",
		Id = 901,
	}
T.RT_1572 = {
		901,
	}
T.RT_1573 = {
		AllowUseSkillInAir = true,
		CD = 3,
		ExecutePassiveFunc = T.RT_1571,
		IgnoreTag = true,
		NotExecute = true,
		PassiveEffects = T.RT_1572,
		SkillBtnDesc = "SKILL_ICON_Support",
		SkillBtnIcon = "Skill_Pet_Wuyou01",
		SkillGrade = T.RT_2,
		SkillId = 901,
		SkillLevel = T.RT_225,
		SkillType = "Support",
	}
T.RT_1574 = {
		[0] = T.RT_1573,
		[1] = T.RT_1573,
		[2] = T.RT_1573,
		[3] = T.RT_1573,
		[4] = T.RT_1573,
		[5] = T.RT_1573,
		[6] = T.RT_1573,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("Skill", {
	[10] = {
		[1] = {
			[0] = T.RT_4,
			[1] = T.RT_4,
			[2] = T.RT_4,
			[3] = T.RT_4,
			[4] = T.RT_4,
			[5] = T.RT_4,
			[6] = T.RT_4,
		},
	},
	[20] = {
		[1] = {
			[0] = T.RT_608,
			[1] = T.RT_608,
			[2] = T.RT_608,
			[3] = T.RT_608,
			[4] = T.RT_608,
			[5] = T.RT_608,
			[6] = T.RT_608,
		},
	},
	[30] = {
		[1] = {
			[0] = T.RT_903,
			[1] = T.RT_903,
			[2] = T.RT_903,
			[3] = T.RT_903,
			[4] = T.RT_903,
			[5] = T.RT_903,
			[6] = T.RT_903,
		},
	},
	[401] = {
		[1] = T.RT_1085,
		[2] = T.RT_1085,
		[3] = T.RT_1085,
		[4] = T.RT_1085,
		[5] = T.RT_1085,
	},
	[402] = {
		[1] = T.RT_1099,
		[2] = T.RT_1099,
		[3] = T.RT_1099,
		[4] = T.RT_1099,
		[5] = T.RT_1099,
	},
	[403] = {
		[1] = T.RT_1103,
		[2] = T.RT_1103,
		[3] = T.RT_1103,
		[4] = T.RT_1103,
		[5] = T.RT_1103,
	},
	[404] = {
		[1] = T.RT_1107,
		[2] = T.RT_1107,
		[3] = T.RT_1107,
		[4] = T.RT_1107,
		[5] = T.RT_1107,
	},
	[405] = {
		[1] = T.RT_1111,
		[2] = T.RT_1111,
		[3] = T.RT_1111,
		[4] = T.RT_1111,
		[5] = T.RT_1111,
	},
	[406] = {
		[1] = T.RT_1115,
		[2] = T.RT_1115,
		[3] = T.RT_1115,
		[4] = T.RT_1115,
		[5] = T.RT_1115,
	},
	[407] = {
		[1] = T.RT_1119,
		[2] = T.RT_1119,
		[3] = T.RT_1119,
		[4] = T.RT_1119,
		[5] = T.RT_1119,
	},
	[408] = {
		[1] = T.RT_1123,
		[2] = T.RT_1123,
		[3] = T.RT_1123,
		[4] = T.RT_1123,
		[5] = T.RT_1123,
	},
	[409] = {
		[1] = T.RT_1127,
		[2] = T.RT_1127,
		[3] = T.RT_1127,
		[4] = T.RT_1127,
		[5] = T.RT_1127,
	},
	[411] = {
		[1] = T.RT_1212,
		[2] = T.RT_1212,
		[3] = T.RT_1212,
		[4] = T.RT_1212,
		[5] = T.RT_1212,
	},
	[412] = {
		[1] = T.RT_1216,
		[2] = T.RT_1216,
		[3] = T.RT_1216,
		[4] = T.RT_1216,
		[5] = T.RT_1216,
	},
	[413] = {
		[1] = T.RT_1220,
		[2] = T.RT_1220,
		[3] = T.RT_1220,
		[4] = T.RT_1220,
		[5] = T.RT_1220,
	},
	[414] = {
		[1] = T.RT_1224,
		[2] = T.RT_1224,
		[3] = T.RT_1224,
		[4] = T.RT_1224,
		[5] = T.RT_1224,
	},
	[415] = {
		[1] = T.RT_1228,
		[2] = T.RT_1228,
		[3] = T.RT_1228,
		[4] = T.RT_1228,
		[5] = T.RT_1228,
	},
	[416] = {
		[1] = T.RT_1232,
		[2] = T.RT_1232,
		[3] = T.RT_1232,
		[4] = T.RT_1232,
		[5] = T.RT_1232,
	},
	[417] = {
		[1] = T.RT_1236,
		[2] = T.RT_1236,
		[3] = T.RT_1236,
		[4] = T.RT_1236,
		[5] = T.RT_1236,
	},
	[421] = {
		[1] = T.RT_1298,
		[2] = T.RT_1298,
		[3] = T.RT_1298,
		[4] = T.RT_1298,
		[5] = T.RT_1298,
	},
	[422] = {
		[1] = T.RT_1303,
		[2] = T.RT_1303,
		[3] = T.RT_1303,
		[4] = T.RT_1303,
		[5] = T.RT_1303,
	},
	[423] = {
		[1] = T.RT_1308,
		[2] = T.RT_1308,
		[3] = T.RT_1308,
		[4] = T.RT_1308,
		[5] = T.RT_1308,
	},
	[424] = {
		[1] = T.RT_1313,
		[2] = T.RT_1313,
		[3] = T.RT_1313,
		[4] = T.RT_1313,
		[5] = T.RT_1313,
	},
	[425] = {
		[1] = T.RT_1318,
		[2] = T.RT_1318,
		[3] = T.RT_1318,
		[4] = T.RT_1318,
		[5] = T.RT_1318,
	},
	[426] = {
		[1] = T.RT_1323,
		[2] = T.RT_1323,
		[3] = T.RT_1323,
		[4] = T.RT_1323,
		[5] = T.RT_1323,
	},
	[601] = {
		[1] = T.RT_1528,
		[2] = T.RT_1528,
		[3] = T.RT_1528,
		[4] = T.RT_1528,
	},
	[602] = {
		[1] = T.RT_1533,
		[2] = T.RT_1533,
		[3] = T.RT_1533,
		[4] = T.RT_1533,
	},
	[603] = {
		[1] = T.RT_1538,
		[2] = T.RT_1538,
		[3] = T.RT_1538,
		[4] = T.RT_1538,
	},
	[604] = {
		[1] = T.RT_1543,
		[2] = T.RT_1543,
		[3] = T.RT_1543,
		[4] = T.RT_1543,
	},
	[605] = {
		[1] = T.RT_1546,
		[2] = T.RT_1546,
		[3] = T.RT_1546,
		[4] = T.RT_1546,
	},
	[606] = {
		[1] = T.RT_1549,
		[2] = T.RT_1549,
		[3] = T.RT_1549,
		[4] = T.RT_1549,
	},
	[901] = {
		[1] = T.RT_1574,
		[2] = T.RT_1574,
		[3] = T.RT_1574,
		[4] = T.RT_1574,
	},
	[10001] = {
		[1] = T.RT_32,
		[2] = T.RT_32,
		[3] = T.RT_32,
		[4] = T.RT_32,
		[5] = T.RT_32,
		[6] = T.RT_32,
		[7] = T.RT_32,
		[8] = T.RT_32,
		[9] = T.RT_32,
		[10] = T.RT_32,
		[11] = T.RT_32,
		[12] = T.RT_32,
		[13] = T.RT_32,
		[14] = T.RT_32,
		[15] = T.RT_32,
		[16] = T.RT_32,
		[17] = T.RT_32,
		[18] = T.RT_32,
		[19] = T.RT_32,
		[20] = T.RT_32,
	},
	[10002] = {
		[1] = T.RT_34,
		[2] = T.RT_34,
		[3] = T.RT_34,
		[4] = T.RT_34,
		[5] = T.RT_34,
		[6] = T.RT_34,
		[7] = T.RT_34,
		[8] = T.RT_34,
		[9] = T.RT_34,
		[10] = T.RT_34,
		[11] = T.RT_34,
		[12] = T.RT_34,
		[13] = T.RT_34,
		[14] = T.RT_34,
		[15] = T.RT_34,
		[16] = T.RT_34,
		[17] = T.RT_34,
		[18] = T.RT_34,
		[19] = T.RT_34,
		[20] = T.RT_34,
	},
	[10003] = {
		[1] = T.RT_37,
		[2] = T.RT_37,
		[3] = T.RT_37,
		[4] = T.RT_37,
		[5] = T.RT_37,
		[6] = T.RT_37,
		[7] = T.RT_37,
		[8] = T.RT_37,
		[9] = T.RT_37,
		[10] = T.RT_37,
		[11] = T.RT_37,
		[12] = T.RT_37,
		[13] = T.RT_37,
		[14] = T.RT_37,
		[15] = T.RT_37,
		[16] = T.RT_37,
		[17] = T.RT_37,
		[18] = T.RT_37,
		[19] = T.RT_37,
		[20] = T.RT_37,
	},
	[10004] = {
		[1] = T.RT_39,
		[2] = T.RT_39,
		[3] = T.RT_39,
		[4] = T.RT_39,
		[5] = T.RT_39,
		[6] = T.RT_39,
		[7] = T.RT_39,
		[8] = T.RT_39,
		[9] = T.RT_39,
		[10] = T.RT_39,
		[11] = T.RT_39,
		[12] = T.RT_39,
		[13] = T.RT_39,
		[14] = T.RT_39,
		[15] = T.RT_39,
		[16] = T.RT_39,
		[17] = T.RT_39,
		[18] = T.RT_39,
		[19] = T.RT_39,
		[20] = T.RT_39,
	},
	[10005] = {
		[1] = T.RT_41,
		[2] = T.RT_41,
		[3] = T.RT_41,
		[4] = T.RT_41,
		[5] = T.RT_41,
		[6] = T.RT_41,
		[7] = T.RT_41,
		[8] = T.RT_41,
		[9] = T.RT_41,
		[10] = T.RT_41,
		[11] = T.RT_41,
		[12] = T.RT_41,
		[13] = T.RT_41,
		[14] = T.RT_41,
		[15] = T.RT_41,
		[16] = T.RT_41,
		[17] = T.RT_41,
		[18] = T.RT_41,
		[19] = T.RT_41,
		[20] = T.RT_41,
	},
	[10006] = {
		[1] = T.RT_43,
		[2] = T.RT_43,
		[3] = T.RT_43,
		[4] = T.RT_43,
		[5] = T.RT_43,
		[6] = T.RT_43,
		[7] = T.RT_43,
		[8] = T.RT_43,
		[9] = T.RT_43,
		[10] = T.RT_43,
		[11] = T.RT_43,
		[12] = T.RT_43,
		[13] = T.RT_43,
		[14] = T.RT_43,
		[15] = T.RT_43,
		[16] = T.RT_43,
		[17] = T.RT_43,
		[18] = T.RT_43,
		[19] = T.RT_43,
		[20] = T.RT_43,
	},
	[10007] = {
		[1] = T.RT_45,
		[2] = T.RT_45,
		[3] = T.RT_45,
		[4] = T.RT_45,
		[5] = T.RT_45,
		[6] = T.RT_45,
		[7] = T.RT_45,
		[8] = T.RT_45,
		[9] = T.RT_45,
		[10] = T.RT_45,
		[11] = T.RT_45,
		[12] = T.RT_45,
		[13] = T.RT_45,
		[14] = T.RT_45,
		[15] = T.RT_45,
		[16] = T.RT_45,
		[17] = T.RT_45,
		[18] = T.RT_45,
		[19] = T.RT_45,
		[20] = T.RT_45,
	},
	[10008] = {
		[1] = T.RT_47,
		[2] = T.RT_47,
		[3] = T.RT_47,
		[4] = T.RT_47,
		[5] = T.RT_47,
		[6] = T.RT_47,
		[7] = T.RT_47,
		[8] = T.RT_47,
		[9] = T.RT_47,
		[10] = T.RT_47,
		[11] = T.RT_47,
		[12] = T.RT_47,
		[13] = T.RT_47,
		[14] = T.RT_47,
		[15] = T.RT_47,
		[16] = T.RT_47,
		[17] = T.RT_47,
		[18] = T.RT_47,
		[19] = T.RT_47,
		[20] = T.RT_47,
	},
	[10009] = {
		[1] = T.RT_49,
		[2] = T.RT_49,
		[3] = T.RT_49,
		[4] = T.RT_49,
		[5] = T.RT_49,
		[6] = T.RT_49,
		[7] = T.RT_49,
		[8] = T.RT_49,
		[9] = T.RT_49,
		[10] = T.RT_49,
		[11] = T.RT_49,
		[12] = T.RT_49,
		[13] = T.RT_49,
		[14] = T.RT_49,
		[15] = T.RT_49,
		[16] = T.RT_49,
		[17] = T.RT_49,
		[18] = T.RT_49,
		[19] = T.RT_49,
		[20] = T.RT_49,
	},
	[18011] = {
		[1] = {
			[0] = T.RT_593,
			[1] = T.RT_593,
			[2] = T.RT_593,
			[3] = T.RT_593,
			[4] = T.RT_593,
			[5] = T.RT_593,
			[6] = T.RT_593,
		},
	},
	[18012] = {
		[1] = {
			[0] = T.RT_597,
			[1] = T.RT_597,
			[2] = T.RT_597,
			[3] = T.RT_597,
			[4] = T.RT_597,
			[5] = T.RT_597,
			[6] = T.RT_597,
		},
	},
	[20101] = {
		[1] = {
			[0] = T.RT_609,
			[1] = T.RT_609,
			[2] = T.RT_609,
			[3] = T.RT_609,
			[4] = T.RT_609,
			[5] = T.RT_609,
			[6] = T.RT_609,
		},
	},
	[20102] = {
		[1] = {
			[0] = T.RT_616,
			[1] = T.RT_616,
			[2] = T.RT_616,
			[3] = T.RT_616,
			[4] = T.RT_616,
			[5] = T.RT_616,
			[6] = T.RT_616,
		},
	},
	[30401] = {
		[1] = {
			[0] = {
				BeginNodeId = 30401,
				SkillGrade = 0,
				SkillId = 30401,
				SkillLevel = 1,
			},
		},
	},
	[30402] = {
		[1] = {
			[0] = {
				BeginNodeId = 30402,
				SkillGrade = 0,
				SkillId = 30402,
				SkillLevel = 1,
			},
		},
	},
	[30403] = {
		[1] = {
			[0] = {
				BeginNodeId = 30403,
				SkillGrade = 0,
				SkillId = 30403,
				SkillLevel = 1,
			},
		},
	},
	[30404] = {
		[1] = {
			[0] = {
				BeginNodeId = 30404,
				SkillGrade = 0,
				SkillId = 30404,
				SkillLevel = 1,
			},
		},
	},
	[30405] = {
		[1] = {
			[0] = {
				BeginNodeId = 30405,
				SkillGrade = 0,
				SkillId = 30405,
				SkillLevel = 1,
			},
		},
	},
	[30406] = {
		[1] = {
			[0] = {
				BeginNodeId = 30406,
				SkillGrade = 0,
				SkillId = 30406,
				SkillLevel = 1,
			},
		},
	},
	[30407] = {
		[1] = {
			[0] = {
				BeginNodeId = 30407,
				SkillGrade = 0,
				SkillId = 30407,
				SkillLevel = 1,
			},
		},
	},
	[30408] = {
		[1] = {
			[0] = {
				BeginNodeId = 30408,
				SkillGrade = 0,
				SkillId = 30408,
				SkillLevel = 1,
			},
		},
	},
	[30409] = {
		[1] = {
			[0] = {
				BeginNodeId = 30409,
				SkillGrade = 0,
				SkillId = 30409,
				SkillLevel = 1,
			},
		},
	},
	[30410] = {
		[1] = {
			[0] = {
				BeginNodeId = 30410,
				SkillGrade = 0,
				SkillId = 30410,
				SkillLevel = 1,
			},
		},
	},
	[30411] = {
		[1] = {
			[0] = {
				BeginNodeId = 30411,
				SkillGrade = 0,
				SkillId = 30411,
				SkillLevel = 1,
			},
		},
	},
	[30412] = {
		[1] = {
			[0] = {
				BeginNodeId = 30412,
				SkillGrade = 0,
				SkillId = 30412,
				SkillLevel = 1,
			},
		},
	},
	[30413] = {
		[1] = {
			[0] = {
				BeginNodeId = 30413,
				SkillGrade = 0,
				SkillId = 30413,
				SkillLevel = 1,
			},
		},
	},
	[30414] = {
		[1] = {
			[0] = {
				BeginNodeId = 30414,
				SkillGrade = 0,
				SkillId = 30414,
				SkillLevel = 1,
			},
		},
	},
	[30415] = {
		[1] = {
			[0] = {
				BeginNodeId = 30415,
				SkillGrade = 0,
				SkillId = 30415,
				SkillLevel = 1,
			},
		},
	},
	[30416] = {
		[1] = {
			[0] = {
				BeginNodeId = 30416,
				SkillGrade = 0,
				SkillId = 30416,
				SkillLevel = 1,
			},
		},
	},
	[30417] = {
		[1] = {
			[0] = {
				BeginNodeId = 30417,
				SkillGrade = 0,
				SkillId = 30417,
				SkillLevel = 1,
			},
		},
	},
	[30418] = {
		[1] = {
			[0] = {
				BeginNodeId = 30418,
				SkillGrade = 0,
				SkillId = 30418,
				SkillLevel = 1,
			},
		},
	},
	[30419] = {
		[1] = {
			[0] = {
				BeginNodeId = 30419,
				SkillGrade = 0,
				SkillId = 30419,
				SkillLevel = 1,
			},
		},
	},
	[30420] = {
		[1] = {
			[0] = {
				BeginNodeId = 30420,
				SkillGrade = 0,
				SkillId = 30420,
				SkillLevel = 1,
			},
		},
	},
	[30421] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					30421,
				},
				SkillGrade = 0,
				SkillId = 30421,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[30422] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					30422,
				},
				SkillGrade = 0,
				SkillId = 30422,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[30423] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					30423,
				},
				SkillGrade = 0,
				SkillId = 30423,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[30424] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					30427,
				},
				SkillGrade = 0,
				SkillId = 30424,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[90001] = {
		[1] = {
			[0] = T.RT_1558,
			[1] = T.RT_1558,
			[2] = T.RT_1558,
			[3] = T.RT_1558,
			[4] = T.RT_1558,
			[5] = T.RT_1558,
			[6] = T.RT_1558,
		},
	},
	[90002] = {
		[1] = {
			[0] = T.RT_1560,
			[1] = T.RT_1560,
			[2] = T.RT_1560,
			[3] = T.RT_1560,
			[4] = T.RT_1560,
			[5] = T.RT_1560,
			[6] = T.RT_1560,
		},
	},
	[90011] = {
		[1] = {
			[0] = T.RT_1563,
			[1] = T.RT_1563,
			[2] = T.RT_1563,
			[3] = T.RT_1563,
			[4] = T.RT_1563,
			[5] = T.RT_1563,
			[6] = T.RT_1563,
		},
	},
	[90012] = {
		[1] = {
			[0] = T.RT_1565,
			[1] = T.RT_1565,
			[2] = T.RT_1565,
			[3] = T.RT_1565,
			[4] = T.RT_1565,
			[5] = T.RT_1565,
			[6] = T.RT_1565,
		},
	},
	[90021] = {
		[1] = {
			[0] = T.RT_1568,
			[1] = T.RT_1568,
			[2] = T.RT_1568,
			[3] = T.RT_1568,
			[4] = T.RT_1568,
			[5] = T.RT_1568,
			[6] = T.RT_1568,
		},
	},
	[90022] = {
		[1] = {
			[0] = T.RT_1570,
			[1] = T.RT_1570,
			[2] = T.RT_1570,
			[3] = T.RT_1570,
			[4] = T.RT_1570,
			[5] = T.RT_1570,
			[6] = T.RT_1570,
		},
	},
	[100001] = {
		[1] = T.RT_10,
		[2] = T.RT_10,
		[3] = T.RT_10,
		[4] = T.RT_10,
		[5] = T.RT_10,
		[6] = T.RT_10,
		[7] = T.RT_10,
		[8] = T.RT_10,
		[9] = T.RT_10,
		[10] = T.RT_10,
		[11] = T.RT_10,
		[12] = T.RT_10,
		[13] = T.RT_10,
		[14] = T.RT_10,
		[15] = T.RT_10,
		[16] = T.RT_10,
		[17] = T.RT_10,
		[18] = T.RT_10,
		[19] = T.RT_10,
		[20] = T.RT_10,
	},
	[100003] = {
		[1] = T.RT_15,
		[2] = T.RT_15,
		[3] = T.RT_15,
		[4] = T.RT_15,
		[5] = T.RT_15,
		[6] = T.RT_15,
		[7] = T.RT_15,
		[8] = T.RT_15,
		[9] = T.RT_15,
		[10] = T.RT_15,
		[11] = T.RT_15,
		[12] = T.RT_15,
		[13] = T.RT_15,
		[14] = T.RT_15,
		[15] = T.RT_15,
		[16] = T.RT_15,
		[17] = T.RT_15,
		[18] = T.RT_15,
		[19] = T.RT_15,
		[20] = T.RT_15,
	},
	[100005] = {
		[1] = T.RT_20,
		[2] = T.RT_20,
		[3] = T.RT_20,
		[4] = T.RT_20,
		[5] = T.RT_20,
		[6] = T.RT_20,
		[7] = T.RT_20,
		[8] = T.RT_20,
		[9] = T.RT_20,
		[10] = T.RT_20,
		[11] = T.RT_20,
		[12] = T.RT_20,
		[13] = T.RT_20,
		[14] = T.RT_20,
		[15] = T.RT_20,
		[16] = T.RT_20,
		[17] = T.RT_20,
		[18] = T.RT_20,
		[19] = T.RT_20,
		[20] = T.RT_20,
	},
	[100007] = {
		[1] = T.RT_25,
		[2] = T.RT_25,
		[3] = T.RT_25,
		[4] = T.RT_25,
		[5] = T.RT_25,
		[6] = T.RT_25,
		[7] = T.RT_25,
		[8] = T.RT_25,
		[9] = T.RT_25,
		[10] = T.RT_25,
		[11] = T.RT_25,
		[12] = T.RT_25,
		[13] = T.RT_25,
		[14] = T.RT_25,
		[15] = T.RT_25,
		[16] = T.RT_25,
		[17] = T.RT_25,
		[18] = T.RT_25,
		[19] = T.RT_25,
		[20] = T.RT_25,
	},
	[100009] = {
		[1] = T.RT_30,
		[2] = T.RT_30,
		[3] = T.RT_30,
		[4] = T.RT_30,
		[5] = T.RT_30,
		[6] = T.RT_30,
		[7] = T.RT_30,
		[8] = T.RT_30,
		[9] = T.RT_30,
		[10] = T.RT_30,
		[11] = T.RT_30,
		[12] = T.RT_30,
		[13] = T.RT_30,
		[14] = T.RT_30,
		[15] = T.RT_30,
		[16] = T.RT_30,
		[17] = T.RT_30,
		[18] = T.RT_30,
		[19] = T.RT_30,
		[20] = T.RT_30,
	},
	[110001] = {
		[1] = T.RT_162,
		[2] = T.RT_162,
		[3] = T.RT_162,
		[4] = T.RT_162,
		[5] = T.RT_162,
		[6] = T.RT_162,
		[7] = T.RT_162,
		[8] = T.RT_162,
		[9] = T.RT_162,
		[10] = T.RT_162,
		[11] = T.RT_162,
		[12] = T.RT_162,
		[13] = T.RT_162,
		[14] = T.RT_162,
		[15] = T.RT_162,
		[16] = T.RT_162,
		[17] = T.RT_162,
		[18] = T.RT_162,
		[19] = T.RT_162,
		[20] = T.RT_162,
	},
	[110003] = {
		[1] = T.RT_166,
		[2] = T.RT_166,
		[3] = T.RT_166,
		[4] = T.RT_166,
		[5] = T.RT_166,
		[6] = T.RT_166,
		[7] = T.RT_166,
		[8] = T.RT_166,
		[9] = T.RT_166,
		[10] = T.RT_166,
		[11] = T.RT_166,
		[12] = T.RT_166,
		[13] = T.RT_166,
		[14] = T.RT_166,
		[15] = T.RT_166,
		[16] = T.RT_166,
		[17] = T.RT_166,
		[18] = T.RT_166,
		[19] = T.RT_166,
		[20] = T.RT_166,
	},
	[110101] = {
		[1] = T.RT_175,
		[2] = T.RT_175,
		[3] = T.RT_175,
		[4] = T.RT_175,
		[5] = T.RT_175,
		[6] = T.RT_175,
		[7] = T.RT_175,
		[8] = T.RT_175,
		[9] = T.RT_175,
		[10] = T.RT_175,
		[11] = T.RT_175,
		[12] = T.RT_175,
		[13] = T.RT_175,
		[14] = T.RT_175,
		[15] = T.RT_175,
		[16] = T.RT_175,
		[17] = T.RT_175,
		[18] = T.RT_175,
		[19] = T.RT_175,
		[20] = T.RT_175,
	},
	[110102] = {
		[1] = T.RT_182,
		[2] = T.RT_182,
		[3] = T.RT_182,
		[4] = T.RT_182,
		[5] = T.RT_182,
		[6] = T.RT_182,
		[7] = T.RT_182,
		[8] = T.RT_182,
		[9] = T.RT_182,
		[10] = T.RT_182,
		[11] = T.RT_182,
		[12] = T.RT_182,
		[13] = T.RT_182,
		[14] = T.RT_182,
		[15] = T.RT_182,
		[16] = T.RT_182,
		[17] = T.RT_182,
		[18] = T.RT_182,
		[19] = T.RT_182,
		[20] = T.RT_182,
	},
	[110103] = {
		[1] = T.RT_187,
		[2] = T.RT_187,
		[3] = T.RT_187,
		[4] = T.RT_187,
		[5] = T.RT_187,
		[6] = T.RT_187,
		[7] = T.RT_187,
		[8] = T.RT_187,
		[9] = T.RT_187,
		[10] = T.RT_187,
		[11] = T.RT_187,
		[12] = T.RT_187,
		[13] = T.RT_187,
		[14] = T.RT_187,
		[15] = T.RT_187,
		[16] = T.RT_187,
		[17] = T.RT_187,
		[18] = T.RT_187,
		[19] = T.RT_187,
		[20] = T.RT_187,
	},
	[110104] = {
		[1] = T.RT_190,
		[2] = T.RT_190,
		[3] = T.RT_190,
		[4] = T.RT_190,
		[5] = T.RT_190,
		[6] = T.RT_190,
		[7] = T.RT_190,
		[8] = T.RT_190,
		[9] = T.RT_190,
		[10] = T.RT_190,
		[11] = T.RT_190,
		[12] = T.RT_190,
		[13] = T.RT_190,
		[14] = T.RT_190,
		[15] = T.RT_190,
		[16] = T.RT_190,
		[17] = T.RT_190,
		[18] = T.RT_190,
		[19] = T.RT_190,
		[20] = T.RT_190,
	},
	[110111] = {
		[1] = T.RT_192,
		[2] = T.RT_192,
		[3] = T.RT_192,
		[4] = T.RT_192,
		[5] = T.RT_192,
		[6] = T.RT_192,
		[7] = T.RT_192,
		[8] = T.RT_192,
		[9] = T.RT_192,
		[10] = T.RT_192,
		[11] = T.RT_192,
		[12] = T.RT_192,
		[13] = T.RT_192,
		[14] = T.RT_192,
		[15] = T.RT_192,
		[16] = T.RT_192,
		[17] = T.RT_192,
		[18] = T.RT_192,
		[19] = T.RT_192,
		[20] = T.RT_192,
	},
	[110121] = {
		[1] = T.RT_195,
		[2] = T.RT_195,
		[3] = T.RT_195,
		[4] = T.RT_195,
		[5] = T.RT_195,
		[6] = T.RT_195,
		[7] = T.RT_195,
		[8] = T.RT_195,
		[9] = T.RT_195,
		[10] = T.RT_195,
		[11] = T.RT_195,
		[12] = T.RT_195,
		[13] = T.RT_195,
		[14] = T.RT_195,
		[15] = T.RT_195,
		[16] = T.RT_195,
		[17] = T.RT_195,
		[18] = T.RT_195,
		[19] = T.RT_195,
		[20] = T.RT_195,
	},
	[110122] = {
		[1] = T.RT_200,
		[2] = T.RT_200,
		[3] = T.RT_200,
		[4] = T.RT_200,
		[5] = T.RT_200,
		[6] = T.RT_200,
		[7] = T.RT_200,
		[8] = T.RT_200,
		[9] = T.RT_200,
		[10] = T.RT_200,
		[11] = T.RT_200,
		[12] = T.RT_200,
		[13] = T.RT_200,
		[14] = T.RT_200,
		[15] = T.RT_200,
		[16] = T.RT_200,
		[17] = T.RT_200,
		[18] = T.RT_200,
		[19] = T.RT_200,
		[20] = T.RT_200,
	},
	[110123] = {
		[1] = T.RT_202,
		[2] = T.RT_202,
		[3] = T.RT_202,
		[4] = T.RT_202,
		[5] = T.RT_202,
		[6] = T.RT_202,
		[7] = T.RT_202,
		[8] = T.RT_202,
		[9] = T.RT_202,
		[10] = T.RT_202,
		[11] = T.RT_202,
		[12] = T.RT_202,
		[13] = T.RT_202,
		[14] = T.RT_202,
		[15] = T.RT_202,
		[16] = T.RT_202,
		[17] = T.RT_202,
		[18] = T.RT_202,
		[19] = T.RT_202,
		[20] = T.RT_202,
	},
	[110124] = {
		[1] = T.RT_204,
		[2] = T.RT_204,
		[3] = T.RT_204,
		[4] = T.RT_204,
		[5] = T.RT_204,
		[6] = T.RT_204,
		[7] = T.RT_204,
		[8] = T.RT_204,
		[9] = T.RT_204,
		[10] = T.RT_204,
		[11] = T.RT_204,
		[12] = T.RT_204,
		[13] = T.RT_204,
		[14] = T.RT_204,
		[15] = T.RT_204,
		[16] = T.RT_204,
		[17] = T.RT_204,
		[18] = T.RT_204,
		[19] = T.RT_204,
		[20] = T.RT_204,
	},
	[110201] = {
		[1] = T.RT_207,
		[2] = T.RT_207,
		[3] = T.RT_207,
		[4] = T.RT_207,
		[5] = T.RT_207,
		[6] = T.RT_207,
		[7] = T.RT_207,
		[8] = T.RT_207,
		[9] = T.RT_207,
		[10] = T.RT_207,
		[11] = T.RT_207,
		[12] = T.RT_207,
		[13] = T.RT_207,
		[14] = T.RT_207,
		[15] = T.RT_207,
		[16] = T.RT_207,
		[17] = T.RT_207,
		[18] = T.RT_207,
		[19] = T.RT_207,
		[20] = T.RT_207,
	},
	[110202] = {
		[1] = T.RT_210,
		[2] = T.RT_210,
		[3] = T.RT_210,
		[4] = T.RT_210,
		[5] = T.RT_210,
		[6] = T.RT_210,
		[7] = T.RT_210,
		[8] = T.RT_210,
		[9] = T.RT_210,
		[10] = T.RT_210,
		[11] = T.RT_210,
		[12] = T.RT_210,
		[13] = T.RT_210,
		[14] = T.RT_210,
		[15] = T.RT_210,
		[16] = T.RT_210,
		[17] = T.RT_210,
		[18] = T.RT_210,
		[19] = T.RT_210,
		[20] = T.RT_210,
	},
	[110203] = {
		[1] = T.RT_213,
		[2] = T.RT_213,
		[3] = T.RT_213,
		[4] = T.RT_213,
		[5] = T.RT_213,
		[6] = T.RT_213,
		[7] = T.RT_213,
		[8] = T.RT_213,
		[9] = T.RT_213,
		[10] = T.RT_213,
		[11] = T.RT_213,
		[12] = T.RT_213,
		[13] = T.RT_213,
		[14] = T.RT_213,
		[15] = T.RT_213,
		[16] = T.RT_213,
		[17] = T.RT_213,
		[18] = T.RT_213,
		[19] = T.RT_213,
		[20] = T.RT_213,
	},
	[110204] = {
		[1] = T.RT_216,
		[2] = T.RT_216,
		[3] = T.RT_216,
		[4] = T.RT_216,
		[5] = T.RT_216,
		[6] = T.RT_216,
		[7] = T.RT_216,
		[8] = T.RT_216,
		[9] = T.RT_216,
		[10] = T.RT_216,
		[11] = T.RT_216,
		[12] = T.RT_216,
		[13] = T.RT_216,
		[14] = T.RT_216,
		[15] = T.RT_216,
		[16] = T.RT_216,
		[17] = T.RT_216,
		[18] = T.RT_216,
		[19] = T.RT_216,
		[20] = T.RT_216,
	},
	[110205] = {
		[1] = T.RT_218,
		[2] = T.RT_218,
		[3] = T.RT_218,
		[4] = T.RT_218,
		[5] = T.RT_218,
		[6] = T.RT_218,
		[7] = T.RT_218,
		[8] = T.RT_218,
		[9] = T.RT_218,
		[10] = T.RT_218,
		[11] = T.RT_218,
		[12] = T.RT_218,
		[13] = T.RT_218,
		[14] = T.RT_218,
		[15] = T.RT_218,
		[16] = T.RT_218,
		[17] = T.RT_218,
		[18] = T.RT_218,
		[19] = T.RT_218,
		[20] = T.RT_218,
	},
	[110211] = {
		[1] = T.RT_220,
		[2] = T.RT_220,
		[3] = T.RT_220,
		[4] = T.RT_220,
		[5] = T.RT_220,
		[6] = T.RT_220,
		[7] = T.RT_220,
		[8] = T.RT_220,
		[9] = T.RT_220,
		[10] = T.RT_220,
		[11] = T.RT_220,
		[12] = T.RT_220,
		[13] = T.RT_220,
		[14] = T.RT_220,
		[15] = T.RT_220,
		[16] = T.RT_220,
		[17] = T.RT_220,
		[18] = T.RT_220,
		[19] = T.RT_220,
		[20] = T.RT_220,
	},
	[110221] = {
		[1] = T.RT_223,
		[2] = T.RT_223,
		[3] = T.RT_223,
		[4] = T.RT_223,
		[5] = T.RT_223,
		[6] = T.RT_223,
		[7] = T.RT_223,
		[8] = T.RT_223,
		[9] = T.RT_223,
		[10] = T.RT_223,
		[11] = T.RT_223,
		[12] = T.RT_223,
		[13] = T.RT_223,
		[14] = T.RT_223,
		[15] = T.RT_223,
		[16] = T.RT_223,
		[17] = T.RT_223,
		[18] = T.RT_223,
		[19] = T.RT_223,
		[20] = T.RT_223,
	},
	[110301] = {
		[1] = T.RT_236,
		[2] = T.RT_236,
		[3] = T.RT_236,
		[4] = T.RT_236,
		[5] = T.RT_236,
		[6] = T.RT_236,
		[7] = T.RT_236,
		[8] = T.RT_236,
		[9] = T.RT_236,
		[10] = T.RT_236,
		[11] = T.RT_236,
		[12] = T.RT_236,
		[13] = T.RT_236,
		[14] = T.RT_236,
		[15] = T.RT_236,
		[16] = T.RT_236,
		[17] = T.RT_236,
		[18] = T.RT_236,
		[19] = T.RT_236,
		[20] = T.RT_236,
	},
	[110302] = {
		[1] = T.RT_243,
		[2] = T.RT_243,
		[3] = T.RT_243,
		[4] = T.RT_243,
		[5] = T.RT_243,
		[6] = T.RT_243,
		[7] = T.RT_243,
		[8] = T.RT_243,
		[9] = T.RT_243,
		[10] = T.RT_243,
		[11] = T.RT_243,
		[12] = T.RT_243,
		[13] = T.RT_243,
		[14] = T.RT_243,
		[15] = T.RT_243,
		[16] = T.RT_243,
		[17] = T.RT_243,
		[18] = T.RT_243,
		[19] = T.RT_243,
		[20] = T.RT_243,
	},
	[110303] = {
		[1] = T.RT_254,
		[2] = T.RT_254,
		[3] = T.RT_254,
		[4] = T.RT_254,
		[5] = T.RT_254,
		[6] = T.RT_254,
		[7] = T.RT_254,
		[8] = T.RT_254,
		[9] = T.RT_254,
		[10] = T.RT_254,
		[11] = T.RT_254,
		[12] = T.RT_254,
		[13] = T.RT_254,
		[14] = T.RT_254,
		[15] = T.RT_254,
		[16] = T.RT_254,
		[17] = T.RT_254,
		[18] = T.RT_254,
		[19] = T.RT_254,
		[20] = T.RT_254,
	},
	[110304] = {
		[1] = T.RT_259,
		[2] = T.RT_259,
		[3] = T.RT_259,
		[4] = T.RT_259,
		[5] = T.RT_259,
		[6] = T.RT_259,
		[7] = T.RT_259,
		[8] = T.RT_259,
		[9] = T.RT_259,
		[10] = T.RT_259,
		[11] = T.RT_259,
		[12] = T.RT_259,
		[13] = T.RT_259,
		[14] = T.RT_259,
		[15] = T.RT_259,
		[16] = T.RT_259,
		[17] = T.RT_259,
		[18] = T.RT_259,
		[19] = T.RT_259,
		[20] = T.RT_259,
	},
	[110311] = {
		[1] = T.RT_262,
		[2] = T.RT_262,
		[3] = T.RT_262,
		[4] = T.RT_262,
		[5] = T.RT_262,
		[6] = T.RT_262,
		[7] = T.RT_262,
		[8] = T.RT_262,
		[9] = T.RT_262,
		[10] = T.RT_262,
		[11] = T.RT_262,
		[12] = T.RT_262,
		[13] = T.RT_262,
		[14] = T.RT_262,
		[15] = T.RT_262,
		[16] = T.RT_262,
		[17] = T.RT_262,
		[18] = T.RT_262,
		[19] = T.RT_262,
		[20] = T.RT_262,
	},
	[110321] = {
		[1] = T.RT_264,
		[2] = T.RT_264,
		[3] = T.RT_264,
		[4] = T.RT_264,
		[5] = T.RT_264,
		[6] = T.RT_264,
		[7] = T.RT_264,
		[8] = T.RT_264,
		[9] = T.RT_264,
		[10] = T.RT_264,
		[11] = T.RT_264,
		[12] = T.RT_264,
		[13] = T.RT_264,
		[14] = T.RT_264,
		[15] = T.RT_264,
		[16] = T.RT_264,
		[17] = T.RT_264,
		[18] = T.RT_264,
		[19] = T.RT_264,
		[20] = T.RT_264,
	},
	[110323] = {
		[1] = T.RT_266,
		[2] = T.RT_266,
		[3] = T.RT_266,
		[4] = T.RT_266,
		[5] = T.RT_266,
		[6] = T.RT_266,
		[7] = T.RT_266,
		[8] = T.RT_266,
		[9] = T.RT_266,
		[10] = T.RT_266,
		[11] = T.RT_266,
		[12] = T.RT_266,
		[13] = T.RT_266,
		[14] = T.RT_266,
		[15] = T.RT_266,
		[16] = T.RT_266,
		[17] = T.RT_266,
		[18] = T.RT_266,
		[19] = T.RT_266,
		[20] = T.RT_266,
	},
	[110324] = {
		[1] = T.RT_268,
		[2] = T.RT_268,
		[3] = T.RT_268,
		[4] = T.RT_268,
		[5] = T.RT_268,
		[6] = T.RT_268,
		[7] = T.RT_268,
		[8] = T.RT_268,
		[9] = T.RT_268,
		[10] = T.RT_268,
		[11] = T.RT_268,
		[12] = T.RT_268,
		[13] = T.RT_268,
		[14] = T.RT_268,
		[15] = T.RT_268,
		[16] = T.RT_268,
		[17] = T.RT_268,
		[18] = T.RT_268,
		[19] = T.RT_268,
		[20] = T.RT_268,
	},
	[110325] = {
		[1] = T.RT_270,
		[2] = T.RT_270,
		[3] = T.RT_270,
		[4] = T.RT_270,
		[5] = T.RT_270,
		[6] = T.RT_270,
		[7] = T.RT_270,
		[8] = T.RT_270,
		[9] = T.RT_270,
		[10] = T.RT_270,
		[11] = T.RT_270,
		[12] = T.RT_270,
		[13] = T.RT_270,
		[14] = T.RT_270,
		[15] = T.RT_270,
		[16] = T.RT_270,
		[17] = T.RT_270,
		[18] = T.RT_270,
		[19] = T.RT_270,
		[20] = T.RT_270,
	},
	[110391] = {
		[1] = T.RT_272,
		[2] = T.RT_272,
		[3] = T.RT_272,
		[4] = T.RT_272,
		[5] = T.RT_272,
		[6] = T.RT_272,
		[7] = T.RT_272,
		[8] = T.RT_272,
		[9] = T.RT_272,
		[10] = T.RT_272,
		[11] = T.RT_272,
		[12] = T.RT_272,
		[13] = T.RT_272,
		[14] = T.RT_272,
		[15] = T.RT_272,
		[16] = T.RT_272,
		[17] = T.RT_272,
		[18] = T.RT_272,
		[19] = T.RT_272,
		[20] = T.RT_272,
	},
	[110392] = {
		[1] = T.RT_275,
		[2] = T.RT_275,
		[3] = T.RT_275,
		[4] = T.RT_275,
		[5] = T.RT_275,
		[6] = T.RT_275,
		[7] = T.RT_275,
		[8] = T.RT_275,
		[9] = T.RT_275,
		[10] = T.RT_275,
		[11] = T.RT_275,
		[12] = T.RT_275,
		[13] = T.RT_275,
		[14] = T.RT_275,
		[15] = T.RT_275,
		[16] = T.RT_275,
		[17] = T.RT_275,
		[18] = T.RT_275,
		[19] = T.RT_275,
		[20] = T.RT_275,
	},
	[110393] = {
		[1] = T.RT_278,
		[2] = T.RT_278,
		[3] = T.RT_278,
		[4] = T.RT_278,
		[5] = T.RT_278,
		[6] = T.RT_278,
		[7] = T.RT_278,
		[8] = T.RT_278,
		[9] = T.RT_278,
		[10] = T.RT_278,
		[11] = T.RT_278,
		[12] = T.RT_278,
		[13] = T.RT_278,
		[14] = T.RT_278,
		[15] = T.RT_278,
		[16] = T.RT_278,
		[17] = T.RT_278,
		[18] = T.RT_278,
		[19] = T.RT_278,
		[20] = T.RT_278,
	},
	[110401] = {
		[1] = T.RT_282,
		[2] = T.RT_282,
		[3] = T.RT_282,
		[4] = T.RT_282,
		[5] = T.RT_282,
		[6] = T.RT_282,
		[7] = T.RT_282,
		[8] = T.RT_282,
		[9] = T.RT_282,
		[10] = T.RT_282,
		[11] = T.RT_282,
		[12] = T.RT_282,
		[13] = T.RT_282,
		[14] = T.RT_282,
		[15] = T.RT_282,
		[16] = T.RT_282,
		[17] = T.RT_282,
		[18] = T.RT_282,
		[19] = T.RT_282,
		[20] = T.RT_282,
	},
	[110402] = {
		[1] = T.RT_284,
		[2] = T.RT_284,
		[3] = T.RT_284,
		[4] = T.RT_284,
		[5] = T.RT_284,
		[6] = T.RT_284,
		[7] = T.RT_284,
		[8] = T.RT_284,
		[9] = T.RT_284,
		[10] = T.RT_284,
		[11] = T.RT_284,
		[12] = T.RT_284,
		[13] = T.RT_284,
		[14] = T.RT_284,
		[15] = T.RT_284,
		[16] = T.RT_284,
		[17] = T.RT_284,
		[18] = T.RT_284,
		[19] = T.RT_284,
		[20] = T.RT_284,
	},
	[110403] = {
		[1] = T.RT_287,
		[2] = T.RT_287,
		[3] = T.RT_287,
		[4] = T.RT_287,
		[5] = T.RT_287,
		[6] = T.RT_287,
		[7] = T.RT_287,
		[8] = T.RT_287,
		[9] = T.RT_287,
		[10] = T.RT_287,
		[11] = T.RT_287,
		[12] = T.RT_287,
		[13] = T.RT_287,
		[14] = T.RT_287,
		[15] = T.RT_287,
		[16] = T.RT_287,
		[17] = T.RT_287,
		[18] = T.RT_287,
		[19] = T.RT_287,
		[20] = T.RT_287,
	},
	[110404] = {
		[1] = T.RT_290,
		[2] = T.RT_290,
		[3] = T.RT_290,
		[4] = T.RT_290,
		[5] = T.RT_290,
		[6] = T.RT_290,
		[7] = T.RT_290,
		[8] = T.RT_290,
		[9] = T.RT_290,
		[10] = T.RT_290,
		[11] = T.RT_290,
		[12] = T.RT_290,
		[13] = T.RT_290,
		[14] = T.RT_290,
		[15] = T.RT_290,
		[16] = T.RT_290,
		[17] = T.RT_290,
		[18] = T.RT_290,
		[19] = T.RT_290,
		[20] = T.RT_290,
	},
	[110411] = {
		[1] = T.RT_293,
		[2] = T.RT_293,
		[3] = T.RT_293,
		[4] = T.RT_293,
		[5] = T.RT_293,
		[6] = T.RT_293,
		[7] = T.RT_293,
		[8] = T.RT_293,
		[9] = T.RT_293,
		[10] = T.RT_293,
		[11] = T.RT_293,
		[12] = T.RT_293,
		[13] = T.RT_293,
		[14] = T.RT_293,
		[15] = T.RT_293,
		[16] = T.RT_293,
		[17] = T.RT_293,
		[18] = T.RT_293,
		[19] = T.RT_293,
		[20] = T.RT_293,
	},
	[110421] = {
		[1] = T.RT_296,
		[2] = T.RT_296,
		[3] = T.RT_296,
		[4] = T.RT_296,
		[5] = T.RT_296,
		[6] = T.RT_296,
		[7] = T.RT_296,
		[8] = T.RT_296,
		[9] = T.RT_296,
		[10] = T.RT_296,
		[11] = T.RT_296,
		[12] = T.RT_296,
		[13] = T.RT_296,
		[14] = T.RT_296,
		[15] = T.RT_296,
		[16] = T.RT_296,
		[17] = T.RT_296,
		[18] = T.RT_296,
		[19] = T.RT_296,
		[20] = T.RT_296,
	},
	[110431] = {
		[1] = T.RT_299,
		[2] = T.RT_299,
		[3] = T.RT_299,
		[4] = T.RT_299,
		[5] = T.RT_299,
		[6] = T.RT_299,
		[7] = T.RT_299,
		[8] = T.RT_299,
		[9] = T.RT_299,
		[10] = T.RT_299,
		[11] = T.RT_299,
		[12] = T.RT_299,
		[13] = T.RT_299,
		[14] = T.RT_299,
		[15] = T.RT_299,
		[16] = T.RT_299,
		[17] = T.RT_299,
		[18] = T.RT_299,
		[19] = T.RT_299,
		[20] = T.RT_299,
	},
	[110441] = {
		[1] = T.RT_302,
		[2] = T.RT_302,
		[3] = T.RT_302,
		[4] = T.RT_302,
		[5] = T.RT_302,
		[6] = T.RT_302,
		[7] = T.RT_302,
		[8] = T.RT_302,
		[9] = T.RT_302,
		[10] = T.RT_302,
		[11] = T.RT_302,
		[12] = T.RT_302,
		[13] = T.RT_302,
		[14] = T.RT_302,
		[15] = T.RT_302,
		[16] = T.RT_302,
		[17] = T.RT_302,
		[18] = T.RT_302,
		[19] = T.RT_302,
		[20] = T.RT_302,
	},
	[110451] = {
		[1] = T.RT_305,
		[2] = T.RT_305,
		[3] = T.RT_305,
		[4] = T.RT_305,
		[5] = T.RT_305,
		[6] = T.RT_305,
		[7] = T.RT_305,
		[8] = T.RT_305,
		[9] = T.RT_305,
		[10] = T.RT_305,
		[11] = T.RT_305,
		[12] = T.RT_305,
		[13] = T.RT_305,
		[14] = T.RT_305,
		[15] = T.RT_305,
		[16] = T.RT_305,
		[17] = T.RT_305,
		[18] = T.RT_305,
		[19] = T.RT_305,
		[20] = T.RT_305,
	},
	[120101] = {
		[1] = T.RT_307,
		[2] = T.RT_307,
		[3] = T.RT_307,
		[4] = T.RT_307,
		[5] = T.RT_307,
		[6] = T.RT_307,
		[7] = T.RT_307,
		[8] = T.RT_307,
		[9] = T.RT_307,
		[10] = T.RT_307,
		[11] = T.RT_307,
		[12] = T.RT_307,
		[13] = T.RT_307,
		[14] = T.RT_307,
		[15] = T.RT_307,
		[16] = T.RT_307,
		[17] = T.RT_307,
		[18] = T.RT_307,
		[19] = T.RT_307,
		[20] = T.RT_307,
	},
	[120102] = {
		[1] = T.RT_309,
		[2] = T.RT_309,
		[3] = T.RT_309,
		[4] = T.RT_309,
		[5] = T.RT_309,
		[6] = T.RT_309,
		[7] = T.RT_309,
		[8] = T.RT_309,
		[9] = T.RT_309,
		[10] = T.RT_309,
		[11] = T.RT_309,
		[12] = T.RT_309,
		[13] = T.RT_309,
		[14] = T.RT_309,
		[15] = T.RT_309,
		[16] = T.RT_309,
		[17] = T.RT_309,
		[18] = T.RT_309,
		[19] = T.RT_309,
		[20] = T.RT_309,
	},
	[120103] = {
		[1] = T.RT_312,
		[2] = T.RT_312,
		[3] = T.RT_312,
		[4] = T.RT_312,
		[5] = T.RT_312,
		[6] = T.RT_312,
		[7] = T.RT_312,
		[8] = T.RT_312,
		[9] = T.RT_312,
		[10] = T.RT_312,
		[11] = T.RT_312,
		[12] = T.RT_312,
		[13] = T.RT_312,
		[14] = T.RT_312,
		[15] = T.RT_312,
		[16] = T.RT_312,
		[17] = T.RT_312,
		[18] = T.RT_312,
		[19] = T.RT_312,
		[20] = T.RT_312,
	},
	[120104] = {
		[1] = T.RT_315,
		[2] = T.RT_315,
		[3] = T.RT_315,
		[4] = T.RT_315,
		[5] = T.RT_315,
		[6] = T.RT_315,
		[7] = T.RT_315,
		[8] = T.RT_315,
		[9] = T.RT_315,
		[10] = T.RT_315,
		[11] = T.RT_315,
		[12] = T.RT_315,
		[13] = T.RT_315,
		[14] = T.RT_315,
		[15] = T.RT_315,
		[16] = T.RT_315,
		[17] = T.RT_315,
		[18] = T.RT_315,
		[19] = T.RT_315,
		[20] = T.RT_315,
	},
	[120201] = {
		[1] = T.RT_318,
		[2] = T.RT_318,
		[3] = T.RT_318,
		[4] = T.RT_318,
		[5] = T.RT_318,
		[6] = T.RT_318,
		[7] = T.RT_318,
		[8] = T.RT_318,
		[9] = T.RT_318,
		[10] = T.RT_318,
		[11] = T.RT_318,
		[12] = T.RT_318,
		[13] = T.RT_318,
		[14] = T.RT_318,
		[15] = T.RT_318,
		[16] = T.RT_318,
		[17] = T.RT_318,
		[18] = T.RT_318,
		[19] = T.RT_318,
		[20] = T.RT_318,
	},
	[120202] = {
		[1] = T.RT_321,
		[2] = T.RT_321,
		[3] = T.RT_321,
		[4] = T.RT_321,
		[5] = T.RT_321,
		[6] = T.RT_321,
		[7] = T.RT_321,
		[8] = T.RT_321,
		[9] = T.RT_321,
		[10] = T.RT_321,
		[11] = T.RT_321,
		[12] = T.RT_321,
		[13] = T.RT_321,
		[14] = T.RT_321,
		[15] = T.RT_321,
		[16] = T.RT_321,
		[17] = T.RT_321,
		[18] = T.RT_321,
		[19] = T.RT_321,
		[20] = T.RT_321,
	},
	[120203] = {
		[1] = T.RT_324,
		[2] = T.RT_324,
		[3] = T.RT_324,
		[4] = T.RT_324,
		[5] = T.RT_324,
		[6] = T.RT_324,
		[7] = T.RT_324,
		[8] = T.RT_324,
		[9] = T.RT_324,
		[10] = T.RT_324,
		[11] = T.RT_324,
		[12] = T.RT_324,
		[13] = T.RT_324,
		[14] = T.RT_324,
		[15] = T.RT_324,
		[16] = T.RT_324,
		[17] = T.RT_324,
		[18] = T.RT_324,
		[19] = T.RT_324,
		[20] = T.RT_324,
	},
	[120204] = {
		[1] = T.RT_327,
		[2] = T.RT_327,
		[3] = T.RT_327,
		[4] = T.RT_327,
		[5] = T.RT_327,
		[6] = T.RT_327,
		[7] = T.RT_327,
		[8] = T.RT_327,
		[9] = T.RT_327,
		[10] = T.RT_327,
		[11] = T.RT_327,
		[12] = T.RT_327,
		[13] = T.RT_327,
		[14] = T.RT_327,
		[15] = T.RT_327,
		[16] = T.RT_327,
		[17] = T.RT_327,
		[18] = T.RT_327,
		[19] = T.RT_327,
		[20] = T.RT_327,
	},
	[120211] = {
		[1] = T.RT_330,
		[2] = T.RT_330,
		[3] = T.RT_330,
		[4] = T.RT_330,
		[5] = T.RT_330,
		[6] = T.RT_330,
		[7] = T.RT_330,
		[8] = T.RT_330,
		[9] = T.RT_330,
		[10] = T.RT_330,
		[11] = T.RT_330,
		[12] = T.RT_330,
		[13] = T.RT_330,
		[14] = T.RT_330,
		[15] = T.RT_330,
		[16] = T.RT_330,
		[17] = T.RT_330,
		[18] = T.RT_330,
		[19] = T.RT_330,
		[20] = T.RT_330,
	},
	[120221] = {
		[1] = T.RT_332,
		[2] = T.RT_332,
		[3] = T.RT_332,
		[4] = T.RT_332,
		[5] = T.RT_332,
		[6] = T.RT_332,
		[7] = T.RT_332,
		[8] = T.RT_332,
		[9] = T.RT_332,
		[10] = T.RT_332,
		[11] = T.RT_332,
		[12] = T.RT_332,
		[13] = T.RT_332,
		[14] = T.RT_332,
		[15] = T.RT_332,
		[16] = T.RT_332,
		[17] = T.RT_332,
		[18] = T.RT_332,
		[19] = T.RT_332,
		[20] = T.RT_332,
	},
	[150001] = {
		[1] = T.RT_336,
		[2] = T.RT_336,
		[3] = T.RT_336,
		[4] = T.RT_336,
		[5] = T.RT_336,
		[6] = T.RT_336,
		[7] = T.RT_336,
		[8] = T.RT_336,
		[9] = T.RT_336,
		[10] = T.RT_336,
		[11] = T.RT_336,
		[12] = T.RT_336,
		[13] = T.RT_336,
		[14] = T.RT_336,
		[15] = T.RT_336,
		[16] = T.RT_336,
		[17] = T.RT_336,
		[18] = T.RT_336,
		[19] = T.RT_336,
		[20] = T.RT_336,
	},
	[150003] = {
		[1] = T.RT_340,
		[2] = T.RT_340,
		[3] = T.RT_340,
		[4] = T.RT_340,
		[5] = T.RT_340,
		[6] = T.RT_340,
		[7] = T.RT_340,
		[8] = T.RT_340,
		[9] = T.RT_340,
		[10] = T.RT_340,
		[11] = T.RT_340,
		[12] = T.RT_340,
		[13] = T.RT_340,
		[14] = T.RT_340,
		[15] = T.RT_340,
		[16] = T.RT_340,
		[17] = T.RT_340,
		[18] = T.RT_340,
		[19] = T.RT_340,
		[20] = T.RT_340,
	},
	[150101] = {
		[1] = T.RT_343,
		[2] = T.RT_343,
		[3] = T.RT_343,
		[4] = T.RT_343,
		[5] = T.RT_343,
		[6] = T.RT_343,
		[7] = T.RT_343,
		[8] = T.RT_343,
		[9] = T.RT_343,
		[10] = T.RT_343,
		[11] = T.RT_343,
		[12] = T.RT_343,
		[13] = T.RT_343,
		[14] = T.RT_343,
		[15] = T.RT_343,
		[16] = T.RT_343,
		[17] = T.RT_343,
		[18] = T.RT_343,
		[19] = T.RT_343,
		[20] = T.RT_343,
	},
	[150102] = {
		[1] = T.RT_353,
		[2] = T.RT_353,
		[3] = T.RT_353,
		[4] = T.RT_353,
		[5] = T.RT_353,
		[6] = T.RT_353,
		[7] = T.RT_353,
		[8] = T.RT_353,
		[9] = T.RT_353,
		[10] = T.RT_353,
		[11] = T.RT_353,
		[12] = T.RT_353,
		[13] = T.RT_353,
		[14] = T.RT_353,
		[15] = T.RT_353,
		[16] = T.RT_353,
		[17] = T.RT_353,
		[18] = T.RT_353,
		[19] = T.RT_353,
		[20] = T.RT_353,
	},
	[150103] = {
		[1] = T.RT_359,
		[2] = T.RT_359,
		[3] = T.RT_359,
		[4] = T.RT_359,
		[5] = T.RT_359,
		[6] = T.RT_359,
		[7] = T.RT_359,
		[8] = T.RT_359,
		[9] = T.RT_359,
		[10] = T.RT_359,
		[11] = T.RT_359,
		[12] = T.RT_359,
		[13] = T.RT_359,
		[14] = T.RT_359,
		[15] = T.RT_359,
		[16] = T.RT_359,
		[17] = T.RT_359,
		[18] = T.RT_359,
		[19] = T.RT_359,
		[20] = T.RT_359,
	},
	[150104] = {
		[1] = T.RT_365,
		[2] = T.RT_365,
		[3] = T.RT_365,
		[4] = T.RT_365,
		[5] = T.RT_365,
		[6] = T.RT_365,
		[7] = T.RT_365,
		[8] = T.RT_365,
		[9] = T.RT_365,
		[10] = T.RT_365,
		[11] = T.RT_365,
		[12] = T.RT_365,
		[13] = T.RT_365,
		[14] = T.RT_365,
		[15] = T.RT_365,
		[16] = T.RT_365,
		[17] = T.RT_365,
		[18] = T.RT_365,
		[19] = T.RT_365,
		[20] = T.RT_365,
	},
	[150121] = {
		[1] = T.RT_367,
		[2] = T.RT_367,
		[3] = T.RT_367,
		[4] = T.RT_367,
		[5] = T.RT_367,
		[6] = T.RT_367,
		[7] = T.RT_367,
		[8] = T.RT_367,
		[9] = T.RT_367,
		[10] = T.RT_367,
		[11] = T.RT_367,
		[12] = T.RT_367,
		[13] = T.RT_367,
		[14] = T.RT_367,
		[15] = T.RT_367,
		[16] = T.RT_367,
		[17] = T.RT_367,
		[18] = T.RT_367,
		[19] = T.RT_367,
		[20] = T.RT_367,
	},
	[150123] = {
		[1] = T.RT_369,
		[2] = T.RT_369,
		[3] = T.RT_369,
		[4] = T.RT_369,
		[5] = T.RT_369,
		[6] = T.RT_369,
		[7] = T.RT_369,
		[8] = T.RT_369,
		[9] = T.RT_369,
		[10] = T.RT_369,
		[11] = T.RT_369,
		[12] = T.RT_369,
		[13] = T.RT_369,
		[14] = T.RT_369,
		[15] = T.RT_369,
		[16] = T.RT_369,
		[17] = T.RT_369,
		[18] = T.RT_369,
		[19] = T.RT_369,
		[20] = T.RT_369,
	},
	[150124] = {
		[1] = T.RT_372,
		[2] = T.RT_372,
		[3] = T.RT_372,
		[4] = T.RT_372,
		[5] = T.RT_372,
		[6] = T.RT_372,
		[7] = T.RT_372,
		[8] = T.RT_372,
		[9] = T.RT_372,
		[10] = T.RT_372,
		[11] = T.RT_372,
		[12] = T.RT_372,
		[13] = T.RT_372,
		[14] = T.RT_372,
		[15] = T.RT_372,
		[16] = T.RT_372,
		[17] = T.RT_372,
		[18] = T.RT_372,
		[19] = T.RT_372,
		[20] = T.RT_372,
	},
	[150125] = {
		[1] = T.RT_374,
		[2] = T.RT_374,
		[3] = T.RT_374,
		[4] = T.RT_374,
		[5] = T.RT_374,
		[6] = T.RT_374,
		[7] = T.RT_374,
		[8] = T.RT_374,
		[9] = T.RT_374,
		[10] = T.RT_374,
		[11] = T.RT_374,
		[12] = T.RT_374,
		[13] = T.RT_374,
		[14] = T.RT_374,
		[15] = T.RT_374,
		[16] = T.RT_374,
		[17] = T.RT_374,
		[18] = T.RT_374,
		[19] = T.RT_374,
		[20] = T.RT_374,
	},
	[150126] = {
		[1] = T.RT_376,
		[2] = T.RT_376,
		[3] = T.RT_376,
		[4] = T.RT_376,
		[5] = T.RT_376,
		[6] = T.RT_376,
		[7] = T.RT_376,
		[8] = T.RT_376,
		[9] = T.RT_376,
		[10] = T.RT_376,
		[11] = T.RT_376,
		[12] = T.RT_376,
		[13] = T.RT_376,
		[14] = T.RT_376,
		[15] = T.RT_376,
		[16] = T.RT_376,
		[17] = T.RT_376,
		[18] = T.RT_376,
		[19] = T.RT_376,
		[20] = T.RT_376,
	},
	[150201] = {
		[1] = T.RT_388,
		[2] = T.RT_388,
		[3] = T.RT_388,
		[4] = T.RT_388,
		[5] = T.RT_388,
		[6] = T.RT_388,
		[7] = T.RT_388,
		[8] = T.RT_388,
		[9] = T.RT_388,
		[10] = T.RT_388,
		[11] = T.RT_388,
		[12] = T.RT_388,
		[13] = T.RT_388,
		[14] = T.RT_388,
		[15] = T.RT_388,
		[16] = T.RT_388,
		[17] = T.RT_388,
		[18] = T.RT_388,
		[19] = T.RT_388,
		[20] = T.RT_388,
	},
	[150202] = {
		[1] = T.RT_393,
		[2] = T.RT_393,
		[3] = T.RT_393,
		[4] = T.RT_393,
		[5] = T.RT_393,
		[6] = T.RT_393,
		[7] = T.RT_393,
		[8] = T.RT_393,
		[9] = T.RT_393,
		[10] = T.RT_393,
		[11] = T.RT_393,
		[12] = T.RT_393,
		[13] = T.RT_393,
		[14] = T.RT_393,
		[15] = T.RT_393,
		[16] = T.RT_393,
		[17] = T.RT_393,
		[18] = T.RT_393,
		[19] = T.RT_393,
		[20] = T.RT_393,
	},
	[150203] = {
		[1] = T.RT_398,
		[2] = T.RT_398,
		[3] = T.RT_398,
		[4] = T.RT_398,
		[5] = T.RT_398,
		[6] = T.RT_398,
		[7] = T.RT_398,
		[8] = T.RT_398,
		[9] = T.RT_398,
		[10] = T.RT_398,
		[11] = T.RT_398,
		[12] = T.RT_398,
		[13] = T.RT_398,
		[14] = T.RT_398,
		[15] = T.RT_398,
		[16] = T.RT_398,
		[17] = T.RT_398,
		[18] = T.RT_398,
		[19] = T.RT_398,
		[20] = T.RT_398,
	},
	[150204] = {
		[1] = T.RT_403,
		[2] = T.RT_403,
		[3] = T.RT_403,
		[4] = T.RT_403,
		[5] = T.RT_403,
		[6] = T.RT_403,
		[7] = T.RT_403,
		[8] = T.RT_403,
		[9] = T.RT_403,
		[10] = T.RT_403,
		[11] = T.RT_403,
		[12] = T.RT_403,
		[13] = T.RT_403,
		[14] = T.RT_403,
		[15] = T.RT_403,
		[16] = T.RT_403,
		[17] = T.RT_403,
		[18] = T.RT_403,
		[19] = T.RT_403,
		[20] = T.RT_403,
	},
	[150211] = {
		[1] = T.RT_405,
		[2] = T.RT_405,
		[3] = T.RT_405,
		[4] = T.RT_405,
		[5] = T.RT_405,
		[6] = T.RT_405,
		[7] = T.RT_405,
		[8] = T.RT_405,
		[9] = T.RT_405,
		[10] = T.RT_405,
		[11] = T.RT_405,
		[12] = T.RT_405,
		[13] = T.RT_405,
		[14] = T.RT_405,
		[15] = T.RT_405,
		[16] = T.RT_405,
		[17] = T.RT_405,
		[18] = T.RT_405,
		[19] = T.RT_405,
		[20] = T.RT_405,
	},
	[150212] = {
		[1] = T.RT_407,
		[2] = T.RT_407,
		[3] = T.RT_407,
		[4] = T.RT_407,
		[5] = T.RT_407,
		[6] = T.RT_407,
		[7] = T.RT_407,
		[8] = T.RT_407,
		[9] = T.RT_407,
		[10] = T.RT_407,
		[11] = T.RT_407,
		[12] = T.RT_407,
		[13] = T.RT_407,
		[14] = T.RT_407,
		[15] = T.RT_407,
		[16] = T.RT_407,
		[17] = T.RT_407,
		[18] = T.RT_407,
		[19] = T.RT_407,
		[20] = T.RT_407,
	},
	[150213] = {
		[1] = T.RT_409,
		[2] = T.RT_409,
		[3] = T.RT_409,
		[4] = T.RT_409,
		[5] = T.RT_409,
		[6] = T.RT_409,
		[7] = T.RT_409,
		[8] = T.RT_409,
		[9] = T.RT_409,
		[10] = T.RT_409,
		[11] = T.RT_409,
		[12] = T.RT_409,
		[13] = T.RT_409,
		[14] = T.RT_409,
		[15] = T.RT_409,
		[16] = T.RT_409,
		[17] = T.RT_409,
		[18] = T.RT_409,
		[19] = T.RT_409,
		[20] = T.RT_409,
	},
	[150301] = {
		[1] = T.RT_416,
		[2] = T.RT_416,
		[3] = T.RT_416,
		[4] = T.RT_416,
		[5] = T.RT_416,
		[6] = T.RT_416,
		[7] = T.RT_416,
		[8] = T.RT_416,
		[9] = T.RT_416,
		[10] = T.RT_416,
		[11] = T.RT_416,
		[12] = T.RT_416,
		[13] = T.RT_416,
		[14] = T.RT_416,
		[15] = T.RT_416,
		[16] = T.RT_416,
		[17] = T.RT_416,
		[18] = T.RT_416,
		[19] = T.RT_416,
		[20] = T.RT_416,
	},
	[150302] = {
		[1] = T.RT_428,
		[2] = T.RT_428,
		[3] = T.RT_428,
		[4] = T.RT_428,
		[5] = T.RT_428,
		[6] = T.RT_428,
		[7] = T.RT_428,
		[8] = T.RT_428,
		[9] = T.RT_428,
		[10] = T.RT_428,
		[11] = T.RT_428,
		[12] = T.RT_428,
		[13] = T.RT_428,
		[14] = T.RT_428,
		[15] = T.RT_428,
		[16] = T.RT_428,
		[17] = T.RT_428,
		[18] = T.RT_428,
		[19] = T.RT_428,
		[20] = T.RT_428,
	},
	[150303] = {
		[1] = T.RT_433,
		[2] = T.RT_433,
		[3] = T.RT_433,
		[4] = T.RT_433,
		[5] = T.RT_433,
		[6] = T.RT_433,
		[7] = T.RT_433,
		[8] = T.RT_433,
		[9] = T.RT_433,
		[10] = T.RT_433,
		[11] = T.RT_433,
		[12] = T.RT_433,
		[13] = T.RT_433,
		[14] = T.RT_433,
		[15] = T.RT_433,
		[16] = T.RT_433,
		[17] = T.RT_433,
		[18] = T.RT_433,
		[19] = T.RT_433,
		[20] = T.RT_433,
	},
	[150304] = {
		[1] = T.RT_438,
		[2] = T.RT_438,
		[3] = T.RT_438,
		[4] = T.RT_438,
		[5] = T.RT_438,
		[6] = T.RT_438,
		[7] = T.RT_438,
		[8] = T.RT_438,
		[9] = T.RT_438,
		[10] = T.RT_438,
		[11] = T.RT_438,
		[12] = T.RT_438,
		[13] = T.RT_438,
		[14] = T.RT_438,
		[15] = T.RT_438,
		[16] = T.RT_438,
		[17] = T.RT_438,
		[18] = T.RT_438,
		[19] = T.RT_438,
		[20] = T.RT_438,
	},
	[150311] = {
		[1] = T.RT_448,
		[2] = T.RT_448,
		[3] = T.RT_448,
		[4] = T.RT_448,
		[5] = T.RT_448,
		[6] = T.RT_448,
		[7] = T.RT_448,
		[8] = T.RT_448,
		[9] = T.RT_448,
		[10] = T.RT_448,
		[11] = T.RT_448,
		[12] = T.RT_448,
		[13] = T.RT_448,
		[14] = T.RT_448,
		[15] = T.RT_448,
		[16] = T.RT_448,
		[17] = T.RT_448,
		[18] = T.RT_448,
		[19] = T.RT_448,
		[20] = T.RT_448,
	},
	[150321] = {
		[1] = T.RT_474,
		[2] = T.RT_474,
		[3] = T.RT_474,
		[4] = T.RT_474,
		[5] = T.RT_474,
		[6] = T.RT_474,
		[7] = T.RT_474,
		[8] = T.RT_474,
		[9] = T.RT_474,
		[10] = T.RT_474,
		[11] = T.RT_474,
		[12] = T.RT_474,
		[13] = T.RT_474,
		[14] = T.RT_474,
		[15] = T.RT_474,
		[16] = T.RT_474,
		[17] = T.RT_474,
		[18] = T.RT_474,
		[19] = T.RT_474,
		[20] = T.RT_474,
	},
	[150401] = {
		[1] = T.RT_480,
		[2] = T.RT_480,
		[3] = T.RT_480,
		[4] = T.RT_480,
		[5] = T.RT_480,
		[6] = T.RT_480,
		[7] = T.RT_480,
		[8] = T.RT_480,
		[9] = T.RT_480,
		[10] = T.RT_480,
		[11] = T.RT_480,
		[12] = T.RT_480,
		[13] = T.RT_480,
		[14] = T.RT_480,
		[15] = T.RT_480,
		[16] = T.RT_480,
		[17] = T.RT_480,
		[18] = T.RT_480,
		[19] = T.RT_480,
		[20] = T.RT_480,
	},
	[150402] = {
		[1] = T.RT_487,
		[2] = T.RT_487,
		[3] = T.RT_487,
		[4] = T.RT_487,
		[5] = T.RT_487,
		[6] = T.RT_487,
		[7] = T.RT_487,
		[8] = T.RT_487,
		[9] = T.RT_487,
		[10] = T.RT_487,
		[11] = T.RT_487,
		[12] = T.RT_487,
		[13] = T.RT_487,
		[14] = T.RT_487,
		[15] = T.RT_487,
		[16] = T.RT_487,
		[17] = T.RT_487,
		[18] = T.RT_487,
		[19] = T.RT_487,
		[20] = T.RT_487,
	},
	[150403] = {
		[1] = T.RT_495,
		[2] = T.RT_495,
		[3] = T.RT_495,
		[4] = T.RT_495,
		[5] = T.RT_495,
		[6] = T.RT_495,
		[7] = T.RT_495,
		[8] = T.RT_495,
		[9] = T.RT_495,
		[10] = T.RT_495,
		[11] = T.RT_495,
		[12] = T.RT_495,
		[13] = T.RT_495,
		[14] = T.RT_495,
		[15] = T.RT_495,
		[16] = T.RT_495,
		[17] = T.RT_495,
		[18] = T.RT_495,
		[19] = T.RT_495,
		[20] = T.RT_495,
	},
	[150404] = {
		[1] = T.RT_500,
		[2] = T.RT_500,
		[3] = T.RT_500,
		[4] = T.RT_500,
		[5] = T.RT_500,
		[6] = T.RT_500,
		[7] = T.RT_500,
		[8] = T.RT_500,
		[9] = T.RT_500,
		[10] = T.RT_500,
		[11] = T.RT_500,
		[12] = T.RT_500,
		[13] = T.RT_500,
		[14] = T.RT_500,
		[15] = T.RT_500,
		[16] = T.RT_500,
		[17] = T.RT_500,
		[18] = T.RT_500,
		[19] = T.RT_500,
		[20] = T.RT_500,
	},
	[150405] = {
		[1] = T.RT_502,
		[2] = T.RT_502,
		[3] = T.RT_502,
		[4] = T.RT_502,
		[5] = T.RT_502,
		[6] = T.RT_502,
		[7] = T.RT_502,
		[8] = T.RT_502,
		[9] = T.RT_502,
		[10] = T.RT_502,
		[11] = T.RT_502,
		[12] = T.RT_502,
		[13] = T.RT_502,
		[14] = T.RT_502,
		[15] = T.RT_502,
		[16] = T.RT_502,
		[17] = T.RT_502,
		[18] = T.RT_502,
		[19] = T.RT_502,
		[20] = T.RT_502,
	},
	[150411] = {
		[1] = T.RT_504,
		[2] = T.RT_504,
		[3] = T.RT_504,
		[4] = T.RT_504,
		[5] = T.RT_504,
		[6] = T.RT_504,
		[7] = T.RT_504,
		[8] = T.RT_504,
		[9] = T.RT_504,
		[10] = T.RT_504,
		[11] = T.RT_504,
		[12] = T.RT_504,
		[13] = T.RT_504,
		[14] = T.RT_504,
		[15] = T.RT_504,
		[16] = T.RT_504,
		[17] = T.RT_504,
		[18] = T.RT_504,
		[19] = T.RT_504,
		[20] = T.RT_504,
	},
	[150421] = {
		[1] = T.RT_506,
		[2] = T.RT_506,
		[3] = T.RT_506,
		[4] = T.RT_506,
		[5] = T.RT_506,
		[6] = T.RT_506,
		[7] = T.RT_506,
		[8] = T.RT_506,
		[9] = T.RT_506,
		[10] = T.RT_506,
		[11] = T.RT_506,
		[12] = T.RT_506,
		[13] = T.RT_506,
		[14] = T.RT_506,
		[15] = T.RT_506,
		[16] = T.RT_506,
		[17] = T.RT_506,
		[18] = T.RT_506,
		[19] = T.RT_506,
		[20] = T.RT_506,
	},
	[150422] = {
		[1] = T.RT_509,
		[2] = T.RT_509,
		[3] = T.RT_509,
		[4] = T.RT_509,
		[5] = T.RT_509,
		[6] = T.RT_509,
		[7] = T.RT_509,
		[8] = T.RT_509,
		[9] = T.RT_509,
		[10] = T.RT_509,
		[11] = T.RT_509,
		[12] = T.RT_509,
		[13] = T.RT_509,
		[14] = T.RT_509,
		[15] = T.RT_509,
		[16] = T.RT_509,
		[17] = T.RT_509,
		[18] = T.RT_509,
		[19] = T.RT_509,
		[20] = T.RT_509,
	},
	[150431] = {
		[1] = T.RT_511,
		[2] = T.RT_511,
		[3] = T.RT_511,
		[4] = T.RT_511,
		[5] = T.RT_511,
		[6] = T.RT_511,
		[7] = T.RT_511,
		[8] = T.RT_511,
		[9] = T.RT_511,
		[10] = T.RT_511,
		[11] = T.RT_511,
		[12] = T.RT_511,
		[13] = T.RT_511,
		[14] = T.RT_511,
		[15] = T.RT_511,
		[16] = T.RT_511,
		[17] = T.RT_511,
		[18] = T.RT_511,
		[19] = T.RT_511,
		[20] = T.RT_511,
	},
	[150441] = {
		[1] = T.RT_513,
		[2] = T.RT_513,
		[3] = T.RT_513,
		[4] = T.RT_513,
		[5] = T.RT_513,
		[6] = T.RT_513,
		[7] = T.RT_513,
		[8] = T.RT_513,
		[9] = T.RT_513,
		[10] = T.RT_513,
		[11] = T.RT_513,
		[12] = T.RT_513,
		[13] = T.RT_513,
		[14] = T.RT_513,
		[15] = T.RT_513,
		[16] = T.RT_513,
		[17] = T.RT_513,
		[18] = T.RT_513,
		[19] = T.RT_513,
		[20] = T.RT_513,
	},
	[150501] = {
		[1] = T.RT_516,
		[2] = T.RT_516,
		[3] = T.RT_516,
		[4] = T.RT_516,
		[5] = T.RT_516,
		[6] = T.RT_516,
		[7] = T.RT_516,
		[8] = T.RT_516,
		[9] = T.RT_516,
		[10] = T.RT_516,
		[11] = T.RT_516,
		[12] = T.RT_516,
		[13] = T.RT_516,
		[14] = T.RT_516,
		[15] = T.RT_516,
		[16] = T.RT_516,
		[17] = T.RT_516,
		[18] = T.RT_516,
		[19] = T.RT_516,
		[20] = T.RT_516,
	},
	[150502] = {
		[1] = T.RT_519,
		[2] = T.RT_519,
		[3] = T.RT_519,
		[4] = T.RT_519,
		[5] = T.RT_519,
		[6] = T.RT_519,
		[7] = T.RT_519,
		[8] = T.RT_519,
		[9] = T.RT_519,
		[10] = T.RT_519,
		[11] = T.RT_519,
		[12] = T.RT_519,
		[13] = T.RT_519,
		[14] = T.RT_519,
		[15] = T.RT_519,
		[16] = T.RT_519,
		[17] = T.RT_519,
		[18] = T.RT_519,
		[19] = T.RT_519,
		[20] = T.RT_519,
	},
	[150503] = {
		[1] = T.RT_522,
		[2] = T.RT_522,
		[3] = T.RT_522,
		[4] = T.RT_522,
		[5] = T.RT_522,
		[6] = T.RT_522,
		[7] = T.RT_522,
		[8] = T.RT_522,
		[9] = T.RT_522,
		[10] = T.RT_522,
		[11] = T.RT_522,
		[12] = T.RT_522,
		[13] = T.RT_522,
		[14] = T.RT_522,
		[15] = T.RT_522,
		[16] = T.RT_522,
		[17] = T.RT_522,
		[18] = T.RT_522,
		[19] = T.RT_522,
		[20] = T.RT_522,
	},
	[150504] = {
		[1] = T.RT_525,
		[2] = T.RT_525,
		[3] = T.RT_525,
		[4] = T.RT_525,
		[5] = T.RT_525,
		[6] = T.RT_525,
		[7] = T.RT_525,
		[8] = T.RT_525,
		[9] = T.RT_525,
		[10] = T.RT_525,
		[11] = T.RT_525,
		[12] = T.RT_525,
		[13] = T.RT_525,
		[14] = T.RT_525,
		[15] = T.RT_525,
		[16] = T.RT_525,
		[17] = T.RT_525,
		[18] = T.RT_525,
		[19] = T.RT_525,
		[20] = T.RT_525,
	},
	[150511] = {
		[1] = T.RT_527,
		[2] = T.RT_527,
		[3] = T.RT_527,
		[4] = T.RT_527,
		[5] = T.RT_527,
		[6] = T.RT_527,
		[7] = T.RT_527,
		[8] = T.RT_527,
		[9] = T.RT_527,
		[10] = T.RT_527,
		[11] = T.RT_527,
		[12] = T.RT_527,
		[13] = T.RT_527,
		[14] = T.RT_527,
		[15] = T.RT_527,
		[16] = T.RT_527,
		[17] = T.RT_527,
		[18] = T.RT_527,
		[19] = T.RT_527,
		[20] = T.RT_527,
	},
	[150512] = {
		[1] = T.RT_529,
		[2] = T.RT_529,
		[3] = T.RT_529,
		[4] = T.RT_529,
		[5] = T.RT_529,
		[6] = T.RT_529,
		[7] = T.RT_529,
		[8] = T.RT_529,
		[9] = T.RT_529,
		[10] = T.RT_529,
		[11] = T.RT_529,
		[12] = T.RT_529,
		[13] = T.RT_529,
		[14] = T.RT_529,
		[15] = T.RT_529,
		[16] = T.RT_529,
		[17] = T.RT_529,
		[18] = T.RT_529,
		[19] = T.RT_529,
		[20] = T.RT_529,
	},
	[150513] = {
		[1] = T.RT_531,
		[2] = T.RT_531,
		[3] = T.RT_531,
		[4] = T.RT_531,
		[5] = T.RT_531,
		[6] = T.RT_531,
		[7] = T.RT_531,
		[8] = T.RT_531,
		[9] = T.RT_531,
		[10] = T.RT_531,
		[11] = T.RT_531,
		[12] = T.RT_531,
		[13] = T.RT_531,
		[14] = T.RT_531,
		[15] = T.RT_531,
		[16] = T.RT_531,
		[17] = T.RT_531,
		[18] = T.RT_531,
		[19] = T.RT_531,
		[20] = T.RT_531,
	},
	[150514] = {
		[1] = T.RT_533,
		[2] = T.RT_533,
		[3] = T.RT_533,
		[4] = T.RT_533,
		[5] = T.RT_533,
		[6] = T.RT_533,
		[7] = T.RT_533,
		[8] = T.RT_533,
		[9] = T.RT_533,
		[10] = T.RT_533,
		[11] = T.RT_533,
		[12] = T.RT_533,
		[13] = T.RT_533,
		[14] = T.RT_533,
		[15] = T.RT_533,
		[16] = T.RT_533,
		[17] = T.RT_533,
		[18] = T.RT_533,
		[19] = T.RT_533,
		[20] = T.RT_533,
	},
	[150521] = {
		[1] = T.RT_535,
		[2] = T.RT_535,
		[3] = T.RT_535,
		[4] = T.RT_535,
		[5] = T.RT_535,
		[6] = T.RT_535,
		[7] = T.RT_535,
		[8] = T.RT_535,
		[9] = T.RT_535,
		[10] = T.RT_535,
		[11] = T.RT_535,
		[12] = T.RT_535,
		[13] = T.RT_535,
		[14] = T.RT_535,
		[15] = T.RT_535,
		[16] = T.RT_535,
		[17] = T.RT_535,
		[18] = T.RT_535,
		[19] = T.RT_535,
		[20] = T.RT_535,
	},
	[160101] = {
		[1] = T.RT_539,
		[2] = T.RT_539,
		[3] = T.RT_539,
		[4] = T.RT_539,
		[5] = T.RT_539,
		[6] = T.RT_539,
		[7] = T.RT_539,
		[8] = T.RT_539,
		[9] = T.RT_539,
		[10] = T.RT_539,
		[11] = T.RT_539,
		[12] = T.RT_539,
		[13] = T.RT_539,
		[14] = T.RT_539,
		[15] = T.RT_539,
		[16] = T.RT_539,
		[17] = T.RT_539,
		[18] = T.RT_539,
		[19] = T.RT_539,
		[20] = T.RT_539,
	},
	[160102] = {
		[1] = T.RT_548,
		[2] = T.RT_548,
		[3] = T.RT_548,
		[4] = T.RT_548,
		[5] = T.RT_548,
		[6] = T.RT_548,
		[7] = T.RT_548,
		[8] = T.RT_548,
		[9] = T.RT_548,
		[10] = T.RT_548,
		[11] = T.RT_548,
		[12] = T.RT_548,
		[13] = T.RT_548,
		[14] = T.RT_548,
		[15] = T.RT_548,
		[16] = T.RT_548,
		[17] = T.RT_548,
		[18] = T.RT_548,
		[19] = T.RT_548,
		[20] = T.RT_548,
	},
	[160103] = {
		[1] = T.RT_554,
		[2] = T.RT_554,
		[3] = T.RT_554,
		[4] = T.RT_554,
		[5] = T.RT_554,
		[6] = T.RT_554,
		[7] = T.RT_554,
		[8] = T.RT_554,
		[9] = T.RT_554,
		[10] = T.RT_554,
		[11] = T.RT_554,
		[12] = T.RT_554,
		[13] = T.RT_554,
		[14] = T.RT_554,
		[15] = T.RT_554,
		[16] = T.RT_554,
		[17] = T.RT_554,
		[18] = T.RT_554,
		[19] = T.RT_554,
		[20] = T.RT_554,
	},
	[160104] = {
		[1] = T.RT_559,
		[2] = T.RT_559,
		[3] = T.RT_559,
		[4] = T.RT_559,
		[5] = T.RT_559,
		[6] = T.RT_559,
		[7] = T.RT_559,
		[8] = T.RT_559,
		[9] = T.RT_559,
		[10] = T.RT_559,
		[11] = T.RT_559,
		[12] = T.RT_559,
		[13] = T.RT_559,
		[14] = T.RT_559,
		[15] = T.RT_559,
		[16] = T.RT_559,
		[17] = T.RT_559,
		[18] = T.RT_559,
		[19] = T.RT_559,
		[20] = T.RT_559,
	},
	[160191] = {
		[1] = T.RT_561,
		[2] = T.RT_561,
		[3] = T.RT_561,
		[4] = T.RT_561,
		[5] = T.RT_561,
		[6] = T.RT_561,
		[7] = T.RT_561,
		[8] = T.RT_561,
		[9] = T.RT_561,
		[10] = T.RT_561,
		[11] = T.RT_561,
		[12] = T.RT_561,
		[13] = T.RT_561,
		[14] = T.RT_561,
		[15] = T.RT_561,
		[16] = T.RT_561,
		[17] = T.RT_561,
		[18] = T.RT_561,
		[19] = T.RT_561,
		[20] = T.RT_561,
	},
	[160192] = {
		[1] = T.RT_563,
		[2] = T.RT_563,
		[3] = T.RT_563,
		[4] = T.RT_563,
		[5] = T.RT_563,
		[6] = T.RT_563,
		[7] = T.RT_563,
		[8] = T.RT_563,
		[9] = T.RT_563,
		[10] = T.RT_563,
		[11] = T.RT_563,
		[12] = T.RT_563,
		[13] = T.RT_563,
		[14] = T.RT_563,
		[15] = T.RT_563,
		[16] = T.RT_563,
		[17] = T.RT_563,
		[18] = T.RT_563,
		[19] = T.RT_563,
		[20] = T.RT_563,
	},
	[180101] = {
		[1] = T.RT_568,
		[2] = T.RT_568,
		[3] = T.RT_568,
		[4] = T.RT_568,
		[5] = T.RT_568,
		[6] = T.RT_568,
		[7] = T.RT_568,
		[8] = T.RT_568,
		[9] = T.RT_568,
		[10] = T.RT_568,
		[11] = T.RT_568,
		[12] = T.RT_568,
		[13] = T.RT_568,
		[14] = T.RT_568,
		[15] = T.RT_568,
		[16] = T.RT_568,
		[17] = T.RT_568,
		[18] = T.RT_568,
		[19] = T.RT_568,
		[20] = T.RT_568,
	},
	[180102] = {
		[1] = T.RT_575,
		[2] = T.RT_575,
		[3] = T.RT_575,
		[4] = T.RT_575,
		[5] = T.RT_575,
		[6] = T.RT_575,
		[7] = T.RT_575,
		[8] = T.RT_575,
		[9] = T.RT_575,
		[10] = T.RT_575,
		[11] = T.RT_575,
		[12] = T.RT_575,
		[13] = T.RT_575,
		[14] = T.RT_575,
		[15] = T.RT_575,
		[16] = T.RT_575,
		[17] = T.RT_575,
		[18] = T.RT_575,
		[19] = T.RT_575,
		[20] = T.RT_575,
	},
	[180103] = {
		[1] = T.RT_585,
		[2] = T.RT_585,
		[3] = T.RT_585,
		[4] = T.RT_585,
		[5] = T.RT_585,
		[6] = T.RT_585,
		[7] = T.RT_585,
		[8] = T.RT_585,
		[9] = T.RT_585,
		[10] = T.RT_585,
		[11] = T.RT_585,
		[12] = T.RT_585,
		[13] = T.RT_585,
		[14] = T.RT_585,
		[15] = T.RT_585,
		[16] = T.RT_585,
		[17] = T.RT_585,
		[18] = T.RT_585,
		[19] = T.RT_585,
		[20] = T.RT_585,
	},
	[180104] = {
		[1] = T.RT_591,
		[2] = T.RT_591,
		[3] = T.RT_591,
		[4] = T.RT_591,
		[5] = T.RT_591,
		[6] = T.RT_591,
		[7] = T.RT_591,
		[8] = T.RT_591,
		[9] = T.RT_591,
		[10] = T.RT_591,
		[11] = T.RT_591,
		[12] = T.RT_591,
		[13] = T.RT_591,
		[14] = T.RT_591,
		[15] = T.RT_591,
		[16] = T.RT_591,
		[17] = T.RT_591,
		[18] = T.RT_591,
		[19] = T.RT_591,
		[20] = T.RT_591,
	},
	[180111] = {
		[1] = T.RT_595,
		[2] = T.RT_595,
		[3] = T.RT_595,
		[4] = T.RT_595,
		[5] = T.RT_595,
		[6] = T.RT_595,
		[7] = T.RT_595,
		[8] = T.RT_595,
		[9] = T.RT_595,
		[10] = T.RT_595,
		[11] = T.RT_595,
		[12] = T.RT_595,
		[13] = T.RT_595,
		[14] = T.RT_595,
		[15] = T.RT_595,
		[16] = T.RT_595,
		[17] = T.RT_595,
		[18] = T.RT_595,
		[19] = T.RT_595,
		[20] = T.RT_595,
	},
	[180121] = {
		[1] = T.RT_601,
		[2] = T.RT_601,
		[3] = T.RT_601,
		[4] = T.RT_601,
		[5] = T.RT_601,
		[6] = T.RT_601,
		[7] = T.RT_601,
		[8] = T.RT_601,
		[9] = T.RT_601,
		[10] = T.RT_601,
		[11] = T.RT_601,
		[12] = T.RT_601,
		[13] = T.RT_601,
		[14] = T.RT_601,
		[15] = T.RT_601,
		[16] = T.RT_601,
		[17] = T.RT_601,
		[18] = T.RT_601,
		[19] = T.RT_601,
		[20] = T.RT_601,
	},
	[180122] = {
		[1] = T.RT_603,
		[2] = T.RT_603,
		[3] = T.RT_603,
		[4] = T.RT_603,
		[5] = T.RT_603,
		[6] = T.RT_603,
		[7] = T.RT_603,
		[8] = T.RT_603,
		[9] = T.RT_603,
		[10] = T.RT_603,
		[11] = T.RT_603,
		[12] = T.RT_603,
		[13] = T.RT_603,
		[14] = T.RT_603,
		[15] = T.RT_603,
		[16] = T.RT_603,
		[17] = T.RT_603,
		[18] = T.RT_603,
		[19] = T.RT_603,
		[20] = T.RT_603,
	},
	[180191] = {
		[1] = T.RT_607,
		[2] = T.RT_607,
		[3] = T.RT_607,
		[4] = T.RT_607,
		[5] = T.RT_607,
		[6] = T.RT_607,
		[7] = T.RT_607,
		[8] = T.RT_607,
		[9] = T.RT_607,
		[10] = T.RT_607,
		[11] = T.RT_607,
		[12] = T.RT_607,
		[13] = T.RT_607,
		[14] = T.RT_607,
		[15] = T.RT_607,
		[16] = T.RT_607,
		[17] = T.RT_607,
		[18] = T.RT_607,
		[19] = T.RT_607,
		[20] = T.RT_607,
	},
	[210001] = {
		[1] = T.RT_733,
		[2] = T.RT_733,
		[3] = T.RT_733,
		[4] = T.RT_733,
		[5] = T.RT_733,
		[6] = T.RT_733,
		[7] = T.RT_733,
		[8] = T.RT_733,
		[9] = T.RT_733,
		[10] = T.RT_733,
		[11] = T.RT_733,
		[12] = T.RT_733,
		[13] = T.RT_733,
		[14] = T.RT_733,
		[15] = T.RT_733,
		[16] = T.RT_733,
		[17] = T.RT_733,
		[18] = T.RT_733,
		[19] = T.RT_733,
		[20] = T.RT_733,
	},
	[210003] = {
		[1] = T.RT_737,
		[2] = T.RT_737,
		[3] = T.RT_737,
		[4] = T.RT_737,
		[5] = T.RT_737,
		[6] = T.RT_737,
		[7] = T.RT_737,
		[8] = T.RT_737,
		[9] = T.RT_737,
		[10] = T.RT_737,
		[11] = T.RT_737,
		[12] = T.RT_737,
		[13] = T.RT_737,
		[14] = T.RT_737,
		[15] = T.RT_737,
		[16] = T.RT_737,
		[17] = T.RT_737,
		[18] = T.RT_737,
		[19] = T.RT_737,
		[20] = T.RT_737,
	},
	[210101] = {
		[1] = T.RT_747,
		[2] = T.RT_747,
		[3] = T.RT_747,
		[4] = T.RT_747,
		[5] = T.RT_747,
		[6] = T.RT_747,
		[7] = T.RT_747,
		[8] = T.RT_747,
		[9] = T.RT_747,
		[10] = T.RT_747,
		[11] = T.RT_747,
		[12] = T.RT_747,
		[13] = T.RT_747,
		[14] = T.RT_747,
		[15] = T.RT_747,
		[16] = T.RT_747,
		[17] = T.RT_747,
		[18] = T.RT_747,
		[19] = T.RT_747,
		[20] = T.RT_747,
	},
	[210102] = {
		[1] = T.RT_752,
		[2] = T.RT_752,
		[3] = T.RT_752,
		[4] = T.RT_752,
		[5] = T.RT_752,
		[6] = T.RT_752,
		[7] = T.RT_752,
		[8] = T.RT_752,
		[9] = T.RT_752,
		[10] = T.RT_752,
		[11] = T.RT_752,
		[12] = T.RT_752,
		[13] = T.RT_752,
		[14] = T.RT_752,
		[15] = T.RT_752,
		[16] = T.RT_752,
		[17] = T.RT_752,
		[18] = T.RT_752,
		[19] = T.RT_752,
		[20] = T.RT_752,
	},
	[210103] = {
		[1] = T.RT_759,
		[2] = T.RT_759,
		[3] = T.RT_759,
		[4] = T.RT_759,
		[5] = T.RT_759,
		[6] = T.RT_759,
		[7] = T.RT_759,
		[8] = T.RT_759,
		[9] = T.RT_759,
		[10] = T.RT_759,
		[11] = T.RT_759,
		[12] = T.RT_759,
		[13] = T.RT_759,
		[14] = T.RT_759,
		[15] = T.RT_759,
		[16] = T.RT_759,
		[17] = T.RT_759,
		[18] = T.RT_759,
		[19] = T.RT_759,
		[20] = T.RT_759,
	},
	[210104] = {
		[1] = T.RT_763,
		[2] = T.RT_763,
		[3] = T.RT_763,
		[4] = T.RT_763,
		[5] = T.RT_763,
		[6] = T.RT_763,
		[7] = T.RT_763,
		[8] = T.RT_763,
		[9] = T.RT_763,
		[10] = T.RT_763,
		[11] = T.RT_763,
		[12] = T.RT_763,
		[13] = T.RT_763,
		[14] = T.RT_763,
		[15] = T.RT_763,
		[16] = T.RT_763,
		[17] = T.RT_763,
		[18] = T.RT_763,
		[19] = T.RT_763,
		[20] = T.RT_763,
	},
	[210105] = {
		[1] = T.RT_767,
		[2] = T.RT_767,
		[3] = T.RT_767,
		[4] = T.RT_767,
		[5] = T.RT_767,
		[6] = T.RT_767,
		[7] = T.RT_767,
		[8] = T.RT_767,
		[9] = T.RT_767,
		[10] = T.RT_767,
		[11] = T.RT_767,
		[12] = T.RT_767,
		[13] = T.RT_767,
		[14] = T.RT_767,
		[15] = T.RT_767,
		[16] = T.RT_767,
		[17] = T.RT_767,
		[18] = T.RT_767,
		[19] = T.RT_767,
		[20] = T.RT_767,
	},
	[210111] = {
		[1] = T.RT_770,
		[2] = T.RT_770,
		[3] = T.RT_770,
		[4] = T.RT_770,
		[5] = T.RT_770,
		[6] = T.RT_770,
		[7] = T.RT_770,
		[8] = T.RT_770,
		[9] = T.RT_770,
		[10] = T.RT_770,
		[11] = T.RT_770,
		[12] = T.RT_770,
		[13] = T.RT_770,
		[14] = T.RT_770,
		[15] = T.RT_770,
		[16] = T.RT_770,
		[17] = T.RT_770,
		[18] = T.RT_770,
		[19] = T.RT_770,
		[20] = T.RT_770,
	},
	[210112] = {
		[1] = T.RT_773,
		[2] = T.RT_773,
		[3] = T.RT_773,
		[4] = T.RT_773,
		[5] = T.RT_773,
		[6] = T.RT_773,
		[7] = T.RT_773,
		[8] = T.RT_773,
		[9] = T.RT_773,
		[10] = T.RT_773,
		[11] = T.RT_773,
		[12] = T.RT_773,
		[13] = T.RT_773,
		[14] = T.RT_773,
		[15] = T.RT_773,
		[16] = T.RT_773,
		[17] = T.RT_773,
		[18] = T.RT_773,
		[19] = T.RT_773,
		[20] = T.RT_773,
	},
	[210201] = {
		[1] = T.RT_775,
		[2] = T.RT_775,
		[3] = T.RT_775,
		[4] = T.RT_775,
		[5] = T.RT_775,
		[6] = T.RT_775,
		[7] = T.RT_775,
		[8] = T.RT_775,
		[9] = T.RT_775,
		[10] = T.RT_775,
		[11] = T.RT_775,
		[12] = T.RT_775,
		[13] = T.RT_775,
		[14] = T.RT_775,
		[15] = T.RT_775,
		[16] = T.RT_775,
		[17] = T.RT_775,
		[18] = T.RT_775,
		[19] = T.RT_775,
		[20] = T.RT_775,
	},
	[210202] = {
		[1] = T.RT_778,
		[2] = T.RT_778,
		[3] = T.RT_778,
		[4] = T.RT_778,
		[5] = T.RT_778,
		[6] = T.RT_778,
		[7] = T.RT_778,
		[8] = T.RT_778,
		[9] = T.RT_778,
		[10] = T.RT_778,
		[11] = T.RT_778,
		[12] = T.RT_778,
		[13] = T.RT_778,
		[14] = T.RT_778,
		[15] = T.RT_778,
		[16] = T.RT_778,
		[17] = T.RT_778,
		[18] = T.RT_778,
		[19] = T.RT_778,
		[20] = T.RT_778,
	},
	[210203] = {
		[1] = T.RT_781,
		[2] = T.RT_781,
		[3] = T.RT_781,
		[4] = T.RT_781,
		[5] = T.RT_781,
		[6] = T.RT_781,
		[7] = T.RT_781,
		[8] = T.RT_781,
		[9] = T.RT_781,
		[10] = T.RT_781,
		[11] = T.RT_781,
		[12] = T.RT_781,
		[13] = T.RT_781,
		[14] = T.RT_781,
		[15] = T.RT_781,
		[16] = T.RT_781,
		[17] = T.RT_781,
		[18] = T.RT_781,
		[19] = T.RT_781,
		[20] = T.RT_781,
	},
	[210204] = {
		[1] = T.RT_783,
		[2] = T.RT_783,
		[3] = T.RT_783,
		[4] = T.RT_783,
		[5] = T.RT_783,
		[6] = T.RT_783,
		[7] = T.RT_783,
		[8] = T.RT_783,
		[9] = T.RT_783,
		[10] = T.RT_783,
		[11] = T.RT_783,
		[12] = T.RT_783,
		[13] = T.RT_783,
		[14] = T.RT_783,
		[15] = T.RT_783,
		[16] = T.RT_783,
		[17] = T.RT_783,
		[18] = T.RT_783,
		[19] = T.RT_783,
		[20] = T.RT_783,
	},
	[210211] = {
		[1] = T.RT_785,
		[2] = T.RT_785,
		[3] = T.RT_785,
		[4] = T.RT_785,
		[5] = T.RT_785,
		[6] = T.RT_785,
		[7] = T.RT_785,
		[8] = T.RT_785,
		[9] = T.RT_785,
		[10] = T.RT_785,
		[11] = T.RT_785,
		[12] = T.RT_785,
		[13] = T.RT_785,
		[14] = T.RT_785,
		[15] = T.RT_785,
		[16] = T.RT_785,
		[17] = T.RT_785,
		[18] = T.RT_785,
		[19] = T.RT_785,
		[20] = T.RT_785,
	},
	[210212] = {
		[1] = T.RT_787,
		[2] = T.RT_787,
		[3] = T.RT_787,
		[4] = T.RT_787,
		[5] = T.RT_787,
		[6] = T.RT_787,
		[7] = T.RT_787,
		[8] = T.RT_787,
		[9] = T.RT_787,
		[10] = T.RT_787,
		[11] = T.RT_787,
		[12] = T.RT_787,
		[13] = T.RT_787,
		[14] = T.RT_787,
		[15] = T.RT_787,
		[16] = T.RT_787,
		[17] = T.RT_787,
		[18] = T.RT_787,
		[19] = T.RT_787,
		[20] = T.RT_787,
	},
	[210213] = {
		[1] = T.RT_789,
		[2] = T.RT_789,
		[3] = T.RT_789,
		[4] = T.RT_789,
		[5] = T.RT_789,
		[6] = T.RT_789,
		[7] = T.RT_789,
		[8] = T.RT_789,
		[9] = T.RT_789,
		[10] = T.RT_789,
		[11] = T.RT_789,
		[12] = T.RT_789,
		[13] = T.RT_789,
		[14] = T.RT_789,
		[15] = T.RT_789,
		[16] = T.RT_789,
		[17] = T.RT_789,
		[18] = T.RT_789,
		[19] = T.RT_789,
		[20] = T.RT_789,
	},
	[210214] = {
		[1] = T.RT_791,
		[2] = T.RT_791,
		[3] = T.RT_791,
		[4] = T.RT_791,
		[5] = T.RT_791,
		[6] = T.RT_791,
		[7] = T.RT_791,
		[8] = T.RT_791,
		[9] = T.RT_791,
		[10] = T.RT_791,
		[11] = T.RT_791,
		[12] = T.RT_791,
		[13] = T.RT_791,
		[14] = T.RT_791,
		[15] = T.RT_791,
		[16] = T.RT_791,
		[17] = T.RT_791,
		[18] = T.RT_791,
		[19] = T.RT_791,
		[20] = T.RT_791,
	},
	[210215] = {
		[1] = T.RT_793,
		[2] = T.RT_793,
		[3] = T.RT_793,
		[4] = T.RT_793,
		[5] = T.RT_793,
		[6] = T.RT_793,
		[7] = T.RT_793,
		[8] = T.RT_793,
		[9] = T.RT_793,
		[10] = T.RT_793,
		[11] = T.RT_793,
		[12] = T.RT_793,
		[13] = T.RT_793,
		[14] = T.RT_793,
		[15] = T.RT_793,
		[16] = T.RT_793,
		[17] = T.RT_793,
		[18] = T.RT_793,
		[19] = T.RT_793,
		[20] = T.RT_793,
	},
	[210221] = {
		[1] = T.RT_796,
		[2] = T.RT_796,
		[3] = T.RT_796,
		[4] = T.RT_796,
		[5] = T.RT_796,
		[6] = T.RT_796,
		[7] = T.RT_796,
		[8] = T.RT_796,
		[9] = T.RT_796,
		[10] = T.RT_796,
		[11] = T.RT_796,
		[12] = T.RT_796,
		[13] = T.RT_796,
		[14] = T.RT_796,
		[15] = T.RT_796,
		[16] = T.RT_796,
		[17] = T.RT_796,
		[18] = T.RT_796,
		[19] = T.RT_796,
		[20] = T.RT_796,
	},
	[210222] = {
		[1] = T.RT_798,
		[2] = T.RT_798,
		[3] = T.RT_798,
		[4] = T.RT_798,
		[5] = T.RT_798,
		[6] = T.RT_798,
		[7] = T.RT_798,
		[8] = T.RT_798,
		[9] = T.RT_798,
		[10] = T.RT_798,
		[11] = T.RT_798,
		[12] = T.RT_798,
		[13] = T.RT_798,
		[14] = T.RT_798,
		[15] = T.RT_798,
		[16] = T.RT_798,
		[17] = T.RT_798,
		[18] = T.RT_798,
		[19] = T.RT_798,
		[20] = T.RT_798,
	},
	[210231] = {
		[1] = T.RT_800,
		[2] = T.RT_800,
		[3] = T.RT_800,
		[4] = T.RT_800,
		[5] = T.RT_800,
		[6] = T.RT_800,
		[7] = T.RT_800,
		[8] = T.RT_800,
		[9] = T.RT_800,
		[10] = T.RT_800,
		[11] = T.RT_800,
		[12] = T.RT_800,
		[13] = T.RT_800,
		[14] = T.RT_800,
		[15] = T.RT_800,
		[16] = T.RT_800,
		[17] = T.RT_800,
		[18] = T.RT_800,
		[19] = T.RT_800,
		[20] = T.RT_800,
	},
	[210232] = {
		[1] = T.RT_802,
		[2] = T.RT_802,
		[3] = T.RT_802,
		[4] = T.RT_802,
		[5] = T.RT_802,
		[6] = T.RT_802,
		[7] = T.RT_802,
		[8] = T.RT_802,
		[9] = T.RT_802,
		[10] = T.RT_802,
		[11] = T.RT_802,
		[12] = T.RT_802,
		[13] = T.RT_802,
		[14] = T.RT_802,
		[15] = T.RT_802,
		[16] = T.RT_802,
		[17] = T.RT_802,
		[18] = T.RT_802,
		[19] = T.RT_802,
		[20] = T.RT_802,
	},
	[210302] = {
		[1] = T.RT_804,
		[2] = T.RT_804,
		[3] = T.RT_804,
		[4] = T.RT_804,
		[5] = T.RT_804,
		[6] = T.RT_804,
		[7] = T.RT_804,
		[8] = T.RT_804,
		[9] = T.RT_804,
		[10] = T.RT_804,
		[11] = T.RT_804,
		[12] = T.RT_804,
		[13] = T.RT_804,
		[14] = T.RT_804,
		[15] = T.RT_804,
		[16] = T.RT_804,
		[17] = T.RT_804,
		[18] = T.RT_804,
		[19] = T.RT_804,
		[20] = T.RT_804,
	},
	[210303] = {
		[1] = T.RT_806,
		[2] = T.RT_806,
		[3] = T.RT_806,
		[4] = T.RT_806,
		[5] = T.RT_806,
		[6] = T.RT_806,
		[7] = T.RT_806,
		[8] = T.RT_806,
		[9] = T.RT_806,
		[10] = T.RT_806,
		[11] = T.RT_806,
		[12] = T.RT_806,
		[13] = T.RT_806,
		[14] = T.RT_806,
		[15] = T.RT_806,
		[16] = T.RT_806,
		[17] = T.RT_806,
		[18] = T.RT_806,
		[19] = T.RT_806,
		[20] = T.RT_806,
	},
	[210304] = {
		[1] = T.RT_808,
		[2] = T.RT_808,
		[3] = T.RT_808,
		[4] = T.RT_808,
		[5] = T.RT_808,
		[6] = T.RT_808,
		[7] = T.RT_808,
		[8] = T.RT_808,
		[9] = T.RT_808,
		[10] = T.RT_808,
		[11] = T.RT_808,
		[12] = T.RT_808,
		[13] = T.RT_808,
		[14] = T.RT_808,
		[15] = T.RT_808,
		[16] = T.RT_808,
		[17] = T.RT_808,
		[18] = T.RT_808,
		[19] = T.RT_808,
		[20] = T.RT_808,
	},
	[210311] = {
		[1] = T.RT_810,
		[2] = T.RT_810,
		[3] = T.RT_810,
		[4] = T.RT_810,
		[5] = T.RT_810,
		[6] = T.RT_810,
		[7] = T.RT_810,
		[8] = T.RT_810,
		[9] = T.RT_810,
		[10] = T.RT_810,
		[11] = T.RT_810,
		[12] = T.RT_810,
		[13] = T.RT_810,
		[14] = T.RT_810,
		[15] = T.RT_810,
		[16] = T.RT_810,
		[17] = T.RT_810,
		[18] = T.RT_810,
		[19] = T.RT_810,
		[20] = T.RT_810,
	},
	[210312] = {
		[1] = T.RT_812,
		[2] = T.RT_812,
		[3] = T.RT_812,
		[4] = T.RT_812,
		[5] = T.RT_812,
		[6] = T.RT_812,
		[7] = T.RT_812,
		[8] = T.RT_812,
		[9] = T.RT_812,
		[10] = T.RT_812,
		[11] = T.RT_812,
		[12] = T.RT_812,
		[13] = T.RT_812,
		[14] = T.RT_812,
		[15] = T.RT_812,
		[16] = T.RT_812,
		[17] = T.RT_812,
		[18] = T.RT_812,
		[19] = T.RT_812,
		[20] = T.RT_812,
	},
	[210313] = {
		[1] = T.RT_814,
		[2] = T.RT_814,
		[3] = T.RT_814,
		[4] = T.RT_814,
		[5] = T.RT_814,
		[6] = T.RT_814,
		[7] = T.RT_814,
		[8] = T.RT_814,
		[9] = T.RT_814,
		[10] = T.RT_814,
		[11] = T.RT_814,
		[12] = T.RT_814,
		[13] = T.RT_814,
		[14] = T.RT_814,
		[15] = T.RT_814,
		[16] = T.RT_814,
		[17] = T.RT_814,
		[18] = T.RT_814,
		[19] = T.RT_814,
		[20] = T.RT_814,
	},
	[210314] = {
		[1] = T.RT_816,
		[2] = T.RT_816,
		[3] = T.RT_816,
		[4] = T.RT_816,
		[5] = T.RT_816,
		[6] = T.RT_816,
		[7] = T.RT_816,
		[8] = T.RT_816,
		[9] = T.RT_816,
		[10] = T.RT_816,
		[11] = T.RT_816,
		[12] = T.RT_816,
		[13] = T.RT_816,
		[14] = T.RT_816,
		[15] = T.RT_816,
		[16] = T.RT_816,
		[17] = T.RT_816,
		[18] = T.RT_816,
		[19] = T.RT_816,
		[20] = T.RT_816,
	},
	[210315] = {
		[1] = T.RT_818,
		[2] = T.RT_818,
		[3] = T.RT_818,
		[4] = T.RT_818,
		[5] = T.RT_818,
		[6] = T.RT_818,
		[7] = T.RT_818,
		[8] = T.RT_818,
		[9] = T.RT_818,
		[10] = T.RT_818,
		[11] = T.RT_818,
		[12] = T.RT_818,
		[13] = T.RT_818,
		[14] = T.RT_818,
		[15] = T.RT_818,
		[16] = T.RT_818,
		[17] = T.RT_818,
		[18] = T.RT_818,
		[19] = T.RT_818,
		[20] = T.RT_818,
	},
	[210316] = {
		[1] = T.RT_820,
		[2] = T.RT_820,
		[3] = T.RT_820,
		[4] = T.RT_820,
		[5] = T.RT_820,
		[6] = T.RT_820,
		[7] = T.RT_820,
		[8] = T.RT_820,
		[9] = T.RT_820,
		[10] = T.RT_820,
		[11] = T.RT_820,
		[12] = T.RT_820,
		[13] = T.RT_820,
		[14] = T.RT_820,
		[15] = T.RT_820,
		[16] = T.RT_820,
		[17] = T.RT_820,
		[18] = T.RT_820,
		[19] = T.RT_820,
		[20] = T.RT_820,
	},
	[210321] = {
		[1] = T.RT_822,
		[2] = T.RT_822,
		[3] = T.RT_822,
		[4] = T.RT_822,
		[5] = T.RT_822,
		[6] = T.RT_822,
		[7] = T.RT_822,
		[8] = T.RT_822,
		[9] = T.RT_822,
		[10] = T.RT_822,
		[11] = T.RT_822,
		[12] = T.RT_822,
		[13] = T.RT_822,
		[14] = T.RT_822,
		[15] = T.RT_822,
		[16] = T.RT_822,
		[17] = T.RT_822,
		[18] = T.RT_822,
		[19] = T.RT_822,
		[20] = T.RT_822,
	},
	[210322] = {
		[1] = T.RT_824,
		[2] = T.RT_824,
		[3] = T.RT_824,
		[4] = T.RT_824,
		[5] = T.RT_824,
		[6] = T.RT_824,
		[7] = T.RT_824,
		[8] = T.RT_824,
		[9] = T.RT_824,
		[10] = T.RT_824,
		[11] = T.RT_824,
		[12] = T.RT_824,
		[13] = T.RT_824,
		[14] = T.RT_824,
		[15] = T.RT_824,
		[16] = T.RT_824,
		[17] = T.RT_824,
		[18] = T.RT_824,
		[19] = T.RT_824,
		[20] = T.RT_824,
	},
	[210323] = {
		[1] = T.RT_826,
		[2] = T.RT_826,
		[3] = T.RT_826,
		[4] = T.RT_826,
		[5] = T.RT_826,
		[6] = T.RT_826,
		[7] = T.RT_826,
		[8] = T.RT_826,
		[9] = T.RT_826,
		[10] = T.RT_826,
		[11] = T.RT_826,
		[12] = T.RT_826,
		[13] = T.RT_826,
		[14] = T.RT_826,
		[15] = T.RT_826,
		[16] = T.RT_826,
		[17] = T.RT_826,
		[18] = T.RT_826,
		[19] = T.RT_826,
		[20] = T.RT_826,
	},
	[210324] = {
		[1] = T.RT_828,
		[2] = T.RT_828,
		[3] = T.RT_828,
		[4] = T.RT_828,
		[5] = T.RT_828,
		[6] = T.RT_828,
		[7] = T.RT_828,
		[8] = T.RT_828,
		[9] = T.RT_828,
		[10] = T.RT_828,
		[11] = T.RT_828,
		[12] = T.RT_828,
		[13] = T.RT_828,
		[14] = T.RT_828,
		[15] = T.RT_828,
		[16] = T.RT_828,
		[17] = T.RT_828,
		[18] = T.RT_828,
		[19] = T.RT_828,
		[20] = T.RT_828,
	},
	[210325] = {
		[1] = T.RT_830,
		[2] = T.RT_830,
		[3] = T.RT_830,
		[4] = T.RT_830,
		[5] = T.RT_830,
		[6] = T.RT_830,
		[7] = T.RT_830,
		[8] = T.RT_830,
		[9] = T.RT_830,
		[10] = T.RT_830,
		[11] = T.RT_830,
		[12] = T.RT_830,
		[13] = T.RT_830,
		[14] = T.RT_830,
		[15] = T.RT_830,
		[16] = T.RT_830,
		[17] = T.RT_830,
		[18] = T.RT_830,
		[19] = T.RT_830,
		[20] = T.RT_830,
	},
	[210326] = {
		[1] = T.RT_832,
		[2] = T.RT_832,
		[3] = T.RT_832,
		[4] = T.RT_832,
		[5] = T.RT_832,
		[6] = T.RT_832,
		[7] = T.RT_832,
		[8] = T.RT_832,
		[9] = T.RT_832,
		[10] = T.RT_832,
		[11] = T.RT_832,
		[12] = T.RT_832,
		[13] = T.RT_832,
		[14] = T.RT_832,
		[15] = T.RT_832,
		[16] = T.RT_832,
		[17] = T.RT_832,
		[18] = T.RT_832,
		[19] = T.RT_832,
		[20] = T.RT_832,
	},
	[210331] = {
		[1] = T.RT_834,
		[2] = T.RT_834,
		[3] = T.RT_834,
		[4] = T.RT_834,
		[5] = T.RT_834,
		[6] = T.RT_834,
		[7] = T.RT_834,
		[8] = T.RT_834,
		[9] = T.RT_834,
		[10] = T.RT_834,
		[11] = T.RT_834,
		[12] = T.RT_834,
		[13] = T.RT_834,
		[14] = T.RT_834,
		[15] = T.RT_834,
		[16] = T.RT_834,
		[17] = T.RT_834,
		[18] = T.RT_834,
		[19] = T.RT_834,
		[20] = T.RT_834,
	},
	[230101] = {
		[1] = T.RT_839,
		[2] = T.RT_839,
		[3] = T.RT_839,
		[4] = T.RT_839,
		[5] = T.RT_839,
		[6] = T.RT_839,
		[7] = T.RT_839,
		[8] = T.RT_839,
		[9] = T.RT_839,
		[10] = T.RT_839,
		[11] = T.RT_839,
		[12] = T.RT_839,
		[13] = T.RT_839,
		[14] = T.RT_839,
		[15] = T.RT_839,
		[16] = T.RT_839,
		[17] = T.RT_839,
		[18] = T.RT_839,
		[19] = T.RT_839,
		[20] = T.RT_839,
	},
	[230102] = {
		[1] = T.RT_848,
		[2] = T.RT_848,
		[3] = T.RT_848,
		[4] = T.RT_848,
		[5] = T.RT_848,
		[6] = T.RT_848,
		[7] = T.RT_848,
		[8] = T.RT_848,
		[9] = T.RT_848,
		[10] = T.RT_848,
		[11] = T.RT_848,
		[12] = T.RT_848,
		[13] = T.RT_848,
		[14] = T.RT_848,
		[15] = T.RT_848,
		[16] = T.RT_848,
		[17] = T.RT_848,
		[18] = T.RT_848,
		[19] = T.RT_848,
		[20] = T.RT_848,
	},
	[230103] = {
		[1] = T.RT_854,
		[2] = T.RT_854,
		[3] = T.RT_854,
		[4] = T.RT_854,
		[5] = T.RT_854,
		[6] = T.RT_854,
		[7] = T.RT_854,
		[8] = T.RT_854,
		[9] = T.RT_854,
		[10] = T.RT_854,
		[11] = T.RT_854,
		[12] = T.RT_854,
		[13] = T.RT_854,
		[14] = T.RT_854,
		[15] = T.RT_854,
		[16] = T.RT_854,
		[17] = T.RT_854,
		[18] = T.RT_854,
		[19] = T.RT_854,
		[20] = T.RT_854,
	},
	[230104] = {
		[1] = T.RT_859,
		[2] = T.RT_859,
		[3] = T.RT_859,
		[4] = T.RT_859,
		[5] = T.RT_859,
		[6] = T.RT_859,
		[7] = T.RT_859,
		[8] = T.RT_859,
		[9] = T.RT_859,
		[10] = T.RT_859,
		[11] = T.RT_859,
		[12] = T.RT_859,
		[13] = T.RT_859,
		[14] = T.RT_859,
		[15] = T.RT_859,
		[16] = T.RT_859,
		[17] = T.RT_859,
		[18] = T.RT_859,
		[19] = T.RT_859,
		[20] = T.RT_859,
	},
	[230131] = {
		[1] = T.RT_861,
		[2] = T.RT_861,
		[3] = T.RT_861,
		[4] = T.RT_861,
		[5] = T.RT_861,
		[6] = T.RT_861,
		[7] = T.RT_861,
		[8] = T.RT_861,
		[9] = T.RT_861,
		[10] = T.RT_861,
		[11] = T.RT_861,
		[12] = T.RT_861,
		[13] = T.RT_861,
		[14] = T.RT_861,
		[15] = T.RT_861,
		[16] = T.RT_861,
		[17] = T.RT_861,
		[18] = T.RT_861,
		[19] = T.RT_861,
		[20] = T.RT_861,
	},
	[230132] = {
		[1] = T.RT_864,
		[2] = T.RT_864,
		[3] = T.RT_864,
		[4] = T.RT_864,
		[5] = T.RT_864,
		[6] = T.RT_864,
		[7] = T.RT_864,
		[8] = T.RT_864,
		[9] = T.RT_864,
		[10] = T.RT_864,
		[11] = T.RT_864,
		[12] = T.RT_864,
		[13] = T.RT_864,
		[14] = T.RT_864,
		[15] = T.RT_864,
		[16] = T.RT_864,
		[17] = T.RT_864,
		[18] = T.RT_864,
		[19] = T.RT_864,
		[20] = T.RT_864,
	},
	[240101] = {
		[1] = T.RT_873,
		[2] = T.RT_873,
		[3] = T.RT_873,
		[4] = T.RT_873,
		[5] = T.RT_873,
		[6] = T.RT_873,
		[7] = T.RT_873,
		[8] = T.RT_873,
		[9] = T.RT_873,
		[10] = T.RT_873,
		[11] = T.RT_873,
		[12] = T.RT_873,
		[13] = T.RT_873,
		[14] = T.RT_873,
		[15] = T.RT_873,
		[16] = T.RT_873,
		[17] = T.RT_873,
		[18] = T.RT_873,
		[19] = T.RT_873,
		[20] = T.RT_873,
	},
	[240102] = {
		[1] = T.RT_882,
		[2] = T.RT_882,
		[3] = T.RT_882,
		[4] = T.RT_882,
		[5] = T.RT_882,
		[6] = T.RT_882,
		[7] = T.RT_882,
		[8] = T.RT_882,
		[9] = T.RT_882,
		[10] = T.RT_882,
		[11] = T.RT_882,
		[12] = T.RT_882,
		[13] = T.RT_882,
		[14] = T.RT_882,
		[15] = T.RT_882,
		[16] = T.RT_882,
		[17] = T.RT_882,
		[18] = T.RT_882,
		[19] = T.RT_882,
		[20] = T.RT_882,
	},
	[240103] = {
		[1] = T.RT_887,
		[2] = T.RT_887,
		[3] = T.RT_887,
		[4] = T.RT_887,
		[5] = T.RT_887,
		[6] = T.RT_887,
		[7] = T.RT_887,
		[8] = T.RT_887,
		[9] = T.RT_887,
		[10] = T.RT_887,
		[11] = T.RT_887,
		[12] = T.RT_887,
		[13] = T.RT_887,
		[14] = T.RT_887,
		[15] = T.RT_887,
		[16] = T.RT_887,
		[17] = T.RT_887,
		[18] = T.RT_887,
		[19] = T.RT_887,
		[20] = T.RT_887,
	},
	[240104] = {
		[1] = T.RT_892,
		[2] = T.RT_892,
		[3] = T.RT_892,
		[4] = T.RT_892,
		[5] = T.RT_892,
		[6] = T.RT_892,
		[7] = T.RT_892,
		[8] = T.RT_892,
		[9] = T.RT_892,
		[10] = T.RT_892,
		[11] = T.RT_892,
		[12] = T.RT_892,
		[13] = T.RT_892,
		[14] = T.RT_892,
		[15] = T.RT_892,
		[16] = T.RT_892,
		[17] = T.RT_892,
		[18] = T.RT_892,
		[19] = T.RT_892,
		[20] = T.RT_892,
	},
	[240111] = {
		[1] = T.RT_895,
		[2] = T.RT_895,
		[3] = T.RT_895,
		[4] = T.RT_895,
		[5] = T.RT_895,
		[6] = T.RT_895,
		[7] = T.RT_895,
		[8] = T.RT_895,
		[9] = T.RT_895,
		[10] = T.RT_895,
		[11] = T.RT_895,
		[12] = T.RT_895,
		[13] = T.RT_895,
		[14] = T.RT_895,
		[15] = T.RT_895,
		[16] = T.RT_895,
		[17] = T.RT_895,
		[18] = T.RT_895,
		[19] = T.RT_895,
		[20] = T.RT_895,
	},
	[240131] = {
		[1] = T.RT_898,
		[2] = T.RT_898,
		[3] = T.RT_898,
		[4] = T.RT_898,
		[5] = T.RT_898,
		[6] = T.RT_898,
		[7] = T.RT_898,
		[8] = T.RT_898,
		[9] = T.RT_898,
		[10] = T.RT_898,
		[11] = T.RT_898,
		[12] = T.RT_898,
		[13] = T.RT_898,
		[14] = T.RT_898,
		[15] = T.RT_898,
		[16] = T.RT_898,
		[17] = T.RT_898,
		[18] = T.RT_898,
		[19] = T.RT_898,
		[20] = T.RT_898,
	},
	[240191] = {
		[1] = T.RT_902,
		[2] = T.RT_902,
		[3] = T.RT_902,
		[4] = T.RT_902,
		[5] = T.RT_902,
		[6] = T.RT_902,
		[7] = T.RT_902,
		[8] = T.RT_902,
		[9] = T.RT_902,
		[10] = T.RT_902,
		[11] = T.RT_902,
		[12] = T.RT_902,
		[13] = T.RT_902,
		[14] = T.RT_902,
		[15] = T.RT_902,
		[16] = T.RT_902,
		[17] = T.RT_902,
		[18] = T.RT_902,
		[19] = T.RT_902,
		[20] = T.RT_902,
	},
	[310001] = {
		[1] = T.RT_907,
		[2] = T.RT_907,
		[3] = T.RT_907,
		[4] = T.RT_907,
		[5] = T.RT_907,
		[6] = T.RT_907,
		[7] = T.RT_907,
		[8] = T.RT_907,
		[9] = T.RT_907,
		[10] = T.RT_907,
		[11] = T.RT_907,
		[12] = T.RT_907,
		[13] = T.RT_907,
		[14] = T.RT_907,
		[15] = T.RT_907,
		[16] = T.RT_907,
		[17] = T.RT_907,
		[18] = T.RT_907,
		[19] = T.RT_907,
		[20] = T.RT_907,
	},
	[310003] = {
		[1] = T.RT_911,
		[2] = T.RT_911,
		[3] = T.RT_911,
		[4] = T.RT_911,
		[5] = T.RT_911,
		[6] = T.RT_911,
		[7] = T.RT_911,
		[8] = T.RT_911,
		[9] = T.RT_911,
		[10] = T.RT_911,
		[11] = T.RT_911,
		[12] = T.RT_911,
		[13] = T.RT_911,
		[14] = T.RT_911,
		[15] = T.RT_911,
		[16] = T.RT_911,
		[17] = T.RT_911,
		[18] = T.RT_911,
		[19] = T.RT_911,
		[20] = T.RT_911,
	},
	[310101] = {
		[1] = T.RT_918,
		[2] = T.RT_918,
		[3] = T.RT_918,
		[4] = T.RT_918,
		[5] = T.RT_918,
		[6] = T.RT_918,
		[7] = T.RT_918,
		[8] = T.RT_918,
		[9] = T.RT_918,
		[10] = T.RT_918,
		[11] = T.RT_918,
		[12] = T.RT_918,
		[13] = T.RT_918,
		[14] = T.RT_918,
		[15] = T.RT_918,
		[16] = T.RT_918,
		[17] = T.RT_918,
		[18] = T.RT_918,
		[19] = T.RT_918,
		[20] = T.RT_918,
	},
	[310102] = {
		[1] = T.RT_926,
		[2] = T.RT_926,
		[3] = T.RT_926,
		[4] = T.RT_926,
		[5] = T.RT_926,
		[6] = T.RT_926,
		[7] = T.RT_926,
		[8] = T.RT_926,
		[9] = T.RT_926,
		[10] = T.RT_926,
		[11] = T.RT_926,
		[12] = T.RT_926,
		[13] = T.RT_926,
		[14] = T.RT_926,
		[15] = T.RT_926,
		[16] = T.RT_926,
		[17] = T.RT_926,
		[18] = T.RT_926,
		[19] = T.RT_926,
		[20] = T.RT_926,
	},
	[310103] = {
		[1] = T.RT_931,
		[2] = T.RT_931,
		[3] = T.RT_931,
		[4] = T.RT_931,
		[5] = T.RT_931,
		[6] = T.RT_931,
		[7] = T.RT_931,
		[8] = T.RT_931,
		[9] = T.RT_931,
		[10] = T.RT_931,
		[11] = T.RT_931,
		[12] = T.RT_931,
		[13] = T.RT_931,
		[14] = T.RT_931,
		[15] = T.RT_931,
		[16] = T.RT_931,
		[17] = T.RT_931,
		[18] = T.RT_931,
		[19] = T.RT_931,
		[20] = T.RT_931,
	},
	[310104] = {
		[1] = T.RT_934,
		[2] = T.RT_934,
		[3] = T.RT_934,
		[4] = T.RT_934,
		[5] = T.RT_934,
		[6] = T.RT_934,
		[7] = T.RT_934,
		[8] = T.RT_934,
		[9] = T.RT_934,
		[10] = T.RT_934,
		[11] = T.RT_934,
		[12] = T.RT_934,
		[13] = T.RT_934,
		[14] = T.RT_934,
		[15] = T.RT_934,
		[16] = T.RT_934,
		[17] = T.RT_934,
		[18] = T.RT_934,
		[19] = T.RT_934,
		[20] = T.RT_934,
	},
	[310111] = {
		[1] = T.RT_936,
		[2] = T.RT_936,
		[3] = T.RT_936,
		[4] = T.RT_936,
		[5] = T.RT_936,
		[6] = T.RT_936,
		[7] = T.RT_936,
		[8] = T.RT_936,
		[9] = T.RT_936,
		[10] = T.RT_936,
		[11] = T.RT_936,
		[12] = T.RT_936,
		[13] = T.RT_936,
		[14] = T.RT_936,
		[15] = T.RT_936,
		[16] = T.RT_936,
		[17] = T.RT_936,
		[18] = T.RT_936,
		[19] = T.RT_936,
		[20] = T.RT_936,
	},
	[310121] = {
		[1] = T.RT_938,
		[2] = T.RT_938,
		[3] = T.RT_938,
		[4] = T.RT_938,
		[5] = T.RT_938,
		[6] = T.RT_938,
		[7] = T.RT_938,
		[8] = T.RT_938,
		[9] = T.RT_938,
		[10] = T.RT_938,
		[11] = T.RT_938,
		[12] = T.RT_938,
		[13] = T.RT_938,
		[14] = T.RT_938,
		[15] = T.RT_938,
		[16] = T.RT_938,
		[17] = T.RT_938,
		[18] = T.RT_938,
		[19] = T.RT_938,
		[20] = T.RT_938,
	},
	[310122] = {
		[1] = T.RT_940,
		[2] = T.RT_940,
		[3] = T.RT_940,
		[4] = T.RT_940,
		[5] = T.RT_940,
		[6] = T.RT_940,
		[7] = T.RT_940,
		[8] = T.RT_940,
		[9] = T.RT_940,
		[10] = T.RT_940,
		[11] = T.RT_940,
		[12] = T.RT_940,
		[13] = T.RT_940,
		[14] = T.RT_940,
		[15] = T.RT_940,
		[16] = T.RT_940,
		[17] = T.RT_940,
		[18] = T.RT_940,
		[19] = T.RT_940,
		[20] = T.RT_940,
	},
	[310201] = {
		[1] = T.RT_948,
		[2] = T.RT_948,
		[3] = T.RT_948,
		[4] = T.RT_948,
		[5] = T.RT_948,
		[6] = T.RT_948,
		[7] = T.RT_948,
		[8] = T.RT_948,
		[9] = T.RT_948,
		[10] = T.RT_948,
		[11] = T.RT_948,
		[12] = T.RT_948,
		[13] = T.RT_948,
		[14] = T.RT_948,
		[15] = T.RT_948,
		[16] = T.RT_948,
		[17] = T.RT_948,
		[18] = T.RT_948,
		[19] = T.RT_948,
		[20] = T.RT_948,
	},
	[310202] = {
		[1] = T.RT_954,
		[2] = T.RT_954,
		[3] = T.RT_954,
		[4] = T.RT_954,
		[5] = T.RT_954,
		[6] = T.RT_954,
		[7] = T.RT_954,
		[8] = T.RT_954,
		[9] = T.RT_954,
		[10] = T.RT_954,
		[11] = T.RT_954,
		[12] = T.RT_954,
		[13] = T.RT_954,
		[14] = T.RT_954,
		[15] = T.RT_954,
		[16] = T.RT_954,
		[17] = T.RT_954,
		[18] = T.RT_954,
		[19] = T.RT_954,
		[20] = T.RT_954,
	},
	[310203] = {
		[1] = T.RT_960,
		[2] = T.RT_960,
		[3] = T.RT_960,
		[4] = T.RT_960,
		[5] = T.RT_960,
		[6] = T.RT_960,
		[7] = T.RT_960,
		[8] = T.RT_960,
		[9] = T.RT_960,
		[10] = T.RT_960,
		[11] = T.RT_960,
		[12] = T.RT_960,
		[13] = T.RT_960,
		[14] = T.RT_960,
		[15] = T.RT_960,
		[16] = T.RT_960,
		[17] = T.RT_960,
		[18] = T.RT_960,
		[19] = T.RT_960,
		[20] = T.RT_960,
	},
	[310204] = {
		[1] = T.RT_963,
		[2] = T.RT_963,
		[3] = T.RT_963,
		[4] = T.RT_963,
		[5] = T.RT_963,
		[6] = T.RT_963,
		[7] = T.RT_963,
		[8] = T.RT_963,
		[9] = T.RT_963,
		[10] = T.RT_963,
		[11] = T.RT_963,
		[12] = T.RT_963,
		[13] = T.RT_963,
		[14] = T.RT_963,
		[15] = T.RT_963,
		[16] = T.RT_963,
		[17] = T.RT_963,
		[18] = T.RT_963,
		[19] = T.RT_963,
		[20] = T.RT_963,
	},
	[310211] = {
		[1] = T.RT_966,
		[2] = T.RT_966,
		[3] = T.RT_966,
		[4] = T.RT_966,
		[5] = T.RT_966,
		[6] = T.RT_966,
		[7] = T.RT_966,
		[8] = T.RT_966,
		[9] = T.RT_966,
		[10] = T.RT_966,
		[11] = T.RT_966,
		[12] = T.RT_966,
		[13] = T.RT_966,
		[14] = T.RT_966,
		[15] = T.RT_966,
		[16] = T.RT_966,
		[17] = T.RT_966,
		[18] = T.RT_966,
		[19] = T.RT_966,
		[20] = T.RT_966,
	},
	[310301] = {
		[1] = T.RT_973,
		[2] = T.RT_973,
		[3] = T.RT_973,
		[4] = T.RT_973,
		[5] = T.RT_973,
		[6] = T.RT_973,
		[7] = T.RT_973,
		[8] = T.RT_973,
		[9] = T.RT_973,
		[10] = T.RT_973,
		[11] = T.RT_973,
		[12] = T.RT_973,
		[13] = T.RT_973,
		[14] = T.RT_973,
		[15] = T.RT_973,
		[16] = T.RT_973,
		[17] = T.RT_973,
		[18] = T.RT_973,
		[19] = T.RT_973,
		[20] = T.RT_973,
	},
	[310302] = {
		[1] = T.RT_983,
		[2] = T.RT_983,
		[3] = T.RT_983,
		[4] = T.RT_983,
		[5] = T.RT_983,
		[6] = T.RT_983,
		[7] = T.RT_983,
		[8] = T.RT_983,
		[9] = T.RT_983,
		[10] = T.RT_983,
		[11] = T.RT_983,
		[12] = T.RT_983,
		[13] = T.RT_983,
		[14] = T.RT_983,
		[15] = T.RT_983,
		[16] = T.RT_983,
		[17] = T.RT_983,
		[18] = T.RT_983,
		[19] = T.RT_983,
		[20] = T.RT_983,
	},
	[310303] = {
		[1] = T.RT_988,
		[2] = T.RT_988,
		[3] = T.RT_988,
		[4] = T.RT_988,
		[5] = T.RT_988,
		[6] = T.RT_988,
		[7] = T.RT_988,
		[8] = T.RT_988,
		[9] = T.RT_988,
		[10] = T.RT_988,
		[11] = T.RT_988,
		[12] = T.RT_988,
		[13] = T.RT_988,
		[14] = T.RT_988,
		[15] = T.RT_988,
		[16] = T.RT_988,
		[17] = T.RT_988,
		[18] = T.RT_988,
		[19] = T.RT_988,
		[20] = T.RT_988,
	},
	[310304] = {
		[1] = T.RT_993,
		[2] = T.RT_993,
		[3] = T.RT_993,
		[4] = T.RT_993,
		[5] = T.RT_993,
		[6] = T.RT_993,
		[7] = T.RT_993,
		[8] = T.RT_993,
		[9] = T.RT_993,
		[10] = T.RT_993,
		[11] = T.RT_993,
		[12] = T.RT_993,
		[13] = T.RT_993,
		[14] = T.RT_993,
		[15] = T.RT_993,
		[16] = T.RT_993,
		[17] = T.RT_993,
		[18] = T.RT_993,
		[19] = T.RT_993,
		[20] = T.RT_993,
	},
	[310311] = {
		[1] = T.RT_995,
		[2] = T.RT_995,
		[3] = T.RT_995,
		[4] = T.RT_995,
		[5] = T.RT_995,
		[6] = T.RT_995,
		[7] = T.RT_995,
		[8] = T.RT_995,
		[9] = T.RT_995,
		[10] = T.RT_995,
		[11] = T.RT_995,
		[12] = T.RT_995,
		[13] = T.RT_995,
		[14] = T.RT_995,
		[15] = T.RT_995,
		[16] = T.RT_995,
		[17] = T.RT_995,
		[18] = T.RT_995,
		[19] = T.RT_995,
		[20] = T.RT_995,
	},
	[310321] = {
		[1] = T.RT_998,
		[2] = T.RT_998,
		[3] = T.RT_998,
		[4] = T.RT_998,
		[5] = T.RT_998,
		[6] = T.RT_998,
		[7] = T.RT_998,
		[8] = T.RT_998,
		[9] = T.RT_998,
		[10] = T.RT_998,
		[11] = T.RT_998,
		[12] = T.RT_998,
		[13] = T.RT_998,
		[14] = T.RT_998,
		[15] = T.RT_998,
		[16] = T.RT_998,
		[17] = T.RT_998,
		[18] = T.RT_998,
		[19] = T.RT_998,
		[20] = T.RT_998,
	},
	[320101] = {
		[1] = T.RT_1011,
		[2] = T.RT_1011,
		[3] = T.RT_1011,
		[4] = T.RT_1011,
		[5] = T.RT_1011,
		[6] = T.RT_1011,
		[7] = T.RT_1011,
		[8] = T.RT_1011,
		[9] = T.RT_1011,
		[10] = T.RT_1011,
		[11] = T.RT_1011,
		[12] = T.RT_1011,
		[13] = T.RT_1011,
		[14] = T.RT_1011,
		[15] = T.RT_1011,
		[16] = T.RT_1011,
		[17] = T.RT_1011,
		[18] = T.RT_1011,
		[19] = T.RT_1011,
		[20] = T.RT_1011,
	},
	[320102] = {
		[1] = T.RT_1015,
		[2] = T.RT_1015,
		[3] = T.RT_1015,
		[4] = T.RT_1015,
		[5] = T.RT_1015,
		[6] = T.RT_1015,
		[7] = T.RT_1015,
		[8] = T.RT_1015,
		[9] = T.RT_1015,
		[10] = T.RT_1015,
		[11] = T.RT_1015,
		[12] = T.RT_1015,
		[13] = T.RT_1015,
		[14] = T.RT_1015,
		[15] = T.RT_1015,
		[16] = T.RT_1015,
		[17] = T.RT_1015,
		[18] = T.RT_1015,
		[19] = T.RT_1015,
		[20] = T.RT_1015,
	},
	[320103] = {
		[1] = T.RT_1020,
		[2] = T.RT_1020,
		[3] = T.RT_1020,
		[4] = T.RT_1020,
		[5] = T.RT_1020,
		[6] = T.RT_1020,
		[7] = T.RT_1020,
		[8] = T.RT_1020,
		[9] = T.RT_1020,
		[10] = T.RT_1020,
		[11] = T.RT_1020,
		[12] = T.RT_1020,
		[13] = T.RT_1020,
		[14] = T.RT_1020,
		[15] = T.RT_1020,
		[16] = T.RT_1020,
		[17] = T.RT_1020,
		[18] = T.RT_1020,
		[19] = T.RT_1020,
		[20] = T.RT_1020,
	},
	[320104] = {
		[1] = T.RT_1025,
		[2] = T.RT_1025,
		[3] = T.RT_1025,
		[4] = T.RT_1025,
		[5] = T.RT_1025,
		[6] = T.RT_1025,
		[7] = T.RT_1025,
		[8] = T.RT_1025,
		[9] = T.RT_1025,
		[10] = T.RT_1025,
		[11] = T.RT_1025,
		[12] = T.RT_1025,
		[13] = T.RT_1025,
		[14] = T.RT_1025,
		[15] = T.RT_1025,
		[16] = T.RT_1025,
		[17] = T.RT_1025,
		[18] = T.RT_1025,
		[19] = T.RT_1025,
		[20] = T.RT_1025,
	},
	[320105] = {
		[1] = T.RT_1029,
		[2] = T.RT_1029,
		[3] = T.RT_1029,
		[4] = T.RT_1029,
		[5] = T.RT_1029,
		[6] = T.RT_1029,
		[7] = T.RT_1029,
		[8] = T.RT_1029,
		[9] = T.RT_1029,
		[10] = T.RT_1029,
		[11] = T.RT_1029,
		[12] = T.RT_1029,
		[13] = T.RT_1029,
		[14] = T.RT_1029,
		[15] = T.RT_1029,
		[16] = T.RT_1029,
		[17] = T.RT_1029,
		[18] = T.RT_1029,
		[19] = T.RT_1029,
		[20] = T.RT_1029,
	},
	[320201] = {
		[1] = T.RT_1035,
		[2] = T.RT_1035,
		[3] = T.RT_1035,
		[4] = T.RT_1035,
		[5] = T.RT_1035,
		[6] = T.RT_1035,
		[7] = T.RT_1035,
		[8] = T.RT_1035,
		[9] = T.RT_1035,
		[10] = T.RT_1035,
		[11] = T.RT_1035,
		[12] = T.RT_1035,
		[13] = T.RT_1035,
		[14] = T.RT_1035,
		[15] = T.RT_1035,
		[16] = T.RT_1035,
		[17] = T.RT_1035,
		[18] = T.RT_1035,
		[19] = T.RT_1035,
		[20] = T.RT_1035,
	},
	[320202] = {
		[1] = T.RT_1040,
		[2] = T.RT_1040,
		[3] = T.RT_1040,
		[4] = T.RT_1040,
		[5] = T.RT_1040,
		[6] = T.RT_1040,
		[7] = T.RT_1040,
		[8] = T.RT_1040,
		[9] = T.RT_1040,
		[10] = T.RT_1040,
		[11] = T.RT_1040,
		[12] = T.RT_1040,
		[13] = T.RT_1040,
		[14] = T.RT_1040,
		[15] = T.RT_1040,
		[16] = T.RT_1040,
		[17] = T.RT_1040,
		[18] = T.RT_1040,
		[19] = T.RT_1040,
		[20] = T.RT_1040,
	},
	[320203] = {
		[1] = T.RT_1047,
		[2] = T.RT_1047,
		[3] = T.RT_1047,
		[4] = T.RT_1047,
		[5] = T.RT_1047,
		[6] = T.RT_1047,
		[7] = T.RT_1047,
		[8] = T.RT_1047,
		[9] = T.RT_1047,
		[10] = T.RT_1047,
		[11] = T.RT_1047,
		[12] = T.RT_1047,
		[13] = T.RT_1047,
		[14] = T.RT_1047,
		[15] = T.RT_1047,
		[16] = T.RT_1047,
		[17] = T.RT_1047,
		[18] = T.RT_1047,
		[19] = T.RT_1047,
		[20] = T.RT_1047,
	},
	[320204] = {
		[1] = T.RT_1052,
		[2] = T.RT_1052,
		[3] = T.RT_1052,
		[4] = T.RT_1052,
		[5] = T.RT_1052,
		[6] = T.RT_1052,
		[7] = T.RT_1052,
		[8] = T.RT_1052,
		[9] = T.RT_1052,
		[10] = T.RT_1052,
		[11] = T.RT_1052,
		[12] = T.RT_1052,
		[13] = T.RT_1052,
		[14] = T.RT_1052,
		[15] = T.RT_1052,
		[16] = T.RT_1052,
		[17] = T.RT_1052,
		[18] = T.RT_1052,
		[19] = T.RT_1052,
		[20] = T.RT_1052,
	},
	[320211] = {
		[1] = T.RT_1054,
		[2] = T.RT_1054,
		[3] = T.RT_1054,
		[4] = T.RT_1054,
		[5] = T.RT_1054,
		[6] = T.RT_1054,
		[7] = T.RT_1054,
		[8] = T.RT_1054,
		[9] = T.RT_1054,
		[10] = T.RT_1054,
		[11] = T.RT_1054,
		[12] = T.RT_1054,
		[13] = T.RT_1054,
		[14] = T.RT_1054,
		[15] = T.RT_1054,
		[16] = T.RT_1054,
		[17] = T.RT_1054,
		[18] = T.RT_1054,
		[19] = T.RT_1054,
		[20] = T.RT_1054,
	},
	[320291] = {
		[1] = T.RT_1059,
		[2] = T.RT_1059,
		[3] = T.RT_1059,
		[4] = T.RT_1059,
		[5] = T.RT_1059,
		[6] = T.RT_1059,
		[7] = T.RT_1059,
		[8] = T.RT_1059,
		[9] = T.RT_1059,
		[10] = T.RT_1059,
		[11] = T.RT_1059,
		[12] = T.RT_1059,
		[13] = T.RT_1059,
		[14] = T.RT_1059,
		[15] = T.RT_1059,
		[16] = T.RT_1059,
		[17] = T.RT_1059,
		[18] = T.RT_1059,
		[19] = T.RT_1059,
		[20] = T.RT_1059,
	},
	[330101] = {
		[1] = T.RT_1065,
		[2] = T.RT_1065,
		[3] = T.RT_1065,
		[4] = T.RT_1065,
		[5] = T.RT_1065,
		[6] = T.RT_1065,
		[7] = T.RT_1065,
		[8] = T.RT_1065,
		[9] = T.RT_1065,
		[10] = T.RT_1065,
		[11] = T.RT_1065,
		[12] = T.RT_1065,
		[13] = T.RT_1065,
		[14] = T.RT_1065,
		[15] = T.RT_1065,
		[16] = T.RT_1065,
		[17] = T.RT_1065,
		[18] = T.RT_1065,
		[19] = T.RT_1065,
		[20] = T.RT_1065,
	},
	[330102] = {
		[1] = T.RT_1070,
		[2] = T.RT_1070,
		[3] = T.RT_1070,
		[4] = T.RT_1070,
		[5] = T.RT_1070,
		[6] = T.RT_1070,
		[7] = T.RT_1070,
		[8] = T.RT_1070,
		[9] = T.RT_1070,
		[10] = T.RT_1070,
		[11] = T.RT_1070,
		[12] = T.RT_1070,
		[13] = T.RT_1070,
		[14] = T.RT_1070,
		[15] = T.RT_1070,
		[16] = T.RT_1070,
		[17] = T.RT_1070,
		[18] = T.RT_1070,
		[19] = T.RT_1070,
		[20] = T.RT_1070,
	},
	[330103] = {
		[1] = T.RT_1075,
		[2] = T.RT_1075,
		[3] = T.RT_1075,
		[4] = T.RT_1075,
		[5] = T.RT_1075,
		[6] = T.RT_1075,
		[7] = T.RT_1075,
		[8] = T.RT_1075,
		[9] = T.RT_1075,
		[10] = T.RT_1075,
		[11] = T.RT_1075,
		[12] = T.RT_1075,
		[13] = T.RT_1075,
		[14] = T.RT_1075,
		[15] = T.RT_1075,
		[16] = T.RT_1075,
		[17] = T.RT_1075,
		[18] = T.RT_1075,
		[19] = T.RT_1075,
		[20] = T.RT_1075,
	},
	[330104] = {
		[1] = T.RT_1079,
		[2] = T.RT_1079,
		[3] = T.RT_1079,
		[4] = T.RT_1079,
		[5] = T.RT_1079,
		[6] = T.RT_1079,
		[7] = T.RT_1079,
		[8] = T.RT_1079,
		[9] = T.RT_1079,
		[10] = T.RT_1079,
		[11] = T.RT_1079,
		[12] = T.RT_1079,
		[13] = T.RT_1079,
		[14] = T.RT_1079,
		[15] = T.RT_1079,
		[16] = T.RT_1079,
		[17] = T.RT_1079,
		[18] = T.RT_1079,
		[19] = T.RT_1079,
		[20] = T.RT_1079,
	},
	[330112] = {
		[1] = T.RT_1081,
		[2] = T.RT_1081,
		[3] = T.RT_1081,
		[4] = T.RT_1081,
		[5] = T.RT_1081,
		[6] = T.RT_1081,
		[7] = T.RT_1081,
		[8] = T.RT_1081,
		[9] = T.RT_1081,
		[10] = T.RT_1081,
		[11] = T.RT_1081,
		[12] = T.RT_1081,
		[13] = T.RT_1081,
		[14] = T.RT_1081,
		[15] = T.RT_1081,
		[16] = T.RT_1081,
		[17] = T.RT_1081,
		[18] = T.RT_1081,
		[19] = T.RT_1081,
		[20] = T.RT_1081,
	},
	[410001] = {
		[1] = T.RT_1131,
		[2] = T.RT_1131,
		[3] = T.RT_1131,
		[4] = T.RT_1131,
		[5] = T.RT_1131,
		[6] = T.RT_1131,
		[7] = T.RT_1131,
		[8] = T.RT_1131,
		[9] = T.RT_1131,
		[10] = T.RT_1131,
		[11] = T.RT_1131,
		[12] = T.RT_1131,
		[13] = T.RT_1131,
		[14] = T.RT_1131,
		[15] = T.RT_1131,
		[16] = T.RT_1131,
		[17] = T.RT_1131,
		[18] = T.RT_1131,
		[19] = T.RT_1131,
		[20] = T.RT_1131,
	},
	[410003] = {
		[1] = T.RT_1135,
		[2] = T.RT_1135,
		[3] = T.RT_1135,
		[4] = T.RT_1135,
		[5] = T.RT_1135,
		[6] = T.RT_1135,
		[7] = T.RT_1135,
		[8] = T.RT_1135,
		[9] = T.RT_1135,
		[10] = T.RT_1135,
		[11] = T.RT_1135,
		[12] = T.RT_1135,
		[13] = T.RT_1135,
		[14] = T.RT_1135,
		[15] = T.RT_1135,
		[16] = T.RT_1135,
		[17] = T.RT_1135,
		[18] = T.RT_1135,
		[19] = T.RT_1135,
		[20] = T.RT_1135,
	},
	[410101] = {
		[1] = T.RT_1140,
		[2] = T.RT_1140,
		[3] = T.RT_1140,
		[4] = T.RT_1140,
		[5] = T.RT_1140,
		[6] = T.RT_1140,
		[7] = T.RT_1140,
		[8] = T.RT_1140,
		[9] = T.RT_1140,
		[10] = T.RT_1140,
		[11] = T.RT_1140,
		[12] = T.RT_1140,
		[13] = T.RT_1140,
		[14] = T.RT_1140,
		[15] = T.RT_1140,
		[16] = T.RT_1140,
		[17] = T.RT_1140,
		[18] = T.RT_1140,
		[19] = T.RT_1140,
		[20] = T.RT_1140,
	},
	[410102] = {
		[1] = T.RT_1151,
		[2] = T.RT_1151,
		[3] = T.RT_1151,
		[4] = T.RT_1151,
		[5] = T.RT_1151,
		[6] = T.RT_1151,
		[7] = T.RT_1151,
		[8] = T.RT_1151,
		[9] = T.RT_1151,
		[10] = T.RT_1151,
		[11] = T.RT_1151,
		[12] = T.RT_1151,
		[13] = T.RT_1151,
		[14] = T.RT_1151,
		[15] = T.RT_1151,
		[16] = T.RT_1151,
		[17] = T.RT_1151,
		[18] = T.RT_1151,
		[19] = T.RT_1151,
		[20] = T.RT_1151,
	},
	[410103] = {
		[1] = T.RT_1156,
		[2] = T.RT_1156,
		[3] = T.RT_1156,
		[4] = T.RT_1156,
		[5] = T.RT_1156,
		[6] = T.RT_1156,
		[7] = T.RT_1156,
		[8] = T.RT_1156,
		[9] = T.RT_1156,
		[10] = T.RT_1156,
		[11] = T.RT_1156,
		[12] = T.RT_1156,
		[13] = T.RT_1156,
		[14] = T.RT_1156,
		[15] = T.RT_1156,
		[16] = T.RT_1156,
		[17] = T.RT_1156,
		[18] = T.RT_1156,
		[19] = T.RT_1156,
		[20] = T.RT_1156,
	},
	[410104] = {
		[1] = T.RT_1159,
		[2] = T.RT_1159,
		[3] = T.RT_1159,
		[4] = T.RT_1159,
		[5] = T.RT_1159,
		[6] = T.RT_1159,
		[7] = T.RT_1159,
		[8] = T.RT_1159,
		[9] = T.RT_1159,
		[10] = T.RT_1159,
		[11] = T.RT_1159,
		[12] = T.RT_1159,
		[13] = T.RT_1159,
		[14] = T.RT_1159,
		[15] = T.RT_1159,
		[16] = T.RT_1159,
		[17] = T.RT_1159,
		[18] = T.RT_1159,
		[19] = T.RT_1159,
		[20] = T.RT_1159,
	},
	[410121] = {
		[1] = T.RT_1162,
		[2] = T.RT_1162,
		[3] = T.RT_1162,
		[4] = T.RT_1162,
		[5] = T.RT_1162,
		[6] = T.RT_1162,
		[7] = T.RT_1162,
		[8] = T.RT_1162,
		[9] = T.RT_1162,
		[10] = T.RT_1162,
		[11] = T.RT_1162,
		[12] = T.RT_1162,
		[13] = T.RT_1162,
		[14] = T.RT_1162,
		[15] = T.RT_1162,
		[16] = T.RT_1162,
		[17] = T.RT_1162,
		[18] = T.RT_1162,
		[19] = T.RT_1162,
		[20] = T.RT_1162,
	},
	[410201] = {
		[1] = T.RT_1171,
		[2] = T.RT_1171,
		[3] = T.RT_1171,
		[4] = T.RT_1171,
		[5] = T.RT_1171,
		[6] = T.RT_1171,
		[7] = T.RT_1171,
		[8] = T.RT_1171,
		[9] = T.RT_1171,
		[10] = T.RT_1171,
		[11] = T.RT_1171,
		[12] = T.RT_1171,
		[13] = T.RT_1171,
		[14] = T.RT_1171,
		[15] = T.RT_1171,
		[16] = T.RT_1171,
		[17] = T.RT_1171,
		[18] = T.RT_1171,
		[19] = T.RT_1171,
		[20] = T.RT_1171,
	},
	[410202] = {
		[1] = T.RT_1189,
		[2] = T.RT_1189,
		[3] = T.RT_1189,
		[4] = T.RT_1189,
		[5] = T.RT_1189,
		[6] = T.RT_1189,
		[7] = T.RT_1189,
		[8] = T.RT_1189,
		[9] = T.RT_1189,
		[10] = T.RT_1189,
		[11] = T.RT_1189,
		[12] = T.RT_1189,
		[13] = T.RT_1189,
		[14] = T.RT_1189,
		[15] = T.RT_1189,
		[16] = T.RT_1189,
		[17] = T.RT_1189,
		[18] = T.RT_1189,
		[19] = T.RT_1189,
		[20] = T.RT_1189,
	},
	[410203] = {
		[1] = T.RT_1193,
		[2] = T.RT_1193,
		[3] = T.RT_1193,
		[4] = T.RT_1193,
		[5] = T.RT_1193,
		[6] = T.RT_1193,
		[7] = T.RT_1193,
		[8] = T.RT_1193,
		[9] = T.RT_1193,
		[10] = T.RT_1193,
		[11] = T.RT_1193,
		[12] = T.RT_1193,
		[13] = T.RT_1193,
		[14] = T.RT_1193,
		[15] = T.RT_1193,
		[16] = T.RT_1193,
		[17] = T.RT_1193,
		[18] = T.RT_1193,
		[19] = T.RT_1193,
		[20] = T.RT_1193,
	},
	[410204] = {
		[1] = T.RT_1197,
		[2] = T.RT_1197,
		[3] = T.RT_1197,
		[4] = T.RT_1197,
		[5] = T.RT_1197,
		[6] = T.RT_1197,
		[7] = T.RT_1197,
		[8] = T.RT_1197,
		[9] = T.RT_1197,
		[10] = T.RT_1197,
		[11] = T.RT_1197,
		[12] = T.RT_1197,
		[13] = T.RT_1197,
		[14] = T.RT_1197,
		[15] = T.RT_1197,
		[16] = T.RT_1197,
		[17] = T.RT_1197,
		[18] = T.RT_1197,
		[19] = T.RT_1197,
		[20] = T.RT_1197,
	},
	[410211] = {
		[1] = T.RT_1199,
		[2] = T.RT_1199,
		[3] = T.RT_1199,
		[4] = T.RT_1199,
		[5] = T.RT_1199,
		[6] = T.RT_1199,
		[7] = T.RT_1199,
		[8] = T.RT_1199,
		[9] = T.RT_1199,
		[10] = T.RT_1199,
		[11] = T.RT_1199,
		[12] = T.RT_1199,
		[13] = T.RT_1199,
		[14] = T.RT_1199,
		[15] = T.RT_1199,
		[16] = T.RT_1199,
		[17] = T.RT_1199,
		[18] = T.RT_1199,
		[19] = T.RT_1199,
		[20] = T.RT_1199,
	},
	[410221] = {
		[1] = T.RT_1201,
		[2] = T.RT_1201,
		[3] = T.RT_1201,
		[4] = T.RT_1201,
		[5] = T.RT_1201,
		[6] = T.RT_1201,
		[7] = T.RT_1201,
		[8] = T.RT_1201,
		[9] = T.RT_1201,
		[10] = T.RT_1201,
		[11] = T.RT_1201,
		[12] = T.RT_1201,
		[13] = T.RT_1201,
		[14] = T.RT_1201,
		[15] = T.RT_1201,
		[16] = T.RT_1201,
		[17] = T.RT_1201,
		[18] = T.RT_1201,
		[19] = T.RT_1201,
		[20] = T.RT_1201,
	},
	[410222] = {
		[1] = T.RT_1204,
		[2] = T.RT_1204,
		[3] = T.RT_1204,
		[4] = T.RT_1204,
		[5] = T.RT_1204,
		[6] = T.RT_1204,
		[7] = T.RT_1204,
		[8] = T.RT_1204,
		[9] = T.RT_1204,
		[10] = T.RT_1204,
		[11] = T.RT_1204,
		[12] = T.RT_1204,
		[13] = T.RT_1204,
		[14] = T.RT_1204,
		[15] = T.RT_1204,
		[16] = T.RT_1204,
		[17] = T.RT_1204,
		[18] = T.RT_1204,
		[19] = T.RT_1204,
		[20] = T.RT_1204,
	},
	[410223] = {
		[1] = T.RT_1206,
		[2] = T.RT_1206,
		[3] = T.RT_1206,
		[4] = T.RT_1206,
		[5] = T.RT_1206,
		[6] = T.RT_1206,
		[7] = T.RT_1206,
		[8] = T.RT_1206,
		[9] = T.RT_1206,
		[10] = T.RT_1206,
		[11] = T.RT_1206,
		[12] = T.RT_1206,
		[13] = T.RT_1206,
		[14] = T.RT_1206,
		[15] = T.RT_1206,
		[16] = T.RT_1206,
		[17] = T.RT_1206,
		[18] = T.RT_1206,
		[19] = T.RT_1206,
		[20] = T.RT_1206,
	},
	[410224] = {
		[1] = T.RT_1208,
		[2] = T.RT_1208,
		[3] = T.RT_1208,
		[4] = T.RT_1208,
		[5] = T.RT_1208,
		[6] = T.RT_1208,
		[7] = T.RT_1208,
		[8] = T.RT_1208,
		[9] = T.RT_1208,
		[10] = T.RT_1208,
		[11] = T.RT_1208,
		[12] = T.RT_1208,
		[13] = T.RT_1208,
		[14] = T.RT_1208,
		[15] = T.RT_1208,
		[16] = T.RT_1208,
		[17] = T.RT_1208,
		[18] = T.RT_1208,
		[19] = T.RT_1208,
		[20] = T.RT_1208,
	},
	[420101] = {
		[1] = T.RT_1243,
		[2] = T.RT_1243,
		[3] = T.RT_1243,
		[4] = T.RT_1243,
		[5] = T.RT_1243,
		[6] = T.RT_1243,
		[7] = T.RT_1243,
		[8] = T.RT_1243,
		[9] = T.RT_1243,
		[10] = T.RT_1243,
		[11] = T.RT_1243,
		[12] = T.RT_1243,
		[13] = T.RT_1243,
		[14] = T.RT_1243,
		[15] = T.RT_1243,
		[16] = T.RT_1243,
		[17] = T.RT_1243,
		[18] = T.RT_1243,
		[19] = T.RT_1243,
		[20] = T.RT_1243,
	},
	[420102] = {
		[1] = T.RT_1249,
		[2] = T.RT_1249,
		[3] = T.RT_1249,
		[4] = T.RT_1249,
		[5] = T.RT_1249,
		[6] = T.RT_1249,
		[7] = T.RT_1249,
		[8] = T.RT_1249,
		[9] = T.RT_1249,
		[10] = T.RT_1249,
		[11] = T.RT_1249,
		[12] = T.RT_1249,
		[13] = T.RT_1249,
		[14] = T.RT_1249,
		[15] = T.RT_1249,
		[16] = T.RT_1249,
		[17] = T.RT_1249,
		[18] = T.RT_1249,
		[19] = T.RT_1249,
		[20] = T.RT_1249,
	},
	[420103] = {
		[1] = T.RT_1253,
		[2] = T.RT_1253,
		[3] = T.RT_1253,
		[4] = T.RT_1253,
		[5] = T.RT_1253,
		[6] = T.RT_1253,
		[7] = T.RT_1253,
		[8] = T.RT_1253,
		[9] = T.RT_1253,
		[10] = T.RT_1253,
		[11] = T.RT_1253,
		[12] = T.RT_1253,
		[13] = T.RT_1253,
		[14] = T.RT_1253,
		[15] = T.RT_1253,
		[16] = T.RT_1253,
		[17] = T.RT_1253,
		[18] = T.RT_1253,
		[19] = T.RT_1253,
		[20] = T.RT_1253,
	},
	[420104] = {
		[1] = T.RT_1256,
		[2] = T.RT_1256,
		[3] = T.RT_1256,
		[4] = T.RT_1256,
		[5] = T.RT_1256,
		[6] = T.RT_1256,
		[7] = T.RT_1256,
		[8] = T.RT_1256,
		[9] = T.RT_1256,
		[10] = T.RT_1256,
		[11] = T.RT_1256,
		[12] = T.RT_1256,
		[13] = T.RT_1256,
		[14] = T.RT_1256,
		[15] = T.RT_1256,
		[16] = T.RT_1256,
		[17] = T.RT_1256,
		[18] = T.RT_1256,
		[19] = T.RT_1256,
		[20] = T.RT_1256,
	},
	[420111] = {
		[1] = T.RT_1259,
		[2] = T.RT_1259,
		[3] = T.RT_1259,
		[4] = T.RT_1259,
		[5] = T.RT_1259,
		[6] = T.RT_1259,
		[7] = T.RT_1259,
		[8] = T.RT_1259,
		[9] = T.RT_1259,
		[10] = T.RT_1259,
		[11] = T.RT_1259,
		[12] = T.RT_1259,
		[13] = T.RT_1259,
		[14] = T.RT_1259,
		[15] = T.RT_1259,
		[16] = T.RT_1259,
		[17] = T.RT_1259,
		[18] = T.RT_1259,
		[19] = T.RT_1259,
		[20] = T.RT_1259,
	},
	[420191] = {
		[1] = T.RT_1263,
		[2] = T.RT_1263,
		[3] = T.RT_1263,
		[4] = T.RT_1263,
		[5] = T.RT_1263,
		[6] = T.RT_1263,
		[7] = T.RT_1263,
		[8] = T.RT_1263,
		[9] = T.RT_1263,
		[10] = T.RT_1263,
		[11] = T.RT_1263,
		[12] = T.RT_1263,
		[13] = T.RT_1263,
		[14] = T.RT_1263,
		[15] = T.RT_1263,
		[16] = T.RT_1263,
		[17] = T.RT_1263,
		[18] = T.RT_1263,
		[19] = T.RT_1263,
		[20] = T.RT_1263,
	},
	[420201] = {
		[1] = T.RT_1272,
		[2] = T.RT_1272,
		[3] = T.RT_1272,
		[4] = T.RT_1272,
		[5] = T.RT_1272,
		[6] = T.RT_1272,
		[7] = T.RT_1272,
		[8] = T.RT_1272,
		[9] = T.RT_1272,
		[10] = T.RT_1272,
		[11] = T.RT_1272,
		[12] = T.RT_1272,
		[13] = T.RT_1272,
		[14] = T.RT_1272,
		[15] = T.RT_1272,
		[16] = T.RT_1272,
		[17] = T.RT_1272,
		[18] = T.RT_1272,
		[19] = T.RT_1272,
		[20] = T.RT_1272,
	},
	[420202] = {
		[1] = T.RT_1279,
		[2] = T.RT_1279,
		[3] = T.RT_1279,
		[4] = T.RT_1279,
		[5] = T.RT_1279,
		[6] = T.RT_1279,
		[7] = T.RT_1279,
		[8] = T.RT_1279,
		[9] = T.RT_1279,
		[10] = T.RT_1279,
		[11] = T.RT_1279,
		[12] = T.RT_1279,
		[13] = T.RT_1279,
		[14] = T.RT_1279,
		[15] = T.RT_1279,
		[16] = T.RT_1279,
		[17] = T.RT_1279,
		[18] = T.RT_1279,
		[19] = T.RT_1279,
		[20] = T.RT_1279,
	},
	[420203] = {
		[1] = T.RT_1285,
		[2] = T.RT_1285,
		[3] = T.RT_1285,
		[4] = T.RT_1285,
		[5] = T.RT_1285,
		[6] = T.RT_1285,
		[7] = T.RT_1285,
		[8] = T.RT_1285,
		[9] = T.RT_1285,
		[10] = T.RT_1285,
		[11] = T.RT_1285,
		[12] = T.RT_1285,
		[13] = T.RT_1285,
		[14] = T.RT_1285,
		[15] = T.RT_1285,
		[16] = T.RT_1285,
		[17] = T.RT_1285,
		[18] = T.RT_1285,
		[19] = T.RT_1285,
		[20] = T.RT_1285,
	},
	[420204] = {
		[1] = T.RT_1291,
		[2] = T.RT_1291,
		[3] = T.RT_1291,
		[4] = T.RT_1291,
		[5] = T.RT_1291,
		[6] = T.RT_1291,
		[7] = T.RT_1291,
		[8] = T.RT_1291,
		[9] = T.RT_1291,
		[10] = T.RT_1291,
		[11] = T.RT_1291,
		[12] = T.RT_1291,
		[13] = T.RT_1291,
		[14] = T.RT_1291,
		[15] = T.RT_1291,
		[16] = T.RT_1291,
		[17] = T.RT_1291,
		[18] = T.RT_1291,
		[19] = T.RT_1291,
		[20] = T.RT_1291,
	},
	[420211] = {
		[1] = T.RT_1293,
		[2] = T.RT_1293,
		[3] = T.RT_1293,
		[4] = T.RT_1293,
		[5] = T.RT_1293,
		[6] = T.RT_1293,
		[7] = T.RT_1293,
		[8] = T.RT_1293,
		[9] = T.RT_1293,
		[10] = T.RT_1293,
		[11] = T.RT_1293,
		[12] = T.RT_1293,
		[13] = T.RT_1293,
		[14] = T.RT_1293,
		[15] = T.RT_1293,
		[16] = T.RT_1293,
		[17] = T.RT_1293,
		[18] = T.RT_1293,
		[19] = T.RT_1293,
		[20] = T.RT_1293,
	},
	[430101] = {
		[1] = T.RT_1329,
		[2] = T.RT_1329,
		[3] = T.RT_1329,
		[4] = T.RT_1329,
		[5] = T.RT_1329,
		[6] = T.RT_1329,
		[7] = T.RT_1329,
		[8] = T.RT_1329,
		[9] = T.RT_1329,
		[10] = T.RT_1329,
		[11] = T.RT_1329,
		[12] = T.RT_1329,
		[13] = T.RT_1329,
		[14] = T.RT_1329,
		[15] = T.RT_1329,
		[16] = T.RT_1329,
		[17] = T.RT_1329,
		[18] = T.RT_1329,
		[19] = T.RT_1329,
		[20] = T.RT_1329,
	},
	[430102] = {
		[1] = T.RT_1339,
		[2] = T.RT_1339,
		[3] = T.RT_1339,
		[4] = T.RT_1339,
		[5] = T.RT_1339,
		[6] = T.RT_1339,
		[7] = T.RT_1339,
		[8] = T.RT_1339,
		[9] = T.RT_1339,
		[10] = T.RT_1339,
		[11] = T.RT_1339,
		[12] = T.RT_1339,
		[13] = T.RT_1339,
		[14] = T.RT_1339,
		[15] = T.RT_1339,
		[16] = T.RT_1339,
		[17] = T.RT_1339,
		[18] = T.RT_1339,
		[19] = T.RT_1339,
		[20] = T.RT_1339,
	},
	[430103] = {
		[1] = T.RT_1344,
		[2] = T.RT_1344,
		[3] = T.RT_1344,
		[4] = T.RT_1344,
		[5] = T.RT_1344,
		[6] = T.RT_1344,
		[7] = T.RT_1344,
		[8] = T.RT_1344,
		[9] = T.RT_1344,
		[10] = T.RT_1344,
		[11] = T.RT_1344,
		[12] = T.RT_1344,
		[13] = T.RT_1344,
		[14] = T.RT_1344,
		[15] = T.RT_1344,
		[16] = T.RT_1344,
		[17] = T.RT_1344,
		[18] = T.RT_1344,
		[19] = T.RT_1344,
		[20] = T.RT_1344,
	},
	[430104] = {
		[1] = T.RT_1349,
		[2] = T.RT_1349,
		[3] = T.RT_1349,
		[4] = T.RT_1349,
		[5] = T.RT_1349,
		[6] = T.RT_1349,
		[7] = T.RT_1349,
		[8] = T.RT_1349,
		[9] = T.RT_1349,
		[10] = T.RT_1349,
		[11] = T.RT_1349,
		[12] = T.RT_1349,
		[13] = T.RT_1349,
		[14] = T.RT_1349,
		[15] = T.RT_1349,
		[16] = T.RT_1349,
		[17] = T.RT_1349,
		[18] = T.RT_1349,
		[19] = T.RT_1349,
		[20] = T.RT_1349,
	},
	[510001] = {
		[1] = T.RT_1353,
		[2] = T.RT_1353,
		[3] = T.RT_1353,
		[4] = T.RT_1353,
		[5] = T.RT_1353,
		[6] = T.RT_1353,
		[7] = T.RT_1353,
		[8] = T.RT_1353,
		[9] = T.RT_1353,
		[10] = T.RT_1353,
		[11] = T.RT_1353,
		[12] = T.RT_1353,
		[13] = T.RT_1353,
		[14] = T.RT_1353,
		[15] = T.RT_1353,
		[16] = T.RT_1353,
		[17] = T.RT_1353,
		[18] = T.RT_1353,
		[19] = T.RT_1353,
		[20] = T.RT_1353,
	},
	[510003] = {
		[1] = T.RT_1357,
		[2] = T.RT_1357,
		[3] = T.RT_1357,
		[4] = T.RT_1357,
		[5] = T.RT_1357,
		[6] = T.RT_1357,
		[7] = T.RT_1357,
		[8] = T.RT_1357,
		[9] = T.RT_1357,
		[10] = T.RT_1357,
		[11] = T.RT_1357,
		[12] = T.RT_1357,
		[13] = T.RT_1357,
		[14] = T.RT_1357,
		[15] = T.RT_1357,
		[16] = T.RT_1357,
		[17] = T.RT_1357,
		[18] = T.RT_1357,
		[19] = T.RT_1357,
		[20] = T.RT_1357,
	},
	[510101] = {
		[1] = T.RT_1369,
		[2] = T.RT_1369,
		[3] = T.RT_1369,
		[4] = T.RT_1369,
		[5] = T.RT_1369,
		[6] = T.RT_1369,
		[7] = T.RT_1369,
		[8] = T.RT_1369,
		[9] = T.RT_1369,
		[10] = T.RT_1369,
		[11] = T.RT_1369,
		[12] = T.RT_1369,
		[13] = T.RT_1369,
		[14] = T.RT_1369,
		[15] = T.RT_1369,
		[16] = T.RT_1369,
		[17] = T.RT_1369,
		[18] = T.RT_1369,
		[19] = T.RT_1369,
		[20] = T.RT_1369,
	},
	[510102] = {
		[1] = T.RT_1376,
		[2] = T.RT_1376,
		[3] = T.RT_1376,
		[4] = T.RT_1376,
		[5] = T.RT_1376,
		[6] = T.RT_1376,
		[7] = T.RT_1376,
		[8] = T.RT_1376,
		[9] = T.RT_1376,
		[10] = T.RT_1376,
		[11] = T.RT_1376,
		[12] = T.RT_1376,
		[13] = T.RT_1376,
		[14] = T.RT_1376,
		[15] = T.RT_1376,
		[16] = T.RT_1376,
		[17] = T.RT_1376,
		[18] = T.RT_1376,
		[19] = T.RT_1376,
		[20] = T.RT_1376,
	},
	[510103] = {
		[1] = T.RT_1382,
		[2] = T.RT_1382,
		[3] = T.RT_1382,
		[4] = T.RT_1382,
		[5] = T.RT_1382,
		[6] = T.RT_1382,
		[7] = T.RT_1382,
		[8] = T.RT_1382,
		[9] = T.RT_1382,
		[10] = T.RT_1382,
		[11] = T.RT_1382,
		[12] = T.RT_1382,
		[13] = T.RT_1382,
		[14] = T.RT_1382,
		[15] = T.RT_1382,
		[16] = T.RT_1382,
		[17] = T.RT_1382,
		[18] = T.RT_1382,
		[19] = T.RT_1382,
		[20] = T.RT_1382,
	},
	[510104] = {
		[1] = T.RT_1384,
		[2] = T.RT_1384,
		[3] = T.RT_1384,
		[4] = T.RT_1384,
		[5] = T.RT_1384,
		[6] = T.RT_1384,
		[7] = T.RT_1384,
		[8] = T.RT_1384,
		[9] = T.RT_1384,
		[10] = T.RT_1384,
		[11] = T.RT_1384,
		[12] = T.RT_1384,
		[13] = T.RT_1384,
		[14] = T.RT_1384,
		[15] = T.RT_1384,
		[16] = T.RT_1384,
		[17] = T.RT_1384,
		[18] = T.RT_1384,
		[19] = T.RT_1384,
		[20] = T.RT_1384,
	},
	[510105] = {
		[1] = T.RT_1386,
		[2] = T.RT_1386,
		[3] = T.RT_1386,
		[4] = T.RT_1386,
		[5] = T.RT_1386,
		[6] = T.RT_1386,
		[7] = T.RT_1386,
		[8] = T.RT_1386,
		[9] = T.RT_1386,
		[10] = T.RT_1386,
		[11] = T.RT_1386,
		[12] = T.RT_1386,
		[13] = T.RT_1386,
		[14] = T.RT_1386,
		[15] = T.RT_1386,
		[16] = T.RT_1386,
		[17] = T.RT_1386,
		[18] = T.RT_1386,
		[19] = T.RT_1386,
		[20] = T.RT_1386,
	},
	[510106] = {
		[1] = T.RT_1390,
		[2] = T.RT_1390,
		[3] = T.RT_1390,
		[4] = T.RT_1390,
		[5] = T.RT_1390,
		[6] = T.RT_1390,
		[7] = T.RT_1390,
		[8] = T.RT_1390,
		[9] = T.RT_1390,
		[10] = T.RT_1390,
		[11] = T.RT_1390,
		[12] = T.RT_1390,
		[13] = T.RT_1390,
		[14] = T.RT_1390,
		[15] = T.RT_1390,
		[16] = T.RT_1390,
		[17] = T.RT_1390,
		[18] = T.RT_1390,
		[19] = T.RT_1390,
		[20] = T.RT_1390,
	},
	[510107] = {
		[1] = T.RT_1392,
		[2] = T.RT_1392,
		[3] = T.RT_1392,
		[4] = T.RT_1392,
		[5] = T.RT_1392,
		[6] = T.RT_1392,
		[7] = T.RT_1392,
		[8] = T.RT_1392,
		[9] = T.RT_1392,
		[10] = T.RT_1392,
		[11] = T.RT_1392,
		[12] = T.RT_1392,
		[13] = T.RT_1392,
		[14] = T.RT_1392,
		[15] = T.RT_1392,
		[16] = T.RT_1392,
		[17] = T.RT_1392,
		[18] = T.RT_1392,
		[19] = T.RT_1392,
		[20] = T.RT_1392,
	},
	[510111] = {
		[1] = T.RT_1397,
		[2] = T.RT_1397,
		[3] = T.RT_1397,
		[4] = T.RT_1397,
		[5] = T.RT_1397,
		[6] = T.RT_1397,
		[7] = T.RT_1397,
		[8] = T.RT_1397,
		[9] = T.RT_1397,
		[10] = T.RT_1397,
		[11] = T.RT_1397,
		[12] = T.RT_1397,
		[13] = T.RT_1397,
		[14] = T.RT_1397,
		[15] = T.RT_1397,
		[16] = T.RT_1397,
		[17] = T.RT_1397,
		[18] = T.RT_1397,
		[19] = T.RT_1397,
		[20] = T.RT_1397,
	},
	[510113] = {
		[1] = T.RT_1399,
		[2] = T.RT_1399,
		[3] = T.RT_1399,
		[4] = T.RT_1399,
		[5] = T.RT_1399,
		[6] = T.RT_1399,
		[7] = T.RT_1399,
		[8] = T.RT_1399,
		[9] = T.RT_1399,
		[10] = T.RT_1399,
		[11] = T.RT_1399,
		[12] = T.RT_1399,
		[13] = T.RT_1399,
		[14] = T.RT_1399,
		[15] = T.RT_1399,
		[16] = T.RT_1399,
		[17] = T.RT_1399,
		[18] = T.RT_1399,
		[19] = T.RT_1399,
		[20] = T.RT_1399,
	},
	[510121] = {
		[1] = T.RT_1401,
		[2] = T.RT_1401,
		[3] = T.RT_1401,
		[4] = T.RT_1401,
		[5] = T.RT_1401,
		[6] = T.RT_1401,
		[7] = T.RT_1401,
		[8] = T.RT_1401,
		[9] = T.RT_1401,
		[10] = T.RT_1401,
		[11] = T.RT_1401,
		[12] = T.RT_1401,
		[13] = T.RT_1401,
		[14] = T.RT_1401,
		[15] = T.RT_1401,
		[16] = T.RT_1401,
		[17] = T.RT_1401,
		[18] = T.RT_1401,
		[19] = T.RT_1401,
		[20] = T.RT_1401,
	},
	[510191] = {
		[1] = T.RT_1406,
		[2] = T.RT_1406,
		[3] = T.RT_1406,
		[4] = T.RT_1406,
		[5] = T.RT_1406,
		[6] = T.RT_1406,
		[7] = T.RT_1406,
		[8] = T.RT_1406,
		[9] = T.RT_1406,
		[10] = T.RT_1406,
		[11] = T.RT_1406,
		[12] = T.RT_1406,
		[13] = T.RT_1406,
		[14] = T.RT_1406,
		[15] = T.RT_1406,
		[16] = T.RT_1406,
		[17] = T.RT_1406,
		[18] = T.RT_1406,
		[19] = T.RT_1406,
		[20] = T.RT_1406,
	},
	[510201] = {
		[1] = T.RT_1413,
		[2] = T.RT_1413,
		[3] = T.RT_1413,
		[4] = T.RT_1413,
		[5] = T.RT_1413,
		[6] = T.RT_1413,
		[7] = T.RT_1413,
		[8] = T.RT_1413,
		[9] = T.RT_1413,
		[10] = T.RT_1413,
		[11] = T.RT_1413,
		[12] = T.RT_1413,
		[13] = T.RT_1413,
		[14] = T.RT_1413,
		[15] = T.RT_1413,
		[16] = T.RT_1413,
		[17] = T.RT_1413,
		[18] = T.RT_1413,
		[19] = T.RT_1413,
		[20] = T.RT_1413,
	},
	[510202] = {
		[1] = T.RT_1419,
		[2] = T.RT_1419,
		[3] = T.RT_1419,
		[4] = T.RT_1419,
		[5] = T.RT_1419,
		[6] = T.RT_1419,
		[7] = T.RT_1419,
		[8] = T.RT_1419,
		[9] = T.RT_1419,
		[10] = T.RT_1419,
		[11] = T.RT_1419,
		[12] = T.RT_1419,
		[13] = T.RT_1419,
		[14] = T.RT_1419,
		[15] = T.RT_1419,
		[16] = T.RT_1419,
		[17] = T.RT_1419,
		[18] = T.RT_1419,
		[19] = T.RT_1419,
		[20] = T.RT_1419,
	},
	[510203] = {
		[1] = T.RT_1426,
		[2] = T.RT_1426,
		[3] = T.RT_1426,
		[4] = T.RT_1426,
		[5] = T.RT_1426,
		[6] = T.RT_1426,
		[7] = T.RT_1426,
		[8] = T.RT_1426,
		[9] = T.RT_1426,
		[10] = T.RT_1426,
		[11] = T.RT_1426,
		[12] = T.RT_1426,
		[13] = T.RT_1426,
		[14] = T.RT_1426,
		[15] = T.RT_1426,
		[16] = T.RT_1426,
		[17] = T.RT_1426,
		[18] = T.RT_1426,
		[19] = T.RT_1426,
		[20] = T.RT_1426,
	},
	[510204] = {
		[1] = T.RT_1430,
		[2] = T.RT_1430,
		[3] = T.RT_1430,
		[4] = T.RT_1430,
		[5] = T.RT_1430,
		[6] = T.RT_1430,
		[7] = T.RT_1430,
		[8] = T.RT_1430,
		[9] = T.RT_1430,
		[10] = T.RT_1430,
		[11] = T.RT_1430,
		[12] = T.RT_1430,
		[13] = T.RT_1430,
		[14] = T.RT_1430,
		[15] = T.RT_1430,
		[16] = T.RT_1430,
		[17] = T.RT_1430,
		[18] = T.RT_1430,
		[19] = T.RT_1430,
		[20] = T.RT_1430,
	},
	[530101] = {
		[1] = T.RT_1442,
		[2] = T.RT_1442,
		[3] = T.RT_1442,
		[4] = T.RT_1442,
		[5] = T.RT_1442,
		[6] = T.RT_1442,
		[7] = T.RT_1442,
		[8] = T.RT_1442,
		[9] = T.RT_1442,
		[10] = T.RT_1442,
		[11] = T.RT_1442,
		[12] = T.RT_1442,
		[13] = T.RT_1442,
		[14] = T.RT_1442,
		[15] = T.RT_1442,
		[16] = T.RT_1442,
		[17] = T.RT_1442,
		[18] = T.RT_1442,
		[19] = T.RT_1442,
		[20] = T.RT_1442,
	},
	[530102] = {
		[1] = T.RT_1447,
		[2] = T.RT_1447,
		[3] = T.RT_1447,
		[4] = T.RT_1447,
		[5] = T.RT_1447,
		[6] = T.RT_1447,
		[7] = T.RT_1447,
		[8] = T.RT_1447,
		[9] = T.RT_1447,
		[10] = T.RT_1447,
		[11] = T.RT_1447,
		[12] = T.RT_1447,
		[13] = T.RT_1447,
		[14] = T.RT_1447,
		[15] = T.RT_1447,
		[16] = T.RT_1447,
		[17] = T.RT_1447,
		[18] = T.RT_1447,
		[19] = T.RT_1447,
		[20] = T.RT_1447,
	},
	[530103] = {
		[1] = T.RT_1454,
		[2] = T.RT_1454,
		[3] = T.RT_1454,
		[4] = T.RT_1454,
		[5] = T.RT_1454,
		[6] = T.RT_1454,
		[7] = T.RT_1454,
		[8] = T.RT_1454,
		[9] = T.RT_1454,
		[10] = T.RT_1454,
		[11] = T.RT_1454,
		[12] = T.RT_1454,
		[13] = T.RT_1454,
		[14] = T.RT_1454,
		[15] = T.RT_1454,
		[16] = T.RT_1454,
		[17] = T.RT_1454,
		[18] = T.RT_1454,
		[19] = T.RT_1454,
		[20] = T.RT_1454,
	},
	[530104] = {
		[1] = T.RT_1459,
		[2] = T.RT_1459,
		[3] = T.RT_1459,
		[4] = T.RT_1459,
		[5] = T.RT_1459,
		[6] = T.RT_1459,
		[7] = T.RT_1459,
		[8] = T.RT_1459,
		[9] = T.RT_1459,
		[10] = T.RT_1459,
		[11] = T.RT_1459,
		[12] = T.RT_1459,
		[13] = T.RT_1459,
		[14] = T.RT_1459,
		[15] = T.RT_1459,
		[16] = T.RT_1459,
		[17] = T.RT_1459,
		[18] = T.RT_1459,
		[19] = T.RT_1459,
		[20] = T.RT_1459,
	},
	[530105] = {
		[1] = T.RT_1461,
		[2] = T.RT_1461,
		[3] = T.RT_1461,
		[4] = T.RT_1461,
		[5] = T.RT_1461,
		[6] = T.RT_1461,
		[7] = T.RT_1461,
		[8] = T.RT_1461,
		[9] = T.RT_1461,
		[10] = T.RT_1461,
		[11] = T.RT_1461,
		[12] = T.RT_1461,
		[13] = T.RT_1461,
		[14] = T.RT_1461,
		[15] = T.RT_1461,
		[16] = T.RT_1461,
		[17] = T.RT_1461,
		[18] = T.RT_1461,
		[19] = T.RT_1461,
		[20] = T.RT_1461,
	},
	[530111] = {
		[1] = T.RT_1467,
		[2] = T.RT_1467,
		[3] = T.RT_1467,
		[4] = T.RT_1467,
		[5] = T.RT_1467,
		[6] = T.RT_1467,
		[7] = T.RT_1467,
		[8] = T.RT_1467,
		[9] = T.RT_1467,
		[10] = T.RT_1467,
		[11] = T.RT_1467,
		[12] = T.RT_1467,
		[13] = T.RT_1467,
		[14] = T.RT_1467,
		[15] = T.RT_1467,
		[16] = T.RT_1467,
		[17] = T.RT_1467,
		[18] = T.RT_1467,
		[19] = T.RT_1467,
		[20] = T.RT_1467,
	},
	[530121] = {
		[1] = T.RT_1469,
		[2] = T.RT_1469,
		[3] = T.RT_1469,
		[4] = T.RT_1469,
		[5] = T.RT_1469,
		[6] = T.RT_1469,
		[7] = T.RT_1469,
		[8] = T.RT_1469,
		[9] = T.RT_1469,
		[10] = T.RT_1469,
		[11] = T.RT_1469,
		[12] = T.RT_1469,
		[13] = T.RT_1469,
		[14] = T.RT_1469,
		[15] = T.RT_1469,
		[16] = T.RT_1469,
		[17] = T.RT_1469,
		[18] = T.RT_1469,
		[19] = T.RT_1469,
		[20] = T.RT_1469,
	},
	[530122] = {
		[1] = T.RT_1471,
		[2] = T.RT_1471,
		[3] = T.RT_1471,
		[4] = T.RT_1471,
		[5] = T.RT_1471,
		[6] = T.RT_1471,
		[7] = T.RT_1471,
		[8] = T.RT_1471,
		[9] = T.RT_1471,
		[10] = T.RT_1471,
		[11] = T.RT_1471,
		[12] = T.RT_1471,
		[13] = T.RT_1471,
		[14] = T.RT_1471,
		[15] = T.RT_1471,
		[16] = T.RT_1471,
		[17] = T.RT_1471,
		[18] = T.RT_1471,
		[19] = T.RT_1471,
		[20] = T.RT_1471,
	},
	[540101] = {
		[1] = T.RT_1478,
		[2] = T.RT_1478,
		[3] = T.RT_1478,
		[4] = T.RT_1478,
		[5] = T.RT_1478,
		[6] = T.RT_1478,
		[7] = T.RT_1478,
		[8] = T.RT_1478,
		[9] = T.RT_1478,
		[10] = T.RT_1478,
		[11] = T.RT_1478,
		[12] = T.RT_1478,
		[13] = T.RT_1478,
		[14] = T.RT_1478,
		[15] = T.RT_1478,
		[16] = T.RT_1478,
		[17] = T.RT_1478,
		[18] = T.RT_1478,
		[19] = T.RT_1478,
		[20] = T.RT_1478,
	},
	[540102] = {
		[1] = T.RT_1485,
		[2] = T.RT_1485,
		[3] = T.RT_1485,
		[4] = T.RT_1485,
		[5] = T.RT_1485,
		[6] = T.RT_1485,
		[7] = T.RT_1485,
		[8] = T.RT_1485,
		[9] = T.RT_1485,
		[10] = T.RT_1485,
		[11] = T.RT_1485,
		[12] = T.RT_1485,
		[13] = T.RT_1485,
		[14] = T.RT_1485,
		[15] = T.RT_1485,
		[16] = T.RT_1485,
		[17] = T.RT_1485,
		[18] = T.RT_1485,
		[19] = T.RT_1485,
		[20] = T.RT_1485,
	},
	[540103] = {
		[1] = T.RT_1490,
		[2] = T.RT_1490,
		[3] = T.RT_1490,
		[4] = T.RT_1490,
		[5] = T.RT_1490,
		[6] = T.RT_1490,
		[7] = T.RT_1490,
		[8] = T.RT_1490,
		[9] = T.RT_1490,
		[10] = T.RT_1490,
		[11] = T.RT_1490,
		[12] = T.RT_1490,
		[13] = T.RT_1490,
		[14] = T.RT_1490,
		[15] = T.RT_1490,
		[16] = T.RT_1490,
		[17] = T.RT_1490,
		[18] = T.RT_1490,
		[19] = T.RT_1490,
		[20] = T.RT_1490,
	},
	[540104] = {
		[1] = T.RT_1495,
		[2] = T.RT_1495,
		[3] = T.RT_1495,
		[4] = T.RT_1495,
		[5] = T.RT_1495,
		[6] = T.RT_1495,
		[7] = T.RT_1495,
		[8] = T.RT_1495,
		[9] = T.RT_1495,
		[10] = T.RT_1495,
		[11] = T.RT_1495,
		[12] = T.RT_1495,
		[13] = T.RT_1495,
		[14] = T.RT_1495,
		[15] = T.RT_1495,
		[16] = T.RT_1495,
		[17] = T.RT_1495,
		[18] = T.RT_1495,
		[19] = T.RT_1495,
		[20] = T.RT_1495,
	},
	[540201] = {
		[1] = T.RT_1497,
		[2] = T.RT_1497,
		[3] = T.RT_1497,
		[4] = T.RT_1497,
		[5] = T.RT_1497,
		[6] = T.RT_1497,
		[7] = T.RT_1497,
		[8] = T.RT_1497,
		[9] = T.RT_1497,
		[10] = T.RT_1497,
		[11] = T.RT_1497,
		[12] = T.RT_1497,
		[13] = T.RT_1497,
		[14] = T.RT_1497,
		[15] = T.RT_1497,
		[16] = T.RT_1497,
		[17] = T.RT_1497,
		[18] = T.RT_1497,
		[19] = T.RT_1497,
		[20] = T.RT_1497,
	},
	[540202] = {
		[1] = T.RT_1499,
		[2] = T.RT_1499,
		[3] = T.RT_1499,
		[4] = T.RT_1499,
		[5] = T.RT_1499,
		[6] = T.RT_1499,
		[7] = T.RT_1499,
		[8] = T.RT_1499,
		[9] = T.RT_1499,
		[10] = T.RT_1499,
		[11] = T.RT_1499,
		[12] = T.RT_1499,
		[13] = T.RT_1499,
		[14] = T.RT_1499,
		[15] = T.RT_1499,
		[16] = T.RT_1499,
		[17] = T.RT_1499,
		[18] = T.RT_1499,
		[19] = T.RT_1499,
		[20] = T.RT_1499,
	},
	[540203] = {
		[1] = T.RT_1502,
		[2] = T.RT_1502,
		[3] = T.RT_1502,
		[4] = T.RT_1502,
		[5] = T.RT_1502,
		[6] = T.RT_1502,
		[7] = T.RT_1502,
		[8] = T.RT_1502,
		[9] = T.RT_1502,
		[10] = T.RT_1502,
		[11] = T.RT_1502,
		[12] = T.RT_1502,
		[13] = T.RT_1502,
		[14] = T.RT_1502,
		[15] = T.RT_1502,
		[16] = T.RT_1502,
		[17] = T.RT_1502,
		[18] = T.RT_1502,
		[19] = T.RT_1502,
		[20] = T.RT_1502,
	},
	[540204] = {
		[1] = T.RT_1505,
		[2] = T.RT_1505,
		[3] = T.RT_1505,
		[4] = T.RT_1505,
		[5] = T.RT_1505,
		[6] = T.RT_1505,
		[7] = T.RT_1505,
		[8] = T.RT_1505,
		[9] = T.RT_1505,
		[10] = T.RT_1505,
		[11] = T.RT_1505,
		[12] = T.RT_1505,
		[13] = T.RT_1505,
		[14] = T.RT_1505,
		[15] = T.RT_1505,
		[16] = T.RT_1505,
		[17] = T.RT_1505,
		[18] = T.RT_1505,
		[19] = T.RT_1505,
		[20] = T.RT_1505,
	},
	[540220] = {
		[1] = T.RT_1507,
		[2] = T.RT_1507,
		[3] = T.RT_1507,
		[4] = T.RT_1507,
		[5] = T.RT_1507,
		[6] = T.RT_1507,
		[7] = T.RT_1507,
		[8] = T.RT_1507,
		[9] = T.RT_1507,
		[10] = T.RT_1507,
		[11] = T.RT_1507,
		[12] = T.RT_1507,
		[13] = T.RT_1507,
		[14] = T.RT_1507,
		[15] = T.RT_1507,
		[16] = T.RT_1507,
		[17] = T.RT_1507,
		[18] = T.RT_1507,
		[19] = T.RT_1507,
		[20] = T.RT_1507,
	},
	[540221] = {
		[1] = T.RT_1509,
		[2] = T.RT_1509,
		[3] = T.RT_1509,
		[4] = T.RT_1509,
		[5] = T.RT_1509,
		[6] = T.RT_1509,
		[7] = T.RT_1509,
		[8] = T.RT_1509,
		[9] = T.RT_1509,
		[10] = T.RT_1509,
		[11] = T.RT_1509,
		[12] = T.RT_1509,
		[13] = T.RT_1509,
		[14] = T.RT_1509,
		[15] = T.RT_1509,
		[16] = T.RT_1509,
		[17] = T.RT_1509,
		[18] = T.RT_1509,
		[19] = T.RT_1509,
		[20] = T.RT_1509,
	},
	[540222] = {
		[1] = T.RT_1511,
		[2] = T.RT_1511,
		[3] = T.RT_1511,
		[4] = T.RT_1511,
		[5] = T.RT_1511,
		[6] = T.RT_1511,
		[7] = T.RT_1511,
		[8] = T.RT_1511,
		[9] = T.RT_1511,
		[10] = T.RT_1511,
		[11] = T.RT_1511,
		[12] = T.RT_1511,
		[13] = T.RT_1511,
		[14] = T.RT_1511,
		[15] = T.RT_1511,
		[16] = T.RT_1511,
		[17] = T.RT_1511,
		[18] = T.RT_1511,
		[19] = T.RT_1511,
		[20] = T.RT_1511,
	},
	[540223] = {
		[1] = T.RT_1514,
		[2] = T.RT_1514,
		[3] = T.RT_1514,
		[4] = T.RT_1514,
		[5] = T.RT_1514,
		[6] = T.RT_1514,
		[7] = T.RT_1514,
		[8] = T.RT_1514,
		[9] = T.RT_1514,
		[10] = T.RT_1514,
		[11] = T.RT_1514,
		[12] = T.RT_1514,
		[13] = T.RT_1514,
		[14] = T.RT_1514,
		[15] = T.RT_1514,
		[16] = T.RT_1514,
		[17] = T.RT_1514,
		[18] = T.RT_1514,
		[19] = T.RT_1514,
		[20] = T.RT_1514,
	},
	[540231] = {
		[1] = T.RT_1517,
		[2] = T.RT_1517,
		[3] = T.RT_1517,
		[4] = T.RT_1517,
		[5] = T.RT_1517,
		[6] = T.RT_1517,
		[7] = T.RT_1517,
		[8] = T.RT_1517,
		[9] = T.RT_1517,
		[10] = T.RT_1517,
		[11] = T.RT_1517,
		[12] = T.RT_1517,
		[13] = T.RT_1517,
		[14] = T.RT_1517,
		[15] = T.RT_1517,
		[16] = T.RT_1517,
		[17] = T.RT_1517,
		[18] = T.RT_1517,
		[19] = T.RT_1517,
		[20] = T.RT_1517,
	},
	[540232] = {
		[1] = T.RT_1519,
		[2] = T.RT_1519,
		[3] = T.RT_1519,
		[4] = T.RT_1519,
		[5] = T.RT_1519,
		[6] = T.RT_1519,
		[7] = T.RT_1519,
		[8] = T.RT_1519,
		[9] = T.RT_1519,
		[10] = T.RT_1519,
		[11] = T.RT_1519,
		[12] = T.RT_1519,
		[13] = T.RT_1519,
		[14] = T.RT_1519,
		[15] = T.RT_1519,
		[16] = T.RT_1519,
		[17] = T.RT_1519,
		[18] = T.RT_1519,
		[19] = T.RT_1519,
		[20] = T.RT_1519,
	},
	[540241] = {
		[1] = T.RT_1521,
		[2] = T.RT_1521,
		[3] = T.RT_1521,
		[4] = T.RT_1521,
		[5] = T.RT_1521,
		[6] = T.RT_1521,
		[7] = T.RT_1521,
		[8] = T.RT_1521,
		[9] = T.RT_1521,
		[10] = T.RT_1521,
		[11] = T.RT_1521,
		[12] = T.RT_1521,
		[13] = T.RT_1521,
		[14] = T.RT_1521,
		[15] = T.RT_1521,
		[16] = T.RT_1521,
		[17] = T.RT_1521,
		[18] = T.RT_1521,
		[19] = T.RT_1521,
		[20] = T.RT_1521,
	},
	[540251] = {
		[1] = T.RT_1523,
		[2] = T.RT_1523,
		[3] = T.RT_1523,
		[4] = T.RT_1523,
		[5] = T.RT_1523,
		[6] = T.RT_1523,
		[7] = T.RT_1523,
		[8] = T.RT_1523,
		[9] = T.RT_1523,
		[10] = T.RT_1523,
		[11] = T.RT_1523,
		[12] = T.RT_1523,
		[13] = T.RT_1523,
		[14] = T.RT_1523,
		[15] = T.RT_1523,
		[16] = T.RT_1523,
		[17] = T.RT_1523,
		[18] = T.RT_1523,
		[19] = T.RT_1523,
		[20] = T.RT_1523,
	},
	[600101] = {
		[1] = {
			[0] = {
				BeginNodeId = 600101,
				SkillGrade = 0,
				SkillId = 600101,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600102] = {
		[1] = {
			[0] = {
				BeginNodeId = 600102,
				SkillGrade = 0,
				SkillId = 600102,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600103] = {
		[1] = {
			[0] = {
				BeginNodeId = 600103,
				BornInCd = 10,
				CD = 20,
				SkillGrade = 0,
				SkillId = 600103,
				SkillLevel = 1,
			},
		},
	},
	[600104] = {
		[1] = {
			[0] = {
				BeginNodeId = 600104,
				SkillGrade = 0,
				SkillId = 600104,
				SkillLevel = 1,
			},
		},
	},
	[600111] = {
		[1] = {
			[0] = {
				BeginNodeId = 600111,
				SkillGrade = 0,
				SkillId = 600111,
				SkillLevel = 1,
			},
		},
	},
	[600171] = {
		[1] = {
			[0] = {
				BeginNodeId = 601101,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 600171,
				SkillLevel = 1,
			},
		},
	},
	[600172] = {
		[1] = {
			[0] = {
				BeginNodeId = 600172,
				SkillGrade = 0,
				SkillId = 600172,
				SkillLevel = 1,
			},
		},
	},
	[600201] = {
		[1] = {
			[0] = {
				BeginNodeId = 600201,
				SkillGrade = 0,
				SkillId = 600201,
				SkillLevel = 1,
				SkillSpeedModify = true,
				SkillType = "Shooting",
			},
		},
	},
	[600202] = {
		[1] = {
			[0] = {
				BeginNodeId = 600202,
				SkillGrade = 0,
				SkillId = 600202,
				SkillLevel = 1,
				SkillType = "Shooting",
			},
		},
	},
	[600203] = {
		[1] = {
			[0] = {
				BeginNodeId = 600203,
				SkillGrade = 0,
				SkillId = 600203,
				SkillLevel = 1,
			},
		},
	},
	[600204] = {
		[1] = {
			[0] = {
				BeginNodeId = 600204,
				SkillGrade = 0,
				SkillId = 600204,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600205] = {
		[1] = {
			[0] = {
				BeginNodeId = 600205,
				SkillGrade = 0,
				SkillId = 600205,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600211] = {
		[1] = {
			[0] = {
				BeginNodeId = 600211,
				SkillGrade = 0,
				SkillId = 600211,
				SkillLevel = 1,
			},
		},
	},
	[600271] = {
		[1] = {
			[0] = {
				BeginNodeId = 600201,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 600271,
				SkillLevel = 1,
				SkillSpeedModify = true,
				SkillType = "Shooting",
			},
		},
	},
	[600272] = {
		[1] = {
			[0] = {
				BeginNodeId = 601201,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 600272,
				SkillLevel = 1,
				SkillType = "Shooting",
			},
		},
	},
	[600273] = {
		[1] = {
			[0] = {
				BeginNodeId = 600273,
				SkillGrade = 0,
				SkillId = 600273,
				SkillLevel = 1,
			},
		},
	},
	[600301] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600301,
				SkillGrade = 0,
				SkillId = 600301,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600302] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600302,
				SkillGrade = 0,
				SkillId = 600302,
				SkillLevel = 1,
			},
		},
	},
	[600303] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600303,
				SkillGrade = 0,
				SkillId = 600303,
				SkillLevel = 1,
			},
		},
	},
	[600311] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600311,
				SkillGrade = 0,
				SkillId = 600311,
				SkillLevel = 1,
			},
		},
	},
	[600371] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600302,
				BornInCd = 10,
				CD = 12,
				SkillGrade = 0,
				SkillId = 600371,
				SkillLevel = 1,
			},
		},
	},
	[600372] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600372,
				SkillGrade = 0,
				SkillId = 600372,
				SkillLevel = 1,
			},
		},
	},
	[600401] = {
		[1] = {
			[0] = {
				BeginNodeId = 600401,
				SkillGrade = 0,
				SkillId = 600401,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600402] = {
		[1] = {
			[0] = {
				BeginNodeId = 600402,
				SkillGrade = 0,
				SkillId = 600402,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600403] = {
		[1] = {
			[0] = {
				BeginNodeId = 600403,
				CD = 20,
				SkillGrade = 0,
				SkillId = 600403,
				SkillLevel = 1,
			},
		},
	},
	[600404] = {
		[1] = {
			[0] = {
				BeginNodeId = 600404,
				CD = 20,
				SkillGrade = 0,
				SkillId = 600404,
				SkillLevel = 1,
			},
		},
	},
	[600405] = {
		[1] = {
			[0] = {
				BeginNodeId = 600403,
				CD = 2,
				SkillGrade = 0,
				SkillId = 600405,
				SkillLevel = 1,
			},
		},
	},
	[600411] = {
		[1] = {
			[0] = {
				BeginNodeId = 600411,
				SkillGrade = 0,
				SkillId = 600411,
				SkillLevel = 1,
			},
		},
	},
	[600471] = {
		[1] = {
			[0] = {
				BeginNodeId = 600404,
				BornInCd = 10,
				CD = 10,
				SkillGrade = 0,
				SkillId = 600471,
				SkillLevel = 1,
			},
		},
	},
	[600472] = {
		[1] = {
			[0] = {
				BeginNodeId = 600472,
				SkillGrade = 0,
				SkillId = 600472,
				SkillLevel = 1,
			},
		},
	},
	[600501] = {
		[1] = {
			[0] = {
				BeginNodeId = 600501,
				SkillGrade = 0,
				SkillId = 600501,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600502] = {
		[1] = {
			[0] = {
				BeginNodeId = 600502,
				CD = 10,
				CDType = 600502,
				SkillGrade = 0,
				SkillId = 600502,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600503] = {
		[1] = {
			[0] = {
				BeginNodeId = 600503,
				SkillGrade = 0,
				SkillId = 600503,
				SkillLevel = 1,
			},
		},
	},
	[600504] = {
		[1] = {
			[0] = {
				BeginNodeId = 600504,
				SkillGrade = 0,
				SkillId = 600504,
				SkillLevel = 1,
			},
		},
	},
	[600505] = {
		[1] = {
			[0] = {
				BeginNodeId = 600505,
				CD = 10,
				CDType = 600502,
				SkillGrade = 0,
				SkillId = 600505,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600506] = {
		[1] = {
			[0] = {
				BeginNodeId = 600506,
				SkillGrade = 0,
				SkillId = 600506,
				SkillLevel = 1,
			},
		},
	},
	[600507] = {
		[1] = {
			[0] = {
				BeginNodeId = 600507,
				SkillGrade = 0,
				SkillId = 600507,
				SkillLevel = 1,
			},
		},
	},
	[600508] = {
		[1] = {
			[0] = {
				BeginNodeId = 600508,
				SkillGrade = 0,
				SkillId = 600508,
				SkillLevel = 1,
			},
		},
	},
	[600571] = {
		[1] = {
			[0] = {
				BeginNodeId = 600502,
				BornInCd = 10,
				CD = 12,
				SkillGrade = 0,
				SkillId = 600571,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600572] = {
		[1] = {
			[0] = {
				BeginNodeId = 600572,
				SkillGrade = 0,
				SkillId = 600572,
				SkillLevel = 1,
			},
		},
	},
	[600601] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600601,
				SkillGrade = 0,
				SkillId = 600601,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600602] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600602,
				CD = 15,
				SkillGrade = 0,
				SkillId = 600602,
				SkillLevel = 1,
			},
		},
	},
	[600603] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600603,
				CD = 10,
				SkillGrade = 0,
				SkillId = 600603,
				SkillLevel = 1,
			},
		},
	},
	[600611] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 600611,
				SkillGrade = 0,
				SkillId = 600611,
				SkillLevel = 1,
			},
		},
	},
	[600701] = {
		[1] = {
			[0] = {
				BeginNodeId = 600701,
				SkillGrade = 0,
				SkillId = 600701,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[600702] = {
		[1] = {
			[0] = {
				BeginNodeId = 600702,
				CD = 15,
				SkillGrade = 0,
				SkillId = 600702,
				SkillLevel = 1,
			},
		},
	},
	[600711] = {
		[1] = {
			[0] = {
				BeginNodeId = 600711,
				SkillGrade = 0,
				SkillId = 600711,
				SkillLevel = 1,
			},
		},
	},
	[601101] = {
		[1] = {
			[0] = {
				BeginNodeId = 601101,
				SkillGrade = 0,
				SkillId = 601101,
				SkillLevel = 1,
			},
		},
	},
	[601201] = {
		[1] = {
			[0] = {
				BeginNodeId = 601201,
				SkillGrade = 0,
				SkillId = 601201,
				SkillLevel = 1,
				SkillType = "Shooting",
			},
		},
	},
	[601202] = {
		[1] = {
			[0] = {
				BeginNodeId = 601202,
				SkillGrade = 0,
				SkillId = 601202,
				SkillLevel = 1,
				SkillType = "Shooting",
			},
		},
	},
	[601301] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 601301,
				BornInCd = 5,
				CD = 5,
				SkillGrade = 0,
				SkillId = 601301,
				SkillLevel = 1,
			},
		},
	},
	[601302] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 601302,
				SkillGrade = 0,
				SkillId = 601302,
				SkillLevel = 1,
			},
		},
	},
	[601401] = {
		[1] = {
			[0] = {
				BeginNodeId = 601401,
				SkillGrade = 0,
				SkillId = 601401,
				SkillLevel = 1,
			},
		},
	},
	[601402] = {
		[1] = {
			[0] = {
				BeginNodeId = 601402,
				SkillGrade = 0,
				SkillId = 601402,
				SkillLevel = 1,
			},
		},
	},
	[601403] = {
		[1] = {
			[0] = {
				BeginNodeId = 601403,
				CD = 20,
				SkillGrade = 0,
				SkillId = 601403,
				SkillLevel = 1,
			},
		},
	},
	[601404] = {
		[1] = {
			[0] = {
				BeginNodeId = 601403,
				SkillGrade = 0,
				SkillId = 601404,
				SkillLevel = 1,
			},
		},
	},
	[601405] = {
		[1] = {
			[0] = {
				BeginNodeId = 601405,
				SkillGrade = 0,
				SkillId = 601405,
				SkillLevel = 1,
			},
		},
	},
	[601501] = {
		[1] = {
			[0] = {
				BeginNodeId = 601501,
				SkillGrade = 0,
				SkillId = 601501,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[601502] = {
		[1] = {
			[0] = {
				BeginNodeId = 601502,
				CD = 15,
				SkillGrade = 0,
				SkillId = 601502,
				SkillLevel = 1,
			},
		},
	},
	[601511] = {
		[1] = {
			[0] = {
				BeginNodeId = 601511,
				SkillGrade = 0,
				SkillId = 601511,
				SkillLevel = 1,
			},
		},
	},
	[601601] = {
		[1] = {
			[0] = {
				BeginNodeId = 601601,
				SkillGrade = 0,
				SkillId = 601601,
				SkillLevel = 1,
				SkillSpeedModify = true,
				SkillType = "Shooting",
			},
		},
	},
	[601602] = {
		[1] = {
			[0] = {
				BeginNodeId = 601602,
				SkillGrade = 0,
				SkillId = 601602,
				SkillLevel = 1,
				SkillType = "Shooting",
			},
		},
	},
	[601603] = {
		[1] = {
			[0] = {
				BeginNodeId = 601603,
				SkillGrade = 0,
				SkillId = 601603,
				SkillLevel = 1,
			},
		},
	},
	[601604] = {
		[1] = {
			[0] = {
				BeginNodeId = 601604,
				SkillGrade = 0,
				SkillId = 601604,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[601605] = {
		[1] = {
			[0] = {
				BeginNodeId = 601605,
				SkillGrade = 0,
				SkillId = 601605,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[601611] = {
		[1] = {
			[0] = {
				BeginNodeId = 601611,
				SkillGrade = 0,
				SkillId = 601611,
				SkillLevel = 1,
			},
		},
	},
	[601701] = {
		[1] = {
			[0] = {
				BeginNodeId = 601701,
				SkillGrade = 0,
				SkillId = 601701,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[601702] = {
		[1] = {
			[0] = {
				BeginNodeId = 601702,
				SkillGrade = 0,
				SkillId = 601702,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[601703] = {
		[1] = {
			[0] = {
				BeginNodeId = 601703,
				BornInCd = 10,
				CD = 20,
				SkillGrade = 0,
				SkillId = 601703,
				SkillLevel = 1,
			},
		},
	},
	[601704] = {
		[1] = {
			[0] = {
				BeginNodeId = 601704,
				SkillGrade = 0,
				SkillId = 601704,
				SkillLevel = 1,
			},
		},
	},
	[601711] = {
		[1] = {
			[0] = {
				BeginNodeId = 601711,
				SkillGrade = 0,
				SkillId = 601711,
				SkillLevel = 1,
			},
		},
	},
	[700101] = {
		[1] = {
			[0] = {
				BeginNodeId = 700101,
				SkillGrade = 0,
				SkillId = 700101,
				SkillLevel = 1,
				SkillSpeedModify = true,
				SkillType = "Shooting",
			},
		},
	},
	[700102] = {
		[1] = {
			[0] = {
				BeginNodeId = 700102,
				SkillGrade = 0,
				SkillId = 700102,
				SkillLevel = 1,
				SkillType = "Shooting",
			},
		},
	},
	[700103] = {
		[1] = {
			[0] = {
				BeginNodeId = 700103,
				SkillGrade = 0,
				SkillId = 700103,
				SkillLevel = 1,
			},
		},
	},
	[700104] = {
		[1] = {
			[0] = {
				BeginNodeId = 700104,
				SkillGrade = 0,
				SkillId = 700104,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[700105] = {
		[1] = {
			[0] = {
				BeginNodeId = 700105,
				SkillGrade = 0,
				SkillId = 700105,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[700106] = {
		[1] = {
			[0] = {
				BeginNodeId = 700106,
				SkillGrade = 0,
				SkillId = 700106,
				SkillLevel = 1,
			},
		},
	},
	[700107] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 700107,
				SkillGrade = 0,
				SkillId = 700107,
				SkillLevel = 1,
			},
		},
	},
	[700108] = {
		[1] = {
			[0] = {
				BeginNodeId = 700108,
				SkillGrade = 0,
				SkillId = 700108,
				SkillLevel = 1,
				SkillSpeedModify = true,
				SkillType = "Shooting",
			},
		},
	},
	[700111] = {
		[1] = {
			[0] = {
				BeginNodeId = 700111,
				SkillGrade = 0,
				SkillId = 700111,
				SkillLevel = 1,
			},
		},
	},
	[700121] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					700121,
				},
				SkillGrade = 0,
				SkillId = 700121,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[700122] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					700122,
				},
				SkillGrade = 0,
				SkillId = 700122,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[700171] = {
		[1] = {
			[0] = {
				BeginNodeId = 700102,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 700171,
				SkillLevel = 1,
				SkillType = "Shooting",
			},
		},
	},
	[700172] = {
		[1] = {
			[0] = {
				BeginNodeId = 700172,
				SkillGrade = 0,
				SkillId = 700172,
				SkillLevel = 1,
			},
		},
	},
	[700201] = {
		[1] = {
			[0] = {
				BeginNodeId = 700201,
				SkillGrade = 0,
				SkillId = 700201,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[700202] = {
		[1] = {
			[0] = {
				BeginNodeId = 700202,
				SkillGrade = 0,
				SkillId = 700202,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[700203] = {
		[1] = {
			[0] = {
				BeginNodeId = 700203,
				CD = 15,
				SkillGrade = 0,
				SkillId = 700203,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[700210] = {
		[1] = {
			[0] = {
				BeginNodeId = 700210,
				SkillGrade = 0,
				SkillId = 700210,
				SkillLevel = 1,
			},
		},
	},
	[700211] = {
		[1] = {
			[0] = {
				BeginNodeId = 700211,
				SkillGrade = 0,
				SkillId = 700211,
				SkillLevel = 1,
			},
		},
	},
	[700215] = {
		[1] = {
			[0] = {
				BeginNodeId = 700215,
				SkillGrade = 0,
				SkillId = 700215,
				SkillLevel = 1,
			},
		},
	},
	[700221] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					700221,
				},
				SkillGrade = 0,
				SkillId = 700221,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[700223] = {
		[1] = {
			[0] = {
				BeginNodeId = 700223,
				CD = 9999,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 700223,
				SkillLevel = 1,
			},
		},
	},
	[700224] = {
		[1] = {
			[0] = {
				BeginNodeId = 700224,
				BornInCd = 5,
				CD = 15,
				SkillGrade = 0,
				SkillId = 700224,
				SkillLevel = 1,
			},
		},
	},
	[700272] = {
		[1] = {
			[0] = {
				BeginNodeId = 700272,
				SkillGrade = 0,
				SkillId = 700272,
				SkillLevel = 1,
			},
		},
	},
	[700301] = {
		[1] = {
			[0] = {
				BeginNodeId = 700301,
				SkillGrade = 0,
				SkillId = 700301,
				SkillLevel = 1,
				SkillSpeedModify = true,
				SkillType = "Shooting",
			},
		},
	},
	[700302] = {
		[1] = {
			[0] = {
				BeginNodeId = 700302,
				CD = 10,
				SkillEndEnterTag = "Cover",
				SkillGrade = 0,
				SkillId = 700302,
				SkillLevel = 1,
			},
		},
	},
	[700303] = {
		[1] = {
			[0] = {
				BeginNodeId = 700303,
				CD = 10,
				SkillEndEnterTag = "Cover",
				SkillGrade = 0,
				SkillId = 700303,
				SkillLevel = 1,
			},
		},
	},
	[700304] = {
		[1] = {
			[0] = {
				BeginNodeId = 700304,
				SkillGrade = 0,
				SkillId = 700304,
				SkillLevel = 1,
			},
		},
	},
	[700305] = {
		[1] = {
			[0] = {
				BeginNodeId = 700305,
				SkillGrade = 0,
				SkillId = 700305,
				SkillLevel = 1,
			},
		},
	},
	[700306] = {
		[1] = {
			[0] = {
				BeginNodeId = 700306,
				SkillGrade = 0,
				SkillId = 700306,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[700307] = {
		[1] = {
			[0] = {
				BeginNodeId = 700307,
				SkillGrade = 0,
				SkillId = 700307,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[700311] = {
		[1] = {
			[0] = {
				BeginNodeId = 700311,
				SkillGrade = 0,
				SkillId = 700311,
				SkillLevel = 1,
			},
		},
	},
	[700321] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					700321,
				},
				SkillGrade = 0,
				SkillId = 700321,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[700322] = {
		[1] = {
			[0] = {
				BeginNodeId = 700321,
				CD = 10,
				SkillGrade = 0,
				SkillId = 700322,
				SkillLevel = 1,
			},
		},
	},
	[700324] = {
		[1] = {
			[0] = {
				BeginNodeId = 700323,
				SkillGrade = 0,
				SkillId = 700324,
				SkillLevel = 1,
			},
		},
	},
	[700371] = {
		[1] = {
			[0] = {
				BeginNodeId = 700302,
				BornInCd = 10,
				CD = 8,
				SkillEndEnterTag = "Cover",
				SkillGrade = 0,
				SkillId = 700371,
				SkillLevel = 1,
			},
		},
	},
	[700372] = {
		[1] = {
			[0] = {
				BeginNodeId = 700372,
				SkillGrade = 0,
				SkillId = 700372,
				SkillLevel = 1,
			},
		},
	},
	[700401] = {
		[1] = {
			[0] = {
				BeginNodeId = 700401,
				SkillGrade = 0,
				SkillId = 700401,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[700402] = {
		[1] = {
			[0] = {
				BeginNodeId = 700402,
				CD = 20,
				SkillGrade = 0,
				SkillId = 700402,
				SkillLevel = 1,
			},
		},
	},
	[700403] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					700401,
				},
				SkillGrade = 0,
				SkillId = 700403,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[700404] = {
		[1] = {
			[0] = {
				BeginNodeId = 700403,
				SkillGrade = 0,
				SkillId = 700404,
				SkillLevel = 1,
			},
		},
	},
	[700411] = {
		[1] = {
			[0] = {
				BeginNodeId = 700411,
				SkillGrade = 0,
				SkillId = 700411,
				SkillLevel = 1,
			},
		},
	},
	[700472] = {
		[1] = {
			[0] = {
				BeginNodeId = 700472,
				SkillGrade = 0,
				SkillId = 700472,
				SkillLevel = 1,
			},
		},
	},
	[700621] = {
		[1] = {
			[0] = {
				BeginNodeId = 700621,
				SkillGrade = 0,
				SkillId = 700621,
				SkillLevel = 1,
			},
		},
	},
	[700622] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					700621,
				},
				SkillGrade = 0,
				SkillId = 700622,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[700721] = {
		[1] = {
			[0] = {
				BeginNodeId = 700721,
				SkillGrade = 0,
				SkillId = 700721,
				SkillLevel = 1,
			},
		},
	},
	[700731] = {
		[1] = {
			[0] = {
				BeginNodeId = 700731,
				SkillGrade = 0,
				SkillId = 700731,
				SkillLevel = 1,
			},
		},
	},
	[700741] = {
		[1] = {
			[0] = {
				BeginNodeId = 700741,
				SkillGrade = 0,
				SkillId = 700741,
				SkillLevel = 1,
			},
		},
	},
	[700751] = {
		[1] = {
			[0] = {
				BeginNodeId = 700751,
				SkillGrade = 0,
				SkillId = 700751,
				SkillLevel = 1,
			},
		},
	},
	[700801] = {
		[1] = {
			[0] = {
				BeginNodeId = 700801,
				SkillGrade = 0,
				SkillId = 700801,
				SkillLevel = 1,
			},
		},
	},
	[700802] = {
		[1] = {
			[0] = {
				BeginNodeId = 700802,
				CD = 10,
				SkillGrade = 0,
				SkillId = 700802,
				SkillLevel = 1,
			},
		},
	},
	[700803] = {
		[1] = {
			[0] = {
				BeginNodeId = 700803,
				SkillGrade = 0,
				SkillId = 700803,
				SkillLevel = 1,
			},
		},
	},
	[700804] = {
		[1] = {
			[0] = {
				BeginNodeId = 700804,
				CD = 10,
				SkillGrade = 0,
				SkillId = 700804,
				SkillLevel = 1,
			},
		},
	},
	[700805] = {
		[1] = {
			[0] = {
				BeginNodeId = 700805,
				SkillGrade = 0,
				SkillId = 700805,
				SkillLevel = 1,
			},
		},
	},
	[700806] = {
		[1] = {
			[0] = {
				BeginNodeId = 700806,
				CD = 20,
				SkillGrade = 0,
				SkillId = 700806,
				SkillLevel = 1,
			},
		},
	},
	[700807] = {
		[1] = {
			[0] = {
				BeginNodeId = 700807,
				SkillGrade = 0,
				SkillId = 700807,
				SkillLevel = 1,
			},
		},
	},
	[700808] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					700801,
				},
				SkillGrade = 0,
				SkillId = 700808,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[700809] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					700802,
				},
				SkillGrade = 0,
				SkillId = 700809,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[700810] = {
		[1] = {
			[0] = {
				BeginNodeId = 700808,
				CD = 10,
				SkillGrade = 0,
				SkillId = 700810,
				SkillLevel = 1,
			},
		},
	},
	[700812] = {
		[1] = {
			[0] = {
				BeginNodeId = 700804,
				SkillGrade = 0,
				SkillId = 700812,
				SkillLevel = 1,
			},
		},
	},
	[700813] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					700803,
				},
				SkillGrade = 0,
				SkillId = 700813,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[700871] = {
		[1] = {
			[0] = {
				BeginNodeId = 700806,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 700871,
				SkillLevel = 1,
			},
		},
	},
	[700872] = {
		[1] = {
			[0] = {
				BeginNodeId = 700872,
				SkillGrade = 0,
				SkillId = 700872,
				SkillLevel = 1,
			},
		},
	},
	[700901] = {
		[1] = {
			[0] = {
				BeginNodeId = 700901,
				SkillGrade = 0,
				SkillId = 700901,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[700902] = {
		[1] = {
			[0] = {
				BeginNodeId = 700902,
				CD = 6,
				SkillGrade = 0,
				SkillId = 700902,
				SkillLevel = 1,
			},
		},
	},
	[700903] = {
		[1] = {
			[0] = {
				BeginNodeId = 700903,
				CD = 10,
				SkillGrade = 0,
				SkillId = 700903,
				SkillLevel = 1,
			},
		},
	},
	[700971] = {
		[1] = {
			[0] = {
				BeginNodeId = 700903,
				BornInCd = 3,
				CD = 6,
				SkillGrade = 0,
				SkillId = 700971,
				SkillLevel = 1,
			},
		},
	},
	[700972] = {
		[1] = {
			[0] = {
				BeginNodeId = 700972,
				SkillGrade = 0,
				SkillId = 700972,
				SkillLevel = 1,
			},
		},
	},
	[701001] = {
		[1] = {
			[0] = {
				BeginNodeId = 701001,
				SkillGrade = 0,
				SkillId = 701001,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[701002] = {
		[1] = {
			[0] = {
				BeginNodeId = 701002,
				SkillGrade = 0,
				SkillId = 701002,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[701003] = {
		[1] = {
			[0] = {
				BeginNodeId = 701003,
				CD = 8,
				SkillGrade = 0,
				SkillId = 701003,
				SkillLevel = 1,
			},
		},
	},
	[701011] = {
		[1] = {
			[0] = {
				BeginNodeId = 701011,
				SkillGrade = 0,
				SkillId = 701011,
				SkillLevel = 1,
			},
		},
	},
	[701071] = {
		[1] = {
			[0] = {
				BeginNodeId = 701003,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 701071,
				SkillLevel = 1,
			},
		},
	},
	[701103] = {
		[1] = {
			[0] = {
				BeginNodeId = 701103,
				SkillGrade = 0,
				SkillId = 701103,
				SkillLevel = 1,
			},
		},
	},
	[701104] = {
		[1] = {
			[0] = {
				BeginNodeId = 701104,
				SkillGrade = 0,
				SkillId = 701104,
				SkillLevel = 1,
			},
		},
	},
	[701201] = {
		[1] = {
			[0] = {
				BeginNodeId = 701201,
				SkillGrade = 0,
				SkillId = 701201,
				SkillLevel = 1,
			},
		},
	},
	[701202] = {
		[1] = {
			[0] = {
				BeginNodeId = 701202,
				SkillGrade = 0,
				SkillId = 701202,
				SkillLevel = 1,
			},
		},
	},
	[701203] = {
		[1] = {
			[0] = {
				BeginNodeId = 701203,
				BornInCd = 5,
				CD = 15,
				SkillGrade = 0,
				SkillId = 701203,
				SkillLevel = 1,
			},
		},
	},
	[701204] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					701201,
				},
				SkillGrade = 0,
				SkillId = 701204,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[701301] = {
		[1] = {
			[0] = {
				BeginNodeId = 701301,
				SkillGrade = 0,
				SkillId = 701301,
				SkillLevel = 1,
			},
		},
	},
	[701302] = {
		[1] = {
			[0] = {
				BeginNodeId = 701302,
				BornInCd = 10,
				CD = 20,
				SkillGrade = 0,
				SkillId = 701302,
				SkillLevel = 1,
			},
		},
	},
	[701401] = {
		[1] = {
			[0] = {
				BeginNodeId = 701401,
				SkillGrade = 0,
				SkillId = 701401,
				SkillLevel = 1,
			},
		},
	},
	[701402] = {
		[1] = {
			[0] = {
				BeginNodeId = 701402,
				CD = 15,
				SkillGrade = 0,
				SkillId = 701402,
				SkillLevel = 1,
			},
		},
	},
	[701501] = {
		[1] = {
			[0] = {
				BeginNodeId = 701501,
				SkillGrade = 0,
				SkillId = 701501,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[701502] = {
		[1] = {
			[0] = {
				BeginNodeId = 701502,
				CD = 15,
				SkillGrade = 0,
				SkillId = 701502,
				SkillLevel = 1,
			},
		},
	},
	[701503] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 701503,
				SkillGrade = 0,
				SkillId = 701503,
				SkillLevel = 1,
			},
		},
	},
	[701511] = {
		[1] = {
			[0] = {
				BeginNodeId = 701511,
				SkillGrade = 0,
				SkillId = 701511,
				SkillLevel = 1,
			},
		},
	},
	[701571] = {
		[1] = {
			[0] = {
				BeginNodeId = 701502,
				BornInCd = 10,
				CD = 10,
				SkillGrade = 0,
				SkillId = 701571,
				SkillLevel = 1,
			},
		},
	},
	[701572] = {
		[1] = {
			[0] = {
				BeginNodeId = 701572,
				SkillGrade = 0,
				SkillId = 701572,
				SkillLevel = 1,
			},
		},
	},
	[701601] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 701601,
				CD = 3.5,
				SkillGrade = 0,
				SkillId = 701601,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[701611] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 701611,
				SkillGrade = 0,
				SkillId = 701611,
				SkillLevel = 1,
			},
		},
	},
	[701801] = {
		[1] = {
			[0] = {
				BeginNodeId = 701801,
				SkillGrade = 0,
				SkillId = 701801,
				SkillLevel = 1,
			},
		},
	},
	[701802] = {
		[1] = {
			[0] = {
				BeginNodeId = 701802,
				SkillGrade = 0,
				SkillId = 701802,
				SkillLevel = 1,
			},
		},
	},
	[701803] = {
		[1] = {
			[0] = {
				BeginNodeId = 701803,
				SkillGrade = 0,
				SkillId = 701803,
				SkillLevel = 1,
			},
		},
	},
	[701811] = {
		[1] = {
			[0] = {
				BeginNodeId = 701811,
				SkillGrade = 0,
				SkillId = 701811,
				SkillLevel = 1,
			},
		},
	},
	[800101] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 800101,
				SkillGrade = 0,
				SkillId = 800101,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[800102] = {
		[1] = {
			[0] = {
				BeginNodeId = 800102,
				CD = 20,
				SkillGrade = 0,
				SkillId = 800102,
				SkillLevel = 1,
			},
		},
	},
	[800103] = {
		[1] = {
			[0] = {
				BeginNodeId = 800103,
				SkillGrade = 0,
				SkillId = 800103,
				SkillLevel = 1,
			},
		},
	},
	[800104] = {
		[1] = {
			[0] = {
				BeginNodeId = 800104,
				SkillGrade = 0,
				SkillId = 800104,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[800105] = {
		[1] = {
			[0] = {
				BeginNodeId = 800105,
				SkillGrade = 0,
				SkillId = 800105,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[800106] = {
		[1] = {
			[0] = {
				BeginNodeId = 800107,
				SkillGrade = 0,
				SkillId = 800106,
				SkillLevel = 1,
			},
		},
	},
	[800107] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 800108,
				SkillGrade = 0,
				SkillId = 800107,
				SkillLevel = 1,
			},
		},
	},
	[800111] = {
		[1] = {
			[0] = {
				BeginNodeId = 800106,
				SkillGrade = 0,
				SkillId = 800111,
				SkillLevel = 1,
			},
		},
	},
	[800171] = {
		[1] = {
			[0] = {
				BeginNodeId = 800102,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 800171,
				SkillLevel = 1,
			},
		},
	},
	[800172] = {
		[1] = {
			[0] = {
				BeginNodeId = 800172,
				SkillGrade = 0,
				SkillId = 800172,
				SkillLevel = 1,
			},
		},
	},
	[800201] = {
		[1] = {
			[0] = {
				BeginNodeId = 800201,
				SkillGrade = 0,
				SkillId = 800201,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[800202] = {
		[1] = {
			[0] = {
				BeginNodeId = 800202,
				SkillGrade = 0,
				SkillId = 800202,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[800203] = {
		[1] = {
			[0] = {
				BeginNodeId = 800203,
				SkillGrade = 0,
				SkillId = 800203,
				SkillLevel = 1,
			},
		},
	},
	[800204] = {
		[1] = {
			[0] = {
				BeginNodeId = 800205,
				BornInCd = 3,
				CD = 15,
				SkillGrade = 0,
				SkillId = 800204,
				SkillLevel = 1,
			},
		},
	},
	[800205] = {
		[1] = {
			[0] = {
				BeginNodeId = 800206,
				SkillGrade = 0,
				SkillId = 800205,
				SkillLevel = 1,
			},
		},
	},
	[800206] = {
		[1] = {
			[0] = {
				BeginNodeId = 800207,
				SkillGrade = 0,
				SkillId = 800206,
				SkillLevel = 1,
			},
		},
	},
	[800207] = {
		[1] = {
			[0] = {
				BeginNodeId = 800208,
				BornInCd = 3,
				CD = 15,
				SkillGrade = 0,
				SkillId = 800207,
				SkillLevel = 1,
			},
		},
	},
	[800208] = {
		[1] = {
			[0] = {
				BeginNodeId = 800209,
				SkillGrade = 0,
				SkillId = 800208,
				SkillLevel = 1,
			},
		},
	},
	[800209] = {
		[1] = {
			[0] = {
				BeginNodeId = 800210,
				SkillGrade = 0,
				SkillId = 800209,
				SkillLevel = 1,
			},
		},
	},
	[800211] = {
		[1] = {
			[0] = {
				BeginNodeId = 800204,
				SkillGrade = 0,
				SkillId = 800211,
				SkillLevel = 1,
			},
		},
	},
	[800271] = {
		[1] = {
			[0] = {
				BeginNodeId = 800203,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 800271,
				SkillLevel = 1,
			},
		},
	},
	[800272] = {
		[1] = {
			[0] = {
				BeginNodeId = 800272,
				SkillGrade = 0,
				SkillId = 800272,
				SkillLevel = 1,
			},
		},
	},
	[800301] = {
		[1] = {
			[0] = {
				BeginNodeId = 800301,
				SkillGrade = 0,
				SkillId = 800301,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[800302] = {
		[1] = {
			[0] = {
				BeginNodeId = 800302,
				SkillGrade = 0,
				SkillId = 800302,
				SkillLevel = 1,
			},
		},
	},
	[800303] = {
		[1] = {
			[0] = {
				BeginNodeId = 800303,
				CD = 15,
				SkillGrade = 0,
				SkillId = 800303,
				SkillLevel = 1,
			},
		},
	},
	[800304] = {
		[1] = {
			[0] = {
				BeginNodeId = 800304,
				CD = 10,
				SkillGrade = 0,
				SkillId = 800304,
				SkillLevel = 1,
			},
		},
	},
	[800311] = {
		[1] = {
			[0] = {
				BeginNodeId = 800305,
				SkillGrade = 0,
				SkillId = 800311,
				SkillLevel = 1,
			},
		},
	},
	[800371] = {
		[1] = {
			[0] = {
				BeginNodeId = 800304,
				BornInCd = 10,
				CD = 6,
				SkillGrade = 0,
				SkillId = 800371,
				SkillLevel = 1,
			},
		},
	},
	[800372] = {
		[1] = {
			[0] = {
				BeginNodeId = 800372,
				SkillGrade = 0,
				SkillId = 800372,
				SkillLevel = 1,
			},
		},
	},
	[850001] = {
		[1] = {
			[0] = {
				BeginNodeId = 850001,
				SkillGrade = 0,
				SkillId = 850001,
				SkillLevel = 1,
			},
		},
	},
	[850002] = {
		[1] = {
			[0] = {
				BeginNodeId = 850002,
				SkillGrade = 0,
				SkillId = 850002,
				SkillLevel = 1,
			},
		},
	},
	[850003] = {
		[1] = {
			[0] = {
				BeginNodeId = 850003,
				SkillGrade = 0,
				SkillId = 850003,
				SkillLevel = 1,
			},
		},
	},
	[850004] = {
		[1] = {
			[0] = {
				BeginNodeId = 850004,
				SkillGrade = 0,
				SkillId = 850004,
				SkillLevel = 1,
			},
		},
	},
	[850005] = {
		[1] = {
			[0] = {
				BeginNodeId = 850005,
				CD = 24,
				SkillGrade = 0,
				SkillId = 850005,
				SkillLevel = 1,
			},
		},
	},
	[850006] = {
		[1] = {
			[0] = {
				BeginNodeId = 850006,
				BornInCd = 40,
				CD = 40,
				SkillGrade = 0,
				SkillId = 850006,
				SkillLevel = 1,
			},
		},
	},
	[850007] = {
		[1] = {
			[0] = {
				BeginNodeId = 850007,
				BornInCd = 24,
				CD = 24,
				SkillGrade = 0,
				SkillId = 850007,
				SkillLevel = 1,
			},
		},
	},
	[850008] = {
		[1] = {
			[0] = {
				BeginNodeId = 850008,
				SkillGrade = 0,
				SkillId = 850008,
				SkillLevel = 1,
			},
		},
	},
	[850009] = {
		[1] = {
			[0] = {
				BeginNodeId = 850009,
				SkillGrade = 0,
				SkillId = 850009,
				SkillLevel = 1,
			},
		},
	},
	[850011] = {
		[1] = {
			[0] = {
				BeginNodeId = 850011,
				SkillGrade = 0,
				SkillId = 850011,
				SkillLevel = 1,
			},
		},
	},
	[850012] = {
		[1] = {
			[0] = {
				BeginNodeId = 850012,
				SkillGrade = 0,
				SkillId = 850012,
				SkillLevel = 1,
			},
		},
	},
	[850013] = {
		[1] = {
			[0] = {
				BeginNodeId = 850013,
				SkillGrade = 0,
				SkillId = 850013,
				SkillLevel = 1,
			},
		},
	},
	[850014] = {
		[1] = {
			[0] = {
				BeginNodeId = 850014,
				SkillGrade = 0,
				SkillId = 850014,
				SkillLevel = 1,
			},
		},
	},
	[850015] = {
		[1] = {
			[0] = {
				BeginNodeId = 850015,
				CD = 24,
				SkillGrade = 0,
				SkillId = 850015,
				SkillLevel = 1,
			},
		},
	},
	[850016] = {
		[1] = {
			[0] = {
				BeginNodeId = 850016,
				SkillGrade = 0,
				SkillId = 850016,
				SkillLevel = 1,
			},
		},
	},
	[850017] = {
		[1] = {
			[0] = {
				BeginNodeId = 850017,
				SkillGrade = 0,
				SkillId = 850017,
				SkillLevel = 1,
			},
		},
	},
	[850018] = {
		[1] = {
			[0] = {
				BeginNodeId = 850018,
				SkillGrade = 0,
				SkillId = 850018,
				SkillLevel = 1,
			},
		},
	},
	[850019] = {
		[1] = {
			[0] = {
				BeginNodeId = 850019,
				SkillGrade = 0,
				SkillId = 850019,
				SkillLevel = 1,
			},
		},
	},
	[850020] = {
		[1] = {
			[0] = {
				BeginNodeId = 850020,
				SkillGrade = 0,
				SkillId = 850020,
				SkillLevel = 1,
			},
		},
	},
	[850021] = {
		[1] = {
			[0] = {
				BeginNodeId = 850021,
				SkillGrade = 0,
				SkillId = 850021,
				SkillLevel = 1,
			},
		},
	},
	[850022] = {
		[1] = {
			[0] = {
				BeginNodeId = 850022,
				SkillGrade = 0,
				SkillId = 850022,
				SkillLevel = 1,
			},
		},
	},
	[850023] = {
		[1] = {
			[0] = {
				BeginNodeId = 850023,
				SkillGrade = 0,
				SkillId = 850023,
				SkillLevel = 1,
			},
		},
	},
	[850024] = {
		[1] = {
			[0] = {
				BeginNodeId = 850024,
				SkillGrade = 0,
				SkillId = 850024,
				SkillLevel = 1,
			},
		},
	},
	[850025] = {
		[1] = {
			[0] = {
				BeginNodeId = 850025,
				SkillGrade = 0,
				SkillId = 850025,
				SkillLevel = 1,
			},
		},
	},
	[850101] = {
		[1] = {
			[0] = {
				BeginNodeId = 850101,
				SkillGrade = 0,
				SkillId = 850101,
				SkillLevel = 1,
			},
		},
	},
	[850102] = {
		[1] = {
			[0] = {
				BeginNodeId = 850102,
				CD = 3,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850102,
				SkillLevel = 1,
			},
		},
	},
	[850103] = {
		[1] = {
			[0] = {
				BeginNodeId = 850103,
				BornInCd = 5,
				CD = 5,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850103,
				SkillLevel = 1,
			},
		},
	},
	[850104] = {
		[1] = {
			[0] = {
				BeginNodeId = 850104,
				BornInCd = 7,
				CD = 18,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850104,
				SkillLevel = 1,
			},
		},
	},
	[850105] = {
		[1] = {
			[0] = {
				BeginNodeId = 850105,
				BornInCd = 15,
				CD = 15,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850105,
				SkillLevel = 1,
			},
		},
	},
	[850107] = {
		[1] = {
			[0] = {
				BeginNodeId = 850107,
				BornInCd = 21,
				CD = 21,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850107,
				SkillLevel = 1,
			},
		},
	},
	[850110] = {
		[1] = {
			[0] = {
				BeginNodeId = 850110,
				CD = 30,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850110,
				SkillLevel = 1,
			},
		},
	},
	[850111] = {
		[1] = {
			[0] = {
				BeginNodeId = 850111,
				BornInCd = 5,
				CD = 3,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850111,
				SkillLevel = 1,
			},
		},
	},
	[850112] = {
		[1] = {
			[0] = {
				BeginNodeId = 850112,
				BornInCd = 120,
				CD = 120,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850112,
				SkillLevel = 1,
			},
		},
	},
	[850113] = {
		[1] = {
			[0] = {
				BeginNodeId = 850113,
				CD = 10,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850113,
				SkillLevel = 1,
			},
		},
	},
	[850114] = {
		[1] = {
			[0] = {
				BeginNodeId = 850114,
				SkillGrade = 0,
				SkillId = 850114,
				SkillLevel = 1,
			},
		},
	},
	[850115] = {
		[1] = {
			[0] = {
				BeginNodeId = 850115,
				CD = 300,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850115,
				SkillLevel = 1,
			},
		},
	},
	[850119] = {
		[1] = {
			[0] = {
				BeginNodeId = 850103,
				SkillGrade = 0,
				SkillId = 850119,
				SkillLevel = 1,
			},
		},
	},
	[850120] = {
		[1] = {
			[0] = {
				BeginNodeId = 850105,
				SkillGrade = 0,
				SkillId = 850120,
				SkillLevel = 1,
			},
		},
	},
	[850121] = {
		[1] = {
			[0] = {
				BeginNodeId = 850110,
				CD = 15,
				SkillGrade = 0,
				SkillId = 850121,
				SkillLevel = 1,
			},
		},
	},
	[850201] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850201,
				SkillGrade = 0,
				SkillId = 850201,
				SkillLevel = 1,
			},
		},
	},
	[850202] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850202,
				CD = 6,
				SkillGrade = 0,
				SkillId = 850202,
				SkillLevel = 1,
			},
		},
	},
	[850203] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850203,
				SkillGrade = 0,
				SkillId = 850203,
				SkillLevel = 1,
			},
		},
	},
	[850204] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850204,
				SkillGrade = 0,
				SkillId = 850204,
				SkillLevel = 1,
			},
		},
	},
	[850205] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850205,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850205,
				SkillLevel = 1,
			},
		},
	},
	[850206] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850206,
				SkillGrade = 0,
				SkillId = 850206,
				SkillLevel = 1,
			},
		},
	},
	[850207] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850207,
				SkillGrade = 0,
				SkillId = 850207,
				SkillLevel = 1,
			},
		},
	},
	[850208] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850208,
				SkillGrade = 0,
				SkillId = 850208,
				SkillLevel = 1,
			},
		},
	},
	[850209] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850209,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850209,
				SkillLevel = 1,
			},
		},
	},
	[850210] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850210,
				BornInCd = 10,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850210,
				SkillLevel = 1,
			},
		},
	},
	[850211] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850211,
				BornInCd = 8,
				CD = 8,
				SkillGrade = 0,
				SkillId = 850211,
				SkillLevel = 1,
			},
		},
	},
	[850212] = {
		[1] = {
			[0] = {
				BeginNodeId = 850212,
				SkillGrade = 0,
				SkillId = 850212,
				SkillLevel = 1,
			},
		},
	},
	[850213] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850213,
				BornInCd = 12,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850213,
				SkillLevel = 1,
			},
		},
	},
	[850214] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850214,
				SkillGrade = 0,
				SkillId = 850214,
				SkillLevel = 1,
			},
		},
	},
	[850215] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850215,
				BornInCd = 10,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850215,
				SkillLevel = 1,
			},
		},
	},
	[850216] = {
		[1] = {
			[0] = {
				BeginNodeId = 850216,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850216,
				SkillLevel = 1,
			},
		},
	},
	[850217] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850217,
				SkillGrade = 0,
				SkillId = 850217,
				SkillLevel = 1,
			},
		},
	},
	[850218] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1550,
				SkillGrade = 0,
				SkillId = 850218,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850219] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1551,
				SkillGrade = 0,
				SkillId = 850219,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850220] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850220,
				SkillGrade = 0,
				SkillId = 850220,
				SkillLevel = 1,
			},
		},
	},
	[850221] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850221,
				BornInCd = 6,
				CD = 6,
				SkillGrade = 0,
				SkillId = 850221,
				SkillLevel = 1,
			},
		},
	},
	[850222] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850222,
				SkillGrade = 0,
				SkillId = 850222,
				SkillLevel = 1,
			},
		},
	},
	[850223] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850223,
				SkillGrade = 0,
				SkillId = 850223,
				SkillLevel = 1,
			},
		},
	},
	[850224] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850224,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850224,
				SkillLevel = 1,
			},
		},
	},
	[850225] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850225,
				SkillGrade = 0,
				SkillId = 850225,
				SkillLevel = 1,
			},
		},
	},
	[850226] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850226,
				SkillGrade = 0,
				SkillId = 850226,
				SkillLevel = 1,
			},
		},
	},
	[850227] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850227,
				SkillGrade = 0,
				SkillId = 850227,
				SkillLevel = 1,
			},
		},
	},
	[850228] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850228,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850228,
				SkillLevel = 1,
			},
		},
	},
	[850229] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850229,
				BornInCd = 10,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850229,
				SkillLevel = 1,
			},
		},
	},
	[850230] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850230,
				BornInCd = 8,
				CD = 8,
				SkillGrade = 0,
				SkillId = 850230,
				SkillLevel = 1,
			},
		},
	},
	[850231] = {
		[1] = {
			[0] = {
				BeginNodeId = 850231,
				SkillGrade = 0,
				SkillId = 850231,
				SkillLevel = 1,
			},
		},
	},
	[850232] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850232,
				BornInCd = 12,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850232,
				SkillLevel = 1,
			},
		},
	},
	[850233] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850233,
				SkillGrade = 0,
				SkillId = 850233,
				SkillLevel = 1,
			},
		},
	},
	[850234] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850234,
				BornInCd = 10,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850234,
				SkillLevel = 1,
			},
		},
	},
	[850235] = {
		[1] = {
			[0] = {
				BeginNodeId = 850235,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850235,
				SkillLevel = 1,
			},
		},
	},
	[850236] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850236,
				SkillGrade = 0,
				SkillId = 850236,
				SkillLevel = 1,
			},
		},
	},
	[850237] = {
		[1] = {
			[0] = {
				BeginNodeId = 850237,
				SkillGrade = 0,
				SkillId = 850237,
				SkillLevel = 1,
			},
		},
	},
	[850238] = {
		[1] = {
			[0] = {
				BeginNodeId = 850238,
				SkillGrade = 0,
				SkillId = 850238,
				SkillLevel = 1,
			},
		},
	},
	[850239] = {
		[1] = {
			[0] = {
				BeginNodeId = 850239,
				SkillGrade = 0,
				SkillId = 850239,
				SkillLevel = 1,
			},
		},
	},
	[850240] = {
		[1] = {
			[0] = {
				BeginNodeId = 850240,
				SkillGrade = 0,
				SkillId = 850240,
				SkillLevel = 1,
			},
		},
	},
	[850241] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850241,
				SkillGrade = 0,
				SkillId = 850241,
				SkillLevel = 1,
			},
		},
	},
	[850242] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850242,
				SkillGrade = 0,
				SkillId = 850242,
				SkillLevel = 1,
			},
		},
	},
	[850243] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850243,
				SkillGrade = 0,
				SkillId = 850243,
				SkillLevel = 1,
			},
		},
	},
	[850244] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850244,
				SkillGrade = 0,
				SkillId = 850244,
				SkillLevel = 1,
			},
		},
	},
	[850245] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850245,
				SkillGrade = 0,
				SkillId = 850245,
				SkillLevel = 1,
			},
		},
	},
	[850246] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850246,
				SkillGrade = 0,
				SkillId = 850246,
				SkillLevel = 1,
			},
		},
	},
	[850247] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850247,
				BornInCd = 10,
				CD = 40,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850247,
				SkillLevel = 1,
			},
		},
	},
	[850248] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1550,
				SkillGrade = 0,
				SkillId = 850248,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850249] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1551,
				SkillGrade = 0,
				SkillId = 850249,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850301] = {
		[1] = {
			[0] = {
				BeginNodeId = 850301,
				CD = 8,
				SkillGrade = 0,
				SkillId = 850301,
				SkillLevel = 1,
			},
		},
	},
	[850302] = {
		[1] = {
			[0] = {
				BeginNodeId = 850302,
				CD = 8,
				SkillGrade = 0,
				SkillId = 850302,
				SkillLevel = 1,
			},
		},
	},
	[850303] = {
		[1] = {
			[0] = {
				BeginNodeId = 850303,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850303,
				SkillLevel = 1,
			},
		},
	},
	[850304] = {
		[1] = {
			[0] = {
				BeginNodeId = 850304,
				BornInCd = 3,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850304,
				SkillLevel = 1,
			},
		},
	},
	[850305] = {
		[1] = {
			[0] = {
				BeginNodeId = 850305,
				BornInCd = 5,
				CD = 21,
				SkillGrade = 0,
				SkillId = 850305,
				SkillLevel = 1,
			},
		},
	},
	[850306] = {
		[1] = {
			[0] = {
				BeginNodeId = 850306,
				BornInCd = 7.5,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850306,
				SkillLevel = 1,
			},
		},
	},
	[850307] = {
		[1] = {
			[0] = {
				BeginNodeId = 850307,
				SkillGrade = 0,
				SkillId = 850307,
				SkillLevel = 1,
			},
		},
	},
	[850308] = {
		[1] = {
			[0] = {
				BeginNodeId = 850308,
				BornInCd = 5,
				CD = 24,
				SkillGrade = 0,
				SkillId = 850308,
				SkillLevel = 1,
			},
		},
	},
	[850309] = {
		[1] = {
			[0] = {
				BeginNodeId = 850309,
				CD = 15,
				SkillGrade = 0,
				SkillId = 850309,
				SkillLevel = 1,
			},
		},
	},
	[850310] = {
		[1] = {
			[0] = {
				BeginNodeId = 850310,
				BornInCd = 50,
				CD = 63,
				SkillGrade = 0,
				SkillId = 850310,
				SkillLevel = 1,
			},
		},
	},
	[850311] = {
		[1] = {
			[0] = {
				BeginNodeId = 850311,
				BornInCd = 20,
				CD = 49,
				SkillGrade = 0,
				SkillId = 850311,
				SkillLevel = 1,
			},
		},
	},
	[850312] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1552,
				SkillGrade = 0,
				SkillId = 850312,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850313] = {
		[1] = {
			[0] = {
				BeginNodeId = 850313,
				BornInCd = 5,
				CD = 15,
				SkillGrade = 0,
				SkillId = 850313,
				SkillLevel = 1,
			},
		},
	},
	[850314] = {
		[1] = {
			[0] = {
				BeginNodeId = 850314,
				BornInCd = 5,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850314,
				SkillLevel = 1,
			},
		},
	},
	[850315] = {
		[1] = {
			[0] = {
				BeginNodeId = 850315,
				BornInCd = 5,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850315,
				SkillLevel = 1,
			},
		},
	},
	[850316] = {
		[1] = {
			[0] = {
				BeginNodeId = 850316,
				CD = 8,
				SkillGrade = 0,
				SkillId = 850316,
				SkillLevel = 1,
			},
		},
	},
	[850317] = {
		[1] = {
			[0] = {
				BeginNodeId = 850317,
				CD = 8,
				SkillGrade = 0,
				SkillId = 850317,
				SkillLevel = 1,
			},
		},
	},
	[850318] = {
		[1] = {
			[0] = {
				BeginNodeId = 850318,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850318,
				SkillLevel = 1,
			},
		},
	},
	[850319] = {
		[1] = {
			[0] = {
				BeginNodeId = 850319,
				BornInCd = 3,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850319,
				SkillLevel = 1,
			},
		},
	},
	[850320] = {
		[1] = {
			[0] = {
				BeginNodeId = 850320,
				BornInCd = 5,
				CD = 15,
				SkillGrade = 0,
				SkillId = 850320,
				SkillLevel = 1,
			},
		},
	},
	[850321] = {
		[1] = {
			[0] = {
				BeginNodeId = 850321,
				BornInCd = 7.5,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850321,
				SkillLevel = 1,
			},
		},
	},
	[850322] = {
		[1] = {
			[0] = {
				BeginNodeId = 850322,
				BornInCd = 5,
				CD = 16,
				SkillGrade = 0,
				SkillId = 850322,
				SkillLevel = 1,
			},
		},
	},
	[850323] = {
		[1] = {
			[0] = {
				BeginNodeId = 850323,
				CD = 15,
				SkillGrade = 0,
				SkillId = 850323,
				SkillLevel = 1,
			},
		},
	},
	[850324] = {
		[1] = {
			[0] = {
				BeginNodeId = 850324,
				BornInCd = 40,
				CD = 54,
				SkillGrade = 0,
				SkillId = 850324,
				SkillLevel = 1,
			},
		},
	},
	[850325] = {
		[1] = {
			[0] = {
				BeginNodeId = 850325,
				BornInCd = 10,
				CD = 21,
				SkillGrade = 0,
				SkillId = 850325,
				SkillLevel = 1,
			},
		},
	},
	[850326] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1552,
				SkillGrade = 0,
				SkillId = 850326,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850327] = {
		[1] = {
			[0] = {
				BeginNodeId = 850327,
				BornInCd = 5,
				CD = 15,
				SkillGrade = 0,
				SkillId = 850327,
				SkillLevel = 1,
			},
		},
	},
	[850328] = {
		[1] = {
			[0] = {
				BeginNodeId = 850328,
				BornInCd = 5,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850328,
				SkillLevel = 1,
			},
		},
	},
	[850329] = {
		[1] = {
			[0] = {
				BeginNodeId = 850329,
				BornInCd = 5,
				CD = 12,
				SkillGrade = 0,
				SkillId = 850329,
				SkillLevel = 1,
			},
		},
	},
	[850330] = {
		[1] = {
			[0] = {
				BeginNodeId = 850330,
				BornInCd = 10,
				CD = 25,
				SkillGrade = 0,
				SkillId = 850330,
				SkillLevel = 1,
			},
		},
	},
	[850331] = {
		[1] = {
			[0] = {
				BeginNodeId = 850331,
				CD = 48,
				SkillGrade = 0,
				SkillId = 850331,
				SkillLevel = 1,
			},
		},
	},
	[850332] = {
		[1] = {
			[0] = {
				BeginNodeId = 850332,
				SkillGrade = 0,
				SkillId = 850332,
				SkillLevel = 1,
			},
		},
	},
	[850333] = {
		[1] = {
			[0] = {
				BeginNodeId = 850333,
				SkillGrade = 0,
				SkillId = 850333,
				SkillLevel = 1,
			},
		},
	},
	[850334] = {
		[1] = {
			[0] = {
				BeginNodeId = 850334,
				SkillGrade = 0,
				SkillId = 850334,
				SkillLevel = 1,
			},
		},
	},
	[850335] = {
		[1] = {
			[0] = {
				BeginNodeId = 850335,
				CD = 3,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850335,
				SkillLevel = 1,
			},
		},
	},
	[850401] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850401,
				SkillGrade = 0,
				SkillId = 850401,
				SkillLevel = 1,
			},
		},
	},
	[850402] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850402,
				BornInCd = 10,
				SkillGrade = 0,
				SkillId = 850402,
				SkillLevel = 1,
			},
		},
	},
	[850403] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850403,
				BornInCd = 10,
				SkillGrade = 0,
				SkillId = 850403,
				SkillLevel = 1,
			},
		},
	},
	[850404] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850404,
				SkillGrade = 0,
				SkillId = 850404,
				SkillLevel = 1,
			},
		},
	},
	[850405] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850405,
				SkillGrade = 0,
				SkillId = 850405,
				SkillLevel = 1,
			},
		},
	},
	[850406] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850406,
				SkillGrade = 0,
				SkillId = 850406,
				SkillLevel = 1,
			},
		},
	},
	[850407] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850407,
				SkillGrade = 0,
				SkillId = 850407,
				SkillLevel = 1,
			},
		},
	},
	[850408] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850408,
				SkillGrade = 0,
				SkillId = 850408,
				SkillLevel = 1,
			},
		},
	},
	[850409] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850409,
				SkillGrade = 0,
				SkillId = 850409,
				SkillLevel = 1,
			},
		},
	},
	[850410] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850410,
				SkillGrade = 0,
				SkillId = 850410,
				SkillLevel = 1,
			},
		},
	},
	[850411] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850411,
				SkillGrade = 0,
				SkillId = 850411,
				SkillLevel = 1,
			},
		},
	},
	[850412] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850412,
				CD = 6,
				SkillGrade = 0,
				SkillId = 850412,
				SkillLevel = 1,
			},
		},
	},
	[850413] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850413,
				SkillGrade = 0,
				SkillId = 850413,
				SkillLevel = 1,
			},
		},
	},
	[850414] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850414,
				SkillGrade = 0,
				SkillId = 850414,
				SkillLevel = 1,
			},
		},
	},
	[850415] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850415,
				BornInCd = 10,
				SkillGrade = 0,
				SkillId = 850415,
				SkillLevel = 1,
			},
		},
	},
	[850416] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850416,
				SkillGrade = 0,
				SkillId = 850416,
				SkillLevel = 1,
			},
		},
	},
	[850417] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850417,
				SkillGrade = 0,
				SkillId = 850417,
				SkillLevel = 1,
			},
		},
	},
	[850418] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850418,
				SkillGrade = 0,
				SkillId = 850418,
				SkillLevel = 1,
			},
		},
	},
	[850419] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850419,
				SkillGrade = 0,
				SkillId = 850419,
				SkillLevel = 1,
			},
		},
	},
	[850420] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850420,
				BornInCd = 10,
				SkillGrade = 0,
				SkillId = 850420,
				SkillLevel = 1,
			},
		},
	},
	[850421] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850421,
				SkillGrade = 0,
				SkillId = 850421,
				SkillLevel = 1,
			},
		},
	},
	[850422] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850422,
				SkillGrade = 0,
				SkillId = 850422,
				SkillLevel = 1,
			},
		},
	},
	[850423] = {
		[1] = {
			[0] = {
				BeginNodeId = 850423,
				SkillGrade = 0,
				SkillId = 850423,
				SkillLevel = 1,
			},
		},
	},
	[850424] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850424,
				SkillGrade = 0,
				SkillId = 850424,
				SkillLevel = 1,
			},
		},
	},
	[850425] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850425,
				SkillGrade = 0,
				SkillId = 850425,
				SkillLevel = 1,
			},
		},
	},
	[850426] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850426,
				SkillGrade = 0,
				SkillId = 850426,
				SkillLevel = 1,
			},
		},
	},
	[850427] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850427,
				SkillGrade = 0,
				SkillId = 850427,
				SkillLevel = 1,
			},
		},
	},
	[850428] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850428,
				SkillGrade = 0,
				SkillId = 850428,
				SkillLevel = 1,
			},
		},
	},
	[850429] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850429,
				SkillGrade = 0,
				SkillId = 850429,
				SkillLevel = 1,
			},
		},
	},
	[850430] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850430,
				SkillGrade = 0,
				SkillId = 850430,
				SkillLevel = 1,
			},
		},
	},
	[850431] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					850402,
				},
				SkillGrade = 0,
				SkillId = 850431,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850432] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					850401,
				},
				SkillGrade = 0,
				SkillId = 850432,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850501] = {
		[1] = {
			[0] = {
				BeginNodeId = 850501,
				SkillGrade = 0,
				SkillId = 850501,
				SkillLevel = 1,
			},
		},
	},
	[850502] = {
		[1] = {
			[0] = {
				BeginNodeId = 850502,
				CD = 15,
				SkillGrade = 0,
				SkillId = 850502,
				SkillLevel = 1,
			},
		},
	},
	[850503] = {
		[1] = {
			[0] = {
				BeginNodeId = 850503,
				CD = 40,
				SkillGrade = 0,
				SkillId = 850503,
				SkillLevel = 1,
			},
		},
	},
	[850504] = {
		[1] = {
			[0] = {
				BeginNodeId = 850504,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850504,
				SkillLevel = 1,
			},
		},
	},
	[850505] = {
		[1] = {
			[0] = {
				BeginNodeId = 850505,
				CD = 5,
				SkillGrade = 0,
				SkillId = 850505,
				SkillLevel = 1,
			},
		},
	},
	[850506] = {
		[1] = {
			[0] = {
				BeginNodeId = 850506,
				CD = 15,
				SkillGrade = 0,
				SkillId = 850506,
				SkillLevel = 1,
			},
		},
	},
	[850507] = {
		[1] = {
			[0] = {
				BeginNodeId = 850507,
				CD = 40,
				SkillGrade = 0,
				SkillId = 850507,
				SkillLevel = 1,
			},
		},
	},
	[850508] = {
		[1] = {
			[0] = {
				BeginNodeId = 850508,
				BornInCd = 5,
				CD = 300,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850508,
				SkillLevel = 1,
			},
		},
	},
	[850509] = {
		[1] = {
			[0] = {
				BeginNodeId = 850509,
				SkillGrade = 0,
				SkillId = 850509,
				SkillLevel = 1,
			},
		},
	},
	[850510] = {
		[1] = {
			[0] = {
				BeginNodeId = 850510,
				SkillGrade = 0,
				SkillId = 850510,
				SkillLevel = 1,
			},
		},
	},
	[850511] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850511,
				SkillGrade = 0,
				SkillId = 850511,
				SkillLevel = 1,
			},
		},
	},
	[850512] = {
		[1] = {
			[0] = {
				BeginNodeId = 850512,
				SkillGrade = 0,
				SkillId = 850512,
				SkillLevel = 1,
			},
		},
	},
	[850513] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1553,
				SkillGrade = 0,
				SkillId = 850513,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850521] = {
		[1] = {
			[0] = {
				BeginNodeId = 850521,
				SkillGrade = 0,
				SkillId = 850521,
				SkillLevel = 1,
			},
		},
	},
	[850522] = {
		[1] = {
			[0] = {
				BeginNodeId = 850522,
				CD = 20,
				SkillGrade = 0,
				SkillId = 850522,
				SkillLevel = 1,
			},
		},
	},
	[850523] = {
		[1] = {
			[0] = {
				BeginNodeId = 850523,
				CD = 40,
				SkillGrade = 0,
				SkillId = 850523,
				SkillLevel = 1,
			},
		},
	},
	[850524] = {
		[1] = {
			[0] = {
				BeginNodeId = 850524,
				CD = 10,
				SkillGrade = 0,
				SkillId = 850524,
				SkillLevel = 1,
			},
		},
	},
	[850525] = {
		[1] = {
			[0] = {
				BeginNodeId = 850525,
				CD = 5,
				SkillGrade = 0,
				SkillId = 850525,
				SkillLevel = 1,
			},
		},
	},
	[850526] = {
		[1] = {
			[0] = {
				BeginNodeId = 850526,
				CD = 15,
				SkillGrade = 0,
				SkillId = 850526,
				SkillLevel = 1,
			},
		},
	},
	[850527] = {
		[1] = {
			[0] = {
				BeginNodeId = 850527,
				CD = 40,
				SkillGrade = 0,
				SkillId = 850527,
				SkillLevel = 1,
			},
		},
	},
	[850528] = {
		[1] = {
			[0] = {
				BeginNodeId = 850528,
				BornInCd = 5,
				CD = 60,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 850528,
				SkillLevel = 1,
			},
		},
	},
	[850529] = {
		[1] = {
			[0] = {
				BeginNodeId = 850529,
				SkillGrade = 0,
				SkillId = 850529,
				SkillLevel = 1,
			},
		},
	},
	[850530] = {
		[1] = {
			[0] = {
				BeginNodeId = 850530,
				SkillGrade = 0,
				SkillId = 850530,
				SkillLevel = 1,
			},
		},
	},
	[850531] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 850531,
				SkillGrade = 0,
				SkillId = 850531,
				SkillLevel = 1,
			},
		},
	},
	[850532] = {
		[1] = {
			[0] = {
				BeginNodeId = 850532,
				SkillGrade = 0,
				SkillId = 850532,
				SkillLevel = 1,
			},
		},
	},
	[850533] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1553,
				SkillGrade = 0,
				SkillId = 850533,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850601] = {
		[1] = {
			[0] = {
				BeginNodeId = 850601,
				SkillGrade = 0,
				SkillId = 850601,
				SkillLevel = 1,
			},
		},
	},
	[850602] = {
		[1] = {
			[0] = {
				BeginNodeId = 850602,
				SkillGrade = 0,
				SkillId = 850602,
				SkillLevel = 1,
			},
		},
	},
	[850603] = {
		[1] = {
			[0] = {
				BeginNodeId = 850603,
				SkillGrade = 0,
				SkillId = 850603,
				SkillLevel = 1,
			},
		},
	},
	[850604] = {
		[1] = {
			[0] = {
				BeginNodeId = 850604,
				SkillGrade = 0,
				SkillId = 850604,
				SkillLevel = 1,
			},
		},
	},
	[850605] = {
		[1] = {
			[0] = {
				BeginNodeId = 850605,
				SkillGrade = 0,
				SkillId = 850605,
				SkillLevel = 1,
			},
		},
	},
	[850606] = {
		[1] = {
			[0] = {
				BeginNodeId = 850606,
				SkillGrade = 0,
				SkillId = 850606,
				SkillLevel = 1,
			},
		},
	},
	[850607] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1554,
				SkillGrade = 0,
				SkillId = 850607,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850701] = {
		[1] = {
			[0] = {
				BeginNodeId = 850701,
				SkillGrade = 0,
				SkillId = 850701,
				SkillLevel = 1,
			},
		},
	},
	[850702] = {
		[1] = {
			[0] = {
				BeginNodeId = 850702,
				SkillGrade = 0,
				SkillId = 850702,
				SkillLevel = 1,
			},
		},
	},
	[850703] = {
		[1] = {
			[0] = {
				BeginNodeId = 850703,
				SkillGrade = 0,
				SkillId = 850703,
				SkillLevel = 1,
			},
		},
	},
	[850704] = {
		[1] = {
			[0] = {
				BeginNodeId = 850704,
				SkillGrade = 0,
				SkillId = 850704,
				SkillLevel = 1,
			},
		},
	},
	[850705] = {
		[1] = {
			[0] = {
				BeginNodeId = 850705,
				SkillGrade = 0,
				SkillId = 850705,
				SkillLevel = 1,
			},
		},
	},
	[850706] = {
		[1] = {
			[0] = {
				BeginNodeId = 850706,
				SkillGrade = 0,
				SkillId = 850706,
				SkillLevel = 1,
			},
		},
	},
	[850707] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1554,
				SkillGrade = 0,
				SkillId = 850707,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[850904] = {
		[1] = {
			[0] = {
				BeginNodeId = 850904,
				SkillGrade = 0,
				SkillId = 850904,
				SkillLevel = 1,
			},
		},
	},
	[850911] = {
		[1] = {
			[0] = {
				BeginNodeId = 850911,
				SkillGrade = 0,
				SkillId = 850911,
				SkillLevel = 1,
			},
		},
	},
	[850912] = {
		[1] = {
			[0] = {
				BeginNodeId = 850912,
				SkillGrade = 0,
				SkillId = 850912,
				SkillLevel = 1,
			},
		},
	},
	[850913] = {
		[1] = {
			[0] = {
				BeginNodeId = 850913,
				SkillGrade = 0,
				SkillId = 850913,
				SkillLevel = 1,
			},
		},
	},
	[850914] = {
		[1] = {
			[0] = {
				BeginNodeId = 850914,
				SkillGrade = 0,
				SkillId = 850914,
				SkillLevel = 1,
			},
		},
	},
	[850915] = {
		[1] = {
			[0] = {
				BeginNodeId = 850915,
				SkillGrade = 0,
				SkillId = 850915,
				SkillLevel = 1,
			},
		},
	},
	[850916] = {
		[1] = {
			[0] = {
				BeginNodeId = 850916,
				SkillGrade = 0,
				SkillId = 850916,
				SkillLevel = 1,
			},
		},
	},
	[850917] = {
		[1] = {
			[0] = {
				BeginNodeId = 850917,
				BornInCd = 25,
				SkillGrade = 0,
				SkillId = 850917,
				SkillLevel = 1,
			},
		},
	},
	[850918] = {
		[1] = {
			[0] = {
				BeginNodeId = 850918,
				SkillGrade = 0,
				SkillId = 850918,
				SkillLevel = 1,
			},
		},
	},
	[850919] = {
		[1] = {
			[0] = {
				BeginNodeId = 850919,
				SkillGrade = 0,
				SkillId = 850919,
				SkillLevel = 1,
			},
		},
	},
	[850920] = {
		[1] = {
			[0] = {
				BeginNodeId = 850920,
				SkillGrade = 0,
				SkillId = 850920,
				SkillLevel = 1,
			},
		},
	},
	[851001] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851001,
				BornInCd = 10,
				CD = 25,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 851001,
				SkillLevel = 1,
			},
		},
	},
	[851002] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851002,
				CD = 4,
				SkillGrade = 0,
				SkillId = 851002,
				SkillLevel = 1,
			},
		},
	},
	[851003] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851003,
				CD = 4,
				SkillGrade = 0,
				SkillId = 851003,
				SkillLevel = 1,
			},
		},
	},
	[851004] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851004,
				BornInCd = 10,
				CD = 30,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 851004,
				SkillLevel = 1,
			},
		},
	},
	[851005] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851005,
				BornInCd = 10,
				CD = 60,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 851005,
				SkillLevel = 1,
			},
		},
	},
	[851006] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851006,
				BornInCd = 10,
				CD = 25,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 851006,
				SkillLevel = 1,
			},
		},
	},
	[851007] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851007,
				BornInCd = 10,
				SkillGrade = 0,
				SkillId = 851007,
				SkillLevel = 1,
			},
		},
	},
	[851008] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851008,
				SkillGrade = 0,
				SkillId = 851008,
				SkillLevel = 1,
			},
		},
	},
	[851009] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851009,
				SkillGrade = 0,
				SkillId = 851009,
				SkillLevel = 1,
			},
		},
	},
	[851010] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851010,
				BornInCd = 10,
				CD = 25,
				SkillGrade = 0,
				SkillId = 851010,
				SkillLevel = 1,
			},
		},
	},
	[851011] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851001,
				SkillGrade = 0,
				SkillId = 851011,
				SkillLevel = 1,
			},
		},
	},
	[851012] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851011,
				BornInCd = 10,
				CD = 25,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 851012,
				SkillLevel = 1,
			},
		},
	},
	[851013] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851012,
				SkillGrade = 0,
				SkillId = 851013,
				SkillLevel = 1,
			},
		},
	},
	[851014] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851013,
				BornInCd = 10,
				CD = 30,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 851014,
				SkillLevel = 1,
			},
		},
	},
	[851015] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851014,
				BornInCd = 10,
				SkillGrade = 0,
				SkillId = 851015,
				SkillLevel = 1,
			},
		},
	},
	[851016] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851015,
				BornInCd = 10,
				CD = 30,
				SkillGrade = 0,
				SkillId = 851016,
				SkillLevel = 1,
			},
		},
	},
	[851017] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851016,
				BornInCd = 10,
				CD = 25,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 851017,
				SkillLevel = 1,
			},
		},
	},
	[851018] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851017,
				CD = 4,
				SkillGrade = 0,
				SkillId = 851018,
				SkillLevel = 1,
			},
		},
	},
	[851019] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851018,
				CD = 4,
				SkillGrade = 0,
				SkillId = 851019,
				SkillLevel = 1,
			},
		},
	},
	[851101] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851101,
				SkillGrade = 0,
				SkillId = 851101,
				SkillLevel = 1,
			},
		},
	},
	[851102] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851102,
				CD = 2,
				SkillGrade = 0,
				SkillId = 851102,
				SkillLevel = 1,
			},
		},
	},
	[851103] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851103,
				CD = 2,
				SkillGrade = 0,
				SkillId = 851103,
				SkillLevel = 1,
			},
		},
	},
	[851104] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851104,
				SkillGrade = 0,
				SkillId = 851104,
				SkillLevel = 1,
			},
		},
	},
	[851105] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851105,
				SkillGrade = 0,
				SkillId = 851105,
				SkillLevel = 1,
			},
		},
	},
	[851106] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851106,
				SkillGrade = 0,
				SkillId = 851106,
				SkillLevel = 1,
			},
		},
	},
	[851107] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851107,
				SkillGrade = 0,
				SkillId = 851107,
				SkillLevel = 1,
			},
		},
	},
	[851108] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851108,
				SkillGrade = 0,
				SkillId = 851108,
				SkillLevel = 1,
			},
		},
	},
	[851109] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851109,
				SkillGrade = 0,
				SkillId = 851109,
				SkillLevel = 1,
			},
		},
	},
	[851110] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851110,
				SkillGrade = 0,
				SkillId = 851110,
				SkillLevel = 1,
			},
		},
	},
	[851111] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851111,
				SkillGrade = 0,
				SkillId = 851111,
				SkillLevel = 1,
			},
		},
	},
	[851201] = {
		[1] = {
			[0] = {
				BeginNodeId = 851201,
				SkillGrade = 0,
				SkillId = 851201,
				SkillLevel = 1,
			},
		},
	},
	[851202] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851202,
				SkillGrade = 0,
				SkillId = 851202,
				SkillLevel = 1,
			},
		},
	},
	[851203] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851203,
				SkillGrade = 0,
				SkillId = 851203,
				SkillLevel = 1,
			},
		},
	},
	[851204] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851204,
				SkillGrade = 0,
				SkillId = 851204,
				SkillLevel = 1,
			},
		},
	},
	[851205] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851205,
				SkillGrade = 0,
				SkillId = 851205,
				SkillLevel = 1,
			},
		},
	},
	[851206] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851206,
				SkillGrade = 0,
				SkillId = 851206,
				SkillLevel = 1,
			},
		},
	},
	[851207] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851207,
				SkillGrade = 0,
				SkillId = 851207,
				SkillLevel = 1,
			},
		},
	},
	[851208] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851208,
				SkillGrade = 0,
				SkillId = 851208,
				SkillLevel = 1,
			},
		},
	},
	[851209] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851209,
				SkillGrade = 0,
				SkillId = 851209,
				SkillLevel = 1,
			},
		},
	},
	[851210] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851210,
				SkillGrade = 0,
				SkillId = 851210,
				SkillLevel = 1,
			},
		},
	},
	[851211] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851211,
				SkillGrade = 0,
				SkillId = 851211,
				SkillLevel = 1,
			},
		},
	},
	[851221] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1555,
				SkillGrade = 0,
				SkillId = 851221,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[851222] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851222,
				SkillGrade = 0,
				SkillId = 851222,
				SkillLevel = 1,
			},
		},
	},
	[851223] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851223,
				SkillGrade = 0,
				SkillId = 851223,
				SkillLevel = 1,
			},
		},
	},
	[851224] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851224,
				SkillGrade = 0,
				SkillId = 851224,
				SkillLevel = 1,
			},
		},
	},
	[851225] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851225,
				SkillGrade = 0,
				SkillId = 851225,
				SkillLevel = 1,
			},
		},
	},
	[851226] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851226,
				SkillGrade = 0,
				SkillId = 851226,
				SkillLevel = 1,
			},
		},
	},
	[851227] = {
		[1] = {
			[0] = {
				BeginNodeId = 851227,
				SkillGrade = 0,
				SkillId = 851227,
				SkillLevel = 1,
			},
		},
	},
	[851228] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851228,
				SkillGrade = 0,
				SkillId = 851228,
				SkillLevel = 1,
			},
		},
	},
	[851229] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851229,
				SkillGrade = 0,
				SkillId = 851229,
				SkillLevel = 1,
			},
		},
	},
	[851230] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851230,
				SkillGrade = 0,
				SkillId = 851230,
				SkillLevel = 1,
			},
		},
	},
	[851231] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851231,
				SkillGrade = 0,
				SkillId = 851231,
				SkillLevel = 1,
			},
		},
	},
	[851251] = {
		[1] = {
			[0] = {
				BeginNodeId = 851251,
				SkillGrade = 0,
				SkillId = 851251,
				SkillLevel = 1,
			},
		},
	},
	[851252] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851252,
				SkillGrade = 0,
				SkillId = 851252,
				SkillLevel = 1,
			},
		},
	},
	[851253] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851253,
				SkillGrade = 0,
				SkillId = 851253,
				SkillLevel = 1,
			},
		},
	},
	[851254] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851254,
				SkillGrade = 0,
				SkillId = 851254,
				SkillLevel = 1,
			},
		},
	},
	[851255] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851255,
				SkillGrade = 0,
				SkillId = 851255,
				SkillLevel = 1,
			},
		},
	},
	[851256] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851256,
				SkillGrade = 0,
				SkillId = 851256,
				SkillLevel = 1,
			},
		},
	},
	[851257] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851257,
				SkillGrade = 0,
				SkillId = 851257,
				SkillLevel = 1,
			},
		},
	},
	[851258] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851258,
				SkillGrade = 0,
				SkillId = 851258,
				SkillLevel = 1,
			},
		},
	},
	[851259] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851259,
				SkillGrade = 0,
				SkillId = 851259,
				SkillLevel = 1,
			},
		},
	},
	[851260] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851260,
				SkillGrade = 0,
				SkillId = 851260,
				SkillLevel = 1,
			},
		},
	},
	[851261] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851261,
				SkillGrade = 0,
				SkillId = 851261,
				SkillLevel = 1,
			},
		},
	},
	[851271] = {
		[1] = {
			[0] = {
				PassiveEffects = T.RT_1555,
				SkillGrade = 0,
				SkillId = 851271,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[851272] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851272,
				SkillGrade = 0,
				SkillId = 851272,
				SkillLevel = 1,
			},
		},
	},
	[851273] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851273,
				SkillGrade = 0,
				SkillId = 851273,
				SkillLevel = 1,
			},
		},
	},
	[851274] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851274,
				SkillGrade = 0,
				SkillId = 851274,
				SkillLevel = 1,
			},
		},
	},
	[851275] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851275,
				SkillGrade = 0,
				SkillId = 851275,
				SkillLevel = 1,
			},
		},
	},
	[851301] = {
		[1] = {
			[0] = {
				BeginNodeId = 851301,
				SkillGrade = 0,
				SkillId = 851301,
				SkillLevel = 1,
			},
		},
	},
	[851302] = {
		[1] = {
			[0] = {
				BeginNodeId = 851302,
				SkillGrade = 0,
				SkillId = 851302,
				SkillLevel = 1,
			},
		},
	},
	[851303] = {
		[1] = {
			[0] = {
				BeginNodeId = 851303,
				SkillGrade = 0,
				SkillId = 851303,
				SkillLevel = 1,
			},
		},
	},
	[851304] = {
		[1] = {
			[0] = {
				BeginNodeId = 851304,
				SkillGrade = 0,
				SkillId = 851304,
				SkillLevel = 1,
			},
		},
	},
	[851305] = {
		[1] = {
			[0] = {
				BeginNodeId = 851305,
				SkillGrade = 0,
				SkillId = 851305,
				SkillLevel = 1,
			},
		},
	},
	[851306] = {
		[1] = {
			[0] = {
				BeginNodeId = 851306,
				BornInCd = 8,
				CD = 50,
				SkillGrade = 0,
				SkillId = 851306,
				SkillLevel = 1,
			},
		},
	},
	[851307] = {
		[1] = {
			[0] = {
				BeginNodeId = 851307,
				BornInCd = 30,
				CD = 50,
				SkillGrade = 0,
				SkillId = 851307,
				SkillLevel = 1,
			},
		},
	},
	[851401] = {
		[1] = {
			[0] = {
				BeginNodeId = 851401,
				SkillGrade = 0,
				SkillId = 851401,
				SkillLevel = 1,
			},
		},
	},
	[851402] = {
		[1] = {
			[0] = {
				BeginNodeId = 851402,
				BornInCd = 15,
				SkillGrade = 0,
				SkillId = 851402,
				SkillLevel = 1,
			},
		},
	},
	[851403] = {
		[1] = {
			[0] = {
				BeginNodeId = 851403,
				BornInCd = 2,
				SkillGrade = 0,
				SkillId = 851403,
				SkillLevel = 1,
			},
		},
	},
	[851404] = {
		[1] = {
			[0] = {
				BeginNodeId = 851404,
				BornInCd = 4,
				SkillGrade = 0,
				SkillId = 851404,
				SkillLevel = 1,
			},
		},
	},
	[851405] = {
		[1] = {
			[0] = {
				BeginNodeId = 851405,
				BornInCd = 30,
				SkillGrade = 0,
				SkillId = 851405,
				SkillLevel = 1,
			},
		},
	},
	[851406] = {
		[1] = {
			[0] = {
				BeginNodeId = 851406,
				SkillGrade = 0,
				SkillId = 851406,
				SkillLevel = 1,
			},
		},
	},
	[851407] = {
		[1] = {
			[0] = {
				BeginNodeId = 851407,
				SkillGrade = 0,
				SkillId = 851407,
				SkillLevel = 1,
			},
		},
	},
	[851408] = {
		[1] = {
			[0] = {
				BeginNodeId = 851408,
				SkillGrade = 0,
				SkillId = 851408,
				SkillLevel = 1,
			},
		},
	},
	[851409] = {
		[1] = {
			[0] = {
				BeginNodeId = 851409,
				SkillGrade = 0,
				SkillId = 851409,
				SkillLevel = 1,
			},
		},
	},
	[851410] = {
		[1] = {
			[0] = {
				BeginNodeId = 851402,
				SkillGrade = 0,
				SkillId = 851410,
				SkillLevel = 1,
			},
		},
	},
	[851411] = {
		[1] = {
			[0] = {
				BeginNodeId = 851404,
				SkillGrade = 0,
				SkillId = 851411,
				SkillLevel = 1,
			},
		},
	},
	[851501] = {
		[1] = {
			[0] = {
				BeginNodeId = 851501,
				SkillGrade = 0,
				SkillId = 851501,
				SkillLevel = 1,
			},
		},
	},
	[851502] = {
		[1] = {
			[0] = {
				BeginNodeId = 851502,
				SkillGrade = 0,
				SkillId = 851502,
				SkillLevel = 1,
			},
		},
	},
	[851503] = {
		[1] = {
			[0] = {
				BeginNodeId = 851503,
				BornInCd = 5,
				SkillGrade = 0,
				SkillId = 851503,
				SkillLevel = 1,
			},
		},
	},
	[851504] = {
		[1] = {
			[0] = {
				BeginNodeId = 851504,
				SkillGrade = 0,
				SkillId = 851504,
				SkillLevel = 1,
			},
		},
	},
	[851505] = {
		[1] = {
			[0] = {
				BeginNodeId = 851505,
				SkillGrade = 0,
				SkillId = 851505,
				SkillLevel = 1,
			},
		},
	},
	[851506] = {
		[1] = {
			[0] = {
				BeginNodeId = 851506,
				BornInCd = 8,
				SkillGrade = 0,
				SkillId = 851506,
				SkillLevel = 1,
			},
		},
	},
	[851507] = {
		[1] = {
			[0] = {
				BeginNodeId = 851507,
				BornInCd = 5,
				SkillGrade = 0,
				SkillId = 851507,
				SkillLevel = 1,
			},
		},
	},
	[851508] = {
		[1] = {
			[0] = {
				BeginNodeId = 851508,
				BornInCd = 5,
				SkillGrade = 0,
				SkillId = 851508,
				SkillLevel = 1,
			},
		},
	},
	[851509] = {
		[1] = {
			[0] = {
				BeginNodeId = 851509,
				BornInCd = 5,
				SkillGrade = 0,
				SkillId = 851509,
				SkillLevel = 1,
			},
		},
	},
	[851510] = {
		[1] = {
			[0] = {
				BeginNodeId = 851510,
				SkillGrade = 0,
				SkillId = 851510,
				SkillLevel = 1,
			},
		},
	},
	[851511] = {
		[1] = {
			[0] = {
				BeginNodeId = 851511,
				SkillGrade = 0,
				SkillId = 851511,
				SkillLevel = 1,
			},
		},
	},
	[851601] = {
		[1] = {
			[0] = {
				BeginNodeId = 851601,
				SkillGrade = 0,
				SkillId = 851601,
				SkillLevel = 1,
			},
		},
	},
	[851602] = {
		[1] = {
			[0] = {
				BeginNodeId = 851602,
				SkillGrade = 0,
				SkillId = 851602,
				SkillLevel = 1,
			},
		},
	},
	[851603] = {
		[1] = {
			[0] = {
				BeginNodeId = 851603,
				SkillGrade = 0,
				SkillId = 851603,
				SkillLevel = 1,
			},
		},
	},
	[851604] = {
		[1] = {
			[0] = {
				BeginNodeId = 851604,
				SkillGrade = 0,
				SkillId = 851604,
				SkillLevel = 1,
			},
		},
	},
	[851605] = {
		[1] = {
			[0] = {
				BeginNodeId = 851605,
				SkillGrade = 0,
				SkillId = 851605,
				SkillLevel = 1,
			},
		},
	},
	[851606] = {
		[1] = {
			[0] = {
				BeginNodeId = 851606,
				SkillGrade = 0,
				SkillId = 851606,
				SkillLevel = 1,
			},
		},
	},
	[851607] = {
		[1] = {
			[0] = {
				BeginNodeId = 851607,
				SkillGrade = 0,
				SkillId = 851607,
				SkillLevel = 1,
			},
		},
	},
	[851608] = {
		[1] = {
			[0] = {
				BeginNodeId = 851608,
				SkillGrade = 0,
				SkillId = 851608,
				SkillLevel = 1,
			},
		},
	},
	[851609] = {
		[1] = {
			[0] = {
				BeginNodeId = 851609,
				SkillGrade = 0,
				SkillId = 851609,
				SkillLevel = 1,
			},
		},
	},
	[851701] = {
		[1] = {
			[0] = {
				BeginNodeId = 851701,
				SkillGrade = 0,
				SkillId = 851701,
				SkillLevel = 1,
			},
		},
	},
	[851702] = {
		[1] = {
			[0] = {
				BeginNodeId = 851702,
				SkillGrade = 0,
				SkillId = 851702,
				SkillLevel = 1,
			},
		},
	},
	[851703] = {
		[1] = {
			[0] = {
				BeginNodeId = 851703,
				SkillGrade = 0,
				SkillId = 851703,
				SkillLevel = 1,
			},
		},
	},
	[851704] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851704,
				BornInCd = 5,
				CD = 20,
				SkillGrade = 0,
				SkillId = 851704,
				SkillLevel = 1,
			},
		},
	},
	[851705] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851705,
				BornInCd = 5,
				CD = 15,
				SkillGrade = 0,
				SkillId = 851705,
				SkillLevel = 1,
			},
		},
	},
	[851706] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851706,
				SkillGrade = 0,
				SkillId = 851706,
				SkillLevel = 1,
			},
		},
	},
	[851707] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851707,
				SkillGrade = 0,
				SkillId = 851707,
				SkillLevel = 1,
			},
		},
	},
	[851708] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851708,
				SkillGrade = 0,
				SkillId = 851708,
				SkillLevel = 1,
			},
		},
	},
	[851801] = {
		[1] = {
			[0] = {
				BeginNodeId = 851801,
				SkillGrade = 0,
				SkillId = 851801,
				SkillLevel = 1,
			},
		},
	},
	[851802] = {
		[1] = {
			[0] = {
				BeginNodeId = 851802,
				BornInCd = 5,
				CD = 20,
				SkillGrade = 0,
				SkillId = 851802,
				SkillLevel = 1,
			},
		},
	},
	[851803] = {
		[1] = {
			[0] = {
				BeginNodeId = 851803,
				CD = 10,
				SkillGrade = 0,
				SkillId = 851803,
				SkillLevel = 1,
			},
		},
	},
	[851804] = {
		[1] = {
			[0] = {
				BeginNodeId = 851804,
				CD = 10,
				SkillGrade = 0,
				SkillId = 851804,
				SkillLevel = 1,
			},
		},
	},
	[851805] = {
		[1] = {
			[0] = {
				BeginNodeId = 851805,
				CD = 5,
				SkillGrade = 0,
				SkillId = 851805,
				SkillLevel = 1,
			},
		},
	},
	[851806] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851806,
				BornInCd = 5,
				CD = 10,
				SkillGrade = 0,
				SkillId = 851806,
				SkillLevel = 1,
			},
		},
	},
	[851807] = {
		[1] = {
			[0] = {
				BeginNodeId = 851807,
				BornInCd = 10,
				CD = 10,
				SkillGrade = 0,
				SkillId = 851807,
				SkillLevel = 1,
			},
		},
	},
	[851808] = {
		[1] = {
			[0] = {
				BeginNodeId = 851808,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 851808,
				SkillLevel = 1,
			},
		},
	},
	[851809] = {
		[1] = {
			[0] = {
				BeginNodeId = 851809,
				CD = 5,
				SkillGrade = 0,
				SkillId = 851809,
				SkillLevel = 1,
			},
		},
	},
	[851810] = {
		[1] = {
			[0] = {
				BeginNodeId = 851810,
				CD = 5,
				SkillGrade = 0,
				SkillId = 851810,
				SkillLevel = 1,
			},
		},
	},
	[851811] = {
		[1] = {
			[0] = {
				BeginNodeId = 851811,
				CD = 20,
				SkillGrade = 0,
				SkillId = 851811,
				SkillLevel = 1,
			},
		},
	},
	[851812] = {
		[1] = {
			[0] = {
				BeginNodeId = 851812,
				CD = 20,
				SkillGrade = 0,
				SkillId = 851812,
				SkillLevel = 1,
			},
		},
	},
	[851813] = {
		[1] = {
			[0] = {
				BeginNodeId = 851813,
				CD = 20,
				SkillGrade = 0,
				SkillId = 851813,
				SkillLevel = 1,
			},
		},
	},
	[851814] = {
		[1] = {
			[0] = {
				BeginNodeId = 851814,
				CD = 25,
				SkillGrade = 0,
				SkillId = 851814,
				SkillLevel = 1,
			},
		},
	},
	[851815] = {
		[1] = {
			[0] = {
				BeginNodeId = 851815,
				CD = 40,
				SkillGrade = 0,
				SkillId = 851815,
				SkillLevel = 1,
			},
		},
	},
	[851816] = {
		[1] = {
			[0] = {
				BeginNodeId = 851816,
				BornInCd = 10,
				CD = 50,
				SkillGrade = 0,
				SkillId = 851816,
				SkillLevel = 1,
			},
		},
	},
	[851817] = {
		[1] = {
			[0] = {
				BeginNodeId = 851817,
				CD = 20,
				SkillGrade = 0,
				SkillId = 851817,
				SkillLevel = 1,
			},
		},
	},
	[851818] = {
		[1] = {
			[0] = {
				BeginNodeId = 851818,
				CD = 999,
				SkillGrade = 0,
				SkillId = 851818,
				SkillLevel = 1,
			},
		},
	},
	[851819] = {
		[1] = {
			[0] = {
				BeginNodeId = 851819,
				CD = 999,
				SkillGrade = 0,
				SkillId = 851819,
				SkillLevel = 1,
			},
		},
	},
	[851820] = {
		[1] = {
			[0] = {
				BeginNodeId = 851820,
				SkillGrade = 0,
				SkillId = 851820,
				SkillLevel = 1,
			},
		},
	},
	[851821] = {
		[1] = {
			[0] = {
				BeginNodeId = 851821,
				CD = 40,
				SkillGrade = 0,
				SkillId = 851821,
				SkillLevel = 1,
			},
		},
	},
	[851901] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851901,
				SkillGrade = 0,
				SkillId = 851901,
				SkillLevel = 1,
			},
		},
	},
	[851902] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851902,
				SkillGrade = 0,
				SkillId = 851902,
				SkillLevel = 1,
			},
		},
	},
	[851903] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851903,
				SkillGrade = 0,
				SkillId = 851903,
				SkillLevel = 1,
			},
		},
	},
	[851904] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851904,
				SkillGrade = 0,
				SkillId = 851904,
				SkillLevel = 1,
			},
		},
	},
	[851905] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851905,
				SkillGrade = 0,
				SkillId = 851905,
				SkillLevel = 1,
			},
		},
	},
	[851906] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851906,
				SkillGrade = 0,
				SkillId = 851906,
				SkillLevel = 1,
			},
		},
	},
	[851907] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851907,
				SkillGrade = 0,
				SkillId = 851907,
				SkillLevel = 1,
			},
		},
	},
	[851908] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851908,
				SkillGrade = 0,
				SkillId = 851908,
				SkillLevel = 1,
			},
		},
	},
	[851909] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851909,
				SkillGrade = 0,
				SkillId = 851909,
				SkillLevel = 1,
			},
		},
	},
	[851910] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851910,
				SkillGrade = 0,
				SkillId = 851910,
				SkillLevel = 1,
			},
		},
	},
	[851921] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851921,
				SkillGrade = 0,
				SkillId = 851921,
				SkillLevel = 1,
			},
		},
	},
	[851922] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851922,
				SkillGrade = 0,
				SkillId = 851922,
				SkillLevel = 1,
			},
		},
	},
	[851923] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851923,
				SkillGrade = 0,
				SkillId = 851923,
				SkillLevel = 1,
			},
		},
	},
	[851924] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851924,
				SkillGrade = 0,
				SkillId = 851924,
				SkillLevel = 1,
			},
		},
	},
	[851925] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851925,
				SkillGrade = 0,
				SkillId = 851925,
				SkillLevel = 1,
			},
		},
	},
	[851926] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851926,
				SkillGrade = 0,
				SkillId = 851926,
				SkillLevel = 1,
			},
		},
	},
	[851927] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851927,
				SkillGrade = 0,
				SkillId = 851927,
				SkillLevel = 1,
			},
		},
	},
	[851929] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					851901,
				},
				SkillGrade = 0,
				SkillId = 851929,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[851931] = {
		[1] = {
			[0] = {
				BeginNodeId = 851931,
				SkillGrade = 0,
				SkillId = 851931,
				SkillLevel = 1,
			},
		},
	},
	[851932] = {
		[1] = {
			[0] = {
				BeginNodeId = 851932,
				SkillGrade = 0,
				SkillId = 851932,
				SkillLevel = 1,
			},
		},
	},
	[851933] = {
		[1] = {
			[0] = {
				BeginNodeId = 851933,
				SkillGrade = 0,
				SkillId = 851933,
				SkillLevel = 1,
			},
		},
	},
	[851941] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851941,
				SkillGrade = 0,
				SkillId = 851941,
				SkillLevel = 1,
			},
		},
	},
	[851942] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851942,
				SkillGrade = 0,
				SkillId = 851942,
				SkillLevel = 1,
			},
		},
	},
	[851943] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851943,
				SkillGrade = 0,
				SkillId = 851943,
				SkillLevel = 1,
			},
		},
	},
	[851944] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851944,
				SkillGrade = 0,
				SkillId = 851944,
				SkillLevel = 1,
			},
		},
	},
	[851945] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 851945,
				SkillGrade = 0,
				SkillId = 851945,
				SkillLevel = 1,
			},
		},
	},
	[852001] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852001,
				SkillGrade = 0,
				SkillId = 852001,
				SkillLevel = 1,
			},
		},
	},
	[852002] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852002,
				SkillGrade = 0,
				SkillId = 852002,
				SkillLevel = 1,
			},
		},
	},
	[852003] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852003,
				SkillGrade = 0,
				SkillId = 852003,
				SkillLevel = 1,
			},
		},
	},
	[852004] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852004,
				SkillGrade = 0,
				SkillId = 852004,
				SkillLevel = 1,
			},
		},
	},
	[852005] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852005,
				SkillGrade = 0,
				SkillId = 852005,
				SkillLevel = 1,
			},
		},
	},
	[852006] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852006,
				SkillGrade = 0,
				SkillId = 852006,
				SkillLevel = 1,
			},
		},
	},
	[852007] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852007,
				SkillGrade = 0,
				SkillId = 852007,
				SkillLevel = 1,
			},
		},
	},
	[852008] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852008,
				SkillGrade = 0,
				SkillId = 852008,
				SkillLevel = 1,
			},
		},
	},
	[852009] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852009,
				CD = 60,
				SkillGrade = 0,
				SkillId = 852009,
				SkillLevel = 1,
			},
		},
	},
	[852010] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852010,
				SkillGrade = 0,
				SkillId = 852010,
				SkillLevel = 1,
			},
		},
	},
	[852011] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852011,
				SkillGrade = 0,
				SkillId = 852011,
				SkillLevel = 1,
			},
		},
	},
	[852012] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852012,
				SkillGrade = 0,
				SkillId = 852012,
				SkillLevel = 1,
			},
		},
	},
	[852013] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852013,
				SkillGrade = 0,
				SkillId = 852013,
				SkillLevel = 1,
			},
		},
	},
	[852014] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852014,
				SkillGrade = 0,
				SkillId = 852014,
				SkillLevel = 1,
			},
		},
	},
	[852015] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852015,
				SkillGrade = 0,
				SkillId = 852015,
				SkillLevel = 1,
			},
		},
	},
	[852016] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852016,
				SkillGrade = 0,
				SkillId = 852016,
				SkillLevel = 1,
			},
		},
	},
	[852017] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852017,
				SkillGrade = 0,
				SkillId = 852017,
				SkillLevel = 1,
			},
		},
	},
	[852018] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852018,
				SkillGrade = 0,
				SkillId = 852018,
				SkillLevel = 1,
			},
		},
	},
	[852019] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852019,
				SkillGrade = 0,
				SkillId = 852019,
				SkillLevel = 1,
			},
		},
	},
	[852020] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852020,
				SkillGrade = 0,
				SkillId = 852020,
				SkillLevel = 1,
			},
		},
	},
	[852021] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852021,
				SkillGrade = 0,
				SkillId = 852021,
				SkillLevel = 1,
			},
		},
	},
	[852022] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852022,
				SkillGrade = 0,
				SkillId = 852022,
				SkillLevel = 1,
			},
		},
	},
	[852023] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852023,
				SkillGrade = 0,
				SkillId = 852023,
				SkillLevel = 1,
			},
		},
	},
	[852101] = {
		[1] = {
			[0] = {
				BeginNodeId = 852101,
				SkillGrade = 0,
				SkillId = 852101,
				SkillLevel = 1,
			},
		},
	},
	[852102] = {
		[1] = {
			[0] = {
				BeginNodeId = 852102,
				SkillGrade = 0,
				SkillId = 852102,
				SkillLevel = 1,
			},
		},
	},
	[852103] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852103,
				CD = 10,
				SkillGrade = 0,
				SkillId = 852103,
				SkillLevel = 1,
			},
		},
	},
	[852104] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852104,
				SkillGrade = 0,
				SkillId = 852104,
				SkillLevel = 1,
			},
		},
	},
	[852105] = {
		[1] = {
			[0] = {
				BeginNodeId = 852105,
				CD = 15,
				SkillGrade = 0,
				SkillId = 852105,
				SkillLevel = 1,
			},
		},
	},
	[852106] = {
		[1] = {
			[0] = {
				BeginNodeId = 852106,
				CD = 20,
				SkillGrade = 0,
				SkillId = 852106,
				SkillLevel = 1,
			},
		},
	},
	[852107] = {
		[1] = {
			[0] = {
				BeginNodeId = 852107,
				SkillGrade = 0,
				SkillId = 852107,
				SkillLevel = 1,
			},
		},
	},
	[852201] = {
		[1] = {
			[0] = {
				BeginNodeId = 852201,
				SkillGrade = 0,
				SkillId = 852201,
				SkillLevel = 1,
			},
		},
	},
	[852202] = {
		[1] = {
			[0] = {
				BeginNodeId = 852202,
				SkillGrade = 0,
				SkillId = 852202,
				SkillLevel = 1,
			},
		},
	},
	[852203] = {
		[1] = {
			[0] = {
				BeginNodeId = 852203,
				SkillGrade = 0,
				SkillId = 852203,
				SkillLevel = 1,
			},
		},
	},
	[852204] = {
		[1] = {
			[0] = {
				BeginNodeId = 852204,
				SkillGrade = 0,
				SkillId = 852204,
				SkillLevel = 1,
			},
		},
	},
	[852205] = {
		[1] = {
			[0] = {
				BeginNodeId = 852205,
				SkillGrade = 0,
				SkillId = 852205,
				SkillLevel = 1,
			},
		},
	},
	[852206] = {
		[1] = {
			[0] = {
				BeginNodeId = 852206,
				SkillGrade = 0,
				SkillId = 852206,
				SkillLevel = 1,
			},
		},
	},
	[852207] = {
		[1] = {
			[0] = {
				BeginNodeId = 852207,
				SkillGrade = 0,
				SkillId = 852207,
				SkillLevel = 1,
			},
		},
	},
	[852208] = {
		[1] = {
			[0] = {
				BeginNodeId = 852208,
				SkillGrade = 0,
				SkillId = 852208,
				SkillLevel = 1,
			},
		},
	},
	[852301] = {
		[1] = {
			[0] = {
				BeginNodeId = 852301,
				SkillGrade = 0,
				SkillId = 852301,
				SkillLevel = 1,
			},
		},
	},
	[852302] = {
		[1] = {
			[0] = {
				BeginNodeId = 852302,
				SkillGrade = 0,
				SkillId = 852302,
				SkillLevel = 1,
			},
		},
	},
	[852303] = {
		[1] = {
			[0] = {
				BeginNodeId = 852303,
				SkillGrade = 0,
				SkillId = 852303,
				SkillLevel = 1,
			},
		},
	},
	[852304] = {
		[1] = {
			[0] = {
				BeginNodeId = 852304,
				SkillGrade = 0,
				SkillId = 852304,
				SkillLevel = 1,
			},
		},
	},
	[852305] = {
		[1] = {
			[0] = {
				BeginNodeId = 852305,
				SkillGrade = 0,
				SkillId = 852305,
				SkillLevel = 1,
			},
		},
	},
	[852306] = {
		[1] = {
			[0] = {
				BeginNodeId = 852306,
				BornInCd = 15,
				CD = 15,
				SkillGrade = 0,
				SkillId = 852306,
				SkillLevel = 1,
			},
		},
	},
	[852307] = {
		[1] = {
			[0] = {
				BeginNodeId = 852307,
				SkillGrade = 0,
				SkillId = 852307,
				SkillLevel = 1,
			},
		},
	},
	[852308] = {
		[1] = {
			[0] = {
				BeginNodeId = 852308,
				CD = 10,
				SkillGrade = 0,
				SkillId = 852308,
				SkillLevel = 1,
			},
		},
	},
	[852309] = {
		[1] = {
			[0] = {
				BeginNodeId = 852309,
				CD = 10,
				SkillGrade = 0,
				SkillId = 852309,
				SkillLevel = 1,
			},
		},
	},
	[852310] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852310,
				CD = 15,
				SkillGrade = 0,
				SkillId = 852310,
				SkillLevel = 1,
			},
		},
	},
	[852311] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852311,
				SkillGrade = 0,
				SkillId = 852311,
				SkillLevel = 1,
			},
		},
	},
	[852401] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852401,
				SkillGrade = 0,
				SkillId = 852401,
				SkillLevel = 1,
			},
		},
	},
	[852402] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852402,
				SkillGrade = 0,
				SkillId = 852402,
				SkillLevel = 1,
			},
		},
	},
	[852403] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852403,
				BornInCd = 5,
				SkillGrade = 0,
				SkillId = 852403,
				SkillLevel = 1,
			},
		},
	},
	[852404] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852404,
				SkillGrade = 0,
				SkillId = 852404,
				SkillLevel = 1,
			},
		},
	},
	[852405] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852405,
				SkillGrade = 0,
				SkillId = 852405,
				SkillLevel = 1,
			},
		},
	},
	[852406] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852406,
				BornInCd = 5,
				SkillGrade = 0,
				SkillId = 852406,
				SkillLevel = 1,
			},
		},
	},
	[852407] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852407,
				SkillGrade = 0,
				SkillId = 852407,
				SkillLevel = 1,
			},
		},
	},
	[852408] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852408,
				SkillGrade = 0,
				SkillId = 852408,
				SkillLevel = 1,
			},
		},
	},
	[852409] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 852409,
				SkillGrade = 0,
				SkillId = 852409,
				SkillLevel = 1,
			},
		},
	},
	[852501] = {
		[1] = {
			[0] = {
				BeginNodeId = 852501,
				SkillGrade = 0,
				SkillId = 852501,
				SkillLevel = 1,
			},
		},
	},
	[852502] = {
		[1] = {
			[0] = {
				BeginNodeId = 852502,
				SkillGrade = 0,
				SkillId = 852502,
				SkillLevel = 1,
			},
		},
	},
	[852503] = {
		[1] = {
			[0] = {
				BeginNodeId = 852503,
				SkillGrade = 0,
				SkillId = 852503,
				SkillLevel = 1,
			},
		},
	},
	[852504] = {
		[1] = {
			[0] = {
				BeginNodeId = 852504,
				SkillGrade = 0,
				SkillId = 852504,
				SkillLevel = 1,
			},
		},
	},
	[852505] = {
		[1] = {
			[0] = {
				BeginNodeId = 852505,
				SkillGrade = 0,
				SkillId = 852505,
				SkillLevel = 1,
			},
		},
	},
	[852506] = {
		[1] = {
			[0] = {
				BeginNodeId = 852506,
				SkillGrade = 0,
				SkillId = 852506,
				SkillLevel = 1,
			},
		},
	},
	[852507] = {
		[1] = {
			[0] = {
				BeginNodeId = 852507,
				SkillGrade = 0,
				SkillId = 852507,
				SkillLevel = 1,
			},
		},
	},
	[852508] = {
		[1] = {
			[0] = {
				BeginNodeId = 852508,
				SkillGrade = 0,
				SkillId = 852508,
				SkillLevel = 1,
			},
		},
	},
	[852509] = {
		[1] = {
			[0] = {
				BeginNodeId = 852509,
				SkillGrade = 0,
				SkillId = 852509,
				SkillLevel = 1,
			},
		},
	},
	[852510] = {
		[1] = {
			[0] = {
				BeginNodeId = 852510,
				SkillGrade = 0,
				SkillId = 852510,
				SkillLevel = 1,
			},
		},
	},
	[900001] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					900001,
				},
				SkillGrade = 0,
				SkillId = 900001,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[900101] = {
		[1] = {
			[0] = {
				BeginNodeId = 900101,
				SkillGrade = 0,
				SkillId = 900101,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900102] = {
		[1] = {
			[0] = {
				BeginNodeId = 900102,
				SkillGrade = 0,
				SkillId = 900102,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900103] = {
		[1] = {
			[0] = {
				BeginNodeId = 900103,
				SkillGrade = 0,
				SkillId = 900103,
				SkillLevel = 1,
			},
		},
	},
	[900111] = {
		[1] = {
			[0] = {
				BeginNodeId = 900111,
				SkillGrade = 0,
				SkillId = 900111,
				SkillLevel = 1,
			},
		},
	},
	[900172] = {
		[1] = {
			[0] = {
				BeginNodeId = 900172,
				SkillGrade = 0,
				SkillId = 900172,
				SkillLevel = 1,
			},
		},
	},
	[900201] = {
		[1] = {
			[0] = {
				BeginNodeId = 900201,
				SkillGrade = 0,
				SkillId = 900201,
				SkillLevel = 1,
				SkillSpeedModify = true,
				SkillType = "Shooting",
			},
		},
	},
	[900202] = {
		[1] = {
			[0] = {
				BeginNodeId = 900202,
				SkillGrade = 0,
				SkillId = 900202,
				SkillLevel = 1,
			},
		},
	},
	[900203] = {
		[1] = {
			[0] = {
				BeginNodeId = 900203,
				SkillGrade = 0,
				SkillId = 900203,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900204] = {
		[1] = {
			[0] = {
				BeginNodeId = 900204,
				SkillGrade = 0,
				SkillId = 900204,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900211] = {
		[1] = {
			[0] = {
				BeginNodeId = 900211,
				SkillGrade = 0,
				SkillId = 900211,
				SkillLevel = 1,
			},
		},
	},
	[900271] = {
		[1] = {
			[0] = {
				BeginNodeId = 900202,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 900271,
				SkillLevel = 1,
			},
		},
	},
	[900272] = {
		[1] = {
			[0] = {
				BeginNodeId = 900272,
				SkillGrade = 0,
				SkillId = 900272,
				SkillLevel = 1,
			},
		},
	},
	[900301] = {
		[1] = {
			[0] = {
				BeginNodeId = 900301,
				SkillGrade = 0,
				SkillId = 900301,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900302] = {
		[1] = {
			[0] = {
				BeginNodeId = 900302,
				SkillGrade = 0,
				SkillId = 900302,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900303] = {
		[1] = {
			[0] = {
				BeginNodeId = 900303,
				SkillGrade = 0,
				SkillId = 900303,
				SkillLevel = 1,
			},
		},
	},
	[900304] = {
		[1] = {
			[0] = {
				BeginNodeId = 900304,
				CD = 15,
				SkillGrade = 0,
				SkillId = 900304,
				SkillLevel = 1,
			},
		},
	},
	[900305] = {
		[1] = {
			[0] = {
				BeginNodeId = 900305,
				SkillGrade = 0,
				SkillId = 900305,
				SkillLevel = 1,
			},
		},
	},
	[900306] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					900301,
				},
				SkillGrade = 0,
				SkillId = 900306,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[900401] = {
		[1] = {
			[0] = {
				BeginNodeId = 900401,
				SkillGrade = 0,
				SkillId = 900401,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900402] = {
		[1] = {
			[0] = {
				BeginNodeId = 900402,
				SkillGrade = 0,
				SkillId = 900402,
				SkillLevel = 1,
			},
		},
	},
	[900403] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					900401,
				},
				SkillGrade = 0,
				SkillId = 900403,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[900501] = {
		[1] = {
			[0] = {
				BeginNodeId = 900501,
				SkillGrade = 0,
				SkillId = 900501,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900502] = {
		[1] = {
			[0] = {
				BeginNodeId = 900502,
				SkillGrade = 0,
				SkillId = 900502,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900503] = {
		[1] = {
			[0] = {
				BeginNodeId = 900503,
				SkillGrade = 0,
				SkillId = 900503,
				SkillLevel = 1,
			},
		},
	},
	[900504] = {
		[1] = {
			[0] = {
				BeginNodeId = 900504,
				SkillGrade = 0,
				SkillId = 900504,
				SkillLevel = 1,
			},
		},
	},
	[900505] = {
		[1] = {
			[0] = {
				BeginNodeId = 900505,
				SkillGrade = 0,
				SkillId = 900505,
				SkillLevel = 1,
			},
		},
	},
	[900601] = {
		[1] = {
			[0] = {
				BeginNodeId = 900601,
				SkillGrade = 0,
				SkillId = 900601,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900602] = {
		[1] = {
			[0] = {
				BeginNodeId = 900602,
				SkillGrade = 0,
				SkillId = 900602,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900603] = {
		[1] = {
			[0] = {
				BeginNodeId = 900603,
				SkillGrade = 0,
				SkillId = 900603,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900604] = {
		[1] = {
			[0] = {
				BeginNodeId = 900604,
				SkillGrade = 0,
				SkillId = 900604,
				SkillLevel = 1,
			},
		},
	},
	[900605] = {
		[1] = {
			[0] = {
				BeginNodeId = 900605,
				SkillGrade = 0,
				SkillId = 900605,
				SkillLevel = 1,
			},
		},
	},
	[900606] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 900606,
				SkillGrade = 0,
				SkillId = 900606,
				SkillLevel = 1,
			},
		},
	},
	[900607] = {
		[1] = {
			[0] = {
				BeginNodeId = 900607,
				SkillGrade = 0,
				SkillId = 900607,
				SkillLevel = 1,
			},
		},
	},
	[900608] = {
		[1] = {
			[0] = {
				BeginNodeId = 900608,
				CD = 9999,
				SkillGrade = 0,
				SkillId = 900608,
				SkillLevel = 1,
			},
		},
	},
	[900701] = {
		[1] = {
			[0] = {
				BeginNodeId = 900701,
				SkillGrade = 0,
				SkillId = 900701,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900702] = {
		[1] = {
			[0] = {
				BeginNodeId = 900702,
				SkillGrade = 0,
				SkillId = 900702,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900703] = {
		[1] = {
			[0] = {
				BeginNodeId = 900703,
				CD = 10,
				SkillGrade = 0,
				SkillId = 900703,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900704] = {
		[1] = {
			[0] = {
				BeginNodeId = 900704,
				SkillGrade = 0,
				SkillId = 900704,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900711] = {
		[1] = {
			[0] = {
				BeginNodeId = 900711,
				SkillGrade = 0,
				SkillId = 900711,
				SkillLevel = 1,
			},
		},
	},
	[900771] = {
		[1] = {
			[0] = {
				BeginNodeId = 900703,
				BornInCd = 10,
				CD = 15,
				SkillGrade = 0,
				SkillId = 900771,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[900772] = {
		[1] = {
			[0] = {
				BeginNodeId = 900772,
				SkillGrade = 0,
				SkillId = 900772,
				SkillLevel = 1,
			},
		},
	},
	[950001] = {
		[1] = {
			[0] = {
				BeginNodeId = 950001,
				SkillGrade = 0,
				SkillId = 950001,
				SkillLevel = 1,
			},
		},
	},
	[950002] = {
		[1] = {
			[0] = {
				BeginNodeId = 950002,
				SkillGrade = 0,
				SkillId = 950002,
				SkillLevel = 1,
			},
		},
	},
	[950003] = {
		[1] = {
			[0] = {
				BeginNodeId = 950003,
				SkillGrade = 0,
				SkillId = 950003,
				SkillLevel = 1,
			},
		},
	},
	[950004] = {
		[1] = {
			[0] = {
				BeginNodeId = 950004,
				BornInCd = 30,
				SkillGrade = 0,
				SkillId = 950004,
				SkillLevel = 1,
			},
		},
	},
	[950005] = {
		[1] = {
			[0] = {
				BeginNodeId = 950004,
				SkillGrade = 0,
				SkillId = 950005,
				SkillLevel = 1,
			},
		},
	},
	[950006] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					950001,
				},
				SkillGrade = 0,
				SkillId = 950006,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[950007] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					950002,
				},
				SkillGrade = 0,
				SkillId = 950007,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[950008] = {
		[1] = {
			[0] = {
				BeginNodeId = 950005,
				SkillGrade = 0,
				SkillId = 950008,
				SkillLevel = 1,
			},
		},
	},
	[950009] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					950003,
				},
				SkillGrade = 0,
				SkillId = 950009,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[950010] = {
		[1] = {
			[0] = {
				BeginNodeId = 950010,
				SkillGrade = 0,
				SkillId = 950010,
				SkillLevel = 1,
			},
		},
	},
	[950101] = {
		[1] = {
			[0] = {
				BeginNodeId = 950101,
				SkillGrade = 0,
				SkillId = 950101,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[950102] = {
		[1] = {
			[0] = {
				BeginNodeId = 950102,
				SkillGrade = 0,
				SkillId = 950102,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[950103] = {
		[1] = {
			[0] = {
				BeginNodeId = 950103,
				SkillGrade = 0,
				SkillId = 950103,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[950104] = {
		[1] = {
			[0] = {
				BeginNodeId = 950104,
				SkillGrade = 0,
				SkillId = 950104,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[950105] = {
		[1] = {
			[0] = {
				BeginNodeId = 950105,
				SkillGrade = 0,
				SkillId = 950105,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[950106] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					950101,
				},
				SkillGrade = 0,
				SkillId = 950106,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[950107] = {
		[1] = {
			[0] = {
				BeginNodeId = 950106,
				SkillGrade = 0,
				SkillId = 950107,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[950401] = {
		[1] = {
			[0] = {
				BeginNodeId = 950401,
				SkillGrade = 0,
				SkillId = 950401,
				SkillLevel = 1,
			},
		},
	},
	[950402] = {
		[1] = {
			[0] = {
				BeginNodeId = 950402,
				SkillGrade = 0,
				SkillId = 950402,
				SkillLevel = 1,
			},
		},
	},
	[950501] = {
		[1] = {
			[0] = {
				BeginNodeId = 950501,
				SkillGrade = 0,
				SkillId = 950501,
				SkillLevel = 1,
			},
		},
	},
	[950502] = {
		[1] = {
			[0] = {
				BeginNodeId = 950502,
				SkillGrade = 0,
				SkillId = 950502,
				SkillLevel = 1,
			},
		},
	},
	[950601] = {
		[1] = {
			[0] = {
				BeginNodeId = 950601,
				SkillGrade = 0,
				SkillId = 950601,
				SkillLevel = 1,
			},
		},
	},
	[950602] = {
		[1] = {
			[0] = {
				BeginNodeId = 950602,
				SkillGrade = 0,
				SkillId = 950602,
				SkillLevel = 1,
			},
		},
	},
	[950701] = {
		[1] = {
			[0] = {
				BeginNodeId = 950701,
				SkillGrade = 0,
				SkillId = 950701,
				SkillLevel = 1,
			},
		},
	},
	[950702] = {
		[1] = {
			[0] = {
				BeginNodeId = 950702,
				SkillGrade = 0,
				SkillId = 950702,
				SkillLevel = 1,
			},
		},
	},
	[951001] = {
		[1] = {
			[0] = {
				BeginNodeId = 951001,
				SkillGrade = 0,
				SkillId = 951001,
				SkillLevel = 1,
			},
		},
	},
	[951002] = {
		[1] = {
			[0] = {
				BeginNodeId = 951002,
				SkillGrade = 0,
				SkillId = 951002,
				SkillLevel = 1,
			},
		},
	},
	[951003] = {
		[1] = {
			[0] = {
				BeginNodeId = 951003,
				SkillGrade = 0,
				SkillId = 951003,
				SkillLevel = 1,
			},
		},
	},
	[980101] = {
		[1] = {
			[0] = {
				BeginNodeId = 980101,
				SkillGrade = 0,
				SkillId = 980101,
				SkillLevel = 1,
			},
		},
	},
	[980102] = {
		[1] = {
			[0] = {
				BeginNodeId = 980102,
				SkillGrade = 0,
				SkillId = 980102,
				SkillLevel = 1,
			},
		},
	},
	[980103] = {
		[1] = {
			[0] = {
				BeginNodeId = 980103,
				SkillGrade = 0,
				SkillId = 980103,
				SkillLevel = 1,
			},
		},
	},
	[980104] = {
		[1] = {
			[0] = {
				BeginNodeId = 980104,
				SkillGrade = 0,
				SkillId = 980104,
				SkillLevel = 1,
			},
		},
	},
	[980105] = {
		[1] = {
			[0] = {
				BeginNodeId = 980105,
				SkillGrade = 0,
				SkillId = 980105,
				SkillLevel = 1,
			},
		},
	},
	[980106] = {
		[1] = {
			[0] = {
				BeginNodeId = 980106,
				SkillGrade = 0,
				SkillId = 980106,
				SkillLevel = 1,
			},
		},
	},
	[980107] = {
		[1] = {
			[0] = {
				BeginNodeId = 980107,
				SkillGrade = 0,
				SkillId = 980107,
				SkillLevel = 1,
			},
		},
	},
	[980108] = {
		[1] = {
			[0] = {
				BeginNodeId = 980108,
				SkillGrade = 0,
				SkillId = 980108,
				SkillLevel = 1,
			},
		},
	},
	[980109] = {
		[1] = {
			[0] = {
				BeginNodeId = 980109,
				SkillGrade = 0,
				SkillId = 980109,
				SkillLevel = 1,
			},
		},
	},
	[980201] = {
		[1] = {
			[0] = {
				BeginNodeId = 980201,
				SkillGrade = 0,
				SkillId = 980201,
				SkillLevel = 1,
			},
		},
	},
	[980202] = {
		[1] = {
			[0] = {
				BeginNodeId = 980202,
				SkillGrade = 0,
				SkillId = 980202,
				SkillLevel = 1,
			},
		},
	},
	[980203] = {
		[1] = {
			[0] = {
				BeginNodeId = 980203,
				SkillGrade = 0,
				SkillId = 980203,
				SkillLevel = 1,
			},
		},
	},
	[980204] = {
		[1] = {
			[0] = {
				BeginNodeId = 980204,
				SkillGrade = 0,
				SkillId = 980204,
				SkillLevel = 1,
			},
		},
	},
	[980205] = {
		[1] = {
			[0] = {
				BeginNodeId = 980205,
				SkillGrade = 0,
				SkillId = 980205,
				SkillLevel = 1,
			},
		},
	},
	[980206] = {
		[1] = {
			[0] = {
				BeginNodeId = 980206,
				SkillGrade = 0,
				SkillId = 980206,
				SkillLevel = 1,
			},
		},
	},
	[980207] = {
		[1] = {
			[0] = {
				BeginNodeId = 980207,
				SkillGrade = 0,
				SkillId = 980207,
				SkillLevel = 1,
			},
		},
	},
	[980301] = {
		[1] = {
			[0] = {
				BeginNodeId = 980301,
				SkillGrade = 0,
				SkillId = 980301,
				SkillLevel = 1,
			},
		},
	},
	[980302] = {
		[1] = {
			[0] = {
				BeginNodeId = 980302,
				SkillGrade = 0,
				SkillId = 980302,
				SkillLevel = 1,
			},
		},
	},
	[980303] = {
		[1] = {
			[0] = {
				BeginNodeId = 980303,
				SkillGrade = 0,
				SkillId = 980303,
				SkillLevel = 1,
			},
		},
	},
	[980304] = {
		[1] = {
			[0] = {
				BeginNodeId = 980304,
				SkillGrade = 0,
				SkillId = 980304,
				SkillLevel = 1,
			},
		},
	},
	[980401] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 980401,
				SkillGrade = 0,
				SkillId = 980401,
				SkillLevel = 1,
			},
		},
	},
	[980402] = {
		[1] = {
			[0] = {
				BeginNodeId = 980402,
				SkillGrade = 0,
				SkillId = 980402,
				SkillLevel = 1,
			},
		},
	},
	[980501] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 980501,
				SkillGrade = 0,
				SkillId = 980501,
				SkillLevel = 1,
			},
		},
	},
	[980502] = {
		[1] = {
			[0] = {
				BeginNodeId = 980502,
				SkillGrade = 0,
				SkillId = 980502,
				SkillLevel = 1,
			},
		},
	},
	[980701] = {
		[1] = {
			[0] = {
				BeginNodeId = 980701,
				SkillGrade = 0,
				SkillId = 980701,
				SkillLevel = 1,
			},
		},
	},
	[980702] = {
		[1] = {
			[0] = {
				BeginNodeId = 980702,
				SkillGrade = 0,
				SkillId = 980702,
				SkillLevel = 1,
			},
		},
	},
	[980801] = {
		[1] = {
			[0] = {
				BeginNodeId = 980801,
				SkillGrade = 0,
				SkillId = 980801,
				SkillLevel = 1,
			},
		},
	},
	[980802] = {
		[1] = {
			[0] = {
				BeginNodeId = 980802,
				SkillGrade = 0,
				SkillId = 980802,
				SkillLevel = 1,
			},
		},
	},
	[980901] = {
		[1] = {
			[0] = {
				BeginNodeId = 980901,
				SkillGrade = 0,
				SkillId = 980901,
				SkillLevel = 1,
			},
		},
	},
	[980902] = {
		[1] = {
			[0] = {
				BeginNodeId = 980902,
				SkillGrade = 0,
				SkillId = 980902,
				SkillLevel = 1,
			},
		},
	},
	[980903] = {
		[1] = {
			[0] = {
				BeginNodeId = 980903,
				SkillGrade = 0,
				SkillId = 980903,
				SkillLevel = 1,
			},
		},
	},
	[980904] = {
		[1] = {
			[0] = {
				BeginNodeId = 980904,
				SkillGrade = 0,
				SkillId = 980904,
				SkillLevel = 1,
			},
		},
	},
	[981001] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 981001,
				SkillGrade = 0,
				SkillId = 981001,
				SkillLevel = 1,
			},
		},
	},
	[981002] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 981002,
				SkillGrade = 0,
				SkillId = 981002,
				SkillLevel = 1,
			},
		},
	},
	[981003] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 981003,
				SkillGrade = 0,
				SkillId = 981003,
				SkillLevel = 1,
			},
		},
	},
	[1000101] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000101,
				SkillGrade = 0,
				SkillId = 1000101,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[1000102] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000102,
				SkillGrade = 0,
				SkillId = 1000102,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[1000103] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000103,
				SkillGrade = 0,
				SkillId = 1000103,
				SkillLevel = 1,
			},
		},
	},
	[1000104] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000105,
				BornInCd = 3,
				CD = 15,
				SkillGrade = 0,
				SkillId = 1000104,
				SkillLevel = 1,
			},
		},
	},
	[1000105] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000106,
				SkillGrade = 0,
				SkillId = 1000105,
				SkillLevel = 1,
			},
		},
	},
	[1000106] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000107,
				SkillGrade = 0,
				SkillId = 1000106,
				SkillLevel = 1,
			},
		},
	},
	[1000107] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000108,
				BornInCd = 3,
				CD = 15,
				SkillGrade = 0,
				SkillId = 1000107,
				SkillLevel = 1,
			},
		},
	},
	[1000108] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000109,
				SkillGrade = 0,
				SkillId = 1000108,
				SkillLevel = 1,
			},
		},
	},
	[1000109] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000110,
				SkillGrade = 0,
				SkillId = 1000109,
				SkillLevel = 1,
			},
		},
	},
	[1000111] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000104,
				SkillGrade = 0,
				SkillId = 1000111,
				SkillLevel = 1,
			},
		},
	},
	[1000201] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000201,
				SkillGrade = 0,
				SkillId = 1000201,
				SkillLevel = 1,
			},
		},
	},
	[1000202] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000202,
				SkillGrade = 0,
				SkillId = 1000202,
				SkillLevel = 1,
			},
		},
	},
	[1000203] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000203,
				SkillGrade = 0,
				SkillId = 1000203,
				SkillLevel = 1,
			},
		},
	},
	[1000204] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000204,
				SkillGrade = 0,
				SkillId = 1000204,
				SkillLevel = 1,
			},
		},
	},
	[1000205] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000205,
				SkillGrade = 0,
				SkillId = 1000205,
				SkillLevel = 1,
			},
		},
	},
	[1000206] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000206,
				SkillGrade = 0,
				SkillId = 1000206,
				SkillLevel = 1,
			},
		},
	},
	[1000207] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000207,
				SkillGrade = 0,
				SkillId = 1000207,
				SkillLevel = 1,
			},
		},
	},
	[1000208] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					1000201,
				},
				SkillGrade = 0,
				SkillId = 1000208,
				SkillLevel = 1,
			},
		},
	},
	[1000209] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					1000202,
				},
				SkillGrade = 0,
				SkillId = 1000209,
				SkillLevel = 1,
			},
		},
	},
	[1000211] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000211,
				SkillGrade = 0,
				SkillId = 1000211,
				SkillLevel = 1,
			},
		},
	},
	[1000301] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000301,
				SkillGrade = 0,
				SkillId = 1000301,
				SkillLevel = 1,
			},
		},
	},
	[1000302] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000302,
				SkillGrade = 0,
				SkillId = 1000302,
				SkillLevel = 1,
			},
		},
	},
	[1000303] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000303,
				BornInCd = 5,
				SkillGrade = 0,
				SkillId = 1000303,
				SkillLevel = 1,
			},
		},
	},
	[1000304] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000304,
				SkillGrade = 0,
				SkillId = 1000304,
				SkillLevel = 1,
			},
		},
	},
	[1000305] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 1000305,
				SkillGrade = 0,
				SkillId = 1000305,
				SkillLevel = 1,
			},
		},
	},
	[1000306] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 1000306,
				CD = 60,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 1000306,
				SkillLevel = 1,
			},
		},
	},
	[1000307] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 1000306,
				CD = 30,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 1000307,
				SkillLevel = 1,
			},
		},
	},
	[1000308] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000307,
				CD = 9999,
				SkillGrade = 0,
				SkillId = 1000308,
				SkillLevel = 1,
			},
		},
	},
	[1000309] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 1000308,
				SkillGrade = 0,
				SkillId = 1000309,
				SkillLevel = 1,
			},
		},
	},
	[1000310] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 1000309,
				CD = 60,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 1000310,
				SkillLevel = 1,
			},
		},
	},
	[1000311] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 1000309,
				CD = 30,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 1000311,
				SkillLevel = 1,
			},
		},
	},
	[1000401] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000401,
				SkillGrade = 0,
				SkillId = 1000401,
				SkillLevel = 1,
			},
		},
	},
	[1000402] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000402,
				SkillGrade = 0,
				SkillId = 1000402,
				SkillLevel = 1,
			},
		},
	},
	[1000403] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000403,
				SkillGrade = 0,
				SkillId = 1000403,
				SkillLevel = 1,
			},
		},
	},
	[1000404] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000404,
				SkillGrade = 0,
				SkillId = 1000404,
				SkillLevel = 1,
			},
		},
	},
	[1000405] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000405,
				BornInCd = 10,
				SkillGrade = 0,
				SkillId = 1000405,
				SkillLevel = 1,
			},
		},
	},
	[1000406] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000406,
				CD = 60,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 1000406,
				SkillLevel = 1,
			},
		},
	},
	[1000407] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000406,
				CD = 30,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 1000407,
				SkillLevel = 1,
			},
		},
	},
	[1000408] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 1000407,
				SkillGrade = 0,
				SkillId = 1000408,
				SkillLevel = 1,
			},
		},
	},
	[1000409] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000408,
				CD = 9999,
				SkillGrade = 0,
				SkillId = 1000409,
				SkillLevel = 1,
			},
		},
	},
	[1000410] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000409,
				SkillGrade = 0,
				SkillId = 1000410,
				SkillLevel = 1,
			},
		},
	},
	[1000411] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000410,
				SkillGrade = 0,
				SkillId = 1000411,
				SkillLevel = 1,
			},
		},
	},
	[1000412] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000411,
				SkillGrade = 0,
				SkillId = 1000412,
				SkillLevel = 1,
			},
		},
	},
	[1000413] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000412,
				CD = 60,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 1000413,
				SkillLevel = 1,
			},
		},
	},
	[1000414] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000412,
				CD = 30,
				CDCalcType = "End",
				SkillGrade = 0,
				SkillId = 1000414,
				SkillLevel = 1,
			},
		},
	},
	[1000415] = {
		[1] = {
			[0] = {
				AllowUseSkillInAir = true,
				BeginNodeId = 1000413,
				SkillGrade = 0,
				SkillId = 1000415,
				SkillLevel = 1,
			},
		},
	},
	[1000501] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000501,
				SkillGrade = 0,
				SkillId = 1000501,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[1000502] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000502,
				SkillGrade = 0,
				SkillId = 1000502,
				SkillLevel = 1,
				SkillSpeedModify = true,
			},
		},
	},
	[1000503] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000503,
				SkillGrade = 0,
				SkillId = 1000503,
				SkillLevel = 1,
			},
		},
	},
	[1000504] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000505,
				BornInCd = 3,
				CD = 15,
				SkillGrade = 0,
				SkillId = 1000504,
				SkillLevel = 1,
			},
		},
	},
	[1000505] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000506,
				SkillGrade = 0,
				SkillId = 1000505,
				SkillLevel = 1,
			},
		},
	},
	[1000506] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000507,
				SkillGrade = 0,
				SkillId = 1000506,
				SkillLevel = 1,
			},
		},
	},
	[1000507] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000508,
				BornInCd = 3,
				CD = 15,
				SkillGrade = 0,
				SkillId = 1000507,
				SkillLevel = 1,
			},
		},
	},
	[1000508] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000509,
				SkillGrade = 0,
				SkillId = 1000508,
				SkillLevel = 1,
			},
		},
	},
	[1000509] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000510,
				SkillGrade = 0,
				SkillId = 1000509,
				SkillLevel = 1,
			},
		},
	},
	[1000511] = {
		[1] = {
			[0] = {
				BeginNodeId = 1000504,
				SkillGrade = 0,
				SkillId = 1000511,
				SkillLevel = 1,
			},
		},
	},
	[1010101] = {
		[1] = {
			[0] = T.RT_55,
			[1] = T.RT_55,
			[2] = T.RT_55,
			[3] = T.RT_55,
			[4] = T.RT_55,
			[5] = T.RT_55,
			[6] = T.RT_55,
		},
	},
	[1010102] = {
		[1] = {
			[0] = T.RT_60,
			[1] = T.RT_60,
			[2] = T.RT_60,
			[3] = T.RT_60,
			[4] = T.RT_60,
			[5] = T.RT_60,
			[6] = T.RT_60,
		},
	},
	[1010103] = {
		[1] = {
			[0] = T.RT_64,
			[1] = T.RT_64,
			[2] = T.RT_64,
			[3] = T.RT_64,
			[4] = T.RT_64,
			[5] = T.RT_64,
			[6] = T.RT_64,
		},
	},
	[1010104] = {
		[1] = {
			[0] = T.RT_68,
			[1] = T.RT_68,
			[2] = T.RT_68,
			[3] = T.RT_68,
			[4] = T.RT_68,
			[5] = T.RT_68,
			[6] = T.RT_68,
		},
	},
	[1010201] = {
		[1] = {
			[0] = T.RT_70,
			[1] = T.RT_70,
			[2] = T.RT_70,
			[3] = T.RT_70,
			[4] = T.RT_70,
			[5] = T.RT_70,
			[6] = T.RT_70,
		},
	},
	[1010202] = {
		[1] = {
			[0] = T.RT_72,
			[1] = T.RT_72,
			[2] = T.RT_72,
			[3] = T.RT_72,
			[4] = T.RT_72,
			[5] = T.RT_72,
			[6] = T.RT_72,
		},
	},
	[1010302] = {
		[1] = {
			[0] = T.RT_74,
			[1] = T.RT_74,
			[2] = T.RT_74,
			[3] = T.RT_74,
			[4] = T.RT_74,
			[5] = T.RT_74,
			[6] = T.RT_74,
		},
	},
	[1019801] = {
		[1] = {
			[0] = T.RT_75,
			[1] = T.RT_75,
			[2] = T.RT_75,
			[3] = T.RT_75,
			[4] = T.RT_75,
			[5] = T.RT_75,
			[6] = T.RT_75,
		},
	},
	[1019901] = {
		[1] = {
			[0] = T.RT_76,
			[1] = T.RT_76,
			[2] = T.RT_76,
			[3] = T.RT_76,
			[4] = T.RT_76,
			[5] = T.RT_76,
			[6] = T.RT_76,
		},
	},
	[1020101] = {
		[1] = {
			[0] = T.RT_79,
			[1] = T.RT_79,
			[2] = T.RT_79,
			[3] = T.RT_79,
			[4] = T.RT_79,
			[5] = T.RT_79,
			[6] = T.RT_79,
		},
	},
	[1020102] = {
		[1] = {
			[0] = T.RT_82,
			[1] = T.RT_82,
			[2] = T.RT_82,
			[3] = T.RT_82,
			[4] = T.RT_82,
			[5] = T.RT_82,
			[6] = T.RT_82,
		},
	},
	[1020103] = {
		[1] = {
			[0] = T.RT_84,
			[1] = T.RT_84,
			[2] = T.RT_84,
			[3] = T.RT_84,
			[4] = T.RT_84,
			[5] = T.RT_84,
			[6] = T.RT_84,
		},
	},
	[1020104] = {
		[1] = {
			[0] = T.RT_86,
			[1] = T.RT_86,
			[2] = T.RT_86,
			[3] = T.RT_86,
			[4] = T.RT_86,
			[5] = T.RT_86,
			[6] = T.RT_86,
		},
	},
	[1020105] = {
		[1] = {
			[0] = T.RT_89,
			[1] = T.RT_89,
			[2] = T.RT_89,
			[3] = T.RT_89,
			[4] = T.RT_89,
			[5] = T.RT_89,
			[6] = T.RT_89,
		},
	},
	[1020106] = {
		[1] = {
			[0] = T.RT_90,
			[1] = T.RT_90,
			[2] = T.RT_90,
			[3] = T.RT_90,
			[4] = T.RT_90,
			[5] = T.RT_90,
			[6] = T.RT_90,
		},
	},
	[1020201] = {
		[1] = T.RT_94,
		[2] = T.RT_94,
		[3] = T.RT_94,
		[4] = T.RT_94,
		[5] = T.RT_94,
		[6] = T.RT_94,
		[7] = T.RT_94,
		[8] = T.RT_94,
		[9] = T.RT_94,
		[10] = T.RT_94,
		[11] = T.RT_94,
	},
	[1020202] = {
		[1] = {
			[0] = T.RT_96,
			[1] = T.RT_96,
			[2] = T.RT_96,
			[3] = T.RT_96,
			[4] = T.RT_96,
			[5] = T.RT_96,
			[6] = T.RT_96,
		},
	},
	[1020203] = {
		[1] = {
			[0] = T.RT_99,
			[1] = T.RT_99,
			[2] = T.RT_99,
			[3] = T.RT_99,
			[4] = T.RT_99,
			[5] = T.RT_99,
			[6] = T.RT_99,
		},
	},
	[1020302] = {
		[1] = {
			[0] = T.RT_102,
			[1] = T.RT_102,
			[2] = T.RT_102,
			[3] = T.RT_102,
			[4] = T.RT_102,
			[5] = T.RT_102,
			[6] = T.RT_102,
		},
	},
	[1030101] = {
		[1] = {
			[0] = T.RT_104,
			[1] = T.RT_104,
			[2] = T.RT_104,
			[3] = T.RT_104,
			[4] = T.RT_104,
			[5] = T.RT_104,
			[6] = T.RT_104,
		},
	},
	[1030102] = {
		[1] = {
			[0] = T.RT_107,
			[1] = T.RT_107,
			[2] = T.RT_107,
			[3] = T.RT_107,
			[4] = T.RT_107,
			[5] = T.RT_107,
			[6] = T.RT_107,
		},
	},
	[1030103] = {
		[1] = {
			[0] = T.RT_109,
			[1] = T.RT_109,
			[2] = T.RT_109,
			[3] = T.RT_109,
			[4] = T.RT_109,
			[5] = T.RT_109,
			[6] = T.RT_109,
		},
	},
	[1030104] = {
		[1] = {
			[0] = T.RT_111,
			[1] = T.RT_111,
			[2] = T.RT_111,
			[3] = T.RT_111,
			[4] = T.RT_111,
			[5] = T.RT_111,
			[6] = T.RT_111,
		},
	},
	[1030201] = {
		[1] = T.RT_115,
		[2] = T.RT_115,
		[3] = T.RT_115,
		[4] = T.RT_115,
		[5] = T.RT_115,
		[6] = T.RT_115,
		[7] = T.RT_115,
		[8] = T.RT_115,
		[9] = T.RT_115,
		[10] = T.RT_115,
		[11] = T.RT_115,
	},
	[1030202] = {
		[1] = {
			[0] = T.RT_119,
			[1] = T.RT_119,
			[2] = T.RT_119,
			[3] = T.RT_119,
			[4] = T.RT_119,
			[5] = T.RT_119,
			[6] = T.RT_119,
		},
	},
	[1030301] = {
		[1] = {
			[0] = T.RT_121,
			[1] = T.RT_121,
			[2] = T.RT_121,
			[3] = T.RT_121,
			[4] = T.RT_121,
			[5] = T.RT_121,
			[6] = T.RT_121,
		},
	},
	[1040101] = {
		[1] = {
			[0] = T.RT_123,
			[1] = T.RT_123,
			[2] = T.RT_123,
			[3] = T.RT_123,
			[4] = T.RT_123,
			[5] = T.RT_123,
			[6] = T.RT_123,
		},
	},
	[1040102] = {
		[1] = {
			[0] = T.RT_125,
			[1] = T.RT_125,
			[2] = T.RT_125,
			[3] = T.RT_125,
			[4] = T.RT_125,
			[5] = T.RT_125,
			[6] = T.RT_125,
		},
	},
	[1040103] = {
		[1] = {
			[0] = T.RT_127,
			[1] = T.RT_127,
			[2] = T.RT_127,
			[3] = T.RT_127,
			[4] = T.RT_127,
			[5] = T.RT_127,
			[6] = T.RT_127,
		},
	},
	[1040104] = {
		[1] = {
			[0] = T.RT_129,
			[1] = T.RT_129,
			[2] = T.RT_129,
			[3] = T.RT_129,
			[4] = T.RT_129,
			[5] = T.RT_129,
			[6] = T.RT_129,
		},
	},
	[1040201] = {
		[1] = {
			[0] = T.RT_131,
			[1] = T.RT_131,
			[2] = T.RT_131,
			[3] = T.RT_131,
			[4] = T.RT_131,
			[5] = T.RT_131,
			[6] = T.RT_131,
		},
	},
	[1040202] = {
		[1] = {
			[0] = T.RT_133,
			[1] = T.RT_133,
			[2] = T.RT_133,
			[3] = T.RT_133,
			[4] = T.RT_133,
			[5] = T.RT_133,
			[6] = T.RT_133,
		},
	},
	[1040204] = {
		[1] = T.RT_136,
		[2] = T.RT_136,
		[3] = T.RT_136,
		[4] = T.RT_136,
		[5] = T.RT_136,
		[6] = T.RT_136,
		[7] = T.RT_136,
		[8] = T.RT_136,
		[9] = T.RT_136,
		[10] = T.RT_136,
		[11] = T.RT_136,
	},
	[1050101] = {
		[1] = {
			[0] = T.RT_138,
			[1] = T.RT_138,
			[2] = T.RT_138,
			[3] = T.RT_138,
			[4] = T.RT_138,
			[5] = T.RT_138,
			[6] = T.RT_138,
		},
	},
	[1050102] = {
		[1] = {
			[0] = T.RT_142,
			[1] = T.RT_142,
			[2] = T.RT_142,
			[3] = T.RT_142,
			[4] = T.RT_142,
			[5] = T.RT_142,
			[6] = T.RT_142,
		},
	},
	[1050103] = {
		[1] = {
			[0] = T.RT_144,
			[1] = T.RT_144,
			[2] = T.RT_144,
			[3] = T.RT_144,
			[4] = T.RT_144,
			[5] = T.RT_144,
			[6] = T.RT_144,
		},
	},
	[1050104] = {
		[1] = {
			[0] = T.RT_146,
			[1] = T.RT_146,
			[2] = T.RT_146,
			[3] = T.RT_146,
			[4] = T.RT_146,
			[5] = T.RT_146,
			[6] = T.RT_146,
		},
	},
	[1060101] = {
		[1] = {
			[0] = T.RT_148,
			[1] = T.RT_148,
			[2] = T.RT_148,
			[3] = T.RT_148,
			[4] = T.RT_148,
			[5] = T.RT_148,
			[6] = T.RT_148,
		},
	},
	[1060102] = {
		[1] = {
			[0] = T.RT_150,
			[1] = T.RT_150,
			[2] = T.RT_150,
			[3] = T.RT_150,
			[4] = T.RT_150,
			[5] = T.RT_150,
			[6] = T.RT_150,
		},
	},
	[1060103] = {
		[1] = {
			[0] = T.RT_152,
			[1] = T.RT_152,
			[2] = T.RT_152,
			[3] = T.RT_152,
			[4] = T.RT_152,
			[5] = T.RT_152,
			[6] = T.RT_152,
		},
	},
	[1060104] = {
		[1] = {
			[0] = T.RT_154,
			[1] = T.RT_154,
			[2] = T.RT_154,
			[3] = T.RT_154,
			[4] = T.RT_154,
			[5] = T.RT_154,
			[6] = T.RT_154,
		},
	},
	[1060201] = {
		[1] = {
			[0] = T.RT_155,
			[1] = T.RT_155,
			[2] = T.RT_155,
			[3] = T.RT_155,
			[4] = T.RT_155,
			[5] = T.RT_155,
			[6] = T.RT_155,
		},
	},
	[1060202] = {
		[1] = {
			[0] = T.RT_158,
			[1] = T.RT_158,
			[2] = T.RT_158,
			[3] = T.RT_158,
			[4] = T.RT_158,
			[5] = T.RT_158,
			[6] = T.RT_158,
		},
	},
	[1503101] = {
		[1] = T.RT_440,
		[2] = T.RT_440,
		[3] = T.RT_440,
		[4] = T.RT_440,
		[5] = T.RT_440,
		[6] = T.RT_440,
		[7] = T.RT_440,
		[8] = T.RT_440,
		[9] = T.RT_440,
		[10] = T.RT_440,
		[11] = T.RT_440,
		[12] = T.RT_440,
		[13] = T.RT_440,
		[14] = T.RT_440,
		[15] = T.RT_440,
		[16] = T.RT_440,
		[17] = T.RT_440,
		[18] = T.RT_440,
		[19] = T.RT_440,
		[20] = T.RT_440,
	},
	[1503102] = {
		[1] = T.RT_442,
		[2] = T.RT_442,
		[3] = T.RT_442,
		[4] = T.RT_442,
		[5] = T.RT_442,
		[6] = T.RT_442,
		[7] = T.RT_442,
		[8] = T.RT_442,
		[9] = T.RT_442,
		[10] = T.RT_442,
		[11] = T.RT_442,
		[12] = T.RT_442,
		[13] = T.RT_442,
		[14] = T.RT_442,
		[15] = T.RT_442,
		[16] = T.RT_442,
		[17] = T.RT_442,
		[18] = T.RT_442,
		[19] = T.RT_442,
		[20] = T.RT_442,
	},
	[1503103] = {
		[1] = T.RT_444,
		[2] = T.RT_444,
		[3] = T.RT_444,
		[4] = T.RT_444,
		[5] = T.RT_444,
		[6] = T.RT_444,
		[7] = T.RT_444,
		[8] = T.RT_444,
		[9] = T.RT_444,
		[10] = T.RT_444,
		[11] = T.RT_444,
		[12] = T.RT_444,
		[13] = T.RT_444,
		[14] = T.RT_444,
		[15] = T.RT_444,
		[16] = T.RT_444,
		[17] = T.RT_444,
		[18] = T.RT_444,
		[19] = T.RT_444,
		[20] = T.RT_444,
	},
	[1503104] = {
		[1] = T.RT_446,
		[2] = T.RT_446,
		[3] = T.RT_446,
		[4] = T.RT_446,
		[5] = T.RT_446,
		[6] = T.RT_446,
		[7] = T.RT_446,
		[8] = T.RT_446,
		[9] = T.RT_446,
		[10] = T.RT_446,
		[11] = T.RT_446,
		[12] = T.RT_446,
		[13] = T.RT_446,
		[14] = T.RT_446,
		[15] = T.RT_446,
		[16] = T.RT_446,
		[17] = T.RT_446,
		[18] = T.RT_446,
		[19] = T.RT_446,
		[20] = T.RT_446,
	},
	[1503121] = {
		[1] = T.RT_450,
		[2] = T.RT_450,
		[3] = T.RT_450,
		[4] = T.RT_450,
		[5] = T.RT_450,
		[6] = T.RT_450,
		[7] = T.RT_450,
		[8] = T.RT_450,
		[9] = T.RT_450,
		[10] = T.RT_450,
		[11] = T.RT_450,
		[12] = T.RT_450,
		[13] = T.RT_450,
		[14] = T.RT_450,
		[15] = T.RT_450,
		[16] = T.RT_450,
		[17] = T.RT_450,
		[18] = T.RT_450,
		[19] = T.RT_450,
		[20] = T.RT_450,
	},
	[1503122] = {
		[1] = T.RT_452,
		[2] = T.RT_452,
		[3] = T.RT_452,
		[4] = T.RT_452,
		[5] = T.RT_452,
		[6] = T.RT_452,
		[7] = T.RT_452,
		[8] = T.RT_452,
		[9] = T.RT_452,
		[10] = T.RT_452,
		[11] = T.RT_452,
		[12] = T.RT_452,
		[13] = T.RT_452,
		[14] = T.RT_452,
		[15] = T.RT_452,
		[16] = T.RT_452,
		[17] = T.RT_452,
		[18] = T.RT_452,
		[19] = T.RT_452,
		[20] = T.RT_452,
	},
	[1503123] = {
		[1] = T.RT_454,
		[2] = T.RT_454,
		[3] = T.RT_454,
		[4] = T.RT_454,
		[5] = T.RT_454,
		[6] = T.RT_454,
		[7] = T.RT_454,
		[8] = T.RT_454,
		[9] = T.RT_454,
		[10] = T.RT_454,
		[11] = T.RT_454,
		[12] = T.RT_454,
		[13] = T.RT_454,
		[14] = T.RT_454,
		[15] = T.RT_454,
		[16] = T.RT_454,
		[17] = T.RT_454,
		[18] = T.RT_454,
		[19] = T.RT_454,
		[20] = T.RT_454,
	},
	[1503124] = {
		[1] = T.RT_456,
		[2] = T.RT_456,
		[3] = T.RT_456,
		[4] = T.RT_456,
		[5] = T.RT_456,
		[6] = T.RT_456,
		[7] = T.RT_456,
		[8] = T.RT_456,
		[9] = T.RT_456,
		[10] = T.RT_456,
		[11] = T.RT_456,
		[12] = T.RT_456,
		[13] = T.RT_456,
		[14] = T.RT_456,
		[15] = T.RT_456,
		[16] = T.RT_456,
		[17] = T.RT_456,
		[18] = T.RT_456,
		[19] = T.RT_456,
		[20] = T.RT_456,
	},
	[1503141] = {
		[1] = T.RT_458,
		[2] = T.RT_458,
		[3] = T.RT_458,
		[4] = T.RT_458,
		[5] = T.RT_458,
		[6] = T.RT_458,
		[7] = T.RT_458,
		[8] = T.RT_458,
		[9] = T.RT_458,
		[10] = T.RT_458,
		[11] = T.RT_458,
		[12] = T.RT_458,
		[13] = T.RT_458,
		[14] = T.RT_458,
		[15] = T.RT_458,
		[16] = T.RT_458,
		[17] = T.RT_458,
		[18] = T.RT_458,
		[19] = T.RT_458,
		[20] = T.RT_458,
	},
	[1503142] = {
		[1] = T.RT_460,
		[2] = T.RT_460,
		[3] = T.RT_460,
		[4] = T.RT_460,
		[5] = T.RT_460,
		[6] = T.RT_460,
		[7] = T.RT_460,
		[8] = T.RT_460,
		[9] = T.RT_460,
		[10] = T.RT_460,
		[11] = T.RT_460,
		[12] = T.RT_460,
		[13] = T.RT_460,
		[14] = T.RT_460,
		[15] = T.RT_460,
		[16] = T.RT_460,
		[17] = T.RT_460,
		[18] = T.RT_460,
		[19] = T.RT_460,
		[20] = T.RT_460,
	},
	[1503143] = {
		[1] = T.RT_462,
		[2] = T.RT_462,
		[3] = T.RT_462,
		[4] = T.RT_462,
		[5] = T.RT_462,
		[6] = T.RT_462,
		[7] = T.RT_462,
		[8] = T.RT_462,
		[9] = T.RT_462,
		[10] = T.RT_462,
		[11] = T.RT_462,
		[12] = T.RT_462,
		[13] = T.RT_462,
		[14] = T.RT_462,
		[15] = T.RT_462,
		[16] = T.RT_462,
		[17] = T.RT_462,
		[18] = T.RT_462,
		[19] = T.RT_462,
		[20] = T.RT_462,
	},
	[1503144] = {
		[1] = T.RT_464,
		[2] = T.RT_464,
		[3] = T.RT_464,
		[4] = T.RT_464,
		[5] = T.RT_464,
		[6] = T.RT_464,
		[7] = T.RT_464,
		[8] = T.RT_464,
		[9] = T.RT_464,
		[10] = T.RT_464,
		[11] = T.RT_464,
		[12] = T.RT_464,
		[13] = T.RT_464,
		[14] = T.RT_464,
		[15] = T.RT_464,
		[16] = T.RT_464,
		[17] = T.RT_464,
		[18] = T.RT_464,
		[19] = T.RT_464,
		[20] = T.RT_464,
	},
	[1503161] = {
		[1] = T.RT_466,
		[2] = T.RT_466,
		[3] = T.RT_466,
		[4] = T.RT_466,
		[5] = T.RT_466,
		[6] = T.RT_466,
		[7] = T.RT_466,
		[8] = T.RT_466,
		[9] = T.RT_466,
		[10] = T.RT_466,
		[11] = T.RT_466,
		[12] = T.RT_466,
		[13] = T.RT_466,
		[14] = T.RT_466,
		[15] = T.RT_466,
		[16] = T.RT_466,
		[17] = T.RT_466,
		[18] = T.RT_466,
		[19] = T.RT_466,
		[20] = T.RT_466,
	},
	[1503162] = {
		[1] = T.RT_468,
		[2] = T.RT_468,
		[3] = T.RT_468,
		[4] = T.RT_468,
		[5] = T.RT_468,
		[6] = T.RT_468,
		[7] = T.RT_468,
		[8] = T.RT_468,
		[9] = T.RT_468,
		[10] = T.RT_468,
		[11] = T.RT_468,
		[12] = T.RT_468,
		[13] = T.RT_468,
		[14] = T.RT_468,
		[15] = T.RT_468,
		[16] = T.RT_468,
		[17] = T.RT_468,
		[18] = T.RT_468,
		[19] = T.RT_468,
		[20] = T.RT_468,
	},
	[1503163] = {
		[1] = T.RT_470,
		[2] = T.RT_470,
		[3] = T.RT_470,
		[4] = T.RT_470,
		[5] = T.RT_470,
		[6] = T.RT_470,
		[7] = T.RT_470,
		[8] = T.RT_470,
		[9] = T.RT_470,
		[10] = T.RT_470,
		[11] = T.RT_470,
		[12] = T.RT_470,
		[13] = T.RT_470,
		[14] = T.RT_470,
		[15] = T.RT_470,
		[16] = T.RT_470,
		[17] = T.RT_470,
		[18] = T.RT_470,
		[19] = T.RT_470,
		[20] = T.RT_470,
	},
	[1503164] = {
		[1] = T.RT_472,
		[2] = T.RT_472,
		[3] = T.RT_472,
		[4] = T.RT_472,
		[5] = T.RT_472,
		[6] = T.RT_472,
		[7] = T.RT_472,
		[8] = T.RT_472,
		[9] = T.RT_472,
		[10] = T.RT_472,
		[11] = T.RT_472,
		[12] = T.RT_472,
		[13] = T.RT_472,
		[14] = T.RT_472,
		[15] = T.RT_472,
		[16] = T.RT_472,
		[17] = T.RT_472,
		[18] = T.RT_472,
		[19] = T.RT_472,
		[20] = T.RT_472,
	},
	[2010101] = {
		[1] = {
			[0] = T.RT_613,
			[1] = T.RT_613,
			[2] = T.RT_613,
			[3] = T.RT_613,
			[4] = T.RT_613,
			[5] = T.RT_613,
			[6] = T.RT_613,
		},
	},
	[2010102] = {
		[1] = {
			[0] = T.RT_615,
			[1] = T.RT_615,
			[2] = T.RT_615,
			[3] = T.RT_615,
			[4] = T.RT_615,
			[5] = T.RT_615,
			[6] = T.RT_615,
		},
	},
	[2010401] = {
		[1] = {
			[0] = T.RT_619,
			[1] = T.RT_619,
			[2] = T.RT_619,
			[3] = T.RT_619,
			[4] = T.RT_619,
			[5] = T.RT_619,
			[6] = T.RT_619,
		},
	},
	[2010402] = {
		[1] = {
			[0] = T.RT_620,
			[1] = T.RT_620,
			[2] = T.RT_620,
			[3] = T.RT_620,
			[4] = T.RT_620,
			[5] = T.RT_620,
			[6] = T.RT_620,
		},
	},
	[2019901] = {
		[1] = {
			[0] = T.RT_623,
			[1] = T.RT_623,
			[2] = T.RT_623,
			[3] = T.RT_623,
			[4] = T.RT_623,
			[5] = T.RT_623,
			[6] = T.RT_623,
		},
	},
	[2019902] = {
		[1] = {
			[0] = T.RT_624,
			[1] = T.RT_624,
			[2] = T.RT_624,
			[3] = T.RT_624,
			[4] = T.RT_624,
			[5] = T.RT_624,
			[6] = T.RT_624,
		},
	},
	[2020101] = {
		[1] = {
			[0] = T.RT_626,
			[1] = T.RT_626,
			[2] = T.RT_626,
			[3] = T.RT_626,
			[4] = T.RT_626,
			[5] = T.RT_626,
			[6] = T.RT_626,
		},
	},
	[2020102] = {
		[1] = {
			[0] = T.RT_627,
			[1] = T.RT_627,
			[2] = T.RT_627,
			[3] = T.RT_627,
			[4] = T.RT_627,
			[5] = T.RT_627,
			[6] = T.RT_627,
		},
	},
	[2020301] = {
		[1] = {
			[0] = T.RT_630,
			[1] = T.RT_630,
			[2] = T.RT_630,
			[3] = T.RT_630,
			[4] = T.RT_630,
			[5] = T.RT_630,
			[6] = T.RT_630,
		},
	},
	[2020302] = {
		[1] = {
			[0] = T.RT_631,
			[1] = T.RT_631,
			[2] = T.RT_631,
			[3] = T.RT_631,
			[4] = T.RT_631,
			[5] = T.RT_631,
			[6] = T.RT_631,
		},
	},
	[2020701] = {
		[1] = {
			[0] = T.RT_632,
			[1] = T.RT_632,
			[2] = T.RT_632,
			[3] = T.RT_632,
			[4] = T.RT_632,
			[5] = T.RT_632,
			[6] = T.RT_632,
		},
	},
	[2020702] = {
		[1] = {
			[0] = T.RT_633,
			[1] = T.RT_633,
			[2] = T.RT_633,
			[3] = T.RT_633,
			[4] = T.RT_633,
			[5] = T.RT_633,
			[6] = T.RT_633,
		},
	},
	[2030101] = {
		[1] = {
			[0] = T.RT_636,
			[1] = T.RT_636,
			[2] = T.RT_636,
			[3] = T.RT_636,
			[4] = T.RT_636,
			[5] = T.RT_636,
			[6] = T.RT_636,
		},
	},
	[2030102] = {
		[1] = {
			[0] = T.RT_637,
			[1] = T.RT_637,
			[2] = T.RT_637,
			[3] = T.RT_637,
			[4] = T.RT_637,
			[5] = T.RT_637,
			[6] = T.RT_637,
		},
	},
	[2030201] = {
		[1] = {
			[0] = T.RT_640,
			[1] = T.RT_640,
			[2] = T.RT_640,
			[3] = T.RT_640,
			[4] = T.RT_640,
			[5] = T.RT_640,
			[6] = T.RT_640,
		},
	},
	[2030202] = {
		[1] = {
			[0] = T.RT_641,
			[1] = T.RT_641,
			[2] = T.RT_641,
			[3] = T.RT_641,
			[4] = T.RT_641,
			[5] = T.RT_641,
			[6] = T.RT_641,
		},
	},
	[2030301] = {
		[1] = {
			[0] = T.RT_644,
			[1] = T.RT_644,
			[2] = T.RT_644,
			[3] = T.RT_644,
			[4] = T.RT_644,
			[5] = T.RT_644,
			[6] = T.RT_644,
		},
	},
	[2030302] = {
		[1] = {
			[0] = T.RT_645,
			[1] = T.RT_645,
			[2] = T.RT_645,
			[3] = T.RT_645,
			[4] = T.RT_645,
			[5] = T.RT_645,
			[6] = T.RT_645,
		},
	},
	[2030401] = {
		[1] = {
			[0] = T.RT_648,
			[1] = T.RT_648,
			[2] = T.RT_648,
			[3] = T.RT_648,
			[4] = T.RT_648,
			[5] = T.RT_648,
			[6] = T.RT_648,
		},
	},
	[2030402] = {
		[1] = {
			[0] = T.RT_649,
			[1] = T.RT_649,
			[2] = T.RT_649,
			[3] = T.RT_649,
			[4] = T.RT_649,
			[5] = T.RT_649,
			[6] = T.RT_649,
		},
	},
	[2030501] = {
		[1] = {
			[0] = T.RT_652,
			[1] = T.RT_652,
			[2] = T.RT_652,
			[3] = T.RT_652,
			[4] = T.RT_652,
			[5] = T.RT_652,
			[6] = T.RT_652,
		},
	},
	[2030502] = {
		[1] = {
			[0] = T.RT_653,
			[1] = T.RT_653,
			[2] = T.RT_653,
			[3] = T.RT_653,
			[4] = T.RT_653,
			[5] = T.RT_653,
			[6] = T.RT_653,
		},
	},
	[2040101] = {
		[1] = {
			[0] = T.RT_656,
			[1] = T.RT_656,
			[2] = T.RT_656,
			[3] = T.RT_656,
			[4] = T.RT_656,
			[5] = T.RT_656,
			[6] = T.RT_656,
		},
	},
	[2040102] = {
		[1] = {
			[0] = T.RT_657,
			[1] = T.RT_657,
			[2] = T.RT_657,
			[3] = T.RT_657,
			[4] = T.RT_657,
			[5] = T.RT_657,
			[6] = T.RT_657,
		},
	},
	[2040201] = {
		[1] = {
			[0] = T.RT_660,
			[1] = T.RT_660,
			[2] = T.RT_660,
			[3] = T.RT_660,
			[4] = T.RT_660,
			[5] = T.RT_660,
			[6] = T.RT_660,
		},
	},
	[2040202] = {
		[1] = {
			[0] = T.RT_661,
			[1] = T.RT_661,
			[2] = T.RT_661,
			[3] = T.RT_661,
			[4] = T.RT_661,
			[5] = T.RT_661,
			[6] = T.RT_661,
		},
	},
	[2040301] = {
		[1] = {
			[0] = T.RT_663,
			[1] = T.RT_663,
			[2] = T.RT_663,
			[3] = T.RT_663,
			[4] = T.RT_663,
			[5] = T.RT_663,
			[6] = T.RT_663,
		},
	},
	[2040302] = {
		[1] = {
			[0] = T.RT_664,
			[1] = T.RT_664,
			[2] = T.RT_664,
			[3] = T.RT_664,
			[4] = T.RT_664,
			[5] = T.RT_664,
			[6] = T.RT_664,
		},
	},
	[2040501] = {
		[1] = {
			[0] = T.RT_667,
			[1] = T.RT_667,
			[2] = T.RT_667,
			[3] = T.RT_667,
			[4] = T.RT_667,
			[5] = T.RT_667,
			[6] = T.RT_667,
		},
	},
	[2040502] = {
		[1] = {
			[0] = T.RT_668,
			[1] = T.RT_668,
			[2] = T.RT_668,
			[3] = T.RT_668,
			[4] = T.RT_668,
			[5] = T.RT_668,
			[6] = T.RT_668,
		},
	},
	[2040503] = {
		[1] = {
			[0] = T.RT_669,
			[1] = T.RT_669,
			[2] = T.RT_669,
			[3] = T.RT_669,
			[4] = T.RT_669,
			[5] = T.RT_669,
			[6] = T.RT_669,
		},
	},
	[2040601] = {
		[1] = {
			[0] = T.RT_672,
			[1] = T.RT_672,
			[2] = T.RT_672,
			[3] = T.RT_672,
			[4] = T.RT_672,
			[5] = T.RT_672,
			[6] = T.RT_672,
		},
	},
	[2040602] = {
		[1] = {
			[0] = T.RT_673,
			[1] = T.RT_673,
			[2] = T.RT_673,
			[3] = T.RT_673,
			[4] = T.RT_673,
			[5] = T.RT_673,
			[6] = T.RT_673,
		},
	},
	[2040701] = {
		[1] = {
			[0] = T.RT_675,
			[1] = T.RT_675,
			[2] = T.RT_675,
			[3] = T.RT_675,
			[4] = T.RT_675,
			[5] = T.RT_675,
			[6] = T.RT_675,
		},
	},
	[2040702] = {
		[1] = {
			[0] = T.RT_676,
			[1] = T.RT_676,
			[2] = T.RT_676,
			[3] = T.RT_676,
			[4] = T.RT_676,
			[5] = T.RT_676,
			[6] = T.RT_676,
		},
	},
	[2050101] = {
		[1] = {
			[0] = T.RT_679,
			[1] = T.RT_679,
			[2] = T.RT_679,
			[3] = T.RT_679,
			[4] = T.RT_679,
			[5] = T.RT_679,
			[6] = T.RT_679,
		},
	},
	[2050102] = {
		[1] = {
			[0] = T.RT_680,
			[1] = T.RT_680,
			[2] = T.RT_680,
			[3] = T.RT_680,
			[4] = T.RT_680,
			[5] = T.RT_680,
			[6] = T.RT_680,
		},
	},
	[2050201] = {
		[1] = {
			[0] = T.RT_683,
			[1] = T.RT_683,
			[2] = T.RT_683,
			[3] = T.RT_683,
			[4] = T.RT_683,
			[5] = T.RT_683,
			[6] = T.RT_683,
		},
	},
	[2050202] = {
		[1] = {
			[0] = T.RT_684,
			[1] = T.RT_684,
			[2] = T.RT_684,
			[3] = T.RT_684,
			[4] = T.RT_684,
			[5] = T.RT_684,
			[6] = T.RT_684,
		},
	},
	[2050301] = {
		[1] = {
			[0] = T.RT_687,
			[1] = T.RT_687,
			[2] = T.RT_687,
			[3] = T.RT_687,
			[4] = T.RT_687,
			[5] = T.RT_687,
			[6] = T.RT_687,
		},
	},
	[2050302] = {
		[1] = {
			[0] = T.RT_688,
			[1] = T.RT_688,
			[2] = T.RT_688,
			[3] = T.RT_688,
			[4] = T.RT_688,
			[5] = T.RT_688,
			[6] = T.RT_688,
		},
	},
	[2050401] = {
		[1] = {
			[0] = T.RT_691,
			[1] = T.RT_691,
			[2] = T.RT_691,
			[3] = T.RT_691,
			[4] = T.RT_691,
			[5] = T.RT_691,
			[6] = T.RT_691,
		},
	},
	[2050402] = {
		[1] = {
			[0] = T.RT_692,
			[1] = T.RT_692,
			[2] = T.RT_692,
			[3] = T.RT_692,
			[4] = T.RT_692,
			[5] = T.RT_692,
			[6] = T.RT_692,
		},
	},
	[2050501] = {
		[1] = {
			[0] = T.RT_695,
			[1] = T.RT_695,
			[2] = T.RT_695,
			[3] = T.RT_695,
			[4] = T.RT_695,
			[5] = T.RT_695,
			[6] = T.RT_695,
		},
	},
	[2050502] = {
		[1] = {
			[0] = T.RT_696,
			[1] = T.RT_696,
			[2] = T.RT_696,
			[3] = T.RT_696,
			[4] = T.RT_696,
			[5] = T.RT_696,
			[6] = T.RT_696,
		},
	},
	[2050601] = {
		[1] = {
			[0] = T.RT_698,
			[1] = T.RT_698,
			[2] = T.RT_698,
			[3] = T.RT_698,
			[4] = T.RT_698,
			[5] = T.RT_698,
			[6] = T.RT_698,
		},
	},
	[2050602] = {
		[1] = {
			[0] = T.RT_699,
			[1] = T.RT_699,
			[2] = T.RT_699,
			[3] = T.RT_699,
			[4] = T.RT_699,
			[5] = T.RT_699,
			[6] = T.RT_699,
		},
	},
	[2050701] = {
		[1] = {
			[0] = T.RT_702,
			[1] = T.RT_702,
			[2] = T.RT_702,
			[3] = T.RT_702,
			[4] = T.RT_702,
			[5] = T.RT_702,
			[6] = T.RT_702,
		},
	},
	[2050902] = {
		[1] = {
			[0] = T.RT_703,
			[1] = T.RT_703,
			[2] = T.RT_703,
			[3] = T.RT_703,
			[4] = T.RT_703,
			[5] = T.RT_703,
			[6] = T.RT_703,
		},
	},
	[2051001] = {
		[1] = {
			[0] = T.RT_705,
			[1] = T.RT_705,
			[2] = T.RT_705,
			[3] = T.RT_705,
			[4] = T.RT_705,
			[5] = T.RT_705,
			[6] = T.RT_705,
		},
	},
	[2051101] = {
		[1] = {
			[0] = T.RT_708,
			[1] = T.RT_708,
			[2] = T.RT_708,
			[3] = T.RT_708,
			[4] = T.RT_708,
			[5] = T.RT_708,
			[6] = T.RT_708,
		},
	},
	[2051102] = {
		[1] = {
			[0] = T.RT_709,
			[1] = T.RT_709,
			[2] = T.RT_709,
			[3] = T.RT_709,
			[4] = T.RT_709,
			[5] = T.RT_709,
			[6] = T.RT_709,
		},
	},
	[2051201] = {
		[1] = {
			[0] = T.RT_711,
			[1] = T.RT_711,
			[2] = T.RT_711,
			[3] = T.RT_711,
			[4] = T.RT_711,
			[5] = T.RT_711,
			[6] = T.RT_711,
		},
	},
	[2051202] = {
		[1] = {
			[0] = T.RT_712,
			[1] = T.RT_712,
			[2] = T.RT_712,
			[3] = T.RT_712,
			[4] = T.RT_712,
			[5] = T.RT_712,
			[6] = T.RT_712,
		},
	},
	[2060101] = {
		[1] = {
			[0] = T.RT_715,
			[1] = T.RT_715,
			[2] = T.RT_715,
			[3] = T.RT_715,
			[4] = T.RT_715,
			[5] = T.RT_715,
			[6] = T.RT_715,
		},
	},
	[2060102] = {
		[1] = {
			[0] = T.RT_716,
			[1] = T.RT_716,
			[2] = T.RT_716,
			[3] = T.RT_716,
			[4] = T.RT_716,
			[5] = T.RT_716,
			[6] = T.RT_716,
		},
	},
	[2060201] = {
		[1] = {
			[0] = T.RT_719,
			[1] = T.RT_719,
			[2] = T.RT_719,
			[3] = T.RT_719,
			[4] = T.RT_719,
			[5] = T.RT_719,
			[6] = T.RT_719,
		},
	},
	[2060301] = {
		[1] = {
			[0] = T.RT_722,
			[1] = T.RT_722,
			[2] = T.RT_722,
			[3] = T.RT_722,
			[4] = T.RT_722,
			[5] = T.RT_722,
			[6] = T.RT_722,
		},
	},
	[2060302] = {
		[1] = {
			[0] = T.RT_723,
			[1] = T.RT_723,
			[2] = T.RT_723,
			[3] = T.RT_723,
			[4] = T.RT_723,
			[5] = T.RT_723,
			[6] = T.RT_723,
		},
	},
	[2060501] = {
		[1] = {
			[0] = T.RT_724,
			[1] = T.RT_724,
			[2] = T.RT_724,
			[3] = T.RT_724,
			[4] = T.RT_724,
			[5] = T.RT_724,
			[6] = T.RT_724,
		},
	},
	[2060502] = {
		[1] = {
			[0] = T.RT_725,
			[1] = T.RT_725,
			[2] = T.RT_725,
			[3] = T.RT_725,
			[4] = T.RT_725,
			[5] = T.RT_725,
			[6] = T.RT_725,
		},
	},
	[2069901] = {
		[1] = {
			[0] = T.RT_728,
			[1] = T.RT_728,
			[2] = T.RT_728,
			[3] = T.RT_728,
			[4] = T.RT_728,
			[5] = T.RT_728,
			[6] = T.RT_728,
		},
	},
	[2069902] = {
		[1] = {
			[0] = T.RT_729,
			[1] = T.RT_729,
			[2] = T.RT_729,
			[3] = T.RT_729,
			[4] = T.RT_729,
			[5] = T.RT_729,
			[6] = T.RT_729,
		},
	},
	[4010100] = {
		[1] = {
			[0] = T.RT_1088,
			[1] = T.RT_1088,
			[2] = T.RT_1088,
			[3] = T.RT_1088,
			[4] = T.RT_1088,
			[5] = T.RT_1088,
			[6] = T.RT_1088,
		},
	},
	[4010101] = {
		[1] = {
			[0] = T.RT_1090,
			[1] = T.RT_1090,
			[2] = T.RT_1090,
			[3] = T.RT_1090,
			[4] = T.RT_1090,
			[5] = T.RT_1090,
			[6] = T.RT_1090,
		},
	},
	[4010200] = {
		[1] = {
			[0] = T.RT_1093,
			[1] = T.RT_1093,
			[2] = T.RT_1093,
			[3] = T.RT_1093,
			[4] = T.RT_1093,
			[5] = T.RT_1093,
			[6] = T.RT_1093,
		},
	},
	[4010201] = {
		[1] = {
			[0] = T.RT_1095,
			[1] = T.RT_1095,
			[2] = T.RT_1095,
			[3] = T.RT_1095,
			[4] = T.RT_1095,
			[5] = T.RT_1095,
			[6] = T.RT_1095,
		},
	},
	[6000000] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000000,
				},
				SkillGrade = 0,
				SkillId = 6000000,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000009] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000009,
				},
				SkillGrade = 0,
				SkillId = 6000009,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000010] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000010,
				},
				SkillGrade = 0,
				SkillId = 6000010,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000011] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000011,
				},
				SkillGrade = 0,
				SkillId = 6000011,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000012] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000012,
				},
				SkillGrade = 0,
				SkillId = 6000012,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000013] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000013,
				},
				SkillGrade = 0,
				SkillId = 6000013,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000014] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000014,
				},
				SkillGrade = 0,
				SkillId = 6000014,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000015] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000015,
				},
				SkillGrade = 0,
				SkillId = 6000015,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000016] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000016,
				},
				SkillGrade = 0,
				SkillId = 6000016,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000017] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000017,
				},
				SkillGrade = 0,
				SkillId = 6000017,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000018] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000018,
				},
				SkillGrade = 0,
				SkillId = 6000018,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000019] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					6000019,
				},
				SkillGrade = 0,
				SkillId = 6000019,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
	[6000020] = {
		[1] = {
			[0] = {
				PassiveEffects = {
					4010101,
				},
				SkillGrade = 0,
				SkillId = 6000020,
				SkillLevel = 1,
				SkillType = "Passive",
			},
		},
	},
})