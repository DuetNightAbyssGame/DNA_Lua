return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17643143827771",
			["startPort"] = "StoryStart",
			["endStory"] = "1764314400841126",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1764314400841126",
			["startPort"] = "Success",
			["endStory"] = "17643143827785",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17643143827771"] = {
			["isStoryNode"] = true,
			["key"] = "17643143827771",
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
		["17643143827785"] = {
			["isStoryNode"] = true,
			["key"] = "17643143827785",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1470,
				["y"] = 292
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1764314400841126"] = {
			["isStoryNode"] = true,
			["key"] = "1764314400841126",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1114,
				["y"] = 286
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
						["startQuest"] = "1764314400841127",
						["startPort"] = "QuestStart",
						["endQuest"] = "1764314419250575",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764314419250575",
						["startPort"] = "Out",
						["endQuest"] = "1764314400841134",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1764314400841127"] = {
						["key"] = "1764314400841127",
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
					["1764314400841134"] = {
						["key"] = "1764314400841134",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1510,
							["y"] = 306
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1764314400841141"] = {
						["key"] = "1764314400841141",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1764314419250575"] = {
						["key"] = "1764314419250575",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1144,
							["y"] = 324
						},
						["propsData"] = {
							["GuideId"] = 112
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}