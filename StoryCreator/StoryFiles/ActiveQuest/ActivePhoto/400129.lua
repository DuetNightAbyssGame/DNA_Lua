return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17695929407465249965",
			["startPort"] = "StoryStart",
			["endStory"] = "17695929407465249964",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17695929407465249964",
			["startPort"] = "Success",
			["endStory"] = "17695929407465249966",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17695929407465249964"] = {
			["isStoryNode"] = true,
			["key"] = "17695929407465249964",
			["type"] = "StoryNode",
			["name"] = "回据点门口对话",
			["pos"] = {
				["x"] = 1362.0930555555556,
				["y"] = 301.4666666666667
			},
			["propsData"] = {
				["QuestId"] = 40012900,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_400129_1",
				["QuestDeatil"] = "Content_400129_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = true,
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
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_40012100_1192071",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17695929407465249968",
						["startPort"] = "QuestStart",
						["endQuest"] = "17695929407465249971",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695929407465249971",
						["startPort"] = "Out",
						["endQuest"] = "17695929407465249972",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695929407465249972",
						["startPort"] = "Out",
						["endQuest"] = "17695929407465249973",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695929407465249973",
						["startPort"] = "Out",
						["endQuest"] = "17695929407465249969",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17695929407465249971",
						["startPort"] = "Out",
						["endQuest"] = "1773630006667523",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17695929407465249968"] = {
						["key"] = "17695929407465249968",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 899,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17695929407465249969"] = {
						["key"] = "17695929407465249969",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2012.5,
							["y"] = 319.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17695929407465249970"] = {
						["key"] = "17695929407465249970",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2014,
							["y"] = 532
						},
						["propsData"] = {}
					},
					["17695929407465249971"] = {
						["key"] = "17695929407465249971",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1186,
							["y"] = 308
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "M",
							["GuideName"] = "Mechanism_40012100_1192071"
						}
					},
					["17695929407465249972"] = {
						["key"] = "17695929407465249972",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1468,
							["y"] = 308.5
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1192071,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_40012100_1192071"
						}
					},
					["17695929407465249973"] = {
						["key"] = "17695929407465249973",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1746,
							["y"] = 310.5
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActivityPhoto/400129/40012901.40012901'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 0,
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
					["1773630006667523"] = {
						["key"] = "1773630006667523",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1470.9935604418363,
							["y"] = 121.53553014860788
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51014000,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17695929407465249965"] = {
			["isStoryNode"] = true,
			["key"] = "17695929407465249965",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 957.5072463768117,
				["y"] = 308.3605390287312
			},
			["propsData"] = {
				["QuestChainId"] = 400129
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17695929407465249966"] = {
			["isStoryNode"] = true,
			["key"] = "17695929407465249966",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1704.7075977162935,
				["y"] = 314.715458937198
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