return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17638157189037556198",
			["startPort"] = "Success",
			["endStory"] = "17638157189037556199",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638157045667556010",
			["startPort"] = "StoryStart",
			["endStory"] = "17638157189037556198",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638157189037556199",
			["startPort"] = "Success",
			["endStory"] = "17638157949887557636",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638157949887557636",
			["startPort"] = "Success",
			["endStory"] = "17638159579187560194",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638159579187560194",
			["startPort"] = "Success",
			["endStory"] = "17638159967347560938",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638159967347560938",
			["startPort"] = "Success",
			["endStory"] = "17638160980747562982",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638160980747562982",
			["startPort"] = "Success",
			["endStory"] = "17722608748191996",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17722608748191996",
			["startPort"] = "Success",
			["endStory"] = "17638157045667556013",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17638157045667556010"] = {
			["isStoryNode"] = true,
			["key"] = "17638157045667556010",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 120307
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17638157045667556013"] = {
			["isStoryNode"] = true,
			["key"] = "17638157045667556013",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2202.8746599118112,
				["y"] = 487.69900240798074
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17638157189037556198"] = {
			["isStoryNode"] = true,
			["key"] = "17638157189037556198",
			["type"] = "StoryNode",
			["name"] = "第五关报名",
			["pos"] = {
				["x"] = 1079.9257703081232,
				["y"] = 273.90499533146595
			},
			["propsData"] = {
				["QuestId"] = 12030701,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120307_1",
				["QuestDeatil"] = "Content__120307_1",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {
					104504
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203020101_132410057",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638157189037556209",
						["startPort"] = "QuestStart",
						["endQuest"] = "17638157189037556212",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638157189037556212",
						["startPort"] = "Out",
						["endQuest"] = "17638157189047556213",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638157189047556213",
						["startPort"] = "Out",
						["endQuest"] = "17638157189037556210",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17638157189037556212",
						["startPort"] = "Out",
						["endQuest"] = "17708837680135789087",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638157189037556212",
						["startPort"] = "Out",
						["endQuest"] = "177267910305117174729",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17638157189037556209"] = {
						["key"] = "17638157189037556209",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 802,
							["y"] = 298
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638157189037556210"] = {
						["key"] = "17638157189037556210",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1725.1648351648353,
							["y"] = 293.8901098901099
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638157189037556211"] = {
						["key"] = "17638157189037556211",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1814,
							["y"] = 554
						},
						["propsData"] = {}
					},
					["17638157189037556212"] = {
						["key"] = "17638157189037556212",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1119.10989010989,
							["y"] = 273.7692307692308
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410057,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020101_132410057"
						}
					},
					["17638157189047556213"] = {
						["key"] = "17638157189047556213",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1404.7362637362637,
							["y"] = 275.6813186813187
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062801.12062801'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030201",
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
					["17638157189047556214"] = {
						["key"] = "17638157189047556214",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1726.9230769230771,
							["y"] = 78.84615384615387
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = false
						}
					},
					["17708837680135789087"] = {
						["key"] = "17708837680135789087",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1404.8627819548874,
							["y"] = 448.03571428571433
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132420143,
								132420144
							}
						}
					},
					["177267910305117174729"] = {
						["key"] = "177267910305117174729",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1409.8947368421052,
							["y"] = 609.9956140350877
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = false,
							["LerpTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17638157189037556199"] = {
			["isStoryNode"] = true,
			["key"] = "17638157189037556199",
			["type"] = "StoryNode",
			["name"] = "第五关",
			["pos"] = {
				["x"] = 1360.7488942945602,
				["y"] = 272.02259986315704
			},
			["propsData"] = {
				["QuestId"] = 12030702,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120307_2",
				["QuestDeatil"] = "Content__120307_2",
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
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_12030202Giongzuo_132410089",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "176794409518610900871",
						["startPort"] = "Out",
						["endQuest"] = "176794409518610900870",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176794409518610900870",
						["startPort"] = "Option_2",
						["endQuest"] = "176794409518610900871",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638157189057556234",
						["startPort"] = "QuestStart",
						["endQuest"] = "176794409518610900870",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638157189057556234",
						["startPort"] = "QuestStart",
						["endQuest"] = "17638157189057556237",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176794409518610900870",
						["startPort"] = "Option_1",
						["endQuest"] = "176794409518610900871",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176794409518610900870",
						["startPort"] = "Option_1",
						["endQuest"] = "17724207914639476860",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638157189057556237",
						["startPort"] = "Success",
						["endQuest"] = "176794409518610900870",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17638157189057556237",
						["startPort"] = "Success",
						["endQuest"] = "17638157189057556235",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17638157189057556237",
						["startPort"] = "Success",
						["endQuest"] = "177267909469017174463",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17638157189057556234"] = {
						["key"] = "17638157189057556234",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 801.6666666666666,
							["y"] = 289.1666666666667
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638157189057556235"] = {
						["key"] = "17638157189057556235",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1441.9097096188743,
							["y"] = 286.9255898366606
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638157189057556236"] = {
						["key"] = "17638157189057556236",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1751.157894736842,
							["y"] = 489.32456140350877
						},
						["propsData"] = {}
					},
					["17638157189057556237"] = {
						["key"] = "17638157189057556237",
						["type"] = "AsyncConditionNode",
						["name"] = "异步等待条件完成",
						["pos"] = {
							["x"] = 1119.6473904196228,
							["y"] = 287.5736539624925
						},
						["propsData"] = {
							["ConditionId"] = 10301431
						}
					},
					["176794409518610900870"] = {
						["key"] = "176794409518610900870",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1121.0372807017543,
							["y"] = 47.87938596491222
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250011,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030202Giongzuo_132410089",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 12060740,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
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
							["NormalOptions"] = {
								{
									["OptionText"] = "12060741",
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								},
								{
									["OptionText"] = "12060742",
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["176794409518610900871"] = {
						["key"] = "176794409518610900871",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1121.0372807017543,
							["y"] = -152.12061403508778
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17724207914639476860"] = {
						["key"] = "17724207914639476860",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1444.546052631579,
							["y"] = 70.16666666666674
						},
						["propsData"] = {
							["IsAsync"] = false,
							["UIName"] = "",
							["IsInterfaceJump"] = true,
							["InterfaceJumpId"] = 89
						}
					},
					["177267909469017174463"] = {
						["key"] = "177267909469017174463",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1443.171052631579,
							["y"] = 447.91008771929825
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = false,
							["LerpTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17638157949887557636"] = {
			["isStoryNode"] = true,
			["key"] = "17638157949887557636",
			["type"] = "StoryNode",
			["name"] = "苏乙送义肢",
			["pos"] = {
				["x"] = 1638.31247188484,
				["y"] = 271.7540485829959
			},
			["propsData"] = {
				["QuestId"] = 12030703,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120307_3",
				["QuestDeatil"] = "Content__120307_3",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {
					104503
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203020101_132410057",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638158388217558584",
						["startPort"] = "Success",
						["endQuest"] = "1767925813680995",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767925813680995",
						["startPort"] = "Out",
						["endQuest"] = "17638157949887557642",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17638158388217558584",
						["startPort"] = "Fail",
						["endQuest"] = "17638157949887557643",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17638158388217558584",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17638157949887557643",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17638157949887557641",
						["startPort"] = "QuestStart",
						["endQuest"] = "17701877544453318",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701877544453318",
						["startPort"] = "Out",
						["endQuest"] = "17638158388217558584",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701877544453318",
						["startPort"] = "Out",
						["endQuest"] = "177267908701217174207",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17638157949887557641"] = {
						["key"] = "17638157949887557641",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 596.8095238095237,
							["y"] = 287.73809523809524
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638157949887557642"] = {
						["key"] = "17638157949887557642",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1801.3720076052198,
							["y"] = 288.2887390891021
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638157949887557643"] = {
						["key"] = "17638157949887557643",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1482.937030075188,
							["y"] = 497.1079260651629
						},
						["propsData"] = {}
					},
					["17638158388217558584"] = {
						["key"] = "17638158388217558584",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1159.1339896662473,
							["y"] = 287.3161162314388
						},
						["propsData"] = {
							["SpecialConfigId"] = 12030703,
							["BlackScreenImmediately"] = false
						}
					},
					["1767925813680995"] = {
						["key"] = "1767925813680995",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1479.9902882205515,
							["y"] = 289.5658079021082
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_1203070301",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17701877544453318"] = {
						["key"] = "17701877544453318",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 881.0138248847926,
							["y"] = 287.89861751152074
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410057,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203020101_132410057"
						}
					},
					["177267908701217174207"] = {
						["key"] = "177267908701217174207",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1164.2431630546955,
							["y"] = 492.702012383901
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = true,
							["LerpTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17638159579187560194"] = {
			["isStoryNode"] = true,
			["key"] = "17638159579187560194",
			["type"] = "StoryNode",
			["name"] = "找潇湘",
			["pos"] = {
				["x"] = 1078.2478070175434,
				["y"] = 470.62083651156865
			},
			["propsData"] = {
				["QuestId"] = 12030704,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120307_4",
				["QuestDeatil"] = "Content__120307_4",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {
					104503
				},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_YanQue_312420140",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17720755046319309304",
						["startPort"] = "false",
						["endQuest"] = "17720755225639309835",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720755046319309304",
						["startPort"] = "true",
						["endQuest"] = "17720755807249311159",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720755595419310766",
						["startPort"] = "true",
						["endQuest"] = "17720755553719310615",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720755595419310766",
						["startPort"] = "false",
						["endQuest"] = "177207561896410471466",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638159579187560199",
						["startPort"] = "QuestStart",
						["endQuest"] = "17720755046319309304",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720755432119310242",
						["startPort"] = "Fail",
						["endQuest"] = "17720755595419310766",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720755432119310242",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17720755595419310766",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720755553719310615",
						["startPort"] = "Out",
						["endQuest"] = "17638159579187560201",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "177207561896410471466",
						["startPort"] = "Out",
						["endQuest"] = "17638159579187560201",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17720755225639309835",
						["startPort"] = "Out",
						["endQuest"] = "17720755432119310242",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17721085262096968731",
						["startPort"] = "Out",
						["endQuest"] = "17721085262096968730",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720755807249311159",
						["startPort"] = "Out",
						["endQuest"] = "17721085262096968731",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17721085262096968730",
						["startPort"] = "Out",
						["endQuest"] = "17720755432119310242",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17721085262096968730",
						["startPort"] = "Out",
						["endQuest"] = "17721741974813120",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17720755432119310242",
						["startPort"] = "Success",
						["endQuest"] = "17722471988426716592",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17722471988426716592",
						["startPort"] = "Out",
						["endQuest"] = "17638159579187560200",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17638159579187560199"] = {
						["key"] = "17638159579187560199",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -670.0183789648704,
							["y"] = 1131.9621275182128
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638159579187560200"] = {
						["key"] = "17638159579187560200",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1207.0512237153957,
							["y"] = 1097.1493702897872
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638159579187560201"] = {
						["key"] = "17638159579187560201",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1593.600257719283,
							["y"] = 1331.3608647350693
						},
						["propsData"] = {}
					},
					["17720755046319309304"] = {
						["key"] = "17720755046319309304",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量-0？",
						["pos"] = {
							["x"] = -308.4850103340571,
							["y"] = 1143.2215552003074
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "FengxiangXiaoxiang",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17720755136299309560"] = {
						["key"] = "17720755136299309560",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 328.6404831419485,
							["y"] = 511.52824441175983
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 312420139,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_YanQue_312420140"
						}
					},
					["17720755225639309835"] = {
						["key"] = "17720755225639309835",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 88.13426388458055,
							["y"] = 1147.7730514896361
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 312420145,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030704Xiaoxiang_132410066"
						}
					},
					["17720755432119310242"] = {
						["key"] = "17720755432119310242",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 531.0929362514355,
							["y"] = 1136.5032097106134
						},
						["propsData"] = {
							["SpecialConfigId"] = 12030704,
							["BlackScreenImmediately"] = false
						}
					},
					["17720755553719310615"] = {
						["key"] = "17720755553719310615",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1196.4199375946598,
							["y"] = 1276.5346446725146
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_1203070301",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17720755595419310766"] = {
						["key"] = "17720755595419310766",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量-0？",
						["pos"] = {
							["x"] = 832.4849269773849,
							["y"] = 1323.6161252993084
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "FengxiangXiaoxiang",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17720755807249311159"] = {
						["key"] = "17720755807249311159",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = -225.62294343940917,
							["y"] = 850.23422402053
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								312420140
							}
						}
					},
					["177207561896410471466"] = {
						["key"] = "177207561896410471466",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1204.1384557904903,
							["y"] = 1468.4753838085355
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpawnPoint_ChaseYanque_2",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17721085262096968730"] = {
						["key"] = "17721085262096968730",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 392.9876514748481,
							["y"] = 823.0884601626283
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {
								312420147
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 11225,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_YanQue_312420140",
							["IsUseCount"] = false
						}
					},
					["17721085262096968731"] = {
						["key"] = "17721085262096968731",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成机关鸟交互点",
						["pos"] = {
							["x"] = 80.55738442930861,
							["y"] = 840.3919839966358
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								312420147
							}
						}
					},
					["17721741974813120"] = {
						["key"] = "17721741974813120",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 732.0269323692512,
							["y"] = 682.2424315752367
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12063801,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17722471988426716592"] = {
						["key"] = "17722471988426716592",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 853.5892857142856,
							["y"] = 1029.2500000000002
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12063313,
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
		["17638159967347560938"] = {
			["isStoryNode"] = true,
			["key"] = "17638159967347560938",
			["type"] = "StoryNode",
			["name"] = "Boss战",
			["pos"] = {
				["x"] = 1361.6517410951624,
				["y"] = 471.4613970925222
			},
			["propsData"] = {
				["QuestId"] = 12030705,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120307_5",
				["QuestDeatil"] = "Content__120307_5",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {
					105901
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203070501_132420054",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17655253808721052275",
						["startPort"] = "Out",
						["endQuest"] = "17638160596627562105",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17655253808721052275",
						["startPort"] = "Out",
						["endQuest"] = "17722471171122032",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724410009921190692",
						["startPort"] = "Out",
						["endQuest"] = "17724410693471191411",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518409041404711",
						["startPort"] = "Region_1",
						["endQuest"] = "17724410009921190692",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518885267407715",
						["startPort"] = "Region_1",
						["endQuest"] = "17664894462939556455",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518885267407715",
						["startPort"] = "Region_1",
						["endQuest"] = "17655253808721052275",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518859458407068",
						["startPort"] = "Region_1",
						["endQuest"] = "17638160267177561391",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638160267177561391",
						["startPort"] = "Success",
						["endQuest"] = "17724351350356266",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724410693471191411",
						["startPort"] = "Out",
						["endQuest"] = "17725190529181614451",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518885267407715",
						["startPort"] = "Region_1",
						["endQuest"] = "17725191452192819734",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518885267407715",
						["startPort"] = "Region_1",
						["endQuest"] = "17727939717589026085",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518885267407715",
						["startPort"] = "Region_1",
						["endQuest"] = "177267907421017173766",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17638160267177561391",
						["startPort"] = "Fail",
						["endQuest"] = "17731450844579320692",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638160267177561391",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17731450844579320692",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724351350356266",
						["startPort"] = "Out",
						["endQuest"] = "177314519907210594815",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17731450844579320692",
						["startPort"] = "Out",
						["endQuest"] = "177314520436210594950",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638159967347560943",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772518681171405326",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518681171405326",
						["startPort"] = "true",
						["endQuest"] = "1772518409041404711",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518681171405326",
						["startPort"] = "true",
						["endQuest"] = "1772518859458407068",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518681171405326",
						["startPort"] = "false",
						["endQuest"] = "17638159967347560944",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17638159967347560943"] = {
						["key"] = "17638159967347560943",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -49.465315144625606,
							["y"] = 229.21308576480988
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638159967347560944"] = {
						["key"] = "17638159967347560944",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 523.684987023462,
							["y"] = 449.30706812848376
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638159967347560945"] = {
						["key"] = "17638159967347560945",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1858,
							["y"] = 573.6666666666667
						},
						["propsData"] = {}
					},
					["17638160267177561391"] = {
						["key"] = "17638160267177561391",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 800.9680250305249,
							["y"] = 207.18678266178267
						},
						["propsData"] = {
							["SpecialConfigId"] = 12030705,
							["BlackScreenImmediately"] = true
						}
					},
					["17638160596627562105"] = {
						["key"] = "17638160596627562105",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1094.7884199134198,
							["y"] = 800.0468975468975
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12063401.12063401'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030701",
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
					["17655253808721052275"] = {
						["key"] = "17655253808721052275",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 815.5996039815064,
							["y"] = 796.1307720057719
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132420054,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203070501_132420054"
						}
					},
					["17664894462939556455"] = {
						["key"] = "17664894462939556455",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 817.2652940928804,
							["y"] = 978.3385070811541
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12063318,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17722471171122032"] = {
						["key"] = "17722471171122032",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1090.2770269712494,
							["y"] = 975.6114530397142
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132410066
							}
						}
					},
					["17724351350356266"] = {
						["key"] = "17724351350356266",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1125.863089346296,
							["y"] = 179.66344894963044
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104504,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17724410009921190692"] = {
						["key"] = "17724410009921190692",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 799.5079575596814,
							["y"] = 5.07692307692291
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "132420160",
							["StaticCreatorIdList"] = {
								132420160
							}
						}
					},
					["17724410693471191411"] = {
						["key"] = "17724410693471191411",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1081.679998736895,
							["y"] = 8.19505705022933
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11226,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "NewTargetPoint_1203070501",
							["IsUseCount"] = false
						}
					},
					["1772518409041404711"] = {
						["key"] = "1772518409041404711",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 521.1267327443798,
							["y"] = 2.5870469399881975
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								104504
							}
						}
					},
					["1772518681171405326"] = {
						["key"] = "1772518681171405326",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 199.571204938852,
							["y"] = 210.07136817430953
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "FengxiangBossFinish",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["1772518859458407068"] = {
						["key"] = "1772518859458407068",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 523.9752851581495,
							["y"] = 209.82966543260682
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								105901
							}
						}
					},
					["1772518885267407715"] = {
						["key"] = "1772518885267407715",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 527.3735535564182,
							["y"] = 798.8159569188983
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								104504
							}
						}
					},
					["17725190529181614451"] = {
						["key"] = "17725190529181614451",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1406.8466594360457,
							["y"] = 1.2832075426705636
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105901,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17725191452192819734"] = {
						["key"] = "17725191452192819734",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 528.2645471039331,
							["y"] = 978.0735005829633
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_1203070501",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["177267907421017173766"] = {
						["key"] = "177267907421017173766",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 534.5714285714286,
							["y"] = 1175.142857142857
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = true,
							["LerpTime"] = 0
						}
					},
					["17727939717589026085"] = {
						["key"] = "17727939717589026085",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 812.5988612836438,
							["y"] = 1178.0766358030628
						},
						["propsData"] = {
							["NewDescription"] = "Description_120307_8",
							["NewDetail"] = "Content__120307_8",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17731450844579320692"] = {
						["key"] = "17731450844579320692",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1121.3001221001223,
							["y"] = 330.557264957265
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104504,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["177314519907210594815"] = {
						["key"] = "177314519907210594815",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1409.39242979243,
							["y"] = 172.33768453768462
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_1203070501",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["177314520436210594950"] = {
						["key"] = "177314520436210594950",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1407.7141081141085,
							["y"] = 327.68733488733494
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_1203070501",
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
		["17638160980747562982"] = {
			["isStoryNode"] = true,
			["key"] = "17638160980747562982",
			["type"] = "StoryNode",
			["name"] = "找苏乙",
			["pos"] = {
				["x"] = 1639.2898059542797,
				["y"] = 473.5378787878789
			},
			["propsData"] = {
				["QuestId"] = 12030706,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120307_8",
				["QuestDeatil"] = "Content__120307_8",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = true,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104503,
				["SubRegionIdList"] = {
					104504
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203070601_132410063",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638160980747562991",
						["startPort"] = "Out",
						["endQuest"] = "17638160980747562990",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17702018837256878652",
						["startPort"] = "Out",
						["endQuest"] = "17638160980747562991",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17702018837256878652",
						["startPort"] = "Out",
						["endQuest"] = "17666529163695314541",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638160980747562990",
						["startPort"] = "Out",
						["endQuest"] = "17708849161776945920",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17708849161776945920",
						["startPort"] = "Out",
						["endQuest"] = "17638160980747562988",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177314516401910594180",
						["startPort"] = "Out",
						["endQuest"] = "177314516401910594179",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177314516401910594180",
						["startPort"] = "Out",
						["endQuest"] = "177314516401910594182",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638160980747562987",
						["startPort"] = "QuestStart",
						["endQuest"] = "177314516401910594180",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177314516401910594179",
						["startPort"] = "Out",
						["endQuest"] = "17702018837256878652",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177314516401910594179",
						["startPort"] = "Out",
						["endQuest"] = "177314547157713142072",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17638160980747562987"] = {
						["key"] = "17638160980747562987",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -83.60119047619037,
							["y"] = 314.38988095238096
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638160980747562988"] = {
						["key"] = "17638160980747562988",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2081.0428318229547,
							["y"] = 286.1189081572574
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104506,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17638160980747562989"] = {
						["key"] = "17638160980747562989",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2185.777777777778,
							["y"] = 556.1666666666667
						},
						["propsData"] = {}
					},
					["17638160980747562990"] = {
						["key"] = "17638160980747562990",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1526.2096300533944,
							["y"] = 276.9605263157895
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12063501.12063501'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030704",
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
					["17638160980747562991"] = {
						["key"] = "17638160980747562991",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1236.296052631579,
							["y"] = 273.9517543859649
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410063,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203070601_132410063"
						}
					},
					["17666529163695314541"] = {
						["key"] = "17666529163695314541",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1244.191385277127,
							["y"] = 72.864208853918
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12063414,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17702018837256878652"] = {
						["key"] = "17702018837256878652",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 918.3019549717974,
							["y"] = 272.6646726382453
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132410127,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203070602_132410127"
						}
					},
					["17708848873176945606"] = {
						["key"] = "17708848873176945606",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 927.2635601879607,
							["y"] = 461.9963594757644
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132410128,
								132410129,
								132410130
							}
						}
					},
					["17708849161776945920"] = {
						["key"] = "17708849161776945920",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1798.8187441344496,
							["y"] = 280.8926805459986
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132410128,
								132410129,
								132410130
							}
						}
					},
					["177267906615417173515"] = {
						["key"] = "177267906615417173515",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1243.071684894053,
							["y"] = 448.72667464114824
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = true,
							["LerpTime"] = 0
						}
					},
					["177314516401910594179"] = {
						["key"] = "177314516401910594179",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 579.5944079659566,
							["y"] = 284.81225800343447
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12063401.12063401'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030701",
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
					["177314516401910594180"] = {
						["key"] = "177314516401910594180",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 300.40559203404314,
							["y"] = 280.89613246230886
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132420054,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203070501_132420054"
						}
					},
					["177314516401910594181"] = {
						["key"] = "177314516401910594181",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 284.57128214541706,
							["y"] = 463.10386753769114
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12063318,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["177314516401910594182"] = {
						["key"] = "177314516401910594182",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 575.0830150237862,
							["y"] = 460.3768134962511
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132410066
							}
						}
					},
					["177314547157713142072"] = {
						["key"] = "177314547157713142072",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 926.125,
							["y"] = 92.92857142857133
						},
						["propsData"] = {
							["NewDescription"] = "Description_120307_6",
							["NewDetail"] = "Content__120307_6",
							["SubTaskTargetIndex"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17722608748191996"] = {
			["isStoryNode"] = true,
			["key"] = "17722608748191996",
			["type"] = "StoryNode",
			["name"] = "奉香大典",
			["pos"] = {
				["x"] = 1921.6798055504432,
				["y"] = 472.5506682905412
			},
			["propsData"] = {
				["QuestId"] = 12030707,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120307_6",
				["QuestDeatil"] = "Content__120307_6",
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
				["SubRegionId"] = 104506,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203070601_132410063",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17722608748192011",
						["startPort"] = "Out",
						["endQuest"] = "17722608748192006",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17722608748192001",
						["startPort"] = "QuestStart",
						["endQuest"] = "17722608748192011",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17722608748192011",
						["startPort"] = "Out",
						["endQuest"] = "17722608748192009",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17722608748192011",
						["startPort"] = "Out",
						["endQuest"] = "17722658634939872172",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17722608748192006",
						["startPort"] = "Out",
						["endQuest"] = "177259342625113271551",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177259342625113271551",
						["startPort"] = "Out",
						["endQuest"] = "17722608748192002",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17722608748192001"] = {
						["key"] = "17722608748192001",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 680.327380952381,
							["y"] = 250.10416666666669
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17722608748192002"] = {
						["key"] = "17722608748192002",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1841.126682754632,
							["y"] = 250.65928082806482
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104506,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17722608748192003"] = {
						["key"] = "17722608748192003",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2185.777777777778,
							["y"] = 556.1666666666667
						},
						["propsData"] = {}
					},
					["17722608748192006"] = {
						["key"] = "17722608748192006",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1279.162928574693,
							["y"] = 247.4645469769308
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12063601.12063601'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030706",
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
					["17722608748192009"] = {
						["key"] = "17722608748192009",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1280.049274473675,
							["y"] = 488.53532051472547
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162440010
							}
						}
					},
					["17722608748192011"] = {
						["key"] = "17722608748192011",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 959.9202319419709,
							["y"] = 248.34492138296483
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC003/Ver0103_SC003",
							["BlendInTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17722658634939872172"] = {
						["key"] = "17722658634939872172",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = 1283.7964285714288,
							["y"] = 92.54006211180116
						},
						["propsData"] = {
							["IsHide"] = false,
							["AtmosphereTagList"] = {
								"Story_FixSimple_36_1"
							}
						}
					},
					["177259342625113271551"] = {
						["key"] = "177259342625113271551",
						["type"] = "OpenChapterUINode",
						["name"] = "打开章节开始UI",
						["pos"] = {
							["x"] = 1562.3428475033736,
							["y"] = 251.4218045112781
						},
						["propsData"] = {
							["ChapterUIId"] = 120300,
							["UIType"] = "End"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}