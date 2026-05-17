return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17266421894411",
			["startPort"] = "StoryStart",
			["endStory"] = "1726642346287167066",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1726642346287167066",
			["startPort"] = "Success",
			["endStory"] = "17266421894425",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17266421894411"] = {
			["isStoryNode"] = true,
			["key"] = "17266421894411",
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
		["17266421894425"] = {
			["isStoryNode"] = true,
			["key"] = "17266421894425",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1465,
				["y"] = 289.5
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1726642346287167066"] = {
			["isStoryNode"] = true,
			["key"] = "1726642346287167066",
			["type"] = "StoryNode",
			["name"] = "保护探测器",
			["pos"] = {
				["x"] = 1151.8350840336134,
				["y"] = 290.2703081232493
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_KuangkengProtecttanceqi_Des",
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
				["bIsDynamicEvent"] = true,
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
						["startQuest"] = "1726642346287167067",
						["startPort"] = "QuestStart",
						["endQuest"] = "1726642372488167897",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1726642346287167067",
						["startPort"] = "QuestStart",
						["endQuest"] = "1726642390063168308",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1726643915525172117",
						["startPort"] = "Out",
						["endQuest"] = "1726643927405172391",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17266461677142254",
						["startPort"] = "Out",
						["endQuest"] = "17266461778812492",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17266462735523461",
						["startPort"] = "Out",
						["endQuest"] = "17266462661943273",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17266462661943273",
						["startPort"] = "TimerRange_2",
						["endQuest"] = "17266471837428206",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17266471837428206",
						["startPort"] = "Out",
						["endQuest"] = "1726643915525172117",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17266471837428206",
						["startPort"] = "Out",
						["endQuest"] = "17266472150439078",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1726643263425170183",
						["startPort"] = "Option_1",
						["endQuest"] = "17266472640529768",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172664731297311071",
						["startPort"] = "Out",
						["endQuest"] = "172664737751712597",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172664729217210673",
						["startPort"] = "Out",
						["endQuest"] = "172664738174212805",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172664737751712597",
						["startPort"] = "Out",
						["endQuest"] = "1726642346287167070",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "172664738174212805",
						["startPort"] = "Out",
						["endQuest"] = "1726642346287167070",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17266462661943273",
						["startPort"] = "TimerRange_1",
						["endQuest"] = "17267386443284084",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17267386443284084",
						["startPort"] = "Out",
						["endQuest"] = "172664727766010194",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17266461677142254",
						["startPort"] = "Out",
						["endQuest"] = "17328674744245513",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17328674744245513",
						["startPort"] = "Out",
						["endQuest"] = "17266462661943273",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17328685532994349691",
						["startPort"] = "Out",
						["endQuest"] = "172664732409311497",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1726643927405172391",
						["startPort"] = "Out",
						["endQuest"] = "17328685532994349691",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172664732409311497",
						["startPort"] = "Out",
						["endQuest"] = "172664729217210673",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172664727766010194",
						["startPort"] = "Out",
						["endQuest"] = "172664731297311071",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17266461677142254",
						["startPort"] = "Out",
						["endQuest"] = "17266462735523461",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17266461677142254",
						["startPort"] = "Out",
						["endQuest"] = "17266462661943273",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1726642372488167897",
						["startPort"] = "Out",
						["endQuest"] = "1726643263425170183",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1726643263425170183",
						["startPort"] = "Option_1",
						["endQuest"] = "17362415297421647436",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17362415297421647436",
						["startPort"] = "Out",
						["endQuest"] = "17417711509241958",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17417711509241958",
						["startPort"] = "Out",
						["endQuest"] = "17266461677142254",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1726643263425170183",
						["startPort"] = "Option_2",
						["endQuest"] = "17566968607811315",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1726642346287167067"] = {
						["key"] = "1726642346287167067",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 543.8923076923077,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1726642346287167070"] = {
						["key"] = "1726642346287167070",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4489.102974828375,
							["y"] = 275.3519450800916
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1726642346287167073"] = {
						["key"] = "1726642346287167073",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4495.729061784897,
							["y"] = 493.1084668192218
						},
						["propsData"] = {}
					},
					["1726642372488167897"] = {
						["key"] = "1726642372488167897",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成矿机与npc",
						["pos"] = {
							["x"] = 879.2624566609859,
							["y"] = 304.18898944193063
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1270076,
								1270075
							}
						}
					},
					["1726642390063168308"] = {
						["key"] = "1726642390063168308",
						["type"] = "TalkNode",
						["name"] = "npc开车对话",
						["pos"] = {
							["x"] = 873.494714725502,
							["y"] = 64.32745098039221
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71002401,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1726643263425170183"] = {
						["key"] = "1726643263425170183",
						["type"] = "TalkNode",
						["name"] = "皎皎npc选项对话",
						["pos"] = {
							["x"] = 1292.0451489686784,
							["y"] = 249.41495098039223
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818015,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1270076",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71002402,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {
								{
									["OptionText"] = "710024021",
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								},
								{
									["OptionText"] = "710024022",
									["OverrideBlend"] = true,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 2
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["1726643915525172117"] = {
						["key"] = "1726643915525172117",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成秽兽",
						["pos"] = {
							["x"] = 3023.4163028148323,
							["y"] = 475.3274509803923
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1270080,
								1270081,
								1270082,
								1270083,
								1270084
							}
						}
					},
					["1726643927405172391"] = {
						["key"] = "1726643927405172391",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 3300.5701489686785,
							["y"] = 471.7274509803922
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1270080,
								1270081,
								1270082,
								1270083,
								1270084
							}
						}
					},
					["17266461677142254"] = {
						["key"] = "17266461677142254",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "开启修理状态",
						["pos"] = {
							["x"] = 1821.1865998634848,
							["y"] = 281.3964254714749
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1270141
							},
							["ManualItemIdList"] = {},
							["StateId"] = 552,
							["QuestId"] = 0
						}
					},
					["17266461778812492"] = {
						["key"] = "17266461778812492",
						["type"] = "TalkNode",
						["name"] = "修理开车对话",
						["pos"] = {
							["x"] = 2084.3285353473557,
							["y"] = 77.96416740695874
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71002403,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17266462661943273"] = {
						["key"] = "17266462661943273",
						["type"] = "TimerBranchNode",
						["name"] = "计时器-8s",
						["pos"] = {
							["x"] = 2477.586599863485,
							["y"] = 290.1964254714749
						},
						["propsData"] = {
							["TimerRange"] = {
								{
									["StartTime"] = 0,
									["EndTime"] = 8
								},
								{
									["StartTime"] = 8,
									["EndTime"] = -1
								}
							}
						}
					},
					["17266462735523461"] = {
						["key"] = "17266462735523461",
						["type"] = "WaitOfTimeNode",
						["name"] = "8s等待",
						["pos"] = {
							["x"] = 2155.0438228648877,
							["y"] = 422.49554388461854
						},
						["propsData"] = {
							["WaitTime"] = 8
						}
					},
					["17266471837428206"] = {
						["key"] = "17266471837428206",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换无法修理矿机状态",
						["pos"] = {
							["x"] = 2741.446205774815,
							["y"] = 353.7150646866659
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1270141
							},
							["ManualItemIdList"] = {},
							["StateId"] = 582,
							["QuestId"] = 0
						}
					},
					["17266472150439078"] = {
						["key"] = "17266472150439078",
						["type"] = "TalkNode",
						["name"] = "秽兽出现开车对话",
						["pos"] = {
							["x"] = 3027.046205774815,
							["y"] = 651.3150646866659
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71002405,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17266472640529768"] = {
						["key"] = "17266472640529768",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "npc消失",
						["pos"] = {
							["x"] = 1824.6462057748145,
							["y"] = 125.71506468666605
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1270076
							}
						}
					},
					["172664727766010194"] = {
						["key"] = "172664727766010194",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "npc出现",
						["pos"] = {
							["x"] = 3085.721927336785,
							["y"] = 162.1347590839496
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1270076
							}
						}
					},
					["172664729217210673"] = {
						["key"] = "172664729217210673",
						["type"] = "TalkNode",
						["name"] = "击杀秽兽后的对话",
						["pos"] = {
							["x"] = 3846.646205774816,
							["y"] = 455.7150646866661
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818015,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1270076",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71002407,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["172664731297311071"] = {
						["key"] = "172664731297311071",
						["type"] = "TalkNode",
						["name"] = "修理完成对话",
						["pos"] = {
							["x"] = 3591.781689645784,
							["y"] = 137.13441952537568
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818015,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1270076",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71002406,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["172664732409311497"] = {
						["key"] = "172664732409311497",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "npc出现",
						["pos"] = {
							["x"] = 3589.188141258687,
							["y"] = 472.08925823505325
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1270076
							}
						}
					},
					["172664737751712597"] = {
						["key"] = "172664737751712597",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 4032.9762782385847,
							["y"] = 147.2708617881152
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["172664738174212805"] = {
						["key"] = "172664738174212805",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 4148.193669542934,
							["y"] = 440.74912265768046
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17267386443284084"] = {
						["key"] = "17267386443284084",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "机关修理完成",
						["pos"] = {
							["x"] = 2733.3958791208806,
							["y"] = 161.88818681318673
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1270141,
							["StateId"] = 572,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17270759951427298"] = {
						["key"] = "17270759951427298",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "测试机关指引点",
						["pos"] = {
							["x"] = 1452.5262237762217,
							["y"] = 66.97202797202762
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1270075,
							["StateId"] = 780091,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "1270075"
						}
					},
					["17328674744245513"] = {
						["key"] = "17328674744245513",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "机关选择修理",
						["pos"] = {
							["x"] = 2144.271428571428,
							["y"] = 641.661904761905
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1270141,
							["StateId"] = 562,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17328680079661246882"] = {
						["key"] = "17328680079661246882",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2994.3788624787767,
							["y"] = -136.38554303647675
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
					["17328685532994349691"] = {
						["key"] = "17328685532994349691",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3445.4728316232363,
							["y"] = 328.17266173210675
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17362415297421647436"] = {
						["key"] = "17362415297421647436",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成小游戏机关",
						["pos"] = {
							["x"] = 1552.8064836149513,
							["y"] = 337.7107014848951
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1270141
							}
						}
					},
					["17417711509241958"] = {
						["key"] = "17417711509241958",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1735.2591397849465,
							["y"] = 466.45161290322585
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17566968607811315"] = {
						["key"] = "17566968607811315",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 1672.1560703228656,
							["y"] = 725.6444235588974
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}