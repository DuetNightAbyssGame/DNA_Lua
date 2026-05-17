return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17367603791051170",
			["startPort"] = "StoryStart",
			["endStory"] = "17367648149383027",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17367648149383027",
			["startPort"] = "Success",
			["endStory"] = "17367603791061173",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17367603791051170"] = {
			["isStoryNode"] = true,
			["key"] = "17367603791051170",
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
		["17367603791061173"] = {
			["isStoryNode"] = true,
			["key"] = "17367603791061173",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1550.5483870967741,
				["y"] = 308.2741935483871
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17367648149383027"] = {
			["isStoryNode"] = true,
			["key"] = "17367648149383027",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1137.8461538461538,
				["y"] = 302.23076923076917
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_SewSaveFisher_Des",
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
						["startQuest"] = "17367648283143497",
						["startPort"] = "Out",
						["endQuest"] = "17367648283143496",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143499",
						["startPort"] = "Out",
						["endQuest"] = "17367648283143500",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143500",
						["startPort"] = "Out",
						["endQuest"] = "17367648283143498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143497",
						["startPort"] = "Out",
						["endQuest"] = "17367648283143499",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143501",
						["startPort"] = "Out",
						["endQuest"] = "17367648283143503",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143503",
						["startPort"] = "Out",
						["endQuest"] = "17367648283143504",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143504",
						["startPort"] = "Out",
						["endQuest"] = "17367648283143505",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143505",
						["startPort"] = "Out",
						["endQuest"] = "17367648283143506",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648149383028",
						["startPort"] = "QuestStart",
						["endQuest"] = "17367648283143497",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143506",
						["startPort"] = "Out",
						["endQuest"] = "17367648149393031",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17367648283143508",
						["startPort"] = "Out",
						["endQuest"] = "17367648149393031",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17367648149383028",
						["startPort"] = "QuestStart",
						["endQuest"] = "1737530464984924",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143498",
						["startPort"] = "Option_2",
						["endQuest"] = "17367648283143508",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143498",
						["startPort"] = "Option_1",
						["endQuest"] = "17367648283143501",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17367648283143498",
						["startPort"] = "Option_1",
						["endQuest"] = "17367648283143502",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17367648149383028"] = {
						["key"] = "17367648149383028",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 62,
							["y"] = -108
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17367648149393031"] = {
						["key"] = "17367648149393031",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3164,
							["y"] = 178
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17367648149393034"] = {
						["key"] = "17367648149393034",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17367648283143496"] = {
						["key"] = "17367648283143496",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 667.3861164491038,
							["y"] = -431.6121651881414
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71005701,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17367648283143497"] = {
						["key"] = "17367648283143497",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成NPC",
						["pos"] = {
							["x"] = 375.46303952602693,
							["y"] = -178.91985749583364
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720481
							}
						}
					},
					["17367648283143498"] = {
						["key"] = "17367648283143498",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1259.7944428896885,
							["y"] = -214.26173783771407
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818051,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1720481",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71005702,
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
					["17367648283143499"] = {
						["key"] = "17367648283143499",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成秽兽",
						["pos"] = {
							["x"] = 676.2818980868208,
							["y"] = -177.02159446853852
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720471,
								1720472,
								1720473,
								1720474
							}
						}
					},
					["17367648283143500"] = {
						["key"] = "17367648283143500",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 985.9234751477529,
							["y"] = -185.55206041835925
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 4,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1720471,
								1720472,
								1720473,
								1720474
							}
						}
					},
					["17367648283143501"] = {
						["key"] = "17367648283143501",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1758.3414717521669,
							["y"] = -217.90970183372548
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1720475,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Dyn_1720475"
						}
					},
					["17367648283143502"] = {
						["key"] = "17367648283143502",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成秽兽",
						["pos"] = {
							["x"] = 1764.5925160295274,
							["y"] = -52.90970183372559
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720477,
								1720478,
								1720479
							}
						}
					},
					["17367648283143503"] = {
						["key"] = "17367648283143503",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2125.1083890454,
							["y"] = -205.0525589765827
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 3,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1720477,
								1720478,
								1720479
							}
						}
					},
					["17367648283143504"] = {
						["key"] = "17367648283143504",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 2511.894103331115,
							["y"] = -198.62398754801126
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1720480
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80029,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17367648283143505"] = {
						["key"] = "17367648283143505",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2856.894103331115,
							["y"] = -232.1304810545048
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818051,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1720481",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71005704,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
							["InType"] = "BlendIn",
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
					["17367648283143506"] = {
						["key"] = "17367648283143506",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3196.536960473972,
							["y"] = -225.40970183372553
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17367648283143508"] = {
						["key"] = "17367648283143508",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 1699.7201661571798,
							["y"] = 171.61216518814126
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["1737530464984924"] = {
						["key"] = "1737530464984924",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成障碍物",
						["pos"] = {
							["x"] = 373.2307692307697,
							["y"] = -9.076923076923052
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720484,
								1720485,
								1720486,
								1720487
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