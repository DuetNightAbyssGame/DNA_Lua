return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "175324056172017110286",
			["startPort"] = "Success",
			["endStory"] = "175324056172017110285",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "175324056172017110284",
			["startPort"] = "StoryStart",
			["endStory"] = "175324056172017110286",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["175324056172017110284"] = {
			["isStoryNode"] = true,
			["key"] = "175324056172017110284",
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
		["175324056172017110285"] = {
			["isStoryNode"] = true,
			["key"] = "175324056172017110285",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1492,
				["y"] = 306
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["175324056172017110286"] = {
			["isStoryNode"] = true,
			["key"] = "175324056172017110286",
			["type"] = "StoryNode",
			["name"] = "兰迪西比尔互动",
			["pos"] = {
				["x"] = 1126,
				["y"] = 308
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
						["startQuest"] = "175324056172017110287",
						["startPort"] = "QuestStart",
						["endQuest"] = "175324056172017110290",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175324056172017110290",
						["startPort"] = "Out",
						["endQuest"] = "175324056172017110288",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["175324056172017110287"] = {
						["key"] = "175324056172017110287",
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
					["175324056172017110288"] = {
						["key"] = "175324056172017110288",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1646,
							["y"] = 314
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["175324056172017110289"] = {
						["key"] = "175324056172017110289",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1610,
							["y"] = 554
						},
						["propsData"] = {}
					},
					["175324056172017110290"] = {
						["key"] = "175324056172017110290",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1232,
							["y"] = 292
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 90080501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "Once",
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["bBubblePlayCDEnable"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
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