return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17503208713682371",
			["startPort"] = "StoryStart",
			["endStory"] = "17503208750742407",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17503208750742407",
			["startPort"] = "Success",
			["endStory"] = "17503208713682374",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17503208713682371"] = {
			["isStoryNode"] = true,
			["key"] = "17503208713682371",
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
		["17503208713682374"] = {
			["isStoryNode"] = true,
			["key"] = "17503208713682374",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1490,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17503208750742407"] = {
			["isStoryNode"] = true,
			["key"] = "17503208750742407",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1160,
				["y"] = 270
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
						["startQuest"] = "17503295394211295664",
						["startPort"] = "Out",
						["endQuest"] = "17503208750742413",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1750333114411904",
						["startPort"] = "Out",
						["endQuest"] = "17503208750742417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503208750742412",
						["startPort"] = "QuestStart",
						["endQuest"] = "1750333114411904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503208750742412",
						["startPort"] = "QuestStart",
						["endQuest"] = "17503331301001151",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503331301001151",
						["startPort"] = "Out",
						["endQuest"] = "17503295394211295664",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503208750742417",
						["startPort"] = "Out",
						["endQuest"] = "17503307964157915",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17503331301001151",
						["startPort"] = "Out",
						["endQuest"] = "17601725152201869432",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17503208750742412"] = {
						["key"] = "17503208750742412",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -147.67470732534258,
							["y"] = 237.00669445497033
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17503208750742413"] = {
						["key"] = "17503208750742413",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 807.8119422170698,
							["y"] = 401.99904042914034
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17503208750742414"] = {
						["key"] = "17503208750742414",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 807.4865709699475,
							["y"] = 569.3773312281191
						},
						["propsData"] = {}
					},
					["17503208750742417"] = {
						["key"] = "17503208750742417",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 482.5613307225257,
							["y"] = 245.25446938676632
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80160101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_320101",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790055,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790008,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
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
					["17503295394211295664"] = {
						["key"] = "17503295394211295664",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 489.93607543600683,
							["y"] = 404.9062856052641
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80160110,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_320101",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790055,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790052,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
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
					["17503307964157915"] = {
						["key"] = "17503307964157915",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 804.4361286848833,
							["y"] = 246.5150087494951
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101107,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["1750333114411904"] = {
						["key"] = "1750333114411904",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 160.12500000000006,
							["y"] = 242.89254385964898
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 210101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17503331301001151"] = {
						["key"] = "17503331301001151",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 172.7565789473685,
							["y"] = 403.94517543859615
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101107,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["17601725152201869432"] = {
						["key"] = "17601725152201869432",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 484.7826086956522,
							["y"] = 562.695652173913
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 1,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0016_judian",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {}
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}