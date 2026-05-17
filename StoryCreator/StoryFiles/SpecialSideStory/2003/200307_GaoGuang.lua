return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17606033024671",
			["startPort"] = "StoryStart",
			["endStory"] = "1760603478528656195",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1760603478528656195",
			["startPort"] = "Success",
			["endStory"] = "1760603476689656091",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1760603476689656091",
			["startPort"] = "Success",
			["endStory"] = "17609503855511979075",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17609503855511979075",
			["startPort"] = "Success",
			["endStory"] = "17609505345491980562",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17609505345491980562",
			["startPort"] = "Success",
			["endStory"] = "17606033024685",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17606033024671"] = {
			["isStoryNode"] = true,
			["key"] = "17606033024671",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 200307
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17606033024685"] = {
			["isStoryNode"] = true,
			["key"] = "17606033024685",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2361.4696356275304,
				["y"] = 292.30364372469637
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1760603476689656091"] = {
			["isStoryNode"] = true,
			["key"] = "1760603476689656091",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1452.9538461538461,
				["y"] = 286.91022707269843
			},
			["propsData"] = {
				["QuestId"] = 20030701,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200307_1",
				["QuestDeatil"] = "Content_200307_1",
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
				["bDeadTriggerQuestFail"] = true,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_200307_2080079",
				["JumpId"] = 0,
				["FailBlackScreenText"] = "",
				["FadeInTime"] = 1,
				["FadeOutTime"] = 1,
				["ContinueTime"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17606868406826245960",
						["startPort"] = "Out",
						["endQuest"] = "17606873013949205100",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17606868406826245960",
						["startPort"] = "Out",
						["endQuest"] = "17606873277549205844",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1761119277383991255",
						["startPort"] = "Out",
						["endQuest"] = "1761119340840992019",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1761119340840992019",
						["startPort"] = "Out",
						["endQuest"] = "1760603476689656095",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17611202223244950062",
						["startPort"] = "Out",
						["endQuest"] = "17606868406826245960",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760603476689656092",
						["startPort"] = "QuestStart",
						["endQuest"] = "17611202223244950062",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760950274659991937",
						["startPort"] = "Out",
						["endQuest"] = "17611206666055940831",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611206666055940831",
						["startPort"] = "Out",
						["endQuest"] = "1760950275323991964",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17606873013949205100",
						["startPort"] = "Out",
						["endQuest"] = "17675138418042148796",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675138418042148796",
						["startPort"] = "Out",
						["endQuest"] = "1760950274659991937",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675138418042148796",
						["startPort"] = "Out",
						["endQuest"] = "1761119277383991255",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1760603476689656092"] = {
						["key"] = "1760603476689656092",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 517.7272727272727,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1760603476689656095"] = {
						["key"] = "1760603476689656095",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2362.4864864864862,
							["y"] = 302.07567567567565
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1760603476689656098"] = {
						["key"] = "1760603476689656098",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17606868406826245960"] = {
						["key"] = "17606868406826245960",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1078.5,
							["y"] = 129.60000000000002
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700365,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_200307_DaoYan_2080233",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51125006,
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17606873013949205100"] = {
						["key"] = "17606873013949205100",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1078.661111111111,
							["y"] = 304.5055555555556
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125012,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200307",
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700366,
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
					["17606873277549205844"] = {
						["key"] = "17606873277549205844",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1399.95,
							["y"] = 129.09999999999997
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080233
							}
						}
					},
					["1760950274659991937"] = {
						["key"] = "1760950274659991937",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1714.6746424885744,
							["y"] = 104.35761462479718
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125025,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1760950275323991964"] = {
						["key"] = "1760950275323991964",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2407.7603567742885,
							["y"] = 109.44332891051143
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125028,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1761119277383991255"] = {
						["key"] = "1761119277383991255",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1691.0663728286233,
							["y"] = 305.9240342234896
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "TargetPoint_200307",
							["StaticCreatorIdList"] = {
								2080236,
								2080237,
								2080238
							}
						}
					},
					["1761119340840992019"] = {
						["key"] = "1761119340840992019",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2046.421282597326,
							["y"] = 291.4203487198042
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 3,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2080236,
								2080237,
								2080238
							}
						}
					},
					["17611202223244950062"] = {
						["key"] = "17611202223244950062",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 801.5454545454546,
							["y"] = 306.68181818181813
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080079,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_200307_2080079"
						}
					},
					["17611206666055940831"] = {
						["key"] = "17611206666055940831",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2041.7545056476088,
							["y"] = 104.27042842215243
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["17675138418042148796"] = {
						["key"] = "17675138418042148796",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1403.0758145363407,
							["y"] = 313.19980204133515
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125022,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200307",
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700366,
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
									["TalkActorId"] = 700381,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700382,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700365,
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
		["1760603478528656195"] = {
			["isStoryNode"] = true,
			["key"] = "1760603478528656195",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 1132.052631578947,
				["y"] = 286.94736842105254
			},
			["propsData"] = {
				["QuestId"] = 20030700,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 104107,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_200307_DaoYan_2080233",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1760604113682362",
						["startPort"] = "Out",
						["endQuest"] = "1760603478529656202",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1760603478529656202",
						["startPort"] = "ApproveOut",
						["endQuest"] = "1760603478529656199",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1760603478529656202",
						["startPort"] = "CancelOut",
						["endQuest"] = "1760603478529656210",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17606870683627233359",
						["startPort"] = "Out",
						["endQuest"] = "1760604113682362",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760603478529656196",
						["startPort"] = "QuestStart",
						["endQuest"] = "17606870683627233359",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1760603478529656196"] = {
						["key"] = "1760603478529656196",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 523.0978260869565,
							["y"] = 287.22826086956525
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1760603478529656199"] = {
						["key"] = "1760603478529656199",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1648.3552631578946,
							["y"] = 288.09210526315786
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1760603478529656202"] = {
						["key"] = "1760603478529656202",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1361.8306636155605,
							["y"] = 286.29427917620137
						},
						["propsData"] = {
							["SideQuestChainId"] = 200307,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["1760603478529656210"] = {
						["key"] = "1760603478529656210",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1641.0820158102765,
							["y"] = 447.3764822134387
						},
						["propsData"] = {}
					},
					["1760604113682362"] = {
						["key"] = "1760604113682362",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1082.8693437661475,
							["y"] = 286.0188787185354
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700365,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_200307_DaoYan_2080233",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51125000,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17606870683627233359"] = {
						["key"] = "17606870683627233359",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 803.0736351748938,
							["y"] = 287.8424975482183
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Npc_200307_DaoYan_2080233",
							["StaticCreatorIdList"] = {
								2080233
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17609503855511979075"] = {
			["isStoryNode"] = true,
			["key"] = "17609503855511979075",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1760.6354229361964,
				["y"] = 277.1423152512055
			},
			["propsData"] = {
				["QuestId"] = 20030702,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200307_1",
				["QuestDeatil"] = "Content_200307_1",
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
				["bDeadTriggerQuestFail"] = true,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_200307_2080079",
				["JumpId"] = 0,
				["FailBlackScreenText"] = "",
				["FadeInTime"] = 1,
				["FadeOutTime"] = 1,
				["ContinueTime"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17611203066314951461",
						["startPort"] = "Out",
						["endQuest"] = "17609503855511979084",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17609503855511979080",
						["startPort"] = "QuestStart",
						["endQuest"] = "17611203066314951461",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611215553797918863",
						["startPort"] = "Out",
						["endQuest"] = "17611215553797918864",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611215812557919664",
						["startPort"] = "Out",
						["endQuest"] = "17611215812557919665",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611215812557919665",
						["startPort"] = "Out",
						["endQuest"] = "17609503855511979081",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17609503855511979086",
						["startPort"] = "Out",
						["endQuest"] = "17611256743614288627",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17615359641121992989",
						["startPort"] = "Out",
						["endQuest"] = "17611215812557919664",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611256743614288627",
						["startPort"] = "Out",
						["endQuest"] = "17609505081141980229",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611215553797918864",
						["startPort"] = "Out",
						["endQuest"] = "17615359641121992989",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17609503855511979084",
						["startPort"] = "Out",
						["endQuest"] = "17617375865731921",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17617375865731921",
						["startPort"] = "Out",
						["endQuest"] = "1762414003510981672",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762414003510981672",
						["startPort"] = "Out",
						["endQuest"] = "17609503855511979086",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762414003510981672",
						["startPort"] = "Out",
						["endQuest"] = "17611215553797918863",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17615359641121992989",
						["startPort"] = "Out",
						["endQuest"] = "1762507461719987499",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762507461719987499",
						["startPort"] = "Out",
						["endQuest"] = "17609503855521979087",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17609503855511979080"] = {
						["key"] = "17609503855511979080",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 323.50563909774445,
							["y"] = 293.5338345864662
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17609503855511979081"] = {
						["key"] = "17609503855511979081",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3252.830357142857,
							["y"] = 299.0217532467532
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17609503855511979082"] = {
						["key"] = "17609503855511979082",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17609503855511979084"] = {
						["key"] = "17609503855511979084",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 846.5771154937669,
							["y"] = 270.3695451933655
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125034,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200307",
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700366,
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
					["17609503855511979086"] = {
						["key"] = "17609503855511979086",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1683.9730750904553,
							["y"] = 75.5886986043385
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125082,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17609503855521979087"] = {
						["key"] = "17609503855521979087",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2801.2989524798536,
							["y"] = 71.33733744281406
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125091,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17609505081141980229"] = {
						["key"] = "17609505081141980229",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2174.5078012338768,
							["y"] = 80.97613134046543
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125085,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17611203066314951461"] = {
						["key"] = "17611203066314951461",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 589.4696437600219,
							["y"] = 269.42037509209376
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080079,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_200307_2080079"
						}
					},
					["17611215553797918863"] = {
						["key"] = "17611215553797918863",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1682.6947582890161,
							["y"] = 282.9210982738514
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "TargetPoint_200307",
							["StaticCreatorIdList"] = {
								2080239
							}
						}
					},
					["17611215553797918864"] = {
						["key"] = "17611215553797918864",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1963.045357712891,
							["y"] = 278.3743093218901
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2080239
							}
						}
					},
					["17611215812557919664"] = {
						["key"] = "17611215812557919664",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2563.079525321084,
							["y"] = 284.1253662697236
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "TargetPoint_200307",
							["StaticCreatorIdList"] = {
								2080239
							}
						}
					},
					["17611215812557919665"] = {
						["key"] = "17611215812557919665",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2908.577116995587,
							["y"] = 283.5865165299744
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2080239
							}
						}
					},
					["17611256743614288627"] = {
						["key"] = "17611256743614288627",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1930.549656322113,
							["y"] = 73.86902479393139
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["17615359641121992989"] = {
						["key"] = "17615359641121992989",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2278.371271564872,
							["y"] = 271.84146721520824
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125090,
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
					["17617375865731921"] = {
						["key"] = "17617375865731921",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1123.8032334203806,
							["y"] = 268.9691479153433
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125056,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_200307",
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700366,
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
									["TalkActorId"] = 700365,
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
					["1762414003510981672"] = {
						["key"] = "1762414003510981672",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1403.3070293687117,
							["y"] = 272.4514907793781
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125077,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_200307",
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700365,
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
									["TalkActorId"] = 700379,
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
					["1762507461719987499"] = {
						["key"] = "1762507461719987499",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2558.7277419091197,
							["y"] = 74.74067097090544
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17609505345491980562"] = {
			["isStoryNode"] = true,
			["key"] = "17609505345491980562",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2080.2001288185493,
				["y"] = 274.42376321500643
			},
			["propsData"] = {
				["QuestId"] = 20030703,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200307_1",
				["QuestDeatil"] = "Content_200307_1",
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
				["bDeadTriggerQuestFail"] = true,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_200307_2080079",
				["JumpId"] = 0,
				["FailBlackScreenText"] = "",
				["FadeInTime"] = 1,
				["FadeOutTime"] = 1,
				["ContinueTime"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17609507843952970058",
						["startPort"] = "Out",
						["endQuest"] = "17609505345491980568",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17611203217454951933",
						["startPort"] = "Out",
						["endQuest"] = "17609505345491980570",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17609505345491980567",
						["startPort"] = "QuestStart",
						["endQuest"] = "17611203217454951933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611216140817920644",
						["startPort"] = "Out",
						["endQuest"] = "17611216140817920645",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17609505345491980570",
						["startPort"] = "Out",
						["endQuest"] = "17611216140817920644",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611216140817920645",
						["startPort"] = "Out",
						["endQuest"] = "17609507843952970058",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17609505345491980567"] = {
						["key"] = "17609505345491980567",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 751.7142857142858,
							["y"] = 296
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17609505345491980568"] = {
						["key"] = "17609505345491980568",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2453.333333333333,
							["y"] = 303.33333333333326
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17609505345491980569"] = {
						["key"] = "17609505345491980569",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17609505345491980570"] = {
						["key"] = "17609505345491980570",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1324.6,
							["y"] = 287.75
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125095,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200307",
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700379,
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
					["17609507843952970058"] = {
						["key"] = "17609507843952970058",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2151.363198859739,
							["y"] = 274.7081640753466
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51125106,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200307",
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700379,
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
									["TalkActorId"] = 700365,
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
					["17611203217454951933"] = {
						["key"] = "17611203217454951933",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1046,
							["y"] = 290
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080079,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_200307_2080079"
						}
					},
					["17611216140817920644"] = {
						["key"] = "17611216140817920644",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1600.4551665436666,
							["y"] = 303.15520409638066
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "TargetPoint_200307",
							["StaticCreatorIdList"] = {
								2080239
							}
						}
					},
					["17611216140817920645"] = {
						["key"] = "17611216140817920645",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1871.1434096457026,
							["y"] = 282.8181852593619
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2080239
							}
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}