return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17667160200241785344",
			["startPort"] = "StoryStart",
			["endStory"] = "17667160200251785346",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17667160200251785346",
			["startPort"] = "Success",
			["endStory"] = "17667160200251785345",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17667160200241785344"] = {
			["isStoryNode"] = true,
			["key"] = "17667160200241785344",
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
		["17667160200251785345"] = {
			["isStoryNode"] = true,
			["key"] = "17667160200251785345",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1740,
				["y"] = 330
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17667160200251785346"] = {
			["isStoryNode"] = true,
			["key"] = "17667160200251785346",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1280,
				["y"] = 292
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
						["startQuest"] = "17667160200251785350",
						["startPort"] = "Out",
						["endQuest"] = "17667160200251785348",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17667160200251785347",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667160846542128394",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667160846542128394",
						["startPort"] = "Out",
						["endQuest"] = "17667160200251785350",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17667160200251785347"] = {
						["key"] = "17667160200251785347",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 764,
							["y"] = 326
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667160200251785348"] = {
						["key"] = "17667160200251785348",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2036,
							["y"] = 310
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667160200251785349"] = {
						["key"] = "17667160200251785349",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17667160200251785350"] = {
						["key"] = "17667160200251785350",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1614,
							["y"] = 306
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "StareAt01",
							["UnitId"] = 200002
						}
					},
					["17667160846542128394"] = {
						["key"] = "17667160846542128394",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1216,
							["y"] = 292
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}