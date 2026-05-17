return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17533583198601267431",
			["startPort"] = "StoryStart",
			["endStory"] = "17533583198611267433",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17533583198611267433",
			["startPort"] = "Success",
			["endStory"] = "17533583198611267432",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17533583198601267431"] = {
			["isStoryNode"] = true,
			["key"] = "17533583198601267431",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1674.8,
				["y"] = 310.40000000000003
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
		["17533583198611267432"] = {
			["isStoryNode"] = true,
			["key"] = "17533583198611267432",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2330.8,
				["y"] = 295.2
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17533583198611267433"] = {
			["isStoryNode"] = true,
			["key"] = "17533583198611267433",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2015.2250000000001,
				["y"] = 303.34999999999997
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
				["SubRegionId"] = 104108,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_2090245",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17533583198611267434",
						["startPort"] = "QuestStart",
						["endQuest"] = "1753691648347932",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753691648347932",
						["startPort"] = "Out",
						["endQuest"] = "17536916572561126",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17536916572561126",
						["startPort"] = "Out",
						["endQuest"] = "1763467417497674344",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763467417497674344",
						["startPort"] = "Out",
						["endQuest"] = "17536916621051230",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17533583198611267434",
						["startPort"] = "QuestStart",
						["endQuest"] = "1767786512365386",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767786512365386",
						["startPort"] = "Out",
						["endQuest"] = "17533583198611267436",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17533583198611267434"] = {
						["key"] = "17533583198611267434",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 841.9658385093169,
							["y"] = 382.54347826086956
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17533583198611267435"] = {
						["key"] = "17533583198611267435",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2287.2422360248447,
							["y"] = 384.5776397515528
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17533583198611267436"] = {
						["key"] = "17533583198611267436",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2282.5,
							["y"] = 599.5
						},
						["propsData"] = {}
					},
					["1753691648347932"] = {
						["key"] = "1753691648347932",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1131.4107142857144,
							["y"] = 384.4857142857142
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "Monster_BiAn_2090246",
							["StaticCreatorIdList"] = {
								2090246,
								2090247
							}
						}
					},
					["17536916572561126"] = {
						["key"] = "17536916572561126",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1443.8392857142858,
							["y"] = 375.2714285714285
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "N",
							["GuideName"] = "Mechanism_2090245",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2090246,
								2090247
							}
						}
					},
					["17536916621051230"] = {
						["key"] = "17536916621051230",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2014.5773809523812,
							["y"] = 379.58095238095234
						},
						["propsData"] = {}
					},
					["1763467417497674344"] = {
						["key"] = "1763467417497674344",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1710.461846087854,
							["y"] = 384.84871100432537
						},
						["propsData"] = {
							["WaitTime"] = 0
						}
					},
					["1767786512365386"] = {
						["key"] = "1767786512365386",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1610.5673468090517,
							["y"] = 613.677932066662
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