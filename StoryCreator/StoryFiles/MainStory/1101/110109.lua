return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1722421216475661039",
			["startPort"] = "Success",
			["endStory"] = "1722421216475661037",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17241355652736586",
			["startPort"] = "Success",
			["endStory"] = "17241355555806196",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1704175979318207451",
			["startPort"] = "StoryStart",
			["endStory"] = "1722421216474661036",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1722421216474661036",
			["startPort"] = "Success",
			["endStory"] = "17352956439772509",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17352956439772509",
			["startPort"] = "Success",
			["endStory"] = "1735295682824939045",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1735295682824939045",
			["startPort"] = "Success",
			["endStory"] = "1722421216475661039",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17241355555806196",
			["startPort"] = "Success",
			["endStory"] = "17443559678473022419",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17443559678473022419",
			["startPort"] = "Success",
			["endStory"] = "1704175979318207452",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1722421216475661037",
			["startPort"] = "Success",
			["endStory"] = "17544794417941323958",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17544794417941323958",
			["startPort"] = "Success",
			["endStory"] = "17241355652736586",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["1704175979318207451"] = {
			["isStoryNode"] = true,
			["key"] = "1704175979318207451",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 687.6026604973972,
				["y"] = 539.4688644688646
			},
			["propsData"] = {
				["QuestChainId"] = 110109
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1704175979318207452"] = {
			["isStoryNode"] = true,
			["key"] = "1704175979318207452",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2042.8202499826648,
				["y"] = 912.4190525721415
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1722421216474661036"] = {
			["isStoryNode"] = true,
			["key"] = "1722421216474661036",
			["type"] = "StoryNode",
			["name"] = "审判对话特殊任务",
			["pos"] = {
				["x"] = 938.2723633090186,
				["y"] = 535.6943366574947
			},
			["propsData"] = {
				["QuestId"] = 11010902,
				["QuestDescriptionComment"] = "监狱剧情",
				["QuestDescription"] = "Description_110113_2",
				["QuestDeatil"] = "Content_110113_2",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = false,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1724309832869225908",
						["startPort"] = "Fail",
						["endQuest"] = "17249115713518449884",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17249115713518449884",
						["startPort"] = "Out",
						["endQuest"] = "1722421216482661057",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1722421216479661055",
						["startPort"] = "QuestStart",
						["endQuest"] = "1724309832869225908",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1724309832869225908",
						["startPort"] = "Success",
						["endQuest"] = "1722421216481661056",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1724309832869225908",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17352969995093748480",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17352969995093748480",
						["startPort"] = "Out",
						["endQuest"] = "1722421216482661057",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1722421216479661055"] = {
						["key"] = "1722421216479661055",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -2467.8675024311838,
							["y"] = 1142.4004805718685
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421216481661056"] = {
						["key"] = "1722421216481661056",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = -1309.5051974378105,
							["y"] = 1131.3901018593504
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421216482661057"] = {
						["key"] = "1722421216482661057",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = -1317.5640216310962,
							["y"] = 1272.874698578945
						},
						["propsData"] = {}
					},
					["1724309832869225908"] = {
						["key"] = "1724309832869225908",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = -2167.2353137949717,
							["y"] = 1155.9266707919905
						},
						["propsData"] = {
							["SpecialConfigId"] = 1014,
							["BlackScreenImmediately"] = true
						}
					},
					["17249115713518449884"] = {
						["key"] = "17249115713518449884",
						["type"] = "SkipRegionNode",
						["name"] = "送回据点",
						["pos"] = {
							["x"] = -1770.7623138522918,
							["y"] = 1281.866291308219
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 210101,
							["StartIndex"] = 1,
							["IsWhite"] = true
						}
					},
					["17352969995093748480"] = {
						["key"] = "17352969995093748480",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -1928.5224840948529,
							["y"] = 1459.0196645459803
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TargetPoint_Jail",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1722421216475661037"] = {
			["isStoryNode"] = true,
			["key"] = "1722421216475661037",
			["type"] = "StoryNode",
			["name"] = "二皇子剧情前",
			["pos"] = {
				["x"] = 1352.1625741568976,
				["y"] = 723.5416898160315
			},
			["propsData"] = {
				["QuestId"] = 11010904,
				["QuestDescriptionComment"] = "监狱剧情",
				["QuestDescription"] = "Description_110113_4",
				["QuestDeatil"] = "Content_110113_4",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = false,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1723550664634392528",
						["startPort"] = "Out",
						["endQuest"] = "1722421216518661177",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1722421216518661176",
						["startPort"] = "QuestStart",
						["endQuest"] = "1724673372403186793",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1724673372403186793",
						["startPort"] = "Out",
						["endQuest"] = "1722421216520661187",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421216518661176",
						["startPort"] = "QuestStart",
						["endQuest"] = "1723550664634392528",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421216518661176",
						["startPort"] = "QuestStart",
						["endQuest"] = "17295876296861908484",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1722421216518661176"] = {
						["key"] = "1722421216518661176",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -3185.457342207326,
							["y"] = 93.85317866796026
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421216518661177"] = {
						["key"] = "1722421216518661177",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = -1896.9268060607599,
							["y"] = 110.10368217407861
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421216518661178"] = {
						["key"] = "1722421216518661178",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = -129.89743440443954,
							["y"] = 578.0283005706506
						},
						["propsData"] = {}
					},
					["1722421216520661187"] = {
						["key"] = "1722421216520661187",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "最后剧情站桩",
						["pos"] = {
							["x"] = -2627.2577850045172,
							["y"] = -131.20158613316448
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TargetPoint_JailFin",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1723550664634392528"] = {
						["key"] = "1723550664634392528",
						["type"] = "TalkNode",
						["name"] = "FixSimple_26问到最关键的部分",
						["pos"] = {
							["x"] = -2274.2426460690676,
							["y"] = 101.34981787640899
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11016501,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_26",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
									["TalkActorId"] = 110039,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
					["1724673372403186793"] = {
						["key"] = "1724673372403186793",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = -2892.147604994022,
							["y"] = -99.25860249807647
						},
						["propsData"] = {}
					},
					["17295876296861908484"] = {
						["key"] = "17295876296861908484",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = -2280.9987836112305,
							["y"] = -69.37512876912646
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								102104
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1722421216475661039"] = {
			["isStoryNode"] = true,
			["key"] = "1722421216475661039",
			["type"] = "StoryNode",
			["name"] = "BOSS战斗",
			["pos"] = {
				["x"] = 949.3619772706602,
				["y"] = 712.801608041082
			},
			["propsData"] = {
				["QuestId"] = 11010903,
				["QuestDescriptionComment"] = "监狱剧情",
				["QuestDescription"] = "Description_110113_3",
				["QuestDeatil"] = "Content_110113_3",
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
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17262243150798732031",
						["startPort"] = "Fail",
						["endQuest"] = "17250134432391276171",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722421216554661300",
						["startPort"] = "QuestStart",
						["endQuest"] = "17262243150798732031",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17262243150798732031",
						["startPort"] = "Success",
						["endQuest"] = "1722421216554661301",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17262243150798732031",
						["startPort"] = "PassiveFail",
						["endQuest"] = "1745413245921555913",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17250134432391276171",
						["startPort"] = "Out",
						["endQuest"] = "1722421216554661302",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1745413245921555913",
						["startPort"] = "Out",
						["endQuest"] = "1722421216554661302",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1722421216554661300"] = {
						["key"] = "1722421216554661300",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -3870.8404723289154,
							["y"] = 447.2001112534159
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421216554661301"] = {
						["key"] = "1722421216554661301",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = -2710.9235265863804,
							["y"] = 394.40081637362215
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722421216554661302"] = {
						["key"] = "1722421216554661302",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = -2660.3056824291893,
							["y"] = 620.0786392481125
						},
						["propsData"] = {}
					},
					["17250134432391276171"] = {
						["key"] = "17250134432391276171",
						["type"] = "SkipRegionNode",
						["name"] = "送回据点",
						["pos"] = {
							["x"] = -3049.0041451009342,
							["y"] = 544.8863415690647
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 210101,
							["StartIndex"] = 1,
							["IsWhite"] = true
						}
					},
					["17262243150798732031"] = {
						["key"] = "17262243150798732031",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = -3474.1694151791608,
							["y"] = 446.2574856693468
						},
						["propsData"] = {
							["SpecialConfigId"] = 1015,
							["BlackScreenImmediately"] = true
						}
					},
					["1745413245921555913"] = {
						["key"] = "1745413245921555913",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -3055.3778721278727,
							["y"] = 694.908091908092
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "BP_HaierReChallenge",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17241355555806196"] = {
			["isStoryNode"] = true,
			["key"] = "17241355555806196",
			["type"] = "StoryNode",
			["name"] = "二皇子剧情",
			["pos"] = {
				["x"] = 1301.59535608524,
				["y"] = 908.2342012416738
			},
			["propsData"] = {
				["QuestId"] = 11010906,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_110113_4",
				["QuestDeatil"] = "Content_110113_4",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = true,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17241358294468274",
						["startPort"] = "Out",
						["endQuest"] = "17241358294468275",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17241355555816197",
						["startPort"] = "QuestStart",
						["endQuest"] = "1726817872489186580",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1726817872489186580",
						["startPort"] = "Out",
						["endQuest"] = "17241358294468274",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17241358294468275",
						["startPort"] = "Out",
						["endQuest"] = "17241355555826200",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17241358294468274",
						["startPort"] = "Out",
						["endQuest"] = "17483344492462595699",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17241355555816197"] = {
						["key"] = "17241355555816197",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 91.42857142857144,
							["y"] = 177.14285714285717
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17241355555826200"] = {
						["key"] = "17241355555826200",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1220.1094690749865,
							["y"] = 247.0662287903668
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101901,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17241355555826203"] = {
						["key"] = "17241355555826203",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17241358294468274"] = {
						["key"] = "17241358294468274",
						["type"] = "TalkNode",
						["name"] = "过场 - SC017 - 维吉尔进场",
						["pos"] = {
							["x"] = 674.5366808067382,
							["y"] = 187.22752498618868
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC017/SQ_OBT0102_SC017",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
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
					["17241358294468275"] = {
						["key"] = "17241358294468275",
						["type"] = "TalkNode",
						["name"] = "FixSimple_29维吉尔站桩",
						["pos"] = {
							["x"] = 936.0570004975443,
							["y"] = 226.09521050433193
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11017101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_29",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
									["TalkActorId"] = 110018,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
					["1726817872489186580"] = {
						["key"] = "1726817872489186580",
						["type"] = "TalkNode",
						["name"] = "FixSimple_28走不出这里",
						["pos"] = {
							["x"] = 420.3266244014164,
							["y"] = 162.67912087912086
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11016901,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_28",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
									["TalkActorId"] = 110032,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110041,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110040,
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
					["17483344492462595699"] = {
						["key"] = "17483344492462595699",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 980.2857142857144,
							["y"] = 32.61904761904758
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt03/0073_story_virgil_theme.0073_story_virgil_theme'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								102104
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17241355652736586"] = {
			["isStoryNode"] = true,
			["key"] = "17241355652736586",
			["type"] = "StoryNode",
			["name"] = "达芙涅印象任务",
			["pos"] = {
				["x"] = 967.7045484089343,
				["y"] = 932.4563965520842
			},
			["propsData"] = {
				["QuestId"] = 11010905,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_110113_4",
				["QuestDeatil"] = "Content_110113_4",
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
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17241355652736587",
						["startPort"] = "QuestStart",
						["endQuest"] = "1724136079053183530",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17290492796331765754",
						["startPort"] = "Out",
						["endQuest"] = "17241355652736590",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1724136079053183530",
						["startPort"] = "Out",
						["endQuest"] = "17470542648655710487",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17470542648655710487",
						["startPort"] = "Out",
						["endQuest"] = "17290492796331765754",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17241355652736587",
						["startPort"] = "QuestStart",
						["endQuest"] = "17483342890804211",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17241355652736587"] = {
						["key"] = "17241355652736587",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1266.512605042017,
							["y"] = 401.21848739495795
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17241355652736590"] = {
						["key"] = "17241355652736590",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2487.670693277311,
							["y"] = 430.56460084033614
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17241355652736593"] = {
						["key"] = "17241355652736593",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1724136079053183530"] = {
						["key"] = "1724136079053183530",
						["type"] = "TalkNode",
						["name"] = "FixSimple_27达芙涅进场",
						["pos"] = {
							["x"] = 1561.4638142927834,
							["y"] = 388.58033928313813
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11016801,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "EX01_FixSimple_27",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
									["TalkActorId"] = 110005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110040,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110041,
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
					["17290485968531764750"] = {
						["key"] = "17290485968531764750",
						["type"] = "VideoNode",
						["name"] = "视频节点",
						["pos"] = {
							["x"] = 2239.8302538956023,
							["y"] = 786.5512591053598
						},
						["propsData"] = {
							["MediaSourceRef"] = "FileMediaSource'/Game/Asset/UIVideo/EX01_SC018.EX01_SC018'"
						}
					},
					["17290492796331765754"] = {
						["key"] = "17290492796331765754",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2148.067067082415,
							["y"] = 412.8644936968554
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11016825,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "EX01_FixSimple_27",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
									["TalkActorId"] = 110040,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110041,
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
					["17470542648655710487"] = {
						["key"] = "17470542648655710487",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1847.9712744218734,
							["y"] = 403.15834023591475
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "LevelSequence'/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC020/SQ_OBT0102_SC020.SQ_OBT0102_SC020'",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
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
					["17483342890804211"] = {
						["key"] = "17483342890804211",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1571.1789473684212,
							["y"] = 219.22105263157886
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0067_story_daphnis_theme_piano.0067_story_daphnis_theme_piano'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								102104
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17352956439772509"] = {
			["isStoryNode"] = true,
			["key"] = "17352956439772509",
			["type"] = "StoryNode",
			["name"] = "审判二阶段特殊任务",
			["pos"] = {
				["x"] = 1196.319163865894,
				["y"] = 537.6726562170891
			},
			["propsData"] = {
				["QuestId"] = 11010907,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_110113_2",
				["QuestDeatil"] = "Content_110113_2",
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
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17352956600993105",
						["startPort"] = "Fail",
						["endQuest"] = "17352956600993106",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17352956439772510",
						["startPort"] = "QuestStart",
						["endQuest"] = "17352956600993105",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17352956600993105",
						["startPort"] = "Success",
						["endQuest"] = "17352956439782513",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17352956600993105",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17352967860611877729",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17352956600993106",
						["startPort"] = "Out",
						["endQuest"] = "17352956439782516",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17352967860611877729",
						["startPort"] = "Out",
						["endQuest"] = "17352956439782516",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17352956439772510"] = {
						["key"] = "17352956439772510",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 987.5,
							["y"] = 337.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17352956439782513"] = {
						["key"] = "17352956439782513",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2162.1103896103896,
							["y"] = 301.7532467532468
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17352956439782516"] = {
						["key"] = "17352956439782516",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2077.272727272727,
							["y"] = 537.7272727272727
						},
						["propsData"] = {}
					},
					["17352956600993105"] = {
						["key"] = "17352956600993105",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1343.516573860169,
							["y"] = 319.526513461173
						},
						["propsData"] = {
							["SpecialConfigId"] = 1024,
							["BlackScreenImmediately"] = true
						}
					},
					["17352956600993106"] = {
						["key"] = "17352956600993106",
						["type"] = "SkipRegionNode",
						["name"] = "送回据点",
						["pos"] = {
							["x"] = 1722.7504355958094,
							["y"] = 433.6441632305563
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 210101,
							["StartIndex"] = 1,
							["IsWhite"] = true
						}
					},
					["17352967860611877729"] = {
						["key"] = "17352967860611877729",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1739.0210333145117,
							["y"] = 594.0516939582158
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "BP_Shenpan02RE",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1735295682824939045"] = {
			["isStoryNode"] = true,
			["key"] = "1735295682824939045",
			["type"] = "StoryNode",
			["name"] = "审判三阶段特殊任务",
			["pos"] = {
				["x"] = 1441.7316827195893,
				["y"] = 531.4675280119611
			},
			["propsData"] = {
				["QuestId"] = 11010908,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_110113_2",
				["QuestDeatil"] = "Content_110113_2",
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
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1735295682825939052",
						["startPort"] = "Fail",
						["endQuest"] = "1735295682825939053",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735295682825939049",
						["startPort"] = "QuestStart",
						["endQuest"] = "1735295682825939052",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735295682825939052",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17352968001301878213",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735295682825939053",
						["startPort"] = "Out",
						["endQuest"] = "1735295682825939051",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17352968001301878213",
						["startPort"] = "Out",
						["endQuest"] = "1735295682825939051",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1735295682825939052",
						["startPort"] = "Success",
						["endQuest"] = "17472020769443144151",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17472020769443144151",
						["startPort"] = "Out",
						["endQuest"] = "1735295682825939050",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1735295682825939049"] = {
						["key"] = "1735295682825939049",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 987.5,
							["y"] = 337.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1735295682825939050"] = {
						["key"] = "1735295682825939050",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2133.1013824884794,
							["y"] = 282.7396313364055
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1735295682825939051"] = {
						["key"] = "1735295682825939051",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1967.5,
							["y"] = 478.21428571428567
						},
						["propsData"] = {}
					},
					["1735295682825939052"] = {
						["key"] = "1735295682825939052",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1332.2158219804699,
							["y"] = 320.82726534087226
						},
						["propsData"] = {
							["SpecialConfigId"] = 1025,
							["BlackScreenImmediately"] = true
						}
					},
					["1735295682825939053"] = {
						["key"] = "1735295682825939053",
						["type"] = "SkipRegionNode",
						["name"] = "送回据点",
						["pos"] = {
							["x"] = 1647.7895090859868,
							["y"] = 435.7838188211457
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 210101,
							["StartIndex"] = 1,
							["IsWhite"] = true
						}
					},
					["17352968001301878213"] = {
						["key"] = "17352968001301878213",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1647.3214285714284,
							["y"] = 608.9642857142858
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "BP_Shenpan3RE",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17472020769443144151"] = {
						["key"] = "17472020769443144151",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1662,
							["y"] = 282
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["17443559678473022419"] = {
			["isStoryNode"] = true,
			["key"] = "17443559678473022419",
			["type"] = "StoryNode",
			["name"] = "剧院剧情",
			["pos"] = {
				["x"] = 1709.6421762380842,
				["y"] = 945.5
			},
			["propsData"] = {
				["QuestId"] = 11010909,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_110113_4",
				["QuestDeatil"] = "Content_110113_4",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17443559678473022420",
						["startPort"] = "QuestStart",
						["endQuest"] = "17443559841853023190",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443559841853023190",
						["startPort"] = "Out",
						["endQuest"] = "17443559985823023474",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443559985823023474",
						["startPort"] = "Out",
						["endQuest"] = "17443559731893022642",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443559731893022643",
						["startPort"] = "Out",
						["endQuest"] = "17443559678473022423",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17443559731893022642",
						["startPort"] = "Out",
						["endQuest"] = "17443559731893022643",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443559985823023474",
						["startPort"] = "Out",
						["endQuest"] = "17483345075043460588",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17443559678473022420"] = {
						["key"] = "17443559678473022420",
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
					["17443559678473022423"] = {
						["key"] = "17443559678473022423",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2320,
							["y"] = 398.75
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 210101,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17443559678473022426"] = {
						["key"] = "17443559678473022426",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17443559731893022642"] = {
						["key"] = "17443559731893022642",
						["type"] = "TalkNode",
						["name"] = "黑屏两句",
						["pos"] = {
							["x"] = 1702.9823134857431,
							["y"] = 354.2025536585295
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11019123,
							["FlowAssetPath"] = "",
							["TalkType"] = "BlackISS",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = false,
							["ShowAutoPlayButton"] = false,
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
					["17443559731893022643"] = {
						["key"] = "17443559731893022643",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1989.5891150856853,
							["y"] = 354.2974463414704
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17443559841853023190"] = {
						["key"] = "17443559841853023190",
						["type"] = "TalkNode",
						["name"] = "黑屏两句",
						["pos"] = {
							["x"] = 1101.5,
							["y"] = 306.5000000000001
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11019107,
							["FlowAssetPath"] = "",
							["TalkType"] = "BlackISS",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = false,
							["ShowAutoPlayButton"] = false,
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
					["17443559985823023474"] = {
						["key"] = "17443559985823023474",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1405.0000000000002,
							["y"] = 364.75
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11019109,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_29",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
									["TalkActorId"] = 110018,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
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
					["17483345075043460588"] = {
						["key"] = "17483345075043460588",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1707.9276416872078,
							["y"] = 168.58373205741623
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								101901
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17544794417941323958"] = {
			["isStoryNode"] = true,
			["key"] = "17544794417941323958",
			["type"] = "StoryNode",
			["name"] = "等待达芙涅特殊任务",
			["pos"] = {
				["x"] = 1688.5304523851432,
				["y"] = 698.0594316057703
			},
			["propsData"] = {
				["QuestId"] = 11010910,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_110113_5",
				["QuestDeatil"] = "Content_110113_4",
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
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 102104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17544794417941323959",
						["startPort"] = "QuestStart",
						["endQuest"] = "17544794623151324669",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17544794623151324669",
						["startPort"] = "Success",
						["endQuest"] = "17544794417941323962",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17544794623151324669",
						["startPort"] = "Fail",
						["endQuest"] = "17575900586151934823",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17544794623151324669",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17575900586151934823",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17575900586151934823",
						["startPort"] = "Out",
						["endQuest"] = "17544794417941323965",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17544794417941323959"] = {
						["key"] = "17544794417941323959",
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
					["17544794417941323962"] = {
						["key"] = "17544794417941323962",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1851.9642857142858,
							["y"] = 354.2857142857143
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17544794417941323965"] = {
						["key"] = "17544794417941323965",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2159.056324110672,
							["y"] = 526.8181818181818
						},
						["propsData"] = {}
					},
					["17544794623151324669"] = {
						["key"] = "17544794623151324669",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1466,
							["y"] = 366
						},
						["propsData"] = {
							["SpecialConfigId"] = 1057,
							["BlackScreenImmediately"] = true
						}
					},
					["17575900586151934823"] = {
						["key"] = "17575900586151934823",
						["type"] = "SkipRegionNode",
						["name"] = "送回据点",
						["pos"] = {
							["x"] = 1762.01581027668,
							["y"] = 485.9148414514548
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 210101,
							["StartIndex"] = 1,
							["IsWhite"] = true
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}