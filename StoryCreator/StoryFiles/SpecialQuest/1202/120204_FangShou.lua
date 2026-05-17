return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17678537949071014368",
			["startPort"] = "StoryStart",
			["endStory"] = "17678537949071014370",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17678537949071014370",
			["startPort"] = "Success",
			["endStory"] = "17678537949071014369",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17678537949071014368"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949071014368",
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
		["17678537949071014369"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949071014369",
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
		["17678537949071014370"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949071014370",
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
						["startQuest"] = "17678537949071014371",
						["startPort"] = "QuestStart",
						["endQuest"] = "1768803857700490",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17688039119811183",
						["startPort"] = "Out",
						["endQuest"] = "1770210602992298",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770210602992298",
						["startPort"] = "Out",
						["endQuest"] = "1770210609833554",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949071014371",
						["startPort"] = "QuestStart",
						["endQuest"] = "17688039119811183",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768803857700490",
						["startPort"] = "Out",
						["endQuest"] = "17730550603324960138",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17688039119811183",
						["startPort"] = "Out",
						["endQuest"] = "177313156223219123346",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770210609833554",
						["startPort"] = "Out",
						["endQuest"] = "177313210297022502289",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177313210297022502289",
						["startPort"] = "Out",
						["endQuest"] = "1768803794819264",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730550603324960138",
						["startPort"] = "Out",
						["endQuest"] = "177313211204922502578",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177313211204922502578",
						["startPort"] = "Out",
						["endQuest"] = "17678537949071014373",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17678537949071014371",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773300783630851789",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17678537949071014371"] = {
						["key"] = "17678537949071014371",
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
					["17678537949071014372"] = {
						["key"] = "17678537949071014372",
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
					["17678537949071014373"] = {
						["key"] = "17678537949071014373",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2420.5194805194806,
							["y"] = 727.1428571428571
						},
						["propsData"] = {}
					},
					["1768803794819264"] = {
						["key"] = "1768803794819264",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2582.8978127136024,
							["y"] = 304.6838687628161
						},
						["propsData"] = {}
					},
					["1768803857700490"] = {
						["key"] = "1768803857700490",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1536.2203457959013,
							["y"] = 685.7214510982956
						},
						["propsData"] = {}
					},
					["17688039119811183"] = {
						["key"] = "17688039119811183",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1215.6596830748897,
							["y"] = 302.326061340019
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Defense_Start",
							["UnitId"] = -1
						}
					},
					["1770190752480696"] = {
						["key"] = "1770190752480696",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1889.3358542236278,
							["y"] = -26.98837503884272
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020402fangshou_Start",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1770210602992298"] = {
						["key"] = "1770210602992298",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1910.8938969527205,
							["y"] = 289.87462863933456
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 50,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["1770210609833554"] = {
						["key"] = "1770210609833554",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2148.608182667006,
							["y"] = 314.7317714964774
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Defense_Finish",
							["UnitId"] = -1
						}
					},
					["17730550603324960138"] = {
						["key"] = "17730550603324960138",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1853.0818572556475,
							["y"] = 718.2102210359162
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Defense_Over",
							["UnitId"] = -1
						}
					},
					["177313156223219123346"] = {
						["key"] = "177313156223219123346",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成空气墙",
						["pos"] = {
							["x"] = 1492.7866045692324,
							["y"] = 134.3157360948009
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360054,
								162360015,
								162360016,
								162360017,
								162360018,
								162360019,
								162360020,
								162360021,
								162360022
							}
						}
					},
					["177313210297022502289"] = {
						["key"] = "177313210297022502289",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成空气墙",
						["pos"] = {
							["x"] = 2364.02952801674,
							["y"] = 177.66995078663876
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360054,
								162360015,
								162360016,
								162360017,
								162360018,
								162360019,
								162360020,
								162360021,
								162360022
							}
						}
					},
					["177313211204922502578"] = {
						["key"] = "177313211204922502578",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成空气墙",
						["pos"] = {
							["x"] = 2090.3713571021976,
							["y"] = 703.0958741885743
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360054,
								162360015,
								162360016,
								162360017,
								162360018,
								162360019,
								162360020,
								162360021,
								162360022
							}
						}
					},
					["1773300783630851789"] = {
						["key"] = "1773300783630851789",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1164,
							["y"] = 26.00000000000003
						},
						["propsData"] = {
							["QuestRoleId"] = 24010102,
							["IsPlayFX"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}