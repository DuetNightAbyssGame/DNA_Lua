return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17638002665441207",
			["startPort"] = "Success",
			["endStory"] = "17638028299192474",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638028299192474",
			["startPort"] = "Success",
			["endStory"] = "17638032568433322",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638032568433322",
			["startPort"] = "Success",
			["endStory"] = "17637307484564801684",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17637307484564801681",
			["startPort"] = "StoryStart",
			["endStory"] = "17638002665441207",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17637307484564801681"] = {
			["isStoryNode"] = true,
			["key"] = "17637307484564801681",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 799.1428571428571,
				["y"] = 299.14285714285717
			},
			["propsData"] = {
				["QuestChainId"] = 120305
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17637307484564801684"] = {
			["isStoryNode"] = true,
			["key"] = "17637307484564801684",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1402.42199055511,
				["y"] = 528.6515192016395
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17637311733055486511"] = {
			["isStoryNode"] = true,
			["key"] = "17637311733055486511",
			["type"] = "StoryNode",
			["name"] = "山外山探索",
			["pos"] = {
				["x"] = 1109.7357357357357,
				["y"] = 21.123123123123264
			},
			["propsData"] = {
				["QuestId"] = 12030501,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120305_1",
				["QuestDeatil"] = "Content__120305_1",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17637311733055486512",
						["startPort"] = "QuestStart",
						["endQuest"] = "17637312708015487025",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637312708015487025",
						["startPort"] = "Out",
						["endQuest"] = "17637311733055486515",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17637311733055486512"] = {
						["key"] = "17637311733055486512",
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
					["17637311733055486515"] = {
						["key"] = "17637311733055486515",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1594,
							["y"] = 322
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637311733055486518"] = {
						["key"] = "17637311733055486518",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17637312708015487025"] = {
						["key"] = "17637312708015487025",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1208,
							["y"] = 304
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17638002665441207"] = {
			["isStoryNode"] = true,
			["key"] = "17638002665441207",
			["type"] = "StoryNode",
			["name"] = "和苏乙聊天",
			["pos"] = {
				["x"] = 1079.9595112353734,
				["y"] = 290.29879879879877
			},
			["propsData"] = {
				["QuestId"] = 12030502,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120305_2",
				["QuestDeatil"] = "Content__120305_2",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_12030502SSuyi_132360051",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638027982091686",
						["startPort"] = "Out",
						["endQuest"] = "17638002665441213",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176544075146312607589",
						["startPort"] = "Out",
						["endQuest"] = "17638027982091686",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638002665441212",
						["startPort"] = "QuestStart",
						["endQuest"] = "17725911950222264",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725911950222264",
						["startPort"] = "Out",
						["endQuest"] = "176544075146312607589",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725911950222264",
						["startPort"] = "Out",
						["endQuest"] = "17725912780941208160",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17725911950222264",
						["startPort"] = "Out",
						["endQuest"] = "1773646482083876309",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773646482083876309",
						["startPort"] = "Out",
						["endQuest"] = "176673737283410651853",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17638002665441212"] = {
						["key"] = "17638002665441212",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 361.51111111111106,
							["y"] = 289.2888888888889
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638002665441213"] = {
						["key"] = "17638002665441213",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1482.888888888889,
							["y"] = 290.8888888888889
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638002665441214"] = {
						["key"] = "17638002665441214",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17638027982091686"] = {
						["key"] = "17638027982091686",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1201.4574314574313,
							["y"] = 272.4761904761905
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250003,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030502SSuyi_132360051",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062101.12062101'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030501",
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
					["176544051314212606123"] = {
						["key"] = "176544051314212606123",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1741.2192420152946,
							["y"] = 632.0038798920378
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105201,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["176544075146312607589"] = {
						["key"] = "176544075146312607589",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 921.8224166184691,
							["y"] = 288.7340386221964
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132360051
							}
						}
					},
					["176673737283410651853"] = {
						["key"] = "176673737283410651853",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1250.25,
							["y"] = 471.69117717321046
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12062015,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17725911950222264"] = {
						["key"] = "17725911950222264",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 640.495634920635,
							["y"] = 272.86352813852795
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 105201,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17725912780941208160"] = {
						["key"] = "17725912780941208160",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 922.8194444444446,
							["y"] = 127.38416305916286
						},
						["propsData"] = {
							["TargetTime"] = 22,
							["NeedLerp"] = false,
							["LerpTime"] = 0
						}
					},
					["1773646482083876309"] = {
						["key"] = "1773646482083876309",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 918.6985294117649,
							["y"] = 471.4191176470588
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East02/RegionUI/Show_Reb_RegionUI_N",
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
							["HideMechanismsFX"] = false,
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
					}
				},
				["commentData"] = {}
			}
		},
		["17638028299192474"] = {
			["isStoryNode"] = true,
			["key"] = "17638028299192474",
			["type"] = "StoryNode",
			["name"] = "唐叔",
			["pos"] = {
				["x"] = 1399.202020233547,
				["y"] = 286.7319820098467
			},
			["propsData"] = {
				["QuestId"] = 12030503,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120305_3",
				["QuestDeatil"] = "Content__120305_3",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestSign_1203050301",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638028299192482",
						["startPort"] = "Out",
						["endQuest"] = "17638028299192480",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17638028299192479",
						["startPort"] = "QuestStart",
						["endQuest"] = "17707943274063487943",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17707943274063487943",
						["startPort"] = "Out",
						["endQuest"] = "176544182012813658589",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176544182012813658589",
						["startPort"] = "Out",
						["endQuest"] = "17667372499068521231",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177200326477815086534",
						["startPort"] = "Out",
						["endQuest"] = "17638028299192482",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17707956615473489579",
						["startPort"] = "Out",
						["endQuest"] = "17719999619383484909",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17719999619383484909",
						["startPort"] = "Out",
						["endQuest"] = "177200326477815086534",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176544182012813658589",
						["startPort"] = "Out",
						["endQuest"] = "17719999321703484038",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17719999321703484038",
						["startPort"] = "Out",
						["endQuest"] = "17720027165609286601",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720027165609286601",
						["startPort"] = "Out",
						["endQuest"] = "17707956615473489579",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17707956615473489579",
						["startPort"] = "Out",
						["endQuest"] = "17722463014891187169",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177200326477815086534",
						["startPort"] = "Out",
						["endQuest"] = "177267932175219628398",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17638028299192479"] = {
						["key"] = "17638028299192479",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -200.54508712566104,
							["y"] = 288.42791926772253
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638028299192480"] = {
						["key"] = "17638028299192480",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1983.7907890040844,
							["y"] = 324.21538240556964
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638028299192481"] = {
						["key"] = "17638028299192481",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1915.8823529411766,
							["y"] = 671.7647058823529
						},
						["propsData"] = {}
					},
					["17638028299192482"] = {
						["key"] = "17638028299192482",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1658.6209775882678,
							["y"] = 316.1461996270506
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "UI_Npc_Name_250024",
							["NpcId"] = 250024,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030503Tangshu_132360066",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 12062201,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
					["176544182012813658589"] = {
						["key"] = "176544182012813658589",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 354.7972556420329,
							["y"] = 288.0872212192903
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132360052,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestSign_1203050301"
						}
					},
					["17667372499068521231"] = {
						["key"] = "17667372499068521231",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 642.4742288672554,
							["y"] = 88.03816196714308
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12062118,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["176794847876228690659"] = {
						["key"] = "176794847876228690659",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 182.98505501327026,
							["y"] = 636.8683760786191
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132360066
							}
						}
					},
					["17707943274063487943"] = {
						["key"] = "17707943274063487943",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 77.68549850876558,
							["y"] = 286.01865762889025
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								312360078,
								132360066
							}
						}
					},
					["17707956615473489579"] = {
						["key"] = "17707956615473489579",
						["type"] = "ListenActorDestroyNode",
						["name"] = "监听Actor销毁节点",
						["pos"] = {
							["x"] = 1002.297191450075,
							["y"] = 368.191655624915
						},
						["propsData"] = {
							["StaticCreatorId"] = 312360078,
							["DestroyReason"] = "Breakable"
						}
					},
					["17719999321703484038"] = {
						["key"] = "17719999321703484038",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 643.7245005794427,
							["y"] = 289.0239579541233
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestSign_1203050301"
						}
					},
					["17719999619383484909"] = {
						["key"] = "17719999619383484909",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1233.151267003655,
							["y"] = 130.21880092808246
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestSign_1203050301"
						}
					},
					["17720027165609286601"] = {
						["key"] = "17720027165609286601",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 642.8958514454811,
							["y"] = 489.35351203392867
						},
						["propsData"] = {
							["NewDescription"] = "Description_120305_4",
							["NewDetail"] = "Content__120305_4",
							["SubTaskTargetIndex"] = 0
						}
					},
					["177200326477815086534"] = {
						["key"] = "177200326477815086534",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1408.7814258020971,
							["y"] = 335.4442489008285
						},
						["propsData"] = {
							["NewDescription"] = "Description_120305_5",
							["NewDetail"] = "Content__120305_5",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17722463014891187169"] = {
						["key"] = "17722463014891187169",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1405.4777310924367,
							["y"] = 566.9455691367459
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12062226,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["177267931606619628207"] = {
						["key"] = "177267931606619628207",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 640.4210526315791,
							["y"] = -67.63815789473695
						},
						["propsData"] = {
							["TargetTime"] = 22,
							["NeedLerp"] = true,
							["LerpTime"] = 0
						}
					},
					["177267932175219628398"] = {
						["key"] = "177267932175219628398",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1674.6315789473686,
							["y"] = 497.62499999999994
						},
						["propsData"] = {
							["TargetTime"] = 22,
							["NeedLerp"] = true,
							["LerpTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17638032568433322"] = {
			["isStoryNode"] = true,
			["key"] = "17638032568433322",
			["type"] = "StoryNode",
			["name"] = "调查",
			["pos"] = {
				["x"] = 1079.0201950887576,
				["y"] = 526.8282230814114
			},
			["propsData"] = {
				["QuestId"] = 12030504,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120305_6",
				["QuestDeatil"] = "Content__120305_6",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203050401_132360053",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638032568433327",
						["startPort"] = "QuestStart",
						["endQuest"] = "176544271583314709394",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176544271583314709394",
						["startPort"] = "Out",
						["endQuest"] = "17638032568433330",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638032568433330",
						["startPort"] = "Out",
						["endQuest"] = "17638032568433328",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17638032568433327",
						["startPort"] = "QuestStart",
						["endQuest"] = "17726165802737350431",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638032568433330",
						["startPort"] = "Out",
						["endQuest"] = "17726234552518574799",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17638032568433327"] = {
						["key"] = "17638032568433327",
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
					["17638032568433328"] = {
						["key"] = "17638032568433328",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1839.0105042016808,
							["y"] = 311.4590336134454
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638032568433329"] = {
						["key"] = "17638032568433329",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1915.8823529411766,
							["y"] = 671.7647058823529
						},
						["propsData"] = {}
					},
					["17638032568433330"] = {
						["key"] = "17638032568433330",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1483.9220779220782,
							["y"] = 294.9269480519481
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062301.12062301'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030503",
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
					["176544271583314709394"] = {
						["key"] = "176544271583314709394",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1128.1488095238096,
							["y"] = 293.6397058823529
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132360053,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203050401_132360053"
						}
					},
					["17726165802737350431"] = {
						["key"] = "17726165802737350431",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1126.1666666666667,
							["y"] = 128
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132360086
							}
						}
					},
					["17726234552518574799"] = {
						["key"] = "17726234552518574799",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1729.6301054018443,
							["y"] = 111.54743083003962
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132360086
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17638032801813533"] = {
			["isStoryNode"] = true,
			["key"] = "17638032801813533",
			["type"] = "StoryNode",
			["name"] = "战斗",
			["pos"] = {
				["x"] = 1447.2394636015324,
				["y"] = 850.2586206896552
			},
			["propsData"] = {
				["QuestId"] = 12030505,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120305_5",
				["QuestDeatil"] = "Content__120305_5",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638032801823541",
						["startPort"] = "Out",
						["endQuest"] = "17638032801823539",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17638032801823538",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763803576959692317",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763803576959692317",
						["startPort"] = "Out",
						["endQuest"] = "17638032801823541",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17638032801823538"] = {
						["key"] = "17638032801823538",
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
					["17638032801823539"] = {
						["key"] = "17638032801823539",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1884,
							["y"] = 312
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638032801823540"] = {
						["key"] = "17638032801823540",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1915.8823529411766,
							["y"] = 671.7647058823529
						},
						["propsData"] = {}
					},
					["17638032801823541"] = {
						["key"] = "17638032801823541",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1528.857142857143,
							["y"] = 294.2857142857143
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 100001,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1763803576959692317"] = {
						["key"] = "1763803576959692317",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1121.7031180893412,
							["y"] = 301.2298931718438
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}