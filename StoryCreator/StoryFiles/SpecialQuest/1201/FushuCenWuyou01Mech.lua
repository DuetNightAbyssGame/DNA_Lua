return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17636395071061",
			["startPort"] = "StoryStart",
			["endStory"] = "176363951207889",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176363951207889",
			["startPort"] = "Success",
			["endStory"] = "17636395071075",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17636395071061"] = {
			["isStoryNode"] = true,
			["key"] = "17636395071061",
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
		["17636395071075"] = {
			["isStoryNode"] = true,
			["key"] = "17636395071075",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1712,
				["y"] = 298
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176363951207889"] = {
			["isStoryNode"] = true,
			["key"] = "176363951207889",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1268,
				["y"] = 286
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
						["startQuest"] = "176363951207890",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636395661071632",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636395661071632",
						["startPort"] = "Out",
						["endQuest"] = "17636437249972685",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636437239202642",
						["startPort"] = "Out",
						["endQuest"] = "17636395538861342",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363951207890",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636471507261354829",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636437249972685",
						["startPort"] = "Out",
						["endQuest"] = "17636471776951355284",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636471776951355284",
						["startPort"] = "Out",
						["endQuest"] = "1763639512078104",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "176363951207890",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636437221642563",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363951207890",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636473319891355903",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636471507261354829",
						["startPort"] = "Out",
						["endQuest"] = "17636473319891355902",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636473319891355902",
						["startPort"] = "Out",
						["endQuest"] = "17636437239202642",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363951207890",
						["startPort"] = "QuestStart",
						["endQuest"] = "17637059367978795515",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["176363951207890"] = {
						["key"] = "176363951207890",
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
					["176363951207897"] = {
						["key"] = "176363951207897",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3026.6666666666665,
							["y"] = 285
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763639512078104"] = {
						["key"] = "1763639512078104",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2360.93984962406,
							["y"] = 824.3984962406016
						},
						["propsData"] = {}
					},
					["17636395538861342"] = {
						["key"] = "17636395538861342",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2324.7644110275683,
							["y"] = 293.38596491228077
						},
						["propsData"] = {}
					},
					["17636395661071632"] = {
						["key"] = "17636395661071632",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1385.5363408521298,
							["y"] = 707.1528822055137
						},
						["propsData"] = {}
					},
					["17636437221642563"] = {
						["key"] = "17636437221642563",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成扶疏魅影",
						["pos"] = {
							["x"] = 1296.1829573934833,
							["y"] = -107.62907268170424
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050129
							}
						}
					},
					["17636437239202642"] = {
						["key"] = "17636437239202642",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁扶疏魅影",
						["pos"] = {
							["x"] = 1946.0250626566415,
							["y"] = 293.19047619047615
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050129
							}
						}
					},
					["17636437249972685"] = {
						["key"] = "17636437249972685",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁扶疏魅影",
						["pos"] = {
							["x"] = 1703.401002506265,
							["y"] = 775.8521303258144
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050129
							}
						}
					},
					["17636471507261354829"] = {
						["key"] = "17636471507261354829",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成晶垢",
						["pos"] = {
							["x"] = 1283.2456140350876,
							["y"] = 305.3684210526317
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050011
							}
						}
					},
					["17636471776951355284"] = {
						["key"] = "17636471776951355284",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁晶垢",
						["pos"] = {
							["x"] = 2032.7192982456145,
							["y"] = 798
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2050011
							}
						}
					},
					["17636473319891355902"] = {
						["key"] = "17636473319891355902",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1617.2047010642546,
							["y"] = 282.453997312121
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2050011,
							["StateId"] = 118022,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_JingGou_2050011"
						}
					},
					["17636473319891355903"] = {
						["key"] = "17636473319891355903",
						["type"] = "TalkNode",
						["name"] = "开车- 清除尘漠",
						["pos"] = {
							["x"] = 1290.865474374342,
							["y"] = -309.61189204896294
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12014201,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17637059367978795515"] = {
						["key"] = "17637059367978795515",
						["type"] = "ShowGuideToastButtonNode",
						["name"] = "ToastButton显示/隐藏信息",
						["pos"] = {
							["x"] = 1299.6842105263156,
							["y"] = 77.6842105263159
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300613,
							["MessageNote"] = "打开战斗背包",
							["LastTime"] = 10,
							["DelayTime"] = 0.5,
							["HighLightUIPath"] = "BattleMain.Char_Skill.Battle_Menu",
							["UICompName"] = "Bg",
							["UIShape"] = "Square",
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["UICompSizeOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "UpLeft",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
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