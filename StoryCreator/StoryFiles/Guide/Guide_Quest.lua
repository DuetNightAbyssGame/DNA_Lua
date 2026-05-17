return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17008104628832179",
			["startPort"] = "StoryStart",
			["endStory"] = "17008104656692378",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17008104656692378",
			["startPort"] = "Success",
			["endStory"] = "17008104628842182",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17008104628832179"] = {
			["isStoryNode"] = true,
			["key"] = "17008104628832179",
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
		["17008104628842182"] = {
			["isStoryNode"] = true,
			["key"] = "17008104628842182",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2800,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17008104656692378"] = {
			["isStoryNode"] = true,
			["key"] = "17008104656692378",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1194,
				["y"] = 312
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
						["startQuest"] = "17008104656692379",
						["startPort"] = "QuestStart",
						["endQuest"] = "17008104706082854",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17008104706082855",
						["startPort"] = "Out",
						["endQuest"] = "170082303881916603",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170082303881916603",
						["startPort"] = "Out",
						["endQuest"] = "17022863467898260",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17022863467898260",
						["startPort"] = "Out",
						["endQuest"] = "17022869462559245",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17022869462559245",
						["startPort"] = "Out",
						["endQuest"] = "1746603170528559462",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1746603170528559462",
						["startPort"] = "Out",
						["endQuest"] = "17008104656692381",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1755524148250622",
						["startPort"] = "Gamepad",
						["endQuest"] = "1755524148250623",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755524148250622",
						["startPort"] = "Touch",
						["endQuest"] = "17555241889261525",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17555241889261525",
						["startPort"] = "Out",
						["endQuest"] = "170082303881916603",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755524148250622",
						["startPort"] = "MouseAndKeyboard",
						["endQuest"] = "17008104706082855",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1755524148250623",
						["startPort"] = "Out",
						["endQuest"] = "17555242332952124",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17555242332952124",
						["startPort"] = "Out",
						["endQuest"] = "170082303881916603",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17008104706082854",
						["startPort"] = "Out",
						["endQuest"] = "1755524148250622",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17008104656692379"] = {
						["key"] = "17008104656692379",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 92.85713429353666,
							["y"] = 295.2380951804279
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17008104656692381"] = {
						["key"] = "17008104656692381",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2694.509090909091,
							["y"] = 316.2
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17008104656692383"] = {
						["key"] = "17008104656692383",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17008104706082854"] = {
						["key"] = "17008104706082854",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 421.2776471140495,
							["y"] = 290.8073259496586
						},
						["propsData"] = {
							["MessageId"] = 300401,
							["MessageNote"] = "当不知道做什么的时候，就打开<H>任务笔记</>看看吧！",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17008104706082855"] = {
						["key"] = "17008104706082855",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1427.5179495957552,
							["y"] = 21.50117149951143
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300402,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.Btn_Task",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["170082303881916603"] = {
						["key"] = "170082303881916603",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1803.087159248971,
							["y"] = 287.4695569136749
						},
						["propsData"] = {
							["MessageId"] = 300403,
							["MessageNote"] = "在这里可以查看所接取的各种任务详情，部分任务需要完成前置任务后才能继续进行。追踪任务可以很方便地找到任务目标。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17022863467898260"] = {
						["key"] = "17022863467898260",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2132.2727272727275,
							["y"] = 277.7272727272727
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300404,
							["MessageNote"] = "点击流浪的皎皎任务",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TaskPanel.WBP_Task_Root.List_Task:2.Task_SubItem.Common_List_Subcell_PC",
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
					["17022869462559245"] = {
						["key"] = "17022869462559245",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2444.832046401874,
							["y"] = 290.35852173951463
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300405,
							["MessageNote"] = "点击追踪任务",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "TaskPanel.WBP_Task_Root.Common_Button_Text_PC",
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
					["1746603170528559462"] = {
						["key"] = "1746603170528559462",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 2555.112076648841,
							["y"] = 484.6116138763198
						},
						["propsData"] = {
							["GuideId"] = 73
						}
					},
					["1755524148250622"] = {
						["key"] = "1755524148250622",
						["type"] = "InputDeviceBranchNode",
						["name"] = "输入设备分支",
						["pos"] = {
							["x"] = 691.0131409589566,
							["y"] = 250.76405571352115
						},
						["propsData"] = {}
					},
					["1755524148250623"] = {
						["key"] = "1755524148250623",
						["type"] = "ShowGuideNode",
						["name"] = "显示引导（支持执行操作后自动关闭/强制引导）",
						["pos"] = {
							["x"] = 1035.8304104624303,
							["y"] = 269.83382340826023
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
					["17555241889261525"] = {
						["key"] = "17555241889261525",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1134.1205785717439,
							["y"] = 484.143843693618
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300402,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.Btn_Task",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17555242332952124"] = {
						["key"] = "17555242332952124",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1349.5051890406417,
							["y"] = 293.11820702775026
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300402,
							["MessageNote"] = "点击<H>“任务”</>进入整备系统。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "MenuWorld.Panel_Function:4",
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}