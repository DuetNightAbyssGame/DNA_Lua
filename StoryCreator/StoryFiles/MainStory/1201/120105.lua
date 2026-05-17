return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1730277995070232",
			["startPort"] = "Success",
			["endStory"] = "173027955144018163246",
			["endPort"] = "In"
		},
		{
			["startStory"] = "173071205291817690514",
			["startPort"] = "Success",
			["endStory"] = "17307962001767295271",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17307962001767295271",
			["startPort"] = "Success",
			["endStory"] = "173079802280910132367",
			["endPort"] = "In"
		},
		{
			["startStory"] = "173079802280910132367",
			["startPort"] = "Success",
			["endStory"] = "173080027464112567025",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17302779849021",
			["startPort"] = "StoryStart",
			["endStory"] = "1730277995070232",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17414154533691564612",
			["startPort"] = "Success",
			["endStory"] = "17501484720731287440",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17501484720731287440",
			["startPort"] = "Success",
			["endStory"] = "17501484732221287532",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17501484732221287532",
			["startPort"] = "Success",
			["endStory"] = "173071205291817690514",
			["endPort"] = "In"
		},
		{
			["startStory"] = "173080027464112567025",
			["startPort"] = "Success",
			["endStory"] = "17302779849025",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17629514992454019068",
			["startPort"] = "Success",
			["endStory"] = "1730376039493867",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1730376039493867",
			["startPort"] = "Success",
			["endStory"] = "17414154533691564612",
			["endPort"] = "In"
		},
		{
			["startStory"] = "173027955144018163246",
			["startPort"] = "Success",
			["endStory"] = "17629514992454019068",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17302779849021"] = {
			["isStoryNode"] = true,
			["key"] = "17302779849021",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1789.89771554409,
				["y"] = -242.40430077057152
			},
			["propsData"] = {
				["QuestChainId"] = 120105
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17302779849025"] = {
			["isStoryNode"] = true,
			["key"] = "17302779849025",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 3860.525970303823,
				["y"] = 565.7505829699901
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1730277995070232"] = {
			["isStoryNode"] = true,
			["key"] = "1730277995070232",
			["type"] = "StoryNode",
			["name"] = "前往虬先生办公室",
			["pos"] = {
				["x"] = 2146.056925445467,
				["y"] = -232.4859051953354
			},
			["propsData"] = {
				["QuestId"] = 12010501,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_1",
				["QuestDeatil"] = "Content_120105_1",
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
						["startQuest"] = "1730277995070239",
						["startPort"] = "Out",
						["endQuest"] = "17302876775582749664",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536974818962008182",
						["startPort"] = "Out",
						["endQuest"] = "1730277995070239",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17629519440334026933",
						["startPort"] = "Out",
						["endQuest"] = "1730277995070237",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1730277995070236",
						["startPort"] = "QuestStart",
						["endQuest"] = "17536975002642008685",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536975002642008685",
						["startPort"] = "Out",
						["endQuest"] = "17536974818962008182",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17302876775582749664",
						["startPort"] = "Out",
						["endQuest"] = "17675177705348514",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675177705348514",
						["startPort"] = "Out",
						["endQuest"] = "17629519440334026933",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1730277995070236"] = {
						["key"] = "1730277995070236",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1252.3862509749792,
							["y"] = 611.359086805274
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1730277995070237"] = {
						["key"] = "1730277995070237",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3202.435049504654,
							["y"] = 567.5308349524038
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1730277995070238"] = {
						["key"] = "1730277995070238",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["1730277995070239"] = {
						["key"] = "1730277995070239",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2071.4045160325227,
							["y"] = 589.4716493680463
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2270009,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2270009"
						}
					},
					["17302876775582749664"] = {
						["key"] = "17302876775582749664",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和虬先生对话",
						["pos"] = {
							["x"] = 2361.1322249340933,
							["y"] = 589.5023794936112
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_47",
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
					["17536974818962008182"] = {
						["key"] = "17536974818962008182",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1766.8793459806595,
							["y"] = 609.2366821682537
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2270010
							}
						}
					},
					["17536975002642008685"] = {
						["key"] = "17536975002642008685",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1490.9855072463763,
							["y"] = 598.4645308924486
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104901,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_EnterQiuOffice"
						}
					},
					["17629519440334026933"] = {
						["key"] = "17629519440334026933",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2928.633465485443,
							["y"] = 566.6617418752336
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17675177705348514"] = {
						["key"] = "17675177705348514",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2646.62009227346,
							["y"] = 611.4416138966507
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2270010
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["173027955144018163246"] = {
			["isStoryNode"] = true,
			["key"] = "173027955144018163246",
			["type"] = "StoryNode",
			["name"] = "前往黑市",
			["pos"] = {
				["x"] = 2412.561485374385,
				["y"] = -231.53983667887005
			},
			["propsData"] = {
				["QuestId"] = 12010502,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_2",
				["QuestDeatil"] = "Content_120105_2",
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
				["SubRegionId"] = 104109,
				["SubRegionIdList"] = {
					104901
				},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "RegionPoint_Shi_04",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17629520977864027866",
						["startPort"] = "Out",
						["endQuest"] = "173027955144018163251",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173027955144018163250",
						["startPort"] = "QuestStart",
						["endQuest"] = "17648594085532240440",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17648594085532240440",
						["startPort"] = "Out",
						["endQuest"] = "17629520977864027866",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["173027955144018163250"] = {
						["key"] = "173027955144018163250",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2034.2277287929464,
							["y"] = 463.7366980845241
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173027955144018163251"] = {
						["key"] = "173027955144018163251",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3070.7875109615293,
							["y"] = 471.1797528912232
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173027955144018163252"] = {
						["key"] = "173027955144018163252",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["17629519354064026679"] = {
						["key"] = "17629519354064026679",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2460.4536613272307,
							["y"] = 773.4185679992821
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2100014,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2100014"
						}
					},
					["17629520977864027866"] = {
						["key"] = "17629520977864027866",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2746.801487414188,
							["y"] = 461.6794375644995
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018503,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17648594085532240440"] = {
						["key"] = "17648594085532240440",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 2412,
							["y"] = 468
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104109,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_QuestTrigger_2100014"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1730376039493867"] = {
			["isStoryNode"] = true,
			["key"] = "1730376039493867",
			["type"] = "StoryNode",
			["name"] = "深入古战场",
			["pos"] = {
				["x"] = 2973.8075893644495,
				["y"] = -234.9878784978221
			},
			["propsData"] = {
				["QuestId"] = 12010504,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_3",
				["QuestDeatil"] = "Content_120105_3",
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
				["SubRegionId"] = 104102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QuestTrigger_1930143",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17629522977854030642",
						["startPort"] = "Out",
						["endQuest"] = "17629522977854030643",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1730376039493871",
						["startPort"] = "QuestStart",
						["endQuest"] = "17629522977854030642",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1730376039493871",
						["startPort"] = "QuestStart",
						["endQuest"] = "17630351064552019685",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17629522977854030643",
						["startPort"] = "Out",
						["endQuest"] = "17640391235938943900",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17527365187724806033",
						["startPort"] = "Out",
						["endQuest"] = "17640391767268944379",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17640391767268944379",
						["startPort"] = "Out",
						["endQuest"] = "1730376039493872",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17640391235938943900",
						["startPort"] = "Out",
						["endQuest"] = "17527365187724806033",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1730376039493871"] = {
						["key"] = "1730376039493871",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1902.5289710289712,
							["y"] = 658.7242757242757
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1730376039493872"] = {
						["key"] = "1730376039493872",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3249.831610340411,
							["y"] = 659.9083243197947
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104201,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["1730376039493873"] = {
						["key"] = "1730376039493873",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["17527365187724806033"] = {
						["key"] = "17527365187724806033",
						["type"] = "TalkNode",
						["name"] = "【SC009】黑市小弟触发机关",
						["pos"] = {
							["x"] = 2748.3928571428573,
							["y"] = 643.9285714285714
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC009/SQ_Ver0101_SC009",
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
					["17629522977854030642"] = {
						["key"] = "17629522977854030642",
						["type"] = "GoToNode",
						["name"] = "前往古战场",
						["pos"] = {
							["x"] = 2186.97161599858,
							["y"] = 639.1091119743091
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1930143,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1930143"
						}
					},
					["17629522977854030643"] = {
						["key"] = "17629522977854030643",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和小弟对话",
						["pos"] = {
							["x"] = 2463.028384001418,
							["y"] = 643.1766023114052
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018601,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "East01_FixSimple_48",
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
									["TalkActorId"] = 210010,
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
					["17630351064552019685"] = {
						["key"] = "17630351064552019685",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2191.8742554916703,
							["y"] = 454.21160622143566
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018508,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17640391235938943900"] = {
						["key"] = "17640391235938943900",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2726.25,
							["y"] = 488.53571428571433
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/1_1/0118_cs_bad_guy_trigger_gear",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								104102
							},
							["bStoreToServer"] = false
						}
					},
					["17640391767268944379"] = {
						["key"] = "17640391767268944379",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2992.3214285714284,
							["y"] = 662.4642857142857
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
		["173071205291817690514"] = {
			["isStoryNode"] = true,
			["key"] = "173071205291817690514",
			["type"] = "StoryNode",
			["name"] = "传送回古战场",
			["pos"] = {
				["x"] = 2595.437493168348,
				["y"] = 534.771243736256
			},
			["propsData"] = {
				["QuestId"] = 12010513,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_14",
				["QuestDeatil"] = "Content_120105_14",
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
				["SubRegionId"] = 104102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_YumingBossFight",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "173071205291817690518",
						["startPort"] = "QuestStart",
						["endQuest"] = "17629388368042017017",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17629388368042017017",
						["startPort"] = "Out",
						["endQuest"] = "173071205291817690523",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17544824228863370",
						["startPort"] = "Out",
						["endQuest"] = "176485570682010842461",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176485570682010842461",
						["startPort"] = "Out",
						["endQuest"] = "173071205291817690519",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173071205291817690523",
						["startPort"] = "Out",
						["endQuest"] = "176485570582710842403",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176485570582710842403",
						["startPort"] = "Out",
						["endQuest"] = "17544824228863370",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["173071205291817690518"] = {
						["key"] = "173071205291817690518",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2197.1350119934505,
							["y"] = 461.29181526277705
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173071205291817690519"] = {
						["key"] = "173071205291817690519",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3730.4347192948862,
							["y"] = 490.25611237219425
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173071205291817690520"] = {
						["key"] = "173071205291817690520",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["173071205291817690523"] = {
						["key"] = "173071205291817690523",
						["type"] = "TalkNode",
						["name"] = "站桩 - 逮捕煜明",
						["pos"] = {
							["x"] = 2716.9703626607593,
							["y"] = 448.96690404252286
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 12019901,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1201/120105/12019901.12019901'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_51",
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
									["TalkActorId"] = 210007,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210012,
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
					["17544824228863370"] = {
						["key"] = "17544824228863370",
						["type"] = "TalkNode",
						["name"] = "【SC010】逮捕煜明",
						["pos"] = {
							["x"] = 3214.9737905283564,
							["y"] = 447.8905713094954
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC010/SQ_Ver0101_SC010",
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
					["17629388368042017017"] = {
						["key"] = "17629388368042017017",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2478.6148090815277,
							["y"] = 449.42092363261094
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_BattWonderland",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["176485570582710842403"] = {
						["key"] = "176485570582710842403",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2972.5,
							["y"] = 449.5625
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/1_1/0128_cs_qiusir_attack_player",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								104102
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = false
						}
					},
					["176485570682010842461"] = {
						["key"] = "176485570682010842461",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 3450,
							["y"] = 461.75
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
		["17307962001767295271"] = {
			["isStoryNode"] = true,
			["key"] = "17307962001767295271",
			["type"] = "StoryNode",
			["name"] = "击败煜明",
			["pos"] = {
				["x"] = 2878.204843766117,
				["y"] = 532.0442661528737
			},
			["propsData"] = {
				["QuestId"] = 12010514,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_14",
				["QuestDeatil"] = "Content_120105_14",
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
				["SubRegionId"] = 104102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_YumingBossFight",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "175716174417910657959",
						["startPort"] = "Fail",
						["endQuest"] = "175716184501310658697",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175716174417910657959",
						["startPort"] = "PassiveFail",
						["endQuest"] = "175716184501310658697",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175716184501310658697",
						["startPort"] = "Out",
						["endQuest"] = "17307962001767295277",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "175716174417910657959",
						["startPort"] = "Success",
						["endQuest"] = "17307962001767295276",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176033555097718499200",
						["startPort"] = "true",
						["endQuest"] = "176033555097718499199",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176033555097718499200",
						["startPort"] = "false",
						["endQuest"] = "17307969394587701290",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17307969394587701290",
						["startPort"] = "Out",
						["endQuest"] = "175716174417910657959",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17307962001767295275",
						["startPort"] = "QuestStart",
						["endQuest"] = "176033555097718499200",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176033555097718499200",
						["startPort"] = "true",
						["endQuest"] = "175716174417910657959",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17307962001767295275"] = {
						["key"] = "17307962001767295275",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1836.7139593618717,
							["y"] = 470.6505569445677
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17307962001767295276"] = {
						["key"] = "17307962001767295276",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3302.659935519125,
							["y"] = 437.93418673904097
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17307962001767295277"] = {
						["key"] = "17307962001767295277",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3299.547894824992,
							["y"] = 703.2092061743707
						},
						["propsData"] = {}
					},
					["17307969394587701290"] = {
						["key"] = "17307969394587701290",
						["type"] = "GoToNode",
						["name"] = "和煜明战斗",
						["pos"] = {
							["x"] = 2415.4532455461185,
							["y"] = 677.63065491064
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1930153,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_YumingBossFight"
						}
					},
					["175716174417910657959"] = {
						["key"] = "175716174417910657959",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 2703.5542451446345,
							["y"] = 452.1789667870903
						},
						["propsData"] = {
							["SpecialConfigId"] = 2011,
							["BlackScreenImmediately"] = true
						}
					},
					["175716184501310658697"] = {
						["key"] = "175716184501310658697",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2986.598347495372,
							["y"] = 671.5511892760177
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_YumingBossFight",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["176033555097718499199"] = {
						["key"] = "176033555097718499199",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2437.685840337055,
							["y"] = 332.0320276447246
						},
						["propsData"] = {
							["VarName"] = "East01YumingBoss",
							["VarValue"] = 1
						}
					},
					["176033555097718499200"] = {
						["key"] = "176033555097718499200",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否在阶段1",
						["pos"] = {
							["x"] = 2140.2948753511982,
							["y"] = 459.65655464850863
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01YumingBoss",
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
		["173079802280910132367"] = {
			["isStoryNode"] = true,
			["key"] = "173079802280910132367",
			["type"] = "StoryNode",
			["name"] = "战后对话",
			["pos"] = {
				["x"] = 3156.3490577556863,
				["y"] = 531.6199906230643
			},
			["propsData"] = {
				["QuestId"] = 12010515,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_15",
				["QuestDeatil"] = "Content_120105_15",
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
				["SubRegionId"] = 104102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_YumingBossFight",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "173079927219211755541",
						["startPort"] = "Out",
						["endQuest"] = "173079802280910132372",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17536984965884015963",
						["startPort"] = "Out",
						["endQuest"] = "173079927219211755541",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173079802280910132371",
						["startPort"] = "QuestStart",
						["endQuest"] = "17536984965884015963",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["173079802280910132371"] = {
						["key"] = "173079802280910132371",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1750.7227312916964,
							["y"] = 488.71196045333966
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173079802280910132372"] = {
						["key"] = "173079802280910132372",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2811.072361967357,
							["y"] = 467.593282119364
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173079802280910132373"] = {
						["key"] = "173079802280910132373",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["173079850958511350020"] = {
						["key"] = "173079850958511350020",
						["type"] = "TalkNode",
						["name"] = "【SC011】",
						["pos"] = {
							["x"] = 2227.91755479726,
							["y"] = 853.5025134491577
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12022521,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 1,
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
					["173079927219211755541"] = {
						["key"] = "173079927219211755541",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和刻舟、虬先生对话",
						["pos"] = {
							["x"] = 2489.7078361271842,
							["y"] = 469.1418996384161
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 12020301,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1201/120105/12020301.12020301'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_52",
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
									["TalkActorId"] = 210012,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210021,
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
					["17536984965884015963"] = {
						["key"] = "17536984965884015963",
						["type"] = "TalkNode",
						["name"] = "【SC011】刻舟救场",
						["pos"] = {
							["x"] = 2151.842391304348,
							["y"] = 471.5481502669717
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC011/SQ_Ver0101_SC011",
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
					}
				},
				["commentData"] = {}
			}
		},
		["173080027464112567025"] = {
			["isStoryNode"] = true,
			["key"] = "173080027464112567025",
			["type"] = "StoryNode",
			["name"] = "和刻舟对话",
			["pos"] = {
				["x"] = 3437.5476234252183,
				["y"] = 535.4100563077338
			},
			["propsData"] = {
				["QuestId"] = 12010516,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_16",
				["QuestDeatil"] = "Content_120105_16",
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
				["SubRegionId"] = 104102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Npc_Kezhou_1930157",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "173080045654912973954",
						["startPort"] = "Out",
						["endQuest"] = "173080072999313379658",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173080027464112567029",
						["startPort"] = "QuestStart",
						["endQuest"] = "173080091057415001673",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173080027464112567029",
						["startPort"] = "QuestStart",
						["endQuest"] = "173080045654912973954",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173080072999313379658",
						["startPort"] = "Out",
						["endQuest"] = "17650326072902887056",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17650326072902887056",
						["startPort"] = "Out",
						["endQuest"] = "173080027464112567030",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["173080027464112567029"] = {
						["key"] = "173080027464112567029",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1817.9137083837954,
							["y"] = 455.18484497881883
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173080027464112567030"] = {
						["key"] = "173080027464112567030",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3187.659318489096,
							["y"] = 457.4700937135669
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173080027464112567031"] = {
						["key"] = "173080027464112567031",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["173080045654912973954"] = {
						["key"] = "173080045654912973954",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成刻舟",
						["pos"] = {
							["x"] = 2245.328397205752,
							["y"] = 458.29437330670504
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1930157
							}
						}
					},
					["173080072999313379658"] = {
						["key"] = "173080072999313379658",
						["type"] = "TalkNode",
						["name"] = "【53】刻舟对话",
						["pos"] = {
							["x"] = 2631.161730539086,
							["y"] = 445.3777066400383
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210021,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Kezhou_1930157",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12020501,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_53",
							["BlendInTime"] = 0.5,
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
									["TalkActorId"] = 210021,
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
					["173080091057415001673"] = {
						["key"] = "173080091057415001673",
						["type"] = "TalkNode",
						["name"] = "开车- 小白吐槽",
						["pos"] = {
							["x"] = 2241.8283972057525,
							["y"] = 221.12770664003835
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12020401,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17650326072902887056"] = {
						["key"] = "17650326072902887056",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成刻舟",
						["pos"] = {
							["x"] = 2908,
							["y"] = 458.00000000000006
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1930157
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17414154533691564612"] = {
			["isStoryNode"] = true,
			["key"] = "17414154533691564612",
			["type"] = "StoryNode",
			["name"] = "古战场副本I",
			["pos"] = {
				["x"] = 2417.7148768587044,
				["y"] = 154.6739927526521
			},
			["propsData"] = {
				["QuestId"] = 12010517,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_20",
				["QuestDeatil"] = "Content_120105_20",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "0",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17414154533691564620",
						["startPort"] = "Fail",
						["endQuest"] = "17414154533691564621",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17414154533691564620",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17414154533691564619",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17414154533691564620",
						["startPort"] = "Success",
						["endQuest"] = "17414154533691564618",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17536979506683010409",
						["startPort"] = "Out",
						["endQuest"] = "17536979506683010411",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536979506683010410",
						["startPort"] = "LastDefaultOut",
						["endQuest"] = "17536979506683010409",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17414154533691564617",
						["startPort"] = "QuestStart",
						["endQuest"] = "17536979561713010575",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536979561713010575",
						["startPort"] = "Out",
						["endQuest"] = "17414154533691564620",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17414154533691564617",
						["startPort"] = "QuestStart",
						["endQuest"] = "17536979506683010410",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17414154533691564621",
						["startPort"] = "Out",
						["endQuest"] = "17414154533691564619",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17414154533691564617"] = {
						["key"] = "17414154533691564617",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 3706.041690688082,
							["y"] = 646.9269646531803
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17414154533691564618"] = {
						["key"] = "17414154533691564618",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4754.74017375962,
							["y"] = 462.1275427723081
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104601,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17414154533691564619"] = {
						["key"] = "17414154533691564619",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4733.925914855935,
							["y"] = 822.8816903940572
						},
						["propsData"] = {}
					},
					["17414154533691564620"] = {
						["key"] = "17414154533691564620",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "2008古战场<1>",
						["pos"] = {
							["x"] = 4319.500896568512,
							["y"] = 559.0030601582324
						},
						["propsData"] = {
							["SpecialConfigId"] = 2008,
							["BlackScreenImmediately"] = false
						}
					},
					["17414154533691564621"] = {
						["key"] = "17414154533691564621",
						["type"] = "SkipRegionNode",
						["name"] = "送回幻境外",
						["pos"] = {
							["x"] = 4731.241603957586,
							["y"] = 623.637794198139
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104102,
							["StartIndex"] = 1,
							["IsWhite"] = true
						}
					},
					["17414154533691564623"] = {
						["key"] = "17414154533691564623",
						["type"] = "CommonBlackFadeInOutNode",
						["name"] = "对话黑屏淡入淡出节点",
						["pos"] = {
							["x"] = 4136.965915804624,
							["y"] = -22.86283608864278
						},
						["propsData"] = {
							["FadeTime"] = 0,
							["FadeType"] = "FadeIn"
						}
					},
					["174901916246333185788"] = {
						["key"] = "174901916246333185788",
						["type"] = "TalkNode",
						["name"] = "【幻境】进入古战场",
						["pos"] = {
							["x"] = 4442.611611506773,
							["y"] = 85.86300258880837
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12023807,
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
					["17536979366283010240"] = {
						["key"] = "17536979366283010240",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 3905.7281991744067,
							["y"] = 325.6599771487543
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 0,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17536979506683010409"] = {
						["key"] = "17536979506683010409",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 4302.55685230715,
							["y"] = 854.7801856292009
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2030014,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2030014"
						}
					},
					["17536979506683010410"] = {
						["key"] = "17536979506683010410",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 4021.106592774197,
							["y"] = 787.1268286293359
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								104201
							}
						}
					},
					["17536979506683010411"] = {
						["key"] = "17536979506683010411",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 4572.407221842559,
							["y"] = 899.1118998764207
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104201,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17536979561713010575"] = {
						["key"] = "17536979561713010575",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 4022.156770602978,
							["y"] = 571.4456914344686
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104201,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17571615295079690749"] = {
						["key"] = "17571615295079690749",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 5197.194547095347,
							["y"] = 591.8853432245797
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_BattWonderland",
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
		["17501484720731287440"] = {
			["isStoryNode"] = true,
			["key"] = "17501484720731287440",
			["type"] = "StoryNode",
			["name"] = "古战场副本II",
			["pos"] = {
				["x"] = 2701.9797323220077,
				["y"] = 152.90825820116254
			},
			["propsData"] = {
				["QuestId"] = 12010518,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_20",
				["QuestDeatil"] = "Content_120105_20",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "0",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17501484720731287448",
						["startPort"] = "Fail",
						["endQuest"] = "17501484720731287449",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501484720731287448",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17501484720731287447",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17501484720731287448",
						["startPort"] = "Success",
						["endQuest"] = "17501484720731287446",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17536981218533012502",
						["startPort"] = "Out",
						["endQuest"] = "17536981218533012504",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536981218533012503",
						["startPort"] = "LastDefaultOut",
						["endQuest"] = "17536981218533012502",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501484720731287445",
						["startPort"] = "QuestStart",
						["endQuest"] = "17536981218533012505",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536981218533012505",
						["startPort"] = "Out",
						["endQuest"] = "17501484720731287448",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501484720731287445",
						["startPort"] = "QuestStart",
						["endQuest"] = "17536981218533012503",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501484720731287449",
						["startPort"] = "Out",
						["endQuest"] = "17501484720731287447",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17501484720731287445"] = {
						["key"] = "17501484720731287445",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 3668.541690688082,
							["y"] = 644.7841075103231
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17501484720731287446"] = {
						["key"] = "17501484720731287446",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 5008.95379347324,
							["y"] = 563.3488214935868
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104701,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17501484720731287447"] = {
						["key"] = "17501484720731287447",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 5016.557782987803,
							["y"] = 961.8029358153025
						},
						["propsData"] = {}
					},
					["17501484720731287448"] = {
						["key"] = "17501484720731287448",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "2009古战场<2>",
						["pos"] = {
							["x"] = 4328.761191828808,
							["y"] = 564.9573281125004
						},
						["propsData"] = {
							["SpecialConfigId"] = 2009,
							["BlackScreenImmediately"] = false
						}
					},
					["17501484720731287449"] = {
						["key"] = "17501484720731287449",
						["type"] = "SkipRegionNode",
						["name"] = "送回幻境外",
						["pos"] = {
							["x"] = 5009.905273621256,
							["y"] = 761.4262557366004
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104102,
							["StartIndex"] = 1,
							["IsWhite"] = true
						}
					},
					["17536981218533012502"] = {
						["key"] = "17536981218533012502",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 4303.389116791892,
							["y"] = 1160.5937844214138
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2030014,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2030014"
						}
					},
					["17536981218533012503"] = {
						["key"] = "17536981218533012503",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 3983.6919287488518,
							["y"] = 1162.3102593440126
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								104601
							}
						}
					},
					["17536981218533012504"] = {
						["key"] = "17536981218533012504",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 4587.74633036046,
							["y"] = 1162.4222212443035
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104601,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17536981218533012505"] = {
						["key"] = "17536981218533012505",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 4007.264280056328,
							["y"] = 568.2266081871344
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104601,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17571615576079691372"] = {
						["key"] = "17571615576079691372",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 4678.817182817183,
							["y"] = 178.22477522477527
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_BattWonderland",
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
		["17501484732221287532"] = {
			["isStoryNode"] = true,
			["key"] = "17501484732221287532",
			["type"] = "StoryNode",
			["name"] = "古战场副本III",
			["pos"] = {
				["x"] = 2978.768640075261,
				["y"] = 151.6098198539976
			},
			["propsData"] = {
				["QuestId"] = 12010519,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_20",
				["QuestDeatil"] = "Content_120105_20",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "0",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17501484732231287540",
						["startPort"] = "Fail",
						["endQuest"] = "17501484732231287541",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501484732231287540",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17501484732231287539",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17501484732231287540",
						["startPort"] = "Success",
						["endQuest"] = "17501484732231287538",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17536981964883014361",
						["startPort"] = "Out",
						["endQuest"] = "17536981964883014362",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536981964883014360",
						["startPort"] = "LastDefaultOut",
						["endQuest"] = "17536981964883014361",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501484732231287537",
						["startPort"] = "QuestStart",
						["endQuest"] = "17536981964883014359",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536981964883014359",
						["startPort"] = "Out",
						["endQuest"] = "17501484732231287540",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501484732231287537",
						["startPort"] = "QuestStart",
						["endQuest"] = "17536981964883014360",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501484732231287541",
						["startPort"] = "Out",
						["endQuest"] = "17501484732231287539",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17501484732231287537"] = {
						["key"] = "17501484732231287537",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 3756.1910413374326,
							["y"] = 672.3880036142192
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17501484732231287538"] = {
						["key"] = "17501484732231287538",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 5008.316600003094,
							["y"] = 585.8815324896847
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104102,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = true
						}
					},
					["17501484732231287539"] = {
						["key"] = "17501484732231287539",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 5014.430319807708,
							["y"] = 881.7654148567289
						},
						["propsData"] = {}
					},
					["17501484732231287540"] = {
						["key"] = "17501484732231287540",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 4521.721675789292,
							["y"] = 604.9770861322584
						},
						["propsData"] = {
							["SpecialConfigId"] = 2010,
							["BlackScreenImmediately"] = false
						}
					},
					["17501484732231287541"] = {
						["key"] = "17501484732231287541",
						["type"] = "SkipRegionNode",
						["name"] = "送回幻境外",
						["pos"] = {
							["x"] = 5012.2045118861715,
							["y"] = 721.7797259378967
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104102,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17536981964883014359"] = {
						["key"] = "17536981964883014359",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 4120.178777665165,
							["y"] = 598.7269478315227
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104701,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17536981964883014360"] = {
						["key"] = "17536981964883014360",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 4124.723763293617,
							["y"] = 810.0728150332255
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								104701
							}
						}
					},
					["17536981964883014361"] = {
						["key"] = "17536981964883014361",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 4408.011952289728,
							["y"] = 887.0454249721256
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2030014,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2030014"
						}
					},
					["17536981964883014362"] = {
						["key"] = "17536981964883014362",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 4683.913510402641,
							["y"] = 1006.847443768597
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104701,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17629514992454019068"] = {
			["isStoryNode"] = true,
			["key"] = "17629514992454019068",
			["type"] = "StoryNode",
			["name"] = "到达古战场",
			["pos"] = {
				["x"] = 2691.521368409395,
				["y"] = -230.69954608645153
			},
			["propsData"] = {
				["QuestId"] = 12010503,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120105_2",
				["QuestDeatil"] = "Content_120105_2",
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
				["SubRegionId"] = 104102,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QuestTrigger_2030042",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17629514992454019069",
						["startPort"] = "QuestStart",
						["endQuest"] = "17629522361454029026",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17629522624694029654",
						["startPort"] = "Out",
						["endQuest"] = "17629514992464019072",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17629522361454029026",
						["startPort"] = "Out",
						["endQuest"] = "17629524532614033205",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17629524532614033205",
						["startPort"] = "Out",
						["endQuest"] = "17629522624694029654",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17629514992454019069"] = {
						["key"] = "17629514992454019069",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 823.1818181818181,
							["y"] = 330
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17629514992464019072"] = {
						["key"] = "17629514992464019072",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2057.9665071770332,
							["y"] = 342.4162679425837
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17629514992464019075"] = {
						["key"] = "17629514992464019075",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17629522361454029026"] = {
						["key"] = "17629522361454029026",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1126.0372373621801,
							["y"] = 319.83107967547323
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2030042,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2030042"
						}
					},
					["17629522624694029654"] = {
						["key"] = "17629522624694029654",
						["type"] = "TalkNode",
						["name"] = "【Show_Batt_RegionUI】",
						["pos"] = {
							["x"] = 1734.9532972748082,
							["y"] = 322.02069898065326
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East01/Batt/Show_Batt_RegionUI",
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
					["17629524532614033205"] = {
						["key"] = "17629524532614033205",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1435.0045617997566,
							["y"] = 320.58016582959374
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Batt01",
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
	["commentData"] = {
		["17629548192785038825"] = {
			["key"] = "17629548192785038825",
			["name"] = "Boss",
			["position"] = {
				["x"] = 2553.930063444313,
				["y"] = 430.1604024679777
			},
			["size"] = {
				["width"] = 1155.6000000000001,
				["height"] = 247.19999999999996
			}
		},
		["17629548304865039151"] = {
			["key"] = "17629548304865039151",
			["name"] = "Dream",
			["position"] = {
				["x"] = 2371.1511160758914,
				["y"] = 52.349876152188116
			},
			["size"] = {
				["width"] = 906.0000000000001,
				["height"] = 277.19999999999993
			}
		},
		["17629548394705039434"] = {
			["key"] = "17629548394705039434",
			["name"] = "Input Commment...",
			["position"] = {
				["x"] = 2078.098484496944,
				["y"] = -327.67117647939085
			},
			["size"] = {
				["width"] = 1153.865397188624,
				["height"] = 266.76577312847326
			}
		}
	}
}