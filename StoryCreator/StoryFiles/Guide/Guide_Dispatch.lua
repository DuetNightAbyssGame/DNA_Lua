return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17230167378801",
			["startPort"] = "StoryStart",
			["endStory"] = "17450574890042006",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17450574890042006",
			["startPort"] = "Success",
			["endStory"] = "17230167378815",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17230167378801"] = {
			["isStoryNode"] = true,
			["key"] = "17230167378801",
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
		["17230167378815"] = {
			["isStoryNode"] = true,
			["key"] = "17230167378815",
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
		["17450574890042006"] = {
			["isStoryNode"] = true,
			["key"] = "17450574890042006",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1668,
				["y"] = 334
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
						["startQuest"] = "17450574890042007",
						["startPort"] = "QuestStart",
						["endQuest"] = "17450575011202542",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17450575011202542",
						["startPort"] = "Out",
						["endQuest"] = "1745057586836546692",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057807238547393",
						["startPort"] = "Out",
						["endQuest"] = "1745057807053547389",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057807053547389",
						["startPort"] = "Out",
						["endQuest"] = "1745057807449547397",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057807449547397",
						["startPort"] = "Out",
						["endQuest"] = "1745057806803547385",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057806803547385",
						["startPort"] = "Out",
						["endQuest"] = "1745057806460547381",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057806460547381",
						["startPort"] = "Out",
						["endQuest"] = "1745057806102547377",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057806102547377",
						["startPort"] = "Out",
						["endQuest"] = "1745057805668547373",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057805668547373",
						["startPort"] = "Out",
						["endQuest"] = "1745057853014548798",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057853014548798",
						["startPort"] = "Out",
						["endQuest"] = "1745057859586549104",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057859586549104",
						["startPort"] = "Out",
						["endQuest"] = "17450574890042010",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1745057586836546692",
						["startPort"] = "Out",
						["endQuest"] = "17651745869761062",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17651745869761062",
						["startPort"] = "Out",
						["endQuest"] = "1745057805015547323",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745057805015547323",
						["startPort"] = "Out",
						["endQuest"] = "1745057807238547393",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17450574890042007"] = {
						["key"] = "17450574890042007",
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
					["17450574890042010"] = {
						["key"] = "17450574890042010",
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
					["17450574890042013"] = {
						["key"] = "17450574890042013",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17450575011202542"] = {
						["key"] = "17450575011202542",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1139,
							["y"] = 116.75000000000003
						},
						["propsData"] = {
							["MessageId"] = 320001,
							["MessageNote"] = "",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1745057586836546692"] = {
						["key"] = "1745057586836546692",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1129.848484848485,
							["y"] = 292.5000000000001
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320002,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain.Entrance_Dispatch",
							["UICompName"] = "Btn_Click",
							["GamePadWidgetName"] = "Icon_Key",
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
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057805015547323"] = {
						["key"] = "1745057805015547323",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1547.527054797888,
							["y"] = 288.571428597379
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320003,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain",
							["UICompName"] = "Dispatch_List:1",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057805668547373"] = {
						["key"] = "1745057805668547373",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2098.7373737373737,
							["y"] = 452.77777777777777
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320010,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain.Dispatch_Detail:1",
							["UICompName"] = "Text_Percent01",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["UICompSizeOffset"] = {
								["X"] = 300,
								["Y"] = 80
							},
							["UICompLocOffset"] = {
								["X"] = 20,
								["Y"] = 0
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057806102547377"] = {
						["key"] = "1745057806102547377",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1797.598484848485,
							["y"] = 455
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320009,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain.Dispatch_AgentList:1.Btn_Auto",
							["UICompName"] = "Button_Area",
							["GamePadWidgetName"] = "Key_GamePad",
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
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057806460547381"] = {
						["key"] = "1745057806460547381",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1464.848484848485,
							["y"] = 453.75
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320008,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain",
							["UICompName"] = "Dispatch_AgentList:1",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057806803547385"] = {
						["key"] = "1745057806803547385",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1129.8484848484852,
							["y"] = 453.8888888888889
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320007,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain.Dispatch_Detail:1.Btn_Select",
							["UICompName"] = "Button_Area",
							["GamePadWidgetName"] = "Key_GamePad",
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057807053547389"] = {
						["key"] = "1745057807053547389",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2106.098484848485,
							["y"] = 291.2500000000001
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320005,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain",
							["UICompName"] = "Dispatch_Detail:1",
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057807238547393"] = {
						["key"] = "1745057807238547393",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1793.598484848485,
							["y"] = 292.5000000000001
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320004,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain",
							["UICompName"] = "Dispatch_Detail:1",
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057807449547397"] = {
						["key"] = "1745057807449547397",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2416.098484848485,
							["y"] = 292.5000000000001
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320006,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain.Dispatch_Detail:1.Btn_Go",
							["UICompName"] = "Button_Area",
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
							["MessageLoc"] = "UpLeft",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057853014548798"] = {
						["key"] = "1745057853014548798",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2411.098484848485,
							["y"] = 453.75
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320011,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain.Dispatch_Detail:1.Btn_Confirm",
							["UICompName"] = "Button_Area",
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
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745057859586549104"] = {
						["key"] = "1745057859586549104",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 2417.348484848485,
							["y"] = 631.25
						},
						["propsData"] = {
							["MessageId"] = 320012,
							["MessageNote"] = "",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17651745869761062"] = {
						["key"] = "17651745869761062",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1344.9694931576475,
							["y"] = 184.05099250129723
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 320003,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "LevelMapMain.Dispatch_List:1.List_Dispatch:1",
							["UICompName"] = "Btn_Click",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = true,
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
							["MessageLoc"] = "Right",
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