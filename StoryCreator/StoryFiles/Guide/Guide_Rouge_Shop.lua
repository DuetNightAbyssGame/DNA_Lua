return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732783210535471079",
			["startPort"] = "StoryStart",
			["endStory"] = "1732783210535471081",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732783210535471081",
			["startPort"] = "Success",
			["endStory"] = "1732783210535471080",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732783210535471079"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210535471079",
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
		["1732783210535471080"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210535471080",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1836,
				["y"] = 334
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1732783210535471081"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210535471081",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1298,
				["y"] = 320
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
						["startQuest"] = "1732783210535471082",
						["startPort"] = "QuestStart",
						["endQuest"] = "17228405652113912",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17228405849334319",
						["startPort"] = "Out",
						["endQuest"] = "1732783210535471083",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17228405652113912",
						["startPort"] = "Out",
						["endQuest"] = "172899607811415006",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "172899607811415006",
						["startPort"] = "PC",
						["endQuest"] = "17228405849334319",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172899607811415006",
						["startPort"] = "Mobile",
						["endQuest"] = "172899607222814805",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172899607222814805",
						["startPort"] = "Out",
						["endQuest"] = "1732783210535471083",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17228405652113912"] = {
						["key"] = "17228405652113912",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1120.941176470588,
							["y"] = 300.0294117647058
						},
						["propsData"] = {
							["MessageId"] = 301901,
							["MessageNote"] = "在神秘行商处，可以花费一定数量的余烬，购买烛芯和遗物。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17228405849334319"] = {
						["key"] = "17228405849334319",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1509.1764705882351,
							["y"] = 296.4999999999999
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301902,
							["MessageNote"] = "点击可以选择想要获取的烛芯",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeShop.Common_Tab.EMScrollBox_TabItem:2",
							["UICompName"] = "Btn",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
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
							["MessageLoc"] = "Down",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["172899607222814805"] = {
						["key"] = "172899607222814805",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1540.361344537815,
							["y"] = 479.6168713639299
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301902,
							["MessageNote"] = "点击可以选择想要获取的烛芯",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeShop.Common_Tab.EMScrollBox_TabItem:2",
							["UICompName"] = "Btn",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["172899607811415006"] = {
						["key"] = "172899607811415006",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 1174.4789915966385,
							["y"] = 498.322753716871
						},
						["propsData"] = {}
					},
					["1732783210535471082"] = {
						["key"] = "1732783210535471082",
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
					["1732783210535471083"] = {
						["key"] = "1732783210535471083",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1995.2941176470588,
							["y"] = 317.6470588235294
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210535471084"] = {
						["key"] = "1732783210535471084",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2658.823529411765,
							["y"] = 707.0588235294117
						},
						["propsData"] = {}
					},
					["1732783210535471085"] = {
						["key"] = "1732783210535471085",
						["type"] = "ShowGuideButtonNode",
						["name"] = "物品列表",
						["pos"] = {
							["x"] = 1063.0499283597928,
							["y"] = 93.15693382010045
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300006,
							["MessageNote"] = "点击刚才获得的新武器。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew.TileView_Select_Role:2",
							["UICompName"] = "Bg01",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1732783210535471086"] = {
						["key"] = "1732783210535471086",
						["type"] = "ShowGuideButtonNode",
						["name"] = "动态界面按钮",
						["pos"] = {
							["x"] = 1629.2461983566627,
							["y"] = 109.37610445456357
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300009,
							["MessageNote"] = "点击“+”号，打开升级弹窗。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew.SubUI_Panel:2.Btn_Lvup",
							["UICompName"] = "Button_Area",
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
					},
					["1732783210535471087"] = {
						["key"] = "1732783210535471087",
						["type"] = "ShowGuideButtonNode",
						["name"] = "界面内弹窗",
						["pos"] = {
							["x"] = 1906.1615244099194,
							["y"] = 106.88811268621237
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300010,
							["MessageNote"] = "点击“+”号，可以提升升级的目标等级",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "CommonDialog.VB_Node:1.Btn_Add",
							["UICompName"] = "Button_Area",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1732783210535471088"] = {
						["key"] = "1732783210535471088",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1041.8384755900806,
							["y"] = -71.83764291610203
						},
						["propsData"] = {
							["MessageId"] = 300004,
							["MessageNote"] = "在近战武器配置界面中，可以查看近战武器的属性、为近战武器升级、替换其他近战武器等。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1732783210535471089"] = {
						["key"] = "1732783210535471089",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1316.197449949055,
							["y"] = -73.37610445456352
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300002,
							["MessageNote"] = "点击<H>“整备”</>进入整备系统。",
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
							["MessageLoc"] = "Down",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1732783210535471090"] = {
						["key"] = "1732783210535471090",
						["type"] = "ShowGuideButtonNode",
						["name"] = "UI内ListView",
						["pos"] = {
							["x"] = 1619.7871935387986,
							["y"] = -60.940207018666456
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300003,
							["MessageNote"] = "点击“近战武器”页签，进行近战武器配置。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew.ListView_Tab:3",
							["UICompName"] = "Text_1",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1732783210535471091"] = {
						["key"] = "1732783210535471091",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1357.8994835476399,
							["y"] = 98.31708741104171
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300005,
							["MessageNote"] = "点击“替换”，进行近战武器的替换。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew.Btn_Confirm_1",
							["UICompName"] = "Button_Area",
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
							["MessageLoc"] = "Up",
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