return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1704175978851177718",
			["startPort"] = "StoryStart",
			["endStory"] = "169823376500632444",
			["endPort"] = "In"
		},
		{
			["startStory"] = "169823376500632444",
			["startPort"] = "Success",
			["endStory"] = "1704175978851177719",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "169823376500632444",
			["startPort"] = "Fail",
			["endStory"] = "1704175978851177719",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["169823376500632444"] = {
			["isStoryNode"] = true,
			["key"] = "169823376500632444",
			["type"] = "StoryNode",
			["name"] = "印象系统节点",
			["pos"] = {
				["x"] = 1213.0076996913883,
				["y"] = 287.8557172199182
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
						["startQuest"] = "1704175978851177720",
						["startPort"] = "QuestStart",
						["endQuest"] = "169823382680035289",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "169823382680035289",
						["startPort"] = "Out",
						["endQuest"] = "1704175978851177721",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "169823382680035289",
						["startPort"] = "Fail",
						["endQuest"] = "1704175978851177722",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["169823382680035289"] = {
						["key"] = "169823382680035289",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1119.7319421156308,
							["y"] = 286.88067265663824
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51001401,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
							["BlendInTime"] = 0.5,
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
									["TalkActorId"] = 700083,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700084,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700085,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "plus",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["PlusOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1704175978851177720"] = {
						["key"] = "1704175978851177720",
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
					["1704175978851177721"] = {
						["key"] = "1704175978851177721",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1470.5142857142857,
							["y"] = 144.68571428571425
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1704175978851177722"] = {
						["key"] = "1704175978851177722",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1474.4428571428568,
							["y"] = 425.45714285714286
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		},
		["1704175978851177718"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978851177718",
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
		["1704175978851177719"] = {
			["isStoryNode"] = true,
			["key"] = "1704175978851177719",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1661.764705882353,
				["y"] = 294.70588235294116
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}