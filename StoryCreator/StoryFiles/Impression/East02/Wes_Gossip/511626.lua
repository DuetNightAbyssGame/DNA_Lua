return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177259320430743494330",
			["startPort"] = "StoryStart",
			["endStory"] = "177259320430743494332",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177259320430743494332",
			["startPort"] = "Success",
			["endStory"] = "177259320430743494331",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177259320430743494330"] = {
			["isStoryNode"] = true,
			["key"] = "177259320430743494330",
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
		["177259320430743494331"] = {
			["isStoryNode"] = true,
			["key"] = "177259320430743494331",
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
		["177259320430743494332"] = {
			["isStoryNode"] = true,
			["key"] = "177259320430743494332",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1224.6140648567118,
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
						["startQuest"] = "177259320430743494337",
						["startPort"] = "false",
						["endQuest"] = "177259320430743494336",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177259320430743494336",
						["startPort"] = "Out",
						["endQuest"] = "177259320430743494338",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177259320430743494337",
						["startPort"] = "true",
						["endQuest"] = "177259320430743494339",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177259320430743494333",
						["startPort"] = "QuestStart",
						["endQuest"] = "177259320430743494337",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177259320430743494339",
						["startPort"] = "Out",
						["endQuest"] = "177259320430743494334",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177259320430743494338",
						["startPort"] = "Out",
						["endQuest"] = "177259320430743494334",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177259320430743494333"] = {
						["key"] = "177259320430743494333",
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
					["177259320430743494334"] = {
						["key"] = "177259320430743494334",
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
					["177259320430743494335"] = {
						["key"] = "177259320430743494335",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1973.2,
							["y"] = 557.6000000000001
						},
						["propsData"] = {}
					},
					["177259320430743494336"] = {
						["key"] = "177259320430743494336",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1179.022299995513,
							["y"] = 45.774879974873215
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51162632,
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["177259320430743494337"] = {
						["key"] = "177259320430743494337",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 787.0881062951496,
							["y"] = -191.8613261093911
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511626",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["177259320430743494338"] = {
						["key"] = "177259320430743494338",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1572.9118937048504,
							["y"] = 59.48980908152737
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511626",
							["VarValue"] = 2
						}
					},
					["177259320430743494339"] = {
						["key"] = "177259320430743494339",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1272.3230134158925,
							["y"] = -297.4898090815275
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51162606,
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
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