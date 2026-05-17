return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732783210610494676",
			["startPort"] = "StoryStart",
			["endStory"] = "1732783210610494678",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732783210610494678",
			["startPort"] = "Success",
			["endStory"] = "1732783210610494677",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732783210610494676"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210610494676",
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
		["1732783210610494677"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210610494677",
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
		["1732783210610494678"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210610494678",
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
						["startQuest"] = "1732783210610494682",
						["startPort"] = "Out",
						["endQuest"] = "1725258975384200239",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1725258975384200239",
						["startPort"] = "Out",
						["endQuest"] = "1732783210610494680",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1752587480933637874",
						["startPort"] = "Out",
						["endQuest"] = "1737628467146656",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210610494679",
						["startPort"] = "QuestStart",
						["endQuest"] = "1752587480933637874",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210610494679",
						["startPort"] = "QuestStart",
						["endQuest"] = "1752587481629637910",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752587481629637910",
						["startPort"] = "Out",
						["endQuest"] = "1732783210610494682",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1752587481629637910",
						["startPort"] = "Out",
						["endQuest"] = "1725258957911199915",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1725258957911199915"] = {
						["key"] = "1725258957911199915",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1079.4876847290645,
							["y"] = 434.394088669951
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 1,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt01/0034_atomos_feina_home",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {}
						}
					},
					["1725258975384200239"] = {
						["key"] = "1725258975384200239",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1345.2019704433503,
							["y"] = 278.6798029556653
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 1,
							["SoundType"] = 0
						}
					},
					["1732783210610494679"] = {
						["key"] = "1732783210610494679",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 505.828437132785,
							["y"] = 155.84958871915393
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210610494680"] = {
						["key"] = "1732783210610494680",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1633.6071428571431,
							["y"] = 276.99999999999994
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210610494681"] = {
						["key"] = "1732783210610494681",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1572.0000000000002,
							["y"] = 434.5
						},
						["propsData"] = {}
					},
					["1732783210610494682"] = {
						["key"] = "1732783210610494682",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1079.3599878382488,
							["y"] = 287.07230330056404
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80050301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_180103",
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
									["TalkActorId"] = 790017,
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
									["TalkActorId"] = 100001,
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
					["1737628467146656"] = {
						["key"] = "1737628467146656",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1153.8965922444181,
							["y"] = 57.78143360752051
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101101,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["1752587480933637874"] = {
						["key"] = "1752587480933637874",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 820,
							["y"] = 58
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
					["1752587481629637910"] = {
						["key"] = "1752587481629637910",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 808,
							["y"] = 278
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