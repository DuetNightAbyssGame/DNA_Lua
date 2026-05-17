return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1722052100800867",
			["startPort"] = "StoryStart",
			["endStory"] = "1722052102897914",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1722052102897914",
			["startPort"] = "Success",
			["endStory"] = "1722052100800870",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1722052100800867"] = {
			["isStoryNode"] = true,
			["key"] = "1722052100800867",
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
		["1722052100800870"] = {
			["isStoryNode"] = true,
			["key"] = "1722052100800870",
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
		["1722052102897914"] = {
			["isStoryNode"] = true,
			["key"] = "1722052102897914",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1514,
				["y"] = 292.42105263157896
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
						["startQuest"] = "1722052102897915",
						["startPort"] = "QuestStart",
						["endQuest"] = "1745766695822609",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745766695822609",
						["startPort"] = "Out",
						["endQuest"] = "174577526471023698322",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174577526471023698322",
						["startPort"] = "Out",
						["endQuest"] = "174577538009223699275",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174577538009223699275",
						["startPort"] = "Out",
						["endQuest"] = "174577542364723699981",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174577547609223700784",
						["startPort"] = "Out",
						["endQuest"] = "1722052102897918",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174577542364723699981",
						["startPort"] = "Out",
						["endQuest"] = "174577546700823700522",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174577546700823700522",
						["startPort"] = "Out",
						["endQuest"] = "174577547609223700784",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1722052102897915"] = {
						["key"] = "1722052102897915",
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
					["1722052102897918"] = {
						["key"] = "1722052102897918",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2212.777777777778,
							["y"] = 507.2222222222223
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1722052102897921"] = {
						["key"] = "1722052102897921",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2221.6666666666665,
							["y"] = 781.6666666666666
						},
						["propsData"] = {}
					},
					["1745766695822609"] = {
						["key"] = "1745766695822609",
						["type"] = "ShowGuideButtonNode",
						["name"] = "深度",
						["pos"] = {
							["x"] = 1160,
							["y"] = 208.0000000000001
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302201,
							["MessageNote"] = "每个契约词条每个等级会提供一定的深度值。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeLikeContractPanel.List_Heat:1",
							["UICompName"] = "Text_HeatNum",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["UICompSizeOffset"] = {
								["X"] = 40,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = -10,
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
					["174577526471023698322"] = {
						["key"] = "174577526471023698322",
						["type"] = "ShowGuideButtonNode",
						["name"] = "等级",
						["pos"] = {
							["x"] = 1508,
							["y"] = 207.99999999999994
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302202,
							["MessageNote"] = "部分契约词条有不同的等级。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeLikeContractPanel.List_Heat:1",
							["UICompName"] = "Text_Level",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["UICompSizeOffset"] = {
								["X"] = 150,
								["Y"] = 0
							},
							["UICompLocOffset"] = {
								["X"] = -16,
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
					["174577538009223699275"] = {
						["key"] = "174577538009223699275",
						["type"] = "ShowGuideButtonNode",
						["name"] = "总深度",
						["pos"] = {
							["x"] = 1837.8181818181815,
							["y"] = 205.63636363636363
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302203,
							["MessageNote"] = "总深度值会影响最终结算的行迹加成。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeLikeContractPanel",
							["UICompName"] = "Text_Heat",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["UICompSizeOffset"] = {
								["X"] = 30,
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
					["174577542364723699981"] = {
						["key"] = "174577542364723699981",
						["type"] = "ShowGuideButtonNode",
						["name"] = "确定",
						["pos"] = {
							["x"] = 1161.5,
							["y"] = 398.0454545454544
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302204,
							["MessageNote"] = "点击“确定”后可保存契约配置。",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeLikeContractPanel",
							["UICompName"] = "Btn_Confirm",
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
					["174577546700823700522"] = {
						["key"] = "174577546700823700522",
						["type"] = "ShowGuideButtonNode",
						["name"] = "重置",
						["pos"] = {
							["x"] = 1461.5,
							["y"] = 403.49999999999994
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302205,
							["MessageNote"] = "重置",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeLikeContractPanel",
							["UICompName"] = "Btn_Reset",
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
					["174577547609223700784"] = {
						["key"] = "174577547609223700784",
						["type"] = "ShowGuideButtonNode",
						["name"] = "帮助",
						["pos"] = {
							["x"] = 1795.5909090909088,
							["y"] = 406.22727272727263
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 302206,
							["MessageNote"] = "帮助",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "RougeLikeContractPanel.Btn_Qa",
							["UICompName"] = "Btn_Click",
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