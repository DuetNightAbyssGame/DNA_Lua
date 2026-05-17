return {
	["storyName"] = "琳恩看板娘",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "171851537039711658913",
			["startPort"] = "StoryStart",
			["endStory"] = "171851537039711658915",
			["endPort"] = "In"
		},
		{
			["startStory"] = "171851537039711658915",
			["startPort"] = "Success",
			["endStory"] = "171851537039711658914",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["171851537039711658913"] = {
			["isStoryNode"] = true,
			["key"] = "171851537039711658913",
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
		["171851537039711658914"] = {
			["isStoryNode"] = true,
			["key"] = "171851537039711658914",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 747.410115073039,
				["y"] = 142.03759598283307
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["171851537039711658915"] = {
			["isStoryNode"] = true,
			["key"] = "171851537039711658915",
			["type"] = "StoryNode",
			["name"] = "耶尔看板娘",
			["pos"] = {
				["x"] = 415.17082861958863,
				["y"] = 119.40455158891598
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
						["startQuest"] = "17169828728741943",
						["startPort"] = "Out",
						["endQuest"] = "171851537039711658917",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "171851537039711658916",
						["startPort"] = "QuestStart",
						["endQuest"] = "17169828728741942",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17169828728741942",
						["startPort"] = "Out",
						["endQuest"] = "17169828728741944",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17169828728741944",
						["startPort"] = "Out",
						["endQuest"] = "17169828728741943",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17169828728741942"] = {
						["key"] = "17169828728741942",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 163.17001858730487,
							["y"] = 941.5792131953443
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 83103,
									["NpcPose"] = "Idle"
								}
							}
						}
					},
					["17169828728741943"] = {
						["key"] = "17169828728741943",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 790.9251724535384,
							["y"] = 942.0917248601804
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 83103,
									["NpcPose"] = "Seating"
								}
							}
						}
					},
					["17169828728741944"] = {
						["key"] = "17169828728741944",
						["type"] = "TalkNode",
						["name"] = "90130001",
						["pos"] = {
							["x"] = 469.1498844416989,
							["y"] = 930.5444178681288
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 90180001,
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
									["TalkActorId"] = 83103,
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
					["171851537039711658916"] = {
						["key"] = "171851537039711658916",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -108.54712798441847,
							["y"] = 940.2337455587602
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537039711658917"] = {
						["key"] = "171851537039711658917",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1154.8333333333333,
							["y"] = 946
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537039711658918"] = {
						["key"] = "171851537039711658918",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1550.8333333333333,
							["y"] = 843.5
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}