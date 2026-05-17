return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17571528245722231663",
			["startPort"] = "StoryStart",
			["endStory"] = "17571528245722231665",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17571528245722231665",
			["startPort"] = "Success",
			["endStory"] = "17571528245722231664",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17571528245722231663"] = {
			["isStoryNode"] = true,
			["key"] = "17571528245722231663",
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
		["17571528245722231664"] = {
			["isStoryNode"] = true,
			["key"] = "17571528245722231664",
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
		["17571528245722231665"] = {
			["isStoryNode"] = true,
			["key"] = "17571528245722231665",
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
						["startQuest"] = "17571528245722231666",
						["startPort"] = "QuestStart",
						["endQuest"] = "17571528245722231670",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571528245722231670",
						["startPort"] = "Out",
						["endQuest"] = "17571528245722231667",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17571528245722231666"] = {
						["key"] = "17571528245722231666",
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
					["17571528245722231667"] = {
						["key"] = "17571528245722231667",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1716,
							["y"] = 318
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17571528245722231668"] = {
						["key"] = "17571528245722231668",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17571528245722231670"] = {
						["key"] = "17571528245722231670",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1284,
							["y"] = 320
						},
						["propsData"] = {
							["GuideId"] = 2009
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}