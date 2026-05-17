return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1773068997208113528406",
			["startPort"] = "StoryStart",
			["endStory"] = "1773068997208113528408",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1773068997208113528408",
			["startPort"] = "Success",
			["endStory"] = "1773068997208113528407",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1773068997208113528406"] = {
			["isStoryNode"] = true,
			["key"] = "1773068997208113528406",
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
		["1773068997208113528407"] = {
			["isStoryNode"] = true,
			["key"] = "1773068997208113528407",
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
		["1773068997208113528408"] = {
			["isStoryNode"] = true,
			["key"] = "1773068997208113528408",
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
						["startQuest"] = "1773068997208113528413",
						["startPort"] = "false",
						["endQuest"] = "1773068997208113528412",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773068997208113528413",
						["startPort"] = "true",
						["endQuest"] = "1773068997208113528415",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773068997208113528409",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773068997208113528413",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773068997208113528412",
						["startPort"] = "Out",
						["endQuest"] = "1773068997208113528414",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773068997208113528415",
						["startPort"] = "Out",
						["endQuest"] = "1773068997208113528410",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1773068997208113528414",
						["startPort"] = "Out",
						["endQuest"] = "1773124001797123079346",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773124001797123079346",
						["startPort"] = "Out",
						["endQuest"] = "1773068997208113528410",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1773068997208113528409"] = {
						["key"] = "1773068997208113528409",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 403.69230769230774,
							["y"] = -172.61538461538464
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1773068997208113528410"] = {
						["key"] = "1773068997208113528410",
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
					["1773068997208113528411"] = {
						["key"] = "1773068997208113528411",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1973.2,
							["y"] = 557.6000000000001
						},
						["propsData"] = {}
					},
					["1773068997208113528412"] = {
						["key"] = "1773068997208113528412",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1179.022299995513,
							["y"] = 47.91773711773036
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 51171001,
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
					["1773068997208113528413"] = {
						["key"] = "1773068997208113528413",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 787.0881062951496,
							["y"] = -191.8613261093911
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511710",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["1773068997208113528414"] = {
						["key"] = "1773068997208113528414",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1479.483322276279,
							["y"] = 64.06123765295592
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511710",
							["VarValue"] = 2
						}
					},
					["1773068997208113528415"] = {
						["key"] = "1773068997208113528415",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1272.3230134158925,
							["y"] = -303.4898090815275
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51171009,
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
					["1773124001797123079346"] = {
						["key"] = "1773124001797123079346",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 1764,
							["y"] = 54
						},
						["propsData"] = {
							["IsHide"] = true,
							["AtmosphereTagList"] = {
								"story_511710"
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