return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1772421504260706948",
			["startPort"] = "StoryStart",
			["endStory"] = "1772421504260706950",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1772421504260706950",
			["startPort"] = "Success",
			["endStory"] = "1772421504260706949",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1772421504260706948"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504260706948",
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
		["1772421504260706949"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504260706949",
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
		["1772421504260706950"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504260706950",
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
						["startQuest"] = "1772421538696793360",
						["startPort"] = "Out",
						["endQuest"] = "1772421504260706953",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1772421504260706951",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772421538696793360",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772421504260706951",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772421556083793742",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772421556083793742",
						["startPort"] = "Out",
						["endQuest"] = "1772460687652805435",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772421556083793745",
						["startPort"] = "Out",
						["endQuest"] = "17724609093953215734",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724609093953215734",
						["startPort"] = "Out",
						["endQuest"] = "1772421530896793262",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772460687652805435",
						["startPort"] = "Out",
						["endQuest"] = "1772714298201754",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772714298201754",
						["startPort"] = "Out",
						["endQuest"] = "17727143779041238",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727143779041238",
						["startPort"] = "Out",
						["endQuest"] = "17727143904401455",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727143904401455",
						["startPort"] = "Out",
						["endQuest"] = "1772421556083793745",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1772421504260706951"] = {
						["key"] = "1772421504260706951",
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
					["1772421504260706952"] = {
						["key"] = "1772421504260706952",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2813.3333333333335,
							["y"] = 155.55555555555554
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1772421504260706953"] = {
						["key"] = "1772421504260706953",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2206.25,
							["y"] = 713.75
						},
						["propsData"] = {}
					},
					["1772421530896793262"] = {
						["key"] = "1772421530896793262",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2727.3349673202615,
							["y"] = 505.5564468211528
						},
						["propsData"] = {}
					},
					["1772421538696793360"] = {
						["key"] = "1772421538696793360",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1795.3930481283423,
							["y"] = 736.8683155080214
						},
						["propsData"] = {}
					},
					["1772421556083793742"] = {
						["key"] = "1772421556083793742",
						["type"] = "ChangeRoleNode",
						["name"] = "切换苏乙",
						["pos"] = {
							["x"] = 1203.0843473775499,
							["y"] = 309.73754064562877
						},
						["propsData"] = {
							["QuestRoleId"] = 15040101,
							["IsPlayFX"] = false
						}
					},
					["1772421556083793745"] = {
						["key"] = "1772421556083793745",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_67】苏乙拦住狴犴，被老头喷",
						["pos"] = {
							["x"] = 2139.483379386308,
							["y"] = 487.4213840015415
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsst'/Game/Dialogue/MainStory/1202/12047101.12047101'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020604",
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
					["1772460687652805435"] = {
						["key"] = "1772460687652805435",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1515.140464274288,
							["y"] = 197.69509977597545
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242010093,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020602_242010093"
						}
					},
					["17724609093953215734"] = {
						["key"] = "17724609093953215734",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2408.6328776899427,
							["y"] = 478.0858311374615
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020603",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1772714298201754"] = {
						["key"] = "1772714298201754",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1805.8863636363637,
							["y"] = 192.99960815047018
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "120206_SuyiMon_Start",
							["UnitId"] = -1
						}
					},
					["17727143779041238"] = {
						["key"] = "17727143779041238",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2088.7020034993466,
							["y"] = 186.13483624464038
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 10,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17727143904401455"] = {
						["key"] = "17727143904401455",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1822.3305749279184,
							["y"] = 508.8124865013604
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "120206_SuyiMon_Over",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}