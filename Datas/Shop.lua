-- Source Excel file path: ..\datas\Shop.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("Shop", {
	AbyssShop = {
		MainTabId = {
			10000,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Abyss.WBP_Shop_BG_Abyss'",
		ShopName = "Abyss_ExchangeStore",
		ShopUIName = "ShopActivity",
		SystemName = "AbyssShop",
	},
	AccessoryDropShop = {
		MainTabId = {
			10008,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Normal.WBP_Shop_BG_Normal'",
		ShopName = "Event_FreeAppearance_tittle01",
		ShopUIName = "ShopActivity",
		SystemName = "AccessoryDropShop",
	},
	AutoChessShop = {
		MainTabId = {
			10006,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/AutoChess/WBP_Activity_AutoChess_OverViewBG.WBP_Activity_AutoChess_OverViewBG'",
		ShopName = "UI_AutoChess_ShopName",
		ShopUIName = "ShopActivity",
		SystemName = "AutoChessShop",
	},
	ExploreBadgeShop = {
		MainTabId = {
			701,
			702,
			703,
			704,
			705,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Area.WBP_Shop_BG_Area'",
		ShopName = "UI_SHOP_ExploreBadge",
		ShopUIName = "ShopActivity",
		SpawnNPCId = 920005,
		SystemName = "ExploreBadgeShop",
	},
	FishingShop = {
		MainTabId = {
			801,
			802,
		},
		PlaySystemUIBGM = "event:/bgm/cbt03/0082_system_fishing",
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Fishing.WBP_Shop_BG_Fishing'",
		ShopName = "UI_SHOP_Fishing",
		ShopUIName = "ShopActivity",
		SpawnNPCId = 900010,
		SystemName = "FishingShop",
	},
	GiftShop = {
		MainTabId = {
			90001,
			90002,
			90003,
		},
		PlaySystemUIBGM = "event:/bgm/1_0/0083_system_shop_normal",
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Normal.WBP_Shop_BG_Normal'",
		ShopName = "MAIN_UI_SHOP",
		ShopUIName = "ShopMain",
		SystemName = "GiftShop",
	},
	HuaxuEventShop = {
		MainTabId = {
			10001,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Abyss.WBP_Shop_BG_Abyss'",
		ShopName = "HuaxuEventShop",
		ShopUIName = "ShopActivity",
		SystemName = "HuaxuEventShop",
	},
	HuaxuExploreShop = {
		MainTabId = {
			10005,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Dongguo.WBP_Shop_BG_Dongguo'",
		ShopName = "HuaxuExploreShop",
		ShopUIName = "ShopActivity",
		SystemName = "HuaxuExploreShop",
	},
	RaidShopSeason01 = {
		MainTabId = {
			10004,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/Shop/ShopBG/WBP_Activity_Shop_BG_GuildWar.WBP_Activity_Shop_BG_GuildWar'",
		ShopName = "RaidDungeon_Shop_Name",
		ShopUIName = "ShopActivity",
		SystemName = "RaidShopSeason01",
	},
	Rouge = {
		MainTabId = {
			10002,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Rouge.WBP_Shop_BG_Rouge'",
		ShopName = "Rouge_ExchangeShop",
		ShopUIName = "ShopActivity",
		SystemName = "Rouge",
	},
	Shop = {
		MainTabId = {
			170,
			160,
			150,
			180,
			140,
			120,
			110,
			200,
		},
		PlaySystemUIBGM = "event:/bgm/1_0/0083_system_shop_normal",
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Normal.WBP_Shop_BG_Normal'",
		ShopName = "MAIN_UI_SHOP",
		ShopUIName = "ShopMain",
		SpawnNPCId = 900002,
		SystemName = "Shop",
	},
	SoloTreasureShop = {
		MainTabId = {
			10007,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_SoloTreasure.WBP_Shop_BG_SoloTreasure'",
		ShopName = "UI_SoloTreasureShop",
		ShopUIName = "ShopActivity",
		SystemName = "SoloTreasureShop",
	},
	WeeklyDungeonShop = {
		MainTabId = {
			10003,
		},
		ShopBgBPPath = "WidgetBlueprint'/Game/UI/WBP/Shop/Widget/BG/WBP_Shop_BG_Mod.WBP_Shop_BG_Mod'",
		ShopName = "WeeklyDungeonShop",
		ShopUIName = "ShopActivity",
		SystemName = "WeeklyDungeonShop",
	},
})