return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177260677331860635510",
			["startPort"] = "StoryStart",
			["endStory"] = "177260677331860635512",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177260677331860635512",
			["startPort"] = "Success",
			["endStory"] = "177260677331860635511",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177260677331860635510"] = {
			["isStoryNode"] = true,
			["key"] = "177260677331860635510",
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
		["177260677331860635511"] = {
			["isStoryNode"] = true,
			["key"] = "177260677331860635511",
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
		["177260677331860635512"] = {
			["isStoryNode"] = true,
			["key"] = "177260677331860635512",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1226.6140648567118,
				["y"] = 277.62727223756656
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
						["startQuest"] = "177260677331860635517",
						["startPort"] = "false",
						["endQuest"] = "177260677331860635516",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177260677331860635517",
						["startPort"] = "true",
						["endQuest"] = "177260677331860635519",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177260677331860635513",
						["startPort"] = "QuestStart",
						["endQuest"] = "177260677331860635517",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177260677331860635519",
						["startPort"] = "Out",
						["endQuest"] = "177260677331860635514",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177260677331860635516",
						["startPort"] = "Out",
						["endQuest"] = "177260677331860635518",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177260677331860635518",
						["startPort"] = "Out",
						["endQuest"] = "177305798326390351647",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177305798326390351647",
						["startPort"] = "Out",
						["endQuest"] = "177260677331860635514",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177260677331860635513"] = {
						["key"] = "177260677331860635513",
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
					["177260677331860635514"] = {
						["key"] = "177260677331860635514",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2150.4285714285716,
							["y"] = -16.14285714285716
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177260677331860635515"] = {
						["key"] = "177260677331860635515",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1973.2,
							["y"] = 557.6000000000001
						},
						["propsData"] = {}
					},
					["177260677331860635516"] = {
						["key"] = "177260677331860635516",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1179.022299995513,
							["y"] = 45.91773711773036
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 51171701,
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
					["177260677331860635517"] = {
						["key"] = "177260677331860635517",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 787.0881062951496,
							["y"] = -191.8613261093911
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511717",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["177260677331860635518"] = {
						["key"] = "177260677331860635518",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1571.483322276279,
							["y"] = 82.06123765295592
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511717",
							["VarValue"] = 2
						}
					},
					["177260677331860635519"] = {
						["key"] = "177260677331860635519",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1272.3230134158925,
							["y"] = -299.4898090815275
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51171707,
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
					["177305798326390351647"] = {
						["key"] = "177305798326390351647",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 1848,
							["y"] = 78
						},
						["propsData"] = {
							["IsHide"] = true,
							["AtmosphereTagList"] = {
								"show_511717"
							}
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}