return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732783210835552816",
			["startPort"] = "StoryStart",
			["endStory"] = "1729059253065375719",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1729059253065375719",
			["startPort"] = "Success",
			["endStory"] = "17290602379552439178",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17290602379552439178",
			["startPort"] = "Success",
			["endStory"] = "17290609876112814755",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17290609876112814755",
			["startPort"] = "Success",
			["endStory"] = "17291489231501127382",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17291489231501127382",
			["startPort"] = "Success",
			["endStory"] = "17291508818644500927",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17291508818644500927",
			["startPort"] = "Success",
			["endStory"] = "172915275387110122592",
			["endPort"] = "In"
		},
		{
			["startStory"] = "172915275387110122592",
			["startPort"] = "Success",
			["endStory"] = "172916010872117255126",
			["endPort"] = "In"
		},
		{
			["startStory"] = "172916010872117255126",
			["startPort"] = "Success",
			["endStory"] = "17292358159711128742",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17292358159711128742",
			["startPort"] = "Success",
			["endStory"] = "17292380373075264585",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17292380373075264585",
			["startPort"] = "Success",
			["endStory"] = "1732783210835552817",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1729059253065375719"] = {
			["isStoryNode"] = true,
			["key"] = "1729059253065375719",
			["type"] = "StoryNode",
			["name"] = "去检票",
			["pos"] = {
				["x"] = 2069.4313700707785,
				["y"] = 310.7703488372093
			},
			["propsData"] = {
				["QuestId"] = 12000201,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120002_1",
				["QuestDeatil"] = "Content_120002_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = true,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_120002022_1960153",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1735819309523943909",
						["startPort"] = "Out",
						["endQuest"] = "173711383039222901646",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1729059253065375723",
						["startPort"] = "QuestStart",
						["endQuest"] = "173952889689017519073",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173952889689017519073",
						["startPort"] = "Out",
						["endQuest"] = "173651178308623293365",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173651178308623293365",
						["startPort"] = "Out",
						["endQuest"] = "173651179540923293799",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173711383039222901646",
						["startPort"] = "Out",
						["endQuest"] = "1729059253065375724",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173651179540923293799",
						["startPort"] = "Out",
						["endQuest"] = "17400534277715511018",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17400534277715511018",
						["startPort"] = "Out",
						["endQuest"] = "17442068881615192147",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17442068881615192147",
						["startPort"] = "Out",
						["endQuest"] = "173952943312019579417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173952943312019579417",
						["startPort"] = "Out",
						["endQuest"] = "1735819309523943909",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1729059253065375723"] = {
						["key"] = "1729059253065375723",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1940.3146853146854,
							["y"] = 442.8671328671328
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1729059253065375724"] = {
						["key"] = "1729059253065375724",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3481.1294213880187,
							["y"] = 455.300623880858
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1729059253065375725"] = {
						["key"] = "1729059253065375725",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["1735819309523943909"] = {
						["key"] = "1735819309523943909",
						["type"] = "TalkNode",
						["name"] = "站桩 - 黑屏 Fixsimple04",
						["pos"] = {
							["x"] = 2987.463475441229,
							["y"] = 436.212545114132
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001101,
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
					["173651178308623293365"] = {
						["key"] = "173651178308623293365",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2496.0232260560133,
							["y"] = 292.04900199793275
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1960163,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000201goto1_1960163"
						}
					},
					["173651179540923293799"] = {
						["key"] = "173651179540923293799",
						["type"] = "TalkNode",
						["name"] = "看到了一眼止流",
						["pos"] = {
							["x"] = 2290.0441695141153,
							["y"] = 466.04193469852964
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12000715,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000201in",
							["BlendInTime"] = 1,
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
					["173711383039222901646"] = {
						["key"] = "173711383039222901646",
						["type"] = "TalkNode",
						["name"] = "站桩 - 检票冲突 Fixsimple04",
						["pos"] = {
							["x"] = 3247.1151470785367,
							["y"] = 431.4909877275326
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001102,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000201in",
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
							["SkipToOption"] = true,
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
									["TalkActorId"] = 220010,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220013,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210004,
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
					["173952889689017519073"] = {
						["key"] = "173952889689017519073",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2200.2199020934577,
							["y"] = 292.0072007355053
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960162,
								1960164,
								1969991
							}
						}
					},
					["173952943312019579417"] = {
						["key"] = "173952943312019579417",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3031.161157948026,
							["y"] = 650.3680803100071
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960162,
								1969991
							}
						}
					},
					["17400534277715511018"] = {
						["key"] = "17400534277715511018",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2501.264399998196,
							["y"] = 648.2506339059622
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1960170,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000201jianpiaoBox_1960170"
						}
					},
					["17442068881615192147"] = {
						["key"] = "17442068881615192147",
						["type"] = "TalkNode",
						["name"] = "站桩 - 检票冲突 Fixsimple04",
						["pos"] = {
							["x"] = 2761.3211199428583,
							["y"] = 651.6822793148881
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12000901,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "TalkStageNew12000201in",
							["BlendInTime"] = 1,
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
							["SkipToOption"] = true,
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
									["TalkActorId"] = 220010,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220046,
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
		["17290602379552439178"] = {
			["isStoryNode"] = true,
			["key"] = "17290602379552439178",
			["type"] = "StoryNode",
			["name"] = "进剧院与止流交谈",
			["pos"] = {
				["x"] = 2323.177266898749,
				["y"] = 310.8902632179844
			},
			["propsData"] = {
				["QuestId"] = 12000202,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120002_2",
				["QuestDeatil"] = "Content_120002_2",
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
				["SubRegionId"] = 101901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_injuyuan12000202_1960168",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17358203430843776243",
						["startPort"] = "Out",
						["endQuest"] = "173652218109449226493",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17290602379552439182",
						["startPort"] = "QuestStart",
						["endQuest"] = "173652272712150187926",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173652272712150187926",
						["startPort"] = "Out",
						["endQuest"] = "17358045609622565",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17358045609622565",
						["startPort"] = "Out",
						["endQuest"] = "17290602379552439183",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17290602379552439182"] = {
						["key"] = "17290602379552439182",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2267.457542457543,
							["y"] = 801.4385614385615
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17290602379552439183"] = {
						["key"] = "17290602379552439183",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3345.634335905934,
							["y"] = 813.0761906368986
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17290602379552439184"] = {
						["key"] = "17290602379552439184",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3643.1774913692475,
							["y"] = 1243.420824647431
						},
						["propsData"] = {}
					},
					["17290602379552439186"] = {
						["key"] = "17290602379552439186",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和止流交谈 Fixsimple05",
						["pos"] = {
							["x"] = 3329.076795868618,
							["y"] = 580.2999620982525
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210004,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Zhiliu_1930022",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12010801,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_05",
							["BlendInTime"] = 1,
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
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210004,
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
					["17358045609622564"] = {
						["key"] = "17358045609622564",
						["type"] = "GoToNode",
						["name"] = "进入之后直接在原地触发站桩",
						["pos"] = {
							["x"] = 3668.217269912433,
							["y"] = 757.4567983834627
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1960146,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000202"
						}
					},
					["17358045609622565"] = {
						["key"] = "17358045609622565",
						["type"] = "TalkNode",
						["name"] = "站桩 - 止流对话 Fixsimple04",
						["pos"] = {
							["x"] = 2848.591215471493,
							["y"] = 790.6061451036591
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210004,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Zhiliu_12000202_1960147",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12001310,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000202",
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
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = true,
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
									["TalkActorId"] = 210004,
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
					["17358203430843776243"] = {
						["key"] = "17358203430843776243",
						["type"] = "GoToNode",
						["name"] = "剧院内部点位",
						["pos"] = {
							["x"] = 3144.7039552066203,
							["y"] = 1129.0302839768926
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1960168,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_injuyuan12000202_1960168"
						}
					},
					["173652215043849226119"] = {
						["key"] = "173652215043849226119",
						["type"] = "TalkNode",
						["name"] = "开车解释一下",
						["pos"] = {
							["x"] = 3067.9732565716245,
							["y"] = 627.6021979712604
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["173652218109449226493"] = {
						["key"] = "173652218109449226493",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 3428.4083460472334,
							["y"] = 1182.721413811702
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint2_12000202",
							["FadeIn"] = true,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["173652272712150187926"] = {
						["key"] = "173652272712150187926",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2549.229424411004,
							["y"] = 786.7947213447729
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Zhiliu_12000202_1960147",
							["StaticCreatorIdList"] = {
								1960147,
								1969982
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17290609876112814755"] = {
			["isStoryNode"] = true,
			["key"] = "17290609876112814755",
			["type"] = "StoryNode",
			["name"] = "坐下看剧",
			["pos"] = {
				["x"] = 2585.5648210113036,
				["y"] = 305.64727902826115
			},
			["propsData"] = {
				["QuestId"] = 12000203,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120002_3",
				["QuestDeatil"] = "Content_120002_3",
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
				["SubRegionId"] = 101901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "NewTargetPoint_12000203",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17358198031522830769",
						["startPort"] = "Out",
						["endQuest"] = "17489363372656739",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17489363372656739",
						["startPort"] = "Out",
						["endQuest"] = "17393422799282299726",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17290609876112814759",
						["startPort"] = "QuestStart",
						["endQuest"] = "17489397954781755394",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750215222027952222",
						["startPort"] = "Out",
						["endQuest"] = "1750215222027952223",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17489397954781755394",
						["startPort"] = "Out",
						["endQuest"] = "1750214056654950672",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17393422799282299726",
						["startPort"] = "Out",
						["endQuest"] = "17290609876112814760",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1750214056654950672",
						["startPort"] = "Out",
						["endQuest"] = "17430735872872436284",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17430735872872436284",
						["startPort"] = "Out",
						["endQuest"] = "1750215222027952222",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17430735872872436284",
						["startPort"] = "Out",
						["endQuest"] = "17358198031522830769",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17290609876112814759"] = {
						["key"] = "17290609876112814759",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2103.5308911518596,
							["y"] = 708.1141886787047
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17290609876112814760"] = {
						["key"] = "17290609876112814760",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3686.2880452880454,
							["y"] = 844.7460059097996
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17290609876112814761"] = {
						["key"] = "17290609876112814761",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3736.558438513615,
							["y"] = 1049.4480425579084
						},
						["propsData"] = {}
					},
					["17358198031522830769"] = {
						["key"] = "17358198031522830769",
						["type"] = "TalkNode",
						["name"] = "站桩 - 看剧 Fixsimple04",
						["pos"] = {
							["x"] = 2604.187906632321,
							["y"] = 854.2937217139543
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001324,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000203",
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
							["SkipToOption"] = true,
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
									["TalkActorId"] = 220042,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220041,
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
					["173702676485027574037"] = {
						["key"] = "173702676485027574037",
						["type"] = "TalkNode",
						["name"] = "假装坐下了",
						["pos"] = {
							["x"] = 2458.033790405245,
							["y"] = 457.75243643627016
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 220027,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "NewTargetPoint_12000203",
							["DelayShowGuideTime"] = 0,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East00/Zhiliu_Sit",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
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
					["17393422799282299726"] = {
						["key"] = "17393422799282299726",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 3118.7151010328557,
							["y"] = 856.0244321579394
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint120002032",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17425411201978362"] = {
						["key"] = "17425411201978362",
						["type"] = "TalkNode",
						["name"] = "假装坐下Sequence",
						["pos"] = {
							["x"] = 2559.4465439530836,
							["y"] = 333.3387075448987
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 100001,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "",
							["DelayShowGuideTime"] = 0,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East00/Zhiliu_Sit",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
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
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17430735872872436284"] = {
						["key"] = "17430735872872436284",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "消除止流",
						["pos"] = {
							["x"] = 2853.9014027282005,
							["y"] = 683.5098967451761
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960147
							}
						}
					},
					["17489363372656739"] = {
						["key"] = "17489363372656739",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2878.91024038008,
							["y"] = 856.1949381620179
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17489397954781755394"] = {
						["key"] = "17489397954781755394",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2340.491749048933,
							["y"] = 685.419624786837
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/mute",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								101901
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["1750214056654950672"] = {
						["key"] = "1750214056654950672",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 2581.8309667854696,
							["y"] = 668.9970152210831
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1969970
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 10068,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Drop_12000203sit_1969970",
							["IsUseCount"] = false
						}
					},
					["1750215222027952222"] = {
						["key"] = "1750215222027952222",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = 3228.1597940227407,
							["y"] = 648.9594829244431
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101901,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Drop_12000203sit_1969970"
						}
					},
					["1750215222027952223"] = {
						["key"] = "1750215222027952223",
						["type"] = "SendMessageNode",
						["name"] = "晚上",
						["pos"] = {
							["x"] = 3481.2052479051495,
							["y"] = 674.9994101530115
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "TheaNight",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17291489231501127382"] = {
			["isStoryNode"] = true,
			["key"] = "17291489231501127382",
			["type"] = "StoryNode",
			["name"] = "黑商进场",
			["pos"] = {
				["x"] = 2849.7637987012986,
				["y"] = 305.0159887194458
			},
			["propsData"] = {
				["QuestId"] = 12000204,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120002_4",
				["QuestDeatil"] = "Content_120002_4",
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
				["SubRegionId"] = 101901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "NewTargetPoint12000204",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17358213798963782608",
						["startPort"] = "Out",
						["endQuest"] = "173686621736928943924",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17358216926213786674",
						["startPort"] = "Out",
						["endQuest"] = "173702952699739309821",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17373752817964960386",
						["startPort"] = "Out",
						["endQuest"] = "173652471869954031925",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17291489231501127386",
						["startPort"] = "QuestStart",
						["endQuest"] = "17291496302451877413",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17291496302451877413",
						["startPort"] = "Out",
						["endQuest"] = "17358213798963782608",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173686621736928943924",
						["startPort"] = "Out",
						["endQuest"] = "17373752476764959709",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17373752476764959709",
						["startPort"] = "Out",
						["endQuest"] = "17373752817964960386",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17373752476764959709",
						["startPort"] = "Out",
						["endQuest"] = "17358216926213786674",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173702952699739309821",
						["startPort"] = "Out",
						["endQuest"] = "17479240649132429",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17291496302451877413",
						["startPort"] = "Out",
						["endQuest"] = "17489370279317845",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173686621736928943924",
						["startPort"] = "Out",
						["endQuest"] = "17489370977248548",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17373752476764959709",
						["startPort"] = "Out",
						["endQuest"] = "17489373296329494",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17479240649132429",
						["startPort"] = "Out",
						["endQuest"] = "174893746783210162",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174893746783210162",
						["startPort"] = "Out",
						["endQuest"] = "17291489231501127387",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17291489231501127386"] = {
						["key"] = "17291489231501127386",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2005.3742091242098,
							["y"] = 830.0496725496726
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17291489231501127387"] = {
						["key"] = "17291489231501127387",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3978.6992244068824,
							["y"] = 977.5835828724788
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17291489231501127388"] = {
						["key"] = "17291489231501127388",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3528.7817939182255,
							["y"] = 1221.6241678111994
						},
						["propsData"] = {}
					},
					["17291496302451877413"] = {
						["key"] = "17291496302451877413",
						["type"] = "GoToNode",
						["name"] = "前往门口",
						["pos"] = {
							["x"] = 2325.139659981252,
							["y"] = 830.4782294999684
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1960150,
							["GuideType"] = "P",
							["GuidePointName"] = "NewTargetPoint12000204"
						}
					},
					["17358213798963782608"] = {
						["key"] = "17358213798963782608",
						["type"] = "TalkNode",
						["name"] = "站桩-黑商进来",
						["pos"] = {
							["x"] = 2616.7402870817227,
							["y"] = 841.604629911495
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001338,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000204",
							["BlendInTime"] = 1,
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
									["TalkActorId"] = 220017,
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
									["TalkActorId"] = 220014,
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
					["17358216926213786674"] = {
						["key"] = "17358216926213786674",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成一队面包人",
						["pos"] = {
							["x"] = 3406.386155988444,
							["y"] = 984.7308288579486
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960155,
								1960156,
								1960157,
								1960158
							}
						}
					},
					["173652471869954031925"] = {
						["key"] = "173652471869954031925",
						["type"] = "TalkNode",
						["name"] = "开车- 止流说话",
						["pos"] = {
							["x"] = 3741.6703764099325,
							["y"] = 780.4125397756384
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001401,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["173686621736928943924"] = {
						["key"] = "173686621736928943924",
						["type"] = "TalkNode",
						["name"] = "黑屏-黑商进来",
						["pos"] = {
							["x"] = 2893.3912538845507,
							["y"] = 840.4149780987057
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001346,
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
					["173702952699739309821"] = {
						["key"] = "173702952699739309821",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 3675.480777716519,
							["y"] = 953.3338780284313
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 4,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1960155,
								1960158,
								1960156,
								1960157
							}
						}
					},
					["17373752476764959709"] = {
						["key"] = "17373752476764959709",
						["type"] = "TalkNode",
						["name"] = "站桩-黑商继续",
						["pos"] = {
							["x"] = 3185.13777020311,
							["y"] = 830.5719321506573
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001348,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "TalkStageNew12000204",
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
							["SkipToOption"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "12000204TargetPointBat",
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
									["TalkActorId"] = 220018,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220017,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220014,
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
									["TalkActorId"] = 220045,
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
					["17373752817964960386"] = {
						["key"] = "17373752817964960386",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3461.6135000856057,
							["y"] = 801.2986363407763
						},
						["propsData"] = {
							["WaitTime"] = 1.3
						}
					},
					["17479240649132429"] = {
						["key"] = "17479240649132429",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3841.9285714285716,
							["y"] = 1303.8766233766235
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["17489370279317845"] = {
						["key"] = "17489370279317845",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2706.6149787980075,
							["y"] = 685.9817757252918
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/mute",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								101901
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17489370977248548"] = {
						["key"] = "17489370977248548",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 3089.5253037671555,
							["y"] = 614.6137173131157
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17489373296329494"] = {
						["key"] = "17489373296329494",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 3490.2121539189,
							["y"] = 647.6104852510603
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt02/0051_story_danger",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								101901
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["174893746783210162"] = {
						["key"] = "174893746783210162",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 4117.9264396331855,
							["y"] = 1313.1709248115
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17291508818644500927"] = {
			["isStoryNode"] = true,
			["key"] = "17291508818644500927",
			["type"] = "StoryNode",
			["name"] = "离场冲突",
			["pos"] = {
				["x"] = 3117.2630574171485,
				["y"] = 305.9673599347512
			},
			["propsData"] = {
				["QuestId"] = 12000205,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120002_5",
				["QuestDeatil"] = "Content_120002_5",
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
				["SubRegionId"] = 101901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "NewTargetPoint12000204",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17291521450197499242",
						["startPort"] = "Out",
						["endQuest"] = "17291508818644500932",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17291508818644500931",
						["startPort"] = "QuestStart",
						["endQuest"] = "17291521450197499242",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17291508818644500931"] = {
						["key"] = "17291508818644500931",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1718.5526199188123,
							["y"] = 836.2565691013966
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17291508818644500932"] = {
						["key"] = "17291508818644500932",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2679.5317808569416,
							["y"] = 864.059812950423
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17291508818644500933"] = {
						["key"] = "17291508818644500933",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2672.176178944964,
							["y"] = 1009.1341945491673
						},
						["propsData"] = {}
					},
					["17291519509656749305"] = {
						["key"] = "17291519509656749305",
						["type"] = "TalkNode",
						["name"] = "开车- 止流说话",
						["pos"] = {
							["x"] = 2075.726365711181,
							["y"] = 636.2821333447929
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011201,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17291520470867124300"] = {
						["key"] = "17291520470867124300",
						["type"] = "TalkNode",
						["name"] = "过场 - 黑商求饶",
						["pos"] = {
							["x"] = 2590.3874221295882,
							["y"] = 546.4996489373085
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011301,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0.5,
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
					["17291521450197499242"] = {
						["key"] = "17291521450197499242",
						["type"] = "TalkNode",
						["name"] = "过场 - 黑商求饶",
						["pos"] = {
							["x"] = 2175.3331923329974,
							["y"] = 843.9658898467654
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001501,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000204",
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
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220017,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220018,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220014,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220045,
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
					["17400548448678657774"] = {
						["key"] = "17400548448678657774",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2023.0802172371084,
							["y"] = 1015.9896521824732
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960152,
								1960151
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["172915275387110122592"] = {
			["isStoryNode"] = true,
			["key"] = "172915275387110122592",
			["type"] = "StoryNode",
			["name"] = "去拿月髓液",
			["pos"] = {
				["x"] = 2060.3554421326057,
				["y"] = 473.8211082928153
			},
			["propsData"] = {
				["QuestId"] = 12000206,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120002_6",
				["QuestDeatil"] = "Content_120002_6",
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
				["SubRegionId"] = 101901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Heishang_12000204_1960152",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "172915643756514252359",
						["startPort"] = "Out",
						["endQuest"] = "17400548593188658326",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17400548593188658326",
						["startPort"] = "Out",
						["endQuest"] = "174893755020010921",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174893755020010921",
						["startPort"] = "Out",
						["endQuest"] = "172915275387110122597",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "172915275387110122596",
						["startPort"] = "QuestStart",
						["endQuest"] = "17521372934611942278",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17521372934611942278",
						["startPort"] = "Out",
						["endQuest"] = "172915643756514252359",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["172915275387110122596"] = {
						["key"] = "172915275387110122596",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2209.9895937395945,
							["y"] = 910.8830058830059
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172915275387110122597"] = {
						["key"] = "172915275387110122597",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2844.3561263659476,
							["y"] = 934.9423655176673
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172915275387110122598"] = {
						["key"] = "172915275387110122598",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4029.3877174065015,
							["y"] = 949.8553483953211
						},
						["propsData"] = {}
					},
					["172915593757112750474"] = {
						["key"] = "172915593757112750474",
						["type"] = "TalkNode",
						["name"] = "开车- 小心敌人",
						["pos"] = {
							["x"] = 3242.3845583450743,
							["y"] = 1227.3469664096137
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011601,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["172915643756514252359"] = {
						["key"] = "172915643756514252359",
						["type"] = "TalkNode",
						["name"] = "站桩 - 点香",
						["pos"] = {
							["x"] = 2545.0112016443554,
							["y"] = 922.5793667078373
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 220018,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Heishang_12000204_1960152",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12001506,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000204",
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
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220017,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220018,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220014,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220045,
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
					["17400548593188658326"] = {
						["key"] = "17400548593188658326",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2567.7320077795594,
							["y"] = 1092.315613944909
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960152,
								1969993,
								1969982,
								1969994
							}
						}
					},
					["174893755020010921"] = {
						["key"] = "174893755020010921",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2837.5913348135555,
							["y"] = 1099.3391990725413
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17521372934611942278"] = {
						["key"] = "17521372934611942278",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2547.0152270699728,
							["y"] = 778.6969123135616
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960152,
								1969994,
								1969993
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["172916010872117255126"] = {
			["isStoryNode"] = true,
			["key"] = "172916010872117255126",
			["type"] = "StoryNode",
			["name"] = "歌剧院外",
			["pos"] = {
				["x"] = 2323.977836500856,
				["y"] = 477.50859709926266
			},
			["propsData"] = {
				["QuestId"] = 12000207,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120002_7",
				["QuestDeatil"] = "Content_120002_7",
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
				["StoryGuidePointName"] = "Point12000207zhiliuTalk",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17292362814791505843",
						["startPort"] = "Out",
						["endQuest"] = "17292363333992257001",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17292363333992257001",
						["startPort"] = "Out",
						["endQuest"] = "172916010872117255131",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "172916010872117255130",
						["startPort"] = "QuestStart",
						["endQuest"] = "17292362814791505843",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["172916010872117255130"] = {
						["key"] = "172916010872117255130",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2811.250832500833,
							["y"] = 840.6600621600621
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172916010872117255131"] = {
						["key"] = "172916010872117255131",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3487.891819466979,
							["y"] = 740.0402480558582
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172916010872117255132"] = {
						["key"] = "172916010872117255132",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3653.673431692216,
							["y"] = 969.2839198238926
						},
						["propsData"] = {}
					},
					["17292362814791505843"] = {
						["key"] = "17292362814791505843",
						["type"] = "GoToNode",
						["name"] = "触发止流对话",
						["pos"] = {
							["x"] = 3142.30610968225,
							["y"] = 885.0149557422798
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191060,
							["GuideType"] = "P",
							["GuidePointName"] = "Point12000207zhiliuTalk"
						}
					},
					["17292363333992257001"] = {
						["key"] = "17292363333992257001",
						["type"] = "TalkNode",
						["name"] = "过场 - 止流对话",
						["pos"] = {
							["x"] = 3391.9991526177732,
							["y"] = 882.9123395739939
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001517,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000207",
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
									["TalkActorId"] = 220014,
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
					["173711406422824872692"] = {
						["key"] = "173711406422824872692",
						["type"] = "TalkNode",
						["name"] = "站桩 - 止流对话 Fixsimple04",
						["pos"] = {
							["x"] = 3364.060167551217,
							["y"] = 494.4288728685948
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001310,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000202",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0.5,
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
									["TalkActorId"] = 210004,
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
					}
				},
				["commentData"] = {}
			}
		},
		["17292358159711128742"] = {
			["isStoryNode"] = true,
			["key"] = "17292358159711128742",
			["type"] = "StoryNode",
			["name"] = "带止流去水仙平原",
			["pos"] = {
				["x"] = 2592.787317945214,
				["y"] = 479.18231258745357
			},
			["propsData"] = {
				["QuestId"] = 12000208,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120002_8",
				["QuestDeatil"] = "Content_120002_8",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12000208SPBox_1191335",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17359039529173101105",
						["startPort"] = "Out",
						["endQuest"] = "17292364048293383924",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17292364048293383924",
						["startPort"] = "Out",
						["endQuest"] = "17359039883263102057",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17410895638493251",
						["startPort"] = "Out",
						["endQuest"] = "17292358159711128747",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17359039883263102057",
						["startPort"] = "Out",
						["endQuest"] = "17410895951454153",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17410895515913095",
						["startPort"] = "Success",
						["endQuest"] = "17411591634292389271",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17411591634292389271",
						["startPort"] = "Out",
						["endQuest"] = "17410895638493251",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17292358159711128746",
						["startPort"] = "QuestStart",
						["endQuest"] = "17442002199471917417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17442002199471917417",
						["startPort"] = "Out",
						["endQuest"] = "17410895515913095",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17442004325411918217",
						["startPort"] = "Out",
						["endQuest"] = "17292358159711128748",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17410895515913095",
						["startPort"] = "Fail",
						["endQuest"] = "17442004325411918217",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17410895515913095",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17442004325411918217",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17292358159711128746"] = {
						["key"] = "17292358159711128746",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1820.9701083166783,
							["y"] = 834.916487200061
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17292358159711128747"] = {
						["key"] = "17292358159711128747",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3320.8287863999803,
							["y"] = 881.5332722023534
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17292358159711128748"] = {
						["key"] = "17292358159711128748",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3086.5127174065015,
							["y"] = 1044.1251896651625
						},
						["propsData"] = {}
					},
					["17292364048293383924"] = {
						["key"] = "17292364048293383924",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2544.1279332693175,
							["y"] = 555.8492774541721
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
					["17359036572563099615"] = {
						["key"] = "17359036572563099615",
						["type"] = "GoToNode",
						["name"] = "到酒馆门口",
						["pos"] = {
							["x"] = 2766.4827082975207,
							["y"] = 1443.0864957742392
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191018,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000102"
						}
					},
					["17359039529173101105"] = {
						["key"] = "17359039529173101105",
						["type"] = "GoToNode",
						["name"] = "带止流走",
						["pos"] = {
							["x"] = 2254.6326820672625,
							["y"] = 540.1082234261341
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191030,
							["GuideType"] = "N",
							["GuidePointName"] = "Zhiliu_12000207"
						}
					},
					["17359039883263102057"] = {
						["key"] = "17359039883263102057",
						["type"] = "GoToNode",
						["name"] = "冰湖城内",
						["pos"] = {
							["x"] = 2831.615556134176,
							["y"] = 578.940172058714
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 1640465,
							["GuideType"] = "P",
							["GuidePointName"] = "NewTargetPoint_120002081"
						}
					},
					["17359040117023102718"] = {
						["key"] = "17359040117023102718",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 2341.403920411005,
							["y"] = 1334.2324605250863
						},
						["propsData"] = {
							["SpecialConfigId"] = 0,
							["BlackScreenImmediately"] = false
						}
					},
					["17410895515913095"] = {
						["key"] = "17410895515913095",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 2452.6921578173533,
							["y"] = 837.8424926141066
						},
						["propsData"] = {
							["SpecialConfigId"] = 12000208,
							["BlackScreenImmediately"] = false
						}
					},
					["17410895638493251"] = {
						["key"] = "17410895638493251",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 3048.4032698803017,
							["y"] = 881.5415603229302
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["17410895699223426"] = {
						["key"] = "17410895699223426",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 止流AI",
						["pos"] = {
							["x"] = 3961.7102196872534,
							["y"] = 811.2488962302663
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240050
							}
						}
					},
					["17410895951454153"] = {
						["key"] = "17410895951454153",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成止流AI",
						["pos"] = {
							["x"] = 3045.95038297294,
							["y"] = 565.7576042678654
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191061
							}
						}
					},
					["17411591634292389271"] = {
						["key"] = "17411591634292389271",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 赛琪AI2号",
						["pos"] = {
							["x"] = 2758.133213996318,
							["y"] = 886.8128408442511
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191061
							}
						}
					},
					["17442002199471917417"] = {
						["key"] = "17442002199471917417",
						["type"] = "GoToNode",
						["name"] = "特殊任务盒子",
						["pos"] = {
							["x"] = 2139.274935396532,
							["y"] = 857.0254821757665
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191335,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000208SPBox_1191335"
						}
					},
					["17442004325411918217"] = {
						["key"] = "17442004325411918217",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2838.078201617292,
							["y"] = 1054.1392909302883
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint12000208SP",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17292380373075264585"] = {
			["isStoryNode"] = true,
			["key"] = "17292380373075264585",
			["type"] = "StoryNode",
			["name"] = "水仙平原内",
			["pos"] = {
				["x"] = 2851.330895985584,
				["y"] = 476.8055723926477
			},
			["propsData"] = {
				["QuestId"] = 12000209,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120002_9",
				["QuestDeatil"] = "Content_120002_9",
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
				["SubRegionId"] = 101107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12000101_1220106",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17292380373085264589",
						["startPort"] = "QuestStart",
						["endQuest"] = "17585272170871869660",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17585272170871869660",
						["startPort"] = "Out",
						["endQuest"] = "17292381015445641402",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17292381015445641402",
						["startPort"] = "Out",
						["endQuest"] = "17292380373085264590",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17292380373085264589"] = {
						["key"] = "17292380373085264589",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2475.7017953311065,
							["y"] = 830.0496725496726
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17292380373085264590"] = {
						["key"] = "17292380373085264590",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3583.595662377719,
							["y"] = 804.356563613553
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17292380373085264591"] = {
						["key"] = "17292380373085264591",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4029.3877174065015,
							["y"] = 949.8553483953211
						},
						["propsData"] = {}
					},
					["17292381015445641402"] = {
						["key"] = "17292381015445641402",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和卡米拉对话 Fixsimple09",
						["pos"] = {
							["x"] = 3206.0670394736617,
							["y"] = 834.1000883760579
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001524,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000209",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
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
									["TalkActorId"] = 200003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210004,
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
					["17359049512624055479"] = {
						["key"] = "17359049512624055479",
						["type"] = "GoToNode",
						["name"] = "酒馆内",
						["pos"] = {
							["x"] = 2799.7602478375793,
							["y"] = 830.1824857704429
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1220106,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000101_1220106"
						}
					},
					["17406374394233373"] = {
						["key"] = "17406374394233373",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3263.0158391909417,
							["y"] = 661.272637001775
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960164
							}
						}
					},
					["17410896634705423"] = {
						["key"] = "17410896634705423",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 止流AI",
						["pos"] = {
							["x"] = 2945.7357010593487,
							["y"] = 591.2910407014559
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240050
							}
						}
					},
					["17585272170871869660"] = {
						["key"] = "17585272170871869660",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 2851.5720285865464,
							["y"] = 1038.9895592765995
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101107,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_12000101_1220106"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1732783210835552816"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210835552816",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1776,
				["y"] = 322
			},
			["propsData"] = {
				["QuestChainId"] = 120002
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1732783210835552817"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210835552817",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 3181.172895517031,
				["y"] = 485.58496217847267
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}