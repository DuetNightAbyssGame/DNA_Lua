return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17637287676743430251",
			["startPort"] = "StoryStart",
			["endStory"] = "17637291918634114305",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17637291918634114305",
			["startPort"] = "Success",
			["endStory"] = "17637293161184114780",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17637293161184114780",
			["startPort"] = "Success",
			["endStory"] = "17637294815294115814",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17637294815294115814",
			["startPort"] = "Success",
			["endStory"] = "17637287676743430254",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17637287676743430251"] = {
			["isStoryNode"] = true,
			["key"] = "17637287676743430251",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 120304
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17637287676743430254"] = {
			["isStoryNode"] = true,
			["key"] = "17637287676743430254",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1923.6571428571426,
				["y"] = 287.14285714285717
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17637291918634114305"] = {
			["isStoryNode"] = true,
			["key"] = "17637291918634114305",
			["type"] = "StoryNode",
			["name"] = "第三关报名",
			["pos"] = {
				["x"] = 1083.5921568627448,
				["y"] = 290.0522875816994
			},
			["propsData"] = {
				["QuestId"] = 12030401,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120304_1",
				["QuestDeatil"] = "Content__120304_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {
					104504
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203020101_132410057",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17637291918634114310",
						["startPort"] = "QuestStart",
						["endQuest"] = "17637291918634114313",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637291918634114313",
						["startPort"] = "Out",
						["endQuest"] = "17637291918634114314",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637291918634114314",
						["startPort"] = "Out",
						["endQuest"] = "17637291918634114311",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17637291918634114313",
						["startPort"] = "Out",
						["endQuest"] = "177267881428713490486",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17637291918634114310"] = {
						["key"] = "17637291918634114310",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 802,
							["y"] = 298
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637291918634114311"] = {
						["key"] = "17637291918634114311",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1720.3076923076924,
							["y"] = 292.46153846153845
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637291918634114312"] = {
						["key"] = "17637291918634114312",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1814,
							["y"] = 554
						},
						["propsData"] = {}
					},
					["17637291918634114313"] = {
						["key"] = "17637291918634114313",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1120.5384615384614,
							["y"] = 269.7692307692308
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410057,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020101_132410057"
						}
					},
					["17637291918634114314"] = {
						["key"] = "17637291918634114314",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1403.7576923076924,
							["y"] = 269.61346153846154
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061601.12061601'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030201",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17637291918634114315"] = {
						["key"] = "17637291918634114315",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1704.9230769230771,
							["y"] = 20.846153846153868
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = false
						}
					},
					["177267881428713490486"] = {
						["key"] = "177267881428713490486",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1401.3436532507742,
							["y"] = 448.80000000000007
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = false,
							["LerpTime"] = 2
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17637293161184114780"] = {
			["isStoryNode"] = true,
			["key"] = "17637293161184114780",
			["type"] = "StoryNode",
			["name"] = "第三关",
			["pos"] = {
				["x"] = 1358.8948646125118,
				["y"] = 287.10438842203547
			},
			["propsData"] = {
				["QuestId"] = 12030402,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120304_2",
				["QuestDeatil"] = "Content__120304_2",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_12030202Giongzuo_132410089",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17637293161184114789",
						["startPort"] = "Out",
						["endQuest"] = "17637293161184114786",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17679440274678722250",
						["startPort"] = "Out",
						["endQuest"] = "17679440274678722249",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679440274678722249",
						["startPort"] = "Option_2",
						["endQuest"] = "17679440274678722250",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637293161184114785",
						["startPort"] = "QuestStart",
						["endQuest"] = "17679440274678722249",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637293161184114785",
						["startPort"] = "QuestStart",
						["endQuest"] = "17637293161184114788",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637293161184114788",
						["startPort"] = "Success",
						["endQuest"] = "17637293161184114789",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679440274678722249",
						["startPort"] = "Option_1",
						["endQuest"] = "17679440274678722250",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679440274678722249",
						["startPort"] = "Option_1",
						["endQuest"] = "17720868957535788751",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637293161184114788",
						["startPort"] = "Success",
						["endQuest"] = "17679440274678722249",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17637293161184114788",
						["startPort"] = "Success",
						["endQuest"] = "17733000471423886043",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17637293161184114785"] = {
						["key"] = "17637293161184114785",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 801.6666666666666,
							["y"] = 289.1666666666667
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637293161184114786"] = {
						["key"] = "17637293161184114786",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1798.2188747731393,
							["y"] = 294.2644283121597
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637293161184114787"] = {
						["key"] = "17637293161184114787",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2048,
							["y"] = 554.1666666666667
						},
						["propsData"] = {}
					},
					["17637293161184114788"] = {
						["key"] = "17637293161184114788",
						["type"] = "AsyncConditionNode",
						["name"] = "异步等待条件完成",
						["pos"] = {
							["x"] = 1158.280701754386,
							["y"] = 290.4011164274323
						},
						["propsData"] = {
							["ConditionId"] = 10301429
						}
					},
					["17637293161184114789"] = {
						["key"] = "17637293161184114789",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1483.3966275452854,
							["y"] = 287.09433775073626
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061701.12061701'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030201",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17637293161184114790"] = {
						["key"] = "17637293161184114790",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1909.4061144286381,
							["y"] = -29.262396561533535
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410057,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020101_132410057"
						}
					},
					["17679440274678722249"] = {
						["key"] = "17679440274678722249",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1158.4736842105262,
							["y"] = 24.51083591331278
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250011,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030202Giongzuo_132410089",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 12060740,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = false,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {
								{
									["OptionText"] = "12060741",
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								},
								{
									["OptionText"] = "12060742",
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["17679440274678722250"] = {
						["key"] = "17679440274678722250",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1164.421052631579,
							["y"] = -163.85758513931881
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17720868957535788751"] = {
						["key"] = "17720868957535788751",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1480.699303405573,
							["y"] = 49.69659442724446
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = true,
							["InterfaceJumpId"] = 89
						}
					},
					["17733000471423886043"] = {
						["key"] = "17733000471423886043",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1510,
							["y"] = 510
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = false,
							["LerpTime"] = 2
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17637294815294115814"] = {
			["isStoryNode"] = true,
			["key"] = "17637294815294115814",
			["type"] = "StoryNode",
			["name"] = "和止流谈谈",
			["pos"] = {
				["x"] = 1644.9476929215618,
				["y"] = 289.6854449472098
			},
			["propsData"] = {
				["QuestId"] = 12030403,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120304_3",
				["QuestDeatil"] = "Content__120304_3",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_12030403Zhiliu_132410065",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17637296623024116376",
						["startPort"] = "Out",
						["endQuest"] = "17637294815294115823",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637294815294115819",
						["startPort"] = "QuestStart",
						["endQuest"] = "17654408633742106182",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17654408633742106182",
						["startPort"] = "Out",
						["endQuest"] = "17637296623024116376",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637294815294115823",
						["startPort"] = "Out",
						["endQuest"] = "176578694043324206465",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637296623024116376",
						["startPort"] = "Out",
						["endQuest"] = "17706262589073150",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637294815294115823",
						["startPort"] = "Out",
						["endQuest"] = "17727842996615320255",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727842996615320255",
						["startPort"] = "Out",
						["endQuest"] = "17654406995785335",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17654406995785335",
						["startPort"] = "Out",
						["endQuest"] = "17637294815294115820",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17637294815294115819"] = {
						["key"] = "17637294815294115819",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 617.8205128205128,
							["y"] = 303.01282051282055
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637294815294115820"] = {
						["key"] = "17637294815294115820",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2322.3899322697876,
							["y"] = 289.65214182872984
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105201,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17637294815294115821"] = {
						["key"] = "17637294815294115821",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1206.8461538461538,
							["y"] = 680.0128205128206
						},
						["propsData"] = {}
					},
					["17637294815294115823"] = {
						["key"] = "17637294815294115823",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1416.3206041534727,
							["y"] = 290.9633435986894
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250004,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030403Zhiliu_132410065",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 12061901,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17637296623024116376"] = {
						["key"] = "17637296623024116376",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1132.5473684210524,
							["y"] = 288.5263157894736
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250004,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030403Zhiliu_132410065",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061801.12061801'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030401",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17654406995785335"] = {
						["key"] = "17654406995785335",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2038.2964029434618,
							["y"] = 289.084693084693
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062001.12062001'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030402",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17654408633742106182"] = {
						["key"] = "17654408633742106182",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 880.2758228638197,
							["y"] = 302.16731245583924
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132410065
							}
						}
					},
					["176578694043324206465"] = {
						["key"] = "176578694043324206465",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1708.9948512585813,
							["y"] = 129.327399380805
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132410065
							}
						}
					},
					["17706262589073150"] = {
						["key"] = "17706262589073150",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1421.039835164835,
							["y"] = 105.17582417582405
						},
						["propsData"] = {
							["NewDescription"] = "Description_120304_4",
							["NewDetail"] = "Content__120304_4",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17727842996615320255"] = {
						["key"] = "17727842996615320255",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1723.4329501915706,
							["y"] = 288.04597701149424
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12063011,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = false,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}