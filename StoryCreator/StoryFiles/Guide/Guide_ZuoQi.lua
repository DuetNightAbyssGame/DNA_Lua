return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17694098574431",
			["startPort"] = "StoryStart",
			["endStory"] = "176940986585184",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176940986585184",
			["startPort"] = "Success",
			["endStory"] = "17694098574435",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17694098574431"] = {
			["isStoryNode"] = true,
			["key"] = "17694098574431",
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
		["17694098574435"] = {
			["isStoryNode"] = true,
			["key"] = "17694098574435",
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
		["176940986585184"] = {
			["isStoryNode"] = true,
			["key"] = "176940986585184",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1440,
				["y"] = 328
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
						["startQuest"] = "176940986585185",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769409883114560",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769409883114560",
						["startPort"] = "Out",
						["endQuest"] = "176940986585193",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["176940986585185"] = {
						["key"] = "176940986585185",
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
					["176940986585193"] = {
						["key"] = "176940986585193",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769409865852101"] = {
						["key"] = "1769409865852101",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1769409883114560"] = {
						["key"] = "1769409883114560",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1402,
							["y"] = 366
						},
						["propsData"] = {
							["GuideId"] = 119
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}