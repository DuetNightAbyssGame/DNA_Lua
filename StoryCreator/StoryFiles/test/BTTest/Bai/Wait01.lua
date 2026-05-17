return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1767091837498369552",
			["startPort"] = "StoryStart",
			["endStory"] = "1767091837498369554",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1767091837498369554",
			["startPort"] = "Success",
			["endStory"] = "1767091837498369553",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1767091837498369552"] = {
			["isStoryNode"] = true,
			["key"] = "1767091837498369552",
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
		["1767091837498369553"] = {
			["isStoryNode"] = true,
			["key"] = "1767091837498369553",
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
		["1767091837498369554"] = {
			["isStoryNode"] = true,
			["key"] = "1767091837498369554",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1260,
				["y"] = 308
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
						["startQuest"] = "1767091837498369555",
						["startPort"] = "QuestStart",
						["endQuest"] = "1767091837498369559",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767091837498369559",
						["startPort"] = "Out",
						["endQuest"] = "1767091837498369558",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767091837498369558",
						["startPort"] = "Out",
						["endQuest"] = "1767091837498369556",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1767091837498369555"] = {
						["key"] = "1767091837498369555",
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
					["1767091837498369556"] = {
						["key"] = "1767091837498369556",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1974.0000000000002,
							["y"] = 435.66666666666674
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1767091837498369557"] = {
						["key"] = "1767091837498369557",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1767091837498369558"] = {
						["key"] = "1767091837498369558",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto1",
						["pos"] = {
							["x"] = 1674.9999999999998,
							["y"] = 424
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Wait01",
							["UnitId"] = 200002
						}
					},
					["1767091837498369559"] = {
						["key"] = "1767091837498369559",
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