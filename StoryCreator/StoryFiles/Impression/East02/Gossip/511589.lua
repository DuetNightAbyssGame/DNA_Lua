return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177211013413747797460",
			["startPort"] = "StoryStart",
			["endStory"] = "177211013413747797462",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177211013413747797462",
			["startPort"] = "Success",
			["endStory"] = "177211013413747797461",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177211013413747797460"] = {
			["isStoryNode"] = true,
			["key"] = "177211013413747797460",
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
		["177211013413747797461"] = {
			["isStoryNode"] = true,
			["key"] = "177211013413747797461",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1659.857142857143,
				["y"] = 180.14285714285714
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["177211013413747797462"] = {
			["isStoryNode"] = true,
			["key"] = "177211013413747797462",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1226.6140648567118,
				["y"] = 279.62727223756656
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "177211013413747797467",
						["startPort"] = "false",
						["endQuest"] = "177211013413747797466",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177211013413747797467",
						["startPort"] = "true",
						["endQuest"] = "177211013413747797469",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177211013413747797463",
						["startPort"] = "QuestStart",
						["endQuest"] = "177211013413747797467",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177211013413747797468",
						["startPort"] = "Out",
						["endQuest"] = "177211013413747797464",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177211013413747797466",
						["startPort"] = "Option_2",
						["endQuest"] = "177211013413747797468",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177211013413747797466",
						["startPort"] = "Option_1",
						["endQuest"] = "17721969815242226",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17721969815242226",
						["startPort"] = "Out",
						["endQuest"] = "177211013413747797468",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177211013413747797469",
						["startPort"] = "Option_1",
						["endQuest"] = "17722470897011004",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17722470897011004",
						["startPort"] = "Out",
						["endQuest"] = "177211013413747797464",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177211013413747797469",
						["startPort"] = "Option_2",
						["endQuest"] = "177211013413747797464",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177211013413747797463"] = {
						["key"] = "177211013413747797463",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 319.69230769230774,
							["y"] = -198.61538461538464
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177211013413747797464"] = {
						["key"] = "177211013413747797464",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2084,
							["y"] = -194
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177211013413747797465"] = {
						["key"] = "177211013413747797465",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1973.2,
							["y"] = 557.6000000000001
						},
						["propsData"] = {}
					},
					["177211013413747797466"] = {
						["key"] = "177211013413747797466",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1061.022299995513,
							["y"] = 75.77487997487322
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51158918,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"",
								""
							},
							["OverrideFailBlend"] = false
						}
					},
					["177211013413747797467"] = {
						["key"] = "177211013413747797467",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 787.0881062951496,
							["y"] = -191.8613261093911
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511589",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["177211013413747797468"] = {
						["key"] = "177211013413747797468",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1836.8349706279273,
							["y"] = 81.54109113280941
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511589",
							["VarValue"] = 2
						}
					},
					["177211013413747797469"] = {
						["key"] = "177211013413747797469",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1236.3230134158925,
							["y"] = -711.4898090815275
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51158911,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"",
								""
							},
							["OverrideFailBlend"] = false
						}
					},
					["17721969815242226"] = {
						["key"] = "17721969815242226",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1399.1153846153843,
							["y"] = -7.833333333333272
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "show_liufu_chuansong",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17722470897011004"] = {
						["key"] = "17722470897011004",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1682,
							["y"] = -814
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "show_liufu_chuansong",
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
		}
	},
	["commentData"] = {}
}