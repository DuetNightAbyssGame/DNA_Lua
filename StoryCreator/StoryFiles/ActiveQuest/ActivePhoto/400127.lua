return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17694125753735204175",
			["startPort"] = "StoryStart",
			["endStory"] = "17694125753735204177",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17694125753735204177",
			["startPort"] = "Success",
			["endStory"] = "17694125753735204176",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17694125753735204175"] = {
			["isStoryNode"] = true,
			["key"] = "17694125753735204175",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 894.1739130434785,
				["y"] = 317.2494279176201
			},
			["propsData"] = {
				["QuestChainId"] = 400127
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17694125753735204176"] = {
			["isStoryNode"] = true,
			["key"] = "17694125753735204176",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1704.7075977162935,
				["y"] = 314.715458937198
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17694125753735204177"] = {
			["isStoryNode"] = true,
			["key"] = "17694125753735204177",
			["type"] = "StoryNode",
			["name"] = "执律阁拍照",
			["pos"] = {
				["x"] = 1373.1216687333697,
				["y"] = 295.5159026324627
			},
			["propsData"] = {
				["QuestId"] = 40012700,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400127_1",
				["QuestDeatil"] = "Content_400127_1",
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
				["SubRegionId"] = 104506,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_TakePhoto_2440008",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17694125753735204178",
						["startPort"] = "QuestStart",
						["endQuest"] = "17694125753735204183",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204182",
						["startPort"] = "Out",
						["endQuest"] = "17694125753735204181",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204182",
						["startPort"] = "Out",
						["endQuest"] = "17694125753735204184",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204184",
						["startPort"] = "Out",
						["endQuest"] = "17694125753735204185",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204185",
						["startPort"] = "Out",
						["endQuest"] = "17694125753735204182",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204181",
						["startPort"] = "Success",
						["endQuest"] = "17694125753735204182",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17694125753735204187",
						["startPort"] = "Out",
						["endQuest"] = "17694125753735204179",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17694125753735204182",
						["startPort"] = "Out",
						["endQuest"] = "17722626353867105900",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204183",
						["startPort"] = "Out",
						["endQuest"] = "17694125753735204186",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204183",
						["startPort"] = "Out",
						["endQuest"] = "176965732508310113289",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204186",
						["startPort"] = "Out",
						["endQuest"] = "17731417752232610",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204181",
						["startPort"] = "Success",
						["endQuest"] = "17694125753735204187",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17731417752232610",
						["startPort"] = "Out",
						["endQuest"] = "17694125753735204189",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204189",
						["startPort"] = "Out",
						["endQuest"] = "17722626282867105693",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694125753735204189",
						["startPort"] = "Out",
						["endQuest"] = "17694125753735204182",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17694125753735204178"] = {
						["key"] = "17694125753735204178",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -558.068181818182,
							["y"] = 293.40909090909093
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17694125753735204179"] = {
						["key"] = "17694125753735204179",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2029.2045454545455,
							["y"] = 316.29545454545456
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17694125753735204180"] = {
						["key"] = "17694125753735204180",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17694125753735204181"] = {
						["key"] = "17694125753735204181",
						["type"] = "CameraNode",
						["name"] = "相机节点",
						["pos"] = {
							["x"] = 1124.75,
							["y"] = 311.47727272727275
						},
						["propsData"] = {
							["bFadeInOut"] = false,
							["bIsForceOpenCamera"] = true,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["_GuidePointName"] = "BP_PhotoTarget_400127",
							["TargetPointList"] = {
								"BP_PhotoTarget_400127"
							},
							["EventId"] = 103017,
							["EventParams"] = {
								"7"
							},
							["Text_TargetFound"] = "",
							["Text_TargetNotFound"] = "",
							["ForceMaxLodStaticPointList"] = {},
							["bShouldSetCameraParams"] = true,
							["FocalLength"] = 12,
							["LookAtTargetName"] = "BP_PhotoTarget_400127",
							["StartPos"] = "(X=32830.332031,Y=-103197.210938,Z=45577.890625)",
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
					["17694125753735204182"] = {
						["key"] = "17694125753735204182",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 756.6135408708936,
							["y"] = 308.0943468296408
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2440008,
							["StateId"] = 11301281,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17694125753735204183"] = {
						["key"] = "17694125753735204183",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = -249.63645912910633,
							["y"] = 296.86707410236824
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104506,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_2440008"
						}
					},
					["17694125753735204184"] = {
						["key"] = "17694125753735204184",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 632.7499045072574,
							["y"] = 514.2534377387318
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17694125753735204185"] = {
						["key"] = "17694125753735204185",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 855.9317226890755,
							["y"] = 514.5943468296409
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2440008
							},
							["ManualItemIdList"] = {},
							["StateId"] = 11301280,
							["QuestId"] = 0
						}
					},
					["17694125753735204186"] = {
						["key"] = "17694125753735204186",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 18.670957138836197,
							["y"] = 297.32161955691356
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2440008
							}
						}
					},
					["17694125753735204187"] = {
						["key"] = "17694125753735204187",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1740.2499045072573,
							["y"] = 319.5488922841863
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2440008
							}
						}
					},
					["17694125753735204189"] = {
						["key"] = "17694125753735204189",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 506.5692066716428,
							["y"] = 300.69332617510383
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400127/40012701.40012701'",
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
					["176965732508310113289"] = {
						["key"] = "176965732508310113289",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 13.636363636363626,
							["y"] = 154.0909090909091
						},
						["propsData"] = {
							["NewDescription"] = "Description_400127_2",
							["NewDetail"] = "Content_400127_2",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17722626282867105693"] = {
						["key"] = "17722626282867105693",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 753.5284992784995,
							["y"] = 129.72222222222229
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_2440008"
						}
					},
					["17722626353867105900"] = {
						["key"] = "17722626353867105900",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1128.882034632035,
							["y"] = 131.59090909090918
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_2440008"
						}
					},
					["17731417752232610"] = {
						["key"] = "17731417752232610",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 273.999666999667,
							["y"] = 296.93563178980116
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2440018,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_PhotoGoto_2440018"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}