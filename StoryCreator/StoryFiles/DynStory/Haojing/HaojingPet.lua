return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1758263979523833",
			["startPort"] = "StoryStart",
			["endStory"] = "1758263980869889",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1758263980869889",
			["startPort"] = "Success",
			["endStory"] = "1758263979523836",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1758263979523833"] = {
			["isStoryNode"] = true,
			["key"] = "1758263979523833",
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
		["1758263979523836"] = {
			["isStoryNode"] = true,
			["key"] = "1758263979523836",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1610.9868421052631,
				["y"] = 287.5657894736842
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1758263980869889"] = {
			["isStoryNode"] = true,
			["key"] = "1758263980869889",
			["type"] = "StoryNode",
			["name"] = "宠物",
			["pos"] = {
				["x"] = 1209.75,
				["y"] = 287.5
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_HaojingPet_Des",
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
						["startQuest"] = "1758264789181353",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181354",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181355",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181353",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181355",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181351",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181354",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181357",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181359",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181350",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181355",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181360",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181354",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181362",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181362",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181359",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181365",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181355",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181364",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181365",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181350",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181361",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181350",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181363",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181363",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181358",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181358",
						["startPort"] = "Out",
						["endQuest"] = "1758264789181352",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758264789181352",
						["startPort"] = "Out",
						["endQuest"] = "1758263980869893",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1758263980869890",
						["startPort"] = "QuestStart",
						["endQuest"] = "1758264789181364",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1758263980869890"] = {
						["key"] = "1758263980869890",
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
					["1758263980869893"] = {
						["key"] = "1758263980869893",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4215.454545454545,
							["y"] = 339.54545454545456
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1758263980869896"] = {
						["key"] = "1758263980869896",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4114.545454545454,
							["y"] = 885.4545454545455
						},
						["propsData"] = {}
					},
					["1758264789181350"] = {
						["key"] = "1758264789181350",
						["type"] = "KillMonsterNode",
						["name"] = "击杀狴犴",
						["pos"] = {
							["x"] = 3025.6888611388604,
							["y"] = 322.26435910580665
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 8,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2420011,
								2420012,
								2420013,
								2420014,
								2420015,
								2420016,
								2420017,
								2420018
							}
						}
					},
					["1758264789181351"] = {
						["key"] = "1758264789181351",
						["type"] = "TalkNode",
						["name"] = "解救宠物开车",
						["pos"] = {
							["x"] = 1864.7974691974687,
							["y"] = 99.13611512756279
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71007301,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1758264789181352"] = {
						["key"] = "1758264789181352",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3923.434315684315,
							["y"] = 328.3208526123002
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["1758264789181353"] = {
						["key"] = "1758264789181353",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成应天侍",
						["pos"] = {
							["x"] = 1869.8434065934061,
							["y"] = 327.39617728762494
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420007,
								2420008,
								2420009,
								2420010
							}
						}
					},
					["1758264789181354"] = {
						["key"] = "1758264789181354",
						["type"] = "KillMonsterNode",
						["name"] = "击杀围绕着宠物的狴犴",
						["pos"] = {
							["x"] = 2172.5570429570425,
							["y"] = 317.9916318330794
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 4,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2420007,
								2420008,
								2420009,
								2420010
							}
						}
					},
					["1758264789181355"] = {
						["key"] = "1758264789181355",
						["type"] = "SendMessageNode",
						["name"] = "锁住宠物",
						["pos"] = {
							["x"] = 1602.2934065934064,
							["y"] = 325.80526819671593
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "LockPet",
							["UnitId"] = -1
						}
					},
					["1758264789181356"] = {
						["key"] = "1758264789181356",
						["type"] = "SendMessageNode",
						["name"] = "解锁宠物",
						["pos"] = {
							["x"] = 3402.293406593407,
							["y"] = 678.2552681967157
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "UnlockPet",
							["UnitId"] = -1
						}
					},
					["1758264789181357"] = {
						["key"] = "1758264789181357",
						["type"] = "TalkNode",
						["name"] = "击杀秽兽开车",
						["pos"] = {
							["x"] = 2532.6115827155304,
							["y"] = 583.7727038312562
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71007302,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1758264789181358"] = {
						["key"] = "1758264789181358",
						["type"] = "TalkNode",
						["name"] = "击杀怪物开车",
						["pos"] = {
							["x"] = 3638.930789824212,
							["y"] = 320.64608045463285
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71007303,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1758264789181359"] = {
						["key"] = "1758264789181359",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成第二波狴犴",
						["pos"] = {
							["x"] = 2743.256114499536,
							["y"] = 325.4220544806068
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420011,
								2420012,
								2420013,
								2420014,
								2420015,
								2420016,
								2420017,
								2420018
							}
						}
					},
					["1758264789181360"] = {
						["key"] = "1758264789181360",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成锁定特效",
						["pos"] = {
							["x"] = 1855.324559035661,
							["y"] = 502.1375796630126
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420004
							}
						}
					},
					["1758264789181361"] = {
						["key"] = "1758264789181361",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 3376.324559035661,
							["y"] = 109.43757966301246
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2420004
							},
							["ManualItemIdList"] = {},
							["StateId"] = 780341,
							["QuestId"] = 0
						}
					},
					["1758264789181362"] = {
						["key"] = "1758264789181362",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2475.0735317235312,
							["y"] = 321.2490002904476
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["1758264789181363"] = {
						["key"] = "1758264789181363",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3385.0163888663883,
							["y"] = 335.6918574333048
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["1758264789181364"] = {
						["key"] = "1758264789181364",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成宠物",
						["pos"] = {
							["x"] = 1064.3888611388606,
							["y"] = 316.82799546944295
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420003
							}
						}
					},
					["1758264789181365"] = {
						["key"] = "1758264789181365",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1341.3888611388609,
							["y"] = 324.82799546944295
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}