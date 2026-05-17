return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1704175978879178387",
			["startPort"] = "StoryStart",
			["endStory"] = "169823505418862352",
			["endPort"] = "In"
		},
		{
			["startStory"] = "169823505418862352",
			["startPort"] = "Success",
			["endStory"] = "1704175978879178388",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "169823505418862352",
			["startPort"] = "Fail",
			["endStory"] = "1704175978879178388",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["169823505418862352"] = {
			["isStoryNode"] = true,
			["key"] = "169823505418862352",
			["type"] = "StoryNode",
			["name"] = "印象系统节点",
			["pos"] = {
				["x"] = 1194.2523714731446,
				["y"] = 295.0379983703644
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
						["startQuest"] = "1704175978879178389",
						["startPort"] = "QuestStart",
						["endQuest"] = "169823505988762886",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "169823505988762886",
						["startPort"] = "Out",
						["endQuest"] = "1704175978879178390",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "169823505988762886",
						["startPort"] = "Fail",
						["endQuest"] = "1704175978879178391",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["169823505988762886"] = {
						["key"] = "169823505988762886",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1138.4796442004174,
							["y"] = 288.53799837036445
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51001701,
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
					},
					["1704175978879178389"] = {
						["key"] = "1704175978879178389",
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
					["1704175978879178390"] = {
						["key"] = "1704175978879178390",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1495.8506493506493,
							["y"] = 126.87662337662337
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978879178391"] = {
						["key"] = "1704175978879178391",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1523.0974025974024,
							["y"] = 438.62987012987014
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["1704175978879178387"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978879178387",
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
		["1704175978879178388"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978879178388",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1661.764705882353,
				["y"] = 294.70588235294116
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}