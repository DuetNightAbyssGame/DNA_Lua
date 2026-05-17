return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177210259845331450256",
			["startPort"] = "StoryStart",
			["endStory"] = "177210259845331450258",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177210259845331450258",
			["startPort"] = "Success",
			["endStory"] = "177210259845331450257",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177210259845331450256"] = {
			["isStoryNode"] = true,
			["key"] = "177210259845331450256",
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
		["177210259845331450257"] = {
			["isStoryNode"] = true,
			["key"] = "177210259845331450257",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1789.375,
				["y"] = 337.5
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["177210259845331450258"] = {
			["isStoryNode"] = true,
			["key"] = "177210259845331450258",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1288,
				["y"] = 302
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
						["startQuest"] = "177210259845331450259",
						["startPort"] = "QuestStart",
						["endQuest"] = "177210259845331450262",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177209809010530961041",
						["startPort"] = "Out",
						["endQuest"] = "177210259845331450260",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177210259845331450262",
						["startPort"] = "Option_1",
						["endQuest"] = "177209809010530961041",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177210259845331450262",
						["startPort"] = "Option_2",
						["endQuest"] = "177210259845331450260",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177209809010530961041"] = {
						["key"] = "177209809010530961041",
						["type"] = "OpenSytstemUINode",
						["name"] = "打开界面节点",
						["pos"] = {
							["x"] = 1652,
							["y"] = 202
						},
						["propsData"] = {
							["IsAsync"] = true,
							["UIName"] = "ShopMain",
							["IsInterfaceJump"] = false
						}
					},
					["177210259845331450259"] = {
						["key"] = "177210259845331450259",
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
					["177210259845331450260"] = {
						["key"] = "177210259845331450260",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2098.75,
							["y"] = 306.75
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177210259845331450261"] = {
						["key"] = "177210259845331450261",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["177210259845331450262"] = {
						["key"] = "177210259845331450262",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1165.5,
							["y"] = 242.25
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51158005,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
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
							["SwitchToMaster"] = "None",
							["PlayerSwitchEmoIdle"] = true,
							["BranchOptions"] = {
								"",
								""
							},
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