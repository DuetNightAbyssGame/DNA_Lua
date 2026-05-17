-- Source Excel file path: ..\datas\Combat\DataSetInfo.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("DataSetIgnore", {
	BaonuEnd = {
		ID = "BaonuEnd",
	},
	BaonuFinish = {
		ID = "BaonuFinish",
	},
	BlockOverride = {
		ID = "BlockOverride",
	},
	BossMapSkill = {
		ID = "BossMapSkill",
	},
	CamBlendTime = {
		ID = "CamBlendTime",
	},
	Claymore_Heavyattack_Mod01_Grab_Cilent = {
		ID = "Claymore_Heavyattack_Mod01_Grab_Cilent",
	},
	DeadDissolveTime = {
		ID = "DeadDissolveTime",
	},
	HitMoveDis = {
		ID = "HitMoveDis",
	},
	IsDestructPart = {
		ID = "IsDestructPart",
	},
	LinenSkill02Range = {
		ID = "LinenSkill02Range",
	},
	Maer_Skill02_Level1 = {
		ID = "Maer_Skill02_Level1",
	},
	Maer_Skill02_Level2 = {
		ID = "Maer_Skill02_Level2",
	},
	Maer_Skill02_Level3 = {
		ID = "Maer_Skill02_Level3",
	},
	Mechanism_39029_Hide = {
		ID = "Mechanism_39029_Hide",
	},
	NiagaraTriggerComponent = {
		ID = "NiagaraTriggerComponent",
	},
	NotifyCurCtrlRotation = {
		ID = "NotifyCurCtrlRotation",
	},
	NotifyMonMoveSpeed = {
		ID = "NotifyMonMoveSpeed",
	},
	Skill01Count1 = {
		ID = "Skill01Count1",
	},
	Skill01Count2 = {
		ID = "Skill01Count2",
	},
	ToExplode = {
		ID = "ToExplode",
	},
	Weapon20402_Scale = {
		ID = "Weapon20402_Scale",
	},
})