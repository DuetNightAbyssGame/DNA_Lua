return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1756632491595381212",
			["startPort"] = "StoryStart",
			["endStory"] = "1756632491595381214",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1756632491595381214",
			["startPort"] = "Success",
			["endStory"] = "1756632491595381213",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1756632491595381212"] = {
			["isStoryNode"] = true,
			["key"] = "1756632491595381212",
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
		["1756632491595381213"] = {
			["isStoryNode"] = true,
			["key"] = "1756632491595381213",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1576,
				["y"] = 298
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1756632491595381214"] = {
			["isStoryNode"] = true,
			["key"] = "1756632491595381214",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1166,
				["y"] = 282
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
						["startQuest"] = "1756632491595381215",
						["startPort"] = "QuestStart",
						["endQuest"] = "1756632491595381222",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756632491595381222",
						["startPort"] = "Out",
						["endQuest"] = "1756632491595381216",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1756632491595381215"] = {
						["key"] = "1756632491595381215",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 254,
							["y"] = 142
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756632491595381216"] = {
						["key"] = "1756632491595381216",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1174,
							["y"] = 162
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1756632491595381217"] = {
						["key"] = "1756632491595381217",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1756632491595381218"] = {
						["key"] = "1756632491595381218",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1712.2720588235295,
							["y"] = -337.9264705882353
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302601,
							["MessageNote"] = "进入整备",
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
							["IsResetPlayer"] = true,
							["IsForbidInAnim"] = false,
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
					["1756632491595381219"] = {
						["key"] = "1756632491595381219",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 2720,
							["y"] = -186.00000000000006
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302603,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.EMListView_SubTab:2",
							["UICompName"] = "TextBlock_Name",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = false,
							["UICompSizeOffset"] = {
								["X"] = 60,
								["Y"] = 20
							},
							["UICompLocOffset"] = {
								["X"] = -20,
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
					["1756632491595381220"] = {
						["key"] = "1756632491595381220",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 2880,
							["y"] = -2
						},
						["propsData"] = {
							["MessageId"] = 0,
							["MessageNote"] = "",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = ""
						}
					},
					["1756632491595381221"] = {
						["key"] = "1756632491595381221",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 888,
							["y"] = 988
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303206,
							["MessageNote"] = "点击魔灵训练",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:3.Btn_Mix",
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
					["1756632491595381222"] = {
						["key"] = "1756632491595381222",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 738,
							["y"] = 176
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303207,
							["MessageNote"] = "添加失活魔灵",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "PetMix",
							["UICompName"] = "Btn_Add",
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
					["1756632491595381223"] = {
						["key"] = "1756632491595381223",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1339.5913382141675,
							["y"] = -100.63310341272734
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1756632491595381224"] = {
						["key"] = "1756632491595381224",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1899.6923086578952,
							["y"] = 983.3333291491213
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303207,
							["MessageNote"] = "点击魔灵训练",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:3.Btn_Mix",
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
							["MessageLoc"] = "UpLeft",
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