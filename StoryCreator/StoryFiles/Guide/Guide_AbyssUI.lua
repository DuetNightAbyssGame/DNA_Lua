return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1704175978636172694",
			["startPort"] = "StoryStart",
			["endStory"] = "1704175978636172696",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1704175978636172696",
			["startPort"] = "Success",
			["endStory"] = "1704175978636172695",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1704175978636172694"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978636172694",
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
		["1704175978636172695"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978636172695",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1697.1999999999998,
				["y"] = 409.2
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1704175978636172696"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978636172696",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1296.1701736030377,
				["y"] = 309.3160100029196
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
						["startQuest"] = "1704175978636172704",
						["startPort"] = "Out",
						["endQuest"] = "1704175978636172707",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978636172703",
						["startPort"] = "Out",
						["endQuest"] = "1704175978636172704",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978636172710",
						["startPort"] = "Out",
						["endQuest"] = "1704175978636172709",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17198255481206236",
						["startPort"] = "Out",
						["endQuest"] = "1704175978636172698",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17454831995634856",
						["startPort"] = "Out",
						["endQuest"] = "17198255481206236",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17454832177335423",
						["startPort"] = "Out",
						["endQuest"] = "1704175978636172710",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978636172707",
						["startPort"] = "Out",
						["endQuest"] = "17454832177335423",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978636172709",
						["startPort"] = "Out",
						["endQuest"] = "17454831995634856",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978636172697",
						["startPort"] = "QuestStart",
						["endQuest"] = "1704175978636172703",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["170131068431983727"] = {
						["key"] = "170131068431983727",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 962.919626346642,
							["y"] = 680.1146225512123
						},
						["propsData"] = {
							["MessageId"] = 300608,
							["MessageNote"] = "【待包装】通过配置战斗背包，可以在战斗中使用各种道具辅助战斗，也可以召唤协战伙伴一起参与战斗。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "Left",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["170131275082686657"] = {
						["key"] = "170131275082686657",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 2304.646316323333,
							["y"] = 873.0124469490364
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300611,
							["MessageNote"] = "点击“X”离开武器配置界面。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryBattleMenuDialog.Btn_Close",
							["UICompName"] = "Btn_Close",
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
					["1704175978636172697"] = {
						["key"] = "1704175978636172697",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 680.9913043478261,
							["y"] = 294.67826086956524
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978636172698"] = {
						["key"] = "1704175978636172698",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2267.4333333333334,
							["y"] = 457.15
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978636172699"] = {
						["key"] = "1704175978636172699",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1704175978636172700"] = {
						["key"] = "1704175978636172700",
						["type"] = "ShowGuideButtonNode",
						["name"] = "物品列表",
						["pos"] = {
							["x"] = 974.7157541367434,
							["y"] = 85.25623901752793
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300006,
							["MessageNote"] = "点击刚才获得的新武器。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["1704175978636172701"] = {
						["key"] = "1704175978636172701",
						["type"] = "ShowGuideButtonNode",
						["name"] = "动态界面按钮",
						["pos"] = {
							["x"] = 1542.2163719597002,
							["y"] = 100.17106182590403
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300009,
							["MessageNote"] = "点击“+”号，打开升级弹窗。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["1704175978636172702"] = {
						["key"] = "1704175978636172702",
						["type"] = "ShowGuideButtonNode",
						["name"] = "界面内弹窗",
						["pos"] = {
							["x"] = 1819.1316980129568,
							["y"] = 98.98741788363982
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300010,
							["MessageNote"] = "点击“+”号，可以提升升级的目标等级",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["1704175978636172703"] = {
						["key"] = "1704175978636172703",
						["type"] = "ShowGuideTextNode",
						["name"] = "这里是大秘境",
						["pos"] = {
							["x"] = 1291.4552544619123,
							["y"] = 292.02634898559234
						},
						["propsData"] = {
							["MessageId"] = 302301,
							["MessageNote"] = "【待包装】通过配置战斗背包，可以在战斗中使用各种道具辅助战斗，也可以召唤协战伙伴一起参与战斗。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = true,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1704175978636172704"] = {
						["key"] = "1704175978636172704",
						["type"] = "ShowGuideButtonNode",
						["name"] = "1点击左侧挑选剧目",
						["pos"] = {
							["x"] = 1577.7714697059384,
							["y"] = 288.8818373008141
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302302,
							["MessageNote"] = "点击<H>“整备”</>进入整备系统。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "AbyssMain",
							["UICompName"] = "WBox_Mode",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = true,
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
					["1704175978636172705"] = {
						["key"] = "1704175978636172705",
						["type"] = "ShowGuideButtonNode",
						["name"] = "UI内ListView",
						["pos"] = {
							["x"] = 1532.757367141836,
							["y"] = -70.14524964732603
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
					["1704175978636172706"] = {
						["key"] = "1704175978636172706",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1270.8696571506773,
							["y"] = 89.11204478238214
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
					},
					["1704175978636172707"] = {
						["key"] = "1704175978636172707",
						["type"] = "ShowGuideButtonNode",
						["name"] = "2点击右侧进入关卡",
						["pos"] = {
							["x"] = 1853.4797584626222,
							["y"] = 292.74318691956995
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302303,
							["MessageNote"] = "点击“替换”，进行近战武器的替换。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "AbyssMain.List_Level:1",
							["UICompName"] = "Btn_Click",
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
							["MessageLoc"] = "Down",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1704175978636172709"] = {
						["key"] = "1704175978636172709",
						["type"] = "ShowGuideButtonNode",
						["name"] = "5查看奖励列表",
						["pos"] = {
							["x"] = 1265.6248134076773,
							["y"] = 496.8413457782551
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302306,
							["MessageNote"] = "点击配置武器。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "AbyssMain.Com_Tab.Pos_Abyss_Star:1",
							["UICompName"] = "Btn_Item",
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
					["1704175978636172710"] = {
						["key"] = "1704175978636172710",
						["type"] = "ShowGuideButtonNode",
						["name"] = "4查看挑战进度",
						["pos"] = {
							["x"] = 957.9429851787871,
							["y"] = 497.10514025251456
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302305,
							["MessageNote"] = "点击协战印记。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "AbyssMain.Com_Tab.Pos_Abyss_Star:1",
							["UICompName"] = "Btn_Item",
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
					["1716899489160137224"] = {
						["key"] = "1716899489160137224",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 2259.4836546367433,
							["y"] = 583.7201813117109
						},
						["propsData"] = {
							["GuideId"] = 32
						}
					},
					["17198255481206236"] = {
						["key"] = "17198255481206236",
						["type"] = "ShowGuideButtonNode",
						["name"] = "7进",
						["pos"] = {
							["x"] = 1958.4655789377064,
							["y"] = 498.60891128455376
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302308,
							["MessageNote"] = "点击“X”离开武器配置界面。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "AbyssMain.Group_Root:Select",
							["UICompName"] = "BtnStart",
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
							["MessageLoc"] = "UpLeft",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17454831995634856"] = {
						["key"] = "17454831995634856",
						["type"] = "ShowGuideButtonNode",
						["name"] = "6选角色配队伍",
						["pos"] = {
							["x"] = 1597.977723110979,
							["y"] = 495.9666026444183
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302307,
							["MessageNote"] = "点击“X”离开武器配置界面。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "AbyssMain.Group_Root:1.Item_L",
							["UICompName"] = "Character",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["UICompSizeOffset"] = {
								["X"] = 100,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = 50,
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
					["17454832177335423"] = {
						["key"] = "17454832177335423",
						["type"] = "ShowGuideButtonNode",
						["name"] = "3查看词条buff",
						["pos"] = {
							["x"] = 692.7816269378123,
							["y"] = 499.67034107902697
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302304,
							["MessageNote"] = "点击协战印记。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "AbyssMain.Group_Root:1.Item_L.Entry_Tip",
							["UICompName"] = "Btn_Entry_L",
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
							["MessageLoc"] = "UpRight",
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