return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17344916973002471",
			["startPort"] = "StoryStart",
			["endStory"] = "17344917015812633",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17344917015812633",
			["startPort"] = "Success",
			["endStory"] = "17344916973002474",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17344916973002471"] = {
			["isStoryNode"] = true,
			["key"] = "17344916973002471",
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
		["17344916973002474"] = {
			["isStoryNode"] = true,
			["key"] = "17344916973002474",
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
		["17344917015812633"] = {
			["isStoryNode"] = true,
			["key"] = "17344917015812633",
			["type"] = "StoryNode",
			["name"] = "魔灵",
			["pos"] = {
				["x"] = 1097.1875,
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
						["startQuest"] = "17344917015822642",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822638",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17344917015822643",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822644",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822645",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822643",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822645",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822641",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822644",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822647",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822649",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822640",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822645",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822650",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822644",
						["startPort"] = "Out",
						["endQuest"] = "1734502092727688167",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734502092727688167",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822649",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822637",
						["startPort"] = "QuestStart",
						["endQuest"] = "17440179860921051185",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17440179930881051322",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822645",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17440179860921051185",
						["startPort"] = "Out",
						["endQuest"] = "17440179930881051322",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822640",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822651",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822640",
						["startPort"] = "Out",
						["endQuest"] = "17345021890611371934",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17345021890611371934",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822648",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17344917015822648",
						["startPort"] = "Out",
						["endQuest"] = "17344917015822642",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17344917015822637"] = {
						["key"] = "17344917015822637",
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
					["17344917015822638"] = {
						["key"] = "17344917015822638",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3024.7,
							["y"] = 283.95000000000005
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17344917015822639"] = {
						["key"] = "17344917015822639",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17344917015822640"] = {
						["key"] = "17344917015822640",
						["type"] = "KillMonsterNode",
						["name"] = "击杀狴犴",
						["pos"] = {
							["x"] = 1858.2999999999993,
							["y"] = 272.8649350649352
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2080052,
								2080053
							}
						}
					},
					["17344917015822641"] = {
						["key"] = "17344917015822641",
						["type"] = "TalkNode",
						["name"] = "解救宠物开车",
						["pos"] = {
							["x"] = 697.4086080586077,
							["y"] = 48.30811965811986
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
					["17344917015822642"] = {
						["key"] = "17344917015822642",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 2756.0454545454545,
							["y"] = 277.4928571428573
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17344917015822643"] = {
						["key"] = "17344917015822643",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成狴犴",
						["pos"] = {
							["x"] = 703.7588932806325,
							["y"] = 276.5681818181819
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080049
							}
						}
					},
					["17344917015822644"] = {
						["key"] = "17344917015822644",
						["type"] = "KillMonsterNode",
						["name"] = "击杀围绕着宠物的狴犴",
						["pos"] = {
							["x"] = 1005.1681818181819,
							["y"] = 267.1636363636365
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2080049
							}
						}
					},
					["17344917015822645"] = {
						["key"] = "17344917015822645",
						["type"] = "SendMessageNode",
						["name"] = "锁住宠物",
						["pos"] = {
							["x"] = 434.90454545454554,
							["y"] = 274.9772727272729
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "LockPet",
							["UnitId"] = -1
						}
					},
					["17344917015822647"] = {
						["key"] = "17344917015822647",
						["type"] = "TalkNode",
						["name"] = "击杀秽兽开车",
						["pos"] = {
							["x"] = 1286.4727215766695,
							["y"] = -44.5552916381867
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
					["17344917015822648"] = {
						["key"] = "17344917015822648",
						["type"] = "TalkNode",
						["name"] = "击杀怪物开车",
						["pos"] = {
							["x"] = 2472.9055650489872,
							["y"] = 269.81808498518996
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
					["17344917015822649"] = {
						["key"] = "17344917015822649",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成第二波狴犴",
						["pos"] = {
							["x"] = 1575.8672533606755,
							["y"] = 274.5940590111639
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080052,
								2080053
							}
						}
					},
					["17344917015822650"] = {
						["key"] = "17344917015822650",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成锁定特效",
						["pos"] = {
							["x"] = 687.9356978968,
							["y"] = 451.30958419356966
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2080047
							}
						}
					},
					["17344917015822651"] = {
						["key"] = "17344917015822651",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 2157.9356978968,
							["y"] = 78.1095841935695
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								2080047
							},
							["ManualItemIdList"] = {},
							["StateId"] = 780341,
							["QuestId"] = 0
						}
					},
					["1734502092727688167"] = {
						["key"] = "1734502092727688167",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1307.6846705846704,
							["y"] = 270.42100482100466
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["17345021890611371934"] = {
						["key"] = "17345021890611371934",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2217.6275277275276,
							["y"] = 284.8638619638618
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["17440179860921051185"] = {
						["key"] = "17440179860921051185",
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
								2080048
							}
						}
					},
					["17440179930881051322"] = {
						["key"] = "17440179930881051322",
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