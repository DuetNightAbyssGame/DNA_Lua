return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17285287777601",
			["startPort"] = "StoryStart",
			["endStory"] = "1728529886354335",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17288938128392411475",
			["startPort"] = "Success",
			["endStory"] = "17288946475193708638",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17288946475193708638",
			["startPort"] = "Success",
			["endStory"] = "17285287777605",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1728529886354335",
			["startPort"] = "Success",
			["endStory"] = "17362563253659743011",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17362563253659743011",
			["startPort"] = "Success",
			["endStory"] = "17288938128392411475",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17285287777601"] = {
			["isStoryNode"] = true,
			["key"] = "17285287777601",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1902.5625,
				["y"] = 316.375
			},
			["propsData"] = {
				["QuestChainId"] = 120001
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17285287777605"] = {
			["isStoryNode"] = true,
			["key"] = "17285287777605",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 3218.288505966153,
				["y"] = 301.19882493576455
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1728529886354335"] = {
			["isStoryNode"] = true,
			["key"] = "1728529886354335",
			["type"] = "StoryNode",
			["name"] = "东国引入-酒馆",
			["pos"] = {
				["x"] = 2183.229287635359,
				["y"] = 304.7562464087006
			},
			["propsData"] = {
				["QuestId"] = 12000101,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120001_1",
				["QuestDeatil"] = "Content_120001_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = true,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12000101_1220106",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1728635189419913071",
						["startPort"] = "Out",
						["endQuest"] = "1728529886355343",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1728529886354336",
						["startPort"] = "QuestStart",
						["endQuest"] = "17362488978552917481",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17362488978552917481",
						["startPort"] = "Out",
						["endQuest"] = "1728635189419913071",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1728529886354336"] = {
						["key"] = "1728529886354336",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1940.3146853146854,
							["y"] = 442.8671328671328
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1728529886355343"] = {
						["key"] = "1728529886355343",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2963.4212076719123,
							["y"] = 471.37871399250054
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1728529886355350"] = {
						["key"] = "1728529886355350",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3953.71390273013,
							["y"] = 788.3435935261493
						},
						["propsData"] = {}
					},
					["1728635189419913071"] = {
						["key"] = "1728635189419913071",
						["type"] = "TalkNode",
						["name"] = "站桩 - 卡米拉 Fixsimple01",
						["pos"] = {
							["x"] = 2507.1067687671894,
							["y"] = 434.46210380026184
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12000401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew12000101",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
							["InType"] = "BlendIn",
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
							["SkipToOption"] = true,
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
									["TalkActorId"] = 200003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
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
					["17362488978552917481"] = {
						["key"] = "17362488978552917481",
						["type"] = "GoToNode",
						["name"] = "进入酒馆内直接触发",
						["pos"] = {
							["x"] = 2239.77875634609,
							["y"] = 426.94787828900974
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1220106,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000101_1220106"
						}
					},
					["17369286947945040"] = {
						["key"] = "17369286947945040",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 2483.6144306256333,
							["y"] = 714.3074935171106
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101107,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_12000101"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17288938128392411475"] = {
			["isStoryNode"] = true,
			["key"] = "17288938128392411475",
			["type"] = "StoryNode",
			["name"] = "歌剧院门口",
			["pos"] = {
				["x"] = 2720.321603367527,
				["y"] = 307.2054724127564
			},
			["propsData"] = {
				["QuestId"] = 12000103,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120001_3",
				["QuestDeatil"] = "Content_120001_3",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_120001033_1191022",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17356472158039019",
						["startPort"] = "Out",
						["endQuest"] = "17356472389209806",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17356472158039019",
						["startPort"] = "Out",
						["endQuest"] = "17356472424129932",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17356472158039019",
						["startPort"] = "Out",
						["endQuest"] = "17356472425779938",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17356472389209806",
						["startPort"] = "Out",
						["endQuest"] = "173564740700911182",
						["endPort"] = "Branch_1"
					},
					{
						["startQuest"] = "17356472424129932",
						["startPort"] = "Out",
						["endQuest"] = "173564740700911182",
						["endPort"] = "Branch_2"
					},
					{
						["startQuest"] = "17356472425779938",
						["startPort"] = "Out",
						["endQuest"] = "173564740700911182",
						["endPort"] = "Branch_3"
					},
					{
						["startQuest"] = "173564740700911182",
						["startPort"] = "Out",
						["endQuest"] = "17288938128392411480",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17356472158039019",
						["startPort"] = "Out",
						["endQuest"] = "17362539765086810392",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17288938128392411479",
						["startPort"] = "QuestStart",
						["endQuest"] = "17356472158039019",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17288938128392411479"] = {
						["key"] = "17288938128392411479",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2359.8218157169754,
							["y"] = 822.2418993386727
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17288938128392411480"] = {
						["key"] = "17288938128392411480",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3705.974456577904,
							["y"] = 798.8978167426445
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17288938128392411481"] = {
						["key"] = "17288938128392411481",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3363.8647978707954,
							["y"] = 1216.9215986412396
						},
						["propsData"] = {}
					},
					["17356472158039019"] = {
						["key"] = "17356472158039019",
						["type"] = "BranchQuestStartNode",
						["name"] = "子任务开始节点",
						["pos"] = {
							["x"] = 2662.227337885584,
							["y"] = 811.2924549181487
						},
						["propsData"] = {
							["AllQuestOptions"] = {
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "Description_12000103_1",
									["TargetBranchQuestKey"] = ""
								},
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "Description_12000103_2",
									["TargetBranchQuestKey"] = ""
								},
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "Description_12000103_3",
									["TargetBranchQuestKey"] = ""
								}
							},
							["IsSetCountInfo"] = true,
							["IsDifftation"] = false,
							["AllDiffGuideOptions"] = {}
						}
					},
					["17356472389209806"] = {
						["key"] = "17356472389209806",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3006.694695960514,
							["y"] = 609.2790984486536
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 220003,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_120001031_1191020",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 12000601,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17356472424129932"] = {
						["key"] = "17356472424129932",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3033.489077139522,
							["y"] = 768.2217380595007
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 220005,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_120001033_1191022",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 12000605,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17356472425779938"] = {
						["key"] = "17356472425779938",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3120.489240816848,
							["y"] = 945.4728021693867
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 220006,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_120001034_1191023",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 12000607,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["173564740700911182"] = {
						["key"] = "173564740700911182",
						["type"] = "CheckBranchQuestFinishedNode",
						["name"] = "子任务结束节点",
						["pos"] = {
							["x"] = 3381.235900936026,
							["y"] = 777.5425237871573
						},
						["propsData"] = {
							["InputBranchQuestNumber"] = 3,
							["BranchQuestFinishOptions"] = {
								{
									["IsNeedFinish"] = true
								},
								{
									["IsNeedFinish"] = true
								},
								{
									["IsNeedFinish"] = true
								}
							}
						}
					},
					["17362539765086810392"] = {
						["key"] = "17362539765086810392",
						["type"] = "TalkNode",
						["name"] = "开车一个小提示去聊一下",
						["pos"] = {
							["x"] = 3031.6071294302883,
							["y"] = 440.84622068272915
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12004101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17369374721563151243"] = {
						["key"] = "17369374721563151243",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2601.7114601153853,
							["y"] = 628.2794089968002
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191020,
								1191022,
								1191023
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17288946475193708638"] = {
			["isStoryNode"] = true,
			["key"] = "17288946475193708638",
			["type"] = "StoryNode",
			["name"] = "前去检票吧——撞小孩",
			["pos"] = {
				["x"] = 2974.2633393263263,
				["y"] = 312.2809804517075
			},
			["propsData"] = {
				["QuestId"] = 12000104,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120001_4",
				["QuestDeatil"] = "Content_120001_4",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = true,
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
						["startQuest"] = "17288946475193708642",
						["startPort"] = "QuestStart",
						["endQuest"] = "17288946475193708645",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17288946475193708645",
						["startPort"] = "Out",
						["endQuest"] = "1728901023816188827",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1728901023816188827",
						["startPort"] = "Out",
						["endQuest"] = "17370145701691022",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17370145788571298",
						["startPort"] = "Out",
						["endQuest"] = "17288946475193708643",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17370145701691022",
						["startPort"] = "Out",
						["endQuest"] = "17417624114274911468",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17417624114274911468",
						["startPort"] = "Out",
						["endQuest"] = "17370145788571298",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17288946475193708642"] = {
						["key"] = "17288946475193708642",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 2239.9800649800654,
							["y"] = 800.3274503274504
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17288946475193708643"] = {
						["key"] = "17288946475193708643",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3503.846931325379,
							["y"] = 764.6112005810284
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17288946475193708644"] = {
						["key"] = "17288946475193708644",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3469.706067712065,
							["y"] = 984.9057256253659
						},
						["propsData"] = {}
					},
					["17288946475193708645"] = {
						["key"] = "17288946475193708645",
						["type"] = "GoToNode",
						["name"] = "去检票的路上",
						["pos"] = {
							["x"] = 2568.7708328707454,
							["y"] = 801.0372564434704
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191024,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12000104_1191024"
						}
					},
					["1728901023816188827"] = {
						["key"] = "1728901023816188827",
						["type"] = "TalkNode",
						["name"] = "站桩 - 撞上黄牛小孩",
						["pos"] = {
							["x"] = 2877.999999999999,
							["y"] = 790.0000000000002
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12000701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000104",
							["BlendInTime"] = 1,
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
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = true,
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
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 220007,
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
					["17370145701691022"] = {
						["key"] = "17370145701691022",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2932.8380618841275,
							["y"] = 1010.0785206010842
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12000711,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
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
					["17370145788571298"] = {
						["key"] = "17370145788571298",
						["type"] = "TalkNode",
						["name"] = "站桩 - 撞上黄牛小孩",
						["pos"] = {
							["x"] = 3236.8478504826257,
							["y"] = 797.7751989227625
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12000712,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000104",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0.5,
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
									["TalkActorId"] = 200002,
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
					["17417624114274911468"] = {
						["key"] = "17417624114274911468",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 3197.8008025720737,
							["y"] = 1024.3347655155214
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191025
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17362563253659743011"] = {
			["isStoryNode"] = true,
			["key"] = "17362563253659743011",
			["type"] = "StoryNode",
			["name"] = "设置酒馆门口",
			["pos"] = {
				["x"] = 2474.6831433466227,
				["y"] = 303.2390481511744
			},
			["propsData"] = {
				["QuestId"] = 12000102,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120001_2",
				["QuestDeatil"] = "Content_120001_2",
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_120001022_1191019",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17362563841199744417",
						["startPort"] = "Out",
						["endQuest"] = "17362563841199744418",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17362563841199744419",
						["startPort"] = "true",
						["endQuest"] = "17362563841199744417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17362563841199744414",
						["startPort"] = "Out",
						["endQuest"] = "17362563841199744415",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17362563841199744419",
						["startPort"] = "true",
						["endQuest"] = "17369293714813883832",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17362563841199744419",
						["startPort"] = "false",
						["endQuest"] = "17369293714813883832",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17362563253659743012",
						["startPort"] = "QuestStart",
						["endQuest"] = "173650121344715609148",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173650121344715609148",
						["startPort"] = "Out",
						["endQuest"] = "17369381149035093112",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17369381149035093112",
						["startPort"] = "Out",
						["endQuest"] = "17362563841199744416",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17362563841199744415",
						["startPort"] = "Out",
						["endQuest"] = "17362563253659743015",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173650121344715609148",
						["startPort"] = "Out",
						["endQuest"] = "17369378662784123363",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17369378662784123363",
						["startPort"] = "Out",
						["endQuest"] = "17362563841199744414",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17362563253659743012"] = {
						["key"] = "17362563253659743012",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 889.6666666666667,
							["y"] = 293.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17362563253659743015"] = {
						["key"] = "17362563253659743015",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2577.6115650534257,
							["y"] = 428.265241986172
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17362563253659743018"] = {
						["key"] = "17362563253659743018",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2603.3333333333335,
							["y"] = 600
						},
						["propsData"] = {}
					},
					["17362563841199744414"] = {
						["key"] = "17362563841199744414",
						["type"] = "GoToNode",
						["name"] = "剧院外侧碰撞盒",
						["pos"] = {
							["x"] = 1764.6406154168699,
							["y"] = 349.22917210013134
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191019,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_120001022_1191019"
						}
					},
					["17362563841199744415"] = {
						["key"] = "17362563841199744415",
						["type"] = "TalkNode",
						["name"] = "热闹的氛围镜头一览",
						["pos"] = {
							["x"] = 2006.5867993700217,
							["y"] = 422.5125204670485
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12000505,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_12000102",
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
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = false,
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
					["17362563841199744416"] = {
						["key"] = "17362563841199744416",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1950.7021162244916,
							["y"] = 736.3854393447039
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12000501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17362563841199744417"] = {
						["key"] = "17362563841199744417",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1434.7567609600364,
							["y"] = -47.25765800646519
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "NewTargetPoint_12000102",
							["FadeIn"] = true,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17362563841199744418"] = {
						["key"] = "17362563841199744418",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 1831.937936403786,
							["y"] = -39.17002212500455
						},
						["propsData"] = {
							["VarName"] = "FirstGotoIceCity12000103",
							["VarValue"] = 1
						}
					},
					["17362563841199744419"] = {
						["key"] = "17362563841199744419",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "执行变量检测函数-是否传过一次了",
						["pos"] = {
							["x"] = 1090.313419013113,
							["y"] = 102.7317240547467
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "FirstGotoIceCity12000103",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["173650121344715609148"] = {
						["key"] = "173650121344715609148",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1169.6430224079763,
							["y"] = 447.4675932909377
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191018,
							["GuideType"] = "P",
							["GuidePointName"] = "Mechanism_12000102_1191018"
						}
					},
					["17369293714813883832"] = {
						["key"] = "17369293714813883832",
						["type"] = "PrintVarNode",
						["name"] = "打印变量值",
						["pos"] = {
							["x"] = 1425.4802340690503,
							["y"] = 97.41588947198716
						},
						["propsData"] = {
							["VarName"] = "FirstGotoIceCity12000103"
						}
					},
					["17369374920033151672"] = {
						["key"] = "17369374920033151672",
						["type"] = "TalkNode",
						["name"] = "假装这里热闹",
						["pos"] = {
							["x"] = 2330.744542379955,
							["y"] = 608.3534930214677
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12001901,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
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
					["17369378662784123363"] = {
						["key"] = "17369378662784123363",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1469.4352764871003,
							["y"] = 418.0099801990625
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191025
							}
						}
					},
					["17369381149035093112"] = {
						["key"] = "17369381149035093112",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1432.2345020212072,
							["y"] = 735.8005818686422
						},
						["propsData"] = {
							["WaitTime"] = 1.3
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}