return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17642997126901",
			["startPort"] = "StoryStart",
			["endStory"] = "1764299720755144",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1764299720755144",
			["startPort"] = "Success",
			["endStory"] = "17642997126915",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17642997126901"] = {
			["isStoryNode"] = true,
			["key"] = "17642997126901",
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
		["17642997126915"] = {
			["isStoryNode"] = true,
			["key"] = "17642997126915",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1688,
				["y"] = 296
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1764299720755144"] = {
			["isStoryNode"] = true,
			["key"] = "1764299720755144",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1224,
				["y"] = 292
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
						["startQuest"] = "1764299720755145",
						["startPort"] = "QuestStart",
						["endQuest"] = "1764299736323681",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764299736323681",
						["startPort"] = "Out",
						["endQuest"] = "1764299720755152",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1764299720755145"] = {
						["key"] = "1764299720755145",
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
					["1764299720755152"] = {
						["key"] = "1764299720755152",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1470,
							["y"] = 302
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1764299720755159"] = {
						["key"] = "1764299720755159",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1764299736323681"] = {
						["key"] = "1764299736323681",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1126,
							["y"] = 298
						},
						["propsData"] = {
							["GuideId"] = 110
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}