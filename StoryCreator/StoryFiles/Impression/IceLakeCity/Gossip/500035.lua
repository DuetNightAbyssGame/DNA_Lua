return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1708496878083214043",
			["startPort"] = "StoryStart",
			["endStory"] = "1708496878083214045",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1708496878083214045",
			["startPort"] = "Success",
			["endStory"] = "1708496878083214044",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1708496878083214043"] = {
			["isStoryNode"] = true,
			["key"] = "1708496878083214043",
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
		["1708496878083214044"] = {
			["isStoryNode"] = true,
			["key"] = "1708496878083214044",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1778,
				["y"] = 312
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1708496878083214045"] = {
			["isStoryNode"] = true,
			["key"] = "1708496878083214045",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1218,
				["y"] = 316
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
						["startQuest"] = "1708496878083214049",
						["startPort"] = "Out",
						["endQuest"] = "1708496878083214047",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1708496878083214046",
						["startPort"] = "QuestStart",
						["endQuest"] = "1708496878083214049",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1708496878083214046"] = {
						["key"] = "1708496878083214046",
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
					["1708496878083214047"] = {
						["key"] = "1708496878083214047",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1708496878083214048"] = {
						["key"] = "1708496878083214048",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1708496878083214049"] = {
						["key"] = "1708496878083214049",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1404.5,
							["y"] = 290
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 50003501,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700077,
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