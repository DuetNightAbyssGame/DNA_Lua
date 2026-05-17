return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17667342909271",
			["startPort"] = "StoryStart",
			["endStory"] = "176673429922784",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176673429922784",
			["startPort"] = "Success",
			["endStory"] = "17667342909275",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17667342909271"] = {
			["isStoryNode"] = true,
			["key"] = "17667342909271",
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
		["17667342909275"] = {
			["isStoryNode"] = true,
			["key"] = "17667342909275",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1808,
				["y"] = 318
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176673429922784"] = {
			["isStoryNode"] = true,
			["key"] = "176673429922784",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1278,
				["y"] = 302
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
						["startQuest"] = "176673429922785",
						["startPort"] = "QuestStart",
						["endQuest"] = "1766734307275419",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766734316299609",
						["startPort"] = "Out",
						["endQuest"] = "1766734348549782",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766734348549782",
						["startPort"] = "Out",
						["endQuest"] = "17667343872051272",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667343872051272",
						["startPort"] = "Out",
						["endQuest"] = "17667343993381418",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667343993381418",
						["startPort"] = "Out",
						["endQuest"] = "17667344375102427",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667344375102427",
						["startPort"] = "Out",
						["endQuest"] = "17667344546053004",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667344822384176",
						["startPort"] = "Out",
						["endQuest"] = "17667344822384177",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667344546053004",
						["startPort"] = "Out",
						["endQuest"] = "17667344822384176",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17667344925344518",
						["startPort"] = "Out",
						["endQuest"] = "176673429922793",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17667344822384177",
						["startPort"] = "Out",
						["endQuest"] = "17667344925344518",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766734307275419",
						["startPort"] = "Out",
						["endQuest"] = "1766734316299609",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766734307275419",
						["startPort"] = "Out",
						["endQuest"] = "17667386798883554527",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["176673429922785"] = {
						["key"] = "176673429922785",
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
					["176673429922793"] = {
						["key"] = "176673429922793",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4418.5,
							["y"] = 320
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766734299227101"] = {
						["key"] = "1766734299227101",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3872,
							["y"] = 781.5
						},
						["propsData"] = {}
					},
					["1766734307275419"] = {
						["key"] = "1766734307275419",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1185,
							["y"] = 280
						},
						["propsData"] = {
							["WaitTime"] = 0.3
						}
					},
					["1766734316299609"] = {
						["key"] = "1766734316299609",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto01",
						["pos"] = {
							["x"] = 1532,
							["y"] = 301
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Moveto01",
							["UnitId"] = 240102
						}
					},
					["1766734348549782"] = {
						["key"] = "1766734348549782",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 1791.5,
							["y"] = 289
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "Moveto01End"
						}
					},
					["17667343872051272"] = {
						["key"] = "17667343872051272",
						["type"] = "SendMessageNode",
						["name"] = "发送消息PlayAni01",
						["pos"] = {
							["x"] = 2212,
							["y"] = 292
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "PlayAni01",
							["UnitId"] = 200002
						}
					},
					["17667343993381418"] = {
						["key"] = "17667343993381418",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 2502,
							["y"] = 278.90909090909093
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "PlayAni01End"
						}
					},
					["17667344375102427"] = {
						["key"] = "17667344375102427",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Moveto01",
						["pos"] = {
							["x"] = 2913,
							["y"] = 295.81818181818187
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Moveto01",
							["UnitId"] = 200002
						}
					},
					["17667344546053004"] = {
						["key"] = "17667344546053004",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 3186,
							["y"] = 276.31818181818187
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "Moveto01End"
						}
					},
					["17667344822384176"] = {
						["key"] = "17667344822384176",
						["type"] = "SendMessageNode",
						["name"] = "发送消息Wait01",
						["pos"] = {
							["x"] = 3544.5,
							["y"] = 295.81818181818187
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Wait01",
							["UnitId"] = 200002
						}
					},
					["17667344822384177"] = {
						["key"] = "17667344822384177",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 3810,
							["y"] = 273.31818181818187
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "Wait01End"
						}
					},
					["17667344925344518"] = {
						["key"] = "17667344925344518",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 4135,
							["y"] = 298.81818181818187
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["17667386798883554527"] = {
						["key"] = "17667386798883554527",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1911.446322007063,
							["y"] = -144.72796747157355
						},
						["propsData"] = {
							["QuestRoleId"] = 1010101,
							["IsPlayFX"] = false
						}
					}
				},
				["commentData"] = {
					["17667344598703217"] = {
						["key"] = "17667344598703217",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 2867.5,
							["y"] = 174.31818181818187
						},
						["size"] = {
							["width"] = 570,
							["height"] = 352.5
						}
					},
					["17667344615823295"] = {
						["key"] = "17667344615823295",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 2132.5,
							["y"] = 166.81818181818187
						},
						["size"] = {
							["width"] = 607.5,
							["height"] = 369
						}
					},
					["17667344640613418"] = {
						["key"] = "17667344640613418",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1475.5,
							["y"] = 162.31818181818187
						},
						["size"] = {
							["width"] = 600,
							["height"] = 400
						}
					},
					["17667345000784818"] = {
						["key"] = "17667345000784818",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 3464.5,
							["y"] = 133.81818181818187
						},
						["size"] = {
							["width"] = 600,
							["height"] = 400
						}
					}
				}
			}
		}
	},
	["commentData"] = {}
}