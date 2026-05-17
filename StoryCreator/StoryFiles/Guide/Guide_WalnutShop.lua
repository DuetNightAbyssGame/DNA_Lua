return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17542072484182715422",
			["startPort"] = "StoryStart",
			["endStory"] = "17542072484182715424",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17542072484182715424",
			["startPort"] = "Success",
			["endStory"] = "17542072484182715423",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17542072484182715422"] = {
			["isStoryNode"] = true,
			["key"] = "17542072484182715422",
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
		["17542072484182715423"] = {
			["isStoryNode"] = true,
			["key"] = "17542072484182715423",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1764,
				["y"] = 322
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17542072484182715424"] = {
			["isStoryNode"] = true,
			["key"] = "17542072484182715424",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1262,
				["y"] = 292
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
						["startQuest"] = "17542153451193283273",
						["startPort"] = "Out",
						["endQuest"] = "17542154183063284819",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17542153451193283271",
						["startPort"] = "Out",
						["endQuest"] = "17542154183063284819",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17542072484182715425",
						["startPort"] = "QuestStart",
						["endQuest"] = "17542153451193283270",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175421751468113766379",
						["startPort"] = "Out",
						["endQuest"] = "175421805464115077368",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175421805464115077368",
						["startPort"] = "Out",
						["endQuest"] = "17542072484182715426",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1756644252647655",
						["startPort"] = "Gamepad",
						["endQuest"] = "1756644252647657",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17542153451193283270",
						["startPort"] = "Out",
						["endQuest"] = "1756644252647655",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1756644252647655",
						["startPort"] = "MouseAndKeyboard",
						["endQuest"] = "17542153451193283273",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756644252647655",
						["startPort"] = "Touch",
						["endQuest"] = "17542153451193283271",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756644252647657",
						["startPort"] = "Out",
						["endQuest"] = "17542154183063284819",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17542154183063284819",
						["startPort"] = "Out",
						["endQuest"] = "17566444402781272875",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566444402781272875",
						["startPort"] = "Out",
						["endQuest"] = "175421751468113766379",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17542072484182715425"] = {
						["key"] = "17542072484182715425",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 222.17391167336018,
							["y"] = 172.6956524984147
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17542072484182715426"] = {
						["key"] = "17542072484182715426",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2332.8282945712504,
							["y"] = 376.67251641247844
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17542072484182715427"] = {
						["key"] = "17542072484182715427",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2194.44444729631,
							["y"] = 811.1111105878331
						},
						["propsData"] = {}
					},
					["17542153451193283270"] = {
						["key"] = "17542153451193283270",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 488.2510784074302,
							["y"] = 204.7179246519869
						},
						["propsData"] = {
							["MessageId"] = 303101,
							["MessageNote"] = "搜集了足够多的委托密函线索，去商店兑换委托密函",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "Upleft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17542153451193283271"] = {
						["key"] = "17542153451193283271",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1441.5484434193636,
							["y"] = 393.84564002472825
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303102,
							["MessageNote"] = "打开菜单",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.Btn_Esc",
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
							["MessageLoc"] = "DownRight",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17542153451193283272"] = {
						["key"] = "17542153451193283272",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 510.40017882015354,
							["y"] = -198.01007439652585
						},
						["propsData"] = {}
					},
					["17542153451193283273"] = {
						["key"] = "17542153451193283273",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1411.6273575305431,
							["y"] = 19.18990856337598
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303102,
							["MessageNote"] = "打开菜单",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.Btn_Esc",
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
							["MessageLoc"] = "DownRight",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17542154183063284819"] = {
						["key"] = "17542154183063284819",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1803.2656677653488,
							["y"] = 330.07977259404606
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303103,
							["MessageNote"] = "点击进入商店",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "MenuWorld.Entrance_Shop",
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
					["17542164738479834681"] = {
						["key"] = "17542164738479834681",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 833.150325176742,
							["y"] = 1039.0567832032375
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303104,
							["MessageNote"] = "点击物资",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ShopMain.ShopTab.List_Tab:4",
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
					["175421723400711800723"] = {
						["key"] = "175421723400711800723",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1138.2412279623666,
							["y"] = 1035.2992047600778
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303105,
							["MessageNote"] = "点击物资",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ShopMain.Common_Toggle_TabGroup_PC.List_Tab:3",
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
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["175421751468113766379"] = {
						["key"] = "175421751468113766379",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1461.938192731873,
							["y"] = 645.7234473010845
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303106,
							["MessageNote"] = "购买委托密函需要消耗对应类型的线索",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ShopMain.List_Item:8",
							["UICompName"] = "Button_Item",
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
					["175421805464115077368"] = {
						["key"] = "175421805464115077368",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1772.5442500918796,
							["y"] = 642.6931466294251
						},
						["propsData"] = {
							["MessageId"] = 303107,
							["MessageNote"] = "在历练中完成委托密函，可以获得奖励。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1756644252647655"] = {
						["key"] = "1756644252647655",
						["type"] = "InputDeviceBranchNode",
						["name"] = "输入设备分支",
						["pos"] = {
							["x"] = 815.1519368386389,
							["y"] = 204.16258802875745
						},
						["propsData"] = {}
					},
					["1756644252647657"] = {
						["key"] = "1756644252647657",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 1405.151936838639,
							["y"] = 270.16258802875745
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
					["17566444402781272875"] = {
						["key"] = "17566444402781272875",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 988,
							["y"] = 676
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303105,
							["MessageNote"] = "点击物资",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ShopMain.ShopTab.List_Tab:4",
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}