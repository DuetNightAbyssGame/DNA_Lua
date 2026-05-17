return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177209715167530668768",
			["startPort"] = "StoryStart",
			["endStory"] = "177209715167530668770",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177209715167530668770",
			["startPort"] = "Success",
			["endStory"] = "177209715167530668769",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177209715167530668768"] = {
			["isStoryNode"] = true,
			["key"] = "177209715167530668768",
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
		["177209715167530668769"] = {
			["isStoryNode"] = true,
			["key"] = "177209715167530668769",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1659.857142857143,
				["y"] = 180.14285714285714
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["177209715167530668770"] = {
			["isStoryNode"] = true,
			["key"] = "177209715167530668770",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1226.6140648567118,
				["y"] = 279.62727223756656
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
						["startQuest"] = "177209715167530668771",
						["startPort"] = "QuestStart",
						["endQuest"] = "177209715167530668774",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177209715167530668774",
						["startPort"] = "Fail",
						["endQuest"] = "177209715167530668773",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "177209715167530668774",
						["startPort"] = "Option_1",
						["endQuest"] = "177227387666416572185",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177209715167530668774",
						["startPort"] = "Option_2",
						["endQuest"] = "177209715167530668772",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177227387666416572185",
						["startPort"] = "Out",
						["endQuest"] = "177209715167530668772",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177209715167530668771"] = {
						["key"] = "177209715167530668771",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 891.6923076923077,
							["y"] = 391.38461538461536
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177209715167530668772"] = {
						["key"] = "177209715167530668772",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2052,
							["y"] = 316
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177209715167530668773"] = {
						["key"] = "177209715167530668773",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1973.2,
							["y"] = 557.6000000000001
						},
						["propsData"] = {}
					},
					["177209715167530668774"] = {
						["key"] = "177209715167530668774",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1304.0077231121281,
							["y"] = 395.41561784897016
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51158010,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"",
								""
							},
							["OverrideFailBlend"] = false
						}
					},
					["177227387666416572185"] = {
						["key"] = "177227387666416572185",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1732,
							["y"] = 228
						},
						["propsData"] = {
							["IsAsync"] = true,
							["UIName"] = "ShopMain",
							["IsInterfaceJump"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}