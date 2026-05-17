return {
	["storyName"] = "结束剧情",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17733007941531361338",
			["startPort"] = "Success",
			["endStory"] = "17733007941531361337",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17733007941531361336",
			["startPort"] = "StoryStart",
			["endStory"] = "17733007941531361338",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17733007941531361336"] = {
			["isStoryNode"] = true,
			["key"] = "17733007941531361336",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 103,
				["y"] = 138
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
		["17733007941531361337"] = {
			["isStoryNode"] = true,
			["key"] = "17733007941531361337",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 721,
				["y"] = 176
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17733007941531361338"] = {
			["isStoryNode"] = true,
			["key"] = "17733007941531361338",
			["type"] = "StoryNode",
			["name"] = "开场剧情",
			["pos"] = {
				["x"] = 378,
				["y"] = 130
			},
			["propsData"] = {
				["QuestId"] = 10100,
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
						["startQuest"] = "17733007941531361339",
						["startPort"] = "QuestStart",
						["endQuest"] = "17733007941531361342",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733007941531361342",
						["startPort"] = "Out",
						["endQuest"] = "17733007941531361340",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17733007941531361339"] = {
						["key"] = "17733007941531361339",
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
					["17733007941531361340"] = {
						["key"] = "17733007941531361340",
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
					["17733007941531361341"] = {
						["key"] = "17733007941531361341",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["17733007941531361342"] = {
						["key"] = "17733007941531361342",
						["type"] = "BossBattleOpenNode",
						["name"] = "BOSS战开场播片",
						["pos"] = {
							["x"] = 399,
							["y"] = 129
						},
						["propsData"] = {
							["SequencePath"] = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_Xibi/HardBoss_Xibi_Start.HardBoss_Xibi_Start'",
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["EnableSkip"] = false,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = true,
							["HideMonsters"] = true
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}