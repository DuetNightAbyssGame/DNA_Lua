return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1745049350247897534",
			["startPort"] = "StoryStart",
			["endStory"] = "1745049350248897536",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1745049350248897536",
			["startPort"] = "Success",
			["endStory"] = "1745049350248897535",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1745049350247897534"] = {
			["isStoryNode"] = true,
			["key"] = "1745049350247897534",
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
		["1745049350248897535"] = {
			["isStoryNode"] = true,
			["key"] = "1745049350248897535",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1611.25,
				["y"] = 301.875
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1745049350248897536"] = {
			["isStoryNode"] = true,
			["key"] = "1745049350248897536",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1194,
				["y"] = 312
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
						["startQuest"] = "1745049350248897542",
						["startPort"] = "Out",
						["endQuest"] = "1745049350248897543",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745049350248897537",
						["startPort"] = "Out",
						["endQuest"] = "1745049350248897538",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745049350248897539",
						["startPort"] = "QuestStart",
						["endQuest"] = "1745049350248897537",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745049350248897538",
						["startPort"] = "Out",
						["endQuest"] = "1745049350248897540",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1745049350248897537"] = {
						["key"] = "1745049350248897537",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1040.8001307942438,
							["y"] = 153.1325646051481
						},
						["propsData"] = {
							["WaitTime"] = 1.5
						}
					},
					["1745049350248897538"] = {
						["key"] = "1745049350248897538",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1367.3001307942436,
							["y"] = 173.67423127181476
						},
						["propsData"] = {
							["GuideId"] = 69
						}
					},
					["1745049350248897539"] = {
						["key"] = "1745049350248897539",
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
					["1745049350248897540"] = {
						["key"] = "1745049350248897540",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1799.3808857808858,
							["y"] = 290.68717948717944
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1745049350248897541"] = {
						["key"] = "1745049350248897541",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1745049350248897542"] = {
						["key"] = "1745049350248897542",
						["type"] = "ShowGuideButtonNode",
						["name"] = "点击查阅词条",
						["pos"] = {
							["x"] = 1167.08663003663,
							["y"] = 303.9807692307693
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300402,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.ListView:9",
							["UICompName"] = "Button_Key",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["UICompSizeOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "DownLeft",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745049350248897543"] = {
						["key"] = "1745049350248897543",
						["type"] = "ShowGuideTextNode",
						["name"] = "告知玩家可以查阅词条Tips",
						["pos"] = {
							["x"] = 1489.1397908279182,
							["y"] = 295.80289024700824
						},
						["propsData"] = {
							["MessageId"] = 300403,
							["MessageNote"] = "在这里可以查阅到故事台词中的一些神秘的词语解释。【待包装】",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "Middle",
							["GuidemanHead"] = "Bai_Idle"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}