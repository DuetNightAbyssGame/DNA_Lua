return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "175324134547026186859",
			["startPort"] = "Success",
			["endStory"] = "175324134547026186858",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "175324134547026186857",
			["startPort"] = "StoryStart",
			["endStory"] = "175324134547026186859",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["175324134547026186857"] = {
			["isStoryNode"] = true,
			["key"] = "175324134547026186857",
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
		["175324134547026186858"] = {
			["isStoryNode"] = true,
			["key"] = "175324134547026186858",
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
		["175324134547026186859"] = {
			["isStoryNode"] = true,
			["key"] = "175324134547026186859",
			["type"] = "StoryNode",
			["name"] = "松露玛尔洁互动",
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
						["startQuest"] = "175324134547026186860",
						["startPort"] = "QuestStart",
						["endQuest"] = "175324134547026186863",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175324134547026186863",
						["startPort"] = "Out",
						["endQuest"] = "175324134547026186861",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["175324134547026186860"] = {
						["key"] = "175324134547026186860",
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
					["175324134547026186861"] = {
						["key"] = "175324134547026186861",
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
					["175324134547026186862"] = {
						["key"] = "175324134547026186862",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1610,
							["y"] = 554
						},
						["propsData"] = {}
					},
					["175324134547026186863"] = {
						["key"] = "175324134547026186863",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1230,
							["y"] = 292
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 90120601,
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