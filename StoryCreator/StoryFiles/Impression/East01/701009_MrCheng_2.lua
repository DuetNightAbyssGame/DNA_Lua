return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17626068980632058174",
			["startPort"] = "StoryStart",
			["endStory"] = "17626068980632058176",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17626068980632058176",
			["startPort"] = "Success",
			["endStory"] = "17626068980632058175",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17626068980632058174"] = {
			["isStoryNode"] = true,
			["key"] = "17626068980632058174",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1014,
				["y"] = 322.25
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
		["17626068980632058175"] = {
			["isStoryNode"] = true,
			["key"] = "17626068980632058175",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1795,
				["y"] = 315
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17626068980632058176"] = {
			["isStoryNode"] = true,
			["key"] = "17626068980632058176",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1389.6428571428573,
				["y"] = 322.5123847926268
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
						["startQuest"] = "17626068980632058177",
						["startPort"] = "QuestStart",
						["endQuest"] = "17626068980632058180",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17626068980632058180",
						["startPort"] = "Out",
						["endQuest"] = "17626068980632058178",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17626068980632058180",
						["startPort"] = "Fail",
						["endQuest"] = "17626068980632058179",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17626068980632058177"] = {
						["key"] = "17626068980632058177",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 806,
							["y"] = 316
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17626068980632058178"] = {
						["key"] = "17626068980632058178",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1636,
							["y"] = 252
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17626068980632058179"] = {
						["key"] = "17626068980632058179",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1648.0000000000002,
							["y"] = 421.00000000000006
						},
						["propsData"] = {}
					},
					["17626068980632058180"] = {
						["key"] = "17626068980632058180",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1190.503105590062,
							["y"] = 312.08695652173907
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 51109031,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
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