return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17636392021541",
			["startPort"] = "StoryStart",
			["endStory"] = "176363920688275",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176363920688275",
			["startPort"] = "Success",
			["endStory"] = "17636392021555",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17636392021541"] = {
			["isStoryNode"] = true,
			["key"] = "17636392021541",
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
		["17636392021555"] = {
			["isStoryNode"] = true,
			["key"] = "17636392021555",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1679.2857142857142,
				["y"] = 287.14285714285717
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176363920688275"] = {
			["isStoryNode"] = true,
			["key"] = "176363920688275",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1330.3333333333333,
				["y"] = 303.4761904761905
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1763639275942472",
						["startPort"] = "Out",
						["endQuest"] = "1763639275942473",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763639275942474",
						["startPort"] = "Out",
						["endQuest"] = "1763639275942472",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763639275942471",
						["startPort"] = "Out",
						["endQuest"] = "1763639275942474",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363920688276",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763639275942471",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363920688276",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763639275942469",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363920688276",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636393449431680",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363920688276",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636394051242264",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763639275942469",
						["startPort"] = "Out",
						["endQuest"] = "17636394034612224",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636394034612224",
						["startPort"] = "Out",
						["endQuest"] = "17636393281211339",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636393449431680",
						["startPort"] = "Out",
						["endQuest"] = "17636394154612664",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636394154612664",
						["startPort"] = "Out",
						["endQuest"] = "176363920688290",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["176363920688276"] = {
						["key"] = "176363920688276",
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
					["176363920688283"] = {
						["key"] = "176363920688283",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176363920688290"] = {
						["key"] = "176363920688290",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2145,
							["y"] = 636.6666666666666
						},
						["propsData"] = {}
					},
					["1763639275942469"] = {
						["key"] = "1763639275942469",
						["type"] = "GoToNode",
						["name"] = "前往祭台",
						["pos"] = {
							["x"] = 1368.2919139840674,
							["y"] = 268.13428648053525
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1930100,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1930100"
						}
					},
					["1763639275942471"] = {
						["key"] = "1763639275942471",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BT_Wuyou01",
						["pos"] = {
							["x"] = 1171.5113922785567,
							["y"] = 55.49136052065978
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050051
							}
						}
					},
					["1763639275942472"] = {
						["key"] = "1763639275942472",
						["type"] = "SendMessageNode",
						["name"] = "无由生Goto1",
						["pos"] = {
							["x"] = 1716.636295851921,
							["y"] = 19.179028763187432
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto1",
							["UnitId"] = 210082
						}
					},
					["1763639275942473"] = {
						["key"] = "1763639275942473",
						["type"] = "BossBattleFinishNode",
						["name"] = "无由生",
						["pos"] = {
							["x"] = 1987.726615524621,
							["y"] = 22.301011139106947
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "End1"
						}
					},
					["1763639275942474"] = {
						["key"] = "1763639275942474",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1464.5902374417326,
							["y"] = 11.952524591031022
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["1763639275942475"] = {
						["key"] = "1763639275942475",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1651.4627258375888,
							["y"] = -488.8219298313363
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_BTWuyousheng01_2050051"
						}
					},
					["1763639275942476"] = {
						["key"] = "1763639275942476",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1951.1552743881098,
							["y"] = -483.5911037688539
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_BTWuyousheng03_2050052"
						}
					},
					["17636393281211339"] = {
						["key"] = "17636393281211339",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2134.333333333333,
							["y"] = 285.6666666666667
						},
						["propsData"] = {}
					},
					["17636393449431680"] = {
						["key"] = "17636393449431680",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1491,
							["y"] = 612.3333333333336
						},
						["propsData"] = {}
					},
					["17636394034612224"] = {
						["key"] = "17636394034612224",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁扶疏魅影",
						["pos"] = {
							["x"] = 1691,
							["y"] = 283.9999999999997
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070214
							}
						}
					},
					["17636394051242264"] = {
						["key"] = "17636394051242264",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成扶疏魅影",
						["pos"] = {
							["x"] = 1230.9999999999998,
							["y"] = -249.33333333333348
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070214
							}
						}
					},
					["17636394154612664"] = {
						["key"] = "17636394154612664",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁扶疏魅影",
						["pos"] = {
							["x"] = 1812.6666666666667,
							["y"] = 647.3333333333334
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070214
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