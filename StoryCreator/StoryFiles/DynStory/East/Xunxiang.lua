return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17502139419031",
			["startPort"] = "StoryStart",
			["endStory"] = "1750213978704136",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1750213978704136",
			["startPort"] = "Success",
			["endStory"] = "17502139419035",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17502139419031"] = {
			["isStoryNode"] = true,
			["key"] = "17502139419031",
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
		["17502139419035"] = {
			["isStoryNode"] = true,
			["key"] = "17502139419035",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1543.142857142857,
				["y"] = 296.2857142857143
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1750213978704136"] = {
			["isStoryNode"] = true,
			["key"] = "1750213978704136",
			["type"] = "StoryNode",
			["name"] = "寻香",
			["pos"] = {
				["x"] = 1168,
				["y"] = 280
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_Xunxiang_Des",
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
						["startQuest"] = "1750213978704137",
						["startPort"] = "QuestStart",
						["endQuest"] = "1750244177096308",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750244177096308",
						["startPort"] = "Out",
						["endQuest"] = "1750244194350490",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750244177096308",
						["startPort"] = "Out",
						["endQuest"] = "1750244197345693",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17502460202332776",
						["startPort"] = "Out",
						["endQuest"] = "17502461060523901",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17502460237112933",
						["startPort"] = "Out",
						["endQuest"] = "17502461060523901",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17502461060523901",
						["startPort"] = "Out",
						["endQuest"] = "17502461152704199",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17502461060523901",
						["startPort"] = "Out",
						["endQuest"] = "17502461190554383",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17502461525775323",
						["startPort"] = "Out",
						["endQuest"] = "1750213978704144",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17502461558475466",
						["startPort"] = "Out",
						["endQuest"] = "1750213978704144",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1750213978704137",
						["startPort"] = "QuestStart",
						["endQuest"] = "17502459912882249",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750244197345693",
						["startPort"] = "Fail",
						["endQuest"] = "17502459529782022",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750244197345693",
						["startPort"] = "Out",
						["endQuest"] = "17502460202332776",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750244197345693",
						["startPort"] = "Out",
						["endQuest"] = "17502460237112933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17502461152704199",
						["startPort"] = "Option_1",
						["endQuest"] = "17502461525775323",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17502461152704199",
						["startPort"] = "Option_2",
						["endQuest"] = "17502461558475466",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1750213978704137"] = {
						["key"] = "1750213978704137",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1016,
							["y"] = 260
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1750213978704144"] = {
						["key"] = "1750213978704144",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4233.433020165573,
							["y"] = 273.58245392101384
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1750213978704151"] = {
						["key"] = "1750213978704151",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4338.152884342143,
							["y"] = 638.6928104575163
						},
						["propsData"] = {}
					},
					["1750244177096308"] = {
						["key"] = "1750244177096308",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1398.25,
							["y"] = 261.00000000000006
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090143
							}
						}
					},
					["1750244194350490"] = {
						["key"] = "1750244194350490",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1811.8863636363637,
							["y"] = -0.24999999999994316
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71007201,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1750244197345693"] = {
						["key"] = "1750244197345693",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1815.9285714285713,
							["y"] = 255.46428571428572
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818074,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090143",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007203,
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
							["OverrideFailBlend"] = true,
							["FailOutType"] = "FadeOut",
							["FailOutTime"] = 2
						}
					},
					["17502459529782022"] = {
						["key"] = "17502459529782022",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 2105.711420932009,
							["y"] = 566.6771514930081
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["17502459912882249"] = {
						["key"] = "17502459912882249",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成商人",
						["pos"] = {
							["x"] = 1402.388144208732,
							["y"] = 461.7566719725288
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090144,
								2090145
							}
						}
					},
					["17502460202332776"] = {
						["key"] = "17502460202332776",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2450.0342980548858,
							["y"] = 108.43359504945182
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818072,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090144",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007206,
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
					["17502460237112933"] = {
						["key"] = "17502460237112933",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2458.7727595933475,
							["y"] = 428.55667197252876
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818073,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090145",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007207,
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
					["17502461060523901"] = {
						["key"] = "17502461060523901",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2985.263134918505,
							["y"] = 248.46250623488461
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17502461152704199"] = {
						["key"] = "17502461152704199",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3319.1885829471794,
							["y"] = 262.0997822205477
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818074,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090143",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007209,
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
								"1",
								"2"
							},
							["OverrideFailBlend"] = false
						}
					},
					["17502461190554383"] = {
						["key"] = "17502461190554383",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3319.7075793629497,
							["y"] = 61.79583956821796
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71007208,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17502461525775323"] = {
						["key"] = "17502461525775323",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3744.9766118670714,
							["y"] = 159.89882259849108
						},
						["propsData"] = {
							["DialogueId"] = 710072091,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17502461558475466"] = {
						["key"] = "17502461558475466",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3740.201266244951,
							["y"] = 426.9955967920396
						},
						["propsData"] = {
							["DialogueId"] = 710072092,
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