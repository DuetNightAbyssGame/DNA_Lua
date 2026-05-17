return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17369484810791364173",
			["startPort"] = "Success",
			["endStory"] = "17369484810791364174",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17369484810791364174",
			["startPort"] = "Success",
			["endStory"] = "17369484810791364175",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17369484810791364176",
			["startPort"] = "Success",
			["endStory"] = "17369484810791364177",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17369484810791364182",
			["startPort"] = "StoryStart",
			["endStory"] = "17388274279851012769",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17388990773701773657",
			["startPort"] = "Success",
			["endStory"] = "17369484810791364173",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17369484810791364179",
			["startPort"] = "Success",
			["endStory"] = "17369484810791364181",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17369484810791364181",
			["startPort"] = "Success",
			["endStory"] = "17492849336551852877",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17492849336551852877",
			["startPort"] = "Success",
			["endStory"] = "17292421988657900909",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17512790288048897076",
			["startPort"] = "Success",
			["endStory"] = "17369484810791364179",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17369484810791364178",
			["startPort"] = "Success",
			["endStory"] = "17532380571306650",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17532380571306650",
			["startPort"] = "Success",
			["endStory"] = "17512790288048897076",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17369484810791364177",
			["startPort"] = "Success",
			["endStory"] = "175325486419625280",
			["endPort"] = "In"
		},
		{
			["startStory"] = "175325486419625280",
			["startPort"] = "Success",
			["endStory"] = "17369484810791364178",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623342067682078711",
			["startPort"] = "Success",
			["endStory"] = "17369484810791364176",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17388274279851012769",
			["startPort"] = "Success",
			["endStory"] = "17388990773701773657",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17292421988657900909",
			["startPort"] = "Success",
			["endStory"] = "176235841479029799870",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176235841479029799870",
			["startPort"] = "Success",
			["endStory"] = "17369484810791364183",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17369484810791364175",
			["startPort"] = "Success",
			["endStory"] = "17512639315923966182",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17512639315923966182",
			["startPort"] = "Success",
			["endStory"] = "17623342067682078711",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17292421988657900909"] = {
			["isStoryNode"] = true,
			["key"] = "17292421988657900909",
			["type"] = "StoryNode",
			["name"] = "离开洞穴",
			["pos"] = {
				["x"] = 3335.246316196381,
				["y"] = 626.2279536558686
			},
			["propsData"] = {
				["QuestId"] = 12010213,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_11",
				["QuestDeatil"] = "Content_120102_11",
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
				["SubRegionId"] = 104103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "RegionPoint_Cav_Door02",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17292421988657900913",
						["startPort"] = "QuestStart",
						["endQuest"] = "17532587076455961",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17532587076455961",
						["startPort"] = "Out",
						["endQuest"] = "17292421988657900914",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17292421988657900913"] = {
						["key"] = "17292421988657900913",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2019.3017953311064,
							["y"] = 809.6496725496727
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17292421988657900914"] = {
						["key"] = "17292421988657900914",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2782.92147691406,
							["y"] = 817.6115086684982
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17292421988657900915"] = {
						["key"] = "17292421988657900915",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4029.3877174065015,
							["y"] = 949.8553483953211
						},
						["propsData"] = {}
					},
					["17532587076455961"] = {
						["key"] = "17532587076455961",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2392.926315789473,
							["y"] = 796.0842105263159
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040068,
							["GuideType"] = "P",
							["GuidePointName"] = "RegionPoint_Cav_Door02"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17369484810791364173"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364173",
			["type"] = "StoryNode",
			["name"] = "前往止流所在处",
			["pos"] = {
				["x"] = 1969.0013446036467,
				["y"] = 305.07842925489973
			},
			["propsData"] = {
				["QuestId"] = 12010204,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_1",
				["QuestDeatil"] = "Content_120102_1_3",
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
				["StoryGuidePointName"] = "QuestPoint_2110016",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17369484810791364184",
						["startPort"] = "QuestStart",
						["endQuest"] = "17369484810791364187",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17369484810791364187",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364188",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17369484810791364188",
						["startPort"] = "Out",
						["endQuest"] = "176235698835928768005",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176235698835928768005",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364189",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17369484810791364189",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364185",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17369484810791364184"] = {
						["key"] = "17369484810791364184",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1815.429816893633,
							["y"] = 446.1730539197644
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364185"] = {
						["key"] = "17369484810791364185",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3268.935462057875,
							["y"] = 458.978494694255
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364186"] = {
						["key"] = "17369484810791364186",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["17369484810791364187"] = {
						["key"] = "17369484810791364187",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成织星客、止流等",
						["pos"] = {
							["x"] = 2110.9460951900887,
							["y"] = 445.4170003972637
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110018,
								2110019,
								2110020,
								2110031
							}
						}
					},
					["17369484810791364188"] = {
						["key"] = "17369484810791364188",
						["type"] = "GoToNode",
						["name"] = "前往止流附近",
						["pos"] = {
							["x"] = 2387.7197822781045,
							["y"] = 428.5740732866343
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2110023,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_12010203"
						}
					},
					["17369484810791364189"] = {
						["key"] = "17369484810791364189",
						["type"] = "TalkNode",
						["name"] = "【14】止流和织星客 Fixsimple04",
						["pos"] = {
							["x"] = 2986.360759721715,
							["y"] = 434.95520794145324
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1201/120102/12010709.12010709'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "East01_FixSimple_14",
							["BlendInTime"] = 1,
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
									["TalkActorId"] = 210004,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210006,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210033,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210022,
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
					["176235698835928768005"] = {
						["key"] = "176235698835928768005",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁织星客、止流等",
						["pos"] = {
							["x"] = 2685.472488038277,
							["y"] = 444.54246411483257
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110018,
								2110019,
								2110020,
								2110031
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17369484810791364174"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364174",
			["type"] = "StoryNode",
			["name"] = "和止流交谈",
			["pos"] = {
				["x"] = 2253.652966159743,
				["y"] = 300.3631575985514
			},
			["propsData"] = {
				["QuestId"] = 12010205,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_2",
				["QuestDeatil"] = "Content_120102_2",
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
				["StoryGuidePointName"] = "Npc_Zhiliu_2110020",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17369484810791364190",
						["startPort"] = "QuestStart",
						["endQuest"] = "176235721965128769067",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176235721965128769067",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364193",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17369484810791364193",
						["startPort"] = "Out",
						["endQuest"] = "17624158476592943688",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17624158476592943688",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364191",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17369484810791364190"] = {
						["key"] = "17369484810791364190",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1992.5088245088248,
							["y"] = 821.5667665667665
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364191"] = {
						["key"] = "17369484810791364191",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3272.3182989424367,
							["y"] = 815.3310679741716
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364192"] = {
						["key"] = "17369484810791364192",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3252.0076550136523,
							["y"] = 974.5287414983818
						},
						["propsData"] = {}
					},
					["17369484810791364193"] = {
						["key"] = "17369484810791364193",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和止流交谈 Fixsimple05",
						["pos"] = {
							["x"] = 2663.039870850309,
							["y"] = 807.5276008943412
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210004,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Zhiliu_2110229",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12010801,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_15",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0.5,
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
									["TalkActorId"] = 210004,
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
					["175178041573812681314"] = {
						["key"] = "175178041573812681314",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成止流",
						["pos"] = {
							["x"] = 2816.905555555555,
							["y"] = 977.3603174603173
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110026
							}
						}
					},
					["176235721965128769067"] = {
						["key"] = "176235721965128769067",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成止流",
						["pos"] = {
							["x"] = 2304.0870547581076,
							["y"] = 814.627525252525
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110229
							}
						}
					},
					["176235724276328769479"] = {
						["key"] = "176235724276328769479",
						["type"] = "SetNpcPatrolNode",
						["name"] = "设置NPC巡逻",
						["pos"] = {
							["x"] = 2736.3092769803297,
							["y"] = 550.1830808080805
						},
						["propsData"] = {
							["NpcId"] = "",
							["PatrolId"] = ""
						}
					},
					["17624158476592943688"] = {
						["key"] = "17624158476592943688",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成止流",
						["pos"] = {
							["x"] = 2963.875,
							["y"] = 808.9103457172343
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110229
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17369484810791364175"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364175",
			["type"] = "StoryNode",
			["name"] = "拿止流的盘缠",
			["pos"] = {
				["x"] = 2530.9364533005833,
				["y"] = 305.35611971868747
			},
			["propsData"] = {
				["QuestId"] = 12010206,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_3",
				["QuestDeatil"] = "Content_120102_3",
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
				["StoryGuidePointName"] = "QuestPoint_12010203",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17369484810791364194",
						["startPort"] = "QuestStart",
						["endQuest"] = "17536759143744009783",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536759143744009783",
						["startPort"] = "Out",
						["endQuest"] = "17290625374963379760",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17369484810791364194",
						["startPort"] = "QuestStart",
						["endQuest"] = "17624158588422944087",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17624158588422944087",
						["startPort"] = "Out",
						["endQuest"] = "176235761886428770793",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17290625374963379760",
						["startPort"] = "Out",
						["endQuest"] = "17290634601473942239",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17624156326441963130",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364195",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17290634601473942239",
						["startPort"] = "Out",
						["endQuest"] = "17624158588422944088",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17624158588422944088",
						["startPort"] = "Out",
						["endQuest"] = "17624156326441963130",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17290625374963379760"] = {
						["key"] = "17290625374963379760",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 2275.9523713264853,
							["y"] = 824.3633590009202
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								2110027
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 10053,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_12010206",
							["IsUseCount"] = false
						}
					},
					["17290634601473942239"] = {
						["key"] = "17290634601473942239",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和止流交谈 Fixsimple06",
						["pos"] = {
							["x"] = 2541.780362049213,
							["y"] = 827.5351674556237
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12010901,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "East01_FixSimple_16",
							["BlendInTime"] = 1,
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
									["TalkActorId"] = 210004,
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
					["17369484810791364194"] = {
						["key"] = "17369484810791364194",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1960.3742091242098,
							["y"] = 841.2996725496726
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364195"] = {
						["key"] = "17369484810791364195",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3193.404047404501,
							["y"] = 817.1569736474457
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364196"] = {
						["key"] = "17369484810791364196",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3177.1375251435225,
							["y"] = 1030.8534168230572
						},
						["propsData"] = {}
					},
					["17536759143744009783"] = {
						["key"] = "17536759143744009783",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成桌子",
						["pos"] = {
							["x"] = 2259.9752321981427,
							["y"] = 646.3831269349844
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110126
							}
						}
					},
					["176235761886428770793"] = {
						["key"] = "176235761886428770793",
						["type"] = "SetNpcPatrolNode",
						["name"] = "设置NPC巡逻",
						["pos"] = {
							["x"] = 2273.2392344497607,
							["y"] = 472.47129186602865
						},
						["propsData"] = {
							["NpcId"] = 210004,
							["PatrolId"] = 120102
						}
					},
					["17624156326441963130"] = {
						["key"] = "17624156326441963130",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2855.8231768231763,
							["y"] = 821.9845286292655
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpawnPoint_SprEnd",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17624158588422944087"] = {
						["key"] = "17624158588422944087",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成止流",
						["pos"] = {
							["x"] = 2267.563819586846,
							["y"] = 332.1123491661417
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110229
							}
						}
					},
					["17624158588422944088"] = {
						["key"] = "17624158588422944088",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁止流",
						["pos"] = {
							["x"] = 2685.3517648287384,
							["y"] = 709.7220927077742
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110229
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17369484810791364176"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364176",
			["type"] = "StoryNode",
			["name"] = "前往洞穴",
			["pos"] = {
				["x"] = 631.4917418685357,
				["y"] = 604.2434374342615
			},
			["propsData"] = {
				["QuestId"] = 12010207,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_4",
				["QuestDeatil"] = "Content_120102_4",
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
						["startQuest"] = "17369484810791364197",
						["startPort"] = "QuestStart",
						["endQuest"] = "17291504770723375784",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17291504770723375784",
						["startPort"] = "Out",
						["endQuest"] = "176235331145920552008",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176231387313315513",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364198",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176235331145920552008",
						["startPort"] = "Out",
						["endQuest"] = "176231387313315513",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17291504770723375784"] = {
						["key"] = "17291504770723375784",
						["type"] = "GoToNode",
						["name"] = "进入洞穴",
						["pos"] = {
							["x"] = 1780.4829820545522,
							["y"] = 846.9424516495453
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040002,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2040002"
						}
					},
					["17369484810791364197"] = {
						["key"] = "17369484810791364197",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1385.5522629544375,
							["y"] = 854.6805904240686
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364198"] = {
						["key"] = "17369484810791364198",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2696.392609398884,
							["y"] = 876.7270386126177
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364199"] = {
						["key"] = "17369484810791364199",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3209.403499697826,
							["y"] = 974.4285271945063
						},
						["propsData"] = {}
					},
					["175178074464212686160"] = {
						["key"] = "175178074464212686160",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2731.9130434782605,
							["y"] = 311.3089244851258
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["176231387313315513"] = {
						["key"] = "176231387313315513",
						["type"] = "TalkNode",
						["name"] = "【SEQ】Show_Cav_RegionUI",
						["pos"] = {
							["x"] = 2106.443588502257,
							["y"] = 839.4182340456334
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East01/Cav/Show_Cav_RegionUI",
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
							["BeginNewTargetPointName"] = "SpawnPoint_Cav",
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
					["176235331145920552008"] = {
						["key"] = "176235331145920552008",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2101.8339579821013,
							["y"] = 656.627510061106
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpawnPoint_Cav",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["176235332315620552461"] = {
						["key"] = "176235332315620552461",
						["type"] = "GoToNode",
						["name"] = "抵达洞穴内战斗位置",
						["pos"] = {
							["x"] = 2685.773821509417,
							["y"] = 585.1987302153364
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040003,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_120102074"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17369484810791364177"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364177",
			["type"] = "StoryNode",
			["name"] = "战斗Cav（01）",
			["pos"] = {
				["x"] = 900.2803560605339,
				["y"] = 601.6459016970525
			},
			["propsData"] = {
				["QuestId"] = 12010208,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_4",
				["QuestDeatil"] = "Content_120102_5",
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
				["SubRegionId"] = 104103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_120102074",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17369484810791364201",
						["startPort"] = "QuestStart",
						["endQuest"] = "175325254074116706",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175325254074116706",
						["startPort"] = "Out",
						["endQuest"] = "175325267270617445",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175325267270617445",
						["startPort"] = "Fail",
						["endQuest"] = "175325282151119044",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175325282151119044",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364203",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "175325267270617445",
						["startPort"] = "Success",
						["endQuest"] = "17369484810791364202",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17369484810791364201",
						["startPort"] = "QuestStart",
						["endQuest"] = "176232324240016902",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175325267270617445",
						["startPort"] = "PassiveFail",
						["endQuest"] = "175325282151119044",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17369484810791364201"] = {
						["key"] = "17369484810791364201",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1634.6296950176265,
							["y"] = 884.6656600104875
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364202"] = {
						["key"] = "17369484810791364202",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2693.570318406348,
							["y"] = 846.015621031231
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364203"] = {
						["key"] = "17369484810791364203",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2969.5635965997717,
							["y"] = 1075.4995766308537
						},
						["propsData"] = {}
					},
					["175325254074116706"] = {
						["key"] = "175325254074116706",
						["type"] = "GoToNode",
						["name"] = "抵达洞穴内战斗位置",
						["pos"] = {
							["x"] = 1989.2484792204104,
							["y"] = 865.2158811350628
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040003,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_120102074"
						}
					},
					["175325267270617445"] = {
						["key"] = "175325267270617445",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 2326.7484792204104,
							["y"] = 856.2158811350628
						},
						["propsData"] = {
							["SpecialConfigId"] = 2005,
							["BlackScreenImmediately"] = false
						}
					},
					["175325282151119044"] = {
						["key"] = "175325282151119044",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2693.793542966733,
							["y"] = 1023.062632524406
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpawnPoint_Cav",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["176232324240016902"] = {
						["key"] = "176232324240016902",
						["type"] = "TalkNode",
						["name"] = "开车- 进入洞穴",
						["pos"] = {
							["x"] = 1985.7228260869565,
							["y"] = 679.6234015345268
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17369484810791364178"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364178",
			["type"] = "StoryNode",
			["name"] = "和煜明离开洞穴",
			["pos"] = {
				["x"] = 1498.761117143916,
				["y"] = 899.1958980499577
			},
			["propsData"] = {
				["QuestId"] = 12010209,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_6",
				["QuestDeatil"] = "Content_120102_6",
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
				["SubRegionId"] = 104103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QuestTrigger_2040071",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17369484810791364208",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623346682162082897",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623346682162082898",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364209",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17369484810791364208",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623346682162082898",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17369484810791364208"] = {
						["key"] = "17369484810791364208",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1896.8915476209534,
							["y"] = 823.7286023155589
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364209"] = {
						["key"] = "17369484810791364209",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2712.2079354548464,
							["y"] = 823.4160159361481
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364210"] = {
						["key"] = "17369484810791364210",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2846.8574088765563,
							["y"] = 1024.5711378690053
						},
						["propsData"] = {}
					},
					["175325385761021091"] = {
						["key"] = "175325385761021091",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2310.674657344496,
							["y"] = 999.500815401452
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040071,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2040071"
						}
					},
					["17623346682162082897"] = {
						["key"] = "17623346682162082897",
						["type"] = "TalkNode",
						["name"] = "开车- 闲谈",
						["pos"] = {
							["x"] = 2322.362786193994,
							["y"] = 585.7223962924368
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17623346682162082898"] = {
						["key"] = "17623346682162082898",
						["type"] = "GoToNode",
						["name"] = "前往洞穴中部",
						["pos"] = {
							["x"] = 2323.56480767898,
							["y"] = 806.6110716485157
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040015,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_12010209"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17369484810791364179"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364179",
			["type"] = "StoryNode",
			["name"] = "战斗Cav（02）",
			["pos"] = {
				["x"] = 2360.153470074444,
				["y"] = 896.6303868468833
			},
			["propsData"] = {
				["QuestId"] = 12010210,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_7",
				["QuestDeatil"] = "Content_120102_7",
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
				["SubRegionId"] = 104103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "RegionPoint_Cav_04",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "173960806848313829659",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364216",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "173960798111013829272",
						["startPort"] = "Success",
						["endQuest"] = "17369484810791364215",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173960798111013829272",
						["startPort"] = "Fail",
						["endQuest"] = "173960806848313829659",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512790959328898861",
						["startPort"] = "Out",
						["endQuest"] = "173960798111013829272",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173960798111013829272",
						["startPort"] = "PassiveFail",
						["endQuest"] = "173960806848313829659",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626043295439247258",
						["startPort"] = "true",
						["endQuest"] = "17626043295439247257",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17369484810791364214",
						["startPort"] = "QuestStart",
						["endQuest"] = "17626043295439247258",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626043295439247258",
						["startPort"] = "false",
						["endQuest"] = "17512790959328898861",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626043295439247258",
						["startPort"] = "true",
						["endQuest"] = "173960798111013829272",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17369484810791364214"] = {
						["key"] = "17369484810791364214",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2478.898156693668,
							["y"] = 796.247582998357
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364215"] = {
						["key"] = "17369484810791364215",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4000.04227036743,
							["y"] = 764.1096381252482
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364216"] = {
						["key"] = "17369484810791364216",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4011.01702559831,
							["y"] = 1049.7094318119046
						},
						["propsData"] = {}
					},
					["173960798111013829272"] = {
						["key"] = "173960798111013829272",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 3420.9107575860667,
							["y"] = 774.9621174104534
						},
						["propsData"] = {
							["SpecialConfigId"] = 2006,
							["BlackScreenImmediately"] = true
						}
					},
					["173960806848313829659"] = {
						["key"] = "173960806848313829659",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 3728.506013723119,
							["y"] = 947.6601260581525
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpawnPoint_CavSpecialQuest",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17512790959328898861"] = {
						["key"] = "17512790959328898861",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3144.6796261014515,
							["y"] = 986.0867766134794
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040093,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2040093"
						}
					},
					["17626043295439247257"] = {
						["key"] = "17626043295439247257",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 3140.870692860475,
							["y"] = 603.9216480114312
						},
						["propsData"] = {
							["VarName"] = "East01Cav02",
							["VarValue"] = 1
						}
					},
					["17626043295439247258"] = {
						["key"] = "17626043295439247258",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否在阶段1",
						["pos"] = {
							["x"] = 2818.1681060599008,
							["y"] = 785.6665872826862
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Cav02",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17369484810791364181"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364181",
			["type"] = "StoryNode",
			["name"] = "询问煜明伤势",
			["pos"] = {
				["x"] = 2759.299825036654,
				["y"] = 628.5790497771923
			},
			["propsData"] = {
				["QuestId"] = 12010211,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_9",
				["QuestDeatil"] = "Content_120102_9",
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
				["SubRegionId"] = 104103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "RegionPoint_Cav_04",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17369484810791364224",
						["startPort"] = "QuestStart",
						["endQuest"] = "17369484810791364227",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17369484810791364227",
						["startPort"] = "Out",
						["endQuest"] = "176260855486315189077",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176260855486315189077",
						["startPort"] = "Out",
						["endQuest"] = "17369484810791364225",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17369484810791364224"] = {
						["key"] = "17369484810791364224",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2409.0199771492885,
							["y"] = 820.2087634587634
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364225"] = {
						["key"] = "17369484810791364225",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3264.892282424339,
							["y"] = 818.2951250521144
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17369484810791364226"] = {
						["key"] = "17369484810791364226",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4029.3877174065015,
							["y"] = 949.8553483953211
						},
						["propsData"] = {}
					},
					["17369484810791364227"] = {
						["key"] = "17369484810791364227",
						["type"] = "TalkNode",
						["name"] = "【19】 和煜明寒暄",
						["pos"] = {
							["x"] = 2732.9125048153282,
							["y"] = 804.0263348004219
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1201/120102/12012001.12012001'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "East01_FixSimple_19",
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
									["TalkActorId"] = 210007,
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
					["17532622191855833447"] = {
						["key"] = "17532622191855833447",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和煜明寒暄 Fixsimple09",
						["pos"] = {
							["x"] = 2986,
							["y"] = 479.9999999999999
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210007,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Yuming_2040028",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12012001,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_19",
							["BlendInTime"] = 1,
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
									["TalkActorId"] = 210007,
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
					["176260855486315189077"] = {
						["key"] = "176260855486315189077",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 3012.208686050791,
							["y"] = 800.0003680529996
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpecialQuestPoint_SQ02Start",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17369484810791364182"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364182",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1073.5704584040745,
				["y"] = 298.7355687606112
			},
			["propsData"] = {
				["QuestChainId"] = 120102
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17369484810791364183"] = {
			["isStoryNode"] = true,
			["key"] = "17369484810791364183",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 3663.5266929347695,
				["y"] = 832.9646848957633
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17388274279851012769"] = {
			["isStoryNode"] = true,
			["key"] = "17388274279851012769",
			["type"] = "StoryNode",
			["name"] = "前往百年春",
			["pos"] = {
				["x"] = 1400.8548805121727,
				["y"] = 299.6850836671891
			},
			["propsData"] = {
				["QuestId"] = 12010201,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_1_1",
				["QuestDeatil"] = "Content_120101_12",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17388274279861012780",
						["startPort"] = "Out",
						["endQuest"] = "17388274279861012781",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388274279861012776",
						["startPort"] = "QuestStart",
						["endQuest"] = "17388274279861012780",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388274279861012781",
						["startPort"] = "Out",
						["endQuest"] = "17388274279861012777",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17388274279861012776"] = {
						["key"] = "17388274279861012776",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2223.580919080919,
							["y"] = 453.91258741258736
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17388274279861012777"] = {
						["key"] = "17388274279861012777",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3018.183112433815,
							["y"] = 460.92633304011974
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17388274279861012778"] = {
						["key"] = "17388274279861012778",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["17388274279861012780"] = {
						["key"] = "17388274279861012780",
						["type"] = "GoToNode",
						["name"] = "前往白龙祠堂",
						["pos"] = {
							["x"] = 2482.1092217859655,
							["y"] = 446.082133209168
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2110009,
							["GuideType"] = "P",
							["GuidePointName"] = "TargetPoint_Spr_In"
						}
					},
					["17388274279861012781"] = {
						["key"] = "17388274279861012781",
						["type"] = "TalkNode",
						["name"] = "【12】站桩",
						["pos"] = {
							["x"] = 2742.556704128186,
							["y"] = 451.840460846443
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1201/120102/12010601.12010601'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "East01_FixSimple_12",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0.5,
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
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210033,
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
		["173883315853110094544"] = {
			["isStoryNode"] = true,
			["key"] = "173883315853110094544",
			["type"] = "StoryNode",
			["name"] = "和香官对话",
			["pos"] = {
				["x"] = 1400.7220333462114,
				["y"] = 105.8577855223485
			},
			["propsData"] = {
				["QuestId"] = 12010202,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_1_2",
				["QuestDeatil"] = "Content_120102_1_2",
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
				["StoryGuidePointName"] = "Npc_Xiangguan_2110011",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {
					["173883315853110094549"] = {
						["key"] = "173883315853110094549",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2484.4170535347007,
							["y"] = 428.0848563201504
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173883315853110094550"] = {
						["key"] = "173883315853110094550",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3060.1529762414075,
							["y"] = 435.50862802708
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173883315853110094551"] = {
						["key"] = "173883315853110094551",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["17388990773701773657"] = {
			["isStoryNode"] = true,
			["key"] = "17388990773701773657",
			["type"] = "StoryNode",
			["name"] = "和皎皎告别",
			["pos"] = {
				["x"] = 1680.46036838978,
				["y"] = 304.85561497326205
			},
			["propsData"] = {
				["QuestId"] = 12010203,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_1_3",
				["QuestDeatil"] = "Content_120101_12",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QuestTrigger_2110012",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17388990773701773662",
						["startPort"] = "QuestStart",
						["endQuest"] = "176235689025328766204",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388990773701773662",
						["startPort"] = "QuestStart",
						["endQuest"] = "17389084046783798771",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17389084046783798772",
						["startPort"] = "Out",
						["endQuest"] = "176235690575728766671",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176235690575728766671",
						["startPort"] = "Out",
						["endQuest"] = "1755085004012922947",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176235689025328766204",
						["startPort"] = "Out",
						["endQuest"] = "17389084046783798772",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755085004012922947",
						["startPort"] = "Out",
						["endQuest"] = "17388990773701773663",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17388990773701773662"] = {
						["key"] = "17388990773701773662",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1899.5810181228305,
							["y"] = 494.3858665878301
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17388990773701773663"] = {
						["key"] = "17388990773701773663",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3577.8500873067683,
							["y"] = 502.73809899155964
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17388990773701773664"] = {
						["key"] = "17388990773701773664",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["17389084046783798771"] = {
						["key"] = "17389084046783798771",
						["type"] = "TalkNode",
						["name"] = "开车 - 找止流",
						["pos"] = {
							["x"] = 2316.6255997865123,
							["y"] = 253.6790943525933
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12010617,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17389084046783798772"] = {
						["key"] = "17389084046783798772",
						["type"] = "GoToNode",
						["name"] = "告别皎皎",
						["pos"] = {
							["x"] = 2629.373781239246,
							["y"] = 488.4540693583377
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2110012,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_EastBai_2110228"
						}
					},
					["1755085004012922947"] = {
						["key"] = "1755085004012922947",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3275.538044268607,
							["y"] = 493.7771014157773
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1201/12010701.12010701'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_13",
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
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210003,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["176235689025328766204"] = {
						["key"] = "176235689025328766204",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2251.0214915504057,
							["y"] = 489.40416269400197
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110228
							}
						}
					},
					["176235690575728766671"] = {
						["key"] = "176235690575728766671",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2962.8848455876728,
							["y"] = 488.41037387412615
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110228
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17492849336551852877"] = {
			["isStoryNode"] = true,
			["key"] = "17492849336551852877",
			["type"] = "StoryNode",
			["name"] = "藏匿煜明",
			["pos"] = {
				["x"] = 3041.321630571759,
				["y"] = 629.6447735271263
			},
			["propsData"] = {
				["QuestId"] = 12010212,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_10",
				["QuestDeatil"] = "Content_120102_10",
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
				["SubRegionId"] = 104103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "RegionPoint_Cav_04",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17492849336551852878",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623437289065167241",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17492849336551852878",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623442831065168400",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17492849336551852878",
						["startPort"] = "QuestStart",
						["endQuest"] = "176260549685011230969",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176260925140915191591",
						["startPort"] = "Out",
						["endQuest"] = "17492849336551852881",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17623437289065167241",
						["startPort"] = "Out",
						["endQuest"] = "176260550695211231242",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176260550695211231242",
						["startPort"] = "Out",
						["endQuest"] = "17494348279654009",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17494348279654009",
						["startPort"] = "Out",
						["endQuest"] = "176260925140915191591",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17492849336551852878"] = {
						["key"] = "17492849336551852878",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 772.8571428571429,
							["y"] = 417.14285714285717
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17492849336551852881"] = {
						["key"] = "17492849336551852881",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2267.712862429968,
							["y"] = 425.7374785302416
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17492849336551852884"] = {
						["key"] = "17492849336551852884",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1893.6842105263158,
							["y"] = 714.2105263157895
						},
						["propsData"] = {}
					},
					["17494348279654009"] = {
						["key"] = "17494348279654009",
						["type"] = "TalkNode",
						["name"] = "【20】藏好煜明Fixsimple09",
						["pos"] = {
							["x"] = 1757.8894441519546,
							["y"] = 416.63274823780444
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12012033,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_20",
							["BlendInTime"] = 1,
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
							["EndNewTargetPointName"] = "East01_12012033",
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
									["TalkActorId"] = 210007,
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
					["17536780029048011062"] = {
						["key"] = "17536780029048011062",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 994.5414377289376,
							["y"] = 610.7273351648353
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040067,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2040067"
						}
					},
					["17536781225948011914"] = {
						["key"] = "17536781225948011914",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 1190.6964285714287,
							["y"] = -254.56845238095238
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12012040,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17623437289065167241"] = {
						["key"] = "17623437289065167241",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1246.795585650048,
							["y"] = 408.4170894894579
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								2040033
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 10057,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17623442831065168400"] = {
						["key"] = "17623442831065168400",
						["type"] = "CameraLookAtNode",
						["name"] = "CameraLookAt",
						["pos"] = {
							["x"] = 1250.9775911445536,
							["y"] = 246.6210730059415
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "DropPoint_Yuming",
							["ActorId"] = 0,
							["Duration"] = 3,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					},
					["176260549685011230969"] = {
						["key"] = "176260549685011230969",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成煜明",
						["pos"] = {
							["x"] = 1246,
							["y"] = 101.7142857142857
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2040143
							}
						}
					},
					["176260550695211231242"] = {
						["key"] = "176260550695211231242",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁煜明",
						["pos"] = {
							["x"] = 1512.262987012987,
							["y"] = 428.37987012987014
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2040143
							}
						}
					},
					["176260925140915191591"] = {
						["key"] = "176260925140915191591",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2004.6219435736673,
							["y"] = 417.91094762380163
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpawnPoint_Cav03",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17512639315923966182"] = {
			["isStoryNode"] = true,
			["key"] = "17512639315923966182",
			["type"] = "StoryNode",
			["name"] = "前往洞穴【百年春】",
			["pos"] = {
				["x"] = 2785.16690557726,
				["y"] = 299.5821800053495
			},
			["propsData"] = {
				["QuestId"] = 12010250,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_4",
				["QuestDeatil"] = "Content_120102_4",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
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
				["SubRegionId"] = 104110,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Zhiliu_2110020",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17512639315923966191",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623342911562080825",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623342911562080825",
						["startPort"] = "Out",
						["endQuest"] = "17512639315923966192",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17512639315923966191"] = {
						["key"] = "17512639315923966191",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1721.064685314686,
							["y"] = 936.2718947718947
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17512639315923966192"] = {
						["key"] = "17512639315923966192",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2630.6329406190916,
							["y"] = 924.3558164395379
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17512639315923966193"] = {
						["key"] = "17512639315923966193",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3201.403499697826,
							["y"] = 1162.4285271945064
						},
						["propsData"] = {}
					},
					["17623342911562080825"] = {
						["key"] = "17623342911562080825",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2168.625,
							["y"] = 920.625
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17512790288048897076"] = {
			["isStoryNode"] = true,
			["key"] = "17512790288048897076",
			["type"] = "StoryNode",
			["name"] = "寻找煜明",
			["pos"] = {
				["x"] = 2057.4583227142084,
				["y"] = 905.7911522691569
			},
			["propsData"] = {
				["QuestId"] = 12010251,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_7",
				["QuestDeatil"] = "Content_120102_7",
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
				["SubRegionId"] = 104103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "RegionPoint_Cav_Door01",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17512790288048897081",
						["startPort"] = "QuestStart",
						["endQuest"] = "17512790610608898116",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512790610608898116",
						["startPort"] = "Out",
						["endQuest"] = "175178217377812692667",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512790610608898116",
						["startPort"] = "Out",
						["endQuest"] = "17623353631573111657",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175178217377812692667",
						["startPort"] = "Out",
						["endQuest"] = "17626037266308257262",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175178217377812692667",
						["startPort"] = "Out",
						["endQuest"] = "17651813091839080",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17651813091839080",
						["startPort"] = "Out",
						["endQuest"] = "1752734412159967035",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752734412159967035",
						["startPort"] = "Out",
						["endQuest"] = "17512790288048897082",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17512790288048897081"] = {
						["key"] = "17512790288048897081",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1603.1244010375594,
							["y"] = 816.8118840224104
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17512790288048897082"] = {
						["key"] = "17512790288048897082",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3409.356811661376,
							["y"] = 813.7101165941478
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17512790288048897083"] = {
						["key"] = "17512790288048897083",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3528.389127180938,
							["y"] = 1029.1499912524641
						},
						["propsData"] = {}
					},
					["17512790610608898116"] = {
						["key"] = "17512790610608898116",
						["type"] = "GoToNode",
						["name"] = "前往煜明处",
						["pos"] = {
							["x"] = 1960.5007503031861,
							["y"] = 803.9021825310911
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040034,
							["GuideType"] = "P",
							["GuidePointName"] = "RegionPoint_Cav_Door01"
						}
					},
					["175178217377812692667"] = {
						["key"] = "175178217377812692667",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2344.0526081089015,
							["y"] = 806.8413033699075
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040093,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2040093"
						}
					},
					["1752734412159967035"] = {
						["key"] = "1752734412159967035",
						["type"] = "TalkNode",
						["name"] = "【SC004】主角加入战斗",
						["pos"] = {
							["x"] = 3019.892397660819,
							["y"] = 808.8210526315789
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC004/SQ_Ver0101_SC004",
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
					["17623353631573111657"] = {
						["key"] = "17623353631573111657",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成狴犴&煜明",
						["pos"] = {
							["x"] = 2252.2105263157887,
							["y"] = 646.2499999999999
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2040127,
								2040128,
								2040132,
								2040133
							}
						}
					},
					["17626037266308257262"] = {
						["key"] = "17626037266308257262",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁狴犴&煜明",
						["pos"] = {
							["x"] = 2649.8835494484874,
							["y"] = 610.158180209883
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2040127,
								2040128,
								2040132,
								2040133
							}
						}
					},
					["17651813091839080"] = {
						["key"] = "17651813091839080",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2712.6513157894738,
							["y"] = 823.5789473684209
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/1_1/0107_story_zhuyinzhizai_full",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								104103
							},
							["bStoreToServer"] = false
						}
					},
					["17651813623479584"] = {
						["key"] = "17651813623479584",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 3177.983123569794,
							["y"] = 506.62242562929083
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
		["17532380571306650"] = {
			["isStoryNode"] = true,
			["key"] = "17532380571306650",
			["type"] = "StoryNode",
			["name"] = "跟随Cav（03）",
			["pos"] = {
				["x"] = 1775.408506405043,
				["y"] = 904.5658188585605
			},
			["propsData"] = {
				["QuestId"] = 12010252,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_6",
				["QuestDeatil"] = "Content_120102_6",
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
				["SubRegionId"] = 104103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "RegionPoint_Cav_03",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17532380571306660",
						["startPort"] = "QuestStart",
						["endQuest"] = "17532380571326664",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17532380571326664",
						["startPort"] = "Out",
						["endQuest"] = "17532380571326665",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17532380571326665",
						["startPort"] = "Out",
						["endQuest"] = "17532380571306659",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17532380571306659",
						["startPort"] = "Out",
						["endQuest"] = "176260921682515190720",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176260921682515190720",
						["startPort"] = "Out",
						["endQuest"] = "17532380571326661",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17532380571306659"] = {
						["key"] = "17532380571306659",
						["type"] = "TalkNode",
						["name"] = "站桩 - 告别煜明 Fixsimple08",
						["pos"] = {
							["x"] = 2948.323669893287,
							["y"] = 810.0843055017446
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011702,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_18a",
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
					["17532380571306660"] = {
						["key"] = "17532380571306660",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2018.7437743416012,
							["y"] = 812.1420638540204
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17532380571326661"] = {
						["key"] = "17532380571326661",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3561.9460257398478,
							["y"] = 837.7240042864705
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17532380571326662"] = {
						["key"] = "17532380571326662",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4131.015303613398,
							["y"] = 1006.2553483953211
						},
						["propsData"] = {}
					},
					["17532380571326664"] = {
						["key"] = "17532380571326664",
						["type"] = "GoToNode",
						["name"] = "前往洞穴出口",
						["pos"] = {
							["x"] = 2329.924930510065,
							["y"] = 801.8830147426954
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040046,
							["GuideType"] = "P",
							["GuidePointName"] = "RegionPoint_Cav_03"
						}
					},
					["17532380571326665"] = {
						["key"] = "17532380571326665",
						["type"] = "TalkNode",
						["name"] = "站桩 - 告别煜明 Fixsimple08",
						["pos"] = {
							["x"] = 2640.131670991805,
							["y"] = 804.5161364102997
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_18",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = true,
							["StartFadeOutTime"] = 0.5,
							["StartScreenEffectDuration"] = 1,
							["FinishFadeInTime"] = 1,
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
									["TalkActorId"] = 210007,
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
					["176260921682515190720"] = {
						["key"] = "176260921682515190720",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 3233.398311422204,
							["y"] = 814.4060214474807
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpawnPoint_Cav02",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["175325486419625280"] = {
			["isStoryNode"] = true,
			["key"] = "175325486419625280",
			["type"] = "StoryNode",
			["name"] = "战斗结束后对话",
			["pos"] = {
				["x"] = 1176.262912889547,
				["y"] = 607.458750152441
			},
			["propsData"] = {
				["QuestId"] = 12010253,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_5",
				["QuestDeatil"] = "Content_120102_5",
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
				["SubRegionId"] = 104103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_120102074",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "175325491235926549",
						["startPort"] = "Out",
						["endQuest"] = "175325491235926550",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175325486419625281",
						["startPort"] = "QuestStart",
						["endQuest"] = "175325491235926549",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175325491235926550",
						["startPort"] = "Out",
						["endQuest"] = "175325486419625284",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["175325486419625281"] = {
						["key"] = "175325486419625281",
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
					["175325486419625284"] = {
						["key"] = "175325486419625284",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1910,
							["y"] = 318
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["175325486419625287"] = {
						["key"] = "175325486419625287",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["175325491235926549"] = {
						["key"] = "175325491235926549",
						["type"] = "TalkNode",
						["name"] = "【SC003】煜明登场",
						["pos"] = {
							["x"] = 1163.8585584951688,
							["y"] = 291.8895182474904
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC003/SQ_Ver0101_SC003",
							["BlendInTime"] = 0.5,
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
					["175325491235926550"] = {
						["key"] = "175325491235926550",
						["type"] = "TalkNode",
						["name"] = "站桩 - 初遇煜明 Fixsimple07",
						["pos"] = {
							["x"] = 1506.1414415048316,
							["y"] = 294.1104817525095
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_17",
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
									["TalkActorId"] = 210007,
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
		["17623342067682078711"] = {
			["isStoryNode"] = true,
			["key"] = "17623342067682078711",
			["type"] = "StoryNode",
			["name"] = "前往洞穴【平原】",
			["pos"] = {
				["x"] = 3073.4453667751795,
				["y"] = 298.7928649819715
			},
			["propsData"] = {
				["QuestId"] = 12010254,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_4",
				["QuestDeatil"] = "Content_120102_4",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QuestTrigger_2080015",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17623342797312080436",
						["startPort"] = "Out",
						["endQuest"] = "17623342797312080435",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623342067682078712",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623342797312080436",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623342797312080436",
						["startPort"] = "Out",
						["endQuest"] = "176235943127731851959",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176235943127731851959",
						["startPort"] = "Out",
						["endQuest"] = "17623342067692078715",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17623342067682078712"] = {
						["key"] = "17623342067682078712",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 874,
							["y"] = 374
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623342067692078715"] = {
						["key"] = "17623342067692078715",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1992.695652173913,
							["y"] = 381.1304347826087
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623342067692078718"] = {
						["key"] = "17623342067692078718",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17623342797312080435"] = {
						["key"] = "17623342797312080435",
						["type"] = "TalkNode",
						["name"] = "开车- 到山洞前",
						["pos"] = {
							["x"] = 1666.5525907159204,
							["y"] = 229.12675711016666
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011001,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17623342797312080436"] = {
						["key"] = "17623342797312080436",
						["type"] = "GoToNode",
						["name"] = "前往洞穴",
						["pos"] = {
							["x"] = 1331.4474092840792,
							["y"] = 366.0906341941812
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080015,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2080015"
						}
					},
					["176235943127731851959"] = {
						["key"] = "176235943127731851959",
						["type"] = "CameraLookAtNode",
						["name"] = "CameraLookAt",
						["pos"] = {
							["x"] = 1646.8755720823797,
							["y"] = 388.0580663615562
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "LookAtPoint_PlaiToCav",
							["ActorId"] = 0,
							["Duration"] = 3,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					}
				},
				["commentData"] = {}
			}
		},
		["176235841479029799870"] = {
			["isStoryNode"] = true,
			["key"] = "176235841479029799870",
			["type"] = "StoryNode",
			["name"] = "离开洞穴",
			["pos"] = {
				["x"] = 3634.982150459082,
				["y"] = 625.5185859519219
			},
			["propsData"] = {
				["QuestId"] = 12010214,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_11",
				["QuestDeatil"] = "Content_120102_11",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = true,
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
						["startQuest"] = "176235841479029799875",
						["startPort"] = "QuestStart",
						["endQuest"] = "176235841479029799878",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176235841479029799878",
						["startPort"] = "Out",
						["endQuest"] = "176261265057418163238",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176261265057418163238",
						["startPort"] = "Out",
						["endQuest"] = "176261262277518162342",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176261262277518162342",
						["startPort"] = "Out",
						["endQuest"] = "176235841479029799876",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["176235841479029799875"] = {
						["key"] = "176235841479029799875",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2019.3017953311064,
							["y"] = 809.6496725496727
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176235841479029799876"] = {
						["key"] = "176235841479029799876",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3156.92147691406,
							["y"] = 811.8972229542125
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176235841479029799877"] = {
						["key"] = "176235841479029799877",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4029.3877174065015,
							["y"] = 949.8553483953211
						},
						["propsData"] = {}
					},
					["176235841479029799878"] = {
						["key"] = "176235841479029799878",
						["type"] = "GoToNode",
						["name"] = "离开洞穴前往出口",
						["pos"] = {
							["x"] = 2292.3191602769643,
							["y"] = 798.2488556984424
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040032,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2040032"
						}
					},
					["176261262277518162342"] = {
						["key"] = "176261262277518162342",
						["type"] = "TalkNode",
						["name"] = "【Show_Shi_RegionUI】",
						["pos"] = {
							["x"] = 2869,
							["y"] = 789
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East01/Shi/Show_Shi_RegionUI",
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
					["176261265057418163238"] = {
						["key"] = "176261265057418163238",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2577,
							["y"] = 792
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpawnPoint_Cav_Out",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}