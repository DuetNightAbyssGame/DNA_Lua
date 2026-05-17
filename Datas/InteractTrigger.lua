-- Source Excel file path: ..\datas\InteractTrigger.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("InteractTrigger", {
	[511564] = {
		DetectionCM = 500,
		InteractTriggerId = 511564,
		RewardId = 4000020,
		StorylineFilePath = "Impression\\East02\\Gossip\\511564.story",
	},
	[511582] = {
		DetectionCM = 500,
		InteractTriggerId = 511582,
		RewardId = 4000021,
		StorylineFilePath = "Impression\\East02\\Gossip\\511582_EndTalk.story",
	},
	[77000008] = {
		DetectionCM = 700,
		InteractTriggerId = 77000008,
		RewardId = 4000001,
		StorylineFilePath = "test_interact.story",
	},
})