return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17636053500051",
			["startPort"] = "StoryStart",
			["endStory"] = "1763605375660119",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1763605375660119",
			["startPort"] = "Success",
			["endStory"] = "17636053500055",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17636053500051"] = {
			["isStoryNode"] = true,
			["key"] = "17636053500051",
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
		["17636053500055"] = {
			["isStoryNode"] = true,
			["key"] = "17636053500055",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1590,
				["y"] = 322
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1763605375660119"] = {
			["isStoryNode"] = true,
			["key"] = "1763605375660119",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1184,
				["y"] = 304
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
						["startQuest"] = "1763605790694674359",
						["startPort"] = "MouseAndKeyboard",
						["endQuest"] = "1763605790694674358",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763605790694674359",
						["startPort"] = "Gamepad",
						["endQuest"] = "1763605790694674360",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763605790694674360",
						["startPort"] = "Out",
						["endQuest"] = "1763605790694674361",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763605790694674359",
						["startPort"] = "Touch",
						["endQuest"] = "1763605790694674357",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763605790694674355",
						["startPort"] = "Out",
						["endQuest"] = "1763605790694674359",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1763605790694674361",
						["startPort"] = "Out",
						["endQuest"] = "1763605790694674356",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763605790694674357",
						["startPort"] = "Out",
						["endQuest"] = "1763605790694674356",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763605790694674358",
						["startPort"] = "Out",
						["endQuest"] = "1763605790694674356",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763605375660120",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763605790694674355",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763605790694674356",
						["startPort"] = "Out",
						["endQuest"] = "1763642008722980",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763642008722980",
						["startPort"] = "Out",
						["endQuest"] = "17636426061702037756",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636426061702037756",
						["startPort"] = "Out",
						["endQuest"] = "17637263085442056287",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637263085442056287",
						["startPort"] = "Out",
						["endQuest"] = "1763605375660127",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1763605375660120"] = {
						["key"] = "1763605375660120",
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
					["1763605375660127"] = {
						["key"] = "1763605375660127",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2395.4440227198866,
							["y"] = 737.1042389783846
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1763605375661134"] = {
						["key"] = "1763605375661134",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1763605790694674355"] = {
						["key"] = "1763605790694674355",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1278.7540141298168,
							["y"] = 363.28673291481834
						},
						["propsData"] = {
							["MessageId"] = 303501,
							["MessageNote"] = "【待包装】通过配置战斗背包，可以在战斗中使用各种道具辅助战斗，也可以召唤协战伙伴一起参与战斗。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = true,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1763605790694674356"] = {
						["key"] = "1763605790694674356",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 2393.245985870183,
							["y"] = 336.22352879991183
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300603,
							["MessageNote"] = "打开战术背包",
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
					["1763605790694674357"] = {
						["key"] = "1763605790694674357",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1832.7656748872555,
							["y"] = 506.6060764274976
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
					["1763605790694674358"] = {
						["key"] = "1763605790694674358",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1952.0717838113387,
							["y"] = 137.3939235725024
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
					["1763605790694674359"] = {
						["key"] = "1763605790694674359",
						["type"] = "InputDeviceBranchNode",
						["name"] = "输入设备分支",
						["pos"] = {
							["x"] = 1537.581167712769,
							["y"] = 264.20129408109284
						},
						["propsData"] = {}
					},
					["1763605790694674360"] = {
						["key"] = "1763605790694674360",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 1880.9698658136215,
							["y"] = 283.2710617758319
						},
						["propsData"] = {
							["MessageId"] = 301611,
							["SkillNameList"] = {
								"OpenMenu"
							},
							["LastTime"] = -1,
							["bIsForceTouch"] = true,
							["bIsTimeDilation"] = false,
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
					["1763605790694674361"] = {
						["key"] = "1763605790694674361",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2115.541885392952,
							["y"] = 316.7181587064619
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
					["1763642008722980"] = {
						["key"] = "1763642008722980",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1074.8446582942872,
							["y"] = 740.3863911373735
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303502,
							["MessageNote"] = "点击探索道具",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:2.WB_Tab:2",
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
							["MessageLoc"] = "UpRight",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17636426061702037756"] = {
						["key"] = "17636426061702037756",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1501.9875076779986,
							["y"] = 743.2435339426155
						},
						["propsData"] = {
							["MessageId"] = 303503,
							["MessageNote"] = "【待包装】通过配置战斗背包，可以在战斗中使用各种道具辅助战斗，也可以召唤协战伙伴一起参与战斗。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17637263085442056287"] = {
						["key"] = "17637263085442056287",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1898.9915996016907,
							["y"] = 774.9135585027345
						},
						["propsData"] = {
							["GuideId"] = 90
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}