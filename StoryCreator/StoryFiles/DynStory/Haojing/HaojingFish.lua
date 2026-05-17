return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17586959718381",
			["startPort"] = "StoryStart",
			["endStory"] = "1758696085409327679",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1758696085409327679",
			["startPort"] = "Success",
			["endStory"] = "17586959718395",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17586959718381"] = {
			["isStoryNode"] = true,
			["key"] = "17586959718381",
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
		["17586959718395"] = {
			["isStoryNode"] = true,
			["key"] = "17586959718395",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1504,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1758696085409327679"] = {
			["isStoryNode"] = true,
			["key"] = "1758696085409327679",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1130,
				["y"] = 296
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_HaojingFish_Des",
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
				["bIsDynamicEvent"] = true,
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
						["startQuest"] = "1758697267139364",
						["startPort"] = "Out",
						["endQuest"] = "1758697267139365",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758697267139364",
						["startPort"] = "Out",
						["endQuest"] = "1758697267139366",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758696085409327680",
						["startPort"] = "QuestStart",
						["endQuest"] = "1758697267139364",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758697267139366",
						["startPort"] = "Option_2",
						["endQuest"] = "1758697273808539",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758697281054688",
						["startPort"] = "Out",
						["endQuest"] = "1758697281054689",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758697281054692",
						["startPort"] = "Out",
						["endQuest"] = "1758697281054691",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758697281054691",
						["startPort"] = "Out",
						["endQuest"] = "1758697281054690",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1758697281054691",
						["startPort"] = "Out",
						["endQuest"] = "1758697281054693",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758697281054690",
						["startPort"] = "Out",
						["endQuest"] = "1758697281054688",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758697267139366",
						["startPort"] = "Option_1",
						["endQuest"] = "1758697281054692",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758697281054689",
						["startPort"] = "Out",
						["endQuest"] = "1758696085409327683",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1758696085409327680"] = {
						["key"] = "1758696085409327680",
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
					["1758696085409327683"] = {
						["key"] = "1758696085409327683",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3512,
							["y"] = 340
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1758696085409327686"] = {
						["key"] = "1758696085409327686",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1758697267139364"] = {
						["key"] = "1758697267139364",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成钓鱼NPC",
						["pos"] = {
							["x"] = 1120.4752747252746,
							["y"] = 306.5
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2010060
							}
						}
					},
					["1758697267139365"] = {
						["key"] = "1758697267139365",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1512.4752747252746,
							["y"] = 29.499999999999957
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71007601,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1758697267139366"] = {
						["key"] = "1758697267139366",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1587.5247252747251,
							["y"] = 289.35714285714283
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818079,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2010060",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007602,
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
					["1758697273808539"] = {
						["key"] = "1758697273808539",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 2048,
							["y"] = 584
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["1758697281054688"] = {
						["key"] = "1758697281054688",
						["type"] = "TalkNode",
						["name"] = "钓鱼成功对话",
						["pos"] = {
							["x"] = 2858.4222198853777,
							["y"] = 278.4512018683072
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818079,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2010060",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007604,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1758697281054689"] = {
						["key"] = "1758697281054689",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3136.4222198853777,
							["y"] = 288.40120186830717
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["1758697281054690"] = {
						["key"] = "1758697281054690",
						["type"] = "ResourceCollectNode",
						["name"] = "获得Resource道具",
						["pos"] = {
							["x"] = 2566.714426801269,
							["y"] = 295.5623068452018
						},
						["propsData"] = {
							["ResourceType"] = "Resource",
							["ResourceId"] = -1,
							["ResourceSType"] = "Fish",
							["NeedCount"] = 1,
							["bUseBagCount"] = false,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Mechanism_Dyn_2010061"
						}
					},
					["1758697281054691"] = {
						["key"] = "1758697281054691",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2289.435652067231,
							["y"] = 298.9521265284424
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					},
					["1758697281054692"] = {
						["key"] = "1758697281054692",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成钓鱼点",
						["pos"] = {
							["x"] = 1959.5777801146219,
							["y"] = 291.7394907723855
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2010061
							}
						}
					},
					["1758697281054693"] = {
						["key"] = "1758697281054693",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "给钓鱼机关指引点",
						["pos"] = {
							["x"] = 2531.978285165127,
							["y"] = 485.5487981316929
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2010061,
							["StateId"] = 9020002,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_2010061"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}