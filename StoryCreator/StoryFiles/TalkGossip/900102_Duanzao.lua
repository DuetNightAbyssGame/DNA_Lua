return {
	["storyName"] = "未命名任务",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_16842233104878084",
			["startPort"] = "StoryStart",
			["endStory"] = "story_16842233104878088",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_16842233104878088",
			["startPort"] = "Success",
			["endStory"] = "story_16842233104878086",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["story_16842233104878084"] = {
			["isStoryNode"] = true,
			["key"] = "story_16842233104878084",
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
		["story_16842233104878086"] = {
			["isStoryNode"] = true,
			["key"] = "story_16842233104878086",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 748.75,
				["y"] = 135
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_16842233104878088"] = {
			["isStoryNode"] = true,
			["key"] = "story_16842233104878088",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 426.25,
				["y"] = 160
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
						["startQuest"] = "quest_16842233104888100",
						["startPort"] = "Option_1",
						["endQuest"] = "quest_16842233104898105",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16842233104878092",
						["startPort"] = "QuestStart",
						["endQuest"] = "quest_16842233104888100",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16842233104898105",
						["startPort"] = "Out",
						["endQuest"] = "quest_16842233104878094",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "quest_16842233104888100",
						["startPort"] = "Option_2",
						["endQuest"] = "quest_16842233104878094",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["quest_16842233104878092"] = {
						["key"] = "quest_16842233104878092",
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
					["quest_16842233104878094"] = {
						["key"] = "quest_16842233104878094",
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
					["quest_16842233104878096"] = {
						["key"] = "quest_16842233104878096",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["quest_16842233104888100"] = {
						["key"] = "quest_16842233104888100",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 425.8925497507369,
							["y"] = 105.80788059823145
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 90010201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_700002",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
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
							["NormalOptions"] = {
								{
									["OptionText"] = "900103011",
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								},
								{
									["OptionText"] = "900103012",
									["OverrideBlend"] = true,
									["OverrideOutype"] = "BlendOut",
									["OverrideOutTime"] = 0.5
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["quest_16842233104898105"] = {
						["key"] = "quest_16842233104898105",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 805.6931495309154,
							["y"] = 105.17149004985261
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 90010301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_700015",
							["BlendInTime"] = 0,
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
		}
	},
	["commentData"] = {}
}