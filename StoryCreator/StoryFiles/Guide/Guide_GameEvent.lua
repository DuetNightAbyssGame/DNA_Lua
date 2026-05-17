return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "172378365239726217",
			["startPort"] = "StoryStart",
			["endStory"] = "172378365337726268",
			["endPort"] = "In"
		},
		{
			["startStory"] = "172378365337726268",
			["startPort"] = "Success",
			["endStory"] = "172378365239726220",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["172378365239726217"] = {
			["isStoryNode"] = true,
			["key"] = "172378365239726217",
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
		["172378365239726220"] = {
			["isStoryNode"] = true,
			["key"] = "172378365239726220",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1699.0000000000014,
				["y"] = 323.99999999999994
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["172378365337726268"] = {
			["isStoryNode"] = true,
			["key"] = "172378365337726268",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1229.9036763165018,
				["y"] = 300.20199130757413
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
						["startQuest"] = "172378365337726275",
						["startPort"] = "Out",
						["endQuest"] = "172378365337726276",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172378365337726272",
						["startPort"] = "QuestStart",
						["endQuest"] = "172378365337726275",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172378365337726278",
						["startPort"] = "Out",
						["endQuest"] = "172378365337726273",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "172378365337726276",
						["startPort"] = "Out",
						["endQuest"] = "172378365337726278",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["172378365337726272"] = {
						["key"] = "172378365337726272",
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
					["172378365337726273"] = {
						["key"] = "172378365337726273",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2138.734615384616,
							["y"] = 287.9769230769231
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["172378365337726274"] = {
						["key"] = "172378365337726274",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["172378365337726275"] = {
						["key"] = "172378365337726275",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1103.8795455189843,
							["y"] = 285.5064979669668
						},
						["propsData"] = {
							["MessageId"] = 302001,
							["MessageNote"] = "活动已解锁，参与各种各样的活动，可以获得丰富的奖励哦！",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["172378365337726276"] = {
						["key"] = "172378365337726276",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1395.1670913065298,
							["y"] = 278.39660785707673
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302002,
							["MessageNote"] = "点击<Highlight>“活动”</>进入活动界面。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = false,
							["HighLightUIPath"] = "BattleMain.ListView:18",
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
					["172378365337726278"] = {
						["key"] = "172378365337726278",
						["type"] = "ShowGuideButtonNode",
						["name"] = "领取按钮",
						["pos"] = {
							["x"] = 1739.5590326984716,
							["y"] = 281.3835687222983
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302003,
							["MessageNote"] = "点击“全部领取”，领取活动奖励。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ActivityMain.Group_Anchor:1.Btn_GetAllBtn",
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