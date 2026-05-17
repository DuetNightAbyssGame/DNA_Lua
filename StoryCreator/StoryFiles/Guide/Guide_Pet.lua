return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732783210529469277",
			["startPort"] = "StoryStart",
			["endStory"] = "1732783210529469279",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732783210529469279",
			["startPort"] = "Success",
			["endStory"] = "1732783210529469278",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732783210529469277"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210529469277",
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
		["1732783210529469278"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210529469278",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1518.1176470588232,
				["y"] = 292.9411764705883
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1732783210529469279"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210529469279",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1159.6425770308124,
				["y"] = 287.71421767087384
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
						["startQuest"] = "1732783210529469280",
						["startPort"] = "QuestStart",
						["endQuest"] = "17225822407962832",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17225822407962832",
						["startPort"] = "Out",
						["endQuest"] = "1732783210529469281",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17225822407962832"] = {
						["key"] = "17225822407962832",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 195.86080586080578,
							["y"] = 484.61684981684965
						},
						["propsData"] = {
							["GuideId"] = 20301
						}
					},
					["1732783210529469280"] = {
						["key"] = "1732783210529469280",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -236.23529411764733,
							["y"] = 482.1176470588236
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210529469281"] = {
						["key"] = "1732783210529469281",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 517.4901960784309,
							["y"] = 481.80392156862746
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210529469282"] = {
						["key"] = "1732783210529469282",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1190.5882352941173,
							["y"] = -279.76470588235304
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}