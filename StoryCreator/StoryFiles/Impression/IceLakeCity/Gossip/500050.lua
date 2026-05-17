return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1721630101480340950",
			["startPort"] = "StoryStart",
			["endStory"] = "1721630101480340952",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1721630101480340952",
			["startPort"] = "Success",
			["endStory"] = "1721630101480340951",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1721630101480340950"] = {
			["isStoryNode"] = true,
			["key"] = "1721630101480340950",
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
		["1721630101480340951"] = {
			["isStoryNode"] = true,
			["key"] = "1721630101480340951",
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
		["1721630101480340952"] = {
			["isStoryNode"] = true,
			["key"] = "1721630101480340952",
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
						["startQuest"] = "1721630101480340956",
						["startPort"] = "Out",
						["endQuest"] = "1721630101480340954",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1721630101480340953",
						["startPort"] = "QuestStart",
						["endQuest"] = "1721630101480340956",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1721630101480340953"] = {
						["key"] = "1721630101480340953",
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
					["1721630101480340954"] = {
						["key"] = "1721630101480340954",
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
					["1721630101480340955"] = {
						["key"] = "1721630101480340955",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1536,
							["y"] = 518
						},
						["propsData"] = {}
					},
					["1721630101480340956"] = {
						["key"] = "1721630101480340956",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1163.388888888889,
							["y"] = 298.8888888888889
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50005001,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "Once",
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["bBubblePlayCDEnable"] = true,
							["BubblePlayCD"] = 13,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700096,
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