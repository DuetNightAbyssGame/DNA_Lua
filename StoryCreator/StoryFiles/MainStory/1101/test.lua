return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "16992508770280",
			["startPort"] = "StoryStart",
			["endStory"] = "1699250888564798",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1699250888564798",
			["startPort"] = "Success",
			["endStory"] = "1699260180964130592",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1699260180964130592",
			["startPort"] = "Success",
			["endStory"] = "1699260185138130935",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1699260185138130935",
			["startPort"] = "Success",
			["endStory"] = "16992508770294",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["16992508770280"] = {
			["isStoryNode"] = true,
			["key"] = "16992508770280",
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
		["16992508770294"] = {
			["isStoryNode"] = true,
			["key"] = "16992508770294",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1928.4827586206898,
				["y"] = 314.55172413793105
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1699250888564798"] = {
			["isStoryNode"] = true,
			["key"] = "1699250888564798",
			["type"] = "StoryNode",
			["name"] = "苏醒部分",
			["pos"] = {
				["x"] = 1074.242927706198,
				["y"] = 296.24489481240454
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "击败初始小boss",
				["QuestDeatil"] = "发现富尔维斯的阴谋",
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
						["startQuest"] = "1704175979359210841",
						["startPort"] = "QuestStart",
						["endQuest"] = "1704175979359210846",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210846",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210844",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210844",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210848",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210848",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210845",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210845",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210849",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210850",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210847",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210849",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210851",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210851",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210850",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210847",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210842",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1704175979359210841"] = {
						["key"] = "1704175979359210841",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 668.9473684210526,
							["y"] = 356.8421052631579
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979359210842"] = {
						["key"] = "1704175979359210842",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3117.4310285517718,
							["y"] = 279.10448134596754
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979359210843"] = {
						["key"] = "1704175979359210843",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3109.97503674516,
							["y"] = 408.6016238233731
						},
						["propsData"] = {}
					},
					["1704175979359210844"] = {
						["key"] = "1704175979359210844",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1285.4459810553496,
							["y"] = 341.5453855746226
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["1704175979359210845"] = {
						["key"] = "1704175979359210845",
						["type"] = "GoToNode",
						["name"] = "前往处决BOSS",
						["pos"] = {
							["x"] = 1752.771701312104,
							["y"] = 327.50030110927963
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 42739,
							["GuideType"] = "M",
							["GuidePointName"] = "BP_Drive01"
						}
					},
					["1704175979359210846"] = {
						["key"] = "1704175979359210846",
						["type"] = "TalkNode",
						["name"] = "苏醒",
						["pos"] = {
							["x"] = 1033.6581675757254,
							["y"] = 345.2454247595757
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Sequences/EX01/EX01_SC002/EX01_CINE02",
							["BlendOutTime"] = 1,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "BP_TargetPoint110102",
							["EndNewTargetPointName"] = "BP_TargetPoint110102",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["1704175979359210847"] = {
						["key"] = "1704175979359210847",
						["type"] = "GoToNode",
						["name"] = "前往寻找达芙涅",
						["pos"] = {
							["x"] = 2780.4656662073617,
							["y"] = 317.4802066922024
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 53150,
							["GuideType"] = "M",
							["GuidePointName"] = "BP_Drive2"
						}
					},
					["1704175979359210848"] = {
						["key"] = "1704175979359210848",
						["type"] = "TalkNode",
						["name"] = "开车节点",
						["pos"] = {
							["x"] = 1518.6602768022149,
							["y"] = 333.2735935123917
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11010202,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1704175979359210849"] = {
						["key"] = "1704175979359210849",
						["type"] = "TalkNode",
						["name"] = "处决动画",
						["pos"] = {
							["x"] = 2000.2844571063995,
							["y"] = 327.41976762495625
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Sequences/EX01/EX01_SC003/EX01_CINE03",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "BP_TargetPoint110102",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["1704175979359210850"] = {
						["key"] = "1704175979359210850",
						["type"] = "TalkNode",
						["name"] = "处决完的开车",
						["pos"] = {
							["x"] = 2459.4578870580895,
							["y"] = 324.9932885484774
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11010204,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1704175979359210851"] = {
						["key"] = "1704175979359210851",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2224.9077989815405,
							["y"] = 330.93721834215523
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					}
				},
				["commentData"] = {
					["169925236810243743"] = {
						["key"] = "169925236810243743",
						["name"] = "ex01苏醒部分",
						["position"] = {
							["x"] = 999.137769133663,
							["y"] = 180.89353938907834
						},
						["size"] = {
							["width"] = 2064.7058823529414,
							["height"] = 379.4117647058824
						}
					}
				}
			}
		},
		["1699260180964130592"] = {
			["isStoryNode"] = true,
			["key"] = "1699260180964130592",
			["type"] = "StoryNode",
			["name"] = "达芙涅部分",
			["pos"] = {
				["x"] = 1329.0563337181097,
				["y"] = 300.26780114584176
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
						["startQuest"] = "1704175979359210856",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210855",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210855",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210857",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210857",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210859",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210860",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210861",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210862",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210858",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210859",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210860",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210861",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210863",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210863",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210862",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210852",
						["startPort"] = "QuestStart",
						["endQuest"] = "1704175979359210856",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210858",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210853",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1704175979359210852"] = {
						["key"] = "1704175979359210852",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 326,
							["y"] = 368
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979359210853"] = {
						["key"] = "1704175979359210853",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1650.8872180451126,
							["y"] = 551.1428571428571
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979359210854"] = {
						["key"] = "1704175979359210854",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1704175979359210855"] = {
						["key"] = "1704175979359210855",
						["type"] = "TalkNode",
						["name"] = "达芙涅站桩",
						["pos"] = {
							["x"] = 875.1836366465322,
							["y"] = 349.0063722274424
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11010301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStage110104",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
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
							["EndNewTargetPointName"] = "BP_TargetPoint110103",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 0,
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
					["1704175979359210856"] = {
						["key"] = "1704175979359210856",
						["type"] = "TalkNode",
						["name"] = "达芙涅登场",
						["pos"] = {
							["x"] = 632.2929103125243,
							["y"] = 349.60931486008855
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Sequences/EX01/EX01_SC004/EX01_CINE04",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "BP_TargetPoint110105",
							["EndNewTargetPointName"] = "BP_TargetPoint110105",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["1704175979359210857"] = {
						["key"] = "1704175979359210857",
						["type"] = "GoToNode",
						["name"] = "途经点解密A",
						["pos"] = {
							["x"] = 1140.1824635379094,
							["y"] = 346.3897355222184
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 53656,
							["GuideType"] = "M",
							["GuidePointName"] = "BP_Drive3"
						}
					},
					["1704175979359210858"] = {
						["key"] = "1704175979359210858",
						["type"] = "TalkNode",
						["name"] = "回到达芙涅身边",
						["pos"] = {
							["x"] = 1419.714570696257,
							["y"] = 550.104986215797
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStage110105",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["InType"] = "FadeIn",
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
							["EndNewTargetPointName"] = "BP_TargetPoint110105",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
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
					["1704175979359210859"] = {
						["key"] = "1704175979359210859",
						["type"] = "TalkNode",
						["name"] = "与达芙涅开车对话",
						["pos"] = {
							["x"] = 1392.2598643042436,
							["y"] = 344.06932327163304
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11010501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1704175979359210860"] = {
						["key"] = "1704175979359210860",
						["type"] = "GoToNode",
						["name"] = "前往医疗包",
						["pos"] = {
							["x"] = 1638.9847831725883,
							["y"] = 342.4830584208653
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 73362,
							["GuideType"] = "M",
							["GuidePointName"] = "BP_Drive5"
						}
					},
					["1704175979359210861"] = {
						["key"] = "1704175979359210861",
						["type"] = "TalkNode",
						["name"] = "找到医疗包",
						["pos"] = {
							["x"] = 632.6812289015154,
							["y"] = 558.9193858011823
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11010504,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1704175979359210862"] = {
						["key"] = "1704175979359210862",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1152.320437216421,
							["y"] = 563.5931073769273
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 67992,
							["GuideType"] = "M",
							["GuidePointName"] = "BP_Drive6"
						}
					},
					["1704175979359210863"] = {
						["key"] = "1704175979359210863",
						["type"] = "TalkNode",
						["name"] = "Npc开车",
						["pos"] = {
							["x"] = 882.6945875543761,
							["y"] = 562.0416619667627
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11010505,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1699260185138130935"] = {
			["isStoryNode"] = true,
			["key"] = "1699260185138130935",
			["type"] = "StoryNode",
			["name"] = "阿瓦尔部分",
			["pos"] = {
				["x"] = 1588.0494743390395,
				["y"] = 299.15240313389216
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
						["startQuest"] = "1704175979359210868",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210869",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210869",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210870",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210870",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210867",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210867",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210871",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210871",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210872",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210872",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210875",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210875",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210873",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210873",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210876",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210876",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210874",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210874",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210877",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210864",
						["startPort"] = "QuestStart",
						["endQuest"] = "1704175979359210868",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175979359210877",
						["startPort"] = "Out",
						["endQuest"] = "1704175979359210865",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1704175979359210864"] = {
						["key"] = "1704175979359210864",
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
					["1704175979359210865"] = {
						["key"] = "1704175979359210865",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2524.5714285714284,
							["y"] = 430.8571428571429
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175979359210866"] = {
						["key"] = "1704175979359210866",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2826,
							["y"] = 862
						},
						["propsData"] = {}
					},
					["1704175979359210867"] = {
						["key"] = "1704175979359210867",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1821.1480792655673,
							["y"] = 278.77979008735656
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					},
					["1704175979359210868"] = {
						["key"] = "1704175979359210868",
						["type"] = "TalkNode",
						["name"] = "看到怪物",
						["pos"] = {
							["x"] = 1046.960656905318,
							["y"] = 300.0079076219956
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["1704175979359210869"] = {
						["key"] = "1704175979359210869",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待（打怪）",
						["pos"] = {
							["x"] = 1299.8363138570614,
							["y"] = 301.9947924762721
						},
						["propsData"] = {
							["WaitTime"] = 20
						}
					},
					["1704175979359210870"] = {
						["key"] = "1704175979359210870",
						["type"] = "TalkNode",
						["name"] = "阿瓦尔登场",
						["pos"] = {
							["x"] = 1553.5327424284899,
							["y"] = 288.6027117309309
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
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
					["1704175979359210871"] = {
						["key"] = "1704175979359210871",
						["type"] = "TalkNode",
						["name"] = "阿瓦尔开车提醒主角",
						["pos"] = {
							["x"] = 2069.6264877754384,
							["y"] = 281.69225548237387
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
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
					["1704175979359210872"] = {
						["key"] = "1704175979359210872",
						["type"] = "TalkNode",
						["name"] = "汇合后站桩对话",
						["pos"] = {
							["x"] = 2337.5616069212656,
							["y"] = 278.94352979395353
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
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
					["1704175979359210873"] = {
						["key"] = "1704175979359210873",
						["type"] = "TalkNode",
						["name"] = "阿瓦尔走路开车",
						["pos"] = {
							["x"] = 1357.5018362256153,
							["y"] = 452.83460245652833
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
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
					["1704175979359210874"] = {
						["key"] = "1704175979359210874",
						["type"] = "TalkNode",
						["name"] = "阿瓦尔走路开车",
						["pos"] = {
							["x"] = 1969.7548006524928,
							["y"] = 448.3399666575445
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
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
					["1704175979359210875"] = {
						["key"] = "1704175979359210875",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1071.1458698740232,
							["y"] = 466.8670877618625
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					},
					["1704175979359210876"] = {
						["key"] = "1704175979359210876",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1648.6417835713098,
							["y"] = 458.3024498825792
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					},
					["1704175979359210877"] = {
						["key"] = "1704175979359210877",
						["type"] = "GoToNode",
						["name"] = "前往瞭望台",
						["pos"] = {
							["x"] = 2248.64178357131,
							["y"] = 437.8479044280339
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 0,
							["GuideType"] = "N",
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}