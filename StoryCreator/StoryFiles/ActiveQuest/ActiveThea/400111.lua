return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17587015619002070",
			["startPort"] = "Success",
			["endStory"] = "17587012479635",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17587012479621",
			["startPort"] = "StoryStart",
			["endStory"] = "1758701295069332",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1758701295069332",
			["startPort"] = "Success",
			["endStory"] = "1758701322301755",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1758701322301755",
			["startPort"] = "Success",
			["endStory"] = "17587013953611148",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17587013953611148",
			["startPort"] = "Success",
			["endStory"] = "17587015328441468",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17587015505801886",
			["startPort"] = "Success",
			["endStory"] = "17587015619002070",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17587015328441468",
			["startPort"] = "Success",
			["endStory"] = "1758888829785991218",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1758888829785991218",
			["startPort"] = "Success",
			["endStory"] = "17587015505801886",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17587012479621"] = {
			["isStoryNode"] = true,
			["key"] = "17587012479621",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 400111
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17587012479635"] = {
			["isStoryNode"] = true,
			["key"] = "17587012479635",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2374.743137647766,
				["y"] = 460.2268082548588
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1758701295069332"] = {
			["isStoryNode"] = true,
			["key"] = "1758701295069332",
			["type"] = "StoryNode",
			["name"] = "酒馆内",
			["pos"] = {
				["x"] = 1116.2857142857142,
				["y"] = 285.13655462184886
			},
			["propsData"] = {
				["QuestId"] = 40011101,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400111_1",
				["QuestDeatil"] = "Content_400111_1",
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
				["SubRegionId"] = 101107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Empty_400111_1220207",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1758797377794657",
						["startPort"] = "Out",
						["endQuest"] = "1758797381249838",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758797381249838",
						["startPort"] = "Out",
						["endQuest"] = "1758701295070340",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1758701295069333",
						["startPort"] = "QuestStart",
						["endQuest"] = "17648322255511498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17648322255511498",
						["startPort"] = "Out",
						["endQuest"] = "17652644262671395",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17652644262671395",
						["startPort"] = "Out",
						["endQuest"] = "1758797377794657",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1758701295069333"] = {
						["key"] = "1758701295069333",
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
					["1758701295070340"] = {
						["key"] = "1758701295070340",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2335.7894736842104,
							["y"] = 159.4736842105263
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1758701295070347"] = {
						["key"] = "1758701295070347",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2335.7894736842104,
							["y"] = 559.4736842105262
						},
						["propsData"] = {}
					},
					["1758797377794657"] = {
						["key"] = "1758797377794657",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1551.7738264580369,
							["y"] = 277.8221906116644
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51105201,
							["FlowAssetPath"] = "",
							["TalkType"] = "BlackISS",
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
					["1758797381249838"] = {
						["key"] = "1758797381249838",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1877.894736842105,
							["y"] = 281.89473684210543
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51105204,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_40011101",
							["BlendInTime"] = 0,
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
									["TalkActorId"] = 200003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700349,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700350,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700352,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17628431890482994780"] = {
						["key"] = "17628431890482994780",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1102.3069581280788,
							["y"] = 413.3174261083744
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1220205,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_40011101_1220205"
						}
					},
					["17648322255511498"] = {
						["key"] = "17648322255511498",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1108.8350433350429,
							["y"] = 257.7132867132869
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101107,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuideName"] = "Npc_Empty_400111_1220207"
						}
					},
					["17652644262671395"] = {
						["key"] = "17652644262671395",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1332.1482145182645,
							["y"] = 135.52321853856424
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1220207
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 400111,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Empty_400111_1220207",
							["IsUseCount"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1758701322301755"] = {
			["isStoryNode"] = true,
			["key"] = "1758701322301755",
			["type"] = "StoryNode",
			["name"] = "休憩之所",
			["pos"] = {
				["x"] = 1372.0000000000002,
				["y"] = 282.45798319327736
			},
			["propsData"] = {
				["QuestId"] = 40011102,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400111_2",
				["QuestDeatil"] = "Content_400111_2",
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
				["SubRegionId"] = 210101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Bai_Duanzao",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17588042691367857812",
						["startPort"] = "Out",
						["endQuest"] = "17588042771927858028",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758701322301760",
						["startPort"] = "QuestStart",
						["endQuest"] = "17588042691367857812",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17588042771927858028",
						["startPort"] = "Out",
						["endQuest"] = "17647612126772047",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17647612126772047",
						["startPort"] = "Out",
						["endQuest"] = "1758701322301761",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1758701322301760"] = {
						["key"] = "1758701322301760",
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
					["1758701322301761"] = {
						["key"] = "1758701322301761",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1758701322301762"] = {
						["key"] = "1758701322301762",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17588042691367857812"] = {
						["key"] = "17588042691367857812",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1501.6666666666667,
							["y"] = 301.3983739837399
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuideName"] = "Npc_Bai_Duanzao"
						}
					},
					["17588042771927858028"] = {
						["key"] = "17588042771927858028",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1943.3333333333333,
							["y"] = 318.9999999999999
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "Name_400111",
							["NpcId"] = 900001,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Bai_Duanzao",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51105301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_40011102",
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
									["TalkActorId"] = 700352,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700353,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700354,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700355,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 900001,
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
					["17647611270281325"] = {
						["key"] = "17647611270281325",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1724.9543650793653,
							["y"] = 146.21527777777786
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt02/0041_story_jiaojiao_tiejiang",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								210101
							},
							["bStoreToServer"] = false
						}
					},
					["17647612126772047"] = {
						["key"] = "17647612126772047",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2313.287698412698,
							["y"] = 308.7152777777778
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
		["17587013953611148"] = {
			["isStoryNode"] = true,
			["key"] = "17587013953611148",
			["type"] = "StoryNode",
			["name"] = "冰湖城广场",
			["pos"] = {
				["x"] = 1611.9006211180124,
				["y"] = 279.8834490317866
			},
			["propsData"] = {
				["QuestId"] = 40011103,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400111_3",
				["QuestDeatil"] = "Content_400111_3",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_40011103_1192052",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17587013953611153",
						["startPort"] = "QuestStart",
						["endQuest"] = "17588066428459823186",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17588066428459823186",
						["startPort"] = "Out",
						["endQuest"] = "175880744253110806161",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17588066428459823186",
						["startPort"] = "Out",
						["endQuest"] = "17648358565963813392",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175880744253110806161",
						["startPort"] = "Out",
						["endQuest"] = "17648358650043813655",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17648358650043813655",
						["startPort"] = "Out",
						["endQuest"] = "17587013953611154",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17587013953611153"] = {
						["key"] = "17587013953611153",
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
					["17587013953611154"] = {
						["key"] = "17587013953611154",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17587013953611155"] = {
						["key"] = "17587013953611155",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17588066428459823186"] = {
						["key"] = "17588066428459823186",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1168,
							["y"] = 310
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1192052,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_40011103_1192052"
						}
					},
					["175880744253110806161"] = {
						["key"] = "175880744253110806161",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1717.9999999999998,
							["y"] = 325.00000000000017
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51105401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_40011103",
							["BlendInTime"] = 0,
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
									["TalkActorId"] = 700352,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700354,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700360,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700355,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17648358565963813392"] = {
						["key"] = "17648358565963813392",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1497,
							["y"] = 197.50000000000003
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0033_story_humour",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								101101
							},
							["bStoreToServer"] = false
						}
					},
					["17648358650043813655"] = {
						["key"] = "17648358650043813655",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2158.5,
							["y"] = 320.5
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
		["17587015328441468"] = {
			["isStoryNode"] = true,
			["key"] = "17587015328441468",
			["type"] = "StoryNode",
			["name"] = "湖边",
			["pos"] = {
				["x"] = 1363.4990983770788,
				["y"] = 512.3442785248743
			},
			["propsData"] = {
				["QuestId"] = 40011104,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400111_4",
				["QuestDeatil"] = "Content_400111_4",
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_40011104_1241165",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17587015328441473",
						["startPort"] = "QuestStart",
						["endQuest"] = "17588865687995877",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17588865687995877",
						["startPort"] = "Out",
						["endQuest"] = "17588865687995878",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17588865687995878",
						["startPort"] = "Out",
						["endQuest"] = "17587015328441474",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17587015328441473"] = {
						["key"] = "17587015328441473",
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
					["17587015328441474"] = {
						["key"] = "17587015328441474",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17587015328441475"] = {
						["key"] = "17587015328441475",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17588865687995877"] = {
						["key"] = "17588865687995877",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1189,
							["y"] = 390.4999999999999
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1241165,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_40011104_1241165"
						}
					},
					["17588865687995878"] = {
						["key"] = "17588865687995878",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1618.9999999999998,
							["y"] = 380.50000000000006
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51105501,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_40011104",
							["BlendInTime"] = 0,
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
									["TalkActorId"] = 700352,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700355,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700356,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700357,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700362,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700369,
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
		["17587015505801886"] = {
			["isStoryNode"] = true,
			["key"] = "17587015505801886",
			["type"] = "StoryNode",
			["name"] = "冰湖城",
			["pos"] = {
				["x"] = 1870.9587257062717,
				["y"] = 456.2336794465332
			},
			["propsData"] = {
				["QuestId"] = 40011106,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400111_6",
				["QuestDeatil"] = "Content_400111_6",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_40011106_1192058",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "175880848542512771581",
						["startPort"] = "Out",
						["endQuest"] = "175880848542512771582",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17587015505801891",
						["startPort"] = "QuestStart",
						["endQuest"] = "175880848542512771581",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175880848542512771582",
						["startPort"] = "Out",
						["endQuest"] = "17639891315756183474",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17639891315756183474",
						["startPort"] = "Out",
						["endQuest"] = "17587015505801892",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17587015505801891"] = {
						["key"] = "17587015505801891",
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
					["17587015505801892"] = {
						["key"] = "17587015505801892",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17587015505801893"] = {
						["key"] = "17587015505801893",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["175880848542512771581"] = {
						["key"] = "175880848542512771581",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1431,
							["y"] = 414.4999999999999
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1192058,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_40011106_1192058"
						}
					},
					["175880848542512771582"] = {
						["key"] = "175880848542512771582",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1981,
							["y"] = 429.5
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51105601,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_40011106",
							["BlendInTime"] = 0,
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
									["TalkActorId"] = 700352,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700355,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700358,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700356,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700357,
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
					["17639891315756183474"] = {
						["key"] = "17639891315756183474",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2333.3566433566434,
							["y"] = 379.3566433566433
						},
						["propsData"] = {
							["VarName"] = "BH_Thea_Online",
							["VarValue"] = 1
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17587015619002070"] = {
			["isStoryNode"] = true,
			["key"] = "17587015619002070",
			["type"] = "StoryNode",
			["name"] = "盖雷亚剧院",
			["pos"] = {
				["x"] = 2098.6664120416754,
				["y"] = 454.5614694685728
			},
			["propsData"] = {
				["QuestId"] = 40011107,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400111_7",
				["QuestDeatil"] = "Content_400111_7",
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
				["SubRegionId"] = 101901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_40011107_1961002",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17590440054471975568",
						["startPort"] = "Out",
						["endQuest"] = "17590440054471975569",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17587015619002075",
						["startPort"] = "QuestStart",
						["endQuest"] = "17590440054471975568",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17590440054471975569",
						["startPort"] = "Out",
						["endQuest"] = "17587015619002076",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17587015619002075"] = {
						["key"] = "17587015619002075",
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
					["17587015619002076"] = {
						["key"] = "17587015619002076",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2318,
							["y"] = 336
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17587015619002077"] = {
						["key"] = "17587015619002077",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17590440054471975568"] = {
						["key"] = "17590440054471975568",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1165,
							["y"] = 336.4999999999999
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1961002,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_40011107_1961002"
						}
					},
					["17590440054471975569"] = {
						["key"] = "17590440054471975569",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1715,
							["y"] = 351.5
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51105701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_40011107",
							["BlendInTime"] = 0,
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
									["TalkActorId"] = 700349,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700350,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700352,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700359,
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
		["1758888829785991218"] = {
			["isStoryNode"] = true,
			["key"] = "1758888829785991218",
			["type"] = "StoryNode",
			["name"] = "战斗，救下一对小孩",
			["pos"] = {
				["x"] = 1598.3016129032253,
				["y"] = 515.4967741935485
			},
			["propsData"] = {
				["QuestId"] = 40011105,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400111_5",
				["QuestDeatil"] = "Content_400111_5",
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
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Nanhai_40011105_1241166",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1758888829787991229",
						["startPort"] = "Out",
						["endQuest"] = "1758888829787991228",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758888829787991228",
						["startPort"] = "Out",
						["endQuest"] = "1758888829786991224",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1758888829786991223",
						["startPort"] = "QuestStart",
						["endQuest"] = "1758888929744993299",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758888929744993299",
						["startPort"] = "Out",
						["endQuest"] = "1758888829787991229",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1758888829786991223"] = {
						["key"] = "1758888829786991223",
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
					["1758888829786991224"] = {
						["key"] = "1758888829786991224",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1758888829787991225"] = {
						["key"] = "1758888829787991225",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1758888829787991228"] = {
						["key"] = "1758888829787991228",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2194,
							["y"] = 392
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51105505,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_40011105",
							["BlendInTime"] = 0,
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
									["TalkActorId"] = 700356,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700357,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700352,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700355,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1758888829787991229"] = {
						["key"] = "1758888829787991229",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1800,
							["y"] = 386
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51105515,
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
					["1758888929744993299"] = {
						["key"] = "1758888929744993299",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1308,
							["y"] = 368
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuideName"] = "Npc_Nanhai_40011105_1241166"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {
		["17590297739023168"] = {
			["key"] = "17590297739023168",
			["name"] = "冰湖流程 连在一起",
			["position"] = {
				["x"] = 1349.9230769230767,
				["y"] = 434.06593406593396
			},
			["size"] = {
				["width"] = 469.8888888888891,
				["height"] = 263.5555555555554
			}
		}
	}
}