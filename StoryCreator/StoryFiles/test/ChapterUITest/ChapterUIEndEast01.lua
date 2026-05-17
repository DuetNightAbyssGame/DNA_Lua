return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17683603786471",
			["startPort"] = "StoryStart",
			["endStory"] = "1768360643385282",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1768360643385282",
			["startPort"] = "Success",
			["endStory"] = "17683603786485",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17683603786471"] = {
			["isStoryNode"] = true,
			["key"] = "17683603786471",
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
		["17683603786485"] = {
			["isStoryNode"] = true,
			["key"] = "17683603786485",
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
		["1768360643385282"] = {
			["isStoryNode"] = true,
			["key"] = "1768360643385282",
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
						["startQuest"] = "1768360643385283",
						["startPort"] = "QuestStart",
						["endQuest"] = "1768360653785651",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768360653785651",
						["startPort"] = "Out",
						["endQuest"] = "17683606690341039",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17683606690341039",
						["startPort"] = "Out",
						["endQuest"] = "1768360643385291",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1768360643385283"] = {
						["key"] = "1768360643385283",
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
					["1768360643385291"] = {
						["key"] = "1768360643385291",
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
					["1768360643386299"] = {
						["key"] = "1768360643386299",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1768360653785651"] = {
						["key"] = "1768360653785651",
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
					["17683606690341039"] = {
						["key"] = "17683606690341039",
						["type"] = "OpenChapterUINode",
						["name"] = "打开章节开始UI",
						["pos"] = {
							["x"] = 1650,
							["y"] = 296
						},
						["propsData"] = {
							["ChapterUIId"] = 120101,
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