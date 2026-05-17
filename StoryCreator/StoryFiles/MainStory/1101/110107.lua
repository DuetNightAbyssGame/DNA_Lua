return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1704175979302206190",
			["startPort"] = "StoryStart",
			["endStory"] = "1722421087595163730",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17309502252793496288",
			["startPort"] = "Success",
			["endStory"] = "1722421087597163736",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1722421087595163730",
			["startPort"] = "Success",
			["endStory"] = "17309502252793496288",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1722421087597163736",
			["startPort"] = "Success",
			["endStory"] = "1742889664571796646",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1742889664571796646",
			["startPort"] = "Success",
			["endStory"] = "1704175979302206191",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1704175979302206190"] = {
			["isStoryNode"] = true,
			["key"] = "1704175979302206190",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 54.78947368421046,
				["y"] = -115.77272727272731
			},
			["propsData"] = {
				["QuestChainId"] = 110107
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1704175979302206191"] = {
			["isStoryNode"] = true,
			["key"] = "1704175979302206191",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1692.248189413693,
				["y"] = -110.19207540636616
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1722421087595163730"] = {
			["isStoryNode"] = true,
			["key"] = "1722421087595163730",
			["type"] = "StoryNode",
			["name"] = "BOSS战",
			["pos"] = {
				["x"] = 385.49287121325085,
				["y"] = -121.42743977134064
			},
			["propsData"] = {
				["QuestId"] = 11010702,
				["QuestDescriptionComment"] = "到达中控室",
				["QuestDescription"] = "Description_110110_6",
				["QuestDeatil"] = "Content_110110_6",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = false,
				["bIsStartChapter"] = true,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_Elevator_Escape",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17229277688621218620",
						["startPort"] = "Success",
						["endQuest"] = "1722421087648163847",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17229280017891222476",
						["startPort"] = "Out",
						["endQuest"] = "1722421087649163848",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17229277688621218620",
						["startPort"] = "Fail",
						["endQuest"] = "17284432663408110999",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284432663408110999",
						["startPort"] = "Out",
						["endQuest"] = "17229280017891222476",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173165885057324582097",
						["startPort"] = "Out",
						["endQuest"] = "173165885057324582098",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173165885057324582098",
						["startPort"] = "Out",
						["endQuest"] = "17229278621251220010",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17229278621251220010",
						["startPort"] = "Out",
						["endQuest"] = "17229277688621218620",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421087648163846",
						["startPort"] = "QuestStart",
						["endQuest"] = "172854286752423290978",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421087648163846",
						["startPort"] = "QuestStart",
						["endQuest"] = "173165885057324582097",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17229277688621218620",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17284432663408110999",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1722421087648163846"] = {
						["key"] = "1722421087648163846",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -1505.0694434994923,
							["y"] = 393.4484382340773
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421087648163847"] = {
						["key"] = "1722421087648163847",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 604.3820243671248,
							["y"] = 406.47298494695514
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421087649163848"] = {
						["key"] = "1722421087649163848",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 606.6051971745079,
							["y"] = 554.4809321495978
						},
						["propsData"] = {}
					},
					["17229277688621218620"] = {
						["key"] = "17229277688621218620",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = -212.16315613499125,
							["y"] = 405.35227744033705
						},
						["propsData"] = {
							["SpecialConfigId"] = 1006,
							["BlackScreenImmediately"] = false
						}
					},
					["17229278621251220010"] = {
						["key"] = "17229278621251220010",
						["type"] = "GoToNode",
						["name"] = "GOTO - BOSS出场",
						["pos"] = {
							["x"] = -684.6208390368475,
							["y"] = 400.178619726253
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1111011005,
							["GuideType"] = "M",
							["GuidePointName"] = "questpoint1111011005"
						}
					},
					["17229280017891222476"] = {
						["key"] = "17229280017891222476",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 366.59744992561525,
							["y"] = 537.1568228948822
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_Elevator_Escape",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17284432663408110999"] = {
						["key"] = "17284432663408110999",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 130.77471041265704,
							["y"] = 530.0664131337537
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["172854286752423290978"] = {
						["key"] = "172854286752423290978",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = -1153.1582150215866,
							["y"] = -63.15243320804109
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0057_scene_ex01_prepare.0057_scene_ex01_prepare'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								102102
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["173165885057324582097"] = {
						["key"] = "173165885057324582097",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "机关控制 - 打开前往中控室的门",
						["pos"] = {
							["x"] = -1216.522875674858,
							["y"] = 390.2574168520943
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {},
							["ManualItemIdList"] = {
								1650019
							},
							["StateId"] = 104011,
							["QuestId"] = 0
						}
					},
					["173165885057324582098"] = {
						["key"] = "173165885057324582098",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = -962.5700395892251,
							["y"] = 395.97194331302444
						},
						["propsData"] = {
							["IsCreate"] = true,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								1650069
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1722421087597163736"] = {
			["isStoryNode"] = true,
			["key"] = "1722421087597163736",
			["type"] = "StoryNode",
			["name"] = "中控室后续剧情",
			["pos"] = {
				["x"] = 1032.743958659306,
				["y"] = -136.09490611598827
			},
			["propsData"] = {
				["QuestId"] = 11010704,
				["QuestDescriptionComment"] = "调查中控室的线索",
				["QuestDescription"] = "Description_110111_1",
				["QuestDeatil"] = "Content_110111_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = false,
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
				["SubRegionId"] = 102102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "questpoint1111011006",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17272521340302785298",
						["startPort"] = "Out",
						["endQuest"] = "17272521340302785297",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17272521340302785297",
						["startPort"] = "Out",
						["endQuest"] = "17272521340302785296",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421087772164116",
						["startPort"] = "Out",
						["endQuest"] = "17272521340302785298",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421087772164116",
						["startPort"] = "Out",
						["endQuest"] = "17283943979645526499",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17272521340302785298",
						["startPort"] = "Out",
						["endQuest"] = "17283944915565714945",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421087770164111",
						["startPort"] = "QuestStart",
						["endQuest"] = "17283943587925525985",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421087770164111",
						["startPort"] = "QuestStart",
						["endQuest"] = "1723186893100672821",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17272521340302785296",
						["startPort"] = "Out",
						["endQuest"] = "173165865887123772183",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421087770164111",
						["startPort"] = "QuestStart",
						["endQuest"] = "17477241276131200",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173165865887123772183",
						["startPort"] = "Out",
						["endQuest"] = "17479158349998359552",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17479158349998359552",
						["startPort"] = "Out",
						["endQuest"] = "1722421087770164112",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1723186893100672821",
						["startPort"] = "Out",
						["endQuest"] = "17507691966235886455",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17507695020845887091",
						["startPort"] = "Out",
						["endQuest"] = "1722421087772164116",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17507695065195887257",
						["startPort"] = "Out",
						["endQuest"] = "1722421087772164116",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17507691966235886455",
						["startPort"] = "false",
						["endQuest"] = "17507695020845887091",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17507691966235886455",
						["startPort"] = "true",
						["endQuest"] = "17507695065195887257",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1722421087770164111"] = {
						["key"] = "1722421087770164111",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -837.5878923970291,
							["y"] = 223.02013591615315
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421087770164112"] = {
						["key"] = "1722421087770164112",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2118.173109699285,
							["y"] = 235.9502988738114
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421087771164113"] = {
						["key"] = "1722421087771164113",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1747.245422738418,
							["y"] = 618.7425862849364
						},
						["propsData"] = {}
					},
					["1722421087772164116"] = {
						["key"] = "1722421087772164116",
						["type"] = "TalkNode",
						["name"] = "过场-SC008-富尔维斯登场",
						["pos"] = {
							["x"] = 348.6015227804994,
							["y"] = 231.34215836324094
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC008/SQ_OBT0102_SC008",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
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
					["1723186893100672821"] = {
						["key"] = "1723186893100672821",
						["type"] = "TalkNode",
						["name"] = "阿瓦尔在楼上",
						["pos"] = {
							["x"] = -566.4827647290036,
							["y"] = 324.0691451428048
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11013401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_18",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110010,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110022,
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
					["1723186893100672822"] = {
						["key"] = "1723186893100672822",
						["type"] = "TalkNode",
						["name"] = "阿瓦尔在楼下",
						["pos"] = {
							["x"] = 32.676455170113655,
							["y"] = -92.68640461238559
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11013408,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_18",
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
									["TalkActorId"] = 110010,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110022,
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
					["17272521340302785296"] = {
						["key"] = "17272521340302785296",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1371.4630804868423,
							["y"] = 249.34744292032198
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11013702,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_19",
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
									["TalkActorId"] = 110012,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110011,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110010,
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
					["17272521340302785297"] = {
						["key"] = "17272521340302785297",
						["type"] = "TalkNode",
						["name"] = "过场-SC009-阿瓦尔死",
						["pos"] = {
							["x"] = 1059.0582331260982,
							["y"] = 245.58782541137862
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC009/SQ_OBT0102_SC009",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
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
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17272521340302785298"] = {
						["key"] = "17272521340302785298",
						["type"] = "TalkNode",
						["name"] = "富尔维斯和阿瓦尔对峙",
						["pos"] = {
							["x"] = 738.8747235783941,
							["y"] = 231.03757838125864
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11018819,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_19",
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
									["TalkActorId"] = 110010,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110012,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110011,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110022,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100340,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100341,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100342,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100343,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100344,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100346,
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
					["17283943587925525985"] = {
						["key"] = "17283943587925525985",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = -342.1956764607602,
							["y"] = 50.69197272931405
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								102102
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17283943979645526499"] = {
						["key"] = "17283943979645526499",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 720.0398186421885,
							["y"] = 76.24752828486888
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0043_story_empire.0043_story_empire'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								102102
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17283944915565714945"] = {
						["key"] = "17283944915565714945",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1130.889433033816,
							["y"] = 94.43060759732103
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								102102
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["173165865887123772183"] = {
						["key"] = "173165865887123772183",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1637.59881993512,
							["y"] = 244.0916121873553
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17477241276131200"] = {
						["key"] = "17477241276131200",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁楼上阿瓦尔",
						["pos"] = {
							["x"] = -361.1111111111111,
							["y"] = -108.88888888888889
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1650062,
								1650700
							}
						}
					},
					["17479158349998359552"] = {
						["key"] = "17479158349998359552",
						["type"] = "AuConditionNode",
						["name"] = "音频条件节点",
						["pos"] = {
							["x"] = 1882.4615384615386,
							["y"] = 273.6923076923077
						},
						["propsData"] = {
							["ActionType"] = 0,
							["Condition"] = "fort02",
							["SaveToServer"] = true
						}
					},
					["17507691966235886455"] = {
						["key"] = "17507691966235886455",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = -320.07437070938215,
							["y"] = 462.00802277432706
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "KajiaTalk",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["17507695020845887091"] = {
						["key"] = "17507695020845887091",
						["type"] = "TalkNode",
						["name"] = "阿瓦尔在楼上",
						["pos"] = {
							["x"] = 28.827104068973117,
							["y"] = 444.86516563146984
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11013420,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_18",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110010,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110022,
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
					["17507695065195887257"] = {
						["key"] = "17507695065195887257",
						["type"] = "TalkNode",
						["name"] = "阿瓦尔在楼上",
						["pos"] = {
							["x"] = 51.35420071918926,
							["y"] = 640.5794513457556
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11013409,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_18",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110010,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110022,
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
					}
				},
				["commentData"] = {}
			}
		},
		["17309502252793496288"] = {
			["isStoryNode"] = true,
			["key"] = "17309502252793496288",
			["type"] = "StoryNode",
			["name"] = "中控室机关特殊任务",
			["pos"] = {
				["x"] = 701.2880140604624,
				["y"] = -127.91158858493542
			},
			["propsData"] = {
				["QuestId"] = 11010705,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_110110_8",
				["QuestDeatil"] = "Content_110110_8",
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
				["SubRegionId"] = 102102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "questpoint1111011006",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17309502252793496289",
						["startPort"] = "QuestStart",
						["endQuest"] = "17349231817402736517",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17309502252793496289",
						["startPort"] = "QuestStart",
						["endQuest"] = "17349231817402736518",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17309502479153497087",
						["startPort"] = "Fail",
						["endQuest"] = "173495100941412765114",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173495100941412765114",
						["startPort"] = "Out",
						["endQuest"] = "17309502252793496295",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17309502252793496289",
						["startPort"] = "QuestStart",
						["endQuest"] = "17352047845822816434",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17309502479153497087",
						["startPort"] = "PassiveFail",
						["endQuest"] = "173495100941412765114",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17309502252793496289",
						["startPort"] = "QuestStart",
						["endQuest"] = "17349231817402736519",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17309502479153497087",
						["startPort"] = "Success",
						["endQuest"] = "17472021382164860590",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17472021382164860590",
						["startPort"] = "Out",
						["endQuest"] = "17309502252793496292",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17349231817402736517",
						["startPort"] = "Out",
						["endQuest"] = "17349232266752737594",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17349231817402736517",
						["startPort"] = "Out",
						["endQuest"] = "173165787171123364029",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173165787171123364029",
						["startPort"] = "Out",
						["endQuest"] = "173165787171123364030",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173165787171123364029",
						["startPort"] = "Out",
						["endQuest"] = "17309502479153497087",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17309502252793496289"] = {
						["key"] = "17309502252793496289",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -207.11939862793756,
							["y"] = 259.54751131221724
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17309502252793496292"] = {
						["key"] = "17309502252793496292",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1388.2760717543376,
							["y"] = 214.40103374885996
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17309502252793496295"] = {
						["key"] = "17309502252793496295",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1398.6890112176204,
							["y"] = 425.02888415931994
						},
						["propsData"] = {}
					},
					["17309502479153497087"] = {
						["key"] = "17309502479153497087",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 732.1062814490421,
							["y"] = 260.15181161492586
						},
						["propsData"] = {
							["SpecialConfigId"] = 1019,
							["BlackScreenImmediately"] = false
						}
					},
					["173165787171123364029"] = {
						["key"] = "173165787171123364029",
						["type"] = "GoToNode",
						["name"] = "GOTO - 到达中控室",
						["pos"] = {
							["x"] = 382.18903975672754,
							["y"] = 264.1532961437912
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1111011006,
							["GuideType"] = "M",
							["GuidePointName"] = "questpoint1111011006"
						}
					},
					["173165787171123364030"] = {
						["key"] = "173165787171123364030",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 701.5768735855032,
							["y"] = 72.86945364920891
						},
						["propsData"] = {
							["IsCreate"] = false,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								1650069
							}
						}
					},
					["17349231817402736517"] = {
						["key"] = "17349231817402736517",
						["type"] = "GoToNode",
						["name"] = "GOTO - 到达中控室门前",
						["pos"] = {
							["x"] = 70.12557096803738,
							["y"] = 259.88402882732794
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1111011012,
							["GuideType"] = "M",
							["GuidePointName"] = "questpoint1111011012"
						}
					},
					["17349231817402736518"] = {
						["key"] = "17349231817402736518",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 49.61495961230611,
							["y"] = 612.9670877979821
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0058_scene_ex01_action.0058_scene_ex01_action'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								102102
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17349231817402736519"] = {
						["key"] = "17349231817402736519",
						["type"] = "TalkNode",
						["name"] = "阿瓦尔说情况不对",
						["pos"] = {
							["x"] = 71.54840121552604,
							["y"] = 107.98095731328337
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11012915,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17349232266752737594"] = {
						["key"] = "17349232266752737594",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 382.91218508348703,
							["y"] = 85.44994438264732
						},
						["propsData"] = {
							["NewDescription"] = "Description_110111_1",
							["NewDetail"] = "Content_110111_1",
							["SubTaskTargetIndex"] = 0
						}
					},
					["173495100941412765114"] = {
						["key"] = "173495100941412765114",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1089.5358851674641,
							["y"] = 398.65550239234466
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "BP_ZhongKongRE",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17352047845822816434"] = {
						["key"] = "17352047845822816434",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "机关控制 - 打开前往中控室的门",
						["pos"] = {
							["x"] = 77.45068337469232,
							["y"] = -61.11616161616175
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {},
							["ManualItemIdList"] = {
								1650021
							},
							["StateId"] = 104011,
							["QuestId"] = 0
						}
					},
					["17472021382164860590"] = {
						["key"] = "17472021382164860590",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1106.4787129382141,
							["y"] = 212.8181818181818
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["1742889664571796646"] = {
			["isStoryNode"] = true,
			["key"] = "1742889664571796646",
			["type"] = "StoryNode",
			["name"] = "查看阿瓦尔特殊任务",
			["pos"] = {
				["x"] = 1313.3947368421052,
				["y"] = -146.33522639249367
			},
			["propsData"] = {
				["QuestId"] = 11010706,
				["QuestDescriptionComment"] = "中控室对峙剧情",
				["QuestDescription"] = "Description_110111_3",
				["QuestDeatil"] = "Content_110111_3",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = false,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = true,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "pAwamove18",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1742889664575796665",
						["startPort"] = "Out",
						["endQuest"] = "1742889664571796653",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1742889664571796651",
						["startPort"] = "QuestStart",
						["endQuest"] = "1742889664571796654",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1742889664571796654",
						["startPort"] = "Fail",
						["endQuest"] = "1742889664575796665",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1742889664571796654",
						["startPort"] = "PassiveFail",
						["endQuest"] = "1742889664575796667",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1742889664575796667",
						["startPort"] = "Out",
						["endQuest"] = "1742889664571796653",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1742889664571796654",
						["startPort"] = "Success",
						["endQuest"] = "17472021122354003332",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17472021122354003332",
						["startPort"] = "Out",
						["endQuest"] = "1742889664571796652",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1742889664571796651"] = {
						["key"] = "1742889664571796651",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -3489.204447730018,
							["y"] = 459.46994371742124
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1742889664571796652"] = {
						["key"] = "1742889664571796652",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = -2230.776268085541,
							["y"] = 226.86895404642834
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1742889664571796653"] = {
						["key"] = "1742889664571796653",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = -2272.4303224463065,
							["y"] = 473.51834111158115
						},
						["propsData"] = {}
					},
					["1742889664571796654"] = {
						["key"] = "1742889664571796654",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = -2968.1337191082566,
							["y"] = 448.09239823404806
						},
						["propsData"] = {
							["SpecialConfigId"] = 1017,
							["BlackScreenImmediately"] = true
						}
					},
					["1742889664575796665"] = {
						["key"] = "1742889664575796665",
						["type"] = "SkipRegionNode",
						["name"] = "送回据点",
						["pos"] = {
							["x"] = -2650.7836391850515,
							["y"] = 476.41974460426474
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 210101,
							["StartIndex"] = 1,
							["IsWhite"] = true
						}
					},
					["1742889664575796667"] = {
						["key"] = "1742889664575796667",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -2641.069111318791,
							["y"] = 645.6853052721057
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "pAwamove18",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["17472021122354003332"] = {
						["key"] = "17472021122354003332",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = -2716.884923425422,
							["y"] = 72
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}