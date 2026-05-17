return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17696695641831",
			["startPort"] = "StoryStart",
			["endStory"] = "176966957149988",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176966957149988",
			["startPort"] = "Success",
			["endStory"] = "17696695641845",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17696695641831"] = {
			["isStoryNode"] = true,
			["key"] = "17696695641831",
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
		["17696695641845"] = {
			["isStoryNode"] = true,
			["key"] = "17696695641845",
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
		["176966957149988"] = {
			["isStoryNode"] = true,
			["key"] = "176966957149988",
			["type"] = "StoryNode",
			["name"] = "苏乙刻舟互动",
			["pos"] = {
				["x"] = 1520,
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
						["startQuest"] = "176966957149989",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769669595259573",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769669595259573",
						["startPort"] = "Out",
						["endQuest"] = "176966957149997",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["176966957149989"] = {
						["key"] = "176966957149989",
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
					["176966957149997"] = {
						["key"] = "176966957149997",
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
					["1769669571499105"] = {
						["key"] = "1769669571499105",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1769669595259573"] = {
						["key"] = "1769669595259573",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1508,
							["y"] = 286
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 90260601,
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