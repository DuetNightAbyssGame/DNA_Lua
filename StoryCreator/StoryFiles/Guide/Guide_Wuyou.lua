return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17690486101351",
			["startPort"] = "StoryStart",
			["endStory"] = "1769049459905725",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1769049459905725",
			["startPort"] = "Success",
			["endStory"] = "17690486101355",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17690486101351"] = {
			["isStoryNode"] = true,
			["key"] = "17690486101351",
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
		["17690486101355"] = {
			["isStoryNode"] = true,
			["key"] = "17690486101355",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1840,
				["y"] = 342
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1769049459905725"] = {
			["isStoryNode"] = true,
			["key"] = "1769049459905725",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1236,
				["y"] = 332
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
						["startQuest"] = "1769049459905726",
						["startPort"] = "QuestStart",
						["endQuest"] = "17690505631211956",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690505631211956",
						["startPort"] = "Out",
						["endQuest"] = "17690629038196836798",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690629038196836798",
						["startPort"] = "Out",
						["endQuest"] = "1769049459906734",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1769049459905726"] = {
						["key"] = "1769049459905726",
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
					["1769049459906734"] = {
						["key"] = "1769049459906734",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769049459907742"] = {
						["key"] = "1769049459907742",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17690505631211956"] = {
						["key"] = "17690505631211956",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1288,
							["y"] = 366
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303601,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ActivityWuyoushengMain.Anchor:1.Text_LevelEffectDesc",
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17690629038196836798"] = {
						["key"] = "17690629038196836798",
						["type"] = "ShowGuideButtonNode",
						["name"] = "Button显示/隐藏信息",
						["pos"] = {
							["x"] = 1706,
							["y"] = 380
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 303602,
							["MessageNote"] = "",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ActivityWuyoushengMain.Anchor:1.MonsterList",
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