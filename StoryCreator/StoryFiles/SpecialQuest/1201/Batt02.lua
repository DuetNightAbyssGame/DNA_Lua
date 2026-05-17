return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17501517483363111240",
			["startPort"] = "Success",
			["endStory"] = "17501517483363111241",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17501517483363111242",
			["startPort"] = "Success",
			["endStory"] = "17501517483363111239",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17501517483363111238",
			["startPort"] = "StoryStart",
			["endStory"] = "17501517483363111240",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17501517483363111241",
			["startPort"] = "Success",
			["endStory"] = "1753346561265696880",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1753348573061710306",
			["startPort"] = "Success",
			["endStory"] = "17501517483363111242",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1753346561265696880",
			["startPort"] = "Success",
			["endStory"] = "176312402111826038905",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176312402111826038905",
			["startPort"] = "Success",
			["endStory"] = "1753348573061710306",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17501517483363111238"] = {
			["isStoryNode"] = true,
			["key"] = "17501517483363111238",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 847.9852249200077,
				["y"] = 315.0566172957477
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
		["17501517483363111239"] = {
			["isStoryNode"] = true,
			["key"] = "17501517483363111239",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 3007.299699554147,
				["y"] = 385.13842751938336
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17501517483363111240"] = {
			["isStoryNode"] = true,
			["key"] = "17501517483363111240",
			["type"] = "StoryNode",
			["name"] = "【变量=0】",
			["pos"] = {
				["x"] = 1102.7399065745685,
				["y"] = 305.5148885375123
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Batt01_01_01",
				["QuestDeatil"] = "Content_Batt01_01_01",
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
						["startQuest"] = "17501517483363111246",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111247",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111243",
						["startPort"] = "QuestStart",
						["endQuest"] = "17501517483363111246",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111247",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111245",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17501517483363111252",
						["startPort"] = "false",
						["endQuest"] = "17501517483363111253",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111253",
						["startPort"] = "true",
						["endQuest"] = "17501517483363111254",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111256",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111244",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17501517483363111259",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111262",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111243",
						["startPort"] = "QuestStart",
						["endQuest"] = "17501517483363111252",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111254",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111244",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17501517483363111255",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111244",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17501693226651902260",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111259",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111253",
						["startPort"] = "false",
						["endQuest"] = "1753346671388698493",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346671388698493",
						["startPort"] = "true",
						["endQuest"] = "17501517483363111255",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346671388698493",
						["startPort"] = "false",
						["endQuest"] = "1753346693873699237",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346693873699237",
						["startPort"] = "true",
						["endQuest"] = "1753354149846719362",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753354149846719362",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111244",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17533562710342721246",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111244",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17501517483363111261",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111263",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111261",
						["startPort"] = "Out",
						["endQuest"] = "17501693226651902260",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111262",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111265",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111262",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111266",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501697218031905003",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111257",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501697218031905003",
						["startPort"] = "Out",
						["endQuest"] = "17567237974603820",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111252",
						["startPort"] = "true",
						["endQuest"] = "17533427780468902",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111252",
						["startPort"] = "true",
						["endQuest"] = "17501517483363111258",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111252",
						["startPort"] = "true",
						["endQuest"] = "17501517483363111261",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111252",
						["startPort"] = "false",
						["endQuest"] = "17533427780468902",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "17501697218031905003",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501697218031905003",
						["startPort"] = "Out",
						["endQuest"] = "17533422381473731",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17533422381473731",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111269",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17533429615719357",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111256",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17533429615719357",
						["startPort"] = "Out",
						["endQuest"] = "17571581355971303229",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501697658501905169",
						["startPort"] = "Out",
						["endQuest"] = "17567237974603819",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "17501697658501905169",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "176310176044715871010",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "17533426145237492",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310176044715871010",
						["startPort"] = "Out",
						["endQuest"] = "17501695937701904156",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310189810115873141",
						["startPort"] = "Out",
						["endQuest"] = "176310189810115873139",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310190755615873306",
						["startPort"] = "Out",
						["endQuest"] = "176310190755615873304",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "176310195580715874119",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310195580715874119",
						["startPort"] = "Out",
						["endQuest"] = "176310189810115873140",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "176310189810115873141",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "176310200520115875220",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310200520115875220",
						["startPort"] = "Out",
						["endQuest"] = "176310190755615873305",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "176310190755615873306",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "176310102113615865962",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "176311967456320652889",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "176311966486720652720",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176311966486720652720",
						["startPort"] = "Out",
						["endQuest"] = "176310102285415866007",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176311967456320652889",
						["startPort"] = "Out",
						["endQuest"] = "176310102508215866062",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111266",
						["startPort"] = "Out",
						["endQuest"] = "176312020978522670719",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312020978522670719",
						["startPort"] = "Out",
						["endQuest"] = "176310165300015868915",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346693873699237",
						["startPort"] = "false",
						["endQuest"] = "176312518792426047911",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312518792426047911",
						["startPort"] = "true",
						["endQuest"] = "17533562710342721246",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312518792426047911",
						["startPort"] = "false",
						["endQuest"] = "176312546095126048312",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312546095126048312",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111244",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17533422381473731",
						["startPort"] = "Out",
						["endQuest"] = "17533429615719357",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17501517483363111243"] = {
						["key"] = "17501517483363111243",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -916.010430745725,
							["y"] = -101.64458482693783
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17501517483363111244"] = {
						["key"] = "17501517483363111244",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3053.712541562036,
							["y"] = 972.6921584910509
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17501517483363111245"] = {
						["key"] = "17501517483363111245",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = -27.888181173665075,
							["y"] = 1337.5272329820716
						},
						["propsData"] = {}
					},
					["17501517483363111246"] = {
						["key"] = "17501517483363111246",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = -648.9924857120553,
							["y"] = 1316.166104682385
						},
						["propsData"] = {}
					},
					["17501517483363111247"] = {
						["key"] = "17501517483363111247",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = -345.6194196726222,
							["y"] = 1331.0031986835797
						},
						["propsData"] = {}
					},
					["17501517483363111248"] = {
						["key"] = "17501517483363111248",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 3279.357333006322,
							["y"] = -1036.019475975945
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1980046,
							["StateId"] = 118012,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_Stone01"
						}
					},
					["17501517483363111249"] = {
						["key"] = "17501517483363111249",
						["type"] = "SendMessageNode",
						["name"] = "探索组初始化",
						["pos"] = {
							["x"] = -1525.2686616420676,
							["y"] = -621.4166150823587
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "East01_Nai01_Init",
							["UnitId"] = -1
						}
					},
					["17501517483363111250"] = {
						["key"] = "17501517483363111250",
						["type"] = "SendMessageNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 3298.4260155870993,
							["y"] = -859.1601883433148
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "East01_Batt01_StoneInOrder01",
							["UnitId"] = -1
						}
					},
					["17501517483363111251"] = {
						["key"] = "17501517483363111251",
						["type"] = "CommonBlackFadeInOutNode",
						["name"] = "对话黑屏淡入淡出节点",
						["pos"] = {
							["x"] = -1275.2771956304562,
							["y"] = -636.2764267914513
						},
						["propsData"] = {
							["FadeTime"] = 0,
							["FadeType"] = "FadeOut"
						}
					},
					["17501517483363111252"] = {
						["key"] = "17501517483363111252",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "阶段变量=0",
						["pos"] = {
							["x"] = -539.9947484999338,
							["y"] = -79.36963082234381
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17501517483363111253"] = {
						["key"] = "17501517483363111253",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "阶段变量=1",
						["pos"] = {
							["x"] = -533.695434612179,
							["y"] = 121.62250418291222
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["17501517483363111254"] = {
						["key"] = "17501517483363111254",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -206.26746354939957,
							["y"] = 102.0519070235861
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Batt02Phase02",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17501517483363111255"] = {
						["key"] = "17501517483363111255",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -210.4630259120599,
							["y"] = 319.4308485939733
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Batt02Phase03",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17501517483363111256"] = {
						["key"] = "17501517483363111256",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2868.352601133917,
							["y"] = -608.3923772537844
						},
						["propsData"] = {
							["VarName"] = "East01Batt02Phase",
							["VarValue"] = 1
						}
					},
					["17501517483363111257"] = {
						["key"] = "17501517483363111257",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1760.580399157117,
							["y"] = -958.6025677511143
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_01_04",
							["NewDetail"] = "Content_Batt02_01_04",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17501517483363111258"] = {
						["key"] = "17501517483363111258",
						["type"] = "TalkNode",
						["name"] = "开车- 这是哪里",
						["pos"] = {
							["x"] = -153.19733702482677,
							["y"] = -1248.150323963086
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12019202,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17501517483363111259"] = {
						["key"] = "17501517483363111259",
						["type"] = "TalkNode",
						["name"] = "站桩 - 和刻舟",
						["pos"] = {
							["x"] = 425.5701609570671,
							["y"] = -803.7558225492984
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1201/120105/12019301.12019301'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_50",
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
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
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
					["17501517483363111261"] = {
						["key"] = "17501517483363111261",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "刻舟",
						["pos"] = {
							["x"] = -141.2887174186273,
							["y"] = -644.7116980728474
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250101
							}
						}
					},
					["17501517483363111262"] = {
						["key"] = "17501517483363111262",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁刻舟",
						["pos"] = {
							["x"] = 430.7462468745679,
							["y"] = -640.9467585497296
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250101
							}
						}
					},
					["17501517483363111263"] = {
						["key"] = "17501517483363111263",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 114.61756195786734,
							["y"] = -819.3996484065137
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_01_01",
							["NewDetail"] = "Content_Batt02_01_01",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17501517483363111265"] = {
						["key"] = "17501517483363111265",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 713.3023192912148,
							["y"] = -802.5049192405838
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_01_02",
							["NewDetail"] = "Content_Batt02_01_02",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17501517483363111266"] = {
						["key"] = "17501517483363111266",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 989.8384616974334,
							["y"] = -636.4165212764341
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250127,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250127"
						}
					},
					["17501517483363111267"] = {
						["key"] = "17501517483363111267",
						["type"] = "TalkNode",
						["name"] = "开车- 提示机关特点",
						["pos"] = {
							["x"] = 3311.8991295214005,
							["y"] = -728.9374471730965
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12019001,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17501517483363111268"] = {
						["key"] = "17501517483363111268",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待石碑完成",
						["pos"] = {
							["x"] = 3330.6565766266244,
							["y"] = -569.1936454804843
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1980046,
							["StateId"] = 118015,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17501517483363111269"] = {
						["key"] = "17501517483363111269",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2799.21109289076,
							["y"] = -1328.1177693207835
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_01_05",
							["NewDetail"] = "Content_Batt02_01_05",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17501693226651902260"] = {
						["key"] = "17501693226651902260",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 123.560974023957,
							["y"] = -648.6622637189165
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2250121,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250121"
						}
					},
					["17501695937701904156"] = {
						["key"] = "17501695937701904156",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G1",
						["pos"] = {
							["x"] = 1013.1418059214528,
							["y"] = 309.17007526955024
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250237,
								2250238,
								2250239,
								2250240,
								2250241,
								2250242,
								2250243
							}
						}
					},
					["17501697218031905003"] = {
						["key"] = "17501697218031905003",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物Group1",
						["pos"] = {
							["x"] = 1501.2667300561868,
							["y"] = -629.9109590021858
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 21,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "MonsterPoint_Batt02Group1"
						}
					},
					["17501697658501905169"] = {
						["key"] = "17501697658501905169",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1735.515150888731,
							["y"] = -1356.6225166205454
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12019501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17533422381473731"] = {
						["key"] = "17533422381473731",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2436.772573401831,
							["y"] = -1252.9641871807146
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250125,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250125"
						}
					},
					["17533426145237492"] = {
						["key"] = "17533426145237492",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1723.1698330049721,
							["y"] = -1682.6500087642091
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_01_03",
							["NewDetail"] = "Content_Batt02_01_03",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17533427780468902"] = {
						["key"] = "17533427780468902",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成钩锁",
						["pos"] = {
							["x"] = -186.19141604010068,
							["y"] = -93.49050936163893
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250089,
								2250090,
								2250091
							}
						}
					},
					["17533429615719357"] = {
						["key"] = "17533429615719357",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2425.813789280895,
							["y"] = -619.0602343992434
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250126,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250126"
						}
					},
					["1753346671388698493"] = {
						["key"] = "1753346671388698493",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "阶段变量=2",
						["pos"] = {
							["x"] = -539.4418851351649,
							["y"] = 369.22464068439376
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["1753346693873699237"] = {
						["key"] = "1753346693873699237",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "阶段变量=3",
						["pos"] = {
							["x"] = -549.9889046711806,
							["y"] = 594.4877985791306
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "3"
								}
							}
						}
					},
					["1753354149846719362"] = {
						["key"] = "1753354149846719362",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -206.72574677644388,
							["y"] = 534.0106313964679
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Batt02Phase04",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17533562710342721246"] = {
						["key"] = "17533562710342721246",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -209.44444693593354,
							["y"] = 729.1882629754152
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Batt02Phase05",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17567237974603819"] = {
						["key"] = "17567237974603819",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤剧情魅影",
						["pos"] = {
							["x"] = 2023.3940006520597,
							["y"] = -1349.998390608584
						},
						["propsData"] = {
							["IsCreate"] = true,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								2250219
							}
						}
					},
					["17567237974603820"] = {
						["key"] = "17567237974603820",
						["type"] = "CreatePhantomNode",
						["name"] = "销毁剧情魅影",
						["pos"] = {
							["x"] = 1738.0273090305393,
							["y"] = -1197.5811053878592
						},
						["propsData"] = {
							["IsCreate"] = false,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								2250219
							}
						}
					},
					["17571581256121302984"] = {
						["key"] = "17571581256121302984",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2816.7062254051407,
							["y"] = -1164.7503288764906
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_QuestTrigger_2250126"
						}
					},
					["17571581355971303229"] = {
						["key"] = "17571581355971303229",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2870.2119367990103,
							["y"] = -784.7438902686592
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_QuestTrigger_2250126"
						}
					},
					["176276393603931750485"] = {
						["key"] = "176276393603931750485",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = -1151.125,
							["y"] = 579.75
						},
						["propsData"] = {
							["NewDescription"] = "",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176310102113615865962"] = {
						["key"] = "176310102113615865962",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG1",
						["pos"] = {
							["x"] = 1281.2958000629962,
							["y"] = -1451.077085503674
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250229,
								2250230,
								2250231,
								2250232,
								2250233,
								2250234,
								2250235
							}
						}
					},
					["176310102285415866007"] = {
						["key"] = "176310102285415866007",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG2",
						["pos"] = {
							["x"] = 1281.0918526945752,
							["y"] = -1320.6781282555114
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250244,
								2250245,
								2250246,
								2250247,
								2250248,
								2250249,
								2250250
							}
						}
					},
					["176310102508215866062"] = {
						["key"] = "176310102508215866062",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG3",
						["pos"] = {
							["x"] = 1282.8737221409183,
							["y"] = -1174.9463102602747
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250258,
								2250259,
								2250260,
								2250261,
								2250262,
								2250263,
								2250264
							}
						}
					},
					["176310165300015868915"] = {
						["key"] = "176310165300015868915",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G1",
						["pos"] = {
							["x"] = 1001.0883352547297,
							["y"] = 20.996585581151393
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250229,
								2250230,
								2250231,
								2250232,
								2250233,
								2250234,
								2250235
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310176044715871010"] = {
						["key"] = "176310176044715871010",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1014.8037502744929,
							["y"] = 149.98189857855084
						},
						["propsData"] = {
							["WaitTime"] = 4.5
						}
					},
					["176310189810115873139"] = {
						["key"] = "176310189810115873139",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G2",
						["pos"] = {
							["x"] = 1476.864876179145,
							["y"] = 305.34140702815756
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250251,
								2250252,
								2250253,
								2250254,
								2250255,
								2250256,
								2250257
							}
						}
					},
					["176310189810115873140"] = {
						["key"] = "176310189810115873140",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G2",
						["pos"] = {
							["x"] = 1471.2399769409935,
							["y"] = -20.213035041193628
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250244,
								2250245,
								2250246,
								2250247,
								2250248,
								2250249,
								2250250
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310189810115873141"] = {
						["key"] = "176310189810115873141",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1474.2411062464707,
							["y"] = 128.5937065276343
						},
						["propsData"] = {
							["WaitTime"] = 8
						}
					},
					["176310190755615873304"] = {
						["key"] = "176310190755615873304",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G3",
						["pos"] = {
							["x"] = 1938.0013939441453,
							["y"] = 309.37295649004767
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250265,
								2250266,
								2250267,
								2250268,
								2250269,
								2250270,
								2250271
							}
						}
					},
					["176310190755615873305"] = {
						["key"] = "176310190755615873305",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G3",
						["pos"] = {
							["x"] = 1936.7462426051536,
							["y"] = -34.766919752973074
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250258,
								2250259,
								2250260,
								2250261,
								2250262,
								2250263,
								2250264
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310190755615873306"] = {
						["key"] = "176310190755615873306",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1928.3188004820593,
							["y"] = 117.6112503872835
						},
						["propsData"] = {
							["WaitTime"] = 12
						}
					},
					["176310195580715874119"] = {
						["key"] = "176310195580715874119",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1469.1244197842366,
							["y"] = -196.36438543508945
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["176310200520115875220"] = {
						["key"] = "176310200520115875220",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1927.261637829349,
							["y"] = -196.7090062817806
						},
						["propsData"] = {
							["WaitTime"] = 8
						}
					},
					["176311966486720652720"] = {
						["key"] = "176311966486720652720",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 989.5816737962414,
							["y"] = -1339.920556330599
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["176311967456320652889"] = {
						["key"] = "176311967456320652889",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 989.9566737962414,
							["y"] = -1191.6308344958986
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["176312020978522670719"] = {
						["key"] = "176312020978522670719",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1001.1887312125097,
							["y"] = -157.76139505843489
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["176312518792426047911"] = {
						["key"] = "176312518792426047911",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "阶段变量=4",
						["pos"] = {
							["x"] = -563.0478159847412,
							["y"] = 844.1213453895227
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "4"
								}
							}
						}
					},
					["176312546095126048312"] = {
						["key"] = "176312546095126048312",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -206.55336364915092,
							["y"] = 940.1213453895227
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Batt02Phase06",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {
					["173702325391818809635"] = {
						["key"] = "173702325391818809635",
						["name"] = "幻境初始化",
						["position"] = {
							["x"] = -1593.1415622878,
							["y"] = -720.9410265606591
						},
						["size"] = {
							["width"] = 610.909090909091,
							["height"] = 248.1818181818182
						}
					},
					["173702336979418811119"] = {
						["key"] = "173702336979418811119",
						["name"] = "判断玩家当前阶段",
						["position"] = {
							["x"] = -633.5469792392701,
							["y"] = -196.2655594838762
						},
						["size"] = {
							["width"] = 900.6737274910191,
							["height"] = 1274.0688811621978
						}
					},
					["17571577626801299157"] = {
						["key"] = "17571577626801299157",
						["name"] = "魅影",
						["position"] = {
							["x"] = 1651.9009289214393,
							["y"] = -1464.48524282735
						},
						["size"] = {
							["width"] = 653.2133920864442,
							["height"] = 417.8084956054397
						}
					},
					["176310159137615868477"] = {
						["key"] = "176310159137615868477",
						["name"] = "机关",
						["position"] = {
							["x"] = 900.6058877822943,
							["y"] = -1522.2058449021708
						},
						["size"] = {
							["width"] = 652.8507860139471,
							["height"] = 467.28528857157175
						}
					},
					["176310187497915872672"] = {
						["key"] = "176310187497915872672",
						["name"] = "G1",
						["position"] = {
							["x"] = 933.2634184667127,
							["y"] = -287.0876114844023
						},
						["size"] = {
							["width"] = 348.1406237505814,
							["height"] = 753.4410489618529
						}
					},
					["176310191782915873448"] = {
						["key"] = "176310191782915873448",
						["name"] = "G2",
						["position"] = {
							["x"] = 1413.648229308046,
							["y"] = -298.98343305413704
						},
						["size"] = {
							["width"] = 315.01190476190476,
							["height"] = 771.2009803921569
						}
					},
					["176310202237615875382"] = {
						["key"] = "176310202237615875382",
						["name"] = "G3",
						["position"] = {
							["x"] = 1887.2616378293492,
							["y"] = -289.24109927852146
						},
						["size"] = {
							["width"] = 315.7142857142857,
							["height"] = 754.2857142857143
						}
					},
					["176310212180215877495"] = {
						["key"] = "176310212180215877495",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 2394.804822714639,
							["y"] = -1434.8657859953144
						},
						["size"] = {
							["width"] = 693.3333333333334,
							["height"] = 439.99999999999994
						}
					},
					["176310212492015877583"] = {
						["key"] = "176310212492015877583",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 2365.0758849857016,
							["y"] = -873.0928922224207
						},
						["size"] = {
							["width"] = 838.3333333333334,
							["height"] = 441.6666666666667
						}
					}
				}
			}
		},
		["17501517483363111241"] = {
			["isStoryNode"] = true,
			["key"] = "17501517483363111241",
			["type"] = "StoryNode",
			["name"] = "【变量=1】",
			["pos"] = {
				["x"] = 1351.1630013778833,
				["y"] = 302.83427159216643
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Batt01_02_01",
				["QuestDeatil"] = "Content_Batt01_02_01",
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
						["startQuest"] = "17501517483363111273",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111274",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111270",
						["startPort"] = "QuestStart",
						["endQuest"] = "17501517483363111273",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111278",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111271",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17501517483363111270",
						["startPort"] = "QuestStart",
						["endQuest"] = "1753343753541680659",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343753541680659",
						["startPort"] = "true",
						["endQuest"] = "1753343726773679537",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344294905686809",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111276",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344294905686809",
						["startPort"] = "Out",
						["endQuest"] = "1753344237937686104",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111276",
						["startPort"] = "Out",
						["endQuest"] = "1753344300546686925",
						["endPort"] = "Branch_1"
					},
					{
						["startQuest"] = "1753344237937686104",
						["startPort"] = "Out",
						["endQuest"] = "1753344300546686925",
						["endPort"] = "Branch_2"
					},
					{
						["startQuest"] = "1753344117753685014",
						["startPort"] = "Out",
						["endQuest"] = "1753344758621690842",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344300546686925",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111278",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343753541680659",
						["startPort"] = "true",
						["endQuest"] = "1753344117753685014",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343713869679079",
						["startPort"] = "Out",
						["endQuest"] = "1753344294905686809",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343713869679079",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111279",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344117753685014",
						["startPort"] = "Out",
						["endQuest"] = "1753343713869679079",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344117753685014",
						["startPort"] = "Out",
						["endQuest"] = "17571581833031946634",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343713869679079",
						["startPort"] = "Out",
						["endQuest"] = "17571582376031946828",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343753541680659",
						["startPort"] = "false",
						["endQuest"] = "17501517483363111271",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1753343753541680659",
						["startPort"] = "true",
						["endQuest"] = "176310247120316551718",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343753541680659",
						["startPort"] = "true",
						["endQuest"] = "176310253130216552532",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343753541680659",
						["startPort"] = "true",
						["endQuest"] = "176310268741716553752",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343753541680659",
						["startPort"] = "true",
						["endQuest"] = "176310298374816556177",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343753541680659",
						["startPort"] = "true",
						["endQuest"] = "176310298557016556238",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310298557016556238",
						["startPort"] = "Out",
						["endQuest"] = "176310270460316554250",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310298374816556177",
						["startPort"] = "Out",
						["endQuest"] = "176310288985416555453",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310268741716553752",
						["startPort"] = "Out",
						["endQuest"] = "176310270246516554190",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310335303116561400",
						["startPort"] = "Out",
						["endQuest"] = "176310335303116561398",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310336484816561766",
						["startPort"] = "Out",
						["endQuest"] = "176310336484816561764",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310336242716561704",
						["startPort"] = "Out",
						["endQuest"] = "176310270246516554191",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344117753685014",
						["startPort"] = "Out",
						["endQuest"] = "176310335303116561399",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344117753685014",
						["startPort"] = "Out",
						["endQuest"] = "176310335303116561400",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344117753685014",
						["startPort"] = "Out",
						["endQuest"] = "176310335737616561543",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310335737616561543",
						["startPort"] = "Out",
						["endQuest"] = "176310336242716561703",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344117753685014",
						["startPort"] = "Out",
						["endQuest"] = "176310336242716561704",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344117753685014",
						["startPort"] = "Out",
						["endQuest"] = "176310336916316561849",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344117753685014",
						["startPort"] = "Out",
						["endQuest"] = "176310336484816561766",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310336916316561849",
						["startPort"] = "Out",
						["endQuest"] = "176310336484816561765",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753343753541680659",
						["startPort"] = "true",
						["endQuest"] = "176310350796316565112",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310474920716569716",
						["startPort"] = "Out",
						["endQuest"] = "176310474920716569714",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310474989316569740",
						["startPort"] = "Out",
						["endQuest"] = "176310474989316569738",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310350796316565112",
						["startPort"] = "Out",
						["endQuest"] = "176310474920716569715",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310350796316565112",
						["startPort"] = "Out",
						["endQuest"] = "176310474920716569716",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310350796316565112",
						["startPort"] = "Out",
						["endQuest"] = "176310474989316569739",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310350796316565112",
						["startPort"] = "Out",
						["endQuest"] = "176310474989316569740",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344294905686809",
						["startPort"] = "Out",
						["endQuest"] = "176311999785621998596",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753344294905686809",
						["startPort"] = "Out",
						["endQuest"] = "17646714592615110551",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111274",
						["startPort"] = "Out",
						["endQuest"] = "176543696058960006796",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543696058960006796",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111272",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17501517483363111270"] = {
						["key"] = "17501517483363111270",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -144.35015706687525,
							["y"] = 282.08726284035885
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17501517483363111271"] = {
						["key"] = "17501517483363111271",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1856.4346983453631,
							["y"] = 1859.2503550551335
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17501517483363111272"] = {
						["key"] = "17501517483363111272",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 889.0310252840994,
							["y"] = 1799.679413332477
						},
						["propsData"] = {}
					},
					["17501517483363111273"] = {
						["key"] = "17501517483363111273",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 74.70652300270964,
							["y"] = 1781.1364713164382
						},
						["propsData"] = {}
					},
					["17501517483363111274"] = {
						["key"] = "17501517483363111274",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 342.3611897943317,
							["y"] = 1797.4767679973056
						},
						["propsData"] = {}
					},
					["17501517483363111276"] = {
						["key"] = "17501517483363111276",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "GravityBallSensor01",
						["pos"] = {
							["x"] = 3190.766660435549,
							["y"] = 124.38536500627967
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2250214,
							["StateId"] = 1210151,
							["IsGuideEnable"] = false,
							["GuidePointName"] = "QuestPoint_GravitySensor01"
						}
					},
					["17501517483363111278"] = {
						["key"] = "17501517483363111278",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 3861.8374688209597,
							["y"] = 296.47028042155097
						},
						["propsData"] = {
							["VarName"] = "East01Batt02Phase",
							["VarValue"] = 2
						}
					},
					["17501517483363111279"] = {
						["key"] = "17501517483363111279",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2344.6503873891006,
							["y"] = -367.80279513869743
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_02_03",
							["NewDetail"] = "Content_Batt02_02_03",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1753343713869679079"] = {
						["key"] = "1753343713869679079",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1906.4884775852172,
							["y"] = 285.64282118847325
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 21,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "MonsterPoint_Batt02Group2"
						}
					},
					["1753343726773679537"] = {
						["key"] = "1753343726773679537",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 479.59604240788485,
							["y"] = 50.88640699498822
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_02_01",
							["NewDetail"] = "Content_Batt02_02_01",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1753343753541680659"] = {
						["key"] = "1753343753541680659",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "阶段变量=1",
						["pos"] = {
							["x"] = 162.2640107618878,
							["y"] = 267.1470510703412
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["1753344117753685014"] = {
						["key"] = "1753344117753685014",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1014.90090348435,
							["y"] = 262.4388589290194
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250204,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250204"
						}
					},
					["1753344237937686104"] = {
						["key"] = "1753344237937686104",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "GravityBallSensor02",
						["pos"] = {
							["x"] = 3193.76716222561,
							["y"] = 312.4146176474252
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2250213,
							["StateId"] = 1210151,
							["IsGuideEnable"] = false,
							["GuidePointName"] = "QuestPoint_GravitySensor02"
						}
					},
					["1753344294905686809"] = {
						["key"] = "1753344294905686809",
						["type"] = "BranchQuestStartNode",
						["name"] = "子任务开始节点",
						["pos"] = {
							["x"] = 2835.1837236390247,
							["y"] = 303.71618953129286
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
								}
							},
							["IsSetCountInfo"] = false,
							["IsDifftation"] = false,
							["AllDiffGuideOptions"] = {}
						}
					},
					["1753344300546686925"] = {
						["key"] = "1753344300546686925",
						["type"] = "CheckBranchQuestFinishedNode",
						["name"] = "子任务结束节点",
						["pos"] = {
							["x"] = 3532.7327856880856,
							["y"] = 288.6541404692438
						},
						["propsData"] = {
							["InputBranchQuestNumber"] = 2,
							["BranchQuestFinishOptions"] = {
								{
									["IsNeedFinish"] = true
								},
								{
									["IsNeedFinish"] = true
								}
							}
						}
					},
					["1753344758621690842"] = {
						["key"] = "1753344758621690842",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1443.0704416689039,
							["y"] = -365.06285309678384
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_02_02",
							["NewDetail"] = "Content_Batt02_02_02",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17571581833031946634"] = {
						["key"] = "17571581833031946634",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 1455.69696969697,
							["y"] = -150.75116550116545
						},
						["propsData"] = {
							["IsCreate"] = true,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								2250220
							}
						}
					},
					["17571582376031946828"] = {
						["key"] = "17571582376031946828",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 2362.465034965035,
							["y"] = -142.10955710955704
						},
						["propsData"] = {
							["IsCreate"] = false,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								2250220
							}
						}
					},
					["176310247120316551718"] = {
						["key"] = "176310247120316551718",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "BattNPC_G4",
						["pos"] = {
							["x"] = 95.96428571428567,
							["y"] = -729.4642857142858
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250272,
								2250273,
								2250274,
								2250275,
								2250276,
								2250277,
								2250278
							}
						}
					},
					["176310253130216552532"] = {
						["key"] = "176310253130216552532",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "BattNPC_G5",
						["pos"] = {
							["x"] = 99.28256302521021,
							["y"] = -597.5
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250286,
								2250287,
								2250288,
								2250289,
								2250290,
								2250291,
								2250292
							}
						}
					},
					["176310268741716553752"] = {
						["key"] = "176310268741716553752",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 558.1703735842166,
							["y"] = -924.4352377382738
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["176310270246516554190"] = {
						["key"] = "176310270246516554190",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "BattNPC_G6",
						["pos"] = {
							["x"] = 866.1298631146614,
							["y"] = -910.582298136646
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250300,
								2250301,
								2250302,
								2250303,
								2250304,
								2250305,
								2250306
							}
						}
					},
					["176310270246516554191"] = {
						["key"] = "176310270246516554191",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "怪物_G7",
						["pos"] = {
							["x"] = 1767.9542547198378,
							["y"] = 1426.4711615221363
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250321,
								2250322,
								2250323,
								2250324,
								2250325,
								2250326,
								2250327
							}
						}
					},
					["176310270460316554250"] = {
						["key"] = "176310270460316554250",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "BattNPC_G8",
						["pos"] = {
							["x"] = 871.3141142139021,
							["y"] = -581.0362229599486
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250328,
								2250329,
								2250330,
								2250331,
								2250332,
								2250333,
								2250334
							}
						}
					},
					["176310288985416555453"] = {
						["key"] = "176310288985416555453",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "BattNPC_G7",
						["pos"] = {
							["x"] = 866.2686681869152,
							["y"] = -757.1734445277363
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250314,
								2250315,
								2250316,
								2250317,
								2250318,
								2250319,
								2250320
							}
						}
					},
					["176310298374816556177"] = {
						["key"] = "176310298374816556177",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 561.7905947236469,
							["y"] = -773.1544495609339
						},
						["propsData"] = {
							["WaitTime"] = 1.5
						}
					},
					["176310298557016556238"] = {
						["key"] = "176310298557016556238",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 567.7416816801687,
							["y"] = -600.1363380809597
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["176310335303116561398"] = {
						["key"] = "176310335303116561398",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G6",
						["pos"] = {
							["x"] = 1271.993562913866,
							["y"] = 1228.9399515791004
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250307,
								2250308,
								2250309,
								2250310,
								2250311,
								2250312,
								2250313
							}
						}
					},
					["176310335303116561399"] = {
						["key"] = "176310335303116561399",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G6",
						["pos"] = {
							["x"] = 1281.0939384009891,
							["y"] = 904.6126157368554
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250300,
								2250301,
								2250302,
								2250303,
								2250304,
								2250305,
								2250306
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310335303116561400"] = {
						["key"] = "176310335303116561400",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1267.117045728445,
							["y"] = 1065.2325441188702
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["176310335737616561543"] = {
						["key"] = "176310335737616561543",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1767.6293405823772,
							["y"] = 929.6040868616394
						},
						["propsData"] = {
							["WaitTime"] = 1.5
						}
					},
					["176310336242716561703"] = {
						["key"] = "176310336242716561703",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G7",
						["pos"] = {
							["x"] = 1767.295399411375,
							["y"] = 1088.9802182716205
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250314,
								2250315,
								2250316,
								2250317,
								2250318,
								2250319,
								2250320
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310336242716561704"] = {
						["key"] = "176310336242716561704",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1766.3700117555527,
							["y"] = 1244.7660329412608
						},
						["propsData"] = {
							["WaitTime"] = 5.5
						}
					},
					["176310336484816561764"] = {
						["key"] = "176310336484816561764",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G8",
						["pos"] = {
							["x"] = 2210.79014215461,
							["y"] = 996.4512157344723
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250335,
								2250336,
								2250337,
								2250338,
								2250339,
								2250340,
								2250341
							}
						}
					},
					["176310336484816561765"] = {
						["key"] = "176310336484816561765",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G8",
						["pos"] = {
							["x"] = 2210.4033381545537,
							["y"] = 679.9443927127401
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250328,
								2250329,
								2250330,
								2250331,
								2250332,
								2250333,
								2250334
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310336484816561766"] = {
						["key"] = "176310336484816561766",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2210.785419840983,
							["y"] = 825.1797057101395
						},
						["propsData"] = {
							["WaitTime"] = 7
						}
					},
					["176310336916316561849"] = {
						["key"] = "176310336916316561849",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2207.4443027369275,
							["y"] = 517.2441810352002
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["176310350796316565112"] = {
						["key"] = "176310350796316565112",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = -759.1366114416982,
							["y"] = -1436.7957535867208
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2250228,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250228"
						}
					},
					["176310474920716569714"] = {
						["key"] = "176310474920716569714",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G4",
						["pos"] = {
							["x"] = -349.07804299888016,
							["y"] = -1555.0482714002662
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250279,
								2250280,
								2250281,
								2250282,
								2250283,
								2250284,
								2250285
							}
						}
					},
					["176310474920716569715"] = {
						["key"] = "176310474920716569715",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G4",
						["pos"] = {
							["x"] = -353.4776675117571,
							["y"] = -1870.3756072425113
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250272,
								2250273,
								2250274,
								2250275,
								2250276,
								2250277,
								2250278
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310474920716569716"] = {
						["key"] = "176310474920716569716",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = -352.4545601843013,
							["y"] = -1718.7556788604963
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["176310474989316569738"] = {
						["key"] = "176310474989316569738",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G5",
						["pos"] = {
							["x"] = -370.8962248170623,
							["y"] = -933.230089582084
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250293,
								2250294,
								2250295,
								2250296,
								2250297,
								2250298,
								2250299
							}
						}
					},
					["176310474989316569739"] = {
						["key"] = "176310474989316569739",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G5",
						["pos"] = {
							["x"] = -368.7503947844847,
							["y"] = -1231.2392436061473
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250286,
								2250287,
								2250288,
								2250289,
								2250290,
								2250291,
								2250292
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310474989316569740"] = {
						["key"] = "176310474989316569740",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = -371.2727420024834,
							["y"] = -1105.9374970423141
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["176311999785621998596"] = {
						["key"] = "176311999785621998596",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3203.4496370677225,
							["y"] = -213.465401545438
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12019610,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17646714592615110551"] = {
						["key"] = "17646714592615110551",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 3196.3122648832245,
							["y"] = 604.0930260009342
						},
						["propsData"] = {
							["GuideId"] = 94
						}
					},
					["176543696058960006796"] = {
						["key"] = "176543696058960006796",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 628.3076923076922,
							["y"] = 1803.747252747253
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "BallsensorReset",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {
					["176310265606616553297"] = {
						["key"] = "176310265606616553297",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 32.318277310924486,
							["y"] = -815.9821428571429
						},
						["size"] = {
							["width"] = 343.75000000000006,
							["height"] = 351.25000000000006
						}
					},
					["176310272435916554660"] = {
						["key"] = "176310272435916554660",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 467.9108158630771,
							["y"] = -997.2725690726066
						},
						["size"] = {
							["width"] = 716.6085251706829,
							["height"] = 550.3519047902495
						}
					},
					["176310326238016559322"] = {
						["key"] = "176310326238016559322",
						["name"] = "魅影",
						["position"] = {
							["x"] = 1354.4730531358093,
							["y"] = -240.40412455609916
						},
						["size"] = {
							["width"] = 1212.792575071986,
							["height"] = 244.07008432743737
						}
					},
					["176310329842416560182"] = {
						["key"] = "176310329842416560182",
						["name"] = "机关球",
						["position"] = {
							["x"] = 2792.8591596763276,
							["y"] = 39.77784788322646
						},
						["size"] = {
							["width"] = 1281.8181818181818,
							["height"] = 466.3636363636363
						}
					},
					["176310341237716562720"] = {
						["key"] = "176310341237716562720",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1216.4033162126454,
							["y"] = 827.8879362565871
						},
						["size"] = {
							["width"] = 295.5555555555555,
							["height"] = 564.4444444444445
						}
					},
					["176310341573616562825"] = {
						["key"] = "176310341573616562825",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1738.4303439268583,
							["y"] = 841.271295015804
						},
						["size"] = {
							["width"] = 261.11111111111103,
							["height"] = 714.4444444444446
						}
					},
					["176310341881816562911"] = {
						["key"] = "176310341881816562911",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 2165.816766505043,
							["y"] = 414.05211754313666
						},
						["size"] = {
							["width"] = 281.06531067159045,
							["height"] = 736.1041239742447
						}
					},
					["176310475355916569822"] = {
						["key"] = "176310475355916569822",
						["name"] = "G4",
						["position"] = {
							["x"] = -403.64793202984765,
							["y"] = -1949.0301211395702
						},
						["size"] = {
							["width"] = 338.18181818181824,
							["height"] = 575.4545454545456
						}
					},
					["176310475604916569881"] = {
						["key"] = "176310475604916569881",
						["name"] = "G5",
						["position"] = {
							["x"] = -390.01156839348414,
							["y"] = -1316.3028484122974
						},
						["size"] = {
							["width"] = 267.27272727272765,
							["height"] = 540.0000000000002
						}
					}
				}
			}
		},
		["17501517483363111242"] = {
			["isStoryNode"] = true,
			["key"] = "17501517483363111242",
			["type"] = "StoryNode",
			["name"] = "【变量=5】",
			["pos"] = {
				["x"] = 2463.9762179240392,
				["y"] = 298.7688551056974
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Batt02_05_01",
				["QuestDeatil"] = "Content_Batt02_05_01",
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
						["startQuest"] = "17501517483363111282",
						["startPort"] = "QuestStart",
						["endQuest"] = "17501517483363111287",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111288",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111284",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17571587203351957891",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957892",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957892",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957890",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957893",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957894",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957899",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957900",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957893",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957898",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957901",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957891",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957893",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957899",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957893",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957902",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957902",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957896",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957899",
						["startPort"] = "Out",
						["endQuest"] = "17571587203351957897",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111282",
						["startPort"] = "QuestStart",
						["endQuest"] = "17571587203351957893",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111282",
						["startPort"] = "QuestStart",
						["endQuest"] = "17571587203351957895",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571587203351957896",
						["startPort"] = "Out",
						["endQuest"] = "17650346823301917442",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17650346823301917442",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111286",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17501517483363111287",
						["startPort"] = "Out",
						["endQuest"] = "176525021745824367717",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176525021745824367717",
						["startPort"] = "Out",
						["endQuest"] = "176525021831224367753",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176525021831224367753",
						["startPort"] = "Out",
						["endQuest"] = "17501517483363111288",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17501517483363111282"] = {
						["key"] = "17501517483363111282",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 3679.3285589410584,
							["y"] = 418.6582417582418
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17501517483363111283"] = {
						["key"] = "17501517483363111283",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 5473.886064915476,
							["y"] = 780.4405137346312
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17501517483363111284"] = {
						["key"] = "17501517483363111284",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 5155.571694971695,
							["y"] = 824.511197136197
						},
						["propsData"] = {}
					},
					["17501517483363111285"] = {
						["key"] = "17501517483363111285",
						["type"] = "GoToNode",
						["name"] = "GOTO - 触发离开幻境",
						["pos"] = {
							["x"] = 3774.370849975793,
							["y"] = -190.75252663462675
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250170,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250170"
						}
					},
					["17501517483363111286"] = {
						["key"] = "17501517483363111286",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 5569.050542341354,
							["y"] = 443.44581740928464
						},
						["propsData"] = {}
					},
					["17501517483363111287"] = {
						["key"] = "17501517483363111287",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 4201.77323054697,
							["y"] = 787.2809465522447
						},
						["propsData"] = {}
					},
					["17501517483363111288"] = {
						["key"] = "17501517483363111288",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 4837.8865563266645,
							["y"] = 802.7544041898026
						},
						["propsData"] = {}
					},
					["1753353970651717641"] = {
						["key"] = "1753353970651717641",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成离开点",
						["pos"] = {
							["x"] = 3555.8897849462364,
							["y"] = 14.483486943164337
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250169
							}
						}
					},
					["1753353984324717821"] = {
						["key"] = "1753353984324717821",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 3870.377450980392,
							["y"] = -1.2997198879551775
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 2250169,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Drop_Leave_2250169",
							["IsUseCount"] = false
						}
					},
					["17571587203351957890"] = {
						["key"] = "17571587203351957890",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 6050.113442922332,
							["y"] = 939.3897554178212
						},
						["propsData"] = {}
					},
					["17571587203351957891"] = {
						["key"] = "17571587203351957891",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 5513.793916385026,
							["y"] = 992.2334933765471
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250223
							}
						}
					},
					["17571587203351957892"] = {
						["key"] = "17571587203351957892",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 5777.289154480264,
							["y"] = 954.9287314717853
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11062,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_LeaveBatt02",
							["IsUseCount"] = false
						}
					},
					["17571587203351957893"] = {
						["key"] = "17571587203351957893",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 4185.265090309141,
							["y"] = 431.2891332609596
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250170,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250170"
						}
					},
					["17571587203351957894"] = {
						["key"] = "17571587203351957894",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 4627.0679249358145,
							["y"] = -392.6891841904227
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12019701,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17571587203351957895"] = {
						["key"] = "17571587203351957895",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 4189.7807779239,
							["y"] = 587.1813152533741
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250224,
								2250225
							}
						}
					},
					["17571587203351957896"] = {
						["key"] = "17571587203351957896",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 4917.868146076902,
							["y"] = 426.6243127873159
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2250225,
							["StateId"] = 118012,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_XingshibeiBatt02Leave01"
						}
					},
					["17571587203351957897"] = {
						["key"] = "17571587203351957897",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 4916.991535432643,
							["y"] = 119.89803318456576
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250218
							},
							["ManualItemIdList"] = {},
							["StateId"] = 118012,
							["QuestId"] = 0
						}
					},
					["17571587203351957898"] = {
						["key"] = "17571587203351957898",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 4617.502548928952,
							["y"] = 179.6376643480359
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Batt02_SeqLeave",
							["UnitId"] = -1
						}
					},
					["17571587203351957899"] = {
						["key"] = "17571587203351957899",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 4624.5420132314175,
							["y"] = 4.5481028775146015
						},
						["propsData"] = {
							["WaitTime"] = 9
						}
					},
					["17571587203351957900"] = {
						["key"] = "17571587203351957900",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 4906.624652315761,
							["y"] = -53.78919625266383
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Batt02_SeqLeaveLoopStart",
							["UnitId"] = -1
						}
					},
					["17571587203351957901"] = {
						["key"] = "17571587203351957901",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 5515.523000758422,
							["y"] = 1176.7529705379352
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Batt02_SeqLeaveLoopEnd",
							["UnitId"] = -1
						}
					},
					["17571587203351957902"] = {
						["key"] = "17571587203351957902",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 4626.396186396314,
							["y"] = 431.4262707671178
						},
						["propsData"] = {
							["WaitTime"] = 7
						}
					},
					["17650346823301917442"] = {
						["key"] = "17650346823301917442",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 5237.473039215686,
							["y"] = 438.6775025799795
						},
						["propsData"] = {}
					},
					["176525021745824367717"] = {
						["key"] = "176525021745824367717",
						["type"] = "SendMessageNode",
						["name"] = "发送消息-Batt02_SeqLeaveDestory",
						["pos"] = {
							["x"] = 4514.629901960785,
							["y"] = 761.5392156862745
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Batt02_SeqLeaveDestory",
							["UnitId"] = -1
						}
					},
					["176525021831224367753"] = {
						["key"] = "176525021831224367753",
						["type"] = "SendMessageNode",
						["name"] = "发送消息-Batt02_SeqLeaveLoopEnd",
						["pos"] = {
							["x"] = 4514.629901960785,
							["y"] = 946.5392156862745
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Batt02_SeqLeaveLoopEnd",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {
					["176525020085124367394"] = {
						["key"] = "176525020085124367394",
						["name"] = "刻舟移动",
						["position"] = {
							["x"] = 4539.629901960785,
							["y"] = -145.12745098039215
						},
						["size"] = {
							["width"] = 689.9999999999994,
							["height"] = 463.33333333333337
						}
					},
					["176525026262224368430"] = {
						["key"] = "176525026262224368430",
						["name"] = "销毁刻舟移动",
						["position"] = {
							["x"] = 4452.963235294118,
							["y"] = 673.2058823529412
						},
						["size"] = {
							["width"] = 321.6666666666665,
							["height"] = 426.6666666666667
						}
					}
				}
			}
		},
		["1753346561265696880"] = {
			["isStoryNode"] = true,
			["key"] = "1753346561265696880",
			["type"] = "StoryNode",
			["name"] = "【变量=2】",
			["pos"] = {
				["x"] = 1620.9626024877741,
				["y"] = 299.7576861226747
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
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
						["startQuest"] = "1753346561265696888",
						["startPort"] = "Out",
						["endQuest"] = "1753346561265696889",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561265696885",
						["startPort"] = "QuestStart",
						["endQuest"] = "1753346561265696888",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561265696889",
						["startPort"] = "Out",
						["endQuest"] = "1753346561265696887",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1753346561265696893",
						["startPort"] = "Out",
						["endQuest"] = "1753346561265696886",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1753346561265696885",
						["startPort"] = "QuestStart",
						["endQuest"] = "1753346561266696901",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696901",
						["startPort"] = "true",
						["endQuest"] = "1753346561266696900",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696901",
						["startPort"] = "true",
						["endQuest"] = "1753346561266696905",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "17533558837902053402",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696899",
						["startPort"] = "Out",
						["endQuest"] = "1753346561265696894",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696899",
						["startPort"] = "Out",
						["endQuest"] = "17533558915082053487",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17567236554022132",
						["startPort"] = "Out",
						["endQuest"] = "17567236942212820",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696901",
						["startPort"] = "false",
						["endQuest"] = "1753346561265696886",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1753346561266696901",
						["startPort"] = "true",
						["endQuest"] = "176310857208017918671",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310857208017918671",
						["startPort"] = "Out",
						["endQuest"] = "176310748772917917443",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310857208017918671",
						["startPort"] = "Out",
						["endQuest"] = "176310748772917917444",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310857208017918671",
						["startPort"] = "Out",
						["endQuest"] = "176310860015217919325",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310860015217919325",
						["startPort"] = "Out",
						["endQuest"] = "176310748772917917445",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310860015217919325",
						["startPort"] = "Out",
						["endQuest"] = "176310749151217917542",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310857208017918671",
						["startPort"] = "Out",
						["endQuest"] = "176310838978017918470",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310838978017918470",
						["startPort"] = "Out",
						["endQuest"] = "176310749502217917616",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "1753346561266696909",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310944860117926045",
						["startPort"] = "Out",
						["endQuest"] = "176310944860117926043",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310945857917926309",
						["startPort"] = "Out",
						["endQuest"] = "176310945857917926307",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310952294717926477",
						["startPort"] = "Out",
						["endQuest"] = "176310952294717926475",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310952294717926478",
						["startPort"] = "Out",
						["endQuest"] = "176310952294717926476",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310952810617926604",
						["startPort"] = "Out",
						["endQuest"] = "176310952810617926602",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310952810617926605",
						["startPort"] = "Out",
						["endQuest"] = "176310952810617926603",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310953091617926674",
						["startPort"] = "Out",
						["endQuest"] = "176310953091617926672",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176310953091617926675",
						["startPort"] = "Out",
						["endQuest"] = "176310953091617926673",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310952294717926478",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310952810617926605",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310953091617926675",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310944860117926044",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310945857917926308",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310944860117926045",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310953091617926674",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310952810617926604",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310952294717926477",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "176310945857917926309",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696905",
						["startPort"] = "Out",
						["endQuest"] = "1753346561266696899",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753346561266696899",
						["startPort"] = "Out",
						["endQuest"] = "176355018281815230017",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753347091138702766",
						["startPort"] = "Out",
						["endQuest"] = "1753346561265696893",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176355018281815230017",
						["startPort"] = "Out",
						["endQuest"] = "17567236554022132",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17567236942212820",
						["startPort"] = "Out",
						["endQuest"] = "176511687347611532857",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511687347611532857",
						["startPort"] = "Out",
						["endQuest"] = "1753347091138702766",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1753346561265696885"] = {
						["key"] = "1753346561265696885",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -26.493014209732394,
							["y"] = 291.08726284035885
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1753346561265696886"] = {
						["key"] = "1753346561265696886",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3576.8484512591167,
							["y"] = 1713.4001219549002
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1753346561265696887"] = {
						["key"] = "1753346561265696887",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 568.6761301792044,
							["y"] = 1784.9140536921175
						},
						["propsData"] = {}
					},
					["1753346561265696888"] = {
						["key"] = "1753346561265696888",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 329.34613339232004,
							["y"] = 1511.8848479398148
						},
						["propsData"] = {}
					},
					["1753346561265696889"] = {
						["key"] = "1753346561265696889",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 595.5832177663598,
							["y"] = 1520.362507258045
						},
						["propsData"] = {}
					},
					["1753346561265696893"] = {
						["key"] = "1753346561265696893",
						["type"] = "SetVarNode",
						["name"] = "设置变量值=3",
						["pos"] = {
							["x"] = 3802.4631695392304,
							["y"] = 267.82911972466275
						},
						["propsData"] = {
							["VarName"] = "East01Batt02Phase",
							["VarValue"] = 3
						}
					},
					["1753346561265696894"] = {
						["key"] = "1753346561265696894",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1968.1508718117982,
							["y"] = -481.20190608966595
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_03_03",
							["NewDetail"] = "Content_Batt02_03_03",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1753346561266696899"] = {
						["key"] = "1753346561266696899",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1557.1797028135265,
							["y"] = 234.5877373124175
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 35,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "MonsterPoint_Batt02Group3"
						}
					},
					["1753346561266696900"] = {
						["key"] = "1753346561266696900",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 675.2106190077557,
							["y"] = -466.17443657320825
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_03_01",
							["NewDetail"] = "Content_Batt02_03_01",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1753346561266696901"] = {
						["key"] = "1753346561266696901",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "阶段变量=2",
						["pos"] = {
							["x"] = 266.9060209256371,
							["y"] = 215.79414310873761
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["1753346561266696905"] = {
						["key"] = "1753346561266696905",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 725.4846628622272,
							["y"] = 215.0894305795911
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250203,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250203"
						}
					},
					["1753346561266696909"] = {
						["key"] = "1753346561266696909",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1030.0740990022823,
							["y"] = -470.66060209700953
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_03_02",
							["NewDetail"] = "Content_Batt02_03_02",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1753347091138702766"] = {
						["key"] = "1753347091138702766",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3299.5701230684026,
							["y"] = 233.96246425012708
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250166,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_Xingshibei0301"
						}
					},
					["17533558837902053402"] = {
						["key"] = "17533558837902053402",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 1025.795921861441,
							["y"] = -657.5396787353309
						},
						["propsData"] = {
							["IsCreate"] = true,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								2250221
							}
						}
					},
					["17533558915082053487"] = {
						["key"] = "17533558915082053487",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 1973.8622549091983,
							["y"] = -658.6415288975527
						},
						["propsData"] = {
							["IsCreate"] = false,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								2250221
							}
						}
					},
					["17567236554022132"] = {
						["key"] = "17567236554022132",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2296.196822997975,
							["y"] = 221.98346249254854
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250216,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250216"
						}
					},
					["17567236942212820"] = {
						["key"] = "17567236942212820",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 2585.6704997788593,
							["y"] = 235.06346749226014
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250206
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310451,
							["QuestId"] = 0
						}
					},
					["176310748772917917443"] = {
						["key"] = "176310748772917917443",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG9",
						["pos"] = {
							["x"] = 1082.8271602881125,
							["y"] = -1543.8421450834576
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250342,
								2250343,
								2250344,
								2250345,
								2250346,
								2250347,
								2250348
							}
						}
					},
					["176310748772917917444"] = {
						["key"] = "176310748772917917444",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG10",
						["pos"] = {
							["x"] = 1077.6232129196917,
							["y"] = -1382.4431878352948
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250356,
								2250357,
								2250358,
								2250359,
								2250360,
								2250361,
								2250362
							}
						}
					},
					["176310748772917917445"] = {
						["key"] = "176310748772917917445",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG11",
						["pos"] = {
							["x"] = 1376.0050823660345,
							["y"] = -1250.9447031733916
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250370,
								2250371,
								2250372,
								2250373,
								2250374,
								2250375,
								2250376
							}
						}
					},
					["176310749151217917542"] = {
						["key"] = "176310749151217917542",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG12",
						["pos"] = {
							["x"] = 1380.2714394720617,
							["y"] = -1090.2773730536103
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250439,
								2250440,
								2250441,
								2250442,
								2250443,
								2250444,
								2250445
							}
						}
					},
					["176310749502217917616"] = {
						["key"] = "176310749502217917616",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG13",
						["pos"] = {
							["x"] = 1379.7559612383277,
							["y"] = -920.616722504564
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250391,
								2250392,
								2250393,
								2250394,
								2250395,
								2250396,
								2250397
							}
						}
					},
					["176310838978017918470"] = {
						["key"] = "176310838978017918470",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1077.5431544772407,
							["y"] = -982.7821666488039
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["176310857208017918671"] = {
						["key"] = "176310857208017918671",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 740.7553560687525,
							["y"] = -1183.9360128026497
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2250446,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250446"
						}
					},
					["176310860015217919325"] = {
						["key"] = "176310860015217919325",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1081.791919879754,
							["y"] = -1163.9325846715603
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["176310944860117926043"] = {
						["key"] = "176310944860117926043",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G9",
						["pos"] = {
							["x"] = 1054.80325252094,
							["y"] = 2121.0031321911124
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250349,
								2250350,
								2250351,
								2250352,
								2250353,
								2250354,
								2250355
							}
						}
					},
					["176310944860117926044"] = {
						["key"] = "176310944860117926044",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G9",
						["pos"] = {
							["x"] = 1067.6119372426883,
							["y"] = 1801.338414432538
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250342,
								2250343,
								2250344,
								2250345,
								2250346,
								2250347,
								2250348
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310944860117926045"] = {
						["key"] = "176310944860117926045",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1051.6406354704714,
							["y"] = 1951.3105695352006
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["176310945857917926307"] = {
						["key"] = "176310945857917926307",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G10",
						["pos"] = {
							["x"] = 1475.7829175927102,
							["y"] = 2125.309950372931
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250363,
								2250364,
								2250365,
								2250366,
								2250367,
								2250368,
								2250369
							}
						}
					},
					["176310945857917926308"] = {
						["key"] = "176310945857917926308",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G10",
						["pos"] = {
							["x"] = 1478.3566399084434,
							["y"] = 1805.6452326143565
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250356,
								2250357,
								2250358,
								2250359,
								2250360,
								2250361,
								2250362
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310945857917926309"] = {
						["key"] = "176310945857917926309",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1471.7321426475046,
							["y"] = 1947.0318614012294
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["176310952294717926475"] = {
						["key"] = "176310952294717926475",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G11",
						["pos"] = {
							["x"] = 1914.2227672167705,
							["y"] = 2119.656754884209
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250377,
								2250378,
								2250379,
								2250380,
								2250381,
								2250382,
								2250383
							}
						}
					},
					["176310952294717926476"] = {
						["key"] = "176310952294717926476",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G11",
						["pos"] = {
							["x"] = 1913.8359632167144,
							["y"] = 1804.8165985291434
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250370,
								2250371,
								2250372,
								2250373,
								2250374,
								2250375,
								2250376
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310952294717926477"] = {
						["key"] = "176310952294717926477",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1911.5394734745726,
							["y"] = 1950.2602448598761
						},
						["propsData"] = {
							["WaitTime"] = 6
						}
					},
					["176310952294717926478"] = {
						["key"] = "176310952294717926478",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1910.8769277990882,
							["y"] = 1642.3247201849367
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["176310952810617926602"] = {
						["key"] = "176310952810617926602",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G12",
						["pos"] = {
							["x"] = 2344.5564138333116,
							["y"] = 2124.52047668872
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250384,
								2250385,
								2250386,
								2250387,
								2250388,
								2250389,
								2250390
							}
						}
					},
					["176310952810617926603"] = {
						["key"] = "176310952810617926603",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G12",
						["pos"] = {
							["x"] = 2346.477302140948,
							["y"] = 1809.778359549341
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250439,
								2250440,
								2250441,
								2250442,
								2250443,
								2250444,
								2250445
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310952810617926604"] = {
						["key"] = "176310952810617926604",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2344.5516915196854,
							["y"] = 1953.2489666643876
						},
						["propsData"] = {
							["WaitTime"] = 6
						}
					},
					["176310952810617926605"] = {
						["key"] = "176310952810617926605",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2339.3355744156293,
							["y"] = 1645.313441989448
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["176310953091617926672"] = {
						["key"] = "176310953091617926672",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G13",
						["pos"] = {
							["x"] = 2633.729346164139,
							["y"] = 1187.8663413503746
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250398,
								2250399,
								2250400,
								2250401,
								2250402,
								2250403,
								2250404
							}
						}
					},
					["176310953091617926673"] = {
						["key"] = "176310953091617926673",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G8",
						["pos"] = {
							["x"] = 2633.3425421640827,
							["y"] = 871.3595183286424
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250391,
								2250392,
								2250393,
								2250394,
								2250395,
								2250396,
								2250397
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176310953091617926674"] = {
						["key"] = "176310953091617926674",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2633.7246238505118,
							["y"] = 1016.594831326042
						},
						["propsData"] = {
							["WaitTime"] = 9
						}
					},
					["176310953091617926675"] = {
						["key"] = "176310953091617926675",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2630.3835067464565,
							["y"] = 708.6593066511024
						},
						["propsData"] = {
							["WaitTime"] = 5
						}
					},
					["176355018281815230017"] = {
						["key"] = "176355018281815230017",
						["type"] = "SendMessageNode",
						["name"] = "发送消息-宝箱",
						["pos"] = {
							["x"] = 1957.7736846486846,
							["y"] = 253.17936230436237
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "ActiveTreasure01",
							["UnitId"] = -1
						}
					},
					["176511687347611532857"] = {
						["key"] = "176511687347611532857",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2859.868242696416,
							["y"] = 225.95950063868045
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2250206,
							["StateId"] = 1310451,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {
					["176310911077117922546"] = {
						["key"] = "176310911077117922546",
						["name"] = "机关",
						["position"] = {
							["x"] = 654.177635097016,
							["y"] = -1691.1989112454396
						},
						["size"] = {
							["width"] = 1070,
							["height"] = 923.3333333333334
						}
					},
					["176310912014417922775"] = {
						["key"] = "176310912014417922775",
						["name"] = "魅影",
						["position"] = {
							["x"] = 950.1868219885563,
							["y"] = -745.6168462516096
						},
						["size"] = {
							["width"] = 1317.9770820891783,
							["height"] = 218.02455768196364
						}
					},
					["176310956696117927163"] = {
						["key"] = "176310956696117927163",
						["name"] = "G09",
						["position"] = {
							["x"] = 972.7021951602767,
							["y"] = 1543.6255643305838
						},
						["size"] = {
							["width"] = 343.125,
							["height"] = 738.75
						}
					},
					["176310958844417927572"] = {
						["key"] = "176310958844417927572",
						["name"] = "G10",
						["position"] = {
							["x"] = 1411.3265970741522,
							["y"] = 1540.3600140913493
						},
						["size"] = {
							["width"] = 346.875,
							["height"] = 729.375
						}
					},
					["176310959996417927795"] = {
						["key"] = "176310959996417927795",
						["name"] = "G11",
						["position"] = {
							["x"] = 1861.0587399312951,
							["y"] = 1557.2350140913493
						},
						["size"] = {
							["width"] = 305.3852813852814,
							["height"] = 717.337121212121
						}
					},
					["176310965299317928803"] = {
						["key"] = "176310965299317928803",
						["name"] = "G12",
						["position"] = {
							["x"] = 2241.4440213165763,
							["y"] = 1550.2864210177556
						},
						["size"] = {
							["width"] = 385.7142857142857,
							["height"] = 707.1428571428572
						}
					},
					["176310967157517929155"] = {
						["key"] = "176310967157517929155",
						["name"] = "G13",
						["position"] = {
							["x"] = 2531.857555151163,
							["y"] = 581.2638646267784
						},
						["size"] = {
							["width"] = 395.41322244520956,
							["height"] = 774.8402484411523
						}
					},
					["176311719092619956168"] = {
						["key"] = "176311719092619956168",
						["name"] = "卷轴",
						["position"] = {
							["x"] = 2238.014317209494,
							["y"] = 139.06431385785498
						},
						["size"] = {
							["width"] = 1025.9967826297793,
							["height"] = 260.7523296379684
						}
					}
				}
			}
		},
		["1753348573061710306"] = {
			["isStoryNode"] = true,
			["key"] = "1753348573061710306",
			["type"] = "StoryNode",
			["name"] = "【变量=4】",
			["pos"] = {
				["x"] = 2181.07926915444,
				["y"] = 297.9310779355402
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Batt02_04_01",
				["QuestDeatil"] = "Content_Batt02_04_01",
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
						["startQuest"] = "1753348573061710314",
						["startPort"] = "Out",
						["endQuest"] = "1753348573061710315",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753348573061710311",
						["startPort"] = "QuestStart",
						["endQuest"] = "1753348573061710314",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753348573061710318",
						["startPort"] = "Out",
						["endQuest"] = "1753348573061710312",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1753348573062710326",
						["startPort"] = "false",
						["endQuest"] = "1753348573061710312",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1753348573062710326",
						["startPort"] = "true",
						["endQuest"] = "176511137727210889026",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511137727210889025",
						["startPort"] = "Out",
						["endQuest"] = "176312691283926062978",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17652685317396003",
						["startPort"] = "Out",
						["endQuest"] = "1753348573061710313",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1753428977597668612",
						["startPort"] = "Out",
						["endQuest"] = "1753348573061710318",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511137727210889025",
						["startPort"] = "Out",
						["endQuest"] = "176312693279126063457",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312693279126063457",
						["startPort"] = "Out",
						["endQuest"] = "1753348573062710338",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176528100003730808758",
						["startPort"] = "false",
						["endQuest"] = "176528108273930810569",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753348573061710315",
						["startPort"] = "Out",
						["endQuest"] = "176528122084230812814",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176528122084230812814",
						["startPort"] = "true",
						["endQuest"] = "17652685317396003",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176528122084230812814",
						["startPort"] = "false",
						["endQuest"] = "1753348573061710313",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17675241306444975",
						["startPort"] = "Out",
						["endQuest"] = "17675240455292704",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176528100003730808758",
						["startPort"] = "true",
						["endQuest"] = "176511137727210889024",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511137727210889024",
						["startPort"] = "Out",
						["endQuest"] = "176511137727210889025",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511137727210889027",
						["startPort"] = "Out",
						["endQuest"] = "17675241306444975",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753348573062710326",
						["startPort"] = "true",
						["endQuest"] = "176511137727210889027",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675240455292704",
						["startPort"] = "Out",
						["endQuest"] = "176528100003730808758",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753348573061710311",
						["startPort"] = "QuestStart",
						["endQuest"] = "1753348573062710326",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753348573062710326",
						["startPort"] = "true",
						["endQuest"] = "176511137727210889023",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312693279126063457",
						["startPort"] = "Out",
						["endQuest"] = "1753428977597668612",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176528100003730808758",
						["startPort"] = "false",
						["endQuest"] = "1753428977597668612",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1753348573061710311"] = {
						["key"] = "1753348573061710311",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -2049.779055399664,
							["y"] = 230.3095168449355
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1753348573061710312"] = {
						["key"] = "1753348573061710312",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1927.0700783162692,
							["y"] = 1430.4877229503963
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1753348573061710313"] = {
						["key"] = "1753348573061710313",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1199.667310051963,
							["y"] = 1753.0720207250845
						},
						["propsData"] = {}
					},
					["1753348573061710314"] = {
						["key"] = "1753348573061710314",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 167.53471145512407,
							["y"] = 1509.3795958389746
						},
						["propsData"] = {}
					},
					["1753348573061710315"] = {
						["key"] = "1753348573061710315",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 465.74254566756065,
							["y"] = 1525.2433249697451
						},
						["propsData"] = {}
					},
					["1753348573061710316"] = {
						["key"] = "1753348573061710316",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否在阶段2",
						["pos"] = {
							["x"] = -139.7866486742342,
							["y"] = 668.7065932414906
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["1753348573061710318"] = {
						["key"] = "1753348573061710318",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2772.1259438907828,
							["y"] = 669.0904488238402
						},
						["propsData"] = {
							["VarName"] = "East01Batt02Phase",
							["VarValue"] = 5
						}
					},
					["1753348573062710326"] = {
						["key"] = "1753348573062710326",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=4",
						["pos"] = {
							["x"] = -1520.46930597858,
							["y"] = 234.8199685418857
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "4"
								}
							}
						}
					},
					["1753348573062710338"] = {
						["key"] = "1753348573062710338",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1985.5963348513928,
							["y"] = -132.07615451563765
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_04_05",
							["NewDetail"] = "Content_Batt02_04_05",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1753428977597668612"] = {
						["key"] = "1753428977597668612",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待交互Xingshibei",
						["pos"] = {
							["x"] = 2441.5338336087334,
							["y"] = 666.946689701468
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2250449,
							["StateId"] = 118015,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_Xingshibei0402"
						}
					},
					["176312691283926062978"] = {
						["key"] = "176312691283926062978",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1230.64199000674,
							["y"] = 29.05167704286669
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12019601,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["176312693279126063457"] = {
						["key"] = "176312693279126063457",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1493.9001193000486,
							["y"] = 266.7989480123514
						},
						["propsData"] = {
							["VarName"] = "Batt02Xingshibei02",
							["VarValue"] = 1
						}
					},
					["176511137727210889023"] = {
						["key"] = "176511137727210889023",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = -1108.253874721197,
							["y"] = -142.53895437304664
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_04_03",
							["NewDetail"] = "Content_Batt02_04_03",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176511137727210889024"] = {
						["key"] = "176511137727210889024",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 409.85385024144693,
							["y"] = 236.22477516522736
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250168,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_Xingshibei0401"
						}
					},
					["176511137727210889025"] = {
						["key"] = "176511137727210889025",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待交互Xingshibei",
						["pos"] = {
							["x"] = 892.226226641258,
							["y"] = 260.3397492164931
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2250087,
							["StateId"] = 118015,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_Xingshibei0401"
						}
					},
					["176511137727210889026"] = {
						["key"] = "176511137727210889026",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = -1108.320805974967,
							["y"] = 19.45655850804205
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250208
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310481,
							["QuestId"] = 0
						}
					},
					["176511137727210889027"] = {
						["key"] = "176511137727210889027",
						["type"] = "SendMessageNode",
						["name"] = "消息StoneInOrder04Awake",
						["pos"] = {
							["x"] = -1108.641903053282,
							["y"] = 226.6869749350664
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "StoneInOrder04Awake",
							["UnitId"] = -1
						}
					},
					["176511137727210889028"] = {
						["key"] = "176511137727210889028",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 769.4967400003824,
							["y"] = -332.14649021152263
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2250208,
							["StateId"] = 1310481,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17652685317396003"] = {
						["key"] = "17652685317396003",
						["type"] = "SendMessageNode",
						["name"] = "StoneInOrder04Reset",
						["pos"] = {
							["x"] = 951.7388663967608,
							["y"] = 1494.895489572347
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "StoneInOrder04Reset",
							["UnitId"] = -1
						}
					},
					["176528100003730808758"] = {
						["key"] = "176528100003730808758",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量Batt02Xingshibei02",
						["pos"] = {
							["x"] = -108.87610330173263,
							["y"] = 235.94965675057207
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Batt02Xingshibei02",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["176528108273930810569"] = {
						["key"] = "176528108273930810569",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1349.1032445366804,
							["y"] = 667.6368267954956
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_04_05",
							["NewDetail"] = "Content_Batt02_04_05",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176528122084230812814"] = {
						["key"] = "176528122084230812814",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量Batt02Xingshibei02",
						["pos"] = {
							["x"] = 707.45901376745,
							["y"] = 1508.1849037185725
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Batt02Xingshibei02",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17675240455292704"] = {
						["key"] = "17675240455292704",
						["type"] = "SendMessageNode",
						["name"] = "消息StoneInOrder04Unlock",
						["pos"] = {
							["x"] = -463.7798163887983,
							["y"] = 249.37118131005263
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "StoneInOrder04Unlock",
							["UnitId"] = -1
						}
					},
					["17675240736493288"] = {
						["key"] = "17675240736493288",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 749.0980304020919,
							["y"] = -132.6901540936741
						},
						["propsData"] = {
							["WaitTime"] = 0
						}
					},
					["17675241306444975"] = {
						["key"] = "17675241306444975",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = -784.2003650430426,
							["y"] = 240.25967849174228
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					}
				},
				["commentData"] = {
					["176511138657810889389"] = {
						["key"] = "176511138657810889389",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 102.59965034965035,
							["y"] = 1335.0909090909088
						},
						["size"] = {
							["width"] = 1361.8593634177998,
							["height"] = 557.0939946276638
						}
					}
				}
			}
		},
		["176312402111826038905"] = {
			["isStoryNode"] = true,
			["key"] = "176312402111826038905",
			["type"] = "StoryNode",
			["name"] = "【变量=3】",
			["pos"] = {
				["x"] = 1915.8355263157896,
				["y"] = 293.97744360902277
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
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
						["startQuest"] = "176312405840626039749",
						["startPort"] = "Out",
						["endQuest"] = "176312405840626039750",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312402111826038906",
						["startPort"] = "QuestStart",
						["endQuest"] = "176312405840626039749",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312405840626039751",
						["startPort"] = "false",
						["endQuest"] = "176312402111826038909",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176312601070526051586",
						["startPort"] = "Out",
						["endQuest"] = "176312402111826038909",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176312616118226053883",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053887",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053879",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053886",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053877",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053883",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053879",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053880",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053877",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053891",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053877",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053892",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118426053900",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053901",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053879",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053890",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053879",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053900",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118426053901",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053877",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118426053897",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053899",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053890",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053902",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118426053902",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053895",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053891",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053903",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118426053903",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053893",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053877",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053897",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053877",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053892",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053896",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118426053896",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053894",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118426053904",
						["startPort"] = "Out",
						["endQuest"] = "176312616118426053898",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312616118226053883",
						["startPort"] = "Out",
						["endQuest"] = "176355014731415229212",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511090915710878503",
						["startPort"] = "Out",
						["endQuest"] = "176511090915710878506",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312402111826038906",
						["startPort"] = "QuestStart",
						["endQuest"] = "176312405840626039751",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511090915710878503",
						["startPort"] = "Out",
						["endQuest"] = "176312445339026045145",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511091887710878753",
						["startPort"] = "Out",
						["endQuest"] = "176511090915710878503",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511091887710878753",
						["startPort"] = "Out",
						["endQuest"] = "176511090915710878504",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176355014731415229212",
						["startPort"] = "Out",
						["endQuest"] = "176312601070526051586",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17652690148698785",
						["startPort"] = "Out",
						["endQuest"] = "176312402111826038912",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "176312419540926042480",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053878",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312419540926042480",
						["startPort"] = "Out",
						["endQuest"] = "176312616118226053879",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312405840626039751",
						["startPort"] = "true",
						["endQuest"] = "176312640036926054739",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312640036926054739",
						["startPort"] = "true",
						["endQuest"] = "176511091887710878753",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176511090915710878503",
						["startPort"] = "Out",
						["endQuest"] = "176312640036926054740",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312640036926054739",
						["startPort"] = "false",
						["endQuest"] = "176528115391430811829",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312405840626039750",
						["startPort"] = "Out",
						["endQuest"] = "176528117363230812113",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176528117363230812113",
						["startPort"] = "true",
						["endQuest"] = "17652690148698785",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176528117363230812113",
						["startPort"] = "false",
						["endQuest"] = "176312402111826038912",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "176312640036926054740",
						["startPort"] = "Out",
						["endQuest"] = "176312419540926042480",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176312640036926054739",
						["startPort"] = "false",
						["endQuest"] = "176312419540926042480",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["176312402111826038906"] = {
						["key"] = "176312402111826038906",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -666.1249999999999,
							["y"] = 215.79166666666669
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176312402111826038909"] = {
						["key"] = "176312402111826038909",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 5151,
							["y"] = 2306
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176312402111826038912"] = {
						["key"] = "176312402111826038912",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1317.4159663865548,
							["y"] = 1996.627450980392
						},
						["propsData"] = {}
					},
					["176312405840626039749"] = {
						["key"] = "176312405840626039749",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 179.00810745291534,
							["y"] = 1669.0482809981813
						},
						["propsData"] = {}
					},
					["176312405840626039750"] = {
						["key"] = "176312405840626039750",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 445.24519182695514,
							["y"] = 1677.5259403164118
						},
						["propsData"] = {}
					},
					["176312405840626039751"] = {
						["key"] = "176312405840626039751",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=3",
						["pos"] = {
							["x"] = -98.01121746798026,
							["y"] = 215.29136737589573
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Batt02Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "3"
								}
							}
						}
					},
					["176312419540926042480"] = {
						["key"] = "176312419540926042480",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "机关-完成",
						["pos"] = {
							["x"] = 2198.1073289854307,
							["y"] = 515.5874303529959
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2250447,
							["StateId"] = 118015,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_Xingshibei0302"
						}
					},
					["176312445339026045145"] = {
						["key"] = "176312445339026045145",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1536.7483114711376,
							["y"] = 52.27059896625093
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12019401,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["176312601070526051586"] = {
						["key"] = "176312601070526051586",
						["type"] = "SetVarNode",
						["name"] = "设置变量值=4",
						["pos"] = {
							["x"] = 5095.729800484372,
							["y"] = 444.80565820569507
						},
						["propsData"] = {
							["VarName"] = "East01Batt02Phase",
							["VarValue"] = 4
						}
					},
					["176312616118226053877"] = {
						["key"] = "176312616118226053877",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 3787.463569099808,
							["y"] = 428.0515292977809
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 7,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "MonsterPoint_Batt02Group4"
						}
					},
					["176312616118226053878"] = {
						["key"] = "176312616118226053878",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2274.4677464688566,
							["y"] = 268.9420736276677
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_04_01",
							["NewDetail"] = "Content_Batt02_04_01",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176312616118226053879"] = {
						["key"] = "176312616118226053879",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2472.026005592064,
							["y"] = 509.7139015159821
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2250167,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2250167"
						}
					},
					["176312616118226053880"] = {
						["key"] = "176312616118226053880",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3427.5397706281965,
							["y"] = -420.391256212725
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_04_02",
							["NewDetail"] = "Content_Batt02_04_02",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176312616118226053883"] = {
						["key"] = "176312616118226053883",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 4500.718561927226,
							["y"] = 431.4714753598117
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 10,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "MonsterPoint_Batt02Group4"
						}
					},
					["176312616118226053886"] = {
						["key"] = "176312616118226053886",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 3432.7999934713407,
							["y"] = -818.0771571886289
						},
						["propsData"] = {
							["IsCreate"] = true,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								2250222
							}
						}
					},
					["176312616118226053887"] = {
						["key"] = "176312616118226053887",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 4962.325377916617,
							["y"] = -827.6917113594999
						},
						["propsData"] = {
							["IsCreate"] = false,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								2250222
							}
						}
					},
					["176312616118226053890"] = {
						["key"] = "176312616118226053890",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG14",
						["pos"] = {
							["x"] = 3434.5156857625907,
							["y"] = -135.87822329723667
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250405,
								2250406,
								2250407,
								2250408,
								2250409,
								2250410,
								2250411
							}
						}
					},
					["176312616118226053891"] = {
						["key"] = "176312616118226053891",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG15",
						["pos"] = {
							["x"] = 4047.0738929324716,
							["y"] = -543.3102437976382
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250419,
								2250420,
								2250421,
								2250422,
								2250423
							}
						}
					},
					["176312616118226053892"] = {
						["key"] = "176312616118226053892",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成BattNpcG16",
						["pos"] = {
							["x"] = 4482.414151699483,
							["y"] = -544.6303200190061
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250429,
								2250430,
								2250431,
								2250432,
								2250433
							}
						}
					},
					["176312616118226053893"] = {
						["key"] = "176312616118226053893",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G15",
						["pos"] = {
							["x"] = 4056.9328104076244,
							["y"] = -217.12615694487425
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250419,
								2250420,
								2250421,
								2250422,
								2250423
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176312616118426053894"] = {
						["key"] = "176312616118426053894",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G16",
						["pos"] = {
							["x"] = 4479.280472362264,
							["y"] = -231.21578890285616
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250429,
								2250430,
								2250431,
								2250432,
								2250433
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176312616118426053895"] = {
						["key"] = "176312616118426053895",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态G14",
						["pos"] = {
							["x"] = 3438.7997108890995,
							["y"] = 158.84680464992474
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250405,
								2250406,
								2250407,
								2250408,
								2250409,
								2250410,
								2250411
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310573,
							["QuestId"] = 0
						}
					},
					["176312616118426053896"] = {
						["key"] = "176312616118426053896",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 4482.929234584023,
							["y"] = -401.54826237903677
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["176312616118426053897"] = {
						["key"] = "176312616118426053897",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 4059.483591870295,
							["y"] = -63.60316375710388
						},
						["propsData"] = {
							["WaitTime"] = 4.5
						}
					},
					["176312616118426053898"] = {
						["key"] = "176312616118426053898",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G16",
						["pos"] = {
							["x"] = 4475.793753589046,
							["y"] = 120.96153618153592
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250434,
								2250435,
								2250436,
								2250437,
								2250438
							}
						}
					},
					["176312616118426053899"] = {
						["key"] = "176312616118426053899",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G15",
						["pos"] = {
							["x"] = 4064.5768566718552,
							["y"] = 122.85385016718689
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250424,
								2250425,
								2250426,
								2250427,
								2250428
							}
						}
					},
					["176312616118426053900"] = {
						["key"] = "176312616118426053900",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3419.6528854922744,
							["y"] = 350.4811340652559
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["176312616118426053901"] = {
						["key"] = "176312616118426053901",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成G14",
						["pos"] = {
							["x"] = 3430.8391845733095,
							["y"] = 546.9493526866831
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2250412,
								2250413,
								2250414,
								2250415,
								2250416,
								2250417,
								2250418
							}
						}
					},
					["176312616118426053902"] = {
						["key"] = "176312616118426053902",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3435.942171933836,
							["y"] = -8.106443049864161
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["176312616118426053903"] = {
						["key"] = "176312616118426053903",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 4054.6892957108835,
							["y"] = -404.3304778811886
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["176312616118426053904"] = {
						["key"] = "176312616118426053904",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 4479.927309090694,
							["y"] = -62.19706949390989
						},
						["propsData"] = {
							["WaitTime"] = 4.5
						}
					},
					["176312640036926054739"] = {
						["key"] = "176312640036926054739",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量判断-机关",
						["pos"] = {
							["x"] = 578.9788780579867,
							["y"] = 210.97296852695277
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Batt02Xingshibei01",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["176312640036926054740"] = {
						["key"] = "176312640036926054740",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1538.2401163810675,
							["y"] = 229.97856674710215
						},
						["propsData"] = {
							["VarName"] = "Batt02Xingshibei01",
							["VarValue"] = 1
						}
					},
					["176312657124726057844"] = {
						["key"] = "176312657124726057844",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 980.5713441316452,
							["y"] = -519.8766523887667
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_04_01",
							["NewDetail"] = "Content_Batt02_04_01",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176355014731415229212"] = {
						["key"] = "176355014731415229212",
						["type"] = "SendMessageNode",
						["name"] = "发送消息-宝箱",
						["pos"] = {
							["x"] = 4765.676378446114,
							["y"] = 441.11357940305305
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "ActiveTreasure02",
							["UnitId"] = -1
						}
					},
					["176511090915710878503"] = {
						["key"] = "176511090915710878503",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待交互Xingshibei",
						["pos"] = {
							["x"] = 1222.182328159582,
							["y"] = 217.0147429190407
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2250047,
							["StateId"] = 118015,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_Xingshibei0301"
						}
					},
					["176511090915710878504"] = {
						["key"] = "176511090915710878504",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1184.9516299096324,
							["y"] = -68.27955798794878
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_03_04",
							["NewDetail"] = "Content_Batt02_03_04",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176511090915710878505"] = {
						["key"] = "176511090915710878505",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "解锁Xingshibei",
						["pos"] = {
							["x"] = 1166.3174312185802,
							["y"] = -592.0545278107281
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2250047
							},
							["ManualItemIdList"] = {},
							["StateId"] = 118011,
							["QuestId"] = 0
						}
					},
					["176511090915710878506"] = {
						["key"] = "176511090915710878506",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1538.6929138285293,
							["y"] = -111.04316889005892
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_03_05",
							["NewDetail"] = "Content_Batt02_03_05",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176511090915710878507"] = {
						["key"] = "176511090915710878507",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1415.8067119668196,
							["y"] = -571.6903117875114
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_Xingshibei01"
						}
					},
					["176511090915710878508"] = {
						["key"] = "176511090915710878508",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1770.8531651300245,
							["y"] = -544.6328527503858
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_Xingshibei01"
						}
					},
					["176511091887710878753"] = {
						["key"] = "176511091887710878753",
						["type"] = "SendMessageNode",
						["name"] = "发送消息-StoneInOrder03Unlock",
						["pos"] = {
							["x"] = 915.7007575757576,
							["y"] = 200.04726890756302
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "StoneInOrder03Unlock",
							["UnitId"] = -1
						}
					},
					["17652690148698785"] = {
						["key"] = "17652690148698785",
						["type"] = "SendMessageNode",
						["name"] = "发送消息-StoneInOrder03Unlock",
						["pos"] = {
							["x"] = 1013.7238378236826,
							["y"] = 1685.5768467858252
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "StoneInOrder03Reset",
							["UnitId"] = -1
						}
					},
					["176528115391430811829"] = {
						["key"] = "176528115391430811829",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1523.2593215607917,
							["y"] = 610.1999618029026
						},
						["propsData"] = {
							["NewDescription"] = "Description_Batt02_03_05",
							["NewDetail"] = "Content_Batt02_03_05",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176528117363230812113"] = {
						["key"] = "176528117363230812113",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量判断-机关",
						["pos"] = {
							["x"] = 704.5841437973784,
							["y"] = 1687.8613225010283
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "Batt02Xingshibei01",
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
				["commentData"] = {
					["176312649111926056336"] = {
						["key"] = "176312649111926056336",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 3398.097243155222,
							["y"] = -211.66981356195913
						},
						["size"] = {
							["width"] = 273.1578947368423,
							["height"] = 896.8421052631579
						}
					},
					["176312649538326056437"] = {
						["key"] = "176312649538326056437",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 3985.0709273657485,
							["y"] = -644.4987609303802
						},
						["size"] = {
							["width"] = 350.52631578947336,
							["height"] = 950.5263157894738
						}
					},
					["176312650005526056541"] = {
						["key"] = "176312650005526056541",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 4438.228822102591,
							["y"] = -650.8145504040643
						},
						["size"] = {
							["width"] = 293.2674184989114,
							["height"] = 932.9744957219045
						}
					},
					["176312652097026056914"] = {
						["key"] = "176312652097026056914",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 3364.6559305978108,
							["y"] = -902.5177152732508
						},
						["size"] = {
							["width"] = 1886.25,
							["height"] = 208.125
						}
					},
					["176511120354210885236"] = {
						["key"] = "176511120354210885236",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 75.26654034819703,
							["y"] = 1554.3105055419305
						},
						["size"] = {
							["width"] = 1594.174746306324,
							["height"] = 659.1401026733832
						}
					},
					["176528131879531452866"] = {
						["key"] = "176528131879531452866",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 575.9642636774984,
							["y"] = -335.8008902861843
						},
						["size"] = {
							["width"] = 1303.8461538461538,
							["height"] = 1179.2307692307693
						}
					}
				}
			}
		}
	},
	["commentData"] = {}
}