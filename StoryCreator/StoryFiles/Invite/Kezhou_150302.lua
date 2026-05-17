return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17581774010861056767",
			["startPort"] = "StoryStart",
			["endStory"] = "17581774010861056769",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17581774010861056769",
			["startPort"] = "Success",
			["endStory"] = "17581774010861056768",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17581774010861056767"] = {
			["isStoryNode"] = true,
			["key"] = "17581774010861056767",
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
		["17581774010861056768"] = {
			["isStoryNode"] = true,
			["key"] = "17581774010861056768",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1606,
				["y"] = 294
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17581774010861056769"] = {
			["isStoryNode"] = true,
			["key"] = "17581774010861056769",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1202,
				["y"] = 292
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
						["startQuest"] = "1758712814180803",
						["startPort"] = "Out",
						["endQuest"] = "1758712814180804",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758712814180805",
						["startPort"] = "Out",
						["endQuest"] = "1758712814180802",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17581774010871056770",
						["startPort"] = "QuestStart",
						["endQuest"] = "1758712814180803",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758712814180802",
						["startPort"] = "Out",
						["endQuest"] = "17581774010871056771",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17581774010871056770",
						["startPort"] = "QuestStart",
						["endQuest"] = "1758712814180805",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17581774010871056770"] = {
						["key"] = "17581774010871056770",
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
					["17581774010871056771"] = {
						["key"] = "17581774010871056771",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1977.6470588235295,
							["y"] = 480
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17581774010871056772"] = {
						["key"] = "17581774010871056772",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1758712814180802"] = {
						["key"] = "1758712814180802",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1609.6341992252487,
							["y"] = 479.23185487356295
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80210201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_150302",
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
									["TalkActorId"] = 790067,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790068,
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
					["1758712814180803"] = {
						["key"] = "1758712814180803",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1205.1178610191387,
							["y"] = 269.2093215970251
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
					["1758712814180804"] = {
						["key"] = "1758712814180804",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1588.8425342217533,
							["y"] = 278.1570340153258
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104110,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["1758712814180805"] = {
						["key"] = "1758712814180805",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1204.924624304163,
							["y"] = 475.8566645921941
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104110,
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