return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1773064572773106802993",
			["startPort"] = "StoryStart",
			["endStory"] = "1773064572773106802995",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1773064572773106802995",
			["startPort"] = "Success",
			["endStory"] = "1773064572773106802994",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1773064572773106802993"] = {
			["isStoryNode"] = true,
			["key"] = "1773064572773106802993",
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
		["1773064572773106802994"] = {
			["isStoryNode"] = true,
			["key"] = "1773064572773106802994",
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
		["1773064572773106802995"] = {
			["isStoryNode"] = true,
			["key"] = "1773064572773106802995",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1224.6140648567118,
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
						["startQuest"] = "1773064572773106803000",
						["startPort"] = "false",
						["endQuest"] = "1773064572773106802999",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773064572773106803000",
						["startPort"] = "true",
						["endQuest"] = "1773064572773106803002",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773064572773106802996",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773064572773106803000",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773064572773106803002",
						["startPort"] = "Out",
						["endQuest"] = "1773064572773106802997",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1773064572773106802999",
						["startPort"] = "Out",
						["endQuest"] = "1773064572773106803001",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773064572773106803001",
						["startPort"] = "Out",
						["endQuest"] = "1773064572773106803003",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773064572773106803003",
						["startPort"] = "Out",
						["endQuest"] = "1773064572773106802997",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1773064572773106802996"] = {
						["key"] = "1773064572773106802996",
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
					["1773064572773106802997"] = {
						["key"] = "1773064572773106802997",
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
					["1773064572773106802998"] = {
						["key"] = "1773064572773106802998",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1973.2,
							["y"] = 557.6000000000001
						},
						["propsData"] = {}
					},
					["1773064572773106802999"] = {
						["key"] = "1773064572773106802999",
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
							["FirstDialogueId"] = 51175001,
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
					["1773064572773106803000"] = {
						["key"] = "1773064572773106803000",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 787.0881062951496,
							["y"] = -191.8613261093911
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511750",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["1773064572773106803001"] = {
						["key"] = "1773064572773106803001",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1493.483322276279,
							["y"] = 128.06123765295592
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511750",
							["VarValue"] = 2
						}
					},
					["1773064572773106803002"] = {
						["key"] = "1773064572773106803002",
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
							["FirstDialogueId"] = 51175008,
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
					["1773064572773106803003"] = {
						["key"] = "1773064572773106803003",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 1792,
							["y"] = 100
						},
						["propsData"] = {
							["IsHide"] = true,
							["AtmosphereTagList"] = {
								"story_511750"
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