-- Source Excel file path: ..\datas\CurrencyForm.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CurrencyForm", {
	[100] = {
		IfAdd = true,
		IfMax = false,
		ResourceID = 100,
	},
	[103] = {
		IfAdd = true,
		IfMax = true,
		ResourceID = 103,
	},
})