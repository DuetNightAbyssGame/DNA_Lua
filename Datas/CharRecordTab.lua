-- Source Excel file path: ..\datas\Tab\ArmoryTab.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("CharRecordTab", {
	[1] = {
		IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Voice",
		TabId = 1,
		Text = "UI_CharVoice_Tab",
	},
	[2] = {
		IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_File",
		TabId = 2,
		Text = "UI_Chardata_Data",
	},
})