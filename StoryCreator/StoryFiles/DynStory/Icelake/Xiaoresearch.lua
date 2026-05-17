return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17260248431146350",
			["startPort"] = "StoryStart",
			["endStory"] = "17260248559866628",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17260248559866628",
			["startPort"] = "Success",
			["endStory"] = "17260248431146353",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17260248431146350"] = {
			["isStoryNode"] = true,
			["key"] = "17260248431146350",
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
		["17260248431146353"] = {
			["isStoryNode"] = true,
			["key"] = "17260248431146353",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1452.1634615384614,
				["y"] = 282.1153846153846
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17260248559866628"] = {
			["isStoryNode"] = true,
			["key"] = "17260248559866628",
			["type"] = "StoryNode",
			["name"] = "西奥的研究",
			["pos"] = {
				["x"] = 1110.7667107631348,
				["y"] = 278.70288887518876
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_IcelakeXiaoresearch_Des",
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
				["bIsDynamicEvent"] = true,
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
						["startQuest"] = "17260248559866629",
						["startPort"] = "QuestStart",
						["endQuest"] = "17260249605948134",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17260248559866629",
						["startPort"] = "QuestStart",
						["endQuest"] = "17260250030748785",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17260249605948134",
						["startPort"] = "Out",
						["endQuest"] = "17260251272839457",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172602534410711876",
						["startPort"] = "Out",
						["endQuest"] = "172602537196412349",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172602553072513493",
						["startPort"] = "Out",
						["endQuest"] = "172603658450822505",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172602537196412349",
						["startPort"] = "Out",
						["endQuest"] = "172603732465624312",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172603732465624312",
						["startPort"] = "Out",
						["endQuest"] = "17260248559866632",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "172603658450822505",
						["startPort"] = "Out",
						["endQuest"] = "172602534410711876",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17260251272839457",
						["startPort"] = "Option_1",
						["endQuest"] = "172602553072513493",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17260251272839457",
						["startPort"] = "Option_2",
						["endQuest"] = "17268133369501800",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17260251272839457",
						["startPort"] = "Option_1",
						["endQuest"] = "176189265598012250236",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172602534410711876",
						["startPort"] = "Out",
						["endQuest"] = "176189268495612250822",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17260248559866629"] = {
						["key"] = "17260248559866629",
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
					["17260248559866632"] = {
						["key"] = "17260248559866632",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3115,
							["y"] = 302.3076923076923
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17260248559866635"] = {
						["key"] = "17260248559866635",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17260249605948134"] = {
						["key"] = "17260249605948134",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成西奥",
						["pos"] = {
							["x"] = 1089.5052418280288,
							["y"] = 299.5042627395619
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240104
							}
						}
					},
					["17260250030748785"] = {
						["key"] = "17260250030748785",
						["type"] = "TalkNode",
						["name"] = "西奥开车",
						["pos"] = {
							["x"] = 1106.5052418280288,
							["y"] = 75.50426273956191
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71000801,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17260251272839457"] = {
						["key"] = "17260251272839457",
						["type"] = "TalkNode",
						["name"] = "与西奥对话",
						["pos"] = {
							["x"] = 1416.5052418280288,
							["y"] = 267.5042627395619
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 800011,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dynquest_1240104",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71000802,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
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
							["TalkActors"] = {},
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"",
								""
							},
							["OverrideFailBlend"] = false
						}
					},
					["172602534410711876"] = {
						["key"] = "172602534410711876",
						["type"] = "TalkNode",
						["name"] = "拾取完成开车对话",
						["pos"] = {
							["x"] = 2133.505241828029,
							["y"] = 287.5042627395619
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71000803,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["172602537196412349"] = {
						["key"] = "172602537196412349",
						["type"] = "TalkNode",
						["name"] = "与西奥交流完成任务",
						["pos"] = {
							["x"] = 2460.200894001942,
							["y"] = 266.5042627395619
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 800011,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dynquest_1240104",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71000804,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 2,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["172602553072513493"] = {
						["key"] = "172602553072513493",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成采集物",
						["pos"] = {
							["x"] = 1647.8129341357212,
							["y"] = 89.1965704318696
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240325
							}
						}
					},
					["172603579510518611"] = {
						["key"] = "172603579510518611",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1763.5052418280288,
							["y"] = 274.73503197033114
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1240325
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80015,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["172603658450822505"] = {
						["key"] = "172603658450822505",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待机关进入状态",
						["pos"] = {
							["x"] = 1889.5109666878768,
							["y"] = 77.19973668091293
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1240325,
							["StateId"] = 610011,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Drop_Dynquest_1240325"
						}
					},
					["172603732465624312"] = {
						["key"] = "172603732465624312",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 2786.0494282263385,
							["y"] = 249.12281360398975
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17268133369501800"] = {
						["key"] = "17268133369501800",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 2137.5944055944055,
							["y"] = 551.3086619263089
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["176189265598012250236"] = {
						["key"] = "176189265598012250236",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1663.7299356989759,
							["y"] = -71.64824958323413
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_IcelakeXiaoresearch_Target1",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["176189268495612250822"] = {
						["key"] = "176189268495612250822",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2471.507713476753,
							["y"] = 458.35175041676587
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_IcelakeXiaoresearch_Target2",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					}
				},
				["commentData"] = {
					["172603664418023583"] = {
						["key"] = "172603664418023583",
						["name"] = "暂时用了采集物的，等等待机关进入状态的指引点好再换成机关节点",
						["position"] = {
							["x"] = 2273.576900753811,
							["y"] = -191.3167468355707
						},
						["size"] = {
							["width"] = 600,
							["height"] = 400
						}
					}
				}
			}
		}
	},
	["commentData"] = {}
}