return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17448604502166322001",
			["startPort"] = "Success",
			["endStory"] = "17448604566236322226",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17448604566236322226",
			["startPort"] = "Success",
			["endStory"] = "17448605233596322412",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17448605233596322412",
			["startPort"] = "Success",
			["endStory"] = "17448696635786330331",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17448696635786330331",
			["startPort"] = "Success",
			["endStory"] = "17448697647406331656",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17448697647406331656",
			["startPort"] = "Success",
			["endStory"] = "17447257980644905609",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17447257980644905608",
			["startPort"] = "StoryStart",
			["endStory"] = "17448604502166322001",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17447257980644905608"] = {
			["isStoryNode"] = true,
			["key"] = "17447257980644905608",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 808.75,
				["y"] = 313.75
			},
			["propsData"] = {
				["QuestChainId"] = 200232
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17447257980644905609"] = {
			["isStoryNode"] = true,
			["key"] = "17447257980644905609",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1660.2167555316714,
				["y"] = 519.681903030757
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17448604502166322001"] = {
			["isStoryNode"] = true,
			["key"] = "17448604502166322001",
			["type"] = "StoryNode",
			["name"] = "与箱子对话",
			["pos"] = {
				["x"] = 1078.367402601384,
				["y"] = 301.8562802246334
			},
			["propsData"] = {
				["QuestId"] = 20023201,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200232_1",
				["QuestDeatil"] = "Content_200232_1",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_20023200Box_1191555",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17448608560116323722",
						["startPort"] = "Out",
						["endQuest"] = "17495553657185528",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17495553657185528",
						["startPort"] = "Out",
						["endQuest"] = "17495557050407635",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17495670574381857257",
						["startPort"] = "Out",
						["endQuest"] = "17448604502166322005",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17495557050407635",
						["startPort"] = "Out",
						["endQuest"] = "17495670574381857257",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17448608560116323722",
						["startPort"] = "Out",
						["endQuest"] = "17495554667956545",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17448604502166322002",
						["startPort"] = "QuestStart",
						["endQuest"] = "17600137339592454",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17600137339592454",
						["startPort"] = "Out",
						["endQuest"] = "17600137572483366",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17600137572483366",
						["startPort"] = "Out",
						["endQuest"] = "17448608560116323722",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17600137339592454",
						["startPort"] = "Out",
						["endQuest"] = "17600138059284704",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17448604502166322002"] = {
						["key"] = "17448604502166322002",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 87.55226812477366,
							["y"] = 336.50087242775714
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448604502166322005"] = {
						["key"] = "17448604502166322005",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2851.3340571980493,
							["y"] = 327.06181394928007
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448604502166322008"] = {
						["key"] = "17448604502166322008",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2404.968113523179,
							["y"] = 457.2830915264732
						},
						["propsData"] = {}
					},
					["17448608560116323722"] = {
						["key"] = "17448608560116323722",
						["type"] = "TalkNode",
						["name"] = "第一段",
						["pos"] = {
							["x"] = 1459.0355932763941,
							["y"] = 278.9406987783497
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009726,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20023201",
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
									["TalkActorId"] = 700309,
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
					["17495553657185528"] = {
						["key"] = "17495553657185528",
						["type"] = "TalkNode",
						["name"] = "黑屏",
						["pos"] = {
							["x"] = 1748.938301633219,
							["y"] = 272.8844744648106
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009760,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
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
							["SwitchToMaster"] = "Player",
							["OverrideFailBlend"] = false
						}
					},
					["17495554667956545"] = {
						["key"] = "17495554667956545",
						["type"] = "SendMessageNode",
						["name"] = "切换白天",
						["pos"] = {
							["x"] = 1748.3716982449118,
							["y"] = 81.36887395088013
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityDay",
							["UnitId"] = -1
						}
					},
					["17495557050407635"] = {
						["key"] = "17495557050407635",
						["type"] = "TalkNode",
						["name"] = "第二段",
						["pos"] = {
							["x"] = 2051.954163246649,
							["y"] = 285.4241524260235
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009761,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20023201b",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
							["InType"] = "FadeIn",
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
					["17495670574381857257"] = {
						["key"] = "17495670574381857257",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成吉赛尔",
						["pos"] = {
							["x"] = 2608.8808640826974,
							["y"] = 316.6737337001181
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191560
							}
						}
					},
					["17600137339592454"] = {
						["key"] = "17600137339592454",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 370.24491104026373,
							["y"] = 309.46939371043584
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191555,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Xiangzi_SSS_1191557"
						}
					},
					["17600137572483366"] = {
						["key"] = "17600137572483366",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 685.8846256561358,
							["y"] = 294.95528759097414
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009723,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20023200",
							["BlendInTime"] = 2,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
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
									["TalkActorId"] = 700309,
									["TalkActorVisible"] = false,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17600138059284704"] = {
						["key"] = "17600138059284704",
						["type"] = "SendMessageNode",
						["name"] = "切换黑夜",
						["pos"] = {
							["x"] = 712.4690692158941,
							["y"] = 539.8734960921822
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["1760013892265938116"] = {
						["key"] = "1760013892265938116",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 827.0468051962102,
							["y"] = -64.75395040174041
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009725,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
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
							["SwitchToMaster"] = "Player",
							["OverrideFailBlend"] = false
						}
					},
					["1760014006049939337"] = {
						["key"] = "1760014006049939337",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1156.9295812414591,
							["y"] = -38.301714846256345
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009838,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
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
							["SwitchToMaster"] = "Player",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17448604566236322226"] = {
			["isStoryNode"] = true,
			["key"] = "17448604566236322226",
			["type"] = "StoryNode",
			["name"] = "与吉赛尔对话",
			["pos"] = {
				["x"] = 1357.977146266413,
				["y"] = 291.78363089461146
			},
			["propsData"] = {
				["QuestId"] = 20023202,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200232_2",
				["QuestDeatil"] = "Content_200232_2",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Giselle_SSS_1191560",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17448604566236322231",
						["startPort"] = "QuestStart",
						["endQuest"] = "17448610023396325805",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17448610023396325805",
						["startPort"] = "Out",
						["endQuest"] = "17448604566236322232",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17448604566236322231"] = {
						["key"] = "17448604566236322231",
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
					["17448604566236322232"] = {
						["key"] = "17448604566236322232",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1671.489353862053,
							["y"] = 304.91793340700127
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448604566236322233"] = {
						["key"] = "17448604566236322233",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1618,
							["y"] = 510.85714285714283
						},
						["propsData"] = {}
					},
					["17448610023396325805"] = {
						["key"] = "17448610023396325805",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1098.5714285714284,
							["y"] = 304.57142857142867
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700302,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Giselle_SSS_1191560",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51009763,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
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
		["17448605233596322412"] = {
			["isStoryNode"] = true,
			["key"] = "17448605233596322412",
			["type"] = "StoryNode",
			["name"] = "采集草药",
			["pos"] = {
				["x"] = 1649.0893719492797,
				["y"] = 304.5217391304348
			},
			["propsData"] = {
				["QuestId"] = 20023203,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200232_3",
				["QuestDeatil"] = "Content_200232_3",
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Questpoint_20023203",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17448612702846328836",
						["startPort"] = "Out",
						["endQuest"] = "17448605233596322418",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174962921728911084711",
						["startPort"] = "Out",
						["endQuest"] = "174962919328211083996",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "174962922064711084808",
						["startPort"] = "Out",
						["endQuest"] = "174962919328211083996",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "174962922304111084899",
						["startPort"] = "Out",
						["endQuest"] = "174962919328211083996",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "174962919328211083996",
						["startPort"] = "Out",
						["endQuest"] = "17448612702846328836",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496120630433704051",
						["startPort"] = "Out",
						["endQuest"] = "174962921728911084711",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496120630433704051",
						["startPort"] = "Out",
						["endQuest"] = "174962922064711084808",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496120630433704051",
						["startPort"] = "Out",
						["endQuest"] = "174962922304111084899",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17448605233596322417",
						["startPort"] = "QuestStart",
						["endQuest"] = "17448612610686328635",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17509216772102426",
						["startPort"] = "Success",
						["endQuest"] = "174963318737312938332",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17448612610686328635",
						["startPort"] = "Out",
						["endQuest"] = "17509216772102426",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17509216772102426",
						["startPort"] = "Fail",
						["endQuest"] = "17509265648186333",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17509265648186333",
						["startPort"] = "Out",
						["endQuest"] = "17448605233596322419",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17509216772102426",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17509265648186333",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174963318737312938332",
						["startPort"] = "Out",
						["endQuest"] = "174963017186712011476",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174963017186712011476",
						["startPort"] = "Out",
						["endQuest"] = "17547389677507262",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17547389677507262",
						["startPort"] = "Out",
						["endQuest"] = "17496120630433704051",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17448605233596322417"] = {
						["key"] = "17448605233596322417",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -96.65077460523108,
							["y"] = 301.11451486084616
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448605233596322418"] = {
						["key"] = "17448605233596322418",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2442.8559582382513,
							["y"] = 560.4303442031829
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448605233596322419"] = {
						["key"] = "17448605233596322419",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1796.8559605997307,
							["y"] = -159.5696559784693
						},
						["propsData"] = {}
					},
					["17448612610686328635"] = {
						["key"] = "17448612610686328635",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 531.8181836397084,
							["y"] = 117.93940019797282
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240920,
							["GuideType"] = "P",
							["GuidePointName"] = "Questpoint_20023203"
						}
					},
					["17448612702846328836"] = {
						["key"] = "17448612702846328836",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2043.5823342261042,
							["y"] = 555.7193550105417
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009785,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20023203",
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
					["17495676811782780079"] = {
						["key"] = "17495676811782780079",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成阻挠的怪物",
						["pos"] = {
							["x"] = 389.3685423259444,
							["y"] = -201.21016107152548
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240906,
								1240907,
								1240908,
								1240909,
								1240910,
								1240911,
								1240912,
								1240913,
								1240914,
								1240915
							}
						}
					},
					["17496120630433704051"] = {
						["key"] = "17496120630433704051",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成掉落物",
						["pos"] = {
							["x"] = 885.1907524295067,
							["y"] = 501.7990358612188
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240917,
								1240918,
								1240919
							}
						}
					},
					["174962919328211083996"] = {
						["key"] = "174962919328211083996",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 1721.6017457910052,
							["y"] = 498.4329037525875
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["174962921728911084711"] = {
						["key"] = "174962921728911084711",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1355.5737463991095,
							["y"] = 356.16218253743625
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11026,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["174962922064711084808"] = {
						["key"] = "174962922064711084808",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1333.8414119072904,
							["y"] = 530.0128250931493
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11027,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["174962922304111084899"] = {
						["key"] = "174962922304111084899",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1337.6250265777371,
							["y"] = 749.3128893911156
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11028,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["174963012882512010330"] = {
						["key"] = "174963012882512010330",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 701.9524568889374,
							["y"] = -210.43228103687147
						},
						["propsData"] = {
							["NewDescription"] = "Description_200232_6",
							["NewDetail"] = "Content_200232_6",
							["SubTaskTargetIndex"] = 0
						}
					},
					["174963015760312011192"] = {
						["key"] = "174963015760312011192",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1029.9524568889374,
							["y"] = -222.43228103687147
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 10,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1240906,
								1240907,
								1240908,
								1240909,
								1240910,
								1240911,
								1240912,
								1240913,
								1240914,
								1240915
							}
						}
					},
					["174963017186712011476"] = {
						["key"] = "174963017186712011476",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2029.5887971957477,
							["y"] = 132.2680612827943
						},
						["propsData"] = {
							["NewDescription"] = "Description_200232_3",
							["NewDetail"] = "Content_200232_3",
							["SubTaskTargetIndex"] = 0
						}
					},
					["174963318737312938332"] = {
						["key"] = "174963318737312938332",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1714.652510612792,
							["y"] = 149.41445561999808
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Questpoint_20023203"
						}
					},
					["17509216772102426"] = {
						["key"] = "17509216772102426",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1216,
							["y"] = 98
						},
						["propsData"] = {
							["SpecialConfigId"] = 1055,
							["BlackScreenImmediately"] = true
						}
					},
					["17509265648186333"] = {
						["key"] = "17509265648186333",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1530,
							["y"] = -88.00000000000006
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "PlayerPoint_20023203",
							["FadeIn"] = true,
							["FadeOut"] = true,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17547389677507262"] = {
						["key"] = "17547389677507262",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁吉赛尔",
						["pos"] = {
							["x"] = 574.5566667239027,
							["y"] = 503.68459297644966
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191560
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17448696635786330331"] = {
			["isStoryNode"] = true,
			["key"] = "17448696635786330331",
			["type"] = "StoryNode",
			["name"] = "回水仙平原+线索2   ",
			["pos"] = {
				["x"] = 1066.6946181872793,
				["y"] = 506.39975735522245
			},
			["propsData"] = {
				["QuestId"] = 20023204,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200232_4",
				["QuestDeatil"] = "Content_200232_4",
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
				["SubRegionId"] = 101107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "TargetPoint_Tavern",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17448696635786330332",
						["startPort"] = "QuestStart",
						["endQuest"] = "17495710382893701925",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17495710382893701925",
						["startPort"] = "Out",
						["endQuest"] = "17448697007886330961",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17500585825641819",
						["startPort"] = "Out",
						["endQuest"] = "17500585955112121",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501297984155678119",
						["startPort"] = "Out",
						["endQuest"] = "17501297984155678120",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501297984155678117",
						["startPort"] = "true",
						["endQuest"] = "17501297984155678118",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501297984155678118",
						["startPort"] = "Out",
						["endQuest"] = "17501297984155678121",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501297984155678121",
						["startPort"] = "Out",
						["endQuest"] = "17501297984155678119",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501297984155678117",
						["startPort"] = "false",
						["endQuest"] = "17501297984155678119",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17448697007886330961",
						["startPort"] = "Out",
						["endQuest"] = "17500585825641819",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17500585955112121",
						["startPort"] = "Out",
						["endQuest"] = "17501297984155678117",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501297984155678120",
						["startPort"] = "Out",
						["endQuest"] = "17448696635796330335",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17448696635786330332"] = {
						["key"] = "17448696635786330332",
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
					["17448696635796330335"] = {
						["key"] = "17448696635796330335",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3533.6070994033307,
							["y"] = 302.8386262419088
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448696635796330338"] = {
						["key"] = "17448696635796330338",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17448697007886330961"] = {
						["key"] = "17448697007886330961",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1407.7506755360873,
							["y"] = 302.09126291365476
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009789,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20023204",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
									["TalkActorId"] = 200003,
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
					},
					["17495710382893701925"] = {
						["key"] = "17495710382893701925",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1133.281173836157,
							["y"] = 303.1067294782466
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1220167,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Kamila_1220002"
						}
					},
					["17500585825641819"] = {
						["key"] = "17500585825641819",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1684.1020702149822,
							["y"] = 298.83892209101106
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009802,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
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
					},
					["17500585955112121"] = {
						["key"] = "17500585955112121",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2059.0111550990237,
							["y"] = 294.7783138118789
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009803,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20023204",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
									["TalkActorId"] = 200003,
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
					},
					["17501297984155678117"] = {
						["key"] = "17501297984155678117",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "0未解锁推理问题，1为已解锁",
						["pos"] = {
							["x"] = 2358.914269040609,
							["y"] = 261.9502578109693
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Huozai04Side",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17501297984155678118"] = {
						["key"] = "17501297984155678118",
						["type"] = "UnlockDetectiveQuestionNode",
						["name"] = "开启推理问题",
						["pos"] = {
							["x"] = 2616.812130165567,
							["y"] = 119.32913021013127
						},
						["propsData"] = {
							["QuestionIds"] = {
								2002
							},
							["OpenToast"] = false
						}
					},
					["17501297984155678119"] = {
						["key"] = "17501297984155678119",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索",
						["pos"] = {
							["x"] = 3200.9840856401706,
							["y"] = 299.8843301205615
						},
						["propsData"] = {
							["AnswerIds"] = {
								200202
							}
						}
					},
					["17501297984155678120"] = {
						["key"] = "17501297984155678120",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 3179.194189896751,
							["y"] = 117.87670803525543
						},
						["propsData"] = {
							["AnswerId"] = 200202,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["17501297984155678121"] = {
						["key"] = "17501297984155678121",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2879.9862355394966,
							["y"] = 114.64517642370248
						},
						["propsData"] = {
							["VarName"] = "Huozai04Side",
							["VarValue"] = 1
						}
					}
				},
				["commentData"] = {
					["17501298488085679901"] = {
						["key"] = "17501298488085679901",
						["name"] = "获得线索2",
						["position"] = {
							["x"] = 2340.823743324144,
							["y"] = -40.89258901543474
						},
						["size"] = {
							["width"] = 1118.1818009473734,
							["height"] = 587.8787788178603
						}
					}
				}
			}
		},
		["17448697647406331656"] = {
			["isStoryNode"] = true,
			["key"] = "17448697647406331656",
			["type"] = "StoryNode",
			["name"] = "去找吉赛尔+线索5    ",
			["pos"] = {
				["x"] = 1373.5700482463853,
				["y"] = 506.53260756537156
			},
			["propsData"] = {
				["QuestId"] = 20023205,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200232_5",
				["QuestDeatil"] = "Content_200232_5",
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
				["StoryGuidePointName"] = "TargetPoint_LeaveTavern",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17448698196776332704",
						["startPort"] = "Out",
						["endQuest"] = "17448698565416333345",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17448697647406331657",
						["startPort"] = "QuestStart",
						["endQuest"] = "174964541884017553935",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174964541884017553935",
						["startPort"] = "Out",
						["endQuest"] = "174964544918317554524",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174964544918317554524",
						["startPort"] = "Out",
						["endQuest"] = "17448698196776332704",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501298868055680755",
						["startPort"] = "Out",
						["endQuest"] = "17501298868055680756",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501298868055680753",
						["startPort"] = "true",
						["endQuest"] = "17501298868055680754",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501298868055680754",
						["startPort"] = "Out",
						["endQuest"] = "17501298868055680757",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501298868055680757",
						["startPort"] = "Out",
						["endQuest"] = "17501298868055680755",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501298868055680753",
						["startPort"] = "false",
						["endQuest"] = "17501298868055680755",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501298868055680756",
						["startPort"] = "Out",
						["endQuest"] = "17448697647406331660",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17448698196776332704",
						["startPort"] = "Out",
						["endQuest"] = "17600102202512817",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17448698565416333345",
						["startPort"] = "Out",
						["endQuest"] = "17600102922873612",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17600102922873612",
						["startPort"] = "Out",
						["endQuest"] = "17501298868055680753",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17448697647406331657"] = {
						["key"] = "17448697647406331657",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 641.4634185676036,
							["y"] = 304.87804865945833
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448697647406331660"] = {
						["key"] = "17448697647406331660",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3415.944243336997,
							["y"] = 307.38675982394045
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448697647406331663"] = {
						["key"] = "17448697647406331663",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2260.7299069405935,
							["y"] = 849.3592356255181
						},
						["propsData"] = {}
					},
					["17448698196776332704"] = {
						["key"] = "17448698196776332704",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1389.6585290512821,
							["y"] = 282.24390268108334
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191561,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_20023205Magnus_1191561"
						}
					},
					["17448698565416333345"] = {
						["key"] = "17448698565416333345",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1645.372814765568,
							["y"] = 280.81533125251195
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009819,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage20023205",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
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
									["TalkActorId"] = 700307,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700308,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700313,
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
					["174964541884017553935"] = {
						["key"] = "174964541884017553935",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 898.6835098818857,
							["y"] = 300.9332397463283
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_20023205Magnus_1191561"
						}
					},
					["174964544918317554524"] = {
						["key"] = "174964544918317554524",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成伯爵夫妇与卫兵",
						["pos"] = {
							["x"] = 1146.2444793493967,
							["y"] = 282.6405572733595
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191562,
								1191563,
								1191565
							}
						}
					},
					["17501298868055680753"] = {
						["key"] = "17501298868055680753",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "0未解锁推理问题，1为已解锁",
						["pos"] = {
							["x"] = 1922.2826900404054,
							["y"] = 274.89762580934075
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Huozai04Side",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17501298868055680754"] = {
						["key"] = "17501298868055680754",
						["type"] = "UnlockDetectiveQuestionNode",
						["name"] = "开启推理问题",
						["pos"] = {
							["x"] = 2205.6350951486756,
							["y"] = 147.8522556674958
						},
						["propsData"] = {
							["QuestionIds"] = {
								2002
							},
							["OpenToast"] = false
						}
					},
					["17501298868055680755"] = {
						["key"] = "17501298868055680755",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索",
						["pos"] = {
							["x"] = 2760.352506639967,
							["y"] = 322.831698118933
						},
						["propsData"] = {
							["AnswerIds"] = {
								200205
							}
						}
					},
					["17501298868055680756"] = {
						["key"] = "17501298868055680756",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 3077.717309959595,
							["y"] = 318.8145129716436
						},
						["propsData"] = {
							["AnswerId"] = 200205,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["17501298868055680757"] = {
						["key"] = "17501298868055680757",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2470.8092005226054,
							["y"] = 141.168301881067
						},
						["propsData"] = {
							["VarName"] = "Huozai04Side",
							["VarValue"] = 1
						}
					},
					["17600102202512817"] = {
						["key"] = "17600102202512817",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1651.4949534154268,
							["y"] = 73.4545501484796
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt02/0043_story_empire",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["SoundUnitKey"] = "Huozai03-empire"
						}
					},
					["17600102922873612"] = {
						["key"] = "17600102922873612",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1817.9572221822298,
							["y"] = 464.42357031121674
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundUnitKey"] = "Huozai03-empire"
						}
					}
				},
				["commentData"] = {
					["17501299255515681814"] = {
						["key"] = "17501299255515681814",
						["name"] = "获得线索5",
						["position"] = {
							["x"] = 1898,
							["y"] = 34
						},
						["size"] = {
							["width"] = 1428,
							["height"] = 426
						}
					}
				}
			}
		},
		["1751271788813983059"] = {
			["isStoryNode"] = true,
			["key"] = "1751271788813983059",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 1009.3170740757441,
				["y"] = 57.75296935234283
			},
			["propsData"] = {
				["QuestId"] = 20023200,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 101101,
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_20023200Box_1191555",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1751271788814983066",
						["startPort"] = "ApproveOut",
						["endQuest"] = "1751271788813983064",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1751271788814983070",
						["startPort"] = "false",
						["endQuest"] = "1751271788814983067",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751271788814983070",
						["startPort"] = "true",
						["endQuest"] = "1751271788814983071",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751271788814983066",
						["startPort"] = "CancelOut",
						["endQuest"] = "1751271788814983072",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751271788814983072",
						["startPort"] = "Out",
						["endQuest"] = "1751271788814983065",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1751271788814983074",
						["startPort"] = "Out",
						["endQuest"] = "1751271788814983066",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1751271788814983067",
						["startPort"] = "Out",
						["endQuest"] = "1751271788814983068",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751271788813983063",
						["startPort"] = "QuestStart",
						["endQuest"] = "1751271788814983070",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751271788814983071",
						["startPort"] = "Out",
						["endQuest"] = "1751271788814983073",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751271788814983073",
						["startPort"] = "Out",
						["endQuest"] = "1751271788814983074",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751271788814983068",
						["startPort"] = "Out",
						["endQuest"] = "1751271788814983069",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1751271788814983069",
						["startPort"] = "Out",
						["endQuest"] = "1751271788814983074",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1751271788813983063"] = {
						["key"] = "1751271788813983063",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 127.58621796092322,
							["y"] = 264.82758679721235
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1751271788813983064"] = {
						["key"] = "1751271788813983064",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2825.864146325851,
							["y"] = 189.1198287087802
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1751271788814983065"] = {
						["key"] = "1751271788814983065",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3074.860479192777,
							["y"] = 413.06854570289835
						},
						["propsData"] = {}
					},
					["1751271788814983066"] = {
						["key"] = "1751271788814983066",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 2509.911638136143,
							["y"] = 201.6132583844402
						},
						["propsData"] = {
							["SideQuestChainId"] = 200232,
							["EnableSequence"] = false,
							["SequencePath"] = "",
							["PauseMark"] = ""
						}
					},
					["1751271788814983067"] = {
						["key"] = "1751271788814983067",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1221.7803810692737,
							["y"] = 311.5779350896006
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191555,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Xiangzi_SSS_1191557"
						}
					},
					["1751271788814983068"] = {
						["key"] = "1751271788814983068",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1568.2796507686476,
							["y"] = 327.5697111107284
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009723,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20023200",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
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
									["TalkActorId"] = 700309,
									["TalkActorVisible"] = false,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1751271788814983069"] = {
						["key"] = "1751271788814983069",
						["type"] = "SendMessageNode",
						["name"] = "切换黑夜",
						["pos"] = {
							["x"] = 1859.8482175583492,
							["y"] = 306.2430313562379
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["1751271788814983070"] = {
						["key"] = "1751271788814983070",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "1为拒绝任务，0为接受任务",
						["pos"] = {
							["x"] = 751.816010492254,
							["y"] = 270.6682095418345
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "BoxSide",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["1751271788814983071"] = {
						["key"] = "1751271788814983071",
						["type"] = "TalkNode",
						["name"] = "拒绝任务后再次对话",
						["pos"] = {
							["x"] = 1468.9588564245723,
							["y"] = 14.953931197440134
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700309,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Xiangzi_SSS_1191557",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51009838,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
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
					["1751271788814983072"] = {
						["key"] = "1751271788814983072",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2787.4203695923784,
							["y"] = 411.1077704058643
						},
						["propsData"] = {
							["VarName"] = "BoxSide",
							["VarValue"] = 1
						}
					},
					["1751271788814983073"] = {
						["key"] = "1751271788814983073",
						["type"] = "SendMessageNode",
						["name"] = "切换黑夜",
						["pos"] = {
							["x"] = 1875.1493229826738,
							["y"] = 36.85868843210528
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["1751271788814983074"] = {
						["key"] = "1751271788814983074",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2238.1564258131757,
							["y"] = 203.64403095568346
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009725,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
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
							["SwitchToMaster"] = "Player",
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