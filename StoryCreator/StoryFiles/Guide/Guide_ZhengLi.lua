return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17727956984921",
			["startPort"] = "StoryStart",
			["endStory"] = "177279570851096",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177279570851096",
			["startPort"] = "Success",
			["endStory"] = "17727956984925",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17727956984921"] = {
			["isStoryNode"] = true,
			["key"] = "17727956984921",
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
		["17727956984925"] = {
			["isStoryNode"] = true,
			["key"] = "17727956984925",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1646,
				["y"] = 264
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["177279570851096"] = {
			["isStoryNode"] = true,
			["key"] = "177279570851096",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1308,
				["y"] = 268
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
						["startQuest"] = "177279570851097",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772795722782477",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772795722782477",
						["startPort"] = "Out",
						["endQuest"] = "1772795708510105",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177279570851097"] = {
						["key"] = "177279570851097",
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
					["1772795708510105"] = {
						["key"] = "1772795708510105",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1756,
							["y"] = 384
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1772795708510113"] = {
						["key"] = "1772795708510113",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1772795722782477"] = {
						["key"] = "1772795722782477",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1232,
							["y"] = 392
						},
						["propsData"] = {
							["GuideId"] = 131
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}