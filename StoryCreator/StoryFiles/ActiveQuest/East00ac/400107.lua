return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17440155447413861014",
			["startPort"] = "StoryStart",
			["endStory"] = "17440155447413861016",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17440155447413861016",
			["startPort"] = "Success",
			["endStory"] = "17440155447413861015",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17440155447413861014"] = {
			["isStoryNode"] = true,
			["key"] = "17440155447413861014",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 301.0344827586207
			},
			["propsData"] = {
				["QuestChainId"] = 400107
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17440155447413861015"] = {
			["isStoryNode"] = true,
			["key"] = "17440155447413861015",
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
		["17440155447413861016"] = {
			["isStoryNode"] = true,
			["key"] = "17440155447413861016",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1209.4010695187167,
				["y"] = 320.5882352941176
			},
			["propsData"] = {
				["QuestId"] = 4001071,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_400107",
				["QuestDeatil"] = "QuestDesc_400107",
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
				["StoryGuidePointName"] = "Mechanism_Eastac7_1240743",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17440155447413861020",
						["startPort"] = "Out",
						["endQuest"] = "17440155447413861021",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17440155447413861021",
						["startPort"] = "Out",
						["endQuest"] = "17440155447413861018",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17440155447413861017",
						["startPort"] = "QuestStart",
						["endQuest"] = "17440155447413861022",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17440155447413861022",
						["startPort"] = "Out",
						["endQuest"] = "17440155447413861020",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17440155447413861017"] = {
						["key"] = "17440155447413861017",
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
					["17440155447413861018"] = {
						["key"] = "17440155447413861018",
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
					["17440155447413861019"] = {
						["key"] = "17440155447413861019",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17440155447413861020"] = {
						["key"] = "17440155447413861020",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁 怪物",
						["pos"] = {
							["x"] = 1132.4302431324197,
							["y"] = 471.75066189080866
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240744,
								1240864,
								1240865,
								1240866,
								1240867,
								1240868
							}
						}
					},
					["17440155447413861021"] = {
						["key"] = "17440155447413861021",
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
								1240744,
								1240864,
								1240865,
								1240866,
								1240867,
								1240868
							}
						}
					},
					["17440155447413861022"] = {
						["key"] = "17440155447413861022",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1130.451855171814,
							["y"] = 186.41868280093897
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240743,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Eastac7_1240743"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}