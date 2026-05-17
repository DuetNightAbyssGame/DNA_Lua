return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17333935029514327567",
			["startPort"] = "StoryStart",
			["endStory"] = "1733393155142640644",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1733393155142640644",
			["startPort"] = "Success",
			["endStory"] = "17333935029514327568",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1733393155142640644"] = {
			["isStoryNode"] = true,
			["key"] = "1733393155142640644",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1125.448275862069,
				["y"] = 288.0689655172414
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
						["startQuest"] = "1733393155142640648",
						["startPort"] = "QuestStart",
						["endQuest"] = "1733393155142640651",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1733393155142640648",
						["startPort"] = "QuestStart",
						["endQuest"] = "176008143312118037889",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1733393155142640651",
						["startPort"] = "Out",
						["endQuest"] = "176008144799218038292",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176008144799218038292",
						["startPort"] = "Out",
						["endQuest"] = "1733393155142640649",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1733393155142640648"] = {
						["key"] = "1733393155142640648",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 353.3374384236454,
							["y"] = 288.5451559934318
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1733393155142640649"] = {
						["key"] = "1733393155142640649",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1290.804646639814,
							["y"] = 275.1773038212077
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1733393155142640650"] = {
						["key"] = "1733393155142640650",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1553.5555555555557,
							["y"] = 437.16666666666663
						},
						["propsData"] = {}
					},
					["1733393155142640651"] = {
						["key"] = "1733393155142640651",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 670.75,
							["y"] = 275.125
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80130101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_Invite",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
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
									["TalkActorId"] = 93103,
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
					},
					["176008143312118037889"] = {
						["key"] = "176008143312118037889",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 678.9032660703141,
							["y"] = 441.8501144164762
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 1,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0016_judian",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {}
						}
					},
					["176008144799218038292"] = {
						["key"] = "176008144799218038292",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 961.9467443311838,
							["y"] = 287.9370709382152
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 1,
							["SoundType"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17333935029514327567"] = {
			["isStoryNode"] = true,
			["key"] = "17333935029514327567",
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
		["17333935029514327568"] = {
			["isStoryNode"] = true,
			["key"] = "17333935029514327568",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1435.111111111111,
				["y"] = 298.44444444444446
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