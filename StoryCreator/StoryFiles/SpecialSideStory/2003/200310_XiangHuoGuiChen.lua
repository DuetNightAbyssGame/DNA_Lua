return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "176528048289612668",
			["startPort"] = "StoryStart",
			["endStory"] = "176528052965412927",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176528053394013134",
			["startPort"] = "Success",
			["endStory"] = "1765285745411721345",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1765285745411721345",
			["startPort"] = "Success",
			["endStory"] = "1765284616163713529",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1765284616163713529",
			["startPort"] = "Success",
			["endStory"] = "17653712895252454211",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17653712895252454211",
			["startPort"] = "Success",
			["endStory"] = "176528048289612671",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "176528052965412927",
			["startPort"] = "Success",
			["endStory"] = "176528053394013134",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["176528048289612668"] = {
			["isStoryNode"] = true,
			["key"] = "176528048289612668",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 200310
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176528048289612671"] = {
			["isStoryNode"] = true,
			["key"] = "176528048289612671",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1704.25,
				["y"] = 122.74999999999997
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176528052965412927"] = {
			["isStoryNode"] = true,
			["key"] = "176528052965412927",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 1071,
				["y"] = -106.25000000000006
			},
			["propsData"] = {
				["QuestId"] = 20031001,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 104107,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Bai_2080414",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "176528052965412934",
						["startPort"] = "CancelOut",
						["endQuest"] = "176528052965412942",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "176528052965412928",
						["startPort"] = "QuestStart",
						["endQuest"] = "17655372863392066",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17655372863392066",
						["startPort"] = "Out",
						["endQuest"] = "17655372930582211",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17655372930582211",
						["startPort"] = "Out",
						["endQuest"] = "176528052965412934",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "176528052965412934",
						["startPort"] = "ApproveOut",
						["endQuest"] = "1766654712934357624",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766654712934357624",
						["startPort"] = "Out",
						["endQuest"] = "1766654712934357623",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766654712934357623",
						["startPort"] = "Out",
						["endQuest"] = "176528052965412931",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["176528052965412928"] = {
						["key"] = "176528052965412928",
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
					["176528052965412931"] = {
						["key"] = "176528052965412931",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2746,
							["y"] = 276
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176528052965412934"] = {
						["key"] = "176528052965412934",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1742,
							["y"] = 274
						},
						["propsData"] = {
							["SideQuestChainId"] = 200310,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["176528052965412942"] = {
						["key"] = "176528052965412942",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2090,
							["y"] = 506
						},
						["propsData"] = {}
					},
					["17655372863392066"] = {
						["key"] = "17655372863392066",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成小白",
						["pos"] = {
							["x"] = 1116.75,
							["y"] = 302
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080414
							}
						}
					},
					["17655372930582211"] = {
						["key"] = "17655372930582211",
						["type"] = "TalkNode",
						["name"] = "与小白对话",
						["pos"] = {
							["x"] = 1420,
							["y"] = 276
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701087,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Bai_2080414",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200310/20031001.20031001'",
							["TalkType"] = "FreeSimple",
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
					["1766654712934357623"] = {
						["key"] = "1766654712934357623",
						["type"] = "TalkNode",
						["name"] = "小白开车",
						["pos"] = {
							["x"] = 2350,
							["y"] = 279
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200310/20031002.20031002'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1766654712934357624"] = {
						["key"] = "1766654712934357624",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁小白",
						["pos"] = {
							["x"] = 2054,
							["y"] = 275
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080414
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["176528053394013134"] = {
			["isStoryNode"] = true,
			["key"] = "176528053394013134",
			["type"] = "StoryNode",
			["name"] = "与秽兽战斗+开车",
			["pos"] = {
				["x"] = 1077.9922077922079,
				["y"] = 97.37142857142854
			},
			["propsData"] = {
				["QuestId"] = 20031003,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200310_2",
				["QuestDeatil"] = "Content_200310_2",
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_2080415",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17674952078914778",
						["startPort"] = "Success",
						["endQuest"] = "176528053394013138",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17674952078914778",
						["startPort"] = "Fail",
						["endQuest"] = "17674953116426417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17674952078914778",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17674953116426417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17674953116426417",
						["startPort"] = "Out",
						["endQuest"] = "176528053394013141",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "176528053394013135",
						["startPort"] = "QuestStart",
						["endQuest"] = "17678750889402180180",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176528053394013135",
						["startPort"] = "QuestStart",
						["endQuest"] = "17678750889402180181",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176528053394013135",
						["startPort"] = "QuestStart",
						["endQuest"] = "17674951893894476",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17674951893894476",
						["startPort"] = "Out",
						["endQuest"] = "17674952078914778",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17674951893894476",
						["startPort"] = "Out",
						["endQuest"] = "17674952875645808",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["176528053394013135"] = {
						["key"] = "176528053394013135",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1336.534706331045,
							["y"] = 256.43630816170855
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176528053394013138"] = {
						["key"] = "176528053394013138",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2384.80701754386,
							["y"] = 280.7894736842105
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176528053394013141"] = {
						["key"] = "176528053394013141",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2711.5789473684213,
							["y"] = 497.89473684210526
						},
						["propsData"] = {}
					},
					["1765285339526716411"] = {
						["key"] = "1765285339526716411",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2461.464732540147,
							["y"] = 700.9071952994092
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {}
						}
					},
					["17674951893894476"] = {
						["key"] = "17674951893894476",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1605.6037151702785,
							["y"] = 277.4736842105264
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080439,
							["GuideType"] = "P",
							["GuidePointName"] = "Point_20031001"
						}
					},
					["17674952078914778"] = {
						["key"] = "17674952078914778",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 2053.4755687171896,
							["y"] = 277.89473684210526
						},
						["propsData"] = {
							["SpecialConfigId"] = 20031001,
							["BlackScreenImmediately"] = false
						}
					},
					["17674952875645808"] = {
						["key"] = "17674952875645808",
						["type"] = "TalkNode",
						["name"] = "小白开车",
						["pos"] = {
							["x"] = 2049.269128704113,
							["y"] = 80.52631578947377
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200310/20031003.20031003'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17674953116426417"] = {
						["key"] = "17674953116426417",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2376.6939407341883,
							["y"] = 481.5789473684211
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "Point_20031004",
							["FadeIn"] = true,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17678750889402180180"] = {
						["key"] = "17678750889402180180",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生出中年男",
						["pos"] = {
							["x"] = 1604.6722689075625,
							["y"] = 135.63876603272882
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Npc_ZhongNianNan_2080411",
							["StaticCreatorIdList"] = {
								2080411
							}
						}
					},
					["17678750889402180181"] = {
						["key"] = "17678750889402180181",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生出秽兽尸体",
						["pos"] = {
							["x"] = 1600.2750995134895,
							["y"] = -3.2177134011500073
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Drop_HuiShouShiTi_2080410",
							["StaticCreatorIdList"] = {
								2080410
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1765284616163713529"] = {
			["isStoryNode"] = true,
			["key"] = "1765284616163713529",
			["type"] = "StoryNode",
			["name"] = "回百年春的路上",
			["pos"] = {
				["x"] = 1354.2162525879917,
				["y"] = -97.98370927318314
			},
			["propsData"] = {
				["QuestId"] = 20031005,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200310_5",
				["QuestDeatil"] = "Content_200310_5",
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_2080419",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1765284616163713530",
						["startPort"] = "QuestStart",
						["endQuest"] = "17675073557949565",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675073557949565",
						["startPort"] = "Out",
						["endQuest"] = "17675073635389670",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675073635389670",
						["startPort"] = "Success",
						["endQuest"] = "1765284616163713533",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17675073635389670",
						["startPort"] = "Fail",
						["endQuest"] = "176750737806310026",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675073635389670",
						["startPort"] = "PassiveFail",
						["endQuest"] = "176750737806310026",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176750737806310026",
						["startPort"] = "Out",
						["endQuest"] = "1765284616163713536",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1765284616163713530"] = {
						["key"] = "1765284616163713530",
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
					["1765284616163713533"] = {
						["key"] = "1765284616163713533",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1896.1666666666665,
							["y"] = 296.5833333333335
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1765284616163713536"] = {
						["key"] = "1765284616163713536",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2243.5,
							["y"] = 494.5
						},
						["propsData"] = {}
					},
					["17675073557949565"] = {
						["key"] = "17675073557949565",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1166,
							["y"] = 280
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2110364,
							["GuideType"] = "P",
							["GuidePointName"] = "Point_20031002"
						}
					},
					["17675073635389670"] = {
						["key"] = "17675073635389670",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1514,
							["y"] = 252.5
						},
						["propsData"] = {
							["SpecialConfigId"] = 20031002,
							["BlackScreenImmediately"] = false
						}
					},
					["176750737806310026"] = {
						["key"] = "176750737806310026",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1899.5,
							["y"] = 473
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "Point_20031003",
							["FadeIn"] = true,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1765285745411721345"] = {
			["isStoryNode"] = true,
			["key"] = "1765285745411721345",
			["type"] = "StoryNode",
			["name"] = "与中年男对话",
			["pos"] = {
				["x"] = 1084.6619914226603,
				["y"] = 327.2440601846227
			},
			["propsData"] = {
				["QuestId"] = 20031004,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200310_4",
				["QuestDeatil"] = "Content_200310_4",
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_ZhongNianNan_2080411",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1765285745411721350",
						["startPort"] = "QuestStart",
						["endQuest"] = "17655392050322112312",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17655392050322112312",
						["startPort"] = "Out",
						["endQuest"] = "17655392376172113060",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17655392480892113329",
						["startPort"] = "Out",
						["endQuest"] = "1765285745411721351",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17655392050322112312",
						["startPort"] = "Out",
						["endQuest"] = "17655392480892113329",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1765285745411721350"] = {
						["key"] = "1765285745411721350",
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
					["1765285745411721351"] = {
						["key"] = "1765285745411721351",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2252,
							["y"] = 296
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1765285745411721352"] = {
						["key"] = "1765285745411721352",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17655392050322112312"] = {
						["key"] = "17655392050322112312",
						["type"] = "TalkNode",
						["name"] = "与中年男对话",
						["pos"] = {
							["x"] = 1234,
							["y"] = 266
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701088,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_ZhongNianNan_2080411",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200310/20031005.20031005'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20031001",
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
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701088,
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
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17655392376172113060"] = {
						["key"] = "17655392376172113060",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁中年男",
						["pos"] = {
							["x"] = 1652,
							["y"] = 190
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Npc_ZhongNianNan_2080411",
							["StaticCreatorIdList"] = {
								2080411
							}
						}
					},
					["17655392480892113329"] = {
						["key"] = "17655392480892113329",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁秽兽尸体",
						["pos"] = {
							["x"] = 1661.3333333333335,
							["y"] = 328.66666666666663
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Drop_HuiShouShiTi_2080410",
							["StaticCreatorIdList"] = {
								2080410
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17653712895252454211"] = {
			["isStoryNode"] = true,
			["key"] = "17653712895252454211",
			["type"] = "StoryNode",
			["name"] = "回百年春",
			["pos"] = {
				["x"] = 1359.5,
				["y"] = 98.4166666666666
			},
			["propsData"] = {
				["QuestId"] = 20031006,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200310_6",
				["QuestDeatil"] = "Content_200310_6",
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
				["SubRegionId"] = 104110,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_2110319",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17653712895252454212",
						["startPort"] = "QuestStart",
						["endQuest"] = "17655394461713166498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17655394461713166498",
						["startPort"] = "Out",
						["endQuest"] = "17655394590983166754",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17655394590983166754",
						["startPort"] = "Out",
						["endQuest"] = "17653712895252454215",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17653712895252454212"] = {
						["key"] = "17653712895252454212",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1172,
							["y"] = 288
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17653712895252454215"] = {
						["key"] = "17653712895252454215",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2153,
							["y"] = 305.6666666666667
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17653712895252454218"] = {
						["key"] = "17653712895252454218",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17655394461713166498"] = {
						["key"] = "17655394461713166498",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1492,
							["y"] = 270
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2110319,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_2110319"
						}
					},
					["17655394531153166638"] = {
						["key"] = "17655394531153166638",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1498,
							["y"] = 722
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "Npc_ZhongNianNan_2110318",
							["StaticCreatorIdList"] = {
								2110318
							}
						}
					},
					["17655394590983166754"] = {
						["key"] = "17655394590983166754",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1776.3333333333333,
							["y"] = 274
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200310/20031006.20031006'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20031002",
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
									["TalkActorId"] = 701088,
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
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17655394651093166910"] = {
						["key"] = "17655394651093166910",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1840.2352941176468,
							["y"] = 739.6666666666667
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "Npc_ZhongNianNan_2110318",
							["StaticCreatorIdList"] = {
								2110318
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