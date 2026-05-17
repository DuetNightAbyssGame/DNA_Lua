return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17694117992554087662",
			["startPort"] = "Success",
			["endStory"] = "17694117992554087661",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17694117992554087660",
			["startPort"] = "StoryStart",
			["endStory"] = "17694117992554087662",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17694117992554087660"] = {
			["isStoryNode"] = true,
			["key"] = "17694117992554087660",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 894.1739130434785,
				["y"] = 317.2494279176201
			},
			["propsData"] = {
				["QuestChainId"] = 400126
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17694117992554087661"] = {
			["isStoryNode"] = true,
			["key"] = "17694117992554087661",
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
		["17694117992554087662"] = {
			["isStoryNode"] = true,
			["key"] = "17694117992554087662",
			["type"] = "StoryNode",
			["name"] = "百年春拍照",
			["pos"] = {
				["x"] = 1659.4482387816788,
				["y"] = 320.433777028598
			},
			["propsData"] = {
				["QuestId"] = 40012600,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400126_1",
				["QuestDeatil"] = "Content_400126_1",
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
				["SubRegionId"] = 104110,
				["SubRegionIdList"] = {
					104107
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_TakePhoto_2110366",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17694117992554087663",
						["startPort"] = "QuestStart",
						["endQuest"] = "17694117992554087668",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087667",
						["startPort"] = "Out",
						["endQuest"] = "17694117992554087666",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087667",
						["startPort"] = "Out",
						["endQuest"] = "17694117992554087669",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087669",
						["startPort"] = "Out",
						["endQuest"] = "17694117992554087670",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087670",
						["startPort"] = "Out",
						["endQuest"] = "17694117992554087667",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087666",
						["startPort"] = "Success",
						["endQuest"] = "17694117992554087667",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17694117992554087668",
						["startPort"] = "Out",
						["endQuest"] = "17694117992554087671",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087672",
						["startPort"] = "Out",
						["endQuest"] = "17694117992554087664",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17694117992554087668",
						["startPort"] = "Out",
						["endQuest"] = "17696572829818989798",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087667",
						["startPort"] = "Out",
						["endQuest"] = "17722625777235921716",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087666",
						["startPort"] = "Success",
						["endQuest"] = "17694117992554087672",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087671",
						["startPort"] = "Out",
						["endQuest"] = "17730415755129873673",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730415755129873673",
						["startPort"] = "Out",
						["endQuest"] = "17694117992554087674",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087674",
						["startPort"] = "Out",
						["endQuest"] = "17694117992554087667",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17694117992554087674",
						["startPort"] = "Out",
						["endQuest"] = "17722625703155921507",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17694117992554087663"] = {
						["key"] = "17694117992554087663",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -645,
							["y"] = 286.25
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17694117992554087664"] = {
						["key"] = "17694117992554087664",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2147.535714285714,
							["y"] = 321.75
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17694117992554087665"] = {
						["key"] = "17694117992554087665",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17694117992554087666"] = {
						["key"] = "17694117992554087666",
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
							["_GuidePointName"] = "BP_PhotoTarget_400126",
							["TargetPointList"] = {
								"BP_PhotoTarget_400126"
							},
							["EventId"] = 103017,
							["EventParams"] = {
								"6"
							},
							["Text_TargetFound"] = "",
							["Text_TargetNotFound"] = "",
							["ForceMaxLodStaticPointList"] = {},
							["bShouldSetCameraParams"] = true,
							["FocalLength"] = 12,
							["LookAtTargetName"] = "BP_PhotoTarget_400126",
							["StartPos"] = "(X=37088.437500,Y=6180.056641,Z=9180.224609)",
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
					["17694117992554087667"] = {
						["key"] = "17694117992554087667",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 748.4317226890755,
							["y"] = 310.82161955691356
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2110366,
							["StateId"] = 11301281,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17694117992554087668"] = {
						["key"] = "17694117992554087668",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = -302.8182773109245,
							["y"] = 296.6966195569137
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104107,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_2110366"
						}
					},
					["17694117992554087669"] = {
						["key"] = "17694117992554087669",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 632.9317226890755,
							["y"] = 553.0716195569137
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17694117992554087670"] = {
						["key"] = "17694117992554087670",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 865.9317226890755,
							["y"] = 557.3216195569137
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2110366
							},
							["ManualItemIdList"] = {},
							["StateId"] = 11301280,
							["QuestId"] = 0
						}
					},
					["17694117992554087671"] = {
						["key"] = "17694117992554087671",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = -21.897224679345584,
							["y"] = 306.69661955691356
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110366
							}
						}
					},
					["17694117992554087672"] = {
						["key"] = "17694117992554087672",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1801.6460084033613,
							["y"] = 316.9644766997707
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2110366
							}
						}
					},
					["17694117992554087674"] = {
						["key"] = "17694117992554087674",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 480.4718040742402,
							["y"] = 307.6089105906883
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400126/40012601.40012601'",
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
					["17696572829818989798"] = {
						["key"] = "17696572829818989798",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = -12.5,
							["y"] = 123.125
						},
						["propsData"] = {
							["NewDescription"] = "Description_400126_2",
							["NewDetail"] = "Content_400126_2",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17722625703155921507"] = {
						["key"] = "17722625703155921507",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 744.5923831070891,
							["y"] = 115.82805429864234
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_2110366"
						}
					},
					["17722625777235921716"] = {
						["key"] = "17722625777235921716",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1135.592383107089,
							["y"] = 111.82805429864239
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_TakePhoto_2110366"
						}
					},
					["17730415755129873673"] = {
						["key"] = "17730415755129873673",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 243.4742739200945,
							["y"] = 314.90000737136967
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2110367,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TakePhoto_2110366"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}