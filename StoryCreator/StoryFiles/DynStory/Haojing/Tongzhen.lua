return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17599975020261",
			["startPort"] = "StoryStart",
			["endStory"] = "1759997577821194",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1759997577821194",
			["startPort"] = "Success",
			["endStory"] = "17599975020275",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17599975020261"] = {
			["isStoryNode"] = true,
			["key"] = "17599975020261",
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
		["17599975020275"] = {
			["isStoryNode"] = true,
			["key"] = "17599975020275",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1672,
				["y"] = 308
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1759997577821194"] = {
			["isStoryNode"] = true,
			["key"] = "1759997577821194",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1218,
				["y"] = 296
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_Tongzhen_Des",
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
						["startQuest"] = "1759997577821195",
						["startPort"] = "QuestStart",
						["endQuest"] = "1759997589368606",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1759997589368606",
						["startPort"] = "Out",
						["endQuest"] = "1759998190650507",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1759997589368606",
						["startPort"] = "Out",
						["endQuest"] = "1759998204919747",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1759998190650507",
						["startPort"] = "Out",
						["endQuest"] = "17599982959691235",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17599982959691235",
						["startPort"] = "Option_1",
						["endQuest"] = "17599984436521855",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17599982959691235",
						["startPort"] = "Option_2",
						["endQuest"] = "17599984507862056",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17599984436521855",
						["startPort"] = "Out",
						["endQuest"] = "17599984715442435",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17599984715442435",
						["startPort"] = "Out",
						["endQuest"] = "17599985233293004",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17599985233293004",
						["startPort"] = "Out",
						["endQuest"] = "17599985313553367",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17599985313553367",
						["startPort"] = "Out",
						["endQuest"] = "1759997577821202",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17599984507862056",
						["startPort"] = "Out",
						["endQuest"] = "1759997577821202",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17599984715442435",
						["startPort"] = "Out",
						["endQuest"] = "1760002241171655227",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1759997577821195"] = {
						["key"] = "1759997577821195",
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
					["1759997577821202"] = {
						["key"] = "1759997577821202",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3989.761904761905,
							["y"] = 276.90476190476187
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1759997577821209"] = {
						["key"] = "1759997577821209",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3889.761904761905,
							["y"] = 638.5714285714286
						},
						["propsData"] = {}
					},
					["1759997589368606"] = {
						["key"] = "1759997589368606",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成NPC和敌人",
						["pos"] = {
							["x"] = 1161.3193902871321,
							["y"] = 309.5384615384615
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420020,
								292420047,
								292420048,
								292420049,
								292420050
							}
						}
					},
					["1759998190650507"] = {
						["key"] = "1759998190650507",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1756.36817617866,
							["y"] = 324.16696207018805
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 4,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								292420047,
								292420048,
								292420049,
								292420050
							}
						}
					},
					["1759998204919747"] = {
						["key"] = "1759998204919747",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1627.299825174825,
							["y"] = 30.49450549450564
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71007901,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17599982959691235"] = {
						["key"] = "17599982959691235",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2030.8895687645686,
							["y"] = 325.18019614793826
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818083,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2420020",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007905,
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
					["17599984436521855"] = {
						["key"] = "17599984436521855",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2457.0440283400817,
							["y"] = 299.9161364950842
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420022
							}
						}
					},
					["17599984507862056"] = {
						["key"] = "17599984507862056",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 2456.8685897435907,
							["y"] = 656.6705224599965
						},
						["propsData"] = {
							["DialogueId"] = 71007908,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17599984715442435"] = {
						["key"] = "17599984715442435",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "挖宝物",
						["pos"] = {
							["x"] = 2783.701923076924,
							["y"] = 311.9940518717612
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2420022,
							["StateId"] = 780581,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_2420022"
						}
					},
					["17599985233293004"] = {
						["key"] = "17599985233293004",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3130.2019230769242,
							["y"] = 295.0038557933298
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818083,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2420020",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71007907,
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
					["17599985313553367"] = {
						["key"] = "17599985313553367",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3473.5352564102573,
							["y"] = 276.67052245999645
						},
						["propsData"] = {
							["DialogueId"] = 71007907,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["1760002241171655227"] = {
						["key"] = "1760002241171655227",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3127.7776806526804,
							["y"] = 98.79173458120849
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420022
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