return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17443521946316013626",
			["startPort"] = "StoryStart",
			["endStory"] = "17443521946316013628",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17443521946316013628",
			["startPort"] = "Success",
			["endStory"] = "17443521946316013627",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17443521946316013626"] = {
			["isStoryNode"] = true,
			["key"] = "17443521946316013626",
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
		["17443521946316013627"] = {
			["isStoryNode"] = true,
			["key"] = "17443521946316013627",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1405.6521739130435,
				["y"] = 289.5652173913043
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17443521946316013628"] = {
			["isStoryNode"] = true,
			["key"] = "17443521946316013628",
			["type"] = "StoryNode",
			["name"] = "暴怒放置",
			["pos"] = {
				["x"] = 1091.6521739130435,
				["y"] = 287.7391304347827
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
						["startQuest"] = "17443521946316013629",
						["startPort"] = "QuestStart",
						["endQuest"] = "17443521946316013632",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17443521946316013632",
						["startPort"] = "Out",
						["endQuest"] = "17443521946316013630",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17443521946316013629"] = {
						["key"] = "17443521946316013629",
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
					["17443521946316013630"] = {
						["key"] = "17443521946316013630",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1431.1818181818182,
							["y"] = 295.45454545454544
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17443521946316013631"] = {
						["key"] = "17443521946316013631",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17443521946316013632"] = {
						["key"] = "17443521946316013632",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1104.2727272727273,
							["y"] = 286.5454545454546
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 90250000,
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