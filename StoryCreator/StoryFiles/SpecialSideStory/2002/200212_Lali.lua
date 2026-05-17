return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "171851537017911649682",
			["startPort"] = "Success",
			["endStory"] = "171851537017911649683",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17423777018509366883",
			["startPort"] = "分支2",
			["endStory"] = "171851537017911649682",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17423777018509366883",
			["startPort"] = "分支1",
			["endStory"] = "174237791652810932038",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17423749088913123451",
			["startPort"] = "Success",
			["endStory"] = "17423777018509366883",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174237791652810932038",
			["startPort"] = "Success",
			["endStory"] = "171851537017911649680",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "171851537017911649683",
			["startPort"] = "Success",
			["endStory"] = "171851537017911649680",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "171851537017911649679",
			["startPort"] = "StoryStart",
			["endStory"] = "17512712880827192918",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17512712880827192918",
			["startPort"] = "Success",
			["endStory"] = "17423749088913123451",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["171851537017911649679"] = {
			["isStoryNode"] = true,
			["key"] = "171851537017911649679",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = -249.20735785953192,
				["y"] = 226.64882943143806
			},
			["propsData"] = {
				["QuestChainId"] = 200212
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["171851537017911649680"] = {
			["isStoryNode"] = true,
			["key"] = "171851537017911649680",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1462.556139512661,
				["y"] = 183.3397037744864
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["171851537017911649682"] = {
			["isStoryNode"] = true,
			["key"] = "171851537017911649682",
			["type"] = "StoryNode",
			["name"] = "和凯文对话",
			["pos"] = {
				["x"] = 833.5015440072106,
				["y"] = 298.36677901935343
			},
			["propsData"] = {
				["QuestId"] = 20021202,
				["QuestDescriptionComment"] = "和凯文对话",
				["QuestDescription"] = "Description_200212_2",
				["QuestDeatil"] = "Content_200212_2",
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
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_KaiwenChangzhu_1190512",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "171851537017911649689",
						["startPort"] = "QuestStart",
						["endQuest"] = "17180898560621425160",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17180898560621425160",
						["startPort"] = "Out",
						["endQuest"] = "171851537017911649690",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17180898560621425160"] = {
						["key"] = "17180898560621425160",
						["type"] = "WaitImpressionTalkCompleteNode",
						["name"] = "等待印象对话完成",
						["pos"] = {
							["x"] = 1034.821922441612,
							["y"] = 295.1751036552621
						},
						["propsData"] = {
							["ImpressionTalkTriggerId"] = 510026,
							["bShowGuide"] = true,
							["GuideType"] = "N",
							["NPCStaticCreaterName"] = "Npc_KaiwenChangzhu_1190512"
						}
					},
					["171851537017911649689"] = {
						["key"] = "171851537017911649689",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 752.5439777613691,
							["y"] = 294.2592407592408
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537017911649690"] = {
						["key"] = "171851537017911649690",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1334.1443143812712,
							["y"] = 296.6266602962255
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537017911649691"] = {
						["key"] = "171851537017911649691",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["171851537017911649683"] = {
			["isStoryNode"] = true,
			["key"] = "171851537017911649683",
			["type"] = "StoryNode",
			["name"] = "再次和拉里对话",
			["pos"] = {
				["x"] = 1141.9066063361863,
				["y"] = 309.6300640435081
			},
			["propsData"] = {
				["QuestId"] = 20021203,
				["QuestDescriptionComment"] = "再次和拉里对话",
				["QuestDescription"] = "Description_200212_3",
				["QuestDeatil"] = "Content_200212_3",
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
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_LaliChangzhu_1190520",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "171851537017911649692",
						["startPort"] = "QuestStart",
						["endQuest"] = "1742384122051786177",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1742384122051786177",
						["startPort"] = "Out",
						["endQuest"] = "17423842186232349841",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423842186232349841",
						["startPort"] = "Success",
						["endQuest"] = "171851537017911649693",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17423842186232349841",
						["startPort"] = "Fail",
						["endQuest"] = "171851537017911649694",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17423842186232349841",
						["startPort"] = "PassiveFail",
						["endQuest"] = "171851537017911649694",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["171851537017911649692"] = {
						["key"] = "171851537017911649692",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 959.69574507618,
							["y"] = 324.9349684132292
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537017911649693"] = {
						["key"] = "171851537017911649693",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2055.3803790412485,
							["y"] = 307.7308037373256
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537017911649694"] = {
						["key"] = "171851537017911649694",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2048.333333333333,
							["y"] = 430
						},
						["propsData"] = {}
					},
					["1742384122051786177"] = {
						["key"] = "1742384122051786177",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1264.3333333333335,
							["y"] = 309.6666666666667
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700113,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_LaliChangzhu_1190520",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51002701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20021203",
							["BlendInTime"] = 0.5,
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
									["TalkActorId"] = 700112,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700114,
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
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17423842186232349841"] = {
						["key"] = "17423842186232349841",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1689.3333333333335,
							["y"] = 353.00000000000006
						},
						["propsData"] = {
							["SpecialConfigId"] = 1047,
							["BlackScreenImmediately"] = true
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17423749088913123451"] = {
			["isStoryNode"] = true,
			["key"] = "17423749088913123451",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 96.9195553806805,
				["y"] = 229.54280961923396
			},
			["propsData"] = {
				["QuestId"] = 20021205,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200212_6",
				["QuestDeatil"] = "Content_200212_6",
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "BP_Drop_Lali_Side_1240611",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17423757407583904174",
						["startPort"] = "Out",
						["endQuest"] = "17423757459053904346",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423758528113905034",
						["startPort"] = "Out",
						["endQuest"] = "17423749088913123458",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17423757459053904346",
						["startPort"] = "Out",
						["endQuest"] = "17423758406213904864",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423757459053904346",
						["startPort"] = "Fail",
						["endQuest"] = "17423758528113905034",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423759024934685603",
						["startPort"] = "Out",
						["endQuest"] = "17423757407583904174",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423757407583904174",
						["startPort"] = "Out",
						["endQuest"] = "17423759096304685923",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423749088913123452",
						["startPort"] = "QuestStart",
						["endQuest"] = "17423869214736260688",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423869214736260688",
						["startPort"] = "Out",
						["endQuest"] = "17423759024934685603",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423759096304685923",
						["startPort"] = "Out",
						["endQuest"] = "17423869303936261108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17425537253152233",
						["startPort"] = "Out",
						["endQuest"] = "17425537624032803",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423758406213904864",
						["startPort"] = "Out",
						["endQuest"] = "17425537832733194",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17425537832733194",
						["startPort"] = "Out",
						["endQuest"] = "17425537253152233",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17425537624032803",
						["startPort"] = "Out",
						["endQuest"] = "17452929499942182759",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17452929499942182759",
						["startPort"] = "Out",
						["endQuest"] = "17423749088913123455",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17423749088913123452"] = {
						["key"] = "17423749088913123452",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 361.1094452773612,
							["y"] = 268.920539730135
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17423749088913123455"] = {
						["key"] = "17423749088913123455",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3308.796338672769,
							["y"] = 194.27002288329516
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17423749088913123458"] = {
						["key"] = "17423749088913123458",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2280.086956521739,
							["y"] = 490.17391304347825
						},
						["propsData"] = {}
					},
					["17423757407583904174"] = {
						["key"] = "17423757407583904174",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1276.4689655172415,
							["y"] = 301.9310344827586
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11015,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17423757459053904346"] = {
						["key"] = "17423757459053904346",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1576.4622425629289,
							["y"] = 314.8108314263921
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51008012,
							["FlowAssetPath"] = "",
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
							["TalkActors"] = {},
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
					["17423758406213904864"] = {
						["key"] = "17423758406213904864",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1911.9862700228834,
							["y"] = 155.51965883087146
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51008014,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17423758528113905034"] = {
						["key"] = "17423758528113905034",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1906.282608695652,
							["y"] = 391.3320158102765
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51008013,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17423759024934685603"] = {
						["key"] = "17423759024934685603",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 902.4916909966073,
							["y"] = 312.94692264257475
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240611
							}
						}
					},
					["17423759096304685923"] = {
						["key"] = "17423759096304685923",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1572.2608695652177,
							["y"] = 508.72332015810264
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240611
							}
						}
					},
					["17423869214736260688"] = {
						["key"] = "17423869214736260688",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 643.8093596059116,
							["y"] = 301.48571428571427
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_Drop_Lali_Side_1240611"
						}
					},
					["17423869303936261108"] = {
						["key"] = "17423869303936261108",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1856.5679802955667,
							["y"] = 542.520197044335
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_Drop_Lali_Side_1240611"
						}
					},
					["17425537253152233"] = {
						["key"] = "17425537253152233",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2217.5789473684213,
							["y"] = 148.40131578947356
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240638,
								1240639,
								1240640,
								1240641,
								1240642
							}
						}
					},
					["17425537624032803"] = {
						["key"] = "17425537624032803",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2501.789473684211,
							["y"] = 137.34868421052622
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1240638,
								1240639,
								1240640,
								1240641,
								1240642
							}
						}
					},
					["17425537832733194"] = {
						["key"] = "17425537832733194",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2081.789473684211,
							["y"] = -131.0723684210527
						},
						["propsData"] = {
							["NewDescription"] = "Description_200212_8",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17452929499942182759"] = {
						["key"] = "17452929499942182759",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2840,
							["y"] = 198
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51008054,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
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
							["TalkActors"] = {},
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
		["17423777018509366883"] = {
			["isStoryNode"] = true,
			["key"] = "17423777018509366883",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 412.41170653595555,
				["y"] = 182.29076033355904
			},
			["propsData"] = {
				["QuestId"] = 20021206,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200212_7",
				["QuestDeatil"] = "Content_200212_6",
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "BP_Drop_Lali_Side_1240611",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174237779829310147964",
						["startPort"] = "Out",
						["endQuest"] = "174237780788510148282",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237780788510148282",
						["startPort"] = "Out",
						["endQuest"] = "174237779939510148022",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237779939510148022",
						["startPort"] = "Out",
						["endQuest"] = "174237781785910148484",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237781785910148484",
						["startPort"] = "Out",
						["endQuest"] = "174237779983510148032",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237779983510148032",
						["startPort"] = "Out",
						["endQuest"] = "174237781738510148475",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237781738510148475",
						["startPort"] = "Out",
						["endQuest"] = "174237780024810148063",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237780024810148063",
						["startPort"] = "Out",
						["endQuest"] = "174237784851910149901",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1742383028086785323",
						["startPort"] = "Out",
						["endQuest"] = "174237789216410150778",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1742383019901785103",
						["startPort"] = "Out",
						["endQuest"] = "174237788450410150648",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237780024810148063",
						["startPort"] = "Out",
						["endQuest"] = "17423858795173915728",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237779829310147964",
						["startPort"] = "Out",
						["endQuest"] = "17423869381656261413",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237779939510148022",
						["startPort"] = "Out",
						["endQuest"] = "17423869421236261562",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237779983510148032",
						["startPort"] = "Out",
						["endQuest"] = "17423869427086261591",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237780024810148063",
						["startPort"] = "Out",
						["endQuest"] = "17423869431326261618",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423858795173915728",
						["startPort"] = "Out",
						["endQuest"] = "17423878277787044917",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423777696929367641",
						["startPort"] = "Out",
						["endQuest"] = "174237779829310147964",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237780788510148282",
						["startPort"] = "Out",
						["endQuest"] = "174290545439713273420",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237781785910148484",
						["startPort"] = "Out",
						["endQuest"] = "174290548993013274659",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237781738510148475",
						["startPort"] = "Out",
						["endQuest"] = "174290545472413273424",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237784851910149901",
						["startPort"] = "Option_1",
						["endQuest"] = "1742383019901785103",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237784851910149901",
						["startPort"] = "Option_2",
						["endQuest"] = "1742383028086785323",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423777018509366888",
						["startPort"] = "QuestStart",
						["endQuest"] = "17423777696929367641",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17423777018509366888"] = {
						["key"] = "17423777018509366888",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 165.22481766786183,
							["y"] = 191.24809560812054
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17423777018509366889"] = {
						["key"] = "17423777018509366889",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1979.453416149068,
							["y"] = 1076.1987577639752
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17423777018509366890"] = {
						["key"] = "17423777018509366890",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2002.2919254658384,
							["y"] = 1054.614906832298
						},
						["propsData"] = {}
					},
					["17423777696929367641"] = {
						["key"] = "17423777696929367641",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 494.31021501381906,
							["y"] = 185.55806444979612
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240612
							}
						}
					},
					["174237779829310147964"] = {
						["key"] = "174237779829310147964",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 738.6467540496336,
							["y"] = 190.77392706581006
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11016,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "BP_Drop1240612",
							["IsUseCount"] = false
						}
					},
					["174237779939510148022"] = {
						["key"] = "174237779939510148022",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 795.4776183336901,
							["y"] = 380.8255001605384
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11017,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "BP_Drop1240613",
							["IsUseCount"] = false
						}
					},
					["174237779983510148032"] = {
						["key"] = "174237779983510148032",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 790.5134810841331,
							["y"] = 567.3472392909732
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11018,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "BP_Drop1240614",
							["IsUseCount"] = false
						}
					},
					["174237780024810148063"] = {
						["key"] = "174237780024810148063",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 764.6011597098551,
							["y"] = 827.3402082785074
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11019,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "BP_Drop1240615",
							["IsUseCount"] = false
						}
					},
					["174237780788510148282"] = {
						["key"] = "174237780788510148282",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1105.0494442628308,
							["y"] = 179.51829192255218
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51008018,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "",
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
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174237781738510148475"] = {
						["key"] = "174237781738510148475",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1116.2665495259887,
							["y"] = 567.3472392909732
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51008021,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174237781785910148484"] = {
						["key"] = "174237781785910148484",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1126.9244442628308,
							["y"] = 383.5972392909732
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51008020,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174237784851910149901"] = {
						["key"] = "174237784851910149901",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1108.599170852031,
							["y"] = 785.5075263723129
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51008022,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "",
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
							["OptionType"] = "plus",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["PlusOptions"] = {
								{
									["OptionText"] = "51008031",
									["PlusId"] = 1005,
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								},
								{
									["OptionText"] = "51008032",
									["PlusId"] = 1002,
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["174237788450410150648"] = {
						["key"] = "174237788450410150648",
						["type"] = "QuestConditionNode",
						["name"] = "QuestCondition",
						["pos"] = {
							["x"] = 1762.8306636155603,
							["y"] = 813.9612062736472
						},
						["propsData"] = {
							["PortName"] = "分支1"
						}
					},
					["174237789216410150778"] = {
						["key"] = "174237789216410150778",
						["type"] = "QuestConditionNode",
						["name"] = "QuestCondition",
						["pos"] = {
							["x"] = 1743.4734172387487,
							["y"] = 972.289984741556
						},
						["propsData"] = {
							["PortName"] = "分支2"
						}
					},
					["1742383019901785103"] = {
						["key"] = "1742383019901785103",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1461.8333333333335,
							["y"] = 803.5833333333334
						},
						["propsData"] = {
							["VarName"] = "LarryChoice",
							["VarValue"] = 1
						}
					},
					["1742383028086785323"] = {
						["key"] = "1742383028086785323",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1445.5238095238096,
							["y"] = 977.0714285714283
						},
						["propsData"] = {
							["VarName"] = "LarryChoice",
							["VarValue"] = 2
						}
					},
					["17423858795173915728"] = {
						["key"] = "17423858795173915728",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1028.3744019138758,
							["y"] = 1061.3106060606062
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_LaLiSide"
						}
					},
					["17423869381656261413"] = {
						["key"] = "17423869381656261413",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1064.578042390178,
							["y"] = -1.4264157940433362
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240612
							}
						}
					},
					["17423869421236261562"] = {
						["key"] = "17423869421236261562",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 499.3636889426363,
							["y"] = 429.01501035196696
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240613
							}
						}
					},
					["17423869427086261591"] = {
						["key"] = "17423869427086261591",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 437.98277009032165,
							["y"] = 661.2892578436058
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240614
							}
						}
					},
					["17423869431326261618"] = {
						["key"] = "17423869431326261618",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 754.0016928151941,
							["y"] = 1072.5363974317065
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240615
							}
						}
					},
					["17423878277787044917"] = {
						["key"] = "17423878277787044917",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1381.5584316522534,
							["y"] = 1229.8362663906144
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240616,
								1240617,
								1240618
							}
						}
					},
					["174290545439713273420"] = {
						["key"] = "174290545439713273420",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1474.9868421052631,
							["y"] = 144.12280701754395
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240613
							}
						}
					},
					["174290545472413273424"] = {
						["key"] = "174290545472413273424",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1389.7236842105262,
							["y"] = 532.543859649123
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240615
							}
						}
					},
					["174290548993013274659"] = {
						["key"] = "174290548993013274659",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1433.934210526316,
							["y"] = 332.2368421052634
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240614
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174237791652810932038"] = {
			["isStoryNode"] = true,
			["key"] = "174237791652810932038",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 840.6341286151549,
				["y"] = 49.026546286736334
			},
			["propsData"] = {
				["QuestId"] = 20021207,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200212_3",
				["QuestDeatil"] = "Content_200212_7",
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
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_LaliChangzhu_1190520",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174237791652810932039",
						["startPort"] = "QuestStart",
						["endQuest"] = "174237914185913281519",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174237914185913281519",
						["startPort"] = "Out",
						["endQuest"] = "17423826998451894",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17423826998451894",
						["startPort"] = "Success",
						["endQuest"] = "174237791652810932042",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17423826998451894",
						["startPort"] = "Fail",
						["endQuest"] = "174237791652810932045",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17423826998451894",
						["startPort"] = "PassiveFail",
						["endQuest"] = "174237791652810932045",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["174237791652810932039"] = {
						["key"] = "174237791652810932039",
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
					["174237791652810932042"] = {
						["key"] = "174237791652810932042",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2075.719540229885,
							["y"] = 300.9655172413793
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174237791652810932045"] = {
						["key"] = "174237791652810932045",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2083.103448275862,
							["y"] = 519.3103448275862
						},
						["propsData"] = {}
					},
					["174237914185913281519"] = {
						["key"] = "174237914185913281519",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1230.1973757439462,
							["y"] = 293.84270364817587
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700113,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_LaliChangzhu_1190520",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51008033,
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17423826998451894"] = {
						["key"] = "17423826998451894",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1572.9770114942528,
							["y"] = 299.0229885057471
						},
						["propsData"] = {
							["SpecialConfigId"] = 1047,
							["BlackScreenImmediately"] = true
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17512712880827192918"] = {
			["isStoryNode"] = true,
			["key"] = "17512712880827192918",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = -25.74596273291904,
				["y"] = -19.259006211180157
			},
			["propsData"] = {
				["QuestId"] = 20021200,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 101101,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_LaliChangzhu_1190520",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17512712880837192922",
						["startPort"] = "QuestStart",
						["endQuest"] = "17512712880837192926",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512712880837192926",
						["startPort"] = "false",
						["endQuest"] = "17512712880837192927",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512712880837192927",
						["startPort"] = "Out",
						["endQuest"] = "17512712880837192924",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17512712880837192926",
						["startPort"] = "true",
						["endQuest"] = "17512712880837192928",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512712880837192928",
						["startPort"] = "Out",
						["endQuest"] = "17512712880837192924",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17512712880837192924",
						["startPort"] = "ApproveOut",
						["endQuest"] = "17512712880837192929",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512712880837192929",
						["startPort"] = "Out",
						["endQuest"] = "17512712880837192923",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17512712880837192924",
						["startPort"] = "CancelOut",
						["endQuest"] = "17512712880837192930",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512712880837192930",
						["startPort"] = "Out",
						["endQuest"] = "17512712880837192925",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17512712880837192922"] = {
						["key"] = "17512712880837192922",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 529.1538461538462,
							["y"] = 203.12637362637363
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17512712880837192923"] = {
						["key"] = "17512712880837192923",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2140.7142857142853,
							["y"] = 232.14285714285714
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17512712880837192924"] = {
						["key"] = "17512712880837192924",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1537.1397515527951,
							["y"] = 236.3664596273292
						},
						["propsData"] = {
							["SideQuestChainId"] = 200212,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["17512712880837192925"] = {
						["key"] = "17512712880837192925",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2094.1506554550033,
							["y"] = 465.9886764234591
						},
						["propsData"] = {}
					},
					["17512712880837192926"] = {
						["key"] = "17512712880837192926",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 830.2769230769233,
							["y"] = 193.0049450549452
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "LarrySide",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["17512712880837192927"] = {
						["key"] = "17512712880837192927",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1165.0371997567652,
							["y"] = 227.89032054901642
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700113,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_LaliChangzhu_1190520",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51008001,
							["FlowAssetPath"] = "",
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
					["17512712880837192928"] = {
						["key"] = "17512712880837192928",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1161.7551839464886,
							["y"] = 35.167988533206156
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700113,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_LaliChangzhu_1190520",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51008009,
							["FlowAssetPath"] = "",
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
					["17512712880837192929"] = {
						["key"] = "17512712880837192929",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1815.9312426703734,
							["y"] = 237.8263736263739
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51008010,
							["FlowAssetPath"] = "",
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17512712880837192930"] = {
						["key"] = "17512712880837192930",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1749.6015984015985,
							["y"] = 459.5722798940194
						},
						["propsData"] = {
							["VarName"] = "LarrySide",
							["VarValue"] = 1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}