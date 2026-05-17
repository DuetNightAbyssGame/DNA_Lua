return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17571535053954765364",
			["startPort"] = "StoryStart",
			["endStory"] = "17571535053954765366",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17571535053954765366",
			["startPort"] = "Success",
			["endStory"] = "17571535053954765365",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17571535053954765364"] = {
			["isStoryNode"] = true,
			["key"] = "17571535053954765364",
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
		["17571535053954765365"] = {
			["isStoryNode"] = true,
			["key"] = "17571535053954765365",
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
		["17571535053954765366"] = {
			["isStoryNode"] = true,
			["key"] = "17571535053954765366",
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
						["startQuest"] = "17571535053954765367",
						["startPort"] = "QuestStart",
						["endQuest"] = "17571535053954765371",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571535053954765371",
						["startPort"] = "Out",
						["endQuest"] = "17571535053954765368",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17571535053954765367"] = {
						["key"] = "17571535053954765367",
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
					["17571535053954765368"] = {
						["key"] = "17571535053954765368",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2418,
							["y"] = 304
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17571535053954765369"] = {
						["key"] = "17571535053954765369",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17571535053954765371"] = {
						["key"] = "17571535053954765371",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1284,
							["y"] = 320
						},
						["propsData"] = {
							["GuideId"] = 2012
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}