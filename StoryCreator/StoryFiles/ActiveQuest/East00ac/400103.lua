return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17440155447383860626",
			["startPort"] = "StoryStart",
			["endStory"] = "17440155447393860628",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17440155447393860628",
			["startPort"] = "Success",
			["endStory"] = "17440155447393860627",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17440155447383860626"] = {
			["isStoryNode"] = true,
			["key"] = "17440155447383860626",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 301.0344827586207
			},
			["propsData"] = {
				["QuestChainId"] = 400103
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17440155447393860627"] = {
			["isStoryNode"] = true,
			["key"] = "17440155447393860627",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1544.0000000000005,
				["y"] = 318
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17440155447393860628"] = {
			["isStoryNode"] = true,
			["key"] = "17440155447393860628",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1209.4010695187167,
				["y"] = 320.5882352941176
			},
			["propsData"] = {
				["QuestId"] = 4001031,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_400103",
				["QuestDeatil"] = "QuestDesc_400103",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = true,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = true,
				["bIsEndChapter"] = true,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_Eastac3_1240723",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17440155447393860633",
						["startPort"] = "Out",
						["endQuest"] = "17440155447393860630",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17440155447393860629",
						["startPort"] = "QuestStart",
						["endQuest"] = "17440155447393860634",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17440155447393860634",
						["startPort"] = "Out",
						["endQuest"] = "17440155447393860635",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17440155447393860635",
						["startPort"] = "Out",
						["endQuest"] = "17440155447393860633",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17440155447393860629"] = {
						["key"] = "17440155447393860629",
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
					["17440155447393860630"] = {
						["key"] = "17440155447393860630",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1666.888888888889,
							["y"] = 311.77777777777777
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17440155447393860631"] = {
						["key"] = "17440155447393860631",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17440155447393860633"] = {
						["key"] = "17440155447393860633",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1420.147202196747,
							["y"] = 358.90706063961875
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 6,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1240724,
								1240725,
								1240726,
								1240727,
								1240728,
								1240729
							}
						}
					},
					["17440155447393860634"] = {
						["key"] = "17440155447393860634",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1130.451855171814,
							["y"] = 186.41868280093897
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240723,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Eastac3_1240723"
						}
					},
					["17440155447393860635"] = {
						["key"] = "17440155447393860635",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁 怪物",
						["pos"] = {
							["x"] = 1048.1120355230241,
							["y"] = 442.55062394949147
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240724,
								1240725,
								1240726,
								1240727,
								1240728,
								1240729
							}
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}