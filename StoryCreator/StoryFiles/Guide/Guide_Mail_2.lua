return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17566466119051649757",
			["startPort"] = "StoryStart",
			["endStory"] = "17566466119051649759",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17566466119051649759",
			["startPort"] = "Success",
			["endStory"] = "17566466119051649758",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17566466119051649757"] = {
			["isStoryNode"] = true,
			["key"] = "17566466119051649757",
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
		["17566466119051649758"] = {
			["isStoryNode"] = true,
			["key"] = "17566466119051649758",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1798,
				["y"] = 286
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17566466119051649759"] = {
			["isStoryNode"] = true,
			["key"] = "17566466119051649759",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1274,
				["y"] = 268
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
						["startQuest"] = "17566466119051649766",
						["startPort"] = "Out",
						["endQuest"] = "17566466119051649767",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566466119051649768",
						["startPort"] = "Out",
						["endQuest"] = "17566466119051649761",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17566464042671704",
						["startPort"] = "MouseAndKeyboard",
						["endQuest"] = "17566464042671705",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566464042671704",
						["startPort"] = "Gamepad",
						["endQuest"] = "17566464042671706",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566464042671706",
						["startPort"] = "Out",
						["endQuest"] = "17566464042671707",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566464042671704",
						["startPort"] = "Touch",
						["endQuest"] = "17566464042671708",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566466119051649764",
						["startPort"] = "Out",
						["endQuest"] = "17566464042671704",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17566464042671705",
						["startPort"] = "Out",
						["endQuest"] = "17566466119051649768",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566464042671707",
						["startPort"] = "Out",
						["endQuest"] = "17566466119051649768",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566464042671708",
						["startPort"] = "Out",
						["endQuest"] = "17566466119051649768",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566466119051649760",
						["startPort"] = "QuestStart",
						["endQuest"] = "1759109719539689",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1759109719539689",
						["startPort"] = "Fail",
						["endQuest"] = "17566466119051649764",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1759109719539689",
						["startPort"] = "Success",
						["endQuest"] = "17566466119051649761",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17566464042671704"] = {
						["key"] = "17566464042671704",
						["type"] = "InputDeviceBranchNode",
						["name"] = "输入设备分支",
						["pos"] = {
							["x"] = 1305.0196411599086,
							["y"] = 500.20129408109284
						},
						["propsData"] = {}
					},
					["17566464042671705"] = {
						["key"] = "17566464042671705",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1722.736063670396,
							["y"] = 375.0068267784613
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300002,
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
							["MessageLoc"] = "DownLeft",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17566464042671706"] = {
						["key"] = "17566464042671706",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 1649.8369106633822,
							["y"] = 519.2710617758319
						},
						["propsData"] = {
							["MessageId"] = 301611,
							["SkillNameList"] = {
								"OpenMenu"
							},
							["LastTime"] = -1,
							["bIsForceTouch"] = true,
							["bIsTimeDilation"] = true,
							["HighLightUIPath"] = "BattleMain.Btn_Esc",
							["UICompName"] = "Btn_top",
							["UIShape"] = "Square",
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["ForbidSuccessAnim"] = true,
							["IsNotForceRelease"] = false,
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
					["17566464042671707"] = {
						["key"] = "17566464042671707",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1882.9803588400914,
							["y"] = 552.718158706462
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300002,
							["MessageNote"] = "点击<H>“整备”</>进入整备系统。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "MenuWorld.Panel_Function:1",
							["UICompName"] = "Button_Area",
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
					["17566464042671708"] = {
						["key"] = "17566464042671708",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1600.204148334395,
							["y"] = 742.6060764274976
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300002,
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
							["MessageLoc"] = "DownLeft",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17566466119051649760"] = {
						["key"] = "17566466119051649760",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 684,
							["y"] = 524
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17566466119051649761"] = {
						["key"] = "17566466119051649761",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2813.0403954560707,
							["y"] = 568.0905595488423
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17566466119051649762"] = {
						["key"] = "17566466119051649762",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2890,
							["y"] = 956
						},
						["propsData"] = {}
					},
					["17566466119051649763"] = {
						["key"] = "17566466119051649763",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2370.927431226131,
							["y"] = 242.30581958761724
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302804,
							["MessageNote"] = "圈一封邮件",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "MailMain.WBP_Mail_Root.WS_MailList:2:2:3:1:1.Common_List_Subcell_PC",
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
							["MessageLoc"] = "Down",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17566466119051649764"] = {
						["key"] = "17566466119051649764",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1032.0384978341551,
							["y"] = 567.221341453414
						},
						["propsData"] = {
							["MessageId"] = 302806,
							["MessageNote"] = "合成提示",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "Upleft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17566466119051649765"] = {
						["key"] = "17566466119051649765",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 676.1828630099483,
							["y"] = 1812.5955716285314
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302809,
							["MessageNote"] = "关闭获得物品界面",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "GetItemPage",
							["UICompName"] = "Button_Close",
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
								["Y"] = 150
							}
						}
					},
					["17566466119051649766"] = {
						["key"] = "17566466119051649766",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 948.2672974409656,
							["y"] = 1284.5112051940234
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302810,
							["MessageNote"] = "展开角色列表",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
							["MessageLoc"] = "DownRight",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17566466119051649767"] = {
						["key"] = "17566466119051649767",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1282.128640449419,
							["y"] = 1254.4479892767722
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302811,
							["MessageNote"] = "点击黑桃",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Selective_Listing.TileView_Select_Role:1",
							["UICompName"] = "Node_Widget",
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
					["17566466119051649768"] = {
						["key"] = "17566466119051649768",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2216.9341088454657,
							["y"] = 572.477314898538
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302812,
							["MessageNote"] = "点击合成",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["17566466119051649769"] = {
						["key"] = "17566466119051649769",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1233.8799725754009,
							["y"] = 1800.772292012126
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302808,
							["MessageNote"] = "展开角色列表",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain",
							["UICompName"] = "Key_GamePad",
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
					["17566466119051649770"] = {
						["key"] = "17566466119051649770",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 3551.463850565692,
							["y"] = 787.9272843900114
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = -1,
							["UnitId"] = -1
						}
					},
					["1759109719539689"] = {
						["key"] = "1759109719539689",
						["type"] = "ConditionNode",
						["name"] = "条件节点",
						["pos"] = {
							["x"] = 899.2870741546346,
							["y"] = 325.908168547777
						},
						["propsData"] = {
							["ConditionId"] = 210100
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}