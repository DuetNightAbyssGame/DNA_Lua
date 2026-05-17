return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17634563244721356161",
			["startPort"] = "StoryStart",
			["endStory"] = "17634563629991356578",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17634563629991356578",
			["startPort"] = "Success",
			["endStory"] = "17634563958871357205",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17634577789326769680",
			["startPort"] = "Success",
			["endStory"] = "17634589533428124907",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17634563958871357205",
			["startPort"] = "Success",
			["endStory"] = "17634577789326769680",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17634589533428124907",
			["startPort"] = "Success",
			["endStory"] = "17634590329428125615",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17634590329428125615",
			["startPort"] = "Success",
			["endStory"] = "17634563244721356164",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17634563244721356161"] = {
			["isStoryNode"] = true,
			["key"] = "17634563244721356161",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 802.0689655172414,
				["y"] = 287.58620689655174
			},
			["propsData"] = {
				["QuestChainId"] = 120302
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17634563244721356164"] = {
			["isStoryNode"] = true,
			["key"] = "17634563244721356164",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1766.9501915708813,
				["y"] = 489.9310344827586
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17634563629991356578"] = {
			["isStoryNode"] = true,
			["key"] = "17634563629991356578",
			["type"] = "StoryNode",
			["name"] = "第一关报名",
			["pos"] = {
				["x"] = 1123.1164750957855,
				["y"] = 289.5386973180077
			},
			["propsData"] = {
				["QuestId"] = 12030201,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120302_1",
				["QuestDeatil"] = "Content__120302_1",
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
					104501
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203020101_132410057",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17634563629991356579",
						["startPort"] = "QuestStart",
						["endQuest"] = "17634567152412033501",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634567152412033501",
						["startPort"] = "Out",
						["endQuest"] = "17634567645132034032",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634567645132034032",
						["startPort"] = "Out",
						["endQuest"] = "17634563629991356582",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17634567152412033501",
						["startPort"] = "Out",
						["endQuest"] = "17726785336946132497",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17634563629991356579"] = {
						["key"] = "17634563629991356579",
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
					["17634563629991356582"] = {
						["key"] = "17634563629991356582",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2002.3076923076924,
							["y"] = 292.46153846153845
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17634563629991356585"] = {
						["key"] = "17634563629991356585",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1814,
							["y"] = 554
						},
						["propsData"] = {}
					},
					["17634567152412033501"] = {
						["key"] = "17634567152412033501",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1128.5384615384614,
							["y"] = 269.7692307692308
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410057,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020101_132410057"
						}
					},
					["17634567645132034032"] = {
						["key"] = "17634567645132034032",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1401.3076923076924,
							["y"] = 267.33846153846156
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12060701.12060701'",
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
					["17634572731474064565"] = {
						["key"] = "17634572731474064565",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1682.9230769230771,
							["y"] = 66.84615384615387
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = false
						}
					},
					["17726785336946132497"] = {
						["key"] = "17726785336946132497",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1407.0458937198066,
							["y"] = 453.7753623188406
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = false,
							["LerpTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17634563958871357205"] = {
			["isStoryNode"] = true,
			["key"] = "17634563958871357205",
			["type"] = "StoryNode",
			["name"] = "第一关",
			["pos"] = {
				["x"] = 1441.4152052334507,
				["y"] = 288.3652349263965
			},
			["propsData"] = {
				["QuestId"] = 12030202,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120302_2",
				["QuestDeatil"] = "Content__120302_2",
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
						["startQuest"] = "17634578623896770278",
						["startPort"] = "Out",
						["endQuest"] = "17634563958881357209",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17634563958881357206",
						["startPort"] = "QuestStart",
						["endQuest"] = "17679407791355762",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679412125517138",
						["startPort"] = "Out",
						["endQuest"] = "17679407791355762",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679407791355762",
						["startPort"] = "Option_1",
						["endQuest"] = "17719865074602451",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634563958881357206",
						["startPort"] = "QuestStart",
						["endQuest"] = "17634571075233387699",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679407791355762",
						["startPort"] = "Option_1",
						["endQuest"] = "17679412125517138",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679407791355762",
						["startPort"] = "Option_2",
						["endQuest"] = "17679412125517138",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634571075233387699",
						["startPort"] = "Success",
						["endQuest"] = "17634578623896770278",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634571075233387699",
						["startPort"] = "Success",
						["endQuest"] = "17679407791355762",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17634571075233387699",
						["startPort"] = "Success",
						["endQuest"] = "17726785603297358063",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17634563958881357206"] = {
						["key"] = "17634563958881357206",
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
					["17634563958881357209"] = {
						["key"] = "17634563958881357209",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1804.7481653909886,
							["y"] = 289.5770141245167
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17634563958881357212"] = {
						["key"] = "17634563958881357212",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1808,
							["y"] = 491.6212121212121
						},
						["propsData"] = {}
					},
					["17634571075233387699"] = {
						["key"] = "17634571075233387699",
						["type"] = "AsyncConditionNode",
						["name"] = "异步等待条件完成",
						["pos"] = {
							["x"] = 1120.957735247209,
							["y"] = 289.86086263088555
						},
						["propsData"] = {
							["ConditionId"] = 10301427
						}
					},
					["17634578623896770278"] = {
						["key"] = "17634578623896770278",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1477.5476572935693,
							["y"] = 291.4261455310566
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12060801.12060801'",
							["TalkType"] = "QuestImpression",
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
					["17634578983737446554"] = {
						["key"] = "17634578983737446554",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1792.1788417013654,
							["y"] = -9.535123834260787
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410057,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020101_132410057"
						}
					},
					["17679407791355762"] = {
						["key"] = "17679407791355762",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1119.4782608695652,
							["y"] = 47.94565217391302
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
					["17679412125517138"] = {
						["key"] = "17679412125517138",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1123.7826086956522,
							["y"] = -126.18478260869566
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17719865074602451"] = {
						["key"] = "17719865074602451",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1482.1739130434783,
							["y"] = 50.08695652173907
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = true,
							["InterfaceJumpId"] = 89
						}
					},
					["17726785603297358063"] = {
						["key"] = "17726785603297358063",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1483.7077922077924,
							["y"] = 489.5343773873186
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = false,
							["LerpTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17634577789326769680"] = {
			["isStoryNode"] = true,
			["key"] = "17634577789326769680",
			["type"] = "StoryNode",
			["name"] = "去东城",
			["pos"] = {
				["x"] = 797.2359443854061,
				["y"] = 474.8037478754358
			},
			["propsData"] = {
				["QuestId"] = 12030203,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120302_3",
				["QuestDeatil"] = "Content__120302_3",
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
				["SubRegionId"] = 104501,
				["SubRegionIdList"] = {
					104503
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203020301_132010083",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17634577789326769681",
						["startPort"] = "QuestStart",
						["endQuest"] = "17634583747818123392",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634583747818123392",
						["startPort"] = "Out",
						["endQuest"] = "17634583763798123418",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634583747818123392",
						["startPort"] = "Out",
						["endQuest"] = "17634583832138123561",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634583763798123418",
						["startPort"] = "Out",
						["endQuest"] = "17634583851208123671",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634583851208123671",
						["startPort"] = "Out",
						["endQuest"] = "17697581069482259703",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17697581069482259703",
						["startPort"] = "Out",
						["endQuest"] = "17634577789326769684",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17634577789326769681",
						["startPort"] = "QuestStart",
						["endQuest"] = "177218379220932524860",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634583747818123392",
						["startPort"] = "Out",
						["endQuest"] = "177218377807532524606",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17634577789326769681"] = {
						["key"] = "17634577789326769681",
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
					["17634577789326769684"] = {
						["key"] = "17634577789326769684",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2244.4534412955463,
							["y"] = 297.12550607287443
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17634577789326769687"] = {
						["key"] = "17634577789326769687",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2081.578947368421,
							["y"] = 534.2105263157895
						},
						["propsData"] = {}
					},
					["17634583747818123392"] = {
						["key"] = "17634583747818123392",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1079.178757388123,
							["y"] = 276.15873909372357
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132010083,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020301_132010083"
						}
					},
					["17634583763798123418"] = {
						["key"] = "17634583763798123418",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1401.68114973262,
							["y"] = 271.5558682803264
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132010084,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020302_132010084"
						}
					},
					["17634583832138123561"] = {
						["key"] = "17634583832138123561",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1400.6380875316636,
							["y"] = 72.89558119898678
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12060822,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17634583851208123671"] = {
						["key"] = "17634583851208123671",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1681.059508216242,
							["y"] = 276.5025005953799
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12060901.12060901'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030202",
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
					["17697581069482259703"] = {
						["key"] = "17697581069482259703",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1960.9726576853907,
							["y"] = 274.30347197605266
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12060919,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["177218377807532524606"] = {
						["key"] = "177218377807532524606",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1401.2153110047848,
							["y"] = 447.9090909090907
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12060820,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "DelayLoop",
							["BubbleDelayLoopSeconds"] = 10,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["ShowSkipButton"] = false,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["bBubblePlayCDEnable"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 250012,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 250013,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["177218379220932524860"] = {
						["key"] = "177218379220932524860",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1082.620905410379,
							["y"] = 447.3111888111888
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010150,
								132010151
							}
						}
					},
					["17726785756727358429"] = {
						["key"] = "17726785756727358429",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1405.4654165493944,
							["y"] = -94.02272727272735
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = true,
							["LerpTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17634589533428124907"] = {
			["isStoryNode"] = true,
			["key"] = "17634589533428124907",
			["type"] = "StoryNode",
			["name"] = "拍照",
			["pos"] = {
				["x"] = 1119.0876190265544,
				["y"] = 471.18502892550083
			},
			["propsData"] = {
				["QuestId"] = 12030204,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120302_4",
				["QuestDeatil"] = "Content__120302_4",
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
				["SubRegionId"] = 104501,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203020302_132010084",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17652680554452098473",
						["startPort"] = "Out",
						["endQuest"] = "17634589533428124911",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17667363195676389443",
						["startPort"] = "Out",
						["endQuest"] = "17667363387736389664",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667358374056389124",
						["startPort"] = "Success",
						["endQuest"] = "17667366173926390273",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667358374056389124",
						["startPort"] = "Success",
						["endQuest"] = "17667367470087455101",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667363195676389443",
						["startPort"] = "Out",
						["endQuest"] = "17667367432077455013",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634589533428124908",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667363195676389443",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667367470087455101",
						["startPort"] = "Out",
						["endQuest"] = "17652680554452098473",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667363387736389664",
						["startPort"] = "Out",
						["endQuest"] = "17667358374056389124",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667363387736389664",
						["startPort"] = "Out",
						["endQuest"] = "17684681105788751632",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17684681105788751632",
						["startPort"] = "Out",
						["endQuest"] = "17667366036356389825",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667366036356389825",
						["startPort"] = "Out",
						["endQuest"] = "17667363387736389664",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667358374056389124",
						["startPort"] = "Success",
						["endQuest"] = "17667363387736389664",
						["endPort"] = "Stop"
					}
				},
				["nodeData"] = {
					["17634589533428124908"] = {
						["key"] = "17634589533428124908",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 165.20454545454547,
							["y"] = 688.1818181818182
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17634589533428124911"] = {
						["key"] = "17634589533428124911",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1839.8765906680806,
							["y"] = 895.2371420996819
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17634589533428124914"] = {
						["key"] = "17634589533428124914",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2142,
							["y"] = 320
						},
						["propsData"] = {}
					},
					["17652680554452098473"] = {
						["key"] = "17652680554452098473",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1520.4148803211635,
							["y"] = 870.2800901378579
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12060913.12060913'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030202",
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
					["17667358374056389124"] = {
						["key"] = "17667358374056389124",
						["type"] = "CameraNode",
						["name"] = "相机节点",
						["pos"] = {
							["x"] = 1201.109584437671,
							["y"] = 672.7961559910004
						},
						["propsData"] = {
							["bFadeInOut"] = false,
							["bIsForceOpenCamera"] = true,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["_GuidePointName"] = "",
							["TargetPointList"] = {
								"BP_NewTargetPoint_12030204"
							},
							["EventId"] = 0,
							["EventParams"] = {},
							["Text_TargetFound"] = "",
							["Text_TargetNotFound"] = "",
							["ForceMaxLodStaticPointList"] = {
								132010120,
								132010121,
								132010146
							},
							["bShouldSetCameraParams"] = true,
							["FocalLength"] = 24,
							["LookAtTargetName"] = "BP_NewTargetPoint_12030204",
							["StartPos"] = "(X=47045,Y=-27577,Z=3105)",
							["bLockCameraPos"] = false,
							["bStartHiddenRole"] = true,
							["bLockHiddenRole"] = true,
							["bStartHiddenNPC"] = false,
							["bLockHiddenNPC"] = false,
							["bStartHiddenMonster"] = true,
							["bLockHiddenMonster"] = true,
							["bStartHiddenPet"] = true,
							["bLockHiddenPet"] = true,
							["bLockGamePause"] = false,
							["bForceGamePause"] = false
						}
					},
					["17667363195676389443"] = {
						["key"] = "17667363195676389443",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 477.6122881896677,
							["y"] = 691.1912448232885
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010119,
								132010120,
								132010121,
								132010146
							}
						}
					},
					["17667363387736389664"] = {
						["key"] = "17667363387736389664",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 842.2016321610819,
							["y"] = 672.2242255403739
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 132010119,
							["StateId"] = 11301281,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17667366036356389825"] = {
						["key"] = "17667366036356389825",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "初始化机关",
						["pos"] = {
							["x"] = 1004.2117343101964,
							["y"] = 896.4293117958938
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								132010119
							},
							["ManualItemIdList"] = {},
							["StateId"] = 11301280,
							["QuestId"] = 0
						}
					},
					["17667366173926390273"] = {
						["key"] = "17667366173926390273",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1520.269676312381,
							["y"] = 495.57729886212877
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010119,
								132010120,
								132010121,
								132010146
							}
						}
					},
					["17667367432077455013"] = {
						["key"] = "17667367432077455013",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "拍照指引点",
						["pos"] = {
							["x"] = 842.4349321092158,
							["y"] = 467.6855984572705
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_1203020302_132010084"
						}
					},
					["17667367470087455101"] = {
						["key"] = "17667367470087455101",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "干掉拍照指引点",
						["pos"] = {
							["x"] = 1520.9187037723354,
							["y"] = 675.9531569856986
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_1203020302_132010084"
						}
					},
					["17684681105788751632"] = {
						["key"] = "17684681105788751632",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 720.2027972027971,
							["y"] = 872.7633419212367
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17726785913867358893"] = {
						["key"] = "17726785913867358893",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1200.4324566098862,
							["y"] = 494.45959571119414
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = true,
							["LerpTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17634590329428125615"] = {
			["isStoryNode"] = true,
			["key"] = "17634590329428125615",
			["type"] = "StoryNode",
			["name"] = "小黑子",
			["pos"] = {
				["x"] = 1443.8209598941964,
				["y"] = 478.07766542793775
			},
			["propsData"] = {
				["QuestId"] = 12030205,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120302_5",
				["QuestDeatil"] = "Content__120302_5",
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
				["SubRegionId"] = 104501,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203010101_132010079",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17634590329428125616",
						["startPort"] = "QuestStart",
						["endQuest"] = "17634590699348126010",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634590699348126010",
						["startPort"] = "Out",
						["endQuest"] = "17634590823108126350",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634590823108126350",
						["startPort"] = "Out",
						["endQuest"] = "176578313837212630745",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176578313837212630745",
						["startPort"] = "Out",
						["endQuest"] = "17634590834958126429",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634590834958126429",
						["startPort"] = "Out",
						["endQuest"] = "176578322180112631238",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176578313837212630745",
						["startPort"] = "Out",
						["endQuest"] = "177209607661943984430",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176578322180112631238",
						["startPort"] = "Out",
						["endQuest"] = "17634590329428125619",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17634590329428125616"] = {
						["key"] = "17634590329428125616",
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
					["17634590329428125619"] = {
						["key"] = "17634590329428125619",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2640.692513368984,
							["y"] = 284.4425133689839
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17634590329428125622"] = {
						["key"] = "17634590329428125622",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2074,
							["y"] = 612
						},
						["propsData"] = {}
					},
					["17634590699348126010"] = {
						["key"] = "17634590699348126010",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1081.6470588235293,
							["y"] = 271.3088235294117
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132010079,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203010101_132010079"
						}
					},
					["17634590823108126350"] = {
						["key"] = "17634590823108126350",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1399.9261845470455,
							["y"] = 268.0412404092072
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061001.12061001'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
					["17634590834958126429"] = {
						["key"] = "17634590834958126429",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2040.3003251123623,
							["y"] = 271.227795031056
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250003,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030205Suyi_132010085",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061101.12061101'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030203",
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
					["176578313837212630745"] = {
						["key"] = "176578313837212630745",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1720.6363636363637,
							["y"] = 296
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Npc_12030205Suyi_132010085",
							["StaticCreatorIdList"] = {
								132010085
							}
						}
					},
					["176578322180112631238"] = {
						["key"] = "176578322180112631238",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2361.6684491978604,
							["y"] = 285.81283422459893
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010085
							}
						}
					},
					["177209607661943984430"] = {
						["key"] = "177209607661943984430",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2042.8916408668733,
							["y"] = 96.02941176470588
						},
						["propsData"] = {
							["NewDescription"] = "Description_120302_6",
							["NewDetail"] = "Content__120302_6",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17726786307317359753"] = {
						["key"] = "17726786307317359753",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1406.2105263157894,
							["y"] = 449.8947368421052
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = true,
							["LerpTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}