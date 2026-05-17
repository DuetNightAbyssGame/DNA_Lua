return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17678537949091014608",
			["startPort"] = "StoryStart",
			["endStory"] = "17678537949091014610",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17678537949091014610",
			["startPort"] = "Success",
			["endStory"] = "17678537949091014609",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17678537949091014608"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949091014608",
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
		["17678537949091014609"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949091014609",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2800,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17678537949091014610"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949091014610",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1372,
				["y"] = 352
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
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
				["bIsDynamicEvent"] = false,
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
						["startQuest"] = "17698459273514558765",
						["startPort"] = "Out",
						["endQuest"] = "17698459273514558766",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17698459273514558762",
						["startPort"] = "Out",
						["endQuest"] = "17698459273514558760",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949091014611",
						["startPort"] = "QuestStart",
						["endQuest"] = "17698459273514558763",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949091014611",
						["startPort"] = "QuestStart",
						["endQuest"] = "17698459273514558761",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17698459273514558761",
						["startPort"] = "Out",
						["endQuest"] = "17678537949091014613",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17698459273514558766",
						["startPort"] = "Out",
						["endQuest"] = "176985259232712157057",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176985259232712157057",
						["startPort"] = "Out",
						["endQuest"] = "17698459273514558762",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17698459273514558764",
						["startPort"] = "Out",
						["endQuest"] = "17733879939096742507",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733879939096742507",
						["startPort"] = "Region_2",
						["endQuest"] = "17698459273514558765",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733879939096742507",
						["startPort"] = "Region_1",
						["endQuest"] = "17733880016136742731",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949091014611",
						["startPort"] = "QuestStart",
						["endQuest"] = "17733921430704208438",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17734950658525063859",
						["startPort"] = "Out",
						["endQuest"] = "17734950658525063860",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949091014611",
						["startPort"] = "QuestStart",
						["endQuest"] = "17734950658525063859",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17734950658525063860",
						["startPort"] = "Out",
						["endQuest"] = "17698459273514558764",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17678537949091014611"] = {
						["key"] = "17678537949091014611",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 294.5,
							["y"] = 289.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17678537949091014612"] = {
						["key"] = "17678537949091014612",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17678537949091014613"] = {
						["key"] = "17678537949091014613",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1751.5,
							["y"] = 799
						},
						["propsData"] = {}
					},
					["17698459273514558760"] = {
						["key"] = "17698459273514558760",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2120.098220862712,
							["y"] = 492.4906486295509
						},
						["propsData"] = {}
					},
					["17698459273514558761"] = {
						["key"] = "17698459273514558761",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1391.123973495123,
							["y"] = 778.2796465033059
						},
						["propsData"] = {}
					},
					["17698459273514558762"] = {
						["key"] = "17698459273514558762",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_60】止流幻境，揭露真相，止流抛硬币",
						["pos"] = {
							["x"] = 1663.3727122988093,
							["y"] = 486.818910570162
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 240001,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12020101zhiliu_2010033",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12046401.12046401'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020101",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
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
					["17698459273514558763"] = {
						["key"] = "17698459273514558763",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1259.3673703580853,
							["y"] = 57.72035349669403
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049128,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17698459273514558764"] = {
						["key"] = "17698459273514558764",
						["type"] = "SendMessageNode",
						["name"] = "开启小黑屋玩法",
						["pos"] = {
							["x"] = 1136.705061274487,
							["y"] = 273.9071449053746
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "StartBox3",
							["UnitId"] = -1
						}
					},
					["17698459273514558765"] = {
						["key"] = "17698459273514558765",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 1839.3437052392178,
							["y"] = 276.31248594115044
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "OpenTheDoor3"
						}
					},
					["17698459273514558766"] = {
						["key"] = "17698459273514558766",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 2212.6282720588465,
							["y"] = 267.9364553936833
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 105602,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["176985259232712157057"] = {
						["key"] = "176985259232712157057",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2474.357471264368,
							["y"] = 326.2988505747127
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2010033
							}
						}
					},
					["17733879939096742507"] = {
						["key"] = "17733879939096742507",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 1493.7446500867557,
							["y"] = 219.6652515105032
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								105602,
								105601
							}
						}
					},
					["17733880016136742731"] = {
						["key"] = "17733880016136742731",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1821.077983420089,
							["y"] = 111.86525151050311
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "XHWstart",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17733921430704208438"] = {
						["key"] = "17733921430704208438",
						["type"] = "StandAloneBlackScreenNode",
						["name"] = "独立黑屏节点",
						["pos"] = {
							["x"] = 1275.0464798359535,
							["y"] = -95.00589542036926
						},
						["propsData"] = {
							["FadeInSeconds"] = 0,
							["FadeOutSeconds"] = 0.5,
							["DurationSeconds"] = 0.5,
							["IsStandAlone"] = false
						}
					},
					["17734950658525063859"] = {
						["key"] = "17734950658525063859",
						["type"] = "SendMessageNode",
						["name"] = "开启小黑屋玩法",
						["pos"] = {
							["x"] = 611.6813725490196,
							["y"] = 303.0858488132096
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "ReStartBox3",
							["UnitId"] = -1
						}
					},
					["17734950658525063860"] = {
						["key"] = "17734950658525063860",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 867.9313725490196,
							["y"] = 284.5661119711042
						},
						["propsData"] = {
							["WaitTime"] = 1.5
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}