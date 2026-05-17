return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17695924776521881195",
			["startPort"] = "Success",
			["endStory"] = "17695924776521881196",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17695924776521881196",
			["startPort"] = "Success",
			["endStory"] = "17695924776521881197",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17695924776521881193",
			["startPort"] = "StoryStart",
			["endStory"] = "17695924776521881195",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17695924776521881197",
			["startPort"] = "Success",
			["endStory"] = "17695924776521881194",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17695924776521881193"] = {
			["isStoryNode"] = true,
			["key"] = "17695924776521881193",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1366.3478260869567,
				["y"] = 345.94508009153316
			},
			["propsData"] = {
				["QuestChainId"] = 400128
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17695924776521881194"] = {
			["isStoryNode"] = true,
			["key"] = "17695924776521881194",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2618.8853754940715,
				["y"] = 318.8043478260869
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17695924776521881195"] = {
			["isStoryNode"] = true,
			["key"] = "17695924776521881195",
			["type"] = "StoryNode",
			["name"] = "前往据点门口",
			["pos"] = {
				["x"] = 1726.5875668449198,
				["y"] = 353.22468611950694
			},
			["propsData"] = {
				["QuestId"] = 40012800,
				["QuestDescriptionComment"] = "前往据点门口",
				["QuestDescription"] = "Description_400128_1",
				["QuestDeatil"] = "Content_400128_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_40012100_1192071",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17695924776521881200",
						["startPort"] = "QuestStart",
						["endQuest"] = "17695924776521881203",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695924776521881203",
						["startPort"] = "Out",
						["endQuest"] = "17695924776521881201",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17695924776521881200"] = {
						["key"] = "17695924776521881200",
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
					["17695924776521881201"] = {
						["key"] = "17695924776521881201",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1571.578947368421,
							["y"] = 312.63157894736844
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17695924776521881202"] = {
						["key"] = "17695924776521881202",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17695924776521881203"] = {
						["key"] = "17695924776521881203",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1165.309562341683,
							["y"] = 308.81972980579786
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1192071,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_40012100_1192071"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17695924776521881196"] = {
			["isStoryNode"] = true,
			["key"] = "17695924776521881196",
			["type"] = "StoryNode",
			["name"] = "播放对话",
			["pos"] = {
				["x"] = 2017.2091083468963,
				["y"] = 351.96381655428956
			},
			["propsData"] = {
				["QuestId"] = 40012801,
				["QuestDescriptionComment"] = "播放对话",
				["QuestDescription"] = "Description_400128_1",
				["QuestDeatil"] = "Content_400128_1",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_40012100_1192071",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17695924776521881204",
						["startPort"] = "QuestStart",
						["endQuest"] = "17695924776521881207",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695924776521881207",
						["startPort"] = "Out",
						["endQuest"] = "17695924776521881208",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695924776521881207",
						["startPort"] = "Out",
						["endQuest"] = "17731425321952549912",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17731425321952549912",
						["startPort"] = "Out",
						["endQuest"] = "17695924776521881205",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17695924776521881204"] = {
						["key"] = "17695924776521881204",
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
					["17695924776521881205"] = {
						["key"] = "17695924776521881205",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1868.8461538461536,
							["y"] = 311.83946488294316
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17695924776521881206"] = {
						["key"] = "17695924776521881206",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1528.2608695652173,
							["y"] = 603.4782608695652
						},
						["propsData"] = {}
					},
					["17695924776521881207"] = {
						["key"] = "17695924776521881207",
						["type"] = "TalkNode",
						["name"] = "播站桩",
						["pos"] = {
							["x"] = 1138.0869565217388,
							["y"] = 309.3299232736572
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 51012300,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400121/40012101.40012101'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
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
					["17695924776521881208"] = {
						["key"] = "17695924776521881208",
						["type"] = "TalkNode",
						["name"] = "播开车",
						["pos"] = {
							["x"] = 1484.1969309462913,
							["y"] = 101.19155096821339
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51012400,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17731425321952549912"] = {
						["key"] = "17731425321952549912",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1482.007992007992,
							["y"] = 301.6703296703296
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17695924776521881197"] = {
			["isStoryNode"] = true,
			["key"] = "17695924776521881197",
			["type"] = "StoryNode",
			["name"] = "进据点&铁匠皎皎对话",
			["pos"] = {
				["x"] = 2321.6376797754674,
				["y"] = 355.46381655428956
			},
			["propsData"] = {
				["QuestId"] = 40012802,
				["QuestDescriptionComment"] = "进据点&铁匠皎皎对话",
				["QuestDescription"] = "Description_400128_2",
				["QuestDeatil"] = "Content_400128_2",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
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
				["SubRegionId"] = 210101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Bai_Duanzao",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17695924776521881209",
						["startPort"] = "QuestStart",
						["endQuest"] = "17695924776521881212",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695924776521881212",
						["startPort"] = "Out",
						["endQuest"] = "17695924776521881213",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695924776521881213",
						["startPort"] = "Out",
						["endQuest"] = "17695924776521881210",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17695924776521881212",
						["startPort"] = "Out",
						["endQuest"] = "17696563662231125179",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17695924776521881209"] = {
						["key"] = "17695924776521881209",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 862.1428571428571,
							["y"] = 250.71428571428572
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17695924776521881210"] = {
						["key"] = "17695924776521881210",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1970.0615384615385,
							["y"] = 265.84615384615387
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17695924776521881211"] = {
						["key"] = "17695924776521881211",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17695924776521881212"] = {
						["key"] = "17695924776521881212",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1242.9285714285718,
							["y"] = 250.14285714285714
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuideName"] = "Npc_Bai_Duanzao"
						}
					},
					["17695924776521881213"] = {
						["key"] = "17695924776521881213",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1560.8956043956046,
							["y"] = 259.40720390720384
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 900001,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Bai_Duanzao",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51012500,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17696563662231125179"] = {
						["key"] = "17696563662231125179",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1554.2372549019606,
							["y"] = 85.08578431372555
						},
						["propsData"] = {
							["NewDescription"] = "Description_400128_3",
							["NewDetail"] = "Content_400128_3",
							["SubTaskTargetIndex"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}