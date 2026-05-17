return {
	["storyName"] = "结束剧情",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_16917418692934",
			["startPort"] = "Success",
			["endStory"] = "story_16917418671622",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "story_16917418671610",
			["startPort"] = "StoryStart",
			["endStory"] = "story_16917418692934",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["story_16917418671610"] = {
			["isStoryNode"] = true,
			["key"] = "story_16917418671610",
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
		["story_16917418671622"] = {
			["isStoryNode"] = true,
			["key"] = "story_16917418671622",
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
		["story_16917418692934"] = {
			["isStoryNode"] = true,
			["key"] = "story_16917418692934",
			["type"] = "StoryNode",
			["name"] = "开场剧情",
			["pos"] = {
				["x"] = 379.15384615384613,
				["y"] = 128.84615384615384
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
						["startQuest"] = "quest_16917418692948",
						["startPort"] = "QuestStart",
						["endQuest"] = "quest_169321393247938",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_169321393247938",
						["startPort"] = "Out",
						["endQuest"] = "quest_169174186929410",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["quest_16917418692948"] = {
						["key"] = "quest_16917418692948",
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
					["quest_169174186929410"] = {
						["key"] = "quest_169174186929410",
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
					["quest_169174186929412"] = {
						["key"] = "quest_169174186929412",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["quest_169321393247938"] = {
						["key"] = "quest_169321393247938",
						["type"] = "BossBattleOpenNode",
						["name"] = "BOSS战开场播片",
						["pos"] = {
							["x"] = 399,
							["y"] = 129
						},
						["propsData"] = {
							["SequencePath"] = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_Saiqi/HardBoss_Saiqi_Start.HardBoss_Saiqi_Start'",
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