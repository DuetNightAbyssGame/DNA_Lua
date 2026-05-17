return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17696722088521",
			["startPort"] = "StoryStart",
			["endStory"] = "1769672217238115",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1769672217238115",
			["startPort"] = "Success",
			["endStory"] = "17696722088535",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17696722088521"] = {
			["isStoryNode"] = true,
			["key"] = "17696722088521",
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
		["17696722088535"] = {
			["isStoryNode"] = true,
			["key"] = "17696722088535",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2800,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1769672217238115"] = {
			["isStoryNode"] = true,
			["key"] = "1769672217238115",
			["type"] = "StoryNode",
			["name"] = "卡米拉止流互动",
			["pos"] = {
				["x"] = 1486,
				["y"] = 320
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
						["startQuest"] = "1769672217238116",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769672257102599",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769672257102599",
						["startPort"] = "Out",
						["endQuest"] = "1769672217238124",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1769672217238116"] = {
						["key"] = "1769672217238116",
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
					["1769672217238124"] = {
						["key"] = "1769672217238124",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1704,
							["y"] = 352
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769672217238132"] = {
						["key"] = "1769672217238132",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1769672257102599"] = {
						["key"] = "1769672257102599",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1312,
							["y"] = 308
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 90270701,
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