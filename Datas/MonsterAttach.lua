-- Source Excel file path: ..\datas\Combat\AIBattleMgr.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("MonsterAttach", {
	[7001] = {
		AttachRuleId = 7001,
		IgnorePhysicAndGravity = true,
		IgnoreRVO = true,
		RelativeOffset = {
			20,
			0,
			160,
		},
		RelativeRotation = 0,
		SetPositionAndRotate = true,
		SourceSocketName = "pelvis",
		TargetSocketName = "pelvis",
		bRelativeUseLocalSpace = false,
	},
	[7002] = {
		AttachRuleId = 7002,
		IgnorePhysicAndGravity = true,
		IgnoreRVO = true,
		RelativeOffset = {
			20,
			0,
			-50,
		},
		RelativeRotation = 0,
		SetPositionAndRotate = true,
		SourceSocketName = "root",
		TargetSocketName = "hand_l",
		bRelativeUseLocalSpace = false,
	},
})