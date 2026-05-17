return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17524799552681856",
			["startPort"] = "Success",
			["endStory"] = "17524633788695",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17524633788681",
			["startPort"] = "StoryStart",
			["endStory"] = "1752463393192102",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1752463403168440",
			["startPort"] = "Success",
			["endStory"] = "17524799552681856",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1752463393192102",
			["startPort"] = "Success",
			["endStory"] = "1755757322327936561",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1755757322327936561",
			["startPort"] = "Success",
			["endStory"] = "1752463403168440",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17524633788681"] = {
			["isStoryNode"] = true,
			["key"] = "17524633788681",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 839.170436820527,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 200306
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17524633788695"] = {
			["isStoryNode"] = true,
			["key"] = "17524633788695",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2249,
				["y"] = 292
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1752463393192102"] = {
			["isStoryNode"] = true,
			["key"] = "1752463393192102",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 1125.181618848138,
				["y"] = 271.4277907587363
			},
			["propsData"] = {
				["QuestId"] = 20030600,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 104107,
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_20030601_2080080",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1752463393192103",
						["startPort"] = "QuestStart",
						["endQuest"] = "17533452608171327678",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17533452608171327678",
						["startPort"] = "Out",
						["endQuest"] = "17533452671141327789",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17607058442941417",
						["startPort"] = "Out",
						["endQuest"] = "17607058442941416",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17607058442941414",
						["startPort"] = "Out",
						["endQuest"] = "17607058442941415",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17607058442941412",
						["startPort"] = "Out",
						["endQuest"] = "17607058442941413",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463393192103",
						["startPort"] = "QuestStart",
						["endQuest"] = "17607058442941417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463393192103",
						["startPort"] = "QuestStart",
						["endQuest"] = "17607058442941414",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463393192103",
						["startPort"] = "QuestStart",
						["endQuest"] = "17607058442941412",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17533452671141327789",
						["startPort"] = "Out",
						["endQuest"] = "1752463393193110",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1752463393192103"] = {
						["key"] = "1752463393192103",
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
					["1752463393193110"] = {
						["key"] = "1752463393193110",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2403.2620320855617,
							["y"] = 289.2513368983957
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1752463393193117"] = {
						["key"] = "1752463393193117",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1807.1717177321868,
							["y"] = 571.8686866818637
						},
						["propsData"] = {
							["SideQuestChainId"] = 200306,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["1752463393193123"] = {
						["key"] = "1752463393193123",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2399.3315508021387,
							["y"] = 605.0267379679144
						},
						["propsData"] = {}
					},
					["17533452608171327678"] = {
						["key"] = "17533452608171327678",
						["type"] = "GoToNode",
						["name"] = "前往机关",
						["pos"] = {
							["x"] = 1203.6262626262628,
							["y"] = 288.8282828282828
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2080080,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_20030601_2080080"
						}
					},
					["17533452671141327789"] = {
						["key"] = "17533452671141327789",
						["type"] = "TalkNode",
						["name"] = "与小白对话",
						["pos"] = {
							["x"] = 1600.8761539069078,
							["y"] = 271.5154558158158
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51103001,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage200306_1",
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
					["17564377159992623"] = {
						["key"] = "17564377159992623",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1228.2140859394863,
							["y"] = 572.9290617848972
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104107,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17607058442941412"] = {
						["key"] = "17607058442941412",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1206.4940464430956,
							["y"] = -327.02862611086636
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080089,
							["StateId"] = 701063,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17607058442941413"] = {
						["key"] = "17607058442941413",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1611.3508641932244,
							["y"] = -325.6942750165968
						},
						["propsData"] = {
							["VarName"] = "JiShuvar1",
							["VarValue"] = 1
						}
					},
					["17607058442941414"] = {
						["key"] = "17607058442941414",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1206.7881519003338,
							["y"] = -126.43925430243746
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080094,
							["StateId"] = 701003,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17607058442941415"] = {
						["key"] = "17607058442941415",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1611.505953556904,
							["y"] = -123.21152543903253
						},
						["propsData"] = {
							["VarName"] = "JiShuvar2",
							["VarValue"] = 1
						}
					},
					["17607058442941416"] = {
						["key"] = "17607058442941416",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1611.1753674763177,
							["y"] = 69.39012291261577
						},
						["propsData"] = {
							["VarName"] = "JiShuvar3",
							["VarValue"] = 1
						}
					},
					["17607058442941417"] = {
						["key"] = "17607058442941417",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1207.7154497434724,
							["y"] = 70.36195944419961
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080099,
							["StateId"] = 701003,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1752463403168440"] = {
			["isStoryNode"] = true,
			["key"] = "1752463403168440",
			["type"] = "StoryNode",
			["name"] = "机关",
			["pos"] = {
				["x"] = 1678.2988505747126,
				["y"] = 273.65520731095546
			},
			["propsData"] = {
				["QuestId"] = 20030602,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200306_2",
				["QuestDeatil"] = "Content_200306_2",
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
				["StoryGuidePointName"] = "Mechanism_20030601_2080080",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1752463403168441",
						["startPort"] = "QuestStart",
						["endQuest"] = "17557453777223804",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17557456953285294",
						["startPort"] = "Out",
						["endQuest"] = "1752463403168444",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1755831840673946300",
						["startPort"] = "true",
						["endQuest"] = "17557456730894693",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17557456730894693",
						["startPort"] = "Out",
						["endQuest"] = "17557453372342796",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755831871030947037",
						["startPort"] = "true",
						["endQuest"] = "1756448910150960311",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756448910150960311",
						["startPort"] = "Out",
						["endQuest"] = "17557456730894691",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755831411713938883",
						["startPort"] = "true",
						["endQuest"] = "17533467848891330634",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17557453372342796",
						["startPort"] = "Out",
						["endQuest"] = "17557453372342797",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17533468197691331208",
						["startPort"] = "Out",
						["endQuest"] = "1755831312053936237",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755831312053936237",
						["startPort"] = "Out",
						["endQuest"] = "17533468478091331950",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17557453372342797",
						["startPort"] = "Out",
						["endQuest"] = "1755831899160947808",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755831899160947808",
						["startPort"] = "Out",
						["endQuest"] = "17557453372342798",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463403168441",
						["startPort"] = "QuestStart",
						["endQuest"] = "1755831871030947037",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463403168441",
						["startPort"] = "QuestStart",
						["endQuest"] = "1755831840673946300",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463403168441",
						["startPort"] = "QuestStart",
						["endQuest"] = "1755831411713938883",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175698917690310081",
						["startPort"] = "Out",
						["endQuest"] = "17557456953285294",
						["endPort"] = "Branch_1"
					},
					{
						["startQuest"] = "17569890877037371",
						["startPort"] = "Out",
						["endQuest"] = "17557456953285294",
						["endPort"] = "Branch_2"
					},
					{
						["startQuest"] = "175698917540210034",
						["startPort"] = "Out",
						["endQuest"] = "17557456953285294",
						["endPort"] = "Branch_3"
					},
					{
						["startQuest"] = "17557453777223804",
						["startPort"] = "Out",
						["endQuest"] = "175698922574411425",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175698922574411425",
						["startPort"] = "Out",
						["endQuest"] = "175698917690310081",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175698917690310081",
						["startPort"] = "Out",
						["endQuest"] = "175698924426611860",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17557453777223804",
						["startPort"] = "Out",
						["endQuest"] = "175698930736513530",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175698930736513530",
						["startPort"] = "Out",
						["endQuest"] = "17569890877037371",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17557453777223804",
						["startPort"] = "Out",
						["endQuest"] = "175698932229913903",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175698932229913903",
						["startPort"] = "Out",
						["endQuest"] = "175698917540210034",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17533467848891330634",
						["startPort"] = "Out",
						["endQuest"] = "17533468197691331208",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17569890877037371",
						["startPort"] = "Out",
						["endQuest"] = "175698946929916858",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175698917540210034",
						["startPort"] = "Out",
						["endQuest"] = "175698948865817299",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611195963892970543",
						["startPort"] = "Out",
						["endQuest"] = "17611195963892970542",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611195963892970540",
						["startPort"] = "Out",
						["endQuest"] = "17611195963892970541",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17611195963892970538",
						["startPort"] = "Out",
						["endQuest"] = "17611195963892970539",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463403168441",
						["startPort"] = "QuestStart",
						["endQuest"] = "17611195963892970538",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463403168441",
						["startPort"] = "QuestStart",
						["endQuest"] = "17611195963892970540",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463403168441",
						["startPort"] = "QuestStart",
						["endQuest"] = "17611195963892970543",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176663137908021563",
						["startPort"] = "Out",
						["endQuest"] = "176663137908021564",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463403168441",
						["startPort"] = "QuestStart",
						["endQuest"] = "176663137908021563",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463403168441",
						["startPort"] = "QuestStart",
						["endQuest"] = "176663137908021565",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176663137908021565",
						["startPort"] = "Out",
						["endQuest"] = "17666320102492903689",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755831411713938883",
						["startPort"] = "true",
						["endQuest"] = "176768532780615414",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17557456730894693",
						["startPort"] = "Out",
						["endQuest"] = "176768534059815750",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756448910150960311",
						["startPort"] = "Out",
						["endQuest"] = "176768534821015892",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17557456730894691",
						["startPort"] = "Out",
						["endQuest"] = "17685511348055533186",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17685511348055533186",
						["startPort"] = "Fail",
						["endQuest"] = "1755831902029947888",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1752463403168441"] = {
						["key"] = "1752463403168441",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 402.88461538461536,
							["y"] = 610.8076923076923
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1752463403168444"] = {
						["key"] = "1752463403168444",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2608.432995228281,
							["y"] = 602.7787511639581
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1752463403168447"] = {
						["key"] = "1752463403168447",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2601.7239010989006,
							["y"] = 891.25
						},
						["propsData"] = {}
					},
					["17533467848891330634"] = {
						["key"] = "17533467848891330634",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1280.8922969515336,
							["y"] = 1004.6706833698074
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51103028,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17533468197691331208"] = {
						["key"] = "17533468197691331208",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1559.3227095079594,
							["y"] = 1004.3033177384449
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080089,
							["StateId"] = 701063,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17533468478091331950"] = {
						["key"] = "17533468478091331950",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 2125.771827196072,
							["y"] = 1008.5840481968437
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51103029,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17540161998261316532"] = {
						["key"] = "17540161998261316532",
						["type"] = "GoToNode",
						["name"] = "前往机关",
						["pos"] = {
							["x"] = 2492.72565139414,
							["y"] = 381.49190820426196
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2080080,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_20030601_2080080"
						}
					},
					["17557453372342796"] = {
						["key"] = "17557453372342796",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1566.5686036107704,
							["y"] = 1205.8015687232353
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51103030,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17557453372342797"] = {
						["key"] = "17557453372342797",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1844.1278191828576,
							["y"] = 1206.4734514062739
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080094,
							["StateId"] = 701003,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17557453372342798"] = {
						["key"] = "17557453372342798",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 2400.8403947140864,
							["y"] = 1203.716904514565
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51103031,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17557453372342799"] = {
						["key"] = "17557453372342799",
						["type"] = "GoToNode",
						["name"] = "前往吸球入坑",
						["pos"] = {
							["x"] = 2187.540539232839,
							["y"] = 379.9997312556905
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080083,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_20030602_2080083"
						}
					},
					["17557453777223804"] = {
						["key"] = "17557453777223804",
						["type"] = "BranchQuestStartNode",
						["name"] = "子任务开始节点",
						["pos"] = {
							["x"] = 803.4047619047619,
							["y"] = 612.4047619047619
						},
						["propsData"] = {
							["AllQuestOptions"] = {
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "Description_200306_4",
									["TargetBranchQuestKey"] = ""
								},
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "Description_200306_5",
									["TargetBranchQuestKey"] = ""
								},
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "Description_200306_6",
									["TargetBranchQuestKey"] = ""
								}
							},
							["IsSetCountInfo"] = true,
							["IsDifftation"] = true,
							["AllDiffGuideOptions"] = {
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "175698922574411425",
											["IsShowOptional"] = false
										}
									}
								},
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "175698930736513530",
											["IsShowOptional"] = false
										}
									}
								},
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "175698932229913903",
											["IsShowOptional"] = false
										}
									}
								}
							}
						}
					},
					["17557456730894691"] = {
						["key"] = "17557456730894691",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1557.5939891973267,
							["y"] = 1405.312364945649
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51103032,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17557456730894693"] = {
						["key"] = "17557456730894693",
						["type"] = "GoToNode",
						["name"] = "前往拨引石块",
						["pos"] = {
							["x"] = 1281.8294421185192,
							["y"] = 1204.5056080190764
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2080084,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_20030603_2080084"
						}
					},
					["17557456953285294"] = {
						["key"] = "17557456953285294",
						["type"] = "CheckBranchQuestFinishedNode",
						["name"] = "子任务结束节点",
						["pos"] = {
							["x"] = 2225.9989155581266,
							["y"] = 568.9281376518219
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
					["1755831312053936237"] = {
						["key"] = "1755831312053936237",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1840.8014680108336,
							["y"] = 1006.0318535953207
						},
						["propsData"] = {
							["VarName"] = "JiShuvar1",
							["VarValue"] = 1
						}
					},
					["1755831411713938883"] = {
						["key"] = "1755831411713938883",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 997.2808959616235,
							["y"] = 1008.6128372401591
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "JiShuvar1",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["1755831840673946300"] = {
						["key"] = "1755831840673946300",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 1001.3804222093686,
							["y"] = 1205.0152147903696
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "JiShuvar2",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["1755831871030947037"] = {
						["key"] = "1755831871030947037",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数",
						["pos"] = {
							["x"] = 1002.9781112849993,
							["y"] = 1406.1486181517146
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "JiShuvar3",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["1755831899160947808"] = {
						["key"] = "1755831899160947808",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2122.567766856466,
							["y"] = 1205.9826535693412
						},
						["propsData"] = {
							["VarName"] = "JiShuvar2",
							["VarValue"] = 1
						}
					},
					["1755831902029947888"] = {
						["key"] = "1755831902029947888",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2132.160590570418,
							["y"] = 1400.114703536917
						},
						["propsData"] = {
							["VarName"] = "JiShuvar3",
							["VarValue"] = 1
						}
					},
					["1756448910150960311"] = {
						["key"] = "1756448910150960311",
						["type"] = "GoToNode",
						["name"] = "前往旋转扇叶",
						["pos"] = {
							["x"] = 1281.3350570997627,
							["y"] = 1405.437380215244
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2080085,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_20030604_2080085"
						}
					},
					["17569890877037371"] = {
						["key"] = "17569890877037371",
						["type"] = "CalculateVarCountNode",
						["name"] = "变量计数节点",
						["pos"] = {
							["x"] = 1405.7447839657154,
							["y"] = 607.3587060586387
						},
						["propsData"] = {
							["VarName"] = "JiShuvar2",
							["VarValue"] = 1,
							["IsOpen"] = true
						}
					},
					["175698917540210034"] = {
						["key"] = "175698917540210034",
						["type"] = "CalculateVarCountNode",
						["name"] = "变量计数节点",
						["pos"] = {
							["x"] = 1403.9870134536711,
							["y"] = 804.9879061895083
						},
						["propsData"] = {
							["VarName"] = "JiShuvar3",
							["VarValue"] = 1,
							["IsOpen"] = true
						}
					},
					["175698917690310081"] = {
						["key"] = "175698917690310081",
						["type"] = "CalculateVarCountNode",
						["name"] = "变量计数节点",
						["pos"] = {
							["x"] = 1404.3974587912264,
							["y"] = 405.6119471102243
						},
						["propsData"] = {
							["VarName"] = "JiShuvar1",
							["VarValue"] = 1,
							["IsOpen"] = true
						}
					},
					["175698922574411425"] = {
						["key"] = "175698922574411425",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1118.65949816075,
							["y"] = 408.3706100719763
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint200306_2"
						}
					},
					["175698924426611860"] = {
						["key"] = "175698924426611860",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1803.4648202896017,
							["y"] = 405.66192659858734
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint200306_2"
						}
					},
					["175698930736513530"] = {
						["key"] = "175698930736513530",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1116.647205455027,
							["y"] = 607.831102448238
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_20030603_2080084"
						}
					},
					["175698932229913903"] = {
						["key"] = "175698932229913903",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1117.4192642785563,
							["y"] = 806.3531612717672
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_20030604_2080085"
						}
					},
					["175698946929916858"] = {
						["key"] = "175698946929916858",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1803.460135492887,
							["y"] = 606.1399158754991
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_20030603_2080084"
						}
					},
					["175698948865817299"] = {
						["key"] = "175698948865817299",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1804.5077545405059,
							["y"] = 802.5922968278802
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_20030604_2080085"
						}
					},
					["17611195963892970538"] = {
						["key"] = "17611195963892970538",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 821.7320327131187,
							["y"] = -145.83859941368854
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080089,
							["StateId"] = 701063,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17611195963892970539"] = {
						["key"] = "17611195963892970539",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1226.5888504632476,
							["y"] = -144.504248319419
						},
						["propsData"] = {
							["VarName"] = "JiShuvar1",
							["VarValue"] = 1
						}
					},
					["17611195963892970540"] = {
						["key"] = "17611195963892970540",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 822.0261381703568,
							["y"] = 54.75077239474035
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080094,
							["StateId"] = 701003,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17611195963892970541"] = {
						["key"] = "17611195963892970541",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1226.743939826927,
							["y"] = 57.97850125814526
						},
						["propsData"] = {
							["VarName"] = "JiShuvar2",
							["VarValue"] = 1
						}
					},
					["17611195963892970542"] = {
						["key"] = "17611195963892970542",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1226.4133537463408,
							["y"] = 250.58014960979358
						},
						["propsData"] = {
							["VarName"] = "JiShuvar3",
							["VarValue"] = 1
						}
					},
					["17611195963892970543"] = {
						["key"] = "17611195963892970543",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 822.9534360134954,
							["y"] = 251.55198614137743
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080099,
							["StateId"] = 701003,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["176663137908021563"] = {
						["key"] = "176663137908021563",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1594.946718706332,
							["y"] = -175.8167502674114
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080090,
							["StateId"] = 1210151,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["176663137908021564"] = {
						["key"] = "176663137908021564",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2007.3035364564612,
							["y"] = -172.60739917314186
						},
						["propsData"] = {
							["VarName"] = "JiShuvar1",
							["VarValue"] = 1
						}
					},
					["176663137908021565"] = {
						["key"] = "176663137908021565",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1603.668122006709,
							["y"] = 37.82383528765459
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080096,
							["StateId"] = 1210172,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17666320102492903689"] = {
						["key"] = "17666320102492903689",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2012.8996373853179,
							["y"] = 46.89802135429093
						},
						["propsData"] = {
							["VarName"] = "JiShuvar2",
							["VarValue"] = 1
						}
					},
					["176768532780615414"] = {
						["key"] = "176768532780615414",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1234,
							["y"] = 1148
						},
						["propsData"] = {
							["GuideId"] = 94
						}
					},
					["176768534059815750"] = {
						["key"] = "176768534059815750",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1568.3492880308402,
							["y"] = 1327.392298427352
						},
						["propsData"] = {
							["GuideId"] = 95
						}
					},
					["176768534821015892"] = {
						["key"] = "176768534821015892",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1568.3492880308404,
							["y"] = 1561.6780084572133
						},
						["propsData"] = {
							["GuideId"] = 93
						}
					},
					["17685511348055533186"] = {
						["key"] = "17685511348055533186",
						["type"] = "ConditionNode",
						["name"] = "条件节点",
						["pos"] = {
							["x"] = 1840.7636937366042,
							["y"] = 1401.620241600505
						},
						["propsData"] = {
							["ConditionId"] = 1000609
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1752463421655875"] = {
			["isStoryNode"] = true,
			["key"] = "1752463421655875",
			["type"] = "StoryNode",
			["name"] = "拨引石块",
			["pos"] = {
				["x"] = 1484.9999999999998,
				["y"] = 1025.0000000000002
			},
			["propsData"] = {
				["QuestId"] = 20030602,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200306_2",
				["QuestDeatil"] = "Content_200306_2",
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
				["StoryGuidePointName"] = "Mechanism_20030602_2080083",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17533472598941333190",
						["startPort"] = "Out",
						["endQuest"] = "1752463421656879",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17533472598931333188",
						["startPort"] = "Out",
						["endQuest"] = "17533472598941333190",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752463421655876",
						["startPort"] = "QuestStart",
						["endQuest"] = "17540162106021316826",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17540162106021316826",
						["startPort"] = "Out",
						["endQuest"] = "17533472598931333188",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1752463421655876"] = {
						["key"] = "1752463421655876",
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
					["1752463421656879"] = {
						["key"] = "1752463421656879",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2430,
							["y"] = 306
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1752463421656882"] = {
						["key"] = "1752463421656882",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17533472598931333188"] = {
						["key"] = "17533472598931333188",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1690.423198263205,
							["y"] = 271.60083402444957
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51103030,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17533472598931333189"] = {
						["key"] = "17533472598931333189",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1693.4012550559917,
							["y"] = 446.15673671225125
						},
						["propsData"] = {
							["CreateType"] = 0,
							["CreateId"] = 0,
							["StateId"] = 0,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17533472598941333190"] = {
						["key"] = "17533472598941333190",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 2066.076277840689,
							["y"] = 302.8965507867174
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51103031,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17540162106021316826"] = {
						["key"] = "17540162106021316826",
						["type"] = "GoToNode",
						["name"] = "前往机关",
						["pos"] = {
							["x"] = 1290,
							["y"] = 274
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2080083,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1752463425345993"] = {
			["isStoryNode"] = true,
			["key"] = "1752463425345993",
			["type"] = "StoryNode",
			["name"] = "旋转扇叶",
			["pos"] = {
				["x"] = 1854.1904761385756,
				["y"] = 1005.6666666666669
			},
			["propsData"] = {
				["QuestId"] = 20030603,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200306_3",
				["QuestDeatil"] = "Content_200306_3",
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
				["StoryGuidePointName"] = "Mechanism_20030603_2080084",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17533473747862324262",
						["startPort"] = "Out",
						["endQuest"] = "1752463425345997",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1752463425345994",
						["startPort"] = "QuestStart",
						["endQuest"] = "17540162180101317066",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17540162180101317066",
						["startPort"] = "Out",
						["endQuest"] = "17533473747862324262",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1752463425345994"] = {
						["key"] = "1752463425345994",
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
					["1752463425345997"] = {
						["key"] = "1752463425345997",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2314,
							["y"] = 358
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17524634253451000"] = {
						["key"] = "17524634253451000",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17533473747862324262"] = {
						["key"] = "17533473747862324262",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1846.2413811322674,
							["y"] = 296.20689754962353
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51103032,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17533473747862324263"] = {
						["key"] = "17533473747862324263",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1816.3103461051999,
							["y"] = 459.79310245037647
						},
						["propsData"] = {
							["CreateType"] = 0,
							["CreateId"] = 0,
							["StateId"] = 0,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17540162180101317066"] = {
						["key"] = "17540162180101317066",
						["type"] = "GoToNode",
						["name"] = "前往机关",
						["pos"] = {
							["x"] = 1334,
							["y"] = 296
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2080084,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17524799552681856"] = {
			["isStoryNode"] = true,
			["key"] = "17524799552681856",
			["type"] = "StoryNode",
			["name"] = "与公尚对话",
			["pos"] = {
				["x"] = 1960.6078694523706,
				["y"] = 272.04117169257114
			},
			["propsData"] = {
				["QuestId"] = 20030603,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200306_3",
				["QuestDeatil"] = "Content_200306_3",
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_GongShang_2080207",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17533475392537274615",
						["startPort"] = "Out",
						["endQuest"] = "175671766516712432218",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175671766516712432218",
						["startPort"] = "Out",
						["endQuest"] = "17524799552681862",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17524799552681861",
						["startPort"] = "QuestStart",
						["endQuest"] = "175671766516712432217",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175671766516712432217",
						["startPort"] = "Out",
						["endQuest"] = "17533475392537274615",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17524799552681861"] = {
						["key"] = "17524799552681861",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 803.5714285714284,
							["y"] = 300.7142857142857
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17524799552681862"] = {
						["key"] = "17524799552681862",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2326.105271156453,
							["y"] = 290.7266551694197
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17524799552681863"] = {
						["key"] = "17524799552681863",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2204.838717001162,
							["y"] = 590.3225819947941
						},
						["propsData"] = {}
					},
					["17533475392537274615"] = {
						["key"] = "17533475392537274615",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1597.2229480607639,
							["y"] = 274.88794678209047
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700323,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_GongShang_2080206",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51103034,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage200306_3",
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
									["TalkActorId"] = 700323,
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
					["17533475473817274838"] = {
						["key"] = "17533475473817274838",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1204.252911041344,
							["y"] = 604.1716763885256
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080207,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_GongShang_2080207"
						}
					},
					["175671766516712432217"] = {
						["key"] = "175671766516712432217",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1199.0760869565217,
							["y"] = 298.5916149068323
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Npc_GongShang_2080207",
							["StaticCreatorIdList"] = {
								2080207
							}
						}
					},
					["175671766516712432218"] = {
						["key"] = "175671766516712432218",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2001.75,
							["y"] = 298.92391304347825
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "Npc_GongShang_2080207",
							["StaticCreatorIdList"] = {
								2080207
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1755757322327936561"] = {
			["isStoryNode"] = true,
			["key"] = "1755757322327936561",
			["type"] = "StoryNode",
			["name"] = "寻找公尚",
			["pos"] = {
				["x"] = 1401.540064554189,
				["y"] = 269.06361668789657
			},
			["propsData"] = {
				["QuestId"] = 20030601,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200306_1",
				["QuestDeatil"] = "Content_200306_1",
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
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_GongShang_2080206",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1755757322327936566",
						["startPort"] = "QuestStart",
						["endQuest"] = "17564568136483827869",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755757463351938919",
						["startPort"] = "Out",
						["endQuest"] = "17564568402843828425",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17564568402843828425",
						["startPort"] = "Out",
						["endQuest"] = "1755757322327936567",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17564568136483827869",
						["startPort"] = "Out",
						["endQuest"] = "1755757463351938919",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17564568136483827869",
						["startPort"] = "Out",
						["endQuest"] = "175689761675210496933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175689761675210496933",
						["startPort"] = "Out",
						["endQuest"] = "175689759955910496447",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17564568136483827869",
						["startPort"] = "Out",
						["endQuest"] = "175689759955910496444",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175689759955910496444",
						["startPort"] = "Out",
						["endQuest"] = "175689759955910496445",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17564568136483827869",
						["startPort"] = "Out",
						["endQuest"] = "175689759955910496442",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175689759955910496442",
						["startPort"] = "Out",
						["endQuest"] = "175689759955910496443",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1755757322327936566"] = {
						["key"] = "1755757322327936566",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 602.1052631578948,
							["y"] = 608.7368421052631
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1755757322327936567"] = {
						["key"] = "1755757322327936567",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1805.140051330074,
							["y"] = 601.6590287810777
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1755757322327936568"] = {
						["key"] = "1755757322327936568",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2805.625,
							["y"] = 1011.25
						},
						["propsData"] = {}
					},
					["1755757463351938919"] = {
						["key"] = "1755757463351938919",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1204.7916666666665,
							["y"] = 595.7916666666667
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700323,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_GongShang_2080206",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51103013,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage200306_2",
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
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700323,
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
					["17564568136483827869"] = {
						["key"] = "17564568136483827869",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 883.6428571428571,
							["y"] = 611.0178571428571
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Npc_GongShang_2080206",
							["StaticCreatorIdList"] = {
								2080206
							}
						}
					},
					["17564568402843828425"] = {
						["key"] = "17564568402843828425",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1521,
							["y"] = 610.375
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "Npc_GongShang_2080206",
							["StaticCreatorIdList"] = {
								2080206
							}
						}
					},
					["175689759955910496442"] = {
						["key"] = "175689759955910496442",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1201.8394194581006,
							["y"] = 7.603917748647753
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080089,
							["StateId"] = 701063,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["175689759955910496443"] = {
						["key"] = "175689759955910496443",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1606.6962372082294,
							["y"] = 8.938268842917296
						},
						["propsData"] = {
							["VarName"] = "JiShuvar1",
							["VarValue"] = 1
						}
					},
					["175689759955910496444"] = {
						["key"] = "175689759955910496444",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1202.1335249153387,
							["y"] = 208.19328955707664
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080094,
							["StateId"] = 701003,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["175689759955910496445"] = {
						["key"] = "175689759955910496445",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1606.8513265719089,
							["y"] = 211.42101842048154
						},
						["propsData"] = {
							["VarName"] = "JiShuvar2",
							["VarValue"] = 1
						}
					},
					["175689759955910496447"] = {
						["key"] = "175689759955910496447",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1606.5207404913226,
							["y"] = 404.02266677212987
						},
						["propsData"] = {
							["VarName"] = "JiShuvar3",
							["VarValue"] = 1
						}
					},
					["175689761675210496933"] = {
						["key"] = "175689761675210496933",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1203.0608227584773,
							["y"] = 404.9945033037137
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2080099,
							["StateId"] = 701003,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}