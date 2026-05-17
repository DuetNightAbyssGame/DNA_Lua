return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177211055517949357359",
			["startPort"] = "StoryStart",
			["endStory"] = "177211055517949357361",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177211055517949357361",
			["startPort"] = "Success",
			["endStory"] = "177211055517949357360",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177211055517949357359"] = {
			["isStoryNode"] = true,
			["key"] = "177211055517949357359",
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
		["177211055517949357360"] = {
			["isStoryNode"] = true,
			["key"] = "177211055517949357360",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1528,
				["y"] = 304
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["177211055517949357361"] = {
			["isStoryNode"] = true,
			["key"] = "177211055517949357361",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1194,
				["y"] = 272
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
						["startQuest"] = "177211055517949357362",
						["startPort"] = "QuestStart",
						["endQuest"] = "177211055517949357365",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177211055517949357365",
						["startPort"] = "Out",
						["endQuest"] = "177211055517949357363",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177211055517949357362"] = {
						["key"] = "177211055517949357362",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1048.3333333333333,
							["y"] = 303.3333333333333
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177211055517949357363"] = {
						["key"] = "177211055517949357363",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1731.6666666666665,
							["y"] = 296.6666666666667
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177211055517949357364"] = {
						["key"] = "177211055517949357364",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["177211055517949357365"] = {
						["key"] = "177211055517949357365",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1408,
							["y"] = 282
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50107224,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "StayOnLast",
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["bBubblePlayCDEnable"] = true,
							["BubblePlayCD"] = 15,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701137,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
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