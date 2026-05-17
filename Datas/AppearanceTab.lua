-- Source Excel file path: ..\datas\Tab\ArmoryTab.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AppearanceTab", {
	[1] = {
		IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Clothing.T_Tab_Fashion_Clothing'",
		TabId = 1,
		Text = "UI_Skin_Name",
	},
	[2] = {
		IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Hair.T_Tab_Fashion_Hair'",
		TabId = 2,
		Text = "UI_Hair_Name",
	},
	[3] = {
		IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Accessory.T_Tab_Accessory'",
		TabId = 3,
		Text = "UI_Armory_Dress",
	},
	[4] = {
		IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_MVP.T_Tab_Fashion_MVP'",
		TabId = 4,
		Text = "UI_SkinPreview_Accessory_MVP",
	},
	[5] = {
		IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Accessory.T_Tab_Accessory'",
		TabId = 5,
		Text = "UI_Weapon_StanceFX",
	},
})