return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17544679066532579015",
			["startPort"] = "StoryStart",
			["endStory"] = "17544679066532579017",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17544679066532579017",
			["startPort"] = "Success",
			["endStory"] = "17544679066532579016",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17544679066532579015"] = {
			["isStoryNode"] = true,
			["key"] = "17544679066532579015",
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
		["17544679066532579016"] = {
			["isStoryNode"] = true,
			["key"] = "17544679066532579016",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1802,
				["y"] = 354
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17544679066532579017"] = {
			["isStoryNode"] = true,
			["key"] = "17544679066532579017",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1308,
				["y"] = 322
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120114_5",
				["QuestDeatil"] = "Content_120114_5",
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
						["startQuest"] = "17544679066532579018",
						["startPort"] = "QuestStart",
						["endQuest"] = "17544679066532579028",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17545584868181341370",
						["startPort"] = "Out",
						["endQuest"] = "17545584868181341371",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17545584868181341371",
						["startPort"] = "Out",
						["endQuest"] = "17546346914432430478",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17545584868181341371",
						["startPort"] = "Out",
						["endQuest"] = "17546201238321832",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17544679066532579018",
						["startPort"] = "QuestStart",
						["endQuest"] = "17545584868181341370",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175758168967139004759",
						["startPort"] = "Out",
						["endQuest"] = "175758168967139004760",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175758168967139004757",
						["startPort"] = "Out",
						["endQuest"] = "175758168967139004761",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17544679066532579018",
						["startPort"] = "QuestStart",
						["endQuest"] = "175758168967139004758",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17544679066532579018",
						["startPort"] = "QuestStart",
						["endQuest"] = "175758168967139004757",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17544679066532579018",
						["startPort"] = "QuestStart",
						["endQuest"] = "175758168967139004759",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175758171979339005757",
						["startPort"] = "Out",
						["endQuest"] = "175758171979339005758",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175758171979339005759",
						["startPort"] = "Out",
						["endQuest"] = "175758171979339005760",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175758171979339005758",
						["startPort"] = "Out",
						["endQuest"] = "175758171979339005761",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175758171979339005761",
						["startPort"] = "Out",
						["endQuest"] = "175758171979339005759",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17544679066532579028",
						["startPort"] = "Out",
						["endQuest"] = "175758171979339005757",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175758171979339005760",
						["startPort"] = "Out",
						["endQuest"] = "17544679066532579020",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "175758173578539006304",
						["startPort"] = "Out",
						["endQuest"] = "175758173578539006305",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175758173578539006306",
						["startPort"] = "Out",
						["endQuest"] = "175758173578539006302",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "175758173578539006303",
						["startPort"] = "Out",
						["endQuest"] = "175758173578539006302",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "175758173578539006305",
						["startPort"] = "Out",
						["endQuest"] = "175758173578539006302",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "175758173578539006302",
						["startPort"] = "Out",
						["endQuest"] = "175448420318815358276",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17546201238321832",
						["startPort"] = "Out",
						["endQuest"] = "175758173578539006304",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17546201238321832",
						["startPort"] = "Out",
						["endQuest"] = "175758173578539006306",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17546201238321832",
						["startPort"] = "Out",
						["endQuest"] = "175758173578539006303",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17544679066532579018"] = {
						["key"] = "17544679066532579018",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 852,
							["y"] = 244
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17544679066532579019"] = {
						["key"] = "17544679066532579019",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2502.307486631016,
							["y"] = 675.5668449197863
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17544679066532579020"] = {
						["key"] = "17544679066532579020",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2373.3712121212125,
							["y"] = 1168.806277056277
						},
						["propsData"] = {}
					},
					["17544679066532579028"] = {
						["key"] = "17544679066532579028",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1377.6799845536298,
							["y"] = 460.2884573392704
						},
						["propsData"] = {}
					},
					["175448420318815358276"] = {
						["key"] = "175448420318815358276",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 3439.6955691367457,
							["y"] = 279.11688311688295
						},
						["propsData"] = {}
					},
					["17545584868181341370"] = {
						["key"] = "17545584868181341370",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1380.7656819533622,
							["y"] = 239.2969823137966
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191669
							}
						}
					},
					["17545584868181341371"] = {
						["key"] = "17545584868181341371",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1687.0024147590063,
							["y"] = 239.04630236849732
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 211014,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Mark_Feina04_1191669",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 12033401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Feina_FixSimple33",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 211012,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 211013,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 211001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 211011,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 211010,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 211014,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17546201238321832"] = {
						["key"] = "17546201238321832",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2045.0425730100653,
							["y"] = 238.59874954766605
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191878,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_SQTrigger_BackCity_1191878"
						}
					},
					["17546346914432430478"] = {
						["key"] = "17546346914432430478",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2043.2974917239626,
							["y"] = 110.15211491295075
						},
						["propsData"] = {
							["NewDescription"] = "Description_120114_6",
							["NewDetail"] = "Content_120114_6",
							["SubTaskTargetIndex"] = 0
						}
					},
					["175758168967139004757"] = {
						["key"] = "175758168967139004757",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1398.2374980761372,
							["y"] = -310.67875375365844
						},
						["propsData"] = {
							["QuestRoleId"] = 10301002,
							["IsPlayFX"] = false
						}
					},
					["175758168967139004758"] = {
						["key"] = "175758168967139004758",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效运动能力/小技能/攻击",
						["pos"] = {
							["x"] = 1415.00587698288,
							["y"] = -148.33757626257216
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = false,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Skill1",
								"Fire",
								"Skill2",
								"Skill3"
							}
						}
					},
					["175758168967139004759"] = {
						["key"] = "175758168967139004759",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1392.069770464337,
							["y"] = -466.5715146465187
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = true
						}
					},
					["175758168967139004760"] = {
						["key"] = "175758168967139004760",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1669.5658214053624,
							["y"] = -473.3582933182038
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "BloodBar",
							["ActionParam"] = "None",
							["ShowOrHide"] = true
						}
					},
					["175758168967139004761"] = {
						["key"] = "175758168967139004761",
						["type"] = "CameraControlNode",
						["name"] = "镜头控制节点",
						["pos"] = {
							["x"] = 1692.9302295356633,
							["y"] = -319.5589721794569
						},
						["propsData"] = {
							["Duration"] = 4,
							["CameraName"] = "StoryEast01Nai01",
							["LockRotate"] = false,
							["FocalLength"] = 0,
							["LensAperture"] = 0,
							["FOV"] = 80,
							["PPMaterialPath"] = ""
						}
					},
					["175758171979339005757"] = {
						["key"] = "175758171979339005757",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1695.5995592294146,
							["y"] = 642.2637752509867
						},
						["propsData"] = {}
					},
					["175758171979339005758"] = {
						["key"] = "175758171979339005758",
						["type"] = "CameraControlClearNode",
						["name"] = "镜头恢复",
						["pos"] = {
							["x"] = 1933.9057156632803,
							["y"] = 691.2297144974988
						},
						["propsData"] = {
							["Duration"] = 3
						}
					},
					["175758171979339005759"] = {
						["key"] = "175758171979339005759",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1695.6903085032493,
							["y"] = 932.2492307537375
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["175758171979339005760"] = {
						["key"] = "175758171979339005760",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1940.265554758764,
							["y"] = 1004.7891645852353
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "BloodBar",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["175758171979339005761"] = {
						["key"] = "175758171979339005761",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效运动能力/小技能/攻击",
						["pos"] = {
							["x"] = 1825.599223660756,
							["y"] = 800.3598032514442
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Skill1",
								"Fire",
								"Skill2",
								"Skill3"
							}
						}
					},
					["175758173578539006302"] = {
						["key"] = "175758173578539006302",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 3086.570220879985,
							["y"] = 246.50677341326298
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["175758173578539006303"] = {
						["key"] = "175758173578539006303",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效运动能力/小技能/攻击",
						["pos"] = {
							["x"] = 2604.3929320016414,
							["y"] = 425.40986128490226
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Skill1",
								"Fire",
								"Skill2",
								"Skill3"
							}
						}
					},
					["175758173578539006304"] = {
						["key"] = "175758173578539006304",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 2496.6282264415267,
							["y"] = 112.29484230186486
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["175758173578539006305"] = {
						["key"] = "175758173578539006305",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 2776.6393725814705,
							["y"] = 109.64307855131969
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "BloodBar",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["175758173578539006306"] = {
						["key"] = "175758173578539006306",
						["type"] = "CameraControlClearNode",
						["name"] = "镜头恢复",
						["pos"] = {
							["x"] = 2603.406390476083,
							["y"] = 267.51455019698557
						},
						["propsData"] = {
							["Duration"] = 3
						}
					}
				},
				["commentData"] = {
					["175758170234439005220"] = {
						["key"] = "175758170234439005220",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1352.1749812365135,
							["y"] = -547.0727554179565
						},
						["size"] = {
							["width"] = 574.090909090909,
							["height"] = 571.3636363636364
						}
					},
					["175758172383839005922"] = {
						["key"] = "175758172383839005922",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1651.2658903274225,
							["y"] = 560.1931365847777
						},
						["size"] = {
							["width"] = 533.3333333333334,
							["height"] = 594.9999999999999
						}
					},
					["175758174818439006775"] = {
						["key"] = "175758174818439006775",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 2413.599223660756,
							["y"] = 11.526469918110934
						},
						["size"] = {
							["width"] = 938,
							["height"] = 578
						}
					}
				}
			}
		}
	},
	["commentData"] = {}
}