return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17228506744874308",
			["startPort"] = "StoryStart",
			["endStory"] = "17228506801924729",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17228506801924729",
			["startPort"] = "Success",
			["endStory"] = "17228506744874311",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17228506744874308"] = {
			["isStoryNode"] = true,
			["key"] = "17228506744874308",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 900,
				["y"] = 388
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
		["17228506744874311"] = {
			["isStoryNode"] = true,
			["key"] = "17228506744874311",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1798,
				["y"] = 410
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17228506801924729"] = {
			["isStoryNode"] = true,
			["key"] = "17228506801924729",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1302,
				["y"] = 378
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
						["startQuest"] = "17228506801924730",
						["startPort"] = "QuestStart",
						["endQuest"] = "17229436909251233",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17229436909251233",
						["startPort"] = "Out",
						["endQuest"] = "17229437048412077",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17229437048412077",
						["startPort"] = "Out",
						["endQuest"] = "17228507290646758",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17229460055061341",
						["startPort"] = "Out",
						["endQuest"] = "17229459999921014",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17229459999921014",
						["startPort"] = "Out",
						["endQuest"] = "17228506801934733",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17228507290646758",
						["startPort"] = "Out",
						["endQuest"] = "17243182778481940",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17243182778481940",
						["startPort"] = "Out",
						["endQuest"] = "17268132087711736",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17268132087711736",
						["startPort"] = "PC",
						["endQuest"] = "17268132147632199",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17268132147632199",
						["startPort"] = "Out",
						["endQuest"] = "17229460055061341",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17268132087711736",
						["startPort"] = "Mobile",
						["endQuest"] = "17289957539447118",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17289957539447118",
						["startPort"] = "Out",
						["endQuest"] = "17229459999921014",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17228506801924730"] = {
						["key"] = "17228506801924730",
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
					["17228506801934733"] = {
						["key"] = "17228506801934733",
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
					["17228506801934736"] = {
						["key"] = "17228506801934736",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17228507290646758"] = {
						["key"] = "17228507290646758",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1568,
							["y"] = 318
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 203007,
							["MessageNote"] = "进入宠物界面",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Tab_Arm.EMScrollBox_TabItem:-2",
							["UICompName"] = "Btn",
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
							["MessageLoc"] = "DownRight",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17229436909251233"] = {
						["key"] = "17229436909251233",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1142,
							["y"] = 588
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["17229437048412077"] = {
						["key"] = "17229437048412077",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1214,
							["y"] = 216
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 203006,
							["MessageNote"] = "进入整备",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "BattleMain.ListView:1",
							["UICompName"] = "Btn_top",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = true,
							["IsForbidInAnim"] = false,
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
					["17229459999921014"] = {
						["key"] = "17229459999921014",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 2440,
							["y"] = 290
						},
						["propsData"] = {
							["MessageId"] = 203009,
							["MessageNote"] = "宠物界面解释",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "Left",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17229460055061341"] = {
						["key"] = "17229460055061341",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2130.274509803922,
							["y"] = 308.156862745098
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 203010,
							["MessageNote"] = "宠物出战",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:2.Btn_Replace",
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
					["17243182778481940"] = {
						["key"] = "17243182778481940",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1738,
							["y"] = 650
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 203008,
							["MessageNote"] = "查看宠物技能",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:2.List_Skill:1",
							["UICompName"] = "Btn",
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
					["17268132087711736"] = {
						["key"] = "17268132087711736",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 1876,
							["y"] = 420
						},
						["propsData"] = {}
					},
					["17268132147632199"] = {
						["key"] = "17268132147632199",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 2000.6666666666667,
							["y"] = 116.66666666666674
						},
						["propsData"] = {
							["MessageId"] = 203011,
							["MessageNote"] = "宠物技能释放",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "Upleft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17289957539447118"] = {
						["key"] = "17289957539447118",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2170.0084033613443,
							["y"] = 598.2051066580476
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 203010,
							["MessageNote"] = "宠物出战",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:2.Btn_Replace",
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}