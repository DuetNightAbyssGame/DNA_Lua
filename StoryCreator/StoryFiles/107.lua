return {
	["storyName"] = "未命名任务",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_16893227058280",
			["startPort"] = "StoryStart",
			["endStory"] = "story_16893227077094",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_16893227077094",
			["startPort"] = "Success",
			["endStory"] = "story_16893227058292",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["story_16893227058280"] = {
			["isStoryNode"] = true,
			["key"] = "story_16893227058280",
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
		["story_16893227058292"] = {
			["isStoryNode"] = true,
			["key"] = "story_16893227058292",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 613,
				["y"] = 165
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_16893227077094"] = {
			["isStoryNode"] = true,
			["key"] = "story_16893227077094",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 334,
				["y"] = 158
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
						["startQuest"] = "quest_16893227077108",
						["startPort"] = "QuestStart",
						["endQuest"] = "quest_1689322847229116",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1689322847229116",
						["startPort"] = "Out",
						["endQuest"] = "quest_168932270771010",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["quest_16893227077108"] = {
						["key"] = "quest_16893227077108",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 100,
							["y"] = 140
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_168932270771010"] = {
						["key"] = "quest_168932270771010",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1500,
							["y"] = 140
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_168932270771012"] = {
						["key"] = "quest_168932270771012",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["quest_1689322847229116"] = {
						["key"] = "quest_1689322847229116",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 450,
							["y"] = 113
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 70000501,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
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
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 81101,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "random",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["RandomOptionNum"] = 0,
							["RandomOptions"] = {},
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