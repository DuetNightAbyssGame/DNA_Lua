return {
	["storyName"] = "未命名故事",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_16842233096413719",
			["startPort"] = "StoryStart",
			["endStory"] = "story_16842233096423723",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_16842233096423723",
			["startPort"] = "Success",
			["endStory"] = "story_16842233096413721",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["story_16842233096413719"] = {
			["isStoryNode"] = true,
			["key"] = "story_16842233096413719",
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
		["story_16842233096413721"] = {
			["isStoryNode"] = true,
			["key"] = "story_16842233096413721",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 840.4545454545455,
				["y"] = 144.0909090909091
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_16842233096423723"] = {
			["isStoryNode"] = true,
			["key"] = "story_16842233096423723",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 425.4545454545455,
				["y"] = 118.18181818181819
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
						["startQuest"] = "quest_16842233096423727",
						["startPort"] = "QuestStart",
						["endQuest"] = "1716173804353118622",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1716173804353118622",
						["startPort"] = "Out",
						["endQuest"] = "quest_16842233096423731",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["quest_16842233096423727"] = {
						["key"] = "quest_16842233096423727",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -6.500000000000014,
							["y"] = 966.35
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_16842233096423729"] = {
						["key"] = "quest_16842233096423729",
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
					["quest_16842233096423731"] = {
						["key"] = "quest_16842233096423731",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 809.3499999999999,
							["y"] = 974.3857142857144
						},
						["propsData"] = {}
					},
					["1716173804353118622"] = {
						["key"] = "1716173804353118622",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 410.30020313321575,
							["y"] = 988.5480515412064
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10100301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "DefaultStage",
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
							["HideAllBattleEntity"] = false,
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
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