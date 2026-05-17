-- Source Excel file path: ..\datas\GameEvent\AutoChessEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AutoChessPoint", {
	[1] = {
		RankIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Level01.T_Activity_Autochess_Level01'",
		RankId = 1,
		RankMaxPoint = 10,
		RankName = "UI_AutoChess_Rank1",
		VictoryBasePoint = 10,
	},
	[2] = {
		RankIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Level02.T_Activity_Autochess_Level02'",
		RankId = 2,
		RankMaxPoint = 30,
		RankMissionId = 1001,
		RankName = "UI_AutoChess_Rank2",
		VictoryBasePoint = 15,
	},
	[3] = {
		RankIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Level03.T_Activity_Autochess_Level03'",
		RankId = 3,
		RankMaxPoint = 120,
		RankName = "UI_AutoChess_Rank3",
		VictoryBasePoint = 20,
	},
	[4] = {
		RankIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Level04.T_Activity_Autochess_Level04'",
		RankId = 4,
		RankMaxPoint = 150,
		RankMissionId = 1004,
		RankName = "UI_AutoChess_Rank4",
		VictoryBasePoint = 25,
	},
	[5] = {
		RankIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Level05.T_Activity_Autochess_Level05'",
		RankId = 5,
		RankMaxPoint = 300,
		RankName = "UI_AutoChess_Rank5",
		VictoryBasePoint = 30,
	},
	[6] = {
		RankIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Level06.T_Activity_Autochess_Level06'",
		RankId = 6,
		RankMaxPoint = 350,
		RankMissionId = 1007,
		RankName = "UI_AutoChess_Rank6",
		VictoryBasePoint = 35,
	},
	[7] = {
		RankIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Level07.T_Activity_Autochess_Level07'",
		RankId = 7,
		RankMaxPoint = 400,
		RankName = "UI_AutoChess_Rank7",
		VictoryBasePoint = 40,
	},
	[8] = {
		RankIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Level08.T_Activity_Autochess_Level08'",
		RankId = 8,
		RankMaxPoint = 750,
		RankMissionId = 1011,
		RankName = "UI_AutoChess_Rank8",
		VictoryBasePoint = 50,
	},
	[9] = {
		RankIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_Autochess_Level09.T_Activity_Autochess_Level09'",
		RankId = 9,
		RankMaxPoint = 99999,
		RankMissionId = 1015,
		RankName = "UI_AutoChess_Rank9",
		VictoryBasePoint = 50,
	},
})