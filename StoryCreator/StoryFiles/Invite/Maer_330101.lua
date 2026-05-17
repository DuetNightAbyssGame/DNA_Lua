return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732692284256491385",
			["startPort"] = "StoryStart",
			["endStory"] = "1732692284256491387",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732692284256491387",
			["startPort"] = "Success",
			["endStory"] = "1732692284256491386",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732692284256491385"] = {
			["isStoryNode"] = true,
			["key"] = "1732692284256491385",
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
		["1732692284256491386"] = {
			["isStoryNode"] = true,
			["key"] = "1732692284256491386",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1435.111111111111,
				["y"] = 298.44444444444446
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1732692284256491387"] = {
			["isStoryNode"] = true,
			["key"] = "1732692284256491387",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1102.888888888889,
				["y"] = 288.44444444444446
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
						["startQuest"] = "1732694908313616156",
						["startPort"] = "Out",
						["endQuest"] = "17326989868754300760",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17326989868754300760",
						["startPort"] = "Out",
						["endQuest"] = "1732692284256491389",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1732692284256491388",
						["startPort"] = "QuestStart",
						["endQuest"] = "17528093041168021856",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528093041168021856",
						["startPort"] = "Out",
						["endQuest"] = "1737628546468548",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732692284256491388",
						["startPort"] = "QuestStart",
						["endQuest"] = "17528093041168021857",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528093041168021857",
						["startPort"] = "Out",
						["endQuest"] = "1732694908313616156",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1732692284256491388"] = {
						["key"] = "1732692284256491388",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 138.22632731253424,
							["y"] = 246.98960043787628
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732692284256491389"] = {
						["key"] = "1732692284256491389",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1259.7352216748773,
							["y"] = 263.1226053639847
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732692284256491390"] = {
						["key"] = "1732692284256491390",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1553.5555555555557,
							["y"] = 437.16666666666663
						},
						["propsData"] = {}
					},
					["1732694908313616156"] = {
						["key"] = "1732694908313616156",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 670.75,
							["y"] = 275.125
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80120100,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_330101",
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
									["TalkActorId"] = 790019,
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
									["TalkActorId"] = 790018,
									["TalkActorVisible"] = true,
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
					["17326989868754300760"] = {
						["key"] = "17326989868754300760",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 939.375,
							["y"] = 270.375
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80120130,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 1,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["1737628546468548"] = {
						["key"] = "1737628546468548",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 685.080808080808,
							["y"] = 102.88888888888891
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101101,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17528093041168021856"] = {
						["key"] = "17528093041168021856",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 399.44444444444434,
							["y"] = 78.11111111111111
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
					["17528093041168021857"] = {
						["key"] = "17528093041168021857",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 402.55555555555566,
							["y"] = 271.88888888888886
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}