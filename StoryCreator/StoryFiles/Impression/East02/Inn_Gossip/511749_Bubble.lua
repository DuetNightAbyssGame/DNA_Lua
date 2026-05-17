return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1773065293933108480594",
			["startPort"] = "StoryStart",
			["endStory"] = "1773065293933108480596",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1773065293933108480596",
			["startPort"] = "Success",
			["endStory"] = "1773065293933108480595",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1773065293933108480594"] = {
			["isStoryNode"] = true,
			["key"] = "1773065293933108480594",
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
		["1773065293933108480595"] = {
			["isStoryNode"] = true,
			["key"] = "1773065293933108480595",
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
		["1773065293933108480596"] = {
			["isStoryNode"] = true,
			["key"] = "1773065293933108480596",
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
						["startQuest"] = "1773065293933108480597",
						["startPort"] = "QuestStart",
						["endQuest"] = "1773065293933108480600",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1773065293933108480600",
						["startPort"] = "Out",
						["endQuest"] = "1773065293933108480598",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1773065293933108480597"] = {
						["key"] = "1773065293933108480597",
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
					["1773065293933108480598"] = {
						["key"] = "1773065293933108480598",
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
					["1773065293933108480599"] = {
						["key"] = "1773065293933108480599",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1773065293933108480600"] = {
						["key"] = "1773065293933108480600",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1386,
							["y"] = 316
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50107321,
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