return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17638161434238250352",
			["startPort"] = "StoryStart",
			["endStory"] = "17638161474148250526",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17638161474148250526",
			["startPort"] = "Success",
			["endStory"] = "17638161434238250355",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17638161434238250352"] = {
			["isStoryNode"] = true,
			["key"] = "17638161434238250352",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 120308
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17638161434238250355"] = {
			["isStoryNode"] = true,
			["key"] = "17638161434238250355",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1406,
				["y"] = 292
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17638161474148250526"] = {
			["isStoryNode"] = true,
			["key"] = "17638161474148250526",
			["type"] = "StoryNode",
			["name"] = "离开华胥",
			["pos"] = {
				["x"] = 1116,
				["y"] = 297.5
			},
			["propsData"] = {
				["QuestId"] = 12030801,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120308_1",
				["QuestDeatil"] = "Content__120308_1",
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
				["SubRegionId"] = 104108,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QuestTrigger_2090012",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17638161474148250527",
						["startPort"] = "QuestStart",
						["endQuest"] = "17638161591838250818",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638161591838250818",
						["startPort"] = "Out",
						["endQuest"] = "17638161799588251114",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638161474148250527",
						["startPort"] = "QuestStart",
						["endQuest"] = "17706208645321403",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17638161799588251114",
						["startPort"] = "Out",
						["endQuest"] = "17638161474148250530",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17638161474148250527"] = {
						["key"] = "17638161474148250527",
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
					["17638161474148250530"] = {
						["key"] = "17638161474148250530",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1684.9665551839464,
							["y"] = 287.3745819397994
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17638161474148250533"] = {
						["key"] = "17638161474148250533",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17638161591838250818"] = {
						["key"] = "17638161591838250818",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1119.7959866220735,
							["y"] = 272.83277591973246
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 132090863,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_120308QuestTrigger_132090863"
						}
					},
					["17638161799588251114"] = {
						["key"] = "17638161799588251114",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1402.7892976588628,
							["y"] = 269.9030100334448
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1203/12063701.12063701'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East01_FixSimple_02",
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
					["17706208645321403"] = {
						["key"] = "17706208645321403",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1122,
							["y"] = 446.53846153846155
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162440010
							}
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}