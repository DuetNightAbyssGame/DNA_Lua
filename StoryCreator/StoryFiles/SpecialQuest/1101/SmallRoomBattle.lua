return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17314982300194699447",
			["startPort"] = "Success",
			["endStory"] = "17314982271214699360",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17314982271214699357",
			["startPort"] = "StoryStart",
			["endStory"] = "17314982300194699447",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17314982271214699357"] = {
			["isStoryNode"] = true,
			["key"] = "17314982271214699357",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1118,
				["y"] = 334
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
		["17314982271214699360"] = {
			["isStoryNode"] = true,
			["key"] = "17314982271214699360",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1986,
				["y"] = 346
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17314982300194699447"] = {
			["isStoryNode"] = true,
			["key"] = "17314982300194699447",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1610,
				["y"] = 282
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_110103_5",
				["QuestDeatil"] = "Description_110104_1",
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
						["startQuest"] = "17314982300194699448",
						["startPort"] = "QuestStart",
						["endQuest"] = "17314983480595309635",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17314982300194699448",
						["startPort"] = "QuestStart",
						["endQuest"] = "17314983149825308467",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17314983149825308467",
						["startPort"] = "Out",
						["endQuest"] = "1731581596187813428",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1731581596187813428",
						["startPort"] = "Out",
						["endQuest"] = "17349228913893109",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17349228913893109",
						["startPort"] = "Out",
						["endQuest"] = "17314983401465309390",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17314982300194699448",
						["startPort"] = "QuestStart",
						["endQuest"] = "1734940811216686695",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1734940811216686695",
						["startPort"] = "Out",
						["endQuest"] = "17349228831742777",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17314983480595309635",
						["startPort"] = "Out",
						["endQuest"] = "17349449413142051559",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17349449413142051559",
						["startPort"] = "Out",
						["endQuest"] = "17314982300194699454",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17314982300194699448"] = {
						["key"] = "17314982300194699448",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1013.9130434782609,
							["y"] = 331.30434782608694
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17314982300194699451"] = {
						["key"] = "17314982300194699451",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2894.2436758893277,
							["y"] = 308.71884057971016
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17314982300194699454"] = {
						["key"] = "17314982300194699454",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1923.5642693690745,
							["y"] = 522.584079764629
						},
						["propsData"] = {}
					},
					["17314983149825308466"] = {
						["key"] = "17314983149825308466",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1930.4395261734942,
							["y"] = 63.58492382489729
						},
						["propsData"] = {
							["GuideId"] = 53
						}
					},
					["17314983149825308467"] = {
						["key"] = "17314983149825308467",
						["type"] = "SendMessageNode",
						["name"] = "小房间战斗开始",
						["pos"] = {
							["x"] = 1453.0627596494678,
							["y"] = 293.25710516060997
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "SmallRoomBattle",
							["UnitId"] = -1
						}
					},
					["17314983401465309390"] = {
						["key"] = "17314983401465309390",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2603.226746708668,
							["y"] = 307.6169405727756
						},
						["propsData"] = {}
					},
					["17314983480595309635"] = {
						["key"] = "17314983480595309635",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1378.4925475744692,
							["y"] = 499.59875875459386
						},
						["propsData"] = {}
					},
					["1731581596187813428"] = {
						["key"] = "1731581596187813428",
						["type"] = "BossBattleFinishNode",
						["name"] = "小房间战斗成功",
						["pos"] = {
							["x"] = 1761.6725981620718,
							["y"] = 288.52543859649137
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "TongYongBattleEnd_1"
						}
					},
					["17349228831742777"] = {
						["key"] = "17349228831742777",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 1660.694381705251,
							["y"] = 97.23785996612082
						},
						["propsData"] = {
							["IsCreate"] = true,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								1640540
							}
						}
					},
					["17349228913893109"] = {
						["key"] = "17349228913893109",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 2038.7922077922076,
							["y"] = 298.59655561829476
						},
						["propsData"] = {
							["IsCreate"] = false,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								1640540
							}
						}
					},
					["1734940811216686695"] = {
						["key"] = "1734940811216686695",
						["type"] = "CreatePhantomNode",
						["name"] = "召唤/销毁剧情魅影",
						["pos"] = {
							["x"] = 1379.6782036613274,
							["y"] = 95.21739130434767
						},
						["propsData"] = {
							["IsCreate"] = false,
							["IsClearOtherPhantom"] = false,
							["IsSync"] = false,
							["StaticCreatorIdList"] = {
								1640642
							}
						}
					},
					["17349449413142051559"] = {
						["key"] = "17349449413142051559",
						["type"] = "SendMessageNode",
						["name"] = "小房间战斗失败",
						["pos"] = {
							["x"] = 1649.865309309303,
							["y"] = 521.0217545739283
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "SmallRoomBattleFail",
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