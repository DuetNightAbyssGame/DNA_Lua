return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "173770534008314203340",
			["startPort"] = "StoryStart",
			["endStory"] = "173770534008314203342",
			["endPort"] = "In"
		},
		{
			["startStory"] = "173770534008314203342",
			["startPort"] = "Success",
			["endStory"] = "173770534008314203341",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["173770534008314203340"] = {
			["isStoryNode"] = true,
			["key"] = "173770534008314203340",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 1458,
				["y"] = 322
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
		["173770534008314203341"] = {
			["isStoryNode"] = true,
			["key"] = "173770534008314203341",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2076.086956521739,
				["y"] = 314.3478260869565
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["173770534008314203342"] = {
			["isStoryNode"] = true,
			["key"] = "173770534008314203342",
			["type"] = "StoryNode",
			["name"] = "Saiqi放置",
			["pos"] = {
				["x"] = 1757.0434782608693,
				["y"] = 309.5652173913043
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
						["startQuest"] = "173770534008314203343",
						["startPort"] = "QuestStart",
						["endQuest"] = "173770534008314203346",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173770534008314203346",
						["startPort"] = "Out",
						["endQuest"] = "173770534008314203344",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["173770534008314203343"] = {
						["key"] = "173770534008314203343",
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
					["173770534008314203344"] = {
						["key"] = "173770534008314203344",
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
					["173770534008314203345"] = {
						["key"] = "173770534008314203345",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["173770534008314203346"] = {
						["key"] = "173770534008314203346",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1105.6363636363635,
							["y"] = 287.909090909091
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 90100000,
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