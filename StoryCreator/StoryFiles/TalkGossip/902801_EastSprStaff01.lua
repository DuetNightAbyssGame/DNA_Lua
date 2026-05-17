return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "175041676525311883026",
			["startPort"] = "StoryStart",
			["endStory"] = "175041676684411883081",
			["endPort"] = "In"
		},
		{
			["startStory"] = "175041676684411883081",
			["startPort"] = "Success",
			["endStory"] = "175041676525311883029",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["175041676525311883026"] = {
			["isStoryNode"] = true,
			["key"] = "175041676525311883026",
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
		["175041676525311883029"] = {
			["isStoryNode"] = true,
			["key"] = "175041676525311883029",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1968,
				["y"] = 344
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["175041676684411883081"] = {
			["isStoryNode"] = true,
			["key"] = "175041676684411883081",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1470,
				["y"] = 298
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
						["startQuest"] = "175041676684411883082",
						["startPort"] = "QuestStart",
						["endQuest"] = "175041677721311883507",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175041677721311883507",
						["startPort"] = "Out",
						["endQuest"] = "175041676684411883085",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["175041676684411883082"] = {
						["key"] = "175041676684411883082",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1114,
							["y"] = 350
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["175041676684411883085"] = {
						["key"] = "175041676684411883085",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1962,
							["y"] = 384
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["175041676684411883088"] = {
						["key"] = "175041676684411883088",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["175041677721311883507"] = {
						["key"] = "175041677721311883507",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1578,
							["y"] = 344
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51101001,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "DelayLoop",
							["BubbleDelayLoopSeconds"] = 5,
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