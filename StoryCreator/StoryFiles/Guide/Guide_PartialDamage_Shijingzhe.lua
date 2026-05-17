return {
	["storyName"] = "未命名任务",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1704175978696174301",
			["startPort"] = "StoryStart",
			["endStory"] = "1704175978696174303",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1704175978696174303",
			["startPort"] = "Success",
			["endStory"] = "1704175978696174302",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1704175978696174301"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978696174301",
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
		["1704175978696174302"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978696174302",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 703,
				["y"] = 154
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1704175978696174303"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978696174303",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 402,
				["y"] = 143
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
						["startQuest"] = "1704175978696174307",
						["startPort"] = "Out",
						["endQuest"] = "1704175978696174305",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1704175978696174304",
						["startPort"] = "QuestStart",
						["endQuest"] = "1704175978696174308",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978696174308",
						["startPort"] = "Out",
						["endQuest"] = "1704175978696174307",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1704175978696174304"] = {
						["key"] = "1704175978696174304",
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
					["1704175978696174305"] = {
						["key"] = "1704175978696174305",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1500,
							["y"] = 140
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978696174306"] = {
						["key"] = "1704175978696174306",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["1704175978696174307"] = {
						["key"] = "1704175978696174307",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 796,
							["y"] = 207
						},
						["propsData"] = {
							["GuideId"] = 8
						}
					},
					["1704175978696174308"] = {
						["key"] = "1704175978696174308",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 418,
							["y"] = 191
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