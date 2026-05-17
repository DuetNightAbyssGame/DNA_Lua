return {
	["storyName"] = "未命名故事",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "170893333260253443",
			["startPort"] = "StoryStart",
			["endStory"] = "170893333260253445",
			["endPort"] = "In"
		},
		{
			["startStory"] = "170893333260253445",
			["startPort"] = "Success",
			["endStory"] = "170893333260253444",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["170893333260253443"] = {
			["isStoryNode"] = true,
			["key"] = "170893333260253443",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 100,
				["y"] = 140
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
		["170893333260253444"] = {
			["isStoryNode"] = true,
			["key"] = "170893333260253444",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 400,
				["y"] = 140
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["170893333260253445"] = {
			["isStoryNode"] = true,
			["key"] = "170893333260253445",
			["type"] = "StoryNode",
			["name"] = "未命名任务",
			["pos"] = {
				["x"] = 300,
				["y"] = 140
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
				["bIsNotifyGameMode"] = false,
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
						["startQuest"] = "170893333260253446",
						["startPort"] = "QuestStart",
						["endQuest"] = "17217912338318444",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17217912338318444",
						["startPort"] = "Out",
						["endQuest"] = "170893333260253447",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1760682598921517",
						["startPort"] = "Out",
						["endQuest"] = "1760682598920516",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "170893333260253446",
						["startPort"] = "QuestStart",
						["endQuest"] = "1760682598921517",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["170893333260253446"] = {
						["key"] = "170893333260253446",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 258,
							["y"] = 550
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["170893333260253447"] = {
						["key"] = "170893333260253447",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 946,
							["y"] = 538
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["170893333260253448"] = {
						["key"] = "170893333260253448",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1500,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["17217912338318444"] = {
						["key"] = "17217912338318444",
						["type"] = "TalkNode",
						["name"] = "过场-100191-和前男主对话-SC02",
						["pos"] = {
							["x"] = 632,
							["y"] = 546
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC002/SQ_OBT0100_SC002",
							["BlendInTime"] = 1,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
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
					},
					["1760682598920516"] = {
						["key"] = "1760682598920516",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "noise - state 0 - start",
						["pos"] = {
							["x"] = 634.3490195105808,
							["y"] = 896.6282096738934
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 1,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/cine/OBT0100/SC002.SC002'",
							["ParamKey"] = "state",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["1760682598921517"] = {
						["key"] = "1760682598921517",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "bgm - start",
						["pos"] = {
							["x"] = 630.6117841784833,
							["y"] = 764.5549260309813
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0002_story_shahai",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					}
				},
				["commentData"] = {
					["1760682601072620"] = {
						["key"] = "1760682601072620",
						["name"] = "sc002音效播放",
						["position"] = {
							["x"] = 613.2651209208841,
							["y"] = 686.9666580946181
						},
						["size"] = {
							["width"] = 254.54545454545453,
							["height"] = 350.90909090909076
						}
					}
				}
			}
		}
	},
	["commentData"] = {}
}