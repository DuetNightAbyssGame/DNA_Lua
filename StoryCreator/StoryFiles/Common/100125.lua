return {
	["storyName"] = "未命名故事",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1715581588169984375",
			["startPort"] = "StoryStart",
			["endStory"] = "17154124528011146",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17154124528011146",
			["startPort"] = "Success",
			["endStory"] = "1715581588169984376",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17154124528011146"] = {
			["isStoryNode"] = true,
			["key"] = "17154124528011146",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 380,
				["y"] = 88
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
				["bIsNotifyGameMode"] = false,
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
						["startQuest"] = "17154124528011150",
						["startPort"] = "QuestStart",
						["endQuest"] = "1754294903793498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1754294903793498",
						["startPort"] = "Out",
						["endQuest"] = "17154124528011151",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17154124528011150"] = {
						["key"] = "17154124528011150",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 100,
							["y"] = 140
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17154124528011151"] = {
						["key"] = "17154124528011151",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 852,
							["y"] = 178
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17154124528011152"] = {
						["key"] = "17154124528011152",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1436,
							["y"] = 512
						},
						["propsData"] = {}
					},
					["1754294903793498"] = {
						["key"] = "1754294903793498",
						["type"] = "FailBlackScreenNode",
						["name"] = "失败黑屏节点",
						["pos"] = {
							["x"] = 498.48478260869604,
							["y"] = 160.35273205055822
						},
						["propsData"] = {
							["Text"] = "FailBlackScreenHode_1",
							["FadeInTime"] = 0,
							["FadeOutTime"] = 0,
							["ContinueTime"] = 2
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1715581588169984375"] = {
			["isStoryNode"] = true,
			["key"] = "1715581588169984375",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 64,
				["y"] = 90
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
		["1715581588169984376"] = {
			["isStoryNode"] = true,
			["key"] = "1715581588169984376",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 720,
				["y"] = 100
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}