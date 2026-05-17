return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17638126691083436548",
			["startPort"] = "Success",
			["endStory"] = "17638126691083436549",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638126691083436549",
			["startPort"] = "Success",
			["endStory"] = "17638126691083436550",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638126591503436275",
			["startPort"] = "StoryStart",
			["endStory"] = "17638126691083436548",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638126691083436550",
			["startPort"] = "Success",
			["endStory"] = "17638130346294124612",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638130346294124612",
			["startPort"] = "Success",
			["endStory"] = "17638126591513436278",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17638126591503436275"] = {
			["isStoryNode"] = true,
			["key"] = "17638126591503436275",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 120306
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17638126591513436278"] = {
			["isStoryNode"] = true,
			["key"] = "17638126591513436278",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1443.6923076923076,
				["y"] = 490.025641025641
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17638126691083436548"] = {
			["isStoryNode"] = true,
			["key"] = "17638126691083436548",
			["type"] = "StoryNode",
			["name"] = "第四关报名",
			["pos"] = {
				["x"] = 1125.9407014096494,
				["y"] = 288.49169071195917
			},
			["propsData"] = {
				["QuestId"] = 12030601,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120306_1",
				["QuestDeatil"] = "Content__120306_1",
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
					105201
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203020101_132410057",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638126691093436565",
						["startPort"] = "QuestStart",
						["endQuest"] = "17638126691093436568",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638126691093436569",
						["startPort"] = "Out",
						["endQuest"] = "17638126691093436566",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17638126691093436568",
						["startPort"] = "Out",
						["endQuest"] = "177267889822114717830",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17638126691093436568",
						["startPort"] = "Out",
						["endQuest"] = "17727891897573694885",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727891897573694885",
						["startPort"] = "Out",
						["endQuest"] = "17638126691093436569",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17638126691093436565"] = {
						["key"] = "17638126691093436565",
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
					["17638126691093436566"] = {
						["key"] = "17638126691093436566",
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
					["17638126691093436567"] = {
						["key"] = "17638126691093436567",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1814,
							["y"] = 554
						},
						["propsData"] = {}
					},
					["17638126691093436568"] = {
						["key"] = "17638126691093436568",
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
					["17638126691093436569"] = {
						["key"] = "17638126691093436569",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1721.7076923076925,
							["y"] = 276.05150501672244
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062401.12062401'",
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
					["17638126691093436570"] = {
						["key"] = "17638126691093436570",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1711.3578595317726,
							["y"] = 68.49832775919735
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = false
						}
					},
					["177267889822114717830"] = {
						["key"] = "177267889822114717830",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1440.8954545454544,
							["y"] = 447.72727272727275
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = false,
							["LerpTime"] = 0
						}
					},
					["17727891897573694885"] = {
						["key"] = "17727891897573694885",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1441.0749999999998,
							["y"] = 278.14999999999986
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12062347,
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
		},
		["17638126691083436549"] = {
			["isStoryNode"] = true,
			["key"] = "17638126691083436549",
			["type"] = "StoryNode",
			["name"] = "第四关",
			["pos"] = {
				["x"] = 1443.9358174047657,
				["y"] = 297.5392859619532
			},
			["propsData"] = {
				["QuestId"] = 12030602,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120306_2",
				["QuestDeatil"] = "Content__120306_2",
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
						["startQuest"] = "17638126691113436594",
						["startPort"] = "Out",
						["endQuest"] = "17638126691113436591",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17679440649279811468",
						["startPort"] = "Out",
						["endQuest"] = "17679440649279811467",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679440649279811467",
						["startPort"] = "Option_2",
						["endQuest"] = "17679440649279811468",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638126691113436590",
						["startPort"] = "QuestStart",
						["endQuest"] = "17679440649279811467",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679440649279811467",
						["startPort"] = "Option_1",
						["endQuest"] = "17679440649279811468",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679440649279811467",
						["startPort"] = "Option_1",
						["endQuest"] = "17720870086759261023",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638126691113436590",
						["startPort"] = "QuestStart",
						["endQuest"] = "17638126691113436593",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638126691113436593",
						["startPort"] = "Success",
						["endQuest"] = "17638126691113436594",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638126691113436593",
						["startPort"] = "Success",
						["endQuest"] = "17679440649279811467",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17638126691113436593",
						["startPort"] = "Success",
						["endQuest"] = "177267892460115943450",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17638126691113436590"] = {
						["key"] = "17638126691113436590",
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
					["17638126691113436591"] = {
						["key"] = "17638126691113436591",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1805.987295825771,
							["y"] = 286.51179673321235
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638126691113436592"] = {
						["key"] = "17638126691113436592",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1941.1055900621118,
							["y"] = 448.5269151138716
						},
						["propsData"] = {}
					},
					["17638126691113436593"] = {
						["key"] = "17638126691113436593",
						["type"] = "AsyncConditionNode",
						["name"] = "异步等待条件完成",
						["pos"] = {
							["x"] = 1201.4122807017543,
							["y"] = 286.2719298245615
						},
						["propsData"] = {
							["ConditionId"] = 10301430
						}
					},
					["17638126691113436594"] = {
						["key"] = "17638126691113436594",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1521.4923213251898,
							["y"] = 288.88859612394197
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062501.12062501'",
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
					["17638126691113436595"] = {
						["key"] = "17638126691113436595",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1857.9515689740927,
							["y"] = -35.262396561533535
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410057,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020101_132410057"
						}
					},
					["17679440649279811467"] = {
						["key"] = "17679440649279811467",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1203.4473684210527,
							["y"] = 50.73684210526312
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
					["17679440649279811468"] = {
						["key"] = "17679440649279811468",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1204.9473684210527,
							["y"] = -154.76315789473688
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17720870086759261023"] = {
						["key"] = "17720870086759261023",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1523,
							["y"] = 48.41666666666663
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = true,
							["InterfaceJumpId"] = 89
						}
					},
					["177267892460115943450"] = {
						["key"] = "177267892460115943450",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1525.7857142857144,
							["y"] = 488.28571428571433
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
		["17638126691083436550"] = {
			["isStoryNode"] = true,
			["key"] = "17638126691083436550",
			["type"] = "StoryNode",
			["name"] = "离场",
			["pos"] = {
				["x"] = 802.5096191031712,
				["y"] = 488.5418237807944
			},
			["propsData"] = {
				["QuestId"] = 12030603,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120306_3",
				["QuestDeatil"] = "Content__120306_3",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203060301_132410060",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638126691143436614",
						["startPort"] = "QuestStart",
						["endQuest"] = "17638128401504124152",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638128401504124152",
						["startPort"] = "Out",
						["endQuest"] = "17638126691143436617",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638126691143436614",
						["startPort"] = "QuestStart",
						["endQuest"] = "176673762251415974560",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17689882726793262",
						["startPort"] = "Out",
						["endQuest"] = "17638126691143436615",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17638126691143436617",
						["startPort"] = "Out",
						["endQuest"] = "1769149458596372441",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769149458596372441",
						["startPort"] = "Out",
						["endQuest"] = "17689882723433252",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17689882723433252",
						["startPort"] = "Out",
						["endQuest"] = "1769149617713372832",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769149617713372832",
						["startPort"] = "Out",
						["endQuest"] = "17689882726793262",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17638126691143436614"] = {
						["key"] = "17638126691143436614",
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
					["17638126691143436615"] = {
						["key"] = "17638126691143436615",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2281.2766258505853,
							["y"] = 292.89666025678554
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638126691143436616"] = {
						["key"] = "17638126691143436616",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2334.363636363636,
							["y"] = 557.9848484848485
						},
						["propsData"] = {}
					},
					["17638126691143436617"] = {
						["key"] = "17638126691143436617",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1401.7113885482893,
							["y"] = 271.9891741749232
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062601.12062601'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030601",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
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
					["17638128401504124152"] = {
						["key"] = "17638128401504124152",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1120.577585081893,
							["y"] = 272.5322479080882
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410060,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203060301_132410060"
						}
					},
					["176673762251415974560"] = {
						["key"] = "176673762251415974560",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1119.5179844988609,
							["y"] = 472.2730717923842
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12062524,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17689882723433252"] = {
						["key"] = "17689882723433252",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1681.6520869481399,
							["y"] = 275.52404079367136
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062638.12062638'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030601",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
					["17689882726793262"] = {
						["key"] = "17689882726793262",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1999.6211138889412,
							["y"] = 271.8906882591092
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062641.12062641'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030601",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
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
					["1769149458596372441"] = {
						["key"] = "1769149458596372441",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1400.632575757576,
							["y"] = 473.84848484848476
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC001/Ver0103_SC001_P1",
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["1769149617713372832"] = {
						["key"] = "1769149617713372832",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1681.4261974584556,
							["y"] = 469.3616813294232
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC001/Ver0103_SC001_P2",
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17638130346294124612"] = {
			["isStoryNode"] = true,
			["key"] = "17638130346294124612",
			["type"] = "StoryNode",
			["name"] = "找小安",
			["pos"] = {
				["x"] = 1123.0505876973268,
				["y"] = 487.660342676647
			},
			["propsData"] = {
				["QuestId"] = 12030604,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120306_4",
				["QuestDeatil"] = "Content__120306_4",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {
					104503
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203060401_132010086",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638130346294124617",
						["startPort"] = "QuestStart",
						["endQuest"] = "17638130346294124621",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638130346294124621",
						["startPort"] = "Out",
						["endQuest"] = "17638130346294124620",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638130346294124620",
						["startPort"] = "Out",
						["endQuest"] = "17638130346294124618",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17638130346294124617",
						["startPort"] = "QuestStart",
						["endQuest"] = "17708825420583475767",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17638130346294124617"] = {
						["key"] = "17638130346294124617",
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
					["17638130346294124618"] = {
						["key"] = "17638130346294124618",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1767.5351219127276,
							["y"] = 297.03788368973403
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638130346294124619"] = {
						["key"] = "17638130346294124619",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1598,
							["y"] = 486.1666666666667
						},
						["propsData"] = {}
					},
					["17638130346294124620"] = {
						["key"] = "17638130346294124620",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1407.3737442500908,
							["y"] = 287.8522324875783
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062701.12062701'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030602",
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
					["17638130346294124621"] = {
						["key"] = "17638130346294124621",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1104.074704897561,
							["y"] = 280.179425327443
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132010086,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203060401_132010086"
						}
					},
					["17708825420583475767"] = {
						["key"] = "17708825420583475767",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1094.0459706959705,
							["y"] = 464.0805860805861
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132420143,
								132420144
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