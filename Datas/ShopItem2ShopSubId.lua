local T = {}
T.RT_1 = {
}
T.RT_2 = {
	["AbyssShop"] = T.RT_1,
	["AccessoryDropShop"] = T.RT_1,
	["AutoChessShop"] = T.RT_1,
	["ExploreBadgeShop"] = T.RT_1,
	["FishingShop"] = T.RT_1,
	["GiftShop"] = T.RT_1,
	["HuaxuEventShop"] = T.RT_1,
	["HuaxuExploreShop"] = T.RT_1,
	["RaidShopSeason01"] = T.RT_1,
	["Rouge"] = T.RT_1,
	["Shop"] = T.RT_1,
	["SoloTreasureShop"] = T.RT_1,
	["WeeklyDungeonShop"] = T.RT_1,
}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ShopItem2ShopSubId", {
	["Char"] = T.RT_2,
	["CharAccessory"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = {
			[10011] = {
				[1] = {
					["ShopItemId"] = 10006103,
					["SubTabId"] = 100061,
				},
			},
			[12123] = {
				[1] = {
					["ShopItemId"] = 10006102,
					["SubTabId"] = 100061,
				},
			},
			[13012] = {
				[1] = {
					["ShopItemId"] = 10006104,
					["SubTabId"] = 100061,
				},
			},
		},
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[10009] = {
				[1] = {
					["ShopItemId"] = 140106,
					["SubTabId"] = 1402,
				},
			},
			[10010] = {
				[1] = {
					["ShopItemId"] = 120202,
					["SubTabId"] = 1210,
				},
			},
			[10012] = {
				[1] = {
					["ShopItemId"] = 140104,
					["SubTabId"] = 1402,
				},
			},
			[10013] = {
				[1] = {
					["ShopItemId"] = 120203,
					["SubTabId"] = 1210,
				},
				[2] = {
					["ShopItemId"] = 140105,
					["SubTabId"] = 1402,
				},
			},
			[10015] = {
				[1] = {
					["ShopItemId"] = 120219,
					["SubTabId"] = 1210,
				},
			},
			[10016] = {
				[1] = {
					["ShopItemId"] = 120213,
					["SubTabId"] = 1210,
				},
			},
			[10017] = {
				[1] = {
					["ShopItemId"] = 120212,
					["SubTabId"] = 1210,
				},
			},
			[10018] = {
				[1] = {
					["ShopItemId"] = 120211,
					["SubTabId"] = 1210,
				},
			},
			[10031] = {
				[1] = {
					["ShopItemId"] = 120220,
					["SubTabId"] = 1210,
				},
			},
			[10035] = {
				[1] = {
					["ShopItemId"] = 120217,
					["SubTabId"] = 1210,
				},
			},
			[10036] = {
				[1] = {
					["ShopItemId"] = 120225,
					["SubTabId"] = 1210,
				},
			},
			[10037] = {
				[1] = {
					["ShopItemId"] = 120214,
					["SubTabId"] = 1210,
				},
			},
			[10038] = {
				[1] = {
					["ShopItemId"] = 120215,
					["SubTabId"] = 1210,
				},
			},
			[10039] = {
				[1] = {
					["ShopItemId"] = 120216,
					["SubTabId"] = 1210,
				},
			},
			[10040] = {
				[1] = {
					["ShopItemId"] = 120204,
					["SubTabId"] = 1210,
				},
			},
			[10041] = {
				[1] = {
					["ShopItemId"] = 120205,
					["SubTabId"] = 1210,
				},
			},
			[10042] = {
				[1] = {
					["ShopItemId"] = 120206,
					["SubTabId"] = 1210,
				},
			},
			[10043] = {
				[1] = {
					["ShopItemId"] = 120207,
					["SubTabId"] = 1210,
				},
			},
			[10044] = {
				[1] = {
					["ShopItemId"] = 120208,
					["SubTabId"] = 1210,
				},
			},
			[10045] = {
				[1] = {
					["ShopItemId"] = 120209,
					["SubTabId"] = 1210,
				},
			},
			[10046] = {
				[1] = {
					["ShopItemId"] = 120218,
					["SubTabId"] = 1210,
				},
			},
			[10047] = {
				[1] = {
					["ShopItemId"] = 140107,
					["SubTabId"] = 1402,
				},
			},
			[10048] = {
				[1] = {
					["ShopItemId"] = 140108,
					["SubTabId"] = 1402,
				},
			},
			[10049] = {
				[1] = {
					["ShopItemId"] = 120224,
					["SubTabId"] = 1210,
				},
			},
			[10050] = {
				[1] = {
					["ShopItemId"] = 120201,
					["SubTabId"] = 1210,
				},
			},
			[10053] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140243,
					["SubTabId"] = 1401,
				},
			},
			[10054] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140244,
					["SubTabId"] = 1401,
				},
			},
			[10055] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140245,
					["SubTabId"] = 1401,
				},
			},
			[10056] = {
				[1] = {
					["ShopItemId"] = 120226,
					["SubTabId"] = 1210,
				},
			},
			[10057] = {
				[1] = {
					["ShopItemId"] = 120230,
					["SubTabId"] = 1210,
				},
			},
			[10058] = {
				[1] = {
					["ShopItemId"] = 120221,
					["SubTabId"] = 1210,
				},
			},
			[10059] = {
				[1] = {
					["ShopItemId"] = 120222,
					["SubTabId"] = 1210,
				},
			},
			[10060] = {
				[1] = {
					["ShopItemId"] = 120223,
					["SubTabId"] = 1210,
				},
			},
			[10061] = {
				[1] = {
					["ShopItemId"] = 120228,
					["SubTabId"] = 1210,
				},
			},
			[10062] = {
				[1] = {
					["ShopItemId"] = 120229,
					["SubTabId"] = 1210,
				},
			},
			[10063] = {
				[1] = {
					["ShopItemId"] = 120227,
					["SubTabId"] = 1210,
				},
			},
			[10064] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140246,
					["SubTabId"] = 1401,
				},
			},
			[10065] = {
				[1] = {
					["ShopItemId"] = 120232,
					["SubTabId"] = 1210,
				},
			},
			[10066] = {
				[1] = {
					["ShopItemId"] = 120231,
					["SubTabId"] = 1210,
				},
			},
			[10067] = {
				[1] = {
					["ShopItemId"] = 120233,
					["SubTabId"] = 1210,
				},
			},
			[10068] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140274,
					["SubTabId"] = 1401,
				},
			},
			[10069] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140275,
					["SubTabId"] = 1401,
				},
			},
			[10070] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140276,
					["SubTabId"] = 1401,
				},
			},
			[10071] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140277,
					["SubTabId"] = 1401,
				},
			},
			[10073] = {
				[1] = {
					["ShopItemId"] = 120235,
					["SubTabId"] = 1210,
				},
			},
			[10074] = {
				[1] = {
					["ShopItemId"] = 120236,
					["SubTabId"] = 1210,
				},
			},
			[10075] = {
				[1] = {
					["ShopItemId"] = 120237,
					["SubTabId"] = 1210,
				},
			},
			[10076] = {
				[1] = {
					["ShopItemId"] = 120333,
					["SubTabId"] = 1210,
				},
			},
			[10077] = {
				[1] = {
					["ShopItemId"] = 120332,
					["SubTabId"] = 1210,
				},
			},
			[10078] = {
				[1] = {
					["ShopItemId"] = 120331,
					["SubTabId"] = 1210,
				},
			},
			[10079] = {
				[1] = {
					["ShopItemId"] = 120335,
					["SubTabId"] = 1210,
				},
			},
			[10080] = {
				[1] = {
					["ShopItemId"] = 120234,
					["SubTabId"] = 1210,
				},
			},
			[10081] = {
				[1] = {
					["ShopItemId"] = 120238,
					["SubTabId"] = 1210,
				},
			},
			[10082] = {
				[1] = {
					["ShopItemId"] = 120239,
					["SubTabId"] = 1210,
				},
			},
			[10083] = {
				[1] = {
					["ShopItemId"] = 120243,
					["SubTabId"] = 1210,
				},
			},
			[10084] = {
				[1] = {
					["ShopItemId"] = 120240,
					["SubTabId"] = 1210,
				},
			},
			[10085] = {
				[1] = {
					["ShopItemId"] = 120241,
					["SubTabId"] = 1210,
				},
			},
			[10086] = {
				[1] = {
					["ShopItemId"] = 120242,
					["SubTabId"] = 1210,
				},
			},
			[10094] = {
				[1] = {
					["ShopItemId"] = 120351,
					["SubTabId"] = 1210,
				},
			},
			[10095] = {
				[1] = {
					["ShopItemId"] = 120352,
					["SubTabId"] = 1210,
				},
			},
			[10097] = {
				[1] = {
					["ShopItemId"] = 120353,
					["SubTabId"] = 1210,
				},
			},
			[10102] = {
				[1] = {
					["ShopItemId"] = 120358,
					["SubTabId"] = 1210,
				},
			},
			[10103] = {
				[1] = {
					["ShopItemId"] = 120359,
					["SubTabId"] = 1210,
				},
			},
			[10104] = {
				[1] = {
					["ShopItemId"] = 120360,
					["SubTabId"] = 1210,
				},
			},
			[10105] = {
				[1] = {
					["ShopItemId"] = 120361,
					["SubTabId"] = 1210,
				},
			},
			[11002] = {
				[1] = {
					["ShopItemId"] = 120702,
					["SubTabId"] = 1212,
				},
			},
			[11003] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140242,
					["SubTabId"] = 1401,
				},
			},
			[11004] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140287,
					["SubTabId"] = 1401,
				},
			},
			[12001] = {
				[1] = {
					["ShopItemId"] = 1210001,
					["SubTabId"] = 1210,
				},
			},
			[12002] = {
				[1] = {
					["ShopItemId"] = 1210002,
					["SubTabId"] = 1210,
				},
			},
			[12003] = {
				[1] = {
					["ShopItemId"] = 1210003,
					["SubTabId"] = 1210,
				},
			},
			[12004] = {
				[1] = {
					["ShopItemId"] = 1210004,
					["SubTabId"] = 1210,
				},
			},
			[12005] = {
				[1] = {
					["ShopItemId"] = 120343,
					["SubTabId"] = 1210,
				},
			},
			[12006] = {
				[1] = {
					["ShopItemId"] = 120344,
					["SubTabId"] = 1210,
				},
			},
			[12007] = {
				[1] = {
					["ShopItemId"] = 120345,
					["SubTabId"] = 1210,
				},
			},
			[12008] = {
				[1] = {
					["ShopItemId"] = 120346,
					["SubTabId"] = 1210,
				},
			},
			[12122] = {
				[1] = {
					["ShopItemId"] = 1209001,
					["SubTabId"] = 1210,
				},
			},
			[12124] = {
				[1] = {
					["ShopItemId"] = 1209002,
					["SubTabId"] = 1210,
				},
			},
			[12127] = {
				[1] = {
					["ShopItemId"] = 120347,
					["SubTabId"] = 1210,
				},
			},
			[12128] = {
				[1] = {
					["ShopItemId"] = 120348,
					["SubTabId"] = 1210,
				},
			},
			[12129] = {
				[1] = {
					["ShopItemId"] = 120349,
					["SubTabId"] = 1210,
				},
			},
			[12130] = {
				[1] = {
					["ShopItemId"] = 120350,
					["SubTabId"] = 1210,
				},
			},
			[13002] = {
				[1] = {
					["ShopItemId"] = 1211001,
					["SubTabId"] = 1211,
				},
			},
			[13003] = {
				[1] = {
					["ShopItemId"] = 1211002,
					["SubTabId"] = 1211,
				},
			},
			[13004] = {
				[1] = {
					["ShopItemId"] = 1211003,
					["SubTabId"] = 1211,
				},
			},
			[13005] = {
				[1] = {
					["ShopItemId"] = 120416,
					["SubTabId"] = 1211,
				},
			},
			[13006] = {
				[1] = {
					["ShopItemId"] = 120417,
					["SubTabId"] = 1211,
				},
			},
			[13007] = {
				[1] = {
					["ShopItemId"] = 120418,
					["SubTabId"] = 1211,
				},
			},
			[13008] = {
				[1] = {
					["ShopItemId"] = 120419,
					["SubTabId"] = 1211,
				},
			},
			[13009] = {
				[1] = {
					["ShopItemId"] = 140156,
					["SubTabId"] = 1402,
				},
			},
			[13010] = {
				[1] = {
					["ShopItemId"] = 140157,
					["SubTabId"] = 1402,
				},
			},
			[13011] = {
				[1] = {
					["ShopItemId"] = 140158,
					["SubTabId"] = 1402,
				},
			},
			[13013] = {
				[1] = {
					["ShopItemId"] = 1211005,
					["SubTabId"] = 1211,
				},
			},
			[13014] = {
				[1] = {
					["ShopItemId"] = 1211009,
					["SubTabId"] = 1211,
				},
			},
			[13015] = {
				[1] = {
					["ShopItemId"] = 1211010,
					["SubTabId"] = 1211,
				},
			},
			[13016] = {
				[1] = {
					["ShopItemId"] = 1211011,
					["SubTabId"] = 1211,
				},
			},
			[13017] = {
				[1] = {
					["ShopItemId"] = 1211004,
					["SubTabId"] = 1211,
				},
			},
			[13018] = {
				[1] = {
					["ShopItemId"] = 1211006,
					["SubTabId"] = 1211,
				},
			},
			[13019] = {
				[1] = {
					["ShopItemId"] = 1211007,
					["SubTabId"] = 1211,
				},
			},
			[13020] = {
				[1] = {
					["ShopItemId"] = 1211008,
					["SubTabId"] = 1211,
				},
			},
			[13021] = {
				[1] = {
					["ShopItemId"] = 1211012,
					["SubTabId"] = 1211,
				},
			},
			[13023] = {
				[1] = {
					["ShopItemId"] = 1211013,
					["SubTabId"] = 1211,
				},
			},
			[13024] = {
				[1] = {
					["ShopItemId"] = 1211014,
					["SubTabId"] = 1211,
				},
				[2] = {
					["ShopItemId"] = 1211018,
					["SubTabId"] = 1211,
				},
			},
			[13025] = {
				[1] = {
					["ShopItemId"] = 1211026,
					["SubTabId"] = 1211,
				},
			},
			[13026] = {
				[1] = {
					["ShopItemId"] = 1211027,
					["SubTabId"] = 1211,
				},
			},
			[13027] = {
				[1] = {
					["ShopItemId"] = 1211028,
					["SubTabId"] = 1211,
				},
			},
			[13028] = {
				[1] = {
					["ShopItemId"] = 1211029,
					["SubTabId"] = 1211,
				},
			},
			[20005] = {
				[1] = {
					["ShopItemId"] = 120305,
					["SubTabId"] = 1210,
				},
			},
			[20006] = {
				[1] = {
					["ShopItemId"] = 120306,
					["SubTabId"] = 1210,
				},
			},
			[20007] = {
				[1] = {
					["ShopItemId"] = 140111,
					["SubTabId"] = 1402,
				},
			},
			[20016] = {
				[1] = {
					["ShopItemId"] = 120303,
					["SubTabId"] = 1210,
				},
			},
			[20017] = {
				[1] = {
					["ShopItemId"] = 120304,
					["SubTabId"] = 1210,
				},
			},
			[20018] = {
				[1] = {
					["ShopItemId"] = 140109,
					["SubTabId"] = 1402,
				},
			},
			[20019] = {
				[1] = {
					["ShopItemId"] = 140110,
					["SubTabId"] = 1402,
				},
			},
			[20027] = {
				[1] = {
					["ShopItemId"] = 140115,
					["SubTabId"] = 1402,
				},
			},
			[20028] = {
				[1] = {
					["ShopItemId"] = 140114,
					["SubTabId"] = 1402,
				},
			},
			[20029] = {
				[1] = {
					["ShopItemId"] = 120301,
					["SubTabId"] = 1210,
				},
			},
			[20031] = {
				[1] = {
					["ShopItemId"] = 140113,
					["SubTabId"] = 1402,
				},
			},
			[20032] = {
				[1] = {
					["ShopItemId"] = 140112,
					["SubTabId"] = 1402,
				},
			},
			[20033] = {
				[1] = {
					["ShopItemId"] = 120302,
					["SubTabId"] = 1210,
				},
			},
			[20034] = {
				[1] = {
					["ShopItemId"] = 140117,
					["SubTabId"] = 1402,
				},
			},
			[20036] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140203,
					["SubTabId"] = 1401,
				},
			},
			[20037] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140204,
					["SubTabId"] = 1401,
				},
			},
			[20038] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140205,
					["SubTabId"] = 1401,
				},
			},
			[20039] = {
				[1] = {
					["ShopItemId"] = 140116,
					["SubTabId"] = 1402,
				},
			},
			[20040] = {
				[1] = {
					["ShopItemId"] = 120307,
					["SubTabId"] = 1210,
				},
			},
			[20041] = {
				[1] = {
					["ShopItemId"] = 120311,
					["SubTabId"] = 1210,
				},
			},
			[20042] = {
				[1] = {
					["ShopItemId"] = 120312,
					["SubTabId"] = 1210,
				},
			},
			[20043] = {
				[1] = {
					["ShopItemId"] = 120317,
					["SubTabId"] = 1210,
				},
			},
			[20045] = {
				[1] = {
					["ShopItemId"] = 120308,
					["SubTabId"] = 1210,
				},
			},
			[20046] = {
				[1] = {
					["ShopItemId"] = 120309,
					["SubTabId"] = 1210,
				},
			},
			[20047] = {
				[1] = {
					["ShopItemId"] = 120310,
					["SubTabId"] = 1210,
				},
			},
			[20049] = {
				[1] = {
					["ShopItemId"] = 120314,
					["SubTabId"] = 1210,
				},
			},
			[20050] = {
				[1] = {
					["ShopItemId"] = 120315,
					["SubTabId"] = 1210,
				},
			},
			[20051] = {
				[1] = {
					["ShopItemId"] = 120313,
					["SubTabId"] = 1210,
				},
			},
			[20055] = {
				[1] = {
					["ShopItemId"] = 120336,
					["SubTabId"] = 1210,
				},
			},
			[20056] = {
				[1] = {
					["ShopItemId"] = 120337,
					["SubTabId"] = 1210,
				},
			},
			[20058] = {
				[1] = {
					["ShopItemId"] = 120338,
					["SubTabId"] = 1210,
				},
			},
			[20063] = {
				[1] = {
					["ShopItemId"] = 120325,
					["SubTabId"] = 1210,
				},
			},
			[20064] = {
				[1] = {
					["ShopItemId"] = 120326,
					["SubTabId"] = 1210,
				},
			},
			[20065] = {
				[1] = {
					["ShopItemId"] = 120327,
					["SubTabId"] = 1210,
				},
			},
			[20066] = {
				[1] = {
					["ShopItemId"] = 120334,
					["SubTabId"] = 1210,
				},
			},
			[20067] = {
				[1] = {
					["ShopItemId"] = 120328,
					["SubTabId"] = 1210,
				},
			},
			[20068] = {
				[1] = {
					["ShopItemId"] = 120329,
					["SubTabId"] = 1210,
				},
			},
			[20069] = {
				[1] = {
					["ShopItemId"] = 120330,
					["SubTabId"] = 1210,
				},
			},
			[20070] = {
				[1] = {
					["ShopItemId"] = 120316,
					["SubTabId"] = 1210,
				},
			},
			[20071] = {
				[1] = {
					["ShopItemId"] = 120322,
					["SubTabId"] = 1210,
				},
			},
			[20072] = {
				[1] = {
					["ShopItemId"] = 120323,
					["SubTabId"] = 1210,
				},
			},
			[20073] = {
				[1] = {
					["ShopItemId"] = 120324,
					["SubTabId"] = 1210,
				},
			},
			[20074] = {
				[1] = {
					["ShopItemId"] = 120318,
					["SubTabId"] = 1210,
				},
			},
			[20075] = {
				[1] = {
					["ShopItemId"] = 120319,
					["SubTabId"] = 1210,
				},
			},
			[20076] = {
				[1] = {
					["ShopItemId"] = 120320,
					["SubTabId"] = 1210,
				},
			},
			[20077] = {
				[1] = {
					["ShopItemId"] = 120321,
					["SubTabId"] = 1210,
				},
			},
			[20078] = {
				[1] = {
					["ShopItemId"] = 120354,
					["SubTabId"] = 1210,
				},
			},
			[20079] = {
				[1] = {
					["ShopItemId"] = 120355,
					["SubTabId"] = 1210,
				},
			},
			[20080] = {
				[1] = {
					["ShopItemId"] = 120356,
					["SubTabId"] = 1210,
				},
			},
			[20081] = {
				[1] = {
					["ShopItemId"] = 120357,
					["SubTabId"] = 1210,
				},
			},
			[21002] = {
				[1] = {
					["ShopItemId"] = 120701,
					["SubTabId"] = 1212,
				},
			},
			[21003] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140241,
					["SubTabId"] = 1401,
				},
			},
			[21004] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140286,
					["SubTabId"] = 1401,
				},
			},
			[30002] = {
				[1] = {
					["ShopItemId"] = 120401,
					["SubTabId"] = 1211,
				},
			},
			[30007] = {
				[1] = {
					["ShopItemId"] = 120402,
					["SubTabId"] = 1211,
				},
			},
			[30016] = {
				[1] = {
					["ShopItemId"] = 120413,
					["SubTabId"] = 1211,
				},
			},
			[30017] = {
				[1] = {
					["ShopItemId"] = 120403,
					["SubTabId"] = 1211,
				},
			},
			[30018] = {
				[1] = {
					["ShopItemId"] = 120407,
					["SubTabId"] = 1211,
				},
			},
			[30019] = {
				[1] = {
					["ShopItemId"] = 120412,
					["SubTabId"] = 1211,
				},
			},
			[30020] = {
				[1] = {
					["ShopItemId"] = 120414,
					["SubTabId"] = 1211,
				},
			},
			[30022] = {
				[1] = {
					["ShopItemId"] = 120404,
					["SubTabId"] = 1211,
				},
			},
			[30023] = {
				[1] = {
					["ShopItemId"] = 120405,
					["SubTabId"] = 1211,
				},
			},
			[30024] = {
				[1] = {
					["ShopItemId"] = 120406,
					["SubTabId"] = 1211,
				},
			},
			[30025] = {
				[1] = {
					["ShopItemId"] = 120408,
					["SubTabId"] = 1211,
				},
			},
			[30026] = {
				[1] = {
					["ShopItemId"] = 120410,
					["SubTabId"] = 1211,
				},
			},
			[30027] = {
				[1] = {
					["ShopItemId"] = 120409,
					["SubTabId"] = 1211,
				},
			},
			[30028] = {
				[1] = {
					["ShopItemId"] = 120421,
					["SubTabId"] = 1211,
				},
			},
			[30029] = {
				[1] = {
					["ShopItemId"] = 120422,
					["SubTabId"] = 1211,
				},
			},
			[30030] = {
				[1] = {
					["ShopItemId"] = 120420,
					["SubTabId"] = 1211,
				},
			},
			[30031] = {
				[1] = {
					["ShopItemId"] = 120415,
					["SubTabId"] = 1211,
				},
			},
			[30033] = {
				[1] = {
					["ShopItemId"] = 1211015,
					["SubTabId"] = 1211,
				},
				[2] = {
					["ShopItemId"] = 1211019,
					["SubTabId"] = 1211,
				},
			},
			[30034] = {
				[1] = {
					["ShopItemId"] = 1211016,
					["SubTabId"] = 1211,
				},
				[2] = {
					["ShopItemId"] = 1211020,
					["SubTabId"] = 1211,
				},
			},
			[30036] = {
				[1] = {
					["ShopItemId"] = 1211017,
					["SubTabId"] = 1211,
				},
				[2] = {
					["ShopItemId"] = 1211021,
					["SubTabId"] = 1211,
				},
			},
			[31001] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140267,
					["SubTabId"] = 1401,
				},
			},
			[31002] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140268,
					["SubTabId"] = 1401,
				},
			},
			[40001] = {
				[1] = {
					["ShopItemId"] = 120502,
					["SubTabId"] = 1211,
				},
			},
			[40002] = {
				[1] = {
					["ShopItemId"] = 120501,
					["SubTabId"] = 1211,
				},
			},
			[40005] = {
				[1] = {
					["ShopItemId"] = 140118,
					["SubTabId"] = 1402,
				},
			},
			[40009] = {
				[1] = {
					["ShopItemId"] = 120509,
					["SubTabId"] = 1211,
				},
			},
			[40011] = {
				[1] = {
					["ShopItemId"] = 120411,
					["SubTabId"] = 1211,
				},
			},
			[40012] = {
				[1] = {
					["ShopItemId"] = 120510,
					["SubTabId"] = 1211,
				},
			},
			[40014] = {
				[1] = {
					["ShopItemId"] = 120507,
					["SubTabId"] = 1211,
				},
			},
			[40015] = {
				[1] = {
					["ShopItemId"] = 120508,
					["SubTabId"] = 1211,
				},
			},
			[40016] = {
				[1] = {
					["ShopItemId"] = 120514,
					["SubTabId"] = 1211,
				},
			},
			[40017] = {
				[1] = {
					["ShopItemId"] = 120503,
					["SubTabId"] = 1211,
				},
			},
			[40018] = {
				[1] = {
					["ShopItemId"] = 120504,
					["SubTabId"] = 1211,
				},
			},
			[40019] = {
				[1] = {
					["ShopItemId"] = 120505,
					["SubTabId"] = 1211,
				},
			},
			[40020] = {
				[1] = {
					["ShopItemId"] = 120506,
					["SubTabId"] = 1211,
				},
			},
			[40021] = {
				[1] = {
					["ShopItemId"] = 120512,
					["SubTabId"] = 1211,
				},
			},
			[40022] = {
				[1] = {
					["ShopItemId"] = 120513,
					["SubTabId"] = 1211,
				},
			},
			[40023] = {
				[1] = {
					["ShopItemId"] = 120511,
					["SubTabId"] = 1211,
				},
			},
			[40024] = {
				[1] = {
					["ShopItemId"] = 120516,
					["SubTabId"] = 1211,
				},
			},
			[40025] = {
				[1] = {
					["ShopItemId"] = 120515,
					["SubTabId"] = 1211,
				},
			},
			[40029] = {
				[1] = {
					["ShopItemId"] = 120517,
					["SubTabId"] = 1211,
				},
			},
			[40030] = {
				[1] = {
					["ShopItemId"] = 120520,
					["SubTabId"] = 1211,
				},
			},
			[40031] = {
				[1] = {
					["ShopItemId"] = 120521,
					["SubTabId"] = 1211,
				},
			},
			[40032] = {
				[1] = {
					["ShopItemId"] = 120522,
					["SubTabId"] = 1211,
				},
			},
			[40033] = {
				[1] = {
					["ShopItemId"] = 120518,
					["SubTabId"] = 1211,
				},
			},
			[40038] = {
				[1] = {
					["ShopItemId"] = 120531,
					["SubTabId"] = 1211,
				},
			},
			[40039] = {
				[1] = {
					["ShopItemId"] = 120532,
					["SubTabId"] = 1211,
				},
			},
			[40040] = {
				[1] = {
					["ShopItemId"] = 120533,
					["SubTabId"] = 1211,
				},
			},
			[40041] = {
				[1] = {
					["ShopItemId"] = 120534,
					["SubTabId"] = 1211,
				},
			},
			[40042] = {
				[1] = {
					["ShopItemId"] = 120535,
					["SubTabId"] = 1211,
				},
			},
			[40043] = {
				[1] = {
					["ShopItemId"] = 120536,
					["SubTabId"] = 1211,
				},
			},
			[40044] = {
				[1] = {
					["ShopItemId"] = 120538,
					["SubTabId"] = 1211,
				},
			},
			[40045] = {
				[1] = {
					["ShopItemId"] = 120529,
					["SubTabId"] = 1211,
				},
			},
			[40046] = {
				[1] = {
					["ShopItemId"] = 120528,
					["SubTabId"] = 1211,
				},
			},
			[40047] = {
				[1] = {
					["ShopItemId"] = 120530,
					["SubTabId"] = 1211,
				},
			},
			[40048] = {
				[1] = {
					["ShopItemId"] = 120525,
					["SubTabId"] = 1211,
				},
			},
			[40049] = {
				[1] = {
					["ShopItemId"] = 120537,
					["SubTabId"] = 1211,
				},
			},
			[40050] = {
				[1] = {
					["ShopItemId"] = 120526,
					["SubTabId"] = 1211,
				},
			},
			[40051] = {
				[1] = {
					["ShopItemId"] = 120527,
					["SubTabId"] = 1211,
				},
			},
			[40052] = {
				[1] = {
					["ShopItemId"] = 120519,
					["SubTabId"] = 1211,
				},
			},
			[40053] = {
				[1] = {
					["ShopItemId"] = 120523,
					["SubTabId"] = 1211,
				},
			},
			[40054] = {
				[1] = {
					["ShopItemId"] = 120524,
					["SubTabId"] = 1211,
				},
			},
			[40060] = {
				[1] = {
					["ShopItemId"] = 1211022,
					["SubTabId"] = 1211,
				},
			},
			[40061] = {
				[1] = {
					["ShopItemId"] = 1211023,
					["SubTabId"] = 1211,
				},
			},
			[40062] = {
				[1] = {
					["ShopItemId"] = 1211024,
					["SubTabId"] = 1211,
				},
			},
			[40063] = {
				[1] = {
					["ShopItemId"] = 1211025,
					["SubTabId"] = 1211,
				},
			},
			[70001] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140219,
					["SubTabId"] = 1401,
				},
			},
			[70002] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140237,
					["SubTabId"] = 1401,
				},
			},
			[70003] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140282,
					["SubTabId"] = 1401,
				},
			},
			[70011] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140224,
					["SubTabId"] = 1401,
				},
			},
			[70012] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140225,
					["SubTabId"] = 1401,
				},
			},
			[70013] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140226,
					["SubTabId"] = 1401,
				},
			},
			[70021] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140238,
					["SubTabId"] = 1401,
				},
			},
			[70022] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140239,
					["SubTabId"] = 1401,
				},
			},
			[70023] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140240,
					["SubTabId"] = 1401,
				},
			},
			[70031] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140283,
					["SubTabId"] = 1401,
				},
			},
			[70032] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140285,
					["SubTabId"] = 1401,
				},
			},
			[70033] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140284,
					["SubTabId"] = 1401,
				},
			},
			[80001] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140206,
					["SubTabId"] = 1401,
				},
			},
			[80002] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140232,
					["SubTabId"] = 1401,
				},
			},
			[80003] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140278,
					["SubTabId"] = 1401,
				},
			},
			[80011] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140220,
					["SubTabId"] = 1401,
				},
			},
			[80012] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140223,
					["SubTabId"] = 1401,
				},
			},
			[80013] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140222,
					["SubTabId"] = 1401,
				},
			},
			[80021] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140233,
					["SubTabId"] = 1401,
				},
			},
			[80022] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140234,
					["SubTabId"] = 1401,
				},
			},
			[80023] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140235,
					["SubTabId"] = 1401,
				},
			},
			[80031] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140279,
					["SubTabId"] = 1401,
				},
			},
			[80032] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140280,
					["SubTabId"] = 1401,
				},
			},
			[80033] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140281,
					["SubTabId"] = 1401,
				},
			},
		},
		["SoloTreasureShop"] = {
			[10011] = {
				[1] = {
					["ShopItemId"] = 10007102,
					["SubTabId"] = 100071,
				},
			},
			[12123] = {
				[1] = {
					["ShopItemId"] = 10007101,
					["SubTabId"] = 100071,
				},
			},
			[13012] = {
				[1] = {
					["ShopItemId"] = 10007103,
					["SubTabId"] = 100071,
				},
			},
		},
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["Draft"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = {
			[154001] = {
				[1] = {
					["ShopItemId"] = 10002201,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002337,
					["SubTabId"] = 100022,
				},
			},
			[154002] = {
				[1] = {
					["ShopItemId"] = 10002202,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002338,
					["SubTabId"] = 100022,
				},
			},
			[154003] = {
				[1] = {
					["ShopItemId"] = 10002203,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002339,
					["SubTabId"] = 100022,
				},
			},
			[154004] = {
				[1] = {
					["ShopItemId"] = 10002204,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002340,
					["SubTabId"] = 100022,
				},
			},
			[154005] = {
				[1] = {
					["ShopItemId"] = 10002205,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002341,
					["SubTabId"] = 100022,
				},
			},
			[154006] = {
				[1] = {
					["ShopItemId"] = 10002206,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002342,
					["SubTabId"] = 100022,
				},
			},
			[154009] = {
				[1] = {
					["ShopItemId"] = 10002373,
					["SubTabId"] = 100022,
				},
			},
			[154101] = {
				[1] = {
					["ShopItemId"] = 10002207,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002343,
					["SubTabId"] = 100022,
				},
			},
			[154102] = {
				[1] = {
					["ShopItemId"] = 10002208,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002344,
					["SubTabId"] = 100022,
				},
			},
			[154103] = {
				[1] = {
					["ShopItemId"] = 10002209,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002345,
					["SubTabId"] = 100022,
				},
			},
			[154201] = {
				[1] = {
					["ShopItemId"] = 10002374,
					["SubTabId"] = 100022,
				},
			},
			[154202] = {
				[1] = {
					["ShopItemId"] = 10002375,
					["SubTabId"] = 100022,
				},
			},
			[154203] = {
				[1] = {
					["ShopItemId"] = 10002376,
					["SubTabId"] = 100022,
				},
			},
			[154204] = {
				[1] = {
					["ShopItemId"] = 10002377,
					["SubTabId"] = 100022,
				},
			},
			[154205] = {
				[1] = {
					["ShopItemId"] = 10002378,
					["SubTabId"] = 100022,
				},
			},
			[155001] = {
				[1] = {
					["ShopItemId"] = 10002301,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002355,
					["SubTabId"] = 100023,
				},
			},
			[155002] = {
				[1] = {
					["ShopItemId"] = 10002302,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002356,
					["SubTabId"] = 100023,
				},
			},
			[155003] = {
				[1] = {
					["ShopItemId"] = 10002303,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002357,
					["SubTabId"] = 100023,
				},
			},
			[155004] = {
				[1] = {
					["ShopItemId"] = 10002304,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002358,
					["SubTabId"] = 100023,
				},
			},
			[155005] = {
				[1] = {
					["ShopItemId"] = 10002305,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002359,
					["SubTabId"] = 100023,
				},
			},
			[155006] = {
				[1] = {
					["ShopItemId"] = 10002306,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002360,
					["SubTabId"] = 100023,
				},
			},
			[155101] = {
				[1] = {
					["ShopItemId"] = 10002307,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002361,
					["SubTabId"] = 100023,
				},
			},
			[155102] = {
				[1] = {
					["ShopItemId"] = 10002308,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002362,
					["SubTabId"] = 100023,
				},
			},
			[155103] = {
				[1] = {
					["ShopItemId"] = 10002309,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002363,
					["SubTabId"] = 100023,
				},
			},
			[1202003] = {
				[1] = {
					["ShopItemId"] = 10002112,
					["SubTabId"] = 100021,
				},
			},
			[1203001] = {
				[1] = {
					["ShopItemId"] = 10002113,
					["SubTabId"] = 100021,
				},
			},
			[1204001] = {
				[1] = {
					["ShopItemId"] = 10002114,
					["SubTabId"] = 100021,
				},
			},
		},
		["Shop"] = T.RT_1,
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = {
			[151411] = {
				[1] = {
					["ShopItemId"] = 10003101,
					["SubTabId"] = 100031,
				},
			},
			[151412] = {
				[1] = {
					["ShopItemId"] = 10003102,
					["SubTabId"] = 100031,
				},
			},
			[151413] = {
				[1] = {
					["ShopItemId"] = 10003103,
					["SubTabId"] = 100031,
				},
			},
			[151414] = {
				[1] = {
					["ShopItemId"] = 10003104,
					["SubTabId"] = 100031,
				},
			},
			[151415] = {
				[1] = {
					["ShopItemId"] = 10003105,
					["SubTabId"] = 100031,
				},
			},
			[151421] = {
				[1] = {
					["ShopItemId"] = 10003106,
					["SubTabId"] = 100031,
				},
			},
			[151422] = {
				[1] = {
					["ShopItemId"] = 10003107,
					["SubTabId"] = 100031,
				},
			},
			[151423] = {
				[1] = {
					["ShopItemId"] = 10003108,
					["SubTabId"] = 100031,
				},
			},
			[151424] = {
				[1] = {
					["ShopItemId"] = 10003109,
					["SubTabId"] = 100031,
				},
			},
			[151425] = {
				[1] = {
					["ShopItemId"] = 10003110,
					["SubTabId"] = 100031,
				},
			},
			[151431] = {
				[1] = {
					["ShopItemId"] = 10003111,
					["SubTabId"] = 100031,
				},
			},
			[151432] = {
				[1] = {
					["ShopItemId"] = 10003112,
					["SubTabId"] = 100031,
				},
			},
			[151433] = {
				[1] = {
					["ShopItemId"] = 10003113,
					["SubTabId"] = 100031,
				},
			},
			[151434] = {
				[1] = {
					["ShopItemId"] = 10003114,
					["SubTabId"] = 100031,
				},
			},
			[151435] = {
				[1] = {
					["ShopItemId"] = 10003115,
					["SubTabId"] = 100031,
				},
			},
			[151441] = {
				[1] = {
					["ShopItemId"] = 10003116,
					["SubTabId"] = 100031,
				},
			},
			[151442] = {
				[1] = {
					["ShopItemId"] = 10003117,
					["SubTabId"] = 100031,
				},
			},
			[151443] = {
				[1] = {
					["ShopItemId"] = 10003118,
					["SubTabId"] = 100031,
				},
			},
			[151444] = {
				[1] = {
					["ShopItemId"] = 10003119,
					["SubTabId"] = 100031,
				},
			},
			[151445] = {
				[1] = {
					["ShopItemId"] = 10003120,
					["SubTabId"] = 100031,
				},
			},
			[151451] = {
				[1] = {
					["ShopItemId"] = 10003121,
					["SubTabId"] = 100031,
				},
			},
			[151452] = {
				[1] = {
					["ShopItemId"] = 10003122,
					["SubTabId"] = 100031,
				},
			},
			[151453] = {
				[1] = {
					["ShopItemId"] = 10003123,
					["SubTabId"] = 100031,
				},
			},
			[151454] = {
				[1] = {
					["ShopItemId"] = 10003124,
					["SubTabId"] = 100031,
				},
			},
			[151455] = {
				[1] = {
					["ShopItemId"] = 10003125,
					["SubTabId"] = 100031,
				},
			},
			[151461] = {
				[1] = {
					["ShopItemId"] = 10003126,
					["SubTabId"] = 100031,
				},
			},
			[151462] = {
				[1] = {
					["ShopItemId"] = 10003127,
					["SubTabId"] = 100031,
				},
			},
			[151463] = {
				[1] = {
					["ShopItemId"] = 10003128,
					["SubTabId"] = 100031,
				},
			},
			[151464] = {
				[1] = {
					["ShopItemId"] = 10003129,
					["SubTabId"] = 100031,
				},
			},
			[151465] = {
				[1] = {
					["ShopItemId"] = 10003130,
					["SubTabId"] = 100031,
				},
			},
		},
	},
	["Drop"] = T.RT_2,
	["Hair"] = T.RT_2,
	["HeadFrame"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[10022] = {
				[1] = {
					["ShopItemId"] = 120151,
					["SubTabId"] = 1208,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["HeadSculpture"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = {
			[30095] = {
				[1] = {
					["ShopItemId"] = 802130,
					["SubTabId"] = 8021,
				},
			},
			[30108] = {
				[1] = {
					["ShopItemId"] = 802131,
					["SubTabId"] = 8021,
				},
			},
		},
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = {
			[30022] = {
				[1] = {
					["ShopItemId"] = 10004119,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004147,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004178,
					["SubTabId"] = 100041,
				},
			},
			[30023] = {
				[1] = {
					["ShopItemId"] = 10004120,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004148,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004179,
					["SubTabId"] = 100041,
				},
			},
			[30024] = {
				[1] = {
					["ShopItemId"] = 10004121,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004149,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004180,
					["SubTabId"] = 100041,
				},
			},
		},
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[30089] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140253,
					["SubTabId"] = 1401,
				},
			},
			[30090] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140254,
					["SubTabId"] = 1401,
				},
			},
			[30091] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140255,
					["SubTabId"] = 1401,
				},
			},
			[30092] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140256,
					["SubTabId"] = 1401,
				},
			},
			[30093] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140257,
					["SubTabId"] = 1401,
				},
			},
			[30094] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140258,
					["SubTabId"] = 1401,
				},
			},
			[30110] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140290,
					["SubTabId"] = 1401,
				},
			},
			[30111] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140289,
					["SubTabId"] = 1401,
				},
			},
			[30112] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140288,
					["SubTabId"] = 1401,
				},
			},
			[30116] = {
				[1] = {
					["ShopItemId"] = 150317,
					["SubTabId"] = 1501,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["IronTicket"] = T.RT_2,
	["Mod"] = {
		["AbyssShop"] = {
			[101002] = {
				[1] = {
					["ShopItemId"] = 10000501,
					["SubTabId"] = 100001,
				},
			},
			[102001] = {
				[1] = {
					["ShopItemId"] = 10000500,
					["SubTabId"] = 100001,
				},
			},
			[102004] = {
				[1] = {
					["ShopItemId"] = 10000503,
					["SubTabId"] = 100001,
				},
			},
			[106001] = {
				[1] = {
					["ShopItemId"] = 10000502,
					["SubTabId"] = 100001,
				},
			},
		},
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = {
			[31502] = {
				[1] = {
					["ShopItemId"] = 702007,
					["SubTabId"] = 7020,
				},
			},
			[31513] = {
				[1] = {
					["ShopItemId"] = 703004,
					["SubTabId"] = 7030,
				},
			},
			[31521] = {
				[1] = {
					["ShopItemId"] = 701004,
					["SubTabId"] = 7010,
				},
			},
			[31522] = {
				[1] = {
					["ShopItemId"] = 703005,
					["SubTabId"] = 7030,
				},
			},
			[31523] = {
				[1] = {
					["ShopItemId"] = 702008,
					["SubTabId"] = 7020,
				},
			},
			[31524] = {
				[1] = {
					["ShopItemId"] = 703006,
					["SubTabId"] = 7030,
				},
			},
			[31525] = {
				[1] = {
					["ShopItemId"] = 702010,
					["SubTabId"] = 7020,
				},
			},
			[31526] = {
				[1] = {
					["ShopItemId"] = 701005,
					["SubTabId"] = 7010,
				},
			},
			[31531] = {
				[1] = {
					["ShopItemId"] = 702009,
					["SubTabId"] = 7020,
				},
			},
			[31532] = {
				[1] = {
					["ShopItemId"] = 701003,
					["SubTabId"] = 7010,
				},
			},
		},
		["FishingShop"] = {
			[103002] = {
				[1] = {
					["ShopItemId"] = 801201,
					["SubTabId"] = 8011,
				},
			},
			[104001] = {
				[1] = {
					["ShopItemId"] = 801202,
					["SubTabId"] = 8011,
				},
			},
		},
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = {
			[24001] = {
				[1] = {
					["ShopItemId"] = 10002228,
					["SubTabId"] = 100022,
				},
			},
			[24002] = {
				[1] = {
					["ShopItemId"] = 10002229,
					["SubTabId"] = 100022,
				},
			},
			[24003] = {
				[1] = {
					["ShopItemId"] = 10002230,
					["SubTabId"] = 100022,
				},
			},
			[24004] = {
				[1] = {
					["ShopItemId"] = 10002231,
					["SubTabId"] = 100022,
				},
			},
			[24005] = {
				[1] = {
					["ShopItemId"] = 10002232,
					["SubTabId"] = 100022,
				},
			},
			[24006] = {
				[1] = {
					["ShopItemId"] = 10002233,
					["SubTabId"] = 100022,
				},
			},
			[24101] = {
				[1] = {
					["ShopItemId"] = 10002234,
					["SubTabId"] = 100022,
				},
			},
			[24102] = {
				[1] = {
					["ShopItemId"] = 10002235,
					["SubTabId"] = 100022,
				},
			},
			[24103] = {
				[1] = {
					["ShopItemId"] = 10002236,
					["SubTabId"] = 100022,
				},
			},
			[25001] = {
				[1] = {
					["ShopItemId"] = 10002328,
					["SubTabId"] = 100023,
				},
			},
			[25002] = {
				[1] = {
					["ShopItemId"] = 10002329,
					["SubTabId"] = 100023,
				},
			},
			[25003] = {
				[1] = {
					["ShopItemId"] = 10002330,
					["SubTabId"] = 100023,
				},
			},
			[25004] = {
				[1] = {
					["ShopItemId"] = 10002331,
					["SubTabId"] = 100023,
				},
			},
			[25005] = {
				[1] = {
					["ShopItemId"] = 10002332,
					["SubTabId"] = 100023,
				},
			},
			[25006] = {
				[1] = {
					["ShopItemId"] = 10002333,
					["SubTabId"] = 100023,
				},
			},
			[25101] = {
				[1] = {
					["ShopItemId"] = 10002334,
					["SubTabId"] = 100023,
				},
			},
			[25102] = {
				[1] = {
					["ShopItemId"] = 10002335,
					["SubTabId"] = 100023,
				},
			},
			[25103] = {
				[1] = {
					["ShopItemId"] = 10002336,
					["SubTabId"] = 100023,
				},
			},
			[34001] = {
				[1] = {
					["ShopItemId"] = 10002219,
					["SubTabId"] = 100022,
				},
			},
			[34002] = {
				[1] = {
					["ShopItemId"] = 10002220,
					["SubTabId"] = 100022,
				},
			},
			[34003] = {
				[1] = {
					["ShopItemId"] = 10002221,
					["SubTabId"] = 100022,
				},
			},
			[34004] = {
				[1] = {
					["ShopItemId"] = 10002222,
					["SubTabId"] = 100022,
				},
			},
			[34005] = {
				[1] = {
					["ShopItemId"] = 10002223,
					["SubTabId"] = 100022,
				},
			},
			[34006] = {
				[1] = {
					["ShopItemId"] = 10002224,
					["SubTabId"] = 100022,
				},
			},
			[34101] = {
				[1] = {
					["ShopItemId"] = 10002225,
					["SubTabId"] = 100022,
				},
			},
			[34102] = {
				[1] = {
					["ShopItemId"] = 10002226,
					["SubTabId"] = 100022,
				},
			},
			[34103] = {
				[1] = {
					["ShopItemId"] = 10002227,
					["SubTabId"] = 100022,
				},
			},
			[35001] = {
				[1] = {
					["ShopItemId"] = 10002319,
					["SubTabId"] = 100023,
				},
			},
			[35002] = {
				[1] = {
					["ShopItemId"] = 10002320,
					["SubTabId"] = 100023,
				},
			},
			[35003] = {
				[1] = {
					["ShopItemId"] = 10002321,
					["SubTabId"] = 100023,
				},
			},
			[35004] = {
				[1] = {
					["ShopItemId"] = 10002322,
					["SubTabId"] = 100023,
				},
			},
			[35005] = {
				[1] = {
					["ShopItemId"] = 10002323,
					["SubTabId"] = 100023,
				},
			},
			[35006] = {
				[1] = {
					["ShopItemId"] = 10002324,
					["SubTabId"] = 100023,
				},
			},
			[35101] = {
				[1] = {
					["ShopItemId"] = 10002325,
					["SubTabId"] = 100023,
				},
			},
			[35102] = {
				[1] = {
					["ShopItemId"] = 10002326,
					["SubTabId"] = 100023,
				},
			},
			[35103] = {
				[1] = {
					["ShopItemId"] = 10002327,
					["SubTabId"] = 100023,
				},
			},
			[44001] = {
				[1] = {
					["ShopItemId"] = 10002210,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002346,
					["SubTabId"] = 100022,
				},
			},
			[44002] = {
				[1] = {
					["ShopItemId"] = 10002211,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002347,
					["SubTabId"] = 100022,
				},
			},
			[44003] = {
				[1] = {
					["ShopItemId"] = 10002212,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002348,
					["SubTabId"] = 100022,
				},
			},
			[44004] = {
				[1] = {
					["ShopItemId"] = 10002213,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002349,
					["SubTabId"] = 100022,
				},
			},
			[44005] = {
				[1] = {
					["ShopItemId"] = 10002214,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002350,
					["SubTabId"] = 100022,
				},
			},
			[44006] = {
				[1] = {
					["ShopItemId"] = 10002215,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002351,
					["SubTabId"] = 100022,
				},
			},
			[44101] = {
				[1] = {
					["ShopItemId"] = 10002216,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002352,
					["SubTabId"] = 100022,
				},
			},
			[44102] = {
				[1] = {
					["ShopItemId"] = 10002217,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002353,
					["SubTabId"] = 100022,
				},
			},
			[44103] = {
				[1] = {
					["ShopItemId"] = 10002218,
					["SubTabId"] = 100022,
				},
				[2] = {
					["ShopItemId"] = 10002354,
					["SubTabId"] = 100022,
				},
			},
			[45001] = {
				[1] = {
					["ShopItemId"] = 10002310,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002364,
					["SubTabId"] = 100023,
				},
			},
			[45002] = {
				[1] = {
					["ShopItemId"] = 10002311,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002365,
					["SubTabId"] = 100023,
				},
			},
			[45003] = {
				[1] = {
					["ShopItemId"] = 10002312,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002366,
					["SubTabId"] = 100023,
				},
			},
			[45004] = {
				[1] = {
					["ShopItemId"] = 10002313,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002367,
					["SubTabId"] = 100023,
				},
			},
			[45005] = {
				[1] = {
					["ShopItemId"] = 10002314,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002368,
					["SubTabId"] = 100023,
				},
			},
			[45006] = {
				[1] = {
					["ShopItemId"] = 10002315,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002369,
					["SubTabId"] = 100023,
				},
			},
			[45101] = {
				[1] = {
					["ShopItemId"] = 10002316,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002370,
					["SubTabId"] = 100023,
				},
			},
			[45102] = {
				[1] = {
					["ShopItemId"] = 10002317,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002371,
					["SubTabId"] = 100023,
				},
			},
			[45103] = {
				[1] = {
					["ShopItemId"] = 10002318,
					["SubTabId"] = 100023,
				},
				[2] = {
					["ShopItemId"] = 10002372,
					["SubTabId"] = 100023,
				},
			},
			[101001] = {
				[1] = {
					["ShopItemId"] = 10002106,
					["SubTabId"] = 100021,
				},
			},
			[101003] = {
				[1] = {
					["ShopItemId"] = 10002111,
					["SubTabId"] = 100021,
				},
			},
			[102002] = {
				[1] = {
					["ShopItemId"] = 10002109,
					["SubTabId"] = 100021,
				},
			},
			[103001] = {
				[1] = {
					["ShopItemId"] = 10002108,
					["SubTabId"] = 100021,
				},
			},
			[103003] = {
				[1] = {
					["ShopItemId"] = 10002115,
					["SubTabId"] = 100021,
				},
			},
			[104002] = {
				[1] = {
					["ShopItemId"] = 10002107,
					["SubTabId"] = 100021,
				},
			},
			[104003] = {
				[1] = {
					["ShopItemId"] = 10002110,
					["SubTabId"] = 100021,
				},
			},
		},
		["Shop"] = T.RT_1,
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["Mount"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[1001] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140269,
					["SubTabId"] = 1401,
				},
			},
			[1002] = {
				[1] = {
					["ShopItemId"] = 1208001,
					["SubTabId"] = 1209,
				},
			},
			[1003] = {
				[1] = {
					["ShopItemId"] = 1208002,
					["SubTabId"] = 1209,
				},
			},
			[1004] = {
				[1] = {
					["ShopItemId"] = 1208003,
					["SubTabId"] = 1209,
				},
			},
			[1005] = {
				[1] = {
					["ShopItemId"] = 1208004,
					["SubTabId"] = 1209,
				},
			},
			[1006] = {
				[1] = {
					["ShopItemId"] = 1208005,
					["SubTabId"] = 1209,
				},
			},
			[1007] = {
				[1] = {
					["ShopItemId"] = 1208006,
					["SubTabId"] = 1209,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["Pet"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = {
			[4942] = {
				[1] = {
					["ShopItemId"] = 802005,
					["SubTabId"] = 8020,
				},
			},
			[4943] = {
				[1] = {
					["ShopItemId"] = 802006,
					["SubTabId"] = 8020,
				},
			},
		},
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = {
			[4944] = {
				[1] = {
					["ShopItemId"] = 10004161,
					["SubTabId"] = 100041,
				},
			},
		},
		["Rouge"] = T.RT_1,
		["Shop"] = T.RT_1,
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["Resource"] = {
		["AbyssShop"] = {
			[101] = {
				[1] = {
					["ShopItemId"] = 10000104,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000107,
					["SubTabId"] = 100001,
				},
				[3] = {
					["ShopItemId"] = 10000604,
					["SubTabId"] = 100001,
				},
				[4] = {
					["ShopItemId"] = 10000607,
					["SubTabId"] = 100001,
				},
				[5] = {
					["ShopItemId"] = 10000614,
					["SubTabId"] = 100001,
				},
				[6] = {
					["ShopItemId"] = 10000617,
					["SubTabId"] = 100001,
				},
			},
			[102] = {
				[1] = {
					["ShopItemId"] = 10000105,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000605,
					["SubTabId"] = 100001,
				},
				[3] = {
					["ShopItemId"] = 10000615,
					["SubTabId"] = 100001,
				},
			},
			[2009] = {
				[1] = {
					["ShopItemId"] = 10000102,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000602,
					["SubTabId"] = 100001,
				},
				[3] = {
					["ShopItemId"] = 10000612,
					["SubTabId"] = 100001,
				},
			},
			[2013] = {
				[1] = {
					["ShopItemId"] = 10000101,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000601,
					["SubTabId"] = 100001,
				},
				[3] = {
					["ShopItemId"] = 10000611,
					["SubTabId"] = 100001,
				},
			},
			[3006] = {
				[1] = {
					["ShopItemId"] = 10000103,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000603,
					["SubTabId"] = 100001,
				},
				[3] = {
					["ShopItemId"] = 10000613,
					["SubTabId"] = 100001,
				},
			},
			[3007] = {
				[1] = {
					["ShopItemId"] = 10000106,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000606,
					["SubTabId"] = 100001,
				},
				[3] = {
					["ShopItemId"] = 10000616,
					["SubTabId"] = 100001,
				},
				[4] = {
					["ShopItemId"] = 10000620,
					["SubTabId"] = 100001,
				},
			},
			[20027] = {
				[1] = {
					["ShopItemId"] = 10000110,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000608,
					["SubTabId"] = 100001,
				},
				[3] = {
					["ShopItemId"] = 10000618,
					["SubTabId"] = 100001,
				},
			},
			[20028] = {
				[1] = {
					["ShopItemId"] = 10000111,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000609,
					["SubTabId"] = 100001,
				},
				[3] = {
					["ShopItemId"] = 10000619,
					["SubTabId"] = 100001,
				},
			},
		},
		["AccessoryDropShop"] = {
			[101] = {
				[1] = {
					["ShopItemId"] = 10008001,
					["SubTabId"] = 100081,
				},
			},
		},
		["AutoChessShop"] = {
			[101] = {
				[1] = {
					["ShopItemId"] = 10006115,
					["SubTabId"] = 100061,
				},
				[2] = {
					["ShopItemId"] = 10006120,
					["SubTabId"] = 100061,
				},
			},
			[102] = {
				[1] = {
					["ShopItemId"] = 10006118,
					["SubTabId"] = 100061,
				},
				[2] = {
					["ShopItemId"] = 10006123,
					["SubTabId"] = 100061,
				},
			},
			[201] = {
				[1] = {
					["ShopItemId"] = 10006112,
					["SubTabId"] = 100061,
				},
			},
			[202] = {
				[1] = {
					["ShopItemId"] = 10006113,
					["SubTabId"] = 100061,
				},
			},
			[2009] = {
				[1] = {
					["ShopItemId"] = 10006122,
					["SubTabId"] = 100061,
				},
			},
			[2010] = {
				[1] = {
					["ShopItemId"] = 10006117,
					["SubTabId"] = 100061,
				},
			},
			[2013] = {
				[1] = {
					["ShopItemId"] = 10006121,
					["SubTabId"] = 100061,
				},
			},
			[2014] = {
				[1] = {
					["ShopItemId"] = 10006116,
					["SubTabId"] = 100061,
				},
			},
			[10100] = {
				[1] = {
					["ShopItemId"] = 10006111,
					["SubTabId"] = 100061,
				},
			},
			[20013] = {
				[1] = {
					["ShopItemId"] = 10006119,
					["SubTabId"] = 100061,
				},
			},
			[30112] = {
				[1] = {
					["ShopItemId"] = 10006114,
					["SubTabId"] = 100061,
				},
			},
			[41037] = {
				[1] = {
					["ShopItemId"] = 10006108,
					["SubTabId"] = 100061,
				},
			},
			[41038] = {
				[1] = {
					["ShopItemId"] = 10006109,
					["SubTabId"] = 100061,
				},
			},
			[41039] = {
				[1] = {
					["ShopItemId"] = 10006110,
					["SubTabId"] = 100061,
				},
			},
			[41042] = {
				[1] = {
					["ShopItemId"] = 10006105,
					["SubTabId"] = 100061,
				},
			},
			[41043] = {
				[1] = {
					["ShopItemId"] = 10006106,
					["SubTabId"] = 100061,
				},
			},
			[41044] = {
				[1] = {
					["ShopItemId"] = 10006107,
					["SubTabId"] = 100061,
				},
			},
		},
		["ExploreBadgeShop"] = {
			[201] = {
				[1] = {
					["ShopItemId"] = 701001,
					["SubTabId"] = 7010,
				},
				[2] = {
					["ShopItemId"] = 702005,
					["SubTabId"] = 7020,
				},
				[3] = {
					["ShopItemId"] = 703002,
					["SubTabId"] = 7030,
				},
				[4] = {
					["ShopItemId"] = 704002,
					["SubTabId"] = 7040,
				},
			},
			[202] = {
				[1] = {
					["ShopItemId"] = 701002,
					["SubTabId"] = 7010,
				},
				[2] = {
					["ShopItemId"] = 702006,
					["SubTabId"] = 7020,
				},
				[3] = {
					["ShopItemId"] = 703003,
					["SubTabId"] = 7030,
				},
				[4] = {
					["ShopItemId"] = 704003,
					["SubTabId"] = 7040,
				},
			},
			[2009] = {
				[1] = {
					["ShopItemId"] = 702004,
					["SubTabId"] = 7020,
				},
			},
			[2013] = {
				[1] = {
					["ShopItemId"] = 702003,
					["SubTabId"] = 7020,
				},
			},
			[10100] = {
				[1] = {
					["ShopItemId"] = 702001,
					["SubTabId"] = 7020,
				},
				[2] = {
					["ShopItemId"] = 702002,
					["SubTabId"] = 7020,
				},
				[3] = {
					["ShopItemId"] = 703001,
					["SubTabId"] = 7030,
				},
				[4] = {
					["ShopItemId"] = 704001,
					["SubTabId"] = 7040,
				},
			},
		},
		["FishingShop"] = {
			[101] = {
				[1] = {
					["ShopItemId"] = 801104,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801109,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801118,
					["SubTabId"] = 8011,
				},
				[4] = {
					["ShopItemId"] = 801129,
					["SubTabId"] = 8011,
				},
				[5] = {
					["ShopItemId"] = 801140,
					["SubTabId"] = 8011,
				},
				[6] = {
					["ShopItemId"] = 802104,
					["SubTabId"] = 8021,
				},
				[7] = {
					["ShopItemId"] = 802109,
					["SubTabId"] = 8021,
				},
				[8] = {
					["ShopItemId"] = 802119,
					["SubTabId"] = 8021,
				},
			},
			[102] = {
				[1] = {
					["ShopItemId"] = 801105,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801110,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801119,
					["SubTabId"] = 8011,
				},
				[4] = {
					["ShopItemId"] = 801130,
					["SubTabId"] = 8011,
				},
				[5] = {
					["ShopItemId"] = 801141,
					["SubTabId"] = 8011,
				},
				[6] = {
					["ShopItemId"] = 802105,
					["SubTabId"] = 8021,
				},
				[7] = {
					["ShopItemId"] = 802110,
					["SubTabId"] = 8021,
				},
				[8] = {
					["ShopItemId"] = 802120,
					["SubTabId"] = 8021,
				},
			},
			[201] = {
				[1] = {
					["ShopItemId"] = 801123,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801134,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801145,
					["SubTabId"] = 8011,
				},
			},
			[202] = {
				[1] = {
					["ShopItemId"] = 801124,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801135,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801146,
					["SubTabId"] = 8011,
				},
			},
			[211] = {
				[1] = {
					["ShopItemId"] = 801114,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801125,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801136,
					["SubTabId"] = 8011,
				},
				[4] = {
					["ShopItemId"] = 801147,
					["SubTabId"] = 8011,
				},
				[5] = {
					["ShopItemId"] = 802115,
					["SubTabId"] = 8021,
				},
				[6] = {
					["ShopItemId"] = 802125,
					["SubTabId"] = 8021,
				},
			},
			[1001] = {
				[1] = {
					["ShopItemId"] = 801112,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801121,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801132,
					["SubTabId"] = 8011,
				},
				[4] = {
					["ShopItemId"] = 801143,
					["SubTabId"] = 8011,
				},
				[5] = {
					["ShopItemId"] = 802112,
					["SubTabId"] = 8021,
				},
				[6] = {
					["ShopItemId"] = 802122,
					["SubTabId"] = 8021,
				},
			},
			[1002] = {
				[1] = {
					["ShopItemId"] = 802113,
					["SubTabId"] = 8021,
				},
				[2] = {
					["ShopItemId"] = 802123,
					["SubTabId"] = 8021,
				},
			},
			[2008] = {
				[1] = {
					["ShopItemId"] = 801102,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801107,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 802102,
					["SubTabId"] = 8021,
				},
			},
			[2009] = {
				[1] = {
					["ShopItemId"] = 801116,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801127,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 802107,
					["SubTabId"] = 8021,
				},
			},
			[2010] = {
				[1] = {
					["ShopItemId"] = 801138,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 802117,
					["SubTabId"] = 8021,
				},
			},
			[2012] = {
				[1] = {
					["ShopItemId"] = 801101,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801106,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 802101,
					["SubTabId"] = 8021,
				},
			},
			[2013] = {
				[1] = {
					["ShopItemId"] = 801115,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801126,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 802106,
					["SubTabId"] = 8021,
				},
			},
			[2014] = {
				[1] = {
					["ShopItemId"] = 801137,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 802116,
					["SubTabId"] = 8021,
				},
			},
			[3001] = {
				[1] = {
					["ShopItemId"] = 801113,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801122,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801133,
					["SubTabId"] = 8011,
				},
				[4] = {
					["ShopItemId"] = 801144,
					["SubTabId"] = 8011,
				},
				[5] = {
					["ShopItemId"] = 802114,
					["SubTabId"] = 8021,
				},
				[6] = {
					["ShopItemId"] = 802124,
					["SubTabId"] = 8021,
				},
			},
			[3005] = {
				[1] = {
					["ShopItemId"] = 801103,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801108,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801203,
					["SubTabId"] = 8011,
				},
				[4] = {
					["ShopItemId"] = 802103,
					["SubTabId"] = 8021,
				},
			},
			[3006] = {
				[1] = {
					["ShopItemId"] = 801117,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801128,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801139,
					["SubTabId"] = 8011,
				},
				[4] = {
					["ShopItemId"] = 802108,
					["SubTabId"] = 8021,
				},
				[5] = {
					["ShopItemId"] = 802118,
					["SubTabId"] = 8021,
				},
			},
			[3015] = {
				[1] = {
					["ShopItemId"] = 802007,
					["SubTabId"] = 8020,
				},
			},
			[10100] = {
				[1] = {
					["ShopItemId"] = 801111,
					["SubTabId"] = 8011,
				},
				[2] = {
					["ShopItemId"] = 801120,
					["SubTabId"] = 8011,
				},
				[3] = {
					["ShopItemId"] = 801131,
					["SubTabId"] = 8011,
				},
				[4] = {
					["ShopItemId"] = 801142,
					["SubTabId"] = 8011,
				},
				[5] = {
					["ShopItemId"] = 802111,
					["SubTabId"] = 8021,
				},
				[6] = {
					["ShopItemId"] = 802121,
					["SubTabId"] = 8021,
				},
			},
			[41013] = {
				[1] = {
					["ShopItemId"] = 801200,
					["SubTabId"] = 8011,
				},
			},
			[5110200] = {
				[1] = {
					["ShopItemId"] = 801005,
					["SubTabId"] = 8010,
				},
			},
			[5110300] = {
				[1] = {
					["ShopItemId"] = 801006,
					["SubTabId"] = 8010,
				},
			},
			[5110400] = {
				[1] = {
					["ShopItemId"] = 801007,
					["SubTabId"] = 8010,
				},
			},
			[5110500] = {
				[1] = {
					["ShopItemId"] = 801008,
					["SubTabId"] = 8010,
				},
			},
			[5110601] = {
				[1] = {
					["ShopItemId"] = 802008,
					["SubTabId"] = 8020,
				},
			},
			[5110602] = {
				[1] = {
					["ShopItemId"] = 802009,
					["SubTabId"] = 8020,
				},
			},
			[5210100] = {
				[1] = {
					["ShopItemId"] = 801001,
					["SubTabId"] = 8010,
				},
				[2] = {
					["ShopItemId"] = 802001,
					["SubTabId"] = 8020,
				},
			},
			[5210200] = {
				[1] = {
					["ShopItemId"] = 801002,
					["SubTabId"] = 8010,
				},
				[2] = {
					["ShopItemId"] = 802002,
					["SubTabId"] = 8020,
				},
			},
			[5210300] = {
				[1] = {
					["ShopItemId"] = 801003,
					["SubTabId"] = 8010,
				},
				[2] = {
					["ShopItemId"] = 802003,
					["SubTabId"] = 8020,
				},
			},
			[5210400] = {
				[1] = {
					["ShopItemId"] = 801004,
					["SubTabId"] = 8010,
				},
				[2] = {
					["ShopItemId"] = 802004,
					["SubTabId"] = 8020,
				},
			},
		},
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = {
			[101] = {
				[1] = {
					["ShopItemId"] = 10001104,
					["SubTabId"] = 100011,
				},
			},
			[102] = {
				[1] = {
					["ShopItemId"] = 10001103,
					["SubTabId"] = 100011,
				},
			},
			[2013] = {
				[1] = {
					["ShopItemId"] = 10001102,
					["SubTabId"] = 100011,
				},
			},
			[10100] = {
				[1] = {
					["ShopItemId"] = 10001101,
					["SubTabId"] = 100011,
				},
			},
		},
		["HuaxuExploreShop"] = {
			[101] = {
				[1] = {
					["ShopItemId"] = 10005106,
					["SubTabId"] = 100051,
				},
			},
			[211] = {
				[1] = {
					["ShopItemId"] = 10005102,
					["SubTabId"] = 100051,
				},
			},
			[1002] = {
				[1] = {
					["ShopItemId"] = 10005103,
					["SubTabId"] = 100051,
				},
			},
			[10100] = {
				[1] = {
					["ShopItemId"] = 10005104,
					["SubTabId"] = 100051,
				},
			},
			[20013] = {
				[1] = {
					["ShopItemId"] = 10005105,
					["SubTabId"] = 100051,
				},
			},
		},
		["RaidShopSeason01"] = {
			[101] = {
				[1] = {
					["ShopItemId"] = 10004107,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004115,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004135,
					["SubTabId"] = 100041,
				},
				[4] = {
					["ShopItemId"] = 10004143,
					["SubTabId"] = 100041,
				},
				[5] = {
					["ShopItemId"] = 10004166,
					["SubTabId"] = 100041,
				},
				[6] = {
					["ShopItemId"] = 10004174,
					["SubTabId"] = 100041,
				},
			},
			[102] = {
				[1] = {
					["ShopItemId"] = 10004108,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004116,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004136,
					["SubTabId"] = 100041,
				},
				[4] = {
					["ShopItemId"] = 10004144,
					["SubTabId"] = 100041,
				},
				[5] = {
					["ShopItemId"] = 10004167,
					["SubTabId"] = 100041,
				},
				[6] = {
					["ShopItemId"] = 10004175,
					["SubTabId"] = 100041,
				},
			},
			[220] = {
				[1] = {
					["ShopItemId"] = 10004153,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004154,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004155,
					["SubTabId"] = 100041,
				},
				[4] = {
					["ShopItemId"] = 10004156,
					["SubTabId"] = 100041,
				},
				[5] = {
					["ShopItemId"] = 10004184,
					["SubTabId"] = 100041,
				},
				[6] = {
					["ShopItemId"] = 10004185,
					["SubTabId"] = 100041,
				},
				[7] = {
					["ShopItemId"] = 10004186,
					["SubTabId"] = 100041,
				},
				[8] = {
					["ShopItemId"] = 10004187,
					["SubTabId"] = 100041,
				},
			},
			[1006] = {
				[1] = {
					["ShopItemId"] = 10004102,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004130,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004160,
					["SubTabId"] = 100041,
				},
			},
			[2009] = {
				[1] = {
					["ShopItemId"] = 10004118,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004146,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004177,
					["SubTabId"] = 100041,
				},
			},
			[2010] = {
				[1] = {
					["ShopItemId"] = 10004110,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004138,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004169,
					["SubTabId"] = 100041,
				},
			},
			[2013] = {
				[1] = {
					["ShopItemId"] = 10004117,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004145,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004176,
					["SubTabId"] = 100041,
				},
			},
			[2014] = {
				[1] = {
					["ShopItemId"] = 10004109,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004137,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004168,
					["SubTabId"] = 100041,
				},
			},
			[3006] = {
				[1] = {
					["ShopItemId"] = 10004112,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004140,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004171,
					["SubTabId"] = 100041,
				},
			},
			[3007] = {
				[1] = {
					["ShopItemId"] = 10004104,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004132,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004163,
					["SubTabId"] = 100041,
				},
			},
			[3016] = {
				[1] = {
					["ShopItemId"] = 10004101,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004125,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004126,
					["SubTabId"] = 100041,
				},
				[4] = {
					["ShopItemId"] = 10004127,
					["SubTabId"] = 100041,
				},
				[5] = {
					["ShopItemId"] = 10004128,
					["SubTabId"] = 100041,
				},
				[6] = {
					["ShopItemId"] = 10004129,
					["SubTabId"] = 100041,
				},
				[7] = {
					["ShopItemId"] = 10004157,
					["SubTabId"] = 100041,
				},
				[8] = {
					["ShopItemId"] = 10004158,
					["SubTabId"] = 100041,
				},
				[9] = {
					["ShopItemId"] = 10004159,
					["SubTabId"] = 100041,
				},
			},
			[10100] = {
				[1] = {
					["ShopItemId"] = 10004103,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004131,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004162,
					["SubTabId"] = 100041,
				},
			},
			[20013] = {
				[1] = {
					["ShopItemId"] = 10004111,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004139,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004170,
					["SubTabId"] = 100041,
				},
			},
			[20021] = {
				[1] = {
					["ShopItemId"] = 10004114,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004142,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004173,
					["SubTabId"] = 100041,
				},
			},
			[20024] = {
				[1] = {
					["ShopItemId"] = 10004113,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004141,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004172,
					["SubTabId"] = 100041,
				},
			},
			[20027] = {
				[1] = {
					["ShopItemId"] = 10004105,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004133,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004164,
					["SubTabId"] = 100041,
				},
			},
			[20028] = {
				[1] = {
					["ShopItemId"] = 10004106,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004134,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004165,
					["SubTabId"] = 100041,
				},
			},
		},
		["Rouge"] = {
			[101] = {
				[1] = {
					["ShopItemId"] = 10002103,
					["SubTabId"] = 100021,
				},
				[2] = {
					["ShopItemId"] = 10002105,
					["SubTabId"] = 100021,
				},
			},
			[102] = {
				[1] = {
					["ShopItemId"] = 10002104,
					["SubTabId"] = 100021,
				},
			},
			[2009] = {
				[1] = {
					["ShopItemId"] = 10002102,
					["SubTabId"] = 100021,
				},
			},
			[2013] = {
				[1] = {
					["ShopItemId"] = 10002101,
					["SubTabId"] = 100021,
				},
			},
		},
		["Shop"] = {
			[99] = {
				[1] = {
					["ShopItemId"] = 110101,
					["SubTabId"] = 1101,
				},
				[2] = {
					["ShopItemId"] = 110102,
					["SubTabId"] = 1101,
				},
				[3] = {
					["ShopItemId"] = 110103,
					["SubTabId"] = 1101,
				},
				[4] = {
					["ShopItemId"] = 110104,
					["SubTabId"] = 1101,
				},
				[5] = {
					["ShopItemId"] = 110105,
					["SubTabId"] = 1101,
				},
				[6] = {
					["ShopItemId"] = 110106,
					["SubTabId"] = 1101,
				},
				[7] = {
					["ShopItemId"] = 110107,
					["SubTabId"] = 1101,
				},
				[8] = {
					["ShopItemId"] = 110108,
					["SubTabId"] = 1101,
				},
			},
			[101] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140136,
					["SubTabId"] = 1402,
				},
				[2] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150303,
					["SubTabId"] = 1500,
				},
			},
			[102] = {
				[1] = {
					["ShopItemId"] = 140141,
					["SubTabId"] = 1402,
				},
			},
			[201] = {
				[1] = {
					["ShopItemId"] = 140143,
					["SubTabId"] = 1402,
				},
				[2] = {
					["ShopItemId"] = 140149,
					["SubTabId"] = 1402,
				},
				[3] = {
					["ShopItemId"] = 150104,
					["SubTabId"] = 1501,
				},
			},
			[202] = {
				[1] = {
					["ShopItemId"] = 140144,
					["SubTabId"] = 1402,
				},
				[2] = {
					["ShopItemId"] = 140150,
					["SubTabId"] = 1402,
				},
				[3] = {
					["ShopItemId"] = 150105,
					["SubTabId"] = 1501,
				},
			},
			[207] = {
				[1] = {
					["ShopItemId"] = 150101,
					["SubTabId"] = 1500,
				},
				[2] = {
					["ShopItemId"] = 150301,
					["SubTabId"] = 1501,
				},
			},
			[208] = {
				[1] = {
					["ShopItemId"] = 150102,
					["SubTabId"] = 1500,
				},
			},
			[209] = {
				[1] = {
					["ShopItemId"] = 150103,
					["SubTabId"] = 1500,
				},
			},
			[1001] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150106,
					["SubTabId"] = 1501,
				},
				[2] = {
					["ShopItemId"] = 140145,
					["SubTabId"] = 1402,
				},
				[3] = {
					["ShopItemId"] = 140151,
					["SubTabId"] = 1402,
				},
			},
			[1002] = {
				[1] = {
					["ShopItemId"] = 140142,
					["SubTabId"] = 1402,
				},
				[2] = {
					["ShopItemId"] = 150115,
					["SubTabId"] = 1501,
				},
			},
			[1003] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150107,
					["SubTabId"] = 1500,
				},
				[2] = {
					["ShopItemId"] = 140146,
					["SubTabId"] = 1402,
				},
				[3] = {
					["ShopItemId"] = 140152,
					["SubTabId"] = 1402,
				},
			},
			[2009] = {
				[1] = {
					["ShopItemId"] = 140137,
					["SubTabId"] = 1402,
				},
			},
			[2013] = {
				[1] = {
					["ShopItemId"] = 140138,
					["SubTabId"] = 1402,
				},
			},
			[3016] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150302,
					["SubTabId"] = 1500,
				},
			},
			[20013] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150304,
					["SubTabId"] = 1500,
				},
			},
			[30101] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140213,
					["SubTabId"] = 1401,
				},
				[2] = {
					["ShopItemId"] = 140147,
					["SubTabId"] = 1402,
				},
				[3] = {
					["ShopItemId"] = 140153,
					["SubTabId"] = 1402,
				},
			},
			[30102] = {
				[1] = {
					["ShopItemId"] = 150108,
					["SubTabId"] = 1501,
				},
			},
			[30103] = {
				[1] = {
					["ShopItemId"] = 150109,
					["SubTabId"] = 1501,
				},
			},
			[30104] = {
				[1] = {
					["ShopItemId"] = 150110,
					["SubTabId"] = 1501,
				},
			},
			[30105] = {
				[1] = {
					["ShopItemId"] = 150111,
					["SubTabId"] = 1501,
				},
			},
			[30106] = {
				[1] = {
					["ShopItemId"] = 150112,
					["SubTabId"] = 1501,
				},
			},
			[30107] = {
				[1] = {
					["ShopItemId"] = 150113,
					["SubTabId"] = 1501,
				},
			},
			[30108] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140214,
					["SubTabId"] = 1401,
				},
				[2] = {
					["ShopItemId"] = 140148,
					["SubTabId"] = 1402,
				},
				[3] = {
					["ShopItemId"] = 140154,
					["SubTabId"] = 1402,
				},
			},
			[30109] = {
				[1] = {
					["ShopItemId"] = 150114,
					["SubTabId"] = 1501,
				},
			},
			[30113] = {
				[1] = {
					["ShopItemId"] = 150312,
					["SubTabId"] = 1501,
				},
			},
			[30114] = {
				[1] = {
					["ShopItemId"] = 150313,
					["SubTabId"] = 1501,
				},
			},
			[30115] = {
				[1] = {
					["ShopItemId"] = 150314,
					["SubTabId"] = 1501,
				},
			},
			[30116] = {
				[1] = {
					["ShopItemId"] = 150315,
					["SubTabId"] = 1501,
				},
			},
			[30117] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140292,
					["SubTabId"] = 1401,
				},
			},
			[30118] = {
				[1] = {
					["ShopItemId"] = 150316,
					["SubTabId"] = 1501,
				},
			},
			[30119] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140293,
					["SubTabId"] = 1401,
				},
			},
			[41002] = {
				[1] = {
					["ShopItemId"] = 140133,
					["SubTabId"] = 1402,
				},
			},
			[41005] = {
				[1] = {
					["ShopItemId"] = 140134,
					["SubTabId"] = 1402,
				},
			},
			[41006] = {
				[1] = {
					["ShopItemId"] = 140135,
					["SubTabId"] = 1402,
				},
			},
			[41012] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140210,
					["SubTabId"] = 1401,
				},
			},
			[41014] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140207,
					["SubTabId"] = 1401,
				},
			},
			[41015] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140211,
					["SubTabId"] = 1401,
				},
			},
			[41016] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140212,
					["SubTabId"] = 1401,
				},
			},
			[41017] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140208,
					["SubTabId"] = 1401,
				},
			},
			[41018] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140209,
					["SubTabId"] = 1401,
				},
			},
			[41019] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140236,
					["SubTabId"] = 1401,
				},
			},
			[41020] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140227,
					["SubTabId"] = 1401,
				},
			},
			[41021] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140228,
					["SubTabId"] = 1401,
				},
			},
			[41022] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140229,
					["SubTabId"] = 1401,
				},
			},
			[41028] = {
				[1] = {
					["ShopItemId"] = 140155,
					["SubTabId"] = 1402,
				},
			},
			[41031] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140273,
					["SubTabId"] = 1401,
				},
			},
			[41032] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140270,
					["SubTabId"] = 1401,
				},
			},
			[41037] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150309,
					["SubTabId"] = 1501,
				},
			},
			[41038] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150310,
					["SubTabId"] = 1501,
				},
			},
			[41039] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150311,
					["SubTabId"] = 1501,
				},
			},
			[41040] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140271,
					["SubTabId"] = 1401,
				},
			},
			[41041] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140272,
					["SubTabId"] = 1401,
				},
			},
			[41042] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150305,
					["SubTabId"] = 1501,
				},
			},
			[41043] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150306,
					["SubTabId"] = 1501,
				},
			},
			[41044] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150307,
					["SubTabId"] = 1501,
				},
			},
			[41045] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 150308,
					["SubTabId"] = 1501,
				},
			},
			[110006] = {
				[1] = {
					["ShopItemId"] = 120105,
					["SubTabId"] = 1208,
				},
				[2] = {
					["ShopItemId"] = 120106,
					["SubTabId"] = 1208,
				},
				[3] = {
					["ShopItemId"] = 120107,
					["SubTabId"] = 1208,
				},
			},
			[110012] = {
				[1] = {
					["ShopItemId"] = 120109,
					["SubTabId"] = 1208,
				},
				[2] = {
					["ShopItemId"] = 120110,
					["SubTabId"] = 1208,
				},
				[3] = {
					["ShopItemId"] = 120111,
					["SubTabId"] = 1208,
				},
			},
			[110015] = {
				[1] = {
					["ShopItemId"] = 120145,
					["SubTabId"] = 1208,
				},
				[2] = {
					["ShopItemId"] = 120146,
					["SubTabId"] = 1208,
				},
				[3] = {
					["ShopItemId"] = 120147,
					["SubTabId"] = 1208,
				},
			},
			[110016] = {
				[1] = {
					["ShopItemId"] = 120148,
					["SubTabId"] = 1208,
				},
				[2] = {
					["ShopItemId"] = 120149,
					["SubTabId"] = 1208,
				},
				[3] = {
					["ShopItemId"] = 120150,
					["SubTabId"] = 1208,
				},
			},
			[110017] = {
				[1] = {
					["ShopItemId"] = 120152,
					["SubTabId"] = 1208,
				},
				[2] = {
					["ShopItemId"] = 120153,
					["SubTabId"] = 1208,
				},
				[3] = {
					["ShopItemId"] = 120154,
					["SubTabId"] = 1208,
				},
			},
			[1001101] = {
				[1] = {
					["ShopItemId"] = 150116,
					["SubTabId"] = 1502,
				},
			},
			[1001103] = {
				[1] = {
					["ShopItemId"] = 150117,
					["SubTabId"] = 1502,
				},
			},
			[1001501] = {
				[1] = {
					["ShopItemId"] = 150118,
					["SubTabId"] = 1502,
				},
			},
			[1001502] = {
				[1] = {
					["ShopItemId"] = 150119,
					["SubTabId"] = 1502,
				},
			},
			[1001503] = {
				[1] = {
					["ShopItemId"] = 150120,
					["SubTabId"] = 1502,
				},
			},
			[1001504] = {
				[1] = {
					["ShopItemId"] = 150121,
					["SubTabId"] = 1502,
				},
			},
			[1001801] = {
				[1] = {
					["ShopItemId"] = 150122,
					["SubTabId"] = 1502,
				},
			},
			[1002101] = {
				[1] = {
					["ShopItemId"] = 150123,
					["SubTabId"] = 1502,
				},
			},
			[1002301] = {
				[1] = {
					["ShopItemId"] = 150124,
					["SubTabId"] = 1502,
				},
			},
			[1002401] = {
				[1] = {
					["ShopItemId"] = 150125,
					["SubTabId"] = 1502,
				},
			},
			[1003101] = {
				[1] = {
					["ShopItemId"] = 150126,
					["SubTabId"] = 1502,
				},
			},
			[1003103] = {
				[1] = {
					["ShopItemId"] = 150128,
					["SubTabId"] = 1502,
				},
			},
			[1003201] = {
				[1] = {
					["ShopItemId"] = 150129,
					["SubTabId"] = 1502,
				},
			},
			[1003202] = {
				[1] = {
					["ShopItemId"] = 150130,
					["SubTabId"] = 1502,
				},
			},
			[1003301] = {
				[1] = {
					["ShopItemId"] = 150131,
					["SubTabId"] = 1502,
				},
			},
			[1004101] = {
				[1] = {
					["ShopItemId"] = 150132,
					["SubTabId"] = 1502,
				},
			},
			[1004102] = {
				[1] = {
					["ShopItemId"] = 150133,
					["SubTabId"] = 1502,
				},
			},
			[1004201] = {
				[1] = {
					["ShopItemId"] = 150134,
					["SubTabId"] = 1502,
				},
			},
			[1004202] = {
				[1] = {
					["ShopItemId"] = 150135,
					["SubTabId"] = 1502,
				},
			},
			[1004301] = {
				[1] = {
					["ShopItemId"] = 150136,
					["SubTabId"] = 1502,
				},
			},
			[1005101] = {
				[1] = {
					["ShopItemId"] = 150137,
					["SubTabId"] = 1502,
				},
			},
			[1005102] = {
				[1] = {
					["ShopItemId"] = 150138,
					["SubTabId"] = 1502,
				},
			},
			[1005301] = {
				[1] = {
					["ShopItemId"] = 150139,
					["SubTabId"] = 1502,
				},
			},
			[1005401] = {
				[1] = {
					["ShopItemId"] = 150140,
					["SubTabId"] = 1502,
				},
			},
		},
		["SoloTreasureShop"] = {
			[101] = {
				[1] = {
					["ShopItemId"] = 10007114,
					["SubTabId"] = 100071,
				},
				[2] = {
					["ShopItemId"] = 10007118,
					["SubTabId"] = 100071,
				},
			},
			[102] = {
				[1] = {
					["ShopItemId"] = 10007116,
					["SubTabId"] = 100071,
				},
				[2] = {
					["ShopItemId"] = 10007120,
					["SubTabId"] = 100071,
				},
			},
			[201] = {
				[1] = {
					["ShopItemId"] = 10007111,
					["SubTabId"] = 100071,
				},
			},
			[202] = {
				[1] = {
					["ShopItemId"] = 10007112,
					["SubTabId"] = 100071,
				},
			},
			[2009] = {
				[1] = {
					["ShopItemId"] = 10007119,
					["SubTabId"] = 100071,
				},
			},
			[2010] = {
				[1] = {
					["ShopItemId"] = 10007115,
					["SubTabId"] = 100071,
				},
			},
			[10100] = {
				[1] = {
					["ShopItemId"] = 10007110,
					["SubTabId"] = 100071,
				},
			},
			[20013] = {
				[1] = {
					["ShopItemId"] = 10007117,
					["SubTabId"] = 100071,
				},
			},
			[30112] = {
				[1] = {
					["ShopItemId"] = 10007113,
					["SubTabId"] = 100071,
				},
			},
			[41037] = {
				[1] = {
					["ShopItemId"] = 10007107,
					["SubTabId"] = 100071,
				},
			},
			[41038] = {
				[1] = {
					["ShopItemId"] = 10007108,
					["SubTabId"] = 100071,
				},
			},
			[41039] = {
				[1] = {
					["ShopItemId"] = 10007109,
					["SubTabId"] = 100071,
				},
			},
			[41042] = {
				[1] = {
					["ShopItemId"] = 10007104,
					["SubTabId"] = 100071,
				},
			},
			[41043] = {
				[1] = {
					["ShopItemId"] = 10007105,
					["SubTabId"] = 100071,
				},
			},
			[41044] = {
				[1] = {
					["ShopItemId"] = 10007106,
					["SubTabId"] = 100071,
				},
			},
			[6000005] = {
				[1] = {
					["ShopItemId"] = 10007126,
					["SubTabId"] = 100071,
				},
			},
			[60000042] = {
				[1] = {
					["ShopItemId"] = 10007121,
					["SubTabId"] = 100071,
				},
			},
			[60000043] = {
				[1] = {
					["ShopItemId"] = 10007122,
					["SubTabId"] = 100071,
				},
			},
			[60000044] = {
				[1] = {
					["ShopItemId"] = 10007123,
					["SubTabId"] = 100071,
				},
			},
			[60000045] = {
				[1] = {
					["ShopItemId"] = 10007124,
					["SubTabId"] = 100071,
				},
			},
			[60000046] = {
				[1] = {
					["ShopItemId"] = 10007125,
					["SubTabId"] = 100071,
				},
			},
		},
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["Reward"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[12001] = {
				[1] = {
					["AccessOrder"] = 8,
					["ShopItemId"] = 160301,
					["SubTabId"] = 1606,
				},
			},
			[12002] = {
				[1] = {
					["AccessOrder"] = 7,
					["ShopItemId"] = 160302,
					["SubTabId"] = 1606,
				},
			},
			[12003] = {
				[1] = {
					["AccessOrder"] = 6,
					["ShopItemId"] = 160303,
					["SubTabId"] = 1606,
				},
			},
			[12004] = {
				[1] = {
					["AccessOrder"] = 5,
					["ShopItemId"] = 160304,
					["SubTabId"] = 1606,
				},
			},
			[12005] = {
				[1] = {
					["AccessOrder"] = 3,
					["ShopItemId"] = 160306,
					["SubTabId"] = 1606,
				},
			},
			[12006] = {
				[1] = {
					["AccessOrder"] = 1,
					["ShopItemId"] = 160308,
					["SubTabId"] = 1606,
				},
			},
			[12023] = {
				[1] = {
					["ShopItemId"] = 160107,
					["SubTabId"] = 1601,
				},
			},
			[12024] = {
				[1] = {
					["ShopItemId"] = 160108,
					["SubTabId"] = 1601,
				},
			},
			[12025] = {
				[1] = {
					["ShopItemId"] = 160109,
					["SubTabId"] = 1601,
				},
			},
			[12026] = {
				[1] = {
					["ShopItemId"] = 160110,
					["SubTabId"] = 1601,
				},
			},
			[12034] = {
				[1] = {
					["AccessOrder"] = 4,
					["ShopItemId"] = 160305,
					["SubTabId"] = 1606,
				},
			},
			[12035] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 160307,
					["SubTabId"] = 1606,
				},
			},
			[12036] = {
				[1] = {
					["ShopItemId"] = 160309,
					["SubTabId"] = 1606,
				},
			},
			[12037] = {
				[1] = {
					["ShopItemId"] = 160310,
					["SubTabId"] = 1606,
				},
			},
			[12038] = {
				[1] = {
					["ShopItemId"] = 160311,
					["SubTabId"] = 1606,
				},
			},
			[12039] = {
				[1] = {
					["ShopItemId"] = 160312,
					["SubTabId"] = 1606,
				},
			},
			[12040] = {
				[1] = {
					["ShopItemId"] = 160313,
					["SubTabId"] = 1606,
				},
			},
			[12041] = {
				[1] = {
					["ShopItemId"] = 160314,
					["SubTabId"] = 1606,
				},
			},
			[12042] = {
				[1] = {
					["ShopItemId"] = 160315,
					["SubTabId"] = 1606,
				},
			},
			[12043] = {
				[1] = {
					["ShopItemId"] = 160204,
					["SubTabId"] = 1605,
				},
			},
			[12044] = {
				[1] = {
					["ShopItemId"] = 160205,
					["SubTabId"] = 1605,
				},
			},
			[12045] = {
				[1] = {
					["ShopItemId"] = 160206,
					["SubTabId"] = 1605,
				},
			},
			[12046] = {
				[1] = {
					["ShopItemId"] = 160207,
					["SubTabId"] = 1605,
				},
			},
			[12047] = {
				[1] = {
					["ShopItemId"] = 160208,
					["SubTabId"] = 1605,
				},
			},
			[12048] = {
				[1] = {
					["ShopItemId"] = 160209,
					["SubTabId"] = 1605,
				},
			},
			[12049] = {
				[1] = {
					["ShopItemId"] = 160210,
					["SubTabId"] = 1605,
				},
			},
			[12050] = {
				[1] = {
					["ShopItemId"] = 160211,
					["SubTabId"] = 1605,
				},
			},
			[12051] = {
				[1] = {
					["ShopItemId"] = 160201,
					["SubTabId"] = 1604,
				},
			},
			[12052] = {
				[1] = {
					["ShopItemId"] = 160202,
					["SubTabId"] = 1604,
				},
			},
			[12055] = {
				[1] = {
					["ShopItemId"] = 160212,
					["SubTabId"] = 1605,
				},
			},
			[12056] = {
				[1] = {
					["ShopItemId"] = 160213,
					["SubTabId"] = 1605,
				},
			},
			[12057] = {
				[1] = {
					["ShopItemId"] = 160214,
					["SubTabId"] = 1605,
				},
			},
			[12058] = {
				[1] = {
					["ShopItemId"] = 160215,
					["SubTabId"] = 1605,
				},
			},
			[12059] = {
				[1] = {
					["ShopItemId"] = 160216,
					["SubTabId"] = 1605,
				},
			},
			[12060] = {
				[1] = {
					["ShopItemId"] = 160217,
					["SubTabId"] = 1605,
				},
			},
			[12061] = {
				[1] = {
					["ShopItemId"] = 160218,
					["SubTabId"] = 1604,
				},
				[2] = {
					["ShopItemId"] = 160222,
					["SubTabId"] = 1604,
				},
			},
			[12062] = {
				[1] = {
					["ShopItemId"] = 160219,
					["SubTabId"] = 1604,
				},
				[2] = {
					["ShopItemId"] = 160223,
					["SubTabId"] = 1604,
				},
			},
			[12063] = {
				[1] = {
					["ShopItemId"] = 160220,
					["SubTabId"] = 1604,
				},
				[2] = {
					["ShopItemId"] = 160224,
					["SubTabId"] = 1604,
				},
			},
			[12064] = {
				[1] = {
					["ShopItemId"] = 160221,
					["SubTabId"] = 1604,
				},
				[2] = {
					["ShopItemId"] = 160225,
					["SubTabId"] = 1604,
				},
			},
			[12101] = {
				[1] = {
					["ShopItemId"] = 160101,
					["SubTabId"] = 1601,
				},
			},
			[12102] = {
				[1] = {
					["ShopItemId"] = 160102,
					["SubTabId"] = 1601,
				},
			},
			[12103] = {
				[1] = {
					["ShopItemId"] = 160103,
					["SubTabId"] = 1601,
				},
			},
			[12104] = {
				[1] = {
					["ShopItemId"] = 160104,
					["SubTabId"] = 1601,
				},
			},
			[12105] = {
				[1] = {
					["ShopItemId"] = 160105,
					["SubTabId"] = 1601,
				},
			},
			[12106] = {
				[1] = {
					["ShopItemId"] = 160106,
					["SubTabId"] = 1601,
				},
			},
			[12107] = {
				[1] = {
					["ShopItemId"] = 160111,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160316,
					["SubTabId"] = 1606,
				},
			},
			[12110] = {
				[1] = {
					["ShopItemId"] = 160112,
					["SubTabId"] = 1601,
				},
			},
			[12111] = {
				[1] = {
					["ShopItemId"] = 160113,
					["SubTabId"] = 1601,
				},
			},
			[12112] = {
				[1] = {
					["ShopItemId"] = 160114,
					["SubTabId"] = 1601,
				},
			},
			[12113] = {
				[1] = {
					["ShopItemId"] = 160115,
					["SubTabId"] = 1601,
				},
			},
			[12114] = {
				[1] = {
					["ShopItemId"] = 160116,
					["SubTabId"] = 1601,
				},
			},
			[12115] = {
				[1] = {
					["ShopItemId"] = 160117,
					["SubTabId"] = 1601,
				},
			},
			[12116] = {
				[1] = {
					["ShopItemId"] = 160118,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160317,
					["SubTabId"] = 1606,
				},
			},
			[12119] = {
				[1] = {
					["ShopItemId"] = 160119,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160120,
					["SubTabId"] = 1601,
				},
				[3] = {
					["ShopItemId"] = 160121,
					["SubTabId"] = 1601,
				},
			},
			[12120] = {
				[1] = {
					["ShopItemId"] = 160122,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160123,
					["SubTabId"] = 1601,
				},
				[3] = {
					["ShopItemId"] = 160124,
					["SubTabId"] = 1601,
				},
			},
			[12121] = {
				[1] = {
					["ShopItemId"] = 160125,
					["SubTabId"] = 1601,
				},
			},
			[12123] = {
				[1] = {
					["ShopItemId"] = 160140,
					["SubTabId"] = 1601,
				},
			},
			[12124] = {
				[1] = {
					["ShopItemId"] = 160141,
					["SubTabId"] = 1601,
				},
			},
			[12125] = {
				[1] = {
					["ShopItemId"] = 160142,
					["SubTabId"] = 1601,
				},
			},
			[12126] = {
				[1] = {
					["ShopItemId"] = 160143,
					["SubTabId"] = 1601,
				},
			},
			[12127] = {
				[1] = {
					["ShopItemId"] = 160144,
					["SubTabId"] = 1601,
				},
			},
			[12128] = {
				[1] = {
					["ShopItemId"] = 160126,
					["SubTabId"] = 1601,
				},
			},
			[12129] = {
				[1] = {
					["ShopItemId"] = 160127,
					["SubTabId"] = 1601,
				},
			},
			[12130] = {
				[1] = {
					["ShopItemId"] = 160128,
					["SubTabId"] = 1601,
				},
			},
			[12131] = {
				[1] = {
					["ShopItemId"] = 160129,
					["SubTabId"] = 1601,
				},
			},
			[12132] = {
				[1] = {
					["ShopItemId"] = 160130,
					["SubTabId"] = 1601,
				},
			},
			[12133] = {
				[1] = {
					["ShopItemId"] = 160131,
					["SubTabId"] = 1601,
				},
			},
			[12134] = {
				[1] = {
					["ShopItemId"] = 160133,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160319,
					["SubTabId"] = 1606,
				},
			},
			[12135] = {
				[1] = {
					["ShopItemId"] = 160132,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160318,
					["SubTabId"] = 1606,
				},
			},
			[12136] = {
				[1] = {
					["ShopItemId"] = 160134,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160135,
					["SubTabId"] = 1601,
				},
				[3] = {
					["ShopItemId"] = 160136,
					["SubTabId"] = 1601,
				},
			},
			[12137] = {
				[1] = {
					["ShopItemId"] = 160137,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160138,
					["SubTabId"] = 1601,
				},
				[3] = {
					["ShopItemId"] = 160139,
					["SubTabId"] = 1601,
				},
			},
			[12142] = {
				[1] = {
					["ShopItemId"] = 160145,
					["SubTabId"] = 1601,
				},
			},
			[12143] = {
				[1] = {
					["ShopItemId"] = 160146,
					["SubTabId"] = 1601,
				},
			},
			[12144] = {
				[1] = {
					["ShopItemId"] = 160147,
					["SubTabId"] = 1601,
				},
			},
			[12152] = {
				[1] = {
					["ShopItemId"] = 160164,
					["SubTabId"] = 1601,
				},
			},
			[12153] = {
				[1] = {
					["ShopItemId"] = 160226,
					["SubTabId"] = 1605,
				},
			},
			[12154] = {
				[1] = {
					["ShopItemId"] = 160148,
					["SubTabId"] = 1601,
				},
			},
			[12155] = {
				[1] = {
					["ShopItemId"] = 160149,
					["SubTabId"] = 1601,
				},
			},
			[12156] = {
				[1] = {
					["ShopItemId"] = 160150,
					["SubTabId"] = 1601,
				},
			},
			[12157] = {
				[1] = {
					["ShopItemId"] = 160151,
					["SubTabId"] = 1601,
				},
			},
			[12158] = {
				[1] = {
					["ShopItemId"] = 160152,
					["SubTabId"] = 1601,
				},
			},
			[12159] = {
				[1] = {
					["ShopItemId"] = 160153,
					["SubTabId"] = 1601,
				},
			},
			[12160] = {
				[1] = {
					["ShopItemId"] = 160154,
					["SubTabId"] = 1601,
				},
			},
			[12161] = {
				[1] = {
					["ShopItemId"] = 160155,
					["SubTabId"] = 1601,
				},
			},
			[12162] = {
				[1] = {
					["ShopItemId"] = 160156,
					["SubTabId"] = 1601,
				},
			},
			[12163] = {
				[1] = {
					["ShopItemId"] = 160157,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160158,
					["SubTabId"] = 1601,
				},
				[3] = {
					["ShopItemId"] = 160159,
					["SubTabId"] = 1601,
				},
			},
			[12164] = {
				[1] = {
					["ShopItemId"] = 160160,
					["SubTabId"] = 1601,
				},
				[2] = {
					["ShopItemId"] = 160161,
					["SubTabId"] = 1601,
				},
				[3] = {
					["ShopItemId"] = 160162,
					["SubTabId"] = 1601,
				},
			},
			[12168] = {
				[1] = {
					["ShopItemId"] = 160163,
					["SubTabId"] = 1601,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["Skin"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[240101] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140230,
					["SubTabId"] = 1401,
				},
			},
			[410201] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140259,
					["SubTabId"] = 1401,
				},
			},
			[530101] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140201,
					["SubTabId"] = 1401,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["Title"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = {
			[10022] = {
				[1] = {
					["ShopItemId"] = 802126,
					["SubTabId"] = 8021,
				},
			},
			[20061] = {
				[1] = {
					["ShopItemId"] = 802127,
					["SubTabId"] = 8021,
				},
			},
			[20065] = {
				[1] = {
					["ShopItemId"] = 802128,
					["SubTabId"] = 8021,
				},
			},
		},
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = {
			[10075] = {
				[1] = {
					["ShopItemId"] = 10004122,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004150,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004181,
					["SubTabId"] = 100041,
				},
			},
			[10076] = {
				[1] = {
					["ShopItemId"] = 10004123,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004151,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004182,
					["SubTabId"] = 100041,
				},
			},
			[10077] = {
				[1] = {
					["ShopItemId"] = 10004124,
					["SubTabId"] = 100041,
				},
				[2] = {
					["ShopItemId"] = 10004152,
					["SubTabId"] = 100041,
				},
				[3] = {
					["ShopItemId"] = 10004183,
					["SubTabId"] = 100041,
				},
			},
		},
		["Rouge"] = T.RT_1,
		["Shop"] = T.RT_1,
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["TitleFrame"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[10018] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140291,
					["SubTabId"] = 1401,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["Walnut"] = {
		["AbyssShop"] = {
			[2029] = {
				[1] = {
					["ShopItemId"] = 10000108,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000109,
					["SubTabId"] = 100001,
				},
			},
			[2045] = {
				[1] = {
					["ShopItemId"] = 10000120,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000121,
					["SubTabId"] = 100001,
				},
			},
			[2046] = {
				[1] = {
					["ShopItemId"] = 10000118,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000119,
					["SubTabId"] = 100001,
				},
			},
			[2047] = {
				[1] = {
					["ShopItemId"] = 10000114,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000115,
					["SubTabId"] = 100001,
				},
			},
			[2049] = {
				[1] = {
					["ShopItemId"] = 10000116,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000117,
					["SubTabId"] = 100001,
				},
			},
			[2050] = {
				[1] = {
					["ShopItemId"] = 10000112,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000113,
					["SubTabId"] = 100001,
				},
			},
			[2055] = {
				[1] = {
					["ShopItemId"] = 10000122,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000123,
					["SubTabId"] = 100001,
				},
			},
			[2056] = {
				[1] = {
					["ShopItemId"] = 10000124,
					["SubTabId"] = 100001,
				},
				[2] = {
					["ShopItemId"] = 10000125,
					["SubTabId"] = 100001,
				},
			},
		},
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[1000] = {
				[1] = {
					["ShopItemId"] = 151000,
					["SubTabId"] = 1801,
				},
			},
			[1001] = {
				[1] = {
					["ShopItemId"] = 151001,
					["SubTabId"] = 1801,
				},
			},
			[1002] = {
				[1] = {
					["ShopItemId"] = 151002,
					["SubTabId"] = 1801,
				},
			},
			[1003] = {
				[1] = {
					["ShopItemId"] = 151003,
					["SubTabId"] = 1801,
				},
			},
			[1006] = {
				[1] = {
					["ShopItemId"] = 151006,
					["SubTabId"] = 1801,
				},
			},
			[1007] = {
				[1] = {
					["ShopItemId"] = 151007,
					["SubTabId"] = 1801,
				},
			},
			[1009] = {
				[1] = {
					["ShopItemId"] = 151009,
					["SubTabId"] = 1801,
				},
			},
			[1011] = {
				[1] = {
					["ShopItemId"] = 151011,
					["SubTabId"] = 1801,
				},
			},
			[1012] = {
				[1] = {
					["ShopItemId"] = 151012,
					["SubTabId"] = 1801,
				},
			},
			[1014] = {
				[1] = {
					["ShopItemId"] = 151014,
					["SubTabId"] = 1801,
				},
			},
			[1015] = {
				[1] = {
					["ShopItemId"] = 151015,
					["SubTabId"] = 1801,
				},
			},
			[1018] = {
				[1] = {
					["ShopItemId"] = 151018,
					["SubTabId"] = 1801,
				},
			},
			[1019] = {
				[1] = {
					["ShopItemId"] = 151019,
					["SubTabId"] = 1801,
				},
			},
			[1020] = {
				[1] = {
					["ShopItemId"] = 151020,
					["SubTabId"] = 1801,
				},
			},
			[1021] = {
				[1] = {
					["ShopItemId"] = 151021,
					["SubTabId"] = 1801,
				},
			},
			[1023] = {
				[1] = {
					["ShopItemId"] = 151023,
					["SubTabId"] = 1801,
				},
			},
			[2001] = {
				[1] = {
					["ShopItemId"] = 152001,
					["SubTabId"] = 1802,
				},
			},
			[2002] = {
				[1] = {
					["ShopItemId"] = 152002,
					["SubTabId"] = 1802,
				},
			},
			[2003] = {
				[1] = {
					["ShopItemId"] = 152003,
					["SubTabId"] = 1802,
				},
			},
			[2004] = {
				[1] = {
					["ShopItemId"] = 152004,
					["SubTabId"] = 1802,
				},
			},
			[2005] = {
				[1] = {
					["ShopItemId"] = 152005,
					["SubTabId"] = 1802,
				},
			},
			[2006] = {
				[1] = {
					["ShopItemId"] = 152006,
					["SubTabId"] = 1802,
				},
			},
			[2007] = {
				[1] = {
					["ShopItemId"] = 152007,
					["SubTabId"] = 1802,
				},
			},
			[2008] = {
				[1] = {
					["ShopItemId"] = 152008,
					["SubTabId"] = 1802,
				},
			},
			[2009] = {
				[1] = {
					["ShopItemId"] = 152009,
					["SubTabId"] = 1802,
				},
			},
			[2010] = {
				[1] = {
					["ShopItemId"] = 152010,
					["SubTabId"] = 1802,
				},
			},
			[2011] = {
				[1] = {
					["ShopItemId"] = 152011,
					["SubTabId"] = 1802,
				},
			},
			[2012] = {
				[1] = {
					["ShopItemId"] = 152012,
					["SubTabId"] = 1802,
				},
			},
			[2013] = {
				[1] = {
					["ShopItemId"] = 152013,
					["SubTabId"] = 1802,
				},
			},
			[2014] = {
				[1] = {
					["ShopItemId"] = 152014,
					["SubTabId"] = 1802,
				},
			},
			[2015] = {
				[1] = {
					["ShopItemId"] = 152015,
					["SubTabId"] = 1802,
				},
			},
			[2016] = {
				[1] = {
					["ShopItemId"] = 152016,
					["SubTabId"] = 1802,
				},
			},
			[2017] = {
				[1] = {
					["ShopItemId"] = 152017,
					["SubTabId"] = 1802,
				},
			},
			[2018] = {
				[1] = {
					["ShopItemId"] = 152018,
					["SubTabId"] = 1802,
				},
			},
			[2019] = {
				[1] = {
					["ShopItemId"] = 152019,
					["SubTabId"] = 1802,
				},
			},
			[2020] = {
				[1] = {
					["ShopItemId"] = 152020,
					["SubTabId"] = 1802,
				},
			},
			[2021] = {
				[1] = {
					["ShopItemId"] = 152021,
					["SubTabId"] = 1802,
				},
			},
			[2022] = {
				[1] = {
					["ShopItemId"] = 152022,
					["SubTabId"] = 1802,
				},
			},
			[2023] = {
				[1] = {
					["ShopItemId"] = 152023,
					["SubTabId"] = 1802,
				},
			},
			[2024] = {
				[1] = {
					["ShopItemId"] = 152024,
					["SubTabId"] = 1802,
				},
			},
			[2025] = {
				[1] = {
					["ShopItemId"] = 152025,
					["SubTabId"] = 1802,
				},
			},
			[2026] = {
				[1] = {
					["ShopItemId"] = 152026,
					["SubTabId"] = 1802,
				},
			},
			[2027] = {
				[1] = {
					["ShopItemId"] = 152027,
					["SubTabId"] = 1802,
				},
			},
			[2028] = {
				[1] = {
					["ShopItemId"] = 152028,
					["SubTabId"] = 1802,
				},
			},
			[2030] = {
				[1] = {
					["ShopItemId"] = 152030,
					["SubTabId"] = 1802,
				},
			},
			[2031] = {
				[1] = {
					["ShopItemId"] = 152031,
					["SubTabId"] = 1802,
				},
			},
			[2037] = {
				[1] = {
					["ShopItemId"] = 152037,
					["SubTabId"] = 1802,
				},
			},
			[2038] = {
				[1] = {
					["ShopItemId"] = 152038,
					["SubTabId"] = 1802,
				},
			},
			[2039] = {
				[1] = {
					["ShopItemId"] = 152039,
					["SubTabId"] = 1802,
				},
			},
			[2040] = {
				[1] = {
					["ShopItemId"] = 152040,
					["SubTabId"] = 1802,
				},
			},
			[2041] = {
				[1] = {
					["ShopItemId"] = 152041,
					["SubTabId"] = 1802,
				},
			},
			[2042] = {
				[1] = {
					["ShopItemId"] = 152042,
					["SubTabId"] = 1802,
				},
			},
			[2043] = {
				[1] = {
					["ShopItemId"] = 152043,
					["SubTabId"] = 1802,
				},
			},
			[2044] = {
				[1] = {
					["ShopItemId"] = 152044,
					["SubTabId"] = 1802,
				},
			},
			[151321] = {
				[1] = {
					["ShopItemId"] = 651321,
					["SubTabId"] = 1803,
				},
			},
			[151322] = {
				[1] = {
					["ShopItemId"] = 651322,
					["SubTabId"] = 1803,
				},
			},
			[151323] = {
				[1] = {
					["ShopItemId"] = 651323,
					["SubTabId"] = 1803,
				},
			},
			[151324] = {
				[1] = {
					["ShopItemId"] = 651324,
					["SubTabId"] = 1803,
				},
			},
			[151325] = {
				[1] = {
					["ShopItemId"] = 651325,
					["SubTabId"] = 1803,
				},
			},
			[151326] = {
				[1] = {
					["ShopItemId"] = 651326,
					["SubTabId"] = 1803,
				},
			},
			[151331] = {
				[1] = {
					["ShopItemId"] = 651331,
					["SubTabId"] = 1803,
				},
			},
			[151332] = {
				[1] = {
					["ShopItemId"] = 651332,
					["SubTabId"] = 1803,
				},
			},
			[151333] = {
				[1] = {
					["ShopItemId"] = 651333,
					["SubTabId"] = 1803,
				},
			},
			[151334] = {
				[1] = {
					["ShopItemId"] = 651334,
					["SubTabId"] = 1803,
				},
			},
			[151335] = {
				[1] = {
					["ShopItemId"] = 651335,
					["SubTabId"] = 1803,
				},
			},
			[151336] = {
				[1] = {
					["ShopItemId"] = 651336,
					["SubTabId"] = 1803,
				},
			},
			[151711] = {
				[1] = {
					["ShopItemId"] = 651711,
					["SubTabId"] = 1803,
				},
			},
			[151712] = {
				[1] = {
					["ShopItemId"] = 651712,
					["SubTabId"] = 1803,
				},
			},
			[151713] = {
				[1] = {
					["ShopItemId"] = 651713,
					["SubTabId"] = 1803,
				},
			},
			[151714] = {
				[1] = {
					["ShopItemId"] = 651714,
					["SubTabId"] = 1803,
				},
			},
			[151721] = {
				[1] = {
					["ShopItemId"] = 651721,
					["SubTabId"] = 1803,
				},
			},
			[151722] = {
				[1] = {
					["ShopItemId"] = 651722,
					["SubTabId"] = 1803,
				},
			},
			[151723] = {
				[1] = {
					["ShopItemId"] = 651723,
					["SubTabId"] = 1803,
				},
			},
			[151724] = {
				[1] = {
					["ShopItemId"] = 651724,
					["SubTabId"] = 1803,
				},
			},
			[151731] = {
				[1] = {
					["ShopItemId"] = 651731,
					["SubTabId"] = 1803,
				},
			},
			[151732] = {
				[1] = {
					["ShopItemId"] = 651732,
					["SubTabId"] = 1803,
				},
			},
			[151733] = {
				[1] = {
					["ShopItemId"] = 651733,
					["SubTabId"] = 1803,
				},
			},
			[151734] = {
				[1] = {
					["ShopItemId"] = 651734,
					["SubTabId"] = 1803,
				},
			},
			[151741] = {
				[1] = {
					["ShopItemId"] = 651741,
					["SubTabId"] = 1803,
				},
			},
			[151742] = {
				[1] = {
					["ShopItemId"] = 651742,
					["SubTabId"] = 1803,
				},
			},
			[151743] = {
				[1] = {
					["ShopItemId"] = 651743,
					["SubTabId"] = 1803,
				},
			},
			[151744] = {
				[1] = {
					["ShopItemId"] = 651744,
					["SubTabId"] = 1803,
				},
			},
			[151745] = {
				[1] = {
					["ShopItemId"] = 651745,
					["SubTabId"] = 1803,
				},
			},
			[151746] = {
				[1] = {
					["ShopItemId"] = 651746,
					["SubTabId"] = 1803,
				},
			},
			[151751] = {
				[1] = {
					["ShopItemId"] = 651751,
					["SubTabId"] = 1803,
				},
			},
			[151752] = {
				[1] = {
					["ShopItemId"] = 651752,
					["SubTabId"] = 1803,
				},
			},
			[151753] = {
				[1] = {
					["ShopItemId"] = 651753,
					["SubTabId"] = 1803,
				},
			},
			[151754] = {
				[1] = {
					["ShopItemId"] = 651754,
					["SubTabId"] = 1803,
				},
			},
			[151755] = {
				[1] = {
					["ShopItemId"] = 651755,
					["SubTabId"] = 1803,
				},
			},
			[151756] = {
				[1] = {
					["ShopItemId"] = 651756,
					["SubTabId"] = 1803,
				},
			},
			[151761] = {
				[1] = {
					["ShopItemId"] = 651761,
					["SubTabId"] = 1803,
				},
			},
			[151762] = {
				[1] = {
					["ShopItemId"] = 651762,
					["SubTabId"] = 1803,
				},
			},
			[151763] = {
				[1] = {
					["ShopItemId"] = 651763,
					["SubTabId"] = 1803,
				},
			},
			[151764] = {
				[1] = {
					["ShopItemId"] = 651764,
					["SubTabId"] = 1803,
				},
			},
			[151765] = {
				[1] = {
					["ShopItemId"] = 651765,
					["SubTabId"] = 1803,
				},
			},
			[151766] = {
				[1] = {
					["ShopItemId"] = 651766,
					["SubTabId"] = 1803,
				},
			},
			[151911] = {
				[1] = {
					["ShopItemId"] = 651911,
					["SubTabId"] = 1803,
				},
			},
			[151921] = {
				[1] = {
					["ShopItemId"] = 651921,
					["SubTabId"] = 1803,
				},
			},
			[151922] = {
				[1] = {
					["ShopItemId"] = 651922,
					["SubTabId"] = 1803,
				},
			},
			[151931] = {
				[1] = {
					["ShopItemId"] = 651931,
					["SubTabId"] = 1803,
				},
			},
			[151941] = {
				[1] = {
					["ShopItemId"] = 651941,
					["SubTabId"] = 1803,
				},
			},
			[151951] = {
				[1] = {
					["ShopItemId"] = 651951,
					["SubTabId"] = 1803,
				},
			},
			[151952] = {
				[1] = {
					["ShopItemId"] = 651952,
					["SubTabId"] = 1803,
				},
			},
			[151961] = {
				[1] = {
					["ShopItemId"] = 651961,
					["SubTabId"] = 1803,
				},
			},
			[151962] = {
				[1] = {
					["ShopItemId"] = 651962,
					["SubTabId"] = 1803,
				},
			},
			[153011] = {
				[1] = {
					["ShopItemId"] = 653011,
					["SubTabId"] = 1803,
				},
			},
			[153013] = {
				[1] = {
					["ShopItemId"] = 653013,
					["SubTabId"] = 1803,
				},
			},
			[156151] = {
				[1] = {
					["ShopItemId"] = 656151,
					["SubTabId"] = 1803,
				},
			},
			[156152] = {
				[1] = {
					["ShopItemId"] = 656152,
					["SubTabId"] = 1803,
				},
			},
			[156153] = {
				[1] = {
					["ShopItemId"] = 656153,
					["SubTabId"] = 1803,
				},
			},
			[156154] = {
				[1] = {
					["ShopItemId"] = 656154,
					["SubTabId"] = 1803,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["Weapon"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[10101] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159101,
					["SubTabId"] = 1503,
				},
			},
			[10102] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159102,
					["SubTabId"] = 1503,
				},
			},
			[10103] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159103,
					["SubTabId"] = 1503,
				},
			},
			[10104] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159104,
					["SubTabId"] = 1503,
				},
			},
			[10105] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159105,
					["SubTabId"] = 1503,
				},
			},
			[10201] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159106,
					["SubTabId"] = 1503,
				},
			},
			[10202] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159107,
					["SubTabId"] = 1503,
				},
			},
			[10203] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159108,
					["SubTabId"] = 1503,
				},
			},
			[10204] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159109,
					["SubTabId"] = 1503,
				},
			},
			[10206] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159111,
					["SubTabId"] = 1503,
				},
			},
			[10208] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159155,
					["SubTabId"] = 1503,
				},
			},
			[10301] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159115,
					["SubTabId"] = 1503,
				},
			},
			[10302] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159116,
					["SubTabId"] = 1503,
				},
			},
			[10303] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159117,
					["SubTabId"] = 1503,
				},
			},
			[10304] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159118,
					["SubTabId"] = 1503,
				},
			},
			[10305] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159161,
					["SubTabId"] = 1503,
				},
			},
			[10401] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159119,
					["SubTabId"] = 1503,
				},
			},
			[10402] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159120,
					["SubTabId"] = 1503,
				},
			},
			[10403] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159121,
					["SubTabId"] = 1503,
				},
			},
			[10404] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159157,
					["SubTabId"] = 1503,
				},
			},
			[10501] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159122,
					["SubTabId"] = 1503,
				},
			},
			[10502] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159123,
					["SubTabId"] = 1503,
				},
			},
			[10503] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159124,
					["SubTabId"] = 1503,
				},
			},
			[10504] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159125,
					["SubTabId"] = 1503,
				},
			},
			[10601] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159126,
					["SubTabId"] = 1503,
				},
			},
			[10602] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159127,
					["SubTabId"] = 1503,
				},
			},
			[10603] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159128,
					["SubTabId"] = 1503,
				},
			},
			[20101] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159129,
					["SubTabId"] = 1503,
				},
			},
			[20102] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159130,
					["SubTabId"] = 1503,
				},
			},
			[20103] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159131,
					["SubTabId"] = 1503,
				},
			},
			[20201] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159132,
					["SubTabId"] = 1503,
				},
			},
			[20203] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159133,
					["SubTabId"] = 1503,
				},
			},
			[20205] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159134,
					["SubTabId"] = 1503,
				},
			},
			[20301] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159135,
					["SubTabId"] = 1503,
				},
			},
			[20303] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159137,
					["SubTabId"] = 1503,
				},
			},
			[20304] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159138,
					["SubTabId"] = 1503,
				},
			},
			[20305] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159139,
					["SubTabId"] = 1503,
				},
			},
			[20401] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159140,
					["SubTabId"] = 1503,
				},
			},
			[20402] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159141,
					["SubTabId"] = 1503,
				},
			},
			[20403] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159142,
					["SubTabId"] = 1503,
				},
			},
			[20405] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159143,
					["SubTabId"] = 1503,
				},
			},
			[20406] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159162,
					["SubTabId"] = 1503,
				},
			},
			[20407] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159159,
					["SubTabId"] = 1503,
				},
			},
			[20501] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159144,
					["SubTabId"] = 1503,
				},
			},
			[20502] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159145,
					["SubTabId"] = 1503,
				},
			},
			[20503] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159146,
					["SubTabId"] = 1503,
				},
			},
			[20504] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159147,
					["SubTabId"] = 1503,
				},
			},
			[20505] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159158,
					["SubTabId"] = 1503,
				},
			},
			[20506] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159156,
					["SubTabId"] = 1503,
				},
			},
			[20507] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159148,
					["SubTabId"] = 1503,
				},
			},
			[20509] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159150,
					["SubTabId"] = 1503,
				},
			},
			[20510] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159149,
					["SubTabId"] = 1503,
				},
			},
			[20512] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159160,
					["SubTabId"] = 1503,
				},
			},
			[20601] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159151,
					["SubTabId"] = 1503,
				},
			},
			[20602] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159152,
					["SubTabId"] = 1503,
				},
			},
			[20603] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159153,
					["SubTabId"] = 1503,
				},
			},
			[20604] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 159154,
					["SubTabId"] = 1503,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["WeaponAccessory"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = {
			[10017] = {
				[1] = {
					["ShopItemId"] = 704004,
					["SubTabId"] = 7040,
				},
			},
			[10021] = {
				[1] = {
					["ShopItemId"] = 704005,
					["SubTabId"] = 7040,
				},
			},
		},
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = {
			[10022] = {
				[1] = {
					["ShopItemId"] = 10005101,
					["SubTabId"] = 100051,
				},
			},
		},
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[10001] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140218,
					["SubTabId"] = 1401,
				},
			},
			[10002] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140216,
					["SubTabId"] = 1401,
				},
			},
			[10003] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140217,
					["SubTabId"] = 1401,
				},
			},
			[10004] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140215,
					["SubTabId"] = 1401,
				},
			},
			[10005] = {
				[1] = {
					["ShopItemId"] = 140120,
					["SubTabId"] = 1402,
				},
			},
			[10006] = {
				[1] = {
					["ShopItemId"] = 140121,
					["SubTabId"] = 1402,
				},
			},
			[10007] = {
				[1] = {
					["ShopItemId"] = 140122,
					["SubTabId"] = 1402,
				},
			},
			[10008] = {
				[1] = {
					["ShopItemId"] = 140123,
					["SubTabId"] = 1402,
				},
			},
			[10009] = {
				[1] = {
					["ShopItemId"] = 140124,
					["SubTabId"] = 1402,
				},
			},
			[10010] = {
				[1] = {
					["ShopItemId"] = 140125,
					["SubTabId"] = 1402,
				},
			},
			[10011] = {
				[1] = {
					["ShopItemId"] = 140126,
					["SubTabId"] = 1402,
				},
			},
			[10012] = {
				[1] = {
					["ShopItemId"] = 140127,
					["SubTabId"] = 1402,
				},
			},
			[10013] = {
				[1] = {
					["ShopItemId"] = 140128,
					["SubTabId"] = 1402,
				},
			},
			[10014] = {
				[1] = {
					["ShopItemId"] = 140129,
					["SubTabId"] = 1402,
				},
			},
			[10015] = {
				[1] = {
					["ShopItemId"] = 140130,
					["SubTabId"] = 1402,
				},
			},
			[10016] = {
				[1] = {
					["ShopItemId"] = 140131,
					["SubTabId"] = 1402,
				},
			},
			[10024] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140247,
					["SubTabId"] = 1401,
				},
			},
			[10025] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140248,
					["SubTabId"] = 1401,
				},
			},
			[10026] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140249,
					["SubTabId"] = 1401,
				},
			},
			[10027] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140250,
					["SubTabId"] = 1401,
				},
			},
			[10028] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140251,
					["SubTabId"] = 1401,
				},
			},
			[10029] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140252,
					["SubTabId"] = 1401,
				},
			},
			[10030] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140261,
					["SubTabId"] = 1401,
				},
			},
			[10031] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140262,
					["SubTabId"] = 1401,
				},
			},
			[10032] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140263,
					["SubTabId"] = 1401,
				},
			},
			[10033] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140264,
					["SubTabId"] = 1401,
				},
			},
			[10034] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140265,
					["SubTabId"] = 1401,
				},
			},
			[10035] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140266,
					["SubTabId"] = 1401,
				},
			},
			[10036] = {
				[1] = {
					["ShopItemId"] = 13110001,
					["SubTabId"] = 1212,
				},
			},
			[10037] = {
				[1] = {
					["ShopItemId"] = 13110002,
					["SubTabId"] = 1212,
				},
			},
			[10038] = {
				[1] = {
					["ShopItemId"] = 13110003,
					["SubTabId"] = 1212,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
	["WeaponSkin"] = {
		["AbyssShop"] = T.RT_1,
		["AccessoryDropShop"] = T.RT_1,
		["AutoChessShop"] = T.RT_1,
		["ExploreBadgeShop"] = T.RT_1,
		["FishingShop"] = T.RT_1,
		["GiftShop"] = T.RT_1,
		["HuaxuEventShop"] = T.RT_1,
		["HuaxuExploreShop"] = T.RT_1,
		["RaidShopSeason01"] = T.RT_1,
		["Rouge"] = T.RT_1,
		["Shop"] = {
			[3010101] = {
				[1] = {
					["ShopItemId"] = 120103,
					["SubTabId"] = 1208,
				},
			},
			[3010102] = {
				[1] = {
					["ShopItemId"] = 120108,
					["SubTabId"] = 1208,
				},
			},
			[3010104] = {
				[1] = {
					["ShopItemId"] = 120119,
					["SubTabId"] = 1208,
				},
			},
			[3010105] = {
				[1] = {
					["ShopItemId"] = 120130,
					["SubTabId"] = 1208,
				},
			},
			[3010106] = {
				[1] = {
					["ShopItemId"] = 120114,
					["SubTabId"] = 1208,
				},
			},
			[3010107] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140260,
					["SubTabId"] = 1401,
				},
			},
			[3010108] = {
				[1] = {
					["ShopItemId"] = 120138,
					["SubTabId"] = 1208,
				},
			},
			[3010201] = {
				[1] = {
					["ShopItemId"] = 120104,
					["SubTabId"] = 1208,
				},
			},
			[3010202] = {
				[1] = {
					["ShopItemId"] = 120101,
					["SubTabId"] = 1208,
				},
			},
			[3010203] = {
				[1] = {
					["ShopItemId"] = 120132,
					["SubTabId"] = 1208,
				},
			},
			[3010204] = {
				[1] = {
					["ShopItemId"] = 120112,
					["SubTabId"] = 1208,
				},
			},
			[3010205] = {
				[1] = {
					["ShopItemId"] = 120136,
					["SubTabId"] = 1208,
				},
			},
			[3010302] = {
				[1] = {
					["ShopItemId"] = 120125,
					["SubTabId"] = 1208,
				},
			},
			[3010303] = {
				[1] = {
					["ShopItemId"] = 120129,
					["SubTabId"] = 1208,
				},
			},
			[3010401] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140202,
					["SubTabId"] = 1401,
				},
			},
			[3010403] = {
				[1] = {
					["ShopItemId"] = 120118,
					["SubTabId"] = 1208,
				},
			},
			[3010404] = {
				[1] = {
					["ShopItemId"] = 120133,
					["SubTabId"] = 1208,
				},
			},
			[3010405] = {
				[1] = {
					["ShopItemId"] = 120113,
					["SubTabId"] = 1208,
				},
			},
			[3010406] = {
				[1] = {
					["ShopItemId"] = 120137,
					["SubTabId"] = 1208,
				},
			},
			[3010407] = {
				[1] = {
					["ShopItemId"] = 120143,
					["SubTabId"] = 1208,
				},
			},
			[3010501] = {
				[1] = {
					["AccessOrder"] = 2,
					["ShopItemId"] = 140231,
					["SubTabId"] = 1401,
				},
			},
			[3010502] = {
				[1] = {
					["ShopItemId"] = 120124,
					["SubTabId"] = 1208,
				},
			},
			[3010503] = {
				[1] = {
					["ShopItemId"] = 120144,
					["SubTabId"] = 1208,
				},
			},
			[3010601] = {
				[1] = {
					["ShopItemId"] = 120122,
					["SubTabId"] = 1208,
				},
			},
			[3010603] = {
				[1] = {
					["ShopItemId"] = 120131,
					["SubTabId"] = 1208,
				},
			},
			[3010605] = {
				[1] = {
					["ShopItemId"] = 120117,
					["SubTabId"] = 1208,
				},
			},
			[3010607] = {
				[1] = {
					["ShopItemId"] = 120141,
					["SubTabId"] = 1208,
				},
			},
			[3010701] = {
				[1] = {
					["ShopItemId"] = 120120,
					["SubTabId"] = 1208,
				},
			},
			[3010703] = {
				[1] = {
					["ShopItemId"] = 120134,
					["SubTabId"] = 1208,
				},
			},
			[3010705] = {
				[1] = {
					["ShopItemId"] = 120115,
					["SubTabId"] = 1208,
				},
			},
			[3010707] = {
				[1] = {
					["ShopItemId"] = 120139,
					["SubTabId"] = 1208,
				},
			},
			[3010801] = {
				[1] = {
					["ShopItemId"] = 120121,
					["SubTabId"] = 1208,
				},
			},
			[3010802] = {
				[1] = {
					["ShopItemId"] = 120135,
					["SubTabId"] = 1208,
				},
			},
			[3010803] = {
				[1] = {
					["ShopItemId"] = 120116,
					["SubTabId"] = 1208,
				},
			},
			[3010804] = {
				[1] = {
					["ShopItemId"] = 120140,
					["SubTabId"] = 1208,
				},
			},
			[3010805] = {
				[1] = {
					["ShopItemId"] = 120142,
					["SubTabId"] = 1208,
				},
			},
			[3010901] = {
				[1] = {
					["ShopItemId"] = 120126,
					["SubTabId"] = 1208,
				},
			},
			[3011001] = {
				[1] = {
					["ShopItemId"] = 120128,
					["SubTabId"] = 1208,
				},
			},
			[3011101] = {
				[1] = {
					["ShopItemId"] = 120123,
					["SubTabId"] = 1208,
				},
			},
			[3011201] = {
				[1] = {
					["ShopItemId"] = 120127,
					["SubTabId"] = 1208,
				},
			},
		},
		["SoloTreasureShop"] = T.RT_1,
		["WeeklyDungeonShop"] = T.RT_1,
	},
})