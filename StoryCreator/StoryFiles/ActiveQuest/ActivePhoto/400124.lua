return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17694113571051863199",
			["startPort"] = "Success",
			["endStory"] = "17694113571051863198",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17694113571041863197",
			["startPort"] = "StoryStart",
			["endStory"] = "17694113571051863199",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17694113571041863197"] = {
			["isStoryNode"] = true,
			["key"] = "17694113571041863197",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 894.1739130434785,
				["y"] = 317.2494279176201
			},
			["propsData"] = {
				["QuestChainId"] = 400124
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17694113571051863198"] = {
			["isStoryNode"] = true,
			["key"] = "17694113571051863198",
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
		["17694113571051863199"] = {
			["isStoryNode"] = true,
			["key"] = "17694113571051863199",
			["type"] = "StoryNode",
			["name"] = "小剧场拍照",
			["pos"] = {
				["x"] = 1658.1438909555918,
				["y"] = 321.73812485468494
			},
			["propsData"] = {
				["QuestId"] = 40012400,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400124_1",
				["QuestDeatil"] = "Content_400124_1",
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
				["SubRegionId"] = 101703,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_TakePhoto_1740136",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17694113571051863200",
						["startPort"] = "QuestStart",
						["endQuest"] = "17694113571051863205",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863204",
						["startPort"] = "Out",
						["endQuest"] = "17694113571051863203",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863204",
						["startPort"] = "Out",
						["endQuest"] = "17694113571051863206",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863206",
						["startPort"] = "Out",
						["endQuest"] = "17694113571051863207",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863207",
						["startPort"] = "Out",
						["endQuest"] = "17694113571051863204",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863203",
						["startPort"] = "Success",
						["endQuest"] = "17694113571051863204",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17694113571051863205",
						["startPort"] = "Out",
						["endQuest"] = "17694113571051863208",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863209",
						["startPort"] = "Out",
						["endQuest"] = "17694113571051863201",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17694113571051863205",
						["startPort"] = "Out",
						["endQuest"] = "17696571821496742821",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863204",
						["startPort"] = "Out",
						["endQuest"] = "17722623552293553081",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863208",
						["startPort"] = "Out",
						["endQuest"] = "17730402637134941462",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863203",
						["startPort"] = "Success",
						["endQuest"] = "17694113571051863209",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730402637134941462",
						["startPort"] = "Out",
						["endQuest"] = "17694113571051863211",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863211",
						["startPort"] = "Out",
						["endQuest"] = "17694113571051863204",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694113571051863211",
						["startPort"] = "Out",
						["endQuest"] = "17722623513613552938",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17694113571051863200"] = {
						["key"] = "17694113571051863200",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -657.554347826087,
							["y"] = 322.2826086956522
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17694113571051863201"] = {
						["key"] = "17694113571051863201",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2021.8214285714287,
							["y"] = 313.17857142857144
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17694113571051863202"] = {
						["key"] = "17694113571051863202",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17694113571051863203"] = {
						["key"] = "17694113571051863203",
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
							["_GuidePointName"] = "BP_PhotoTarget_400124",
							["TargetPointList"] = {
								"BP_PhotoTarget_400124"
							},
							["EventId"] = 103017,
							["EventParams"] = {
								"4"
							},
							["Text_TargetFound"] = "",
							["Text_TargetNotFound"] = "",
							["ForceMaxLodStaticPointList"] = {},
							["bShouldSetCameraParams"] = true,
							["FocalLength"] = 20,
							["LookAtTargetName"] = "BP_PhotoTarget_400124",
							["StartPos"] = "(X=-6597.339355,Y=-11275.300781,Z=-2012.234131)",
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
					["17694113571051863204"] = {
						["key"] = "17694113571051863204",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 748.4317226890755,
							["y"] = 310.82161955691356
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1740136,
							["StateId"] = 11301281,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17694113571051863205"] = {
						["key"] = "17694113571051863205",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = -328.90523383266367,
							["y"] = 314.0607499916963
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101703,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1740136"
						}
					},
					["17694113571051863206"] = {
						["key"] = "17694113571051863206",
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
					["17694113571051863207"] = {
						["key"] = "17694113571051863207",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 855.9317226890755,
							["y"] = 562.3216195569137
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1740136
							},
							["ManualItemIdList"] = {},
							["StateId"] = 11301280,
							["QuestId"] = 0
						}
					},
					["17694113571051863208"] = {
						["key"] = "17694113571051863208",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = -76.56827731092459,
							["y"] = 312.32161955691356
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1740136
							}
						}
					},
					["17694113571051863209"] = {
						["key"] = "17694113571051863209",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1711.6460084033613,
							["y"] = 322.6787624140564
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1740136
							}
						}
					},
					["17694113571051863211"] = {
						["key"] = "17694113571051863211",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 455.5028599748612,
							["y"] = 317.2983515844772
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400124/40012401.40012401'",
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
					["17696571821496742821"] = {
						["key"] = "17696571821496742821",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = -58.488339615022525,
							["y"] = 111.65965075441454
						},
						["propsData"] = {
							["NewDescription"] = "Description_400124_2",
							["NewDetail"] = "Content_400124_2",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17722623513613552938"] = {
						["key"] = "17722623513613552938",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 751.4615384615383,
							["y"] = 102.76923076923073
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1740136"
						}
					},
					["17722623552293553081"] = {
						["key"] = "17722623552293553081",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1143,
							["y"] = 95.84615384615387
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_1740136"
						}
					},
					["17730402637134941462"] = {
						["key"] = "17730402637134941462",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 192.7725400457667,
							["y"] = 310.7459382151027
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1740137,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TakePhoto_1740136"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}