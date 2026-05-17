return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1767004057600369315",
			["startPort"] = "StoryStart",
			["endStory"] = "1767004057600369317",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1767004057600369317",
			["startPort"] = "Success",
			["endStory"] = "1767004057600369316",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1767004057600369315"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057600369315",
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
		["1767004057600369316"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057600369316",
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
		["1767004057600369317"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057600369317",
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
						["startQuest"] = "1767004057600369321",
						["startPort"] = "Out",
						["endQuest"] = "1767004057600369319",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1767004057600369318",
						["startPort"] = "QuestStart",
						["endQuest"] = "1767004057600369322",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767004057600369322",
						["startPort"] = "Out",
						["endQuest"] = "1767004057600369321",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1767004057600369318"] = {
						["key"] = "1767004057600369318",
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
					["1767004057600369319"] = {
						["key"] = "1767004057600369319",
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
					["1767004057600369320"] = {
						["key"] = "1767004057600369320",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1767004057600369321"] = {
						["key"] = "1767004057600369321",
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
					["1767004057600369322"] = {
						["key"] = "1767004057600369322",
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