return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1767004057600369191",
			["startPort"] = "StoryStart",
			["endStory"] = "1767004057600369193",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1767004057600369193",
			["startPort"] = "Success",
			["endStory"] = "1767004057600369192",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1767004057600369191"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057600369191",
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
		["1767004057600369192"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057600369192",
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
		["1767004057600369193"] = {
			["isStoryNode"] = true,
			["key"] = "1767004057600369193",
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
						["startQuest"] = "1767004057600369194",
						["startPort"] = "QuestStart",
						["endQuest"] = "1767004057600369197",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767004057600369197",
						["startPort"] = "Out",
						["endQuest"] = "1767004057600369198",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767004057600369198",
						["startPort"] = "Out",
						["endQuest"] = "1767004057600369195",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1767004057600369194"] = {
						["key"] = "1767004057600369194",
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
					["1767004057600369195"] = {
						["key"] = "1767004057600369195",
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
					["1767004057600369196"] = {
						["key"] = "1767004057600369196",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1767004057600369197"] = {
						["key"] = "1767004057600369197",
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
					["1767004057600369198"] = {
						["key"] = "1767004057600369198",
						["type"] = "SendMessageNode",
						["name"] = "发送消息PlayAni01",
						["pos"] = {
							["x"] = 1412,
							["y"] = 326
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "PlayAni01",
							["UnitId"] = 200002
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}