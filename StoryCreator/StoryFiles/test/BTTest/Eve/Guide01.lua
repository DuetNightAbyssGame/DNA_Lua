return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17665847845881",
			["startPort"] = "StoryStart",
			["endStory"] = "1766584789689102",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1766584789689102",
			["startPort"] = "Success",
			["endStory"] = "17665847845895",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17665847845881"] = {
			["isStoryNode"] = true,
			["key"] = "17665847845881",
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
		["17665847845895"] = {
			["isStoryNode"] = true,
			["key"] = "17665847845895",
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
		["1766584789689102"] = {
			["isStoryNode"] = true,
			["key"] = "1766584789689102",
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
						["startQuest"] = "1766584799011421",
						["startPort"] = "Out",
						["endQuest"] = "1766584799011420",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766584789689103",
						["startPort"] = "QuestStart",
						["endQuest"] = "1766584799011421",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766584799011420",
						["startPort"] = "Out",
						["endQuest"] = "1766584789690111",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1766584789689103"] = {
						["key"] = "1766584789689103",
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
					["1766584789690111"] = {
						["key"] = "1766584789690111",
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
					["1766584789690119"] = {
						["key"] = "1766584789690119",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1766584799011420"] = {
						["key"] = "1766584799011420",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto1",
						["pos"] = {
							["x"] = 1440.3333333333333,
							["y"] = 272
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Guide01",
							["UnitId"] = 111001
						}
					},
					["1766584799011421"] = {
						["key"] = "1766584799011421",
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