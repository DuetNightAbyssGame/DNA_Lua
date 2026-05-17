return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "171851537062111663679",
			["startPort"] = "StoryStart",
			["endStory"] = "171851537062111663681",
			["endPort"] = "In"
		},
		{
			["startStory"] = "171851537062111663681",
			["startPort"] = "Success",
			["endStory"] = "171851537062111663680",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["171851537062111663679"] = {
			["isStoryNode"] = true,
			["key"] = "171851537062111663679",
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
		["171851537062111663680"] = {
			["isStoryNode"] = true,
			["key"] = "171851537062111663680",
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
		["171851537062111663681"] = {
			["isStoryNode"] = true,
			["key"] = "171851537062111663681",
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
						["startQuest"] = "171851537062111663682",
						["startPort"] = "QuestStart",
						["endQuest"] = "172232642636030191",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172232642636030191",
						["startPort"] = "Out",
						["endQuest"] = "171851537062111663683",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["171851537062111663682"] = {
						["key"] = "171851537062111663682",
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
					["171851537062111663683"] = {
						["key"] = "171851537062111663683",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1328.585607940447,
							["y"] = 305.2109181141439
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537062111663684"] = {
						["key"] = "171851537062111663684",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1373.8461538461543,
							["y"] = 499.2307692307693
						},
						["propsData"] = {}
					},
					["172232642636030191"] = {
						["key"] = "172232642636030191",
						["type"] = "TalkNode",
						["name"] = "过场动画 飞向太阳",
						["pos"] = {
							["x"] = 1071.3861899194699,
							["y"] = 349.146722859184
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC011/SQ_OBT0101_SC011",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
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