return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17633680267201",
			["startPort"] = "StoryStart",
			["endStory"] = "176336802849557",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176336802849557",
			["startPort"] = "Success",
			["endStory"] = "17633680267205",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17633680267201"] = {
			["isStoryNode"] = true,
			["key"] = "17633680267201",
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
		["17633680267205"] = {
			["isStoryNode"] = true,
			["key"] = "17633680267205",
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
		["176336802849557"] = {
			["isStoryNode"] = true,
			["key"] = "176336802849557",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1768,
				["y"] = 372
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
						["startQuest"] = "1763368054483311",
						["startPort"] = "Out",
						["endQuest"] = "1763368054483312",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176336802849558",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763368054482309",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763368054483312",
						["startPort"] = "Out",
						["endQuest"] = "1763368054482308",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17633681300011705",
						["startPort"] = "Out",
						["endQuest"] = "1763368054483311",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176336802849558",
						["startPort"] = "QuestStart",
						["endQuest"] = "1765889325964492",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17659597923501448",
						["startPort"] = "Out",
						["endQuest"] = "17659600019912655",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763368054482309",
						["startPort"] = "Out",
						["endQuest"] = "176336802849572",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17659600019912655",
						["startPort"] = "Out",
						["endQuest"] = "17698485753868357555",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17698485753868357555",
						["startPort"] = "Out",
						["endQuest"] = "17698485889338357912",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17698485889338357912",
						["startPort"] = "Out",
						["endQuest"] = "17633681300011705",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17659597793261170",
						["startPort"] = "Out",
						["endQuest"] = "17733875068945059285",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733875068945059285",
						["startPort"] = "Region_1",
						["endQuest"] = "17733875175155059504",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733875068945059285",
						["startPort"] = "Region_2",
						["endQuest"] = "17659597923501448",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176336802849558",
						["startPort"] = "QuestStart",
						["endQuest"] = "17733920630992525598",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "176336802849558",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773494558755848786",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773494558755848786",
						["startPort"] = "Out",
						["endQuest"] = "1773494571264849045",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773494571264849045",
						["startPort"] = "Out",
						["endQuest"] = "17659597793261170",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["176336802849558"] = {
						["key"] = "176336802849558",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 383.3552631578948,
							["y"] = 275.625
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176336802849565"] = {
						["key"] = "176336802849565",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3232.8365384615386,
							["y"] = 317.0913461538462
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176336802849572"] = {
						["key"] = "176336802849572",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2141.6666666666665,
							["y"] = 910
						},
						["propsData"] = {}
					},
					["1763368054482308"] = {
						["key"] = "1763368054482308",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2942.8066080803846,
							["y"] = 555.9416639938809
						},
						["propsData"] = {}
					},
					["1763368054482309"] = {
						["key"] = "1763368054482309",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1645.6656940461287,
							["y"] = 835.0639952009692
						},
						["propsData"] = {}
					},
					["1763368054483311"] = {
						["key"] = "1763368054483311",
						["type"] = "TalkNode",
						["name"] = "过场动画",
						["pos"] = {
							["x"] = 2324.8144213660426,
							["y"] = 566.4369454522284
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC007/SQ_Ver0102_SC007",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["1763368054483312"] = {
						["key"] = "1763368054483312",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_31】止流幻境，看止流开卦（下）",
						["pos"] = {
							["x"] = 2621.204645257195,
							["y"] = 585.0959758880505
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12043212.12043212'",
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
					["17633681300011705"] = {
						["key"] = "17633681300011705",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_30】止流幻境，看止流开卦（上）",
						["pos"] = {
							["x"] = 2011.9901904255728,
							["y"] = 563.9062895708556
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12043201.12043201'",
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
					["1765889325964492"] = {
						["key"] = "1765889325964492",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1285.6948051948052,
							["y"] = -292.19480519480527
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049044,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17659597793261170"] = {
						["key"] = "17659597793261170",
						["type"] = "SendMessageNode",
						["name"] = "开启小黑屋玩法",
						["pos"] = {
							["x"] = 1228.584444163155,
							["y"] = 272.1200650316094
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "StartBox1",
							["UnitId"] = -1
						}
					},
					["17659597923501448"] = {
						["key"] = "17659597923501448",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 1772.4875763278578,
							["y"] = 294.7635013054805
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "OpenTheDoor1"
						}
					},
					["17659600019912655"] = {
						["key"] = "17659600019912655",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 2142.408087847947,
							["y"] = 314.95889932944186
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
					["17698485753868357555"] = {
						["key"] = "17698485753868357555",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2422.430347731978,
							["y"] = 321.4325302367349
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
					["17698485889338357912"] = {
						["key"] = "17698485889338357912",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1721.5041209415272,
							["y"] = 556.4998379290425
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242470001,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_ZLhezi1_242470001"
						}
					},
					["17733875068945059285"] = {
						["key"] = "17733875068945059285",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 1491.3241167434714,
							["y"] = 262.6181683328268
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								105602,
								105601
							}
						}
					},
					["17733875175155059504"] = {
						["key"] = "17733875175155059504",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1931.047619047619,
							["y"] = -46.18367498514567
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
					["17733920630992525598"] = {
						["key"] = "17733920630992525598",
						["type"] = "StandAloneBlackScreenNode",
						["name"] = "独立黑屏节点",
						["pos"] = {
							["x"] = 1529.7057692307692,
							["y"] = -167.82892976588641
						},
						["propsData"] = {
							["FadeInSeconds"] = 0,
							["FadeOutSeconds"] = 0.5,
							["DurationSeconds"] = 0.5,
							["IsStandAlone"] = false
						}
					},
					["1773494558755848786"] = {
						["key"] = "1773494558755848786",
						["type"] = "SendMessageNode",
						["name"] = "开启小黑屋玩法",
						["pos"] = {
							["x"] = 732.9515063883484,
							["y"] = 265.92756282618984
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "ReStartBox1",
							["UnitId"] = -1
						}
					},
					["1773494571264849045"] = {
						["key"] = "1773494571264849045",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 989.2015063883484,
							["y"] = 257.4078259840845
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