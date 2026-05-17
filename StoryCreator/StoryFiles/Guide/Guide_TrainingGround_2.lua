return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "171851536830111576305",
			["startPort"] = "StoryStart",
			["endStory"] = "171851536830111576307",
			["endPort"] = "In"
		},
		{
			["startStory"] = "171851536830111576307",
			["startPort"] = "Success",
			["endStory"] = "171851536830111576306",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["171851536830111576305"] = {
			["isStoryNode"] = true,
			["key"] = "171851536830111576305",
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
		["171851536830111576306"] = {
			["isStoryNode"] = true,
			["key"] = "171851536830111576306",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1508.235294117647,
				["y"] = 312.35294117647055
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["171851536830111576307"] = {
			["isStoryNode"] = true,
			["key"] = "171851536830111576307",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1133.140730225936,
				["y"] = 297.6286915119693
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
						["startQuest"] = "1717657751774264930",
						["startPort"] = "Out",
						["endQuest"] = "1717658634841267181",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1717657719626264455",
						["startPort"] = "Out",
						["endQuest"] = "1717657751774264930",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "171851536830111576308",
						["startPort"] = "QuestStart",
						["endQuest"] = "1717657719626264455",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1717659674690272156",
						["startPort"] = "Out",
						["endQuest"] = "171851536830111576309",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17490106110711172157",
						["startPort"] = "MouseAndKeyboard",
						["endQuest"] = "1717659001920267758",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17490106110711172157",
						["startPort"] = "Gamepad",
						["endQuest"] = "17490106210051172419",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1717658634841267181",
						["startPort"] = "Out",
						["endQuest"] = "17490453197469307563",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17490453197469307563",
						["startPort"] = "PC",
						["endQuest"] = "17490106110711172157",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17490453197469307563",
						["startPort"] = "Mobile",
						["endQuest"] = "1717659001920267758",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1717659001920267758",
						["startPort"] = "Out",
						["endQuest"] = "1717659224853268828",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17490106210051172419",
						["startPort"] = "Out",
						["endQuest"] = "1717659224853268828",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1717659224853268828",
						["startPort"] = "Out",
						["endQuest"] = "1717659674690272156",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1717657719626264455"] = {
						["key"] = "1717657719626264455",
						["type"] = "ShowGuideToastNode",
						["name"] = "Toast显示/隐藏信息",
						["pos"] = {
							["x"] = 465.36579416455515,
							["y"] = 277.9100214352432
						},
						["propsData"] = {
							["ShowEnable"] = false,
							["MessageId"] = 301401,
							["MessageNote"] = "打开训练菜单",
							["LastTime"] = -1,
							["Style"] = "Normal"
						}
					},
					["1717657751774264930"] = {
						["key"] = "1717657751774264930",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 731.5842815854634,
							["y"] = 288.4982567293608
						},
						["propsData"] = {
							["MessageId"] = 301501,
							["MessageNote"] = "在沙海冥想中，我们可以回忆曾经见过的敌人，并与它们进行自主的战斗。可以以此熟悉它们的招式、测试自己的技能。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1717658634841267181"] = {
						["key"] = "1717658634841267181",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 990.8133644970356,
							["y"] = 265.4803539160616
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301502,
							["MessageNote"] = "点击“疾冲秽兽”",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.Training_Root.List_Item:1",
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
					["1717659001920267758"] = {
						["key"] = "1717659001920267758",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1909.860679075041,
							["y"] = 27.24122348127902
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301503,
							["MessageNote"] = "点击“+”，可以增加生成的敌人数量",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.Training_Root.Com_Slider.Btn_Add",
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
					["1717659148974268395"] = {
						["key"] = "1717659148974268395",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2195.709783934376,
							["y"] = 27.310277189718903
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301504,
							["MessageNote"] = "若选择了多个敌人，可以在这里分别调整其生成数量。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.Training_Root.Btn_Show",
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
					["1717659224853268828"] = {
						["key"] = "1717659224853268828",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1093.3760243435834,
							["y"] = 472.3345738649108
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301505,
							["MessageNote"] = "点击“+”，可以增加敌人的等级。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.Training_Root.Com_NumInput.Btn_Add",
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
							["MessageLoc"] = "UpLeft",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1717659421329269714"] = {
						["key"] = "1717659421329269714",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1355.1407304075885,
							["y"] = 646.9564194644178
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301506,
							["MessageNote"] = "这里可以选择是否开启玩家的无敌状态。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.Training_Root.InvincibleSetting.Btn_Setting",
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
							["MessageLoc"] = "UpLeft",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1717659509411270787"] = {
						["key"] = "1717659509411270787",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1640.9558561985057,
							["y"] = 644.0152431754817
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301507,
							["MessageNote"] = "这里可以选择是否开启敌人的AI。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.Training_Root.AISetting.Btn_Setting",
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
							["MessageLoc"] = "UpLeft",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1717659674690272156"] = {
						["key"] = "1717659674690272156",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1790.8718254395956,
							["y"] = 472.33457386491074
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301508,
							["MessageNote"] = "在配置完毕后，点击“生成敌人”，即可开始战斗。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.Training_Root.Btn_Generate",
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
							["MessageLoc"] = "Up",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["171851536830111576308"] = {
						["key"] = "171851536830111576308",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 198.695652173913,
							["y"] = 273.2225063938619
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851536830111576309"] = {
						["key"] = "171851536830111576309",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2212.1848739495795,
							["y"] = 469.2436974789915
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851536830111576310"] = {
						["key"] = "171851536830111576310",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17490106110711172157"] = {
						["key"] = "17490106110711172157",
						["type"] = "InputDeviceBranchNode",
						["name"] = "输入设备分支",
						["pos"] = {
							["x"] = 1582.3695652173915,
							["y"] = 3.3260869565217206
						},
						["propsData"] = {}
					},
					["17490106210051172419"] = {
						["key"] = "17490106210051172419",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1916.7753623188407,
							["y"] = 212.35304774083556
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301503,
							["MessageNote"] = "点击“+”，可以增加生成的敌人数量",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.Training_Root.Com_Slider.Key_Add",
							["UICompName"] = "Button_Key",
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
					["17490106719231172677"] = {
						["key"] = "17490106719231172677",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2632.666666666667,
							["y"] = 263.0269607843138
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301504,
							["MessageNote"] = "若选择了多个敌人，可以在这里分别调整其生成数量。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.WBP_Training_Root.Key_BottomNum",
							["UICompName"] = "Button_Key",
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
					["17490117101836398655"] = {
						["key"] = "17490117101836398655",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2207.9057971014495,
							["y"] = 213.13565643648772
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 301504,
							["MessageNote"] = "若选择了多个敌人，可以在这里分别调整其生成数量。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TrainingGroundSetup.Training_Root.Btn_Show",
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
					["17490453197469307563"] = {
						["key"] = "17490453197469307563",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断",
						["pos"] = {
							["x"] = 1307.1304347826085,
							["y"] = 235.91304347826085
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}