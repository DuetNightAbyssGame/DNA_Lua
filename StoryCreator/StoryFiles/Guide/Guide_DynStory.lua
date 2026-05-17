return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1733915609138728182",
			["startPort"] = "StoryStart",
			["endStory"] = "1733915609138728184",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1733915609138728184",
			["startPort"] = "Success",
			["endStory"] = "1733915609138728183",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1733915609138728182"] = {
			["isStoryNode"] = true,
			["key"] = "1733915609138728182",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1733915609138728183"] = {
			["isStoryNode"] = true,
			["key"] = "1733915609138728183",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2800,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1733915609138728184"] = {
			["isStoryNode"] = true,
			["key"] = "1733915609138728184",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1674.3076923076924,
				["y"] = 378.76923076923083
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
				["QuestDeatil"] = "",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1733915609138728185",
						["startPort"] = "QuestStart",
						["endQuest"] = "1733915609138728188",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1733915609138728188",
						["startPort"] = "Out",
						["endQuest"] = "1733915609138728186",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1733915609138728185"] = {
						["key"] = "1733915609138728185",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1733915609138728186"] = {
						["key"] = "1733915609138728186",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1733915609138728187"] = {
						["key"] = "1733915609138728187",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1733915609138728188"] = {
						["key"] = "1733915609138728188",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1637.3846153846155,
							["y"] = 400.923076923077
						},
						["propsData"] = {
							["GuideId"] = 47
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}