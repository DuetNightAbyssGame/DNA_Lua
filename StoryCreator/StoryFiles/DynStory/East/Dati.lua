return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1749110990648610403",
			["startPort"] = "StoryStart",
			["endStory"] = "1749111000870610586",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1749111000870610586",
			["startPort"] = "Success",
			["endStory"] = "1749110990648610406",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1749110990648610403"] = {
			["isStoryNode"] = true,
			["key"] = "1749110990648610403",
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
		["1749110990648610406"] = {
			["isStoryNode"] = true,
			["key"] = "1749110990648610406",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1622,
				["y"] = 293.42857142857144
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1749111000870610586"] = {
			["isStoryNode"] = true,
			["key"] = "1749111000870610586",
			["type"] = "StoryNode",
			["name"] = "答题",
			["pos"] = {
				["x"] = 1210,
				["y"] = 290
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_Dati_Des",
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
						["startQuest"] = "1749111000870610587",
						["startPort"] = "QuestStart",
						["endQuest"] = "1749111038977611244",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749111038977611244",
						["startPort"] = "Out",
						["endQuest"] = "1749111194626611773",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749111629482614796",
						["startPort"] = "Out",
						["endQuest"] = "1749111000870610590",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1749111637116615058",
						["startPort"] = "Out",
						["endQuest"] = "1749111000870610590",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1749111211009612000",
						["startPort"] = "WeightBranch_1",
						["endQuest"] = "17495601331721460",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496259877295586814",
						["startPort"] = "Out",
						["endQuest"] = "17495601331721460",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496261466935588574",
						["startPort"] = "Out",
						["endQuest"] = "17495602613271904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496262587095589518",
						["startPort"] = "Out",
						["endQuest"] = "17496263248525590396",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "1749111211009612000",
						["startPort"] = "WeightBranch_1",
						["endQuest"] = "17496263248525590396",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17496263248525590396",
						["startPort"] = "Out",
						["endQuest"] = "17496263463945591037",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496262587095589518",
						["startPort"] = "Out",
						["endQuest"] = "17496264754025592869",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17496262587095589518",
						["startPort"] = "Out",
						["endQuest"] = "17496264768765592926",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "1749111211009612000",
						["startPort"] = "WeightBranch_2",
						["endQuest"] = "17496264754025592869",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1749111211009612000",
						["startPort"] = "WeightBranch_3",
						["endQuest"] = "17496264768765592926",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17496264754025592869",
						["startPort"] = "Out",
						["endQuest"] = "17496264928005593424",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496264768765592926",
						["startPort"] = "Out",
						["endQuest"] = "17496264954145593498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496265097285593814",
						["startPort"] = "Out",
						["endQuest"] = "17496265097285593813",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496265124845593885",
						["startPort"] = "Out",
						["endQuest"] = "17496265124845593884",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749111211009612000",
						["startPort"] = "WeightBranch_2",
						["endQuest"] = "17496265097285593813",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749111211009612000",
						["startPort"] = "WeightBranch_3",
						["endQuest"] = "17496265124845593884",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749111038977611244",
						["startPort"] = "Out",
						["endQuest"] = "1749111095710611457",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496258995435585626",
						["startPort"] = "Out",
						["endQuest"] = "17495602613271904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496258995435585626",
						["startPort"] = "Out",
						["endQuest"] = "1750317346864645893",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933110",
						["startPort"] = "Out",
						["endQuest"] = "17503182427321933109",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933112",
						["startPort"] = "Out",
						["endQuest"] = "17503182427321933111",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933114",
						["startPort"] = "Out",
						["endQuest"] = "17503182427321933113",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496263463945591037",
						["startPort"] = "Out",
						["endQuest"] = "17503182427321933109",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496264928005593424",
						["startPort"] = "Out",
						["endQuest"] = "17503182427321933111",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496264954145593498",
						["startPort"] = "Out",
						["endQuest"] = "17503182427321933113",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933108",
						["startPort"] = "Out",
						["endQuest"] = "1749111000870610590",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17496263463945591037",
						["startPort"] = "Out",
						["endQuest"] = "17503183231051934422",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17496264928005593424",
						["startPort"] = "Out",
						["endQuest"] = "17503183699091935324",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17496264954145593498",
						["startPort"] = "Out",
						["endQuest"] = "17503183782411935515",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17503183231051934422",
						["startPort"] = "Out",
						["endQuest"] = "17503134799142976",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503183699091935324",
						["startPort"] = "Out",
						["endQuest"] = "17503135060603661",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503183782411935515",
						["startPort"] = "Out",
						["endQuest"] = "17503135073383702",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503134799142976",
						["startPort"] = "Out",
						["endQuest"] = "1749111000870610590",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17503135060603661",
						["startPort"] = "Out",
						["endQuest"] = "1749111000870610590",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17503135073383702",
						["startPort"] = "Out",
						["endQuest"] = "1749111000870610590",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1749111194626611773",
						["startPort"] = "Fail",
						["endQuest"] = "17495602551981698",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749111194626611773",
						["startPort"] = "Out",
						["endQuest"] = "1749111211009612000",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749111194626611773",
						["startPort"] = "Out",
						["endQuest"] = "17496258995435585626",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17495602613271904",
						["startPort"] = "Option_2",
						["endQuest"] = "17496261466935588574",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17495601331721460",
						["startPort"] = "Option_2",
						["endQuest"] = "17496259877295586814",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496265097285593813",
						["startPort"] = "Option_2",
						["endQuest"] = "17496265097285593814",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496265124845593884",
						["startPort"] = "Option_2",
						["endQuest"] = "17496265124845593885",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17495601331721460",
						["startPort"] = "Option_1",
						["endQuest"] = "17562954699533484",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496265097285593813",
						["startPort"] = "Option_1",
						["endQuest"] = "17562954919003854",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496265124845593884",
						["startPort"] = "Option_1",
						["endQuest"] = "17562955152104298",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562954699533484",
						["startPort"] = "Option_1",
						["endQuest"] = "1749111629482614796",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562954919003854",
						["startPort"] = "Option_1",
						["endQuest"] = "1749111629482614796",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562955152104298",
						["startPort"] = "Option_1",
						["endQuest"] = "1749111629482614796",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562955152104298",
						["startPort"] = "Option_2",
						["endQuest"] = "1749111637116615058",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562954919003854",
						["startPort"] = "Option_2",
						["endQuest"] = "1749111637116615058",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562954699533484",
						["startPort"] = "Option_2",
						["endQuest"] = "1749111637116615058",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933109",
						["startPort"] = "Option_1",
						["endQuest"] = "17562956549245783",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933111",
						["startPort"] = "Option_1",
						["endQuest"] = "17562956549245784",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933113",
						["startPort"] = "Option_1",
						["endQuest"] = "17562956549245785",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562956549245783",
						["startPort"] = "Option_1",
						["endQuest"] = "17503183231051934422",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17562956549245784",
						["startPort"] = "Option_1",
						["endQuest"] = "17503183699091935324",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17562956549245785",
						["startPort"] = "Option_1",
						["endQuest"] = "17503183782411935515",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17562956549245785",
						["startPort"] = "Option_2",
						["endQuest"] = "17503182427321933108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562956549245784",
						["startPort"] = "Option_2",
						["endQuest"] = "17503182427321933108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562956549245783",
						["startPort"] = "Option_2",
						["endQuest"] = "17503182427321933108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933109",
						["startPort"] = "Option_2",
						["endQuest"] = "17503182427321933110",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933111",
						["startPort"] = "Option_2",
						["endQuest"] = "17503182427321933112",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933113",
						["startPort"] = "Option_2",
						["endQuest"] = "17503182427321933114",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496263463945591037",
						["startPort"] = "Out",
						["endQuest"] = "17495601331721460",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17496264928005593424",
						["startPort"] = "Out",
						["endQuest"] = "17496265097285593813",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17496264954145593498",
						["startPort"] = "Out",
						["endQuest"] = "17496265124845593884",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17503182427321933109",
						["startPort"] = "Option_1",
						["endQuest"] = "176189504976327918646",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933111",
						["startPort"] = "Option_1",
						["endQuest"] = "176189505311127918709",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503182427321933113",
						["startPort"] = "Option_1",
						["endQuest"] = "176189505712727918791",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1749111194626611773",
						["startPort"] = "Out",
						["endQuest"] = "176189509704927919252",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17495602613271904",
						["startPort"] = "Option_1",
						["endQuest"] = "176189514759427919931",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637114189781745",
						["startPort"] = "Out",
						["endQuest"] = "17496262587095589518",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17637114881272199",
						["startPort"] = "Out",
						["endQuest"] = "17496262587095589518",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17495602613271904",
						["startPort"] = "Option_1",
						["endQuest"] = "1763712453452684539",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763712453452684539",
						["startPort"] = "Out",
						["endQuest"] = "17637114189781745",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763712453452684539",
						["startPort"] = "Out",
						["endQuest"] = "17637114881272199",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1749111000870610587"] = {
						["key"] = "1749111000870610587",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -598.6166007905138,
							["y"] = 276.87747035573125
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1749111000870610590"] = {
						["key"] = "1749111000870610590",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4782.09090909091,
							["y"] = 565.4623376623376
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1749111000870610593"] = {
						["key"] = "1749111000870610593",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3771.9428571428575,
							["y"] = 729.8857142857142
						},
						["propsData"] = {}
					},
					["1749111038977611244"] = {
						["key"] = "1749111038977611244",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成NPC",
						["pos"] = {
							["x"] = -226.93847912231922,
							["y"] = 280.0952422228167
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090136,
								2090137
							}
						}
					},
					["1749111095710611457"] = {
						["key"] = "1749111095710611457",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 102.24026483903356,
							["y"] = 42.99379294745433
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71006501,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1749111194626611773"] = {
						["key"] = "1749111194626611773",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 90.18084454917823,
							["y"] = 276.3903422918297
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818060,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090136",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006502,
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
							["OverrideFailBlend"] = true,
							["FailOutType"] = "FadeOut",
							["FailOutTime"] = 2
						}
					},
					["1749111211009612000"] = {
						["key"] = "1749111211009612000",
						["type"] = "WeightBranchNode",
						["name"] = "权重分支节点",
						["pos"] = {
							["x"] = 746.6863850803475,
							["y"] = 277.1092033443294
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
					["1749111629482614796"] = {
						["key"] = "1749111629482614796",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3279.7256852157584,
							["y"] = 237.73010397941746
						},
						["propsData"] = {
							["DialogueId"] = 71006515,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["1749111637116615058"] = {
						["key"] = "1749111637116615058",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3275.7256852157584,
							["y"] = 478.93010397941754
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17495601331721460"] = {
						["key"] = "17495601331721460",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1882.5658761528325,
							["y"] = 3.98319167483911
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818060,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090136",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006511,
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
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17495602551981698"] = {
						["key"] = "17495602551981698",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 748.9696058327636,
							["y"] = 607.237916926704
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["17495602613271904"] = {
						["key"] = "17495602613271904",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1150.9008817269687,
							["y"] = -733.8006775832865
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818061,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090137",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006506,
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
					["17496258995435585626"] = {
						["key"] = "17496258995435585626",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 855.8634085213033,
							["y"] = -693.0276852247677
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71006505,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17496259877295586814"] = {
						["key"] = "17496259877295586814",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1878.8765837518695,
							["y"] = 206.87420998147545
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17496261466935588574"] = {
						["key"] = "17496261466935588574",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1150.445348320634,
							["y"] = -457.4925681679113
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17496262587095589518"] = {
						["key"] = "17496262587095589518",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2206.0083360575345,
							["y"] = -702.7489784243216
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17496263248525590396"] = {
						["key"] = "17496263248525590396",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2683.57355344884,
							["y"] = -842.7489784243216
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17496263463945591037"] = {
						["key"] = "17496263463945591037",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3037.382249101013,
							["y"] = -828.2380921424115
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818061,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090137",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006509,
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
					["17496264754025592869"] = {
						["key"] = "17496264754025592869",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2689.2257273618834,
							["y"] = -658.079989375613
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17496264768765592926"] = {
						["key"] = "17496264768765592926",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2678.790944753188,
							["y"] = -466.3408589408303
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17496264928005593424"] = {
						["key"] = "17496264928005593424",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3050.5300751879704,
							["y"] = -634.5498426773456
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818061,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090137",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006510,
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
					["17496264954145593498"] = {
						["key"] = "17496264954145593498",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3042.7039882314484,
							["y"] = -434.98462528604114
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818061,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090137",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006508,
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
					["17496265097285593813"] = {
						["key"] = "17496265097285593813",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1880.6484078469202,
							["y"] = 326.96041234699703
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818060,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090136",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006512,
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
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17496265097285593814"] = {
						["key"] = "17496265097285593814",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1874.623703032284,
							["y"] = 517.8410909932936
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17496265124845593884"] = {
						["key"] = "17496265124845593884",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1880.3133906901642,
							["y"] = 663.4116956175023
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818060,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090136",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006513,
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
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17496265124845593885"] = {
						["key"] = "17496265124845593885",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1879.6323986844582,
							["y"] = 862.4918156309749
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17503134799142976"] = {
						["key"] = "17503134799142976",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 4609.186103628053,
							["y"] = -786.5128144559258
						},
						["propsData"] = {
							["DialogueId"] = 71006508,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17503135060603661"] = {
						["key"] = "17503135060603661",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 4599.640649082599,
							["y"] = -591.33850166861
						},
						["propsData"] = {
							["DialogueId"] = 71006509,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17503135073383702"] = {
						["key"] = "17503135073383702",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 4599.640649082599,
							["y"] = -364.97486530497343
						},
						["propsData"] = {
							["DialogueId"] = 71006510,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["1750317346864645893"] = {
						["key"] = "1750317346864645893",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1159.333333333333,
							["y"] = -299.9166666666666
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_Dyn_2090136"
						}
					},
					["17503182427321933108"] = {
						["key"] = "17503182427321933108",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 4298.440974222976,
							["y"] = -174.53425640808513
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["17503182427321933109"] = {
						["key"] = "17503182427321933109",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3498.281165160051,
							["y"] = -909.4172589382274
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818060,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090136",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006511,
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
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17503182427321933110"] = {
						["key"] = "17503182427321933110",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3496.788842456057,
							["y"] = -717.3931807090573
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17503182427321933111"] = {
						["key"] = "17503182427321933111",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3496.435125425567,
							["y"] = -587.2192590452902
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818060,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090136",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006512,
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
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17503182427321933112"] = {
						["key"] = "17503182427321933112",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3501.0723253728356,
							["y"] = -400.32629969723916
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17503182427321933113"] = {
						["key"] = "17503182427321933113",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3496.028679697382,
							["y"] = -251.8513660687015
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818060,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2090136",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006513,
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
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17503182427321933114"] = {
						["key"] = "17503182427321933114",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3503.6810210250096,
							["y"] = -65.1089083928913
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17503183231051934422"] = {
						["key"] = "17503183231051934422",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 4242.725463777709,
							["y"] = -799.3561483483859
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17503183699091935324"] = {
						["key"] = "17503183699091935324",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 4242.72546377771,
							["y"] = -607.4648160700665
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17503183782411935515"] = {
						["key"] = "17503183782411935515",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 4251.5489931894745,
							["y"] = -379.1662087544361
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17562954699533484"] = {
						["key"] = "17562954699533484",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2202.238865043547,
							["y"] = 8.74957311225765
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71006514,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 818060,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17562954919003854"] = {
						["key"] = "17562954919003854",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2193.683947974198,
							["y"] = 324.6056525167242
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71006515,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 818060,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17562955152104298"] = {
						["key"] = "17562955152104298",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2186.2554511738854,
							["y"] = 647.012600407543
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71006516,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 818060,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17562956549245783"] = {
						["key"] = "17562956549245783",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3864.075861002818,
							["y"] = -866.5706167604125
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71006514,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 818060,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17562956549245784"] = {
						["key"] = "17562956549245784",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3858.6788386703115,
							["y"] = -552.293484724367
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71006515,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 818060,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["17562956549245785"] = {
						["key"] = "17562956549245785",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3846.6713945015777,
							["y"] = -229.886536833548
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71006516,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 818060,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"答对",
								"答错"
							},
							["OverrideFailBlend"] = true,
							["FailOutType"] = "BlendOut",
							["FailOutTime"] = 0.5
						}
					},
					["176189504976327918646"] = {
						["key"] = "176189504976327918646",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3768.55980861244,
							["y"] = -1093.5717703349283
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_Dati_Target1",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176189505311127918709"] = {
						["key"] = "176189505311127918709",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3798.55980861244,
							["y"] = -665.3576555023924
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_Dati_Target1",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176189505712727918791"] = {
						["key"] = "176189505712727918791",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3806.05980861244,
							["y"] = -348.8576555023924
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_Dati_Target1",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176189509704927919252"] = {
						["key"] = "176189509704927919252",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 422.80980861244007,
							["y"] = -114.32177033492829
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_Dati_Target2",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176189514759427919931"] = {
						["key"] = "176189514759427919931",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1543.6431419457736,
							["y"] = -1049.9051036682615
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_Dati_Target3",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17637114189781745"] = {
						["key"] = "17637114189781745",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1881.080794215012,
							["y"] = -784.1611324675908
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2090138,
							["StateId"] = 780671,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_2090138"
						}
					},
					["17637114881272199"] = {
						["key"] = "17637114881272199",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1891.976834780337,
							["y"] = -616.3309747829488
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2090139,
							["StateId"] = 780671,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_2090139"
						}
					},
					["1763712453452684539"] = {
						["key"] = "1763712453452684539",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成机关",
						["pos"] = {
							["x"] = 1485.9410322152444,
							["y"] = -718.3536229548841
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2090138,
								2090139
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