return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17189628637812656",
			["startPort"] = "StoryStart",
			["endStory"] = "17189628764052923",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17189628764052923",
			["startPort"] = "Success",
			["endStory"] = "17189628637822659",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17189628637812656"] = {
			["isStoryNode"] = true,
			["key"] = "17189628637812656",
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
		["17189628637822659"] = {
			["isStoryNode"] = true,
			["key"] = "17189628637822659",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1503.1,
				["y"] = 297
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17189628764052923"] = {
			["isStoryNode"] = true,
			["key"] = "17189628764052923",
			["type"] = "StoryNode",
			["name"] = "拯救皎皎",
			["pos"] = {
				["x"] = 1204.7446807949157,
				["y"] = 301.9483087204144
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_VillageSave_Des",
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
						["startQuest"] = "17189629773724696",
						["startPort"] = "Out",
						["endQuest"] = "17189631195655361",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17189629773724696",
						["startPort"] = "Out",
						["endQuest"] = "17189631668215776",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17189632786227222",
						["startPort"] = "Out",
						["endQuest"] = "17189633183747710",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17189633183747710",
						["startPort"] = "Out",
						["endQuest"] = "17189628764052927",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17189631668215776",
						["startPort"] = "Out",
						["endQuest"] = "172216060453619050",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172216060453619050",
						["startPort"] = "Out",
						["endQuest"] = "172216062738419363",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172216062738419363",
						["startPort"] = "Out",
						["endQuest"] = "17189632786227222",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172216066407019974",
						["startPort"] = "Out",
						["endQuest"] = "172216067171520183",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1725265135294166973",
						["startPort"] = "Out",
						["endQuest"] = "1725265371621170332",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1725265135294166973",
						["startPort"] = "Out",
						["endQuest"] = "1725265394661170719",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172216060453619050",
						["startPort"] = "Out",
						["endQuest"] = "172216066407019974",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17189628764052924",
						["startPort"] = "QuestStart",
						["endQuest"] = "17259491215521502",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17259491215521502",
						["startPort"] = "WeightBranch_1",
						["endQuest"] = "17189629773724696",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17259491215521502",
						["startPort"] = "WeightBranch_2",
						["endQuest"] = "1725265135294166973",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1725265554054171899",
						["startPort"] = "Out",
						["endQuest"] = "17189628764052927",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1725265394661170719",
						["startPort"] = "Out",
						["endQuest"] = "1725265554054171899",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17189628764052924"] = {
						["key"] = "17189628764052924",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 389.2207792207792,
							["y"] = 441.42857142857144
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17189628764052927"] = {
						["key"] = "17189628764052927",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2704.3757575757577,
							["y"] = 352.60202020202007
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17189628764052930"] = {
						["key"] = "17189628764052930",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2602.2727272727275,
							["y"] = 615.4545454545455
						},
						["propsData"] = {}
					},
					["17189629773724696"] = {
						["key"] = "17189629773724696",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成皎皎和怪物",
						["pos"] = {
							["x"] = 1040.7707491810693,
							["y"] = 299.0311828839854
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180342,
								1180343,
								1180344,
								1180341
							}
						}
					},
					["17189631195655361"] = {
						["key"] = "17189631195655361",
						["type"] = "TalkNode",
						["name"] = "弹旁白",
						["pos"] = {
							["x"] = 1346.0358285461487,
							["y"] = 139.17880193160445
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71000501,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17189631668215776"] = {
						["key"] = "17189631668215776",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1355.1548761651961,
							["y"] = 367.34546859827117
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 3,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1180342,
								1180343,
								1180344
							}
						}
					},
					["17189632786227222"] = {
						["key"] = "17189632786227222",
						["type"] = "TalkNode",
						["name"] = "表达感谢",
						["pos"] = {
							["x"] = 2139.3802729905933,
							["y"] = 348.94388129668397
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71000512,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_Dyn_71000512",
							["BlendInTime"] = 0.2,
							["BlendOutTime"] = 2,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 800005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
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
					["17189633183747710"] = {
						["key"] = "17189633183747710",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 2434.7691618794825,
							["y"] = 354.9994368522393
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["172216060453619050"] = {
						["key"] = "172216060453619050",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1617.8807303560636,
							["y"] = 363.3931981672952
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["172216062738419363"] = {
						["key"] = "172216062738419363",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1868.6807303560638,
							["y"] = 365.7931981672952
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180341
							}
						}
					},
					["172216066407019974"] = {
						["key"] = "172216066407019974",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1879.0807303560644,
							["y"] = 558.9931981672953
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["172216067171520183"] = {
						["key"] = "172216067171520183",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2143.4807303560647,
							["y"] = 557.7931981672951
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "Dyn_targetpoint",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1725265135294166973"] = {
						["key"] = "1725265135294166973",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成皎皎、狩月人与秽兽尸体",
						["pos"] = {
							["x"] = 1058.573987571567,
							["y"] = 872.3418144579437
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180494,
								1180490,
								1180491,
								1180492,
								1180493
							}
						}
					},
					["1725265371621170332"] = {
						["key"] = "1725265371621170332",
						["type"] = "TalkNode",
						["name"] = "狩月人开车",
						["pos"] = {
							["x"] = 1350.4456453255782,
							["y"] = 640.5236326397619
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71000503,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1725265394661170719"] = {
						["key"] = "1725265394661170719",
						["type"] = "TalkNode",
						["name"] = "探险白与狩月人的旁白",
						["pos"] = {
							["x"] = 1357.7077538053338,
							["y"] = 868.542425611496
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818014,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1180490",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71000504,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 818015,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1725265554054171899"] = {
						["key"] = "1725265554054171899",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 1834.710351207931,
							["y"] = 848.4781780943074
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 2,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17259491215521502"] = {
						["key"] = "17259491215521502",
						["type"] = "WeightBranchNode",
						["name"] = "权重分支节点",
						["pos"] = {
							["x"] = 712.3018175373013,
							["y"] = 433.85217363281873
						},
						["propsData"] = {
							["RandomTriggerBranchCount"] = 1,
							["WeightBranchArray"] = {
								3,
								1
							}
						}
					},
					["17267277549422278"] = {
						["key"] = "17267277549422278",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "狩月人离开",
						["pos"] = {
							["x"] = 1625.1515151515143,
							["y"] = 1036.4108780108784
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180490
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