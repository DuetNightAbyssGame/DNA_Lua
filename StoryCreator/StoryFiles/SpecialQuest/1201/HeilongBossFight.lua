return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1760950499063209",
			["startPort"] = "Success",
			["endStory"] = "17609503279695",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17609503279681",
			["startPort"] = "StoryStart",
			["endStory"] = "1760950499063209",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17609503279681"] = {
			["isStoryNode"] = true,
			["key"] = "17609503279681",
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
		["17609503279695"] = {
			["isStoryNode"] = true,
			["key"] = "17609503279695",
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
		["1760950499063209"] = {
			["isStoryNode"] = true,
			["key"] = "1760950499063209",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1588,
				["y"] = 310
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
						["startQuest"] = "1760950508197596",
						["startPort"] = "Out",
						["endQuest"] = "1760950508197597",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760950499063210",
						["startPort"] = "QuestStart",
						["endQuest"] = "17614605675933986",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1761291324978454",
						["startPort"] = "Out",
						["endQuest"] = "1761479558729876",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1761479558729876",
						["startPort"] = "Out",
						["endQuest"] = "1761479562425983",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760965401868794",
						["startPort"] = "Out",
						["endQuest"] = "17614807489042987",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760950499063210",
						["startPort"] = "QuestStart",
						["endQuest"] = "1760965401868794",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17614795809301688",
						["startPort"] = "Out",
						["endQuest"] = "1760965392380656",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760950499063210",
						["startPort"] = "QuestStart",
						["endQuest"] = "176485712838513392067",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176485712838513392067",
						["startPort"] = "Out",
						["endQuest"] = "1761291324978454",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1761479562425983",
						["startPort"] = "Out",
						["endQuest"] = "176485721357313392581",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176485721357313392581",
						["startPort"] = "Out",
						["endQuest"] = "17614795809301688",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17614807489042987",
						["startPort"] = "Out",
						["endQuest"] = "176485724570413393232",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176485724570413393232",
						["startPort"] = "Out",
						["endQuest"] = "1760950499063224",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1760950499063210"] = {
						["key"] = "1760950499063210",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 845,
							["y"] = 288.75
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1760950499063217"] = {
						["key"] = "1760950499063217",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3102.809090909091,
							["y"] = 298.09090909090907
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1760950499063224"] = {
						["key"] = "1760950499063224",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2518.7238095238095,
							["y"] = 685.3857142857144
						},
						["propsData"] = {}
					},
					["1760950508197595"] = {
						["key"] = "1760950508197595",
						["type"] = "TalkNode",
						["name"] = "Boss战斗",
						["pos"] = {
							["x"] = 1809.882911153235,
							["y"] = -17.485236180145165
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12023809,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
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
					["1760950508197596"] = {
						["key"] = "1760950508197596",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成黑龙",
						["pos"] = {
							["x"] = 1269.291160593792,
							["y"] = -868.3688659870377
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2020012
							}
						}
					},
					["1760950508197597"] = {
						["key"] = "1760950508197597",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1554.919365721997,
							["y"] = -873.7021993203709
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = false,
							["StaticCreatorIdList"] = {
								2020012
							}
						}
					},
					["1760965392380656"] = {
						["key"] = "1760965392380656",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2800.341987379516,
							["y"] = 334.9233478954303
						},
						["propsData"] = {}
					},
					["1760965401868794"] = {
						["key"] = "1760965401868794",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1524.347619047619,
							["y"] = 681.0809523809523
						},
						["propsData"] = {}
					},
					["17609654299331328"] = {
						["key"] = "17609654299331328",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁黑龙",
						["pos"] = {
							["x"] = 1592.095238095238,
							["y"] = -674.8952380952383
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2020012
							}
						}
					},
					["1761291324978454"] = {
						["key"] = "1761291324978454",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1236.5598779557588,
							["y"] = 263.9458428680396
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_BossFight120106",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17614605342923088"] = {
						["key"] = "17614605342923088",
						["type"] = "SendMessageNode",
						["name"] = "发送消息【时间-Day】",
						["pos"] = {
							["x"] = 1148.610071301248,
							["y"] = -371.438725490196
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "SwitchEnvDay",
							["UnitId"] = -1
						}
					},
					["17614605665343935"] = {
						["key"] = "17614605665343935",
						["type"] = "SendMessageNode",
						["name"] = "发送消息【时间-Dusk】",
						["pos"] = {
							["x"] = 1150.1100713012477,
							["y"] = -237.79445187165766
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "SwitchEnvDawn",
							["UnitId"] = -1
						}
					},
					["17614605675933986"] = {
						["key"] = "17614605675933986",
						["type"] = "SendMessageNode",
						["name"] = "发送消息【时间-Night】",
						["pos"] = {
							["x"] = 1151.8555258467024,
							["y"] = -87.20236185383234
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "SwitchEnvNight",
							["UnitId"] = -1
						}
					},
					["1761479558729876"] = {
						["key"] = "1761479558729876",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战3开始",
						["pos"] = {
							["x"] = 1529.8634085213032,
							["y"] = 269.1667805878333
						},
						["propsData"] = {
							["SendMessage"] = "BossBattle",
							["FinishCondition"] = "BossHeilong_Create"
						}
					},
					["1761479562425983"] = {
						["key"] = "1761479562425983",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战3成功",
						["pos"] = {
							["x"] = 1814.1457051720208,
							["y"] = 273.5686944634315
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "BossHeilong_StoryEnd"
						}
					},
					["17614795809301688"] = {
						["key"] = "17614795809301688",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2463.716392303349,
							["y"] = 299.81984300977456
						},
						["propsData"] = {
							["WaitTime"] = 1.5
						}
					},
					["17614807489042987"] = {
						["key"] = "17614807489042987",
						["type"] = "SendMessageNode",
						["name"] = "发送消息【Boss战失败】",
						["pos"] = {
							["x"] = 1838.5564871403108,
							["y"] = 693.6218473992468
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "BossBattleFail",
							["UnitId"] = -1
						}
					},
					["17614822272741328467"] = {
						["key"] = "17614822272741328467",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁节点【钩锁】",
						["pos"] = {
							["x"] = 1287.8961929061197,
							["y"] = 923.9344228101058
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2020023,
								2020024,
								2020025,
								2020022,
								2020021,
								2020020,
								2020019
							}
						}
					},
					["17614822374711328851"] = {
						["key"] = "17614822374711328851",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成节点【钩锁】",
						["pos"] = {
							["x"] = 1845.8855175604667,
							["y"] = 843.4138691881996
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2020023,
								2020024,
								2020025,
								2020022,
								2020021,
								2020020,
								2020019
							}
						}
					},
					["17614822926041330046"] = {
						["key"] = "17614822926041330046",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2854.506839998965,
							["y"] = 472.83666790987064
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17614823249461331252"] = {
						["key"] = "17614823249461331252",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成节点【钩锁】",
						["pos"] = {
							["x"] = 2938.933304838474,
							["y"] = 655.2572125825892
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2020023,
								2020024,
								2020025,
								2020022,
								2020021,
								2020020,
								2020019
							}
						}
					},
					["17614829836471994821"] = {
						["key"] = "17614829836471994821",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2197.1196575373147,
							["y"] = 804.2891024893954
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["176485712838513392067"] = {
						["key"] = "176485712838513392067",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1216.625,
							["y"] = 111.25
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/1_1/0121_boss_heilong",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								105701
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = false
						}
					},
					["176485721357313392581"] = {
						["key"] = "176485721357313392581",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2184.535714285714,
							["y"] = 311.8928571428571
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["176485724570413393232"] = {
						["key"] = "176485724570413393232",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 2130.25,
							["y"] = 693.3214285714287
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					}
				},
				["commentData"] = {
					["17614605453053433"] = {
						["key"] = "17614605453053433",
						["name"] = "时间切换",
						["position"] = {
							["x"] = 1080.200980392157,
							["y"] = -467.438725490196
						},
						["size"] = {
							["width"] = 369.81818181818176,
							["height"] = 543.8181818181819
						}
					},
					["17614829992531995453"] = {
						["key"] = "17614829992531995453",
						["name"] = "失败",
						["position"] = {
							["x"] = 1798.0608340079025,
							["y"] = 613.1361613129247
						},
						["size"] = {
							["width"] = 674.4000000000002,
							["height"] = 363.6000000000002
						}
					},
					["17614830125911995727"] = {
						["key"] = "17614830125911995727",
						["name"] = "成功",
						["position"] = {
							["x"] = 2110.0608340079025,
							["y"] = 169.13616131292477
						},
						["size"] = {
							["width"] = 600,
							["height"] = 400
						}
					}
				}
			}
		}
	},
	["commentData"] = {}
}