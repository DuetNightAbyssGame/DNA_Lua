return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17722628873546016822",
			["startPort"] = "StoryStart",
			["endStory"] = "17722628873546016824",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17722628873546016824",
			["startPort"] = "Success",
			["endStory"] = "17722628873546016823",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17722628873546016822"] = {
			["isStoryNode"] = true,
			["key"] = "17722628873546016822",
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
		["17722628873546016823"] = {
			["isStoryNode"] = true,
			["key"] = "17722628873546016823",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1528,
				["y"] = 304
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17722628873546016824"] = {
			["isStoryNode"] = true,
			["key"] = "17722628873546016824",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1196,
				["y"] = 276
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
						["startQuest"] = "17722628873546016825",
						["startPort"] = "QuestStart",
						["endQuest"] = "17722628555095525078",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17722628555095525078",
						["startPort"] = "Out",
						["endQuest"] = "17722628873546016826",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17722628555095525078"] = {
						["key"] = "17722628555095525078",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1416,
							["y"] = 232.9243498260762
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50107205,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "StayOnLast",
							["UseProceduralCamera"] = true,
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
							["TalkActors"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17722628873546016825"] = {
						["key"] = "17722628873546016825",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1048.3333333333333,
							["y"] = 303.3333333333333
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17722628873546016826"] = {
						["key"] = "17722628873546016826",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1731.6666666666665,
							["y"] = 298.6666666666667
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17722628873546016827"] = {
						["key"] = "17722628873546016827",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}