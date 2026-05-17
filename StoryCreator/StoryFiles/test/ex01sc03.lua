return {
	["storyName"] = "未命名故事",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "171851537066911664718",
			["startPort"] = "StoryStart",
			["endStory"] = "171851537066911664720",
			["endPort"] = "In"
		},
		{
			["startStory"] = "171851537066911664720",
			["startPort"] = "Success",
			["endStory"] = "171851537066911664719",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["171851537066911664718"] = {
			["isStoryNode"] = true,
			["key"] = "171851537066911664718",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 100,
				["y"] = 140
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
		["171851537066911664719"] = {
			["isStoryNode"] = true,
			["key"] = "171851537066911664719",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 400,
				["y"] = 140
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["171851537066911664720"] = {
			["isStoryNode"] = true,
			["key"] = "171851537066911664720",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 300,
				["y"] = 140
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
						["startQuest"] = "171851537066911664724",
						["startPort"] = "QuestStart",
						["endQuest"] = "17223397987164266",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17223397987164266",
						["startPort"] = "Out",
						["endQuest"] = "171851537066911664725",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["171851537066911664724"] = {
						["key"] = "171851537066911664724",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 136.66666666666669,
							["y"] = 455.00000000000006
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537066911664725"] = {
						["key"] = "171851537066911664725",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 831.3333333333333,
							["y"] = 459.33333333333337
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851537066911664726"] = {
						["key"] = "171851537066911664726",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["17223397987164266"] = {
						["key"] = "17223397987164266",
						["type"] = "TalkNode",
						["name"] = "过场-SC003-秽兽包围",
						["pos"] = {
							["x"] = 448,
							["y"] = 452
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC003/SQ_OBT0102_SC003",
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
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "BP_TargetPoint110104",
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}