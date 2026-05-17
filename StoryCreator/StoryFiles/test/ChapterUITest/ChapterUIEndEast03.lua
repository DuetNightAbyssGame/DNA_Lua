return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17683610220642178810",
			["startPort"] = "StoryStart",
			["endStory"] = "17683610220642178812",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17683610220642178812",
			["startPort"] = "Success",
			["endStory"] = "17683610220642178811",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17683610220642178810"] = {
			["isStoryNode"] = true,
			["key"] = "17683610220642178810",
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
		["17683610220642178811"] = {
			["isStoryNode"] = true,
			["key"] = "17683610220642178811",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1670,
				["y"] = 306
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17683610220642178812"] = {
			["isStoryNode"] = true,
			["key"] = "17683610220642178812",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1194,
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
						["startQuest"] = "17683610220642178813",
						["startPort"] = "QuestStart",
						["endQuest"] = "17683610220642178816",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17683610220642178816",
						["startPort"] = "Out",
						["endQuest"] = "17683610220642178817",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17683610220642178817",
						["startPort"] = "Out",
						["endQuest"] = "17683610220642178814",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17683610220642178813"] = {
						["key"] = "17683610220642178813",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 940,
							["y"] = 296
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17683610220642178814"] = {
						["key"] = "17683610220642178814",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2028,
							["y"] = 292
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17683610220642178815"] = {
						["key"] = "17683610220642178815",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17683610220642178816"] = {
						["key"] = "17683610220642178816",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1302,
							["y"] = 280
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17683610220642178817"] = {
						["key"] = "17683610220642178817",
						["type"] = "OpenChapterUINode",
						["name"] = "打开章节开始UI",
						["pos"] = {
							["x"] = 1650,
							["y"] = 296
						},
						["propsData"] = {
							["ChapterUIId"] = 120301,
							["UIType"] = "End"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}