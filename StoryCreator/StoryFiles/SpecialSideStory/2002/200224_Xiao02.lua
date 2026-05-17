return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17376215453218972421",
			["startPort"] = "StoryStart",
			["endStory"] = "17376215471358972488",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17376215471358972488",
			["startPort"] = "Success",
			["endStory"] = "173762458376313461070",
			["endPort"] = "In"
		},
		{
			["startStory"] = "173762458757613461279",
			["startPort"] = "Success",
			["endStory"] = "17376215453228972424",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "173762458376313461070",
			["startPort"] = "Success",
			["endStory"] = "173762542787417955265",
			["endPort"] = "In"
		},
		{
			["startStory"] = "173762542787417955265",
			["startPort"] = "Success",
			["endStory"] = "173762458757613461279",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17376215453218972421"] = {
			["isStoryNode"] = true,
			["key"] = "17376215453218972421",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 836.5439560439561,
				["y"] = 312.0824175824176
			},
			["propsData"] = {
				["QuestChainId"] = 200224
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17376215453228972424"] = {
			["isStoryNode"] = true,
			["key"] = "17376215453228972424",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2679.8571428571427,
				["y"] = 388.3571428571429
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17376215471358972488"] = {
			["isStoryNode"] = true,
			["key"] = "17376215471358972488",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1363.6111111111109,
				["y"] = 330.54698200350373
			},
			["propsData"] = {
				["QuestId"] = 20022401,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200224_1",
				["QuestDeatil"] = "Content_200224_1",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "BP_Npc_SideQuest_Xiao_1191071",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "173762511993715709914",
						["startPort"] = "Out",
						["endQuest"] = "17376218134979720546",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17376218134979720546",
						["startPort"] = "Out",
						["endQuest"] = "173762547733319452184",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762547733319452184",
						["startPort"] = "Out",
						["endQuest"] = "17376215471358972492",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17376215471358972489",
						["startPort"] = "QuestStart",
						["endQuest"] = "173762511993715709914",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17376215471358972489"] = {
						["key"] = "17376215471358972489",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 177.91666666666674,
							["y"] = 347.29166666666663
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17376215471358972492"] = {
						["key"] = "17376215471358972492",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1638.4888888888888,
							["y"] = 328.84444444444443
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17376215471358972495"] = {
						["key"] = "17376215471358972495",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1838.8888888888887,
							["y"] = 525.5555555555555
						},
						["propsData"] = {}
					},
					["17376218134979720546"] = {
						["key"] = "17376218134979720546",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1110.608695652174,
							["y"] = 302.69565217391306
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700204,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_SideQuest_Xiao_1191071",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51007601,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
					["173762511993715709914"] = {
						["key"] = "173762511993715709914",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 836.2060020284379,
							["y"] = 298.4859575442601
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191071
							}
						}
					},
					["173762547733319452184"] = {
						["key"] = "173762547733319452184",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1386.651131295306,
							["y"] = 301.93241938659884
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191071
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["173762458376313461070"] = {
			["isStoryNode"] = true,
			["key"] = "173762458376313461070",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1731.006102212052,
				["y"] = 339.44422511127317
			},
			["propsData"] = {
				["QuestId"] = 20022402,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200224_2",
				["QuestDeatil"] = "Content_200224_2",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "173762528379816458093",
						["startPort"] = "Out",
						["endQuest"] = "173762531539316458430",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762531539316458430",
						["startPort"] = "Out",
						["endQuest"] = "173762539959817206933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762539959817206933",
						["startPort"] = "Out",
						["endQuest"] = "173762458376313461074",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173762458376313461071",
						["startPort"] = "QuestStart",
						["endQuest"] = "1741663083522980",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1741663083522980",
						["startPort"] = "Out",
						["endQuest"] = "173762528379816458093",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["173762458376313461071"] = {
						["key"] = "173762458376313461071",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 456,
							["y"] = 286
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173762458376313461074"] = {
						["key"] = "173762458376313461074",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2094,
							["y"] = 312
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173762458376313461077"] = {
						["key"] = "173762458376313461077",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["173762528379816458093"] = {
						["key"] = "173762528379816458093",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成西奥",
						["pos"] = {
							["x"] = 1150,
							["y"] = 302
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720494
							}
						}
					},
					["173762531539316458430"] = {
						["key"] = "173762531539316458430",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1498,
							["y"] = 288
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700204,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Xiao_1720494",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51007646,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
					["173762539959817206933"] = {
						["key"] = "173762539959817206933",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁西奥",
						["pos"] = {
							["x"] = 1824,
							["y"] = 302
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720494
							}
						}
					},
					["1741663083522980"] = {
						["key"] = "1741663083522980",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 768,
							["y"] = 324
						},
						["propsData"] = {
							["RegionType"] = 2,
							["IsEnter"] = "Enter",
							["RegionId"] = 1017,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "BP_Npc_Xiao_1720494"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["173762458757613461279"] = {
			["isStoryNode"] = true,
			["key"] = "173762458757613461279",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2325.058174281858,
				["y"] = 340.92818906239967
			},
			["propsData"] = {
				["QuestId"] = 20022404,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200224_5",
				["QuestDeatil"] = "Content_200224_5",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "BP_Npc_SideQuest_Xiao_1191071",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "173762578465822445241",
						["startPort"] = "Out",
						["endQuest"] = "173762578465822445242",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762458757613461280",
						["startPort"] = "QuestStart",
						["endQuest"] = "173762578465822445241",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762578465822445243",
						["startPort"] = "Out",
						["endQuest"] = "173762458757613461283",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173762578465822445242",
						["startPort"] = "Out",
						["endQuest"] = "17389178461911012147",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17389178461911012147",
						["startPort"] = "Out",
						["endQuest"] = "173762578465822445243",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["173762458757613461280"] = {
						["key"] = "173762458757613461280",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1080,
							["y"] = 308
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173762458757613461283"] = {
						["key"] = "173762458757613461283",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2545.4106280193237,
							["y"] = 295.8937198067633
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173762458757613461286"] = {
						["key"] = "173762458757613461286",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["173762578465822445241"] = {
						["key"] = "173762578465822445241",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1483.854358443489,
							["y"] = 292.9382412273717
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191071
							}
						}
					},
					["173762578465822445242"] = {
						["key"] = "173762578465822445242",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1766.6844024945756,
							["y"] = 304.2331112180621
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700204,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_SideQuest_Xiao_1191071",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51007670,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
					["173762578465822445243"] = {
						["key"] = "173762578465822445243",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2269.940513351383,
							["y"] = 287.02757073844015
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191071
							}
						}
					},
					["17389178461911012147"] = {
						["key"] = "17389178461911012147",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2002.9158721078056,
							["y"] = 287.9150957102903
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51007690,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Fixsimple_SewPoor",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
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
									["TalkActorId"] = 700204,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700205,
									["TalkActorVisible"] = true,
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
		},
		["173762542787417955265"] = {
			["isStoryNode"] = true,
			["key"] = "173762542787417955265",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2006.5410699267677,
				["y"] = 356.76880788928844
			},
			["propsData"] = {
				["QuestId"] = 20022403,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200224_3",
				["QuestDeatil"] = "Content_200224_3",
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
				["SubRegionId"] = 101701,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "BP_Npc_Xiao_1720493",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "173762543022217955362",
						["startPort"] = "Out",
						["endQuest"] = "173762543022217955364",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762543022217955360",
						["startPort"] = "Out",
						["endQuest"] = "173762543022217955363",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762543022217955363",
						["startPort"] = "Out",
						["endQuest"] = "173762543022217955365",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762543022217955365",
						["startPort"] = "Out",
						["endQuest"] = "173762543022217955362",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762542787417955266",
						["startPort"] = "QuestStart",
						["endQuest"] = "173762543022217955361",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173762543022217955364",
						["startPort"] = "Out",
						["endQuest"] = "173762542787417955269",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173762543022217955361",
						["startPort"] = "Out",
						["endQuest"] = "173762543022217955360",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["173762542787417955266"] = {
						["key"] = "173762542787417955266",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1160,
							["y"] = 252
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173762542787417955269"] = {
						["key"] = "173762542787417955269",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2544,
							["y"] = 414
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173762542787417955272"] = {
						["key"] = "173762542787417955272",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["173762543022217955360"] = {
						["key"] = "173762543022217955360",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1888.401068540405,
							["y"] = 303.9147074190177
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700204,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Xiao_1720493",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51007660,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
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
					["173762543022217955361"] = {
						["key"] = "173762543022217955361",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成西奥",
						["pos"] = {
							["x"] = 1542.7571461834016,
							["y"] = 280.8411703239289
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720493
							}
						}
					},
					["173762543022217955362"] = {
						["key"] = "173762543022217955362",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成老鼠",
						["pos"] = {
							["x"] = 1900.4072245533077,
							["y"] = 482.15882967607104
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720488,
								1720489,
								1720490,
								1720491,
								1720492
							}
						}
					},
					["173762543022217955363"] = {
						["key"] = "173762543022217955363",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁西奥",
						["pos"] = {
							["x"] = 2150.7574566342364,
							["y"] = 317.4046158738812
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720493
							}
						}
					},
					["173762543022217955364"] = {
						["key"] = "173762543022217955364",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2176.242853816598,
							["y"] = 467.1160669665167
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1720488,
								1720489,
								1720490,
								1720491,
								1720492
							}
						}
					},
					["173762543022217955365"] = {
						["key"] = "173762543022217955365",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1631.3955112390431,
							["y"] = 479.68994796056165
						},
						["propsData"] = {
							["NewDescription"] = "Description_200224_4",
							["NewDetail"] = "Content_200224_4",
							["SubTaskTargetIndex"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}