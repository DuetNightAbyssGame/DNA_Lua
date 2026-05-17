-- Source Excel file path: ..\datas\KeyboardSet.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("FrenchCorrect", {
	["^"] = {
		Key = "LeftBracket",
		RawKey = "^",
	},
	["²"] = {
		Key = "Tilde",
		RawKey = "²",
	},
	["ù"] = {
		Key = "Apostrophe",
		RawKey = "ù",
	},
})