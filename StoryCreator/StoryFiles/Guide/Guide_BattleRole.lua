return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1745484076014342721",
			["startPort"] = "StoryStart",
			["endStory"] = "1745484076014342723",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1745484076014342723",
			["startPort"] = "Success",
			["endStory"] = "1745484076014342722",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1745484076014342721"] = {
			["isStoryNode"] = true,
			["key"] = "1745484076014342721",
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
		["1745484076014342722"] = {
			["isStoryNode"] = true,
			["key"] = "1745484076014342722",
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
		["1745484076014342723"] = {
			["isStoryNode"] = true,
			["key"] = "1745484076014342723",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1302.1701736030377,
				["y"] = 311.3160100029196
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
						["startQuest"] = "1745484076014342739",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342740",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745484076014342740",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342742",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745484076014342736",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342739",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745484076014342735",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342736",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745484076014342727",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342743",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745484076014342743",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342730",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1745484076014342742",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342741",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745484076014342741",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342728",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745484076014342729",
						["startPort"] = "QuestStart",
						["endQuest"] = "174584053322528664014",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174584053322528664014",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342735",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745484076014342728",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342724",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745484076014342724",
						["startPort"] = "Out",
						["endQuest"] = "1745484076014342727",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1745484076014342724"] = {
						["key"] = "1745484076014342724",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1744.1696263466417,
							["y"] = 468.86462255121234
						},
						["propsData"] = {
							["MessageId"] = 300615,
							["MessageNote"] = "武器配置界面。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "Left",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1745484076014342726"] = {
						["key"] = "1745484076014342726",
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
					["1745484076014342727"] = {
						["key"] = "1745484076014342727",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 2075.1568058338216,
							["y"] = 447.34111827770784
						},
						["propsData"] = {
							["MessageId"] = 300612,
							["MessageNote"] = "【待包装】已配置武器的协战印记可以通过拖拽放入战斗背包内。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "Left",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1745484076014342728"] = {
						["key"] = "1745484076014342728",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1442.15374459455,
							["y"] = 480.61179255520625
						},
						["propsData"] = {
							["MessageId"] = 300609,
							["MessageNote"] = "【待包装】通过配置战斗背包，可以在战斗中使用各种道具辅助战斗，也可以召唤协战伙伴一起参与战斗。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "Left",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1745484076014342729"] = {
						["key"] = "1745484076014342729",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 469.3246376811595,
							["y"] = 269.67826086956524
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1745484076014342730"] = {
						["key"] = "1745484076014342730",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2639.1,
							["y"] = 457.15
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1745484076014342731"] = {
						["key"] = "1745484076014342731",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1745484076014342732"] = {
						["key"] = "1745484076014342732",
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
					["1745484076014342733"] = {
						["key"] = "1745484076014342733",
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
					["1745484076014342734"] = {
						["key"] = "1745484076014342734",
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
					["1745484076014342735"] = {
						["key"] = "1745484076014342735",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1290.9100984684806,
							["y"] = 293.0288120397795
						},
						["propsData"] = {
							["MessageId"] = 300605,
							["MessageNote"] = "【待包装】通过配置战斗背包，可以在战斗中使用各种道具辅助战斗，也可以召唤协战伙伴一起参与战斗。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = true,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1745484076014342736"] = {
						["key"] = "1745484076014342736",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1576.5214697059384,
							["y"] = 288.8818373008141
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300602,
							["MessageNote"] = "点击<H>“整备”</>进入整备系统。",
							["DelayTime"] = 0,
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745484076014342737"] = {
						["key"] = "1745484076014342737",
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
					["1745484076014342738"] = {
						["key"] = "1745484076014342738",
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
					["1745484076014342739"] = {
						["key"] = "1745484076014342739",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1853.4797584626222,
							["y"] = 291.49318691956995
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300603,
							["MessageNote"] = "点击“替换”，进行近战武器的替换。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Tab_Arm.EMScrollBox_TabItem:-1",
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
							["MessageLoc"] = "Down",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745484076014342740"] = {
						["key"] = "1745484076014342740",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 693.895020977885,
							["y"] = 474.7494043863138
						},
						["propsData"] = {
							["MessageId"] = 300606,
							["MessageNote"] = "【待包装】通过配置战斗背包，可以在战斗中使用各种道具辅助战斗，也可以召唤协战伙伴一起参与战斗。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1745484076014342741"] = {
						["key"] = "1745484076014342741",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1192.3748134076773,
							["y"] = 481.8413457782551
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300608,
							["MessageNote"] = "点击配置武器。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:2.List_Item:1.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:1.Btn01_Mod",
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
							["MessageLoc"] = "UpRight",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745484076014342742"] = {
						["key"] = "1745484076014342742",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 945.8976975410883,
							["y"] = 483.75630304321226
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300607,
							["MessageNote"] = "点击协战印记。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:2.List_Item:1.Item",
							["UICompName"] = "ItemDetails_MenuAnchor",
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
								["Y"] = 80
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "UpRight",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745484076014342743"] = {
						["key"] = "1745484076014342743",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 2346.9836546367433,
							["y"] = 461.220181311711
						},
						["propsData"] = {
							["GuideId"] = 32
						}
					},
					["174584053322528664014"] = {
						["key"] = "174584053322528664014",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 764.3333333333333,
							["y"] = 287.66666666666663
						},
						["propsData"] = {
							["WaitTime"] = 0.1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}