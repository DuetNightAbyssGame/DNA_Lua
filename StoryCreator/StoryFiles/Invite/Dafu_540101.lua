return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17485895644492377835",
			["startPort"] = "StoryStart",
			["endStory"] = "17485895692412378020",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17485895692412378020",
			["startPort"] = "Success",
			["endStory"] = "17485895644492377838",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17485895644492377835"] = {
			["isStoryNode"] = true,
			["key"] = "17485895644492377835",
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
		["17485895644492377838"] = {
			["isStoryNode"] = true,
			["key"] = "17485895644492377838",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1668,
				["y"] = 308
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17485895692412378020"] = {
			["isStoryNode"] = true,
			["key"] = "17485895692412378020",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1236,
				["y"] = 290
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
						["startQuest"] = "1750407826687324597",
						["startPort"] = "Out",
						["endQuest"] = "17485895692412378024",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17485895692412378021",
						["startPort"] = "QuestStart",
						["endQuest"] = "17528091580996737669",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528091580996737669",
						["startPort"] = "Out",
						["endQuest"] = "1750407801048324213",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485895692412378021",
						["startPort"] = "QuestStart",
						["endQuest"] = "17528091580996737670",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17528091580996737670",
						["startPort"] = "Out",
						["endQuest"] = "1750407826687324597",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17485895692412378021"] = {
						["key"] = "17485895692412378021",
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
					["17485895692412378024"] = {
						["key"] = "17485895692412378024",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2034,
							["y"] = 310
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17485895692412378027"] = {
						["key"] = "17485895692412378027",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2092,
							["y"] = 528
						},
						["propsData"] = {}
					},
					["1750407801048324213"] = {
						["key"] = "1750407801048324213",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1607.0588235294117,
							["y"] = 127.29411764705881
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101110,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["1750407826687324597"] = {
						["key"] = "1750407826687324597",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1604,
							["y"] = 296
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80180101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_540101",
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 790045,
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
									["TalkActorId"] = 790059,
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
					["17528091580996737669"] = {
						["key"] = "17528091580996737669",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1189.3341503267973,
							["y"] = 116.34640522875816
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
					["17528091580996737670"] = {
						["key"] = "17528091580996737670",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1194.4452614379086,
							["y"] = 364.1241830065359
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101110,
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