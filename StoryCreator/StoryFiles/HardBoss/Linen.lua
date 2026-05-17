return {
	["storyName"] = "结束剧情",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1704175978719174741",
			["startPort"] = "Success",
			["endStory"] = "1704175978719174740",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1704175978719174739",
			["startPort"] = "StoryStart",
			["endStory"] = "1704175978719174741",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["1704175978719174739"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978719174739",
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
		["1704175978719174740"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978719174740",
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
		["1704175978719174741"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978719174741",
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
						["startQuest"] = "1704175978719174743",
						["startPort"] = "QuestStart",
						["endQuest"] = "1704175978719174746",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978719174746",
						["startPort"] = "Out",
						["endQuest"] = "1704175978719174744",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1704175978719174743"] = {
						["key"] = "1704175978719174743",
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
					["1704175978719174744"] = {
						["key"] = "1704175978719174744",
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
					["1704175978719174745"] = {
						["key"] = "1704175978719174745",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["1704175978719174746"] = {
						["key"] = "1704175978719174746",
						["type"] = "BossBattleOpenNode",
						["name"] = "BOSS战开场播片",
						["pos"] = {
							["x"] = 582.2307692307692,
							["y"] = 145.26923076923077
						},
						["propsData"] = {
							["SequencePath"] = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_Linen/HardBoss_Linen_Start.HardBoss_Linen_Start'",
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