return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17569706136521",
			["startPort"] = "StoryStart",
			["endStory"] = "1756970626911131",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1756970626911131",
			["startPort"] = "Success",
			["endStory"] = "17588790900882294599",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17588790900882294599",
			["startPort"] = "已合成",
			["endStory"] = "1758891549888507",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1758891549888507",
			["startPort"] = "Success",
			["endStory"] = "17569706136535",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17588790900882294599",
			["startPort"] = "未合成",
			["endStory"] = "17634699518921017796",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17634699518921017796",
			["startPort"] = "Success",
			["endStory"] = "17569706136535",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17569706136521"] = {
			["isStoryNode"] = true,
			["key"] = "17569706136521",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 803.3333332391433,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 200236
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17569706136535"] = {
			["isStoryNode"] = true,
			["key"] = "17569706136535",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2120.386112748026,
				["y"] = 247.99227909623767
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1756970626911131"] = {
			["isStoryNode"] = true,
			["key"] = "1756970626911131",
			["type"] = "GameModeCompleteNode",
			["name"] = "完成目标",
			["pos"] = {
				["x"] = 1135.0204081314894,
				["y"] = 293.9591837370212
			},
			["propsData"] = {
				["QuestId"] = 20023601,
				["QuestDescriptionComment"] = "完成委托密函",
				["QuestDescription"] = "Description_200236_1",
				["QuestDeatil"] = "Content_200236_1",
				["TaskRegionReName"] = "UI_REGION_NAME_2101",
				["TaskSubRegionReName"] = "UI_SUBREGION_NAME_210101",
				["InRegionExportName"] = "",
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["GameModeTargetId"] = 20023601,
				["GameModeKeyCount"] = 1,
				["QuestHintMessageId"] = 0,
				["IsShowGuide"] = false,
				["GuideType"] = "P",
				["GuidePointName"] = "",
				["InterfaceJumpId"] = 66
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17588790900882294599"] = {
			["isStoryNode"] = true,
			["key"] = "17588790900882294599",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1437.6958423239203,
				["y"] = 232.04663640664285
			},
			["propsData"] = {
				["QuestId"] = 20023603,
				["QuestDescriptionComment"] = "完成委托密函",
				["QuestDescription"] = "Description_200236_1",
				["QuestDeatil"] = "Content_200236_1",
				["TaskRegionReName"] = "UI_REGION_NAME_2101",
				["TaskSubRegionReName"] = "UI_SUBREGION_NAME_210101",
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
						["startQuest"] = "17588790900882294600",
						["startPort"] = "QuestStart",
						["endQuest"] = "17588790993122294850",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17588790993122294850",
						["startPort"] = "Success",
						["endQuest"] = "17588791417252295832",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17588790993122294850",
						["startPort"] = "Fail",
						["endQuest"] = "17588791502962296224",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17588790900882294600"] = {
						["key"] = "17588790900882294600",
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
					["17588790900882294603"] = {
						["key"] = "17588790900882294603",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2203.030312231348,
							["y"] = 319.6969693933819
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17588790900882294606"] = {
						["key"] = "17588790900882294606",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2162.1212219527856,
							["y"] = 586.3636381151043
						},
						["propsData"] = {}
					},
					["17588790993122294850"] = {
						["key"] = "17588790993122294850",
						["type"] = "ConditionNode",
						["name"] = "条件节点",
						["pos"] = {
							["x"] = 1209.7575838376813,
							["y"] = 272.4561429510066
						},
						["propsData"] = {
							["ConditionId"] = 20023600
						}
					},
					["17588791417252295832"] = {
						["key"] = "17588791417252295832",
						["type"] = "QuestConditionNode",
						["name"] = "QuestCondition",
						["pos"] = {
							["x"] = 1637.16914368678,
							["y"] = 202.2647581657663
						},
						["propsData"] = {
							["PortName"] = "已合成"
						}
					},
					["17588791502962296224"] = {
						["key"] = "17588791502962296224",
						["type"] = "QuestConditionNode",
						["name"] = "QuestCondition",
						["pos"] = {
							["x"] = 1606.2919502561208,
							["y"] = 393.2748537629232
						},
						["propsData"] = {
							["PortName"] = "未合成"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1758891549888507"] = {
			["isStoryNode"] = true,
			["key"] = "1758891549888507",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1749.5411248871728,
				["y"] = 209.954201071112
			},
			["propsData"] = {
				["QuestId"] = 20023604,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200236_2",
				["QuestDeatil"] = "Content_200236_2",
				["TaskRegionReName"] = "UI_REGION_NAME_2101",
				["TaskSubRegionReName"] = "UI_SUBREGION_NAME_210101",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
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
						["startQuest"] = "1758891549888508",
						["startPort"] = "QuestStart",
						["endQuest"] = "1758891549888511",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1758891549888508"] = {
						["key"] = "1758891549888508",
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
					["1758891549888511"] = {
						["key"] = "1758891549888511",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1352,
							["y"] = 302
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1758891549888514"] = {
						["key"] = "1758891549888514",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["17634699518921017796"] = {
			["isStoryNode"] = true,
			["key"] = "17634699518921017796",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1747.9581150838906,
				["y"] = 518.2145850235514
			},
			["propsData"] = {
				["QuestId"] = 20023602,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200236_2",
				["QuestDeatil"] = "Content_200236_2",
				["TaskRegionReName"] = "UI_REGION_NAME_2101",
				["TaskSubRegionReName"] = "UI_SUBREGION_NAME_210101",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
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
				["JumpId"] = 4
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17634699518921017797",
						["startPort"] = "QuestStart",
						["endQuest"] = "17634700080691019132",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634700080691019132",
						["startPort"] = "Success",
						["endQuest"] = "17634699518921017800",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17634699518921017797"] = {
						["key"] = "17634699518921017797",
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
					["17634699518921017800"] = {
						["key"] = "17634699518921017800",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1590,
							["y"] = 328
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17634699518921017803"] = {
						["key"] = "17634699518921017803",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17634700080691019132"] = {
						["key"] = "17634700080691019132",
						["type"] = "AsyncConditionNode",
						["name"] = "异步等待条件完成",
						["pos"] = {
							["x"] = 1170,
							["y"] = 332
						},
						["propsData"] = {
							["ConditionId"] = 20023600
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}