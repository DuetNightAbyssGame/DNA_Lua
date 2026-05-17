return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17490349529551",
			["startPort"] = "StoryStart",
			["endStory"] = "1749035174514300881",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1749035174514300881",
			["startPort"] = "Success",
			["endStory"] = "17490349529555",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17490349529551"] = {
			["isStoryNode"] = true,
			["key"] = "17490349529551",
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
		["17490349529555"] = {
			["isStoryNode"] = true,
			["key"] = "17490349529555",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1600,
				["y"] = 277.89473684210526
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1749035174514300881"] = {
			["isStoryNode"] = true,
			["key"] = "1749035174514300881",
			["type"] = "StoryNode",
			["name"] = "击杀狴犴",
			["pos"] = {
				["x"] = 1166.842105263158,
				["y"] = 280.6315789473684
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_Bian_Des",
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
				["bIsDynamicEvent"] = true,
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
						["startQuest"] = "1749035174514300882",
						["startPort"] = "QuestStart",
						["endQuest"] = "1749035336100301861",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749035336100301861",
						["startPort"] = "Out",
						["endQuest"] = "1749035352698302181",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749035481294302417",
						["startPort"] = "Out",
						["endQuest"] = "1749035174514300885",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17494757844141711",
						["startPort"] = "Out",
						["endQuest"] = "17494757844141712",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17494757716561207",
						["startPort"] = "Out",
						["endQuest"] = "17494757844141711",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749035336100301861",
						["startPort"] = "Out",
						["endQuest"] = "1749035323773301572",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749035336100301861",
						["startPort"] = "Out",
						["endQuest"] = "17494757716561207",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17494759610515059",
						["startPort"] = "Out",
						["endQuest"] = "17494758056822581",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17494757844141712",
						["startPort"] = "Out",
						["endQuest"] = "17496245065833102064",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1749035352698302181",
						["startPort"] = "Out",
						["endQuest"] = "17496245065833102064",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17496245065833102064",
						["startPort"] = "Out",
						["endQuest"] = "17494759610515059",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17494758056822581",
						["startPort"] = "Out",
						["endQuest"] = "1749035481294302417",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1749035174514300882"] = {
						["key"] = "1749035174514300882",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 532.6086956521738,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1749035174514300885"] = {
						["key"] = "1749035174514300885",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3998.005115089514,
							["y"] = 290.58458165875044
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1749035174514300888"] = {
						["key"] = "1749035174514300888",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1749035323773301572"] = {
						["key"] = "1749035323773301572",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1547.6459627329193,
							["y"] = 69.06521739130427
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71006401,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1749035336100301861"] = {
						["key"] = "1749035336100301861",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成敌人",
						["pos"] = {
							["x"] = 1220.2857142857142,
							["y"] = 300.57142857142856
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090129
							}
						}
					},
					["1749035352698302181"] = {
						["key"] = "1749035352698302181",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1938.8,
							["y"] = 43.314285714285575
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2090129
							}
						}
					},
					["1749035481294302417"] = {
						["key"] = "1749035481294302417",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3688.119108512971,
							["y"] = 260.1622214103032
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17494757716561207"] = {
						["key"] = "17494757716561207",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1631.4,
							["y"] = 308.88478260869556
						},
						["propsData"] = {
							["WaitTime"] = 5
						}
					},
					["17494757844141711"] = {
						["key"] = "17494757844141711",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成敌人",
						["pos"] = {
							["x"] = 1955.3078658923528,
							["y"] = 317.15235659481186
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090130
							}
						}
					},
					["17494757844141712"] = {
						["key"] = "17494757844141712",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2310.201563371344,
							["y"] = 114.67462550237477
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2090130
							}
						}
					},
					["17494758056822581"] = {
						["key"] = "17494758056822581",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 3172.505801588369,
							["y"] = 314.9841432225063
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2090132,
								2090133
							}
						}
					},
					["17494759610515059"] = {
						["key"] = "17494759610515059",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成敌人",
						["pos"] = {
							["x"] = 2852.3349575986003,
							["y"] = 328.0603580562656
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090132,
								2090133
							}
						}
					},
					["17496245065833102064"] = {
						["key"] = "17496245065833102064",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 3261.000000000001,
							["y"] = 103.24999999999966
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}