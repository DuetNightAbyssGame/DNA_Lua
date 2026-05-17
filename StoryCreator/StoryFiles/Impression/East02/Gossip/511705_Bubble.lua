return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177303767827965849226",
			["startPort"] = "StoryStart",
			["endStory"] = "177303767827965849228",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177303767827965849228",
			["startPort"] = "Success",
			["endStory"] = "177303767827965849227",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177303767827965849226"] = {
			["isStoryNode"] = true,
			["key"] = "177303767827965849226",
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
		["177303767827965849227"] = {
			["isStoryNode"] = true,
			["key"] = "177303767827965849227",
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
		["177303767827965849228"] = {
			["isStoryNode"] = true,
			["key"] = "177303767827965849228",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1196,
				["y"] = 274
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
						["startQuest"] = "177303767827965849229",
						["startPort"] = "QuestStart",
						["endQuest"] = "177303767827965849232",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177303767827965849232",
						["startPort"] = "Out",
						["endQuest"] = "177303767827965849230",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177303767827965849229"] = {
						["key"] = "177303767827965849229",
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
					["177303767827965849230"] = {
						["key"] = "177303767827965849230",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1731.6666666666665,
							["y"] = 296.6666666666667
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177303767827965849231"] = {
						["key"] = "177303767827965849231",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["177303767827965849232"] = {
						["key"] = "177303767827965849232",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1388,
							["y"] = 316
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50107295,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "StayOnLast",
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["bBubblePlayCDEnable"] = true,
							["BubblePlayCD"] = 10,
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