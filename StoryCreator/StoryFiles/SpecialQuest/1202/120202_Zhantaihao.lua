return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17616403829591",
			["startPort"] = "StoryStart",
			["endStory"] = "176164039225887",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176164039225887",
			["startPort"] = "Success",
			["endStory"] = "17616403829595",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17616403829591"] = {
			["isStoryNode"] = true,
			["key"] = "17616403829591",
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
		["17616403829595"] = {
			["isStoryNode"] = true,
			["key"] = "17616403829595",
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
		["176164039225887"] = {
			["isStoryNode"] = true,
			["key"] = "176164039225887",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1448,
				["y"] = 302
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
						["startQuest"] = "176164039225888",
						["startPort"] = "QuestStart",
						["endQuest"] = "1761640409354498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176164039225888",
						["startPort"] = "QuestStart",
						["endQuest"] = "1761640405267433",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1761640409354498",
						["startPort"] = "Out",
						["endQuest"] = "1761640392259102",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["176164039225888"] = {
						["key"] = "176164039225888",
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
					["176164039225995"] = {
						["key"] = "176164039225995",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1770.625,
							["y"] = 320.625
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1761640392259102"] = {
						["key"] = "1761640392259102",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1613.8461538461538,
							["y"] = 577.6923076923077
						},
						["propsData"] = {}
					},
					["1761640405267433"] = {
						["key"] = "1761640405267433",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 1295.875,
							["y"] = 367.25
						},
						["propsData"] = {}
					},
					["1761640409354498"] = {
						["key"] = "1761640409354498",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1357.2083333333333,
							["y"] = 558.25
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}