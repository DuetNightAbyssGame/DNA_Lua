return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1765195374537429388",
			["startPort"] = "StoryStart",
			["endStory"] = "1765195374537429390",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1765195374537429390",
			["startPort"] = "Success",
			["endStory"] = "1765195374537429389",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1765195374537429388"] = {
			["isStoryNode"] = true,
			["key"] = "1765195374537429388",
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
		["1765195374537429389"] = {
			["isStoryNode"] = true,
			["key"] = "1765195374537429389",
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
		["1765195374537429390"] = {
			["isStoryNode"] = true,
			["key"] = "1765195374537429390",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1387.6428571428573,
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
						["startQuest"] = "1765195374537429391",
						["startPort"] = "QuestStart",
						["endQuest"] = "1765195374537429394",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1765195374537429394",
						["startPort"] = "Out",
						["endQuest"] = "1765195374537429392",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1765195374537429394",
						["startPort"] = "Fail",
						["endQuest"] = "1765195374537429393",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1765195374537429391"] = {
						["key"] = "1765195374537429391",
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
					["1765195374537429392"] = {
						["key"] = "1765195374537429392",
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
					["1765195374537429393"] = {
						["key"] = "1765195374537429393",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1648.0000000000002,
							["y"] = 421.00000000000006
						},
						["propsData"] = {}
					},
					["1765195374537429394"] = {
						["key"] = "1765195374537429394",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1188.503105590062,
							["y"] = 312.08695652173907
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51124027,
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