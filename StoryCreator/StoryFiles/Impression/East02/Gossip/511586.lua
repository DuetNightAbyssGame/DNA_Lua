return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177210790842543899393",
			["startPort"] = "StoryStart",
			["endStory"] = "177210790842543899395",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177210790842543899395",
			["startPort"] = "Success",
			["endStory"] = "177210790842543899394",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177210790842543899393"] = {
			["isStoryNode"] = true,
			["key"] = "177210790842543899393",
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
		["177210790842543899394"] = {
			["isStoryNode"] = true,
			["key"] = "177210790842543899394",
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
		["177210790842543899395"] = {
			["isStoryNode"] = true,
			["key"] = "177210790842543899395",
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
						["startQuest"] = "177210790842543899400",
						["startPort"] = "false",
						["endQuest"] = "177210790842543899399",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177210790842543899399",
						["startPort"] = "Out",
						["endQuest"] = "177210790842543899401",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177210790842543899400",
						["startPort"] = "true",
						["endQuest"] = "177210790842543899402",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177210790842543899396",
						["startPort"] = "QuestStart",
						["endQuest"] = "177210790842543899400",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177210790842543899402",
						["startPort"] = "Out",
						["endQuest"] = "177210790842543899397",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177210790842543899401",
						["startPort"] = "Out",
						["endQuest"] = "177210790842543899397",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177210790842543899396"] = {
						["key"] = "177210790842543899396",
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
					["177210790842543899397"] = {
						["key"] = "177210790842543899397",
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
					["177210790842543899398"] = {
						["key"] = "177210790842543899398",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1973.2,
							["y"] = 557.6000000000001
						},
						["propsData"] = {}
					},
					["177210790842543899399"] = {
						["key"] = "177210790842543899399",
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
							["FirstDialogueId"] = 51158616,
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
					["177210790842543899400"] = {
						["key"] = "177210790842543899400",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 787.0881062951496,
							["y"] = -191.8613261093911
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511586",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["177210790842543899401"] = {
						["key"] = "177210790842543899401",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1574.9118937048504,
							["y"] = 59.48980908152737
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511586",
							["VarValue"] = 2
						}
					},
					["177210790842543899402"] = {
						["key"] = "177210790842543899402",
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
							["FirstDialogueId"] = 51158606,
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