-- Source Excel file path: ..\datas\GameFlowConfig.xlsx
local T = {}
T.RT_1 = {
		"ImmersiveStory",
		"GetItemPage",
		"SkillFeature",
		"SystemGuideWithUI",
		"SystemGuideWithoutUI",
		"GuideMain",
		"LevelDelivery",
		"StorylineCountdown",
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("GameFlow", {
	GetItemPage = {
		BlockChannels = T.RT_1,
		Channel = "GetItemPage",
		Priority = 100,
	},
	GuideMain = {
		BlockChannels = {
			"ImmersiveStory",
			"GetItemPage",
			"SkillFeature",
			"Sojourn",
			"LevelDelivery",
			"StorylineCountdown",
		},
		Channel = "GuideMain",
		Priority = 100,
	},
	ImmersiveStory = {
		BlockChannels = {
			"ImmersiveStory",
			"OpenSystemUI",
			"GetItemPage",
			"SkillFeature",
			"SystemGuideWithoutUI",
			"GuideMain",
			"LevelDelivery",
			"ShowHudReward",
			"StorylineCountdown",
		},
		Channel = "ImmersiveStory",
		Priority = 100,
	},
	LevelDelivery = {
		BlockChannels = {
			"ImmersiveStory",
			"OpenSystemUI",
			"GetItemPage",
			"SkillFeature",
			"SystemGuideWithUI",
			"SystemGuideWithoutUI",
			"GuideMain",
			"Sojourn",
			"LevelDelivery",
			"StorylineCountdown",
		},
		Channel = "LevelDelivery",
		Priority = 200,
	},
	OpenSystemUI = {
		BlockChannels = {
			"ImmersiveStory",
			"LevelDelivery",
			"ShowHudReward",
			"StorylineCountdown",
		},
		Channel = "OpenSystemUI",
		Priority = 100,
	},
	ShowHudReward = {
		BlockChannels = {
			"OpenSystemUI",
			"ShowHudReward",
			"StorylineCountdown",
		},
		Channel = "ShowHudReward",
		Priority = 99,
	},
	SkillFeature = {
		BlockChannels = T.RT_1,
		Channel = "SkillFeature",
		Priority = 100,
	},
	Sojourn = {
		BlockChannels = {
			"SystemGuideWithUI",
			"SystemGuideWithoutUI",
			"GuideMain",
			"LevelDelivery",
			"StorylineCountdown",
		},
		Channel = "Sojourn",
		Priority = 100,
	},
	StorylineCountdown = {
		BlockChannels = {
			"ImmersiveStory",
			"OpenSystemUI",
			"GetItemPage",
			"SkillFeature",
			"SystemGuideWithUI",
			"SystemGuideWithoutUI",
			"GuideMain",
			"Sojourn",
			"LevelDelivery",
			"ShowHudReward",
			"StorylineCountdown",
		},
		Channel = "StorylineCountdown",
		Priority = 0,
	},
	SystemGuideWithUI = {
		BlockChannels = {
			"GetItemPage",
			"SkillFeature",
			"SystemGuideWithUI",
			"SystemGuideWithoutUI",
			"Sojourn",
			"LevelDelivery",
			"StorylineCountdown",
		},
		Channel = "SystemGuideWithUI",
		Priority = 100,
	},
	SystemGuideWithoutUI = {
		BlockChannels = {
			"ImmersiveStory",
			"OpenSystemUI",
			"GetItemPage",
			"SkillFeature",
			"SystemGuideWithUI",
			"SystemGuideWithoutUI",
			"Sojourn",
			"LevelDelivery",
			"StorylineCountdown",
		},
		Channel = "SystemGuideWithoutUI",
		Priority = 100,
	},
})