return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1715582936879937864",
			["startPort"] = "Success",
			["endStory"] = "1716364352215332212",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1716364352215332212",
			["startPort"] = "Success",
			["endStory"] = "17155815892581044683",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17155815892581044682",
			["startPort"] = "StoryStart",
			["endStory"] = "1715582936879937864",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17155815892581044682"] = {
			["isStoryNode"] = true,
			["key"] = "17155815892581044682",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 34.9979002774719,
				["y"] = 699.482147430621
			},
			["propsData"] = {
				["QuestChainId"] = 200208
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17155815892581044683"] = {
			["isStoryNode"] = true,
			["key"] = "17155815892581044683",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1081.0753628278114,
				["y"] = 702.4380764949684
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1715582929033937580"] = {
			["isStoryNode"] = true,
			["key"] = "1715582929033937580",
			["type"] = "StoryNode",
			["name"] = "前往疗养院",
			["pos"] = {
				["x"] = 287.46765120850785,
				["y"] = 529.7637843780723
			},
			["propsData"] = {
				["QuestId"] = 20020801,
				["QuestDescriptionComment"] = "前往疗养院",
				["QuestDescription"] = "Description_200208_1",
				["QuestDeatil"] = "Content_200208_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
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
				["SubRegionId"] = 101106,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "TargetPoint_Sanatorium",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1715582929033937581",
						["startPort"] = "QuestStart",
						["endQuest"] = "17155831151891148166",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17155831151891148166",
						["startPort"] = "Out",
						["endQuest"] = "1715582929033937584",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1715582929033937581"] = {
						["key"] = "1715582929033937581",
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
					["1715582929033937584"] = {
						["key"] = "1715582929033937584",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1434.817391304348,
							["y"] = 299.3739130434783
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1715582929033937587"] = {
						["key"] = "1715582929033937587",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17155831151891148166"] = {
						["key"] = "17155831151891148166",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1083.5734960574016,
							["y"] = 296.52304150954853
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101106,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_Sanatorium"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1715582936879937864"] = {
			["isStoryNode"] = true,
			["key"] = "1715582936879937864",
			["type"] = "StoryNode",
			["name"] = "和莱娜对话",
			["pos"] = {
				["x"] = 540.9816709742719,
				["y"] = 684.2300055599911
			},
			["propsData"] = {
				["QuestId"] = 20020802,
				["QuestDescriptionComment"] = "去疗养院找莱娜对话",
				["QuestDescription"] = "Description_200208_2",
				["QuestDeatil"] = "Content_200208_2",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
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
				["SubRegionId"] = 101106,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_200208Laina_1200106",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1715582936879937868",
						["startPort"] = "QuestStart",
						["endQuest"] = "17155831418481252236",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17155831418481252236",
						["startPort"] = "Out",
						["endQuest"] = "1715582936879937869",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1715582936879937868"] = {
						["key"] = "1715582936879937868",
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
					["1715582936879937869"] = {
						["key"] = "1715582936879937869",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1357.6,
							["y"] = 301.2
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1715582936879937870"] = {
						["key"] = "1715582936879937870",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17155831418481252236"] = {
						["key"] = "17155831418481252236",
						["type"] = "WaitImpressionTalkCompleteNode",
						["name"] = "等待印象对话完成",
						["pos"] = {
							["x"] = 1071.0144898462222,
							["y"] = 303.2090439196657
						},
						["propsData"] = {
							["ImpressionTalkTriggerId"] = 510050,
							["bShowGuide"] = true,
							["GuideType"] = "N",
							["NPCStaticCreaterName"] = "Npc_200208Laina_1200106"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1716364352215332212"] = {
			["isStoryNode"] = true,
			["key"] = "1716364352215332212",
			["type"] = "StoryNode",
			["name"] = "搜寻恩里克遗嘱",
			["pos"] = {
				["x"] = 805.0520893484847,
				["y"] = 686.3190754897275
			},
			["propsData"] = {
				["QuestId"] = 20020803,
				["QuestDescriptionComment"] = "寻找恩里克遗嘱",
				["QuestDescription"] = "Description_200208_3",
				["QuestDeatil"] = "Content_200208_3",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
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
				["SubRegionId"] = 101106,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_20020803",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1716364510877977361",
						["startPort"] = "Out",
						["endQuest"] = "17163655075511839415",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17163655075511839415",
						["startPort"] = "Out",
						["endQuest"] = "17163656071252055039",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1716364352215332213",
						["startPort"] = "QuestStart",
						["endQuest"] = "17163652150041621232",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17163656071252055039",
						["startPort"] = "Out",
						["endQuest"] = "1716364352215332216",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17410942512465232517",
						["startPort"] = "Out",
						["endQuest"] = "17410947537958370479",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17410947537958370479",
						["startPort"] = "Out",
						["endQuest"] = "17410947143478370185",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17410947143478370185",
						["startPort"] = "Out",
						["endQuest"] = "1716364510877977361",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17163652150041621232",
						["startPort"] = "Out",
						["endQuest"] = "1741241414169911",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1741241476075790365",
						["startPort"] = "Out",
						["endQuest"] = "17410942512465232517",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1741241414169911",
						["startPort"] = "Out",
						["endQuest"] = "1741241476075790365",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1716364352215332213"] = {
						["key"] = "1716364352215332213",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -459.8777173913045,
							["y"] = 319.32065217391306
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1716364352215332216"] = {
						["key"] = "1716364352215332216",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2062.0108695652175,
							["y"] = 313.7853260869565
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1716364352215332219"] = {
						["key"] = "1716364352215332219",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1925.75,
							["y"] = 462
						},
						["propsData"] = {}
					},
					["1716364510877977361"] = {
						["key"] = "1716364510877977361",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1261.6956615943168,
							["y"] = 304.8394457087532
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51005034,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20020803",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700098,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700013,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17163652150041621232"] = {
						["key"] = "17163652150041621232",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = -208.29718737593498,
							["y"] = 319.70143083461136
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1200158
							}
						}
					},
					["17163655075511839415"] = {
						["key"] = "17163655075511839415",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1507.3821604501525,
							["y"] = 306.1473690497143
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51005040,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 2,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17163656071252055039"] = {
						["key"] = "17163656071252055039",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1779.4773549581614,
							["y"] = 314.0220830085244
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_LeaveOffice",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17410942512465232517"] = {
						["key"] = "17410942512465232517",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 513.0434782608694,
							["y"] = 312.34782608695645
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1200158,
							["StateId"] = 572,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "QuestPoint_20020803"
						}
					},
					["17410947143478370185"] = {
						["key"] = "17410947143478370185",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1023.952876193482,
							["y"] = 306.30190168073847
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51005042,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_20020803",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700098,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17410947537958370479"] = {
						["key"] = "17410947537958370479",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入疗养院",
						["pos"] = {
							["x"] = 775.2173913043474,
							["y"] = 307.1304347826086
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101106,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["1741241414169911"] = {
						["key"] = "1741241414169911",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 37.73913043478228,
							["y"] = 311.47826086956513
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1200159,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_20020803"
						}
					},
					["1741241476075790365"] = {
						["key"] = "1741241476075790365",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 276.43478260869546,
							["y"] = 324.5217391304347
						},
						["propsData"] = {
							["NewDescription"] = "Description_200208_4",
							["NewDetail"] = "Content_200208_4",
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