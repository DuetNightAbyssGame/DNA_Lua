return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17730379250669589913",
			["startPort"] = "StoryStart",
			["endStory"] = "17730379250669589915",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17730379250669589915",
			["startPort"] = "Success",
			["endStory"] = "17730379250669589914",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17730379250669589913"] = {
			["isStoryNode"] = true,
			["key"] = "17730379250669589913",
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
		["17730379250669589914"] = {
			["isStoryNode"] = true,
			["key"] = "17730379250669589914",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1414,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17730379250669589915"] = {
			["isStoryNode"] = true,
			["key"] = "17730379250669589915",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1128.5,
				["y"] = 290
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
						["startQuest"] = "17730379250669589916",
						["startPort"] = "QuestStart",
						["endQuest"] = "177314575530818661879",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177314575530818661879",
						["startPort"] = "Out",
						["endQuest"] = "17730379250669589917",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17730379250669589916"] = {
						["key"] = "17730379250669589916",
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
					["17730379250669589917"] = {
						["key"] = "17730379250669589917",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1410.7692307692307,
							["y"] = 306.9230769230769
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17730379250669589918"] = {
						["key"] = "17730379250669589918",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["177314575530818661879"] = {
						["key"] = "177314575530818661879",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1093.7854618684137,
							["y"] = 290.65328874024544
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = false,
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