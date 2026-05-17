return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1701326022210115412",
			["startPort"] = "StoryStart",
			["endStory"] = "1701326022805115472",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1701326022805115472",
			["startPort"] = "Success",
			["endStory"] = "1701326022210115415",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1701326022210115412"] = {
			["isStoryNode"] = true,
			["key"] = "1701326022210115412",
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
		["1701326022210115415"] = {
			["isStoryNode"] = true,
			["key"] = "1701326022210115415",
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
		["1701326022805115472"] = {
			["isStoryNode"] = true,
			["key"] = "1701326022805115472",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1216.599198255417,
				["y"] = 298.7817792947994
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
						["startQuest"] = "170556363715695277",
						["startPort"] = "Out",
						["endQuest"] = "170556367605395955",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170556367605395955",
						["startPort"] = "Out",
						["endQuest"] = "170556369582996239",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170556369582996239",
						["startPort"] = "Out",
						["endQuest"] = "170556371570296903",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170556371570296903",
						["startPort"] = "Out",
						["endQuest"] = "170556373703597392",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170556373703597392",
						["startPort"] = "Out",
						["endQuest"] = "1701326201315116238",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1701328391212123872",
						["startPort"] = "Out",
						["endQuest"] = "170556377059098262",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170556377059098262",
						["startPort"] = "Out",
						["endQuest"] = "1704175978684174220",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17516097601673148054",
						["startPort"] = "Out",
						["endQuest"] = "17516097732323148174",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1701326201315116238",
						["startPort"] = "Out",
						["endQuest"] = "1701328336305123060",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1701326737530121630",
						["startPort"] = "Out",
						["endQuest"] = "1701328391212123872",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978684174219",
						["startPort"] = "QuestStart",
						["endQuest"] = "170556363715695277",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1701328336305123060",
						["startPort"] = "Out",
						["endQuest"] = "175715933668013946853",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175715933668013946853",
						["startPort"] = "Out",
						["endQuest"] = "1701326737530121630",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1701326201315116238"] = {
						["key"] = "1701326201315116238",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 68.39648626152845,
							["y"] = 524.7442503701857
						},
						["propsData"] = {
							["MessageId"] = 300901,
							["MessageNote"] = "<H>移转模块</>可以对角色先天的槽位趋向进行调整。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1701326737530121630"] = {
						["key"] = "1701326737530121630",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 1038.357311008744,
							["y"] = 561.1449663425702
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300904,
							["MessageNote"] = "点击魔之楔插槽。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMod.Mod_1",
							["UICompName"] = "ItemDetails_MenuAnchor",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = true,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["UICompSizeOffset"] = {
								["X"] = 80,
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
					["1701328336305123060"] = {
						["key"] = "1701328336305123060",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 357.9941489838408,
							["y"] = 545.0529577083349
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300905,
							["MessageNote"] = "点击“调整槽位极性”。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMod.Btn_EditPolarity",
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
					["1701328391212123872"] = {
						["key"] = "1701328391212123872",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1420.6999020901023,
							["y"] = 539.7117124051672
						},
						["propsData"] = {
							["MessageId"] = 300906,
							["MessageNote"] = "通过消耗移转模块，可以给该插槽增加、修改或删除趋向。部分魔之楔有趋向，当魔之楔的趋向和插槽趋向相同时，可降低装配所需的耐受值。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1704175978684174219"] = {
						["key"] = "1704175978684174219",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -229.4865424430642,
							["y"] = 343.3074534161491
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978684174220"] = {
						["key"] = "1704175978684174220",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2039.4088482074749,
							["y"] = 522.2402745995424
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978684174221"] = {
						["key"] = "1704175978684174221",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1704175978684174222"] = {
						["key"] = "1704175978684174222",
						["type"] = "ShowGuideButtonNode",
						["name"] = "物品列表",
						["pos"] = {
							["x"] = 264.9071967189161,
							["y"] = -166.77681343926892
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300006,
							["MessageNote"] = "点击刚才获得的新武器。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["1704175978684174223"] = {
						["key"] = "1704175978684174223",
						["type"] = "ShowGuideButtonNode",
						["name"] = "动态界面按钮",
						["pos"] = {
							["x"] = 832.407814541873,
							["y"] = -151.86199063089282
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300009,
							["MessageNote"] = "点击“+”号，打开升级弹窗。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["1704175978684174224"] = {
						["key"] = "1704175978684174224",
						["type"] = "ShowGuideButtonNode",
						["name"] = "界面内弹窗",
						["pos"] = {
							["x"] = 1109.3231405951296,
							["y"] = -153.04563457315703
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300010,
							["MessageNote"] = "点击“+”号，可以提升升级的目标等级",
							["DelayTime"] = 0,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["1704175978684174225"] = {
						["key"] = "1704175978684174225",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 245.0000917752909,
							["y"] = -334.7424046682251
						},
						["propsData"] = {
							["MessageId"] = 300004,
							["MessageNote"] = "在近战武器配置界面中，可以查看近战武器的属性、为近战武器升级、替换其他近战武器等。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1704175978684174226"] = {
						["key"] = "1704175978684174226",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 519.3590661342653,
							["y"] = -334.6141995400199
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300002,
							["MessageNote"] = "点击<H>“整备”</>进入整备系统。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["1704175978684174227"] = {
						["key"] = "1704175978684174227",
						["type"] = "ShowGuideButtonNode",
						["name"] = "UI内ListView",
						["pos"] = {
							["x"] = 822.9488097240089,
							["y"] = -322.17830210412285
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300003,
							["MessageNote"] = "点击“近战武器”页签，进行近战武器配置。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["1704175978684174228"] = {
						["key"] = "1704175978684174228",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 561.0610997328502,
							["y"] = -162.9210076744147
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300005,
							["MessageNote"] = "点击“替换”，进行近战武器的替换。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = true,
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
					["170556363715695277"] = {
						["key"] = "170556363715695277",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 57.79087895581759,
							["y"] = 348.1881177124343
						},
						["propsData"] = {
							["MessageId"] = 300907,
							["MessageNote"] = "你会不会为耐受值有限，无法装配更多魔之楔而烦恼呀？那就留意一下<H>趋向</>吧！",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["170556367605395955"] = {
						["key"] = "170556367605395955",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 319.31503354518964,
							["y"] = 342.51420466895627
						},
						["propsData"] = {
							["MessageId"] = 300909,
							["MessageNote"] = "为了更高效地发挥魔之楔的效果，部分<H>魔之楔</>在研制时被赋予了适配于不同个体的<H>趋向</>。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["170556369582996239"] = {
						["key"] = "170556369582996239",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 620.4894032930888,
							["y"] = 351.60243996307395
						},
						["propsData"] = {
							["MessageId"] = 300908,
							["MessageNote"] = "每个角色和每把武器先天特性不尽相同，从而其<H>魔之楔槽位</>呈现出不同的<H>趋向</>。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["170556371570296903"] = {
						["key"] = "170556371570296903",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 894.7856217804836,
							["y"] = 351.25878671229987
						},
						["propsData"] = {
							["GuideId"] = 12
						}
					},
					["170556373703597392"] = {
						["key"] = "170556373703597392",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1209.8642441385177,
							["y"] = 358.1702148991353
						},
						["propsData"] = {
							["MessageId"] = 300910,
							["MessageNote"] = "如果你得到了强大的魔之楔，却为<H>趋向不合</>而头痛，要不要试一下<H>调整槽位趋向</>呢？",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["170556377059098262"] = {
						["key"] = "170556377059098262",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1731.563203074319,
							["y"] = 537.2096885833457
						},
						["propsData"] = {
							["MessageId"] = 300911,
							["MessageNote"] = "当角色槽位与魔之楔<H>趋向一致</>时，可<H>降低</>该装配该魔之楔所需的<H>耐受值</>。",
							["IsTimePause"] = false,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["17516097601673148054"] = {
						["key"] = "17516097601673148054",
						["type"] = "ShowGuideButtonNode",
						["name"] = "区域右上角UI",
						["pos"] = {
							["x"] = 54.24279864143239,
							["y"] = 142.1619746687062
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300302,
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
							["MessageLoc"] = "Left",
							["MessageLocOffset"] = {
								["X"] = 0,
								["Y"] = 0
							}
						}
					},
					["17516097732323148174"] = {
						["key"] = "17516097732323148174",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 350.396638036167,
							["y"] = 126.77735963521339
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300702,
							["MessageNote"] = "点击“魔之楔”，进行魔之楔配置。",
							["DelayTime"] = 0,
							["IsForceClick"] = true,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMain.Panel_SubUI:1",
							["UICompName"] = "Btn_Mod",
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
					["17571588271119510867"] = {
						["key"] = "17571588271119510867",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 610,
							["y"] = 988
						},
						["propsData"] = {
							["WaitTime"] = 0.1
						}
					},
					["175715933668013946853"] = {
						["key"] = "175715933668013946853",
						["type"] = "ShowGuideButtonNode",
						["name"] = "普通按钮",
						["pos"] = {
							["x"] = 678.0000000000001,
							["y"] = 576
						},
						["propsData"] = {
							["ShowEnable"] = true,
							["MessageId"] = 300904,
							["MessageNote"] = "点击魔之楔插槽。",
							["DelayTime"] = 0.1,
							["IsForceClick"] = false,
							["IsControlPlayer"] = false,
							["IsTimePause"] = false,
							["IsShowCursor"] = true,
							["HighLightUIPath"] = "ArmoryMod.Mod_1",
							["UICompName"] = "ItemDetails_MenuAnchor",
							["GamePadWidgetName"] = "",
							["IsAutoClick"] = false,
							["IsAutoClickByGamepad"] = false,
							["IsFindByMainUI"] = false,
							["UIShape"] = "Square",
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = true,
							["UICompSizeOffset"] = {
								["X"] = 80,
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}