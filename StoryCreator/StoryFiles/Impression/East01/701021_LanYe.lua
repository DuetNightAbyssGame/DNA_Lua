return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17624155771799889301",
			["startPort"] = "StoryStart",
			["endStory"] = "17624155771799889303",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17624155771799889303",
			["startPort"] = "Success",
			["endStory"] = "17624155771799889302",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17624155771799889301"] = {
			["isStoryNode"] = true,
			["key"] = "17624155771799889301",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1014,
				["y"] = 322.25
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
		["17624155771799889302"] = {
			["isStoryNode"] = true,
			["key"] = "17624155771799889302",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1795,
				["y"] = 315
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17624155771799889303"] = {
			["isStoryNode"] = true,
			["key"] = "17624155771799889303",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1389.6428571428573,
				["y"] = 321.1487484289904
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
						["startQuest"] = "17624155771799889304",
						["startPort"] = "QuestStart",
						["endQuest"] = "17624155771799889307",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17624155771799889307",
						["startPort"] = "Out",
						["endQuest"] = "17624155771799889305",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17624155771799889307",
						["startPort"] = "Fail",
						["endQuest"] = "17624155771799889306",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17624155771799889304"] = {
						["key"] = "17624155771799889304",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 806,
							["y"] = 316
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17624155771799889305"] = {
						["key"] = "17624155771799889305",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1636,
							["y"] = 252
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17624155771799889306"] = {
						["key"] = "17624155771799889306",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1648.0000000000002,
							["y"] = 421.00000000000006
						},
						["propsData"] = {}
					},
					["17624155771799889307"] = {
						["key"] = "17624155771799889307",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1188.503105590062,
							["y"] = 312.08695652173907
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51117000,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_LanYe",
							["BlendInTime"] = 0.5,
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
									["TalkActorId"] = 701021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701022,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701023,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
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
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
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