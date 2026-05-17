return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17533575536791",
			["startPort"] = "StoryStart",
			["endStory"] = "1753358093343571",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1753358093343571",
			["startPort"] = "Success",
			["endStory"] = "17533575536795",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17533575536791"] = {
			["isStoryNode"] = true,
			["key"] = "17533575536791",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1670.7857142857142,
				["y"] = 326.15714285714284
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
		["17533575536795"] = {
			["isStoryNode"] = true,
			["key"] = "17533575536795",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2353.4285714285716,
				["y"] = 306.3
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1753358093343571"] = {
			["isStoryNode"] = true,
			["key"] = "1753358093343571",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2015.0964285714285,
				["y"] = 312.43571428571425
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
				["SubRegionId"] = 104108,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_2090230",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17534266294761698",
						["startPort"] = "Out",
						["endQuest"] = "17534266581982124",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753358093343572",
						["startPort"] = "QuestStart",
						["endQuest"] = "1753528225971667270",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753358093343572",
						["startPort"] = "QuestStart",
						["endQuest"] = "17534266294761698",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17534266581982124",
						["startPort"] = "Out",
						["endQuest"] = "1763467294308436",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763467294308436",
						["startPort"] = "Out",
						["endQuest"] = "1753527037161752",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753358093343572",
						["startPort"] = "QuestStart",
						["endQuest"] = "1764674319905436",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764674319905436",
						["startPort"] = "Out",
						["endQuest"] = "1753358093344586",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1753358093343572"] = {
						["key"] = "1753358093343572",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 985.7054698457223,
							["y"] = 294.8499298737728
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1753358093344579"] = {
						["key"] = "1753358093344579",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2287.353639568465,
							["y"] = 131.10810018377896
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1753358093344586"] = {
						["key"] = "1753358093344586",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2298.5714285714284,
							["y"] = 535.7142857142857
						},
						["propsData"] = {}
					},
					["17534266294761698"] = {
						["key"] = "17534266294761698",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1485.016577060932,
							["y"] = 294.30997183819767
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Monster_BiAn_2090161",
							["StaticCreatorIdList"] = {
								2090161,
								2090162
							}
						}
					},
					["17534266581982124"] = {
						["key"] = "17534266581982124",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1735.274641577061,
							["y"] = 290.37448796722987
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Mechanism_2090230",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2090161,
								2090162
							}
						}
					},
					["1753527037161752"] = {
						["key"] = "1753527037161752",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2302.1188725490197,
							["y"] = 292.8296568627452
						},
						["propsData"] = {}
					},
					["1753528225971667270"] = {
						["key"] = "1753528225971667270",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1241.3444009138695,
							["y"] = 132.03467632881865
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51104064,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1763467294308436"] = {
						["key"] = "1763467294308436",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2002.0702770482806,
							["y"] = 307.61831473139586
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["1764674319905436"] = {
						["key"] = "1764674319905436",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1817.9999999999998,
							["y"] = 526.4
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}