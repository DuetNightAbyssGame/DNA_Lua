return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17503346172797036324",
			["startPort"] = "Success",
			["endStory"] = "17503349595987038897",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17503349595987038897",
			["startPort"] = "Success",
			["endStory"] = "17503350347627039938",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17503350347627039938",
			["startPort"] = "Success",
			["endStory"] = "17503351070927041125",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17503351070927041125",
			["startPort"] = "Success",
			["endStory"] = "17503346116567036182",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17503346116567036179",
			["startPort"] = "StoryStart",
			["endStory"] = "17516136605614425",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17516136605614425",
			["startPort"] = "Success",
			["endStory"] = "17503346172797036324",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17503346116567036179"] = {
			["isStoryNode"] = true,
			["key"] = "17503346116567036179",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 781.7070938215103,
				["y"] = 239.26315789473682
			},
			["propsData"] = {
				["QuestChainId"] = 200302
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17503346116567036182"] = {
			["isStoryNode"] = true,
			["key"] = "17503346116567036182",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 3084.2105263157896,
				["y"] = 282.63157894736844
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17503346172797036324"] = {
			["isStoryNode"] = true,
			["key"] = "17503346172797036324",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1685.5526315789473,
				["y"] = 297.67105263157896
			},
			["propsData"] = {
				["QuestId"] = 20030201,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200302_1",
				["QuestDeatil"] = "Content_200302_2",
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_SideZhuXing_2080056",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17503346172797036325",
						["startPort"] = "QuestStart",
						["endQuest"] = "17503346233997036523",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503346233997036523",
						["startPort"] = "Out",
						["endQuest"] = "17503346582607036833",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503346233997036523",
						["startPort"] = "Out",
						["endQuest"] = "17503346813117037057",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503346233997036523",
						["startPort"] = "Out",
						["endQuest"] = "17503348788867037451",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503346813117037057",
						["startPort"] = "Out",
						["endQuest"] = "17503348761037037398",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503348761037037398",
						["startPort"] = "Out",
						["endQuest"] = "17503349185357038461",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503349185357038461",
						["startPort"] = "Out",
						["endQuest"] = "17503346172797036328",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17503346172797036325"] = {
						["key"] = "17503346172797036325",
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
					["17503346172797036328"] = {
						["key"] = "17503346172797036328",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2422.638888888889,
							["y"] = 390
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17503346172797036331"] = {
						["key"] = "17503346172797036331",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17503346233997036523"] = {
						["key"] = "17503346233997036523",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1173.448275862069,
							["y"] = 308.35477453580904
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080056,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_SideZhuXing_2080056"
						}
					},
					["17503346582607036833"] = {
						["key"] = "17503346582607036833",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1517.6666666666667,
							["y"] = 86
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200302/20030203.20030203'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17503346813117037057"] = {
						["key"] = "17503346813117037057",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1515.2931034482758,
							["y"] = 321.83620689655174
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080070,
								2080069
							}
						}
					},
					["17503348761037037398"] = {
						["key"] = "17503348761037037398",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1880.0555555555554,
							["y"] = 336.78303303303306
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2080070,
								2080069
							}
						}
					},
					["17503348788867037451"] = {
						["key"] = "17503348788867037451",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1522.1379310344828,
							["y"] = 507.1034482758621
						},
						["propsData"] = {
							["NewDescription"] = "Description_200302_2",
							["NewDetail"] = "Content_200302_3",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17503349185357038461"] = {
						["key"] = "17503349185357038461",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2175.393589743589,
							["y"] = 355.134188034188
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200302/20030204.20030204'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17503349595987038897"] = {
			["isStoryNode"] = true,
			["key"] = "17503349595987038897",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2075.3661718398566,
				["y"] = 287.12986270022884
			},
			["propsData"] = {
				["QuestId"] = 20030202,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200302_1",
				["QuestDeatil"] = "Content_200302_2",
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
				["StoryGuidePointName"] = "Mechanism_SideZhuXIng_2090848",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17503349595987038898",
						["startPort"] = "QuestStart",
						["endQuest"] = "17503349705657039169",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503349705657039169",
						["startPort"] = "Out",
						["endQuest"] = "17503350133667039481",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503350133667039481",
						["startPort"] = "Out",
						["endQuest"] = "17503349595987038901",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17503350133667039481",
						["startPort"] = "Fail",
						["endQuest"] = "17503349595987038904",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17503349595987038898"] = {
						["key"] = "17503349595987038898",
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
					["17503349595987038901"] = {
						["key"] = "17503349595987038901",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2104,
							["y"] = 396
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17503349595987038904"] = {
						["key"] = "17503349595987038904",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2104,
							["y"] = 556
						},
						["propsData"] = {}
					},
					["17503349705657039169"] = {
						["key"] = "17503349705657039169",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1409.5555555555557,
							["y"] = 385.7777777777778
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2090848,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_SideZhuXIng_2090848"
						}
					},
					["17503350133667039481"] = {
						["key"] = "17503350133667039481",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1755.25,
							["y"] = 386.75
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200302/20030205.20030205'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0.5,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17503350347627039938"] = {
			["isStoryNode"] = true,
			["key"] = "17503350347627039938",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2401.3058929374724,
				["y"] = 283.0695006747639
			},
			["propsData"] = {
				["QuestId"] = 20030203,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200302_3",
				["QuestDeatil"] = "Content_200302_4",
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
				["StoryGuidePointName"] = "Mechanism_Side_ZhuXing_2080078",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17503350347627039943",
						["startPort"] = "QuestStart",
						["endQuest"] = "17503350347627039946",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503350742967040562",
						["startPort"] = "Out",
						["endQuest"] = "17503350347627039944",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17503350347627039946",
						["startPort"] = "Out",
						["endQuest"] = "17503350742967040562",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503350742967040562",
						["startPort"] = "Fail",
						["endQuest"] = "17503350347627039945",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17503350347627039943"] = {
						["key"] = "17503350347627039943",
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
					["17503350347627039944"] = {
						["key"] = "17503350347627039944",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2386,
							["y"] = 396
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17503350347627039945"] = {
						["key"] = "17503350347627039945",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2381.153846153846,
							["y"] = 551.1538461538462
						},
						["propsData"] = {}
					},
					["17503350347627039946"] = {
						["key"] = "17503350347627039946",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1410,
							["y"] = 380
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080078,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Side_ZhuXing_2080078"
						}
					},
					["17503350742967040562"] = {
						["key"] = "17503350742967040562",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1814,
							["y"] = 398
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200302/20030206.20030206'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0.5,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17503351070927041125"] = {
			["isStoryNode"] = true,
			["key"] = "17503351070927041125",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2699.353070175439,
				["y"] = 315.42543859649123
			},
			["propsData"] = {
				["QuestId"] = 20030204,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200302_4",
				["QuestDeatil"] = "Content_200302_5",
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
				["SubRegionId"] = 104108,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_SideZhuXing_2090153",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17503351070937041130",
						["startPort"] = "QuestStart",
						["endQuest"] = "17503351070937041133",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503351070937041133",
						["startPort"] = "Out",
						["endQuest"] = "17503351070937041135",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503352532607042533",
						["startPort"] = "Out",
						["endQuest"] = "17503351070937041131",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17503351070937041133",
						["startPort"] = "Out",
						["endQuest"] = "17503356464148011307",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503351070937041133",
						["startPort"] = "Out",
						["endQuest"] = "17516258607592121",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17516258607592121",
						["startPort"] = "Out",
						["endQuest"] = "17503352415567042273",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503352415567042273",
						["startPort"] = "Out",
						["endQuest"] = "17630319555384018247",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17630319555384018247",
						["startPort"] = "Out",
						["endQuest"] = "17503352532607042533",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17630319555384018247",
						["startPort"] = "Out",
						["endQuest"] = "17632068821251006699",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17503351070937041130"] = {
						["key"] = "17503351070937041130",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 764,
							["y"] = 330
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17503351070937041131"] = {
						["key"] = "17503351070937041131",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2657.241379310345,
							["y"] = 344.48275862068965
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17503351070937041132"] = {
						["key"] = "17503351070937041132",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17503351070937041133"] = {
						["key"] = "17503351070937041133",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1101.25,
							["y"] = 310
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2090153,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_SideZhuXing_2090153"
						}
					},
					["17503351070937041135"] = {
						["key"] = "17503351070937041135",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1444,
							["y"] = 67.6
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200302/20030208.20030208'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17503352415567042273"] = {
						["key"] = "17503352415567042273",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1795.18275862069,
							["y"] = 324.1365900383142
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2090154,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_SideZhuXing_2090154"
						}
					},
					["17503352532607042533"] = {
						["key"] = "17503352532607042533",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2378.4827586206898,
							["y"] = 338.3724137931035
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200302/20030207.20030207'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0.5,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17503356464148011307"] = {
						["key"] = "17503356464148011307",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1440.95,
							["y"] = 589.35
						},
						["propsData"] = {
							["NewDescription"] = "Description_200302_5",
							["NewDetail"] = "Content_200302_6",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17516258607592121"] = {
						["key"] = "17516258607592121",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1424.8441767951751,
							["y"] = 315.6896359236651
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090149,
								2090150,
								2090151,
								2090152,
								2090826,
								2090827,
								2090828,
								2090829
							}
						}
					},
					["17630319555384018247"] = {
						["key"] = "17630319555384018247",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2079.555555555555,
							["y"] = 326.55555555555543
						},
						["propsData"] = {
							["WaitTime"] = 10
						}
					},
					["17632068821251006699"] = {
						["key"] = "17632068821251006699",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2373.875,
							["y"] = 168.87499999999991
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "SetTOD_0",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17516136605614425"] = {
			["isStoryNode"] = true,
			["key"] = "17516136605614425",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 1225.7414187643021,
				["y"] = 268.906941266209
			},
			["propsData"] = {
				["QuestId"] = 20030200,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 104110,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_ZhaoQian_2110111",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1751613708014948956",
						["startPort"] = "Out",
						["endQuest"] = "1751613708014948957",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1751613708014948957",
						["startPort"] = "ApproveOut",
						["endQuest"] = "1751613708014948958",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751613708014948957",
						["startPort"] = "CancelOut",
						["endQuest"] = "17516136605614437",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17516136605614426",
						["startPort"] = "QuestStart",
						["endQuest"] = "17518719703685675299",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751613708014948958",
						["startPort"] = "Out",
						["endQuest"] = "17518719966075675953",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17518719966075675953",
						["startPort"] = "Out",
						["endQuest"] = "17516136605614429",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17518719703685675299",
						["startPort"] = "Out",
						["endQuest"] = "17518721908916621345",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17518721908916621345",
						["startPort"] = "Out",
						["endQuest"] = "1751613708014948956",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17516136605614426"] = {
						["key"] = "17516136605614426",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 380.80219780219784,
							["y"] = 591.2719780219779
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17516136605614429"] = {
						["key"] = "17516136605614429",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2651.4285714285716,
							["y"] = 470.85714285714283
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17516136605614437"] = {
						["key"] = "17516136605614437",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2286.2608695652175,
							["y"] = 728.7826086956521
						},
						["propsData"] = {}
					},
					["1751613708014948956"] = {
						["key"] = "1751613708014948956",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1276.041666666666,
							["y"] = 618.3068181818182
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200302/20030201.20030201'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1751613708014948957"] = {
						["key"] = "1751613708014948957",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1611.041666666666,
							["y"] = 595.5568181818182
						},
						["propsData"] = {
							["SideQuestChainId"] = 200302,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["1751613708014948958"] = {
						["key"] = "1751613708014948958",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1965.567028985508,
							["y"] = 538.5301383399209
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200302/20030202.20030202'",
							["TalkType"] = "QuestImpression",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17518719703685675299"] = {
						["key"] = "17518719703685675299",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 660.6883318312681,
							["y"] = 590.8797480842844
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110114
							}
						}
					},
					["17518719966075675953"] = {
						["key"] = "17518719966075675953",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2289.5345855775217,
							["y"] = 485.692385446922
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110114
							}
						}
					},
					["17518721908916621345"] = {
						["key"] = "17518721908916621345",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 968.1060141489504,
							["y"] = 598.1923854469221
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11032,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}