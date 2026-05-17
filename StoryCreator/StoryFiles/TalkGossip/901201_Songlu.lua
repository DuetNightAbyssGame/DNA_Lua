return {
	["storyName"] = "松露看板娘",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_1689144315873693",
			["startPort"] = "StoryStart",
			["endStory"] = "story_1689144317301697",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_1689144317301697",
			["startPort"] = "Success",
			["endStory"] = "story_1689144315874695",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["story_1689144315873693"] = {
			["isStoryNode"] = true,
			["key"] = "story_1689144315873693",
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
		["story_1689144315874695"] = {
			["isStoryNode"] = true,
			["key"] = "story_1689144315874695",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 701.5642054592951,
				["y"] = 149.1691819227488
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_1689144317301697"] = {
			["isStoryNode"] = true,
			["key"] = "story_1689144317301697",
			["type"] = "StoryNode",
			["name"] = "松露看板娘",
			["pos"] = {
				["x"] = 383.92837438783505,
				["y"] = 120.53243107390819
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
						["startQuest"] = "quest_16917538991842386",
						["startPort"] = "Out",
						["endQuest"] = "1704175979621225380",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1704175979621225379",
						["startPort"] = "QuestStart",
						["endQuest"] = "quest_16917539552422503",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16917539552422503",
						["startPort"] = "Out",
						["endQuest"] = "1704175979621225382",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979621225382",
						["startPort"] = "Out",
						["endQuest"] = "quest_16917538991842386",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_16917538991842386"] = {
						["key"] = "quest_16917538991842386",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 640.1065752330078,
							["y"] = 165.26432089015788
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 85101,
									["NpcPose"] = "Seating"
								}
							}
						}
					},
					["quest_16917539552422503"] = {
						["key"] = "quest_16917539552422503",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 99.58617440114165,
							["y"] = 159.57842380525892
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 85101,
									["NpcPose"] = "Idle"
								}
							}
						}
					},
					["1704175979621225379"] = {
						["key"] = "1704175979621225379",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -162.32953383238393,
							["y"] = 139.68418157300468
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979621225380"] = {
						["key"] = "1704175979621225380",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 982.5,
							["y"] = 165.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979621225381"] = {
						["key"] = "1704175979621225381",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 978,
							["y"] = 343
						},
						["propsData"] = {}
					},
					["1704175979621225382"] = {
						["key"] = "1704175979621225382",
						["type"] = "TalkNode",
						["name"] = "90120001",
						["pos"] = {
							["x"] = 359.9730572617803,
							["y"] = 150.91271041373966
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 90120001,
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
									["TalkActorId"] = 85101,
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