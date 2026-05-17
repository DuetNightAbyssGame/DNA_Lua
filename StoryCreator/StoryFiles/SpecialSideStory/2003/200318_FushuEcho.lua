return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17702778835501",
			["startPort"] = "StoryStart",
			["endStory"] = "1770278081211383643",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770279360195395037",
			["startPort"] = "Success",
			["endStory"] = "1770281467597397393",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770281467597397393",
			["startPort"] = "Success",
			["endStory"] = "1770282184913398056",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770282184913398056",
			["startPort"] = "Success",
			["endStory"] = "1770282194593398357",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770282194593398357",
			["startPort"] = "Success",
			["endStory"] = "17702778835515",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1770278081211383643",
			["startPort"] = "Success",
			["endStory"] = "1770278590773387494",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1770278590773387494",
			["startPort"] = "Success",
			["endStory"] = "1770279360195395037",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17702778835501"] = {
			["isStoryNode"] = true,
			["key"] = "17702778835501",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 779.4736842105264,
				["y"] = 301.57894736842104
			},
			["propsData"] = {
				["QuestChainId"] = 200318
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17702778835515"] = {
			["isStoryNode"] = true,
			["key"] = "17702778835515",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2095.436318067897,
				["y"] = 522.6885395306446
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1770278081211383643"] = {
			["isStoryNode"] = true,
			["key"] = "1770278081211383643",
			["type"] = "StoryNode",
			["name"] = "回忆",
			["pos"] = {
				["x"] = 1090.3157894736842,
				["y"] = 287.3508771929824
			},
			["propsData"] = {
				["QuestId"] = 20031801,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031801",
				["QuestDeatil"] = "Content_20031801",
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
				["StoryGuidePointName"] = "Mechanism_TriggerBox01_232010266",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770278081211383644",
						["startPort"] = "QuestStart",
						["endQuest"] = "1770278554756386774",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770278554756386774",
						["startPort"] = "Out",
						["endQuest"] = "1770278557956386838",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726066180633637091",
						["startPort"] = "Out",
						["endQuest"] = "17726066180633637092",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770278557956386838",
						["startPort"] = "Out",
						["endQuest"] = "17726066180633637091",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726066180633637092",
						["startPort"] = "Out",
						["endQuest"] = "1770278081211383647",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1770278081211383644"] = {
						["key"] = "1770278081211383644",
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
					["1770278081211383647"] = {
						["key"] = "1770278081211383647",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2434,
							["y"] = 284
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770278081211383650"] = {
						["key"] = "1770278081211383650",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2324,
							["y"] = 624
						},
						["propsData"] = {}
					},
					["1770278554756386774"] = {
						["key"] = "1770278554756386774",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1099.5,
							["y"] = 295.75
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010266,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox01_232010266"
						}
					},
					["1770278557956386838"] = {
						["key"] = "1770278557956386838",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1402,
							["y"] = 291.25
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180101.2003180101'",
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
					["17726066180633637091"] = {
						["key"] = "17726066180633637091",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1717.5,
							["y"] = 293.5
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "StartPoint_200318fushu1",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["17726066180633637092"] = {
						["key"] = "17726066180633637092",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2039.842105263158,
							["y"] = 292.4736842105263
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180102.2003180102'",
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
					}
				},
				["commentData"] = {}
			}
		},
		["1770278125263384569"] = {
			["isStoryNode"] = true,
			["key"] = "1770278125263384569",
			["type"] = "StoryNode",
			["name"] = "开场",
			["pos"] = {
				["x"] = 1436.7916666666672,
				["y"] = 40.125
			},
			["propsData"] = {
				["QuestId"] = 20031802,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031802",
				["QuestDeatil"] = "Content_20031802",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {
					["1770278125263384574"] = {
						["key"] = "1770278125263384574",
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
					["1770278125263384575"] = {
						["key"] = "1770278125263384575",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1920,
							["y"] = 298
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770278125263384576"] = {
						["key"] = "1770278125263384576",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["1770278590773387494"] = {
			["isStoryNode"] = true,
			["key"] = "1770278590773387494",
			["type"] = "StoryNode",
			["name"] = "救不救",
			["pos"] = {
				["x"] = 1451.4009170653906,
				["y"] = 287.09469696969694
			},
			["propsData"] = {
				["QuestId"] = 20031803,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031803",
				["QuestDeatil"] = "Content_20031803",
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
				["SubRegionIdList"] = {
					104503
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_TriggerBox02_232010267",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770278685719387942",
						["startPort"] = "Out",
						["endQuest"] = "1770278690063388070",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770279044511390701",
						["startPort"] = "Out",
						["endQuest"] = "1770279063303391139",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773055956712418711",
						["startPort"] = "true",
						["endQuest"] = "1773055956712418710",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770278590773387495",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773055956712418711",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773055956712418711",
						["startPort"] = "false",
						["endQuest"] = "17726780176893640304",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726780176893640304",
						["startPort"] = "Out",
						["endQuest"] = "1770278685719387942",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773055956712418710",
						["startPort"] = "Out",
						["endQuest"] = "1770278685719387942",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770278685719387942",
						["startPort"] = "Out",
						["endQuest"] = "1770278699048388321",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770278699048388321",
						["startPort"] = "Out",
						["endQuest"] = "1773056041444420700",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773057076216426455",
						["startPort"] = "Out",
						["endQuest"] = "1773057076216426454",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773057076216426454",
						["startPort"] = "Out",
						["endQuest"] = "1773058139327430806",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773058139327430806",
						["startPort"] = "Out",
						["endQuest"] = "1770278590773387498",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1770278966032389765",
						["startPort"] = "Option_2",
						["endQuest"] = "1773058196525431609",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773058196525431609",
						["startPort"] = "Out",
						["endQuest"] = "1770279038342390537",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770279038342390537",
						["startPort"] = "Out",
						["endQuest"] = "1770279070734391456",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770279138866392190",
						["startPort"] = "Out",
						["endQuest"] = "17731244610328425121",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17731244610328425121",
						["startPort"] = "Out",
						["endQuest"] = "1773057076216426455",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770278966032389765",
						["startPort"] = "Option_1",
						["endQuest"] = "1770279138866392190",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773056041444420700",
						["startPort"] = "Out",
						["endQuest"] = "1770278966032389765",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770279070734391456",
						["startPort"] = "Out",
						["endQuest"] = "1770279138866392190",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773055956712418710",
						["startPort"] = "Out",
						["endQuest"] = "177312826647321092309",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17731244610328425121",
						["startPort"] = "Out",
						["endQuest"] = "177312829053121092686",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1770278590773387495"] = {
						["key"] = "1770278590773387495",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 419.2672858617131,
							["y"] = 612.7162022703818
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770278590773387498"] = {
						["key"] = "1770278590773387498",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4217.728399051928,
							["y"] = 766.2942069540367
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770278590773387501"] = {
						["key"] = "1770278590773387501",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4508.399321266968,
							["y"] = 955.8338720103427
						},
						["propsData"] = {}
					},
					["1770278685719387942"] = {
						["key"] = "1770278685719387942",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1302.8848449996872,
							["y"] = 623.5812324929973
						},
						["propsData"] = {
							["QuestRoleId"] = 24010101,
							["IsPlayFX"] = false
						}
					},
					["1770278690063388070"] = {
						["key"] = "1770278690063388070",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效 子弹跳",
						["pos"] = {
							["x"] = 1612.520157860715,
							["y"] = 435.5259372979961
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"BulletJump"
							}
						}
					},
					["1770278699048388321"] = {
						["key"] = "1770278699048388321",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1607.049935358759,
							["y"] = 623.6922807584572
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								232010265
							}
						}
					},
					["1770278869081388476"] = {
						["key"] = "1770278869081388476",
						["type"] = "SendMessageNode",
						["name"] = "发送消息-Env",
						["pos"] = {
							["x"] = 1498.3461538461538,
							["y"] = -526.6538461538462
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = -1,
							["UnitId"] = -1
						}
					},
					["1770278884067388966"] = {
						["key"] = "1770278884067388966",
						["type"] = "SendMessageNode",
						["name"] = "发送消息-氛围NPC",
						["pos"] = {
							["x"] = 1498.7171024280156,
							["y"] = -370.3405516052576
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = -1,
							["UnitId"] = -1
						}
					},
					["1770278966032389765"] = {
						["key"] = "1770278966032389765",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1910.6328688014546,
							["y"] = 758.9024123731518
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180301.2003180301'",
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
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["BranchOptions"] = {
								"jiu",
								"bujiu"
							},
							["OverrideFailBlend"] = false
						}
					},
					["1770279005519390001"] = {
						["key"] = "1770279005519390001",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 2515.5834897592204,
							["y"] = 329.9012946491742
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1770279038342390537"] = {
						["key"] = "1770279038342390537",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2494.4895865228686,
							["y"] = 992.4356195919661
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010269,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox04_232010269"
						}
					},
					["1770279044511390701"] = {
						["key"] = "1770279044511390701",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2435.0957895303864,
							["y"] = 1193.5963338776805
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = ""
						}
					},
					["1770279063303391139"] = {
						["key"] = "1770279063303391139",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2727.9905263724927,
							["y"] = 1168.1828000430937
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010268,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox03_232010268"
						}
					},
					["1770279070734391456"] = {
						["key"] = "1770279070734391456",
						["type"] = "TalkNode",
						["name"] = "对话",
						["pos"] = {
							["x"] = 2825.747418603068,
							["y"] = 994.6239027999861
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180302.2003180302'",
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
					["1770279138866392190"] = {
						["key"] = "1770279138866392190",
						["type"] = "TalkNode",
						["name"] = "对话",
						["pos"] = {
							["x"] = 3109.899839296748,
							["y"] = 767.9602367614883
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180303.2003180303'",
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
					["17726780176893640304"] = {
						["key"] = "17726780176893640304",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 984.9564295353765,
							["y"] = 790.4125698862541
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010267,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox02_232010267"
						}
					},
					["17726780281113640598"] = {
						["key"] = "17726780281113640598",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1327.854925775978,
							["y"] = 1092.671968382495
						},
						["propsData"] = {
							["SpecialConfigId"] = 0,
							["BlackScreenImmediately"] = false
						}
					},
					["1773055956712418710"] = {
						["key"] = "1773055956712418710",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 994.3197269275443,
							["y"] = 612.6913238979805
						},
						["propsData"] = {
							["VarName"] = "WangchuanFushu01",
							["VarValue"] = 1
						}
					},
					["1773055956712418711"] = {
						["key"] = "1773055956712418711",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量判断",
						["pos"] = {
							["x"] = 706.8347032655859,
							["y"] = 614.7417440660474
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "WangchuanFushu01",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["1773056041444420700"] = {
						["key"] = "1773056041444420700",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1617.314038773404,
							["y"] = 812.5557828394515
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010268,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox03_232010268"
						}
					},
					["1773056062251421285"] = {
						["key"] = "1773056062251421285",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1666.6907894736842,
							["y"] = 1097.1776315789473
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
					["1773057076216426454"] = {
						["key"] = "1773057076216426454",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3858.6824672761436,
							["y"] = 760.4136599984123
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010270,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox05_232010270"
						}
					},
					["1773057076216426455"] = {
						["key"] = "1773057076216426455",
						["type"] = "SimplePostProcessNode",
						["name"] = "开启关闭屏幕后处理",
						["pos"] = {
							["x"] = 3531.636506786685,
							["y"] = 762.2131913494143
						},
						["propsData"] = {
							["bEnablePP"] = true,
							["PPEnum"] = 0
						}
					},
					["1773058139327430806"] = {
						["key"] = "1773058139327430806",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3866.838216865692,
							["y"] = 986.1032119325461
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010278,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox05_232010278"
						}
					},
					["1773058196525431609"] = {
						["key"] = "1773058196525431609",
						["type"] = "PlayerSwitchWalkRunNode",
						["name"] = "玩家走跑切换",
						["pos"] = {
							["x"] = 2215.6719003390826,
							["y"] = 1002.3736731534724
						},
						["propsData"] = {
							["Rate"] = 0.25,
							["Mode"] = "EWT_Normal"
						}
					},
					["17731244610328425121"] = {
						["key"] = "17731244610328425121",
						["type"] = "PlayerSwitchWalkRunNode",
						["name"] = "玩家走跑切换",
						["pos"] = {
							["x"] = 3331.7673277444933,
							["y"] = 984.5247360998144
						},
						["propsData"] = {
							["Rate"] = 1,
							["Mode"] = "ToRun"
						}
					},
					["177312826647321092309"] = {
						["key"] = "177312826647321092309",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1300.9721884634841,
							["y"] = 250.3489629599106
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PPBlinkLoop",
							["UnitId"] = -1
						}
					},
					["177312829053121092686"] = {
						["key"] = "177312829053121092686",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 3716.9245694158653,
							["y"] = 1255.605373216321
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PPBlinkEnd",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1770279167802392939"] = {
			["isStoryNode"] = true,
			["key"] = "1770279167802392939",
			["type"] = "StoryNode",
			["name"] = "移动",
			["pos"] = {
				["x"] = 1796.306818181818,
				["y"] = 98.88576555023917
			},
			["propsData"] = {
				["QuestId"] = 20031804,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031804",
				["QuestDeatil"] = "Content_20031804",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {
					["1770279167802392940"] = {
						["key"] = "1770279167802392940",
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
					["1770279167802392943"] = {
						["key"] = "1770279167802392943",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2174,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770279167802392946"] = {
						["key"] = "1770279167802392946",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["1770279360195395037"] = {
			["isStoryNode"] = true,
			["key"] = "1770279360195395037",
			["type"] = "StoryNode",
			["name"] = "泽生阁",
			["pos"] = {
				["x"] = 1809.3979551150603,
				["y"] = 283.482826384142
			},
			["propsData"] = {
				["QuestId"] = 20031805,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031805",
				["QuestDeatil"] = "Content_20031805",
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
				["StoryGuidePointName"] = "Mechanism_TriggerBox02_232010267",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770281420364396221",
						["startPort"] = "Out",
						["endQuest"] = "1770281427083396372",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770281440102396712",
						["startPort"] = "Out",
						["endQuest"] = "1770279360195395041",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1770282272222399695",
						["startPort"] = "Out",
						["endQuest"] = "1770282272222399696",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770279360195395038",
						["startPort"] = "QuestStart",
						["endQuest"] = "1770281420364396221",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282272222399695",
						["startPort"] = "Out",
						["endQuest"] = "1770281438499396632",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770281427083396372",
						["startPort"] = "Out",
						["endQuest"] = "1770281440102396712",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177312731155418557723",
						["startPort"] = "true",
						["endQuest"] = "177312731155418557722",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1770279360195395038"] = {
						["key"] = "1770279360195395038",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 416.3157894736842,
							["y"] = 343.36842105263156
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770279360195395041"] = {
						["key"] = "1770279360195395041",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1690.9473684210527,
							["y"] = 350.9473684210526
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770279360195395044"] = {
						["key"] = "1770279360195395044",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1770281420364396221"] = {
						["key"] = "1770281420364396221",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 749.2105263157895,
							["y"] = 343
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "StartPoint_200318fushu3",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["1770281427083396372"] = {
						["key"] = "1770281427083396372",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1057.5,
							["y"] = 338.5
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180501.2003180501'",
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
					["1770281434560396538"] = {
						["key"] = "1770281434560396538",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 743.1578947368421,
							["y"] = -290.65789473684214
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "StartPoint_200318fushu3",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["1770281438499396632"] = {
						["key"] = "1770281438499396632",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1317.7894736842106,
							["y"] = 55.28947368421054
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010275,
							["GuideType"] = "M",
							["GuidePointName"] = "Npc_Gezhu_232010264"
						}
					},
					["1770281440102396712"] = {
						["key"] = "1770281440102396712",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1378.8947368421054,
							["y"] = 341.8157894736842
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180502.2003180502'",
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
					["1770282272222399695"] = {
						["key"] = "1770282272222399695",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1010.4352276178424,
							["y"] = 84.27935222672063
						},
						["propsData"] = {
							["QuestRoleId"] = 24010101,
							["IsPlayFX"] = false
						}
					},
					["1770282272222399696"] = {
						["key"] = "1770282272222399696",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效 子弹跳",
						["pos"] = {
							["x"] = 1355.880561855842,
							["y"] = -125.3846153846154
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"BulletJump"
							}
						}
					},
					["177312731155418557722"] = {
						["key"] = "177312731155418557722",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 738.8471299940342,
							["y"] = 89.23291685095097
						},
						["propsData"] = {
							["VarName"] = "WangchuanFushu02",
							["VarValue"] = 1
						}
					},
					["177312731155418557723"] = {
						["key"] = "177312731155418557723",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量判断",
						["pos"] = {
							["x"] = 451.36210633207577,
							["y"] = 91.28333701901789
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "WangchuanFushu02",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1770281467597397393"] = {
			["isStoryNode"] = true,
			["key"] = "1770281467597397393",
			["type"] = "StoryNode",
			["name"] = "移动",
			["pos"] = {
				["x"] = 1092.474054454318,
				["y"] = 526.5618876737299
			},
			["propsData"] = {
				["QuestId"] = 20031806,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031806",
				["QuestDeatil"] = "Content_20031806",
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
				["StoryGuidePointName"] = "Mechanism_TriggerBox05_232010278",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770282442797401291",
						["startPort"] = "BeginOverlap",
						["endQuest"] = "1770282442797401290",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282442797401290",
						["startPort"] = "Out",
						["endQuest"] = "1770282442797401292",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282442797401292",
						["startPort"] = "Out",
						["endQuest"] = "1770282442797401291",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1770282442797401291",
						["startPort"] = "EndOverlap",
						["endQuest"] = "1770282442797401293",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282442797401293",
						["startPort"] = "Out",
						["endQuest"] = "1770282442797401294",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282442797401294",
						["startPort"] = "Out",
						["endQuest"] = "1770282442797401291",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1770282456077401635",
						["startPort"] = "Out",
						["endQuest"] = "1770282456077401636",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282456077401636",
						["startPort"] = "Out",
						["endQuest"] = "1770282456077401637",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282456077401636",
						["startPort"] = "Out",
						["endQuest"] = "1770282452037401559",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282452037401559",
						["startPort"] = "Out",
						["endQuest"] = "1770281467597397397",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1770283236227409249",
						["startPort"] = "Out",
						["endQuest"] = "1770283236227409250",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059078538436853",
						["startPort"] = "true",
						["endQuest"] = "1773059078538436852",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059078538436853",
						["startPort"] = "false",
						["endQuest"] = "1773059078538436851",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770281467597397394",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773059078538436853",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059078538436851",
						["startPort"] = "Out",
						["endQuest"] = "1770283236227409247",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059078538436852",
						["startPort"] = "Out",
						["endQuest"] = "1770283236227409247",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770283236227409247",
						["startPort"] = "Out",
						["endQuest"] = "1773059144537438626",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059144537438626",
						["startPort"] = "Out",
						["endQuest"] = "1770283314412411681",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770283314412411681",
						["startPort"] = "Out",
						["endQuest"] = "1770283236227409249",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770283236227409249",
						["startPort"] = "Out",
						["endQuest"] = "1770282456077401635",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770283236227409249",
						["startPort"] = "Out",
						["endQuest"] = "1770282442797401291",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["1770281467597397394"] = {
						["key"] = "1770281467597397394",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -494.8571428571429,
							["y"] = 11.214285714285712
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770281467597397397"] = {
						["key"] = "1770281467597397397",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2470.842105263158,
							["y"] = 13.34412955465589
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104301,
							["StartIndex"] = 1,
							["LoadingId"] = 101001,
							["IsWhite"] = false
						}
					},
					["1770281467597397400"] = {
						["key"] = "1770281467597397400",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2475.9514170040484,
							["y"] = 609.3927125506073
						},
						["propsData"] = {}
					},
					["1770282262011399291"] = {
						["key"] = "1770282262011399291",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 908.8609022556392,
							["y"] = 639.8947368421052
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010271,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox06_232010271"
						}
					},
					["1770282442797401290"] = {
						["key"] = "1770282442797401290",
						["type"] = "SimplePostProcessNode",
						["name"] = "开启关闭屏幕后处理",
						["pos"] = {
							["x"] = 1669.8357390130857,
							["y"] = 276.02732978376446
						},
						["propsData"] = {
							["bEnablePP"] = true,
							["PPEnum"] = 8
						}
					},
					["1770282442797401291"] = {
						["key"] = "1770282442797401291",
						["type"] = "CollisionBoxNode",
						["name"] = "进入/离开判定盒节点",
						["pos"] = {
							["x"] = 1371.485683271724,
							["y"] = 289.7578936516284
						},
						["propsData"] = {
							["StaticCreatorId"] = 232010271
						}
					},
					["1770282442797401292"] = {
						["key"] = "1770282442797401292",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1970.9226955348238,
							["y"] = 282.13247559142746
						},
						["propsData"] = {
							["WaitTime"] = 0.2
						}
					},
					["1770282442797401293"] = {
						["key"] = "1770282442797401293",
						["type"] = "SimplePostProcessNode",
						["name"] = "开启关闭屏幕后处理",
						["pos"] = {
							["x"] = 1664.3967801708266,
							["y"] = 515.2650158726306
						},
						["propsData"] = {
							["bEnablePP"] = false,
							["PPEnum"] = 8
						}
					},
					["1770282442797401294"] = {
						["key"] = "1770282442797401294",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1977.6197751747188,
							["y"] = 488.0686040307046
						},
						["propsData"] = {
							["WaitTime"] = 0.2
						}
					},
					["1770282452037401559"] = {
						["key"] = "1770282452037401559",
						["type"] = "SimplePostProcessNode",
						["name"] = "确保关闭屏幕后处理",
						["pos"] = {
							["x"] = 2062.8178137651817,
							["y"] = 4.47773279352225
						},
						["propsData"] = {
							["bEnablePP"] = false,
							["PPEnum"] = 8
						}
					},
					["1770282456077401635"] = {
						["key"] = "1770282456077401635",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成掉落物",
						["pos"] = {
							["x"] = 1383.578903513927,
							["y"] = -5.777373700355902
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								232010276
							}
						}
					},
					["1770282456077401636"] = {
						["key"] = "1770282456077401636",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1702.9861633077953,
							["y"] = 4.122678904417915
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11077,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Drop_Wangxi_232010276",
							["IsUseCount"] = false
						}
					},
					["1770282456077401637"] = {
						["key"] = "1770282456077401637",
						["type"] = "PlayNormalSoundNode",
						["name"] = "播放普通音效",
						["pos"] = {
							["x"] = 2040.9690047181919,
							["y"] = -181.74084492312585
						},
						["propsData"] = {
							["EventPath"] = "event:/sfx/common/scene/east/wangxi_click",
							["TargetPointName"] = "",
							["EventKey"] = "",
							["PlayAs2D"] = true
						}
					},
					["1770283236227409247"] = {
						["key"] = "1770283236227409247",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 324.8228769668158,
							["y"] = 10.263736263736298
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "StartPoint_200318fushu4",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["1770283236227409249"] = {
						["key"] = "1770283236227409249",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 892.8408113515753,
							["y"] = -6.970069404279911
						},
						["propsData"] = {
							["QuestRoleId"] = 24010101,
							["IsPlayFX"] = false
						}
					},
					["1770283236227409250"] = {
						["key"] = "1770283236227409250",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效 子弹跳",
						["pos"] = {
							["x"] = 1191.6520603765425,
							["y"] = -173.9072199730094
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"BulletJump"
							}
						}
					},
					["1770283314412411681"] = {
						["key"] = "1770283314412411681",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 622.0742481203007,
							["y"] = 0.9624060150375957
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180601.2003180601'",
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
					["1773059067507436446"] = {
						["key"] = "1773059067507436446",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 471.8560558266608,
							["y"] = 688.5526400843737
						},
						["propsData"] = {
							["SpecialConfigId"] = 0,
							["BlackScreenImmediately"] = false
						}
					},
					["1773059078538436851"] = {
						["key"] = "1773059078538436851",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 45.9903338293592,
							["y"] = 200.69544902981448
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010278,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox05_232010278"
						}
					},
					["1773059078538436852"] = {
						["key"] = "1773059078538436852",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 43.92365923273144,
							["y"] = 2.6447212488236005
						},
						["propsData"] = {
							["VarName"] = "WangchuanFushu03",
							["VarValue"] = 1
						}
					},
					["1773059078538436853"] = {
						["key"] = "1773059078538436853",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量判断",
						["pos"] = {
							["x"] = -233.01374538160792,
							["y"] = 2.144721248823487
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "WangchuanFushu03",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["1773059144537438626"] = {
						["key"] = "1773059144537438626",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成往隙特效",
						["pos"] = {
							["x"] = 358.268938996123,
							["y"] = 231.82187085360462
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								232010277
							}
						}
					}
				},
				["commentData"] = {
					["1770282444340401385"] = {
						["key"] = "1770282444340401385",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1335.9433198380566,
							["y"] = 180.26720647773277
						},
						["size"] = {
							["width"] = 900,
							["height"] = 452
						}
					}
				}
			}
		},
		["1770282184913398056"] = {
			["isStoryNode"] = true,
			["key"] = "1770282184913398056",
			["type"] = "StoryNode",
			["name"] = "幻境",
			["pos"] = {
				["x"] = 1457.246781727045,
				["y"] = 530.4796365914789
			},
			["propsData"] = {
				["QuestId"] = 20031807,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031807",
				["QuestDeatil"] = "Content_20031807",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770282781601402570",
						["startPort"] = "Out",
						["endQuest"] = "1770282775602402409",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282775602402409",
						["startPort"] = "Out",
						["endQuest"] = "1770282791177402878",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282791177402878",
						["startPort"] = "Out",
						["endQuest"] = "1770282802193403067",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282830708403652",
						["startPort"] = "Out",
						["endQuest"] = "1770282830708403653",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282830708403653",
						["startPort"] = "Out",
						["endQuest"] = "1770282830709403654",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282835373403844",
						["startPort"] = "Out",
						["endQuest"] = "1770282835373403845",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282835373403845",
						["startPort"] = "Out",
						["endQuest"] = "1770282835373403846",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282802193403067",
						["startPort"] = "Out",
						["endQuest"] = "1770282830708403652",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282830708403652",
						["startPort"] = "Out",
						["endQuest"] = "1770282842676404076",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282775602402409",
						["startPort"] = "Out",
						["endQuest"] = "1770282862181404342",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282830709403654",
						["startPort"] = "Out",
						["endQuest"] = "1770282835373403844",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282835373403844",
						["startPort"] = "Out",
						["endQuest"] = "1770282913937405725",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282945976406549",
						["startPort"] = "Out",
						["endQuest"] = "1770282956232406731",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282835373403846",
						["startPort"] = "Out",
						["endQuest"] = "1770282945976406549",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770283250027409762",
						["startPort"] = "Out",
						["endQuest"] = "1770283250027409763",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059472913443675",
						["startPort"] = "Out",
						["endQuest"] = "1773059472913443677",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059472913443676",
						["startPort"] = "LastDefaultOut",
						["endQuest"] = "1773059472913443675",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059472913443676",
						["startPort"] = "Region_1",
						["endQuest"] = "1770283250027409762",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282184913398057",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773059472913443676",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770283250027409762",
						["startPort"] = "Out",
						["endQuest"] = "1773059557850444969",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059557850444969",
						["startPort"] = "Out",
						["endQuest"] = "1770282184913398060",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1770282781601402570",
						["startPort"] = "Out",
						["endQuest"] = "17730639630081287250",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282802193403067",
						["startPort"] = "Out",
						["endQuest"] = "17730640054181287671",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282830709403654",
						["startPort"] = "Out",
						["endQuest"] = "17730640507001288088",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282945976406549",
						["startPort"] = "Out",
						["endQuest"] = "1770283020971407614",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1770282184913398057"] = {
						["key"] = "1770282184913398057",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -242.61904761904765,
							["y"] = 161.71428571428572
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770282184913398060"] = {
						["key"] = "1770282184913398060",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1161.2142857142858,
							["y"] = 164.33333333333334
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104501,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["1770282184913398063"] = {
						["key"] = "1770282184913398063",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1283.5000000000002,
							["y"] = 540.166666666667
						},
						["propsData"] = {}
					},
					["1770282775602402409"] = {
						["key"] = "1770282775602402409",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2044.1666666666665,
							["y"] = 31.66666666666667
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					},
					["1770282781601402570"] = {
						["key"] = "1770282781601402570",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1696.1666666666665,
							["y"] = 51.83333333333334
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
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
					["1770282791177402878"] = {
						["key"] = "1770282791177402878",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2369.6911764705883,
							["y"] = 79.83333333333331
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
					["1770282802193403067"] = {
						["key"] = "1770282802193403067",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2674.857843137255,
							["y"] = 73.16666666666666
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["1770282830708403652"] = {
						["key"] = "1770282830708403652",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1726.5122549019607,
							["y"] = 511.66666666666663
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					},
					["1770282830708403653"] = {
						["key"] = "1770282830708403653",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2040.703431372549,
							["y"] = 522.1666666666666
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
					["1770282830709403654"] = {
						["key"] = "1770282830709403654",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2333.203431372549,
							["y"] = 507.16666666666663
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["1770282835373403844"] = {
						["key"] = "1770282835373403844",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1730.0122549019607,
							["y"] = 936.1666666666666
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					},
					["1770282835373403845"] = {
						["key"] = "1770282835373403845",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2044.203431372549,
							["y"] = 946.6666666666666
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
					["1770282835373403846"] = {
						["key"] = "1770282835373403846",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2336.703431372549,
							["y"] = 931.6666666666666
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["1770282842676404076"] = {
						["key"] = "1770282842676404076",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2026.1911764705878,
							["y"] = 311.33333333333337
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51175408,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1770282862181404342"] = {
						["key"] = "1770282862181404342",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 2379.1911764705883,
							["y"] = -131.83333333333331
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51175404,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1770282913937405725"] = {
						["key"] = "1770282913937405725",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2051.357843137255,
							["y"] = 767.1666666666666
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51175413,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1770282945976406549"] = {
						["key"] = "1770282945976406549",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1724.3578431372548,
							["y"] = 1368.1666666666667
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					},
					["1770282956232406731"] = {
						["key"] = "1770282956232406731",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 2043.6034571723426,
							["y"] = 1175.4298245614036
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1770283012939407456"] = {
						["key"] = "1770283012939407456",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2942.5109531851017,
							["y"] = 822.7982456140347
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					},
					["1770283020971407614"] = {
						["key"] = "1770283020971407614",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2040.6927713669197,
							["y"] = 1355.755183413078
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
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
					["1770283250027409760"] = {
						["key"] = "1770283250027409760",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -441.97079504744386,
							["y"] = 382.38170163170116
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
					["1770283250027409762"] = {
						["key"] = "1770283250027409762",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 463.4844826957118,
							["y"] = 141.88536463536414
						},
						["propsData"] = {
							["QuestRoleId"] = 24010101,
							["IsPlayFX"] = false
						}
					},
					["1770283250027409763"] = {
						["key"] = "1770283250027409763",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效 子弹跳",
						["pos"] = {
							["x"] = 806.8834510189245,
							["y"] = -56.16958041958091
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"BulletJump"
							}
						}
					},
					["1773059452018443601"] = {
						["key"] = "1773059452018443601",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 447.2857142857142,
							["y"] = 412.42857142857144
						},
						["propsData"] = {
							["SpecialConfigId"] = 0,
							["BlackScreenImmediately"] = false
						}
					},
					["1773059472913443675"] = {
						["key"] = "1773059472913443675",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 432.5195347485487,
							["y"] = 682.9757664931253
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010271,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox06_232010271"
						}
					},
					["1773059472913443676"] = {
						["key"] = "1773059472913443676",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 112.40379466930972,
							["y"] = 146.23700547519377
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								104301
							}
						}
					},
					["1773059472913443677"] = {
						["key"] = "1773059472913443677",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 778.3104910449767,
							["y"] = 694.0487088105203
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104301,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["1773059557850444969"] = {
						["key"] = "1773059557850444969",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 812.1666666666666,
							["y"] = 150.16666666666666
						},
						["propsData"] = {
							["WaitTime"] = 10
						}
					},
					["17730639630081287250"] = {
						["key"] = "17730639630081287250",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 2040.594013442697,
							["y"] = -144.9287707906124
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51175402,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17730640054181287671"] = {
						["key"] = "17730640054181287671",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2959.9799783549774,
							["y"] = -95.45508658008598
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51175407,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17730640507001288088"] = {
						["key"] = "17730640507001288088",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2616.6466450216444,
							["y"] = 314.5449134199139
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51175412,
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
		["1770282194593398357"] = {
			["isStoryNode"] = true,
			["key"] = "1770282194593398357",
			["type"] = "StoryNode",
			["name"] = "终场",
			["pos"] = {
				["x"] = 1815.3420198222832,
				["y"] = 528.5629699248123
			},
			["propsData"] = {
				["QuestId"] = 20031808,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031808",
				["QuestDeatil"] = "Content_20031808",
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
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_TriggerBox05_232010278",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1770283275661410664",
						["startPort"] = "Out",
						["endQuest"] = "1770283275661410665",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770283275661410664",
						["startPort"] = "Out",
						["endQuest"] = "1770283343526412203",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770283343526412203",
						["startPort"] = "Out",
						["endQuest"] = "1770283387275412966",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059612624446662",
						["startPort"] = "true",
						["endQuest"] = "1773059612624446661",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059612624446662",
						["startPort"] = "false",
						["endQuest"] = "1773059612624446660",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770282194593398362",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773059612624446662",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059612624446661",
						["startPort"] = "Out",
						["endQuest"] = "1770283275661410664",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059612624446660",
						["startPort"] = "Out",
						["endQuest"] = "1770283275661410664",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770283387275412966",
						["startPort"] = "Out",
						["endQuest"] = "1773059855262448764",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059855262448764",
						["startPort"] = "Out",
						["endQuest"] = "1773059872687449345",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773060044538450710",
						["startPort"] = "Out",
						["endQuest"] = "1773060056353450813",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773059872687449345",
						["startPort"] = "Out",
						["endQuest"] = "1773060044538450710",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773060056353450813",
						["startPort"] = "Out",
						["endQuest"] = "1770282194593398363",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1770282194593398362"] = {
						["key"] = "1770282194593398362",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 200.5,
							["y"] = 365
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770282194593398363"] = {
						["key"] = "1770282194593398363",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3343.1722488038276,
							["y"] = 391.97846889952154
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1770282194593398364"] = {
						["key"] = "1770282194593398364",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1586.1454545454549,
							["y"] = 954.2818181818182
						},
						["propsData"] = {}
					},
					["1770283275661410662"] = {
						["key"] = "1770283275661410662",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1118.3228769668158,
							["y"] = -52.557692307692264
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
					["1770283275661410664"] = {
						["key"] = "1770283275661410664",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1286.4881114199281,
							["y"] = 364.09315684315686
						},
						["propsData"] = {
							["QuestRoleId"] = 24010101,
							["IsPlayFX"] = false
						}
					},
					["1770283275661410665"] = {
						["key"] = "1770283275661410665",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效 子弹跳",
						["pos"] = {
							["x"] = 1652.847452703514,
							["y"] = 195.5177322677322
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"BulletJump"
							}
						}
					},
					["1770283343526412203"] = {
						["key"] = "1770283343526412203",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1639.178321678322,
							["y"] = 363.04545454545456
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010273,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox08_232010273"
						}
					},
					["1770283387275412966"] = {
						["key"] = "1770283387275412966",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1940.196172248804,
							["y"] = 362.56459330143537
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180801.2003180801'",
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
					["1773059612624446660"] = {
						["key"] = "1773059612624446660",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 881.5353769037974,
							["y"] = 544.4628638904956
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010278,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox05_232010278"
						}
					},
					["1773059612624446661"] = {
						["key"] = "1773059612624446661",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 888.4687023071697,
							["y"] = 357.1799932523618
						},
						["propsData"] = {
							["VarName"] = "WangchuanFushu05",
							["VarValue"] = 1
						}
					},
					["1773059612624446662"] = {
						["key"] = "1773059612624446662",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量判断",
						["pos"] = {
							["x"] = 559.0312976928303,
							["y"] = 357.53713610950444
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "WangchuanFushu05",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["1773059855262448764"] = {
						["key"] = "1773059855262448764",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2230.340909090909,
							["y"] = 366.6818181818182
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010274,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox09_232010274"
						}
					},
					["1773059872687449345"] = {
						["key"] = "1773059872687449345",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2476.147129186603,
							["y"] = 371.04545454545456
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180802.2003180802'",
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
					["1773060044538450710"] = {
						["key"] = "1773060044538450710",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2746.8217703349283,
							["y"] = 369.94736842105266
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 232010279,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TriggerBox11_232010279"
						}
					},
					["1773060056353450813"] = {
						["key"] = "1773060056353450813",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3025.183014354067,
							["y"] = 376.52870813397124
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180803.2003180803'",
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
					["1773060070761451259"] = {
						["key"] = "1773060070761451259",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1282.0136363636366,
							["y"] = 921.7727272727274
						},
						["propsData"] = {
							["SpecialConfigId"] = 0,
							["BlackScreenImmediately"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}