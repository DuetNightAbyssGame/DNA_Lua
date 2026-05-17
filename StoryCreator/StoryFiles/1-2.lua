return {
	["storyName"] = "未命名任务",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "story_16759276611290",
			["startPort"] = "StoryStart",
			["endStory"] = "story_16759276668144",
			["endPort"] = "In"
		},
		{
			["startStory"] = "story_16759276668144",
			["startPort"] = "Success",
			["endStory"] = "story_16759276611292",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["story_16759276611290"] = {
			["isStoryNode"] = true,
			["key"] = "story_16759276611290",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 153,
				["y"] = 170
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
		["story_16759276611292"] = {
			["isStoryNode"] = true,
			["key"] = "story_16759276611292",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1145,
				["y"] = 162
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["story_16759276668144"] = {
			["isStoryNode"] = true,
			["key"] = "story_16759276668144",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 491,
				["y"] = 108.59615384615384
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
				["bIsNotifyGameMode"] = false,
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
						["startQuest"] = "quest_16759276668148",
						["startPort"] = "QuestStart",
						["endQuest"] = "1715916489140364",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17159165288731749",
						["startPort"] = "Out",
						["endQuest"] = "quest_167592766681410",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1715916489140364",
						["startPort"] = "Out",
						["endQuest"] = "17159165288731749",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["quest_16759276668148"] = {
						["key"] = "quest_16759276668148",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -156.1538461538462,
							["y"] = 140
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_167592766681410"] = {
						["key"] = "quest_167592766681410",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1066.7692307692307,
							["y"] = 123.15384615384616
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["quest_167592766681412"] = {
						["key"] = "quest_167592766681412",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1103.2307692307693,
							["y"] = 277.9230769230769
						},
						["propsData"] = {}
					},
					["1715596373966146387"] = {
						["key"] = "1715596373966146387",
						["type"] = "SetPlayerStatusNode",
						["name"] = "设置玩家状态",
						["pos"] = {
							["x"] = 442.07789003159917,
							["y"] = -248.36298550284107
						},
						["propsData"] = {
							["HPPercent"] = -1,
							["ESPercent"] = -1,
							["SPPercent"] = -1,
							["BuffList"] = {
								{
									["Id"] = 11,
									["LastTime"] = -1,
									["Value"] = -1
								}
							},
							["RecoverPlayer"] = false
						}
					},
					["1715916489140364"] = {
						["key"] = "1715916489140364",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 133.39504048583007,
							["y"] = 144.29757085020236
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["17159165288731749"] = {
						["key"] = "17159165288731749",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 688.7796558704455,
							["y"] = 156.98987854251013
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300302,
							["MessageNote"] = "点击<H>“整备”</>进入整备系统。",
							["DelayTime"] = 0.5,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.ListView:1",
							["UICompName"] = "Btn_top",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
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
							["MessageLoc"] = "Left",
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