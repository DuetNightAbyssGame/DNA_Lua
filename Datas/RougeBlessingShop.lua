-- Source Excel file path: ..\datas\RougeLike\RougeLike_Shop.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("RougeBlessingShop", {
	[1] = {
		Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Rouge_BlessingMainT.T_Tab_Rouge_BlessingMainT'",
		MainName = "UI_Rouge_Shop_SubTab_Blessing",
		MainTabId = 1,
		Type = "Blessing",
	},
})