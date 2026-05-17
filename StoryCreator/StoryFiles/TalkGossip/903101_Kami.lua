return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17696689835591",
			["startPort"] = "StoryStart",
			["endStory"] = "176966898930089",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176966898930089",
			["startPort"] = "Success",
			["endStory"] = "17696689835595",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17696689835591"] = {
			["isStoryNode"] = true,
			["key"] = "17696689835591",
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
		["17696689835595"] = {
			["isStoryNode"] = true,
			["key"] = "17696689835595",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1568,
				["y"] = 274
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176966898930089"] = {
			["isStoryNode"] = true,
			["key"] = "176966898930089",
			["type"] = "StoryNode",
			["name"] = "卡米拉看板娘",
			["pos"] = {
				["x"] = 1250,
				["y"] = 266
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
						["startQuest"] = "176966898930090",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769669094880827",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769669094880827",
						["startPort"] = "Out",
						["endQuest"] = "17696691118641236",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17696691118641236",
						["startPort"] = "Out",
						["endQuest"] = "1769669100880974",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769669100880974",
						["startPort"] = "Out",
						["endQuest"] = "176966898930198",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["176966898930090"] = {
						["key"] = "176966898930090",
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
					["176966898930198"] = {
						["key"] = "176966898930198",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769668989301106"] = {
						["key"] = "1769668989301106",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1769669094880827"] = {
						["key"] = "1769669094880827",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 1188,
							["y"] = 516
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 83202,
									["NpcPose"] = "Idle"
								}
							}
						}
					},
					["1769669100880974"] = {
						["key"] = "1769669100880974",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 1992,
							["y"] = 576
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 83202,
									["NpcPose"] = "Seating"
								}
							}
						}
					},
					["17696691118641236"] = {
						["key"] = "17696691118641236",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1486,
							["y"] = 372
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 90270001,
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
									["TalkActorId"] = 83202,
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