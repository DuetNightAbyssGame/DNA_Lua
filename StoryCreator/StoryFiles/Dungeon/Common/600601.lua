return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "177329988576116191",
			["startPort"] = "StoryStart",
			["endStory"] = "177329989012716240",
			["endPort"] = "In"
		},
		{
			["startStory"] = "177329989012716240",
			["startPort"] = "Success",
			["endStory"] = "177329988576116194",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["177329988576116191"] = {
			["isStoryNode"] = true,
			["key"] = "177329988576116191",
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
		["177329988576116194"] = {
			["isStoryNode"] = true,
			["key"] = "177329988576116194",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2158,
				["y"] = 354
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["177329989012716240"] = {
			["isStoryNode"] = true,
			["key"] = "177329989012716240",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1532,
				["y"] = 322
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
						["startQuest"] = "177329989012716241",
						["startPort"] = "QuestStart",
						["endQuest"] = "177329989798816494",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177329989798816494",
						["startPort"] = "Out",
						["endQuest"] = "177329989012716244",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["177329989012716241"] = {
						["key"] = "177329989012716241",
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
					["177329989012716244"] = {
						["key"] = "177329989012716244",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2226,
							["y"] = 392
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["177329989012716247"] = {
						["key"] = "177329989012716247",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["177329989798816494"] = {
						["key"] = "177329989798816494",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1450,
							["y"] = 330
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 60060101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
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