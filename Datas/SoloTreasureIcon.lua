-- Source Excel file path: ..\datas\Dungeons\SoloTreasure.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SoloTreasureIcon", {
	[1] = {
		Mechanism = {
			131073,
		},
		SoloTreasureIconId = 1,
		SoloTreasureIconText = "UI_SoloTreasure_EvacuationPoint_Title",
		SoloTreasureIconType = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_EvacuationPoint.T_Gp_EvacuationPoint",
	},
	[2] = {
		Mechanism = {
			131071,
		},
		MechanismState = {
			1310712,
		},
		SoloTreasureIconId = 2,
		SoloTreasureIconText = "UI_SoloTreasure_GuardContainer_Title",
		SoloTreasureIconType = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_GuardContainer.T_Gp_GuardContainer",
	},
	[3] = {
		Mechanism = {
			131072,
		},
		MechanismState = {
			1310663,
		},
		SoloTreasureIconId = 3,
		SoloTreasureIconText = "UI_SoloTreasure_RainyHighValueItem_Title",
		SoloTreasureIconType = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_RainyHighValueItem.T_Gp_RainyHighValueItem",
	},
	[4] = {
		Mechanism = {
			131069,
		},
		MechanismState = {
			1310692,
		},
		SoloTreasureIconId = 4,
		SoloTreasureIconText = "UI_SoloTreasure_SacrificeContainer_Title",
		SoloTreasureIconType = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SacrificeContainer.T_Gp_SacrificeContainer",
	},
	[5] = {
		Mechanism = {
			131070,
			131082,
			131083,
		},
		MechanismState = {
			1310702,
		},
		SoloTreasureIconId = 5,
		SoloTreasureIconText = "UI_SoloTreasure_TreasureRoom_Title",
		SoloTreasureIconType = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_TreasureRoom.T_Gp_TreasureRoom",
	},
	[6] = {
		Mechanism = {
			131065,
			131066,
		},
		MechanismState = {
			1310663,
			1310663,
		},
		SoloTreasureIconId = 6,
		SoloTreasureIconText = "UI_SoloTreasure_HighValueItem_Title",
		SoloTreasureIconType = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_HighValueItem.T_Gp_HighValueItem",
	},
	[7] = {
		Mechanism = {
			92001,
		},
		MechanismState = {
			900000,
			900001,
		},
		SoloTreasureIconId = 7,
		SoloTreasureIconText = "UI_SoloTreasure_GachaMachine_Title",
		SoloTreasureIconType = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_GachaMachine.T_Gp_GachaMachine",
	},
})