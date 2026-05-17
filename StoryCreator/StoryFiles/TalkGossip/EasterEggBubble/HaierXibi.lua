return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "175323995805313227503",
			["startPort"] = "Success",
			["endStory"] = "175323995805313227502",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "175323995805313227501",
			["startPort"] = "StoryStart",
			["endStory"] = "175323995805313227503",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["175323995805313227501"] = {
			["isStoryNode"] = true,
			["key"] = "175323995805313227501",
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
		["175323995805313227502"] = {
			["isStoryNode"] = true,
			["key"] = "175323995805313227502",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1492,
				["y"] = 306
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["175323995805313227503"] = {
			["isStoryNode"] = true,
			["key"] = "175323995805313227503",
			["type"] = "StoryNode",
			["name"] = "海尔法西比尔互动",
			["pos"] = {
				["x"] = 1126,
				["y"] = 308
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
						["startQuest"] = "175323995805313227504",
						["startPort"] = "QuestStart",
						["endQuest"] = "175323995805313227507",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175323995805313227507",
						["startPort"] = "Out",
						["endQuest"] = "175323995805313227505",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["175323995805313227504"] = {
						["key"] = "175323995805313227504",
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
					["175323995805313227505"] = {
						["key"] = "175323995805313227505",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1646,
							["y"] = 314
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["175323995805313227506"] = {
						["key"] = "175323995805313227506",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1610,
							["y"] = 554
						},
						["propsData"] = {}
					},
					["175323995805313227507"] = {
						["key"] = "175323995805313227507",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1232,
							["y"] = 292
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 90060601,
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