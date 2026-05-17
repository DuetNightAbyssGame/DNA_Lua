return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17447258370735450535",
			["startPort"] = "Success",
			["endStory"] = "17447258370735450536",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17447258370735450536",
			["startPort"] = "Success",
			["endStory"] = "17447258370735450537",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17448589446675491637",
			["startPort"] = "Success",
			["endStory"] = "17447258370735450534",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17447258370735450537",
			["startPort"] = "Success",
			["endStory"] = "174859613777116869268",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174859613777116869268",
			["startPort"] = "Success",
			["endStory"] = "17448589446675491637",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17447258370735450533",
			["startPort"] = "StoryStart",
			["endStory"] = "17512717337712164",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17512717337712164",
			["startPort"] = "Success",
			["endStory"] = "17447258370735450535",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17447258370735450533"] = {
			["isStoryNode"] = true,
			["key"] = "17447258370735450533",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 820,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 200231
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17447258370735450534"] = {
			["isStoryNode"] = true,
			["key"] = "17447258370735450534",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2659.7451883221634,
				["y"] = 255.1518366642235
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17447258370735450535"] = {
			["isStoryNode"] = true,
			["key"] = "17447258370735450535",
			["type"] = "StoryNode",
			["name"] = "与拉斯对话",
			["pos"] = {
				["x"] = 1076,
				["y"] = 292.8870967940411
			},
			["propsData"] = {
				["QuestId"] = 20023101,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200231_1",
				["QuestDeatil"] = "Content_200231_1",
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
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Lars_SSS_1191533",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17447258370735450542",
						["startPort"] = "Out",
						["endQuest"] = "17447258370735450540",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17447258370735450539",
						["startPort"] = "QuestStart",
						["endQuest"] = "17447258370735450542",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17447258370735450539"] = {
						["key"] = "17447258370735450539",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 920,
							["y"] = 305.45454545454544
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17447258370735450540"] = {
						["key"] = "17447258370735450540",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1622.9090909090908,
							["y"] = 306.54545454545456
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17447258370735450541"] = {
						["key"] = "17447258370735450541",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1626,
							["y"] = 458.63636363636374
						},
						["propsData"] = {}
					},
					["17447258370735450542"] = {
						["key"] = "17447258370735450542",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1257.9729206646653,
							["y"] = 278.60541646226795
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009608,
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
		["17447258370735450536"] = {
			["isStoryNode"] = true,
			["key"] = "17447258370735450536",
			["type"] = "StoryNode",
			["name"] = "前往小巷&与门交互",
			["pos"] = {
				["x"] = 1340.4002562708563,
				["y"] = 293.984218058564
			},
			["propsData"] = {
				["QuestId"] = 20023102,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200231_2",
				["QuestDeatil"] = "Content_200231_2",
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
				["StoryGuidePointName"] = "QuestPoint_20023102",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17447258370735450543",
						["startPort"] = "QuestStart",
						["endQuest"] = "17447258370735450546",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17447258370735450546",
						["startPort"] = "Out",
						["endQuest"] = "17447258370735450548",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17447258370735450548",
						["startPort"] = "Out",
						["endQuest"] = "17447258370735450547",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17447258370735450547",
						["startPort"] = "Out",
						["endQuest"] = "17447258370735450544",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17447258370735450543"] = {
						["key"] = "17447258370735450543",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 798,
							["y"] = 306
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17447258370735450544"] = {
						["key"] = "17447258370735450544",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2226.2134706924016,
							["y"] = 300.24539474730364
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17447258370735450545"] = {
						["key"] = "17447258370735450545",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2165.442070508084,
							["y"] = 570.0762189675626
						},
						["propsData"] = {}
					},
					["17447258370735450546"] = {
						["key"] = "17447258370735450546",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1046,
							["y"] = 304
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191535,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_20023102"
						}
					},
					["17447258370735450547"] = {
						["key"] = "17447258370735450547",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成拉斯",
						["pos"] = {
							["x"] = 1701.1229065406822,
							["y"] = 294.08703968176985
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191536
							}
						}
					},
					["17447258370735450548"] = {
						["key"] = "17447258370735450548",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1367.80440262174,
							["y"] = 299.213347867309
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009610,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20023102",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
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
									["TalkActorId"] = 700303,
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
					}
				},
				["commentData"] = {}
			}
		},
		["17447258370735450537"] = {
			["isStoryNode"] = true,
			["key"] = "17447258370735450537",
			["type"] = "StoryNode",
			["name"] = "前往矿坑遇见大叔",
			["pos"] = {
				["x"] = 1627.1217192516992,
				["y"] = 292.98121222572524
			},
			["propsData"] = {
				["QuestId"] = 20023103,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200231_3",
				["QuestDeatil"] = "Content_200231_3",
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
				["StoryGuidePointName"] = "Npc_Donat_SSS_1240916",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174860570823718649117",
						["startPort"] = "Out",
						["endQuest"] = "174860585748318651336",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174860590876018652868",
						["startPort"] = "Out",
						["endQuest"] = "174860570823718649117",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17489381170866244820",
						["startPort"] = "Out",
						["endQuest"] = "17489381170866244821",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17447258370735450554",
						["startPort"] = "Out",
						["endQuest"] = "17489392903708620960",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174860585748318651336",
						["startPort"] = "Success",
						["endQuest"] = "17447258370735450550",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17489392903708620960",
						["startPort"] = "Out",
						["endQuest"] = "174860590876018652868",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174860585748318651336",
						["startPort"] = "Fail",
						["endQuest"] = "174910671301941156727",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174860585748318651336",
						["startPort"] = "PassiveFail",
						["endQuest"] = "174910671301941156727",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174910671301941156727",
						["startPort"] = "Out",
						["endQuest"] = "17447258370735450551",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17447258370735450549",
						["startPort"] = "QuestStart",
						["endQuest"] = "174928012722754850389",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174928012722754850389",
						["startPort"] = "Out",
						["endQuest"] = "17447258370735450554",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17447258370735450549"] = {
						["key"] = "17447258370735450549",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 736.2830867053601,
							["y"] = 266.7939816679938
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17447258370735450550"] = {
						["key"] = "17447258370735450550",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2952.9678074428657,
							["y"] = 210.48965131314304
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17447258370735450551"] = {
						["key"] = "17447258370735450551",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3114.918467000517,
							["y"] = 431.11690398812914
						},
						["propsData"] = {}
					},
					["17447258370735450554"] = {
						["key"] = "17447258370735450554",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1284.584927174211,
							["y"] = 272.89329253715016
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700301,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Donat_SSS_1240916",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51009629,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174860570823718649117"] = {
						["key"] = "174860570823718649117",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2221.8634645299844,
							["y"] = 286.7446089366498
						},
						["propsData"] = {
							["NewDescription"] = "Description_200231_4",
							["NewDetail"] = "Content_200231_4",
							["SubTaskTargetIndex"] = 0
						}
					},
					["174860585748318651336"] = {
						["key"] = "174860585748318651336",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 2503.0474450942793,
							["y"] = 262.2342057009259
						},
						["propsData"] = {
							["SpecialConfigId"] = 1050,
							["BlackScreenImmediately"] = true
						}
					},
					["174860590876018652868"] = {
						["key"] = "174860590876018652868",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示任务指引点节点",
						["pos"] = {
							["x"] = 1911.9598514288116,
							["y"] = 280.89487215191855
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_20023104"
						}
					},
					["17489381170866244820"] = {
						["key"] = "17489381170866244820",
						["type"] = "SetNpcPatrolNode",
						["name"] = "设置多纳特巡逻1",
						["pos"] = {
							["x"] = 1655.360489590483,
							["y"] = -132.77799970975562
						},
						["propsData"] = {
							["NpcId"] = 700301,
							["PatrolId"] = 2002310401
						}
					},
					["17489381170866244821"] = {
						["key"] = "17489381170866244821",
						["type"] = "SendMessageNode",
						["name"] = "发送消息，让多纳特上路",
						["pos"] = {
							["x"] = 1945.8068220354926,
							["y"] = -123.19298823941185
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "DonatGo1",
							["UnitId"] = 700301
						}
					},
					["17489392903708620960"] = {
						["key"] = "17489392903708620960",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁多纳特",
						["pos"] = {
							["x"] = 1560.5930505088236,
							["y"] = 262.5441118433291
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240916
							}
						}
					},
					["174910671301941156727"] = {
						["key"] = "174910671301941156727",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2820.7190306441025,
							["y"] = 435.15095350305086
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_Nvzhu_20023103",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["174928012722754850389"] = {
						["key"] = "174928012722754850389",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成多纳特",
						["pos"] = {
							["x"] = 1022.4673357838676,
							["y"] = 292.0274152507302
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240916
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17448589446675491637"] = {
			["isStoryNode"] = true,
			["key"] = "17448589446675491637",
			["type"] = "StoryNode",
			["name"] = "返回小巷+线索1    ",
			["pos"] = {
				["x"] = 2255.757906971642,
				["y"] = 308.3599819964297
			},
			["propsData"] = {
				["QuestId"] = 20023108,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200231_5",
				["QuestDeatil"] = "Content_200231_5",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_20023108",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17448590098465492157",
						["startPort"] = "Out",
						["endQuest"] = "17448590585515492524",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17448589446685491638",
						["startPort"] = "QuestStart",
						["endQuest"] = "174903285757837562848",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174903285757837562848",
						["startPort"] = "Out",
						["endQuest"] = "17448590098465492157",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17448590585515492524",
						["startPort"] = "Out",
						["endQuest"] = "174903320199737565292",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501294609933785647",
						["startPort"] = "Out",
						["endQuest"] = "17501294609933785648",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501294609933785645",
						["startPort"] = "true",
						["endQuest"] = "17501294609933785646",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501294609933785646",
						["startPort"] = "Out",
						["endQuest"] = "17501294609933785649",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501294609933785649",
						["startPort"] = "Out",
						["endQuest"] = "17501294609933785647",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501294609933785645",
						["startPort"] = "false",
						["endQuest"] = "17501294609933785647",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "174903320199737565292",
						["startPort"] = "Out",
						["endQuest"] = "17501294609933785645",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501294609933785648",
						["startPort"] = "Out",
						["endQuest"] = "17448589446685491641",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17448589446685491638"] = {
						["key"] = "17448589446685491638",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 574.8888965496799,
							["y"] = 325.55555539857215
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448589446685491641"] = {
						["key"] = "17448589446685491641",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3571.333330696012,
							["y"] = 327.5555556811423
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17448589446685491644"] = {
						["key"] = "17448589446685491644",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1976,
							["y"] = 582
						},
						["propsData"] = {}
					},
					["17448590098465492157"] = {
						["key"] = "17448590098465492157",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1110,
							["y"] = 313.1111110797144
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009665,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20023108",
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
									["TalkActorId"] = 700303,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700301,
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
					["17448590585515492524"] = {
						["key"] = "17448590585515492524",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1386.2222221594288,
							["y"] = 311.1111110797144
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009713,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
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
					["174903285757837562848"] = {
						["key"] = "174903285757837562848",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 822.8148246559311,
							["y"] = 321.77777190659776
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191538,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_20023108"
						}
					},
					["174903320199737565292"] = {
						["key"] = "174903320199737565292",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1666.1481313334796,
							["y"] = 308.44443471147224
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009714,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20023108",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
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
									["TalkActorId"] = 700303,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700301,
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
					["17501294609933785645"] = {
						["key"] = "17501294609933785645",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "0未解锁推理问题，1为已解锁",
						["pos"] = {
							["x"] = 1960.2826900404054,
							["y"] = 289.5556489161263
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Huozai04Side",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17501294609933785646"] = {
						["key"] = "17501294609933785646",
						["type"] = "UnlockDetectiveQuestionNode",
						["name"] = "开启推理问题",
						["pos"] = {
							["x"] = 2313.6350951486756,
							["y"] = 154.51027877428135
						},
						["propsData"] = {
							["QuestionIds"] = {
								2002
							},
							["OpenToast"] = false
						}
					},
					["17501294609933785647"] = {
						["key"] = "17501294609933785647",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索",
						["pos"] = {
							["x"] = 2802.352506639967,
							["y"] = 327.48972122571854
						},
						["propsData"] = {
							["AnswerIds"] = {
								200201
							}
						}
					},
					["17501294609933785648"] = {
						["key"] = "17501294609933785648",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 3119.717309959595,
							["y"] = 323.47253607842913
						},
						["propsData"] = {
							["AnswerId"] = 200201,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["17501294609933785649"] = {
						["key"] = "17501294609933785649",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2576.8092005226054,
							["y"] = 153.82632498785256
						},
						["propsData"] = {
							["VarName"] = "Huozai04Side",
							["VarValue"] = 1
						}
					}
				},
				["commentData"] = {
					["17501294751363785918"] = {
						["key"] = "17501294751363785918",
						["name"] = "获得线索1",
						["position"] = {
							["x"] = 1892,
							["y"] = 62
						},
						["size"] = {
							["width"] = 1596,
							["height"] = 492
						}
					}
				}
			}
		},
		["174859613777116869268"] = {
			["isStoryNode"] = true,
			["key"] = "174859613777116869268",
			["type"] = "StoryNode",
			["name"] = "进入矿坑+线索3    ",
			["pos"] = {
				["x"] = 1924.0230380874018,
				["y"] = 289.06668572678444
			},
			["propsData"] = {
				["QuestId"] = 20023105,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200231_4",
				["QuestDeatil"] = "Content_200231_4",
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
				["SubRegionId"] = 101301,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_20023106",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174859613777116869269",
						["startPort"] = "QuestStart",
						["endQuest"] = "174859679754616871350",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174859679754616871350",
						["startPort"] = "Out",
						["endQuest"] = "174894188750513377294",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174894188750513377294",
						["startPort"] = "Fail",
						["endQuest"] = "174902914413033079622",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174902914413033079622",
						["startPort"] = "Out",
						["endQuest"] = "174859613777216869275",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "174894188750513377294",
						["startPort"] = "PassiveFail",
						["endQuest"] = "174903000203534872838",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174903000203534872838",
						["startPort"] = "Out",
						["endQuest"] = "174859613777216869275",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17501293839583783822",
						["startPort"] = "Out",
						["endQuest"] = "17501293839583783823",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501293839583783820",
						["startPort"] = "true",
						["endQuest"] = "17501293839583783821",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501293839583783821",
						["startPort"] = "Out",
						["endQuest"] = "17501293839583783824",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501293839583783824",
						["startPort"] = "Out",
						["endQuest"] = "17501293839583783822",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501293839583783820",
						["startPort"] = "false",
						["endQuest"] = "17501293839583783822",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17501293839583783823",
						["startPort"] = "Out",
						["endQuest"] = "174859613777116869272",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174894188750513377294",
						["startPort"] = "Success",
						["endQuest"] = "17501293839583783820",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174859613777116869269"] = {
						["key"] = "174859613777116869269",
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
					["174859613777116869272"] = {
						["key"] = "174859613777116869272",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3281.3772209610715,
							["y"] = 313.20086263792075
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174859613777216869275"] = {
						["key"] = "174859613777216869275",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2227.1028280405103,
							["y"] = 486.27341865419567
						},
						["propsData"] = {}
					},
					["174859679754616871350"] = {
						["key"] = "174859679754616871350",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1147.282051252791,
							["y"] = 321.28205125279106
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101301,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_20023106"
						}
					},
					["174894188750513377294"] = {
						["key"] = "174894188750513377294",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1446.3767645146415,
							["y"] = 286.5526493977138
						},
						["propsData"] = {
							["SpecialConfigId"] = 1051,
							["BlackScreenImmediately"] = false
						}
					},
					["174895118236916943914"] = {
						["key"] = "174895118236916943914",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 2776.572293051789,
							["y"] = -267.1653654884837
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009646,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174895967132021415095"] = {
						["key"] = "174895967132021415095",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示任务指引点节点",
						["pos"] = {
							["x"] = 2656.0105618564367,
							["y"] = -79.98220484870376
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_20023107"
						}
					},
					["174902914413033079622"] = {
						["key"] = "174902914413033079622",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1903.2862484031293,
							["y"] = 483.15546555406854
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101103,
							["StartIndex"] = 9,
							["IsWhite"] = false
						}
					},
					["174903000203534872838"] = {
						["key"] = "174903000203534872838",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1896.1433913640735,
							["y"] = 690.2983196866884
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NvzhuPoint_20023106",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["17501293839583783820"] = {
						["key"] = "17501293839583783820",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "0未解锁推理问题，1为已解锁",
						["pos"] = {
							["x"] = 1776.0402623183984,
							["y"] = 261.07080271986274
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Huozai04Side",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17501293839583783821"] = {
						["key"] = "17501293839583783821",
						["type"] = "UnlockDetectiveQuestionNode",
						["name"] = "开启推理问题",
						["pos"] = {
							["x"] = 2099.3926674266686,
							["y"] = 126.0254325780179
						},
						["propsData"] = {
							["QuestionIds"] = {
								2002
							},
							["OpenToast"] = false
						}
					},
					["17501293839583783822"] = {
						["key"] = "17501293839583783822",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索",
						["pos"] = {
							["x"] = 2612.11007891796,
							["y"] = 329.004875029455
						},
						["propsData"] = {
							["AnswerIds"] = {
								200203
							}
						}
					},
					["17501293839583783823"] = {
						["key"] = "17501293839583783823",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 2918.505185221185,
							["y"] = 305.0482935374225
						},
						["propsData"] = {
							["AnswerId"] = 200203,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["17501293839583783824"] = {
						["key"] = "17501293839583783824",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2341.475863849807,
							["y"] = 146.97784298842248
						},
						["propsData"] = {
							["VarName"] = "Huozai04Side",
							["VarValue"] = 1
						}
					}
				},
				["commentData"] = {
					["17501293871323784005"] = {
						["key"] = "17501293871323784005",
						["name"] = "获得线索3",
						["position"] = {
							["x"] = 1695.7575838376815,
							["y"] = 6.303038313077195
						},
						["size"] = {
							["width"] = 1498.4848253888242,
							["height"] = 474.2424169329646
						}
					}
				}
			}
		},
		["17512717337712164"] = {
			["isStoryNode"] = true,
			["key"] = "17512717337712164",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 895.6032608695652,
				["y"] = 111.79241953698471
			},
			["propsData"] = {
				["QuestId"] = 20023100,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 101101,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Lars_SSS_1191533",
				["bIsPlayBlackScreenOnComplete"] = true,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17512717337712174",
						["startPort"] = "Out",
						["endQuest"] = "17512717337712172",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17512717337712178",
						["startPort"] = "Out",
						["endQuest"] = "17512717337712172",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17512717337712177",
						["startPort"] = "true",
						["endQuest"] = "17512717337712174",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512717337712172",
						["startPort"] = "CancelOut",
						["endQuest"] = "17512717337712180",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512717337712180",
						["startPort"] = "Out",
						["endQuest"] = "17512717337712170",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17512717337712168",
						["startPort"] = "QuestStart",
						["endQuest"] = "17512717337712177",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512717337712177",
						["startPort"] = "false",
						["endQuest"] = "17512717337712178",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17512717337712172",
						["startPort"] = "ApproveOut",
						["endQuest"] = "17512717337712169",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17512717337712168"] = {
						["key"] = "17512717337712168",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 517.7901008194377,
							["y"] = 311.1283564871089
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17512717337712169"] = {
						["key"] = "17512717337712169",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3048.4444366580665,
							["y"] = 219.33333529248648
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17512717337712170"] = {
						["key"] = "17512717337712170",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3065.111102947973,
							["y"] = 393.55555859475464
						},
						["propsData"] = {}
					},
					["17512717337712171"] = {
						["key"] = "17512717337712171",
						["type"] = "TalkNode",
						["name"] = "黑幕",
						["pos"] = {
							["x"] = 1693.8672117512372,
							["y"] = 468.7524852092009
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51009602,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
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
					["17512717337712172"] = {
						["key"] = "17512717337712172",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 2434.8095163168637,
							["y"] = 286.16636814671847
						},
						["propsData"] = {
							["SideQuestChainId"] = 200231,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["17512717337712173"] = {
						["key"] = "17512717337712173",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1406.2229687635509,
							["y"] = 737.9084407171574
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191532,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Lars_SSS_1191533"
						}
					},
					["17512717337712174"] = {
						["key"] = "17512717337712174",
						["type"] = "TalkNode",
						["name"] = "拒绝后再次对话",
						["pos"] = {
							["x"] = 1660.1392908804482,
							["y"] = -64.53961179666871
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700303,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Lars_SSS_1191533",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51009603,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17512717337712175"] = {
						["key"] = "17512717337712175",
						["type"] = "TalkNode",
						["name"] = "再次和小男孩对话",
						["pos"] = {
							["x"] = 2051.3766527455678,
							["y"] = 698.6825990497822
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
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
					},
					["17512717337712176"] = {
						["key"] = "17512717337712176",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1802.3766527455675,
							["y"] = 716.1825990497822
						},
						["propsData"] = {
							["WaitTime"] = 0
						}
					},
					["17512717337712177"] = {
						["key"] = "17512717337712177",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "1为拒绝任务，0为接受任务",
						["pos"] = {
							["x"] = 981.8990108026514,
							["y"] = 297.57575283511767
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "LarsSide",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["17512717337712178"] = {
						["key"] = "17512717337712178",
						["type"] = "TalkNode",
						["name"] = "对话",
						["pos"] = {
							["x"] = 1995.2412063711322,
							["y"] = 367.12457878863415
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700303,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Lars_SSS_1191533",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51009602,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17512717337712180"] = {
						["key"] = "17512717337712180",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2753.399464930915,
							["y"] = 403.7307648974035
						},
						["propsData"] = {
							["VarName"] = "LarsSide",
							["VarValue"] = 1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}