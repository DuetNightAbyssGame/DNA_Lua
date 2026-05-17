return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17454761535502276685",
			["startPort"] = "StoryStart",
			["endStory"] = "17454761535502276687",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17454761535502276687",
			["startPort"] = "Success",
			["endStory"] = "17454761535502276686",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17454761535502276685"] = {
			["isStoryNode"] = true,
			["key"] = "17454761535502276685",
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
		["17454761535502276686"] = {
			["isStoryNode"] = true,
			["key"] = "17454761535502276686",
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
		["17454761535502276687"] = {
			["isStoryNode"] = true,
			["key"] = "17454761535502276687",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1304.3923958252599,
				["y"] = 310.2048988918085
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
						["startQuest"] = "17455019297665493546",
						["startPort"] = "Out",
						["endQuest"] = "17455019297665493550",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455019297665493549",
						["startPort"] = "Out",
						["endQuest"] = "17455019297665493551",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17454761535502276705",
						["startPort"] = "Out",
						["endQuest"] = "17454761535502276694",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17455019297665493550",
						["startPort"] = "Out",
						["endQuest"] = "17454761535502276706",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455019297665493551",
						["startPort"] = "Out",
						["endQuest"] = "17454761535502276706",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17454761535502276693",
						["startPort"] = "QuestStart",
						["endQuest"] = "17455019297665493547",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17454761535502276706",
						["startPort"] = "Out",
						["endQuest"] = "17454761535502276705",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562197359871905934",
						["startPort"] = "Gamepad",
						["endQuest"] = "17562197359871905935",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562197359871905934",
						["startPort"] = "MouseAndKeyboard",
						["endQuest"] = "17455019297665493546",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562197359871905934",
						["startPort"] = "Touch",
						["endQuest"] = "17455019297665493549",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17455019297665493547",
						["startPort"] = "Out",
						["endQuest"] = "17562197359871905934",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17562197359871905935",
						["startPort"] = "Out",
						["endQuest"] = "17562204198582541118",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17562204198582541118",
						["startPort"] = "Out",
						["endQuest"] = "17455019297665493550",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17454761535502276688"] = {
						["key"] = "17454761535502276688",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 832.919626346642,
							["y"] = 1142.1146225512123
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
					["17454761535502276690"] = {
						["key"] = "17454761535502276690",
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
					["17454761535502276693"] = {
						["key"] = "17454761535502276693",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 764.1341614906833,
							["y"] = 61.8211180124224
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17454761535502276694"] = {
						["key"] = "17454761535502276694",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2414.8932330827065,
							["y"] = 665.6951127819549
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17454761535502276695"] = {
						["key"] = "17454761535502276695",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17454761535502276705"] = {
						["key"] = "17454761535502276705",
						["type"] = "ShowGuideButtonNode",
						["name"] = "圈圈奖励",
						["pos"] = {
							["x"] = 1826.4330840843686,
							["y"] = 666.8263081842701
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302505,
							["MessageNote"] = "点击配置武器。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "StyleOfPlay.Group_Task:1.PanelRoot:1.Progress",
							["UICompName"] = "",
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
					["17454761535502276706"] = {
						["key"] = "17454761535502276706",
						["type"] = "ShowGuideButtonNode",
						["name"] = "圈圈一个任务",
						["pos"] = {
							["x"] = 1946.9194366715228,
							["y"] = 443.778042173647
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302504,
							["MessageNote"] = "点击协战印记。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "StyleOfPlay.Group_Task:1.PanelRoot:1.List_Task:1",
							["UICompName"] = "",
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
					["17454761535502276707"] = {
						["key"] = "17454761535502276707",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 2233.412061390808,
							["y"] = 498.1648828090441
						},
						["propsData"] = {
							["GuideId"] = 32
						}
					},
					["17455019297665493546"] = {
						["key"] = "17455019297665493546",
						["type"] = "ShowGuideButtonNode",
						["name"] = "按历练",
						["pos"] = {
							["x"] = 1310.688074455552,
							["y"] = 267.49607854499413
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302502,
							["MessageNote"] = "点击“玩法”进入委托系统。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.ListView:8",
							["UICompName"] = "Btn_top",
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
					["17455019297665493547"] = {
						["key"] = "17455019297665493547",
						["type"] = "ShowGuideTextNode",
						["name"] = "每日解锁啦",
						["pos"] = {
							["x"] = 1089.892695121876,
							["y"] = 51.383541280466375
						},
						["propsData"] = {
							["MessageId"] = 302501,
							["MessageNote"] = "歧路迷津解锁了，在歧路迷津中，我们将探索未知的深渊，获取不同组合的烛芯和遗物，挑战强敌！一起去看看吧！",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17455019297665493548"] = {
						["key"] = "17455019297665493548",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 1209.4214359200028,
							["y"] = 1002.3351239902302
						},
						["propsData"] = {}
					},
					["17455019297665493549"] = {
						["key"] = "17455019297665493549",
						["type"] = "ShowGuideButtonNode",
						["name"] = "按历练",
						["pos"] = {
							["x"] = 1342.593723310032,
							["y"] = 599.0156052736526
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302502,
							["MessageNote"] = "点击“玩法”进入委托系统。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.ListView:8",
							["UICompName"] = "Btn_top",
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
					["17455019297665493550"] = {
						["key"] = "17455019297665493550",
						["type"] = "ShowGuideButtonNode",
						["name"] = "按每日",
						["pos"] = {
							["x"] = 1674.1397298514935,
							["y"] = 402.8160023371309
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302503,
							["MessageNote"] = "点击<H>“迷津”</>。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "StyleOfPlay.Group_Task:1.Tab.List_Tab:2",
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
					["17455019297665493551"] = {
						["key"] = "17455019297665493551",
						["type"] = "ShowGuideButtonNode",
						["name"] = "按每日",
						["pos"] = {
							["x"] = 1671.2590501467575,
							["y"] = 541.3317440889357
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302503,
							["MessageNote"] = "点击<H>“迷津”</>。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "StyleOfPlay.Group_Task:1.Tab.List_Tab:2",
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
					["17562197359871905934"] = {
						["key"] = "17562197359871905934",
						["type"] = "InputDeviceBranchNode",
						["name"] = "输入设备分支",
						["pos"] = {
							["x"] = 637.0196411599085,
							["y"] = 442.20129408109284
						},
						["propsData"] = {}
					},
					["17562197359871905935"] = {
						["key"] = "17562197359871905935",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 981.8369106633821,
							["y"] = 461.2710617758319
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
					["17562197487621906255"] = {
						["key"] = "17562197487621906255",
						["type"] = "ShowGuideButtonNode",
						["name"] = "按历练",
						["pos"] = {
							["x"] = 1806,
							["y"] = -240
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302502,
							["MessageNote"] = "点击“玩法”进入委托系统。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.ListView:8",
							["UICompName"] = "Btn_top",
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
					["17562204198582541118"] = {
						["key"] = "17562204198582541118",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1318,
							["y"] = 442
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302502,
							["MessageNote"] = "点击<H>“整备”</>进入整备系统。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "MenuWorld.Panel_Function:5",
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}