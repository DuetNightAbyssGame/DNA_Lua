return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17307765714531033194",
			["startPort"] = "Success",
			["endStory"] = "1731914562984845883",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1731914562984845883",
			["startPort"] = "Success",
			["endStory"] = "1744799695101686633",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1744799695101686632",
			["startPort"] = "StoryStart",
			["endStory"] = "17307765714531033194",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17307765714531033194"] = {
			["isStoryNode"] = true,
			["key"] = "17307765714531033194",
			["type"] = "StoryNode",
			["name"] = "黎瑟城墙对话",
			["pos"] = {
				["x"] = 1463.8744802924448,
				["y"] = 339.05177627326265
			},
			["propsData"] = {
				["QuestId"] = 10030701,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10030603",
				["QuestDeatil"] = "QuestDesc_10030603",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = true,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "cp2sicktalktele",
				["JumpId"] = 0,
				["QuestUIId"] = 100307
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17407348775234292",
						["startPort"] = "Out",
						["endQuest"] = "174099089486117042",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17465393277133348193",
						["startPort"] = "Out",
						["endQuest"] = "17465163010911284",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17465163010911284",
						["startPort"] = "Out",
						["endQuest"] = "17476370132141726211",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17476370132141726211",
						["startPort"] = "Out",
						["endQuest"] = "1747640869596872696",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1740997757769797185",
						["startPort"] = "Out",
						["endQuest"] = "17479170667461727262",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17309669552894798400",
						["startPort"] = "Out",
						["endQuest"] = "17479170750551727523",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17479170750551727523",
						["startPort"] = "Out",
						["endQuest"] = "17401236515714726688",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17307765714531033195",
						["startPort"] = "QuestStart",
						["endQuest"] = "1740997757769797185",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17307765714531033195",
						["startPort"] = "QuestStart",
						["endQuest"] = "17465393277133348193",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17307765714531033195",
						["startPort"] = "QuestStart",
						["endQuest"] = "17407348775234292",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17401236515714726688",
						["startPort"] = "Out",
						["endQuest"] = "17485230216972613970",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485230216972613970",
						["startPort"] = "Out",
						["endQuest"] = "17307765714531033198",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17479170667461727262",
						["startPort"] = "Out",
						["endQuest"] = "17309669552894798400",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17307765714531033195"] = {
						["key"] = "17307765714531033195",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 377.27272727272725,
							["y"] = 256.3636363636364
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17307765714531033198"] = {
						["key"] = "17307765714531033198",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3101.4772727272725,
							["y"] = 214.0530303030303
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17307765714531033201"] = {
						["key"] = "17307765714531033201",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2808,
							["y"] = 842
						},
						["propsData"] = {}
					},
					["17309669552894798400"] = {
						["key"] = "17309669552894798400",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1792.0431241536844,
							["y"] = 257.5893043577464
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 100304,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_1190845",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 10037501,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "cp2fixsimple04_66",
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
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100304,
									["TalkActorVisible"] = true,
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
					["17401236515714726688"] = {
						["key"] = "17401236515714726688",
						["type"] = "TalkNode",
						["name"] = "过场",
						["pos"] = {
							["x"] = 2475.990196078432,
							["y"] = 283.3382352941176
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC008/SQ_OBT0103_SC008",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17407348775234292"] = {
						["key"] = "17407348775234292",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 1388.25,
							["y"] = 850.5
						},
						["propsData"] = {
							["IsHide"] = true,
							["AtmosphereTagList"] = {
								"cp2theasph"
							}
						}
					},
					["174099089486117042"] = {
						["key"] = "174099089486117042",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 1692.25,
							["y"] = 850.5
						},
						["propsData"] = {
							["IsHide"] = false,
							["AtmosphereTagList"] = {
								"cp2iclsphide"
							}
						}
					},
					["1740997757769797185"] = {
						["key"] = "1740997757769797185",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1163,
							["y"] = 73.5
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityDay",
							["UnitId"] = -1
						}
					},
					["17448906731858939676"] = {
						["key"] = "17448906731858939676",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1442.3529411764703,
							["y"] = 245.4117647058824
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/Chapter02/cp2UIopen07",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = false,
							["ShowReviewButton"] = false,
							["ShowWikiButton"] = false,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
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
					},
					["17465163010911284"] = {
						["key"] = "17465163010911284",
						["type"] = "FinishDetectiveQuestionNode",
						["name"] = "完成推理问题",
						["pos"] = {
							["x"] = 1689.75,
							["y"] = 596
						},
						["propsData"] = {
							["QuestionIds"] = {
								1000
							}
						}
					},
					["17465393277133348193"] = {
						["key"] = "17465393277133348193",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1388.181818181818,
							["y"] = 598.25
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17476370132141726211"] = {
						["key"] = "17476370132141726211",
						["type"] = "AuConditionNode",
						["name"] = "音频条件节点",
						["pos"] = {
							["x"] = 2006,
							["y"] = 600
						},
						["propsData"] = {
							["ActionType"] = 1,
							["Condition"] = "task_cp2"
						}
					},
					["1747640869596872696"] = {
						["key"] = "1747640869596872696",
						["type"] = "AuConditionNode",
						["name"] = "音频条件节点",
						["pos"] = {
							["x"] = 2306,
							["y"] = 600
						},
						["propsData"] = {
							["ActionType"] = 1,
							["Condition"] = "task_cp2_firework"
						}
					},
					["17479170667461727262"] = {
						["key"] = "17479170667461727262",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1530.04662004662,
							["y"] = 50.89510489510474
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190845
							}
						}
					},
					["17479170750551727523"] = {
						["key"] = "17479170750551727523",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2119.7132867132864,
							["y"] = 278.2284382284381
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190845
							}
						}
					},
					["17485230216972613970"] = {
						["key"] = "17485230216972613970",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2741.644736842105,
							["y"] = 175.38157894736844
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1731914562984845883"] = {
			["isStoryNode"] = true,
			["key"] = "1731914562984845883",
			["type"] = "StoryNode",
			["name"] = "军团会议室",
			["pos"] = {
				["x"] = 2015.7142857142858,
				["y"] = 352.2857142857142
			},
			["propsData"] = {
				["QuestId"] = 10030702,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10030604",
				["QuestDeatil"] = "QuestDesc_10030604",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1731914564349846047",
						["startPort"] = "Out",
						["endQuest"] = "1731914564349846049",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1731914564349846049",
						["startPort"] = "Out",
						["endQuest"] = "1731914564349846048",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17350356706941386909",
						["startPort"] = "Out",
						["endQuest"] = "1731914562984845887",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1731914562984845884",
						["startPort"] = "QuestStart",
						["endQuest"] = "174852207932323449425",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174852207932323449425",
						["startPort"] = "Out",
						["endQuest"] = "17485230399533483444",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485230399533483444",
						["startPort"] = "Out",
						["endQuest"] = "1731914564349846047",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1731914564349846048",
						["startPort"] = "Out",
						["endQuest"] = "17485230565053483881",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485230565053483881",
						["startPort"] = "Out",
						["endQuest"] = "17350356706941386909",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1731914562984845884"] = {
						["key"] = "1731914562984845884",
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
					["1731914562984845887"] = {
						["key"] = "1731914562984845887",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2808.5714285714284,
							["y"] = 302.85714285714283
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101101,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["1731914562984845890"] = {
						["key"] = "1731914562984845890",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1731914564349846047"] = {
						["key"] = "1731914564349846047",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1597.9586712038233,
							["y"] = 302.65403675599805
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10037601,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Cp2Meetingstage01",
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
									["TalkActorId"] = 200022,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100006,
									["TalkActorVisible"] = true,
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
					["1731914564349846048"] = {
						["key"] = "1731914564349846048",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2286.5240874168667,
							["y"] = 304.679296577335
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10037623,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Cp2Meetingstage01",
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
									["TalkActorId"] = 200022,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100006,
									["TalkActorVisible"] = true,
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
					["1731914564349846049"] = {
						["key"] = "1731914564349846049",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1944.8574207502,
							["y"] = 296.01262991066824
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10037610,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Cp2Meetingstage02",
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
									["TalkActorId"] = 200022,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100005,
									["TalkActorVisible"] = true,
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
					["17350356706941386909"] = {
						["key"] = "17350356706941386909",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2377.1428571428573,
							["y"] = 642.0714285714286
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/Chapter02/Meet/Chapter02EndByte",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["174852207932323449425"] = {
						["key"] = "174852207932323449425",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1036.75,
							["y"] = 576.5
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101104,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17485230399533483444"] = {
						["key"] = "17485230399533483444",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1313,
							["y"] = 511.54605263157896
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/mute",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								101104
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = false
						}
					},
					["17485230565053483881"] = {
						["key"] = "17485230565053483881",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1775.5,
							["y"] = 609.046052631579
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1744799695101686632"] = {
			["isStoryNode"] = true,
			["key"] = "1744799695101686632",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 100307
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1744799695101686633"] = {
			["isStoryNode"] = true,
			["key"] = "1744799695101686633",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2800,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}