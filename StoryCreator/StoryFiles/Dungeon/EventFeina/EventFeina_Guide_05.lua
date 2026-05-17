return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1757152467739332110",
			["startPort"] = "StoryStart",
			["endStory"] = "1757152467739332112",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1757152467739332112",
			["startPort"] = "Success",
			["endStory"] = "1757152467739332111",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1757152467739332110"] = {
			["isStoryNode"] = true,
			["key"] = "1757152467739332110",
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
		["1757152467739332111"] = {
			["isStoryNode"] = true,
			["key"] = "1757152467739332111",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1652,
				["y"] = 334
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1757152467739332112"] = {
			["isStoryNode"] = true,
			["key"] = "1757152467739332112",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1220,
				["y"] = 288
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
						["startQuest"] = "1757152467739332113",
						["startPort"] = "QuestStart",
						["endQuest"] = "1757152467739332117",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757152467739332117",
						["startPort"] = "Out",
						["endQuest"] = "1757152467739332114",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1757152467739332113"] = {
						["key"] = "1757152467739332113",
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
					["1757152467739332114"] = {
						["key"] = "1757152467739332114",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1728,
							["y"] = 314
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1757152467739332115"] = {
						["key"] = "1757152467739332115",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1757152467739332117"] = {
						["key"] = "1757152467739332117",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1284,
							["y"] = 320
						},
						["propsData"] = {
							["GuideId"] = 2005
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}