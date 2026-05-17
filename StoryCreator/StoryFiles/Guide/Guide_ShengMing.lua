return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17690659976001",
			["startPort"] = "StoryStart",
			["endStory"] = "1769066823762445",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1769066823762445",
			["startPort"] = "Success",
			["endStory"] = "17690659976005",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17690659976001"] = {
			["isStoryNode"] = true,
			["key"] = "17690659976001",
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
		["17690659976005"] = {
			["isStoryNode"] = true,
			["key"] = "17690659976005",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1908,
				["y"] = 330
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1769066823762445"] = {
			["isStoryNode"] = true,
			["key"] = "1769066823762445",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1302,
				["y"] = 294
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
						["startQuest"] = "1769067514032685643",
						["startPort"] = "Gamepad",
						["endQuest"] = "1769067514032685642",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769067514032685643",
						["startPort"] = "Touch",
						["endQuest"] = "1769067514032685639",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769067514032685643",
						["startPort"] = "MouseAndKeyboard",
						["endQuest"] = "1769067514032685640",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769067514032685640",
						["startPort"] = "Out",
						["endQuest"] = "1769067514032685644",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769067514032685642",
						["startPort"] = "Out",
						["endQuest"] = "1769067514032685644",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769067514032685639",
						["startPort"] = "Out",
						["endQuest"] = "1769067514032685644",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769067514032685644",
						["startPort"] = "Success",
						["endQuest"] = "1769067514032685645",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769067951879687166",
						["startPort"] = "Out",
						["endQuest"] = "17690694532186844813",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690694532186844813",
						["startPort"] = "Out",
						["endQuest"] = "176907056314516422285",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176907056314516422285",
						["startPort"] = "Out",
						["endQuest"] = "176907133833719160377",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769067514032685644",
						["startPort"] = "Fail",
						["endQuest"] = "1769067514032685641",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176907133833719160377",
						["startPort"] = "Out",
						["endQuest"] = "176907364643324637271",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176907364643324637271",
						["startPort"] = "Out",
						["endQuest"] = "176907903723927375681",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176907903723927375681",
						["startPort"] = "Out",
						["endQuest"] = "176907910811328060810",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176908068900431483273",
						["startPort"] = "Out",
						["endQuest"] = "1769066823764454",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176907910811328060810",
						["startPort"] = "Out",
						["endQuest"] = "176908068900431483273",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769066823762446",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769067445396685032",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769067445396685032",
						["startPort"] = "Out",
						["endQuest"] = "1769067951879687166",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1769066823762446"] = {
						["key"] = "1769066823762446",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 654,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769066823764454"] = {
						["key"] = "1769066823764454",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2203.523795712472,
							["y"] = 1098.857152458762
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769066823764462"] = {
						["key"] = "1769066823764462",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3460.952383749249,
							["y"] = 944.1904777186618
						},
						["propsData"] = {}
					},
					["1769067445396685032"] = {
						["key"] = "1769067445396685032",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 978,
							["y"] = 314
						},
						["propsData"] = {
							["MessageId"] = 303701,
							["MessageNote"] = "声名已解锁",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "Upleft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1769067514032685639"] = {
						["key"] = "1769067514032685639",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1756.0599922733265,
							["y"] = 23.155778680561355
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302905,
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
					["1769067514032685640"] = {
						["key"] = "1769067514032685640",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1765.5674777871272,
							["y"] = -343.499952780791
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302905,
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
					["1769067514032685641"] = {
						["key"] = "1769067514032685641",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2494.1231386905633,
							["y"] = -67.891356638876
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303702,
							["MessageNote"] = "点击声名",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "MenuWorld.Panel_Function:13",
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
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1769067514032685642"] = {
						["key"] = "1769067514032685642",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 1723.871351464405,
							["y"] = -120.00949902135739
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
					["1769067514032685643"] = {
						["key"] = "1769067514032685643",
						["type"] = "InputDeviceBranchNode",
						["name"] = "输入设备分支",
						["pos"] = {
							["x"] = 1327.871351464405,
							["y"] = -138.00949902135739
						},
						["propsData"] = {}
					},
					["1769067514032685644"] = {
						["key"] = "1769067514032685644",
						["type"] = "ConditionNode",
						["name"] = "条件节点",
						["pos"] = {
							["x"] = 2229.7940033862974,
							["y"] = -192.79736734713424
						},
						["propsData"] = {
							["ConditionId"] = 4410
						}
					},
					["1769067514032685645"] = {
						["key"] = "1769067514032685645",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2514.8243002047275,
							["y"] = -261.46403683950257
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303702,
							["MessageNote"] = "点击声名",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "MenuWorld.Panel_Function:14",
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
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1769067951879687166"] = {
						["key"] = "1769067951879687166",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2912.344836264908,
							["y"] = 336.8275836214299
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303703,
							["MessageNote"] = "讨伐与惠赠",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "FameMain",
							["UICompName"] = "Btn_Conquer",
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
								["Y"] = 300
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 125
							},
							["MessageParentLoc"] = "HighLightUI",
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17690694532186844813"] = {
						["key"] = "17690694532186844813",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 970.9162639713254,
							["y"] = 691.9704390342656
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303704,
							["MessageNote"] = "等级说明",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "FameMain",
							["UICompName"] = "Fame_Progress",
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
					["176907056314516422285"] = {
						["key"] = "176907056314516422285",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1418.9162639713254,
							["y"] = 711.9704390342656
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303705,
							["MessageNote"] = "奖励说明",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "FameMain.Fame_Progress",
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
					["176907133833719160377"] = {
						["key"] = "176907133833719160377",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1942.9162639713256,
							["y"] = 711.9704390342656
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303706,
							["MessageNote"] = "点击讨伐",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "FameMain.Btn_Conquer",
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
					["176907364643324637271"] = {
						["key"] = "176907364643324637271",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2303.1634955465393,
							["y"] = 697.8624838124056
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303707,
							["MessageNote"] = "难度说明",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "FameTask",
							["UICompName"] = "Group_TaskLevel",
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
					["176907903723927375681"] = {
						["key"] = "176907903723927375681",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2677.3577950830822,
							["y"] = 675.4719202475533
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303708,
							["MessageNote"] = "讨伐说明",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "FameTask",
							["UICompName"] = "Group_Task",
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
					["176907910811328060810"] = {
						["key"] = "176907910811328060810",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 948.7863455783936,
							["y"] = 1030.2338293056782
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303709,
							["MessageNote"] = "讨伐说明",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "FameTask.Fame_Tab.List_Tab:2",
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
					["176908068900431483273"] = {
						["key"] = "176908068900431483273",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1663.072068514215,
							["y"] = 1082.6147823209722
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303710,
							["MessageNote"] = "惠赠说明",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "FameTask",
							["UICompName"] = "List_Item_1",
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