return {
	["storyName"] = "结束剧情",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1704175978725174814",
			["startPort"] = "Success",
			["endStory"] = "1704175978725174813",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1704175978725174812",
			["startPort"] = "StoryStart",
			["endStory"] = "1704175978725174814",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["1704175978725174812"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978725174812",
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
		["1704175978725174813"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978725174813",
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
		["1704175978725174814"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978725174814",
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
						["startQuest"] = "1704175978725174816",
						["startPort"] = "QuestStart",
						["endQuest"] = "1704175978725174819",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978725174819",
						["startPort"] = "Out",
						["endQuest"] = "1704175978725174817",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1704175978725174816"] = {
						["key"] = "1704175978725174816",
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
					["1704175978725174817"] = {
						["key"] = "1704175978725174817",
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
					["1704175978725174818"] = {
						["key"] = "1704175978725174818",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["1704175978725174819"] = {
						["key"] = "1704175978725174819",
						["type"] = "BossBattleOpenNode",
						["name"] = "BOSS战开场播片",
						["pos"] = {
							["x"] = 761.8571428571429,
							["y"] = 129
						},
						["propsData"] = {
							["SequencePath"] = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_shuanglong/HardBoss_Shuanglong_Start.HardBoss_Shuanglong_Start'",
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