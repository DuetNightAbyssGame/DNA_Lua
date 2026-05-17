return {
	["storyName"] = "未命名故事",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1745392492872278999",
			["startPort"] = "StoryStart",
			["endStory"] = "1745392492872279001",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1745392492872279001",
			["startPort"] = "Success",
			["endStory"] = "1745392492872279000",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1745392492872278999"] = {
			["isStoryNode"] = true,
			["key"] = "1745392492872278999",
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
		["1745392492872279000"] = {
			["isStoryNode"] = true,
			["key"] = "1745392492872279000",
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
		["1745392492872279001"] = {
			["isStoryNode"] = true,
			["key"] = "1745392492872279001",
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
						["startQuest"] = "1745392492872279006",
						["startPort"] = "Out",
						["endQuest"] = "1745392492872279007",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745392492872279009",
						["startPort"] = "Out",
						["endQuest"] = "1745392492872279012",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745392492872279002",
						["startPort"] = "QuestStart",
						["endQuest"] = "1745392492872279013",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745392492872279013",
						["startPort"] = "Out",
						["endQuest"] = "1745392492872279003",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1745392492872279002"] = {
						["key"] = "1745392492872279002",
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
					["1745392492872279003"] = {
						["key"] = "1745392492872279003",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 712.5000000000003,
							["y"] = 1066.2499999999993
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1745392492872279004"] = {
						["key"] = "1745392492872279004",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 809.3499999999999,
							["y"] = 974.3857142857144
						},
						["propsData"] = {}
					},
					["1745392492872279005"] = {
						["key"] = "1745392492872279005",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 453.76363636363635,
							["y"] = 242
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10010116,
							["FlowAssetPath"] = "",
							["TalkType"] = "HintGuide",
							["OverrideFailBlend"] = false
						}
					},
					["1745392492872279006"] = {
						["key"] = "1745392492872279006",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 529.1561073852763,
							["y"] = -130.27268778149386
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					},
					["1745392492872279007"] = {
						["key"] = "1745392492872279007",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 855.1662083953772,
							["y"] = -125.92925343805948
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10010116,
							["FlowAssetPath"] = "",
							["TalkType"] = "HintGuide",
							["OverrideFailBlend"] = false
						}
					},
					["1745392492872279008"] = {
						["key"] = "1745392492872279008",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 852.5123949641911,
							["y"] = 1114.5304153099025
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1110010303,
							["GuideType"] = "M",
							["GuidePointName"] = "QuestTrigger0303"
						}
					},
					["1745392492872279009"] = {
						["key"] = "1745392492872279009",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 222.77940539231543,
							["y"] = 758.2243769885861
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1111010201,
							["GuideType"] = "M",
							["GuidePointName"] = "QuestTrigger0304"
						}
					},
					["1745392492872279010"] = {
						["key"] = "1745392492872279010",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 903.5604818419372,
							["y"] = 522.9188219177707
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1110010302,
							["GuideType"] = "M",
							["GuidePointName"] = "QuestTrigger0302"
						}
					},
					["1745392492872279011"] = {
						["key"] = "1745392492872279011",
						["type"] = "TalkNode",
						["name"] = "因鲜血而震颤",
						["pos"] = {
							["x"] = 523.7568821456825,
							["y"] = 443.55425824064355
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11010207,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_02",
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
									["TalkActorId"] = 110022,
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
					["1745392492872279012"] = {
						["key"] = "1745392492872279012",
						["type"] = "TalkNode",
						["name"] = "因鲜血而震颤",
						["pos"] = {
							["x"] = 538.9198490344177,
							["y"] = 751.3007064451126
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11010207,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_02",
							["BlendInTime"] = 0,
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
									["TalkActorId"] = 110022,
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
					["1745392492872279013"] = {
						["key"] = "1745392492872279013",
						["type"] = "TalkNode",
						["name"] = "对话节点1000031",
						["pos"] = {
							["x"] = 410.30020313321575,
							["y"] = 988.5480515412064
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10029401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
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