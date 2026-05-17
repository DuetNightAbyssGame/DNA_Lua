return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732783210608494152",
			["startPort"] = "StoryStart",
			["endStory"] = "1732783210608494151",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732783210608494151",
			["startPort"] = "Success",
			["endStory"] = "1732783210608494153",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732783210608494151"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210608494151",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1119.7088122605362,
				["y"] = 289.34482758620686
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
						["startQuest"] = "1732783210608494157",
						["startPort"] = "Out",
						["endQuest"] = "1732783210608494155",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1732783210608494154",
						["startPort"] = "QuestStart",
						["endQuest"] = "1732783210608494157",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1732783210608494154"] = {
						["key"] = "1732783210608494154",
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
					["1732783210608494155"] = {
						["key"] = "1732783210608494155",
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
					["1732783210608494156"] = {
						["key"] = "1732783210608494156",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1536,
							["y"] = 518
						},
						["propsData"] = {}
					},
					["1732783210608494157"] = {
						["key"] = "1732783210608494157",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1163.388888888889,
							["y"] = 298.8888888888889
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50005301,
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
									["TalkActorId"] = 700147,
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
		},
		["1732783210608494152"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210608494152",
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
		["1732783210608494153"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210608494153",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1494.6666666666665,
				["y"] = 313.1111111111111
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