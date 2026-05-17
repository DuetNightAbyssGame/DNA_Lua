return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1773124016722123619086",
			["startPort"] = "StoryStart",
			["endStory"] = "1773124016722123619088",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1773124016722123619088",
			["startPort"] = "Success",
			["endStory"] = "1773124016722123619087",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1773124016722123619086"] = {
			["isStoryNode"] = true,
			["key"] = "1773124016722123619086",
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
		["1773124016722123619087"] = {
			["isStoryNode"] = true,
			["key"] = "1773124016722123619087",
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
		["1773124016722123619088"] = {
			["isStoryNode"] = true,
			["key"] = "1773124016722123619088",
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
						["startQuest"] = "1773124016722123619093",
						["startPort"] = "false",
						["endQuest"] = "1773124016722123619092",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773124016722123619093",
						["startPort"] = "true",
						["endQuest"] = "1773124016722123619095",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773124016722123619089",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773124016722123619093",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773124016722123619094",
						["startPort"] = "Out",
						["endQuest"] = "177260672635760117729",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177260672635760117729",
						["startPort"] = "Out",
						["endQuest"] = "1773124016722123619090",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1773124016722123619092",
						["startPort"] = "Option_1",
						["endQuest"] = "1773124016722123619094",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773124016722123619092",
						["startPort"] = "Option_2",
						["endQuest"] = "17726997443151635279",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726997443151635279",
						["startPort"] = "Out",
						["endQuest"] = "1773124016722123619090",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1773124016722123619095",
						["startPort"] = "Option_1",
						["endQuest"] = "17726997874331636350",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726997874331636350",
						["startPort"] = "Out",
						["endQuest"] = "1773124016722123619090",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1773124016722123619095",
						["startPort"] = "Option_2",
						["endQuest"] = "1773124016722123619090",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177260672635760117729"] = {
						["key"] = "177260672635760117729",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1749.5714285714287,
							["y"] = 33.28571428571428
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "show_liulu_chuansong",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17726997443151635279"] = {
						["key"] = "17726997443151635279",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1474.9999999999998,
							["y"] = 352.85714285714255
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511680",
							["VarValue"] = 2
						}
					},
					["17726997874331636350"] = {
						["key"] = "17726997874331636350",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1794.2857142857144,
							["y"] = -487.14285714285734
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "show_liulu_chuansong",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1773124016722123619089"] = {
						["key"] = "1773124016722123619089",
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
					["1773124016722123619090"] = {
						["key"] = "1773124016722123619090",
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
					["1773124016722123619091"] = {
						["key"] = "1773124016722123619091",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1973.2,
							["y"] = 557.6000000000001
						},
						["propsData"] = {}
					},
					["1773124016722123619092"] = {
						["key"] = "1773124016722123619092",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1179.022299995513,
							["y"] = 47.91773711773036
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51168016,
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
					["1773124016722123619093"] = {
						["key"] = "1773124016722123619093",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 787.0881062951496,
							["y"] = -191.8613261093911
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511680",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["1773124016722123619094"] = {
						["key"] = "1773124016722123619094",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1493.483322276279,
							["y"] = 128.06123765295592
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511680",
							["VarValue"] = 2
						}
					},
					["1773124016722123619095"] = {
						["key"] = "1773124016722123619095",
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
							["FirstDialogueId"] = 51168009,
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}