return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17733707360011",
			["startPort"] = "StoryStart",
			["endStory"] = "1773370809148118",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1773370809148118",
			["startPort"] = "Success",
			["endStory"] = "17733707360015",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17733707360011"] = {
			["isStoryNode"] = true,
			["key"] = "17733707360011",
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
		["17733707360015"] = {
			["isStoryNode"] = true,
			["key"] = "17733707360015",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1656,
				["y"] = 332
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1773370809148118"] = {
			["isStoryNode"] = true,
			["key"] = "1773370809148118",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1192,
				["y"] = 328
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
						["startQuest"] = "1773370809148119",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773382649254864194",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "1773382649254864194",
						["startPort"] = "PC",
						["endQuest"] = "1773370809149127",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1773382649254864194",
						["startPort"] = "Mobile",
						["endQuest"] = "1773382662959864601",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773382662959864601",
						["startPort"] = "Out",
						["endQuest"] = "17733829073663454189",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17733829073663454189",
						["startPort"] = "Out",
						["endQuest"] = "1773370809149127",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1773370809148119"] = {
						["key"] = "1773370809148119",
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
					["1773370809149127"] = {
						["key"] = "1773370809149127",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2410,
							["y"] = 44
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1773370809149135"] = {
						["key"] = "1773370809149135",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1773382649254864194"] = {
						["key"] = "1773382649254864194",
						["type"] = "PlatformJudgmentNode",
						["name"] = "PC/手机平台判断(云游戏视为手机)",
						["pos"] = {
							["x"] = 1222,
							["y"] = 290
						},
						["propsData"] = {}
					},
					["1773382662959864601"] = {
						["key"] = "1773382662959864601",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1314,
							["y"] = 638
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303901,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "CustomHUDSetting",
							["UICompName"] = "Btn_Add",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
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
							["MessageLoc"] = "Down",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17733829073663454189"] = {
						["key"] = "17733829073663454189",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1724,
							["y"] = 632
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303902,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "CustomHUDSetting.SchemeRight",
							["UICompName"] = "Solution_Item1",
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
								["Y"] = 90
							},
							["UICompLocOffset"] = {
								["X"] = 0,
								["Y"] = 45
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