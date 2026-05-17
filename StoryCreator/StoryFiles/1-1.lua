return {
	["storyName"] = "未命名任务",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732783210333413944",
			["startPort"] = "StoryStart",
			["endStory"] = "1732783210333413946",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732783210333413946",
			["startPort"] = "Success",
			["endStory"] = "1732783210333413945",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732783210333413944"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210333413944",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 100,
				["y"] = 140
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
		["1732783210333413945"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210333413945",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 857,
				["y"] = 111
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1732783210333413946"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210333413946",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 431,
				["y"] = 100.75
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
						["startQuest"] = "1732783210333413947",
						["startPort"] = "QuestStart",
						["endQuest"] = "17131748239904652",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17131748239904652",
						["startPort"] = "Success",
						["endQuest"] = "1732783210333413948",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17131748239904652",
						["startPort"] = "Fail",
						["endQuest"] = "171394070707798760",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "171394070707798760",
						["startPort"] = "Out",
						["endQuest"] = "1732783210333413948",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17131748239904652",
						["startPort"] = "PassiveFail",
						["endQuest"] = "171394070707798760",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17131748239904652"] = {
						["key"] = "17131748239904652",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待开始特殊任务开始并完成",
						["pos"] = {
							["x"] = 281.3403864128803,
							["y"] = 170.29025920893628
						},
						["propsData"] = {
							["SpecialConfigId"] = 10000,
							["BlackScreenImmediately"] = false
						}
					},
					["171394070707798760"] = {
						["key"] = "171394070707798760",
						["type"] = "TestPrintNode",
						["name"] = "测试打印",
						["pos"] = {
							["x"] = 597.7219996684191,
							["y"] = 243.25931218539918
						},
						["propsData"] = {
							["Text"] = "tyx特殊任务失败"
						}
					},
					["1732783210333413947"] = {
						["key"] = "1732783210333413947",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -102.80000000000001,
							["y"] = 167.6
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210333413948"] = {
						["key"] = "1732783210333413948",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 980.701361440492,
							["y"] = 167.51251646903825
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210333413949"] = {
						["key"] = "1732783210333413949",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 988.2777777777778,
							["y"] = 322.3888888888889
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}