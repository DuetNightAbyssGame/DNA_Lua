return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17688981426971",
			["startPort"] = "StoryStart",
			["endStory"] = "1768898151881113",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1768898151881113",
			["startPort"] = "Success",
			["endStory"] = "17688981426985",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17688981426971"] = {
			["isStoryNode"] = true,
			["key"] = "17688981426971",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 884,
				["y"] = 342
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
		["17688981426985"] = {
			["isStoryNode"] = true,
			["key"] = "17688981426985",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1674,
				["y"] = 346
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1768898151881113"] = {
			["isStoryNode"] = true,
			["key"] = "1768898151881113",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1274,
				["y"] = 334
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
						["startQuest"] = "1768898151881114",
						["startPort"] = "QuestStart",
						["endQuest"] = "1768898161865485",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768898161865485",
						["startPort"] = "Out",
						["endQuest"] = "1768898172072708",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768898172072708",
						["startPort"] = "Out",
						["endQuest"] = "1768898151882122",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1768898151881114"] = {
						["key"] = "1768898151881114",
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
					["1768898151882122"] = {
						["key"] = "1768898151882122",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2070,
							["y"] = 332
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1768898151882130"] = {
						["key"] = "1768898151882130",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1768898161865485"] = {
						["key"] = "1768898161865485",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1274,
							["y"] = 292
						},
						["propsData"] = {
							["WaitTime"] = 0.1
						}
					},
					["1768898172072708"] = {
						["key"] = "1768898172072708",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1636,
							["y"] = 322
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_PorStart",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}