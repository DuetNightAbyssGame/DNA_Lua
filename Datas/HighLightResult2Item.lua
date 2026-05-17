local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("HighLightResult2Item", {
	[6] = {
		[111] = {
			[25] = {
				["Path"] = "WidgetBlueprint'/Game/UI/WBP/GachaNew/Widget/GachaGet/WBP_GachaGet_Widget_SuperCoin.WBP_GachaGet_Widget_SuperCoin'",
				["Seq"] = 1,
			},
			[50] = {
				["Path"] = "WidgetBlueprint'/Game/UI/WBP/GachaNew/Widget/GachaGet/WBP_GachaGet_Widget_SuperCoin_Max.WBP_GachaGet_Widget_SuperCoin_Max'",
				["Seq"] = 2,
			},
		},
	},
})