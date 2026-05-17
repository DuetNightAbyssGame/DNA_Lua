return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17496245223333461354",
			["startPort"] = "StoryStart",
			["endStory"] = "17496245223333461356",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17496245223333461356",
			["startPort"] = "Success",
			["endStory"] = "17496245223333461355",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17496245223333461354"] = {
			["isStoryNode"] = true,
			["key"] = "17496245223333461354",
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
		["17496245223333461355"] = {
			["isStoryNode"] = true,
			["key"] = "17496245223333461355",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1406,
				["y"] = 286
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17496245223333461356"] = {
			["isStoryNode"] = true,
			["key"] = "17496245223333461356",
			["type"] = "StoryNode",
			["name"] = "魔灵",
			["pos"] = {
				["x"] = 1095.1875,
				["y"] = 279.8125
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_FortPet_Des",
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
						["startQuest"] = "17496245223333461362",
						["startPort"] = "Out",
						["endQuest"] = "17496245223333461358",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17496245223333461363",
						["startPort"] = "Out",
						["endQuest"] = "17496245223333461364",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223333461365",
						["startPort"] = "Out",
						["endQuest"] = "17496245223333461363",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223333461365",
						["startPort"] = "Out",
						["endQuest"] = "17496245223333461361",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223333461364",
						["startPort"] = "Out",
						["endQuest"] = "17496245223343461367",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223343461369",
						["startPort"] = "Out",
						["endQuest"] = "17496245223333461360",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223333461365",
						["startPort"] = "Out",
						["endQuest"] = "17496245223343461370",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223333461364",
						["startPort"] = "Out",
						["endQuest"] = "17496245223343461372",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223343461372",
						["startPort"] = "Out",
						["endQuest"] = "17496245223343461369",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223343461373",
						["startPort"] = "Out",
						["endQuest"] = "17496245223333461362",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223333461357",
						["startPort"] = "QuestStart",
						["endQuest"] = "17496245223343461374",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223343461375",
						["startPort"] = "Out",
						["endQuest"] = "17496245223333461365",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223343461374",
						["startPort"] = "Out",
						["endQuest"] = "17496245223343461375",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223333461360",
						["startPort"] = "Out",
						["endQuest"] = "17496245223343461371",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223333461360",
						["startPort"] = "Out",
						["endQuest"] = "17496245223343461373",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17496245223333461360",
						["startPort"] = "Out",
						["endQuest"] = "17496245223343461368",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17496245223333461357"] = {
						["key"] = "17496245223333461357",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -361.2500000000001,
							["y"] = 271.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17496245223333461358"] = {
						["key"] = "17496245223333461358",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2777.2,
							["y"] = 295.20000000000005
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17496245223333461359"] = {
						["key"] = "17496245223333461359",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17496245223333461360"] = {
						["key"] = "17496245223333461360",
						["type"] = "KillMonsterNode",
						["name"] = "击杀历战者",
						["pos"] = {
							["x"] = 1859.4999999999993,
							["y"] = 271.43636363636375
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1640461
							}
						}
					},
					["17496245223333461361"] = {
						["key"] = "17496245223333461361",
						["type"] = "TalkNode",
						["name"] = "解救宠物开车",
						["pos"] = {
							["x"] = 697.4086080586077,
							["y"] = 48.30811965811986
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71004401,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17496245223333461362"] = {
						["key"] = "17496245223333461362",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 2508.5454545454545,
							["y"] = 288.7428571428573
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17496245223333461363"] = {
						["key"] = "17496245223333461363",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成士兵",
						["pos"] = {
							["x"] = 702.4545454545455,
							["y"] = 276.5681818181819
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1640458,
								1640459,
								1640460
							}
						}
					},
					["17496245223333461364"] = {
						["key"] = "17496245223333461364",
						["type"] = "KillMonsterNode",
						["name"] = "击杀围绕着宠物的秽兽",
						["pos"] = {
							["x"] = 1005.1681818181819,
							["y"] = 267.1636363636365
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 3,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1640458,
								1640459,
								1640460
							}
						}
					},
					["17496245223333461365"] = {
						["key"] = "17496245223333461365",
						["type"] = "SendMessageNode",
						["name"] = "锁住宠物",
						["pos"] = {
							["x"] = 433.7045454545455,
							["y"] = 274.9772727272729
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "LockPet",
							["UnitId"] = -1
						}
					},
					["17496245223333461366"] = {
						["key"] = "17496245223333461366",
						["type"] = "SendMessageNode",
						["name"] = "解锁宠物",
						["pos"] = {
							["x"] = 2381.8175889328068,
							["y"] = 498.3511857707511
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "UnlockPet",
							["UnitId"] = -1
						}
					},
					["17496245223343461367"] = {
						["key"] = "17496245223343461367",
						["type"] = "TalkNode",
						["name"] = "击杀秽兽开车",
						["pos"] = {
							["x"] = 1286.4727215766695,
							["y"] = -44.5552916381867
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71004402,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17496245223343461368"] = {
						["key"] = "17496245223343461368",
						["type"] = "TalkNode",
						["name"] = "击杀初始士兵开车",
						["pos"] = {
							["x"] = 2116.003391135944,
							["y"] = 487.91591107214657
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71004403,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17496245223343461369"] = {
						["key"] = "17496245223343461369",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成历战者",
						["pos"] = {
							["x"] = 1578.0101105035326,
							["y"] = 275.66548758259245
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1640461
							}
						}
					},
					["17496245223343461370"] = {
						["key"] = "17496245223343461370",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成锁定特效",
						["pos"] = {
							["x"] = 690.3356978968,
							["y"] = 451.30958419356966
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1640457
							}
						}
					},
					["17496245223343461371"] = {
						["key"] = "17496245223343461371",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 2157.9356978968,
							["y"] = 78.1095841935695
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1640457
							},
							["ManualItemIdList"] = {},
							["StateId"] = 780341,
							["QuestId"] = 0
						}
					},
					["17496245223343461372"] = {
						["key"] = "17496245223343461372",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1307.6846705846704,
							["y"] = 271.62100482100465
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17496245223343461373"] = {
						["key"] = "17496245223343461373",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2217.6275277275276,
							["y"] = 284.8638619638618
						},
						["propsData"] = {
							["WaitTime"] = 5
						}
					},
					["17496245223343461374"] = {
						["key"] = "17496245223343461374",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成宠物",
						["pos"] = {
							["x"] = -103,
							["y"] = 266
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1640456
							}
						}
					},
					["17496245223343461375"] = {
						["key"] = "17496245223343461375",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 174.0000000000001,
							["y"] = 274
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