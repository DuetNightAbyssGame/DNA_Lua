return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17688973546341",
			["startPort"] = "StoryStart",
			["endStory"] = "1768897362085107",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1768897362085107",
			["startPort"] = "Success",
			["endStory"] = "17688973546355",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17688973546341"] = {
			["isStoryNode"] = true,
			["key"] = "17688973546341",
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
		["17688973546355"] = {
			["isStoryNode"] = true,
			["key"] = "17688973546355",
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
		["1768897362085107"] = {
			["isStoryNode"] = true,
			["key"] = "1768897362085107",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1288,
				["y"] = 294
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
						["startQuest"] = "1768897362085108",
						["startPort"] = "QuestStart",
						["endQuest"] = "1768897390902402",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768897390902402",
						["startPort"] = "Out",
						["endQuest"] = "1768897362085116",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1768897362085108"] = {
						["key"] = "1768897362085108",
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
					["1768897362085116"] = {
						["key"] = "1768897362085116",
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
					["1768897362086124"] = {
						["key"] = "1768897362086124",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1768897390902402"] = {
						["key"] = "1768897390902402",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1270,
							["y"] = 324
						},
						["propsData"] = {
							["GuideId"] = 116
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}