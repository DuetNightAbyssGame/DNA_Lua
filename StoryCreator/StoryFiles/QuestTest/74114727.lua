return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17339875892943971128",
			["startPort"] = "StoryStart",
			["endStory"] = "17339875892943971127",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17339875892943971127",
			["startPort"] = "Success",
			["endStory"] = "17339875892943971129",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17339875892943971127"] = {
			["isStoryNode"] = true,
			["key"] = "17339875892943971127",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1105.5714285714287,
				["y"] = 296.92857142857144
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
						["startQuest"] = "17339875892943971130",
						["startPort"] = "QuestStart",
						["endQuest"] = "17339875892943971133",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17339875892943971133",
						["startPort"] = "Out",
						["endQuest"] = "17339875892943971131",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17339875892943971130"] = {
						["key"] = "17339875892943971130",
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
					["17339875892943971131"] = {
						["key"] = "17339875892943971131",
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
					["17339875892943971132"] = {
						["key"] = "17339875892943971132",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17339875892943971133"] = {
						["key"] = "17339875892943971133",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1179.034923538793,
							["y"] = 290.7121212121212
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 741148101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Kawaii27",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
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
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 74114753,
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
		},
		["17339875892943971128"] = {
			["isStoryNode"] = true,
			["key"] = "17339875892943971128",
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
		["17339875892943971129"] = {
			["isStoryNode"] = true,
			["key"] = "17339875892943971129",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1417.5714285714287,
				["y"] = 291.57142857142856
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}