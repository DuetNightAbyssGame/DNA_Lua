return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1704175978930179310",
			["startPort"] = "StoryStart",
			["endStory"] = "17141819383127344",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17141819383127344",
			["startPort"] = "Success",
			["endStory"] = "1704175978930179311",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1704175978930179310"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978930179310",
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
		["1704175978930179311"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978930179311",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1431.4425770308126,
				["y"] = 300.5882352941176
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17141819383127344"] = {
			["isStoryNode"] = true,
			["key"] = "17141819383127344",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1112.9960752885659,
				["y"] = 293.1447424586231
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
						["startQuest"] = "1773382530271841846",
						["startPort"] = "Out",
						["endQuest"] = "1773382530271841847",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17141819383127345",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773382530271841846",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773382530271841847",
						["startPort"] = "Out",
						["endQuest"] = "17141819383127347",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17141819383127345"] = {
						["key"] = "17141819383127345",
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
					["17141819383127347"] = {
						["key"] = "17141819383127347",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1710.9210526315806,
							["y"] = 308.41739766081866
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17141819383127349"] = {
						["key"] = "17141819383127349",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1773382530271841846"] = {
						["key"] = "1773382530271841846",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_21】前方禁地，阁下请止步。",
						["pos"] = {
							["x"] = 1051.965681337452,
							["y"] = 276.53471168524027
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12042501_2.12042501_2'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020206",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1773382530271841847"] = {
						["key"] = "1773382530271841847",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1374.9818756694358,
							["y"] = 266.0691246407058
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020206L",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}