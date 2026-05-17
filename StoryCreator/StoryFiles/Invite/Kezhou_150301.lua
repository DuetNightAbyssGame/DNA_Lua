return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17581772909511",
			["startPort"] = "StoryStart",
			["endStory"] = "1758177332860363",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1758177332860363",
			["startPort"] = "Success",
			["endStory"] = "17581772909525",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17581772909511"] = {
			["isStoryNode"] = true,
			["key"] = "17581772909511",
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
		["17581772909525"] = {
			["isStoryNode"] = true,
			["key"] = "17581772909525",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1606,
				["y"] = 294
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1758177332860363"] = {
			["isStoryNode"] = true,
			["key"] = "1758177332860363",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1202,
				["y"] = 292
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
						["startQuest"] = "17587120918394797",
						["startPort"] = "Out",
						["endQuest"] = "1758177332860371",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17587125480741310550",
						["startPort"] = "Out",
						["endQuest"] = "17587125480741310551",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758177332860364",
						["startPort"] = "QuestStart",
						["endQuest"] = "17587125480741310550",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758177332860364",
						["startPort"] = "QuestStart",
						["endQuest"] = "17587125480741310552",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17587125480741310552",
						["startPort"] = "Out",
						["endQuest"] = "17587120918394797",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1758177332860364"] = {
						["key"] = "1758177332860364",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 681.304347826087,
							["y"] = 93.91304347826085
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1758177332860371"] = {
						["key"] = "1758177332860371",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1716.704805491991,
							["y"] = 46.201372997711644
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1758177332860378"] = {
						["key"] = "1758177332860378",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17587120918394797"] = {
						["key"] = "17587120918394797",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1404.4936117467582,
							["y"] = 203.61489321128911
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80210101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "TalkStageNew_150301",
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
									["TalkActorId"] = 790067,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790065,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790066,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
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
					["17587125480741310550"] = {
						["key"] = "17587125480741310550",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 999.9772735406483,
							["y"] = -6.407640065248756
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
					["17587125480741310551"] = {
						["key"] = "17587125480741310551",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1383.7019467432629,
							["y"] = 2.5400723530518974
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104107,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17587125480741310552"] = {
						["key"] = "17587125480741310552",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 999.7840368256726,
							["y"] = 200.23970292992024
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104107,
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