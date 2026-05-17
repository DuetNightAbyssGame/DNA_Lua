return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1749799124754412",
			["startPort"] = "StoryStart",
			["endStory"] = "1749799127819466",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1749799127819466",
			["startPort"] = "Success",
			["endStory"] = "1749799124755415",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1749799124754412"] = {
			["isStoryNode"] = true,
			["key"] = "1749799124754412",
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
		["1749799124755415"] = {
			["isStoryNode"] = true,
			["key"] = "1749799124755415",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1794,
				["y"] = 320
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1749799127819466"] = {
			["isStoryNode"] = true,
			["key"] = "1749799127819466",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1280,
				["y"] = 298
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
						["startQuest"] = "1749799127819471",
						["startPort"] = "QuestStart",
						["endQuest"] = "1749799127819474",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749799127819471",
						["startPort"] = "QuestStart",
						["endQuest"] = "176008445662029241616",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749799127819474",
						["startPort"] = "Out",
						["endQuest"] = "176008446424729241814",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176008446424729241814",
						["startPort"] = "Out",
						["endQuest"] = "1749799127819472",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1749799127819471"] = {
						["key"] = "1749799127819471",
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
					["1749799127819472"] = {
						["key"] = "1749799127819472",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1326.7878532538246,
							["y"] = 276.75418431135313
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1749799127819473"] = {
						["key"] = "1749799127819473",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1553.5555555555557,
							["y"] = 437.16666666666663
						},
						["propsData"] = {}
					},
					["1749799127819474"] = {
						["key"] = "1749799127819474",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 686.0487012987002,
							["y"] = 274.23051948051966
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80090201,
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
									["TalkActorId"] = 92301,
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
					["176008445662029241616"] = {
						["key"] = "176008445662029241616",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 681.6464783281734,
							["y"] = 454.2844427244582
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 1,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0033_story_humour",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {}
						}
					},
					["176008446424729241814"] = {
						["key"] = "176008446424729241814",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1001.5313467492261,
							["y"] = 285.73181114551085
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