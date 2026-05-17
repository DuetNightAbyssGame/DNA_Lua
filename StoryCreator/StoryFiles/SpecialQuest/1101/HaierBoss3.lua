return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1724310308693716037",
			["startPort"] = "StoryStart",
			["endStory"] = "17262242589848729279",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17262242589848729279",
			["startPort"] = "Success",
			["endStory"] = "1724310308694716040",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1724310308693716037"] = {
			["isStoryNode"] = true,
			["key"] = "1724310308693716037",
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
		["1724310308694716040"] = {
			["isStoryNode"] = true,
			["key"] = "1724310308694716040",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1388.363636363637,
				["y"] = 321.27272727272725
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17262242589848729279"] = {
			["isStoryNode"] = true,
			["key"] = "17262242589848729279",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1119.1813144784646,
				["y"] = 119.00715612193329
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
				["bIsPlayBlackScreenOnComplete"] = true,
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
						["startQuest"] = "17262242589848729287",
						["startPort"] = "Out",
						["endQuest"] = "17262242589848729288",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17262242589848729283",
						["startPort"] = "QuestStart",
						["endQuest"] = "17262242589848729291",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17262242589848729288",
						["startPort"] = "Out",
						["endQuest"] = "17262242589848729293",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17262242589848729293",
						["startPort"] = "Out",
						["endQuest"] = "17262242589848729289",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17262242589848729287",
						["startPort"] = "Out",
						["endQuest"] = "17271690062773511993",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17262242589848729283",
						["startPort"] = "QuestStart",
						["endQuest"] = "17295874506191906119",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17262242589848729291",
						["startPort"] = "Out",
						["endQuest"] = "17262242589848729285",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17262242589848729283",
						["startPort"] = "QuestStart",
						["endQuest"] = "17413352757076571042",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17262242589848729286",
						["startPort"] = "Out",
						["endQuest"] = "17262242589848729287",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17262242589848729283",
						["startPort"] = "QuestStart",
						["endQuest"] = "17262242589848729286",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17262242589848729283"] = {
						["key"] = "17262242589848729283",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 276.66666666666663,
							["y"] = 185
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17262242589848729284"] = {
						["key"] = "17262242589848729284",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2618.768731084373,
							["y"] = 220.16018306636164
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17262242589848729285"] = {
						["key"] = "17262242589848729285",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1542.4027459954232,
							["y"] = 549.1075514874142
						},
						["propsData"] = {}
					},
					["17262242589848729286"] = {
						["key"] = "17262242589848729286",
						["type"] = "TalkNode",
						["name"] = "过场 - SC015 - BOSS战登场",
						["pos"] = {
							["x"] = 759.754154799935,
							["y"] = 121.83931416368043
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC015/SQ_OBT0102_SC015",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
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
					},
					["17262242589848729287"] = {
						["key"] = "17262242589848729287",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战3开始",
						["pos"] = {
							["x"] = 1068.1964351896393,
							["y"] = 171.0255200121727
						},
						["propsData"] = {
							["SendMessage"] = "LianhuoStart",
							["FinishCondition"] = "Boss_Lianhuo_Create"
						}
					},
					["17262242589848729288"] = {
						["key"] = "17262242589848729288",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战3成功",
						["pos"] = {
							["x"] = 1484.7306744439018,
							["y"] = 160.9754674331727
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "Boss_LianhuoEnd"
						}
					},
					["17262242589848729289"] = {
						["key"] = "17262242589848729289",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2090.5189128253855,
							["y"] = 170.00293247363447
						},
						["propsData"] = {}
					},
					["17262242589848729291"] = {
						["key"] = "17262242589848729291",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1134.470016459948,
							["y"] = 526.7547519104897
						},
						["propsData"] = {}
					},
					["17262242589848729293"] = {
						["key"] = "17262242589848729293",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1813.5649027995928,
							["y"] = 199.7993183702441
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17271690062773511993"] = {
						["key"] = "17271690062773511993",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1650.5100589461556,
							["y"] = 411.0955663225709
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11016301,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17295874506191906119"] = {
						["key"] = "17295874506191906119",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 851.1962675999548,
							["y"] = -485.19319608193064
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0055_combat_boss_haier.0055_combat_boss_haier'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								102104
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17413352757076571042"] = {
						["key"] = "17413352757076571042",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 785.356733430446,
							["y"] = -210.07017543859646
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TargetPoint_JailBoss",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}