return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17652856508731",
			["startPort"] = "StoryStart",
			["endStory"] = "1765285835545126",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1765285835545126",
			["startPort"] = "Success",
			["endStory"] = "17652856508745",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17652856508731"] = {
			["isStoryNode"] = true,
			["key"] = "17652856508731",
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
		["17652856508745"] = {
			["isStoryNode"] = true,
			["key"] = "17652856508745",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1586,
				["y"] = 310
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1765285835545126"] = {
			["isStoryNode"] = true,
			["key"] = "1765285835545126",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1196,
				["y"] = 298
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
						["startQuest"] = "1765285835545127",
						["startPort"] = "QuestStart",
						["endQuest"] = "1765285863786673",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1765285863786673",
						["startPort"] = "Out",
						["endQuest"] = "1765285835545134",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1765285835545127"] = {
						["key"] = "1765285835545127",
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
					["1765285835545134"] = {
						["key"] = "1765285835545134",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1520,
							["y"] = 294
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1765285835545141"] = {
						["key"] = "1765285835545141",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1765285863786673"] = {
						["key"] = "1765285863786673",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1154,
							["y"] = 298
						},
						["propsData"] = {
							["GuideId"] = 114
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}