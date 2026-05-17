return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17292500774591",
			["startPort"] = "StoryStart",
			["endStory"] = "1729250106331137",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1729250106331137",
			["startPort"] = "Success",
			["endStory"] = "1729684563989741",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1729684563989741",
			["startPort"] = "Success",
			["endStory"] = "17297503632772664460",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17297503632772664460",
			["startPort"] = "Success",
			["endStory"] = "17297523075049139191",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17297523075049139191",
			["startPort"] = "Success",
			["endStory"] = "172975495373411429037",
			["endPort"] = "In"
		},
		{
			["startStory"] = "172975495373411429037",
			["startPort"] = "Success",
			["endStory"] = "172975541764912953502",
			["endPort"] = "In"
		},
		{
			["startStory"] = "172975541764912953502",
			["startPort"] = "Success",
			["endStory"] = "172975632306116386188",
			["endPort"] = "In"
		},
		{
			["startStory"] = "172975632306116386188",
			["startPort"] = "Success",
			["endStory"] = "172976220001520784705",
			["endPort"] = "In"
		},
		{
			["startStory"] = "172976220001520784705",
			["startPort"] = "Success",
			["endStory"] = "17292500774605",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17292500774591"] = {
			["isStoryNode"] = true,
			["key"] = "17292500774591",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 120003
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17292500774605"] = {
			["isStoryNode"] = true,
			["key"] = "17292500774605",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1929.648882830707,
				["y"] = 453.4633308023237
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1729250106331137"] = {
			["isStoryNode"] = true,
			["key"] = "1729250106331137",
			["type"] = "StoryNode",
			["name"] = "酒馆闲聊",
			["pos"] = {
				["x"] = 1088.3174603174605,
				["y"] = 287.7142857142857
			},
			["propsData"] = {
				["QuestId"] = 12000301,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120003_1",
				["QuestDeatil"] = "Content_120003_1",
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
				["SubRegionId"] = 101107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12000101_1220106",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1736064837968240056",
						["startPort"] = "Out",
						["endQuest"] = "1737688921940258458",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1737688921940258458",
						["startPort"] = "Out",
						["endQuest"] = "1737688923309258484",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17377021690622269908",
						["startPort"] = "Out",
						["endQuest"] = "1736064837968240056",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1737688923309258484",
						["startPort"] = "Out",
						["endQuest"] = "173779373643826582825",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173779373643826582825",
						["startPort"] = "Out",
						["endQuest"] = "1729250106331142",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1729250106331141",
						["startPort"] = "QuestStart",
						["endQuest"] = "17377021690622269908",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1729250106331141"] = {
						["key"] = "1729250106331141",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1842.0388232457199,
							["y"] = 445.9705811429949
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1729250106331142"] = {
						["key"] = "1729250106331142",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3207.736985235032,
							["y"] = 756.6029081190102
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 210101,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["1729250106331143"] = {
						["key"] = "1729250106331143",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["1736064837968240055"] = {
						["key"] = "1736064837968240055",
						["type"] = "GoToRegionNode",
						["name"] = "进入酒馆内区域检测",
						["pos"] = {
							["x"] = 2173.9002079002075,
							["y"] = 618.8210573210574
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_12010101"
						}
					},
					["1736064837968240056"] = {
						["key"] = "1736064837968240056",
						["type"] = "TalkNode",
						["name"] = "站桩 - 小白 Fixsimple01",
						["pos"] = {
							["x"] = 2441.992145992147,
							["y"] = 609.7344982344982
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 200002,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Xiaobai12000301_1220112",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12001541,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000301",
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
							["RestoreStand"] = true,
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
									["TalkActorId"] = 220019,
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
					["17364961986054083100"] = {
						["key"] = "17364961986054083100",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2568.079768189533,
							["y"] = 229.278479566064
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1220106,
							["GuideType"] = "N",
							["GuidePointName"] = "Xiaobai12000301"
						}
					},
					["1737688921940258458"] = {
						["key"] = "1737688921940258458",
						["type"] = "TalkNode",
						["name"] = "站桩 - 小白 Fixsimple01",
						["pos"] = {
							["x"] = 2702.3676252759697,
							["y"] = 604.2230887593404
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001549,
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
					["1737688923309258484"] = {
						["key"] = "1737688923309258484",
						["type"] = "TalkNode",
						["name"] = "站桩 - 小白 Fixsimple01",
						["pos"] = {
							["x"] = 2967.046215070839,
							["y"] = 591.5518128322504
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001550,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000301",
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
									["TalkActorId"] = 220019,
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
					["17377021690622269908"] = {
						["key"] = "17377021690622269908",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2278.749703442931,
							["y"] = 250.71770430511918
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Xiaobai12000301_1220112",
							["StaticCreatorIdList"] = {
								1220112,
								1220108
							}
						}
					},
					["173779373643826582825"] = {
						["key"] = "173779373643826582825",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3210.3503780066153,
							["y"] = 596.4600025366517
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Xiaobai12000301",
							["StaticCreatorIdList"] = {
								1220112,
								1220108
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1729684563989741"] = {
			["isStoryNode"] = true,
			["key"] = "1729684563989741",
			["type"] = "StoryNode",
			["name"] = "前往门口",
			["pos"] = {
				["x"] = 1344.5957235549783,
				["y"] = 285.62595723214963
			},
			["propsData"] = {
				["QuestId"] = 12000302,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120003_2",
				["QuestDeatil"] = "Content_120003_2",
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
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_EX01",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1729740332630413",
						["startPort"] = "Out",
						["endQuest"] = "1729740341799726",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1729740341799726",
						["startPort"] = "Out",
						["endQuest"] = "1729740379783381322",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1729740379783381322",
						["startPort"] = "Out",
						["endQuest"] = "1729740387295381604",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1729740387295381604",
						["startPort"] = "Out",
						["endQuest"] = "17297502553742283321",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1736065343930242228",
						["startPort"] = "Out",
						["endQuest"] = "1736065343930242229",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1736065005906241501",
						["startPort"] = "Out",
						["endQuest"] = "1736065343930242231",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1736065343930242229",
						["startPort"] = "Out",
						["endQuest"] = "1729684563990746",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1736065343930242231",
						["startPort"] = "Out",
						["endQuest"] = "1736065343930242228",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1729684563990745",
						["startPort"] = "QuestStart",
						["endQuest"] = "1736065005906241501",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1729684563990745"] = {
						["key"] = "1729684563990745",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1893.7629611767545,
							["y"] = 439.7636845912707
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1729684563990746"] = {
						["key"] = "1729684563990746",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3866.551250100851,
							["y"] = 467.81094206940656
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1729684563990747"] = {
						["key"] = "1729684563990747",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3334.295662512609,
							["y"] = 656.1123554931786
						},
						["propsData"] = {}
					},
					["1729740332630413"] = {
						["key"] = "1729740332630413",
						["type"] = "GoToRegionNode",
						["name"] = "进入东国区域检测",
						["pos"] = {
							["x"] = 2073.9605911330054,
							["y"] = 67.41871921182224
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_12010302"
						}
					},
					["1729740341799726"] = {
						["key"] = "1729740341799726",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成黑市商人A",
						["pos"] = {
							["x"] = 2341.399014778325,
							["y"] = 87.8128078817731
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1930060
							}
						}
					},
					["1729740379783381322"] = {
						["key"] = "1729740379783381322",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和黑市商人聊天 Fixsimple10",
						["pos"] = {
							["x"] = 2612.4827586206907,
							["y"] = 87.07389162561532
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210008,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_MerchantA_1930060",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12012101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_10",
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
									["TalkActorId"] = 210008,
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
					["1729740387295381604"] = {
						["key"] = "1729740387295381604",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁黑市商人A",
						["pos"] = {
							["x"] = 2871.7438423645326,
							["y"] = 107.3201970443346
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1930060
							}
						}
					},
					["17297502553742283321"] = {
						["key"] = "17297502553742283321",
						["type"] = "TalkNode",
						["name"] = "开车- 那里发生了什么",
						["pos"] = {
							["x"] = 3121.9237524095092,
							["y"] = 106.65624330691782
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12012201,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1736065005906241501"] = {
						["key"] = "1736065005906241501",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2445.67984197965,
							["y"] = 452.46291628554803
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1210087
							}
						}
					},
					["1736065343930242228"] = {
						["key"] = "1736065343930242228",
						["type"] = "TalkNode",
						["name"] = "黑屏 - 前往天黑",
						["pos"] = {
							["x"] = 3053.9253835561344,
							["y"] = 460.44917974709165
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11017401,
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
					["1736065343930242229"] = {
						["key"] = "1736065343930242229",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3573.6521171130103,
							["y"] = 476.2548170772633
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1210087
							}
						}
					},
					["1736065343930242231"] = {
						["key"] = "1736065343930242231",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 2716.5274335736,
							["y"] = 446.0799837673095
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 10060,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "NewTargetPoint12000302",
							["IsUseCount"] = false
						}
					}
				},
				["commentData"] = {
					["1736067259277244597"] = {
						["key"] = "1736067259277244597",
						["name"] = "触发提示弹窗",
						["position"] = {
							["x"] = 2691.2922365436534,
							["y"] = 348.01308165121384
						},
						["size"] = {
							["width"] = 807.0967741935492,
							["height"] = 289.35483870967767
						}
					}
				}
			}
		},
		["17297503632772664460"] = {
			["isStoryNode"] = true,
			["key"] = "17297503632772664460",
			["type"] = "StoryNode",
			["name"] = "门口的演出",
			["pos"] = {
				["x"] = 1587.9543554015936,
				["y"] = 276.7954871276133
			},
			["propsData"] = {
				["QuestId"] = 12000303,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120003_3",
				["QuestDeatil"] = "Content_120003_3",
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
						["startQuest"] = "17297503632772664464",
						["startPort"] = "QuestStart",
						["endQuest"] = "173651656632034824817",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17392610015844082435",
						["startPort"] = "Out",
						["endQuest"] = "17392610015844082436",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17392610112784082592",
						["startPort"] = "Out",
						["endQuest"] = "17392610112784082593",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17297503632772664464",
						["startPort"] = "QuestStart",
						["endQuest"] = "17392610015844082435",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17297503632772664464",
						["startPort"] = "QuestStart",
						["endQuest"] = "17392610112784082592",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562857693273456",
						["startPort"] = "Out",
						["endQuest"] = "17297503632772664465",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173651656632034824817",
						["startPort"] = "Out",
						["endQuest"] = "17625895250456581",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17625895250456581",
						["startPort"] = "Out",
						["endQuest"] = "17360689212282192132",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17360689212282192132",
						["startPort"] = "Out",
						["endQuest"] = "17625895906137266",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17625895906137266",
						["startPort"] = "Out",
						["endQuest"] = "17625896173367921",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17625896190327981",
						["startPort"] = "Out",
						["endQuest"] = "17562857693273456",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17297514826724188018",
						["startPort"] = "Out",
						["endQuest"] = "17625896190327981",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17625896173367921",
						["startPort"] = "Out",
						["endQuest"] = "17297514826724188018",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173651656632034824817",
						["startPort"] = "Out",
						["endQuest"] = "176285345394712619589",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176285369398914606685",
						["startPort"] = "Out",
						["endQuest"] = "176285370223714606867",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17297503632772664464"] = {
						["key"] = "17297503632772664464",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1893.7629611767545,
							["y"] = 439.7636845912707
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17297503632772664465"] = {
						["key"] = "17297503632772664465",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3311.0997436952734,
							["y"] = 447.04532324531675
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17297503632772664466"] = {
						["key"] = "17297503632772664466",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3260.532084548311,
							["y"] = 601.6163207988767
						},
						["propsData"] = {}
					},
					["17297514826724188018"] = {
						["key"] = "17297514826724188018",
						["type"] = "TalkNode",
						["name"] = "站桩 - 小白 Fixsimple11",
						["pos"] = {
							["x"] = 2795.216568946202,
							["y"] = 298.29427386043636
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000303",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0.5,
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
							["SkipToOption"] = true,
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
					["17360689212282192132"] = {
						["key"] = "17360689212282192132",
						["type"] = "TalkNode",
						["name"] = "过场动画-撞小白",
						["pos"] = {
							["x"] = 2497.015363910318,
							["y"] = 302.1230397055393
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0104/OBT0104_SC001/SQ_OBT0104_SC001",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = false,
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
					["173651656632034824817"] = {
						["key"] = "173651656632034824817",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2162.3332545514068,
							["y"] = 350.6485533587152
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191032,
							["GuideType"] = "P",
							["GuidePointName"] = "NewTargetPoint_12000303"
						}
					},
					["17391909647793060860"] = {
						["key"] = "17391909647793060860",
						["type"] = "HasDetectiveResultNode",
						["name"] = "检测是否获取过推理结果",
						["pos"] = {
							["x"] = 3198.8558250610213,
							["y"] = 885.7666718778632
						},
						["propsData"] = {
							["ResultIds"] = {}
						}
					},
					["17391909915393061798"] = {
						["key"] = "17391909915393061798",
						["type"] = "HasDetectiveResultNode",
						["name"] = "检测是否获取过推理结果",
						["pos"] = {
							["x"] = 3171.242909153099,
							["y"] = 1088.4167847325823
						},
						["propsData"] = {
							["ResultIds"] = {}
						}
					},
					["17392610015844082435"] = {
						["key"] = "17392610015844082435",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖城",
						["pos"] = {
							["x"] = 2196.1944206747585,
							["y"] = 685.5627624592911
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17392610015844082436"] = {
						["key"] = "17392610015844082436",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2453.301024223193,
							["y"] = 685.8864508213874
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["17392610112784082592"] = {
						["key"] = "17392610112784082592",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = 2185.7339505602044,
							["y"] = 847.5658862316191
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17392610112784082593"] = {
						["key"] = "17392610112784082593",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2456.281676857931,
							["y"] = 867.536714202447
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["17562857693273456"] = {
						["key"] = "17562857693273456",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3068.7784546897674,
							["y"] = 437.72200889423004
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191039
							}
						}
					},
					["17625894553146351"] = {
						["key"] = "17625894553146351",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2138.413384683431,
							["y"] = 4.283376542884639
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17625895250456581"] = {
						["key"] = "17625895250456581",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放暂停音乐",
						["pos"] = {
							["x"] = 2508.701544799178,
							["y"] = 152.63158006350196
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17625895906137266"] = {
						["key"] = "17625895906137266",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "关音乐",
						["pos"] = {
							["x"] = 2491.2538287221514,
							["y"] = 467.8773256971785
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17625896173367921"] = {
						["key"] = "17625896173367921",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放暂停音乐",
						["pos"] = {
							["x"] = 2805.3655556150247,
							["y"] = 166.12101997231304
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0016_judian.0016_judian'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17625896190327981"] = {
						["key"] = "17625896190327981",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "关音乐",
						["pos"] = {
							["x"] = 2798.0928283422977,
							["y"] = 464.30283815413117
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["176285345394712619589"] = {
						["key"] = "176285345394712619589",
						["type"] = "AuConditionNode",
						["name"] = "音频条件节点",
						["pos"] = {
							["x"] = 2545.509182908546,
							["y"] = 5.4092953523238805
						},
						["propsData"] = {
							["ActionType"] = 0,
							["Condition"] = "cp2_dgyr",
							["SaveToServer"] = true
						}
					},
					["176285369398914606685"] = {
						["key"] = "176285369398914606685",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 2111.3546405783823,
							["y"] = -201.94492620799227
						},
						["propsData"] = {
							["QuestRoleId"] = 0,
							["IsPlayFX"] = false
						}
					},
					["176285370223714606867"] = {
						["key"] = "176285370223714606867",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "激活/失效 玩家技能",
						["pos"] = {
							["x"] = 2338.829723634861,
							["y"] = -140.00209197726713
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = false,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Skill2"
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17297523075049139191"] = {
			["isStoryNode"] = true,
			["key"] = "17297523075049139191",
			["type"] = "StoryNode",
			["name"] = "电话亭不远处",
			["pos"] = {
				["x"] = 1843.811966442695,
				["y"] = 280.3794003917684
			},
			["propsData"] = {
				["QuestId"] = 12000304,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120003_4",
				["QuestDeatil"] = "Content_120003_4",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17297523075049139201",
						["startPort"] = "Out",
						["endQuest"] = "17297523075049139196",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17360690292663161233",
						["startPort"] = "Out",
						["endQuest"] = "17297523075049139201",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185192639915529572",
						["startPort"] = "Out",
						["endQuest"] = "174185192639915529573",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185192639915529574",
						["startPort"] = "Out",
						["endQuest"] = "174185192639915529575",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17297523075049139195",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185192639915529572",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17297523075049139195",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185192639915529574",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762590029013996975",
						["startPort"] = "Out",
						["endQuest"] = "17360690292663161233",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185192639915529573",
						["startPort"] = "Out",
						["endQuest"] = "1762590029013996975",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17297523075049139195"] = {
						["key"] = "17297523075049139195",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2308.0486754624685,
							["y"] = 494.00331592767617
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17297523075049139196"] = {
						["key"] = "17297523075049139196",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3394.5100885228608,
							["y"] = 458.41084048669603
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17297523075049139197"] = {
						["key"] = "17297523075049139197",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3995.532084548312,
							["y"] = 575.6163207988767
						},
						["propsData"] = {}
					},
					["17297523075049139201"] = {
						["key"] = "17297523075049139201",
						["type"] = "TalkNode",
						["name"] = "站桩 - 询问情况 Fixsimple11",
						["pos"] = {
							["x"] = 3111.201547082296,
							["y"] = 470.1133168219709
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001720,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000304",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0.5,
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
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220022,
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
					["17360690292663161233"] = {
						["key"] = "17360690292663161233",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2850.2844199164083,
							["y"] = 474.343342451739
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191035,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000304_1191035"
						}
					},
					["174185192639915529572"] = {
						["key"] = "174185192639915529572",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖城",
						["pos"] = {
							["x"] = 2533.351987045964,
							["y"] = 309.48762032575024
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185192639915529573"] = {
						["key"] = "174185192639915529573",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2806.31112515661,
							["y"] = 308.4288202085838
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["174185192639915529574"] = {
						["key"] = "174185192639915529574",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = 2658.0067243046815,
							["y"] = 938.0345228999211
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185192639915529575"] = {
						["key"] = "174185192639915529575",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2974.268736316694,
							["y"] = 933.7196365850348
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["1762590029013996975"] = {
						["key"] = "1762590029013996975",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放暂停音乐",
						["pos"] = {
							["x"] = 2571.445459078982,
							["y"] = 494.7343934841317
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								101101
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["1762590029013996976"] = {
						["key"] = "1762590029013996976",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "关音乐",
						["pos"] = {
							["x"] = 3222.860973671916,
							["y"] = 59.471720673072184
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17625950551921985361"] = {
						["key"] = "17625950551921985361",
						["type"] = "TalkNode",
						["name"] = "站桩 - 询问情况 Fixsimple11",
						["pos"] = {
							["x"] = 3397.7917838890153,
							["y"] = 674.9858334919757
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001720,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000304",
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
									["TalkActorId"] = 220022,
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
		["172975495373411429037"] = {
			["isStoryNode"] = true,
			["key"] = "172975495373411429037",
			["type"] = "StoryNode",
			["name"] = "电话亭",
			["pos"] = {
				["x"] = 2098.006688785061,
				["y"] = 275.1373837549994
			},
			["propsData"] = {
				["QuestId"] = 12000305,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120003_5",
				["QuestDeatil"] = "Content_120003_5",
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
				["StoryGuidePointName"] = "Mechanism_12000305_1191038",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "172975511386711810437",
						["startPort"] = "Out",
						["endQuest"] = "172975495373411429044",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975495373411429044",
						["startPort"] = "Out",
						["endQuest"] = "172976126090720014725",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975495373411429041",
						["startPort"] = "QuestStart",
						["endQuest"] = "17360691206653162651",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173686267783920257138",
						["startPort"] = "Out",
						["endQuest"] = "17388290769604075647",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185193461615529905",
						["startPort"] = "Out",
						["endQuest"] = "174185193461615529906",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185193461615529907",
						["startPort"] = "Out",
						["endQuest"] = "174185193461615529908",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975495373411429041",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185193461615529905",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975495373411429041",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185193461615529907",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753257990684988481",
						["startPort"] = "Out",
						["endQuest"] = "17360699731685099583",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17360699731685099583",
						["startPort"] = "Out",
						["endQuest"] = "17562860411345202",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562860411345202",
						["startPort"] = "Out",
						["endQuest"] = "172975495373411429042",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17360691206653162651",
						["startPort"] = "Out",
						["endQuest"] = "17626006756111988301",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626006756111988301",
						["startPort"] = "Out",
						["endQuest"] = "173686186326616400265",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173686186326616400265",
						["startPort"] = "Out",
						["endQuest"] = "17626022250932977319",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626022250932977319",
						["startPort"] = "Out",
						["endQuest"] = "173686267783920257138",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626024816852979684",
						["startPort"] = "Out",
						["endQuest"] = "17626024816852979685",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388290769604075647",
						["startPort"] = "Out",
						["endQuest"] = "17626024816852979684",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626024816852979685",
						["startPort"] = "Out",
						["endQuest"] = "17360696807954131645",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17360696807954131645",
						["startPort"] = "Out",
						["endQuest"] = "17626025275792980293",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626025275792980293",
						["startPort"] = "Out",
						["endQuest"] = "1753257990684988481",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["172975495373411429041"] = {
						["key"] = "172975495373411429041",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2255.2486754624683,
							["y"] = 436.90654173412787
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172975495373411429042"] = {
						["key"] = "172975495373411429042",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4250.805577011291,
							["y"] = 774.841874950197
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172975495373411429043"] = {
						["key"] = "172975495373411429043",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4099.797818814046,
							["y"] = 1094.0079291904847
						},
						["propsData"] = {}
					},
					["172975495373411429044"] = {
						["key"] = "172975495373411429044",
						["type"] = "TalkNode",
						["name"] = "站桩 - 询问情况 Fixsimple11",
						["pos"] = {
							["x"] = 2779.356995800245,
							["y"] = 167.85209887325306
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12012701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_14",
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
									["TalkActorId"] = 210012,
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
					["172975511386711810437"] = {
						["key"] = "172975511386711810437",
						["type"] = "GoToNode",
						["name"] = "进办公室",
						["pos"] = {
							["x"] = 2652.2767518102714,
							["y"] = 322.8965224104615
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1930071,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_12010305"
						}
					},
					["172976126090720014725"] = {
						["key"] = "172976126090720014725",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁黑市商人B和年轻女孩",
						["pos"] = {
							["x"] = 2899.8478076323017,
							["y"] = 348.9228631260554
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1930061,
								1930062
							}
						}
					},
					["17360691206653162651"] = {
						["key"] = "17360691206653162651",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2634.165517501514,
							["y"] = 496.1880206864937
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191038,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000305_1191038"
						}
					},
					["17360696807954131645"] = {
						["key"] = "17360696807954131645",
						["type"] = "TalkNode",
						["name"] = "站桩 - 假黑桃和长官 Fixsimple11",
						["pos"] = {
							["x"] = 3739.5593441436617,
							["y"] = 545.0939061786247
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001737,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000305",
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
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220022,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220032,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220033,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220034,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220035,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220036,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17360699731685099583"] = {
						["key"] = "17360699731685099583",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 4271.522489075243,
							["y"] = 544.7842458329992
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_12000305",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["173686186326616400265"] = {
						["key"] = "173686186326616400265",
						["type"] = "TalkNode",
						["name"] = "过场动画-走近电话亭 Fixsimple11",
						["pos"] = {
							["x"] = 2910.1541641785634,
							["y"] = 511.92151487633566
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1200/12002001.12002001'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000305",
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
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220022,
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
					["173686267783920257138"] = {
						["key"] = "173686267783920257138",
						["type"] = "TalkNode",
						["name"] = "站桩 - 假黑桃和白 Fixsimple11",
						["pos"] = {
							["x"] = 3191.5651941194606,
							["y"] = 507.78280335259893
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001731,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000305",
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
									["TalkActorId"] = 220022,
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
					["17388290769604075647"] = {
						["key"] = "17388290769604075647",
						["type"] = "TalkNode",
						["name"] = "黑幕说白走了",
						["pos"] = {
							["x"] = 3474.3014767954105,
							["y"] = 524.041571576562
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001785,
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
					["174185193461615529905"] = {
						["key"] = "174185193461615529905",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖城",
						["pos"] = {
							["x"] = 2495.1706576226993,
							["y"] = 910.6282605994544
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185193461615529906"] = {
						["key"] = "174185193461615529906",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2759.4201183139908,
							["y"] = 906.6662346758363
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["174185193461615529907"] = {
						["key"] = "174185193461615529907",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = 2507.567330365288,
							["y"] = 1096.9170986574966
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185193461615529908"] = {
						["key"] = "174185193461615529908",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2823.8293423773002,
							["y"] = 1092.6022123426103
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["17526460229855857"] = {
						["key"] = "17526460229855857",
						["type"] = "TalkNode",
						["name"] = "过场动画-靠近",
						["pos"] = {
							["x"] = 3191.7929551161747,
							["y"] = 1256.2220373821472
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East00/NPC_CloseTo",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = false,
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
					["1753257990684988481"] = {
						["key"] = "1753257990684988481",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成白和止流",
						["pos"] = {
							["x"] = 4004.4922384520305,
							["y"] = 550.3194456929215
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191041
							}
						}
					},
					["17562860411345202"] = {
						["key"] = "17562860411345202",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3932.749265169982,
							["y"] = 757.6126814525786
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191039
							}
						}
					},
					["17626006756111988301"] = {
						["key"] = "17626006756111988301",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放音乐",
						["pos"] = {
							["x"] = 2800.983645880754,
							["y"] = 712.2844186172972
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0035_atomos_thrill.0035_atomos_thrill'",
							["ParamKey"] = "ToEnd",
							["ParamValue"] = 1,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17626022250932977319"] = {
						["key"] = "17626022250932977319",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放暂停音乐",
						["pos"] = {
							["x"] = 3081.5100671068076,
							["y"] = 715.2867498374462
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17626024816852979684"] = {
						["key"] = "17626024816852979684",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "关音乐",
						["pos"] = {
							["x"] = 3547.996049448374,
							["y"] = 339.2072255217613
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17626024816852979685"] = {
						["key"] = "17626024816852979685",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放音乐",
						["pos"] = {
							["x"] = 3826.650032378673,
							["y"] = 353.05521119540504
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0043_story_empire.0043_story_empire'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17626025275792980293"] = {
						["key"] = "17626025275792980293",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放暂停音乐",
						["pos"] = {
							["x"] = 4128.161529970152,
							["y"] = 367.7928827001575
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								101101
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					}
				},
				["commentData"] = {}
			}
		},
		["172975541764912953502"] = {
			["isStoryNode"] = true,
			["key"] = "172975541764912953502",
			["type"] = "StoryNode",
			["name"] = "角落站桩-白回来",
			["pos"] = {
				["x"] = 2362.1121684769378,
				["y"] = 271.9340224104617
			},
			["propsData"] = {
				["QuestId"] = 12000306,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120003_6",
				["QuestDeatil"] = "Content_120003_6",
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
				["StoryGuidePointName"] = "Xiaobai_12000306_1191041",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17400419801332347526",
						["startPort"] = "Out",
						["endQuest"] = "172975541764912953507",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "172975615582514479397",
						["startPort"] = "Out",
						["endQuest"] = "17400419801332347526",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185194371015530241",
						["startPort"] = "Out",
						["endQuest"] = "174185194371015530242",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185194371015530243",
						["startPort"] = "Out",
						["endQuest"] = "174185194371015530244",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975541764912953506",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185194371015530241",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975541764912953506",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185194371015530243",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975541764912953506",
						["startPort"] = "QuestStart",
						["endQuest"] = "172975615582514479397",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["172975541764912953506"] = {
						["key"] = "172975541764912953506",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2069.8619759550797,
							["y"] = 459.1375762168865
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172975541764912953507"] = {
						["key"] = "172975541764912953507",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2994.176908799358,
							["y"] = 463.85521037037574
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172975541764912953508"] = {
						["key"] = "172975541764912953508",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3995.532084548312,
							["y"] = 575.6163207988767
						},
						["propsData"] = {}
					},
					["172975615582514479397"] = {
						["key"] = "172975615582514479397",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和白聊天准备逃跑",
						["pos"] = {
							["x"] = 2531.091008432582,
							["y"] = 448.06972692482566
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 200002,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Xiaobai_12000306_1191041",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12001745,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000306",
							["BlendInTime"] = 1,
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
							["SkipToOption"] = true,
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
					["172976141569720397644"] = {
						["key"] = "172976141569720397644",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成白和止流",
						["pos"] = {
							["x"] = 2135.599170200588,
							["y"] = 200.72316457423048
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191041
							}
						}
					},
					["17400419801332347526"] = {
						["key"] = "17400419801332347526",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "删除白",
						["pos"] = {
							["x"] = 2769.6571122674486,
							["y"] = 467.8821645278128
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191041
							}
						}
					},
					["174185194371015530241"] = {
						["key"] = "174185194371015530241",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖城",
						["pos"] = {
							["x"] = 2280.0980291642013,
							["y"] = 710.8484516402978
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185194371015530242"] = {
						["key"] = "174185194371015530242",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2544.3474898554928,
							["y"] = 706.8864257166797
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["174185194371015530243"] = {
						["key"] = "174185194371015530243",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = 2292.49470190679,
							["y"] = 897.1372896983399
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185194371015530244"] = {
						["key"] = "174185194371015530244",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2608.7567139188022,
							["y"] = 892.8224033834537
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		},
		["172975632306116386188"] = {
			["isStoryNode"] = true,
			["key"] = "172975632306116386188",
			["type"] = "StoryNode",
			["name"] = "潜行玩法",
			["pos"] = {
				["x"] = 1079.0281461614102,
				["y"] = 443.38099714620154
			},
			["propsData"] = {
				["QuestId"] = 12000307,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120003_7",
				["QuestDeatil"] = "Content_120003_7",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "NewTargetPoint12000307StealthStart",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "172975673771917149815",
						["startPort"] = "Out",
						["endQuest"] = "172975674938317150108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975674938317150108",
						["startPort"] = "Out",
						["endQuest"] = "172975680630317151254",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17400505190362109",
						["startPort"] = "Out",
						["endQuest"] = "17400505190362110",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17400505190362110",
						["startPort"] = "Out",
						["endQuest"] = "17400505190362111",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17360701627245100655",
						["startPort"] = "Fail",
						["endQuest"] = "17400505190362108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17360701627245100655",
						["startPort"] = "Fail",
						["endQuest"] = "17400505190362107",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17400505190362114",
						["startPort"] = "Out",
						["endQuest"] = "17400505727673690",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17400505190362108",
						["startPort"] = "Out",
						["endQuest"] = "17400505190362114",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17400505190362107",
						["startPort"] = "Out",
						["endQuest"] = "17400505190362114",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17360701627245100655",
						["startPort"] = "Success",
						["endQuest"] = "174013796313613917015",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17406444609133158163",
						["startPort"] = "Out",
						["endQuest"] = "1740050694603789888",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185195098415530549",
						["startPort"] = "Out",
						["endQuest"] = "174185195098415530550",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185195098415530551",
						["startPort"] = "Out",
						["endQuest"] = "174185195098415530552",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975632306116386192",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185195098415530549",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172975632306116386192",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185195098415530551",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434269413807331953",
						["startPort"] = "Out",
						["endQuest"] = "17434261998684078158",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434261793554077880",
						["startPort"] = "Out",
						["endQuest"] = "17434269413807331953",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174013796313613917015",
						["startPort"] = "Out",
						["endQuest"] = "17400505190362109",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17360701627245100655",
						["startPort"] = "Fail",
						["endQuest"] = "17407264185626314146",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17407264185626314146",
						["startPort"] = "Out",
						["endQuest"] = "17400505190362114",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "17400505727673690",
						["startPort"] = "Out",
						["endQuest"] = "172975632306116386194",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17400505190362111",
						["startPort"] = "Out",
						["endQuest"] = "17406444609133158163",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1740050694603789888",
						["startPort"] = "Out",
						["endQuest"] = "172975632306116386193",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "172975632306116386192",
						["startPort"] = "QuestStart",
						["endQuest"] = "17569702576723089",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17569702576723089",
						["startPort"] = "Out",
						["endQuest"] = "17401335103189983881",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17360701627245100655",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17400505190362108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17360701627245100655",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17400505190362107",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17360701627245100655",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17407264185626314146",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17401335103189983881",
						["startPort"] = "Out",
						["endQuest"] = "17626025663312980848",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626025663312980848",
						["startPort"] = "Out",
						["endQuest"] = "17626026015272981524",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626026015272981524",
						["startPort"] = "Out",
						["endQuest"] = "17360701627245100655",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["172975632306116386192"] = {
						["key"] = "172975632306116386192",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1715.7486754624688,
							["y"] = 534.7065417341278
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172975632306116386193"] = {
						["key"] = "172975632306116386193",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4425.266558486346,
							["y"] = 303.73490571575735
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172975632306116386194"] = {
						["key"] = "172975632306116386194",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4081.804376772218,
							["y"] = 659.415432977021
						},
						["propsData"] = {}
					},
					["172975673771917149815"] = {
						["key"] = "172975673771917149815",
						["type"] = "GoToRegionNode",
						["name"] = "进入东国区域检测",
						["pos"] = {
							["x"] = 3735.819285048222,
							["y"] = 1105.4653785986734
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_12010101"
						}
					},
					["172975674938317150108"] = {
						["key"] = "172975674938317150108",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成扶疏",
						["pos"] = {
							["x"] = 3765.672863503748,
							["y"] = 1155.017508128314
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1930076
							}
						}
					},
					["172975680630317151254"] = {
						["key"] = "172975680630317151254",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3815.0748318180354,
							["y"] = 1182.2868151903256
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210013,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Fushu_1930076",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 12013201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17360701627245100655"] = {
						["key"] = "17360701627245100655",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "潜行特殊任务",
						["pos"] = {
							["x"] = 2545.8343863872983,
							["y"] = 536.6772266577606
						},
						["propsData"] = {
							["SpecialConfigId"] = 12000307,
							["BlackScreenImmediately"] = true
						}
					},
					["173686318436023151262"] = {
						["key"] = "173686318436023151262",
						["type"] = "TalkNode",
						["name"] = "假装潜行任务",
						["pos"] = {
							["x"] = 3704.5757200555026,
							["y"] = 1035.9670086147244
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12002100,
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
					["173686319318423151357"] = {
						["key"] = "173686319318423151357",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 3659.43756256806,
							["y"] = 967.9473062430383
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint12000307StealthStart",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17400505190362107"] = {
						["key"] = "17400505190362107",
						["type"] = "ForbidWeaponByWeaponTagNode",
						["name"] = "启用 武器节点",
						["pos"] = {
							["x"] = 3064.031771250717,
							["y"] = 657.4419530966827
						},
						["propsData"] = {
							["WeaponTags"] = {
								"Melee",
								"Ranged"
							},
							["bForbid"] = false,
							["ForbidTag"] = "ForbidDefault",
							["bHidewhenForbid"] = true
						}
					},
					["17400505190362108"] = {
						["key"] = "17400505190362108",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 3063.6755809952547,
							["y"] = 525.0741561339196
						},
						["propsData"] = {}
					},
					["17400505190362109"] = {
						["key"] = "17400505190362109",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 3027.7851436727556,
							["y"] = 332.86573921100955
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "BloodBar",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["17400505190362110"] = {
						["key"] = "17400505190362110",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 3295.9787465908007,
							["y"] = 314.71200026546643
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["17400505190362111"] = {
						["key"] = "17400505190362111",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 3519.9386982914816,
							["y"] = 317.29003599984065
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "Entrance",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["17400505190362114"] = {
						["key"] = "17400505190362114",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 3449.30780767695,
							["y"] = 637.363667638827
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["17400505727673690"] = {
						["key"] = "17400505727673690",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 3747.1691832564106,
							["y"] = 679.5350170477802
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "Steathpoint1",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1740050694603789888"] = {
						["key"] = "1740050694603789888",
						["type"] = "ForbidWeaponByWeaponTagNode",
						["name"] = "启用 武器节点",
						["pos"] = {
							["x"] = 4047.4927345123087,
							["y"] = 319.63191126506365
						},
						["propsData"] = {
							["WeaponTags"] = {
								"Melee",
								"Ranged"
							},
							["bForbid"] = false,
							["ForbidTag"] = "ForbidDefault",
							["bHidewhenForbid"] = true
						}
					},
					["17401335103189983881"] = {
						["key"] = "17401335103189983881",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2209.675320287402,
							["y"] = 518.6463795213502
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191141,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000307StealthStartBox_1191141"
						}
					},
					["17401335310949984248"] = {
						["key"] = "17401335310949984248",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1992.9650962120465,
							["y"] = 275.4049062591857
						},
						["propsData"] = {
							["WaitTime"] = 0.1
						}
					},
					["174013796313613917015"] = {
						["key"] = "174013796313613917015",
						["type"] = "SendMessageNode",
						["name"] = "探索组未激活",
						["pos"] = {
							["x"] = 3034.505396283158,
							["y"] = 200.7971540280964
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "East00SteathDie",
							["UnitId"] = -1
						}
					},
					["17406444609133158163"] = {
						["key"] = "17406444609133158163",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "禁止攻击放技能",
						["pos"] = {
							["x"] = 3782.5248742603794,
							["y"] = 303.4619463539773
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Attack",
								"Skill1",
								"Skill2",
								"Skill3",
								"FallAttack",
								"SlideAttack",
								"Fire",
								"Avoid",
								"HeavyAttack",
								"FireInAir",
								"BulletJump",
								"Jump",
								"Slide"
							}
						}
					},
					["17407264185626314146"] = {
						["key"] = "17407264185626314146",
						["type"] = "SendMessageNode",
						["name"] = "探索组重置",
						["pos"] = {
							["x"] = 3040.4229404428715,
							["y"] = 806.2435371343369
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "East00SteathDie",
							["UnitId"] = -1
						}
					},
					["174185195098415530549"] = {
						["key"] = "174185195098415530549",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖城",
						["pos"] = {
							["x"] = 1870.1706576227002,
							["y"] = 764.3365939327881
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185195098415530550"] = {
						["key"] = "174185195098415530550",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2108.9201183139917,
							["y"] = 773.87456800917
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["174185195098415530551"] = {
						["key"] = "174185195098415530551",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = 1783.5673303652889,
							["y"] = 908.6254319908304
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185195098415530552"] = {
						["key"] = "174185195098415530552",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2038.3293423773016,
							["y"] = 920.8105456759441
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["17434261793554077880"] = {
						["key"] = "17434261793554077880",
						["type"] = "CommonBlackFadeInOutNode",
						["name"] = "对话黑屏淡入淡出节点",
						["pos"] = {
							["x"] = 2436.322044268233,
							["y"] = 1052.395443735213
						},
						["propsData"] = {
							["FadeTime"] = 0,
							["FadeType"] = "FadeIn"
						}
					},
					["17434261998684078158"] = {
						["key"] = "17434261998684078158",
						["type"] = "CommonBlackFadeInOutNode",
						["name"] = "对话黑屏淡入淡出节点",
						["pos"] = {
							["x"] = 2952.4932481399806,
							["y"] = 1042.9379017813005
						},
						["propsData"] = {
							["FadeTime"] = 0,
							["FadeType"] = "FadeOut"
						}
					},
					["17434269413807331953"] = {
						["key"] = "17434269413807331953",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2700.3794437554507,
							["y"] = 1067.470956075565
						},
						["propsData"] = {
							["WaitTime"] = 0.1
						}
					},
					["17569702576723089"] = {
						["key"] = "17569702576723089",
						["type"] = "SendMessageNode",
						["name"] = "探索组重置",
						["pos"] = {
							["x"] = 1989.1631750064244,
							["y"] = 433.49094426780687
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "East00SteathDie",
							["UnitId"] = -1
						}
					},
					["17626025663312980848"] = {
						["key"] = "17626025663312980848",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "关音乐",
						["pos"] = {
							["x"] = 2361.961907190519,
							["y"] = 353.09913952340315
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17626026015272981524"] = {
						["key"] = "17626026015272981524",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放潜行音乐",
						["pos"] = {
							["x"] = 2607.325543554155,
							["y"] = 354.7052001294637
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt01/level/stage1/combat01_state1_r01.combat01_state1_r01'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								101101
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					}
				},
				["commentData"] = {
					["17434766250119774266"] = {
						["key"] = "17434766250119774266",
						["name"] = "出+进特殊任务遮盖穿帮，延迟0.1秒同步覆盖进任务",
						["position"] = {
							["x"] = 2395.8674220709004,
							["y"] = 960.9539555659697
						},
						["size"] = {
							["width"] = 846.2439656453334,
							["height"] = 278.66131682961935
						}
					}
				}
			}
		},
		["172976220001520784705"] = {
			["isStoryNode"] = true,
			["key"] = "172976220001520784705",
			["type"] = "StoryNode",
			["name"] = "止流接人",
			["pos"] = {
				["x"] = 1343.178448561329,
				["y"] = 448.4874581781537
			},
			["propsData"] = {
				["QuestId"] = 12000308,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120003_8",
				["QuestDeatil"] = "Content_120003_8",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12000308",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174185195785115530855",
						["startPort"] = "Out",
						["endQuest"] = "174185195785115530856",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185195785115530857",
						["startPort"] = "Out",
						["endQuest"] = "174185195785115530858",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172976220001520784709",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185195785115530855",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172976220001520784709",
						["startPort"] = "QuestStart",
						["endQuest"] = "174185195785115530857",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17519720925528388",
						["startPort"] = "Out",
						["endQuest"] = "17519720925528389",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173703496106857903364",
						["startPort"] = "Out",
						["endQuest"] = "17519720925528386",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172976220001520784709",
						["startPort"] = "QuestStart",
						["endQuest"] = "1755257649921926097",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755257649921926097",
						["startPort"] = "Out",
						["endQuest"] = "172976454183821552017",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172976454183821552017",
						["startPort"] = "Out",
						["endQuest"] = "1755257834772926619",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755257834772926619",
						["startPort"] = "Out",
						["endQuest"] = "17388297762008149164",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17519720925528386",
						["startPort"] = "Out",
						["endQuest"] = "17519720925528388",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388297762008149164",
						["startPort"] = "Out",
						["endQuest"] = "17626034802882983132",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626034802882983132",
						["startPort"] = "Out",
						["endQuest"] = "173703496106857903364",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637979168163073506",
						["startPort"] = "Out",
						["endQuest"] = "176285346081712619857",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17519720925528388",
						["startPort"] = "Out",
						["endQuest"] = "17637979168163073506",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176285346081712619857",
						["startPort"] = "Out",
						["endQuest"] = "172976220001520784710",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["172976220001520784709"] = {
						["key"] = "172976220001520784709",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2194.6723207826653,
							["y"] = 350.71639395087675
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172976220001520784710"] = {
						["key"] = "172976220001520784710",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3428.5863781362104,
							["y"] = 767.0011183329718
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104108,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["172976220001520784711"] = {
						["key"] = "172976220001520784711",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3934.4642254360983,
							["y"] = 1027.6708769058523
						},
						["propsData"] = {}
					},
					["172976454183821552017"] = {
						["key"] = "172976454183821552017",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和止流聊天 Fixsimple17",
						["pos"] = {
							["x"] = 2476.506632070616,
							["y"] = 337.1241185504053
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001753,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000308",
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
							["HideAllBattleEntity"] = false,
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
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["173703496106857903364"] = {
						["key"] = "173703496106857903364",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3128.4454648403203,
							["y"] = 352.1649228052548
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191052,
								1191051,
								1191894
							}
						}
					},
					["17388295334936113636"] = {
						["key"] = "17388295334936113636",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成开车的止流",
						["pos"] = {
							["x"] = 3669.933789891491,
							["y"] = 1385.4641597745822
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "Zhiliu_12000308",
							["StaticCreatorIdList"] = {
								1191046
							}
						}
					},
					["17388296450567131258"] = {
						["key"] = "17388296450567131258",
						["type"] = "TalkNode",
						["name"] = "假装开车Sequence",
						["pos"] = {
							["x"] = 3951.195786841853,
							["y"] = 1359.2463089979078
						},
						["propsData"] = {
							["IsNpcNode"] = false,
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
					["17388296838478147939"] = {
						["key"] = "17388296838478147939",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 3227.280991511736,
							["y"] = 1019.8977690387812
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_120003081",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17388297762008149164"] = {
						["key"] = "17388297762008149164",
						["type"] = "TalkNode",
						["name"] = "假装假装开车Sequence",
						["pos"] = {
							["x"] = 2829.7985031526487,
							["y"] = 312.71113664020004
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East00/Zhiliu_Drive",
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
							["HideAllBattleEntity"] = false,
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
					["173950313098411335662"] = {
						["key"] = "173950313098411335662",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成开车的止流",
						["pos"] = {
							["x"] = 4283.064802450417,
							["y"] = 1274.1545903765236
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Zhiliu_12000308",
							["StaticCreatorIdList"] = {
								1191046
							}
						}
					},
					["174185195785115530855"] = {
						["key"] = "174185195785115530855",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖城",
						["pos"] = {
							["x"] = 2541.566761518803,
							["y"] = 85.36906146525537
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185195785115530856"] = {
						["key"] = "174185195785115530856",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2804.476936495809,
							["y"] = 84.88917839878015
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan`",
							["UnitId"] = -1
						}
					},
					["174185195785115530857"] = {
						["key"] = "174185195785115530857",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = 2546.999148547106,
							["y"] = -106.28852904813105
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185195785115530858"] = {
						["key"] = "174185195785115530858",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2769.7790177019756,
							["y"] = -87.56770107730301
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityKuanghuan",
							["UnitId"] = -1
						}
					},
					["17425418438261573133"] = {
						["key"] = "17425418438261573133",
						["type"] = "ResourceCollectNode",
						["name"] = "获得Resource道具",
						["pos"] = {
							["x"] = 4341.09700903226,
							["y"] = 1021.302009166404
						},
						["propsData"] = {
							["ResourceType"] = "Resource",
							["ResourceId"] = -1,
							["ResourceSType"] = "Fish",
							["NeedCount"] = 0,
							["bUseBagCount"] = true,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = ""
						}
					},
					["17519720925528386"] = {
						["key"] = "17519720925528386",
						["type"] = "TalkNode",
						["name"] = "站桩 - 门口士兵检查    ",
						["pos"] = {
							["x"] = 3398.8339575579566,
							["y"] = 346.0246929584758
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001762,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000309",
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
							["HideAllBattleEntity"] = false,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = true,
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
									["TalkActorId"] = 220014,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220025,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220026,
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
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17519720925528388"] = {
						["key"] = "17519720925528388",
						["type"] = "TalkNode",
						["name"] = "站桩 - 门口士兵检查2D    ",
						["pos"] = {
							["x"] = 3056.3181101606215,
							["y"] = 750.244182895577
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001801,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "TalkStageNew_12000309",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = true,
							["StartFadeOutTime"] = 0.5,
							["StartScreenEffectDuration"] = 1,
							["FinishFadeInTime"] = 0,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = false,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = true,
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
									["TalkActorId"] = 220014,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220025,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220026,
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
					["17519720925528389"] = {
						["key"] = "17519720925528389",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,白天",
						["pos"] = {
							["x"] = 3499.684325806485,
							["y"] = 628.8265164945408
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityDay",
							["UnitId"] = -1
						}
					},
					["1755257649921926097"] = {
						["key"] = "1755257649921926097",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2292.7344439093167,
							["y"] = 485.0323974476785
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191895
							}
						}
					},
					["1755257834772926619"] = {
						["key"] = "1755257834772926619",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2652.3756542006936,
							["y"] = 486.3638624231924
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191895
							}
						}
					},
					["17621574861823220"] = {
						["key"] = "17621574861823220",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 4104.672224261901,
							["y"] = 574.6722384003206
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104108,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17626034802882983132"] = {
						["key"] = "17626034802882983132",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放音乐",
						["pos"] = {
							["x"] = 3058.3985405047147,
							["y"] = 203.11265107461654
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0043_story_empire.0043_story_empire'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["176285346081712619857"] = {
						["key"] = "176285346081712619857",
						["type"] = "AuConditionNode",
						["name"] = "音频条件节点",
						["pos"] = {
							["x"] = 3603.7988812825574,
							["y"] = 911.4006775832863
						},
						["propsData"] = {
							["ActionType"] = 1,
							["Condition"] = "cp2_dgyr"
						}
					},
					["17637979168163073506"] = {
						["key"] = "17637979168163073506",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放音乐",
						["pos"] = {
							["x"] = 3338.2025998201716,
							["y"] = 918.2879286517123
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
		["172976411309121167728"] = {
			["isStoryNode"] = true,
			["key"] = "172976411309121167728",
			["type"] = "StoryNode",
			["name"] = "冰湖城正门",
			["pos"] = {
				["x"] = 1616.4394568913563,
				["y"] = 603.0776063982975
			},
			["propsData"] = {
				["QuestId"] = 12000309,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120003_9",
				["QuestDeatil"] = "Content_120003_9",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12000309",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1730948580909825426",
						["startPort"] = "Out",
						["endQuest"] = "172976934913524610690",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172976934913524610690",
						["startPort"] = "Out",
						["endQuest"] = "1737042567503249497",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1737042567503249497",
						["startPort"] = "Out",
						["endQuest"] = "173703510161658881974",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1737042567503249497",
						["startPort"] = "Out",
						["endQuest"] = "17392635003305101632",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185196412315531115",
						["startPort"] = "Out",
						["endQuest"] = "174185196412315531116",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174185196412315531117",
						["startPort"] = "Out",
						["endQuest"] = "174185196412315531118",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["172976411309121167732"] = {
						["key"] = "172976411309121167732",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2278.962961176754,
							["y"] = 483.70654173412794
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172976411309121167733"] = {
						["key"] = "172976411309121167733",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3595.3541322487436,
							["y"] = 673.578281970215
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172976411309121167734"] = {
						["key"] = "172976411309121167734",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3995.532084548312,
							["y"] = 575.6163207988767
						},
						["propsData"] = {}
					},
					["172976934913524610690"] = {
						["key"] = "172976934913524610690",
						["type"] = "TalkNode",
						["name"] = "假装2D图",
						["pos"] = {
							["x"] = 2856.854709734033,
							["y"] = 458.77078005586867
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12003201,
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
					["17309477497724650"] = {
						["key"] = "17309477497724650",
						["type"] = "GoToNode",
						["name"] = "正门检测",
						["pos"] = {
							["x"] = 2544.1584513775474,
							["y"] = 223.14384421962782
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191047,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000309"
						}
					},
					["1730948580909825426"] = {
						["key"] = "1730948580909825426",
						["type"] = "TalkNode",
						["name"] = "站桩 - 门口士兵检查    ",
						["pos"] = {
							["x"] = 2588.063614320628,
							["y"] = 458.0297448955035
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001762,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000309",
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
							["SkipToOption"] = true,
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
									["TalkActorId"] = 220014,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220025,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220026,
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
					["173703510161658881974"] = {
						["key"] = "173703510161658881974",
						["type"] = "TalkNode",
						["name"] = "传到东国了就",
						["pos"] = {
							["x"] = 3265.7215381804654,
							["y"] = 630.8335895535697
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12003301,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0.5,
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
					["1737042567503249497"] = {
						["key"] = "1737042567503249497",
						["type"] = "TalkNode",
						["name"] = "站桩 - 门口士兵检查2D    ",
						["pos"] = {
							["x"] = 3144.1949817774043,
							["y"] = 457.7987006615476
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001801,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "TalkStageNew_12000309",
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
							["ShowSkipButton"] = false,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = true,
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
									["TalkActorId"] = 220014,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220025,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220026,
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
					["17392635003305101632"] = {
						["key"] = "17392635003305101632",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,白天",
						["pos"] = {
							["x"] = 3526.738726790452,
							["y"] = 460.1911743428985
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityDay",
							["UnitId"] = -1
						}
					},
					["174185196412315531115"] = {
						["key"] = "174185196412315531115",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖城",
						["pos"] = {
							["x"] = 2506.2420861941278,
							["y"] = 709.1223082185022
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185196412315531116"] = {
						["key"] = "174185196412315531116",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2844.241546885419,
							["y"] = 705.1602822948842
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["174185196412315531117"] = {
						["key"] = "174185196412315531117",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = 2518.6387589367164,
							["y"] = 895.4111462765444
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174185196412315531118"] = {
						["key"] = "174185196412315531118",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 2949.9007709487287,
							["y"] = 932.3462599616581
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeNight",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}