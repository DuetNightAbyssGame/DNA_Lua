return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732783210610494875",
			["startPort"] = "StoryStart",
			["endStory"] = "1732783210610494877",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732783210610494877",
			["startPort"] = "Success",
			["endStory"] = "1732783210610494876",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732783210610494875"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210610494875",
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
		["1732783210610494876"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210610494876",
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
		},
		["1732783210610494877"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210610494877",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1102.888888888889,
				["y"] = 288.44444444444446
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
						["startQuest"] = "1732783210610494881",
						["startPort"] = "Out",
						["endQuest"] = "1725258819331197321",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1725258819331197321",
						["startPort"] = "Out",
						["endQuest"] = "1732783210610494879",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1732783210610494878",
						["startPort"] = "QuestStart",
						["endQuest"] = "17528085774612890974",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528085774612890974",
						["startPort"] = "Out",
						["endQuest"] = "17376224323743736483",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210610494878",
						["startPort"] = "QuestStart",
						["endQuest"] = "17528085988662891705",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528085988662891705",
						["startPort"] = "Out",
						["endQuest"] = "1732783210610494881",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528085988662891705",
						["startPort"] = "Out",
						["endQuest"] = "1725246375878179820",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1725246375878179820"] = {
						["key"] = "1725246375878179820",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1080.0689655172414,
							["y"] = 448.41379310344826
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
					["1725258819331197321"] = {
						["key"] = "1725258819331197321",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1339.9305418719216,
							["y"] = 277.594088669951
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 1,
							["SoundType"] = 0
						}
					},
					["1732783210610494878"] = {
						["key"] = "1732783210610494878",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 529.6476190476191,
							["y"] = 207.76825396825393
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210610494879"] = {
						["key"] = "1732783210610494879",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1611.6214285714289,
							["y"] = 279.1285714285714
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210610494880"] = {
						["key"] = "1732783210610494880",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1608.0000000000002,
							["y"] = 418.9
						},
						["propsData"] = {}
					},
					["1732783210610494881"] = {
						["key"] = "1732783210610494881",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1069.1171306953918,
							["y"] = 282.78658901484977
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80040101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_110101",
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
									["TalkActorId"] = 790007,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790008,
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
					["17376224323743736483"] = {
						["key"] = "17376224323743736483",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1123.3142857142855,
							["y"] = 95.96666666666673
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 100101,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17528085774612890974"] = {
						["key"] = "17528085774612890974",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 803.2984354826459,
							["y"] = 75.38251879699251
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17528085988662891705"] = {
						["key"] = "17528085988662891705",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 804.409546593757,
							["y"] = 323.16029657477026
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 100101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}