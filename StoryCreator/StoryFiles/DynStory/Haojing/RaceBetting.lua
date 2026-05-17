return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17605179142131",
			["startPort"] = "StoryStart",
			["endStory"] = "176051798095986",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176051798095986",
			["startPort"] = "Success",
			["endStory"] = "17605179142135",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17605179142131"] = {
			["isStoryNode"] = true,
			["key"] = "17605179142131",
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
		["17605179142135"] = {
			["isStoryNode"] = true,
			["key"] = "17605179142135",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1662.3076923076922,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176051798095986"] = {
			["isStoryNode"] = true,
			["key"] = "176051798095986",
			["type"] = "StoryNode",
			["name"] = "赛跑竞猜",
			["pos"] = {
				["x"] = 1169.7692307692307,
				["y"] = 286.2307692307692
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_RaceBetting_Des",
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
						["startQuest"] = "176051798095987",
						["startPort"] = "QuestStart",
						["endQuest"] = "1760518880593427",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760518880593427",
						["startPort"] = "Out",
						["endQuest"] = "1760518894265672",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760518880593427",
						["startPort"] = "Out",
						["endQuest"] = "17605190532281078",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520159028658105",
						["startPort"] = "Out",
						["endQuest"] = "1760523939807664678",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520159028658105",
						["startPort"] = "Out",
						["endQuest"] = "1760520562193661001",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520159028658105",
						["startPort"] = "Out",
						["endQuest"] = "1760523941026664719",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520562193661001",
						["startPort"] = "Out",
						["endQuest"] = "1760524141070668721",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "1760523939807664678",
						["startPort"] = "Out",
						["endQuest"] = "1760524141070668721",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1760523941026664719",
						["startPort"] = "Out",
						["endQuest"] = "1760524141070668721",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "1760520284508659693",
						["startPort"] = "Option_1",
						["endQuest"] = "17605249835421329467",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17605249835421329467",
						["startPort"] = "Out",
						["endQuest"] = "1760520628746662285",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17605249835421329467",
						["startPort"] = "Out",
						["endQuest"] = "1760520599738661864",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520284508659693",
						["startPort"] = "Option_2",
						["endQuest"] = "17605251202701986695",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1760520284508659693",
						["startPort"] = "Option_3",
						["endQuest"] = "17605251214171986730",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17605251202701986695",
						["startPort"] = "Out",
						["endQuest"] = "17605251946541987940",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605251214171986730",
						["startPort"] = "Out",
						["endQuest"] = "17605251973691988025",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605251202701986695",
						["startPort"] = "Out",
						["endQuest"] = "1760520628746662285",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17605251214171986730",
						["startPort"] = "Out",
						["endQuest"] = "1760520628746662285",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "1760520628746662285",
						["startPort"] = "Out",
						["endQuest"] = "17605252644891988382",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605252644891988382",
						["startPort"] = "Out",
						["endQuest"] = "176051798095994",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1760520599738661864",
						["startPort"] = "Out",
						["endQuest"] = "17605252716841988609",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605252716841988609",
						["startPort"] = "Out",
						["endQuest"] = "176051798095994",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17605251946541987940",
						["startPort"] = "Out",
						["endQuest"] = "17605252759811988734",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605252759811988734",
						["startPort"] = "Out",
						["endQuest"] = "176051798095994",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17605251973691988025",
						["startPort"] = "Out",
						["endQuest"] = "17605252796091988847",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605252796091988847",
						["startPort"] = "Out",
						["endQuest"] = "176051798095994",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1760520191491658910",
						["startPort"] = "Out",
						["endQuest"] = "17605297146141217",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297308641698",
						["startPort"] = "Out",
						["endQuest"] = "1760523941026664719",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297308641698",
						["startPort"] = "Out",
						["endQuest"] = "1760523939807664678",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297308641698",
						["startPort"] = "Out",
						["endQuest"] = "1760520562193661001",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297298141654",
						["startPort"] = "Out",
						["endQuest"] = "1760520562193661001",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297298141654",
						["startPort"] = "Out",
						["endQuest"] = "1760523939807664678",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297298141654",
						["startPort"] = "Out",
						["endQuest"] = "1760523941026664719",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605190532281078",
						["startPort"] = "Option_2",
						["endQuest"] = "17606142129731976326",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297146141217",
						["startPort"] = "WeightBranch_1",
						["endQuest"] = "17606911432143289524",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17606911432143289524",
						["startPort"] = "Out",
						["endQuest"] = "17606911395353289399",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17606911395353289399",
						["startPort"] = "Out",
						["endQuest"] = "17605297298141654",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297146141217",
						["startPort"] = "WeightBranch_2",
						["endQuest"] = "17606912603543290516",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17606912603543290516",
						["startPort"] = "Out",
						["endQuest"] = "17606912622803290566",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17606912622803290566",
						["startPort"] = "Out",
						["endQuest"] = "17605297308641698",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297146141217",
						["startPort"] = "WeightBranch_3",
						["endQuest"] = "17606912872863291118",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17606912872863291118",
						["startPort"] = "Out",
						["endQuest"] = "17606912856353291067",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17606912856353291067",
						["startPort"] = "Out",
						["endQuest"] = "1760520159028658105",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605194159991859",
						["startPort"] = "Out",
						["endQuest"] = "17605194079631643",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17609455408731975092",
						["startPort"] = "Out",
						["endQuest"] = "17609455408731975091",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760524141070668721",
						["startPort"] = "Out",
						["endQuest"] = "17609455408731975092",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17609455408731975091",
						["startPort"] = "Out",
						["endQuest"] = "1760520628746662285",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17609468768963956108",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956109",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956108",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956110",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956109",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956108",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956109",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956110",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956110",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956108",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956110",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956109",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17605297298141654",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297298141654",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956109",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297298141654",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956110",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297308641698",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297308641698",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956109",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297308641698",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956110",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520159028658105",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520159028658105",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956109",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520159028658105",
						["startPort"] = "Out",
						["endQuest"] = "17609468768963956110",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17609468768963956109",
						["startPort"] = "Out",
						["endQuest"] = "1760520599738661864",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956109",
						["startPort"] = "Out",
						["endQuest"] = "17605251946541987940",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956109",
						["startPort"] = "Out",
						["endQuest"] = "17605251973691988025",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956109",
						["startPort"] = "Out",
						["endQuest"] = "1760520628746662285",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956110",
						["startPort"] = "Out",
						["endQuest"] = "1760520628746662285",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956110",
						["startPort"] = "Out",
						["endQuest"] = "1760520599738661864",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956110",
						["startPort"] = "Out",
						["endQuest"] = "17605251946541987940",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17609468768963956110",
						["startPort"] = "Out",
						["endQuest"] = "17605251973691988025",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17605190532281078",
						["startPort"] = "Option_1",
						["endQuest"] = "1760520284508659693",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520284508659693",
						["startPort"] = "Option_1",
						["endQuest"] = "17605194159991859",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605194079631643",
						["startPort"] = "Out",
						["endQuest"] = "1760520191491658910",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520284508659693",
						["startPort"] = "Option_2",
						["endQuest"] = "17605194159991859",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760520284508659693",
						["startPort"] = "Option_3",
						["endQuest"] = "17605194159991859",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17605297298141654",
						["startPort"] = "Out",
						["endQuest"] = "17605249835421329467",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17605297308641698",
						["startPort"] = "Out",
						["endQuest"] = "17605251202701986695",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "1760520159028658105",
						["startPort"] = "Out",
						["endQuest"] = "17605251214171986730",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "1760524141070668721",
						["startPort"] = "Out",
						["endQuest"] = "17605249835421329467",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "1760524141070668721",
						["startPort"] = "Out",
						["endQuest"] = "17605251202701986695",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "1760524141070668721",
						["startPort"] = "Out",
						["endQuest"] = "17605251214171986730",
						["endPort"] = "Input_3"
					}
				},
				["nodeData"] = {
					["176051798095987"] = {
						["key"] = "176051798095987",
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
					["176051798095994"] = {
						["key"] = "176051798095994",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 6238.538565082784,
							["y"] = 303.26789159599775
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1760517980959101"] = {
						["key"] = "1760517980959101",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 5521.977161574012,
							["y"] = 1446.9257863328398
						},
						["propsData"] = {}
					},
					["1760518880593427"] = {
						["key"] = "1760518880593427",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成npc",
						["pos"] = {
							["x"] = 1120,
							["y"] = 300
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2410019,
								2410020,
								2410021,
								2410022
							}
						}
					},
					["1760518894265672"] = {
						["key"] = "1760518894265672",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1496.3846153846152,
							["y"] = -9.769230769230859
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71008101,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17605190532281078"] = {
						["key"] = "17605190532281078",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1498.6923076923076,
							["y"] = 292.53846153846155
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818087,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2410019",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71008102,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"",
								""
							},
							["OverrideFailBlend"] = false
						}
					},
					["17605194079631643"] = {
						["key"] = "17605194079631643",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成npc",
						["pos"] = {
							["x"] = 2302.0073260073264,
							["y"] = -269.0915750915752
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2410023,
								2410024,
								2410025
							}
						}
					},
					["17605194159991859"] = {
						["key"] = "17605194159991859",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁npc",
						["pos"] = {
							["x"] = 2062.8498168498168,
							["y"] = -260.7765567765568
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2410020,
								2410021,
								2410022
							}
						}
					},
					["1760520159028658105"] = {
						["key"] = "1760520159028658105",
						["type"] = "SendMessageNode",
						["name"] = "开始赛跑_NPCC赢",
						["pos"] = {
							["x"] = 3617.2280238950366,
							["y"] = 181.75258940291366
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto2",
							["UnitId"] = 818088
						}
					},
					["1760520178942658524"] = {
						["key"] = "1760520178942658524",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2255.2567846595307,
							["y"] = 628.1342511797889
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "BP_ViewPoint",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["1760520191491658910"] = {
						["key"] = "1760520191491658910",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2583.6806382853015,
							["y"] = -263.5661219338834
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71008106,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1760520284508659693"] = {
						["key"] = "1760520284508659693",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2213.809441664361,
							["y"] = 268.8791787160209
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818087,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2410019",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71008104,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"",
								"",
								""
							},
							["OverrideFailBlend"] = false
						}
					},
					["1760520562193661001"] = {
						["key"] = "1760520562193661001",
						["type"] = "BossBattleFinishNode",
						["name"] = "一号完成",
						["pos"] = {
							["x"] = 4234.5880829001835,
							["y"] = -203.86318859719736
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "End1"
						}
					},
					["1760520599738661864"] = {
						["key"] = "1760520599738661864",
						["type"] = "TalkNode",
						["name"] = "猜对分支——一号赢",
						["pos"] = {
							["x"] = 5376.150167986096,
							["y"] = 299.5726223052311
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818087,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2410019",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71008111,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
					["1760520628746662285"] = {
						["key"] = "1760520628746662285",
						["type"] = "TalkNode",
						["name"] = "猜错分支",
						["pos"] = {
							["x"] = 5371.886628703107,
							["y"] = -1.7999940181862542
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818087,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2410019",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71008110,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
					["1760523939807664678"] = {
						["key"] = "1760523939807664678",
						["type"] = "BossBattleFinishNode",
						["name"] = "二号完成",
						["pos"] = {
							["x"] = 4235.779107741096,
							["y"] = -21.238739565425647
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "End2"
						}
					},
					["1760523941026664719"] = {
						["key"] = "1760523941026664719",
						["type"] = "BossBattleFinishNode",
						["name"] = "三号完成",
						["pos"] = {
							["x"] = 4232.909725661187,
							["y"] = 146.5666066266484
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "End3"
						}
					},
					["1760524141070668721"] = {
						["key"] = "1760524141070668721",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 4581.0656771583535,
							["y"] = -39.54176848263504
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["17605249835421329467"] = {
						["key"] = "17605249835421329467",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 5013.225937657051,
							["y"] = 288.23994496952463
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["17605251202701986695"] = {
						["key"] = "17605251202701986695",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 5022.725937657051,
							["y"] = 481.73994496952463
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["17605251214171986730"] = {
						["key"] = "17605251214171986730",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 5024.225937657051,
							["y"] = 670.7399449695247
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["17605251946541987940"] = {
						["key"] = "17605251946541987940",
						["type"] = "TalkNode",
						["name"] = "猜对分支——二号赢",
						["pos"] = {
							["x"] = 5372.620674499156,
							["y"] = 497.74871689934923
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818087,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2410019",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71008111,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
					["17605251973691988025"] = {
						["key"] = "17605251973691988025",
						["type"] = "TalkNode",
						["name"] = "猜对分支——三号赢",
						["pos"] = {
							["x"] = 5375.620674499156,
							["y"] = 698.4987168993492
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818087,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2410019",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71008111,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
					["17605252644891988382"] = {
						["key"] = "17605252644891988382",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 5717.120674499156,
							["y"] = -3.751283100650795
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17605252716841988609"] = {
						["key"] = "17605252716841988609",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 5723.620674499156,
							["y"] = 302.74871689934923
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17605252759811988734"] = {
						["key"] = "17605252759811988734",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 5731.120674499156,
							["y"] = 496.24871689934923
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17605252796091988847"] = {
						["key"] = "17605252796091988847",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 5729.370674499156,
							["y"] = 690.9987168993492
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17605297146141217"] = {
						["key"] = "17605297146141217",
						["type"] = "WeightBranchNode",
						["name"] = "权重分支节点",
						["pos"] = {
							["x"] = 2857.2049689440996,
							["y"] = -282.85714285714295
						},
						["propsData"] = {
							["RandomTriggerBranchCount"] = 1,
							["WeightBranchArray"] = {
								1,
								1,
								1
							}
						}
					},
					["17605297298141654"] = {
						["key"] = "17605297298141654",
						["type"] = "SendMessageNode",
						["name"] = "开始赛跑_NPCA赢",
						["pos"] = {
							["x"] = 3664.2478211443727,
							["y"] = -297.0481242895037
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto1",
							["UnitId"] = 818088
						}
					},
					["17605297308641698"] = {
						["key"] = "17605297308641698",
						["type"] = "SendMessageNode",
						["name"] = "开始赛跑_NPCB赢",
						["pos"] = {
							["x"] = 3649.882531261842,
							["y"] = -61.15658288072086
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto3",
							["UnitId"] = 818088
						}
					},
					["17606142129731976326"] = {
						["key"] = "17606142129731976326",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 1883.2319930260437,
							["y"] = 640.298925426214
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["17606911395353289399"] = {
						["key"] = "17606911395353289399",
						["type"] = "SendMessageNode",
						["name"] = "开始赛跑_NPCA赢",
						["pos"] = {
							["x"] = 3411.642678060101,
							["y"] = -292.7828928902712
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto2",
							["UnitId"] = 818089
						}
					},
					["17606911432143289524"] = {
						["key"] = "17606911432143289524",
						["type"] = "SendMessageNode",
						["name"] = "开始赛跑_NPCA赢",
						["pos"] = {
							["x"] = 3160.8329614609097,
							["y"] = -288.31409490060173
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto3",
							["UnitId"] = 818090
						}
					},
					["17606912603543290516"] = {
						["key"] = "17606912603543290516",
						["type"] = "SendMessageNode",
						["name"] = "开始赛跑_NPCB赢",
						["pos"] = {
							["x"] = 3152.2262324367575,
							["y"] = -72.30992665505397
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto2",
							["UnitId"] = 818090
						}
					},
					["17606912622803290566"] = {
						["key"] = "17606912622803290566",
						["type"] = "SendMessageNode",
						["name"] = "开始赛跑_NPCB赢",
						["pos"] = {
							["x"] = 3396.131331169443,
							["y"] = -66.11187183630955
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto1",
							["UnitId"] = 818089
						}
					},
					["17606912856353291067"] = {
						["key"] = "17606912856353291067",
						["type"] = "SendMessageNode",
						["name"] = "开始赛跑_NPCC赢",
						["pos"] = {
							["x"] = 3378.2266113681712,
							["y"] = 185.59458262876564
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto3",
							["UnitId"] = 818089
						}
					},
					["17606912872863291118"] = {
						["key"] = "17606912872863291118",
						["type"] = "SendMessageNode",
						["name"] = "开始赛跑_NPCC赢",
						["pos"] = {
							["x"] = 3142.438434028271,
							["y"] = 186.62906538738622
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto1",
							["UnitId"] = 818090
						}
					},
					["17609455408731975091"] = {
						["key"] = "17609455408731975091",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁比赛npc",
						["pos"] = {
							["x"] = 5110.062379649338,
							["y"] = 1.1475596351422084
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2410023,
								2410024,
								2410025
							}
						}
					},
					["17609455408731975092"] = {
						["key"] = "17609455408731975092",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成站立npc",
						["pos"] = {
							["x"] = 4850.51093109789,
							["y"] = -4.204088716506028
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = true,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2410020,
								2410021,
								2410022
							}
						}
					},
					["17609468768963956108"] = {
						["key"] = "17609468768963956108",
						["type"] = "BossBattleFinishNode",
						["name"] = "一号完成",
						["pos"] = {
							["x"] = 4232.042086981161,
							["y"] = -875.5029389274046
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "Win1"
						}
					},
					["17609468768963956109"] = {
						["key"] = "17609468768963956109",
						["type"] = "BossBattleFinishNode",
						["name"] = "二号完成",
						["pos"] = {
							["x"] = 4231.733111822074,
							["y"] = -694.3784898956328
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "Win2"
						}
					},
					["17609468768963956110"] = {
						["key"] = "17609468768963956110",
						["type"] = "BossBattleFinishNode",
						["name"] = "三号完成",
						["pos"] = {
							["x"] = 4230.363729742165,
							["y"] = -525.0731437035588
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "Win3"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}