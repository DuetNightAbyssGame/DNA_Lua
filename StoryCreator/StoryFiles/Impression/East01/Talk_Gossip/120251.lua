return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17637793725491912568",
			["startPort"] = "StoryStart",
			["endStory"] = "17637793725501912570",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17637793725501912570",
			["startPort"] = "Success",
			["endStory"] = "17637793725501912569",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17637793725491912568"] = {
			["isStoryNode"] = true,
			["key"] = "17637793725491912568",
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
		["17637793725501912569"] = {
			["isStoryNode"] = true,
			["key"] = "17637793725501912569",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1844.2857142857142,
				["y"] = 332.1428571428571
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17637793725501912570"] = {
			["isStoryNode"] = true,
			["key"] = "17637793725501912570",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1310.4887218045112,
				["y"] = 288.8345864661655
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
						["startQuest"] = "17637793725501912571",
						["startPort"] = "QuestStart",
						["endQuest"] = "17637793725501912574",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17637793725501912574",
						["startPort"] = "Out",
						["endQuest"] = "17637793725501912572",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17637793725501912571"] = {
						["key"] = "17637793725501912571",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 924,
							["y"] = 310
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637793725501912572"] = {
						["key"] = "17637793725501912572",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2095,
							["y"] = 335
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17637793725501912573"] = {
						["key"] = "17637793725501912573",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17637793725501912574"] = {
						["key"] = "17637793725501912574",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1528,
							["y"] = 132.30769230769232
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12025101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "Once",
							["UseProceduralCamera"] = true,
							["ProceduralCameraId"] = 1,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["bBubblePlayCDEnable"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 210113,
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