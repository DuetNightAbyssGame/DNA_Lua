return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1769410805760750875",
			["startPort"] = "Success",
			["endStory"] = "1769410805760750874",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1769410805760750873",
			["startPort"] = "StoryStart",
			["endStory"] = "1769410805760750875",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["1769410805760750873"] = {
			["isStoryNode"] = true,
			["key"] = "1769410805760750873",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 894.1739130434785,
				["y"] = 317.2494279176201
			},
			["propsData"] = {
				["QuestChainId"] = 400123
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1769410805760750874"] = {
			["isStoryNode"] = true,
			["key"] = "1769410805760750874",
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
		["1769410805760750875"] = {
			["isStoryNode"] = true,
			["key"] = "1769410805760750875",
			["type"] = "StoryNode",
			["name"] = "冰湖拍照",
			["pos"] = {
				["x"] = 1660.1438909555918,
				["y"] = 319.90364209606423
			},
			["propsData"] = {
				["QuestId"] = 40012300,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400123_1",
				["QuestDeatil"] = "Content_400123_1",
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_TakePhoto_1241180",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1769410805760750876",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769410805760750881",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750880",
						["startPort"] = "Out",
						["endQuest"] = "1769410805760750879",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750880",
						["startPort"] = "Out",
						["endQuest"] = "1769410805760750882",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750882",
						["startPort"] = "Out",
						["endQuest"] = "1769410805760750883",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750883",
						["startPort"] = "Out",
						["endQuest"] = "1769410805760750880",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750879",
						["startPort"] = "Success",
						["endQuest"] = "1769410805760750880",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "1769410805760750881",
						["startPort"] = "Out",
						["endQuest"] = "1769410805760750884",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750885",
						["startPort"] = "Out",
						["endQuest"] = "1769410805760750877",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1769410805760750881",
						["startPort"] = "Out",
						["endQuest"] = "17696571342305619390",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750880",
						["startPort"] = "Out",
						["endQuest"] = "17722622123931186192",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750879",
						["startPort"] = "Success",
						["endQuest"] = "1769410805760750885",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750884",
						["startPort"] = "Out",
						["endQuest"] = "17730398163443708472",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730398163443708472",
						["startPort"] = "Out",
						["endQuest"] = "1769410805760750887",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769410805760750887",
						["startPort"] = "Out",
						["endQuest"] = "1769410805760750880",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1769410805760750876"] = {
						["key"] = "1769410805760750876",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -784.8214285714287,
							["y"] = 291.7857142857143
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769410805760750877"] = {
						["key"] = "1769410805760750877",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1995.25,
							["y"] = 309.75
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769410805760750878"] = {
						["key"] = "1769410805760750878",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1769410805760750879"] = {
						["key"] = "1769410805760750879",
						["type"] = "CameraNode",
						["name"] = "相机节点",
						["pos"] = {
							["x"] = 1139.75,
							["y"] = 308.75
						},
						["propsData"] = {
							["bFadeInOut"] = false,
							["bIsForceOpenCamera"] = true,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["_GuidePointName"] = "BP_PhotoTarget_400123",
							["TargetPointList"] = {
								"BP_PhotoTarget_400123"
							},
							["EventId"] = 103017,
							["EventParams"] = {
								"3"
							},
							["Text_TargetFound"] = "",
							["Text_TargetNotFound"] = "",
							["ForceMaxLodStaticPointList"] = {},
							["bShouldSetCameraParams"] = true,
							["FocalLength"] = 20,
							["LookAtTargetName"] = "BP_PhotoTarget_400123",
							["StartPos"] = "(X=-9282.445312,Y=44975.488281,Z=-13361.389648)",
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
					["1769410805760750880"] = {
						["key"] = "1769410805760750880",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 747.4639807535916,
							["y"] = 306.9506518149781
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1241180,
							["StateId"] = 11301281,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["1769410805760750881"] = {
						["key"] = "1769410805760750881",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = -337.1039915966388,
							["y"] = 292.3216195569137
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1241180"
						}
					},
					["1769410805760750882"] = {
						["key"] = "1769410805760750882",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 580.9317226890755,
							["y"] = 551.0716195569137
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["1769410805760750883"] = {
						["key"] = "1769410805760750883",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 855.9317226890755,
							["y"] = 562.3216195569137
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1241180
							},
							["ManualItemIdList"] = {},
							["StateId"] = 11301280,
							["QuestId"] = 0
						}
					},
					["1769410805760750884"] = {
						["key"] = "1769410805760750884",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = -63.71113445378171,
							["y"] = 305.1787624140564
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1241180
							}
						}
					},
					["1769410805760750885"] = {
						["key"] = "1769410805760750885",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1785.9317226890755,
							["y"] = 316.22161955691354
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1241180
							}
						}
					},
					["1769410805760750887"] = {
						["key"] = "1769410805760750887",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 459.32894693138303,
							["y"] = 297.03748201925976
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400123/40012301.40012301'",
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
					["17696571342305619390"] = {
						["key"] = "17696571342305619390",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = -42.788177339901495,
							["y"] = 95.18226600985221
						},
						["propsData"] = {
							["NewDescription"] = "Description_400123_2",
							["NewDetail"] = "Content_400123_2",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17722622065791186069"] = {
						["key"] = "17722622065791186069",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 760.5111561866123,
							["y"] = 114.27021725205512
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1241180"
						}
					},
					["17722622123931186192"] = {
						["key"] = "17722622123931186192",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1132.2352941176466,
							["y"] = 108.06332070033105
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1241180"
						}
					},
					["17730398163443708472"] = {
						["key"] = "17730398163443708472",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 181.1964285714285,
							["y"] = 296.73214285714306
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1241182,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_PhotoGoto_1241182"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}