return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17706037888781",
			["startPort"] = "StoryStart",
			["endStory"] = "1770604637441527",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770604637441527",
			["startPort"] = "Success",
			["endStory"] = "1770604634849331",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770604634849331",
			["startPort"] = "Success",
			["endStory"] = "17706064631173004",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17706071709564944",
			["startPort"] = "Success",
			["endStory"] = "17706080218787497",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17706080218787497",
			["startPort"] = "Success",
			["endStory"] = "17706080989349279",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17706080989349279",
			["startPort"] = "Success",
			["endStory"] = "17706081305039959",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17706081305039959",
			["startPort"] = "Success",
			["endStory"] = "177060821789411408",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177060821789411408",
			["startPort"] = "Success",
			["endStory"] = "177060831345612965",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17706064631173004",
			["startPort"] = "Success",
			["endStory"] = "17706065259043304",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17706065259043304",
			["startPort"] = "Success",
			["endStory"] = "17706071709564944",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177060831345612965",
			["startPort"] = "Success",
			["endStory"] = "17733961443071652",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17733961443071652",
			["startPort"] = "Success",
			["endStory"] = "17706037888795",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17706037888781"] = {
			["isStoryNode"] = true,
			["key"] = "17706037888781",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 710,
				["y"] = 307.82608695652175
			},
			["propsData"] = {
				["QuestChainId"] = 200317
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17706037888795"] = {
			["isStoryNode"] = true,
			["key"] = "17706037888795",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2328.3710407239814,
				["y"] = 965.6561085972851
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1770604634849331"] = {
			["isStoryNode"] = true,
			["key"] = "1770604634849331",
			["type"] = "StoryNode",
			["name"] = "与逍遥生对话",
			["pos"] = {
				["x"] = 1361.391304347826,
				["y"] = 322.20869565217396
			},
			["propsData"] = {
				["QuestId"] = 20031701,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031701_01",
				["QuestDeatil"] = "Content_20031701_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Xiaoyao_2420157",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770604634849332",
						["startPort"] = "QuestStart",
						["endQuest"] = "17706055912062169",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706055912062169",
						["startPort"] = "Out",
						["endQuest"] = "1770604634850340",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1770604634849332"] = {
						["key"] = "1770604634849332",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 768,
							["y"] = 274
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770604634850340"] = {
						["key"] = "1770604634850340",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2067.3333333333335,
							["y"] = 250.33333333333331
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770604634850348"] = {
						["key"] = "1770604634850348",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17706055912062169"] = {
						["key"] = "17706055912062169",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1364,
							["y"] = 278
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700385,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Xiaoyao_272420197",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031701.20031701'",
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
					}
				},
				["commentData"] = {}
			}
		},
		["1770604637441527"] = {
			["isStoryNode"] = true,
			["key"] = "1770604637441527",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 1045.145962732919,
				["y"] = 318.2329192546584
			},
			["propsData"] = {
				["QuestId"] = 20031700,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 104504,
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770604637441528",
						["startPort"] = "QuestStart",
						["endQuest"] = "17706055596861358",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706055596861358",
						["startPort"] = "Out",
						["endQuest"] = "17721064747833543314",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17721064747833543314",
						["startPort"] = "Out",
						["endQuest"] = "1770604637441531",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1770604637441528",
						["startPort"] = "QuestStart",
						["endQuest"] = "17731108626054682378",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1770604637441528"] = {
						["key"] = "1770604637441528",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1280,
							["y"] = 319.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770604637441531"] = {
						["key"] = "1770604637441531",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2368,
							["y"] = 292.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770604637441546"] = {
						["key"] = "1770604637441546",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17706055596861358"] = {
						["key"] = "17706055596861358",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1754.6218487394958,
							["y"] = 291.6638655462185
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 272420196,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Qinsheng_272420196"
						}
					},
					["17721064747833543314"] = {
						["key"] = "17721064747833543314",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2020.3522625483374,
							["y"] = 319.648732496214
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031714.20031714'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17731108626054682378"] = {
						["key"] = "17731108626054682378",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1736.432841238569,
							["y"] = 521.0953863602858
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								272420197
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17706064631173004"] = {
			["isStoryNode"] = true,
			["key"] = "17706064631173004",
			["type"] = "StoryNode",
			["name"] = "钓鱼节点",
			["pos"] = {
				["x"] = 1694.9972315124492,
				["y"] = 320.91301089382034
			},
			["propsData"] = {
				["QuestId"] = 20031702,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031702_01",
				["QuestDeatil"] = "Content_20031702_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "BP_QinshengFish_2420169",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17706064631173005",
						["startPort"] = "QuestStart",
						["endQuest"] = "177302670336514146367",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706064631173005",
						["startPort"] = "QuestStart",
						["endQuest"] = "177312815743521336991",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "177312815743521336991",
						["startPort"] = "Out",
						["endQuest"] = "177314253929341936169",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177314253929341936169",
						["startPort"] = "Out",
						["endQuest"] = "17706064631183008",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17706064631173005"] = {
						["key"] = "17706064631173005",
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
					["17706064631183008"] = {
						["key"] = "17706064631183008",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1819.6444805194806,
							["y"] = 397.23295454545456
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17706064631183011"] = {
						["key"] = "17706064631183011",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["177302670336514146367"] = {
						["key"] = "177302670336514146367",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1246.1279647481058,
							["y"] = 204.94974161993602
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								272420198
							}
						}
					},
					["177312815743521336991"] = {
						["key"] = "177312815743521336991",
						["type"] = "ResourceCollectNode",
						["name"] = "获得Resource道具",
						["pos"] = {
							["x"] = 1273.1765579371413,
							["y"] = 416.68535219455015
						},
						["propsData"] = {
							["ResourceType"] = "Resource",
							["ResourceId"] = 5030030,
							["ResourceSType"] = "Fish",
							["NeedCount"] = 1,
							["bUseBagCount"] = false,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "BP_QinshengFish_2420169"
						}
					},
					["177314253929341936169"] = {
						["key"] = "177314253929341936169",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1534.5006958681754,
							["y"] = 399.4956970221363
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								272420197
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17706065259043304"] = {
			["isStoryNode"] = true,
			["key"] = "17706065259043304",
			["type"] = "StoryNode",
			["name"] = "钓鱼节点后对话",
			["pos"] = {
				["x"] = 2003.2741545893723,
				["y"] = 332.31960430041386
			},
			["propsData"] = {
				["QuestId"] = 20031703,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031702_02",
				["QuestDeatil"] = "Content_20031702_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "BP_QinshengFish_2420169",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17706065442553653",
						["startPort"] = "Out",
						["endQuest"] = "17706066093534486",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706066093534486",
						["startPort"] = "Out",
						["endQuest"] = "17706066096274494",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706065259043305",
						["startPort"] = "QuestStart",
						["endQuest"] = "177313115660922623156",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177313115660922623156",
						["startPort"] = "Out",
						["endQuest"] = "17706065442553653",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177313115660922623156",
						["startPort"] = "Out",
						["endQuest"] = "177313239732025195705",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706066096274494",
						["startPort"] = "Out",
						["endQuest"] = "17706065259043308",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17706065259043305"] = {
						["key"] = "17706065259043305",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 485.8479532163743,
							["y"] = 364.85380116959067
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17706065259043308"] = {
						["key"] = "17706065259043308",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2537.3333333333335,
							["y"] = 382
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17706065259043311"] = {
						["key"] = "17706065259043311",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17706065442553653"] = {
						["key"] = "17706065442553653",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1233.7777777777778,
							["y"] = 374.8333333333333
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031702.20031702'",
							["TalkType"] = "QuestImpression",
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
					["17706066093534486"] = {
						["key"] = "17706066093534486",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1592,
							["y"] = 362.75
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031703.20031703'",
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
					["17706066096274494"] = {
						["key"] = "17706066096274494",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1908.1313131313132,
							["y"] = 359.54040404040404
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031723.20031723'",
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
					["177313115660922623156"] = {
						["key"] = "177313115660922623156",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 910.4795321637426,
							["y"] = 381.13450292397664
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 272420206,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Qinsheng_272420206"
						}
					},
					["177313239732025195705"] = {
						["key"] = "177313239732025195705",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1582.6947403092709,
							["y"] = 26.635617039964643
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								272420198
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17706071709564944"] = {
			["isStoryNode"] = true,
			["key"] = "17706071709564944",
			["type"] = "StoryNode",
			["name"] = "村民对话节点",
			["pos"] = {
				["x"] = 1066.550116127834,
				["y"] = 582.8580658388754
			},
			["propsData"] = {
				["QuestId"] = 20031704,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031704_01",
				["QuestDeatil"] = "Content_20031704_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_Qinsheng_2420159",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17706071709564945",
						["startPort"] = "QuestStart",
						["endQuest"] = "17706077604796495",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706071709564945",
						["startPort"] = "QuestStart",
						["endQuest"] = "17720961904122363264",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720961904122363264",
						["startPort"] = "Out",
						["endQuest"] = "17721047161181182085",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720961904122363264",
						["startPort"] = "Out",
						["endQuest"] = "17706072118665786",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706072118665786",
						["startPort"] = "Out",
						["endQuest"] = "17721047226001182266",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706072118665786",
						["startPort"] = "Out",
						["endQuest"] = "17706072103395699",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706072103395699",
						["startPort"] = "Out",
						["endQuest"] = "17721047230331182285",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706072103395699",
						["startPort"] = "Out",
						["endQuest"] = "17706072120685795",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720961904122363264",
						["startPort"] = "Out",
						["endQuest"] = "17730469099892925703",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706072120685795",
						["startPort"] = "Out",
						["endQuest"] = "17706071709564948",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17706071709564945"] = {
						["key"] = "17706071709564945",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 622,
							["y"] = 326
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17706071709564948"] = {
						["key"] = "17706071709564948",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2820.076923076923,
							["y"] = 393.9230769230769
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17706071709564951"] = {
						["key"] = "17706071709564951",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17706072103395699"] = {
						["key"] = "17706072103395699",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1823.7777777777778,
							["y"] = 331.3333333333334
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 240038,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12020508nongfu_242420058",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031705.20031705'",
							["TalkType"] = "FreeSimple",
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
					["17706072118665786"] = {
						["key"] = "17706072118665786",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1472.6565656565656,
							["y"] = 433.5555555555556
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700389,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_qinsheng_272420207",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031704.20031704'",
							["TalkType"] = "FreeSimple",
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
					["17706072120685795"] = {
						["key"] = "17706072120685795",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2136,
							["y"] = 384
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700388,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Baozi_272420195",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031706.20031706'",
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
					["17706077604796495"] = {
						["key"] = "17706077604796495",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1066.8846153846152,
							["y"] = -192.6923076923077
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031716.20031716'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17720961904122363264"] = {
						["key"] = "17720961904122363264",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 924,
							["y"] = 410
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2420159,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Qinsheng_2420159"
						}
					},
					["17721047161181182085"] = {
						["key"] = "17721047161181182085",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1626.931623931624,
							["y"] = 172.48717948717945
						},
						["propsData"] = {
							["NewDescription"] = "Description_20031704_02",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17721047226001182266"] = {
						["key"] = "17721047226001182266",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1746.4539835164835,
							["y"] = 565.3962912087912
						},
						["propsData"] = {
							["NewDescription"] = "Description_20031704_03",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17721047230331182285"] = {
						["key"] = "17721047230331182285",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2127.4395604395604,
							["y"] = 541.9587912087912
						},
						["propsData"] = {
							["NewDescription"] = "Description_20031704_04",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17730469099892925703"] = {
						["key"] = "17730469099892925703",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1181.0956944688926,
							["y"] = 73.15068247605426
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								272420207,
								272420195
							}
						}
					},
					["177313387322635481208"] = {
						["key"] = "177313387322635481208",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1027.730333852681,
							["y"] = 1020.5866220735787
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17706080218787497"] = {
			["isStoryNode"] = true,
			["key"] = "17706080218787497",
			["type"] = "StoryNode",
			["name"] = "前往战斗节点",
			["pos"] = {
				["x"] = 1361.1709203236378,
				["y"] = 591.2594644402739
			},
			["propsData"] = {
				["QuestId"] = 20031705,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031705_01",
				["QuestDeatil"] = "Content_20031705_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QinSheng_2420147",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17706080218787498",
						["startPort"] = "QuestStart",
						["endQuest"] = "17706080335587699",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706080218787498",
						["startPort"] = "QuestStart",
						["endQuest"] = "17706080576548046",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706080576548046",
						["startPort"] = "Out",
						["endQuest"] = "17706080635138262",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706080576548046",
						["startPort"] = "Out",
						["endQuest"] = "17706080716628485",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706080716628485",
						["startPort"] = "Out",
						["endQuest"] = "17706080781268651",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706080576548046",
						["startPort"] = "Out",
						["endQuest"] = "17706080849418872",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706080781268651",
						["startPort"] = "Out",
						["endQuest"] = "17706080218787501",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17706080576548046",
						["startPort"] = "Out",
						["endQuest"] = "177312242241516208095",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706080576548046",
						["startPort"] = "Out",
						["endQuest"] = "177314136756339351848",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17706080218787498"] = {
						["key"] = "17706080218787498",
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
					["17706080218787501"] = {
						["key"] = "17706080218787501",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2419,
							["y"] = 505.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17706080218787504"] = {
						["key"] = "17706080218787504",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17706080335587699"] = {
						["key"] = "17706080335587699",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 1272,
							["y"] = -9.5
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031717.20031717'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17706080576548046"] = {
						["key"] = "17706080576548046",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1284,
							["y"] = 474.5
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 272420199,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QinSheng_272420199"
						}
					},
					["17706080635138262"] = {
						["key"] = "17706080635138262",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 1542.5,
							["y"] = 212
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031718.20031718'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17706080716628485"] = {
						["key"] = "17706080716628485",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1634.5,
							["y"] = 540
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								272420200,
								272420201,
								272420203,
								272420202
							}
						}
					},
					["17706080781268651"] = {
						["key"] = "17706080781268651",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2021.804347826087,
							["y"] = 528.5
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 4,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "BP_QinshengBattle",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								272420200,
								272420201,
								272420202,
								272420203
							}
						}
					},
					["17706080849418872"] = {
						["key"] = "17706080849418872",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1786.5,
							["y"] = 315.5
						},
						["propsData"] = {
							["NewDescription"] = "Description_20031705_02",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["177312242241516208095"] = {
						["key"] = "177312242241516208095",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1591.116704805492,
							["y"] = 734.4790236460716
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								272420205
							}
						}
					},
					["177314136756339351848"] = {
						["key"] = "177314136756339351848",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1595.8993135011442,
							["y"] = 1027.3775743707095
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								272420207,
								272420195
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17706080989349279"] = {
			["isStoryNode"] = true,
			["key"] = "17706080989349279",
			["type"] = "StoryNode",
			["name"] = "宫先生对话节点",
			["pos"] = {
				["x"] = 1680.0391021418197,
				["y"] = 600.2151462584558
			},
			["propsData"] = {
				["QuestId"] = 20031706,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031706_01",
				["QuestDeatil"] = "Content_20031705_02",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QinSheng_2420147",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17706080989349280",
						["startPort"] = "QuestStart",
						["endQuest"] = "17706081112459517",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706081112459517",
						["startPort"] = "Out",
						["endQuest"] = "17706080989359283",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17706080989349280",
						["startPort"] = "QuestStart",
						["endQuest"] = "177312278059817488462",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17706080989349280"] = {
						["key"] = "17706080989349280",
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
					["17706080989359283"] = {
						["key"] = "17706080989359283",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1636,
							["y"] = 290
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17706080989359286"] = {
						["key"] = "17706080989359286",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17706081112459517"] = {
						["key"] = "17706081112459517",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1234,
							["y"] = 295
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700386,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Gong_272420205",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031707.20031707'",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1,
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
					["177312278059817488462"] = {
						["key"] = "177312278059817488462",
						["type"] = "ChangeNpcDefaultDataNode",
						["name"] = "修改NPC默认动作/表情节点",
						["pos"] = {
							["x"] = 1122.7457264957266,
							["y"] = 125.83981727085182
						},
						["propsData"] = {
							["ChangeNpcDefaultDataList"] = {
								{
									["TargetNpcUnitId"] = 700386,
									["DefaultActionId"] = 2,
									["DefaultFacialId"] = 1
								}
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17706081305039959"] = {
			["isStoryNode"] = true,
			["key"] = "17706081305039959",
			["type"] = "StoryNode",
			["name"] = "神秘人对话节点",
			["pos"] = {
				["x"] = 2027.2266021418197,
				["y"] = 592.459464440274
			},
			["propsData"] = {
				["QuestId"] = 20031707,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031707_01",
				["QuestDeatil"] = "Content_20031707_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QinSheng_2420147",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17706081305039964",
						["startPort"] = "QuestStart",
						["endQuest"] = "17706081305039967",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706081305039967",
						["startPort"] = "Out",
						["endQuest"] = "177060818182310749",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17706081305039967",
						["startPort"] = "Fail",
						["endQuest"] = "177060818182310749",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177060818182310749",
						["startPort"] = "Out",
						["endQuest"] = "17706081305039965",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17706081305039964"] = {
						["key"] = "17706081305039964",
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
					["17706081305039965"] = {
						["key"] = "17706081305039965",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1878.8,
							["y"] = 305.6
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17706081305039966"] = {
						["key"] = "17706081305039966",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17706081305039967"] = {
						["key"] = "17706081305039967",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1184,
							["y"] = 296
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031708.20031708'",
							["TalkType"] = "QuestImpression",
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
					["177060818182310749"] = {
						["key"] = "177060818182310749",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1476,
							["y"] = 322.00000000000006
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031709.20031709'",
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
					}
				},
				["commentData"] = {}
			}
		},
		["177060821789411408"] = {
			["isStoryNode"] = true,
			["key"] = "177060821789411408",
			["type"] = "StoryNode",
			["name"] = "回到尸体",
			["pos"] = {
				["x"] = 1145.8345566872745,
				["y"] = 878.2069391877487
			},
			["propsData"] = {
				["QuestId"] = 20031708,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031708_01",
				["QuestDeatil"] = "Content_20031708_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_Qinsheng_2420158",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "177060821789411409",
						["startPort"] = "QuestStart",
						["endQuest"] = "177060824346211772",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177305680265310478435",
						["startPort"] = "Fail",
						["endQuest"] = "177305680265310478434",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177305680265310478435",
						["startPort"] = "PassiveFail",
						["endQuest"] = "177305680265310478434",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177060825704512154",
						["startPort"] = "Out",
						["endQuest"] = "177305680265310478435",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177305680265310478435",
						["startPort"] = "Success",
						["endQuest"] = "177060821789411412",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177060821789411409",
						["startPort"] = "QuestStart",
						["endQuest"] = "17731112005057244769",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17731112005057244769",
						["startPort"] = "Out",
						["endQuest"] = "177060825704512154",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177060825704512154",
						["startPort"] = "Out",
						["endQuest"] = "17731118225849806836",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17731112005057244769",
						["startPort"] = "Out",
						["endQuest"] = "177314208176840644552",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177305680265310478434",
						["startPort"] = "Out",
						["endQuest"] = "177060821789411415",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["177060821789411409"] = {
						["key"] = "177060821789411409",
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
					["177060821789411412"] = {
						["key"] = "177060821789411412",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2378.521739130435,
							["y"] = 467.04347826086956
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177060821789411415"] = {
						["key"] = "177060821789411415",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["177060824346211772"] = {
						["key"] = "177060824346211772",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1180,
							["y"] = 144
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031719.20031719'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["177060825704512154"] = {
						["key"] = "177060825704512154",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1512,
							["y"] = 440.17391304347825
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031710.20031710'",
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
					["177305680265310478434"] = {
						["key"] = "177305680265310478434",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2123.55,
							["y"] = 668.6970251716247
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "200317TraceFail",
							["UnitId"] = -1
						}
					},
					["177305680265310478435"] = {
						["key"] = "177305680265310478435",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1856.9717391304348,
							["y"] = 497.4448512585813
						},
						["propsData"] = {
							["SpecialConfigId"] = 20031799,
							["BlackScreenImmediately"] = false
						}
					},
					["17731112005057244769"] = {
						["key"] = "17731112005057244769",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1204,
							["y"] = 434
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 272420196,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Qinsheng_272420196"
						}
					},
					["17731118225849806836"] = {
						["key"] = "17731118225849806836",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1899.3180778032038,
							["y"] = 271.79061784897027
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031720.20031720'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["177314208176840644552"] = {
						["key"] = "177314208176840644552",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1516.274599542334,
							["y"] = 200.0514874141876
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								272420205
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["177060831345612965"] = {
			["isStoryNode"] = true,
			["key"] = "177060831345612965",
			["type"] = "StoryNode",
			["name"] = "抵达后对话",
			["pos"] = {
				["x"] = 1740.7646856799033,
				["y"] = 909.2702752510849
			},
			["propsData"] = {
				["QuestId"] = 20031710,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031709_01",
				["QuestDeatil"] = "Content_20031709_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "177060832859213225",
						["startPort"] = "Out",
						["endQuest"] = "177060831345612969",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177060831345612966",
						["startPort"] = "QuestStart",
						["endQuest"] = "17731115643538525602",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17731115643538525602",
						["startPort"] = "Out",
						["endQuest"] = "177060832859213225",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["177060831345612966"] = {
						["key"] = "177060831345612966",
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
					["177060831345612969"] = {
						["key"] = "177060831345612969",
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
					["177060831345612972"] = {
						["key"] = "177060831345612972",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["177060832859213225"] = {
						["key"] = "177060832859213225",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1684.5,
							["y"] = 400.5
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031711.20031711'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
					["17731115643538525602"] = {
						["key"] = "17731115643538525602",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1319,
							["y"] = 318
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 272420204,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QinshengEnd_272420204"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17733961443071652"] = {
			["isStoryNode"] = true,
			["key"] = "17733961443071652",
			["type"] = "StoryNode",
			["name"] = "最后的对话",
			["pos"] = {
				["x"] = 2045.6993019947251,
				["y"] = 937.247167014272
			},
			["propsData"] = {
				["QuestId"] = 20031711,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031711_01",
				["QuestDeatil"] = "Content_20031711_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17733961443071657",
						["startPort"] = "QuestStart",
						["endQuest"] = "17733962755241264722",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733962755241264722",
						["startPort"] = "Out",
						["endQuest"] = "17733963080211264978",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733962755241264722",
						["startPort"] = "Out",
						["endQuest"] = "17733963090471265054",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733963080211264978",
						["startPort"] = "Out",
						["endQuest"] = "17733963200991265345",
						["endPort"] = "Branch_1"
					},
					{
						["startQuest"] = "17733963090471265054",
						["startPort"] = "Out",
						["endQuest"] = "17733963200991265345",
						["endPort"] = "Branch_2"
					},
					{
						["startQuest"] = "17733961443071657",
						["startPort"] = "QuestStart",
						["endQuest"] = "17733963339391265790",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733963200991265345",
						["startPort"] = "Out",
						["endQuest"] = "17733963380661265971",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733963380661265971",
						["startPort"] = "Out",
						["endQuest"] = "17733961443071658",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17733961443071657"] = {
						["key"] = "17733961443071657",
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
					["17733961443071658"] = {
						["key"] = "17733961443071658",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2592.713043478261,
							["y"] = 427.2521739130435
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17733961443071659"] = {
						["key"] = "17733961443071659",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17733962755241264722"] = {
						["key"] = "17733962755241264722",
						["type"] = "BranchQuestStartNode",
						["name"] = "子任务开始节点",
						["pos"] = {
							["x"] = 1298.75,
							["y"] = 381.80000000000007
						},
						["propsData"] = {
							["AllQuestOptions"] = {
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "",
									["TargetBranchQuestKey"] = ""
								},
								{
									["IsNeedFinish"] = false,
									["BranchQuestName"] = "Description_20031711_02",
									["TargetBranchQuestKey"] = ""
								}
							},
							["IsSetCountInfo"] = false,
							["IsDifftation"] = false,
							["AllDiffGuideOptions"] = {
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "",
											["IsShowOptional"] = false
										}
									}
								},
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "17733963090471265054",
											["IsShowOptional"] = true
										}
									}
								}
							}
						}
					},
					["17733963080211264978"] = {
						["key"] = "17733963080211264978",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1662.3500000000001,
							["y"] = 391.7
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700385,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Qinsheng_2420208",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031713.20031713'",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1,
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
					["17733963090471265054"] = {
						["key"] = "17733963090471265054",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1655.0500000000002,
							["y"] = 607.4
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700387,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Qinsheng_2420209",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200317/20031712.20031712'",
							["TalkType"] = "FreeSimple",
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
					["17733963200991265345"] = {
						["key"] = "17733963200991265345",
						["type"] = "CheckBranchQuestFinishedNode",
						["name"] = "子任务结束节点",
						["pos"] = {
							["x"] = 2065.8500000000004,
							["y"] = 398.5999999999999
						},
						["propsData"] = {
							["InputBranchQuestNumber"] = 2,
							["BranchQuestFinishOptions"] = {
								{
									["IsNeedFinish"] = true
								},
								{
									["IsNeedFinish"] = false
								}
							}
						}
					},
					["17733963339391265790"] = {
						["key"] = "17733963339391265790",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1103.971739130435,
							["y"] = 577.6086956521739
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420209,
								2420208
							}
						}
					},
					["17733963380661265971"] = {
						["key"] = "17733963380661265971",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2344.6456521739133,
							["y"] = 427.6086956521739
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420209,
								2420208
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