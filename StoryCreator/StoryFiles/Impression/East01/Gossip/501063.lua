return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17636263685462457315",
			["startPort"] = "StoryStart",
			["endStory"] = "17636263685462457317",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17636263685462457317",
			["startPort"] = "Success",
			["endStory"] = "17636263685462457316",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17636263685462457315"] = {
			["isStoryNode"] = true,
			["key"] = "17636263685462457315",
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
		["17636263685462457316"] = {
			["isStoryNode"] = true,
			["key"] = "17636263685462457316",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1700,
				["y"] = 378
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17636263685462457317"] = {
			["isStoryNode"] = true,
			["key"] = "17636263685462457317",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1186,
				["y"] = 342
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
						["startQuest"] = "17636263685462457318",
						["startPort"] = "QuestStart",
						["endQuest"] = "17636263685462457321",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17636263685462457321",
						["startPort"] = "Out",
						["endQuest"] = "17636263685462457319",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17636263685462457318"] = {
						["key"] = "17636263685462457318",
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
					["17636263685462457319"] = {
						["key"] = "17636263685462457319",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1834.6172248803828,
							["y"] = 298.13397129186603
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17636263685462457320"] = {
						["key"] = "17636263685462457320",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17636263685462457321"] = {
						["key"] = "17636263685462457321",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1225.7392344497607,
							["y"] = 281.4330143540669
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50106301,
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