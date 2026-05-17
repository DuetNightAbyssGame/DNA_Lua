return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1721630101563342055",
			["startPort"] = "StoryStart",
			["endStory"] = "1721630101563342057",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1721630101563342057",
			["startPort"] = "Success",
			["endStory"] = "1721630101563342056",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1721630101563342055"] = {
			["isStoryNode"] = true,
			["key"] = "1721630101563342055",
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
		["1721630101563342056"] = {
			["isStoryNode"] = true,
			["key"] = "1721630101563342056",
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
		["1721630101563342057"] = {
			["isStoryNode"] = true,
			["key"] = "1721630101563342057",
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
						["startQuest"] = "1721630101563342061",
						["startPort"] = "Out",
						["endQuest"] = "1725259835809206624",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1725259835809206624",
						["startPort"] = "Out",
						["endQuest"] = "1721630101563342059",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1721630101563342058",
						["startPort"] = "QuestStart",
						["endQuest"] = "17528197454788346628",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1721630101563342058",
						["startPort"] = "QuestStart",
						["endQuest"] = "17528197454788346629",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528197454788346628",
						["startPort"] = "Out",
						["endQuest"] = "17376303254175232032",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528197454788346629",
						["startPort"] = "Out",
						["endQuest"] = "1721630101563342061",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528197454788346629",
						["startPort"] = "Out",
						["endQuest"] = "1725259813489206196",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1721630101563342058"] = {
						["key"] = "1721630101563342058",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 508.42857142857144,
							["y"] = 297
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1721630101563342059"] = {
						["key"] = "1721630101563342059",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1596.464285714286,
							["y"] = 279.85714285714283
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1721630101563342060"] = {
						["key"] = "1721630101563342060",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1572.0000000000002,
							["y"] = 434.5
						},
						["propsData"] = {}
					},
					["1721630101563342061"] = {
						["key"] = "1721630101563342061",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1075.446944359988,
							["y"] = 274.0288250396945
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80070201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_430102",
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
									["TalkActorId"] = 790014,
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
									["TalkActorId"] = 790013,
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
					["1725259813489206196"] = {
						["key"] = "1725259813489206196",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1079.4876847290645,
							["y"] = 431.5369458128082
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 1,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0036_story_renweidaozu",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {}
						}
					},
					["1725259835809206624"] = {
						["key"] = "1725259835809206624",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1330.9162561576359,
							["y"] = 278.6798029556653
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 1,
							["SoundType"] = 0
						}
					},
					["17376303254175232032"] = {
						["key"] = "17376303254175232032",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1083.7233201581025,
							["y"] = 138.6521739130435
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101104,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17528197454788346628"] = {
						["key"] = "17528197454788346628",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 796.7871064467766,
							["y"] = 131.90442278860564
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
					["17528197454788346629"] = {
						["key"] = "17528197454788346629",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 797.8215892053972,
							["y"] = 327.42166416791616
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101104,
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