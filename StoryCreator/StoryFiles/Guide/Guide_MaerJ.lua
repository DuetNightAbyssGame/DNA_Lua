return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "175533314100413759851",
			["startPort"] = "StoryStart",
			["endStory"] = "175533314100413759853",
			["endPort"] = "In"
		},
		{
			["startStory"] = "175533314100413759853",
			["startPort"] = "Success",
			["endStory"] = "175533314100413759852",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["175533314100413759851"] = {
			["isStoryNode"] = true,
			["key"] = "175533314100413759851",
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
		["175533314100413759852"] = {
			["isStoryNode"] = true,
			["key"] = "175533314100413759852",
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
		["175533314100413759853"] = {
			["isStoryNode"] = true,
			["key"] = "175533314100413759853",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1175.25,
				["y"] = 294.19565217391306
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
						["startQuest"] = "175533314100413759857",
						["startPort"] = "Out",
						["endQuest"] = "175533314100413759858",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175533314100413759865",
						["startPort"] = "Out",
						["endQuest"] = "175533314100413759863",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175533314100413759864",
						["startPort"] = "Out",
						["endQuest"] = "175533314100413759865",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175533314100413759869",
						["startPort"] = "PC",
						["endQuest"] = "175533314100413759870",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175533314100413759869",
						["startPort"] = "Mobile",
						["endQuest"] = "175533314100413759871",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175533314100413759861",
						["startPort"] = "Out",
						["endQuest"] = "175533314100413759862",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175533314100413759870",
						["startPort"] = "Out",
						["endQuest"] = "175533314100413759864",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175533314100413759871",
						["startPort"] = "Out",
						["endQuest"] = "175533314100413759864",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175533314100413759862",
						["startPort"] = "Out",
						["endQuest"] = "175533314100413759873",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175533217316111574976",
						["startPort"] = "MouseAndKeyboard",
						["endQuest"] = "175533314100413759868",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "175533314100413759859",
						["startPort"] = "Out",
						["endQuest"] = "175533314100413759855",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "175533314100413759854",
						["startPort"] = "QuestStart",
						["endQuest"] = "175533314100413759859",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["175533217316111574976"] = {
						["key"] = "175533217316111574976",
						["type"] = "InputDeviceBranchNode",
						["name"] = "输入设备分支",
						["pos"] = {
							["x"] = 1064.4719705399004,
							["y"] = 143.49075719991947
						},
						["propsData"] = {}
					},
					["175533314100413759854"] = {
						["key"] = "175533314100413759854",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 799.0389016018307,
							["y"] = 307.07093821510296
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["175533314100413759855"] = {
						["key"] = "175533314100413759855",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2029.3842253855983,
							["y"] = 223.67388035305657
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["175533314100413759856"] = {
						["key"] = "175533314100413759856",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3026.5,
							["y"] = 943
						},
						["propsData"] = {}
					},
					["175533314100413759857"] = {
						["key"] = "175533314100413759857",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1914.569872061577,
							["y"] = -72.93706241597963
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300003,
							["MessageNote"] = "点击“近战武器”页签，进行近战武器配置。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew.ListView_Tab:3",
							["UICompName"] = "Text_2",
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
					["175533314100413759858"] = {
						["key"] = "175533314100413759858",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2245.645386935719,
							["y"] = -59.76936055262564
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300005,
							["MessageNote"] = "点击“替换”，进行近战武器的替换。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew..Panel_Tab:1",
							["UICompName"] = "Btn_Confirm_1",
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
					["175533314100413759859"] = {
						["key"] = "175533314100413759859",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1581.9789155479302,
							["y"] = 302.2619465649158
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303301,
							["MessageNote"] = "点击“近战武器”页签，进行近战武器配置。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:1.Btn_Unlock",
							["UICompName"] = "Btn_Area",
							["GamePadWidgetName"] = "Key_Unlock",
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
					["175533314100413759860"] = {
						["key"] = "175533314100413759860",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1415.4563543724848,
							["y"] = -18.793112333461494
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
							["HighLightUIPath"] = "ArmoryMain.Btn_Confirm_1",
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
					},
					["175533314100413759861"] = {
						["key"] = "175533314100413759861",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1344.7737727216238,
							["y"] = 1080.0770978668165
						},
						["propsData"] = {
							["MessageId"] = 300008,
							["MessageNote"] = "【待包装】新替换的武器等级较低，提高武器的等级可以提升武器的输出能力。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["175533314100413759862"] = {
						["key"] = "175533314100413759862",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1645.5803753743658,
							["y"] = 1086.3019638079231
						},
						["propsData"] = {
							["MessageId"] = 300011,
							["MessageNote"] = "武器升级需消耗一定的银币以及武器说明书。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["175533314100413759863"] = {
						["key"] = "175533314100413759863",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 4179.520320567244,
							["y"] = 210.289195562742
						},
						["propsData"] = {
							["MessageId"] = 300016,
							["MessageNote"] = "物理攻击",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["175533314100413759864"] = {
						["key"] = "175533314100413759864",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 3601.562486652005,
							["y"] = 198.54156732585227
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300014,
							["MessageNote"] = "触发效果",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:1.Btn_Info",
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["175533314100413759865"] = {
						["key"] = "175533314100413759865",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 3893.760288849807,
							["y"] = 206.4031793979908
						},
						["propsData"] = {
							["MessageId"] = 300015,
							["MessageNote"] = "元素攻击",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["175533314100413759866"] = {
						["key"] = "175533314100413759866",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 2519.1882155818475,
							["y"] = -43.124393378939686
						},
						["propsData"] = {
							["MessageId"] = 300013,
							["MessageNote"] = "触发概率",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["175533314100413759867"] = {
						["key"] = "175533314100413759867",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1702.2862686683043,
							["y"] = 846.8522872884774
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300017,
							["MessageNote"] = "在这里可以打开武器列表。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Btn_Selective",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["175533314100413759868"] = {
						["key"] = "175533314100413759868",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 1347.7105263157894,
							["y"] = 121.83834586466168
						},
						["propsData"] = {}
					},
					["175533314100413759869"] = {
						["key"] = "175533314100413759869",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 2912.0247678018577,
							["y"] = 203.37151702786366
						},
						["propsData"] = {}
					},
					["175533314100413759870"] = {
						["key"] = "175533314100413759870",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 3233.3869969040243,
							["y"] = 117.73684210526307
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300013,
							["MessageNote"] = "触发概率",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:1.List_Attr:6",
							["UICompName"] = "WidgetSwitcher_Bg",
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
					["175533314100413759871"] = {
						["key"] = "175533314100413759871",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 3251.405572755417,
							["y"] = 247.67492260061914
						},
						["propsData"] = {
							["MessageId"] = 300013,
							["MessageNote"] = "触发概率",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["175533314100413759872"] = {
						["key"] = "175533314100413759872",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1995.6982714138287,
							["y"] = 914.9856811145513
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300010,
							["MessageNote"] = "点击“+”号，可以提升升级的目标等级",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
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
					["175533314100413759873"] = {
						["key"] = "175533314100413759873",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1964,
							["y"] = 1094
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300009,
							["MessageNote"] = "点击“+”号，打开升级弹窗。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:1.Btn_Intensify",
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