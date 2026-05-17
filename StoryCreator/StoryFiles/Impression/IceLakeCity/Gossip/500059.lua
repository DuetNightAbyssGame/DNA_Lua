return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17439122412331929003",
			["startPort"] = "StoryStart",
			["endStory"] = "17439122412331929005",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17439122412331929005",
			["startPort"] = "Success",
			["endStory"] = "17439122412331929004",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17439122412331929003"] = {
			["isStoryNode"] = true,
			["key"] = "17439122412331929003",
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
		["17439122412331929004"] = {
			["isStoryNode"] = true,
			["key"] = "17439122412331929004",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1706,
				["y"] = 306
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17439122412331929005"] = {
			["isStoryNode"] = true,
			["key"] = "17439122412331929005",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1238,
				["y"] = 314
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
						["startQuest"] = "17439122412331929006",
						["startPort"] = "QuestStart",
						["endQuest"] = "17439122019911049061",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17439122019911049061",
						["startPort"] = "Out",
						["endQuest"] = "17439122412331929007",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17439122019911049061"] = {
						["key"] = "17439122019911049061",
						["type"] = "TalkNode",
						["name"] = "挖到了",
						["pos"] = {
							["x"] = 1342.58631713555,
							["y"] = 333.04507672634287
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10109701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101097",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
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
							["EndNewTargetPointName"] = "QuestPoint_SaiqiWalkStart",
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
									["TalkActorId"] = 200006,
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
					["17439122412331929006"] = {
						["key"] = "17439122412331929006",
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
					["17439122412331929007"] = {
						["key"] = "17439122412331929007",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1890,
							["y"] = 414
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17439122412331929008"] = {
						["key"] = "17439122412331929008",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17439122412331929009"] = {
						["key"] = "17439122412331929009",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1338.3478260869565,
							["y"] = 577.8260869565217
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51007930,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
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