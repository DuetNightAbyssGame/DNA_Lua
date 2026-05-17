return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17582901223992913763",
			["startPort"] = "StoryStart",
			["endStory"] = "17582901267342913894",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17582901267342913894",
			["startPort"] = "Success",
			["endStory"] = "17582901223992913766",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17582901223992913763"] = {
			["isStoryNode"] = true,
			["key"] = "17582901223992913763",
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
		["17582901223992913766"] = {
			["isStoryNode"] = true,
			["key"] = "17582901223992913766",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2430,
				["y"] = 320
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17582901267342913894"] = {
			["isStoryNode"] = true,
			["key"] = "17582901267342913894",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1652,
				["y"] = 368
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
						["startQuest"] = "17582901396542914199",
						["startPort"] = "Out",
						["endQuest"] = "17582901267342913898",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17582901267342913895",
						["startPort"] = "QuestStart",
						["endQuest"] = "17582901396542914199",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17582901267342913895"] = {
						["key"] = "17582901267342913895",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1247.6923076923076,
							["y"] = 353.0769230769231
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17582901267342913898"] = {
						["key"] = "17582901267342913898",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1990,
							["y"] = 362.1428571428571
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17582901267342913901"] = {
						["key"] = "17582901267342913901",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17582901396542914199"] = {
						["key"] = "17582901396542914199",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1648,
							["y"] = 370
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51101001,
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