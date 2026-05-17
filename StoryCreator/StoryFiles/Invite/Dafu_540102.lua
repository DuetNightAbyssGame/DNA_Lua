return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17485895940252971720",
			["startPort"] = "StoryStart",
			["endStory"] = "17485895978972971855",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17485895978972971855",
			["startPort"] = "Success",
			["endStory"] = "17485895940252971723",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17485895940252971720"] = {
			["isStoryNode"] = true,
			["key"] = "17485895940252971720",
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
		["17485895940252971723"] = {
			["isStoryNode"] = true,
			["key"] = "17485895940252971723",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1744,
				["y"] = 294
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17485895978972971855"] = {
			["isStoryNode"] = true,
			["key"] = "17485895978972971855",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1284,
				["y"] = 290
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
						["startQuest"] = "1750407924607844",
						["startPort"] = "Out",
						["endQuest"] = "17504079864701248",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485895978972971856",
						["startPort"] = "QuestStart",
						["endQuest"] = "17504080262701507",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17504080262701507",
						["startPort"] = "Out",
						["endQuest"] = "1750407924607843",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485895978972971856",
						["startPort"] = "QuestStart",
						["endQuest"] = "17504080272461526",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17504080272461526",
						["startPort"] = "Out",
						["endQuest"] = "17504080743582433",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17504080743582433",
						["startPort"] = "Out",
						["endQuest"] = "17485895978972971859",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17485895978972971856",
						["startPort"] = "QuestStart",
						["endQuest"] = "1750411155121646729",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750411155121646729",
						["startPort"] = "Out",
						["endQuest"] = "1750407924607844",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17504080272461526",
						["startPort"] = "Out",
						["endQuest"] = "1760171867976500",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17485895978972971856"] = {
						["key"] = "17485895978972971856",
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
					["17485895978972971859"] = {
						["key"] = "17485895978972971859",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1812,
							["y"] = 496
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17485895978972971862"] = {
						["key"] = "17485895978972971862",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1750407924607843"] = {
						["key"] = "1750407924607843",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1483,
							["y"] = 91
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 103201,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["1750407924607844"] = {
						["key"] = "1750407924607844",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1487,
							["y"] = 265
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80180201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_540102",
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
							["DoNotReceiveCharacterShadow"] = true,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790045,
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
									["TalkActorId"] = 790056,
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
					["17504079864701248"] = {
						["key"] = "17504079864701248",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1814,
							["y"] = 298
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101104,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17504080262701507"] = {
						["key"] = "17504080262701507",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1166,
							["y"] = 76
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
					["17504080272461526"] = {
						["key"] = "17504080272461526",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1164,
							["y"] = 478
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101104,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17504080743582433"] = {
						["key"] = "17504080743582433",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1484,
							["y"] = 474
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80180207,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_540102",
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
									["TalkActorId"] = 790045,
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
					["1750411155121646729"] = {
						["key"] = "1750411155121646729",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1168,
							["y"] = 274
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 103201,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["1760171867976500"] = {
						["key"] = "1760171867976500",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1462,
							["y"] = 804
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}