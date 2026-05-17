return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17665850171181",
			["startPort"] = "StoryStart",
			["endStory"] = "1766585049657242",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1766585049657242",
			["startPort"] = "Success",
			["endStory"] = "17665850171195",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17665850171181"] = {
			["isStoryNode"] = true,
			["key"] = "17665850171181",
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
		["17665850171195"] = {
			["isStoryNode"] = true,
			["key"] = "17665850171195",
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
		["1766585049657242"] = {
			["isStoryNode"] = true,
			["key"] = "1766585049657242",
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
						["startQuest"] = "1766585049657247",
						["startPort"] = "QuestStart",
						["endQuest"] = "1766585049657251",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766585049657251",
						["startPort"] = "Out",
						["endQuest"] = "1766585049657250",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766585049657250",
						["startPort"] = "Out",
						["endQuest"] = "1766585049657248",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1766585049657247"] = {
						["key"] = "1766585049657247",
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
					["1766585049657248"] = {
						["key"] = "1766585049657248",
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
					["1766585049657249"] = {
						["key"] = "1766585049657249",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1766585049657250"] = {
						["key"] = "1766585049657250",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto1",
						["pos"] = {
							["x"] = 1674.9999999999998,
							["y"] = 424
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "FollowRun",
							["UnitId"] = 111001
						}
					},
					["1766585049657251"] = {
						["key"] = "1766585049657251",
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