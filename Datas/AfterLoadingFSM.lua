-- Source Excel file path: ..\datas\AfterLoading.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("AfterLoadingFSM", {
	BeginState = {
		FSMState = "BeginState",
		NextState = "JumpToRogueMain",
	},
	DungeonUI = {
		FSMState = "DungeonUI",
		NextState = "OpenForcePopup",
	},
	DynamicQuest = {
		FSMState = "DynamicQuest",
		NextState = "EndState",
	},
	EndState = {
		FSMState = "EndState",
	},
	Entertainment = {
		FSMState = "Entertainment",
		NextState = "TriggerGuide",
	},
	GameplayReward = {
		FSMState = "GameplayReward",
		NextState = "SystemUnlock",
	},
	JumpToRogueMain = {
		FSMState = "JumpToRogueMain",
		NextState = "GameplayReward",
	},
	LayoutPlan = {
		FSMState = "LayoutPlan",
		NextState = "DynamicQuest",
	},
	MainLineQuest = {
		FSMState = "MainLineQuest",
		NextState = "LayoutPlan",
	},
	OpenForcePopup = {
		FSMState = "OpenForcePopup",
		NextState = "MainLineQuest",
	},
	SystemUnlock = {
		FSMState = "SystemUnlock",
		NextState = "Entertainment",
	},
	TriggerGuide = {
		FSMState = "TriggerGuide",
		NextState = "DungeonUI",
	},
})