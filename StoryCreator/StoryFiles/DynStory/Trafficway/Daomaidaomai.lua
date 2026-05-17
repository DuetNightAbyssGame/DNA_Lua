return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17216306425401",
			["startPort"] = "StoryStart",
			["endStory"] = "17217269355792905",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17217269355792905",
			["startPort"] = "Success",
			["endStory"] = "17216306425405",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17216306425401"] = {
			["isStoryNode"] = true,
			["key"] = "17216306425401",
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
		["17216306425405"] = {
			["isStoryNode"] = true,
			["key"] = "17216306425405",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1656.6071114240447,
				["y"] = 260.4919908466819
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17217269355792905"] = {
			["isStoryNode"] = true,
			["key"] = "17217269355792905",
			["type"] = "StoryNode",
			["name"] = "本地商人开启对话",
			["pos"] = {
				["x"] = 1178.8838616189303,
				["y"] = 275.64358010410626
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_TrafficwayDaomaidaomai_Des",
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
						["startQuest"] = "17388976599751100",
						["startPort"] = "Out",
						["endQuest"] = "17388976599761101",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599771107",
						["startPort"] = "Out",
						["endQuest"] = "17388976599761103",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599771108",
						["startPort"] = "Out",
						["endQuest"] = "17388976599771105",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599751098",
						["startPort"] = "Out",
						["endQuest"] = "17388976599751100",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599751098",
						["startPort"] = "Out",
						["endQuest"] = "17388976599771111",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599771111",
						["startPort"] = "Out",
						["endQuest"] = "17388976599761102",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599761101",
						["startPort"] = "Out",
						["endQuest"] = "17388976599761103",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599761101",
						["startPort"] = "Out",
						["endQuest"] = "17388976599771105",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599771104",
						["startPort"] = "Out",
						["endQuest"] = "17217269355792909",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17388976599771106",
						["startPort"] = "Out",
						["endQuest"] = "17217269355792909",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17217269355792906",
						["startPort"] = "QuestStart",
						["endQuest"] = "17388976599751098",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17217269355792906",
						["startPort"] = "QuestStart",
						["endQuest"] = "17388976599751099",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599761103",
						["startPort"] = "Option_2",
						["endQuest"] = "17388976599771107",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599761103",
						["startPort"] = "Option_1",
						["endQuest"] = "17388976599771104",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599771105",
						["startPort"] = "Option_1",
						["endQuest"] = "17388976599771106",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599771105",
						["startPort"] = "Option_2",
						["endQuest"] = "17388976599771108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388976599761101",
						["startPort"] = "Out",
						["endQuest"] = "17618919155556123421",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17217269355792906"] = {
						["key"] = "17217269355792906",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 801.7647058823529,
							["y"] = 188.8235294117647
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17217269355792909"] = {
						["key"] = "17217269355792909",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3934.5607287449393,
							["y"] = 18.827935222672068
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17217269355792912"] = {
						["key"] = "17217269355792912",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2787,
							["y"] = 1386.5
						},
						["propsData"] = {}
					},
					["17388976599751098"] = {
						["key"] = "17388976599751098",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成商人",
						["pos"] = {
							["x"] = 1292.8370277404479,
							["y"] = 194.106554754155
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180416,
								1180413
							}
						}
					},
					["17388976599751099"] = {
						["key"] = "17388976599751099",
						["type"] = "TalkNode",
						["name"] = "旁白开车对话",
						["pos"] = {
							["x"] = 1287.5636628203433,
							["y"] = 14.822366719966794
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71001401,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17388976599751100"] = {
						["key"] = "17388976599751100",
						["type"] = "PickUpNode",
						["name"] = "采集交互",
						["pos"] = {
							["x"] = 1680.246205132581,
							["y"] = 339.4234774629206
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1180417,
								1180418,
								1180419
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80013,
							["UnitCount"] = 3,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17388976599761101"] = {
						["key"] = "17388976599761101",
						["type"] = "TalkNode",
						["name"] = "采集完成开车对话",
						["pos"] = {
							["x"] = 2046.067275366695,
							["y"] = 318.60835297388303
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71001403,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17388976599761102"] = {
						["key"] = "17388976599761102",
						["type"] = "TalkNode",
						["name"] = "采集对话",
						["pos"] = {
							["x"] = 2045.0320207027212,
							["y"] = 125.31326931993237
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71001402,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17388976599761103"] = {
						["key"] = "17388976599761103",
						["type"] = "TalkNode",
						["name"] = "和本地商人对话",
						["pos"] = {
							["x"] = 2647.544985305854,
							["y"] = 33.41582448816985
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818002,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1180416",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71001404,
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
							["OverrideFailBlend"] = false
						}
					},
					["17388976599771104"] = {
						["key"] = "17388976599771104",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3399.659634644395,
							["y"] = 23.435881610649403
						},
						["propsData"] = {
							["DialogueId"] = 71001406,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17388976599771105"] = {
						["key"] = "17388976599771105",
						["type"] = "TalkNode",
						["name"] = "和外地商人交流",
						["pos"] = {
							["x"] = 2664.313436649311,
							["y"] = 349.03542434070437
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818003,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1180413",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71001405,
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
							["OverrideFailBlend"] = false
						}
					},
					["17388976599771106"] = {
						["key"] = "17388976599771106",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3401.4363371796567,
							["y"] = 350.3152250099449
						},
						["propsData"] = {
							["DialogueId"] = 71001407,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17388976599771107"] = {
						["key"] = "17388976599771107",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2649.058864293314,
							["y"] = 228.48214285714266
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					},
					["17388976599771108"] = {
						["key"] = "17388976599771108",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2678.969578579028,
							["y"] = 549.375
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					},
					["17388976599771111"] = {
						["key"] = "17388976599771111",
						["type"] = "PickUpNode",
						["name"] = "与物品1进行交互",
						["pos"] = {
							["x"] = 1697.1603933713914,
							["y"] = 150.365325077399
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 80013,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17618919155556123421"] = {
						["key"] = "17618919155556123421",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2382,
							["y"] = -77
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_TrafficwayDaomaidaomai_Target1",
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