return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "172415184581355961",
			["startPort"] = "StoryStart",
			["endStory"] = "172415187538156206",
			["endPort"] = "In"
		},
		{
			["startStory"] = "172415187538156206",
			["startPort"] = "Success",
			["endStory"] = "172415184581355964",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["172415184581355961"] = {
			["isStoryNode"] = true,
			["key"] = "172415184581355961",
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
		["172415184581355964"] = {
			["isStoryNode"] = true,
			["key"] = "172415184581355964",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1442.5000000000066,
				["y"] = 296.25
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["172415187538156206"] = {
			["isStoryNode"] = true,
			["key"] = "172415187538156206",
			["type"] = "StoryNode",
			["name"] = "调整电梯",
			["pos"] = {
				["x"] = 1115.3411191119078,
				["y"] = 294.29405374925716
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_TrafficElevator_Des",
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
						["startQuest"] = "172415187538156207",
						["startPort"] = "QuestStart",
						["endQuest"] = "172415203295057256",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172415187538156207",
						["startPort"] = "QuestStart",
						["endQuest"] = "172415205349357723",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172415205349357723",
						["startPort"] = "Out",
						["endQuest"] = "172415208014258112",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172415208014258112",
						["startPort"] = "Option_2",
						["endQuest"] = "17255127708575675",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172415208014258112",
						["startPort"] = "Option_1",
						["endQuest"] = "17255128547857769",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17255128547857769",
						["startPort"] = "Out",
						["endQuest"] = "17255124122003758",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172551304133810406",
						["startPort"] = "Out",
						["endQuest"] = "172551306049710698",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172551303112910139",
						["startPort"] = "Out",
						["endQuest"] = "172551306413010881",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172551306049710698",
						["startPort"] = "Out",
						["endQuest"] = "172415187538156210",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "172551306413010881",
						["startPort"] = "Out",
						["endQuest"] = "172415187538156210",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "172415208014258112",
						["startPort"] = "Option_1",
						["endQuest"] = "1725536300645165605",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17255124122003758",
						["startPort"] = "Out",
						["endQuest"] = "1725536300645165605",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "1725536300645165605",
						["startPort"] = "TimerRange_2",
						["endQuest"] = "172551303112910139",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1725536300645165605",
						["startPort"] = "TimerRange_1",
						["endQuest"] = "172551304133810406",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172415208014258112",
						["startPort"] = "Option_1",
						["endQuest"] = "17255129038748707",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1725536300645165605",
						["startPort"] = "TimerRange_1",
						["endQuest"] = "176189249205010207682",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1725536300645165605",
						["startPort"] = "TimerRange_2",
						["endQuest"] = "176189249205010207682",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["172415187538156207"] = {
						["key"] = "172415187538156207",
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
					["172415187538156210"] = {
						["key"] = "172415187538156210",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4285.49773755656,
							["y"] = -49.15966386554618
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172415187538156213"] = {
						["key"] = "172415187538156213",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["172415203295057256"] = {
						["key"] = "172415203295057256",
						["type"] = "TalkNode",
						["name"] = "NPC开车对话",
						["pos"] = {
							["x"] = 1134.0629166126544,
							["y"] = 74.89223188690929
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71001901,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["172415205349357723"] = {
						["key"] = "172415205349357723",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成电梯质检员NPC",
						["pos"] = {
							["x"] = 1149.6629166126545,
							["y"] = 296.89223188690903
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180509
							}
						}
					},
					["172415208014258112"] = {
						["key"] = "172415208014258112",
						["type"] = "TalkNode",
						["name"] = "NPC交互对话",
						["pos"] = {
							["x"] = 1445.612916612654,
							["y"] = 253.29223188690884
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818016,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1180509",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71001902,
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
									["OptionText"] = "710019021",
									["OverrideBlend"] = true,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 2
								},
								{
									["OptionText"] = "710019022",
									["OverrideBlend"] = true,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 2
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["17255124122003758"] = {
						["key"] = "17255124122003758",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2061.944989198273,
							["y"] = 273.8651931691544
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1180511,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_DynTrigger_1180511"
						}
					},
					["17255127708575675"] = {
						["key"] = "17255127708575675",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 1990.6360239699538,
							["y"] = 594.3780200007666
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["17255128547857769"] = {
						["key"] = "17255128547857769",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁npc",
						["pos"] = {
							["x"] = 1794.3315623025896,
							["y"] = 267.97615573599904
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180509
							}
						}
					},
					["17255129038748707"] = {
						["key"] = "17255129038748707",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成底部npc",
						["pos"] = {
							["x"] = 1790.256886977913,
							["y"] = 70.39748440732765
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180510
							}
						}
					},
					["172551303112910139"] = {
						["key"] = "172551303112910139",
						["type"] = "TalkNode",
						["name"] = "与npc对话",
						["pos"] = {
							["x"] = 3043.7902014894894,
							["y"] = 88.90006877947724
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818016,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1180510",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71001904,
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
					["172551304133810406"] = {
						["key"] = "172551304133810406",
						["type"] = "TalkNode",
						["name"] = "与npc对话奖励",
						["pos"] = {
							["x"] = 3041.852302432025,
							["y"] = -41.50164906789283
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818016,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1180510",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71001903,
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
					["172551306049710698"] = {
						["key"] = "172551306049710698",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3463.7570281410985,
							["y"] = -17.069016483086266
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["172551306413010881"] = {
						["key"] = "172551306413010881",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3466.885910128676,
							["y"] = 120.51779887546816
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["1725536300645165605"] = {
						["key"] = "1725536300645165605",
						["type"] = "TimerBranchNode",
						["name"] = "计时器",
						["pos"] = {
							["x"] = 2381.8461538461543,
							["y"] = 38.7692307692307
						},
						["propsData"] = {
							["TimerRange"] = {
								{
									["StartTime"] = 0,
									["EndTime"] = 15
								},
								{
									["StartTime"] = 15,
									["EndTime"] = -1
								}
							}
						}
					},
					["176189249205010207682"] = {
						["key"] = "176189249205010207682",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3042.264492753623,
							["y"] = -195.73369565217396
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_TrafficElevator_Target1",
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