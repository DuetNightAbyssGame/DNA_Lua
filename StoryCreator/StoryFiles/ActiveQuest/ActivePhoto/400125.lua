return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17694116128592975248",
			["startPort"] = "Success",
			["endStory"] = "17694116128592975247",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17694116128592975246",
			["startPort"] = "StoryStart",
			["endStory"] = "17694116128592975248",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17694116128592975246"] = {
			["isStoryNode"] = true,
			["key"] = "17694116128592975246",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 894.1739130434785,
				["y"] = 317.2494279176201
			},
			["propsData"] = {
				["QuestChainId"] = 400125
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17694116128592975247"] = {
			["isStoryNode"] = true,
			["key"] = "17694116128592975247",
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
		["17694116128592975248"] = {
			["isStoryNode"] = true,
			["key"] = "17694116128592975248",
			["type"] = "StoryNode",
			["name"] = "剧院拍照",
			["pos"] = {
				["x"] = 1656.1438909555918,
				["y"] = 321.73812485468494
			},
			["propsData"] = {
				["QuestId"] = 40012500,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400125_1",
				["QuestDeatil"] = "Content_400125_1",
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
				["SubRegionId"] = 101901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_TakePhoto_1960201",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17694116128592975249",
						["startPort"] = "QuestStart",
						["endQuest"] = "17694116128592975254",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975253",
						["startPort"] = "Out",
						["endQuest"] = "17694116128592975252",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975253",
						["startPort"] = "Out",
						["endQuest"] = "17694116128592975255",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975255",
						["startPort"] = "Out",
						["endQuest"] = "17694116128592975256",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975256",
						["startPort"] = "Out",
						["endQuest"] = "17694116128592975253",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975252",
						["startPort"] = "Success",
						["endQuest"] = "17694116128592975253",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17694116128592975254",
						["startPort"] = "Out",
						["endQuest"] = "17694116128592975257",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975258",
						["startPort"] = "Out",
						["endQuest"] = "17694116128592975250",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17694116128592975254",
						["startPort"] = "Out",
						["endQuest"] = "17696572350427866289",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975253",
						["startPort"] = "Out",
						["endQuest"] = "17722624291004737447",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975252",
						["startPort"] = "Success",
						["endQuest"] = "17694116128592975258",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975257",
						["startPort"] = "Out",
						["endQuest"] = "17730404938476175488",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730404938476175488",
						["startPort"] = "Out",
						["endQuest"] = "17694116128592975260",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975260",
						["startPort"] = "Out",
						["endQuest"] = "17694116128592975253",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694116128592975260",
						["startPort"] = "Out",
						["endQuest"] = "17722624163524737111",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17694116128592975249"] = {
						["key"] = "17694116128592975249",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -740.5357142857144,
							["y"] = 303.2142857142857
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17694116128592975250"] = {
						["key"] = "17694116128592975250",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1992.892857142857,
							["y"] = 316.39285714285717
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17694116128592975251"] = {
						["key"] = "17694116128592975251",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17694116128592975252"] = {
						["key"] = "17694116128592975252",
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
							["_GuidePointName"] = "BP_PhotoTarget_400125",
							["TargetPointList"] = {
								"BP_PhotoTarget_400125"
							},
							["EventId"] = 103017,
							["EventParams"] = {
								"5"
							},
							["Text_TargetFound"] = "",
							["Text_TargetNotFound"] = "",
							["ForceMaxLodStaticPointList"] = {},
							["bShouldSetCameraParams"] = true,
							["FocalLength"] = 8,
							["LookAtTargetName"] = "BP_PhotoTarget_400125",
							["StartPos"] = "(X=20502.601562,Y=787.810120,Z=-36083.574219)",
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
					["17694116128592975253"] = {
						["key"] = "17694116128592975253",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 748.4317226890755,
							["y"] = 310.82161955691356
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1960201,
							["StateId"] = 11301281,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17694116128592975254"] = {
						["key"] = "17694116128592975254",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = -369.9611344537817,
							["y"] = 306.60733384262795
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101901,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1960201"
						}
					},
					["17694116128592975255"] = {
						["key"] = "17694116128592975255",
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
					["17694116128592975256"] = {
						["key"] = "17694116128592975256",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 855.9317226890755,
							["y"] = 562.3216195569137
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1960201
							},
							["ManualItemIdList"] = {},
							["StateId"] = 11301280,
							["QuestId"] = 0
						}
					},
					["17694116128592975257"] = {
						["key"] = "17694116128592975257",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = -93.71113445378177,
							["y"] = 312.32161955691356
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960201
							}
						}
					},
					["17694116128592975258"] = {
						["key"] = "17694116128592975258",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1695.9317226890755,
							["y"] = 329.4644766997707
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1960201
							}
						}
					},
					["17694116128592975260"] = {
						["key"] = "17694116128592975260",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 412.6146612170973,
							["y"] = 303.6803391621169
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400125/40012501.40012501'",
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
					["17696572350427866289"] = {
						["key"] = "17696572350427866289",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = -95.71428571428578,
							["y"] = 128
						},
						["propsData"] = {
							["NewDescription"] = "Description_400125_2",
							["NewDetail"] = "Content_400125_2",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17722624163524737111"] = {
						["key"] = "17722624163524737111",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 748.2285714285714,
							["y"] = 112.39999999999995
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1960201"
						}
					},
					["17722624291004737447"] = {
						["key"] = "17722624291004737447",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1135.4285714285718,
							["y"] = 108.79999999999994
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1960201"
						}
					},
					["17730404938476175488"] = {
						["key"] = "17730404938476175488",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 150.98214285714337,
							["y"] = 316.2857142857143
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1960202,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_PhotoGoto_1960202"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}