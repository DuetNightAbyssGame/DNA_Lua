return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17358095326061",
			["startPort"] = "StoryStart",
			["endStory"] = "1735809587445232838",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1735809587445232838",
			["startPort"] = "Success",
			["endStory"] = "17358095326075",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17358095326061"] = {
			["isStoryNode"] = true,
			["key"] = "17358095326061",
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
		["17358095326075"] = {
			["isStoryNode"] = true,
			["key"] = "17358095326075",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1592,
				["y"] = 268
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1735809587445232838"] = {
			["isStoryNode"] = true,
			["key"] = "1735809587445232838",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1296,
				["y"] = 282
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
						["startQuest"] = "17400380466002320367",
						["startPort"] = "Out",
						["endQuest"] = "1735809587446232842",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1735809587445232839",
						["startPort"] = "QuestStart",
						["endQuest"] = "1739773689772301",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1739773689772301",
						["startPort"] = "Out",
						["endQuest"] = "17400380466002320367",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1735809587445232839"] = {
						["key"] = "1735809587445232839",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 800,
							["y"] = 316.25
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1735809587446232842"] = {
						["key"] = "1735809587446232842",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1877.5,
							["y"] = 328.25
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1735809587446232845"] = {
						["key"] = "1735809587446232845",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2006,
							["y"] = 464
						},
						["propsData"] = {}
					},
					["1735809696032233976"] = {
						["key"] = "1735809696032233976",
						["type"] = "UnlockDetectiveQuestionNode",
						["name"] = "开启推理问题",
						["pos"] = {
							["x"] = 1661.3679589860942,
							["y"] = 89.71252546080927
						},
						["propsData"] = {
							["QuestionIds"] = {
								1001,
								1002
							},
							["OpenToast"] = true
						}
					},
					["1735809699296234052"] = {
						["key"] = "1735809699296234052",
						["type"] = "UnlockDetectiveAnswerNode",
						["name"] = "开启推理线索",
						["pos"] = {
							["x"] = 1657.9879894133326,
							["y"] = 202.56563440373486
						},
						["propsData"] = {
							["AnswerIds"] = {
								100101,
								100201,
								100202
							}
						}
					},
					["1739773689772301"] = {
						["key"] = "1739773689772301",
						["type"] = "HasDetectiveAnswerNode",
						["name"] = "检测是否获取过推理线索",
						["pos"] = {
							["x"] = 1117.7415413533836,
							["y"] = 320.55952380952374
						},
						["propsData"] = {
							["AnswerIds"] = {
								100101,
								100201
							}
						}
					},
					["17400380466002320367"] = {
						["key"] = "17400380466002320367",
						["type"] = "HasDetectiveResultNode",
						["name"] = "检测是否获取过推理结果",
						["pos"] = {
							["x"] = 1425.3361528822054,
							["y"] = 321.1372180451128
						},
						["propsData"] = {
							["ResultIds"] = {
								10010101
							}
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}