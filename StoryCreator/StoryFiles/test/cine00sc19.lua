return {
	["storyName"] = "未命名故事",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17141991240923249755",
			["startPort"] = "StoryStart",
			["endStory"] = "17141991240923249757",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17141991240923249757",
			["startPort"] = "Success",
			["endStory"] = "17141991240923249756",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17141991240923249755"] = {
			["isStoryNode"] = true,
			["key"] = "17141991240923249755",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 100,
				["y"] = 140
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
		["17141991240923249756"] = {
			["isStoryNode"] = true,
			["key"] = "17141991240923249756",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 400,
				["y"] = 140
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17141991240923249757"] = {
			["isStoryNode"] = true,
			["key"] = "17141991240923249757",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 296.25,
				["y"] = 142.5
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
				["bIsNotifyGameMode"] = false,
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
						["startQuest"] = "17141991240923249759",
						["startPort"] = "QuestStart",
						["endQuest"] = "1712905662797163696",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1712905662797163696",
						["startPort"] = "Out",
						["endQuest"] = "17199147985531794836",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17199147985531794836",
						["startPort"] = "Out",
						["endQuest"] = "17141991240923249760",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1712905662797163696"] = {
						["key"] = "1712905662797163696",
						["type"] = "SkipRegionNode",
						["name"] = "传送酒馆",
						["pos"] = {
							["x"] = 559.7957498914417,
							["y"] = 570.2321797662116
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101107,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17141991240923249759"] = {
						["key"] = "17141991240923249759",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 136.66666666666669,
							["y"] = 455.00000000000006
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17141991240923249760"] = {
						["key"] = "17141991240923249760",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1223.3333333333333,
							["y"] = 233.33333333333337
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17141991240923249761"] = {
						["key"] = "17141991240923249761",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["17141991240923249762"] = {
						["key"] = "17141991240923249762",
						["type"] = "TalkNode",
						["name"] = "过场-100191-和前男主对话-SC02",
						["pos"] = {
							["x"] = 238.57589223492673,
							["y"] = -248.1747426497762
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC002/SQ_OBT0100_SC002",
							["BlendInTime"] = 1,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17199147985531794836"] = {
						["key"] = "17199147985531794836",
						["type"] = "TalkNode",
						["name"] = "过场-100194-神秘人",
						["pos"] = {
							["x"] = 814.4136698989986,
							["y"] = 239.57781521174007
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC019/SQ_OBT0100_SC019",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = false,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
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