return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17730376938714928929",
			["startPort"] = "StoryStart",
			["endStory"] = "17730376968554929069",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17730376968554929069",
			["startPort"] = "Success",
			["endStory"] = "17730376938714928932",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17730376938714928929"] = {
			["isStoryNode"] = true,
			["key"] = "17730376938714928929",
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
		["17730376938714928932"] = {
			["isStoryNode"] = true,
			["key"] = "17730376938714928932",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1414,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17730376968554929069"] = {
			["isStoryNode"] = true,
			["key"] = "17730376968554929069",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1130,
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
						["startQuest"] = "1773108331084984",
						["startPort"] = "Out",
						["endQuest"] = "1773108331084982",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773108331084985",
						["startPort"] = "Out",
						["endQuest"] = "1773108331084983",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730376968554929070",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773108331084984",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17730376968554929070",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773108331084985",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773108331084983",
						["startPort"] = "Out",
						["endQuest"] = "17730376968554929073",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17730376968554929070"] = {
						["key"] = "17730376968554929070",
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
					["17730376968554929073"] = {
						["key"] = "17730376968554929073",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1803.75,
							["y"] = 370
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17730376968554929076"] = {
						["key"] = "17730376968554929076",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1773108331084982"] = {
						["key"] = "1773108331084982",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1441.7777777777778,
							["y"] = 175.99999999999994
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104106,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["1773108331084983"] = {
						["key"] = "1773108331084983",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1438.7777777777778,
							["y"] = 371.74999999999994
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 80200001,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200101a",
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
					["1773108331084984"] = {
						["key"] = "1773108331084984",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1128.4722222222222,
							["y"] = 170.36111111111111
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
					["1773108331084985"] = {
						["key"] = "1773108331084985",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1123.5833333333335,
							["y"] = 373.13888888888886
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104106,
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