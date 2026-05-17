return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17667416091016757754",
			["startPort"] = "StoryStart",
			["endStory"] = "17667416091016757756",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17667416091016757756",
			["startPort"] = "Success",
			["endStory"] = "17667416091016757755",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17667416091016757754"] = {
			["isStoryNode"] = true,
			["key"] = "17667416091016757754",
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
		["17667416091016757755"] = {
			["isStoryNode"] = true,
			["key"] = "17667416091016757755",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1620,
				["y"] = 312
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17667416091016757756"] = {
			["isStoryNode"] = true,
			["key"] = "17667416091016757756",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1196,
				["y"] = 280
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
						["startQuest"] = "17667416091016757757",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667416091016757761",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667416091016757761",
						["startPort"] = "Out",
						["endQuest"] = "17667416091016757760",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667416091016757760",
						["startPort"] = "Out",
						["endQuest"] = "17667416091016757758",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17667416091016757757"] = {
						["key"] = "17667416091016757757",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1056.3333333333333,
							["y"] = 438.33333333333337
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667416091016757758"] = {
						["key"] = "17667416091016757758",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1972.3333333333335,
							["y"] = 404.00000000000006
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667416091016757759"] = {
						["key"] = "17667416091016757759",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17667416091016757760"] = {
						["key"] = "17667416091016757760",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto1",
						["pos"] = {
							["x"] = 1674.9999999999998,
							["y"] = 424
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "PlayTalk01",
							["UnitId"] = 200002
						}
					},
					["17667416091016757761"] = {
						["key"] = "17667416091016757761",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1386.3333333333333,
							["y"] = 416
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