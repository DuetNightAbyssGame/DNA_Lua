-- Source Excel file path: ..\datas\Talk\ImpressionShop.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ImpressionShopMainTab", {
	[1] = {
		Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_IceLake.T_Tab_IceLake",
		MainName = "UI_ImpressionShop_ShopName_1011",
		MainTabId = 1,
		RegionId = 1011,
	},
	[2] = {
		Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_East_Season01.T_Tab_East_Season01",
		MainName = "UI_ImpressionShop_ShopName_1041",
		MainTabId = 2,
		RegionId = 1041,
	},
})