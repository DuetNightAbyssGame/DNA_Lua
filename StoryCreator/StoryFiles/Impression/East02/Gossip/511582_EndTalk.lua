return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177210469637636114510",
			["startPort"] = "StoryStart",
			["endStory"] = "177210469637636114512",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177210469637636114512",
			["startPort"] = "Success",
			["endStory"] = "177210469637636114511",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177210469637636114510"] = {
			["isStoryNode"] = true,
			["key"] = "177210469637636114510",
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
		["177210469637636114511"] = {
			["isStoryNode"] = true,
			["key"] = "177210469637636114511",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1789.375,
				["y"] = 337.5
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["177210469637636114512"] = {
			["isStoryNode"] = true,
			["key"] = "177210469637636114512",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1288,
				["y"] = 298
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
						["startQuest"] = "177210469637636114516",
						["startPort"] = "Option_1",
						["endQuest"] = "177210477438636405745",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177210477438636405745",
						["startPort"] = "Out",
						["endQuest"] = "177210469637636114514",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177210483444636406461",
						["startPort"] = "false",
						["endQuest"] = "177210469637636114516",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177210483444636406461",
						["startPort"] = "true",
						["endQuest"] = "177210496567537185338",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177210496567537185338",
						["startPort"] = "Out",
						["endQuest"] = "177210469637636114514",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177210469637636114516",
						["startPort"] = "Option_2",
						["endQuest"] = "177210469637636114515",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "177210469637636114513",
						["startPort"] = "QuestStart",
						["endQuest"] = "17733725304841685142",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177210469637636114513",
						["startPort"] = "QuestStart",
						["endQuest"] = "177210483444636406461",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["177210469637636114513"] = {
						["key"] = "177210469637636114513",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 63.85714285714283,
							["y"] = 217
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177210469637636114514"] = {
						["key"] = "177210469637636114514",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1970.75,
							["y"] = 210.75
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177210469637636114515"] = {
						["key"] = "177210469637636114515",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1976,
							["y"] = 394
						},
						["propsData"] = {}
					},
					["177210469637636114516"] = {
						["key"] = "177210469637636114516",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1163.735294117647,
							["y"] = 241
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701266,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51158209,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"",
								""
							},
							["OverrideFailBlend"] = false
						}
					},
					["177210477438636405745"] = {
						["key"] = "177210477438636405745",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1467.75,
							["y"] = 143.5
						},
						["propsData"] = {
							["VarName"] = "Scenpc_511582",
							["VarValue"] = 2
						}
					},
					["177210483444636406461"] = {
						["key"] = "177210483444636406461",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 774,
							["y"] = 250.75
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Scenpc_511582",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["177210496567537185338"] = {
						["key"] = "177210496567537185338",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1170.5714285714284,
							["y"] = -87.49999999999974
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701266,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51158224,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = false,
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
					["17733725304841685142"] = {
						["key"] = "17733725304841685142",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1222.7142857142858,
							["y"] = -445.57142857142856
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50107017,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "StayOnLast",
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["bBubblePlayCDEnable"] = true,
							["BubblePlayCD"] = 15,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701266,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
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