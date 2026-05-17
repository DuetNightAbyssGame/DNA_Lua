return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1700641873119149157",
			["startPort"] = "StoryStart",
			["endStory"] = "1700641875225149340",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1700641875225149340",
			["startPort"] = "Success",
			["endStory"] = "1700641873119149160",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1700641873119149157"] = {
			["isStoryNode"] = true,
			["key"] = "1700641873119149157",
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
		["1700641873119149160"] = {
			["isStoryNode"] = true,
			["key"] = "1700641873119149160",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1898.4210526315794,
				["y"] = 333.1578947368421
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1700641875225149340"] = {
			["isStoryNode"] = true,
			["key"] = "1700641875225149340",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1146.3312639356755,
				["y"] = 293.1618352027427
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
						["startQuest"] = "1700641875225149341",
						["startPort"] = "QuestStart",
						["endQuest"] = "1700641880098149881",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1700641880098149881",
						["startPort"] = "Out",
						["endQuest"] = "1700641875225149343",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1700641875225149341"] = {
						["key"] = "1700641875225149341",
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
					["1700641875225149343"] = {
						["key"] = "1700641875225149343",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2062.631578947369,
							["y"] = 344.2105263157895
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1700641875225149345"] = {
						["key"] = "1700641875225149345",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1700641880098149881"] = {
						["key"] = "1700641880098149881",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1223.1733691988331,
							["y"] = 316.8460457290584
						},
						["propsData"] = {
							["GuideId"] = 10
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}