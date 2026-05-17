return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "171851536831211576352",
			["startPort"] = "StoryStart",
			["endStory"] = "171851536831211576354",
			["endPort"] = "In"
		},
		{
			["startStory"] = "171851536831211576354",
			["startPort"] = "Success",
			["endStory"] = "171851536831211576353",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["171851536831211576352"] = {
			["isStoryNode"] = true,
			["key"] = "171851536831211576352",
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
		["171851536831211576353"] = {
			["isStoryNode"] = true,
			["key"] = "171851536831211576353",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1508.235294117647,
				["y"] = 312.35294117647055
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["171851536831211576354"] = {
			["isStoryNode"] = true,
			["key"] = "171851536831211576354",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1133.140730225936,
				["y"] = 297.6286915119693
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
						["startQuest"] = "171851536831211576355",
						["startPort"] = "QuestStart",
						["endQuest"] = "171851536831211576358",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "171851536831211576358",
						["startPort"] = "Out",
						["endQuest"] = "1720939786547389",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1720939786547389",
						["startPort"] = "Out",
						["endQuest"] = "171851536831211576356",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["171851536831211576355"] = {
						["key"] = "171851536831211576355",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 456.66666666666663,
							["y"] = 314.44444444444446
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851536831211576356"] = {
						["key"] = "171851536831211576356",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1601.2560386473428,
							["y"] = 311.1111111111111
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["171851536831211576357"] = {
						["key"] = "171851536831211576357",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["171851536831211576358"] = {
						["key"] = "171851536831211576358",
						["type"] = "ShowGuideToastNode",
						["name"] = "Toast显示/隐藏信息",
						["pos"] = {
							["x"] = 838.8276029918235,
							["y"] = 321.5227403595789
						},
						["propsData"] = {
							["ShowEnable"] = false,
							["MessageId"] = 301401,
							["MessageNote"] = "打开训练菜单",
							["LastTime"] = -1,
							["Style"] = "Normal"
						}
					},
					["1720939786547389"] = {
						["key"] = "1720939786547389",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1196.9166666666667,
							["y"] = 311.3813209494324
						},
						["propsData"] = {
							["GuideId"] = 34
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}