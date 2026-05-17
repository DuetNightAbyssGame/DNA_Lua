return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1768313807645380770",
			["startPort"] = "StoryStart",
			["endStory"] = "1768313807645380772",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1768313807645380772",
			["startPort"] = "Success",
			["endStory"] = "1768313807645380771",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1768313807645380770"] = {
			["isStoryNode"] = true,
			["key"] = "1768313807645380770",
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
		["1768313807645380771"] = {
			["isStoryNode"] = true,
			["key"] = "1768313807645380771",
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
		["1768313807645380772"] = {
			["isStoryNode"] = true,
			["key"] = "1768313807645380772",
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
						["startQuest"] = "1768313807645380773",
						["startPort"] = "QuestStart",
						["endQuest"] = "1768313807645380777",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768313807645380777",
						["startPort"] = "Out",
						["endQuest"] = "1768313807645380776",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768313807645380776",
						["startPort"] = "Out",
						["endQuest"] = "1768313807645380774",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1768313807645380773"] = {
						["key"] = "1768313807645380773",
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
					["1768313807645380774"] = {
						["key"] = "1768313807645380774",
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
					["1768313807645380775"] = {
						["key"] = "1768313807645380775",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1768313807645380776"] = {
						["key"] = "1768313807645380776",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto1",
						["pos"] = {
							["x"] = 1672.9999999999998,
							["y"] = 426
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "FollowWalk",
							["UnitId"] = 111001
						}
					},
					["1768313807645380777"] = {
						["key"] = "1768313807645380777",
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