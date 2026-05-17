return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17633704514641",
			["startPort"] = "StoryStart",
			["endStory"] = "1763371085703672929",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1763371641119678238",
			["startPort"] = "Success",
			["endStory"] = "1763371657647678540",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1763371085703672929",
			["startPort"] = "Success",
			["endStory"] = "1763371196784673865",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1763371196784673865",
			["startPort"] = "Success",
			["endStory"] = "1763371608095677862",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1763371657647678540",
			["startPort"] = "Success",
			["endStory"] = "17633704514645",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1763371608095677862",
			["startPort"] = "Success",
			["endStory"] = "1763371641119678238",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17633704514641"] = {
			["isStoryNode"] = true,
			["key"] = "17633704514641",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 811.6666666666666,
				["y"] = 302
			},
			["propsData"] = {
				["QuestChainId"] = 120301
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17633704514645"] = {
			["isStoryNode"] = true,
			["key"] = "17633704514645",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1684.194424382493,
				["y"] = 569.0715248687949
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1763371085703672929"] = {
			["isStoryNode"] = true,
			["key"] = "1763371085703672929",
			["type"] = "StoryNode",
			["name"] = "东城吃饭",
			["pos"] = {
				["x"] = 1126.7670807453417,
				["y"] = 290.3333333333333
			},
			["propsData"] = {
				["QuestId"] = 12030101,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120301_1",
				["QuestDeatil"] = "Content__120301_1",
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
				["SubRegionId"] = 104501,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203010101_132010079",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1763371085703672930",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763371205199674010",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371205199674010",
						["startPort"] = "Out",
						["endQuest"] = "1763371224783674562",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725931388287244302",
						["startPort"] = "Out",
						["endQuest"] = "1763371085703672933",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1763371205199674010",
						["startPort"] = "Out",
						["endQuest"] = "17726783303842766",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1763371224783674562",
						["startPort"] = "Out",
						["endQuest"] = "17733821479461253",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733821479461253",
						["startPort"] = "Out",
						["endQuest"] = "17725931388287244302",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1763371085703672930"] = {
						["key"] = "1763371085703672930",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 999.8181818181819,
							["y"] = 302.9090909090909
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763371085703672933"] = {
						["key"] = "1763371085703672933",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2506.212121212122,
							["y"] = 296.8585858585858
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763371085703672936"] = {
						["key"] = "1763371085703672936",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1925.4545454545455,
							["y"] = 487.1818181818182
						},
						["propsData"] = {}
					},
					["1763371205199674010"] = {
						["key"] = "1763371205199674010",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1317.7509881422925,
							["y"] = 288.42292490118575
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132010079,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203010101_132010079"
						}
					},
					["1763371224783674562"] = {
						["key"] = "1763371224783674562",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1599.5353535353536,
							["y"] = 290.5454545454545
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12060101.12060101'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030101",
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
					["17725931388287244302"] = {
						["key"] = "17725931388287244302",
						["type"] = "OpenChapterUINode",
						["name"] = "打开章节开始UI",
						["pos"] = {
							["x"] = 2203.9332750582753,
							["y"] = 302.652972027972
						},
						["propsData"] = {
							["ChapterUIId"] = 120300,
							["UIType"] = "Start"
						}
					},
					["17726783303842766"] = {
						["key"] = "17726783303842766",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1602.3707093821513,
							["y"] = 482.2013729977117
						},
						["propsData"] = {
							["TargetTime"] = 12,
							["NeedLerp"] = false,
							["LerpTime"] = 0
						}
					},
					["17733821479461253"] = {
						["key"] = "17733821479461253",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1884.5557928913195,
							["y"] = 287.6138072453863
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1763371196784673865"] = {
			["isStoryNode"] = true,
			["key"] = "1763371196784673865",
			["type"] = "StoryNode",
			["name"] = "找苏乙",
			["pos"] = {
				["x"] = 1400.945341614907,
				["y"] = 290.6053830227743
			},
			["propsData"] = {
				["QuestId"] = 12030102,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120301_2",
				["QuestDeatil"] = "Content__120301_2",
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
				["SubRegionId"] = 104501,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203010201_132010080",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1763371196784673870",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763371425407676396",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371425407676396",
						["startPort"] = "Out",
						["endQuest"] = "1763371441111676656",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371441111676656",
						["startPort"] = "Out",
						["endQuest"] = "1763371443249676753",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371441111676656",
						["startPort"] = "Out",
						["endQuest"] = "17708814730161158398",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371443249676753",
						["startPort"] = "Out",
						["endQuest"] = "17708814674091158300",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371196784673870",
						["startPort"] = "QuestStart",
						["endQuest"] = "17708814418561157988",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17708814674091158300",
						["startPort"] = "Out",
						["endQuest"] = "1763371196784673871",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1763371196784673870"] = {
						["key"] = "1763371196784673870",
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
					["1763371196784673871"] = {
						["key"] = "1763371196784673871",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2198.486166007905,
							["y"] = 288.3583662714098
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763371196784673872"] = {
						["key"] = "1763371196784673872",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2092.5454545454545,
							["y"] = 476.09090909090907
						},
						["propsData"] = {}
					},
					["1763371425407676396"] = {
						["key"] = "1763371425407676396",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1086.4444444444443,
							["y"] = 288.8888888888889
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132010080,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203010201_132010080"
						}
					},
					["1763371441111676656"] = {
						["key"] = "1763371441111676656",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1365.090909090909,
							["y"] = 288.78787878787875
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12060201.12060201'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030102",
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
					["1763371443249676753"] = {
						["key"] = "1763371443249676753",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1640.4444444444443,
							["y"] = 289.45454545454544
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250003,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030102Suyi_132010143",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12060301.12060301'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "TalkStageNew_12030102",
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
					["17708814418561157988"] = {
						["key"] = "17708814418561157988",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1084.866930171278,
							["y"] = 128.8981115502853
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010143,
								132010144,
								132010145
							}
						}
					},
					["17708814674091158300"] = {
						["key"] = "17708814674091158300",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1918.393500219587,
							["y"] = 289.52613087395684
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010143
							}
						}
					},
					["17708814730161158398"] = {
						["key"] = "17708814730161158398",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1643.321036451471,
							["y"] = 129.13965744400517
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010144,
								132010145
							}
						}
					},
					["17726783789151228657"] = {
						["key"] = "17726783789151228657",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1365.6140350877195,
							["y"] = 487.07602339181295
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
		["1763371608095677862"] = {
			["isStoryNode"] = true,
			["key"] = "1763371608095677862",
			["type"] = "StoryNode",
			["name"] = "追踪塔比瑟",
			["pos"] = {
				["x"] = 1679.4904009034449,
				["y"] = 292.87605872388474
			},
			["propsData"] = {
				["QuestId"] = 12030103,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120301_3",
				["QuestDeatil"] = "Content__120301_3",
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
				["SubRegionId"] = 104501,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_1203010301_132010081",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17633720063122026718",
						["startPort"] = "Out",
						["endQuest"] = "1763371608095677866",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17649178318683135693",
						["startPort"] = "Out",
						["endQuest"] = "17633720063122026718",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371608095677863",
						["startPort"] = "QuestStart",
						["endQuest"] = "17649178318683135693",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371608095677863",
						["startPort"] = "QuestStart",
						["endQuest"] = "17685471932161318",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17685471932161318",
						["startPort"] = "Out",
						["endQuest"] = "17667324358671066674",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667324358671066674",
						["startPort"] = "Out",
						["endQuest"] = "17685471940121351",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17685471940121351",
						["startPort"] = "Out",
						["endQuest"] = "17667324635251067044",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667324635251067044",
						["startPort"] = "Out",
						["endQuest"] = "17685472933851107904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17649178318683135693",
						["startPort"] = "Out",
						["endQuest"] = "17685473107871108266",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371608095677863",
						["startPort"] = "QuestStart",
						["endQuest"] = "17707104997401354",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17685471932161318",
						["startPort"] = "Out",
						["endQuest"] = "17707105649082065",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17685471940121351",
						["startPort"] = "Out",
						["endQuest"] = "17707106991251158215",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17649178318683135693",
						["startPort"] = "Out",
						["endQuest"] = "17707107244231158576",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1763371608095677863"] = {
						["key"] = "1763371608095677863",
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
					["1763371608095677866"] = {
						["key"] = "1763371608095677866",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1801.4171122994653,
							["y"] = 298.2352941176471
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763371608095677869"] = {
						["key"] = "1763371608095677869",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1801.8181818181818,
							["y"] = 494.572192513369
						},
						["propsData"] = {}
					},
					["17633720063122026718"] = {
						["key"] = "17633720063122026718",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1403.0880202958379,
							["y"] = 272.82120407971803
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12060401.12060401'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12030103",
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
					["17649178318683135693"] = {
						["key"] = "17649178318683135693",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1079.7272727272727,
							["y"] = 271.1590909090909
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 132010081,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203010301_132010081"
						}
					},
					["17667324358671066674"] = {
						["key"] = "17667324358671066674",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1401.7045454545455,
							["y"] = 5.181818181818173
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12060337,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17667324581391066968"] = {
						["key"] = "17667324581391066968",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 996.3636363636364,
							["y"] = 672.5454545454545
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12060338,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17667324635251067044"] = {
						["key"] = "17667324635251067044",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2005.090909090909,
							["y"] = 7.454545454545446
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12060339,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17685471932161318"] = {
						["key"] = "17685471932161318",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1081.335115864527,
							["y"] = 7.446969696969376
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132010122,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203010302_132010122"
						}
					},
					["17685471940121351"] = {
						["key"] = "17685471940121351",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1720.4260249554366,
							["y"] = 6.083333333333085
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132010123,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1203010303_132010123"
						}
					},
					["17685472933851107904"] = {
						["key"] = "17685472933851107904",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2286.5623885918003,
							["y"] = 5.17424242424209
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_1203010301_132010081"
						}
					},
					["17685473107871108266"] = {
						["key"] = "17685473107871108266",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1401.971479500891,
							["y"] = 469.7196969696966
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_1203010301_132010081"
						}
					},
					["17707104997401354"] = {
						["key"] = "17707104997401354",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1074.464530892448,
							["y"] = -187.93312164682803
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010129,
								132010130,
								132010131,
								132010132
							}
						}
					},
					["17707105649082065"] = {
						["key"] = "17707105649082065",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1412.9999999999998,
							["y"] = -188.96286993058106
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010133,
								132010134,
								132010135,
								132010136,
								132010137,
								132010138,
								132010139
							}
						}
					},
					["17707106991251158215"] = {
						["key"] = "17707106991251158215",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2013,
							["y"] = -209.83243514797235
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010140,
								132010141,
								132010142,
								132010176
							}
						}
					},
					["17707107244231158576"] = {
						["key"] = "17707107244231158576",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1409.7899491812534,
							["y"] = 659.6861983924005
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010129,
								132010130,
								132010131,
								132010132,
								132010133,
								132010134,
								132010135,
								132010136,
								132010137,
								132010138,
								132010139,
								132010140,
								132010141,
								132010142,
								132010176
							}
						}
					},
					["17726784143882454383"] = {
						["key"] = "17726784143882454383",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1407.1012641898863,
							["y"] = 810.8746130030961
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
		["1763371641119678238"] = {
			["isStoryNode"] = true,
			["key"] = "1763371641119678238",
			["type"] = "StoryNode",
			["name"] = "抓捕塔比瑟",
			["pos"] = {
				["x"] = 1124.1920771341906,
				["y"] = 567.8219461697723
			},
			["propsData"] = {
				["QuestId"] = 12030104,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120301_4",
				["QuestDeatil"] = "Content__120301_4",
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
				["SubRegionId"] = 104501,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_12030105Zhangyu_132010082",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1763371641119678239",
						["startPort"] = "QuestStart",
						["endQuest"] = "17667321788621707",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667321788621707",
						["startPort"] = "Out",
						["endQuest"] = "17633720946642028263",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17633720946642028263",
						["startPort"] = "Out",
						["endQuest"] = "176673904964720234128",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176673904964720234128",
						["startPort"] = "Out",
						["endQuest"] = "1763371641119678242",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1763371641119678239"] = {
						["key"] = "1763371641119678239",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1159.826086956522,
							["y"] = 290.6086956521739
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763371641119678242"] = {
						["key"] = "1763371641119678242",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2283.6521739130435,
							["y"] = 287.4285714285714
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763371641119678245"] = {
						["key"] = "1763371641119678245",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2281.316770186336,
							["y"] = 450.17391304347825
						},
						["propsData"] = {}
					},
					["17633720946642028263"] = {
						["key"] = "17633720946642028263",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1728.2917529330568,
							["y"] = 287.70997239475486
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250028,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030105WeiyanZhangyu_132010124",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12060501.12060501'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "TalkStageNew_12030103",
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
					["17633764178362028941"] = {
						["key"] = "17633764178362028941",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 1366.9206349206347,
							["y"] = 43.03450655624551
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = ""
						}
					},
					["17667321788621707"] = {
						["key"] = "17667321788621707",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成塔比瑟",
						["pos"] = {
							["x"] = 1443.4347826086955,
							["y"] = 288.9762443438916
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010124,
								132010176
							}
						}
					},
					["176673904964720234128"] = {
						["key"] = "176673904964720234128",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁·塔比瑟",
						["pos"] = {
							["x"] = 2002.358695652174,
							["y"] = 286.0869565217391
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010124,
								132010176
							}
						}
					},
					["17726784709283679907"] = {
						["key"] = "17726784709283679907",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 2012.1544117647059,
							["y"] = 490.72368421052636
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
		["1763371657647678540"] = {
			["isStoryNode"] = true,
			["key"] = "1763371657647678540",
			["type"] = "StoryNode",
			["name"] = "组队",
			["pos"] = {
				["x"] = 1404.7783883082575,
				["y"] = 568.6590691539346
			},
			["propsData"] = {
				["QuestId"] = 12030105,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120301_5",
				["QuestDeatil"] = "Content__120301_5",
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
				["SubRegionId"] = 104501,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_12030105Zhangyu_132010082",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17634560820291946",
						["startPort"] = "Out",
						["endQuest"] = "17649190015887318341",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763371657647678541",
						["startPort"] = "QuestStart",
						["endQuest"] = "17649189024656271843",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17649190015887318341",
						["startPort"] = "Out",
						["endQuest"] = "17696018321461308",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17696018321461308",
						["startPort"] = "Out",
						["endQuest"] = "1763371657647678544",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1763456202278679416",
						["startPort"] = "Out",
						["endQuest"] = "17634560820291946",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17649189024656271843",
						["startPort"] = "Out",
						["endQuest"] = "1763456202278679416",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763456202278679416",
						["startPort"] = "Out",
						["endQuest"] = "17724328055761198",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1763371657647678541"] = {
						["key"] = "1763371657647678541",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 429.1338127868298,
							["y"] = 272.1989468864469
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763371657647678544"] = {
						["key"] = "1763371657647678544",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2201.746843434343,
							["y"] = 293.7531565656566
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763371657647678547"] = {
						["key"] = "1763371657647678547",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1858.75,
							["y"] = 551.875
						},
						["propsData"] = {}
					},
					["17634560820291946"] = {
						["key"] = "17634560820291946",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1361.316653375864,
							["y"] = 272.0663780663781
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 250006,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12030105Zhangyu_132010082",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12060601,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East03_Fix06",
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
									["TalkActorId"] = 250003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 250006,
									["TalkActorVisible"] = true,
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
					["1763456202278679416"] = {
						["key"] = "1763456202278679416",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1041.2601766445287,
							["y"] = 276.33712357732173
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11228,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "BP_NewTargetPoint_1203010501",
							["IsUseCount"] = false
						}
					},
					["17649189024656271843"] = {
						["key"] = "17649189024656271843",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成塔比瑟",
						["pos"] = {
							["x"] = 715.1907547100182,
							["y"] = 270.6731146529958
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010082,
								132010176,
								132010177
							}
						}
					},
					["17649190015887318341"] = {
						["key"] = "17649190015887318341",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁塔比瑟",
						["pos"] = {
							["x"] = 1656.6711274018896,
							["y"] = 301.53599611857317
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								132010082,
								132010176,
								132010177
							}
						}
					},
					["17696018321461308"] = {
						["key"] = "17696018321461308",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1930.652221094935,
							["y"] = 281.1146108618854
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12060631,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17724328055761198"] = {
						["key"] = "17724328055761198",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1363.1503831417626,
							["y"] = 91.70517241379304
						},
						["propsData"] = {
							["NewDescription"] = "Description_120301_6",
							["NewDetail"] = "Content__120301_6",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17726784975724905349"] = {
						["key"] = "17726784975724905349",
						["type"] = "SetTimeOfDayNode",
						["name"] = "设置TOD",
						["pos"] = {
							["x"] = 1360.25,
							["y"] = 448.5
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
		}
	},
	["commentData"] = {}
}