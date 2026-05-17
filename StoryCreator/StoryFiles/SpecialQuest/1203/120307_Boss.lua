return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17724342457474749946",
			["startPort"] = "StoryStart",
			["endStory"] = "17724342599234750406",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17724342599234750406",
			["startPort"] = "Success",
			["endStory"] = "17724342457474749949",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17724342457474749946"] = {
			["isStoryNode"] = true,
			["key"] = "17724342457474749946",
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
		["17724342457474749949"] = {
			["isStoryNode"] = true,
			["key"] = "17724342457474749949",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1401.8636363636365,
				["y"] = 296.54545454545456
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17724342599234750406"] = {
			["isStoryNode"] = true,
			["key"] = "17724342599234750406",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1121.3748198093467,
				["y"] = 271.14938967681957
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
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 105901,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17724344680625541497",
						["startPort"] = "Out",
						["endQuest"] = "17724344680625541498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724342599234750407",
						["startPort"] = "QuestStart",
						["endQuest"] = "17724345157565542573",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724345157565542573",
						["startPort"] = "Out",
						["endQuest"] = "17724342599234750413",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17724342599234750407",
						["startPort"] = "QuestStart",
						["endQuest"] = "177243571895212661688",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177243571895212661688",
						["startPort"] = "Out",
						["endQuest"] = "17724345355635542958",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177243571895212661688",
						["startPort"] = "Out",
						["endQuest"] = "17724344680625541497",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772518991877563",
						["startPort"] = "Out",
						["endQuest"] = "17724344171765541343",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177243571895212661688",
						["startPort"] = "Out",
						["endQuest"] = "17727066414131488",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727067132822627",
						["startPort"] = "Out",
						["endQuest"] = "17727067132822628",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727067132822628",
						["startPort"] = "Out",
						["endQuest"] = "1772518991877563",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724344680625541498",
						["startPort"] = "Out",
						["endQuest"] = "17727067717123772",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727067717123772",
						["startPort"] = "Out",
						["endQuest"] = "17727067132822627",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727067717123772",
						["startPort"] = "Out",
						["endQuest"] = "17727066748822141",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724342599234750407",
						["startPort"] = "QuestStart",
						["endQuest"] = "177243576210813454455",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17724342599234750407"] = {
						["key"] = "17724342599234750407",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 522.9043478260869,
							["y"] = 292.8
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105901,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17724342599234750410"] = {
						["key"] = "17724342599234750410",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2434.9230769230767,
							["y"] = 487.76923076923083
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17724342599234750413"] = {
						["key"] = "17724342599234750413",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1206.0064837711018,
							["y"] = 791.0484043692439
						},
						["propsData"] = {}
					},
					["17724344171765541343"] = {
						["key"] = "17724344171765541343",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2935.752437557905,
							["y"] = 268.4270057302045
						},
						["propsData"] = {}
					},
					["17724344680625541497"] = {
						["key"] = "17724344680625541497",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战开始",
						["pos"] = {
							["x"] = 1159.4670541873907,
							["y"] = 269.71022742394393
						},
						["propsData"] = {
							["SendMessage"] = "BossBattle01",
							["FinishCondition"] = ""
						}
					},
					["17724344680625541498"] = {
						["key"] = "17724344680625541498",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战成功",
						["pos"] = {
							["x"] = 1440.3954599947403,
							["y"] = 273.9579804875772
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "BossJuque_StoryEnd"
						}
					},
					["17724345157565542573"] = {
						["key"] = "17724345157565542573",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 846.4188092641988,
							["y"] = 773.6474133063338
						},
						["propsData"] = {}
					},
					["17724345355635542958"] = {
						["key"] = "17724345355635542958",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1198.1514753986642,
							["y"] = 67.24580891372484
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12063315,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["177243563093111868600"] = {
						["key"] = "177243563093111868600",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1675.4945917192917,
							["y"] = 23.516300940438782
						},
						["propsData"] = {
							["QuestRoleId"] = 0,
							["IsPlayFX"] = false
						}
					},
					["177243571895212661688"] = {
						["key"] = "177243571895212661688",
						["type"] = "ChangeRoleNode",
						["name"] = "切换苏乙",
						["pos"] = {
							["x"] = 842.0334033613441,
							["y"] = 292.9569327731091
						},
						["propsData"] = {
							["QuestRoleId"] = 15040103,
							["IsPlayFX"] = false
						}
					},
					["177243576210813454455"] = {
						["key"] = "177243576210813454455",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 852.6520369017167,
							["y"] = 69.86656010230156
						},
						["propsData"] = {
							["IsCreate"] = true,
							["IsClearOtherPhantom"] = true,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								132700009,
								132700010
							}
						}
					},
					["1772518991877563"] = {
						["key"] = "1772518991877563",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2625.613613360324,
							["y"] = 268.2148279352227
						},
						["propsData"] = {
							["VarName"] = "FengxiangBossFinish",
							["VarValue"] = 1
						}
					},
					["17727066414131488"] = {
						["key"] = "17727066414131488",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1163.6021022825607,
							["y"] = 451.5096196373286
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_JuqueBossBattle",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17727066748822141"] = {
						["key"] = "17727066748822141",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2028.05265173311,
							["y"] = 465.5865427142517
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_Juque02BossBattle",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17727067132822627"] = {
						["key"] = "17727067132822627",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战开始",
						["pos"] = {
							["x"] = 2039.7670645685348,
							["y"] = 276.02425663183396
						},
						["propsData"] = {
							["SendMessage"] = "BossBattle02",
							["FinishCondition"] = ""
						}
					},
					["17727067132822628"] = {
						["key"] = "17727067132822628",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战成功",
						["pos"] = {
							["x"] = 2320.6954703758847,
							["y"] = 269.88739431085185
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "BossJuque02_StoryEnd"
						}
					},
					["17727067717123772"] = {
						["key"] = "17727067717123772",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1734.231267472209,
							["y"] = 278.348272105169
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC004/Ver0103_SC004",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
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
							["HideMechanismsFX"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
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