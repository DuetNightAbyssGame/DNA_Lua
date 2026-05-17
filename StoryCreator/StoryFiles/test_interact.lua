return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17700116425411",
			["startPort"] = "StoryStart",
			["endStory"] = "177001164733666",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177001164733666",
			["startPort"] = "Success",
			["endStory"] = "17700116425425",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17700116425411"] = {
			["isStoryNode"] = true,
			["key"] = "17700116425411",
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
		["17700116425425"] = {
			["isStoryNode"] = true,
			["key"] = "17700116425425",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2800,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["177001164733666"] = {
			["isStoryNode"] = true,
			["key"] = "177001164733666",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1708,
				["y"] = 340
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
						["startQuest"] = "1770011667966505",
						["startPort"] = "Out",
						["endQuest"] = "177001164733675",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "177001164733667",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772159814406878",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772159814406878",
						["startPort"] = "Success",
						["endQuest"] = "1770011667966505",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772159814406878",
						["startPort"] = "Fail",
						["endQuest"] = "1770014859959761428",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770014859959761428",
						["startPort"] = "Out",
						["endQuest"] = "177001164733675",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177001164733667"] = {
						["key"] = "177001164733667",
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
					["177001164733675"] = {
						["key"] = "177001164733675",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2222.5,
							["y"] = 341.25
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177001164733783"] = {
						["key"] = "177001164733783",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2224.375,
							["y"] = 480.625
						},
						["propsData"] = {}
					},
					["1770011667966505"] = {
						["key"] = "1770011667966505",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1560.0142284186404,
							["y"] = 9.414247517188642
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 77000008,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 760000201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
					},
					["1770014859959761428"] = {
						["key"] = "1770014859959761428",
						["type"] = "ListenPlayerSkillAndActionNode",
						["name"] = "监听玩家技能和动作",
						["pos"] = {
							["x"] = 1570.093031968032,
							["y"] = 343.61101398601363
						},
						["propsData"] = {
							["ListenIds"] = {
								41001
							},
							["CompareType"] = 4,
							["ListenCount"] = 1,
							["ListenType"] = 0,
							["StaticPointId"] = 123456789,
							["StaticPointListenMinCM"] = 0,
							["StaticPointListenMaxCM"] = 500
						}
					},
					["1772159814406878"] = {
						["key"] = "1772159814406878",
						["type"] = "ConditionNode",
						["name"] = "条件节点",
						["pos"] = {
							["x"] = 1143.0357142857142,
							["y"] = 287.3104395604395
						},
						["propsData"] = {
							["ConditionId"] = 77000008
						}
					},
					["17721744881243137645"] = {
						["key"] = "17721744881243137645",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1578.0470844944532,
							["y"] = 562.0365681229523
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 77000008,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 760000203,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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