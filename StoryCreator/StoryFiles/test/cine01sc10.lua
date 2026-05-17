return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "171851537061511663602",
			["startPort"] = "StoryStart",
			["endStory"] = "171851537061511663604",
			["endPort"] = "In"
		},
		{
			["startStory"] = "171851537061511663604",
			["startPort"] = "Success",
			["endStory"] = "171851537061511663603",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["171851537061511663602"] = {
			["isStoryNode"] = true,
			["key"] = "171851537061511663602",
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
		["171851537061511663603"] = {
			["isStoryNode"] = true,
			["key"] = "171851537061511663603",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1267.6900584795326,
				["y"] = 316.53508771929825
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["171851537061511663604"] = {
			["isStoryNode"] = true,
			["key"] = "171851537061511663604",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1028.970337028758,
				["y"] = 308.3616499713401
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
						["startQuest"] = "171851537061511663605",
						["startPort"] = "QuestStart",
						["endQuest"] = "17223535957439979",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17223535957439979",
						["startPort"] = "Out",
						["endQuest"] = "172235361994110391",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172235361994110391",
						["startPort"] = "Out",
						["endQuest"] = "172232635498429297",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172232635498429297",
						["startPort"] = "Out",
						["endQuest"] = "17337365955391304344",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17337365955391304344",
						["startPort"] = "Out",
						["endQuest"] = "171851537061511663606",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["171851537061511663605"] = {
						["key"] = "171851537061511663605",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 407.9310344827586,
							["y"] = 310.34482758620686
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537061511663606"] = {
						["key"] = "171851537061511663606",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1588.5472937642019,
							["y"] = 301.4944430183584
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537061511663607"] = {
						["key"] = "171851537061511663607",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1373.8461538461543,
							["y"] = 499.2307692307693
						},
						["propsData"] = {}
					},
					["172232635498429297"] = {
						["key"] = "172232635498429297",
						["type"] = "TalkNode",
						["name"] = "过场动画 布鲁斯袭击主角",
						["pos"] = {
							["x"] = 1126.3418549441005,
							["y"] = 301.46199379514456
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC010/SQ_OBT0101_SC010",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = true,
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
					["17223535957439979"] = {
						["key"] = "17223535957439979",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = 643.4976979727961,
							["y"] = 309.4353970108176
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["172235361994110391"] = {
						["key"] = "172235361994110391",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 880.0494221107273,
							["y"] = 308.40091425219686
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17337365955391304344"] = {
						["key"] = "17337365955391304344",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,白天",
						["pos"] = {
							["x"] = 1359.7543859649122,
							["y"] = 305.33333333333337
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityMorning",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}