return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17667354230631",
			["startPort"] = "StoryStart",
			["endStory"] = "1766736317895331",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1766736317895331",
			["startPort"] = "Success",
			["endStory"] = "1766736324013532",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1766736324013532",
			["startPort"] = "Success",
			["endStory"] = "1766736339901917",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17667363634781216",
			["startPort"] = "Success",
			["endStory"] = "17667363830501493",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1766736339901917",
			["startPort"] = "Success",
			["endStory"] = "17667372901592143028",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17667372901592143028",
			["startPort"] = "Success",
			["endStory"] = "17667363634781216",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17667363830501493",
			["startPort"] = "Success",
			["endStory"] = "17667354230645",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17667354230631"] = {
			["isStoryNode"] = true,
			["key"] = "17667354230631",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 593.2173913043478,
				["y"] = 300.60869565217394
			},
			["propsData"] = {
				["QuestChainId"] = 200313
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17667354230645"] = {
			["isStoryNode"] = true,
			["key"] = "17667354230645",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1752.2608695652173,
				["y"] = 299.0434782608696
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1766736317895331"] = {
			["isStoryNode"] = true,
			["key"] = "1766736317895331",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 1006.4347826086957,
				["y"] = 70.63043478260882
			},
			["propsData"] = {
				["QuestId"] = 20031301,
				["QuestDescriptionComment"] = "Content_200313_1",
				["SubRegionId"] = 104108,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_ChenBaiSha_2090854",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1766736317895348",
						["startPort"] = "CancelOut",
						["endQuest"] = "1766736317895360",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1766736317895348",
						["startPort"] = "ApproveOut",
						["endQuest"] = "1766736317895340",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1766736317895332",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667368352486413",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766736317895332",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667368543066687",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667368352486413",
						["startPort"] = "Out",
						["endQuest"] = "17667368998297172",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667368998297172",
						["startPort"] = "Out",
						["endQuest"] = "1766736317895348",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["1766736317895332"] = {
						["key"] = "1766736317895332",
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
					["1766736317895340"] = {
						["key"] = "1766736317895340",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2402,
							["y"] = 304
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766736317895348"] = {
						["key"] = "1766736317895348",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1805.909090909091,
							["y"] = 279.8181818181818
						},
						["propsData"] = {
							["SideQuestChainId"] = 200313,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["1766736317895360"] = {
						["key"] = "1766736317895360",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2416,
							["y"] = 706
						},
						["propsData"] = {}
					},
					["17667368352486413"] = {
						["key"] = "17667368352486413",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成陈白沙",
						["pos"] = {
							["x"] = 1090.563596491228,
							["y"] = 293.719298245614
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090854
							}
						}
					},
					["17667368543066687"] = {
						["key"] = "17667368543066687",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成茶摊老板",
						["pos"] = {
							["x"] = 1093.1999601275918,
							["y"] = 494.81020733652315
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090855
							}
						}
					},
					["17667368998297172"] = {
						["key"] = "17667368998297172",
						["type"] = "TalkNode",
						["name"] = "与陈白沙对话",
						["pos"] = {
							["x"] = 1450.4726874003193,
							["y"] = 274.628389154705
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701091,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_ChenBaiSha_2090854",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 51153001,
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
					}
				},
				["commentData"] = {}
			}
		},
		["1766736324013532"] = {
			["isStoryNode"] = true,
			["key"] = "1766736324013532",
			["type"] = "StoryNode",
			["name"] = "在茶摊对话",
			["pos"] = {
				["x"] = 1006.5391304347827,
				["y"] = 269.96273291925473
			},
			["propsData"] = {
				["QuestId"] = 20031302,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200313_2",
				["QuestDeatil"] = "Content_200313_2",
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
				["SubRegionId"] = 104108,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_ChenBaiSha_2090854",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1766736324013533",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667369572461072929",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667369572461072929",
						["startPort"] = "Out",
						["endQuest"] = "17667370116731073710",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667369572461072929",
						["startPort"] = "Out",
						["endQuest"] = "17667370032571073527",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667370032571073527",
						["startPort"] = "Out",
						["endQuest"] = "1766736324013536",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17667369572461072929",
						["startPort"] = "Out",
						["endQuest"] = "17678547573612666",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766736324013533",
						["startPort"] = "QuestStart",
						["endQuest"] = "17682040445801939",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1766736324013533"] = {
						["key"] = "1766736324013533",
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
					["1766736324013536"] = {
						["key"] = "1766736324013536",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2011.4285714285713,
							["y"] = 295.7142857142857
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766736324013539"] = {
						["key"] = "1766736324013539",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17667369572461072929"] = {
						["key"] = "17667369572461072929",
						["type"] = "TalkNode",
						["name"] = "围观争执现场",
						["pos"] = {
							["x"] = 1201.7142857142858,
							["y"] = 271.7142857142857
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51153002,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20031301",
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701090,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701091,
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
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17667370032571073527"] = {
						["key"] = "17667370032571073527",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁陈白沙",
						["pos"] = {
							["x"] = 1627.3142857142857,
							["y"] = 388.79047619047606
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090854
							}
						}
					},
					["17667370116731073710"] = {
						["key"] = "17667370116731073710",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁茶摊老板",
						["pos"] = {
							["x"] = 1617.7142857142856,
							["y"] = 202.10476190476174
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090855
							}
						}
					},
					["17678547573612666"] = {
						["key"] = "17678547573612666",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 1636.6666666666667,
							["y"] = 553.4545454545455
						},
						["propsData"] = {
							["IsHide"] = false,
							["AtmosphereTagList"] = {
								"20031301"
							}
						}
					},
					["17682040445801939"] = {
						["key"] = "17682040445801939",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 1209.328947368421,
							["y"] = 84.29006820119358
						},
						["propsData"] = {
							["IsHide"] = true,
							["AtmosphereTagList"] = {
								"20031301"
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1766736339901917"] = {
			["isStoryNode"] = true,
			["key"] = "1766736339901917",
			["type"] = "StoryNode",
			["name"] = "蒹葭浦遇怪物",
			["pos"] = {
				["x"] = 1009.130434782609,
				["y"] = 469.44099378882004
			},
			["propsData"] = {
				["QuestId"] = 20031303,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200313_3",
				["QuestDeatil"] = "Content_200313_3",
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_PingYuan_2080425",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1766736339901918",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667371769462140686",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667371769462140686",
						["startPort"] = "Out",
						["endQuest"] = "17667372107162141315",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667372107162141315",
						["startPort"] = "Out",
						["endQuest"] = "17667372278082141695",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667372278082141695",
						["startPort"] = "Out",
						["endQuest"] = "1766736339901921",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1766736339901918"] = {
						["key"] = "1766736339901918",
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
					["1766736339901921"] = {
						["key"] = "1766736339901921",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2129.8947368421054,
							["y"] = 298.8421052631579
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766736339901924"] = {
						["key"] = "1766736339901924",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2129.8947368421054,
							["y"] = 698.8421052631579
						},
						["propsData"] = {}
					},
					["17667371769462140686"] = {
						["key"] = "17667371769462140686",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1132,
							["y"] = 272
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080425,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_PingYuan_2080425"
						}
					},
					["17667372107162141315"] = {
						["key"] = "17667372107162141315",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1426.421052631579,
							["y"] = 294
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080427,
								2080428,
								2080429,
								2080430,
								2080426
							}
						}
					},
					["17667372278082141695"] = {
						["key"] = "17667372278082141695",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1760.9473684210527,
							["y"] = 277.36842105263173
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2080426,
								2080427,
								2080428,
								2080429,
								2080430
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17667363634781216"] = {
			["isStoryNode"] = true,
			["key"] = "17667363634781216",
			["type"] = "StoryNode",
			["name"] = "百年春对话",
			["pos"] = {
				["x"] = 1400.8136645962736,
				["y"] = 66.73478260869574
			},
			["propsData"] = {
				["QuestId"] = 20031305,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200313_5",
				["QuestDeatil"] = "Content_200313_5",
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
				["StoryGuidePointName"] = "Npc_ChenBaiSha_2110353",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17667379448052152466",
						["startPort"] = "Out",
						["endQuest"] = "17667375526682147000",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667375947402147830",
						["startPort"] = "Out",
						["endQuest"] = "17667387995272160766",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667375947402147830",
						["startPort"] = "Out",
						["endQuest"] = "17667387995272160765",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667375526682147000",
						["startPort"] = "Out",
						["endQuest"] = "17676162248315332",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17676162248315332",
						["startPort"] = "Out",
						["endQuest"] = "17667375947402147830",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667375947402147830",
						["startPort"] = "Out",
						["endQuest"] = "17678548357773968",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667387995272160766",
						["startPort"] = "Out",
						["endQuest"] = "17689237673482811",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17689237673482811",
						["startPort"] = "Out",
						["endQuest"] = "17667363634781220",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17667363634781217",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667379404902152378",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667363634781217",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667379448052152466",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667363634781217",
						["startPort"] = "QuestStart",
						["endQuest"] = "17678548170553560",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17667363634781217"] = {
						["key"] = "17667363634781217",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -20.944055944056004,
							["y"] = 398.8811188811189
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667363634781220"] = {
						["key"] = "17667363634781220",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2480.8695652173915,
							["y"] = 375.2709030100334
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667363634781223"] = {
						["key"] = "17667363634781223",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2824,
							["y"] = 582
						},
						["propsData"] = {}
					},
					["17667375526682147000"] = {
						["key"] = "17667375526682147000",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 770.9889277389279,
							["y"] = 388.8315850815851
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701092,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_HuLaoBan_2110354",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51153025,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031302",
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701091,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701092,
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
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17667375947402147830"] = {
						["key"] = "17667375947402147830",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1345.2692307692307,
							["y"] = 387.88461538461536
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51153044,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20031302",
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
									["TalkActorId"] = 701091,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701092,
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
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17667379404902152378"] = {
						["key"] = "17667379404902152378",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成陈白沙",
						["pos"] = {
							["x"] = 447.8598484848483,
							["y"] = 228.6054625199361
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110353
							}
						}
					},
					["17667379448052152466"] = {
						["key"] = "17667379448052152466",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成胡老板",
						["pos"] = {
							["x"] = 452.1325757575756,
							["y"] = 379.9690988835725
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110354
							}
						}
					},
					["17667380229722153972"] = {
						["key"] = "17667380229722153972",
						["type"] = "GoToNode",
						["name"] = "前往胡老板",
						["pos"] = {
							["x"] = 14.24912587412571,
							["y"] = 1008.0017329162065
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2110362,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_BaiNianChun_2110362"
						}
					},
					["17667387995272160765"] = {
						["key"] = "17667387995272160765",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁陈白沙",
						["pos"] = {
							["x"] = 1776.1266440350605,
							["y"] = 228.00038643659923
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110353
							}
						}
					},
					["17667387995272160766"] = {
						["key"] = "17667387995272160766",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁胡老板",
						["pos"] = {
							["x"] = 1778.3993713077875,
							["y"] = 381.36402280023555
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110354
							}
						}
					},
					["17676162248315332"] = {
						["key"] = "17676162248315332",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1049.0192307692307,
							["y"] = 393.38461538461536
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51153043,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = false,
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
					["17678548170553560"] = {
						["key"] = "17678548170553560",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 440,
							["y"] = 566
						},
						["propsData"] = {
							["IsHide"] = true,
							["AtmosphereTagList"] = {
								"20031302"
							}
						}
					},
					["17678548357773968"] = {
						["key"] = "17678548357773968",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 1781.0989010989013,
							["y"] = 562.2637362637362
						},
						["propsData"] = {
							["IsHide"] = false,
							["AtmosphereTagList"] = {
								"20031302"
							}
						}
					},
					["17689237673482811"] = {
						["key"] = "17689237673482811",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成陈白沙",
						["pos"] = {
							["x"] = 2132.9084668192218,
							["y"] = 378.6506006864988
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080432
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17667363830501493"] = {
			["isStoryNode"] = true,
			["key"] = "17667363830501493",
			["type"] = "StoryNode",
			["name"] = "前往河滩",
			["pos"] = {
				["x"] = 1406.2231416549794,
				["y"] = 263.78004407934304
			},
			["propsData"] = {
				["QuestId"] = 20031306,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200313_6",
				["QuestDeatil"] = "Content_200313_6",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = true,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_ChenBaiSha_2080432",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17675080839196736",
						["startPort"] = "Out",
						["endQuest"] = "17667381422902156478",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667381422902156478",
						["startPort"] = "Out",
						["endQuest"] = "17667363830511497",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1768391041741367233",
						["startPort"] = "Success",
						["endQuest"] = "17675080839196736",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768391041741367233",
						["startPort"] = "Fail",
						["endQuest"] = "1768391028099366930",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768391041741367233",
						["startPort"] = "PassiveFail",
						["endQuest"] = "1768391028099366930",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667363830501494",
						["startPort"] = "QuestStart",
						["endQuest"] = "17689245982326776",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17689245982326776",
						["startPort"] = "Out",
						["endQuest"] = "1768391041741367233",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768391028099366930",
						["startPort"] = "Out",
						["endQuest"] = "17689236897621769",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17689236897621769",
						["startPort"] = "Out",
						["endQuest"] = "17667363830511500",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17667363830501494"] = {
						["key"] = "17667363830501494",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 905,
							["y"] = 270
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667363830511497"] = {
						["key"] = "17667363830511497",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2639.5882352941176,
							["y"] = 304.8039215686274
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667363830511500"] = {
						["key"] = "17667363830511500",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2642.527568922305,
							["y"] = 507.5960526315792
						},
						["propsData"] = {}
					},
					["17667376864932149633"] = {
						["key"] = "17667376864932149633",
						["type"] = "TalkNode",
						["name"] = "开启跑步对话",
						["pos"] = {
							["x"] = 1398.0526315789473,
							["y"] = 886.9868421052631
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701091,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_ChenBaiSha_2080432",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51153063,
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
							["PauseNpcBT"] = false,
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
					["17667381382762156378"] = {
						["key"] = "17667381382762156378",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成陈白沙",
						["pos"] = {
							["x"] = 1122.5,
							["y"] = 923.375
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080432
							}
						}
					},
					["17667381422902156478"] = {
						["key"] = "17667381422902156478",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁陈白沙",
						["pos"] = {
							["x"] = 2297.2588235294115,
							["y"] = 299.5098039215686
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080432
							}
						}
					},
					["17675080839196736"] = {
						["key"] = "17675080839196736",
						["type"] = "TalkNode",
						["name"] = "完成Fixsimple对话",
						["pos"] = {
							["x"] = 1944.7479946524068,
							["y"] = 291.92684585796036
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51153070,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031303",
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701091,
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
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17675081450338144"] = {
						["key"] = "17675081450338144",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2065.974516840229,
							["y"] = 947.701355661882
						},
						["propsData"] = {
							["WaitTime"] = 30
						}
					},
					["1768391028099366930"] = {
						["key"] = "1768391028099366930",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1948.5714285714287,
							["y"] = 489.42857142857144
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "Point_20031301",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1768391041741367233"] = {
						["key"] = "1768391041741367233",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1667.142857142857,
							["y"] = 267.7142857142857
						},
						["propsData"] = {
							["SpecialConfigId"] = 20031301,
							["BlackScreenImmediately"] = false
						}
					},
					["17689236897621769"] = {
						["key"] = "17689236897621769",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2278.25,
							["y"] = 501.7500000000001
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "ClearKey",
							["UnitId"] = 701091
						}
					},
					["17689242405334523"] = {
						["key"] = "17689242405334523",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 853.25,
							["y"] = 906.75
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "M",
							["GuidePointName"] = ""
						}
					},
					["17689245982326776"] = {
						["key"] = "17689245982326776",
						["type"] = "TalkNode",
						["name"] = "开启跑步对话",
						["pos"] = {
							["x"] = 1333.25,
							["y"] = 269.25000000000006
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701091,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_ChenBaiSha_2080432",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51153063,
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
							["PauseNpcBT"] = false,
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
		["17667372901592143028"] = {
			["isStoryNode"] = true,
			["key"] = "17667372901592143028",
			["type"] = "StoryNode",
			["name"] = "蒹葭浦对话",
			["pos"] = {
				["x"] = 1017.2671208174716,
				["y"] = 676.5635234330888
			},
			["propsData"] = {
				["QuestId"] = 20031304,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200313_4",
				["QuestDeatil"] = "Content_200313_4",
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_ChenBaiSha_2080431",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17667372901592143029",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667378616602150991",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667378616602150991",
						["startPort"] = "Out",
						["endQuest"] = "17667373937372144354",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667373937372144354",
						["startPort"] = "Out",
						["endQuest"] = "17667378875702151443",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667378875702151443",
						["startPort"] = "Out",
						["endQuest"] = "17667372901592143032",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17667372901592143029"] = {
						["key"] = "17667372901592143029",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 593.1578947368421,
							["y"] = 290.5263157894737
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667372901592143032"] = {
						["key"] = "17667372901592143032",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1823.5789473684213,
							["y"] = 297.89473684210526
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17667372901592143035"] = {
						["key"] = "17667372901592143035",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17667373937372144354"] = {
						["key"] = "17667373937372144354",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1182,
							["y"] = 272.63157894736844
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701091,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_ChenBaiSha_2080431",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51153022,
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
					["17667378616602150991"] = {
						["key"] = "17667378616602150991",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成陈白沙",
						["pos"] = {
							["x"] = 883.4903250773993,
							["y"] = 298.7552889576883
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080431
							}
						}
					},
					["17667378875702151443"] = {
						["key"] = "17667378875702151443",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁陈白沙",
						["pos"] = {
							["x"] = 1505.5955882352941,
							["y"] = 294.01844685242514
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080431
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