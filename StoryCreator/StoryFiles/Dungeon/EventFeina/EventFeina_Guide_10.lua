return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17571528991222865056",
			["startPort"] = "StoryStart",
			["endStory"] = "17571528991222865058",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17571528991222865058",
			["startPort"] = "Success",
			["endStory"] = "17571528991222865057",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17571528991222865056"] = {
			["isStoryNode"] = true,
			["key"] = "17571528991222865056",
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
		["17571528991222865057"] = {
			["isStoryNode"] = true,
			["key"] = "17571528991222865057",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1652,
				["y"] = 334
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17571528991222865058"] = {
			["isStoryNode"] = true,
			["key"] = "17571528991222865058",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1220,
				["y"] = 288
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
						["startQuest"] = "17571528991222865059",
						["startPort"] = "QuestStart",
						["endQuest"] = "17571528991222865063",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571528991222865063",
						["startPort"] = "Out",
						["endQuest"] = "17571528991222865060",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17571528991222865059"] = {
						["key"] = "17571528991222865059",
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
					["17571528991222865060"] = {
						["key"] = "17571528991222865060",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1712,
							["y"] = 332
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17571528991222865061"] = {
						["key"] = "17571528991222865061",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17571528991222865063"] = {
						["key"] = "17571528991222865063",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1284,
							["y"] = 320
						},
						["propsData"] = {
							["GuideId"] = 2010
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}