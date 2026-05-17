return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17700212164371",
			["startPort"] = "StoryStart",
			["endStory"] = "1770021269387383153",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770021269387383153",
			["startPort"] = "Success",
			["endStory"] = "1770191080739743",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770191080739743",
			["startPort"] = "Success",
			["endStory"] = "1770191080462730",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770191079880704",
			["startPort"] = "Success",
			["endStory"] = "1770191079607691",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770191078691652",
			["startPort"] = "Success",
			["endStory"] = "1770191078311639",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770191080462730",
			["startPort"] = "Success",
			["endStory"] = "1770191079880704",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770191079607691",
			["startPort"] = "Success",
			["endStory"] = "1770191078691652",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770191078311639",
			["startPort"] = "Success",
			["endStory"] = "17700212164385",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17700212164371"] = {
			["isStoryNode"] = true,
			["key"] = "17700212164371",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 914,
				["y"] = 314
			},
			["propsData"] = {
				["QuestChainId"] = 200316
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17700212164385"] = {
			["isStoryNode"] = true,
			["key"] = "17700212164385",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1880.5727064697317,
				["y"] = 561.4352680119272
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1770021269387383153"] = {
			["isStoryNode"] = true,
			["key"] = "1770021269387383153",
			["type"] = "StoryNode",
			["name"] = "参加奉香大典",
			["pos"] = {
				["x"] = 1280.3333333333333,
				["y"] = 290.31987577639757
			},
			["propsData"] = {
				["QuestId"] = 20031601,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200316_1",
				["QuestDeatil"] = "Content_200316_1",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_20031601_322410127",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770021269387383154",
						["startPort"] = "QuestStart",
						["endQuest"] = "17701914872136073",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701914872136073",
						["startPort"] = "Out",
						["endQuest"] = "17701915402546485",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701915402546485",
						["startPort"] = "Out",
						["endQuest"] = "1770021269387383157",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1770021269387383154"] = {
						["key"] = "1770021269387383154",
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
					["1770021269387383157"] = {
						["key"] = "1770021269387383157",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1940,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770021269387383160"] = {
						["key"] = "1770021269387383160",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17701914872136073"] = {
						["key"] = "17701914872136073",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1166,
							["y"] = 294
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 322410127,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_20031601_322410127"
						}
					},
					["17701915402546485"] = {
						["key"] = "17701915402546485",
						["type"] = "TalkNode",
						["name"] = "参加奉香大典",
						["pos"] = {
							["x"] = 1498,
							["y"] = 282.57142857142856
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031601.20031601'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20031601",
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
					}
				},
				["commentData"] = {}
			}
		},
		["1770191078311639"] = {
			["isStoryNode"] = true,
			["key"] = "1770191078311639",
			["type"] = "StoryNode",
			["name"] = "找工匠确认炸炉的原因",
			["pos"] = {
				["x"] = 1562.3784461152884,
				["y"] = 535.2077922077922
			},
			["propsData"] = {
				["QuestId"] = 20031607,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Content_200316_7",
				["QuestDeatil"] = "Description_200316_7",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_GongJiang_322410142",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770191078311644",
						["startPort"] = "QuestStart",
						["endQuest"] = "1770194682929423951",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770194682929423951",
						["startPort"] = "Out",
						["endQuest"] = "1770194736371424184",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770194736371424184",
						["startPort"] = "Out",
						["endQuest"] = "1770194743258424296",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701961108401577760",
						["startPort"] = "Out",
						["endQuest"] = "1770191078311645",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1770194743258424296",
						["startPort"] = "Out",
						["endQuest"] = "17720931930622326577",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720931930622326577",
						["startPort"] = "Out",
						["endQuest"] = "17701961108401577760",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1770191078311644"] = {
						["key"] = "1770191078311644",
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
					["1770191078311645"] = {
						["key"] = "1770191078311645",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2757.368421052631,
							["y"] = 291.3684210526316
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770191078311646"] = {
						["key"] = "1770191078311646",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1770194682929423951"] = {
						["key"] = "1770194682929423951",
						["type"] = "TalkNode",
						["name"] = "与工匠对话",
						["pos"] = {
							["x"] = 1094.846889952153,
							["y"] = 289.47846889952154
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701109,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_GongJiang_322410142",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031614.20031614'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031606",
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
					["1770194736371424184"] = {
						["key"] = "1770194736371424184",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "将炉子切换为激活状态",
						["pos"] = {
							["x"] = 1377.7894736842104,
							["y"] = 297.68421052631584
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								322410132
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1320012,
							["QuestId"] = 200316
						}
					},
					["1770194743258424296"] = {
						["key"] = "1770194743258424296",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待小游戏完成",
						["pos"] = {
							["x"] = 1670.421052631579,
							["y"] = 285.2631578947369
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 322410132,
							["StateId"] = 1320014,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17701961108401577760"] = {
						["key"] = "17701961108401577760",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2322.7368421052633,
							["y"] = 270.6563467492261
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031615.20031615'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031607",
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
					["17720931930622326577"] = {
						["key"] = "17720931930622326577",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁五个NPC和炉子",
						["pos"] = {
							["x"] = 1983.3636363636363,
							["y"] = 290
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								322410138,
								322410139,
								322410140,
								322410141,
								322410142,
								322410132
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1770191078691652"] = {
			["isStoryNode"] = true,
			["key"] = "1770191078691652",
			["type"] = "StoryNode",
			["name"] = "合成线索",
			["pos"] = {
				["x"] = 1280.9197994987467,
				["y"] = 539.1061349024734
			},
			["propsData"] = {
				["QuestId"] = 20031606,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Content_200316_6",
				["QuestDeatil"] = "Description_200316_6",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Lanqin_322410138",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770191078691657",
						["startPort"] = "QuestStart",
						["endQuest"] = "1770194212871417388",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770194212871417388",
						["startPort"] = "Out",
						["endQuest"] = "1770194223038417564",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770194339855418402",
						["startPort"] = "Out",
						["endQuest"] = "1770194339855418403",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770194388835419218",
						["startPort"] = "Out",
						["endQuest"] = "1770194372499418886",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770194372499418886",
						["startPort"] = "Out",
						["endQuest"] = "1770191078691658",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1770194223038417564",
						["startPort"] = "Out",
						["endQuest"] = "17720216854953894",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17720216854953894",
						["startPort"] = "Out",
						["endQuest"] = "1770194339855418402",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770194339855418403",
						["startPort"] = "Out",
						["endQuest"] = "17720216961614198",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17720216961614198",
						["startPort"] = "Out",
						["endQuest"] = "1770194363432418694",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720218616575357",
						["startPort"] = "Out",
						["endQuest"] = "17720218616575358",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1770194363432418694",
						["startPort"] = "Out",
						["endQuest"] = "17720218616575357",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720218616575358",
						["startPort"] = "Out",
						["endQuest"] = "1770194388835419218",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1770191078691657"] = {
						["key"] = "1770191078691657",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 920,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770191078691658"] = {
						["key"] = "1770191078691658",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3411.7142857142853,
							["y"] = 322.8571428571429
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770191078691659"] = {
						["key"] = "1770191078691659",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1770194212871417388"] = {
						["key"] = "1770194212871417388",
						["type"] = "TalkNode",
						["name"] = "与澜清对话01",
						["pos"] = {
							["x"] = 1225.7272727272727,
							["y"] = 282.1363636363636
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701101,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Lanqin_322410138",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031610.20031610'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031605",
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
					["1770194223038417564"] = {
						["key"] = "1770194223038417564",
						["type"] = "HasDetectiveAnswerNode",
						["name"] = "检测推理线索八",
						["pos"] = {
							["x"] = 1498,
							["y"] = 302
						},
						["propsData"] = {
							["AnswerIds"] = {
								200508
							}
						}
					},
					["1770194339855418402"] = {
						["key"] = "1770194339855418402",
						["type"] = "TalkNode",
						["name"] = "与澜清对话02",
						["pos"] = {
							["x"] = 1796.5974025974024,
							["y"] = 297.42857142857144
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701101,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Lanqin_322410138",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031611.20031611'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031605",
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
					["1770194339855418403"] = {
						["key"] = "1770194339855418403",
						["type"] = "HasDetectiveAnswerNode",
						["name"] = "检测推理线索九",
						["pos"] = {
							["x"] = 2082.714285714286,
							["y"] = 313.5714285714286
						},
						["propsData"] = {
							["AnswerIds"] = {
								200509
							}
						}
					},
					["1770194363432418694"] = {
						["key"] = "1770194363432418694",
						["type"] = "TalkNode",
						["name"] = "与澜清对话03",
						["pos"] = {
							["x"] = 2362.5064935064934,
							["y"] = 315.7012987012987
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701101,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Lanqin_322410138",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031612.20031612'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031605",
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
					["1770194372499418886"] = {
						["key"] = "1770194372499418886",
						["type"] = "TalkNode",
						["name"] = "与澜清对话04",
						["pos"] = {
							["x"] = 3154.3636363636365,
							["y"] = 295.20779220779224
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701101,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Lanqin_322410138",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031613.20031613'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031605",
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
					["1770194388835419218"] = {
						["key"] = "1770194388835419218",
						["type"] = "HasDetectiveResultNode",
						["name"] = "检测是否获取过推理结果",
						["pos"] = {
							["x"] = 2898.285714285714,
							["y"] = 307.14285714285717
						},
						["propsData"] = {
							["ResultIds"] = {
								20050101
							}
						}
					},
					["17720216854953894"] = {
						["key"] = "17720216854953894",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 1626.8108108108108,
							["y"] = 544
						},
						["propsData"] = {
							["AnswerId"] = 200508,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["17720216961614198"] = {
						["key"] = "17720216961614198",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 2202,
							["y"] = 552
						},
						["propsData"] = {
							["AnswerId"] = 200509,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["17720218616575357"] = {
						["key"] = "17720218616575357",
						["type"] = "HasDetectiveAnswerNode",
						["name"] = "检测推理线索十",
						["pos"] = {
							["x"] = 2602.3571428571427,
							["y"] = 347.7857142857143
						},
						["propsData"] = {
							["AnswerIds"] = {
								200510
							}
						}
					},
					["17720218616575358"] = {
						["key"] = "17720218616575358",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 2751.642857142857,
							["y"] = 574.2142857142857
						},
						["propsData"] = {
							["AnswerId"] = 200510,
							["AutoOpenDetectiveGameUI"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1770191079607691"] = {
			["isStoryNode"] = true,
			["key"] = "1770191079607691",
			["type"] = "StoryNode",
			["name"] = "获得线索",
			["pos"] = {
				["x"] = 2479.991718426501,
				["y"] = 293.26576322228493
			},
			["propsData"] = {
				["QuestId"] = 20031605,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Content_200316_5",
				["QuestDeatil"] = "Description_200316_5",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_ZhenLiaoGuan_322410141",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "177019254265715767",
						["startPort"] = "Out",
						["endQuest"] = "177019259004216580",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019265248717358",
						["startPort"] = "Out",
						["endQuest"] = "177019266015317521",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019269631618223",
						["startPort"] = "Out",
						["endQuest"] = "177019269631618224",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019269678518236",
						["startPort"] = "Out",
						["endQuest"] = "177019269678518237",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019296795323942",
						["startPort"] = "Out",
						["endQuest"] = "177019296795323943",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019296795323943",
						["startPort"] = "Out",
						["endQuest"] = "177019296795323944",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019296795323947",
						["startPort"] = "Out",
						["endQuest"] = "177019296795323948",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019297801224216",
						["startPort"] = "Out",
						["endQuest"] = "177019297801224217",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019297801224217",
						["startPort"] = "Out",
						["endQuest"] = "177019297801224218",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019297801324221",
						["startPort"] = "Out",
						["endQuest"] = "177019297801324222",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019297801324222",
						["startPort"] = "Out",
						["endQuest"] = "1770191079607697",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177019296795323948",
						["startPort"] = "Out",
						["endQuest"] = "177019304868725637",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019296795323948",
						["startPort"] = "Out",
						["endQuest"] = "177019297801224216",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019269631618224",
						["startPort"] = "Out",
						["endQuest"] = "177019303691725391",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019269631618224",
						["startPort"] = "Out",
						["endQuest"] = "177019296795323942",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019259004216580",
						["startPort"] = "Out",
						["endQuest"] = "177019269678518236",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17721935473909686",
						["startPort"] = "Out",
						["endQuest"] = "17721935473909687",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770191079607696",
						["startPort"] = "QuestStart",
						["endQuest"] = "17721935473909686",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17721935473909686",
						["startPort"] = "Out",
						["endQuest"] = "177019254265715767",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019269678518237",
						["startPort"] = "Out",
						["endQuest"] = "17721941470234601",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17721941470234601",
						["startPort"] = "Out",
						["endQuest"] = "177019269631618223",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019296795323944",
						["startPort"] = "Out",
						["endQuest"] = "17721946607202370412",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17721946607202370412",
						["startPort"] = "Out",
						["endQuest"] = "177019296795323947",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177019297801224218",
						["startPort"] = "Out",
						["endQuest"] = "17721946873332371112",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17721946873332371112",
						["startPort"] = "Out",
						["endQuest"] = "177019297801324221",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["1770191079607696"] = {
						["key"] = "1770191079607696",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 644.1176470588235,
							["y"] = 478.8888888888889
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770191079607697"] = {
						["key"] = "1770191079607697",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4976.684491978609,
							["y"] = 524.4385026737968
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770191079607698"] = {
						["key"] = "1770191079607698",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2033.6363636363637,
							["y"] = 1114.5454545454545
						},
						["propsData"] = {}
					},
					["177019254265715767"] = {
						["key"] = "177019254265715767",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成甄料官、江仙、合香官、工匠、澜清",
						["pos"] = {
							["x"] = 1161.1355498721227,
							["y"] = 485.85166240409205
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								322410138,
								322410139,
								322410140,
								322410141,
								322410142
							}
						}
					},
					["177019259004216580"] = {
						["key"] = "177019259004216580",
						["type"] = "TalkNode",
						["name"] = "与甄料官对话",
						["pos"] = {
							["x"] = 1516.828947368421,
							["y"] = 480.831550802139
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701108,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_ZhenLiaoGuan_322410141",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031606.20031606'",
							["TalkType"] = "FreeSimple",
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["177019265248717358"] = {
						["key"] = "177019265248717358",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索一",
						["pos"] = {
							["x"] = 1792.2334928229668,
							["y"] = 4.513833992094817
						},
						["propsData"] = {
							["AnswerIds"] = {
								200501
							}
						}
					},
					["177019266015317521"] = {
						["key"] = "177019266015317521",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 2080.3425837320574,
							["y"] = 12.47272727272724
						},
						["propsData"] = {
							["AnswerId"] = 200501,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["177019269631618223"] = {
						["key"] = "177019269631618223",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索三",
						["pos"] = {
							["x"] = 1799.0334928229668,
							["y"] = 700.3068181818181
						},
						["propsData"] = {
							["AnswerIds"] = {
								200503
							}
						}
					},
					["177019269631618224"] = {
						["key"] = "177019269631618224",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 2098.8516746411487,
							["y"] = 699.4545454545454
						},
						["propsData"] = {
							["AnswerId"] = 200503,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["177019269678518236"] = {
						["key"] = "177019269678518236",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索二",
						["pos"] = {
							["x"] = 1801.4834928229668,
							["y"] = 307.62499999999994
						},
						["propsData"] = {
							["AnswerIds"] = {
								200502
							}
						}
					},
					["177019269678518237"] = {
						["key"] = "177019269678518237",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 2117.3425837320574,
							["y"] = 316.6545454545454
						},
						["propsData"] = {
							["AnswerId"] = 200502,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["177019296795323942"] = {
						["key"] = "177019296795323942",
						["type"] = "TalkNode",
						["name"] = "与合香官对话",
						["pos"] = {
							["x"] = 2676.586701379116,
							["y"] = 463.98189531057176
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701107,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_HeXiangGuan_322410140",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031608.20031608'",
							["TalkType"] = "FreeSimple",
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["177019296795323943"] = {
						["key"] = "177019296795323943",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索四",
						["pos"] = {
							["x"] = 3010.5010507552315,
							["y"] = 338.104775698158
						},
						["propsData"] = {
							["AnswerIds"] = {
								200504
							}
						}
					},
					["177019296795323944"] = {
						["key"] = "177019296795323944",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 3296.6101416643223,
							["y"] = 347.8704322638145
						},
						["propsData"] = {
							["AnswerId"] = 200504,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["177019296795323947"] = {
						["key"] = "177019296795323947",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索五",
						["pos"] = {
							["x"] = 2996.7510507552315,
							["y"] = 780.0227049910875
						},
						["propsData"] = {
							["AnswerIds"] = {
								200505
							}
						}
					},
					["177019296795323948"] = {
						["key"] = "177019296795323948",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 3342.943474997656,
							["y"] = 781.0522504456327
						},
						["propsData"] = {
							["AnswerId"] = 200505,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["177019297801224216"] = {
						["key"] = "177019297801224216",
						["type"] = "TalkNode",
						["name"] = "与江仙对话",
						["pos"] = {
							["x"] = 3915.4158773182667,
							["y"] = 460.92893803766526
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701106,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Jiangxian_322410139",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031609.20031609'",
							["TalkType"] = "FreeSimple",
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["177019297801224217"] = {
						["key"] = "177019297801224217",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索六",
						["pos"] = {
							["x"] = 4258.558091753449,
							["y"] = 347.34779411764663
						},
						["propsData"] = {
							["AnswerIds"] = {
								200506
							}
						}
					},
					["177019297801224218"] = {
						["key"] = "177019297801224218",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 4544.66718266254,
							["y"] = 354.00233957219206
						},
						["propsData"] = {
							["AnswerId"] = 200506,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["177019297801324221"] = {
						["key"] = "177019297801324221",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索七",
						["pos"] = {
							["x"] = 4229.808091753449,
							["y"] = 867.0724866956001
						},
						["propsData"] = {
							["AnswerIds"] = {
								200507
							}
						}
					},
					["177019297801324222"] = {
						["key"] = "177019297801324222",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 4572.333849329207,
							["y"] = 848.8508244206771
						},
						["propsData"] = {
							["AnswerId"] = 200507,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["177019303691725391"] = {
						["key"] = "177019303691725391",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 2415.0862372013507,
							["y"] = 279.51463862224693
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031607.20031607'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["177019304868725637"] = {
						["key"] = "177019304868725637",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 3632.8383380416876,
							["y"] = 308.693484073471
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031619.20031619'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17721935473909686"] = {
						["key"] = "17721935473909686",
						["type"] = "UnlockDetectiveQuestionNode",
						["name"] = "开启推理问题",
						["pos"] = {
							["x"] = 908.8728070175441,
							["y"] = 474.49444444444464
						},
						["propsData"] = {
							["QuestionIds"] = {
								2005
							},
							["OpenToast"] = true
						}
					},
					["17721935473909687"] = {
						["key"] = "17721935473909687",
						["type"] = "TalkNode",
						["name"] = "推理开车",
						["pos"] = {
							["x"] = 1148.893859649123,
							["y"] = 272.79444444444465
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031605.20031605'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17721941470234601"] = {
						["key"] = "17721941470234601",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1944.2619047619046,
							["y"] = 501.2142857142857
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17721946607202370412"] = {
						["key"] = "17721946607202370412",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3169.1428571428573,
							["y"] = 531.6190476190476
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17721946873332371112"] = {
						["key"] = "17721946873332371112",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 4399.142857142858,
							["y"] = 576.6190476190476
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					}
				},
				["commentData"] = {
					["177019281663820987"] = {
						["key"] = "177019281663820987",
						["name"] = "获得线索二三",
						["position"] = {
							["x"] = 1765.2527441598652,
							["y"] = 218.835294117647
						},
						["size"] = {
							["width"] = 562.7999999999998,
							["height"] = 603.6
						}
					},
					["177019315982827645"] = {
						["key"] = "177019315982827645",
						["name"] = "获得线索四五",
						["position"] = {
							["x"] = 2951.129654568298,
							["y"] = 272.8899887623027
						},
						["size"] = {
							["width"] = 611.3465359078926,
							["height"] = 658.7290588567448
						}
					},
					["177019318113928006"] = {
						["key"] = "177019318113928006",
						["name"] = "获得线索六七",
						["position"] = {
							["x"] = 4189.561027117318,
							["y"] = 276.6154789583812
						},
						["size"] = {
							["width"] = 609.5818300255393,
							["height"] = 730.0035686606664
						}
					}
				}
			}
		},
		["1770191079880704"] = {
			["isStoryNode"] = true,
			["key"] = "1770191079880704",
			["type"] = "StoryNode",
			["name"] = "分析炸炉的原因",
			["pos"] = {
				["x"] = 2171.173630717109,
				["y"] = 293.9047619047619
			},
			["propsData"] = {
				["QuestId"] = 20031604,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Content_200316_4",
				["QuestDeatil"] = "Description_200316_4",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_20031602_322410137",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "177019198287110701",
						["startPort"] = "Out",
						["endQuest"] = "177019198987410825",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019199910010980",
						["startPort"] = "Out",
						["endQuest"] = "177019203232011268",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019244557514459",
						["startPort"] = "Out",
						["endQuest"] = "177019246767914592",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770191079880709",
						["startPort"] = "QuestStart",
						["endQuest"] = "17720898998341162888",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720898998341162888",
						["startPort"] = "Out",
						["endQuest"] = "177019198287110701",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019198987410825",
						["startPort"] = "Out",
						["endQuest"] = "177019199910010980",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019198987410825",
						["startPort"] = "Out",
						["endQuest"] = "17720899282781163463",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177019203232011268",
						["startPort"] = "Out",
						["endQuest"] = "1770191079880710",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1770191079880709"] = {
						["key"] = "1770191079880709",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 731.6,
							["y"] = 284.8
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770191079880710"] = {
						["key"] = "1770191079880710",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2664.3666666666663,
							["y"] = 283.43333333333334
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770191079880711"] = {
						["key"] = "1770191079880711",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["177019198287110701"] = {
						["key"] = "177019198287110701",
						["type"] = "GoToNode",
						["name"] = "前往匠矩阁",
						["pos"] = {
							["x"] = 1313.2,
							["y"] = 270.4
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 322410137,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_20031602_322410137"
						}
					},
					["177019198987410825"] = {
						["key"] = "177019198987410825",
						["type"] = "TalkNode",
						["name"] = "黑屏一句话",
						["pos"] = {
							["x"] = 1579.2,
							["y"] = 274
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031620.20031620'",
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
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["177019199910010980"] = {
						["key"] = "177019199910010980",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "传送回祀烟阁",
						["pos"] = {
							["x"] = 1914.8,
							["y"] = 271.45741626794256
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_20031601",
							["FadeIn"] = true,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["177019203232011268"] = {
						["key"] = "177019203232011268",
						["type"] = "TalkNode",
						["name"] = "与江仙甄料官对话",
						["pos"] = {
							["x"] = 2198.8,
							["y"] = 271.59999999999997
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031604.20031604'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031604",
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
					["177019244557514459"] = {
						["key"] = "177019244557514459",
						["type"] = "UnlockDetectiveQuestionNode",
						["name"] = "开启推理问题",
						["pos"] = {
							["x"] = 2447.4666666666662,
							["y"] = 60.333333333333314
						},
						["propsData"] = {
							["QuestionIds"] = {
								2005
							},
							["OpenToast"] = true
						}
					},
					["177019246767914592"] = {
						["key"] = "177019246767914592",
						["type"] = "TalkNode",
						["name"] = "推理开车",
						["pos"] = {
							["x"] = 2780.8210526315784,
							["y"] = 85.3
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031605.20031605'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17720898998341162888"] = {
						["key"] = "17720898998341162888",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成工匠",
						["pos"] = {
							["x"] = 1046,
							["y"] = 280
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								322410136
							}
						}
					},
					["17720899282781163463"] = {
						["key"] = "17720899282781163463",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁工匠",
						["pos"] = {
							["x"] = 1897.3636363636365,
							["y"] = 491.45454545454544
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								322410136
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1770191080462730"] = {
			["isStoryNode"] = true,
			["key"] = "1770191080462730",
			["type"] = "StoryNode",
			["name"] = "击杀黑狴犴+对话",
			["pos"] = {
				["x"] = 1878.2753623188407,
				["y"] = 294.84615384615387
			},
			["propsData"] = {
				["QuestId"] = 20031603,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Content_200316_3",
				["QuestDeatil"] = "Description_200316_3",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "NewTargetPoint_20031601",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770191080462735",
						["startPort"] = "QuestStart",
						["endQuest"] = "17701917353048713",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701917353048713",
						["startPort"] = "Out",
						["endQuest"] = "17701917708859084",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701917708859084",
						["startPort"] = "Out",
						["endQuest"] = "17701917906169212",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701917906169212",
						["startPort"] = "Out",
						["endQuest"] = "1770191080462736",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1770191080462735"] = {
						["key"] = "1770191080462735",
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
					["1770191080462736"] = {
						["key"] = "1770191080462736",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2168,
							["y"] = 296
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770191080462737"] = {
						["key"] = "1770191080462737",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17701917353048713"] = {
						["key"] = "17701917353048713",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成怪物狴犴",
						["pos"] = {
							["x"] = 1128,
							["y"] = 302
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								322410133,
								322410134,
								322410135
							}
						}
					},
					["17701917708859084"] = {
						["key"] = "17701917708859084",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1470,
							["y"] = 266
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 3,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								322410133,
								322410134,
								322410135
							}
						}
					},
					["17701917906169212"] = {
						["key"] = "17701917906169212",
						["type"] = "TalkNode",
						["name"] = "与江仙合香官对话",
						["pos"] = {
							["x"] = 1818,
							["y"] = 272
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031603.20031603'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20031603",
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
					}
				},
				["commentData"] = {}
			}
		},
		["1770191080739743"] = {
			["isStoryNode"] = true,
			["key"] = "1770191080739743",
			["type"] = "StoryNode",
			["name"] = "炉子炸了",
			["pos"] = {
				["x"] = 1590,
				["y"] = 295.3913043478261
			},
			["propsData"] = {
				["QuestId"] = 20031602,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Content_200316_2",
				["QuestDeatil"] = "Description_200316_2",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_HeXiangGuan_322410131",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770191080739748",
						["startPort"] = "QuestStart",
						["endQuest"] = "17701916421397463",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701916421397463",
						["startPort"] = "Out",
						["endQuest"] = "17701916619387734",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701916619387734",
						["startPort"] = "Out",
						["endQuest"] = "17701969752763875481",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701969752763875481",
						["startPort"] = "Out",
						["endQuest"] = "1770191080739749",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1770191080739748",
						["startPort"] = "QuestStart",
						["endQuest"] = "17701974470803878503",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1770191080739748"] = {
						["key"] = "1770191080739748",
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
					["1770191080739749"] = {
						["key"] = "1770191080739749",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2103.076923076923,
							["y"] = 296.53846153846155
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770191080739750"] = {
						["key"] = "1770191080739750",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17701916421397463"] = {
						["key"] = "17701916421397463",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成合香官",
						["pos"] = {
							["x"] = 1180,
							["y"] = 298
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								322410131
							}
						}
					},
					["17701916619387734"] = {
						["key"] = "17701916619387734",
						["type"] = "TalkNode",
						["name"] = "与合香官对话，炉子炸了",
						["pos"] = {
							["x"] = 1483.3076923076926,
							["y"] = 283.3846153846154
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701107,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_HeXiangGuan_322410131",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200316/20031602.20031602'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20031602",
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
					["17701969752763875481"] = {
						["key"] = "17701969752763875481",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁合香官",
						["pos"] = {
							["x"] = 1773.1571906354516,
							["y"] = 305.3076923076925
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								322410131
							}
						}
					},
					["17701974470803878503"] = {
						["key"] = "17701974470803878503",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成未激活的炉子",
						["pos"] = {
							["x"] = 1179.8461538461536,
							["y"] = 113.61872909699012
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								322410132
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