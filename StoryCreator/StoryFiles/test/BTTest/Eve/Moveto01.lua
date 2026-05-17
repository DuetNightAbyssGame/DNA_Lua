return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17665811088113896108",
			["startPort"] = "StoryStart",
			["endStory"] = "17665811181793896283",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17665811181793896283",
			["startPort"] = "Success",
			["endStory"] = "17665811088113896111",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17665811088113896108"] = {
			["isStoryNode"] = true,
			["key"] = "17665811088113896108",
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
		["17665811088113896111"] = {
			["isStoryNode"] = true,
			["key"] = "17665811088113896111",
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
		["17665811181793896283"] = {
			["isStoryNode"] = true,
			["key"] = "17665811181793896283",
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
						["startQuest"] = "17665811181793896284",
						["startPort"] = "QuestStart",
						["endQuest"] = "17665823361924605412",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17665823361924605412",
						["startPort"] = "Out",
						["endQuest"] = "17665812163323896986",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17665812163323896986",
						["startPort"] = "Out",
						["endQuest"] = "17665811181793896287",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17665811181793896284"] = {
						["key"] = "17665811181793896284",
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
					["17665811181793896287"] = {
						["key"] = "17665811181793896287",
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
					["17665811181793896290"] = {
						["key"] = "17665811181793896290",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17665812163323896986"] = {
						["key"] = "17665812163323896986",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto1",
						["pos"] = {
							["x"] = 1674.9999999999998,
							["y"] = 424
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Moveto01",
							["UnitId"] = 111001
						}
					},
					["17665823361924605412"] = {
						["key"] = "17665823361924605412",
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