return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1767004057599369067",
			["startPort"] = "StoryStart",
			["endStory"] = "1767004057599369069",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1767004057599369069",
			["startPort"] = "Success",
			["endStory"] = "1767004057599369068",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1767004057599369067"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057599369067",
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
		["1767004057599369068"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057599369068",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1850,
				["y"] = 286
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1767004057599369069"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057599369069",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1388,
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
						["startQuest"] = "1767004057599369074",
						["startPort"] = "Out",
						["endQuest"] = "1767004057599369073",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767004057599369070",
						["startPort"] = "QuestStart",
						["endQuest"] = "1767004057599369074",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767004057599369073",
						["startPort"] = "Out",
						["endQuest"] = "1767004057599369071",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1767004057599369070"] = {
						["key"] = "1767004057599369070",
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
					["1767004057599369071"] = {
						["key"] = "1767004057599369071",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1966,
							["y"] = 286
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1767004057599369072"] = {
						["key"] = "1767004057599369072",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1767004057599369073"] = {
						["key"] = "1767004057599369073",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto1",
						["pos"] = {
							["x"] = 1440.3333333333333,
							["y"] = 272
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Guide01",
							["UnitId"] = 200002
						}
					},
					["1767004057599369074"] = {
						["key"] = "1767004057599369074",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1151.6666666666667,
							["y"] = 264
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