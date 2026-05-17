return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1768461041446495",
			["startPort"] = "Success",
			["endStory"] = "17684612594472324",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17684612594472324",
			["startPort"] = "Success",
			["endStory"] = "17684617069564758",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17684607894831",
			["startPort"] = "StoryStart",
			["endStory"] = "17684617396715281",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17684617396715281",
			["startPort"] = "Success",
			["endStory"] = "17684617573395568",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17684617573395568",
			["startPort"] = "Success",
			["endStory"] = "17684607894835",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17684607894831"] = {
			["isStoryNode"] = true,
			["key"] = "17684607894831",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1588.868278032037,
				["y"] = 322.34745423340956
			},
			["propsData"] = {
				["QuestChainId"] = 400121
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17684607894835"] = {
			["isStoryNode"] = true,
			["key"] = "17684607894835",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2461.9450246168785,
				["y"] = 324.50610221205176
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1768461041446495"] = {
			["isStoryNode"] = true,
			["key"] = "1768461041446495",
			["type"] = "StoryNode",
			["name"] = "前往据点门口",
			["pos"] = {
				["x"] = 1189.1962624970938,
				["y"] = 61.05077307602869
			},
			["propsData"] = {
				["QuestId"] = 40012100,
				["QuestDescriptionComment"] = "前往据点门口",
				["QuestDescription"] = "",
				["QuestDeatil"] = "",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_40012100_1192071",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1768461041446496",
						["startPort"] = "QuestStart",
						["endQuest"] = "17684610812671241",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17684610812671241",
						["startPort"] = "Out",
						["endQuest"] = "1768461041447504",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1768461041446496"] = {
						["key"] = "1768461041446496",
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
					["1768461041447504"] = {
						["key"] = "1768461041447504",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1571.578947368421,
							["y"] = 312.63157894736844
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1768461041447512"] = {
						["key"] = "1768461041447512",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17684610812671241"] = {
						["key"] = "17684610812671241",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1165.309562341683,
							["y"] = 308.81972980579786
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1192071,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_40012100_1192071"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17684612594472324"] = {
			["isStoryNode"] = true,
			["key"] = "17684612594472324",
			["type"] = "StoryNode",
			["name"] = "播放对话",
			["pos"] = {
				["x"] = 1479.81780399907,
				["y"] = 60.78990351081126
			},
			["propsData"] = {
				["QuestId"] = 40012101,
				["QuestDescriptionComment"] = "播放对话",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17684612594472325",
						["startPort"] = "QuestStart",
						["endQuest"] = "17684613160473290",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17684613160473290",
						["startPort"] = "Out",
						["endQuest"] = "17684612594472328",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17684613160473290",
						["startPort"] = "Out",
						["endQuest"] = "17691372784001906",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17684612594472325"] = {
						["key"] = "17684612594472325",
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
					["17684612594472328"] = {
						["key"] = "17684612594472328",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1479.9999999999998,
							["y"] = 302.60869565217394
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17684612594472331"] = {
						["key"] = "17684612594472331",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1528.2608695652173,
							["y"] = 603.4782608695652
						},
						["propsData"] = {}
					},
					["17684613160473290"] = {
						["key"] = "17684613160473290",
						["type"] = "TalkNode",
						["name"] = "播站桩",
						["pos"] = {
							["x"] = 1138.0869565217388,
							["y"] = 309.3299232736572
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 51012300,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400121/40012101.40012101'",
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
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = false,
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
					},
					["17691372784001906"] = {
						["key"] = "17691372784001906",
						["type"] = "TalkNode",
						["name"] = "播开车",
						["pos"] = {
							["x"] = 1484.1969309462913,
							["y"] = 101.19155096821339
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51012400,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17684617069564758"] = {
			["isStoryNode"] = true,
			["key"] = "17684617069564758",
			["type"] = "StoryNode",
			["name"] = "进据点&铁匠皎皎对话",
			["pos"] = {
				["x"] = 1784.2463754276412,
				["y"] = 63.28990351081126
			},
			["propsData"] = {
				["QuestId"] = 40012102,
				["QuestDescriptionComment"] = "进据点&铁匠皎皎对话",
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
				["SubRegionId"] = 210101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17684617069564759",
						["startPort"] = "QuestStart",
						["endQuest"] = "17684620467926410",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17684620467926410",
						["startPort"] = "Out",
						["endQuest"] = "17684621027517068",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17684621027517068",
						["startPort"] = "Out",
						["endQuest"] = "17684617069564762",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17684617069564759"] = {
						["key"] = "17684617069564759",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 862.1428571428571,
							["y"] = 250.71428571428572
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17684617069564762"] = {
						["key"] = "17684617069564762",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1970.0615384615385,
							["y"] = 265.84615384615387
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17684617069564765"] = {
						["key"] = "17684617069564765",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17684620467926410"] = {
						["key"] = "17684620467926410",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1242.9285714285718,
							["y"] = 250.14285714285714
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
					["17684621027517068"] = {
						["key"] = "17684621027517068",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1560.8956043956046,
							["y"] = 259.40720390720384
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 900001,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Bai_Duanzao",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51012500,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
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
							["HideMechanismsFX"] = false,
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17684617396715281"] = {
			["isStoryNode"] = true,
			["key"] = "17684617396715281",
			["type"] = "StoryNode",
			["name"] = "据点打开活动界面",
			["pos"] = {
				["x"] = 1854.1821182695417,
				["y"] = 321.53780319915
			},
			["propsData"] = {
				["QuestId"] = 40012103,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400128_2",
				["QuestDeatil"] = "Content_400128_2",
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
				["SubRegionIdList"] = {
					100101
				},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Bai_Duanzao",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17684617396715282",
						["startPort"] = "QuestStart",
						["endQuest"] = "17724374486912539",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724374486912539",
						["startPort"] = "Out",
						["endQuest"] = "17724376475893765",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724374486912539",
						["startPort"] = "Out",
						["endQuest"] = "17724376701064237",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724376475893765",
						["startPort"] = "Out",
						["endQuest"] = "17724375148763114",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724375148763114",
						["startPort"] = "Out",
						["endQuest"] = "17684627905039955",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17684627905039955",
						["startPort"] = "Out",
						["endQuest"] = "17724381203586769",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724381203586769",
						["startPort"] = "Out",
						["endQuest"] = "17684617396725285",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17684617396715282",
						["startPort"] = "QuestStart",
						["endQuest"] = "17724534783391286",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724534783391286",
						["startPort"] = "Out",
						["endQuest"] = "17684617396725285",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17684617396715282"] = {
						["key"] = "17684617396715282",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -469.9545454545455,
							["y"] = 295.22727272727275
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17684617396725285"] = {
						["key"] = "17684617396725285",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1510,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17684617396725288"] = {
						["key"] = "17684617396725288",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17684627905039955"] = {
						["key"] = "17684627905039955",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 974.7,
							["y"] = 309.3
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "ActivityCamreaGame",
							["IsInterfaceJump"] = false
						}
					},
					["17724374486912539"] = {
						["key"] = "17724374486912539",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = -105.35,
							["y"] = 306.64166666666665
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_Album_1210129"
						}
					},
					["17724375148763114"] = {
						["key"] = "17724375148763114",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 589.25,
							["y"] = 308.54166666666663
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11227,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Album_1210129",
							["IsUseCount"] = false
						}
					},
					["17724376475893765"] = {
						["key"] = "17724376475893765",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成相册和drop",
						["pos"] = {
							["x"] = 213.25,
							["y"] = 317.44166666666666
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1210130,
								1210129
							}
						}
					},
					["17724376701064237"] = {
						["key"] = "17724376701064237",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 213.55,
							["y"] = 130.84166666666664
						},
						["propsData"] = {
							["NewDescription"] = "Description_400121_3",
							["NewDetail"] = "Content_400121_3",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17724381203586769"] = {
						["key"] = "17724381203586769",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁drop",
						["pos"] = {
							["x"] = 1248.2368421052631,
							["y"] = 305.4469298245614
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1210130
							}
						}
					},
					["17724534783391286"] = {
						["key"] = "17724534783391286",
						["type"] = "GoToRegionNode",
						["name"] = "如果玩家直接跑了，也得算他完成这环",
						["pos"] = {
							["x"] = 469.12410437859324,
							["y"] = 974.2142414860681
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Leave",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_Album_1210129"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17684617573395568"] = {
			["isStoryNode"] = true,
			["key"] = "17684617573395568",
			["type"] = "StoryNode",
			["name"] = "境界岛拍照",
			["pos"] = {
				["x"] = 2140.2353605716607,
				["y"] = 321.5811454496506
			},
			["propsData"] = {
				["QuestId"] = 40012104,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400121_1",
				["QuestDeatil"] = "Content_400121_1",
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
				["SubRegionId"] = 100101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_TakePhoto_1590338",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17684617573395569",
						["startPort"] = "QuestStart",
						["endQuest"] = "17690843585922813",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690827196101969",
						["startPort"] = "Out",
						["endQuest"] = "176846293738411230",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690850961694071",
						["startPort"] = "Out",
						["endQuest"] = "17690851199824257",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690851199824257",
						["startPort"] = "Out",
						["endQuest"] = "17690827196101969",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176846293738411230",
						["startPort"] = "Success",
						["endQuest"] = "17690827196101969",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17690852937356289",
						["startPort"] = "Out",
						["endQuest"] = "17684617573405572",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17690827196101969",
						["startPort"] = "Out",
						["endQuest"] = "17722608093649472025",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690827196101969",
						["startPort"] = "Out",
						["endQuest"] = "17690850961694071",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690843585922813",
						["startPort"] = "Out",
						["endQuest"] = "17690852361735884",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690843585922813",
						["startPort"] = "Out",
						["endQuest"] = "17696564416662249178",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690852361735884",
						["startPort"] = "Out",
						["endQuest"] = "17730379546502016",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730379546502016",
						["startPort"] = "Out",
						["endQuest"] = "17691384314992220742",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17691384314992220742",
						["startPort"] = "Out",
						["endQuest"] = "17690827196101969",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17691384314992220742",
						["startPort"] = "Out",
						["endQuest"] = "177226142398413022966",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176846293738411230",
						["startPort"] = "Success",
						["endQuest"] = "17690852937356289",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17684617573395569"] = {
						["key"] = "17684617573395569",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -797.019230769231,
							["y"] = 296.34615384615387
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17684617573405572"] = {
						["key"] = "17684617573405572",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1794.6923076923076,
							["y"] = 321.46153846153845
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17684617573405575"] = {
						["key"] = "17684617573405575",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["176846293738411230"] = {
						["key"] = "176846293738411230",
						["type"] = "CameraNode",
						["name"] = "相机节点",
						["pos"] = {
							["x"] = 1124.0978260869565,
							["y"] = 315.2717391304348
						},
						["propsData"] = {
							["bFadeInOut"] = false,
							["bIsForceOpenCamera"] = true,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["_GuidePointName"] = "BP_PhotoTarget_400121",
							["TargetPointList"] = {
								"BP_PhotoTarget_400121"
							},
							["EventId"] = 103017,
							["EventParams"] = {
								"1"
							},
							["Text_TargetFound"] = "",
							["Text_TargetNotFound"] = "",
							["ForceMaxLodStaticPointList"] = {},
							["bShouldSetCameraParams"] = true,
							["FocalLength"] = 15,
							["LookAtTargetName"] = "BP_PhotoTarget_400121",
							["StartPos"] = "(X=1756.329956,Y=4095.978027,Z=-2091.954834)",
							["bLockCameraPos"] = false,
							["bStartHiddenRole"] = true,
							["bLockHiddenRole"] = true,
							["bStartHiddenNPC"] = false,
							["bLockHiddenNPC"] = false,
							["bStartHiddenMonster"] = false,
							["bLockHiddenMonster"] = false,
							["bStartHiddenPet"] = false,
							["bLockHiddenPet"] = false,
							["bLockGamePause"] = false,
							["bForceGamePause"] = false
						}
					},
					["17690827196101969"] = {
						["key"] = "17690827196101969",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 748.4317226890755,
							["y"] = 312.32161955691356
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1590338,
							["StateId"] = 11301281,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17690843585922813"] = {
						["key"] = "17690843585922813",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = -438.9721234647707,
							["y"] = 298.86008109537516
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 100101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1590338"
						}
					},
					["17690850961694071"] = {
						["key"] = "17690850961694071",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 580.9317226890755,
							["y"] = 551.0716195569137
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17690851199824257"] = {
						["key"] = "17690851199824257",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 855.9317226890755,
							["y"] = 562.3216195569137
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1590338
							},
							["ManualItemIdList"] = {},
							["StateId"] = 11301280,
							["QuestId"] = 0
						}
					},
					["17690852361735884"] = {
						["key"] = "17690852361735884",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = -144.6452003878477,
							["y"] = 299.6293118646059
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1590338
							}
						}
					},
					["17690852937356289"] = {
						["key"] = "17690852937356289",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1451.7009534583062,
							["y"] = 322.033158018452
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1590338
							}
						}
					},
					["17691384314992220742"] = {
						["key"] = "17691384314992220742",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 430.52794358690136,
							["y"] = 313.69347819699504
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400121/40012102.40012102'",
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
							["HideMechanismsFX"] = false,
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
					},
					["17696564416662249178"] = {
						["key"] = "17696564416662249178",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = -170.69098184424274,
							["y"] = 94.20831668331662
						},
						["propsData"] = {
							["NewDescription"] = "Description_400121_2",
							["NewDetail"] = "Content_400121_2",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17722608093649472025"] = {
						["key"] = "17722608093649472025",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "干掉拍照点的指引",
						["pos"] = {
							["x"] = 1119.7308441558444,
							["y"] = 122.13896103896104
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1590338"
						}
					},
					["177226142398413022966"] = {
						["key"] = "177226142398413022966",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示拍照点的指引",
						["pos"] = {
							["x"] = 759.7308441558445,
							["y"] = 124.53896103896119
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1590338"
						}
					},
					["17730379546502016"] = {
						["key"] = "17730379546502016",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 159.27884615384568,
							["y"] = 302.68896321070207
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1590339,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_PhotoGoto_1590339"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17702034436942940"] = {
			["isStoryNode"] = true,
			["key"] = "17702034436942940",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2412.9823948884778,
				["y"] = 67.5374233104381
			},
			["propsData"] = {
				["QuestId"] = 40012105,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
				["QuestDeatil"] = "",
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
				["SubRegionId"] = 210101,
				["SubRegionIdList"] = {
					100101
				},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Album_1210129",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17702034436942941",
						["startPort"] = "QuestStart",
						["endQuest"] = "17702035615423893",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17702035615423893",
						["startPort"] = "Out",
						["endQuest"] = "17702036378564862",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17702036378564862",
						["startPort"] = "Out",
						["endQuest"] = "17702034436942944",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17702034436942941"] = {
						["key"] = "17702034436942941",
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
					["17702034436942944"] = {
						["key"] = "17702034436942944",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1783.3333333333333,
							["y"] = 315
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17702034436942947"] = {
						["key"] = "17702034436942947",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17702035615423893"] = {
						["key"] = "17702035615423893",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1126,
							["y"] = 302
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 100101,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17702035795864065"] = {
						["key"] = "17702035795864065",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1086,
							["y"] = 528.8333333333334
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17702036378564862"] = {
						["key"] = "17702036378564862",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1441.735294117647,
							["y"] = 306.69607843137254
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51012600,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
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