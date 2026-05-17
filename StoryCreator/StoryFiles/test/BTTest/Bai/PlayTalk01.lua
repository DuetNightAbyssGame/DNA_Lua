return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1767004057600369253",
			["startPort"] = "StoryStart",
			["endStory"] = "1767004057600369255",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1767004057600369255",
			["startPort"] = "Success",
			["endStory"] = "1767004057600369254",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1767004057600369253"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057600369253",
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
		["1767004057600369254"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057600369254",
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
		["1767004057600369255"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057600369255",
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
						["startQuest"] = "1767004057600369256",
						["startPort"] = "QuestStart",
						["endQuest"] = "1767004057600369260",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767004057600369260",
						["startPort"] = "Out",
						["endQuest"] = "1767004057600369259",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767004057600369259",
						["startPort"] = "Out",
						["endQuest"] = "1767004057600369257",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1767004057600369256"] = {
						["key"] = "1767004057600369256",
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
					["1767004057600369257"] = {
						["key"] = "1767004057600369257",
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
					["1767004057600369258"] = {
						["key"] = "1767004057600369258",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1767004057600369259"] = {
						["key"] = "1767004057600369259",
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
					["1767004057600369260"] = {
						["key"] = "1767004057600369260",
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