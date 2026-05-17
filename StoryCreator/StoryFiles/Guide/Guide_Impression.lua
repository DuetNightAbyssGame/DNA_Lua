return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "170169214572918358",
			["startPort"] = "StoryStart",
			["endStory"] = "170169214626418414",
			["endPort"] = "In"
		},
		{
			["startStory"] = "170169214626418414",
			["startPort"] = "Success",
			["endStory"] = "170169214572918361",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["170169214572918358"] = {
			["isStoryNode"] = true,
			["key"] = "170169214572918358",
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
		["170169214572918361"] = {
			["isStoryNode"] = true,
			["key"] = "170169214572918361",
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
		["170169214626418414"] = {
			["isStoryNode"] = true,
			["key"] = "170169214626418414",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1348.716291139949,
				["y"] = 327.1652095048279
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
				["bIsNotifyGameMode"] = false,
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
						["startQuest"] = "170169246299820208",
						["startPort"] = "Out",
						["endQuest"] = "170169246993020714",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170591852470819666",
						["startPort"] = "Out",
						["endQuest"] = "170169246299820208",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170169246993020714",
						["startPort"] = "Out",
						["endQuest"] = "1719410379523415231",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1719410379523415231",
						["startPort"] = "Out",
						["endQuest"] = "1704175978670173503",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1704175978670173502",
						["startPort"] = "QuestStart",
						["endQuest"] = "17581025082001239036",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17581025082001239036",
						["startPort"] = "Out",
						["endQuest"] = "170591852470819666",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1700640589641134659"] = {
						["key"] = "1700640589641134659",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1089.500091775291,
							["y"] = 50.92426199844158
						},
						["propsData"] = {
							["MessageId"] = 300004,
							["MessageNote"] = "在近战武器配置界面中，可以查看近战武器的属性、为近战武器升级、替换其他近战武器等。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1700640593629134942"] = {
						["key"] = "1700640593629134942",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 1363.8590661342653,
							["y"] = 49.38580045998007
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300002,
							["MessageNote"] = "点击<H>“整备”</>进入整备系统。",
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
							["MessageLoc"] = "Down",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1700640602353135611"] = {
						["key"] = "1700640602353135611",
						["type"] = "ShowGuideButtonNode",
						["name"] = "UI内ListView",
						["pos"] = {
							["x"] = 1667.448809724009,
							["y"] = 61.82169789587712
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300003,
							["MessageNote"] = "点击“近战武器”页签，进行近战武器配置。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew.ListView_Tab:3",
							["UICompName"] = "Text_1",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1700640608522135930"] = {
						["key"] = "1700640608522135930",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1405.5610997328502,
							["y"] = 221.0789923255853
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300005,
							["MessageNote"] = "点击“替换”，进行近战武器的替换。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew.Btn_Confirm_1",
							["UICompName"] = "Button_Area",
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
					["170169246299820208"] = {
						["key"] = "170169246299820208",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1412.4520618909373,
							["y"] = 450.02089681268916
						},
						["propsData"] = {
							["MessageId"] = 301002,
							["MessageNote"] = "在近战武器配置界面中，可以查看近战武器的属性、为近战武器升级、替换其他近战武器等。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["170169246993020714"] = {
						["key"] = "170169246993020714",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1683.8156982545734,
							["y"] = 456.839078630871
						},
						["propsData"] = {
							["MessageId"] = 301003,
							["MessageNote"] = "在近战武器配置界面中，可以查看近战武器的属性、为近战武器升级、替换其他近战武器等。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1704175978670173502"] = {
						["key"] = "1704175978670173502",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 314.97442557442537,
							["y"] = 477.64115884115887
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978670173503"] = {
						["key"] = "1704175978670173503",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2462.0823798627002,
							["y"] = 465.09643674403407
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978670173504"] = {
						["key"] = "1704175978670173504",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1704175978670173505"] = {
						["key"] = "1704175978670173505",
						["type"] = "ShowGuideButtonNode",
						["name"] = "物品列表",
						["pos"] = {
							["x"] = 1110.711544545003,
							["y"] = 215.9188387346441
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300006,
							["MessageNote"] = "点击刚才获得的新武器。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew.TileView_Select_Role:2",
							["UICompName"] = "Bg01",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["1704175978670173506"] = {
						["key"] = "1704175978670173506",
						["type"] = "ShowGuideButtonNode",
						["name"] = "动态界面按钮",
						["pos"] = {
							["x"] = 1676.907814541873,
							["y"] = 232.13800936910718
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300009,
							["MessageNote"] = "点击“+”号，打开升级弹窗。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMainNew.SubUI_Panel:2.Btn_Lvup",
							["UICompName"] = "Button_Area",
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
					["1704175978670173507"] = {
						["key"] = "1704175978670173507",
						["type"] = "ShowGuideButtonNode",
						["name"] = "界面内弹窗",
						["pos"] = {
							["x"] = 1953.8231405951296,
							["y"] = 229.650017600756
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300010,
							["MessageNote"] = "点击“+”号，可以提升升级的目标等级",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "CommonDialog.VB_Node:1.Btn_Add",
							["UICompName"] = "Button_Area",
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
							["MessageLoc"] = "Right",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["170591852470819666"] = {
						["key"] = "170591852470819666",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1060.5288574509077,
							["y"] = 442.3555826752329
						},
						["propsData"] = {
							["MessageId"] = 301001,
							["MessageNote"] = "在近战武器配置界面中，可以查看近战武器的属性、为近战武器升级、替换其他近战武器等。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1719410379523415231"] = {
						["key"] = "1719410379523415231",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1982.4381713364494,
							["y"] = 454.5985323085398
						},
						["propsData"] = {
							["MessageId"] = 301004,
							["MessageNote"] = "在近战武器配置界面中，可以查看近战武器的属性、为近战武器升级、替换其他近战武器等。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17581025082001239036"] = {
						["key"] = "17581025082001239036",
						["type"] = "MSDKUploadNode",
						["name"] = "海外市场SDK埋点上报",
						["pos"] = {
							["x"] = 634,
							["y"] = 442
						},
						["propsData"] = {
							["EventName"] = "Impression_active"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}