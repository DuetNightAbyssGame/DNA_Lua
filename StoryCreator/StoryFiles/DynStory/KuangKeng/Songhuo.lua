return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17370944931721",
			["startPort"] = "StoryStart",
			["endStory"] = "1737094929987690",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1737094929987690",
			["startPort"] = "Success",
			["endStory"] = "17370944931735",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17370944931721"] = {
			["isStoryNode"] = true,
			["key"] = "17370944931721",
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
		["17370944931735"] = {
			["isStoryNode"] = true,
			["key"] = "17370944931735",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1461.409168081494,
				["y"] = 297.35144312393885
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1737094929987690"] = {
			["isStoryNode"] = true,
			["key"] = "1737094929987690",
			["type"] = "StoryNode",
			["name"] = "送货",
			["pos"] = {
				["x"] = 1148.3999999999999,
				["y"] = 301.59999999999997
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_KuangkengSonghuo_Des",
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
						["startQuest"] = "1737094929987691",
						["startPort"] = "QuestStart",
						["endQuest"] = "173710109300612332",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173710109300612332",
						["startPort"] = "Out",
						["endQuest"] = "173710110520812569",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173710117082113635",
						["startPort"] = "Out",
						["endQuest"] = "173710118848713827",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173710118848713827",
						["startPort"] = "Out",
						["endQuest"] = "173710125150714186",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17370952743232329",
						["startPort"] = "Out",
						["endQuest"] = "1737094929987698",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17370952878622473",
						["startPort"] = "Out",
						["endQuest"] = "1737094929987698",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "173710109300612332",
						["startPort"] = "Out",
						["endQuest"] = "17370949494471445",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17371086877802206185",
						["startPort"] = "Out",
						["endQuest"] = "17371087069472206713",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173710118848713827",
						["startPort"] = "Out",
						["endQuest"] = "17371094338652208400",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173710125150714186",
						["startPort"] = "Out",
						["endQuest"] = "1737340038070737489",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1737340038070737489",
						["startPort"] = "Out",
						["endQuest"] = "173710125978814418",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173710125150714186",
						["startPort"] = "Out",
						["endQuest"] = "17371086877802206185",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173710110520812569",
						["startPort"] = "Out",
						["endQuest"] = "173710117082113635",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173710125978814418",
						["startPort"] = "Option_1",
						["endQuest"] = "17370952743232329",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173710125978814418",
						["startPort"] = "Option_2",
						["endQuest"] = "17370952878622473",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1737094929987691"] = {
						["key"] = "1737094929987691",
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
					["1737094929987698"] = {
						["key"] = "1737094929987698",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4578.357011092356,
							["y"] = 393.4873953632574
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1737094929987705"] = {
						["key"] = "1737094929987705",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3582.624403183024,
							["y"] = 960.5909814323608
						},
						["propsData"] = {}
					},
					["17370949494471445"] = {
						["key"] = "17370949494471445",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1501.6201212580522,
							["y"] = 34.69514967790831
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71006101,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17370952743232329"] = {
						["key"] = "17370952743232329",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功-功利",
						["pos"] = {
							["x"] = 4001.7435196986935,
							["y"] = 122.13989611920651
						},
						["propsData"] = {
							["DialogueId"] = 71006110,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17370952878622473"] = {
						["key"] = "17370952878622473",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功-混沌",
						["pos"] = {
							["x"] = 4002.47838495005,
							["y"] = 402.2609524741459
						},
						["propsData"] = {
							["DialogueId"] = 71006111,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["173710109300612332"] = {
						["key"] = "173710109300612332",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成外送皎皎",
						["pos"] = {
							["x"] = 1219.6884534610003,
							["y"] = 296.1707186648022
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1270167
							}
						}
					},
					["173710110520812569"] = {
						["key"] = "173710110520812569",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1536.8313106038574,
							["y"] = 245.85325834734178
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818019,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1270167",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006102,
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["173710117082113635"] = {
						["key"] = "173710117082113635",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2072.4531689387595,
							["y"] = 235.8654924900108
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1270159,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Dyn_1270159"
						}
					},
					["173710118848713827"] = {
						["key"] = "173710118848713827",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成秽兽",
						["pos"] = {
							["x"] = 2530.2792558952815,
							["y"] = 240.45486447068706
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1270161,
								1270162,
								1270163,
								1270164,
								1270165
							}
						}
					},
					["173710125150714186"] = {
						["key"] = "173710125150714186",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2819.1681447841706,
							["y"] = 226.01042002624263
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1270161,
								1270162,
								1270163,
								1270164,
								1270165
							}
						}
					},
					["173710125978814418"] = {
						["key"] = "173710125978814418",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 3485.1312238506976,
							["y"] = 195.0247007646613
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 818024,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Dyn_1270166",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 71006108,
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
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"1",
								"2"
							},
							["OverrideFailBlend"] = false
						}
					},
					["17371086877802206185"] = {
						["key"] = "17371086877802206185",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3075.6732564500176,
							["y"] = 495.92252226490046
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 1270168,
							["GuideType"] = "M",
							["GuidePointName"] = ""
						}
					},
					["17371087069472206713"] = {
						["key"] = "17371087069472206713",
						["type"] = "TalkNode",
						["name"] = "还没送到抱怨",
						["pos"] = {
							["x"] = 3391.523010144598,
							["y"] = 503.9028178314029
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71006107,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17371094338652208400"] = {
						["key"] = "17371094338652208400",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2814.8727638391783,
							["y"] = 22.129418816624487
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71006106,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1737340038070737489"] = {
						["key"] = "1737340038070737489",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成订单人NPC",
						["pos"] = {
							["x"] = 3088.0494505494503,
							["y"] = 230.0076923076922
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1270166
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