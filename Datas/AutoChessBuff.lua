-- Source Excel file path: ..\datas\GameEvent\AutoChessEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AutoChessBuff", {
	[4020701] = {
		BuffDes = "UI_AutoChess_BuffDes1",
		BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Buff01.T_Activity_Autochess_Buff01'",
		BuffId = 4020701,
		BuffName = "UI_AutoChess_BuffName1",
		BuffType = 1,
		Id = 4020701,
	},
	[4020702] = {
		BuffDes = "UI_AutoChess_BuffDes2",
		BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Buff02.T_Activity_Autochess_Buff02'",
		BuffId = 4020702,
		BuffName = "UI_AutoChess_BuffName2",
		BuffType = 1,
		Id = 4020702,
	},
})