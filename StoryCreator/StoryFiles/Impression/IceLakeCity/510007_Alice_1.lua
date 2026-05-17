return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1704175978764175749",
			["startPort"] = "StoryStart",
			["endStory"] = "1704175978764175751",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1704175978764175751",
			["startPort"] = "Success",
			["endStory"] = "1704175978764175750",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "1704175978764175751",
			["startPort"] = "Fail",
			["endStory"] = "1704175978764175750",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1704175978764175749"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978764175749",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 935.5555555555555,
				["y"] = 313.3333333333333
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
		["1704175978764175750"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978764175750",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1525,
				["y"] = 310.55555555555554
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1704175978764175751"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978764175751",
			["type"] = "StoryNode",
			["name"] = "印象系统节点",
			["pos"] = {
				["x"] = 1216.095238095238,
				["y"] = 301.5
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
						["startQuest"] = "1704175978764175752",
						["startPort"] = "QuestStart",
						["endQuest"] = "1704175978764175755",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1704175978764175755",
						["startPort"] = "Out",
						["endQuest"] = "1704175978764175753",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1704175978764175755",
						["startPort"] = "Fail",
						["endQuest"] = "1704175978764175754",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1704175978764175752"] = {
						["key"] = "1704175978764175752",
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
					["1704175978764175753"] = {
						["key"] = "1704175978764175753",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1604.575163398693,
							["y"] = 244.44444444444443
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978764175754"] = {
						["key"] = "1704175978764175754",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1598.0392156862742,
							["y"] = 436.4705882352941
						},
						["propsData"] = {}
					},
					["1704175978764175755"] = {
						["key"] = "1704175978764175755",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1172.3202614379088,
							["y"] = 303.3333333333333
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51000701,
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
							["OptionType"] = "plus",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["PlusOptions"] = {},
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