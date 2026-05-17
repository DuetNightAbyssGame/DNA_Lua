return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1738810294466253855",
			["startPort"] = "StoryStart",
			["endStory"] = "1738810298039253954",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1738810298039253954",
			["startPort"] = "Success",
			["endStory"] = "1738810294466253858",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1738810294466253855"] = {
			["isStoryNode"] = true,
			["key"] = "1738810294466253855",
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
		["1738810294466253858"] = {
			["isStoryNode"] = true,
			["key"] = "1738810294466253858",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1510,
				["y"] = 285.7894736842105
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1738810298039253954"] = {
			["isStoryNode"] = true,
			["key"] = "1738810298039253954",
			["type"] = "StoryNode",
			["name"] = "钓鱼人",
			["pos"] = {
				["x"] = 1148.7777777777778,
				["y"] = 291.88888888888886
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_IcelakeFishMonster_Des",
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
						["startQuest"] = "1738810298039253955",
						["startPort"] = "QuestStart",
						["endQuest"] = "1738810795153254704",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1738810795153254704",
						["startPort"] = "Out",
						["endQuest"] = "1738810932370255229",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1738810795153254704",
						["startPort"] = "Out",
						["endQuest"] = "1738811009911256418",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1738811061261257593",
						["startPort"] = "Out",
						["endQuest"] = "1738811075757258059",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1738811075757258059",
						["startPort"] = "Out",
						["endQuest"] = "1738810298039253958",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1738811009911256418",
						["startPort"] = "Option_2",
						["endQuest"] = "17388120551251771207",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17388120551251771207",
						["startPort"] = "Out",
						["endQuest"] = "1738810298039253958",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1738811009911256418",
						["startPort"] = "Option_1",
						["endQuest"] = "17390122111993040227",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17429711317842389",
						["startPort"] = "Out",
						["endQuest"] = "17429711317842388",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17429711317842388",
						["startPort"] = "Out",
						["endQuest"] = "17429711317842387",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17429711317842388",
						["startPort"] = "Out",
						["endQuest"] = "17429711317852390",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17390122111993040227",
						["startPort"] = "Out",
						["endQuest"] = "17429711317842389",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17429711317842387",
						["startPort"] = "Out",
						["endQuest"] = "1738811061261257593",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1738810298039253955"] = {
						["key"] = "1738810298039253955",
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
					["1738810298039253958"] = {
						["key"] = "1738810298039253958",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3435.606060606061,
							["y"] = 260.9090909090909
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1738810298039253961"] = {
						["key"] = "1738810298039253961",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3417.7777777777783,
							["y"] = 653.3333333333333
						},
						["propsData"] = {}
					},
					["1738810795153254704"] = {
						["key"] = "1738810795153254704",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成钓鱼NPC",
						["pos"] = {
							["x"] = 1163.642857142857,
							["y"] = 295.7702762340634
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240472
							}
						}
					},
					["1738810932370255229"] = {
						["key"] = "1738810932370255229",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1464.328034034931,
							["y"] = 55.56320444528221
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71006201,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1738811009911256418"] = {
						["key"] = "1738811009911256418",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1465.4676725490074,
							["y"] = 262.28734237631676
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818055,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1240472",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006202,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 1,
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
							["NormalOptions"] = {
								{
									["OptionText"] = "710062021",
									["OverrideBlend"] = true,
									["OverrideOutype"] = "BlendOut",
									["OverrideOutTime"] = -1
								},
								{
									["OptionText"] = "710062022",
									["OverrideBlend"] = true,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 2
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["1738811061261257593"] = {
						["key"] = "1738811061261257593",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2893.4840721032406,
							["y"] = 244.61631158155373
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818055,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1240472",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006205,
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
					["1738811075757258059"] = {
						["key"] = "1738811075757258059",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3135.428516547685,
							["y"] = 248.9218671371094
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17388120551251771207"] = {
						["key"] = "17388120551251771207",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 1815.6032608695652,
							["y"] = 602.3115942028986
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					},
					["17390122111993040227"] = {
						["key"] = "17390122111993040227",
						["type"] = "TalkNode",
						["name"] = "接受对话",
						["pos"] = {
							["x"] = 1720,
							["y"] = 248.25
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006203,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = -1,
							["BlendOutTime"] = 1,
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
					["17429711317842387"] = {
						["key"] = "17429711317842387",
						["type"] = "ResourceCollectNode",
						["name"] = "获得Resource道具",
						["pos"] = {
							["x"] = 2569.7760183976293,
							["y"] = 275.33812674253875
						},
						["propsData"] = {
							["ResourceType"] = "Resource",
							["ResourceId"] = -1,
							["ResourceSType"] = "Fish",
							["NeedCount"] = 1,
							["bUseBagCount"] = false,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Mechanism_Dyn_1240644"
						}
					},
					["17429711317842388"] = {
						["key"] = "17429711317842388",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2288.7472436635912,
							["y"] = 282.4779464257794
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					},
					["17429711317842389"] = {
						["key"] = "17429711317842389",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成钓鱼点",
						["pos"] = {
							["x"] = 2042.7530080746187,
							["y"] = 262.9925833969953
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240644
							}
						}
					},
					["17429711317852390"] = {
						["key"] = "17429711317852390",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "给钓鱼机关指引点",
						["pos"] = {
							["x"] = 2559.9398767614875,
							["y"] = 474.1246180290298
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 1240644,
							["StateId"] = 9020002,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_1240644"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}