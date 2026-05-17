return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17636478347513303411",
			["startPort"] = "StoryStart",
			["endStory"] = "17636478347513303413",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17636478347513303413",
			["startPort"] = "Success",
			["endStory"] = "17636478347513303412",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17636478347513303411"] = {
			["isStoryNode"] = true,
			["key"] = "17636478347513303411",
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
		["17636478347513303412"] = {
			["isStoryNode"] = true,
			["key"] = "17636478347513303412",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1712,
				["y"] = 298
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17636478347513303413"] = {
			["isStoryNode"] = true,
			["key"] = "17636478347513303413",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1268,
				["y"] = 286
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
						["startQuest"] = "17636478347513303414",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636478347513303418",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636478347513303418",
						["startPort"] = "Out",
						["endQuest"] = "17636478347513303421",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636478347513303421",
						["startPort"] = "Out",
						["endQuest"] = "17636478347513303416",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17636478347513303414",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636478347513303419",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636477608152705163",
						["startPort"] = "Out",
						["endQuest"] = "17636477608152705164",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636477608152705170",
						["startPort"] = "Out",
						["endQuest"] = "17636477608152705171",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636477608152705166",
						["startPort"] = "Out",
						["endQuest"] = "17636477608152705163",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636477608152705174",
						["startPort"] = "Out",
						["endQuest"] = "17636477608152705170",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636477608152705169",
						["startPort"] = "Out",
						["endQuest"] = "17636477608152705174",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636478347513303414",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636477608152705166",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636478347513303414",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636477608152705169",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636478347513303414",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636477608152705165",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636477608152705166",
						["startPort"] = "Out",
						["endQuest"] = "17636477608152705168",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636477608152705164",
						["startPort"] = "Out",
						["endQuest"] = "176529119985843650677",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176529119985843650677",
						["startPort"] = "Out",
						["endQuest"] = "17636478347513303420",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636478347513303420",
						["startPort"] = "Out",
						["endQuest"] = "17636478347513303417",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17636477608152705163"] = {
						["key"] = "17636477608152705163",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成怪物",
						["pos"] = {
							["x"] = 1921.7346925962624,
							["y"] = 38.2592626406489
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050043,
								2050044,
								2050045,
								2050046,
								2050047,
								2050048
							}
						}
					},
					["17636477608152705164"] = {
						["key"] = "17636477608152705164",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2260.418267475489,
							["y"] = 44.541181205175974
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 6,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2050043,
								2050044,
								2050045,
								2050046,
								2050047,
								2050048
							}
						}
					},
					["17636477608152705165"] = {
						["key"] = "17636477608152705165",
						["type"] = "TalkNode",
						["name"] = "开车- 被找到了",
						["pos"] = {
							["x"] = 1606.088492157572,
							["y"] = 318.51570990069456
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12014701,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17636477608152705166"] = {
						["key"] = "17636477608152705166",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1611.416639358481,
							["y"] = 27.97372354093318
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2050023,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2050023"
						}
					},
					["17636477608152705167"] = {
						["key"] = "17636477608152705167",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁无由生",
						["pos"] = {
							["x"] = 2622.510756859384,
							["y"] = -227.05094704823944
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1930106
							}
						}
					},
					["17636477608152705168"] = {
						["key"] = "17636477608152705168",
						["type"] = "TalkNode",
						["name"] = "开车-无由生害怕",
						["pos"] = {
							["x"] = 2214.115133248792,
							["y"] = 317.6897650299923
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12014801,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17636477608152705169"] = {
						["key"] = "17636477608152705169",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BT_Wuyou03",
						["pos"] = {
							["x"] = 1368.0362045758727,
							["y"] = -507.22285219080885
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050052
							}
						}
					},
					["17636477608152705170"] = {
						["key"] = "17636477608152705170",
						["type"] = "SendMessageNode",
						["name"] = "无由生Goto1",
						["pos"] = {
							["x"] = 1905.7366876676595,
							["y"] = -539.3861798407094
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto1",
							["UnitId"] = 210083
						}
					},
					["17636477608152705171"] = {
						["key"] = "17636477608152705171",
						["type"] = "BossBattleFinishNode",
						["name"] = "无由生",
						["pos"] = {
							["x"] = 2196.0084267980947,
							["y"] = -561.604707831616
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "End1"
						}
					},
					["17636477608152705172"] = {
						["key"] = "17636477608152705172",
						["type"] = "SendMessageNode",
						["name"] = "无由生Goto2",
						["pos"] = {
							["x"] = 2921.999972691815,
							["y"] = -396.45864360882535
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto2",
							["UnitId"] = 210083
						}
					},
					["17636477608152705173"] = {
						["key"] = "17636477608152705173",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2069.972194914036,
							["y"] = -276.5975324977144
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_QuestTrigger_2050023"
						}
					},
					["17636477608152705174"] = {
						["key"] = "17636477608152705174",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1645.527750469592,
							["y"] = -532.1808658310476
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17636477608152705177"] = {
						["key"] = "17636477608152705177",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2348.2956760306215,
							["y"] = -276.2873245064718
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_QuestTrigger_2050023"
						}
					},
					["17636477608152705178"] = {
						["key"] = "17636477608152705178",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1651.0798640648102,
							["y"] = -763.0095467286941
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_BTWuyousheng03_2050052"
						}
					},
					["17636477608152705179"] = {
						["key"] = "17636477608152705179",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2533.486726809908,
							["y"] = -546.1860173169293
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_BTWuyousheng03_2050052"
						}
					},
					["17636478347513303414"] = {
						["key"] = "17636478347513303414",
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
					["17636478347513303415"] = {
						["key"] = "17636478347513303415",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3140.6666666666665,
							["y"] = 333
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17636478347513303416"] = {
						["key"] = "17636478347513303416",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2283.5714285714284,
							["y"] = 830.7142857142858
						},
						["propsData"] = {}
					},
					["17636478347513303417"] = {
						["key"] = "17636478347513303417",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 3194.238095238095,
							["y"] = 40.33333333333343
						},
						["propsData"] = {}
					},
					["17636478347513303418"] = {
						["key"] = "17636478347513303418",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1522.9047619047615,
							["y"] = 745.047619047619
						},
						["propsData"] = {}
					},
					["17636478347513303419"] = {
						["key"] = "17636478347513303419",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "扶疏魅影",
						["pos"] = {
							["x"] = 1440.6619047619047,
							["y"] = -295.5571428571429
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050118
							}
						}
					},
					["17636478347513303420"] = {
						["key"] = "17636478347513303420",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁扶疏魅影",
						["pos"] = {
							["x"] = 2852.7619047619046,
							["y"] = 63.19047619047615
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050118
							}
						}
					},
					["17636478347513303421"] = {
						["key"] = "17636478347513303421",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁扶疏魅影",
						["pos"] = {
							["x"] = 1809.1904761904757,
							["y"] = 794.9047619047618
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050118
							}
						}
					},
					["176529119985843650677"] = {
						["key"] = "176529119985843650677",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2560,
							["y"] = 44
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}