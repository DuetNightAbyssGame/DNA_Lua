return {
	["storyName"] = "章鱼看板娘",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "173770775053426244552",
			["startPort"] = "StoryStart",
			["endStory"] = "173770775053426244554",
			["endPort"] = "In"
		},
		{
			["startStory"] = "173770775053426244554",
			["startPort"] = "Success",
			["endStory"] = "173770775053426244553",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["173770775053426244552"] = {
			["isStoryNode"] = true,
			["key"] = "173770775053426244552",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 146.07142857142858,
				["y"] = 167.85714285714286
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
		["173770775053426244553"] = {
			["isStoryNode"] = true,
			["key"] = "173770775053426244553",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 766.4945725536977,
				["y"] = 168.20513234458454
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["173770775053426244554"] = {
			["isStoryNode"] = true,
			["key"] = "173770775053426244554",
			["type"] = "StoryNode",
			["name"] = "妮弗尔夫人看板娘",
			["pos"] = {
				["x"] = 447.3838642391187,
				["y"] = 157.4065945329894
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
						["startQuest"] = "173770775053426244557",
						["startPort"] = "QuestStart",
						["endQuest"] = "173770775053426244555",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173770775053426244555",
						["startPort"] = "Out",
						["endQuest"] = "173770775053426244560",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173770775053426244556",
						["startPort"] = "Out",
						["endQuest"] = "173770775053426244558",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173770775053426244560",
						["startPort"] = "Out",
						["endQuest"] = "173770775053426244556",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["173770775053426244555"] = {
						["key"] = "173770775053426244555",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 85,
							["y"] = 156.94128009520045
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 81502,
									["NpcPose"] = "Idle"
								}
							}
						}
					},
					["173770775053426244556"] = {
						["key"] = "173770775053426244556",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 593.8519363099516,
							["y"] = 155.2455458868704
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 81502,
									["NpcPose"] = "Seating"
								}
							}
						}
					},
					["173770775053426244557"] = {
						["key"] = "173770775053426244557",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -171.7304734684251,
							["y"] = 156.44718737417537
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173770775053426244558"] = {
						["key"] = "173770775053426244558",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 972.6315789473684,
							["y"] = 147.89473684210526
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173770775053426244559"] = {
						["key"] = "173770775053426244559",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 930,
							["y"] = 411.0526315789474
						},
						["propsData"] = {}
					},
					["173770775053426244560"] = {
						["key"] = "173770775053426244560",
						["type"] = "TalkNode",
						["name"] = "90050001",
						["pos"] = {
							["x"] = 322.57894736842104,
							["y"] = 142.42105263157896
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 90220001,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1,
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
							["ShowSkipButton"] = false,
							["ShowAutoPlayButton"] = false,
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
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 81502,
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}