return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "176637117884849",
			["startPort"] = "StoryStart",
			["endStory"] = "17663717049711312",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17663717049711312",
			["startPort"] = "Success",
			["endStory"] = "1766373374093710194",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1766386007987714893",
			["startPort"] = "Success",
			["endStory"] = "176637117884852",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1766373374093710194",
			["startPort"] = "Success",
			["endStory"] = "17682003679212000",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17682003679212000",
			["startPort"] = "Success",
			["endStory"] = "1766386007987714893",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["176637117884849"] = {
			["isStoryNode"] = true,
			["key"] = "176637117884849",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 942,
				["y"] = 326
			},
			["propsData"] = {
				["QuestChainId"] = 200311
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176637117884852"] = {
			["isStoryNode"] = true,
			["key"] = "176637117884852",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2429.119458128079,
				["y"] = 323.6268472906404
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17663717049711312"] = {
			["isStoryNode"] = true,
			["key"] = "17663717049711312",
			["type"] = "StoryNode",
			["name"] = "创建NPC",
			["pos"] = {
				["x"] = 1224.0244269541436,
				["y"] = 314.1889946515077
			},
			["propsData"] = {
				["QuestId"] = 20031100,
				["QuestDescriptionComment"] = "创建NPC",
				["QuestDescription"] = "Description_200311_1",
				["QuestDeatil"] = "Content_200311_1",
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
				["SubRegionId"] = 104110,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Yang_2110235",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17663717049711313",
						["startPort"] = "QuestStart",
						["endQuest"] = "1766373316321709134",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766373316321709134",
						["startPort"] = "Out",
						["endQuest"] = "17663717049711316",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17663717049711313"] = {
						["key"] = "17663717049711313",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 815,
							["y"] = 294.2307692307692
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17663717049711316"] = {
						["key"] = "17663717049711316",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1583.8461538461538,
							["y"] = 292.6442307692308
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17663717049711319"] = {
						["key"] = "17663717049711319",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1766373316321709134"] = {
						["key"] = "1766373316321709134",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "放出杨父、小杨",
						["pos"] = {
							["x"] = 1180.9178634664568,
							["y"] = 293.39053976713825
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110235,
								2110236
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1766373374093710194"] = {
			["isStoryNode"] = true,
			["key"] = "1766373374093710194",
			["type"] = "StoryNode",
			["name"] = "杨二人对话",
			["pos"] = {
				["x"] = 1539.5224681446966,
				["y"] = 309.6979905546899
			},
			["propsData"] = {
				["QuestId"] = 20031101,
				["QuestDescriptionComment"] = "交互对话",
				["QuestDescription"] = "Description_200311_1",
				["QuestDeatil"] = "Content_200311_1",
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
				["SubRegionId"] = 104110,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Yang_2110235",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1766373374093710195",
						["startPort"] = "QuestStart",
						["endQuest"] = "1766373388792710480",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766373388792710480",
						["startPort"] = "Out",
						["endQuest"] = "1766373374093710198",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1766373388792710480",
						["startPort"] = "Fail",
						["endQuest"] = "1766373374093710201",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1766373374093710195"] = {
						["key"] = "1766373374093710195",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 930.7142857142858,
							["y"] = 291.42857142857144
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766373374093710198"] = {
						["key"] = "1766373374093710198",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1694.0601503759397,
							["y"] = 295.2631578947369
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766373374093710201"] = {
						["key"] = "1766373374093710201",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1701.4473684210525,
							["y"] = 497.89473684210526
						},
						["propsData"] = {}
					},
					["1766373388792710480"] = {
						["key"] = "1766373388792710480",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1270,
							["y"] = 299
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "UI_CMNpc_Yanjindu_Name_Yang",
							["NpcId"] = 701015,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Yang_2110235",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51114000,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_200311_1",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701015,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701016,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
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
					}
				},
				["commentData"] = {}
			}
		},
		["1766386007987714893"] = {
			["isStoryNode"] = true,
			["key"] = "1766386007987714893",
			["type"] = "StoryNode",
			["name"] = "杨张四人对话",
			["pos"] = {
				["x"] = 2101.9744385880463,
				["y"] = 318.1354905546899
			},
			["propsData"] = {
				["QuestId"] = 20031102,
				["QuestDescriptionComment"] = "交互对话",
				["QuestDescription"] = "Description_200311_2",
				["QuestDeatil"] = "Content_200311_2",
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
				["SubRegionId"] = 104110,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Yang_2110235",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1766386007987714894",
						["startPort"] = "QuestStart",
						["endQuest"] = "1766386168706715898",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766386168706715898",
						["startPort"] = "Out",
						["endQuest"] = "1766386319637717250",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766386319637717250",
						["startPort"] = "Out",
						["endQuest"] = "1766386387690717854",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766386387690717854",
						["startPort"] = "Out",
						["endQuest"] = "1766386007987714897",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1766386007987714894"] = {
						["key"] = "1766386007987714894",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 854,
							["y"] = 317.14285714285717
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766386007987714897"] = {
						["key"] = "1766386007987714897",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2049.9999999999995,
							["y"] = 318
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766386007987714900"] = {
						["key"] = "1766386007987714900",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1766386168706715898"] = {
						["key"] = "1766386168706715898",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "放出张父、小张",
						["pos"] = {
							["x"] = 1159.578947368421,
							["y"] = 312
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110237,
								2110238
							}
						}
					},
					["1766386319637717250"] = {
						["key"] = "1766386319637717250",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1462.1992481203008,
							["y"] = 303.70833333333326
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "UI_CMNpc_Yanjindu_Name_Yang",
							["NpcId"] = 701015,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Yang_2110235",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51114007,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_200311_2",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701015,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701016,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701017,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701018,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
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
					["1766386387690717854"] = {
						["key"] = "1766386387690717854",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁四人",
						["pos"] = {
							["x"] = 1748.9135338345866,
							["y"] = 322.7797619047618
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110235,
								2110236,
								2110237,
								2110238
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17682003679212000"] = {
			["isStoryNode"] = true,
			["key"] = "17682003679212000",
			["type"] = "StoryNode",
			["name"] = "买梨",
			["pos"] = {
				["x"] = 1806.4522441160373,
				["y"] = 316.78940886699513
			},
			["propsData"] = {
				["QuestId"] = 20031103,
				["QuestDescriptionComment"] = "去港口买梨",
				["QuestDescription"] = "Description_200311_3",
				["QuestDeatil"] = "Content_200311_3",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104108,
				["SubRegionIdList"] = {
					104110
				},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Point_BuyPear_200311",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17682003679212001",
						["startPort"] = "QuestStart",
						["endQuest"] = "17682004990273417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17682007471603872",
						["startPort"] = "Out",
						["endQuest"] = "17682007821704266",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17682007821704266",
						["startPort"] = "Out",
						["endQuest"] = "17682008670155253",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17682008670155253",
						["startPort"] = "Out",
						["endQuest"] = "17682003679212004",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17682004990273417",
						["startPort"] = "Out",
						["endQuest"] = "17682034050671091700",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17682034050671091700",
						["startPort"] = "Out",
						["endQuest"] = "17682007471603872",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17682003679212001"] = {
						["key"] = "17682003679212001",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 598.4,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17682003679212004"] = {
						["key"] = "17682003679212004",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2264.7368421052633,
							["y"] = 320.5263157894737
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17682003679212007"] = {
						["key"] = "17682003679212007",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17682004990273417"] = {
						["key"] = "17682004990273417",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成交互drop",
						["pos"] = {
							["x"] = 851.2922077922078,
							["y"] = 312.7813664596275
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090861
							}
						}
					},
					["17682007471603872"] = {
						["key"] = "17682007471603872",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1397.2276916631754,
							["y"] = 308.2313664596275
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 51114005,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17682007821704266"] = {
						["key"] = "17682007821704266",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁交互drop",
						["pos"] = {
							["x"] = 1667.5905948889822,
							["y"] = 320.65072129833715
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090861
							}
						}
					},
					["17682008670155253"] = {
						["key"] = "17682008670155253",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1965.292207792208,
							["y"] = 309.48136645962745
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TargetPoint_200311",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["17682034050671091700"] = {
						["key"] = "17682034050671091700",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1114.0210526315786,
							["y"] = 317.74365325077395
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11224,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Point_BuyPear_200311",
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