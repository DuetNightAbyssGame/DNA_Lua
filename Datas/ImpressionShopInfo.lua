-- Source Excel file path: ..\datas\Talk\ImpressionShop.xlsx
local T = {}
T.RT_1 = {
		3001,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ImpressionShopInfo", {
	[1011] = {
		ImpressionShopRegionId = 1011,
		PlaySystemUIBGM = "event:/bgm/1_0/0084_system_shop_danjiao",
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Impression.WBP_Shop_BG_Impression'",
		ShopName = "UI_ImpressionShop_ShopName",
		TabCoin = T.RT_1,
	},
	[1041] = {
		ImpressionShopRegionId = 1041,
		PlaySystemUIBGM = "event:/bgm/1_0/0084_system_shop_danjiao",
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Impression.WBP_Shop_BG_Impression'",
		ShopName = "UI_ImpressionShop_ShopName",
		ShopUnlockRuleId = 12010101,
		TabCoin = T.RT_1,
	},
})