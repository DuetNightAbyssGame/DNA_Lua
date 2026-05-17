return {
	["storyName"] = "未命名任务",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17700202262954528296",
			["startPort"] = "StoryStart",
			["endStory"] = "17700202262954528298",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17700202262954528298",
			["startPort"] = "Success",
			["endStory"] = "17700202262954528297",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17700202262954528296"] = {
			["isStoryNode"] = true,
			["key"] = "17700202262954528296",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 100,
				["y"] = 140
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
		["17700202262954528297"] = {
			["isStoryNode"] = true,
			["key"] = "17700202262954528297",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 857,
				["y"] = 111
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17700202262954528298"] = {
			["isStoryNode"] = true,
			["key"] = "17700202262954528298",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 431,
				["y"] = 100.75
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
						["startQuest"] = "17700202262954528299",
						["startPort"] = "Fail",
						["endQuest"] = "17700202262954528300",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17700202262954528299",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17700202262954528300",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17700202262954528310",
						["startPort"] = "Out",
						["endQuest"] = "17700202262954528302",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17700202262954528301",
						["startPort"] = "QuestStart",
						["endQuest"] = "17700201663003768278",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17700201663003768278",
						["startPort"] = "Out",
						["endQuest"] = "17700202262954528306",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17700202262954528306",
						["startPort"] = "Out",
						["endQuest"] = "17700202262954528307",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17700202262954528301",
						["startPort"] = "QuestStart",
						["endQuest"] = "17700201872953768785",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17700201872953768785",
						["startPort"] = "Out",
						["endQuest"] = "17700202262954528309",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17700202262954528309",
						["startPort"] = "Out",
						["endQuest"] = "17700202262954528308",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17700202262954528301",
						["startPort"] = "QuestStart",
						["endQuest"] = "17700202076513769267",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17700202076513769267",
						["startPort"] = "Out",
						["endQuest"] = "17700202262954528310",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17700201663003768278"] = {
						["key"] = "17700201663003768278",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = -119.89473684210527,
							["y"] = 575.8947368421053
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "start"
						}
					},
					["17700201872953768785"] = {
						["key"] = "17700201872953768785",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = -120.82236842105276,
							["y"] = 740.9671052631579
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "stop"
						}
					},
					["17700202076513769267"] = {
						["key"] = "17700202076513769267",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = -106.61184210526318,
							["y"] = 977.8092105263156
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "end"
						}
					},
					["17700202262954528299"] = {
						["key"] = "17700202262954528299",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待开始特殊任务开始并完成",
						["pos"] = {
							["x"] = 281.3403864128803,
							["y"] = 170.29025920893628
						},
						["propsData"] = {
							["SpecialConfigId"] = 10000,
							["BlackScreenImmediately"] = false
						}
					},
					["17700202262954528300"] = {
						["key"] = "17700202262954528300",
						["type"] = "TestPrintNode",
						["name"] = "测试打印",
						["pos"] = {
							["x"] = 597.7219996684191,
							["y"] = 243.25931218539918
						},
						["propsData"] = {
							["Text"] = "tyx特殊任务失败"
						}
					},
					["17700202262954528301"] = {
						["key"] = "17700202262954528301",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -403.0727272727273,
							["y"] = 629.5090909090909
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17700202262954528302"] = {
						["key"] = "17700202262954528302",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 866.3066245983864,
							["y"] = 997.4335691006172
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17700202262954528303"] = {
						["key"] = "17700202262954528303",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1494.5277777777778,
							["y"] = 1096.138888888889
						},
						["propsData"] = {}
					},
					["17700202262954528304"] = {
						["key"] = "17700202262954528304",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 279.90909090909093,
							["y"] = -11.000000000000057
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17700202262954528305"] = {
						["key"] = "17700202262954528305",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = -60,
							["y"] = 194
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080410
							}
						}
					},
					["17700202262954528306"] = {
						["key"] = "17700202262954528306",
						["type"] = "LookToHookNode",
						["name"] = "进入范围后自动看向钩锁",
						["pos"] = {
							["x"] = 166.2781954887218,
							["y"] = 582.4342105263158
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								123,
								124,
								125
							},
							["bOpenNode"] = true,
							["DurationTime"] = 2
						}
					},
					["17700202262954528307"] = {
						["key"] = "17700202262954528307",
						["type"] = "TestPrintNode",
						["name"] = "测试打印",
						["pos"] = {
							["x"] = 481.54024094566694,
							["y"] = 574.4974427702116
						},
						["propsData"] = {
							["Text"] = "tyx开启自动看向"
						}
					},
					["17700202262954528308"] = {
						["key"] = "17700202262954528308",
						["type"] = "TestPrintNode",
						["name"] = "测试打印",
						["pos"] = {
							["x"] = 505.6123825064654,
							["y"] = 785.0260271622261
						},
						["propsData"] = {
							["Text"] = "tyx关闭自动看向"
						}
					},
					["17700202262954528309"] = {
						["key"] = "17700202262954528309",
						["type"] = "LookToHookNode",
						["name"] = "进入范围后自动看向钩锁",
						["pos"] = {
							["x"] = 195.74571151865098,
							["y"] = 763.7689620857418
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								123,
								124,
								125
							},
							["bOpenNode"] = false,
							["DurationTime"] = 3
						}
					},
					["17700202262954528310"] = {
						["key"] = "17700202262954528310",
						["type"] = "TestPrintNode",
						["name"] = "测试打印",
						["pos"] = {
							["x"] = 503.4957115186512,
							["y"] = 1007.8385109579223
						},
						["propsData"] = {
							["Text"] = "tyx STL结束"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}