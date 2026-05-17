return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1736148733987948253",
			["startPort"] = "StoryStart",
			["endStory"] = "1736148734646948274",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1736148734646948274",
			["startPort"] = "Success",
			["endStory"] = "1736148733988948256",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1736148733987948253"] = {
			["isStoryNode"] = true,
			["key"] = "1736148733987948253",
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
		["1736148733988948256"] = {
			["isStoryNode"] = true,
			["key"] = "1736148733988948256",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1918.9473684210525,
				["y"] = 331.57894736842104
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1736148734646948274"] = {
			["isStoryNode"] = true,
			["key"] = "1736148734646948274",
			["type"] = "StoryNode",
			["name"] = "开场剧情",
			["pos"] = {
				["x"] = 1298.5,
				["y"] = 307
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
						["startQuest"] = "1736148734646948284",
						["startPort"] = "QuestStart",
						["endQuest"] = "1736148734646948287",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1736148734646948287",
						["startPort"] = "Out",
						["endQuest"] = "1736148734646948285",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1736148734646948284"] = {
						["key"] = "1736148734646948284",
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
					["1736148734646948285"] = {
						["key"] = "1736148734646948285",
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
					["1736148734646948286"] = {
						["key"] = "1736148734646948286",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["1736148734646948287"] = {
						["key"] = "1736148734646948287",
						["type"] = "BossBattleOpenNode",
						["name"] = "BOSS战开场播片",
						["pos"] = {
							["x"] = 399,
							["y"] = 127
						},
						["propsData"] = {
							["SequencePath"] = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_Haier/HardBoss_Haier_Start.HardBoss_Haier_Start'",
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