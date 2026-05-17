return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17328641731317351078",
			["startPort"] = "StoryStart",
			["endStory"] = "17328641731317351080",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17328641731317351080",
			["startPort"] = "Success",
			["endStory"] = "17328641731317351079",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17328641731317351078"] = {
			["isStoryNode"] = true,
			["key"] = "17328641731317351078",
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
		["17328641731317351079"] = {
			["isStoryNode"] = true,
			["key"] = "17328641731317351079",
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
		["17328641731317351080"] = {
			["isStoryNode"] = true,
			["key"] = "17328641731317351080",
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
						["startQuest"] = "17328641731317351084",
						["startPort"] = "Out",
						["endQuest"] = "17328641731317351085",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17328633597343114521",
						["startPort"] = "Out",
						["endQuest"] = "17328641353996229933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17328641731317351081",
						["startPort"] = "QuestStart",
						["endQuest"] = "17328641731317351084",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17328641731317351085",
						["startPort"] = "Out",
						["endQuest"] = "17328633597343114521",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17328641731317351081",
						["startPort"] = "QuestStart",
						["endQuest"] = "176008420383726750698",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17328641353996229933",
						["startPort"] = "Out",
						["endQuest"] = "176008421106126750960",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176008421106126750960",
						["startPort"] = "Out",
						["endQuest"] = "17328641731317351082",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17328633597343114521"] = {
						["key"] = "17328633597343114521",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1181.2626262626263,
							["y"] = 275.0202020202021
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80120203,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_330102",
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
									["TalkActorId"] = 790022,
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
									["TalkActorId"] = 790019,
									["TalkActorVisible"] = true,
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
					["17328641353996229933"] = {
						["key"] = "17328641353996229933",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1453.4848484848485,
							["y"] = 269.46464646464636
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80120230,
							["FlowAssetPath"] = "",
							["TalkType"] = "BlackISS",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 1,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17328641731317351081"] = {
						["key"] = "17328641731317351081",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 387.25048190190626,
							["y"] = 278.11037338473614
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17328641731317351082"] = {
						["key"] = "17328641731317351082",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2005.601888341544,
							["y"] = 293.3003831417625
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17328641731317351083"] = {
						["key"] = "17328641731317351083",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1562.4444444444446,
							["y"] = 597.1666666666666
						},
						["propsData"] = {}
					},
					["17328641731317351084"] = {
						["key"] = "17328641731317351084",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 636.3055555555555,
							["y"] = 277.34722222222223
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80120201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_330102",
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
									["TalkActorId"] = 790019,
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
									["TalkActorId"] = 790022,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790020,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790021,
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
					["17328641731317351085"] = {
						["key"] = "17328641731317351085",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 908.2638888888888,
							["y"] = 278.15277777777777
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80120202,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 1,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["176008420383726750698"] = {
						["key"] = "176008420383726750698",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 641.4127450980392,
							["y"] = 445.329513681903
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 1,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0024_story_pub",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {}
						}
					},
					["176008421106126750960"] = {
						["key"] = "176008421106126750960",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1723.8127450980394,
							["y"] = 290.529513681903
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