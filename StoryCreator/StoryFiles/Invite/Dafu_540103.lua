return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17485896308493565760",
			["startPort"] = "StoryStart",
			["endStory"] = "17485896345763565908",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17485896345763565908",
			["startPort"] = "Success",
			["endStory"] = "17485896308493565763",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17485896308493565760"] = {
			["isStoryNode"] = true,
			["key"] = "17485896308493565760",
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
		["17485896308493565763"] = {
			["isStoryNode"] = true,
			["key"] = "17485896308493565763",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1686,
				["y"] = 304
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17485896345763565908"] = {
			["isStoryNode"] = true,
			["key"] = "17485896345763565908",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1242,
				["y"] = 304
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
						["startQuest"] = "1750409343631970496",
						["startPort"] = "Out",
						["endQuest"] = "1750409343630970495",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750409343631970497",
						["startPort"] = "Out",
						["endQuest"] = "1750409343631970498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750409343631970500",
						["startPort"] = "Out",
						["endQuest"] = "1750409343631970499",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485896345763565909",
						["startPort"] = "QuestStart",
						["endQuest"] = "1750409343631970497",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485896345763565909",
						["startPort"] = "QuestStart",
						["endQuest"] = "1750409343631970500",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750409470294971402",
						["startPort"] = "Out",
						["endQuest"] = "17485896345773565912",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1750409343631970499",
						["startPort"] = "Out",
						["endQuest"] = "1750409468415971352",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750409468415971352",
						["startPort"] = "Out",
						["endQuest"] = "1750409470294971402",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485896345763565909",
						["startPort"] = "QuestStart",
						["endQuest"] = "17504112098421938550",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17504112098421938550",
						["startPort"] = "Out",
						["endQuest"] = "1750409343631970496",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750409470294971402",
						["startPort"] = "Out",
						["endQuest"] = "1760409524790776",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17485896345763565909"] = {
						["key"] = "17485896345763565909",
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
					["17485896345773565912"] = {
						["key"] = "17485896345773565912",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2406,
							["y"] = 498
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17485896345773565915"] = {
						["key"] = "17485896345773565915",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1750409343630970495"] = {
						["key"] = "1750409343630970495",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1814,
							["y"] = 290.5
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 102101,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["1750409343631970496"] = {
						["key"] = "1750409343631970496",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1527,
							["y"] = 265.5
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80180301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_540103",
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
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790057,
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
					["1750409343631970497"] = {
						["key"] = "1750409343631970497",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1208,
							["y"] = 68.5
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
					["1750409343631970498"] = {
						["key"] = "1750409343631970498",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1525,
							["y"] = 91.5
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 103201,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["1750409343631970499"] = {
						["key"] = "1750409343631970499",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1518,
							["y"] = 474.5
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80180315,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_540103_1",
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
									["TalkActorId"] = 110029,
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
					["1750409343631970500"] = {
						["key"] = "1750409343631970500",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1212,
							["y"] = 488.5
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 102101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["1750409468415971352"] = {
						["key"] = "1750409468415971352",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1804,
							["y"] = 478
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80180321,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_540103_2",
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
									["TalkActorId"] = 110028,
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
					["1750409470294971402"] = {
						["key"] = "1750409470294971402",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2082,
							["y"] = 478
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80180331,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_540103_3",
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
									["TalkActorId"] = 110025,
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
					["17504112098421938550"] = {
						["key"] = "17504112098421938550",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1208,
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
					["1760409524790776"] = {
						["key"] = "1760409524790776",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2357.229341736694,
							["y"] = 643.8018207282915
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 1,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/mute",
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