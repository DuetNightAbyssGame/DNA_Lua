return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17345132724031366065",
			["startPort"] = "StoryStart",
			["endStory"] = "17345132753051366160",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17345132753051366160",
			["startPort"] = "Success",
			["endStory"] = "17345132724031366068",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17345132724031366065"] = {
			["isStoryNode"] = true,
			["key"] = "17345132724031366065",
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
		["17345132724031366068"] = {
			["isStoryNode"] = true,
			["key"] = "17345132724031366068",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1510,
				["y"] = 287.36842105263156
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17345132753051366160"] = {
			["isStoryNode"] = true,
			["key"] = "17345132753051366160",
			["type"] = "StoryNode",
			["name"] = "电池",
			["pos"] = {
				["x"] = 1151.3076923076924,
				["y"] = 285.61538461538464
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_FortBattery_Des",
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
						["startQuest"] = "17345133603031366968",
						["startPort"] = "Out",
						["endQuest"] = "17345133751031367225",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17345133603031366968",
						["startPort"] = "Out",
						["endQuest"] = "17345134309011367511",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17345134309011367511",
						["startPort"] = "Out",
						["endQuest"] = "17345142446281370179",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17345142598691370584",
						["startPort"] = "Out",
						["endQuest"] = "17345132753051366164",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17345133603031366968",
						["startPort"] = "Out",
						["endQuest"] = "17349458609411358",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17345134309011367511",
						["startPort"] = "Out",
						["endQuest"] = "17349459507513481",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17349458609411358",
						["startPort"] = "Out",
						["endQuest"] = "17349459507513481",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1734946641044694933",
						["startPort"] = "WeightBranch_2",
						["endQuest"] = "1734946604487694404",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946641044694933",
						["startPort"] = "WeightBranch_2",
						["endQuest"] = "1734946628903694699",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946604487694404",
						["startPort"] = "Out",
						["endQuest"] = "1734946663111695402",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946663111695402",
						["startPort"] = "Out",
						["endQuest"] = "1734946677592695703",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "1734946604487694404",
						["startPort"] = "Out",
						["endQuest"] = "1734946732439697248",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946786654698203",
						["startPort"] = "Out",
						["endQuest"] = "17345132753051366164",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1734946641044694933",
						["startPort"] = "WeightBranch_1",
						["endQuest"] = "1734588366106665",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946641044694933",
						["startPort"] = "WeightBranch_1",
						["endQuest"] = "17345133603031366968",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946641044694933",
						["startPort"] = "WeightBranch_1",
						["endQuest"] = "1734588355688407",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17345132753051366161",
						["startPort"] = "QuestStart",
						["endQuest"] = "1734946641044694933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946641044694933",
						["startPort"] = "WeightBranch_2",
						["endQuest"] = "17349487238463456720",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946677592695703",
						["startPort"] = "Out",
						["endQuest"] = "17356163511842100353",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17356163511842100353",
						["startPort"] = "Out",
						["endQuest"] = "1734946786654698203",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17349459507513481",
						["startPort"] = "Out",
						["endQuest"] = "17349380967271361",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946663111695402",
						["startPort"] = "Out",
						["endQuest"] = "1734946718932696931",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17345142446281370179",
						["startPort"] = "Out",
						["endQuest"] = "17392550360261518318",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17392550360261518318",
						["startPort"] = "Out",
						["endQuest"] = "17345142598691370584",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443547134734937889",
						["startPort"] = "Out",
						["endQuest"] = "17443547216654938002",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443547134734937889",
						["startPort"] = "Out",
						["endQuest"] = "17443547437664938292",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443547134734937889",
						["startPort"] = "Out",
						["endQuest"] = "17443547450884938330",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443547216654938002",
						["startPort"] = "Out",
						["endQuest"] = "17443547526804938446",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17443547437664938292",
						["startPort"] = "Out",
						["endQuest"] = "17443547526804938446",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17443547450884938330",
						["startPort"] = "Out",
						["endQuest"] = "17443547526804938446",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "17345133603031366968",
						["startPort"] = "Out",
						["endQuest"] = "17443547134734937889",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443547526804938446",
						["startPort"] = "Out",
						["endQuest"] = "17345142446281370179",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17349459507513481",
						["startPort"] = "Out",
						["endQuest"] = "17443548649994940049",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17349459507513481",
						["startPort"] = "Out",
						["endQuest"] = "17443548649994940050",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17349459507513481",
						["startPort"] = "Out",
						["endQuest"] = "17443548649994940051",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443550077474940655",
						["startPort"] = "Out",
						["endQuest"] = "17443550077484940656",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443550077474940655",
						["startPort"] = "Out",
						["endQuest"] = "17443550077484940658",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443550077474940655",
						["startPort"] = "Out",
						["endQuest"] = "17443550077484940657",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443550077484940656",
						["startPort"] = "Out",
						["endQuest"] = "17443550077484940659",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17443550077484940658",
						["startPort"] = "Out",
						["endQuest"] = "17443550077484940659",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17443550077484940657",
						["startPort"] = "Out",
						["endQuest"] = "17443550077484940659",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "1734946604487694404",
						["startPort"] = "Out",
						["endQuest"] = "17443550077474940655",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443550077484940659",
						["startPort"] = "Out",
						["endQuest"] = "1734946677592695703",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1734946663111695402",
						["startPort"] = "Out",
						["endQuest"] = "17443550399244941112",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946663111695402",
						["startPort"] = "Out",
						["endQuest"] = "17443550399244941114",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946663111695402",
						["startPort"] = "Out",
						["endQuest"] = "17443550399244941113",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946641044694933",
						["startPort"] = "WeightBranch_1",
						["endQuest"] = "176189361281318378847",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734946641044694933",
						["startPort"] = "WeightBranch_2",
						["endQuest"] = "176189362230618379087",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17345132753051366161"] = {
						["key"] = "17345132753051366161",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 394.1929824561403,
							["y"] = 979.1929824561403
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17345132753051366164"] = {
						["key"] = "17345132753051366164",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3631.8559218559217,
							["y"] = 343.1868131868132
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17345132753051366167"] = {
						["key"] = "17345132753051366167",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3265,
							["y"] = 835
						},
						["propsData"] = {}
					},
					["17345133603031366968"] = {
						["key"] = "17345133603031366968",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成指挥官",
						["pos"] = {
							["x"] = 1106.2820512820513,
							["y"] = 311.4358974358974
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1650489,
								1650490,
								1650491
							}
						}
					},
					["17345133751031367225"] = {
						["key"] = "17345133751031367225",
						["type"] = "TalkNode",
						["name"] = "遇到指挥官开车",
						["pos"] = {
							["x"] = 1446.8205128205127,
							["y"] = 50.051282051281966
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71004501,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17345134309011367511"] = {
						["key"] = "17345134309011367511",
						["type"] = "KillMonsterNode",
						["name"] = "击杀小兵",
						["pos"] = {
							["x"] = 1440.8888888888887,
							["y"] = 235.61538461538456
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1650490,
								1650491
							}
						}
					},
					["17345134865341367847"] = {
						["key"] = "17345134865341367847",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 2606.9468864468863,
							["y"] = -711.9954212454213
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1650486,
								1650487,
								1650488
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80025,
							["UnitCount"] = 3,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17345142446281370179"] = {
						["key"] = "17345142446281370179",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2427.2985347985345,
							["y"] = 309.54029304029297
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17345142598691370584"] = {
						["key"] = "17345142598691370584",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3176.9467643467638,
							["y"] = 322.4329670329669
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17345145106502053864"] = {
						["key"] = "17345145106502053864",
						["type"] = "PickUpNode",
						["name"] = "挂拾取物品的指引点",
						["pos"] = {
							["x"] = 2602.357165781079,
							["y"] = -123.39686641860567
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {
								1650486,
								1650487,
								1650488
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80025,
							["UnitCount"] = 3,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["1734588355688407"] = {
						["key"] = "1734588355688407",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成士兵尸体",
						["pos"] = {
							["x"] = 1111.2820512820513,
							["y"] = 573.197261072261
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1650472,
								1650473,
								1650474
							}
						}
					},
					["1734588366106665"] = {
						["key"] = "1734588366106665",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成秽兽尸体",
						["pos"] = {
							["x"] = 1123.2051282051284,
							["y"] = 65.81963869463856
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1650475,
								1650476,
								1650477,
								1650478,
								1650479,
								1650480,
								1650481,
								1650482,
								1650483
							}
						}
					},
					["17349380967271361"] = {
						["key"] = "17349380967271361",
						["type"] = "TalkNode",
						["name"] = "完成开车",
						["pos"] = {
							["x"] = 2157.2242010487225,
							["y"] = 146.8002633518349
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71004503,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1734943250564666"] = {
						["key"] = "1734943250564666",
						["type"] = "SendMessageNode",
						["name"] = "战斗欲望提升",
						["pos"] = {
							["x"] = 1831.0329670329672,
							["y"] = 62.95054945054943
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Warpathup",
							["UnitId"] = 7008004
						}
					},
					["17349458609411358"] = {
						["key"] = "17349458609411358",
						["type"] = "KillMonsterNode",
						["name"] = "击杀指挥官",
						["pos"] = {
							["x"] = 1448.1971361971368,
							["y"] = 411.08424908424917
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1650489
							}
						}
					},
					["17349459507513481"] = {
						["key"] = "17349459507513481",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 1813.0689310689318,
							["y"] = 335.05860805860806
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["1734946604487694404"] = {
						["key"] = "1734946604487694404",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成历战者",
						["pos"] = {
							["x"] = 1089.5954992630059,
							["y"] = 1026.2979518066472
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1650514
							}
						}
					},
					["1734946628903694699"] = {
						["key"] = "1734946628903694699",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成士兵尸体",
						["pos"] = {
							["x"] = 1103.5475194650262,
							["y"] = 1229.6312851399805
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1650511,
								1650512,
								1650513,
								1650472,
								1650473,
								1650474
							}
						}
					},
					["1734946641044694933"] = {
						["key"] = "1734946641044694933",
						["type"] = "WeightBranchNode",
						["name"] = "权重分支节点",
						["pos"] = {
							["x"] = 752.7141861316928,
							["y"] = 958.7979518066473
						},
						["propsData"] = {
							["RandomTriggerBranchCount"] = 1,
							["WeightBranchArray"] = {
								1,
								1
							}
						}
					},
					["1734946657610695323"] = {
						["key"] = "1734946657610695323",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1488.7015306585113,
							["y"] = 1804.7601255977684
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1650515,
								1650516,
								1650517
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80025,
							["UnitCount"] = 3,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["1734946663111695402"] = {
						["key"] = "1734946663111695402",
						["type"] = "KillMonsterNode",
						["name"] = "击杀历战者",
						["pos"] = {
							["x"] = 1510.4919639094705,
							["y"] = 1021.714618473314
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1650514
							}
						}
					},
					["1734946677592695703"] = {
						["key"] = "1734946677592695703",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2176.7419639094705,
							["y"] = 1044.214618473314
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["1734946718932696931"] = {
						["key"] = "1734946718932696931",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 2188.433611506725,
							["y"] = 880.1029806831865
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71004503,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1734946732439697248"] = {
						["key"] = "1734946732439697248",
						["type"] = "TalkNode",
						["name"] = "遇见秽兽开车对话",
						["pos"] = {
							["x"] = 1491.7419639094708,
							["y"] = 827.964618473314
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71004502,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1734946786654698203"] = {
						["key"] = "1734946786654698203",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 2994.241963909471,
							["y"] = 1060.464618473314
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17349485220612077768"] = {
						["key"] = "17349485220612077768",
						["type"] = "PickUpNode",
						["name"] = "挂拾取物品的指引点",
						["pos"] = {
							["x"] = 1826.8077533831547,
							["y"] = 841.1193803780758
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {
								1650515,
								1650516,
								1650517
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80025,
							["UnitCount"] = 3,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17349487238463456720"] = {
						["key"] = "17349487238463456720",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成秽兽尸体",
						["pos"] = {
							["x"] = 1114.3077533831547,
							["y"] = 1453.3374254908576
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1650475,
								1650476,
								1650477,
								1650478,
								1650479,
								1650480,
								1650481,
								1650482,
								1650483
							}
						}
					},
					["17356163511842100353"] = {
						["key"] = "17356163511842100353",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2570.544012509229,
							["y"] = 1067.1671893324067
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["17392550360261518318"] = {
						["key"] = "17392550360261518318",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2711.9689537388617,
							["y"] = 335.92710622710626
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17443547134734937889"] = {
						["key"] = "17443547134734937889",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成电池",
						["pos"] = {
							["x"] = 1489.1159420289853,
							["y"] = 583.6811594202898
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1650486,
								1650487,
								1650488
							}
						}
					},
					["17443547216654938002"] = {
						["key"] = "17443547216654938002",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1703.1014492753618,
							["y"] = 487.8840579710145
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650486,
							["StateId"] = 610033,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17443547437664938292"] = {
						["key"] = "17443547437664938292",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1917.3043478260872,
							["y"] = 580.9565217391304
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650487,
							["StateId"] = 610033,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17443547450884938330"] = {
						["key"] = "17443547450884938330",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1714.4782608695655,
							["y"] = 695.159420289855
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650488,
							["StateId"] = 610033,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17443547526804938446"] = {
						["key"] = "17443547526804938446",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2173.1014492753625,
							["y"] = 539.3333333333333
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["17443548649994940049"] = {
						["key"] = "17443548649994940049",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2492.77536231884,
							["y"] = 491.945652173913
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650486,
							["StateId"] = 610033,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Drop_Dyn_1650486"
						}
					},
					["17443548649994940050"] = {
						["key"] = "17443548649994940050",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2706.978260869566,
							["y"] = 585.0181159420289
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650487,
							["StateId"] = 610033,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Drop_Dyn_1650487"
						}
					},
					["17443548649994940051"] = {
						["key"] = "17443548649994940051",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2504.152173913044,
							["y"] = 699.2210144927535
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650488,
							["StateId"] = 610033,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Drop_Dyn_1650488"
						}
					},
					["17443550077474940655"] = {
						["key"] = "17443550077474940655",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成电池",
						["pos"] = {
							["x"] = 1541.831426392067,
							["y"] = 1497.8743325705568
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1650515,
								1650516,
								1650517
							}
						}
					},
					["17443550077484940656"] = {
						["key"] = "17443550077484940656",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1755.8169336384435,
							["y"] = 1402.0772311212818
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650515,
							["StateId"] = 610033,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17443550077484940657"] = {
						["key"] = "17443550077484940657",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1767.1937452326472,
							["y"] = 1609.3525934401223
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650517,
							["StateId"] = 610033,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17443550077484940658"] = {
						["key"] = "17443550077484940658",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1970.019832189169,
							["y"] = 1495.1496948893973
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650516,
							["StateId"] = 610033,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17443550077484940659"] = {
						["key"] = "17443550077484940659",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2225.8169336384444,
							["y"] = 1453.5265064836003
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["17443550399244941112"] = {
						["key"] = "17443550399244941112",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2526.7227307398925,
							["y"] = 1247.3403890160184
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650515,
							["StateId"] = 610033,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Drop_Dyn_1650515"
						}
					},
					["17443550399244941113"] = {
						["key"] = "17443550399244941113",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2538.0995423340964,
							["y"] = 1454.615751334859
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650517,
							["StateId"] = 610033,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Drop_Dyn_1650517"
						}
					},
					["17443550399244941114"] = {
						["key"] = "17443550399244941114",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2742.5045766590397,
							["y"] = 1341.991800152555
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1650516,
							["StateId"] = 610033,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Drop_Dyn_1650516"
						}
					},
					["176189361281318378847"] = {
						["key"] = "176189361281318378847",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1115.2007223942207,
							["y"] = -125.19401444788434
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_FortBattery_Target1",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176189362230618379087"] = {
						["key"] = "176189362230618379087",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1118.7007223942207,
							["y"] = 1682.3059855521155
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_FortBattery_Target2",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}