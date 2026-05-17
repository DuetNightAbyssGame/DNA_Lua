return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17213570503702861",
			["startPort"] = "StoryStart",
			["endStory"] = "17213571672823366",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17213571672823366",
			["startPort"] = "Success",
			["endStory"] = "17213570503702864",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17213570503702861"] = {
			["isStoryNode"] = true,
			["key"] = "17213570503702861",
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
		["17213570503702864"] = {
			["isStoryNode"] = true,
			["key"] = "17213570503702864",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1475,
				["y"] = 275
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17213571672823366"] = {
			["isStoryNode"] = true,
			["key"] = "17213571672823366",
			["type"] = "StoryNode",
			["name"] = "黑桃的回忆（正式名：睡前故事）",
			["pos"] = {
				["x"] = 1131.8395721925133,
				["y"] = 288.86949995309106
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_BalconyHeiTao_Des",
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
				["bIsDynamicEvent"] = true,
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
						["startQuest"] = "1721384342924936",
						["startPort"] = "Out",
						["endQuest"] = "172135780037311203",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "172135780037311203",
						["startPort"] = "Out",
						["endQuest"] = "17213843586271499",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213843586271499",
						["startPort"] = "Out",
						["endQuest"] = "17213571672833370",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17213571672833367",
						["startPort"] = "QuestStart",
						["endQuest"] = "17213572947314989",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213572947314989",
						["startPort"] = "Out",
						["endQuest"] = "17213762765575345",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213762765575345",
						["startPort"] = "Out",
						["endQuest"] = "17271479122381429",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17213763125676023",
						["startPort"] = "Out",
						["endQuest"] = "17271479385982069",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17271479122381429",
						["startPort"] = "Out",
						["endQuest"] = "17213763125676023",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17271479385982069",
						["startPort"] = "Out",
						["endQuest"] = "1721384342924936",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17213571672833367"] = {
						["key"] = "17213571672833367",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 770.0923076923077,
							["y"] = 312.73846153846154
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17213571672833370"] = {
						["key"] = "17213571672833370",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3962.227272727273,
							["y"] = 237.68181818181816
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17213571672833373"] = {
						["key"] = "17213571672833373",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3461.3636363636365,
							["y"] = 817.2727272727273
						},
						["propsData"] = {}
					},
					["17213572947314989"] = {
						["key"] = "17213572947314989",
						["type"] = "TalkNode",
						["name"] = "主角开车对话",
						["pos"] = {
							["x"] = 1137.2941176470588,
							["y"] = 292.9604090440001
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71001301,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17213573933385960"] = {
						["key"] = "17213573933385960",
						["type"] = "TalkNode",
						["name"] = "与床交互对话",
						["pos"] = {
							["x"] = 1273.0563554092969,
							["y"] = -136.45392662033558
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71001303,
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
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17213574560606958"] = {
						["key"] = "17213574560606958",
						["type"] = "TalkNode",
						["name"] = "与炼金器械对话",
						["pos"] = {
							["x"] = 1264.7206910736322,
							["y"] = 47.04607337966456
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = false,
							["IsNPCTurnToPlayer"] = false,
							["FirstDialogueId"] = 71001304,
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
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["172135780037311203"] = {
						["key"] = "172135780037311203",
						["type"] = "TalkNode",
						["name"] = "交互完成对话",
						["pos"] = {
							["x"] = 3281.650761003703,
							["y"] = 250.50936009295134
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71001306,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
					["17213762765575345"] = {
						["key"] = "17213762765575345",
						["type"] = "PickUpNode",
						["name"] = "与床交互",
						["pos"] = {
							["x"] = 1740.0763138396135,
							["y"] = 77.57852678012522
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1570094
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80011,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17213763125676023"] = {
						["key"] = "17213763125676023",
						["type"] = "PickUpNode",
						["name"] = "与炼金器械交互",
						["pos"] = {
							["x"] = 1794.630859294159,
							["y"] = 348.0725827241813
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1570095
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80012,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["1721384342924936"] = {
						["key"] = "1721384342924936",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2825.230769230769,
							["y"] = 291.71153846153845
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17213843586271499"] = {
						["key"] = "17213843586271499",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3645.5,
							["y"] = 235
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17271479122381429"] = {
						["key"] = "17271479122381429",
						["type"] = "TalkNode",
						["name"] = "与床交互",
						["pos"] = {
							["x"] = 2099.085448916409,
							["y"] = 59.35334928229681
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71001303,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
					["17271479385982069"] = {
						["key"] = "17271479385982069",
						["type"] = "TalkNode",
						["name"] = "与炼金交互",
						["pos"] = {
							["x"] = 2181.1692873002476,
							["y"] = 323.3039708829184
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71001304,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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