return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17458509578232222655",
			["startPort"] = "StoryStart",
			["endStory"] = "17458509597912222731",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17458509597912222731",
			["startPort"] = "Success",
			["endStory"] = "17458509578232222658",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17458509578232222655"] = {
			["isStoryNode"] = true,
			["key"] = "17458509578232222655",
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
		["17458509578232222658"] = {
			["isStoryNode"] = true,
			["key"] = "17458509578232222658",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1534,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17458509597912222731"] = {
			["isStoryNode"] = true,
			["key"] = "17458509597912222731",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1164,
				["y"] = 316
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
						["startQuest"] = "17458509597912222732",
						["startPort"] = "QuestStart",
						["endQuest"] = "17458542634662223532",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17458542634662223532",
						["startPort"] = "Out",
						["endQuest"] = "17458509597912222735",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17458509597912222732"] = {
						["key"] = "17458509597912222732",
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
					["17458509597912222735"] = {
						["key"] = "17458509597912222735",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1686,
							["y"] = 304
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17458509597912222738"] = {
						["key"] = "17458509597912222738",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17458542634662223532"] = {
						["key"] = "17458542634662223532",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1188,
							["y"] = 280
						},
						["propsData"] = {
							["GuideId"] = 76
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}