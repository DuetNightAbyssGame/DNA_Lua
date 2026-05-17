return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17505692486902929143",
			["startPort"] = "Success",
			["endStory"] = "17505702619912930974",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17505702619912930974",
			["startPort"] = "Success",
			["endStory"] = "17505712518582933667",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17505712518582933667",
			["startPort"] = "Success",
			["endStory"] = "17505713472352934668",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17505713472352934668",
			["startPort"] = "Success",
			["endStory"] = "17505692470962929079",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17505692470962929076",
			["startPort"] = "StoryStart",
			["endStory"] = "17514435175261242",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17514435175261242",
			["startPort"] = "Success",
			["endStory"] = "17505692486902929143",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17505692470962929076"] = {
			["isStoryNode"] = true,
			["key"] = "17505692470962929076",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 802,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 200303
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17505692470962929079"] = {
			["isStoryNode"] = true,
			["key"] = "17505692470962929079",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 3054.3478260869565,
				["y"] = 289.5652173913044
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17505692486902929143"] = {
			["isStoryNode"] = true,
			["key"] = "17505692486902929143",
			["type"] = "StoryNode",
			["name"] = "沉船附近调查，拾取交互点",
			["pos"] = {
				["x"] = 1428.4292803970225,
				["y"] = 284.1861042183623
			},
			["propsData"] = {
				["QuestId"] = 20030301,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200303_1",
				["QuestDeatil"] = "Content_200303_1",
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
				["SubRegionId"] = 104109,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "BP_Side_TongBi",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17505692486902929144",
						["startPort"] = "QuestStart",
						["endQuest"] = "17505699883912929503",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505692486902929144",
						["startPort"] = "QuestStart",
						["endQuest"] = "17505700077462929732",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505700077462929732",
						["startPort"] = "Out",
						["endQuest"] = "17505700214392929974",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505700214392929974",
						["startPort"] = "Out",
						["endQuest"] = "1760511374676984329",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760511374676984329",
						["startPort"] = "Out",
						["endQuest"] = "17505692486902929147",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17505700214392929974",
						["startPort"] = "Out",
						["endQuest"] = "17611230341161979387",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505700214392929974",
						["startPort"] = "Out",
						["endQuest"] = "17619025259814087740",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17505692486902929144"] = {
						["key"] = "17505692486902929144",
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
					["17505692486902929147"] = {
						["key"] = "17505692486902929147",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2366.8,
							["y"] = 388.8
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17505692486902929150"] = {
						["key"] = "17505692486902929150",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17505699883912929503"] = {
						["key"] = "17505699883912929503",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1205.9380341880342,
							["y"] = 155.96581196581195
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_Side_TongBi"
						}
					},
					["17505700077462929732"] = {
						["key"] = "17505700077462929732",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1195.7451215451215,
							["y"] = 369.69157117392405
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2100065
							}
						}
					},
					["17505700214392929974"] = {
						["key"] = "17505700214392929974",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1538.394694194694,
							["y"] = 375.4608019431549
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11029,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["1760511374676984329"] = {
						["key"] = "1760511374676984329",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1870.4571428571426,
							["y"] = 393.37142857142857
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700322,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_RenWu20030300_2100181",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51102025,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20030300",
							["BlendInTime"] = 0,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700322,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700363,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17611230341161979387"] = {
						["key"] = "17611230341161979387",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1862.4285714285713,
							["y"] = 248.9999999999999
						},
						["propsData"] = {
							["NewDescription"] = "Description_200303_7",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17619025259814087740"] = {
						["key"] = "17619025259814087740",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1877.6000000000001,
							["y"] = 56
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_Side_TongBi"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17505702619912930974"] = {
			["isStoryNode"] = true,
			["key"] = "17505702619912930974",
			["type"] = "StoryNode",
			["name"] = "再次调查，第一轮战斗",
			["pos"] = {
				["x"] = 1830.0751588152793,
				["y"] = 272.5827267361795
			},
			["propsData"] = {
				["QuestId"] = 20030302,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200303_2",
				["QuestDeatil"] = "Content_200303_2",
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
				["SubRegionId"] = 104105,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_Side_DaFeng_2060103",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17505702619912930979",
						["startPort"] = "QuestStart",
						["endQuest"] = "17505705818742931477",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505705818742931477",
						["startPort"] = "Out",
						["endQuest"] = "17505710078662932296",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505710078662932296",
						["startPort"] = "Out",
						["endQuest"] = "17505709821102931855",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505709821102931855",
						["startPort"] = "Out",
						["endQuest"] = "17505709948792932064",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505705818742931477",
						["startPort"] = "Out",
						["endQuest"] = "17505710482552933177",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505710078662932296",
						["startPort"] = "Out",
						["endQuest"] = "17505710177262932713",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605152780872951205",
						["startPort"] = "Out",
						["endQuest"] = "17505702619912930980",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17605176950729830660",
						["startPort"] = "Out",
						["endQuest"] = "17605176950729830661",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505709948792932064",
						["startPort"] = "Out",
						["endQuest"] = "17611255092683954983",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611255092683954983",
						["startPort"] = "Out",
						["endQuest"] = "17605152780872951205",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17505702619912930979"] = {
						["key"] = "17505702619912930979",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 431.6959064327485,
							["y"] = 317.5438596491228
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17505702619912930980"] = {
						["key"] = "17505702619912930980",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2366.8,
							["y"] = 388.8
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17505702619912930981"] = {
						["key"] = "17505702619912930981",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17505705818742931477"] = {
						["key"] = "17505705818742931477",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 838.5941543836279,
							["y"] = 310.55931746272296
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2060103,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Side_DaFeng_2060103"
						}
					},
					["17505709821102931855"] = {
						["key"] = "17505709821102931855",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1360.1324203383701,
							["y"] = 372.5705048514847
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060133,
								2060134
							}
						}
					},
					["17505709948792932064"] = {
						["key"] = "17505709948792932064",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1597.7881538751105,
							["y"] = 373.52397548458924
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2060133,
								2060134
							}
						}
					},
					["17505710078662932296"] = {
						["key"] = "17505710078662932296",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1120.5239789450316,
							["y"] = 347.0505455328984
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102033,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20030302",
							["BlendInTime"] = 0.5,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700363,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210087,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17505710177262932713"] = {
						["key"] = "17505710177262932713",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1432.278364909944,
							["y"] = 112.43066249196272
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102037,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17505710482552933177"] = {
						["key"] = "17505710482552933177",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1089.2374292374295,
							["y"] = 620.3838788662317
						},
						["propsData"] = {
							["NewDescription"] = "Description_200303_3",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17605152780872951205"] = {
						["key"] = "17605152780872951205",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2074.4204416273383,
							["y"] = 386.12780323125145
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102039,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20030302",
							["BlendInTime"] = 0,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700363,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17605176950729830660"] = {
						["key"] = "17605176950729830660",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1751.560744620241,
							["y"] = 63.580207740390904
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060133,
								2060134,
								2060135,
								2060136,
								2060137
							}
						}
					},
					["17605176950729830661"] = {
						["key"] = "17605176950729830661",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物（5只）",
						["pos"] = {
							["x"] = 1989.2164781569813,
							["y"] = 64.53367837349543
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2060133,
								2060134,
								2060135,
								2060136,
								2060137
							}
						}
					},
					["17611255092683954983"] = {
						["key"] = "17611255092683954983",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1833.3300492610838,
							["y"] = 386.0689655172413
						},
						["propsData"] = {
							["WaitTime"] = 2.5
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17505712518582933667"] = {
			["isStoryNode"] = true,
			["key"] = "17505712518582933667",
			["type"] = "StoryNode",
			["name"] = "前往另一地点，第二场战斗",
			["pos"] = {
				["x"] = 2175.7391304347825,
				["y"] = 259.3913043478261
			},
			["propsData"] = {
				["QuestId"] = 20030303,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200303_4",
				["QuestDeatil"] = "Content_200303_4",
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
				["SubRegionId"] = 104105,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_SideDaFeng_2060104",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17505712518592933675",
						["startPort"] = "Out",
						["endQuest"] = "17505712518592933673",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17505712518582933672",
						["startPort"] = "QuestStart",
						["endQuest"] = "17505712518592933676",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505712518592933677",
						["startPort"] = "Out",
						["endQuest"] = "17505712518592933678",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505712518592933676",
						["startPort"] = "Out",
						["endQuest"] = "17505712518592933681",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505712518592933676",
						["startPort"] = "Out",
						["endQuest"] = "17505712518592933677",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176051782207810813178",
						["startPort"] = "Out",
						["endQuest"] = "176051782207810813179",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505712518592933678",
						["startPort"] = "Out",
						["endQuest"] = "17611255269953955521",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611255269953955521",
						["startPort"] = "Out",
						["endQuest"] = "17505712518592933675",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17505712518582933672"] = {
						["key"] = "17505712518582933672",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 602.2222222222222,
							["y"] = 303.3333333333333
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17505712518592933673"] = {
						["key"] = "17505712518592933673",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2366.8,
							["y"] = 388.8
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17505712518592933674"] = {
						["key"] = "17505712518592933674",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17505712518592933675"] = {
						["key"] = "17505712518592933675",
						["type"] = "TalkNode",
						["name"] = "战斗后对话节点",
						["pos"] = {
							["x"] = 2119.8147517940997,
							["y"] = 376.5174491003456
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102043,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20030304",
							["BlendInTime"] = 0,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700322,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700363,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700364,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17505712518592933676"] = {
						["key"] = "17505712518592933676",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 841.5369461456417,
							["y"] = 309.80416872130417
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2060104,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_SideDaFeng_2060104"
						}
					},
					["17505712518592933677"] = {
						["key"] = "17505712518592933677",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1342.7639992857385,
							["y"] = 380.19064215125593
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060074,
								2060075
							}
						}
					},
					["17505712518592933678"] = {
						["key"] = "17505712518592933678",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1593.8751103968498,
							["y"] = 374.8283233106762
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2060074,
								2060075
							}
						}
					},
					["17505712518592933681"] = {
						["key"] = "17505712518592933681",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1091.2374292374295,
							["y"] = 618.3838788662317
						},
						["propsData"] = {
							["NewDescription"] = "Description_200303_5",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176051782207810813178"] = {
						["key"] = "176051782207810813178",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1393.422222222222,
							["y"] = 146.68115942028982
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060074,
								2060075,
								2060076,
								2060077,
								2060073
							}
						}
					},
					["176051782207810813179"] = {
						["key"] = "176051782207810813179",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物5只",
						["pos"] = {
							["x"] = 1644.5333333333333,
							["y"] = 141.31884057971007
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2060074,
								2060075,
								2060076,
								2060077,
								2060073
							}
						}
					},
					["17611255269953955521"] = {
						["key"] = "17611255269953955521",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1852.4615384615386,
							["y"] = 386.75824175824175
						},
						["propsData"] = {
							["WaitTime"] = 2.5
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17505713472352934668"] = {
			["isStoryNode"] = true,
			["key"] = "17505713472352934668",
			["type"] = "StoryNode",
			["name"] = "触碰宝箱三次，对话",
			["pos"] = {
				["x"] = 2512.2173913043475,
				["y"] = 250.27717391304347
			},
			["propsData"] = {
				["QuestId"] = 20030304,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200303_6",
				["QuestDeatil"] = "Content_200303_5",
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
				["SubRegionId"] = 104105,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "BP_Side_BaoXiang2",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17505715930052935020",
						["startPort"] = "Out",
						["endQuest"] = "17505716584502935299",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505717355902936080",
						["startPort"] = "Out",
						["endQuest"] = "17505717355902936081",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505717361842936112",
						["startPort"] = "Out",
						["endQuest"] = "17505717361842936113",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505716584502935299",
						["startPort"] = "Out",
						["endQuest"] = "17505717959972937236",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505717355902936081",
						["startPort"] = "Out",
						["endQuest"] = "17505717997282937369",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505718035642937505",
						["startPort"] = "Out",
						["endQuest"] = "17605154818543934118",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505713472352934669",
						["startPort"] = "QuestStart",
						["endQuest"] = "17605175262186882455",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505713472352934669",
						["startPort"] = "QuestStart",
						["endQuest"] = "17505717775592936921",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605175262186882455",
						["startPort"] = "Out",
						["endQuest"] = "17505715930052935020",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505716584502935299",
						["startPort"] = "Out",
						["endQuest"] = "17505717355902936080",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505717355902936081",
						["startPort"] = "Out",
						["endQuest"] = "17505717361842936112",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17505717361842936113",
						["startPort"] = "Out",
						["endQuest"] = "17505718035642937505",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605154818543934118",
						["startPort"] = "Out",
						["endQuest"] = "17623306828665146904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623306828665146904",
						["startPort"] = "Out",
						["endQuest"] = "17505713472352934672",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17505713472352934669"] = {
						["key"] = "17505713472352934669",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 475.8064516129032,
							["y"] = 290.3225806451613
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17505713472352934672"] = {
						["key"] = "17505713472352934672",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4545.222672064777,
							["y"] = 386.3562753036437
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17505713472352934675"] = {
						["key"] = "17505713472352934675",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4451.578947368421,
							["y"] = 564.2105263157895
						},
						["propsData"] = {}
					},
					["17505715930052935020"] = {
						["key"] = "17505715930052935020",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1118.8978328173375,
							["y"] = 304.99690402476784
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060079
							}
						}
					},
					["17505716584502935299"] = {
						["key"] = "17505716584502935299",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1435.1305125558997,
							["y"] = 307.2321981424148
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11030,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_chest20030304_2060144",
							["IsUseCount"] = false
						}
					},
					["17505717355902936080"] = {
						["key"] = "17505717355902936080",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2038.8204334365323,
							["y"] = 291.39318885448915
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060079
							}
						}
					},
					["17505717355902936081"] = {
						["key"] = "17505717355902936081",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 2320.5851393188855,
							["y"] = 320.09907120743026
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11030,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_chest20030304_2060144",
							["IsUseCount"] = false
						}
					},
					["17505717361842936112"] = {
						["key"] = "17505717361842936112",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3033,
							["y"] = 346.37770897832826
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060079
							}
						}
					},
					["17505717361842936113"] = {
						["key"] = "17505717361842936113",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 3357.1176470588234,
							["y"] = 332.73065015479864
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11030,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_chest20030304_2060144",
							["IsUseCount"] = false
						}
					},
					["17505717775592936921"] = {
						["key"] = "17505717775592936921",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1100.341683084717,
							["y"] = 114.47818744722757
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102062,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17505717959972937236"] = {
						["key"] = "17505717959972937236",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1735.871094849423,
							["y"] = 52.18037741412358
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102063,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17505717997282937369"] = {
						["key"] = "17505717997282937369",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2592.8088938924852,
							["y"] = 152.73061664857335
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102064,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17505718035642937505"] = {
						["key"] = "17505718035642937505",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3757.3516474038292,
							["y"] = 330.57769953173437
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102065,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17605154818543934118"] = {
						["key"] = "17605154818543934118",
						["type"] = "TalkNode",
						["name"] = "战斗后对话节点",
						["pos"] = {
							["x"] = 4054.3333333333335,
							["y"] = 366.6666666666664
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102066,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20030304",
							["BlendInTime"] = 0.5,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700322,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700363,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700364,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17605175262186882455"] = {
						["key"] = "17605175262186882455",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成宝箱和壬午",
						["pos"] = {
							["x"] = 802.824116743472,
							["y"] = 308.44470046082904
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060147,
								2060144
							}
						}
					},
					["17623306828665146904"] = {
						["key"] = "17623306828665146904",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁宝箱和壬午",
						["pos"] = {
							["x"] = 4304.54048582996,
							["y"] = 239.39068825910897
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060147,
								2060144
							}
						}
					}
				},
				["commentData"] = {
					["17603395813855838094"] = {
						["key"] = "17603395813855838094",
						["name"] = "与宝箱第一次交互",
						["position"] = {
							["x"] = 1058.5751898559113,
							["y"] = -164.70277868584589
						},
						["size"] = {
							["width"] = 922.1052631578948,
							["height"] = 707.3684210526316
						}
					},
					["17603396051875838611"] = {
						["key"] = "17603396051875838611",
						["name"] = "与宝箱第二次交互",
						["position"] = {
							["x"] = 2012.2594003822269,
							["y"] = -109.43962079110898
						},
						["size"] = {
							["width"] = 980.5263157894739,
							["height"] = 658.421052631579
						}
					},
					["17603396442585839535"] = {
						["key"] = "17603396442585839535",
						["name"] = "与宝箱第三次交互",
						["position"] = {
							["x"] = 3021.2067688032794,
							["y"] = -104.7027786858456
						},
						["size"] = {
							["width"] = 988.0689608434179,
							["height"] = 682.1797372111909
						}
					}
				}
			}
		},
		["17514435175261242"] = {
			["isStoryNode"] = true,
			["key"] = "17514435175261242",
			["type"] = "PreStoryNode",
			["name"] = "微茫市，与壬午对话接取任务",
			["pos"] = {
				["x"] = 1114.114409141583,
				["y"] = 304.41604924442436
			},
			["propsData"] = {
				["QuestId"] = 20030300,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 104109,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_RenWu_2100064",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17514435397571999",
						["startPort"] = "Out",
						["endQuest"] = "17514435397572000",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17514435397572000",
						["startPort"] = "ApproveOut",
						["endQuest"] = "17514435397572001",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17514435397572001",
						["startPort"] = "Out",
						["endQuest"] = "17514435175261246",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17514435397572000",
						["startPort"] = "CancelOut",
						["endQuest"] = "17514435175261254",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17514435175261243",
						["startPort"] = "QuestStart",
						["endQuest"] = "17514435397571999",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17514435175261243"] = {
						["key"] = "17514435175261243",
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
					["17514435175261246"] = {
						["key"] = "17514435175261246",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2187.727272727273,
							["y"] = 290.4545454545455
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17514435175261254"] = {
						["key"] = "17514435175261254",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2075.909090909091,
							["y"] = 537.7272727272727
						},
						["propsData"] = {}
					},
					["17514435397571999"] = {
						["key"] = "17514435397571999",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1160.3235619453008,
							["y"] = 266.7747833688051
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700322,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_RenWu20030300_2100181",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51102001,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20030300",
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700322,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700363,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17514435397572000"] = {
						["key"] = "17514435397572000",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1533.596289218028,
							["y"] = 268.1384197324415
						},
						["propsData"] = {
							["SideQuestChainId"] = 200303,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["17514435397572001"] = {
						["key"] = "17514435397572001",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1890.403710781972,
							["y"] = 278.49794390392213
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51102012,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20030300",
							["BlendInTime"] = 0,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700363,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700322,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
							["SwitchToMaster"] = "Player",
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
		}
	},
	["commentData"] = {}
}