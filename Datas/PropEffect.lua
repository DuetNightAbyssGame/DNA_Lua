-- Source Excel file path: ..\datas\Combat\PropEffect.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PropEffect", {
	[1] = {
		BPPath = "Blueprint'/Game/BluePrints/Combat/PropEffect/PropEffectObject.PropEffectObject_C'",
		Id = 1,
		UsingIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_CallPhantom_Empty",
	},
	[42001] = {
		BPPath = "Blueprint'/Game/BluePrints/Combat/PropEffect/PropEffectObject_42001.PropEffectObject_42001'",
		Id = 42001,
		ReplaceShootIconPath = "/Game/UI/Texture/Dynamic/Atlas/Skill/T_Skill_Ray.T_Skill_Ray",
		UsingIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Icon_CentralSquare_Unequip01.T_Icon_CentralSquare_Unequip01",
	},
	[42002] = {
		BPPath = "Blueprint'/Game/BluePrints/Combat/PropEffect/PropEffectObject_42002.PropEffectObject_42002'",
		Id = 42002,
		ReplaceShootIconPath = "/Game/UI/Texture/Dynamic/Atlas/Skill/T_Skill_Blow.T_Skill_Blow",
		ReplaceSupportIconPath = "/Game/UI/Texture/Dynamic/Atlas/Skill/T_Skill_Pet_EastScan.T_Skill_Pet_EastScan",
		UsingIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Icon_CentralSquare_Unequip.T_Icon_CentralSquare_Unequip",
	},
	[49996] = {
		Id = 49996,
		UsingIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_Gesture_0402.T_Mounts_Gesture_0402",
	},
	[49997] = {
		Id = 49997,
		UsingIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_Gesture_0302.T_Mounts_Gesture_0302",
	},
	[49998] = {
		Id = 49998,
		UsingIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_Gesture_0102.T_Mounts_Gesture_0102",
	},
	[49999] = {
		Id = 49999,
		UsingIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_Gesture_0202.T_Mounts_Gesture_0202",
	},
})