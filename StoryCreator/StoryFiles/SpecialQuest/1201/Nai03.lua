return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17358092442036182272",
			["startPort"] = "StoryStart",
			["endStory"] = "17562898248993749",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17562898248993749",
			["startPort"] = "Success",
			["endStory"] = "1756294960503647537",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1756294960503647537",
			["startPort"] = "Success",
			["endStory"] = "1756297875070655989",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1756297875070655989",
			["startPort"] = "Success",
			["endStory"] = "1756298431006659827",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1756298431006659827",
			["startPort"] = "Success",
			["endStory"] = "1756299211245664400",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1756299211245664400",
			["startPort"] = "Success",
			["endStory"] = "1756299365880664768",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1756299365880664768",
			["startPort"] = "Success",
			["endStory"] = "17562998588441306814",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17562998588441306814",
			["startPort"] = "Success",
			["endStory"] = "17358092442036182273",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17358092442036182272"] = {
			["isStoryNode"] = true,
			["key"] = "17358092442036182272",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 671.0869565217391,
				["y"] = 209.34782608695647
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
		["17358092442036182273"] = {
			["isStoryNode"] = true,
			["key"] = "17358092442036182273",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2709.7844385274407,
				["y"] = 516.9770780199215
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17562898248993749"] = {
			["isStoryNode"] = true,
			["key"] = "17562898248993749",
			["type"] = "StoryNode",
			["name"] = "【变量=0】",
			["pos"] = {
				["x"] = 1006.9336870026526,
				["y"] = 209.18502722323052
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Nai03_01_00",
				["QuestDeatil"] = "Content_Nai03_01_01",
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
						["startQuest"] = "17562901517964931",
						["startPort"] = "false",
						["endQuest"] = "17562901517964932",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562901517964931",
						["startPort"] = "true",
						["endQuest"] = "17562901517964933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562901517964932",
						["startPort"] = "true",
						["endQuest"] = "17562901517964934",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562898248993750",
						["startPort"] = "QuestStart",
						["endQuest"] = "17562901517964929",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562901517964929",
						["startPort"] = "Out",
						["endQuest"] = "17562901517964930",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756292862353640203",
						["startPort"] = "Out",
						["endQuest"] = "1756293601700641238",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756294382284643017",
						["startPort"] = "Out",
						["endQuest"] = "1756294724523644815",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756294843550646137",
						["startPort"] = "Out",
						["endQuest"] = "17562901517964931",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562901517964930",
						["startPort"] = "false",
						["endQuest"] = "1756294843550646137",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756294724523644815",
						["startPort"] = "Out",
						["endQuest"] = "1756295000032648565",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562901517964932",
						["startPort"] = "false",
						["endQuest"] = "1756298603650660694",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298603650660694",
						["startPort"] = "true",
						["endQuest"] = "17562901517964935",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298603650660694",
						["startPort"] = "false",
						["endQuest"] = "1756299382840665326",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299382840665326",
						["startPort"] = "true",
						["endQuest"] = "1756299399611665722",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299382840665326",
						["startPort"] = "false",
						["endQuest"] = "1756299386185665456",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299386185665456",
						["startPort"] = "true",
						["endQuest"] = "1756299406782665939",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299386185665456",
						["startPort"] = "false",
						["endQuest"] = "1756299443673666739",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299784976671514",
						["startPort"] = "Out",
						["endQuest"] = "17562898249003753",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17563013481352584199",
						["startPort"] = "Out",
						["endQuest"] = "17563013481352584200",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562898248993750",
						["startPort"] = "QuestStart",
						["endQuest"] = "17563013481352584199",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562901517964930",
						["startPort"] = "true",
						["endQuest"] = "1756292862353640203",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756292862353640203",
						["startPort"] = "Out",
						["endQuest"] = "1756294624274643642",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756294724523644815",
						["startPort"] = "Out",
						["endQuest"] = "1756294866264646974",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756295000032648565",
						["startPort"] = "Out",
						["endQuest"] = "17601671253802615234",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "1756294866264646974",
						["startPort"] = "Out",
						["endQuest"] = "17601671253802615234",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1756294624274643642",
						["startPort"] = "Out",
						["endQuest"] = "17601851148494546603",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601851148494546603",
						["startPort"] = "Out",
						["endQuest"] = "17601854663825194402",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756294382284643017",
						["startPort"] = "Out",
						["endQuest"] = "17601854795375194628",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601851148494546603",
						["startPort"] = "Out",
						["endQuest"] = "1756294392685643320",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756294392685643320",
						["startPort"] = "Out",
						["endQuest"] = "1756294626515643743",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756294626515643743",
						["startPort"] = "Out",
						["endQuest"] = "1756294382284643017",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756292862353640203",
						["startPort"] = "Out",
						["endQuest"] = "17641414501571382558",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562901517964933",
						["startPort"] = "Out",
						["endQuest"] = "17645888650537670362",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562901517964934",
						["startPort"] = "Out",
						["endQuest"] = "17645888661837670406",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562901517964935",
						["startPort"] = "Out",
						["endQuest"] = "17645888674257670435",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299399611665722",
						["startPort"] = "Out",
						["endQuest"] = "17645888690457670481",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299406782665939",
						["startPort"] = "Out",
						["endQuest"] = "17645888706697670540",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299443673666739",
						["startPort"] = "Out",
						["endQuest"] = "17645889924327672372",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17645889924327672372",
						["startPort"] = "Out",
						["endQuest"] = "17562898249003753",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17645888706697670540",
						["startPort"] = "Out",
						["endQuest"] = "17562898249003753",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17645888690457670481",
						["startPort"] = "Out",
						["endQuest"] = "17562898249003753",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17645888674257670435",
						["startPort"] = "Out",
						["endQuest"] = "17562898249003753",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17645888661837670406",
						["startPort"] = "Out",
						["endQuest"] = "17562898249003753",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17645888650537670362",
						["startPort"] = "Out",
						["endQuest"] = "17562898249003753",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1756292862353640203",
						["startPort"] = "Out",
						["endQuest"] = "176459120742411848150",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601851148494546603",
						["startPort"] = "Out",
						["endQuest"] = "1756293650370641693",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601851148494546603",
						["startPort"] = "Out",
						["endQuest"] = "176459139237111849380",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756294392685643320",
						["startPort"] = "Out",
						["endQuest"] = "176459175477111850559",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756294382284643017",
						["startPort"] = "Out",
						["endQuest"] = "176459187496411851457",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290248",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290251",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290248",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290253",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290251",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290255",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290255",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290252",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290248",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290250",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290248",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290257",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290253",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290258",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290248",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290261",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290248",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290260",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601671253802615234",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290256",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601671253802615234",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290248",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290253",
						["startPort"] = "Out",
						["endQuest"] = "1756299784976671514",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601671253802615234",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290259",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601671253802615234",
						["startPort"] = "Out",
						["endQuest"] = "176543733256461290249",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563013481352584200",
						["startPort"] = "Out",
						["endQuest"] = "176543743243761292576",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543743243761292576",
						["startPort"] = "Out",
						["endQuest"] = "17562898249003756",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17562901517964930",
						["startPort"] = "true",
						["endQuest"] = "17657815633362556",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176543733256461290259",
						["startPort"] = "Out",
						["endQuest"] = "1765883761703655463",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1765883761703655463",
						["startPort"] = "PC",
						["endQuest"] = "176543733256461290254",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1765883761703655463",
						["startPort"] = "Mobile",
						["endQuest"] = "1765883755179655362",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17562898248993750"] = {
						["key"] = "17562898248993750",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 749.9204545454545,
							["y"] = 306.92045454545456
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17562898249003753"] = {
						["key"] = "17562898249003753",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 6918.069166127989,
							["y"] = 859.1208791208792
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17562898249003756"] = {
						["key"] = "17562898249003756",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2093.1954320189616,
							["y"] = 2288.5832794656326
						},
						["propsData"] = {}
					},
					["17562901517964929"] = {
						["key"] = "17562901517964929",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1224.5708690472673,
							["y"] = 313.5202771998013
						},
						["propsData"] = {
							["QuestRoleId"] = 24010101,
							["IsPlayFX"] = false
						}
					},
					["17562901517964930"] = {
						["key"] = "17562901517964930",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=0",
						["pos"] = {
							["x"] = 1571.0115138884908,
							["y"] = 382.4951847954111
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17562901517964931"] = {
						["key"] = "17562901517964931",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否在阶段2",
						["pos"] = {
							["x"] = 1566.2521389160863,
							["y"] = 787.0623330227393
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["17562901517964932"] = {
						["key"] = "17562901517964932",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否在阶段3",
						["pos"] = {
							["x"] = 1558.1895947336404,
							["y"] = 985.5657790091572
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["17562901517964933"] = {
						["key"] = "17562901517964933",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1948.3006928273903,
							["y"] = 789.6362090372983
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Phase02",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17562901517964934"] = {
						["key"] = "17562901517964934",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1942.9131028631753,
							["y"] = 985.9540490919802
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Phase03",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17562901517964935"] = {
						["key"] = "17562901517964935",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1942.1839119773347,
							["y"] = 1182.5238404472573
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Phase04",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17562901517964939"] = {
						["key"] = "17562901517964939",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 371.1900694402665,
							["y"] = 1060.5814164037993
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IntCyanBoat",
							["UnitId"] = -1
						}
					},
					["1756292862353640203"] = {
						["key"] = "1756292862353640203",
						["type"] = "TalkNode",
						["name"] = "开场对话",
						["pos"] = {
							["x"] = 1908.5967341482049,
							["y"] = 53.10873272754064
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 12018202,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1201/120104/12018202.12018202'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "FixSimple_Nai03_01",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
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
									["TalkActorId"] = 210013,
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
					["1756293601700641238"] = {
						["key"] = "1756293601700641238",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2269.6760694156205,
							["y"] = -156.41254862268806
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018210,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1756293650370641693"] = {
						["key"] = "1756293650370641693",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2914.7083886186056,
							["y"] = -149.76770971546523
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018213,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1756294382284643017"] = {
						["key"] = "1756294382284643017",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 3890.0154628877203,
							["y"] = 63.72053091051256
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 4,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2320005,
								2320006,
								2320007,
								2320008
							}
						}
					},
					["1756294392685643320"] = {
						["key"] = "1756294392685643320",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3248.1178909258742,
							["y"] = 55.58425817799549
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320120,
							["GuideType"] = "M",
							["GuidePointName"] = "Npc_WuYou_2320004"
						}
					},
					["1756294624274643642"] = {
						["key"] = "1756294624274643642",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成无由生",
						["pos"] = {
							["x"] = 2267.3230906987296,
							["y"] = 44.92924402962764
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320004
							}
						}
					},
					["1756294626515643743"] = {
						["key"] = "1756294626515643743",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成怪物",
						["pos"] = {
							["x"] = 3571.8382206970573,
							["y"] = 74.58276122181744
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320005,
								2320006,
								2320007,
								2320008
							}
						}
					},
					["1756294724523644815"] = {
						["key"] = "1756294724523644815",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 4771.9974140720715,
							["y"] = 92.92133318551737
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210082,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_WuYou_2320004",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 12018216,
							["FlowAssetPath"] = "",
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1756294843550646137"] = {
						["key"] = "1756294843550646137",
						["type"] = "SwitchPlayerBattlePetNode",
						["name"] = "切换玩家战斗宠物",
						["pos"] = {
							["x"] = 1564.7581612480499,
							["y"] = 585.3574133386691
						},
						["propsData"] = {
							["BattlePetId"] = 901
						}
					},
					["1756294866264646974"] = {
						["key"] = "1756294866264646974",
						["type"] = "SwitchPlayerBattlePetNode",
						["name"] = "切换玩家战斗宠物",
						["pos"] = {
							["x"] = 5097.120887934475,
							["y"] = 180.6301259706329
						},
						["propsData"] = {
							["BattlePetId"] = 901
						}
					},
					["1756295000032648565"] = {
						["key"] = "1756295000032648565",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁无由生",
						["pos"] = {
							["x"] = 5106.400336556028,
							["y"] = 10.46095303830208
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320004
							}
						}
					},
					["1756298603650660694"] = {
						["key"] = "1756298603650660694",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否在阶段4",
						["pos"] = {
							["x"] = 1560.5525079140805,
							["y"] = 1183.12658152746
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "3"
								}
							}
						}
					},
					["1756299382840665326"] = {
						["key"] = "1756299382840665326",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否在阶段5",
						["pos"] = {
							["x"] = 1562.043467934452,
							["y"] = 1390.101498767083
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "4"
								}
							}
						}
					},
					["1756299386185665456"] = {
						["key"] = "1756299386185665456",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "是否在阶段6",
						["pos"] = {
							["x"] = 1554.9761235141664,
							["y"] = 1600.9571137403452
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "5"
								}
							}
						}
					},
					["1756299399611665722"] = {
						["key"] = "1756299399611665722",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1938.2607491052936,
							["y"] = 1389.6214215687398
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Phase05",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1756299406782665939"] = {
						["key"] = "1756299406782665939",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1942.5973258412507,
							["y"] = 1601.125180967236
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Phase06",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1756299443673666739"] = {
						["key"] = "1756299443673666739",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1932.8615157277322,
							["y"] = 1824.6643229398148
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_Phase06",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1756299784976671514"] = {
						["key"] = "1756299784976671514",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 8621.06435210704,
							["y"] = 57.38643905898927
						},
						["propsData"] = {
							["VarName"] = "East01Nai03Phase",
							["VarValue"] = 1
						}
					},
					["17563013481352584199"] = {
						["key"] = "17563013481352584199",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 924.8874956852343,
							["y"] = 2273.9923357519538
						},
						["propsData"] = {}
					},
					["17563013481352584200"] = {
						["key"] = "17563013481352584200",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1223.2216006857068,
							["y"] = 2284.394364818083
						},
						["propsData"] = {}
					},
					["17601671253802615234"] = {
						["key"] = "17601671253802615234",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 5399.257295907754,
							["y"] = 71.33200838063432
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17601851148494546603"] = {
						["key"] = "17601851148494546603",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2575.98201952846,
							["y"] = 49.124498179838795
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 2320121,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320121"
						}
					},
					["17601854663825194402"] = {
						["key"] = "17601854663825194402",
						["type"] = "SendMessageNode",
						["name"] = "无由生Afraid_Start",
						["pos"] = {
							["x"] = 2913.8096199029133,
							["y"] = -319.9730784022813
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Afraid_Start",
							["UnitId"] = 210082
						}
					},
					["17601854795375194628"] = {
						["key"] = "17601854795375194628",
						["type"] = "SendMessageNode",
						["name"] = "无由生Afraid_End",
						["pos"] = {
							["x"] = 4213.130660554804,
							["y"] = -90.52082735151896
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Afraid_End",
							["UnitId"] = 210082
						}
					},
					["17641414501571382558"] = {
						["key"] = "17641414501571382558",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "女主魅影",
						["pos"] = {
							["x"] = 2266.941176470588,
							["y"] = -334.47058823529414
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320203
							}
						}
					},
					["17645871389677668642"] = {
						["key"] = "17645871389677668642",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 356.8121278875924,
							["y"] = 1377.6959565202596
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17645888650537670362"] = {
						["key"] = "17645888650537670362",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "女主魅影",
						["pos"] = {
							["x"] = 2292.6063655127114,
							["y"] = 801.0766052832612
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320204
							}
						}
					},
					["17645888661837670406"] = {
						["key"] = "17645888661837670406",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "女主魅影",
						["pos"] = {
							["x"] = 2297.9509033278378,
							["y"] = 1002.6144204093116
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320205
							}
						}
					},
					["17645888674257670435"] = {
						["key"] = "17645888674257670435",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "女主魅影",
						["pos"] = {
							["x"] = 2301.8584663530482,
							["y"] = 1196.5808069639336
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320206
							}
						}
					},
					["17645888690457670481"] = {
						["key"] = "17645888690457670481",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "女主魅影",
						["pos"] = {
							["x"] = 2290.3878781177536,
							["y"] = 1402.7740842748578
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320207
							}
						}
					},
					["17645888706697670540"] = {
						["key"] = "17645888706697670540",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "女主魅影",
						["pos"] = {
							["x"] = 2289.505525176577,
							["y"] = 1617.9421515017484
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320208
							}
						}
					},
					["17645889924327672372"] = {
						["key"] = "17645889924327672372",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "女主魅影",
						["pos"] = {
							["x"] = 2283.4269046227246,
							["y"] = 1850.2540826047014
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320203
							}
						}
					},
					["176459120742411848150"] = {
						["key"] = "176459120742411848150",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2267.6580266998226,
							["y"] = -504.45900229801083
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_01_01",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176459139237111849380"] = {
						["key"] = "176459139237111849380",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2908.1843424892963,
							["y"] = -489.84639818385847
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_01_02",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176459175477111850559"] = {
						["key"] = "176459175477111850559",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3591.5302071509514,
							["y"] = -303.55513372076734
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_01_03",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176459187496411851457"] = {
						["key"] = "176459187496411851457",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 4212.733214669747,
							["y"] = -316.6501029929811
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_01_04",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176543733256461290248"] = {
						["key"] = "176543733256461290248",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 6881.748242604077,
							["y"] = 104.43358542845851
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320124,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320124"
						}
					},
					["176543733256461290249"] = {
						["key"] = "176543733256461290249",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 5883.669536863958,
							["y"] = -1002.2364249851107
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018221,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["176543733256461290250"] = {
						["key"] = "176543733256461290250",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 6917.297544101251,
							["y"] = -195.66593031917603
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018222,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["176543733256461290251"] = {
						["key"] = "176543733256461290251",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 7051.581842311903,
							["y"] = -511.78449638988906
						},
						["propsData"] = {
							["WaitTime"] = 8
						}
					},
					["176543733256461290252"] = {
						["key"] = "176543733256461290252",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 7549.186375325441,
							["y"] = -653.021151958487
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018224,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["176543733256461290253"] = {
						["key"] = "176543733256461290253",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 7358.039816668053,
							["y"] = 112.66954391516451
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2320039,
							["StateId"] = 1310251,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["176543733256461290254"] = {
						["key"] = "176543733256461290254",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 6402.203840057466,
							["y"] = -951.301340156509
						},
						["propsData"] = {
							["MessageId"] = 200038,
							["SkillNameList"] = {
								"Skill3"
							},
							["LastTime"] = -1,
							["bIsForceTouch"] = false,
							["bIsTimeDilation"] = false,
							["HighLightUIPath"] = "",
							["UICompName"] = "",
							["UIShape"] = "Square",
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["ForbidSuccessAnim"] = false,
							["IsNotForceRelease"] = false,
							["UICompSizeOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["176543733256461290255"] = {
						["key"] = "176543733256461290255",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 7287.19767357984,
							["y"] = -666.3211459587432
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2320039,
							["StateId"] = 1310250,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["176543733256461290256"] = {
						["key"] = "176543733256461290256",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 5886.55824203078,
							["y"] = -689.4205772957594
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_02_01",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176543733256461290257"] = {
						["key"] = "176543733256461290257",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 6903.293365942175,
							["y"] = -339.62285511074265
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_02_02",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176543733256461290258"] = {
						["key"] = "176543733256461290258",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 7688.146307118646,
							["y"] = -330.84126722035023
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_02_03",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176543733256461290259"] = {
						["key"] = "176543733256461290259",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 5885.613810011871,
							["y"] = -864.6738276639555
						},
						["propsData"] = {
							["GuideId"] = 108
						}
					},
					["176543733256461290260"] = {
						["key"] = "176543733256461290260",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 7350.679061630251,
							["y"] = -208.3898093913756
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2320041,
							["StateId"] = 1310202,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_GongMingShi01"
						}
					},
					["176543733256461290261"] = {
						["key"] = "176543733256461290261",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 7347.808473394958,
							["y"] = -45.683927038434305
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2320040,
							["StateId"] = 1310202,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_GongMingShi02"
						}
					},
					["176543743243761292576"] = {
						["key"] = "176543743243761292576",
						["type"] = "SendMessageNode",
						["name"] = "发送消息ResetVine",
						["pos"] = {
							["x"] = 1618.4886681945516,
							["y"] = 2279.3045630839765
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "ResetVine",
							["UnitId"] = -1
						}
					},
					["17657815633362556"] = {
						["key"] = "17657815633362556",
						["type"] = "SwitchPlayerBattlePetNode",
						["name"] = "切换玩家战斗宠物",
						["pos"] = {
							["x"] = 1908.3529411764707,
							["y"] = -134.47058823529414
						},
						["propsData"] = {
							["BattlePetId"] = 0
						}
					},
					["1765883755179655362"] = {
						["key"] = "1765883755179655362",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 6414.706772391085,
							["y"] = -748.1177304280674
						},
						["propsData"] = {
							["MessageId"] = 200038,
							["SkillNameList"] = {
								"Skill3"
							},
							["LastTime"] = -1,
							["bIsForceTouch"] = false,
							["bIsTimeDilation"] = false,
							["HighLightUIPath"] = "BattleMain.Char_Skill.SupportSkill",
							["UICompName"] = "Button_Area",
							["UIShape"] = "Square",
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["ForbidSuccessAnim"] = false,
							["IsNotForceRelease"] = false,
							["UICompSizeOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1765883761703655463"] = {
						["key"] = "1765883761703655463",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 6128.741874747674,
							["y"] = -880.3617741381852
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {
					["17645890159957673108"] = {
						["key"] = "17645890159957673108",
						["name"] = "失败逻辑",
						["position"] = {
							["x"] = 847.9617031575239,
							["y"] = 2178.239930090549
						},
						["size"] = {
							["width"] = 1636.4093179782042,
							["height"] = 296.94698593460384
						}
					},
					["17645890215747673301"] = {
						["key"] = "17645890215747673301",
						["name"] = "分阶段",
						["position"] = {
							["x"] = 1507.5646002604208,
							["y"] = 245.89893774955738
						},
						["size"] = {
							["width"] = 1251.8181818181818,
							["height"] = 1802.7272727272725
						}
					},
					["176459141206211849894"] = {
						["key"] = "176459141206211849894",
						["name"] = "开始",
						["position"] = {
							["x"] = 1895.0264477524543,
							["y"] = -630.7747917716953
						},
						["size"] = {
							["width"] = 617.3684210526316,
							["height"] = 851.0526315789474
						}
					},
					["176459142423811850149"] = {
						["key"] = "176459142423811850149",
						["name"] = "跑图",
						["position"] = {
							["x"] = 2542.394868805086,
							["y"] = -629.1958444032741
						},
						["size"] = {
							["width"] = 587.6051311949141,
							["height"] = 853.1958444032741
						}
					},
					["176459190484711852080"] = {
						["key"] = "176459190484711852080",
						["name"] = "战斗",
						["position"] = {
							["x"] = 3209.1617860983188,
							["y"] = -623.4439647040258
						},
						["size"] = {
							["width"] = 1309.2857142857144,
							["height"] = 840
						}
					},
					["176459233262011854434"] = {
						["key"] = "176459233262011854434",
						["name"] = "对话",
						["position"] = {
							["x"] = 4581.661786098321,
							["y"] = -417.61429437435504
						},
						["size"] = {
							["width"] = 1120.3467054101711,
							["height"] = 753.7853732954356
						}
					},
					["176543737835561291520"] = {
						["key"] = "176543737835561291520",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 5819.457891406622,
							["y"] = -1090.536073642079
						},
						["size"] = {
							["width"] = 889.1085227553581,
							["height"] = 632.1041080640772
						}
					},
					["176543740170761291995"] = {
						["key"] = "176543740170761291995",
						["name"] = "探索组Vine",
						["position"] = {
							["x"] = 6793.5469530469545,
							["y"] = -849.9827672327655
						},
						["size"] = {
							["width"] = 1195.3846153846157,
							["height"] = 1160.7692307692307
						}
					}
				}
			}
		},
		["1756294960503647537"] = {
			["isStoryNode"] = true,
			["key"] = "1756294960503647537",
			["type"] = "StoryNode",
			["name"] = "【变量=1】",
			["pos"] = {
				["x"] = 1381.927408673286,
				["y"] = 205.93658486099505
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Nai03_01_00",
				["QuestDeatil"] = "Content_Nai03_01_01",
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
						["startQuest"] = "1756294960503647538",
						["startPort"] = "QuestStart",
						["endQuest"] = "1756295612336651493",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756295629681652000",
						["startPort"] = "Out",
						["endQuest"] = "1756297603370654302",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297603370654302",
						["startPort"] = "Out",
						["endQuest"] = "1756295604751651199",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299772253671026",
						["startPort"] = "Out",
						["endQuest"] = "1756294960503647541",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17563013713592584668",
						["startPort"] = "Out",
						["endQuest"] = "17563013713592584669",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756295612336651493",
						["startPort"] = "false",
						["endQuest"] = "1756294960503647541",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1756294960503647538",
						["startPort"] = "QuestStart",
						["endQuest"] = "17563013713592584668",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756295604751651199",
						["startPort"] = "Out",
						["endQuest"] = "17601532357436800",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601532357436800",
						["startPort"] = "Out",
						["endQuest"] = "1756299772253671026",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756295629681652000",
						["startPort"] = "Out",
						["endQuest"] = "176459339651012566482",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297603370654302",
						["startPort"] = "Out",
						["endQuest"] = "176459355551012567741",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756295612336651493",
						["startPort"] = "true",
						["endQuest"] = "176543734362961290589",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756295612336651493",
						["startPort"] = "true",
						["endQuest"] = "1756295629681652000",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563013713592584669",
						["startPort"] = "Out",
						["endQuest"] = "1756294960503647544",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1756294960503647538"] = {
						["key"] = "1756294960503647538",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 420.625,
							["y"] = 340
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756294960503647541"] = {
						["key"] = "1756294960503647541",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4508.550125313283,
							["y"] = 1483.0584415584417
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756294960503647544"] = {
						["key"] = "1756294960503647544",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1848.534090909091,
							["y"] = 1302.0795454545455
						},
						["propsData"] = {}
					},
					["1756295604751651199"] = {
						["key"] = "1756295604751651199",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3143.1115150071805,
							["y"] = 368.283293509111
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210092,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_WuYou_2320022",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 12018225,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1.5,
							["BlendOutTime"] = 1.5,
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
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1756295612336651493"] = {
						["key"] = "1756295612336651493",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=1",
						["pos"] = {
							["x"] = 769.5873205741625,
							["y"] = 328.37303485987684
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["1756295629681652000"] = {
						["key"] = "1756295629681652000",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2087.1131893356796,
							["y"] = 358.0751857455146
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320125,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320125"
						}
					},
					["1756297603370654302"] = {
						["key"] = "1756297603370654302",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2392.8510924172524,
							["y"] = 361.0149696402221
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320126,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320126"
						}
					},
					["1756299772253671026"] = {
						["key"] = "1756299772253671026",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 3743.223269461728,
							["y"] = 372.7270178428238
						},
						["propsData"] = {
							["VarName"] = "East01Nai03Phase",
							["VarValue"] = 2
						}
					},
					["17563013713592584668"] = {
						["key"] = "17563013713592584668",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 912.3708212617086,
							["y"] = 1293.5252638325323
						},
						["propsData"] = {}
					},
					["17563013713592584669"] = {
						["key"] = "17563013713592584669",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1205.204926262181,
							["y"] = 1309.4954747168435
						},
						["propsData"] = {}
					},
					["17601532357436800"] = {
						["key"] = "17601532357436800",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁NPC无由生",
						["pos"] = {
							["x"] = 3447.968999163781,
							["y"] = 370.39405635557273
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320021,
								2320022
							}
						}
					},
					["17603396194053089"] = {
						["key"] = "17603396194053089",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2969.4705882352937,
							["y"] = -275.48431372549027
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_GongMingShi02"
						}
					},
					["17603396204433142"] = {
						["key"] = "17603396204433142",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2998.915966386554,
							["y"] = -161.06834733893552
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_GongMingShi01"
						}
					},
					["17603396379863781"] = {
						["key"] = "17603396379863781",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 3111.020798319328,
							["y"] = -177.58053221288515
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_GongMingShi02"
						}
					},
					["17603396379863782"] = {
						["key"] = "17603396379863782",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 3148.213445378152,
							["y"] = -262.0655462184874
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_GongMingShi01"
						}
					},
					["176459339651012566482"] = {
						["key"] = "176459339651012566482",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2103.8635619943843,
							["y"] = 170.77230285306808
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_02_04",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176459355551012567741"] = {
						["key"] = "176459355551012567741",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2386.2165031708546,
							["y"] = 176.06642050012695
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_02_05",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176543734362961290589"] = {
						["key"] = "176543734362961290589",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成NPC无由生",
						["pos"] = {
							["x"] = 1306,
							["y"] = 81.860273137315
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320021,
								2320022
							}
						}
					}
				},
				["commentData"] = {
					["176459243173712550899"] = {
						["key"] = "176459243173712550899",
						["name"] = "失败逻辑",
						["position"] = {
							["x"] = 793.2253068139293,
							["y"] = 1178.1032821667495
						},
						["size"] = {
							["width"] = 1374.5246931860706,
							["height"] = 293.1335599385136
						}
					},
					["176459270305812556394"] = {
						["key"] = "176459270305812556394",
						["name"] = "跑图",
						["position"] = {
							["x"] = 2050.3975482609553,
							["y"] = -23.781498737498563
						},
						["size"] = {
							["width"] = 578.7601313804878,
							["height"] = 559.8479192376255
						}
					},
					["176459271702712556728"] = {
						["key"] = "176459271702712556728",
						["name"] = "对话",
						["position"] = {
							["x"] = 3058.755059686578,
							["y"] = 222.53930326751396
						},
						["size"] = {
							["width"] = 938.1038961038963,
							["height"] = 334.7532467532467
						}
					}
				}
			}
		},
		["1756297875070655989"] = {
			["isStoryNode"] = true,
			["key"] = "1756297875070655989",
			["type"] = "StoryNode",
			["name"] = "【变量=2】",
			["pos"] = {
				["x"] = 1775.185997910136,
				["y"] = 203.87614530055552
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Nai03_01_00",
				["QuestDeatil"] = "Content_Nai03_01_01",
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
						["startQuest"] = "1756297875070655990",
						["startPort"] = "QuestStart",
						["endQuest"] = "1756297891939656332",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297940093656580",
						["startPort"] = "Out",
						["endQuest"] = "1756297988349656802",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297988349656802",
						["startPort"] = "Out",
						["endQuest"] = "1756298071346657049",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297891939656332",
						["startPort"] = "false",
						["endQuest"] = "1756297875070655993",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1756299761909670666",
						["startPort"] = "Out",
						["endQuest"] = "1756297875070655993",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1756297875070655990",
						["startPort"] = "QuestStart",
						["endQuest"] = "17563013997582585404",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297988349656802",
						["startPort"] = "Out",
						["endQuest"] = "17591500084465308408",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298279497658761",
						["startPort"] = "Out",
						["endQuest"] = "17601644259379639",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17591500084465308408",
						["startPort"] = "Out",
						["endQuest"] = "17601728882286501007",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601728882286501007",
						["startPort"] = "Out",
						["endQuest"] = "1756298186974657973",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298186974657973",
						["startPort"] = "Out",
						["endQuest"] = "17601730066216501324",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297891939656332",
						["startPort"] = "true",
						["endQuest"] = "17603404589948222",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297891939656332",
						["startPort"] = "true",
						["endQuest"] = "17603420215841962355",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297988349656802",
						["startPort"] = "Out",
						["endQuest"] = "17603420460471963184",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297988349656802",
						["startPort"] = "Out",
						["endQuest"] = "17603422081701963944",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760426995628658726",
						["startPort"] = "Out",
						["endQuest"] = "1760426995628658728",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760426995628658728",
						["startPort"] = "Out",
						["endQuest"] = "1756298279497658761",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601730066216501324",
						["startPort"] = "Out",
						["endQuest"] = "1760426995628658726",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297891939656332",
						["startPort"] = "true",
						["endQuest"] = "176459360692912568498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297988349656802",
						["startPort"] = "Out",
						["endQuest"] = "176459383955312569554",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17591500084465308408",
						["startPort"] = "Out",
						["endQuest"] = "176459395855812569912",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760426995628658726",
						["startPort"] = "Out",
						["endQuest"] = "176459398326312570599",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760426995628658728",
						["startPort"] = "Out",
						["endQuest"] = "17645979109772965",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297988349656802",
						["startPort"] = "Out",
						["endQuest"] = "17646835576764458050",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756297891939656332",
						["startPort"] = "true",
						["endQuest"] = "17651758904397067242",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17651758904397067242",
						["startPort"] = "Out",
						["endQuest"] = "1756297940093656580",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601644259379639",
						["startPort"] = "Out",
						["endQuest"] = "1756299761909670666",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563013997582585404",
						["startPort"] = "Out",
						["endQuest"] = "17651759575197067935",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17651759575197067935",
						["startPort"] = "Out",
						["endQuest"] = "17563013997582585405",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563013997582585405",
						["startPort"] = "Out",
						["endQuest"] = "1756297875070655996",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1760426995628658726",
						["startPort"] = "Out",
						["endQuest"] = "17651785927758401",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17658839282091296062",
						["startPort"] = "PC",
						["endQuest"] = "17604287715923273921",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17658839282091296062",
						["startPort"] = "Mobile",
						["endQuest"] = "17658839151741295904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760426995628658726",
						["startPort"] = "Out",
						["endQuest"] = "17658839282091296062",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["1756297875070655990"] = {
						["key"] = "1756297875070655990",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 283.54066985645926,
							["y"] = 289.30143540669854
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756297875070655993"] = {
						["key"] = "1756297875070655993",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3837.446172248804,
							["y"] = 1327.4196001367054
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756297875070655996"] = {
						["key"] = "1756297875070655996",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1893.032894736842,
							["y"] = 1241.924043062201
						},
						["propsData"] = {}
					},
					["1756297891939656332"] = {
						["key"] = "1756297891939656332",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=2",
						["pos"] = {
							["x"] = 663.8235645933015,
							["y"] = 281.4473684210527
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["1756297940093656580"] = {
						["key"] = "1756297940093656580",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1481,
							["y"] = 290.75
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320128,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320128"
						}
					},
					["1756297988349656802"] = {
						["key"] = "1756297988349656802",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1842.5347744360902,
							["y"] = 298.22180451127815
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320129,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320129"
						}
					},
					["1756298071346657049"] = {
						["key"] = "1756298071346657049",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2256.0930453203846,
							["y"] = 66.2462423661255
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018232,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1756298186974657973"] = {
						["key"] = "1756298186974657973",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2582.6400375939857,
							["y"] = 290.3627819548873
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 50,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "MonsterPoint_Nai03Group1"
						}
					},
					["1756298279497658761"] = {
						["key"] = "1756298279497658761",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3663.5817558602394,
							["y"] = 306.4227111897391
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210090,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_WuYou_2320156",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 12018236,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1.5,
							["BlendOutTime"] = 1.5,
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
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1756299761909670666"] = {
						["key"] = "1756299761909670666",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 4562.223887438669,
							["y"] = 296.48467979389085
						},
						["propsData"] = {
							["VarName"] = "East01Nai03Phase",
							["VarValue"] = 3
						}
					},
					["17563013997582585404"] = {
						["key"] = "17563013997582585404",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 974.0512511259619,
							["y"] = 1224.0902271200196
						},
						["propsData"] = {}
					},
					["17563013997582585405"] = {
						["key"] = "17563013997582585405",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1589.2853561264346,
							["y"] = 1236.792256186149
						},
						["propsData"] = {}
					},
					["17591500084465308408"] = {
						["key"] = "17591500084465308408",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2259.5451127819547,
							["y"] = 302.2387218045113
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2320147,
							["StateId"] = 1310181,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_huaruiA"
						}
					},
					["17601644259379639"] = {
						["key"] = "17601644259379639",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁NPC无由生",
						["pos"] = {
							["x"] = 3964.237567298875,
							["y"] = 292.4060947969785
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320156,
								2320157
							}
						}
					},
					["17601728882286501007"] = {
						["key"] = "17601728882286501007",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2582.856316340365,
							["y"] = 88.35724348787963
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Huarui01CreateMon",
							["UnitId"] = -1
						}
					},
					["17601730066216501324"] = {
						["key"] = "17601730066216501324",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2867.2905268666814,
							["y"] = 81.55837130742847
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Huarui01DestroyMon",
							["UnitId"] = -1
						}
					},
					["17603404589948222"] = {
						["key"] = "17603404589948222",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成Monster战士",
						["pos"] = {
							["x"] = 1478.1893606810588,
							["y"] = -408.194442291368
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320149,
								2320150
							}
						}
					},
					["17603420215841962355"] = {
						["key"] = "17603420215841962355",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成NPC无由生",
						["pos"] = {
							["x"] = 1481.2236842105265,
							["y"] = -662.3666150670794
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320156,
								2320157
							}
						}
					},
					["17603420460471963184"] = {
						["key"] = "17603420460471963184",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁Monster战士",
						["pos"] = {
							["x"] = 2264.857769423558,
							["y"] = -621.1510762199614
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320149,
								2320150
							}
						}
					},
					["17603422081701963944"] = {
						["key"] = "17603422081701963944",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成Monster战士",
						["pos"] = {
							["x"] = 2269.8076441102753,
							["y"] = -405.8127303552999
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320176,
								2320177
							}
						}
					},
					["1760426995628658726"] = {
						["key"] = "1760426995628658726",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 2856.675950216383,
							["y"] = 305.99003819450905
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2320147
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310182,
							["QuestId"] = 0
						}
					},
					["1760426995628658728"] = {
						["key"] = "1760426995628658728",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 3190.039087377602,
							["y"] = 286.54651952670076
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2320147,
							["StateId"] = 1310183,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_huaruiA"
						}
					},
					["17604287715923273921"] = {
						["key"] = "17604287715923273921",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 3191.348971693941,
							["y"] = 457.59206103494034
						},
						["propsData"] = {
							["MessageId"] = 200038,
							["SkillNameList"] = {
								"Skill3"
							},
							["LastTime"] = -1,
							["bIsForceTouch"] = false,
							["bIsTimeDilation"] = false,
							["HighLightUIPath"] = "",
							["UICompName"] = "",
							["UIShape"] = "Square",
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["ForbidSuccessAnim"] = false,
							["IsNotForceRelease"] = false,
							["UICompSizeOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["176459360692912568498"] = {
						["key"] = "176459360692912568498",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1490.5003456811485,
							["y"] = -139.88018516571145
						},
						["propsData"] = {
							["NewDescription"] = "",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176459383955312569554"] = {
						["key"] = "176459383955312569554",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2248.5830527075686,
							["y"] = -127.73732625823254
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_03_02",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176459395855812569912"] = {
						["key"] = "176459395855812569912",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2575.2747817713744,
							["y"] = -73.22604982736571
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_03_03",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176459398326312570599"] = {
						["key"] = "176459398326312570599",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3208.032813213616,
							["y"] = -66.30875659428301
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_03_04",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17645979109772965"] = {
						["key"] = "17645979109772965",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3639.3766233766237,
							["y"] = 139.983957219251
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_03_05",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17646835576764458050"] = {
						["key"] = "17646835576764458050",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 2253.1350277820316,
							["y"] = 483.45764809597995
						},
						["propsData"] = {
							["GuideId"] = 109
						}
					},
					["17651758904397067242"] = {
						["key"] = "17651758904397067242",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成花蕊",
						["pos"] = {
							["x"] = 1070.3121775025802,
							["y"] = 281.38209494324013
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320147
							}
						}
					},
					["17651759575197067935"] = {
						["key"] = "17651759575197067935",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁花蕊",
						["pos"] = {
							["x"] = 1282.080457944488,
							["y"] = 1235.789122126583
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320147
							}
						}
					},
					["17651785927758401"] = {
						["key"] = "17651785927758401",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3213.763368983957,
							["y"] = -418.2052139037433
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018235,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17658839151741295904"] = {
						["key"] = "17658839151741295904",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 3215.7799808886766,
							["y"] = 622.9211859718451
						},
						["propsData"] = {
							["MessageId"] = 200038,
							["SkillNameList"] = {
								"Skill3"
							},
							["LastTime"] = -1,
							["bIsForceTouch"] = false,
							["bIsTimeDilation"] = false,
							["HighLightUIPath"] = "BattleMain.Char_Skill.SupportSkill",
							["UICompName"] = "Button_Area",
							["UIShape"] = "Square",
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["ForbidSuccessAnim"] = false,
							["IsNotForceRelease"] = false,
							["UICompSizeOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17658839282091296062"] = {
						["key"] = "17658839282091296062",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 2911.7799808886766,
							["y"] = 458.9800511858789
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {
					["176459274871512557495"] = {
						["key"] = "176459274871512557495",
						["name"] = "失败逻辑",
						["position"] = {
							["x"] = 924,
							["y"] = 1149.2727272727273
						},
						["size"] = {
							["width"] = 1263.365072573812,
							["height"] = 236.6075654987687
						}
					},
					["176459288029612560745"] = {
						["key"] = "176459288029612560745",
						["name"] = "花蕊战斗-1",
						["position"] = {
							["x"] = 1768.7979362484762,
							["y"] = -261.0257479362743
						},
						["size"] = {
							["width"] = 1731.7024094326728,
							["height"] = 869.0027056277056
						}
					},
					["176459459124712572333"] = {
						["key"] = "176459459124712572333",
						["name"] = "对话",
						["position"] = {
							["x"] = 3558.1054429832266,
							["y"] = -118.34944655447731
						},
						["size"] = {
							["width"] = 1322.2984143879212,
							["height"] = 714.8035232916671
						}
					}
				}
			}
		},
		["1756298431006659827"] = {
			["isStoryNode"] = true,
			["key"] = "1756298431006659827",
			["type"] = "StoryNode",
			["name"] = "【变量=3】",
			["pos"] = {
				["x"] = 1016.4284221525601,
				["y"] = 487.6663550907654
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Nai03_01_00",
				["QuestDeatil"] = "Content_Nai03_01_01",
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
						["startQuest"] = "1756298431007659828",
						["startPort"] = "QuestStart",
						["endQuest"] = "1756298637460661570",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298649155661964",
						["startPort"] = "Out",
						["endQuest"] = "1756298838737662244",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298838737662244",
						["startPort"] = "Out",
						["endQuest"] = "1756298957601663131",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298637460661570",
						["startPort"] = "false",
						["endQuest"] = "1756298431007659831",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1756299750957670271",
						["startPort"] = "Out",
						["endQuest"] = "1756298431007659831",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1756298431007659828",
						["startPort"] = "QuestStart",
						["endQuest"] = "17563014160842586005",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563014160842586006",
						["startPort"] = "Out",
						["endQuest"] = "1756298431007659834",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1756298975786663442",
						["startPort"] = "Out",
						["endQuest"] = "176016533416612771",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298838737662244",
						["startPort"] = "Out",
						["endQuest"] = "17591500578155309224",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17591500578155309224",
						["startPort"] = "Out",
						["endQuest"] = "17601730717127148767",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298934009662771",
						["startPort"] = "Out",
						["endQuest"] = "17601730717137148768",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298637460661570",
						["startPort"] = "true",
						["endQuest"] = "17603404881029233",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176016533416612771",
						["startPort"] = "Out",
						["endQuest"] = "1756299750957670271",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298649155661964",
						["startPort"] = "Out",
						["endQuest"] = "1760341083997661014",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298649155661964",
						["startPort"] = "Out",
						["endQuest"] = "1760341104681661602",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298838737662244",
						["startPort"] = "Out",
						["endQuest"] = "1760341319853662277",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298838737662244",
						["startPort"] = "Out",
						["endQuest"] = "1760341366820663595",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298649155661964",
						["startPort"] = "Out",
						["endQuest"] = "17603422476581965049",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298637460661570",
						["startPort"] = "true",
						["endQuest"] = "17603428269733261212",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17604245689179802881",
						["startPort"] = "Out",
						["endQuest"] = "17604268115714451",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17604268115714451",
						["startPort"] = "Out",
						["endQuest"] = "1756298975786663442",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601730717127148767",
						["startPort"] = "Out",
						["endQuest"] = "1756298934009662771",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17601730717137148768",
						["startPort"] = "Out",
						["endQuest"] = "17604245689179802881",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298637460661570",
						["startPort"] = "true",
						["endQuest"] = "1764598120458702363",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298838737662244",
						["startPort"] = "Out",
						["endQuest"] = "1764598089389702080",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17591500578155309224",
						["startPort"] = "Out",
						["endQuest"] = "1764598089389702081",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17604245689179802881",
						["startPort"] = "Out",
						["endQuest"] = "1764598089389702082",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17604268115714451",
						["startPort"] = "Out",
						["endQuest"] = "1764598089389702079",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756298637460661570",
						["startPort"] = "true",
						["endQuest"] = "17651778162547708729",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17651778162547708729",
						["startPort"] = "Out",
						["endQuest"] = "1756298649155661964",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563014160842586005",
						["startPort"] = "Out",
						["endQuest"] = "17651778321947709193",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17651778321947709193",
						["startPort"] = "Out",
						["endQuest"] = "17563014160842586006",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17604245689179802881",
						["startPort"] = "Out",
						["endQuest"] = "17651785195057433",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17658839687621936435",
						["startPort"] = "PC",
						["endQuest"] = "17604267649913564",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17658839687621936435",
						["startPort"] = "Mobile",
						["endQuest"] = "17658839607711936294",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17604245689179802881",
						["startPort"] = "Out",
						["endQuest"] = "17658839687621936435",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["1756298431007659828"] = {
						["key"] = "1756298431007659828",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 352.9473684210526,
							["y"] = 308.7368421052631
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756298431007659831"] = {
						["key"] = "1756298431007659831",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4495.428571428572,
							["y"] = 935.2619047619048
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756298431007659834"] = {
						["key"] = "1756298431007659834",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1817.4736842105262,
							["y"] = 1265.578947368421
						},
						["propsData"] = {}
					},
					["1756298637460661570"] = {
						["key"] = "1756298637460661570",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=3",
						["pos"] = {
							["x"] = 661.9999999999998,
							["y"] = 292.5
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "3"
								}
							}
						}
					},
					["1756298649155661964"] = {
						["key"] = "1756298649155661964",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1490.7727272727273,
							["y"] = 284.7631578947368
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320133,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320133"
						}
					},
					["1756298838737662244"] = {
						["key"] = "1756298838737662244",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1807.008971291866,
							["y"] = 290.69736842105266
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320134,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320134"
						}
					},
					["1756298934009662771"] = {
						["key"] = "1756298934009662771",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2480.7543859649127,
							["y"] = 285.10526315789474
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 50,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "MonsterPoint_Nai03Group2"
						}
					},
					["1756298957601663131"] = {
						["key"] = "1756298957601663131",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2117.169768312183,
							["y"] = -107.08681488789844
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018238,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1756298975786663442"] = {
						["key"] = "1756298975786663442",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3670.605052068675,
							["y"] = 313.1093598523938
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 210094,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Wuyou_2320158",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 12018240,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 2,
							["BlendOutTime"] = 2,
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
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1756299750957670271"] = {
						["key"] = "1756299750957670271",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 4313.1659546593755,
							["y"] = 308.60429482797895
						},
						["propsData"] = {
							["VarName"] = "East01Nai03Phase",
							["VarValue"] = 4
						}
					},
					["17563014160842586005"] = {
						["key"] = "17563014160842586005",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 882.3720224598917,
							["y"] = 1259.0320396934105
						},
						["propsData"] = {}
					},
					["17563014160842586006"] = {
						["key"] = "17563014160842586006",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1513.311390618259,
							["y"] = 1271.9603845490137
						},
						["propsData"] = {}
					},
					["17591500578155309224"] = {
						["key"] = "17591500578155309224",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2146.259343210969,
							["y"] = 295.4747530591184
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2320148,
							["StateId"] = 1310181,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_huaruiB"
						}
					},
					["176016533416612771"] = {
						["key"] = "176016533416612771",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁NPC无由生",
						["pos"] = {
							["x"] = 4000.773951150662,
							["y"] = 305.0444554043794
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320158,
								2320159
							}
						}
					},
					["17601730717127148767"] = {
						["key"] = "17601730717127148767",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2491.147917871602,
							["y"] = 109.10549383537047
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Huarui02CreateMon",
							["UnitId"] = -1
						}
					},
					["17601730717137148768"] = {
						["key"] = "17601730717137148768",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2797.7277498043754,
							["y"] = 109.77930458774145
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Huarui02DestroyMon",
							["UnitId"] = -1
						}
					},
					["17603404881029233"] = {
						["key"] = "17603404881029233",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成Monster斗士",
						["pos"] = {
							["x"] = 1440.2417582417581,
							["y"] = -527.2582417582419
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320152,
								2320153
							}
						}
					},
					["1760341083997661014"] = {
						["key"] = "1760341083997661014",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁Monster斗士",
						["pos"] = {
							["x"] = 1786.132942650744,
							["y"] = -679.6643305095317
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320152,
								2320153
							}
						}
					},
					["1760341104681661602"] = {
						["key"] = "1760341104681661602",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成Monster战士&斗士",
						["pos"] = {
							["x"] = 1782.5520407939798,
							["y"] = -528.4229511991871
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320172,
								2320173,
								2320174,
								2320175
							}
						}
					},
					["1760341319853662277"] = {
						["key"] = "1760341319853662277",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁Monster战士&斗士",
						["pos"] = {
							["x"] = 2174.7565690243705,
							["y"] = -625.260725600509
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320172,
								2320173,
								2320174,
								2320175
							}
						}
					},
					["1760341366820663595"] = {
						["key"] = "1760341366820663595",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成Monster战士&斗士",
						["pos"] = {
							["x"] = 2175.4059196737207,
							["y"] = -490.92955676934014
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320178,
								2320179,
								2320180,
								2320181
							}
						}
					},
					["17603422476581965049"] = {
						["key"] = "17603422476581965049",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成Monster战士",
						["pos"] = {
							["x"] = 1784.3066703722977,
							["y"] = -834.1701184197414
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320176,
								2320177
							}
						}
					},
					["17603428269733261212"] = {
						["key"] = "17603428269733261212",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成NPC法师",
						["pos"] = {
							["x"] = 1439.3393168605064,
							["y"] = -660.1942355060478
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320158,
								2320159
							}
						}
					},
					["17604245689179802881"] = {
						["key"] = "17604245689179802881",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 2787.989872872225,
							["y"] = 312.3798750269339
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2320148
							},
							["ManualItemIdList"] = {},
							["StateId"] = 1310182,
							["QuestId"] = 0
						}
					},
					["17604267649913564"] = {
						["key"] = "17604267649913564",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 3210.607566505905,
							["y"] = 532.7731485333607
						},
						["propsData"] = {
							["MessageId"] = 200038,
							["SkillNameList"] = {
								"Skill3"
							},
							["LastTime"] = -1,
							["bIsForceTouch"] = false,
							["bIsTimeDilation"] = false,
							["HighLightUIPath"] = "",
							["UICompName"] = "",
							["UIShape"] = "Square",
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["ForbidSuccessAnim"] = false,
							["IsNotForceRelease"] = false,
							["UICompSizeOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17604268115714451"] = {
						["key"] = "17604268115714451",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 3174.654994160428,
							["y"] = 307.43760949195746
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2320148,
							["StateId"] = 1310183,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_huaruiB"
						}
					},
					["1764598089389702079"] = {
						["key"] = "1764598089389702079",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3652.2430869804566,
							["y"] = 37.439179545322304
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_04_05",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1764598089389702080"] = {
						["key"] = "1764598089389702080",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2114.7834759516477,
							["y"] = 85.12860858893126
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_04_02",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1764598089389702081"] = {
						["key"] = "1764598089389702081",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2489.634666427839,
							["y"] = -42.014248553925995
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_04_03",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1764598089389702082"] = {
						["key"] = "1764598089389702082",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3159.399276817449,
							["y"] = -107.72853426821169
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_04_04",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1764598120458702363"] = {
						["key"] = "1764598120458702363",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1436.1263767041476,
							["y"] = -364.135748790016
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_04_01",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17651778162547708729"] = {
						["key"] = "17651778162547708729",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1103.5899122807018,
							["y"] = 282.4583333333334
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320148
							}
						}
					},
					["17651778321947709193"] = {
						["key"] = "17651778321947709193",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1212.9232456140353,
							["y"] = 1272.982142857143
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320148
							}
						}
					},
					["17651785195057433"] = {
						["key"] = "17651785195057433",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3160,
							["y"] = -334.8000000000001
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12018235,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17658839607711936294"] = {
						["key"] = "17658839607711936294",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 3230.2042364392632,
							["y"] = 675.4886775880525
						},
						["propsData"] = {
							["MessageId"] = 200038,
							["SkillNameList"] = {
								"Skill3"
							},
							["LastTime"] = -1,
							["bIsForceTouch"] = false,
							["bIsTimeDilation"] = false,
							["HighLightUIPath"] = "BattleMain.Char_Skill.SupportSkill",
							["UICompName"] = "Button_Area",
							["UIShape"] = "Square",
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["ForbidSuccessAnim"] = false,
							["IsNotForceRelease"] = false,
							["UICompSizeOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17658839687621936435"] = {
						["key"] = "17658839687621936435",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 2930.48010379256,
							["y"] = 549.8234114707952
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {
					["1764597985768699010"] = {
						["key"] = "1764597985768699010",
						["name"] = "失败逻辑",
						["position"] = {
							["x"] = 775.9821981424149,
							["y"] = 1170.1033281733746
						},
						["size"] = {
							["width"] = 1452.9410474716205,
							["height"] = 274.87881468376827
						}
					},
					["1764598007823699540"] = {
						["key"] = "1764598007823699540",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1348.3393409995576,
							["y"] = -909.3026868642194
						},
						["size"] = {
							["width"] = 704.2156071331614,
							["height"] = 693.0240809313461
						}
					},
					["1764598142355703021"] = {
						["key"] = "1764598142355703021",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 2097.554948132719,
							["y"] = -717.7071773614446
						},
						["size"] = {
							["width"] = 400.7142857142857,
							["height"] = 381.42857142857144
						}
					},
					["1764598187749703596"] = {
						["key"] = "1764598187749703596",
						["name"] = "花蕊战斗-2",
						["position"] = {
							["x"] = 1797.0787576565285,
							["y"] = -207.23098688525423
						},
						["size"] = {
							["width"] = 1651.6946778711485,
							["height"] = 708.4177170868344
						}
					},
					["1764598212685704217"] = {
						["key"] = "1764598212685704217",
						["name"] = "对话",
						["position"] = {
							["x"] = 3572.952006956248,
							["y"] = -120.02755551270567
						},
						["size"] = {
							["width"] = 998.9652479873071,
							["height"] = 604.2355291767055
						}
					}
				}
			}
		},
		["1756299211245664400"] = {
			["isStoryNode"] = true,
			["key"] = "1756299211245664400",
			["type"] = "StoryNode",
			["name"] = "【变量=4】",
			["pos"] = {
				["x"] = 1386.9136470725673,
				["y"] = 481.50817993259017
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Nai03_01_00",
				["QuestDeatil"] = "Content_Nai03_01_01",
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
						["startQuest"] = "1756299488265668148",
						["startPort"] = "true",
						["endQuest"] = "1756299488265668149",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299211245664401",
						["startPort"] = "QuestStart",
						["endQuest"] = "1756299488265668148",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299488265668148",
						["startPort"] = "false",
						["endQuest"] = "1756299211245664404",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1756299664387669359",
						["startPort"] = "Out",
						["endQuest"] = "1756299211245664404",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17563014237812586307",
						["startPort"] = "Out",
						["endQuest"] = "17563014237812586308",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299211245664401",
						["startPort"] = "QuestStart",
						["endQuest"] = "17563014237812586307",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563014237812586308",
						["startPort"] = "Out",
						["endQuest"] = "1756299211245664407",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1756299488265668148",
						["startPort"] = "true",
						["endQuest"] = "17603405078789970",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760341427703664920",
						["startPort"] = "Out",
						["endQuest"] = "1760341466266665844",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1760341438853665234",
						["startPort"] = "Out",
						["endQuest"] = "1760341466266665844",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17563002106491309252",
						["startPort"] = "Out",
						["endQuest"] = "1760341438853665234",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563002106491309252",
						["startPort"] = "Out",
						["endQuest"] = "1760341427703664920",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760341466266665844",
						["startPort"] = "Out",
						["endQuest"] = "1756299664387669359",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299488265668148",
						["startPort"] = "true",
						["endQuest"] = "17604246174139804289",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299488265668149",
						["startPort"] = "Out",
						["endQuest"] = "17604300713199155308",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299488265668149",
						["startPort"] = "Out",
						["endQuest"] = "17563002106491309252",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299488265668148",
						["startPort"] = "true",
						["endQuest"] = "17645984708551404631",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299488265668149",
						["startPort"] = "Out",
						["endQuest"] = "17645984903201404912",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1756299211245664401"] = {
						["key"] = "1756299211245664401",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 798.5714285714286,
							["y"] = 381.1904761904762
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756299211245664404"] = {
						["key"] = "1756299211245664404",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3527.307422969188,
							["y"] = 1042.9682327476446
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756299211245664407"] = {
						["key"] = "1756299211245664407",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1745.6249999999998,
							["y"] = 983.125
						},
						["propsData"] = {}
					},
					["1756299488265668148"] = {
						["key"] = "1756299488265668148",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=4",
						["pos"] = {
							["x"] = 1135.4166666666665,
							["y"] = 369.14285714285717
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "4"
								}
							}
						}
					},
					["1756299488265668149"] = {
						["key"] = "1756299488265668149",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1626.2069059681291,
							["y"] = 373.561299639473
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320141,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320141"
						}
					},
					["1756299643707668896"] = {
						["key"] = "1756299643707668896",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2461.7032459957154,
							["y"] = -369.87512805205284
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 8,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["1756299664387669359"] = {
						["key"] = "1756299664387669359",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 3317.8091183841957,
							["y"] = 415.70918104083745
						},
						["propsData"] = {
							["VarName"] = "East01Nai03Phase",
							["VarValue"] = 5
						}
					},
					["17563002106491309252"] = {
						["key"] = "17563002106491309252",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2479.701485170728,
							["y"] = 391.4098457460789
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320144,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320144"
						}
					},
					["17563014237812586307"] = {
						["key"] = "17563014237812586307",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1118.9844844303261,
							["y"] = 969.1500838010058
						},
						["propsData"] = {}
					},
					["17563014237812586308"] = {
						["key"] = "17563014237812586308",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1398.276922764132,
							["y"] = 980.3854462004687
						},
						["propsData"] = {}
					},
					["17603405078789970"] = {
						["key"] = "17603405078789970",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成Monster法师",
						["pos"] = {
							["x"] = 1621.2039959524482,
							["y"] = 193.51741653599234
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320154,
								2320155
							}
						}
					},
					["1760341427703664920"] = {
						["key"] = "1760341427703664920",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁Monster战士&斗士",
						["pos"] = {
							["x"] = 2754.3623765295592,
							["y"] = 479.53930782839467
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320178,
								2320179,
								2320180,
								2320181
							}
						}
					},
					["1760341438853665234"] = {
						["key"] = "1760341438853665234",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁Monster法师",
						["pos"] = {
							["x"] = 2748.3211865982094,
							["y"] = 289.9969737322848
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320154,
								2320155
							}
						}
					},
					["1760341466266665844"] = {
						["key"] = "1760341466266665844",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 3024.6140927766983,
							["y"] = 390.56905611214745
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17604246174139804289"] = {
						["key"] = "17604246174139804289",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成钩锁",
						["pos"] = {
							["x"] = 1628.4702777199918,
							["y"] = 4.231580680951286
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320111,
								2320112
							}
						}
					},
					["17604300713199155308"] = {
						["key"] = "17604300713199155308",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成怪物",
						["pos"] = {
							["x"] = 2030.2991470771794,
							["y"] = 198.75629290617843
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320098,
								2320099,
								2320100,
								2320101,
								2320102,
								2320103,
								2320104,
								2320105,
								2320106,
								2320107,
								2320108,
								2320109
							}
						}
					},
					["17645984708551404631"] = {
						["key"] = "17645984708551404631",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1629.7572809027924,
							["y"] = -186.9575995469959
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_05_01",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17645984903201404912"] = {
						["key"] = "17645984903201404912",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2013.4362906802003,
							["y"] = 30.955859991177647
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_05_01",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					}
				},
				["commentData"] = {
					["17645983262021401681"] = {
						["key"] = "17645983262021401681",
						["name"] = "失败逻辑",
						["position"] = {
							["x"] = 1053.4436274509803,
							["y"] = 895.2794117647059
						},
						["size"] = {
							["width"] = 1030,
							["height"] = 261.6666666666665
						}
					},
					["17645988819121405968"] = {
						["key"] = "17645988819121405968",
						["name"] = "跑图",
						["position"] = {
							["x"] = 1538.8511024130898,
							["y"] = -293.8637780366985
						},
						["size"] = {
							["width"] = 729.6363636363637,
							["height"] = 839.2727272727274
						}
					},
					["17645988985701406446"] = {
						["key"] = "17645988985701406446",
						["name"] = "到达",
						["position"] = {
							["x"] = 2440.2259030510486,
							["y"] = 195.20958719456146
						},
						["size"] = {
							["width"] = 831.2349054454315,
							["height"] = 437.2997711670479
						}
					}
				}
			}
		},
		["1756299365880664768"] = {
			["isStoryNode"] = true,
			["key"] = "1756299365880664768",
			["type"] = "StoryNode",
			["name"] = "【变量=5】",
			["pos"] = {
				["x"] = 1765.5234141171172,
				["y"] = 483.63440153707273
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_Nai03_01_00",
				["QuestDeatil"] = "Content_Nai03_01_01",
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
						["startQuest"] = "1756299365880664769",
						["startPort"] = "QuestStart",
						["endQuest"] = "17562998242781306404",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562998853801307573",
						["startPort"] = "Out",
						["endQuest"] = "17562998886371307648",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562998242781306404",
						["startPort"] = "true",
						["endQuest"] = "17562998950531307822",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563011525331312813",
						["startPort"] = "Out",
						["endQuest"] = "1756299365880664772",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17563014338542586739",
						["startPort"] = "Out",
						["endQuest"] = "17563014338552586740",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756299365880664769",
						["startPort"] = "QuestStart",
						["endQuest"] = "17563014338542586739",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563014338552586740",
						["startPort"] = "Out",
						["endQuest"] = "1756299365880664775",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17562998242781306404",
						["startPort"] = "false",
						["endQuest"] = "1756299365880664772",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17562998242781306404",
						["startPort"] = "true",
						["endQuest"] = "17601846845613897511",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562998886371307648",
						["startPort"] = "Out",
						["endQuest"] = "17563011525331312813",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17645807237777668014",
						["startPort"] = "Out",
						["endQuest"] = "17645892196307676140",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17645807237777668014",
						["startPort"] = "Out",
						["endQuest"] = "17645892547337676550",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17645892547337676550",
						["startPort"] = "Out",
						["endQuest"] = "17562998853801307573",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562998950531307822",
						["startPort"] = "Out",
						["endQuest"] = "17645893130847677281",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17645893130847677281",
						["startPort"] = "Out",
						["endQuest"] = "17645807237777668014",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562998242781306404",
						["startPort"] = "true",
						["endQuest"] = "17645990354812104101",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17645892547337676550",
						["startPort"] = "Out",
						["endQuest"] = "17645990488942104452",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17645892547337676550",
						["startPort"] = "Out",
						["endQuest"] = "17603417017271314042",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17603417017271314042",
						["startPort"] = "Out",
						["endQuest"] = "17645996158832105115",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17645996779682105541",
						["startPort"] = "Out",
						["endQuest"] = "17645996779682105542",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17645892547337676550",
						["startPort"] = "Out",
						["endQuest"] = "17645996779682105541",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562998886371307648",
						["startPort"] = "Out",
						["endQuest"] = "17645997211982105969",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562998886371307648",
						["startPort"] = "Out",
						["endQuest"] = "17645997211982105970",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1756299365880664769"] = {
						["key"] = "1756299365880664769",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 794.7142857142857,
							["y"] = 419.57142857142856
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756299365880664772"] = {
						["key"] = "1756299365880664772",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4071.232142857143,
							["y"] = 1171.5059523809525
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756299365880664775"] = {
						["key"] = "1756299365880664775",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1652.9047619047617,
							["y"] = 1097
						},
						["propsData"] = {}
					},
					["17562998242781306404"] = {
						["key"] = "17562998242781306404",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=5",
						["pos"] = {
							["x"] = 1135.7619047619048,
							["y"] = 406.90476190476187
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East01Nai03Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "5"
								}
							}
						}
					},
					["17562998853801307573"] = {
						["key"] = "17562998853801307573",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2743.9343021585582,
							["y"] = 412.7727916629518
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320026
							}
						}
					},
					["17562998886371307648"] = {
						["key"] = "17562998886371307648",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 3072.278933499758,
							["y"] = 412.8252069567859
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2320026
							}
						}
					},
					["17562998950531307822"] = {
						["key"] = "17562998950531307822",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1458.1125541125539,
							["y"] = 403.3766233766235
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320145,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320145"
						}
					},
					["17563011525331312813"] = {
						["key"] = "17563011525331312813",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 3874.533363979015,
							["y"] = 424.75532800532807
						},
						["propsData"] = {
							["VarName"] = "East01Nai03Phase",
							["VarValue"] = 6
						}
					},
					["17563014338542586739"] = {
						["key"] = "17563014338542586739",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 997.2753837185155,
							["y"] = 1086.5953754804304
						},
						["propsData"] = {}
					},
					["17563014338552586740"] = {
						["key"] = "17563014338552586740",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1304.5618696713689,
							["y"] = 1098.0926426417982
						},
						["propsData"] = {}
					},
					["17601846845613897511"] = {
						["key"] = "17601846845613897511",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成Monster无由生",
						["pos"] = {
							["x"] = 1449.2701732971113,
							["y"] = 155.6224654781662
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320166,
								2320167,
								2320168,
								2320169,
								2320170,
								2320171
							}
						}
					},
					["17603417017271314042"] = {
						["key"] = "17603417017271314042",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2823.051734996058,
							["y"] = -8.705024229371276
						},
						["propsData"] = {
							["WaitTime"] = 15
						}
					},
					["17645807237777668014"] = {
						["key"] = "17645807237777668014",
						["type"] = "TalkNode",
						["name"] = "【Show_Nai03_Boss】",
						["pos"] = {
							["x"] = 1989.3332639900143,
							["y"] = 407.6837944664032
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East01/Nai03/Show_Nai03_Boss",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = false,
							["HideMechanismsFX"] = false,
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
					["17645892196307676140"] = {
						["key"] = "17645892196307676140",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成女主魅影",
						["pos"] = {
							["x"] = 2442.18859022702,
							["y"] = 221.09469849932958
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320209
							}
						}
					},
					["17645892547337676550"] = {
						["key"] = "17645892547337676550",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2442.151110163224,
							["y"] = 406.256580477001
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "RespawnPoint_BossFight",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17645893130847677281"] = {
						["key"] = "17645893130847677281",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁女主魅影",
						["pos"] = {
							["x"] = 1708.796473571746,
							["y"] = 414.51324486524436
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320203,
								2320204,
								2320205,
								2320206,
								2320207,
								2320208,
								2320209
							}
						}
					},
					["17645990354812104101"] = {
						["key"] = "17645990354812104101",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1449.0258048195356,
							["y"] = -18.274824762440915
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_06_01",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17645990488942104452"] = {
						["key"] = "17645990488942104452",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2816.5353540937913,
							["y"] = -220.76145577848376
						},
						["propsData"] = {
							["NewDescription"] = "Description_Nai03_06_02",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17645996158832105115"] = {
						["key"] = "17645996158832105115",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成杂鱼",
						["pos"] = {
							["x"] = 3098.069880948011,
							["y"] = 2.9086209478588447
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320210,
								2320211,
								2320212,
								2320213,
								2320214,
								2320215,
								2320216,
								2320217,
								2320218,
								2320219,
								2320220,
								2320221
							}
						}
					},
					["17645996779682105541"] = {
						["key"] = "17645996779682105541",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2821.541809068125,
							["y"] = 171.3984735510597
						},
						["propsData"] = {
							["WaitTime"] = 30
						}
					},
					["17645996779682105542"] = {
						["key"] = "17645996779682105542",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成杂鱼",
						["pos"] = {
							["x"] = 3100.472998498339,
							["y"] = 180.40342307611593
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320222,
								2320223,
								2320224,
								2320225,
								2320226,
								2320227,
								2320228,
								2320229,
								2320230,
								2320231,
								2320232,
								2320233
							}
						}
					},
					["17645997211982105969"] = {
						["key"] = "17645997211982105969",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁杂鱼",
						["pos"] = {
							["x"] = 3506.3275841385025,
							["y"] = 5.932811463506113
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320210,
								2320211,
								2320212,
								2320213,
								2320214,
								2320215,
								2320216,
								2320217,
								2320218,
								2320219,
								2320220,
								2320221
							}
						}
					},
					["17645997211982105970"] = {
						["key"] = "17645997211982105970",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁杂鱼",
						["pos"] = {
							["x"] = 3513.1812511393805,
							["y"] = 162.49354765769726
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2320222,
								2320223,
								2320224,
								2320225,
								2320226,
								2320227,
								2320228,
								2320229,
								2320230,
								2320231,
								2320232,
								2320233
							}
						}
					}
				},
				["commentData"] = {
					["17645983829891403277"] = {
						["key"] = "17645983829891403277",
						["name"] = "失败逻辑",
						["position"] = {
							["x"] = 862,
							["y"] = 986
						},
						["size"] = {
							["width"] = 1068,
							["height"] = 318
						}
					},
					["17646450789243828197"] = {
						["key"] = "17646450789243828197",
						["name"] = "Boss战",
						["position"] = {
							["x"] = 2369.7422969187674,
							["y"] = -467.5714285714284
						},
						["size"] = {
							["width"] = 1367.142857142857,
							["height"] = 1200
						}
					}
				}
			}
		},
		["17562998588441306814"] = {
			["isStoryNode"] = true,
			["key"] = "17562998588441306814",
			["type"] = "StoryNode",
			["name"] = "【变量=6】",
			["pos"] = {
				["x"] = 2165.0346709762007,
				["y"] = 477.4142494542204
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
				["QuestDeatil"] = "Content_Nai03_01_01",
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
						["startQuest"] = "17563012213761313836",
						["startPort"] = "Out",
						["endQuest"] = "17563012213761313835",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563012324451314036",
						["startPort"] = "Out",
						["endQuest"] = "17563012324451314037",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562998588441306815",
						["startPort"] = "QuestStart",
						["endQuest"] = "17563012324451314036",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563012324451314037",
						["startPort"] = "Out",
						["endQuest"] = "17562998588441306821",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17562998588441306815",
						["startPort"] = "QuestStart",
						["endQuest"] = "17563012883581314677",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562998588441306815",
						["startPort"] = "QuestStart",
						["endQuest"] = "17640381320348255324",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17563012883581314677",
						["startPort"] = "Out",
						["endQuest"] = "17640381374598255547",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17640381374598255547",
						["startPort"] = "Out",
						["endQuest"] = "17563012213761313836",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17562998588441306815"] = {
						["key"] = "17562998588441306815",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 937.5,
							["y"] = 480.625
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17562998588441306818"] = {
						["key"] = "17562998588441306818",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17562998588441306821"] = {
						["key"] = "17562998588441306821",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1928,
							["y"] = 624
						},
						["propsData"] = {}
					},
					["17563011328711312097"] = {
						["key"] = "17563011328711312097",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1257.375,
							["y"] = -91.5
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2320146,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_2320146"
						}
					},
					["17563012213761313835"] = {
						["key"] = "17563012213761313835",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2233.2328630245934,
							["y"] = 402.4186633463453
						},
						["propsData"] = {}
					},
					["17563012213761313836"] = {
						["key"] = "17563012213761313836",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1913.0434527648804,
							["y"] = 411.57475770628633
						},
						["propsData"] = {}
					},
					["17563012324451314036"] = {
						["key"] = "17563012324451314036",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1284.1365189283351,
							["y"] = 612.3882711812212
						},
						["propsData"] = {}
					},
					["17563012324451314037"] = {
						["key"] = "17563012324451314037",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1604.7384810716649,
							["y"] = 625.486728818779
						},
						["propsData"] = {}
					},
					["17563012883581314677"] = {
						["key"] = "17563012883581314677",
						["type"] = "TalkNode",
						["name"] = "【SC020】离开幻境",
						["pos"] = {
							["x"] = 1282.171052631579,
							["y"] = 412.2960526315789
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC020/SQ_Ver0101_SC020",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = false,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = false,
							["HideMechanismsFX"] = false,
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
					["17640381320348255324"] = {
						["key"] = "17640381320348255324",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1274.8604118993135,
							["y"] = 272.4164759725401
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/1_1/0116_cs_fushuhuanjing",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								105001
							},
							["bStoreToServer"] = false
						}
					},
					["17640381374598255547"] = {
						["key"] = "17640381374598255547",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1599.6842105263158,
							["y"] = 408.3157894736843
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
		}
	},
	["commentData"] = {}
}