return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1746518311597552900",
			["startPort"] = "StoryStart",
			["endStory"] = "1746518311597552902",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1746518311597552902",
			["startPort"] = "Success",
			["endStory"] = "1746518311597552901",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1746518311597552900"] = {
			["isStoryNode"] = true,
			["key"] = "1746518311597552900",
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
		["1746518311597552901"] = {
			["isStoryNode"] = true,
			["key"] = "1746518311597552901",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1810,
				["y"] = 306.9230769230769
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1746518311597552902"] = {
			["isStoryNode"] = true,
			["key"] = "1746518311597552902",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1341.3273833654268,
				["y"] = 357.5791210600993
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
						["startQuest"] = "1746518311597552903",
						["startPort"] = "QuestStart",
						["endQuest"] = "1746518311597552906",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1746518311597552906",
						["startPort"] = "Out",
						["endQuest"] = "1746518311597552904",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1746518311597552903"] = {
						["key"] = "1746518311597552903",
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
					["1746518311597552904"] = {
						["key"] = "1746518311597552904",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1328.585607940447,
							["y"] = 305.2109181141439
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1746518311597552905"] = {
						["key"] = "1746518311597552905",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1373.8461538461543,
							["y"] = 499.2307692307693
						},
						["propsData"] = {}
					},
					["1746518311597552906"] = {
						["key"] = "1746518311597552906",
						["type"] = "TalkNode",
						["name"] = "赛琪摔倒",
						["pos"] = {
							["x"] = 1056.2100169147425,
							["y"] = 304.08473465800654
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC020/SQ_OBT0101_SC020",
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
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