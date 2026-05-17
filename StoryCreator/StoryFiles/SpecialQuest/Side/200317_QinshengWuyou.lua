return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17730566197758379121",
			["startPort"] = "StoryStart",
			["endStory"] = "17730566204228379139",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17730566204228379139",
			["startPort"] = "Success",
			["endStory"] = "17730566197768379124",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17730566197758379121"] = {
			["isStoryNode"] = true,
			["key"] = "17730566197758379121",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1316.9230769230771,
				["y"] = 286.15384615384613
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
		["17730566197768379124"] = {
			["isStoryNode"] = true,
			["key"] = "17730566197768379124",
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
		["17730566204228379139"] = {
			["isStoryNode"] = true,
			["key"] = "17730566204228379139",
			["type"] = "StoryNode",
			["name"] = "跟随无由生",
			["pos"] = {
				["x"] = 1796,
				["y"] = 338
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_20031709_01",
				["QuestDeatil"] = "Content_20031709_01",
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
				["SubRegionId"] = 104504,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17730566204248379144",
						["startPort"] = "QuestStart",
						["endQuest"] = "17730566204248379147",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566204248379144",
						["startPort"] = "QuestStart",
						["endQuest"] = "17730566204248379148",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566204248379148",
						["startPort"] = "Out",
						["endQuest"] = "17730566204248379152",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566204248379152",
						["startPort"] = "Out",
						["endQuest"] = "17730566204248379153",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566204248379144",
						["startPort"] = "QuestStart",
						["endQuest"] = "17730566438238379933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566438238379933",
						["startPort"] = "Out",
						["endQuest"] = "17730566204248379146",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17730566204248379148",
						["startPort"] = "Out",
						["endQuest"] = "17730566204248379150",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566204248379152",
						["startPort"] = "Out",
						["endQuest"] = "17730566204248379149",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566204248379153",
						["startPort"] = "Out",
						["endQuest"] = "17730566204248379151",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773314766735853361",
						["startPort"] = "Out",
						["endQuest"] = "1773314780850853759",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773314789242854121",
						["startPort"] = "Out",
						["endQuest"] = "1773314803335854454",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773314809470854651",
						["startPort"] = "Out",
						["endQuest"] = "1773314818381854931",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773314818381854931",
						["startPort"] = "Out",
						["endQuest"] = "17730566351758379723",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566204248379144",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773314766735853361",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566204248379144",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773314789242854121",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730566204248379144",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773314809470854651",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17730566204248379144"] = {
						["key"] = "17730566204248379144",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 887,
							["y"] = 489.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17730566204248379145"] = {
						["key"] = "17730566204248379145",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3110.5,
							["y"] = 453
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17730566204248379146"] = {
						["key"] = "17730566204248379146",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2203.684210526316,
							["y"] = 1493.8345864661655
						},
						["propsData"] = {}
					},
					["17730566204248379147"] = {
						["key"] = "17730566204248379147",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1154,
							["y"] = -45.5
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "200317TraceStart",
							["UnitId"] = -1
						}
					},
					["17730566204248379148"] = {
						["key"] = "17730566204248379148",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1320.7815280956017,
							["y"] = 468.11009407576887
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2420165,
							["StateId"] = 1210352,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17730566204248379149"] = {
						["key"] = "17730566204248379149",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2120.2259725400463,
							["y"] = 104.21564963132447
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_BP_WUyouQinsheng02"
						}
					},
					["17730566204248379150"] = {
						["key"] = "17730566204248379150",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1625.125972540046,
							["y"] = -64.8621281464533
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_WUyouQinsheng01"
						}
					},
					["17730566204248379151"] = {
						["key"] = "17730566204248379151",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2671.4759725400463,
							["y"] = 209.6378718535467
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_WUyouQinsheng03"
						}
					},
					["17730566204248379152"] = {
						["key"] = "17730566204248379152",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1750.503750317824,
							["y"] = 476.6656496313245
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2420160,
							["StateId"] = 1210352,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17730566204248379153"] = {
						["key"] = "17730566204248379153",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 2240.940258254332,
							["y"] = 581.1339035995785
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2420161,
							["StateId"] = 1210352,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["17730566351758379723"] = {
						["key"] = "17730566351758379723",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2187.928571428571,
							["y"] = 1157.4642857142858
						},
						["propsData"] = {}
					},
					["17730566438238379933"] = {
						["key"] = "17730566438238379933",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 958.2142857142857,
							["y"] = 1256.5
						},
						["propsData"] = {}
					},
					["1773314766735853361"] = {
						["key"] = "1773314766735853361",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1309.75,
							["y"] = 722.25
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2420166,
							["StateId"] = 1210321,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["1773314780850853759"] = {
						["key"] = "1773314780850853759",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1666,
							["y"] = 722.8055555555557
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_WUyouQinsheng01"
						}
					},
					["1773314789242854121"] = {
						["key"] = "1773314789242854121",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1311.8660361377752,
							["y"] = 919.2142857142858
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2420162,
							["StateId"] = 1210321,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["1773314803335854454"] = {
						["key"] = "1773314803335854454",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1761.5896551325613,
							["y"] = 920.8189359267733
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_BP_WUyouQinsheng02"
						}
					},
					["1773314809470854651"] = {
						["key"] = "1773314809470854651",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1333.2946075663465,
							["y"] = 1100.642857142857
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 2420163,
							["StateId"] = 1210321,
							["IsGuideEnable"] = false,
							["GuidePointName"] = ""
						}
					},
					["1773314818381854931"] = {
						["key"] = "1773314818381854931",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1737.7390520107906,
							["y"] = 1128.7380952380952
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "BP_WUyouQinsheng03"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}