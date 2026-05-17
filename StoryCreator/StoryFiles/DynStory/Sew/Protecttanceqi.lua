return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17411638372531",
			["startPort"] = "StoryStart",
			["endStory"] = "174116384118863",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174116384118863",
			["startPort"] = "Success",
			["endStory"] = "17411638372535",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17411638372531"] = {
			["isStoryNode"] = true,
			["key"] = "17411638372531",
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
		["17411638372535"] = {
			["isStoryNode"] = true,
			["key"] = "17411638372535",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1472,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["174116384118863"] = {
			["isStoryNode"] = true,
			["key"] = "174116384118863",
			["type"] = "StoryNode",
			["name"] = "保护探测器",
			["pos"] = {
				["x"] = 1132,
				["y"] = 291.99999999999994
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
						["startQuest"] = "174116384118968",
						["startPort"] = "QuestStart",
						["endQuest"] = "174116384118971",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118968",
						["startPort"] = "QuestStart",
						["endQuest"] = "174116384118972",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118974",
						["startPort"] = "Out",
						["endQuest"] = "174116384118975",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118977",
						["startPort"] = "Out",
						["endQuest"] = "174116384118978",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119080",
						["startPort"] = "Out",
						["endQuest"] = "174116384119079",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "174116384119079",
						["startPort"] = "TimerRange_2",
						["endQuest"] = "174116384119081",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119081",
						["startPort"] = "Out",
						["endQuest"] = "174116384118974",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119081",
						["startPort"] = "Out",
						["endQuest"] = "174116384119082",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118973",
						["startPort"] = "Option_1",
						["endQuest"] = "174116384119083",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119086",
						["startPort"] = "Out",
						["endQuest"] = "174116384119088",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119085",
						["startPort"] = "Out",
						["endQuest"] = "174116384119089",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119088",
						["startPort"] = "Out",
						["endQuest"] = "174116384118969",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174116384119089",
						["startPort"] = "Out",
						["endQuest"] = "174116384118969",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174116384119079",
						["startPort"] = "TimerRange_1",
						["endQuest"] = "174116384119090",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119090",
						["startPort"] = "Out",
						["endQuest"] = "174116384119084",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118977",
						["startPort"] = "Out",
						["endQuest"] = "174116384119092",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119092",
						["startPort"] = "Out",
						["endQuest"] = "174116384119079",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "174116384119194",
						["startPort"] = "Out",
						["endQuest"] = "174116384119087",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118975",
						["startPort"] = "Out",
						["endQuest"] = "174116384119194",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119087",
						["startPort"] = "Out",
						["endQuest"] = "174116384119085",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119084",
						["startPort"] = "Out",
						["endQuest"] = "174116384119086",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118977",
						["startPort"] = "Out",
						["endQuest"] = "174116384119080",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118977",
						["startPort"] = "Out",
						["endQuest"] = "174116384119079",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118971",
						["startPort"] = "Out",
						["endQuest"] = "174116384118973",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118973",
						["startPort"] = "Option_1",
						["endQuest"] = "174116384119195",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119195",
						["startPort"] = "Out",
						["endQuest"] = "174116384119196",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384119196",
						["startPort"] = "Out",
						["endQuest"] = "174116384118977",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174116384118973",
						["startPort"] = "Option_2",
						["endQuest"] = "1756696945178635785",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174116384118968"] = {
						["key"] = "174116384118968",
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
					["174116384118969"] = {
						["key"] = "174116384118969",
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
					["174116384118970"] = {
						["key"] = "174116384118970",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4495.729061784897,
							["y"] = 493.1084668192218
						},
						["propsData"] = {}
					},
					["174116384118971"] = {
						["key"] = "174116384118971",
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
								1720647,
								1720648
							}
						}
					},
					["174116384118972"] = {
						["key"] = "174116384118972",
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
					["174116384118973"] = {
						["key"] = "174116384118973",
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
							["GuidePointName"] = "Npc_Dyn_1720647",
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
					["174116384118974"] = {
						["key"] = "174116384118974",
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
								1720651,
								1720652,
								1720653,
								1720654,
								1720655,
								1720656,
								1720657,
								1720658
							}
						}
					},
					["174116384118975"] = {
						["key"] = "174116384118975",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 3300.5701489686785,
							["y"] = 471.7274509803922
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 8,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1720651,
								1720652,
								1720653,
								1720654,
								1720655,
								1720656,
								1720657,
								1720658
							}
						}
					},
					["174116384118977"] = {
						["key"] = "174116384118977",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "开启修理状态",
						["pos"] = {
							["x"] = 1821.1865998634848,
							["y"] = 281.3964254714749
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1720649
							},
							["ManualItemIdList"] = {},
							["StateId"] = 552,
							["QuestId"] = 0
						}
					},
					["174116384118978"] = {
						["key"] = "174116384118978",
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
					["174116384119079"] = {
						["key"] = "174116384119079",
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
					["174116384119080"] = {
						["key"] = "174116384119080",
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
					["174116384119081"] = {
						["key"] = "174116384119081",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换无法修理矿机状态",
						["pos"] = {
							["x"] = 2741.446205774815,
							["y"] = 353.7150646866659
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1720649
							},
							["ManualItemIdList"] = {},
							["StateId"] = 582,
							["QuestId"] = 0
						}
					},
					["174116384119082"] = {
						["key"] = "174116384119082",
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
					["174116384119083"] = {
						["key"] = "174116384119083",
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
								1720647
							}
						}
					},
					["174116384119084"] = {
						["key"] = "174116384119084",
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
								1720647
							}
						}
					},
					["174116384119085"] = {
						["key"] = "174116384119085",
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
							["GuidePointName"] = "Npc_Dyn_1720647",
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
					["174116384119086"] = {
						["key"] = "174116384119086",
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
					["174116384119087"] = {
						["key"] = "174116384119087",
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
								1720647
							}
						}
					},
					["174116384119088"] = {
						["key"] = "174116384119088",
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
					["174116384119089"] = {
						["key"] = "174116384119089",
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
					["174116384119090"] = {
						["key"] = "174116384119090",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "机关修理完成",
						["pos"] = {
							["x"] = 2733.3958791208806,
							["y"] = 161.88818681318673
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1720649,
							["StateId"] = 572,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["174116384119091"] = {
						["key"] = "174116384119091",
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
					["174116384119092"] = {
						["key"] = "174116384119092",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "机关选择修理",
						["pos"] = {
							["x"] = 2144.271428571428,
							["y"] = 641.661904761905
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1720649,
							["StateId"] = 562,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["174116384119193"] = {
						["key"] = "174116384119193",
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
					["174116384119194"] = {
						["key"] = "174116384119194",
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
					["174116384119195"] = {
						["key"] = "174116384119195",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成小游戏机关",
						["pos"] = {
							["x"] = 1548.935515873016,
							["y"] = 311.52474323062563
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720649
							}
						}
					},
					["174116384119196"] = {
						["key"] = "174116384119196",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1698.7586206896551,
							["y"] = 460.7115618661257
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["1756696945178635785"] = {
						["key"] = "1756696945178635785",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 1673.6391898864808,
							["y"] = 735.5492776057791
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