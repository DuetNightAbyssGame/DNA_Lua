return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1772421504260707088",
			["startPort"] = "StoryStart",
			["endStory"] = "1772421504260707090",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1772421504260707090",
			["startPort"] = "Success",
			["endStory"] = "1772421504260707089",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1772421504260707088"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504260707088",
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
		["1772421504260707089"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504260707089",
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
		["1772421504260707090"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504260707090",
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
						["startQuest"] = "1772421504260707091",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772421504260707096",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772421504260707091",
						["startPort"] = "QuestStart",
						["endQuest"] = "17724329249092376847",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724329249092376847",
						["startPort"] = "Out",
						["endQuest"] = "1772421504260707093",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17724329475492377201",
						["startPort"] = "Out",
						["endQuest"] = "17724329475492377202",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724329475492377203",
						["startPort"] = "Out",
						["endQuest"] = "17724329475492377201",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724329475492377204",
						["startPort"] = "Out",
						["endQuest"] = "17724329475492377205",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724329475492377206",
						["startPort"] = "Out",
						["endQuest"] = "17724329475492377204",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724329475492377207",
						["startPort"] = "Out",
						["endQuest"] = "17724329475492377208",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724329475492377209",
						["startPort"] = "Out",
						["endQuest"] = "17724329475492377207",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724329475492377202",
						["startPort"] = "Out",
						["endQuest"] = "17724329475492377206",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724329475492377205",
						["startPort"] = "Out",
						["endQuest"] = "17724329475492377209",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772421504260707096",
						["startPort"] = "Out",
						["endQuest"] = "17724329475492377203",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724329475492377208",
						["startPort"] = "Out",
						["endQuest"] = "17724329191092376718",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1772421504260707091"] = {
						["key"] = "1772421504260707091",
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
					["1772421504260707092"] = {
						["key"] = "1772421504260707092",
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
					["1772421504260707093"] = {
						["key"] = "1772421504260707093",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1934.2857142857142,
							["y"] = 684.2857142857143
						},
						["propsData"] = {}
					},
					["1772421504260707096"] = {
						["key"] = "1772421504260707096",
						["type"] = "ChangeRoleNode",
						["name"] = "切换苏乙",
						["pos"] = {
							["x"] = 1035.4599333598187,
							["y"] = 60.18996951875701
						},
						["propsData"] = {
							["QuestRoleId"] = 15040101,
							["IsPlayFX"] = false
						}
					},
					["17724329191092376718"] = {
						["key"] = "17724329191092376718",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2388.171428571429,
							["y"] = 130.45714285714277
						},
						["propsData"] = {}
					},
					["17724329249092376847"] = {
						["key"] = "17724329249092376847",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1548.857142857143,
							["y"] = 618.2857142857142
						},
						["propsData"] = {}
					},
					["17724329475492377201"] = {
						["key"] = "17724329475492377201",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1389.0822198599221,
							["y"] = -44.26457273424812
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162010207,
								162010208,
								162010209,
								162010210,
								162010211,
								162010212,
								162010213,
								162010214,
								162010215,
								162010216,
								162010217,
								162010218,
								162010219
							}
						}
					},
					["17724329475492377202"] = {
						["key"] = "17724329475492377202",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1380.1561114855376,
							["y"] = 100.14922036920017
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 13,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17724329475492377203"] = {
						["key"] = "17724329475492377203",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1384.7469305717932,
							["y"] = -205.3749084249085
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242010089,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020605mon1_242010089"
						}
					},
					["17724329475492377204"] = {
						["key"] = "17724329475492377204",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1769.7814133304137,
							["y"] = -45.098065702731006
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162010220,
								162010221,
								162010222,
								162010223,
								162010224,
								162010225,
								162010226,
								162010227,
								162010228,
								162010229
							}
						}
					},
					["17724329475492377205"] = {
						["key"] = "17724329475492377205",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1765.6553049560289,
							["y"] = 112.51572740071728
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 10,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17724329475492377206"] = {
						["key"] = "17724329475492377206",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1767.4461240422847,
							["y"] = -205.20840139339143
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242010090,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020605mon2_242010090"
						}
					},
					["17724329475492377207"] = {
						["key"] = "17724329475492377207",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2125.0588908078903,
							["y"] = -47.419677424342595
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162410158,
								162410159,
								162410160,
								162410161,
								162410162,
								162410163,
								162410164,
								162410165,
								162410166,
								162410167,
								162410168,
								162410169,
								162410170
							}
						}
					},
					["17724329475492377208"] = {
						["key"] = "17724329475492377208",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2116.1327824335062,
							["y"] = 100.09756395496775
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 13,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17724329475492377209"] = {
						["key"] = "17724329475492377209",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2122.723601519762,
							["y"] = -207.53001311500302
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 162410171,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020605mon3_162410171"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}