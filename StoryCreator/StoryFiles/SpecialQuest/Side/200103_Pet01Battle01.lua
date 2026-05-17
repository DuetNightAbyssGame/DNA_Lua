return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17509042459681",
			["startPort"] = "StoryStart",
			["endStory"] = "1750904500558459",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1750904500558459",
			["startPort"] = "Success",
			["endStory"] = "17509042459695",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1750904500558459",
			["startPort"] = "Fail",
			["endStory"] = "17509042459695",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17509042459681"] = {
			["isStoryNode"] = true,
			["key"] = "17509042459681",
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
		["17509042459695"] = {
			["isStoryNode"] = true,
			["key"] = "17509042459695",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1566,
				["y"] = 318
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1750904500558459"] = {
			["isStoryNode"] = true,
			["key"] = "1750904500558459",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1192,
				["y"] = 306
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200103_3",
				["QuestDeatil"] = "Content_200103_3",
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
						["startQuest"] = "1750904502100577",
						["startPort"] = "Out",
						["endQuest"] = "1750904502100578",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750904500558460",
						["startPort"] = "QuestStart",
						["endQuest"] = "17509068522184661",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17509068522184661",
						["startPort"] = "Out",
						["endQuest"] = "17509234890661974342",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17509234890661974342",
						["startPort"] = "Out",
						["endQuest"] = "1750904500559474",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1750904502100578",
						["startPort"] = "Out",
						["endQuest"] = "17509346453257917173",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17509346453257917173",
						["startPort"] = "Out",
						["endQuest"] = "175144300784814013181",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750904500558460",
						["startPort"] = "QuestStart",
						["endQuest"] = "1750904502100577",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1750904500558460"] = {
						["key"] = "1750904500558460",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1049.25,
							["y"] = 265.75
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1750904500559467"] = {
						["key"] = "1750904500559467",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2756.948076923077,
							["y"] = 213.14423076923077
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1750904500559474"] = {
						["key"] = "1750904500559474",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1958.786739576214,
							["y"] = 435.18549783549776
						},
						["propsData"] = {}
					},
					["1750904502100577"] = {
						["key"] = "1750904502100577",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成怪物",
						["pos"] = {
							["x"] = 1381.7144129869548,
							["y"] = 251.376299243954
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240841,
								1240842
							}
						}
					},
					["1750904502100578"] = {
						["key"] = "1750904502100578",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1663.9600550652967,
							["y"] = 239.17911711023112
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1240841,
								1240842
							}
						}
					},
					["17509068522184661"] = {
						["key"] = "17509068522184661",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1386.7408486540248,
							["y"] = 421.24140602962217
						},
						["propsData"] = {}
					},
					["17509234890661974342"] = {
						["key"] = "17509234890661974342",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁怪物",
						["pos"] = {
							["x"] = 1671.2177897631946,
							["y"] = 430.78877680520645
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240841,
								1240842
							}
						}
					},
					["17509346453257917173"] = {
						["key"] = "17509346453257917173",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1921.6768907563028,
							["y"] = 251.44285714285706
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["175144300784814013181"] = {
						["key"] = "175144300784814013181",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2198,
							["y"] = 253.71428571428572
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}