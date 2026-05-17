return {
	["storyName"] = "未命名任务",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_16681501402220",
			["startPort"] = "StoryStart",
			["endStory"] = "story_16681501430924",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_16681501430924",
			["startPort"] = "Success",
			["endStory"] = "story_16681501402222",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["story_16681501402220"] = {
			["isStoryNode"] = true,
			["key"] = "story_16681501402220",
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
		["story_16681501402222"] = {
			["isStoryNode"] = true,
			["key"] = "story_16681501402222",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 857,
				["y"] = 111
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_16681501430924"] = {
			["isStoryNode"] = true,
			["key"] = "story_16681501430924",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 432,
				["y"] = 98.75
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
						["startQuest"] = "17331227260821468832",
						["startPort"] = "Out",
						["endQuest"] = "17331227260821468833",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17331229400432094082",
						["startPort"] = "Out",
						["endQuest"] = "17331229155632093679",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17331227260821468833",
						["startPort"] = "Out",
						["endQuest"] = "17331229400432094082",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1733985130467674269",
						["startPort"] = "Out",
						["endQuest"] = "1733107879246839092",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16681501430928",
						["startPort"] = "QuestStart",
						["endQuest"] = "17392606800328114783",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17392606800328114783",
						["startPort"] = "Out",
						["endQuest"] = "quest_166815014309210",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["quest_16681501430928"] = {
						["key"] = "quest_16681501430928",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -163.20909090909095,
							["y"] = 145.23636363636362
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_166815014309210"] = {
						["key"] = "quest_166815014309210",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 960.0346947738253,
							["y"] = 143.0680720245938
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_166815014309212"] = {
						["key"] = "quest_166815014309212",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 988.2777777777778,
							["y"] = 322.3888888888889
						},
						["propsData"] = {}
					},
					["17319968941011184"] = {
						["key"] = "17319968941011184",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成 逃跑哈尔",
						["pos"] = {
							["x"] = 1263.5652173913045,
							["y"] = -247.36645962732928
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180482,
								1180483,
								1180484,
								1180485,
								1180486,
								1180487,
								1180488
							}
						}
					},
					["1733107879246839092"] = {
						["key"] = "1733107879246839092",
						["type"] = "BossBattleOpenNode",
						["name"] = "BOSS战开场播片",
						["pos"] = {
							["x"] = 550.4025974025974,
							["y"] = 748.922077922078
						},
						["propsData"] = {
							["SequencePath"] = "LevelSequence'/Game/AssetDesign/Story/Sequence/Chapter01/IceLakeCity/Saiqi_Dream2.Saiqi_Dream2'",
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["EnableSkip"] = false,
							["PauseGameGlobal"] = false,
							["HideNpcs"] = false,
							["HideMonsters"] = true
						}
					},
					["17331227260821468832"] = {
						["key"] = "17331227260821468832",
						["type"] = "TalkNode",
						["name"] = "哈尔嘲讽",
						["pos"] = {
							["x"] = 192.0955600631059,
							["y"] = 1159.1282039461553
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10103100,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101031",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
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
									["TalkActorId"] = 200053,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17331227260821468833"] = {
						["key"] = "17331227260821468833",
						["type"] = "TalkNode",
						["name"] = "哈尔嘲讽",
						["pos"] = {
							["x"] = 185.99534902780323,
							["y"] = 1320.7808869629357
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10103101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101031",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200011,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17331229155632093679"] = {
						["key"] = "17331229155632093679",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 732.8181818181818,
							["y"] = 1189.0909090909092
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "MaerGo",
							["UnitId"] = 200011
						}
					},
					["17331229400432094082"] = {
						["key"] = "17331229400432094082",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 502.3636363636365,
							["y"] = 1198.6363636363637
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["17331230429552718443"] = {
						["key"] = "17331230429552718443",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 31.909090909090907,
							["y"] = 1410.0000000000002
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720060
							}
						}
					},
					["1733985130467674269"] = {
						["key"] = "1733985130467674269",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 267.2727272727272,
							["y"] = 726.6704545454546
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17339950869832020703"] = {
						["key"] = "17339950869832020703",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = -38.1818181818183,
							["y"] = 699.3977272727274
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike1",
							["UnitId"] = -1
						}
					},
					["17392606800328114783"] = {
						["key"] = "17392606800328114783",
						["type"] = "TalkNode",
						["name"] = "看到怪物小白跑路",
						["pos"] = {
							["x"] = 316,
							["y"] = 123.8131313131313
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10120301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_100203",
							["BlendInTime"] = 2,
							["BlendOutTime"] = 1,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = false,
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
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