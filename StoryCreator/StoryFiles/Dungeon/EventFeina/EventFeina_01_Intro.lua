return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1754637038935298778",
			["startPort"] = "StoryStart",
			["endStory"] = "1754637109257299010",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1754637109257299010",
			["startPort"] = "Success",
			["endStory"] = "1754637038935298781",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1754637038935298778"] = {
			["isStoryNode"] = true,
			["key"] = "1754637038935298778",
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
		["1754637038935298781"] = {
			["isStoryNode"] = true,
			["key"] = "1754637038935298781",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1521.6,
				["y"] = 280.4
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1754637109257299010"] = {
			["isStoryNode"] = true,
			["key"] = "1754637109257299010",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1130.8041958041958,
				["y"] = 287.5827505827507
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
						["startQuest"] = "1754637109257299011",
						["startPort"] = "QuestStart",
						["endQuest"] = "1754637134437299565",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175729891414533598585",
						["startPort"] = "Out",
						["endQuest"] = "1754637109257299014",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1754637134437299565",
						["startPort"] = "Out",
						["endQuest"] = "175729892419333598783",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175729892419333598783",
						["startPort"] = "Out",
						["endQuest"] = "175729891414533598586",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175729891414533598586",
						["startPort"] = "Out",
						["endQuest"] = "176061703180721472",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176061703180721472",
						["startPort"] = "Out",
						["endQuest"] = "175729891414533598585",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1754637109257299011"] = {
						["key"] = "1754637109257299011",
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
					["1754637109257299014"] = {
						["key"] = "1754637109257299014",
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
					["1754637109257299017"] = {
						["key"] = "1754637109257299017",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1754637134437299565"] = {
						["key"] = "1754637134437299565",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1192.3684210526317,
							["y"] = 291.13157894736844
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Level/Sequencer/Special/Event/Feina/Feina_01/LS_Feina_01_00",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = true,
							["StartFadeOutTime"] = 0.5,
							["StartScreenEffectDuration"] = 1,
							["FinishFadeInTime"] = 0,
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
					["175729891414533598585"] = {
						["key"] = "175729891414533598585",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2441.5789473684213,
							["y"] = 273
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80001005,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["175729891414533598586"] = {
						["key"] = "175729891414533598586",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1780.5263157894738,
							["y"] = 290.2631578947368
						},
						["propsData"] = {
							["GuideId"] = 2001
						}
					},
					["175729892419333598783"] = {
						["key"] = "175729892419333598783",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1508.0000000000002,
							["y"] = 284.421052631579
						},
						["propsData"] = {
							["WaitTime"] = 5
						}
					},
					["176061703180721472"] = {
						["key"] = "176061703180721472",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2106.3157894736846,
							["y"] = 274.42105263157885
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80001003,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}