return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1722839702526613",
			["startPort"] = "StoryStart",
			["endStory"] = "1722839703986650",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1722839703986650",
			["startPort"] = "Success",
			["endStory"] = "1722839702526616",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1722839702526613"] = {
			["isStoryNode"] = true,
			["key"] = "1722839702526613",
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
		["1722839702526616"] = {
			["isStoryNode"] = true,
			["key"] = "1722839702526616",
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
		["1722839703986650"] = {
			["isStoryNode"] = true,
			["key"] = "1722839703986650",
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
						["startQuest"] = "1722839703986651",
						["startPort"] = "QuestStart",
						["endQuest"] = "17228401029511429",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17228401029511429",
						["startPort"] = "Out",
						["endQuest"] = "17228401229071736",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17228401229071736",
						["startPort"] = "Out",
						["endQuest"] = "17454935886141407",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17454935886141407",
						["startPort"] = "Out",
						["endQuest"] = "17228404890722971",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17228404890722971",
						["startPort"] = "Out",
						["endQuest"] = "17228401896792435",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17228401896792435",
						["startPort"] = "Out",
						["endQuest"] = "1745494443141554223",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745496131713555243",
						["startPort"] = "Out",
						["endQuest"] = "1745496317213555870",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745496317213555870",
						["startPort"] = "Out",
						["endQuest"] = "17651965715041039",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17651965715041039",
						["startPort"] = "PC",
						["endQuest"] = "1745496652495557683",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17651965715041039",
						["startPort"] = "Mobile",
						["endQuest"] = "1765196559976901",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745496652495557683",
						["startPort"] = "Out",
						["endQuest"] = "1722839703986654",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1765196559976901",
						["startPort"] = "Out",
						["endQuest"] = "1722839703986654",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1745494443141554223",
						["startPort"] = "Out",
						["endQuest"] = "1765248856276643737",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1765248856276643737",
						["startPort"] = "PC",
						["endQuest"] = "1745496131713555243",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1765248856276643737",
						["startPort"] = "Mobile",
						["endQuest"] = "1765248864271643963",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1765248864271643963",
						["startPort"] = "Out",
						["endQuest"] = "1745496317213555870",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1722839703986651"] = {
						["key"] = "1722839703986651",
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
					["1722839703986654"] = {
						["key"] = "1722839703986654",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2516,
							["y"] = 489.52941176470586
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722839703986657"] = {
						["key"] = "1722839703986657",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2658.823529411765,
							["y"] = 707.0588235294117
						},
						["propsData"] = {}
					},
					["1722839710652978"] = {
						["key"] = "1722839710652978",
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
					["1722839710652979"] = {
						["key"] = "1722839710652979",
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
					["1722839710652980"] = {
						["key"] = "1722839710652980",
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
					["1722839710652981"] = {
						["key"] = "1722839710652981",
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
					["1722839710652982"] = {
						["key"] = "1722839710652982",
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
					["1722839710652983"] = {
						["key"] = "1722839710652983",
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
					["1722839710652984"] = {
						["key"] = "1722839710652984",
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
					},
					["17228401029511429"] = {
						["key"] = "17228401029511429",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1111.5,
							["y"] = 301
						},
						["propsData"] = {
							["MessageId"] = 301801,
							["MessageNote"] = "完成战斗或部分事件后，可以从3枚烛芯中选择获取1枚。烛芯可以提高在此次迷津探险中的能力。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17228401229071736"] = {
						["key"] = "17228401229071736",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1442,
							["y"] = 295.5
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301802,
							["MessageNote"] = "点击可以选择想要获取的烛芯",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "Rouge_Blessing_3Choose1.Item_Blessing01",
							["UICompName"] = "Button_Select",
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
					["17228401896792435"] = {
						["key"] = "17228401896792435",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 2256.735294117647,
							["y"] = 315
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301803,
							["MessageNote"] = "在这里可以消耗余烬来刷新可选择的烛芯。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "Rouge_Blessing_3Choose1.Btn_Refresh",
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17228404890722971"] = {
						["key"] = "17228404890722971",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1997.588089111702,
							["y"] = 299.16129038212324
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301804,
							["MessageNote"] = "这里显示的是当前拥有的余烬数量。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "Rouge_Blessing_3Choose1.Panel_ResourceBar:1.Panel_ResourceBar:1",
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
					["17454935886141407"] = {
						["key"] = "17454935886141407",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1700,
							["y"] = 306
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301805,
							["MessageNote"] = "集齐一定数量的<H>同类型</>烛芯，可以激活<H>额外效果</>。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "Rouge_Blessing_3Choose1",
							["UICompName"] = "ScrollBox_Suit",
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
					["1745494443141554223"] = {
						["key"] = "1745494443141554223",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 954,
							["y"] = 482
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301806,
							["MessageNote"] = "此处可<H>放弃烛芯奖励</>，将获得一定的<H>余烬</>。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "Rouge_Blessing_3Choose1.Btn_GiveUp",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1745496131713555243"] = {
						["key"] = "1745496131713555243",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1406,
							["y"] = 562
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301807,
							["MessageNote"] = "此处可将<H>烛芯</>的描述切换成简洁版。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "Rouge_Blessing_3Choose1.Btn_SortDesc",
							["UICompName"] = "ButtonArea",
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
					["1745496317213555870"] = {
						["key"] = "1745496317213555870",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1744.6486486765134,
							["y"] = 478.59459470605395
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301808,
							["MessageNote"] = "点击打开<H>局内背包</>，可查看当前探索所得。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "Rouge_Blessing_3Choose1.Btn_Bag",
							["UICompName"] = "Btn_Click",
							["GamePadWidgetName"] = "Key_Bag",
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
					["1745496652495557683"] = {
						["key"] = "1745496652495557683",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 2149.3939380161178,
							["y"] = 477.75757613122227
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301809,
							["MessageNote"] = "点击打开<H>局内背包</>，可查看当前探索所得。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeBag.Common_Tab.EMScrollBox_TabItem:2",
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
					["1765196559976901"] = {
						["key"] = "1765196559976901",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 2141.4118079511077,
							["y"] = 702.7444477237498
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301809,
							["MessageNote"] = "点击打开<H>局内背包</>，可查看当前探索所得。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeBag.Common_Tab.EMScrollBox_TabItem:2",
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
					["17651965715041039"] = {
						["key"] = "17651965715041039",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 1729.290603723178,
							["y"] = 693.653541084896
						},
						["propsData"] = {}
					},
					["1765248856276643737"] = {
						["key"] = "1765248856276643737",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 1020,
							["y"] = 684
						},
						["propsData"] = {}
					},
					["1765248864271643963"] = {
						["key"] = "1765248864271643963",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1408,
							["y"] = 700
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301807,
							["MessageNote"] = "此处可将<H>烛芯</>的描述切换成简洁版。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "Rouge_Blessing_3Choose1.Btn_SortDesc",
							["UICompName"] = "ButtonArea",
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}