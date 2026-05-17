return {
	["storyName"] = "海尔法看板娘",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_1689129919154323",
			["startPort"] = "StoryStart",
			["endStory"] = "story_1689129934949327",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_1689129934949327",
			["startPort"] = "Success",
			["endStory"] = "story_1689129919154325",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["story_1689129919154323"] = {
			["isStoryNode"] = true,
			["key"] = "story_1689129919154323",
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
		["story_1689129919154325"] = {
			["isStoryNode"] = true,
			["key"] = "story_1689129919154325",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 676.6753781224992,
				["y"] = 145.5781326234374
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_1689129934949327"] = {
			["isStoryNode"] = true,
			["key"] = "story_1689129934949327",
			["type"] = "StoryNode",
			["name"] = "海尔法看板娘",
			["pos"] = {
				["x"] = 344.07788867343777,
				["y"] = 141.6405411421876
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
						["startQuest"] = "1704175979584223468",
						["startPort"] = "QuestStart",
						["endQuest"] = "quest_16917509740381183",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16917509740381183",
						["startPort"] = "Out",
						["endQuest"] = "1704175979584223471",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16917536995591980",
						["startPort"] = "Out",
						["endQuest"] = "1704175979584223469",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1704175979584223471",
						["startPort"] = "Out",
						["endQuest"] = "quest_16917536995591980",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_16917509740381183"] = {
						["key"] = "quest_16917509740381183",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 58.141981280071064,
							["y"] = 140.74408483468295
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 83201,
									["NpcPose"] = "Idle"
								}
							}
						}
					},
					["quest_16917536995591980"] = {
						["key"] = "quest_16917536995591980",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 759.7078308658934,
							["y"] = 148.16462445736448
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 83201,
									["NpcPose"] = "Seating"
								}
							}
						}
					},
					["1704175979584223468"] = {
						["key"] = "1704175979584223468",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -201.41103933359716,
							["y"] = 128.60210355461192
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979584223469"] = {
						["key"] = "1704175979584223469",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1112,
							["y"] = 144
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979584223470"] = {
						["key"] = "1704175979584223470",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1140,
							["y"] = 338
						},
						["propsData"] = {}
					},
					["1704175979584223471"] = {
						["key"] = "1704175979584223471",
						["type"] = "TalkNode",
						["name"] = "90060001",
						["pos"] = {
							["x"] = 385,
							["y"] = 127
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 90060001,
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
									["TalkActorId"] = 83201,
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