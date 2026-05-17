-- Source Excel file path: ..\datas\CharVoice.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CharVoiceType", {
	[1] = {
		Text = "UI_CharVoice_Normal",
		Type = 1,
	},
	[2] = {
		Text = "UI_CharVoice_Battle",
		Type = 2,
	},
})