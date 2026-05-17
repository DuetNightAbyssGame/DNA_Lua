-- Source Excel file path: ..\datas\GameEvent\ComeBackEvent.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("ComeBackQuest", {
	[114001] = {
		EventQuestId = 114001,
		PhaseUnlockInterval = 24,
		QuestPhase = {
			1401,
			1402,
			1403,
		},
		QuestProgressResource = 2005,
		QuestReward = {
			1140011,
			1140012,
			1140013,
			1140014,
			1140015,
		},
		QuestRewardProgress = {
			100,
			200,
			300,
			400,
			500,
		},
	},
})