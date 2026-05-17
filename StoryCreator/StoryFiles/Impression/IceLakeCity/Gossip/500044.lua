return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1721630101436340530",
			["startPort"] = "StoryStart",
			["endStory"] = "1721630101436340532",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1721630101436340532",
			["startPort"] = "Success",
			["endStory"] = "1721630101436340531",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1721630101436340530"] = {
			["isStoryNode"] = true,
			["key"] = "1721630101436340530",
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
		["1721630101436340531"] = {
			["isStoryNode"] = true,
			["key"] = "1721630101436340531",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1778,
				["y"] = 312
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1721630101436340532"] = {
			["isStoryNode"] = true,
			["key"] = "1721630101436340532",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1218,
				["y"] = 316
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
						["startQuest"] = "1721630101436340536",
						["startPort"] = "Out",
						["endQuest"] = "1721630101436340534",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1721630101436340533",
						["startPort"] = "QuestStart",
						["endQuest"] = "1721630101436340536",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1721630101436340533"] = {
						["key"] = "1721630101436340533",
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
					["1721630101436340534"] = {
						["key"] = "1721630101436340534",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1644,
							["y"] = 328
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1721630101436340535"] = {
						["key"] = "1721630101436340535",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1536,
							["y"] = 518
						},
						["propsData"] = {}
					},
					["1721630101436340536"] = {
						["key"] = "1721630101436340536",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1163.388888888889,
							["y"] = 298.8888888888889
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50004401,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "Once",
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
									["TalkActorId"] = 700113,
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