-- Source Excel file path: ..\datas\PreloadCommonAsset.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CommonAsset", {
	All = {
		AssetPath = {
			[1] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Battle/PC/WBP_Battle_Interactive_P.WBP_Battle_Interactive_P_C'",
				PlatformName = "PC",
			},
			[2] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/WBP_Battle_Interactive_M.WBP_Battle_Interactive_M_C'",
				PlatformName = "Mobile",
			},
			[3] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Common/WBP_Com_BlackScreen.WBP_Com_BlackScreen'",
			},
			[4] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Battle/Widget/Drops/WBP_Battle_SpecialDrops.WBP_Battle_SpecialDrops_C'",
			},
			[5] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Battle/Widget/Drops/WBP_Battle_Drops.WBP_Battle_Drops_C'",
			},
			[6] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Battle/Widget/Drops/WBP_Battle_DropItem.WBP_Battle_DropItem_C'",
			},
			[7] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Common/Toast/PC/WBP_Com_ToastList_P.WBP_Com_ToastList_P_C'",
				PlatformName = "PC",
			},
			[8] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Common/Toast/Mobile/WBP_Com_ToastList_M.WBP_Com_ToastList_M_C'",
				PlatformName = "Mobile",
			},
			[9] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Battle/PC/WBP_Battle_HookLock_P.WBP_Battle_HookLock_P'",
				PlatformName = "PC",
			},
			[10] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_HookLock_M.WBP_Battle_HookLock_M'",
				PlatformName = "Mobile",
			},
			[11] = {
				Path = "PhysicsAsset'/Game/Asset/Char/Player/Common/AssetPhysics/PHYS_Player_Culling.PHYS_Player_Culling'",
			},
			[12] = {
				Path = "PhysicsAsset'/Game/Asset/Char/Player/Common/AssetPhysics/PHYS_Player_CapsuleShadow.PHYS_Player_CapsuleShadow'",
			},
		},
		Type = "All",
	},
	Dungeon = {
		AssetPath = {
			[1] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/Settlement/Widget/WBP_Settlement_BlackScreen.WBP_Settlement_BlackScreen'",
			},
		},
		Type = "Dungeon",
	},
	Region = {
		AssetPath = {
			[1] = {
				Path = "WidgetBlueprint'/Game/UI/WBP/World/NPC/Widget/WBP_NPC_UniformHeadWidget.WBP_NPC_UniformHeadWidget'",
			},
		},
		Type = "Region",
	},
})