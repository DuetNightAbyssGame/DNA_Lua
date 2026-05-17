return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17352796800421",
			["startPort"] = "StoryStart",
			["endStory"] = "1735279758686235125",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1735279758686235125",
			["startPort"] = "Success",
			["endStory"] = "17352796800435",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17352796800421"] = {
			["isStoryNode"] = true,
			["key"] = "17352796800421",
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
		["17352796800435"] = {
			["isStoryNode"] = true,
			["key"] = "17352796800435",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1507.5806451612902,
				["y"] = 290.9032258064516
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1735279758686235125"] = {
			["isStoryNode"] = true,
			["key"] = "1735279758686235125",
			["type"] = "StoryNode",
			["name"] = "拍照",
			["pos"] = {
				["x"] = 1153.3101736972706,
				["y"] = 283.85856079404465
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_TakePhoto_Des",
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
						["startQuest"] = "1735279758686235126",
						["startPort"] = "QuestStart",
						["endQuest"] = "1735279794109235857",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735279794109235857",
						["startPort"] = "Out",
						["endQuest"] = "1735279803250236065",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735279794109235857",
						["startPort"] = "Out",
						["endQuest"] = "1735279818413236380",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735279917146237655",
						["startPort"] = "Success",
						["endQuest"] = "1735279994504939388",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735279850448236775",
						["startPort"] = "Out",
						["endQuest"] = "1735279758686235129",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1735279994504939388",
						["startPort"] = "Out",
						["endQuest"] = "17352833969141289",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17352833969141289",
						["startPort"] = "Out",
						["endQuest"] = "1735279758686235129",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17355477435875042",
						["startPort"] = "Out",
						["endQuest"] = "1735279917146237655",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735547220094988",
						["startPort"] = "Out",
						["endQuest"] = "17355519851441400125",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17355519851441400125",
						["startPort"] = "Out",
						["endQuest"] = "17355477435875042",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17355477435875042",
						["startPort"] = "Out",
						["endQuest"] = "17443731591322198058",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735279917146237655",
						["startPort"] = "Success",
						["endQuest"] = "17443735253602747670",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443735253602747670",
						["startPort"] = "Out",
						["endQuest"] = "1735551740718854",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443731591322198058",
						["startPort"] = "Out",
						["endQuest"] = "17355477435875042",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735279794109235857",
						["startPort"] = "Out",
						["endQuest"] = "17503885242662582769",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735279818413236380",
						["startPort"] = "Option_1",
						["endQuest"] = "1735547220094988",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1735279818413236380",
						["startPort"] = "Option_2",
						["endQuest"] = "1735279850448236775",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1735279758686235126"] = {
						["key"] = "1735279758686235126",
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
					["1735279758686235129"] = {
						["key"] = "1735279758686235129",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3491.6695652173917,
							["y"] = 367.66956521739127
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1735279758686235132"] = {
						["key"] = "1735279758686235132",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1735279794109235857"] = {
						["key"] = "1735279794109235857",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成NPC",
						["pos"] = {
							["x"] = 1208,
							["y"] = 296.4
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110100
							}
						}
					},
					["1735279803250236065"] = {
						["key"] = "1735279803250236065",
						["type"] = "TalkNode",
						["name"] = "拍照开车",
						["pos"] = {
							["x"] = 1509.2,
							["y"] = 83.99999999999993
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71006801,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1735279818413236380"] = {
						["key"] = "1735279818413236380",
						["type"] = "TalkNode",
						["name"] = "交互开车",
						["pos"] = {
							["x"] = 1522.6285714285711,
							["y"] = 254.1461538461539
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818041,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2110100",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006802,
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
							["OverrideFailBlend"] = true,
							["FailOutType"] = "FadeOut",
							["FailOutTime"] = 2
						}
					},
					["1735279850448236775"] = {
						["key"] = "1735279850448236775",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 2051.5262672811064,
							["y"] = 711.7640552995392
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["1735279917146237655"] = {
						["key"] = "1735279917146237655",
						["type"] = "CameraNode",
						["name"] = "相机节点",
						["pos"] = {
							["x"] = 2357.26446989196,
							["y"] = 201.45395249911374
						},
						["propsData"] = {
							["bFadeInOut"] = false,
							["bIsForceOpenCamera"] = true,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["_GuidePointName"] = "",
							["TargetPointList"] = {
								"Npc_Dyn_2110100",
								"Mechanism_Dyn_2110109"
							},
							["EventId"] = 0,
							["EventParams"] = {},
							["Text_TargetFound"] = "",
							["Text_TargetNotFound"] = "",
							["ForceMaxLodStaticPointList"] = {},
							["bShouldSetCameraParams"] = true,
							["FocalLength"] = 8,
							["LookAtTargetName"] = "Mechanism_Dyn_2110108",
							["StartPos"] = "(X=34400.000000,Y=-960.000000,Z=9460.000000)",
							["bLockCameraPos"] = true,
							["bStartHiddenRole"] = true,
							["bLockHiddenRole"] = true,
							["bStartHiddenNPC"] = false,
							["bLockHiddenNPC"] = true,
							["bStartHiddenMonster"] = true,
							["bLockHiddenMonster"] = true,
							["bStartHiddenPet"] = true,
							["bLockHiddenPet"] = true,
							["bLockGamePause"] = true,
							["bForceGamePause"] = false
						}
					},
					["1735279994504939388"] = {
						["key"] = "1735279994504939388",
						["type"] = "TalkNode",
						["name"] = "完成对话",
						["pos"] = {
							["x"] = 2593.451696129958,
							["y"] = 233.05096185279243
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818041,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_2110100",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006805,
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
					["17352833969141289"] = {
						["key"] = "17352833969141289",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 2853.83197123243,
							["y"] = 270.07845701209544
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = true,
							["TalkFadeOutTime"] = 1,
							["UseTalkFadeIn"] = true,
							["TalkFadeInTime"] = 1
						}
					},
					["1735547220094988"] = {
						["key"] = "1735547220094988",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成照相机机关",
						["pos"] = {
							["x"] = 2046.3535631035636,
							["y"] = -136.0480769230769
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110101
							}
						}
					},
					["17355477435875042"] = {
						["key"] = "17355477435875042",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2045.476764707299,
							["y"] = 164.24464759378563
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2110101,
							["StateId"] = 780421,
							["IsGuideEnable"] = false,
							["GuidePointName"] = "Mechanism_Dyn_2110101"
						}
					},
					["1735551740718854"] = {
						["key"] = "1735551740718854",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁照相机机关",
						["pos"] = {
							["x"] = 2942.021167125594,
							["y"] = 10.929924074892941
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110101
							}
						}
					},
					["17355519851441400125"] = {
						["key"] = "17355519851441400125",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "初始化机关",
						["pos"] = {
							["x"] = 2054.5423233886854,
							["y"] = 16.75849550346436
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2110101
							},
							["ManualItemIdList"] = {},
							["StateId"] = 780420,
							["QuestId"] = 0
						}
					},
					["17443731591322198058"] = {
						["key"] = "17443731591322198058",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2071.199581064097,
							["y"] = 383.64079388353565
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					},
					["17443735253602747670"] = {
						["key"] = "17443735253602747670",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2656.8253875157097,
							["y"] = 2.156922915793688
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2110101,
							["StateId"] = 780420,
							["IsGuideEnable"] = false,
							["GuidePointName"] = "Mechanism_Dyn_2110101"
						}
					},
					["17503885242662582769"] = {
						["key"] = "17503885242662582769",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成NPC",
						["pos"] = {
							["x"] = 1231.8571428571427,
							["y"] = 472.75910364145653
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110108,
								2110109
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