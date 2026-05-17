return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17727831851307876159",
			["startPort"] = "StoryStart",
			["endStory"] = "17727831851307876161",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17727831851307876161",
			["startPort"] = "Success",
			["endStory"] = "17727831851307876160",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17727831851307876159"] = {
			["isStoryNode"] = true,
			["key"] = "17727831851307876159",
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
		["17727831851307876160"] = {
			["isStoryNode"] = true,
			["key"] = "17727831851307876160",
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
		["17727831851307876161"] = {
			["isStoryNode"] = true,
			["key"] = "17727831851307876161",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1194,
				["y"] = 272
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
						["startQuest"] = "17727831851307876162",
						["startPort"] = "QuestStart",
						["endQuest"] = "17727831851307876165",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727831851307876165",
						["startPort"] = "Out",
						["endQuest"] = "17727831851307876163",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17727831851307876162"] = {
						["key"] = "17727831851307876162",
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
					["17727831851307876163"] = {
						["key"] = "17727831851307876163",
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
					["17727831851307876164"] = {
						["key"] = "17727831851307876164",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17727831851307876165"] = {
						["key"] = "17727831851307876165",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1408,
							["y"] = 282
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50107151,
							["FlowAssetPath"] = "",
							["TalkType"] = "Bubble",
							["BubblePlayType"] = "StayOnLast",
							["UseProceduralCamera"] = false,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 701246,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
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