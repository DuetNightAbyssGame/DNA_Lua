return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "176216014153110180",
			["startPort"] = "StoryStart",
			["endStory"] = "176216201638610772",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176216201638610772",
			["startPort"] = "Success",
			["endStory"] = "1762348911158549",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1762348911158549",
			["startPort"] = "Success",
			["endStory"] = "1762348910743527",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1762348910391513",
			["startPort"] = "Success",
			["endStory"] = "1762348909968499",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1762348909968499",
			["startPort"] = "Success",
			["endStory"] = "176216014153110183",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1762348910743527",
			["startPort"] = "Success",
			["endStory"] = "17640657853632062117",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17640657853632062117",
			["startPort"] = "Success",
			["endStory"] = "1762348910391513",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["176216014153110180"] = {
			["isStoryNode"] = true,
			["key"] = "176216014153110180",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 298
			},
			["propsData"] = {
				["QuestChainId"] = 200309
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176216014153110183"] = {
			["isStoryNode"] = true,
			["key"] = "176216014153110183",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1956.25,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176216201638610772"] = {
			["isStoryNode"] = true,
			["key"] = "176216201638610772",
			["type"] = "StoryNode",
			["name"] = "与尾生对话",
			["pos"] = {
				["x"] = 1220.0625,
				["y"] = 49
			},
			["propsData"] = {
				["QuestId"] = 20030901,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200309_1",
				["QuestDeatil"] = "Content_200309_1",
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
				["SubRegionId"] = 104104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_2050070",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17623491441573795",
						["startPort"] = "Out",
						["endQuest"] = "17623491676794079",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623491676794079",
						["startPort"] = "Out",
						["endQuest"] = "17631736032582006735",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17631736032582006735",
						["startPort"] = "Out",
						["endQuest"] = "176216201638610776",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176216201638610773",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623491441573795",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["176216201638610773"] = {
						["key"] = "176216201638610773",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 800,
							["y"] = 298
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176216201638610776"] = {
						["key"] = "176216201638610776",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2254.25,
							["y"] = 310.3
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176216201638610779"] = {
						["key"] = "176216201638610779",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1974.5,
							["y"] = 794
						},
						["propsData"] = {}
					},
					["17623491441573795"] = {
						["key"] = "17623491441573795",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成尾生",
						["pos"] = {
							["x"] = 1339.9499999999998,
							["y"] = 309.95000000000005
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050066
							}
						}
					},
					["17623491676794079"] = {
						["key"] = "17623491676794079",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1628.2,
							["y"] = 304.6
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701074,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_weisheng_2050066",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200309/20030901.20030901'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20030901",
							["BlendInTime"] = 1,
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
									["TalkActorId"] = 701074,
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
					["17623491758024344"] = {
						["key"] = "17623491758024344",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1376,
							["y"] = -266
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2050066,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_weisheng_2050066"
						}
					},
					["17624859562342964391"] = {
						["key"] = "17624859562342964391",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1091.5999999999997,
							["y"] = 635.0999999999999
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2050070,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_2050070"
						}
					},
					["17631736032582006735"] = {
						["key"] = "17631736032582006735",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁尾生",
						["pos"] = {
							["x"] = 1947.5,
							["y"] = 324
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050066
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1762348909968499"] = {
			["isStoryNode"] = true,
			["key"] = "1762348909968499",
			["type"] = "StoryNode",
			["name"] = "与尾生对话",
			["pos"] = {
				["x"] = 1617.5,
				["y"] = 283.25
			},
			["propsData"] = {
				["QuestId"] = 20030905,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200309_5",
				["QuestDeatil"] = "Content_200309_5",
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
				["SubRegionId"] = 104104,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_weisheng_2050066",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "176234958755811843",
						["startPort"] = "Out",
						["endQuest"] = "1762348909968505",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176234957790411587",
						["startPort"] = "Out",
						["endQuest"] = "176252042256017790904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176252042256017790904",
						["startPort"] = "Out",
						["endQuest"] = "176234958755811843",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762348909968504",
						["startPort"] = "QuestStart",
						["endQuest"] = "17631736595463009468",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17631736595463009468",
						["startPort"] = "Out",
						["endQuest"] = "176234957790411587",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1762348909968504"] = {
						["key"] = "1762348909968504",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 630,
							["y"] = 274
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1762348909968505"] = {
						["key"] = "1762348909968505",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2198,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1762348909968506"] = {
						["key"] = "1762348909968506",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["176234957790411587"] = {
						["key"] = "176234957790411587",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1276,
							["y"] = 298
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701074,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_weisheng_2050066",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200309/20030904.20030904'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20030901",
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
									["TalkActorId"] = 701074,
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
					["176234958755811843"] = {
						["key"] = "176234958755811843",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁尾生",
						["pos"] = {
							["x"] = 1928,
							["y"] = 302
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050066
							}
						}
					},
					["176234962069212541"] = {
						["key"] = "176234962069212541",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1576,
							["y"] = -162
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2050066,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_weisheng_2050066"
						}
					},
					["176252042256017790904"] = {
						["key"] = "176252042256017790904",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1652,
							["y"] = 290
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200309/20030905.20030905'",
							["TalkType"] = "Black",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = false,
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
					["17631736595463009468"] = {
						["key"] = "17631736595463009468",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成尾生",
						["pos"] = {
							["x"] = 954,
							["y"] = 310
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050066
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1762348910391513"] = {
			["isStoryNode"] = true,
			["key"] = "1762348910391513",
			["type"] = "StoryNode",
			["name"] = "与扶疏对话",
			["pos"] = {
				["x"] = 1617,
				["y"] = 86.1875
			},
			["propsData"] = {
				["QuestId"] = 20030904,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200309_4",
				["QuestDeatil"] = "Content_200309_4",
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
				["SubRegionId"] = 104106,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_fushu_2070168",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1762348910391518",
						["startPort"] = "QuestStart",
						["endQuest"] = "176234952065610388",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176234953587510626",
						["startPort"] = "Out",
						["endQuest"] = "176234954221310767",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176234954221310767",
						["startPort"] = "Out",
						["endQuest"] = "1762348910391519",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176234952065610388",
						["startPort"] = "Out",
						["endQuest"] = "176234953587510626",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1762348910391518"] = {
						["key"] = "1762348910391518",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 782,
							["y"] = 304
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1762348910391519"] = {
						["key"] = "1762348910391519",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2172,
							["y"] = 316
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1762348910391520"] = {
						["key"] = "1762348910391520",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["176234952065610388"] = {
						["key"] = "176234952065610388",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1218,
							["y"] = 314
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070168
							}
						}
					},
					["176234952950510512"] = {
						["key"] = "176234952950510512",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1540,
							["y"] = -56
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2070168,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_fushu_2070168"
						}
					},
					["176234953587510626"] = {
						["key"] = "176234953587510626",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1546.595238095238,
							["y"] = 299.26190476190476
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701075,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_fushu_2070168",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200309/20030903.20030903'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20030903",
							["BlendInTime"] = 1,
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
									["TalkActorId"] = 701075,
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
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
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
					["176234954221310767"] = {
						["key"] = "176234954221310767",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1846,
							["y"] = 314
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070168
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1762348910743527"] = {
			["isStoryNode"] = true,
			["key"] = "1762348910743527",
			["type"] = "StoryNode",
			["name"] = "推理游戏",
			["pos"] = {
				["x"] = 1228,
				["y"] = 454.2625
			},
			["propsData"] = {
				["QuestId"] = 20030903,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200309_3",
				["QuestDeatil"] = "Content_200309_3",
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
				["SubRegionId"] = 104106,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Targetpoint_20030903",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1762348910743532",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623493736937267",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623493736937267",
						["startPort"] = "Out",
						["endQuest"] = "17625835299954614",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17625835299954614",
						["startPort"] = "Out",
						["endQuest"] = "17623493806837444",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17625835607735106",
						["startPort"] = "Out",
						["endQuest"] = "17625835787695463",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17625835607735106",
						["startPort"] = "Out",
						["endQuest"] = "17623494146958223",
						["endPort"] = "Branch_1"
					},
					{
						["startQuest"] = "17625836059676212",
						["startPort"] = "Out",
						["endQuest"] = "17625836059676213",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17625836059676212",
						["startPort"] = "Out",
						["endQuest"] = "17623494146958223",
						["endPort"] = "Branch_2"
					},
					{
						["startQuest"] = "17625836327126980",
						["startPort"] = "Out",
						["endQuest"] = "17625836327126981",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17625836327126980",
						["startPort"] = "Out",
						["endQuest"] = "17623494146958223",
						["endPort"] = "Branch_3"
					},
					{
						["startQuest"] = "17625907387341326235",
						["startPort"] = "Out",
						["endQuest"] = "17625835607735106",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17623494020097901",
						["startPort"] = "Out",
						["endQuest"] = "17625907387341326235",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623494049647994",
						["startPort"] = "Out",
						["endQuest"] = "17625907525341326521",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17625907525341326521",
						["startPort"] = "Out",
						["endQuest"] = "17625836059676212",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17623494045647987",
						["startPort"] = "Out",
						["endQuest"] = "17625907964461327515",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17625907964461327515",
						["startPort"] = "Out",
						["endQuest"] = "17625836327126980",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17640616880171924",
						["startPort"] = "Out",
						["endQuest"] = "17640616717051577",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17640527398113589",
						["startPort"] = "Out",
						["endQuest"] = "1762348910743533",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17623494146958223",
						["startPort"] = "Out",
						["endQuest"] = "17640527398113589",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17640798064326179884",
						["startPort"] = "Out",
						["endQuest"] = "17623493876897596",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623493806837444",
						["startPort"] = "Out",
						["endQuest"] = "17640798059756179879",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17640798059756179879",
						["startPort"] = "Out",
						["endQuest"] = "17623493905647672",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623493806837444",
						["startPort"] = "Out",
						["endQuest"] = "17624842965482962850",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17624842965482962850",
						["startPort"] = "Out",
						["endQuest"] = "17623493909317677",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623493905647672",
						["startPort"] = "Out",
						["endQuest"] = "17640799478886182336",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17640799478886182336",
						["startPort"] = "Out",
						["endQuest"] = "17623494020097901",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623493876897596",
						["startPort"] = "Out",
						["endQuest"] = "17640799663846182653",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17640799663846182653",
						["startPort"] = "Out",
						["endQuest"] = "17623494049647994",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623493909317677",
						["startPort"] = "Out",
						["endQuest"] = "17640800011766183396",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17640800011766183396",
						["startPort"] = "Out",
						["endQuest"] = "17623494045647987",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623493806837444",
						["startPort"] = "Out",
						["endQuest"] = "17640798064326179884",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1762348910743532"] = {
						["key"] = "1762348910743532",
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
					["1762348910743533"] = {
						["key"] = "1762348910743533",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3567.157894736842,
							["y"] = 255.3684210526316
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1762348910743534"] = {
						["key"] = "1762348910743534",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4280,
							["y"] = 554
						},
						["propsData"] = {}
					},
					["17623493736937267"] = {
						["key"] = "17623493736937267",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1111.7894736842104,
							["y"] = 179.1578947368421
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070177,
								2070178,
								2070179
							}
						}
					},
					["17623493806837444"] = {
						["key"] = "17623493806837444",
						["type"] = "BranchQuestStartNode",
						["name"] = "子任务开始节点",
						["pos"] = {
							["x"] = 1578.7445820433436,
							["y"] = 183.5735294117647
						},
						["propsData"] = {
							["AllQuestOptions"] = {
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "",
									["TargetBranchQuestKey"] = ""
								},
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "",
									["TargetBranchQuestKey"] = ""
								},
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "",
									["TargetBranchQuestKey"] = ""
								}
							},
							["IsSetCountInfo"] = true,
							["IsDifftation"] = false,
							["AllDiffGuideOptions"] = {
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "17624842965482962850",
											["IsShowOptional"] = false
										}
									}
								},
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "17640798064326179884",
											["IsShowOptional"] = false
										}
									}
								},
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "17640798059756179879",
											["IsShowOptional"] = false
										}
									}
								}
							}
						}
					},
					["17623493876897596"] = {
						["key"] = "17623493876897596",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 2073.176470588235,
							["y"] = 209.76470588235293
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11071,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17623493905647672"] = {
						["key"] = "17623493905647672",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1954.8161764705883,
							["y"] = -390.4264705882353
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11070,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17623493909317677"] = {
						["key"] = "17623493909317677",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1959.6048761609907,
							["y"] = 854.8769349845202
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11072,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17623494020097901"] = {
						["key"] = "17623494020097901",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2195.6470588235297,
							["y"] = -398.11764705882354
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51160001,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17623494045647987"] = {
						["key"] = "17623494045647987",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2234.1838235294117,
							["y"] = 863.1691176470588
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51160003,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17623494049647994"] = {
						["key"] = "17623494049647994",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2308.678733031674,
							["y"] = 220.03619909502262
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51160002,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17623494146958223"] = {
						["key"] = "17623494146958223",
						["type"] = "CheckBranchQuestFinishedNode",
						["name"] = "子任务结束节点",
						["pos"] = {
							["x"] = 2996,
							["y"] = 244
						},
						["propsData"] = {
							["InputBranchQuestNumber"] = 3,
							["BranchQuestFinishOptions"] = {
								{
									["IsNeedFinish"] = true
								},
								{
									["IsNeedFinish"] = true
								},
								{
									["IsNeedFinish"] = true
								}
							}
						}
					},
					["17624842965482962850"] = {
						["key"] = "17624842965482962850",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1740.8764705882356,
							["y"] = 848.1911764705883
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Targetpoint_20030910"
						}
					},
					["17624843223672963496"] = {
						["key"] = "17624843223672963496",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 3701.040909090909,
							["y"] = 675.6949760765551
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Targetpoint_20030903"
						}
					},
					["17625835299954614"] = {
						["key"] = "17625835299954614",
						["type"] = "UnlockDetectiveQuestionNode",
						["name"] = "开启推理问题",
						["pos"] = {
							["x"] = 1343.7972136222909,
							["y"] = 182.78947368421075
						},
						["propsData"] = {
							["QuestionIds"] = {
								2004
							},
							["OpenToast"] = true
						}
					},
					["17625835607735106"] = {
						["key"] = "17625835607735106",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索",
						["pos"] = {
							["x"] = 2688.1315789473683,
							["y"] = -385.7368421052629
						},
						["propsData"] = {
							["AnswerIds"] = {
								200401
							}
						}
					},
					["17625835787695463"] = {
						["key"] = "17625835787695463",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 2994.0263157894733,
							["y"] = -434.99999999999966
						},
						["propsData"] = {
							["AnswerId"] = 200401,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["17625836059676212"] = {
						["key"] = "17625836059676212",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索",
						["pos"] = {
							["x"] = 2746.289473684211,
							["y"] = 243.8111455108363
						},
						["propsData"] = {
							["AnswerIds"] = {
								200402
							}
						}
					},
					["17625836059676213"] = {
						["key"] = "17625836059676213",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 2734.5615325077392,
							["y"] = 466.84326625387047
						},
						["propsData"] = {
							["AnswerId"] = 200402,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["17625836327126980"] = {
						["key"] = "17625836327126980",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索",
						["pos"] = {
							["x"] = 2709.4671052631575,
							["y"] = 877.6578947368425
						},
						["propsData"] = {
							["AnswerIds"] = {
								200403
							}
						}
					},
					["17625836327126981"] = {
						["key"] = "17625836327126981",
						["type"] = "OpenDetectiveAnswerUINode",
						["name"] = "开启推理获得新线索提示UI",
						["pos"] = {
							["x"] = 3046.342105263157,
							["y"] = 1071.1578947368425
						},
						["propsData"] = {
							["AnswerId"] = 200403,
							["AutoOpenDetectiveGameUI"] = false
						}
					},
					["17625907387341326235"] = {
						["key"] = "17625907387341326235",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2446.6666666666665,
							["y"] = -400.0980392156863
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51160004,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17625907525341326521"] = {
						["key"] = "17625907525341326521",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2535.6470588235293,
							["y"] = 226.70588235294122
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51160005,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17625907964461327515"] = {
						["key"] = "17625907964461327515",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2477.308823529412,
							["y"] = 865.3848039215687
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51160006,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17640527398113589"] = {
						["key"] = "17640527398113589",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3246.842105263158,
							["y"] = 258.00000000000006
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070177,
								2070178,
								2070179
							}
						}
					},
					["17640616717051577"] = {
						["key"] = "17640616717051577",
						["type"] = "HasDetectiveResultNode",
						["name"] = "检测是否获取过推理结果",
						["pos"] = {
							["x"] = 4014,
							["y"] = 524
						},
						["propsData"] = {
							["ResultIds"] = {
								20040101
							}
						}
					},
					["17640616880171924"] = {
						["key"] = "17640616880171924",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3692,
							["y"] = 522
						},
						["propsData"] = {
							["NewDescription"] = "Description_200309_6",
							["NewDetail"] = "Content_200309_6",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17640798059756179879"] = {
						["key"] = "17640798059756179879",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1720.191950464396,
							["y"] = -398.9647832817327
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_20030908"
						}
					},
					["17640798064326179884"] = {
						["key"] = "17640798064326179884",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1847.2507739938078,
							["y"] = 197.88080495356138
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_20030909"
						}
					},
					["17640799478886182336"] = {
						["key"] = "17640799478886182336",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2099.603715170278,
							["y"] = -188.86996904024596
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_20030908"
						}
					},
					["17640799663846182653"] = {
						["key"] = "17640799663846182653",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2187.8390092879254,
							["y"] = 444.67492260062045
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_20030909"
						}
					},
					["17640800011766183396"] = {
						["key"] = "17640800011766183396",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2107.0697785186953,
							["y"] = 1070.5572755417966
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Targetpoint_20030910"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1762348911158549"] = {
			["isStoryNode"] = true,
			["key"] = "1762348911158549",
			["type"] = "StoryNode",
			["name"] = "与扶疏对话",
			["pos"] = {
				["x"] = 1233.5,
				["y"] = 244.75
			},
			["propsData"] = {
				["QuestId"] = 20030902,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200309_2",
				["QuestDeatil"] = "Content_200309_2",
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
				["SubRegionId"] = 104106,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Fushu_2070165",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17623492485815832",
						["startPort"] = "Out",
						["endQuest"] = "17623492890676399",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623492890676399",
						["startPort"] = "Out",
						["endQuest"] = "1762348911158555",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1762348911158554",
						["startPort"] = "QuestStart",
						["endQuest"] = "17624815815761714",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17624815815761714",
						["startPort"] = "Out",
						["endQuest"] = "17623492235295510",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623492235295510",
						["startPort"] = "Out",
						["endQuest"] = "17623492485815832",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1762348911158554"] = {
						["key"] = "1762348911158554",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 814,
							["y"] = 318
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1762348911158555"] = {
						["key"] = "1762348911158555",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2348,
							["y"] = 316
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1762348911158556"] = {
						["key"] = "1762348911158556",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17623492235295510"] = {
						["key"] = "17623492235295510",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1472,
							["y"] = 298
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2070196,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_2070196"
						}
					},
					["17623492485815832"] = {
						["key"] = "17623492485815832",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1754.75,
							["y"] = 311.25
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200309/20030902.20030902'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20030902",
							["BlendInTime"] = 1,
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
									["TalkActorId"] = 701075,
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
					["17623492890676399"] = {
						["key"] = "17623492890676399",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2003.25,
							["y"] = 322
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070165
							}
						}
					},
					["17624815815761714"] = {
						["key"] = "17624815815761714",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成扶疏",
						["pos"] = {
							["x"] = 1114,
							["y"] = 316
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070165
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17640657853632062117"] = {
			["isStoryNode"] = true,
			["key"] = "17640657853632062117",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1235,
				["y"] = 676.076923076923
			},
			["propsData"] = {
				["QuestId"] = 20030906,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200309_6",
				["QuestDeatil"] = "Content_200309_6",
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
				["SubRegionId"] = 104106,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Targetpoint_20030903",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17640657853632062118",
						["startPort"] = "QuestStart",
						["endQuest"] = "17640658435472063222",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17640658435472063222",
						["startPort"] = "Out",
						["endQuest"] = "17640657853632062121",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17640657853632062118"] = {
						["key"] = "17640657853632062118",
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
					["17640657853632062121"] = {
						["key"] = "17640657853632062121",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1494,
							["y"] = 314
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17640657853632062124"] = {
						["key"] = "17640657853632062124",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17640658435472063222"] = {
						["key"] = "17640658435472063222",
						["type"] = "HasDetectiveResultNode",
						["name"] = "检测是否获取过推理结果",
						["pos"] = {
							["x"] = 1162,
							["y"] = 298
						},
						["propsData"] = {
							["ResultIds"] = {
								20040101
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