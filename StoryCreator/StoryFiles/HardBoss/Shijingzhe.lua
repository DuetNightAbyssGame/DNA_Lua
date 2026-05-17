return {
	["storyName"] = "结束剧情",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1748589440643384323",
			["startPort"] = "Success",
			["endStory"] = "1748589440643384322",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1748589440643384321",
			["startPort"] = "StoryStart",
			["endStory"] = "1748589440643384323",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["1748589440643384321"] = {
			["isStoryNode"] = true,
			["key"] = "1748589440643384321",
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
		["1748589440643384322"] = {
			["isStoryNode"] = true,
			["key"] = "1748589440643384322",
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
		["1748589440643384323"] = {
			["isStoryNode"] = true,
			["key"] = "1748589440643384323",
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
						["startQuest"] = "1748589440643384325",
						["startPort"] = "QuestStart",
						["endQuest"] = "1748589440643384328",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1748589440643384328",
						["startPort"] = "Out",
						["endQuest"] = "1748589440643384326",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1748589440643384325"] = {
						["key"] = "1748589440643384325",
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
					["1748589440643384326"] = {
						["key"] = "1748589440643384326",
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
					["1748589440643384327"] = {
						["key"] = "1748589440643384327",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["1748589440643384328"] = {
						["key"] = "1748589440643384328",
						["type"] = "BossBattleOpenNode",
						["name"] = "BOSS战开场播片",
						["pos"] = {
							["x"] = 399,
							["y"] = 129
						},
						["propsData"] = {
							["SequencePath"] = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_Shijingzhe/HardBoss_Shijingzhe_Start.HardBoss_Shijingzhe_Start'",
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