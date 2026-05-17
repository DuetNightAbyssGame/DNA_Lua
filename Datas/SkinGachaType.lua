-- Source Excel file path: ..\datas\SkinGacha.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("SkinGachaType", {
	GACHA_SKIN_TYPE_NORMAL = {
		GachaGuaranteeDes = "UI_SkinGacha_Guarantee_Normal",
		GachaType = "GACHA_SKIN_TYPE_NORMAL",
		GachaTypeName = "UI_SkinGacha_Normal",
		SubTabId = 1402,
	},
	GACHA_SKIN_TYPE_SPECIAL = {
		GachaGuaranteeDes = "UI_SkinGacha_Guarantee_Normal",
		GachaType = "GACHA_SKIN_TYPE_SPECIAL",
		GachaTypeName = "UI_SkinGacha_Special",
		SubTabId = 1401,
	},
	GACHA_SKIN_TYPE_SPECIAL_2 = {
		GachaGuaranteeDes = "UI_SkinGacha_Guarantee_Normal",
		GachaType = "GACHA_SKIN_TYPE_SPECIAL_2",
		GachaTypeName = "UI_SkinGacha_Special",
		SubTabId = 1401,
	},
	GACHA_SKIN_TYPE_SPECIAL_3 = {
		GachaGuaranteeDes = "UI_SkinGacha_Guarantee_Normal",
		GachaType = "GACHA_SKIN_TYPE_SPECIAL_3",
		GachaTypeName = "UI_SkinGacha_Special",
		SubTabId = 1401,
	},
	GACHA_SKIN_TYPE_SPECIAL_4 = {
		GachaGuaranteeDes = "UI_SkinGacha_Guarantee_Normal",
		GachaType = "GACHA_SKIN_TYPE_SPECIAL_4",
		GachaTypeName = "UI_SkinGacha_Special",
		SubTabId = 1401,
	},
})