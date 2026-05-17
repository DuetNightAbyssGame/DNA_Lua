return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17394142337881706",
			["startPort"] = "StoryStart",
			["endStory"] = "17394142497151901",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17394142497151901",
			["startPort"] = "Success",
			["endStory"] = "1745415975410273834",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1745415975410273834",
			["startPort"] = "Success",
			["endStory"] = "1745415990473274274",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1745415990473274274",
			["startPort"] = "Success",
			["endStory"] = "17456575621327261",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174687711753614252462",
			["startPort"] = "Success",
			["endStory"] = "17394142337881709",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17456575621327261",
			["startPort"] = "Success",
			["endStory"] = "175195993301219061",
			["endPort"] = "In"
		},
		{
			["startStory"] = "175195993301219061",
			["startPort"] = "Success",
			["endStory"] = "174687711753614252462",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17394142337881706"] = {
			["isStoryNode"] = true,
			["key"] = "17394142337881706",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 200103
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17394142337881709"] = {
			["isStoryNode"] = true,
			["key"] = "17394142337881709",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2627.4700854700855,
				["y"] = 334.41968759210135
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17394142497151901"] = {
			["isStoryNode"] = true,
			["key"] = "17394142497151901",
			["type"] = "StoryNode",
			["name"] = "据点小白对话",
			["pos"] = {
				["x"] = 1124.3846153846152,
				["y"] = 319.61538461538464
			},
			["propsData"] = {
				["QuestId"] = 20010301,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200103_1",
				["QuestDeatil"] = "Content_200103_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
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
				["SubRegionId"] = 210101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "TargetPoint_HomeBase",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1739414427555767717",
						["startPort"] = "Out",
						["endQuest"] = "1739414667587768204",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17394142497151902",
						["startPort"] = "QuestStart",
						["endQuest"] = "17435950839101060958",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17435950839101060958",
						["startPort"] = "Out",
						["endQuest"] = "1744448971022807265",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1744448971022807265",
						["startPort"] = "Out",
						["endQuest"] = "1744449119567808313",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1744449119567808313",
						["startPort"] = "Out",
						["endQuest"] = "1744448794285323",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1744448794285323",
						["startPort"] = "Out",
						["endQuest"] = "17457653715419930329",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1744449119567808313",
						["startPort"] = "Out",
						["endQuest"] = "1748933879119883582",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457653715419930329",
						["startPort"] = "Out",
						["endQuest"] = "1748933934498883981",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1748933934498883981",
						["startPort"] = "Out",
						["endQuest"] = "17394142497151905",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17394142497151902"] = {
						["key"] = "17394142497151902",
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
					["17394142497151905"] = {
						["key"] = "17394142497151905",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2665.5345543345547,
							["y"] = 307.66398046398047
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17394142497151908"] = {
						["key"] = "17394142497151908",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1605.7142857142858,
							["y"] = 432
						},
						["propsData"] = {}
					},
					["1739414427555767717"] = {
						["key"] = "1739414427555767717",
						["type"] = "GoToRegionNode",
						["name"] = "进入冰湖城",
						["pos"] = {
							["x"] = 1094.3809523809523,
							["y"] = 34.22222222222217
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_icelakecity"
						}
					},
					["1739414667587768204"] = {
						["key"] = "1739414667587768204",
						["type"] = "WaitOfTimeNode",
						["name"] = "等1S",
						["pos"] = {
							["x"] = 1352.144140989729,
							["y"] = 76.33963585434174
						},
						["propsData"] = {
							["WaitTime"] = 0
						}
					},
					["17435950839101060958"] = {
						["key"] = "17435950839101060958",
						["type"] = "GoToRegionNode",
						["name"] = "进入据点",
						["pos"] = {
							["x"] = 1068.6818818436466,
							["y"] = 302.4748323571854
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_HomeBase"
						}
					},
					["1744448794285323"] = {
						["key"] = "1744448794285323",
						["type"] = "TalkNode",
						["name"] = "不好啦",
						["pos"] = {
							["x"] = 1823.3626373626373,
							["y"] = 279.6373626373625
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20004801,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200048",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
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
					["1744448971022807265"] = {
						["key"] = "1744448971022807265",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "创建小白",
						["pos"] = {
							["x"] = 1330.6703296703295,
							["y"] = 315.40659340659334
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1210093
							}
						}
					},
					["1744449007926807872"] = {
						["key"] = "1744449007926807872",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "挂指引点",
						["pos"] = {
							["x"] = 1434.5164835164835,
							["y"] = 741.1758241758241
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_200048Bai_1210093"
						}
					},
					["1744449119567808313"] = {
						["key"] = "1744449119567808313",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1577.5934065934068,
							["y"] = 269.2527472527471
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1210105,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_200048Bai_1210093"
						}
					},
					["17457653715419930329"] = {
						["key"] = "17457653715419930329",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁小白",
						["pos"] = {
							["x"] = 2119.3376623376626,
							["y"] = 290.46493506493493
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1210093
							}
						}
					},
					["1748933879119883582"] = {
						["key"] = "1748933879119883582",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放幽默音乐",
						["pos"] = {
							["x"] = 1837.848484848485,
							["y"] = 143.21212121212125
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0033_story_humour",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["SoundUnitKey"] = "pet_story_humour"
						}
					},
					["1748933934498883981"] = {
						["key"] = "1748933934498883981",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "暂停幽默音乐",
						["pos"] = {
							["x"] = 2375.6262626262624,
							["y"] = 305.4343434343434
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundUnitKey"] = "pet_story_humour"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1745415975410273834"] = {
			["isStoryNode"] = true,
			["key"] = "1745415975410273834",
			["type"] = "StoryNode",
			["name"] = "冰湖对话",
			["pos"] = {
				["x"] = 1361.0571374277893,
				["y"] = 315.89007057016204
			},
			["propsData"] = {
				["QuestId"] = 20010302,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200103_2",
				["QuestDeatil"] = "Content_200103_2",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "P200051Nvzhu1",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1745415975410273839",
						["startPort"] = "QuestStart",
						["endQuest"] = "1745415975410273842",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455115606202746224",
						["startPort"] = "Out",
						["endQuest"] = "17455027470611100122",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745415975410273842",
						["startPort"] = "Out",
						["endQuest"] = "17455118312154393467",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455118312154393467",
						["startPort"] = "Out",
						["endQuest"] = "1745491798277276829",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745491798277276829",
						["startPort"] = "Out",
						["endQuest"] = "17455119336674394367",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455119336674394367",
						["startPort"] = "Out",
						["endQuest"] = "17455115606202746224",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745491798277276829",
						["startPort"] = "Out",
						["endQuest"] = "17455119507434394748",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455027470611100122",
						["startPort"] = "Out",
						["endQuest"] = "17455121152954395444",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455027470611100122",
						["startPort"] = "Out",
						["endQuest"] = "174576929982815713574",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455121152954395444",
						["startPort"] = "Out",
						["endQuest"] = "174576930431415713749",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174576930431415713749",
						["startPort"] = "Out",
						["endQuest"] = "1746847631992845130",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "1746847631992845130",
						["startPort"] = "Out",
						["endQuest"] = "1745415975410273840",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1745491798277276829",
						["startPort"] = "Out",
						["endQuest"] = "174687696102513401004",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455118312154393467",
						["startPort"] = "Out",
						["endQuest"] = "17489343539003509289",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745491798277276829",
						["startPort"] = "Out",
						["endQuest"] = "17489343539003509290",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455119336674394367",
						["startPort"] = "Out",
						["endQuest"] = "17489343647973509704",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455121152954395444",
						["startPort"] = "Out",
						["endQuest"] = "17489343647973509705",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17489343647973509705",
						["startPort"] = "Out",
						["endQuest"] = "1746847631992845130",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "17455121152954395444",
						["startPort"] = "Out",
						["endQuest"] = "17568006622192137",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17568006622192137",
						["startPort"] = "Out",
						["endQuest"] = "1746847631992845130",
						["endPort"] = "Input_2"
					}
				},
				["nodeData"] = {
					["1745415975410273839"] = {
						["key"] = "1745415975410273839",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 741.4285714285714,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1745415975410273840"] = {
						["key"] = "1745415975410273840",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3433.3186813186812,
							["y"] = 259.3846153846154
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1745415975410273841"] = {
						["key"] = "1745415975410273841",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2369.3809523809523,
							["y"] = 754.6666666666666
						},
						["propsData"] = {}
					},
					["1745415975410273842"] = {
						["key"] = "1745415975410273842",
						["type"] = "GoToRegionNode",
						["name"] = "进入冰湖",
						["pos"] = {
							["x"] = 1002.5952380952382,
							["y"] = 292.07936507936506
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "P200051Nvzhu1"
						}
					},
					["1745415975410273843"] = {
						["key"] = "1745415975410273843",
						["type"] = "WaitOfTimeNode",
						["name"] = "等1S",
						["pos"] = {
							["x"] = 1800.8584267040148,
							["y"] = 765.482492997199
						},
						["propsData"] = {
							["WaitTime"] = 0
						}
					},
					["1745491798277276829"] = {
						["key"] = "1745491798277276829",
						["type"] = "TalkNode",
						["name"] = "野猪呢？",
						["pos"] = {
							["x"] = 1477.6646182764605,
							["y"] = 300.00156641604013
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005001,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200050",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
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
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700261,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700262,
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
					["17455027470611100122"] = {
						["key"] = "17455027470611100122",
						["type"] = "TalkNode",
						["name"] = "你们是在",
						["pos"] = {
							["x"] = 2227.0260398203945,
							["y"] = 297.7200017724211
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "LevelSequence'/Game/AssetDesign/Story/Sequence/Chapter01/IceLakeCity/CatchPet.CatchPet'",
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = false,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = false,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17455115606202746224"] = {
						["key"] = "17455115606202746224",
						["type"] = "TalkNode",
						["name"] = "你们是在",
						["pos"] = {
							["x"] = 1974.1927064870608,
							["y"] = 306.55333510575434
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200051",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
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
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700261,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700262,
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
					["17455118312154393467"] = {
						["key"] = "17455118312154393467",
						["type"] = "GoToNode",
						["name"] = "去野猪出现地",
						["pos"] = {
							["x"] = 1246.1212779156322,
							["y"] = 301.1009541533735
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240787,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_PetQuestTrigger_1240787"
						}
					},
					["17455119336674394367"] = {
						["key"] = "17455119336674394367",
						["type"] = "GoToNode",
						["name"] = "去火箭队旁边",
						["pos"] = {
							["x"] = 1713.6427739634441,
							["y"] = 300.49395588848046
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240788,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_200050XiaoCiLang_1240784"
						}
					},
					["17455119507434394748"] = {
						["key"] = "17455119507434394748",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成火箭队",
						["pos"] = {
							["x"] = 1452.1530239473782,
							["y"] = 158.6009541533734
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1241123,
								1241124
							}
						}
					},
					["17455121152954395444"] = {
						["key"] = "17455121152954395444",
						["type"] = "TalkNode",
						["name"] = "有一只没见过",
						["pos"] = {
							["x"] = 2586.026039820394,
							["y"] = 300.05333510575446
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005212,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200052",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
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
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200075,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200087,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200086,
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
					["174576929982815713574"] = {
						["key"] = "174576929982815713574",
						["type"] = "SendMessageNode",
						["name"] = "宠物被抓",
						["pos"] = {
							["x"] = 2611.864734299516,
							["y"] = 170.04921497584553
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Catch",
							["UnitId"] = -1
						}
					},
					["174576930431415713749"] = {
						["key"] = "174576930431415713749",
						["type"] = "SendMessageNode",
						["name"] = "宠物被抓",
						["pos"] = {
							["x"] = 2873.531400966183,
							["y"] = 169.49365942028993
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Catch",
							["UnitId"] = -1
						}
					},
					["1746847631992845130"] = {
						["key"] = "1746847631992845130",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待前置任务",
						["pos"] = {
							["x"] = 3151.588007971001,
							["y"] = 245.9152177390667
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["174687696102513401004"] = {
						["key"] = "174687696102513401004",
						["type"] = "TalkNode",
						["name"] = "不是的话我们就回去",
						["pos"] = {
							["x"] = 1425.2653867871256,
							["y"] = 23.233766233766232
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17489343539003509289"] = {
						["key"] = "17489343539003509289",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放幽默音乐",
						["pos"] = {
							["x"] = 1239.4849302744044,
							["y"] = 469.77198605488087
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0033_story_humour",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["SoundUnitKey"] = "pet_story_humour"
						}
					},
					["17489343539003509290"] = {
						["key"] = "17489343539003509290",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "暂停幽默音乐",
						["pos"] = {
							["x"] = 1485.2817942291629,
							["y"] = 479.0300671550672
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundUnitKey"] = "pet_story_humour"
						}
					},
					["17489343647973509704"] = {
						["key"] = "17489343647973509704",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放幽默音乐",
						["pos"] = {
							["x"] = 1724.9969474969482,
							["y"] = 468.239468864469
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0033_story_humour",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["SoundUnitKey"] = "pet_story_humour"
						}
					},
					["17489343647973509705"] = {
						["key"] = "17489343647973509705",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "暂停幽默音乐",
						["pos"] = {
							["x"] = 2891.62087912088,
							["y"] = 457.9403235653236
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundUnitKey"] = "pet_story_humour"
						}
					},
					["17568006622192137"] = {
						["key"] = "17568006622192137",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成火箭队",
						["pos"] = {
							["x"] = 2882,
							["y"] = 296
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1241123,
								1241124
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1745415990473274274"] = {
			["isStoryNode"] = true,
			["key"] = "1745415990473274274",
			["type"] = "StoryNode",
			["name"] = "冰湖揍人",
			["pos"] = {
				["x"] = 1618.8305640012156,
				["y"] = 318.31058339067476
			},
			["propsData"] = {
				["QuestId"] = 20010303,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200103_3",
				["QuestDeatil"] = "Content_200103_3",
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Mechanism_SQTrigger_1240986",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17456574358555041",
						["startPort"] = "Out",
						["endQuest"] = "174565782809011408",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17456574276474865",
						["startPort"] = "Out",
						["endQuest"] = "17456574358555041",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745416843245276526",
						["startPort"] = "Out",
						["endQuest"] = "17456572171454260",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17456572171454260",
						["startPort"] = "Out",
						["endQuest"] = "17456574429515245",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17456574429515245",
						["startPort"] = "Out",
						["endQuest"] = "17456574276474865",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17473060718722165",
						["startPort"] = "Out",
						["endQuest"] = "17473060718722166",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17473060718722166",
						["startPort"] = "Out",
						["endQuest"] = "17473060718722167",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745416843245276526",
						["startPort"] = "Out",
						["endQuest"] = "17473060718722165",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750904574127893790",
						["startPort"] = "Success",
						["endQuest"] = "1745415990473274280",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1750904574127893790",
						["startPort"] = "PassiveFail",
						["endQuest"] = "1750906644035895991",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750906644035895991",
						["startPort"] = "Out",
						["endQuest"] = "1745415990473274281",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1750904574127893790",
						["startPort"] = "Fail",
						["endQuest"] = "1750933786260992808",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750933786260992808",
						["startPort"] = "Out",
						["endQuest"] = "1745415990473274281",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1750904581702893991",
						["startPort"] = "Out",
						["endQuest"] = "1750904574127893790",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17554330294492744219",
						["startPort"] = "true",
						["endQuest"] = "17554330294492744218",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745415990473274279",
						["startPort"] = "QuestStart",
						["endQuest"] = "17554330294492744219",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17554330294492744219",
						["startPort"] = "true",
						["endQuest"] = "1750904574127893790",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17554330294492744219",
						["startPort"] = "false",
						["endQuest"] = "1750904581702893991",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1745415990473274279"] = {
						["key"] = "1745415990473274279",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 632.6666666666666,
							["y"] = 308.6666666666667
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1745415990473274280"] = {
						["key"] = "1745415990473274280",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2025.7700757895127,
							["y"] = 276.1182512645966
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1745415990473274281"] = {
						["key"] = "1745415990473274281",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2015.1865674416213,
							["y"] = 427.9663621970525
						},
						["propsData"] = {}
					},
					["1745415990473274287"] = {
						["key"] = "1745415990473274287",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "挂指引点",
						["pos"] = {
							["x"] = 2291.012647199348,
							["y"] = 690.6131643292769
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_200048Bai_1210093"
						}
					},
					["1745416843245276526"] = {
						["key"] = "1745416843245276526",
						["type"] = "GoToRegionNode",
						["name"] = "进入冰湖",
						["pos"] = {
							["x"] = 977.1419351073769,
							["y"] = -427.8610066833752
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "20010303_pPlayer"
						}
					},
					["1745416843245276527"] = {
						["key"] = "1745416843245276527",
						["type"] = "WaitOfTimeNode",
						["name"] = "等1S",
						["pos"] = {
							["x"] = 2564.7730082612757,
							["y"] = 597.2526417813501
						},
						["propsData"] = {
							["WaitTime"] = 0
						}
					},
					["17456572171454260"] = {
						["key"] = "17456572171454260",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "玩家放进战斗区域",
						["pos"] = {
							["x"] = 1233.8752478683728,
							["y"] = -430.02858681229935
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "20010303_pPlayer",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17456574276474865"] = {
						["key"] = "17456574276474865",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成怪物",
						["pos"] = {
							["x"] = 1212.8549688566916,
							["y"] = -764.8573967687762
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240834,
								1240835,
								1240836,
								1240837,
								1240838,
								1240839,
								1240840,
								1240841,
								1240842
							}
						}
					},
					["17456574358555041"] = {
						["key"] = "17456574358555041",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1509.0509214940398,
							["y"] = -427.3402931882133
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 9,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1240834,
								1240835,
								1240836,
								1240837,
								1240838,
								1240839,
								1240840,
								1240841,
								1240842
							}
						}
					},
					["17456574429515245"] = {
						["key"] = "17456574429515245",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成空气墙",
						["pos"] = {
							["x"] = 1228.3972412576425,
							["y"] = -594.7775436032534
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240843
							}
						}
					},
					["174565782809011408"] = {
						["key"] = "174565782809011408",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁空气墙",
						["pos"] = {
							["x"] = 1743.8192188851663,
							["y"] = -431.5529559685168
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240843
							}
						}
					},
					["17456604320433313581"] = {
						["key"] = "17456604320433313581",
						["type"] = "GoToRegionNode",
						["name"] = "检测当前区域",
						["pos"] = {
							["x"] = 2828.1953125720697,
							["y"] = 578.6179957073482
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_icelakecity"
						}
					},
					["17473060718722165"] = {
						["key"] = "17473060718722165",
						["type"] = "MonitorPlayerStatusNode",
						["name"] = "监听玩家状态",
						["pos"] = {
							["x"] = 1228.9508241511712,
							["y"] = -263.03464383465064
						},
						["propsData"] = {
							["ListenHPPercent"] = false,
							["ListenESPercent"] = false,
							["ListenSPPercent"] = false,
							["ListenDead"] = true
						}
					},
					["17473060718722166"] = {
						["key"] = "17473060718722166",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1523.4719094731718,
							["y"] = -244.1918847630588
						},
						["propsData"] = {
							["WaitTime"] = 0.2
						}
					},
					["17473060718722167"] = {
						["key"] = "17473060718722167",
						["type"] = "RefreshPlayerNode",
						["name"] = "重新初始化玩家",
						["pos"] = {
							["x"] = 1831.9354596529688,
							["y"] = -226.70904723445472
						},
						["propsData"] = {}
					},
					["1750904574127893790"] = {
						["key"] = "1750904574127893790",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1408.1828341634136,
							["y"] = 279.9754610310944
						},
						["propsData"] = {
							["SpecialConfigId"] = 1054,
							["BlackScreenImmediately"] = true
						}
					},
					["1750904581702893991"] = {
						["key"] = "1750904581702893991",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 984.8387803529985,
							["y"] = 424.1537981783102
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240986,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_SQTrigger_1240986"
						}
					},
					["1750906644035895991"] = {
						["key"] = "1750906644035895991",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1729.4790965585323,
							["y"] = 539.2988782698432
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "20010303_pPlayerSQFail",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1750933786260992808"] = {
						["key"] = "1750933786260992808",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1738.4000000000003,
							["y"] = 378.29999999999995
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "20010303_pPlayerSQFail",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17554330294492744218"] = {
						["key"] = "17554330294492744218",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1408.1792286229593,
							["y"] = 5.447368421052633
						},
						["propsData"] = {
							["VarName"] = "Pet01Battle01",
							["VarValue"] = 1
						}
					},
					["17554330294492744219"] = {
						["key"] = "17554330294492744219",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否在阶段1",
						["pos"] = {
							["x"] = 994.0663854121286,
							["y"] = 163.30701754385964
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Pet01Battle01",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17456575621327261"] = {
			["isStoryNode"] = true,
			["key"] = "17456575621327261",
			["type"] = "StoryNode",
			["name"] = "揍完人后对话",
			["pos"] = {
				["x"] = 1878.14988169725,
				["y"] = 319.00705610179284
			},
			["propsData"] = {
				["QuestId"] = 20010304,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200103_4",
				["QuestDeatil"] = "Content_200103_4",
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "P200054Nvzhu2",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17456575621327262",
						["startPort"] = "QuestStart",
						["endQuest"] = "1745744045022834679",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457462289143316156",
						["startPort"] = "Out",
						["endQuest"] = "17457462289143316157",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17456576162318838",
						["startPort"] = "Out",
						["endQuest"] = "17457462289143316156",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745744045022834679",
						["startPort"] = "Out",
						["endQuest"] = "17457463440933317411",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457463440933317411",
						["startPort"] = "Out",
						["endQuest"] = "17456576111488655",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17456576111488655",
						["startPort"] = "Out",
						["endQuest"] = "17457640201204971238",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17456576111488655",
						["startPort"] = "Out",
						["endQuest"] = "17457640689834971779",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457640201204971238",
						["startPort"] = "Out",
						["endQuest"] = "17457641296554972210",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457640201204971238",
						["startPort"] = "Out",
						["endQuest"] = "17457641365434972388",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457641296554972210",
						["startPort"] = "Out",
						["endQuest"] = "17457641700624972535",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457641296554972210",
						["startPort"] = "Out",
						["endQuest"] = "17457641756614972677",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457641700624972535",
						["startPort"] = "Out",
						["endQuest"] = "17457641839314973038",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457641700624972535",
						["startPort"] = "Out",
						["endQuest"] = "17457641896644973171",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457462289143316156",
						["startPort"] = "Out",
						["endQuest"] = "17457643884886625334",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457462289143316157",
						["startPort"] = "Out",
						["endQuest"] = "17457648287297451617",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457462289143316157",
						["startPort"] = "Out",
						["endQuest"] = "17458414058131569",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457462289143316157",
						["startPort"] = "Out",
						["endQuest"] = "17458475685862495363",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17458414058131569",
						["startPort"] = "Out",
						["endQuest"] = "17458487547313326625",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457641839314973038",
						["startPort"] = "Out",
						["endQuest"] = "17489344984583511336",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17489344984583511336",
						["startPort"] = "Out",
						["endQuest"] = "17456575621337265",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17457641896644973171",
						["startPort"] = "Out",
						["endQuest"] = "1747031707297294388",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17456575621327262"] = {
						["key"] = "17456575621327262",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 568,
							["y"] = 318
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17456575621337265"] = {
						["key"] = "17456575621337265",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2827.0123082586615,
							["y"] = 340.50188685994306
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17456575621337268"] = {
						["key"] = "17456575621337268",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1558,
							["y"] = 600
						},
						["propsData"] = {}
					},
					["17456576111488655"] = {
						["key"] = "17456576111488655",
						["type"] = "TalkNode",
						["name"] = "没影了",
						["pos"] = {
							["x"] = 1278.2380244755243,
							["y"] = 336.0399208244156
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005401,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_200054",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200074,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200086,
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
					["17456576162318838"] = {
						["key"] = "17456576162318838",
						["type"] = "WaitOfTimeNode",
						["name"] = "等待0.5",
						["pos"] = {
							["x"] = 2974.2090009379626,
							["y"] = -135.01965717573137
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					},
					["17456605028693314448"] = {
						["key"] = "17456605028693314448",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1040,
							["y"] = 704
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
							["TalkActors"] = {},
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
					["1745744045022834679"] = {
						["key"] = "1745744045022834679",
						["type"] = "GoToRegionNode",
						["name"] = "进入冰湖",
						["pos"] = {
							["x"] = 801.9123501567472,
							["y"] = 328.2183503504966
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "P200054Nvzhu2"
						}
					},
					["17457462289143316156"] = {
						["key"] = "17457462289143316156",
						["type"] = "ShowGuideMainNode",
						["name"] = "捉宠物引导",
						["pos"] = {
							["x"] = 3230.3131948598243,
							["y"] = -114.24833978843759
						},
						["propsData"] = {
							["GuideId"] = 49
						}
					},
					["17457462289143316157"] = {
						["key"] = "17457462289143316157",
						["type"] = "WaitingCompleteSysGuideNode",
						["name"] = "等待完成指引",
						["pos"] = {
							["x"] = 3462.6594814834352,
							["y"] = -112.17040225383403
						},
						["propsData"] = {
							["SystemGuideId"] = 2031
						}
					},
					["17457463440933317411"] = {
						["key"] = "17457463440933317411",
						["type"] = "TalkNode",
						["name"] = "火箭队飞天",
						["pos"] = {
							["x"] = 1051.2438533923669,
							["y"] = 329.1990991668804
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "LevelSequence'/Game/AssetDesign/Story/Sequence/Chapter01/IceLakeCity/PetThiefFly.PetThiefFly'",
							["BlendInTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = false,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
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
					["17457640201204971238"] = {
						["key"] = "17457640201204971238",
						["type"] = "TalkNode",
						["name"] = "没影了",
						["pos"] = {
							["x"] = 1562.4111140355726,
							["y"] = 327.49797564860717
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005411,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_200054A",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200086,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200074,
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
					["17457640689834971779"] = {
						["key"] = "17457640689834971779",
						["type"] = "SendMessageNode",
						["name"] = "Show",
						["pos"] = {
							["x"] = 1567.8194372526577,
							["y"] = 186.27522567905459
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Show",
							["UnitId"] = -1
						}
					},
					["17457641296554972210"] = {
						["key"] = "17457641296554972210",
						["type"] = "TalkNode",
						["name"] = "没影了",
						["pos"] = {
							["x"] = 1815.5855541941862,
							["y"] = 324.08632013182785
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005415,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200054A",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200074,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200086,
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
					["17457641365434972388"] = {
						["key"] = "17457641365434972388",
						["type"] = "SendMessageNode",
						["name"] = "Show",
						["pos"] = {
							["x"] = 1820.143851968376,
							["y"] = 189.18492467570996
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Show",
							["UnitId"] = -1
						}
					},
					["17457641700624972535"] = {
						["key"] = "17457641700624972535",
						["type"] = "TalkNode",
						["name"] = "没影了",
						["pos"] = {
							["x"] = 2073.393405076438,
							["y"] = 322.88879389494645
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005420,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_200054A",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200074,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200086,
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
					["17457641756614972677"] = {
						["key"] = "17457641756614972677",
						["type"] = "SendMessageNode",
						["name"] = "Show",
						["pos"] = {
							["x"] = 2081.534118373635,
							["y"] = 187.77851249718384
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Show",
							["UnitId"] = -1
						}
					},
					["17457641839314973038"] = {
						["key"] = "17457641839314973038",
						["type"] = "TalkNode",
						["name"] = "没影了",
						["pos"] = {
							["x"] = 2331.1108508945763,
							["y"] = 327.93507661683986
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005421,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_200054A",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
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
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200074,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200086,
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
					["17457641896644973171"] = {
						["key"] = "17457641896644973171",
						["type"] = "SendMessageNode",
						["name"] = "Show",
						["pos"] = {
							["x"] = 2323.2563452934655,
							["y"] = 190.14851458111573
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Show",
							["UnitId"] = -1
						}
					},
					["17457643884886625334"] = {
						["key"] = "17457643884886625334",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "开指引点",
						["pos"] = {
							["x"] = 3472.9621261343864,
							["y"] = -258.7872877665792
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P200054Pet"
						}
					},
					["17457648287297451617"] = {
						["key"] = "17457648287297451617",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "关指引点",
						["pos"] = {
							["x"] = 3855.26747663427,
							["y"] = -299.12114907790226
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P200054Pet"
						}
					},
					["17458414058131569"] = {
						["key"] = "17458414058131569",
						["type"] = "TalkNode",
						["name"] = "没影了",
						["pos"] = {
							["x"] = 3897.4821428571427,
							["y"] = -116.82142857142856
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005425,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20005425",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200074,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200086,
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
					["17458475685862495363"] = {
						["key"] = "17458475685862495363",
						["type"] = "SendMessageNode",
						["name"] = "PetOnly",
						["pos"] = {
							["x"] = 3861.2321428571427,
							["y"] = -439.3214285714286
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Only",
							["UnitId"] = -1
						}
					},
					["17458487547313326625"] = {
						["key"] = "17458487547313326625",
						["type"] = "SendMessageNode",
						["name"] = "PetOnly",
						["pos"] = {
							["x"] = 4184.982142857143,
							["y"] = -108.07142857142856
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Only",
							["UnitId"] = -1
						}
					},
					["174687732140215106949"] = {
						["key"] = "174687732140215106949",
						["type"] = "ShowGuideMainNode",
						["name"] = "捉宠物引导",
						["pos"] = {
							["x"] = 2671.765151515152,
							["y"] = 822.0934343434344
						},
						["propsData"] = {
							["GuideId"] = 49
						}
					},
					["1747031707297294388"] = {
						["key"] = "1747031707297294388",
						["type"] = "SendMessageNode",
						["name"] = "生成宠物",
						["pos"] = {
							["x"] = 2324.2745427310624,
							["y"] = 50.743218646666705
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Pet_Guide",
							["UnitId"] = -1
						}
					},
					["17489344984583511336"] = {
						["key"] = "17489344984583511336",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "暂停幽默音乐",
						["pos"] = {
							["x"] = 2582.3492328927114,
							["y"] = 330.78693528693526
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundUnitKey"] = "pet_story_humour"
						}
					},
					["17489344984583511337"] = {
						["key"] = "17489344984583511337",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放幽默音乐",
						["pos"] = {
							["x"] = 1067.2828741307003,
							["y"] = 489.1595530073791
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 2,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0033_story_humour",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["SoundUnitKey"] = "pet_story_humour"
						}
					},
					["17514536210781280274"] = {
						["key"] = "17514536210781280274",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成宠物",
						["pos"] = {
							["x"] = 2600.688888888889,
							["y"] = -82.75555555555556
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240833
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174687711753614252462"] = {
			["isStoryNode"] = true,
			["key"] = "174687711753614252462",
			["type"] = "StoryNode",
			["name"] = "捉宠物",
			["pos"] = {
				["x"] = 2357.7798175274415,
				["y"] = 329.3638408068694
			},
			["propsData"] = {
				["QuestId"] = 20010306,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200103_5",
				["QuestDeatil"] = "Content_200103_5",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "P200054Pet",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174687711753714252467",
						["startPort"] = "QuestStart",
						["endQuest"] = "174687711753714252473",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174687711753714252473",
						["startPort"] = "Out",
						["endQuest"] = "17482476220241176553",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17482486937414067641",
						["startPort"] = "Out",
						["endQuest"] = "174687711753914252490",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174687711753914252490",
						["startPort"] = "Out",
						["endQuest"] = "1749537343571624609",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749537343571624609",
						["startPort"] = "Out",
						["endQuest"] = "174687711753714252468",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17482476220241176553",
						["startPort"] = "Out",
						["endQuest"] = "1760429290204330264",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760429290204330264",
						["startPort"] = "Out",
						["endQuest"] = "174687711753914252489",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760429290204330264",
						["startPort"] = "Out",
						["endQuest"] = "17482486937414067641",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174687711753714252467"] = {
						["key"] = "174687711753714252467",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 568,
							["y"] = 318
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174687711753714252468"] = {
						["key"] = "174687711753714252468",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2691.6075463539,
							["y"] = 332.8000235059058
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174687711753714252469"] = {
						["key"] = "174687711753714252469",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1558,
							["y"] = 600
						},
						["propsData"] = {}
					},
					["174687711753714252473"] = {
						["key"] = "174687711753714252473",
						["type"] = "GoToRegionNode",
						["name"] = "进入冰湖",
						["pos"] = {
							["x"] = 801.9123501567472,
							["y"] = 328.2183503504966
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "P200054Nvzhu2"
						}
					},
					["174687711753914252489"] = {
						["key"] = "174687711753914252489",
						["type"] = "SendMessageNode",
						["name"] = "PetOnly",
						["pos"] = {
							["x"] = 1828.1094322344325,
							["y"] = 174.28663003663004
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Only",
							["UnitId"] = -1
						}
					},
					["174687711753914252490"] = {
						["key"] = "174687711753914252490",
						["type"] = "SendMessageNode",
						["name"] = "PetOnly",
						["pos"] = {
							["x"] = 2096.4940476190477,
							["y"] = 349.46825396825403
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PetQuest_Only",
							["UnitId"] = -1
						}
					},
					["17482476220241176553"] = {
						["key"] = "17482476220241176553",
						["type"] = "GoToNode",
						["name"] = "去宠物身边",
						["pos"] = {
							["x"] = 1083.4120967741937,
							["y"] = 336.67741935483883
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240999,
							["GuideType"] = "P",
							["GuidePointName"] = "P200054Pet"
						}
					},
					["17482484385912044282"] = {
						["key"] = "17482484385912044282",
						["type"] = "SendMessageNode",
						["name"] = "销毁宠物",
						["pos"] = {
							["x"] = 1366.6194700460835,
							["y"] = -91.32258064516114
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Pet_Guide_Off",
							["UnitId"] = -1
						}
					},
					["17482486937414067640"] = {
						["key"] = "17482486937414067640",
						["type"] = "TalkNode",
						["name"] = "捉宠物演出",
						["pos"] = {
							["x"] = 1647.988113273258,
							["y"] = -81.30582831147353
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/Chapter01/IceLakeCity/PlayerCatchPet",
							["BlendInTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17482486937414067641"] = {
						["key"] = "17482486937414067641",
						["type"] = "TalkNode",
						["name"] = "没影了",
						["pos"] = {
							["x"] = 1798.8292249440806,
							["y"] = 345.94294674859185
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20005425,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20005425",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0.5,
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
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200074,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200086,
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
					["1749537343571624609"] = {
						["key"] = "1749537343571624609",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "激活宠物技能",
						["pos"] = {
							["x"] = 2394.634920634921,
							["y"] = 343.68253968253975
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Skill3"
							}
						}
					},
					["1760429290204330264"] = {
						["key"] = "1760429290204330264",
						["type"] = "WaitOfTimeNode",
						["name"] = "等待捕捉魔灵音效结束",
						["pos"] = {
							["x"] = 1357.93768115942,
							["y"] = 344.7723320158104
						},
						["propsData"] = {
							["WaitTime"] = 5
						}
					}
				},
				["commentData"] = {}
			}
		},
		["175195993301219061"] = {
			["isStoryNode"] = true,
			["key"] = "175195993301219061",
			["type"] = "GameModeCompleteNode",
			["name"] = "抓捕魔灵",
			["pos"] = {
				["x"] = 2115.987460815047,
				["y"] = 333.11598746081506
			},
			["propsData"] = {
				["QuestId"] = 20010305,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200103_5",
				["QuestDeatil"] = "Content_200103_5",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["InRegionExportName"] = "",
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["GameModeTargetId"] = 1400401,
				["GameModeKeyCount"] = 1,
				["QuestHintMessageId"] = 0,
				["IsShowGuide"] = true,
				["GuideType"] = "P",
				["GuidePointName"] = "P200054Pet",
				["InterfaceJumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}