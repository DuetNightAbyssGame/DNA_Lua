return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17647517573931",
			["startPort"] = "StoryStart",
			["endStory"] = "1764751888773695939",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1764751888773695939",
			["startPort"] = "Success",
			["endStory"] = "17647517573945",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17647517573931"] = {
			["isStoryNode"] = true,
			["key"] = "17647517573931",
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
		["17647517573945"] = {
			["isStoryNode"] = true,
			["key"] = "17647517573945",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1448,
				["y"] = 290.9655172413793
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1764751888773695939"] = {
			["isStoryNode"] = true,
			["key"] = "1764751888773695939",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1126.9655172413793,
				["y"] = 283.53694581280786
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
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
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {
					104503
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203060401_132010086",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1764751888773695940",
						["startPort"] = "QuestStart",
						["endQuest"] = "1764751921075696879",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764751921075696879",
						["startPort"] = "Out",
						["endQuest"] = "17647526620171392373",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17647534059451393629",
						["startPort"] = "Out",
						["endQuest"] = "17647535734171394073",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764751888773695940",
						["startPort"] = "QuestStart",
						["endQuest"] = "176649422180914859545",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176649422180914859545",
						["startPort"] = "Out",
						["endQuest"] = "1764751888773695946",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1764751921075696879",
						["startPort"] = "Out",
						["endQuest"] = "17647534059451393629",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17647535734171394073",
						["startPort"] = "Out",
						["endQuest"] = "17665686141678126697",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17665686141678126697",
						["startPort"] = "Out",
						["endQuest"] = "176649340228713444054",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764751888773695940",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671672417933416",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17677746636766835",
						["startPort"] = "Out",
						["endQuest"] = "176649419213614858941",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176649340228713444054",
						["startPort"] = "Out",
						["endQuest"] = "17665686451958127284",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764751888773695940",
						["startPort"] = "QuestStart",
						["endQuest"] = "177010843806912217366",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "176649340228713444054",
						["startPort"] = "Out",
						["endQuest"] = "177217611428517631330",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177217611428517631330",
						["startPort"] = "Out",
						["endQuest"] = "17677746636766835",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177217611428517631330",
						["startPort"] = "Out",
						["endQuest"] = "17720012533012320028",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1764751888773695940"] = {
						["key"] = "1764751888773695940",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1001.923076923077,
							["y"] = 294.2307692307692
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1764751888773695943"] = {
						["key"] = "1764751888773695943",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2602.6666666666665,
							["y"] = 320.19047619047615
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1764751888773695946"] = {
						["key"] = "1764751888773695946",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1481.377450980392,
							["y"] = 687.4950980392157
						},
						["propsData"] = {}
					},
					["1764751921075696879"] = {
						["key"] = "1764751921075696879",
						["type"] = "ChangeRoleNode",
						["name"] = "切换苏乙",
						["pos"] = {
							["x"] = 1399.2054758522142,
							["y"] = 296.89698902037424
						},
						["propsData"] = {
							["QuestRoleId"] = 15040102,
							["IsPlayFX"] = false
						}
					},
					["17647526620171392373"] = {
						["key"] = "17647526620171392373",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1720.8865000698033,
							["y"] = 73.39006003071336
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12062820,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17647534059451393629"] = {
						["key"] = "17647534059451393629",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1720.1902224396501,
							["y"] = 270.74469663314045
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132010086,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203060401_132010086"
						}
					},
					["17647535734171394073"] = {
						["key"] = "17647535734171394073",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2045.1032627625582,
							["y"] = 274.063134074339
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062901.12062901'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030602",
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
					["176649340228713444054"] = {
						["key"] = "176649340228713444054",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1716.186442079032,
							["y"] = 471.30627405864635
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250017,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030703Xiaoan_132420056",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 12063001,
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
					["176649419213614858941"] = {
						["key"] = "176649419213614858941",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2714.6501976284585,
							["y"] = 463.72727272727275
						},
						["propsData"] = {}
					},
					["176649422180914859545"] = {
						["key"] = "176649422180914859545",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1209.654751131222,
							["y"] = 671.785294117647
						},
						["propsData"] = {}
					},
					["17665686141678126697"] = {
						["key"] = "17665686141678126697",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2305.4785469107555,
							["y"] = 277.29061784897016
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132420056
							}
						}
					},
					["17665686451958127284"] = {
						["key"] = "17665686451958127284",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2037.4736061992933,
							["y"] = 698.901289785729
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132420056
							}
						}
					},
					["17671672417933416"] = {
						["key"] = "17671672417933416",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1400.9458587896215,
							["y"] = 109.83972278566587
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_1203070302",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17677746636766835"] = {
						["key"] = "17677746636766835",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2399.9029020178905,
							["y"] = 471.4593450028232
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12063101.12063101'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030701",
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
					["17677746994967363"] = {
						["key"] = "17677746994967363",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2669.8386727688785,
							["y"] = 671.1777244494637
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132420061,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203070301_132420061"
						}
					},
					["177010843806912217366"] = {
						["key"] = "177010843806912217366",
						["type"] = "StandAloneBlackScreenNode",
						["name"] = "独立黑屏节点",
						["pos"] = {
							["x"] = 1400.711274273394,
							["y"] = -65.09545170853474
						},
						["propsData"] = {
							["FadeInSeconds"] = 0,
							["FadeOutSeconds"] = 0,
							["DurationSeconds"] = 1,
							["IsStandAlone"] = true
						}
					},
					["17720012533012320028"] = {
						["key"] = "17720012533012320028",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2403.7193295210536,
							["y"] = 664.5718663520387
						},
						["propsData"] = {
							["VarName"] = "FengxiangBoss",
							["VarValue"] = 0
						}
					},
					["177217611428517631330"] = {
						["key"] = "177217611428517631330",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2021.3646379627528,
							["y"] = 475.801948051948
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC002/Ver0103_SC002",
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
							["HideMechanismsFX"] = false,
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}