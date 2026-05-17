return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "176362288661312679",
			["startPort"] = "StoryStart",
			["endStory"] = "176362288804412701",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176362288804412701",
			["startPort"] = "Success",
			["endStory"] = "176362288661312682",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["176362288661312679"] = {
			["isStoryNode"] = true,
			["key"] = "176362288661312679",
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
		["176362288661312682"] = {
			["isStoryNode"] = true,
			["key"] = "176362288661312682",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1700,
				["y"] = 378
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176362288804412701"] = {
			["isStoryNode"] = true,
			["key"] = "176362288804412701",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1186,
				["y"] = 342
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
						["startQuest"] = "176362288804412702",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763623057900688666",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763623057900688666",
						["startPort"] = "true",
						["endQuest"] = "176362289531312951",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763623057900688666",
						["startPort"] = "false",
						["endQuest"] = "1763623185120690247",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763623185120690247",
						["startPort"] = "Out",
						["endQuest"] = "176362288804412705",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176362289531312951",
						["startPort"] = "Out",
						["endQuest"] = "1763623246748691445",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763623246748691445",
						["startPort"] = "Out",
						["endQuest"] = "176362288804412705",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["176362288804412702"] = {
						["key"] = "176362288804412702",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176362288804412705"] = {
						["key"] = "176362288804412705",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2280.5263157894738,
							["y"] = 306.3157894736842
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176362288804412708"] = {
						["key"] = "176362288804412708",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["176362289531312951"] = {
						["key"] = "176362289531312951",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1473.921052631579,
							["y"] = 112.34210526315783
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51151201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_51151201",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 900012,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1763623057900688666"] = {
						["key"] = "1763623057900688666",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否是第一次对话",
						["pos"] = {
							["x"] = 1109.2629638335522,
							["y"] = 284.75
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "BaiJLFirstTalk",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["1763623185120690247"] = {
						["key"] = "1763623185120690247",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1567.9473684210525,
							["y"] = 398.9868421052632
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51151301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 900012,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1763623246748691445"] = {
						["key"] = "1763623246748691445",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1816.8768198979205,
							["y"] = 125.56237766585734
						},
						["propsData"] = {
							["VarName"] = "BaiJLFirstTalk",
							["VarValue"] = 1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}