return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17642999524141",
			["startPort"] = "StoryStart",
			["endStory"] = "1764300086735183",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1764300086735183",
			["startPort"] = "Success",
			["endStory"] = "17642999524155",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17642999524141"] = {
			["isStoryNode"] = true,
			["key"] = "17642999524141",
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
		["17642999524155"] = {
			["isStoryNode"] = true,
			["key"] = "17642999524155",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1690,
				["y"] = 322
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1764300086735183"] = {
			["isStoryNode"] = true,
			["key"] = "1764300086735183",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1284,
				["y"] = 310
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
						["startQuest"] = "1764300086735184",
						["startPort"] = "QuestStart",
						["endQuest"] = "1764300289363713",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764300289363713",
						["startPort"] = "Out",
						["endQuest"] = "1764300086736191",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1764300086735184"] = {
						["key"] = "1764300086735184",
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
					["1764300086736191"] = {
						["key"] = "1764300086736191",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1588,
							["y"] = 304
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1764300086736198"] = {
						["key"] = "1764300086736198",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1764300289363713"] = {
						["key"] = "1764300289363713",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1204,
							["y"] = 320
						},
						["propsData"] = {
							["GuideId"] = 111
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}