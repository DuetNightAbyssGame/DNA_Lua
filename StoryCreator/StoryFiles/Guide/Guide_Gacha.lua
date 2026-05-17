return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "171343153468017922",
			["startPort"] = "StoryStart",
			["endStory"] = "171343153663918001",
			["endPort"] = "In"
		},
		{
			["startStory"] = "171343153663918001",
			["startPort"] = "Success",
			["endStory"] = "171343153468017925",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["171343153468017922"] = {
			["isStoryNode"] = true,
			["key"] = "171343153468017922",
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
		["171343153468017925"] = {
			["isStoryNode"] = true,
			["key"] = "171343153468017925",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1518.181818181818,
				["y"] = 317.72727272727275
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["171343153663918001"] = {
			["isStoryNode"] = true,
			["key"] = "171343153663918001",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1179.2066299790383,
				["y"] = 296.60109326385196
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
						["startQuest"] = "171343153663918002",
						["startPort"] = "QuestStart",
						["endQuest"] = "171343154229318316",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "171343154229318316",
						["startPort"] = "Out",
						["endQuest"] = "171343153663918004",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["171343153663918002"] = {
						["key"] = "171343153663918002",
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
					["171343153663918004"] = {
						["key"] = "171343153663918004",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1541.2753036437246,
							["y"] = 300.85020242914976
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171343153663918006"] = {
						["key"] = "171343153663918006",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2261.578947368421,
							["y"] = 723.6842105263158
						},
						["propsData"] = {}
					},
					["171343154229318310"] = {
						["key"] = "171343154229318310",
						["type"] = "ShowGuideButtonNode",
						["name"] = "物品列表",
						["pos"] = {
							["x"] = 1037.8020128842857,
							["y"] = 714.6671179930433
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
					["171343154229318311"] = {
						["key"] = "171343154229318311",
						["type"] = "ShowGuideButtonNode",
						["name"] = "动态界面按钮",
						["pos"] = {
							["x"] = 1603.9982828811555,
							["y"] = 730.8862886275065
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
					["171343154229318312"] = {
						["key"] = "171343154229318312",
						["type"] = "ShowGuideButtonNode",
						["name"] = "界面内弹窗",
						["pos"] = {
							["x"] = 1880.9136089344122,
							["y"] = 728.3982968591553
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
					["171343154229318313"] = {
						["key"] = "171343154229318313",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1016.5905601145735,
							["y"] = 549.6725412568409
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
					["171343154229318314"] = {
						["key"] = "171343154229318314",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1290.949534473548,
							["y"] = 548.1340797183793
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
					["171343154229318315"] = {
						["key"] = "171343154229318315",
						["type"] = "ShowGuideButtonNode",
						["name"] = "UI内ListView",
						["pos"] = {
							["x"] = 1594.5392780632917,
							["y"] = 560.5699771542764
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
					["171343154229318316"] = {
						["key"] = "171343154229318316",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1139.6080898112632,
							["y"] = 298.5229237578977
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301201,
							["MessageNote"] = "点击进行一次祈愿",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "GachaMain.Btn_Once",
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}