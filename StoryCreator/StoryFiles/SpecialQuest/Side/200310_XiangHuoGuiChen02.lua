return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17675165445951",
			["startPort"] = "StoryStart",
			["endStory"] = "176751654767288",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176751654767288",
			["startPort"] = "Success",
			["endStory"] = "17675165445965",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17675165445951"] = {
			["isStoryNode"] = true,
			["key"] = "17675165445951",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 828,
				["y"] = 298
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
		["17675165445965"] = {
			["isStoryNode"] = true,
			["key"] = "17675165445965",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1664,
				["y"] = 322
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176751654767288"] = {
			["isStoryNode"] = true,
			["key"] = "176751654767288",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1222,
				["y"] = 288
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200310_5_1",
				["QuestDeatil"] = "Content_200310_5_1",
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Point_20031002",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "176751654767293",
						["startPort"] = "QuestStart",
						["endQuest"] = "176751654767296",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176751654767296",
						["startPort"] = "Out",
						["endQuest"] = "176751654767297",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176751654767297",
						["startPort"] = "Out",
						["endQuest"] = "176751654767298",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176751654767293",
						["startPort"] = "QuestStart",
						["endQuest"] = "176751654767299",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176751654767299",
						["startPort"] = "Out",
						["endQuest"] = "1767516547672100",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767516547672100",
						["startPort"] = "Out",
						["endQuest"] = "176751654767295",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "176751654767298",
						["startPort"] = "Out",
						["endQuest"] = "1767755562576392",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["176751654767293"] = {
						["key"] = "176751654767293",
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
					["176751654767294"] = {
						["key"] = "176751654767294",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2448.5714285714284,
							["y"] = 254.85714285714286
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["176751654767295"] = {
						["key"] = "176751654767295",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1808.857142857143,
							["y"] = 536.2857142857143
						},
						["propsData"] = {}
					},
					["176751654767296"] = {
						["key"] = "176751654767296",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1147.7669172932328,
							["y"] = 304.5112781954887
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PlaiQuest02Start",
							["UnitId"] = -1
						}
					},
					["176751654767297"] = {
						["key"] = "176751654767297",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1453.1637426900584,
							["y"] = 275.9398496240601
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 30,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Point_20031001"
						}
					},
					["176751654767298"] = {
						["key"] = "176751654767298",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1754.5923141186297,
							["y"] = 291.6541353383459
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PlaiQuest02End",
							["UnitId"] = -1
						}
					},
					["176751654767299"] = {
						["key"] = "176751654767299",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1147.766917293233,
							["y"] = 494.5112781954888
						},
						["propsData"] = {}
					},
					["1767516547672100"] = {
						["key"] = "1767516547672100",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1452.0526315789473,
							["y"] = 523.0827067669173
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PlaiQuest02End",
							["UnitId"] = -1
						}
					},
					["1767755562576392"] = {
						["key"] = "1767755562576392",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2090,
							["y"] = 278
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