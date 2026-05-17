return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17693940035811",
			["startPort"] = "StoryStart",
			["endStory"] = "1769394056568184",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1769394056568184",
			["startPort"] = "Success",
			["endStory"] = "17693940035825",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17693940035811"] = {
			["isStoryNode"] = true,
			["key"] = "17693940035811",
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
		["17693940035825"] = {
			["isStoryNode"] = true,
			["key"] = "17693940035825",
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
		["1769394056568184"] = {
			["isStoryNode"] = true,
			["key"] = "1769394056568184",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1380,
				["y"] = 276
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
						["startQuest"] = "1769394056568185",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769394075311646",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769394075311646",
						["startPort"] = "Out",
						["endQuest"] = "1769394056568193",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1769394056568185"] = {
						["key"] = "1769394056568185",
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
					["1769394056568193"] = {
						["key"] = "1769394056568193",
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
					["1769394056568201"] = {
						["key"] = "1769394056568201",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1769394075311646"] = {
						["key"] = "1769394075311646",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1362,
							["y"] = 368
						},
						["propsData"] = {
							["GuideId"] = 118
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}