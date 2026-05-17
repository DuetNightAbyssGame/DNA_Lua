return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1769168247919747704",
			["startPort"] = "Success",
			["endStory"] = "1769168247919747703",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1769168247919747702",
			["startPort"] = "StoryStart",
			["endStory"] = "1769168247919747704",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["1769168247919747702"] = {
			["isStoryNode"] = true,
			["key"] = "1769168247919747702",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 894.1739130434785,
				["y"] = 317.2494279176201
			},
			["propsData"] = {
				["QuestChainId"] = 400122
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1769168247919747703"] = {
			["isStoryNode"] = true,
			["key"] = "1769168247919747703",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2618.8853754940715,
				["y"] = 318.8043478260869
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1769168247919747704"] = {
			["isStoryNode"] = true,
			["key"] = "1769168247919747704",
			["type"] = "StoryNode",
			["name"] = "修普诺斯之家拍照",
			["pos"] = {
				["x"] = 1658.1438909555918,
				["y"] = 322.93812485468493
			},
			["propsData"] = {
				["QuestId"] = 40012200,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400122_1",
				["QuestDeatil"] = "Content_400122_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_TakePhoto_1192072",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1769168247919747705",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769168247919747710",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747709",
						["startPort"] = "Out",
						["endQuest"] = "1769168247919747708",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747709",
						["startPort"] = "Out",
						["endQuest"] = "1769168247919747711",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747711",
						["startPort"] = "Out",
						["endQuest"] = "1769168247919747712",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747712",
						["startPort"] = "Out",
						["endQuest"] = "1769168247919747709",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747708",
						["startPort"] = "Success",
						["endQuest"] = "1769168247919747709",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "1769168247919747710",
						["startPort"] = "Out",
						["endQuest"] = "1769168247919747713",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747714",
						["startPort"] = "Out",
						["endQuest"] = "1769168247919747706",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1769168247919747710",
						["startPort"] = "Out",
						["endQuest"] = "17696565352474495259",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747709",
						["startPort"] = "Out",
						["endQuest"] = "17722621026121394",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747708",
						["startPort"] = "Success",
						["endQuest"] = "1769168247919747714",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730389780851241722",
						["startPort"] = "Out",
						["endQuest"] = "1769168247919747716",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747716",
						["startPort"] = "Out",
						["endQuest"] = "1769168247919747709",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747713",
						["startPort"] = "Out",
						["endQuest"] = "17730389780851241722",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769168247919747716",
						["startPort"] = "Out",
						["endQuest"] = "17722620994771347",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1769168247919747705"] = {
						["key"] = "1769168247919747705",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -549.45,
							["y"] = 309.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769168247919747706"] = {
						["key"] = "1769168247919747706",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1990.068181818182,
							["y"] = 310.84090909090907
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769168247919747707"] = {
						["key"] = "1769168247919747707",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1769168247919747708"] = {
						["key"] = "1769168247919747708",
						["type"] = "CameraNode",
						["name"] = "相机节点",
						["pos"] = {
							["x"] = 1203.35,
							["y"] = 306.35
						},
						["propsData"] = {
							["bFadeInOut"] = false,
							["bIsForceOpenCamera"] = true,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["_GuidePointName"] = "BP_PhotoTarget_400122",
							["TargetPointList"] = {
								"BP_PhotoTarget_400122"
							},
							["EventId"] = 103017,
							["EventParams"] = {
								"2"
							},
							["Text_TargetFound"] = "",
							["Text_TargetNotFound"] = "",
							["ForceMaxLodStaticPointList"] = {},
							["bShouldSetCameraParams"] = true,
							["FocalLength"] = 15,
							["LookAtTargetName"] = "BP_PhotoTarget_400122",
							["StartPos"] = "(X=-3214.376953,Y=11569.043945,Z=-1987.442505)",
							["bLockCameraPos"] = false,
							["bStartHiddenRole"] = true,
							["bLockHiddenRole"] = true,
							["bStartHiddenNPC"] = false,
							["bLockHiddenNPC"] = false,
							["bStartHiddenMonster"] = false,
							["bLockHiddenMonster"] = false,
							["bStartHiddenPet"] = false,
							["bLockHiddenPet"] = false,
							["bLockGamePause"] = false,
							["bForceGamePause"] = false
						}
					},
					["1769168247919747709"] = {
						["key"] = "1769168247919747709",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 795.2317226890755,
							["y"] = 310.82161955691356
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1192072,
							["StateId"] = 11301281,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["1769168247919747710"] = {
						["key"] = "1769168247919747710",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = -265.61827731092455,
							["y"] = 311.92161955691364
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1192072"
						}
					},
					["1769168247919747711"] = {
						["key"] = "1769168247919747711",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 620.5317226890755,
							["y"] = 546.2716195569137
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["1769168247919747712"] = {
						["key"] = "1769168247919747712",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 905.1317226890756,
							["y"] = 561.1216195569136
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1192072
							},
							["ManualItemIdList"] = {},
							["StateId"] = 11301280,
							["QuestId"] = 0
						}
					},
					["1769168247919747713"] = {
						["key"] = "1769168247919747713",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 5.0317226890754085,
							["y"] = 318.3216195569135
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1192072
							}
						}
					},
					["1769168247919747714"] = {
						["key"] = "1769168247919747714",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1689.1135408708938,
							["y"] = 310.276165011459
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1192072
							}
						}
					},
					["1769168247919747716"] = {
						["key"] = "1769168247919747716",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 519.128946931383,
							["y"] = 309.9387807205584
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400122/40012201.40012201'",
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
					["17696565352474495259"] = {
						["key"] = "17696565352474495259",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = -15.733333333333377,
							["y"] = 90.17777777777776
						},
						["propsData"] = {
							["NewDescription"] = "Description_400122_2",
							["NewDetail"] = "Content_400122_2",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17722620994771347"] = {
						["key"] = "17722620994771347",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示拍照点的指引",
						["pos"] = {
							["x"] = 795.3711042311661,
							["y"] = 123.4932146542829
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1192072"
						}
					},
					["17722621026121394"] = {
						["key"] = "17722621026121394",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "干掉拍照点的指引",
						["pos"] = {
							["x"] = 1201.3045727910035,
							["y"] = 124.62262641898877
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1192072"
						}
					},
					["17730389780851241722"] = {
						["key"] = "17730389780851241722",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 262.4353322564717,
							["y"] = 306.3399931472484
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1192073,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_PhotoGoto_1192073"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}