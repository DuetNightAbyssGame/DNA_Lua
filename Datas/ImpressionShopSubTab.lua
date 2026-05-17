-- Source Excel file path: ..\datas\Talk\ImpressionShop.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ImpressionShopSubTab", {
	[1001] = {
		MainTabId = 1,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_BENEFIT",
		SubTabId = 1001,
	},
	[1002] = {
		MainTabId = 1,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_MORALITY",
		SubTabId = 1002,
	},
	[1003] = {
		MainTabId = 1,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_WISDOM",
		SubTabId = 1003,
	},
	[1004] = {
		MainTabId = 1,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_EMPATHY",
		SubTabId = 1004,
	},
	[1005] = {
		MainTabId = 1,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_CHAOS",
		SubTabId = 1005,
	},
	[2001] = {
		MainTabId = 2,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_BENEFIT",
		SubTabId = 2001,
	},
	[2002] = {
		MainTabId = 2,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_MORALITY",
		SubTabId = 2002,
	},
	[2003] = {
		MainTabId = 2,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_WISDOM",
		SubTabId = 2003,
	},
	[2004] = {
		MainTabId = 2,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_EMPATHY",
		SubTabId = 2004,
	},
	[2005] = {
		MainTabId = 2,
		SubName = "UI_IMPRESSIONSHOP_SUBTAB_CHAOS",
		SubTabId = 2005,
	},
})