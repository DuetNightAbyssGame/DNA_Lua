return {
	["storyName"] = "琳恩看板娘",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17141991239553245788",
			["startPort"] = "StoryStart",
			["endStory"] = "17141991239563245790",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17141991239563245790",
			["startPort"] = "Success",
			["endStory"] = "17141991239563245789",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17141991239553245788"] = {
			["isStoryNode"] = true,
			["key"] = "17141991239553245788",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 204.44444444444446,
				["y"] = 121.11111111111111
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
		["17141991239563245789"] = {
			["isStoryNode"] = true,
			["key"] = "17141991239563245789",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 712.7434484063724,
				["y"] = 123.14870709394418
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17141991239563245790"] = {
			["isStoryNode"] = true,
			["key"] = "17141991239563245790",
			["type"] = "StoryNode",
			["name"] = "菲娜看板娘",
			["pos"] = {
				["x"] = 459.42082861958863,
				["y"] = 106.29344047780486
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
						["startQuest"] = "17141991239563245793",
						["startPort"] = "QuestStart",
						["endQuest"] = "17141991239563245791",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17141991239563245791",
						["startPort"] = "Out",
						["endQuest"] = "17141991239563245796",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17141991239563245792",
						["startPort"] = "Out",
						["endQuest"] = "17141991239563245794",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17141991239563245796",
						["startPort"] = "Out",
						["endQuest"] = "17141991239563245792",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17141991239563245791"] = {
						["key"] = "17141991239563245791",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 67.08048099364657,
							["y"] = 130.6975057409552
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 81801,
									["NpcPose"] = "Idle"
								}
							}
						}
					},
					["17141991239563245792"] = {
						["key"] = "17141991239563245792",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 710.83563485988,
							["y"] = 130.96001740579118
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 81801,
									["NpcPose"] = "Seating"
								}
							}
						}
					},
					["17141991239563245793"] = {
						["key"] = "17141991239563245793",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -187.38046131775178,
							["y"] = 129.06707889209355
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17141991239563245794"] = {
						["key"] = "17141991239563245794",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1008,
							["y"] = 131
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17141991239563245795"] = {
						["key"] = "17141991239563245795",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1014,
							["y"] = 322
						},
						["propsData"] = {}
					},
					["17141991239563245796"] = {
						["key"] = "17141991239563245796",
						["type"] = "TalkNode",
						["name"] = "90130001",
						["pos"] = {
							["x"] = 378.69671048440426,
							["y"] = 113.41271041373966
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 90150001,
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
									["TalkActorId"] = 81801,
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