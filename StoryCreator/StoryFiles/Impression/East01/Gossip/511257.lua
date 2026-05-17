return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1761827815091419805",
			["startPort"] = "StoryStart",
			["endStory"] = "1761827815091419807",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1761827815091419807",
			["startPort"] = "Success",
			["endStory"] = "1761827815091419806",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1761827815091419805"] = {
			["isStoryNode"] = true,
			["key"] = "1761827815091419805",
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
		["1761827815091419806"] = {
			["isStoryNode"] = true,
			["key"] = "1761827815091419806",
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
		["1761827815091419807"] = {
			["isStoryNode"] = true,
			["key"] = "1761827815091419807",
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
						["startQuest"] = "1761827815091419808",
						["startPort"] = "QuestStart",
						["endQuest"] = "17628471138232003626",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628471138232003626",
						["startPort"] = "false",
						["endQuest"] = "1761827815091419811",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1761827815091419811",
						["startPort"] = "Out",
						["endQuest"] = "17628472678612005427",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628472678612005427",
						["startPort"] = "Out",
						["endQuest"] = "1761827815091419809",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17628471138232003626",
						["startPort"] = "true",
						["endQuest"] = "17628473776722007223",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628473776722007223",
						["startPort"] = "Out",
						["endQuest"] = "1761827815091419809",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1761827815091419808"] = {
						["key"] = "1761827815091419808",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 169.69230769230774,
							["y"] = 357.38461538461536
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1761827815091419809"] = {
						["key"] = "1761827815091419809",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1883.610294117647,
							["y"] = 170.10294117647058
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1761827815091419810"] = {
						["key"] = "1761827815091419810",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2130.1485294117647,
							["y"] = 779.2911764705884
						},
						["propsData"] = {}
					},
					["1761827815091419811"] = {
						["key"] = "1761827815091419811",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1034.5591937003635,
							["y"] = 431.1362060842643
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 51125701,
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
					["17628471138232003626"] = {
						["key"] = "17628471138232003626",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 635.125,
							["y"] = 207.5
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511257",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["17628472678612005427"] = {
						["key"] = "17628472678612005427",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1420.9487874097008,
							["y"] = 458.85113519091846
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511257",
							["VarValue"] = 2
						}
					},
					["17628473776722007223"] = {
						["key"] = "17628473776722007223",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1120.359907120743,
							["y"] = 99.87151702786362
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 51125704,
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