-- Source Excel file path: ..\datas\SkinGacha.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("HighLightResult", {
	[1] = {
		HighLightBp = "WidgetBlueprint'/Game/UI/WBP/GachaNew/Widget/GachaGet/WBP_GachaGet_Widget_SuperCoin.WBP_GachaGet_Widget_SuperCoin'",
		HighLightId = 1,
		HighLightItemId = 111,
		HighLightType = 6,
		ItemCount = 25,
	},
	[2] = {
		HighLightBp = "WidgetBlueprint'/Game/UI/WBP/GachaNew/Widget/GachaGet/WBP_GachaGet_Widget_SuperCoin_Max.WBP_GachaGet_Widget_SuperCoin_Max'",
		HighLightId = 2,
		HighLightItemId = 111,
		HighLightType = 6,
		ItemCount = 50,
	},
})