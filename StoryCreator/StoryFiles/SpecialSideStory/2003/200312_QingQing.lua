return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1766660880913568",
			["startPort"] = "StoryStart",
			["endStory"] = "1766660885974783",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1766660885974783",
			["startPort"] = "Success",
			["endStory"] = "17666636815592167",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17666636877552388",
			["startPort"] = "Success",
			["endStory"] = "17666636890012482",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17666636890012482",
			["startPort"] = "Success",
			["endStory"] = "1766660880913571",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17666636815592167",
			["startPort"] = "Success",
			["endStory"] = "17679442299982177037",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17679442299982177037",
			["startPort"] = "Success",
			["endStory"] = "17666636877552388",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["1766660880913568"] = {
			["isStoryNode"] = true,
			["key"] = "1766660880913568",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 776.0571428571429,
				["y"] = 353.37142857142857
			},
			["propsData"] = {
				["QuestChainId"] = 200312
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1766660880913571"] = {
			["isStoryNode"] = true,
			["key"] = "1766660880913571",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2492.8571428571427,
				["y"] = 351.42857142857144
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1766660885974783"] = {
			["isStoryNode"] = true,
			["key"] = "1766660885974783",
			["type"] = "StoryNode",
			["name"] = "创建NPC",
			["pos"] = {
				["x"] = 1059.4761904761906,
				["y"] = 342.1714285714286
			},
			["propsData"] = {
				["QuestId"] = 20031200,
				["QuestDescriptionComment"] = "创建NPC",
				["QuestDescription"] = "Description_200312_1",
				["QuestDeatil"] = "Content_200312_1",
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
				["StoryGuidePointName"] = "Npc_QingQing_2110240",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1766660885974784",
						["startPort"] = "QuestStart",
						["endQuest"] = "17666643147167542",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17666643147167542",
						["startPort"] = "Out",
						["endQuest"] = "1766660885974787",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1766660885974784"] = {
						["key"] = "1766660885974784",
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
					["1766660885974787"] = {
						["key"] = "1766660885974787",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1472.1052631578946,
							["y"] = 296.84210526315786
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766660885974790"] = {
						["key"] = "1766660885974790",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17666643147167542"] = {
						["key"] = "17666643147167542",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "创建青青",
						["pos"] = {
							["x"] = 1107.9114832535886,
							["y"] = 301.18215994531784
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110240
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17666636815592167"] = {
			["isStoryNode"] = true,
			["key"] = "17666636815592167",
			["type"] = "StoryNode",
			["name"] = "青青对话",
			["pos"] = {
				["x"] = 1382.062561576355,
				["y"] = 339.0502463054187
			},
			["propsData"] = {
				["QuestId"] = 20031201,
				["QuestDescriptionComment"] = "和青青对话",
				["QuestDescription"] = "Description_200312_1",
				["QuestDeatil"] = "Content_200312_1",
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
				["StoryGuidePointName"] = "Npc_QingQing_2110240",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17666636815592168",
						["startPort"] = "QuestStart",
						["endQuest"] = "17666646132318482",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17666646132318482",
						["startPort"] = "Out",
						["endQuest"] = "17666646506319661",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17666646132318482",
						["startPort"] = "Fail",
						["endQuest"] = "17666636815592174",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17666646506319661",
						["startPort"] = "Out",
						["endQuest"] = "17666636815592171",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17666636815592168"] = {
						["key"] = "17666636815592168",
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
					["17666636815592171"] = {
						["key"] = "17666636815592171",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2017.4444444444446,
							["y"] = 301.9871794871795
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17666636815592174"] = {
						["key"] = "17666636815592174",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1458.1818181818187,
							["y"] = 513.1818181818182
						},
						["propsData"] = {}
					},
					["17666646132318482"] = {
						["key"] = "17666646132318482",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1197.923076923077,
							["y"] = 309.15384615384625
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "UI_CMNpc_Yanjindu_Name_QingQing",
							["NpcId"] = 701024,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_QingQing_2110240",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200312/20031201.20031201'",
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
					["17666646506319661"] = {
						["key"] = "17666646506319661",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁青青",
						["pos"] = {
							["x"] = 1448.6421362421368,
							["y"] = 308.47627589801505
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110240
							}
						}
					},
					["176666476898610664"] = {
						["key"] = "176666476898610664",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成送礼物男",
						["pos"] = {
							["x"] = 1709.6317004669947,
							["y"] = 136.85961398723566
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110241
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17666636877552388"] = {
			["isStoryNode"] = true,
			["key"] = "17666636877552388",
			["type"] = "StoryNode",
			["name"] = "送礼男子对话",
			["pos"] = {
				["x"] = 1929.9428571428575,
				["y"] = 338.5714285714285
			},
			["propsData"] = {
				["QuestId"] = 20031202,
				["QuestDescriptionComment"] = "和送礼男子对话",
				["QuestDescription"] = "Description_200312_2",
				["QuestDeatil"] = "Content_200312_2",
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
				["StoryGuidePointName"] = "Npc_PresentMan_2110241",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "176666480411111275",
						["startPort"] = "Out",
						["endQuest"] = "176666481621811670",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176666481621811670",
						["startPort"] = "Out",
						["endQuest"] = "17666636877552392",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17666636877552389",
						["startPort"] = "QuestStart",
						["endQuest"] = "17681877962102339",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17681877962102339",
						["startPort"] = "Out",
						["endQuest"] = "176666480411111275",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17666636877552389"] = {
						["key"] = "17666636877552389",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 501.76802507837,
							["y"] = 314.99059561128524
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17666636877552392"] = {
						["key"] = "17666636877552392",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1863.111111111111,
							["y"] = 305.77777777777777
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17666636877552395"] = {
						["key"] = "17666636877552395",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["176666480411111275"] = {
						["key"] = "176666480411111275",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 997.7777777777778,
							["y"] = 309.3333333333333
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "UI_CMNpc_Yanjindu_Name_PresentMan",
							["NpcId"] = 701025,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_PresentMan_2110241",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51118027,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
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
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["176666481621811670"] = {
						["key"] = "176666481621811670",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁送礼物男",
						["pos"] = {
							["x"] = 1287.3698964434263,
							["y"] = 309.7916051268993
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110241
							}
						}
					},
					["176666485487312146"] = {
						["key"] = "176666485487312146",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成青青",
						["pos"] = {
							["x"] = 1588.05955161584,
							["y"] = 181.36248635295297
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110240
							}
						}
					},
					["17681877962102339"] = {
						["key"] = "17681877962102339",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成送礼物男",
						["pos"] = {
							["x"] = 749.6934865900382,
							["y"] = 322.40613026819926
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110241
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17666636890012482"] = {
			["isStoryNode"] = true,
			["key"] = "17666636890012482",
			["type"] = "StoryNode",
			["name"] = "青青对话",
			["pos"] = {
				["x"] = 2189.4624999999996,
				["y"] = 338.3428571428571
			},
			["propsData"] = {
				["QuestId"] = 20031203,
				["QuestDescriptionComment"] = "和青青对话",
				["QuestDescription"] = "Description_200312_3",
				["QuestDeatil"] = "Content_200312_3",
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
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Point_Knock_200312",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17666636890012483",
						["startPort"] = "QuestStart",
						["endQuest"] = "17675097534481681",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675097534481681",
						["startPort"] = "Out",
						["endQuest"] = "17675098324622589",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675098324622589",
						["startPort"] = "Out",
						["endQuest"] = "176666493750413098",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176666493750413098",
						["startPort"] = "Out",
						["endQuest"] = "17675098463473018",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675098463473018",
						["startPort"] = "Out",
						["endQuest"] = "17666636890012486",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17666636890012483"] = {
						["key"] = "17666636890012483",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 579.5,
							["y"] = 307.35714285714283
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17666636890012486"] = {
						["key"] = "17666636890012486",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1880.73732718894,
							["y"] = 317.5115207373272
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17666636890012489"] = {
						["key"] = "17666636890012489",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["176666493750413098"] = {
						["key"] = "176666493750413098",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1375.1774193548388,
							["y"] = 320.7534562211982
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51118043,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_200312_1",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701024,
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
					["176666511242313619"] = {
						["key"] = "176666511242313619",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁青青",
						["pos"] = {
							["x"] = 1388.6394347071694,
							["y"] = 93.206328154604
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110240
							}
						}
					},
					["17675097534481681"] = {
						["key"] = "17675097534481681",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成交互drop",
						["pos"] = {
							["x"] = 833.1118012422362,
							["y"] = 307.4223602484472
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110358
							}
						}
					},
					["17675098324622589"] = {
						["key"] = "17675098324622589",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1080.957423362052,
							["y"] = 312.81406531757165
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11222,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Point_Knock_200312",
							["IsUseCount"] = false
						}
					},
					["17675098463473018"] = {
						["key"] = "17675098463473018",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁交互drop",
						["pos"] = {
							["x"] = 1631.6025846523746,
							["y"] = 313.78180725305566
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110358
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17679442299982177037"] = {
			["isStoryNode"] = true,
			["key"] = "17679442299982177037",
			["type"] = "StoryNode",
			["name"] = "交互等待",
			["pos"] = {
				["x"] = 1651.075729985891,
				["y"] = 343.54668478146135
			},
			["propsData"] = {
				["QuestId"] = 20031204,
				["QuestDescriptionComment"] = "交互等待",
				["QuestDescription"] = "Description_200312_4",
				["QuestDeatil"] = "Content_200312_4",
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
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Point_Wait_200312",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17679442299982177038",
						["startPort"] = "QuestStart",
						["endQuest"] = "17679443314802177992",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679443314802177992",
						["startPort"] = "Out",
						["endQuest"] = "17679444684872178938",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679444684872178938",
						["startPort"] = "Out",
						["endQuest"] = "17679445583002180037",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679445583002180037",
						["startPort"] = "Out",
						["endQuest"] = "17679445677432180317",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17679445677432180317",
						["startPort"] = "Out",
						["endQuest"] = "17679442299982177041",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17679442299982177038"] = {
						["key"] = "17679442299982177038",
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
					["17679442299982177041"] = {
						["key"] = "17679442299982177041",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2245,
							["y"] = 312
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17679442299982177044"] = {
						["key"] = "17679442299982177044",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17679443314802177992"] = {
						["key"] = "17679443314802177992",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成交互drop",
						["pos"] = {
							["x"] = 1097.1875,
							["y"] = 300.6875
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110365
							}
						}
					},
					["17679444684872178938"] = {
						["key"] = "17679444684872178938",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1373.0535714285716,
							["y"] = 300.05357142857144
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11223,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Point_Wait_200312",
							["IsUseCount"] = false
						}
					},
					["17679445583002180037"] = {
						["key"] = "17679445583002180037",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1675.9061147186146,
							["y"] = 312.65882034632057
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200312/20031202.20031202'",
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
					["17679445677432180317"] = {
						["key"] = "17679445677432180317",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁交互drop",
						["pos"] = {
							["x"] = 1971.4061147186146,
							["y"] = 311.15882034632057
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110365
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