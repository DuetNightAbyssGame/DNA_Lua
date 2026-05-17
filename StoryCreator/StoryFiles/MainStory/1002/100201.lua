return {
	["storyName"] = "未命名故事",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_16844790799220",
			["startPort"] = "StoryStart",
			["endStory"] = "story_16844791203384",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1698223105447183661",
			["startPort"] = "Success",
			["endStory"] = "story_16844790799222",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "170246689171376464",
			["startPort"] = "Success",
			["endStory"] = "story_1686038892768203",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_168448111698466",
			["startPort"] = "Success",
			["endStory"] = "story_1684482633946108",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1702468354501121387",
			["startPort"] = "Success",
			["endStory"] = "1698223105447183661",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_16844791203384",
			["startPort"] = "Success",
			["endStory"] = "story_168448111698466",
			["endPort"] = "In"
		},
		{
			["startStory"] = "170417835022081449",
			["startPort"] = "Success",
			["endStory"] = "story_1684484789006140",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_1686038892768203",
			["startPort"] = "Success",
			["endStory"] = "story_1686038892767184",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_1684482633946108",
			["startPort"] = "Success",
			["endStory"] = "170417835022081449",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_1686038892767184",
			["startPort"] = "Success",
			["endStory"] = "1702468354501121387",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_1684484789006140",
			["startPort"] = "Success",
			["endStory"] = "170246689171376464",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["story_16844790799220"] = {
			["isStoryNode"] = true,
			["key"] = "story_16844790799220",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = -532.4999999999995,
				["y"] = 139.72222222222223
			},
			["propsData"] = {
				["QuestChainId"] = 100201
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_16844790799222"] = {
			["isStoryNode"] = true,
			["key"] = "story_16844790799222",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 844.2805156886236,
				["y"] = 514.0589689513702
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_16844791203384"] = {
			["isStoryNode"] = true,
			["key"] = "story_16844791203384",
			["type"] = "StoryNode",
			["name"] = "苏醒",
			["pos"] = {
				["x"] = -244.4104761259765,
				["y"] = 116.08287757966313
			},
			["propsData"] = {
				["QuestId"] = 10020101,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020101",
				["QuestDeatil"] = "QuestDesc_10020101",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
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
						["startQuest"] = "quest_16941608686221040",
						["startPort"] = "Out",
						["endQuest"] = "quest_1687767152149286",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "169510792764936998",
						["startPort"] = "Out",
						["endQuest"] = "17368229624622874394",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16941608686221040",
						["startPort"] = "Out",
						["endQuest"] = "169510792764936998",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16941608686221040",
						["startPort"] = "Out",
						["endQuest"] = "17286308287165351",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17574027053373416",
						["startPort"] = "Out",
						["endQuest"] = "17574027053373417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17574027053373417",
						["startPort"] = "Out",
						["endQuest"] = "quest_168447912033810",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17368229624622874394",
						["startPort"] = "Out",
						["endQuest"] = "17574027053373416",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_16844791203388",
						["startPort"] = "QuestStart",
						["endQuest"] = "quest_168448189176895",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_168448189176895",
						["startPort"] = "Out",
						["endQuest"] = "quest_16941608686221040",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_16844791203388"] = {
						["key"] = "quest_16844791203388",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -1886.0171451875042,
							["y"] = 188.0053415142027
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_168447912033810"] = {
						["key"] = "quest_168447912033810",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = -44.83565898755255,
							["y"] = 169.65479276901348
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_168447912033812"] = {
						["key"] = "quest_168447912033812",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 269.69360197064725,
							["y"] = 394.3011257780065
						},
						["propsData"] = {}
					},
					["quest_168448189176895"] = {
						["key"] = "quest_168448189176895",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = -1637.4878441760566,
							["y"] = 170.4672729299229
						},
						["propsData"] = {
							["QuestRoleId"] = 1010101,
							["IsPlayFX"] = false
						}
					},
					["quest_1687767152149286"] = {
						["key"] = "quest_1687767152149286",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "设置玩家位置公路起点",
						["pos"] = {
							["x"] = -1010.6503868133983,
							["y"] = -80.85632491436445
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_10020102",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["quest_1687849351233294"] = {
						["key"] = "quest_1687849351233294",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放BGM",
						["pos"] = {
							["x"] = -950.6960337457699,
							["y"] = 538.1450736555043
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["quest_16941608686221040"] = {
						["key"] = "quest_16941608686221040",
						["type"] = "GoToRegionNode",
						["name"] = "wait  for 公路（封闭流程）",
						["pos"] = {
							["x"] = -1352.1739994385462,
							["y"] = 162.71307696681038
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "P10100201Nvzhu"
						}
					},
					["169510792764936998"] = {
						["key"] = "169510792764936998",
						["type"] = "TalkNode",
						["name"] = "苏醒过场",
						["pos"] = {
							["x"] = -1020.4526378208218,
							["y"] = 187.91840100695575
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC001/SQ_OBT0101_SC001",
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
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
					["1707123298204221578"] = {
						["key"] = "1707123298204221578",
						["type"] = "BossBattleOpenNode",
						["name"] = "BOSS战开场播片",
						["pos"] = {
							["x"] = 308.06779510177324,
							["y"] = -227.24405795959237
						},
						["propsData"] = {
							["SequencePath"] = "LevelSequence'/Game/AssetDesign/Story/Sequence/Common/Common_Black_Quick_WhithoutFadein.Common_Black_Quick_WhithoutFadein'",
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["EnableSkip"] = false,
							["PauseGameGlobal"] = false,
							["HideNpcs"] = false,
							["HideMonsters"] = true
						}
					},
					["1707123298204221579"] = {
						["key"] = "1707123298204221579",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 28.748011588895338,
							["y"] = -243.44097598899137
						},
						["propsData"] = {
							["WaitTime"] = 0.1
						}
					},
					["17286308287165351"] = {
						["key"] = "17286308287165351",
						["type"] = "SendMessageNode",
						["name"] = "发送消息，飞艇回到初始位置",
						["pos"] = {
							["x"] = -1023.9999999999998,
							["y"] = -243.95454545454558
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "FeitingStopFromBeginning",
							["UnitId"] = -1
						}
					},
					["17368229624622874394"] = {
						["key"] = "17368229624622874394",
						["type"] = "TalkNode",
						["name"] = "和卡米拉交流",
						["pos"] = {
							["x"] = -770.1894409937877,
							["y"] = 171.50000000000009
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10100201,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_101002",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = true,
							["StartFadeOutTime"] = 0.5,
							["StartScreenEffectDuration"] = 1,
							["FinishFadeInTime"] = 0,
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
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17574027053373416"] = {
						["key"] = "17574027053373416",
						["type"] = "HeitaoLeaveTeamNode",
						["name"] = "黑桃离队",
						["pos"] = {
							["x"] = -521.5328254953631,
							["y"] = 184.90283101368684
						},
						["propsData"] = {}
					},
					["17574027053373417"] = {
						["key"] = "17574027053373417",
						["type"] = "PrologueGachaNode",
						["name"] = "序章特供抽卡",
						["pos"] = {
							["x"] = -273.3838583705734,
							["y"] = 176.41859755774163
						},
						["propsData"] = {}
					},
					["176287051174824569386"] = {
						["key"] = "176287051174824569386",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = -1608.2504012724905,
							["y"] = 10.672743438717632
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["story_168448111698466"] = {
			["isStoryNode"] = true,
			["key"] = "story_168448111698466",
			["type"] = "StoryNode",
			["name"] = "上公路",
			["pos"] = {
				["x"] = -1.5261889539352467,
				["y"] = 112.851181590896
			},
			["propsData"] = {
				["QuestId"] = 10020102,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020102",
				["QuestDeatil"] = "QuestDesc_10020102",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "170246589325349141",
						["startPort"] = "Out",
						["endQuest"] = "170349203137378661",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213875040371282652",
						["startPort"] = "Out",
						["endQuest"] = "17213875040371282653",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213875040371282653",
						["startPort"] = "Out",
						["endQuest"] = "17213875040371282654",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213875040371282654",
						["startPort"] = "Out",
						["endQuest"] = "17213875040371282655",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170246589325349141",
						["startPort"] = "Out",
						["endQuest"] = "17213875040371282652",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213875040371282655",
						["startPort"] = "Out",
						["endQuest"] = "1721704305260307943",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_168448133533183",
						["startPort"] = "Out",
						["endQuest"] = "1722593590036818560",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170488841182291426",
						["startPort"] = "Out",
						["endQuest"] = "quest_1685960615817363",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1685960615817363",
						["startPort"] = "Out",
						["endQuest"] = "quest_168448133533183",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722593590036818560",
						["startPort"] = "Out",
						["endQuest"] = "17392443159842034173",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1722593590036818560",
						["startPort"] = "Out",
						["endQuest"] = "17392550882903005",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17392550882903005",
						["startPort"] = "Out",
						["endQuest"] = "17392554285871017549",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17236369910202045771",
						["startPort"] = "Out",
						["endQuest"] = "170488841182291426",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17236369910202045771",
						["startPort"] = "Out",
						["endQuest"] = "quest_1685012510362175",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17392554285871017549",
						["startPort"] = "Out",
						["endQuest"] = "17568844843382694",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17568844843382694",
						["startPort"] = "Out",
						["endQuest"] = "quest_168448111698472",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "170246589325349141",
						["startPort"] = "Out",
						["endQuest"] = "17236369910202045771",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17154144497784412",
						["startPort"] = "Out",
						["endQuest"] = "175610866604612361552",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17154144497784412",
						["startPort"] = "Out",
						["endQuest"] = "170246589325349141",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_168448111698470",
						["startPort"] = "QuestStart",
						["endQuest"] = "17154144497784412",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_168448111698470"] = {
						["key"] = "quest_168448111698470",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -1644.5238950353553,
							["y"] = 96.84875184238511
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_168448111698472"] = {
						["key"] = "quest_168448111698472",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1479.321569039117,
							["y"] = 90.05180681512091
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_168448111698474"] = {
						["key"] = "quest_168448111698474",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1057.2617246543603,
							["y"] = 223.41556893722486
						},
						["propsData"] = {}
					},
					["quest_168448133533183"] = {
						["key"] = "quest_168448133533183",
						["type"] = "SendMessageNode",
						["name"] = "发送消息：让白上公路",
						["pos"] = {
							["x"] = 392.3502265864256,
							["y"] = 600.3324915954624
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "BaiGo",
							["UnitId"] = 200002
						}
					},
					["quest_1685012510362175"] = {
						["key"] = "quest_1685012510362175",
						["type"] = "TalkNode",
						["name"] = "身上的伤恢复了",
						["pos"] = {
							["x"] = 412.6196791677976,
							["y"] = -76.19382367742327
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10100301,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["quest_1685960615817363"] = {
						["key"] = "quest_1685960615817363",
						["type"] = "SetNpcPatrolNode",
						["name"] = "设置小白的巡逻点",
						["pos"] = {
							["x"] = 392.782782533196,
							["y"] = 447.29678539927227
						},
						["propsData"] = {
							["NpcId"] = 200002,
							["PatrolId"] = 1001
						}
					},
					["170246564859938199"] = {
						["key"] = "170246564859938199",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = -78.86789106432519,
							["y"] = -238.43649123723193
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["170246589325349141"] = {
						["key"] = "170246589325349141",
						["type"] = "GoToRegionNode",
						["name"] = "wait  for 公路（封闭流程）",
						["pos"] = {
							["x"] = -477.9521662681757,
							["y"] = 100.23494664553888
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_10020102"
						}
					},
					["170349203137378661"] = {
						["key"] = "170349203137378661",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 448.42028060171094,
							["y"] = -233.2504039036871
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_10020102",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["170488841182291426"] = {
						["key"] = "170488841182291426",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 402.86354281794985,
							["y"] = 266.5097327949039
						},
						["propsData"] = {
							["WaitTime"] = 1.5
						}
					},
					["17154144497784412"] = {
						["key"] = "17154144497784412",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = -1193.6463953896916,
							["y"] = 115.3207677181499
						},
						["propsData"] = {}
					},
					["17213875040371282652"] = {
						["key"] = "17213875040371282652",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 73.30604695591478,
							["y"] = -414.83883365367217
						},
						["propsData"] = {
							["Function"] = "SetContinuedPCGuideVisibility",
							["UIParam"] = "None",
							["ActionParam"] = "SpiralLeap",
							["ShowOrHide"] = true
						}
					},
					["17213875040371282653"] = {
						["key"] = "17213875040371282653",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 341.87747552734345,
							["y"] = -417.69597651081506
						},
						["propsData"] = {
							["Function"] = "SetContinuedPCGuideVisibility",
							["UIParam"] = "None",
							["ActionParam"] = "Dodge",
							["ShowOrHide"] = true
						}
					},
					["17213875040371282654"] = {
						["key"] = "17213875040371282654",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 617.5917612416292,
							["y"] = -411.9816907965295
						},
						["propsData"] = {
							["Function"] = "SetContinuedPCGuideVisibility",
							["UIParam"] = "None",
							["ActionParam"] = "Skill1",
							["ShowOrHide"] = true
						}
					},
					["17213875040371282655"] = {
						["key"] = "17213875040371282655",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 875.9250945749626,
							["y"] = -416.50550032033897
						},
						["propsData"] = {
							["Function"] = "SetContinuedPCGuideVisibility",
							["UIParam"] = "None",
							["ActionParam"] = "Skill2",
							["ShowOrHide"] = true
						}
					},
					["1721704305260307943"] = {
						["key"] = "1721704305260307943",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1148.8349402045005,
							["y"] = -415.0523291034588
						},
						["propsData"] = {
							["Function"] = "SetContinuedPCGuideVisibility",
							["UIParam"] = "None",
							["ActionParam"] = "Skill2Attack",
							["ShowOrHide"] = true
						}
					},
					["1722593340507496475"] = {
						["key"] = "1722593340507496475",
						["type"] = "SwitchStoryModeNode",
						["name"] = "开启 剧情模式",
						["pos"] = {
							["x"] = 403.22924212197637,
							["y"] = 100.5617588238031
						},
						["propsData"] = {
							["IsOpen"] = true
						}
					},
					["1722593590036818560"] = {
						["key"] = "1722593590036818560",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 388.15747178704805,
							["y"] = 753.0976439912672
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					},
					["1723632166317699891"] = {
						["key"] = "1723632166317699891",
						["type"] = "WaitingCompleteSysGuideNode",
						["name"] = "等待完成指引",
						["pos"] = {
							["x"] = 35.70651538739256,
							["y"] = 460.2618972124174
						},
						["propsData"] = {
							["SystemGuideId"] = 2002
						}
					},
					["17236369910202045771"] = {
						["key"] = "17236369910202045771",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成小白",
						["pos"] = {
							["x"] = 20.617691663441338,
							["y"] = 142.69344716513405
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180006
							}
						}
					},
					["17368230109103830050"] = {
						["key"] = "17368230109103830050",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = -1333.1256963638552,
							["y"] = -102.1337018765514
						},
						["propsData"] = {
							["QuestRoleId"] = 1010101,
							["IsPlayFX"] = false
						}
					},
					["17392443159842034173"] = {
						["key"] = "17392443159842034173",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "给小白挂指引点",
						["pos"] = {
							["x"] = 665.4450549450551,
							["y"] = 764.9725274725275
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_AIBai_1180006"
						}
					},
					["17392550882903005"] = {
						["key"] = "17392550882903005",
						["type"] = "WaitOfTimeNode",
						["name"] = "等小白跑到位",
						["pos"] = {
							["x"] = 689.7142857142859,
							["y"] = 107.42857142857132
						},
						["propsData"] = {
							["WaitTime"] = 14
						}
					},
					["17392554285871017549"] = {
						["key"] = "17392554285871017549",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "消除小白的指引点",
						["pos"] = {
							["x"] = 922.5714285714288,
							["y"] = 107.42857142857157
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_AIBai_1180006"
						}
					},
					["17392569131874058823"] = {
						["key"] = "17392569131874058823",
						["type"] = "SendMessageNode",
						["name"] = "卡车刷出来",
						["pos"] = {
							["x"] = 1014.0714285714288,
							["y"] = 589.4285714285714
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_Trafficway_Truck1",
							["UnitId"] = -1
						}
					},
					["175610866604612361552"] = {
						["key"] = "175610866604612361552",
						["type"] = "MSDKUploadNode",
						["name"] = "海外市场SDK埋点上报",
						["pos"] = {
							["x"] = -735.8142079763182,
							["y"] = -84.61300528860451
						},
						["propsData"] = {
							["EventName"] = "weaponup_1"
						}
					},
					["17568844843382694"] = {
						["key"] = "17568844843382694",
						["type"] = "CheckAlternativeCharNode",
						["name"] = "检查备选角色",
						["pos"] = {
							["x"] = 1219.539900628709,
							["y"] = 102.55053925033866
						},
						["propsData"] = {}
					},
					["17568851280232863729"] = {
						["key"] = "17568851280232863729",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = -337.5898846401145,
							["y"] = 553.2638389882032
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {},
							["ManualItemIdList"] = {},
							["StateId"] = 0,
							["QuestId"] = 0
						}
					},
					["17568851317752863800"] = {
						["key"] = "17568851317752863800",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = -226.41341405187916,
							["y"] = 715.6167801646737
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 0,
							["StateId"] = 0,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		},
		["story_1684482633946108"] = {
			["isStoryNode"] = true,
			["key"] = "story_1684482633946108",
			["type"] = "StoryNode",
			["name"] = "击退怪物",
			["pos"] = {
				["x"] = 262.67723999216037,
				["y"] = 111.38294030275866
			},
			["propsData"] = {
				["QuestId"] = 10020103,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020103",
				["QuestDeatil"] = "QuestDesc_10020103",
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "P1180032",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1728474384436407144",
						["startPort"] = "Out",
						["endQuest"] = "1728474384436407145",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17371118581708680",
						["startPort"] = "Out",
						["endQuest"] = "1721112686059183205",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1684482633947112",
						["startPort"] = "QuestStart",
						["endQuest"] = "17371118581708680",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1721112686059183205",
						["startPort"] = "Out",
						["endQuest"] = "17527507965891938646",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17527507965891938646",
						["startPort"] = "Success",
						["endQuest"] = "quest_1684482633947114",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17527507965891938646",
						["startPort"] = "Fail",
						["endQuest"] = "1728474384436407144",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17527507965891938646",
						["startPort"] = "PassiveFail",
						["endQuest"] = "1728474384436407144",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1728474384436407145",
						["startPort"] = "Out",
						["endQuest"] = "17552471336422144321",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17552471336422144321",
						["startPort"] = "Out",
						["endQuest"] = "quest_1684482633947116",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["quest_1684482633947112"] = {
						["key"] = "quest_1684482633947112",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -886.4097259053251,
							["y"] = 145.22523879286436
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684482633947114"] = {
						["key"] = "quest_1684482633947114",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1379.5899890110063,
							["y"] = 166.20636306516678
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684482633947116"] = {
						["key"] = "quest_1684482633947116",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1398.0354564865438,
							["y"] = 447.25808872213713
						},
						["propsData"] = {}
					},
					["1721112686059183205"] = {
						["key"] = "1721112686059183205",
						["type"] = "GoToNode",
						["name"] = "goto公路集装箱前",
						["pos"] = {
							["x"] = -136.7043606847974,
							["y"] = 155.84007097723395
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1180032,
							["GuideType"] = "P",
							["GuidePointName"] = "P1180032"
						}
					},
					["1728474384436407144"] = {
						["key"] = "1728474384436407144",
						["type"] = "RefreshPlayerNode",
						["name"] = "重新初始化玩家",
						["pos"] = {
							["x"] = 857.8643385865314,
							["y"] = 367.41572758205814
						},
						["propsData"] = {}
					},
					["1728474384436407145"] = {
						["key"] = "1728474384436407145",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 862.1335744885275,
							["y"] = 497.44107706618365
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_10020102",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["17364205368953149"] = {
						["key"] = "17364205368953149",
						["type"] = "SendMessageNode",
						["name"] = "卡车刷出来",
						["pos"] = {
							["x"] = -39.11913086913073,
							["y"] = 452.2523865023864
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_Trafficway_Truck1",
							["UnitId"] = -1
						}
					},
					["17371118581708680"] = {
						["key"] = "17371118581708680",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = -453.04545454545473,
							["y"] = 153.07272727272684
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "P1180032"
						}
					},
					["17527507965891938646"] = {
						["key"] = "17527507965891938646",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 442.14285714285734,
							["y"] = 234.85714285714278
						},
						["propsData"] = {
							["SpecialConfigId"] = 118,
							["BlackScreenImmediately"] = false
						}
					},
					["17552471336422144321"] = {
						["key"] = "17552471336422144321",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁小白",
						["pos"] = {
							["x"] = 1109.4579686387383,
							["y"] = 492.1904761904764
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180006
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["story_1684484789006140"] = {
			["isStoryNode"] = true,
			["key"] = "story_1684484789006140",
			["type"] = "StoryNode",
			["name"] = "进城",
			["pos"] = {
				["x"] = -245.60511653829874,
				["y"] = 311.34033444983766
			},
			["propsData"] = {
				["QuestId"] = 10020105,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020105",
				["QuestDeatil"] = "QuestDesc_10020105",
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
						["startQuest"] = "quest_1684484789006144",
						["startPort"] = "QuestStart",
						["endQuest"] = "17213873872071140070",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213873872071140070",
						["startPort"] = "Out",
						["endQuest"] = "17213843895871445876",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170834238412926192",
						["startPort"] = "Out",
						["endQuest"] = "17213873254731138042",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213873254731138042",
						["startPort"] = "Out",
						["endQuest"] = "172856829476322846",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1684484789006144",
						["startPort"] = "QuestStart",
						["endQuest"] = "170254047619118993",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213873872071140070",
						["startPort"] = "Out",
						["endQuest"] = "171007752079655007",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172856829476322846",
						["startPort"] = "Out",
						["endQuest"] = "quest_1684484789006146",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "170254047619118993",
						["startPort"] = "Out",
						["endQuest"] = "17447981698954060572",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170254047619118993",
						["startPort"] = "Out",
						["endQuest"] = "17091206117715915",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17447981698954060572",
						["startPort"] = "Out",
						["endQuest"] = "170834238412926192",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_1684484789006144"] = {
						["key"] = "quest_1684484789006144",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -622.9369496676718,
							["y"] = 98.80592915603887
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684484789006146"] = {
						["key"] = "quest_1684484789006146",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1596.6271775929838,
							["y"] = 114.49628811571522
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684484789006148"] = {
						["key"] = "quest_1684484789006148",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1669.4964997402765,
							["y"] = 615.9871567934431
						},
						["propsData"] = {}
					},
					["170254047619118993"] = {
						["key"] = "170254047619118993",
						["type"] = "GoToNode",
						["name"] = "goto冰湖城",
						["pos"] = {
							["x"] = 201.68928999534728,
							["y"] = 117.16773416621515
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190005,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190005"
						}
					},
					["170834238412926192"] = {
						["key"] = "170834238412926192",
						["type"] = "TalkNode",
						["name"] = "挺会演的",
						["pos"] = {
							["x"] = 793.0130369853863,
							["y"] = 134.74504241848823
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10100801,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101008",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
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
							["SkipToOption"] = true,
							["DisableNpcOptimization"] = true,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "P101008Player",
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
									["TalkActorId"] = 200003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17091206117715915"] = {
						["key"] = "17091206117715915",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "停止暂停音乐",
						["pos"] = {
							["x"] = 532.9606336100305,
							["y"] = 23.398541198620222
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["1709192120390178673"] = {
						["key"] = "1709192120390178673",
						["type"] = "SwitchStoryModeNode",
						["name"] = "关闭 剧情模式",
						["pos"] = {
							["x"] = 1451.831493802288,
							["y"] = 368.0788263825193
						},
						["propsData"] = {
							["IsOpen"] = false
						}
					},
					["171007752079655007"] = {
						["key"] = "171007752079655007",
						["type"] = "TalkNode",
						["name"] = "凯文闲置对话",
						["pos"] = {
							["x"] = 719.432888100886,
							["y"] = -294.8243869751143
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 200071,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_101006Kevin_1180129",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10100701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17213843895871445876"] = {
						["key"] = "17213843895871445876",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "卡米拉",
						["pos"] = {
							["x"] = 726.4500062086993,
							["y"] = -149.14227720804723
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190217,
								1190216
							}
						}
					},
					["17213873254731138042"] = {
						["key"] = "17213873254731138042",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 卡米拉",
						["pos"] = {
							["x"] = 1019.7768104029942,
							["y"] = 135.62161116466802
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190217,
								1190216
							}
						}
					},
					["17213873872071140070"] = {
						["key"] = "17213873872071140070",
						["type"] = "GoToRegionNode",
						["name"] = "位于冰湖",
						["pos"] = {
							["x"] = 273.00932788551154,
							["y"] = -164.259507716451
						},
						["propsData"] = {
							["RegionType"] = 2,
							["IsEnter"] = "Enter",
							["RegionId"] = 1011,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["172856829476322846"] = {
						["key"] = "172856829476322846",
						["type"] = "SendMessageNode",
						["name"] = "发送消息，飞艇开始移动",
						["pos"] = {
							["x"] = 1266.6580276448697,
							["y"] = 133.44630515683173
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "FeitingSartFromBeginning",
							["UnitId"] = -1
						}
					},
					["17447981698954060572"] = {
						["key"] = "17447981698954060572",
						["type"] = "TalkNode",
						["name"] = "冰湖城区域介绍",
						["pos"] = {
							["x"] = 549.0500000000001,
							["y"] = 150.20000000000002
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "LevelSequence'/Game/AssetDesign/Story/Sequence/Chapter01/IceLakeCity/IcelakecityIntro.IcelakecityIntro'",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = false,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = false,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = true,
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
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["story_1686038892767184"] = {
			["isStoryNode"] = true,
			["key"] = "story_1686038892767184",
			["type"] = "StoryNode",
			["name"] = "前往据点任务",
			["pos"] = {
				["x"] = -234.92566404374418,
				["y"] = 507.0541189695649
			},
			["propsData"] = {
				["QuestId"] = 10020108,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020108",
				["QuestDeatil"] = "QuestDesc_10020108",
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
						["startQuest"] = "quest_1684740269641208",
						["startPort"] = "QuestStart",
						["endQuest"] = "170671881011422265",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170671881011422265",
						["startPort"] = "Out",
						["endQuest"] = "1702467858089109691",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "171202779175836602",
						["startPort"] = "Out",
						["endQuest"] = "171202779175836601",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1684740269641208",
						["startPort"] = "QuestStart",
						["endQuest"] = "171202779175836602",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1686301633811268",
						["startPort"] = "Out",
						["endQuest"] = "17371907810807876328",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1684740269641208",
						["startPort"] = "QuestStart",
						["endQuest"] = "quest_1686301633811268",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17371907810807876328",
						["startPort"] = "Out",
						["endQuest"] = "17633474132753416",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17633474132753416",
						["startPort"] = "Out",
						["endQuest"] = "quest_1684740269641210",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["quest_1684740269641208"] = {
						["key"] = "quest_1684740269641208",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -421.05303055013826,
							["y"] = 128.90002706888455
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684740269641210"] = {
						["key"] = "quest_1684740269641210",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1039.4350934517693,
							["y"] = 116.64860695129424
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684740269641212"] = {
						["key"] = "quest_1684740269641212",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 818.2787627582159,
							["y"] = 628.6852427923486
						},
						["propsData"] = {}
					},
					["quest_1686301633811268"] = {
						["key"] = "quest_1686301633811268",
						["type"] = "GoToRegionNode",
						["name"] = "进入据点",
						["pos"] = {
							["x"] = 202.8369313847098,
							["y"] = 125.55004066455106
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_HomeBase"
						}
					},
					["1702467858089109691"] = {
						["key"] = "1702467858089109691",
						["type"] = "TalkNode",
						["name"] = "就是这里。",
						["pos"] = {
							["x"] = 458.9700716344296,
							["y"] = 399.64071941301916
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101502,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["170671881011422265"] = {
						["key"] = "170671881011422265",
						["type"] = "GoToNode",
						["name"] = "前往据点",
						["pos"] = {
							["x"] = 203.30121982979318,
							["y"] = 411.92814326323764
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 1190035,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190035"
						}
					},
					["171202779175836601"] = {
						["key"] = "171202779175836601",
						["type"] = "TalkNode",
						["name"] = "跟我走吧",
						["pos"] = {
							["x"] = 462.22809556469207,
							["y"] = 250.68292155627447
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["171202779175836602"] = {
						["key"] = "171202779175836602",
						["type"] = "GoToNode",
						["name"] = "前往疗养院门口",
						["pos"] = {
							["x"] = 209.22643494809654,
							["y"] = 260.2364133953152
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 1190433,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190433"
						}
					},
					["17371907810807876328"] = {
						["key"] = "17371907810807876328",
						["type"] = "TalkNode",
						["name"] = "来到据点",
						["pos"] = {
							["x"] = 463.4675324675325,
							["y"] = 104.19480519480516
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101601,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_101016",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0.5,
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
									["TalkActorId"] = 200006,
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
					["17633474132753416"] = {
						["key"] = "17633474132753416",
						["type"] = "ShowTaskFullfillPopupUINode",
						["name"] = "显示提前完成任务选择弹窗",
						["pos"] = {
							["x"] = 766.1334586466165,
							["y"] = 98.87593984962403
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["story_1686038892768203"] = {
			["isStoryNode"] = true,
			["key"] = "story_1686038892768203",
			["type"] = "StoryNode",
			["name"] = "尝试入住疗养院",
			["pos"] = {
				["x"] = 501.05426382040207,
				["y"] = 298.05566372877064
			},
			["propsData"] = {
				["QuestId"] = 10020107,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020107",
				["QuestDeatil"] = "QuestDesc_10020107",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
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
						["startQuest"] = "170912107815515005",
						["startPort"] = "Out",
						["endQuest"] = "17183617823851584722",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17371907445847875041",
						["startPort"] = "Out",
						["endQuest"] = "17371907445847875040",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17371907445847875043",
						["startPort"] = "Out",
						["endQuest"] = "quest_1684738049605174",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17183617823851584722",
						["startPort"] = "Out",
						["endQuest"] = "17371907445847875041",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1684738049605172",
						["startPort"] = "QuestStart",
						["endQuest"] = "17376146656552001172",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17376146656552001172",
						["startPort"] = "Out",
						["endQuest"] = "170912107815515005",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17539487699443086",
						["startPort"] = "Out",
						["endQuest"] = "17539487699443084",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17371907445847875040",
						["startPort"] = "Out",
						["endQuest"] = "17539487699443086",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17539487699443086",
						["startPort"] = "Out",
						["endQuest"] = "17539487864263552",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17539487864263552",
						["startPort"] = "Out",
						["endQuest"] = "17539487699443085",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17539487699443084",
						["startPort"] = "Out",
						["endQuest"] = "1702467755460105566",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1702467755460105566",
						["startPort"] = "Out",
						["endQuest"] = "17371907445847875043",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_1684738049605172"] = {
						["key"] = "quest_1684738049605172",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -592.129945360463,
							["y"] = 129.81345164761473
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684738049605174"] = {
						["key"] = "quest_1684738049605174",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2159.2229874354425,
							["y"] = 204.3631511927554
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684738049605176"] = {
						["key"] = "quest_1684738049605176",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 709.2516333201804,
							["y"] = 398.73643206690735
						},
						["propsData"] = {}
					},
					["1702467755460105566"] = {
						["key"] = "1702467755460105566",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "设置玩家位置",
						["pos"] = {
							["x"] = 1571.0524219466188,
							["y"] = 185.48164446563797
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_Sana",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["170912107815515005"] = {
						["key"] = "170912107815515005",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放疗养院剧情音乐",
						["pos"] = {
							["x"] = 35.632674413561126,
							["y"] = 173.36847520552817
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0020_story_sanatorium.0020_story_sanatorium'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17183617823851584722"] = {
						["key"] = "17183617823851584722",
						["type"] = "TalkNode",
						["name"] = "小白敲门",
						["pos"] = {
							["x"] = 309.79335840704607,
							["y"] = 163.16528698228538
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC012/SQ_OBT0101_SC012",
							["BlendInTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
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
					["17371907445847875040"] = {
						["key"] = "17371907445847875040",
						["type"] = "TalkNode",
						["name"] = "赛琪摔倒",
						["pos"] = {
							["x"] = 809.1010007080309,
							["y"] = 178.05777204107497
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC013/SQ_OBT0101_SC013",
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
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
					["17371907445847875041"] = {
						["key"] = "17371907445847875041",
						["type"] = "TalkNode",
						["name"] = "【印象对话】女主敲门",
						["pos"] = {
							["x"] = 552.6581459976076,
							["y"] = 168.73346054178097
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101201,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_101012",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
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
									["TalkActorId"] = 200005,
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
					["17371907445847875043"] = {
						["key"] = "17371907445847875043",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "站桩bgm停止播放",
						["pos"] = {
							["x"] = 1845.1807428912819,
							["y"] = 194.24546666128415
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17376146656552001172"] = {
						["key"] = "17376146656552001172",
						["type"] = "GoToRegionNode",
						["name"] = "位于冰湖城",
						["pos"] = {
							["x"] = -210.29984887777783,
							["y"] = 162.88791115505893
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_QuestTrigger_1190006"
						}
					},
					["17447950663152438603"] = {
						["key"] = "17447950663152438603",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = -175.93609022556387,
							["y"] = 1166
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17539487699443084"] = {
						["key"] = "17539487699443084",
						["type"] = "TalkNode",
						["name"] = "赛琪求情",
						["pos"] = {
							["x"] = 1309.370760233918,
							["y"] = 183.34006242930735
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101409,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101014_2",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
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
									["TalkActorId"] = 200005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200006,
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
					["17539487699443085"] = {
						["key"] = "17539487699443085",
						["type"] = "SendMessageNode",
						["name"] = "开门",
						["pos"] = {
							["x"] = 1316.0432611629406,
							["y"] = -100.9179864059156
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_SanDoorOpen",
							["UnitId"] = -1
						}
					},
					["17539487699443086"] = {
						["key"] = "17539487699443086",
						["type"] = "TalkNode",
						["name"] = "赛琪求情",
						["pos"] = {
							["x"] = 1053.1929824561403,
							["y"] = 189.69561798486296
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101014",
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
									["TalkActorId"] = 200005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200006,
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
					["17539487864263552"] = {
						["key"] = "17539487864263552",
						["type"] = "WaitOfTimeNode",
						["name"] = "2",
						["pos"] = {
							["x"] = 1317.864777327935,
							["y"] = 39.95996963562749
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1698223105447183661"] = {
			["isStoryNode"] = true,
			["key"] = "1698223105447183661",
			["type"] = "StoryNode",
			["name"] = "离开据点",
			["pos"] = {
				["x"] = 526.4610419925905,
				["y"] = 514.4908646413448
			},
			["propsData"] = {
				["QuestId"] = 10020112,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020112",
				["QuestDeatil"] = "QuestDesc_10020112",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "quest_1687156767983846",
						["startPort"] = "Out",
						["endQuest"] = "quest_1685693722432185",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "quest_1685693722432183",
						["startPort"] = "QuestStart",
						["endQuest"] = "171202802585746532",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "171202802585746532",
						["startPort"] = "Out",
						["endQuest"] = "1702468811982132975",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1685693722432183",
						["startPort"] = "QuestStart",
						["endQuest"] = "quest_1687156767983846",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_1685693722432183"] = {
						["key"] = "quest_1685693722432183",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -220,
							["y"] = 124.28571428571428
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1685693722432185"] = {
						["key"] = "quest_1685693722432185",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1025.6206896551723,
							["y"] = 145.9655172413793
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1685693722432187"] = {
						["key"] = "quest_1685693722432187",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1025.103448275862,
							["y"] = 281.0344827586208
						},
						["propsData"] = {}
					},
					["quest_1687156767983846"] = {
						["key"] = "quest_1687156767983846",
						["type"] = "GoToRegionNode",
						["name"] = "等待玩家离开据点",
						["pos"] = {
							["x"] = 400.65359477124184,
							["y"] = 141
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Leave",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_HomeBase"
						}
					},
					["quest_1693205867709603"] = {
						["key"] = "quest_1693205867709603",
						["type"] = "TalkNode",
						["name"] = "100279白也来带路",
						["pos"] = {
							["x"] = 1884.2939257493495,
							["y"] = 189.00254741391763
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10027901,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = true,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["quest_1693205869241606"] = {
						["key"] = "quest_1693205869241606",
						["type"] = "TalkNode",
						["name"] = "100279白也来带路",
						["pos"] = {
							["x"] = 1884.2939257493495,
							["y"] = 189.00254741391763
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10027901,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = true,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1702468811982132975"] = {
						["key"] = "1702468811982132975",
						["type"] = "TalkNode",
						["name"] = "找卡米拉",
						["pos"] = {
							["x"] = 670.8885604299866,
							["y"] = 278.6903214822725
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10102001,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["171202802585746532"] = {
						["key"] = "171202802585746532",
						["type"] = "GoToRegionNode",
						["name"] = "等待玩家位于据点",
						["pos"] = {
							["x"] = 402.8596112360797,
							["y"] = 290.1484697243491
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174481273878012523120"] = {
						["key"] = "174481273878012523120",
						["type"] = "CheckBranchQuestFinishedNode",
						["name"] = "子任务结束节点",
						["pos"] = {
							["x"] = 399.39130434782606,
							["y"] = -34.78260869565217
						},
						["propsData"] = {
							["InputBranchQuestNumber"] = 2,
							["BranchQuestFinishOptions"] = {
								{
									["IsNeedFinish"] = false
								},
								{
									["IsNeedFinish"] = false
								}
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["170246689171376464"] = {
			["isStoryNode"] = true,
			["key"] = "170246689171376464",
			["type"] = "StoryNode",
			["name"] = "前往疗养院",
			["pos"] = {
				["x"] = 241.57374316879094,
				["y"] = 300.2828651488892
			},
			["propsData"] = {
				["QuestId"] = 10020106,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020106",
				["QuestDeatil"] = "QuestDesc_10020106",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "170246715368284670",
						["startPort"] = "Out",
						["endQuest"] = "quest_1684737305341154",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "170246726533988523",
						["startPort"] = "Out",
						["endQuest"] = "170246723929087021",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1684737305341152",
						["startPort"] = "QuestStart",
						["endQuest"] = "17071867608539145",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17071867608539145",
						["startPort"] = "Out",
						["endQuest"] = "170246726533988523",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1684737305341152",
						["startPort"] = "QuestStart",
						["endQuest"] = "171202756451529299",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "171202756451529299",
						["startPort"] = "Out",
						["endQuest"] = "170246730444990737",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1684737305341152",
						["startPort"] = "QuestStart",
						["endQuest"] = "17398646861203850674",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17398646861203850674",
						["startPort"] = "Out",
						["endQuest"] = "17398647812893851183",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17398647812893851183",
						["startPort"] = "Out",
						["endQuest"] = "170246715368284670",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17398646861203850674",
						["startPort"] = "Out",
						["endQuest"] = "17590403597883277",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_1684737305341152"] = {
						["key"] = "quest_1684737305341152",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -499.8009169884171,
							["y"] = 306.9775579150578
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684737305341154"] = {
						["key"] = "quest_1684737305341154",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 532.2149526149527,
							["y"] = 461.5328887328885
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1684737305341156"] = {
						["key"] = "quest_1684737305341156",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 509.72776412776415,
							["y"] = 609.408845208845
						},
						["propsData"] = {}
					},
					["quest_1690875407648311"] = {
						["key"] = "quest_1690875407648311",
						["type"] = "SendMessageNode",
						["name"] = "发送消息，桥四周加空气墙",
						["pos"] = {
							["x"] = -578.1757920337657,
							["y"] = 586.154799102548
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_Trafficway_AirWallOn",
							["UnitId"] = -1
						}
					},
					["quest_1690875409454314"] = {
						["key"] = "quest_1690875409454314",
						["type"] = "SendMessageNode",
						["name"] = "发送消息，桥四周加空气墙",
						["pos"] = {
							["x"] = -578.1757920337657,
							["y"] = 586.154799102548
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_Trafficway_AirWallOn",
							["UnitId"] = -1
						}
					},
					["170246715368284670"] = {
						["key"] = "170246715368284670",
						["type"] = "GoToNode",
						["name"] = "前往疗养院门口",
						["pos"] = {
							["x"] = 291.6160860873063,
							["y"] = 463.35309869396417
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190006,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190006"
						}
					},
					["170246723929087021"] = {
						["key"] = "170246723929087021",
						["type"] = "TalkNode",
						["name"] = "鬼宅",
						["pos"] = {
							["x"] = 647.9370251559129,
							["y"] = 71.19175078555756
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10100901,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["170246726533988523"] = {
						["key"] = "170246726533988523",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 378.0655452844329,
							["y"] = 82.76990236370938
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["170246730444990737"] = {
						["key"] = "170246730444990737",
						["type"] = "TalkNode",
						["name"] = "到啦",
						["pos"] = {
							["x"] = 393.0965905742289,
							["y"] = 279.06031664924734
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101001,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17071867608539145"] = {
						["key"] = "17071867608539145",
						["type"] = "GoToRegionNode",
						["name"] = "位于冰湖城",
						["pos"] = {
							["x"] = 116.23628228542026,
							["y"] = 80.94189155747937
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["171202756451529299"] = {
						["key"] = "171202756451529299",
						["type"] = "GoToNode",
						["name"] = "前往疗养院外围",
						["pos"] = {
							["x"] = 116.17316287987684,
							["y"] = 289.5184480797503
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 1190433,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190433"
						}
					},
					["17398646861203850674"] = {
						["key"] = "17398646861203850674",
						["type"] = "GoToNode",
						["name"] = "前往城中央",
						["pos"] = {
							["x"] = -214.57142857142873,
							["y"] = 451.42857142857144
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191096,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1191096"
						}
					},
					["17398647812893851183"] = {
						["key"] = "17398647812893851183",
						["type"] = "GoToNode",
						["name"] = "前往台阶处",
						["pos"] = {
							["x"] = 28.142857142856883,
							["y"] = 458.57142857142867
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191097,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1191097"
						}
					},
					["17590403597883277"] = {
						["key"] = "17590403597883277",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = -5.672016369957916,
							["y"] = 672.7652453271427
						},
						["propsData"] = {
							["GuideId"] = 88
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1702468354501121387"] = {
			["isStoryNode"] = true,
			["key"] = "1702468354501121387",
			["type"] = "StoryNode",
			["name"] = "等待赛琪",
			["pos"] = {
				["x"] = 271.4231100619203,
				["y"] = 514.0721666611764
			},
			["propsData"] = {
				["QuestId"] = 10020111,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020111",
				["QuestDeatil"] = "QuestDesc_10020111",
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
						["startQuest"] = "170470337817922429",
						["startPort"] = "Out",
						["endQuest"] = "170470337817922430",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170470337817922428",
						["startPort"] = "Out",
						["endQuest"] = "170470337817922429",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170470337817922430",
						["startPort"] = "Out",
						["endQuest"] = "170531431221546972",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "quest_1694341918841472",
						["startPort"] = "QuestStart",
						["endQuest"] = "170462275881015715",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174481269750512522270",
						["startPort"] = "Out",
						["endQuest"] = "174481269750512522273",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174481269750512522272",
						["startPort"] = "Out",
						["endQuest"] = "174481269750512522270",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174481269750512522269",
						["startPort"] = "Out",
						["endQuest"] = "174481269750512522274",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174481269750512522274",
						["startPort"] = "Out",
						["endQuest"] = "174481269750512522275",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174481269750512522275",
						["startPort"] = "Out",
						["endQuest"] = "174481269750512522276",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170462275881015715",
						["startPort"] = "Out",
						["endQuest"] = "174481269750512522269",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17508217490186618",
						["startPort"] = "Out",
						["endQuest"] = "170470337817922428",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17526614109613271",
						["startPort"] = "Out",
						["endQuest"] = "17508217490186618",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170531431221546972",
						["startPort"] = "Out",
						["endQuest"] = "17526614376174163",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170462275881015715",
						["startPort"] = "Out",
						["endQuest"] = "17526614109613271",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17526614376174163",
						["startPort"] = "Out",
						["endQuest"] = "quest_1694341918841474",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174481269750512522276",
						["startPort"] = "Out",
						["endQuest"] = "174481269750512522271",
						["endPort"] = "Branch_1"
					}
				},
				["nodeData"] = {
					["quest_1694341918841472"] = {
						["key"] = "quest_1694341918841472",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -682.3200175272754,
							["y"] = 184.96470469494668
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1694341918841474"] = {
						["key"] = "quest_1694341918841474",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1493.2933275094313,
							["y"] = 360.7707998330138
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_1694341918841476"] = {
						["key"] = "quest_1694341918841476",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1609.1337242562931,
							["y"] = 847.1257151029748
						},
						["propsData"] = {}
					},
					["170462275881015715"] = {
						["key"] = "170462275881015715",
						["type"] = "GoToRegionNode",
						["name"] = "等待玩家位于据点",
						["pos"] = {
							["x"] = -377.5111745496217,
							["y"] = 188.8148327268545
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_HomeBase"
						}
					},
					["170470337817922428"] = {
						["key"] = "170470337817922428",
						["type"] = "TalkNode",
						["name"] = "思考",
						["pos"] = {
							["x"] = 484.6633963862221,
							["y"] = 201.01976284584964
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101017",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
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
							["DisableNpcOptimization"] = true,
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
									["TalkActorId"] = 100001,
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
					["170470337817922429"] = {
						["key"] = "170470337817922429",
						["type"] = "TalkNode",
						["name"] = "吃面包",
						["pos"] = {
							["x"] = 782.3326510446071,
							["y"] = 205.2753704316671
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101802,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101018",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
							["DisableNpcOptimization"] = true,
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
									["TalkActorId"] = 100003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
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
					["170470337817922430"] = {
						["key"] = "170470337817922430",
						["type"] = "TalkNode",
						["name"] = "吃面包",
						["pos"] = {
							["x"] = 603.2190146809708,
							["y"] = 409.73842461885926
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101805,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101018",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
							["DisableNpcOptimization"] = true,
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200006,
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
					["170531431221546972"] = {
						["key"] = "170531431221546972",
						["type"] = "TalkNode",
						["name"] = "请求委托",
						["pos"] = {
							["x"] = 902.7956844222213,
							["y"] = 405.9316845858692
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10101901,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101019",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0.5,
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
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = true,
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
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200006,
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
					["174481269750512522269"] = {
						["key"] = "174481269750512522269",
						["type"] = "BranchQuestStartNode",
						["name"] = "子任务开始节点",
						["pos"] = {
							["x"] = 29.25162264635935,
							["y"] = 667.3179437654146
						},
						["propsData"] = {
							["AllQuestOptions"] = {
								{
									["IsNeedFinish"] = true,
									["BranchQuestName"] = "QuestName_10020110_2",
									["TargetBranchQuestKey"] = ""
								}
							},
							["IsSetCountInfo"] = false,
							["IsDifftation"] = false,
							["AllDiffGuideOptions"] = {
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "174481269750512522274",
											["IsShowOptional"] = true
										}
									}
								}
							}
						}
					},
					["174481269750512522270"] = {
						["key"] = "174481269750512522270",
						["type"] = "WaitingCompleteSysGuideNode",
						["name"] = "等待完成指引",
						["pos"] = {
							["x"] = 649.3022941970312,
							["y"] = 870.6103735578442
						},
						["propsData"] = {
							["SystemGuideId"] = 2019
						}
					},
					["174481269750512522271"] = {
						["key"] = "174481269750512522271",
						["type"] = "CheckBranchQuestFinishedNode",
						["name"] = "子任务结束节点",
						["pos"] = {
							["x"] = 1236.0115352483774,
							["y"] = 646.4322359060225
						},
						["propsData"] = {
							["InputBranchQuestNumber"] = 1,
							["BranchQuestFinishOptions"] = {
								{
									["IsNeedFinish"] = true
								}
							}
						}
					},
					["174481269750512522272"] = {
						["key"] = "174481269750512522272",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 291.66070857958397,
							["y"] = 842.0859535334247
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Point_TrainingGround"
						}
					},
					["174481269750512522273"] = {
						["key"] = "174481269750512522273",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 915.4793393740767,
							["y"] = 858.8893723368435
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Point_TrainingGround"
						}
					},
					["174481269750512522274"] = {
						["key"] = "174481269750512522274",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 332.67557352442304,
							["y"] = 629.8261343786635
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_Bai_Shangdian"
						}
					},
					["174481269750512522275"] = {
						["key"] = "174481269750512522275",
						["type"] = "WaitingCompleteSysGuideNode",
						["name"] = "等待完成指引",
						["pos"] = {
							["x"] = 596.861445698226,
							["y"] = 645.6118486643777
						},
						["propsData"] = {
							["SystemGuideId"] = 2026
						}
					},
					["174481269750512522276"] = {
						["key"] = "174481269750512522276",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 874.6308095686027,
							["y"] = 648.3975629500919
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Npc_Bai_Shangdian"
						}
					},
					["17508217490186618"] = {
						["key"] = "17508217490186618",
						["type"] = "GoToNode",
						["name"] = "走到沙发旁边",
						["pos"] = {
							["x"] = 203.00182283275734,
							["y"] = 194.26781881105492
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 1210121,
							["GuideType"] = "P",
							["GuidePointName"] = "P_1210121"
						}
					},
					["17526614109613271"] = {
						["key"] = "17526614109613271",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = -69.99999999999994,
							["y"] = 205.58928571428578
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P_1210121"
						}
					},
					["17526614376174163"] = {
						["key"] = "17526614376174163",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1203.4285714285713,
							["y"] = 412.44642857142856
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P_1210121"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["170417835022081449"] = {
			["isStoryNode"] = true,
			["key"] = "170417835022081449",
			["type"] = "StoryNode",
			["name"] = "继续前往检查站",
			["pos"] = {
				["x"] = 523.9998285433276,
				["y"] = 116.12505757737068
			},
			["propsData"] = {
				["QuestId"] = 10020104,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020104",
				["QuestDeatil"] = "QuestDesc_10020104",
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
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "QuestPoint_10020106",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "170417835022081457",
						["startPort"] = "Out",
						["endQuest"] = "170442487854032790",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170442487854032790",
						["startPort"] = "Out",
						["endQuest"] = "170417835022081461",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170417835022081461",
						["startPort"] = "Out",
						["endQuest"] = "170417835022081456",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170417835022081465",
						["startPort"] = "Out",
						["endQuest"] = "17235567657274772184",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17235567657274772184",
						["startPort"] = "Out",
						["endQuest"] = "172130558266014436",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170417835022081460",
						["startPort"] = "Out",
						["endQuest"] = "170417835022081463",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172130558266014436",
						["startPort"] = "Out",
						["endQuest"] = "17371906267116889224",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17371906267116889224",
						["startPort"] = "Out",
						["endQuest"] = "170417835022081454",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "170417835022081453",
						["startPort"] = "QuestStart",
						["endQuest"] = "170417835022081466",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170417835022081465",
						["startPort"] = "Out",
						["endQuest"] = "1744793016659816311",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170417835022081453",
						["startPort"] = "QuestStart",
						["endQuest"] = "17524906666656100883",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17524906666656100883",
						["startPort"] = "Out",
						["endQuest"] = "17524907281546101120",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170417835022081466",
						["startPort"] = "Out",
						["endQuest"] = "17561930523131911456",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17561930523131911456",
						["startPort"] = "Out",
						["endQuest"] = "170417835022081469",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17561930523131911456",
						["startPort"] = "Out",
						["endQuest"] = "170417835022081460",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17561930523131911456",
						["startPort"] = "Out",
						["endQuest"] = "170417835022081465",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17561930523131911456",
						["startPort"] = "Out",
						["endQuest"] = "173927153424115963634",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17561930523131911456",
						["startPort"] = "Out",
						["endQuest"] = "17392623705608876344",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["170417835022081453"] = {
						["key"] = "170417835022081453",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -974.4666370584061,
							["y"] = 138.78959256044905
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["170417835022081454"] = {
						["key"] = "170417835022081454",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1487.530760396361,
							["y"] = 483.34866684219156
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["170417835022081455"] = {
						["key"] = "170417835022081455",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 932.4241998077612,
							["y"] = 840.4685628277869
						},
						["propsData"] = {}
					},
					["170417835022081456"] = {
						["key"] = "170417835022081456",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,让白上公路",
						["pos"] = {
							["x"] = 1202.0884652477946,
							["y"] = -106.0286664123421
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "BaiGo",
							["UnitId"] = 200002
						}
					},
					["170417835022081457"] = {
						["key"] = "170417835022081457",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成小白",
						["pos"] = {
							["x"] = 195.14826242665956,
							["y"] = -107.78728474183403
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180151
							}
						}
					},
					["170417835022081460"] = {
						["key"] = "170417835022081460",
						["type"] = "GoToNode",
						["name"] = "goto检查站前",
						["pos"] = {
							["x"] = 200.99579406922106,
							["y"] = 270.2113523791327
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 1180034,
							["GuideType"] = "P",
							["GuidePointName"] = "TargetPoint_1180034"
						}
					},
					["170417835022081461"] = {
						["key"] = "170417835022081461",
						["type"] = "SetNpcPatrolNode",
						["name"] = "设置小白的巡逻点",
						["pos"] = {
							["x"] = 914.7829950480026,
							["y"] = -103.67240755655898
						},
						["propsData"] = {
							["NpcId"] = 200002,
							["PatrolId"] = 1003
						}
					},
					["170417835022081463"] = {
						["key"] = "170417835022081463",
						["type"] = "TalkNode",
						["name"] = "快到检查站",
						["pos"] = {
							["x"] = 519.807479217567,
							["y"] = 314.73618596805386
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10100501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["170417835022081465"] = {
						["key"] = "170417835022081465",
						["type"] = "GoToNode",
						["name"] = "goto检查站",
						["pos"] = {
							["x"] = 203.18504781265455,
							["y"] = 474.9744481785671
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1180130,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1180130"
						}
					},
					["170417835022081466"] = {
						["key"] = "170417835022081466",
						["type"] = "GoToRegionNode",
						["name"] = "wait  for 公路",
						["pos"] = {
							["x"] = -569.2465890648139,
							["y"] = 73.43943064999351
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_10020106"
						}
					},
					["170417835022081467"] = {
						["key"] = "170417835022081467",
						["type"] = "SetNpcPatrolNode",
						["name"] = "设置卡米拉巡逻点",
						["pos"] = {
							["x"] = 1378.0433458194475,
							["y"] = -484.9636027580875
						},
						["propsData"] = {
							["NpcId"] = 200003,
							["PatrolId"] = 1004
						}
					},
					["170417835022081468"] = {
						["key"] = "170417835022081468",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,让卡米拉上公路",
						["pos"] = {
							["x"] = 1376.654690256209,
							["y"] = -378.86838507313894
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "KamiGo",
							["UnitId"] = 200003
						}
					},
					["170417835022081469"] = {
						["key"] = "170417835022081469",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "设置玩家位置旋转",
						["pos"] = {
							["x"] = 151.2241953708433,
							["y"] = -671.7035044654838
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TargetPoint_IcelakeCity_Connect",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["170442487854032790"] = {
						["key"] = "170442487854032790",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 605.078082158793,
							["y"] = -102.58759623924081
						},
						["propsData"] = {
							["WaitTime"] = 0.1
						}
					},
					["172130558266014435"] = {
						["key"] = "172130558266014435",
						["type"] = "TalkNode",
						["name"] = "卫兵拦住",
						["pos"] = {
							["x"] = 1470.8173556389186,
							["y"] = 257.06622943136404
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10100601,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101006",
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
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200004,
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
					["172130558266014436"] = {
						["key"] = "172130558266014436",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "播放暂停音乐",
						["pos"] = {
							["x"] = 804.9523051926132,
							["y"] = 495.89464472608665
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17235567657274772184"] = {
						["key"] = "17235567657274772184",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁小白和终点的卡米拉",
						["pos"] = {
							["x"] = 517.4059814683446,
							["y"] = 493.77810185471515
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180151,
								1180128
							}
						}
					},
					["17371906267116889224"] = {
						["key"] = "17371906267116889224",
						["type"] = "TalkNode",
						["name"] = "卫兵拦住",
						["pos"] = {
							["x"] = 1141.1363636363637,
							["y"] = 472.28715728715713
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10100601,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_101006",
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
							["DisableNpcOptimization"] = true,
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
									["TalkActorId"] = 200003,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200071,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17392623705608876344"] = {
						["key"] = "17392623705608876344",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成凯文",
						["pos"] = {
							["x"] = 193.04545454545462,
							["y"] = -226.551948051948
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180129
							}
						}
					},
					["173927153424115963634"] = {
						["key"] = "173927153424115963634",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成终点的卡米拉",
						["pos"] = {
							["x"] = 191.875,
							["y"] = -354.2499999999999
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1180128
							}
						}
					},
					["17447928498323984"] = {
						["key"] = "17447928498323984",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "小白指引点",
						["pos"] = {
							["x"] = 124.20179820179789,
							["y"] = 40.65934065934047
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "200002"
						}
					},
					["1744792990588815651"] = {
						["key"] = "1744792990588815651",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "目标点指引点",
						["pos"] = {
							["x"] = 329.68131868131843,
							["y"] = 39.89010989010973
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_QuestTrigger_1180130"
						}
					},
					["1744793016659816310"] = {
						["key"] = "1744793016659816310",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "小白指引点",
						["pos"] = {
							["x"] = 294.37912087912053,
							["y"] = 1128.1593406593406
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "N",
							["GuideName"] = "200002"
						}
					},
					["1744793016659816311"] = {
						["key"] = "1744793016659816311",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "目标点指引点",
						["pos"] = {
							["x"] = 495.2582417582415,
							["y"] = 648.543956043956
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_QuestTrigger_1180130"
						}
					},
					["17524906666656100883"] = {
						["key"] = "17524906666656100883",
						["type"] = "GoToRegionNode",
						["name"] = "进入冰湖城",
						["pos"] = {
							["x"] = 366.1353383458642,
							["y"] = 823.5639097744361
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17524907281546101120"] = {
						["key"] = "17524907281546101120",
						["type"] = "TalkNode",
						["name"] = "这就是城市吗",
						["pos"] = {
							["x"] = 635.4732693803471,
							["y"] = 824.3363235675396
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10120601,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17527478434325140549"] = {
						["key"] = "17527478434325140549",
						["type"] = "WaitOfTimeNode",
						["name"] = "0.1S",
						["pos"] = {
							["x"] = -400.00439560439577,
							["y"] = -310.2351648351648
						},
						["propsData"] = {
							["WaitTime"] = 0.1
						}
					},
					["17561930523131911456"] = {
						["key"] = "17561930523131911456",
						["type"] = "TalkNode",
						["name"] = "冰湖城背景",
						["pos"] = {
							["x"] = -263.01459672938097,
							["y"] = 88.10133365086965
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10100401,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_101004",
							["BlendInTime"] = 0.5,
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
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = true,
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
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}