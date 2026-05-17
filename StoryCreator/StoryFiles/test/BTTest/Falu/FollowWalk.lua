return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17683725850721448954",
			["startPort"] = "StoryStart",
			["endStory"] = "17683725850721448956",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17683725850721448956",
			["startPort"] = "Success",
			["endStory"] = "17683725850721448955",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17683725850721448954"] = {
			["isStoryNode"] = true,
			["key"] = "17683725850721448954",
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
		["17683725850721448955"] = {
			["isStoryNode"] = true,
			["key"] = "17683725850721448955",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2032,
				["y"] = 290
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17683725850721448956"] = {
			["isStoryNode"] = true,
			["key"] = "17683725850721448956",
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
						["startQuest"] = "17683725850721448957",
						["startPort"] = "QuestStart",
						["endQuest"] = "17683725850721448961",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17683725850721448961",
						["startPort"] = "Out",
						["endQuest"] = "17683725850721448960",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17683725850721448960",
						["startPort"] = "Out",
						["endQuest"] = "17683725850721448958",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17683725850721448957"] = {
						["key"] = "17683725850721448957",
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
					["17683725850721448958"] = {
						["key"] = "17683725850721448958",
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
					["17683725850721448959"] = {
						["key"] = "17683725850721448959",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17683725850721448960"] = {
						["key"] = "17683725850721448960",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto1",
						["pos"] = {
							["x"] = 1672.9999999999998,
							["y"] = 426
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "FollowWalk",
							["UnitId"] = 200006
						}
					},
					["17683725850721448961"] = {
						["key"] = "17683725850721448961",
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