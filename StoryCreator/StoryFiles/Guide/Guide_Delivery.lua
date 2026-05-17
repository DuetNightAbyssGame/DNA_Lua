return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "169961232336011234",
			["startPort"] = "StoryStart",
			["endStory"] = "169961232501211345",
			["endPort"] = "In"
		},
		{
			["startStory"] = "169961232501211345",
			["startPort"] = "Success",
			["endStory"] = "169961232336111237",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["169961232336011234"] = {
			["isStoryNode"] = true,
			["key"] = "169961232336011234",
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
		["169961232336111237"] = {
			["isStoryNode"] = true,
			["key"] = "169961232336111237",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1440,
				["y"] = 335
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["169961232501211345"] = {
			["isStoryNode"] = true,
			["key"] = "169961232501211345",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1092.1739130434783,
				["y"] = 293.9130434782609
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
						["startQuest"] = "169961232501211346",
						["startPort"] = "QuestStart",
						["endQuest"] = "169961233525712012",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "169961233525712012",
						["startPort"] = "Out",
						["endQuest"] = "169961232501211348",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["169961232501211346"] = {
						["key"] = "169961232501211346",
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
					["169961232501211348"] = {
						["key"] = "169961232501211348",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1560,
							["y"] = 320
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["169961232501211350"] = {
						["key"] = "169961232501211350",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["169961233525712012"] = {
						["key"] = "169961233525712012",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1170.0000000000002,
							["y"] = 303.3333333333333
						},
						["propsData"] = {
							["GuideId"] = 9
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}