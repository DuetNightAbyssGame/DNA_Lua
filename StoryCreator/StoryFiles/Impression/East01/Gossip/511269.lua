return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1761827815096421391",
			["startPort"] = "StoryStart",
			["endStory"] = "1761827815096421393",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1761827815096421393",
			["startPort"] = "Success",
			["endStory"] = "1761827815096421392",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1761827815096421391"] = {
			["isStoryNode"] = true,
			["key"] = "1761827815096421391",
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
		["1761827815096421392"] = {
			["isStoryNode"] = true,
			["key"] = "1761827815096421392",
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
		["1761827815096421393"] = {
			["isStoryNode"] = true,
			["key"] = "1761827815096421393",
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
						["startQuest"] = "1761827815096421397",
						["startPort"] = "Fail",
						["endQuest"] = "1761827815096421396",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17628482920734673626",
						["startPort"] = "false",
						["endQuest"] = "17628482920734673625",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628482920734673625",
						["startPort"] = "Out",
						["endQuest"] = "17628482920734673627",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628482920734673626",
						["startPort"] = "true",
						["endQuest"] = "17628482920734673628",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1761827815096421394",
						["startPort"] = "QuestStart",
						["endQuest"] = "17628482920734673626",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628482920734673628",
						["startPort"] = "Out",
						["endQuest"] = "1761827815096421395",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17628482920734673627",
						["startPort"] = "Out",
						["endQuest"] = "1761827815096421395",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1761827815096421394"] = {
						["key"] = "1761827815096421394",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 485.69230769230774,
							["y"] = -358.61538461538464
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1761827815096421395"] = {
						["key"] = "1761827815096421395",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2112,
							["y"] = -372
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1761827815096421396"] = {
						["key"] = "1761827815096421396",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1973.2,
							["y"] = 557.6000000000001
						},
						["propsData"] = {}
					},
					["1761827815096421397"] = {
						["key"] = "1761827815096421397",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1304.0077231121281,
							["y"] = 393.41561784897016
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51126901,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
					["17628482920734673625"] = {
						["key"] = "17628482920734673625",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1399.522299995513,
							["y"] = -102.22512002512673
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51126901,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
					["17628482920734673626"] = {
						["key"] = "17628482920734673626",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 986.0881062951496,
							["y"] = -359.86132610939103
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511269",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["17628482920734673627"] = {
						["key"] = "17628482920734673627",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1773.9118937048504,
							["y"] = -108.51019091847257
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511269",
							["VarValue"] = 2
						}
					},
					["17628482920734673628"] = {
						["key"] = "17628482920734673628",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1659.3230134158925,
							["y"] = -511.4898090815274
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51126909,
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