return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1750230312164806",
			["startPort"] = "Success",
			["endStory"] = "17515246631939466277",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17515246631939466277",
			["startPort"] = "Success",
			["endStory"] = "17515243582307575562",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17515243582307575562",
			["startPort"] = "Success",
			["endStory"] = "1751534892992835",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1751534892992835",
			["startPort"] = "Success",
			["endStory"] = "1750142619591948742",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1750142619591948739",
			["startPort"] = "StoryStart",
			["endStory"] = "1762829834328336135",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1762829834328336135",
			["startPort"] = "Success",
			["endStory"] = "1750230312164806",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["1750142619591948739"] = {
			["isStoryNode"] = true,
			["key"] = "1750142619591948739",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 627.2383655370957,
				["y"] = 391.54510860019906
			},
			["propsData"] = {
				["QuestChainId"] = 200301
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1750142619591948742"] = {
			["isStoryNode"] = true,
			["key"] = "1750142619591948742",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2594.586956521739,
				["y"] = 365.0217391304348
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1750230312164806"] = {
			["isStoryNode"] = true,
			["key"] = "1750230312164806",
			["type"] = "StoryNode",
			["name"] = "前往",
			["pos"] = {
				["x"] = 1279.85008380123,
				["y"] = 387.7053852175075
			},
			["propsData"] = {
				["QuestId"] = 20030101,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200301_1",
				["QuestDeatil"] = "Content_200301_4",
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
				["SubRegionId"] = 104105,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_Side_God_2060081",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1750230312164807",
						["startPort"] = "QuestStart",
						["endQuest"] = "17515229661404743740",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17515229661404743740",
						["startPort"] = "Out",
						["endQuest"] = "17502304036541596",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17635386930414381650",
						["startPort"] = "Out",
						["endQuest"] = "17635386930414381651",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17515229661404743740",
						["startPort"] = "Out",
						["endQuest"] = "17635386930414381650",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17635386930414381650",
						["startPort"] = "Out",
						["endQuest"] = "1750230312165810",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1750230312164807"] = {
						["key"] = "1750230312164807",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 261,
							["y"] = 305.7857142857143
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1750230312165810"] = {
						["key"] = "1750230312165810",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1356.51548579298,
							["y"] = 300.58765766472055
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1750230312165813"] = {
						["key"] = "1750230312165813",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1374.4487818010498,
							["y"] = 607.8032036613272
						},
						["propsData"] = {}
					},
					["17502304036541596"] = {
						["key"] = "17502304036541596",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 1045.3954545454544,
							["y"] = -15.977272727272776
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200301/20030102.20030102'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17515229661404743740"] = {
						["key"] = "17515229661404743740",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 641.4642857142857,
							["y"] = 307.8928571428571
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2060081,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Side_God_2060081"
						}
					},
					["17515245489808521433"] = {
						["key"] = "17515245489808521433",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1024.6735328878956,
							["y"] = 610.0619576681228
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060082
							}
						}
					},
					["17635386930414381650"] = {
						["key"] = "17635386930414381650",
						["type"] = "GoToNode",
						["name"] = "前往污秽之地边缘",
						["pos"] = {
							["x"] = 1046.7821498620733,
							["y"] = 308.8505687280218
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2060080,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_SideGod_2060080"
						}
					},
					["17635386930414381651"] = {
						["key"] = "17635386930414381651",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1349.9790808083649,
							["y"] = -1.9669524833612968
						},
						["propsData"] = {
							["NewDescription"] = "Description_200301_5",
							["NewDetail"] = "Content_200301_6",
							["SubTaskTargetIndex"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17514248151166350500"] = {
			["isStoryNode"] = true,
			["key"] = "17514248151166350500",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 981.4699248120303,
				["y"] = 124.36139261196473
			},
			["propsData"] = {
				["QuestId"] = 20030100,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 104109,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Side_LaoZhe_2100066",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17514248469846351623",
						["startPort"] = "ApproveOut",
						["endQuest"] = "17514248151166350504",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17514248469846351623",
						["startPort"] = "CancelOut",
						["endQuest"] = "17514248151166350512",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17514248151166350501",
						["startPort"] = "QuestStart",
						["endQuest"] = "17514248469846351626",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17514248469846351626",
						["startPort"] = "Out",
						["endQuest"] = "17514248469846351623",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17514248469846351626",
						["startPort"] = "Fail",
						["endQuest"] = "17514248151166350512",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17514248151166350501"] = {
						["key"] = "17514248151166350501",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1159.3939393939395,
							["y"] = 197.3320158102767
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17514248151166350504"] = {
						["key"] = "17514248151166350504",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2225.909090909091,
							["y"] = 128.18181818181816
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17514248151166350512"] = {
						["key"] = "17514248151166350512",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2200,
							["y"] = 375.45454545454544
						},
						["propsData"] = {}
					},
					["17514248469846351623"] = {
						["key"] = "17514248469846351623",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1899.0019841269843,
							["y"] = 75.29872758820136
						},
						["propsData"] = {
							["SideQuestChainId"] = 200301,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["17514248469846351626"] = {
						["key"] = "17514248469846351626",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1476.1559065934064,
							["y"] = 136.8419433827043
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700319,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Side_LaoZhe_2100066",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200301/20030101.20030101'",
							["TalkType"] = "Impression",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17515243582307575562"] = {
			["isStoryNode"] = true,
			["key"] = "17515243582307575562",
			["type"] = "StoryNode",
			["name"] = "战斗",
			["pos"] = {
				["x"] = 1909.6990219532788,
				["y"] = 395.2938713763018
			},
			["propsData"] = {
				["QuestId"] = 20030103,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200301_2",
				["QuestDeatil"] = "Content_200301_7",
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
				["StoryGuidePointName"] = "Mechanism_SideGod_2060357",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17515243759747576217",
						["startPort"] = "Out",
						["endQuest"] = "17515243759747576219",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17515243759747576217",
						["startPort"] = "Out",
						["endQuest"] = "17515243759747576220",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17515243759747576219",
						["startPort"] = "Out",
						["endQuest"] = "17515317888515665046",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17515317888515665046",
						["startPort"] = "Out",
						["endQuest"] = "17515243582307575566",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17515243582307575563",
						["startPort"] = "QuestStart",
						["endQuest"] = "17639747944593089120",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17639747944593089120",
						["startPort"] = "Out",
						["endQuest"] = "17515243759747576217",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17515243582307575563"] = {
						["key"] = "17515243582307575563",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 994.2882117882119,
							["y"] = 317.7422577422577
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17515243582307575566"] = {
						["key"] = "17515243582307575566",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2538.1730769230767,
							["y"] = 350.15109890109886
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17515243582307575569"] = {
						["key"] = "17515243582307575569",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2540.12987012987,
							["y"] = 579.4155844155844
						},
						["propsData"] = {}
					},
					["17515243759747576217"] = {
						["key"] = "17515243759747576217",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1614.526579827495,
							["y"] = 325.2266505892977
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060058,
								2060059,
								2060060
							}
						}
					},
					["17515243759747576219"] = {
						["key"] = "17515243759747576219",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1925.6890183707192,
							["y"] = 336.6681298673831
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 3,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2060058,
								2060059,
								2060060
							}
						}
					},
					["17515243759747576220"] = {
						["key"] = "17515243759747576220",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1920.7671170163092,
							["y"] = 105.73254239163424
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200301/20030104.20030104'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17515317888515665046"] = {
						["key"] = "17515317888515665046",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2211.977583057674,
							["y"] = 345.3313909583933
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17639747944593089120"] = {
						["key"] = "17639747944593089120",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1302.8277790310058,
							["y"] = 324.0788814465883
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2060357,
							["GuideType"] = "N",
							["GuidePointName"] = "Mechanism_SideGod_2060357"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17515246631939466277"] = {
			["isStoryNode"] = true,
			["key"] = "17515246631939466277",
			["type"] = "StoryNode",
			["name"] = "交互对话",
			["pos"] = {
				["x"] = 1618.2699948400414,
				["y"] = 389.5288527691781
			},
			["propsData"] = {
				["QuestId"] = 20030104,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200301_5",
				["QuestDeatil"] = "Content_200301_6",
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
				["StoryGuidePointName"] = "Mechanism_SideGod_2060080",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17515246843939467074",
						["startPort"] = "Out",
						["endQuest"] = "17515246631939466281",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17629530522333361",
						["startPort"] = "Out",
						["endQuest"] = "17515246843939467073",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17515246895699467312",
						["startPort"] = "Out",
						["endQuest"] = "17515247153199468125",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17515246843939467073",
						["startPort"] = "Out",
						["endQuest"] = "1763536889293339551",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763536889293339551",
						["startPort"] = "Out",
						["endQuest"] = "17515246843939467074",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17515246843939467073",
						["startPort"] = "Fail",
						["endQuest"] = "17515246631939466284",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17515246631939466278",
						["startPort"] = "QuestStart",
						["endQuest"] = "17629530522333361",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17515246631939466278"] = {
						["key"] = "17515246631939466278",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 553.7198067632851,
							["y"] = 319.04347826086956
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17515246631939466281"] = {
						["key"] = "17515246631939466281",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2028,
							["y"] = 370
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17515246631939466284"] = {
						["key"] = "17515246631939466284",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2022.142857142857,
							["y"] = 550
						},
						["propsData"] = {}
					},
					["17515246843939467073"] = {
						["key"] = "17515246843939467073",
						["type"] = "TalkNode",
						["name"] = "这地方荒无人烟",
						["pos"] = {
							["x"] = 1228.1931696166114,
							["y"] = 327.9828364397451
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700319,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Side_LaoZhe_2060082",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200301/20030103.20030103'",
							["TalkType"] = "Impression",
							["BlendInTime"] = 1,
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
					["17515246843939467074"] = {
						["key"] = "17515246843939467074",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1772.0655182437595,
							["y"] = 338.4547512180388
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060082
							}
						}
					},
					["17515246895699467312"] = {
						["key"] = "17515246895699467312",
						["type"] = "GoToNode",
						["name"] = "前往污秽之地边缘",
						["pos"] = {
							["x"] = 616.1214630779847,
							["y"] = -6.951000690131224
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2060080,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_SideGod_2060080"
						}
					},
					["17515247153199468125"] = {
						["key"] = "17515247153199468125",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 908.7301587301586,
							["y"] = -0.12146307798489886
						},
						["propsData"] = {
							["NewDescription"] = "Description_200301_5",
							["NewDetail"] = "Content_200301_6",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17629530522333361"] = {
						["key"] = "17629530522333361",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 937.7487922705316,
							["y"] = 321.54589371980677
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2060082
							}
						}
					},
					["1763536889293339551"] = {
						["key"] = "1763536889293339551",
						["type"] = "TalkNode",
						["name"] = "刻舟出场站桩",
						["pos"] = {
							["x"] = 1509.8555956276855,
							["y"] = 328.2024032146753
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200301/20030106.20030106'",
							["TalkType"] = "Impression",
							["BlendInTime"] = 1,
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1751534892992835"] = {
			["isStoryNode"] = true,
			["key"] = "1751534892992835",
			["type"] = "StoryNode",
			["name"] = "站桩",
			["pos"] = {
				["x"] = 2226.5442890442896,
				["y"] = 399.09236596736605
			},
			["propsData"] = {
				["QuestId"] = 20030106,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200301_5",
				["QuestDeatil"] = "Content_200301_3",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_SideGod_2060080",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1751534892992848",
						["startPort"] = "Out",
						["endQuest"] = "1751534892992841",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1751534892992840",
						["startPort"] = "QuestStart",
						["endQuest"] = "1751534892992848",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1751534892992840"] = {
						["key"] = "1751534892992840",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2090.3076923076924,
							["y"] = 365.84615384615387
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1751534892992841"] = {
						["key"] = "1751534892992841",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2823.1730769230767,
							["y"] = 338.3653846153846
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1751534892992842"] = {
						["key"] = "1751534892992842",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1751534892992848"] = {
						["key"] = "1751534892992848",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2450.7138467939385,
							["y"] = 354.15007227707446
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 51100104,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200301/20030105.20030105'",
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
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700319,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700318,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = true,
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
		},
		["1762829834328336135"] = {
			["isStoryNode"] = true,
			["key"] = "1762829834328336135",
			["type"] = "StoryNode",
			["name"] = "交互对话",
			["pos"] = {
				["x"] = 937.9053020482239,
				["y"] = 393.8253887762001
			},
			["propsData"] = {
				["QuestId"] = 20030100,
				["QuestDescriptionComment"] = "交互NPC对话",
				["QuestDescription"] = "Description_200301_5",
				["QuestDeatil"] = "Content_200301_1",
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
				["SubRegionId"] = 104109,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Side_LaoZhe_2100066",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1762829834328336136",
						["startPort"] = "QuestStart",
						["endQuest"] = "17628719835271109",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628719835271109",
						["startPort"] = "Out",
						["endQuest"] = "1762829885062337029",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762829885062337029",
						["startPort"] = "Out",
						["endQuest"] = "17628719943941280",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628719943941280",
						["startPort"] = "Out",
						["endQuest"] = "1762829834328336139",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1762829885062337029",
						["startPort"] = "Fail",
						["endQuest"] = "1762829834328336142",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1762829834328336136"] = {
						["key"] = "1762829834328336136",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 688.7096774193549,
							["y"] = 298.06451612903226
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1762829834328336139"] = {
						["key"] = "1762829834328336139",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1789.2302558398221,
							["y"] = 311.92880978865406
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1762829834328336142"] = {
						["key"] = "1762829834328336142",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1787.258064516129,
							["y"] = 529.5564516129033
						},
						["propsData"] = {}
					},
					["1762829885062337029"] = {
						["key"] = "1762829885062337029",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1265.225806451613,
							["y"] = 309.2903225806452
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700319,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Side_LaoZhe_2100066",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200301/20030101.20030101'",
							["TalkType"] = "Impression",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
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
					["17628719835271109"] = {
						["key"] = "17628719835271109",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 961.8709677419354,
							["y"] = 303.4541096574454
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Npc_Side_LaoZhe_2100066",
							["StaticCreatorIdList"] = {
								2100066
							}
						}
					},
					["17628719943941280"] = {
						["key"] = "17628719943941280",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1527.9999999999998,
							["y"] = 310.2283032058324
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "Npc_Side_LaoZhe_2100066",
							["StaticCreatorIdList"] = {
								2100066
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