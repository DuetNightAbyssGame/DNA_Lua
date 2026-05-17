return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17497005605521",
			["startPort"] = "StoryStart",
			["endStory"] = "1749707717765687",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1749707717765687",
			["startPort"] = "Success",
			["endStory"] = "17497005605525",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17497005605521"] = {
			["isStoryNode"] = true,
			["key"] = "17497005605521",
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
		["17497005605525"] = {
			["isStoryNode"] = true,
			["key"] = "17497005605525",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1738,
				["y"] = 306
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1749707717765687"] = {
			["isStoryNode"] = true,
			["key"] = "1749707717765687",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1234.6363636363637,
				["y"] = 290.00000000000006
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
						["startQuest"] = "1749707717765692",
						["startPort"] = "QuestStart",
						["endQuest"] = "1749707717765695",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749707717765692",
						["startPort"] = "QuestStart",
						["endQuest"] = "176008115203014305596",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749707717765695",
						["startPort"] = "Out",
						["endQuest"] = "176008116915514305837",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176008116915514305837",
						["startPort"] = "Out",
						["endQuest"] = "1749707717765693",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1749707717765692"] = {
						["key"] = "1749707717765692",
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
					["1749707717765693"] = {
						["key"] = "1749707717765693",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1247.3352216748772,
							["y"] = 292.9226053639847
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1749707717765694"] = {
						["key"] = "1749707717765694",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1553.5555555555557,
							["y"] = 437.16666666666663
						},
						["propsData"] = {}
					},
					["1749707717765695"] = {
						["key"] = "1749707717765695",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 689.7987012987002,
							["y"] = 277.98051948051966
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80170101,
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
									["TalkActorId"] = 91502,
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
					["176008115203014305596"] = {
						["key"] = "176008115203014305596",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 684.4674566851913,
							["y"] = 439.50751879699243
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 1,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0017_story_incave",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {}
						}
					},
					["176008116915514305837"] = {
						["key"] = "176008116915514305837",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 965.2674566851912,
							["y"] = 291.9075187969924
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
		}
	},
	["commentData"] = {}
}