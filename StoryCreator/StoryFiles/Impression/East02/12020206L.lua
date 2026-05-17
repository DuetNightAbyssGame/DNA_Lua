return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17724193532362077113",
			["startPort"] = "StoryStart",
			["endStory"] = "17724193532362077115",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17724193532362077115",
			["startPort"] = "Success",
			["endStory"] = "17724193532362077114",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17724193532362077113"] = {
			["isStoryNode"] = true,
			["key"] = "17724193532362077113",
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
		["17724193532362077114"] = {
			["isStoryNode"] = true,
			["key"] = "17724193532362077114",
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
		["17724193532362077115"] = {
			["isStoryNode"] = true,
			["key"] = "17724193532362077115",
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
						["startQuest"] = "1773382542836904",
						["startPort"] = "Out",
						["endQuest"] = "1773382542836905",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724193532362077116",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773382542836904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773382542836905",
						["startPort"] = "Out",
						["endQuest"] = "17724193532362077117",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17724193532362077116"] = {
						["key"] = "17724193532362077116",
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
					["17724193532362077117"] = {
						["key"] = "17724193532362077117",
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
					["17724193532362077118"] = {
						["key"] = "17724193532362077118",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1773382542836904"] = {
						["key"] = "1773382542836904",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_21】前方禁地，阁下请止步。",
						["pos"] = {
							["x"] = 1135.361209719194,
							["y"] = 288.64447808318647
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12042501.12042501'",
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
					["1773382542836905"] = {
						["key"] = "1773382542836905",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1412.9927886665623,
							["y"] = 271.55801191777283
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020206R",
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