return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17580263067283540825",
			["startPort"] = "StoryStart",
			["endStory"] = "17580263087413540879",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17580263087413540879",
			["startPort"] = "Success",
			["endStory"] = "17580263067283540828",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17580263067283540825"] = {
			["isStoryNode"] = true,
			["key"] = "17580263067283540825",
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
		["17580263067283540828"] = {
			["isStoryNode"] = true,
			["key"] = "17580263067283540828",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1638,
				["y"] = 350
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17580263087413540879"] = {
			["isStoryNode"] = true,
			["key"] = "17580263087413540879",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1230,
				["y"] = 316
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
						["startQuest"] = "17580263087413540880",
						["startPort"] = "QuestStart",
						["endQuest"] = "17580263676614183109",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580263676614183109",
						["startPort"] = "Branch_1",
						["endQuest"] = "17580263775324183365",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580263775324183365",
						["startPort"] = "Out",
						["endQuest"] = "17580263087413540883",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17580263676614183109",
						["startPort"] = "Branch_2",
						["endQuest"] = "17585093576309445",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17585093576309445",
						["startPort"] = "Out",
						["endQuest"] = "17580263087413540883",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17580263676614183109",
						["startPort"] = "Branch_3",
						["endQuest"] = "17615677609874019",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17615677609874019",
						["startPort"] = "Out",
						["endQuest"] = "17580263087413540883",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17580263087413540880"] = {
						["key"] = "17580263087413540880",
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
					["17580263087413540883"] = {
						["key"] = "17580263087413540883",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2072.5,
							["y"] = 428.75
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17580263087413540886"] = {
						["key"] = "17580263087413540886",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17580263676614183109"] = {
						["key"] = "17580263676614183109",
						["type"] = "BranchTriggerNode",
						["name"] = "触发分支节点",
						["pos"] = {
							["x"] = 1169.5454545454545,
							["y"] = 352.02272727272725
						},
						["propsData"] = {
							["Branches"] = {
								700181,
								700182,
								700183
							}
						}
					},
					["17580263775324183365"] = {
						["key"] = "17580263775324183365",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1594.217741935484,
							["y"] = 422.8790322580645
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20007107,
							["FlowAssetPath"] = "",
							["TalkType"] = "NoIntFixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17585093576309445"] = {
						["key"] = "17585093576309445",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1687.6774193548388,
							["y"] = 552.3870967741935
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20007108,
							["FlowAssetPath"] = "",
							["TalkType"] = "NoIntFixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17615677609874019"] = {
						["key"] = "17615677609874019",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1501.2534562211983,
							["y"] = 697.8709677419356
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 70016111,
							["FlowAssetPath"] = "",
							["TalkType"] = "NoIntFixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
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