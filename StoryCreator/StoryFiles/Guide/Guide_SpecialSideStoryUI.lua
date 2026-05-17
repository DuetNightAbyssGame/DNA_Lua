return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17454761535772283724",
			["startPort"] = "StoryStart",
			["endStory"] = "17454761535772283726",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17454761535772283726",
			["startPort"] = "Success",
			["endStory"] = "17454761535772283725",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17454761535772283724"] = {
			["isStoryNode"] = true,
			["key"] = "17454761535772283724",
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
		["17454761535772283725"] = {
			["isStoryNode"] = true,
			["key"] = "17454761535772283725",
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
		["17454761535772283726"] = {
			["isStoryNode"] = true,
			["key"] = "17454761535772283726",
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
						["startQuest"] = "1745757086551552458",
						["startPort"] = "Out",
						["endQuest"] = "1745757086551552459",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745757086551552459",
						["startPort"] = "Out",
						["endQuest"] = "1745757086551552460",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745757086551552460",
						["startPort"] = "Out",
						["endQuest"] = "1745757086551552461",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17454761535772283732",
						["startPort"] = "QuestStart",
						["endQuest"] = "1745757086551552458",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745757086551552461",
						["startPort"] = "Out",
						["endQuest"] = "17457624161901101319",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17457624161901101319",
						["startPort"] = "Out",
						["endQuest"] = "17454761535772283733",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17454761535772283732"] = {
						["key"] = "17454761535772283732",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 680.9913043478261,
							["y"] = 294.67826086956524
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17454761535772283733"] = {
						["key"] = "17454761535772283733",
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
					["17454761535772283734"] = {
						["key"] = "17454761535772283734",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1745757086551552458"] = {
						["key"] = "1745757086551552458",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1032.0738927738928,
							["y"] = 304.9209790209791
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
					["1745757086551552459"] = {
						["key"] = "1745757086551552459",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1369.632867132867,
							["y"] = 293.6734265734267
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
					["1745757086551552460"] = {
						["key"] = "1745757086551552460",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1706.7405392023509,
							["y"] = 296.82130516542315
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
					["1745757086551552461"] = {
						["key"] = "1745757086551552461",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2035.9261072261074,
							["y"] = 287.0790209790209
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
							["HighLightUIPath"] = "TaskPanel.WBP_Task_Root.List_Task:1.Task_SubItem.Common_List_Subcell_PC",
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
					["17457624161901101319"] = {
						["key"] = "17457624161901101319",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2333.3933731387287,
							["y"] = 407.8000051279092
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300405,
							["MessageNote"] = "点击追踪任务",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}