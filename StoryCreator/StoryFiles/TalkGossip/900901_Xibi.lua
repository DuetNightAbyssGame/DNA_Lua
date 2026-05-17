return {
	["storyName"] = "西比尔看板娘",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_1689141740788421",
			["startPort"] = "StoryStart",
			["endStory"] = "story_1689141754055425",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_1689141754055425",
			["startPort"] = "Success",
			["endStory"] = "story_1689141740789423",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["story_1689141740788421"] = {
			["isStoryNode"] = true,
			["key"] = "story_1689141740788421",
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
		["story_1689141740789423"] = {
			["isStoryNode"] = true,
			["key"] = "story_1689141740789423",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 693,
				["y"] = 139
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_1689141754055425"] = {
			["isStoryNode"] = true,
			["key"] = "story_1689141754055425",
			["type"] = "StoryNode",
			["name"] = "西比尔看板娘",
			["pos"] = {
				["x"] = 383,
				["y"] = 132
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
						["startQuest"] = "1704175979603224398",
						["startPort"] = "QuestStart",
						["endQuest"] = "quest_16917513955461336",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16917513955461336",
						["startPort"] = "Out",
						["endQuest"] = "1704175979603224401",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16917537870192207",
						["startPort"] = "Out",
						["endQuest"] = "1704175979603224399",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1704175979603224401",
						["startPort"] = "Out",
						["endQuest"] = "quest_16917537870192207",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_16917513955461336"] = {
						["key"] = "quest_16917513955461336",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 87.94104699165739,
							["y"] = 149.79224387343248
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 84301,
									["NpcPose"] = "Idle"
								}
							}
						}
					},
					["quest_16917537870192207"] = {
						["key"] = "quest_16917537870192207",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 673.2099887706806,
							["y"] = 152.1851245528394
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 84301,
									["NpcPose"] = "Seating"
								}
							}
						}
					},
					["1704175979603224398"] = {
						["key"] = "1704175979603224398",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -202.98356657085967,
							["y"] = 126.36086838587775
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979603224399"] = {
						["key"] = "1704175979603224399",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 985.5,
							["y"] = 146
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979603224400"] = {
						["key"] = "1704175979603224400",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 987,
							["y"] = 304
						},
						["propsData"] = {}
					},
					["1704175979603224401"] = {
						["key"] = "1704175979603224401",
						["type"] = "TalkNode",
						["name"] = "90090001",
						["pos"] = {
							["x"] = 369.56034684804064,
							["y"] = 131.37896277950367
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 90090001,
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
									["TalkActorId"] = 84301,
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