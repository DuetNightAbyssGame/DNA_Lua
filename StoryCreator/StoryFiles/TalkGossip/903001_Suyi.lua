return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17696687628271",
			["startPort"] = "StoryStart",
			["endStory"] = "176966876670876",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176966876670876",
			["startPort"] = "Success",
			["endStory"] = "17696687628275",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17696687628271"] = {
			["isStoryNode"] = true,
			["key"] = "17696687628271",
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
		["17696687628275"] = {
			["isStoryNode"] = true,
			["key"] = "17696687628275",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1715.1515318721958,
				["y"] = 293.9393940328056
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176966876670876"] = {
			["isStoryNode"] = true,
			["key"] = "176966876670876",
			["type"] = "StoryNode",
			["name"] = "苏乙看板娘",
			["pos"] = {
				["x"] = 1182.9696993283405,
				["y"] = 293.8787880656111
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
						["startQuest"] = "176966876670877",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769668797451736",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769668797451736",
						["startPort"] = "Out",
						["endQuest"] = "17696688171341223",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17696688171341223",
						["startPort"] = "Out",
						["endQuest"] = "1769668806491933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769668806491933",
						["startPort"] = "Out",
						["endQuest"] = "176966876670885",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["176966876670877"] = {
						["key"] = "176966876670877",
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
					["176966876670885"] = {
						["key"] = "176966876670885",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1872,
							["y"] = 350
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176966876670893"] = {
						["key"] = "176966876670893",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1769668797451736"] = {
						["key"] = "1769668797451736",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 982,
							["y"] = 598
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 81504,
									["NpcPose"] = "Idle"
								}
							}
						}
					},
					["1769668806491933"] = {
						["key"] = "1769668806491933",
						["type"] = "SetNpcPoseNode",
						["name"] = "设置Npc姿态",
						["pos"] = {
							["x"] = 1386,
							["y"] = 574
						},
						["propsData"] = {
							["NpcInfos"] = {
								{
									["NpcId"] = 81504,
									["NpcPose"] = "Seating"
								}
							}
						}
					},
					["17696688171341223"] = {
						["key"] = "17696688171341223",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1288,
							["y"] = 359.28205125279106
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 90260001,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = false,
							["ShowAutoPlayButton"] = false,
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
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 81504,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
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