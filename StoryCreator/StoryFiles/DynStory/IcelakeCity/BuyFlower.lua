return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1736149297799837",
			["startPort"] = "StoryStart",
			["endStory"] = "1736149301902980",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1736149301902980",
			["startPort"] = "Success",
			["endStory"] = "1736149297799840",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1736149297799837"] = {
			["isStoryNode"] = true,
			["key"] = "1736149297799837",
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
		["1736149297799840"] = {
			["isStoryNode"] = true,
			["key"] = "1736149297799840",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1634.3803056027164,
				["y"] = 296.02716468590836
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1736149301902980"] = {
			["isStoryNode"] = true,
			["key"] = "1736149301902980",
			["type"] = "StoryNode",
			["name"] = "买花",
			["pos"] = {
				["x"] = 1202.5263157894738,
				["y"] = 287.05263157894734
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_IcelakeBuyFlower_Des",
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
						["startQuest"] = "1736149301902981",
						["startPort"] = "QuestStart",
						["endQuest"] = "17361493830831603",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361493830831603",
						["startPort"] = "Out",
						["endQuest"] = "17361494124551805",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361493830831603",
						["startPort"] = "Out",
						["endQuest"] = "17361495322822663",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361495322822663",
						["startPort"] = "Out",
						["endQuest"] = "17361495496112997",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361495322822663",
						["startPort"] = "Out",
						["endQuest"] = "17361495563663188",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361495496112997",
						["startPort"] = "Out",
						["endQuest"] = "17361495665373451",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17361495563663188",
						["startPort"] = "Out",
						["endQuest"] = "17361495665373451",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17361495665373451",
						["startPort"] = "Out",
						["endQuest"] = "17361494209071982",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361494209071982",
						["startPort"] = "Option_1",
						["endQuest"] = "17361496084264314",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361494209071982",
						["startPort"] = "Option_2",
						["endQuest"] = "17361496134204460",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361496084264314",
						["startPort"] = "Out",
						["endQuest"] = "17361496218864722",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361496134204460",
						["startPort"] = "Out",
						["endQuest"] = "17361496276484890",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361496218864722",
						["startPort"] = "Out",
						["endQuest"] = "1736149301902984",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17361496276484890",
						["startPort"] = "Out",
						["endQuest"] = "1736149301902984",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17361495322822663",
						["startPort"] = "Out",
						["endQuest"] = "17361520142521408411",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361495665373451",
						["startPort"] = "Out",
						["endQuest"] = "176189422003523147451",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17361495322822663",
						["startPort"] = "Out",
						["endQuest"] = "176189423953923147973",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1736149301902981"] = {
						["key"] = "1736149301902981",
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
					["1736149301902984"] = {
						["key"] = "1736149301902984",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3752.5252525252527,
							["y"] = 276.7676767676768
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1736149301902987"] = {
						["key"] = "1736149301902987",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3323.6363636363635,
							["y"] = 724.5454545454545
						},
						["propsData"] = {}
					},
					["17361493830831603"] = {
						["key"] = "17361493830831603",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成小孩npc",
						["pos"] = {
							["x"] = 1114.1024844720498,
							["y"] = 299.751552795031
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190989
							}
						}
					},
					["17361494124551805"] = {
						["key"] = "17361494124551805",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1505.1739130434785,
							["y"] = 75.8229813664596
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71005201,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17361494209071982"] = {
						["key"] = "17361494209071982",
						["type"] = "TalkNode",
						["name"] = "买花",
						["pos"] = {
							["x"] = 2714.9610703306353,
							["y"] = 234.3691574126358
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818046,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1190989",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71005214,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {
								{
									["OptionText"] = "710052141",
									["OverrideBlend"] = true,
									["OverrideOutype"] = "BlendOut",
									["OverrideOutTime"] = -1
								},
								{
									["OptionText"] = "710052142",
									["OverrideBlend"] = true,
									["OverrideOutype"] = "BlendOut",
									["OverrideOutTime"] = -1
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["17361495322822663"] = {
						["key"] = "17361495322822663",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1505.1739130434783,
							["y"] = 284.75155279503116
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818046,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1190989",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71005202,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17361495496112997"] = {
						["key"] = "17361495496112997",
						["type"] = "TalkNode",
						["name"] = "乞讨者",
						["pos"] = {
							["x"] = 1949.8167701863356,
							["y"] = 110.1086956521739
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818047,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1190990",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71005206,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17361495563663188"] = {
						["key"] = "17361495563663188",
						["type"] = "TalkNode",
						["name"] = "小男孩",
						["pos"] = {
							["x"] = 1953.0310559006214,
							["y"] = 417.96583850931677
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818048,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1190991",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71005209,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17361495665373451"] = {
						["key"] = "17361495665373451",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2405.173913043478,
							["y"] = 246.18012422360255
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17361496084264314"] = {
						["key"] = "17361496084264314",
						["type"] = "TalkNode",
						["name"] = "信任",
						["pos"] = {
							["x"] = 3037.4450718363764,
							["y"] = 187.84318338666162
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71005215,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = -1,
							["BlendOutTime"] = 2,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17361496134204460"] = {
						["key"] = "17361496134204460",
						["type"] = "TalkNode",
						["name"] = "不信任",
						["pos"] = {
							["x"] = 3068.5561829474873,
							["y"] = 441.17651671999505
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71005216,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = -1,
							["BlendOutTime"] = 2,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17361496218864722"] = {
						["key"] = "17361496218864722",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3383.0006273919316,
							["y"] = 183.39873894221722
						},
						["propsData"] = {
							["DialogueId"] = 71005215,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17361496276484890"] = {
						["key"] = "17361496276484890",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3372.722849614154,
							["y"] = 431.4542944977728
						},
						["propsData"] = {
							["DialogueId"] = 71005216,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17361520142521408411"] = {
						["key"] = "17361520142521408411",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/Npc",
						["pos"] = {
							["x"] = 1942.8022146935195,
							["y"] = 707.0098500533284
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190990,
								1190991,
								291192061
							}
						}
					},
					["176189422003523147451"] = {
						["key"] = "176189422003523147451",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2794.25,
							["y"] = -30.5
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_IcelakeBuyFlower_Target1",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176189423953923147973"] = {
						["key"] = "176189423953923147973",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1955.2499999999998,
							["y"] = -100.25000000000006
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_IcelakeBuyFlower_Target2",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}