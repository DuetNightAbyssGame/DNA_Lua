return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17637158223841369280",
			["startPort"] = "StoryStart",
			["endStory"] = "17637159687752052714",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17637159687752052714",
			["startPort"] = "Success",
			["endStory"] = "17637245989832738025",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17637245989832738025",
			["startPort"] = "Success",
			["endStory"] = "17637247125282739150",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17637247125282739150",
			["startPort"] = "Success",
			["endStory"] = "17637248930082740535",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17637248930082740535",
			["startPort"] = "Success",
			["endStory"] = "17637158223841369283",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17637158223841369280"] = {
			["isStoryNode"] = true,
			["key"] = "17637158223841369280",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 120303
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17637158223841369283"] = {
			["isStoryNode"] = true,
			["key"] = "17637158223841369283",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1654.9875776397516,
				["y"] = 522.6273291925468
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17637159687752052714"] = {
			["isStoryNode"] = true,
			["key"] = "17637159687752052714",
			["type"] = "StoryNode",
			["name"] = "第二关报名",
			["pos"] = {
				["x"] = 1086.8168859649124,
				["y"] = 291.50429996560035
			},
			["propsData"] = {
				["QuestId"] = 12030301,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120303_1",
				["QuestDeatil"] = "Content__120303_1",
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
						["startQuest"] = "17637165813752053042",
						["startPort"] = "Out",
						["endQuest"] = "17637165813752053041",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637159687752052715",
						["startPort"] = "QuestStart",
						["endQuest"] = "17637165813752053042",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637165813752053041",
						["startPort"] = "Out",
						["endQuest"] = "17637159687752052718",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17637165813752053042",
						["startPort"] = "Out",
						["endQuest"] = "17726786594728585866",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17637159687752052715"] = {
						["key"] = "17637159687752052715",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 797,
							["y"] = 249
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637159687752052718"] = {
						["key"] = "17637159687752052718",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1679,
							["y"] = 246
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637159687752052721"] = {
						["key"] = "17637159687752052721",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1727,
							["y"] = 499
						},
						["propsData"] = {}
					},
					["17637165813752053041"] = {
						["key"] = "17637165813752053041",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1400.076923076923,
							["y"] = 249.84615384615387
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061201.12061201'",
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
					["17637165813752053042"] = {
						["key"] = "17637165813752053042",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1086.3076923076922,
							["y"] = 249.5769230769231
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410057,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020101_132410057"
						}
					},
					["17637165813752053043"] = {
						["key"] = "17637165813752053043",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1805.1923076923078,
							["y"] = 47.65384615384619
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = false
						}
					},
					["17726786594728585866"] = {
						["key"] = "17726786594728585866",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1408.5369446343132,
							["y"] = 445.0259284575074
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
		["17637245989832738025"] = {
			["isStoryNode"] = true,
			["key"] = "17637245989832738025",
			["type"] = "StoryNode",
			["name"] = "第二关",
			["pos"] = {
				["x"] = 1357.7922120728933,
				["y"] = 300.05810442397586
			},
			["propsData"] = {
				["QuestId"] = 12030302,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120303_2",
				["QuestDeatil"] = "Content__120303_2",
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
						["startQuest"] = "17637245989842738034",
						["startPort"] = "Out",
						["endQuest"] = "17637245989842738031",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17679439906767632972",
						["startPort"] = "Out",
						["endQuest"] = "17679439906767632971",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679439906767632971",
						["startPort"] = "Option_2",
						["endQuest"] = "17679439906767632972",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637245989842738030",
						["startPort"] = "QuestStart",
						["endQuest"] = "17679439906767632971",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679439906767632971",
						["startPort"] = "Option_1",
						["endQuest"] = "17679439906767632972",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679439906767632971",
						["startPort"] = "Option_1",
						["endQuest"] = "17720867080702315844",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637245989842738030",
						["startPort"] = "QuestStart",
						["endQuest"] = "17637245989842738033",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637245989842738033",
						["startPort"] = "Success",
						["endQuest"] = "17637245989842738034",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637245989842738033",
						["startPort"] = "Success",
						["endQuest"] = "17679439906767632971",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17637245989842738033",
						["startPort"] = "Success",
						["endQuest"] = "17726787016669812728",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17637245989842738030"] = {
						["key"] = "17637245989842738030",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 998.623188405797,
							["y"] = 299.6014492753623
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637245989842738031"] = {
						["key"] = "17637245989842738031",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2081.987295825771,
							["y"] = 288.01179673321235
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637245989842738032"] = {
						["key"] = "17637245989842738032",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2225,
							["y"] = 487.6666666666667
						},
						["propsData"] = {}
					},
					["17637245989842738033"] = {
						["key"] = "17637245989842738033",
						["type"] = "AsyncConditionNode",
						["name"] = "异步等待条件完成",
						["pos"] = {
							["x"] = 1359.14706331045,
							["y"] = 301.31540808543105
						},
						["propsData"] = {
							["ConditionId"] = 10301428
						}
					},
					["17637245989842738034"] = {
						["key"] = "17637245989842738034",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1800.765048597917,
							["y"] = 290.25223248757834
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061301.12061301'",
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
					["17637245989842738035"] = {
						["key"] = "17637245989842738035",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2025.4614503970179,
							["y"] = -38.62208035599996
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410057,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020101_132410057"
						}
					},
					["17679439906767632971"] = {
						["key"] = "17679439906767632971",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1361.9753623188408,
							["y"] = 51.256521739130385
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
					["17679439906767632972"] = {
						["key"] = "17679439906767632972",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1366.3840579710145,
							["y"] = -130.28260869565224
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17720867080702315844"] = {
						["key"] = "17720867080702315844",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1720.2782400665694,
							["y"] = 78.01065301302572
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = true,
							["InterfaceJumpId"] = 89
						}
					},
					["17726787016669812728"] = {
						["key"] = "17726787016669812728",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1685.764705882353,
							["y"] = 447.8897058823529
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
		["17637247125282739150"] = {
			["isStoryNode"] = true,
			["key"] = "17637247125282739150",
			["type"] = "StoryNode",
			["name"] = "找苏乙",
			["pos"] = {
				["x"] = 1088.555332114918,
				["y"] = 508.2307804234439
			},
			["propsData"] = {
				["QuestId"] = 12030303,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120303_3",
				["QuestDeatil"] = "Content__120303_3",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {
					104503
				},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_12030303Suyi_132420052",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17637247125282739155",
						["startPort"] = "QuestStart",
						["endQuest"] = "176535459913915033592",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176535459913915033592",
						["startPort"] = "Out",
						["endQuest"] = "17637247125282739159",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637247125282739159",
						["startPort"] = "Out",
						["endQuest"] = "176535461372615033944",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176535461372615033944",
						["startPort"] = "Out",
						["endQuest"] = "17637247125282739156",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17637247125282739155"] = {
						["key"] = "17637247125282739155",
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
					["17637247125282739156"] = {
						["key"] = "17637247125282739156",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1951.8509321894073,
							["y"] = 315.7390694604851
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637247125282739157"] = {
						["key"] = "17637247125282739157",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1940,
							["y"] = 532.9666666666667
						},
						["propsData"] = {}
					},
					["17637247125282739159"] = {
						["key"] = "17637247125282739159",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1387.8559576888263,
							["y"] = 291.38859612394197
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250003,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030303Suyi_132420052",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061401.12061401'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030301",
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
					["176535459913915033592"] = {
						["key"] = "176535459913915033592",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1091.75,
							["y"] = 302.25
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132420052
							}
						}
					},
					["176535461372615033944"] = {
						["key"] = "176535461372615033944",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1671.75,
							["y"] = 303.4999999999999
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132420052
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17637248930082740535"] = {
			["isStoryNode"] = true,
			["key"] = "17637248930082740535",
			["type"] = "StoryNode",
			["name"] = "救小安",
			["pos"] = {
				["x"] = 1363.1354297666264,
				["y"] = 515.2306764084656
			},
			["propsData"] = {
				["QuestId"] = 12030304,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120303_4",
				["QuestDeatil"] = "Content__120303_4",
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
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203030301_132420051",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17637248930082740540",
						["startPort"] = "QuestStart",
						["endQuest"] = "17637248930082740545",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637248930082740545",
						["startPort"] = "Out",
						["endQuest"] = "17637249891592741847",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176535467032316082857",
						["startPort"] = "Out",
						["endQuest"] = "17637248930082740541",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17637251430322743814",
						["startPort"] = "Out",
						["endQuest"] = "17637251756322744423",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637248930082740545",
						["startPort"] = "Out",
						["endQuest"] = "17637248930082740544",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637251756322744423",
						["startPort"] = "Out",
						["endQuest"] = "17667373162909586775",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637248930082740544",
						["startPort"] = "Out",
						["endQuest"] = "17700309019473219",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667373162909586775",
						["startPort"] = "Out",
						["endQuest"] = "176535467032316082857",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637251430322743814",
						["startPort"] = "Out",
						["endQuest"] = "17706264362352316459",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637248930082740544",
						["startPort"] = "Out",
						["endQuest"] = "17637251430322743814",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17637248930082740540"] = {
						["key"] = "17637248930082740540",
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
					["17637248930082740541"] = {
						["key"] = "17637248930082740541",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3201.1509321894077,
							["y"] = 297.5390694604851
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637248930082740542"] = {
						["key"] = "17637248930082740542",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2804.9444444444443,
							["y"] = 727.9722222222223
						},
						["propsData"] = {}
					},
					["17637248930082740544"] = {
						["key"] = "17637248930082740544",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1404.581349538356,
							["y"] = 75.03675830658688
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12061445,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17637248930082740545"] = {
						["key"] = "17637248930082740545",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1080.6017666025512,
							["y"] = 272.8285125293756
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132420051,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203030301_132420051"
						}
					},
					["17637249891592741847"] = {
						["key"] = "17637249891592741847",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1403.7999096145707,
							["y"] = 297.2113726423675
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132420053,
								132420055
							}
						}
					},
					["17637250658392742711"] = {
						["key"] = "17637250658392742711",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1525.5856239002849,
							["y"] = 782.407756903268
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17637251430322743814"] = {
						["key"] = "17637251430322743814",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1802.608796379979,
							["y"] = 273.08955336767326
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								132420055
							}
						}
					},
					["17637251756322744423"] = {
						["key"] = "17637251756322744423",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2199.1319254248474,
							["y"] = 277.6298020390579
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250017,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030304Xiaoan_132420053",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061501.12061501'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030302",
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
					["17637252307932745179"] = {
						["key"] = "17637252307932745179",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1920.085623900285,
							["y"] = 825.8534090771811
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["176535467032316082857"] = {
						["key"] = "176535467032316082857",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2877.194905123993,
							["y"] = 280.5945702784372
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132420053
							}
						}
					},
					["17667373162909586775"] = {
						["key"] = "17667373162909586775",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2576.2230392156866,
							["y"] = 278.7444444444444
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12061516,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17700309019473219"] = {
						["key"] = "17700309019473219",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1742.099676185883,
							["y"] = 77.61108288263452
						},
						["propsData"] = {
							["NewDescription"] = "Description_120303_5",
							["NewDetail"] = "Content__120303_5",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17706264362352316459"] = {
						["key"] = "17706264362352316459",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2202,
							["y"] = 94.2500000000001
						},
						["propsData"] = {
							["NewDescription"] = "Description_120303_6",
							["NewDetail"] = "Content__120303_6",
							["SubTaskTargetIndex"] = 0
						}
					},
					["177267878571812264394"] = {
						["key"] = "177267878571812264394",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1403.2719298245615,
							["y"] = 450.36184210526324
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