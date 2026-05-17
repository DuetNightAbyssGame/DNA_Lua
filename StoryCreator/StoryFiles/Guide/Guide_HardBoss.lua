return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1700795644731361",
			["startPort"] = "StoryStart",
			["endStory"] = "1700795646572464",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1700795646572464",
			["startPort"] = "Success",
			["endStory"] = "1700795644731364",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1700795644731361"] = {
			["isStoryNode"] = true,
			["key"] = "1700795644731361",
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
		["1700795644731364"] = {
			["isStoryNode"] = true,
			["key"] = "1700795644731364",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2396,
				["y"] = 298
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1700795646572464"] = {
			["isStoryNode"] = true,
			["key"] = "1700795646572464",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1222,
				["y"] = 278
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
						["startQuest"] = "175403064237113932",
						["startPort"] = "Out",
						["endQuest"] = "175403083064215001",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1700795646572465",
						["startPort"] = "QuestStart",
						["endQuest"] = "175402904789811750",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175403052664113487",
						["startPort"] = "Out",
						["endQuest"] = "175403064237113932",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17542136334512621902",
						["startPort"] = "Out",
						["endQuest"] = "1700795646572467",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "175403083064215001",
						["startPort"] = "Out",
						["endQuest"] = "17542136334512621902",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175402904789811750",
						["startPort"] = "Out",
						["endQuest"] = "17566306433572547962",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17566306433572547962",
						["startPort"] = "MouseAndKeyboard",
						["endQuest"] = "175403008514012527",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566306433572547962",
						["startPort"] = "Touch",
						["endQuest"] = "175403008514012529",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175403008514012529",
						["startPort"] = "Out",
						["endQuest"] = "175403052664113487",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566306433572547962",
						["startPort"] = "Gamepad",
						["endQuest"] = "17566306789562549051",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566306789562549051",
						["startPort"] = "Out",
						["endQuest"] = "17566307024822549330",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17566307024822549330",
						["startPort"] = "Out",
						["endQuest"] = "17683750219427279982",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175403008514012527",
						["startPort"] = "Out",
						["endQuest"] = "17683750219427279982",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17683750219427279982",
						["startPort"] = "Out",
						["endQuest"] = "175403064237113932",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1700795646572465"] = {
						["key"] = "1700795646572465",
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
					["1700795646572467"] = {
						["key"] = "1700795646572467",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3641.1862031673745,
							["y"] = 325.4548538432345
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1700795646572469"] = {
						["key"] = "1700795646572469",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17007956518031009"] = {
						["key"] = "17007956518031009",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 2810,
							["y"] = 1026
						},
						["propsData"] = {
							["GuideId"] = 11
						}
					},
					["175402904789811750"] = {
						["key"] = "175402904789811750",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1122,
							["y"] = 296
						},
						["propsData"] = {
							["MessageId"] = 303001,
							["MessageNote"] = "梦魇残声中记录着与你交手过的强大敌人",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["175403008514012527"] = {
						["key"] = "175403008514012527",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1732.6827714291837,
							["y"] = 112.91288310606821
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300801,
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
					["175403008514012528"] = {
						["key"] = "175403008514012528",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 1410.9296193240593,
							["y"] = -197.33264923327488
						},
						["propsData"] = {}
					},
					["175403008514012529"] = {
						["key"] = "175403008514012529",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1754.3607037329266,
							["y"] = 599.2069320522012
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300801,
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
					["175403052664113487"] = {
						["key"] = "175403052664113487",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2159.354837856233,
							["y"] = 561.2258064119178
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303002,
							["MessageNote"] = "点击梦魇残声",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "StyleOfPlay.ComTab.EMScrollBox_TabItem:3",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["175403064237113932"] = {
						["key"] = "175403064237113932",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 2429.9999840028827,
							["y"] = 305.0322613989029
						},
						["propsData"] = {
							["MessageId"] = 303003,
							["MessageNote"] = "梦魇残声挑战中的首领敌人拥有更强大的战斗力",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["175403083064215001"] = {
						["key"] = "175403083064215001",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2740.064501263225,
							["y"] = 316.32258384061527
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303004,
							["MessageNote"] = "每周共可从梦魇残声挑战中获得3次奖励",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "StyleOfPlay.Group_HardBoss:1.ListView_Rewards",
							["UICompName"] = "",
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
					["1754212992230961"] = {
						["key"] = "1754212992230961",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1889.1539539772548,
							["y"] = -146.14814200413207
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303002,
							["MessageNote"] = "点击梦魇残声",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "StyleOfPlay.ComTab.EMScrollBox_TabItem:3",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17542136334512621902"] = {
						["key"] = "17542136334512621902",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 3223.399270181391,
							["y"] = 304.0182515418913
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303005,
							["MessageNote"] = "点击前往挑战",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "StyleOfPlay.Group_HardBoss:1.Btn_Enter",
							["UICompName"] = "Button_Area",
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17566306433572547962"] = {
						["key"] = "17566306433572547962",
						["type"] = "InputDeviceBranchNode",
						["name"] = "输入设备分支",
						["pos"] = {
							["x"] = 1398.7741954339037,
							["y"] = 263.16129284321835
						},
						["propsData"] = {}
					},
					["17566306789562549051"] = {
						["key"] = "17566306789562549051",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 1634.2580635039046,
							["y"] = 305.09677619815005
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
					["17566307024822549330"] = {
						["key"] = "17566307024822549330",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1874.5806411917824,
							["y"] = 306.70967940410895
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300801,
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
					},
					["17683750219427279982"] = {
						["key"] = "17683750219427279982",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2146.111342831805,
							["y"] = 238.34145450868937
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303002,
							["MessageNote"] = "点击梦魇残声",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "StyleOfPlay.ComTab.EMScrollBox_TabItem:3",
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}