return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1700645317962151672",
			["startPort"] = "StoryStart",
			["endStory"] = "1700645320375151879",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1700645320375151879",
			["startPort"] = "Success",
			["endStory"] = "1700645317962151675",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1700645317962151672"] = {
			["isStoryNode"] = true,
			["key"] = "1700645317962151672",
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
		["1700645317962151675"] = {
			["isStoryNode"] = true,
			["key"] = "1700645317962151675",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1715.5000000000005,
				["y"] = 348
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1700645320375151879"] = {
			["isStoryNode"] = true,
			["key"] = "1700645320375151879",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1169.6111273471176,
				["y"] = 266.13782717415813
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
						["startQuest"] = "1700645326296152518",
						["startPort"] = "Out",
						["endQuest"] = "1700645326296152519",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1700645320375151880",
						["startPort"] = "QuestStart",
						["endQuest"] = "1700645326296152518",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1700645326296152519",
						["startPort"] = "Out",
						["endQuest"] = "1700653560994160427",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1700653560994160427",
						["startPort"] = "Out",
						["endQuest"] = "1700653567255160901",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1700653567255160901",
						["startPort"] = "Out",
						["endQuest"] = "1700645320376151882",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1700645320375151880"] = {
						["key"] = "1700645320375151880",
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
					["1700645320376151882"] = {
						["key"] = "1700645320376151882",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2597.7346153846156,
							["y"] = 275.9769230769231
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1700645320376151884"] = {
						["key"] = "1700645320376151884",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1700645326296152518"] = {
						["key"] = "1700645326296152518",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1103.8795455189843,
							["y"] = 285.5064979669668
						},
						["propsData"] = {
							["MessageId"] = 300201,
							["MessageNote"] = "【待包装】我们完成了一个成就，让我们去领取成就奖励吧！",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1700645326296152519"] = {
						["key"] = "1700645326296152519",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1395.1670913065298,
							["y"] = 278.39660785707673
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300202,
							["MessageNote"] = "点击<H>“成就”</>进入成就系统。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.ListView:7",
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
							["MessageLoc"] = "Down",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1700653560994160427"] = {
						["key"] = "1700653560994160427",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1672.487604127043,
							["y"] = 276.06928300801246
						},
						["propsData"] = {
							["MessageId"] = 300203,
							["MessageNote"] = "【待包装】我们完成了一个成就，让我们去领取成就奖励吧！",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1700653567255160901"] = {
						["key"] = "1700653567255160901",
						["type"] = "ShowGuideButtonNode",
						["name"] = "领取按钮",
						["pos"] = {
							["x"] = 1949.5590326984714,
							["y"] = 261.8835687222983
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300204,
							["MessageNote"] = "点击“领取”，领取成就奖励。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "AchievementSystem.List_Item:1.Common_RewardsBtn_PC",
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