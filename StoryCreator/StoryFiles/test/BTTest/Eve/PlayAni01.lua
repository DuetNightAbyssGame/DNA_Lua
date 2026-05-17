return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17665839108691",
			["startPort"] = "StoryStart",
			["endStory"] = "176658391468376",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176658391468376",
			["startPort"] = "Success",
			["endStory"] = "17665839108695",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17665839108691"] = {
			["isStoryNode"] = true,
			["key"] = "17665839108691",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 870,
				["y"] = 335
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
		["17665839108695"] = {
			["isStoryNode"] = true,
			["key"] = "17665839108695",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1522,
				["y"] = 318
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176658391468376"] = {
			["isStoryNode"] = true,
			["key"] = "176658391468376",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1181.6666666666667,
				["y"] = 319
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
						["startQuest"] = "176658391468377",
						["startPort"] = "QuestStart",
						["endQuest"] = "1766584741457572",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766584741457572",
						["startPort"] = "Out",
						["endQuest"] = "1766584750921767",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766584750921767",
						["startPort"] = "Out",
						["endQuest"] = "176658391468385",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["176658391468377"] = {
						["key"] = "176658391468377",
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
					["176658391468385"] = {
						["key"] = "176658391468385",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1768,
							["y"] = 332
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176658391468393"] = {
						["key"] = "176658391468393",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1766584741457572"] = {
						["key"] = "1766584741457572",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1114,
							["y"] = 308
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["1766584750921767"] = {
						["key"] = "1766584750921767",
						["type"] = "SendMessageNode",
						["name"] = "发送消息PlayAni01",
						["pos"] = {
							["x"] = 1412,
							["y"] = 326
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "PlayAni01",
							["UnitId"] = 111001
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}