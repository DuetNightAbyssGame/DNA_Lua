return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17501516689411",
			["startPort"] = "StoryStart",
			["endStory"] = "175015168049583",
			["endPort"] = "In"
		},
		{
			["startStory"] = "175015168049583",
			["startPort"] = "Success",
			["endStory"] = "17501516689425",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17501516689411"] = {
			["isStoryNode"] = true,
			["key"] = "17501516689411",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17501516689425"] = {
			["isStoryNode"] = true,
			["key"] = "17501516689425",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1430,
				["y"] = 288
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["175015168049583"] = {
			["isStoryNode"] = true,
			["key"] = "175015168049583",
			["type"] = "StoryNode",
			["name"] = "礼物",
			["pos"] = {
				["x"] = 1110.5,
				["y"] = 279.5
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_Gift_Des",
				["QuestDeatil"] = "",
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
				["bIsDynamicEvent"] = true,
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
						["startQuest"] = "175015168049584",
						["startPort"] = "QuestStart",
						["endQuest"] = "1750151799282572",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750151799282572",
						["startPort"] = "Out",
						["endQuest"] = "1750151792109307",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750151799282572",
						["startPort"] = "Out",
						["endQuest"] = "1750151806482874",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501519762351904",
						["startPort"] = "Out",
						["endQuest"] = "17501519802312104",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501520379253645",
						["startPort"] = "Out",
						["endQuest"] = "175015168049591",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17501520405463755",
						["startPort"] = "Out",
						["endQuest"] = "175015168049591",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17501519802312104",
						["startPort"] = "Option_1",
						["endQuest"] = "17501519939172501",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501519802312104",
						["startPort"] = "Option_2",
						["endQuest"] = "17501519939172501",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750151806482874",
						["startPort"] = "Option_2",
						["endQuest"] = "17501519665501582",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750151806482874",
						["startPort"] = "Option_1",
						["endQuest"] = "17501519762351904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501519802312104",
						["startPort"] = "Option_3",
						["endQuest"] = "17501519939172501",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17575778221273201732",
						["startPort"] = "Out",
						["endQuest"] = "175015168049591",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17501519802312104",
						["startPort"] = "Option_1",
						["endQuest"] = "17501520042682862",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501519802312104",
						["startPort"] = "Option_2",
						["endQuest"] = "17575778221273201731",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501519802312104",
						["startPort"] = "Option_3",
						["endQuest"] = "17501639742181275563",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501520042682862",
						["startPort"] = "Out",
						["endQuest"] = "17501520379253645",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17575778221273201731",
						["startPort"] = "Out",
						["endQuest"] = "17575778221273201732",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501639742181275563",
						["startPort"] = "Out",
						["endQuest"] = "17501520405463755",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["175015168049584"] = {
						["key"] = "175015168049584",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1070,
							["y"] = 298.125
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["175015168049591"] = {
						["key"] = "175015168049591",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4120.846153846154,
							["y"] = 240.38717948717948
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["175015168049598"] = {
						["key"] = "175015168049598",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4153.2,
							["y"] = 817.7333333333333
						},
						["propsData"] = {}
					},
					["1750151792109307"] = {
						["key"] = "1750151792109307",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1732,
							["y"] = 45.325
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71007001,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1750151799282572"] = {
						["key"] = "1750151799282572",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成男npc",
						["pos"] = {
							["x"] = 1386.8,
							["y"] = 292.925
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110103
							}
						}
					},
					["1750151806482874"] = {
						["key"] = "1750151806482874",
						["type"] = "TalkNode",
						["name"] = "请求买礼物对话",
						["pos"] = {
							["x"] = 1743.4631578947372,
							["y"] = 298.18026315789484
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818066,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2110103",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007002,
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
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"",
								""
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "FadeOut",
							["FailOutTime"] = 2
						}
					},
					["17501519665501582"] = {
						["key"] = "17501519665501582",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 2088.132894736842,
							["y"] = 553.363157894737
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["17501519762351904"] = {
						["key"] = "17501519762351904",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成小贩npc",
						["pos"] = {
							["x"] = 2241.4465534465535,
							["y"] = 293.45870795870815
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110104
							}
						}
					},
					["17501519802312104"] = {
						["key"] = "17501519802312104",
						["type"] = "TalkNode",
						["name"] = "小贩对话",
						["pos"] = {
							["x"] = 2604.1388611388606,
							["y"] = 263.4587079587081
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818067,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2110104",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007005,
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
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"买错礼物",
								"买对礼物",
								"买对礼物"
							},
							["OverrideFailBlend"] = false
						}
					},
					["17501519939172501"] = {
						["key"] = "17501519939172501",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成女npc",
						["pos"] = {
							["x"] = 2870.439210789211,
							["y"] = -54.70440392940386
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110105
							}
						}
					},
					["17501520042682862"] = {
						["key"] = "17501520042682862",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3026.8969030969033,
							["y"] = 101.16290376290397
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818066,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2110103",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71007012,
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
					["17501520379253645"] = {
						["key"] = "17501520379253645",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3764.9584415584413,
							["y"] = 107.80905760905777
						},
						["propsData"] = {
							["DialogueId"] = 710070101,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17501520405463755"] = {
						["key"] = "17501520405463755",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3775.758441558441,
							["y"] = 595.0090576090577
						},
						["propsData"] = {
							["DialogueId"] = 710070103,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17501639742181275563"] = {
						["key"] = "17501639742181275563",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3038.271028971028,
							["y"] = 587.5908757908757
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818066,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2110103",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71007016,
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
					["17575778221273201731"] = {
						["key"] = "17575778221273201731",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3040.52888633106,
							["y"] = 307.32477739651654
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818066,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2110103",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71007016,
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
					["17575778221273201732"] = {
						["key"] = "17575778221273201732",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3774.190424792598,
							["y"] = 313.8665834165834
						},
						["propsData"] = {
							["DialogueId"] = 710070102,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}