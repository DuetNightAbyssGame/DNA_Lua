return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17652030320431824462",
			["startPort"] = "StoryStart",
			["endStory"] = "17652030320431824464",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17652030320431824464",
			["startPort"] = "Success",
			["endStory"] = "17652030320431824463",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17652030320431824462"] = {
			["isStoryNode"] = true,
			["key"] = "17652030320431824462",
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
		["17652030320431824463"] = {
			["isStoryNode"] = true,
			["key"] = "17652030320431824463",
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
		["17652030320431824464"] = {
			["isStoryNode"] = true,
			["key"] = "17652030320431824464",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1389.6428571428573,
				["y"] = 321.1487484289904
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
						["startQuest"] = "17652030320431824465",
						["startPort"] = "QuestStart",
						["endQuest"] = "17652030320431824468",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17652030320431824468",
						["startPort"] = "Out",
						["endQuest"] = "17652030320431824466",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17652030320431824468",
						["startPort"] = "Fail",
						["endQuest"] = "17652030320431824467",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17652030320431824465"] = {
						["key"] = "17652030320431824465",
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
					["17652030320431824466"] = {
						["key"] = "17652030320431824466",
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
					["17652030320431824467"] = {
						["key"] = "17652030320431824467",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1648.0000000000002,
							["y"] = 421.00000000000006
						},
						["propsData"] = {}
					},
					["17652030320431824468"] = {
						["key"] = "17652030320431824468",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1188.503105590062,
							["y"] = 312.08695652173907
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 51120032,
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}