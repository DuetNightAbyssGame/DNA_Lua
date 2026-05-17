return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1773113272808121080616",
			["startPort"] = "StoryStart",
			["endStory"] = "1773113272808121080618",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1773113272808121080618",
			["startPort"] = "Success",
			["endStory"] = "1773113272808121080617",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1773113272808121080616"] = {
			["isStoryNode"] = true,
			["key"] = "1773113272808121080616",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1130,
				["y"] = 358
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
		["1773113272808121080617"] = {
			["isStoryNode"] = true,
			["key"] = "1773113272808121080617",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1714,
				["y"] = 346
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1773113272808121080618"] = {
			["isStoryNode"] = true,
			["key"] = "1773113272808121080618",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1436,
				["y"] = 328
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
						["startQuest"] = "1773113272808121080619",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773113272808121080622",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773113272808121080622",
						["startPort"] = "Out",
						["endQuest"] = "1773113272808121080620",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1773113272808121080619"] = {
						["key"] = "1773113272808121080619",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1540,
							["y"] = 384
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1773113272808121080620"] = {
						["key"] = "1773113272808121080620",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2348,
							["y"] = 370
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1773113272808121080621"] = {
						["key"] = "1773113272808121080621",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1773113272808121080622"] = {
						["key"] = "1773113272808121080622",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1926,
							["y"] = 370
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50107298,
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